local effect_ids = {
  ["rail-layer-build"] = require("events.script_trigger_effect.rail-layer-build"),
}

script.on_event(defines.events.on_script_trigger_effect,function(event)
  local effect = effect_ids[event.effect_id]
  if effect then effect(event) end
end)