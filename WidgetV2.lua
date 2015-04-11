--require "base/internal/ui/reflexcore"

BonusWidget =
{
    canHide = false,

    configDefinition = {
        { name = "visible", type = "checkbox" },
        { name = "align", type = "align" },
        { name = "textColor", type = "color" }
    },

    config = {
        visible = false,
        align = { x = 0, y = 0 },
        textColor = Color(255,255,255)
    },

    draw = function()
        local config = BonusWidget.config

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
registerWidget("BonusWidget");