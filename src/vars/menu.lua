---Gets the current menu's variables.
---@param menuType string The menu type.
---@return table
function getMenuVars(menuType)
  local menuVars = {} -- TODO: CONVERT TO STATE

  local labelText = table.concat({ menuType, "Menu" })
  getVariables(labelText, menuVars)
  return menuVars
end
