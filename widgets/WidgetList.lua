local funcArray = require "base/internal/ui/bonus/lib/funcArray"
local color = require "base/internal/ui/bonus/lib/color"
local nvg = require "base/internal/ui/bonus/nvg"

local crosshair;
local shouldDraw = false;

_G.WidgetList =
{
  canHide = false,
  canPosition = false,

  draw = function()

    -- hack for toggling
    local currentCrosshair = _G.consoleGetVariable('cl_crosshair')

    if crosshair == nil then
      crosshair = currentCrosshair
    end
    if (currentCrosshair == 666) then
      shouldDraw = not shouldDraw
      _G.consolePerformCommand('cl_crosshair ' .. crosshair)
    end

    if not shouldDraw then
      if #_G.players ~= 0 then
        return
      end
    end

    nvg.fontFace("TitilliumWeb-Bold");
    nvg.textAlign(nvg.const.hAlign.left, nvg.const.vAlign.top);

    local widgets = {}
    for key,value in pairs(_G) do
      if type(value) == 'table' and value.draw then
        value.name = key
        widgets[#widgets + 1] = value
      end
    end

    local offsetX = - _G.viewport.width / 2 + 250;
    local offsetY = - _G.viewport.height / 2 + 100;

    nvg.fontSize(36)
    nvg.fillColor(color.new(255,0,0))
    nvg.text(offsetX, offsetY, "AVAILABLE WIDGETS")

    nvg.fontSize(32)
    nvg.fillColor(color.new(255,255,255))
    funcArray(widgets)
      .filter(function(w)
        return w.canHide ~= false
          and w.isMenu ~= true
      end)
      .sort(function(a, b)
        return a.name < b.name
      end)
      .forEach(function(w, i)
        -- info about canPosition

        nvg.text(offsetX, offsetY + 30*i, w.name)
      end)

  end
};

_G.registerWidget("WidgetList");

-- NOTE: to enable this widget remove the comment from the following line
--consolePerformCommand("bind i cl_crosshair 666")
