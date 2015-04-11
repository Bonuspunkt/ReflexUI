local FuncArray = require "base/internal/ui/bonus/_FuncArray"
local Color = require "base/internal/ui/bonus/_Color"

local crosshair;
local shouldDraw = false;

WidgetList =
{
    canHide = false,
    canPosition = false,

    draw = function()

        local currentCrosshair = consoleGetVariable('cl_crosshair')

        if crosshair == nil then
            crosshair = currentCrosshair
        end
        if (currentCrosshair == 666) then
            shouldDraw = not shouldDraw
            consolePerformCommand('cl_crosshair ' .. crosshair)
        end

        if not shouldDraw then
            if #players ~= 0 then
                return
            end
        end

        nvgFontFace("TitilliumWeb-Bold");
        nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_TOP);

        local widgets = {}
        for key,value in pairs(_G) do
            if type(value) == 'table' and value.draw then
                value.name = key
                widgets[#widgets + 1] = value
            end
        end

        local offsetX = - viewport.width / 2 + 250;
        local offsetY = - viewport.height / 2 + 100;

        nvgFontSize(36)
        nvgFillColor(Color(255,0,0))
        nvgText(offsetX, offsetY, "AVAILABLE WIDGETS")

        nvgFontSize(32)
        nvgFillColor(Color(255,255,255))
        FuncArray(widgets)
            .filter(function(w)
                return w.canHide ~= false
                    and w.isMenu ~= true
            end)
            .sort(function(a, b)
                return a.name < b.name
            end)
            .forEach(function(w, i)
                -- info about canPosition

                nvgText(offsetX, offsetY + 30*i, w.name)
            end)

    end
};
registerWidget("WidgetList");

--consolePerformCommand("bind i cl_crosshair 666")