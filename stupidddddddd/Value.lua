-- ReplicatedStorage.Packages.DebugTools.Shared.Value
-- Script path: ReplicatedStorage.Packages.DebugTools.Shared.Value
-- Decompile time: 0.43 ms

local Signal = require(script.Parent.Signal)
local u5 = {}
u5.__index = u5

function u5.new(a1) -- Line: 6 -- upvalues: Signal (val), u5 (val)
    return (setmetatable({
        _value = a1,
        _changed = Signal.new(),
        __tostring = function(a1) -- Line: 10
            return "Value<" .. a1._value .. ">"
        end,
    }, u5))
end

function u5.Observe(a1, a2) -- Line: 18 -- types: a1: table, a2: function
    a2(a1._value)
    return a1._changed:Connect(a2)
end

function u5.Subscribe(a1, a2) -- Line: 23 -- types: a1: table, a2: function
    return a1._changed:Connect(a2)
end

function u5.Set(a1, a2, a3) -- Line: 27 -- types: a1: table, a3: boolean?
    if not a3 and a2 == a1._value then
        return
    end
    a1._value = a2
    a1._changed:Fire(a2)
end

function u5.Get(a1) -- Line: 36
    return a1._value
end

function u5:Destroy() -- Line: 40
    self._changed:Destroy()
end

return u5