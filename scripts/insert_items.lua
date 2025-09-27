---@class (exact) ItemData
---@field def ItemStackIdentification
---@field stack_size number
---@field min_slot number
---@field max_slot number
---@field invs LuaInventory[]


--- Can all items be inserted into the inventories
---@param inventories LuaInventory[]
---@param items ItemStackIdentification[]
local function can_insert_items(inventories, items)
  -- create a temporary items data
  ---@type ItemData[]
  local items_data = {}
  local total_filled_slots = 0
  local total_occupied_slots = 0
  for _, item in ipairs(items) do
    local stack_size = prototypes.item[item.name].stack_size
    local filled_slots = math.floor(item.count / stack_size)
    local occupied_slots = math.ceil(item.count / stack_size)
    total_filled_slots = total_filled_slots + filled_slots
    total_occupied_slots = total_occupied_slots + occupied_slots
    local def = {
      name = item.name,
      quality = item.quality or "normal"
    }
    table.insert(items_data, {
      def=def,
      count = item.count,
      stack_size = stack_size,
      min_slot = filled_slots,   -- The number of slots that will be 100% filled
      max_slot = occupied_slots, -- The number of slots that will be occupied
      invs={},
    })
  end

  -- make a quick scan of inventories with quick return if we have enough free slots
  
  ---@type LuaInventory[]
  local invs = {}

  local total_free_slots = 0
  for i, inv in ipairs(inventories) do
    if not inv.is_full() then
      local free = inv.count_empty_stacks()
      total_free_slots = total_free_slots + free
      table.insert(invs, inv)
    end
    if total_free_slots >= total_occupied_slots then return true end
  end

  -- we check items by item
  for _, item in ipairs(items_data) do
    -- if item can be inserted with quick insertion count
    -- if not we return false
    local count = 0
    for _, inv in ipairs(invs) do
      if inv.can_insert(item.def) then
        local available = inv.get_insertable_count{
          name=item.def.name, quality=item.def.quality
        }
        count = count + available
        table.insert(item.invs, inv)
      end
    end
    if count < item.def.count then return false end
  end

  return true
  -- at this point we know that this is the hard case
  -- so we really need to check slot by slot
  -- but to simplify we have checked before which inventories can accept items
  
  --for _, item_data in ipairs(items_data) do
  --  for _, inv_data in ipairs(item_data.invs_data) do
  --    for _, slot in ipairs(inv_data.inv) do
  --      
  --
  --    end
  --    ::continue::
  --  end
  --end
end

--- Insert items into the inventories
---@param inventories LuaInventory[]
---@param items ItemStackIdentification[]
---@param dry? boolean
local function insert_items(inventories, items, dry)
  if dry then return can_insert_items(inventories, items) end
  for _, item in pairs(items) do
    local def = { name = item.name, quality = item.quality or "normal", count = item.count }
    for _, inventory in pairs(inventories) do
      if def.count > 0 then
        local inserted = inventory.insert(def)
        def.count = def.count - inserted
      end
    end
  end
end

return insert_items
