require "base/internal/ui/reflexcore"
local const = (function()
-- inlined ../const
return {
  state = {
    disconnect = 0,
    connecting = 1,
    connected = 2
  },
  -- see players[1].state
  gameState = {
    warmup = 0,
    active = 1,
    roundPrepare = 2,
    roundActive = 3,
    roundCooldownSomeoneWon = 4,
    roundCooldownDraw = 5,
    gameover = 6
  },
  -- see world.gameState
  playerState = {
    ingame = 1,
    spectator = 2,
    editor = 3,
    queued = 4
  },
  -- see pickupTimers[1].type
  pickupType = {
    burstGun = 0,
    shotgun = 1,
    grenadeLauncher = 2,
    machineGun = 3,
    rocketLauncer = 4,
    ionCannon = 5,
    boltRifle = 6,
    stakeGun = 7,

    health5 = 40,
    health25 = 41,
    health50 = 42,
    health100 = 43,

    armor5 = 50,
    armor50 = 51,
    armor100 = 52,
    armor150 = 53,

    powerupCarnage = 60
  },

  font = {
    header = "oswald-bold";
    hud = "oswald-bold";
    text = "roboto-regular";
    textBold = "roboto-bold";
    sizeDefault = 24;
    sizeSmall = 22;
  }
}

end)()
local nvg = (function()
-- inlined ../nvg
-- wrapper for exposed nanoVG

return {

  ------------------------------------------------------------------------------
  -- nano constants
  ------------------------------------------------------------------------------
  const = {
    hAlign = {
      left = _G.NVG_ALIGN_LEFT,
      center = _G.NVG_ALIGN_CENTER,
      right = _G.NVG_ALIGN_RIGHT
    },
    vAlign = {
      baseline = _G.NVG_ALIGN_BASELINE,
      top = _G.NVG_ALIGN_TOP,
      middle = _G.NVG_ALIGN_MIDDLE,
      bottom = _G.NVG_ALIGN_BOTTOM
    },
    solidity = {
      solid = _G.NVG_SOLID,
      hole = _G.NVG_HOLE
    },
    winding = {
      ccw = _G.NVG_CCW,
      cw = _G.NVG_CW
    }
  },


  -- State
  save = _G.nvgSave,
  restore = _G.nvgRestore,

  -- Font
  fontSize = _G.nvgFontSize,
  fontFace = _G.nvgFontFace,
  fontBlur = _G.nvgFontBlur,
  textWidth = _G.nvgTextWidth,

  -- returns table { minx, miny, maxx, maxy }
  textBounds = _G.nvgTextBounds,

  -- Fill
  fillColor = _G.nvgFillColor,
  fillLinearGradient = _G.nvgFillLinearGradient,
  fillBoxGradient = _G.nvgFillBoxGradient,
  fillRadialGradient = _G.nvgFillRadialGradient,
  fill = _G.nvgFill,

  -- Stroke
  strokeColor = _G.nvgStrokeColor,
  strokeLinearGradient = _G.nvgStrokeLinearGradient,
  strokeBoxGradient = _G.nvgStrokeBoxGradient,
  strokeRadialGradient = _G.nvgStrokeRadialGradient,
  strokeWidth = _G.nvgStrokeWidth,
  stroke = _G.nvgStroke,

  -- Text
  textAlign = _G.nvgTextAlign,
  text = _G.nvgText,

  -- Paths
  beginPath = _G.nvgBeginPath,
  moveTo = _G.nvgMoveTo,
  lineTo = _G.nvgLineTo,
  bezierTo = _G.nvgBezierTo,
  quadTo = _G.nvgQuadTo,
  arcTo = _G.nvgArcTo,
  closePath = _G.nvgClosePath,
  pathWinding = _G.nvgPathWinding,

  -- Primitives
  arc = _G.nvgArc,
  rect = _G.nvgRect,
  roundedRect = _G.nvgRoundedRect,
  ellipse = _G.nvgEllipse,
  circle = _G.nvgCircle,

  -- Scissoring
  scissor = _G.nvgScissor,
  intersectScissor = _G.nvgIntersectScissor,
  resetScissor = _G.nvgResetScissor,

  -- Transform
  translate = _G.nvgTranslate,
  rotate = _G.nvgRotate,
  skewX = _G.nvgSkewX,
  skewY = _G.nvgSkewY,
  scale = _G.nvgScale,

  ------------------------------------------------------------------------------------------------
  --SVG BINDINGS
  ------------------------------------------------------------------------------------------------
  -- NOTE: swapped param names position to be inline with other functions
  svg = function(x, y, name, rad)
    _G.nvgSvg(name, x, y, rad)
  end,

}

end)()
local ui = (function()
-- inlined ../ui
require "base/internal/ui/reflexcore"

return {
  -- stuff from reflexCore
  window = _G.uiWindow,
  button = _G.uiButton,
  buttonVertical = _G.uiButtonVertical,
  slider = _G.uiSlider,
  progressBar = _G.uiProgressBar,
  scrollBar = _G.uiScrollBar,
  subHeader = _G.uiSubHeader,
  toolTip = _G.uiToolTip,
  checkBox = _G.uiCheckBox,
  editBox = _G.uiEditBox,
  label = _G.uiLabel,
  comboBox = _G.uiComboxBox,

  scrollSelection = _G.uiScrollSelection,
  scrollSelectionItem = _G.uiScrollSelectionItem
}

end)()
local userData = (function()
-- inlined ../userData
return {
  load = _G.loadUserData,
  save = _G.saveUserData
}

end)()
local color = (function()
-- inlined ../lib/color
require "base/internal/ui/reflexcore"

local lerp = function(a, b, k)
  return a * (1 - k) + b * k;
end

local Color = _G.Color

return {
  new = function(r,g,b,a)
    return Color(r,g,b,a)
  end,

  lerp = function(colorA, colorB, k)
    return Color(
      lerp(colorA.r, colorB.r, k),
      lerp(colorA.g, colorB.g, k),
      lerp(colorA.b, colorB.b, k),
      lerp(colorA.a, colorB.a, k)
    )
  end
}

end)()
local funcArray = (function()
-- inlined ../lib/funcArray
local function add(array, value)
    array[#array + 1] = value
end


local function FuncArray(array)

    local result = {
        map = function(func)
            local newTable = {}
            for i = 1, #array do
                newTable[i] = func(array[i], i, array)
            end

            return FuncArray(newTable)
        end,

        filter = function(func)
            local newTable = {}
            for i = 1, #array do
                if func(array[i], i) then
                    newTable[#newTable+1] = array[i]
                end
            end

            return FuncArray(newTable)
        end,

        forEach = function(func)
            for i = 1, #array do
                func(array[i], i, array)
            end
        end,

        reduce = function(func, initialValue)
            for i = 1, #array do
                initialValue = func(initialValue, array[i], i, array);
            end
            return initialValue
        end,

        sort = function(func)
            local newArray = {}
            for i = 1, #array do
                newArray[i] = array[i]
            end
            table.sort(newArray, func)

            return FuncArray(newArray)
        end,

        first = function(func)
            for i = 1, #array do
                if func(array[i], i, array) then
                    return array[i]
                end
            end
        end,

        groupBy = function(func)
            local newArray = FuncArray({})
            for i = 1, #array do
                local key = func(array[i], i, array);
                local match = newArray.first(function(other) return other.key == key end)
                if not match then
                    match = { key = key, values = FuncArray({ array[i] }) }
                    add(newArray.raw, match)
                else
                    add(match.values.raw, array[i]);
                end
            end

            return newArray
        end,

        concat = function(otherArray)
            local result = {}
            for i = 1, #array do
                add(result, array[i])
            end

            if otherArray.raw then otherArray = otherArray.raw end
            for j = 1, #otherArray do
                add(result, otherArray[j])
            end

            return FuncArray(result)
        end,

        -- escape the fancyness
        raw = array
    }

    -- setmetatable(result, {
    --     __len = function() return #array end, -- does not work with lua 5.1
    --     __index = function(v, i)
    --         return array[i]
    --     end,
    --     __newindex = function(v, i, value)
    --         array[i] = value
    --     end
    -- })

    return result
end

return FuncArray;
end)()

local widgetName = "MiniScores"
local ORIENTATION_HORZ = "Horizontal"
local ORIENTATION_VERT = "Vertical"
local orientations = { ORIENTATION_HORZ, ORIENTATION_VERT }
local orientationState = {}
local config

local function initOrFixConfig()
  if not config then config = userData.load() or {} end

  if not config.ourColor then config.ourColor = color.new(64,64,255,64) end
  if not config.diffColor then config.diffColor = color.new(255,255,255,64) end
  if not config.theirColor then config.theirColor = color.new(255,64,64,64) end
  if not config.orientation then config.orientation = ORIENTATION_HORZ end
end

local function drawColorSliders(x, y, label, table, property)

  ui.label(label, x, y+30);

  table[property].r = ui.slider(x + 120, y+0,  255, 0, 255, table[property].r)
  table[property].g = ui.slider(x + 120, y+20, 255, 0, 255, table[property].g)
  table[property].b = ui.slider(x + 120, y+40, 255, 0, 255, table[property].b)
  table[property].a = ui.slider(x + 120, y+60, 255, 0, 255, table[property].a)

  nvg.beginPath()
  nvg.rect(x + 400, y, 100, 90)
  nvg.fillColor(table[property])
  nvg.fill()
end


local MiniScores = {

  draw = function()

    -- Early out if HUD should not be shown.
    if not _G.shouldShowHUD() then return end;

    initOrFixConfig()

    -- Find player
    local player = _G.getPlayer()

    local textColor = color.new(255,255,255)

    nvg.fontFace(const.font.textBold)
    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)

    local activePlayers = funcArray(_G.players).filter(
      function(p)
        return p.state == const.playerState.ingame
          and p.connected;
      end
    )

    local ourScore = 0;
    local theirScore = 0;
    local gameMode = _G.gamemodes[_G.world.gameModeIndex].shortName;

    if gameMode == "tdm" or gameMode == "atdm" then
      ourScore = activePlayers
        .filter(function(p) return player.team == p.team end)
        .map(function(p) return p.score end)
        .reduce(function(prev, curr) return prev + curr end, 0)
      theirScore = activePlayers
        .filter(function(p) return player.team ~= p.team end)
        .map(function(p) return p.score end)
        .reduce(function(prev, curr) return prev + curr end, 0)

    elseif gameMode == "1v1" then
      ourScore = player.score;
      theirScore = activePlayers
        .filter(function(p) return player ~= p end)
        .map(function(p) return p.score; end)
        .reduce(function(prev, curr) return prev + curr end, 0)

    elseif gameMode == "a1v1" or gameMode == "ffa" or gameMode == "affa" then
      ourScore = player.score;
      theirScore = activePlayers
        .filter(function(p) return player ~= p; end)
        .map(function(p) return p.score; end)
        .reduce(function(prev, curr) return math.max(prev, curr) end, 0)
    end

    -- calculate positions
    nvg.fontSize(64);
    local size = nvg.textBounds("-888")
    local padding = 5
    local width = (size.maxx - size.minx) + 2 * padding
    local height = (size.maxy - size.miny) -- height is way off so no need for padding XD

    local count = config.showDiff and 3 or 2
    local x = -width * count / 2
    local y = 0

    -- some helpers
    local function step()
      if (config.orientation == ORIENTATION_HORZ) then
        x = x + width
      else
        y = y + height
      end
    end

    local function drawScore(color, text)
      nvg.beginPath();
      nvg.rect(x, y, width, height);
      nvg.fillColor(color);
      nvg.fill();

      nvg.fillColor(textColor);
      nvg.text(x + width/2, y + height / 2, text);
    end

    -- our score
    drawScore(config.ourColor, ourScore)
    step()

    -- difference
    if config.showDiff then
      drawScore(config.diffColor, ourScore - theirScore)
      step()
    end

    -- their score
    drawScore(config.theirColor, theirScore)
    step()
  end,

  drawOptions = function(_, x, y)
    initOrFixConfig()

    ui.label("Orientation", x, y)
    local comboX = x + 120
    local comboY = y
    y = y + 40

    drawColorSliders(x, y, "Your Score", config, "ourColor")

    -- we draw he comboBox after the sliders, because the comboBox dropdown
    -- must be drawn over the sliders
    config.orientation = ui.comboBox(orientations, config.orientation, comboX, comboY, 255, orientationState)
    y = y + 90

    config.showDiff = ui.checkBox(config.showDiff or false, "Show Diff", x, y)
    y = y + 30

    if config.showDiff then
      drawColorSliders(x, y, "Score Diff", config, "diffColor")
      y = y + 90
    end

    drawColorSliders(x, y, "Other Score", config, "theirColor")

    userData.save(config);
  end
};

_G[widgetName] = MiniScores;
_G.registerWidget(widgetName);
