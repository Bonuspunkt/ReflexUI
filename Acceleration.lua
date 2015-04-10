require "base/internal/ui/reflexcore"

local barHeight = 50;
local barColor = Color(255,255,255,255);
local oldSpeed = 0;
local multiplier = 10;

Acceleration =
{
    draw = function()

        -- Early out if HUD shouldn't be shown.
        if not shouldShowHUD() then return end;

        -- Find player
        local player = getPlayer();
        local speed = player.speed;

        local deltaSpeed = speed - oldSpeed;
        local barWidth = deltaSpeed * multiplier;

        nvgFillColor(barColor);
        nvgBeginPath();


        if deltaSpeed > 0 then
            nvgRoundedRect(
                0,
                -barHeight / 2,
                barWidth,
                barHeight,
                2
            );
        elseif deltaSpeed < 0 then
            nvgRoundedRect(
                barWidth,
                -barHeight / 2,
                -barWidth,
                barHeight,
                2
            );
        end

        nvgFill()

        oldSpeed = speed;
    end
};

registerWidget("Acceleration");