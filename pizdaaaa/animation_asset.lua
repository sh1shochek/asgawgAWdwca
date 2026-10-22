-- ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.roblox.animation_asset
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.roblox.animation_asset
-- Decompile time: 21.04 ms

-- Decompiled with Potassium's decompiler.

local u1 = require("../easings");
local u2 = require("./easing_enum_map");
require("../rig");
local u3 = {};
local u4 = {};

local function easing_index(p5: function) -- Line: 82
    -- upvalues: u4 (copy), u3 (copy)
    local v6 = u4[p5];

    if not v6 then
        v6 = #u3 + 1;
        u3[v6] = p5;
        u4[p5] = v6;
    end;

    return v6;
end;

local linear = u1.linear;
local u7 = u4[linear];

if not u7 then
    u7 = #u3 + 1;
    u3[u7] = linear;
    u4[linear] = u7;
end;

for _, v in u2 do
    for _, v2 in v do
        if not u4[v2] then
            local v8 = #u3 + 1;
            u3[v8] = v2;
            u4[v2] = v8;
        end;
    end;
end;

local v9 = `animation_asset: {#u3} easing functions, a u8 pose_easing slot holds 255`;
assert(#u3 <= 255, v9);

local function recursive_tree_from_pose(p10: table, p11: userdata) -- Line: 108
    -- upvalues: recursive_tree_from_pose (copy), u2 (copy)
    for _, v in p11:GetSubPoses() do
        recursive_tree_from_pose(p10, v);
    end;

    if p11.Weight == 0 then
        return;
    end;

    local CFrame = p11.CFrame;
    local v12, v13 = CFrame:ToAxisAngle();
    local v14 = v13 * 0.5;
    local Position = CFrame.Position;
    local v15 = math.sin(v14) * v12;
    local math_cos_ret = math.cos(v14);
    p10[p11.Name] = {
        position = Position,
        quat_vector = v15,
        quat_scalar = math_cos_ret,
        easing_function = u2[p11.EasingStyle][p11.EasingDirection]
    };
end;

local v16 = {
    easing_functions = u3
};

local function free_source(p17) -- Line: 151
    if p17.keyframes then
        table.clear(p17.keyframes);
        p17.keyframes = {};
    end;

    p17.parsed = true;
end;

local function load_keyframe_events(p18: table, p19: userdata) -- Line: 165
    if p19.Name ~= "Keyframe" then
        table.insert(p18, {
            name = p19.Name,
            time = p19.Time
        });
    end;

    for _, v in p19:GetMarkers() do
        table.insert(p18, {
            name = v.Name,
            time = p19.Time,
            value = v.Value
        });
    end;
end;

function v16.load_keyframe_sequence_metadata(p20) -- Line: 182
    -- upvalues: load_keyframe_events (copy)
    local v21;

    if typeof(p20) == "Instance" and p20:IsA("ModuleScript") then
        p20 = require(p20);

        if typeof(p20) == "table" then
            v21 = true;
        else
            v21 = false;
        end;
    else
        v21 = false;
    end;

    if typeof(p20) == "table" then
        local v22 = {
            length = p20.length or 0,
            events = p20.events or {}
        };

        if v21 then
            if p20.keyframes then
                table.clear(p20.keyframes);
                p20.keyframes = {};
            end;

            p20.parsed = true;
        end;

        return v22;
    end;

    local Keyframes = p20:GetKeyframes();
    table.sort(Keyframes, function(p23: userdata, p24: userdata) -- Line: 214
        return p23.Time < p24.Time;
    end);
    local v25 = {};

    for _, v in Keyframes do
        load_keyframe_events(v25, v);
    end;

    return {
        length = Keyframes[#Keyframes].Time,
        events = v25
    };
end;

function v16.load_keyframe_sequence(p26, p27) -- Line: 229
    -- upvalues: u2 (copy), u1 (copy), load_keyframe_events (copy), recursive_tree_from_pose (copy), u4 (copy), u3 (copy), u7 (copy)
    local v28;

    if typeof(p26) == "Instance" and p26:IsA("ModuleScript") then
        p26 = require(p26);
        v28 = typeof(p26) == "table";
        local v29;

        if v28 then
            v29 = p26.parsed;
        else
            v29 = v28;
        end;

        assert(not v29, "load_keyframe_sequence: source keyframes were already freed -- this clip should have come back from AnimationManager\'s RigAssets cache");
    else
        v28 = false;
    end;

    local v30 = {};
    local v31 = {};

    if typeof(p26) == "table" then
        v31 = p26.events or {};
        local limbs = p26.limbs;

        for _, v in p26.keyframes do
            local v32 = v;
            local v33 = {};

            for i, v2 in v.poses do
                local v34;

                if limbs then
                    v34 = limbs[i] or i;
                else
                    v34 = i;
                end;

                local v35, v36, v37, v38, v39;

                if v2.pos or (v2.position or v2.qv) then
                    v35 = v2.pos or v2.position;
                    v36 = v2.qv or v2.quat_vector;
                    v37 = v2.qs or v2.quat_scalar;
                    v38 = typeof(v2.es) == "string" and Enum.PoseEasingStyle[v2.es] or (v2.es or Enum.PoseEasingStyle.Linear);
                    v39 = typeof(v2.ed) == "string" and Enum.PoseEasingDirection[v2.ed] or (v2.ed or Enum.PoseEasingDirection.In);
                else
                    v35 = vector.create(v2[1], v2[2], v2[3]);
                    v36 = vector.create(v2[4], v2[5], v2[6]);
                    v37 = v2[7];
                    v38 = v2[8] and (typeof(v2[8]) == "string" and Enum.PoseEasingStyle[v2[8]] or v2[8]) or Enum.PoseEasingStyle.Linear;
                    v39 = v2[9] and (typeof(v2[9]) == "string" and Enum.PoseEasingDirection[v2[9]] or v2[9]) or Enum.PoseEasingDirection.In;
                end;

                local v40 = u2[v38] or u2[Enum.PoseEasingStyle.Linear];
                v33[v34] = {
                    position = v35,
                    quat_vector = v36,
                    quat_scalar = v37,
                    easing_function = v40 and v40[v39] or u1.linear
                };
            end;

            table.insert(v30, {
                name = v32.name or "Keyframe",
                time = v32.time,
                poses = v33
            });
        end;
    else
        for _, v in p26:GetKeyframes() do
            load_keyframe_events(v31, v);
            local v41 = v;
            local v42 = {};

            for _, v2 in v:GetPoses() do
                recursive_tree_from_pose(v42, v2);
            end;

            table.insert(v30, {
                name = v41.Name,
                time = v41.Time,
                poses = v42
            });
        end;
    end;

    table.sort(v30, function(p43: table, p44: table) -- Line: 305
        return p43.time < p44.time;
    end);
    local limb_name_to_index = p27.limb_name_to_index;
    local v45 = #v30;
    local v46 = `load_keyframe_sequence: {v45} keyframes, a u16 left_kf/right_kf slot holds 65535`;
    assert(v45 <= 65535, v46);
    local v47 = {};
    local v48 = {};

    for _, v in v30 do
        for i in v.poses do
            local v49 = limb_name_to_index[i];

            if v49 and v47[v49] == nil then
                v47[v49] = 0;
                table.insert(v48, v49);
            end;
        end;
    end;

    table.sort(v48);

    for i, v in v48 do
        v47[v] = i;
    end;

    local v50 = {};

    for _, v in limb_name_to_index do
        if v47[v] == nil then
            table.insert(v50, v);
        end;
    end;

    local v51 = #v48;
    local v52 = v45 * v51;
    local buffer_create_ret = buffer.create(v52 * 28);
    local buffer_create_ret2 = buffer.create(v52);
    local buffer_create_ret3 = buffer.create(v52 * 2);
    local buffer_create_ret4 = buffer.create(v52 * 2);
    local buffer_create_ret5 = buffer.create(v52);

    for i, v in v30 do
        local v53 = (i - 1) * v51;

        for i2, v2 in v.poses do
            local v54 = limb_name_to_index[i2];

            if v54 then
                v54 = v47[v54];
            end;

            if v54 then
                local v55 = v53 + v54;
                local v56 = (v55 - 1) * 28;
                local position = v2.position;
                local quat_vector = v2.quat_vector;
                buffer.writef32(buffer_create_ret, v56, position.x);
                buffer.writef32(buffer_create_ret, v56 + 4, position.y);
                buffer.writef32(buffer_create_ret, v56 + 8, position.z);
                buffer.writef32(buffer_create_ret, v56 + 12, quat_vector.x);
                buffer.writef32(buffer_create_ret, v56 + 16, quat_vector.y);
                buffer.writef32(buffer_create_ret, v56 + 20, quat_vector.z);
                buffer.writef32(buffer_create_ret, v56 + 24, v2.quat_scalar);
                local easing_function = v2.easing_function;
                local v57 = u4[easing_function];

                if not v57 then
                    v57 = #u3 + 1;
                    u3[v57] = easing_function;
                    u4[easing_function] = v57;
                end;

                buffer.writeu8(buffer_create_ret2, v55 - 1, v57);
                buffer.writeu8(buffer_create_ret5, v55 - 1, 1);
            end;
        end;
    end;

    for i = 1, v51 do
        local v58;

        if buffer.readu8(buffer_create_ret5, i - 1) == 0 then
            buffer.writef32(buffer_create_ret, (i - 1) * 28 + 24, 1);
            buffer.writeu8(buffer_create_ret2, i - 1, u7);
            buffer.writeu8(buffer_create_ret5, i - 1, 1);
            v58 = i;
        else
            v58 = i;
        end;
    end;

    for i = 1, v51 do
        local v59 = i;
        local v60 = 0;

        for i2 = 1, v45 do
            local v61 = (i2 - 1) * v51 + v59;

            if buffer.readu8(buffer_create_ret5, v61 - 1) ~= 0 then
                v60 = i2;
            end;

            buffer.writeu16(buffer_create_ret3, (v61 - 1) * 2, v60);
            local _ = i2;
        end;

        local v62 = 0;

        for i2 = v45, 1, -1 do
            local v63 = (i2 - 1) * v51 + v59;

            if buffer.readu8(buffer_create_ret5, v63 - 1) ~= 0 then
                v62 = i2;
            end;

            buffer.writeu16(buffer_create_ret4, (v63 - 1) * 2, v62);
            local _ = i2;
        end;
    end;

    local buffer_create_ret6 = buffer.create(v45 * 4);

    for i, v in v30 do
        buffer.writef32(buffer_create_ret6, (i - 1) * 4, v.time);
    end;

    local v64 = {
        length = p26 and typeof(p26) == "table" and p26.length or (v30[v45] and (v30[v45].time or 0) or 0),
        events = v31,
        keyframe_count = v45,
        keyframe_times = buffer_create_ret6,
        limb_indices = v48,
        limb_count = v51,
        pose_data = buffer_create_ret,
        pose_easing = buffer_create_ret2,
        left_kf = buffer_create_ret3,
        right_kf = buffer_create_ret4,
        identity_limbs = v50
    };

    if v28 then
        if p26.keyframes then
            table.clear(p26.keyframes);
            p26.keyframes = {};
        end;

        p26.parsed = true;
    end;

    return v64;
end;

return v16;