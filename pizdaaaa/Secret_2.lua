-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Misc.Defuse.Secret
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Misc.Defuse.Secret
-- Decompile time: 3.49 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 6.25,
    limbs = { "Head", "HumanoidRootPart", "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "UpperTorso" },
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