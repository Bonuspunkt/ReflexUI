local lerp = function(a, b, k)
    return a * (1 - k) + b * k;
end


local Color = function(r,g,b,a)
    if a == nil then a = 255 end
    return {
        r = r,
        b = b,
        g = g,
        a = a,

        lerp = function(otherColor, k)
            return Color(
                lerp(r, otherColor.r, k),
                lerp(g, otherColor.g, k),
                lerp(b, otherColor.b, k),
                lerp(a, otherColor.a, k)
            )
        end
    }
end

return Color