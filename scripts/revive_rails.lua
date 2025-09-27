local find = require("scripts.find")
local revive_entity = require("scripts.revive_entity")

--- Build rail ghosts after rail end.
--- @param train LuaTrain
--- @param radius number
local function revive_rails(train, radius)
  local rail_end = train.speed > 0 and train.front_end or train.back_end

  local surface = rail_end.rail.surface
  local rail_start = rail_end.make_copy()
  rail_start.flip_direction()

  local inventories = {}
  for _, wagon in ipairs(train.cargo_wagons) do
    table.insert(inventories, wagon.get_inventory(defines.inventory.cargo_wagon))
  end

  -- try to build ghost rails
  for _, extension in ipairs(rail_end.get_rail_extensions("rail")) do
    local filter = { direction = extension.direction, position = extension.position, name = extension.name }
    local ghost = find.ghost(surface, filter)
    local ramp = extension.name == "rail-ramp"
    local elevated = extension.name:sub(1, 9) == "elevated-"

    if ramp or elevated then ghost=nil end

    revive_entity(ghost, inventories)
  end
end

return revive_rails
