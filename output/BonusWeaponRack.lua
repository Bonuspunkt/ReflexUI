-- based on WeaponRack by TurboPixelStudio
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
local userData = (function()
-- inlined ../userData
return {
  load = _G.loadUserData,
  save = _G.saveUserData
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

local config

local function round(number)
  return math.floor(number + 0.5)
end

_G.BonusWeaponRack = {
  initialize = function()
    config = userData.load() or {};
    if not config.hideMelee then config.hideMelee = false end
    if not config.weaponWidth then config.weaponWidth = 100 end
    if not config.weaponHeight then config.weaponHeight = 30 end
    if not config.weaponSpacing then config.weaponSpacing = 5 end
  end,

  drawOptions = function(_, x, y)
    local sliderStart = 140
    local sliderWidth = 300

    config.verticalRack = ui.checkBox(config.verticalRack or false, "Vertical", x, y)
    y = y + 40

    config.hideMelee = ui.checkBox(config.hideMelee or false, "Hide Melee", x, y)
    y = y + 40

    ui.label("WeaponWidth", x, y)
    config.weaponWidth = round(ui.slider(x + sliderStart, y, sliderWidth, 10, 300, config.weaponWidth))
    config.weaponWidth = round(ui.editBox(config.weaponWidth, x + sliderStart + sliderWidth + 10, y, 60));

    y = y + 40

    ui.label("WeaponHeight", x, y)
    config.weaponHeight = round(ui.slider(x + sliderStart, y, sliderWidth, 5, 100, config.weaponHeight))
    config.weaponHeight = round(ui.editBox(config.weaponHeight, x + sliderStart + sliderWidth + 10, y, 60));
    y = y + 40


    ui.label("Spacing", x, y)
    config.weaponSpacing = round(ui.slider(x + sliderStart, y, sliderWidth, -1, 50, config.weaponSpacing))
    config.weaponSpacing = round(ui.editBox(config.weaponSpacing, x + sliderStart + sliderWidth + 10, y, 60));

    userData.save(config);
  end,

  draw = function()
    if not _G.shouldShowHUD() then return end;

       -- Find player
    local player = _G.getPlayer();

    local weaponCount = 9;
    local spaceCount = weaponCount - 1;

    local weaponOffset = config.hideMelee and 1 or 0

    -- Helpers
    local rackWidth =
      (config.weaponWidth * (weaponCount - weaponOffset)) +
      (config.weaponSpacing * spaceCount);
    local rackLeft = -(rackWidth / 2);
    local weaponX = rackLeft;
    local weaponY = 0;

    local rackHeight, rackTop

    if config.verticalRack then
      rackHeight = (config.weaponHeight * weaponCount) + (config.weaponSpacing * spaceCount);
      rackTop = -(rackHeight / 2);
      weaponX = 0;
      weaponY = rackTop;
    end

    for weaponIndex = 1 + weaponOffset, weaponCount do

      local weapon = player.weapons[weaponIndex];
      local weaponColor = weapon.color;

      -- if we havent picked up the weapon, colour it grey
      if not weapon.pickedup then
        color.r = 128;
        color.g = 128;
        color.b = 128;
      end

      local backgroundColor = color.new(0,0,0,65)

      -- Frame background
      nvg.beginPath();
      nvg.rect(weaponX, weaponY, config.weaponWidth, config.weaponHeight);

      if weaponIndex == player.weaponIndexSelected then
        backgroundColor.r = _G.lerp(backgroundColor.r, weaponColor.r, player.weaponSelectionIntensity);
        backgroundColor.g = _G.lerp(backgroundColor.g, weaponColor.g, player.weaponSelectionIntensity);
        backgroundColor.b = _G.lerp(backgroundColor.b, weaponColor.b, player.weaponSelectionIntensity);
        backgroundColor.a = _G.lerp(backgroundColor.a, 128, player.weaponSelectionIntensity);

        local outlineColor = color.new(
          weaponColor.r,
          weaponColor.g,
          weaponColor.b,
          _G.lerp(0, 255, player.weaponSelectionIntensity));

        nvg.strokeWidth(2);
        nvg.strokeColor(outlineColor);
        nvg.stroke();
      end

      nvg.fillColor(backgroundColor);
      nvg.fill();

      -- Icon
      local iconRadius = config.weaponHeight * 0.40;
      local iconX = weaponX + (config.weaponHeight - iconRadius);
      local iconY = (config.weaponHeight / 2);
      local iconColor = weaponColor;

      if config.verticalRack then
        iconX = weaponX + iconRadius + 5;
        iconY = weaponY + (config.weaponHeight / 2);
      end

      if weaponIndex == player.weaponIndexSelected then
        iconColor.r = _G.lerp(iconColor.r, 255, player.weaponSelectionIntensity);
        iconColor.g = _G.lerp(iconColor.g, 255, player.weaponSelectionIntensity);
        iconColor.b = _G.lerp(iconColor.b, 255, player.weaponSelectionIntensity);
        iconColor.a = _G.lerp(iconColor.a, 255, player.weaponSelectionIntensity);
      end

      local svgName = "internal/ui/icons/weapon"..weaponIndex;
      nvg.fillColor(iconColor);
      nvg.svg(iconX, iconY, svgName, iconRadius);

      -- Ammo
      local ammoX = weaponX + (iconRadius) + (config.weaponWidth / 2);
      local ammoCount = player.weapons[weaponIndex].ammo;

      if config.verticalRack then
        ammoX = weaponX + (config.weaponWidth / 2) + iconRadius;
      end

      if weaponIndex == 1 then ammoCount = "-" end

      nvg.fontSize(config.weaponHeight);
      nvg.fontFace("TitilliumWeb-Bold");
      nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.top);

      nvg.fontBlur(0);
      nvg.fillColor(color.new(255,255,255));
      nvg.text(ammoX, weaponY, ammoCount);

      if config.verticalRack then
        weaponY = weaponY + config.weaponHeight + config.weaponSpacing;
      else
        weaponX = weaponX + config.weaponWidth + config.weaponSpacing;
      end
    end
  end
};
_G.registerWidget("BonusWeaponRack");
