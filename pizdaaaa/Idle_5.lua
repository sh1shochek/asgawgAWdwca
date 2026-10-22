-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Heavy.Sawed-Off.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Heavy.Sawed-Off.Idle
-- Decompile time: 7.50 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "Head", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Shell", "Slide", "Slide1", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "HumanoidRootPart" },
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