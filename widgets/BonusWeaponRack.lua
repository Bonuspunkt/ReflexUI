-- based on WeaponRack by TurboPixelStudio
local nvg = require "../nvg"
local userData = require "../userData"
local ui = require "../ui"
local color = require "../lib/color"

local grey = color.new(128,128,128)

local config

local function round(number)
  return math.floor(number + 0.5)
end

local widgetName = "bonusWeaponRack"
local widget = {
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
      local textColor = color.new(255,255,255)

      -- if we havent picked up the weapon, colour it grey
      if not weapon.pickedup then
        color = grey
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

      if weapon.ammo == 0 then
        iconColor = grey
        textColor = grey
      elseif weaponIndex == player.weaponIndexSelected then
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
      nvg.fillColor(textColor);
      nvg.text(ammoX, weaponY, ammoCount);

      if config.verticalRack then
        weaponY = weaponY + config.weaponHeight + config.weaponSpacing;
      else
        weaponX = weaponX + config.weaponWidth + config.weaponSpacing;
      end
    end
  end
};

_G[widgetName] = widget;
_G.registerWidget(widgetName);
