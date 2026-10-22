-- ReplicatedStorage.ClientModules.ClientModule
-- Script path: ReplicatedStorage.ClientModules.ClientModule
-- Decompile time: 4.87 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local UserId = LocalPlayer.UserId;
local u2 = 0;
local u3 = {};
local u4 = nil;
local u5 = {
    LostCommandPercent = 0,
    FakeCommandCount = 0,
    Jitter = 0,
    InputQueueDelayMs = 0,
    ShotRewindMs = 0,
    ShotRenderTime = 0,
    ShotPingMs = 0,
    ShotJitterMs = 0,
    ShotHit = false,
    ShotTargetIdentifier = 0,
    ShotHitbox = 0,
    ShotAppliedDamage = 0,
    ShotHealthBefore = 0,
    ShotHealthAfter = 0,
    ShotRejected = false,
    ShotRejectReason = 0,
    ShotLethal = false
};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = {};

local function RefreshConfig() -- Line: 50
    -- upvalues: u13 (copy), u8 (ref)
    u13.PingCheckTime = u8.Get("Network", "PingCheckTime");
end;

local function CleanupPlayer(p14: userdata) -- Line: 54
    for _, child in ipairs(p14:GetChildren()) do
        child:Destroy();
    end;
end;

local function StopPing() -- Line: 60
    -- upvalues: u4 (ref)
    if u4 then
        task.cancel(u4);
        u4 = nil;
    end;
end;

local function StartPing() -- Line: 67
    -- upvalues: u4 (ref), u2 (ref), u6 (ref), u9 (ref), u13 (copy)
    if u4 then
        return;
    end;

    u4 = task.spawn(function() -- Line: 72
        -- upvalues: u2 (ref), u6 (ref), u9 (ref), u13 (ref)
        while true do
            local v15 = u2;

            if v15 > 0 then
                u6.ClientPing.Fire(v15);
            end;

            local v16 = u9 and (u9.ToTime and u9.ToTime(u13.PingCheckTime)) or 1;
            task.wait((math.max(v16, 0.5)));
        end;
    end);
end;

function v1.SetCurrentServerFrame(p17: number) -- Line: 88
    -- upvalues: u2 (ref)
    u2 = p17;
end;

function v1.GetServerFrame() -- Line: 92
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.GetPingInfo() -- Line: 96
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.GetLocalPing() -- Line: 100
    -- upvalues: LocalPlayer (copy), u3 (ref), UserId (copy)
    local Attribute = LocalPlayer:GetAttribute("PingId");
    local v18 = Attribute and u3[Attribute] or u3[UserId];

    return (not v18 or v18 <= 0) and (v18 or 0) or v18;
end;

function v1.GetNetworkDebugStats() -- Line: 110
    -- upvalues: u5 (ref)
    return u5;
end;

function v1.SetNetworkDebugEnabled(p19: boolean) -- Line: 114
    -- upvalues: u6 (ref)
    u6.NetworkDebugEnabled.Fire(p19);
end;

function v1.Init(p20) -- Line: 120
    -- upvalues: u10 (ref), u6 (ref), u12 (ref), u8 (ref), u9 (ref), u13 (copy), RefreshConfig (copy), u2 (ref), u3 (ref), u11 (ref), u5 (ref)
    u10 = p20:GetModule("Gui");
    u6 = p20:GetModule("Network");
    u12 = p20:GetModule("CharacterController");
    u8 = p20:GetModule("GameConfiguration");
    u9 = p20:GetModule("Tick");
    u13.PingCheckTime = u8.Get("Network", "PingCheckTime");
    u8.Updated:Connect(RefreshConfig);
    u6.ServerTick.On(function(p21) -- Line: 130
        -- upvalues: u2 (ref)
        u2 = p21;
    end);
    u6.ServerPing.On(function(p22) -- Line: 134
        -- upvalues: u3 (ref), u11 (ref)
        u3 = p22;

        if u11 and (u3 and next(u3)) then
            u11.UpdatePing(u3);
        end;
    end);
    u6.NetworkDebugStats.On(function(p23) -- Line: 143
        -- upvalues: u5 (ref)
        u5 = p23;
    end);
end;

function v1.Start(p24) -- Line: 149
    -- upvalues: u11 (ref), u10 (ref), u12 (ref), u7 (ref), u4 (ref), u2 (ref), u6 (ref), u9 (ref), u13 (copy)
    u11 = u10.GetComponent("Score");
    u12.OnCharacterSpawn:Connect(function(p25) -- Line: 152
        -- upvalues: u7 (ref), u4 (ref)
        u7 = p25;

        if u4 then
            task.cancel(u4);
            u4 = nil;
        end;
    end);
    u12.OnCharacterDestroy:Connect(function() -- Line: 158
        -- upvalues: u4 (ref), u2 (ref), u6 (ref), u9 (ref), u13 (ref)
        if u4 then
            return;
        end;

        u4 = task.spawn(function() -- Line: 72
            -- upvalues: u2 (ref), u6 (ref), u9 (ref), u13 (ref)
            while true do
                local v26 = u2;

                if v26 > 0 then
                    u6.ClientPing.Fire(v26);
                end;

                local v27 = u9 and (u9.ToTime and u9.ToTime(u13.PingCheckTime)) or 1;
                task.wait((math.max(v27, 0.5)));
            end;
        end);
    end);
end;

function v1.Start2(p28) -- Line: 163
    -- upvalues: u4 (ref), u2 (ref), u6 (ref), u9 (ref), u13 (copy), Players (copy), LocalPlayer (copy)
    if not u4 then
        u4 = task.spawn(function() -- Line: 72
            -- upvalues: u2 (ref), u6 (ref), u9 (ref), u13 (ref)
            while true do
                local v29 = u2;

                if v29 > 0 then
                    u6.ClientPing.Fire(v29);
                end;

                local v30 = u9 and (u9.ToTime and u9.ToTime(u13.PingCheckTime)) or 1;
                task.wait((math.max(v30, 0.5)));
            end;
        end);
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            for _, child in ipairs(v:GetChildren()) do
                child:Destroy();
            end;
        end;
    end;

    Players.PlayerAdded:Connect(function(p31) -- Line: 174
        for _, child in ipairs(p31:GetChildren()) do
            child:Destroy();
        end;
    end);
end;

return v1;