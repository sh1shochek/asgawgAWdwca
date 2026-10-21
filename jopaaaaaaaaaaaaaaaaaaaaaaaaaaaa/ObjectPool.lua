-- ReplicatedStorage.Shared.ObjectPool
-- Script path: ReplicatedStorage.Shared.ObjectPool
-- Decompile time: 8.20 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};
u2.__index = u2;

local function asInstance(p3) -- Line: 47
    return p3;
end;

local function isPoolable(p4) -- Line: 51
    local v5;

    if typeof(p4) == "Instance" then
        v5 = p4:IsA("BasePart") or p4:IsA("Model");
    else
        v5 = false;
    end;

    return v5;
end;

local function destroy(p6: userdata) -- Line: 55
    pcall(p6.Destroy, p6);
end;

local function unparent(u7: userdata) -- Line: 59
    return pcall(function() -- Line: 60
        -- upvalues: u7 (copy)
        u7.Parent = nil;
    end);
end;

local function newStorage(p8: string, p9: userdata?) -- Line: 65
    local Folder = Instance.new("Folder");
    Folder.Name = p8;

    if p9 then
        Folder.Parent = p9;
    end;

    return Folder;
end;

local function ensureStorage(p10: table) -- Line: 77
    local StorageParent = p10.StorageParent;

    if StorageParent and (p10.Storage.Parent ~= StorageParent and StorageParent.Parent ~= nil) then
        table.clear(p10.Available);
        local StorageName = p10.StorageName;
        local Folder = Instance.new("Folder");
        Folder.Name = StorageName;

        if StorageParent then
            Folder.Parent = StorageParent;
        end;

        p10.Storage = Folder;
    end;
end;

local function park(u11: table, u12: any) -- Line: 85
    return pcall(function() -- Line: 86
        -- upvalues: u12 (copy), u11 (copy)
        u12.Parent = u11.Storage;
    end);
end;

local function clone(p13: table) -- Line: 91
    local v14 = p13.Template:Clone();

    if p13.Prepare then
        p13.Prepare(v14);
    end;

    return v14;
end;

function u2.Acquire(u15: table) -- Line: 99
    assert(not u15.Destroyed, "Cannot acquire from a destroyed ObjectPool");
    local StorageParent = u15.StorageParent;

    if StorageParent and (u15.Storage.Parent ~= StorageParent and StorageParent.Parent ~= nil) then
        table.clear(u15.Available);
        local StorageName = u15.StorageName;
        local Folder = Instance.new("Folder");
        Folder.Name = StorageName;

        if StorageParent then
            Folder.Parent = StorageParent;
        end;

        u15.Storage = Folder;
    end;

    local table_remove_ret = table.remove(u15.Available);

    while table_remove_ret and (table_remove_ret.Parent ~= u15.Storage or not (u15.InPlace or pcall(function() -- Line: 60
        -- upvalues: table_remove_ret (copy)
        table_remove_ret.Parent = nil;
    end))) do
        pcall(table_remove_ret.Destroy, table_remove_ret);
        table_remove_ret = table.remove(u15.Available);
    end;

    if not table_remove_ret then
        table_remove_ret = u15.Template:Clone();

        if u15.Prepare then
            u15.Prepare(table_remove_ret);
        end;

        if u15.InPlace then
            pcall(function() -- Line: 86
                -- upvalues: table_remove_ret (copy), u15 (copy)
                table_remove_ret.Parent = u15.Storage;
            end);
        end;
    end;

    u15.NextLease = u15.NextLease + 1;
    u15.Active[table_remove_ret] = u15.NextLease;

    return table_remove_ret, u15.NextLease;
end;

function u2.Release(u16: table, u17: any, p18: number) -- Line: 127
    if u16.Destroyed then
        return false;
    end;

    if u16.Active[u17] ~= p18 then
        return false;
    end;

    u16.Active[u17] = nil;

    if #u16.Available >= u16.MaxRetained then
        pcall(u17.Destroy, u17);

        return true;
    end;

    if not pcall(function() -- Line: 86
        -- upvalues: u17 (copy), u16 (copy)
        u17.Parent = u16.Storage;
    end) then
        pcall(u17.Destroy, u17);

        return true;
    end;

    if u16.Reset then
        local success, result = pcall(u16.Reset, u17);

        if not success then
            warn((`ObjectPool reset failed; discarding object: {tostring(result)}`));
            pcall(u17.Destroy, u17);

            return true;
        end;
    end;

    table.insert(u16.Available, u17);

    return true;
end;

function u2.IsAcquired(p19: table, p20: any, p21: number) -- Line: 161
    return not p19.Destroyed and p19.Active[p20] == p21;
end;

function u2.Destroy(p22: table) -- Line: 165
    if p22.Destroyed then
        return;
    end;

    p22.Destroyed = true;

    for i in pairs(p22.Active) do
        pcall(i.Destroy, i);
    end;

    p22.Storage:Destroy();
    table.clear(p22.Available);
    table.clear(p22.Active);
end;

function v1.new(p23: any, p24: table?) -- Line: 180
    -- upvalues: u2 (copy)
    local v25;

    if typeof(p23) == "Instance" then
        v25 = p23:IsA("BasePart") or p23:IsA("Model");
    else
        v25 = false;
    end;

    assert(v25, "ObjectPool template must be a BasePart, MeshPart, or Model");
    local v26 = p24 or {};
    local math_floor_ret = math.floor(v26.MaxRetained or 32);
    local math_max_ret = math.max(0, math_floor_ret);
    local math_floor_ret2 = math.floor(v26.InitialSize or 0);
    local math_clamp_ret = math.clamp(math_floor_ret2, 0, math_max_ret);
    local v27 = v26.StorageName or "ObjectPool";
    local v28 = {
        NextLease = 0,
        Destroyed = false,
        Template = p23
    };
    local StorageParent = v26.StorageParent;
    local Folder = Instance.new("Folder");
    Folder.Name = v27;

    if StorageParent then
        Folder.Parent = StorageParent;
    end;

    v28.Storage = Folder;
    v28.StorageParent = v26.StorageParent;
    v28.StorageName = v27;
    v28.Available = {};
    v28.Active = {};
    v28.MaxRetained = math_max_ret;
    v28.Reset = v26.Reset;
    v28.Prepare = v26.Prepare;
    v28.InPlace = v26.InPlace == true;
    local u29 = setmetatable(v28, u2);

    for i = 1, math_clamp_ret do
        local u30 = u29.Template:Clone();

        if u29.Prepare then
            u29.Prepare(u30);
        end;

        local v31;

        if pcall(function() -- Line: 86
            -- upvalues: u30 (copy), u29 (copy)
            u30.Parent = u29.Storage;
        end) then
            table.insert(u29.Available, u30);
            v31 = i;
        else
            pcall(u30.Destroy, u30);
            v31 = i;
        end;
    end;

    return u29;
end;

return v1;