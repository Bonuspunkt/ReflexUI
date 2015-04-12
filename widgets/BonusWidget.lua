local registry = require "base/internal/ui/bonus/widgetRegistry"
local color = require "base/internal/ui/bonus/lib/color"
local nvg = require "base/internal/ui/bonus/nvg"
local const = require "base/internal/ui/bonus/const"

local config = {
    visible = false,
    align = { x = 0, y = 0 },
    textColor = color.new(255,255,255)
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

        nvg.fontSize(64);
        nvg.fontFace(const.font.textBold)
        nvg.fillColor(config.textColor)

        local hAlign = nvg.const.hAlign.center
        local vAlign = nvg.const.vAlign.middle
        local x = 0
        local y = 0

        if config.align.x == -1 then
            x = -_G.viewport.width / 2
            hAlign = nvg.const.hAlign.left
        elseif config.align.x == 1 then
            x = _G.viewport.width / 2
            hAlign = nvg.const.hAlign.right
        end

        if config.align.y == -1 then
            y = -_G.viewport.height / 2 + 100 -- +100 for top menu bar
            vAlign = nvg.const.vAlign.top
        elseif config.align.y == 1 then
            y = _G.viewport.height / 2
            vAlign = nvg.const.vAlign.bottom
        end

        nvg.textAlign(hAlign, vAlign)
        nvg.text(x, y, "BonusWidget POC")
    end
};
registry.register(bonusWidget);
