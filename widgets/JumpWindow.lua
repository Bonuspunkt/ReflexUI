require "base/internal/ui/reflexcore"
local nvg = require "../nvg"

_G.JumpWindow =
{
  draw = function()

    local player = _G.getPlayer()

    if not player then return end

    -- calculate height
    local jumpTimer = player.jumpTimer
    if jumpTimer >= 400 then jumpTimer = 0 end
    local barHeight = jumpTimer * 0.5;

    if jumpTimer > 0 then
      nvg.beginPath()
      nvg.rect(-10, 100 - barHeight, 20, barHeight)
      nvg.fillColor(_G.Color(255,255,255));
      nvg.fill()
    end

    nvg.fillColor(_G.Color(255,0,0));

    nvg.beginPath()
    nvg.rect(-20, -100, 40, 2)
    nvg.fill()

    nvg.beginPath()
    nvg.rect(-20, 100, 40, 2)
    nvg.fill()
end
};
_G.registerWidget("JumpWindow");
