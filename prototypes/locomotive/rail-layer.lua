local function add_trigger(entity,trigger,effect)
  if not entity[trigger] then entity[trigger] = {} end
  if entity[trigger].type then entity[trigger] = {entity[trigger]} end
  table.insert(entity[trigger],effect)
end

local rail_layer = structured_clone(data.raw["locomotive"]["locomotive"])
rail_layer.name = "rail-layer"
rail_layer.icon = "__rail-layer__/graphics/icons/rail-layer.png"
rail_layer.color = {r=1,g=0.75,b=0}
rail_layer.minable.result = "rail-layer"
rail_layer.default_copy_color_from_train_stop=false
rail_layer.allow_manual_color=false
rail_layer.max_speed=0.25
rail_layer.drive_over_tie_trigger_minimal_speed=0
rail_layer.tie_distance=1
rail_layer.factoriopedia_simulation = {init ="require(\"__rail-layer__/factoriopedia/rail-layer\")"}
add_trigger(rail_layer,"drive_over_tie_trigger",{type="script",effect_id="rail-layer-build"})

if mods["elevated-rails"] then
  local meld = require("__core__.lualib.meld")
  local updates = require("__elevated-rails__.prototypes.sloped-trains-updates")
  meld(rail_layer, updates.locomotive)
  add_trigger(rail_layer,"drive_over_elevated_tie_trigger",{type="script",effect_id="rail-layer-build"})
end

data:extend{rail_layer}