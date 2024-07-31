function onClientMapStart()
  exports.spawnmanager:setAutoSpawn(false)
  TriggerEvent("playerSpawnSetup")
end

RegisterNetEvent("playerSpawnSetup")
AddEventHandler("playerSpawnSetup", function()
  exports.spawnmanager:spawnPlayer({
    x = 0.0,
    y = 0.0,
    z = 72.0,
    model = "mp_m_freemode_01"
  }, function()
    TriggerEvent("playerSpawned")
  end)
end)

RegisterNetEvent("playerSpawned")
AddEventHandler("playerSpawned", function()
  Valhalla.Functions.RequestPlayerData(function(data)
    if data then
      print('Player data received:', json.encode(data))
      local ped = PlayerPedId()
      -- aply customizations
    else
      print('No player data found.')
    end
  end)
end)

AddEventHandler("onClientMapStart", onClientMapStart)
