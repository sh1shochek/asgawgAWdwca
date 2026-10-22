-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.Galil ACE.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.Galil ACE.Idle
-- Decompile time: 6.17 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "LeftHand", "LeftLowerArm", "LeftUpperArm", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "Head", "UpperTorso", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "LowerTorso", "HumanoidRootPart" },
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