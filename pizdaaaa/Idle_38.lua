-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MP9.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MP9.Idle
-- Decompile time: 4.26 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "Head", "Mag", "Slide1", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "LeftHand", "LeftLowerArm", "LeftUpperArm", "UpperTorso", "HumanoidRootPart" },
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