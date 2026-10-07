-- ReplicatedStorage.Shared.Zone.ZonePlusReference
-- Script path: ReplicatedStorage.Shared.Zone.ZonePlusReference
-- Decompile time: 0.41 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
    addToReplicatedStorage = function() -- Line: 9 -- upvalues: ReplicatedStorage (val)
        if ReplicatedStorage:FindFirstChild(script.Name) then
            return false
        end
        local ObjectValue = Instance.new("ObjectValue")
        ObjectValue.Name = script.Name
        ObjectValue.Value = script.Parent
        ObjectValue.Parent = ReplicatedStorage
        local BoolValue = Instance.new("BoolValue")
        BoolValue.Name = if not game:GetService("RunService"):IsClient() then "Server" else "Client"
        BoolValue.Value = true
        BoolValue.Parent = ObjectValue
        return ObjectValue
    end,
    getObject = function() -- Line: 25 -- upvalues: ReplicatedStorage (val)
        local v1 = ReplicatedStorage:FindFirstChild(script.Name)
        if v1 then
            return v1
        end
        return false
    end,
}