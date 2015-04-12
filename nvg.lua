-- wrapper for exposed nanoVG

return {

  ------------------------------------------------------------------------------
  -- nano constants
  ------------------------------------------------------------------------------
  const = {
    hAlign = {
      left = 0,
      center = 1,
      right = 2
    },
    vAlign = {
      baseline = 0,
      top = 1,
      middle = 2,
      bottom = 3
    },
    solidity = {
      solid = 1,
      hole = 2
    }
  },


  -- State
  save = function()
    return _G.nvgSave()
  end,

  restore = function()
    return _G.nvgRestore()
  end,

  -- Font
  fontSize = function(size)
    return _G.nvgFontSize(size)
  end,
  fontFace = function(fontname)
    return _G.nvgFontFace(fontname)
  end,
  fontBlur = function(amount)
    return _G.nvgFontBlur(amount)
  end,
  textWidth = function(text)
    return _G.nvgTextWidth(text)
  end,

  -- returns table { minx, miny, maxx, maxy }
  textBounds = function(text)
    return _G.nvgTextBounds(text)
  end,

  -- Fill
  fillColor = function(color)
    _G.nvgFillColor(color)
  end,
  fillLinearGradient = function(startx, starty, endx, endy, startcol, endcol)
    _G.nvgFillLinearGradient(startx, starty, endx, endy, startcol, endcol)
  end,
  fillBoxGradient = function(x, y, w, h, rad, f, incol, outcol)
    _G.nvgFillBoxGradient(x, y, w, h, rad, f, incol, outcol)
  end,
  fillRadialGradient = function(cx, cy, in_rad, out_rad, in_col, out_col)
    _G.nvgFillRadialGradient(cx, cy, in_rad, out_rad, in_col, out_col)
  end,
  fill = function()
    _G.nvgFill()
  end,

  -- Stroke
  strokeColor = function(col)
    _G.nvgStrokeColor(col)
  end,
  strokeLinearGradient = function(startx, starty, endx, endy, startcol, endcol)
    _G.nvgStrokeLinearGradient(startx, starty, endx, endy, startcol, endcol)
  end,
  strokeBoxGradient = function(x, y, w, h, r, f, incol, outcol)
    _G.nvgStrokeBoxGradient(x, y, w, h, r, f, incol, outcol)
  end,
  strokeRadialGradient = function(cx, cy, in_rad, out_rad, in_col, out_col)
    _G.nvgStrokeRadialGradient(cx, cy, in_rad, out_rad, in_col, out_col)
  end,
  strokeWidth = function(width)
    _G.nvgStrokeWidth(width)
  end,
  stroke = function()
    _G.nvgStroke()
  end,

  -- Text
  textAlign = function(vert, horiz)
    _G.nvgTextAlign(vert, horiz)
  end,
  text = function(x, y, text)
    _G.nvgText(x, y, text)
  end,

  -- Paths
  beginPath = function()
    _G.nvgBeginPath()
  end,
  moveTo = function(x, y)
    _G.nvgMoveTo(x, y)
  end,
  lineTo = function(x, y)
    _G.nvgLineTo(x, y)
  end,
  bezierTo = function(c1x, c1y, c2x, c2y, x, y)
    _G.nvgBezierTo(c1x, c1y, c2x, c2y, x, y)
  end,
  quadTo = function(cx, cy, x, y)
    _G.nvgQuadTo(cx, cy, x, y)
  end,
  arcTo = function(x1, y1, x2, y2, r)
    _G.nvgArcTo(x1, y1, x2, y2, r)
  end,
  closePath = function()
    _G.nvgClosePath()
  end,
  pathWinding = function(solidity)
    _G.nvgPathWinding(solidity)
  end,

  -- Primitives
  arc = function(cx, cy, r, a0, a1, dir)
    _G.nvgArc(cx, cy, r, a0, a1, dir)
  end,
  rect = function(x, y, w, h)
    _G.nvgRect(x, y, w, h)
  end,
  roundedRect = function(x, y, w, h, r)
    _G.nvgRoundedRect(x, y, w, h, r)
  end,
  ellipse = function(x, y, rx, ry)
    _G.nvgEllipse(x, y, rx, ry)
  end,
  circle = function(x, y, r)
    _G.nvgCircle(x, y, r)
  end,

  -- Scissoring
  scissor = function(x, y, w, h)
    _G.nvgScissor(x, y, w, h)
  end,
  intersectScissor = function(x, y, w, h, r)
    _G.nvgIntersectScissor(x, y, w, h, r)
  end,
  resetScissor = function()
    _G.nvgResetScissor()
  end,

  -- Transform
  translate = function(x, y)
    _G.nvgTranslate(x, y)
  end,
  rotate = function(radians)
    _G.nvgRotate(radians)
  end,
  skewX = function(radians)
    _G.nvgSkewX(radians)
  end,
  skewY = function(radians)
    _G.nvgSkewY(radians)
  end,
  scale = function(x, y)
    _G.nvgScale(x, y)
  end,

  ------------------------------------------------------------------------------------------------
  --SVG BINDINGS
  ------------------------------------------------------------------------------------------------
  -- NOTE: swapped param names position to be inline with other functions
  Svg = function(x, y, name, rad)
    _G.nvgSvg(name, x, y, rad)
  end,

}
