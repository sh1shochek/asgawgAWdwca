-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Rifles.SCAR-20.Inspect1
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Rifles.SCAR-20.Inspect1
-- Decompile time: 9.59 ms

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
    length = 6.783333,
    limbs = { "RootPart", "Right Arm", "Left Arm", "Handle", "Mag", "Slide1" },
    events = {},
    keyframes = v3
};