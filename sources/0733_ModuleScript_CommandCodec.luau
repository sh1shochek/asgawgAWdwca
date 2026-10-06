-- Decompiled with Potassium's decompiler.

local Buttons = require(script.Parent.Buttons);
local Config = require(script.Parent.Config);
local Quantization = require(script.Parent.Quantization);
local Serial = require(script.Parent.Serial);
require(script.Parent.Types);
local u1 = {
    Version = 5,
    HeaderSize = 10,
    CommandSize = 6,
    MaxDeltaCommandSize = 7,
    MaxWeaponSelectionSize = 200
};

local function resolveConfig(p2) -- Line: 41
    -- upvalues: Config (copy)
    return p2 or Config.Default;
end;

function u1.validateCommand(p3, p4) -- Line: 45
    -- upvalues: Serial (copy), Quantization (copy), Buttons (copy)
    if not Serial.isUInt32(p3) then
        return false, "InvalidCommandNumber";
    end;

    if typeof(p4) ~= "table" then
        return false, "CommandNotTable";
    end;

    if not Quantization.isFiniteVector2(p4.Move) then
        return false, "InvalidMove";
    end;

    if not Quantization.isFinite(p4.LookYaw) then
        return false, "InvalidLookYaw";
    end;

    if not Quantization.isFinite(p4.VerticalLook) then
        return false, "InvalidVerticalLook";
    end;

    if not Buttons.isValid(p4.Buttons) then
        return false, "InvalidButtons";
    end;

    local WeaponSelectRequestId = p4.WeaponSelectRequestId;
    local WeaponSelectIdentifier = p4.WeaponSelectIdentifier;
    local GrenadeThrowIdentifier = p4.GrenadeThrowIdentifier;
    local GrenadeThrowAnimation = p4.GrenadeThrowAnimation;

    if WeaponSelectRequestId ~= nil or (WeaponSelectIdentifier ~= nil or (GrenadeThrowIdentifier ~= nil or GrenadeThrowAnimation ~= nil)) then
        if not (Serial.isUInt32(WeaponSelectRequestId) and (WeaponSelectRequestId ~= 0 and (typeof(WeaponSelectIdentifier) == "string" and #WeaponSelectIdentifier <= 96))) then
            return false, "InvalidWeaponSelection";
        end;

        if GrenadeThrowIdentifier ~= nil and true or GrenadeThrowAnimation ~= nil then
            if type(GrenadeThrowIdentifier) ~= "string" or (#GrenadeThrowIdentifier < 1 or (#GrenadeThrowIdentifier > 96 or GrenadeThrowAnimation ~= "Far" and GrenadeThrowAnimation ~= "Near")) then
                return false, "InvalidGrenadeThrowSelection";
            end;
        elseif #WeaponSelectIdentifier < 1 then
            return false, "InvalidWeaponSelection";
        end;
    end;

    return true, nil;
end;

function u1.canonicalizeCommandInto(p5, p6, p7) -- Line: 94
    -- upvalues: u1 (copy), Quantization (copy)
    if typeof(p5) ~= "table" or table.isfrozen(p5) then
        return nil, "InvalidCanonicalCommandTarget";
    end;

    local v8, v9 = u1.validateCommand(p6, p7);

    if not v8 then
        return nil, v9;
    end;

    local v10 = Quantization.canonicalMove(p7.Move);
    local v11 = Quantization.quantizeSignedUnit(v10.X);
    local v12 = Quantization.quantizeSignedUnit(v10.Y);
    local Vector2_new_ret = Vector2.new(Quantization.dequantizeSignedUnit(v11), Quantization.dequantizeSignedUnit(v12));
    local v13 = Quantization.canonicalMove(Vector2_new_ret);
    p5.CommandNumber = p6;
    p5.Move = v13;
    p5.LookYaw = Quantization.dequantizeYaw(Quantization.quantizeYaw(p7.LookYaw));
    p5.VerticalLook = Quantization.dequantizeSignedUnit(Quantization.quantizeSignedUnit(p7.VerticalLook));
    p5.Buttons = p7.Buttons;
    p5.WeaponSelectRequestId = p7.WeaponSelectRequestId;
    p5.WeaponSelectIdentifier = p7.WeaponSelectIdentifier;
    p5.GrenadeThrowIdentifier = p7.GrenadeThrowIdentifier;
    p5.GrenadeThrowAnimation = p7.GrenadeThrowAnimation;
    p5.PredictedBaseMoveSpeed = p7.PredictedBaseMoveSpeed;
    p5.PredictedWeaponMoveSpeed = p7.PredictedWeaponMoveSpeed;
    p5.PredictedWeaponScopedMoveSpeed = p7.PredictedWeaponScopedMoveSpeed;

    return p5, nil;
end;

function u1.canonicalizeCommand(p14, p15) -- Line: 125
    -- upvalues: u1 (copy)
    return u1.canonicalizeCommandInto({}, p14, p15);
end;

function u1.validatePacket(p16, p17) -- Line: 129
    -- upvalues: Config (copy), Serial (copy), u1 (copy)
    local v18 = p17 or Config.Default;

    if typeof(p16) ~= "table" then
        return false, "PacketNotTable";
    end;

    if not Serial.isNonZeroUInt16(p16.Generation) then
        return false, "InvalidGeneration";
    end;

    if not Serial.isUInt32(p16.FirstCommandNumber) then
        return false, "InvalidFirstCommandNumber";
    end;

    if typeof(p16.RedundantCommandCount) ~= "number" or (p16.RedundantCommandCount % 1 ~= 0 or (p16.RedundantCommandCount < 0 or p16.RedundantCommandCount > v18.TargetRedundantCommandCount)) then
        return false, "InvalidRedundantCommandCount";
    end;

    if typeof(p16.NewCommandCount) ~= "number" or (p16.NewCommandCount % 1 ~= 0 or (p16.NewCommandCount < 1 or p16.NewCommandCount > v18.MaxNewCommandsPerPacket)) then
        return false, "InvalidNewCommandCount";
    end;

    if typeof(p16.Commands) ~= "table" then
        return false, "CommandsNotTable";
    end;

    local v19 = p16.RedundantCommandCount + p16.NewCommandCount;

    if v19 ~= #p16.Commands or (v18.MaxCommandsPerPacket < v19 or v19 > 255) then
        return false, "CommandCountMismatch";
    end;

    for i = 1, v19 do
        local v20 = Serial.addUInt32(p16.FirstCommandNumber, i - 1);
        local v21 = p16.Commands[i];

        if typeof(v21) ~= "table" or v21.CommandNumber ~= v20 then
            return false, "NonSequentialCommands";
        end;

        local v22, v23 = u1.validateCommand(v20, v21);

        if not v22 then
            return false, v23;
        end;

        local _ = i;
    end;

    return true, nil;
end;

function u1.makePacket(p24, p25, p26, p27) -- Line: 180
    -- upvalues: Serial (copy), u1 (copy)
    if typeof(p25) ~= "table" or #p25 == 0 then
        return nil, "CommandsNotTable";
    end;

    if typeof(p26) ~= "number" or p26 % 1 ~= 0 then
        return nil, "InvalidNewCommandCount";
    end;

    local v28 = p25[1];

    if typeof(v28) ~= "table" or not Serial.isUInt32(v28.CommandNumber) then
        return nil, "InvalidFirstCommandNumber";
    end;

    local v29 = {
        Generation = p24,
        FirstCommandNumber = v28.CommandNumber,
        RedundantCommandCount = #p25 - p26,
        NewCommandCount = p26,
        Commands = p25
    };
    local v30, v31 = u1.validatePacket(v29, p27);

    if v30 then
        return v29, nil;
    end;

    return nil, v31;
end;

local function commandFields(p32) -- Line: 211
    -- upvalues: Quantization (copy)
    local v33 = Quantization.canonicalMove(p32.Move);

    return Quantization.quantizeSignedUnit(v33.X), Quantization.quantizeSignedUnit(v33.Y), Quantization.quantizeYaw(p32.LookYaw), Quantization.quantizeSignedUnit(p32.VerticalLook), p32.Buttons;
end;

local function changedFieldMask(p34: number, p35: number, p36: number, p37: number, p38: number, p39: number, p40: number, p41: number, p42: number, p43: number) -- Line: 220
    local v44 = 0;

    if p34 ~= p39 then
        v44 = bit32.bor(v44, 1);
    end;

    if p35 ~= p40 then
        v44 = bit32.bor(v44, 2);
    end;

    if p36 ~= p41 then
        v44 = bit32.bor(v44, 4);
    end;

    if p37 ~= p42 then
        v44 = bit32.bor(v44, 8);
    end;

    if p38 ~= p43 then
        v44 = bit32.bor(v44, 16);
    end;

    return v44;
end;

local function changedFieldWireSize(p45: number) -- Line: 251
    local v46 = 0;

    if bit32.band(p45, 1) ~= 0 then
        v46 = v46 + 1;
    end;

    if bit32.band(p45, 2) ~= 0 then
        v46 = v46 + 1;
    end;

    if bit32.band(p45, 4) ~= 0 then
        v46 = v46 + 2;
    end;

    if bit32.band(p45, 8) ~= 0 then
        v46 = v46 + 1;
    end;

    if bit32.band(p45, 16) ~= 0 then
        v46 = v46 + 1;
    end;

    return v46;
end;

local function writeFullCommand(p47: buffer, p48: number, p49: number, p50: number, p51: number, p52: number, p53: number) -- Line: 271
    buffer.writei8(p47, p48, p49);
    buffer.writei8(p47, p48 + 1, p50);
    buffer.writeu16(p47, p48 + 2, p51);
    buffer.writei8(p47, p48 + 4, p52);
    buffer.writeu8(p47, p48 + 5, p53);

    return p48 + 6;
end;

local function writeChangedFields(p54: buffer, p55: number, p56: number, p57: number, p58: number, p59: number, p60: number, p61: number) -- Line: 288
    if bit32.band(p56, 1) ~= 0 then
        buffer.writei8(p54, p55, p57);
        p55 = p55 + 1;
    end;

    if bit32.band(p56, 2) ~= 0 then
        buffer.writei8(p54, p55, p58);
        p55 = p55 + 1;
    end;

    if bit32.band(p56, 4) ~= 0 then
        buffer.writeu16(p54, p55, p59);
        p55 = p55 + 2;
    end;

    if bit32.band(p56, 8) ~= 0 then
        buffer.writei8(p54, p55, p60);
        p55 = p55 + 1;
    end;

    if bit32.band(p56, 16) ~= 0 then
        buffer.writeu8(p54, p55, p61);
        p55 = p55 + 1;
    end;

    return p55;
end;

function u1.encode(p62, p63) -- Line: 321
    -- upvalues: u1 (copy), Quantization (copy), writeChangedFields (copy)
    local v64, v65 = u1.validatePacket(p62, p63);

    if not v64 then
        return nil, v65;
    end;

    local v66 = p62.RedundantCommandCount + p62.NewCommandCount;
    local v67 = p62.Commands[1];
    local v68 = Quantization.canonicalMove(v67.Move);
    local v69 = Quantization.quantizeSignedUnit(v68.X);
    local v70 = Quantization.quantizeSignedUnit(v68.Y);
    local v71 = Quantization.quantizeYaw(v67.LookYaw);
    local v72 = Quantization.quantizeSignedUnit(v67.VerticalLook);
    local Buttons2 = v67.Buttons;
    local v73 = 16;
    local v74 = 0;

    for i = 2, v66 do
        local v75 = p62.Commands[i];
        local v76 = Quantization.canonicalMove(v75.Move);
        local v77 = Quantization.quantizeSignedUnit(v76.X);
        local v78 = Quantization.quantizeSignedUnit(v76.Y);
        local v79 = Quantization.quantizeYaw(v75.LookYaw);
        local v80 = Quantization.quantizeSignedUnit(v75.VerticalLook);
        local Buttons3 = v75.Buttons;
        local v81 = 0;

        if v77 ~= v69 then
            v81 = bit32.bor(v81, 1);
        end;

        if v78 ~= v70 then
            v81 = bit32.bor(v81, 2);
        end;

        if v79 ~= v71 then
            v81 = bit32.bor(v81, 4);
        end;

        if v80 ~= v72 then
            v81 = bit32.bor(v81, 8);
        end;

        if Buttons3 ~= Buttons2 then
            v81 = bit32.bor(v81, 16);
        end;

        local v82 = 0;

        if bit32.band(v81, 1) ~= 0 then
            v82 = v82 + 1;
        end;

        if bit32.band(v81, 2) ~= 0 then
            v82 = v82 + 1;
        end;

        if bit32.band(v81, 4) ~= 0 then
            v82 = v82 + 2;
        end;

        if bit32.band(v81, 8) ~= 0 then
            v82 = v82 + 1;
        end;

        if bit32.band(v81, 16) ~= 0 then
            v82 = v82 + 1;
        end;

        v73 = v73 + (v82 + 1);
        v71 = v79;
        v72 = v80;
        Buttons2 = Buttons3;
        v70 = v78;
        v69 = v77;
        local _ = i;
    end;

    for _, v in p62.Commands do
        local WeaponSelectIdentifier = v.WeaponSelectIdentifier;

        if WeaponSelectIdentifier ~= nil then
            local GrenadeThrowIdentifier = v.GrenadeThrowIdentifier;
            v74 = v74 + 1;
            v73 = v73 + (#WeaponSelectIdentifier + 8 + (GrenadeThrowIdentifier == nil and 0 or #GrenadeThrowIdentifier));
        end;
    end;

    local buffer_create_ret = buffer.create(v73);
    buffer.writeu8(buffer_create_ret, 0, 5);
    buffer.writeu16(buffer_create_ret, 1, p62.Generation);
    buffer.writeu32(buffer_create_ret, 3, p62.FirstCommandNumber);
    buffer.writeu8(buffer_create_ret, 7, p62.NewCommandCount);
    buffer.writeu8(buffer_create_ret, 8, p62.RedundantCommandCount);
    buffer.writeu8(buffer_create_ret, 9, v74);
    local v83 = p62.Commands[1];
    local v84 = Quantization.canonicalMove(v83.Move);
    local v85 = Quantization.quantizeSignedUnit(v84.X);
    local v86 = Quantization.quantizeSignedUnit(v84.Y);
    local v87 = Quantization.quantizeYaw(v83.LookYaw);
    local v88 = Quantization.quantizeSignedUnit(v83.VerticalLook);
    local Buttons3 = v83.Buttons;
    buffer.writei8(buffer_create_ret, 10, v85);
    buffer.writei8(buffer_create_ret, 11, v86);
    buffer.writeu16(buffer_create_ret, 12, v87);
    buffer.writei8(buffer_create_ret, 14, v88);
    buffer.writeu8(buffer_create_ret, 15, Buttons3);
    local v89 = 16;

    for i = 2, v66 do
        local v90 = p62.Commands[i];
        local v91 = Quantization.canonicalMove(v90.Move);
        local v92 = Quantization.quantizeSignedUnit(v91.X);
        local v93 = Quantization.quantizeSignedUnit(v91.Y);
        local v94 = Quantization.quantizeYaw(v90.LookYaw);
        local v95 = Quantization.quantizeSignedUnit(v90.VerticalLook);
        local Buttons4 = v90.Buttons;
        local v96 = 0;

        if v92 ~= v85 then
            v96 = bit32.bor(v96, 1);
        end;

        if v93 ~= v86 then
            v96 = bit32.bor(v96, 2);
        end;

        if v94 ~= v87 then
            v96 = bit32.bor(v96, 4);
        end;

        if v95 ~= v88 then
            v96 = bit32.bor(v96, 8);
        end;

        if Buttons4 ~= Buttons3 then
            v96 = bit32.bor(v96, 16);
        end;

        buffer.writeu8(buffer_create_ret, v89, v96);
        v89 = writeChangedFields(buffer_create_ret, v89 + 1, v96, v92, v93, v94, v95, Buttons4);
        v87 = v94;
        v88 = v95;
        v86 = v93;
        Buttons3 = Buttons4;
        v85 = v92;
        local _ = i;
    end;

    for i, v in p62.Commands do
        local WeaponSelectIdentifier = v.WeaponSelectIdentifier;

        if WeaponSelectIdentifier ~= nil then
            local GrenadeThrowIdentifier = v.GrenadeThrowIdentifier;
            local GrenadeThrowAnimation = v.GrenadeThrowAnimation;
            local v97 = GrenadeThrowIdentifier == nil and 0 or #GrenadeThrowIdentifier;
            buffer.writeu8(buffer_create_ret, v89, i - 1);
            buffer.writeu32(buffer_create_ret, v89 + 1, v.WeaponSelectRequestId);
            buffer.writeu8(buffer_create_ret, v89 + 5, #WeaponSelectIdentifier);
            buffer.writeu8(buffer_create_ret, v89 + 6, v97);
            buffer.writeu8(buffer_create_ret, v89 + 7, GrenadeThrowAnimation == "Far" and 1 or (GrenadeThrowAnimation == "Near" and 2 or 0));
            buffer.writestring(buffer_create_ret, v89 + 8, WeaponSelectIdentifier);

            if GrenadeThrowIdentifier ~= nil then
                buffer.writestring(buffer_create_ret, v89 + 8 + #WeaponSelectIdentifier, GrenadeThrowIdentifier);
            end;

            v89 = v89 + (#WeaponSelectIdentifier + 8 + v97);
        end;
    end;

    local v98 = v89 == buffer.len(buffer_create_ret);
    assert(v98, "MovementV2 command wire size drift");

    return buffer_create_ret, nil;
end;

function u1.decode(p99, p100) -- Line: 425
    -- upvalues: Config (copy), Serial (copy), Quantization (copy), Buttons (copy)
    local v101 = p100 or Config.Default;

    if typeof(p99) ~= "buffer" then
        return nil, "CommandPayloadNotBuffer";
    end;

    local buffer_len_ret = buffer.len(p99);

    if buffer_len_ret < 10 then
        return nil, "CommandPayloadTruncated";
    end;

    if buffer.readu8(p99, 0) ~= 5 then
        return nil, "CommandVersion";
    end;

    local buffer_readu16_ret = buffer.readu16(p99, 1);
    local buffer_readu32_ret = buffer.readu32(p99, 3);
    local buffer_readu8_ret = buffer.readu8(p99, 7);
    local buffer_readu8_ret2 = buffer.readu8(p99, 8);
    local buffer_readu8_ret3 = buffer.readu8(p99, 9);
    local v102 = buffer_readu8_ret + buffer_readu8_ret2;

    if not Serial.isNonZeroUInt16(buffer_readu16_ret) then
        return nil, "InvalidGeneration";
    end;

    if buffer_readu8_ret < 1 or v101.MaxNewCommandsPerPacket < buffer_readu8_ret then
        return nil, "InvalidNewCommandCount";
    end;

    if v101.TargetRedundantCommandCount < buffer_readu8_ret2 then
        return nil, "InvalidRedundantCommandCount";
    end;

    if v101.MaxCommandsPerPacket < v102 then
        return nil, "CommandCountTooLarge";
    end;

    if v102 < buffer_readu8_ret3 then
        return nil, "InvalidWeaponSelectionCount";
    end;

    local v103 = math.max(0, v102 - 1) * 1 + 16 + buffer_readu8_ret3 * 8;
    local v104 = math.max(0, v102 - 1) * 7 + 16 + buffer_readu8_ret3 * 200;

    if buffer_len_ret < v103 or v104 < buffer_len_ret then
        return nil, "CommandPayloadSize";
    end;

    local table_create_ret = table.create(v102);
    local v105 = 10;
    local buffer_readi8_ret = buffer.readi8(p99, v105);
    local buffer_readi8_ret2 = buffer.readi8(p99, v105 + 1);
    local buffer_readu16_ret2 = buffer.readu16(p99, v105 + 2);
    local buffer_readi8_ret3 = buffer.readi8(p99, v105 + 4);
    local buffer_readu8_ret4 = buffer.readu8(p99, v105 + 5);
    local v106 = v105 + 6;

    for i = 1, v102 do
        if i > 1 then
            if buffer_len_ret - v106 < 1 then
                return nil, "CommandPayloadSize";
            end;

            local buffer_readu8_ret5 = buffer.readu8(p99, v106);
            v106 = v106 + 1;

            if bit32.band(buffer_readu8_ret5, 4294967264) ~= 0 then
                return nil, "InvalidCommandDeltaMask";
            end;

            local v107 = 0;

            if bit32.band(buffer_readu8_ret5, 1) ~= 0 then
                v107 = v107 + 1;
            end;

            if bit32.band(buffer_readu8_ret5, 2) ~= 0 then
                v107 = v107 + 1;
            end;

            if bit32.band(buffer_readu8_ret5, 4) ~= 0 then
                v107 = v107 + 2;
            end;

            if bit32.band(buffer_readu8_ret5, 8) ~= 0 then
                v107 = v107 + 1;
            end;

            if bit32.band(buffer_readu8_ret5, 16) ~= 0 then
                v107 = v107 + 1;
            end;

            if buffer_len_ret - v106 < v107 then
                return nil, "CommandPayloadSize";
            end;

            if bit32.band(buffer_readu8_ret5, 1) ~= 0 then
                buffer_readi8_ret = buffer.readi8(p99, v106);
                v106 = v106 + 1;
            end;

            if bit32.band(buffer_readu8_ret5, 2) ~= 0 then
                buffer_readi8_ret2 = buffer.readi8(p99, v106);
                v106 = v106 + 1;
            end;

            if bit32.band(buffer_readu8_ret5, 4) ~= 0 then
                buffer_readu16_ret2 = buffer.readu16(p99, v106);
                v106 = v106 + 2;
            end;

            if bit32.band(buffer_readu8_ret5, 8) ~= 0 then
                buffer_readi8_ret3 = buffer.readi8(p99, v106);
                v106 = v106 + 1;
            end;

            if bit32.band(buffer_readu8_ret5, 16) ~= 0 then
                buffer_readu8_ret4 = buffer.readu8(p99, v106);
                v106 = v106 + 1;
            end;
        end;

        local Vector2_new_ret = Vector2.new(Quantization.dequantizeSignedUnit(buffer_readi8_ret), Quantization.dequantizeSignedUnit(buffer_readi8_ret2));
        local v108 = Quantization.canonicalMove(Vector2_new_ret);

        if not Buttons.isValid(buffer_readu8_ret4) then
            return nil, "InvalidButtons";
        end;

        table_create_ret[i] = {
            CommandNumber = Serial.addUInt32(buffer_readu32_ret, i - 1),
            Move = v108,
            LookYaw = Quantization.dequantizeYaw(buffer_readu16_ret2),
            VerticalLook = Quantization.dequantizeSignedUnit(buffer_readi8_ret3),
            Buttons = buffer_readu8_ret4
        };
        local _ = i;
    end;

    local v109 = {};

    for i = 1, buffer_readu8_ret3 do
        if buffer_len_ret - v106 < 8 then
            return nil, "CommandPayloadSize";
        end;

        local v110 = buffer.readu8(p99, v106) + 1;
        local buffer_readu32_ret2 = buffer.readu32(p99, v106 + 1);
        local buffer_readu8_ret5 = buffer.readu8(p99, v106 + 5);
        local buffer_readu8_ret6 = buffer.readu8(p99, v106 + 6);
        local buffer_readu8_ret7 = buffer.readu8(p99, v106 + 7);
        local v111 = v106 + 8 + buffer_readu8_ret5 + buffer_readu8_ret6;
        local v112 = buffer_readu8_ret7 ~= 0 and true or buffer_readu8_ret6 ~= 0;

        if v102 < v110 or (v109[v110] == true or (buffer_readu32_ret2 == 0 or (buffer_readu8_ret5 > 96 or (buffer_readu8_ret6 > 96 or not v112 and buffer_readu8_ret5 < 1)))) or (v112 and buffer_readu8_ret6 < 1 or (v112 and (buffer_readu8_ret7 ~= 1 and buffer_readu8_ret7 ~= 2) or buffer_len_ret < v111)) then
            return nil, "InvalidWeaponSelection";
        end;

        local v113 = table_create_ret[v110];
        v113.WeaponSelectRequestId = buffer_readu32_ret2;
        v113.WeaponSelectIdentifier = buffer.readstring(p99, v106 + 8, buffer_readu8_ret5);

        if v112 then
            v113.GrenadeThrowIdentifier = buffer.readstring(p99, v106 + 8 + buffer_readu8_ret5, buffer_readu8_ret6);
            v113.GrenadeThrowAnimation = buffer_readu8_ret7 == 1 and "Far" or "Near";
        end;

        v109[v110] = true;
        v106 = v111;
        local _ = i;
    end;

    if v106 ~= buffer_len_ret then
        return nil, "CommandPayloadSize";
    end;

    for _, v in table_create_ret do
        table.freeze(v);
    end;

    table.freeze(table_create_ret);

    return table.freeze({
        Generation = buffer_readu16_ret,
        FirstCommandNumber = buffer_readu32_ret,
        RedundantCommandCount = buffer_readu8_ret2,
        NewCommandCount = buffer_readu8_ret,
        Commands = table_create_ret
    }), nil;
end;

return table.freeze(u1);