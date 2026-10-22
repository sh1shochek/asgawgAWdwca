-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Misc.Bomb.Plant
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Misc.Bomb.Plant
-- Decompile time: 4.86 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 3,
    limbs = { "Handle", "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "Slide1", "Slide2", "UpperTorso" },
    events = { {
            name = "open",
            time = 0.2
        }, {
            name = "press1",
            time = 0.6333333
        }, {
            name = "press2",
            time = 0.85
        }, {
            name = "press3",
            time = 1.083333
        }, {
            name = "press4",
            time = 1.3
        }, {
            name = "press5",
            time = 1.533333
        }, {
            name = "press6",
            time = 1.7
        }, {
            name = "press7",
            time = 1.883333
        }, {
            name = "toggle",
            time = 2.35
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