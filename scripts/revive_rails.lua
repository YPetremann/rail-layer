local find = require("scripts.find")
local train_action = require("scripts.train_actions")

--- Build rail ghosts after rail end.
--- @param train LuaTrain
--- @param radius number
local function revive_rails(train, radius)
  local rail_end = train.speed > 0 and train.front_end or train.back_end

  local surface = rail_end.rail.surface
  local rail_start = rail_end.make_copy()
  rail_start.flip_direction()

  -- get a cargo LuaInventory
  local cargo = train.cargo_wagons[1]
  local inv = cargo.get_inventory(defines.inventory.cargo_wagon)

  -- try to build ghost rails
  for _, extension in ipairs(rail_end.get_rail_extensions("rail")) do
    local filter = { direction = extension.direction, position = extension.position, name = extension.name }
    local ghost = find.ghost(surface, filter)
    local ramp = extension.name == "rail-ramp"
    local elevated = extension.name:sub(1, 9) == "elevated-"

    if ramp or elevated then ghost=nil end

    train_action.place_entity(train, ghost)
  end
end

return revive_rails
