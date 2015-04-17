require "base/internal/ui/reflexcore"
local const = require "../const"
local nvg = require "../nvg"
local ui = require "../ui"
local color = require "../lib/color"
local funcArray = require "../lib/funcArray"

local config

local function initOrFixConfig()
  if not config then config = _G.loadUserData() or {} end

  if not config.ourColor then config.ourColor = color.new(64,64,255,64) end
  if not config.diffColor then config.diffColor = color.new(255,255,255,64) end
  if not config.theirColor then config.theirColor = color.new(255,64,64,64) end
end


_G.MiniScores = {

  draw = function()

    -- Early out if HUD should not be shown.
    if not _G.shouldShowHUD() then return end;

    initOrFixConfig()

    -- Find player
    local player = _G.getPlayer()

    local textColor = color.new(255,255,255)

    nvg.fontFace(const.font.textBold)
    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.top)

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


    nvg.fontSize(64);
    local width = 80;

    local count = config.showDiff and 3 or 2
    local x = -width * count / 2

    -- our score
    nvg.beginPath();
    nvg.rect(x, 5, width, 55);
    nvg.fillColor(config.ourColor);
    nvg.fill();

    nvg.fillColor(textColor);
    nvg.text(x + width/2, 0, ourScore);

    x = x + width

    -- difference
    if config.showDiff then
      nvg.beginPath();
      nvg.rect(x, 5, 80, 55);
      nvg.fillColor(config.diffColor);
      nvg.fill();

      nvg.fillColor(textColor);
      nvg.text(x + width / 2,0, ourScore - theirScore);

      x = x + width
    end

    -- their score
    nvg.beginPath();
    nvg.rect(x, 5, width, 55);
    nvg.fillColor(config.theirColor);
    nvg.fill();

    nvg.fillColor(textColor);
    nvg.text(x + width / 2,0, theirScore);
  end,

  drawOptions = function(_, x, y)
    initOrFixConfig()

    ui.label("Your Score:", x, y+30);

    config.ourColor.r = ui.slider(x + 120, y, 255, 0, 255, config.ourColor.r)
    config.ourColor.g = ui.slider(x + 120, y+20, 255, 0, 255, config.ourColor.g)
    config.ourColor.b = ui.slider(x + 120, y+40, 255, 0, 255, config.ourColor.b)
    config.ourColor.a = ui.slider(x + 120, y+60, 255, 0, 255, config.ourColor.a)

    nvg.beginPath()
    nvg.rect(x + 400, y, 100, 90)
    nvg.fillColor(config.ourColor)
    nvg.fill()

    y = y + 90

    config.showDiff = ui.checkBox(config.showDiff or false, "Show Diff", x, y)
    y = y + 30

    if config.showDiff then
      ui.label("Score diff:", x, y+30);

      config.diffColor.r = ui.slider(x + 120, y, 255, 0, 255, config.diffColor.r)
      config.diffColor.g = ui.slider(x + 120, y+20, 255, 0, 255, config.diffColor.g)
      config.diffColor.b = ui.slider(x + 120, y+40, 255, 0, 255, config.diffColor.b)
      config.diffColor.a = ui.slider(x + 120, y+60, 255, 0, 255, config.diffColor.a)

      nvg.beginPath()
      nvg.rect(x + 400, y, 100, 90)
      nvg.fillColor(config.diffColor)
      nvg.fill()

      y = y + 90
    end

    ui.label("Other score:", x, y+30);

    config.theirColor.r = ui.slider(x + 120, y, 255, 0, 255, config.theirColor.r)
    config.theirColor.g = ui.slider(x + 120, y+20, 255, 0, 255, config.theirColor.g)
    config.theirColor.b = ui.slider(x + 120, y+40, 255, 0, 255, config.theirColor.b)
    config.theirColor.a = ui.slider(x + 120, y+60, 255, 0, 255, config.theirColor.a)

    nvg.beginPath()
    nvg.rect(x + 400, y, 100, 90)
    nvg.fillColor(config.theirColor)
    nvg.fill()

    _G.saveUserData(config);
  end
};
_G.registerWidget("MiniScores");
