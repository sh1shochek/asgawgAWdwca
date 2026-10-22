-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SSG-08.ScopeIdle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SSG-08.ScopeIdle
-- Decompile time: 4.07 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.3166666,
    limbs = { "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Head", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
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