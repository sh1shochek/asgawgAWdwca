-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Misc.Defuse.Defuse
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Misc.Defuse.Defuse
-- Decompile time: 5.12 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 10,
    limbs = { "Handle", "LeftHand", "LeftLowerArm", "LeftUpperArm", "UpperTorso" },
    events = { {
            name = "defusestart",
            time = 0.01666667
        }, {
            name = "defuse",
            time = 0.5
        }, {
            name = "defusefinish",
            time = 8
        } },
    keyframes = {}
};

for i = 1, Chunks:GetAttribute("Count") do
    local _ = i;

    for _, v in ipairs(require(Chunks[tostring(i)])) do
        table.insert(v1.keyframes, v);
    end;
end;

return v1;