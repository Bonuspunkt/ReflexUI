local configLoaded = false
local widgetStore = _G.__widgetStore or {}
local widgetConfig = {}

local widgetRegistry = {
  canHide = false,
  canPositon = false,

  register = function(widget)
    if widgetStore[widget.name] then
      _G.consolePrint("Widget " .. widget.name .. " already registered")
    end

    -- TODO: verifcation

    widgetStore[widget.name] = widget
  end,

  draw = function()

    for _, widget in pairs(widgetStore) do
      if not configLoaded and widgetConfig[widget.name] then
        widget.setConfig(widgetConfig[widget.name])
      end

      -- todo: widget.support(spec, pov, freeLook / 1v1, tdm, ffa, race) ?
      widget:draw()
    end

    configLoaded = true;
  end,

  getList = function()
    local result = {}
    for _, widget in pairs(widgetStore) do
      result[#result + 1] = widget
    end
    return result
  end
}

-- expose for reflex
_G.widgetRegistry = widgetRegistry
_G.registerWidget("widgetRegistry");


-- HACK: workaround for multiple file loads
_G.__widgetStore = widgetStore

return widgetRegistry;
