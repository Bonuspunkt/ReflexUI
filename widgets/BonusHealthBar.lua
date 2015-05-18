local color = require "../lib/color"
local barFactory = require "./barFactory"

local widgetName = "bonusHealthBar"
local barAlpha = 160;

local widget = barFactory({

  name = widgetName,
  getValue = function(player)
    return player.health
  end,

  getColor = function(player)
    if player.hasMega then
      return color.new(16,116,217, barAlpha)
    else
      return color.new(2,167,46, barAlpha)
    end
  end
})

_G[widgetName] = widget
_G.registerWidget(widgetName)
