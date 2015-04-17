local funcArray = (function()
-- inlined base/internal/ui/bonus/lib/funcArray
local function add(array, value)
    array[#array + 1] = value
end


local function FuncArray(array)

    local result = {
        map = function(func)
            local newTable = {}
            for i = 1, #array do
                newTable[i] = func(array[i], i, array)
            end

            return FuncArray(newTable)
        end,

        filter = function(func)
            local newTable = {}
            for i = 1, #array do
                if func(array[i], i) then
                    newTable[#newTable+1] = array[i]
                end
            end

            return FuncArray(newTable)
        end,

        forEach = function(func)
            for i = 1, #array do
                func(array[i], i, array)
            end
        end,

        reduce = function(func, initialValue)
            for i = 1, #array do
                initialValue = func(initialValue, array[i], i, array);
            end
            return initialValue
        end,

        sort = function(func)
            local newArray = {}
            for i = 1, #array do
                newArray[i] = array[i]
            end
            table.sort(newArray, func)

            return FuncArray(newArray)
        end,

        first = function(func)
            for i = 1, #array do
                if func(array[i], i, array) then
                    return array[i]
                end
            end
        end,

        groupBy = function(func)
            local newArray = FuncArray({})
            for i = 1, #array do
                local key = func(array[i], i, array);
                local match = newArray.first(function(other) return other.key == key end)
                if not match then
                    match = { key = key, values = FuncArray({ array[i] }) }
                    add(newArray.raw, match)
                else
                    add(match.values.raw, array[i]);
                end
            end

            return newArray
        end,

        concat = function(otherArray)
            local result = {}
            for i = 1, #array do
                add(result, array[i])
            end

            if otherArray.raw then otherArray = otherArray.raw end
            for j = 1, #otherArray do
                add(result, otherArray[j])
            end

            return FuncArray(result)
        end,

        -- escape the fancyness
        raw = array
    }

    -- setmetatable(result, {
    --     __len = function() return #array end, -- does not work with lua 5.1
    --     __index = function(v, i)
    --         return array[i]
    --     end,
    --     __newindex = function(v, i, value)
    --         array[i] = value
    --     end
    -- })

    return result
end

return FuncArray;
end)()
local icons = (function()
-- inlined base/internal/ui/bonus/lib/icons
local nvg = (function()
-- inlined ../nvg
-- wrapper for exposed nanoVG

return {

  ------------------------------------------------------------------------------
  -- nano constants
  ------------------------------------------------------------------------------
  const = {
    hAlign = {
      left = 0,
      center = 1,
      right = 2
    },
    vAlign = {
      baseline = 0,
      top = 1,
      middle = 2,
      bottom = 3
    },
    solidity = {
      solid = 1,
      hole = 2
    }
  },


  -- State
  save = _G.nvgSave,
  restore = _G.nvgRestore,

  -- Font
  fontSize = _G.nvgFontSize,
  fontFace = _G.nvgFontFace,
  fontBlur = _G.nvgFontBlur,
  textWidth = _G.nvgTextWidth,

  -- returns table { minx, miny, maxx, maxy }
  textBounds = _G.nvgTextBounds,

  -- Fill
  fillColor = _G.nvgFillColor,
  fillLinearGradient = _G.nvgFillLinearGradient,
  fillBoxGradient = _G.nvgFillBoxGradient,
  fillRadialGradient = _G.nvgFillRadialGradient,
  fill = _G.nvgFill,

  -- Stroke
  strokeColor = _G.nvgStrokeColor,
  strokeLinearGradient = _G.nvgStrokeLinearGradient,
  strokeBoxGradient = _G.nvgStrokeBoxGradient,
  strokeRadialGradient = _G.nvgStrokeRadialGradient,
  strokeWidth = _G.nvgStrokeWidth,
  stroke = _G.nvgStroke,

  -- Text
  textAlign = _G.nvgTextAlign,
  text = _G.nvgText,

  -- Paths
  beginPath = _G.nvgBeginPath,
  moveTo = _G.nvgMoveTo,
  lineTo = _G.nvgLineTo,
  bezierTo = _G.nvgBezierTo,
  quadTo = _G.nvgQuadTo,
  arcTo = _G.nvgArcTo,
  closePath = _G.nvgClosePath,
  pathWinding = _G.nvgPathWinding,

  -- Primitives
  arc = _G.nvgArc,
  rect = _G.nvgRect,
  roundedRect = _G.nvgRoundedRect,
  ellipse = _G.nvgEllipse,
  circle = _G.nvgCircle,

  -- Scissoring
  scissor = _G.nvgScissor,
  intersectScissor = _G.nvgIntersectScissor,
  resetScissor = _G.nvgResetScissor,

  -- Transform
  translate = _G.nvgTranslate,
  rotate = _G.nvgRotate,
  skewX = _G.nvgSkewX,
  skewY = _G.nvgSkewY,
  scale = _G.nvgScale,

  ------------------------------------------------------------------------------------------------
  --SVG BINDINGS
  ------------------------------------------------------------------------------------------------
  -- NOTE: swapped param names position to be inline with other functions
  svg = function(x, y, name, rad)
    _G.nvgSvg(name, x, y, rad)
  end,

}

end)()
local color = (function()
-- inlined base/internal/ui/bonus/lib/color
require "base/internal/ui/reflexcore"

local lerp = function(a, b, k)
  return a * (1 - k) + b * k;
end

local Color = _G.Color

return {
  new = function(r,g,b,a)
    return Color(r,g,b,a)
  end,

  lerp = function(colorA, colorB, k)
    return Color(
      lerp(colorA.r, colorB.r, k),
      lerp(colorA.g, colorB.g, k),
      lerp(colorA.b, colorB.b, k),
      lerp(colorA.a, colorB.a, k)
    )
  end
}

end)()

local armorColors = {
  color.new(0, 255, 0, 255),
  color.new(255, 255, 0, 255),
  color.new(255, 0, 0, 255)
}

return {
  -- TODO: replace params with table
  drawArmor = function(x, y, size, armorProtection, lerpColor)
    local armorColor = armorColors[armorProtection + 1];

    if lerpColor then
      armorColor = color.lerp(armorColor, lerpColor, .75)
    end

    nvg.save()
    nvg.fillColor(armorColor);
    nvg.svg(x, y, "internal/ui/icons/armor", size)
    nvg.restore()
  end,

  -- TODO: replace params with table
  drawMega = function(x, y, size, hasMega)
    local healthColor
    if hasMega then
      healthColor = color.new(60,80,255)
    else
      healthColor = color.new(64,64,64)
    end

    nvg.save()
    nvg.fillColor(healthColor);
    nvg.svg(x, y, "internal/ui/icons/health", size)
    nvg.restore()
  end,

  -- TODO: replace params with table
  drawCarnage = function(x, y, size, carnageTimer)
    if carnageTimer <= 0 then return end
    nvg.save()
    nvg.fillColor(color.new(255,120,128))
    nvg.svg(x, y, "internal/ui/icons/carnage", size)
    nvg.restore()
  end,

  -- TODO: replace params with table
  drawWeapon = function(x, y, size, weaponIndex, weaponColor) -- would prefeer only weaponIndex but weapons if on player
    nvg.save()
    nvg.fillColor(weaponColor);
    nvg.svg(x, y, "internal/ui/icons/weapon" .. weaponIndex, size);
    nvg.restore()
  end
}

end)()
local reflexMath = (function()
-- inlined base/internal/ui/bonus/lib/reflexMath
local const = (function()
-- inlined base/internal/ui/bonus/const
return {
  state = {
    disconnect = 0,
    connecting = 1,
    connected = 2
  },
  -- see players[1].state
  gameState = {
    warmup = 0,
    active = 1,
    roundPrepare = 2,
    roundActive = 3,
    roundCooldownSomeoneWon = 4,
    roundCooldownDraw = 5,
    gameover = 6
  },
  -- see world.gameState
  playerState = {
    ingame = 1,
    spectator = 2,
    editor = 3,
    queued = 4
  },
  -- see pickupTimers[1].type
  pickupType = {
    burstGun = 0,
    shotgun = 1,
    grenadeLauncher = 2,
    machineGun = 3,
    rocketLauncer = 4,
    ionCannon = 5,
    boltRifle = 6,
    stakeGun = 7,

    health5 = 40,
    health25 = 41,
    health50 = 42,
    health100 = 43,

    armor5 = 50,
    armor50 = 51,
    armor100 = 52,
    armor150 = 53,

    powerupCarnage = 60
  },

  font = {
    header = "oswald-bold";
    hud = "oswald-bold";
    text = "roboto-regular";
    textBold = "roboto-bold";
    sizeDefault = 24;
    sizeSmall = 22;
  }
}

end)()

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


-- calculates the amount of damage to kill the player
local trueStack = function(player)
  return math.min(
    player.armor,
    player.health * (player.armorProtection + 1)
  ) + player.health;
end

-- checks if the player can pickup an item
local canPickup = function(player, itemType)
  if itemType == const.pickupType.health100 then

    return player.health < 200

  elseif itemType == const.pickupType.armor150 then

    return player.armorProtection < 2
        or player.armor < 200

  elseif itemType == const.pickupType.armor100 then

    return player.armorProtection == 2 and player.armor < 133
        or player.armorProtection ~= 2 and player.armor < 150

  elseif itemType == const.pickupType.armor50 then

    return player.armorProtection == 2 and player.armor < 66
        or player.armorProtection == 1 and player.armor < 75
        or player.armorProtection == 0 and player.armor < 100

  elseif itemType == const.pickupType.powerupCarnage then

      return player.carnageTimer == 0

  end

  return false
end

-- calculates the player stats after an item pickup
local pickup = function(player, itemType)
  if not canPickup(player, itemType) then
    return {
      armorProtection = player.armorProtection,
      armor = player.armor,
      health = player.health
    }
  elseif itemType == const.pickupType.health100 then
    return {
      armorProtection = player.armorProtection,
      armor = player.armor,
      health = math.min(200, player.health + 100)
    }
  elseif itemType == const.pickupType.armor150 then
    return {
      armorProtection = 2,
      armor = math.min(200, player.armor + 150),
      health = player.health
    }
  elseif itemType == const.pickupType.armor100 then
    return {
      armorProtection = 1,
      armor = math.min(150, player.armor + 100),
      health = player.health
    }
  elseif itemType == const.pickupType.armor50 then
    return {
      armorProtection = 0,
      armor = math.min(100, player.armor + 50),
      health = player.health
    }
  end
end

-- priorizes which item will be most useful for the players stack
local priorize = function(player, itemType)
  if itemType == const.pickupType.powerupCarnage then
    return 401;
  end
  return trueStack(pickup(player, itemType))
end

-- calculates the new player stats after receiving damage
local receiveDamage = function(player, damage)
  local armorDamage = damage * (1 - (1/(player.armorProtection + 2)));
  local armorAbsorbs = round(math.min(player.armor, armorDamage));

  return {
    armorProtection = player.armorProtection,
    armor = player.armor - armorAbsorbs,
    health = player.health - (damage - armorAbsorbs)
  }
end

return {
  trueStack = trueStack,
  canPickup = canPickup,
  pickup = pickup,
  priorize = priorize,
  receiveDamage = receiveDamage
}

end)()
local color = (function()
-- inlined base/internal/ui/bonus/lib/color
require "base/internal/ui/reflexcore"

local lerp = function(a, b, k)
  return a * (1 - k) + b * k;
end

local Color = _G.Color

return {
  new = function(r,g,b,a)
    return Color(r,g,b,a)
  end,

  lerp = function(colorA, colorB, k)
    return Color(
      lerp(colorA.r, colorB.r, k),
      lerp(colorA.g, colorB.g, k),
      lerp(colorA.b, colorB.b, k),
      lerp(colorA.a, colorB.a, k)
    )
  end
}

end)()
local nvg = (function()
-- inlined base/internal/ui/bonus/nvg
-- wrapper for exposed nanoVG

return {

  ------------------------------------------------------------------------------
  -- nano constants
  ------------------------------------------------------------------------------
  const = {
    hAlign = {
      left = 0,
      center = 1,
      right = 2
    },
    vAlign = {
      baseline = 0,
      top = 1,
      middle = 2,
      bottom = 3
    },
    solidity = {
      solid = 1,
      hole = 2
    }
  },


  -- State
  save = _G.nvgSave,
  restore = _G.nvgRestore,

  -- Font
  fontSize = _G.nvgFontSize,
  fontFace = _G.nvgFontFace,
  fontBlur = _G.nvgFontBlur,
  textWidth = _G.nvgTextWidth,

  -- returns table { minx, miny, maxx, maxy }
  textBounds = _G.nvgTextBounds,

  -- Fill
  fillColor = _G.nvgFillColor,
  fillLinearGradient = _G.nvgFillLinearGradient,
  fillBoxGradient = _G.nvgFillBoxGradient,
  fillRadialGradient = _G.nvgFillRadialGradient,
  fill = _G.nvgFill,

  -- Stroke
  strokeColor = _G.nvgStrokeColor,
  strokeLinearGradient = _G.nvgStrokeLinearGradient,
  strokeBoxGradient = _G.nvgStrokeBoxGradient,
  strokeRadialGradient = _G.nvgStrokeRadialGradient,
  strokeWidth = _G.nvgStrokeWidth,
  stroke = _G.nvgStroke,

  -- Text
  textAlign = _G.nvgTextAlign,
  text = _G.nvgText,

  -- Paths
  beginPath = _G.nvgBeginPath,
  moveTo = _G.nvgMoveTo,
  lineTo = _G.nvgLineTo,
  bezierTo = _G.nvgBezierTo,
  quadTo = _G.nvgQuadTo,
  arcTo = _G.nvgArcTo,
  closePath = _G.nvgClosePath,
  pathWinding = _G.nvgPathWinding,

  -- Primitives
  arc = _G.nvgArc,
  rect = _G.nvgRect,
  roundedRect = _G.nvgRoundedRect,
  ellipse = _G.nvgEllipse,
  circle = _G.nvgCircle,

  -- Scissoring
  scissor = _G.nvgScissor,
  intersectScissor = _G.nvgIntersectScissor,
  resetScissor = _G.nvgResetScissor,

  -- Transform
  translate = _G.nvgTranslate,
  rotate = _G.nvgRotate,
  skewX = _G.nvgSkewX,
  skewY = _G.nvgSkewY,
  scale = _G.nvgScale,

  ------------------------------------------------------------------------------------------------
  --SVG BINDINGS
  ------------------------------------------------------------------------------------------------
  -- NOTE: swapped param names position to be inline with other functions
  svg = function(x, y, name, rad)
    _G.nvgSvg(name, x, y, rad)
  end,

}

end)()
local const = (function()
-- inlined base/internal/ui/bonus/const
return {
  state = {
    disconnect = 0,
    connecting = 1,
    connected = 2
  },
  -- see players[1].state
  gameState = {
    warmup = 0,
    active = 1,
    roundPrepare = 2,
    roundActive = 3,
    roundCooldownSomeoneWon = 4,
    roundCooldownDraw = 5,
    gameover = 6
  },
  -- see world.gameState
  playerState = {
    ingame = 1,
    spectator = 2,
    editor = 3,
    queued = 4
  },
  -- see pickupTimers[1].type
  pickupType = {
    burstGun = 0,
    shotgun = 1,
    grenadeLauncher = 2,
    machineGun = 3,
    rocketLauncer = 4,
    ionCannon = 5,
    boltRifle = 6,
    stakeGun = 7,

    health5 = 40,
    health25 = 41,
    health50 = 42,
    health100 = 43,

    armor5 = 50,
    armor50 = 51,
    armor100 = 52,
    armor150 = 53,

    powerupCarnage = 60
  },

  font = {
    header = "oswald-bold";
    hud = "oswald-bold";
    text = "roboto-regular";
    textBold = "roboto-bold";
    sizeDefault = 24;
    sizeSmall = 22;
  }
}

end)()

-- config
local lineHeight = 50
local iconPadding = 3
local fontSize = 50
local showTrueStack = true
local itemHero = true
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

    if itemHero then
      nvg.beginPath()
      nvg.rect(
        -100 - lineHeight/2 + iconPadding,
        lineHeight - iconSize,
        iconSize * 2,
        #_G.pickupTimers * lineHeight)
      nvg.fillColor(color.new(0,0,0,64))
      nvg.fill()
    end

    funcArray(_G.pickupTimers)
      .groupBy(function(pickup) return pickup.type end)
      .map(function(group)
        return group.values.map(
          function(pickup, i, array)
            local index = i
            if #array == 1 then index = 0 end

            return {
              index = index,
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

        local time
        if pickup.respawn ~= 0 then
          time = math.ceil(pickup.respawn / 1000)
        elseif pickup.canSpawn then
          time = "-"
        else
          time = "held"
        end
        nvg.fillColor(color.new(255,255,255, 64))
        nvg.fontSize(fontSize);
        nvg.textAlign(nvg.const.hAlign.right, nvg.const.vAlign.middle)
        nvg.text(-130, lineHeight * i,  time)


        local x = -100
        if itemHero then x = x + pickup.respawn/50 end

        if pickup.type == 60 then
          icons.drawCarnage(x, lineHeight * i, iconSize, 1)
        elseif pickup.type < 50 then
          icons.drawMega(x, lineHeight * i, iconSize, pickup.canSpawn)
        else
          local lerpColor
          if not pickup.canPickup then
            lerpColor = color.new(0,0,0)
          end
          icons.drawArmor(x, lineHeight * i, iconSize, pickup.type - const.pickupType.armor50, lerpColor)
        end

        if pickup.index > 0 then
          _G.nvgSave()
          for blur, usedColor in pairs({color.new(0,0,0), color.new(255,255,255)}) do
            nvg.fillColor(usedColor)
            nvg.fontBlur((2 - blur) * 10)
            nvg.fontSize(fontSize * 2 / 3);
            nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)
            nvg.text(x + iconSize/2, lineHeight * i + iconSize/2, pickup.index)
          end
          _G.nvgRestore()
        end

        if showTrueStack then
          nvg.text(150, lineHeight * i,  pickup.priority)
        end
      end)

  end
};
_G.registerWidget("ItemArrivals");
