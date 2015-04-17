local function Averager(length)
    local index = 1
    local store = {}

    local averager = {};
    averager.add = function(number)
        store[index] = number
        index = index % length + 1

        return averager.get()
    end

    averager.get = function()
        local result = 0;
        for i = 1, #store do
            result = result + store[i]
        end
        return result / #store
    end

    return averager
end

return Averager;