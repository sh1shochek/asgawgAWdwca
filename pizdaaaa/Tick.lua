-- ReplicatedStorage.Shared.Tick
-- Script path: ReplicatedStorage.Shared.Tick
-- Decompile time: 5.74 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local u2 = 0;
local u3 = 0;
local u4 = 0;
local u5 = {};
local u6 = {};
local u7 = nil;
local u8 = nil;
local u9 = {};

local function RefreshConfig() -- Line: 31
    -- upvalues: u9 (copy), u7 (ref)
    u9.TickRate = u7.Get("Game", "TickRate");
    local v10 = u7.Get("Game", "MaxTickRate") or 128;
    u9.MaxTickRate = math.max(v10, u9.TickRate);
    u9.TimeScale = u7.Get("Game", "TimeScale");
    local v11 = u7.Get("Character", "MaxCommandsPerFrame");
    local v12 = u7.Get("Network", "CommandBackup") or 0;
    u9.MaxTicksPerFrame = v11 + math.max(v12, 0);
end;

local function Step(p13) -- Line: 44
    -- upvalues: u9 (copy), u3 (ref), u4 (ref), u2 (ref), u6 (copy), u5 (copy), u8 (ref), u1 (copy)
    local v14 = 1 / u9.TickRate;
    local v15 = p13 * u9.TimeScale;
    u3 = u3 + v15;
    local MaxTicksPerFrame = u9.MaxTicksPerFrame;
    local v16 = 0;

    while v14 <= u3 do
        if MaxTicksPerFrame <= v16 then
            u3 = math.min(u3, v14 * MaxTicksPerFrame);
            break;
        end;

        u3 = u3 - v14;
        local math_floor_ret = math.floor(u3 / v14);
        local math_max_ret = math.max(math_floor_ret, 0);
        u4 = math.min(math_max_ret, MaxTicksPerFrame - v16 - 1);
        u2 = u2 + 1;

        if u6[u2] then
            for _, v in u6[u2] do
                task.spawn(v);
            end;

            u6[u2] = nil;
        end;

        local v17 = u5[u2];

        if v17 then
            for _, v in v17 do
                u8:Spawn(v.Function, table.unpack(v.Parameters));
            end;

            u5[u2] = nil;
        end;

        u1.OnTick.Fire(v14);
        v16 = v16 + 1;
    end;

    u4 = 0;
    u1.PostTick.Fire(v15, v14);
end;

local function NewDispatcher(u18: string) -- Line: 102
    local u19 = {};
    local u20 = {};
    local u21 = false;

    local function Rebuild() -- Line: 109
        -- upvalues: u19 (copy), u20 (copy), u21 (ref)
        local v22 = {};

        for i in u19 do
            table.insert(v22, i);
        end;

        table.sort(v22);
        table.clear(u20);

        for _, v in v22 do
            local v23 = v;
            local v24 = {};

            for i in u19[v] do
                table.insert(v24, i);
            end;

            table.sort(v24);

            for _, v2 in v24 do
                table.insert(u20, u19[v23][v2]);
            end;
        end;

        u21 = false;
    end;

    return {
        Connect = function(u25: table) -- Line: 138, Name: Connect
            -- upvalues: u19 (copy), u18 (copy), u21 (ref)
            local u26 = u19[u25.Priority];

            if not u26 then
                u26 = {};
                u19[u25.Priority] = u26;
            end;

            local SubPriority = u25.SubPriority;

            if not SubPriority then
                local v27 = 0;

                for i in u26 do
                    v27 = math.max(v27, i);
                end;

                SubPriority = math.floor(v27) + 1;
            end;

            if u26[SubPriority] then
                warn(`[Tick] {u18} slot {u25.Priority}/{SubPriority} is already taken; the task already there will stop running`, debug.traceback());
            end;

            u26[SubPriority] = u25;
            u21 = true;

            function u25.Disconnect() -- Line: 182
                -- upvalues: u26 (ref), SubPriority (ref), u25 (copy), u21 (ref)
                if u26[SubPriority] == u25 then
                    u26[SubPriority] = nil;
                    u21 = true;
                end;
            end;

            return u25;
        end,

        Fire = function(...) -- Line: 197, Name: Fire
            -- upvalues: u21 (ref), Rebuild (copy), u20 (copy)
            if u21 then
                Rebuild();
            end;

            for _, v in u20 do
                v.Function(...);
            end;
        end
    };
end;

function u1.Delay(p28: number, p29: any, ...) -- Line: 213
    -- upvalues: u2 (ref), u5 (copy)
    local math_max_ret = math.max(p28, 1);
    local v30 = u2 + math.ceil(math_max_ret);
    local v31 = u5[v30];

    if not v31 then
        v31 = {};
        u5[v30] = v31;
    end;

    table.insert(v31, {
        Function = p29,
        Parameters = { ... }
    });
end;

function u1.Wait(p32: number) -- Line: 230
    -- upvalues: u2 (ref), u6 (copy)
    local v33 = u2 + math.max(1, p32);

    if not u6[v33] then
        u6[v33] = {};
    end;

    table.insert(u6[v33], coroutine.running());

    return coroutine.yield();
end;

function u1.ToTime(p34: number) -- Line: 245
    -- upvalues: u9 (copy)
    return p34 / u9.TickRate;
end;

function u1.TimeToTick(p35: number) -- Line: 249
    -- upvalues: u9 (copy)
    return p35 * u9.TickRate;
end;

function u1.GetTick() -- Line: 253
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.GetTime() -- Line: 271
    -- upvalues: u2 (ref), u9 (copy)
    return u2 / u9.TickRate;
end;

function u1.HistorySize(p36: number) -- Line: 289
    -- upvalues: u9 (copy)
    local math_ceil_ret = math.ceil(p36 * u9.MaxTickRate);

    return math.max(math_ceil_ret, 8);
end;

function u1.GetAccumulatedTime() -- Line: 293
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.GetTicksRemainingThisFrame() -- Line: 297
    -- upvalues: u4 (ref)
    return u4;
end;

function u1.Init(p37) -- Line: 303
    -- upvalues: u7 (ref), u8 (ref), RefreshConfig (copy), u1 (copy), NewDispatcher (copy)
    u7 = p37:GetModule("GameConfiguration");
    u8 = p37:GetModule("Threads");
    RefreshConfig();
    u7.Updated:Connect(RefreshConfig);
    u1.OnTick = NewDispatcher("OnTick");
    u1.PostTick = NewDispatcher("PostTick");
end;

function u1.EventStart(p38) -- Line: 316
    -- upvalues: RunService (copy), Step (copy)
    if RunService:IsServer() then
        RunService.PostSimulation:Connect(Step);

        return;
    end;

    RunService:BindToRenderStep("Tick", Enum.RenderPriority.First.Value, Step);
end;

return u1;