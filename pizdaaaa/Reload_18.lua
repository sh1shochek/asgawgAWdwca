-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.M4A4.Reload
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.M4A4.Reload
-- Decompile time: 7.41 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 2.5999999,
    limbs = { "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "Head", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Slide1", "Mag", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LowerTorso", "HumanoidRootPart" },
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