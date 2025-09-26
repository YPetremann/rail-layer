local rail_layer = structured_clone(data.raw["item-with-entity-data"]["locomotive"])
rail_layer.name = "rail-layer"
rail_layer.icon = "__rail-layer__/graphics/icons/rail-layer.png"
rail_layer.place_result = "rail-layer"

data:extend{rail_layer}