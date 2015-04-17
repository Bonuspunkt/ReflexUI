require "base/internal/ui/reflexcore"
local nvg = require "../nvg"

local config;

_G.JumpWindow =
{
  draw = function()

    local player = _G.getPlayer()

    if not player then return end

    -- loading config
    if not config then config = _G.loadUserData() or {} end

    -- calculating values
    local width = config.width or 20
    local halfWidth = width/2
    local barWidth = width + 20

    -- calculate height
    local jumpTimer = player.jumpTimer
    if jumpTimer >= 400 then jumpTimer = 0 end
    local barHeight = jumpTimer * 0.5;

    if jumpTimer > 0 then
      nvg.beginPath()
      nvg.rect(-halfWidth, 100 - barHeight, width, barHeight)
      nvg.fillColor(_G.Color(255,255,255));
      nvg.fill()
    end

    nvg.fillColor(_G.Color(255,0,0));

    nvg.beginPath()
    nvg.rect(-barWidth/2, -100, barWidth, 2)
    nvg.fill()

    nvg.beginPath()
    nvg.rect(-barWidth/2, 100, barWidth, 2)
    nvg.fill()
  end,

  -- option menu :D
  drawOptions = function(self, x, y)
    if not config then config = _G.loadUserData() or {} end
    if not config.width then config.width = 20 end

    uiLabel("Width:", x, y);
    config.width = math.floor(uiSlider(x + 80, y, 200, 1, 120, config.width));
    config.width = math.floor(uiEditBox(config.width, x + 290, y, 80));

    saveUserData(config)

  end
};
_G.registerWidget("JumpWindow");
