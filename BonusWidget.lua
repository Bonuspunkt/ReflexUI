local registry = require "base/internal/ui/bonus/widgetRegistry"

local config = {
    visible = false,
    align = { x = 0, y = 0 },
    textColor = Color(255,255,255)
}


local bonusWidget =
{
    name = "Bonus Widget",
    description = "Sample proof of concept",

    canHide = false,

    configDefinition = {
        { name = "visible", type = "checkbox" },
        { name = "align", type = "align" },
        { name = "textColor", type = "color" }
    },

    getConfig = function() return config end,
    setConfig = function(newConfig) config = newConfig end,

    draw = function()
        --consolePrint("draw: " .. bonusWidget.name)

        if not config.visible then return end

        nvgFontSize(64);
        nvgFontFace(FONT_TEXT_BOLD)
        nvgFillColor(config.textColor)

        local hAlign = NVG_ALIGN_CENTER
        local vAlign = NVG_ALIGN_MIDDLE
        local x = 0
        local y = 0

        if config.align.x == -1 then
            x = -viewport.width / 2
            hAlign = NVG_ALIGN_LEFT
        elseif config.align.x == 1 then
            x = viewport.width / 2
            hAlign = NVG_ALIGN_RIGHT
        end

        if config.align.y == -1 then
            y = -viewport.height / 2 + 100 -- +100 for top menu bar
            vAlign = NVG_ALIGN_TOP
        elseif config.align.y == 1 then
            y = viewport.height / 2
            vAlign = NVG_ALIGN_BOTTOM
        end

        nvgTextAlign(hAlign, vAlign)
        nvgText(x, y, "BonusWidget POC")
    end
};
registry.register(bonusWidget);