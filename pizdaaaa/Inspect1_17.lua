-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.P2000.Inspect1
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.P2000.Inspect1
-- Decompile time: 5.13 ms

-- Decompiled with Potassium's decompiler.

local Children = script:GetChildren();
table.sort(Children, function(p1, p2) -- Line: 3
    return p1.Name < p2.Name;
end);
local v3 = {};

for _, v in ipairs(Children) do
    local v4 = require(v);
    table.move(v4, 1, #v4, #v3 + 1, v3);
end;

return {
    length = 7.55,
    limbs = { "RootPart", "Right Arm", "Handle", "Slide1", "Slide2", "Mag", "Left Arm" },
    events = {},
    keyframes = v3
};