-- ReplicatedStorage.Interface.Screens.Menu.Progression
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Progression
-- Decompile time: 21.42 ms

local v1 = {}
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration)
local ConfigController = require(ReplicatedStorage.Controllers.ConfigController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys)
require(ReplicatedStorage.Database.Custom.Types)
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts)
local MissionStars = require(ReplicatedStorage.Database.Custom.GameStats.MissionStars)
local MissionIcons = require(ReplicatedStorage.Database.Custom.GameStats.MissionIcons)
local Missions = require(ReplicatedStorage.Database.Custom.GameStats.Missions)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local LocalPlayer = Players.LocalPlayer
local u105 = nil
local u106 = nil
local u107 = nil
local u108 = nil
local u109 = nil
local u110 = "hourly"
local u111 = nil
local u112 = {}
local u113 = {"hourly", "daily", "weekly", "monthly"}
local u136 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 89)),
    (ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 116))),
})
local u155 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 236, 160)),
    (ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 216, 141))),
})
local u174 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 125, 125)),
    (ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65))),
})

local function isMissionStarRewardClaimed(a1, a2) -- Line: 58 -- types: a1: table?, a2: number
    local v1 = false
    if a1 ~= nil then
        v1 = a1[tostring(a2)] == true
    end
    return v1
end

local function hasDailyStarToClaim(a1) -- Line: 62 -- upvalues: MissionStars (val)
    local Rewards, v1
    if not a1 then
        return false
    end
    for i = 1, (math.clamp(a1.CurrentStreak, 0, #MissionStars)) do
        Rewards = a1.Rewards
        v1 = false
        if Rewards ~= nil then
            v1 = Rewards[tostring(i)] == true
        end
        if not v1 then
            return true
        end
    end
    return false
end

local function hasClaimableMissions(a1) -- Line: 77 -- types: a1: table?
    local Progress
    if not a1 then
        return false
    end
    for i, v in ipairs(a1) do
        Progress = v.Progress
        if v.Target <= Progress and not v.IsClaimed then
            return true
        end
    end
    return false
end

local function getAlertFingerprint(a1, a2) -- Line: 91 -- upvalues: MissionStars (val) -- types: a1: table?
    local v1 = {}
    if a1 then
        for i, v in ipairs(a1) do
            table.insert(v1, (("%*:%*:%*"):format(v.MissionId, v.Progress, (tostring(v.IsClaimed)))))
        end
    end
    if a2 then
        local Rewards, v2
        for i2 = 1, (math.clamp(a2.CurrentStreak, 0, #MissionStars)) do
            Rewards = a2.Rewards
            v2 = false
            if Rewards ~= nil then
                v2 = Rewards[tostring(i2)] == true
            end
            if not v2 then
                table.insert(v1, (("star:%*"):format(i2)))
            end
        end
    end
    return table.concat(v1, "|")
end

local function updateProgressionAlert(a1, a2) -- Line: 115
    -- upvalues: u105 (ref), DataController (val), LocalPlayer (val), getAlertFingerprint (val)
    -- upvalues: hasClaimableMissions (val), hasDailyStarToClaim (val), u106 (ref), u111 (ref)
    if not u105 then
        return
    end
    local Alert = u105.Menu.Top.Bottom.Buttons.Progression:FindFirstChild("Alert")
    if Alert and Alert:IsA("GuiObject") then
        local v1 = a2 or DataController.Get(LocalPlayer, "Missions")
        local v2 = a1 or DataController.Get(LocalPlayer, "MissionStars")
        local v3 = getAlertFingerprint(v1, v2)
        local v4 = hasClaimableMissions(v1) or hasDailyStarToClaim(v2)
        if not u106 or not u106.Visible then
            Alert.Visible = v4 and v3 ~= u111
        else
            u111 = v3
            Alert.Visible = false
        end
        local TextLabel = Alert:FindFirstChild("TextLabel")
        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = "!"
        end
        return
    end
end

local function getMissionFromId(a1) -- Line: 148
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Missions")
    if not v1 then
        return nil
    end
    for i, v in ipairs(v1) do
        if v.MissionId == a1 then
            return v
        end
    end
    return nil
end

local function getMissionCreditRewardAmount(a1) -- Line: 162 -- upvalues: ConfigKeys (val), ConfigController (val)
    local v1 = a1.Rewards[1]
    if v1 and v1.type == "Credits" and typeof(v1.amount) == "number" then
        local v2 = ConfigKeys.Shared.MissionCreditRewardMultipliers[a1.Type]
        return (math.round(v1.amount * (if not v2 then 1 else ConfigController.GetRewardMultiplier(v2))))
    end
    return 0
end

local function canonicalizeFilter(a1) -- Line: 173 -- upvalues: u113 (val) -- types: a1: userdata
    local v1 = table.find(u113, a1.Name)
    if v1 then
        return u113[v1]
    end
    return nil
end

local function getEarliestExpirationTime(a1) -- Line: 178
    -- upvalues: DataController (val), LocalPlayer (val), Missions (val)
    local v1
    local v2 = DataController.Get(LocalPlayer, "Missions")
    if not v2 then
        return nil
    end
    local ExpiresAt = nil
    local v3 = os.time() * 1000
    for i, v in ipairs(v2) do
        v1 = Missions.GetMissionDefinition(v.MissionId)
        if v1 and v1.Type == a1 and v3 < v.ExpiresAt then
            if not ExpiresAt or v.ExpiresAt < ExpiresAt then
                ExpiresAt = v.ExpiresAt
            end
        end
    end
    return ExpiresAt
end

local function updateMissionHeader() -- Line: 200
    -- upvalues: getEarliestExpirationTime (val), u110 (ref), u107 (ref), FormatDuration (val)
    local v1 = getEarliestExpirationTime(u110)
    local v2 = if not v1 then 0 else math.max(0, (math.floor((v1 - (os.time()) * 1000) / 1000)))
    u107.MissionHeader.Title.Text = ("%* MISSIONS"):format((string.upper(u110)))
    u107.MissionHeader.Timer.Text = FormatDuration(v2, "IfNeeded")
end

local function setReward(a1, a2) -- Line: 208
    -- upvalues: ConfigKeys (val), ConfigController (val), CommaNumber (val)
    local v1
    local v2 = a2.Rewards[1]
    if not v2 or v2.type ~= "Credits" then
        v1 = 0
    elseif typeof(v2.amount) == "number" then
        local v3 = ConfigKeys.Shared.MissionCreditRewardMultipliers[a2.Type]
        v1 = math.round(v2.amount * (if not v3 then 1 else ConfigController.GetRewardMultiplier(v3)))
    else
        v1 = 0
    end
    a1.ItemTemplate.Amount.Text = ("x%*"):format((CommaNumber(v1)))
    a1.RewardTemplate.Amount.Text = ("x%*"):format((CommaNumber(v1)))
    a1.RewardTemplate.Icon.Image = "rbxassetid://129921992230064"
end

local function getMissionFingerprint(a1, a2, a3) -- Line: 215
    -- upvalues: ConfigKeys (val), ConfigController (val)
    local v1
    local concat = table.concat
    local v2 = {}
    local MissionId = a2.MissionId
    local DisplayName = a1.DisplayName or a1.MissionId
    local v3 = tostring(a2.Progress)
    local v4 = tostring(a2.Target)
    local v5 = tostring(a2.IsClaimed)
    local v6 = a1.Rewards[1]
    if not v6 or v6.type ~= "Credits" then
        v1 = 0
    elseif typeof(v6.amount) == "number" then
        local v7 = ConfigKeys.Shared.MissionCreditRewardMultipliers[a1.Type]
        v1 = math.round(v6.amount * (if not v7 then 1 else ConfigController.GetRewardMultiplier(v7)))
    else
        v1 = 0
    end
    local v8 = tostring(v1)
    v2[1] = MissionId
    v2[2] = DisplayName
    v2[3] = v3
    v2[4] = v4
    v2[5] = v5
    v2[6] = v8
    v2[7] = (tostring(a3))
    return concat(v2, "|")
end

local function updateMissionTemplate(a1, a2, a3, a4) -- Line: 231
    -- upvalues: CommaNumber (val), MissionIcons (val), ConfigKeys (val), ConfigController (val)
    local v1
    a1.LayoutOrder = a4
    local v2 = math.max(a3.Target, 1)
    local v3 = a3.Target <= a3.Progress
    local Title = a1.Title
    local DisplayName = a2.DisplayName or a2.MissionId
    Title.Text = DisplayName
    a1.Progress.Text = ("%*/%*"):format(CommaNumber(a3.Progress), (CommaNumber(a3.Target)))
    a1.Bar.Progress.Size = UDim2.fromScale(math.clamp(a3.Progress / v2, 0, 1), 1)
    a1.GlowEffect.Visible = v3 and not a3.IsClaimed
    a1.RewardTemplate.Finish.Visible = a3.IsClaimed
    local Icon = a1.ItemTemplate.Icon
    local Default = MissionIcons[a2.Category] or MissionIcons.Default
    Icon.Image = Default
    local v4 = a2.Rewards[1]
    if not v4 or v4.type ~= "Credits" then
        v1 = 0
    elseif typeof(v4.amount) == "number" then
        local v5 = ConfigKeys.Shared.MissionCreditRewardMultipliers[a2.Type]
        v1 = math.round(v4.amount * (if not v5 then 1 else ConfigController.GetRewardMultiplier(v5)))
    else
        v1 = 0
    end
    a1.ItemTemplate.Amount.Text = ("x%*"):format((CommaNumber(v1)))
    a1.RewardTemplate.Amount.Text = ("x%*"):format((CommaNumber(v1)))
    a1.RewardTemplate.Icon.Image = "rbxassetid://129921992230064"
end

local function createMissionTemplate(a1, a2, a3) -- Line: 252
    -- upvalues: u109 (ref), updateMissionTemplate (val), u108 (ref), DataController (val), LocalPlayer (val)
    -- upvalues: Router (val), Remotes (val)
    local v1 = u109:Clone()
    v1.Name = a2.MissionId
    v1.Visible = true
    v1.Active = true
    v1:SetAttribute("GeneratedMission", true)
    updateMissionTemplate(v1, a1, a2, a3)
    v1.Parent = u108
    local MissionId = a2.MissionId
    v1.InputEnded:Connect(function(a1) -- Line: 266
        -- upvalues: MissionId (val), DataController (upval), LocalPlayer (upval), Router (upval), Remotes (upval)
        local v1
        if a1.UserInputType ~= Enum.UserInputType.MouseButton1 and a1.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local v2 = DataController.Get(LocalPlayer, "Missions")
        if v2 then
            for i, v in ipairs(v2) do
                if v.MissionId == MissionId then
                    v1 = v
                    if v1 and v1.Target <= v1.Progress and not v1.IsClaimed then
                        Router.broadcastRouter("RunInterfaceSound", "UI Click")
                        Remotes.Dashboard.MissionCompleted.Send(MissionId)
                    end
                    return
                end
            end
        end
        v1 = nil
        if v1 and v1.Target <= v1.Progress and not v1.IsClaimed then
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            Remotes.Dashboard.MissionCompleted.Send(MissionId)
        end
    end)
    return v1
end

local function reconcileMissions(a1) -- Line: 284
    -- upvalues: Profiler (val), u108 (ref), Missions (val), u110 (ref), getMissionFingerprint (val)
    -- upvalues: createMissionTemplate (val), u112 (val), updateMissionTemplate (val), updateMissionHeader (val)
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u108 (upval), a1 (val), Missions (upval), u110 (upval), getMissionFingerprint (upval)
        -- upvalues: Profiler (upval), createMissionTemplate (upval), u112 (upval), updateMissionTemplate (upval)
        -- upvalues: updateMissionHeader (upval)
        local v1 = {}
        for i, v in ipairs(u108:GetChildren()) do
            if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                v1[v.Name] = v
            end
        end
        local v2 = {}
        local v3 = 0
        if a1 then
            local MissionId, v4, v5, v6
            for i2, i3 in ipairs(a1) do
                v6 = Missions.GetMissionDefinition(i3.MissionId)
                if v6 and v6.Type == u110 then
                    v3 = v3 + 1
                    MissionId = i3.MissionId
                    v4 = getMissionFingerprint(v6, i3, v3)
                    v5 = v1[MissionId]
                    v2[MissionId] = true
                    if not v5 then
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                    elseif u112[MissionId] ~= v4 then
                        Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                    end
                    u112[MissionId] = v4
                end
            end
        end
        for k, j in pairs(v1) do
            if not v2[k] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                    j:Destroy()
                end)
                u112[k] = nil
            end
        end
        updateMissionHeader()
    end)
end

local function renderMissions() -- Line: 346
    -- upvalues: DataController (val), LocalPlayer (val), Profiler (val), u108 (ref), Missions (val), u110 (ref)
    -- upvalues: getMissionFingerprint (val), createMissionTemplate (val), u112 (val), updateMissionTemplate (val)
    -- upvalues: updateMissionHeader (val)
    local u4 = DataController.Get(LocalPlayer, "Missions")
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u108 (upval), u4 (val), Missions (upval), u110 (upval), getMissionFingerprint (upval)
        -- upvalues: Profiler (upval), createMissionTemplate (upval), u112 (upval), updateMissionTemplate (upval)
        -- upvalues: updateMissionHeader (upval)
        local v1 = {}
        for i, v in ipairs(u108:GetChildren()) do
            if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                v1[v.Name] = v
            end
        end
        local v2 = {}
        local v3 = 0
        if u4 then
            local MissionId, v4, v5, v6
            for i2, i3 in ipairs(u4) do
                v6 = Missions.GetMissionDefinition(i3.MissionId)
                if v6 and v6.Type == u110 then
                    v3 = v3 + 1
                    MissionId = i3.MissionId
                    v4 = getMissionFingerprint(v6, i3, v3)
                    v5 = v1[MissionId]
                    v2[MissionId] = true
                    if not v5 then
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                    elseif u112[MissionId] ~= v4 then
                        Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                    end
                    u112[MissionId] = v4
                end
            end
        end
        for k, j in pairs(v1) do
            if not v2[k] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                    j:Destroy()
                end)
                u112[k] = nil
            end
        end
        updateMissionHeader()
    end)
end

local function updateFilterButtons() -- Line: 350 -- upvalues: u107 (ref), u113 (val), u110 (ref)
    local v1, v2
    for i, v in ipairs(u107.ChangeMissionTimes:GetChildren()) do
        if v:IsA("GuiButton") then
            v2 = table.find(u113, v.Name)
            v1 = if not v2 then nil else u113[v2]
            v.GlowEffect.Visible = v1 == u110
        end
    end
end

local function openMissionFilter(a1) -- Line: 360
    -- upvalues: u110 (ref), updateFilterButtons (val), DataController (val), LocalPlayer (val), Profiler (val)
    -- upvalues: u108 (ref), Missions (val), getMissionFingerprint (val), createMissionTemplate (val), u112 (val)
    -- upvalues: updateMissionTemplate (val), updateMissionHeader (val)
    u110 = a1
    updateFilterButtons()
    local u7 = DataController.Get(LocalPlayer, "Missions")
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u108 (upval), u7 (val), Missions (upval), u110 (upval), getMissionFingerprint (upval)
        -- upvalues: Profiler (upval), createMissionTemplate (upval), u112 (upval), updateMissionTemplate (upval)
        -- upvalues: updateMissionHeader (upval)
        local v1 = {}
        for i, v in ipairs(u108:GetChildren()) do
            if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                v1[v.Name] = v
            end
        end
        local v2 = {}
        local v3 = 0
        if u7 then
            local MissionId, v4, v5, v6
            for i2, i3 in ipairs(u7) do
                v6 = Missions.GetMissionDefinition(i3.MissionId)
                if v6 and v6.Type == u110 then
                    v3 = v3 + 1
                    MissionId = i3.MissionId
                    v4 = getMissionFingerprint(v6, i3, v3)
                    v5 = v1[MissionId]
                    v2[MissionId] = true
                    if not v5 then
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                    elseif u112[MissionId] ~= v4 then
                        Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                    end
                    u112[MissionId] = v4
                end
            end
        end
        for k, j in pairs(v1) do
            if not v2[k] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                    j:Destroy()
                end)
                u112[k] = nil
            end
        end
        updateMissionHeader()
    end)
end

local function setupMissionFilters() -- Line: 366
    -- upvalues: u107 (ref), u113 (val), ActivateButton (val), u110 (ref), updateFilterButtons (val)
    -- upvalues: DataController (val), LocalPlayer (val), Profiler (val), u108 (ref), Missions (val)
    -- upvalues: getMissionFingerprint (val), createMissionTemplate (val), u112 (val), updateMissionTemplate (val)
    -- upvalues: updateMissionHeader (val)
    local v1
    local v2 = {}
    for i, v in ipairs(u107.ChangeMissionTimes:GetChildren()) do
        if v:IsA("GuiButton") then
            v1 = table.find(u113, v.Name)
            if not v1 then
                u51 = nil
            else
                local u51 = u113[v1]
            end
            if u51 and not v2[u51] then
                v2[u51] = true
                ActivateButton(v)
                v.MouseButton1Click:Connect(function() -- Line: 378
                    -- upvalues: u51 (val), u110 (upval), updateFilterButtons (upval), DataController (upval)
                    -- upvalues: LocalPlayer (upval), Profiler (upval), u108 (upval), Missions (upval)
                    -- upvalues: getMissionFingerprint (upval), createMissionTemplate (upval), u112 (upval)
                    -- upvalues: updateMissionTemplate (upval), updateMissionHeader (upval)
                    u110 = u51
                    updateFilterButtons()
                    local u7 = DataController.Get(LocalPlayer, "Missions")
                    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
                        -- upvalues: u108 (upval), u7 (val), Missions (upval), u110 (upval)
                        -- upvalues: getMissionFingerprint (upval), Profiler (upval), createMissionTemplate (upval)
                        -- upvalues: u112 (upval), updateMissionTemplate (upval), updateMissionHeader (upval)
                        local v1 = {}
                        for i, v in ipairs(u108:GetChildren()) do
                            if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                                v1[v.Name] = v
                            end
                        end
                        local v2 = {}
                        local v3 = 0
                        if u7 then
                            local MissionId, v4, v5, v6
                            for i2, i3 in ipairs(u7) do
                                v6 = Missions.GetMissionDefinition(i3.MissionId)
                                if v6 and v6.Type == u110 then
                                    v3 = v3 + 1
                                    MissionId = i3.MissionId
                                    v4 = getMissionFingerprint(v6, i3, v3)
                                    v5 = v1[MissionId]
                                    v2[MissionId] = true
                                    if not v5 then
                                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                                    elseif u112[MissionId] ~= v4 then
                                        Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                                    end
                                    u112[MissionId] = v4
                                end
                            end
                        end
                        for k, j in pairs(v1) do
                            if not v2[k] then
                                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                                    j:Destroy()
                                end)
                                u112[k] = nil
                            end
                        end
                        updateMissionHeader()
                    end)
                end)
            end
        end
    end
    for i2, i3 in ipairs(u113) do
        assert(v2[i3], (("Progression is missing its %* mission filter"):format(i3)))
    end
    updateFilterButtons()
end

local function attemptStarClaim(a1) -- Line: 389
    -- upvalues: DataController (val), LocalPlayer (val), Router (val), Remotes (val)
    local v1 = DataController.Get(LocalPlayer, "MissionStars")
    if not v1 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Mission stars are still loading.")
        return
    end
    local Rewards = v1.Rewards
    local v2 = false
    if Rewards ~= nil then
        v2 = Rewards[tostring(a1)] == true
    end
    if v2 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Star reward already claimed.")
        return
    end
    if v1.CurrentStreak < a1 then
        Router.broadcastRouter("CreateMenuNotification", "Error", (("Reach streak day %* to claim this reward."):format(a1)))
        return
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
    Remotes.Dashboard.ClaimStarReward.Send(a1)
end

local function updateMissionStars(a1) -- Line: 408
    -- upvalues: updateProgressionAlert (val), MissionStars (val), u107 (ref), u106 (ref), TweenService (val)
    -- upvalues: CommaNumber (val), u155 (val), u136 (val), u174 (val)
    local Rewards, v1, v2, v3, v4, v5
    updateProgressionAlert(a1)
    local DailyStars = u107.DailyStars
    local Progress = DailyStars.Bar.Progress
    local v6 = UDim2.fromScale((if not a1 then 0 else math.clamp(a1.CurrentStreak, 0, #MissionStars)) / math.max(#MissionStars, 1), 1)
    if not u106.Visible then
        Progress.Size = v6
    else
        TweenService:Create(Progress, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = v6}):Play()
    end
    u107.StarHeader.Streak.Streak.Text = tostring(v1)
    local v7 = a1
    for i, v in ipairs(MissionStars) do
        v2 = DailyStars.Container:FindFirstChild((("Template%*"):format(i)))
        assert(v2, (("Progression is missing star template %*"):format(i)))
        v3 = false
        if v7 ~= nil then
            Rewards = v7.Rewards
            v3 = false
            if Rewards ~= nil then
                v3 = Rewards[tostring(i)] == true
            end
        end
        v4 = i <= v1
        v2.ItemTemplate.Amount.Text = ("x%*"):format((CommaNumber(v)))
        v2.Title.Text = if not v3 then if not v4 then tostring(i) else "CLAIM" else "CLAIMED"
        v2.Star.Glow.Visible = v4
        v5 = if not v3 then if not v4 then u174 else u136 else u155
        v2.Star.Icon.UIGradient.Color = v5
        v2.Title.UIGradient.Color = v5
        v2.Star.Glow.UIGradient.Color = v5
    end
end

local function setupMissionStars() -- Line: 442
    -- upvalues: MissionStars (val), u107 (ref), ActivateButton (val), attemptStarClaim (val), updateMissionStars (val)
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1
    local v2 = #MissionStars
    for i = 1, v2 do
        v1 = u107.DailyStars.Container:FindFirstChild((("Template%*"):format(i)))
        assert(v1, (("Progression is missing star template %*"):format(i)))
        ActivateButton(v1)
        v1.MouseButton1Click:Connect(function() -- Line: 447 -- upvalues: attemptStarClaim (upval), i (val)
            attemptStarClaim(i)
        end)
    end
    updateMissionStars((DataController.Get(LocalPlayer, "MissionStars")))
end

local function setupRefreshButtons() -- Line: 454
    -- upvalues: u107 (ref), ActivateButton (val), MarketplaceService (val), LocalPlayer (val), DevProducts (val)
    -- upvalues: Router (val)
    local More = u107.MissionHeader.More
    ActivateButton(More)
    More.MouseButton1Click:Connect(function() -- Line: 457
        -- upvalues: MarketplaceService (upval), LocalPlayer (upval), DevProducts (upval), Router (upval)
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts["Refresh Missions"].DevProductId)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end)
end

local function visibilityUpdated(a1) -- Line: 463
    -- upvalues: DataController (val), LocalPlayer (val), updateProgressionAlert (val), Profiler (val), u108 (ref)
    -- upvalues: Missions (val), u110 (ref), getMissionFingerprint (val), createMissionTemplate (val), u112 (val)
    -- upvalues: updateMissionTemplate (val), updateMissionHeader (val), updateMissionStars (val)
    local v1 = DataController.Get(LocalPlayer, "MissionStars")
    updateProgressionAlert(v1, (DataController.Get(LocalPlayer, "Missions")))
    if a1 then
        local u19 = DataController.Get(LocalPlayer, "Missions")
        Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
            -- upvalues: u108 (upval), u19 (val), Missions (upval), u110 (upval), getMissionFingerprint (upval)
            -- upvalues: Profiler (upval), createMissionTemplate (upval), u112 (upval), updateMissionTemplate (upval)
            -- upvalues: updateMissionHeader (upval)
            local v1 = {}
            for i, v in ipairs(u108:GetChildren()) do
                if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                    v1[v.Name] = v
                end
            end
            local v2 = {}
            local v3 = 0
            if u19 then
                local MissionId, v4, v5, v6
                for i2, i3 in ipairs(u19) do
                    v6 = Missions.GetMissionDefinition(i3.MissionId)
                    if v6 and v6.Type == u110 then
                        v3 = v3 + 1
                        MissionId = i3.MissionId
                        v4 = getMissionFingerprint(v6, i3, v3)
                        v5 = v1[MissionId]
                        v2[MissionId] = true
                        if not v5 then
                            Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                        elseif u112[MissionId] ~= v4 then
                            Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                        end
                        u112[MissionId] = v4
                    end
                end
            end
            for k, j in pairs(v1) do
                if not v2[k] then
                    Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                        j:Destroy()
                    end)
                    u112[k] = nil
                end
            end
            updateMissionHeader()
        end)
        updateMissionStars(v1)
    end
end

function v1.Initialize(a1, a2) -- Line: 474
    -- upvalues: u105 (ref), u106 (ref), u107 (ref), u108 (ref), u109 (ref), MissionIcons (val), ContentProvider (val)
    -- upvalues: setupMissionFilters (val), setupMissionStars (val), ActivateButton (val), MarketplaceService (val)
    -- upvalues: LocalPlayer (val), DevProducts (val), Router (val), DataController (val), Profiler (val)
    -- upvalues: Missions (val), u110 (ref), getMissionFingerprint (val), createMissionTemplate (val), u112 (val)
    -- upvalues: updateMissionTemplate (val), updateMissionHeader (val), updateProgressionAlert (val)
    -- upvalues: updateMissionStars (val), ConfigKeys (val), ConfigController (val), renderMissions (val)
    u105 = a1
    u106 = a2
    u107 = a2.Missions
    u108 = u107.MissionsTab
    u109 = u108.MissionTemplate:Clone()
    u109.Parent = nil
    u108.MissionTemplate:Destroy()
    local u17 = {}
    for i, j in MissionIcons do
        if not table.find(u17, j) then
            table.insert(u17, j)
        end
    end
    task.spawn(function() -- Line: 491 -- upvalues: ContentProvider (upval), u17 (val)
        ContentProvider:PreloadAsync(u17)
    end)
    setupMissionFilters()
    setupMissionStars()
    local More = u107.MissionHeader.More
    ActivateButton(More)
    More.MouseButton1Click:Connect(function() -- Line: 457
        -- upvalues: MarketplaceService (upval), LocalPlayer (upval), DevProducts (upval), Router (upval)
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts["Refresh Missions"].DevProductId)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end)
    local u51 = DataController.Get(LocalPlayer, "Missions")
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u108 (upval), u51 (val), Missions (upval), u110 (upval), getMissionFingerprint (upval)
        -- upvalues: Profiler (upval), createMissionTemplate (upval), u112 (upval), updateMissionTemplate (upval)
        -- upvalues: updateMissionHeader (upval)
        local v1 = {}
        for i, v in ipairs(u108:GetChildren()) do
            if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                v1[v.Name] = v
            end
        end
        local v2 = {}
        local v3 = 0
        if u51 then
            local MissionId, v4, v5, v6
            for i2, i3 in ipairs(u51) do
                v6 = Missions.GetMissionDefinition(i3.MissionId)
                if v6 and v6.Type == u110 then
                    v3 = v3 + 1
                    MissionId = i3.MissionId
                    v4 = getMissionFingerprint(v6, i3, v3)
                    v5 = v1[MissionId]
                    v2[MissionId] = true
                    if not v5 then
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                    elseif u112[MissionId] ~= v4 then
                        Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                    end
                    u112[MissionId] = v4
                end
            end
        end
        for k, j in pairs(v1) do
            if not v2[k] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                    j:Destroy()
                end)
                u112[k] = nil
            end
        end
        updateMissionHeader()
    end)
    updateProgressionAlert(DataController.Get(LocalPlayer, "MissionStars"), (DataController.Get(LocalPlayer, "Missions")))
    DataController.CreateListener(LocalPlayer, "Missions", function(a1) -- Line: 504
        -- upvalues: Profiler (upval), u106 (upval), u108 (upval), Missions (upval), u110 (upval)
        -- upvalues: getMissionFingerprint (upval), createMissionTemplate (upval), u112 (upval)
        -- upvalues: updateMissionTemplate (upval), updateMissionHeader (upval), updateProgressionAlert (upval)
        Profiler.scope("UI.Progression.MissionsChanged", function() -- Line: 505
            -- upvalues: u106 (upval), a1 (val), Profiler (upval), u108 (upval), Missions (upval), u110 (upval)
            -- upvalues: getMissionFingerprint (upval), createMissionTemplate (upval), u112 (upval)
            -- upvalues: updateMissionTemplate (upval), updateMissionHeader (upval), updateProgressionAlert (upval)
            if u106.Visible then
                local u2 = a1
                Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
                    -- upvalues: u108 (upval), u2 (val), Missions (upval), u110 (upval), getMissionFingerprint (upval)
                    -- upvalues: Profiler (upval), createMissionTemplate (upval), u112 (upval)
                    -- upvalues: updateMissionTemplate (upval), updateMissionHeader (upval)
                    local v1 = {}
                    for i, v in ipairs(u108:GetChildren()) do
                        if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                            v1[v.Name] = v
                        end
                    end
                    local v2 = {}
                    local v3 = 0
                    if u2 then
                        local MissionId, v4, v5, v6
                        for i2, i3 in ipairs(u2) do
                            v6 = Missions.GetMissionDefinition(i3.MissionId)
                            if v6 and v6.Type == u110 then
                                v3 = v3 + 1
                                MissionId = i3.MissionId
                                v4 = getMissionFingerprint(v6, i3, v3)
                                v5 = v1[MissionId]
                                v2[MissionId] = true
                                if not v5 then
                                    Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                                elseif u112[MissionId] ~= v4 then
                                    Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                                end
                                u112[MissionId] = v4
                            end
                        end
                    end
                    for k, j in pairs(v1) do
                        if not v2[k] then
                            Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                                j:Destroy()
                            end)
                            u112[k] = nil
                        end
                    end
                    updateMissionHeader()
                end)
            end
            updateProgressionAlert(nil, a1)
        end)
    end)
    DataController.CreateListener(LocalPlayer, "MissionStars", function(a1) -- Line: 512 -- upvalues: updateMissionStars (upval)
        updateMissionStars(a1)
    end)
    for k, v in pairs(ConfigKeys.Shared.MissionCreditRewardMultipliers) do
        ConfigController.OnChanged(v, renderMissions)
    end
end

function v1.Start() -- Line: 520
    -- upvalues: RunService (val), u106 (ref), updateMissionHeader (val), DataController (val), LocalPlayer (val)
    -- upvalues: updateProgressionAlert (val), Profiler (val), u108 (ref), Missions (val), u110 (ref)
    -- upvalues: getMissionFingerprint (val), createMissionTemplate (val), u112 (val), updateMissionTemplate (val)
    -- upvalues: updateMissionStars (val)
    local u0 = 0
    RunService.Heartbeat:Connect(function(a1) -- Line: 522 -- upvalues: u106 (upval), u0 (ref), updateMissionHeader (upval) -- types: a1: number
        if not u106.Visible then
            return
        end
        u0 = u0 + a1
        if u0 >= 1 then
            u0 = 0
            updateMissionHeader()
        end
    end)
    ;(u106:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 532
        -- upvalues: u106 (upval), DataController (upval), LocalPlayer (upval), updateProgressionAlert (upval)
        -- upvalues: Profiler (upval), u108 (upval), Missions (upval), u110 (upval), getMissionFingerprint (upval)
        -- upvalues: createMissionTemplate (upval), u112 (upval), updateMissionTemplate (upval)
        -- upvalues: updateMissionHeader (upval), updateMissionStars (upval)
        local Visible = u106.Visible
        local v1 = DataController.Get(LocalPlayer, "MissionStars")
        local v2 = DataController.Get(LocalPlayer, "Missions")
        updateProgressionAlert(v1, v2)
        if Visible then
            local u20 = DataController.Get(LocalPlayer, "Missions")
            Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
                -- upvalues: u108 (upval), u20 (val), Missions (upval), u110 (upval), getMissionFingerprint (upval)
                -- upvalues: Profiler (upval), createMissionTemplate (upval), u112 (upval)
                -- upvalues: updateMissionTemplate (upval), updateMissionHeader (upval)
                local v1 = {}
                for i, v in ipairs(u108:GetChildren()) do
                    if v:IsA("Frame") and v:GetAttribute("GeneratedMission") then
                        v1[v.Name] = v
                    end
                end
                local v2 = {}
                local v3 = 0
                if u20 then
                    local MissionId, v4, v5, v6
                    for i2, i3 in ipairs(u20) do
                        v6 = Missions.GetMissionDefinition(i3.MissionId)
                        if v6 and v6.Type == u110 then
                            v3 = v3 + 1
                            MissionId = i3.MissionId
                            v4 = getMissionFingerprint(v6, i3, v3)
                            v5 = v1[MissionId]
                            v2[MissionId] = true
                            if not v5 then
                                Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, v6, i3, v3)
                            elseif u112[MissionId] ~= v4 then
                                Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v5, v6, i3, v3)
                            end
                            u112[MissionId] = v4
                        end
                    end
                end
                for k, j in pairs(v1) do
                    if not v2[k] then
                        Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336 -- upvalues: j (val)
                            j:Destroy()
                        end)
                        u112[k] = nil
                    end
                end
                updateMissionHeader()
            end)
            updateMissionStars(v1)
        end
    end)
end

return v1