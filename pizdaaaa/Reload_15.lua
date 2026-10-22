-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.G3SG1.Reload
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.G3SG1.Reload
-- Decompile time: 6.13 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 2.5999999,
    limbs = { "RightFoot", "RightLowerLeg", "RightUpperLeg", "Head", "Slide1", "Mag", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "LeftHand", "LeftLowerArm", "LeftUpperArm", "UpperTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "LowerTorso", "HumanoidRootPart" },
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