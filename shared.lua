mod_name = "rail-layer"
mod_prefix = mod_name .. "--"
mod_directory = "__" .. mod_name .. "__"
dbg={}
---@generic T:any
---@param data T
---@return T
function structured_clone(data)
  if data == nil then return nil end
  return helpers.json_to_table(helpers.table_to_json(data))
end