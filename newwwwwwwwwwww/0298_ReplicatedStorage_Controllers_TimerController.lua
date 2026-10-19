-- TimerController (ModuleScript)
-- full path: ReplicatedStorage.Controllers.TimerController

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = {};
local u3 = {};

local function WaitForTimersLoaded(p4: number) -- Line: 18
    -- upvalues: ReplicatedStorage (copy)
    local v5 = 0;

    while not ReplicatedStorage:GetAttribute("TimersLoaded") do
        v5 = v5 + task.wait();

        if p4 <= v5 then
            break;
        end;
    end;
end;

local function FireTimerListeners(p6: string) -- Line: 30
    -- upvalues: u2 (copy), u1 (copy)
    local v7 = u2[p6];

    if not v7 or #v7 == 0 then
        return;
    end;

    local Timer = u1.GetTimer(p6);

    for _, v in v7 do
        v(Timer);
    end;
end;

function u1.GetTimer(p8: string) -- Line: 47
    -- upvalues: ReplicatedStorage (copy)
    local Attribute = ReplicatedStorage:GetAttribute((`timers_source/{p8}`));
    local v9 = typeof(Attribute) == "number";
    assert(v9, "Timer attribute is not a number.");

    return Attribute;
end;

function u1.GetSecondsRemaining(p10: string) -- Line: 60
    -- upvalues: ReplicatedStorage (copy), u3 (copy)
    local Attribute = ReplicatedStorage:GetAttribute((`timers_source/{p10}`));

    if typeof(Attribute) ~= "number" then
        return nil;
    end;

    local ServerTimeNow = workspace:GetServerTimeNow();

    if Attribute > 1000000000000 then
        return math.max(0, Attribute / 1000 - ServerTimeNow);
    end;

    if Attribute > 1000000000 then
        return math.max(0, Attribute - ServerTimeNow);
    end;

    local v11 = u3[p10];

    if v11 and v11.Tick == Attribute then
        return math.max(0, Attribute - (ServerTimeNow - v11.At));
    end;

    u3[p10] = {
        Tick = Attribute,
        At = ServerTimeNow
    };

    return math.max(0, Attribute);
end;

function u1.ObserveRunning(u12: string, u13: function) -- Line: 87
    -- upvalues: u1 (copy), ReplicatedStorage (copy)
    local u14 = nil;
    local u15 = nil;
    local u16 = nil;

    local function onExpiry() -- Line: 92
        -- upvalues: u15 (ref), u16 (ref)
        u15 = nil;
        u16();
    end;

    u16 = function() -- Line: 97, Name: update
        -- upvalues: u15 (ref), u1 (ref), u12 (copy), onExpiry (copy), u14 (ref), u13 (copy)
        if u15 then
            task.cancel(u15);
            u15 = nil;
        end;

        local SecondsRemaining = u1.GetSecondsRemaining(u12);
        local v17;

        if SecondsRemaining == nil then
            v17 = false;
        else
            v17 = SecondsRemaining > 0;
        end;

        if v17 then
            u15 = task.delay(SecondsRemaining, onExpiry);
        end;

        if v17 ~= u14 then
            u14 = v17;
            u13(v17);
        end;
    end;

    ReplicatedStorage:GetAttributeChangedSignal((`timers_source/{u12}`)):Connect(u16);
    u16();
end;

function u1.ListenToTimerChanged(p18: string, p19: function) -- Line: 121
    -- upvalues: u1 (copy), u2 (copy)
    local Timer = u1.GetTimer(p18);
    u2[p18] = u2[p18] or {};
    table.insert(u2[p18], p19);
    p19(Timer);
end;

function u1.Initialize() -- Line: 132
    -- upvalues: WaitForTimersLoaded (copy), ReplicatedStorage (copy), u2 (copy), u1 (copy)
    WaitForTimersLoaded(10);

    for i in ReplicatedStorage:GetAttributes() do
        if string.find(string.lower(i), "timers_source") then
            local string_gsub_ret = string.gsub(i, "timers_source/", "");
            local v20 = u2[string_gsub_ret];
            local v21;

            if v20 and #v20 ~= 0 then
                local Timer = u1.GetTimer(string_gsub_ret);
                v21 = i;

                for _, v in v20 do
                    v(Timer);
                end;
            else
                v21 = i;
            end;

            ReplicatedStorage:GetAttributeChangedSignal(v21):Connect(function() -- Line: 139
                -- upvalues: string_gsub_ret (copy), u2 (ref), u1 (ref)
                local v22 = string_gsub_ret;
                local v23 = u2[v22];

                if v23 then
                    if #v23 == 0 then
                        return;
                    end;

                    local Timer = u1.GetTimer(v22);

                    for _, v in v23 do
                        v(Timer);
                    end;
                end;
            end);
        end;
    end;
end;

return u1;