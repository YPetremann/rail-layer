local find = require("scripts.find")
local train_action = require("scripts.train_actions")

--- Build rail ghosts after rail end.
--- @param train LuaTrain
--- @param radius number
local function revive_power_poles(train, radius)
  if not settings.global.rail_layer__experimental_power_poles.value then return end

  local stock_end = train.speed > 0 and train.front_stock or train.back_stock
  if not stock_end then return end
  local surface = stock_end.surface

  -- get a cargo LuaInventory
  local cargo = train.cargo_wagons[1]
  local inv = cargo.get_inventory(defines.inventory.cargo_wagon)

  local ghosts=surface.find_entities_filtered{
    ghost_type = "electric-pole",
    force = train.front_stock.force,
    position = stock_end.position,
    radius = radius,
  }
  for _,ghost in pairs(ghosts) do
    train_action.place_entity(train, ghost)
  end
end

return revive_power_poles