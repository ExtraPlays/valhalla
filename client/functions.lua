Valhalla.Functions = {}

-- Faz uma requisição para o servidor para obter os dados do jogador
function Valhalla.Functions.RequestPlayerData(cb)
  Valhalla.Functions.TriggerCallback('valhalla:getPlayer', source, function(data)
    if data then
      Valhalla.PlayerData = data
      if cb then cb(data) end
    else
      cb(nil)
    end
  end)
end

-- Retorna os dados do jogador
function Valhalla.Functions.GetPlayerData()
  return Valhalla.PlayerData
end
