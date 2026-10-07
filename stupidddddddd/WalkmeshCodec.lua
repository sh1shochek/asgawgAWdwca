-- ReplicatedStorage.MovementV2.Collision.WalkmeshCodec
-- Script path: ReplicatedStorage.MovementV2.Collision.WalkmeshCodec
-- Decompile time: 3.44 ms

local CanonicalGeometry = require(script.Parent.CanonicalGeometry)
local Schema = require(script.Parent.Schema)
local u10 = {}

local function isFinite(a1) -- Line: 27 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 > (-1 / 0) then
            v1 = a1 < (1 / 0)
        end
    end
    return v1
end

function u10.Decode(a1) -- Line: 31 -- upvalues: Schema (val), CanonicalGeometry (val)
    if typeof(a1) ~= "string" then
        return nil, "walkmesh payload must be a string"
    end
    local v1 = #Schema.WalkmeshHeader
    if not (#a1 < v1 + 8) then
        local v2 = string.sub(a1, 1, v1)
        if v2 == Schema.WalkmeshHeader then
            v2 = buffer.fromstring(a1)
            local v3 = buffer.readu32(v2, v1)
            if v3 ~= 0 and not (Schema.MaxWalkmeshVertices < v3) then
                local v4 = v1 + 4
                local v5 = v4 + v3 * 12
                local v6 = v5 + 4
                if #a1 < v6 then
                    return nil, "walkmesh payload ends inside its vertex array"
                end
                v6 = buffer.readu32(v2, v5)
                if v6 ~= 0 and not (Schema.MaxWalkmeshTriangles < v6) then
                    local v7, v8, v9, v10, v11, v12, v13, v14
                    local v15 = v5 + 4
                    local v16 = v15 + v6 * 13
                    if v16 ~= #a1 then
                        return nil, string.format("walkmesh payload has %d bytes; expected exactly %d", #a1, v16)
                    end
                    local v17 = table.create(v3)
                    local v18 = v4
                    for i = 1, v3 do
                        v7 = buffer.readf32(v2, v18)
                        v10 = v18 + 4
                        v8 = buffer.readf32(v2, v10)
                        v11 = v18 + 8
                        v9 = buffer.readf32(v2, v11)
                        v18 = v18 + 12
                        v10 = false
                        if v7 == v7 then
                            v10 = false
                            if v7 > (-1 / 0) then
                                v10 = v7 < (1 / 0)
                            end
                        end
                        if v10 then
                            v10 = false
                            if v8 == v8 then
                                v10 = false
                                if v8 > (-1 / 0) then
                                    v10 = v8 < (1 / 0)
                                end
                            end
                            if v10 then
                                v10 = false
                                if v9 == v9 then
                                    v10 = false
                                    if v9 > (-1 / 0) then
                                        v10 = v9 < (1 / 0)
                                    end
                                end
                                if v10 then
                                    continue
                                end
                            end
                        end
                        return nil, string.format("walkmesh vertex %d contains a non-finite component", i)
                    end
                    local v19 = table.create(v6)
                    v18 = v15
                    for j = 1, v6 do
                        v8 = buffer.readu32(v2, v18)
                        v11 = v18 + 4
                        v9 = buffer.readu32(v2, v11)
                        v12 = v18 + 8
                        v10 = buffer.readu32(v2, v12)
                        v13 = v18 + 12
                        v11 = buffer.readu8(v2, v13)
                        v18 = v18 + 13
                        if not (v8 < 1)
                            and not (v3 < v8)
                            and not (v9 < 1)
                            and not (v3 < v9)
                            and not (v10 < 1)
                            and not (v3 < v10) then
                            if v8 ~= v9 and v9 ~= v10 and v8 ~= v10 then
                                v12 = v17[v8]
                                v13 = v17[v9]
                                v14 = v17[v10]
                                if not ((v13 - v12):Cross(v14 - v12).Magnitude <= 1e-08) then
                                    continue
                                end
                                return nil, string.format("walkmesh triangle %d is degenerate", j)
                            end
                            return nil, string.format("walkmesh triangle %d repeats a vertex index", j)
                        end
                        return nil, string.format("walkmesh triangle %d references a vertex outside [1, %d]", j, v3)
                    end
                    table.freeze(v17)
                    table.freeze(v19)
                    return (table.freeze({
                        Vertices = v17,
                        Triangles = v19,
                        VertexCount = v3,
                        TriangleCount = v6,
                        Fingerprint = CanonicalGeometry.Crc32(a1),
                    })), nil
                end
                return nil, string.format("walkmesh triangle count must be in [1, %d]", Schema.MaxWalkmeshTriangles)
            end
            return nil, string.format("walkmesh vertex count must be in [1, %d]", Schema.MaxWalkmeshVertices)
        end
    end
    return nil, "walkmesh payload is missing the MLWALK1 header"
end

function u10.ReadPublished(a1) -- Line: 122 -- upvalues: Schema (val), u10 (val) -- types: a1: userdata
    local v1, v2 = u10.Decode((a1:GetAttribute(Schema.Attributes.WalkmeshData)))
    if v1 == nil then
        return nil, string.format("%s has invalid %s: %s", a1:GetFullName(), Schema.Attributes.WalkmeshData, v2 or "unknown error")
    end
    return v1, nil
end

return table.freeze(u10)