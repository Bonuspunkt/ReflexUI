require "base/internal/ui/reflexcore"

ShowKeys =
{
    draw = function()

        -- no player => no crosshair
        local player = getPlayer();
        if player == nil then return end;

        -- editor => no crosshair
        if player.state == PLAYER_STATE_EDITOR then return end

        nvgFillColor(Color(255,255,255));
        nvgFontSize(FONT_SIZE_DEFAULT);
        nvgFontFace("ProFontWindows");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);

        if player.buttons.forward then
            nvgText(0, -20, "^");
        end
        if player.buttons.back then
            nvgText(0, 20, "v");
        end
        if player.buttons.left then
            nvgText(-20, 0, "<");
        end
        if player.buttons.right then
            nvgText(20, 0, ">");
        end
        if player.buttons.jump then
            nvgText(-20, 40, "J");
        end
        if player.buttons.attack then
            nvgText(20, 40, "A");
        end

    end
};
registerWidget("ShowKeys");