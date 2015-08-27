require "base/internal/ui/reflexcore"
local nvg = require "../nvg"
local userData = require "../userData"
local ui = require "../ui"

local directionDown = 'down'
local directionUp = 'up'
local directions = { directionDown, directionUp }
local directionState = {}

local config
local widgetName = "bonusGameTimer"
local widget = {
  initialize = function()
    config = userData.load() or {}
    if not config.direction then config.direction = directions[1] end
  end,

  drawOptions = function(_, x, y)
    ui.label("Direction", x, y)
    config.direction = ui.comboBox(directions, config.direction, x + 80, y, 290, directionState)

    userData.save(config)
  end,

  draw = function()
    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end

    if (_G.world.gameState ~= _G.GAME_STATE_ACTIVE) and
      (_G.world.gameState ~= _G.GAME_STATE_ROUNDACTIVE) then
      return
    end

    local timeRemaining = _G.world.gameTimeLimit - _G.world.gameTime
    if timeRemaining < 0 then
      timeRemaining = 0
    end

    local t;
    if config.direction == directionUp then
      t = _G.FormatTime(_G.world.gameTime)
    else
      t = _G.FormatTime(timeRemaining)
    end
    local textTime = string.format("%d:%02d", t.minutes, t.seconds)

    local fontSize = 52

    -- Colors
    local frameColor = _G.Color(0,0,0,64)
    local textColor = _G.Color(255,255,255,255)
    local lowTimeFrameColor = _G.Color(200,0,0,64)
    local lowTimeTextColor = _G.Color(255,255,255,255)

    -- Options
    local lowTime = 30000; -- in milliseconds

    if timeRemaining < lowTime then
      frameColor = lowTimeFrameColor
      textColor = lowTimeTextColor
    end

    -- Background
    nvg.beginPath();
    nvg.rect(-fontSize, 0, fontSize * 2, fontSize)
    nvg.fillColor(frameColor)
    nvg.fill()

    -- Text
    nvg.fontSize(52)
    nvg.fontFace("TitilliumWeb-Bold")
    nvg.textAlign(_G.NVG_ALIGN_CENTER, _G.NVG_ALIGN_TOP)
    nvg.fontBlur(0)
    nvg.fillColor(textColor)
    nvg.text(0, 0, textTime)
  end
};


_G[widgetName] = widget
_G.registerWidget(widgetName)
