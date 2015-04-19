local funcArray = require "./funcArray"

local function position(widgetName, width, height)
  local widget = funcArray(_G.widgets).first(function(w) return w.name == widgetName end)
  local anchor = widget.anchor;

  local left = -(anchor.x + 1) * width / 2;
  local top = -(anchor.y + 1) * height / 2;

  return left, top
end

return position
