-- Decompiled with Potassium's decompiler.

local Constants = require(script.Parent.Constants);
local u2 = {
    supportsPart = function(p1: userdata) -- Line: 20, Name: supportsPart
        return p1:IsA("Part") or p1:IsA("WedgePart") or (p1:IsA("CornerWedgePart") or p1:IsA("MeshPart") or (p1:IsA("TrussPart") or p1:IsA("UnionOperation")));
    end
};

local function canonicalNumber(p3: number, p4: number?) -- Line: 29
    local math_round_ret = math.round(p3 / (p4 or 0.0001));

    return string.format("%d", math_round_ret == 0 and 0 or math_round_ret);
end;

local function vectorRecord(p5: vector) -- Line: 38
    -- upvalues: canonicalNumber (copy)
    local table_concat = table.concat;
    local v6 = {};
    local math_round_ret = math.round(p5.X / 0.0001);
    local string_format_ret = string.format("%d", math_round_ret == 0 and 0 or math_round_ret);
    local math_round_ret2 = math.round(p5.Y / 0.0001);
    v6[1], v6[2], v6[3] = string_format_ret, string.format("%d", math_round_ret2 == 0 and 0 or math_round_ret2), canonicalNumber(p5.Z);

    return table_concat(v6, ",");
end;

local function cframeRecord(p7) -- Line: 42
    local v8 = { p7:GetComponents() };
    local table_create_ret = table.create(#v8);

    for i, v in v8 do
        local math_round_ret = math.round(v / (i <= 3 and 0.0001 or 1e-6 or 0.0001));
        table_create_ret[i] = string.format("%d", math_round_ret == 0 and 0 or math_round_ret);
    end;

    return table.concat(table_create_ret, ",");
end;

local function lengthPrefixed(p9: string) -- Line: 51
    return `{#p9}:{p9}`;
end;

local function assertInsideRoot(p10: userdata, p11: userdata) -- Line: 55
    local v12 = p11 == p10 and true or p11:IsDescendantOf(p10);
    assert(v12, "Visibility geometry is outside the selected map root");
end;

local function propertyString(u13: userdata, u14: string) -- Line: 59
    -- upvalues: vectorRecord (copy), cframeRecord (copy), canonicalNumber (copy)
    local success, result = pcall(function() -- Line: 60
        -- upvalues: u13 (copy), u14 (copy)
        return u13[u14];
    end);

    if not success or result == nil then
        return "";
    end;

    if typeof(result) == "Vector3" then
        return vectorRecord(result);
    end;

    if typeof(result) == "CFrame" then
        return cframeRecord(result);
    end;

    if typeof(result) == "number" then
        return canonicalNumber(result);
    end;

    return tostring(result);
end;

local function meshChildrenRecord(p15: userdata) -- Line: 76
    -- upvalues: propertyString (copy)
    local v16 = {};

    for _, child in p15:GetChildren() do
        if child:IsA("DataModelMesh") then
            local v17 = {
                child.ClassName,
                propertyString(child, "MeshType"),
                propertyString(child, "MeshId"),
                propertyString(child, "MeshContent"),
                propertyString(child, "Scale"),
                propertyString(child, "Offset")
            };
            table.insert(v16, table.concat(v17, "|"));
        end;
    end;

    table.sort(v16);

    return table.concat(v16, ";");
end;

local function unionRecord(p18: userdata) -- Line: 95
    -- upvalues: propertyString (copy)
    return table.concat({
        "UnionOperationV2",
        `MeshSize={propertyString(p18, "MeshSize")}`,
        `RenderFidelity={propertyString(p18, "RenderFidelity")}`,
        `SmoothingAngle={propertyString(p18, "SmoothingAngle")}`,
        (`TriangleCount={propertyString(p18, "TriangleCount")}`)
    }, "|");
end;

local function partRecord(p19: userdata, p20: userdata) -- Line: 106
    -- upvalues: u2 (copy), propertyString (copy), unionRecord (copy), cframeRecord (copy), vectorRecord (copy), meshChildrenRecord (copy)
    local v21 = u2.supportsPart(p20);
    local v22 = `Unsupported visibility geometry class {p20.ClassName}`;
    assert(v21, v22);
    local v23 = "";

    if p20:IsA("TrussPart") then
        v23 = propertyString(p20, "Style");
    elseif p20:IsA("Part") then
        v23 = tostring(p20.Shape);
    elseif p20:IsA("MeshPart") then
        v23 = table.concat({
            propertyString(p20, "MeshId"),
            propertyString(p20, "MeshContent"),
            propertyString(p20, "MeshSize"),
            propertyString(p20, "RenderFidelity"),
            propertyString(p20, "DoubleSided")
        }, "|");
    elseif p20:IsA("UnionOperation") then
        v23 = unionRecord(p20);
    end;

    local v24 = p20 == p19 and true or p20:IsDescendantOf(p19);
    assert(v24, "Visibility geometry is outside the selected map root");
    local table_concat = table.concat;
    local v25 = {};
    local ClassName = p20.ClassName;
    local v26 = `{#ClassName}:{ClassName}`;
    local v27 = cframeRecord(p20.CFrame);
    local v28 = vectorRecord(p20.Size);
    local v29 = `{#v23}:{v23}`;
    local v30 = meshChildrenRecord(p20);
    v25[1], v25[2], v25[3], v25[4], v25[5], v25[6] = "PVSOCCLUDER2", v26, v27, v28, v29, `{#v30}:{v30}`;

    return table_concat(v25, "|");
end;

local function worldBounds(p31: userdata) -- Line: 137
    local v32 = p31.Size * 0.5;
    local CFrame = p31.CFrame;
    local RightVector = CFrame.RightVector;
    local UpVector = CFrame.UpVector;
    local LookVector = CFrame.LookVector;
    local v33 = math.abs(RightVector.X) * v32.X + math.abs(UpVector.X) * v32.Y + math.abs(LookVector.X) * v32.Z;
    local v34 = math.abs(RightVector.Y) * v32.X + math.abs(UpVector.Y) * v32.Y + math.abs(LookVector.Y) * v32.Z;
    local v35 = math.abs(RightVector.Z) * v32.X + math.abs(UpVector.Z) * v32.Y + math.abs(LookVector.Z) * v32.Z;
    local Vector3_new_ret = Vector3.new(v33, v34, v35);

    return CFrame.Position - Vector3_new_ret, CFrame.Position + Vector3_new_ret;
end;

function u2.hashStrings(p36: table) -- Line: 151
    local v37 = 5381;
    local v38 = 2166136261;

    for _, v in p36 do
        local v39 = `{#v}:{v}`;

        for i = 1, #v39 do
            local string_byte_ret = string.byte(v39, i);
            v37 = (v37 * 33 + string_byte_ret) % 4294967296;
            v38 = (v38 * 65599 + string_byte_ret) % 4294967296;
            local _ = i;
        end;
    end;

    return string.format("%08x%08x", v37, v38);
end;

function u2.compute(p40: userdata, p41: table) -- Line: 165
    -- upvalues: partRecord (copy), worldBounds (copy), Constants (copy), u2 (copy)
    assert(#p41 > 0, "Cannot fingerprint an empty visibility catalog");
    local table_create_ret = table.create(#p41 + 1);
    local v42 = Vector3.new(inf, inf, inf);
    local v43 = Vector3.new(-inf, -inf, -inf);

    for _, v in p41 do
        table.insert(table_create_ret, partRecord(p40, v));
        local v44, v45 = worldBounds(v);
        v42 = v42:Min(v44);
        v43 = v43:Max(v45);
    end;

    table.sort(table_create_ret);
    local v46 = `PVSVisibilityExportVersion={Constants.EXPORT_VERSION}|Transform={Constants.EXPORT_TRANSFORM}|PartCount={#p41}`;
    table.insert(table_create_ret, 1, v46);

    return {
        fingerprint = u2.hashStrings(table_create_ret),
        minimum = v42,
        maximum = v43,
        partCount = #p41,
        records = table_create_ret
    };
end;

return table.freeze(u2);