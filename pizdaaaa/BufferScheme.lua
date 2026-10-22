-- ReplicatedStorage.Shared.Utility.BufferScheme
-- Script path: ReplicatedStorage.Shared.Utility.BufferScheme
-- Decompile time: 13.65 ms

-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
local script_Writer = require(script.Writer);
local script_Reader = require(script.Reader);
local script_Sizes = require(script.Sizes);
local script_Specialized = require(script.Specialized);
local buffer_create_ret = buffer.create(6);
local u1 = {};
local u2 = {};
local u3 = {};

for _, v in { "half", "half3", "unorm8", "angle16", "fixed16_128", "fixed16_128_3" } do
    local u4 = script_Writer[v];
    local u5 = script_Reader[v];

    u1[v] = function(p6) -- Line: 32
        -- upvalues: u4 (copy), buffer_create_ret (copy), u5 (copy)
        u4(buffer_create_ret, 0, p6);

        return u5(buffer_create_ret, 0);
    end;
end;

local function WriteBooleanBitmask(p7, p8, p9, p10) -- Line: 39
    local BooleanKeys = p7.BooleanKeys;
    local BooleanMasks = p7.BooleanMasks;

    for _, v in p7.BooleanGroups do
        local v11 = 0;

        for i = v[1], v[2] do
            local v12;

            if p9[BooleanKeys[i]] == true then
                v11 = bit32.bor(v11, BooleanMasks[i]);
                v12 = i;
            else
                v12 = i;
            end;
        end;

        buffer.writeu8(p8, p10, v11);
        p10 = p10 + 1;
    end;

    return p10;
end;

local function WriteBooleanBitmaskDelta(p13, p14, p15, p16, p17) -- Line: 61
    local BooleanKeys = p13.BooleanKeys;
    local BooleanMasks = p13.BooleanMasks;
    local v18 = false;

    for _, v in p13.BooleanGroups do
        local v19 = 0;

        for i = v[1], v[2] do
            local v20 = BooleanKeys[i];
            local v21 = p16[v20];

            if v21 == true then
                v19 = bit32.bor(v19, BooleanMasks[i]);
            end;

            local v22;

            if v21 == nil or p15[v20] == v21 then
                v22 = i;
            else
                v22 = i;
                v18 = true;
            end;
        end;

        buffer.writeu8(p14, p17, v19);
        p17 = p17 + 1;
    end;

    return p17, v18;
end;

local function WriteFieldsWithPresence(p23, p24, p25, p26) -- Line: 89
    local v27 = p26 + p23.PresenceBytes;
    local Enums = p23.Enums;
    local EnumWriters = p23.EnumWriters;
    local FieldMasks = p23.FieldMasks;

    for i, v in p23.FieldGroups do
        local v28 = 0;

        for i2 = v[1], v[2] do
            local v29 = p25[Enums[i2]];
            local v30;

            if v29 == nil then
                v30 = i2;
            else
                v28 = bit32.bor(v28, FieldMasks[i2]);
                v27 = EnumWriters[i2](p24, v27, v29);
                v30 = i2;
            end;
        end;

        buffer.writeu8(p24, p26 + i - 1, v28);
    end;

    return v27;
end;

local function WriteDeltaFieldsWithPresence(p31, p32, p33, p34, p35) -- Line: 122
    local v36 = p35 + p31.PresenceBytes;
    local Enums = p31.Enums;
    local EnumWriters = p31.EnumWriters;
    local TrackedFields = p31.TrackedFields;
    local FieldMasks = p31.FieldMasks;
    local v37 = false;

    for i, v in p31.FieldGroups do
        local v38 = 0;

        for i2 = v[1], v[2] do
            local v39 = Enums[i2];
            local v40 = p34[v39];
            local v41;

            if v40 == nil then
                v41 = i2;
            else
                local v42 = p33[v39];

                if v42 == v40 then
                    v41 = i2;
                else
                    v37 = (v42 == nil or TrackedFields[i2]) and true or v37;
                    v38 = bit32.bor(v38, FieldMasks[i2]);
                    v36 = EnumWriters[i2](p32, v36, v40);
                    v41 = i2;
                end;
            end;
        end;

        buffer.writeu8(p32, p35 + i - 1, v38);
    end;

    return v36, v37;
end;

local function GetScratchBuffer(p43, p44) -- Line: 164
    local Size = p43.Size;

    for _, v in p43.StringFields do
        local v45 = p44[v];

        if v45 ~= nil then
            local v46;

            if typeof(v45) == "string" then
                v46 = #v45;
            else
                v46 = #tostring(v45);
            end;

            local v47 = `[BufferScheme] {v} exceeds u16 length`;
            assert(v46 <= 65535, v47);
            Size = Size + v46;
        end;
    end;

    if buffer.len(p43.ScratchBuffer) < Size then
        p43.ScratchBuffer = buffer.create(Size);
    end;

    return p43.ScratchBuffer;
end;

local function PrepareBooleanMasks(p48, p49, p50) -- Line: 195
    local v51 = p50 or {
        Truth = {},
        Presence = {}
    };
    v51.Scheme = p48;
    v51.Valid = true;
    local BooleanKeys = p48.BooleanKeys;
    local BooleanMasks = p48.BooleanMasks;

    for i, v in p48.BooleanGroups do
        local v52 = i;
        local v53 = 0;
        local v54 = 0;

        for i2 = v[1], v[2] do
            local v55 = p49[BooleanKeys[i2]];
            local v56 = BooleanMasks[i2];
            local v57;

            if v55 == nil then
                v57 = i2;
            else
                v53 = bit32.bor(v53, v56);

                if v55 == true then
                    v54 = bit32.bor(v54, v56);
                    v57 = i2;
                elseif v55 == false then
                    v57 = i2;
                else
                    v51.Valid = false;
                    v57 = i2;
                end;
            end;
        end;

        local Presence = v51.Presence;
        v51.Truth[v52] = v54;
        Presence[v52] = v53;
    end;

    return v51;
end;

local function WritePreparedBooleans(p58, p59, p60, p61) -- Line: 215
    local v62 = false;

    for i = 1, p58.BoolBytes do
        local v63 = p61.Truth[i];
        local v64 = p61.Presence[i];
        buffer.writeu8(p59, i - 1, v63);
        local v65;

        if p60 then
            local bit32_bnot_ret = bit32.bnot(p60.Presence[i]);
            local bit32_bxor_ret = bit32.bxor(p60.Truth[i], v63);
            local bit32_bor_ret = bit32.bor(bit32_bnot_ret, bit32_bxor_ret);

            if bit32.band(v64, bit32_bor_ret) == 0 then
                v65 = i;
            else
                v65 = i;
                v62 = true;
            end;
        else
            v65 = i;
        end;
    end;

    return p58.BoolBytes, v62;
end;

local function PackScheme(p66, p67, p68) -- Line: 227
    -- upvalues: GetScratchBuffer (copy), WriteBooleanBitmask (copy)
    if not p67 then
        return nil;
    end;

    local v69 = GetScratchBuffer(p66, p67);
    local v70 = 0;
    local v71;

    if p68 and (p68.Scheme == p66 and p68.Valid) then
        for i = 1, p66.BoolBytes do
            local _ = p68.Presence[i];
            buffer.writeu8(v69, i - 1, p68.Truth[i]);
            local _ = i;
        end;

        v71 = p66.BoolBytes;
    else
        v71 = WriteBooleanBitmask(p66, v69, p67, v70);
    end;

    local v72 = p66.WriteFields(p66, v69, p67, v71);
    local buffer_create_ret2 = buffer.create(v72);
    buffer.copy(buffer_create_ret2, 0, v69, 0, v72);

    return buffer_create_ret2;
end;

local function PackDeltaScheme(p73, p74, p75, p76, p77) -- Line: 248
    -- upvalues: PackScheme (copy), GetScratchBuffer (copy), WritePreparedBooleans (copy), WriteBooleanBitmaskDelta (copy)
    if not p75 then
        return nil;
    end;

    if not (p74 and next(p74)) then
        return PackScheme(p73, p75, p77);
    end;

    local v78 = GetScratchBuffer(p73, p75);
    local v79 = 0;
    local v80, v81;

    if p76 and (p77 and (p76.Scheme == p73 and (p77.Scheme == p73 and (p76.Valid and p77.Valid)))) then
        v80, v81 = WritePreparedBooleans(p73, v78, p76, p77);
    else
        v80, v81 = WriteBooleanBitmaskDelta(p73, v78, p74, p75, v79);
    end;

    local v82, v83 = p73.WriteDeltaFields(p73, v78, p74, p75, v80);

    if not (v83 or v81) then
        return nil;
    end;

    local buffer_create_ret2 = buffer.create(v82);
    buffer.copy(buffer_create_ret2, 0, v78, 0, v82);

    return buffer_create_ret2;
end;

local function QuantizeState(p84, p85) -- Line: 288
    local LossyFields = p84.LossyFields;
    local LossyQuantizers = p84.LossyQuantizers;

    for i = 1, #LossyFields do
        local v86 = LossyFields[i];
        local v87 = p85[v86];
        local v88;

        if v87 == nil then
            v88 = i;
        else
            p85[v86] = LossyQuantizers[i](v87);
            v88 = i;
        end;
    end;

    return p85;
end;

local function UnpackScheme(p89, p90, p91) -- Line: 308
    if not p90 then
        return nil;
    end;

    local v92 = p91 or {};

    if p91 then
        table.clear(p91);
    end;

    local BooleanKeys = p89.BooleanKeys;
    local v93 = 0;

    for i = 1, p89.BoolBytes do
        local buffer_readu8_ret = buffer.readu8(p90, v93);
        v93 = v93 + 1;
        local v94 = i;

        for i2 = 0, 7 do
            local v95 = BooleanKeys[(v94 - 1) * 8 + i2 + 1];

            if not v95 then
                break;
            end;

            local bit32_rshift_ret = bit32.rshift(buffer_readu8_ret, i2);
            v92[v95] = bit32.band(bit32_rshift_ret, 1) == 1;
            local _ = i2;
        end;
    end;

    local v96 = v93 + p89.PresenceBytes;
    local Enums = p89.Enums;
    local EnumReaders = p89.EnumReaders;
    local NonBoolCount = p89.NonBoolCount;

    for i = 0, p89.PresenceBytes - 1 do
        local buffer_readu8_ret = buffer.readu8(p90, v93 + i);
        local v97;

        if buffer_readu8_ret == 0 then
            v97 = i;
        else
            local v98 = i * 8;
            v97 = i;

            for i2 = v98 + 1, math.min(v98 + 8, NonBoolCount) do
                if bit32.band(buffer_readu8_ret, 1) ~= 0 then
                    local v99 = Enums[i2];
                    local v100;
                    v100, v96 = EnumReaders[i2](p90, v96);
                    v92[v99] = v100;
                end;

                buffer_readu8_ret = bit32.rshift(buffer_readu8_ret, 1);
                local _ = i2;
            end;
        end;
    end;

    return v92;
end;

function u3.new(p101: string, p102: any, p103: table?) -- Line: 365
    -- upvalues: script_Sizes (copy), u1 (copy), script_Reader (copy), script_Writer (copy), script_Specialized (copy), WriteFieldsWithPresence (copy), WriteDeltaFieldsWithPresence (copy), PackScheme (copy), PackDeltaScheme (copy), UnpackScheme (copy), QuantizeState (copy), PrepareBooleanMasks (copy), u2 (copy)
    local v104 = {
        Scheme = p102
    };

    if p103 and #p103 > 0 then
        local v105 = {};

        for _, v in p103 do
            local v106 = p102[v];
            local v107 = `[BufferScheme] {p101} marks unknown field "{v}" untracked`;
            assert(v106, v107);
            local v108 = p102[v] ~= "boolean";
            local v109 = `[BufferScheme] {p101}.{v} is a boolean; the bitmask is written whole and cannot carry an untracked field`;
            assert(v108, v109);
            v105[v] = true;
        end;

        v104.Untracked = v105;
    end;

    v104.Enums = {};
    v104.SwappedEnums = {};
    v104.BooleanKeys = {};
    v104.StringFields = {};
    v104.LossyFields = {};
    v104.LossyQuantizers = {};
    v104.Size = 0;
    local v110 = 0;

    for i, v in p102 do
        if v == "boolean" then
            table.insert(v104.BooleanKeys, i);
        else
            v104.Size = v104.Size + script_Sizes[v];
            v110 = v110 + 1;

            if v == "string" then
                table.insert(v104.StringFields, i);
            end;

            local v111 = u1[v];

            if v111 then
                table.insert(v104.LossyFields, i);
                v104.LossyQuantizers[#v104.LossyFields] = v111;
            end;
        end;
    end;

    v104.BoolBytes = math.ceil(#v104.BooleanKeys / 8);
    v104.Size = v104.Size + v104.BoolBytes;
    v104.NonBoolCount = v110;
    v104.PresenceBytes = math.ceil(v110 / 8);
    v104.Size = v104.Size + v104.PresenceBytes;
    local v112 = 1;

    for i, v in v104.Scheme do
        if v ~= "boolean" then
            v104.Enums[v112] = i;
            v104.SwappedEnums[i] = v112;
            v112 = v112 + 1;
        end;
    end;

    v104.EnumReaders = {};
    v104.EnumWriters = {};
    v104.TrackedFields = {};

    for i, v in v104.Enums do
        local v113 = v104.Scheme[v];
        v104.EnumReaders[i] = script_Reader[v113];
        v104.EnumWriters[i] = script_Writer[v113];
        v104.TrackedFields[i] = not (v104.Untracked and v104.Untracked[v]);
    end;

    local function Groups(p114) -- Line: 445
        local v115 = {};
        local v116 = {};

        for i = 1, p114, 8 do
            local v117 = { i, (math.min(i + 7, p114)) };
            table.insert(v115, v117);
            local v118 = i;

            for i2 = i, math.min(i + 7, p114) do
                v116[i2] = bit32.lshift(1, i2 - v118);
                local _ = i2;
            end;
        end;

        return v115, v116;
    end;

    local v119, v120 = Groups(#v104.BooleanKeys);
    v104.BooleanGroups = v119;
    v104.BooleanMasks = v120;
    local v121, v122 = Groups(v110);
    v104.FieldGroups = v121;
    v104.FieldMasks = v122;
    local v123, v124 = script_Specialized.Bind(p101, v104, script_Writer);
    v104.WriteFields = v123;
    v104.WriteDeltaFields = v124;
    v104.Specialized = v104.WriteFields ~= nil;
    v104.WriteFields = v104.WriteFields or WriteFieldsWithPresence;
    v104.WriteDeltaFields = v104.WriteDeltaFields or WriteDeltaFieldsWithPresence;
    v104.ScratchBuffer = buffer.create(v104.Size);
    v104.ScratchUnpack = {};
    v104.PackScheme = PackScheme;
    v104.PackDeltaScheme = PackDeltaScheme;
    v104.UnpackScheme = UnpackScheme;
    v104.QuantizeState = QuantizeState;
    v104.PrepareBooleanMasks = PrepareBooleanMasks;
    u2[p101] = v104;

    return v104;
end;

function u3.PackSlots(p125: number, p126: number, p127: table) -- Line: 485
    local v128 = 3;

    for _, v in p127 do
        v128 = v128 + (3 + buffer.len(v));
    end;

    local buffer_create_ret2 = buffer.create(v128);
    buffer.writeu8(buffer_create_ret2, 0, p125);
    buffer.writeu16(buffer_create_ret2, 1, p126);
    local v129 = 3;

    for i, v in p127 do
        local buffer_len_ret = buffer.len(v);
        buffer.writeu8(buffer_create_ret2, v129, i);
        buffer.writeu16(buffer_create_ret2, v129 + 1, buffer_len_ret);
        buffer.copy(buffer_create_ret2, v129 + 3, v);
        v129 = v129 + (3 + buffer_len_ret);
    end;

    return buffer_create_ret2;
end;

function u3.UnpackSlots(p130: buffer) -- Line: 511
    local buffer_len_ret = buffer.len(p130);
    local v131 = 3;
    local v132 = {};

    while v131 < buffer_len_ret do
        local buffer_readu8_ret = buffer.readu8(p130, v131);
        local buffer_readu16_ret = buffer.readu16(p130, v131 + 1);
        local buffer_create_ret2 = buffer.create(buffer_readu16_ret);
        buffer.copy(buffer_create_ret2, 0, p130, v131 + 3, buffer_readu16_ret);
        v132[buffer_readu8_ret] = buffer_create_ret2;
        v131 = v131 + (buffer_readu16_ret + 3);
    end;

    return buffer.readu8(p130, 0), buffer.readu16(p130, 1), v132;
end;

function u3.GetScheme(p133: string) -- Line: 533
    -- upvalues: u2 (copy)
    return u2[p133];
end;

function u3.Init(p134) -- Line: 545
    -- upvalues: u3 (copy)
    u3.new("CharacterState", {
        LastDuck = "boolean",
        Ducking = "boolean",
        Ducked = "boolean",
        DuckFlag = "boolean",
        OnGround = "boolean",
        AirFrictionReduced = "boolean",
        WasGround = "boolean",
        DoJump = "boolean",
        WannaJump = "boolean",
        Climbing = "boolean",
        HasWalkMovedSinceLastJump = "boolean",
        IsWalking = "boolean",
        StepDownFrameSkip = "boolean",
        SkipMovementPhysics = "boolean",
        Planting = "boolean",
        Defusing = "boolean",
        DuckAmount = "float32",
        DuckSpeed = "float32",
        DuckCooldown = "float32",
        Stamina = "float32",
        StepUp = "float32",
        FallingVelocity = "float32",
        DefuseTimer = "float32",
        Position = "vector",
        Velocity = "vector",
        LadderNormal = "vector",
        LastFullCrouchPosition = "vector",
        ViewPunchAngle = "vector",
        AimPunchAngle = "vector",
        AimPunchAngleVel = "vector",
        Yaw = "u16",
        Pitch = "u16",
        Height = "u16",
        IgnoreLadderJumpTime = "u16",
        CameraOffset = "u8",
        CurrentFrame = "u8",
        PerfectBhopChain = "u8",
        ArmorValue = "u8",
        HasHelmet = "boolean",
        HitPoints = "u16",
        VelocityModifier = "float32",
        FlinchStack = "float32",
        PendingVelocityModifier = "float32",
        PendingVelocityModifierTicks = "u8",
        Speed = "float32",
        HasDefuseKit = "boolean"
    });
    u3.new(
        "WeaponState",
        {
            Equipping = "boolean",
            Reloading = "boolean",
            AmmoClip = "boolean",
            ShotgunShellLoaded = "boolean",
            Firing = "boolean",
            Inspecting = "boolean",
            Silencer = "boolean",
            SilencerAction = "boolean",
            SniperShotActive = "boolean",
            WannaShoot = "boolean",
            WaitForNoAttack = "boolean",
            NameEnum = "u8",
            Slot = "u8",
            Ammo = "u8",
            ReserveAmmo = "u8",
            Mode = "u8",
            BurstFireRemaining = "u8",
            ZoomLevel = "u8",
            SavedZoom = "u8",
            RandomSeed = "u16",
            Timer = "float32",
            AccuracyPenalty = "float32",
            RecoilIndex = "float32",
            EquipDelay = "float32",
            ReloadDelay = "float32",
            AmmoDelay = "float32",
            FireDelay = "float32",
            LastShotTime = "float32",
            InspectDelay = "float32",
            AltFunctionDelay = "float32",
            SilencerDelay = "float32",
            SniperUnscopeAt = "float32",
            NextPlant = "float32"
        }
    );
    u3.new(
        "CharacterWeaponInventoryData",
        {
            Reloading = "boolean",
            Firing = "boolean",
            Ammo = "u8",
            ReserveAmmo = "u8",
            Mode = "u8",
            ZoomLevel = "u8",
            Variant = "u8"
        }
    );
    u3.new(
        "CharacterWeaponData",
        {
            Reloading = "boolean",
            Firing = "boolean",
            Name = "u8",
            Slot = "u8",
            Skin = "u8",
            OwnerName = "string",
            NameTag = "string",
            Ammo = "u8",
            ReserveAmmo = "u8",
            Mode = "u8",
            ZoomLevel = "u8",
            Variant = "u8"
        }
    );
    u3.new(
        "EntityCharacter",
        {
            Position = "vector",
            Yaw = "angle16",
            Pitch = "angle16",
            BodyYaw = "angle16",
            Ducked = "boolean",
            Ducking = "boolean",
            OnGround = "boolean",
            Climbing = "boolean",
            LadderNormal = "half3",
            AnimationAlpha = "float32",
            AimPunchAngle = "half3",
            NoInterpParity = "u8",
            DisplayOffset = "fixed16_128",
            Health = "u16",
            LegDuck = "unorm8"
        },
        { "DisplayOffset" }
    );
    u3.new(
        "EntityDroppedWeapon",
        {
            Position = "vector",
            Yaw = "angle16",
            Pitch = "angle16",
            Roll = "angle16",
            Normal = "vector",
            InBuyZone = "u8",
            Mode = "u8",
            BlockedTeam = "u8",
            OnGround = "u8"
        }
    );
    u3.new(
        "SpectateState",
        {
            Position = "vector",
            Velocity = "vector",
            Yaw = "angle16",
            Pitch = "angle16",
            Roll = "angle16",
            Animation = "u8",
            AnimationAlpha = "unorm8",
            Inaccuracy = "half",
            AimPunchAngle = "half3"
        }
    );
    u3.new(
        "EntityBomb",
        {
            BlowTimer = "float32",
            Exploded = "boolean",
            Defusing = "u8",
            Defused = "boolean",
            DefuseTimer = "float32",
            NextDefuse = "float32"
        }
    );
end;

return u3;