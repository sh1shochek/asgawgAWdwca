-- ReplicatedStorage.MovementV2.Collision.CanonicalGeometry
-- Script path: ReplicatedStorage.MovementV2.Collision.CanonicalGeometry
-- Decompile time: 7.95 ms

local v1, v2
local Schema = require(script.Parent.Schema)
local u83 = {}
local u53 = table.create(256)
for i = 0, 255 do
    v2 = i
    for j = 1, 8 do
        v1 = bit32.rshift(v2, 1)
        v2 = if bit32.band(v2, 1) == 0 then v1 else bit32.bxor(v1, 3988292384)
    end
    u53[i + 1] = v2
end
table.freeze(u53)

local function updateCrc32(a1, a2) -- Line: 34 -- upvalues: u53 (val) -- types: a1: number, a2: string
    local v1
    local v2 = #a2
    for i = 1, v2 do
        v1 = (bit32.band(bit32.bxor(a1, (string.byte(a2, i))), 255)) + 1
        a1 = bit32.bxor(bit32.rshift(a1, 8), u53[v1])
    end
    return a1
end

local function finishCrc32(a1) -- Line: 43 -- types: a1: number
    return (bit32.bxor(a1, 4294967295))
end

local function isFinite(a1) -- Line: 47
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

local function quantize(a1, a2) -- Line: 51 -- types: a1: number, a2: number
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
    if not v1 then
        return nil, "geometry contains a non-finite component"
    end
    v1 = math.round(a1 * a2)
    if not (v1 < -2147483648) and not (v1 > 2147483647) then
        return if v1 ~= 0 then v1 else 0, nil
    end
    return nil, "geometry component exceeds the signed fixed-point range"
end

local function appendQuantized(a1, a2, a3) -- Line: 63 -- types: a1: table, a2: number, a3: number
    local v1, v2
    local v3 = false
    if typeof(a2) == "number" then
        v3 = false
        if a2 == a2 then
            v3 = false
            if a2 > (-1 / 0) then
                v3 = a2 < (1 / 0)
            end
        end
    end
    if v3 then
        v3 = math.round(a2 * a3)
        if v3 < -2147483648 then
            v1 = nil
            v2 = "geometry component exceeds the signed fixed-point range"
        elseif not (v3 > 2147483647) then
            v1 = if v3 ~= 0 then v3 else 0
            v2 = nil
        else
            v1 = nil
            v2 = "geometry component exceeds the signed fixed-point range"
        end
    else
        v1 = nil
        v2 = "geometry contains a non-finite component"
    end
    if v1 == nil then
        return v2
    end
    a1[#a1 + 1] = v1
    return nil
end

local function encodeRaw(a1, a2) -- Line: 72 -- upvalues: Schema (val), u83 (val) -- types: a1: userdata, a2: vector
    if typeof(a1) == "CFrame" and typeof(a2) == "Vector3" then
        local v1
        local v2 = {a1:GetComponents()}
        local v3 = a2
        for i, v in ipairs(v2) do
            v1 = false
            if typeof(v) == "number" then
                v1 = false
                if v == v then
                    v1 = false
                    if v > (-1 / 0) then
                        v1 = v < (1 / 0)
                    end
                end
            end
            if not v1 then
                return nil, "geometry CFrame contains a non-finite component"
            end
        end
        local X = v3.X
        local v4 = false
        if typeof(X) == "number" then
            v4 = false
            if X == X then
                v4 = false
                if X > (-1 / 0) then
                    v4 = X < (1 / 0)
                end
            end
        end
        if v4 then
            local Y = v3.Y
            v4 = false
            if typeof(Y) == "number" then
                v4 = false
                if Y == Y then
                    v4 = false
                    if Y > (-1 / 0) then
                        v4 = Y < (1 / 0)
                    end
                end
            end
            if v4 then
                local Z = v3.Z
                v4 = false
                if typeof(Z) == "number" then
                    v4 = false
                    if Z == Z then
                        v4 = false
                        if Z > (-1 / 0) then
                            v4 = Z < (1 / 0)
                        end
                    end
                end
                if v4 then
                    if not (v3.X < 0) and not (v3.Y < 0) and not (v3.Z < 0) then
                        local v5, v6, v7, v8, v9, v10
                        local Position = v11.Position
                        local RightVector = v11.RightVector
                        local UpVector = v11.UpVector
                        local v12 = {}
                        for i2, i3 in ipairs({
                            {Position.X, 4096},
                            {Position.Y, 4096},
                            {Position.Z, 4096},
                            {RightVector.X, 4096},
                            {RightVector.Y, 4096},
                            {RightVector.Z, 4096},
                            {UpVector.X, 4096},
                            {UpVector.Y, 4096},
                            {UpVector.Z, 4096},
                            {v3.X, 4096},
                            {v3.Y, 4096},
                            {v3.Z, 4096},
                        }) do
                            v6 = i3[1]
                            v7 = i3[2]
                            v10 = false
                            if typeof(v6) == "number" then
                                v10 = false
                                if v6 == v6 then
                                    v10 = false
                                    if v6 > (-1 / 0) then
                                        v10 = v6 < (1 / 0)
                                    end
                                end
                            end
                            if v10 then
                                v10 = math.round(v6 * v7)
                                if v10 < -2147483648 then
                                    v8 = nil
                                    v9 = "geometry component exceeds the signed fixed-point range"
                                elseif not (v10 > 2147483647) then
                                    v8 = if v10 ~= 0 then v10 else 0
                                    v9 = nil
                                else
                                    v8 = nil
                                    v9 = "geometry component exceeds the signed fixed-point range"
                                end
                            else
                                v8 = nil
                                v9 = "geometry contains a non-finite component"
                            end
                            if v8 ~= nil then
                                v12[#v12 + 1] = v8
                                v5 = nil
                            else
                                v5 = v9
                            end
                            if v5 ~= nil then
                                return nil, v5
                            end
                        end
                        v1 = table.create(13)
                        v1[1] = Schema.CanonicalGeometryVersion
                        for i4, j in ipairs(v12) do
                            v1[i4 + 1] = (tostring(j))
                        end
                        local v13 = table.concat(v1, "|")
                        return (string.format("%s|%08x", v13, (u83.Crc32(v13)))), nil
                    end
                    return nil, "geometry size cannot be negative"
                end
            end
        end
        return nil, "geometry size contains a non-finite component"
    end
    return nil, "geometry requires a CFrame and Vector3 size"
end

local function parseCanonicalInteger(a1) -- Line: 125 -- types: a1: string?
    if a1 ~= nil and string.match(a1, "^%-?%d+$") ~= nil and a1 ~= "-0" then
        local v1 = tonumber(a1)
        if v1 ~= nil and v1 % 1 == 0 and not (v1 < -2147483648) and not (v1 > 2147483647) then
            if tostring(v1) ~= a1 then
                return nil
            end
            return v1
        end
        return nil
    end
    return nil
end

function u83.Crc32(a1) -- Line: 139 -- upvalues: updateCrc32 (val) -- types: a1: string
    assert(typeof(a1) == "string", "CRC32 input must be a string")
    return (bit32.bxor(updateCrc32(4294967295, a1), 4294967295))
end

function u83.HashStrings(a1) -- Line: 144 -- upvalues: updateCrc32 (val) -- types: a1: table
    local v1
    local v2 = table.clone(a1)
    table.sort(v2)
    local v3 = 4294967295
    for i, v in ipairs(v2) do
        assert(typeof(v) == "string", "fingerprint entries must be strings")
        v1 = #v
        assert(v1 <= 4294967295, "fingerprint entry is too large")
        v3 = updateCrc32(v3, (string.char(
            bit32.band(v1, 255),
            bit32.band(bit32.rshift(v1, 8), 255),
            bit32.band(bit32.rshift(v1, 16), 255),
            (bit32.band(bit32.rshift(v1, 24), 255))
        )))
        v3 = updateCrc32(v3, v)
    end
    return (bit32.bxor(v3, 4294967295))
end

function u83.TryEncode(a1, a2) -- Line: 165 -- upvalues: encodeRaw (val) -- types: a1: userdata, a2: vector
    return encodeRaw(a1, a2)
end

function u83.Encode(a1, a2) -- Line: 169 -- upvalues: encodeRaw (val) -- types: a1: userdata, a2: vector
    local v1, v2 = encodeRaw(a1, a2)
    assert(v1 ~= nil, v2)
    return v1
end

function u83.Decode(a1) -- Line: 175 -- upvalues: Schema (val), u83 (val), parseCanonicalInteger (val)
    if typeof(a1) ~= "string" then
        return nil, "canonical geometry descriptor must be a string"
    end
    local v1 = string.split(a1, "|")
    if #v1 == 14 and v1[1] == Schema.CanonicalGeometryVersion then
        local v2 = v1[14]
        if #v2 == 8 and string.match(v2, "^%x+$") ~= nil and v2 == string.lower(v2) then
            local v3 = tonumber(v2, 16)
            local v4 = string.sub(a1, 1, #a1 - 9)
            if v3 ~= nil and u83.Crc32(v4) == v3 then
                local v5
                local v6 = table.create(12)
                for i = 1, 12 do
                    v5 = parseCanonicalInteger(v1[i + 1])
                    if v5 == nil then
                        return nil, string.format("canonical geometry field %d is not a canonical i32", i)
                    end
                    v6[i] = v5
                end
                if not (v6[10] < 0) and not (v6[11] < 0) and not (v6[12] < 0) then
                    local v7 = Vector3.new(v6[1], v6[2], v6[3]) / 4096
                    local v8 = Vector3.new(v6[4], v6[5], v6[6]) / 4096
                    local v9 = Vector3.new(v6[7], v6[8], v6[9]) / 4096
                    local Magnitude = v8.Magnitude
                    local Magnitude_2 = v9.Magnitude
                    if not (0.01 < (math.abs(Magnitude - 1))) and not (0.01 < (math.abs(Magnitude_2 - 1))) then
                        if 0.01 < (math.abs((v8:Dot(v9)))) then
                            return nil, "canonical geometry axes are not orthogonal"
                        end
                        local Unit = v8.Unit
                        local v10 = v9 - Unit * v9:Dot(Unit)
                        if v10.Magnitude <= 0.5 then
                            return nil, "canonical geometry axes are degenerate"
                        end
                        local Unit_3 = Unit:Cross(v10.Unit).Unit
                        local Unit_4 = Unit_3:Cross(Unit).Unit
                        local v11 = Vector3.new(v6[10], v6[11], v6[12]) / 4096
                        return (table.freeze({
                            CFrame = CFrame.fromMatrix(v7, Unit, Unit_4, Unit_3),
                            Size = v11,
                            Descriptor = a1,
                        })), nil
                    end
                    return nil, "canonical geometry axes are not unit length"
                end
                return nil, "canonical geometry size cannot be negative"
            end
            return nil, "canonical geometry descriptor CRC does not match"
        end
        return nil, "canonical geometry descriptor has an invalid CRC field"
    end
    return nil, "canonical geometry descriptor has an unsupported shape or version"
end

function u83.EncodeInstance(a1) -- Line: 238 -- upvalues: u83 (val) -- types: a1: userdata
    if a1:IsA("BasePart") then
        return u83.Encode(a1.CFrame, a1.Size)
    end
    if a1:IsA("Model") then
        return u83.Encode(a1:GetPivot(), (Vector3.new(0, 0, 0)))
    end
    error("canonical geometry can only be encoded for a BasePart or Model", 2)
end

function u83.Publish(a1) -- Line: 248 -- upvalues: u83 (val), Schema (val) -- types: a1: userdata
    local v1 = u83.EncodeInstance(a1)
    a1:SetAttribute(Schema.Attributes.CanonicalGeometry, v1)
    return v1
end

function u83.ReadPublished(a1) -- Line: 254 -- upvalues: Schema (val), u83 (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute(Schema.Attributes.CanonicalGeometry)
    if typeof(Attribute) ~= "string" then
        return nil, string.format("%s is missing %s", a1:GetFullName(), Schema.Attributes.CanonicalGeometry)
    end
    local v1, v2 = u83.Decode(Attribute)
    if v1 == nil then
        return nil, string.format("%s has invalid canonical geometry: %s", a1:GetFullName(), v2 or "unknown error")
    end
    return v1, nil
end

return table.freeze(u83)