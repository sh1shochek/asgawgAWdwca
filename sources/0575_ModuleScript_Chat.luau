-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local TextChatService = game:GetService("TextChatService");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local CanPlayerUseChatService = require(ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local ChatModes = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.ChatModes);
local Platforms = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.Platforms);
local HTML = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.HTML);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
require(script:WaitForChild("Types"));
local TweenInfo_new_ret = TweenInfo.new(3, Enum.EasingStyle.Linear);
local u2 = nil;
local u3 = nil;
local u4 = { Platforms.PC };
local All = ChatModes.Modes.All;
local u5 = false;
local u6 = false;
local u7 = 0;
local u8 = {};
local u9 = {};
local u10 = nil;

local function IsSystemChatMessagesEnabled() -- Line: 77
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false;
end;

local function EscapeRichText(p11: string) -- Line: 81
    return p11:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
end;

local function ColorToRGB(p12) -- Line: 85
    local math_floor_ret = math.floor(p12.R * 255 + 0.5);
    local math_floor_ret2 = math.floor(p12.G * 255 + 0.5);
    local math_floor_ret3 = math.floor(p12.B * 255 + 0.5);

    return string.format("rgb(%d,%d,%d)", math_floor_ret, math_floor_ret2, math_floor_ret3);
end;

local function IsCompetitiveServerGamemode() -- Line: 92
    return workspace:GetAttribute("ServerGamemode") == "Competitive";
end;

local function GetChatNameColorFormat(p13) -- Line: 96
    -- upvalues: HTML (copy)
    return HTML.TeamColors[p13.team] or "";
end;

local function IsMobilePlatform() -- Line: 100
    -- upvalues: u4 (ref), Platforms (copy)
    return table.find(u4, Platforms.Mobile) ~= nil;
end;

local function FormatAnnouncerName(p14: any, p15: string) -- Line: 105
    -- upvalues: HTML (copy)
    local v16 = HTML.TeamColors[p14] or "";
    local v17 = p15:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");

    if v16 == "" then
        return v17 .. " ";
    end;

    return string.format(v16, v17);
end;

local function GetPlaceholderText() -- Line: 111
    -- upvalues: u4 (ref), Platforms (copy), InputController (copy)
    return table.find(u4, Platforms.Mobile) ~= nil and "Tap to chat" or ((table.find(u4, Platforms.Console) or table.find(u4, Platforms.VR)) and "" or string.format("Team Chat (%s) | All Chat (%s)", InputController.GetActionKeybind("Team Message") or "U", InputController.GetActionKeybind("Chat Message") or "Y"));
end;

local function OpenChatFrame(u18) -- Line: 128
    -- upvalues: Profiler (copy), u6 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    Profiler.mark("UI.Chat.OpenChatFrame");

    if not (u18.frame and u18.frame.Parent) then
        return;
    end;

    if u6 or (u18.fadeConnection or u18.frame.Message.TextTransparency >= 1) then
        return;
    end;

    local u19 = TweenService:Create(u18.frame.Message, TweenInfo_new_ret, {
        TextTransparency = 1
    });
    local u20 = {
        Disconnect = function() -- Line: 142, Name: Disconnect
            -- upvalues: u19 (copy)
            u19:Cancel();
        end
    };
    u19.Completed:Once(function() -- Line: 146
        -- upvalues: u18 (copy), u20 (copy)
        if u18.fadeConnection == u20 then
            u18.fadeConnection = nil;
        end;
    end);
    u18.fadeConnection = u20;
    u19:Play();
end;

local function SetChatActive(p21: boolean) -- Line: 155
    -- upvalues: u6 (ref), u3 (ref), GetPlaceholderText (copy), u8 (copy), OpenChatFrame (copy)
    u6 = p21;
    u3.Chat.ScrollingFrame.ScrollBarImageTransparency = p21 and 0 or 1;
    u3.Chat.BackgroundTransparency = p21 and 0.55 or 1;
    u3.Type.BackgroundTransparency = p21 and 0.55 or 1;
    u3.BackgroundTransparency = p21 and 0.55 or 1;
    u3.Type.TextBox.PlaceholderColor3 = p21 and Color3.fromRGB(141, 141, 141) or Color3.new(1, 1, 1);

    if not p21 then
        u3.Type.TextBox.PlaceholderText = GetPlaceholderText();
    end;

    local os_clock_ret = os.clock();

    for _, v in ipairs(u8) do
        if p21 then
            if v.fadeConnection then
                v.fadeConnection:Disconnect();
                v.fadeConnection = nil;
            end;

            v.frame.Message.TextTransparency = 0;
        else
            local v22 = os_clock_ret - v.timestamp;

            if v22 > 10 then
                v.frame.Message.TextTransparency = 1;
            else
                task.delay(10 - v22, OpenChatFrame, v);
            end;
        end;
    end;
end;

local function CloseChat() -- Line: 188
    -- upvalues: u6 (ref), LocalPlayer (copy), MenuState (copy), u4 (ref), Platforms (copy), CameraController (copy), u3 (ref), SetChatActive (copy), u7 (ref)
    if not u6 then
        return;
    end;

    LocalPlayer:SetAttribute("IsPlayerChatting", nil);
    local v23 = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Menu");

    if v23 then
        v23 = v23.Visible;
    end;

    if not (v23 or (MenuState.IsCaseSceneActive() or MenuState.IsInspectActive())) and table.find(u4, Platforms.Mobile) == nil then
        CameraController.setMouseEnabled(false);
    end;

    u3.Type.TextBox:ReleaseFocus();
    u3.Type.TextBox.TextTransparency = 1;
    u3.Type.TextBox.Text = "";
    SetChatActive(false);
    u7 = os.clock();

    if table.find(u4, Platforms.Mobile) ~= nil then
        u3.Visible = false;
    end;
end;

local function AddMessageToUI(p24) -- Line: 217
    -- upvalues: u8 (copy), u6 (ref), OpenChatFrame (copy), u3 (ref), Profiler (copy)
    local v25 = #u8 >= 15 and u8[15];

    if v25 then
        v25.frame:Destroy();
        table.remove(u8, 15);
    end;

    table.insert(u8, 1, p24);

    for i, v in ipairs(u8) do
        v.frame.LayoutOrder = #u8 - i;
    end;

    p24.frame.Message.TextTransparency = 0;

    if not u6 then
        task.delay(10, OpenChatFrame, p24);
    end;

    p24.frame.Parent = u3.Chat.ScrollingFrame;
    Profiler.defer("UI.Chat.ScrollToBottomDeferred", function() -- Line: 242
        -- upvalues: u3 (ref)
        u3.Chat.ScrollingFrame.CanvasPosition = Vector2.new(0, u3.Chat.ScrollingFrame.AbsoluteCanvasSize.Y);
    end);
end;

local function ProcessMessageQueue() -- Line: 248
    -- upvalues: Profiler (copy), u5 (ref), u9 (copy), u10 (ref), u2 (ref), AddMessageToUI (copy), RunServiceController (copy), ProcessMessageQueue (copy)
    Profiler.mark("UI.Chat.ProcessMessageQueue");

    if u5 or #u9 == 0 then
        if #u9 == 0 and u10 then
            u10:Disconnect();
            u10 = nil;
        end;

        return;
    end;

    local v26 = 0;
    u5 = true;

    while #u9 > 0 and v26 < 2 do
        local table_remove_ret = table.remove(u9, 1);

        if table_remove_ret then
            local v27 = u2:Clone();
            v27.Message.Text = table_remove_ret.text;
            AddMessageToUI({
                fadeConnection = nil,
                frame = v27,
                timestamp = table_remove_ret.timestamp,
                text = table_remove_ret.text
            });
            v26 = v26 + 1;
        end;
    end;

    u5 = false;

    if #u9 ~= 0 or not u10 then
        if #u9 > 0 and not u10 then
            u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 281
                -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
                Profiler.mark("UI.Chat.Heartbeat");
                ProcessMessageQueue();
            end);
        end;

        return;
    end;

    u10:Disconnect();
    u10 = nil;
end;

local function QueueMessage(p28: string) -- Line: 288
    -- upvalues: Profiler (copy), u9 (copy), u5 (ref), ProcessMessageQueue (copy)
    Profiler.mark("UI.Chat.QueueMessage");
    local v29 = {
        text = p28,
        timestamp = os.clock()
    };
    table.insert(u9, v29);

    if not u5 then
        ProcessMessageQueue();
    end;
end;

function u1.OpenChat(p30) -- Line: 303
    -- upvalues: Profiler (copy), u6 (ref), CanPlayerUseChatService (copy), LocalPlayer (copy), BuyMenu (copy), All (ref), u3 (ref), ChatModes (copy), SetChatActive (copy), u4 (ref), Platforms (copy), CameraController (copy)
    Profiler.mark("UI.Chat.OpenChat");

    if u6 or not CanPlayerUseChatService(LocalPlayer) then
        return;
    end;

    BuyMenu.closeFrame();
    All = p30;
    u3.Visible = true;
    u3.Type.TextBox.PlaceholderText = ChatModes.Labels[p30];
    u3.Type.TextBox.TextTransparency = 0;
    u3.Type.TextBox.Text = "";
    SetChatActive(true);

    if table.find(u4, Platforms.Mobile) == nil then
        CameraController.setMouseEnabled(true);
    end;

    LocalPlayer:SetAttribute("IsPlayerChatting", true);
    u3.Type.TextBox:CaptureFocus();
    task.delay(0, function() -- Line: 328
        -- upvalues: u3 (ref)
        u3.Type.TextBox.Text = "";
    end);
end;

function u1.CloseChat() -- Line: 333
    -- upvalues: CloseChat (copy)
    CloseChat();
end;

function u1.ToggleChat(p31) -- Line: 337
    -- upvalues: u6 (ref), u7 (ref), CloseChat (copy), u1 (copy)
    if u6 or os.clock() - u7 < 0.25 then
        CloseChat();

        return;
    end;

    u1.OpenChat(p31);
end;

function u1.ProcessChatData(p32: any, p33: boolean) -- Line: 346
    -- upvalues: Profiler (copy), HTML (copy), QueueMessage (copy)
    Profiler.mark("UI.Chat.ProcessChatData");
    local v34;

    if p33 then
        v34 = HTML.Prefixes[p32.team] or HTML.Prefixes.All;
    else
        v34 = HTML.Prefixes.All;
    end;

    QueueMessage((not (p32.role and HTML.Roles[p32.role]) and "" or HTML.Roles[p32.role]) .. v34 .. string.format(HTML.TeamColors[p32.team] or "", (p32.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))) .. (not p32.verified and "" or HTML.Badges.Verified .. " ") .. (p32.alive and "" or HTML.Suffixes.Dead) .. ": " .. p32.message);
end;

function u1.ProcessTeamJoin(p35: string, p36: any) -- Line: 360
    -- upvalues: HTML (copy), QueueMessage (copy)
    local v37 = HTML.TeamJoinMessages[p36];

    if not v37 then
        return;
    end;

    QueueMessage(string.format(v37, p35));
end;

function u1.ProcessPlayerLeave(p38: string) -- Line: 368
    -- upvalues: QueueMessage (copy), HTML (copy)
    QueueMessage(string.format(HTML.PlayerLeave, p38));
end;

function u1.ProcessPlayerBanned(p39: string) -- Line: 372
    -- upvalues: QueueMessage (copy), HTML (copy)
    QueueMessage(string.format(HTML.PlayerBanned, p39));
end;

function u1.ProcessSystemMessage(p40: string) -- Line: 376
    -- upvalues: QueueMessage (copy), HTML (copy)
    QueueMessage(string.format(HTML.SystemMessage, (p40:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))));
end;

function u1.ProcessTeamDamage(p41) -- Line: 380
    -- upvalues: QueueMessage (copy), HTML (copy)
    if p41.messageType == "Warning" then
        QueueMessage(HTML.TeamDamageWarning);

        return;
    end;

    if p41.messageType == "Announcement" then
        QueueMessage(string.format(HTML.TeamDamageAnnouncement, (p41.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))));
    end;
end;

function u1.ProcessKillMessage(p42) -- Line: 391
    -- upvalues: Profiler (copy), LocalPlayer (copy), QueueMessage (copy), HTML (copy)
    Profiler.mark("UI.Chat.ProcessKillMessage");

    if tostring(p42.Killer) == tostring(LocalPlayer.UserId) then
        local v43 = p42.Points or 11;
        QueueMessage(string.format(HTML.Points.Deathmatch, v43, v43 == 1 and "point" or "points", p42.Weapon));
    end;
end;

function u1.ProcessMoneyReward(p44) -- Line: 400
    -- upvalues: HTML (copy), QueueMessage (copy)
    local v45 = HTML.Money[p44.source];

    if not v45 then
        return;
    end;

    local v46 = tonumber(p44.amount);

    if not v46 then
        return;
    end;

    if p44.source ~= "Kill" then
        QueueMessage(string.format(v45, (math.abs(v46))));

        return;
    end;

    local v47 = p44.weaponName and HTML.Money.KillWithWeapon or HTML.Money.Kill;
    QueueMessage(p44.weaponName and string.format(v47, v46, p44.weaponName) or string.format(v47, v46));
end;

function u1.ProcessDefuseStart(p48) -- Line: 423
    -- upvalues: HTML (copy), QueueMessage (copy)
    local v49 = HTML.TeamColors[p48.team] or "";
    local v50 = p48.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v51;

    if v49 == "" then
        v51 = v50 .. " ";
    else
        v51 = string.format(v49, v50);
    end;

    QueueMessage((HTML.Prefixes[p48.team] or HTML.Prefixes.All) .. v51 .. string.format("<font color=\"%s\">@%s</font>", HTML.DefuseStartLocationColor, (("Bombsite " .. (p48.site or "?")):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))) .. "<font color=\"rgb(255,255,255)\">: </font>" .. HTML.DefuseStartAction);
end;

function u1.ProcessGrenadeThrow(p52) -- Line: 434
    -- upvalues: HTML (copy), QueueMessage (copy)
    local v53 = HTML.TeamColors[p52.team] or "";
    local v54 = p52.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v55;

    if v53 == "" then
        v55 = v54 .. " ";
    else
        v55 = string.format(v53, v54);
    end;

    local v56 = HTML.Prefixes[p52.team] or HTML.Prefixes.All;
    local v57 = HTML.GrenadeDisplayNames[p52.grenadeName] or p52.grenadeName:gsub(" Grenade", "");
    QueueMessage(v56 .. v55 .. "<font color=\"rgb(255,255,255)\">: </font>" .. string.format("<font color=\"%s\">%s!</font>", HTML.GrenadeColors[p52.grenadeName] or "rgb(255,255,255)", (v57:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))));
end;

local function QueueItemAnnouncement(p58: any, p59: string) -- Line: 444
    -- upvalues: HTML (copy), Rarities (copy), QueueMessage (copy)
    local v60 = HTML.TeamColors[p58.team] or "";
    local v61 = p58.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v62;

    if v60 == "" then
        v62 = v61 .. " ";
    else
        v62 = string.format(v60, v61);
    end;

    local Color = (Rarities[p58.rarity] or Rarities.Stock).Color;
    local math_floor_ret = math.floor(Color.R * 255 + 0.5);
    local math_floor_ret2 = math.floor(Color.G * 255 + 0.5);
    local math_floor_ret3 = math.floor(Color.B * 255 + 0.5);
    local string_format_ret = string.format("rgb(%d,%d,%d)", math_floor_ret, math_floor_ret2, math_floor_ret3);
    local v63 = p58.weaponName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v64 = p58.skinName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v65 = (p58.statTrak and "KillTrak™ " or "") .. v63 .. " | " .. v64;
    QueueMessage(v62 .. `<font color="rgb(255,255,255)">{p59}</font>` .. string.format("<font color=\"%s\">%s</font>", string_format_ret, v65));
end;

function u1.ProcessCaseOpened(p66) -- Line: 459
    -- upvalues: Profiler (copy), QueueItemAnnouncement (copy)
    Profiler.mark("UI.Chat.ProcessCaseOpened");
    QueueItemAnnouncement(p66, "opened a case and found: ");
end;

function u1.ProcessTradeUp(p67) -- Line: 464
    -- upvalues: Profiler (copy), QueueItemAnnouncement (copy)
    Profiler.mark("UI.Chat.ProcessTradeUp");
    QueueItemAnnouncement(p67, "traded up and crafted: ");
end;

local u68 = {
    ["Show Player Crosshairs"] = true,
    ["Show my crosshair when spectating bots"] = true
};

local function CopySpectatedCrosshair() -- Line: 479
    -- upvalues: ReplicatedStorage (copy), u1 (copy), LocalPlayer (copy), DataController (copy), u68 (copy)
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
    local Settings = require(ReplicatedStorage.Interface.Screens.Menu.Settings);
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if CurrentSpectateInstance then
        CurrentSpectateInstance = CurrentSpectateInstance.Player;
    end;

    if not CurrentSpectateInstance then
        u1.ProcessSystemMessage("You must be spectating a player to use /cc.");

        return;
    end;

    if CurrentSpectateInstance == LocalPlayer then
        u1.ProcessSystemMessage("You can\'t copy your own crosshair.");

        return;
    end;

    if not CurrentSpectateInstance:IsA("Player") then
        u1.ProcessSystemMessage("Bots don\'t have a crosshair to copy.");

        return;
    end;

    local v69 = DataController.Get(CurrentSpectateInstance, "Settings.Game.Crosshair");

    if type(v69) ~= "table" then
        u1.ProcessSystemMessage((`Couldn't read {CurrentSpectateInstance.DisplayName}'s crosshair.`));

        return;
    end;

    local v70 = false;

    for i, v in pairs(v69) do
        if not u68[i] then
            Settings.SettingChanged("Game", i, v);
            v70 = true;
        end;
    end;

    if v70 then
        u1.ProcessSystemMessage((`Copied {CurrentSpectateInstance.DisplayName}'s crosshair.`));
    end;
end;

local function ToggleDeveloperConsole() -- Line: 522
    -- upvalues: StarterGui (copy)
    local success, result = pcall(StarterGui.GetCore, StarterGui, "DevConsoleVisible");

    if not success then
        return;
    end;

    pcall(StarterGui.SetCore, StarterGui, "DevConsoleVisible", not result);
end;

function u1.HandleChatCommand(p71: string) -- Line: 532
    -- upvalues: CopySpectatedCrosshair (copy), StarterGui (copy)
    local string_lower_ret = string.lower(string.match(p71, "^%s*(%S+)") or "");

    if string_lower_ret == "/cc" then
        CopySpectatedCrosshair();

        return true;
    end;

    if string_lower_ret ~= "/console" and string_lower_ret ~= "/newconsole" then
        return false;
    end;

    local success, result = pcall(StarterGui.GetCore, StarterGui, "DevConsoleVisible");

    if success then
        pcall(StarterGui.SetCore, StarterGui, "DevConsoleVisible", not result);
    end;

    return true;
end;

local function GetOutgoingChannelName() -- Line: 549
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), All (ref), ChatModes (copy)
    local v72 = CharacterResolver.isAlivePlayer(LocalPlayer);
    local Attribute = LocalPlayer:GetAttribute("Team");
    local v73 = not Attribute or Attribute == "Spectators";
    local v74 = workspace:GetAttribute("ServerGamemode") == "Competitive";

    return All == ChatModes.Modes.All and ((v72 or (v73 or v74 and not v73)) and "All" or "AllDead") or ((v72 or v74 and not v73) and "Team" or "TeamDead");
end;

function u1.Initialize(p75, p76) -- Line: 572
    -- upvalues: Profiler (copy), u3 (ref), u4 (ref), GetUserPlatform (copy), u2 (ref), ReplicatedStorage (copy), u6 (ref), BuyMenu (copy), LocalPlayer (copy), SetChatActive (copy), ChatModes (copy), All (ref), CloseChat (copy), u1 (copy), TextChatService (copy), GetOutgoingChannelName (copy), CanPlayerUseChatService (copy)
    Profiler.mark("UI.Chat.Initialize");
    u3 = p76;
    u4 = GetUserPlatform();
    u2 = ReplicatedStorage.Assets.UI.Chat.Template;
    u2.Message.RichText = true;

    for _, child in ipairs(u3.Chat.ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    u3.Type.TextBox.ClearTextOnFocus = false;
    u3.Type.TextBox.Focused:Connect(function() -- Line: 588
        -- upvalues: u6 (ref), u3 (ref), BuyMenu (ref), LocalPlayer (ref), SetChatActive (ref), Profiler (ref), ChatModes (ref), All (ref)
        if not u6 then
            u3.Type.TextBox:ReleaseFocus();

            return;
        end;

        BuyMenu.closeFrame();
        LocalPlayer:SetAttribute("IsPlayerChatting", true);
        u3.Type.TextBox.TextTransparency = 0;
        SetChatActive(true);
        task.delay(0, function() -- Line: 601
            -- upvalues: Profiler (ref), u3 (ref)
            debug.setmemorycategory("UI.Chat.ClearFocusedTextDeferred");
            Profiler.mark("UI.Chat.ClearFocusedTextDeferred");
            u3.Type.TextBox.Text = "";
        end);

        if ChatModes.Labels[All] then
            u3.Type.TextBox.PlaceholderText = ChatModes.Labels[All];
        end;
    end);
    u3.Type.TextBox.FocusLost:Connect(function(p77: boolean) -- Line: 612
        -- upvalues: u3 (ref), CloseChat (ref), u1 (ref), TextChatService (ref), GetOutgoingChannelName (ref)
        local v78 = (not p77 or string.len(u3.Type.TextBox.Text) <= 0) and "" or u3.Type.TextBox.Text;
        CloseChat();

        if not p77 or #v78 == 0 then
            return;
        end;

        if u1.HandleChatCommand(v78) then
            return;
        end;

        if #v78 > 100 then
            return;
        end;

        local v79 = TextChatService:FindFirstChild((GetOutgoingChannelName()));

        if v79 then
            v79:SendAsync(v78);
        end;
    end);
    SetChatActive(false);
    u3.Visible = false;

    if not CanPlayerUseChatService(LocalPlayer) then
        u3:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 647
            -- upvalues: u3 (ref)
            if u3.Visible then
                u3.Visible = false;
            end;
        end);
    end;
end;

function u1.Start() -- Line: 655
    -- upvalues: Profiler (copy), TextChatService (copy), CharacterResolver (copy), LocalPlayer (copy), Players (copy), u1 (copy), DataController (copy), Remotes (copy), UserInputService (copy), ChatModes (copy)
    debug.setmemorycategory("UI.Chat.Start");
    Profiler.mark("UI.Chat.Start.Begin");
    local v80 = { { "All", false }, { "AllDead", false }, { "Team", true }, { "TeamDead", true } };
    local v81 = {};

    for _, v in v80 do
        v81[v[1]] = TextChatService:WaitForChild(v[1], 10);
    end;

    local u82 = true;

    local function updateLocalPlayerAliveStatus() -- Line: 667
        -- upvalues: u82 (ref), CharacterResolver (ref), LocalPlayer (ref)
        u82 = CharacterResolver.isAlivePlayer(LocalPlayer);
    end;

    u82 = CharacterResolver.isAlivePlayer(LocalPlayer);
    LocalPlayer:GetAttributeChangedSignal("Dead"):Connect(updateLocalPlayerAliveStatus);
    LocalPlayer:GetAttributeChangedSignal("Health"):Connect(updateLocalPlayerAliveStatus);

    local function getPlayerAliveStatus(p83: number) -- Line: 676
        -- upvalues: Players (ref), CharacterResolver (ref)
        local PlayerByUserId = Players:GetPlayerByUserId(p83);
        local v84;

        if PlayerByUserId == nil then
            v84 = false;
        else
            v84 = CharacterResolver.isAlivePlayer(PlayerByUserId);
        end;

        return v84;
    end;

    local u85 = {};

    local function processChannelMessage(p86: userdata, p87: string, p88: boolean) -- Line: 685
        -- upvalues: u85 (ref), Players (ref), CharacterResolver (ref), LocalPlayer (ref), u82 (ref), u1 (ref)
        if p86.Status ~= Enum.TextChatMessageStatus.Success then
            return;
        end;

        local MessageId = p86.MessageId;

        if MessageId and u85[MessageId] then
            return;
        end;

        if MessageId then
            u85[MessageId] = true;
            local v89 = 0;

            for _ in u85 do
                v89 = v89 + 1;
            end;

            if v89 > 100 then
                u85 = {
                    [MessageId] = true
                };
            end;
        end;

        local TextSource = p86.TextSource;

        if not TextSource then
            return;
        end;

        local UserId = TextSource.UserId;

        if not UserId then
            return;
        end;

        local PlayerByUserId = Players:GetPlayerByUserId(UserId);

        if not PlayerByUserId then
            return;
        end;

        local PlayerByUserId2 = Players:GetPlayerByUserId(UserId);
        local v90;

        if PlayerByUserId2 == nil then
            v90 = false;
        else
            v90 = CharacterResolver.isAlivePlayer(PlayerByUserId2);
        end;

        local Attribute = PlayerByUserId:GetAttribute("Team");
        local Attribute2 = LocalPlayer:GetAttribute("Team");
        local v91 = workspace:GetAttribute("ServerGamemode") == "Competitive";
        local v92 = u82 and (not v90 and not v91);

        if p87 == "All" and v92 then
            return;
        end;

        if not (p87 ~= "Team" and p87 ~= "TeamDead" or Attribute == Attribute2 and (p87 ~= "Team" or not v92)) then
            return;
        end;

        local success, result = pcall(function() -- Line: 740
            -- upvalues: PlayerByUserId (copy)
            return PlayerByUserId:GetRankInGroup(33751825);
        end);
        u1.ProcessChatData({
            verified = PlayerByUserId.HasVerifiedBadge,
            userId = UserId,
            displayName = PlayerByUserId.DisplayName,
            team = Attribute or "Spectators",
            message = p86.Text,
            alive = v90,
            role = success and result and result or 0
        }, p88);
    end;

    for _, v in v80 do
        local u93 = v[1];
        local u94 = v[2];
        local v95 = v81[u93];

        if v95 then
            function v95.OnIncomingMessage(p96: userdata) -- Line: 762
                -- upvalues: processChannelMessage (copy), u93 (copy), u94 (copy)
                processChannelMessage(p96, u93, u94);

                return nil;
            end;
        end;
    end;

    local function listenSystemMessage(p97: any, u98: function) -- Line: 770
        -- upvalues: DataController (ref), LocalPlayer (ref)
        p97.Listen(function(p99) -- Line: 771
            -- upvalues: DataController (ref), LocalPlayer (ref), u98 (copy)
            if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
                u98(p99);
            end;
        end);
    end;

    local function u101(p100) -- Line: 777
        -- upvalues: u1 (ref)
        u1.ProcessTeamJoin(p100.name, p100.team);
    end;

    Remotes.Chat.ChatTeamJoin.Listen(function(p102) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), u101 (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u101(p102);
        end;
    end);

    local function u104(p103: table) -- Line: 780
        -- upvalues: u1 (ref)
        u1.ProcessPlayerLeave(p103.name);
    end;

    Remotes.Chat.ChatPlayerLeave.Listen(function(p105) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), u104 (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u104(p105);
        end;
    end);

    local function u107(p106: table) -- Line: 783
        -- upvalues: u1 (ref)
        u1.ProcessPlayerBanned(p106.name);
    end;

    Remotes.Chat.ChatPlayerBanned.Listen(function(p108) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), u107 (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u107(p108);
        end;
    end);

    local function u110(p109) -- Line: 786
        -- upvalues: u1 (ref)
        u1.ProcessSystemMessage(p109.message);
    end;

    Remotes.Chat.ChatSystemMessage.Listen(function(p111) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), u110 (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            u110(p111);
        end;
    end);
    local ProcessTeamDamage = u1.ProcessTeamDamage;
    Remotes.Chat.ChatTeamDamage.Listen(function(p112) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), ProcessTeamDamage (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessTeamDamage(p112);
        end;
    end);
    local ProcessKillMessage = u1.ProcessKillMessage;
    Remotes.Chat.ChatPlayerKilled.Listen(function(p113) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), ProcessKillMessage (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessKillMessage(p113);
        end;
    end);
    local ProcessMoneyReward = u1.ProcessMoneyReward;
    Remotes.Chat.ChatMoneyReward.Listen(function(p114) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), ProcessMoneyReward (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessMoneyReward(p114);
        end;
    end);
    local ProcessCaseOpened = u1.ProcessCaseOpened;
    Remotes.Chat.ChatCaseOpened.Listen(function(p115) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), ProcessCaseOpened (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessCaseOpened(p115);
        end;
    end);
    local ProcessTradeUp = u1.ProcessTradeUp;
    Remotes.Chat.ChatTradeUp.Listen(function(p116) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), ProcessTradeUp (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessTradeUp(p116);
        end;
    end);
    local ProcessGrenadeThrow = u1.ProcessGrenadeThrow;
    Remotes.Chat.ChatGrenadeThrow.Listen(function(p117) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), ProcessGrenadeThrow (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessGrenadeThrow(p117);
        end;
    end);
    local ProcessDefuseStart = u1.ProcessDefuseStart;
    Remotes.Chat.ChatDefuseStart.Listen(function(p118) -- Line: 771
        -- upvalues: DataController (ref), LocalPlayer (ref), ProcessDefuseStart (copy)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false then
            ProcessDefuseStart(p118);
        end;
    end);
    UserInputService.InputBegan:Connect(function(p119: userdata, p120: boolean) -- Line: 798
        -- upvalues: u1 (ref), ChatModes (ref)
        if not (p120 or (p119.UserInputType ~= Enum.UserInputType.Keyboard or p119.KeyCode ~= Enum.KeyCode.Slash)) then
            u1.OpenChat(ChatModes.Modes.All);
        end;
    end);
end;

return u1;