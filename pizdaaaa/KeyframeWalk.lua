-- ReplicatedStorage.Shared.KeyframeWalk
-- Script path: ReplicatedStorage.Shared.KeyframeWalk
-- Decompile time: 9.84 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    Walk = { "WalkW", "WalkDW", "WalkD", "WalkDS", "WalkS", "WalkAS", "WalkA", "WalkAW" },
    Crouch = { "CrouchW", "CrouchDW", "CrouchD", "CrouchDS", "CrouchS", "CrouchAS", "CrouchA", "CrouchAW" },
    Climb = { "Climb_up", "Climb_down" }
};
local u3 = {
    LowerTorso = "Root",
    LeftUpperLeg = "LeftHip",
    LeftLowerLeg = "LeftKnee",
    LeftFoot = "LeftAnkle",
    RightUpperLeg = "RightHip",
    RightLowerLeg = "RightKnee",
    RightFoot = "RightAnkle"
};

local function CollectPoses(p4, p5) -- Line: 68
    -- upvalues: CollectPoses (copy)
    if p4:IsA("Pose") and p4.Weight > 0 then
        p5[p4.Name] = p4.CFrame;
    end;

    for _, child in p4:GetChildren() do
        CollectPoses(child, p5);
    end;
end;

local function BakeSequence(p6) -- Line: 91
    -- upvalues: u3 (copy), CollectPoses (copy)
    if typeof(p6) == "Instance" and p6:IsA("ModuleScript") then
        p6 = require(p6);
    end;

    if typeof(p6) ~= "table" then
        local Children = p6:GetChildren();
        table.sort(Children, function(p7, p8) -- Line: 147
            return p7.Time < p8.Time;
        end);
        local v9 = {};

        for i, v in Children do
            local v10 = {};

            for _, child in v:GetChildren() do
                CollectPoses(child, v10);
            end;

            local v11 = {};

            for i2, v2 in v10 do
                local v12 = u3[i2];

                if v12 then
                    v11[v12] = v2;
                end;
            end;

            v9[i] = v11;
        end;

        return v9;
    end;

    if p6.frames then
        return p6.frames;
    end;

    local limbs = p6.limbs;
    local v13 = {};
    local v14 = {};

    for i, v in ipairs(p6.keyframes) do
        local table_clone_ret = table.clone(v13);

        for i2, v2 in pairs(v.poses or (v.p or {})) do
            local v15;

            if limbs then
                v15 = limbs[i2] or i2;
            else
                v15 = i2;
            end;

            local v16 = u3[v15];

            if v16 then
                if v2.cf then
                    table_clone_ret[v16] = v2.cf;
                    v13[v16] = v2.cf;
                else
                    local v17, v18, v19;

                    if typeof(v2[1]) == "number" then
                        v17 = vector.create(v2[1], v2[2], v2[3]);
                        v18 = vector.create(v2[4], v2[5], v2[6]);
                        v19 = v2[7];
                    else
                        v17 = v2.pos;
                        v18 = v2.qv;
                        v19 = v2.qs;
                    end;

                    if v17 and (v18 and typeof(v19) == "number") then
                        local vector_magnitude_ret = vector.magnitude(v18);
                        local v20 = math.atan2(vector_magnitude_ret, v19) * 2;
                        local v21 = CFrame.new(v17) * CFrame.fromAxisAngle(vector_magnitude_ret > 1e-6 and (v18 / vector_magnitude_ret or Vector3.new(0, 1, 0)) or Vector3.new(0, 1, 0), v20);
                        table_clone_ret[v16] = v21;
                        v13[v16] = v21;
                    end;
                end;
            end;
        end;

        v14[i] = table_clone_ret;
    end;

    table.clear(p6.keyframes);

    return v14;
end;

local function SampleFrames(p22, p23, p24) -- Line: 186
    local v25 = #p22;
    local v26 = p23 % v25;
    local math_floor_ret = math.floor(v26);
    local v27 = v26 - math_floor_ret;
    local v28 = p22[math_floor_ret + 1];
    local v29 = p22[(math_floor_ret + 1) % v25 + 1];
    local v30 = p24 or {};
    table.clear(v30);

    for i, v in v28 do
        local v31 = v29[i];

        if v31 then
            v30[i] = v:Lerp(v31, v27);
        else
            v30[i] = v;
        end;
    end;

    return v30;
end;

local function BearingFromLocalWish(p32: number, p33: number) -- Line: 217
    return math.atan2(p32, -p33) % 6.283185307179586;
end;

function u1.DampWish(p34: number, p35: number, p36: number, p37: number, p38: number) -- Line: 237
    local math_atan2_ret = math.atan2(p34, -p35);
    local v39 = math_atan2_ret + ((math.atan2(p36, -p37) - math_atan2_ret + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * (1 - math.exp(-p38 * 10));

    return math.sin(v39), -math.cos(v39);
end;

local u40 = {};

function u1.Bake(p41: userdata) -- Line: 266
    -- upvalues: u40 (copy), u2 (copy), BakeSequence (copy)
    local v42 = u40[p41];

    if v42 then
        return v42;
    end;

    local v43 = u2[p41.Name];

    if not v43 then
        warn("KeyframeWalk: no anim order known for folder \'" .. p41.Name .. "\' — add a row to ANIM_ORDERS");

        return nil;
    end;

    local v44 = {};

    for i, v in ipairs(v43) do
        local v45 = p41:FindFirstChild(v);

        if not v45 then
            warn("KeyframeWalk: folder \'" .. p41.Name .. "\' is missing \'" .. v .. "\'");

            return nil;
        end;

        v44[i] = BakeSequence(v45);
    end;

    u40[p41] = v44;

    return v44;
end;

function u1.SampleAt(p46: any, p47: number, p48: number, p49: table?) -- Line: 303
    -- upvalues: SampleFrames (copy)
    local v50 = p46[p47];

    return SampleFrames(v50, p48 * #v50, p49);
end;

local u51 = {};
local u52 = {};

function u1.SamplePose(p53: any, p54: number, p55: number, p56: number, p57: table?) -- Line: 328
    -- upvalues: u1 (copy), u51 (copy), u52 (copy)
    local v58 = math.atan2(p55, -p56) % 6.283185307179586 / 0.7853981633974483;
    local math_floor_ret = math.floor(v58);

    return u1.BlendPoses(u1.SampleAt(p53, math_floor_ret % 8 + 1, p54, u51), u1.SampleAt(p53, (math_floor_ret + 1) % 8 + 1, p54, u52), v58 - math_floor_ret, p57);
end;

function u1.BlendPoses(p59: any, p60: any, p61: number, p62: table?) -- Line: 344
    local CFrame_identity = CFrame.identity;
    local v63 = p62 or {};
    table.clear(v63);

    for i, v in p59 do
        v63[i] = v:Lerp(p60[i] or CFrame_identity, p61);
    end;

    for i, v in p60 do
        if v63[i] == nil then
            v63[i] = CFrame_identity:Lerp(v, p61);
        end;
    end;

    return v63;
end;

return u1;