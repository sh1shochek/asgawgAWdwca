-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SCAR-20.ScopeIdle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SCAR-20.ScopeIdle
-- Decompile time: 7.21 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.3166666,
    limbs = { "LeftHand", "LeftLowerArm", "LeftUpperArm", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "Head", "UpperTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LowerTorso", "HumanoidRootPart" },
    events = {},
    keyframes = {}
};

for i = 1, Chunks:GetAttribute("Count") do
    local _ = i;

    for _, v in ipairs(require(Chunks[tostring(i)])) do
        table.insert(v1.keyframes, v);
    end;
end;

return v1;