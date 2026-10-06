-- Decompiled with Potassium's decompiler.

local CommandCodec = require(script.Parent.Parent.CommandCodec);
local Config = require(script.Parent.Parent.Config);
local Enums = require(script.Parent.Parent.Enums);
local Mapping = require(script.Parent.Parent.Mapping);
local Quantization = require(script.Parent.Parent.Quantization);
local Serial = require(script.Parent.Parent.Serial);
local StateCodec = require(script.Parent.Parent.StateCodec);
require(script.Parent.Parent.Types);
local State = require(script.Parent.Parent.Simulation.State);
local u1 = {};
u1.__index = u1;
u1.Dependency = table.freeze({
    Player = 1,
    Mover = 2,
    ValidMask = 3
});

local function slotIndex(p2: any, p3: number) -- Line: 51
    -- upvalues: Serial (copy)
    local _newestCommandNumber = p2._newestCommandNumber;

    return _newestCommandNumber == nil and 1 or (p2._newestSlotIndex - 1 + Serial.deltaUInt32(p3, _newestCommandNumber)) % p2._capacity + 1;
end;

local function copyStateInto(p4, p5) -- Line: 59
    p4.Position = p5.Position;
    p4.Velocity = p5.Velocity;
    p4.LookYaw = p5.LookYaw;
    p4.VerticalLook = p5.VerticalLook;
    p4.BaseMoveSpeed = p5.BaseMoveSpeed;
    p4.WeaponMoveSpeed = p5.WeaponMoveSpeed;
    p4.WeaponScopedMoveSpeed = p5.WeaponScopedMoveSpeed;
    p4.VelocityModifier = p5.VelocityModifier;
    p4.MovementTick = p5.MovementTick;
    p4.MovementMode = p5.MovementMode;
    p4.Stance = p5.Stance;
    p4.OnGround = p5.OnGround;
    p4.GroundNormal = p5.GroundNormal;
    p4.WallNormal = p5.WallNormal;
    p4.GroundSurfaceFriction = p5.GroundSurfaceFriction;
    p4.DuckAmount = p5.DuckAmount;
    p4.DuckTimeMsecs = p5.DuckTimeMsecs;
    p4.IsDucking = p5.IsDucking;
    p4.DuckSpeed = p5.DuckSpeed;
    p4.DuckCooldownSeconds = p5.DuckCooldownSeconds;
    p4.Stamina = p5.Stamina;
    p4.LastJumpCommandNumber = p5.LastJumpCommandNumber;
    p4.PreviousButtons = p5.PreviousButtons;
    p4.JumpBufferTicksRemaining = p5.JumpBufferTicksRemaining;
    p4.JumpHullActive = p5.JumpHullActive;
    p4.StuckStepTicks = p5.StuckStepTicks;
end;

local function copySupportInto(p6, p7) -- Line: 88
    p6.Kind = p7.Kind;
    p6.SourceId = p7.SourceId;
    p6.Anchor = p7.Anchor;
    p6.Velocity = p7.Velocity;
end;

local function newSlot() -- Line: 95
    -- upvalues: State (copy)
    return {
        Active = false,
        ServerTick = 0,
        TopologyRevision = 0,
        DependencyMask = 0,
        Command = {
            CommandNumber = 0,
            LookYaw = 0,
            VerticalLook = 0,
            Buttons = 0,
            WeaponSelectRequestId = nil,
            WeaponSelectIdentifier = nil,
            GrenadeThrowIdentifier = nil,
            GrenadeThrowAnimation = nil,
            PredictedBaseMoveSpeed = nil,
            PredictedWeaponMoveSpeed = nil,
            PredictedWeaponScopedMoveSpeed = nil,
            Move = Vector2.zero
        },
        PostState = State.new(Vector3.new(0, 0, 0)),
        PostSupport = State.noneSupport()
    };
end;

local function createSlots(p8: number) -- Line: 120
    -- upvalues: newSlot (copy)
    local table_create_ret = table.create(p8);

    for i = 1, p8 do
        table_create_ret[i] = newSlot();
        local _ = i;
    end;

    return table_create_ret;
end;

local function validateSupport(p9) -- Line: 128
    -- upvalues: Enums (copy), Serial (copy), Quantization (copy)
    if typeof(p9) ~= "table" then
        return false, "SupportNotTable";
    end;

    if type(p9.Kind) ~= "number" or (p9.Kind % 1 ~= 0 or (p9.Kind < Enums.SupportKind.None or p9.Kind > Enums.SupportKind.Max)) then
        return false, "InvalidSupportKind";
    end;

    if not Serial.isUInt32(p9.SourceId) then
        return false, "InvalidSupportSourceId";
    end;

    if p9.Kind == Enums.SupportKind.None ~= (p9.SourceId == 0) then
        return false, "InvalidEmptySupport";
    end;

    if Quantization.isFiniteVector3(p9.Anchor) and Quantization.isFiniteVector3(p9.Velocity) then
        return true, nil;
    end;

    return false, "InvalidSupportVector";
end;

local function validateStoredValues(p10: number, p11: any, p12: any, p13: number, p14: number) -- Line: 152
    -- upvalues: Serial (copy), u1 (copy), StateCodec (copy), validateSupport (copy)
    if not Serial.isUInt32(p10) then
        return false, "InvalidServerTick";
    end;

    if not Serial.isUInt32(p13) then
        return false, "InvalidTopologyRevision";
    end;

    if Serial.isUInt32(p14) then
        local bit32_bnot_ret = bit32.bnot(u1.Dependency.ValidMask);

        if bit32.band(p14, bit32_bnot_ret) == 0 then
            local v15, v16 = StateCodec.validate(p11);

            if not v15 then
                return false, v16;
            end;

            local v17, v18 = validateSupport(p12);

            if v17 then
                return true, nil;
            end;

            return false, v18;
        end;
    end;

    return false, "InvalidPredictionDependencyMask";
end;

local function writeSlot(p19: any, p20: any, p21: number, p22: any, p23: any, p24: number, p25: number) -- Line: 182
    -- upvalues: CommandCodec (copy), copyStateInto (copy)
    local v26, v27 = CommandCodec.canonicalizeCommandInto(p19.Command, p20.CommandNumber, p20);

    if v26 == nil then
        return false, v27;
    end;

    copyStateInto(p19.PostState, p22);
    local PostSupport = p19.PostSupport;
    PostSupport.Kind = p23.Kind;
    PostSupport.SourceId = p23.SourceId;
    PostSupport.Anchor = p23.Anchor;
    PostSupport.Velocity = p23.Velocity;
    p19.ServerTick = p21;
    p19.TopologyRevision = p24;
    p19.DependencyMask = p25;
    p19.Active = true;

    return true, nil;
end;

function u1.new(p28) -- Line: 204
    -- upvalues: Mapping (copy), Config (copy), newSlot (copy), u1 (copy)
    local v29, v30 = Mapping.validate(p28);
    assert(v29, v30 or "invalid command mapping");
    local PredictionReplayTicks = Config.derive(p28.SimulationHz).PredictionReplayTicks;
    local table_create_ret = table.create(PredictionReplayTicks);
    local v31 = {
        _count = 0,
        _newestSlotIndex = 1,
        _capacity = PredictionReplayTicks
    };

    for i = 1, PredictionReplayTicks do
        table_create_ret[i] = newSlot();
        local _ = i;
    end;

    v31._slots = table_create_ret;

    return setmetatable(v31, u1);
end;

function u1.clear(p32) -- Line: 216
    for _, v in p32._slots do
        v.Active = false;
    end;

    p32._count = 0;
    p32._newestCommandNumber = nil;
    p32._newestSlotIndex = 1;
end;

function u1.reset(p33, p34) -- Line: 225
    -- upvalues: Mapping (copy), Config (copy), newSlot (copy)
    local v35, v36 = Mapping.validate(p34);
    assert(v35, v36 or "invalid command mapping");
    local PredictionReplayTicks = Config.derive(p34.SimulationHz).PredictionReplayTicks;

    if PredictionReplayTicks ~= p33._capacity then
        p33._capacity = PredictionReplayTicks;
        local table_create_ret = table.create(PredictionReplayTicks);

        for i = 1, PredictionReplayTicks do
            table_create_ret[i] = newSlot();
            local _ = i;
        end;

        p33._slots = table_create_ret;
    end;

    p33:clear();
end;

function u1.isFull(p37) -- Line: 236
    return p37._count >= p37._capacity;
end;

function u1.count(p38) -- Line: 240
    return p38._count;
end;

function u1.capacity(p39) -- Line: 244
    return p39._capacity;
end;

function u1.newestCommandNumber(p40) -- Line: 248
    return p40._newestCommandNumber;
end;

function u1.get(p41: table, p42: number) -- Line: 252
    -- upvalues: Serial (copy)
    if not Serial.isUInt32(p42) then
        return nil;
    end;

    local _newestCommandNumber = p41._newestCommandNumber;
    local v43 = p41._slots[_newestCommandNumber == nil and 1 or (p41._newestSlotIndex - 1 + Serial.deltaUInt32(p42, _newestCommandNumber)) % p41._capacity + 1];

    if v43.Active and v43.Command.CommandNumber == p42 then
        return v43;
    end;

    return nil;
end;

function u1.anyEntryAtOrAfterServerTick(p44: table, p45: number, p46: function) -- Line: 263
    -- upvalues: Serial (copy)
    if not Serial.isUInt32(p45) then
        return false;
    end;

    for _, v in p44._slots do
        if v.Active and (Serial.deltaUInt32(v.ServerTick, p45) >= 0 and p46(v)) then
            return true;
        end;
    end;

    return false;
end;

function u1.push(p47: table, p48: any, p49: number, p50: any, p51: any, p52: number, p53: boolean?, p54: number?) -- Line: 275
    -- upvalues: CommandCodec (copy), validateStoredValues (copy), Serial (copy), copyStateInto (copy)
    local v55, v56 = CommandCodec.validateCommand(p48.CommandNumber, p48);

    if not v55 then
        return false, v56;
    end;

    local v57 = p54 or 0;
    local v58, v59 = validateStoredValues(p49, p50, p51, p52, v57);

    if not v58 then
        return false, v59;
    end;

    local _newestCommandNumber = p47._newestCommandNumber;

    if _newestCommandNumber ~= nil then
        local v60 = Serial.deltaUInt32(p48.CommandNumber, _newestCommandNumber);

        if v60 < 0 then
            return false, "CommandOlderThanTail";
        end;

        if v60 > 1 then
            return false, "NonSequentialCommand";
        end;
    end;

    local _newestCommandNumber2 = p47._newestCommandNumber;
    local v61 = _newestCommandNumber2 == nil and 1 or (p47._newestSlotIndex - 1 + Serial.deltaUInt32(p48.CommandNumber, _newestCommandNumber2)) % p47._capacity + 1;
    local v62 = p47._slots[v61];

    if v62.Active and (v62.Command.CommandNumber ~= p48.CommandNumber and (p53 ~= true or Serial.deltaUInt32(p48.CommandNumber, v62.Command.CommandNumber) ~= p47._capacity)) then
        return false, "PredictionHistoryOverflow";
    end;

    if not v62.Active then
        p47._count = p47._count + 1;
    end;

    local v63, v64 = CommandCodec.canonicalizeCommandInto(v62.Command, p48.CommandNumber, p48);
    local v65;

    if v63 == nil then
        v65 = false;
    else
        copyStateInto(v62.PostState, p50);
        local PostSupport = v62.PostSupport;
        PostSupport.Kind = p51.Kind;
        PostSupport.SourceId = p51.SourceId;
        PostSupport.Anchor = p51.Anchor;
        PostSupport.Velocity = p51.Velocity;
        v62.ServerTick = p49;
        v62.TopologyRevision = p52;
        v62.DependencyMask = v57;
        v62.Active = true;
        v65 = true;
        v64 = nil;
    end;

    if not v65 then
        return false, v64;
    end;

    if _newestCommandNumber == nil or Serial.isNewerUInt32(p48.CommandNumber, _newestCommandNumber) then
        p47._newestCommandNumber = p48.CommandNumber;
        p47._newestSlotIndex = v61;
    end;

    return true, nil;
end;

function u1.replacePrediction(p66: table, p67: number, p68: number, p69: any, p70: any, p71: number, p72: number?) -- Line: 331
    -- upvalues: Serial (copy), validateStoredValues (copy), copyStateInto (copy)
    if not Serial.isUInt32(p67) then
        return false, "InvalidCommandNumber";
    end;

    local _newestCommandNumber = p66._newestCommandNumber;
    local v73 = p66._slots[_newestCommandNumber == nil and 1 or (p66._newestSlotIndex - 1 + Serial.deltaUInt32(p67, _newestCommandNumber)) % p66._capacity + 1];

    if not v73.Active or v73.Command.CommandNumber ~= p67 then
        return false, "CommandNotBuffered";
    end;

    local v74 = p72 or v73.DependencyMask;
    local v75, v76 = validateStoredValues(p68, p69, p70, p71, v74);

    if not v75 then
        return false, v76;
    end;

    copyStateInto(v73.PostState, p69);
    local PostSupport = v73.PostSupport;
    PostSupport.Kind = p70.Kind;
    PostSupport.SourceId = p70.SourceId;
    PostSupport.Anchor = p70.Anchor;
    PostSupport.Velocity = p70.Velocity;
    v73.ServerTick = p68;
    v73.TopologyRevision = p71;
    v73.DependencyMask = v74;

    return true, nil;
end;

function u1.entriesAfter(p77: table, p78: number, p79: table?) -- Line: 360
    -- upvalues: Serial (copy)
    local v80 = p79 or {};
    table.clear(v80);

    if not Serial.isUInt32(p78) then
        return v80;
    end;

    local _newestCommandNumber = p77._newestCommandNumber;

    if _newestCommandNumber == nil then
        return v80;
    end;

    local v81 = Serial.deltaUInt32(_newestCommandNumber, p78);
    local math_max_ret = math.max(v81, 0);

    for i = 1, math.min(math_max_ret, p77._capacity) do
        local v82 = p77:get(Serial.addUInt32(p78, i));

        if v82 == nil then
            break;
        end;

        v80[#v80 + 1] = v82;
        local _ = i;
    end;

    return v80;
end;

function u1.cloneEntry(p83: table) -- Line: 381
    -- upvalues: CommandCodec (copy), State (copy)
    local v84, v85 = CommandCodec.canonicalizeCommand(p83.Command.CommandNumber, p83.Command);
    assert(v84 ~= nil, v85 or "prediction entry command became invalid");

    return {
        Command = v84,
        ServerTick = p83.ServerTick,
        PostState = State.clone(p83.PostState),
        PostSupport = State.cloneSupport(p83.PostSupport),
        TopologyRevision = p83.TopologyRevision,
        DependencyMask = p83.DependencyMask
    };
end;

function u1.shiftServerTicksAfter(p86: table, p87: number, p88: number) -- Line: 394
    -- upvalues: Serial (copy)
    if not (Serial.isUInt32(p87) and (type(p88) == "number" and p88 % 1 == 0)) then
        return false, "InvalidPredictionTickShift";
    end;

    if math.abs(p88) > p86._capacity then
        return false, "PredictionTickShiftTooLarge";
    end;

    local _newestCommandNumber = p86._newestCommandNumber;

    if _newestCommandNumber == nil then
        return true, nil;
    end;

    local v89 = Serial.deltaUInt32(_newestCommandNumber, p87);
    local math_max_ret = math.max(v89, 0);

    for i = 1, math.min(math_max_ret, p86._capacity) do
        local v90 = p86:get(Serial.addUInt32(p87, i));

        if v90 == nil then
            return false, "PredictionHistoryGap";
        end;

        v90.ServerTick = Serial.addUInt32(v90.ServerTick, p88);
        local _ = i;
    end;

    return true, nil;
end;

function u1.dropThrough(p91: table, p92: number) -- Line: 416
    -- upvalues: Serial (copy)
    if not Serial.isUInt32(p92) then
        return 0;
    end;

    local v93 = 0;

    for _, v in p91._slots do
        if v.Active and Serial.deltaUInt32(v.Command.CommandNumber, p92) <= 0 then
            v.Active = false;
            p91._count = p91._count - 1;
            v93 = v93 + 1;
        end;
    end;

    if p91._count == 0 then
        p91._newestCommandNumber = nil;
    end;

    return v93;
end;

return table.freeze(u1);