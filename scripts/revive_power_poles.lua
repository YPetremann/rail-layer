local find = require("scripts.find")
local revive_entity = require("scripts.revive_entity")

--- Build rail ghosts after rail end.
--- @param train LuaTrain
--- @param radius number
local function revive_power_poles(train, radius)
  if not settings.global.rail_layer__experimental_power_poles.value then return end

  local stock_end = train.speed > 0 and train.front_stock or train.back_stock
  if not stock_end then return end
  local surface = stock_end.surface

  local inventories = {}
  for _, wagon in ipairs(train.cargo_wagons) do
    table.insert(inventories, wagon.get_inventory(defines.inventory.cargo_wagon))
  end

  local ghosts=surface.find_entities_filtered{
    ghost_type = "electric-pole",
    force = train.front_stock.force,
    position = stock_end.position,
    radius = radius,
  }
  for _,ghost in pairs(ghosts) do
    revive_entity(ghost, inventories)
  end
end

return revive_power_poles