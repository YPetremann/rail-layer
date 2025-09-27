local remove_items = require("scripts.remove_items")
local insert_items = require("scripts.insert_items")

---@param tile_ghost LuaEntity|nil
---@param inventories LuaInventory[]|nil
---@return string|nil error message on failure
local function revive_tile(tile_ghost, inventories)
  if not tile_ghost then return false end
  local quality = tile_ghost.quality or "normal"

  local items = {}
  if inventories then
    for _, item in pairs(tile_ghost.ghost_prototype.items_to_place_this or {}) do
      table.insert(items, {
        name=item.name, 
        count = item.count,
        --quality=quality
      })
    end

    local can_remove = not inventories or remove_items(inventories, items, true)
    if not can_remove then return "rail-layer.no-suficient-items" end
  end


  local collide, revived, proxy = tile_ghost.revive { raise_revive = true }
  if not collide then return "rail-layer.revive-error" end

  if inventories then 
    remove_items(inventories, items)
  end
end

return revive_tile
