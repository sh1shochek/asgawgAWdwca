-- ReplicatedStorage.Shared.Simulation.Collision
-- Script path: ReplicatedStorage.Shared.Simulation.Collision
-- Decompile time: 12.91 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local table_freeze_ret = table.freeze({ Vector3.new(0, 1, 0), Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1), Vector3.new(0, -1, 0) });
local u2 = nil;
local u3 = nil;
local u4 = nil;
local table_create_ret = table.create(5);
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = -1;

function u1.UpdatePlayerHulls(p9: any, p10: number?) -- Line: 76
    -- upvalues: u3 (ref), u8 (ref), u4 (ref), u5 (copy), u6 (copy), u7 (copy), u2 (ref)
    local v11 = 0;

    if u3.CFG.SolidPlayers then
        local Identifier = p9.Identifier;
        local HullMaxDistance = u3.CFG.HullMaxDistance;
        local v12 = HullMaxDistance > 0 and HullMaxDistance * HullMaxDistance or 0;
        local Position = p9.Position;

        for i, v in u4.GetAllCategoryEntities("Character") do
            if i ~= Identifier and v.PrimaryPart then
                local v13, v14;

                if v12 > 0 then
                    local v15 = v.Position - Position;

                    if v12 >= vector.dot(v15, v15) then
                        v13, v14 = u4.GetStateAtTime(v, p10);
                        v11 = v11 + 1;
                        u5[v11] = v13;
                        u6[v11] = v14 and u3.HalfDuckCollisionBox or u3.HalfStandCollisionBox;
                        u7[v11] = v.CollisionBox or v.PrimaryPart;
                    end;
                else
                    v13, v14 = u4.GetStateAtTime(v, p10);
                    v11 = v11 + 1;
                    u5[v11] = v13;
                    u6[v11] = v14 and u3.HalfDuckCollisionBox or u3.HalfStandCollisionBox;
                    u7[v11] = v.CollisionBox or v.PrimaryPart;
                end;
            end;
        end;
    elseif u8 == 0 then
        return;
    end;

    for i = #u7, v11 + 1, -1 do
        u5[i] = nil;
        u6[i] = nil;
        u7[i] = nil;
        local _ = i;
    end;

    u8 = v11;
    u2.SetPlayerHulls(u5, u6, u7, v11);
end;

function u1.CheckStuck(p16) -- Line: 156
    -- upvalues: u2 (ref), u3 (ref), table_freeze_ret (copy)
    local Ducked = p16.Ducked;
    local Generation = u2.Generation;

    if u3.CFG.StuckCheckMemo and (p16.LastStuckGeneration == Generation and (p16.LastStuckDucked == Ducked and p16.LastStuckPosition == p16.Position)) then
        return false;
    end;

    local v17 = Ducked and u3.DuckCollisionBox or u3.StandCollisionBox;

    if u2.BoxSolid(p16.Position, v17) then
        for i = 0.1, 6, 0.1 do
            local v18 = i;

            for _, v in table_freeze_ret do
                local v19 = p16.Position + v * v18;

                if not u2.BoxSolid(v19, v17) then
                    p16.Position = v19;
                    p16.LastStuckPosition = v19;
                    p16.LastStuckDucked = Ducked;
                    p16.LastStuckGeneration = Generation;

                    return true;
                end;
            end;
        end;

        return false;
    end;

    p16.LastStuckPosition = p16.Position;
    p16.LastStuckDucked = Ducked;
    p16.LastStuckGeneration = Generation;

    return false;
end;

function u1.ClipVelocity(p20: vector, p21: vector) -- Line: 199
    local v22 = p20 - p21 * vector.dot(p20, p21);
    local vector_dot_ret = vector.dot(v22, p21);

    if vector_dot_ret < 0 then
        v22 = v22 - p21 * math.min(vector_dot_ret, -0.00216875);
    end;

    return v22;
end;

local table_freeze_ret2 = table.freeze({ Vector3.new(-1, 0, -1), Vector3.new(1, 0, 1), Vector3.new(-1, 0, 1), Vector3.new(1, 0, -1) });
local u23 = {};

local function QuadrantGeometry(p24: boolean, p25: vector) -- Line: 264
    -- upvalues: u23 (copy), table_freeze_ret2 (copy)
    local v26 = u23[p24];

    if not v26 or v26.Box ~= p25 then
        local vector_create_ret = vector.create(p25.X * 0.25, 0, p25.Z * 0.25);
        local table_create_ret2 = table.create(4);

        for i, v in table_freeze_ret2 do
            table_create_ret2[i] = v * vector_create_ret;
        end;

        v26 = {
            Box = p25,
            QuarterBox = vector.create(p25.X * 0.5, p25.Y, p25.Z * 0.5),
            Offsets = table_create_ret2
        };
        u23[p24] = v26;
    end;

    return v26.QuarterBox, v26.Offsets;
end;

local function TouchGroundInQuadrants(p27: vector, p28: number, p29: boolean, p30: vector) -- Line: 289
    -- upvalues: u3 (ref), QuadrantGeometry (copy), u2 (ref)
    local v31, v32 = QuadrantGeometry(p29, p29 and u3.DuckCollisionBox or u3.StandCollisionBox);

    for i = 1, 4 do
        local v33 = p27 + v32[i];
        local v34 = u2.SweepBox(v33, v33 + p30, v31);

        if v34.Fraction < 1 and p28 <= v34.Normal.Y then
            return true, v34.Instance;
        end;

        local _ = i;
    end;

    return false, nil;
end;

function u1.DoGroundCheck(p35: vector, p36: number, p37: boolean, p38: number?) -- Line: 312
    -- upvalues: u2 (ref), TouchGroundInQuadrants (copy)
    local vector_create_ret = vector.create(0, -(0.1388 + (p38 or 0)), 0);
    local v39 = u2.Sweep(p35, p35 + vector_create_ret, p37);
    local Fraction = v39.Fraction;
    local Instance = v39.Instance;
    local EndPosition = v39.EndPosition;
    local StartSolid = v39.StartSolid;
    local v40 = not v39.StartInHull;
    local v41 = false;
    local v42 = nil;

    if p36 <= v39.Normal.Y and (v39.AllSolid or Fraction < 1) then
        v42 = Instance;
        v41 = true;
    elseif Fraction < 1 then
        v41, v42 = TouchGroundInQuadrants(p35, p36, p37, vector_create_ret);
    end;

    return v41, v42, v40, EndPosition, Fraction, StartSolid;
end;

function u1.ProjectVelocity(p43: vector, p44: vector, p45: number, p46: boolean, p47: number?) -- Line: 359
    -- upvalues: u3 (ref), u2 (ref), table_create_ret (copy), u1 (copy)
    local ProjectVelocityEpsilonSkip = u3.CFG.ProjectVelocityEpsilonSkip;
    local v48 = p44;
    local v49 = 0;
    local v50 = false;
    local v51 = false;

    for i = 1, p47 or 4 do
        if vector.dot(p44, p44) < 1e-6 then
            return p43, Vector3.new(0, 0, 0), v50, v51;
        end;

        local v52 = p44 * p45;

        if ProjectVelocityEpsilonSkip and vector.dot(v52, v52) < 1e-8 then
            return p43, Vector3.new(0, 0, 0), v50, v51;
        end;

        local v53 = u2.Sweep(p43, p43 + v52, p46);

        if v53.AllSolid then
            return p43, Vector3.new(0, 0, 0), true, false;
        end;

        if v53.Fraction > 0 and v53.Fraction < 0.0001 then
            v53.Fraction = 0;
        end;

        if v53.Fraction > 0 then
            p43 = v53.EndPosition;

            if v53.Fraction >= 1 then
                v51 = not v53.EndInHull;
            else
                v51 = false;
            end;

            v48 = p44;
            v49 = 0;
        end;

        if v53.Fraction >= 1 then
            break;
        end;

        p45 = p45 - p45 * v53.Fraction;
        local Normal = v53.Normal;
        local _ = i;
        local v54 = false;
        v50 = true;

        for i2 = 1, v49 do
            if vector.dot(Normal, table_create_ret[i2]) > 0.999 then
                p43 = p43 + Normal * 0.001;
                p44 = p44 + Normal;
                v54 = true;
                break;
            end;

            local _ = i2;
        end;

        if not v54 then
            v49 = v49 + 1;
            table_create_ret[v49] = Normal;
            local v55 = false;

            for i2 = 1, v49 do
                local v56 = u1.ClipVelocity(v48, table_create_ret[i2]);
                local v57 = i2;
                local v58 = false;

                for i3 = 1, v49 do
                    if i3 ~= v57 and vector.dot(v56, table_create_ret[i3]) < 0 then
                        v58 = true;
                        break;
                    end;

                    local _ = i3;
                end;

                if not v58 then
                    p44 = v56;
                    v55 = true;
                end;
            end;

            if not v55 then
                if v49 ~= 2 then
                    if p44.Y > 0 then
                        return p43, Vector3.new(0, 0, 0), v50, v51;
                    end;

                    return p43, vector.create(0, p44.Y, 0), v50, v51;
                end;

                local vector_cross_ret = vector.cross(table_create_ret[1], table_create_ret[2]);
                local vector_dot_ret = vector.dot(vector_cross_ret, vector_cross_ret);

                if vector_dot_ret > 0.1 then
                    local v59 = vector_cross_ret / math.sqrt(vector_dot_ret);
                    p44 = v59 * vector.dot(p44, v59);
                else
                    p44 = u1.ClipVelocity(p44, Normal);
                end;
            end;
        end;

        if vector.dot(p44, v48) < 0 then
            return p43, Vector3.new(0, 0, 0), v50, v51;
        end;
    end;

    return p43, p44, v50, v51;
end;

local function LandedOnGround(p60: any, p61: number) -- Line: 506
    -- upvalues: u3 (ref)
    if not u3.CFG.StepReuseLandingNormal then
        return false;
    end;

    if p60.Fraction >= 1 or (p60.AllSolid or p60.StartSolid) then
        return false;
    end;

    return p61 <= p60.Normal.Y;
end;

function u1.DoStepDown(p62: vector, p63: vector, p64: number, p65: boolean) -- Line: 531
    -- upvalues: u2 (ref)
    local EndPosition = u2.Sweep(p62, p62 + Vector3.new(0, 0.1388, 0), p65).EndPosition;
    local v66 = u2.Sweep(EndPosition, p62 - p63, p65);

    if v66.Fraction <= 0 or (v66.Fraction >= 1 or (v66.StartSolid or (v66.AllSolid or v66.Normal.Y < p64))) then
        return nil;
    end;

    local EndPosition2 = v66.EndPosition;
    local v67 = p62.Y - EndPosition2.Y;

    if math.abs(v67) > 0.001084375 then
        return EndPosition2, v67, v66.Instance;
    end;

    return nil, nil, v66.Instance;
end;

function u1.DoStepUp(p68: vector, p69: vector, p70: vector, p71: number, p72: number, p73: boolean) -- Line: 551
    -- upvalues: u3 (ref), u2 (ref), u1 (copy)
    if u3.CFG.StepUpSkipIfLowHorizontalVelocity then
        local v74 = p69 * Vector3.new(1, 0, 1);

        if vector.dot(v74, v74) < 0.0001 then
            return nil;
        end;
    end;

    local v75 = u2.Sweep(p68, p68 + p70, p73);

    if v75.StartSolid or v75.AllSolid then
        return nil;
    end;

    if u3.CFG.StepUpSkipIfHeadBlocked and v75.Fraction < 0.1 then
        return nil;
    end;

    local EndPosition = v75.EndPosition;
    local v76, v77, _ = u1.ProjectVelocity(EndPosition, Vector3.new(1, 0, 1) * p69, p72, p73, u3.CFG.StepUpProbeIterations);

    if u3.CFG.StepUpSkipIfPositionChangeVeryLow and (v76.Y - EndPosition.Y == 0 and vector.dot((EndPosition - v76) * Vector3.new(1, 0, 1), (EndPosition - v76) * Vector3.new(1, 0, 1)) < 1e-6) then
        return nil;
    end;

    local v78 = u2.Sweep(v76, v76 - p70, p73);
    local EndPosition2 = v78.EndPosition;
    local v79 = p68.Y - EndPosition2.Y;

    if u3.CFG.StepUpSkipIfHeightNotChanged and v79 == 0 then
        local v80 = (EndPosition2 - p68) * Vector3.new(1, 0, 1);

        if vector.dot(v80, v80) < 0.0001 then
            return nil;
        end;
    end;

    local v81;

    if u3.CFG.StepReuseLandingNormal and (v78.Fraction < 1 and not (v78.AllSolid or v78.StartSolid)) then
        v81 = p71 <= v78.Normal.Y;
    else
        v81 = false;
    end;

    if v81 or u1.DoGroundCheck(EndPosition2, p71, p73) then
        return EndPosition2, v77, v79;
    end;

    return nil;
end;

function u1.Init(p82) -- Line: 606
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    u2 = p82:GetModule("CollisionModule");
    u3 = p82:GetModule("Config");
    u4 = p82:GetModule("Entities");
end;

return u1;