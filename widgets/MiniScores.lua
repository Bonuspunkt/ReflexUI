require "base/internal/ui/reflexcore"
local funcArray = require "base/internal/ui/bonus/lib/funcArray"
local nvg = require "base/internal/ui/bonus/nvg"
local color = require "base/internal/ui/bonus/lib/color"
local const = require "base/internal/ui/bonus/const"

_G.MiniScores =
{
  draw = function()

    -- Early out if HUD should not be shown.
    if not _G.shouldShowHUD() then return end;

    -- Find player
    local player = _G.getPlayer();

    local textColor = color.new(255,255,255);

    nvg.fontFace(const.font.textBold);
    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.top);

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
    end

    if gameMode == "1v1" then
      ourScore = player.score;
      theirScore = activePlayers
        .filter(function(p) return player ~= p end)
        .map(function(p) return p.score; end)
        .reduce(function(prev, curr) return prev + curr end, 0)
    end

    if gameMode == "a1v1" or gameMode == "ffa" or gameMode == "affa" then
      ourScore = player.score;
      theirScore = activePlayers
        .filter(function(p) return player ~= p; end)
        .map(function(p) return p.score; end)
        .reduce(function(prev, curr) return math.max(prev, curr) end, 0)
    end


    nvg.fontSize(64);

    -- our score
    nvg.beginPath();
    nvg.rect(-120, 5, 80, 55);
    nvg.fillColor(color.new(64,64,255,64));
    nvg.fill();

    nvg.fillColor(textColor);
    nvg.text(-80,0, ourScore);

    -- difference
    nvg.beginPath();
    nvg.rect(-40, 5, 80, 55);
    nvg.fillColor(color.new(255,255,255,64));
    nvg.fill();

    nvg.fillColor(textColor);
    nvg.text(0,0, ourScore - theirScore);

    -- their score
    nvg.beginPath();
    nvg.rect(40, 5, 80, 55);
    nvg.fillColor(color.new(255,64,64,64));
    nvg.fill();

    nvg.fillColor(textColor);
    nvg.text(80,0, theirScore);
  end
};
_G.registerWidget("MiniScores");
