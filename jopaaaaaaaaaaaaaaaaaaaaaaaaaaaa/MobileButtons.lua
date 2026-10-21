-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons
-- Decompile time: 37.57 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
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
local SurvivalDownedController = require(ReplicatedStorage.Controllers.SurvivalDownedController);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CanPlayerUseChatService = require(ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
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
local table_freeze_ret = table.freeze({ "Shoot", "AlternativeAction", "Reload", "Inspect", "Drop", "Primary", "Secondary", "Melee", "Grenade1", "Grenade2", "Grenade3", "Grenade4", "Bomb" });
local table_freeze_ret2 = table.freeze({
    Shoot = true,
    AlternativeAction = true,
    Reload = true,
    Inspect = true
});
local u14 = { "EndScreen", "Halftime" };
local u15 = nil;
local u16 = nil;
local u17 = nil;

local function GetWeaponDataFromInstance(p18: userdata?) -- Line: 146
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

local function GetPingRaycastResult(...) -- Line: 163
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

local function ValidateButtonTouch(p21: userdata, p22: userdata?) -- Line: 190
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

local function IsNewTouch(p25: userdata) -- Line: 195
    return p25.UserInputState == Enum.UserInputState.Begin;
end;

local function IsPressInput(p26: userdata) -- Line: 199
    return p26.UserInputType == Enum.UserInputType.Touch and true or p26.UserInputType == Enum.UserInputType.MouseButton1;
end;

local u27 = nil;

local function TrackButtonTouchStart(u28: userdata, p29: userdata) -- Line: 206
    -- upvalues: u11 (copy), BUTTONS_WITH_CAMERA_DRAG (copy), script_TouchIntent (copy), u27 (ref)
    if not u11[u28] and p29.UserInputState == Enum.UserInputState.Begin then
        u11[u28] = p29;

        if not BUTTONS_WITH_CAMERA_DRAG[u28.Name] then
            script_TouchIntent.track(p29, u28, function(p30: userdata) -- Line: 212
                -- upvalues: u27 (ref), u28 (copy)
                if u27 then
                    u27(u28, p30);
                end;
            end);
        end;
    end;
end;

local function TrackButtonTouchEnd(p31: userdata, p32: userdata) -- Line: 221
    -- upvalues: u11 (copy)
    if u11[p31] == p32 then
        u11[p31] = nil;
    end;
end;

local function IsInputInsideButton(p33: userdata, p34: userdata) -- Line: 228
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

local function SetButtonVisibility(p36: string, p37: boolean) -- Line: 238
    -- upvalues: u15 (ref), u13 (copy)
    local v38 = u15:FindFirstChild(p36);

    if v38 then
        if p37 then
            p37 = not u13[p36];
        end;

        v38.Visible = p37;
    end;
end;

local function CanUseVIPMenu() -- Line: 247
    -- upvalues: RunService (copy), LocalPlayer (copy)
    if RunService:IsStudio() then
        return true;
    end;

    local v39;

    if workspace:GetAttribute("IsVIPServer") == true then
        v39 = LocalPlayer:GetAttribute("CanUseVIPMenu") == true;
    else
        v39 = false;
    end;

    return v39;
end;

local function SetToggledIndicator(p40: userdata?, p41: boolean) -- Line: 254
    if p40 then
        p40 = p40:FindFirstChild("Toggled");
    end;

    if p40 and (p40:IsA("GuiObject") and p40.Visible ~= p41) then
        p40.Visible = p41;
    end;
end;

local function IsAlternativeActionActive() -- Line: 261
    -- upvalues: u5 (ref), InventoryController (copy)
    if u5 ~= nil then
        return true;
    end;

    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v42 = CurrentEquipped and CurrentEquipped.Viewmodel and CurrentEquipped.Viewmodel.Bobble;

    if v42 then
        v42 = v42.IsAiming;
    end;

    return v42 == true;
end;

local function UpdateToggledIndicators() -- Line: 273
    -- upvalues: u15 (ref), CharacterController (copy), IsSurvivalMode (copy), Leaderboard (copy), u5 (ref), InventoryController (copy)
    local Crouch = u15:FindFirstChild("Crouch");
    local v43 = CharacterController.GetCrouchState() == true;

    if Crouch then
        Crouch = Crouch:FindFirstChild("Toggled");
    end;

    if Crouch and (Crouch:IsA("GuiObject") and Crouch.Visible ~= v43) then
        Crouch.Visible = v43;
    end;

    local ToggleWalk = u15:FindFirstChild("ToggleWalk");
    local v44;

    if IsSurvivalMode() then
        v44 = CharacterController.GetSprintState();
    else
        v44 = CharacterController.GetWalkState();
    end;

    local v45 = v44 == true;

    if ToggleWalk then
        ToggleWalk = ToggleWalk:FindFirstChild("Toggled");
    end;

    if ToggleWalk and (ToggleWalk:IsA("GuiObject") and ToggleWalk.Visible ~= v45) then
        ToggleWalk.Visible = v45;
    end;

    local ToggleScoreboard = u15:FindFirstChild("ToggleScoreboard");
    local v46 = Leaderboard.IsOpen() == true;

    if ToggleScoreboard then
        ToggleScoreboard = ToggleScoreboard:FindFirstChild("Toggled");
    end;

    if ToggleScoreboard and (ToggleScoreboard:IsA("GuiObject") and ToggleScoreboard.Visible ~= v46) then
        ToggleScoreboard.Visible = v46;
    end;

    local AlternativeAction = u15:FindFirstChild("AlternativeAction");
    local v47;

    if u5 == nil then
        local CurrentEquipped = InventoryController.getCurrentEquipped();
        local v48 = CurrentEquipped and CurrentEquipped.Viewmodel and CurrentEquipped.Viewmodel.Bobble;

        if v48 then
            v48 = v48.IsAiming;
        end;

        v47 = v48 == true;
    else
        v47 = true;
    end;

    if AlternativeAction then
        AlternativeAction = AlternativeAction:FindFirstChild("Toggled");
    end;

    if AlternativeAction and (AlternativeAction:IsA("GuiObject") and AlternativeAction.Visible ~= v47) then
        AlternativeAction.Visible = v47;
    end;
end;

local function UpdateButtonVisibilityForSpectate(p49: boolean) -- Line: 283
    -- upvalues: u15 (ref), GAMEPLAY_MOBILE_BUTTONS (copy), SPECTATE_MOBILE_BUTTONS (copy), u13 (copy), script_Loadout (copy), u10 (ref)
    if not u15 then
        return;
    end;

    for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
        local v50 = not p49 or table.find(SPECTATE_MOBILE_BUTTONS, v) ~= nil;
        local v51 = u15:FindFirstChild(v);

        if v51 then
            if v50 then
                v50 = not u13[v];
            end;

            v51.Visible = v50;
        end;
    end;

    for _, v in ipairs(script_Loadout.GetSlotButtonNames()) do
        local v52 = not p49 and script_Loadout.IsSlotFilled(v);
        local v53 = u15:FindFirstChild(v);

        if v53 then
            if v52 then
                v52 = not u13[v];
            end;

            v53.Visible = v52;
        end;
    end;

    local v54 = not u10 and u15:FindFirstChild("Chat");

    if v54 then
        v54.Visible = false;
    end;
end;

local function IsSiblingFrameVisible(p55: string) -- Line: 300
    -- upvalues: u16 (ref), u15 (ref)
    local v56 = u16 or u15 and u15.Parent;

    if v56 then
        v56 = v56:FindFirstChild(p55);
    end;

    local v57;

    if v56 == nil then
        v57 = false;
    else
        v57 = v56:IsA("GuiObject") and v56.Visible;
    end;

    return v57;
end;

local function GetDesiredFrameVisibility(p58: userdata?) -- Line: 306
    -- upvalues: u3 (copy), u14 (copy), u16 (ref), u15 (ref), LocalPlayer (copy)
    if not u3 then
        return false;
    end;

    for _, v in ipairs(u14) do
        local v59 = u16 or u15 and u15.Parent;

        if v59 then
            v59 = v59:FindFirstChild(v);
        end;

        local v60;

        if v59 == nil then
            v60 = false;
        else
            v60 = v59:IsA("GuiObject") and v59.Visible;
        end;

        if v60 then
            return false;
        end;
    end;

    local Character = LocalPlayer.Character;

    if Character == p58 then
        Character = nil;
    end;

    local v61;

    if Character == nil then
        v61 = false;
    else
        v61 = Character:IsDescendantOf(workspace);
    end;

    local v62 = u16 or u15 and u15.Parent;

    if v62 then
        v62 = v62:FindFirstChild("TeamSelection");
    end;

    local v63;

    if v62 == nil then
        v63 = false;
    else
        v63 = v62:IsA("GuiObject") and v62.Visible;
    end;

    if v63 and not v61 then
        return false;
    end;

    return v61 or LocalPlayer:GetAttribute("IsSpectating") == true;
end;

local u64 = nil;

local function RefreshButtonVisibility(p65: userdata?, p66: boolean?) -- Line: 331
    -- upvalues: u15 (ref), GetDesiredFrameVisibility (copy), LocalPlayer (copy), u64 (ref), UpdateButtonVisibilityForSpectate (copy)
    if not u15 then
        return;
    end;

    local v67 = GetDesiredFrameVisibility(p65);
    local Visible = u15.Visible;
    u15.Visible = v67;
    local v68 = LocalPlayer:GetAttribute("IsSpectating") == true;

    if v67 and (p66 ~= false or (not Visible or u64 ~= v68)) then
        UpdateButtonVisibilityForSpectate(v68);
    end;

    u64 = v68;
end;

local function GetHoveredHostage() -- Line: 346
    -- upvalues: CenterScreenRaycast (copy)
    return CenterScreenRaycast.GetHoveredHostage();
end;

local function GetHoveredBreakableDoor() -- Line: 350
    -- upvalues: CenterScreenRaycast (copy), CollectionService (copy)
    local v69 = {};
    local v70 = CenterScreenRaycast.FindTaggedModelInSight("BreakableDoor", 8);

    if v70 and (v70:IsA("Model") and v70:GetAttribute("Destroyed") ~= true) then
        table.insert(v69, v70);

        for _, v in CollectionService:GetTagged("BreakableDoor") do
            if v ~= v70 and v:GetAttribute("Destroyed") ~= true then
                local BreakableDoorHingePivot = v70:FindFirstChild("BreakableDoorHingePivot");
                local BreakableDoorHingePivot2 = v:FindFirstChild("BreakableDoorHingePivot");

                if BreakableDoorHingePivot and (BreakableDoorHingePivot2 and (BreakableDoorHingePivot.Position - BreakableDoorHingePivot2.Position).Magnitude <= 20) then
                    table.insert(v69, v);
                end;
            end;
        end;
    end;

    return v69;
end;

local function MultiplyUdim2(p71, p72: number) -- Line: 378
    return UDim2.fromScale(p71.X.Scale * p72, p71.Y.Scale * p72);
end;

local function GetButtonRestingSize(p73: userdata) -- Line: 382
    -- upvalues: u12 (copy)
    return u12[p73] or p73.Size;
end;

local function SetButtonRestingSize(p74: userdata, p75) -- Line: 386
    -- upvalues: u12 (copy)
    u12[p74] = p75 or p74.Size;
end;

local function TweenButtonToRestingScale(p76: userdata, p77: number) -- Line: 390
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), u12 (copy)
    local v78 = {};
    local v79 = u12[p76] or p76.Size;
    v78.Size = UDim2.fromScale(v79.X.Scale * p77, v79.Y.Scale * p77);
    TweenService:Create(p76, TweenInfo_new_ret, v78):Play();
end;

u27 = function(p80: userdata, p81: userdata) -- Line: 398
    -- upvalues: u11 (copy), TweenButtonToRestingScale (copy)
    if u11[p80] == p81 then
        u11[p80] = nil;
    end;

    TweenButtonToRestingScale(p80, 1);
end;

local function GetCurrentEquipped() -- Line: 406
    -- upvalues: Promise (copy), InventoryController (copy)
    return Promise.new(function(p82, p83) -- Line: 407
        -- upvalues: InventoryController (ref)
        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if CurrentEquipped then
            p82(CurrentEquipped);

            return;
        end;

        p83("Failed to fetch current equipped");
    end):catch(warn);
end;

local function SetInteractIcon(p84: boolean, p85: boolean) -- Line: 418
    -- upvalues: u15 (ref), u13 (copy)
    u15.Interact.Defuse.Visible = p84;
    u15.Interact.Use.Visible = p85;
    local v86 = p84 or p85;
    local Interact = u15:FindFirstChild("Interact");

    if Interact then
        if v86 then
            v86 = not u13.Interact;
        end;

        Interact.Visible = v86;
    end;
end;

local function DoButtonsOverlap(p87: userdata, p88: userdata) -- Line: 425
    local AbsolutePosition = p87.AbsolutePosition;
    local v89 = p87.AbsolutePosition + p87.AbsoluteSize;
    local AbsolutePosition2 = p88.AbsolutePosition;
    local v90 = p88.AbsolutePosition + p88.AbsoluteSize;
    local v91;

    if AbsolutePosition.X < v90.X and (AbsolutePosition2.X < v89.X and AbsolutePosition.Y < v90.Y) then
        v91 = AbsolutePosition2.Y < v89.Y;
    else
        v91 = false;
    end;

    return v91;
end;

local function UpdateInteractButton() -- Line: 431
    -- upvalues: u15 (ref), SurvivalDowned (copy), LocalPlayer (copy), SurvivalDownedController (copy), u13 (copy), CollectionService (copy), u8 (ref), HoverBomb (copy), CenterScreenRaycast (copy), GetHoveredBreakableDoor (copy)
    if not u15 then
        return;
    end;

    if SurvivalDowned.IsDowned(LocalPlayer) then
        u15.Interact.Defuse.Visible = false;
        u15.Interact.Use.Visible = false;
        local Interact = u15:FindFirstChild("Interact");

        if Interact then
            Interact.Visible = false;
        end;

        return;
    end;

    if SurvivalDownedController.WantsUse() then
        u15.Interact.Defuse.Visible = false;
        u15.Interact.Use.Visible = true;
        local Interact = u15:FindFirstChild("Interact");

        if Interact then
            Interact.Visible = not u13.Interact;
        end;

        return;
    end;

    local Shop = u15.Shop;

    if Shop.Visible then
        local Interact = u15.Interact;
        local AbsolutePosition = Shop.AbsolutePosition;
        local v92 = Shop.AbsolutePosition + Shop.AbsoluteSize;
        local AbsolutePosition2 = Interact.AbsolutePosition;
        local v93 = Interact.AbsolutePosition + Interact.AbsoluteSize;
        local v94;

        if AbsolutePosition.X < v93.X and (AbsolutePosition2.X < v92.X and AbsolutePosition.Y < v93.Y) then
            v94 = AbsolutePosition2.Y < v92.Y;
        else
            v94 = false;
        end;

        if v94 then
            u15.Interact.Defuse.Visible = false;
            u15.Interact.Use.Visible = false;
            local Interact2 = u15:FindFirstChild("Interact");

            if Interact2 then
                Interact2.Visible = false;
            end;

            return;
        end;
    end;

    local v95 = CollectionService:GetTagged("Bomb")[1];
    local v96;

    if v95 then
        v96 = v95:GetAttribute("Defused") or (v95:GetAttribute("Exploding") or v95:GetAttribute("Exploded"));
    else
        v96 = v95;
    end;

    local v97 = u8 or LocalPlayer:GetAttribute("IsDefusingBomb") == true;
    local v98 = v95 and (not v96 and HoverBomb.IsDefuseAllowed());

    if v98 then
        if not v97 then
            v97 = v95:GetAttribute("CanDefuse") and not v95:GetAttribute("IsGettingDefused");
        end;
    else
        v97 = v98;
    end;

    local v99 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
    local v100 = CenterScreenRaycast.GetHoveredHostage() ~= nil;
    local v101 = GetHoveredBreakableDoor();
    local v102;

    if v101 == nil then
        v102 = false;
    else
        v102 = #v101 > 0;
    end;

    if v97 then
        u15.Interact.Defuse.Visible = true;
        u15.Interact.Use.Visible = false;
        local Interact = u15:FindFirstChild("Interact");

        if Interact then
            Interact.Visible = not u13.Interact;
        end;
    else
        local v103 = v99 or (v100 or v102);
        u15.Interact.Defuse.Visible = false;
        u15.Interact.Use.Visible = v103;
        local Interact = u15:FindFirstChild("Interact");

        if Interact then
            if v103 then
                v103 = not u13.Interact;
            end;

            Interact.Visible = v103;
        end;
    end;
end;

local u104 = "";

local function HandsBusyStateChanged() -- Line: 497
    -- upvalues: SurvivalDowned (copy), LocalPlayer (copy), InventoryController (copy), u104 (ref)
    local v105;

    if SurvivalDowned.AreHandsBusy(LocalPlayer) then
        local CurrentEquipped = InventoryController.getCurrentEquipped();
        local v106;

        if CurrentEquipped then
            v106 = CurrentEquipped.Properties.Slot;
        else
            v106 = nil;
        end;

        local v107 = SurvivalDowned.CanUseSlot(LocalPlayer, v106);
        v105 = `{SurvivalDowned.IsDowned(LocalPlayer)}:{v107}`;
    else
        v105 = "";
    end;

    local v108 = v105 ~= u104;
    u104 = v105;

    return v108;
end;

local function UpdateHandsBusyButtons() -- Line: 512
    -- upvalues: SurvivalDowned (copy), LocalPlayer (copy), InventoryController (copy), table_freeze_ret (copy), table_freeze_ret2 (copy), u15 (ref)
    if not SurvivalDowned.AreHandsBusy(LocalPlayer) then
        return;
    end;

    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v109;

    if CurrentEquipped then
        v109 = CurrentEquipped.Properties.Slot;
    else
        v109 = nil;
    end;

    local v110 = SurvivalDowned.CanUseSlot(LocalPlayer, v109);

    for _, v in table_freeze_ret do
        if not (v110 and table_freeze_ret2[v]) then
            local v111 = u15:FindFirstChild(v);

            if v111 then
                v111.Visible = false;
            end;
        end;
    end;

    if SurvivalDowned.IsDowned(LocalPlayer) then
        local Jump = u15:FindFirstChild("Jump");

        if Jump then
            Jump.Visible = false;
        end;

        local Crouch = u15:FindFirstChild("Crouch");

        if Crouch then
            Crouch.Visible = false;
        end;
    end;
end;

local function HasAlternativeAction(p112) -- Line: 530
    -- upvalues: GameState (copy)
    if not (p112 and p112.Properties) then
        return false;
    end;

    local Properties = p112.Properties;

    return (Properties.HasScope == true or Properties.HasSuppressor == true) and true or ((Properties.ShootingOptions == "Burst" or Properties.ShootingOptions == "Revolver") and true or ((Properties.Type == "Equipment" or (Properties.Class == "Grenade" and true or Properties.Slot == "Grenade")) and GameState.GetState() ~= "Buy Period" and true or false));
end;

local function UpdateAlternativeActionButton() -- Line: 550
    -- upvalues: SpectateController (copy), u15 (ref), HasAlternativeAction (copy), InventoryController (copy), u13 (copy)
    if SpectateController.IsLocalPlayerDead() then
        local AlternativeAction = u15:FindFirstChild("AlternativeAction");

        if AlternativeAction then
            AlternativeAction.Visible = false;
        end;

        return;
    end;

    local v113 = HasAlternativeAction(InventoryController.getCurrentEquipped());
    local AlternativeAction = u15:FindFirstChild("AlternativeAction");

    if AlternativeAction then
        if v113 then
            v113 = not u13.AlternativeAction;
        end;

        AlternativeAction.Visible = v113;
    end;
end;

local function CanDropCurrentEquipped(p114) -- Line: 559
    -- upvalues: SpectateController (copy), IsTutorialMode (copy), GameState (copy)
    if not p114 or (SpectateController.IsLocalPlayerDead() or IsTutorialMode()) then
        return false;
    end;

    local Properties = p114.Properties;

    if not Properties then
        return false;
    end;

    local v115;

    if Properties.Class == "Melee" then
        v115 = workspace:GetAttribute("VIPKnifeDropEnabled") == true;
    else
        v115 = false;
    end;

    if not (Properties.Droppable or v115) then
        return false;
    end;

    if GameState.GetState() == "Warmup" or workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false;
    end;

    return (Properties.Class ~= "C4" or not p114.IsPlanting) and true or false;
end;

local function UpdateDropButton() -- Line: 584
    -- upvalues: CanDropCurrentEquipped (copy), InventoryController (copy), u15 (ref), u13 (copy)
    local v116 = CanDropCurrentEquipped(InventoryController.getCurrentEquipped());
    local Drop = u15:FindFirstChild("Drop");

    if Drop then
        if v116 then
            v116 = not u13.Drop;
        end;

        Drop.Visible = v116;
    end;
end;

local function UpdateReloadButton() -- Line: 588
    -- upvalues: SpectateController (copy), u15 (ref), InventoryController (copy), u13 (copy)
    if SpectateController.IsLocalPlayerDead() then
        local Reload = u15:FindFirstChild("Reload");

        if Reload then
            Reload.Visible = false;
        end;

        return;
    end;

    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v117;

    if CurrentEquipped == nil then
        v117 = false;
    else
        v117 = CurrentEquipped.Properties.Class == "Weapon";
    end;

    local Reload = u15:FindFirstChild("Reload");

    if Reload then
        if v117 then
            v117 = not u13.Reload;
        end;

        Reload.Visible = v117;
    end;
end;

local function UpdatePingButton() -- Line: 599
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u15 (ref), u13 (copy)
    if LocalPlayer:GetAttribute("IsSpectating") == true or SpectateController.IsLocalPlayerDead() then
        local Ping = u15:FindFirstChild("Ping");

        if Ping then
            Ping.Visible = false;
        end;

        return;
    end;

    local v118 = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
    local Ping = u15:FindFirstChild("Ping");

    if Ping then
        if v118 then
            v118 = not u13.Ping;
        end;

        Ping.Visible = v118;
    end;
end;

local function UpdateInspectButton() -- Line: 609
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
    local v119 = CurrentEquipped and CurrentEquipped.Viewmodel and CurrentEquipped.Viewmodel.Animation;
    local v120;

    if v119 == nil or v119.hasInspectAnimation == nil then
        v120 = false;
    else
        v120 = v119:hasInspectAnimation();
    end;

    local v121 = v120 == true;
    local Inspect = u15:FindFirstChild("Inspect");

    if Inspect then
        if v121 then
            v121 = not u13.Inspect;
        end;

        Inspect.Visible = v121;
    end;
end;

local function GetRarityRGB(p122) -- Line: 627
    return math.floor(p122.Color.R * 255), math.floor(p122.Color.G * 255), math.floor(p122.Color.B * 255);
end;

local function BindPressFeedback(u123: userdata) -- Line: 635
    -- upvalues: TrackButtonTouchStart (copy), u11 (copy), TweenButtonToRestingScale (copy)
    u123.InputBegan:Connect(function(p124: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), u123 (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p124.UserInputType ~= Enum.UserInputType.Touch and p124.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p124.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(u123, p124);

            if u11[u123] == p124 then
                TweenButtonToRestingScale(u123, 0.9);
            end;
        end;
    end);
end;

local function BindTapButton(u125: userdata, u126: function) -- Line: 650
    -- upvalues: TrackButtonTouchStart (copy), u11 (copy), TweenButtonToRestingScale (copy)
    u125.InputBegan:Connect(function(p127: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), u125 (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p127.UserInputType ~= Enum.UserInputType.Touch and p127.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p127.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(u125, p127);

            if u11[u125] == p127 then
                TweenButtonToRestingScale(u125, 0.9);
            end;
        end;
    end);
    u125.InputEnded:Connect(function(p128: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), u125 (copy), u11 (ref), u126 (copy)
        if p128.UserInputType ~= Enum.UserInputType.Touch and p128.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u125, 1);
        local v129 = u11[u125];
        local v130;

        if v129 == nil then
            v130 = false;
        else
            v130 = p128 == nil and true or p128 == v129;
        end;

        if not v130 then
            local v131 = u125;

            if u11[v131] == p128 then
                u11[v131] = nil;
            end;

            return;
        end;

        local v132 = u125;

        if u11[v132] == p128 then
            u11[v132] = nil;
        end;

        u126();
    end);
end;

function u1.HighlightButton(p133: string, p134: number) -- Line: 671
    -- upvalues: u15 (ref), u11 (copy), u12 (copy), TweenService (copy)
    local u135 = u15 and u15:FindFirstChild(p133);

    if not (u135 and (u135:IsA("TextButton") and not u11[u135])) then
        return;
    end;

    local v136 = u12[u135] or u135.Size;
    local math_round_ret = math.round(p134 / 1);
    local math_max_ret = math.max(1, math_round_ret);
    u135.Size = v136;
    local v137 = TweenService:Create(u135, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, math_max_ret - 1, true), {
        Size = UDim2.fromScale(v136.X.Scale * 1.2, v136.Y.Scale * 1.2)
    });
    v137.Completed:Once(function(p138) -- Line: 685
        -- upvalues: u135 (copy), u12 (ref)
        if p138 == Enum.PlaybackState.Completed then
            local v139 = u135;
            u135.Size = u12[v139] or v139.Size;
        end;
    end);
    v137:Play();
end;

function u1.setupButton(u140: userdata) -- Line: 693
    -- upvalues: Profiler (copy), u12 (copy), BUTTONS_WITH_EXPLICIT_HANDLERS (copy), TrackButtonTouchStart (copy), u11 (copy), TweenButtonToRestingScale (copy), BUTTONS_EXCLUDED_FROM_CLEARING (copy), BUTTONS_WITH_EXPLICIT_INPUT_ENDED (copy)
    Profiler.mark("UI.MobileButtons.SetupButton");
    u12[u140] = u140.Size;
    u140.InputBegan:Connect(function(p141: userdata) -- Line: 698
        -- upvalues: BUTTONS_WITH_EXPLICIT_HANDLERS (ref), u140 (copy), TrackButtonTouchStart (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p141.UserInputType ~= Enum.UserInputType.Touch and p141.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p141.UserInputState == Enum.UserInputState.Begin then
            if not BUTTONS_WITH_EXPLICIT_HANDLERS[u140.Name] then
                TrackButtonTouchStart(u140, p141);
            end;

            if u11[u140] == p141 then
                TweenButtonToRestingScale(u140, 0.9);
            end;
        end;
    end);

    if not BUTTONS_EXCLUDED_FROM_CLEARING[u140.Name] then
        u140.InputChanged:Connect(function(p142: userdata) -- Line: 716
            -- upvalues: u11 (ref), u140 (copy), TweenButtonToRestingScale (ref)
            if p142.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if u11[u140] == p142 then
                local v143 = u140;
                local Position = p142.Position;
                local AbsolutePosition = v143.AbsolutePosition;
                local AbsoluteSize = v143.AbsoluteSize;
                local v144;

                if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
                    v144 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                else
                    v144 = false;
                end;

                if not v144 then
                    local v145 = u140;

                    if u11[v145] == p142 then
                        u11[v145] = nil;
                    end;

                    TweenButtonToRestingScale(u140, 1);
                end;
            end;
        end);
    end;

    u140.InputEnded:Connect(function(p146: userdata) -- Line: 732
        -- upvalues: TweenButtonToRestingScale (ref), u140 (copy), BUTTONS_WITH_EXPLICIT_INPUT_ENDED (ref), u11 (ref)
        if p146.UserInputType ~= Enum.UserInputType.Touch and p146.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u140, 1);

        if not BUTTONS_WITH_EXPLICIT_INPUT_ENDED[u140.Name] then
            local v147 = u140;

            if u11[v147] == p146 then
                u11[v147] = nil;
            end;
        end;
    end);
end;

function u1.Initialize(p148, p149) -- Line: 746
    -- upvalues: Profiler (copy), u15 (ref), u16 (ref), u7 (ref), u8 (ref), LocalPlayer (copy), u17 (ref), u12 (copy), u3 (copy), script_Loadout (copy), u13 (copy), TrackButtonTouchStart (copy), u11 (copy), script_TouchIntent (copy), CharacterController (copy), TweenButtonToRestingScale (copy), IsSurvivalMode (copy), Promise (copy), InventoryController (copy), CanDropCurrentEquipped (copy), Skins (copy), Rarities (copy), Router (copy), u4 (ref), MobileAutoShootController (copy), SpectateController (copy), GameState (copy), CameraInput (copy), u5 (ref), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), SurvivalDownedController (copy), SurvivalDowned (copy), CollectionService (copy), HoverBomb (copy), CenterScreenRaycast (copy), GetHoveredBreakableDoor (copy), Remotes (copy), BuyMenu (copy), u6 (ref), Leaderboard (copy), IsTutorialMode (copy), Chat (copy), Top (copy), u10 (ref), ChatModes (copy), RunService (copy), ReplicatedStorage (copy), HintController (copy), TeamSelection (copy), DataController (copy), CharacterResolver (copy), GetPingRaycastResult (copy), GetWeaponDataFromInstance (copy), u9 (ref), u1 (copy), RunServiceController (copy), HandsBusyStateChanged (copy), GetDesiredFrameVisibility (copy), u64 (ref), UpdateButtonVisibilityForSpectate (copy), IsInBuyArea (copy), TutorialPurchaseLock (copy), UpdateInteractButton (copy), UpdateInspectButton (copy), UpdatePingButton (copy), HasAlternativeAction (copy), UpdateToggledIndicators (copy), UpdateHandsBusyButtons (copy), UserInputService (copy)
    Profiler.mark("UI.MobileButtons.Initialize");
    u15 = p149;
    u16 = p149.Parent;
    u7 = nil;
    u8 = false;
    local u150 = p149:FindFirstAncestorOfClass("ScreenGui");
    local v151 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if u150 and v151 then
        local MobileControlsGui = v151:FindFirstChild("MobileControlsGui");

        if not (MobileControlsGui and MobileControlsGui:IsA("ScreenGui")) then
            MobileControlsGui = Instance.new("ScreenGui");
            MobileControlsGui.Name = "MobileControlsGui";
            MobileControlsGui.ResetOnSpawn = false;
            MobileControlsGui.IgnoreGuiInset = u150.IgnoreGuiInset;
            MobileControlsGui.ScreenInsets = u150.ScreenInsets;
            MobileControlsGui.SafeAreaCompatibility = u150.SafeAreaCompatibility;
            MobileControlsGui.ClipToDeviceSafeArea = u150.ClipToDeviceSafeArea;
            MobileControlsGui.ZIndexBehavior = u150.ZIndexBehavior;
            MobileControlsGui.DisplayOrder = 1000;
            MobileControlsGui.Parent = v151;
        end;

        u17 = MobileControlsGui;
        p149.Parent = MobileControlsGui;
        local u152 = u16;
        u152 = u152;
        local u153;

        if u152 then
            u153 = u152.Parent;
        else
            u153 = u152;
        end;

        local function syncHostVisibility() -- Line: 776
            -- upvalues: u150 (copy), u153 (copy), u152 (copy), MobileControlsGui (ref)
            local v154 = u150.Enabled and (u153 == nil or (not u153:IsA("GuiObject") or u153.Visible)) and (u152 == nil and true or (not u152:IsA("GuiObject") or u152.Visible));

            if MobileControlsGui.Enabled ~= v154 then
                MobileControlsGui.Enabled = v154;
            end;
        end;

        u150:GetPropertyChangedSignal("Enabled"):Connect(syncHostVisibility);

        if u153 and u153:IsA("GuiObject") then
            u153:GetPropertyChangedSignal("Visible"):Connect(syncHostVisibility);
        end;

        if u152 and u152:IsA("GuiObject") then
            u152:GetPropertyChangedSignal("Visible"):Connect(syncHostVisibility);
        end;

        local v155 = u150.Enabled and (u153 == nil or not u153:IsA("GuiObject") or u153.Visible) and (u152 == nil and true or (not u152:IsA("GuiObject") or u152.Visible));

        if MobileControlsGui.Enabled ~= v155 then
            MobileControlsGui.Enabled = v155;
        end;
    end;

    for _, child in ipairs(u15:GetChildren()) do
        if child:IsA("TextButton") then
            u12[child] = child.Size;
        end;

        local v156;

        if child then
            v156 = child:FindFirstChild("Toggled");
        else
            v156 = child;
        end;

        if v156 and (v156:IsA("GuiObject") and v156.Visible ~= false) then
            v156.Visible = false;
        end;
    end;

    if not u3 then
        u15.Visible = false;

        return;
    end;

    script_Loadout.Initialize(u15, function(p157: string, p158: boolean) -- Line: 805
        -- upvalues: LocalPlayer (ref), u15 (ref), u13 (ref)
        if p158 then
            p158 = LocalPlayer:GetAttribute("IsSpectating") ~= true;
        end;

        local v159 = u15:FindFirstChild(p157);

        if v159 then
            if p158 then
                p158 = not u13[p157];
            end;

            v159.Visible = p158;
        end;
    end);
    local v160 = u16 and u16.Parent;

    if v160 then
        v160 = v160:FindFirstChild("Top");
    end;

    local v161 = v160 and v160:FindFirstChild("Bomb Defusal");

    if v161 then
        v161.Size = UDim2.new(0.6, 0, 0.75, 0);
    end;

    u15.Jump.InputBegan:Connect(function(p162: userdata) -- Line: 823
        -- upvalues: TrackButtonTouchStart (ref), u15 (ref), u11 (ref), script_TouchIntent (ref), CharacterController (ref)
        if p162.UserInputType ~= Enum.UserInputType.Touch and p162.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p162.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        TrackButtonTouchStart(u15.Jump, p162);
        local v163 = u11[u15.Jump];
        local v164;

        if v163 == nil then
            v164 = false;
        else
            v164 = p162 == nil and true or p162 == v163;
        end;

        if v164 then
            script_TouchIntent.onTap(p162, CharacterController.jump);
        end;
    end);
    local Crouch = u15.Crouch;

    local function u165() -- Line: 837
        -- upvalues: CharacterController (ref)
        CharacterController.crouch(not CharacterController.GetCrouchState());
    end;

    Crouch.InputBegan:Connect(function(p166: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), Crouch (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p166.UserInputType ~= Enum.UserInputType.Touch and p166.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p166.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Crouch, p166);

            if u11[Crouch] == p166 then
                TweenButtonToRestingScale(Crouch, 0.9);
            end;
        end;
    end);
    Crouch.InputEnded:Connect(function(p167: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), Crouch (copy), u11 (ref), u165 (copy)
        if p167.UserInputType ~= Enum.UserInputType.Touch and p167.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Crouch, 1);
        local v168 = u11[Crouch];
        local v169;

        if v168 == nil then
            v169 = false;
        else
            v169 = p167 == nil and true or p167 == v168;
        end;

        if not v169 then
            local v170 = Crouch;

            if u11[v170] == p167 then
                u11[v170] = nil;
            end;

            return;
        end;

        local v171 = Crouch;

        if u11[v171] == p167 then
            u11[v171] = nil;
        end;

        u165();
    end);
    local ToggleWalk = u15.ToggleWalk;

    local function u172() -- Line: 842
        -- upvalues: LocalPlayer (ref), IsSurvivalMode (ref), CharacterController (ref)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if IsSurvivalMode() then
            CharacterController.sprint(not CharacterController.GetSprintState());

            return;
        end;

        CharacterController.walk(not CharacterController.GetWalkState());
    end;

    ToggleWalk.InputBegan:Connect(function(p173: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), ToggleWalk (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p173.UserInputType ~= Enum.UserInputType.Touch and p173.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p173.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(ToggleWalk, p173);

            if u11[ToggleWalk] == p173 then
                TweenButtonToRestingScale(ToggleWalk, 0.9);
            end;
        end;
    end);
    ToggleWalk.InputEnded:Connect(function(p174: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), ToggleWalk (copy), u11 (ref), u172 (copy)
        if p174.UserInputType ~= Enum.UserInputType.Touch and p174.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(ToggleWalk, 1);
        local v175 = u11[ToggleWalk];
        local v176;

        if v175 == nil then
            v176 = false;
        else
            v176 = p174 == nil and true or p174 == v175;
        end;

        if not v176 then
            local v177 = ToggleWalk;

            if u11[v177] == p174 then
                u11[v177] = nil;
            end;

            return;
        end;

        local v178 = ToggleWalk;

        if u11[v178] == p174 then
            u11[v178] = nil;
        end;

        u172();
    end);
    u15.Drop.InputEnded:Connect(function(p179: userdata) -- Line: 854
        -- upvalues: u15 (ref), u11 (ref), Promise (ref), InventoryController (ref), CanDropCurrentEquipped (ref), Skins (ref), Rarities (ref), Router (ref)
        if p179.UserInputType ~= Enum.UserInputType.Touch and p179.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v180 = u11[u15.Drop];
        local v181;

        if v180 == nil then
            v181 = false;
        else
            v181 = p179 == nil and true or p179 == v180;
        end;

        local Drop = u15.Drop;

        if u11[Drop] == p179 then
            u11[Drop] = nil;
        end;

        if not v181 then
            return;
        end;

        Promise.new(function(p182, p183) -- Line: 407
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p182(CurrentEquipped);

                return;
            end;

            p183("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p184) -- Line: 864
            -- upvalues: CanDropCurrentEquipped (ref), Skins (ref), Rarities (ref), Router (ref)
            if p184 and CanDropCurrentEquipped(p184) then
                local SkinInformation = Skins.GetSkinInformation(p184.Name, p184.Skin);
                assert(SkinInformation, "Skin data not found for weapon: " .. p184.Name .. " and skin: " .. p184.Skin);
                local v185 = Rarities[SkinInformation.rarity];
                local math_floor_ret = math.floor(v185.Color.R * 255);
                local math_floor_ret2 = math.floor(v185.Color.G * 255);
                local math_floor_ret3 = math.floor(v185.Color.B * 255);

                if p184:drop() then
                    Router.broadcastRouter("CreateNotification", "Item Dropped", `You dropped your <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{p184.Name} | {p184.Skin}</b></font>`, 2);
                end;
            end;
        end);
    end);
    local Reload = u15.Reload;

    local function u189() -- Line: 888
        -- upvalues: Promise (ref), InventoryController (ref)
        Promise.new(function(p186, p187) -- Line: 407
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p186(CurrentEquipped);

                return;
            end;

            p187("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p188) -- Line: 889
            if p188 then
                p188:reload();
            end;
        end);
    end;

    Reload.InputBegan:Connect(function(p190: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), Reload (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p190.UserInputType ~= Enum.UserInputType.Touch and p190.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p190.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Reload, p190);

            if u11[Reload] == p190 then
                TweenButtonToRestingScale(Reload, 0.9);
            end;
        end;
    end);
    Reload.InputEnded:Connect(function(p191: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), Reload (copy), u11 (ref), u189 (copy)
        if p191.UserInputType ~= Enum.UserInputType.Touch and p191.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Reload, 1);
        local v192 = u11[Reload];
        local v193;

        if v192 == nil then
            v193 = false;
        else
            v193 = p191 == nil and true or p191 == v192;
        end;

        if not v193 then
            local v194 = Reload;

            if u11[v194] == p191 then
                u11[v194] = nil;
            end;

            return;
        end;

        local v195 = Reload;

        if u11[v195] == p191 then
            u11[v195] = nil;
        end;

        u189();
    end);
    u15.Shoot.Active = true;
    local u196 = false;

    local function ProcessEndShoot(p197: userdata, p198: boolean?) -- Line: 901
        -- upvalues: u4 (ref), u196 (ref), MobileAutoShootController (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref)
        if p197 ~= u4 then
            return;
        end;

        if not p198 and p197.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u4 = nil;

        if not u196 then
            return;
        end;

        u196 = false;
        MobileAutoShootController.SetManualFireHeld(false);
        TweenButtonToRestingScale(u15.Shoot, 1);
        Promise.new(function(p199, p200) -- Line: 407
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p199(CurrentEquipped);

                return;
            end;

            p200("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p201) -- Line: 922
            if not p201 then
                return;
            end;

            if p201.Properties.Class ~= "Weapon" then
                if p201.Properties.Class == "Melee" then
                    p201.IsFireHeld = false;

                    return;
                end;

                if p201.Properties.Class == "C4" then
                    p201:cancel();

                    return;
                end;

                if p201.Properties.Slot == "Grenade" then
                    p201:Throw("Far");
                end;

                return;
            end;

            if p201.Properties.ShootingOptions ~= "Revolver" then
                p201.IsFireHeld = false;

                return;
            end;

            local v202 = p201.Properties.FireModes and p201.Properties.FireModes.Primary;

            if not v202 or v202.CancelOnRelease ~= false then
                p201:cancelRevolverCharge(false);

                return;
            end;

            p201.IsFireHeld = false;
            p201.FireInputBinding = nil;
        end);
    end;

    u15.Shoot.InputBegan:Connect(function(p203: userdata) -- Line: 956
        -- upvalues: u4 (ref), LocalPlayer (ref), SpectateController (ref), GameState (ref), Router (ref), u196 (ref), MobileAutoShootController (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref)
        if p203.UserInputType ~= Enum.UserInputType.Touch and p203.UserInputType ~= Enum.UserInputType.MouseButton1 or u4 or p203.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u4 = p203;

        if LocalPlayer:GetAttribute("IsPlayerChatting") or (SpectateController.IsLocalPlayerDead() or (not LocalPlayer.Character or GameState.GetState() == "Buy Period")) then
            return;
        end;

        Router.broadcastRouter("Cancel Defuse Bomb");
        u196 = true;
        MobileAutoShootController.SetManualFireHeld(true);
        TweenButtonToRestingScale(u15.Shoot, 0.9);
        Promise.new(function(p204, p205) -- Line: 407
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p204(CurrentEquipped);

                return;
            end;

            p205("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p206) -- Line: 981
            if not p206 then
                return;
            end;

            if p206.Properties.Class ~= "Weapon" then
                if p206.Properties.Class == "Melee" then
                    p206.IsFireHeld = true;
                    p206:shoot();

                    return;
                end;

                if p206.Properties.Class == "C4" then
                    p206:shoot();

                    return;
                end;

                if p206.Properties.Slot == "Grenade" then
                    p206:StartThrow();
                end;

                return;
            end;

            if p206.Properties.ShootingOptions == "Revolver" then
                p206:startRevolverCharge(nil);

                return;
            end;

            if p206.AlternativeShootingOption ~= "Burst" then
                p206.IsFireHeld = true;
                p206:shoot();

                return;
            end;

            if p206.IsBurstShooting then
                return;
            end;

            p206.IsFireHeld = true;
            p206:fireBurst();
        end);
    end);
    u15.Shoot.InputEnded:Connect(ProcessEndShoot);
    u15.Shoot.InputChanged:Connect(function(p207: userdata) -- Line: 1025
        -- upvalues: u4 (ref), CameraInput (ref)
        if p207 == u4 and p207.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p207.Delta.X, p207.Delta.Y));
        end;
    end);
    u15.AlternativeAction.Active = true;

    local function ProcessEndAlternativeAction(p208: userdata, p209: boolean?) -- Line: 1034
        -- upvalues: u5 (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref), GameState (ref)
        if p208 ~= u5 then
            return;
        end;

        if not p209 and p208.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u5 = nil;
        TweenButtonToRestingScale(u15.AlternativeAction, 1);
        Promise.new(function(p210, p211) -- Line: 407
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p210(CurrentEquipped);

                return;
            end;

            p211("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p212) -- Line: 1050
            -- upvalues: GameState (ref)
            if not p212 then
                return;
            end;

            local Properties = p212.Properties;

            if Properties.ShootingOptions == "Revolver" then
                p212:stopRevolverSecondaryFire();

                return;
            end;

            if Properties.Slot ~= "Grenade" or GameState.GetState() == "Buy Period" then
                return;
            end;

            if p212.ThrowStarted and not p212.ThrowFinished then
                p212:Throw("Near");
            end;
        end);
    end;

    u15.AlternativeAction.InputBegan:Connect(function(p213: userdata) -- Line: 1071
        -- upvalues: u5 (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref), LocalPlayer (ref), SpectateController (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), GameState (ref)
        if p213.UserInputType ~= Enum.UserInputType.Touch and p213.UserInputType ~= Enum.UserInputType.MouseButton1 or u5 or p213.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u5 = p213;
        TweenButtonToRestingScale(u15.AlternativeAction, 0.9);
        Promise.new(function(p214, p215) -- Line: 407
            -- upvalues: InventoryController (ref)
            local CurrentEquipped = InventoryController.getCurrentEquipped();

            if CurrentEquipped then
                p214(CurrentEquipped);

                return;
            end;

            p215("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p216) -- Line: 1081
            -- upvalues: LocalPlayer (ref), SpectateController (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), GameState (ref)
            if not p216 then
                return;
            end;

            if LocalPlayer:GetAttribute("IsPlayerChatting") or (SpectateController.IsLocalPlayerDead() or (CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive()))) then
                return;
            end;

            local Properties = p216.Properties;

            if Properties.ShootingOptions == "Revolver" then
                p216:startRevolverSecondaryFire(nil);

                return;
            end;

            if Properties.Class == "Grenade" or Properties.Slot == "Grenade" then
                if GameState.GetState() ~= "Buy Period" then
                    p216:StartThrow();
                end;

                return;
            end;

            if Properties.HasScope then
                p216:scope(true);

                return;
            end;

            if Properties.HasSuppressor then
                if p216.IsSuppressed then
                    p216:removeSuppressor();

                    return;
                end;

                p216:addSuppressor();

                return;
            end;

            if Properties.ShootingOptions == "Burst" then
                p216:updateFireMode();

                return;
            end;

            if Properties.Type ~= "Equipment" then
                return;
            end;

            if GameState.GetState() ~= "Buy Period" then
                p216:shoot(true);
            end;
        end);
    end);
    u15.AlternativeAction.InputEnded:Connect(ProcessEndAlternativeAction);
    u15.AlternativeAction.InputChanged:Connect(function(p217: userdata) -- Line: 1132
        -- upvalues: u5 (ref), CameraInput (ref)
        if p217 == u5 and p217.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p217.Delta.X, p217.Delta.Y));
        end;
    end);
    u15.Interact.Active = true;
    u7 = nil;
    u15.Interact.InputBegan:Connect(function(p218: userdata) -- Line: 1142
        -- upvalues: u7 (ref), TrackButtonTouchStart (ref), u15 (ref), SurvivalDownedController (ref), SurvivalDowned (ref), LocalPlayer (ref), CollectionService (ref), HoverBomb (ref), u8 (ref), Router (ref), CenterScreenRaycast (ref), GetHoveredBreakableDoor (ref), CharacterController (ref), Remotes (ref), Skins (ref), Rarities (ref)
        if p218.UserInputType ~= Enum.UserInputType.Touch and p218.UserInputType ~= Enum.UserInputType.MouseButton1 or u7 or p218.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u7 = p218;
        TrackButtonTouchStart(u15.Interact, p218);

        if SurvivalDownedController.TryStartRevive() or SurvivalDowned.AreHandsBusy(LocalPlayer) then
            return;
        end;

        local v219 = CollectionService:GetTagged("Bomb")[1];

        if v219 and (v219:GetAttribute("CanDefuse") and (not v219:GetAttribute("Defused") and HoverBomb.IsDefuseAllowed())) then
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

        local v220 = GetHoveredBreakableDoor();

        if #v220 > 0 then
            for _, v in v220 do
                local v221 = CharacterController.PredictDoorUse(v);
                local Send = Remotes.BreakableDoor.Use.Send;
                local v222 = {
                    Model = v
                };
                local v223;

                if v221 == nil then
                    v223 = nil;
                else
                    v223 = v221.ServerTick;
                end;

                v222.ServerTick = v223;
                local v224;

                if v221 == nil then
                    v224 = nil;
                else
                    v224 = v221.TargetAngle;
                end;

                v222.TargetAngle = v224;
                local v225;

                if v221 == nil then
                    v225 = nil;
                else
                    v225 = v221.RequestId;
                end;

                v222.RequestId = v225;
                Send(v222);
            end;

            return;
        end;

        local Tagged = CollectionService:GetTagged("IsHoveringInteractable");

        if #Tagged == 0 then
            return;
        end;

        local v226 = Tagged[1];
        local Attribute = v226:GetAttribute("Weapon");
        local Attribute2 = v226:GetAttribute("Skin");

        if Attribute == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
            return;
        end;

        if v226:GetAttribute("CanPickup") then
            local SkinInformation = Skins.GetSkinInformation(Attribute, Attribute2);

            if SkinInformation then
                local v227 = Rarities[SkinInformation.rarity];
                local math_floor_ret = math.floor(v227.Color.R * 255);
                local math_floor_ret2 = math.floor(v227.Color.G * 255);
                local math_floor_ret3 = math.floor(v227.Color.B * 255);
                Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{Attribute:find("Zeus") and "Taser" or Attribute} | {Attribute2}</b></font>`, 2);
            end;

            Remotes.Inventory.PickupWeapon.Send({
                AllowAutoEquip = true,
                Identity = v226.Name
            });
        end;
    end);

    local function ProcessEndInteract(p228: userdata) -- Line: 1235
        -- upvalues: u7 (ref), u8 (ref), LocalPlayer (ref), u15 (ref), u11 (ref), SurvivalDownedController (ref), CollectionService (ref), Router (ref)
        if p228 ~= u7 then
            return;
        end;

        local v229 = u8 or LocalPlayer:GetAttribute("IsDefusingBomb") == true;
        u7 = nil;
        u8 = false;
        local Interact = u15.Interact;

        if u11[Interact] == p228 then
            u11[Interact] = nil;
        end;

        SurvivalDownedController.StopRevive();

        if CollectionService:GetTagged("Bomb")[1] and v229 then
            Router.broadcastRouter("Cancel Defuse Bomb");

            return;
        end;

        if LocalPlayer:GetAttribute("IsRescuingHostage") then
            Router.broadcastRouter("Cancel Rescue Hostage");
        end;
    end;

    u15.Interact.InputEnded:Connect(ProcessEndInteract);
    u15.Interact.InputChanged:Connect(function(p230: userdata) -- Line: 1260
        -- upvalues: u7 (ref), CameraInput (ref)
        if p230 == u7 and p230.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p230.Delta.X, p230.Delta.Y));
        end;
    end);
    local Shop = u15.Shop;
    local toggleFrame = BuyMenu.toggleFrame;
    Shop.InputBegan:Connect(function(p231: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), Shop (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p231.UserInputType ~= Enum.UserInputType.Touch and p231.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p231.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Shop, p231);

            if u11[Shop] == p231 then
                TweenButtonToRestingScale(Shop, 0.9);
            end;
        end;
    end);
    Shop.InputEnded:Connect(function(p232: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), Shop (copy), u11 (ref), toggleFrame (copy)
        if p232.UserInputType ~= Enum.UserInputType.Touch and p232.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Shop, 1);
        local v233 = u11[Shop];
        local v234;

        if v233 == nil then
            v234 = false;
        else
            v234 = p232 == nil and true or p232 == v233;
        end;

        if not v234 then
            local v235 = Shop;

            if u11[v235] == p232 then
                u11[v235] = nil;
            end;

            return;
        end;

        local v236 = Shop;

        if u11[v236] == p232 then
            u11[v236] = nil;
        end;

        toggleFrame();
    end);

    local function ProcessEndScoreboard(p237: userdata, p238: boolean?) -- Line: 1270
        -- upvalues: u6 (ref), TweenButtonToRestingScale (ref), u15 (ref), u11 (ref)
        if p237 ~= u6 then
            return;
        end;

        if not p238 and p237.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u6 = nil;
        TweenButtonToRestingScale(u15.ToggleScoreboard, 1);
        local ToggleScoreboard = u15.ToggleScoreboard;

        if u11[ToggleScoreboard] == p237 then
            u11[ToggleScoreboard] = nil;
        end;
    end;

    u15.ToggleScoreboard.InputBegan:Connect(function(p239: userdata) -- Line: 1283
        -- upvalues: u6 (ref), LocalPlayer (ref), TrackButtonTouchStart (ref), u15 (ref), TweenButtonToRestingScale (ref)
        if p239.UserInputType ~= Enum.UserInputType.Touch and p239.UserInputType ~= Enum.UserInputType.MouseButton1 or (u6 or LocalPlayer:GetAttribute("IsPlayerChatting")) or p239.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u6 = p239;
        TrackButtonTouchStart(u15.ToggleScoreboard, p239);
        TweenButtonToRestingScale(u15.ToggleScoreboard, 0.9);
    end);
    u15.ToggleScoreboard.InputEnded:Connect(function(p240: userdata) -- Line: 1298
        -- upvalues: u6 (ref), u15 (ref), u11 (ref), TweenButtonToRestingScale (ref), Leaderboard (ref)
        if p240 ~= u6 then
            return;
        end;

        local v241 = u11[u15.ToggleScoreboard];
        local v242;

        if v241 == nil then
            v242 = false;
        else
            v242 = p240 == nil and true or p240 == v241;
        end;

        if p240 == u6 then
            u6 = nil;
            TweenButtonToRestingScale(u15.ToggleScoreboard, 1);
            local ToggleScoreboard = u15.ToggleScoreboard;

            if u11[ToggleScoreboard] == p240 then
                u11[ToggleScoreboard] = nil;
            end;
        end;

        if not v242 then
            return;
        end;

        if Leaderboard.IsOpen() then
            Leaderboard.closeFrame();

            return;
        end;

        Leaderboard.openFrame();
    end);
    local Menu = u15.Menu;

    local function u243() -- Line: 1316
        -- upvalues: IsTutorialMode (ref), Chat (ref), Top (ref)
        if IsTutorialMode() then
            return;
        end;

        Chat.CloseChat();
        Top.ToggleMenu();
    end;

    Menu.InputBegan:Connect(function(p244: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), Menu (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p244.UserInputType ~= Enum.UserInputType.Touch and p244.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p244.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Menu, p244);

            if u11[Menu] == p244 then
                TweenButtonToRestingScale(Menu, 0.9);
            end;
        end;
    end);
    Menu.InputEnded:Connect(function(p245: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), Menu (copy), u11 (ref), u243 (copy)
        if p245.UserInputType ~= Enum.UserInputType.Touch and p245.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Menu, 1);
        local v246 = u11[Menu];
        local v247;

        if v246 == nil then
            v247 = false;
        else
            v247 = p245 == nil and true or p245 == v246;
        end;

        if not v247 then
            local v248 = Menu;

            if u11[v248] == p245 then
                u11[v248] = nil;
            end;

            return;
        end;

        local v249 = Menu;

        if u11[v249] == p245 then
            u11[v249] = nil;
        end;

        u243();
    end);
    local Chat2 = u15.Chat;

    local function u250() -- Line: 1325
        -- upvalues: u10 (ref), Chat (ref), ChatModes (ref)
        if not u10 then
            return;
        end;

        Chat.ToggleChat(ChatModes.Modes.All);
    end;

    Chat2.InputBegan:Connect(function(p251: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), Chat2 (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p251.UserInputType ~= Enum.UserInputType.Touch and p251.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p251.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Chat2, p251);

            if u11[Chat2] == p251 then
                TweenButtonToRestingScale(Chat2, 0.9);
            end;
        end;
    end);
    Chat2.InputEnded:Connect(function(p252: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), Chat2 (copy), u11 (ref), u250 (copy)
        if p252.UserInputType ~= Enum.UserInputType.Touch and p252.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Chat2, 1);
        local v253 = u11[Chat2];
        local v254;

        if v253 == nil then
            v254 = false;
        else
            v254 = p252 == nil and true or p252 == v253;
        end;

        if not v254 then
            local v255 = Chat2;

            if u11[v255] == p252 then
                u11[v255] = nil;
            end;

            return;
        end;

        local v256 = Chat2;

        if u11[v256] == p252 then
            u11[v256] = nil;
        end;

        u250();
    end);
    local VIP = u15:FindFirstChild("VIP");

    if VIP and VIP:IsA("TextButton") then
        local function u258() -- Line: 1336
            -- upvalues: RunService (ref), LocalPlayer (ref), ReplicatedStorage (ref)
            local v257;

            if RunService:IsStudio() then
                v257 = true;
            elseif workspace:GetAttribute("IsVIPServer") == true then
                v257 = LocalPlayer:GetAttribute("CanUseVIPMenu") == true;
            else
                v257 = false;
            end;

            if not v257 or LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu).toggleFrame();
        end;

        VIP.InputBegan:Connect(function(p259: userdata) -- Line: 636
            -- upvalues: TrackButtonTouchStart (ref), VIP (copy), u11 (ref), TweenButtonToRestingScale (ref)
            if p259.UserInputType ~= Enum.UserInputType.Touch and p259.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return;
            end;

            if p259.UserInputState == Enum.UserInputState.Begin then
                TrackButtonTouchStart(VIP, p259);

                if u11[VIP] == p259 then
                    TweenButtonToRestingScale(VIP, 0.9);
                end;
            end;
        end);
        VIP.InputEnded:Connect(function(p260: userdata) -- Line: 652
            -- upvalues: TweenButtonToRestingScale (ref), VIP (copy), u11 (ref), u258 (copy)
            if p260.UserInputType ~= Enum.UserInputType.Touch and p260.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return;
            end;

            TweenButtonToRestingScale(VIP, 1);
            local v261 = u11[VIP];
            local v262;

            if v261 == nil then
                v262 = false;
            else
                v262 = p260 == nil and true or p260 == v261;
            end;

            if not v262 then
                local v263 = VIP;

                if u11[v263] == p260 then
                    u11[v263] = nil;
                end;

                return;
            end;

            local v264 = VIP;

            if u11[v264] == p260 then
                u11[v264] = nil;
            end;

            u258();
        end);
    end;

    local Inspect = u15.Inspect;

    local function u265() -- Line: 1346
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

    Inspect.InputBegan:Connect(function(p266: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), Inspect (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p266.UserInputType ~= Enum.UserInputType.Touch and p266.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p266.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Inspect, p266);

            if u11[Inspect] == p266 then
                TweenButtonToRestingScale(Inspect, 0.9);
            end;
        end;
    end);
    Inspect.InputEnded:Connect(function(p267: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), Inspect (copy), u11 (ref), u265 (copy)
        if p267.UserInputType ~= Enum.UserInputType.Touch and p267.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Inspect, 1);
        local v268 = u11[Inspect];
        local v269;

        if v268 == nil then
            v269 = false;
        else
            v269 = p267 == nil and true or p267 == v268;
        end;

        if not v269 then
            local v270 = Inspect;

            if u11[v270] == p267 then
                u11[v270] = nil;
            end;

            return;
        end;

        local v271 = Inspect;

        if u11[v271] == p267 then
            u11[v271] = nil;
        end;

        u265();
    end);
    local SwapTeam = u15.SwapTeam;

    local function u272() -- Line: 1362
        -- upvalues: LocalPlayer (ref), TeamSelection (ref)
        if LocalPlayer:GetAttribute("IsSpectating") then
            TeamSelection.openFrame();

            return;
        end;

        if LocalPlayer.Character then
            TeamSelection.ToggleTeamSelection();
        end;
    end;

    SwapTeam.InputBegan:Connect(function(p273: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), SwapTeam (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p273.UserInputType ~= Enum.UserInputType.Touch and p273.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p273.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(SwapTeam, p273);

            if u11[SwapTeam] == p273 then
                TweenButtonToRestingScale(SwapTeam, 0.9);
            end;
        end;
    end);
    SwapTeam.InputEnded:Connect(function(p274: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), SwapTeam (copy), u11 (ref), u272 (copy)
        if p274.UserInputType ~= Enum.UserInputType.Touch and p274.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(SwapTeam, 1);
        local v275 = u11[SwapTeam];
        local v276;

        if v275 == nil then
            v276 = false;
        else
            v276 = p274 == nil and true or p274 == v275;
        end;

        if not v276 then
            local v277 = SwapTeam;

            if u11[v277] == p274 then
                u11[v277] = nil;
            end;

            return;
        end;

        local v278 = SwapTeam;

        if u11[v278] == p274 then
            u11[v278] = nil;
        end;

        u272();
    end);
    local Ping = u15.Ping;

    local function u283() -- Line: 1371
        -- upvalues: DataController (ref), LocalPlayer (ref), CharacterResolver (ref), GetPingRaycastResult (ref), GetWeaponDataFromInstance (ref), Remotes (ref), u9 (ref)
        if workspace:GetAttribute("Gamemode") == "Deathmatch" or (DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" or not CharacterResolver.isAliveCharacter(LocalPlayer.Character)) then
            return;
        end;

        local v279 = GetPingRaycastResult(LocalPlayer.Character);

        if not v279 then
            return;
        end;

        local v280, v281, v282 = GetWeaponDataFromInstance(v279.Instance);

        if v280 and (v281 and v282) then
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = false,
                Position = v279.Position,
                WeaponIdentity = v282,
                WeaponName = v280,
                WeaponSkin = v281
            });
        else
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = tick() - u9 < 0.5,
                Position = v279.Position
            });
        end;

        u9 = tick();
    end;

    Ping.InputBegan:Connect(function(p284: userdata) -- Line: 636
        -- upvalues: TrackButtonTouchStart (ref), Ping (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p284.UserInputType ~= Enum.UserInputType.Touch and p284.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p284.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Ping, p284);

            if u11[Ping] == p284 then
                TweenButtonToRestingScale(Ping, 0.9);
            end;
        end;
    end);
    Ping.InputEnded:Connect(function(p285: userdata) -- Line: 652
        -- upvalues: TweenButtonToRestingScale (ref), Ping (copy), u11 (ref), u283 (copy)
        if p285.UserInputType ~= Enum.UserInputType.Touch and p285.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(Ping, 1);
        local v286 = u11[Ping];
        local v287;

        if v286 == nil then
            v287 = false;
        else
            v287 = p285 == nil and true or p285 == v286;
        end;

        if not v287 then
            local v288 = Ping;

            if u11[v288] == p285 then
                u11[v288] = nil;
            end;

            return;
        end;

        local v289 = Ping;

        if u11[v289] == p285 then
            u11[v289] = nil;
        end;

        u283();
    end);

    for _, child in ipairs(u15:GetChildren()) do
        if child:IsA("TextButton") and (child.Name ~= "Shoot" and child.Name ~= "AlternativeAction") then
            u1.setupButton(child);
        end;
    end;

    RunServiceController.BindToHeartbeat("UI.MobileButtons.UpdateVisibility", function() -- Line: 1410
        -- upvalues: Profiler (ref), HandsBusyStateChanged (ref), u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), u64 (ref), UpdateButtonVisibilityForSpectate (ref), IsInBuyArea (ref), TutorialPurchaseLock (ref), u13 (ref), IsTutorialMode (ref), RunService (ref), UpdateInteractButton (ref), UpdateInspectButton (ref), SpectateController (ref), InventoryController (ref), CanDropCurrentEquipped (ref), UpdatePingButton (ref), HasAlternativeAction (ref), UpdateToggledIndicators (ref), UpdateHandsBusyButtons (ref)
        Profiler.mark("UI.MobileButtons.Heartbeat");
        local v290 = HandsBusyStateChanged();

        if u15 then
            local v291 = GetDesiredFrameVisibility(nil);
            local Visible = u15.Visible;
            u15.Visible = v291;
            local v292 = LocalPlayer:GetAttribute("IsSpectating") == true;

            if v291 and (v290 ~= false or (not Visible or u64 ~= v292)) then
                UpdateButtonVisibilityForSpectate(v292);
            end;

            u64 = v292;
        end;

        if not u15.Visible then
            return;
        end;

        local v293 = LocalPlayer:GetAttribute("IsSpectating") ~= true;

        if v293 then
            if LocalPlayer:GetAttribute("BuyMenu") == true then
                v293 = IsInBuyArea(LocalPlayer) and not TutorialPurchaseLock.isBuyMenuLocked(LocalPlayer);
            else
                v293 = false;
            end;
        end;

        local Shop2 = u15:FindFirstChild("Shop");

        if Shop2 then
            if v293 then
                v293 = not u13.Shop;
            end;

            Shop2.Visible = v293;
        end;

        local v294 = IsTutorialMode() and u15:FindFirstChild("Menu");

        if v294 then
            v294.Visible = false;
        end;

        local v295;

        if RunService:IsStudio() then
            v295 = true;
        elseif workspace:GetAttribute("IsVIPServer") == true then
            v295 = LocalPlayer:GetAttribute("CanUseVIPMenu") == true;
        else
            v295 = false;
        end;

        if v295 then
            v295 = not IsTutorialMode();
        end;

        local VIP2 = u15:FindFirstChild("VIP");

        if VIP2 then
            if v295 then
                v295 = not u13.VIP;
            end;

            VIP2.Visible = v295;
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
            local v296;

            if CurrentEquipped == nil then
                v296 = false;
            else
                v296 = CurrentEquipped.Properties.Class == "Weapon";
            end;

            local Reload2 = u15:FindFirstChild("Reload");

            if Reload2 then
                if v296 then
                    v296 = not u13.Reload;
                end;

                Reload2.Visible = v296;
            end;
        end;

        local v297 = CanDropCurrentEquipped(InventoryController.getCurrentEquipped());
        local Drop = u15:FindFirstChild("Drop");

        if Drop then
            if v297 then
                v297 = not u13.Drop;
            end;

            Drop.Visible = v297;
        end;

        UpdatePingButton();

        if SpectateController.IsLocalPlayerDead() then
            local AlternativeAction = u15:FindFirstChild("AlternativeAction");

            if AlternativeAction then
                AlternativeAction.Visible = false;
            end;
        else
            local v298 = HasAlternativeAction(InventoryController.getCurrentEquipped());
            local AlternativeAction = u15:FindFirstChild("AlternativeAction");

            if AlternativeAction then
                if v298 then
                    v298 = not u13.AlternativeAction;
                end;

                AlternativeAction.Visible = v298;
            end;
        end;

        UpdateToggledIndicators();
        UpdateHandsBusyButtons();
    end);
    UserInputService.InputChanged:Connect(function(p299: userdata) -- Line: 1439
        -- upvalues: u4 (ref), u5 (ref), u7 (ref), CameraInput (ref)
        if p299 == u4 or (p299 == u5 or p299 == u7) then
            CameraInput.addTouchMove(Vector2.new(p299.Delta.X, p299.Delta.Y));
        end;
    end);
    UserInputService.InputEnded:Connect(function(p300: userdata) -- Line: 1446
        -- upvalues: u4 (ref), u196 (ref), MobileAutoShootController (ref), TweenButtonToRestingScale (ref), u15 (ref), Promise (ref), InventoryController (ref), u5 (ref), GameState (ref), u6 (ref), u11 (ref), ProcessEndInteract (copy)
        if p300.UserInputType == Enum.UserInputType.Touch and true or p300.UserInputType == Enum.UserInputType.MouseButton1 then
            if p300 == u4 then
                u4 = nil;

                if u196 then
                    u196 = false;
                    MobileAutoShootController.SetManualFireHeld(false);
                    TweenButtonToRestingScale(u15.Shoot, 1);
                    Promise.new(function(p301, p302) -- Line: 407
                        -- upvalues: InventoryController (ref)
                        local CurrentEquipped = InventoryController.getCurrentEquipped();

                        if CurrentEquipped then
                            p301(CurrentEquipped);

                            return;
                        end;

                        p302("Failed to fetch current equipped");
                    end):catch(warn):andThen(function(p303) -- Line: 922
                        if not p303 then
                            return;
                        end;

                        if p303.Properties.Class ~= "Weapon" then
                            if p303.Properties.Class == "Melee" then
                                p303.IsFireHeld = false;

                                return;
                            end;

                            if p303.Properties.Class == "C4" then
                                p303:cancel();

                                return;
                            end;

                            if p303.Properties.Slot == "Grenade" then
                                p303:Throw("Far");
                            end;

                            return;
                        end;

                        if p303.Properties.ShootingOptions ~= "Revolver" then
                            p303.IsFireHeld = false;

                            return;
                        end;

                        local v304 = p303.Properties.FireModes and p303.Properties.FireModes.Primary;

                        if not v304 or v304.CancelOnRelease ~= false then
                            p303:cancelRevolverCharge(false);

                            return;
                        end;

                        p303.IsFireHeld = false;
                        p303.FireInputBinding = nil;
                    end);
                end;
            end;

            if p300 == u5 then
                u5 = nil;
                TweenButtonToRestingScale(u15.AlternativeAction, 1);
                Promise.new(function(p305, p306) -- Line: 407
                    -- upvalues: InventoryController (ref)
                    local CurrentEquipped = InventoryController.getCurrentEquipped();

                    if CurrentEquipped then
                        p305(CurrentEquipped);

                        return;
                    end;

                    p306("Failed to fetch current equipped");
                end):catch(warn):andThen(function(p307) -- Line: 1050
                    -- upvalues: GameState (ref)
                    if not p307 then
                        return;
                    end;

                    local Properties = p307.Properties;

                    if Properties.ShootingOptions == "Revolver" then
                        p307:stopRevolverSecondaryFire();

                        return;
                    end;

                    if Properties.Slot ~= "Grenade" or GameState.GetState() == "Buy Period" then
                        return;
                    end;

                    if p307.ThrowStarted and not p307.ThrowFinished then
                        p307:Throw("Near");
                    end;
                end);
            end;

            if p300 == u6 then
                u6 = nil;
                TweenButtonToRestingScale(u15.ToggleScoreboard, 1);
                local ToggleScoreboard = u15.ToggleScoreboard;

                if u11[ToggleScoreboard] == p300 then
                    u11[ToggleScoreboard] = nil;
                end;
            end;

            ProcessEndInteract(p300);

            for i, v in pairs(u11) do
                if v == p300 then
                    u11[i] = nil;
                end;
            end;
        end;
    end);
end;

function u1.Start() -- Line: 1465
    -- upvalues: Profiler (copy), u15 (ref), u3 (copy), u10 (ref), CanPlayerUseChatService (copy), LocalPlayer (copy), GetDesiredFrameVisibility (copy), UpdateButtonVisibilityForSpectate (copy), u64 (ref), script_Loadout (copy), u5 (ref), u6 (ref), Leaderboard (copy), RefreshButtonVisibility (copy), u14 (copy), u16 (ref), DataController (copy), Mobile (copy), u13 (copy), ApplyMobileButtonLayout (copy), u12 (copy)
    debug.setmemorycategory("UI.MobileButtons.Start");
    Profiler.mark("UI.MobileButtons.Start");
    u15.Visible = false;

    if u3 then
        task.spawn(function() -- Line: 1473
            -- upvalues: u10 (ref), CanPlayerUseChatService (ref), LocalPlayer (ref), u15 (ref), GetDesiredFrameVisibility (ref), UpdateButtonVisibilityForSpectate (ref), u64 (ref)
            u10 = CanPlayerUseChatService(LocalPlayer);

            if not u15 then
                return;
            end;

            local v308 = GetDesiredFrameVisibility(nil);
            local _ = u15.Visible;
            u15.Visible = v308;
            local v309 = LocalPlayer:GetAttribute("IsSpectating") == true;

            if v308 then
                UpdateButtonVisibilityForSpectate(v309);
            end;

            u64 = v309;
        end);
        script_Loadout.Start();

        if u15 then
            local v310 = GetDesiredFrameVisibility(nil);
            local _ = u15.Visible;
            u15.Visible = v310;
            local v311 = LocalPlayer:GetAttribute("IsSpectating") == true;

            if v310 then
                UpdateButtonVisibilityForSpectate(v311);
            end;

            u64 = v311;
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(function() -- Line: 1486
        -- upvalues: u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u64 (ref)
        if not u15 then
            return;
        end;

        local v312 = GetDesiredFrameVisibility(nil);
        local _ = u15.Visible;
        u15.Visible = v312;
        local v313 = LocalPlayer:GetAttribute("IsSpectating") == true;

        if v312 then
            UpdateButtonVisibilityForSpectate(v313);
        end;

        u64 = v313;
    end);
    LocalPlayer.CharacterRemoving:Connect(function(p314: userdata) -- Line: 1491
        -- upvalues: u5 (ref), u6 (ref), Leaderboard (ref), u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u64 (ref)
        u5 = nil;
        u6 = nil;
        Leaderboard.closeFrame();

        if not u15 then
            return;
        end;

        local v315 = GetDesiredFrameVisibility(p314);
        local _ = u15.Visible;
        u15.Visible = v315;
        local v316 = LocalPlayer:GetAttribute("IsSpectating") == true;

        if v315 then
            UpdateButtonVisibilityForSpectate(v316);
        end;

        u64 = v316;
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(RefreshButtonVisibility);
    local u317 = { "TeamSelection", table.unpack(u14) };
    local v318 = u16;

    if v318 then
        local function watchSiblingFrame(p319: userdata) -- Line: 1506
            -- upvalues: u317 (copy), RefreshButtonVisibility (ref), u15 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u64 (ref)
            if p319:IsA("GuiObject") and table.find(u317, p319.Name) then
                p319:GetPropertyChangedSignal("Visible"):Connect(RefreshButtonVisibility);

                if not u15 then
                    return;
                end;

                local v320 = GetDesiredFrameVisibility(nil);
                local _ = u15.Visible;
                u15.Visible = v320;
                local v321 = LocalPlayer:GetAttribute("IsSpectating") == true;

                if v320 then
                    UpdateButtonVisibilityForSpectate(v321);
                end;

                u64 = v321;
            end;
        end;

        for _, child in v318:GetChildren() do
            if child:IsA("GuiObject") and table.find(u317, child.Name) then
                child:GetPropertyChangedSignal("Visible"):Connect(RefreshButtonVisibility);

                if u15 then
                    local v322 = GetDesiredFrameVisibility(nil);
                    local _ = u15.Visible;
                    u15.Visible = v322;
                    local v323 = LocalPlayer:GetAttribute("IsSpectating") == true;

                    if v322 then
                        UpdateButtonVisibilityForSpectate(v323);
                    end;

                    u64 = v323;
                end;
            end;
        end;

        v318.ChildAdded:Connect(watchSiblingFrame);
    end;

    DataController.CreateListener(LocalPlayer, "MobileButtons", function(p324) -- Line: 1520
        -- upvalues: Mobile (ref), u13 (ref), u15 (ref), ApplyMobileButtonLayout (ref), u12 (ref), GetDesiredFrameVisibility (ref), LocalPlayer (ref), UpdateButtonVisibilityForSpectate (ref), u64 (ref)
        if typeof(p324) ~= "table" then
            return;
        end;

        local v325 = Mobile.SanitizeLayout(p324);
        table.clear(u13);

        for i, v in pairs(v325) do
            local v326 = u15:FindFirstChild(i);

            if v326 and v326:IsA("GuiObject") then
                ApplyMobileButtonLayout(v326, v);
                u12[v326] = v326.Size;

                if not v.Enabled then
                    u13[i] = true;
                end;
            end;
        end;

        if not u15 then
            return;
        end;

        local v327 = GetDesiredFrameVisibility(nil);
        local _ = u15.Visible;
        u15.Visible = v327;
        local v328 = LocalPlayer:GetAttribute("IsSpectating") == true;

        if v327 then
            UpdateButtonVisibilityForSpectate(v328);
        end;

        u64 = v328;
    end);
end;

return u1;