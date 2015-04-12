require "base/internal/ui/reflexcore"
local reflexMath = require "base/internal/ui/bonus/lib/reflexMath"
local nvg = require "base/internal/ui/bonus/nvg"
local color = require "base/internal/ui/bonus/lib/color"

_G.TrueStack =
{
  draw = function()

    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end;

    -- Find player
    local player = _G.getPlayer();

    local textColor = color.new(255,255,255);

    nvg.fontSize(52);
    nvg.fontFace("TitilliumWeb-Bold");
    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.top);
    nvg.fontBlur(0);
    nvg.fillColor(textColor);


    nvg.text(0, 0, reflexMath.trueStack(player));
  end
};
_G.registerWidget("TrueStack");
