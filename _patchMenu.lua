require "base/internal/ui/widgets/MenuBar"

local uiMenuBarButton = _G.uiMenuBarButton
local setMenuStack = _G.setMenuStack
local registerWidget = _G.registerWidget


local baseDraw = function() end
local draw = function()
  baseDraw();

  if _G.MenuBar.visibility <= 0 then return end

  if uiMenuBarButton("Widgets", 300, -540, 200, 100, 255) then
      setMenuStack("WidgetMenu");
  end
end

_G.__PatchMenu =
{
    canHide = false,

    draw = function()

        if _G.MenuBar.draw ~= draw then
          baseDraw = _G.MenuBar.draw
          _G.MenuBar.draw = draw;
        end
    end
};
registerWidget("__PatchMenu");
