-- ReplicatedStorage.Shared.CollisionModule
-- Script path: ReplicatedStorage.Shared.CollisionModule
-- Decompile time: 8.78 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = game:GetService("RunService"):IsServer();
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = 0;
local u14 = {};
local u15 = true;
u1.Generation = 0;

local function BumpGeneration() -- Line: 60
    -- upvalues: u6 (ref), u1 (copy)
    local v16 = u6;
    v16.Generation = v16.Generation + 1;
    u1.Generation = u6.Generation;
end;

local function RefreshConfig() -- Line: 65
    -- upvalues: u15 (ref), u4 (ref), u6 (ref)
    u15 = u4.Get("Optimization", "HullBroadphase");
    u6.DefaultCollisionBox = u4.Get("Character", "StandCollisionSize") or Vector3.new(2, 5, 2);
    u6.CrouchCollisionBox = u4.Get("Character", "DuckCollisionSize") or Vector3.new(2, 3.75, 2);
    u6.HalfDefaultCollisionBox = u6.DefaultCollisionBox * 0.5;
    u6.HalfCrouchCollisionBox = u6.CrouchCollisionBox * 0.5;
end;

function u1.SetPlayerHulls(p17: table, p18: table, p19: table, p20: number) -- Line: 78
    -- upvalues: u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    u10 = p17;
    u11 = p18;
    u12 = p19;
    u13 = p20;
end;

function u1.Sweep(p21: vector, p22: vector, p23: boolean) -- Line: 82
    -- upvalues: u8 (ref), u13 (ref), u6 (ref), u10 (ref), u11 (ref), u15 (ref), u9 (ref), u12 (ref)
    local v24 = u8.Sweep(p21, p22, p23);

    if u13 == 0 then
        return v24;
    end;

    local v25 = p23 and u6.HalfCrouchCollisionBox or u6.HalfDefaultCollisionBox;
    local v26 = p22 - p21;
    local X = v26.X;
    local Y = v26.Y;
    local Z = v26.Z;
    local vector_magnitude_ret = vector.magnitude(v26);
    local v27 = vector_magnitude_ret > 1e-6 and u6.SkinThickness / vector_magnitude_ret or 1;
    local SweepMin = v24.SweepMin;
    local SweepMax = v24.SweepMax;

    for i = 1, u13 do
        local v28 = u10[i];
        local v29 = u11[i] + v25;
        local v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40;

        if u15 then
            local X2 = v28.X;
            local Y2 = v28.Y;
            local Z2 = v28.Z;
            local X3 = v29.X;
            local Y3 = v29.Y;
            local Z3 = v29.Z;

            if SweepMin.X > X2 + X3 or (SweepMax.X < X2 - X3 or (SweepMin.Y > Y2 + Y3 or (SweepMax.Y < Y2 - Y3 or (SweepMin.Z > Z2 + Z3 or SweepMax.Z < Z2 - Z3)))) then
                v30 = i;
            else
                v31 = p21 - v28;
                v32, v33, v34, v35 = u9(v31.X, v31.Y, v31.Z, X, Y, Z, v29.X, v29.Y, v29.Z);

                if v33 == 0 and (v34 == 0 and v35 == 0) then
                    if v32 > 1 then
                        v30 = i;
                    else
                        v36 = v29.X - math.abs(v31.X);
                        v37 = v29.Y - math.abs(v31.Y);
                        v38 = v29.Z - math.abs(v31.Z);

                        if v36 <= v37 and v36 <= v38 then
                            v33 = v31.X >= 0 and 1 or -1;
                        elseif v37 <= v38 then
                            v34 = v31.Y >= 0 and 1 or -1;
                        else
                            v35 = v31.Z >= 0 and 1 or -1;
                        end;

                        if X * v33 + Y * v34 + Z * v35 < 0 then
                            v32 = 0;
                            v39 = v32 - v27;
                            v40 = v39 < 0 and 0 or v39;

                            if v24.Fraction <= v40 then
                                v30 = i;
                            else
                                v24.Fraction = v40;
                                v24.Normal = vector.create(v33, v34, v35);
                                v24.EndPosition = p21 + v26 * v40;
                                v24.Instance = u12[i];
                                v24.Climbable = nil;
                                v30 = i;
                            end;
                        end;

                        v30 = i;
                    end;
                else
                    v39 = v32 - v27;
                    v40 = v39 < 0 and 0 or v39;

                    if v24.Fraction <= v40 then
                        v30 = i;
                    else
                        v24.Fraction = v40;
                        v24.Normal = vector.create(v33, v34, v35);
                        v24.EndPosition = p21 + v26 * v40;
                        v24.Instance = u12[i];
                        v24.Climbable = nil;
                        v30 = i;
                    end;
                end;
            end;
        else
            v31 = p21 - v28;
            v32, v33, v34, v35 = u9(v31.X, v31.Y, v31.Z, X, Y, Z, v29.X, v29.Y, v29.Z);

            if v33 ~= 0 or (v34 ~= 0 or v35 ~= 0) then
                v39 = v32 - v27;
                v40 = v39 < 0 and 0 or v39;

                if v24.Fraction <= v40 then
                    v30 = i;
                else
                    v24.Fraction = v40;
                    v24.Normal = vector.create(v33, v34, v35);
                    v24.EndPosition = p21 + v26 * v40;
                    v24.Instance = u12[i];
                    v24.Climbable = nil;
                    v30 = i;
                end;
            end;

            if v32 > 1 then
                v30 = i;
            else
                v36 = v29.X - math.abs(v31.X);
                v37 = v29.Y - math.abs(v31.Y);
                v38 = v29.Z - math.abs(v31.Z);

                if v36 <= v37 and v36 <= v38 then
                    v33 = v31.X >= 0 and 1 or -1;
                elseif v37 <= v38 then
                    v34 = v31.Y >= 0 and 1 or -1;
                else
                    v35 = v31.Z >= 0 and 1 or -1;
                end;

                if X * v33 + Y * v34 + Z * v35 < 0 then
                    v32 = 0;
                    v39 = v32 - v27;
                    v40 = v39 < 0 and 0 or v39;

                    if v24.Fraction <= v40 then
                        v30 = i;
                    else
                        v24.Fraction = v40;
                        v24.Normal = vector.create(v33, v34, v35);
                        v24.EndPosition = p21 + v26 * v40;
                        v24.Instance = u12[i];
                        v24.Climbable = nil;
                        v30 = i;
                    end;
                end;

                v30 = i;
            end;
        end;
    end;

    return v24;
end;

function u1.SweepBox(p41: vector, p42: vector, p43: vector, p44) -- Line: 194
    -- upvalues: u8 (ref)
    return u8.SweepBox(p41, p42, p43, p44);
end;

function u1.BoxSolid(p45: vector, p46: vector, p47) -- Line: 199
    -- upvalues: u8 (ref)
    return u8.BoxSolid(p45, p46, p47);
end;

function u1.SweepLadders(p48: vector, p49: vector, p50: boolean) -- Line: 203
    -- upvalues: u8 (ref)
    return u8.SweepLadders(p48, p49, p50);
end;

function u1.GenerateCollision(p51, p52) -- Line: 207
    -- upvalues: u14 (copy), u6 (ref), u7 (ref), u2 (copy), u1 (copy)
    table.clear(u14);
    local ClipsFolder = u6.ClipsFolder;

    if ClipsFolder then
        ClipsFolder:Destroy();
        u6.ClipsFolder = nil;
    end;

    u7.Build(p51, p52, u2);
    u1.CurrentBuffer = u6.CurrentBuffer;
    local v53 = u6;
    v53.Generation = v53.Generation + 1;
    u1.Generation = u6.Generation;
end;

function u1.AddStaticParts(p54: table) -- Line: 222
    -- upvalues: u7 (ref), u6 (ref), u1 (copy)
    u7.AddStaticParts(p54);
    local v55 = u6;
    v55.Generation = v55.Generation + 1;
    u1.Generation = u6.Generation;
end;

local function FindBrushes(p56: userdata) -- Line: 255
    -- upvalues: u5 (ref), u6 (ref)
    local v57, v58, v59, v60, v61, v62 = u5.FindAABB(p56.CFrame, p56.Size);
    local v63 = vector.create(v57, v58, v59) - Vector3.new(1, 1, 1);
    local v64 = vector.create(v60, v61, v62) + Vector3.new(1, 1, 1);
    local HalfDefaultCollisionBox = u6.HalfDefaultCollisionBox;
    local v65 = {};

    for i = 1, u6.HullRecordCount do
        local v66 = u6.StandMin[i] + HalfDefaultCollisionBox;
        local v67 = u6.StandMax[i] - HalfDefaultCollisionBox;
        local v68;

        if v66.X >= v63.X and (v66.Y >= v63.Y and (v66.Z >= v63.Z and (v67.X <= v64.X and (v67.Y <= v64.Y and v67.Z <= v64.Z)))) then
            table.insert(v65, i);
            v68 = i;
        else
            v68 = i;
        end;
    end;

    return v65;
end;

function u1.SetBrushesEnabled(p69: userdata, p70: boolean) -- Line: 280
    -- upvalues: u14 (copy), u6 (ref), u1 (copy), FindBrushes (copy)
    local v71 = u14[p69];

    if p70 then
        if not v71 then
            return;
        end;

        for _, v in v71 do
            local Id = v.Id;
            local StandMax = u6.StandMax;
            local StandMax2 = v.StandMax;
            u6.StandMin[Id] = v.StandMin;
            StandMax[Id] = StandMax2;
            local CrouchMax = u6.CrouchMax;
            local CrouchMax2 = v.CrouchMax;
            u6.CrouchMin[Id] = v.CrouchMin;
            CrouchMax[Id] = CrouchMax2;
        end;

        u14[p69] = nil;
        local v72 = u6;
        v72.Generation = v72.Generation + 1;
        u1.Generation = u6.Generation;

        return;
    end;

    if v71 then
        return;
    end;

    local v73 = FindBrushes(p69);

    if #v73 == 0 then
        return;
    end;

    local table_create_ret = table.create(#v73);

    for _, v in v73 do
        table.insert(table_create_ret, {
            Id = v,
            StandMin = u6.StandMin[v],
            StandMax = u6.StandMax[v],
            CrouchMin = u6.CrouchMin[v],
            CrouchMax = u6.CrouchMax[v]
        });
        local StandMax = u6.StandMax;
        u6.StandMin[v] = Vector3.new(inf, inf, inf);
        StandMax[v] = Vector3.new(-inf, -inf, -inf);
        local CrouchMax = u6.CrouchMax;
        u6.CrouchMin[v] = Vector3.new(inf, inf, inf);
        CrouchMax[v] = Vector3.new(-inf, -inf, -inf);
    end;

    u14[p69] = table_create_ret;
    local v74 = u6;
    v74.Generation = v74.Generation + 1;
    u1.Generation = u6.Generation;
end;

function u1.Cleanup() -- Line: 328
    -- upvalues: u14 (copy), u6 (ref), u1 (copy)
    table.clear(u14);
    u6.Reset();
    u1.CurrentBuffer = nil;
    local v75 = u6;
    v75.Generation = v75.Generation + 1;
    u1.Generation = u6.Generation;
end;

function u1.HasLadders() -- Line: 337
    -- upvalues: u6 (ref)
    return u6.LadderAmount > 0;
end;

function u1.Init(p76) -- Line: 341
    -- upvalues: u4 (ref), u3 (ref), u5 (ref), u9 (ref), u6 (ref), u7 (ref), u8 (ref), RefreshConfig (copy)
    u4 = p76:GetModule("GameConfiguration");
    u3 = p76:GetModule("Enums");
    u5 = p76:GetModule("CollisionMath");
    u9 = u5.SweepPointBox;
    u6 = require(script.CollisionState);
    u7 = require(script.CollisionBuilder);
    u8 = require(script.BVH);
    RefreshConfig();
    u4.Updated:Connect(RefreshConfig);
end;

return u1;