local find = require("scripts.find")
local train_action = require("scripts.train_actions")

--- Build rail ghosts after rail end.
--- @param train LuaTrain
--- @param radius number
local function revive_signals(train, radius)
  local rail_end = train.speed > 0 and train.front_end or train.back_end
  local surface = rail_end.rail.surface
  local rail_start = rail_end.make_copy()
  rail_start.flip_direction()

  -- get a cargo LuaInventory
  local cargo = train.cargo_wagons[1]
  local inv = cargo.get_inventory(defines.inventory.cargo_wagon)

  -- try to build ghost signals
  local signal_locations = {}
  table.insert(signal_locations, rail_end.out_signal_location)
  table.insert(signal_locations, rail_end.in_signal_location)
  table.insert(signal_locations, rail_end.alternative_in_signal_location)
  table.insert(signal_locations, rail_end.alternative_out_signal_location)
  table.insert(signal_locations, rail_start.out_signal_location)
  table.insert(signal_locations, rail_start.in_signal_location)
  table.insert(signal_locations, rail_start.alternative_in_signal_location)
  table.insert(signal_locations, rail_start.alternative_out_signal_location)

  for i, location in ipairs(signal_locations) do
    if not location then goto continue end
    local filter = {position=location.position, type={"rail-signal","rail-chain-signal"}}
    local ghost = find.ghost(surface, filter)

    train_action.place_entity(train, ghost)
    ::continue::
  end
end

return revive_signals
