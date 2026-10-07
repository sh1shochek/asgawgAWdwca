-- ReplicatedStorage.Visibility.StaticOcclusionCodec
-- Script path: ReplicatedStorage.Visibility.StaticOcclusionCodec
-- Decompile time: 36.70 ms

local v1 = {}

local function finite(a1) -- Line: 112 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 > (-1 / 0) then
            v1 = a1 < (1 / 0)
        end
    end
    return v1
end

local function finiteVector(a1) -- Line: 116 -- types: a1: vector
    local X = a1.X
    local v1 = false
    if X == X then
        v1 = false
        if X > (-1 / 0) then
            v1 = X < (1 / 0)
        end
    end
    if v1 then
        local Y = a1.Y
        v1 = false
        if Y == Y then
            v1 = false
            if Y > (-1 / 0) then
                v1 = Y < (1 / 0)
            end
        end
        if v1 then
            local Z = a1.Z
            v1 = false
            if Z == Z then
                v1 = false
                if Z > (-1 / 0) then
                    v1 = Z < (1 / 0)
                end
            end
        end
    end
    return v1
end

local function writeVector(a1, a2, a3) -- Line: 120 -- types: a1: buffer, a2: number, a3: vector
    local X = a3.X
    buffer.writef32(a1, a2, X)
    local v1 = a2 + 4
    local Y = a3.Y
    buffer.writef32(a1, v1, Y)
    v1 = a2 + 8
    local Z = a3.Z
    buffer.writef32(a1, v1, Z)
end

local function readVector(a1, a2) -- Line: 126 -- types: a1: buffer, a2: number
    return (Vector3.new(buffer.readf32(a1, a2), buffer.readf32(a1, a2 + 4), (buffer.readf32(a1, a2 + 8))))
end

local function boundsContain(a1, a2, a3, a4) -- Line: 134 -- types: a1: vector, a2: vector, a3: vector, a4: vector
    local v1 = false
    local X = a3.X
    if a1.X - 0.125 <= X then
        v1 = false
        local Y = a3.Y
        if a1.Y - 0.125 <= Y then
            v1 = false
            local Z = a3.Z
            if a1.Z - 0.125 <= Z then
                v1 = false
                if a4.X <= a2.X + 0.125 then
                    v1 = false
                    if a4.Y <= a2.Y + 0.125 then
                        v1 = a4.Z <= a2.Z + 0.125
                    end
                end
            end
        end
    end
    return v1
end

local function boundsContainPoint(a1, a2, a3) -- Line: 148 -- types: a1: vector, a2: vector, a3: vector
    local v1 = false
    local X = a3.X
    if a1.X - 0.125 <= X then
        v1 = false
        local Y = a3.Y
        if a1.Y - 0.125 <= Y then
            v1 = false
            local Z = a3.Z
            if a1.Z - 0.125 <= Z then
                v1 = false
                if a3.X <= a2.X + 0.125 then
                    v1 = false
                    if a3.Y <= a2.Y + 0.125 then
                        v1 = a3.Z <= a2.Z + 0.125
                    end
                end
            end
        end
    end
    return v1
end

local function payloadHash(a1, a2, a3) -- Line: 157 -- types: a1: buffer, a2: number, a3: function?
    local v1, v2
    local v3 = 5381
    local v4 = buffer.len(a1) - 1
    local v5 = a3
    for i = a2, v4, 65536 do
        if v5 then
            v5()
        end
        v2 = math.min(i + 65535, (buffer.len(v1)) - 1)
        for j = i, v2 do
            v3 = bit32.band(v3 * 33 + buffer.readu8(v1, j), 4294967295)
        end
    end
    return v3
end

local function checkedCount(a1, a2, a3) -- Line: 170 -- types: a1: number, a2: string, a3: number?
    if a1 < 0 or (a3 or 2000000) < a1 or a1 % 1 ~= 0 then
        error((("PVBVH1 has invalid %*"):format(a2)))
    end
end

function v1.encode(a1) -- Line: 176 -- upvalues: payloadHash (val) -- types: a1: table
    local X_10, X_11, X_12, X_13, X_14, X_15, X_16, X_6, X_7, X_8, X_9, Y_10, Y_11, Y_12, Y_13, Y_14, Y_15, Y_16, Y_6, Y_7, Y_8, Y_9, Z_10, Z_11, Z_12, Z_13, Z_14, Z_15, Z_16, Z_6, Z_7, Z_8, Z_9, a, b, c, candidateCount, firstCandidate, firstRectangle, firstTriangle, maximumU, maximumV, maximum_3, maximum_4, minimumU, minimumV, minimum_6, minimum_7, normal, origin, pairKey, primitive, primitive_2, rectangleCount, reference, triangleCount, u, v, v1, v2, v3, v4, v5, v6, v7, v8
    local v9 = #a1.fingerprint
    if v9 == 0 or v9 > 65535 then
        error("PVBVH1 fingerprint length is invalid")
    end
    local v10 = #a1.nodes
    if v10 < 0 or v10 > 2000000 or v10 % 1 ~= 0 then
        error("PVBVH1 has invalid node count")
    end
    v10 = #a1.leaves
    if v10 < 0 or v10 > 2000000 or v10 % 1 ~= 0 then
        error("PVBVH1 has invalid leaf count")
    end
    v10 = #a1.triangles
    if v10 < 0 or v10 > 2000000 or v10 % 1 ~= 0 then
        error("PVBVH1 has invalid triangle count")
    end
    v10 = #a1.planes
    if v10 < 0 or v10 > 2000000 or v10 % 1 ~= 0 then
        error("PVBVH1 has invalid plane count")
    end
    v10 = #a1.rectangles
    if v10 < 0 or v10 > 2000000 or v10 % 1 ~= 0 then
        error("PVBVH1 has invalid rectangle count")
    end
    v10 = #a1.certificates
    if v10 < 0 or v10 > 2000000 or v10 % 1 ~= 0 then
        error("PVBVH1 has invalid certificate count")
    end
    v10 = #a1.candidates
    if v10 < 0 or v10 > 2000000 or v10 % 1 ~= 0 then
        error("PVBVH1 has invalid candidate count")
    end
    if #a1.nodes == 0 or a1.rootNode < 1 then
        error("PVBVH1 root node is invalid")
    else
        local rootNode = a1.rootNode
        if #a1.nodes < rootNode then
            error("PVBVH1 root node is invalid")
        end
    end
    local minimum = a1.worldBounds.minimum
    local X = minimum.X
    v10 = false
    if X == X then
        v10 = false
        if X > (-1 / 0) then
            v10 = X < (1 / 0)
        end
    end
    if v10 then
        local Y = minimum.Y
        v10 = false
        if Y == Y then
            v10 = false
            if Y > (-1 / 0) then
                v10 = Y < (1 / 0)
            end
        end
        if v10 then
            local Z = minimum.Z
            v10 = false
            if Z == Z then
                v10 = false
                if Z > (-1 / 0) then
                    v10 = Z < (1 / 0)
                end
            end
        end
    end
    if not v10 then
        error("PVBVH1 world bounds are invalid")
    else
        local maximum = a1.worldBounds.maximum
        local X_2 = maximum.X
        v10 = false
        if X_2 == X_2 then
            v10 = false
            if X_2 > (-1 / 0) then
                v10 = X_2 < (1 / 0)
            end
        end
        if v10 then
            local Y_2 = maximum.Y
            v10 = false
            if Y_2 == Y_2 then
                v10 = false
                if Y_2 > (-1 / 0) then
                    v10 = Y_2 < (1 / 0)
                end
            end
            if v10 then
                local Z_2 = maximum.Z
                v10 = false
                if Z_2 == Z_2 then
                    v10 = false
                    if Z_2 > (-1 / 0) then
                        v10 = Z_2 < (1 / 0)
                    end
                end
            end
        end
        if not v10
            or a1.worldBounds.maximum.X < a1.worldBounds.minimum.X
            or a1.worldBounds.maximum.Y < a1.worldBounds.minimum.Y
            or a1.worldBounds.maximum.Z < a1.worldBounds.minimum.Z then
            error("PVBVH1 world bounds are invalid")
        end
    end
    v10 = v9 + #a1.nodes * 224 + #a1.leaves * 8 + #a1.triangles * 40 + #a1.planes * 56 + #a1.rectangles * 20 + #a1.certificates * 12 + #a1.candidates * 2
    local v11 = buffer.create(v10 + 80)
    buffer.writestring(v11, 0, "PVBVH1\000\000")
    buffer.writeu16(v11, 8, 2)
    buffer.writeu16(v11, 10, 0)
    local v12 = #a1.nodes
    buffer.writeu32(v11, 12, v12)
    v12 = #a1.leaves
    buffer.writeu32(v11, 16, v12)
    v12 = #a1.triangles
    buffer.writeu32(v11, 20, v12)
    v12 = #a1.planes
    buffer.writeu32(v11, 24, v12)
    v12 = #a1.rectangles
    buffer.writeu32(v11, 28, v12)
    buffer.writeu16(v11, 32, v9)
    buffer.writeu16(v11, 34, 0)
    local rootNode_2 = a1.rootNode
    buffer.writeu32(v11, 36, rootNode_2)
    buffer.writeu32(v11, 40, 0)
    buffer.writeu32(v11, 44, v10)
    local minimum_5 = a1.worldBounds.minimum
    local X_4 = minimum_5.X
    buffer.writef32(v11, 48, X_4)
    local Y_4 = minimum_5.Y
    buffer.writef32(v11, 52, Y_4)
    local Z_4 = minimum_5.Z
    buffer.writef32(v11, 56, Z_4)
    local maximum_2 = a1.worldBounds.maximum
    local X_5 = maximum_2.X
    buffer.writef32(v11, 60, X_5)
    local Y_5 = maximum_2.Y
    buffer.writef32(v11, 64, Y_5)
    local Z_5 = maximum_2.Z
    buffer.writef32(v11, 68, Z_5)
    v12 = #a1.certificates
    buffer.writeu32(v11, 72, v12)
    v12 = #a1.candidates
    buffer.writeu32(v11, 76, v12)
    local v13 = 80
    buffer.writestring(v11, v13, a1.fingerprint)
    v13 = v13 + v9
    local v14 = nil
    v12 = nil
    for i, j in a1.nodes, v14, v12 do
        if #j.children > 8 then
            error("PVBVH1 node has more than eight children")
        end
        v1 = v13
        for k = 1, 8 do
            v3 = j.children[k]
            v4 = v1 + (k - 1) * 24
            if v3 == nil then
                buffer.writef32(v11, v4, 0)
                v6 = v4 + 4
                buffer.writef32(v11, v6, 0)
                v6 = v4 + 8
                buffer.writef32(v11, v6, 0)
                v5 = v4 + 12
                buffer.writef32(v11, v5, 0)
                v7 = v5 + 4
                buffer.writef32(v11, v7, 0)
                v7 = v5 + 8
                buffer.writef32(v11, v7, 0)
                v6 = v1 + 192 + (k - 1) * 4
                buffer.writei32(v11, v6, 0)
            else
                minimum_6 = v3.minimum
                X_13 = minimum_6.X
                v5 = false
                if X_13 == X_13 then
                    v5 = false
                    if X_13 > (-1 / 0) then
                        v5 = X_13 < (1 / 0)
                    end
                end
                if v5 then
                    Y_13 = minimum_6.Y
                    v5 = false
                    if Y_13 == Y_13 then
                        v5 = false
                        if Y_13 > (-1 / 0) then
                            v5 = Y_13 < (1 / 0)
                        end
                    end
                    if v5 then
                        Z_13 = minimum_6.Z
                        v5 = false
                        if Z_13 == Z_13 then
                            v5 = false
                            if Z_13 > (-1 / 0) then
                                v5 = Z_13 < (1 / 0)
                            end
                        end
                    end
                end
                if not v5 then
                    error("PVBVH1 child bounds are not finite")
                else
                    maximum_3 = v3.maximum
                    X_14 = maximum_3.X
                    v5 = false
                    if X_14 == X_14 then
                        v5 = false
                        if X_14 > (-1 / 0) then
                            v5 = X_14 < (1 / 0)
                        end
                    end
                    if v5 then
                        Y_14 = maximum_3.Y
                        v5 = false
                        if Y_14 == Y_14 then
                            v5 = false
                            if Y_14 > (-1 / 0) then
                                v5 = Y_14 < (1 / 0)
                            end
                        end
                        if v5 then
                            Z_14 = maximum_3.Z
                            v5 = false
                            if Z_14 == Z_14 then
                                v5 = false
                                if Z_14 > (-1 / 0) then
                                    v5 = Z_14 < (1 / 0)
                                end
                            end
                        end
                    end
                    if not v5 then
                        error("PVBVH1 child bounds are not finite")
                    end
                end
                minimum_7 = v3.minimum
                X_15 = minimum_7.X
                buffer.writef32(v11, v4, X_15)
                v7 = v4 + 4
                Y_15 = minimum_7.Y
                buffer.writef32(v11, v7, Y_15)
                v7 = v4 + 8
                Z_15 = minimum_7.Z
                buffer.writef32(v11, v7, Z_15)
                v5 = v4 + 12
                maximum_4 = v3.maximum
                X_16 = maximum_4.X
                buffer.writef32(v11, v5, X_16)
                v8 = v5 + 4
                Y_16 = maximum_4.Y
                buffer.writef32(v11, v8, Y_16)
                v8 = v5 + 8
                Z_16 = maximum_4.Z
                buffer.writef32(v11, v8, Z_16)
                v6 = v1 + 192 + (k - 1) * 4
                reference = v3.reference
                buffer.writei32(v11, v6, reference)
            end
        end
        v13 = v13 + 224
    end
    for n, m in a1.leaves do
        firstTriangle = m.firstTriangle
        buffer.writeu32(v11, v13, firstTriangle)
        v2 = v13 + 4
        triangleCount = m.triangleCount
        buffer.writeu16(v11, v2, triangleCount)
        v2 = v13 + 6
        buffer.writeu16(v11, v2, 0)
        v13 = v13 + 8
    end
    for i5, i6 in a1.triangles do
        a = i6.a
        X_10 = a.X
        buffer.writef32(v11, v13, X_10)
        v3 = v13 + 4
        Y_10 = a.Y
        buffer.writef32(v11, v3, Y_10)
        v3 = v13 + 8
        Z_10 = a.Z
        buffer.writef32(v11, v3, Z_10)
        v1 = v13 + 12
        b = i6.b
        X_11 = b.X
        buffer.writef32(v11, v1, X_11)
        v3 = v1 + 4
        Y_11 = b.Y
        buffer.writef32(v11, v3, Y_11)
        v3 = v1 + 8
        Z_11 = b.Z
        buffer.writef32(v11, v3, Z_11)
        v1 = v13 + 24
        c = i6.c
        X_12 = c.X
        buffer.writef32(v11, v1, X_12)
        v3 = v1 + 4
        Y_12 = c.Y
        buffer.writef32(v11, v3, Y_12)
        v3 = v1 + 8
        Z_12 = c.Z
        buffer.writef32(v11, v3, Z_12)
        v2 = v13 + 36
        primitive_2 = i6.primitive
        buffer.writeu32(v11, v2, primitive_2)
        v13 = v13 + 40
    end
    for i7, i8 in a1.planes do
        origin = i8.origin
        X_6 = origin.X
        buffer.writef32(v11, v13, X_6)
        v3 = v13 + 4
        Y_6 = origin.Y
        buffer.writef32(v11, v3, Y_6)
        v3 = v13 + 8
        Z_6 = origin.Z
        buffer.writef32(v11, v3, Z_6)
        v1 = v13 + 12
        u = i8.u
        X_7 = u.X
        buffer.writef32(v11, v1, X_7)
        v3 = v1 + 4
        Y_7 = u.Y
        buffer.writef32(v11, v3, Y_7)
        v3 = v1 + 8
        Z_7 = u.Z
        buffer.writef32(v11, v3, Z_7)
        v1 = v13 + 24
        v = i8.v
        X_8 = v.X
        buffer.writef32(v11, v1, X_8)
        v3 = v1 + 4
        Y_8 = v.Y
        buffer.writef32(v11, v3, Y_8)
        v3 = v1 + 8
        Z_8 = v.Z
        buffer.writef32(v11, v3, Z_8)
        v1 = v13 + 36
        normal = i8.normal
        X_9 = normal.X
        buffer.writef32(v11, v1, X_9)
        v3 = v1 + 4
        Y_9 = normal.Y
        buffer.writef32(v11, v3, Y_9)
        v3 = v1 + 8
        Z_9 = normal.Z
        buffer.writef32(v11, v3, Z_9)
        v2 = v13 + 48
        firstRectangle = i8.firstRectangle
        buffer.writeu32(v11, v2, firstRectangle)
        v2 = v13 + 52
        rectangleCount = i8.rectangleCount
        buffer.writeu16(v11, v2, rectangleCount)
        v2 = v13 + 54
        buffer.writeu16(v11, v2, 0)
        v13 = v13 + 56
    end
    for i9, i10 in a1.rectangles do
        minimumU = i10.minimumU
        buffer.writef32(v11, v13, minimumU)
        v2 = v13 + 4
        maximumU = i10.maximumU
        buffer.writef32(v11, v2, maximumU)
        v2 = v13 + 8
        minimumV = i10.minimumV
        buffer.writef32(v11, v2, minimumV)
        v2 = v13 + 12
        maximumV = i10.maximumV
        buffer.writef32(v11, v2, maximumV)
        v2 = v13 + 16
        primitive = i10.primitive
        buffer.writeu32(v11, v2, primitive)
        v13 = v13 + 20
    end
    for i11, i12 in a1.certificates do
        pairKey = i12.pairKey
        buffer.writeu32(v11, v13, pairKey)
        v2 = v13 + 4
        firstCandidate = i12.firstCandidate
        buffer.writeu32(v11, v2, firstCandidate)
        v2 = v13 + 8
        candidateCount = i12.candidateCount
        buffer.writeu16(v11, v2, candidateCount)
        v2 = v13 + 10
        buffer.writeu16(v11, v2, 0)
        v13 = v13 + 12
    end
    v14 = nil
    v12 = nil
    for i13, i14 in a1.candidates, v14, v12 do
        if i14 < 1 or #a1.planes < i14 or i14 > 65535 then
            error("PVBVH1 certificate candidate is invalid")
        end
        buffer.writeu16(v11, v13, i14)
        v13 = v13 + 2
    end
    assert(v13 == buffer.len(v11), "PVBVH1 encoder size drift")
    local v15 = payloadHash(v11, 80)
    buffer.writeu32(v11, 40, v15)
    return buffer.tostring(v11)
end

local function readTriangle(a1, a2) -- Line: 304 -- types: a1: table, a2: number
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
    local buffer_2 = a1.buffer
    local v11 = a1.triangleOffset + (a2 - 1) * a1.triangleSize
    if a1.version ~= 3 then
        v6 = buffer.readf32(buffer_2, v11)
        v9 = v11 + 4
        v7 = buffer.readf32(buffer_2, v9)
        v10 = v11 + 8
        v5 = Vector3.new(v6, v7, (buffer.readf32(buffer_2, v10)))
        v7 = v11 + 12
        v9 = buffer.readf32(buffer_2, v7)
        v2 = v7 + 4
        v10 = buffer.readf32(buffer_2, v2)
        v3 = v7 + 8
        v6 = Vector3.new(v9, v10, (buffer.readf32(buffer_2, v3)))
        v8 = v11 + 24
        v10 = buffer.readf32(buffer_2, v8)
        v3 = v8 + 4
        v1 = buffer.readf32(buffer_2, v3)
        v4 = v8 + 8
        v7 = Vector3.new(v10, v1, (buffer.readf32(buffer_2, v4)))
        v10 = v11 + 36
        return v5, v6, v7, (buffer.readu32(buffer_2, v10))
    end
    v5 = buffer.readu32(buffer_2, v11)
    v8 = v11 + 4
    v6 = buffer.readu32(buffer_2, v8)
    v9 = v11 + 8
    v7 = buffer.readu32(buffer_2, v9)
    v9 = a1.vertexOffset + (v5 - 1) * 12
    v1 = buffer.readf32(buffer_2, v9)
    v4 = v9 + 4
    v2 = buffer.readf32(buffer_2, v4)
    local v12 = v9 + 8
    v8 = Vector3.new(v1, v2, (buffer.readf32(buffer_2, v12)))
    v10 = a1.vertexOffset + (v6 - 1) * 12
    v2 = buffer.readf32(buffer_2, v10)
    v12 = v10 + 4
    v3 = buffer.readf32(buffer_2, v12)
    local v13 = v10 + 8
    v9 = Vector3.new(v2, v3, (buffer.readf32(buffer_2, v13)))
    v1 = a1.vertexOffset + (v7 - 1) * 12
    v3 = buffer.readf32(buffer_2, v1)
    v13 = v1 + 4
    v4 = buffer.readf32(buffer_2, v13)
    local v14 = v1 + 8
    return v8, v9, Vector3.new(v3, v4, (buffer.readf32(buffer_2, v14))), 0
end

function v1.referencedPrimitives(a1) -- Line: 323 -- types: a1: table
    local v1
    local v2 = {}
    if a1.version == 3 then
        if 0 < a1.triangleCount then
            v2[0] = true
        end
        return v2
    end
    local buffer_2 = a1.buffer
    local triangleCount = a1.triangleCount
    for i = 1, triangleCount do
        v1 = a1.triangleOffset + (i - 1) * a1.triangleSize + 36
        v2[(buffer.readu32(buffer_2, v1))] = true
    end
    return v2
end

function v1.validateExactGeometry(a1) -- Line: 339 -- types: a1: table
    if a1.planeCount == 0 and a1.rectangleCount == 0 and a1.certificateCount == 0 and a1.candidateCount == 0 then
        if a1.version ~= 3 then
            local v1
            local buffer_2 = a1.buffer
            local triangleCount = a1.triangleCount
            for i = 1, triangleCount do
                v1 = a1.triangleOffset + (i - 1) * a1.triangleSize + 36
                if buffer.readu32(buffer_2, v1) ~= 0 then
                    return false, "ExactPVBVHHasOwnedPrimitive"
                end
            end
        end
        return true, nil
    end
    return false, "ExactPVBVHContainsLegacyRecords"
end

local function validateHierarchy(a1, a2) -- Line: 356
    -- upvalues: boundsContain (val), readTriangle (val), boundsContainPoint (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18
    local buffer_2 = a1.buffer
    local v19 = buffer.create(a1.nodeCount)
    local v20 = buffer.create(a1.leafCount)
    local v21 = buffer.create(a1.triangleCount)
    local v22 = table.create(math.min(a1.nodeCount, 1024), 0)
    local v23 = table.create(math.min(a1.nodeCount, 1024), (Vector3.new(0, 0, 0)))
    local v24 = table.create(math.min(a1.nodeCount, 1024), (Vector3.new(0, 0, 0)))
    local v25 = 1
    local v26 = 1
    local v27 = 0
    local v28 = 0
    v22[1] = a1.rootNode
    v23[1] = a1.worldBounds.minimum
    v24[1] = a1.worldBounds.maximum
    local v29 = a1.rootNode - 1
    buffer.writeu8(v19, v29, 1)
    local v30, v31 = a2, a1
    while v25 > 0 do
        if v30 then
            v30()
        end
        v1 = v22[v25]
        v2 = v23[v25]
        v29 = v24[v25]
        v25 = v25 - 1
        v3 = v31.nodeOffset + (v1 - 1) * 224
        v4 = 0
        for i = 1, 8 do
            v7 = v3 + 192 + (i - 1) * 4
            v5 = buffer.readi32(buffer_2, v7)
            if v5 ~= 0 then
                v4 = v4 + 1
                v6 = v3 + (i - 1) * 24
                v8 = buffer.readf32(buffer_2, v6)
                v11 = v6 + 4
                v9 = buffer.readf32(buffer_2, v11)
                v12 = v6 + 8
                v7 = Vector3.new(v8, v9, (buffer.readf32(buffer_2, v12)))
                v9 = v6 + 12
                v11 = buffer.readf32(buffer_2, v9)
                v14 = v9 + 4
                v12 = buffer.readf32(buffer_2, v14)
                v15 = v9 + 8
                v8 = Vector3.new(v11, v12, (buffer.readf32(buffer_2, v15)))
                if not boundsContain(v2, v29, v7, v8) then
                    error("PVBVH1 child bounds escape their parent")
                end
                if not (v5 > 0) then
                    v9 = -v5
                    v12 = v9 - 1
                    if buffer.readu8(v20, v12) ~= 0 then
                        error("PVBVH1 leaf has multiple parents")
                    end
                    v12 = v9 - 1
                    buffer.writeu8(v20, v12, 1)
                    v27 = v27 + 1
                    v10 = v31.leafOffset + (v9 - 1) * 8
                    v11 = buffer.readu32(buffer_2, v10)
                    v14 = v10 + 4
                    v13 = v11 + buffer.readu16(buffer_2, v14) - 1
                    for j = v11, v13 do
                        v18 = j - 1
                        if buffer.readu8(v21, v18) ~= 0 then
                            error("PVBVH1 leaf triangle ranges overlap")
                        end
                        v18 = j - 1
                        buffer.writeu8(v21, v18, 1)
                        v28 = v28 + 1
                        v16, v17, v18 = readTriangle(v31, j)
                        if not boundsContainPoint(v7, v8, v16)
                            or not boundsContainPoint(v7, v8, v17)
                            or not boundsContainPoint(v7, v8, v18) then
                            error("PVBVH1 triangle escapes its leaf bounds")
                        end
                    end
                else
                    v11 = v5 - 1
                    if buffer.readu8(v19, v11) ~= 0 then
                        error("PVBVH1 node graph is cyclic or has multiple parents")
                    end
                    v11 = v5 - 1
                    buffer.writeu8(v19, v11, 1)
                    v26 = v26 + 1
                    v25 = v25 + 1
                    v22[v25] = v5
                    v23[v25] = v7
                    v24[v25] = v8
                end
            end
        end
        if v4 == 0 then
            error("PVBVH1 reachable node is empty")
        end
    end
    if v26 ~= v31.nodeCount then
        error("PVBVH1 contains unreachable nodes")
    end
    if v27 ~= v31.leafCount then
        error("PVBVH1 contains unreachable leaves")
    end
    if v28 ~= v31.triangleCount then
        error("PVBVH1 leaf ranges do not cover every triangle")
    end
end

function v1.decode(a1, a2) -- Line: 450
    -- upvalues: payloadHash (val), validateHierarchy (val)
    local X_4, X_5, Y_4, Y_5, Z_4, Z_5, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
    local v16 = buffer.fromstring(a1)
    if (buffer.len(v16)) < 80 or buffer.readstring(v16, 0, 8) ~= "PVBVH1\000\000" then
        error("PVBVH1 magic is invalid")
    end
    local v17 = buffer.readu16(v16, 8)
    if v17 == 2 then
        if buffer.readu16(v16, 10) ~= 0 then
            error("PVBVH1 version or flags are unsupported")
        end
    elseif v17 ~= 3 or buffer.readu16(v16, 10) ~= 0 then
        error("PVBVH1 version or flags are unsupported")
    end
    local v18 = v17 == 3
    local v19 = buffer.readu32(v16, 12)
    local v20 = buffer.readu32(v16, 16)
    local v21 = buffer.readu32(v16, 20)
    local v22 = buffer.readu32(v16, 24)
    local v23 = if not v18 then 0 else v22
    local v24 = if not v18 then v22 else 0
    local v25 = buffer.readu32(v16, 28)
    local v26 = buffer.readu32(v16, 72)
    local v27 = buffer.readu32(v16, 76)
    local v28 = buffer.readu16(v16, 32)
    local v29 = buffer.readu32(v16, 36)
    local v30 = buffer.readu32(v16, 40)
    local v31 = buffer.readu32(v16, 44)
    if v19 < 0 or v19 > 2000000 or v19 % 1 ~= 0 then
        error("PVBVH1 has invalid node count")
    end
    if v20 < 0 or v20 > 2000000 or v20 % 1 ~= 0 then
        error("PVBVH1 has invalid leaf count")
    end
    if v21 < 0 or v21 > 2000000 or v21 % 1 ~= 0 then
        error("PVBVH1 has invalid triangle count")
    end
    if v23 < 0 or v23 > 6000000 or v23 % 1 ~= 0 then
        error("PVBVH1 has invalid vertex count")
    end
    if v24 < 0 or v24 > 2000000 or v24 % 1 ~= 0 then
        error("PVBVH1 has invalid plane count")
    end
    if v25 < 0 or v25 > 2000000 or v25 % 1 ~= 0 then
        error("PVBVH1 has invalid rectangle count")
    end
    if v26 < 0 or v26 > 2000000 or v26 % 1 ~= 0 then
        error("PVBVH1 has invalid certificate count")
    end
    if v27 < 0 or v27 > 2000000 or v27 % 1 ~= 0 then
        error("PVBVH1 has invalid candidate count")
    end
    if v19 == 0 or v29 < 1 or v19 < v29 or v28 == 0 then
        error("PVBVH1 root or fingerprint is invalid")
    elseif v18 then
        if v20 == 0 or v21 == 0 or v23 == 0 then
            error("PVBVH1 root or fingerprint is invalid")
        end
    end
    if v18 then
        if v25 ~= 0 or v26 ~= 0 or v27 ~= 0 then
            error("PVBVH1 v3 is reserved for indexed ExactGeometryV1 payloads")
        end
    end
    local v32 = v28 + v19 * 224 + v20 * 8 + v23 * 12
    local v33 = v32 + v21 * (if not v18 then 40 else 12) + v24 * 56 + v25 * 20 + v26 * 12 + v27 * 2
    if v31 ~= v33 or (buffer.len(v16)) ~= v33 + 80 then
        error("PVBVH1 payload size is invalid")
    end
    if payloadHash(v16, 80, a2) ~= v30 then
        error("PVBVH1 payload checksum mismatch")
    end
    local v34 = Vector3.new(buffer.readf32(v16, 48), buffer.readf32(v16, 52), (buffer.readf32(v16, 56)))
    local v35 = Vector3.new(buffer.readf32(v16, 60), buffer.readf32(v16, 64), (buffer.readf32(v16, 68)))
    local X = v34.X
    local v36 = false
    if X == X then
        v36 = false
        if X > (-1 / 0) then
            v36 = X < (1 / 0)
        end
    end
    if v36 then
        local Y = v34.Y
        v36 = false
        if Y == Y then
            v36 = false
            if Y > (-1 / 0) then
                v36 = Y < (1 / 0)
            end
        end
        if v36 then
            local Z = v34.Z
            v36 = false
            if Z == Z then
                v36 = false
                if Z > (-1 / 0) then
                    v36 = Z < (1 / 0)
                end
            end
        end
    end
    if not v36 then
        error("PVBVH1 world bounds are invalid")
    else
        local X_2 = v35.X
        v36 = false
        if X_2 == X_2 then
            v36 = false
            if X_2 > (-1 / 0) then
                v36 = X_2 < (1 / 0)
            end
        end
        if v36 then
            local Y_2 = v35.Y
            v36 = false
            if Y_2 == Y_2 then
                v36 = false
                if Y_2 > (-1 / 0) then
                    v36 = Y_2 < (1 / 0)
                end
            end
            if v36 then
                local Z_2 = v35.Z
                v36 = false
                if Z_2 == Z_2 then
                    v36 = false
                    if Z_2 > (-1 / 0) then
                        v36 = Z_2 < (1 / 0)
                    end
                end
            end
        end
        if not v36 or v35.X < v34.X or v35.Y < v34.Y or v35.Z < v34.Z then
            error("PVBVH1 world bounds are invalid")
        end
    end
    v36 = buffer.readstring(v16, 80, v28)
    local v37 = v28 + 80
    v32 = v37 + v19 * 224
    local v38 = v32 + v20 * 8
    local v39 = v38 + v23 * 12
    local v40 = v39 + v21 * (if not v18 then 40 else 12)
    local v41 = v40 + v24 * 56
    local v42 = v41 + v25 * 20
    local v43 = v42 + v26 * 12
    for i = 1, v19 do
        if a2 and i % 1024 == 0 then
            a2()
        end
        v3 = v37 + (i - 1) * 224
        for j = 1, 8 do
            v9 = v3 + 192 + (j - 1) * 4
            v7 = buffer.readi32(v16, v9)
            if v19 < v7 or v7 < -v20 then
                error("PVBVH1 child reference is invalid")
            end
            if v7 ~= 0 then
                v8 = v3 + (j - 1) * 24
                v10 = buffer.readf32(v16, v8)
                v12 = v8 + 4
                v11 = buffer.readf32(v16, v12)
                v13 = v8 + 8
                v9 = Vector3.new(v10, v11, (buffer.readf32(v16, v13)))
                v11 = v8 + 12
                v12 = buffer.readf32(v16, v11)
                v14 = v11 + 4
                v13 = buffer.readf32(v16, v14)
                v15 = v11 + 8
                v10 = Vector3.new(v12, v13, (buffer.readf32(v16, v15)))
                X_4 = v9.X
                v11 = false
                if X_4 == X_4 then
                    v11 = false
                    if X_4 > (-1 / 0) then
                        v11 = X_4 < (1 / 0)
                    end
                end
                if v11 then
                    Y_4 = v9.Y
                    v11 = false
                    if Y_4 == Y_4 then
                        v11 = false
                        if Y_4 > (-1 / 0) then
                            v11 = Y_4 < (1 / 0)
                        end
                    end
                    if v11 then
                        Z_4 = v9.Z
                        v11 = false
                        if Z_4 == Z_4 then
                            v11 = false
                            if Z_4 > (-1 / 0) then
                                v11 = Z_4 < (1 / 0)
                            end
                        end
                    end
                end
                if not v11 then
                    error("PVBVH1 child bounds are invalid")
                else
                    X_5 = v10.X
                    v11 = false
                    if X_5 == X_5 then
                        v11 = false
                        if X_5 > (-1 / 0) then
                            v11 = X_5 < (1 / 0)
                        end
                    end
                    if v11 then
                        Y_5 = v10.Y
                        v11 = false
                        if Y_5 == Y_5 then
                            v11 = false
                            if Y_5 > (-1 / 0) then
                                v11 = Y_5 < (1 / 0)
                            end
                        end
                        if v11 then
                            Z_5 = v10.Z
                            v11 = false
                            if Z_5 == Z_5 then
                                v11 = false
                                if Z_5 > (-1 / 0) then
                                    v11 = Z_5 < (1 / 0)
                                end
                            end
                        end
                    end
                    if not v11 or v10.X < v9.X or v10.Y < v9.Y or v10.Z < v9.Z then
                        error("PVBVH1 child bounds are invalid")
                    end
                end
            end
        end
    end
    local v44 = v20
    for k = 1, v44 do
        if a2 and k % 8192 == 0 then
            a2()
        end
        v3 = v32 + (k - 1) * 8
        v4 = buffer.readu32(v16, v3)
        v7 = v3 + 4
        v5 = buffer.readu16(v16, v7)
        if v5 == 0 or v4 < 1 or v21 < v4 + v5 - 1 then
            error("PVBVH1 leaf triangle range is invalid")
        end
    end
    if not v18 then
        local X_10, X_8, X_9, Y_10, Y_8, Y_9, Z_10, Z_8, Z_9, v45
        for n = 1, v21 do
            if a2 and n % 8192 == 0 then
                a2()
            end
            v3 = v39 + (n - 1) * 40
            v6 = buffer.readf32(v16, v3)
            v9 = v3 + 4
            v7 = buffer.readf32(v16, v9)
            v10 = v3 + 8
            v5 = Vector3.new(v6, v7, (buffer.readf32(v16, v10)))
            X_8 = v5.X
            v4 = false
            if X_8 == X_8 then
                v4 = false
                if X_8 > (-1 / 0) then
                    v4 = X_8 < (1 / 0)
                end
            end
            if v4 then
                Y_8 = v5.Y
                v4 = false
                if Y_8 == Y_8 then
                    v4 = false
                    if Y_8 > (-1 / 0) then
                        v4 = Y_8 < (1 / 0)
                    end
                end
                if v4 then
                    Z_8 = v5.Z
                    v4 = false
                    if Z_8 == Z_8 then
                        v4 = false
                        if Z_8 > (-1 / 0) then
                            v4 = Z_8 < (1 / 0)
                        end
                    end
                end
            end
            if not v4 then
                error("PVBVH1 triangle is not finite")
            else
                v6 = v3 + 12
                v8 = buffer.readf32(v16, v6)
                v11 = v6 + 4
                v9 = buffer.readf32(v16, v11)
                v45 = v6 + 8
                v5 = Vector3.new(v8, v9, (buffer.readf32(v16, v45)))
                X_9 = v5.X
                v4 = false
                if X_9 == X_9 then
                    v4 = false
                    if X_9 > (-1 / 0) then
                        v4 = X_9 < (1 / 0)
                    end
                end
                if v4 then
                    Y_9 = v5.Y
                    v4 = false
                    if Y_9 == Y_9 then
                        v4 = false
                        if Y_9 > (-1 / 0) then
                            v4 = Y_9 < (1 / 0)
                        end
                    end
                    if v4 then
                        Z_9 = v5.Z
                        v4 = false
                        if Z_9 == Z_9 then
                            v4 = false
                            if Z_9 > (-1 / 0) then
                                v4 = Z_9 < (1 / 0)
                            end
                        end
                    end
                end
                if not v4 then
                    error("PVBVH1 triangle is not finite")
                else
                    v6 = v3 + 24
                    v8 = buffer.readf32(v16, v6)
                    v11 = v6 + 4
                    v9 = buffer.readf32(v16, v11)
                    v45 = v6 + 8
                    v5 = Vector3.new(v8, v9, (buffer.readf32(v16, v45)))
                    X_10 = v5.X
                    v4 = false
                    if X_10 == X_10 then
                        v4 = false
                        if X_10 > (-1 / 0) then
                            v4 = X_10 < (1 / 0)
                        end
                    end
                    if v4 then
                        Y_10 = v5.Y
                        v4 = false
                        if Y_10 == Y_10 then
                            v4 = false
                            if Y_10 > (-1 / 0) then
                                v4 = Y_10 < (1 / 0)
                            end
                        end
                        if v4 then
                            Z_10 = v5.Z
                            v4 = false
                            if Z_10 == Z_10 then
                                v4 = false
                                if Z_10 > (-1 / 0) then
                                    v4 = Z_10 < (1 / 0)
                                end
                            end
                        end
                    end
                    if not v4 then
                        error("PVBVH1 triangle is not finite")
                    end
                end
            end
        end
    else
        local X_7, Y_7, Z_7
        for m = 1, v23 do
            if a2 and m % 8192 == 0 then
                a2()
            end
            v5 = v38 + (m - 1) * 12
            v7 = buffer.readf32(v16, v5)
            v10 = v5 + 4
            v8 = buffer.readf32(v16, v10)
            v11 = v5 + 8
            v4 = Vector3.new(v7, v8, (buffer.readf32(v16, v11)))
            X_7 = v4.X
            v3 = false
            if X_7 == X_7 then
                v3 = false
                if X_7 > (-1 / 0) then
                    v3 = X_7 < (1 / 0)
                end
            end
            if v3 then
                Y_7 = v4.Y
                v3 = false
                if Y_7 == Y_7 then
                    v3 = false
                    if Y_7 > (-1 / 0) then
                        v3 = Y_7 < (1 / 0)
                    end
                end
                if v3 then
                    Z_7 = v4.Z
                    v3 = false
                    if Z_7 == Z_7 then
                        v3 = false
                        if Z_7 > (-1 / 0) then
                            v3 = Z_7 < (1 / 0)
                        end
                    end
                end
            end
            if not v3 then
                error("PVBVH1 indexed vertex is not finite")
            end
        end
        v44 = buffer.create(v23)
        v2 = 0
        for i5 = 1, v21 do
            if a2 and i5 % 8192 == 0 then
                a2()
            end
            v5 = v39 + (i5 - 1) * 12
            v6 = buffer.readu32(v16, v5)
            v9 = v5 + 4
            v7 = buffer.readu32(v16, v9)
            v10 = v5 + 8
            v8 = buffer.readu32(v16, v10)
            if v6 < 1 or v23 < v6 or v7 < 1 or v23 < v7 or v8 < 1 or v23 < v8 or v6 == v7 or v6 == v8 or v7 == v8 then
                error("PVBVH1 indexed triangle has invalid vertex indices")
            end
            v11 = v6 - 1
            if buffer.readu8(v44, v11) == 0 then
                v11 = v6 - 1
                buffer.writeu8(v44, v11, 1)
                v2 = v2 + 1
            end
            v11 = v7 - 1
            if buffer.readu8(v44, v11) == 0 then
                v11 = v7 - 1
                buffer.writeu8(v44, v11, 1)
                v2 = v2 + 1
            end
            v11 = v8 - 1
            if buffer.readu8(v44, v11) == 0 then
                v11 = v8 - 1
                buffer.writeu8(v44, v11, 1)
                v2 = v2 + 1
            end
        end
        if v2 ~= v23 then
            error("PVBVH1 indexed vertex table contains unreachable vertices")
        end
    end
    for i6 = 1, v24 do
        v3 = v40 + (i6 - 1) * 56
        v6 = v3 + 48
        v4 = buffer.readu32(v16, v6)
        v7 = v3 + 52
        v5 = buffer.readu16(v16, v7)
        if v5 == 0 or v4 < 1 or v25 < v4 + v5 - 1 then
            error("PVBVH1 plane rectangle range is invalid")
        end
    end
    v44 = -1
    for i7 = 1, v26 do
        v4 = v42 + (i7 - 1) * 12
        v5 = buffer.readu32(v16, v4)
        v8 = v4 + 4
        v6 = buffer.readu32(v16, v8)
        v9 = v4 + 8
        v7 = buffer.readu16(v16, v9)
        if v5 <= v44 or v7 == 0 or v6 < 1 or v27 < v6 + v7 - 1 then
            error("PVBVH1 certificate range or ordering is invalid")
        end
    end
    for i8 = 1, v27 do
        v6 = v43 + (i8 - 1) * 2
        v4 = buffer.readu16(v16, v6)
        if v4 < 1 or v24 < v4 then
            error("PVBVH1 certificate plane is invalid")
        end
    end
    v2 = {
        buffer = v16,
        version = v17,
        fingerprint = v36,
        rootNode = v29,
        nodeCount = v19,
        leafCount = v20,
        triangleCount = v21,
        planeCount = v24,
        rectangleCount = v25,
        certificateCount = v26,
        candidateCount = v27,
        vertexCount = v23,
        worldBounds = {minimum = v34, maximum = v35},
        nodeOffset = v37,
        leafOffset = v32,
        vertexOffset = v38,
        triangleOffset = v39,
        triangleSize = v1,
        planeOffset = v40,
        rectangleOffset = v41,
        certificateOffset = v42,
        candidateOffset = v43,
    }
    validateHierarchy(v2, a2)
    return v2
end

v1.MAGIC = "PVBVH1\000\000"
v1.VERSION = 2
v1.INDEXED_VERSION = 3
v1.NODE_SIZE = 224
v1.LEAF_SIZE = 8
v1.TRIANGLE_SIZE = 40
v1.VERTEX_SIZE = 12
v1.INDEXED_TRIANGLE_SIZE = 12
v1.PLANE_SIZE = 56
v1.RECT_SIZE = 20
v1.CERTIFICATE_SIZE = 12
v1.CANDIDATE_SIZE = 2
return table.freeze(v1)