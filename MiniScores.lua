require "base/internal/ui/reflexcore"
local FuncArray = require "base/internal/ui/bonus/_FuncArray"

MiniScores =
{
    draw = function()

        -- Early out if HUD should not be shown.
        if not shouldShowHUD() then return end;

        -- Find player
        local player = getPlayer();

        local textColor = Color(255,255,255,255);

        nvgFontFace("TitilliumWeb-Bold");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);

        local activePlayers = FuncArray(players).filter(
            function(player)
                return player.state == PLAYER_STATE_INGAME
                    and player.connected;
            end
        )

        local ourScore = 0;
        local theirScore = 0;
        local gameMode = gamemodes[world.gameModeIndex].shortName;

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


        nvgFontSize(64);

        -- our score
        nvgBeginPath();
        nvgRect(-120, 5, 80, 55);
        nvgFillColor(Color(64,64,255,64));
        nvgFill();

        nvgFillColor(textColor);
        nvgText(-80,0, ourScore);

        -- difference
        nvgBeginPath();
        nvgRect(-40, 5, 80, 55);
        nvgFillColor(Color(255,255,255,64));
        nvgFill();

        nvgFillColor(textColor);
        nvgText(0,0, ourScore - theirScore);

        -- their score
        nvgBeginPath();
        nvgRect(40, 5, 80, 55);
        nvgFillColor(Color(255,64,64,64));
        nvgFill();

        nvgFillColor(textColor);
        nvgText(80,0, theirScore);
    end
};
registerWidget("MiniScores");