-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MP7.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MP7.Idle
-- Decompile time: 4.30 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "Slide1", "Mag", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Head", "UpperTorso", "HumanoidRootPart" },
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