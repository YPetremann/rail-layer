
--- Can item be removed from the inventories
---@param inventories LuaInventory[]
---@param item ItemStackIdentification
local function can_remove_item(inventories, item)
  local count = 0
  local filter = { name = item.name, quality = item.quality }
  for _, inventory in pairs(inventories) do
    count = count + inventory.get_item_count(filter)
    if count >= item.count then return true end
  end
  return false
end

--- Can all items be removed from the inventories
---@param inventories LuaInventory[]
---@param items ItemStackIdentification[]
local function can_remove_items(inventories, items)
  for _, item in pairs(items) do
    local removable = can_remove_item(inventories, item)
    if not removable then return false end
  end
  return true
end

--- Remove items from the inventories
---@param inventories LuaInventory[]
---@param items ItemStackIdentification[]
---@param dry? boolean
local function remove_items(inventories, items, dry)
  if dry then return can_remove_items(inventories, items) end
  for _, item in pairs(items) do
    local def = {name = item.name, quality = item.quality, count = item.count }
    for _, inventory in pairs(inventories) do
      if def.count > 0 then
        local removed = inventory.remove(def)
        def.count = def.count - removed
      end
    end
  end
end

return remove_items