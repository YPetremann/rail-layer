local find={}
---@param surface LuaSurface
---@param args EntitySearchFilters
function find.entity(surface, args)
  local entities = surface.find_entities_filtered(args)
  local entity = #entities >= 1 and entities[1] or nil
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
function find.ghost(surface, args)
  local new_args = {}
  for k, v in pairs(args) do new_args[k] = v end
  new_args.ghost_name = new_args.name
  new_args.ghost_type = new_args.type
  new_args.name = nil
  new_args.type = nil
  return find.entity(surface, new_args)
end

---@param surface LuaSurface
---@param args EntitySearchFilters
function find.entity_or_ghost(surface, args)
  return find.entity(surface, args) or find.ghost(surface, args)
end

return find