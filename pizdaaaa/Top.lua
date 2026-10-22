-- ReplicatedStorage.Interface.Screens.Menu.Top
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Top
-- Decompile time: 24.26 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);
local workspace_CurrentCamera = workspace.CurrentCamera;
local BlurEffect = Instance.new("BlurEffect", Lighting);
BlurEffect.Enabled = false;
BlurEffect.Name = "Menu";
BlurEffect.Size = 20;
local u2 = false;
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = 0;
local u12 = nil;
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(150, 220, 239);
local Color3_fromRGB_ret3 = Color3.fromRGB(175, 175, 175);
local u13 = nil;
local u14 = nil;

local function tweenButton(p15: any, p16) -- Line: 96
    -- upvalues: TweenService (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    if p15:IsA("ImageButton") then
        TweenService:Create(p15, TweenInfo.new(0.15), {
            ImageColor3 = p16
        }):Play();

        return;
    end;

    if p15:IsA("TextButton") then
        local v17 = p15:GetAttribute("DefaultSize") or p15.Size;
        local v18 = p16 == Color3_fromRGB_ret2 and 1.12 or (p16 == Color3_fromRGB_ret3 and 1.06 or 1);
        TweenService:Create(p15, TweenInfo.new(0.15), {
            Size = UDim2.new(v17.X.Scale * v18, v17.X.Offset * v18, v17.Y.Scale * v18, v17.Y.Offset * v18)
        }):Play();
    end;
end;

local function animateBlackmarketButton(p19: userdata, u20: function) -- Line: 124
    -- upvalues: RunServiceController (copy), GuiService (copy)
    local Icon = p19:FindFirstChild("Icon");

    if not Icon then
        return;
    end;

    local Position = Icon.Position;
    local Rotation = Icon.Rotation;
    local u21 = false;
    local u22 = 0;
    p19.MouseEnter:Connect(function() -- Line: 135
        -- upvalues: u21 (ref)
        u21 = true;
    end);
    p19.MouseLeave:Connect(function() -- Line: 138
        -- upvalues: u21 (ref)
        u21 = false;
    end);
    RunServiceController.BindToRenderStep("UI.Top.BlackmarketButton", function(p23: number) -- Line: 142
        -- upvalues: u20 (copy), GuiService (ref), Icon (copy), Position (copy), Rotation (copy), u21 (ref), u22 (ref)
        if not u20() then
            return;
        end;

        if GuiService.ReducedMotionEnabled then
            Icon.Position = Position;
            Icon.Rotation = Rotation;

            return;
        end;

        u22 = u22 + ((u21 and 1 or 0) - u22) * (1 - math.exp(p23 * -14));
        local v24 = os.clock() * 1.4;
        Icon.Position = Position + UDim2.fromScale(0, math.sin(v24) * 0.035);
        Icon.Rotation = Rotation + math.cos(v24) * 2 + u22 * -8;
    end);
end;

local u25 = nil;

local function fitTopButtonsBesideTabs() -- Line: 173
    -- upvalues: u13 (ref), u14 (ref), u25 (ref)
    local Buttons = u13.Top.Buttons;
    local Store = u14.Menu:FindFirstChild("Store");

    if Store then
        Store = Store:FindFirstChild("Top");
    end;

    if Store then
        Store = Store:FindFirstChild("Categories");
    end;

    local v26 = u25;

    if not (Store and v26) then
        return;
    end;

    if Store:IsA("GuiObject") and not Store.Visible then
        Buttons.Size = UDim2.new(Buttons.Size.X, v26);

        return;
    end;

    local v27 = (-1 / 0);

    for _, child in Store:GetChildren() do
        if child:IsA("GuiObject") and child.Visible then
            v27 = math.max(v27, child.AbsolutePosition.X + child.AbsoluteSize.X);
        end;
    end;

    local v28 = 0;
    local v29 = 0;

    for _, child in Buttons:GetChildren() do
        if child:IsA("GuiButton") and child.Visible then
            v28 = v28 + 1;
            v29 = math.max(v29, child.Size.Y.Scale);
        end;
    end;

    local Y = Buttons.Parent.AbsoluteSize.Y;

    if v27 == (-1 / 0) or (v28 == 0 or (v29 <= 0 or Y <= 0)) then
        return;
    end;

    local X = Buttons.AbsoluteSize.X;
    local v30 = Buttons:FindFirstChildOfClass("UIPadding");
    local v31 = Buttons:FindFirstChildOfClass("UIListLayout");
    local v32 = Buttons.AbsolutePosition.X + X - (not v30 and 0 or v30.PaddingRight.Scale * X + v30.PaddingRight.Offset) - (v27 + 8) - (not v31 and 0 or v31.Padding.Scale * X + v31.Padding.Offset) * (v28 - 1);
    local v33 = v29 * math.min(X, v26.Scale * Y + v26.Offset);
    local math_clamp_ret = math.clamp(v32 / v28 / v33, 0, 1);
    Buttons.Size = UDim2.new(Buttons.Size.X, UDim.new(v26.Scale * math_clamp_ret, v26.Offset * math_clamp_ret));
end;

local function setupButton(u34) -- Line: 229
    -- upvalues: Color3_fromRGB_ret (copy), u8 (ref), tweenButton (copy), Router (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy)
    for _, descendant in ipairs(u34:GetDescendants()) do
        if descendant:IsA("GuiObject") and (not descendant:IsA("GuiButton") and descendant.Active) then
            descendant.Active = false;
        end;
    end;

    if u34:IsA("ImageButton") then
        u34.ImageColor3 = Color3_fromRGB_ret;
    elseif u34:IsA("TextButton") then
        u34.TextLabel.TextColor3 = Color3_fromRGB_ret;
        u34:SetAttribute("DefaultSize", u34.Size);
    end;

    u34.MouseLeave:Connect(function() -- Line: 244
        -- upvalues: u8 (ref), u34 (copy), tweenButton (ref), Color3_fromRGB_ret (ref)
        if u8 ~= u34 then
            tweenButton(u34, Color3_fromRGB_ret);
        end;
    end);
    u34.MouseEnter:Connect(function() -- Line: 249
        -- upvalues: Router (ref), u8 (ref), u34 (copy), tweenButton (ref), Color3_fromRGB_ret3 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");

        if u8 ~= u34 then
            tweenButton(u34, Color3_fromRGB_ret3);
        end;
    end);
    u34.MouseButton1Click:Connect(function() -- Line: 255
        -- upvalues: u8 (ref), u34 (copy), tweenButton (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref)
        local v35 = u8;
        u8 = u34;

        if v35 ~= u34 then
            tweenButton(u34, Color3_fromRGB_ret2);

            if v35 then
                local Alert = v35:FindFirstChild("Alert");
                tweenButton(v35, Color3_fromRGB_ret);

                if Alert then
                    Alert.Visible = false;
                end;
            end;
        end;
    end);
end;

local u36 = {
    Dashboard = true,
    Inventory = true,
    Loadout = true,
    Gamemodes = true,
    Settings = true,
    Store = true,
    Career = true,
    Progression = true,
    GlobalMarketPlace = true,
    GameDashboard = true,
    Blackmarket = true,
    HalloweenEvent = true
};

local function toMenuScreen(p37: string) -- Line: 288
    -- upvalues: u36 (copy)
    if u36[p37] then
        return p37;
    end;

    return nil;
end;

local function setButtonToggle(p38) -- Line: 293
    -- upvalues: u8 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    local v39 = u8;
    u8 = p38;
    tweenButton(p38, Color3_fromRGB_ret2);

    if v39 and v39 ~= p38 then
        tweenButton(v39, Color3_fromRGB_ret);
    end;
end;

local function setNavigationVisible(p40: boolean) -- Line: 304
    -- upvalues: u13 (ref)
    if not u13 then
        return;
    end;

    local Top = u13:FindFirstChild("Top");

    if Top and Top:IsA("GuiObject") then
        Top.Visible = true;
    end;

    local Bottom = u13:FindFirstChild("Bottom");

    if Bottom and Bottom:IsA("GuiObject") then
        Bottom.Visible = p40;
    end;
end;

local function syncControlLockWithMenuVisibility() -- Line: 319
    -- upvalues: u14 (ref), TeamSelection (copy), u3 (ref), InputController (copy), UserInputService (copy), GuiService (copy)
    local v41 = u14 and u14.Menu and u14.Menu.Visible;
    local v42 = TeamSelection.isVisible();
    local v43 = v41 == true and true or v42 == true;

    if v43 and not u3 then
        InputController.disableGroup("Gameplay");
        u3 = true;
    elseif not v43 and u3 then
        InputController.enableGroup("Gameplay");
        u3 = false;
    end;

    if UserInputService.TouchEnabled then
        local v44 = not v43;

        if GuiService.TouchControlsEnabled ~= v44 then
            GuiService.TouchControlsEnabled = v44;
        end;
    end;
end;

local function syncCameraWithTeamSelection() -- Line: 343
    -- upvalues: TeamSelection (copy), u14 (ref), ReplicatedStorage (copy), u1 (copy)
    local v45 = TeamSelection.shouldUseMapCamera();

    if u14.Menu.Visible or not v45 then
        return;
    end;

    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

    if MenuSceneController.ShowTeamSelectScene() then
        return;
    end;

    if MenuSceneController.IsActive() then
        MenuSceneController.HideMenuScene(true, false);
    end;

    local Map = workspace:FindFirstChild("Map");

    if Map then
        u1.UpdateBackground(Map);
    end;
end;

function u1.UpdateBackground(p46) -- Line: 373
    -- upvalues: Profiler (copy), TeamSelection (copy), u14 (ref), ReplicatedStorage (copy), MenuState (copy), LocalPlayer (copy), workspace_CurrentCamera (copy), CameraController (copy)
    Profiler.mark("UI.Top.UpdateBackground");
    local v47 = TeamSelection.shouldUseMapCamera();

    if u14.Menu.Visible or not v47 then
        return;
    end;

    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

    if MenuSceneController.IsActive() or MenuSceneController.IsTeamSelectSceneActive() then
        return;
    end;

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    if LocalPlayer:GetAttribute("IsSpectating") then
        return;
    end;

    local Cameras = p46:FindFirstChild("Cameras");

    if Cameras then
        local Children = Cameras:GetChildren();
        assert(Children[1], "Current map doesnt contain any cameras.");
        workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        workspace_CurrentCamera.CameraSubject = nil;
        local v48 = Children[math.random(1, #Children)];
        LocalPlayer.ReplicationFocus = v48;
        workspace_CurrentCamera.CFrame = v48.CFrame;
        CameraController.updateCameraFOV(80);
    end;
end;

function u1.ToggleMenu() -- Line: 418
    -- upvalues: Profiler (copy), MenuState (copy), GameState (copy), u14 (ref), u6 (ref), CameraController (copy), LocalPlayer (copy), GetUserPlatform (copy), TeamSelection (copy), u1 (copy), u7 (ref)
    Profiler.mark("UI.Top.ToggleMenu");

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    local State = GameState.GetState();

    if not (State and (State ~= "Map Voting" and State ~= "Game Ending")) then
        return;
    end;

    if not u14.Menu.Visible then
        if u14.Gameplay.Middle.TeamSelection.Visible then
            TeamSelection.closeFrame();
        end;

        CameraController.setForceLockOverride("Menu", true);

        if not LocalPlayer:GetAttribute("IsSpectating") then
            CameraController.setPerspective(true, true);
        end;

        u14.Gameplay.Visible = false;
        u14.Menu.Visible = true;

        if LocalPlayer.Character then
            u1.openFrame("GameDashboard");
        elseif u7 and not u7.Visible then
            u1.openFrame(u7.Name);
        end;

        if u7 and (u7.Name ~= "Dashboard" and not MenuState.IsSceneScreen(u7.Name)) then
            MenuState.SetBlurEnabled(true);
        end;

        return;
    end;

    MenuState.SetWantsMainMenu(false);
    u6 = false;
    CameraController.setForceLockOverride("Menu", false);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, false);
    end;

    MenuState.SetBlurEnabled(false);
    u14.Gameplay.Visible = true;
    u14.Gameplay.Top.Visible = true;
    local v49 = table.find(GetUserPlatform(), "Mobile") == nil;
    u14.Gameplay.Middle.SessionStats.Visible = v49;
    u14.Gameplay.Middle.Chat.Visible = v49;
    MenuState.HideMenu();
end;

function u1.openFrame(p50: string, p51: boolean?) -- Line: 481
    -- upvalues: Profiler (copy), MenuState (copy), Router (copy), u12 (ref), u14 (ref), setNavigationVisible (copy), GameState (copy), ReplicatedStorage (copy), u6 (ref), u1 (copy), CameraController (copy), u7 (ref), LocalPlayer (copy), IsPlayingTeam (copy), IsTutorialMode (copy), Remotes (copy), GetUserPlatform (copy), u36 (copy), u2 (ref)
    Profiler.mark("UI.Top.OpenFrame");

    if MenuState.IsInspectActive() then
        return;
    end;

    if MenuState.IsCaseSceneActive() then
        return;
    end;

    if p50 == "Store" and not MenuState.IsStoreEnabled() then
        Router.broadcastRouter("RunInterfaceSound", "UI Store Click");

        return;
    end;

    if p50 == "Store" then
        u12();
    end;

    local v52 = MenuState.IsSceneScreen(p50);
    local v53;

    if p50 == "Dashboard" or p50 == "Play" then
        v53 = false;
    else
        v53 = not v52;
    end;

    MenuState.SetBlurEnabled(v53);
    local Pattern = u14.Menu:FindFirstChild("Pattern");
    u14.Menu.BackgroundTransparency = v53 and 0.15 or 1;

    if Pattern then
        Pattern.Visible = not v53 and not v52;
    end;

    setNavigationVisible(not v52);

    if p50 == "Play" then
        local State = GameState.GetState();
        local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);

        if State and (State ~= "Game Ending" or not EndScreenController.IsActive()) then
            local v54 = nil;
            local v55 = u6;
            u6 = false;
            Router.broadcastRouter("RunInterfaceSound", "UI Play Click");

            if p51 then
                u1.reportPressedPlay();
                MenuState.SetWantsMainMenu(false);
            end;

            CameraController.resetForceLockOverride();
            CameraController.setPerspective(true, false);

            if u7 and u7.Name ~= "Dashboard" then
                u7.Visible = false;
                local Dashboard = u14.Menu:FindFirstChild("Dashboard");

                if Dashboard then
                    Dashboard.Visible = true;
                    u7 = Dashboard;
                end;
            end;

            u14.Gameplay.Bottom.Visible = false;
            u14.Gameplay.Top.Visible = true;
            u14.Gameplay.Visible = true;
            MenuState.HideMenu();

            if State == "Map Voting" then
                v54 = "EndScreen";
            else
                local Attribute = LocalPlayer:GetAttribute("Team");
                local Character = LocalPlayer.Character;
                local v56;

                if v55 then
                    v56 = IsPlayingTeam(Attribute);
                else
                    v56 = v55;
                end;

                if IsTutorialMode() then
                    if Attribute ~= "Terrorists" or not Character then
                        Remotes.TeamSelection.SelectTeam.Send("Terrorists");
                    end;
                else
                    v54 = not (v56 or Character and (Attribute and Attribute ~= "Spectators")) and "TeamSelection" or v54;
                end;
            end;

            if v54 then
                CameraController.setForceLockOverride(v54, true);
                CameraController.setPerspective(true, true);

                for _, child in ipairs(u14.Gameplay.Middle:GetChildren()) do
                    if child.Name == "Chat" then
                        child.Visible = not table.find(GetUserPlatform(), "Mobile");
                    else
                        child.Visible = (child.Name == "Notification" or child.Name == "Votekick" and child:GetAttribute("IsVoteKickActive") == true) and true or child.Name == v54;
                    end;
                end;

                return;
            end;

            local v57 = table.find(GetUserPlatform(), "Mobile") == nil;
            u14.Gameplay.Middle.SessionStats.Visible = v57;
            u14.Gameplay.Middle.Chat.Visible = v57;
            u14.Gameplay.Middle.TeamSelection.Visible = false;
            u14.Gameplay.Middle.Crosshair.Visible = true;
            u14.Gameplay.Top.Visible = true;
            u14.Gameplay.Bottom.Visible = true;
            local Radar = u14.Gameplay.Middle:FindFirstChild("Radar");

            if v55 and (Radar and (Radar:IsA("GuiObject") and not IsTutorialMode())) then
                Radar.Visible = true;
            end;

            if LocalPlayer.Character then
                CameraController.setPerspective(true, false);
            end;
        end;
    else
        if p50 == "Inventory" then
            Router.broadcastRouter("ResetInventoryToGrid");
        end;

        local v58 = u14.Menu:FindFirstChild(p50);

        if v58 and (v58 ~= u7 or not v58.Visible) then
            v58.Visible = true;

            if u7 and u7 ~= v58 then
                u7.Visible = false;
            end;

            u7 = v58;
            local v59;

            if u36[p50] then
                v59 = p50;
            else
                v59 = nil;
            end;

            MenuState.SetScreen(v59);
        end;

        if u2 then
            Router.broadcastRouter("RunInterfaceSound", (`UI {p50} Click`));

            return;
        end;

        u2 = p50 == "Dashboard";
    end;
end;

function u1.reportPressedPlay() -- Line: 632
    -- upvalues: u5 (ref), Remotes (copy)
    if u5 then
        return;
    end;

    u5 = true;
    Remotes.Player.PressedPlay.Send();
end;

function u1.CloseTeamSelection() -- Line: 643
    -- upvalues: u14 (ref)
    u14.Gameplay.Middle.TeamSelection.Visible = false;
    u14.Gameplay.Middle.Crosshair.Visible = true;
    u14.Gameplay.Top.Visible = true;
    u14.Gameplay.Bottom.Visible = true;
end;

local u60 = { "Loadout", "Inventory", "Gamemodes", "Play", "Store", "GlobalMarketPlace", "Progression" };

local function getControllerCurrentTab() -- Line: 656
    -- upvalues: GuiService (copy), u60 (copy), u13 (ref), MenuState (copy), u8 (ref)
    local SelectedObject = GuiService.SelectedObject;

    for _, v in ipairs(u60) do
        local v61 = u13.Bottom.Buttons:FindFirstChild(v);

        if v61 and (SelectedObject and (SelectedObject == v61 or SelectedObject:IsDescendantOf(v61))) then
            return v;
        end;
    end;

    local CurrentScreen = MenuState.GetCurrentScreen();

    if CurrentScreen and table.find(u60, CurrentScreen) then
        return CurrentScreen;
    end;

    local v62 = u8 and u8.Name or nil;

    return not (v62 and table.find(u60, v62)) and "Play" or v62;
end;

local function getTabForBumper(p63: string, p64: boolean) -- Line: 679
    -- upvalues: u60 (copy)
    local table_find_ret = table.find(u60, p63);

    if not table_find_ret then
        return nil;
    end;

    local v65 = #u60;

    if p64 then
        return u60[(table_find_ret - 2 + v65) % v65 + 1];
    end;

    return u60[table_find_ret % v65 + 1];
end;

local function getTopButton(p66: string) -- Line: 688
    -- upvalues: u13 (ref)
    if not u13 then
        return nil;
    end;

    for _, v in ipairs({ "Top", "Bottom" }) do
        local v67 = u13:FindFirstChild(v);

        if v67 then
            v67 = v67:FindFirstChild("Buttons");
        end;

        if v67 then
            v67 = v67:FindFirstChild(p66);
        end;

        if v67 and v67:IsA("GuiButton") then
            return v67;
        end;
    end;

    return nil;
end;

local function goToTab(p68: string, p69: boolean?) -- Line: 705
    -- upvalues: getTopButton (copy), GuiService (copy), MenuState (copy), u1 (copy), u8 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), Router (copy)
    local v70 = getTopButton(p68);

    if not v70 then
        return;
    end;

    GuiService.SelectedObject = v70;
    MenuState.HoldNavigationSelection(v70);

    if not p69 then
        u1.openFrame(p68);
    end;

    local v71 = u8;
    u8 = v70;
    tweenButton(v70, Color3_fromRGB_ret2);

    if v71 and v71 ~= v70 then
        tweenButton(v71, Color3_fromRGB_ret);
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
end;

local function getVisibleUtilityButtons() -- Line: 721
    -- upvalues: u13 (ref)
    local v72 = {};

    for _, child in ipairs(u13.Top.Buttons:GetChildren()) do
        if child:IsA("GuiButton") and child.Visible then
            table.insert(v72, child);
        end;
    end;

    table.sort(v72, function(p73, p74) -- Line: 728
        return p73.AbsolutePosition.X < p74.AbsolutePosition.X;
    end);

    return v72;
end;

local function cycleUtilityButtons(p75: boolean) -- Line: 736
    -- upvalues: getVisibleUtilityButtons (copy), GuiService (copy), MenuState (copy), u1 (copy), u8 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), Router (copy)
    local v76 = getVisibleUtilityButtons();
    local v77 = #v76;

    if v77 == 0 then
        return;
    end;

    local SelectedObject = GuiService.SelectedObject;
    local v78 = 1;

    for i, v in ipairs(v76) do
        if SelectedObject and (SelectedObject == v or SelectedObject:IsDescendantOf(v)) then
            v78 = i;
            break;
        end;
    end;

    local v79 = v76[(v78 - 1 + (p75 and -1 or 1)) % v77 + 1];
    GuiService.SelectedObject = v79;
    MenuState.HoldNavigationSelection(v79);

    if v79.Name ~= "Blackmarket" then
        u1.openFrame(v79.Name);
        local v80 = u8;
        u8 = v79;
        tweenButton(v79, Color3_fromRGB_ret2);

        if v80 and v80 ~= v79 then
            tweenButton(v80, Color3_fromRGB_ret);
        end;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
end;

local u90 = {
    Loadout = function(p81) -- Line: 766, Name: Loadout
        return { (p81:FindFirstChild("Ignore")) };
    end,

    Inventory = function(p82) -- Line: 769, Name: Inventory
        return { (p82:FindFirstChild("Ignore")) };
    end,

    Gamemodes = function(p83) -- Line: 772, Name: Gamemodes
        local Gamemodes = p83:FindFirstChild("Gamemodes");
        local v84 = {};

        if Gamemodes then
            Gamemodes = Gamemodes:FindFirstChild("Prompt");
        end;

        v84[1] = Gamemodes;

        return v84;
    end,

    Store = function(p85) -- Line: 777, Name: Store
        local v86 = {};

        for _, v in { "CaseContent", "Gift", "CreatorCode", "CurrentConfirm" } do
            local v87 = p85:FindFirstChild(v);

            if v87 then
                table.insert(v86, v87);
            end;
        end;

        return v86;
    end,

    Settings = function(p88) -- Line: 788, Name: Settings
        local v89 = {};

        for _, descendant in p88:GetDescendants() do
            if descendant.Name == "Share" or descendant.Name == "ChangeColor" then
                table.insert(v89, descendant);
            end;
        end;

        return v89;
    end
};

local function getPageButtonForBack(p91: userdata?) -- Line: 801
    -- upvalues: u90 (copy), u14 (ref), getTopButton (copy)
    if not p91 then
        return nil;
    end;

    for i, v in pairs(u90) do
        local v92 = u14.Menu:FindFirstChild(i);

        if v92 and (v92:IsA("GuiObject") and (v92.Visible and p91:IsDescendantOf(v92))) then
            for _, v2 in ipairs(v(v92)) do
                if v2 and p91:IsDescendantOf(v2) then
                    return nil;
                end;
            end;

            return getTopButton(i);
        end;
    end;

    return nil;
end;

local function autoJoinMatch() -- Line: 819
    -- upvalues: u4 (ref), IsTutorialMode (copy), MenuState (copy), GameState (copy), u1 (copy), ReplicatedStorage (copy)
    if u4 then
        return;
    end;

    if not IsTutorialMode() then
        return;
    end;

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    local State = GameState.GetState();

    if State == nil or (State == "Game Ending" or State == "Map Voting") then
        return;
    end;

    if not workspace:FindFirstChild("Map") then
        return;
    end;

    u4 = true;
    u1.openFrame("Play", true);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

    if MenuSceneController.IsActive() then
        MenuSceneController.HideMenuScene(true, false);
    end;
end;

local function getStoreNewAlert() -- Line: 847
    -- upvalues: getTopButton (copy)
    local v93 = getTopButton("Store");

    if v93 then
        v93 = v93:FindFirstChild("NewAlert");
    end;

    if v93 and v93:IsA("GuiObject") then
        return v93;
    end;

    return nil;
end;

local function hasUnseenShopVersion() -- Line: 856
    -- upvalues: DataController (copy), LocalPlayer (copy), Constants (copy)
    if DataController.IsDataLoaded(LocalPlayer) then
        return DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
    end;

    return false;
end;

local function updateStoreNewAlert() -- Line: 863
    -- upvalues: getTopButton (copy), DataController (copy), LocalPlayer (copy), Constants (copy)
    local v94 = getTopButton("Store");

    if v94 then
        v94 = v94:FindFirstChild("NewAlert");
    end;

    if not (v94 and v94:IsA("GuiObject")) then
        v94 = nil;
    end;

    if v94 then
        local v95;

        if DataController.IsDataLoaded(LocalPlayer) then
            v95 = DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
        else
            v95 = false;
        end;

        v94.Visible = v95;
    end;
end;

u12 = function() -- Line: 870
    -- upvalues: DataController (copy), LocalPlayer (copy), Constants (copy), getTopButton (copy), Remotes (copy)
    local v96;

    if DataController.IsDataLoaded(LocalPlayer) then
        v96 = DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
    else
        v96 = false;
    end;

    if not v96 then
        return;
    end;

    local v97 = getTopButton("Store");

    if v97 then
        v97 = v97:FindFirstChild("NewAlert");
    end;

    if not (v97 and v97:IsA("GuiObject")) then
        v97 = nil;
    end;

    if v97 then
        v97.Visible = false;
    end;

    Remotes.Player.MarkShopVersionViewed.Send();
end;

local function shouldPreserveMenuFrame() -- Line: 882
    -- upvalues: u14 (ref), MenuState (copy)
    if not u14 then
        return false;
    end;

    local CurrentScreen = MenuState.GetCurrentScreen();

    if not (u14.Menu.Visible and CurrentScreen) then
        return false;
    end;

    if not MenuState.IsPreservableScreen(CurrentScreen) then
        return false;
    end;

    local v98 = u14.Menu:FindFirstChild(CurrentScreen);
    local v99;

    if v98 == nil then
        v99 = false;
    else
        v99 = v98.Visible;
    end;

    return v99;
end;

function u1.ResetToMainMenu() -- Line: 900
    -- upvalues: Profiler (copy), MenuState (copy), u14 (ref), shouldPreserveMenuFrame (copy), u7 (ref), setNavigationVisible (copy), u8 (ref), tweenButton (copy), Color3_fromRGB_ret (copy), u13 (ref), Color3_fromRGB_ret2 (copy)
    Profiler.mark("UI.Top.ResetToMainMenu");

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    if not (u14 and u14:FindFirstChild("Menu")) then
        return;
    end;

    if shouldPreserveMenuFrame() then
        return;
    end;

    for _, child in ipairs(u14.Menu:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= "Dashboard" and (child.Name ~= "Rewards" and (child.Name ~= "UpdateLog" and child.Name ~= "TutorialPrompt")))) then
            child.Visible = false;
        end;
    end;

    local Dashboard = u14.Menu:FindFirstChild("Dashboard");

    if Dashboard then
        Dashboard.Visible = true;
        u7 = Dashboard;
    end;

    local Top = u14.Menu:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    setNavigationVisible(true);
    MenuState.SetBlurEnabled(false);
    u14.Menu.BackgroundTransparency = 1;
    local Pattern = u14.Menu:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = true;
    end;

    MenuState.SetScreen("Dashboard");

    if u8 then
        tweenButton(u8, Color3_fromRGB_ret);
    end;

    u8 = u13.Top.Buttons.Dashboard;
    tweenButton(u8, Color3_fromRGB_ret2);
end;

function u1.ShowMainMenu() -- Line: 966
    -- upvalues: MenuState (copy), CameraController (copy), LocalPlayer (copy), u14 (ref), u1 (copy), ReplicatedStorage (copy)
    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    MenuState.SetWantsMainMenu(true);
    CameraController.setForceLockOverride("Menu", true);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, true);
    end;

    u14.Gameplay.Visible = false;
    u14.Gameplay.Bottom.Visible = false;
    u14.Menu.Visible = true;
    u1.ResetToMainMenu();

    local function tryMenuScene() -- Line: 982
        -- upvalues: u14 (ref), ReplicatedStorage (ref)
        if u14.Menu.Visible and not u14.Gameplay.Visible then
            require(ReplicatedStorage.Controllers.MenuSceneController).ShowMenuScene();
        end;
    end;

    if u14.Menu.Visible and not u14.Gameplay.Visible then
        require(ReplicatedStorage.Controllers.MenuSceneController).ShowMenuScene();
    end;

    if LocalPlayer.Character then
        task.delay(0.15, tryMenuScene);
        task.delay(0.5, tryMenuScene);
    end;
end;

function u1.ShowMainMenuOverGameplay() -- Line: 997
    -- upvalues: MenuState (copy), u6 (ref), CameraController (copy), LocalPlayer (copy), u14 (ref), u1 (copy)
    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    u6 = true;
    CameraController.setForceLockOverride("Menu", true);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, true);
    end;

    u14.Gameplay.Visible = false;
    u14.Menu.Visible = true;
    u1.ResetToMainMenu();
end;

function u1.Initialize(p100, p101) -- Line: 1017
    -- upvalues: Profiler (copy), u14 (ref), u13 (ref), setupButton (copy), ActivateButton (copy), MenuState (copy), u1 (copy), u25 (ref), Constants (copy), animateBlackmarketButton (copy), fitTopButtonsBesideTabs (copy), TeamSelection (copy)
    Profiler.mark("UI.Top.Initialize");
    u14 = p100;
    u13 = p101;

    for _, v in { u13.Top.Buttons, u13.Bottom.Buttons } do
        for _, child in ipairs(v:GetChildren()) do
            if child:IsA("ImageButton") then
                setupButton(child);
                ActivateButton(child);
                child.MouseButton1Click:Connect(function() -- Line: 1027
                    -- upvalues: MenuState (ref), u1 (ref), child (copy)
                    MenuState.HoldNavigationSelection(nil);
                    u1.openFrame(child.Name, child.Name == "Play");
                end);
            end;
        end;
    end;

    local Buttons = u13.Top.Buttons;
    u25 = Buttons.Size.Y;
    local Blackmarket = Buttons:FindFirstChild("Blackmarket");

    if Blackmarket and (Blackmarket:IsA("GuiButton") and not Constants.BLACK_MARKET_ENABLED) then
        Blackmarket.Visible = false;
    elseif Blackmarket and Blackmarket:IsA("GuiButton") then
        animateBlackmarketButton(Blackmarket, function() -- Line: 1043
            -- upvalues: u14 (ref), u13 (ref), Blackmarket (copy)
            return u14.Enabled and (u14.Menu.Visible and u13.Visible) and Blackmarket.Visible;
        end);
    end;

    local u102 = false;

    local function queueTopButtonsFit() -- Line: 1048
        -- upvalues: u102 (ref), fitTopButtonsBesideTabs (ref)
        if u102 then
            return;
        end;

        u102 = true;
        task.defer(function() -- Line: 1054
            -- upvalues: u102 (ref), fitTopButtonsBesideTabs (ref)
            u102 = false;
            fitTopButtonsBesideTabs();
        end);
    end;

    local Store = u14.Menu:FindFirstChild("Store");

    if Store then
        Store = Store:FindFirstChild("Top");
    end;

    if Store then
        Store = Store:FindFirstChild("Categories");
    end;

    if Store and Store:IsA("GuiObject") then
        Store:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueTopButtonsFit);
        Store:GetPropertyChangedSignal("AbsolutePosition"):Connect(queueTopButtonsFit);
        Store:GetPropertyChangedSignal("Visible"):Connect(queueTopButtonsFit);
    end;

    Buttons.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueTopButtonsFit);

    if not u102 then
        u102 = true;
        task.defer(function() -- Line: 1054
            -- upvalues: u102 (ref), fitTopButtonsBesideTabs (ref)
            u102 = false;
            fitTopButtonsBesideTabs();
        end);
    end;

    workspace.ChildAdded:Connect(function(u103) -- Line: 1072
        -- upvalues: u14 (ref), TeamSelection (ref), u1 (ref)
        if u103.Name == "Map" then
            task.delay(0.25, function() -- Line: 1074
                -- upvalues: u14 (ref), TeamSelection (ref), u1 (ref), u103 (copy)
                if u14.Menu.Visible or not TeamSelection.shouldUseMapCamera() then
                    return;
                end;

                u1.UpdateBackground(u103);
            end);
        end;
    end);
end;

function u1.Start() -- Line: 1086
    -- upvalues: Profiler (copy), u8 (ref), u13 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), u14 (ref), CameraController (copy), syncControlLockWithMenuVisibility (copy), syncCameraWithTeamSelection (copy), LocalPlayer (copy), IsTutorialMode (copy), UserInputService (copy), MenuState (copy), cycleUtilityButtons (copy), getControllerCurrentTab (copy), u60 (copy), goToTab (copy), GuiService (copy), u11 (ref), u10 (ref), getPageButtonForBack (copy), CloseButtonRegistry (copy), Router (copy), u9 (ref), getTopButton (copy), u1 (copy), Color3_fromRGB_ret (copy), u7 (ref), ReplicatedStorage (copy), Observers (copy), IsPlayingTeam (copy), u6 (ref), GameState (copy), shouldPreserveMenuFrame (copy), TeamSelection (copy), DataController (copy), updateStoreNewAlert (copy), Constants (copy), autoJoinMatch (copy)
    debug.setmemorycategory("UI.Top.Start");
    Profiler.mark("UI.Top.Start");
    u8 = u13.Top.Buttons.Dashboard;
    tweenButton(u8, Color3_fromRGB_ret2);
    local Pattern = u14.Menu:FindFirstChild("Pattern");
    u14.Menu.BackgroundTransparency = 1;

    if Pattern then
        Pattern.Visible = false;
    end;

    if u14.Menu.Visible then
        CameraController.setForceLockOverride("Menu", true);
    end;

    local function syncMenuAndTeamSelectionState() -- Line: 1106
        -- upvalues: syncControlLockWithMenuVisibility (ref), syncCameraWithTeamSelection (ref)
        syncControlLockWithMenuVisibility();
        syncCameraWithTeamSelection();
    end;

    u14.Menu:GetPropertyChangedSignal("Visible"):Connect(syncControlLockWithMenuVisibility);
    local Gameplay = u14:FindFirstChild("Gameplay");
    local v104;

    if Gameplay then
        v104 = Gameplay:FindFirstChild("Middle");
    else
        v104 = Gameplay;
    end;

    if v104 then
        v104 = v104:FindFirstChild("TeamSelection");
    end;

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    if v104 and v104:IsA("GuiObject") then
        v104:GetPropertyChangedSignal("Visible"):Connect(syncMenuAndTeamSelectionState);
    end;

    if Gameplay and Gameplay:IsA("GuiObject") then
        Gameplay:GetPropertyChangedSignal("Visible"):Connect(syncControlLockWithMenuVisibility);
    end;

    syncControlLockWithMenuVisibility();
    local Attribute = LocalPlayer:GetAttribute("Team");

    if not (LocalPlayer.Character or (Attribute == "Counter-Terrorists" or Attribute == "Terrorists" or IsTutorialMode())) then
        if not CameraController.isForceLockOverrideActive() then
            CameraController.setForceLockOverride("Menu", true);
        end;

        if not u14.Menu.Visible then
            u14.Menu.Visible = true;
        end;

        u14.Gameplay.Visible = false;
        u14.Gameplay.Bottom.Visible = false;
    end;

    UserInputService.InputBegan:Connect(function(p105, p106) -- Line: 1144
        -- upvalues: u14 (ref), MenuState (ref), LocalPlayer (ref), u13 (ref), cycleUtilityButtons (ref), getControllerCurrentTab (ref), u60 (ref), goToTab (ref)
        if not (u14 and u14.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        local v107 = p105.KeyCode == Enum.KeyCode.ButtonL1;

        if not v107 and p105.KeyCode ~= Enum.KeyCode.ButtonR1 then
            return;
        end;

        if MenuState.IsSelectionWithin(u13.Top.Buttons) then
            cycleUtilityButtons(v107);

            return;
        end;

        if MenuState.HandleBumperInput(v107) then
            return;
        end;

        local v108 = getControllerCurrentTab();
        local table_find_ret = table.find(u60, v108);
        local v109;

        if table_find_ret then
            local v110 = #u60;

            if v107 then
                v109 = u60[(table_find_ret - 2 + v110) % v110 + 1];
            else
                v109 = u60[table_find_ret % v110 + 1];
            end;
        else
            v109 = nil;
        end;

        if v109 then
            goToTab(v109, v109 == "Play");
        end;
    end);
    UserInputService.InputBegan:Connect(function(p111) -- Line: 1180
        -- upvalues: u14 (ref), MenuState (ref), LocalPlayer (ref), GuiService (ref), u11 (ref), u10 (ref), getPageButtonForBack (ref), CloseButtonRegistry (ref), Router (ref)
        if p111.KeyCode ~= Enum.KeyCode.ButtonB or not (u14 and u14.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or (MenuState.IsCaseSceneActive() or LocalPlayer:GetAttribute("IsPlayerChatting")) then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject == nil and os.clock() - u11 < 0.1 then
            SelectedObject = u10;
        end;

        local u112 = getPageButtonForBack(SelectedObject);

        if not u112 then
            return;
        end;

        task.defer(function() -- Line: 1199
            -- upvalues: CloseButtonRegistry (ref), GuiService (ref), u112 (copy), Router (ref)
            if CloseButtonRegistry.IsDoublePressed() then
                return;
            end;

            GuiService.SelectedObject = u112;
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end);
    end);
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 1208
        -- upvalues: u10 (ref), u9 (ref), GuiService (ref), u11 (ref)
        u10 = u9;
        u9 = GuiService.SelectedObject;
        u11 = os.clock();
    end);
    UserInputService.InputBegan:Connect(function(p113, p114) -- Line: 1216
        -- upvalues: u14 (ref), MenuState (ref), LocalPlayer (ref), getTopButton (ref), GuiService (ref), u1 (ref)
        if not (u14 and u14.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") or (p113.UserInputType ~= Enum.UserInputType.Gamepad1 or p113.KeyCode ~= Enum.KeyCode.ButtonA) then
            return;
        end;

        local v115 = getTopButton("Play");

        if not v115 then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject ~= v115 and not (SelectedObject and SelectedObject:IsDescendantOf(v115)) then
            return;
        end;

        u1.openFrame("Play", true);
    end);
    u1.openFrame("Dashboard");
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 1246
        -- upvalues: u14 (ref), GuiService (ref), MenuState (ref), u13 (ref), u60 (ref), getTopButton (ref), u8 (ref), tweenButton (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref), Router (ref)
        if not (u14 and u14.Menu.Visible) then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if MenuState.IsInspectActive() or (MenuState.IsCaseSceneActive() or not (u13 and SelectedObject)) then
            return;
        end;

        local v116 = nil;

        for _, v in ipairs(u60) do
            local v117 = getTopButton(v);

            if v117 and (SelectedObject == v117 or SelectedObject:IsDescendantOf(v117)) then
                v116 = v117;
                break;
            end;
        end;

        local v118;

        if v116 then
            v118 = v116;
        else
            v118 = getTopButton("Dashboard");

            if not (v118 and (SelectedObject == v118 or SelectedObject:IsDescendantOf(v118))) then
                v118 = v116;
            end;
        end;

        if v118 and u8 ~= v118 then
            local v119 = u8;
            u8 = v118;
            tweenButton(v118, Color3_fromRGB_ret2);

            if v119 and v119 ~= v118 then
                tweenButton(v119, Color3_fromRGB_ret);
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end;
    end);
    MenuState.OnScreenChanged:Connect(function(p120, p121) -- Line: 1278
        -- upvalues: u14 (ref), u7 (ref), u13 (ref), u8 (ref), tweenButton (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref)
        if not p121 then
            return;
        end;

        local v122 = u14.Menu:FindFirstChild(p121);

        if v122 and v122:IsA("Frame") then
            u7 = v122;
        end;

        local v123 = u13.Bottom.Buttons:FindFirstChild(p121) or u13.Top.Buttons:FindFirstChild(p121);

        if v123 and (v123:IsA("GuiButton") and u8 ~= v123) then
            local v124 = u8;
            u8 = v123;
            tweenButton(v123, Color3_fromRGB_ret2);

            if v124 and v124 ~= v123 then
                tweenButton(v124, Color3_fromRGB_ret);
            end;
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function(p125) -- Line: 1300
        -- upvalues: Profiler (ref), u14 (ref), MenuState (ref), ReplicatedStorage (ref), CameraController (ref)
        Profiler.defer("UI.Top.CharacterAddedDeferred", function() -- Line: 1303
            -- upvalues: u14 (ref), MenuState (ref), ReplicatedStorage (ref), CameraController (ref)
            if not (u14.Menu.Visible or (u14.Gameplay.Middle.TeamSelection.Visible or (MenuState.IsCaseSceneActive() or (MenuState.IsInspectActive() or require(ReplicatedStorage.Controllers.EndScreenController).IsActive())))) then
                CameraController.resetForceLockOverride();
                CameraController.setPerspective(true, false);
            end;
        end);
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function(p126) -- Line: 1326
        -- upvalues: IsPlayingTeam (ref), u6 (ref), u1 (ref)
        if not IsPlayingTeam(p126) then
            u6 = false;
        end;

        if p126 == "Spectators" then
            u1.CloseTeamSelection();
        end;
    end);
    GameState.ListenToState(function(p127, p128) -- Line: 1335
        -- upvalues: u6 (ref), MenuState (ref), u14 (ref), CameraController (ref), IsTutorialMode (ref), u1 (ref), ReplicatedStorage (ref), Router (ref), shouldPreserveMenuFrame (ref), LocalPlayer (ref), TeamSelection (ref), Profiler (ref)
        if p128 == "Game Ending" or p128 == "Map Voting" then
            u6 = false;
        end;

        if MenuState.IsCaseSceneActive() then
            if p128 == "Game Ending" or p128 == "Map Voting" then
                u14.Gameplay.Bottom.Visible = false;
                u14.Gameplay.Visible = false;
            end;

            return;
        end;

        if MenuState.IsInspectActive() then
            return;
        end;

        if MenuState.IsTradeUpActive() then
            if p128 == "Game Ending" or p128 == "Map Voting" then
                u14.Gameplay.Bottom.Visible = false;
                u14.Gameplay.Visible = false;

                if not u14.Menu.Visible then
                    CameraController.setForceLockOverride("Menu", true);
                    u14.Menu.Visible = true;
                end;
            end;

            return;
        end;

        if p128 == "Game Ending" or p128 == "Map Voting" then
            if IsTutorialMode() then
                u1.ShowMainMenu();

                return;
            end;

            if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
                if MenuState.IsInspectActive() then
                    Router.broadcastRouter("WeaponInspectCloseForGameEnd");
                end;

                return;
            end;

            u14.Gameplay.Visible = false;
            u14.Gameplay.Bottom.Visible = false;

            if MenuState.IsInspectActive() then
                Router.broadcastRouter("WeaponInspectCloseForGameEnd");
            end;

            if not shouldPreserveMenuFrame() then
                u1.ResetToMainMenu();
            end;

            if not u14.Menu.Visible then
                CameraController.setForceLockOverride("Menu", true);
                u14.Menu.Visible = true;
            end;
        end;

        if p128 == "Map Voting" then
            if LocalPlayer:GetAttribute("FollowGamemode") or LocalPlayer:GetAttribute("IsSpectating") then
                if u14.Menu.Visible and (MenuState.WantsMainMenu() or shouldPreserveMenuFrame()) then
                    return;
                end;

                u1.openFrame("Play");

                return;
            end;

            if not (u14.Menu.Visible or shouldPreserveMenuFrame()) then
                u1.openFrame("Dashboard");
                u1.ToggleMenu();
            end;
        end;

        if not (p127 ~= "Game Ending" and p127 ~= "Map Voting" or (p128 == "Game Ending" or p128 == "Map Voting")) then
            if IsTutorialMode() and u14.Menu.Visible then
                return;
            end;

            if p127 == "Map Voting" then
                if u14.Menu.Visible then
                    return;
                end;

                if MenuState.WantsMainMenu() then
                    u1.ResetToMainMenu();
                    CameraController.setForceLockOverride("Menu", true);
                    u14.Gameplay.Visible = false;
                    u14.Gameplay.Bottom.Visible = false;
                    u14.Menu.Visible = true;

                    return;
                end;

                local Attribute2 = LocalPlayer:GetAttribute("Team");

                if not (LocalPlayer.Character and (Attribute2 and Attribute2 ~= "Spectators")) then
                    MenuState.HideMenu();
                    u14.Gameplay.Visible = true;
                    u14.Gameplay.Top.Visible = true;
                    TeamSelection.openFrame();

                    return;
                end;
            elseif u14.Menu.Visible and shouldPreserveMenuFrame() then
                return;
            end;

            Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1472
                -- upvalues: MenuState (ref), ReplicatedStorage (ref), u14 (ref), shouldPreserveMenuFrame (ref), u1 (ref), CameraController (ref)
                if MenuState.IsInspectActive() then
                    return;
                end;

                if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive() and not u14.Menu.Visible then
                    if not shouldPreserveMenuFrame() then
                        u1.ResetToMainMenu();
                    end;

                    CameraController.setForceLockOverride("Menu", true);
                    u14.Gameplay.Visible = false;
                    u14.Menu.Visible = true;
                end;
            end);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "LastShopVersionViewed", updateStoreNewAlert);
    local v129 = getTopButton("Store");

    if v129 then
        v129 = v129:FindFirstChild("NewAlert");
    end;

    if not (v129 and v129:IsA("GuiObject")) then
        v129 = nil;
    end;

    if v129 then
        local v130;

        if DataController.IsDataLoaded(LocalPlayer) then
            v130 = DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
        else
            v130 = false;
        end;

        v129.Visible = v130;
    end;

    GameState.ListenToState(function() -- Line: 1496
        -- upvalues: Profiler (ref), autoJoinMatch (ref)
        Profiler.defer("UI.Top.AutoJoinTutorialDeferred", autoJoinMatch);
    end);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(autoJoinMatch);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(autoJoinMatch);
    workspace.ChildAdded:Connect(function(p131) -- Line: 1501
        -- upvalues: autoJoinMatch (ref)
        if p131.Name == "Map" then
            autoJoinMatch();
        end;
    end);
    Profiler.defer("UI.Top.AutoJoinTutorialDeferred", autoJoinMatch);
    local u132 = workspace:GetAttribute("TutorialActive") == true;
    workspace:GetAttributeChangedSignal("TutorialActive"):Connect(function() -- Line: 1509
        -- upvalues: u132 (ref), u1 (ref)
        local v133 = workspace:GetAttribute("TutorialActive") == true;

        if u132 and not v133 then
            u1.ShowMainMenu();
        end;

        u132 = v133;
    end);
end;

return u1;