---Gets the current menu's variables.
---@param menuType string The menu type.
---@return table
function getMenuVars(menuType)
  local menuVars = {}

  if (menuType == "placeStandard") then
    menuVars = {
      svTypeIndex = 1,
      svMultipliers = {},
      svDistances = {},
      svGraphStats = createSVGraphStats(),
      svStats = createSVStats(),
      interlace = false,
      interlaceRatio = -0.5,
      overrideFinal = false
    }
  elseif (menuType == "placeSpecial") then
    menuVars = { svTypeIndex = 1 }
  elseif (menuType == "placeStill") then
    menuVars = {
      svTypeIndex = 1,
      noteSpacing = 1,
      stillTypeIndex = 1,
      stillDistance = 0,
      stillBehavior = 1,
      prePlaceDistances = {},
      svMultipliers = {},
      svDistances = {},
      svGraphStats = createSVGraphStats(),
      svStats = createSVStats(),
      interlace = false,
      interlaceRatio = -0.5,
      overrideFinal = false
    }
  elseif (menuType == "placeVibrato") then
    menuVars = {
      svTypeIndex = 1,
      vibratoMode = 1,
      vibratoQuality = 3,
      sides = 2
    }
  elseif (menuType == "delete") then
    menuVars = {
      deleteTable = { true, true, true, true }
    }
  elseif (menuType == "addTeleport") then
    menuVars = {
      distance = 10727,
      teleportBeforeHand = false
    }
  elseif (menuType == "copy") then
    menuVars = {
      copyTable = { true, true, true, true }, -- 1: timing lines, 2: svs, 3: ssfs, 4: bookmarks
      copiedLines = {},
      copiedSVs = {},
      copiedSSFs = {},
      copiedBMs = {},
    }
  elseif (menuType == "convertSVSSF") then
    menuVars = { conversionDirection = true }
  elseif (menuType == "directSV") then
    menuVars = {
      selectableIndex = 1,
      startTime = 0,
      multiplier = 0,
      pageNumber = 1
    }
  elseif (menuType == "displaceNote") then
    menuVars = {
      distance = 200,
      distance1 = 0,
      distance2 = 200,
      linearlyChange = false
    }
  elseif (menuType == "displaceView") then
    menuVars = { distance = 200 }
  elseif (menuType == "dynamicScale") then
    menuVars = {
      noteTimes = {},
      svTypeIndex = 1,
      svMultipliers = {},
      svDistances = {},
      svGraphStats = createSVGraphStats(),
      svStats = createSVStats()
    }
  elseif (menuType == "flicker") then
    menuVars = {
      flickerTypeIndex = 1,
      distance = -69420.727,
      distance1 = 0,
      distance2 = -69420.727,
      numFlickers = 1,
      linearlyChange = false,
      flickerPosition = 0.5
    }
  elseif (menuType == "measure") then
    menuVars = {
      unrounded = false,
      nsvDistance = "",
      svDistance = "",
      avgSV = "",
      startDisplacement = "",
      endDisplacement = "",
      avgSVDisplaceless = "",
      roundedNSVDistance = 0,
      roundedSVDistance = 0,
      roundedAvgSV = 0,
      roundedStartDisplacement = 0,
      roundedEndDisplacement = 0,
      roundedAvgSVDisplaceless = 0
    }
  elseif (menuType == "reverseScroll") then
    menuVars = { distance = 400 }
  elseif (menuType == "scaleDisplace") then
    menuVars = {
      scaleSpotIndex = 1,
      scaleTypeIndex = 1,
      avgSV = 0.6,
      distance = 100,
      ratio = 0.6,
    }
  elseif (menuType == "scaleMultiply") then
    menuVars = {
      scaleTypeIndex = 1,
      avgSV = 0.6,
      distance = 100,
      ratio = 0.6
    }
  elseif (menuType == "verticalShift") then
    menuVars = { verticalShift = 1 }
  elseif (menuType == "selectAlternating") then
    menuVars = {
      every = 1,
      offset = 0
    }
  elseif (menuType == "selectChordSize") then
    menuVars = {
      single = false,
      jump = true,
      hand = true,
      quad = false
    }
  elseif (menuType == "selectNoteType") then
    menuVars = {
      rice = true,
      ln = true
    }
  elseif (menuType == "selectBySnap") then
    menuVars = { snap = 1 }
  end

  local labelText = table.concat({ menuType, "Menu" })
  getVariables(labelText, menuVars)
  return menuVars
end
