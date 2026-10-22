-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MAC-10.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.SMG.MAC-10.Idle
-- Decompile time: 5.28 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "Head", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Mag", "Slide1", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "HumanoidRootPart" },
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