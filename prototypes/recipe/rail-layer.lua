local rail_layer = structured_clone(data.raw["recipe"]["locomotive"])
rail_layer.name = "rail-layer"
rail_layer.ingredients ={
  {type = "item", name = "engine-unit", amount = 20},
  {type = "item", name = "electronic-circuit", amount = 10},
  {type = "item", name = "steel-plate", amount = 30}
}
rail_layer.results = {
  { type = "item", name = "rail-layer", amount = 1 }
}

data:extend { rail_layer }
