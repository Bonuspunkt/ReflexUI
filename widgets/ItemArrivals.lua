local funcArray = require "base/internal/ui/bonus/lib/funcArray"
local icons = require "base/internal/ui/bonus/lib/icons"
local reflexMath = require "base/internal/ui/bonus/lib/reflexMath"
local color = require "base/internal/ui/bonus/lib/color"
local nvg = require "base/internal/ui/bonus/nvg"
local const = require "base/internal/ui/bonus/const"

-- config
local lineHeight = 50
local iconPadding = 3
local fontSize = 50
local showTrueStack = true
-- todo: sorting

_G.ItemArrivals =
{
  draw = function()
    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end;

    nvg.fontFace("TitilliumWeb-Bold");

    local iconSize = lineHeight/2 - iconPadding
    local player = _G.getPlayer()

    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle);

    funcArray(_G.pickupTimers)
      .groupBy(function(pickup) return pickup.type end)
      .map(function(group)
        return group.values.map(
          function(pickup, i)
            return {
              index = i,
              respawn = pickup.timeUntilRespawn,
              type = pickup.type,
              canSpawn = pickup.canSpawn,
              priority = reflexMath.priorize(player, pickup.type),
              canPickup = reflexMath.canPickup(player, pickup.type)
            }
          end)
      end)
      .reduce(function(prev, curr)
        return prev.concat(curr)
      end,  funcArray({}))
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
          icons.drawCarnage(-100, lineHeight * i, iconSize, 1)
        elseif pickup.type < 50 then
          icons.drawMega(-100, lineHeight * i, iconSize, pickup.canSpawn)
        else
          local lerpColor
          if not pickup.canPickup then
            lerpColor = color.new(0,0,0)
          end
          icons.drawArmor(-100, lineHeight * i, iconSize, pickup.type - const.pickupType.armor50, lerpColor)
        end

        if pickup.index > 1 then
          nvg.fontSize(fontSize);
          nvg.text(-100 + iconSize/2, lineHeight * i + iconSize/2, pickup.index)
        end

        local time
        if pickup.respawn ~= 0 then
          time = math.ceil(pickup.respawn / 1000)
        elseif pickup.canSpawn then
          time = "-"
        else
          time = "held"
        end
        nvg.fontSize(fontSize);
        nvg.text(0, lineHeight * i,  time)

        if showTrueStack then
          nvg.text(150, lineHeight * i,  pickup.priority)
        end
      end)

  end
};
_G.registerWidget("ItemArrivals");
