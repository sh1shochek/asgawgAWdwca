-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.MissionCompleted
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.MissionCompleted
-- Decompile time: 8.04 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local ConfigController = require(ReplicatedStorage.Controllers.ConfigController)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Missions = require(ReplicatedStorage.Database.Custom.GameStats.Missions)
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys)
require(ReplicatedStorage.Database.Custom.Types)
local u54 = Color3.fromRGB(255, 255, 255)
local u58 = UDim2.fromScale(0.5, -1.5)
local u62 = UDim2.fromScale(0.1, 1)
local u66 = UDim2.fromScale(0.5, -0.25)
local u70 = UDim2.fromScale(8, 1)
local u71 = {}
u71.hourly = Color3.fromRGB(208, 182, 68)
u71.daily = Color3.fromRGB(21, 208, 11)
u71.weekly = Color3.fromRGB(76, 154, 255)
u71.monthly = Color3.fromRGB(160, 68, 191)
local u96 = Color3.fromRGB(255, 255, 255)
local u97 = {
    hourly = "HOURLY MISSION",
    daily = "DAILY MISSION",
    weekly = "WEEKLY MISSION",
    monthly = "MONTHLY MISSION",
}
local v1 = {}
local u99 = nil
local u100 = nil
local u101 = nil
local u102 = nil
local u103 = nil
local u104 = nil
local u105 = nil
local u106 = {}
local u107 = {}
local u108 = false
local u109 = {}
local u110 = false
local ProcessQueue = nil
local FinishDisplay = nil

local function CommaNumber(a1) -- Line: 96 -- types: a1: number
    return (tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local function ColorToHex(a1) -- Line: 100 -- types: a1: userdata
    return string.format("#%02X%02X%02X", math.round(a1.R * 255), math.round(a1.G * 255), (math.round(a1.B * 255)))
end

local function GetMissionKey(a1) -- Line: 109
    return (("%*:%*"):format(a1.MissionId, a1.CreatedAt))
end

local function GetCreditRewardAmount(a1, a2) -- Line: 113
    -- upvalues: ConfigKeys (val), ConfigController (val)
    local v1 = ConfigKeys.Shared.MissionCreditRewardMultipliers[a1]
    return (math.round(a2 * (if not v1 then 1 else ConfigController.GetRewardMultiplier(v1))))
end

local function CancelActiveTweens() -- Line: 119 -- upvalues: u106 (val)
    for i, j in u106 do
        j:Cancel()
    end
    table.clear(u106)
end

local function PlayTween(a1, a2, a3) -- Line: 126
    -- upvalues: TweenService (val), u106 (val)
    local v1 = TweenService:Create(a1, a2, a3)
    table.insert(u106, v1)
    v1:Play()
    return v1
end

local function SetTextLabelTransparent(a1, a2) -- Line: 133 -- types: a1: userdata, a2: boolean
    local v1
    a1.TextTransparency = if not a2 then 0 else 1
    a1.TextStrokeTransparency = v1
end

local function SetImageLabelTransparent(a1, a2) -- Line: 139 -- types: a1: userdata, a2: boolean
    a1.ImageTransparency = if not a2 then 0 else 1
end

local function SetContentTransparent(a1) -- Line: 143
    -- upvalues: u101 (ref), u102 (ref), u103 (ref), u104 (ref)
    local v1, v2
    if u101 then
        v1 = u101
        v1.TextTransparency = if not a1 then 0 else 1
        v1.TextStrokeTransparency = v2
    end
    if u102 then
        v1 = u102
        v1.TextTransparency = if not a1 then 0 else 1
        v1.TextStrokeTransparency = v2
    end
    if u103 then
        u103.ImageTransparency = if not a1 then 0 else 1
    end
    if u104 then
        u104.ImageTransparency = if not a1 then 0 else 1
    end
end

local function ResetFramePresentation() -- Line: 158
    -- upvalues: u106 (val), u100 (ref), u58 (val), u62 (val), u101 (ref), u102 (ref), u103 (ref), u104 (ref)
    local v1 = u106
    for i, j in v1 do
        j:Cancel()
    end
    table.clear(u106)
    if u100 then
        u100.Position = u58
        u100.Size = u62
    end
    if u101 then
        v1 = u101
        v1.TextTransparency = 1
        v1.TextStrokeTransparency = 1
    end
    if u102 then
        v1 = u102
        v1.TextTransparency = 1
        v1.TextStrokeTransparency = 1
    end
    if u103 then
        u103.ImageTransparency = 1
    end
    if u104 then
        u104.ImageTransparency = 1
    end
end

local function HidePopup() -- Line: 169
    -- upvalues: u99 (ref), u106 (val), u100 (ref), u58 (val), u62 (val), u101 (ref), u102 (ref), u103 (ref), u104 (ref)
    if u99 then
        u99.Visible = false
        local v1 = u106
        for i, j in v1 do
            j:Cancel()
        end
        table.clear(u106)
        if u100 then
            u100.Position = u58
            u100.Size = u62
        end
        if u101 then
            v1 = u101
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u102 then
            v1 = u102
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u103 then
            u103.ImageTransparency = 1
        end
        if u104 then
            u104.ImageTransparency = 1
        end
    end
end

local function ApplyHUDColor() -- Line: 176 -- upvalues: u100 (ref), GetPreferenceColor (val)
    if u100 then
        u100.BackgroundColor3 = GetPreferenceColor()
    end
end

local function IsMissionsNotificationsEnabled() -- Line: 182 -- upvalues: DataController (val), LocalPlayer (val)
    return DataController.Get(LocalPlayer, "Settings.Game.HUD.Enable Missions Notifications") ~= false
end

local function ShowEntry(a1, a2) -- Line: 186
    -- upvalues: u99 (ref), u100 (ref), u101 (ref), u102 (ref), u103 (ref), u106 (val), u54 (val), u105 (ref)
    -- upvalues: u104 (ref), GetPreferenceColor (val), u58 (val), u62 (val), Router (val), u66 (val), TweenService (val)
    -- upvalues: FinishDisplay (ref), u70 (val)
    if u99 and u100 and u101 and u102 and u103 then
        local v1
        for i, j in u106 do
            j:Cancel()
        end
        table.clear(u106)
        u101.RichText = true
        u101.TextColor3 = u54
        u101.Text = ("<font color=\"%*\">%*</font> COMPLETED"):format(a1.colorHex, a1.typeLabel)
        u102.Text = a1.objective
        if a1.creditAmount then
            u103.Image = "rbxassetid://129921992230064"
            if u105 then
                u105.Text = ("x%*"):format((tostring(a1.creditAmount):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")))
            end
        end
        u103.Visible = a1.creditAmount ~= nil
        if u104 then
            u104.Visible = a1.creditAmount ~= nil
        end
        if u100 then
            u100.BackgroundColor3 = GetPreferenceColor()
        end
        u100.Position = u58
        u100.Size = u62
        if u101 then
            v1 = u101
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u102 then
            v1 = u102
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u103 then
            u103.ImageTransparency = 1
        end
        if u104 then
            u104.ImageTransparency = 1
        end
        u99.Visible = true
        Router.broadcastRouter("RunInterfaceSound", "Mission Completed")
        local v2 = u100
        local v3 = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
        v1 = TweenService:Create(v2, v3, {Position = u66})
        table.insert(u106, v1)
        v1:Play()
        v1.Completed:Once(function(a1) -- Line: 223
            -- upvalues: FinishDisplay (upval), u99 (upval), u100 (upval), u70 (upval), TweenService (upval)
            -- upvalues: u106 (upval), u101 (upval), u102 (upval), u103 (upval), u104 (upval), a2 (val)
            if a1 ~= Enum.PlaybackState.Completed then
                FinishDisplay()
                return
            end
            task.delay(0.1, function() -- Line: 229
                -- upvalues: u99 (upval), u100 (upval), FinishDisplay (upval), u70 (upval), TweenService (upval)
                -- upvalues: u106 (upval), u101 (upval), u102 (upval), u103 (upval), u104 (upval), a2 (upval)
                if u99 and u99.Visible and u100 then
                    local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
                    local v2 = TweenService:Create(u100, v1, {Size = u70})
                    table.insert(u106, v2)
                    v2:Play()
                    if u101 then
                        v2 = TweenService:Create(u101, v1, {TextTransparency = 0, TextStrokeTransparency = 0})
                        table.insert(u106, v2)
                        v2:Play()
                    end
                    if u102 then
                        v2 = TweenService:Create(u102, v1, {TextTransparency = 0, TextStrokeTransparency = 0})
                        table.insert(u106, v2)
                        v2:Play()
                    end
                    if u103 then
                        v2 = TweenService:Create(u103, v1, {ImageTransparency = 0})
                        table.insert(u106, v2)
                        v2:Play()
                    end
                    if u104 then
                        v2 = TweenService:Create(u104, v1, {ImageTransparency = 0})
                        table.insert(u106, v2)
                        v2:Play()
                    end
                    task.delay(0.5, a2)
                    return
                end
                FinishDisplay()
            end)
        end)
        return
    end
end

function FinishDisplay() -- Line: 263
    -- upvalues: u109 (val), u110 (ref), ProcessQueue (ref), u99 (ref), u106 (val), u100 (ref), u58 (val), u62 (val)
    -- upvalues: u101 (ref), u102 (ref), u103 (ref), u104 (ref)
    table.remove(u109, 1)
    u110 = false
    if #u109 > 0 then
        ProcessQueue()
        return
    end
    if u99 then
        u99.Visible = false
        local v1 = u106
        for i, j in v1 do
            j:Cancel()
        end
        table.clear(u106)
        if u100 then
            u100.Position = u58
            u100.Size = u62
        end
        if u101 then
            v1 = u101
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u102 then
            v1 = u102
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u103 then
            u103.ImageTransparency = 1
        end
        if u104 then
            u104.ImageTransparency = 1
        end
    end
end

function ProcessQueue() -- Line: 273
    -- upvalues: u110 (ref), u109 (val), u99 (ref), u106 (val), u100 (ref), u58 (val), u62 (val), u101 (ref), u102 (ref)
    -- upvalues: u103 (ref), u104 (ref), ShowEntry (val), FinishDisplay (ref)
    if u110 then
        return
    end
    local v1 = u109[1]
    if v1 then
        u110 = true
        ShowEntry(v1, function() -- Line: 285 -- upvalues: FinishDisplay (upval)
            task.delay(3, FinishDisplay)
        end)
        return
    end
    if u99 then
        u99.Visible = false
        local v2 = u106
        for i, j in v2 do
            j:Cancel()
        end
        table.clear(u106)
        if u100 then
            u100.Position = u58
            u100.Size = u62
        end
        if u101 then
            v2 = u101
            v2.TextTransparency = 1
            v2.TextStrokeTransparency = 1
        end
        if u102 then
            v2 = u102
            v2.TextTransparency = 1
            v2.TextStrokeTransparency = 1
        end
        if u103 then
            u103.ImageTransparency = 1
        end
        if u104 then
            u104.ImageTransparency = 1
        end
    end
end

local function BuildEntry(a1) -- Line: 290
    -- upvalues: Missions (val), ConfigKeys (val), ConfigController (val), u97 (val), u71 (val), u96 (val)
    local v1 = Missions.GetMissionDefinition(a1.MissionId)
    if not v1 then
        return nil
    end
    local Type = v1.Type
    local v2 = nil
    local Rewards = v1.Rewards and v1.Rewards[1]
    if Rewards and Rewards.type == "Credits" and typeof(Rewards.amount) == "number" then
        local amount_2 = Rewards.amount
        local v3 = ConfigKeys.Shared.MissionCreditRewardMultipliers[Type]
        v2 = math.round(amount_2 * (if not v3 then 1 else ConfigController.GetRewardMultiplier(v3)))
    end
    local v4 = {typeLabel = u97[Type] or "MISSION"}
    local v5 = u71[Type] or u96
    v4.colorHex = string.format("#%02X%02X%02X", math.round(v5.R * 255), math.round(v5.G * 255), (math.round(v5.B * 255)))
    local DisplayName = v1.DisplayName or v1.MissionId
    v4.objective = DisplayName
    v4.creditAmount = v2
    return v4
end

local function EnqueueDisplayEntry(a1) -- Line: 311 -- upvalues: u109 (val), ProcessQueue (ref) -- types: a1: table
    table.insert(u109, a1)
    ProcessQueue()
end

local function OnMissionsChanged(a1) -- Line: 316
    -- upvalues: u107 (val), u108 (ref), DataController (val), LocalPlayer (val), BuildEntry (val), u109 (val)
    -- upvalues: ProcessQueue (ref)
    local v1, v2, v3
    if typeof(a1) ~= "table" then
        return
    end
    local v4 = {}
    for i, v in ipairs(a1) do
        if typeof(v) == "table" and typeof(v.MissionId) == "string" then
            v2 = ("%*:%*"):format(v.MissionId, v.CreatedAt)
            v4[v2] = true
            v3 = v.Progress or 0
            v3 = (v.Target or (1 / 0)) <= v3 and not v.IsClaimed
            if v3 and not u107[v2] then
                u107[v2] = true
                if u108 then
                    v1 = DataController.Get(LocalPlayer, "Settings.Game.HUD.Enable Missions Notifications") ~= false
                    if v1 then
                        v1 = BuildEntry(v)
                        if v1 then
                            table.insert(u109, v1)
                            ProcessQueue()
                        end
                    end
                end
            end
        end
    end
    for k in pairs(u107) do
        if not v4[k] then
            u107[k] = nil
        end
    end
    u108 = true
end

function v1.Initialize(a1, a2) -- Line: 357
    -- upvalues: u99 (ref), u100 (ref), u101 (ref), u102 (ref), u103 (ref), u105 (ref), u104 (ref), u106 (val)
    -- upvalues: u58 (val), u62 (val), GetPreferenceColor (val), DataController (val), LocalPlayer (val)
    -- upvalues: OnMissionsChanged (val)
    u99 = a2
    u100 = a2:FindFirstChild("Frame")
    local Container = u100 and u100:FindFirstChild("Container")
    local Info = Container and Container:FindFirstChild("Info")
    local Reward = Container and Container:FindFirstChild("Reward")
    u101 = Info and Info:FindFirstChild("Title")
    u102 = Info and Info:FindFirstChild("Objective")
    u103 = Reward and Reward:FindFirstChild("Icon")
    u105 = u103 and u103:FindFirstChild("Amount")
    if Container then
        for i, j in Container:GetDescendants() do
            if j:IsA("ImageLabel") and j ~= u103 then
                u104 = j
                break
            end
        end
    end
    if u100 and u101 and u102 and u103 then
        a2.Visible = false
        local v1 = u106
        for k, n in v1 do
            n:Cancel()
        end
        table.clear(u106)
        if u100 then
            u100.Position = u58
            u100.Size = u62
        end
        if u101 then
            v1 = u101
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u102 then
            v1 = u102
            v1.TextTransparency = 1
            v1.TextStrokeTransparency = 1
        end
        if u103 then
            u103.ImageTransparency = 1
        end
        if u104 then
            u104.ImageTransparency = 1
        end

        local function refreshHUDColor() -- Line: 386 -- upvalues: u99 (upval), u100 (upval), GetPreferenceColor (upval)
            if u99 and u99.Visible and u100 then
                u100.BackgroundColor3 = GetPreferenceColor()
            end
        end

        DataController.CreateListener(LocalPlayer, "Missions", OnMissionsChanged)
        DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshHUDColor)
        ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(refreshHUDColor)
        return
    end
    warn("[MissionCompleted] Missing expected UI elements; popup disabled.")
end

return v1