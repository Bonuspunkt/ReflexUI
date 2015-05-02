require "base/internal/ui/reflexcore"
local nvg = require "../nvg"
local ui = require "../ui"
local userData = require "../userData"
local color = require "../lib/color"
local position = require "../lib/position"

local frameColor = color.new(0,0,0,128)

local directionLTR = "left to right"
local directionRTL = "right to left"
local directions = { directionLTR, directionRTL }

local textLeft = "left"
local textRight = "right"
local textNone = "none"
local textDisplay = { textLeft, textRight, textNone }


return function(options)

  local directionState = {}
  local textDisplayState = {}

  local config

  return {
    initialize = function()
      config = config or userData.load() or {}
      if not config.width then config.width = 500 end
      if not config.height then config.height = 100 end
      if not config.padding then config.padding = 8 end
      if not config.direction then config.direction = directionLTR end
      if not config.depth then config.depth = 64 end
      if not config.textDisplay then config.textDisplay = textLeft end
    end,

    draw = function()
      -- Early out if HUD shouldn't be shown.
      if not _G.shouldShowHUD() then return end

    	local player = _G.getPlayer()

      local value = options.getValue(player)
      local barColor = options.getColor(player)

      local padding = config.padding

      local left, top = position(options.name, config.width, config.height)

      nvg.fontFace(_G.FONT_HUD);
      nvg.fontSize( config.height )
      nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)
      local bounds = nvg.textBounds("888")
      local textWidth = bounds.maxx - bounds.minx

      -- draw frame
      nvg.beginPath()
      nvg.roundedRect(left, top, config.width, config.height, 5)
      nvg.fillColor(frameColor)
      nvg.fill()

      local textX
      local barX
      local maxBarWidth
      if config.textDisplay == textLeft then
        textX = left + padding + textWidth/2
        barX = left + 2 * padding + textWidth
        maxBarWidth = config.width - 3 * padding - textWidth
      elseif config.textDisplay == textRight then
        textX = left + config.width - padding - textWidth / 2
        barX = left + padding
        maxBarWidth = config.width - 3 * padding - textWidth
      else
        barX = left + padding
        maxBarWidth = config.width - 2 * padding
      end


      local barHeight = (config.height - 3 * padding) / 2


      local function drawBar(x, y, maxWidth, height, percentage)
        local drawWidth = math.min(1, percentage / 100) * maxBarWidth
        if config.direction == directionRTL then
          x = x + maxWidth - drawWidth
        end

        nvg.beginPath()
        nvg.roundedRect(x, y, drawWidth, barHeight, 2)
        nvg.fillColor(barColor)
        nvg.fill()

        nvg.beginPath();
        nvg.rect(x, y, drawWidth, height/2);
        nvg.fillLinearGradient(x, y, x, y + height/2,
          color.new(255,255,255, config.depth), color.new(255,255,255,0))
        nvg.fill();
        nvg.beginPath();
        nvg.rect(x, y + height/2, drawWidth, height/2);
        nvg.fillLinearGradient(x, y + height/2, x, y + height,
          color.new(0,0,0,0), color.new(0,0,0, config.depth))
        nvg.fill();
      end


      if value > 0 then
        drawBar(barX, top + barHeight + 2 * padding, maxBarWidth, barHeight, math.min(100, value))
      end
      if value > 100 then
        drawBar(barX, top + padding, maxBarWidth, barHeight, value - 100)
      end

      if config.textDisplay ~= textNone then
        nvg.fillColor(color.new(255,255,255))
        nvg.text(textX, top + config.height/2, value)
      end

    end,

    drawOptions = function(_, x, y)
      y = y + 10

      local sliderOffset = 80
      local sliderWidth = 200
      local textBoxOffset = 290
      local textBoxWidth = 80

      ui.label("Width", x, y)
      config.width = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 150, 800, config.width))
      config.width = ui.editBox(config.width, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      ui.label("Height", x, y)
      config.height = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 20, 200, config.height))
      config.height = ui.editBox(config.height, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      ui.label("Padding", x, y)
      config.padding = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 0, 40, config.padding))
      config.padding = ui.editBox(config.padding, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      ui.label("Depth", x, y)
      config.depth = math.floor(ui.slider(x + sliderOffset, y, sliderWidth, 0, 127, config.depth))
      config.depth = ui.editBox(config.depth, x + textBoxOffset, y, textBoxWidth)
      y = y + 40

      local directionY = y
      y = y + 40

      ui.label("Number", x, y)
      config.textDisplay = ui.comboBox(textDisplay, config.textDisplay, x + 80, y, 290, textDisplayState)

      ui.label("Direction", x, directionY)
      config.direction = ui.comboBox(directions, config.direction, x + 80, directionY, 290, directionState)

      userData.save(config)
    end
  }
end
