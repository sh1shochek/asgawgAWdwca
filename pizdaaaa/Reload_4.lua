-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Pistols.Dual Berettas.Reload
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Pistols.Dual Berettas.Reload
-- Decompile time: 3.64 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3.7833333,
    limbs = { "Mag1", "Slide11", "Slide21", "Handle1", "LeftHand", "LeftLowerArm", "LeftUpperArm", "Slide2", "Slide1", "Mag", "Handle", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "HumanoidRootPart" },
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