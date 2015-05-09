require "base/internal/ui/reflexcore"
local nvg = require "../nvg"
local ui = require "../ui"
local userData = require "../userData"
local color = require "../lib/color"

local config;

_G.JumpWindow = {
  initialize = function()
    config = config or userData.load() or {}
    if not config.width then config.width = 20 end
  end,

  drawOptions = function(_, x, y)

    ui.label("Width:", x, y);
    config.width = math.floor(ui.slider(x + 80, y, 200, 1, 120, config.width));
    config.width = math.floor(ui.editBox(config.width, x + 290, y, 80));

    userData.save(config)

  end,

  draw = function()

    local player = _G.getPlayer()

    if not player then return end

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
      nvg.fillColor(color.new(255,255,255));
      nvg.fill()
    end

    nvg.strokeColor(color.new(0,0,0));
    nvg.strokeWidth(2)

    nvg.beginPath();
    nvg.moveTo(-barWidth/2, -100);
    nvg.lineTo(barWidth/2, -100);
    nvg.stroke();

    nvg.beginPath();
    nvg.moveTo(-barWidth/2, 100);
    nvg.lineTo(barWidth/2, 100);
    nvg.stroke();
  end,

  -- option menu :D
};
_G.registerWidget("JumpWindow");
