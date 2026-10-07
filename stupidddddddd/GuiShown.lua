-- ReplicatedStorage.Components.Common.InterfaceAnimations.GuiShown
-- Script path: ReplicatedStorage.Components.Common.InterfaceAnimations.GuiShown
-- Decompile time: 0.67 ms

local u0 = {}

function u0.IsShown(a1) -- Line: 7 -- types: a1: userdata
    local Parent = a1
    while Parent do
        if not Parent:IsA("GuiObject") then
            break
        end
        if not Parent.Visible then
            return false
        end
        Parent = Parent.Parent
    end
    return true
end

function u0.Observe(a1, a2) -- Line: 19 -- upvalues: u0 (val) -- types: a1: userdata, a2: function
    local u5 = u0.IsShown(a1)
    local u6 = {}
    local Parent = a1
    while Parent do
        if not Parent:IsA("GuiObject") then
            break
        end
        table.insert(u6, ((Parent:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 26 -- upvalues: u0 (upval), a1 (val), u5 (ref), a2 (val)
            local v1 = u0.IsShown(a1)
            if v1 ~= u5 then
                a2(v1)
            end
        end)))
        Parent = Parent.Parent
    end
    a2(u5)
    return function() -- Line: 37 -- upvalues: u6 (val)
        for i, j in u6 do
            j:Disconnect()
        end
        table.clear(u6)
    end
end

return table.freeze(u0)