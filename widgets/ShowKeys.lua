require "base/internal/ui/reflexcore"
local color = require "base/internal/ui/bonus/lib/color"
local const = require "base/internal/ui/bonus/const"
local nvg = require "base/internal/ui/bonus/nvg"

_G.ShowKeys =
{
    draw = function()

        -- no player => no crosshair
        local player = _G.getPlayer();
        if player == nil then return end;

        -- editor => no crosshair
        if player.state == const.playerState.editor then return end

        nvg.fillColor(color.new(255,255,255));
        nvg.fontFace(const.font.text);
        nvg.fontSize(const.font.sizeDefault);
        nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle);

        if player.buttons.forward then
            nvg.text(0, -20, "^");
        end
        if player.buttons.back then
            nvg.text(0, 20, "v");
        end
        if player.buttons.left then
            nvg.text(-20, 0, "<");
        end
        if player.buttons.right then
            nvg.text(20, 0, ">");
        end
        if player.buttons.jump then
            nvg.text(-20, 40, "J");
        end
        if player.buttons.attack then
            nvg.text(20, 40, "A");
        end

    end
};
_G.registerWidget("ShowKeys");
