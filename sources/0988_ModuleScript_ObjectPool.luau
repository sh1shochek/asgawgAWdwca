-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};
u2.__index = u2;

local function asInstance(p3) -- Line: 41
    return p3;
end;

local function isPoolable(p4) -- Line: 45
    local v5;

    if typeof(p4) == "Instance" then
        v5 = p4:IsA("BasePart") or p4:IsA("Model");
    else
        v5 = false;
    end;

    return v5;
end;

local function destroy(p6: userdata) -- Line: 49
    pcall(p6.Destroy, p6);
end;

local function unparent(u7: userdata) -- Line: 53
    return pcall(function() -- Line: 54
        -- upvalues: u7 (copy)
        u7.Parent = nil;
    end);
end;

local function park(u8: table, u9: any) -- Line: 59
    return pcall(function() -- Line: 60
        -- upvalues: u9 (copy), u8 (copy)
        u9.Parent = u8.Storage;
    end);
end;

local function clone(p10: table) -- Line: 65
    return p10.Template:Clone();
end;

function u2.Acquire(p11: table) -- Line: 69
    assert(not p11.Destroyed, "Cannot acquire from a destroyed ObjectPool");
    local table_remove_ret = table.remove(p11.Available);

    while table_remove_ret and (table_remove_ret.Parent ~= p11.Storage or not (p11.InPlace or pcall(function() -- Line: 54
        -- upvalues: table_remove_ret (copy)
        table_remove_ret.Parent = nil;
    end))) do
        pcall(table_remove_ret.Destroy, table_remove_ret);
        table_remove_ret = table.remove(p11.Available);
    end;

    local v12 = table_remove_ret or p11.Template:Clone();
    p11.NextLease = p11.NextLease + 1;
    p11.Active[v12] = p11.NextLease;

    return v12, p11.NextLease;
end;

function u2.Release(u13: table, u14: any, p15: number) -- Line: 89
    if u13.Destroyed then
        return false;
    end;

    if u13.Active[u14] ~= p15 then
        return false;
    end;

    u13.Active[u14] = nil;

    if #u13.Available >= u13.MaxRetained then
        pcall(u14.Destroy, u14);

        return true;
    end;

    if not pcall(function() -- Line: 60
        -- upvalues: u14 (copy), u13 (copy)
        u14.Parent = u13.Storage;
    end) then
        pcall(u14.Destroy, u14);

        return true;
    end;

    if u13.Reset then
        local success, result = pcall(u13.Reset, u14);

        if not success then
            warn((`ObjectPool reset failed; discarding object: {tostring(result)}`));
            pcall(u14.Destroy, u14);

            return true;
        end;
    end;

    table.insert(u13.Available, u14);

    return true;
end;

function u2.IsAcquired(p16: table, p17: any, p18: number) -- Line: 123
    return not p16.Destroyed and p16.Active[p17] == p18;
end;

function u2.Destroy(p19: table) -- Line: 127
    if p19.Destroyed then
        return;
    end;

    p19.Destroyed = true;

    for i in pairs(p19.Active) do
        pcall(i.Destroy, i);
    end;

    p19.Storage:Destroy();
    table.clear(p19.Available);
    table.clear(p19.Active);
end;

function v1.new(p20: any, p21: table?) -- Line: 142
    -- upvalues: u2 (copy)
    local v22;

    if typeof(p20) == "Instance" then
        v22 = p20:IsA("BasePart") or p20:IsA("Model");
    else
        v22 = false;
    end;

    assert(v22, "ObjectPool template must be a BasePart, MeshPart, or Model");
    local v23 = p21 or {};
    local math_floor_ret = math.floor(v23.MaxRetained or 32);
    local math_max_ret = math.max(0, math_floor_ret);
    local math_floor_ret2 = math.floor(v23.InitialSize or 0);
    local math_clamp_ret = math.clamp(math_floor_ret2, 0, math_max_ret);
    local Folder = Instance.new("Folder");
    Folder.Name = v23.StorageName or "ObjectPool";

    if v23.StorageParent then
        Folder.Parent = v23.StorageParent;
    end;

    local u24 = setmetatable({
        NextLease = 0,
        Destroyed = false,
        Template = p20,
        Storage = Folder,
        Available = {},
        Active = {},
        MaxRetained = math_max_ret,
        Reset = v23.Reset,
        InPlace = v23.InPlace == true
    }, u2);

    for i = 1, math_clamp_ret do
        local u25 = u24.Template:Clone();
        local v26;

        if pcall(function() -- Line: 60
            -- upvalues: u25 (copy), u24 (copy)
            u25.Parent = u24.Storage;
        end) then
            table.insert(u24.Available, u25);
            v26 = i;
        else
            pcall(u25.Destroy, u25);
            v26 = i;
        end;
    end;

    return u24;
end;

return v1;