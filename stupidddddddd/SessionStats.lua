-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.SessionStats
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.SessionStats
-- Decompile time: 7.30 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Observers = require(ReplicatedStorage.Packages.Observers)
local u40 = table.find(GetUserPlatform(), "Mobile") ~= nil
local u42 = os.clock()
local u43 = 0
local u44 = 0
local u45 = false
local u46 = false
local u47 = {}
local u48 = nil
local u49 = nil

local function UpdateServerStats(a1) -- Line: 46 -- upvalues: u49 (ref), Constants (val)
    u49.Server.Text = ("Location: %*, Version: %*"):format(a1, Constants.VERSION)
end

local function IsFiniteNumber(a1) -- Line: 50
    if typeof(a1) ~= "number" then
        return false
    end
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 ~= (1 / 0) then
            v1 = a1 ~= (-1 / 0)
        end
    end
    return v1
end

local function GetDisplayedPing() -- Line: 58 -- upvalues: LocalPlayer (val)
    return tonumber((LocalPlayer:GetAttribute("Ping"))) or 999
end

local function UpdatePlayerText(a1) -- Line: 63
    -- upvalues: u46 (ref), u44 (ref), u47 (val), u45 (ref), u49 (ref)
    local v1 = {}
    if u46 then
        local v2 = u44
        local v3 = #u47
        if v3 > 0 then
            local v4
            v3 = 0
            local v5 = 0
            for i, v in ipairs(u47) do
                if typeof(v) == "number" then
                    v4 = false
                    if v == v then
                        v4 = false
                        if v ~= (1 / 0) then
                            v4 = v ~= (-1 / 0)
                        end
                    end
                else
                    v4 = false
                end
                if v4 then
                    v3 = v3 + v
                    v5 = v5 + 1
                end
            end
            if v5 > 0 then
                v2 = math.round(v3 / v5)
            end
        end
        table.insert(v1, (("Fps: %*"):format((tostring(v2)))))
    end
    if u45 then
        table.insert(v1, (("Ping: %*ms"):format(a1)))
    end
    u49.Player.Text = table.concat(v1, ", ")
    u49.Player.Visible = #v1 > 0
end

local function UpdatePlayerStats(a1, a2) -- Line: 90
    -- upvalues: u44 (ref), u47 (val), u43 (ref), u42 (ref), UpdatePlayerText (val)
    local v1, v2
    local v3 = os.clock()
    if typeof(a1) == "number" then
        v2 = false
        if a1 == a1 then
            v2 = false
            if a1 ~= (1 / 0) then
                v2 = a1 ~= (-1 / 0)
            end
        end
    else
        v2 = false
    end
    table.insert(u47, if not v2 then u44 else a1)
    u43 = a2
    u44 = v1
    if 1 <= v3 - u42 then
        u42 = v3
        UpdatePlayerText(a2)
        table.clear(u47)
    end
end

local function StopStatsUpdate() -- Line: 105 -- upvalues: u48 (ref)
    if u48 then
        u48:Disconnect()
        u48 = nil
    end
end

local function RunStatsUpdate(a1) -- Line: 112
    -- upvalues: u49 (ref), u46 (ref), u45 (ref), u48 (ref), LocalPlayer (val), u44 (ref), UpdatePlayerStats (val)
    local v1
    if not u49.Visible then
        if u48 then
            u48:Disconnect()
            u48 = nil
        end
        return
    end
    if not u46 and not u45 then
        if u48 then
            u48:Disconnect()
            u48 = nil
        end
        return
    end
    local v2 = u44
    if a1 > 0 then
        v2 = math.round(1 / a1)
    end
    if typeof(v2) == "number" then
        v1 = false
        if v2 == v2 then
            v1 = false
            if v2 ~= (1 / 0) then
                v1 = v2 ~= (-1 / 0)
            end
        end
    else
        v1 = false
    end
    if not v1 then
        v2 = u44
    end
    UpdatePlayerStats(v2, tonumber((LocalPlayer:GetAttribute("Ping"))) or 999)
end

local function SyncStatsUpdate() -- Line: 131
    -- upvalues: u40 (val), u49 (ref), u46 (ref), u45 (ref), u48 (ref), u42 (ref), RunServiceController (val)
    -- upvalues: RunStatsUpdate (val), LocalPlayer (val), u44 (ref), UpdatePlayerStats (val)
    if not u40 and u49 then
        local v1
        if not u49.Visible then
            if u48 then
                u48:Disconnect()
                u48 = nil
            end
            return
        end
        if not u46 and not u45 then
            if u48 then
                u48:Disconnect()
                u48 = nil
            end
            return
        end
        if u48 then
            return
        end
        u42 = os.clock()
        u48 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate)
        if not u49.Visible then
            if u48 then
                u48:Disconnect()
                u48 = nil
                return
            end
            return
        end
        if not u46 and not u45 then
            if not u48 then
                return
            end
            u48:Disconnect()
            u48 = nil
            return
        end
        local v2 = u44
        if typeof(v2) == "number" then
            v1 = false
            if v2 == v2 then
                v1 = false
                if v2 ~= (1 / 0) then
                    v1 = v2 ~= (-1 / 0)
                end
            end
        else
            v1 = false
        end
        if not v1 then
            v2 = u44
        end
        UpdatePlayerStats(v2, tonumber((LocalPlayer:GetAttribute("Ping"))) or 999)
        return
    end
end

function v1.Initialize(a1, a2) -- Line: 153
    -- upvalues: u49 (ref), u40 (val), u45 (ref), DataController (val), LocalPlayer (val), u46 (ref), Constants (val)
    -- upvalues: UpdatePlayerText (val), u43 (ref), u48 (ref), u42 (ref), RunServiceController (val)
    -- upvalues: RunStatsUpdate (val), u44 (ref), UpdatePlayerStats (val), SyncStatsUpdate (val), Observers (val)
    u49 = a2
    u49.Visible = false
    if u40 then
        (u49:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 158 -- upvalues: u49 (upval)
            if u49.Visible then
                u49.Visible = false
            end
        end)
        return
    end
    u45 = DataController.Get(LocalPlayer, "Settings.Game.Other.Show Ping") == true
    u46 = DataController.Get(LocalPlayer, "Settings.Game.Other.Show FPS") == true
    u49.Server.Text = ("Location: Unknown, Version: %*"):format(Constants.VERSION)

    local function onStatSettingChanged() -- Line: 169
        -- upvalues: u49 (upval), UpdatePlayerText (upval), u43 (upval), u40 (upval), u46 (upval), u45 (upval)
        -- upvalues: u48 (upval), u42 (upval), RunServiceController (upval), RunStatsUpdate (upval), LocalPlayer (upval)
        -- upvalues: u44 (upval), UpdatePlayerStats (upval)
        if u49.Visible then
            UpdatePlayerText(u43)
        end
        if not u40 then
            if not u49 then
                return
            end
            if u49.Visible then
                local v1
                if not u46 and not u45 then
                    if u48 then
                        u48:Disconnect()
                        u48 = nil
                    end
                    return
                end
                if u48 then
                    return
                end
                u42 = os.clock()
                u48 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate)
                if not u49.Visible then
                    if u48 then
                        u48:Disconnect()
                        u48 = nil
                        return
                    end
                    return
                end
                if not u46 and not u45 then
                    if not u48 then
                        return
                    end
                    u48:Disconnect()
                    u48 = nil
                    return
                end
                local v2 = tonumber((LocalPlayer:GetAttribute("Ping"))) or 999
                local v3 = u44
                if typeof(v3) == "number" then
                    v1 = false
                    if v3 == v3 then
                        v1 = false
                        if v3 ~= (1 / 0) then
                            v1 = v3 ~= (-1 / 0)
                        end
                    end
                else
                    v1 = false
                end
                if not v1 then
                    v3 = u44
                end
                UpdatePlayerStats(v3, v2)
                return
            end
            if u48 then
                u48:Disconnect()
                u48 = nil
            end
        end
    end

    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Show FPS", function(a1) -- Line: 175
        -- upvalues: u46 (upval), u49 (upval), UpdatePlayerText (upval), u43 (upval), u40 (upval), u45 (upval)
        -- upvalues: u48 (upval), u42 (upval), RunServiceController (upval), RunStatsUpdate (upval), LocalPlayer (upval)
        -- upvalues: u44 (upval), UpdatePlayerStats (upval)
        u46 = a1 == true
        if u49.Visible then
            UpdatePlayerText(u43)
        end
        if not u40 then
            if not u49 then
                return
            end
            if u49.Visible then
                local v1
                if not u46 and not u45 then
                    if u48 then
                        u48:Disconnect()
                        u48 = nil
                    end
                    return
                end
                if u48 then
                    return
                end
                u42 = os.clock()
                u48 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate)
                if not u49.Visible then
                    if u48 then
                        u48:Disconnect()
                        u48 = nil
                        return
                    end
                    return
                end
                if not u46 and not u45 then
                    if not u48 then
                        return
                    end
                    u48:Disconnect()
                    u48 = nil
                    return
                end
                local v2 = tonumber((LocalPlayer:GetAttribute("Ping"))) or 999
                local v3 = u44
                if typeof(v3) == "number" then
                    v1 = false
                    if v3 == v3 then
                        v1 = false
                        if v3 ~= (1 / 0) then
                            v1 = v3 ~= (-1 / 0)
                        end
                    end
                else
                    v1 = false
                end
                if not v1 then
                    v3 = u44
                end
                UpdatePlayerStats(v3, v2)
                return
            end
            if u48 then
                u48:Disconnect()
                u48 = nil
            end
        end
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Show Ping", function(a1) -- Line: 179
        -- upvalues: u45 (upval), u49 (upval), UpdatePlayerText (upval), u43 (upval), u40 (upval), u46 (upval)
        -- upvalues: u48 (upval), u42 (upval), RunServiceController (upval), RunStatsUpdate (upval), LocalPlayer (upval)
        -- upvalues: u44 (upval), UpdatePlayerStats (upval)
        u45 = a1 == true
        if u49.Visible then
            UpdatePlayerText(u43)
        end
        if not u40 then
            if not u49 then
                return
            end
            if u49.Visible then
                local v1
                if not u46 and not u45 then
                    if u48 then
                        u48:Disconnect()
                        u48 = nil
                    end
                    return
                end
                if u48 then
                    return
                end
                u42 = os.clock()
                u48 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate)
                if not u49.Visible then
                    if u48 then
                        u48:Disconnect()
                        u48 = nil
                        return
                    end
                    return
                end
                if not u46 and not u45 then
                    if not u48 then
                        return
                    end
                    u48:Disconnect()
                    u48 = nil
                    return
                end
                local v2 = tonumber((LocalPlayer:GetAttribute("Ping"))) or 999
                local v3 = u44
                if typeof(v3) == "number" then
                    v1 = false
                    if v3 == v3 then
                        v1 = false
                        if v3 ~= (1 / 0) then
                            v1 = v3 ~= (-1 / 0)
                        end
                    end
                else
                    v1 = false
                end
                if not v1 then
                    v3 = u44
                end
                UpdatePlayerStats(v3, v2)
                return
            end
            if u48 then
                u48:Disconnect()
                u48 = nil
            end
        end
    end)
    ;(u49:GetPropertyChangedSignal("Visible")):Connect(SyncStatsUpdate)
    if not u40 and u49 then
        if not u49.Visible then
            if u48 then
                u48:Disconnect()
                u48 = nil
            end
        else
            local v1, v2, v3
            if u46 then
                if not u48 then
                    u42 = os.clock()
                    u48 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate)
                    if not u49.Visible then
                        if u48 then
                            u48:Disconnect()
                            u48 = nil
                        end
                    elseif u46 or u45 then
                        v1 = tonumber((LocalPlayer:GetAttribute("Ping"))) or 999
                        v2 = u44
                        if typeof(v2) == "number" then
                            v3 = false
                            if v2 == v2 then
                                v3 = false
                                if v2 ~= (1 / 0) then
                                    v3 = v2 ~= (-1 / 0)
                                end
                            end
                        else
                            v3 = false
                        end
                        if not v3 then
                            v2 = u44
                        end
                        UpdatePlayerStats(v2, v1)
                    elseif u48 then
                        u48:Disconnect()
                        u48 = nil
                    end
                end
            elseif not u45 then
                if u48 then
                    u48:Disconnect()
                    u48 = nil
                end
            elseif not u48 then
                u42 = os.clock()
                u48 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate)
                if not u49.Visible then
                    if u48 then
                        u48:Disconnect()
                        u48 = nil
                    end
                elseif u46 or u45 then
                    v1 = tonumber((LocalPlayer:GetAttribute("Ping"))) or 999
                    v2 = u44
                    if typeof(v2) == "number" then
                        v3 = false
                        if v2 == v2 then
                            v3 = false
                            if v2 ~= (1 / 0) then
                                v3 = v2 ~= (-1 / 0)
                            end
                        end
                    else
                        v3 = false
                    end
                    if not v3 then
                        v2 = u44
                    end
                    UpdatePlayerStats(v2, v1)
                elseif u48 then
                    u48:Disconnect()
                    u48 = nil
                end
            end
        end
    end
    Observers.observeAttribute(workspace, "Timezone", function(a1) -- Line: 186 -- upvalues: u49 (upval), Constants (upval)
        u49.Server.Text = ("Location: %*, Version: %*"):format(a1, Constants.VERSION)
        return function() -- Line: 189 -- upvalues: u49 (upval), Constants (upval)
            u49.Server.Text = ("Location: Unknown, Version: %*"):format(Constants.VERSION)
        end
    end)
end

return v1