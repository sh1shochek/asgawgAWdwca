-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Knives.Balisong.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Knives.Balisong.Idle
-- Decompile time: 5.35 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "LeftHand", "LeftLowerArm", "LeftUpperArm", "Head", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "LowerTorso", "HumanoidRootPart" },
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