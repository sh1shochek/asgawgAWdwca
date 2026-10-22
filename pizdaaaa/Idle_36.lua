-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MP5-SD.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MP5-SD.Idle
-- Decompile time: 4.58 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "Head", "LeftHand", "LeftLowerArm", "LeftUpperArm", "UpperTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LowerTorso", "HumanoidRootPart" },
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