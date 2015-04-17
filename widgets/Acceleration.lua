require "base/internal/ui/reflexcore"
local color = require "base/internal/ui/bonus/lib/color"
local averager = require "base/internal/ui/bonus/lib/averager"
local nvg = require "base/internal/ui/bonus/nvg"

-- config
local barHeight = 50
local barColor = color.new(255,255,255)
local multiplier = 10
local averageDuration = 10

local oldSpeed = 0

local avg = averager(averageDuration)

_G.Acceleration =
{
  draw = function()

    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end;

    -- Find player
    local player = _G.getPlayer();
    local speed = player.speed;

    local deltaSpeed = speed - oldSpeed;

    avg.add(deltaSpeed);
    deltaSpeed = avg.get();

    local barWidth = deltaSpeed * multiplier;

    nvg.beginPath();


    if deltaSpeed > 0 then
      nvg.roundedRect(
        0,
        -barHeight / 2,
        barWidth,
        barHeight,
        2
      );
    elseif deltaSpeed < 0 then
      nvg.roundedRect(
        barWidth,
        -barHeight / 2,
        -barWidth,
        barHeight,
        2
      );
    end

    nvg.fillColor(barColor);
    nvg.fill()

    oldSpeed = speed;
  end
};

_G.registerWidget("Acceleration");
