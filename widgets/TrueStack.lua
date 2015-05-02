require "base/internal/ui/reflexcore"
local nvg = require "../nvg"
local ui = require "../ui"
local userData = require "../userData"
local color = require "../lib/color"
local reflexMath = require "../lib/reflexMath"

local config = {}
local circleColorState = {}
local textColorState = {}

_G.TrueStack =
{

  initialize = function()
    config = userData.load() or {
      showCircle = true,
      circleColor = color.new(0,127,0, 127),
      radius = 100,
      width = 40,

      showNumber = false,
      fontSize = 40,
      textColor = color.new(255,255,255)
    };
  end,

  drawOptions = function(_, x, y)
    local sliderOffsetX = 120
    local sliderWidth = 320
    local textWidth = 80

    config.showCircle = ui.checkBox(config.showCircle or false, "Show Circle", x, y)
    y = y + 40

    if config.showCircle then
      ui.label("Circle Color", x, y)
      config.circleColor = ui.colorPicker(x, y + 30, config.circleColor, circleColorState)
      y = y + 270

      ui.label("Radius", x, y)
      config.radius = round(ui.slider(x + sliderOffsetX, y, sliderWidth, 10, 500, config.radius))
      config.radius = round(ui.editBox(config.radius, x + sliderWidth + sliderOffsetX + 10, y, textWidth))
      y = y + 40

      ui.label("Width", x, y)
      config.width = round(ui.slider(x + sliderOffsetX, y, sliderWidth, 10, 500, config.width))
      config.width = round(ui.editBox(config.width, x + sliderWidth + sliderOffsetX + 10, y, textWidth))
      y = y + 40
    end

    config.showNumber = ui.checkBox(config.showNumber or false, "Show Number", x, y)
    y = y + 40

    if config.showNumber then
      ui.label("Font Size", x, y)
      config.fontSize = round(ui.slider(x + sliderOffsetX, y, sliderWidth, 10, 500, config.fontSize))
      config.fontSize = round(ui.editBox(config.fontSize, x + sliderWidth + sliderOffsetX + 10, y, textWidth))
      y = y + 40

      ui.label("Text Color", x, y)
      config.textColor = ui.colorPicker(x, y + 30, config.textColor, textColorState)
    end

    saveUserData(config)
  end,

  getOptionsHeight = function()
    local result = 90
    if config.showCircle then
      result = result + 360
    end
    if config.showNumber then
      result = result + 340
    end
    return result
  end,

  draw = function()

    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end;

    -- Find player
    local player = _G.getPlayer();

    local trueStack = reflexMath.trueStack(player);

    if config.showCircle then
      local arcEnd = trueStack / 400 * 2 * math.pi
      local radius = config.radius + config.width / 2

      nvg.beginPath();
      nvg.arc(0, 0, config.radius - 1, 0, arcEnd, nvg.const.winding.cw)
      nvg.strokeWidth(2)
      nvg.strokeColor(color.new(0,0,0, config.circleColor.a))
      nvg.stroke()

      nvg.beginPath();
      nvg.arc(0, 0, config.radius + config.width, 0, arcEnd, nvg.const.winding.cw)
      nvg.strokeWidth(2)
      nvg.strokeColor(color.new(0,0,0, config.circleColor.a))
      nvg.stroke()

      nvg.beginPath();
      nvg.arc(0, 0, radius, 0, arcEnd, nvg.const.winding.cw)
      nvg.strokeWidth(config.width)
      nvg.strokeColor(config.circleColor)
      nvg.stroke()
    end

    if config.showNumber then
      nvg.fontFace("TitilliumWeb-Bold");
      nvg.fontSize(config.fontSize);
      nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle);
      nvg.fillColor(config.textColor);
      nvg.text(0, 0, trueStack);
    end

  end
};
_G.registerWidget("TrueStack");
