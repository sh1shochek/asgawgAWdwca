-- Decompiled with Potassium's decompiler.

local MoverTrajectory = require(script.Parent.MoverTrajectory);
local u1 = {
    DescriptorWireSize = 193,
    MaxDescriptorCount = 64
};

local function fitsF32(p2: number) -- Line: 18
    local v3;

    if p2 == p2 and p2 >= -3.402823466e38 then
        v3 = p2 <= 3.402823466e38;
    else
        v3 = false;
    end;

    return v3;
end;

local function vectorFitsF32(p4: vector) -- Line: 22
    local X = p4.X;
    local v5;

    if X == X and X >= -3.402823466e38 then
        v5 = X <= 3.402823466e38;
    else
        v5 = false;
    end;

    if v5 then
        local Y = p4.Y;

        if Y == Y and Y >= -3.402823466e38 then
            v5 = Y <= 3.402823466e38;
        else
            v5 = false;
        end;

        if v5 then
            local Z = p4.Z;

            if Z == Z and Z >= -3.402823466e38 then
                v5 = Z <= 3.402823466e38;
            else
                v5 = false;
            end;
        end;
    end;

    return v5;
end;

local function cframeFitsF32(p6) -- Line: 26
    for _, v in { p6:GetComponents() } do
        local v7;

        if v == v and v >= -3.402823466e38 then
            v7 = v <= 3.402823466e38;
        else
            v7 = false;
        end;

        if not v7 then
            return false;
        end;
    end;

    return true;
end;

function u1.validateList(p8: any, p9: boolean?) -- Line: 35
    -- upvalues: MoverTrajectory (copy), cframeFitsF32 (copy)
    if type(p8) ~= "table" or (#p8 > 64 or #p8 == 0 and p9 ~= true) then
        return false, "InvalidMoverDescriptorCount";
    end;

    for i, v in p8 do
        if type(i) ~= "number" or (i % 1 ~= 0 or (i < 1 or #p8 < i)) then
            return false, "MoverDescriptorsNotDense";
        end;

        local v10, v11 = MoverTrajectory.Validate(v);

        if not v10 then
            return false, v11;
        end;

        local Size = v.Size;
        local X = Size.X;
        local v12;

        if X == X and X >= -3.402823466e38 then
            v12 = X <= 3.402823466e38;
        else
            v12 = false;
        end;

        if v12 then
            local Y = Size.Y;

            if Y == Y and Y >= -3.402823466e38 then
                v12 = Y <= 3.402823466e38;
            else
                v12 = false;
            end;

            if v12 then
                local Z = Size.Z;

                if Z == Z and Z >= -3.402823466e38 then
                    v12 = Z <= 3.402823466e38;
                else
                    v12 = false;
                end;
            end;
        end;

        if not (v12 and cframeFitsF32(v.CollisionOffset)) then
            return false, "MoverDescriptorOutsideWireRange";
        end;

        local SurfaceFriction = v.SurfaceFriction;
        local v13;

        if SurfaceFriction == SurfaceFriction and SurfaceFriction >= -3.402823466e38 then
            v13 = SurfaceFriction <= 3.402823466e38;
        else
            v13 = false;
        end;

        if not (v13 and (cframeFitsF32(v.StartPose) and cframeFitsF32(v.TargetPose))) then
            return false, "MoverDescriptorOutsideWireRange";
        end;

        local DurationSeconds = v.DurationSeconds;
        local v14;

        if DurationSeconds == DurationSeconds and DurationSeconds >= -3.402823466e38 then
            v14 = DurationSeconds <= 3.402823466e38;
        else
            v14 = false;
        end;

        if not v14 then
            return false, "MoverDescriptorOutsideWireRange";
        end;
    end;

    return true, nil;
end;

local function writeVector3(p15: buffer, p16: number, p17: vector) -- Line: 61
    buffer.writef32(p15, p16, p17.X);
    buffer.writef32(p15, p16 + 4, p17.Y);
    buffer.writef32(p15, p16 + 8, p17.Z);

    return p16 + 12;
end;

local function readVector3(p18: buffer, p19: number) -- Line: 68
    local buffer_readf32_ret = buffer.readf32(p18, p19);
    local buffer_readf32_ret2 = buffer.readf32(p18, p19 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p18, p19 + 8);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3), p19 + 12;
end;

local function writeCFrame(p20: buffer, p21: number, p22) -- Line: 77
    for _, v in { p22:GetComponents() } do
        buffer.writef32(p20, p21, v);
        p21 = p21 + 4;
    end;

    return p21;
end;

local function readCFrame(p23: buffer, p24: number) -- Line: 85
    local table_create_ret = table.create(12);

    for i = 1, 12 do
        table_create_ret[i] = buffer.readf32(p23, p24);
        p24 = p24 + 4;
        local _ = i;
    end;

    return CFrame.new(table.unpack(table_create_ret)), p24;
end;

function u1.writeValidated(p25: buffer, p26: number, p27: table) -- Line: 94
    for _, v in p27 do
        buffer.writeu32(p25, p26, v.Id);
        local v28 = p26 + 4;
        buffer.writeu32(p25, v28, v.Revision);
        local v29 = v28 + 4;
        local v30 = 0;

        if v.Moving then
            v30 = bit32.bor(v30, 1);
        end;

        if v.Active then
            v30 = bit32.bor(v30, 2);
        end;

        if v.Behavior == "Pusher" then
            v30 = bit32.bor(v30, 4);
        end;

        buffer.writeu8(p25, v29, v30);
        local v31 = v29 + 1;
        local Size = v.Size;
        buffer.writef32(p25, v31, Size.X);
        buffer.writef32(p25, v31 + 4, Size.Y);
        buffer.writef32(p25, v31 + 8, Size.Z);
        local v32 = v31 + 12;
        local v33 = v;

        for _, v2 in { v.CollisionOffset:GetComponents() } do
            buffer.writef32(p25, v32, v2);
            v32 = v32 + 4;
        end;

        buffer.writef32(p25, v32, v33.SurfaceFriction);
        local v34 = v32 + 4;

        for _, v2 in { v33.StartPose:GetComponents() } do
            buffer.writef32(p25, v34, v2);
            v34 = v34 + 4;
        end;

        for _, v2 in { v33.TargetPose:GetComponents() } do
            buffer.writef32(p25, v34, v2);
            v34 = v34 + 4;
        end;

        buffer.writeu32(p25, v34, v33.EffectiveTick);
        local v35 = v34 + 4;
        buffer.writeu32(p25, v35, v33.StartTick);
        local v36 = v35 + 4;
        buffer.writeu32(p25, v36, v33.DurationTicks);
        local v37 = v36 + 4;
        buffer.writef64(p25, v37, v33.StartServerTime);
        local v38 = v37 + 8;
        buffer.writef32(p25, v38, v33.DurationSeconds);
        local v39 = v38 + 4;
        assert(v39 - p26 == 193, "mover descriptor wire size drift");
        p26 = v39;
    end;

    return p26;
end;

function u1.readList(p40: buffer, p41: number, p42: number) -- Line: 134
    -- upvalues: readCFrame (copy), u1 (copy)
    if p42 < 0 or (p42 > 64 or buffer.len(p40) - p41 ~= p42 * 193) then
        return nil, p41, "MoverDescriptorPayloadSize";
    end;

    local table_create_ret = table.create(p42);

    for i = 1, p42 do
        local buffer_readu32_ret = buffer.readu32(p40, p41);
        local v43 = p41 + 4;
        local buffer_readu32_ret2 = buffer.readu32(p40, v43);
        local v44 = v43 + 4;
        local buffer_readu8_ret = buffer.readu8(p40, v44);
        local v45 = v44 + 1;

        if bit32.band(buffer_readu8_ret, 4294967288) ~= 0 then
            return nil, v45, "InvalidMoverDescriptorFlags";
        end;

        local buffer_readf32_ret = buffer.readf32(p40, v45);
        local buffer_readf32_ret2 = buffer.readf32(p40, v45 + 4);
        local buffer_readf32_ret3 = buffer.readf32(p40, v45 + 8);
        local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local v46, v47 = readCFrame(p40, v45 + 12);
        local buffer_readf32_ret4 = buffer.readf32(p40, v47);
        local v48, v49 = readCFrame(p40, v47 + 4);
        local v50, v51 = readCFrame(p40, v49);
        local buffer_readu32_ret3 = buffer.readu32(p40, v51);
        local v52 = v51 + 4;
        local buffer_readu32_ret4 = buffer.readu32(p40, v52);
        local v53 = v52 + 4;
        local buffer_readu32_ret5 = buffer.readu32(p40, v53);
        local v54 = v53 + 4;
        local buffer_readf64_ret = buffer.readf64(p40, v54);
        local v55 = v54 + 8;
        local buffer_readf32_ret5 = buffer.readf32(p40, v55);
        local v56 = v55 + 4;
        assert(v56 - p41 == 193, "mover descriptor wire size drift");
        table_create_ret[i] = {
            Id = buffer_readu32_ret,
            Size = Vector3_new_ret,
            CollisionOffset = v46,
            SurfaceFriction = buffer_readf32_ret4,
            StartPose = v48,
            TargetPose = v50,
            EffectiveTick = buffer_readu32_ret3,
            StartTick = buffer_readu32_ret4,
            DurationTicks = buffer_readu32_ret5,
            StartServerTime = buffer_readf64_ret,
            DurationSeconds = buffer_readf32_ret5,
            Moving = bit32.band(buffer_readu8_ret, 1) ~= 0,
            Active = bit32.band(buffer_readu8_ret, 2) ~= 0,
            Behavior = bit32.band(buffer_readu8_ret, 4) == 0 and "StopOnBlock" or "Pusher",
            Revision = buffer_readu32_ret2
        };
        p41 = v56;
        local _ = i;
    end;

    local v57, v58 = u1.validateList(table_create_ret, true);

    if v57 then
        return table_create_ret, p41, nil;
    end;

    return nil, p41, v58;
end;

function u1.canonicalize(p59) -- Line: 194
    -- upvalues: u1 (copy)
    local v60 = { p59 };
    local v61, v62 = u1.validateList(v60);

    if not v61 then
        return nil, v62;
    end;

    local buffer_create_ret = buffer.create(193);
    u1.writeValidated(buffer_create_ret, 0, v60);
    local v63, _, v64 = u1.readList(buffer_create_ret, 0, 1);

    if v63 == nil then
        return nil, v64;
    end;

    return v63[1], nil;
end;

return table.freeze(u1);