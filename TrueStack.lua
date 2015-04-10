require "base/internal/ui/reflexcore"

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

        local armorProtection = player.armorProtection + 1;

        local maxDamage =
            math.min(player.armor, player.health * armorProtection) +
            player.health;

        nvgText(0, 0, maxDamage);
    end
};
registerWidget("TrueStack");