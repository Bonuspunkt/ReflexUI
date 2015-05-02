require "base/internal/ui/reflexcore"
local nvg = (function()
-- inlined ../nvg
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
local ui = (function()
-- inlined ../ui
require "base/internal/ui/reflexcore"

return {
  -- stuff from reflexCore
  window = _G.uiWindow,
  button = _G.uiButton,
  buttonVertical = _G.uiButtonVertical,
  slider = _G.uiSlider,
  progressBar = _G.uiProgressBar,
  scrollBar = _G.uiScrollBar,
  subHeader = _G.uiSubHeader,
  toolTip = _G.uiToolTip,
  checkBox = _G.uiCheckBox,
  editBox = _G.uiEditBox,
  label = _G.uiLabel,
  comboBox = _G.uiComboBox,
  colorPicker = _G.uiColorPicker,


  scrollSelection = _G.uiScrollSelection,
  scrollSelectionItem = _G.uiScrollSelectionItem
}

end)()
local userData = (function()
-- inlined ../userData
return {
  load = _G.loadUserData,
  save = _G.saveUserData
}

end)()
local color = (function()
-- inlined ../lib/color
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
local reflexMath = (function()
-- inlined ../lib/reflexMath
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

local config = {}
local circleColorState = {}
local textColorState = {}

local function round(number)
  return math.floor(number + 0.5)
end

_G.TrueStack =
{

  initialize = function()
    config = userData.load() or {
      showCircle = true,
      circleColor = color.new(0,127,0, 127),
      radius = 100,
      width = 40,

      showNumber = false,
      fontSize = 40,
      textColor = color.new(255,255,255)
    };
  end,

  drawOptions = function(_, x, y)
    local sliderOffsetX = 120
    local sliderWidth = 320
    local textWidth = 80

    config.showCircle = ui.checkBox(config.showCircle or false, "Show Circle", x, y)
    y = y + 40

    if config.showCircle then
      ui.label("Circle Color", x, y)
      config.circleColor = ui.colorPicker(x, y + 30, config.circleColor, circleColorState)
      y = y + 270

      ui.label("Radius", x, y)
      config.radius = round(ui.slider(x + sliderOffsetX, y, sliderWidth, 10, 500, config.radius))
      config.radius = round(ui.editBox(config.radius, x + sliderWidth + sliderOffsetX + 10, y, textWidth))
      y = y + 40

      ui.label("Width", x, y)
      config.width = round(ui.slider(x + sliderOffsetX, y, sliderWidth, 10, 500, config.width))
      config.width = round(ui.editBox(config.width, x + sliderWidth + sliderOffsetX + 10, y, textWidth))
      y = y + 40
    end

    config.showNumber = ui.checkBox(config.showNumber or false, "Show Number", x, y)
    y = y + 40

    if config.showNumber then
      ui.label("Font Size", x, y)
      config.fontSize = round(ui.slider(x + sliderOffsetX, y, sliderWidth, 10, 500, config.fontSize))
      config.fontSize = round(ui.editBox(config.fontSize, x + sliderWidth + sliderOffsetX + 10, y, textWidth))
      y = y + 40

      ui.label("Text Color", x, y)
      config.textColor = ui.colorPicker(x, y + 30, config.textColor, textColorState)
    end

    userData.save(config)
  end,

  getOptionsHeight = function()
    local result = 90
    if config.showCircle then
      result = result + 360
    end
    if config.showNumber then
      result = result + 340
    end
    return result
  end,

  draw = function()

    -- Early out if HUD shouldn't be shown.
    if not _G.shouldShowHUD() then return end;

    -- Find player
    local player = _G.getPlayer();

    local trueStack = reflexMath.trueStack(player);

    if config.showCircle then
      local arcEnd = trueStack / 400 * 2 * math.pi
      local radius = config.radius + config.width / 2

      nvg.beginPath();
      nvg.arc(0, 0, config.radius - 1, 0, arcEnd, nvg.const.winding.cw)
      nvg.strokeWidth(2)
      nvg.strokeColor(color.new(0,0,0, config.circleColor.a))
      nvg.stroke()

      nvg.beginPath();
      nvg.arc(0, 0, config.radius + config.width, 0, arcEnd, nvg.const.winding.cw)
      nvg.strokeWidth(2)
      nvg.strokeColor(color.new(0,0,0, config.circleColor.a))
      nvg.stroke()

      nvg.beginPath();
      nvg.arc(0, 0, radius, 0, arcEnd, nvg.const.winding.cw)
      nvg.strokeWidth(config.width)
      nvg.strokeColor(config.circleColor)
      nvg.stroke()
    end

    if config.showNumber then
      nvg.fontFace("TitilliumWeb-Bold");
      nvg.fontSize(config.fontSize);
      nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle);
      nvg.fillColor(config.textColor);
      nvg.text(0, 0, trueStack);
    end

  end
};
_G.registerWidget("TrueStack");
