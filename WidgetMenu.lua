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

local function uiAlign(x, y, width, height, value)
    local baseColor = Color(255,255,255, 32)
    local activeColor = Color(255,255,255,192)
    local selectedColor = Color(255,127,127,192)

    local m;
    local stepWidth = width / 3
    local stepHeight = height / 3
    for i = 0, 2, 1 do
        for j = 0, 2, 1 do

            m = mouseRegion(x + i * stepWidth, y + j * stepHeight, stepWidth, stepHeight, i * 3 + j)

            nvgBeginPath()
            nvgRect(x + i * stepWidth, y + j * stepHeight, stepWidth, stepHeight)
            if value.x == i-1 and value.y == j-1 then
                nvgFillColor(selectedColor)
            else
                nvgFillColor(baseColor.lerp(activeColor, m.hoverAmount))
            end
            nvgFill();

            if m.leftUp then
                return { x = i - 1, y = j - 1 }
            end

        end
    end
    return value
end

local function generateControls(itemDefinition, x, y, value)
    if itemDefinition.type == "align" then
        nvgText(x, y, itemDefinition.name);
        value = uiAlign(x, y + 20, 60, 60, value)
        return y + 90, value

    elseif itemDefinition.type == "checkbox" then
        nvgSave()
        -- uiCheckbox leaks color
        value = uiCheckBox(value, itemDefinition.name, x, y)
        nvgRestore()

        return y + 50, value

    elseif itemDefinition.type == "color" then
        nvgFillColor(Color(200,200,200))
        nvgText(x, y, itemDefinition.name);
        y = y + 30

        nvgText(x, y, "R")
        value.r =uiSlider(x + 30, y, 400, 0, 255, value.r);
        y = y + 30

        nvgText(x, y, "G")
        value.g = uiSlider(x + 30, y, 400, 0, 255, value.g);
        y = y + 30

        nvgText(5, y, "B")
        value.b = uiSlider(x + 30, y, 400, 0, 255, value.b);
        y = y + 30

        nvgSave()

        nvgBeginPath();
        nvgRect(450, y - 120, 120, 120);
        nvgFillColor(value);
        nvgFill()

        nvgRestore()

        return y, value
    end
    consolePrint('no match for type ' .. itemDefinition.type)
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

            selectedWidget.config[definition.name] = value
        end
    end
}
registerWidget("WidgetMenu");