require "base/internal/ui/reflexcore"

local armorColors = {
    Color(0, 255, 0, 255),
    Color(255, 255, 0, 255),
    Color(255, 0, 0, 255)
}

return {
    drawArmor = function(x, y, size, armorProtection)
        nvgSave()
        nvgFillColor(armorColors[armorProtection + 1]);
        nvgSvg("internal/ui/icons/armor", x, y, size)
        nvgRestore()
    end,

    drawMega = function(x, y, size, hasMega)
        if not hasMega then return end
        nvgSave()
        nvgFillColor(Color(60,80,255));
        nvgSvg("internal/ui/icons/health", x, y, size)
        nvgRestore()
    end
}