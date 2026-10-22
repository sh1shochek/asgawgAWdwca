-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SSG-08.Reload
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.SSG-08.Reload
-- Decompile time: 3.90 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 2.75,
    limbs = { "LeftHand", "LeftLowerArm", "LeftUpperArm", "Head", "Mag", "Slide1", "Slide", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LowerTorso", "HumanoidRootPart" },
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