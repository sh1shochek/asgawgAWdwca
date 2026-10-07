-- ReplicatedStorage.Interface.Screens.Menu.Career.Overview
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.Overview
-- Decompile time: 12.64 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Types)
local Format = require(script.Parent.Format)
local Derive = require(script.Parent.Derive)
local Resolve = require(script.Parent.Resolve)
local Selection = require(script.Parent.Selection)
local CareerData = require(script.Parent.CareerData)
local WeaponIcon = require(script.Parent.WeaponIcon)
local LocalPlayer = Players.LocalPlayer
local GetRankTitle = require(ReplicatedStorage.Components.Common.GetRankTitle)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon)
local u72 = table.freeze({"Counter-Terrorists", "Terrorists"})
local u77 = Color3.fromRGB(219, 43, 43)
local u82 = Color3.new(1, 1, 1)
local u85 = table.freeze({Pistol = "1ST ROUND", Eco = "$0-999", Semi = "$1000-3899", Full = "$3900+"})
local u95 = table.freeze({"LOADOUT", "K/D", "ADR", "KAST", "WIN %", "KILLS", "DEATHS"})
local u96 = nil
local u97 = nil
local u98 = nil
local u99 = nil
local u100 = nil
local u101 = nil
local u102 = nil
local u103 = nil
local u104 = nil
local u105 = nil
local u106 = {}

local function GetOrderedLabels(a1) -- Line: 76 -- types: a1: userdata
    local v1 = a1:FindFirstChild("Left") or a1
    local v2 = {}
    for i, v in ipairs(v1:GetChildren()) do
        if v:IsA("TextLabel") then
            table.insert(v2, v)
        end
    end
    table.sort(v2, function(a1, a2) -- Line: 86 -- types: a1: userdata, a2: userdata
        return a1.Position.X.Scale < a2.Position.X.Scale
    end)
    return v2
end

local function GetBadgeIconFromItem(a1) -- Line: 95 -- upvalues: Skins (val)
    if typeof(a1) == "table" and a1.Name == "Badge" and typeof(a1.Skin) == "string" then
        local v1 = Skins.GetSkinInformation(a1.Name, a1.Skin)
        if not v1 then
            return ""
        end
        return Skins.GetWearImageForFloat(v1, if typeof(a1.Float) ~= "number" then 0.9999 else a1.Float) or v1.imageAssetId or ""
    end
    return ""
end

local function PopulatePins() -- Line: 112
    -- upvalues: u106 (ref), DataController (val), LocalPlayer (val), u72 (val), GetBadgeIconFromItem (val)
    local Equipped, Skin_2, v1, v2, v3, v4
    if #u106 == 0 then
        return
    end
    local v5, v6 = DataController.Get(LocalPlayer, "Inventory", "Loadout")
    local v7 = {}
    local v8 = {}
    for i, v in ipairs(u72) do
        v4 = false
        if typeof(v6) == "table" then
            v4 = v6[v]
        end
        Equipped = false
        if typeof(v4) == "table" then
            Equipped = v4.Equipped
        end
        v2 = false
        if typeof(Equipped) == "table" then
            v2 = Equipped["Equipped Badge"]
        end
        if typeof(v2) == "string" and v2 ~= "" and typeof(v5) == "table" then
            for i2, i3 in ipairs(v5) do
                if typeof(i3) == "table" and i3._id == v2 then
                    if (if typeof(i3.Skin) ~= "string" then "" else i3.Skin) == "" or v8[Skin_2] then
                        break
                    end
                    v3 = GetBadgeIconFromItem(i3)
                    if v3 == "" then
                        break
                    end
                    v8[Skin_2] = true
                    table.insert(v7, v3)
                    break
                end
            end
        end
    end
    for i4, j in ipairs(u106) do
        v4 = v7[i4]
        j.Image = v4 or ""
        v1 = v4 ~= nil
        j.Visible = v1
    end
end

local function PopulateLevel() -- Line: 161
    -- upvalues: u97 (ref), DataController (val), LocalPlayer (val), GetRankTitle (val), LevelsIcon (val)
    local Level = u97.Info:FindFirstChild("Level")
    if not Level then
        return
    end
    local v1 = DataController.Get(LocalPlayer, "Level")
    local v2 = 1
    local v3 = 0
    local v4 = 1000
    if typeof(v1) == "table" then
        v2 = v1.Level or 1
        v3 = v1.Experience or 0
        v4 = v1.NextExperienceRequirement or 1000
    end
    local TextLabel = Level:FindFirstChild("TextLabel")
    if TextLabel then
        TextLabel.Text = ("[%* Rank %*]"):format(GetRankTitle(v2), v2)
    end
    local Rank = Level:FindFirstChild("Rank")
    if Rank then
        Rank.Image = LevelsIcon[tostring(v2)] or ""
    end
    local LevelBar = Level:FindFirstChild("LevelBar")
    local Current = LevelBar and LevelBar:FindFirstChild("Current")
    if Current then
        local v5 = math.clamp(v3 / math.max(v4, 1), 0, 1)
        local Y = Current.Size.Y
        Current.Size = UDim2.new(v5, 0, Y.Scale, Y.Offset)
    end
end

local function PopulateProfile(a1) -- Line: 199
    -- upvalues: u97 (ref), LocalPlayer (val), PopulatePins (val), PopulateLevel (val), Resolve (val), Format (val)
    -- upvalues: Derive (val)
    local Player = u97.Info:FindFirstChild("Player")
    local Avatar = Player and Player:FindFirstChild("Avatar")
    if Avatar then
        Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(LocalPlayer.UserId)
    end
    local Username = u97.Info:FindFirstChild("Username")
    if Username then
        Username.Text = LocalPlayer.Name
    end
    local Verified = u97.Info:FindFirstChild("Verified")
    if Verified then
        Verified.Visible = LocalPlayer.HasVerifiedBadge
    end
    PopulatePins()
    PopulateLevel()
    local BasicInfo = u97:FindFirstChild("BasicInfo")
    if not BasicInfo then
        return
    end
    Resolve.SetRow(BasicInfo, "Timeplayed", "TIME PLAYED", Format.TimePlayed(a1.SecondsPlayed))
    Resolve.SetRow(BasicInfo, "Kd", "K/D RATIO", Format.Decimal(Derive.KillDeath(a1), 2))
    Resolve.SetRow(BasicInfo, "Winrate", "WIN RATE", Format.Percent(a1.MatchesWon, a1.MatchesPlayed))
end

local function PaintBodyZone(a1, a2, a3) -- Line: 232
    -- upvalues: u98 (ref), u82 (val), u77 (val), Derive (val)
    local Body = u98:FindFirstChild("Body")
    local v1 = Body and Body:FindFirstChild(a1)
    if not v1 then
        return
    end
    v1.ImageColor3 = u82:Lerp(u77, (Derive.HeatWeight(a2, a3)))
end

local function PopulateAccuracy(a1) -- Line: 244
    -- upvalues: u98 (ref), Resolve (val), Format (val), u82 (val), u77 (val), Derive (val)
    local Accuracy = a1.Accuracy
    local Info = u98:FindFirstChild("Info")
    if Info then
        local ShotsHit = Accuracy.ShotsHit
        Resolve.SetRow(Info, "Average", "AVERAGE", Format.Percent(ShotsHit, Accuracy.ShotsFired, 1))
        Resolve.SetRow(Info, "Head", "HEAD", Format.Percent(Accuracy.HeadHits, ShotsHit, 1))
        Resolve.SetRow(Info, "Body", "BODY", Format.Percent(Accuracy.BodyHits, ShotsHit, 1))
        Resolve.SetRow(Info, "Legs", "LEGS", Format.Percent(Accuracy.LegHits, ShotsHit, 1))
    end
    local HeadHits = Accuracy.HeadHits
    local ShotsFired = Accuracy.ShotsFired
    local Body = u98:FindFirstChild("Body")
    local Head = Body and Body:FindFirstChild("Head")
    if Head then
        Head.ImageColor3 = u82:Lerp(u77, (Derive.HeatWeight(HeadHits, ShotsFired)))
    end
    local BodyHits = Accuracy.BodyHits
    local ShotsFired_2 = Accuracy.ShotsFired
    local Body_2 = u98:FindFirstChild("Body")
    local Torso = Body_2 and Body_2:FindFirstChild("Torso")
    if Torso then
        Torso.ImageColor3 = u82:Lerp(u77, (Derive.HeatWeight(BodyHits, ShotsFired_2)))
    end
    local LegHits = Accuracy.LegHits
    local ShotsFired_3 = Accuracy.ShotsFired
    local Body_3 = u98:FindFirstChild("Body")
    local Legs = Body_3 and Body_3:FindFirstChild("Legs")
    if not Legs then
        return
    end
    Legs.ImageColor3 = u82:Lerp(u77, (Derive.HeatWeight(LegHits, ShotsFired_3)))
end

local function PopulateSide(a1, a2, a3) -- Line: 263
    -- upvalues: u100 (ref), Resolve (val), Format (val), Derive (val), WeaponIcon (val)
    local v1 = u100 and u100:FindFirstChild(a2)
    if not v1 then
        return
    end
    local v2 = a1.Sides[a3]
    if not v2 then
        return
    end
    local Info = v1:FindFirstChild("Info")
    if Info then
        Resolve.SetRow(Info, "Kd", "K/D RATIO", Format.Ratio(v2.Kills, v2.Deaths))
        Resolve.SetRow(Info, "Win", "WIN %", Format.Percent(v2.RoundsWon, v2.RoundsPlayed))
        Resolve.SetRow(Info, "Kills/Round", "KILLS/ROUND", Format.Decimal(Derive.Divide(v2.Kills, v2.RoundsPlayed), 1))
    end
    local FavoriteGun = v1:FindFirstChild("FavoriteGun")
    if not FavoriteGun then
        return
    end
    local v3, v4 = Derive.FavouriteWeapon(a1, a3)
    local ItemIcon = FavoriteGun:FindFirstChild("ItemIcon")
    if ItemIcon then
        ItemIcon.Image = if not v3 then "" else WeaponIcon.Get(v3, a3)
    end
    local Header = FavoriteGun:FindFirstChild("Header")
    local Title = Header and Header:FindFirstChild("Title")
    if Title then
        Title.Text = if not v3 then "FAVORITE WEAPON" else ("FAVORITE WEAPON: %*"):format((string.upper(v3)))
    end
    local Title_2 = FavoriteGun:FindFirstChild("Title")
    if Title_2 then
        Title_2.Text = ("KILLS: %*"):format((Format.Number(v4)))
    end
end

local function PopulateKillStats(a1) -- Line: 314 -- upvalues: u101 (ref), Resolve (val), Format (val), Derive (val)
    local WinRate = u101 and u101:FindFirstChild("WinRate")
    if WinRate then
        Resolve.SetRow(WinRate, "Header", "WINS RATE", Format.Percent(a1.MatchesWon, a1.MatchesPlayed))
        local MoreInfo = WinRate:FindFirstChild("MoreInfo")
        local Info = MoreInfo and MoreInfo:FindFirstChild("Info")
        if Info then
            Resolve.SetRow(Info, "Played", "PLAYED", Format.Number(a1.MatchesPlayed))
            Resolve.SetRow(Info, "Won", "WON", Format.Number(a1.MatchesWon))
            Resolve.SetRow(Info, "Lost", "LOST", Format.Number(a1.MatchesLost))
            Resolve.SetRow(Info, "Tied", "TIED", Format.Number(a1.MatchesTied))
            Resolve.SetRow(Info, "Clutch", "CLUTCHES 1V1", Format.Number(a1.Clutches))
            Resolve.SetRow(Info, "FlawlessRounds", "FLAWLESS ROUNDS", Format.Number(a1.FlawlessRounds))
            Resolve.SetRow(Info, "MVP", "MVPS", Format.Number(a1.RoundMVPs))
            Resolve.SetRow(Info, "Ace", "ACE ROUNDS", Format.Number(a1.AceRounds))
            Resolve.SetRow(Info, "OvertimeWins", "OVERTIME WINS", Format.Number(a1.OvertimeWins))
        end
    end
    local KD = u101 and u101:FindFirstChild("KD")
    if KD then
        Resolve.SetRow(KD, "Header", "K/D RATIO", Format.Decimal(Derive.KillDeath(a1), 2))
        local MoreInfo_2 = KD:FindFirstChild("MoreInfo")
        local Info_2 = MoreInfo_2 and MoreInfo_2:FindFirstChild("Info")
        if Info_2 then
            Resolve.SetRow(Info_2, "Kills", "KILLS", Format.Number(a1.Kills))
            Resolve.SetRow(Info_2, "Deaths", "DEATHS", Format.Number(a1.Deaths))
            Resolve.SetRow(Info_2, "Assists", "ASSISTS", Format.Number(a1.Assists))
            Resolve.SetRow(Info_2, "HeadshotKills", "HEADSHOT KILLS", Format.Number(a1.HeadshotKills))
            Resolve.SetRow(Info_2, "Kast", "KAST", Format.Share(Derive.Kast(a1), 1))
            Resolve.SetRow(Info_2, "ACS", "ACS", Format.Decimal(Derive.CombatScore(a1), 1))
            Resolve.SetRow(Info_2, "ADR", "ADR", Format.Decimal(Derive.AverageDamage(a1), 1))
            Resolve.SetRow(Info_2, "DamageDelta", "DAMAGE DELTA TOTAL", Format.Signed(Derive.DamageDelta(a1), 1))
            Resolve.SetRow(Info_2, "Kill/Round", "KILL/ROUND", Format.Decimal(Derive.Divide(a1.Kills, a1.RoundsPlayed), 2))
        end
    end
end

local function PopulateLoadout(a1) -- Line: 367
    -- upvalues: u102 (ref), GetOrderedLabels (val), u95 (val), CareerData (val), Resolve (val), u85 (val), Format (val)
    -- upvalues: Derive (val)
    local v1, v2, v3, v4
    if not u102 then
        return
    end
    local Header = u102:FindFirstChild("Header")
    if Header then
        local v5
        local v6 = GetOrderedLabels(Header)
        for i, v in ipairs(u95) do
            v5 = v6[i]
            if v5 then
                v5.Text = v
            end
        end
    end
    local MoreInfo = u102:FindFirstChild("MoreInfo")
    local Info = MoreInfo and MoreInfo:FindFirstChild("Info")
    if not Info then
        return
    end
    for i2, i3 in ipairs(CareerData.EconomyTiers) do
        v4 = Resolve.Row(Info, i3, string.upper(i3))
        if v4 then
            v1 = a1.Economy[i3]
            if v1 then
                v2 = GetOrderedLabels(v4)
                for i4, j in ipairs({
                    string.upper(i3),
                    u85[i3] or "",
                    Format.Ratio(v1.Kills, v1.Deaths),
                    Format.Decimal(Derive.Divide(v1.DamageDealt, v1.RoundsPlayed), 1),
                    Format.Percent(v1.KastRounds, v1.RoundsPlayed, 1),
                    Format.Percent(v1.RoundsWon, v1.RoundsPlayed),
                    Format.Number(v1.Kills),
                    (Format.Number(v1.Deaths)),
                }) do
                    v3 = v2[i4]
                    if v3 then
                        v3.Text = j
                    end
                end
            end
        end
    end
end

local function IsShown(a1) -- Line: 425 -- upvalues: u99 (ref) -- types: a1: userdata
    local Parent = a1
    while Parent do
        if Parent == u99 then
            break
        end
        if Parent:IsA("GuiObject") and not Parent.Visible then
            return false
        end
        Parent = Parent.Parent
    end
    return true
end

local function GetHeaderIcon(a1) -- Line: 441
    local Header = a1 and a1:FindFirstChild("Header")
    local Icon = Header and Header:FindFirstChild("Icon")
    if Icon and Icon:IsA("GuiButton") then
        return Icon
    end
    return nil
end

local function SetSelectionLink(a1, a2, a3) -- Line: 450 -- types: a1: userdata?, a2: string, a3: userdata?
    if a1 then
        a1[a2] = a3
    end
end

local function LinkSelection() -- Line: 458
    -- upvalues: IsShown (val), u101 (ref), u100 (ref), u102 (ref), CareerData (val), Resolve (val), u104 (ref)
    -- upvalues: u97 (ref), u98 (ref), u103 (ref), u96 (ref), u105 (ref)
    local v1, v2, v3, v4, v5
    local u289 = {}

    local function AddRow(...) -- Line: 462 -- upvalues: IsShown (upval), u289 (val)
        local v1, v2
        local v3 = {}
        for i = 1, (select("#", ...)) do
            v1 = select(i, ...)
            if v1 and v1:IsA("GuiObject") then
                v2 = IsShown(v1)
                v1.Selectable = v2
                if v2 then
                    table.insert(v3, v1)
                end
            end
        end
        if #v3 > 0 then
            table.insert(u289, v3)
        end
    end

    local KD = u101 and u101:FindFirstChild("KD")
    AddRow(u101 and u101:FindFirstChild("WinRate"), KD)
    local T = u100 and u100:FindFirstChild("T")
    AddRow(u100 and u100:FindFirstChild("CT"), T)
    local MoreInfo = u102 and u102:FindFirstChild("MoreInfo")
    local Info = MoreInfo and MoreInfo:FindFirstChild("Info")
    if Info then
        for i, v in ipairs(CareerData.EconomyTiers) do
            AddRow(Resolve.Row(Info, v, string.upper(v)))
        end
    end
    for i2, i3 in ipairs(u289) do
        v5 = u289[i2 - 1]
        v1 = u289[i2 + 1]
        for i4, j in ipairs(i3) do
            j.NextSelectionLeft = i3[i4 - 1]
            j.NextSelectionRight = i3[i4 + 1]
            v3 = v5
            if v3 then
                v4 = #v5
                v3 = v5[math.min(i4, v4)]
            end
            j.NextSelectionUp = v3
            v3 = v1
            if v3 then
                v4 = #v1
                v3 = v1[math.min(i4, v4)]
            end
            j.NextSelectionDown = v3
        end
    end
    local v6 = u289[1]
    u104 = v6 and v6[1]
    local v7 = u97
    local Header = v7 and v7:FindFirstChild("Header")
    local Icon = Header and Header:FindFirstChild("Icon")
    local v8 = if not Icon then nil else if not Icon:IsA("GuiButton") then nil else Icon
    local v9 = u98
    local Header_2 = v9 and v9:FindFirstChild("Header")
    local Icon_2 = Header_2 and Header_2:FindFirstChild("Icon")
    v7 = if not Icon_2 then nil else if not Icon_2:IsA("GuiButton") then nil else Icon_2
    v9 = u104
    if v9 then
        if v8 then
            v8.NextSelectionRight = v9
        end
        if v7 then
            v7.NextSelectionRight = v9
        end
        if u103 and u103:IsA("GuiObject") then
            v9.NextSelectionUp = u103
        end
    end
    for i5, k in ipairs(u289) do
        v2 = i5 ~= 1 and v7 or v8
        if v2 then
            k[1].NextSelectionLeft = v2
        end
    end
    local Visible = false
    if u96 ~= nil then
        Visible = u96.Visible
    end
    v5 = u105
    v1 = if not Visible then nil else v9
    if v5 then
        v5.NextSelectionDown = v1
    end
    v5 = u103
    v1 = u105
    if v5 then
        v5.NextSelectionUp = v1
    end
    local DropdownContent = u103 and u103:FindFirstChild("DropdownContent")
    local Visible_2 = DropdownContent and DropdownContent:IsA("GuiObject") and DropdownContent.Visible
    if u103 and u103:IsA("GuiObject") and not Visible_2 then
        u103.NextSelectionDown = u104
    end
end

local function SetDropdownOpen(a1) -- Line: 553 -- upvalues: u103 (ref), u104 (ref) -- types: a1: boolean
    local DropdownContent = u103 and u103:FindFirstChild("DropdownContent")
    if DropdownContent and DropdownContent:IsA("GuiObject") then
        DropdownContent.Visible = a1
    end
    local Container = u103 and u103:FindFirstChild("Container") and u103.Container:FindFirstChild("Left") and u103.Container.Left:FindFirstChild("Reverse")
    if Container and Container:IsA("GuiObject") then
        Container.Rotation = if not a1 then 0 else 180
    end
    if u103 and u103:IsA("GuiObject") then
        u103.NextSelectionDown = if not a1 then u104 else nil
    end
end

local function BindDropdown() -- Line: 575 -- upvalues: u103 (ref), SetDropdownOpen (val), Selection (val)
    if not u103 then
        return
    end
    local DropdownContent = u103:FindFirstChild("DropdownContent")
    local Scroll = DropdownContent and DropdownContent:FindFirstChild("Scroll")
    if not Scroll then
        return
    end
    SetDropdownOpen(false)
    if u103:IsA("GuiButton") then
        u103.Activated:Connect(function() -- Line: 589 -- upvalues: DropdownContent (val), SetDropdownOpen (upval)
            local Visible = DropdownContent:IsA("GuiObject") and DropdownContent.Visible
            SetDropdownOpen(not Visible)
        end)
    end
    for i, v in ipairs(Scroll:GetChildren()) do
        if v:IsA("GuiButton") then
            local Name = v.Name
            if Selection.Names[Name] ~= nil then
                v.Activated:Connect(function() -- Line: 605 -- upvalues: SetDropdownOpen (upval), Selection (upval), Name (val)
                    SetDropdownOpen(false)
                    Selection.Set(Name)
                end)
            end
        end
    end
end

function v1.Bind(a1) -- Line: 615
    -- upvalues: u96 (ref), u97 (ref), u98 (ref), u99 (ref), u100 (ref), u101 (ref), u102 (ref), u103 (ref), u106 (ref)
    -- upvalues: BindDropdown (val)
    u96 = a1
    u97 = a1:FindFirstChild("Profile")
    u98 = a1:FindFirstChild("Accuracy")
    u99 = a1:FindFirstChild("LifetimeStats")
    local Container = u99 and u99:FindFirstChild("Container")
    local TeamStats = Container and Container:FindFirstChild("TeamStats")
    u100 = TeamStats and TeamStats:FindFirstChild("Team")
    u101 = Container and Container:FindFirstChild("KillStats")
    u102 = Container and Container:FindFirstChild("Loadout")
    u103 = u99 and u99:FindFirstChild("Filter")
    u106 = {}
    local Pins = u97 and u97.Info:FindFirstChild("Pins")
    if Pins then
        for i, v in ipairs(Pins:GetChildren()) do
            if v:IsA("ImageLabel") then
                table.insert(u106, v)
            end
        end
        table.sort(u106, function(a1, a2) -- Line: 636 -- types: a1: userdata, a2: userdata
            return a1.Position.X.Scale < a2.Position.X.Scale
        end)
    end
    BindDropdown()
end

function v1.BindTab(a1) -- Line: 647 -- upvalues: u105 (ref), LinkSelection (val) -- types: a1: userdata?
    u105 = a1
    LinkSelection()
end

function v1.RefreshSelection() -- Line: 655 -- upvalues: LinkSelection (val)
    LinkSelection()
end

function v1.Render() -- Line: 661
    -- upvalues: Selection (val), CareerData (val), u99 (ref), u103 (ref), u97 (ref), PopulateProfile (val), u98 (ref)
    -- upvalues: PopulateAccuracy (val), u100 (ref), u102 (ref), PopulateSide (val), PopulateLoadout (val)
    -- upvalues: PopulateKillStats (val), LinkSelection (val)
    local v1 = Selection.Get()
    local v2 = CareerData.GetBucket(v1)
    if u99 then
        local Title = u99:FindFirstChild("Title")
        local Title_2 = Title and Title:FindFirstChild("Title")
        if Title_2 then
            Title_2.Text = Selection.Headings[v1] or "LIFETIME STATS"
        end
        local Container = u103 and u103:FindFirstChild("Container") and u103.Container:FindFirstChild("Left") and u103.Container.Left:FindFirstChild("Title")
        if Container then
            Container.Text = Selection.Names[v1] or "All Gamemodes"
        end
    end
    if u97 then
        PopulateProfile(v2)
    end
    if u98 then
        PopulateAccuracy(v2)
    end
    local v3 = Selection.HasRounds(v1)
    local Parent = u100 and u100.Parent
    if Parent then
        Parent.Visible = v3
    end
    if u102 then
        u102.Visible = v3
    end
    if v3 then
        PopulateSide(v2, "CT", "Counter-Terrorists")
        PopulateSide(v2, "T", "Terrorists")
        PopulateLoadout(v2)
    end
    PopulateKillStats(v2)
    LinkSelection()
end

return v1