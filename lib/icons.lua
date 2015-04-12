local color = require "base/internal/ui/bonus/lib/color"

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

    _G.nvgSave()
    _G.nvgFillColor(armorColor);
    _G.nvgSvg("internal/ui/icons/armor", x, y, size)
    _G.nvgRestore()
  end,

  -- TODO: replace params with table
  drawMega = function(x, y, size, hasMega)
    local healthColor
    if hasMega then
      healthColor = color.new(60,80,255)
    else
      healthColor = color.new(64,64,64)
    end

    _G.nvgSave()
    _G.nvgFillColor(healthColor);
    _G.nvgSvg("internal/ui/icons/health", x, y, size)
    _G.nvgRestore()
  end,

  -- TODO: replace params with table
  drawCarnage = function(x, y, size, carnageTimer)
    if carnageTimer <= 0 then return end
    _G.nvgSave()
    _G.nvgFillColor(color(255,120,128))
    _G.nvgSvg("internal/ui/icons/carnage", x, y, size)
    _G.nvgRestore()
  end,

  -- TODO: replace params with table
  drawWeapon = function(x, y, size, weaponIndex, weaponColor) -- would prefeer only weaponIndex but weapons if on player
    _G.nvgSave()
    _G.nvgFillColor(weaponColor);
    _G.nvgSvg("internal/ui/icons/weapon" .. weaponIndex, x, y, size);
    _G.nvgRestore()
  end
}
