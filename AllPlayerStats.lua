require "base/internal/ui/reflexcore"
local FuncArray = require "base/internal/ui/bonus/_FuncArray"
local Icons = require "base/internal/ui/bonus/_Icons"

-- config
local spacing = 32
local lineHeight = 40
local fontSize = 48
local iconPadding = 5
local highlightColor = Color(255,0,0,64)

-- gibberish
local properties = FuncArray({
    { name = "name" },
    { name = "hasMega", width = 32, draw = Icons.drawMega },
    { name = "health", width = 60 },
    { name = "armorProtection", width = 32, draw = Icons.drawArmor },
    { name = "armor", width =  60 },
    { name = "score", 60 },
    {
        name = "trueStack",
        get = function(player)
            return math.min(player.armor, player.health * player.armorProtection + 1)
                + player.health
        end
    }
})

function getEmpty()
    return properties.reduce(function(prev, property)
        prev[property.name] = 0
        return prev
    end, {})
end

function get(table, property)
    local value;
    if property.get then
        return property.get(table)
    end
    return table[property.name]
end

AllPlayerStats =
{
    draw = function()

        local myself = getLocalPlayer();
        local specingPlayer = getPlayer();

        -- only display if we are spectating
        if myself.state ~= PLAYER_STATE_SPECTATOR then return end

        nvgFontSize(fontSize);

        local activePlayers = FuncArray(players)
            .filter(function(player)
                return player.state == PLAYER_STATE_INGAME
                   and player.connected
            end)
            .map(function(player)
                local result = properties.reduce(function(prev, property)
                    prev[property.name] = get(player, property)
                    return prev
                end, {})

                -- hack
                if (player == specingPlayer) then specingPlayer = result end

                return result
            end)
            .sort(function(a, b) return a.score > b.score end)

        local maxWidths = activePlayers
            .reduce(function(prev, player)
                properties.forEach(function(property)
                    local currWidth;
                    if property.width ~= nil then
                        currWidth = property.width
                    else
                        currWidth = nvgTextWidth(player[property.name])
                    end
                    local prevWidth = prev[property.name];
                    if prevWidth < currWidth then
                        prev[property.name] = currWidth
                    end
                end)
                return prev
            end, getEmpty())

        local totalWidth = properties.reduce(
            function(prev, property)
                return prev + maxWidths[property.name] + spacing -- padding
            end, 0);

        activePlayers
            .forEach(function(player, i)
                if player == specingPlayer then
                    nvgFillColor(highlightColor);
                    nvgBeginPath();
                    nvgRoundedRect(
                        -totalWidth / 2,
                        (i - .5) * lineHeight,
                        totalWidth,
                        lineHeight, 5)
                    nvgFill()
                end

                nvgTextAlign(NVG_ALIGN_RIGHT, NVG_ALIGN_MIDDLE)
                nvgFillColor(Color(255,255,255));

                local x = -totalWidth / 2 + maxWidths.name + 25
                local y = lineHeight * i

                nvgText(x, y, player.name);

                if player.health <= 0 then
                    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE)
                    x = (maxWidths.name + spacing/2) / 2
                    nvgText(x, y, "DEAD")
                    return
                end

                properties.forEach(function(property, i)
                    if i < 2 then return end -- skip player name

                    x = x + maxWidths[property.name] + spacing;
                    if property.draw then
                        property.draw(x, y, lineHeight/2 - iconPadding, player[property.name])
                    else
                        nvgText(x, y, player[property.name]);
                    end
                end)
            end)

    end
};
registerWidget("AllPlayerStats");