local color = (function()
-- inlined ../lib/color
require "base/internal/ui/reflexcore"

local lerp = function(a, b, k)
  return a * (1 - k) + b * k;
end

local Color = _G.Color

return {
  new = function(r,g,b,a)
    return Color(r,g,b,a)
  end,

  lerp = function(colorA, colorB, k)
    return Color(
      lerp(colorA.r, colorB.r, k),
      lerp(colorA.g, colorB.g, k),
      lerp(colorA.b, colorB.b, k),
      lerp(colorA.a, colorB.a, k)
    )
  end
}

end)()
local barFactory = (function()
-- inlined ./barFactory
require "base/internal/ui/reflexcore"
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
  comboBox = _G.uiComboxBox,

  scrollSelection = _G.uiScrollSelection,
  scrollSelectionItem = _G.uiScrollSelectionItem
}

end)()
local userData = (function()
-- inlined ../userData
return {
  load = _G.loadUserData,
  save = _G.saveUserData
}

end)()
local color = (function()
-- inlined ../lib/color
require "base/internal/ui/reflexcore"

local lerp = function(a, b, k)
  return a * (1 - k) + b * k;
end

local Color = _G.Color

return {
  new = function(r,g,b,a)
    return Color(r,g,b,a)
  end,

  lerp = function(colorA, colorB, k)
    return Color(
      lerp(colorA.r, colorB.r, k),
      lerp(colorA.g, colorB.g, k),
      lerp(colorA.b, colorB.b, k),
      lerp(colorA.a, colorB.a, k)
    )
  end
}

end)()
local position = (function()
-- inlined ../lib/position
local funcArray = (function()
-- inlined ./funcArray
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

local function position(widgetName, width, height)
  local widget = funcArray(_G.widgets).first(function(w) return w.name == widgetName end)
  local anchor = widget.anchor;

  local left = -(anchor.x + 1) * width / 2;
  local top = -(anchor.y + 1) * height / 2;

  return left, top
end

return position

end)()

local frameColor = color.new(0,0,0,128)

local directionLTR = "left to right"
local directionRTL = "right to left"
local directions = { directionLTR, directionRTL }

local textLeft = "left"
local textRight = "right"
local textNone = "none"
local textDisplay = { textLeft, textRight, textNone }


return function(options)

  local directionState = {}
  local textDisplayState = {}

  local config

  local function initOrFixConfig()
    config = config or userData.load() or {}
    if not config.width then config.width = 500 end
    if not config.height then config.height = 100 end
    if not config.padding then config.padding = 8 end
    if not config.direction then config.direction = directionLTR end
    if not config.depth then config.depth = 64 end
    if not config.textDisplay then config.textDisplay = textLeft end
  end

  return {
    draw = function()
      initOrFixConfig()

      -- Early out if HUD shouldn't be shown.
      if not _G.shouldShowHUD() then return end

    	local player = _G.getPlayer()

      local value = options.getValue(player)
      local barColor = options.getColor(player)

      local padding = config.padding

      local left, top = position(options.name, config.width, config.height)

      nvg.fontFace(_G.FONT_HUD);
      nvg.fontSize( config.height )
      nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)
      local bounds = nvg.textBounds("888")
      local textWidth = bounds.maxx - bounds.minx

      -- draw frame
      nvg.beginPath()
      nvg.roundedRect(left, top, config.width, config.height, 5)
      nvg.fillColor(frameColor)
      nvg.fill()

      local textX
      local barX
      local maxBarWidth
      if config.textDisplay == textLeft then
        textX = left + padding + textWidth/2
        barX = left + 2 * padding + textWidth
        maxBarWidth = config.width - 3 * padding - textWidth
      elseif config.textDisplay == textRight then
        textX = left + config.width - padding - textWidth / 2
        barX = left + padding
        maxBarWidth = config.width - 3 * padding - textWidth
      else
        barX = left + padding
        maxBarWidth = config.width - 2 * padding
      end


      local barHeight = (config.height - 3 * padding) / 2


      local function drawBar(x, y, maxWidth, height, percentage)
        local drawWidth = math.min(1, percentage / 100) * maxBarWidth
        if config.direction == directionRTL then
          x = x + maxWidth - drawWidth
        end

        nvg.beginPath()
        nvg.roundedRect(x, y, drawWidth, barHeight, 2)
        nvg.fillColor(barColor)
        nvg.fill()

        nvg.beginPath();
        nvg.rect(x, y, drawWidth, height/2);
        nvg.fillLinearGradient(x, y, x, y + height/2,
          color.new(255,255,255, config.depth), color.new(255,255,255,0))
        nvg.fill();
        nvg.beginPath();
        nvg.rect(x, y + height/2, drawWidth, height/2);
        nvg.fillLinearGradient(x, y + height/2, x, y + height,
          color.new(0,0,0,0), color.new(0,0,0, config.depth))
        nvg.fill();
      end


      if value > 0 then
        drawBar(barX, top + barHeight + 2 * padding, maxBarWidth, barHeight, math.min(100, value))
      end
      if value > 100 then
        drawBar(barX, top + padding, maxBarWidth, barHeight, value - 100)
      end

      if config.textDisplay ~= textNone then
        nvg.fillColor(color.new(255,255,255))
        nvg.text(textX, top + config.height/2, value)
      end

    end,

    drawOptions = function(_, x, y)
      initOrFixConfig()

      y = y + 10

      local sliderOffset = 80
      local sliderWidth = 200
      local textBoxOffset = 290
      local textBoxWidth = 80

      ui.label("Width", x, y)
      config.width = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 150, 800, config.width))
      config.width = ui.editBox(config.width, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      ui.label("Height", x, y)
      config.height = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 20, 200, config.height))
      config.height = ui.editBox(config.height, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      ui.label("Padding", x, y)
      config.padding = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 0, 40, config.padding))
      config.padding = ui.editBox(config.padding, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      ui.label("Depth", x, y)
      config.depth = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 0, 127, config.depth))
      config.depth = ui.editBox(config.depth, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      local directionY = y
      y = y + 40

      ui.label("Number", x, y)
      config.textDisplay = ui.comboBox(textDisplay, config.textDisplay, x + 80, y, 290, textDisplayState)

      ui.label("Direction", x, directionY)
      config.direction = ui.comboBox(directions, config.direction, x + 80, directionY, 290, directionState)

      userData.save(config)
    end
  }
end

end)()

local widgetName = "BonusArmorBar"
local barAlpha = 160;
local barColors = {
  color.new(2,167,46, barAlpha),
  color.new(245,215,50, barAlpha),
  color.new(236,0,0, barAlpha)
}

local BonusArmorBar = barFactory({

  name = widgetName,
  getValue = function(player)
    return player.armor
  end,

  getColor = function(player)
    return barColors[player.armorProtection + 1]
  end
})

_G[widgetName] = BonusArmorBar
_G.registerWidget(widgetName)
