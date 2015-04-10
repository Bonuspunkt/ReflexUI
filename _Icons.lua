local Color = require "base/internal/ui/bonus/_Color"

local armorColors = {
    Color(0, 255, 0, 255),
    Color(255, 255, 0, 255),
    Color(255, 0, 0, 255)
}

return {
    drawArmor = function(x, y, size, armorProtection, lerpColor)
        local color = armorColors[armorProtection + 1];

        if lerpColor then
            color = color.lerp(lerpColor, .75)
        end

        nvgSave()
        nvgFillColor(color);
        nvgSvg("internal/ui/icons/armor", x, y, size)
        nvgRestore()
    end,

    drawMega = function(x, y, size, hasMega)
        local healthColor
        if hasMega then
            healthColor = Color(60,80,255)
        else
            healthColor = Color(64,64,64)
        end

        nvgSave()
        nvgFillColor(healthColor);
        nvgSvg("internal/ui/icons/health", x, y, size)
        nvgRestore()
    end,

    drawCarnage = function(x, y, size, carnageTimer)
        if carnageTimer <= 0 then return end
        nvgSave()
        nvgFillColor(Color(255,120,128))
        nvgSvg("internal/ui/icons/carnage", x, y, size)
        nvgRestore()
    end,

    drawWeapon = function(x, y, size, weaponIndex, weaponColor) -- would prefeer weaponIndex but weapons if on player
        nvgSave()
        nvgFillColor(weaponColor);
        nvgSvg("internal/ui/icons/weapon" .. weaponIndex, x, y, size);
        nvgRestore()
    end
}