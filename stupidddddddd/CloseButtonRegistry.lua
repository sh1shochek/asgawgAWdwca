-- ReplicatedStorage.Shared.CloseButtonRegistry
-- Script path: ReplicatedStorage.Shared.CloseButtonRegistry
-- Decompile time: 2.04 ms

local u0 = {}
local UserInputService = game:GetService("UserInputService")
local u6 = {}
local u7 = {}
local u8 = 0

local function isOnScreen(a1) -- Line: 35 -- types: a1: userdata
    local Parent = a1
    while Parent do
        if not Parent:IsA("GuiObject") then
            if Parent:IsA("LayerCollector") then
                return Parent.Enabled
            end
        elseif not Parent.Visible then
            return false
        end
        Parent = Parent.Parent
    end
    return false
end

function u0.IsDoublePressed() -- Line: 53 -- upvalues: u8 (ref)
    return tick() - u8 < 0.1
end

function u0.MarkUsed() -- Line: 61 -- upvalues: u8 (ref)
    u8 = tick()
end

function u0.Add(a1, a2, a3) -- Line: 67 -- upvalues: u6 (val) -- types: a1: userdata, a2: userdata?, a3: function
    table.insert(u6, {closeButton = a2, onClose = a3, frame = a1})
    if not a2 then
        return
    end
    a2.MouseButton1Click:Connect(function() -- Line: 70 -- upvalues: a3 (val), a1 (val), a2 (val)
        a3(a1, a2)
    end)
    a2.Activated:Connect(function(a1_2) -- Line: 73 -- upvalues: a3 (val), a1 (val), a2 (val)
        if a1_2 and a1_2.UserInputType == Enum.UserInputType.Gamepad1 then
            a3(a1, a2)
        end
    end)
end

function u0.Remove(a1) -- Line: 83 -- upvalues: u6 (val) -- types: a1: userdata
    for i = #u6, 1, -1 do
        if u6[i].frame == a1 then
            table.remove(u6, i)
        end
    end
end

function u0.BringToFront(a1) -- Line: 94 -- upvalues: u6 (val) -- types: a1: userdata
    for i = #u6, 1, -1 do
        if u6[i].frame == a1 then
            table.insert(u6, (table.remove(u6, i)))
            return
        end
    end
end

function u0.AddHandler(a1, a2) -- Line: 107 -- upvalues: u7 (val) -- types: a1: function, a2: function
    table.insert(u7, {isActive = a1, onClose = a2})
end

function u0.CloseFrame() -- Line: 113 -- upvalues: u0 (val), u7 (val), u8 (ref), u6 (val), isOnScreen (val)
    local v1
    if u0.IsDoublePressed() then
        return true
    end
    for i = #u7, 1, -1 do
        v1 = u7[i]
        if v1.isActive() then
            v1.onClose()
            u8 = tick()
            return true
        end
    end
    for j = #u6, 1, -1 do
        v1 = u6[j]
        if isOnScreen(v1.frame) then
            v1.onClose(v1.frame, v1.closeButton)
            u8 = tick()
            return true
        end
    end
    return false
end

UserInputService.InputBegan:Connect(function(a1) -- Line: 144 -- upvalues: u0 (val) -- types: a1: userdata
    if a1.UserInputType == Enum.UserInputType.Gamepad1 and a1.KeyCode == Enum.KeyCode.ButtonB then
        u0.CloseFrame()
    end
end)
return u0