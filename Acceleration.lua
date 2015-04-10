require "base/internal/ui/reflexcore"
local Averager = require "base/internal/ui/bonus/_Averager"

-- config
local barHeight = 50
local barColor = Color(255,255,255,255)
local oldSpeed = 0
local multiplier = 10
local averageDuration = 10

--
local avg = Averager(averageDuration)

Acceleration =
{
    draw = function()

        -- Early out if HUD shouldn't be shown.
        if not shouldShowHUD() then return end;

        -- Find player
        local player = getPlayer();
        local speed = player.speed;

        local deltaSpeed = speed - oldSpeed;

        avg.add(deltaSpeed);
        deltaSpeed = avg.get();

        local barWidth = deltaSpeed * multiplier;

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

        nvgFillColor(barColor);
        nvgFill()

        oldSpeed = speed;
    end
};

registerWidget("Acceleration");