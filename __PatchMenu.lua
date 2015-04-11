--require "base/internal/ui/reflexcore"

local menuIsPatched = false

__PatchMenu =
{
    canHide = false,

    draw = function()

        if menuIsPatched then return end

        local draw = MenuBar.draw;

        MenuBar.draw = function()
            draw(MenuBar);

            if uiMenuBarButton("WIDGETS", 300, -540, 200, 100, 255) then
                setMenuStack("WidgetMenu");
            end
        end

        menuIsPatched = true

    end
};
registerWidget("__PatchMenu");