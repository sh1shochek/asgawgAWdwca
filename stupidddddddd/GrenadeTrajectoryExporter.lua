-- ReplicatedStorage.Shared.GrenadeTrajectoryExporter
-- Script path: ReplicatedStorage.Shared.GrenadeTrajectoryExporter
-- Decompile time: 1.76 ms

local v1 = {}

local function vec3ToArray(a1) -- Line: 43 -- types: a1: vector
    return {a1.X, a1.Y, a1.Z}
end

local function calculateAngle(a1, a2) -- Line: 47 -- types: a1: vector, a2: vector
    local Magnitude = a1.Magnitude
    if Magnitude < 0.001 then
        return 0
    end
    return (math.deg((math.acos((math.clamp(math.abs(((a1 / Magnitude):Dot(a2))), -1, 1))))))
end

function v1.startRecording(a1, a2, a3, a4, a5, a6) -- Line: 60
    -- upvalues: 
    local v1 = {
        map_name = "",
        grenade_type = a1,
        throw_type = a2,
        start_position = {a3.X, a3.Y, a3.Z},
    }
    local Unit = a4.Unit
    v1.throw_direction = {Unit.X, Unit.Y, Unit.Z}
    v1.player_velocity = {a5.X, a5.Y, a5.Z}
    v1.player_state = a6 or "standing"
    v1.start_time = tick()
    v1.points = {}
    v1.bounces = {}
    return v1
end

function v1.recordPoint(a1, a2, a3) -- Line: 85 -- types: a1: table, a3: boolean?
    local v1 = math.floor(a2.simulationTime * 1000)
    local time_ms = if not (#a1.points > 0) then -16 else a1.points[#a1.points].time_ms
    if not a3 and v1 - time_ms < 16 then
        return
    end
    local points = a1.points
    local v2 = {time_ms = v1}
    local position = a2.position
    v2.position = {position.X, position.Y, position.Z}
    local velocity = a2.velocity
    v2.velocity = {velocity.X, velocity.Y, velocity.Z}
    v2.speed = a2.velocity.Magnitude
    table.insert(points, v2)
end

function v1.recordBounce(a1, a2, a3, a4) -- Line: 109 -- types: a1: table, a3: vector, a4: string?
    local v1 = a2.normal or Vector3.new(0, 1, 0)
    local velocity = a2.velocity
    local bounces = a1.bounces
    local v2 = {
        time_ms = math.floor((a2.timestamp - (a1.start_time or a2.timestamp)) * 1000),
    }
    local position = a2.position
    v2.position = {position.X, position.Y, position.Z}
    v2.velocity_before = {a3.X, a3.Y, a3.Z}
    v2.velocity_after = {velocity.X, velocity.Y, velocity.Z}
    v2.surface_normal = {v1.X, v1.Y, v1.Z}
    v2.surface_type = a4 or "world"
    local Magnitude = a3.Magnitude
    v2.incident_angle = if not (Magnitude < 0.001) then math.deg((math.acos((math.clamp(math.abs(((a3 / Magnitude):Dot(v1))), -1, 1))))) else 0
    local Magnitude_2 = velocity.Magnitude
    v2.reflection_angle = if not (Magnitude_2 < 0.001) then math.deg((math.acos((math.clamp(math.abs(((velocity / Magnitude_2):Dot(v1))), -1, 1))))) else 0
    table.insert(bounces, v2)
end

function v1.finishRecording(a1, a2, a3) -- Line: 131 -- types: a1: table, a2: vector, a3: string
    a1.end_position = {a2.X, a2.Y, a2.Z}
    a1.end_reason = a3
end

return v1