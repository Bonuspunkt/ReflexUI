require "base/internal/ui/reflexcore"
local reflexMath = require "base/internal/ui/bonus/_ReflexMath"

TrueStack =
{
    draw = function()

        -- Early out if HUD shouldn't be shown.
        if not shouldShowHUD() then return end;

        -- Find player
        local player = getPlayer();

        local textColor = Color(255,255,255,255);

        nvgFontSize(52);
        nvgFontFace("TitilliumWeb-Bold");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);
        nvgFontBlur(0);
        nvgFillColor(textColor);


        nvgText(0, 0, reflexMath.trueStack(player));
    end
};
registerWidget("TrueStack");