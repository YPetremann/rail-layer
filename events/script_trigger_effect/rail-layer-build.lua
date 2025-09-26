local rail_build = require("scripts.rail_discover")

---@param event EventData.on_script_trigger_effect
return function(event)
  local rail_layer = event.cause_entity
  if not rail_layer then return end -- event not caused by entity
  local train = rail_layer.train
  if not train then return end      -- not a train

  local rail_end = train.speed > 0 and train.front_end or train.back_end
  
  rail_build(train, rail_end, 15)

  
end
