-- ReplicatedStorage.Shared.Managers.AnimationManager.Animator
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Animator
-- Decompile time: 6.20 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local u2 = nil;

function u1.new(p3: any, p4: boolean?, p5: any) -- Line: 11
    -- upvalues: u1 (copy)
    local v6 = setmetatable({}, u1);
    v6.Asset = p3;
    v6.Track = {
        Alpha = 0,
        StartFadeTime = 0,
        StopFadeTime = 0.05,
        Weight = 1,
        Priority = 1
    };
    v6.Playing = false;
    v6.ActiveAnimators = p5;
    v6.Looped = p4 or false;
    v6.Direction = 1;
    v6.Speed = 1;
    local events = p3.events;
    local v7 = events and (#events or 0) or 0;
    v6.Events = {};
    v6.EventNames = table.create(v7);
    v6.EventAlphas = table.create(v7);
    v6.EventValues = table.create(v7);
    v6.EventCallbackCount = 0;
    local length = p3.length;

    if events then
        for i, v in events do
            local name = v.name;
            v6.Events[name] = false;
            v6.EventNames[i] = name;
            v6.EventAlphas[i] = length > 0 and (v.time / length or 0) or 0;
            v6.EventValues[i] = v.value or name;
        end;
    end;

    return v6;
end;

function u1.SetPlaying(p8: table, p9: boolean) -- Line: 64
    p8.Playing = p9;
    p8.ActiveAnimators[p8] = p9 and true or nil;
end;

function u1.Play(p10) -- Line: 69
    p10:SetPlaying(true);
end;

function u1.Stop(p11) -- Line: 73
    p11:SetPlaying(false);
    p11.Track.Alpha = 0;
end;

function u1.Reverse(p12) -- Line: 78
    p12.Direction = -p12.Direction;
end;

function u1.OnEvent(p13: table, p14: string, p15: function) -- Line: 82
    local v16 = p13.Events[p14];

    if p15 and not v16 then
        p13.EventCallbackCount = p13.EventCallbackCount + 1;
    elseif v16 and not p15 then
        p13.EventCallbackCount = p13.EventCallbackCount - 1;
    end;

    p13.Events[p14] = p15;
end;

function u1.WriteState(p17) -- Line: 94
    return p17.Track.Alpha;
end;

function u1.ReadState(p18: table, p19: number) -- Line: 98
    p18.Track.Alpha = p19;
end;

function u1.Step(p20: table, p21: number) -- Line: 102
    if not p20.Playing then
        return;
    end;

    local length = p20.Asset.length;

    if length <= 0 then
        return;
    end;

    local Alpha = p20.Track.Alpha;
    local v22 = Alpha + p21 / length * p20.Speed * p20.Direction;
    local v23;

    if p20.Looped then
        v23 = v22 % 1;
    elseif v22 >= 1 then
        p20:SetPlaying(false);
        v23 = 1;
    elseif v22 <= 0 then
        p20:SetPlaying(false);
        v23 = 0;
    else
        v23 = v22;
    end;

    if not p20.Looped then
        v22 = v23;
    end;

    p20.Track.Alpha = v23;

    if p20.EventCallbackCount == 0 then
        return;
    end;

    for i, v in p20.EventNames do
        local v24 = p20.Events[v];

        if v24 then
            local v25 = p20.EventAlphas[i];
            local v26 = p20.EventValues[i];

            for i2 = math.floor(Alpha - v25) + 1, math.floor(v22 - v25) do
                v24(v26);
                local _ = i2;
            end;
        end;
    end;
end;

function u1.Destroy(p27) -- Line: 167
    p27:SetPlaying(false);
    table.clear(p27);
end;

function u1.Init(p28) -- Line: 175
    -- upvalues: u2 (ref)
    u2 = require(script.Parent.Crunchyroll);
end;

return u1;