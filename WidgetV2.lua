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

        --consolePrint("visible: " .. (config.visible and 'true' or 'false'))

        if not config.visible then return end

        consolePrint('DRAWING')

        nvgFontSize(64);
        nvgFontFace(FONT_TEXT_BOLD);
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
        nvgText(0, 0, "BonusWidget POC")
    end
};
registerWidget("BonusWidget");