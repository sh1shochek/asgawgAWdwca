-- ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.animation_solver
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.animation_solver
-- Decompile time: 14.80 ms

-- Decompiled with Potassium's decompiler.

local v1 = require("./roblox/animation_asset");
require("./rig");
local easing_functions = v1.easing_functions;

local function quat_dot(p2: vector, p3: number, p4: vector, p5: number) -- Line: 23
    return vector.dot(p2, p4) + p3 * p5;
end;

local function quat_nlerp(p6: vector, p7: number, p8: vector, p9: number, p10: number) -- Line: 27
    if vector.dot(p6, p8) + p7 * p9 < 0 then
        p8 = -p8;
        p9 = -p9;
    end;

    local vector_lerp_ret = vector.lerp(p6, p8, p10);
    local math_lerp_ret = math.lerp(p7, p9, p10);
    local v11 = vector.dot(vector_lerp_ret, vector_lerp_ret) + math_lerp_ret * math_lerp_ret;
    local math_sqrt_ret = math.sqrt(v11);

    return vector_lerp_ret / math_sqrt_ret, math_lerp_ret / math_sqrt_ret;
end;

return {
    solve_fade_time_influence = function(p12: number, p13: number, p14: number, p15: number) -- Line: 47, Name: solve_fade_time_influence
        if p14 > 0 and p12 <= p14 then
            return math.min(1, 1 - (p14 - p12) / p14);
        end;

        return (p15 <= 0 or p13 - p15 > p12) and 1 or math.min(1, 1 - (p12 - (p13 - p15)) / p15);
    end,

    solver = function(p16: any, p17: table, p18, p19: boolean?, p20: number?) -- Line: 68, Name: animation_solver
        -- upvalues: easing_functions (copy)
        local limb_transforms = p16.limb_transforms;
        local v21 = p20 or 1;

        for _, v in limb_transforms do
            v.priority = -1;
            v.max_priority = -1;
            v.weight_sum = 0;
        end;

        for i, v in p17 do
            local priority = v.priority;
            local weight = v.weight;

            for _, v2 in i.limb_indices do
                local v22 = limb_transforms[v2];

                if v22.max_priority < priority then
                    v22.max_priority = priority;
                    v22.weight_sum = weight;
                elseif priority == v22.max_priority then
                    v22.weight_sum = v22.weight_sum + weight;
                end;
            end;
        end;

        for i, v in p17 do
            local priority = v.priority;
            local v23 = i.length * v.alpha;
            local length = i.length;
            local start_fade_time = v.start_fade_time;
            local stop_fade_time = v.stop_fade_time;
            local v24;

            if start_fade_time > 0 and v23 <= start_fade_time then
                v24 = math.min(1, 1 - (start_fade_time - v23) / start_fade_time);
            else
                v24 = (stop_fade_time <= 0 or length - stop_fade_time > v23) and 1 or math.min(1, 1 - (v23 - (length - stop_fade_time)) / stop_fade_time);
            end;

            local keyframe_times = i.keyframe_times;
            local keyframe_count = i.keyframe_count;
            local math_clamp_ret = math.clamp(v.keyframe_index or 1, 1, keyframe_count);
            local v25 = i;
            local v26 = v;

            while math_clamp_ret < keyframe_count and buffer.readf32(keyframe_times, math_clamp_ret * 4) < v23 do
                math_clamp_ret = math_clamp_ret + 1;
            end;

            while math_clamp_ret > 1 and v23 <= buffer.readf32(keyframe_times, (math_clamp_ret - 1) * 4) do
                math_clamp_ret = math_clamp_ret - 1;
            end;

            v26.keyframe_index = math_clamp_ret;
            local limb_count = v25.limb_count;
            local pose_data = v25.pose_data;
            local pose_easing = v25.pose_easing;
            local left_kf = v25.left_kf;
            local right_kf = v25.right_kf;
            local v27 = (math_clamp_ret - 1) * limb_count;
            local v28;

            if math_clamp_ret < keyframe_count then
                v28 = math_clamp_ret * limb_count;
            else
                v28 = nil;
            end;

            for i2, v2 in v25.limb_indices do
                local v29 = limb_transforms[v2];

                if priority >= v29.max_priority then
                    local v30 = v26.weight / v29.weight_sum * v24;
                    local buffer_readu16_ret = buffer.readu16(left_kf, (v27 + i2 - 1) * 2);
                    local v31 = not v28 and 0 or buffer.readu16(right_kf, (v28 + i2 - 1) * 2);
                    local v32 = ((buffer_readu16_ret - 1) * limb_count + i2 - 1) * 28;
                    local buffer_readf32_ret = buffer.readf32(pose_data, v32);
                    local buffer_readf32_ret2 = buffer.readf32(pose_data, v32 + 4);
                    local buffer_readf32_ret3 = buffer.readf32(pose_data, v32 + 8);
                    local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
                    local buffer_readf32_ret4 = buffer.readf32(pose_data, v32 + 12);
                    local buffer_readf32_ret5 = buffer.readf32(pose_data, v32 + 16);
                    local buffer_readf32_ret6 = buffer.readf32(pose_data, v32 + 20);
                    local vector_create_ret2 = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
                    local buffer_readf32_ret7 = buffer.readf32(pose_data, v32 + 24);

                    if v31 == 0 then
                        v29.position = vector.lerp(v29.position, vector_create_ret, v30);
                        local quat_vector = v29.quat_vector;
                        local quat_scalar = v29.quat_scalar;

                        if vector.dot(quat_vector, vector_create_ret2) + quat_scalar * buffer_readf32_ret7 < 0 then
                            vector_create_ret2 = -vector_create_ret2;
                            buffer_readf32_ret7 = -buffer_readf32_ret7;
                        end;

                        local vector_lerp_ret = vector.lerp(quat_vector, vector_create_ret2, v30);
                        local math_lerp_ret = math.lerp(quat_scalar, buffer_readf32_ret7, v30);
                        local v33 = vector.dot(vector_lerp_ret, vector_lerp_ret) + math_lerp_ret * math_lerp_ret;
                        local math_sqrt_ret = math.sqrt(v33);
                        v29.quat_vector = vector_lerp_ret / math_sqrt_ret;
                        v29.quat_scalar = math_lerp_ret / math_sqrt_ret;
                    else
                        local v34 = ((v31 - 1) * limb_count + i2 - 1) * 28;
                        local buffer_readf32_ret8 = buffer.readf32(pose_data, v34);
                        local buffer_readf32_ret9 = buffer.readf32(pose_data, v34 + 4);
                        local buffer_readf32_ret10 = buffer.readf32(pose_data, v34 + 8);
                        local vector_create_ret3 = vector.create(buffer_readf32_ret8, buffer_readf32_ret9, buffer_readf32_ret10);
                        local buffer_readf32_ret11 = buffer.readf32(pose_data, v34 + 12);
                        local buffer_readf32_ret12 = buffer.readf32(pose_data, v34 + 16);
                        local buffer_readf32_ret13 = buffer.readf32(pose_data, v34 + 20);
                        local vector_create_ret4 = vector.create(buffer_readf32_ret11, buffer_readf32_ret12, buffer_readf32_ret13);
                        local buffer_readf32_ret14 = buffer.readf32(pose_data, v34 + 24);
                        local buffer_readf32_ret15 = buffer.readf32(keyframe_times, (buffer_readu16_ret - 1) * 4);
                        local buffer_readf32_ret16 = buffer.readf32(keyframe_times, (v31 - 1) * 4);
                        local v35 = easing_functions[buffer.readu8(pose_easing, (buffer_readu16_ret - 1) * limb_count + i2 - 1)]((v23 - buffer_readf32_ret15) / (buffer_readf32_ret16 - buffer_readf32_ret15));
                        local vector_lerp_ret = vector.lerp(vector_create_ret, vector_create_ret3, v35);

                        if vector.dot(vector_create_ret2, vector_create_ret4) + buffer_readf32_ret7 * buffer_readf32_ret14 < 0 then
                            vector_create_ret4 = -vector_create_ret4;
                            buffer_readf32_ret14 = -buffer_readf32_ret14;
                        end;

                        local vector_lerp_ret2 = vector.lerp(vector_create_ret2, vector_create_ret4, v35);
                        local math_lerp_ret = math.lerp(buffer_readf32_ret7, buffer_readf32_ret14, v35);
                        local v36 = vector.dot(vector_lerp_ret2, vector_lerp_ret2) + math_lerp_ret * math_lerp_ret;
                        local math_sqrt_ret = math.sqrt(v36);
                        local v37 = vector_lerp_ret2 / math_sqrt_ret;
                        local v38 = math_lerp_ret / math_sqrt_ret;

                        if v30 == 1 then
                            v29.position = vector_lerp_ret;
                            v29.quat_vector = v37;
                            v29.quat_scalar = v38;
                        else
                            v29.position = vector.lerp(v29.position, vector_lerp_ret, v30);
                            local quat_vector = v29.quat_vector;
                            local quat_scalar = v29.quat_scalar;

                            if vector.dot(quat_vector, v37) + quat_scalar * v38 < 0 then
                                v37 = -v37;
                                v38 = -v38;
                            end;

                            local vector_lerp_ret3 = vector.lerp(quat_vector, v37, v30);
                            local math_lerp_ret2 = math.lerp(quat_scalar, v38, v30);
                            local v39 = vector.dot(vector_lerp_ret3, vector_lerp_ret3) + math_lerp_ret2 * math_lerp_ret2;
                            local math_sqrt_ret2 = math.sqrt(v39);
                            v29.quat_vector = vector_lerp_ret3 / math_sqrt_ret2;
                            v29.quat_scalar = math_lerp_ret2 / math_sqrt_ret2;
                        end;
                    end;

                    v29.priority = priority;
                end;
            end;
        end;

        for i, v in p17 do
            local priority = v.priority;
            local v40 = i.length * v.alpha;
            local length = i.length;
            local start_fade_time = v.start_fade_time;
            local stop_fade_time = v.stop_fade_time;
            local v41;

            if start_fade_time > 0 and v40 <= start_fade_time then
                v41 = math.min(1, 1 - (start_fade_time - v40) / start_fade_time);
            else
                v41 = (stop_fade_time <= 0 or length - stop_fade_time > v40) and 1 or math.min(1, 1 - (v40 - (length - stop_fade_time)) / stop_fade_time);
            end;

            for _, v2 in i.identity_limbs do
                local v42 = limb_transforms[v2];

                if v42.priority == -1 then
                    v42.position = vector.lerp(v42.position, Vector3.new(0, 0, 0), v41);
                    local quat_vector = v42.quat_vector;
                    local quat_scalar = v42.quat_scalar;
                    local v43 = Vector3.new(0, 0, 0);
                    local v44 = 1;

                    if vector.dot(quat_vector, v43) + quat_scalar * v44 < 0 then
                        v43 = -v43;
                        v44 = -v44;
                    end;

                    local vector_lerp_ret = vector.lerp(quat_vector, v43, v41);
                    local math_lerp_ret = math.lerp(quat_scalar, v44, v41);
                    local v45 = vector.dot(vector_lerp_ret, vector_lerp_ret) + math_lerp_ret * math_lerp_ret;
                    local math_sqrt_ret = math.sqrt(v45);
                    v42.quat_vector = vector_lerp_ret / math_sqrt_ret;
                    v42.quat_scalar = math_lerp_ret / math_sqrt_ret;
                    v42.priority = priority;
                end;
            end;
        end;

        if not p19 then
            local result_coordinate_frames = p16.result_coordinate_frames;
            result_coordinate_frames.root = p18;

            for i, v in p16.limbs do
                local v46 = limb_transforms[i];
                local position = v46.position;
                local quat_vector = v46.quat_vector;
                local CFrame_new_ret = CFrame.new(position.x, position.y, position.z, quat_vector.x, quat_vector.y, quat_vector.z, v46.quat_scalar);
                local v47 = v.c0 * CFrame_new_ret * v.c1;

                if v21 ~= 1 then
                    v47 = v47.Rotation + v47.Position * v21;
                end;

                result_coordinate_frames[v.name] = result_coordinate_frames[v.depends_on] * v47;
            end;
        end;
    end
};