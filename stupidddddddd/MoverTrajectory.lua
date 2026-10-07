-- ReplicatedStorage.MovementV2.MoverTrajectory
-- Script path: ReplicatedStorage.MovementV2.MoverTrajectory
-- Decompile time: 13.48 ms

local Serial = require(script.Parent.Serial)
local RunService = game:GetService("RunService")
local u10 = {Tag = "MovementV2Mover"}
u10.Attributes = table.freeze({
    Id = "MovementV2MoverId",
    Size = "MovementV2MoverSize",
    CollisionOffset = "MovementV2MoverCollisionOffset",
    SurfaceFriction = "MovementV2MoverSurfaceFriction",
    StartPose = "MovementV2MoverStartPose",
    TargetPose = "MovementV2MoverTargetPose",
    EffectiveTick = "MovementV2MoverEffectiveTick",
    StartTick = "MovementV2MoverStartTick",
    DurationTicks = "MovementV2MoverDurationTicks",
    StartServerTime = "MovementV2MoverStartServerTime",
    DurationSeconds = "MovementV2MoverDurationSeconds",
    Moving = "MovementV2MoverMoving",
    Active = "MovementV2MoverActive",
    Revision = "MovementV2MoverRevision",
    Behavior = "MovementV2MoverBehavior",
})
local u15 = {}
local u16 = {}
local u17 = {}
local u18 = false
local BindableEvent = Instance.new("BindableEvent")
local u22 = {}
local u23 = {TickFraction = 0, UpdatedAt = (-1 / 0)}

local function posesMatch(a1, a2) -- Line: 77 -- types: a1: userdata, a2: userdata
    local v1
    if a1 == a2 then
        return true
    end
    if 1e-05 < (a1.Position - a2.Position).Magnitude then
        return false
    end
    _, v1 = a1.Rotation:ToObjectSpace(a2.Rotation):ToAxisAngle()
    return (math.abs(v1)) <= 1e-05
end

local function isFiniteNumber(a1) -- Line: 88
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    return v1
end

local function isFiniteVector3(a1) -- Line: 92
    local v1 = false
    if typeof(a1) == "Vector3" then
        local X = a1.X
        v1 = false
        if typeof(X) == "number" then
            v1 = false
            if X == X then
                v1 = false
                if X > (-1 / 0) then
                    v1 = X < (1 / 0)
                end
            end
        end
        if v1 then
            local Y = a1.Y
            v1 = false
            if typeof(Y) == "number" then
                v1 = false
                if Y == Y then
                    v1 = false
                    if Y > (-1 / 0) then
                        v1 = Y < (1 / 0)
                    end
                end
            end
            if v1 then
                local Z = a1.Z
                v1 = false
                if typeof(Z) == "number" then
                    v1 = false
                    if Z == Z then
                        v1 = false
                        if Z > (-1 / 0) then
                            v1 = Z < (1 / 0)
                        end
                    end
                end
            end
        end
    end
    return v1
end

local function isFiniteCFrame(a1) -- Line: 99
    local v1
    if typeof(a1) ~= "CFrame" then
        return false
    end
    local v2 = {a1:GetComponents()}
    local v3 = nil
    local v4 = nil
    for i, j in v2, v3, v4 do
        v1 = false
        if typeof(j) == "number" then
            v1 = false
            if j == j then
                v1 = false
                if j > (-1 / 0) then
                    v1 = j < (1 / 0)
                end
            end
        end
        if not v1 then
            return false
        end
    end
    return true
end

function u10.Validate(a1) -- Line: 111 -- upvalues: Serial (val), isFiniteCFrame (val)
    if type(a1) ~= "table" then
        return false, "mover descriptor must be a table"
    end
    if Serial.isUInt32(a1.Id) and a1.Id ~= 0 then
        local Size = a1.Size
        local v1 = false
        if typeof(Size) == "Vector3" then
            local X = Size.X
            v1 = false
            if typeof(X) == "number" then
                v1 = false
                if X == X then
                    v1 = false
                    if X > (-1 / 0) then
                        v1 = X < (1 / 0)
                    end
                end
            end
            if v1 then
                local Y = Size.Y
                v1 = false
                if typeof(Y) == "number" then
                    v1 = false
                    if Y == Y then
                        v1 = false
                        if Y > (-1 / 0) then
                            v1 = Y < (1 / 0)
                        end
                    end
                end
                if v1 then
                    local Z = Size.Z
                    v1 = false
                    if typeof(Z) == "number" then
                        v1 = false
                        if Z == Z then
                            v1 = false
                            if Z > (-1 / 0) then
                                v1 = Z < (1 / 0)
                            end
                        end
                    end
                end
            end
        end
        if v1 and not (a1.Size.X <= 0) and not (a1.Size.Y <= 0) and not (a1.Size.Z <= 0) then
            if not isFiniteCFrame(a1.CollisionOffset) then
                return false, "mover collision offset must be a finite CFrame"
            end
            local SurfaceFriction = a1.SurfaceFriction
            v1 = false
            if typeof(SurfaceFriction) == "number" then
                v1 = false
                if SurfaceFriction == SurfaceFriction then
                    v1 = false
                    if SurfaceFriction > (-1 / 0) then
                        v1 = SurfaceFriction < (1 / 0)
                    end
                end
            end
            if v1 and not (a1.SurfaceFriction < 0) then
                if isFiniteCFrame(a1.StartPose) and isFiniteCFrame(a1.TargetPose) then
                    if Serial.isUInt32(a1.EffectiveTick) and Serial.isUInt32(a1.StartTick) then
                        local DurationSeconds, DurationTicks, StartServerTime
                        if not a1.Moving then
                            if a1.EffectiveTick ~= a1.StartTick then
                                return false, "stationary descriptor effective tick must equal its start tick"
                            end
                            DurationTicks = a1.DurationTicks
                            v1 = false
                            if typeof(DurationTicks) == "number" then
                                v1 = false
                                if DurationTicks == DurationTicks then
                                    v1 = false
                                    if DurationTicks > (-1 / 0) then
                                        v1 = DurationTicks < (1 / 0)
                                    end
                                end
                            end
                            if v1
                                and a1.DurationTicks % 1 == 0
                                and not (a1.DurationTicks < 0)
                                and not (2147483648 <= a1.DurationTicks) then
                                StartServerTime = a1.StartServerTime
                                v1 = false
                                if typeof(StartServerTime) == "number" then
                                    v1 = false
                                    if StartServerTime == StartServerTime then
                                        v1 = false
                                        if StartServerTime > (-1 / 0) then
                                            v1 = StartServerTime < (1 / 0)
                                        end
                                    end
                                end
                                if v1 and not (a1.StartServerTime < 0) then
                                    DurationSeconds = a1.DurationSeconds
                                    v1 = false
                                    if typeof(DurationSeconds) == "number" then
                                        v1 = false
                                        if DurationSeconds == DurationSeconds then
                                            v1 = false
                                            if DurationSeconds > (-1 / 0) then
                                                v1 = DurationSeconds < (1 / 0)
                                            end
                                        end
                                    end
                                    if v1 and not (a1.DurationSeconds < 0) then
                                        if typeof(a1.Moving) ~= "boolean" then
                                            return false, "mover trajectory moving flag must be boolean"
                                        end
                                        if typeof(a1.Active) ~= "boolean" then
                                            return false, "mover trajectory active flag must be boolean"
                                        end
                                        if a1.Moving and not a1.Active then
                                            return false, "an inactive mover trajectory cannot be moving"
                                        end
                                        if a1.Behavior ~= "StopOnBlock" and a1.Behavior ~= "Pusher" then
                                            return false, "mover trajectory behavior is invalid"
                                        end
                                        if Serial.isUInt32(a1.Revision) and a1.Revision ~= 0 then
                                            if not a1.Moving then
                                                return true, nil
                                            end
                                            if not (a1.DurationTicks < 1) and not (a1.DurationSeconds <= 0) then
                                                return true, nil
                                            end
                                            return false, "moving trajectory must have a positive tick and seconds duration"
                                        end
                                        return false, "mover trajectory revision must be a non-zero u32"
                                    end
                                    return false, "mover trajectory duration seconds are invalid"
                                end
                                return false, "mover trajectory start server time is invalid"
                            end
                            return false, "mover trajectory duration ticks are invalid"
                        end
                        v1 = Serial.deltaUInt32(a1.StartTick, a1.EffectiveTick)
                        if not (v1 < 0) and not (v1 > 1) then
                            DurationTicks = a1.DurationTicks
                            v1 = false
                            if typeof(DurationTicks) == "number" then
                                v1 = false
                                if DurationTicks == DurationTicks then
                                    v1 = false
                                    if DurationTicks > (-1 / 0) then
                                        v1 = DurationTicks < (1 / 0)
                                    end
                                end
                            end
                            if v1
                                and a1.DurationTicks % 1 == 0
                                and not (a1.DurationTicks < 0)
                                and not (2147483648 <= a1.DurationTicks) then
                                StartServerTime = a1.StartServerTime
                                v1 = false
                                if typeof(StartServerTime) == "number" then
                                    v1 = false
                                    if StartServerTime == StartServerTime then
                                        v1 = false
                                        if StartServerTime > (-1 / 0) then
                                            v1 = StartServerTime < (1 / 0)
                                        end
                                    end
                                end
                                if v1 and not (a1.StartServerTime < 0) then
                                    DurationSeconds = a1.DurationSeconds
                                    v1 = false
                                    if typeof(DurationSeconds) == "number" then
                                        v1 = false
                                        if DurationSeconds == DurationSeconds then
                                            v1 = false
                                            if DurationSeconds > (-1 / 0) then
                                                v1 = DurationSeconds < (1 / 0)
                                            end
                                        end
                                    end
                                    if v1 and not (a1.DurationSeconds < 0) then
                                        if typeof(a1.Moving) ~= "boolean" then
                                            return false, "mover trajectory moving flag must be boolean"
                                        end
                                        if typeof(a1.Active) ~= "boolean" then
                                            return false, "mover trajectory active flag must be boolean"
                                        end
                                        if a1.Moving and not a1.Active then
                                            return false, "an inactive mover trajectory cannot be moving"
                                        end
                                        if a1.Behavior ~= "StopOnBlock" and a1.Behavior ~= "Pusher" then
                                            return false, "mover trajectory behavior is invalid"
                                        end
                                        if Serial.isUInt32(a1.Revision) and a1.Revision ~= 0 then
                                            if not a1.Moving then
                                                return true, nil
                                            end
                                            if not (a1.DurationTicks < 1) and not (a1.DurationSeconds <= 0) then
                                                return true, nil
                                            end
                                            return false, "moving trajectory must have a positive tick and seconds duration"
                                        end
                                        return false, "mover trajectory revision must be a non-zero u32"
                                    end
                                    return false, "mover trajectory duration seconds are invalid"
                                end
                                return false, "mover trajectory start server time is invalid"
                            end
                            return false, "mover trajectory duration ticks are invalid"
                        end
                        return false, "moving descriptor effective tick must equal or immediately precede its start tick"
                    end
                    return false, "mover trajectory start tick must be a u32"
                end
                return false, "mover trajectory poses must be finite CFrames"
            end
            return false, "mover surface friction must be finite and nonnegative"
        end
        return false, "mover size must be a finite positive Vector3"
    end
    return false, "mover id must be a non-zero u32"
end

function u10.Read(a1) -- Line: 181
    -- upvalues: u10 (val), RunService (val), u18 (ref), Serial (val), u16 (val), u15 (val)
    local v1
    local Attributes = u10.Attributes
    if RunService:IsClient() and u18 then
        local Attribute = a1:GetAttribute(Attributes.Id)
        if Serial.isUInt32(Attribute) and Attribute ~= 0 then
            v1 = u16[Attribute] or u15[Attribute]
            return if v1 == nil then nil else v1, "mover is absent from the reliable descriptor baseline"
        end
        return nil, "mover root identity is unavailable"
    end
    local Attribute_2 = a1:GetAttribute(Attributes.Revision)
    if Attribute_2 == nil then
        return nil, "mover trajectory is not committed"
    end
    v1 = {
        Id = a1:GetAttribute(Attributes.Id),
        Size = a1:GetAttribute(Attributes.Size),
        CollisionOffset = a1:GetAttribute(Attributes.CollisionOffset),
        SurfaceFriction = a1:GetAttribute(Attributes.SurfaceFriction),
        StartPose = a1:GetAttribute(Attributes.StartPose),
        TargetPose = a1:GetAttribute(Attributes.TargetPose),
        EffectiveTick = a1:GetAttribute(Attributes.EffectiveTick),
        StartTick = a1:GetAttribute(Attributes.StartTick),
        DurationTicks = a1:GetAttribute(Attributes.DurationTicks),
        StartServerTime = a1:GetAttribute(Attributes.StartServerTime),
        DurationSeconds = a1:GetAttribute(Attributes.DurationSeconds),
        Moving = a1:GetAttribute(Attributes.Moving),
        Active = a1:GetAttribute(Attributes.Active),
        Behavior = a1:GetAttribute(Attributes.Behavior),
        Revision = Attribute_2,
    }
    local v2, v3 = u10.Validate(v1)
    return if not v2 then nil else v1, v3
end

u10.ClientDescriptorChanged = BindableEvent.Event

function u10.EvaluateProgress(a1, a2) -- Line: 218 -- types: a1: table, a2: number
    local v1 = false
    if type(a2) == "number" then
        v1 = false
        if a2 % 1 == 0 then
            v1 = false
            if a2 >= 0 then
                v1 = a2 <= 65535
            end
        end
    end
    assert(v1, "mover progress must be a u16")
    return a1.StartPose:Lerp(a1.TargetPose, a2 / 65535)
end

function u10.QuantizeProgress(a1) -- Line: 226 -- types: a1: number
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    assert(v1, "mover normalized progress must be finite")
    return (math.floor((math.clamp(a1, 0, 1)) * 65535))
end

function u10.InstallClientBaseline(a1, a2) -- Line: 232
    -- upvalues: RunService (val), u15 (val), u16 (val), u17 (val), u22 (val), u10 (val), Serial (val), u18 (ref)
    -- upvalues: BindableEvent (val)
    local v1, v2, v3
    assert(RunService:IsClient(), "client mover baseline installation is client-only")
    local v4 = {}
    for i in u15 do
        v4[i] = true
    end
    table.clear(u15)
    table.clear(u16)
    table.clear(u17)
    table.clear(u22)
    local v5 = nil
    local v6 = nil
    local v7 = a2
    for j, k in a1, v5, v6 do
        v2, v3 = u10.Validate(k)
        assert(v2, v3)
        v4[k.Id] = true
        if v7 == nil or Serial.deltaUInt32(v7, k.EffectiveTick) >= 0 then
            v1 = u15[k.Id]
            if v1 == nil or 0 <= (Serial.deltaUInt32(k.EffectiveTick, v1.EffectiveTick)) then
                u15[k.Id] = k
            end
        end
    end
    u18 = true
    if v7 ~= nil then
        for n in u15 do
            u17[n] = v7
        end
    end
    for m in v4 do
        BindableEvent:Fire(m)
    end
end

function u10.InstallClientSpeculativeDescriptor(a1) -- Line: 264
    -- upvalues: RunService (val), u18 (ref), u10 (val), u15 (val), u16 (val), BindableEvent (val)
    assert(RunService:IsClient(), "speculative mover descriptor installation is client-only")
    assert(u18, "speculative mover descriptor requires a baseline")
    local v1, v2 = u10.Validate(a1)
    assert(v1, v2)
    assert(u15[a1.Id] ~= nil, "speculative mover is absent from the reliable baseline")
    u16[a1.Id] = a1
    BindableEvent:Fire(a1.Id)
end

function u10.ClearClientSpeculativeDescriptor(a1) -- Line: 274
    -- upvalues: RunService (val), u16 (val), BindableEvent (val)
    assert(RunService:IsClient(), "speculative mover descriptor clearing is client-only")
    if u16[a1] == nil then
        return
    end
    u16[a1] = nil
    BindableEvent:Fire(a1)
end

function u10.InstallClientResolvedPose(a1, a2, a3, a4) -- Line: 284
    -- upvalues: RunService (val), u18 (ref), Serial (val), isFiniteCFrame (val), u22 (val), BindableEvent (val)
    local v1, v2
    assert(RunService:IsClient(), "client resolved mover pose installation is client-only")
    assert(u18, "client resolved mover pose requires a baseline")
    assert(Serial.isUInt32(a2), "client resolved mover pose tick must be a u32")
    assert(isFiniteCFrame(a3) and isFiniteCFrame(a4), "client resolved mover pose must be a finite CFrame")
    local v3 = u22[a1.Id]
    if v3 == nil then
        u22[a1.Id] = {
            Discontinuity = 0,
            Descriptor = a1,
            ServerTick = a2,
            PreviousPose = a3,
            Pose = a4,
        }
        return
    end
    local v4 = Serial.deltaUInt32(a2, v3.ServerTick)
    if v4 < 0 then
        return
    end
    if v4 ~= 0 then
        local Pose_2 = v3.Pose
        if a3 == Pose_2 then
            v1 = true
        elseif not (1e-05 < (a3.Position - Pose_2.Position).Magnitude) then
            _, v2 = a3.Rotation:ToObjectSpace(Pose_2.Rotation):ToAxisAngle()
            v1 = (math.abs(v2)) <= 1e-05
        else
            v1 = false
        end
    else
        local Pose = v3.Pose
        if a4 == Pose then
            v1 = true
        elseif not (1e-05 < (a4.Position - Pose.Position).Magnitude) then
            _, v2 = a4.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle()
            v1 = (math.abs(v2)) <= 1e-05
        else
            v1 = false
        end
        if v1 then
            local PreviousPose = v3.PreviousPose
            if a3 == PreviousPose then
                v1 = true
            elseif not (1e-05 < (a3.Position - PreviousPose.Position).Magnitude) then
                _, v2 = a3.Rotation:ToObjectSpace(PreviousPose.Rotation):ToAxisAngle()
                v1 = (math.abs(v2)) <= 1e-05
            else
                v1 = false
            end
        end
    end
    v3.Descriptor = a1
    v3.ServerTick = a2
    v3.PreviousPose = a3
    v3.Pose = a4
    if not v1 then
        v3.Discontinuity = v3.Discontinuity + 1
        BindableEvent:Fire(a1.Id)
    end
end

function u10.GetClientPresentation(a1) -- Line: 323 -- upvalues: RunService (val), u22 (val) -- types: a1: number
    if RunService:IsClient() then
        return u22[a1]
    end
    return nil
end

function u10.SetClientPresentationClock(a1, a2) -- Line: 328 -- upvalues: u23 (val) -- types: a1: number?, a2: number
    u23.ServerTick = a1
    u23.TickFraction = math.clamp(a2, 0, 1)
    u23.UpdatedAt = os.clock()
end

function u10.GetClientPresentationClock() -- Line: 334 -- upvalues: u23 (val)
    if 0.25 < os.clock() - u23.UpdatedAt then
        return nil, 0
    end
    return u23.ServerTick, u23.TickFraction
end

local function installClientResolved(a1, a2, a3) -- Line: 341
    -- upvalues: RunService (val), u18 (ref), Serial (val), u10 (val), u17 (val), u15 (val), u16 (val)
    -- upvalues: BindableEvent (val)
    local v1, v2, v3, v4, v5, v6
    assert(RunService:IsClient(), "client mover delta installation is client-only")
    assert(u18, "client mover delta requires a baseline")
    assert(Serial.isUInt32(a1), "client mover resolved tick must be a u32")
    local v7 = nil
    local v8 = nil
    local v9, v10 = a1, a3
    for i, j in a2, v7, v8 do
        v5, v6 = u10.Validate(j)
        assert(v5, v6)
        v1 = Serial.deltaUInt32(v9, j.EffectiveTick)
        if not (v1 < 0) then
            v1 = u17[j.Id]
            if v1 == nil then
                u17[j.Id] = v9
                v2 = u15[j.Id]
                if v2 == nil or v2.Revision ~= j.Revision then
                    u15[j.Id] = j
                    v3 = true
                    v4 = u16[j.Id]
                    if v4 ~= nil then
                        if not (0 <= (Serial.deltaUInt32(j.Revision, v4.Revision))) then
                            v3 = false
                        else
                            u16[j.Id] = nil
                        end
                    end
                    if v3 then
                        if v10 == nil then
                            BindableEvent:Fire(j.Id)
                        else
                            v10[j.Id] = true
                        end
                    end
                end
            else
                v2 = Serial.deltaUInt32(v9, v1)
                if not (v2 < 0) then
                    u17[j.Id] = v9
                    v2 = u15[j.Id]
                    if v2 == nil or v2.Revision ~= j.Revision then
                        u15[j.Id] = j
                        v3 = true
                        v4 = u16[j.Id]
                        if v4 ~= nil then
                            if not (0 <= (Serial.deltaUInt32(j.Revision, v4.Revision))) then
                                v3 = false
                            else
                                u16[j.Id] = nil
                            end
                        end
                        if v3 then
                            if v10 == nil then
                                BindableEvent:Fire(j.Id)
                            else
                                v10[j.Id] = true
                            end
                        end
                    end
                end
            end
        end
    end
end

function u10.InstallClientResolved(a1, a2) -- Line: 384
    -- upvalues: installClientResolved (val)
    installClientResolved(a1, a2, nil)
end

function u10.InstallClientDelta(a1, a2) -- Line: 388
    -- upvalues: installClientResolved (val), BindableEvent (val)
    local v1 = {}
    installClientResolved(a2, a1, v1)
    for i in v1 do
        BindableEvent:Fire(i)
    end
end

function u10.RetireClientDescriptors(a1) -- Line: 396
    -- upvalues: RunService (val), u15 (val), u16 (val), u17 (val), u22 (val), BindableEvent (val)
    assert(RunService:IsClient(), "client mover retirement is client-only")
    for i, j in a1 do
        if u15[j] ~= nil then
            u15[j] = nil
            u16[j] = nil
            u17[j] = nil
            u22[j] = nil
            BindableEvent:Fire(j)
        end
    end
end

function u10.ResetClientDescriptors() -- Line: 409
    -- upvalues: RunService (val), u15 (val), u16 (val), u17 (val), u22 (val), u18 (ref), BindableEvent (val)
    assert(RunService:IsClient(), "client mover reset is client-only")
    local v1 = {}
    for i in u15 do
        v1[#v1 + 1] = i
    end
    table.clear(u15)
    table.clear(u16)
    table.clear(u17)
    table.clear(u22)
    u18 = false
    for j, k in v1 do
        BindableEvent:Fire(k)
    end
end

function u10.Publish(a1, a2) -- Line: 425 -- upvalues: u10 (val) -- types: a1: userdata, a2: table
    local v1, v2 = u10.Validate(a2)
    assert(v1, v2)
    local Attributes = u10.Attributes
    a1:SetAttribute(Attributes.Revision, nil)
    a1:SetAttribute(Attributes.Id, a2.Id)
    a1:SetAttribute(Attributes.Size, a2.Size)
    a1:SetAttribute(Attributes.CollisionOffset, a2.CollisionOffset)
    a1:SetAttribute(Attributes.SurfaceFriction, a2.SurfaceFriction)
    a1:SetAttribute(Attributes.StartPose, a2.StartPose)
    a1:SetAttribute(Attributes.TargetPose, a2.TargetPose)
    a1:SetAttribute(Attributes.EffectiveTick, a2.EffectiveTick)
    a1:SetAttribute(Attributes.StartTick, a2.StartTick)
    a1:SetAttribute(Attributes.DurationTicks, a2.DurationTicks)
    a1:SetAttribute(Attributes.StartServerTime, a2.StartServerTime)
    a1:SetAttribute(Attributes.DurationSeconds, a2.DurationSeconds)
    a1:SetAttribute(Attributes.Moving, a2.Moving)
    a1:SetAttribute(Attributes.Active, a2.Active)
    a1:SetAttribute(Attributes.Behavior, a2.Behavior)
    a1:SetAttribute(Attributes.Revision, a2.Revision)
end

function u10.TickAlpha(a1, a2) -- Line: 448 -- upvalues: Serial (val) -- types: a1: table, a2: number
    if not a1.Moving then
        return 1
    end
    assert(Serial.isUInt32(a2), "mover endpoint tick must be a u32")
    return (math.clamp((Serial.deltaUInt32(a2, a1.StartTick) + 1) / a1.DurationTicks, 0, 1))
end

function u10.EvaluateTick(a1, a2) -- Line: 457 -- upvalues: u10 (val) -- types: a1: table, a2: number
    return u10.EvaluateProgress(a1, u10.QuantizeProgress(u10.TickAlpha(a1, a2)))
end

function u10.TimeAlpha(a1, a2) -- Line: 464 -- types: a1: table, a2: number
    if not a1.Moving then
        return 1
    end
    local v1 = false
    if typeof(a2) == "number" then
        v1 = false
        if a2 == a2 then
            v1 = false
            if a2 > (-1 / 0) then
                v1 = a2 < (1 / 0)
            end
        end
    end
    assert(v1, "mover presentation time must be finite")
    return (math.clamp((a2 - a1.StartServerTime) / a1.DurationSeconds, 0, 1))
end

function u10.EvaluateTime(a1, a2) -- Line: 472 -- upvalues: u10 (val) -- types: a1: table, a2: number
    return a1.StartPose:Lerp(a1.TargetPose, (u10.TimeAlpha(a1, a2)))
end

function u10.PresentationMoving(a1, a2) -- Line: 476
    -- upvalues: RunService (val), u16 (val), u10 (val)
    local v1 = false
    if typeof(a2) == "number" then
        v1 = false
        if a2 == a2 then
            v1 = false
            if a2 > (-1 / 0) then
                v1 = a2 < (1 / 0)
            end
        end
    end
    assert(v1, "mover presentation time must be finite")
    if RunService:IsClient() then
        local v2 = u16[a1.Id]
        if v2 ~= nil and v2.Revision == a1.Revision then
            return true
        end
    end
    return a1.Moving and (u10.TimeAlpha(a1, a2)) < 1
end

function u10.CollisionPose(a1, a2) -- Line: 488 -- types: a1: table, a2: userdata
    return a2 * a1.CollisionOffset
end

return (table.freeze(u10))