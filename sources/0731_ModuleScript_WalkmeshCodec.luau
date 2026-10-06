-- Decompiled with Potassium's decompiler.

local CanonicalGeometry = require(script.Parent.CanonicalGeometry);
local Schema = require(script.Parent.Schema);
local u1 = {};

local function isFinite(p2: number) -- Line: 27
    local v3;

    if p2 == p2 and p2 > (-1 / 0) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function u1.Decode(p4) -- Line: 31
    -- upvalues: Schema (copy), CanonicalGeometry (copy)
    if typeof(p4) ~= "string" then
        return nil, "walkmesh payload must be a string";
    end;

    local v5 = #Schema.WalkmeshHeader;

    if #p4 < v5 + 8 or string.sub(p4, 1, v5) ~= Schema.WalkmeshHeader then
        return nil, "walkmesh payload is missing the MLWALK1 header";
    end;

    local buffer_fromstring_ret = buffer.fromstring(p4);
    local buffer_readu32_ret = buffer.readu32(buffer_fromstring_ret, v5);

    if buffer_readu32_ret == 0 or Schema.MaxWalkmeshVertices < buffer_readu32_ret then
        return nil, string.format("walkmesh vertex count must be in [1, %d]", Schema.MaxWalkmeshVertices);
    end;

    local v6 = v5 + 4;
    local v7 = v6 + buffer_readu32_ret * 12;

    if v7 + 4 > #p4 then
        return nil, "walkmesh payload ends inside its vertex array";
    end;

    local buffer_readu32_ret2 = buffer.readu32(buffer_fromstring_ret, v7);

    if buffer_readu32_ret2 == 0 or Schema.MaxWalkmeshTriangles < buffer_readu32_ret2 then
        return nil, string.format("walkmesh triangle count must be in [1, %d]", Schema.MaxWalkmeshTriangles);
    end;

    local v8 = v7 + 4;
    local v9 = v8 + buffer_readu32_ret2 * 13;

    if v9 ~= #p4 then
        return nil, string.format("walkmesh payload has %d bytes; expected exactly %d", #p4, v9);
    end;

    local table_create_ret = table.create(buffer_readu32_ret);

    for i = 1, buffer_readu32_ret do
        local buffer_readf32_ret = buffer.readf32(buffer_fromstring_ret, v6);
        local buffer_readf32_ret2 = buffer.readf32(buffer_fromstring_ret, v6 + 4);
        local buffer_readf32_ret3 = buffer.readf32(buffer_fromstring_ret, v6 + 8);
        v6 = v6 + 12;
        local v10;

        if buffer_readf32_ret == buffer_readf32_ret and buffer_readf32_ret > (-1 / 0) then
            v10 = buffer_readf32_ret < (1 / 0);
        else
            v10 = false;
        end;

        if not v10 then
            return nil, string.format("walkmesh vertex %d contains a non-finite component", i);
        end;

        local v11;

        if buffer_readf32_ret2 == buffer_readf32_ret2 and buffer_readf32_ret2 > (-1 / 0) then
            v11 = buffer_readf32_ret2 < (1 / 0);
        else
            v11 = false;
        end;

        if not v11 then
            return nil, string.format("walkmesh vertex %d contains a non-finite component", i);
        end;

        local v12;

        if buffer_readf32_ret3 == buffer_readf32_ret3 and buffer_readf32_ret3 > (-1 / 0) then
            v12 = buffer_readf32_ret3 < (1 / 0);
        else
            v12 = false;
        end;

        if not v12 then
            return nil, string.format("walkmesh vertex %d contains a non-finite component", i);
        end;

        table_create_ret[i] = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local _ = i;
    end;

    local table_create_ret2 = table.create(buffer_readu32_ret2);

    for i = 1, buffer_readu32_ret2 do
        local buffer_readu32_ret3 = buffer.readu32(buffer_fromstring_ret, v8);
        local buffer_readu32_ret4 = buffer.readu32(buffer_fromstring_ret, v8 + 4);
        local buffer_readu32_ret5 = buffer.readu32(buffer_fromstring_ret, v8 + 8);
        local buffer_readu8_ret = buffer.readu8(buffer_fromstring_ret, v8 + 12);
        v8 = v8 + 13;

        if buffer_readu32_ret3 < 1 or (buffer_readu32_ret < buffer_readu32_ret3 or (buffer_readu32_ret4 < 1 or (buffer_readu32_ret < buffer_readu32_ret4 or (buffer_readu32_ret5 < 1 or buffer_readu32_ret < buffer_readu32_ret5)))) then
            return nil, string.format("walkmesh triangle %d references a vertex outside [1, %d]", i, buffer_readu32_ret);
        end;

        if buffer_readu32_ret3 == buffer_readu32_ret4 or (buffer_readu32_ret4 == buffer_readu32_ret5 or buffer_readu32_ret3 == buffer_readu32_ret5) then
            return nil, string.format("walkmesh triangle %d repeats a vertex index", i);
        end;

        local v13 = table_create_ret[buffer_readu32_ret3];

        if (table_create_ret[buffer_readu32_ret4] - v13):Cross(table_create_ret[buffer_readu32_ret5] - v13).Magnitude <= 1e-8 then
            return nil, string.format("walkmesh triangle %d is degenerate", i);
        end;

        table_create_ret2[i] = table.freeze({
            A = buffer_readu32_ret3,
            B = buffer_readu32_ret4,
            C = buffer_readu32_ret5,
            Flags = buffer_readu8_ret
        });
        local _ = i;
    end;

    table.freeze(table_create_ret);
    table.freeze(table_create_ret2);

    return table.freeze({
        Vertices = table_create_ret,
        Triangles = table_create_ret2,
        VertexCount = buffer_readu32_ret,
        TriangleCount = buffer_readu32_ret2,
        Fingerprint = CanonicalGeometry.Crc32(p4)
    }), nil;
end;

function u1.ReadPublished(p14: userdata) -- Line: 122
    -- upvalues: Schema (copy), u1 (copy)
    local Attribute = p14:GetAttribute(Schema.Attributes.WalkmeshData);
    local v15, v16 = u1.Decode(Attribute);

    if v15 == nil then
        return nil, string.format("%s has invalid %s: %s", p14:GetFullName(), Schema.Attributes.WalkmeshData, v16 or "unknown error");
    end;

    return v15, nil;
end;

return table.freeze(u1);