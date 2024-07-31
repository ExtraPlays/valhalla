--- Tabela de jogadores conectados ao servidor
Valhalla.Players = {}
--- Funções relacionadas a jogadores
Valhalla.Player = {}

--- Cria um novo jogador no banco de dados e o adiciona à tabela de jogadores
--- @param source any
--- @param identifier string
function Valhalla.Player.CreatePlayer(source, identifier)
  local player = {
    name = ValhallaConfig.DefaultUserData.name,
    license = Valhalla.Config.DefaultUserData.license,
    identifier = identifier,
    group = ValhallaConfig.DefaultUserData.group,
    premium = ValhallaConfig.DefaultUserData.premium,
    banned = ValhallaConfig.DefaultUserData.banned,
    allowlist = ValhallaConfig.DefaultUserData.allowlist,
    settings = json.encode(ValhallaConfig.DefaultUserData.settings)
  }

  MySQL.Async.execute(
    'INSERT INTO players (name, license, identifier, group, premium, settings) VALUES (@name, @license, @identifier, @group, @premium, @settings)',
    {
      ['@name'] = player.name,
      ['@license'] = player.license,
      ['@identifier'] = player.identifier,
      ['@group'] = player.group,
      ['@premium'] = player.premium,
      ['@banned'] = player.banned,
      ['@allowlist'] = player.allowlist,
      ['@settings'] = player.settings
    }, function(rowsChanged)
      if rowsChanged > 0 then
        Valhalla.Players[source] = player
        return player
      else
        return false
      end
    end)
end

function Valhalla.Player.LoadPlayer(identifier)
  MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
    ['@identifier'] = identifier
  }, function(result)
    if result[1] then
      local player = result[1]
      Valhalla.Players[source] = {
        name = player.name,
        license = player.license,
        identifier = player.identifier,
        group = player.group,
        premium = player.premium,
        banned = player.banned,
        allowlist = player.allowlist,
        settings = json.decode(player.settings)
      }

      return player
    else
      return false
    end
  end)
end

function Valhalla.Player.DoesPlayerExist(identifier)
  MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
    ['@identifier'] = identifier
  }, function(result)
    if result[1] then
      return true
    else
      return false
    end
  end)
end
