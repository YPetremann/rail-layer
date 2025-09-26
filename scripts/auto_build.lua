--- Auto build a rails around a rail
--- @param rail LuaEntity
--- @param inv LuaInventory
return function(rail,inv)
  local rail_layer = inv.find_item_stack("rail-layer")
  if not rail_layer then return end
  local pos = rail.position
  local surface = rail.surface
  local direction = rail.direction
  local force = rail.force
  local params = {name="rail-layer",position=pos,direction=direction,force=force}
  local entity = surface.create_entity(params)
  if entity then
    if rail_layer.count > 1 then
      rail_layer.count = rail_layer.count - 1
    else
      rail_layer.clear()
    end
    entity.set_vehicle_ownership(force)
    return entity
  end
end