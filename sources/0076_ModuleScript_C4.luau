-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local workspace_CurrentCamera = workspace.CurrentCamera;
local Debris = workspace:WaitForChild("Debris");
local u2 = nil;
local u3 = (-1 / 0);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;

local function PlayerCanPlantC4() -- Line: 86
    -- upvalues: CharacterResolver (copy), RaycastParams_new_ret (copy), workspace_CurrentCamera (copy), Debris (copy), RuntimeKinematics (copy), Players (copy)
    local LocalCharacter = CharacterResolver.getLocalCharacter();
    RaycastParams_new_ret.FilterDescendantsInstances = { LocalCharacter, workspace_CurrentCamera, Debris };

    if not (CharacterResolver.isAliveCharacter(LocalCharacter) and RuntimeKinematics.isOnGround(LocalCharacter)) then
        return false;
    end;

    local PrimaryPart = LocalCharacter.PrimaryPart;

    if not PrimaryPart then
        return false;
    end;

    local v4 = { workspace_CurrentCamera, Debris };

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Character then
            table.insert(v4, v.Character);
        end;
    end;

    local Map = workspace:FindFirstChild("Map");
    local v5;

    if Map then
        v5 = Map:FindFirstChild("Barriers");
    else
        v5 = nil;
    end;

    if v5 then
        table.insert(v4, v5);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v4;
    local v6 = workspace:Raycast(PrimaryPart.Position, Vector3.new(-0, -5, -0), RaycastParams_new_ret);

    return v6 and (v6.Instance:HasTag("PlantArea") and v6.Instance:GetAttribute("Site")) and true or false;
end;

local function GetHoldToPlantMessage() -- Line: 122
    -- upvalues: UserInputService (copy), ReplicatedStorage (copy)
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        return "Keep holding the <b>Shoot</b> button until the bomb is planted";
    end;

    local ActionKeyText = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips).GetActionKeyText("Fire");

    return not ActionKeyText and "Keep holding the fire button until the bomb is planted" or `Keep holding <b>{ActionKeyText}</b> until the bomb is planted`;
end;

local function NotifyPlantCancelled(p7: string?) -- Line: 135
    -- upvalues: IsTutorialMode (copy), UserInputService (copy), ReplicatedStorage (copy), CharacterResolver (copy), u3 (ref), Router (copy)
    local v8 = nil;
    local v9;

    if p7 == nil and IsTutorialMode() then
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            v9 = "Keep holding the <b>Shoot</b> button until the bomb is planted";
        else
            local ActionKeyText = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips).GetActionKeyText("Fire");
            v9 = not ActionKeyText and "Keep holding the fire button until the bomb is planted" or `Keep holding <b>{ActionKeyText}</b> until the bomb is planted`;
        end;
    else
        v9 = p7 == "LeftPlantArea" and CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) and "Stay on the ground inside the bombsite until the bomb is planted" or v8;
    end;

    if not v9 or os.clock() - u3 < 2 then
        return;
    end;

    u3 = os.clock();
    Router.broadcastRouter("CreateNotification", "Plant Cancelled", v9, 3);
end;

local function NotifyPlantOffSite() -- Line: 150
    -- upvalues: CharacterResolver (copy), IsTutorialMode (copy), u3 (ref), RuntimeKinematics (copy), Router (copy)
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if not (IsTutorialMode() and CharacterResolver.isAliveCharacter(LocalCharacter)) then
        return;
    end;

    if os.clock() - u3 < 2 then
        return;
    end;

    u3 = os.clock();
    local v10 = RuntimeKinematics.isOnGround(LocalCharacter) and "Plant the bomb at the bombsite" or "Stand on the ground inside the bombsite to plant the bomb";
    Router.broadcastRouter("CreateNotification", "Can\'t Plant Here", v10, 3);
end;

function u1.stopAllAnimations(p11) -- Line: 168
    if not (p11.CharacterAnimator and (p11.Viewmodel and p11.Viewmodel.Animation)) then
        return;
    end;

    for i, v in pairs(p11.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p11.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p11.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p11.Viewmodel.Animation:stop(i);
        end;
    end;

    p11.Viewmodel.Animation:stopSounds();
end;

function u1.reload(p12) -- Line: 188
end;

function u1.shoot(u13) -- Line: 192
    -- upvalues: PlayerCanPlantC4 (copy), NotifyPlantOffSite (copy), ReplicateCharacterAction (copy), Remotes (copy), Router (copy)
    if u13.IsPlanting then
        return;
    end;

    local v14 = tick();

    if v14 - u13.PlantStartedTick < 0.5 then
        return;
    end;

    u13.Janitor:Remove("BombAnimationEnded");

    if not PlayerCanPlantC4() then
        NotifyPlantOffSite();

        return;
    end;

    u13.IsInspecting = false;
    u13.IsPlanting = true;
    u13.PlantStartedTick = v14;
    u13:stopAllAnimations();
    ReplicateCharacterAction("Use");
    local v15 = u13.Viewmodel.Animation:play("Use");
    u13.CharacterAnimator:play("Use");
    Remotes.C4.Start.Send(u13.Identifier);
    Router.broadcastRouter("Plant Bomb");
    u13.Janitor:Add(v15.Ended:Connect(function() -- Line: 224
        -- upvalues: u13 (copy), PlayerCanPlantC4 (ref), Remotes (ref), Router (ref)
        if u13.IsPlanting then
            if PlayerCanPlantC4() then
                Remotes.C4.Planted.Send(u13.Identifier);
                u13.IsPlanting = false;
            end;

            Router.broadcastRouter("Cancel Bomb Plant");
        end;
    end), "Disconnect", "BombAnimationEnded");
end;

function u1.cancel(p16: any, p17: string?) -- Line: 238
    -- upvalues: ReplicateCharacterAction (copy), Remotes (copy), Router (copy), NotifyPlantCancelled (copy)
    if not p16.IsPlanting then
        return;
    end;

    p16.Viewmodel.Model.Weapon.Interactive.SurfaceGui.TextLabel.Text = "*******";
    p16.IsPlanting = false;
    p16:stopAllAnimations();
    ReplicateCharacterAction("Cancel Plant");
    Remotes.C4.Cancel.Send(p16.Identifier);
    Router.broadcastRouter("Cancel Bomb Plant");
    p16.Janitor:Remove("BombAnimationEnded");
    NotifyPlantCancelled(p17);
end;

function u1.inspect(u18) -- Line: 260
    -- upvalues: ReplicateCharacterAction (copy)
    if u18.IsInspecting or u18.IsPlanting then
        return;
    end;

    u18.IsInspecting = true;
    u18:stopAllAnimations();
    local v19 = u18.Viewmodel.Animation:play("Inspect");
    ReplicateCharacterAction("Inspect");
    task.delay(v19.Length, function() -- Line: 271
        -- upvalues: u18 (copy)
        u18.IsInspecting = false;
    end);
end;

function u1.drop(p20) -- Line: 278
    -- upvalues: GameState (copy), IsTutorialMode (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy), workspace_CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or (GameState.GetState() == "Warmup" or (IsTutorialMode() or (p20.IsPlanting or not p20.Properties.Droppable))) then
        return false;
    end;

    p20:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
        Direction = workspace_CurrentCamera.CFrame.LookVector,
        Identifier = p20.Identifier
    });

    return true;
end;

function u1.equip(p21) -- Line: 300
    -- upvalues: u2 (ref)
    p21.Viewmodel.Animation:stopAnimations();
    p21.CharacterAnimator:stopAnimations();
    p21.CharacterAnimator:play("Idle");
    p21.CharacterAnimator:play("Equip");
    p21.Viewmodel:equip(false);
    u2 = p21;
end;

function u1.unequip(p22) -- Line: 311
    -- upvalues: u2 (ref)
    if p22.IsPlanting then
        p22:cancel("Unequipped");
    end;

    p22.CharacterAnimator:stopAnimations();
    p22.Viewmodel:unequip();

    if u2 and u2 == p22 then
        u2 = nil;
    end;
end;

function u1.new(p23: userdata, p24: string, p25: string, p26: number, p27: string, p28: string, p29: number, p30: any, p31: any, p32: string?, p33: any, p34: table, p35: table) -- Line: 325
    -- upvalues: WeaponComponent (copy), u1 (copy), RunServiceController (copy), PlayerCanPlantC4 (copy)
    local v36 = WeaponComponent.new(p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34);
    local u37 = setmetatable(v36, u1);
    u37.IsInspecting = false;
    u37.IsPlanting = false;
    u37.PlantStartedTick = 0;
    u37.Janitor:Add(RunServiceController.BindToHeartbeat(`Components.C4.{p24}.PlantValidation`, function(p38: number) -- Line: 351
        -- upvalues: u37 (copy), PlayerCanPlantC4 (ref)
        if u37.IsPlanting and not PlayerCanPlantC4() then
            u37:cancel("LeftPlantArea");
        end;
    end));

    return u37;
end;

function u1.destroy(p39) -- Line: 365
    -- upvalues: u2 (ref), WeaponComponent (copy)
    if p39.IsDestroyed then
        return;
    end;

    p39.IsDestroyed = true;

    if p39.IsPlanting then
        p39:cancel("Destroyed");
    end;

    if u2 and u2 == p39 then
        u2 = nil;
    end;

    if p39.Janitor then
        p39.Janitor:Destroy();
        p39.Janitor = nil;
    end;

    p39.PlantStartedTick = nil;
    p39.IsInspecting = nil;
    p39.IsPlanting = nil;
    WeaponComponent.destroy(p39);
end;

Remotes.C4.ForceCancel.Listen(function() -- Line: 396
    -- upvalues: u2 (ref)
    if u2 and u2.IsPlanting then
        u2:cancel("Server");
    end;
end);

return u1;