local color = require "../lib/color"
local barFactory = require "./barFactory"

local widgetName = "BonusHealthBar"
local barAlpha = 160;

local BonusHealthBar = barFactory({

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

_G[widgetName] = BonusHealthBar
_G.registerWidget(widgetName)
