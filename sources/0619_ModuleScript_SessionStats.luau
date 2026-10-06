-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Observers = require(ReplicatedStorage.Packages.Observers);
local u2 = table.find(GetUserPlatform(), "Mobile") ~= nil;
local os_clock_ret = os.clock();
local u3 = 0;
local u4 = 0;
local u5 = false;
local u6 = false;
local u7 = {};
local u8 = nil;
local u9 = nil;

local function UpdateServerStats(p10) -- Line: 46
    -- upvalues: u9 (ref), Constants (copy)
    u9.Server.Text = `Location: {p10}, Version: {Constants.VERSION}`;
end;

local function IsFiniteNumber(p11) -- Line: 50
    if typeof(p11) ~= "number" then
        return false;
    end;

    local v12;

    if p11 == p11 and p11 ~= (1 / 0) then
        v12 = p11 ~= (-1 / 0);
    else
        v12 = false;
    end;

    return v12;
end;

local function GetDisplayedPing() -- Line: 58
    -- upvalues: LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute("Ping");

    return tonumber(Attribute) or 999;
end;

local function UpdatePlayerText(p13: number) -- Line: 63
    -- upvalues: u6 (ref), u4 (ref), u7 (copy), u5 (ref), u9 (ref)
    local v14 = {};

    if u6 then
        local v15 = u4;

        if #u7 > 0 then
            local v16 = 0;
            local v17 = 0;

            for _, v in ipairs(u7) do
                local v18;

                if typeof(v) == "number" and (v == v and v ~= (1 / 0)) then
                    v18 = v ~= (-1 / 0);
                else
                    v18 = false;
                end;

                if v18 then
                    v16 = v16 + v;
                    v17 = v17 + 1;
                end;
            end;

            if v17 > 0 then
                v15 = math.round(v16 / v17);
            end;
        end;

        local v19 = `Fps: {tostring(v15)}`;
        table.insert(v14, v19);
    end;

    if u5 then
        local v20 = `Ping: {p13}ms`;
        table.insert(v14, v20);
    end;

    u9.Player.Text = table.concat(v14, ", ");
    u9.Player.Visible = #v14 > 0;
end;

local function UpdatePlayerStats(p21: number, p22: number) -- Line: 90
    -- upvalues: u4 (ref), u7 (copy), u3 (ref), os_clock_ret (ref), UpdatePlayerText (copy)
    local os_clock_ret2 = os.clock();
    local v23;

    if typeof(p21) == "number" and (p21 == p21 and p21 ~= (1 / 0)) then
        v23 = p21 ~= (-1 / 0);
    else
        v23 = false;
    end;

    if not v23 then
        p21 = u4;
    end;

    table.insert(u7, p21);
    u3 = p22;
    u4 = p21;

    if os_clock_ret2 - os_clock_ret >= 1 then
        os_clock_ret = os_clock_ret2;
        UpdatePlayerText(p22);
        table.clear(u7);
    end;
end;

local function StopStatsUpdate() -- Line: 105
    -- upvalues: u8 (ref)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;
end;

local function RunStatsUpdate(p24: number) -- Line: 112
    -- upvalues: u9 (ref), u6 (ref), u5 (ref), u8 (ref), LocalPlayer (copy), u4 (ref), UpdatePlayerStats (copy)
    if not (u9.Visible and (u6 or u5)) then
        if u8 then
            u8:Disconnect();
            u8 = nil;
        end;

        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Ping");
    local v25 = tonumber(Attribute) or 999;
    local v26 = u4;

    if p24 > 0 then
        v26 = math.round(1 / p24);
    end;

    local v27;

    if typeof(v26) == "number" and (v26 == v26 and v26 ~= (1 / 0)) then
        v27 = v26 ~= (-1 / 0);
    else
        v27 = false;
    end;

    if not v27 then
        v26 = u4;
    end;

    UpdatePlayerStats(v26, v25);
end;

local function SyncStatsUpdate() -- Line: 131
    -- upvalues: u2 (copy), u9 (ref), u6 (ref), u5 (ref), u8 (ref), os_clock_ret (ref), RunServiceController (copy), RunStatsUpdate (copy), LocalPlayer (copy), u4 (ref), UpdatePlayerStats (copy)
    if u2 or not u9 then
        return;
    end;

    if not (u9.Visible and (u6 or u5)) then
        if u8 then
            u8:Disconnect();
            u8 = nil;
        end;

        return;
    end;

    if u8 then
        return;
    end;

    os_clock_ret = os.clock();
    u8 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

    if u9.Visible and (u6 or u5) then
        local Attribute = LocalPlayer:GetAttribute("Ping");
        local v28 = tonumber(Attribute) or 999;
        local v29 = u4;
        local v30;

        if typeof(v29) == "number" and (v29 == v29 and v29 ~= (1 / 0)) then
            v30 = v29 ~= (-1 / 0);
        else
            v30 = false;
        end;

        if not v30 then
            v29 = u4;
        end;

        UpdatePlayerStats(v29, v28);
    elseif u8 then
        u8:Disconnect();
        u8 = nil;
    end;
end;

function v1.Initialize(p31, p32) -- Line: 153
    -- upvalues: u9 (ref), u2 (copy), u5 (ref), DataController (copy), LocalPlayer (copy), u6 (ref), Constants (copy), UpdatePlayerText (copy), u3 (ref), u8 (ref), os_clock_ret (ref), RunServiceController (copy), RunStatsUpdate (copy), u4 (ref), UpdatePlayerStats (copy), SyncStatsUpdate (copy), Observers (copy)
    u9 = p32;
    u9.Visible = false;

    if u2 then
        u9:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 158
            -- upvalues: u9 (ref)
            if u9.Visible then
                u9.Visible = false;
            end;
        end);

        return;
    end;

    u5 = DataController.Get(LocalPlayer, "Settings.Game.Other.Show Ping") == true;
    u6 = DataController.Get(LocalPlayer, "Settings.Game.Other.Show FPS") == true;
    u9.Server.Text = `Location: Unknown, Version: {Constants.VERSION}`;

    local function onStatSettingChanged() -- Line: 169
        -- upvalues: u9 (ref), UpdatePlayerText (ref), u3 (ref), u2 (ref), u6 (ref), u5 (ref), u8 (ref), os_clock_ret (ref), RunServiceController (ref), RunStatsUpdate (ref), LocalPlayer (ref), u4 (ref), UpdatePlayerStats (ref)
        if u9.Visible then
            UpdatePlayerText(u3);
        end;

        if not u2 then
            if not u9 then
                return;
            end;

            if u9.Visible and (u6 or u5) then
                if u8 then
                    return;
                end;

                os_clock_ret = os.clock();
                u8 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

                if u9.Visible and (u6 or u5) then
                    local Attribute = LocalPlayer:GetAttribute("Ping");
                    local v33 = tonumber(Attribute) or 999;
                    local v34 = u4;
                    local v35;

                    if typeof(v34) == "number" and (v34 == v34 and v34 ~= (1 / 0)) then
                        v35 = v34 ~= (-1 / 0);
                    else
                        v35 = false;
                    end;

                    if not v35 then
                        v34 = u4;
                    end;

                    UpdatePlayerStats(v34, v33);

                    return;
                end;

                if u8 then
                    u8:Disconnect();
                    u8 = nil;
                end;
            elseif u8 then
                u8:Disconnect();
                u8 = nil;
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Show FPS", function(p36) -- Line: 175
        -- upvalues: u6 (ref), u9 (ref), UpdatePlayerText (ref), u3 (ref), u2 (ref), u5 (ref), u8 (ref), os_clock_ret (ref), RunServiceController (ref), RunStatsUpdate (ref), LocalPlayer (ref), u4 (ref), UpdatePlayerStats (ref)
        u6 = p36 == true;

        if u9.Visible then
            UpdatePlayerText(u3);
        end;

        if not u2 then
            if not u9 then
                return;
            end;

            if u9.Visible and (u6 or u5) then
                if u8 then
                    return;
                end;

                os_clock_ret = os.clock();
                u8 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

                if u9.Visible and (u6 or u5) then
                    local Attribute = LocalPlayer:GetAttribute("Ping");
                    local v37 = tonumber(Attribute) or 999;
                    local v38 = u4;
                    local v39;

                    if typeof(v38) == "number" and (v38 == v38 and v38 ~= (1 / 0)) then
                        v39 = v38 ~= (-1 / 0);
                    else
                        v39 = false;
                    end;

                    if not v39 then
                        v38 = u4;
                    end;

                    UpdatePlayerStats(v38, v37);

                    return;
                end;

                if u8 then
                    u8:Disconnect();
                    u8 = nil;
                end;
            elseif u8 then
                u8:Disconnect();
                u8 = nil;
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Show Ping", function(p40) -- Line: 179
        -- upvalues: u5 (ref), u9 (ref), UpdatePlayerText (ref), u3 (ref), u2 (ref), u6 (ref), u8 (ref), os_clock_ret (ref), RunServiceController (ref), RunStatsUpdate (ref), LocalPlayer (ref), u4 (ref), UpdatePlayerStats (ref)
        u5 = p40 == true;

        if u9.Visible then
            UpdatePlayerText(u3);
        end;

        if not u2 then
            if not u9 then
                return;
            end;

            if u9.Visible and (u6 or u5) then
                if u8 then
                    return;
                end;

                os_clock_ret = os.clock();
                u8 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

                if u9.Visible and (u6 or u5) then
                    local Attribute = LocalPlayer:GetAttribute("Ping");
                    local v41 = tonumber(Attribute) or 999;
                    local v42 = u4;
                    local v43;

                    if typeof(v42) == "number" and (v42 == v42 and v42 ~= (1 / 0)) then
                        v43 = v42 ~= (-1 / 0);
                    else
                        v43 = false;
                    end;

                    if not v43 then
                        v42 = u4;
                    end;

                    UpdatePlayerStats(v42, v41);

                    return;
                end;

                if u8 then
                    u8:Disconnect();
                    u8 = nil;
                end;
            elseif u8 then
                u8:Disconnect();
                u8 = nil;
            end;
        end;
    end);
    u9:GetPropertyChangedSignal("Visible"):Connect(SyncStatsUpdate);

    if not u2 and u9 then
        if u9.Visible and (u6 or u5) then
            if not u8 then
                os_clock_ret = os.clock();
                u8 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

                if u9.Visible and (u6 or u5) then
                    local Attribute = LocalPlayer:GetAttribute("Ping");
                    local v44 = tonumber(Attribute) or 999;
                    local v45 = u4;
                    local v46;

                    if typeof(v45) == "number" and (v45 == v45 and v45 ~= (1 / 0)) then
                        v46 = v45 ~= (-1 / 0);
                    else
                        v46 = false;
                    end;

                    if not v46 then
                        v45 = u4;
                    end;

                    UpdatePlayerStats(v45, v44);
                elseif u8 then
                    u8:Disconnect();
                    u8 = nil;
                end;
            end;
        elseif u8 then
            u8:Disconnect();
            u8 = nil;
        end;
    end;

    Observers.observeAttribute(workspace, "Timezone", function(p47) -- Line: 186
        -- upvalues: u9 (ref), Constants (ref)
        u9.Server.Text = `Location: {p47}, Version: {Constants.VERSION}`;

        return function() -- Line: 189
            -- upvalues: u9 (ref), Constants (ref)
            u9.Server.Text = `Location: Unknown, Version: {Constants.VERSION}`;
        end;
    end);
end;

return v1;