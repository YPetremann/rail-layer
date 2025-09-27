local remove_items = require("scripts.remove_items")
local deconstruct_entity = require("scripts.deconstruct_entity")
local revive_tile = require("scripts.revive_tile")

---@param ghost LuaEntity|nil
---@param inventories LuaInventory[]|nil
---@return string|nil error message on failure
local function revive_entity(ghost, inventories)
  if not ghost then return "rail-layer-error.no-entity-to-place" end
  local quality = ghost.quality or "normal"

  -- deconstruct entities marked for deconstruction colliding with this ghost
  local to_be_deconstructed = ghost.surface.find_entities_filtered {
    area = ghost.bounding_box,
    to_be_deconstructed = true
  }

  for _, entity in pairs(to_be_deconstructed) do
    local msg = deconstruct_entity(entity, inventories)
    if msg then global_msg = msg end
  end

  -- revive ghost tiles needed for this ghost
  local tile_ghosts = ghost.surface.find_entities_filtered {
    type = "tile-ghost",
    area = ghost.bounding_box,
    force = ghost.force
  }

  for _, tile_ghost in pairs(tile_ghosts) do
    msg = revive_tile(tile_ghost, inventories)
    if msg then global_msg = msg end
  end

  local items = {}
  if inventories then
    for _, item in pairs(ghost.ghost_prototype.items_to_place_this or {}) do
      table.insert(items, { name = item.name, count = item.count, quality = quality })
    end
    local can_remove = not inventories or remove_items(inventories, items, true)
    if not can_remove then return "rail-layer.no-suficient-items" end
  end

  local collide, revived, proxy = ghost.revive { raise_revive = true }
  if not revived then return "rail-layer.revive-error" end

  if inventories then
    remove_items(inventories, items)
  end
end

return revive_entity
