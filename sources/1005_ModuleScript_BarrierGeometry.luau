-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local v1 = {};
local table_freeze_ret = table.freeze({ "BreakableDoor", "BreakableGlass", "Garage", "Market Window", "Vent" });

local function findBarrierRoot(p2: userdata) -- Line: 28
    return p2:FindFirstChild("Barriers") or p2:FindFirstChild("Barriers", true);
end;

local function shouldIgnore(p3: userdata, p4: userdata) -- Line: 36
    -- upvalues: table_freeze_ret (copy), CollectionService (copy)
    while p3 do
        if p3:GetAttribute("PVSIgnore") == true then
            return true;
        end;

        for _, v in ipairs(table_freeze_ret) do
            if CollectionService:HasTag(p3, v) then
                return true;
            end;
        end;

        if p3 == p4 then
            break;
        end;

        p3 = p3.Parent;
    end;

    return false;
end;

local function supportedKind(p5: userdata) -- Line: 55
    if p5:IsA("WedgePart") then
        return "Wedge";
    end;

    if p5:IsA("CornerWedgePart") then
        return "CornerWedge";
    end;

    if p5:IsA("Part") then
        if p5.Shape == Enum.PartType.Block then
            return "Block";
        end;

        if p5.Shape == Enum.PartType.Cylinder then
            return "Cylinder";
        end;

        if p5.Shape == Enum.PartType.Ball then
            return "Ball";
        end;

        if p5.Shape == Enum.PartType.Wedge then
            return "Wedge";
        end;

        if p5.Shape == Enum.PartType.CornerWedge then
            return "CornerWedge";
        end;
    end;

    return nil;
end;

local function relativePath(p6: userdata, p7: userdata) -- Line: 78
    local v8 = {};

    while p6 and p6 ~= p7 do
        table.insert(v8, 1, p6.Name);
        p6 = p6.Parent;
    end;

    return table.concat(v8, "/");
end;

local function geometryKey(p9: userdata, p10: userdata, p11: string) -- Line: 88
    -- upvalues: relativePath (copy)
    local v12 = { p9.CFrame:GetComponents() };
    local table_create_ret = table.create(#v12 + 3);

    for _, v in ipairs(v12) do
        table_create_ret[#table_create_ret + 1] = string.format("%.9g", v);
    end;

    table_create_ret[#table_create_ret + 1] = string.format("%.9g", p9.Size.X);
    table_create_ret[#table_create_ret + 1] = string.format("%.9g", p9.Size.Y);
    table_create_ret[#table_create_ret + 1] = string.format("%.9g", p9.Size.Z);

    return `{relativePath(p9, p10)}|{p11}|{table.concat(table_create_ret, ",")}`;
end;

local function fingerprint(p13: table) -- Line: 101
    local v14 = 5381;

    for _, v in ipairs(p13) do
        local v15 = v;

        for i = 1, #v do
            local v16 = v14 * 33 + string.byte(v15, i);
            v14 = bit32.band(v16, 4294967295);
            local _ = i;
        end;

        v14 = bit32.band(v14 * 33 + 10, 4294967295);
    end;

    return string.format("BPR1-%08x-%d", v14, #p13);
end;

function v1.collect(p17: userdata) -- Line: 112
    -- upvalues: shouldIgnore (copy), supportedKind (copy), geometryKey (copy), relativePath (copy), fingerprint (copy)
    local u18 = p17:FindFirstChild("Barriers") or p17:FindFirstChild("Barriers", true);

    if u18 == nil then
        return nil, "MissingBarriers";
    end;

    local v19 = {};
    local v20 = {};
    local v21 = {};
    local v22 = 0;
    local v23 = 0;
    local v24 = 0;
    local v25 = 0;
    local v26 = {};

    if u18:IsA("BasePart") then
        v26[#v26 + 1] = u18;
    end;

    for _, descendant in ipairs(u18:GetDescendants()) do
        if descendant:IsA("BasePart") then
            v26[#v26 + 1] = descendant;
        end;
    end;

    for _, v in ipairs(v26) do
        v22 = v22 + 1;

        if shouldIgnore(v, u18) then
            v23 = v23 + 1;
        else
            local v27 = supportedKind(v);

            if v27 == nil then
                v24 = v24 + 1;
                v21[v.ClassName] = (v21[v.ClassName] or 0) + 1;
            elseif v.CanQuery then
                v19[#v19 + 1] = v;
                v20[#v20 + 1] = geometryKey(v, u18, v27);
            else
                v25 = v25 + 1;
            end;
        end;
    end;

    if #v19 == 0 then
        return nil, "NoSupportedBarrierPrimitives";
    end;

    table.sort(v19, function(p28, p29) -- Line: 162
        -- upvalues: relativePath (ref), u18 (copy)
        return relativePath(p28, u18) < relativePath(p29, u18);
    end);
    table.sort(v20);

    return {
        root = u18,
        parts = v19,
        fingerprint = fingerprint(v20),
        totalParts = v22,
        ignoredParts = v23,
        unsupportedParts = v24,
        unqueryableParts = v25,
        unsupportedClasses = v21
    }, nil;
end;

function v1.buildRaycastParams(p30: table) -- Line: 179
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.FilterDescendantsInstances = p30.parts;
    RaycastParams_new_ret.IgnoreWater = true;
    RaycastParams_new_ret.RespectCanCollide = false;

    return RaycastParams_new_ret;
end;

function v1.describeUnsupported(p31: table) -- Line: 189
    local v32 = {};

    for i, v in pairs(p31.unsupportedClasses) do
        v32[#v32 + 1] = `{i}={v}`;
    end;

    table.sort(v32);

    return table.concat(v32, ", ");
end;

return table.freeze(v1);