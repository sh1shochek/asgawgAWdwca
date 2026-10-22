-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Pistols.P2000.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Pistols.P2000.Idle
-- Decompile time: 6.25 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "LeftHand", "LeftLowerArm", "LeftUpperArm", "Head", "Slide1", "Slide2", "Mag", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "HumanoidRootPart" },
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