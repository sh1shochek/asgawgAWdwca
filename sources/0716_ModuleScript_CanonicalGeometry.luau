-- Decompiled with Potassium's decompiler.

local Schema = require(script.Parent.Schema);
local table_create_ret = table.create(256);
local u1 = {};

for i = 0, 255 do
    local v2 = i;
    local v3 = v2;
    local v4 = v2;
    v2 = v3;
    v4 = v3;

    for i2 = 1, 8 do
        local bit32_rshift_ret = bit32.rshift(v3, 1);
        local v5;

        if bit32.band(v3, 1) == 0 then
            v3 = bit32_rshift_ret;
            v5 = i2;
        else
            v3 = bit32.bxor(bit32_rshift_ret, 3988292384);
            v5 = i2;
        end;
    end;

    table_create_ret[v2 + 1] = v3;
end;

table.freeze(table_create_ret);

local function updateCrc32(p6: number, p7: string) -- Line: 34
    -- upvalues: table_create_ret (copy)
    for i = 1, #p7 do
        local string_byte_ret = string.byte(p7, i);
        local bit32_bxor_ret = bit32.bxor(p6, string_byte_ret);
        local v8 = bit32.band(bit32_bxor_ret, 255) + 1;
        local bit32_rshift_ret = bit32.rshift(p6, 8);
        p6 = bit32.bxor(bit32_rshift_ret, table_create_ret[v8]);
        local _ = i;
    end;

    return p6;
end;

local function finishCrc32(p9: number) -- Line: 43
    return bit32.bxor(p9, 4294967295);
end;

local function isFinite(p10) -- Line: 47
    local v11;

    if typeof(p10) == "number" and (p10 == p10 and p10 > (-1 / 0)) then
        v11 = p10 < (1 / 0);
    else
        v11 = false;
    end;

    return v11;
end;

local function quantize(p12: number, p13: number) -- Line: 51
    local v14;

    if typeof(p12) == "number" and (p12 == p12 and p12 > (-1 / 0)) then
        v14 = p12 < (1 / 0);
    else
        v14 = false;
    end;

    if not v14 then
        return nil, "geometry contains a non-finite component";
    end;

    local math_round_ret = math.round(p12 * p13);

    if math_round_ret < -2147483648 or math_round_ret > 2147483647 then
        return nil, "geometry component exceeds the signed fixed-point range";
    end;

    return math_round_ret == 0 and 0 or math_round_ret, nil;
end;

local function appendQuantized(p15: table, p16: number, p17: number) -- Line: 63
    local v18;

    if typeof(p16) == "number" and (p16 == p16 and p16 > (-1 / 0)) then
        v18 = p16 < (1 / 0);
    else
        v18 = false;
    end;

    local v19, v20;

    if v18 then
        local math_round_ret = math.round(p16 * p17);

        if math_round_ret < -2147483648 or math_round_ret > 2147483647 then
            v19 = nil;
            v20 = "geometry component exceeds the signed fixed-point range";
        else
            v19 = math_round_ret == 0 and 0 or math_round_ret;
            v20 = nil;
        end;
    else
        v19 = nil;
        v20 = "geometry contains a non-finite component";
    end;

    if v19 == nil then
        return v20;
    end;

    p15[#p15 + 1] = v19;

    return nil;
end;

local function encodeRaw(p21, p22: vector) -- Line: 72
    -- upvalues: Schema (copy), u1 (copy)
    if typeof(p21) ~= "CFrame" or typeof(p22) ~= "Vector3" then
        return nil, "geometry requires a CFrame and Vector3 size";
    end;

    local v23 = { p21:GetComponents() };

    for _, v in ipairs(v23) do
        local v24;

        if typeof(v) == "number" and (v == v and v > (-1 / 0)) then
            v24 = v < (1 / 0);
        else
            v24 = false;
        end;

        if not v24 then
            return nil, "geometry CFrame contains a non-finite component";
        end;
    end;

    local X = p22.X;
    local v25;

    if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
        v25 = X < (1 / 0);
    else
        v25 = false;
    end;

    if v25 then
        local Y = p22.Y;
        local v26;

        if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
            v26 = Y < (1 / 0);
        else
            v26 = false;
        end;

        if v26 then
            local Z = p22.Z;
            local v27;

            if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                v27 = Z < (1 / 0);
            else
                v27 = false;
            end;

            if v27 then
                if p22.X < 0 or (p22.Y < 0 or p22.Z < 0) then
                    return nil, "geometry size cannot be negative";
                end;

                local Position = p21.Position;
                local RightVector = p21.RightVector;
                local UpVector = p21.UpVector;
                local v28 = {};

                for _, v in ipairs({
                    { Position.X, 4096 },
                    { Position.Y, 4096 },
                    { Position.Z, 4096 },
                    { RightVector.X, 4096 },
                    { RightVector.Y, 4096 },
                    { RightVector.Z, 4096 },
                    { UpVector.X, 4096 },
                    { UpVector.Y, 4096 },
                    { UpVector.Z, 4096 },
                    { p22.X, 4096 },
                    { p22.Y, 4096 },
                    { p22.Z, 4096 }
                }) do
                    local v29 = v[1];
                    local v30 = v[2];
                    local v31;

                    if typeof(v29) == "number" and (v29 == v29 and v29 > (-1 / 0)) then
                        v31 = v29 < (1 / 0);
                    else
                        v31 = false;
                    end;

                    local v32, v33;

                    if v31 then
                        local math_round_ret = math.round(v29 * v30);

                        if math_round_ret < -2147483648 or math_round_ret > 2147483647 then
                            v32 = nil;
                            v33 = "geometry component exceeds the signed fixed-point range";
                        else
                            v32 = math_round_ret == 0 and 0 or math_round_ret;
                            v33 = nil;
                        end;
                    else
                        v32 = nil;
                        v33 = "geometry contains a non-finite component";
                    end;

                    if v32 ~= nil then
                        v28[#v28 + 1] = v32;
                        v33 = nil;
                    end;

                    if v33 ~= nil then
                        return nil, v33;
                    end;
                end;

                local table_create_ret2 = table.create(13);
                table_create_ret2[1] = Schema.CanonicalGeometryVersion;

                for i, v in ipairs(v28) do
                    table_create_ret2[i + 1] = tostring(v);
                end;

                local table_concat_ret = table.concat(table_create_ret2, "|");
                local v34 = u1.Crc32(table_concat_ret);

                return string.format("%s|%08x", table_concat_ret, v34), nil;
            end;
        end;
    end;

    return nil, "geometry size contains a non-finite component";
end;

local function parseCanonicalInteger(p35: string?) -- Line: 125
    if p35 == nil or (string.match(p35, "^%-?%d+$") == nil or p35 == "-0") then
        return nil;
    end;

    local v36 = tonumber(p35);

    if v36 == nil or (v36 % 1 ~= 0 or (v36 < -2147483648 or v36 > 2147483647)) then
        return nil;
    end;

    if tostring(v36) == p35 then
        return v36;
    end;

    return nil;
end;

function u1.Crc32(p37: string) -- Line: 139
    -- upvalues: updateCrc32 (copy)
    local v38 = typeof(p37) == "string";
    assert(v38, "CRC32 input must be a string");
    local v39 = updateCrc32(4294967295, p37);

    return bit32.bxor(v39, 4294967295);
end;

function u1.HashStrings(p40: table) -- Line: 144
    -- upvalues: updateCrc32 (copy)
    local table_clone_ret = table.clone(p40);
    table.sort(table_clone_ret);
    local v41 = 4294967295;

    for _, v in ipairs(table_clone_ret) do
        local v42 = typeof(v) == "string";
        assert(v42, "fingerprint entries must be strings");
        local v43 = #v;
        assert(v43 <= 4294967295, "fingerprint entry is too large");
        local bit32_band_ret = bit32.band(v43, 255);
        local bit32_rshift_ret = bit32.rshift(v43, 8);
        local bit32_band_ret2 = bit32.band(bit32_rshift_ret, 255);
        local bit32_rshift_ret2 = bit32.rshift(v43, 16);
        local bit32_band_ret3 = bit32.band(bit32_rshift_ret2, 255);
        local bit32_rshift_ret3 = bit32.rshift(v43, 24);
        local bit32_band_ret4 = bit32.band(bit32_rshift_ret3, 255);
        v41 = updateCrc32(updateCrc32(v41, (string.char(bit32_band_ret, bit32_band_ret2, bit32_band_ret3, bit32_band_ret4))), v);
    end;

    return bit32.bxor(v41, 4294967295);
end;

function u1.TryEncode(p44, p45: vector) -- Line: 165
    -- upvalues: encodeRaw (copy)
    return encodeRaw(p44, p45);
end;

function u1.Encode(p46, p47: vector) -- Line: 169
    -- upvalues: encodeRaw (copy)
    local v48, v49 = encodeRaw(p46, p47);
    assert(v48 ~= nil, v49);

    return v48;
end;

function u1.Decode(p50) -- Line: 175
    -- upvalues: Schema (copy), u1 (copy), parseCanonicalInteger (copy)
    if typeof(p50) ~= "string" then
        return nil, "canonical geometry descriptor must be a string";
    end;

    local string_split_ret = string.split(p50, "|");

    if #string_split_ret ~= 14 or string_split_ret[1] ~= Schema.CanonicalGeometryVersion then
        return nil, "canonical geometry descriptor has an unsupported shape or version";
    end;

    local v51 = string_split_ret[14];

    if #v51 ~= 8 or (string.match(v51, "^%x+$") == nil or v51 ~= string.lower(v51)) then
        return nil, "canonical geometry descriptor has an invalid CRC field";
    end;

    local v52 = tonumber(v51, 16);
    local string_sub_ret = string.sub(p50, 1, #p50 - 9);

    if v52 == nil or u1.Crc32(string_sub_ret) ~= v52 then
        return nil, "canonical geometry descriptor CRC does not match";
    end;

    local table_create_ret2 = table.create(12);

    for i = 1, 12 do
        local v53 = parseCanonicalInteger(string_split_ret[i + 1]);

        if v53 == nil then
            return nil, string.format("canonical geometry field %d is not a canonical i32", i);
        end;

        table_create_ret2[i] = v53;
        local _ = i;
    end;

    if table_create_ret2[10] < 0 or (table_create_ret2[11] < 0 or table_create_ret2[12] < 0) then
        return nil, "canonical geometry size cannot be negative";
    end;

    local v54 = Vector3.new(table_create_ret2[1], table_create_ret2[2], table_create_ret2[3]) / 4096;
    local v55 = Vector3.new(table_create_ret2[4], table_create_ret2[5], table_create_ret2[6]) / 4096;
    local v56 = Vector3.new(table_create_ret2[7], table_create_ret2[8], table_create_ret2[9]) / 4096;
    local Magnitude = v56.Magnitude;

    if math.abs(v55.Magnitude - 1) > 0.01 or math.abs(Magnitude - 1) > 0.01 then
        return nil, "canonical geometry axes are not unit length";
    end;

    local v57 = v55:Dot(v56);

    if math.abs(v57) > 0.01 then
        return nil, "canonical geometry axes are not orthogonal";
    end;

    local Unit = v55.Unit;
    local v58 = v56 - Unit * v56:Dot(Unit);

    if v58.Magnitude <= 0.5 then
        return nil, "canonical geometry axes are degenerate";
    end;

    local Unit2 = Unit:Cross(v58.Unit).Unit;
    local Unit3 = Unit2:Cross(Unit).Unit;
    local v59 = Vector3.new(table_create_ret2[10], table_create_ret2[11], table_create_ret2[12]) / 4096;

    return table.freeze({
        CFrame = CFrame.fromMatrix(v54, Unit, Unit3, Unit2),
        Size = v59,
        Descriptor = p50
    }), nil;
end;

function u1.EncodeInstance(p60: userdata) -- Line: 238
    -- upvalues: u1 (copy)
    if p60:IsA("BasePart") then
        return u1.Encode(p60.CFrame, p60.Size);
    end;

    if p60:IsA("Model") then
        return u1.Encode(p60:GetPivot(), Vector3.new(0, 0, 0));
    end;

    error("canonical geometry can only be encoded for a BasePart or Model", 2);
end;

function u1.Publish(p61: userdata) -- Line: 248
    -- upvalues: u1 (copy), Schema (copy)
    local v62 = u1.EncodeInstance(p61);
    p61:SetAttribute(Schema.Attributes.CanonicalGeometry, v62);

    return v62;
end;

function u1.ReadPublished(p63: userdata) -- Line: 254
    -- upvalues: Schema (copy), u1 (copy)
    local Attribute = p63:GetAttribute(Schema.Attributes.CanonicalGeometry);

    if typeof(Attribute) ~= "string" then
        return nil, string.format("%s is missing %s", p63:GetFullName(), Schema.Attributes.CanonicalGeometry);
    end;

    local v64, v65 = u1.Decode(Attribute);

    if v64 == nil then
        return nil, string.format("%s has invalid canonical geometry: %s", p63:GetFullName(), v65 or "unknown error");
    end;

    return v64, nil;
end;

return table.freeze(u1);