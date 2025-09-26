local rail_layer = structured_clone(data.raw["technology"]["automated-rail-transportation"])
rail_layer.name = "rail-layer"
rail_layer.effects = { { type = "unlock-recipe", recipe = "rail-layer" } }
rail_layer.icon = "__rail-layer__/graphics/technology/rail-layer.png"

data:extend { rail_layer }
