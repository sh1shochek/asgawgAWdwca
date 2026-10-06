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

local function destroyNotification(p10: string) -- Line: 84
    -- upvalues: u3 (ref)
    local v11 = u3 and u3:FindFirstChild(p10);

    if v11 then
        v11:Destroy();
    end;
end;

local function getSpawnCardHeader() -- Line: 91
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

local function getHeaderText(p13: boolean) -- Line: 99
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

local function setSpawnCardInvulnerable(p15: boolean) -- Line: 115
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

local function clearSpawnCard() -- Line: 123
    -- upvalues: u3 (ref), u1 (copy)
    local v17 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

    if v17 then
        v17:Destroy();
    end;

    if workspace:GetAttribute("GameState") == "Warmup" then
        u1.createNotification("Default", "GameState", "Warmup", 1);
    end;
end;

local function onCleanup(p18: any, p19: number) -- Line: 135
    -- upvalues: cleanupNotificationTemplate (copy)
    if p19 <= tick() - p18:GetAttribute("Timestamp") then
        cleanupNotificationTemplate(p18);
    end;
end;

local function scheduleCleanup(u20: any, u21: number) -- Line: 142
    -- upvalues: cleanupNotificationTemplate (copy)
    task.delay(u21, function() -- Line: 143
        -- upvalues: u20 (copy), u21 (copy), cleanupNotificationTemplate (ref)
        if u20 and u20.Parent then
            local v22 = u20;

            if u21 <= tick() - v22:GetAttribute("Timestamp") then
                cleanupNotificationTemplate(v22);
            end;
        end;
    end);
end;

function u1.createNotification(p23: any, p24: string, p25: string, p26: number?) -- Line: 153
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

function u1.removeNotification(p31: string) -- Line: 207
    -- upvalues: u3 (ref)
    local v32 = u3 and u3:FindFirstChild(p31);

    if v32 then
        v32:Destroy();
    end;
end;

function u1.Initialize(p33, p34) -- Line: 214
    -- upvalues: u3 (ref), LocalPlayer (copy), u1 (copy), getHeaderText (copy), GetPreferenceColor (copy), Color3_fromRGB_ret (copy), cleanupNotificationTemplate (copy), GameState (copy), DataController (copy)
    u3 = p34;

    local function updateDeathmatchSpawnCard() -- Line: 217
        -- upvalues: LocalPlayer (ref), u3 (ref), u1 (ref), getHeaderText (ref), GetPreferenceColor (ref), Color3_fromRGB_ret (ref)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            return;
        end;

        local v35 = LocalPlayer:GetAttribute("Invincible") == true;

        if not (v35 or LocalPlayer:GetAttribute("BuyMenu")) then
            local v36 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

            if v36 then
                v36:Destroy();
            end;

            if workspace:GetAttribute("GameState") == "Warmup" then
                u1.createNotification("Default", "GameState", "Warmup", 1);
            end;

            return;
        end;

        local GameState2 = u3:FindFirstChild("GameState");
        u1.createNotification("Invulnerable", "Deathmatch Invincibility", "", 0);
        local v37 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

        if v37 then
            v37 = v37:FindFirstChild("Container");
        end;

        if v37 then
            v37 = v37:FindFirstChild("Header");
        end;

        if not (v37 and (v37:IsA("TextLabel") and v37)) then
            v37 = nil;
        end;

        if v37 then
            v37.Text = getHeaderText(v35);
            v37.TextColor3 = v35 and GetPreferenceColor() or Color3_fromRGB_ret;
        end;

        if GameState2 then
            GameState2:Destroy();
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("BuyMenu"):Connect(function() -- Line: 237
        -- upvalues: LocalPlayer (ref), u3 (ref), u1 (ref), cleanupNotificationTemplate (ref)
        local Attribute = workspace:GetAttribute("Gamemode");

        if not LocalPlayer:GetAttribute("BuyMenu") and Attribute == "Deathmatch" then
            if not LocalPlayer:GetAttribute("Invincible") then
                local v38 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

                if v38 then
                    v38:Destroy();
                end;

                if workspace:GetAttribute("GameState") == "Warmup" then
                    u1.createNotification("Default", "GameState", "Warmup", 1);
                end;
            end;

            local u39 = u1.createNotification("Default", "Your buy period has expired", "Your buy period has expired", 2);
            task.delay(2, function() -- Line: 246
                -- upvalues: u39 (copy), cleanupNotificationTemplate (ref)
                if u39 and u39.Parent then
                    cleanupNotificationTemplate(u39);
                end;
            end);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("Invincible"):Connect(updateDeathmatchSpawnCard);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 257
        -- upvalues: updateDeathmatchSpawnCard (copy), u3 (ref), u1 (ref)
        local Attribute = workspace:GetAttribute("GameState");

        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            updateDeathmatchSpawnCard();

            return;
        end;

        local v40 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

        if v40 then
            v40:Destroy();
        end;

        if Attribute == "Warmup" then
            u1.createNotification("Default", "GameState", "Warmup", 1);

            return;
        end;

        local v41 = u3 and u3:FindFirstChild("GameState");

        if v41 then
            v41:Destroy();
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 274
        -- upvalues: u3 (ref)
        local v42 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

        if v42 then
            v42:Destroy();
        end;
    end);
    GameState.ListenToState(function(p43) -- Line: 279
        -- upvalues: u3 (ref)
        if p43 == "Warmup" then
            local v44 = u3 and u3:FindFirstChild("GameState");

            if v44 then
                v44:Destroy();
            end;
        end;
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 286
        -- upvalues: u3 (ref)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            local v45 = u3 and u3:FindFirstChild("Deathmatch Invincibility");

            if v45 then
                v45:Destroy();
            end;
        end;
    end);

    local function refreshOpenNotifications() -- Line: 293
        -- upvalues: GetPreferenceColor (ref), u3 (ref)
        local v46 = GetPreferenceColor();

        for _, child in ipairs(u3:GetChildren()) do
            if child:IsA("Frame") then
                child.Right.BackgroundColor3 = v46;
                child.Left.BackgroundColor3 = v46;
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshOpenNotifications);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshOpenNotifications);
end;

function u1.Start() -- Line: 310
    -- upvalues: Remotes (copy), u1 (copy), cleanupNotificationTemplate (copy), Router (copy)
    Remotes.UI.ShowNotification.Listen(function(p47) -- Line: 311
        -- upvalues: u1 (ref), cleanupNotificationTemplate (ref)
        local u48 = u1.createNotification("Default", p47.header, p47.message, 2);
        local timeLength = p47.timeLength;
        task.delay(timeLength, function() -- Line: 143
            -- upvalues: u48 (copy), timeLength (copy), cleanupNotificationTemplate (ref)
            if u48 and u48.Parent then
                local v49 = u48;

                if timeLength <= tick() - v49:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v49);
                end;
            end;
        end);
    end);
    Router.observerRouter("CreateNotification", function(p50: string, p51: string, u52: number) -- Line: 316
        -- upvalues: u1 (ref), cleanupNotificationTemplate (ref)
        local u53 = u1.createNotification("Default", p50, p51, 2);
        task.delay(u52, function() -- Line: 143
            -- upvalues: u53 (copy), u52 (copy), cleanupNotificationTemplate (ref)
            if u53 and u53.Parent then
                local v54 = u53;

                if u52 <= tick() - v54:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v54);
                end;
            end;
        end);
    end);
end;

return u1;