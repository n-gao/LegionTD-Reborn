function ShallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function AngleFromVector(vec)
    vec = vec:Normalized();
    local angle = math.acos(vec.x);
    if (vec.y < 0) then
        angle = -angle;
    end
    return angle/math.pi * 180;
end

function WrapObjectFunction(instance, functionName)
    if type(instance[functionName]) ~= "function" then
        error(functionName.." is not a function of the given instance.");
    end
    return function (...)
        instance[functionName](...);
    end
end

function string.split(str)
    local result = {}
    for i in string.gmatch(str, "%S+") do
        table.insert(result, i);
    end
    return result;
end

function math.round(num, nearest)
    num = num / nearest
    num = math.floor(num)
    num = num * nearest
    return num, num / nearest
end

function table.count(tab)
    local result = 0
    for k, v in pairs(tab) do
        result = result + 1
    end
    return result
end
