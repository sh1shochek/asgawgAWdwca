-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Serial);
local RunService = game:GetService("RunService");
local u1 = {
    Tag = "MovementV2Mover",
    Attributes = table.freeze({
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
        Behavior = "MovementV2MoverBehavior"
    })
};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = false;
local BindableEvent = Instance.new("BindableEvent");
local u6 = {};
local u7 = {
    ServerTick = nil,
    TickFraction = 0,
    UpdatedAt = (-1 / 0)
};

local function posesMatch(p8, p9) -- Line: 77
    if p8 == p9 then
        return true;
    end;

    if (p8.Position - p9.Position).Magnitude > 0.00001 then
        return false;
    end;

    local _, v10 = p8.Rotation:ToObjectSpace(p9.Rotation):ToAxisAngle();

    return math.abs(v10) <= 0.00001;
end;

local function isFiniteNumber(p11) -- Line: 88
    local v12;

    if typeof(p11) == "number" and (p11 == p11 and p11 > (-1 / 0)) then
        v12 = p11 < (1 / 0);
    else
        v12 = false;
    end;

    return v12;
end;

local function isFiniteVector3(p13) -- Line: 92
    local v14;

    if typeof(p13) == "Vector3" then
        local X = p13.X;

        if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
            v14 = X < (1 / 0);
        else
            v14 = false;
        end;

        if v14 then
            local Y = p13.Y;

            if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                v14 = Y < (1 / 0);
            else
                v14 = false;
            end;

            if v14 then
                local Z = p13.Z;

                if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                    v14 = Z < (1 / 0);
                else
                    v14 = false;
                end;
            end;
        end;
    else
        v14 = false;
    end;

    return v14;
end;

local function isFiniteCFrame(p15) -- Line: 99
    if typeof(p15) ~= "CFrame" then
        return false;
    end;

    for _, v in { p15:GetComponents() } do
        local v16;

        if typeof(v) == "number" and (v == v and v > (-1 / 0)) then
            v16 = v < (1 / 0);
        else
            v16 = false;
        end;

        if not v16 then
            return false;
        end;
    end;

    return true;
end;

function u1.Validate(p17) -- Line: 111
    -- upvalues: Serial (copy), isFiniteCFrame (copy)
    if type(p17) ~= "table" then
        return false, "mover descriptor must be a table";
    end;

    if not Serial.isUInt32(p17.Id) or p17.Id == 0 then
        return false, "mover id must be a non-zero u32";
    end;

    local Size = p17.Size;
    local v18;

    if typeof(Size) == "Vector3" then
        local X = Size.X;

        if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
            v18 = X < (1 / 0);
        else
            v18 = false;
        end;

        if v18 then
            local Y = Size.Y;

            if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                v18 = Y < (1 / 0);
            else
                v18 = false;
            end;

            if v18 then
                local Z = Size.Z;

                if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                    v18 = Z < (1 / 0);
                else
                    v18 = false;
                end;
            end;
        end;
    else
        v18 = false;
    end;

    if not (v18 and (p17.Size.X > 0 and (p17.Size.Y > 0 and p17.Size.Z > 0))) then
        return false, "mover size must be a finite positive Vector3";
    end;

    if not isFiniteCFrame(p17.CollisionOffset) then
        return false, "mover collision offset must be a finite CFrame";
    end;

    local SurfaceFriction = p17.SurfaceFriction;
    local v19;

    if typeof(SurfaceFriction) == "number" and (SurfaceFriction == SurfaceFriction and SurfaceFriction > (-1 / 0)) then
        v19 = SurfaceFriction < (1 / 0);
    else
        v19 = false;
    end;

    if not v19 or p17.SurfaceFriction < 0 then
        return false, "mover surface friction must be finite and nonnegative";
    end;

    if not (isFiniteCFrame(p17.StartPose) and isFiniteCFrame(p17.TargetPose)) then
        return false, "mover trajectory poses must be finite CFrames";
    end;

    if not (Serial.isUInt32(p17.EffectiveTick) and Serial.isUInt32(p17.StartTick)) then
        return false, "mover trajectory start tick must be a u32";
    end;

    if p17.Moving then
        local v20 = Serial.deltaUInt32(p17.StartTick, p17.EffectiveTick);

        if v20 < 0 or v20 > 1 then
            return false, "moving descriptor effective tick must equal or immediately precede its start tick";
        end;
    elseif p17.EffectiveTick ~= p17.StartTick then
        return false, "stationary descriptor effective tick must equal its start tick";
    end;

    local DurationTicks = p17.DurationTicks;
    local v21;

    if typeof(DurationTicks) == "number" and (DurationTicks == DurationTicks and DurationTicks > (-1 / 0)) then
        v21 = DurationTicks < (1 / 0);
    else
        v21 = false;
    end;

    if not (v21 and (p17.DurationTicks % 1 == 0 and (p17.DurationTicks >= 0 and p17.DurationTicks < 2147483648))) then
        return false, "mover trajectory duration ticks are invalid";
    end;

    local StartServerTime = p17.StartServerTime;
    local v22;

    if typeof(StartServerTime) == "number" and (StartServerTime == StartServerTime and StartServerTime > (-1 / 0)) then
        v22 = StartServerTime < (1 / 0);
    else
        v22 = false;
    end;

    if not v22 or p17.StartServerTime < 0 then
        return false, "mover trajectory start server time is invalid";
    end;

    local DurationSeconds = p17.DurationSeconds;
    local v23;

    if typeof(DurationSeconds) == "number" and (DurationSeconds == DurationSeconds and DurationSeconds > (-1 / 0)) then
        v23 = DurationSeconds < (1 / 0);
    else
        v23 = false;
    end;

    if not v23 or p17.DurationSeconds < 0 then
        return false, "mover trajectory duration seconds are invalid";
    end;

    if typeof(p17.Moving) ~= "boolean" then
        return false, "mover trajectory moving flag must be boolean";
    end;

    if typeof(p17.Active) ~= "boolean" then
        return false, "mover trajectory active flag must be boolean";
    end;

    if p17.Moving and not p17.Active then
        return false, "an inactive mover trajectory cannot be moving";
    end;

    if p17.Behavior ~= "StopOnBlock" and p17.Behavior ~= "Pusher" then
        return false, "mover trajectory behavior is invalid";
    end;

    if not Serial.isUInt32(p17.Revision) or p17.Revision == 0 then
        return false, "mover trajectory revision must be a non-zero u32";
    end;

    if p17.Moving and (p17.DurationTicks < 1 or p17.DurationSeconds <= 0) then
        return false, "moving trajectory must have a positive tick and seconds duration";
    end;

    return true, nil;
end;

function u1.Read(p24: userdata) -- Line: 181
    -- upvalues: u1 (copy), RunService (copy), u5 (ref), Serial (copy), u3 (copy), u2 (copy)
    local Attributes = u1.Attributes;

    if RunService:IsClient() and u5 then
        local Attribute = p24:GetAttribute(Attributes.Id);

        if not Serial.isUInt32(Attribute) or Attribute == 0 then
            return nil, "mover root identity is unavailable";
        end;

        local v25 = u3[Attribute] or u2[Attribute];

        if v25 == nil then
            v25 = nil;
        end;

        return v25, "mover is absent from the reliable descriptor baseline";
    end;

    local Attribute = p24:GetAttribute(Attributes.Revision);

    if Attribute == nil then
        return nil, "mover trajectory is not committed";
    end;

    local v26 = {
        Id = p24:GetAttribute(Attributes.Id),
        Size = p24:GetAttribute(Attributes.Size),
        CollisionOffset = p24:GetAttribute(Attributes.CollisionOffset),
        SurfaceFriction = p24:GetAttribute(Attributes.SurfaceFriction),
        StartPose = p24:GetAttribute(Attributes.StartPose),
        TargetPose = p24:GetAttribute(Attributes.TargetPose),
        EffectiveTick = p24:GetAttribute(Attributes.EffectiveTick),
        StartTick = p24:GetAttribute(Attributes.StartTick),
        DurationTicks = p24:GetAttribute(Attributes.DurationTicks),
        StartServerTime = p24:GetAttribute(Attributes.StartServerTime),
        DurationSeconds = p24:GetAttribute(Attributes.DurationSeconds),
        Moving = p24:GetAttribute(Attributes.Moving),
        Active = p24:GetAttribute(Attributes.Active),
        Behavior = p24:GetAttribute(Attributes.Behavior),
        Revision = Attribute
    };
    local v27, v28 = u1.Validate(v26);

    if not v27 then
        v26 = nil;
    end;

    return v26, v28;
end;

u1.ClientDescriptorChanged = BindableEvent.Event;

function u1.EvaluateProgress(p29: table, p30: number) -- Line: 218
    local v31;

    if type(p30) == "number" and (p30 % 1 == 0 and p30 >= 0) then
        v31 = p30 <= 65535;
    else
        v31 = false;
    end;

    assert(v31, "mover progress must be a u16");

    return p29.StartPose:Lerp(p29.TargetPose, p30 / 65535);
end;

function u1.QuantizeProgress(p32: number) -- Line: 226
    local v33;

    if typeof(p32) == "number" and (p32 == p32 and p32 > (-1 / 0)) then
        v33 = p32 < (1 / 0);
    else
        v33 = false;
    end;

    assert(v33, "mover normalized progress must be finite");
    local v34 = math.clamp(p32, 0, 1) * 65535;

    return math.floor(v34);
end;

function u1.InstallClientBaseline(p35: table, p36: number?) -- Line: 232
    -- upvalues: RunService (copy), u2 (copy), u3 (copy), u4 (copy), u6 (copy), u1 (copy), Serial (copy), u5 (ref), BindableEvent (copy)
    local v37 = RunService:IsClient();
    assert(v37, "client mover baseline installation is client-only");
    local v38 = {};

    for i in u2 do
        v38[i] = true;
    end;

    table.clear(u2);
    table.clear(u3);
    table.clear(u4);
    table.clear(u6);

    for _, v in p35 do
        local v39, v40 = u1.Validate(v);
        assert(v39, v40);
        v38[v.Id] = true;

        if p36 == nil or Serial.deltaUInt32(p36, v.EffectiveTick) >= 0 then
            local v41 = u2[v.Id];

            if v41 == nil or Serial.deltaUInt32(v.EffectiveTick, v41.EffectiveTick) >= 0 then
                u2[v.Id] = v;
            end;
        end;
    end;

    u5 = true;

    if p36 ~= nil then
        for i in u2 do
            u4[i] = p36;
        end;
    end;

    for i in v38 do
        BindableEvent:Fire(i);
    end;
end;

function u1.InstallClientSpeculativeDescriptor(p42: table) -- Line: 264
    -- upvalues: RunService (copy), u5 (ref), u1 (copy), u2 (copy), u3 (copy), BindableEvent (copy)
    local v43 = RunService:IsClient();
    assert(v43, "speculative mover descriptor installation is client-only");
    assert(u5, "speculative mover descriptor requires a baseline");
    local v44, v45 = u1.Validate(p42);
    assert(v44, v45);
    assert(u2[p42.Id] ~= nil, "speculative mover is absent from the reliable baseline");
    u3[p42.Id] = p42;
    BindableEvent:Fire(p42.Id);
end;

function u1.ClearClientSpeculativeDescriptor(p46: number) -- Line: 274
    -- upvalues: RunService (copy), u3 (copy), BindableEvent (copy)
    local v47 = RunService:IsClient();
    assert(v47, "speculative mover descriptor clearing is client-only");

    if u3[p46] == nil then
        return;
    end;

    u3[p46] = nil;
    BindableEvent:Fire(p46);
end;

function u1.InstallClientResolvedPose(p48: table, p49: number, p50, p51) -- Line: 284
    -- upvalues: RunService (copy), u5 (ref), Serial (copy), isFiniteCFrame (copy), u6 (copy), BindableEvent (copy)
    local v52 = RunService:IsClient();
    assert(v52, "client resolved mover pose installation is client-only");
    assert(u5, "client resolved mover pose requires a baseline");
    local v53 = Serial.isUInt32(p49);
    assert(v53, "client resolved mover pose tick must be a u32");
    local v54 = isFiniteCFrame(p50) and isFiniteCFrame(p51);
    assert(v54, "client resolved mover pose must be a finite CFrame");
    local v55 = u6[p48.Id];

    if v55 == nil then
        u6[p48.Id] = {
            Discontinuity = 0,
            Descriptor = p48,
            ServerTick = p49,
            PreviousPose = p50,
            Pose = p51
        };

        return;
    end;

    local v56 = Serial.deltaUInt32(p49, v55.ServerTick);

    if v56 < 0 then
        return;
    end;

    local v57;

    if v56 == 0 then
        local Pose = v55.Pose;

        if p51 == Pose then
            v57 = true;
        elseif (p51.Position - Pose.Position).Magnitude > 0.00001 then
            v57 = false;
        else
            local _, v58 = p51.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle();
            v57 = math.abs(v58) <= 0.00001;
        end;

        if v57 then
            local PreviousPose = v55.PreviousPose;

            if p50 == PreviousPose then
                v57 = true;
            elseif (p50.Position - PreviousPose.Position).Magnitude > 0.00001 then
                v57 = false;
            else
                local _, v59 = p50.Rotation:ToObjectSpace(PreviousPose.Rotation):ToAxisAngle();
                v57 = math.abs(v59) <= 0.00001;
            end;
        end;
    else
        local Pose = v55.Pose;

        if p50 == Pose then
            v57 = true;
        elseif (p50.Position - Pose.Position).Magnitude > 0.00001 then
            v57 = false;
        else
            local _, v60 = p50.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle();
            v57 = math.abs(v60) <= 0.00001;
        end;
    end;

    v55.Descriptor = p48;
    v55.ServerTick = p49;
    v55.PreviousPose = p50;
    v55.Pose = p51;

    if not v57 then
        v55.Discontinuity = v55.Discontinuity + 1;
        BindableEvent:Fire(p48.Id);
    end;
end;

function u1.GetClientPresentation(p61: number) -- Line: 323
    -- upvalues: RunService (copy), u6 (copy)
    if RunService:IsClient() then
        return u6[p61];
    end;

    return nil;
end;

function u1.SetClientPresentationClock(p62: number?, p63: number) -- Line: 328
    -- upvalues: u7 (copy)
    u7.ServerTick = p62;
    u7.TickFraction = math.clamp(p63, 0, 1);
    u7.UpdatedAt = os.clock();
end;

function u1.GetClientPresentationClock() -- Line: 334
    -- upvalues: u7 (copy)
    if os.clock() - u7.UpdatedAt > 0.25 then
        return nil, 0;
    end;

    return u7.ServerTick, u7.TickFraction;
end;

local function installClientResolved(p64: number, p65: table, p66: table?) -- Line: 341
    -- upvalues: RunService (copy), u5 (ref), Serial (copy), u1 (copy), u4 (copy), u2 (copy), u3 (copy), BindableEvent (copy)
    local v67 = RunService:IsClient();
    assert(v67, "client mover delta installation is client-only");
    assert(u5, "client mover delta requires a baseline");
    local v68 = Serial.isUInt32(p64);
    assert(v68, "client mover resolved tick must be a u32");

    for _, v in p65 do
        local v69, v70 = u1.Validate(v);
        assert(v69, v70);

        if Serial.deltaUInt32(p64, v.EffectiveTick) >= 0 then
            local v71 = u4[v.Id];

            if v71 == nil or Serial.deltaUInt32(p64, v71) >= 0 then
                u4[v.Id] = p64;
                local v72 = u2[v.Id];

                if v72 == nil or v72.Revision ~= v.Revision then
                    u2[v.Id] = v;
                    local v73 = true;
                    local v74 = u3[v.Id];

                    if v74 ~= nil then
                        if Serial.deltaUInt32(v.Revision, v74.Revision) >= 0 then
                            u3[v.Id] = nil;
                        else
                            v73 = false;
                        end;
                    end;

                    if v73 then
                        if p66 == nil then
                            BindableEvent:Fire(v.Id);
                        else
                            p66[v.Id] = true;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.InstallClientResolved(p75: number, p76: table) -- Line: 384
    -- upvalues: installClientResolved (copy)
    installClientResolved(p75, p76, nil);
end;

function u1.InstallClientDelta(p77: table, p78: number) -- Line: 388
    -- upvalues: installClientResolved (copy), BindableEvent (copy)
    local v79 = {};
    installClientResolved(p78, p77, v79);

    for i in v79 do
        BindableEvent:Fire(i);
    end;
end;

function u1.RetireClientDescriptors(p80: table) -- Line: 396
    -- upvalues: RunService (copy), u2 (copy), u3 (copy), u4 (copy), u6 (copy), BindableEvent (copy)
    local v81 = RunService:IsClient();
    assert(v81, "client mover retirement is client-only");

    for _, v in p80 do
        if u2[v] ~= nil then
            u2[v] = nil;
            u3[v] = nil;
            u4[v] = nil;
            u6[v] = nil;
            BindableEvent:Fire(v);
        end;
    end;
end;

function u1.ResetClientDescriptors() -- Line: 409
    -- upvalues: RunService (copy), u2 (copy), u3 (copy), u4 (copy), u6 (copy), u5 (ref), BindableEvent (copy)
    local v82 = RunService:IsClient();
    assert(v82, "client mover reset is client-only");
    local v83 = {};

    for i in u2 do
        v83[#v83 + 1] = i;
    end;

    table.clear(u2);
    table.clear(u3);
    table.clear(u4);
    table.clear(u6);
    u5 = false;

    for _, v in v83 do
        BindableEvent:Fire(v);
    end;
end;

function u1.Publish(p84: userdata, p85: table) -- Line: 425
    -- upvalues: u1 (copy)
    local v86, v87 = u1.Validate(p85);
    assert(v86, v87);
    local Attributes = u1.Attributes;
    p84:SetAttribute(Attributes.Revision, nil);
    p84:SetAttribute(Attributes.Id, p85.Id);
    p84:SetAttribute(Attributes.Size, p85.Size);
    p84:SetAttribute(Attributes.CollisionOffset, p85.CollisionOffset);
    p84:SetAttribute(Attributes.SurfaceFriction, p85.SurfaceFriction);
    p84:SetAttribute(Attributes.StartPose, p85.StartPose);
    p84:SetAttribute(Attributes.TargetPose, p85.TargetPose);
    p84:SetAttribute(Attributes.EffectiveTick, p85.EffectiveTick);
    p84:SetAttribute(Attributes.StartTick, p85.StartTick);
    p84:SetAttribute(Attributes.DurationTicks, p85.DurationTicks);
    p84:SetAttribute(Attributes.StartServerTime, p85.StartServerTime);
    p84:SetAttribute(Attributes.DurationSeconds, p85.DurationSeconds);
    p84:SetAttribute(Attributes.Moving, p85.Moving);
    p84:SetAttribute(Attributes.Active, p85.Active);
    p84:SetAttribute(Attributes.Behavior, p85.Behavior);
    p84:SetAttribute(Attributes.Revision, p85.Revision);
end;

function u1.TickAlpha(p88: table, p89: number) -- Line: 448
    -- upvalues: Serial (copy)
    if not p88.Moving then
        return 1;
    end;

    local v90 = Serial.isUInt32(p89);
    assert(v90, "mover endpoint tick must be a u32");
    local v91 = (Serial.deltaUInt32(p89, p88.StartTick) + 1) / p88.DurationTicks;

    return math.clamp(v91, 0, 1);
end;

function u1.EvaluateTick(p92: table, p93: number) -- Line: 457
    -- upvalues: u1 (copy)
    return u1.EvaluateProgress(p92, u1.QuantizeProgress(u1.TickAlpha(p92, p93)));
end;

function u1.TimeAlpha(p94: table, p95: number) -- Line: 464
    if not p94.Moving then
        return 1;
    end;

    local v96;

    if typeof(p95) == "number" and (p95 == p95 and p95 > (-1 / 0)) then
        v96 = p95 < (1 / 0);
    else
        v96 = false;
    end;

    assert(v96, "mover presentation time must be finite");

    return math.clamp((p95 - p94.StartServerTime) / p94.DurationSeconds, 0, 1);
end;

function u1.EvaluateTime(p97: table, p98: number) -- Line: 472
    -- upvalues: u1 (copy)
    return p97.StartPose:Lerp(p97.TargetPose, u1.TimeAlpha(p97, p98));
end;

function u1.PresentationMoving(p99: table, p100: number) -- Line: 476
    -- upvalues: RunService (copy), u3 (copy), u1 (copy)
    local v101;

    if typeof(p100) == "number" and (p100 == p100 and p100 > (-1 / 0)) then
        v101 = p100 < (1 / 0);
    else
        v101 = false;
    end;

    assert(v101, "mover presentation time must be finite");

    if RunService:IsClient() then
        local v102 = u3[p99.Id];

        if v102 ~= nil and v102.Revision == p99.Revision then
            return true;
        end;
    end;

    local v103 = p99.Moving and u1.TimeAlpha(p99, p100) < 1;

    return v103;
end;

function u1.CollisionPose(p104: table, p105) -- Line: 488
    return p105 * p104.CollisionOffset;
end;

return table.freeze(u1);