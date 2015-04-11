local FuncArray = require "base/internal/ui/bonus/_FuncArray"

WidgetList =
{
    draw = function()

        nvgFontFace("TitilliumWeb-Bold");
        nvgFontSize(32)
        nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_TOP);

        local widgets = {}
        for key,value in pairs(_G) do
            if type(value) == 'table' and value.draw then
                value.name = key
                widgets[#widgets + 1] = value
            end
        end

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

                nvgText(300, 30*i, w.name)
            end)

    end
};
registerWidget("WidgetList");