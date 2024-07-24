local Config = require("config")
local zones = require("utils.zones")

local rooms = {}

RegisterServerEvent("valhalla:createRoom")
AddEventHandler("valhalla:createRoom", function(mapName)
  if not Config.mapas[mapName] then
    mapName = "praça"
  end

  local newRoom = createRoom(mapName)
  TriggerClientEvent("valhalla:roomCreated", source, newRoom)
end)

RegisterServerEvent("valhalla:joinRoom")
AddEventHandler("valhalla:joinRoom", function(roomID)
  local playerId = source
  local room = getRoom(roomID)

  if room then
    -- verifica se a sala está cheia de jogadores e envia um evento para o cliente
    if #room.players >= room.maxPlayers then
      TriggerClientEvent("valhalla:roomFull", playerId)
      return
    end

    -- Adiciona o jogador à sala
    table.insert(room.players, playerId)
    room.scores[playerId] = 0
    room.kills[playerId] = 0

    -- Adiciona o jogador à equipe com menos jogadores
    if room.teams.attackers < room.teams.defenders then
      table.insert(room.teams.attackers, playerId)
      room.alive.attackers = room.alive.attackers + 1
    else
      table.insert(room.teams.defenders, playerId)
      room.alive.defenders = room.alive.defenders + 1
    end
    -- seta o bucket de roteamento do jogador para o bucket da sala
    SetPlayerRoutingBucket(playerId, room.routingBucket)
    TriggerClientEvent("valhalla:joinedRoom", playerId, room)
  else
    TriggerClientEvent("valhalla:roomNotFound", playerId)
  end
end)

RegisterServerEvent("valhalla:updateScore")
AddEventHandler("valhalla:updateScore", function(roomID, playerID, score)
  local room = getRoom(roomID)
  -- Verifica se a sala existe e se o jogador está na sala
  if room and room.scores[playerID] then
    -- Atualiza a pontuação do jogador
    room.scores[playerId] = score
    -- Envia um evento para todos os jogadores na sala
    for _, player in ipairs(room.players) do
      TriggerClientEvent('scoreUpdated', player, roomId, playerId, score)
    end
  end
end)

RegisterServerEvent("valhalla:playerKilled")
AddEventHandler("valhalla:playerKilled", function(roomID, killerId, victimId)
  local room = getRoom(roomID)

  -- verifica se a sala existe
  if not room then return end

  -- verifica se o jogador tem algum abate e soma, se não tiver inicializa com 1
  if room.kills[killerId] then
    room.kills[killerId] = room.kills[killerId] + 1
  else
    room.kills[killerId] = 1
  end

  -- verifica se o jogador morto está na equipe dos atacantes ou defensores e atualiza o contador de jogadores vivos
  if isPlayerInTeam(victimId, room.teams.attackers) then
    room.alive.attackers = room.alive.attackers - 1
  elseif isPlayerInTeam(victimId, room.teams.defenders) then
    room.alive.defenders = room.alive.defenders - 1
  end

  -- verifica se todos os jogadores de uma equipe estão mortos
  local winningTeam = nil
  if room.alive.attackers == 0 then
    winningTeam = "defenders"
  elseif room.alive.defenders == 0 then
    winningTeam = "attackers"
  end

  if winningTeam then
    -- atualiza o status da sala
    room.status = "roundOver"
    room.round = room.round + 1

    -- envia um evento para todos os jogadores na sala
    for _, player in ipairs(room.players) do
      TriggerClientEvent('roundOver', player, roomID, winningTeam)
    end
  end

  -- verifica se o jogo acabou (mover para o roundover)
  if room.round >= room.maxRounds then
    room.status = "gameOver"
    -- envia um evento para todos os jogadores na sala
    for _, player in ipairs(room.players) do
      TriggerClientEvent('gameOver', player, roomID)
    end
  end

  -- envia um evento para todos os jogadores na sala notificando-os sobre o jogador morto
  for _, player in ipairs(room.players) do
    TriggerClientEvent('playerKilledNotification', player, killerId, victimId)
  end
end)

RegisterServerEvent("valhalla:roundOver")
AddEventHandler("valhalla:roundOver", function(roomID)
  local room = getRoom(roomID)

  if room then
    -- todo: verificar se o jogo acabou e enviar um evento para todos os jogadores na sala
  end
end)

RegisterServerEvent("valhalla:startGame")
AddEventHandler("valhalla:startGame", function(roomID)
  local room = getRoom(roomID)

  if room then
    if #room.players >= 2 then
      room.status = "in_progress"
      room.round = 1

      -- Teleporta todos os jogadores para seus pontos de spawn de atacantes
      for _, player in ipairs(room.teams.attackers) do
        TriggerClientEvent('teleportPlayer', player, roomID, room.spawnPoints.attackers)
      end

      -- Teleporta todos os jogadores para seus pontos de spawn de defensores
      for _, player in ipairs(room.teams.defenders) do
        TriggerClientEvent('teleportPlayer', player, roomID, room.spawnPoints.defenders)
      end

      -- Envia um evento para todos os jogadores na sala notificando-os de que o jogo começou
      for _, player in ipairs(room.players) do
        TriggerClientEvent('gameStarted', player, roomID)
      end
    else
      -- Envia um evento para todos os jogadores na sala notificando-os de que não tem players suficientes
      for _, player in ipairs(room.players) do
        TriggerClientEvent('notEnoughPlayers', player)
      end
    end
  end
end)



function getRoom(id)
  return rooms[id]
end

---@class Room
---@field id number
---@field players table
---@field status string
---@field scores table
---@field routingBucket number
---@field teams table
---@field round number
---@field maxRounds number
---@field maxPlayers number
---@field kills table
---@field alive table
---@field mapName string
---@field spawnPoints table
function createRoom(mapName)
  local roomID = #rooms + 1
  local mapConfig = Config.mapas[mapName]
  local room = {
    id = roomID,
    players = {},
    status = "waiting",
    scores = {},
    routingBucket = roomID,
    teams = { attackers = {}, defenders = {} },
    round = 0,
    maxRounds = 10,
    maxPlayers = mapConfig.maxPlayers,
    kills = {},
    alive = { attackers = 0, defenders = 0 },
    mapName = mapName,
    spawnPoints = mapConfig.spawn
  }

  table.insert(rooms, room)
  return room
end

function isPlayerInTeam(playerId, team)
  for _, id in ipairs(team) do
    if id == playerId then
      return true
    end
  end
  return false
end
