-- ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.rig
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.rig
-- Decompile time: 3.78 ms

-- Decompiled with Potassium's decompiler.

local function topological_sort(p1: table, p2: table) -- Line: 33
    -- upvalues: topological_sort (copy)
    if not p2.children then
        return;
    end;

    for _, v in p2.children do
        local v3 = {
            name = v.name,
            depends_on = p2.name,
            c0 = v.c0,
            c1 = v.c1:Inverse()
        };
        table.insert(p1, v3);
        topological_sort(p1, v);
    end;
end;

local u4 = setmetatable({}, {
    __mode = "k"
});

local function build_skeleton(p5: table) -- Line: 66
    -- upvalues: topological_sort (copy)
    local v6 = {};
    local v7 = {
        depends_on = "root",
        name = p5.name,
        c0 = p5.c0,
        c1 = p5.c1:Inverse()
    };
    table.insert(v6, v7);
    topological_sort(v6, p5);
    local v8 = {};

    for i, v in v6 do
        v8[v.name] = i;
    end;

    return {
        limbs = table.freeze(v6),
        limb_name_to_index = table.freeze(v8)
    };
end;

return {
    create_rig = function(p9: table) -- Line: 89, Name: create_rig
        -- upvalues: u4 (copy), build_skeleton (copy)
        local v10 = u4[p9];

        if not v10 then
            v10 = build_skeleton(p9);
            u4[p9] = v10;
        end;

        local table_create_ret = table.create(#v10.limbs);

        for i in v10.limbs do
            table_create_ret[i] = {
                priority = -1,
                position = Vector3.new(0, 0, 0),
                quat_vector = Vector3.new(0, 0, 0),
                quat_scalar = 1
            };
        end;

        return {
            limbs = v10.limbs,
            limb_transforms = table_create_ret,
            limb_name_to_index = v10.limb_name_to_index,
            result_coordinate_frames = {}
        };
    end
};