-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);

return function(p1: userdata?) -- Line: 7, Name: GetCharacterVelocity
    -- upvalues: RuntimeKinematics (copy)
    local v2;

    if p1 then
        v2 = p1:FindFirstChild("HumanoidRootPart");
    else
        v2 = p1;
    end;

    return RuntimeKinematics.getVelocity(p1, v2);
end;