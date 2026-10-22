-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Heavy.MAG-7.Inspect1
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Heavy.MAG-7.Inspect1
-- Decompile time: 4.27 ms

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
    length = 7.783333,
    limbs = { "RootPart", "Left Arm", "Right Arm", "Handle", "Slide", "Bullet", "Mag" },
    events = {},
    keyframes = v3
};