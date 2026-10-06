-- Decompiled with Potassium's decompiler.

local v1 = {};

local function finite(p2: number) -- Line: 112
    local v3;

    if p2 == p2 and p2 > (-1 / 0) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function finiteVector(p4: vector) -- Line: 116
    local X = p4.X;
    local v5;

    if X == X and X > (-1 / 0) then
        v5 = X < (1 / 0);
    else
        v5 = false;
    end;

    if v5 then
        local Y = p4.Y;

        if Y == Y and Y > (-1 / 0) then
            v5 = Y < (1 / 0);
        else
            v5 = false;
        end;

        if v5 then
            local Z = p4.Z;

            if Z == Z and Z > (-1 / 0) then
                v5 = Z < (1 / 0);
            else
                v5 = false;
            end;
        end;
    end;

    return v5;
end;

local function writeVector(p6: buffer, p7: number, p8: vector) -- Line: 120
    buffer.writef32(p6, p7, p8.X);
    buffer.writef32(p6, p7 + 4, p8.Y);
    buffer.writef32(p6, p7 + 8, p8.Z);
end;

local function readVector(p9: buffer, p10: number) -- Line: 126
    local buffer_readf32_ret = buffer.readf32(p9, p10);
    local buffer_readf32_ret2 = buffer.readf32(p9, p10 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p9, p10 + 8);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
end;

local function boundsContain(p11: vector, p12: vector, p13: vector, p14: vector) -- Line: 134
    local v15;

    if p13.X >= p11.X - 0.125 and (p13.Y >= p11.Y - 0.125 and (p13.Z >= p11.Z - 0.125 and (p14.X <= p12.X + 0.125 and p14.Y <= p12.Y + 0.125))) then
        v15 = p14.Z <= p12.Z + 0.125;
    else
        v15 = false;
    end;

    return v15;
end;

local function boundsContainPoint(p16: vector, p17: vector, p18: vector) -- Line: 148
    local v19;

    if p18.X >= p16.X - 0.125 and (p18.Y >= p16.Y - 0.125 and (p18.Z >= p16.Z - 0.125 and (p18.X <= p17.X + 0.125 and p18.Y <= p17.Y + 0.125))) then
        v19 = p18.Z <= p17.Z + 0.125;
    else
        v19 = false;
    end;

    return v19;
end;

local function payloadHash(p20: buffer, p21: number, p22: function?) -- Line: 157
    local v23 = 5381;

    for i = p21, buffer.len(p20) - 1, 65536 do
        if p22 then
            p22();
        end;

        local v24 = buffer.len(p20) - 1;
        local _ = i;

        for i2 = i, math.min(i + 65535, v24) do
            local v25 = v23 * 33 + buffer.readu8(p20, i2);
            v23 = bit32.band(v25, 4294967295);
            local _ = i2;
        end;
    end;

    return v23;
end;

local function checkedCount(p26: number, p27: string, p28: number?) -- Line: 170
    if p26 < 0 or ((p28 or 2000000) < p26 or p26 % 1 ~= 0) then
        error((`PVBVH1 has invalid {p27}`));
    end;
end;

function v1.encode(p29: table) -- Line: 176
    -- upvalues: payloadHash (copy)
    local v30 = #p29.fingerprint;

    if v30 == 0 or v30 > 65535 then
        error("PVBVH1 fingerprint length is invalid");
    end;

    local v31 = #p29.nodes;

    if v31 < 0 or (v31 > 2000000 or v31 % 1 ~= 0) then
        error("PVBVH1 has invalid node count");
    end;

    local v32 = #p29.leaves;

    if v32 < 0 or (v32 > 2000000 or v32 % 1 ~= 0) then
        error("PVBVH1 has invalid leaf count");
    end;

    local v33 = #p29.triangles;

    if v33 < 0 or (v33 > 2000000 or v33 % 1 ~= 0) then
        error("PVBVH1 has invalid triangle count");
    end;

    local v34 = #p29.planes;

    if v34 < 0 or (v34 > 2000000 or v34 % 1 ~= 0) then
        error("PVBVH1 has invalid plane count");
    end;

    local v35 = #p29.rectangles;

    if v35 < 0 or (v35 > 2000000 or v35 % 1 ~= 0) then
        error("PVBVH1 has invalid rectangle count");
    end;

    local v36 = #p29.certificates;

    if v36 < 0 or (v36 > 2000000 or v36 % 1 ~= 0) then
        error("PVBVH1 has invalid certificate count");
    end;

    local v37 = #p29.candidates;

    if v37 < 0 or (v37 > 2000000 or v37 % 1 ~= 0) then
        error("PVBVH1 has invalid candidate count");
    end;

    if #p29.nodes == 0 or (p29.rootNode < 1 or p29.rootNode > #p29.nodes) then
        error("PVBVH1 root node is invalid");
    end;

    local minimum = p29.worldBounds.minimum;
    local X = minimum.X;
    local v38;

    if X == X and X > (-1 / 0) then
        v38 = X < (1 / 0);
    else
        v38 = false;
    end;

    if v38 then
        local Y = minimum.Y;

        if Y == Y and Y > (-1 / 0) then
            v38 = Y < (1 / 0);
        else
            v38 = false;
        end;

        if v38 then
            local Z = minimum.Z;

            if Z == Z and Z > (-1 / 0) then
                v38 = Z < (1 / 0);
            else
                v38 = false;
            end;
        end;
    end;

    if v38 then
        local maximum = p29.worldBounds.maximum;
        local X2 = maximum.X;
        local v39;

        if X2 == X2 and X2 > (-1 / 0) then
            v39 = X2 < (1 / 0);
        else
            v39 = false;
        end;

        if v39 then
            local Y = maximum.Y;

            if Y == Y and Y > (-1 / 0) then
                v39 = Y < (1 / 0);
            else
                v39 = false;
            end;

            if v39 then
                local Z = maximum.Z;

                if Z == Z and Z > (-1 / 0) then
                    v39 = Z < (1 / 0);
                else
                    v39 = false;
                end;
            end;
        end;

        if not (v39 and (p29.worldBounds.minimum.X <= p29.worldBounds.maximum.X and (p29.worldBounds.minimum.Y <= p29.worldBounds.maximum.Y and p29.worldBounds.minimum.Z <= p29.worldBounds.maximum.Z))) then
            error("PVBVH1 world bounds are invalid");
        end;
    else
        error("PVBVH1 world bounds are invalid");
    end;

    local v40 = v30 + #p29.nodes * 224 + #p29.leaves * 8 + #p29.triangles * 40 + #p29.planes * 56 + #p29.rectangles * 20 + #p29.certificates * 12 + #p29.candidates * 2;
    local buffer_create_ret = buffer.create(v40 + 80);
    buffer.writestring(buffer_create_ret, 0, "PVBVH1\0\0");
    buffer.writeu16(buffer_create_ret, 8, 2);
    buffer.writeu16(buffer_create_ret, 10, 0);
    buffer.writeu32(buffer_create_ret, 12, #p29.nodes);
    buffer.writeu32(buffer_create_ret, 16, #p29.leaves);
    buffer.writeu32(buffer_create_ret, 20, #p29.triangles);
    buffer.writeu32(buffer_create_ret, 24, #p29.planes);
    buffer.writeu32(buffer_create_ret, 28, #p29.rectangles);
    buffer.writeu16(buffer_create_ret, 32, v30);
    buffer.writeu16(buffer_create_ret, 34, 0);
    buffer.writeu32(buffer_create_ret, 36, p29.rootNode);
    buffer.writeu32(buffer_create_ret, 40, 0);
    buffer.writeu32(buffer_create_ret, 44, v40);
    local minimum2 = p29.worldBounds.minimum;
    buffer.writef32(buffer_create_ret, 48, minimum2.X);
    buffer.writef32(buffer_create_ret, 52, minimum2.Y);
    buffer.writef32(buffer_create_ret, 56, minimum2.Z);
    local maximum = p29.worldBounds.maximum;
    buffer.writef32(buffer_create_ret, 60, maximum.X);
    buffer.writef32(buffer_create_ret, 64, maximum.Y);
    buffer.writef32(buffer_create_ret, 68, maximum.Z);
    buffer.writeu32(buffer_create_ret, 72, #p29.certificates);
    buffer.writeu32(buffer_create_ret, 76, #p29.candidates);
    local v41 = 80;
    buffer.writestring(buffer_create_ret, v41, p29.fingerprint);
    local v42 = v41 + v30;

    for _, v in p29.nodes do
        if #v.children > 8 then
            error("PVBVH1 node has more than eight children");
        end;

        local v43 = v;

        for i = 1, 8 do
            local v44 = v43.children[i];
            local v45 = v42 + (i - 1) * 24;
            local v46;

            if v44 == nil then
                buffer.writef32(buffer_create_ret, v45, 0);
                buffer.writef32(buffer_create_ret, v45 + 4, 0);
                buffer.writef32(buffer_create_ret, v45 + 8, 0);
                local v47 = v45 + 12;
                buffer.writef32(buffer_create_ret, v47, 0);
                buffer.writef32(buffer_create_ret, v47 + 4, 0);
                buffer.writef32(buffer_create_ret, v47 + 8, 0);
                buffer.writei32(buffer_create_ret, v42 + 192 + (i - 1) * 4, 0);
                v46 = i;
            else
                local minimum3 = v44.minimum;
                local X2 = minimum3.X;
                local v48;

                if X2 == X2 and X2 > (-1 / 0) then
                    v48 = X2 < (1 / 0);
                else
                    v48 = false;
                end;

                if v48 then
                    local Y = minimum3.Y;

                    if Y == Y and Y > (-1 / 0) then
                        v48 = Y < (1 / 0);
                    else
                        v48 = false;
                    end;

                    if v48 then
                        local Z = minimum3.Z;

                        if Z == Z and Z > (-1 / 0) then
                            v48 = Z < (1 / 0);
                        else
                            v48 = false;
                        end;
                    end;
                end;

                if v48 then
                    local maximum2 = v44.maximum;
                    local X3 = maximum2.X;
                    local v49;

                    if X3 == X3 and X3 > (-1 / 0) then
                        v49 = X3 < (1 / 0);
                    else
                        v49 = false;
                    end;

                    if v49 then
                        local Y = maximum2.Y;

                        if Y == Y and Y > (-1 / 0) then
                            v49 = Y < (1 / 0);
                        else
                            v49 = false;
                        end;

                        if v49 then
                            local Z = maximum2.Z;

                            if Z == Z and Z > (-1 / 0) then
                                v49 = Z < (1 / 0);
                            else
                                v49 = false;
                            end;
                        end;
                    end;

                    if not v49 then
                        error("PVBVH1 child bounds are not finite");
                    end;
                else
                    error("PVBVH1 child bounds are not finite");
                end;

                local minimum4 = v44.minimum;
                buffer.writef32(buffer_create_ret, v45, minimum4.X);
                buffer.writef32(buffer_create_ret, v45 + 4, minimum4.Y);
                buffer.writef32(buffer_create_ret, v45 + 8, minimum4.Z);
                local v50 = v45 + 12;
                local maximum2 = v44.maximum;
                buffer.writef32(buffer_create_ret, v50, maximum2.X);
                buffer.writef32(buffer_create_ret, v50 + 4, maximum2.Y);
                buffer.writef32(buffer_create_ret, v50 + 8, maximum2.Z);
                buffer.writei32(buffer_create_ret, v42 + 192 + (i - 1) * 4, v44.reference);
                v46 = i;
            end;
        end;

        v42 = v42 + 224;
    end;

    for _, v in p29.leaves do
        buffer.writeu32(buffer_create_ret, v42, v.firstTriangle);
        buffer.writeu16(buffer_create_ret, v42 + 4, v.triangleCount);
        buffer.writeu16(buffer_create_ret, v42 + 6, 0);
        v42 = v42 + 8;
    end;

    for _, v in p29.triangles do
        local a = v.a;
        buffer.writef32(buffer_create_ret, v42, a.X);
        buffer.writef32(buffer_create_ret, v42 + 4, a.Y);
        buffer.writef32(buffer_create_ret, v42 + 8, a.Z);
        local v51 = v42 + 12;
        local b = v.b;
        buffer.writef32(buffer_create_ret, v51, b.X);
        buffer.writef32(buffer_create_ret, v51 + 4, b.Y);
        buffer.writef32(buffer_create_ret, v51 + 8, b.Z);
        local v52 = v42 + 24;
        local c = v.c;
        buffer.writef32(buffer_create_ret, v52, c.X);
        buffer.writef32(buffer_create_ret, v52 + 4, c.Y);
        buffer.writef32(buffer_create_ret, v52 + 8, c.Z);
        buffer.writeu32(buffer_create_ret, v42 + 36, v.primitive);
        v42 = v42 + 40;
    end;

    for _, v in p29.planes do
        local origin = v.origin;
        buffer.writef32(buffer_create_ret, v42, origin.X);
        buffer.writef32(buffer_create_ret, v42 + 4, origin.Y);
        buffer.writef32(buffer_create_ret, v42 + 8, origin.Z);
        local v53 = v42 + 12;
        local u = v.u;
        buffer.writef32(buffer_create_ret, v53, u.X);
        buffer.writef32(buffer_create_ret, v53 + 4, u.Y);
        buffer.writef32(buffer_create_ret, v53 + 8, u.Z);
        local v54 = v42 + 24;
        local v2 = v.v;
        buffer.writef32(buffer_create_ret, v54, v2.X);
        buffer.writef32(buffer_create_ret, v54 + 4, v2.Y);
        buffer.writef32(buffer_create_ret, v54 + 8, v2.Z);
        local v55 = v42 + 36;
        local normal = v.normal;
        buffer.writef32(buffer_create_ret, v55, normal.X);
        buffer.writef32(buffer_create_ret, v55 + 4, normal.Y);
        buffer.writef32(buffer_create_ret, v55 + 8, normal.Z);
        buffer.writeu32(buffer_create_ret, v42 + 48, v.firstRectangle);
        buffer.writeu16(buffer_create_ret, v42 + 52, v.rectangleCount);
        buffer.writeu16(buffer_create_ret, v42 + 54, 0);
        v42 = v42 + 56;
    end;

    for _, v in p29.rectangles do
        buffer.writef32(buffer_create_ret, v42, v.minimumU);
        buffer.writef32(buffer_create_ret, v42 + 4, v.maximumU);
        buffer.writef32(buffer_create_ret, v42 + 8, v.minimumV);
        buffer.writef32(buffer_create_ret, v42 + 12, v.maximumV);
        buffer.writeu32(buffer_create_ret, v42 + 16, v.primitive);
        v42 = v42 + 20;
    end;

    for _, v in p29.certificates do
        buffer.writeu32(buffer_create_ret, v42, v.pairKey);
        buffer.writeu32(buffer_create_ret, v42 + 4, v.firstCandidate);
        buffer.writeu16(buffer_create_ret, v42 + 8, v.candidateCount);
        buffer.writeu16(buffer_create_ret, v42 + 10, 0);
        v42 = v42 + 12;
    end;

    for _, v in p29.candidates do
        if v < 1 or (#p29.planes < v or v > 65535) then
            error("PVBVH1 certificate candidate is invalid");
        end;

        buffer.writeu16(buffer_create_ret, v42, v);
        v42 = v42 + 2;
    end;

    local v56 = v42 == buffer.len(buffer_create_ret);
    assert(v56, "PVBVH1 encoder size drift");
    local v57 = payloadHash(buffer_create_ret, 80);
    buffer.writeu32(buffer_create_ret, 40, v57);

    return buffer.tostring(buffer_create_ret);
end;

local function readTriangle(p58: table, p59: number) -- Line: 304
    local buffer2 = p58.buffer;
    local v60 = p58.triangleOffset + (p59 - 1) * p58.triangleSize;

    if p58.version ~= 3 then
        local buffer_readf32_ret = buffer.readf32(buffer2, v60);
        local buffer_readf32_ret2 = buffer.readf32(buffer2, v60 + 4);
        local buffer_readf32_ret3 = buffer.readf32(buffer2, v60 + 8);
        local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local v61 = v60 + 12;
        local buffer_readf32_ret4 = buffer.readf32(buffer2, v61);
        local buffer_readf32_ret5 = buffer.readf32(buffer2, v61 + 4);
        local buffer_readf32_ret6 = buffer.readf32(buffer2, v61 + 8);
        local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
        local v62 = v60 + 24;
        local buffer_readf32_ret7 = buffer.readf32(buffer2, v62);
        local buffer_readf32_ret8 = buffer.readf32(buffer2, v62 + 4);
        local buffer_readf32_ret9 = buffer.readf32(buffer2, v62 + 8);

        return Vector3_new_ret, Vector3_new_ret2, Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9), buffer.readu32(buffer2, v60 + 36);
    end;

    local buffer_readu32_ret = buffer.readu32(buffer2, v60);
    local buffer_readu32_ret2 = buffer.readu32(buffer2, v60 + 4);
    local buffer_readu32_ret3 = buffer.readu32(buffer2, v60 + 8);
    local v63 = p58.vertexOffset + (buffer_readu32_ret - 1) * 12;
    local buffer_readf32_ret = buffer.readf32(buffer2, v63);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v63 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v63 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v64 = p58.vertexOffset + (buffer_readu32_ret2 - 1) * 12;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v64);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v64 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v64 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v65 = p58.vertexOffset + (buffer_readu32_ret3 - 1) * 12;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v65);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v65 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v65 + 8);

    return Vector3_new_ret, Vector3_new_ret2, Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9), 0;
end;

function v1.referencedPrimitives(p66: table) -- Line: 323
    local v67 = {};

    if p66.version == 3 then
        if p66.triangleCount > 0 then
            v67[0] = true;
        end;

        return v67;
    end;

    local buffer2 = p66.buffer;

    for i = 1, p66.triangleCount do
        v67[buffer.readu32(buffer2, p66.triangleOffset + (i - 1) * p66.triangleSize + 36)] = true;
        local _ = i;
    end;

    return v67;
end;

function v1.validateExactGeometry(p68: table) -- Line: 339
    if p68.planeCount ~= 0 or (p68.rectangleCount ~= 0 or (p68.certificateCount ~= 0 or p68.candidateCount ~= 0)) then
        return false, "ExactPVBVHContainsLegacyRecords";
    end;

    if p68.version ~= 3 then
        local buffer2 = p68.buffer;

        for i = 1, p68.triangleCount do
            if buffer.readu32(buffer2, p68.triangleOffset + (i - 1) * p68.triangleSize + 36) ~= 0 then
                return false, "ExactPVBVHHasOwnedPrimitive";
            end;

            local _ = i;
        end;
    end;

    return true, nil;
end;

local function validateHierarchy(p69: table, p70: function?) -- Line: 356
    -- upvalues: boundsContain (copy), readTriangle (copy), boundsContainPoint (copy)
    local buffer2 = p69.buffer;
    local buffer_create_ret = buffer.create(p69.nodeCount);
    local buffer_create_ret2 = buffer.create(p69.leafCount);
    local buffer_create_ret3 = buffer.create(p69.triangleCount);
    local table_create_ret = table.create(math.min(p69.nodeCount, 1024), 0);
    local table_create_ret2 = table.create(math.min(p69.nodeCount, 1024), Vector3.new(0, 0, 0));
    local table_create_ret3 = table.create(math.min(p69.nodeCount, 1024), Vector3.new(0, 0, 0));
    table_create_ret[1] = p69.rootNode;
    table_create_ret2[1] = p69.worldBounds.minimum;
    table_create_ret3[1] = p69.worldBounds.maximum;
    buffer.writeu8(buffer_create_ret, p69.rootNode - 1, 1);
    local v71 = 0;
    local v72 = 1;
    local v73 = 1;
    local v74 = 0;

    while v73 > 0 do
        if p70 then
            p70();
        end;

        local v75 = table_create_ret[v73];
        local v76 = table_create_ret2[v73];
        local v77 = table_create_ret3[v73];
        v73 = v73 - 1;
        local v78 = p69.nodeOffset + (v75 - 1) * 224;
        local v79 = 0;

        for i = 1, 8 do
            local buffer_readi32_ret = buffer.readi32(buffer2, v78 + 192 + (i - 1) * 4);
            local v80;

            if buffer_readi32_ret == 0 then
                v80 = i;
            else
                v79 = v79 + 1;
                local v81 = v78 + (i - 1) * 24;
                local buffer_readf32_ret = buffer.readf32(buffer2, v81);
                local buffer_readf32_ret2 = buffer.readf32(buffer2, v81 + 4);
                local buffer_readf32_ret3 = buffer.readf32(buffer2, v81 + 8);
                local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
                local v82 = v81 + 12;
                local buffer_readf32_ret4 = buffer.readf32(buffer2, v82);
                local buffer_readf32_ret5 = buffer.readf32(buffer2, v82 + 4);
                local buffer_readf32_ret6 = buffer.readf32(buffer2, v82 + 8);
                local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);

                if not boundsContain(v76, v77, Vector3_new_ret, Vector3_new_ret2) then
                    error("PVBVH1 child bounds escape their parent");
                end;

                if buffer_readi32_ret > 0 then
                    if buffer.readu8(buffer_create_ret, buffer_readi32_ret - 1) ~= 0 then
                        error("PVBVH1 node graph is cyclic or has multiple parents");
                    end;

                    buffer.writeu8(buffer_create_ret, buffer_readi32_ret - 1, 1);
                    v72 = v72 + 1;
                    v73 = v73 + 1;
                    table_create_ret[v73] = buffer_readi32_ret;
                    table_create_ret2[v73] = Vector3_new_ret;
                    table_create_ret3[v73] = Vector3_new_ret2;
                    v80 = i;
                else
                    local v83 = -buffer_readi32_ret;

                    if buffer.readu8(buffer_create_ret2, v83 - 1) ~= 0 then
                        error("PVBVH1 leaf has multiple parents");
                    end;

                    buffer.writeu8(buffer_create_ret2, v83 - 1, 1);
                    v74 = v74 + 1;
                    local v84 = p69.leafOffset + (v83 - 1) * 8;
                    local buffer_readu32_ret = buffer.readu32(buffer2, v84);
                    v80 = i;

                    for i2 = buffer_readu32_ret, buffer_readu32_ret + buffer.readu16(buffer2, v84 + 4) - 1 do
                        if buffer.readu8(buffer_create_ret3, i2 - 1) ~= 0 then
                            error("PVBVH1 leaf triangle ranges overlap");
                        end;

                        buffer.writeu8(buffer_create_ret3, i2 - 1, 1);
                        v71 = v71 + 1;
                        local v85, v86, v87 = readTriangle(p69, i2);
                        local v88;

                        if boundsContainPoint(Vector3_new_ret, Vector3_new_ret2, v85) and (boundsContainPoint(Vector3_new_ret, Vector3_new_ret2, v86) and boundsContainPoint(Vector3_new_ret, Vector3_new_ret2, v87)) then
                            v88 = i2;
                        else
                            error("PVBVH1 triangle escapes its leaf bounds");
                            v88 = i2;
                        end;
                    end;
                end;
            end;
        end;

        if v79 == 0 then
            error("PVBVH1 reachable node is empty");
        end;
    end;

    if v72 ~= p69.nodeCount then
        error("PVBVH1 contains unreachable nodes");
    end;

    if v74 ~= p69.leafCount then
        error("PVBVH1 contains unreachable leaves");
    end;

    if v71 ~= p69.triangleCount then
        error("PVBVH1 leaf ranges do not cover every triangle");
    end;
end;

function v1.decode(p89: string, p90: function?) -- Line: 450
    -- upvalues: payloadHash (copy), validateHierarchy (copy)
    local buffer_fromstring_ret = buffer.fromstring(p89);

    if buffer.len(buffer_fromstring_ret) < 80 or buffer.readstring(buffer_fromstring_ret, 0, 8) ~= "PVBVH1\0\0" then
        error("PVBVH1 magic is invalid");
    end;

    local buffer_readu16_ret = buffer.readu16(buffer_fromstring_ret, 8);

    if buffer_readu16_ret ~= 2 and buffer_readu16_ret ~= 3 or buffer.readu16(buffer_fromstring_ret, 10) ~= 0 then
        error("PVBVH1 version or flags are unsupported");
    end;

    local v91 = buffer_readu16_ret == 3;
    local buffer_readu32_ret = buffer.readu32(buffer_fromstring_ret, 12);
    local buffer_readu32_ret2 = buffer.readu32(buffer_fromstring_ret, 16);
    local buffer_readu32_ret3 = buffer.readu32(buffer_fromstring_ret, 20);
    local buffer_readu32_ret4 = buffer.readu32(buffer_fromstring_ret, 24);
    local v92 = not v91 and 0 or buffer_readu32_ret4;
    local v93 = v91 and 0 or buffer_readu32_ret4;
    local buffer_readu32_ret5 = buffer.readu32(buffer_fromstring_ret, 28);
    local buffer_readu32_ret6 = buffer.readu32(buffer_fromstring_ret, 72);
    local buffer_readu32_ret7 = buffer.readu32(buffer_fromstring_ret, 76);
    local buffer_readu16_ret2 = buffer.readu16(buffer_fromstring_ret, 32);
    local buffer_readu32_ret8 = buffer.readu32(buffer_fromstring_ret, 36);
    local buffer_readu32_ret9 = buffer.readu32(buffer_fromstring_ret, 40);
    local buffer_readu32_ret10 = buffer.readu32(buffer_fromstring_ret, 44);

    if buffer_readu32_ret < 0 or (buffer_readu32_ret > 2000000 or buffer_readu32_ret % 1 ~= 0) then
        error("PVBVH1 has invalid node count");
    end;

    if buffer_readu32_ret2 < 0 or (buffer_readu32_ret2 > 2000000 or buffer_readu32_ret2 % 1 ~= 0) then
        error("PVBVH1 has invalid leaf count");
    end;

    if buffer_readu32_ret3 < 0 or (buffer_readu32_ret3 > 2000000 or buffer_readu32_ret3 % 1 ~= 0) then
        error("PVBVH1 has invalid triangle count");
    end;

    if v92 < 0 or (v92 > 6000000 or v92 % 1 ~= 0) then
        error("PVBVH1 has invalid vertex count");
    end;

    if v93 < 0 or (v93 > 2000000 or v93 % 1 ~= 0) then
        error("PVBVH1 has invalid plane count");
    end;

    if buffer_readu32_ret5 < 0 or (buffer_readu32_ret5 > 2000000 or buffer_readu32_ret5 % 1 ~= 0) then
        error("PVBVH1 has invalid rectangle count");
    end;

    if buffer_readu32_ret6 < 0 or (buffer_readu32_ret6 > 2000000 or buffer_readu32_ret6 % 1 ~= 0) then
        error("PVBVH1 has invalid certificate count");
    end;

    if buffer_readu32_ret7 < 0 or (buffer_readu32_ret7 > 2000000 or buffer_readu32_ret7 % 1 ~= 0) then
        error("PVBVH1 has invalid candidate count");
    end;

    if buffer_readu32_ret == 0 or (buffer_readu32_ret8 < 1 or (buffer_readu32_ret < buffer_readu32_ret8 or (buffer_readu16_ret2 == 0 or v91 and (buffer_readu32_ret2 == 0 or (buffer_readu32_ret3 == 0 or v92 == 0))))) then
        error("PVBVH1 root or fingerprint is invalid");
    end;

    if v91 and (buffer_readu32_ret5 ~= 0 or (buffer_readu32_ret6 ~= 0 or buffer_readu32_ret7 ~= 0)) then
        error("PVBVH1 v3 is reserved for indexed ExactGeometryV1 payloads");
    end;

    local v94 = buffer_readu16_ret2 + buffer_readu32_ret * 224 + buffer_readu32_ret2 * 8 + v92 * 12 + buffer_readu32_ret3 * (v91 and 12 or 40) + v93 * 56 + buffer_readu32_ret5 * 20 + buffer_readu32_ret6 * 12 + buffer_readu32_ret7 * 2;

    if buffer_readu32_ret10 ~= v94 or buffer.len(buffer_fromstring_ret) ~= v94 + 80 then
        error("PVBVH1 payload size is invalid");
    end;

    if payloadHash(buffer_fromstring_ret, 80, p90) ~= buffer_readu32_ret9 then
        error("PVBVH1 payload checksum mismatch");
    end;

    local buffer_readf32_ret = buffer.readf32(buffer_fromstring_ret, 48);
    local buffer_readf32_ret2 = buffer.readf32(buffer_fromstring_ret, 52);
    local buffer_readf32_ret3 = buffer.readf32(buffer_fromstring_ret, 56);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local buffer_readf32_ret4 = buffer.readf32(buffer_fromstring_ret, 60);
    local buffer_readf32_ret5 = buffer.readf32(buffer_fromstring_ret, 64);
    local buffer_readf32_ret6 = buffer.readf32(buffer_fromstring_ret, 68);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local X = Vector3_new_ret.X;
    local v95;

    if X == X and X > (-1 / 0) then
        v95 = X < (1 / 0);
    else
        v95 = false;
    end;

    if v95 then
        local Y = Vector3_new_ret.Y;

        if Y == Y and Y > (-1 / 0) then
            v95 = Y < (1 / 0);
        else
            v95 = false;
        end;

        if v95 then
            local Z = Vector3_new_ret.Z;

            if Z == Z and Z > (-1 / 0) then
                v95 = Z < (1 / 0);
            else
                v95 = false;
            end;
        end;
    end;

    if v95 then
        local X2 = Vector3_new_ret2.X;
        local v96;

        if X2 == X2 and X2 > (-1 / 0) then
            v96 = X2 < (1 / 0);
        else
            v96 = false;
        end;

        if v96 then
            local Y = Vector3_new_ret2.Y;

            if Y == Y and Y > (-1 / 0) then
                v96 = Y < (1 / 0);
            else
                v96 = false;
            end;

            if v96 then
                local Z = Vector3_new_ret2.Z;

                if Z == Z and Z > (-1 / 0) then
                    v96 = Z < (1 / 0);
                else
                    v96 = false;
                end;
            end;
        end;

        if not (v96 and (Vector3_new_ret.X <= Vector3_new_ret2.X and (Vector3_new_ret.Y <= Vector3_new_ret2.Y and Vector3_new_ret.Z <= Vector3_new_ret2.Z))) then
            error("PVBVH1 world bounds are invalid");
        end;
    else
        error("PVBVH1 world bounds are invalid");
    end;

    local buffer_readstring_ret = buffer.readstring(buffer_fromstring_ret, 80, buffer_readu16_ret2);
    local v97 = buffer_readu16_ret2 + 80;
    local v98 = v97 + buffer_readu32_ret * 224;
    local v99 = v98 + buffer_readu32_ret2 * 8;
    local v100 = v99 + v92 * 12;
    local v101 = v91 and 12 or 40;
    local v102 = v100 + buffer_readu32_ret3 * v101;
    local v103 = v102 + v93 * 56;
    local v104 = v103 + buffer_readu32_ret5 * 20;
    local v105 = v104 + buffer_readu32_ret6 * 12;

    for i = 1, buffer_readu32_ret do
        if p90 and i % 1024 == 0 then
            p90();
        end;

        local v106 = v97 + (i - 1) * 224;
        local _ = i;

        for i2 = 1, 8 do
            local buffer_readi32_ret = buffer.readi32(buffer_fromstring_ret, v106 + 192 + (i2 - 1) * 4);

            if buffer_readu32_ret < buffer_readi32_ret or buffer_readi32_ret < -buffer_readu32_ret2 then
                error("PVBVH1 child reference is invalid");
            end;

            local v107;

            if buffer_readi32_ret == 0 then
                v107 = i2;
            else
                local v108 = v106 + (i2 - 1) * 24;
                local buffer_readf32_ret7 = buffer.readf32(buffer_fromstring_ret, v108);
                local buffer_readf32_ret8 = buffer.readf32(buffer_fromstring_ret, v108 + 4);
                local buffer_readf32_ret9 = buffer.readf32(buffer_fromstring_ret, v108 + 8);
                local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
                local v109 = v108 + 12;
                local buffer_readf32_ret10 = buffer.readf32(buffer_fromstring_ret, v109);
                local buffer_readf32_ret11 = buffer.readf32(buffer_fromstring_ret, v109 + 4);
                local buffer_readf32_ret12 = buffer.readf32(buffer_fromstring_ret, v109 + 8);
                local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
                local X2 = Vector3_new_ret3.X;
                local v110;

                if X2 == X2 and X2 > (-1 / 0) then
                    v110 = X2 < (1 / 0);
                else
                    v110 = false;
                end;

                if v110 then
                    local Y = Vector3_new_ret3.Y;

                    if Y == Y and Y > (-1 / 0) then
                        v110 = Y < (1 / 0);
                    else
                        v110 = false;
                    end;

                    if v110 then
                        local Z = Vector3_new_ret3.Z;

                        if Z == Z and Z > (-1 / 0) then
                            v110 = Z < (1 / 0);
                        else
                            v110 = false;
                        end;
                    end;
                end;

                if v110 then
                    local X3 = Vector3_new_ret4.X;
                    local v111;

                    if X3 == X3 and X3 > (-1 / 0) then
                        v111 = X3 < (1 / 0);
                    else
                        v111 = false;
                    end;

                    if v111 then
                        local Y = Vector3_new_ret4.Y;

                        if Y == Y and Y > (-1 / 0) then
                            v111 = Y < (1 / 0);
                        else
                            v111 = false;
                        end;

                        if v111 then
                            local Z = Vector3_new_ret4.Z;

                            if Z == Z and Z > (-1 / 0) then
                                v111 = Z < (1 / 0);
                            else
                                v111 = false;
                            end;
                        end;
                    end;

                    if v111 and (Vector3_new_ret3.X <= Vector3_new_ret4.X and (Vector3_new_ret3.Y <= Vector3_new_ret4.Y and Vector3_new_ret3.Z <= Vector3_new_ret4.Z)) then
                        v107 = i2;
                    else
                        error("PVBVH1 child bounds are invalid");
                        v107 = i2;
                    end;
                else
                    error("PVBVH1 child bounds are invalid");
                    v107 = i2;
                end;
            end;
        end;
    end;

    for i = 1, buffer_readu32_ret2 do
        if p90 and i % 8192 == 0 then
            p90();
        end;

        local v112 = v98 + (i - 1) * 8;
        local buffer_readu32_ret11 = buffer.readu32(buffer_fromstring_ret, v112);
        local buffer_readu16_ret3 = buffer.readu16(buffer_fromstring_ret, v112 + 4);
        local v113;

        if buffer_readu16_ret3 == 0 or (buffer_readu32_ret11 < 1 or buffer_readu32_ret3 < buffer_readu32_ret11 + buffer_readu16_ret3 - 1) then
            error("PVBVH1 leaf triangle range is invalid");
            v113 = i;
        else
            v113 = i;
        end;
    end;

    if v91 then
        for i = 1, v92 do
            if p90 and i % 8192 == 0 then
                p90();
            end;

            local v114 = v99 + (i - 1) * 12;
            local buffer_readf32_ret7 = buffer.readf32(buffer_fromstring_ret, v114);
            local buffer_readf32_ret8 = buffer.readf32(buffer_fromstring_ret, v114 + 4);
            local buffer_readf32_ret9 = buffer.readf32(buffer_fromstring_ret, v114 + 8);
            local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
            local X2 = Vector3_new_ret3.X;
            local v115;

            if X2 == X2 and X2 > (-1 / 0) then
                v115 = X2 < (1 / 0);
            else
                v115 = false;
            end;

            if v115 then
                local Y = Vector3_new_ret3.Y;

                if Y == Y and Y > (-1 / 0) then
                    v115 = Y < (1 / 0);
                else
                    v115 = false;
                end;

                if v115 then
                    local Z = Vector3_new_ret3.Z;

                    if Z == Z and Z > (-1 / 0) then
                        v115 = Z < (1 / 0);
                    else
                        v115 = false;
                    end;
                end;
            end;

            local v116;

            if v115 then
                v116 = i;
            else
                error("PVBVH1 indexed vertex is not finite");
                v116 = i;
            end;
        end;

        local buffer_create_ret = buffer.create(v92);
        local v117 = 0;

        for i = 1, buffer_readu32_ret3 do
            if p90 and i % 8192 == 0 then
                p90();
            end;

            local v118 = v100 + (i - 1) * 12;
            local buffer_readu32_ret11 = buffer.readu32(buffer_fromstring_ret, v118);
            local buffer_readu32_ret12 = buffer.readu32(buffer_fromstring_ret, v118 + 4);
            local buffer_readu32_ret13 = buffer.readu32(buffer_fromstring_ret, v118 + 8);

            if buffer_readu32_ret11 < 1 or (v92 < buffer_readu32_ret11 or (buffer_readu32_ret12 < 1 or (v92 < buffer_readu32_ret12 or (buffer_readu32_ret13 < 1 or (v92 < buffer_readu32_ret13 or (buffer_readu32_ret11 == buffer_readu32_ret12 or (buffer_readu32_ret11 == buffer_readu32_ret13 or buffer_readu32_ret12 == buffer_readu32_ret13))))))) then
                error("PVBVH1 indexed triangle has invalid vertex indices");
            end;

            if buffer.readu8(buffer_create_ret, buffer_readu32_ret11 - 1) == 0 then
                buffer.writeu8(buffer_create_ret, buffer_readu32_ret11 - 1, 1);
                v117 = v117 + 1;
            end;

            if buffer.readu8(buffer_create_ret, buffer_readu32_ret12 - 1) == 0 then
                buffer.writeu8(buffer_create_ret, buffer_readu32_ret12 - 1, 1);
                v117 = v117 + 1;
            end;

            local v119;

            if buffer.readu8(buffer_create_ret, buffer_readu32_ret13 - 1) == 0 then
                buffer.writeu8(buffer_create_ret, buffer_readu32_ret13 - 1, 1);
                v117 = v117 + 1;
                v119 = i;
            else
                v119 = i;
            end;
        end;

        if v117 ~= v92 then
            error("PVBVH1 indexed vertex table contains unreachable vertices");
        end;
    else
        for i = 1, buffer_readu32_ret3 do
            if p90 and i % 8192 == 0 then
                p90();
            end;

            local v120 = v100 + (i - 1) * 40;
            local buffer_readf32_ret7 = buffer.readf32(buffer_fromstring_ret, v120);
            local buffer_readf32_ret8 = buffer.readf32(buffer_fromstring_ret, v120 + 4);
            local buffer_readf32_ret9 = buffer.readf32(buffer_fromstring_ret, v120 + 8);
            local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
            local X2 = Vector3_new_ret3.X;
            local v121;

            if X2 == X2 and X2 > (-1 / 0) then
                v121 = X2 < (1 / 0);
            else
                v121 = false;
            end;

            if v121 then
                local Y = Vector3_new_ret3.Y;

                if Y == Y and Y > (-1 / 0) then
                    v121 = Y < (1 / 0);
                else
                    v121 = false;
                end;

                if v121 then
                    local Z = Vector3_new_ret3.Z;

                    if Z == Z and Z > (-1 / 0) then
                        v121 = Z < (1 / 0);
                    else
                        v121 = false;
                    end;
                end;
            end;

            local v122;

            if v121 then
                local v123 = v120 + 12;
                local buffer_readf32_ret10 = buffer.readf32(buffer_fromstring_ret, v123);
                local buffer_readf32_ret11 = buffer.readf32(buffer_fromstring_ret, v123 + 4);
                local buffer_readf32_ret12 = buffer.readf32(buffer_fromstring_ret, v123 + 8);
                local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
                local X3 = Vector3_new_ret4.X;
                local v124;

                if X3 == X3 and X3 > (-1 / 0) then
                    v124 = X3 < (1 / 0);
                else
                    v124 = false;
                end;

                if v124 then
                    local Y = Vector3_new_ret4.Y;

                    if Y == Y and Y > (-1 / 0) then
                        v124 = Y < (1 / 0);
                    else
                        v124 = false;
                    end;

                    if v124 then
                        local Z = Vector3_new_ret4.Z;

                        if Z == Z and Z > (-1 / 0) then
                            v124 = Z < (1 / 0);
                        else
                            v124 = false;
                        end;
                    end;
                end;

                if v124 then
                    local v125 = v120 + 24;
                    local buffer_readf32_ret13 = buffer.readf32(buffer_fromstring_ret, v125);
                    local buffer_readf32_ret14 = buffer.readf32(buffer_fromstring_ret, v125 + 4);
                    local buffer_readf32_ret15 = buffer.readf32(buffer_fromstring_ret, v125 + 8);
                    local Vector3_new_ret5 = Vector3.new(buffer_readf32_ret13, buffer_readf32_ret14, buffer_readf32_ret15);
                    local X4 = Vector3_new_ret5.X;
                    local v126;

                    if X4 == X4 and X4 > (-1 / 0) then
                        v126 = X4 < (1 / 0);
                    else
                        v126 = false;
                    end;

                    if v126 then
                        local Y = Vector3_new_ret5.Y;

                        if Y == Y and Y > (-1 / 0) then
                            v126 = Y < (1 / 0);
                        else
                            v126 = false;
                        end;

                        if v126 then
                            local Z = Vector3_new_ret5.Z;

                            if Z == Z and Z > (-1 / 0) then
                                v126 = Z < (1 / 0);
                            else
                                v126 = false;
                            end;
                        end;
                    end;

                    if v126 then
                        v122 = i;
                    else
                        error("PVBVH1 triangle is not finite");
                        v122 = i;
                    end;
                else
                    error("PVBVH1 triangle is not finite");
                    v122 = i;
                end;
            else
                error("PVBVH1 triangle is not finite");
                v122 = i;
            end;
        end;
    end;

    for i = 1, v93 do
        local v127 = v102 + (i - 1) * 56;
        local buffer_readu32_ret11 = buffer.readu32(buffer_fromstring_ret, v127 + 48);
        local buffer_readu16_ret3 = buffer.readu16(buffer_fromstring_ret, v127 + 52);
        local v128;

        if buffer_readu16_ret3 == 0 or (buffer_readu32_ret11 < 1 or buffer_readu32_ret5 < buffer_readu32_ret11 + buffer_readu16_ret3 - 1) then
            error("PVBVH1 plane rectangle range is invalid");
            v128 = i;
        else
            v128 = i;
        end;
    end;

    local v129 = -1;

    for i = 1, buffer_readu32_ret6 do
        local v130 = v104 + (i - 1) * 12;
        local buffer_readu32_ret11 = buffer.readu32(buffer_fromstring_ret, v130);
        local buffer_readu32_ret12 = buffer.readu32(buffer_fromstring_ret, v130 + 4);
        local buffer_readu16_ret3 = buffer.readu16(buffer_fromstring_ret, v130 + 8);

        if buffer_readu32_ret11 <= v129 or (buffer_readu16_ret3 == 0 or (buffer_readu32_ret12 < 1 or buffer_readu32_ret7 < buffer_readu32_ret12 + buffer_readu16_ret3 - 1)) then
            error("PVBVH1 certificate range or ordering is invalid");
        end;

        v129 = buffer_readu32_ret11;
        local _ = i;
    end;

    for i = 1, buffer_readu32_ret7 do
        local buffer_readu16_ret3 = buffer.readu16(buffer_fromstring_ret, v105 + (i - 1) * 2);
        local v131;

        if buffer_readu16_ret3 < 1 or v93 < buffer_readu16_ret3 then
            error("PVBVH1 certificate plane is invalid");
            v131 = i;
        else
            v131 = i;
        end;
    end;

    local v132 = {
        buffer = buffer_fromstring_ret,
        version = buffer_readu16_ret,
        fingerprint = buffer_readstring_ret,
        rootNode = buffer_readu32_ret8,
        nodeCount = buffer_readu32_ret,
        leafCount = buffer_readu32_ret2,
        triangleCount = buffer_readu32_ret3,
        planeCount = v93,
        rectangleCount = buffer_readu32_ret5,
        certificateCount = buffer_readu32_ret6,
        candidateCount = buffer_readu32_ret7,
        vertexCount = v92,
        worldBounds = {
            minimum = Vector3_new_ret,
            maximum = Vector3_new_ret2
        },
        nodeOffset = v97,
        leafOffset = v98,
        vertexOffset = v99,
        triangleOffset = v100,
        triangleSize = v101,
        planeOffset = v102,
        rectangleOffset = v103,
        certificateOffset = v104,
        candidateOffset = v105
    };
    validateHierarchy(v132, p90);

    return v132;
end;

v1.MAGIC = "PVBVH1\0\0";
v1.VERSION = 2;
v1.INDEXED_VERSION = 3;
v1.NODE_SIZE = 224;
v1.LEAF_SIZE = 8;
v1.TRIANGLE_SIZE = 40;
v1.VERTEX_SIZE = 12;
v1.INDEXED_TRIANGLE_SIZE = 12;
v1.PLANE_SIZE = 56;
v1.RECT_SIZE = 20;
v1.CERTIFICATE_SIZE = 12;
v1.CANDIDATE_SIZE = 2;

return table.freeze(v1);