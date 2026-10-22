-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.PPSH-41.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.PPSH-41.Idle
-- Decompile time: 4.86 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "RightFoot", "RightLowerLeg", "RightUpperLeg", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Head", "UpperTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "LowerTorso", "HumanoidRootPart" },
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