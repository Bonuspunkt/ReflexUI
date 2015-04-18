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

local config;

_G.JumpWindow =
{
  draw = function()

    local player = _G.getPlayer()

    if not player then return end

    -- loading config
    if not config then config = _G.loadUserData() or {} end

    -- calculating values
    local width = config.width or 20
    local halfWidth = width/2
    local barWidth = width + 20

    -- calculate height
    local jumpTimer = player.jumpTimer
    if jumpTimer >= 400 then jumpTimer = 0 end
    local barHeight = jumpTimer * 0.5;

    if jumpTimer > 0 then
      nvg.beginPath()
      nvg.rect(-halfWidth, 100 - barHeight, width, barHeight)
      nvg.fillColor(_G.Color(255,255,255));
      nvg.fill()
    end

    nvg.fillColor(_G.Color(255,0,0));

    nvg.beginPath()
    nvg.rect(-barWidth/2, -100, barWidth, 2)
    nvg.fill()

    nvg.beginPath()
    nvg.rect(-barWidth/2, 100, barWidth, 2)
    nvg.fill()
  end,

  -- option menu :D
  drawOptions = function(self, x, y)
    if not config then config = _G.loadUserData() or {} end
    if not config.width then config.width = 20 end

    uiLabel("Width:", x, y);
    config.width = math.floor(uiSlider(x + 80, y, 200, 1, 120, config.width));
    config.width = math.floor(uiEditBox(config.width, x + 290, y, 80));

    saveUserData(config)

  end
};
_G.registerWidget("JumpWindow");
