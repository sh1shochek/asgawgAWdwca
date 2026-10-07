-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat
-- Decompile time: 14.54 ms

local ProcessMessageQueue
local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local CanPlayerUseChatService = require(ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local ChatModes = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.ChatModes)
local Platforms = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.Platforms)
local HTML = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.HTML)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
require(script:WaitForChild("Types"))
local u125 = TweenInfo.new(3, Enum.EasingStyle.Linear)
local u126 = nil
local u127 = nil
local u128 = {Platforms.PC}
local All = ChatModes.Modes.All
local u132 = false
local u133 = false
local u134 = 0
local u135 = {}
local u136 = {}
local u137 = nil

local function IsSystemChatMessagesEnabled() -- Line: 77 -- upvalues: DataController (val), LocalPlayer (val)
    return DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false
end

local function EscapeRichText(a1) -- Line: 81 -- types: a1: string
    return (((a1:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))
end

local function ColorToRGB(a1) -- Line: 85 -- types: a1: Vector2
    return string.format("rgb(%d,%d,%d)", math.floor(a1.R * 255 + 0.5), math.floor(a1.G * 255 + 0.5), (math.floor(a1.B * 255 + 0.5)))
end

local function IsCompetitiveServerGamemode() -- Line: 92
    return workspace:GetAttribute("ServerGamemode") == "Competitive"
end

local function GetChatNameColorFormat(a1) -- Line: 96 -- upvalues: HTML (val)
    return HTML.TeamColors[a1.team] or ""
end

local function IsMobilePlatform() -- Line: 100 -- upvalues: u128 (ref), Platforms (val)
    return table.find(u128, Platforms.Mobile) ~= nil
end

local function FormatAnnouncerName(a1, a2) -- Line: 105 -- upvalues: HTML (val) -- types: a2: string
    local v1 = HTML.TeamColors[a1] or ""
    local v2 = ((a2:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
    if v1 ~= "" then
        return (string.format(v1, v2))
    end
    return v2 .. " "
end

local function GetPlaceholderText() -- Line: 111 -- upvalues: u128 (ref), Platforms (val), InputController (val)
    if table.find(u128, Platforms.Mobile) ~= nil then
        return "Tap to chat"
    end
    if not table.find(u128, Platforms.Console) and not table.find(u128, Platforms.VR) then
        return string.format(
            "Team Chat (%s) | All Chat (%s)",
            InputController.GetActionKeybind("Team Message") or "U",
            InputController.GetActionKeybind("Chat Message") or "Y"
        )
    end
    return ""
end

local function OpenChatFrame(a1) -- Line: 128 -- upvalues: Profiler (val), u133 (ref), TweenService (val), u125 (val)
    Profiler.mark("UI.Chat.OpenChatFrame")
    if a1.frame and a1.frame.Parent then
        if not u133 and not a1.fadeConnection and not (1 <= a1.frame.Message.TextTransparency) then
            local u21 = TweenService:Create(a1.frame.Message, u125, {TextTransparency = 1})
            local u22 = {}

            function u22.Disconnect() -- Line: 142 -- upvalues: u21 (val)
                u21:Cancel()
            end

            u21.Completed:Once(function() -- Line: 146 -- upvalues: a1 (val), u22 (val)
                if a1.fadeConnection == u22 then
                    a1.fadeConnection = nil
                end
            end)
            a1.fadeConnection = u22
            u21:Play()
            return
        end
        return
    end
end

local function SetChatActive(a1) -- Line: 155
    -- upvalues: u133 (ref), u127 (ref), GetPlaceholderText (val), u135 (val), OpenChatFrame (val)
    local v1
    u133 = a1
    local v2 = if not a1 then 1 else 0
    u127.Chat.ScrollingFrame.ScrollBarImageTransparency = v2
    v2 = if not a1 then 1 else 0.55
    u127.Chat.BackgroundTransparency = v2
    v2 = if not a1 then 1 else 0.55
    u127.Type.BackgroundTransparency = v2
    u127.BackgroundTransparency = if not a1 then 1 else 0.55
    local TextBox = u127.Type.TextBox
    v2 = a1 and Color3.fromRGB(141, 141, 141) or Color3.new(1, 1, 1)
    TextBox.PlaceholderColor3 = v2
    if not a1 then
        u127.Type.TextBox.PlaceholderText = GetPlaceholderText()
    end
    local v3 = os.clock()
    for i, v in ipairs(u135) do
        if not a1 then
            v1 = v3 - v.timestamp
            if not (v1 > 10) then
                task.delay(10 - v1, OpenChatFrame, v)
            else
                v.frame.Message.TextTransparency = 1
            end
        else
            if v.fadeConnection then
                v.fadeConnection:Disconnect()
                v.fadeConnection = nil
            end
            v.frame.Message.TextTransparency = 0
        end
    end
end

local function CloseChat() -- Line: 188
    -- upvalues: u133 (ref), LocalPlayer (val), MenuState (val), u128 (ref), Platforms (val), CameraController (val)
    -- upvalues: u127 (ref), SetChatActive (val), u134 (ref)
    if not u133 then
        return
    end
    LocalPlayer:SetAttribute("IsPlayerChatting", nil)
    local MainGui = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Menu")
    local Visible = MainGui and MainGui.Visible
    local v1 = MenuState.IsCaseSceneActive()
    local v2 = MenuState.IsInspectActive()
    if not Visible and not v1 and not v2 and not (table.find(u128, Platforms.Mobile) ~= nil) then
        CameraController.setMouseEnabled(false)
    end
    u127.Type.TextBox:ReleaseFocus()
    u127.Type.TextBox.TextTransparency = 1
    u127.Type.TextBox.Text = ""
    SetChatActive(false)
    u134 = os.clock()
    if table.find(u128, Platforms.Mobile) ~= nil then
        u127.Visible = false
    end
end

local function AddMessageToUI(a1) -- Line: 217
    -- upvalues: u135 (val), u133 (ref), OpenChatFrame (val), u127 (ref), Profiler (val)
    local v1 = #u135
    if v1 >= 15 then
        v1 = u135[15]
        if v1 then
            v1.frame:Destroy()
            table.remove(u135, 15)
        end
    end
    table.insert(u135, 1, a1)
    for i, v in ipairs(u135) do
        v.frame.LayoutOrder = #u135 - i
    end
    a1.frame.Message.TextTransparency = 0
    if not u133 then
        task.delay(10, OpenChatFrame, a1)
    end
    a1.frame.Parent = u127.Chat.ScrollingFrame
    Profiler.defer("UI.Chat.ScrollToBottomDeferred", function() -- Line: 242 -- upvalues: u127 (upval)
        u127.Chat.ScrollingFrame.CanvasPosition = Vector2.new(0, u127.Chat.ScrollingFrame.AbsoluteCanvasSize.Y)
    end)
end

function ProcessMessageQueue() -- Line: 248
    -- upvalues: Profiler (val), u132 (ref), u136 (val), u137 (ref), u126 (ref), AddMessageToUI (val)
    -- upvalues: RunServiceController (val), ProcessMessageQueue (val)
    Profiler.mark("UI.Chat.ProcessMessageQueue")
    if not u132 and #u136 ~= 0 then
        local v1, v2
        local v3 = 0
        u132 = true
        while true do
            if not (#u136 > 0) or not (v3 < 2) then
                break
            end
            v1 = table.remove(u136, 1)
            if v1 then
                v2 = u126:Clone()
                v2.Message.Text = v1.text
                AddMessageToUI({frame = v2, timestamp = v1.timestamp, text = v1.text})
                v3 = v3 + 1
            end
        end
        u132 = false
        if #u136 == 0 and u137 then
            u137:Disconnect()
            u137 = nil
            return
        end
        if #u136 > 0 and not u137 then
            u137 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 281 -- upvalues: Profiler (upval), ProcessMessageQueue (upval)
                Profiler.mark("UI.Chat.Heartbeat")
                ProcessMessageQueue()
            end)
        end
        return
    end
    if #u136 == 0 and u137 then
        u137:Disconnect()
        u137 = nil
    end
end

local function QueueMessage(a1) -- Line: 288
    -- upvalues: Profiler (val), u136 (val), u132 (ref), ProcessMessageQueue (val)
    Profiler.mark("UI.Chat.QueueMessage")
    table.insert(u136, {text = a1, timestamp = os.clock()})
    if not u132 then
        ProcessMessageQueue()
    end
end

function u0.OpenChat(a1) -- Line: 303
    -- upvalues: Profiler (val), u133 (ref), CanPlayerUseChatService (val), LocalPlayer (val), BuyMenu (val), All (ref)
    -- upvalues: u127 (ref), ChatModes (val), SetChatActive (val), u128 (ref), Platforms (val), CameraController (val)
    Profiler.mark("UI.Chat.OpenChat")
    if not u133 and CanPlayerUseChatService(LocalPlayer) then
        BuyMenu.closeFrame()
        All = a1
        u127.Visible = true
        u127.Type.TextBox.PlaceholderText = ChatModes.Labels[a1]
        u127.Type.TextBox.TextTransparency = 0
        u127.Type.TextBox.Text = ""
        SetChatActive(true)
        if not (table.find(u128, Platforms.Mobile) ~= nil) then
            CameraController.setMouseEnabled(true)
        end
        LocalPlayer:SetAttribute("IsPlayerChatting", true)
        u127.Type.TextBox:CaptureFocus()
        task.delay(0, function() -- Line: 328 -- upvalues: u127 (upval)
            u127.Type.TextBox.Text = ""
        end)
        return
    end
end

function u0.CloseChat() -- Line: 333 -- upvalues: CloseChat (val)
    CloseChat()
end

function u0.ToggleChat(a1) -- Line: 337 -- upvalues: u133 (ref), u134 (ref), CloseChat (val), u0 (val)
    if not u133 and not (os.clock() - u134 < 0.25) then
        u0.OpenChat(a1)
        return
    end
    CloseChat()
end

function u0.ProcessChatData(a1, a2) -- Line: 346
    -- upvalues: Profiler (val), HTML (val), QueueMessage (val)
    Profiler.mark("UI.Chat.ProcessChatData")
    QueueMessage((if not a1.role then "" else if not HTML.Roles[a1.role] then "" else HTML.Roles[a1.role]) .. (a2 and HTML.Prefixes[a1.team] or HTML.Prefixes.All) .. (string.format(HTML.TeamColors[a1.team] or "", (((a1.displayName:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")))) .. (if not a1.verified then "" else HTML.Badges.Verified .. " ") .. (if a1.alive then "" else HTML.Suffixes.Dead) .. ": " .. a1.message)
end

function u0.ProcessTeamJoin(a1, a2) -- Line: 360 -- upvalues: HTML (val), QueueMessage (val) -- types: a1: string
    local v1 = HTML.TeamJoinMessages[a2]
    if not v1 then
        return
    end
    QueueMessage(string.format(v1, a1))
end

function u0.ProcessPlayerLeave(a1) -- Line: 368 -- upvalues: QueueMessage (val), HTML (val) -- types: a1: string
    QueueMessage(string.format(HTML.PlayerLeave, a1))
end

function u0.ProcessPlayerBanned(a1) -- Line: 372 -- upvalues: QueueMessage (val), HTML (val) -- types: a1: string
    QueueMessage(string.format(HTML.PlayerBanned, a1))
end

function u0.ProcessSystemMessage(a1) -- Line: 376 -- upvalues: QueueMessage (val), HTML (val) -- types: a1: string
    QueueMessage(string.format(HTML.SystemMessage, (((a1:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))))
end

function u0.ProcessTeamDamage(a1) -- Line: 380 -- upvalues: QueueMessage (val), HTML (val)
    if a1.messageType == "Warning" then
        QueueMessage(HTML.TeamDamageWarning)
        return
    end
    if a1.messageType == "Announcement" then
        QueueMessage(string.format(HTML.TeamDamageAnnouncement, (((a1.displayName:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))))
    end
end

function u0.ProcessKillMessage(a1) -- Line: 391
    -- upvalues: Profiler (val), LocalPlayer (val), QueueMessage (val), HTML (val)
    Profiler.mark("UI.Chat.ProcessKillMessage")
    local v1 = tostring(a1.Killer)
    if v1 == tostring(LocalPlayer.UserId) then
        v1 = a1.Points or 11
        QueueMessage(string.format(HTML.Points.Deathmatch, v1, if v1 ~= 1 then "points" else "point", a1.Weapon))
    end
end

function u0.ProcessMoneyReward(a1) -- Line: 400 -- upvalues: HTML (val), QueueMessage (val)
    local v1 = HTML.Money[a1.source]
    if not v1 then
        return
    end
    local v2 = tonumber(a1.amount)
    if not v2 then
        return
    end
    if a1.source ~= "Kill" then
        QueueMessage(string.format(v1, (math.abs(v2))))
        return
    end
    local KillWithWeapon = a1.weaponName and HTML.Money.KillWithWeapon or HTML.Money.Kill
    QueueMessage(a1.weaponName and string.format(KillWithWeapon, v2, a1.weaponName) or string.format(KillWithWeapon, v2))
end

function u0.ProcessDefuseStart(a1) -- Line: 423 -- upvalues: HTML (val), QueueMessage (val)
    local team = a1.team
    local displayName = a1.displayName
    local v1 = HTML.TeamColors[team] or ""
    local v2 = ((displayName:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
    local v3 = if v1 == "" then v2 .. " " else string.format(v1, v2)
    QueueMessage((HTML.Prefixes[a1.team] or HTML.Prefixes.All) .. v3 .. (string.format(
        "<font color=\"%s\">@%s</font>",
        HTML.DefuseStartLocationColor,
        (((("Bombsite " .. (a1.site or "?")):gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))
    )) .. "<font color=\"rgb(255,255,255)\">: </font>" .. HTML.DefuseStartAction)
end

function u0.ProcessGrenadeThrow(a1) -- Line: 434 -- upvalues: HTML (val), QueueMessage (val)
    local team = a1.team
    local displayName = a1.displayName
    local v1 = HTML.TeamColors[team] or ""
    local v2 = ((displayName:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
    local All = HTML.Prefixes[a1.team] or HTML.Prefixes.All
    local v3 = HTML.GrenadeDisplayNames[a1.grenadeName] or a1.grenadeName:gsub(" Grenade", "")
    QueueMessage(All .. (if v1 == "" then v2 .. " " else string.format(v1, v2)) .. "<font color=\"rgb(255,255,255)\">: </font>" .. (string.format(
        "<font color=\"%s\">%s!</font>",
        HTML.GrenadeColors[a1.grenadeName] or "rgb(255,255,255)",
        (((v3:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))
    )))
end

local function QueueItemAnnouncement(a1, a2) -- Line: 444
    -- upvalues: HTML (val), Rarities (val), QueueMessage (val)
    local team = a1.team
    local displayName = a1.displayName
    local v1 = HTML.TeamColors[team] or ""
    local v2 = ((displayName:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
    local v3 = if v1 == "" then v2 .. " " else string.format(v1, v2)
    local Stock = Rarities[a1.rarity] or Rarities.Stock
    local Color = Stock.Color
    local v4 = string.format("rgb(%d,%d,%d)", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5)))
    v1 = ((a1.weaponName:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
    v2 = ((a1.skinName:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
    local v5 = (if not a1.statTrak then "" else "KillTrak™ ") .. v1 .. " | " .. v2
    QueueMessage(v3 .. (("<font color=\"rgb(255,255,255)\">%*</font>"):format(a2)) .. string.format("<font color=\"%s\">%s</font>", v4, v5))
end

function u0.ProcessCaseOpened(a1) -- Line: 459 -- upvalues: Profiler (val), QueueItemAnnouncement (val)
    Profiler.mark("UI.Chat.ProcessCaseOpened")
    QueueItemAnnouncement(a1, "opened a case and found: ")
end

function u0.ProcessTradeUp(a1) -- Line: 464 -- upvalues: Profiler (val), QueueItemAnnouncement (val)
    Profiler.mark("UI.Chat.ProcessTradeUp")
    QueueItemAnnouncement(a1, "traded up and crafted: ")
end

local u168 = {["Show Player Crosshairs"] = true, ["Show my crosshair when spectating bots"] = true}

local function CopySpectatedCrosshair() -- Line: 479
    -- upvalues: ReplicatedStorage (val), u0 (val), LocalPlayer (val), DataController (val), u168 (val)
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
    local Settings = require(ReplicatedStorage.Interface.Screens.Menu.Settings)
    local v1 = SpectateController.GetCurrentSpectateInstance()
    local Player = v1 and v1.Player
    if not Player then
        u0.ProcessSystemMessage("You must be spectating a player to use /cc.")
        return
    end
    if Player == LocalPlayer then
        u0.ProcessSystemMessage("You can't copy your own crosshair.")
        return
    end
    if not Player:IsA("Player") then
        u0.ProcessSystemMessage("Bots don't have a crosshair to copy.")
        return
    end
    local v2 = DataController.Get(Player, "Settings.Game.Crosshair")
    if type(v2) ~= "table" then
        u0.ProcessSystemMessage((("Couldn't read %*'s crosshair."):format(Player.DisplayName)))
        return
    end
    local v3 = false
    for k, v in pairs(v2) do
        if not u168[k] then
            Settings.SettingChanged("Game", k, v)
            v3 = true
        end
    end
    if v3 then
        u0.ProcessSystemMessage((("Copied %*'s crosshair."):format(Player.DisplayName)))
    end
end

local function ToggleDeveloperConsole() -- Line: 522 -- upvalues: StarterGui (val)
    local success, result = pcall(StarterGui.GetCore, StarterGui, "DevConsoleVisible")
    if not success then
        return
    end
    pcall(StarterGui.SetCore, StarterGui, "DevConsoleVisible", not result)
end

function u0.HandleChatCommand(a1) -- Line: 532
    -- upvalues: CopySpectatedCrosshair (val), StarterGui (val)
    local v1 = string.lower(string.match(a1, "^%s*(%S+)") or "")
    if v1 == "/cc" then
        CopySpectatedCrosshair()
        return true
    end
    if v1 ~= "/console" and v1 ~= "/newconsole" then
        return false
    end
    local success, result = pcall(StarterGui.GetCore, StarterGui, "DevConsoleVisible")
    if success then
        pcall(StarterGui.SetCore, StarterGui, "DevConsoleVisible", not result)
    end
    return true
end

local function GetOutgoingChannelName() -- Line: 549
    -- upvalues: CharacterResolver (val), LocalPlayer (val), All (ref), ChatModes (val)
    local v1 = CharacterResolver.isAlivePlayer(LocalPlayer)
    local Attribute = LocalPlayer:GetAttribute("Team")
    local v2 = not Attribute or Attribute == "Spectators"
    local v3 = workspace:GetAttribute("ServerGamemode") == "Competitive"
    if All ~= ChatModes.Modes.All then
        if not v1 then
            if v3 and not v2 then
                return "Team"
            end
            return "TeamDead"
        end
        return "Team"
    end
    if not v1 and not v2 then
        if v3 and not v2 then
            return "All"
        end
        return "AllDead"
    end
    return "All"
end

function u0.Initialize(a1, a2) -- Line: 572
    -- upvalues: Profiler (val), u127 (ref), u128 (ref), GetUserPlatform (val), u126 (ref), ReplicatedStorage (val)
    -- upvalues: u133 (ref), BuyMenu (val), LocalPlayer (val), SetChatActive (val), ChatModes (val), All (ref)
    -- upvalues: CloseChat (val), u0 (val), TextChatService (val), GetOutgoingChannelName (val)
    -- upvalues: CanPlayerUseChatService (val)
    Profiler.mark("UI.Chat.Initialize")
    u127 = a2
    u128 = GetUserPlatform()
    u126 = ReplicatedStorage.Assets.UI.Chat.Template
    u126.Message.RichText = true
    for i, v in ipairs(u127.Chat.ScrollingFrame:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    u127.Type.TextBox.ClearTextOnFocus = false
    u127.Type.TextBox.Focused:Connect(function() -- Line: 588
        -- upvalues: u133 (upval), u127 (upval), BuyMenu (upval), LocalPlayer (upval), SetChatActive (upval)
        -- upvalues: Profiler (upval), ChatModes (upval), All (upval)
        if not u133 then
            u127.Type.TextBox:ReleaseFocus()
            return
        end
        BuyMenu.closeFrame()
        LocalPlayer:SetAttribute("IsPlayerChatting", true)
        u127.Type.TextBox.TextTransparency = 0
        SetChatActive(true)
        task.delay(0, function() -- Line: 601 -- upvalues: Profiler (upval), u127 (upval)
            debug.setmemorycategory("UI.Chat.ClearFocusedTextDeferred")
            Profiler.mark("UI.Chat.ClearFocusedTextDeferred")
            u127.Type.TextBox.Text = ""
        end)
        if ChatModes.Labels[All] then
            u127.Type.TextBox.PlaceholderText = ChatModes.Labels[All]
        end
    end)
    u127.Type.TextBox.FocusLost:Connect(function(a1) -- Line: 612
        -- upvalues: u127 (upval), CloseChat (upval), u0 (upval), TextChatService (upval)
        -- upvalues: GetOutgoingChannelName (upval)
        local Text_2 = ""
        if a1 and 0 < (string.len(u127.Type.TextBox.Text)) then
            Text_2 = u127.Type.TextBox.Text
        end
        CloseChat()
        if a1 and #Text_2 ~= 0 then
            if u0.HandleChatCommand(Text_2) or #Text_2 > 100 then
                return
            end
            local v1 = TextChatService:FindFirstChild((GetOutgoingChannelName()))
            if v1 then
                v1:SendAsync(Text_2)
            end
            return
        end
    end)
    SetChatActive(false)
    u127.Visible = false
    if not CanPlayerUseChatService(LocalPlayer) then
        (u127:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 647 -- upvalues: u127 (upval)
            if u127.Visible then
                u127.Visible = false
            end
        end)
    end
end

function u0.Start() -- Line: 655
    -- upvalues: Profiler (val), TextChatService (val), CharacterResolver (val), LocalPlayer (val), Players (val)
    -- upvalues: u0 (val), DataController (val), Remotes (val), UserInputService (val), ChatModes (val)
    local v1, v2
    debug.setmemorycategory("UI.Chat.Start")
    Profiler.mark("UI.Chat.Start.Begin")
    local v3 = {{"All", false}, {"AllDead", false}, {"Team", true}, {"TeamDead", true}}
    local v4 = {}
    for i, j in v3 do
        v2 = j[1]
        v4[v2] = (TextChatService:WaitForChild(j[1], 10))
    end
    local u31 = true

    local function updateLocalPlayerAliveStatus() -- Line: 667
        -- upvalues: u31 (ref), CharacterResolver (upval), LocalPlayer (upval)
        u31 = CharacterResolver.isAlivePlayer(LocalPlayer)
    end

    u31 = CharacterResolver.isAlivePlayer(LocalPlayer)
    ;(LocalPlayer:GetAttributeChangedSignal("Dead")):Connect(updateLocalPlayerAliveStatus)
    ;(LocalPlayer:GetAttributeChangedSignal("Health")):Connect(updateLocalPlayerAliveStatus)

    local function getPlayerAliveStatus(a1) -- Line: 676
        -- upvalues: Players (upval), CharacterResolver (upval)
        local PlayerByUserId = Players:GetPlayerByUserId(a1)
        local v1 = false
        if PlayerByUserId ~= nil then
            v1 = CharacterResolver.isAlivePlayer(PlayerByUserId)
        end
        return v1
    end

    local u57 = {}

    local function processChannelMessage(a1, a2, a3) -- Line: 685
        -- upvalues: u57 (ref), Players (upval), CharacterResolver (upval), LocalPlayer (upval), u31 (ref), u0 (upval)
        local result, success, v1
        if a1.Status ~= Enum.TextChatMessageStatus.Success then
            return
        end
        local MessageId = a1.MessageId
        if MessageId and u57[MessageId] then
            return
        end
        if MessageId then
            u57[MessageId] = true
            local v2 = 0
            for i in u57 do
                v2 = v2 + 1
            end
            if v2 > 100 then
                u57 = {[MessageId] = true}
            end
        end
        local TextSource = a1.TextSource
        if not TextSource then
            return
        end
        local UserId = TextSource.UserId
        if not UserId then
            return
        end
        local PlayerByUserId = Players:GetPlayerByUserId(UserId)
        if not PlayerByUserId then
            return
        end
        local PlayerByUserId_2 = Players:GetPlayerByUserId(UserId)
        local v3 = false
        if PlayerByUserId_2 ~= nil then
            v3 = CharacterResolver.isAlivePlayer(PlayerByUserId_2)
        end
        local Attribute = PlayerByUserId:GetAttribute("Team")
        local Attribute_2 = LocalPlayer:GetAttribute("Team")
        local v4 = workspace:GetAttribute("ServerGamemode") == "Competitive"
        local v5 = u31 and not v3 and not v4
        if a2 == "All" and v5 then
            return
        end
        if a2 ~= "Team" and a2 ~= "TeamDead" then
            success, result = pcall(function() -- Line: 740 -- upvalues: PlayerByUserId (val)
                return PlayerByUserId:GetRankInGroup(33751825)
            end)
            v1 = {
                verified = PlayerByUserId.HasVerifiedBadge,
                userId = UserId,
                displayName = PlayerByUserId.DisplayName,
                team = Attribute or "Spectators",
                message = a1.Text,
                alive = v3,
                role = if not success then 0 else if not result then 0 else result,
            }
            u0.ProcessChatData(v1, a3)
            return
        end
        if Attribute ~= Attribute_2 then
            return
        end
        if a2 == "Team" and v5 then
            return
        end
        success, result = pcall(function() -- Line: 740 -- upvalues: PlayerByUserId (val)
            return PlayerByUserId:GetRankInGroup(33751825)
        end)
        v1 = {
            verified = PlayerByUserId.HasVerifiedBadge,
            userId = UserId,
            displayName = PlayerByUserId.DisplayName,
            team = Attribute or "Spectators",
            message = a1.Text,
            alive = v3,
            role = if not success then 0 else if not result then 0 else result,
        }
        u0.ProcessChatData(v1, a3)
    end

    for k, n in v3 do
        local u161 = n[1]
        local u162 = n[2]
        v1 = v4[u161]
        if v1 then
            function v1.OnIncomingMessage(a1) -- Line: 762
                -- upvalues: processChannelMessage (val), u161 (val), u162 (val)
                processChannelMessage(a1, u161, u162)
                return nil
            end
        end
    end

    local function listenSystemMessage(a1, a2) -- Line: 770
        -- upvalues: DataController (upval), LocalPlayer (upval)
        a1.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), a2 (val)
            if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
                a2(a1)
            end
        end)
    end

    local ChatTeamJoin = Remotes.Chat.ChatTeamJoin

    local function u74(a1) -- Line: 777 -- upvalues: u0 (upval)
        u0.ProcessTeamJoin(a1.name, a1.team)
    end

    ChatTeamJoin.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), u74 (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u74(a1)
        end
    end)
    local ChatPlayerLeave = Remotes.Chat.ChatPlayerLeave

    local function u81(a1) -- Line: 780 -- upvalues: u0 (upval) -- types: a1: table
        u0.ProcessPlayerLeave(a1.name)
    end

    ChatPlayerLeave.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), u81 (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u81(a1)
        end
    end)
    local ChatPlayerBanned = Remotes.Chat.ChatPlayerBanned

    local function u88(a1) -- Line: 783 -- upvalues: u0 (upval) -- types: a1: table
        u0.ProcessPlayerBanned(a1.name)
    end

    ChatPlayerBanned.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), u88 (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u88(a1)
        end
    end)
    local ChatSystemMessage = Remotes.Chat.ChatSystemMessage

    local function u95(a1) -- Line: 786 -- upvalues: u0 (upval)
        u0.ProcessSystemMessage(a1.message)
    end

    ChatSystemMessage.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), u95 (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u95(a1)
        end
    end)
    local ChatTeamDamage = Remotes.Chat.ChatTeamDamage
    local ProcessTeamDamage = u0.ProcessTeamDamage
    ChatTeamDamage.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), ProcessTeamDamage (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessTeamDamage(a1)
        end
    end)
    local ChatPlayerKilled = Remotes.Chat.ChatPlayerKilled
    local ProcessKillMessage = u0.ProcessKillMessage
    ChatPlayerKilled.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), ProcessKillMessage (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessKillMessage(a1)
        end
    end)
    local ChatMoneyReward = Remotes.Chat.ChatMoneyReward
    local ProcessMoneyReward = u0.ProcessMoneyReward
    ChatMoneyReward.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), ProcessMoneyReward (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessMoneyReward(a1)
        end
    end)
    local ChatCaseOpened = Remotes.Chat.ChatCaseOpened
    local ProcessCaseOpened = u0.ProcessCaseOpened
    ChatCaseOpened.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), ProcessCaseOpened (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessCaseOpened(a1)
        end
    end)
    local ChatTradeUp = Remotes.Chat.ChatTradeUp
    local ProcessTradeUp = u0.ProcessTradeUp
    ChatTradeUp.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), ProcessTradeUp (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessTradeUp(a1)
        end
    end)
    local ChatGrenadeThrow = Remotes.Chat.ChatGrenadeThrow
    local ProcessGrenadeThrow = u0.ProcessGrenadeThrow
    ChatGrenadeThrow.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), ProcessGrenadeThrow (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessGrenadeThrow(a1)
        end
    end)
    local ChatDefuseStart = Remotes.Chat.ChatDefuseStart
    local ProcessDefuseStart = u0.ProcessDefuseStart
    ChatDefuseStart.Listen(function(a1) -- Line: 771 -- upvalues: DataController (upval), LocalPlayer (upval), ProcessDefuseStart (val)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessDefuseStart(a1)
        end
    end)
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 798 -- upvalues: u0 (upval), ChatModes (upval) -- types: a1: userdata, a2: boolean
        if not a2 and a1.UserInputType == Enum.UserInputType.Keyboard and a1.KeyCode == Enum.KeyCode.Slash then
            u0.OpenChat(ChatModes.Modes.All)
        end
    end)
end

return u0