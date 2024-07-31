Valhalla.Functions = {}

--- Retorna o jogador pelo source
--- @param source any
--- @return table
function Valhalla.Functions.GetPlayerBySource(source)
  return Valhalla.Players[source]
end

--- Retorna o jogador pelo identificador
--- @param identifier string
function Valhalla.Functions.GetPlayerByIdentifier(identifier)
  for _, player in pairs(Valhalla.Players) do
    if player.Identifier == identifier then
      return player
    end
  end

  return nil
end

--- Retorna o jogador pelo source ou identificador
--- @param source any string | number
function Valhalla.Functions.GetPlayer(source)
  if type(source) == 'number' then
    return Valhalla.Functions.GetPlayerBySource(source)
  elseif type(source) == 'string' then
    return Valhalla.Functions.GetPlayerByIdentifier(source)
  end
end

--- Cria um callback para ser chamado posteriormente
--- @param name string
--- @param cb function
function Valhalla.Functions.CreateCallback(name, cb)
  Valhalla.ServerCallbacks[name] = cb
end

--- Chama um callback registrado anteriormente pelo nome e passa os argumentos
--- @param name any
--- @param source any
--- @param cb function
--- @param ... any
function Valhalla.Functions.TriggerCallback(name, source, cb, ...)
  if not Valhalla.ServerCallbacks[name] then return end
  Valhalla.ServerCallbacks[name](source, cb, ...)
end

Valhalla.Functions.CreateCallback('valhalla:getPlayer', function(source, cb)
  local player = Valhalla.Functions.GetPlayerBySource(source)
  if player then
    cb(player)
  else
    cb(nil)
  end
end)
