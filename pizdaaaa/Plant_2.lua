-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Misc.Bomb.Plant
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Misc.Bomb.Plant
-- Decompile time: 5.59 ms

-- Decompiled with Potassium's decompiler.

local Chunks = script:WaitForChild("Chunks");
local v1 = {
    length = 4.733333,
    limbs = { "Handle", "Left Arm", "Right Arm", "Slide1", "Slide2" },
    events = { {
            name = "open",
            time = 0.5166667
        }, {
            name = "press1",
            time = 0.95
        }, {
            name = "press2",
            time = 1.166667
        }, {
            name = "press3",
            time = 1.35
        }, {
            name = "press4",
            time = 1.616667
        }, {
            name = "press5",
            time = 1.866667
        }, {
            name = "press6",
            time = 2.05
        }, {
            name = "press7",
            time = 2.3
        }, {
            name = "press8",
            time = 2.583333
        }, {
            name = "press9",
            time = 2.816667
        }, {
            name = "press10",
            time = 3.033333
        }, {
            name = "press11",
            time = 3.233333
        }, {
            name = "toggle",
            time = 3.7
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