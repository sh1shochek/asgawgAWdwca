-- ReplicatedStorage.Interface.Screens.Menu.Dashboard
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Dashboard
-- Decompile time: 11.90 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
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
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local EditMobile = require(script:WaitForChild("EditMobile"));
local Halloween = require(script:WaitForChild("Halloween"));
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(201, 201, 201);
local Color3_fromRGB_ret3 = Color3.fromRGB(50, 46, 46);
local Color3_fromRGB_ret4 = Color3.fromRGB(50, 46, 46);
local TweenInfo_new_ret = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
local UDim2_fromScale_ret = UDim2.fromScale(0.01, 0.015);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.98, 0.82);
local u6 = nil;

local function SetupNewsSection(p7: userdata) -- Line: 77
    p7.Visible = false;
end;

local function OpenFeaturedPromotion(p8: string) -- Line: 102
    -- upvalues: Router (copy), Top (copy), MenuState (copy), Store (copy)
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    Top.openFrame("Store");

    if MenuState.GetCurrentScreen() ~= "Store" then
        return;
    end;

    if p8 ~= "StarterPack" then
        Store.OpenFeaturedBundleSection();

        return;
    end;

    Store.OpenBundleSection();
    Store.PromptStarterPackPurchase();
end;

local function CreateFeaturedHitbox(p9: userdata, u10: string) -- Line: 121
    -- upvalues: UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), Router (copy), OpenFeaturedPromotion (copy)
    local Interact = p9:FindFirstChild("Interact");

    if Interact then
        Interact = Interact:FindFirstChild("View");
    end;

    if Interact and Interact:IsA("GuiButton") then
        Interact.Selectable = false;
    end;

    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Hitbox";
    TextButton.Text = "";
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.Position = UDim2_fromScale_ret;
    TextButton.Size = UDim2_fromScale_ret2;
    TextButton.ZIndex = 10;
    TextButton.Parent = p9;

    local function hover() -- Line: 139
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
    end;

    TextButton.MouseEnter:Connect(hover);
    TextButton.SelectionGained:Connect(hover);
    TextButton.Activated:Connect(function() -- Line: 144
        -- upvalues: OpenFeaturedPromotion (ref), u10 (copy)
        OpenFeaturedPromotion(u10);
    end);
end;

local function SetupFeaturedSection(u11: userdata) -- Line: 151
    -- upvalues: u3 (ref), u2 (ref), CreateFeaturedHitbox (copy), DataController (copy), LocalPlayer (copy), Store (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), TweenService (copy), TweenInfo_new_ret (copy), GuiService (copy), UserInputService (copy), Router (copy), u5 (ref), u4 (ref)
    local Container = u11.Container;
    local u12 = {
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
    Container.ClipsDescendants = true;
    local Position = Container.CurrentBundle.Position;
    local u13 = 1;

    for i, v in ipairs(u12) do
        if v.Frame.Visible then
            u13 = i;
            break;
        end;
    end;

    local Buttons = Container.Bottom.Buttons;
    local Left = Buttons.Left;
    local Right = Buttons.Right;
    local u14 = {};
    local u15 = 0;
    local u16 = nil;

    for _, v in ipairs(u12) do
        CreateFeaturedHitbox(v.Frame, v.Destination);
    end;

    local function IsPageAvailable(p17: number) -- Line: 184
        -- upvalues: u12 (copy), DataController (ref), LocalPlayer (ref), Store (ref)
        return u12[p17].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackShown());
    end;

    local function FindNextPage(p18: number) -- Line: 194
        -- upvalues: u12 (copy), u13 (ref), DataController (ref), LocalPlayer (ref), Store (ref)
        for i = 1, #u12 - 1 do
            local v19 = (u13 - 1 + p18 * i) % #u12 + 1;

            if u12[v19].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackShown()) then
                return v19;
            end;

            local _ = i;
        end;

        return nil;
    end;

    local function UpdateFeaturedPage() -- Line: 204
        -- upvalues: u13 (ref), u12 (copy), DataController (ref), LocalPlayer (ref), Store (ref), FindNextPage (copy), u16 (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret4 (ref), Left (copy), Right (copy), Buttons (copy), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret3 (ref)
        if u12[u13].Destination == "StarterPack" and (DataController.IsDataLoaded(LocalPlayer) and not Store.IsStarterPackShown()) then
            u13 = FindNextPage(1) or u13;
        end;

        for i, v in ipairs(u12) do
            if v.Frame ~= u16 then
                local Frame = v.Frame;
                local v20 = (u12[i].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackShown())) and i == u13;
                Frame.Visible = v20;
            end;
        end;

        local v21;

        if FindNextPage(1) then
            v21 = Color3_fromRGB_ret;
        else
            v21 = Color3_fromRGB_ret4;
        end;

        Left.ImageColor3 = v21;
        Right.ImageColor3 = v21;

        for i = 1, #u12 do
            local v22 = Buttons:FindFirstChild((tostring(i)));
            local v23;

            if v22 and v22:IsA("Frame") then
                v22.Visible = u12[i].Destination ~= "StarterPack" and true or (not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackShown());
                v22.BackgroundColor3 = i == u13 and Color3_fromRGB_ret2 or Color3_fromRGB_ret3;
                v23 = i;
            else
                v23 = i;
            end;
        end;
    end;

    local function settleOutgoingPage() -- Line: 228
        -- upvalues: u16 (ref), Position (copy)
        if u16 then
            u16.Visible = false;
            u16.Position = Position;
            u16 = nil;
        end;
    end;

    local function ShowPage(p24: number, p25: number) -- Line: 237
        -- upvalues: u15 (ref), u13 (ref), u14 (ref), u16 (ref), Position (copy), u12 (copy), UpdateFeaturedPage (copy), TweenService (ref), TweenInfo_new_ret (ref)
        u15 = 0;

        if p24 == u13 then
            return;
        end;

        for _, v in u14 do
            v:Cancel();
        end;

        if u16 then
            u16.Visible = false;
            u16.Position = Position;
            u16 = nil;
        end;

        local Frame = u12[u13].Frame;
        local Frame2 = u12[p24].Frame;
        u16 = Frame;
        u13 = p24;
        Frame2.Position = Position + UDim2.fromScale(p25, 0);
        UpdateFeaturedPage();
        local v26 = TweenService:Create(Frame, TweenInfo_new_ret, {
            Position = Position - UDim2.fromScale(p25, 0)
        });
        u14 = { v26, TweenService:Create(Frame2, TweenInfo_new_ret, {
                Position = Position
            }) };
        v26.Completed:Once(function(p27) -- Line: 261
            -- upvalues: u16 (ref), Frame (copy), Position (ref)
            if p27 == Enum.PlaybackState.Completed and (u16 == Frame and u16) then
                u16.Visible = false;
                u16.Position = Position;
                u16 = nil;
            end;
        end);

        for _, v in u14 do
            v:Play();
        end;
    end;

    local u28 = u11:FindFirstAncestorWhichIsA("ScreenGui");

    local function IsPanelHeld() -- Line: 273
        -- upvalues: GuiService (ref), u11 (copy), UserInputService (ref), u28 (copy)
        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject and SelectedObject:IsDescendantOf(u11) then
            return true;
        end;

        local MouseLocation = UserInputService:GetMouseLocation();

        if u28 and not u28.IgnoreGuiInset then
            MouseLocation = MouseLocation - GuiService:GetGuiInset();
        end;

        local AbsolutePosition = u11.AbsolutePosition;
        local AbsoluteSize = u11.AbsoluteSize;
        local v29;

        if MouseLocation.X >= AbsolutePosition.X and (MouseLocation.Y >= AbsolutePosition.Y and MouseLocation.X <= AbsolutePosition.X + AbsoluteSize.X) then
            v29 = MouseLocation.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v29 = false;
        end;

        return v29;
    end;

    for i, v in {
        [Left] = -1,
        [Right] = 1
    } do
        i.MouseButton1Click:Connect(function() -- Line: 290
            -- upvalues: FindNextPage (copy), v (copy), Router (ref), ShowPage (copy)
            local v30 = FindNextPage(v);

            if not v30 then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            ShowPage(v30, v);
        end);
    end;

    u5 = {
        Tick = function(p31: number) -- Line: 301, Name: Tick
            -- upvalues: Container (copy), u15 (ref), IsPanelHeld (copy), FindNextPage (copy), ShowPage (copy)
            if not Container.Visible then
                return;
            end;

            u15 = u15 + p31;

            if u15 < 7 or IsPanelHeld() then
                return;
            end;

            local v32 = FindNextPage(1);

            if v32 then
                ShowPage(v32, 1);

                return;
            end;

            u15 = 0;
        end,

        Reset = function() -- Line: 318, Name: Reset
            -- upvalues: u15 (ref)
            u15 = 0;
        end
    };
    u4 = UpdateFeaturedPage;
    UpdateFeaturedPage();
end;

local function SetupToggleCollapse(u33: userdata, p34: userdata, p35: boolean?) -- Line: 329
    -- upvalues: TweenService (copy), ActivateButton (copy)
    local u36 = p34:FindFirstChildOfClass("TextLabel");
    local u37 = false;
    local Scale = u33.Size.X.Scale;
    local Position = u33.Position;
    local BackgroundTransparency = u33.BackgroundTransparency;
    local v38;

    if p35 then
        v38 = Position.X.Scale - Scale - 0.04;
    else
        v38 = Position.X.Scale + Scale + 0.04;
    end;

    local UDim2_new_ret = UDim2.new(v38, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
    local u39 = p35 and "<" or ">";
    local u40 = p35 and ">" or "<";

    local function SetVisibleState(p41: boolean) -- Line: 350
        -- upvalues: u33 (copy), BackgroundTransparency (copy)
        for _, child in u33:GetChildren() do
            if child:IsA("GuiObject") then
                child.Visible = p41;
            elseif child:IsA("UIStroke") or (child:IsA("UIGradient") or child:IsA("UIShadow")) then
                child.Enabled = p41;
            end;
        end;

        u33.BackgroundTransparency = not p41 and 1 or BackgroundTransparency;
    end;

    local function UpdateCollapseState() -- Line: 362
        -- upvalues: u36 (copy), u37 (ref), u40 (copy), u39 (copy), TweenService (ref), u33 (copy), UDim2_new_ret (copy), Position (copy), SetVisibleState (copy)
        if u36 then
            local v42;

            if u37 then
                v42 = u40;
            else
                v42 = u39;
            end;

            u36.Text = v42;
        end;

        local TweenInfo_new_ret2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v43 = {};
        local v44;

        if u37 then
            v44 = UDim2_new_ret;
        else
            v44 = Position;
        end;

        v43.Position = v44;
        local v45 = TweenService:Create(u33, TweenInfo_new_ret2, v43);

        if u37 then
            v45.Completed:Once(function() -- Line: 372
                -- upvalues: SetVisibleState (ref)
                SetVisibleState(false);
            end);
        else
            SetVisibleState(true);
        end;

        v45:Play();
    end;

    UpdateCollapseState();
    ActivateButton(p34);
    p34.Activated:Connect(function() -- Line: 384
        -- upvalues: u37 (ref), UpdateCollapseState (copy)
        u37 = not u37;
        UpdateCollapseState();
    end);
end;

local function SetupToggleCollapses(p46: userdata, p47: boolean?) -- Line: 392
    -- upvalues: SetupToggleCollapse (copy)
    for _, v in p46:QueryDescendants("#ToggleCollapsed") do
        if v:IsA("GuiButton") then
            local v48 = v:FindFirstAncestorWhichIsA("GuiObject");

            if v48 then
                SetupToggleCollapse(v48, v, p47);
            end;
        end;
    end;
end;

local function SetupLeftDashboard(p49: userdata) -- Line: 407
    -- upvalues: SetupFeaturedSection (copy), SetupToggleCollapses (copy)
    p49:WaitForChild("News").Visible = false;
    SetupFeaturedSection((p49:WaitForChild("Featured")));
    SetupToggleCollapses(p49, true);
end;

local function SetupTutorialCard(u50: userdata) -- Line: 416
    -- upvalues: AnimateDashboardCard (copy), TutorialPrompt (copy), Constants (copy), IsTutorialMode (copy), DataController (copy), LocalPlayer (copy)
    local Button = u50:FindFirstChild("Button");

    if Button then
        AnimateDashboardCard(u50, Button);
        Button.MouseButton1Click:Connect(TutorialPrompt.RequestTeleport);
    end;

    local function updateVisibility() -- Line: 423
        -- upvalues: u50 (copy), Constants (ref), IsTutorialMode (ref), DataController (ref), LocalPlayer (ref)
        local v51 = Constants.TUTORIAL_ENABLED and not IsTutorialMode() and DataController.Get(LocalPlayer, "TutorialCompleted") ~= true;
        u50.Visible = v51;
    end;

    DataController.CreateListener(LocalPlayer, "TutorialCompleted", updateVisibility);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(updateVisibility);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateVisibility);
    local v52 = Constants.TUTORIAL_ENABLED and not IsTutorialMode() and DataController.Get(LocalPlayer, "TutorialCompleted") ~= true;
    u50.Visible = v52;
end;

local function UpdateStarterPackTimer() -- Line: 436
    -- upvalues: DataController (copy), LocalPlayer (copy), Store (copy), FormatDuration (copy), u4 (ref), u2 (ref)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return;
    end;

    local v53;

    if Store.IsStarterPackAvailable() then
        v53 = math.max(0, Store.GetStarterPackRemainingSeconds());

        if v53 <= 0 then
            v53 = Store.GetStarterPackWindowSeconds();
        end;
    else
        v53 = 0;
    end;

    local v54 = FormatDuration(v53, "Never");

    if u4 then
        u4();
    end;

    if u2 then
        u2.Extra.Title.Top.Timer.Text = v54;
    end;
end;

local function UpdateCurrentBundleTimer() -- Line: 461
    -- upvalues: u3 (ref), Store (copy)
    if u3 then
        u3.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText();
    end;
end;

local function SetupDashboardHeartbeat() -- Line: 469
    -- upvalues: RunServiceController (copy), u6 (ref), u5 (ref), Profiler (copy), UpdateStarterPackTimer (copy), u3 (ref), Store (copy)
    local u55 = 1;
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function(p56: number) -- Line: 471
        -- upvalues: u6 (ref), u55 (ref), u5 (ref), Profiler (ref), UpdateStarterPackTimer (ref), u3 (ref), Store (ref)
        if not u6.Visible then
            u55 = 1;

            if u5 then
                u5.Reset();
            end;

            return;
        end;

        if u5 then
            u5.Tick(p56);
        end;

        u55 = u55 + p56;

        if u55 < 1 then
            return;
        end;

        u55 = u55 % 1;
        Profiler.mark("UI.Dashboard.Heartbeat");
        UpdateStarterPackTimer();

        if u3 then
            u3.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText();
        end;
    end);
end;

function v1.Initialize(p57, p58) -- Line: 498
    -- upvalues: Profiler (copy), u6 (ref), EditMobile (copy), SetupFeaturedSection (copy), SetupToggleCollapses (copy), SetupTutorialCard (copy), Halloween (copy)
    Profiler.mark("UI.Dashboard.Initialize");
    u6 = p58;
    EditMobile.Initialize(p57, u6);
    local Left = u6.Left;
    Left:WaitForChild("News").Visible = false;
    SetupFeaturedSection((Left:WaitForChild("Featured")));
    SetupToggleCollapses(Left, true);
    local Tutorial = Left:FindFirstChild("Tutorial");

    if Tutorial and Tutorial:IsA("Frame") then
        SetupTutorialCard(Tutorial);
    end;

    local Halloween2 = u6:FindFirstChild("Halloween");

    if Halloween2 and Halloween2:IsA("Frame") then
        Halloween.Initialize(Halloween2);
    end;
end;

function v1.Start() -- Line: 521
    -- upvalues: Profiler (copy), RunServiceController (copy), u6 (ref), u5 (ref), UpdateStarterPackTimer (copy), u3 (ref), Store (copy)
    debug.setmemorycategory("UI.Dashboard.Start");
    Profiler.mark("UI.Dashboard.Start");
    local u59 = 1;
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function(p60: number) -- Line: 471
        -- upvalues: u6 (ref), u59 (ref), u5 (ref), Profiler (ref), UpdateStarterPackTimer (ref), u3 (ref), Store (ref)
        if not u6.Visible then
            u59 = 1;

            if u5 then
                u5.Reset();
            end;

            return;
        end;

        if u5 then
            u5.Tick(p60);
        end;

        u59 = u59 + p60;

        if u59 < 1 then
            return;
        end;

        u59 = u59 % 1;
        Profiler.mark("UI.Dashboard.Heartbeat");
        UpdateStarterPackTimer();

        if u3 then
            u3.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText();
        end;
    end);
end;

return v1;