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
local IsBotLobby = require(ReplicatedStorage.Components.Common.IsBotLobby);
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
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = 0;
local u11 = nil;
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(150, 220, 239);
local Color3_fromRGB_ret3 = Color3.fromRGB(175, 175, 175);
local u12 = nil;
local u13 = nil;

local function tweenButton(p14: any, p15) -- Line: 94
    -- upvalues: TweenService (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    if p14:IsA("ImageButton") then
        TweenService:Create(p14, TweenInfo.new(0.15), {
            ImageColor3 = p15
        }):Play();

        return;
    end;

    if p14:IsA("TextButton") then
        local v16 = p14:GetAttribute("DefaultSize") or p14.Size;
        local v17 = p15 == Color3_fromRGB_ret2 and 1.12 or (p15 == Color3_fromRGB_ret3 and 1.06 or 1);
        TweenService:Create(p14, TweenInfo.new(0.15), {
            Size = UDim2.new(v16.X.Scale * v17, v16.X.Offset * v17, v16.Y.Scale * v17, v16.Y.Offset * v17)
        }):Play();
    end;
end;

local function animateBlackmarketButton(p18: userdata, u19: function) -- Line: 122
    -- upvalues: RunServiceController (copy), GuiService (copy)
    local Icon = p18:FindFirstChild("Icon");

    if not Icon then
        return;
    end;

    local Position = Icon.Position;
    local Rotation = Icon.Rotation;
    local u20 = false;
    local u21 = 0;
    p18.MouseEnter:Connect(function() -- Line: 133
        -- upvalues: u20 (ref)
        u20 = true;
    end);
    p18.MouseLeave:Connect(function() -- Line: 136
        -- upvalues: u20 (ref)
        u20 = false;
    end);
    RunServiceController.BindToRenderStep("UI.Top.BlackmarketButton", function(p22: number) -- Line: 140
        -- upvalues: u19 (copy), GuiService (ref), Icon (copy), Position (copy), Rotation (copy), u20 (ref), u21 (ref)
        if not u19() then
            return;
        end;

        if GuiService.ReducedMotionEnabled then
            Icon.Position = Position;
            Icon.Rotation = Rotation;

            return;
        end;

        u21 = u21 + ((u20 and 1 or 0) - u21) * (1 - math.exp(p22 * -14));
        local v23 = os.clock() * 1.4;
        Icon.Position = Position + UDim2.fromScale(0, math.sin(v23) * 0.035);
        Icon.Rotation = Rotation + math.cos(v23) * 2 + u21 * -8;
    end);
end;

local u24 = nil;

local function fitTopButtonsBesideTabs() -- Line: 171
    -- upvalues: u12 (ref), u13 (ref), u24 (ref)
    local Buttons = u12.Top.Buttons;
    local Store = u13.Menu:FindFirstChild("Store");

    if Store then
        Store = Store:FindFirstChild("Top");
    end;

    if Store then
        Store = Store:FindFirstChild("Categories");
    end;

    local v25 = u24;

    if not (Store and v25) then
        return;
    end;

    if Store:IsA("GuiObject") and not Store.Visible then
        Buttons.Size = UDim2.new(Buttons.Size.X, v25);

        return;
    end;

    local v26 = (-1 / 0);

    for _, child in Store:GetChildren() do
        if child:IsA("GuiObject") and child.Visible then
            v26 = math.max(v26, child.AbsolutePosition.X + child.AbsoluteSize.X);
        end;
    end;

    local v27 = 0;
    local v28 = 0;

    for _, child in Buttons:GetChildren() do
        if child:IsA("GuiButton") and child.Visible then
            v27 = v27 + 1;
            v28 = math.max(v28, child.Size.Y.Scale);
        end;
    end;

    local Y = Buttons.Parent.AbsoluteSize.Y;

    if v26 == (-1 / 0) or (v27 == 0 or (v28 <= 0 or Y <= 0)) then
        return;
    end;

    local X = Buttons.AbsoluteSize.X;
    local v29 = Buttons:FindFirstChildOfClass("UIPadding");
    local v30 = Buttons:FindFirstChildOfClass("UIListLayout");
    local v31 = Buttons.AbsolutePosition.X + X - (not v29 and 0 or v29.PaddingRight.Scale * X + v29.PaddingRight.Offset) - (v26 + 8) - (not v30 and 0 or v30.Padding.Scale * X + v30.Padding.Offset) * (v27 - 1);
    local v32 = v28 * math.min(X, v25.Scale * Y + v25.Offset);
    local math_clamp_ret = math.clamp(v31 / v27 / v32, 0, 1);
    Buttons.Size = UDim2.new(Buttons.Size.X, UDim.new(v25.Scale * math_clamp_ret, v25.Offset * math_clamp_ret));
end;

local function setupButton(u33) -- Line: 227
    -- upvalues: Color3_fromRGB_ret (copy), u7 (ref), tweenButton (copy), Router (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy)
    for _, descendant in ipairs(u33:GetDescendants()) do
        if descendant:IsA("GuiObject") and (not descendant:IsA("GuiButton") and descendant.Active) then
            descendant.Active = false;
        end;
    end;

    if u33:IsA("ImageButton") then
        u33.ImageColor3 = Color3_fromRGB_ret;
    elseif u33:IsA("TextButton") then
        u33.TextLabel.TextColor3 = Color3_fromRGB_ret;
        u33:SetAttribute("DefaultSize", u33.Size);
    end;

    u33.MouseLeave:Connect(function() -- Line: 242
        -- upvalues: u7 (ref), u33 (copy), tweenButton (ref), Color3_fromRGB_ret (ref)
        if u7 ~= u33 then
            tweenButton(u33, Color3_fromRGB_ret);
        end;
    end);
    u33.MouseEnter:Connect(function() -- Line: 247
        -- upvalues: Router (ref), u7 (ref), u33 (copy), tweenButton (ref), Color3_fromRGB_ret3 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");

        if u7 ~= u33 then
            tweenButton(u33, Color3_fromRGB_ret3);
        end;
    end);
    u33.MouseButton1Click:Connect(function() -- Line: 253
        -- upvalues: u7 (ref), u33 (copy), tweenButton (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref)
        local v34 = u7;
        u7 = u33;

        if v34 ~= u33 then
            tweenButton(u33, Color3_fromRGB_ret2);

            if v34 then
                local Alert = v34:FindFirstChild("Alert");
                tweenButton(v34, Color3_fromRGB_ret);

                if Alert then
                    Alert.Visible = false;
                end;
            end;
        end;
    end);
end;

local u35 = {
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
    Blackmarket = true
};

local function toMenuScreen(p36: string) -- Line: 285
    -- upvalues: u35 (copy)
    if u35[p36] then
        return p36;
    end;

    return nil;
end;

local function setButtonToggle(p37) -- Line: 290
    -- upvalues: u7 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    local v38 = u7;
    u7 = p37;
    tweenButton(p37, Color3_fromRGB_ret2);

    if v38 and v38 ~= p37 then
        tweenButton(v38, Color3_fromRGB_ret);
    end;
end;

local function setNavigationVisible(p39: boolean) -- Line: 300
    -- upvalues: u12 (ref)
    if not u12 then
        return;
    end;

    for _, v in ipairs({ "Top", "Bottom" }) do
        local v40 = u12:FindFirstChild(v);

        if v40 and v40:IsA("GuiObject") then
            v40.Visible = p39;
        end;
    end;
end;

local function syncControlLockWithMenuVisibility() -- Line: 313
    -- upvalues: u13 (ref), TeamSelection (copy), u3 (ref), InputController (copy), UserInputService (copy), GuiService (copy)
    local v41 = u13 and u13.Menu and u13.Menu.Visible;
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

local function syncCameraWithTeamSelection() -- Line: 337
    -- upvalues: TeamSelection (copy), u13 (ref), ReplicatedStorage (copy), u1 (copy)
    local v45 = TeamSelection.shouldUseMapCamera();

    if u13.Menu.Visible or not v45 then
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

function u1.UpdateBackground(p46) -- Line: 367
    -- upvalues: Profiler (copy), TeamSelection (copy), u13 (ref), ReplicatedStorage (copy), MenuState (copy), LocalPlayer (copy), workspace_CurrentCamera (copy), CameraController (copy)
    Profiler.mark("UI.Top.UpdateBackground");
    local v47 = TeamSelection.shouldUseMapCamera();

    if u13.Menu.Visible or not v47 then
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

function u1.ToggleMenu() -- Line: 412
    -- upvalues: Profiler (copy), MenuState (copy), GameState (copy), u13 (ref), CameraController (copy), LocalPlayer (copy), GetUserPlatform (copy), TeamSelection (copy), u1 (copy), u6 (ref)
    Profiler.mark("UI.Top.ToggleMenu");

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    local State = GameState.GetState();

    if not (State and (State ~= "Map Voting" and State ~= "Game Ending")) then
        return;
    end;

    if not u13.Menu.Visible then
        if u13.Gameplay.Middle.TeamSelection.Visible then
            TeamSelection.closeFrame();
        end;

        CameraController.setForceLockOverride("Menu", true);

        if not LocalPlayer:GetAttribute("IsSpectating") then
            CameraController.setPerspective(true, true);
        end;

        u13.Gameplay.Visible = false;
        u13.Menu.Visible = true;

        if LocalPlayer.Character then
            u1.openFrame("GameDashboard");
        elseif u6 and not u6.Visible then
            u1.openFrame(u6.Name);
        end;

        if u6 and u6.Name ~= "Dashboard" then
            MenuState.SetBlurEnabled(true);
        end;

        return;
    end;

    MenuState.SetWantsMainMenu(false);
    CameraController.setForceLockOverride("Menu", false);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, false);
    end;

    MenuState.SetBlurEnabled(false);
    u13.Gameplay.Visible = true;
    u13.Gameplay.Top.Visible = true;
    local v49 = table.find(GetUserPlatform(), "Mobile") == nil;
    u13.Gameplay.Middle.SessionStats.Visible = v49;
    u13.Gameplay.Middle.Chat.Visible = v49;
    MenuState.HideMenu();
end;

function u1.openFrame(p50: string, p51: boolean?) -- Line: 474
    -- upvalues: Profiler (copy), MenuState (copy), Router (copy), u11 (ref), u13 (ref), setNavigationVisible (copy), GameState (copy), ReplicatedStorage (copy), u1 (copy), CameraController (copy), u6 (ref), LocalPlayer (copy), IsTutorialMode (copy), Remotes (copy), GetUserPlatform (copy), u35 (copy), u2 (ref)
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
        u11();
    end;

    local v52 = MenuState.IsSceneScreen(p50);
    local v53;

    if p50 == "Dashboard" or p50 == "Play" then
        v53 = false;
    else
        v53 = not v52;
    end;

    MenuState.SetBlurEnabled(v53);
    local Pattern = u13.Menu:FindFirstChild("Pattern");
    u13.Menu.BackgroundTransparency = v53 and 0.15 or 1;

    if Pattern then
        Pattern.Visible = not v53 and not v52;
    end;

    setNavigationVisible(not v52);

    if p50 == "Play" then
        local State = GameState.GetState();
        local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);

        if State and (State ~= "Game Ending" or not EndScreenController.IsActive()) then
            local v54 = nil;
            Router.broadcastRouter("RunInterfaceSound", "UI Play Click");

            if p51 then
                u1.reportPressedPlay();
                MenuState.SetWantsMainMenu(false);
            end;

            CameraController.resetForceLockOverride();
            CameraController.setPerspective(true, false);

            if u6 and u6.Name ~= "Dashboard" then
                u6.Visible = false;
                local Dashboard = u13.Menu:FindFirstChild("Dashboard");

                if Dashboard then
                    Dashboard.Visible = true;
                    u6 = Dashboard;
                end;
            end;

            u13.Gameplay.Bottom.Visible = false;
            u13.Gameplay.Top.Visible = true;
            u13.Gameplay.Visible = true;
            MenuState.HideMenu();

            if State == "Map Voting" then
                v54 = "EndScreen";
            else
                local Attribute = LocalPlayer:GetAttribute("Team");
                local Character = LocalPlayer.Character;

                if IsTutorialMode() then
                    if Attribute ~= "Terrorists" or not Character then
                        Remotes.TeamSelection.SelectTeam.Send("Terrorists");
                    end;
                else
                    v54 = not (Character and (Attribute and Attribute ~= "Spectators")) and "TeamSelection" or v54;
                end;
            end;

            if v54 then
                CameraController.setForceLockOverride(v54, true);
                CameraController.setPerspective(true, true);

                for _, child in ipairs(u13.Gameplay.Middle:GetChildren()) do
                    if child.Name == "Chat" then
                        child.Visible = not table.find(GetUserPlatform(), "Mobile");
                    else
                        child.Visible = (child.Name == "Notification" or child.Name == "Votekick" and child:GetAttribute("IsVoteKickActive") == true) and true or child.Name == v54;
                    end;
                end;

                return;
            end;

            local v55 = table.find(GetUserPlatform(), "Mobile") == nil;
            u13.Gameplay.Middle.SessionStats.Visible = v55;
            u13.Gameplay.Middle.Chat.Visible = v55;
            u13.Gameplay.Middle.TeamSelection.Visible = false;
            u13.Gameplay.Middle.Crosshair.Visible = true;
            u13.Gameplay.Top.Visible = true;
            u13.Gameplay.Bottom.Visible = true;

            if LocalPlayer.Character then
                CameraController.setPerspective(true, false);
            end;
        end;
    else
        if p50 == "Inventory" then
            Router.broadcastRouter("ResetInventoryToGrid");
        end;

        local v56 = u13.Menu:FindFirstChild(p50);

        if v56 and (v56 ~= u6 or not v56.Visible) then
            v56.Visible = true;

            if u6 and u6 ~= v56 then
                u6.Visible = false;
            end;

            u6 = v56;
            local v57;

            if u35[p50] then
                v57 = p50;
            else
                v57 = nil;
            end;

            MenuState.SetScreen(v57);
        end;

        if u2 then
            Router.broadcastRouter("RunInterfaceSound", (`UI {p50} Click`));

            return;
        end;

        u2 = p50 == "Dashboard";
    end;
end;

function u1.reportPressedPlay() -- Line: 612
    -- upvalues: u5 (ref), Remotes (copy)
    if u5 then
        return;
    end;

    u5 = true;
    Remotes.Player.PressedPlay.Send();
end;

function u1.CloseTeamSelection() -- Line: 623
    -- upvalues: u13 (ref)
    u13.Gameplay.Middle.TeamSelection.Visible = false;
    u13.Gameplay.Middle.Crosshair.Visible = true;
    u13.Gameplay.Top.Visible = true;
    u13.Gameplay.Bottom.Visible = true;
end;

local u58 = { "Loadout", "Inventory", "Gamemodes", "Play", "Store", "GlobalMarketPlace", "Progression" };

local function getControllerCurrentTab() -- Line: 636
    -- upvalues: GuiService (copy), u58 (copy), u12 (ref), MenuState (copy), u7 (ref)
    local SelectedObject = GuiService.SelectedObject;

    for _, v in ipairs(u58) do
        local v59 = u12.Bottom.Buttons:FindFirstChild(v);

        if v59 and (SelectedObject and (SelectedObject == v59 or SelectedObject:IsDescendantOf(v59))) then
            return v;
        end;
    end;

    local CurrentScreen = MenuState.GetCurrentScreen();

    if CurrentScreen and table.find(u58, CurrentScreen) then
        return CurrentScreen;
    end;

    local v60 = u7 and u7.Name or nil;

    return not (v60 and table.find(u58, v60)) and "Play" or v60;
end;

local function getTabForBumper(p61: string, p62: boolean) -- Line: 659
    -- upvalues: u58 (copy)
    local table_find_ret = table.find(u58, p61);

    if not table_find_ret then
        return nil;
    end;

    local v63 = #u58;

    if p62 then
        return u58[(table_find_ret - 2 + v63) % v63 + 1];
    end;

    return u58[table_find_ret % v63 + 1];
end;

local function getTopButton(p64: string) -- Line: 668
    -- upvalues: u12 (ref)
    if not u12 then
        return nil;
    end;

    for _, v in ipairs({ "Top", "Bottom" }) do
        local v65 = u12:FindFirstChild(v);

        if v65 then
            v65 = v65:FindFirstChild("Buttons");
        end;

        if v65 then
            v65 = v65:FindFirstChild(p64);
        end;

        if v65 and v65:IsA("GuiButton") then
            return v65;
        end;
    end;

    return nil;
end;

local function goToTab(p66: string, p67: boolean?) -- Line: 685
    -- upvalues: getTopButton (copy), GuiService (copy), MenuState (copy), u1 (copy), u7 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), Router (copy)
    local v68 = getTopButton(p66);

    if not v68 then
        return;
    end;

    GuiService.SelectedObject = v68;
    MenuState.HoldNavigationSelection(v68);

    if not p67 then
        u1.openFrame(p66);
    end;

    local v69 = u7;
    u7 = v68;
    tweenButton(v68, Color3_fromRGB_ret2);

    if v69 and v69 ~= v68 then
        tweenButton(v69, Color3_fromRGB_ret);
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
end;

local function getVisibleUtilityButtons() -- Line: 701
    -- upvalues: u12 (ref)
    local v70 = {};

    for _, child in ipairs(u12.Top.Buttons:GetChildren()) do
        if child:IsA("GuiButton") and child.Visible then
            table.insert(v70, child);
        end;
    end;

    table.sort(v70, function(p71, p72) -- Line: 708
        return p71.AbsolutePosition.X < p72.AbsolutePosition.X;
    end);

    return v70;
end;

local function cycleUtilityButtons(p73: boolean) -- Line: 716
    -- upvalues: getVisibleUtilityButtons (copy), GuiService (copy), MenuState (copy), u1 (copy), u7 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), Router (copy)
    local v74 = getVisibleUtilityButtons();
    local v75 = #v74;

    if v75 == 0 then
        return;
    end;

    local SelectedObject = GuiService.SelectedObject;
    local v76 = 1;

    for i, v in ipairs(v74) do
        if SelectedObject and (SelectedObject == v or SelectedObject:IsDescendantOf(v)) then
            v76 = i;
            break;
        end;
    end;

    local v77 = v74[(v76 - 1 + (p73 and -1 or 1)) % v75 + 1];
    GuiService.SelectedObject = v77;
    MenuState.HoldNavigationSelection(v77);

    if v77.Name ~= "Blackmarket" then
        u1.openFrame(v77.Name);
        local v78 = u7;
        u7 = v77;
        tweenButton(v77, Color3_fromRGB_ret2);

        if v78 and v78 ~= v77 then
            tweenButton(v78, Color3_fromRGB_ret);
        end;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
end;

local u88 = {
    Loadout = function(p79) -- Line: 746, Name: Loadout
        return { (p79:FindFirstChild("Ignore")) };
    end,

    Inventory = function(p80) -- Line: 749, Name: Inventory
        return { (p80:FindFirstChild("Ignore")) };
    end,

    Gamemodes = function(p81) -- Line: 752, Name: Gamemodes
        local Gamemodes = p81:FindFirstChild("Gamemodes");
        local v82 = {};

        if Gamemodes then
            Gamemodes = Gamemodes:FindFirstChild("Prompt");
        end;

        v82[1] = Gamemodes;

        return v82;
    end,

    Store = function(p83) -- Line: 757, Name: Store
        local v84 = {};

        for _, v in { "CaseContent", "Gift", "CreatorCode", "CurrentConfirm" } do
            local v85 = p83:FindFirstChild(v);

            if v85 then
                table.insert(v84, v85);
            end;
        end;

        return v84;
    end,

    Settings = function(p86) -- Line: 768, Name: Settings
        local v87 = {};

        for _, descendant in p86:GetDescendants() do
            if descendant.Name == "Share" or descendant.Name == "ChangeColor" then
                table.insert(v87, descendant);
            end;
        end;

        return v87;
    end
};

local function getPageButtonForBack(p89: userdata?) -- Line: 781
    -- upvalues: u88 (copy), u13 (ref), getTopButton (copy)
    if not p89 then
        return nil;
    end;

    for i, v in pairs(u88) do
        local v90 = u13.Menu:FindFirstChild(i);

        if v90 and (v90:IsA("GuiObject") and (v90.Visible and p89:IsDescendantOf(v90))) then
            for _, v2 in ipairs(v(v90)) do
                if v2 and p89:IsDescendantOf(v2) then
                    return nil;
                end;
            end;

            return getTopButton(i);
        end;
    end;

    return nil;
end;

local function autoJoinMatch() -- Line: 799
    -- upvalues: u4 (ref), IsTutorialMode (copy), IsBotLobby (copy), MenuState (copy), GameState (copy), u1 (copy), ReplicatedStorage (copy)
    if u4 then
        return;
    end;

    if not (IsTutorialMode() or IsBotLobby()) then
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

local function getStoreNewAlert() -- Line: 827
    -- upvalues: getTopButton (copy)
    local v91 = getTopButton("Store");

    if v91 then
        v91 = v91:FindFirstChild("NewAlert");
    end;

    if v91 and v91:IsA("GuiObject") then
        return v91;
    end;

    return nil;
end;

local function hasUnseenShopVersion() -- Line: 836
    -- upvalues: DataController (copy), LocalPlayer (copy), Constants (copy)
    if DataController.IsDataLoaded(LocalPlayer) then
        return DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
    end;

    return false;
end;

local function updateStoreNewAlert() -- Line: 843
    -- upvalues: getTopButton (copy), DataController (copy), LocalPlayer (copy), Constants (copy)
    local v92 = getTopButton("Store");

    if v92 then
        v92 = v92:FindFirstChild("NewAlert");
    end;

    if not (v92 and v92:IsA("GuiObject")) then
        v92 = nil;
    end;

    if v92 then
        local v93;

        if DataController.IsDataLoaded(LocalPlayer) then
            v93 = DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
        else
            v93 = false;
        end;

        v92.Visible = v93;
    end;
end;

u11 = function() -- Line: 850
    -- upvalues: DataController (copy), LocalPlayer (copy), Constants (copy), getTopButton (copy), Remotes (copy)
    local v94;

    if DataController.IsDataLoaded(LocalPlayer) then
        v94 = DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
    else
        v94 = false;
    end;

    if not v94 then
        return;
    end;

    local v95 = getTopButton("Store");

    if v95 then
        v95 = v95:FindFirstChild("NewAlert");
    end;

    if not (v95 and v95:IsA("GuiObject")) then
        v95 = nil;
    end;

    if v95 then
        v95.Visible = false;
    end;

    Remotes.Player.MarkShopVersionViewed.Send();
end;

local function shouldPreserveMenuFrame() -- Line: 862
    -- upvalues: u13 (ref), MenuState (copy)
    if not u13 then
        return false;
    end;

    local CurrentScreen = MenuState.GetCurrentScreen();

    if not (u13.Menu.Visible and CurrentScreen) then
        return false;
    end;

    if not MenuState.IsPreservableScreen(CurrentScreen) then
        return false;
    end;

    local v96 = u13.Menu:FindFirstChild(CurrentScreen);
    local v97;

    if v96 == nil then
        v97 = false;
    else
        v97 = v96.Visible;
    end;

    return v97;
end;

function u1.ResetToMainMenu() -- Line: 880
    -- upvalues: Profiler (copy), MenuState (copy), u13 (ref), shouldPreserveMenuFrame (copy), u6 (ref), setNavigationVisible (copy), u7 (ref), tweenButton (copy), Color3_fromRGB_ret (copy), u12 (ref), Color3_fromRGB_ret2 (copy)
    Profiler.mark("UI.Top.ResetToMainMenu");

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    if not (u13 and u13:FindFirstChild("Menu")) then
        return;
    end;

    if shouldPreserveMenuFrame() then
        return;
    end;

    for _, child in ipairs(u13.Menu:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= "Dashboard" and (child.Name ~= "Rewards" and (child.Name ~= "UpdateLog" and child.Name ~= "TutorialPrompt")))) then
            child.Visible = false;
        end;
    end;

    local Dashboard = u13.Menu:FindFirstChild("Dashboard");

    if Dashboard then
        Dashboard.Visible = true;
        u6 = Dashboard;
    end;

    local Top = u13.Menu:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    setNavigationVisible(true);
    MenuState.SetBlurEnabled(false);
    u13.Menu.BackgroundTransparency = 1;
    local Pattern = u13.Menu:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = true;
    end;

    MenuState.SetScreen("Dashboard");

    if u7 then
        tweenButton(u7, Color3_fromRGB_ret);
    end;

    u7 = u12.Top.Buttons.Dashboard;
    tweenButton(u7, Color3_fromRGB_ret2);
end;

function u1.ShowMainMenu() -- Line: 946
    -- upvalues: MenuState (copy), CameraController (copy), LocalPlayer (copy), u13 (ref), u1 (copy), ReplicatedStorage (copy)
    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    MenuState.SetWantsMainMenu(true);
    CameraController.setForceLockOverride("Menu", true);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, true);
    end;

    u13.Gameplay.Visible = false;
    u13.Gameplay.Bottom.Visible = false;
    u13.Menu.Visible = true;
    u1.ResetToMainMenu();

    local function tryMenuScene() -- Line: 962
        -- upvalues: u13 (ref), ReplicatedStorage (ref)
        if u13.Menu.Visible and not u13.Gameplay.Visible then
            require(ReplicatedStorage.Controllers.MenuSceneController).ShowMenuScene();
        end;
    end;

    if u13.Menu.Visible and not u13.Gameplay.Visible then
        require(ReplicatedStorage.Controllers.MenuSceneController).ShowMenuScene();
    end;

    if LocalPlayer.Character then
        task.delay(0.15, tryMenuScene);
        task.delay(0.5, tryMenuScene);
    end;
end;

function u1.Initialize(p98, p99) -- Line: 978
    -- upvalues: Profiler (copy), u13 (ref), u12 (ref), setupButton (copy), ActivateButton (copy), MenuState (copy), u1 (copy), u24 (ref), Constants (copy), animateBlackmarketButton (copy), fitTopButtonsBesideTabs (copy), TeamSelection (copy)
    Profiler.mark("UI.Top.Initialize");
    u13 = p98;
    u12 = p99;

    for _, v in { u12.Top.Buttons, u12.Bottom.Buttons } do
        for _, child in ipairs(v:GetChildren()) do
            if child:IsA("ImageButton") then
                setupButton(child);
                ActivateButton(child);
                child.MouseButton1Click:Connect(function() -- Line: 988
                    -- upvalues: MenuState (ref), u1 (ref), child (copy)
                    MenuState.HoldNavigationSelection(nil);
                    u1.openFrame(child.Name, child.Name == "Play");
                end);
            end;
        end;
    end;

    local Buttons = u12.Top.Buttons;
    u24 = Buttons.Size.Y;
    local Blackmarket = Buttons:FindFirstChild("Blackmarket");

    if Blackmarket and (Blackmarket:IsA("GuiButton") and not Constants.BLACK_MARKET_ENABLED) then
        Blackmarket.Visible = false;
    elseif Blackmarket and Blackmarket:IsA("GuiButton") then
        animateBlackmarketButton(Blackmarket, function() -- Line: 1004
            -- upvalues: u13 (ref), u12 (ref), Blackmarket (copy)
            return u13.Enabled and (u13.Menu.Visible and u12.Visible) and Blackmarket.Visible;
        end);
    end;

    local u100 = false;

    local function queueTopButtonsFit() -- Line: 1009
        -- upvalues: u100 (ref), fitTopButtonsBesideTabs (ref)
        if u100 then
            return;
        end;

        u100 = true;
        task.defer(function() -- Line: 1015
            -- upvalues: u100 (ref), fitTopButtonsBesideTabs (ref)
            u100 = false;
            fitTopButtonsBesideTabs();
        end);
    end;

    local Store = u13.Menu:FindFirstChild("Store");

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

    if not u100 then
        u100 = true;
        task.defer(function() -- Line: 1015
            -- upvalues: u100 (ref), fitTopButtonsBesideTabs (ref)
            u100 = false;
            fitTopButtonsBesideTabs();
        end);
    end;

    workspace.ChildAdded:Connect(function(u101) -- Line: 1033
        -- upvalues: u13 (ref), TeamSelection (ref), u1 (ref)
        if u101.Name == "Map" then
            task.delay(0.25, function() -- Line: 1035
                -- upvalues: u13 (ref), TeamSelection (ref), u1 (ref), u101 (copy)
                if u13.Menu.Visible or not TeamSelection.shouldUseMapCamera() then
                    return;
                end;

                u1.UpdateBackground(u101);
            end);
        end;
    end);
end;

function u1.Start() -- Line: 1047
    -- upvalues: Profiler (copy), u7 (ref), u12 (ref), tweenButton (copy), Color3_fromRGB_ret2 (copy), u13 (ref), CameraController (copy), syncControlLockWithMenuVisibility (copy), syncCameraWithTeamSelection (copy), LocalPlayer (copy), IsTutorialMode (copy), UserInputService (copy), MenuState (copy), cycleUtilityButtons (copy), getControllerCurrentTab (copy), u58 (copy), goToTab (copy), GuiService (copy), u10 (ref), u9 (ref), getPageButtonForBack (copy), CloseButtonRegistry (copy), Router (copy), u8 (ref), getTopButton (copy), u1 (copy), Color3_fromRGB_ret (copy), u6 (ref), Observers (copy), GameState (copy), ReplicatedStorage (copy), shouldPreserveMenuFrame (copy), TeamSelection (copy), DataController (copy), updateStoreNewAlert (copy), Constants (copy), autoJoinMatch (copy)
    debug.setmemorycategory("UI.Top.Start");
    Profiler.mark("UI.Top.Start");
    u7 = u12.Top.Buttons.Dashboard;
    tweenButton(u7, Color3_fromRGB_ret2);
    local Pattern = u13.Menu:FindFirstChild("Pattern");
    u13.Menu.BackgroundTransparency = 1;

    if Pattern then
        Pattern.Visible = false;
    end;

    if u13.Menu.Visible then
        CameraController.setForceLockOverride("Menu", true);
    end;

    local function syncMenuAndTeamSelectionState() -- Line: 1067
        -- upvalues: syncControlLockWithMenuVisibility (ref), syncCameraWithTeamSelection (ref)
        syncControlLockWithMenuVisibility();
        syncCameraWithTeamSelection();
    end;

    u13.Menu:GetPropertyChangedSignal("Visible"):Connect(syncControlLockWithMenuVisibility);
    local Gameplay = u13:FindFirstChild("Gameplay");
    local v102;

    if Gameplay then
        v102 = Gameplay:FindFirstChild("Middle");
    else
        v102 = Gameplay;
    end;

    if v102 then
        v102 = v102:FindFirstChild("TeamSelection");
    end;

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    if v102 and v102:IsA("GuiObject") then
        v102:GetPropertyChangedSignal("Visible"):Connect(syncMenuAndTeamSelectionState);
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

        if not u13.Menu.Visible then
            u13.Menu.Visible = true;
        end;

        u13.Gameplay.Visible = false;
        u13.Gameplay.Bottom.Visible = false;
    end;

    UserInputService.InputBegan:Connect(function(p103, p104) -- Line: 1105
        -- upvalues: u13 (ref), MenuState (ref), LocalPlayer (ref), u12 (ref), cycleUtilityButtons (ref), getControllerCurrentTab (ref), u58 (ref), goToTab (ref)
        if not (u13 and u13.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        local v105 = p103.KeyCode == Enum.KeyCode.ButtonL1;

        if not v105 and p103.KeyCode ~= Enum.KeyCode.ButtonR1 then
            return;
        end;

        if MenuState.IsSelectionWithin(u12.Top.Buttons) then
            cycleUtilityButtons(v105);

            return;
        end;

        if MenuState.HandleBumperInput(v105) then
            return;
        end;

        local v106 = getControllerCurrentTab();
        local table_find_ret = table.find(u58, v106);
        local v107;

        if table_find_ret then
            local v108 = #u58;

            if v105 then
                v107 = u58[(table_find_ret - 2 + v108) % v108 + 1];
            else
                v107 = u58[table_find_ret % v108 + 1];
            end;
        else
            v107 = nil;
        end;

        if v107 then
            goToTab(v107, v107 == "Play");
        end;
    end);
    UserInputService.InputBegan:Connect(function(p109) -- Line: 1141
        -- upvalues: u13 (ref), MenuState (ref), LocalPlayer (ref), GuiService (ref), u10 (ref), u9 (ref), getPageButtonForBack (ref), CloseButtonRegistry (ref), Router (ref)
        if p109.KeyCode ~= Enum.KeyCode.ButtonB or not (u13 and u13.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or (MenuState.IsCaseSceneActive() or LocalPlayer:GetAttribute("IsPlayerChatting")) then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject == nil and os.clock() - u10 < 0.1 then
            SelectedObject = u9;
        end;

        local u110 = getPageButtonForBack(SelectedObject);

        if not u110 then
            return;
        end;

        task.defer(function() -- Line: 1160
            -- upvalues: CloseButtonRegistry (ref), GuiService (ref), u110 (copy), Router (ref)
            if CloseButtonRegistry.IsDoublePressed() then
                return;
            end;

            GuiService.SelectedObject = u110;
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end);
    end);
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 1169
        -- upvalues: u9 (ref), u8 (ref), GuiService (ref), u10 (ref)
        u9 = u8;
        u8 = GuiService.SelectedObject;
        u10 = os.clock();
    end);
    UserInputService.InputBegan:Connect(function(p111, p112) -- Line: 1177
        -- upvalues: u13 (ref), MenuState (ref), LocalPlayer (ref), getTopButton (ref), GuiService (ref), u1 (ref)
        if not (u13 and u13.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") or (p111.UserInputType ~= Enum.UserInputType.Gamepad1 or p111.KeyCode ~= Enum.KeyCode.ButtonA) then
            return;
        end;

        local v113 = getTopButton("Play");

        if not v113 then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject ~= v113 and not (SelectedObject and SelectedObject:IsDescendantOf(v113)) then
            return;
        end;

        u1.openFrame("Play", true);
    end);
    u1.openFrame("Dashboard");
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 1207
        -- upvalues: u13 (ref), GuiService (ref), MenuState (ref), u12 (ref), u58 (ref), getTopButton (ref), u7 (ref), tweenButton (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref), Router (ref)
        if not (u13 and u13.Menu.Visible) then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if MenuState.IsInspectActive() or (MenuState.IsCaseSceneActive() or not (u12 and SelectedObject)) then
            return;
        end;

        local v114 = nil;

        for _, v in ipairs(u58) do
            local v115 = getTopButton(v);

            if v115 and (SelectedObject == v115 or SelectedObject:IsDescendantOf(v115)) then
                v114 = v115;
                break;
            end;
        end;

        local v116;

        if v114 then
            v116 = v114;
        else
            v116 = getTopButton("Dashboard");

            if not (v116 and (SelectedObject == v116 or SelectedObject:IsDescendantOf(v116))) then
                v116 = v114;
            end;
        end;

        if v116 and u7 ~= v116 then
            local v117 = u7;
            u7 = v116;
            tweenButton(v116, Color3_fromRGB_ret2);

            if v117 and v117 ~= v116 then
                tweenButton(v117, Color3_fromRGB_ret);
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end;
    end);
    MenuState.OnScreenChanged:Connect(function(p118, p119) -- Line: 1239
        -- upvalues: u13 (ref), u6 (ref), u12 (ref), u7 (ref), tweenButton (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref)
        if not p119 then
            return;
        end;

        local v120 = u13.Menu:FindFirstChild(p119);

        if v120 and v120:IsA("Frame") then
            u6 = v120;
        end;

        local v121 = u12.Bottom.Buttons:FindFirstChild(p119) or u12.Top.Buttons:FindFirstChild(p119);

        if v121 and (v121:IsA("GuiButton") and u7 ~= v121) then
            local v122 = u7;
            u7 = v121;
            tweenButton(v121, Color3_fromRGB_ret2);

            if v122 and v122 ~= v121 then
                tweenButton(v122, Color3_fromRGB_ret);
            end;
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function(p123) -- Line: 1261
        -- upvalues: Profiler (ref), u13 (ref), MenuState (ref), CameraController (ref)
        Profiler.defer("UI.Top.CharacterAddedDeferred", function() -- Line: 1264
            -- upvalues: u13 (ref), MenuState (ref), CameraController (ref)
            if not (u13.Menu.Visible or (u13.Gameplay.Middle.TeamSelection.Visible or (MenuState.IsCaseSceneActive() or MenuState.IsInspectActive()))) then
                CameraController.resetForceLockOverride();
                CameraController.setPerspective(true, false);
            end;
        end);
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function(p124) -- Line: 1278
        -- upvalues: u1 (ref)
        if p124 == "Spectators" then
            u1.CloseTeamSelection();
        end;
    end);
    GameState.ListenToState(function(p125, p126) -- Line: 1284
        -- upvalues: MenuState (ref), u13 (ref), CameraController (ref), IsTutorialMode (ref), u1 (ref), ReplicatedStorage (ref), Router (ref), shouldPreserveMenuFrame (ref), LocalPlayer (ref), TeamSelection (ref), Profiler (ref)
        if MenuState.IsCaseSceneActive() then
            if p126 == "Game Ending" or p126 == "Map Voting" then
                u13.Gameplay.Bottom.Visible = false;
                u13.Gameplay.Visible = false;
            end;

            return;
        end;

        if MenuState.IsInspectActive() then
            return;
        end;

        if MenuState.IsTradeUpActive() then
            if p126 == "Game Ending" or p126 == "Map Voting" then
                u13.Gameplay.Bottom.Visible = false;
                u13.Gameplay.Visible = false;

                if not u13.Menu.Visible then
                    CameraController.setForceLockOverride("Menu", true);
                    u13.Menu.Visible = true;
                end;
            end;

            return;
        end;

        if p126 == "Game Ending" or p126 == "Map Voting" then
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

            u13.Gameplay.Visible = false;
            u13.Gameplay.Bottom.Visible = false;

            if MenuState.IsInspectActive() then
                Router.broadcastRouter("WeaponInspectCloseForGameEnd");
            end;

            if not shouldPreserveMenuFrame() then
                u1.ResetToMainMenu();
            end;

            if not u13.Menu.Visible then
                CameraController.setForceLockOverride("Menu", true);
                u13.Menu.Visible = true;
            end;
        end;

        if p126 == "Map Voting" then
            if LocalPlayer:GetAttribute("FollowGamemode") or LocalPlayer:GetAttribute("IsSpectating") then
                if u13.Menu.Visible and (MenuState.WantsMainMenu() or shouldPreserveMenuFrame()) then
                    return;
                end;

                u1.openFrame("Play");

                return;
            end;

            if not (u13.Menu.Visible or shouldPreserveMenuFrame()) then
                u1.openFrame("Dashboard");
                u1.ToggleMenu();
            end;
        end;

        if not (p125 ~= "Game Ending" and p125 ~= "Map Voting" or (p126 == "Game Ending" or p126 == "Map Voting")) then
            if IsTutorialMode() and u13.Menu.Visible then
                return;
            end;

            if p125 == "Map Voting" then
                if u13.Menu.Visible then
                    return;
                end;

                if MenuState.WantsMainMenu() then
                    u1.ResetToMainMenu();
                    CameraController.setForceLockOverride("Menu", true);
                    u13.Gameplay.Visible = false;
                    u13.Gameplay.Bottom.Visible = false;
                    u13.Menu.Visible = true;

                    return;
                end;

                local Attribute2 = LocalPlayer:GetAttribute("Team");

                if not (LocalPlayer.Character and (Attribute2 and Attribute2 ~= "Spectators")) then
                    MenuState.HideMenu();
                    u13.Gameplay.Visible = true;
                    u13.Gameplay.Top.Visible = true;
                    TeamSelection.openFrame();

                    return;
                end;
            elseif u13.Menu.Visible and shouldPreserveMenuFrame() then
                return;
            end;

            Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                -- upvalues: MenuState (ref), ReplicatedStorage (ref), u13 (ref), shouldPreserveMenuFrame (ref), u1 (ref), CameraController (ref)
                if MenuState.IsInspectActive() then
                    return;
                end;

                if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive() and not u13.Menu.Visible then
                    if not shouldPreserveMenuFrame() then
                        u1.ResetToMainMenu();
                    end;

                    CameraController.setForceLockOverride("Menu", true);
                    u13.Gameplay.Visible = false;
                    u13.Menu.Visible = true;
                end;
            end);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "LastShopVersionViewed", updateStoreNewAlert);
    local v127 = getTopButton("Store");

    if v127 then
        v127 = v127:FindFirstChild("NewAlert");
    end;

    if not (v127 and v127:IsA("GuiObject")) then
        v127 = nil;
    end;

    if v127 then
        local v128;

        if DataController.IsDataLoaded(LocalPlayer) then
            v128 = DataController.Get(LocalPlayer, "LastShopVersionViewed") ~= Constants.SHOP_VERSION;
        else
            v128 = false;
        end;

        v127.Visible = v128;
    end;

    GameState.ListenToState(function() -- Line: 1440
        -- upvalues: Profiler (ref), autoJoinMatch (ref)
        Profiler.defer("UI.Top.AutoJoinTutorialDeferred", autoJoinMatch);
    end);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(autoJoinMatch);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(autoJoinMatch);
    workspace:GetAttributeChangedSignal("BotLobby"):Connect(autoJoinMatch);
    workspace.ChildAdded:Connect(function(p129) -- Line: 1446
        -- upvalues: autoJoinMatch (ref)
        if p129.Name == "Map" then
            autoJoinMatch();
        end;
    end);
    Profiler.defer("UI.Top.AutoJoinTutorialDeferred", autoJoinMatch);
    local u130 = workspace:GetAttribute("TutorialActive") == true;
    workspace:GetAttributeChangedSignal("TutorialActive"):Connect(function() -- Line: 1454
        -- upvalues: u130 (ref), u1 (ref)
        local v131 = workspace:GetAttribute("TutorialActive") == true;

        if u130 and not v131 then
            u1.ShowMainMenu();
        end;

        u130 = v131;
    end);
end;

return u1;