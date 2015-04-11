local FuncArray = require "base/internal/ui/bonus/_FuncArray"
local Color = require "base/internal/ui/bonus/_Color"

local function drawWidget(x, y, index, item, isSelected, mouse, itemWidth, itemHeight)
    nvgSave()

    nvgFontSize(FONT_SIZE_SMALL);
    nvgFontFace(FONT_TEXT_BOLD);
    nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);

    if isSelected then
        nvgFillColor(Color(255, 127, 127))
    else
        nvgFillColor(Color(255, 255, 255).lerp(Color(255,255,0), mouse.hoverAmount))
    end

    nvgText(x+10, y + itemHeight / 2 + 1, item.name);

    nvgRestore()

    return mouse.leftUp;
end

local function generateControls(itemDefinition, x, y, value)
    if itemDefinition.type == "align" then
        return y + 10, value

    elseif itemDefinition.type == "checkbox" then
        return y + 10, uiCheckBox(value, itemDefinition.name, x, y)

    elseif itemDefinition.type == "color" then
        return y, value
    end
    consolePrint('no match')
end

local selectedWidget
local scrollBarData = {}

WidgetMenu =
{
    isMenu = true,

    scrollBarData = {},
    draw = function()

        uiWindow("WIDGETS", -600, -400, 1200, 800);

        -- copy widgetList
        local widgets = {}
        for key,value in pairs(_G) do
            if type(value) == 'table' and value.draw then
                value.name = key
                widgets[#widgets + 1] = value
            end
        end
        local filteredWidgets = FuncArray(widgets)
            .filter(function(w)
                return w.isMenu ~= true
                    -- and w.canHide ~= false -- we removed this to work around ui_show_widget
            end)
            .sort(function(a, b)
                return a.name < b.name
            end).raw

        --selectedWidget = filteredWidgets[1]

        selectedWidget = uiScrollSelection(
            filteredWidgets,
            selectedWidget,
            -590,
            -350,
            585,
            740,
            scrollBarData,
            40,
            drawWidget
        )

        nvgFontSize(FONT_SIZE_SMALL);
        nvgFontFace(FONT_TEXT_BOLD);
        nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);


        if not selectedWidget then
            nvgText(5, -350, "NO WIDGET SELECTED")
            return
        end

        local configDefinition = selectedWidget.configDefinition
        if not configDefinition then
            nvgText(5, -350, "NO CONFIG DEFINITION AVAILABLE")
            return
        end

        local value
        local y = -350
        for key, definition in pairs(selectedWidget.configDefinition) do
            value = selectedWidget.config[definition.name]
            y, value = generateControls(definition, 5, y, value)

            consolePrint(key .. " value: " .. (value and 'true' or 'false'))

            selectedWidget.config[definition.name] = value
        end
    end
}
registerWidget("WidgetMenu");