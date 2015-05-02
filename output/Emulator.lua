local ui = (function()
-- inlined ../ui
require "base/internal/ui/reflexcore"

return {
  -- stuff from reflexCore
  window = _G.uiWindow,
  button = _G.uiButton,
  buttonVertical = _G.uiButtonVertical,
  slider = _G.uiSlider,
  progressBar = _G.uiProgressBar,
  scrollBar = _G.uiScrollBar,
  subHeader = _G.uiSubHeader,
  toolTip = _G.uiToolTip,
  checkBox = _G.uiCheckBox,
  editBox = _G.uiEditBox,
  label = _G.uiLabel,
  comboBox = _G.uiComboBox,
  colorPicker = _G.uiColorPicker,


  scrollSelection = _G.uiScrollSelection,
  scrollSelectionItem = _G.uiScrollSelectionItem
}

end)()
local nvg = (function()
-- inlined ../nvg
-- wrapper for exposed nanoVG

return {

  ------------------------------------------------------------------------------
  -- nano constants
  ------------------------------------------------------------------------------
  const = {
    hAlign = {
      left = _G.NVG_ALIGN_LEFT,
      center = _G.NVG_ALIGN_CENTER,
      right = _G.NVG_ALIGN_RIGHT
    },
    vAlign = {
      baseline = _G.NVG_ALIGN_BASELINE,
      top = _G.NVG_ALIGN_TOP,
      middle = _G.NVG_ALIGN_MIDDLE,
      bottom = _G.NVG_ALIGN_BOTTOM
    },
    solidity = {
      solid = _G.NVG_SOLID,
      hole = _G.NVG_HOLE
    },
    winding = {
      ccw = _G.NVG_CCW,
      cw = _G.NVG_CW
    }
  },


  -- State
  save = _G.nvgSave,
  restore = _G.nvgRestore,

  -- Font
  fontSize = _G.nvgFontSize,
  fontFace = _G.nvgFontFace,
  fontBlur = _G.nvgFontBlur,
  textWidth = _G.nvgTextWidth,

  -- returns table { minx, miny, maxx, maxy }
  textBounds = _G.nvgTextBounds,

  -- Fill
  fillColor = _G.nvgFillColor,
  fillLinearGradient = _G.nvgFillLinearGradient,
  fillBoxGradient = _G.nvgFillBoxGradient,
  fillRadialGradient = _G.nvgFillRadialGradient,
  fill = _G.nvgFill,

  -- Stroke
  strokeColor = _G.nvgStrokeColor,
  strokeLinearGradient = _G.nvgStrokeLinearGradient,
  strokeBoxGradient = _G.nvgStrokeBoxGradient,
  strokeRadialGradient = _G.nvgStrokeRadialGradient,
  strokeWidth = _G.nvgStrokeWidth,
  stroke = _G.nvgStroke,

  -- Text
  textAlign = _G.nvgTextAlign,
  text = _G.nvgText,

  -- Paths
  beginPath = _G.nvgBeginPath,
  moveTo = _G.nvgMoveTo,
  lineTo = _G.nvgLineTo,
  bezierTo = _G.nvgBezierTo,
  quadTo = _G.nvgQuadTo,
  arcTo = _G.nvgArcTo,
  closePath = _G.nvgClosePath,
  pathWinding = _G.nvgPathWinding,

  -- Primitives
  arc = _G.nvgArc,
  rect = _G.nvgRect,
  roundedRect = _G.nvgRoundedRect,
  ellipse = _G.nvgEllipse,
  circle = _G.nvgCircle,

  -- Scissoring
  scissor = _G.nvgScissor,
  intersectScissor = _G.nvgIntersectScissor,
  resetScissor = _G.nvgResetScissor,

  -- Transform
  translate = _G.nvgTranslate,
  rotate = _G.nvgRotate,
  skewX = _G.nvgSkewX,
  skewY = _G.nvgSkewY,
  scale = _G.nvgScale,

  ------------------------------------------------------------------------------------------------
  --SVG BINDINGS
  ------------------------------------------------------------------------------------------------
  -- NOTE: swapped param names position to be inline with other functions
  svg = function(x, y, name, rad)
    _G.nvgSvg(name, x, y, rad)
  end,

}

end)()
local userData = (function()
-- inlined ../userData
return {
  load = _G.loadUserData,
  save = _G.saveUserData
}

end)()
local funcArray = (function()
-- inlined ../lib/funcArray
local function add(array, value)
    array[#array + 1] = value
end


local function FuncArray(array)

    local result = {
        map = function(func)
            local newTable = {}
            for i = 1, #array do
                newTable[i] = func(array[i], i, array)
            end

            return FuncArray(newTable)
        end,

        filter = function(func)
            local newTable = {}
            for i = 1, #array do
                if func(array[i], i) then
                    newTable[#newTable+1] = array[i]
                end
            end

            return FuncArray(newTable)
        end,

        forEach = function(func)
            for i = 1, #array do
                func(array[i], i, array)
            end
        end,

        reduce = function(func, initialValue)
            for i = 1, #array do
                initialValue = func(initialValue, array[i], i, array);
            end
            return initialValue
        end,

        sort = function(func)
            local newArray = {}
            for i = 1, #array do
                newArray[i] = array[i]
            end
            table.sort(newArray, func)

            return FuncArray(newArray)
        end,

        first = function(func)
            for i = 1, #array do
                if func(array[i], i, array) then
                    return array[i]
                end
            end
        end,

        groupBy = function(func)
            local newArray = FuncArray({})
            for i = 1, #array do
                local key = func(array[i], i, array);
                local match = newArray.first(function(other) return other.key == key end)
                if not match then
                    match = { key = key, values = FuncArray({ array[i] }) }
                    add(newArray.raw, match)
                else
                    add(match.values.raw, array[i]);
                end
            end

            return newArray
        end,

        concat = function(otherArray)
            local result = {}
            for i = 1, #array do
                add(result, array[i])
            end

            if otherArray.raw then otherArray = otherArray.raw end
            for j = 1, #otherArray do
                add(result, otherArray[j])
            end

            return FuncArray(result)
        end,

        -- escape the fancyness
        raw = array
    }

    -- setmetatable(result, {
    --     __len = function() return #array end, -- does not work with lua 5.1
    --     __index = function(v, i)
    --         return array[i]
    --     end,
    --     __newindex = function(v, i, value)
    --         array[i] = value
    --     end
    -- })

    return result
end

return FuncArray;
end)()

local properties = {
  "world",
  "clientGameState",
  "playerIndexCameraAttachedTo",
  "playerIndexLocalPlayer",
  "showScores",
  "players",
  "pickupTimers"
}

local name = ""
local config
local snapshotNames
local snapshotState = {}

local function initOrFixConfig()
  config = config or userData.load() or {}
  if not config.active then config.active = "" end
  if not config.store then config.store = {} end
  if not snapshotNames then
    _G.consolePrint("rebuild")
    snapshotNames = { "" }
    for key in pairs(config.store) do
      _G.consolePrint("Key: " .. key)
      snapshotNames[#snapshotNames+1] = key
    end

  end
end

_G.Emulator = {
  canPosition = false,

  draw = function()
    initOrFixConfig()

    if not config.active or config.active == "" then return end

    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)
    nvg.text(0,0, "EMULATING...");

    funcArray(properties).forEach(function(property)
      _G[property] = config.store[config.active][property]
    end)

  end,

  drawOptions = function(_, x, y)
    initOrFixConfig()

    ui.label("Snapshot", x, y)
    name = ui.editBox(name, x + 120, y, 380)

    local snapshotClicked = ui.button("make snapshot", nil,
      x, y + 40, 500, 40, nil, nil, config.active == "")

    if name ~= "" and snapshotClicked then
      local data = {}
      funcArray(properties).forEach(function(property) data[property] = _G[property] end)

      config.store[name] = data

      -- trigger rebuild
      snapshotNames = nil;
    end

    ui.label("Emulate", x, y + 120)
    config.active = ui.comboBox(snapshotNames, config.active, x + 120, y + 120, 300, snapshotState)

    userData.save(config)

  end

}

_G.registerWidget('Emulator')
