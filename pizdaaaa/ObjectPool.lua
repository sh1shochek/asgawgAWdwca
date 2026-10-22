-- ReplicatedStorage.Shared.Utility.ObjectPool
-- Script path: ReplicatedStorage.Shared.Utility.ObjectPool
-- Decompile time: 5.44 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};

local function Get(p2) -- Line: 8
    return table.remove(p2.Free) or p2.Create();
end;

local function Release(p3, p4) -- Line: 18
    table.insert(p3.Free, p4);
end;

function v1.new(p5: function) -- Line: 24
    -- upvalues: Get (copy), Release (copy)
    return {
        Free = {},
        Create = p5,
        Get = Get,
        Release = Release
    };
end;

return v1;