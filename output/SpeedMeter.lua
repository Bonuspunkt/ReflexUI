require "base/internal/ui/reflexcore"
local color = (function()
-- inlined base/internal/ui/bonus/lib/color
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
local nvg = (function()
-- inlined base/internal/ui/bonus/nvg
-- wrapper for exposed nanoVG

return {

  ------------------------------------------------------------------------------
  -- nano constants
  ------------------------------------------------------------------------------
  const = {
    hAlign = {
      left = 0,
      center = 1,
      right = 2
    },
    vAlign = {
      baseline = 0,
      top = 1,
      middle = 2,
      bottom = 3
    },
    solidity = {
      solid = 1,
      hole = 2
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
local const = (function()
-- inlined base/internal/ui/bonus/const
return {
  state = {
    disconnect = 0,
    connecting = 1,
    connected = 2
  },
  -- see players[1].state
  gameState = {
    warmup = 0,
    active = 1,
    roundPrepare = 2,
    roundActive = 3,
    roundCooldownSomeoneWon = 4,
    roundCooldownDraw = 5,
    gameover = 6
  },
  -- see world.gameState
  playerState = {
    ingame = 1,
    spectator = 2,
    editor = 3,
    queued = 4
  },
  -- see pickupTimers[1].type
  pickupType = {
    burstGun = 0,
    shotgun = 1,
    grenadeLauncher = 2,
    machineGun = 3,
    rocketLauncer = 4,
    ionCannon = 5,
    boltRifle = 6,
    stakeGun = 7,

    health5 = 40,
    health25 = 41,
    health50 = 42,
    health100 = 43,

    armor5 = 50,
    armor50 = 51,
    armor100 = 52,
    armor150 = 53,

    powerupCarnage = 60
  },

  font = {
    header = "oswald-bold";
    hud = "oswald-bold";
    text = "roboto-regular";
    textBold = "roboto-bold";
    sizeDefault = 24;
    sizeSmall = 22;
  }
}

end)()

local colors = {
  color.new(255,0,0), -- red
  color.new(255,255,0), -- yellow
  color.new(127,255,127)   -- bright green
};

local barFillSpeedMeter = 1000;
local barFillWidth = 500;
local barHeight = 48

local textColor = color.new(255,255,255,255);

_G.SpeedMeter =
{
  draw = function()
    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end;

    -- Find player
    local player = _G.getPlayer();

    --if not player then return end

    local speed = player.speed
    --if not speed then speed = 0 end

    nvg.fontSize(52);
    nvg.fontFace(const.font.textBold)
    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle);


    local barColor;
    if speed < 320 then
        barColor = colors[1]
    elseif speed < 480 then
        barColor = color.lerp(colors[1], colors[2], (speed - 320) / (480 - 320))
    elseif speed < 520 then
        barColor = color.lerp(colors[2], colors[3], (speed - 480) / (520 - 480))
    else
        barColor = colors[3]
    end

    if speed > 0 then
      nvg.fillColor(barColor);
      nvg.beginPath();
      nvg.roundedRect(
        -barFillWidth / 2,
        -barHeight / 2,
        speed / barFillSpeedMeter * barFillWidth,
        barHeight,
        2
      );
      nvg.fill()
    end

    nvg.fillColor(textColor);
    nvg.text(0, 0, math.floor(speed));
  end
};
_G.registerWidget("SpeedMeter");
