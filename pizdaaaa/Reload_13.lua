-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.AWP.Reload
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.AWP.Reload
-- Decompile time: 4.30 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 2.75,
    limbs = { "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "Head", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Slide1", "Mag", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
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