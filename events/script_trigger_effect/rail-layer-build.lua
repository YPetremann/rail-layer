local revive_rails = require"scripts.revive_rails"
local revive_signals = require"scripts.revive_signals"
local revive_power_poles = require"scripts.revive_power_poles"

---@param event EventData.on_script_trigger_effect
return function(event)
  local rail_layer = event.cause_entity
  if not rail_layer then return end -- event not caused by entity
  local train = rail_layer.train
  if not train then return end      -- not a train

  revive_rails(train, 7)
  revive_signals(train, 7)
  revive_power_poles(train, 7)
end
