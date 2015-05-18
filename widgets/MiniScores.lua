require "base/internal/ui/reflexcore"
local const = require "../const"
local nvg = require "../nvg"
local ui = require "../ui"
local userData = require "../userData"
local color = require "../lib/color"
local funcArray = require "../lib/funcArray"

local ORIENTATION_HORZ = "Horizontal"
local ORIENTATION_VERT = "Vertical"
local orientations = { ORIENTATION_HORZ, ORIENTATION_VERT }

local orientationState = {}
local ourColorState = {}
local diffColorState = {}
local theirColorState = {}
local config

local widgetName = "bonusMiniScores"
local widget = {

  initialize = function()
    if not config then config = userData.load() or {} end

    if not config.ourColor then config.ourColor = color.new(64,64,255,64) end
    if not config.diffColor then config.diffColor = color.new(255,255,255,64) end
    if not config.theirColor then config.theirColor = color.new(255,64,64,64) end
    if not config.orientation then config.orientation = ORIENTATION_HORZ end
  end,

  drawOptions = function(_, x, y)

    ui.label("Orientation", x, y)
    local comboX = x + 120
    local comboY = y
    y = y + 40

    ui.label("Your Score", x, y)
    config.ourColor = ui.colorPicker(x, y + 30, config.ourColor, ourColorState)
    y = y + 260

    -- we draw he comboBox after the sliders, because the comboBox dropdown
    -- must be drawn over the sliders
    config.orientation = ui.comboBox(orientations, config.orientation, comboX, comboY, 255, orientationState)

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
    if not _G.shouldShowHUD() then return end;

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

    local ourScore = 0;
    local theirScore = 0;
    local gameMode = _G.gamemodes[_G.world.gameModeIndex].shortName;

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
    end

    -- calculate positions
    nvg.fontSize(64);
    local size = nvg.textBounds("-888")
    local padding = 5
    local width = (size.maxx - size.minx) + 2 * padding
    local height = (size.maxy - size.miny) -- height is way off so no need for padding XD

    local count = config.showDiff and 3 or 2
    local x = -width * count / 2
    local y = 0

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
      nvg.text(x + width/2, y + height / 2, text);
    end

    -- our score
    drawScore(config.ourColor, ourScore)
    step()

    -- difference
    if config.showDiff then
      drawScore(config.diffColor, ourScore - theirScore)
      step()
    end

    -- their score
    drawScore(config.theirColor, theirScore)
    step()
  end
};

_G[widgetName] = widget;
_G.registerWidget(widgetName);
