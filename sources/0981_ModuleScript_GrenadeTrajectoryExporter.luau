-- Decompiled with Potassium's decompiler.

local v1 = {};

local function vec3ToArray(p2: vector) -- Line: 43
    return { p2.X, p2.Y, p2.Z };
end;

local function calculateAngle(p3: vector, p4: vector) -- Line: 47
    local Magnitude = p3.Magnitude;

    if Magnitude < 0.001 then
        return 0;
    end;

    local v5 = (p3 / Magnitude):Dot(p4);
    local math_abs_ret = math.abs(v5);
    local math_clamp_ret = math.clamp(math_abs_ret, -1, 1);
    local math_acos_ret = math.acos(math_clamp_ret);

    return math.deg(math_acos_ret);
end;

function v1.startRecording(p6: string, p7: string, p8: vector, p9: vector, p10: vector, p11: string?) -- Line: 60
    local v12 = {
        map_name = "",
        end_position = nil,
        end_reason = nil,
        grenade_type = p6,
        throw_type = p7,
        start_position = { p8.X, p8.Y, p8.Z }
    };
    local Unit = p9.Unit;
    v12.throw_direction = { Unit.X, Unit.Y, Unit.Z };
    v12.player_velocity = { p10.X, p10.Y, p10.Z };
    v12.player_state = p11 or "standing";
    v12.start_time = tick();
    v12.points = {};
    v12.bounces = {};

    return v12;
end;

function v1.recordPoint(p13: table, p14: any, p15: boolean?) -- Line: 85
    local math_floor_ret = math.floor(p14.simulationTime * 1000);

    if not p15 and math_floor_ret - (#p13.points <= 0 and -16 or p13.points[#p13.points].time_ms) < 16 then
        return;
    end;

    local points = p13.points;
    local v16 = {
        time_ms = math_floor_ret
    };
    local position = p14.position;
    v16.position = { position.X, position.Y, position.Z };
    local velocity = p14.velocity;
    v16.velocity = { velocity.X, velocity.Y, velocity.Z };
    v16.speed = p14.velocity.Magnitude;
    table.insert(points, v16);
end;

function v1.recordBounce(p17: table, p18: any, p19: vector, p20: string?) -- Line: 109
    local v21 = p18.normal or Vector3.new(0, 1, 0);
    local velocity = p18.velocity;
    local bounces = p17.bounces;
    local v22 = {
        time_ms = math.floor((p18.timestamp - (p17.start_time or p18.timestamp)) * 1000)
    };
    local position = p18.position;
    v22.position = { position.X, position.Y, position.Z };
    v22.velocity_before = { p19.X, p19.Y, p19.Z };
    v22.velocity_after = { velocity.X, velocity.Y, velocity.Z };
    v22.surface_normal = { v21.X, v21.Y, v21.Z };
    v22.surface_type = p20 or "world";
    local Magnitude = p19.Magnitude;
    local v23;

    if Magnitude < 0.001 then
        v23 = 0;
    else
        local v24 = (p19 / Magnitude):Dot(v21);
        local math_abs_ret = math.abs(v24);
        local math_clamp_ret = math.clamp(math_abs_ret, -1, 1);
        local math_acos_ret = math.acos(math_clamp_ret);
        v23 = math.deg(math_acos_ret);
    end;

    v22.incident_angle = v23;
    local Magnitude2 = velocity.Magnitude;
    local v25;

    if Magnitude2 < 0.001 then
        v25 = 0;
    else
        local v26 = (velocity / Magnitude2):Dot(v21);
        local math_abs_ret = math.abs(v26);
        local math_clamp_ret = math.clamp(math_abs_ret, -1, 1);
        local math_acos_ret = math.acos(math_clamp_ret);
        v25 = math.deg(math_acos_ret);
    end;

    v22.reflection_angle = v25;
    table.insert(bounces, v22);
end;

function v1.finishRecording(p27: table, p28: vector, p29: string) -- Line: 131
    p27.end_position = { p28.X, p28.Y, p28.Z };
    p27.end_reason = p29;
end;

return v1;