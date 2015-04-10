require "base/internal/ui/reflexcore"
local FuncArray = require "base/internal/ui/bonus/_FuncArray"
local Icons = require "base/internal/ui/bonus/_Icons"
local ReflexMath = require "base/internal/ui/bonus/_ReflexMath"

-- config
local lineHeight = 50
local iconPadding = 3
local fontSize = 50
local showTrueStack = true

local function getPriority()
    local player = getPlayer()
    return 1
end

ItemArrivals =
{
    draw = function()
        -- Early out if HUD shouldn't be shown.
        if not shouldShowHUD() then return end;

        nvgFontFace("TitilliumWeb-Bold");

        local iconSize = lineHeight/2 - iconPadding

        local player = getPlayer()

        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);

        timers = FuncArray(pickupTimers)
            .groupBy(function(pickup) return pickup.type end)
            .map(function(group)
                return group.values.map(
                    function(pickup, i)
                        return {
                            index = i,
                            respawn = pickup.timeUntilRespawn,
                            type = pickup.type,
                            canSpawn = pickup.canSpawn,
                            priority = ReflexMath.priority(player, pickup.type),
                            priority = ReflexMath.priorize(player, pickup.type),
                            canPickup = ReflexMath.canPickup(player, pickup.type)
                        }
                    end)
            end)
            .reduce(function(prev, curr)
                return prev.concat(curr)
            end,  FuncArray({}))
            .sort(function(a, b)
                if (a.priority ~= b.priority) then
                    return a.priority > b.priority
                elseif (a.type ~= b.type) then
                    return a.type > b.type
                end
                return a.index < b.index
            end)
            .forEach(function(pickup, i)

                if pickup.type == 60 then
                    Icons.drawCarnage(-100, lineHeight * i, iconSize, 1)
                elseif pickup.type < 50 then
                    Icons.drawMega(-100, lineHeight * i, iconSize, pickup.canSpawn)
                elseif not pickup.canPickup then
                    nvgSave()
                    nvgFillColor(Color(64,64,64));
                    nvgSvg("internal/ui/icons/armor", -100, lineHeight * i, iconSize)
                    nvgRestore()
                else
                    Icons.drawArmor(-100, lineHeight * i, iconSize, pickup.type - PICKUP_TYPE_ARMOR50)
                end
                if pickup.index > 1 then
                    nvgFontSize(fontSize);
                    nvgText(-100 + iconSize/2, lineHeight * i + iconSize/2, pickup.index)
                end

                local time
                if pickup.respawn ~= 0 then
                    time = math.floor(pickup.respawn / 1000)
                elseif pickup.canSpawn then
                    time = "-"
                else
                    time = "hold"
                end
                nvgFontSize(fontSize);
                nvgText(0, lineHeight * i,  time)

                if showTrueStack then
                    nvgText(150, lineHeight * i,  pickup.priority)
                end
            end)

    end
};
registerWidget("ItemArrivals");
