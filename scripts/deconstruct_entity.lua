local remove_items = require("scripts.remove_items")
local insert_items = require("scripts.insert_items")

---@param entity LuaEntity|nil
---@param inventories LuaInventory[]|nil
---@return string|nil error message on failure
local function deconstruct_entity(entity, inventories)
  if not entity then return false end

  if not inventories then
    local inventory = game.create_inventory(0)
    entity.mine { inventory = inventory, force = true }
    inventory.destroy()
    return
  end

  -- if this is cliff, we cannot deconstruct it without cliff explosives
  if entity.type == "cliff" then
    local explosive = entity.prototype.cliff_explosive_prototype
    local def = { name = explosive, count = 1 }
    local can_remove = not inventories or remove_items(inventories, { def }, true)
    if not can_remove then return "rail-layer.no-suficient-items" end

    -- find the first stack of explosives and use it
    local stack = nil
    for _, inventory in ipairs(inventories) do
      stack = inventory.find_item_stack { name = explosive }
      if stack then break end
    end
    if stack then
      stack.use_capsule(entity, entity.position)
      return nil
    end

    return "rail-layer-error.cant-deconstruct-cliff"
  else 

    for _, inventory in ipairs(inventories) do
      local success = entity.mine { inventory = inventory }
      if success then return nil end
    end
  end
  return "rail-layer.not-enough-space"
end

return deconstruct_entity
