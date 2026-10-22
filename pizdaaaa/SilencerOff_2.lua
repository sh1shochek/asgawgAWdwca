-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.M4A1-S.SilencerOff
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Rifles.M4A1-S.SilencerOff
-- Decompile time: 5.71 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.66666675,
    limbs = { "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "Head", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Slide1", "Silencer", "Mag", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
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