local Config = require("config")

local room = nil
local inGame = false

RegisterCommand("criarsala", function(source, args, rawCommand)
  local mapName = args[1]
  if not mapName then
    TriggerEvent("chat:addMessage", {
      color = { 255, 0, 0 },
      multiline = true,
      args = { "[Valhalla]", "Você precisa informar o nome do mapa para criar uma sala." }
    })

    TriggerEvent("chat:addMessage", {
      color = { 255, 0, 0 },
      multiline = true,
      args = { "[Valhalla]", "Mapas disponíveis:" }
    })
    for _, map in ipairs(Config.mapas) do
      TriggerEvent("chat:addMessage", {
        color = { 255, 0, 0 },
        multiline = true,
        args = { "", map }
      })
    end
    return
  end
  TriggerServerEvent("valhalla:createRoom", mapName)
end, false)

RegisterCommand("entrarsala", function(source, args, rawCommand)
  local roomID = args[1]
  if not roomID then
    TriggerEvent("chat:addMessage", {
      color = { 255, 0, 0 },
      multiline = true,
      args = { "[Valhalla]", "Você precisa informar o ID da sala para entrar." }
    })
    return
  end
  TriggerServerEvent("valhalla:joinRoom", roomID)
end, false)

-- Evento disparado quando o jogador cria uma sala
RegisterNetEvent("valhalla:roomCreated")
AddEventHandler("valhalla:roomCreated", function(newRoom)
  TriggerEvent("chat:addMessage", {
    color = { 255, 0, 0 },
    multiline = true,
    args = {
      "[Valhalla]", "Sala criada com sucesso, id: " .. newRoom.id,
      "Mapa: " .. newRoom.mapName,
      "Para entrar na sala, digite /entrarsala " .. newRoom.id
    }
  })
end)

-- Evento disparado quando o jogador tenta entrar em uma sala cheia
RegisterNetEvent("valhalla:roomFull")
AddEventHandler("valhalla:roomFull", function()
  TriggerEvent("chat:addMessage", {
    color = { 255, 0, 0 },
    multiline = true,
    args = { "[Valhalla]", "A sala está cheia." }
  })
end)

-- Evento disparado quando a sala não foi encontrada
RegisterNetEvent("valhalla:roomNotFound")
AddEventHandler("valhalla:roomNotFound", function()
  TriggerEvent("chat:addMessage", {
    color = { 255, 0, 0 },
    multiline = true,
    args = { "[Valhalla]", "Sala não encontrada." }
  })
end)

-- Evento disparado quando o jogador entra na sala
RegisterNetEvent("valhalla:joinedRoom")
AddEventHandler("valhalla:joinedRoom", function(joinedRoom)
  room = joinedRoom
  TriggerEvent("chat:addMessage", {
    color = { 255, 0, 0 },
    multiline = true,
    args = {
      "[Valhalla]", "Você entrou na sala " .. room.id,
      "Mapa: " .. room.mapName,
      "Jogadores: " .. #room.players .. "/" .. room.maxPlayers
    }
  })
end)


-- Evento para teleportar os jogadores para a sala
RegisterNetEvent("valhalla:teleportPlayer")
AddEventHandler("valhalla:teleportPlayer", function(player, roomId, spawnPoint)
  print("Teleportando jogador para a sala " .. roomId)
  local x, y, z = table.unpack(spawnPoint)
  SetEntityCoords(GetPlayerPed(player), x, y, z)
  FreezeEntityPosition(GetPlayerPed(player), true)
end)

-- Evento disparado quando o jogo inicia
RegisterNetEvent("valhalla:gameStarted")
AddEventHandler("valhalla:gameStarted", function(player, roomId)
  print("O jogo começou")
  TriggerEvent("chat:addMessage", {
    color = { 255, 0, 0 },
    multiline = true,
    args = { "[Valhalla]", "O jogo começou!" }
  })

  FreezeEntityPosition(player, false)
  inGame = true
end)
