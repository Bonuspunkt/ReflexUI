require "base/internal/ui/reflexcore"
local color = require "base/internal/ui/bonus/lib/color"
local nvg = require "base/internal/ui/bonus/nvg"
local const = require "base/internal/ui/bonus/const"

local colors = {
  color.new(255,0,0), -- red
  color.new(255,255,0), -- yellow
  color.new(127,255,127)   -- bright green
};

local barFillSpeedMeter = 1000;
local barFillWidth = 500;
local barHeight = 48

local textColor = color.new(255,255,255,255);

local widgetName = "bonusSpeedMeter"
local widget =
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

_G[widgetName] = widget
_G.registerWidget(widgetName);
