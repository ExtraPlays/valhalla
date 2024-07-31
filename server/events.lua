function onPlayerConnecting(source, _, deferrals)
  -- Defere a conexão para fazer verificações
  deferrals.defer()
  Wait(0) -- Aguarda um tick após deferrer

  local player = source
  local identifiers = GetPlayerIdentifiers(player)
  local steamIdentifier = nil

  -- Procura o identificador do Steam
  for _, v in ipairs(identifiers) do
    if string.match(v, 'steam:') then
      steamIdentifier = v
      break
    end
  end

  -- Atualiza o status para 'Verificando Steam...'
  deferrals.update('Verificando Steam...')
  Wait(0) -- Aguarda um tick após a atualização do status

  -- Se o Steam não estiver presente, rejeita a conexão
  if not steamIdentifier then
    deferrals.done('Você precisa ter o Steam aberto para jogar no servidor.')
    return
  end

  -- Checa se o jogador existe no Valhalla
  deferrals.update('Verificando dados do jogador...')
  Wait(0) -- Aguarda um tick após a atualização do status

  if Valhalla.Player.DoesPlayerExist(steamIdentifier) then
    local playerData = Valhalla.Player.LoadPlayer(steamIdentifier)

    if playerData then
      if playerData.banned then
        deferrals.done('Você foi banido do servidor.')
        return
      end

      if not playerData.allowlist then
        deferrals.done('Você não está na lista de permissão.')
        return
      end
    end

    -- Se o jogador está permitido, aceita a conexão
    deferrals.done()
  else
    -- Cria um novo jogador se não existir
    Valhalla.Player.CreatePlayer(player, steamIdentifier)
    deferrals.update('Criando personagem...')
    Wait(0) -- Aguarda um tick após a atualização do status

    -- Aceita a conexão após criar o personagem
    deferrals.done()
  end
end

function onPlayerDropped(reason)
  local player = source
  local playerData = Valhalla.Players[player]

  if playerData then
    Valhalla.Player.SavePlayer(playerData)
    Wait(2000) -- Aguarda um tick após salvar o jogador
    Valhalla.Players[player] = nil
  end
end

AddEventHandler('playerConnecting', onPlayerConnecting)
AddEventHandler('playerDropped', onPlayerDropped)
