require "base/internal/ui/reflexcore"
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
local nvg = (function()
-- inlined base/internal/ui/bonus/nvg
-- wrapper for exposed nanoVG

return {

  ------------------------------------------------------------------------------
  -- nano constants
  ------------------------------------------------------------------------------
  const = {
    hAlign = {
      left = _G.NVG_ALIGN_LEFT,
      center = _G.NVG_ALIGN_CENTER,
      right = _G.NVG_ALIGN_RIGHT
    },
    vAlign = {
      baseline = _G.NVG_ALIGN_BASELINE,
      top = _G.NVG_ALIGN_TOP,
      middle = _G.NVG_ALIGN_MIDDLE,
      bottom = _G.NVG_ALIGN_BOTTOM
    },
    solidity = {
      solid = _G.NVG_SOLID,
      hole = _G.NVG_HOLE
    },
    winding = {
      ccw = _G.NVG_CCW,
      cw = _G.NVG_CW
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

_G.TrueStack =
{
  draw = function()

    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end;

    -- Find player
    local player = _G.getPlayer();

    local textColor = color.new(255,255,255);

    nvg.fontSize(52);
    nvg.fontFace("TitilliumWeb-Bold");
    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.top);
    nvg.fontBlur(0);
    nvg.fillColor(textColor);


    nvg.text(0, 0, reflexMath.trueStack(player));
  end
};
_G.registerWidget("TrueStack");
