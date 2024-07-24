Config = {}

-- Padrão para criação de mapas
--["praça"] = {                     Nome do mapa
--  ["spawn"] = {                   Tabela de posições das equipes
--    attackers = { x = -1037.0, y = -2737.0, z = 13.0 },
--    defenders = { x = -1037.0, y = -2737.0, z = 13.0 }
--  },
--  maxPlayers = 10,                Quantidade maxima de jogadores por mapa
--},
Config.mapas = {
  ["praça"] = {
    ["spawn"] = {
      attackers = { x = -1037.0, y = -2737.0, z = 13.0 },
      defenders = { x = -1037.0, y = -2737.0, z = 13.0 }
    },
    maxPlayers = 10,
  },
  ["bebidas"] = {
    ["spawn"] = {
      attackers = { x = -1037.0, y = -2737.0, z = 13.0 },
      defenders = { x = -1037.0, y = -2737.0, z = 13.0 }
    },
    maxPlayers = 10,
  },
}


return Config
