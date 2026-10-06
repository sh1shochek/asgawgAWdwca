-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local Profiler = require(game:GetService("ReplicatedStorage").Shared.Profiler);
local u2 = {};
local u3 = 0;
local u4 = 0;

local function newScheduler(p5: string) -- Line: 53
    return {
        Connection = nil,
        NeedsCompact = false,
        NeedsSort = false,
        Stepping = false,
        EventName = p5,
        ProfileLabel = `RunServiceController.{p5}`,
        Bindings = {},
        BindingsByName = {},
        StepBindings = {},
        RenderPriorityBindings = {},
        RenderStepNames = {}
    };
end;

local u6 = {
    Heartbeat = newScheduler("Heartbeat"),
    RenderStepped = newScheduler("RenderStepped"),
    Stepped = newScheduler("Stepped"),
    PostSimulation = newScheduler("PostSimulation")
};

local function getTraceback(p7) -- Line: 79
    return debug.traceback(tostring(p7), 2);
end;

local function isDynamicNameSegment(p8: string) -- Line: 83
    local v9;

    if tonumber(p8) == nil and string.find(p8, "-", 1, true) == nil then
        if #p8 >= 8 then
            v9 = string.find(p8, "%d") ~= nil;
        else
            v9 = false;
        end;
    else
        v9 = true;
    end;

    return v9;
end;

local function getBindingProfileLabel(p10: string, p11: string) -- Line: 89
    local table_create_ret = table.create(8);

    for _, v in ipairs(string.split(p11, ".")) do
        local v12;

        if tonumber(v) == nil and string.find(v, "-", 1, true) == nil then
            if #v >= 8 then
                v12 = string.find(v, "%d") ~= nil;
            else
                v12 = false;
            end;
        else
            v12 = true;
        end;

        table.insert(table_create_ret, v12 and "#" or v);
    end;

    return `RunService.{p10}.{table.concat(table_create_ret, ".")}`;
end;

local function syncSchedulerConnections(p13: table) -- Line: 99
    -- upvalues: RunService (copy)
    if #p13.StepBindings == 0 and p13.Connection then
        p13.Connection:Disconnect();
        p13.Connection = nil;
    end;

    for i, v in pairs(p13.RenderStepNames) do
        local v14 = p13.RenderPriorityBindings[i];

        if not v14 or #v14 == 0 then
            RunService:UnbindFromRenderStep(v);
            p13.RenderStepNames[i] = nil;
        end;
    end;
end;

local function rebuildScheduler(p15: table) -- Line: 114
    -- upvalues: syncSchedulerConnections (copy)
    local v16 = 1;

    for i = 1, #p15.Bindings do
        local v17 = p15.Bindings[i];
        local v18;

        if v17.Connected then
            p15.Bindings[v16] = v17;
            v16 = v16 + 1;
            v18 = i;
        else
            v18 = i;
        end;
    end;

    for i = v16, #p15.Bindings do
        p15.Bindings[i] = nil;
        local _ = i;
    end;

    table.sort(p15.Bindings, function(p19, p20) -- Line: 129
        if p19.Priority == p20.Priority then
            return p19.Sequence < p20.Sequence;
        end;

        return p19.Priority < p20.Priority;
    end);
    table.clear(p15.StepBindings);
    table.clear(p15.RenderPriorityBindings);

    for _, v in ipairs(p15.Bindings) do
        if v.UsesRenderPriority then
            local v21 = p15.RenderPriorityBindings[v.Priority];

            if not v21 then
                v21 = {};
                p15.RenderPriorityBindings[v.Priority] = v21;
            end;

            table.insert(v21, v);
        else
            table.insert(p15.StepBindings, v);
        end;
    end;

    p15.NeedsCompact = false;
    p15.NeedsSort = false;
    syncSchedulerConnections(p15);
end;

local u22 = 0;

local function invokeBinding(p23, ...) -- Line: 163
    -- upvalues: u22 (ref), getTraceback (copy)
    debug.profilebegin(p23.ProfileLabel);
    local v24, v25 = xpcall(p23.Callback, getTraceback, ...);

    if u22 == u22 then
        debug.profileend();
    end;

    if not v24 then
        warn((`[RunServiceController] {p23.EventName} binding "{p23.Name}" failed:\n{v25}`));
    end;
end;

local function stepScheduler(p26: table, p27: number?, ...) -- Line: 175
    -- upvalues: u22 (ref), Profiler (copy), rebuildScheduler (copy), u2 (copy), invokeBinding (copy)
    u22 = u22 + 1;
    Profiler.mark(p26.ProfileLabel);

    if p26.NeedsCompact or p26.NeedsSort then
        rebuildScheduler(p26);
    end;

    p26.Stepping = true;
    local v28;

    if p27 == nil then
        v28 = p26.StepBindings;
    else
        v28 = p26.RenderPriorityBindings[p27] or u2;
    end;

    for i = 1, #v28 do
        local v29 = v28[i];
        local v30;

        if v29 and v29.Connected then
            invokeBinding(v29, ...);
            v30 = i;
        else
            v30 = i;
        end;
    end;

    p26.Stepping = false;

    if p26.NeedsCompact or p26.NeedsSort then
        rebuildScheduler(p26);
    end;
end;

local function ensureSchedulerConnection(u31: table, u32: number, p33: boolean) -- Line: 203
    -- upvalues: RunService (copy), stepScheduler (copy)
    if not p33 then
        if not (u31.Connection and u31.Connection.Connected) then
            u31.Connection = RunService[u31.EventName]:Connect(function(...) -- Line: 216
                -- upvalues: stepScheduler (ref), u31 (copy)
                stepScheduler(u31, nil, ...);
            end);
        end;

        return;
    end;

    if u31.RenderStepNames[u32] then
        return;
    end;

    local v34 = `RunServiceController.RenderStepped.{u32}`;
    u31.RenderStepNames[u32] = v34;
    RunService:BindToRenderStep(v34, u32, function(p35: number) -- Line: 211
        -- upvalues: stepScheduler (ref), u31 (copy), u32 (copy)
        stepScheduler(u31, u32, p35);
    end);
end;

local function disconnectBinding(p36: table, p37: any) -- Line: 222
    -- upvalues: rebuildScheduler (copy)
    if not p37.Connected then
        return;
    end;

    p37.Connected = false;

    if p36.BindingsByName[p37.Name] == p37 then
        p36.BindingsByName[p37.Name] = nil;
    end;

    p36.NeedsCompact = true;

    if not p36.Stepping then
        rebuildScheduler(p36);
    end;
end;

local function createBinding(p38: string, p39: string, p40: number, p41: function, p42: boolean) -- Line: 238
    -- upvalues: u6 (copy), rebuildScheduler (copy), u3 (ref), getBindingProfileLabel (copy), ensureSchedulerConnection (copy)
    local v43;

    if type(p39) == "string" then
        v43 = p39 ~= "";
    else
        v43 = false;
    end;

    assert(v43, "RunServiceController binding name must be a non-empty string");
    local v44 = type(p40) == "number";
    assert(v44, "RunServiceController binding priority must be a number");
    local v45 = type(p41) == "function";
    assert(v45, "RunServiceController callback must be a function");
    local u46 = u6[p38];
    local v47 = u46.BindingsByName[p39];

    if v47 and v47.Connected then
        v47.Connected = false;

        if u46.BindingsByName[v47.Name] == v47 then
            u46.BindingsByName[v47.Name] = nil;
        end;

        u46.NeedsCompact = true;

        if not u46.Stepping then
            rebuildScheduler(u46);
        end;
    end;

    u3 = u3 + 1;
    local u48 = {
        Connected = true,
        Name = p39,
        EventName = p38,
        Priority = p40,
        Callback = p41,
        ProfileLabel = getBindingProfileLabel(p38, p39),
        Sequence = u3,
        UsesRenderPriority = p42
    };

    function u48.Disconnect(p49) -- Line: 268
        -- upvalues: u46 (copy), u48 (copy), rebuildScheduler (ref)
        local v50 = u46;
        local v51 = u48;

        if not v51.Connected then
            return;
        end;

        v51.Connected = false;

        if v50.BindingsByName[v51.Name] == v51 then
            v50.BindingsByName[v51.Name] = nil;
        end;

        v50.NeedsCompact = true;

        if not v50.Stepping then
            rebuildScheduler(v50);
        end;
    end;

    u48.Destroy = u48.Disconnect;
    table.insert(u46.Bindings, u48);
    u46.BindingsByName[p39] = u48;
    u46.NeedsSort = true;
    ensureSchedulerConnection(u46, p40, p42);

    return u48;
end;

function u1.CreateBindingName(p52: string) -- Line: 285
    -- upvalues: u4 (ref)
    local v53;

    if type(p52) == "string" then
        v53 = p52 ~= "";
    else
        v53 = false;
    end;

    assert(v53, "RunServiceController binding prefix must be a non-empty string");
    u4 = u4 + 1;

    return `{p52}.{u4}`;
end;

function u1.BindToHeartbeat(p54: string, p55: function, p56: number?) -- Line: 292
    -- upvalues: createBinding (copy)
    return createBinding("Heartbeat", p54, p56 or 0, p55, false);
end;

function u1.BindToRenderStep(p57: string, p58: any, p59: function?) -- Line: 296
    -- upvalues: createBinding (copy)
    if p59 == nil then
        return createBinding("RenderStepped", p57, 0, p58, false);
    end;

    return createBinding("RenderStepped", p57, p58, p59, true);
end;

function u1.BindToRenderSteppedEvent(p60: string, p61: function, p62: number?) -- Line: 307
    -- upvalues: createBinding (copy)
    return createBinding("RenderStepped", p60, p62 or 0, p61, false);
end;

function u1.BindToStepped(p63: string, p64: function, p65: number?) -- Line: 315
    -- upvalues: createBinding (copy)
    return createBinding("Stepped", p63, p65 or 0, p64, false);
end;

function u1.BindToPostSimulation(p66: string, p67: function, p68: number?) -- Line: 323
    -- upvalues: createBinding (copy)
    return createBinding("PostSimulation", p66, p68 or 0, p67, false);
end;

function u1.Unbind(p69: string, p70: string) -- Line: 331
    -- upvalues: u6 (copy), rebuildScheduler (copy)
    local v71 = u6[p69].BindingsByName[p70];

    if v71 then
        local v72 = u6[p69];

        if not v71.Connected then
            return;
        end;

        v71.Connected = false;

        if v72.BindingsByName[v71.Name] == v71 then
            v72.BindingsByName[v71.Name] = nil;
        end;

        v72.NeedsCompact = true;

        if not v72.Stepping then
            rebuildScheduler(v72);
        end;
    end;
end;

function u1.UnbindFromRenderStep(p73: string) -- Line: 338
    -- upvalues: u1 (copy)
    u1.Unbind("RenderStepped", p73);
end;

return u1;