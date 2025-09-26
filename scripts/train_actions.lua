local train_action={}
---@param train LuaTrain
---@param items ItemToPlace[]
function train_action.can_remove_items(train, items, quality)
  for _, item in pairs(items) do
    local count = train.get_item_count {
      name = item.name,
      comparator = "=",
      quality = quality or "normal"
    }
    if count < item.count then return false end
  end
  return true
end

---@param train LuaTrain
---@param items ItemToPlace[]
function train_action.remove_items(train, items, quality)
  for _, item in pairs(items) do
    train.remove_item {
      name = item.name,
      count = item.count,
      quality = quality or "normal"
    }
  end
end

function train_action.place_entity(train, ghost)
  if not ghost then return "rail-layer-error.no-entity-to-place" end
  local quality = ghost.quality or "normal"
  local items = ghost.ghost_prototype.items_to_place_this or {}

  local can_remove = train_action.can_remove_items(train, items, quality)
  if not can_remove then return "rail-layer-error.no-suficient-items" end

  local collide, revived, proxy = ghost.revive{raise_revive=true,inventory = inv}
  if not revived then return "rail-layer-error.cant-revive-entity" end

  train_action.remove_items(train, items, quality)
end

return train_action