local color = require "../lib/color"
local barFactory = require "./barFactory"

local widgetName = "BonusArmorBar"
local barAlpha = 160;
local barColors = {
  color.new(2,167,46, barAlpha),
  color.new(245,215,50, barAlpha),
  color.new(236,0,0, barAlpha)
}

local BonusArmorBar = barFactory({

  name = widgetName,
  getValue = function(player)
    return player.armor
  end,

  getColor = function(player)
    return barColors[player.armorProtection + 1]
  end
})

_G[widgetName] = BonusArmorBar
_G.registerWidget(widgetName)
