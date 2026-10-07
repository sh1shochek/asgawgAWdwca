-- StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.CharacterUtil
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.CharacterUtil
-- Decompile time: 1.35 ms

local Players = game:GetService("Players")
local ConnectionUtil = require(script.Parent:WaitForChild("ConnectionUtil"))
local u14 = {}
u14._connectionUtil = ConnectionUtil.new()
u14._boundEvents = {}

function u14.getLocalPlayer() -- Line: 53 -- upvalues: Players (val)
    return Players.LocalPlayer
end

function u14.onLocalPlayer(a1) -- Line: 57 -- upvalues: u14 (val), Players (val)
    local v1 = u14.getLocalPlayer()
    if v1 then
        a1(v1)
    end
    u14._connectionUtil:trackConnection("LOCAL_PLAYER", ((Players:GetPropertyChangedSignal("LocalPlayer")):Connect(function() -- Line: 66 -- upvalues: u14 (upval)
        local v1 = u14.getLocalPlayer()
        assert(v1)
        u14._getOrCreateBoundEvent("LOCAL_PLAYER"):Fire(v1)
    end)))
    return u14._getOrCreateBoundEvent("LOCAL_PLAYER").Event:Connect(a1)
end

function u14.getCharacter() -- Line: 77 -- upvalues: u14 (val)
    local v1 = u14.getLocalPlayer()
    if not v1 then
        return nil
    end
    return v1.Character
end

function u14.onCharacter(a1) -- Line: 85 -- upvalues: u14 (val)
    u14._connectionUtil:trackConnection("ON_LOCAL_PLAYER", (u14.onLocalPlayer(function(a1_2) -- Line: 89 -- upvalues: u14 (upval), a1 (val)
        local v1 = u14.getCharacter()
        if v1 then
            a1(v1)
        end
        u14._connectionUtil:trackConnection("CHARACTER_ADDED", (a1_2.CharacterAdded:Connect(function(a1) -- Line: 98 -- upvalues: u14 (upval)
            assert(a1)
            u14._getOrCreateBoundEvent("CHARACTER_ADDED"):Fire(a1)
        end)))
    end)))
    return u14._getOrCreateBoundEvent("CHARACTER_ADDED").Event:Connect(a1)
end

function u14.getChild(a1, a2) -- Line: 110 -- upvalues: u14 (val) -- types: a1: string, a2: string
    local v1 = u14.getCharacter()
    if not v1 then
        return nil
    end
    local v2 = v1:FindFirstChild(a1)
    if v2 and v2:IsA(a2) then
        return v2
    end
    return nil
end

function u14.onChild(a1, a2, a3) -- Line: 122 -- upvalues: u14 (val) -- types: a1: string, a2: string
    u14._connectionUtil:trackConnection("ON_CHARACTER", (u14.onCharacter(function(a1_2) -- Line: 126 -- upvalues: u14 (upval), a1 (val), a2 (val), a3 (val)
        local v1 = u14.getChild(a1, a2)
        if v1 then
            a3(v1)
        end
        u14._connectionUtil:trackConnection("CHARACTER_CHILD_ADDED", (a1_2.ChildAdded:Connect(function(a1_2) -- Line: 135 -- upvalues: a1 (upval), a2 (upval), u14 (upval)
            if a1_2.Name == a1 and a1_2:IsA(a2) then
                u14._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. a1 .. a2):Fire(a1_2)
            end
        end)))
    end)))
    return u14._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. a1 .. a2).Event:Connect(a3)
end

function u14._getOrCreateBoundEvent(a1) -- Line: 149 -- upvalues: u14 (val) -- types: a1: string
    if not u14._boundEvents[a1] then
        u14._boundEvents[a1] = (Instance.new("BindableEvent"))
    end
    return u14._boundEvents[a1]
end

return u14