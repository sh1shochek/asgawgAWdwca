-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = {};

local function WaitForTimersLoaded(p3: number) -- Line: 16
    -- upvalues: ReplicatedStorage (copy)
    local v4 = 0;

    while not ReplicatedStorage:GetAttribute("TimersLoaded") do
        v4 = v4 + task.wait();

        if p3 <= v4 then
            break;
        end;
    end;
end;

local function FireTimerListeners(p5: string) -- Line: 28
    -- upvalues: u2 (copy), u1 (copy)
    local v6 = u2[p5];

    if not v6 or #v6 == 0 then
        return;
    end;

    local Timer = u1.GetTimer(p5);

    for _, v in v6 do
        v(Timer);
    end;
end;

function u1.GetTimer(p7: string) -- Line: 45
    -- upvalues: ReplicatedStorage (copy)
    local Attribute = ReplicatedStorage:GetAttribute((`timers_source/{p7}`));
    local v8 = typeof(Attribute) == "number";
    assert(v8, "Timer attribute is not a number.");

    return Attribute;
end;

function u1.ListenToTimerChanged(p9: string, p10: function) -- Line: 53
    -- upvalues: u1 (copy), u2 (copy)
    local Timer = u1.GetTimer(p9);
    u2[p9] = u2[p9] or {};
    table.insert(u2[p9], p10);
    p10(Timer);
end;

function u1.Initialize() -- Line: 64
    -- upvalues: WaitForTimersLoaded (copy), ReplicatedStorage (copy), u2 (copy), u1 (copy)
    WaitForTimersLoaded(10);

    for i in ReplicatedStorage:GetAttributes() do
        if string.find(string.lower(i), "timers_source") then
            local string_gsub_ret = string.gsub(i, "timers_source/", "");
            local v11 = u2[string_gsub_ret];
            local v12;

            if v11 and #v11 ~= 0 then
                local Timer = u1.GetTimer(string_gsub_ret);
                v12 = i;

                for _, v in v11 do
                    v(Timer);
                end;
            else
                v12 = i;
            end;

            ReplicatedStorage:GetAttributeChangedSignal(v12):Connect(function() -- Line: 71
                -- upvalues: string_gsub_ret (copy), u2 (ref), u1 (ref)
                local v13 = string_gsub_ret;
                local v14 = u2[v13];

                if v14 then
                    if #v14 == 0 then
                        return;
                    end;

                    local Timer = u1.GetTimer(v13);

                    for _, v in v14 do
                        v(Timer);
                    end;
                end;
            end);
        end;
    end;
end;

return u1;