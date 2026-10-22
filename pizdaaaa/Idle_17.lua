-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Pistols.Dual Berettas.Idle
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Pistols.Dual Berettas.Idle
-- Decompile time: 3.77 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.33333325,
    limbs = { "Mag1", "Slide11", "Slide21", "Handle1", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Head", "Slide1", "Mag", "Slide2", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "HumanoidRootPart" },
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