-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return {
    addToReplicatedStorage = function() -- Line: 9, Name: addToReplicatedStorage
        -- upvalues: ReplicatedStorage (copy)
        if ReplicatedStorage:FindFirstChild(script.Name) then
            return false;
        end;

        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = script.Name;
        ObjectValue.Value = script.Parent;
        ObjectValue.Parent = ReplicatedStorage;
        local BoolValue = Instance.new("BoolValue");
        BoolValue.Name = game:GetService("RunService"):IsClient() and "Client" or "Server";
        BoolValue.Value = true;
        BoolValue.Parent = ObjectValue;

        return ObjectValue;
    end,

    getObject = function() -- Line: 25, Name: getObject
        -- upvalues: ReplicatedStorage (copy)
        return ReplicatedStorage:FindFirstChild(script.Name) or false;
    end
};