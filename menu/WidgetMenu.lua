local color = require "base/internal/ui/bonus/lib/color"
local registry = require "base/internal/ui/bonus/widgetRegistry"
local nvg = require "base/internal/ui/bonus/nvg"
local const = require "base/internal/ui/bonus/const"
local ui = require "base/internal/ui/bonus/ui"
local mouseRegion = _G.mouseRegion


local function drawWidgetListItem(x, y, _, item, isSelected, mouse, itemWidth, itemHeight)
  nvg.save()
  nvg.fontFace(const.font.textBold)
  nvg.textAlign(nvg.const.hAlign.left, nvg.const.vAlign.top)

  nvg.beginPath()
  nvg.rect(x,y,itemWidth, itemHeight);
  nvg.fillColor(color.lerp(color.new(0, 0, 0, 0), color.new(0,0,0, 64), mouse.hoverAmount))
  nvg.fill()

  if isSelected then
    nvg.fillColor(color.new(255, 127, 127))
  else
    nvg.fillColor(color.lerp(color.new(255, 255, 255), color.new(255,255,0), mouse.hoverAmount))
  end

  nvg.fontSize(const.font.sizeDefault)
  nvg.text(x+10, y, item.name);
  nvg.fontSize(const.font.sizeSmall)
  nvg.text(x+10, y + itemHeight/ 2 - 3, item.description or '');

  nvg.restore()

  return mouse.leftUp;
end

local function uiAlign(x, y, width, height, value)
    local baseColor = color.new(255,255,255, 32)
    local activeColor = color.new(255,255,255,192)
    local selectedColor = color.new(255,127,127,192)

    local m;
    local stepWidth = width / 3
    local stepHeight = height / 3
    for i = 0, 2, 1 do
      for j = 0, 2, 1 do

        m = mouseRegion(x + i * stepWidth, y + j * stepHeight, stepWidth, stepHeight, i * 3 + j)

        nvg.beginPath()
        nvg.rect(x + i * stepWidth, y + j * stepHeight, stepWidth, stepHeight)
        if value.x == i-1 and value.y == j-1 then
            nvg.fillColor(selectedColor)
        else
            nvg.fillColor(color.lerp(baseColor, activeColor, m.hoverAmount))
        end
        nvg.fill();

        if m.leftUp then
            return { x = i - 1, y = j - 1 }
        end

      end
    end
    return value
end

local function generateControls(itemDefinition, x, y, value)
  if itemDefinition.type == "align" then
    nvg.text(x, y, itemDefinition.name);
    value = uiAlign(x, y + 20, 60, 60, value)
    return y + 90, value

  elseif itemDefinition.type == "checkbox" then
    nvg.save()
    -- uiCheckbox leaks color
    value = ui.checkBox(value, itemDefinition.name, x, y)
    nvg.restore()

      return y + 50, value

  elseif itemDefinition.type == "color" then
    nvg.fillColor(color.new(200,200,200))
    nvg.text(x, y, itemDefinition.name);
    y = y + 30

    nvg.text(x, y, "R")
    value.r =ui.slider(x + 30, y, 400, 0, 255, value.r);
    y = y + 30

    nvg.text(x, y, "G")
    value.g = ui.slider(x + 30, y, 400, 0, 255, value.g);
    y = y + 30

    nvg.text(5, y, "B")
    value.b = ui.slider(x + 30, y, 400, 0, 255, value.b);
    y = y + 30

    nvg.text(5, y, "A")
    value.a = ui.slider(x + 30, y, 400, 0, 255, value.a);
    y = y + 30

    nvg.save()

    nvg.beginPath();
    nvg.rect(450, y - 120, 120, 120);
    nvg.fillColor(value);
    nvg.fill()

    nvg.restore()

    return y, value
  end
  _G.consolePrint('no match for type ' .. itemDefinition.type)
end

local selectedWidget
local scrollBarData = {}

_G.WidgetMenu =
{
  isMenu = true,

  scrollBarData = {},
  draw = function()

    ui.window("WIDGETS", -600, -400, 1200, 800);

    local widgetList = registry.getList()

    -- copy widgetList
    selectedWidget = ui.scrollSelection(
      widgetList,
      selectedWidget,
      -590,
      -350,
      585,
      740,
      scrollBarData,
      50,
      drawWidgetListItem
    )

    nvg.fontSize(const.font.sizeSmall);
    nvg.fontFace(const.font.textBold);
    nvg.textAlign(nvg.const.hAlign.left, nvg.const.vAlign.middle);


    if not selectedWidget then
      nvg.text(5, -350, "NO WIDGET SELECTED")
      return
    end

    local configDefinition = selectedWidget.configDefinition
    if not configDefinition then
      nvg.text(5, -350, "NO CONFIG DEFINITION AVAILABLE")
      return
    end

    local value
    local config
    if selectedWidget.config then
      config = selectedWidget.config
    elseif selectedWidget.getConfig then
      config = selectedWidget:getConfig()
    else
      _G.consolePrint("NO CONFIG FOUND")
    end

    local y = -350
    local newConfig = {}
    for _, definition in pairs(configDefinition) do
      value = config[definition.name]

      y, value = generateControls(definition, 5, y, value)

      newConfig[definition.name] = value
    end

    if selectedWidget.setConfig then
      selectedWidget.setConfig(newConfig)
    else
      selectedWidget.config = newConfig
    end

  end
}
_G.registerWidget("WidgetMenu");
