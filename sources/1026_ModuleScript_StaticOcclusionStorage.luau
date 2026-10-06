-- Decompiled with Potassium's decompiler.

local v1 = {};
local EncodingService = game:GetService("EncodingService");

local function base64Encode(p2: string) -- Line: 16
    local table_create_ret = table.create(math.ceil(#p2 / 3) * 4);
    local v3 = 1;

    while v3 <= #p2 do
        local v4 = string.byte(p2, v3) or 0;
        local v5 = string.byte(p2, v3 + 1) or 0;
        local v6 = string.byte(p2, v3 + 2) or 0;
        local v7 = v4 * 65536 + v5 * 256 + v6;
        local v8 = math.floor(v7 / 262144) % 64 + 1;
        local v9 = math.floor(v7 / 262144) % 64 + 1;
        table_create_ret[#table_create_ret + 1] = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", v8, v9);
        local v10 = math.floor(v7 / 4096) % 64 + 1;
        local v11 = math.floor(v7 / 4096) % 64 + 1;
        table_create_ret[#table_create_ret + 1] = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", v10, v11);
        local v12;

        if v3 + 1 <= #p2 then
            local v13 = math.floor(v7 / 64) % 64 + 1;
            local v14 = math.floor(v7 / 64) % 64 + 1;
            v12 = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", v13, v14);
        else
            v12 = "=";
        end;

        table_create_ret[#table_create_ret + 1] = v12;
        table_create_ret[#table_create_ret + 1] = v3 + 2 > #p2 and "=" or string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", v7 % 64 + 1, v7 % 64 + 1);
        v3 = v3 + 3;
    end;

    return table.concat(table_create_ret);
end;

local function base64Decode(u15: string) -- Line: 36
    -- upvalues: EncodingService (copy)
    if #u15 == 0 or #u15 % 4 ~= 0 then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 40
        -- upvalues: EncodingService (ref), u15 (copy)
        return buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(u15)));
    end);

    if success then
        return result;
    end;

    return nil;
end;

local function writePayload(p16: userdata, p17: string, p18: string, p19: string, p20: string) -- Line: 46
    -- upvalues: base64Encode (copy)
    if #p17 < 1 or #p17 > 67108864 then
        error((`Static occlusion payload is outside the runtime storage limit (1-{67108864} bytes)`));
    end;

    local v21 = p16:FindFirstChild(p19);

    if v21 then
        v21:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = p19;
    Folder:SetAttribute("Format", p20);
    Folder:SetAttribute("Encoding", "Base64");
    Folder:SetAttribute("Fingerprint", p18);
    Folder:SetAttribute("ByteCount", #p17);
    local v22 = base64Encode(p17);
    Folder:SetAttribute("EncodedByteCount", #v22);
    local math_ceil_ret = math.ceil(#v22 / 160000);
    local math_max_ret = math.max(math_ceil_ret, 1);
    Folder:SetAttribute("ChunkCount", math_max_ret);

    for i = 1, math_max_ret do
        local StringValue = Instance.new("StringValue");
        StringValue.Name = `Chunk{string.format("%04d", i)}`;
        local v23 = (i - 1) * 160000 + 1;
        local math_min_ret = math.min(v23 + 160000 - 1, #v22);
        StringValue.Value = string.sub(v22, v23, math_min_ret);
        StringValue.Parent = Folder;
        local _ = i;
    end;

    Folder.Parent = p16;
end;

local function readPayload(p24: userdata, p25: string?, p26: function?, p27: string, p28: string) -- Line: 80
    -- upvalues: EncodingService (copy)
    local v29 = p24:FindFirstChild(p27);

    if v29 == nil or not v29:IsA("Folder") then
        return nil, "MissingPVSStaticOcclusion";
    end;

    if v29:GetAttribute("Format") ~= p28 then
        return nil, "UnsupportedPVSStaticOcclusionFormat";
    end;

    if v29:GetAttribute("Encoding") ~= "Base64" then
        return nil, "UnsupportedPVSStaticOcclusionEncoding";
    end;

    local Attribute = v29:GetAttribute("Fingerprint");

    if typeof(Attribute) ~= "string" or #Attribute == 0 then
        return nil, "MissingPVSStaticOcclusionFingerprint";
    end;

    if p25 ~= nil and Attribute ~= p25 then
        return nil, "PVSStaticOcclusionFingerprintMismatch";
    end;

    local Attribute2 = v29:GetAttribute("ChunkCount");
    local Attribute3 = v29:GetAttribute("ByteCount");
    local Attribute4 = v29:GetAttribute("EncodedByteCount");

    if typeof(Attribute2) ~= "number" or (Attribute2 < 1 or (Attribute2 > 560 or (Attribute2 % 1 ~= 0 or (typeof(Attribute3) ~= "number" or (Attribute3 < 1 or (Attribute3 > 67108864 or (Attribute3 % 1 ~= 0 or (typeof(Attribute4) ~= "number" or (Attribute4 < 1 or (Attribute4 > 89478488 or Attribute4 % 1 ~= 0)))))))))) then
        return nil, "InvalidPVSStaticOcclusionManifest";
    end;

    local table_create_ret = table.create(Attribute2);
    local v30 = 0;
    local v31 = 0;

    for i = 1, Attribute2 do
        if p26 then
            p26();
        end;

        local v32 = v29:FindFirstChild((`Chunk{string.format("%04d", i)}`));

        if v32 == nil or not v32:IsA("StringValue") then
            return nil, `MissingPVSStaticOcclusionChunk:{i}`;
        end;

        local Value = v32.Value;
        local v33 = #Value;

        if v33 == 0 or (v33 > 160000 or v33 % 4 ~= 0) then
            return nil, `InvalidPVSStaticOcclusionChunk:{i}`;
        end;

        v30 = v30 + v33;

        if Attribute4 < v30 then
            return nil, "PVSStaticOcclusionByteCountMismatch";
        end;

        local v34;

        if #Value == 0 or #Value % 4 ~= 0 then
            v34 = nil;
        else
            local v35;
            v35, v34 = pcall(function() -- Line: 40
                -- upvalues: EncodingService (ref), Value (copy)
                return buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(Value)));
            end);

            if not v35 then
                v34 = nil;
            end;
        end;

        if v34 == nil then
            return nil, `PVSStaticOcclusionBase64DecodeFailed:{i}`;
        end;

        table_create_ret[i] = v34;
        v31 = v31 + #v34;

        if Attribute3 < v31 then
            return nil, "PVSStaticOcclusionByteCountMismatch";
        end;

        local _ = i;
    end;

    if v30 == Attribute4 and v31 == Attribute3 then
        return table.concat(table_create_ret), nil;
    end;

    return nil, "PVSStaticOcclusionByteCountMismatch";
end;

function v1.write(p36: userdata, p37: string, p38: string) -- Line: 159
    -- upvalues: writePayload (copy)
    writePayload(p36, p37, p38, "PVSStaticOcclusion", "PVBVH1");
end;

function v1.read(p39: userdata, p40: string?, p41: function?) -- Line: 162
    -- upvalues: readPayload (copy)
    return readPayload(p39, p40, p41, "PVSStaticOcclusion", "PVBVH1");
end;

function v1.writeProofs(p42: userdata, p43: string, p44: string) -- Line: 169
    -- upvalues: writePayload (copy)
    assert(#p43 <= 8388608, "geometry proof sidecar exceeds 8 MiB");
    writePayload(p42, p43, p44, "PVSGeometryProofs", "PVSPRF1");
end;

function v1.readProofs(p45: userdata, p46: string?, p47: function?) -- Line: 173
    -- upvalues: readPayload (copy)
    local PVSGeometryProofs = p45:FindFirstChild("PVSGeometryProofs");

    if PVSGeometryProofs == nil then
        return nil, nil;
    end;

    local Attribute = PVSGeometryProofs:GetAttribute("ByteCount");

    if typeof(Attribute) == "number" and Attribute <= 8388608 then
        return readPayload(p45, p46, p47, "PVSGeometryProofs", "PVSPRF1");
    end;

    return nil, "InvalidGeometryProofSize";
end;

v1.FOLDER_NAME = "PVSStaticOcclusion";
v1.MAX_RAW_BYTES = 67108864;

return table.freeze(v1);