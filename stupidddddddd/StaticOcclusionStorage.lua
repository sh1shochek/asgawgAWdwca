-- ReplicatedStorage.Visibility.StaticOcclusionStorage
-- Script path: ReplicatedStorage.Visibility.StaticOcclusionStorage
-- Decompile time: 4.13 ms

local v1 = {}
local EncodingService = game:GetService("EncodingService")

local function base64Encode(a1) -- Line: 16 -- types: a1: string
    local v1, v2, v3, v4
    local v5 = table.create(math.ceil(#a1 / 3) * 4)
    local v6 = 1
    local v7 = a1
    while v6 <= #v7 do
        v1 = string.byte(v7, v6) or 0
        v2 = string.byte(v7, v6 + 1) or 0
        v3 = string.byte(v7, v6 + 2)
        v3 = v1 * 65536 + v2 * 256 + (v3 or 0)
        v5[#v5 + 1] = (string.sub(
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
            math.floor(v3 / 262144) % 64 + 1,
            (math.floor(v3 / 262144)) % 64 + 1
        ))
        v5[#v5 + 1] = (string.sub(
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
            math.floor(v3 / 4096) % 64 + 1,
            (math.floor(v3 / 4096)) % 64 + 1
        ))
        v4 = #v5 + 1
        v5[v4] = if not (v6 + 1 <= #v7) then "=" else string.sub(
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
            math.floor(v3 / 64) % 64 + 1,
            (math.floor(v3 / 64)) % 64 + 1
        )
        v4 = #v5 + 1
        v5[v4] = if not (v6 + 2 <= #v7) then "=" else string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", v3 % 64 + 1, v3 % 64 + 1)
        v6 = v6 + 3
    end
    return table.concat(v5)
end

local function base64Decode(a1) -- Line: 36 -- upvalues: EncodingService (val) -- types: a1: string
    if #a1 ~= 0 and #a1 % 4 == 0 then
        local success, result = pcall(function() -- Line: 40 -- upvalues: EncodingService (upval), a1 (val)
            return buffer.tostring(EncodingService:Base64Decode((buffer.fromstring(a1))))
        end)
        if success then
            return result
        end
        return nil
    end
    return nil
end

local function writePayload(a1, a2, a3, a4, a5) -- Line: 46
    -- upvalues: base64Encode (val)
    local StringValue, v1
    if #a2 < 1 or #a2 > 67108864 then
        error((("Static occlusion payload is outside the runtime storage limit (1-%* bytes)"):format(67108864)))
    end
    local v2 = a1:FindFirstChild(a4)
    if v2 then
        v2:Destroy()
    end
    local Folder = Instance.new("Folder")
    Folder.Name = a4
    Folder:SetAttribute("Format", a5)
    Folder:SetAttribute("Encoding", "Base64")
    Folder:SetAttribute("Fingerprint", a3)
    Folder:SetAttribute("ByteCount", #a2)
    local v3 = base64Encode(a2)
    Folder:SetAttribute("EncodedByteCount", #v3)
    local v4 = math.max(math.ceil(#v3 / 160000), 1)
    Folder:SetAttribute("ChunkCount", v4)
    for i = 1, v4 do
        StringValue = Instance.new("StringValue")
        StringValue.Name = ("Chunk%*"):format((string.format("%04d", i)))
        v1 = (i - 1) * 160000 + 1
        StringValue.Value = string.sub(v3, v1, (math.min(v1 + 160000 - 1, #v3)))
        StringValue.Parent = Folder
    end
    Folder.Parent = a1
end

local function readPayload(a1, a2, a3, a4, a5) -- Line: 80
    -- upvalues: EncodingService (val)
    local v1 = a1:FindFirstChild(a4)
    if v1 ~= nil and v1:IsA("Folder") then
        if v1:GetAttribute("Format") ~= a5 then
            return nil, "UnsupportedPVSStaticOcclusionFormat"
        end
        if v1:GetAttribute("Encoding") ~= "Base64" then
            return nil, "UnsupportedPVSStaticOcclusionEncoding"
        end
        local Attribute = v1:GetAttribute("Fingerprint")
        if typeof(Attribute) == "string" and #Attribute ~= 0 then
            if a2 ~= nil and Attribute ~= a2 then
                return nil, "PVSStaticOcclusionFingerprintMismatch"
            end
            local Attribute_2 = v1:GetAttribute("ChunkCount")
            local Attribute_3 = v1:GetAttribute("ByteCount")
            local Attribute_4 = v1:GetAttribute("EncodedByteCount")
            if typeof(Attribute_2) == "number"
                and not (Attribute_2 < 1)
                and not (Attribute_2 > 560)
                and Attribute_2 % 1 == 0
                and typeof(Attribute_3) == "number"
                and not (Attribute_3 < 1)
                and not (Attribute_3 > 67108864)
                and Attribute_3 % 1 == 0
                and typeof(Attribute_4) == "number"
                and not (Attribute_4 < 1)
                and not (Attribute_4 > 89478488)
                and Attribute_4 % 1 == 0 then
                local result, success, v2, v3, v4
                local v5 = table.create(Attribute_2)
                local v6 = 0
                local v7 = 0
                local v8 = a3
                for i = 1, Attribute_2 do
                    if v8 then
                        v8()
                    end
                    v2 = v1:FindFirstChild((("Chunk%*"):format((string.format("%04d", i)))))
                    if v2 ~= nil and v2:IsA("StringValue") then
                        local Value = v2.Value
                        v3 = #Value
                        if v3 ~= 0 and not (v3 > 160000) and v3 % 4 == 0 then
                            v6 = v6 + v3
                            if Attribute_4 < v6 then
                                return nil, "PVSStaticOcclusionByteCountMismatch"
                            end
                            if #Value == 0 then
                                v4 = nil
                            elseif #Value % 4 == 0 then
                                success, result = pcall(function() -- Line: 40 -- upvalues: EncodingService (upval), Value (val)
                                    return buffer.tostring(EncodingService:Base64Decode((buffer.fromstring(Value))))
                                end)
                                v4 = if not success then nil else result
                            else
                                v4 = nil
                            end
                            if v4 == nil then
                                return nil, (("PVSStaticOcclusionBase64DecodeFailed:%*"):format(i))
                            end
                            v5[i] = v4
                            v7 = v7 + #v4
                            if not (Attribute_3 < v7) then
                                continue
                            end
                            return nil, "PVSStaticOcclusionByteCountMismatch"
                        end
                        return nil, (("InvalidPVSStaticOcclusionChunk:%*"):format(i))
                    end
                    return nil, (("MissingPVSStaticOcclusionChunk:%*"):format(i))
                end
                if v6 == Attribute_4 and v7 == Attribute_3 then
                    return (table.concat(v5)), nil
                end
                return nil, "PVSStaticOcclusionByteCountMismatch"
            end
            return nil, "InvalidPVSStaticOcclusionManifest"
        end
        return nil, "MissingPVSStaticOcclusionFingerprint"
    end
    return nil, "MissingPVSStaticOcclusion"
end

function v1.write(a1, a2, a3) -- Line: 159
    -- upvalues: writePayload (val)
    writePayload(a1, a2, a3, "PVSStaticOcclusion", "PVBVH1")
end

function v1.read(a1, a2, a3) -- Line: 162
    -- upvalues: readPayload (val)
    return readPayload(a1, a2, a3, "PVSStaticOcclusion", "PVBVH1")
end

function v1.writeProofs(a1, a2, a3) -- Line: 169
    -- upvalues: writePayload (val)
    assert(#a2 <= 8388608, "geometry proof sidecar exceeds 8 MiB")
    writePayload(a1, a2, a3, "PVSGeometryProofs", "PVSPRF1")
end

function v1.readProofs(a1, a2, a3) -- Line: 173
    -- upvalues: readPayload (val)
    local PVSGeometryProofs = a1:FindFirstChild("PVSGeometryProofs")
    if PVSGeometryProofs == nil then
        return nil, nil
    end
    local Attribute = PVSGeometryProofs:GetAttribute("ByteCount")
    if typeof(Attribute) == "number" and not (Attribute > 8388608) then
        return readPayload(a1, a2, a3, "PVSGeometryProofs", "PVSPRF1")
    end
    return nil, "InvalidGeometryProofSize"
end

v1.FOLDER_NAME = "PVSStaticOcclusion"
v1.MAX_RAW_BYTES = 67108864
return table.freeze(v1)