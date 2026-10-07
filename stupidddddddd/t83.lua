-- ReplicatedStorage.Packages._Index.osyrisrblx_t@3.1.1.t
-- Script path: ReplicatedStorage.Packages._Index.osyrisrblx_t@3.1.1.t
-- Decompile time: 6.23 ms

local u0 = {}

function u0.type(a1) -- Line: 5
    return function(a1_2) -- Line: 6 -- upvalues: a1 (val)
        local v1 = type(a1_2)
        if v1 == a1 then
            return true
        end
        return false, string.format("%s expected, got %s", a1, v1)
    end
end

function u0.typeof(a1) -- Line: 16
    return function(a1_2) -- Line: 17 -- upvalues: a1 (val)
        local v1 = typeof(a1_2)
        if v1 == a1 then
            return true
        end
        return false, string.format("%s expected, got %s", a1, v1)
    end
end

function u0.any(a1) -- Line: 34
    if a1 ~= nil then
        return true
    end
    return false, "any expected, got nil"
end

u0.boolean = u0.typeof("boolean")
u0.buffer = u0.typeof("buffer")
u0.thread = u0.typeof("thread")
u0.callback = u0.typeof("function")
u0["function"] = u0.callback
u0.none = u0.typeof("nil")
u0["nil"] = u0.none
u0.string = u0.typeof("string")
u0.table = u0.typeof("table")
u0.userdata = u0.type("userdata")
u0.vector = u0.type("vector")

function u0.number(a1) -- Line: 134
    local v1 = typeof(a1)
    if v1 ~= "number" then
        return false, string.format("number expected, got %s", v1)
    end
    if a1 == a1 then
        return true
    end
    return false, "unexpected NaN value"
end

function u0.nan(a1) -- Line: 154
    local v1 = typeof(a1)
    if v1 ~= "number" then
        return false, string.format("number expected, got %s", v1)
    end
    if a1 ~= a1 then
        return true
    end
    return false, "unexpected non-NaN value"
end

u0.Axes = u0.typeof("Axes")
u0.BrickColor = u0.typeof("BrickColor")
u0.CatalogSearchParams = u0.typeof("CatalogSearchParams")
u0.CFrame = u0.typeof("CFrame")
u0.Color3 = u0.typeof("Color3")
u0.ColorSequence = u0.typeof("ColorSequence")
u0.ColorSequenceKeypoint = u0.typeof("ColorSequenceKeypoint")
u0.DateTime = u0.typeof("DateTime")
u0.DockWidgetPluginGuiInfo = u0.typeof("DockWidgetPluginGuiInfo")
u0.Enum = u0.typeof("Enum")
u0.EnumItem = u0.typeof("EnumItem")
u0.Enums = u0.typeof("Enums")
u0.Faces = u0.typeof("Faces")
u0.FloatCurveKey = u0.typeof("FloatCurveKey")
u0.Font = u0.typeof("Font")
u0.Instance = u0.typeof("Instance")
u0.NumberRange = u0.typeof("NumberRange")
u0.NumberSequence = u0.typeof("NumberSequence")
u0.NumberSequenceKeypoint = u0.typeof("NumberSequenceKeypoint")
u0.OverlapParams = u0.typeof("OverlapParams")
u0.PathWaypoint = u0.typeof("PathWaypoint")
u0.PhysicalProperties = u0.typeof("PhysicalProperties")
u0.Random = u0.typeof("Random")
u0.Ray = u0.typeof("Ray")
u0.RaycastParams = u0.typeof("RaycastParams")
u0.RaycastResult = u0.typeof("RaycastResult")
u0.RBXScriptConnection = u0.typeof("RBXScriptConnection")
u0.RBXScriptSignal = u0.typeof("RBXScriptSignal")
u0.Rect = u0.typeof("Rect")
u0.Region3 = u0.typeof("Region3")
u0.Region3int16 = u0.typeof("Region3int16")
u0.TweenInfo = u0.typeof("TweenInfo")
u0.UDim = u0.typeof("UDim")
u0.UDim2 = u0.typeof("UDim2")
u0.Vector2 = u0.typeof("Vector2")
u0.Vector2int16 = u0.typeof("Vector2int16")
u0.Vector3 = u0.typeof("Vector3")
u0.Vector3int16 = u0.typeof("Vector3int16")

function u0.literal(...) -- Line: 518 -- upvalues: u0 (val)
    local v1
    local v2 = select("#", ...)
    if v2 == 1 then
        local u4 = ...
        return function(a1) -- Line: 522 -- upvalues: u4 (val)
            if a1 ~= u4 then
                return false, string.format("expected %s, got %s", tostring(u4), (tostring(a1)))
            end
            return true
        end
    end
    local v3 = {}
    for i = 1, v2 do
        v1 = select(i, ...)
        v3[i] = (u0.literal(v1))
    end
    return u0.union(table.unpack(v3, 1, v2))
end

u0.exactly = u0.literal

function u0.keyOf(a1) -- Line: 553 -- upvalues: u0 (val)
    local v1 = {}
    local v2 = 0
    for k in pairs(a1) do
        v2 = v2 + 1
        v1[v2] = k
    end
    return u0.literal(table.unpack(v1, 1, v2))
end

function u0.valueOf(a1) -- Line: 571 -- upvalues: u0 (val)
    local v1 = {}
    local v2 = 0
    for k, v in pairs(a1) do
        v2 = v2 + 1
        v1[v2] = v
    end
    return u0.literal(table.unpack(v1, 1, v2))
end

function u0.integer(a1) -- Line: 589 -- upvalues: u0 (val)
    local v1, v2 = u0.number(a1)
    if not v1 then
        return false, v2 or ""
    end
    if a1 % 1 == 0 then
        return true
    end
    return false, string.format("integer expected, got %s", a1)
end

function u0.numberMin(a1) -- Line: 609 -- upvalues: u0 (val)
    return function(a1_2) -- Line: 610 -- upvalues: u0 (upval), a1 (val)
        local v1, v2 = u0.number(a1_2)
        if not v1 then
            return false, v2 or ""
        end
        if a1 <= a1_2 then
            return true
        end
        return false, string.format("number >= %s expected, got %s", a1, a1_2)
    end
end

function u0.numberMax(a1) -- Line: 631 -- upvalues: u0 (val)
    return function(a1_2) -- Line: 632 -- upvalues: u0 (upval), a1 (val)
        local v1, v2 = u0.number(a1_2)
        if not v1 then
            return false, v2
        end
        if a1_2 <= a1 then
            return true
        end
        return false, string.format("number <= %s expected, got %s", a1, a1_2)
    end
end

function u0.numberMinExclusive(a1) -- Line: 653 -- upvalues: u0 (val)
    return function(a1_2) -- Line: 654 -- upvalues: u0 (upval), a1 (val)
        local v1, v2 = u0.number(a1_2)
        if not v1 then
            return false, v2 or ""
        end
        if a1 < a1_2 then
            return true
        end
        return false, string.format("number > %s expected, got %s", a1, a1_2)
    end
end

function u0.numberMaxExclusive(a1) -- Line: 675 -- upvalues: u0 (val)
    return function(a1_2) -- Line: 676 -- upvalues: u0 (upval), a1 (val)
        local v1, v2 = u0.number(a1_2)
        if not v1 then
            return false, v2 or ""
        end
        if a1_2 < a1 then
            return true
        end
        return false, string.format("number < %s expected, got %s", a1, a1_2)
    end
end

u0.numberPositive = u0.numberMinExclusive(0)
u0.numberNegative = u0.numberMaxExclusive(0)

function u0.numberConstrained(a1, a2) -- Line: 712 -- upvalues: u0 (val)
    assert((u0.number(a1)))
    assert((u0.number(a2)))
    local u17 = u0.numberMin(a1)
    local u21 = u0.numberMax(a2)
    return function(a1) -- Line: 718 -- upvalues: u17 (val), u21 (val)
        local v1, v2 = u17(a1)
        if not v1 then
            return false, v2 or ""
        end
        local v3, v4 = u21(a1)
        if not v3 then
            return false, v4 or ""
        end
        return true
    end
end

function u0.numberConstrainedExclusive(a1, a2) -- Line: 741 -- upvalues: u0 (val)
    assert((u0.number(a1)))
    assert((u0.number(a2)))
    local u17 = u0.numberMinExclusive(a1)
    local u21 = u0.numberMaxExclusive(a2)
    return function(a1) -- Line: 747 -- upvalues: u17 (val), u21 (val)
        local v1, v2 = u17(a1)
        if not v1 then
            return false, v2 or ""
        end
        local v3, v4 = u21(a1)
        if not v3 then
            return false, v4 or ""
        end
        return true
    end
end

function u0.match(a1) -- Line: 769 -- upvalues: u0 (val)
    assert((u0.string(a1)))
    return function(a1_2) -- Line: 771 -- upvalues: u0 (upval), a1 (val)
        local v1, v2 = u0.string(a1_2)
        if not v1 then
            return false, v2
        end
        if string.match(a1_2, a1) == nil then
            return false, string.format("%q failed to match pattern %q", a1_2, a1)
        end
        return true
    end
end

function u0.optional(a1) -- Line: 792 -- upvalues: u0 (val)
    assert((u0.callback(a1)))
    return function(a1_2) -- Line: 794 -- upvalues: a1 (val)
        if a1_2 == nil then
            return true
        end
        local v1, v2 = a1(a1_2)
        if v1 then
            return true
        end
        return false, string.format("(optional) %s", v2 or "")
    end
end

function u0.tuple(...) -- Line: 815
    local u0 = {}
    u0[1] = ...
    return function(...) -- Line: 817 -- upvalues: u0 (val)
        local v1, v2
        local v3 = {...}
        for i, v in ipairs(u0) do
            v1, v2 = v(v3[i])
            if v1 == false then
                return false, string.format("Bad tuple index #%s:\n\t%s", i, v2 or "")
            end
        end
        return true
    end
end

function u0.keys(a1) -- Line: 837 -- upvalues: u0 (val)
    assert((u0.callback(a1)))
    return function(a1_2) -- Line: 839 -- upvalues: u0 (upval), a1 (val)
        local v1, v2
        local v3, v4 = u0.table(a1_2)
        if v3 == false then
            return false, v4 or ""
        end
        for k in pairs(a1_2) do
            v1, v2 = a1(k)
            if v1 == false then
                return false, string.format("bad key %s:\n\t%s", tostring(k), v2 or "")
            end
        end
        return true
    end
end

function u0.values(a1) -- Line: 863 -- upvalues: u0 (val)
    assert((u0.callback(a1)))
    return function(a1_2) -- Line: 865 -- upvalues: u0 (upval), a1 (val)
        local v1, v2
        local v3, v4 = u0.table(a1_2)
        if v3 == false then
            return false, v4 or ""
        end
        for k, v in pairs(a1_2) do
            v1, v2 = a1(v)
            if v1 == false then
                return false, string.format("bad value for key %s:\n\t%s", tostring(k), v2 or "")
            end
        end
        return true
    end
end

function u0.map(a1, a2) -- Line: 890 -- upvalues: u0 (val)
    assert((u0.callback(a1)))
    assert((u0.callback(a2)))
    local u17 = u0.keys(a1)
    local u21 = u0.values(a2)
    return function(a1) -- Line: 896 -- upvalues: u17 (val), u21 (val)
        local v1, v2 = u17(a1)
        if not v1 then
            return false, v2 or ""
        end
        local v3, v4 = u21(a1)
        if not v3 then
            return false, v4 or ""
        end
        return true
    end
end

function u0.set(a1) -- Line: 918 -- upvalues: u0 (val)
    return u0.map(a1, u0.literal(true))
end

local u175 = u0.keys(u0.integer)

function u0.array(a1) -- Line: 931 -- upvalues: u0 (val), u175 (val)
    assert((u0.callback(a1)))
    local u10 = u0.values(a1)
    return function(a1) -- Line: 935 -- upvalues: u175 (upval), u10 (val)
        local v1, v2 = u175(a1)
        if v1 == false then
            return false, string.format("[array] %s", v2 or "")
        end
        local v3 = 0
        for i in ipairs(a1) do
            v3 = v3 + 1
        end
        for k in pairs(a1) do
            if not (k < 1) and not (v3 < k) then
                continue
            end
            return false, string.format("[array] key %s must be sequential", (tostring(k)))
        end
        local v4, v5 = u10(a1)
        if not v4 then
            return false, string.format("[array] %s", v5 or "")
        end
        return true
    end
end

function u0.strictArray(...) -- Line: 971 -- upvalues: u0 (val), u175 (val)
    local u0_2 = {}
    u0_2[1] = ...
    assert((u0.array(u0.callback)(u0_2)))
    return function(a1) -- Line: 975 -- upvalues: u175 (upval), u0_2 (val)
        local v1, v2
        local v3, v4 = u175(a1)
        if v3 == false then
            return false, string.format("[strictArray] %s", v4 or "")
        end
        if #u0_2 < #a1 then
            return false, string.format("[strictArray] Array size exceeds limit of %d", #u0_2)
        end
        for k, v in pairs(u0_2) do
            v1, v2 = v(a1[k])
            if not v1 then
                return false, string.format("[strictArray] Array index #%d - %s", k, v2)
            end
        end
        return true
    end
end

local u180 = u0.array(u0.callback)

function u0.union(...) -- Line: 1007 -- upvalues: u180 (val)
    local u0 = {}
    u0[1] = ...
    assert((u180(u0)))
    return function(a1) -- Line: 1011 -- upvalues: u0 (val)
        for i, v in ipairs(u0) do
            if v(a1) then
                return true
            end
        end
        return false, "bad type for union"
    end
end

u0.some = u0.union

function u0.intersection(...) -- Line: 1034 -- upvalues: u180 (val)
    local u0 = {}
    u0[1] = ...
    assert((u180(u0)))
    return function(a1) -- Line: 1038 -- upvalues: u0 (val)
        local v1, v2
        for i, v in ipairs(u0) do
            v1, v2 = v(a1)
            if not v1 then
                return false, v2 or ""
            end
        end
        return true
    end
end

u0.every = u0.intersection
local u188 = u0.map(u0.any, u0.callback)

function u0.interface(a1) -- Line: 1065 -- upvalues: u188 (val), u0 (val)
    assert((u188(a1)))
    return function(a1_2) -- Line: 1067 -- upvalues: u0 (upval), a1 (val)
        local v1, v2
        local v3, v4 = u0.table(a1_2)
        if v3 == false then
            return false, v4 or ""
        end
        for k, v in pairs(a1) do
            v1, v2 = v(a1_2[k])
            if v1 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v2 or "")
            end
        end
        return true
    end
end

function u0.strictInterface(a1) -- Line: 1091 -- upvalues: u188 (val), u0 (val)
    assert((u188(a1)))
    return function(a1_2) -- Line: 1093 -- upvalues: u0 (upval), a1 (val)
        local v1, v2
        local v3, v4 = u0.table(a1_2)
        if v3 == false then
            return false, v4 or ""
        end
        for k, v in pairs(a1) do
            v1, v2 = v(a1_2[k])
            if v1 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v2 or "")
            end
        end
        for k2 in pairs(a1_2) do
            if not a1[k2] then
                return false, string.format("[interface] unexpected field %q", (tostring(k2)))
            end
        end
        return true
    end
end

function u0.instanceOf(a1, a2) -- Line: 1124 -- upvalues: u0 (val)
    assert((u0.string(a1)))
    local u13 = nil
    if a2 ~= nil then
        u13 = u0.children(a2)
    end
    return function(a1_2) -- Line: 1132 -- upvalues: u0 (upval), a1 (val), u13 (ref)
        local v1, v2 = u0.Instance(a1_2)
        if not v1 then
            return false, v2 or ""
        end
        if a1_2.ClassName ~= a1 then
            return false, string.format("%s expected, got %s", a1, a1_2.ClassName)
        end
        if u13 then
            local v3, v4 = u13(a1_2)
            if not v3 then
                return false, v4
            end
        end
        return true
    end
end

u0.instance = u0.instanceOf

function u0.instanceIsA(a1, a2) -- Line: 1162 -- upvalues: u0 (val)
    assert((u0.string(a1)))
    local u13 = nil
    if a2 ~= nil then
        u13 = u0.children(a2)
    end
    return function(a1_2) -- Line: 1170 -- upvalues: u0 (upval), a1 (val), u13 (ref)
        local v1, v2 = u0.Instance(a1_2)
        if not v1 then
            return false, v2 or ""
        end
        if not a1_2:IsA(a1) then
            return false, string.format("%s expected, got %s", a1, a1_2.ClassName)
        end
        if u13 then
            local v3, v4 = u13(a1_2)
            if not v3 then
                return false, v4
            end
        end
        return true
    end
end

function u0.enum(a1) -- Line: 1198 -- upvalues: u0 (val)
    assert((u0.Enum(a1)))
    return function(a1_2) -- Line: 1200 -- upvalues: u0 (upval), a1 (val)
        local v1, v2 = u0.EnumItem(a1_2)
        if not v1 then
            return false, v2
        end
        if a1_2.EnumType == a1 then
            return true
        end
        return false, string.format("enum of %s expected, got enum of %s", tostring(a1), (tostring(a1_2.EnumType)))
    end
end

local u198 = u0.tuple(u0.callback, u0.callback)

function u0.wrap(a1, a2) -- Line: 1225 -- upvalues: u198 (val)
    assert((u198(a1, a2)))
    return function(...) -- Line: 1227 -- upvalues: a2 (val), a1 (val)
        assert((a2(...)))
        return a1(...)
    end
end

function u0.strict(a1) -- Line: 1241
    return function(...) -- Line: 1242 -- upvalues: a1 (val)
        assert((a1(...)))
    end
end

local u204 = u0.map(u0.string, u0.callback)

function u0.children(a1) -- Line: 1261 -- upvalues: u204 (val), u0 (val)
    assert((u204(a1)))
    return function(a1_2) -- Line: 1264 -- upvalues: u0 (upval), a1 (val)
        local Name, v1, v2
        local v3, v4 = u0.Instance(a1_2)
        if not v3 then
            return false, v4 or ""
        end
        local v5 = {}
        for i, v in ipairs(a1_2:GetChildren()) do
            Name = v.Name
            if a1[Name] then
                if v5[Name] then
                    return false, string.format("Cannot process multiple children with the same name %q", Name)
                end
                v5[Name] = v
            end
        end
        for k, i2 in pairs(a1) do
            v2, v1 = i2(v5[k])
            if not v2 then
                return false, string.format("[%s.%s] %s", a1_2:GetFullName(), k, v1 or "")
            end
        end
        return true
    end
end

return u0