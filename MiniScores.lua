require "base/internal/ui/reflexcore"

local function map(tbl, func)
    local newtbl = {}
    for i,v in pairs(tbl) do
        newtbl[i] = func(v)
    end
    return newtbl
end

local function filter(tbl, func)
    local newtbl= {}
    for i,v in pairs(tbl) do
        if func(v) then
            newtbl[i]=v
        end
    end
    return newtbl
 end


local function reduce(tbl, func, initialValue)
    for key,value in pairs(tbl) do
        initialValue = func(initialValue, value)
    end
    return initialValue;
end

MiniScores =
{
    draw = function()

        --inspect(maps)

        -- Early out if HUD should not be shown.
        if not shouldShowHUD() then return end;

        -- Find player
        local player = getPlayer();

        local textColor = Color(255,255,255,255);

        nvgFontFace("TitilliumWeb-Bold");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);

        local activePlayers = filter(players, function(player)
            return player.state == PLAYER_STATE_INGAME and player.connected;
        end)

        local ourScore = 0;
        local theirScore = 0;
        local gameMode = gamemodes[world.gameModeIndex].shortName;

        if gameMode == "tdm" or gameMode == "atdm" then
            ourScore = reduce(map(filter(activePlayers, function(p)
                return player.team == p.team;
            end), function(p)
                return p.score;
            end), function(prev, curr)
                return prev + curr;
            end, 0)

            theirScore = reduce(map(filter(activePlayers, function(p)
                return player.team ~= p.team;
            end), function(p)
                return p.score;
            end), function(prev, curr)
                return prev + curr;
            end, 0)
        end

        if gameMode == "1v1" then
            ourScore = player.score;
            theirScore = reduce(map(filter(activePlayers, function(p)
                return player ~= p;
            end), function(p)
                return p.score;
            end), function(prev, curr)
                return prev + curr;
            end, 0)
        end

        if gameMode == "a1v1" or gameMode == "ffa" or gameMode == "affa" then
            ourScore = player.score;
            theirScore = reduce(map(filter(activePlayers, function(p)
                return player ~= p;
            end), function(p)
                return p.score;
            end), function(prev, curr)
                return math.max(prev, curr);
            end, 0)
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