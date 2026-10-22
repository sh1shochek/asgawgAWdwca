-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.Dual Berettas.Reload
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.Dual Berettas.Reload
-- Decompile time: 4.58 ms

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
    length = 3.783333,
    limbs = { "Left Arm", "Handle1", "Slide11", "Mag1", "Slide21", "Right Arm", "Handle", "Slide1", "Slide2", "Mag" },
    events = { {
            name = "magout",
            time = 0.3166667
        }, {
            name = "magin",
            time = 1.633333
        }, {
            name = "magin2",
            time = 2.533333
        }, {
            name = "slidestart",
            time = 3.216667
        }, {
            name = "slidefinish",
            time = 3.333333
        } },
    keyframes = v3
};