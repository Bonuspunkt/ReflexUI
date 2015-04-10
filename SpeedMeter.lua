require "base/internal/ui/reflexcore"

local colors = {
    Color(255,0,0), -- red
    Color(255,255,0), -- yellow
    Color(127,255,127)   -- bright green
};
local function colorLerp(colorA, colorB, k)
    return Color(
        lerp(colorA.r, colorB.r, k),
        lerp(colorA.g, colorB.g, k),
        lerp(colorA.b, colorB.b, k)
    );
end

local barFillSpeedMeter = 1000;
local barFillWidth = 500;
local barHeight = 48

local textColor = Color(255,255,255,255);

SpeedMeter =
{
    draw = function()

        -- Early out if HUD shouldn't be shown.
        if not shouldShowHUD() then return end;

        -- Find player
        local player = getPlayer();

        --if not player then return end

        local speed = player.speed
        --if not speed then speed = 0 end

        nvgFontSize(52);
        nvgFontFace("TitilliumWeb-Bold");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE );


        local barColor;
        if speed < 320 then
            barColor = colors[1]
        elseif speed < 480 then
            barColor = colorLerp(colors[1], colors[2], (speed - 320) / (480 - 320))
        elseif speed < 520 then
            barColor = colorLerp(colors[2], colors[3], (speed - 480) / (520 - 480))
        else
            barColor = colors[3]
        end

        if speed > 0 then
            nvgFillColor(barColor);
            nvgBeginPath();
            nvgRoundedRect(
                -barFillWidth / 2,
                -barHeight / 2,
                speed / barFillSpeedMeter * barFillWidth,
                barHeight,
                2
            );
            nvgFill()
        end


        nvgFillColor(textColor);
        nvgText(0, 0, math.floor(speed));
    end
};
registerWidget("SpeedMeter");