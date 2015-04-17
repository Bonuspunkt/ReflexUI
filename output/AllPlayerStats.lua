require "base/internal/ui/reflexcore"
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
