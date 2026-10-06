-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local AnimateDashboardCard = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateDashboardCard);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Store = require(ReplicatedStorage.Interface.Screens.Menu.Store);
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
local TutorialPrompt = require(ReplicatedStorage.Interface.Screens.Menu.TutorialPrompt);
local UpdateLogs = require(ReplicatedStorage.Database.Custom.UpdateLogs);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local EditMobile = require(script:WaitForChild("EditMobile"));
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(201, 201, 201);
local Color3_fromRGB_ret3 = Color3.fromRGB(50, 46, 46);
local Color3_fromRGB_ret4 = Color3.fromRGB(50, 46, 46);
local u5 = nil;

local function SetupNewsSection(p6: userdata) -- Line: 60
    -- upvalues: UpdateLogs (copy), ActivateButton (copy), Router (copy), u5 (ref)
    local Container = p6.Container;
    local Information = Container.Bottom.Container.Information;
    local v7 = UpdateLogs[1];
    Container.ImageContent.Image.Image = v7.Banner;
    Information.Label.Text = v7.Title;
    Information.Description.Text = v7.Date;
    local Button = Information.Buttons.Button;
    ActivateButton(Button);
    Button.Title.Text = "View Updates";
    Button.MouseButton1Click:Connect(function() -- Line: 72
        -- upvalues: Router (ref), u5 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u5.Parent.UpdateLog.Visible = true;
    end);
end;

local function SetupFeaturedSection(p8: userdata) -- Line: 80
    -- upvalues: u3 (ref), u2 (ref), DataController (copy), LocalPlayer (copy), Store (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), Router (copy), ActivateButton (copy), Top (copy), MenuState (copy), u4 (ref)
    local Container = p8.Container;
    local u9 = {
        {
            Destination = "Bundle",
            Frame = Container.CurrentBundle
        },
        {
            Destination = "StarterPack",
            Frame = Container.StarterPack
        }
    };
    u3 = Container.CurrentBundle;
    u2 = Container.StarterPack;
    local u10 = 1;

    for i, v in ipairs(u9) do
        if v.Frame.Visible then
            u10 = i;
            break;
        end;
    end;

    local Buttons = Container.Bottom.Buttons;
    local Left = Buttons.Left;
    local Right = Buttons.Right;

    local function IsPageAvailable(p11: number) -- Line: 101
        -- upvalues: u9 (copy), DataController (ref), LocalPlayer (ref), Store (ref)
        return u9[p11].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable());
    end;

    local function FindAvailablePage(p12: number, p13: number) -- Line: 110
        -- upvalues: u9 (copy), DataController (ref), LocalPlayer (ref), Store (ref)
        while p12 >= 1 and p12 <= #u9 do
            if u9[p12].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable()) then
                return p12;
            end;

            p12 = p12 + p13;
        end;

        return nil;
    end;

    local function UpdateFeaturedPage() -- Line: 121
        -- upvalues: u10 (ref), u9 (copy), DataController (ref), LocalPlayer (ref), Store (ref), FindAvailablePage (copy), Left (copy), Color3_fromRGB_ret (ref), Color3_fromRGB_ret4 (ref), Right (copy), Buttons (copy), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret3 (ref)
        if u9[u10].Destination == "StarterPack" and (DataController.IsDataLoaded(LocalPlayer) and not Store.IsStarterPackAvailable()) then
            u10 = FindAvailablePage(u10 + 1, 1) or (FindAvailablePage(u10 - 1, -1) or u10);
        end;

        for i, v in ipairs(u9) do
            local Frame = v.Frame;
            local v14 = (u9[i].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable())) and i == u10;
            Frame.Visible = v14;
        end;

        Left.ImageColor3 = FindAvailablePage(u10 - 1, -1) and Color3_fromRGB_ret or Color3_fromRGB_ret4;
        Right.ImageColor3 = FindAvailablePage(u10 + 1, 1) and Color3_fromRGB_ret or Color3_fromRGB_ret4;

        for i = 1, #u9 do
            local v15 = Buttons:FindFirstChild((tostring(i)));
            local v16;

            if v15 and v15:IsA("Frame") then
                v15.Visible = u9[i].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable());
                v15.BackgroundColor3 = i == u10 and Color3_fromRGB_ret2 or Color3_fromRGB_ret3;
                v16 = i;
            else
                v16 = i;
            end;
        end;
    end;

    for i, v in {
        [Left] = -1,
        [Right] = 1
    } do
        i.MouseButton1Click:Connect(function() -- Line: 147
            -- upvalues: FindAvailablePage (copy), u10 (ref), v (copy), Router (ref), UpdateFeaturedPage (copy)
            local v17 = FindAvailablePage(u10 + v, v);

            if not v17 then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u10 = v17;
            UpdateFeaturedPage();
        end);
    end;

    for _, v in ipairs(u9) do
        local View = v.Frame.Interact.View;
        ActivateButton(View);
        View.MouseButton1Click:Connect(function() -- Line: 162
            -- upvalues: Router (ref), Top (ref), MenuState (ref), v (copy), Store (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Top.openFrame("Store");

            if MenuState.GetCurrentScreen() ~= "Store" then
                return;
            end;

            if v.Destination == "StarterPack" then
                Store.OpenBundleSection();

                return;
            end;

            Store.OpenFeaturedBundleSection();
        end);
    end;

    u4 = UpdateFeaturedPage;
    UpdateFeaturedPage();
end;

local function SetupToggleCollapse(u18: userdata, p19: userdata, p20: boolean?) -- Line: 183
    -- upvalues: TweenService (copy), ActivateButton (copy)
    local u21 = p19:FindFirstChildOfClass("TextLabel");
    local u22 = false;
    local Scale = u18.Size.X.Scale;
    local Position = u18.Position;
    local BackgroundTransparency = u18.BackgroundTransparency;
    local v23;

    if p20 then
        v23 = Position.X.Scale - Scale - 0.04;
    else
        v23 = Position.X.Scale + Scale + 0.04;
    end;

    local UDim2_new_ret = UDim2.new(v23, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
    local u24 = p20 and "<" or ">";
    local u25 = p20 and ">" or "<";

    local function SetVisibleState(p26: boolean) -- Line: 204
        -- upvalues: u18 (copy), BackgroundTransparency (copy)
        for _, child in u18:GetChildren() do
            if child:IsA("GuiObject") then
                child.Visible = p26;
            elseif child:IsA("UIStroke") or (child:IsA("UIGradient") or child:IsA("UIShadow")) then
                child.Enabled = p26;
            end;
        end;

        u18.BackgroundTransparency = not p26 and 1 or BackgroundTransparency;
    end;

    local function UpdateCollapseState() -- Line: 216
        -- upvalues: u21 (copy), u22 (ref), u25 (copy), u24 (copy), TweenService (ref), u18 (copy), UDim2_new_ret (copy), Position (copy), SetVisibleState (copy)
        if u21 then
            local v27;

            if u22 then
                v27 = u25;
            else
                v27 = u24;
            end;

            u21.Text = v27;
        end;

        local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v28 = {};
        local v29;

        if u22 then
            v29 = UDim2_new_ret;
        else
            v29 = Position;
        end;

        v28.Position = v29;
        local v30 = TweenService:Create(u18, TweenInfo_new_ret, v28);

        if u22 then
            v30.Completed:Once(function() -- Line: 226
                -- upvalues: SetVisibleState (ref)
                SetVisibleState(false);
            end);
        else
            SetVisibleState(true);
        end;

        v30:Play();
    end;

    UpdateCollapseState();
    ActivateButton(p19);
    p19.Activated:Connect(function() -- Line: 238
        -- upvalues: u22 (ref), UpdateCollapseState (copy)
        u22 = not u22;
        UpdateCollapseState();
    end);
end;

local function SetupToggleCollapses(p31: userdata, p32: boolean?) -- Line: 246
    -- upvalues: SetupToggleCollapse (copy)
    for _, v in p31:QueryDescendants("#ToggleCollapsed") do
        if v:IsA("GuiButton") then
            local v33 = v:FindFirstAncestorWhichIsA("GuiObject");

            if v33 then
                SetupToggleCollapse(v33, v, p32);
            end;
        end;
    end;
end;

local function SetupLeftDashboard(p34: userdata) -- Line: 261
    -- upvalues: SetupNewsSection (copy), SetupFeaturedSection (copy), SetupToggleCollapses (copy)
    SetupNewsSection((p34:WaitForChild("News")));
    SetupFeaturedSection((p34:WaitForChild("Featured")));
    SetupToggleCollapses(p34, true);
end;

local function SetupTutorialCard(u35: userdata) -- Line: 270
    -- upvalues: AnimateDashboardCard (copy), TutorialPrompt (copy), Constants (copy), IsTutorialMode (copy), DataController (copy), LocalPlayer (copy)
    local Button = u35:FindFirstChild("Button");

    if Button then
        AnimateDashboardCard(u35, Button);
        Button.MouseButton1Click:Connect(TutorialPrompt.RequestTeleport);
    end;

    local function updateVisibility() -- Line: 277
        -- upvalues: u35 (copy), Constants (ref), IsTutorialMode (ref), DataController (ref), LocalPlayer (ref)
        local v36 = Constants.TUTORIAL_TELEPORT_ENABLED and not IsTutorialMode() and DataController.Get(LocalPlayer, "TutorialCompleted") ~= true;
        u35.Visible = v36;
    end;

    DataController.CreateListener(LocalPlayer, "TutorialCompleted", updateVisibility);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(updateVisibility);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateVisibility);
    local v37 = Constants.TUTORIAL_TELEPORT_ENABLED and not IsTutorialMode() and DataController.Get(LocalPlayer, "TutorialCompleted") ~= true;
    u35.Visible = v37;
end;

local function UpdateStarterPackTimer() -- Line: 290
    -- upvalues: DataController (copy), LocalPlayer (copy), Store (copy), FormatDuration (copy), u4 (ref), u2 (ref)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return;
    end;

    local v38;

    if Store.IsStarterPackAvailable() then
        v38 = math.max(0, Store.GetStarterPackRemainingSeconds());

        if v38 <= 0 then
            v38 = Store.GetStarterPackWindowSeconds();
        end;
    else
        v38 = 0;
    end;

    local v39 = FormatDuration(v38, "Never");

    if u4 then
        u4();
    end;

    if u2 then
        u2.Extra.Title.Top.Timer.Text = v39;
    end;
end;

local function UpdateCurrentBundleTimer() -- Line: 315
    -- upvalues: u3 (ref), Store (copy)
    if u3 then
        u3.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText();
    end;
end;

local function SetupDashboardHeartbeat() -- Line: 323
    -- upvalues: RunServiceController (copy), u5 (ref), Profiler (copy), UpdateStarterPackTimer (copy), u3 (ref), Store (copy)
    local u40 = 1;
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function(p41: number) -- Line: 325
        -- upvalues: u5 (ref), u40 (ref), Profiler (ref), UpdateStarterPackTimer (ref), u3 (ref), Store (ref)
        if not u5.Visible then
            u40 = 1;

            return;
        end;

        u40 = u40 + p41;

        if u40 < 1 then
            return;
        end;

        u40 = u40 % 1;
        Profiler.mark("UI.Dashboard.Heartbeat");
        UpdateStarterPackTimer();

        if u3 then
            u3.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText();
        end;
    end);
end;

function v1.Initialize(p42, p43) -- Line: 345
    -- upvalues: Profiler (copy), u5 (ref), EditMobile (copy), SetupNewsSection (copy), SetupFeaturedSection (copy), SetupToggleCollapses (copy), SetupTutorialCard (copy)
    Profiler.mark("UI.Dashboard.Initialize");
    u5 = p43;
    EditMobile.Initialize(p42, u5);
    local Left = u5.Left;
    SetupNewsSection((Left:WaitForChild("News")));
    SetupFeaturedSection((Left:WaitForChild("Featured")));
    SetupToggleCollapses(Left, true);
    local Tutorial = u5:FindFirstChild("Tutorial");

    if Tutorial and Tutorial:IsA("Frame") then
        SetupTutorialCard(Tutorial);
    end;
end;

function v1.Start() -- Line: 362
    -- upvalues: Profiler (copy), RunServiceController (copy), u5 (ref), UpdateStarterPackTimer (copy), u3 (ref), Store (copy)
    debug.setmemorycategory("UI.Dashboard.Start");
    Profiler.mark("UI.Dashboard.Start");
    local u44 = 1;
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function(p45: number) -- Line: 325
        -- upvalues: u5 (ref), u44 (ref), Profiler (ref), UpdateStarterPackTimer (ref), u3 (ref), Store (ref)
        if not u5.Visible then
            u44 = 1;

            return;
        end;

        u44 = u44 + p45;

        if u44 < 1 then
            return;
        end;

        u44 = u44 % 1;
        Profiler.mark("UI.Dashboard.Heartbeat");
        UpdateStarterPackTimer();

        if u3 then
            u3.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText();
        end;
    end);
end;

return v1;