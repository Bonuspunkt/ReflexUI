require "base/internal/ui/reflexcore"
local core = require "../core"

_G.BonusWeaponRack = {};
_G.registerWidget("BonusWeaponRack");

function _G.BonusWeaponRack:initialize()
  self.config = _G.loadUserData() or {};
  if not self.config.hideMelee then self.config.hideMelee = false end
  if not self.config.weaponWidth then self.config.weaponWidth = 100 end
  if not self.config.weaponHeight then self.config.weaponHeight = 30 end
  if not self.config.weaponSpacing then self.config.weaponSpacing = 5 end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function _G.BonusWeaponRack:draw()

  -- Early out if HUD should not be shown.
  if not _G.shouldShowHUD() then return end;

     -- Find player
  local player = _G.getPlayer();

  local weaponCount = 9;
  local spaceCount = weaponCount - 1;

  -- Helpers
  local rackWidth = (self.config.weaponWidth * weaponCount) + (self.config.weaponSpacing * spaceCount);
  local rackLeft = -(rackWidth / 2);
  local weaponX = rackLeft;
  local weaponY = 0;

  local rackHeight, rackTop

  if self.config.verticalRack then
    rackHeight = (self.config.weaponHeight * weaponCount) + (self.config.weaponSpacing * spaceCount);
    rackTop = -(rackHeight / 2);
    weaponX = 0;
    weaponY = rackTop;
  end

  local startWeapon = self.config.hideMelee and 2 or 1

  for weaponIndex = startWeapon, weaponCount do

    local weapon = player.weapons[weaponIndex];
    local color = weapon.color;

    -- if we havent picked up the weapon, colour it grey
    if not weapon.pickedup then
      color.r = 128;
      color.g = 128;
      color.b = 128;
    end

    local backgroundColor = Color(0,0,0,65)

    -- Frame background
    nvgBeginPath();
    nvgRect(weaponX,weaponY,self.config.weaponWidth,self.config.weaponHeight);

    if weaponIndex == player.weaponIndexSelected then
      backgroundColor.r = lerp(backgroundColor.r, color.r, player.weaponSelectionIntensity);
      backgroundColor.g = lerp(backgroundColor.g, color.g, player.weaponSelectionIntensity);
      backgroundColor.b = lerp(backgroundColor.b, color.b, player.weaponSelectionIntensity);
      backgroundColor.a = lerp(backgroundColor.a, 128, player.weaponSelectionIntensity);

      local outlineColor = Color(
        color.r,
        color.g,
        color.b,
        lerp(0, 255, player.weaponSelectionIntensity));

      nvgStrokeWidth(2);
      nvgStrokeColor(outlineColor);
      nvgStroke();
    end

    nvgFillColor(backgroundColor);
    nvgFill();

    -- Icon
    local iconRadius = self.config.weaponHeight * 0.40;
    local iconX = weaponX + (self.config.weaponHeight - iconRadius);
    local iconY = (self.config.weaponHeight / 2);
    local iconColor = color;

    if self.config.verticalRack then
      iconX = weaponX + iconRadius + 5;
      iconY = weaponY + (self.config.weaponHeight / 2);
    end

    if weaponIndex == player.weaponIndexSelected then
      iconColor.r = lerp(iconColor.r, 255, player.weaponSelectionIntensity);
      iconColor.g = lerp(iconColor.g, 255, player.weaponSelectionIntensity);
      iconColor.b = lerp(iconColor.b, 255, player.weaponSelectionIntensity);
      iconColor.a = lerp(iconColor.a, 255, player.weaponSelectionIntensity);
    end

    local svgName = "internal/ui/icons/weapon"..weaponIndex;
    nvgFillColor(iconColor);
    nvgSvg(svgName, iconX, iconY, iconRadius);

    -- Ammo
    local ammoX = weaponX + (iconRadius) + (self.config.weaponWidth / 2);
    local ammoCount = player.weapons[weaponIndex].ammo;

    if self.config.verticalRack then
      ammoX = weaponX + (self.config.weaponWidth / 2) + iconRadius;
    end

    if weaponIndex == 1 then ammoCount = "-" end

    nvgFontSize(self.config.weaponHeight);
    nvgFontFace("TitilliumWeb-Bold");
    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);

    nvgFontBlur(0);
    nvgFillColor(Color(255,255,255));
    nvgText(ammoX, weaponY, ammoCount);

    if self.config.verticalRack then
      weaponY = weaponY + self.config.weaponHeight + self.config.weaponSpacing;
    else
      weaponX = weaponX + self.config.weaponWidth + self.config.weaponSpacing;
    end

  end
end

function BonusWeaponRack:drawOptions(x, y)
  local sliderStart = 140
  local sliderWidth = 300

  self.config.verticalRack = uiCheckBox(self.config.verticalRack or false, "Vertical", x, y)
  y = y + 40

  self.config.hideMelee = uiCheckBox(self.config.hideMelee or false, "Hide Melee", x, y)
  y = y + 40

  uiLabel("WeaponWidth", x, y)
  self.config.weaponWidth = round(uiSlider(x + sliderStart, y, sliderWidth, 10, 300, self.config.weaponWidth))
  self.config.weaponWidth = round(uiEditBox(self.config.weaponWidth, x + sliderStart + sliderWidth + 10, y, 60));

  y = y + 40

  uiLabel("WeaponHeight", x, y)
  self.config.weaponHeight = round(uiSlider(x + sliderStart, y, sliderWidth, 5, 100, self.config.weaponHeight))
  self.config.weaponHeight = round(uiEditBox(self.config.weaponHeight, x + sliderStart + sliderWidth + 10, y, 60));
  y = y + 40


  uiLabel("Spacing", x, y)
  self.config.weaponSpacing = round(uiSlider(x + sliderStart, y, sliderWidth, -1, 50, self.config.weaponSpacing))
  self.config.weaponSpacing = round(uiEditBox(self.config.weaponSpacing, x + sliderStart + sliderWidth + 10, y, 60));

  saveUserData(self.config);
end
