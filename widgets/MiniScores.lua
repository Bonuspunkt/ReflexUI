require "base/internal/ui/reflexcore"
local const = require "../const"
local nvg = require "../nvg"
local ui = require "../ui"
local userData = require "../userData"
local color = require "../lib/color"
local funcArray = require "../lib/funcArray"
local position = require "../lib/position"

local ORIENTATION_HORZ = "Horizontal"
local ORIENTATION_VERT = "Vertical"

local TEXT_LEFT = "Left"
local TEXT_CENTER = "Center"
local TEXT_RIGHT = "Right"
local textAlign = { TEXT_LEFT, TEXT_CENTER, TEXT_RIGHT }

local textAlignState = {}
local ourColorState = {}
local diffColorState = {}
local theirColorState = {}
local config

local function formatRaceScore(score)

  if score == 0 then return 'dnf' end

  local ms = score % 1000;
	score = math.floor(score / 1000);
	local seconds = score % 60;
	score = math.floor(score / 60);
	local minutes = score % 60;

  if minutes > 0 then
	  return string.format("%d:%02d.%03d", minutes, seconds, ms)
  else
    return string.format("%d.%03d", seconds, ms)
  end
end

local widgetName = "bonusMiniScores"
local widget = {

  initialize = function()
    if not config then config = userData.load() or {} end

    if not config.ourColor then config.ourColor = color.new(64,64,255,64) end
    if not config.diffColor then config.diffColor = color.new(255,255,255,64) end
    if not config.theirColor then config.theirColor = color.new(255,64,64,64) end
    if not config.orientation then config.orientation = ORIENTATION_HORZ end
    if not config.textAlign then config.textAlign = TEXT_CENTER end
  end,

  drawOptions = function(_, x, y)

    ui.label("Text align", x, y)
    config.textAlign = ui.comboBox(textAlign, config.textAlign, x + 120, y, 255, textAlignState)
    y = y + 40

    config.orientation = ui.checkBox(config.orientation == ORIENTATION_VERT, "Vertical", x, y) and ORIENTATION_VERT or ORIENTATION_HORZ
    y = y + 40

    ui.label("Your Score", x, y)
    config.ourColor = ui.colorPicker(x, y + 30, config.ourColor, ourColorState)
    y = y + 260


    config.showDiff = ui.checkBox(config.showDiff or false, "Show Diff", x, y)
    y = y + 30

    if config.showDiff then
      ui.label("Score difference", x, y)
      config.diffColor = ui.colorPicker(x, y + 30, config.diffColor, diffColorState)
      y = y + 260
    end

    ui.label("Other Score", x, y)
    config.theirColor = ui.colorPicker(x, y + 30, config.theirColor, theirColorState)

    userData.save(config);
  end,

  getOptionsHeight = function()
    local result = 600
    if config.showDiff then
      result = result + 270
    end
    return result
  end,

  draw = function()

    -- Early out if HUD should not be shown.
    if not _G.shouldShowHUD() then return end

    -- Find player
    local player = _G.getPlayer()

    local textColor = color.new(255,255,255)

    nvg.fontFace(const.font.textBold)
    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)

    local activePlayers = funcArray(_G.players).filter(
      function(p)
        return p.state == const.playerState.ingame
          and p.connected;
      end
    )

    local ourScore;
    local theirScore;
    local boundText = "-888"
    local formatScore = function(score) return score end
    local formatDiff = function(diff) return diff end
    local gameMode = _G.gamemodes[_G.world.gameModeIndex].shortName

    if gameMode == "tdm" or gameMode == "atdm" then
      ourScore = activePlayers
        .filter(function(p) return player.team == p.team end)
        .map(function(p) return p.score end)
        .reduce(function(prev, curr) return prev + curr end, 0)
      theirScore = activePlayers
        .filter(function(p) return player.team ~= p.team end)
        .map(function(p) return p.score end)
        .reduce(function(prev, curr) return prev + curr end, 0)

    elseif gameMode == "1v1" then
      ourScore = player.score;
      theirScore = activePlayers
        .filter(function(p) return player ~= p end)
        .map(function(p) return p.score; end)
        .reduce(function(prev, curr) return prev + curr end, 0)

    elseif gameMode == "a1v1" or gameMode == "ffa" or gameMode == "affa" then
      ourScore = player.score;
      theirScore = activePlayers
        .filter(function(p) return player ~= p; end)
        .map(function(p) return p.score; end)
        .reduce(function(prev, curr) return math.max(prev, curr) end, 0)

    elseif gameMode == "race" then
      ourScore = player.score;
      theirScore = activePlayers
        .filter(function(p) return player ~= p; end)
        .map(function(p) return p.score; end)
        .reduce(function(prev, curr) return math.min(prev, curr) end, 999999)

      boundText = "+00:00.000"
      formatDiff = function (diff)
        if diff > 0 then
          return "+" .. formatScore(diff)
        else
          return "-" .. formatScore(-diff)
        end
      end
      formatScore = formatRaceScore;
    else
      -- NOTE: not supported yet
      return
    end

    -- calculate positions
    nvg.fontSize(64);
    local size = nvg.textBounds(boundText)
    local padding = 5
    local width = (size.maxx - size.minx) + 2 * padding
    local height = (size.maxy - size.miny) -- height is off so no need for padding

    local count = config.showDiff and 3 or 2
    local totalWidth = width
    local totalHeight = height
    if config.orientation == ORIENTATION_HORZ then
      totalWidth = count * width
    else
      totalHeight = count * height
    end

    local x, y = position(widgetName, totalWidth, totalHeight)

    -- some helpers
    local function step()
      if (config.orientation == ORIENTATION_HORZ) then
        x = x + width
      else
        y = y + height
      end
    end

    local function drawScore(color, text)
      nvg.beginPath();
      nvg.rect(x, y, width, height);
      nvg.fillColor(color);
      nvg.fill();

      nvg.fillColor(textColor);
      if config.textAlign == TEXT_LEFT then
        nvg.textAlign(nvg.const.hAlign.left, nvg.const.vAlign.middle)
        nvg.text(x + padding, y + height / 2, text)
      elseif config.textAlign == TEXT_CENTER then
        nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)
        nvg.text(x + width/2, y + height / 2, text)
      elseif config.textAlign == TEXT_RIGHT then
        nvg.textAlign(nvg.const.hAlign.right, nvg.const.vAlign.middle)
        nvg.text(x + width - padding, y + height / 2, text)
      end
    end

    -- our score
    drawScore(config.ourColor, formatScore(ourScore))
    step()

    -- difference
    if config.showDiff then
      drawScore(config.diffColor, formatDiff(ourScore - theirScore))
      step()
    end

    -- their score
    drawScore(config.theirColor, formatScore(theirScore))
    step()
  end
}

_G[widgetName] = widget
_G.registerWidget(widgetName)
