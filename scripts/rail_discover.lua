---@param surface LuaSurface
---@param args EntitySearchFilters
local function find_entity(surface, args)
  local entities = surface.find_entities_filtered(args)
  local entity = #entities >= 1 and entities[1]
  local arg_pos = args.position
  if entity and arg_pos then
    local ent_pos = entity.position
    if ent_pos.x ~= (arg_pos.x or arg_pos[1]) then entity = nil end
    if ent_pos.y ~= (arg_pos.y or arg_pos[2]) then entity = nil end
  end
  return entity
end

---@param surface LuaSurface
---@param args EntitySearchFilters
local function find_ghost(surface, args)
  local new_args = {}
  for k, v in pairs(args) do new_args[k] = v end
  new_args.ghost_name = new_args.name
  new_args.ghost_type = new_args.type
  new_args.name = nil
  new_args.type = nil
  return find_entity(surface, new_args)
end

---@param surface LuaSurface
---@param args EntitySearchFilters
local function find_entity_or_ghost(surface, args)
  return find_entity(surface, args) or find_ghost(surface, args)
end

---@param train LuaTrain
---@param items ItemToPlace[]
local function can_remove_items(train, items, quality)
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
local function remove_items(train, items, quality)
  for _, item in pairs(items) do
    train.remove_item {
      name = item.name,
      count = item.count,
      quality = quality or "normal"
    }
  end
end

--- Build rail ghosts after rail end.
--- @param train LuaTrain
--- @param rail_end LuaRailEnd
--- @param radius number
local function rail_ghost_build(train, rail_end, radius)
  local surface = rail_end.rail.surface
  local rail_start = rail_end.make_copy()
  rail_start.flip_direction()

  -- get a cargo LuaInventory
  local cargo = train.cargo_wagons[1]
  local inv = cargo.get_inventory(defines.inventory.cargo_wagon)

  -- try to build ghost rails
  for _, extension in ipairs(rail_end.get_rail_extensions("rail")) do
    local entity = find_entity_or_ghost(surface, extension)
    local ghost = entity and entity.type == "entity-ghost"
    local ramp = extension.name == "rail-ramp"
    local elevated = extension.name:sub(1, 9) == "elevated-"

    if not (entity and ghost) then goto continue end
    if ramp or elevated then goto continue end
    local quality = entity.quality or "normal"
    local items = entity.ghost_prototype.items_to_place_this or {}
    if not can_remove_items(train, items, quality) then goto continue end
    local collide, revived, proxy = entity.revive{inventory = inv}
    if not revived then goto continue end
    remove_items(train, items, quality)
    ::continue::
  end

  -- try to build ghost signals
  local signal_locations = {}
  table.insert(signal_locations, rail_end.out_signal_location)
  table.insert(signal_locations, rail_end.in_signal_location)
  table.insert(signal_locations, rail_end.alternative_in_signal_location)
  table.insert(signal_locations, rail_end.alternative_out_signal_location)
  table.insert(signal_locations, rail_start.out_signal_location)
  table.insert(signal_locations, rail_start.in_signal_location)
  table.insert(signal_locations, rail_start.alternative_in_signal_location)
  table.insert(signal_locations, rail_start.alternative_out_signal_location)

  rendering.clear("rail-layer")
  for i, location in ipairs(signal_locations) do
    if not location then goto continue end
    local filter = {position=location.position, type={"rail-signal","rail-chain-signal"}}
    local entity = find_entity_or_ghost(surface, filter)
    local ghost = entity and entity.type == "entity-ghost"

    if not (entity and ghost) then goto continue end
    local quality = entity.quality or "normal"
    local items = entity.ghost_prototype.items_to_place_this or {}
    if not can_remove_items(train, items, quality) then goto continue end
    local collide, revived, proxy = entity.revive{inventory = inv}
    if not revived then goto continue end
    remove_items(train, items, quality)
    ::continue::
  end
end

return rail_ghost_build
