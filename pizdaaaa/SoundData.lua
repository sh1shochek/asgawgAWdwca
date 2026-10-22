-- ReplicatedStorage.Shared.Managers.SoundManager.SoundData
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.SoundData
-- Decompile time: 4.93 ms

-- Decompiled with Potassium's decompiler.

local v1 = {
    Groups = { {
            Name = "Master",
            Parent = ""
        }, {
            Name = "SFX",
            Parent = "Master"
        }, {
            Name = "UI",
            Parent = "Master"
        }, {
            Name = "Music",
            Parent = "Master"
        } }
};
local v2 = {};
v1.Entries = v2;

for _, child in script:GetChildren() do
    local v3 = require(child);

    for i, v in v3.Entries or v3 do
        v2[i] = v;
    end;
end;

return v1;