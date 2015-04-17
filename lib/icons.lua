local nvg = require "../nvg"
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
