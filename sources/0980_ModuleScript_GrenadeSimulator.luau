-- Decompiled with Potassium's decompiler.

local u42 = {
    Constants = {
        GRENADE_ELASTICITY = 0.4,
        FLOOR_NORMAL_THRESHOLD = 0.7,
        FIXED_TIMESTEP = 0.0078125,
        GRAVITY = Vector3.new(0, -23.833334, 0),
        THROW_UPWARD_BIAS_FAR = 0.06,
        THROW_UPWARD_BIAS_NEAR = 0.04,
        THROW_FORWARD_OFFSET = 1.35,
        THROW_HEIGHT_OFFSET = 2.4,
        MAX_SIMULATION_TIME = 10
    },

    createInitialState = function(p1: vector, p2: vector, p3: string, p4: vector, p5: number, p6: number) -- Line: 159, Name: createInitialState
        local v7 = ((p3 == "Far" and 1 or 0) * 0.7 + 0.3) * 57.29166666666667 * p5 * 0.58;
        local v8 = p4.Y > 5;
        local v9 = 1;

        if v8 then
            p1 = p1 + Vector3.new(0, 0, 0);
        end;

        local v10 = v8 and Vector3.new(0, 20, 0) or Vector3.new(0, p4.Y * 2 * 0.58, 0);
        local v11;

        if v8 then
            v11 = Vector3.new(p2.X * v9, p2.Y, p2.Z * v9).Unit;
        else
            v11 = p2;
        end;

        local v12 = not v8 and 1 or v9;
        local v13 = v11 * v7 + v10 + (Vector3.new(p2.X * v12, p2.Y, p2.Z * v12).Unit * v7 * 0.15 + Vector3.new(0, p5 * 6.5 * 0.58, 0));
        local v14 = not v8 and 50 or (p2.Y - 0.4) * 20 + 62;

        if v14 < v13.Magnitude then
            v13 = v13.Unit * v14;
        end;

        local v15 = v13 + Vector3.new(p4.X, 0, p4.Z) * 1.5 * v9;
        local v16 = math.floor(p6 * 1000) % 1000;
        local v17 = math.floor(v16 / 11) % 13 - 6;
        local v18 = math.floor(v16 / 143) % 11 - 5;

        return {
            simulationTime = 0,
            bounceCount = 0,
            isGrounded = false,
            isAtRest = false,
            hasTouched = false,
            accumulatedTime = 0,
            position = p1,
            velocity = v15,
            angularVelocity = Vector3.new(v16 % 11 - 5, v17, v18),
            timestamp = p6,
            isJumpThrow = v8
        };
    end,

    createConfig = function(p19: number, p20: number, p21: boolean, p22: number?, p23: number?, p24: boolean?) -- Line: 246, Name: createConfig
        return {
            restitution = 0.4,
            maxBounces = 20,
            radius = p19,
            fuseTime = p22,
            minimumFuseTime = p23,
            explodeOnFloorImpact = p24,
            rangeScale = p20,
            isNearThrow = p21
        };
    end,

    detectCollision = function(p25: vector, p26: vector, p27: number, p28: userdata) -- Line: 269, Name: detectCollision
        local v29 = p26 - p25;
        local Magnitude = v29.Magnitude;

        if Magnitude < 0.001 then
            return nil;
        end;

        local v30 = p27 * 0.01;
        local v31 = {
            Vector3.new(v30, 0, 0),
            Vector3.new(-v30, 0, 0),
            Vector3.new(0, v30, 0),
            Vector3.new(0, -v30, 0),
            Vector3.new(0, 0, v30),
            (Vector3.new(0, 0, -v30))
        };
        local v32 = (1 / 0);
        local v33 = workspace:Raycast(p25, v29, p28);
        local v34;

        if v33 and v33.Distance < v32 then
            v32 = v33.Distance;
            v34 = Vector3.new(0, 0, 0);
        else
            v33 = nil;
            v34 = Vector3.new(0, 0, 0);
        end;

        for _, v in v31 do
            local v35 = workspace:Raycast(p25 + v, v29, p28);

            if v35 and v35.Distance < v32 then
                v32 = v35.Distance;
                v34 = v;
                v33 = v35;
            end;
        end;

        if not v33 then
            return nil;
        end;

        local v36 = v33.Position - v34;
        local Magnitude2 = (v36 - p25).Magnitude;

        if Magnitude + v30 + 0.1 < Magnitude2 then
            return nil;
        end;

        local Instance = v33.Instance;
        local Parent = Instance.Parent;
        local v37;

        if Parent == nil then
            v37 = false;
        else
            v37 = Parent:IsA("Model") and Parent:GetAttribute("CharacterType") == "PlayerCustomCharacter";
        end;

        local v38 = Parent and Parent:HasTag("BreakableGlass") or Instance:HasTag("BreakableGlass");

        return {
            hit = true,
            position = v36,
            normal = v33.Normal,
            distance = Magnitude2,
            instance = Instance,
            isPlayer = v37,
            isGlass = v38
        };
    end,

    checkGrounded = function(p39: vector, p40: userdata) -- Line: 352, Name: checkGrounded
        local v41 = workspace:Raycast(p39, Vector3.new(0, -0.2, 0), p40);

        if v41 then
            return true, v41.Normal;
        end;

        return false, nil;
    end
};

local function PhysicsClipVelocity(p43: vector, p44: vector, p45: number) -- Line: 367
    local v46 = p43:Dot(p44) * p45;
    local v47 = p43.X - p44.X * v46;
    local v48 = p43.Y - p44.Y * v46;
    local v49 = p43.Z - p44.Z * v46;
    local v50 = math.abs(v47) < 0.0076388888888888895 and 0 or v47;
    local v51 = math.abs(v48) < 0.0076388888888888895 and 0 or v48;
    local v52 = math.abs(v49) < 0.0076388888888888895 and 0 or v49;

    return Vector3.new(v50, v51, v52);
end;

function u42.integrate(p53: vector, p54: vector, p55: number, p56: boolean) -- Line: 391
    if p56 then
        return p53 + p54 * p55, p54;
    end;

    local v57 = p54.Y - p55 * 23.83333396911621;
    local Vector3_new_ret = Vector3.new(p54.X * p55, (p54.Y + v57) / 2 * p55, p54.Z * p55);
    local Vector3_new_ret2 = Vector3.new(p54.X, v57, p54.Z);

    return p53 + Vector3_new_ret, Vector3_new_ret2;
end;

function u42.calculateBounce(p58: vector, p59: vector, p60: table, p61: boolean) -- Line: 421
    -- upvalues: PhysicsClipVelocity (copy)
    local table_clone_ret = table.clone(p60);
    table_clone_ret.bounceCount = p60.bounceCount + 1;
    table_clone_ret.hasTouched = true;
    local math_clamp_ret = math.clamp((p60.isJumpThrow and 0.32 or 0.4) * (p61 and 0.3 or 1), 0, 0.9);
    local v62 = PhysicsClipVelocity(p58, p59, 2) * math_clamp_ret;

    if p59.Y > 0.7 and v62:Dot(v62) < 2.3341049382716053 then
        return Vector3.new(0, 0, 0), table_clone_ret;
    end;

    return v62, table_clone_ret;
end;

function u42.shouldStop(p63: vector, p64: boolean, p65: boolean) -- Line: 455
    if p64 and p65 then
        return p63:Dot(p63) < 2.3341049382716053;
    end;

    return false;
end;

local function newEvent(p66: string, p67: table, p68: table, p69: vector, p70: vector) -- Line: 473
    return {
        type = p66,
        timestamp = p67.timestamp + p68.simulationTime,
        position = p68.position,
        normal = p69,
        velocity = p70,
        bounceCount = p68.bounceCount
    };
end;

function u42.step(p71: table, p72: table, p73: userdata, p74: number) -- Line: 490
    -- upvalues: u42 (copy)
    local table_clone_ret = table.clone(p71);
    table_clone_ret.simulationTime = p71.simulationTime + p74;
    local v75 = nil;

    if table_clone_ret.simulationTime >= 10 then
        table_clone_ret.isAtRest = true;

        return table_clone_ret, {
            type = "timeout",
            normal = Vector3.new(0, 1, 0),
            timestamp = p71.timestamp + table_clone_ret.simulationTime,
            position = table_clone_ret.position,
            velocity = table_clone_ret.velocity,
            bounceCount = table_clone_ret.bounceCount
        };
    end;

    if p72.fuseTime and table_clone_ret.simulationTime >= p72.fuseTime then
        table_clone_ret.isAtRest = true;

        return table_clone_ret, {
            type = "fuse",
            normal = Vector3.new(0, 1, 0),
            timestamp = p71.timestamp + table_clone_ret.simulationTime,
            position = table_clone_ret.position,
            velocity = table_clone_ret.velocity,
            bounceCount = table_clone_ret.bounceCount
        };
    end;

    if p71.bounceCount >= p72.maxBounces then
        table_clone_ret.isAtRest = true;
        table_clone_ret.velocity = Vector3.new(0, 0, 0);

        return table_clone_ret, {
            type = "rest",
            normal = Vector3.new(0, 1, 0),
            velocity = Vector3.new(0, 0, 0),
            timestamp = p71.timestamp + table_clone_ret.simulationTime,
            position = table_clone_ret.position,
            bounceCount = table_clone_ret.bounceCount
        };
    end;

    local position = table_clone_ret.position;
    local v76, v77 = u42.integrate(table_clone_ret.position, table_clone_ret.velocity, p74, table_clone_ret.isGrounded);
    local v78 = u42.detectCollision(position, v76, p72.radius, p73);

    if v78 then
        local v79;
        v79, table_clone_ret = u42.calculateBounce(v77, v78.normal, table_clone_ret, v78.isPlayer);
        table_clone_ret.position = v78.position + v78.normal * 0.05;
        table_clone_ret.velocity = v79;

        if p72.explodeOnFloorImpact and v78.normal.Y > 0.7 and (not p72.minimumFuseTime or table_clone_ret.simulationTime >= p72.minimumFuseTime) then
            table_clone_ret.isAtRest = true;

            return table_clone_ret, {
                type = "floor_impact",
                timestamp = p71.timestamp + table_clone_ret.simulationTime,
                position = table_clone_ret.position,
                normal = v78.normal,
                velocity = table_clone_ret.velocity,
                bounceCount = table_clone_ret.bounceCount
            };
        end;

        v75 = {
            type = "bounce",
            timestamp = p71.timestamp + table_clone_ret.simulationTime,
            position = table_clone_ret.position,
            normal = v78.normal,
            velocity = table_clone_ret.velocity,
            bounceCount = table_clone_ret.bounceCount
        };
    else
        table_clone_ret.position = v76;
        table_clone_ret.velocity = v77;
    end;

    local v80, v81 = u42.checkGrounded(table_clone_ret.position, p73);
    table_clone_ret.isGrounded = v80;

    if not (u42.shouldStop(table_clone_ret.velocity, v80, table_clone_ret.hasTouched) and ((not p72.minimumFuseTime or table_clone_ret.simulationTime >= p72.minimumFuseTime) and not p72.fuseTime)) then
        return table_clone_ret, v75;
    end;

    table_clone_ret.isAtRest = true;
    table_clone_ret.velocity = Vector3.new(0, 0, 0);
    table_clone_ret.angularVelocity = Vector3.new(0, 0, 0);

    return table_clone_ret, {
        type = "rest",
        velocity = Vector3.new(0, 0, 0),
        timestamp = p71.timestamp + table_clone_ret.simulationTime,
        position = table_clone_ret.position,
        normal = v81 or Vector3.new(0, 1, 0),
        bounceCount = table_clone_ret.bounceCount
    };
end;

function u42.simulate(p82: table, p83: table, p84: userdata, p85: number) -- Line: 581
    -- upvalues: u42 (copy)
    if p82.isAtRest then
        if not p83.fuseTime then
            return {
                state = p82,
                events = {}
            };
        end;

        local table_clone_ret = table.clone(p82);
        table_clone_ret.simulationTime = p82.simulationTime + p85;

        return table_clone_ret.simulationTime >= p83.fuseTime and {
            state = table_clone_ret,
            events = {
                {
                    type = "fuse",
                    normal = Vector3.new(0, 1, 0),
                    timestamp = p82.timestamp + table_clone_ret.simulationTime,
                    position = table_clone_ret.position,
                    velocity = table_clone_ret.velocity,
                    bounceCount = table_clone_ret.bounceCount
                }
            }
        } or {
            state = table_clone_ret,
            events = {}
        };
    end;

    local table_clone_ret = table.clone(p82);
    table_clone_ret.accumulatedTime = p82.accumulatedTime + p85;
    local v86, v87;

    if table_clone_ret.accumulatedTime > 0.1 then
        table_clone_ret.accumulatedTime = 0.1;
        v86 = 0;
        v87 = {};
    else
        v86 = 0;
        v87 = {};
    end;

    while table_clone_ret.accumulatedTime >= 0.0078125 and v86 < 16 do
        v86 = v86 + 1;
        table_clone_ret.accumulatedTime = table_clone_ret.accumulatedTime - 0.0078125;
        local v88;
        table_clone_ret, v88 = u42.step(table_clone_ret, p83, p84, 0.0078125);

        if v88 then
            table.insert(v87, v88);
        end;

        if table_clone_ret.isAtRest then
            break;
        end;
    end;

    return {
        state = table_clone_ret,
        events = v87
    };
end;

function u42.calculateThrowParameters(p89: vector, p90: vector, p91: string, p92: number) -- Line: 657
    local v93 = p91 == "Near";
    local v94 = (v93 and 0.04 or 0.06) * math.clamp(p92, 0.8, 1.2);
    local v95 = 1.35;
    local v96 = 2.4;
    local v97;

    if v93 then
        v95 = v95 * 0.55;
        v97 = v96 * 0.8;
        v94 = v94 + 0.08;
    else
        v97 = v96 + 0.1;
    end;

    local Unit = (p90 + Vector3.new(0, v94, 0)).Unit;
    local Vector3_new_ret = Vector3.new(p90.X, 0, p90.Z);

    return p89 + (Vector3_new_ret.Magnitude < 0.01 and Vector3.new(0, 0, -1) or Vector3_new_ret).Unit * v95 + Vector3.new(0, v97, 0), Unit;
end;

return u42;