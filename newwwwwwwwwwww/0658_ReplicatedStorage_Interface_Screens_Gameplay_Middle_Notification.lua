-- Notification (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local LocalPlayer = Players.LocalPlayer;
local UDim2_fromScale_ret = UDim2.fromScale(0.9, 0.2);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.9, 0.12);
local Color3_fromRGB_ret = Color3.fromRGB(230, 36, 36);
local TweenInfo_new_ret = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local Notification = ReplicatedStorage.Assets.UI.Notification;
local u2 = {
    Invulnerable = Notification:FindFirstChild("Invulnerable"),
    Default = Notification:FindFirstChild("Default"),
    Keybind = Notification:FindFirstChild("Keybind")
};
local u3 = nil;

local function collectFadeTargets(p4: userdata) -- Line: 52
    local u5 = {};

    local function collect(u6: userdata) -- Line: 54
        -- upvalues: u5 (copy)
        local function add(p7: string) -- Line: 55
            -- upvalues: u6 (copy), u5 (ref)
            local v8 = u6[p7];

            if typeof(v8) == "number" and v8 < 1 then
                table.insert(u5, {
                    Instance = u6,
                    Property = p7,
                    Value = v8
                });
            end;
        end;

        if u6:IsA("GuiObject") then
            local BackgroundTransparency = u6.BackgroundTransparency;

            if typeof(BackgroundTransparency) == "number" and BackgroundTransparency < 1 then
                table.insert(u5, {
                    Property = "BackgroundTransparency",
                    Instance = u6,
                    Value = BackgroundTransparency
                });
            end;
        end;

        if u6:IsA("ImageLabel") or u6:IsA("ImageButton") then
            local ImageTransparency = u6.ImageTransparency;

            if typeof(ImageTransparency) == "number" and ImageTransparency < 1 then
                table.insert(u5, {
                    Property = "ImageTransparency",
                    Instance = u6,
                    Value = ImageTransparency
                });
            end;
        end;

        if u6:IsA("TextLabel") or (u6:IsA("TextButton") or u6:IsA("TextBox")) then
            local TextTransparency = u6.TextTransparency;

            if typeof(TextTransparency) == "number" and TextTransparency < 1 then
                table.insert(u5, {
                    Property = "TextTransparency",
                    Instance = u6,
                    Value = TextTransparency
                });
            end;

            local TextStrokeTransparency = u6.TextStrokeTransparency;

            if typeof(TextStrokeTransparency) == "number" and TextStrokeTransparency < 1 then
                table.insert(u5, {
                    Property = "TextStrokeTransparency",
                    Instance = u6,
                    Value = TextStrokeTransparency
                });
            end;
        end;

        if u6:IsA("UIStroke") then
            local Transparency = u6.Transparency;

            if typeof(Transparency) == "number" and Transparency < 1 then
                table.insert(u5, {
                    Property = "Transparency",
                    Instance = u6,
                    Value = Transparency
                });
            end;
        end;
    end;

    collect(p4);

    for _, descendant in p4:GetDescendants() do
        collect(descendant);
    end;

    return u5;
end;

local function cleanupNotificationTemplate(p9) -- Line: 76
    -- upvalues: collectFadeTargets (copy), TweenService (copy), TweenInfo_new_ret (copy), Debris (copy)
    for _, v in collectFadeTargets(p9) do
        TweenService:Create(v.Instance, TweenInfo_new_ret, {
            [v.Property] = 1
        }):Play();
    end;

    Debris:AddItem(p9, 0.35);
end;

local function getWarmupCardMessage() -- Line: 85
    local Attribute = workspace:GetAttribute("WaitingForPlayers");

    return (typeof(Attribute) ~= "string" or Attribute == "") and "Warmup" or `WAITING FOR PLAYERS ({Attribute})`;
end;

local function destroyNotification(p10: string) -- Line: 93
    -- upvalues: u3 (ref)
    local v11 = u3 and u3:FindFirstChild(p10);

    if v11 then
        v11:Destroy();
    end;
end;

local function getSpawnCardHeader() -- Line: 100
    -- upvalues: u3 (ref)
    local v12 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

    if v12 then
        v12 = v12:FindFirstChild("Container");
    end;

    if v12 then
        v12 = v12:FindFirstChild("Header");
    end;

    if not (v12 and (v12:IsA("TextLabel") and v12)) then
        v12 = nil;
    end;

    return v12;
end;

local function getHeaderText(p13: boolean) -- Line: 108
    -- upvalues: u2 (copy)
    local Invulnerable = u2.Invulnerable;

    if Invulnerable then
        Invulnerable = Invulnerable:FindFirstChild("Container");
    end;

    if Invulnerable then
        Invulnerable = Invulnerable:FindFirstChild("Header");
    end;

    local v14 = Invulnerable and (Invulnerable:IsA("TextLabel") and Invulnerable.Text) or "Invulnerable";

    if p13 then
        return v14;
    end;

    local string_match_ret = string.match(v14, "^[Ii][Nn](.+)$");

    return not string_match_ret and "Vulnerable" or string.upper((string.sub(string_match_ret, 1, 1))) .. string.sub(string_match_ret, 2);
end;

local function setSpawnCardInvulnerable(p15: boolean) -- Line: 124
    -- upvalues: u3 (ref), getHeaderText (copy), GetPreferenceColor (copy), Color3_fromRGB_ret (copy)
    local v16 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

    if v16 then
        v16 = v16:FindFirstChild("Container");
    end;

    if v16 then
        v16 = v16:FindFirstChild("Header");
    end;

    if not (v16 and (v16:IsA("TextLabel") and v16)) then
        v16 = nil;
    end;

    if v16 then
        v16.Text = getHeaderText(p15);
        v16.TextColor3 = p15 and GetPreferenceColor() or Color3_fromRGB_ret;
    end;
end;

local function clearSpawnCard() -- Line: 132
    -- upvalues: u3 (ref), u1 (copy)
    local v17 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

    if v17 then
        v17:Destroy();
    end;

    if workspace:GetAttribute("GameState") == "Warmup" then
        local createNotification = u1.createNotification;
        local Attribute = workspace:GetAttribute("WaitingForPlayers");
        createNotification("Default", "GameState", (typeof(Attribute) ~= "string" or Attribute == "") and "Warmup" or `WAITING FOR PLAYERS ({Attribute})`, 1);
    end;
end;

local function onCleanup(p18: any, p19: number) -- Line: 144
    -- upvalues: cleanupNotificationTemplate (copy)
    if p19 <= tick() - p18:GetAttribute("Timestamp") then
        cleanupNotificationTemplate(p18);
    end;
end;

local function scheduleCleanup(u20: any, u21: number) -- Line: 151
    -- upvalues: cleanupNotificationTemplate (copy)
    task.delay(u21, function() -- Line: 152
        -- upvalues: u20 (copy), u21 (copy), cleanupNotificationTemplate (ref)
        if u20 and u20.Parent then
            local v22 = u20;

            if u21 <= tick() - v22:GetAttribute("Timestamp") then
                cleanupNotificationTemplate(v22);
            end;
        end;
    end);
end;

function u1.createNotification(p23: any, p24: string, p25: string, p26: number?) -- Line: 162
    -- upvalues: u3 (ref), LocalPlayer (copy), u2 (copy), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), collectFadeTargets (copy), TweenService (copy), TweenInfo_new_ret (copy), GetPreferenceColor (copy), InputController (copy)
    if not u3 then
        return;
    end;

    local v27 = u3:FindFirstChild(p24);

    if LocalPlayer:GetAttribute("Team") then
        if not v27 then
            local v28 = u2[p23];

            if not v28 then
                warn((`[Notification]: ReplicatedStorage.Assets.UI.Notification has no "{p23}" template`));

                return nil;
            end;

            v27 = v28:Clone();
            v27.Size = p23 == "Invulnerable" and UDim2_fromScale_ret or UDim2_fromScale_ret2;
            v27.LayoutOrder = -(p26 or 1);
            v27.Name = p24;
            local v29 = collectFadeTargets(v27);

            for _, v in v29 do
                v.Instance[v.Property] = 1;
            end;

            v27.Parent = u3;

            for _, v in v29 do
                TweenService:Create(v.Instance, TweenInfo_new_ret, {
                    [v.Property] = v.Value
                }):Play();
            end;
        end;

        v27:SetAttribute("Timestamp", tick());
        v27.Right.BackgroundColor3 = GetPreferenceColor();
        v27.Left.BackgroundColor3 = GetPreferenceColor();

        if v27:FindFirstChild("TextLabel") then
            v27.TextLabel.Text = p25;
        end;

        if p23 == "Invulnerable" then
            local v30 = InputController.GetActionKeybind("Buy Menu") or "B";
            v27.Container.Context.Text = `[{v30}] Open the Buy Menu`;
            v27.Container.Header.TextColor3 = GetPreferenceColor();
        end;

        return v27;
    end;
end;

function u1.removeNotification(p31: string) -- Line: 216
    -- upvalues: u3 (ref)
    local v32 = u3 and u3:FindFirstChild(p31);

    if v32 then
        v32:Destroy();
    end;
end;

function u1.Initialize(p33, p34) -- Line: 223
    -- upvalues: u3 (ref), LocalPlayer (copy), u1 (copy), getHeaderText (copy), GetPreferenceColor (copy), Color3_fromRGB_ret (copy), clearSpawnCard (copy), cleanupNotificationTemplate (copy), GameState (copy), DataController (copy)
    u3 = p34;

    local function updateDeathmatchSpawnCard() -- Line: 226
        -- upvalues: LocalPlayer (ref), u3 (ref), u1 (ref), getHeaderText (ref), GetPreferenceColor (ref), Color3_fromRGB_ret (ref), clearSpawnCard (ref)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            return;
        end;

        local v35 = LocalPlayer:GetAttribute("Invincible") == true;

        if not (v35 or LocalPlayer:GetAttribute("BuyMenu")) then
            clearSpawnCard();

            return;
        end;

        local GameState2 = u3:FindFirstChild("GameState");
        u1.createNotification("Invulnerable", "Deathmatch Invincibility", "", 0);
        local v36 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

        if v36 then
            v36 = v36:FindFirstChild("Container");
        end;

        if v36 then
            v36 = v36:FindFirstChild("Header");
        end;

        if not (v36 and (v36:IsA("TextLabel") and v36)) then
            v36 = nil;
        end;

        if v36 then
            v36.Text = getHeaderText(v35);
            v36.TextColor3 = v35 and GetPreferenceColor() or Color3_fromRGB_ret;
        end;

        if GameState2 then
            GameState2:Destroy();
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("BuyMenu"):Connect(function() -- Line: 246
        -- upvalues: LocalPlayer (ref), clearSpawnCard (ref), u1 (ref), cleanupNotificationTemplate (ref)
        local Attribute = workspace:GetAttribute("Gamemode");

        if not LocalPlayer:GetAttribute("BuyMenu") and Attribute == "Deathmatch" then
            if not LocalPlayer:GetAttribute("Invincible") then
                clearSpawnCard();
            end;

            local u37 = u1.createNotification("Default", "Your buy period has expired", "Your buy period has expired", 2);
            task.delay(2, function() -- Line: 255
                -- upvalues: u37 (copy), cleanupNotificationTemplate (ref)
                if u37 and u37.Parent then
                    cleanupNotificationTemplate(u37);
                end;
            end);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("Invincible"):Connect(updateDeathmatchSpawnCard);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 266
        -- upvalues: updateDeathmatchSpawnCard (copy), u3 (ref), u1 (ref)
        local Attribute = workspace:GetAttribute("GameState");

        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            updateDeathmatchSpawnCard();

            return;
        end;

        local v38 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

        if v38 then
            v38:Destroy();
        end;

        if Attribute == "Warmup" then
            local createNotification = u1.createNotification;
            local Attribute2 = workspace:GetAttribute("WaitingForPlayers");
            createNotification("Default", "GameState", (typeof(Attribute2) ~= "string" or Attribute2 == "") and "Warmup" or `WAITING FOR PLAYERS ({Attribute2})`, 1);

            return;
        end;

        local v39 = u3 and u3:FindFirstChild("GameState");

        if v39 then
            v39:Destroy();
        end;
    end);
    workspace:GetAttributeChangedSignal("WaitingForPlayers"):Connect(function() -- Line: 283
        -- upvalues: u3 (ref), u1 (ref)
        if workspace:GetAttribute("GameState") ~= "Warmup" then
            return;
        end;

        if u3 and u3:FindFirstChild("GameState") then
            local createNotification = u1.createNotification;
            local Attribute = workspace:GetAttribute("WaitingForPlayers");
            createNotification("Default", "GameState", (typeof(Attribute) ~= "string" or Attribute == "") and "Warmup" or `WAITING FOR PLAYERS ({Attribute})`, 1);
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 293
        -- upvalues: u3 (ref)
        local v40 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

        if v40 then
            v40:Destroy();
        end;
    end);
    GameState.ListenToState(function(p41) -- Line: 298
        -- upvalues: u3 (ref)
        if p41 == "Warmup" then
            local v42 = u3 and u3:FindFirstChild("GameState");

            if v42 then
                v42:Destroy();
            end;
        end;
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 305
        -- upvalues: u3 (ref)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            local v43 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

            if v43 then
                v43:Destroy();
            end;
        end;
    end);

    local function refreshOpenNotifications() -- Line: 312
        -- upvalues: GetPreferenceColor (ref), u3 (ref)
        local v44 = GetPreferenceColor();

        for _, child in ipairs(u3:GetChildren()) do
            if child:IsA("Frame") then
                child.Right.BackgroundColor3 = v44;
                child.Left.BackgroundColor3 = v44;
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshOpenNotifications);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshOpenNotifications);
end;

function u1.Start() -- Line: 329
    -- upvalues: Remotes (copy), u1 (copy), cleanupNotificationTemplate (copy), Router (copy)
    Remotes.UI.ShowNotification.Listen(function(p45) -- Line: 330
        -- upvalues: u1 (ref), cleanupNotificationTemplate (ref)
        local u46 = u1.createNotification("Default", p45.header, p45.message, 2);
        local timeLength = p45.timeLength;
        task.delay(timeLength, function() -- Line: 152
            -- upvalues: u46 (copy), timeLength (copy), cleanupNotificationTemplate (ref)
            if u46 and u46.Parent then
                local v47 = u46;

                if timeLength <= tick() - v47:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v47);
                end;
            end;
        end);
    end);
    Router.observerRouter("CreateNotification", function(p48: string, p49: string, u50: number) -- Line: 335
        -- upvalues: u1 (ref), cleanupNotificationTemplate (ref)
        local u51 = u1.createNotification("Default", p48, p49, 2);
        task.delay(u50, function() -- Line: 152
            -- upvalues: u51 (copy), u50 (copy), cleanupNotificationTemplate (ref)
            if u51 and u51.Parent then
                local v52 = u51;

                if u50 <= tick() - v52:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v52);
                end;
            end;
        end);
    end);
end;

return u1;