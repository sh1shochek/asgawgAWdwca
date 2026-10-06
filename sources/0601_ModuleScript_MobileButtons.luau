-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local MobileAutoShootController = require(ReplicatedStorage.Controllers.MobileAutoShootController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CanPlayerUseChatService = require(ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local ApplyMobileButtonLayout = require(ReplicatedStorage.Components.Common.ApplyMobileButtonLayout);
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Promise = require(ReplicatedStorage.Shared.Promise);
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard);
local Chat = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat);
local HoverBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb);
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
local ChatModes = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.ChatModes);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local script_Buttons = require(script.Buttons);
local script_Loadout = require(script.Loadout);
local script_TouchIntent = require(script.TouchIntent);
local LocalPlayer = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local CameraInput = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("CameraInput"));
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = false;
local v2 = GetUserPlatform();
local u3 = table.find(v2, "Mobile") and #v2 <= 1;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = 0;
local u10 = false;
local u11 = {};
local u12 = {};
local u13 = {};
local TweenInfo_new_ret = TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
local BUTTONS_WITH_EXPLICIT_INPUT_ENDED = script_Buttons.BUTTONS_WITH_EXPLICIT_INPUT_ENDED;
local BUTTONS_WITH_EXPLICIT_HANDLERS = script_Buttons.BUTTONS_WITH_EXPLICIT_HANDLERS;
local BUTTONS_EXCLUDED_FROM_CLEARING = script_Buttons.BUTTONS_EXCLUDED_FROM_CLEARING;
local BUTTONS_WITH_CAMERA_DRAG = script_Buttons.BUTTONS_WITH_CAMERA_DRAG;
local SPECTATE_MOBILE_BUTTONS = script_Buttons.SPECTATE_MOBILE_BUTTONS;
local GAMEPLAY_MOBILE_BUTTONS = script_Buttons.GAMEPLAY_MOBILE_BUTTONS;
local u14 = { "EndScreen", "Halftime" };
local u15 = nil;
local u16 = nil;
local u17 = nil;

local function GetWeaponDataFromInstance(p18: userdata?) -- Line: 133
    -- upvalues: CollectionService (copy)
    while p18 do
        if CollectionService:HasTag(p18, "WeaponDropped") then
            local Attribute = p18:GetAttribute("Weapon");
            local Attribute2 = p18:GetAttribute("Skin");

            if Attribute and Attribute2 then
                return Attribute, Attribute2, p18.Name;
            end;

            break;
        end;

        p18 = p18.Parent;
    end;

    return nil, nil, nil;
end;

local function GetPingRaycastResult(...) -- Line: 150
    -- upvalues: workspace_CurrentCamera (copy), RaycastParams_new_ret (copy)
    local v19 = { workspace_CurrentCamera, ... };
    RaycastParams_new_ret.FilterDescendantsInstances = v19;
    local v20 = workspace:Raycast(workspace_CurrentCamera.CFrame.Position, workspace_CurrentCamera.CFrame.LookVector * 1000, RaycastParams_new_ret);

    while v20 and v20.Instance do
        local Instance2 = v20.Instance;

        if not Instance2:IsA("BasePart") or Instance2.Transparency <= 0.98 then
            break;
        end;

        table.insert(v19, Instance2);
        RaycastParams_new_ret.FilterDescendantsInstances = v19;
        v20 = workspace:Raycast(v20.Position, workspace_CurrentCamera.CFrame.LookVector.Unit * (1000 - v20.Distance), RaycastParams_new_ret);
    end;

    return v20;
end;

local function ValidateButtonTouch(p21: userdata, p22: userdata?) -- Line: 177
    -- upvalues: u11 (copy)
    local v23 = u11[p21];
    local v24;

    if v23 == nil then
        v24 = false;
    else
        v24 = p22 == nil and true or p22 == v23;
    end;

    return v24;
end;

local function IsNewTouch(p25: userdata) -- Line: 182
    return p25.UserInputState == Enum.UserInputState.Begin;
end;

local function IsPressInput(p26: userdata) -- Line: 186
    return p26.UserInputType == Enum.UserInputType.Touch and true or p26.UserInputType == Enum.UserInputType.MouseButton1;
end;

local u27 = nil;

local function TrackButtonTouchStart(u28: userdata, p29: userdata) -- Line: 193
    -- upvalues: u11 (copy), BUTTONS_WITH_CAMERA_DRAG (copy), script_TouchIntent (copy), u27 (ref)
    if not u11[u28] and p29.UserInputState == Enum.UserInputState.Begin then
        u11[u28] = p29;

        if not BUTTONS_WITH_CAMERA_DRAG[u28.Name] then
            script_TouchIntent.track(p29, u28, function(p30: userdata) -- Line: 199
                -- upvalues: u27 (ref), u28 (copy)
                if u27 then
                    u27(u28, p30);
                end;
            end);
        end;
    end;
end;

local function TrackButtonTouchEnd(p31: userdata, p32: userdata) -- Line: 208
    -- upvalues: u11 (copy)
    if u11[p31] == p32 then
        u11[p31] = nil;
    end;
end;

local function IsInputInsideButton(p33: userdata, p34: userdata) -- Line: 215
    local Position = p34.Position;
    local AbsolutePosition = p33.AbsolutePosition;
    local AbsoluteSize = p33.AbsoluteSize;
    local v35;

    if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
        v35 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v35 = false;
    end;

    return v35;
end;

local function SetButtonVisibility(p36: string, p37: boolean) -- Line: 225
    -- upvalues: u15 (ref), u13 (copy)
    local v38 = u15:FindFirstChild(p36);

    if v38 then
        if p37 then
            p37 = not u13[p36];
        end;

        v38.Visible = p37;
    end;
end;

local function SetToggledIndicator(p39: userdata?, p40: boolean) -- Line: 232
    if p39 then
        p39 = p39:FindFirstChild("Toggled");
    end;

    if p39 and (p39:IsA("GuiObject") and p39.Visible ~= p40) then
        p39.Visible = p40;
    end;
end;

local function IsAlternativeActionActive() -- Line: 239
    -- upvalues: u5 (ref), InventoryController (copy)
    if u5 ~= nil then
        return true;
    end;

    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v41 = CurrentEquipped and CurrentEquipped.Viewmodel and CurrentEquipped.Viewmodel.Bobble;

    if v41 then
        v41 = v41.IsAiming;
    end;

    return v41 == true;
end;

local function UpdateToggledIndicators() -- Line: 251
    -- upvalues: u15 (ref), CharacterController (copy), Leaderboard (copy), u5 (ref), InventoryController (copy)
    local Crouch = u15:FindFirstChild("Crouch");
    local v42 = CharacterController.GetCrouchState() == true;

    if Crouch then
        Crouch = Crouch:FindFirstChild("Toggled");
    end;

    if Crouch and (Crouch:IsA("GuiObject") and Crouch.Visible ~= v42) then
        Crouch.Visible = v42;
    end;

    local ToggleWalk = u15:FindFirstChild("ToggleWalk");
    local v43 = CharacterController.GetWalkState() == true;

    if ToggleWalk then
        ToggleWalk = ToggleWalk:FindFirstChild("Toggled");
    end;

    if ToggleWalk and (ToggleWalk:IsA("GuiObject") and ToggleWalk.Visible ~= v43) then
        ToggleWalk.Visible = v43;
    end;

    local ToggleScoreboard = u15:FindFirstChild("ToggleScoreboard");
    local v44 = Leaderboard.IsOpen() == true;

    if ToggleScoreboard then
        ToggleScoreboard = ToggleScoreboard:FindFirstChild("Toggled");
    end;

    if ToggleScoreboard and (ToggleScoreboard:IsA("GuiObject") and ToggleScoreboard.Visible ~= v44) then
        ToggleScoreboard.Visible = v44;
    end;

    local AlternativeAction = u15:FindFirstChild("AlternativeAction");
    local v45;

    if u5 == nil then
        local CurrentEquipped = InventoryController.getCurrentEquipped();
        local v46 = CurrentEquipped and CurrentEquipped.Viewmodel and CurrentEquipped.Viewmodel.Bobble;

        if v46 then
            v46 = v46.IsAiming;
        end;

        v45 = v46 == true;
    else
        v45 = true;
    end;

    if AlternativeAction then
        AlternativeAction = AlternativeAction:FindFirstChild("Toggled");
    end;

    if AlternativeAction and (AlternativeAction:IsA("GuiObject") and AlternativeAction.Visible ~= v45) then
        AlternativeAction.Visible = v45;
    end;
end;

local function UpdateButtonVisibilityForSpectate(p47: boolean) -- Line: 258
    -- upvalues: u15 (ref), GAMEPLAY_MOBILE_BUTTONS (copy), SPECTATE_MOBILE_BUTTONS (copy), u13 (copy), script_Loadout (copy), u10 (ref)
    if not u15 then
        return;
    end;

    for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
        local v48 = not p47 or table.find(SPECTATE_MOBILE_BUTTONS, v) ~= nil;
        local v49 = u15:FindFirstChild(v);

        if v49 then
            if v48 then
                v48 = not u13[v];
            end;

            v49.Visible = v48;
        end;
    end;

    for _, v in ipairs(script_Loadout.GetSlotButtonNames()) do
        local v50 = not p47 and script_Loadout.IsSlotFilled(v);
        local v51 = u15:FindFirstChild(v);

        if v51 then
            if v50 then
                v50 = not u13[v];
            end;

            v51.Visible = v50;
        end;
    end;

    local v52 = not u10 and u15:FindFirstChild("Chat");

    if v52 then
        v52.Visible = false;
    end;
end;

local function IsSiblingFrameVisible(p53: string) -- Line: 275
    -- upvalues: u16 (ref), u15 (ref)
    local v54 = u16 or u15 and u15.Parent;

    if v54 then
        v54 = v54:FindFirstChild(p53);
    end;

    local v55;

    if v54 == nil then
        v55 = false;
    else
        v55 = v54:IsA("GuiObject") and v54.Visible;
    end;

    return v55;
end;

local function GetDesiredFrameVisibility(p56: userdata?) -- Line: 281
    -- upvalues: u3 (copy), u14 (copy), u16 (ref), u15 (ref), LocalPlayer (copy)
    if not u3 then
        return false;
    end;

    for _, v in ipairs(u14) do
        local v57 = u16 or u15 and u15.Parent;

        if v57 then
            v57 = v57:FindFirstChild(v);
        end;

        local v58;

        if v57 == nil then
            v58 = false;
        else
            v58 = v57:IsA("GuiObject") and v57.Visible;
        end;

        if v58 then
            return false;
        end;
    end;

    local Character = LocalPlayer.Character;

    if Character == p56 then
        Character = nil;
    end;

    local v59;

    if Character == nil then
        v59 = false;
    else
        v59 = Character:IsDescendantOf(workspace);
    end;

    local v60 = u16 or u15 and u15.Parent;

    if v60 then
        v60 = v60:FindFirstChild("TeamSelection");
    end;

    local v61;

    if v60 == nil then
        v61 = false;
    else
        v61 = v60:IsA("GuiObject") and v60.Visible;
    end;

    if v61 and not v59 then
        return false;
    end;

    return v59 or LocalPlayer:GetAttribute("IsSpectating") == true;
end;

local u62 = nil;

local function RefreshButtonVisibility(p63: userdata?, p64: boolean?) -- Line: 306
    -- upvalues: u15 (ref), GetDesiredFrameVisibility (copy), LocalPlayer (copy), u62 (ref), UpdateButtonVisibilityForSpectate (copy)
    if not u15 then
        return;
    end;

    local v65 = GetDesiredFrameVisibility(p63);
    local Visible = u15.Visible;
    u15.Visible = v65;
    local v66 = LocalPlayer:GetAttribute("IsSpectating") == true;

    if v65 and (p64 ~= false or (not Visible or u62 ~= v66)) then
        UpdateButtonVisibilityForSpectate(v66);
    end;

    u62 = v66;
end;

local function GetHoveredHostage() -- Line: 321
    -- upvalues: CenterScreenRaycast (copy)
    return CenterScreenRaycast.GetHoveredHostage();
end;

local function GetHoveredBreakableDoor() -- Line: 325
    -- upvalues: CenterScreenRaycast (copy), CollectionService (copy)
    local v67 = {};
    local v68 = CenterScreenRaycast.FindTaggedModelInSight("BreakableDoor", 8);

    if v68 and (v68:IsA("Model") and v68:GetAttribute("Destroyed") ~= true) then
        table.insert(v67, v68);

        for _, v in CollectionService:GetTagged("BreakableDoor") do
            if v ~= v68 and v:GetAttribute("Destroyed") ~= true then
                local BreakableDoorHingePivot = v68:FindFirstChild("BreakableDoorHingePivot");
                local BreakableDoorHingePivot2 = v:FindFirstChild("BreakableDoorHingePivot");

                if BreakableDoorHingePivot and (BreakableDoorHingePivot2 and (BreakableDoorHingePivot.Position - BreakableDoorHingePivot2.Position).Magnitude <= 20) then
                    table.insert(v67, v);
                end;
            end;
        end;
    end;

    return v67;
end;

local function MultiplyUdim2(p69, p70: number) -- Line: 353
    return UDim2.fromScale(p69.X.Scale * p70, p69.Y.Scale * p70);
end;

local function GetButtonRestingSize(p71: userdata) -- Line: 357
    -- upvalues: u12 (copy)
    return u12[p71] or p71.Size;
end;

local function SetButtonRestingSize(p72: userdata, p73) -- Line: 361
    -- upvalues: u12 (copy)
    u12[p72] = p73 or p72.Size;
end;

local function TweenButtonToRestingScale(p74: userdata, p75: number) -- Line: 365
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), u12 (copy)
    local v76 = {};
    local v77 = u12[p74] or p74.Size;
    v76.Size = UDim2.fromScale(v77.X.Scale * p75, v77.Y.Scale * p75);
    TweenService:Create(p74, TweenInfo_new_ret, v76):Play();
end;

u27 = function(p78: userdata, p79: userdata) -- Line: 373
    -- upvalues: u11 (copy), TweenButtonToRestingScale (copy)
    if u11[p78] == p79 then
        u11[p78] = nil;
    end;

    TweenButtonToRestingScale(p78, 1);
end;

local function GetCurrentEquipped() -- Line: 381
    -- upvalues: Promise (copy), InventoryController (copy)
    return Promise.new(function(p80, p81) -- Line: 382
        -- upvalues: InventoryController (ref)
        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if CurrentEquipped then
            p80(CurrentEquipped);

            return;
        end;

        p81("Failed to fetch current equipped");
    end):catch(warn);
end;

local function SetInteractIcon(p82: boolean, p83: boolean) -- Line: 393
    -- upvalues: u15 (ref), u13 (copy)
    u15.Interact.Defuse.Visible = p82;
    u15.Interact.Use.Visible = p83;
    local v84 = p82 or p83;
    local Interact = u15:FindFirstChild("Interact");

    if Interact then
        if v84 then
            v84 = not u13.Interact;
        end;

        Interact.Visible = v84;
    end;
end;

local function UpdateInteractButton() -- Line: 399
    -- upvalues: u15 (ref), CollectionService (copy), u8 (ref), LocalPlayer (copy), HoverBomb (copy), CenterScreenRaycast (copy), GetHoveredBreakableDoor (copy), u13 (copy)
    if not u15 then
        return;
    end;

    if u15.Shop.Visible then
        u15.Interact.Defuse.Visible = false;
        u15.Interact.Use.Visible = false;
        local Interact = u15:FindFirstChild("Interact");

        if Interact then
            Interact.Visible = false;
        end;

        return;
    end;

    local v85 = CollectionService:GetTagged("Bomb")[1];
    local v86;

    if v85 then
        v86 = v85:GetAttribute("Defused") or (v85:GetAttribute("Exploding") or v85:GetAttribute("Exploded"));
    else
        v86 = v85;
    end;

    local v87 = u8 or LocalPlayer:GetAttribute("IsDefusingBomb") == true;
    local v88 = v85 and (not v86 and HoverBomb.IsDefuseAllowed());

    if v88 then
        if not v87 then
            v87 = v85:GetAttribute("CanDefuse") and not v85:GetAttribute("IsGettingDefused");
        end;
    else
        v87 = v88;
    end;

    local v89 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
    local v90 = CenterScreenRaycast.GetHoveredHostage() ~= nil;
    local v91 = GetHoveredBreakableDoor();
    local v92;

    if v91 == nil then
        v92 = false;
    else
        v92 = #v91 > 0;
    end;

    if v87 then
        u15.Interact.Defuse.Visible = true;
        u15.Interact.Use.Visible = false;
        local Interact = u15:FindFirstChild("Interact");

        if Interact then
            Interact.Visible = not u13.Interact;
        end;
    else
        local v93 = v89 or (v90 or v92);
        u15.Interact.Defuse.Visible = false;
        u15.Interact.Use.Visible = v93;
        local Interact = u15:FindFirstChild("Interact");

        if Interact then
            if v93 then
                v93 = not u13.Interact;
            end;

            Interact.Visible = v93;
        end;
    end;
end;

local function HasAlternativeAction(p94) -- Line: 447
    -- upvalues: GameState (copy)
    if not (p94 and p94.Properties) then
        return false;
    end;

    local Properties = p94.Properties;

    return (Properties.HasScope == true or Properties.HasSuppressor == true) and true or ((Properties.ShootingOptions == "Burst" or Properties.ShootingOptions == "Revolver") and true or ((Properties.Type == "Equipment" or (Properties.Class == "Grenade" and true or Properties.Slot == "Grenade")) and GameState.GetState() ~= "Buy Period" and true or false));
end;

local function UpdateAlternativeActionButton() -- Line: 467
    -- upvalues: SpectateController (copy), u15 (ref), HasAlternativeAction (copy), InventoryController (copy), u13 (copy)
    if SpectateController.IsLocalPlayerDead() then
        local AlternativeAction = u15:FindFirstChild("AlternativeAction");

        if AlternativeAction then
            AlternativeAction.Visible = false;
        end;

        return;
    end;

    local v95 = HasAlternativeAction(InventoryController.getCurrentEquipped());
    local AlternativeAction = u15:FindFirstChild("AlternativeAction");

    if AlternativeAction then
        if v95 then
            v95 = not u13.AlternativeAction;
        end;

        AlternativeAction.Visible = v95;
    end;
end;

local function CanDropCurrentEquipped(p96) -- Line: 476
    -- upvalues: SpectateController (copy), IsTutorialMode (copy), GameState (copy)
    if not p96 or (SpectateController.IsLocalPlayerDead() or IsTutorialMode()) then
        return false;
    end;

    local Properties = p96.Properties;

    if not Properties then
        return false;
    end;

    local v97;

    if Properties.Class == "Melee" then
        v97 = workspace:GetAttribute("VIPKnifeDropEnabled") == true;
    else
        v97 = false;
    end;

    if not (Properties.Droppable or v97) then
        return false;
    end;

    if GameState.GetState() == "Warmup" or workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false;
    end;

    return (Properties.Class ~= "C4" or not p96.IsPlanting) and true or false;
end;

local function UpdateDropButton() -- Line: 501
    -- upvalues: CanDropCurrentEquipped (copy), InventoryController (copy), u15 (ref), u13 (copy)
    local v98 = CanDropCurrentEquipped(InventoryController.getCurrentEquipped());
    local Drop = u15:FindFirstChild("Drop");

    if Drop then
        if v98 then
            v98 = not u13.Drop;
        end;

        Drop.Visible = v98;
    end;
end;

local function UpdateReloadButton() -- Line: 505
    -- upvalues: SpectateController (copy), u15 (ref), InventoryController (copy), u13 (copy)
    if SpectateController.IsLocalPlayerDead() then
        local Reload = u15:FindFirstChild("Reload");

        if Reload then
            Reload.Visible = false;
        end;

        return;
    end;

    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v99;

    if CurrentEquipped == nil then
        v99 = false;
    else
        v99 = CurrentEquipped.Properties.Class == "Weapon";
    end;

    local Reload = u15:FindFirstChild("Reload");

    if Reload then
        if v99 then
            v99 = not u13.Reload;
        end;

        Reload.Visible = v99;
    end;
end;

local function UpdatePingButton() -- Line: 516
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u15 (ref), u13 (copy)
    if LocalPlayer:GetAttribute("IsSpectating") == true or SpectateController.IsLocalPlayerDead() then
        local Ping = u15:FindFirstChild("Ping");

        if Ping then
            Ping.Visible = false;
        end;

        return;
    end;

    local v100 = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
    local Ping = u15:FindFirstChild("Ping");

    if Ping then
        if v100 then
            v100 = not u13.Ping;
        end;

        Ping.Visible = v100;
    end;
end;

local function UpdateInspectButton() -- Line: 526
    -- upvalues: u15 (ref), SpectateController (copy), InventoryController (copy), u13 (copy)
    if not u15:FindFirstChild("Inspect") then
        return;
    end;

    if SpectateController.IsLocalPlayerDead() then
        local Inspect = u15:FindFirstChild("Inspect");

        if Inspect then
            Inspect.Visible = false;
        end;

        return;
    end;

    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v101 = CurrentEquipped and CurrentEquipped.Viewmodel and CurrentEquipped.Viewmodel.Animation;
    local v102;

    if v101 == nil or v101.hasInspectAnimation == nil then
        v102 = false;
    else
        v102 = v101:hasInspectAnimation();
    end;

    local v103 = v102 == true;
    local Inspect = u15:FindFirstChild("Inspect");

    if Inspect then
        if v103 then
            v103 = not u13.Inspect;
        end;

        Inspect.Visible = v103;
    end;
end;

local function GetRarityRGB(p104) -- Line: 544
    return math.floor(p104.Color.R * 255), math.floor(p104.Color.G * 255), math.floor(p104.Color.B * 255);
end;

local function BindPressFeedback(u105: userdata) -- Line: 552
    -- upvalues: TrackButtonTouchStart (copy), u11 (copy), TweenButtonToRestingScale (copy)
    u105.InputBegan:Connect(function(p106: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), u105 (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p106.UserInputType ~= Enum.UserInputType.Touch and p106.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p106.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(u105, p106);

            if u11[u105] == p106 then
                TweenButtonToRestingScale(u105, 0.9);
            end;
        end;
    end);
end;

local function BindTapButton(u107: userdata, u108: function) -- Line: 567
    -- upvalues: TrackButtonTouchStart (copy), u11 (copy), TweenButtonToRestingScale (copy)
    u107.InputBegan:Connect(function(p109: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), u107 (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p109.UserInputType ~= Enum.UserInputType.Touch and p109.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p109.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(u107, p109);

            if u11[u107] == p109 then
                TweenButtonToRestingScale(u107, 0.9);
            end;
        end;
    end);
    u107.InputEnded:Connect(function(p110: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), u107 (copy), u11 (ref), u108 (copy)
        if p110.UserInputType ~= Enum.UserInputType.Touch and p110.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u107, 1);
        local v111 = u11[u107];
        local v112;

        if v111 == nil then
            v112 = false;
        else
            v112 = p110 == nil and true or p110 == v111;
        end;

        if not v112 then
            local v113 = u107;

            if u11[v113] == p110 then
                u11[v113] = nil;
            end;

            return;
        end;

        local v114 = u107;

        if u11[v114] == p110 then
            u11[v114] = nil;
        end;

        u108();
    end);
end;

function u1.HighlightButton(p115: string, p116: number) -- Line: 588
    -- upvalues: u15 (ref), u11 (copy), u12 (copy), TweenService (copy)
    local u117 = u15 and u15:FindFirstChild(p115);

    if not (u117 and (u117:IsA("TextButton") and not u11[u117])) then
        return;
    end;

    local v118 = u12[u117] or u117.Size;
    local math_round_ret = math.round(p116 / 1);
    local math_max_ret = math.max(1, math_round_ret);
    u117.Size = v118;
    local v119 = TweenService:Create(u117, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, math_max_ret - 1, true), {
        Size = UDim2.fromScale(v118.X.Scale * 1.2, v118.Y.Scale * 1.2)
    });
    v119.Completed:Once(function(p120) -- Line: 602
        -- upvalues: u117 (copy), u12 (ref)
        if p120 == Enum.PlaybackState.Completed then
            local v121 = u117;
            u117.Size = u12[v121] or v121.Size;
        end;
    end);
    v119:Play();
end;

function u1.setupButton(u122: userdata) -- Line: 610
    -- upvalues: Profiler (copy), u12 (copy), BUTTONS_WITH_EXPLICIT_HANDLERS (copy), TrackButtonTouchStart (copy), u11 (copy), TweenButtonToRestingScale (copy), BUTTONS_EXCLUDED_FROM_CLEARING (copy), BUTTONS_WITH_EXPLICIT_INPUT_ENDED (copy)
    Profiler.mark("UI.MobileButtons.SetupButton");
    u12[u122] = u122.Size;
    u122.InputBegan:Connect(function(p123: userdata) -- Line: 615
        -- upvalues: BUTTONS_WITH_EXPLICIT_HANDLERS (ref), u122 (copy), TrackButtonTouchStart (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p123.UserInputType ~= Enum.UserInputType.Touch and p123.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p123.UserInputState == Enum.UserInputState.Begin then
            if not BUTTONS_WITH_EXPLICIT_HANDLERS[u122.Name] then
                TrackButtonTouchStart(u122, p123);
            end;

            if u11[u122] == p123 then
                TweenButtonToRestingScale(u122, 0.9);
            end;
        end;
    end);

    if not BUTTONS_EXCLUDED_FROM_CLEARING[u122.Name] then
        u122.InputChanged:Connect(function(p124: userdata) -- Line: 633
            -- upvalues: u11 (ref), u122 (copy), TweenButtonToRestingScale (ref)
            if p124.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if u11[u122] == p124 then
                local v125 = u122;
                local Position = p124.Position;
                local AbsolutePosition = v125.AbsolutePosition;
                local AbsoluteSize = v125.AbsoluteSize;
                local v126;

                if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
                    v126 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                else
                    v126 = false;
                end;

                if not v126 then
                    local v127 = u122;

                    if u11[v127] == p124 then
                        u11[v127] = nil;
                    end;

                    TweenButtonToRestingScale(u122, 1);
                end;
            end;
        end);
    end;

    u122.InputEnded:Connect(function(p128: userdata) -- Line: 649
        -- upvalues: TweenButtonToRestingScale (ref), u122 (copy), BUTTONS_WITH_EXPLICIT_INPUT_ENDED (ref), u11 (ref)
        if p128.UserInputType ~= Enum.UserInputType.Touch and p128.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u122, 1);

        if not BUTTONS_WITH_EXPLICIT_INPUT_ENDED[u122.Name] then
            local v129 = u122;

            if u11[v129] == p128 then
                u11[v129] = nil;
            end;
        end;
    end);
end;

function u1.Initialize(p130, p131) -- Line: 663
    -- upvalues: Profiler (copy), u15 (ref), u16 (ref), u7 (ref), u8 (ref), LocalPlayer (copy), u17 (ref), u12 (copy), u3 (copy), script_Loadout (copy), u13 (copy), TrackButtonTouchStart (copy), u11 (copy), script_TouchIntent (copy), CharacterController (copy), TweenButtonToRestingScale (copy), Promise (copy), InventoryController (copy), CanDropCurrentEquipped (copy), Skins (copy), Rarities (copy), Router (copy), u4 (ref), MobileAutoShootController (copy), SpectateController (copy), GameState (copy), CameraInput (copy), u5 (ref), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), CollectionService (copy), HoverBomb (copy), CenterScreenRaycast (copy), GetHoveredBreakableDoor (copy), Remotes (copy), BuyMenu (copy), u6 (ref), Leaderboard (copy), IsTutorialMode (copy), Chat (copy), Top (copy), u10 (ref), ChatModes (copy), HintController (copy), TeamSelection (copy), DataController (copy), CharacterResolver (copy), GetPingRaycastResult (copy), GetWeaponDataFromInstance (copy), u9 (ref), u1 (copy), RunServiceController (copy), GetDesiredFrameVisibility (copy), u62 (ref), UpdateButtonVisibilityForSpectate (copy), IsInBuyArea (copy), TutorialPurchaseLock (copy), UpdateInteractButton (copy), UpdateInspectButton (copy), UpdatePingButton (copy), HasAlternativeAction (copy), UpdateToggledIndicators (copy), UserInputService (copy)
    Profiler.mark("UI.MobileButtons.Initialize");
    u15 = p131;
    u16 = p131.Parent;
    u7 = nil;
    u8 = false;
    local u132 = p131:FindFirstAncestorOfClass("ScreenGui");
    local v133 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if u132 and v133 then
        local MobileControlsGui = v133:FindFirstChild("MobileControlsGui");

        if not (MobileControlsGui and MobileControlsGui:IsA("ScreenGui")) then
            MobileControlsGui = Instance.new("ScreenGui");
            MobileControlsGui.Name = "MobileControlsGui";
            MobileControlsGui.ResetOnSpawn = false;
            MobileControlsGui.IgnoreGuiInset = u132.IgnoreGuiInset;
            MobileControlsGui.ScreenInsets = u132.ScreenInsets;
            MobileControlsGui.SafeAreaCompatibility = u132.SafeAreaCompatibility;
            MobileControlsGui.ClipToDeviceSafeArea = u132.ClipToDeviceSafeArea;
            MobileControlsGui.ZIndexBehavior = u132.ZIndexBehavior;
            MobileControlsGui.DisplayOrder = 1000;
            MobileControlsGui.Parent = v133;
        end;

        u17 = MobileControlsGui;
        p131.Parent = MobileControlsGui;
        local u134 = u16;
        u134 = u134;
        local u135;

        if u134 then
            u135 = u134.Parent;
        else
            u135 = u134;
        end;

        local function syncHostVisibility() -- Line: 693
            -- upvalues: u132 (copy), u135 (copy), u134 (copy), MobileControlsGui (ref)
            local v136 = u132.Enabled and (u135 == nil or (not u135:IsA("GuiObject") or u135.Visible)) and (u134 == nil and true or (not u134:IsA("GuiObject") or u134.Visible));

            if MobileControlsGui.Enabled ~= v136 then
                MobileControlsGui.Enabled = v136;
            end;
        end;

        u132:GetPropertyChangedSignal("Enabled"):Connect(syncHostVisibility);

        if u135 and u135:IsA("GuiObject") then
            u135:GetPropertyChangedSignal("Visible"):Connect(syncHostVisibility);
        end;

        if u134 and u134:IsA("GuiObject") then
            u134:GetPropertyChangedSignal("Visible"):Connect(syncHostVisibility);
        end;

        local v137 = u132.Enabled and (u135 == nil or not u135:IsA("GuiObject") or u135.Visible) and (u134 == nil and true or (not u134:IsA("GuiObject") or u134.Visible));

        if MobileControlsGui.Enabled ~= v137 then
            MobileControlsGui.Enabled = v137;
        end;
    end;

    for _, child in ipairs(u15:GetChildren()) do
        if child:IsA("TextButton") then
            u12[child] = child.Size;
        end;

        local v138;

        if child then
            v138 = child:FindFirstChild("Toggled");
        else
            v138 = child;
        end;

        if v138 and (v138:IsA("GuiObject") and v138.Visible ~= false) then
            v138.Visible = false;
        end;
    end;

    if not u3 then
        u15.Visible = false;

        return;
    end;

    script_Loadout.Initialize(u15, function(p139: string, p140: boolean) -- Line: 722
        -- upvalues: LocalPlayer (ref), u15 (ref), u13 (ref)
        if p140 then
            p140 = LocalPlayer:GetAttribute("IsSpectating") ~= true;
        end;

        local v141 = u15:FindFirstChild(p139);

        if v141 then
            if p140 then
                p140 = not u13[p139];
            end;

            v141.Visible = p140;
        end;
    end);
    local v142 = u16 and u16.Parent;

    if v142 then
        v142 = v142:FindFirstChild("Top");
    end;

    local v143 = v142 and v142:FindFirstChild("Bomb Defusal");

    if v143 then
        v143.Size = UDim2.new(0.6, 0, 0.75, 0);
    end;

    u15.Jump.InputBegan:Connect(function(p144: userdata) -- Line: 740
        -- upvalues: TrackButtonTouchStart (ref), u15 (ref), u11 (ref), script_TouchIntent (ref), CharacterController (ref)
        if p144.UserInputType ~= Enum.UserInputType.Touch and p144.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p144.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        TrackButtonTouchStart(u15.Jump, p144);
        local v145 = u11[u15.Jump];
        local v146;

        if v145 == nil then
            v146 = false;
        else
            v146 = p144 == nil and true or p144 == v145;
        end;

        if v146 then
            script_TouchIntent.onTap(p144, CharacterController.jump);
        end;
    end);
    local Crouch = u15.Crouch;

    local function u147() -- Line: 754
        -- upvalues: CharacterController (ref)
        CharacterController.crouch(not CharacterController.GetCrouchState());
    end;

    Crouch.InputBegan:Connect(function(p148: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), Crouch (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p148.UserInputType ~= Enum.UserInputType.Touch and p148.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p148.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Crouch, p148);

            if u11[Crouch] == p148 then
                TweenButtonToRestingScale(Crouch, 0.9);
            end;
        end;
    end);
    Crouch.InputEnded:Connect(function(p149: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), Crouch (copy), u11 (ref), u147 (copy)
        if p149.UserInputType ~= Enum.UserInputType.Touch and p149.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Crouch, 1);
        local v150 = u11[Crouch];
        local v151;

        if v150 == nil then
            v151 = false;
        else
            v151 = p149 == nil and true or p149 == v150;
        end;

        if not v151 then
            local v152 = Crouch;

            if u11[v152] == p149 then
                u11[v152] = nil;
            end;

            return;
        end;

        local v153 = Crouch;

        if u11[v153] == p149 then
            u11[v153] = nil;
        end;

        u147();
    end);
    local ToggleWalk = u15.ToggleWalk;

    local function u154() -- Line: 759
        -- upvalues: LocalPlayer (ref), CharacterController (ref)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") then
            CharacterController.walk(not CharacterController.GetWalkState());
        end;
    end;

    ToggleWalk.InputBegan:Connect(function(p155: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), ToggleWalk (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p155.UserInputType ~= Enum.UserInputType.Touch and p155.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p155.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(ToggleWalk, p155);

            if u11[ToggleWalk] == p155 then
                TweenButtonToRestingScale(ToggleWalk, 0.9);
            end;
        end;
    end);
    ToggleWalk.InputEnded:Connect(function(p156: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), ToggleWalk (copy), u11 (ref), u154 (copy)
        if p156.UserInputType ~= Enum.UserInputType.Touch and p156.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(ToggleWalk, 1);
        local v157 = u11[ToggleWalk];
        local v158;

        if v157 == nil then
            v158 = false;
        else
            v158 = p156 == nil and true or p156 == v157;
        end;

        if not v158 then
            local v159 = ToggleWalk;

            if u11[v159] == p156 then
                u11[v159] = nil;
            end;

            return;
        end;

        local v160 = ToggleWalk;

        if u11[v160] == p156 then
            u11[v160] = nil;
        end;

        u154();
    end);
    u15.Drop.InputEnded:Connect(function(p161: userdata) -- Line: 766
        -- upvalues: u15 (ref), u11 (ref), Promise (ref), InventoryController (ref), CanDropCurrentEquipped (ref), Skins (ref), Rarities (ref), Router (ref)
        if p161.UserInputType ~= Enum.UserInputType.Touch and p161.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v162 = u11[u15.Drop];
        local v163;

        if v162 == nil then
            v163 = false;
        else
            v163 = p161 == nil and true or p161 == v162;
        end;

        local Drop = u15.Drop;

        if u11[Drop] == p161 then
            u11[Drop] = nil;
        end;

        if not v163 then
            return;
        end;

        Promise.new(function(p164, p165) -- Line: 382
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p164(CurrentEquipped);

                return;
            end;

            p165("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p166) -- Line: 776
            -- upvalues: CanDropCurrentEquipped (ref), Skins (ref), Rarities (ref), Router (ref)
            if p166 and CanDropCurrentEquipped(p166) then
                local SkinInformation = Skins.GetSkinInformation(p166.Name, p166.Skin);
                assert(SkinInformation, "Skin data not found for weapon: " .. p166.Name .. " and skin: " .. p166.Skin);
                local v167 = Rarities[SkinInformation.rarity];
                local math_floor_ret = math.floor(v167.Color.R * 255);
                local math_floor_ret2 = math.floor(v167.Color.G * 255);
                local math_floor_ret3 = math.floor(v167.Color.B * 255);

                if p166:drop() then
                    Router.broadcastRouter("CreateNotification", "Item Dropped", `You dropped your <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{p166.Name} | {p166.Skin}</b></font>`, 2);
                end;
            end;
        end);
    end);
    local Reload = u15.Reload;

    local function u171() -- Line: 800
        -- upvalues: Promise (ref), InventoryController (ref)
        Promise.new(function(p168, p169) -- Line: 382
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p168(CurrentEquipped);

                return;
            end;

            p169("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p170) -- Line: 801
            if p170 then
                p170:reload();
            end;
        end);
    end;

    Reload.InputBegan:Connect(function(p172: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), Reload (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p172.UserInputType ~= Enum.UserInputType.Touch and p172.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p172.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Reload, p172);

            if u11[Reload] == p172 then
                TweenButtonToRestingScale(Reload, 0.9);
            end;
        end;
    end);
    Reload.InputEnded:Connect(function(p173: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), Reload (copy), u11 (ref), u171 (copy)
        if p173.UserInputType ~= Enum.UserInputType.Touch and p173.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Reload, 1);
        local v174 = u11[Reload];
        local v175;

        if v174 == nil then
            v175 = false;
        else
            v175 = p173 == nil and true or p173 == v174;
        end;

        if not v175 then
            local v176 = Reload;

            if u11[v176] == p173 then
                u11[v176] = nil;
            end;

            return;
        end;

        local v177 = Reload;

        if u11[v177] == p173 then
            u11[v177] = nil;
        end;

        u171();
    end);
    u15.Shoot.Active = true;
    local u178 = false;

    local function ProcessEndShoot(p179: userdata, p180: boolean?) -- Line: 813
        -- upvalues: u4 (ref), u178 (ref), MobileAutoShootController (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref)
        if p179 ~= u4 then
            return;
        end;

        if not p180 and p179.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u4 = nil;

        if not u178 then
            return;
        end;

        u178 = false;
        MobileAutoShootController.SetManualFireHeld(false);
        TweenButtonToRestingScale(u15.Shoot, 1);
        Promise.new(function(p181, p182) -- Line: 382
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p181(CurrentEquipped);

                return;
            end;

            p182("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p183) -- Line: 834
            if not p183 then
                return;
            end;

            if p183.Properties.Class ~= "Weapon" then
                if p183.Properties.Class == "Melee" then
                    p183.IsFireHeld = false;

                    return;
                end;

                if p183.Properties.Class == "C4" then
                    p183:cancel();

                    return;
                end;

                if p183.Properties.Slot == "Grenade" then
                    p183:Throw("Far");
                end;

                return;
            end;

            if p183.Properties.ShootingOptions ~= "Revolver" then
                p183.IsFireHeld = false;

                return;
            end;

            local v184 = p183.Properties.FireModes and p183.Properties.FireModes.Primary;

            if not v184 or v184.CancelOnRelease ~= false then
                p183:cancelRevolverCharge(false);

                return;
            end;

            p183.IsFireHeld = false;
            p183.FireInputBinding = nil;
        end);
    end;

    u15.Shoot.InputBegan:Connect(function(p185: userdata) -- Line: 868
        -- upvalues: u4 (ref), LocalPlayer (ref), SpectateController (ref), GameState (ref), Router (ref), u178 (ref), MobileAutoShootController (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref)
        if p185.UserInputType ~= Enum.UserInputType.Touch and p185.UserInputType ~= Enum.UserInputType.MouseButton1 or u4 or p185.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u4 = p185;

        if LocalPlayer:GetAttribute("IsPlayerChatting") or (SpectateController.IsLocalPlayerDead() or (not LocalPlayer.Character or GameState.GetState() == "Buy Period")) then
            return;
        end;

        Router.broadcastRouter("Cancel Defuse Bomb");
        u178 = true;
        MobileAutoShootController.SetManualFireHeld(true);
        TweenButtonToRestingScale(u15.Shoot, 0.9);
        Promise.new(function(p186, p187) -- Line: 382
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p186(CurrentEquipped);

                return;
            end;

            p187("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p188) -- Line: 893
            if not p188 then
                return;
            end;

            if p188.Properties.Class ~= "Weapon" then
                if p188.Properties.Class == "Melee" then
                    p188.IsFireHeld = true;
                    p188:shoot();

                    return;
                end;

                if p188.Properties.Class == "C4" then
                    p188:shoot();

                    return;
                end;

                if p188.Properties.Slot == "Grenade" then
                    p188:StartThrow();
                end;

                return;
            end;

            if p188.Properties.ShootingOptions == "Revolver" then
                p188:startRevolverCharge(nil);

                return;
            end;

            if p188.AlternativeShootingOption ~= "Burst" then
                p188.IsFireHeld = true;
                p188:shoot();

                return;
            end;

            if p188.IsBurstShooting then
                return;
            end;

            p188.IsFireHeld = true;
            p188:fireBurst();
        end);
    end);
    u15.Shoot.InputEnded:Connect(ProcessEndShoot);
    u15.Shoot.InputChanged:Connect(function(p189: userdata) -- Line: 937
        -- upvalues: u4 (ref), CameraInput (ref)
        if p189 == u4 and p189.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p189.Delta.X, p189.Delta.Y));
        end;
    end);
    u15.AlternativeAction.Active = true;

    local function ProcessEndAlternativeAction(p190: userdata, p191: boolean?) -- Line: 946
        -- upvalues: u5 (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref), GameState (ref)
        if p190 ~= u5 then
            return;
        end;

        if not p191 and p190.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u5 = nil;
        TweenButtonToRestingScale(u15.AlternativeAction, 1);
        Promise.new(function(p192, p193) -- Line: 382
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p192(CurrentEquipped);

                return;
            end;

            p193("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p194) -- Line: 962
            -- upvalues: GameState (ref)
            if not p194 then
                return;
            end;

            local Properties = p194.Properties;

            if Properties.ShootingOptions == "Revolver" then
                p194:stopRevolverSecondaryFire();

                return;
            end;

            if Properties.Slot ~= "Grenade" or GameState.GetState() == "Buy Period" then
                return;
            end;

            if p194.ThrowStarted and not p194.ThrowFinished then
                p194:Throw("Near");
            end;
        end);
    end;

    u15.AlternativeAction.InputBegan:Connect(function(p195: userdata) -- Line: 983
        -- upvalues: u5 (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref), LocalPlayer (ref), SpectateController (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), GameState (ref)
        if p195.UserInputType ~= Enum.UserInputType.Touch and p195.UserInputType ~= Enum.UserInputType.MouseButton1 or u5 or p195.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u5 = p195;
        TweenButtonToRestingScale(u15.AlternativeAction, 0.9);
        Promise.new(function(p196, p197) -- Line: 382
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p196(CurrentEquipped);

                return;
            end;

            p197("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p198) -- Line: 993
            -- upvalues: LocalPlayer (ref), SpectateController (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), GameState (ref)
            if not p198 then
                return;
            end;

            if LocalPlayer:GetAttribute("IsPlayerChatting") or (SpectateController.IsLocalPlayerDead() or (CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive()))) then
                return;
            end;

            local Properties = p198.Properties;

            if Properties.ShootingOptions == "Revolver" then
                p198:startRevolverSecondaryFire(nil);

                return;
            end;

            if Properties.Class == "Grenade" or Properties.Slot == "Grenade" then
                if GameState.GetState() ~= "Buy Period" then
                    p198:StartThrow();
                end;

                return;
            end;

            if Properties.HasScope then
                p198:scope(true);

                return;
            end;

            if Properties.HasSuppressor then
                if p198.IsSuppressed then
                    p198:removeSuppressor();

                    return;
                end;

                p198:addSuppressor();

                return;
            end;

            if Properties.ShootingOptions == "Burst" then
                p198:updateFireMode();

                return;
            end;

            if Properties.Type ~= "Equipment" then
                return;
            end;

            if GameState.GetState() ~= "Buy Period" then
                p198:shoot(true);
            end;
        end);
    end);
    u15.AlternativeAction.InputEnded:Connect(ProcessEndAlternativeAction);
    u15.AlternativeAction.InputChanged:Connect(function(p199: userdata) -- Line: 1044
        -- upvalues: u5 (ref), CameraInput (ref)
        if p199 == u5 and p199.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p199.Delta.X, p199.Delta.Y));
        end;
    end);
    u15.Interact.Active = true;
    u7 = nil;
    u15.Interact.InputBegan:Connect(function(p200: userdata) -- Line: 1054
        -- upvalues: u7 (ref), TrackButtonTouchStart (ref), u15 (ref), CollectionService (ref), HoverBomb (ref), u8 (ref), Router (ref), CenterScreenRaycast (ref), LocalPlayer (ref), GetHoveredBreakableDoor (ref), CharacterController (ref), Remotes (ref), Skins (ref), Rarities (ref)
        if p200.UserInputType ~= Enum.UserInputType.Touch and p200.UserInputType ~= Enum.UserInputType.MouseButton1 or u7 or p200.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u7 = p200;
        TrackButtonTouchStart(u15.Interact, p200);
        local v201 = CollectionService:GetTagged("Bomb")[1];

        if v201 and (v201:GetAttribute("CanDefuse") and (not v201:GetAttribute("Defused") and HoverBomb.IsDefuseAllowed())) then
            u8 = true;
            Router.broadcastRouter("Start Defuse Bomb");

            return;
        end;

        local HoveredHostage = CenterScreenRaycast.GetHoveredHostage();

        if HoveredHostage then
            local Attribute = LocalPlayer:GetAttribute("Team");

            if not (LocalPlayer:GetAttribute("IsCarryingHostage") or (LocalPlayer:GetAttribute("IsRescuingHostage") or Attribute ~= "Counter-Terrorists")) then
                local Attribute2 = HoveredHostage:GetAttribute("RescuingPlayer");
                local Attribute3 = HoveredHostage:GetAttribute("CarryingPlayer");

                if not (Attribute2 and Attribute2 ~= LocalPlayer.Name or Attribute3) then
                    Router.broadcastRouter("Start Rescue Hostage");

                    return;
                end;
            end;
        end;

        local v202 = GetHoveredBreakableDoor();

        if #v202 > 0 then
            for _, v in v202 do
                local v203 = CharacterController.PredictDoorUse(v);
                local Send = Remotes.BreakableDoor.Use.Send;
                local v204 = {
                    Model = v
                };
                local v205;

                if v203 == nil then
                    v205 = nil;
                else
                    v205 = v203.ServerTick;
                end;

                v204.ServerTick = v205;
                local v206;

                if v203 == nil then
                    v206 = nil;
                else
                    v206 = v203.TargetAngle;
                end;

                v204.TargetAngle = v206;
                local v207;

                if v203 == nil then
                    v207 = nil;
                else
                    v207 = v203.RequestId;
                end;

                v204.RequestId = v207;
                Send(v204);
            end;

            return;
        end;

        local Tagged = CollectionService:GetTagged("IsHoveringInteractable");

        if #Tagged == 0 then
            return;
        end;

        local v208 = Tagged[1];
        local Attribute = v208:GetAttribute("Weapon");
        local Attribute2 = v208:GetAttribute("Skin");

        if Attribute == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
            return;
        end;

        if v208:GetAttribute("CanPickup") then
            local SkinInformation = Skins.GetSkinInformation(Attribute, Attribute2);

            if SkinInformation then
                local v209 = Rarities[SkinInformation.rarity];
                local math_floor_ret = math.floor(v209.Color.R * 255);
                local math_floor_ret2 = math.floor(v209.Color.G * 255);
                local math_floor_ret3 = math.floor(v209.Color.B * 255);
                Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{Attribute:find("Zeus") and "Taser" or Attribute} | {Attribute2}</b></font>`, 2);
            end;

            Remotes.Inventory.PickupWeapon.Send({
                AllowAutoEquip = true,
                Identity = v208.Name
            });
        end;
    end);

    local function ProcessEndInteract(p210: userdata) -- Line: 1142
        -- upvalues: u7 (ref), u8 (ref), LocalPlayer (ref), u15 (ref), u11 (ref), CollectionService (ref), Router (ref)
        if p210 ~= u7 then
            return;
        end;

        local v211 = u8 or LocalPlayer:GetAttribute("IsDefusingBomb") == true;
        u7 = nil;
        u8 = false;
        local Interact = u15.Interact;

        if u11[Interact] == p210 then
            u11[Interact] = nil;
        end;

        if CollectionService:GetTagged("Bomb")[1] and v211 then
            Router.broadcastRouter("Cancel Defuse Bomb");

            return;
        end;

        if LocalPlayer:GetAttribute("IsRescuingHostage") then
            Router.broadcastRouter("Cancel Rescue Hostage");
        end;
    end;

    u15.Interact.InputEnded:Connect(ProcessEndInteract);
    u15.Interact.InputChanged:Connect(function(p212: userdata) -- Line: 1166
        -- upvalues: u7 (ref), CameraInput (ref)
        if p212 == u7 and p212.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p212.Delta.X, p212.Delta.Y));
        end;
    end);
    local Shop = u15.Shop;
    local toggleFrame = BuyMenu.toggleFrame;
    Shop.InputBegan:Connect(function(p213: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), Shop (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p213.UserInputType ~= Enum.UserInputType.Touch and p213.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p213.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Shop, p213);

            if u11[Shop] == p213 then
                TweenButtonToRestingScale(Shop, 0.9);
            end;
        end;
    end);
    Shop.InputEnded:Connect(function(p214: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), Shop (copy), u11 (ref), toggleFrame (copy)
        if p214.UserInputType ~= Enum.UserInputType.Touch and p214.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Shop, 1);
        local v215 = u11[Shop];
        local v216;

        if v215 == nil then
            v216 = false;
        else
            v216 = p214 == nil and true or p214 == v215;
        end;

        if not v216 then
            local v217 = Shop;

            if u11[v217] == p214 then
                u11[v217] = nil;
            end;

            return;
        end;

        local v218 = Shop;

        if u11[v218] == p214 then
            u11[v218] = nil;
        end;

        toggleFrame();
    end);

    local function ProcessEndScoreboard(p219: userdata, p220: boolean?) -- Line: 1176
        -- upvalues: u6 (ref), TweenButtonToRestingScale (ref), u15 (ref), u11 (ref)
        if p219 ~= u6 then
            return;
        end;

        if not p220 and p219.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u6 = nil;
        TweenButtonToRestingScale(u15.ToggleScoreboard, 1);
        local ToggleScoreboard = u15.ToggleScoreboard;

        if u11[ToggleScoreboard] == p219 then
            u11[ToggleScoreboard] = nil;
        end;
    end;

    u15.ToggleScoreboard.InputBegan:Connect(function(p221: userdata) -- Line: 1189
        -- upvalues: u6 (ref), LocalPlayer (ref), TrackButtonTouchStart (ref), u15 (ref), TweenButtonToRestingScale (ref)
        if p221.UserInputType ~= Enum.UserInputType.Touch and p221.UserInputType ~= Enum.UserInputType.MouseButton1 or (u6 or LocalPlayer:GetAttribute("IsPlayerChatting")) or p221.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u6 = p221;
        TrackButtonTouchStart(u15.ToggleScoreboard, p221);
        TweenButtonToRestingScale(u15.ToggleScoreboard, 0.9);
    end);
    u15.ToggleScoreboard.InputEnded:Connect(function(p222: userdata) -- Line: 1204
        -- upvalues: u6 (ref), u15 (ref), u11 (ref), TweenButtonToRestingScale (ref), Leaderboard (ref)
        if p222 ~= u6 then
            return;
        end;

        local v223 = u11[u15.ToggleScoreboard];
        local v224;

        if v223 == nil then
            v224 = false;
        else
            v224 = p222 == nil and true or p222 == v223;
        end;

        if p222 == u6 then
            u6 = nil;
            TweenButtonToRestingScale(u15.ToggleScoreboard, 1);
            local ToggleScoreboard = u15.ToggleScoreboard;

            if u11[ToggleScoreboard] == p222 then
                u11[ToggleScoreboard] = nil;
            end;
        end;

        if not v224 then
            return;
        end;

        if Leaderboard.IsOpen() then
            Leaderboard.closeFrame();

            return;
        end;

        Leaderboard.openFrame();
    end);
    local Menu = u15.Menu;

    local function u225() -- Line: 1222
        -- upvalues: IsTutorialMode (ref), Chat (ref), Top (ref)
        if IsTutorialMode() then
            return;
        end;

        Chat.CloseChat();
        Top.ToggleMenu();
    end;

    Menu.InputBegan:Connect(function(p226: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), Menu (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p226.UserInputType ~= Enum.UserInputType.Touch and p226.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p226.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Menu, p226);

            if u11[Menu] == p226 then
                TweenButtonToRestingScale(Menu, 0.9);
            end;
        end;
    end);
    Menu.InputEnded:Connect(function(p227: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), Menu (copy), u11 (ref), u225 (copy)
        if p227.UserInputType ~= Enum.UserInputType.Touch and p227.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Menu, 1);
        local v228 = u11[Menu];
        local v229;

        if v228 == nil then
            v229 = false;
        else
            v229 = p227 == nil and true or p227 == v228;
        end;

        if not v229 then
            local v230 = Menu;

            if u11[v230] == p227 then
                u11[v230] = nil;
            end;

            return;
        end;

        local v231 = Menu;

        if u11[v231] == p227 then
            u11[v231] = nil;
        end;

        u225();
    end);
    local Chat2 = u15.Chat;

    local function u232() -- Line: 1231
        -- upvalues: u10 (ref), Chat (ref), ChatModes (ref)
        if not u10 then
            return;
        end;

        Chat.ToggleChat(ChatModes.Modes.All);
    end;

    Chat2.InputBegan:Connect(function(p233: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), Chat2 (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p233.UserInputType ~= Enum.UserInputType.Touch and p233.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p233.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Chat2, p233);

            if u11[Chat2] == p233 then
                TweenButtonToRestingScale(Chat2, 0.9);
            end;
        end;
    end);
    Chat2.InputEnded:Connect(function(p234: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), Chat2 (copy), u11 (ref), u232 (copy)
        if p234.UserInputType ~= Enum.UserInputType.Touch and p234.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Chat2, 1);
        local v235 = u11[Chat2];
        local v236;

        if v235 == nil then
            v236 = false;
        else
            v236 = p234 == nil and true or p234 == v235;
        end;

        if not v236 then
            local v237 = Chat2;

            if u11[v237] == p234 then
                u11[v237] = nil;
            end;

            return;
        end;

        local v238 = Chat2;

        if u11[v238] == p234 then
            u11[v238] = nil;
        end;

        u232();
    end);
    local Inspect = u15.Inspect;

    local function u239() -- Line: 1240
        -- upvalues: LocalPlayer (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), InventoryController (ref), HintController (ref)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or (CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive())) then
            return;
        end;

        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if CurrentEquipped then
            CurrentEquipped:inspect();
            HintController:clearHint("Inspect");
        end;
    end;

    Inspect.InputBegan:Connect(function(p240: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), Inspect (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p240.UserInputType ~= Enum.UserInputType.Touch and p240.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p240.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Inspect, p240);

            if u11[Inspect] == p240 then
                TweenButtonToRestingScale(Inspect, 0.9);
            end;
        end;
    end);
    Inspect.InputEnded:Connect(function(p241: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), Inspect (copy), u11 (ref), u239 (copy)
        if p241.UserInputType ~= Enum.UserInputType.Touch and p241.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Inspect, 1);
        local v242 = u11[Inspect];
        local v243;

        if v242 == nil then
            v243 = false;
        else
            v243 = p241 == nil and true or p241 == v242;
        end;

        if not v243 then
            local v244 = Inspect;

            if u11[v244] == p241 then
                u11[v244] = nil;
            end;

            return;
        end;

        local v245 = Inspect;

        if u11[v245] == p241 then
            u11[v245] = nil;
        end;

        u239();
    end);
    local SwapTeam = u15.SwapTeam;

    local function u246() -- Line: 1256
        -- upvalues: LocalPlayer (ref), TeamSelection (ref)
        if LocalPlayer:GetAttribute("IsSpectating") then
            TeamSelection.openFrame();

            return;
        end;

        if LocalPlayer.Character then
            TeamSelection.ToggleTeamSelection();
        end;
    end;

    SwapTeam.InputBegan:Connect(function(p247: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), SwapTeam (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p247.UserInputType ~= Enum.UserInputType.Touch and p247.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p247.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(SwapTeam, p247);

            if u11[SwapTeam] == p247 then
                TweenButtonToRestingScale(SwapTeam, 0.9);
            end;
        end;
    end);
    SwapTeam.InputEnded:Connect(function(p248: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), SwapTeam (copy), u11 (ref), u246 (copy)
        if p248.UserInputType ~= Enum.UserInputType.Touch and p248.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(SwapTeam, 1);
        local v249 = u11[SwapTeam];
        local v250;

        if v249 == nil then
            v250 = false;
        else
            v250 = p248 == nil and true or p248 == v249;
        end;

        if not v250 then
            local v251 = SwapTeam;

            if u11[v251] == p248 then
                u11[v251] = nil;
            end;

            return;
        end;

        local v252 = SwapTeam;

        if u11[v252] == p248 then
            u11[v252] = nil;
        end;

        u246();
    end);
    local Ping = u15.Ping;

    local function u257() -- Line: 1265
        -- upvalues: DataController (ref), LocalPlayer (ref), CharacterResolver (ref), GetPingRaycastResult (ref), GetWeaponDataFromInstance (ref), Remotes (ref), u9 (ref)
        if workspace:GetAttribute("Gamemode") == "Deathmatch" or (DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" or not CharacterResolver.isAliveCharacter(LocalPlayer.Character)) then
            return;
        end;

        local v253 = GetPingRaycastResult(LocalPlayer.Character);

        if not v253 then
            return;
        end;

        local v254, v255, v256 = GetWeaponDataFromInstance(v253.Instance);

        if v254 and (v255 and v256) then
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = false,
                Position = v253.Position,
                WeaponIdentity = v256,
                WeaponName = v254,
                WeaponSkin = v255
            });
        else
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = tick() - u9 < 0.5,
                Position = v253.Position
            });
        end;

        u9 = tick();
    end;

    Ping.InputBegan:Connect(function(p258: userdata) -- Line: 553
        -- upvalues: TrackButtonTouchStart (ref), Ping (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p258.UserInputType ~= Enum.UserInputType.Touch and p258.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p258.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Ping, p258);

            if u11[Ping] == p258 then
                TweenButtonToRestingScale(Ping, 0.9);
            end;
        end;
    end);
    Ping.InputEnded:Connect(function(p259: userdata) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (ref), Ping (copy), u11 (ref), u257 (copy)
        if p259.UserInputType ~= Enum.UserInputType.Touch and p259.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Ping, 1);
        local v260 = u11[Ping];
        local v261;

        if v260 == nil then
            v261 = false;
        else
            v261 = p259 == nil and true or p259 == v260;
        end;

        if not v261 then
            local v262 = Ping;

            if u11[v262] == p259 then
                u11[v262] = nil;
            end;

            return;
        end;

        local v263 = Ping;

        if u11[v263] == p259 then
            u11[v263] = nil;
        end;

        u257();
    end);

    for _, child in ipairs(u15:GetChildren()) do
        if child:IsA("TextButton") and (child.Name ~= "Shoot" and child.Name ~= "AlternativeAction") then
            u1.setupButton(child);
        end;
    end;

    RunServiceController.BindToHeartbeat("UI.MobileButtons.UpdateVisibility", function() -- Line: 1304
        -- upvalues: Profiler (ref), u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), u62 (ref), UpdateButtonVisibilityForSpectate (ref), IsInBuyArea (ref), TutorialPurchaseLock (ref), u13 (ref), IsTutorialMode (ref), UpdateInteractButton (ref), UpdateInspectButton (ref), SpectateController (ref), InventoryController (ref), CanDropCurrentEquipped (ref), UpdatePingButton (ref), HasAlternativeAction (ref), UpdateToggledIndicators (ref)
        Profiler.mark("UI.MobileButtons.Heartbeat");

        if u15 then
            local v264 = GetDesiredFrameVisibility(nil);
            local Visible = u15.Visible;
            u15.Visible = v264;
            local v265 = LocalPlayer:GetAttribute("IsSpectating") == true;

            if v264 and (not Visible or u62 ~= v265) then
                UpdateButtonVisibilityForSpectate(v265);
            end;

            u62 = v265;
        end;

        if not u15.Visible then
            return;
        end;

        local v266 = LocalPlayer:GetAttribute("IsSpectating") ~= true;

        if v266 then
            if LocalPlayer:GetAttribute("BuyMenu") == true then
                v266 = IsInBuyArea(LocalPlayer) and not TutorialPurchaseLock.isBuyMenuLocked(LocalPlayer);
            else
                v266 = false;
            end;
        end;

        local Shop2 = u15:FindFirstChild("Shop");

        if Shop2 then
            if v266 then
                v266 = not u13.Shop;
            end;

            Shop2.Visible = v266;
        end;

        local v267 = IsTutorialMode() and u15:FindFirstChild("Menu");

        if v267 then
            v267.Visible = false;
        end;

        UpdateInteractButton();
        UpdateInspectButton();

        if SpectateController.IsLocalPlayerDead() then
            local Reload2 = u15:FindFirstChild("Reload");

            if Reload2 then
                Reload2.Visible = false;
            end;
        else
            local CurrentEquipped = InventoryController.getCurrentEquipped();
            local v268;

            if CurrentEquipped == nil then
                v268 = false;
            else
                v268 = CurrentEquipped.Properties.Class == "Weapon";
            end;

            local Reload2 = u15:FindFirstChild("Reload");

            if Reload2 then
                if v268 then
                    v268 = not u13.Reload;
                end;

                Reload2.Visible = v268;
            end;
        end;

        local v269 = CanDropCurrentEquipped(InventoryController.getCurrentEquipped());
        local Drop = u15:FindFirstChild("Drop");

        if Drop then
            if v269 then
                v269 = not u13.Drop;
            end;

            Drop.Visible = v269;
        end;

        UpdatePingButton();

        if SpectateController.IsLocalPlayerDead() then
            local AlternativeAction = u15:FindFirstChild("AlternativeAction");

            if AlternativeAction then
                AlternativeAction.Visible = false;
            end;
        else
            local v270 = HasAlternativeAction(InventoryController.getCurrentEquipped());
            local AlternativeAction = u15:FindFirstChild("AlternativeAction");

            if AlternativeAction then
                if v270 then
                    v270 = not u13.AlternativeAction;
                end;

                AlternativeAction.Visible = v270;
            end;
        end;

        UpdateToggledIndicators();
    end);
    UserInputService.InputChanged:Connect(function(p271: userdata) -- Line: 1328
        -- upvalues: u4 (ref), u5 (ref), u7 (ref), CameraInput (ref)
        if p271 == u4 or (p271 == u5 or p271 == u7) then
            CameraInput.addTouchMove(Vector2.new(p271.Delta.X, p271.Delta.Y));
        end;
    end);
    UserInputService.InputEnded:Connect(function(p272: userdata) -- Line: 1335
        -- upvalues: u4 (ref), u178 (ref), MobileAutoShootController (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref), u5 (ref), GameState (ref), u6 (ref), u11 (ref), ProcessEndInteract (copy)
        if p272.UserInputType == Enum.UserInputType.Touch and true or p272.UserInputType == Enum.UserInputType.MouseButton1 then
            if p272 == u4 then
                u4 = nil;

                if u178 then
                    u178 = false;
                    MobileAutoShootController.SetManualFireHeld(false);
                    TweenButtonToRestingScale(u15.Shoot, 1);
                    Promise.new(function(p273, p274) -- Line: 382
                        -- upvalues: InventoryController (ref)
                        local CurrentEquipped = InventoryController.getCurrentEquipped();

                        if CurrentEquipped then
                            p273(CurrentEquipped);

                            return;
                        end;

                        p274("Failed to fetch current equipped");
                    end):catch(warn):andThen(function(p275) -- Line: 834
                        if not p275 then
                            return;
                        end;

                        if p275.Properties.Class ~= "Weapon" then
                            if p275.Properties.Class == "Melee" then
                                p275.IsFireHeld = false;

                                return;
                            end;

                            if p275.Properties.Class == "C4" then
                                p275:cancel();

                                return;
                            end;

                            if p275.Properties.Slot == "Grenade" then
                                p275:Throw("Far");
                            end;

                            return;
                        end;

                        if p275.Properties.ShootingOptions ~= "Revolver" then
                            p275.IsFireHeld = false;

                            return;
                        end;

                        local v276 = p275.Properties.FireModes and p275.Properties.FireModes.Primary;

                        if not v276 or v276.CancelOnRelease ~= false then
                            p275:cancelRevolverCharge(false);

                            return;
                        end;

                        p275.IsFireHeld = false;
                        p275.FireInputBinding = nil;
                    end);
                end;
            end;

            if p272 == u5 then
                u5 = nil;
                TweenButtonToRestingScale(u15.AlternativeAction, 1);
                Promise.new(function(p277, p278) -- Line: 382
                    -- upvalues: InventoryController (ref)
                    local CurrentEquipped = InventoryController.getCurrentEquipped();

                    if CurrentEquipped then
                        p277(CurrentEquipped);

                        return;
                    end;

                    p278("Failed to fetch current equipped");
                end):catch(warn):andThen(function(p279) -- Line: 962
                    -- upvalues: GameState (ref)
                    if not p279 then
                        return;
                    end;

                    local Properties = p279.Properties;

                    if Properties.ShootingOptions == "Revolver" then
                        p279:stopRevolverSecondaryFire();

                        return;
                    end;

                    if Properties.Slot ~= "Grenade" or GameState.GetState() == "Buy Period" then
                        return;
                    end;

                    if p279.ThrowStarted and not p279.ThrowFinished then
                        p279:Throw("Near");
                    end;
                end);
            end;

            if p272 == u6 then
                u6 = nil;
                TweenButtonToRestingScale(u15.ToggleScoreboard, 1);
                local ToggleScoreboard = u15.ToggleScoreboard;

                if u11[ToggleScoreboard] == p272 then
                    u11[ToggleScoreboard] = nil;
                end;
            end;

            ProcessEndInteract(p272);

            for i, v in pairs(u11) do
                if v == p272 then
                    u11[i] = nil;
                end;
            end;
        end;
    end);
end;

function u1.Start() -- Line: 1354
    -- upvalues: Profiler (copy), u15 (ref), u3 (copy), u10 (ref), CanPlayerUseChatService (copy), LocalPlayer (copy), GetDesiredFrameVisibility (copy), UpdateButtonVisibilityForSpectate (copy), u62 (ref), script_Loadout (copy), u5 (ref), u6 (ref), Leaderboard (copy), RefreshButtonVisibility (copy), u14 (copy), u16 (ref), DataController (copy), Mobile (copy), u13 (copy), ApplyMobileButtonLayout (copy), u12 (copy)
    debug.setmemorycategory("UI.MobileButtons.Start");
    Profiler.mark("UI.MobileButtons.Start");
    u15.Visible = false;

    if u3 then
        task.spawn(function() -- Line: 1362
            -- upvalues: u10 (ref), CanPlayerUseChatService (ref), LocalPlayer (ref), u15 (ref), GetDesiredFrameVisibility (ref), UpdateButtonVisibilityForSpectate (ref), u62 (ref)
            u10 = CanPlayerUseChatService(LocalPlayer);

            if not u15 then
                return;
            end;

            local v280 = GetDesiredFrameVisibility(nil);
            local _ = u15.Visible;
            u15.Visible = v280;
            local v281 = LocalPlayer:GetAttribute("IsSpectating") == true;

            if v280 then
                UpdateButtonVisibilityForSpectate(v281);
            end;

            u62 = v281;
        end);
        script_Loadout.Start();

        if u15 then
            local v282 = GetDesiredFrameVisibility(nil);
            local _ = u15.Visible;
            u15.Visible = v282;
            local v283 = LocalPlayer:GetAttribute("IsSpectating") == true;

            if v282 then
                UpdateButtonVisibilityForSpectate(v283);
            end;

            u62 = v283;
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(function() -- Line: 1375
        -- upvalues: u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u62 (ref)
        if not u15 then
            return;
        end;

        local v284 = GetDesiredFrameVisibility(nil);
        local _ = u15.Visible;
        u15.Visible = v284;
        local v285 = LocalPlayer:GetAttribute("IsSpectating") == true;

        if v284 then
            UpdateButtonVisibilityForSpectate(v285);
        end;

        u62 = v285;
    end);
    LocalPlayer.CharacterRemoving:Connect(function(p286: userdata) -- Line: 1380
        -- upvalues: u5 (ref), u6 (ref), Leaderboard (ref), u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u62 (ref)
        u5 = nil;
        u6 = nil;
        Leaderboard.closeFrame();

        if not u15 then
            return;
        end;

        local v287 = GetDesiredFrameVisibility(p286);
        local _ = u15.Visible;
        u15.Visible = v287;
        local v288 = LocalPlayer:GetAttribute("IsSpectating") == true;

        if v287 then
            UpdateButtonVisibilityForSpectate(v288);
        end;

        u62 = v288;
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(RefreshButtonVisibility);
    local u289 = { "TeamSelection", table.unpack(u14) };
    local v290 = u16;

    if v290 then
        local function watchSiblingFrame(p291: userdata) -- Line: 1395
            -- upvalues: u289 (copy), RefreshButtonVisibility (ref), u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u62 (ref)
            if p291:IsA("GuiObject") and table.find(u289, p291.Name) then
                p291:GetPropertyChangedSignal("Visible"):Connect(RefreshButtonVisibility);

                if not u15 then
                    return;
                end;

                local v292 = GetDesiredFrameVisibility(nil);
                local _ = u15.Visible;
                u15.Visible = v292;
                local v293 = LocalPlayer:GetAttribute("IsSpectating") == true;

                if v292 then
                    UpdateButtonVisibilityForSpectate(v293);
                end;

                u62 = v293;
            end;
        end;

        for _, child in v290:GetChildren() do
            if child:IsA("GuiObject") and table.find(u289, child.Name) then
                child:GetPropertyChangedSignal("Visible"):Connect(RefreshButtonVisibility);

                if u15 then
                    local v294 = GetDesiredFrameVisibility(nil);
                    local _ = u15.Visible;
                    u15.Visible = v294;
                    local v295 = LocalPlayer:GetAttribute("IsSpectating") == true;

                    if v294 then
                        UpdateButtonVisibilityForSpectate(v295);
                    end;

                    u62 = v295;
                end;
            end;
        end;

        v290.ChildAdded:Connect(watchSiblingFrame);
    end;

    DataController.CreateListener(LocalPlayer, "MobileButtons", function(p296) -- Line: 1409
        -- upvalues: Mobile (ref), u13 (ref), u15 (ref), ApplyMobileButtonLayout (ref), u12 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u62 (ref)
        if typeof(p296) ~= "table" then
            return;
        end;

        local v297 = Mobile.SanitizeLayout(p296);
        table.clear(u13);

        for i, v in pairs(v297) do
            local v298 = u15:FindFirstChild(i);

            if v298 and v298:IsA("GuiObject") then
                ApplyMobileButtonLayout(v298, v);
                u12[v298] = v298.Size;

                if not v.Enabled then
                    u13[i] = true;
                end;
            end;
        end;

        if not u15 then
            return;
        end;

        local v299 = GetDesiredFrameVisibility(nil);
        local _ = u15.Visible;
        u15.Visible = v299;
        local v300 = LocalPlayer:GetAttribute("IsSpectating") == true;

        if v299 then
            UpdateButtonVisibilityForSpectate(v300);
        end;

        u62 = v300;
    end);
end;

return u1;