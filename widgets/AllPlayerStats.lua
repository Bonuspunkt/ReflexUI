require "base/internal/ui/reflexcore"
local color = require "base/internal/ui/bonus/lib/color"
local funcArray = require "base/internal/ui/bonus/lib/funcArray"
local icons = require "base/internal/ui/bonus/lib/icons"
local const = require "base/internal/ui/bonus/const"
local nvg = require "base/internal/ui/bonus/nvg"

-- config
local spacing = 32
local lineHeight = 40
local fontSize = 48
local iconPadding = 5
local highlightColor = color.new(255,0,0,64)

-- gibberish
local properties = funcArray({
    { name = "name" },
    { name = "hasMega", width = 32, draw = icons.drawMega },
    { name = "health", width = 60 },
    { name = "armorProtection", width = 32, draw = icons.drawArmor },
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

local function getEmpty()
    return properties.reduce(function(prev, property)
        prev[property.name] = 0
        return prev
    end, {})
end

local function get(table, property)
    if property.get then
        return property.get(table)
    end
    return table[property.name]
end

_G.AllPlayerStats =
{
    draw = function()

        local myself = _G.getLocalPlayer();
        local specingPlayer = _G.getPlayer();

        -- only display if we are spectating
        if not myself
          or myself.state ~= const.playerState.spectator then return end

        nvg.fontSize(fontSize);

        local activePlayers = funcArray(_G.players)
            .filter(function(player)
                return player.state == const.playerState.ingame
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
                        currWidth = nvg.textWidth(player[property.name])
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
                    nvg.fillColor(highlightColor);
                    nvg.beginPath();
                    nvg.roundedRect(
                        -totalWidth / 2,
                        (i - .5) * lineHeight,
                        totalWidth,
                        lineHeight, 5)
                    nvg.fill()
                end

                nvg.textAlign(nvg.const.hAlign.right, nvg.const.vAlign.middle)
                nvg.fillColor(color.new(255,255,255));

                local x = -totalWidth / 2 + maxWidths.name + 25
                local y = lineHeight * i

                nvg.text(x, y, player.name);

                if player.health <= 0 then
                    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)
                    x = (maxWidths.name + spacing/2) / 2
                    nvg.text(x, y, "DEAD")
                    return
                end

                properties.forEach(function(property, j)
                    if j < 2 then return end -- skip player name, we already have drawn that

                    x = x + maxWidths[property.name] + spacing;
                    if property.draw then
                        property.draw(x, y, lineHeight/2 - iconPadding, player[property.name])
                    else
                        nvg.text(x, y, player[property.name]);
                    end
                end)
            end)

    end
};
_G.registerWidget("AllPlayerStats");
