-- Decompiled with Potassium's decompiler.

local u8 = {
    type = function(u1) -- Line: 5, Name: type
        return function(p2) -- Line: 6
            -- upvalues: u1 (copy)
            local v3 = type(p2);

            if v3 == u1 then
                return true;
            end;

            return false, string.format("%s expected, got %s", u1, v3);
        end;
    end,

    typeof = function(u4) -- Line: 16, Name: typeof
        return function(p5) -- Line: 17
            -- upvalues: u4 (copy)
            local v6 = typeof(p5);

            if v6 == u4 then
                return true;
            end;

            return false, string.format("%s expected, got %s", u4, v6);
        end;
    end,

    any = function(p7) -- Line: 34, Name: any
        if p7 == nil then
            return false, "any expected, got nil";
        end;

        return true;
    end
};
u8.boolean = u8.typeof("boolean");
u8.buffer = u8.typeof("buffer");
u8.thread = u8.typeof("thread");
u8.callback = u8.typeof("function");
u8["function"] = u8.callback;
u8.none = u8.typeof("nil");
u8["nil"] = u8.none;
u8.string = u8.typeof("string");
u8.table = u8.typeof("table");
u8.userdata = u8.type("userdata");
u8.vector = u8.type("vector");

function u8.number(p9) -- Line: 134
    local v10 = typeof(p9);

    if v10 ~= "number" then
        return false, string.format("number expected, got %s", v10);
    end;

    if p9 == p9 then
        return true;
    end;

    return false, "unexpected NaN value";
end;

function u8.nan(p11) -- Line: 154
    local v12 = typeof(p11);

    if v12 ~= "number" then
        return false, string.format("number expected, got %s", v12);
    end;

    if p11 == p11 then
        return false, "unexpected non-NaN value";
    end;

    return true;
end;

u8.Axes = u8.typeof("Axes");
u8.BrickColor = u8.typeof("BrickColor");
u8.CatalogSearchParams = u8.typeof("CatalogSearchParams");
u8.CFrame = u8.typeof("CFrame");
u8.Color3 = u8.typeof("Color3");
u8.ColorSequence = u8.typeof("ColorSequence");
u8.ColorSequenceKeypoint = u8.typeof("ColorSequenceKeypoint");
u8.DateTime = u8.typeof("DateTime");
u8.DockWidgetPluginGuiInfo = u8.typeof("DockWidgetPluginGuiInfo");
u8.Enum = u8.typeof("Enum");
u8.EnumItem = u8.typeof("EnumItem");
u8.Enums = u8.typeof("Enums");
u8.Faces = u8.typeof("Faces");
u8.FloatCurveKey = u8.typeof("FloatCurveKey");
u8.Font = u8.typeof("Font");
u8.Instance = u8.typeof("Instance");
u8.NumberRange = u8.typeof("NumberRange");
u8.NumberSequence = u8.typeof("NumberSequence");
u8.NumberSequenceKeypoint = u8.typeof("NumberSequenceKeypoint");
u8.OverlapParams = u8.typeof("OverlapParams");
u8.PathWaypoint = u8.typeof("PathWaypoint");
u8.PhysicalProperties = u8.typeof("PhysicalProperties");
u8.Random = u8.typeof("Random");
u8.Ray = u8.typeof("Ray");
u8.RaycastParams = u8.typeof("RaycastParams");
u8.RaycastResult = u8.typeof("RaycastResult");
u8.RBXScriptConnection = u8.typeof("RBXScriptConnection");
u8.RBXScriptSignal = u8.typeof("RBXScriptSignal");
u8.Rect = u8.typeof("Rect");
u8.Region3 = u8.typeof("Region3");
u8.Region3int16 = u8.typeof("Region3int16");
u8.TweenInfo = u8.typeof("TweenInfo");
u8.UDim = u8.typeof("UDim");
u8.UDim2 = u8.typeof("UDim2");
u8.Vector2 = u8.typeof("Vector2");
u8.Vector2int16 = u8.typeof("Vector2int16");
u8.Vector3 = u8.typeof("Vector3");
u8.Vector3int16 = u8.typeof("Vector3int16");

function u8.literal(...) -- Line: 518
    -- upvalues: u8 (copy)
    local v13 = select("#", ...);

    if v13 == 1 then
        local u14 = ...;

        return function(p15) -- Line: 522
            -- upvalues: u14 (copy)
            if p15 == u14 then
                return true;
            end;

            return false, string.format("expected %s, got %s", tostring(u14), (tostring(p15)));
        end;
    end;

    local v16 = {};

    for i = 1, v13 do
        local v17 = select(i, ...);
        v16[i] = u8.literal(v17);
        local _ = i;
    end;

    return u8.union(table.unpack(v16, 1, v13));
end;

u8.exactly = u8.literal;

function u8.keyOf(p18) -- Line: 553
    -- upvalues: u8 (copy)
    local v19 = 0;
    local v20 = {};

    for i in pairs(p18) do
        v19 = v19 + 1;
        v20[v19] = i;
    end;

    return u8.literal(table.unpack(v20, 1, v19));
end;

function u8.valueOf(p21) -- Line: 571
    -- upvalues: u8 (copy)
    local v22 = 0;
    local v23 = {};

    for _, v in pairs(p21) do
        v22 = v22 + 1;
        v23[v22] = v;
    end;

    return u8.literal(table.unpack(v23, 1, v22));
end;

function u8.integer(p24) -- Line: 589
    -- upvalues: u8 (copy)
    local v25, v26 = u8.number(p24);

    if not v25 then
        return false, v26 or "";
    end;

    if p24 % 1 == 0 then
        return true;
    end;

    return false, string.format("integer expected, got %s", p24);
end;

function u8.numberMin(u27) -- Line: 609
    -- upvalues: u8 (copy)
    return function(p28) -- Line: 610
        -- upvalues: u8 (ref), u27 (copy)
        local v29, v30 = u8.number(p28);

        if not v29 then
            return false, v30 or "";
        end;

        if u27 <= p28 then
            return true;
        end;

        return false, string.format("number >= %s expected, got %s", u27, p28);
    end;
end;

function u8.numberMax(u31) -- Line: 631
    -- upvalues: u8 (copy)
    return function(p32) -- Line: 632
        -- upvalues: u8 (ref), u31 (copy)
        local v33, v34 = u8.number(p32);

        if not v33 then
            return false, v34;
        end;

        if p32 <= u31 then
            return true;
        end;

        return false, string.format("number <= %s expected, got %s", u31, p32);
    end;
end;

function u8.numberMinExclusive(u35) -- Line: 653
    -- upvalues: u8 (copy)
    return function(p36) -- Line: 654
        -- upvalues: u8 (ref), u35 (copy)
        local v37, v38 = u8.number(p36);

        if not v37 then
            return false, v38 or "";
        end;

        if u35 < p36 then
            return true;
        end;

        return false, string.format("number > %s expected, got %s", u35, p36);
    end;
end;

function u8.numberMaxExclusive(u39) -- Line: 675
    -- upvalues: u8 (copy)
    return function(p40) -- Line: 676
        -- upvalues: u8 (ref), u39 (copy)
        local v41, v42 = u8.number(p40);

        if not v41 then
            return false, v42 or "";
        end;

        if p40 < u39 then
            return true;
        end;

        return false, string.format("number < %s expected, got %s", u39, p40);
    end;
end;

u8.numberPositive = u8.numberMinExclusive(0);
u8.numberNegative = u8.numberMaxExclusive(0);

function u8.numberConstrained(p43, p44) -- Line: 712
    -- upvalues: u8 (copy)
    assert(u8.number(p43));
    assert(u8.number(p44));
    local u45 = u8.numberMin(p43);
    local u46 = u8.numberMax(p44);

    return function(p47) -- Line: 718
        -- upvalues: u45 (copy), u46 (copy)
        local v48, v49 = u45(p47);

        if not v48 then
            return false, v49 or "";
        end;

        local v50, v51 = u46(p47);

        if v50 then
            return true;
        end;

        return false, v51 or "";
    end;
end;

function u8.numberConstrainedExclusive(p52, p53) -- Line: 741
    -- upvalues: u8 (copy)
    assert(u8.number(p52));
    assert(u8.number(p53));
    local u54 = u8.numberMinExclusive(p52);
    local u55 = u8.numberMaxExclusive(p53);

    return function(p56) -- Line: 747
        -- upvalues: u54 (copy), u55 (copy)
        local v57, v58 = u54(p56);

        if not v57 then
            return false, v58 or "";
        end;

        local v59, v60 = u55(p56);

        if v59 then
            return true;
        end;

        return false, v60 or "";
    end;
end;

function u8.match(u61) -- Line: 769
    -- upvalues: u8 (copy)
    assert(u8.string(u61));

    return function(p62) -- Line: 771
        -- upvalues: u8 (ref), u61 (copy)
        local v63, v64 = u8.string(p62);

        if not v63 then
            return false, v64;
        end;

        if string.match(p62, u61) == nil then
            return false, string.format("%q failed to match pattern %q", p62, u61);
        end;

        return true;
    end;
end;

function u8.optional(u65) -- Line: 792
    -- upvalues: u8 (copy)
    assert(u8.callback(u65));

    return function(p66) -- Line: 794
        -- upvalues: u65 (copy)
        if p66 == nil then
            return true;
        end;

        local v67, v68 = u65(p66);

        if v67 then
            return true;
        end;

        return false, string.format("(optional) %s", v68 or "");
    end;
end;

function u8.tuple(...) -- Line: 815
    local u69 = { ... };

    return function(...) -- Line: 817
        -- upvalues: u69 (copy)
        local v70 = { ... };

        for i, v in ipairs(u69) do
            local v71, v72 = v(v70[i]);

            if v71 == false then
                return false, string.format("Bad tuple index #%s:\n\t%s", i, v72 or "");
            end;
        end;

        return true;
    end;
end;

function u8.keys(u73) -- Line: 837
    -- upvalues: u8 (copy)
    assert(u8.callback(u73));

    return function(p74) -- Line: 839
        -- upvalues: u8 (ref), u73 (copy)
        local v75, v76 = u8.table(p74);

        if v75 == false then
            return false, v76 or "";
        end;

        for i in pairs(p74) do
            local v77, v78 = u73(i);

            if v77 == false then
                return false, string.format("bad key %s:\n\t%s", tostring(i), v78 or "");
            end;
        end;

        return true;
    end;
end;

function u8.values(u79) -- Line: 863
    -- upvalues: u8 (copy)
    assert(u8.callback(u79));

    return function(p80) -- Line: 865
        -- upvalues: u8 (ref), u79 (copy)
        local v81, v82 = u8.table(p80);

        if v81 == false then
            return false, v82 or "";
        end;

        for i, v in pairs(p80) do
            local v83, v84 = u79(v);

            if v83 == false then
                return false, string.format("bad value for key %s:\n\t%s", tostring(i), v84 or "");
            end;
        end;

        return true;
    end;
end;

function u8.map(p85, p86) -- Line: 890
    -- upvalues: u8 (copy)
    assert(u8.callback(p85));
    assert(u8.callback(p86));
    local u87 = u8.keys(p85);
    local u88 = u8.values(p86);

    return function(p89) -- Line: 896
        -- upvalues: u87 (copy), u88 (copy)
        local v90, v91 = u87(p89);

        if not v90 then
            return false, v91 or "";
        end;

        local v92, v93 = u88(p89);

        if v92 then
            return true;
        end;

        return false, v93 or "";
    end;
end;

function u8.set(p94) -- Line: 918
    -- upvalues: u8 (copy)
    return u8.map(p94, u8.literal(true));
end;

local u95 = u8.keys(u8.integer);

function u8.array(p96) -- Line: 931
    -- upvalues: u8 (copy), u95 (copy)
    assert(u8.callback(p96));
    local u97 = u8.values(p96);

    return function(p98) -- Line: 935
        -- upvalues: u95 (ref), u97 (copy)
        local v99, v100 = u95(p98);

        if v99 == false then
            return false, string.format("[array] %s", v100 or "");
        end;

        local v101 = 0;

        for _ in ipairs(p98) do
            v101 = v101 + 1;
        end;

        for i in pairs(p98) do
            if i < 1 or v101 < i then
                return false, string.format("[array] key %s must be sequential", (tostring(i)));
            end;
        end;

        local v102, v103 = u97(p98);

        if v102 then
            return true;
        end;

        return false, string.format("[array] %s", v103 or "");
    end;
end;

function u8.strictArray(...) -- Line: 971
    -- upvalues: u8 (copy), u95 (copy)
    local u104 = { ... };
    local v105 = u8.array(u8.callback);
    assert(v105(u104));

    return function(p106) -- Line: 975
        -- upvalues: u95 (ref), u104 (copy)
        local v107, v108 = u95(p106);

        if v107 == false then
            return false, string.format("[strictArray] %s", v108 or "");
        end;

        if #u104 < #p106 then
            return false, string.format("[strictArray] Array size exceeds limit of %d", #u104);
        end;

        for i, v in pairs(u104) do
            local v109, v110 = v(p106[i]);

            if not v109 then
                return false, string.format("[strictArray] Array index #%d - %s", i, v110);
            end;
        end;

        return true;
    end;
end;

local u111 = u8.array(u8.callback);

function u8.union(...) -- Line: 1007
    -- upvalues: u111 (copy)
    local u112 = { ... };
    assert(u111(u112));

    return function(p113) -- Line: 1011
        -- upvalues: u112 (copy)
        for _, v in ipairs(u112) do
            if v(p113) then
                return true;
            end;
        end;

        return false, "bad type for union";
    end;
end;

u8.some = u8.union;

function u8.intersection(...) -- Line: 1034
    -- upvalues: u111 (copy)
    local u114 = { ... };
    assert(u111(u114));

    return function(p115) -- Line: 1038
        -- upvalues: u114 (copy)
        for _, v in ipairs(u114) do
            local v116, v117 = v(p115);

            if not v116 then
                return false, v117 or "";
            end;
        end;

        return true;
    end;
end;

u8.every = u8.intersection;
local u118 = u8.map(u8.any, u8.callback);

function u8.interface(u119) -- Line: 1065
    -- upvalues: u118 (copy), u8 (copy)
    assert(u118(u119));

    return function(p120) -- Line: 1067
        -- upvalues: u8 (ref), u119 (copy)
        local v121, v122 = u8.table(p120);

        if v121 == false then
            return false, v122 or "";
        end;

        for i, v in pairs(u119) do
            local v123, v124 = v(p120[i]);

            if v123 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(i), v124 or "");
            end;
        end;

        return true;
    end;
end;

function u8.strictInterface(u125) -- Line: 1091
    -- upvalues: u118 (copy), u8 (copy)
    assert(u118(u125));

    return function(p126) -- Line: 1093
        -- upvalues: u8 (ref), u125 (copy)
        local v127, v128 = u8.table(p126);

        if v127 == false then
            return false, v128 or "";
        end;

        for i, v in pairs(u125) do
            local v129, v130 = v(p126[i]);

            if v129 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(i), v130 or "");
            end;
        end;

        for i in pairs(p126) do
            if not u125[i] then
                return false, string.format("[interface] unexpected field %q", (tostring(i)));
            end;
        end;

        return true;
    end;
end;

function u8.instanceOf(u131, p132) -- Line: 1124
    -- upvalues: u8 (copy)
    assert(u8.string(u131));
    local u133;

    if p132 == nil then
        u133 = nil;
    else
        u133 = u8.children(p132);
    end;

    return function(p134) -- Line: 1132
        -- upvalues: u8 (ref), u131 (copy), u133 (ref)
        local v135, v136 = u8.Instance(p134);

        if not v135 then
            return false, v136 or "";
        end;

        if p134.ClassName ~= u131 then
            return false, string.format("%s expected, got %s", u131, p134.ClassName);
        end;

        if u133 then
            local v137, v138 = u133(p134);

            if not v137 then
                return false, v138;
            end;
        end;

        return true;
    end;
end;

u8.instance = u8.instanceOf;

function u8.instanceIsA(u139, p140) -- Line: 1162
    -- upvalues: u8 (copy)
    assert(u8.string(u139));
    local u141;

    if p140 == nil then
        u141 = nil;
    else
        u141 = u8.children(p140);
    end;

    return function(p142) -- Line: 1170
        -- upvalues: u8 (ref), u139 (copy), u141 (ref)
        local v143, v144 = u8.Instance(p142);

        if not v143 then
            return false, v144 or "";
        end;

        if not p142:IsA(u139) then
            return false, string.format("%s expected, got %s", u139, p142.ClassName);
        end;

        if u141 then
            local v145, v146 = u141(p142);

            if not v145 then
                return false, v146;
            end;
        end;

        return true;
    end;
end;

function u8.enum(u147) -- Line: 1198
    -- upvalues: u8 (copy)
    assert(u8.Enum(u147));

    return function(p148) -- Line: 1200
        -- upvalues: u8 (ref), u147 (copy)
        local v149, v150 = u8.EnumItem(p148);

        if not v149 then
            return false, v150;
        end;

        if p148.EnumType == u147 then
            return true;
        end;

        return false, string.format("enum of %s expected, got enum of %s", tostring(u147), (tostring(p148.EnumType)));
    end;
end;

local u151 = u8.tuple(u8.callback, u8.callback);

function u8.wrap(u152, u153) -- Line: 1225
    -- upvalues: u151 (copy)
    assert(u151(u152, u153));

    return function(...) -- Line: 1227
        -- upvalues: u153 (copy), u152 (copy)
        assert(u153(...));

        return u152(...);
    end;
end;

function u8.strict(u154) -- Line: 1241
    return function(...) -- Line: 1242
        -- upvalues: u154 (copy)
        assert(u154(...));
    end;
end;

local u155 = u8.map(u8.string, u8.callback);

function u8.children(u156) -- Line: 1261
    -- upvalues: u155 (copy), u8 (copy)
    assert(u155(u156));

    return function(p157) -- Line: 1264
        -- upvalues: u8 (ref), u156 (copy)
        local v158, v159 = u8.Instance(p157);

        if not v158 then
            return false, v159 or "";
        end;

        local v160 = {};

        for _, child in ipairs(p157:GetChildren()) do
            local Name = child.Name;

            if u156[Name] then
                if v160[Name] then
                    return false, string.format("Cannot process multiple children with the same name %q", Name);
                end;

                v160[Name] = child;
            end;
        end;

        for i, v in pairs(u156) do
            local v161, v162 = v(v160[i]);

            if not v161 then
                return false, string.format("[%s.%s] %s", p157:GetFullName(), i, v162 or "");
            end;
        end;

        return true;
    end;
end;

return u8;