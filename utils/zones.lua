local zones = {}

zones["praça"] = PolyZone:Create({
  vector2(-1047.0, -2747.0),
  vector2(-1047.0, -2727.0),
  vector2(-1027.0, -2727.0),
  vector2(-1027.0, -2747.0)
}, {
  name = "praça",
  minZ = 12.0,
  maxZ = 14.0
})

zones["bebidas"] = PolyZone:Create({
  vector2(-1057.0, -2757.0),
  vector2(-1057.0, -2737.0),
  vector2(-1037.0, -2737.0),
  vector2(-1037.0, -2757.0)
}, {
  name = "bebidas",
  minZ = 12.0,
  maxZ = 14.0
})

return zones
