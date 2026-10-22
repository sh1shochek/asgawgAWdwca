-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SSG-08.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SSG-08.Idle
-- Decompile time: 5.14 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.3166666,
    limbs = { "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "Head", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
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