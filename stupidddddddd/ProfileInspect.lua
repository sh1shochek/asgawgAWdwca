-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard.ProfileInspect
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard.ProfileInspect
-- Decompile time: 5.87 ms

local v1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetRankTitle = require(ReplicatedStorage.Components.Common.GetRankTitle)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
require(ReplicatedStorage.Database.Custom.Types)
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local Settings = require(ReplicatedStorage.Interface.Screens.Menu.Settings)
local Report = require(script.Parent.Parent.Report)
local LocalPlayer = Players.LocalPlayer
local u61 = {["Show Player Crosshairs"] = true, ["Show my crosshair when spectating bots"] = true}
local u64 = nil
local u65 = nil
local u66 = {}
local u67 = nil
local u68 = nil
local u69 = nil
local u70 = nil
local u71 = nil
local u72 = nil

local function getBadgeIconFromItem(a1) -- Line: 39 -- upvalues: Skins (val)
    if typeof(a1) == "table" and a1.Name == "Badge" then
        local v1 = Skins.GetSkinInformation(a1.Name, a1.Skin)
        if not v1 then
            return ""
        end
        return Skins.GetWearImageForFloat(v1, a1.Float or 0.9999) or v1.imageAssetId or ""
    end
    return ""
end

local function collectPinLabels(a1) -- Line: 52 -- types: a1: userdata
    local v1 = {}
    for i, j in a1:GetChildren() do
        if j:IsA("ImageLabel") and j.Name == "Pin" then
            table.insert(v1, j)
        end
    end
    table.sort(v1, function(a1, a2) -- Line: 60 -- types: a1: userdata, a2: userdata
        return a1.LayoutOrder < a2.LayoutOrder
    end)
    return v1
end

local function getEquippedBadgeId(a1, a2) -- Line: 67
    if typeof(a2) == "table" and a1 then
        local v1 = a2[a1]
        if typeof(v1) == "table" and typeof(v1.Equipped) == "table" then
            local v2 = v1.Equipped["Equipped Badge"]
            if typeof(v2) == "string" and v2 ~= "" then
                return v2
            end
            return nil
        end
        return nil
    end
    return nil
end

local function populatePins(a1) -- Line: 81
    -- upvalues: DataController (val), Skins (val), u66 (ref)
    local v1, v2, v3
    local Attribute = a1:GetAttribute("Team")
    local v4, v5 = DataController.Get(a1, "Loadout", "Inventory")
    if typeof(v4) ~= "table" then
        v2 = nil
    elseif Attribute then
        local v6 = v4[Attribute]
        if typeof(v6) ~= "table" then
            v2 = nil
        elseif typeof(v6.Equipped) == "table" then
            v3 = v6.Equipped["Equipped Badge"]
            v2 = if typeof(v3) ~= "string" then nil else if v3 == "" then nil else v3
        else
            v2 = nil
        end
    else
        v2 = nil
    end
    local Skin_2 = nil
    if v2 and typeof(v5) == "table" then
        for i, v in ipairs(v5) do
            if typeof(v) == "table" and v._id == v2 and v.Name == "Badge" and typeof(v.Skin) == "string" then
                Skin_2 = v.Skin
                break
            end
        end
    end
    v3 = nil
    local v7 = {}
    local v8 = {}
    if typeof(v5) == "table" then
        local imageAssetId, v9
        for i2, i3 in ipairs(v5) do
            if typeof(i3) == "table"
                and i3.Name == "Badge"
                and typeof(i3.Skin) == "string"
                and i3.Skin ~= ""
                and not v8[i3.Skin] then
                if typeof(i3) ~= "table" then
                    imageAssetId = ""
                elseif i3.Name == "Badge" then
                    v9 = Skins.GetSkinInformation(i3.Name, i3.Skin)
                    imageAssetId = if v9 then Skins.GetWearImageForFloat(v9, i3.Float or 0.9999) or v9.imageAssetId or "" else ""
                else
                    imageAssetId = ""
                end
                if imageAssetId ~= "" then
                    v8[i3.Skin] = true
                    if not Skin_2 or i3.Skin ~= Skin_2 then
                        table.insert(v7, imageAssetId)
                    else
                        v3 = imageAssetId
                    end
                end
            end
        end
    end
    for i4, j in ipairs(u66) do
        v1 = if i4 ~= 1 then v7[i4 - 1] else v3
        if not v1 then
            j.Visible = false
        else
            j.Image = v1
            j.Visible = true
        end
    end
end

local function populateLevel(a1) -- Line: 137
    -- upvalues: u67 (ref), u68 (ref), u69 (ref), DataController (val), GetRankTitle (val), LevelsIcon (val)
    if u67 and u68 and u69 then
        local v1 = DataController.Get(a1, "Level")
        local v2 = 1
        local v3 = 0
        local v4 = 1000
        if typeof(v1) == "table" then
            v2 = v1.Level or 1
            v3 = v1.Experience or 0
            v4 = v1.NextExperienceRequirement or 1000
        end
        u67.Text = ("[%* Rank %*]"):format(GetRankTitle(v2), v2)
        u68.Image = LevelsIcon[tostring(v2)] or ""
        local v5 = math.clamp(v3 / math.max(v4, 1), 0, 1)
        local Y = u69.Size.Y
        u69.Size = UDim2.new(v5, 0, Y.Scale, Y.Offset)
        return
    end
end

local function updateActionButtons(a1) -- Line: 161
    -- upvalues: Participants (val), u70 (ref), LocalPlayer (val), u71 (ref)
    local v1, v2
    local v3 = Participants.IsBot(a1)
    if u70 then
        v1 = u70
        v2 = false
        if a1 ~= nil then
            v2 = false
            if a1 ~= LocalPlayer then
                v2 = not v3
            end
        end
        v1.Active = v2
    end
    if u71 then
        u71.Visible = not v3
        v1 = u71
        v2 = false
        if a1 ~= nil then
            v2 = not v3
        end
        v1.Active = v2
    end
end

local function copyPlayerCrosshair(a1) -- Line: 174
    -- upvalues: LocalPlayer (val), Participants (val), DataController (val), u61 (val), Settings (val)
    if a1 ~= LocalPlayer and not Participants.IsBot(a1) then
        local v1 = DataController.Get(a1, "Settings.Game.Crosshair")
        if typeof(v1) ~= "table" then
            return
        end
        for k, v in pairs(v1) do
            if not u61[k] then
                Settings.SettingChanged("Game", k, v)
            end
        end
        return
    end
end

function v1.Bind(a1) -- Line: 191
    -- upvalues: u64 (ref), u65 (ref), u67 (ref), u68 (ref), u69 (ref), u66 (ref), collectPinLabels (val), u70 (ref)
    -- upvalues: ActivateButton (val), u72 (ref), copyPlayerCrosshair (val), u71 (ref), LocalPlayer (val)
    -- upvalues: Participants (val), Report (val)
    local Info = a1:FindFirstChild("Info")
    local Player = Info and Info:FindFirstChild("Player")
    local Pins = Info and Info:FindFirstChild("Pins")
    local Level = Info and Info:FindFirstChild("Level")
    local LevelBar = Level and Level:FindFirstChild("LevelBar")
    u64 = Player and Player:FindFirstChild("Avatar")
    u65 = Info and Info:FindFirstChild("Username")
    u67 = Level and Level:FindFirstChild("TextLabel")
    u68 = Level and Level:FindFirstChild("Rank")
    u69 = LevelBar and LevelBar:FindFirstChild("Current")
    u66 = if not Pins then {} else if not Pins:IsA("Frame") then {} else collectPinLabels(Pins)
    local CopyCrosshair = a1:FindFirstChild("CopyCrosshair")
    if CopyCrosshair and CopyCrosshair:IsA("ImageButton") then
        u70 = CopyCrosshair
        ActivateButton(CopyCrosshair)
        CopyCrosshair.MouseButton1Click:Connect(function() -- Line: 210 -- upvalues: u72 (upval), copyPlayerCrosshair (upval)
            if u72 then
                copyPlayerCrosshair(u72)
            end
        end)
    end
    local Report_2 = a1:FindFirstChild("Report")
    if Report_2 and Report_2:IsA("ImageButton") then
        u71 = Report_2
        ActivateButton(Report_2)
        Report_2.MouseButton1Click:Connect(function() -- Line: 221 -- upvalues: u72 (upval), LocalPlayer (upval), Participants (upval), Report (upval)
            if u72 and u72 ~= LocalPlayer and not Participants.IsBot(u72) then
                Report.Open(u72)
            end
        end)
    end
end

local function clearAccountDetails() -- Line: 229 -- upvalues: u66 (ref), u67 (ref), u68 (ref), u69 (ref)
    for i, j in u66 do
        j.Visible = false
    end
    if u67 then
        u67.Text = ""
    end
    if u68 then
        u68.Image = ""
    end
    if u69 then
        local Y = u69.Size.Y
        u69.Size = UDim2.new(0, 0, Y.Scale, Y.Offset)
    end
end

function v1.Populate(a1) -- Line: 248
    -- upvalues: u72 (ref), Participants (val), u70 (ref), LocalPlayer (val), u71 (ref), u64 (ref), u65 (ref), u66 (ref)
    -- upvalues: u67 (ref), u68 (ref), u69 (ref), populatePins (val), populateLevel (val)
    local v1, v2
    u72 = a1
    local v3 = Participants.IsBot(a1)
    if u70 then
        v1 = u70
        v2 = false
        if a1 ~= nil then
            v2 = false
            if a1 ~= LocalPlayer then
                v2 = not v3
            end
        end
        v1.Active = v2
    end
    if u71 then
        u71.Visible = not v3
        v1 = u71
        v2 = false
        if a1 ~= nil then
            v2 = not v3
        end
        v1.Active = v2
    end
    if u64 then
        u64.Image = Participants.HeadshotImage(a1)
    end
    if u65 then
        u65.Text = Participants.Name(a1)
    end
    if not Participants.IsBot(a1) then
        populatePins(a1)
        populateLevel(a1)
        return
    end
    for i, j in u66 do
        j.Visible = false
    end
    if u67 then
        u67.Text = ""
    end
    if u68 then
        u68.Image = ""
    end
    if u69 then
        local Y = u69.Size.Y
        u69.Size = UDim2.new(0, 0, Y.Scale, Y.Offset)
    end
    if u67 then
        u67.Text = "[Bot]"
    end
end

function v1.Reset() -- Line: 272
    -- upvalues: u72 (ref), Participants (val), u70 (ref), u71 (ref), u66 (ref), u67 (ref), u68 (ref), u69 (ref)
    -- upvalues: u64 (ref), u65 (ref)
    u72 = nil
    local v1 = Participants.IsBot(nil)
    if u70 then
        u70.Active = false
    end
    if u71 then
        u71.Visible = not v1
        u71.Active = false
    end
    for i, j in u66 do
        j.Visible = false
    end
    if u67 then
        u67.Text = ""
    end
    if u68 then
        u68.Image = ""
    end
    if u69 then
        local Y = u69.Size.Y
        u69.Size = UDim2.new(0, 0, Y.Scale, Y.Offset)
    end
    if u64 then
        u64.Image = ""
    end
    if u65 then
        u65.Text = ""
    end
end

return v1