-- ReplicatedStorage.Interface.Screens.Menu.Gamemodes.ServerBrowser
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Gamemodes.ServerBrowser
-- Decompile time: 15.37 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local ServerBrowser = require(ReplicatedStorage.Database.Components.ServerBrowser)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps
local ServerTemplate = ReplicatedStorage.Assets.UI.ServerBrowser.ServerTemplate
local u54 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u59 = Color3.fromRGB(120, 255, 127)
local u70 = table.freeze({Transparency = 0.25, BlurRadius = UDim.new(0, 14), Spread = UDim2.fromOffset(6, 6)})
local u81 = table.freeze({Transparency = 1, BlurRadius = UDim.new(0, 0), Spread = UDim2.fromOffset(0, 0)})
local u90 = table.freeze({"Map", "Players", "Score", "Region", "ServerUptime", "ServerId"})
local u93 = table.freeze({casual = "CASUAL", competitive = "COMPETITIVE", deathmatch = "DEATHMATCH", trading = "TRADING"})
local u94 = nil
local u95 = ""
local u96 = false
local u97 = nil
local u98 = 0
local u99 = 0
local u100 = 0
local u101 = false
local u102 = {}
local u103 = {}
local u104 = {}
local u105 = {}
local u106 = {}
local u107 = nil
local u108 = nil
local u109 = nil
local u110 = nil
local u111 = nil

local function CommaNumber(a1) -- Line: 89 -- types: a1: number
    return (tostring((math.max(math.floor(a1), 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local function GetGamemodeLabel(a1) -- Line: 97 -- upvalues: u93 (val)
    return u93[a1.GameMode] or string.upper((tostring(a1.GameMode)))
end

local function GetMapName(a1) -- Line: 103
    local GameModeData = a1.GameModeData
    return GameModeData and GameModeData.MapName or ""
end

local function GetMapIcon(a1) -- Line: 110 -- upvalues: u106 (val), Maps (val) -- types: a1: string
    if a1 == "" then
        return nil
    end
    local v1 = u106[a1]
    if v1 then
        return v1
    end
    local v2 = Maps:FindFirstChild(a1)
    local Icon = nil
    if v2 and v2:IsA("ModuleScript") then
        local success, result = pcall(require, v2)
        if success and typeof(result) == "table" then
            Icon = result.Icon
        end
    end
    if Icon then
        u106[a1] = Icon
    end
    return Icon
end

local function FormatScore(a1) -- Line: 139
    local GameModeData = a1.GameModeData
    local Scores = GameModeData and GameModeData.Scores
    if not Scores then
        return "--"
    end
    return (("<font color=\"rgb(219,199,126)\">%*</font> - <font color=\"rgb(165,183,212)\">%*</font>"):format(Scores.T or 0, Scores.CT or 0))
end

local function FormatUptime(a1) -- Line: 153 -- types: a1: string?
    if a1 and a1 ~= "" then
        local success, result = pcall(DateTime.fromIsoDate, a1)
        if success and result then
            local v1 = math.max(DateTime.now().UnixTimestamp - result.UnixTimestamp, 0)
            return string.format("%02d:%02d:%02d", v1 // 3600, v1 % 3600 // 60, v1 % 60)
        end
        return "--"
    end
    return "--"
end

local function GetFriendInServer(a1) -- Line: 169 -- upvalues: u104 (val)
    local v1
    for i, j in a1.Players do
        v1 = u104[j.UserId]
        if v1 then
            return v1
        end
    end
    return nil
end

local function IsCategorySelected(a1, a2) -- Line: 183 -- upvalues: u97 (ref) -- types: a1: string, a2: string
    local v1 = u97 and u97[a1]
    if not v1 then
        return true
    end
    local v2 = string.lower(a2)
    for i, j in v1 do
        if string.lower(j) == v2 then
            return true
        end
    end
    return false
end

local function MatchesFilters(a1) -- Line: 200
    -- upvalues: IsCategorySelected (val), u96 (ref), u104 (val), u95 (ref), ServerBrowser (val), u93 (val)
    local GameModeData_2, MapName_2, concat, lower, v1, v2, v3, v4
    if not IsCategorySelected("gameModes", (tostring(a1.GameMode))) then
        return false
    end
    local GameModeData = a1.GameModeData
    local MapName = GameModeData and GameModeData.MapName or ""
    if MapName ~= "" and not IsCategorySelected("maps", MapName) then
        return false
    end
    if u96 then
        v1 = nil
        v2 = nil
        for i, j in a1.Players, v1, v2 do
            v4 = u104[j.UserId]
            if v4 then
                if not v4 then
                    return false
                end
                if u95 == "" then
                    return true
                end
                lower = string.lower
                concat = table.concat
                v1 = {}
                v2 = ServerBrowser.GetServerNameFromMatchId(a1.MatchId)
                GameModeData_2 = a1.GameModeData
                MapName_2 = GameModeData_2 and GameModeData_2.MapName or ""
                v3 = a1.Region or ""
                v4 = u93[a1.GameMode] or string.upper((tostring(a1.GameMode)))
                v1[1] = v2
                v1[2] = MapName_2
                v1[3] = v3
                v1[4] = v4
                return string.find(lower((concat(v1, " "))), u95, 1, true) ~= nil
            end
        end
        if true then
            return false
        end
    end
    if u95 == "" then
        return true
    end
    lower = string.lower
    concat = table.concat
    v1 = {}
    v2 = ServerBrowser.GetServerNameFromMatchId(a1.MatchId)
    GameModeData_2 = a1.GameModeData
    MapName_2 = GameModeData_2 and GameModeData_2.MapName or ""
    v3 = a1.Region or ""
    v4 = u93[a1.GameMode] or string.upper((tostring(a1.GameMode)))
    v1[1] = v2
    v1[2] = MapName_2
    v1[3] = v3
    v1[4] = v4
    return string.find(lower((concat(v1, " "))), u95, 1, true) ~= nil
end

local function RequestTeleport(a1) -- Line: 230 -- upvalues: u98 (ref), Remotes (val) -- types: a1: string
    local v1 = os.clock()
    if v1 - u98 < 1.1 then
        return
    end
    u98 = v1
    Remotes.ServerBrowser.Teleport.Send(a1)
end

local function SetDetailValue(a1, a2) -- Line: 242 -- upvalues: u103 (val) -- types: a1: string, a2: string
    local v1 = u103[a1]
    if v1 then
        v1.Text = a2
    end
end

local function RefreshFriendTag(a1) -- Line: 251
    -- upvalues: u109 (ref), u104 (val), u99 (ref), u105 (val), Players (val)
    local FriendTag = u109.FriendTag
    local u3 = nil
    for i, j in a1.Players do
        if u104[j.UserId] then
            u3 = j
            break
        end
    end
    u99 = u99 + 1
    local u20 = u99
    if not u3 then
        FriendTag.Visible = false
        return
    end
    FriendTag.Visible = true
    FriendTag.Username.Text = ("%* in Server"):format(u3.Username)
    local Avatar = FriendTag.Player.Avatar
    local v1 = u105[u3.UserId]
    if v1 then
        Avatar.Image = v1
        return
    end
    Avatar.Image = ""
    task.spawn(function() -- Line: 282 -- upvalues: Players (upval), u3 (ref), u105 (upval), u20 (val), u99 (upval), Avatar (val)
        local success, result = pcall(Players.GetUserThumbnailAsync, Players, u3.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if success and result then
            u105[u3.UserId] = result
            if u20 == u99 then
                Avatar.Image = result
            end
            return
        end
    end)
end

local function GetSelectionShadow(a1) -- Line: 304 -- upvalues: u59 (val), u81 (val) -- types: a1: userdata
    local SelectionShadow = a1:FindFirstChild("SelectionShadow")
    if SelectionShadow and SelectionShadow:IsA("UIShadow") then
        return SelectionShadow
    end
    local UIShadow = Instance.new("UIShadow")
    UIShadow.Name = "SelectionShadow"
    UIShadow.Color = u59
    UIShadow.Transparency = u81.Transparency
    UIShadow.BlurRadius = u81.BlurRadius
    UIShadow.Spread = u81.Spread
    UIShadow.Parent = a1
    return UIShadow
end

local function TweenRowSelection(a1, a2) -- Line: 322
    -- upvalues: TweenService (val), u59 (val), u81 (val), u54 (val), u70 (val)
    local v1
    local SelectionShadow = a1:FindFirstChild("SelectionShadow")
    if not SelectionShadow or not SelectionShadow:IsA("UIShadow") then
        local UIShadow = Instance.new("UIShadow")
        UIShadow.Name = "SelectionShadow"
        UIShadow.Color = u59
        UIShadow.Transparency = u81.Transparency
        UIShadow.BlurRadius = u81.BlurRadius
        UIShadow.Spread = u81.Spread
        UIShadow.Parent = a1
        v1 = UIShadow
    else
        v1 = SelectionShadow
    end
    TweenService:Create(v1, u54, if not a2 then u81 else u70):Play()
end

local function ClearSelection() -- Line: 332
    -- upvalues: u94 (ref), u109 (ref), u102 (val), TweenService (val), u59 (val), u81 (val), u54 (val)
    local SelectionShadow, UIShadow, v1
    u94 = nil
    u109.Visible = false
    local v2 = nil
    local v3 = nil
    for i, j in u102, v2, v3 do
        SelectionShadow = j:FindFirstChild("SelectionShadow")
        if not SelectionShadow or not SelectionShadow:IsA("UIShadow") then
            UIShadow = Instance.new("UIShadow")
            UIShadow.Name = "SelectionShadow"
            UIShadow.Color = u59
            UIShadow.Transparency = u81.Transparency
            UIShadow.BlurRadius = u81.BlurRadius
            UIShadow.Spread = u81.Spread
            UIShadow.Parent = j
            v1 = UIShadow
        else
            v1 = SelectionShadow
        end
        TweenService:Create(v1, u54, u81):Play()
    end
end

local function RefreshDetails() -- Line: 342
    -- upvalues: u94 (ref), u109 (ref), ServerBrowser (val), u102 (val), TweenService (val), u59 (val), u81 (val)
    -- upvalues: u54 (val), u93 (val), GetMapIcon (val), u103 (val), FormatUptime (val), RefreshFriendTag (val)
    local GameModeData_3, Scores, v1, v2
    if not u94 then
        u109.Visible = false
        return
    end
    local v3 = ServerBrowser.GetServerByMatchId(u94)
    if not v3 then
        local SelectionShadow, UIShadow, v4
        u94 = nil
        u109.Visible = false
        v1 = nil
        v2 = nil
        for i, j in u102, v1, v2 do
            SelectionShadow = j:FindFirstChild("SelectionShadow")
            if not SelectionShadow or not SelectionShadow:IsA("UIShadow") then
                UIShadow = Instance.new("UIShadow")
                UIShadow.Name = "SelectionShadow"
                UIShadow.Color = u59
                UIShadow.Transparency = u81.Transparency
                UIShadow.BlurRadius = u81.BlurRadius
                UIShadow.Spread = u81.Spread
                UIShadow.Parent = j
                v4 = UIShadow
            else
                v4 = SelectionShadow
            end
            TweenService:Create(v4, u54, u81):Play()
        end
        return
    end
    local GameModeData = v3.GameModeData
    local MapName = GameModeData and GameModeData.MapName or ""
    v1 = u93[v3.GameMode] or string.upper((tostring(v3.GameMode)))
    u109.Visible = true
    u109.Title.Title.Text = ("%* | %*"):format(string.upper(MapName), v1)
    u109.Map.Map.Image = GetMapIcon(MapName) or "rbxassetid://111859813726258"
    u109.Scroll.Score.Label.Text = if v3.GameMode ~= "trading" then "SCORE" else "RAP"
    u109.Scroll.Map.Visible = v3.GameMode ~= "trading"
    v2 = string.upper(MapName)
    local Map_2 = u103.Map
    if Map_2 then
        Map_2.Text = v2
    end
    v2 = ("%*/%*"):format(#v3.Players, v3.MaxPlayers)
    local Players = u103.Players
    if Players then
        Players.Text = v2
    end
    if v3.GameMode ~= "trading" or not v3.GameModeData.Score then
        GameModeData_3 = v3.GameModeData
        Scores = GameModeData_3 and GameModeData_3.Scores
        v2 = if Scores then ("<font color=\"rgb(219,199,126)\">%*</font> - <font color=\"rgb(165,183,212)\">%*</font>"):format(Scores.T or 0, Scores.CT or 0) else "--"
    else
        v2 = tostring((math.max(math.floor((math.floor(v3.GameModeData.Score))), 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        if not v2 then
            GameModeData_3 = v3.GameModeData
            Scores = GameModeData_3 and GameModeData_3.Scores
            v2 = if Scores then ("<font color=\"rgb(219,199,126)\">%*</font> - <font color=\"rgb(165,183,212)\">%*</font>"):format(
                Scores.T or 0,
                Scores.CT or 0
            ) else "--"
        end
    end
    local Score_2 = u103.Score
    if Score_2 then
        Score_2.Text = v2
    end
    v2 = v3.Region or "--"
    local Region = u103.Region
    if Region then
        Region.Text = v2
    end
    v2 = FormatUptime(v3.StartedAt)
    local ServerUptime = u103.ServerUptime
    if ServerUptime then
        ServerUptime.Text = v2
    end
    local MatchId = v3.MatchId
    local ServerId = u103.ServerId
    if ServerId then
        ServerId.Text = MatchId
    end
    RefreshFriendTag(v3)
end

local function SelectServer(a1) -- Line: 375
    -- upvalues: u94 (ref), RefreshDetails (val), u102 (val), TweenService (val), u59 (val), u81 (val), u54 (val)
    -- upvalues: u70 (val)
    local SelectionShadow, UIShadow, v1, v2
    u94 = a1
    RefreshDetails()
    local v3 = nil
    local v4 = nil
    for i, j in u102, v3, v4 do
        v1 = i == a1
        SelectionShadow = j:FindFirstChild("SelectionShadow")
        if not SelectionShadow or not SelectionShadow:IsA("UIShadow") then
            UIShadow = Instance.new("UIShadow")
            UIShadow.Name = "SelectionShadow"
            UIShadow.Color = u59
            UIShadow.Transparency = u81.Transparency
            UIShadow.BlurRadius = u81.BlurRadius
            UIShadow.Spread = u81.Spread
            UIShadow.Parent = j
            v2 = UIShadow
        else
            v2 = SelectionShadow
        end
        TweenService:Create(v2, u54, if not v1 then u81 else u70):Play()
    end
end

local function ApplyServerToRow(a1, a2) -- Line: 386 -- upvalues: ServerBrowser (val), u93 (val), GetMapIcon (val)
    local GameModeData = a2.GameModeData
    local MapName = GameModeData and GameModeData.MapName or ""
    a1.ServerId.Text = ServerBrowser.GetServerNameFromMatchId(a2.MatchId)
    a1.MapName.Text = string.upper(MapName)
    a1.PlayerCount.Text = ("%*/%*"):format(#a2.Players, a2.MaxPlayers)
    local Score = a1.Score
    local GameModeData_2 = a2.GameModeData
    local Scores = GameModeData_2 and GameModeData_2.Scores
    Score.Text = if Scores then ("<font color=\"rgb(219,199,126)\">%*</font> - <font color=\"rgb(165,183,212)\">%*</font>"):format(Scores.T or 0, Scores.CT or 0) else "--"
    a1.Region.Text = a2.Region or "--"
    local Gamemode = a1.Gamemode
    local v1 = u93[a2.GameMode] or string.upper((tostring(a2.GameMode)))
    Gamemode.Text = v1
    a1.MapBackground.ImageButton.Image = GetMapIcon(MapName) or ""
end

local function CreateRow(a1) -- Line: 399
    -- upvalues: ServerTemplate (val), u59 (val), u81 (val), ActivateButton (val), u94 (ref), RefreshDetails (val)
    -- upvalues: u102 (val), TweenService (val), u54 (val), u70 (val), u108 (ref)
    local v1 = ServerTemplate:Clone()
    v1.Name = a1
    local SelectionShadow = v1:FindFirstChild("SelectionShadow")
    if not SelectionShadow or not SelectionShadow:IsA("UIShadow") then
        local UIShadow = Instance.new("UIShadow")
        UIShadow.Name = "SelectionShadow"
        UIShadow.Color = u59
        UIShadow.Transparency = u81.Transparency
        UIShadow.BlurRadius = u81.BlurRadius
        UIShadow.Spread = u81.Spread
        UIShadow.Parent = v1
    end
    local Join = v1:FindFirstChild("Join")
    local v2 = {}
    local Select = v1:FindFirstChild("Select")
    v2[1] = Join
    v2[2] = Select
    v2[3] = v1.MapBackground:FindFirstChild("ImageButton")
    local v3 = nil
    local v4 = nil
    for i, j in v2, v3, v4 do
        if j and j:IsA("GuiButton") then
            if j == Join then
                ActivateButton(j)
            end
            j.MouseButton1Click:Connect(function() -- Line: 411
                -- upvalues: a1 (val), u94 (upval), RefreshDetails (upval), u102 (upval), TweenService (upval)
                -- upvalues: u59 (upval), u81 (upval), u54 (upval), u70 (upval)
                local SelectionShadow, UIShadow, v1, v2, v3
                local v4 = a1
                u94 = v4
                RefreshDetails()
                local v5 = nil
                local v6 = nil
                for i, j in u102, v5, v6 do
                    v1 = i == v4
                    v2 = TweenService
                    SelectionShadow = j:FindFirstChild("SelectionShadow")
                    if not SelectionShadow or not SelectionShadow:IsA("UIShadow") then
                        UIShadow = Instance.new("UIShadow")
                        UIShadow.Name = "SelectionShadow"
                        UIShadow.Color = u59
                        UIShadow.Transparency = u81.Transparency
                        UIShadow.BlurRadius = u81.BlurRadius
                        UIShadow.Spread = u81.Spread
                        UIShadow.Parent = j
                        v3 = UIShadow
                    else
                        v3 = SelectionShadow
                    end
                    v2:Create(v3, u54, if not v1 then u81 else u70):Play()
                end
            end)
        end
    end
    v1.Parent = u108
    return v1
end

local function RefreshList() -- Line: 423
    -- upvalues: ServerBrowser (val), MatchesFilters (val), u102 (val), CreateRow (val), ApplyServerToRow (val)
    -- upvalues: u94 (ref), RefreshDetails (val), TweenService (val), u59 (val), u81 (val), u54 (val), u70 (val)
    -- upvalues: u110 (ref), u109 (ref)
    local GameModeData, MatchId, SelectionShadow_2, UIShadow_2, v1, v2, v3, v4, v5, v6
    local v7 = {}
    for i, j in (ServerBrowser.GetActiveGameServers()) do
        if MatchesFilters(j) then
            table.insert(v7, j)
        end
    end
    table.sort(v7, function(a1, a2) -- Line: 433
        if #a1.Players == #a2.Players then
            return a1.MatchId < a2.MatchId
        end
        local v1 = #a1.Players
        return #a2.Players < v1
    end)

    local function formatRap(a1) -- Line: 440 -- types: a1: table
        local v1 = 0
        local v2 = 0
        for i, j in a1 do
            v1 = v1 + 1
            v2 = v2 + j
        end
        return v2 / v1
    end

    local v8 = {}
    local v9 = nil
    local v10 = nil
    for k, n in v7, v9, v10 do
        v8[n.MatchId] = true
        v6 = u102[n.MatchId]
        if not v6 then
            if n.GameMode == "trading" then
                GameModeData = n.GameModeData
                v2 = 0
                v3 = 0
                for m, i5 in n.GameModeData.InventoryValues do
                    v2 = v2 + 1
                    v3 = v3 + i5
                end
                GameModeData.Score = v3 / v2
            end
            v6 = CreateRow(n.MatchId)
            u102[n.MatchId] = v6
        end
        v6.LayoutOrder = k
        ApplyServerToRow(v6, n)
        if k == 1 then
            MatchId = n.MatchId
            u94 = MatchId
            RefreshDetails()
            v1 = nil
            v2 = nil
            for i6, i7 in u102, v1, v2 do
                v4 = i6 == MatchId
                SelectionShadow_2 = i7:FindFirstChild("SelectionShadow")
                if not SelectionShadow_2 or not SelectionShadow_2:IsA("UIShadow") then
                    UIShadow_2 = Instance.new("UIShadow")
                    UIShadow_2.Name = "SelectionShadow"
                    UIShadow_2.Color = u59
                    UIShadow_2.Transparency = u81.Transparency
                    UIShadow_2.BlurRadius = u81.BlurRadius
                    UIShadow_2.Spread = u81.Spread
                    UIShadow_2.Parent = i7
                    v5 = UIShadow_2
                else
                    v5 = SelectionShadow_2
                end
                TweenService:Create(v5, u54, if not v4 then u81 else u70):Play()
            end
        end
    end
    v9 = nil
    v10 = nil
    for i8, i9 in u102, v9, v10 do
        if not v8[i8] then
            i9:Destroy()
            u102[i8] = nil
        end
    end
    u110.Text = ("%* Servers"):format((tostring((math.max(math.floor(#v7), 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")))
    if u94 and not v8[u94] then
        local SelectionShadow, UIShadow, v11
        u94 = nil
        u109.Visible = false
        v9 = nil
        v10 = nil
        for i10, i11 in u102, v9, v10 do
            SelectionShadow = i11:FindFirstChild("SelectionShadow")
            if not SelectionShadow or not SelectionShadow:IsA("UIShadow") then
                UIShadow = Instance.new("UIShadow")
                UIShadow.Name = "SelectionShadow"
                UIShadow.Color = u59
                UIShadow.Transparency = u81.Transparency
                UIShadow.BlurRadius = u81.BlurRadius
                UIShadow.Spread = u81.Spread
                UIShadow.Parent = i11
                v11 = UIShadow
            else
                v11 = SelectionShadow
            end
            TweenService:Create(v11, u54, u81):Play()
        end
        return
    end
    RefreshDetails()
end

local function StepUptime(a1) -- Line: 492
    -- upvalues: u100 (ref), u94 (ref), ServerBrowser (val), FormatUptime (val), u103 (val)
    u100 = u100 + a1
    if u100 < 1 then
        return
    end
    u100 = 0
    if not u94 then
        return
    end
    local v1 = ServerBrowser.GetServerByMatchId(u94)
    if v1 then
        local v2 = FormatUptime(v1.StartedAt)
        local ServerUptime = u103.ServerUptime
        if ServerUptime then
            ServerUptime.Text = v2
        end
    end
end

local function LoadFriends() -- Line: 511
    -- upvalues: Players (val), LocalPlayer (val), u104 (val), u101 (ref), RefreshList (val)
    local success, result = pcall(Players.GetFriendsAsync, Players, LocalPlayer.UserId)
    if success and result then
        repeat
            for i, j in result:GetCurrentPage() do
                u104[j.Id] = j.Username
            end
        until result.IsFinished
            or not pcall(function() -- Line: 525 -- upvalues: result (val)
                local v0, v1
                result:AdvanceToNextPageAsync()
                return
            end)
        if u101 then
            RefreshList()
        end
        return
    end
end

local function ToggleFriendsOnly() -- Line: 541 -- upvalues: u96 (ref), u111 (ref), RefreshList (val)
    u96 = not u96
    if u111 then
        u111.Visible = u96
    end
    RefreshList()
end

function v1.SetCategoryFilters(a1) -- Line: 553
    -- upvalues: u97 (ref), u101 (ref), RefreshList (val)
    u97 = a1
    if u101 then
        RefreshList()
    end
end

function v1.SetActive(a1) -- Line: 562
    -- upvalues: u101 (ref), u100 (ref), u107 (ref), RunServiceController (val), StepUptime (val), RefreshList (val)
    if a1 == u101 then
        return
    end
    u101 = a1
    if a1 then
        u100 = 0
        u107 = RunServiceController.BindToHeartbeat("UI.ServerBrowser.Uptime", StepUptime)
        RefreshList()
        return
    end
    if u107 then
        u107:Disconnect()
        u107 = nil
    end
end

function v1.Initialize(a1) -- Line: 581
    -- upvalues: u108 (ref), u110 (ref), u109 (ref), u90 (val), u103 (val), u95 (ref), RefreshList (val), u111 (ref)
    -- upvalues: u96 (ref), ToggleFriendsOnly (val), ActivateButton (val), u94 (ref), u98 (ref), Remotes (val)
    local Value, v1
    local Main = a1.Main
    local Frame = Main.Frame
    u108 = Frame.Container
    u110 = Frame.Top.Title
    u109 = Main.Categories
    for i, j in u108:GetChildren() do
        if j:IsA("GuiObject") then
            j:Destroy()
        end
    end
    local v2 = nil
    local v3 = nil
    for k, n in u90, v2, v3 do
        v1 = u109.Scroll:FindFirstChild(n)
        Value = v1 and v1:FindFirstChild("Value")
        if not Value or not Value:IsA("TextLabel") then
            warn((("[ServerBrowser] Missing \"%*.Value\" label in the details panel"):format(n)))
        else
            u103[n] = Value
        end
    end
    u109.Visible = false
    local SearchBar = Frame.Top.SearchBar
    local TextBox = SearchBar:FindFirstChildWhichIsA("TextBox", true)
    if not TextBox then
        warn("[ServerBrowser] No search TextBox found, searching is disabled")
    else
        SearchBar.MouseButton1Click:Connect(function() -- Line: 612 -- upvalues: TextBox (val)
            TextBox:CaptureFocus()
        end)
        ;(TextBox:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 615 -- upvalues: u95 (upval), TextBox (val), RefreshList (upval)
            u95 = string.lower((string.gsub(TextBox.Text, "^%s*(.-)%s*$", "%1")))
            RefreshList()
        end)
    end
    local Friends = Frame.Top.Friends
    local Button = Friends:FindFirstChild("Button")
    local Check = Button and Button:FindFirstChild("Check")
    if not Check or not Check:IsA("GuiObject") then
        warn("[ServerBrowser] No \"Friends.Button.Check\" mark found, the friends only filter is disabled")
    else
        u111 = Check
        Check.Visible = u96
        Friends.MouseButton1Click:Connect(ToggleFriendsOnly)
        if Button and Button:IsA("GuiButton") then
            Button.MouseButton1Click:Connect(ToggleFriendsOnly)
        end
    end
    ActivateButton(u109.Join)
    u109.Join.MouseButton1Click:Connect(function() -- Line: 640 -- upvalues: u94 (upval), Main (val)
        if u94 then
            Main.Prompt.Visible = true
        end
    end)
    ActivateButton(Main.Prompt.Buttons.Buttons.Yes)
    Main.Prompt.Buttons.Buttons.Yes.MouseButton1Click:Connect(function() -- Line: 647 -- upvalues: u94 (upval), u98 (upval), Remotes (upval)
        if u94 then
            local v1 = u94
            local v2 = os.clock()
            if v2 - u98 < 1.1 then
                return
            end
            u98 = v2
            Remotes.ServerBrowser.Teleport.Send(v1)
        end
    end)
    ActivateButton(Main.Prompt.Buttons.Buttons.No)
    Main.Prompt.Buttons.Buttons.No.MouseButton1Click:Connect(function() -- Line: 654 -- upvalues: Main (val)
        Main.Prompt.Visible = false
    end)
end

function v1.Start() -- Line: 661 -- upvalues: LoadFriends (val), ServerBrowser (val), u101 (ref), RefreshList (val)
    task.spawn(LoadFriends)
    ServerBrowser.OnServerBrowserUpdated:Connect(function() -- Line: 664 -- upvalues: u101 (upval), RefreshList (upval)
        if u101 then
            RefreshList()
        end
    end)
end

return v1