-- ReplicatedStorage.GameClient.Gui.Misc.Stats
-- Script path: ReplicatedStorage.GameClient.Gui.Misc.Stats
-- Decompile time: 12.80 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Stats = game:GetService("Stats");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local Roles = require(ReplicatedStorage.Shared.Roles);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = 0;

local function Percent(p12, p13) -- Line: 27
    return p13 > 0 and p12 / p13 * 100 or 0;
end;

local function StopDebugMenu() -- Line: 31
    -- upvalues: u10 (ref), u9 (ref)
    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    if u9 then
        u9:destroy();
        u9 = nil;
    end;
end;

local function StartDebugMenu() -- Line: 43
    -- upvalues: u9 (ref), u3 (ref), u11 (ref), Stats (copy), GameStats (copy), u2 (ref), u7 (ref), u8 (ref), u10 (ref), RunService (copy)
    if u9 then
        return;
    end;

    local v14 = u3.create();
    u9 = v14;
    v14:mount(nil, {
        studioOnly = false,
        maxItems = 12
    });
    v14:watch("System", {
        FPS = function() -- Line: 57
            -- upvalues: u11 (ref)
            return u11;
        end,

        Memory = function() -- Line: 60
            -- upvalues: Stats (ref)
            return string.format("%.2f MB", Stats:GetTotalMemoryUsageMb());
        end,

        ["Server region"] = function() -- Line: 63
            -- upvalues: GameStats (ref)
            return GameStats:GetAttribute("ServerRegion") or "unknown";
        end
    });
    v14:watch("Network Stats", {
        Incoming = function() -- Line: 69
            -- upvalues: Stats (ref)
            return string.format("%.2f", Stats.DataReceiveKbps);
        end,

        Out = function() -- Line: 73
            -- upvalues: Stats (ref)
            return string.format("%.2f", Stats.DataSendKbps);
        end,

        Ping = function() -- Line: 77
            -- upvalues: u2 (ref)
            return string.format("%.2f", u2.GetLocalPing());
        end,

        Jitter = function() -- Line: 81
            -- upvalues: u2 (ref)
            return string.format("%.2f ms", u2.GetNetworkDebugStats().Jitter);
        end
    });
    v14:watch("Network Commands", {
        ["Lost commands"] = function() -- Line: 87
            -- upvalues: u2 (ref)
            return string.format("%.2f%%", u2.GetNetworkDebugStats().LostCommandPercent);
        end,

        ["Fake commands"] = function() -- Line: 90
            -- upvalues: u2 (ref)
            return u2.GetNetworkDebugStats().FakeCommandCount;
        end,

        ["Server input delay"] = function() -- Line: 93
            -- upvalues: u2 (ref)
            return string.format("%.2f ms", u2.GetNetworkDebugStats().InputQueueDelayMs);
        end,

        CommandIdle = function() -- Line: 96
            -- upvalues: u7 (ref)
            local v15;

            if u7 then
                local TotalCommandCount = u7.TotalCommandCount;
                v15 = TotalCommandCount > 0 and u7.IdleCommandCount / TotalCommandCount * 100 or 0 or 0;
            else
                v15 = 0;
            end;

            return string.format("%.2f%%", v15);
        end
    });
    v14:watch("Last Server Shot", {
        Rewind = function() -- Line: 102
            -- upvalues: u2 (ref)
            return string.format("%.2f ms", u2.GetNetworkDebugStats().ShotRewindMs);
        end,

        ["Render time"] = function() -- Line: 105
            -- upvalues: u2 (ref)
            return string.format("%.3f", u2.GetNetworkDebugStats().ShotRenderTime);
        end,

        Ping = function() -- Line: 108
            -- upvalues: u2 (ref)
            return string.format("%.2f ms", u2.GetNetworkDebugStats().ShotPingMs);
        end,

        Jitter = function() -- Line: 111
            -- upvalues: u2 (ref)
            return string.format("%.2f ms", u2.GetNetworkDebugStats().ShotJitterMs);
        end,

        Hit = function() -- Line: 114
            -- upvalues: u2 (ref)
            return u2.GetNetworkDebugStats().ShotHit and "yes" or "no";
        end,

        Target = function() -- Line: 117
            -- upvalues: u2 (ref)
            return u2.GetNetworkDebugStats().ShotTargetIdentifier;
        end,

        Hitbox = function() -- Line: 120
            -- upvalues: u2 (ref)
            return ({ "none", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg" })[u2.GetNetworkDebugStats().ShotHitbox + 1] or "unknown";
        end,

        Damage = function() -- Line: 123
            -- upvalues: u2 (ref)
            return string.format("%.0f", u2.GetNetworkDebugStats().ShotAppliedDamage);
        end,

        Health = function() -- Line: 126
            -- upvalues: u2 (ref)
            local NetworkDebugStats = u2.GetNetworkDebugStats();

            return string.format("%.0f -> %.0f", NetworkDebugStats.ShotHealthBefore, NetworkDebugStats.ShotHealthAfter);
        end,

        Rejected = function() -- Line: 130
            -- upvalues: u2 (ref)
            local NetworkDebugStats = u2.GetNetworkDebugStats();
            local v16;

            if NetworkDebugStats.ShotRejected then
                v16 = ({ "spawn protection", "attacker dead", "victim dead", "teammate", "no armor state", "zero after armor", "health unchanged", "no character", "no HitPoints" })[NetworkDebugStats.ShotRejectReason];

                if not v16 then
                    return "yes";
                end;
            else
                v16 = "no";
            end;

            return v16;
        end,

        Lethal = function() -- Line: 134
            -- upvalues: u2 (ref)
            return u2.GetNetworkDebugStats().ShotLethal and "yes" or "no";
        end
    });
    v14:watch("Character", {
        Stamina = function() -- Line: 140
            -- upvalues: u8 (ref)
            return u8 and math.floor(u8.Stamina) or 0;
        end,

        Position = function() -- Line: 143
            -- upvalues: u8 (ref)
            local v17 = u8 and u8.Position;

            return v17 and string.format("%.2f, %.2f, %.2f", v17.X, v17.Y, v17.Z) or "0, 0, 0";
        end,

        Velocity = function() -- Line: 147
            -- upvalues: u8 (ref)
            local v18 = u8 and u8.Velocity;

            return v18 and string.format("%.2f, %.2f, %.2f", v18.X, v18.Y, v18.Z) or "0, 0, 0";
        end,

        Speed = function() -- Line: 151
            -- upvalues: u8 (ref)
            local v19;

            if u8 then
                local vector_magnitude_ret = vector.magnitude(u8.Velocity * Vector3.new(1, 0, 1));
                v19 = math.floor(vector_magnitude_ret) or 0;
            else
                v19 = 0;
            end;

            return v19;
        end,

        ["Reconciliation correction"] = function() -- Line: 154
            -- upvalues: u7 (ref)
            return string.format("%.3f studs", u7 and u7.ReconciliationCorrection or 0);
        end
    });
    v14:watch("Angles", {
        Yaw = function() -- Line: 160
            -- upvalues: u8 (ref)
            return string.format("%.2f", u8 and u8.Yaw or 0);
        end,

        Pitch = function() -- Line: 163
            -- upvalues: u8 (ref)
            return string.format("%.2f", u8 and u8.Pitch or 0);
        end
    });
    local u20 = 0;
    local u21 = {};
    u10 = RunService.PreRender:Connect(function(p22) -- Line: 171
        -- upvalues: u20 (ref), u21 (copy), u11 (ref)
        u20 = u20 + p22;

        if u20 > 0.01 then
            local math_ceil_ret = math.ceil(1 / p22);
            table.insert(u21, math_ceil_ret);

            if #u21 > 40 then
                local v23 = 0;

                for _, v in u21 do
                    v23 = v23 + v;
                end;

                u11 = math.ceil(v23 / #u21);
                table.clear(u21);
            end;

            u20 = 0;
        end;
    end);
end;

local function SetDebugMode(p24) -- Line: 191
    -- upvalues: Roles (copy), LocalPlayer (copy), u2 (ref), StartDebugMenu (copy), u10 (ref), u9 (ref)
    if p24 and not Roles.HasRole(LocalPlayer.UserId, "Admin") then
        p24 = false;
    end;

    u2.SetNetworkDebugEnabled(p24);

    if p24 then
        StartDebugMenu();

        return;
    end;

    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    if u9 then
        u9:destroy();
        u9 = nil;
    end;
end;

function v1.Init(p25) -- Line: 205
    -- upvalues: u3 (ref), u2 (ref), u4 (ref), u5 (ref)
    u3 = p25:GetModule("NetStats");
    u2 = p25:GetModule("ClientModule");
    u4 = p25:GetModule("CharacterController");
    u5 = p25:GetModule("Gui");
end;

function v1.Start(p26) -- Line: 212
    -- upvalues: u6 (ref), u5 (ref), u7 (ref), u4 (ref), u8 (ref), SetDebugMode (copy), Roles (copy), LocalPlayer (copy), u2 (ref), StartDebugMenu (copy), u10 (ref), u9 (ref)
    u6 = u5.GetComponent("Settings");
    u7 = u4.GetCharacter();
    u8 = u7 and u7.Simulation;
    u4.OnCharacterSpawn:Connect(function(p27) -- Line: 217
        -- upvalues: u7 (ref), u8 (ref)
        u7 = p27;
        u8 = p27.Simulation;
    end);
    u4.OnCharacterDestroy:Connect(function() -- Line: 222
        -- upvalues: u7 (ref), u8 (ref)
        u7 = nil;
        u8 = nil;
    end);
    u6:AddConnection("Game", "HUD & UI", "Debug Mode", SetDebugMode);
    local v28 = u6:GetPlayerSettings() or {};
    local v29 = v28.Game and v28.Game["HUD & UI"];
    local v30 = v29 and v29["Debug Mode"] or false;

    if v30 and not Roles.HasRole(LocalPlayer.UserId, "Admin") then
        v30 = false;
    end;

    u2.SetNetworkDebugEnabled(v30);

    if v30 then
        StartDebugMenu();

        return;
    end;

    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    if u9 then
        u9:destroy();
        u9 = nil;
    end;
end;

return v1;