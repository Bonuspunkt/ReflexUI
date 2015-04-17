-- Animations definitions
local function easeLinear(k) return k end
local function easeQuad(k) return k*k end
local function easeCubic(k) return k*k*k end
local function easeQuart(k) return k*k*k*k end
local function easeQuint(k) return k*k*k*k*k end
local function easeSine(k) return math.cos(k * math.pi/2) end

-- Transformations
local function out(fn)
  return function(k)
    return 1 - fn(1 - k)
  end
end
local function inOut(fn)
  return function(k)
    if k < 0.5 then
      return 0.5 * fn(2*k)
    else
      k = k - 0.5
      return 0.5 + out(2*k)
    end
  end
end

-- Animator
local function Animator(fn)

  return function(duration)
    local elapsed = 0;

    return {
      update = function()
        elapsed = elapsed + (_G.deltaTimeRaw * 1000)
        if (elapsed > duration) then return 1 end

        local k = elapsed / duration
        return fn(k, 0, 1, 1)
      end,
      reset = function()
        elapsed = 0
      end
    }
  end
end

return {
  easeLinear = Animator(easeLinear),

  easeInQuad = Animator(easeQuad),
  easeOutQuad = Animator(out(easeQuad)),
  easeInOutQuad = Animator(inOut(easeQuad)),

  easeInCubic = Animator(easeCubic),
  easeOutCubic = Animator(out(easeCubic)),
  easeInOutCubic = Animator(inOut(easeCubic)),

  easeInQuart = Animator(easeQuart),
  easeOutQuart = Animator(out(easeQuart)),
  easeInOutQuart = Animator(inOut(easeQuart)),

  easeInQuint = Animator(easeQuint),
  easeOutQuint = Animator(out(easeQuint)),
  easeInOutQuint = Animator(inOut(easeQuint)),

  easeInSine = Animator(easeSine),
  easeOutSine = Animator(out(easeSine)),
  easeInOutSine = Animator(inOut(easeSine)),

  Animator = Animator,
  transformations = {
    out = out,
    inOut = inOut
  }
}
