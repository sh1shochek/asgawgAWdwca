-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController);
local SoundController = require(ReplicatedStorage.Controllers.SoundController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction);
local WeaponTimings = require(ReplicatedStorage.Components.Common.WeaponTimings);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CreateBloodSplatter = require(ReplicatedStorage.Components.Common.VFXLibary.CreateBloodSplatter);
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker);
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact);
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass);
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local LocalPlayer = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;

local function isPlayer(p2: userdata) -- Line: 91
    -- upvalues: CharacterResolver (copy)
    return CharacterResolver.isPlayerCharacter(p2 and p2:FindFirstAncestorOfClass("Model") or nil);
end;

local function cancelThreadField(p3: any, p4: string) -- Line: 97
    local v5 = p3[p4];

    if v5 then
        task.cancel(v5);
        p3[p4] = nil;
    end;
end;

local function isCurrentEquipped(p6: string) -- Line: 107
    -- upvalues: HttpService (copy), LocalPlayer (copy)
    return HttpService:JSONDecode(LocalPlayer:GetAttribute("CurrentEquipped") or "[]").Identifier == p6;
end;

local function isBackStab(p7: userdata, p8: userdata) -- Line: 113
    -- upvalues: CharacterResolver (copy)
    local RootPart = CharacterResolver.getRootPart(p7);
    local RootPart2 = CharacterResolver.getRootPart(p8);

    if RootPart and RootPart2 then
        local v9 = RootPart2.CFrame.LookVector:Dot((RootPart.Position - RootPart2.Position).Unit);
        local math_acos_ret = math.acos(v9);

        return math.deg(math_acos_ret) > 100;
    end;
end;

local function getBotVictimKey(p10: userdata) -- Line: 126
    -- upvalues: ReplicatedStorage (copy)
    local v11 = p10:FindFirstAncestorOfClass("Model");

    while v11 ~= nil and v11:GetAttribute("Bot") ~= true do
        v11 = v11:FindFirstAncestorOfClass("Model");
    end;

    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");
    local v12;

    if v11 == nil or Combatants == nil then
        v12 = nil;
    else
        v12 = Combatants:FindFirstChild((tostring(v11:GetAttribute("CombatantId"))));
    end;

    local v13;

    if v12 == nil then
        v13 = nil;
    else
        v13 = v12:GetAttribute("UserId");
    end;

    if typeof(v13) == "number" then
        return v13;
    end;

    return nil;
end;

local function scheduleInspectEnd(u14: any, p15: number) -- Line: 141
    u14.InspectDelayThread = task.delay(p15, function() -- Line: 142
        -- upvalues: u14 (copy)
        if not u14.IsDestroyed then
            u14.InspectDelayThread = nil;
            u14.IsInspecting = false;
        end;
    end);
end;

local function resetActionState(p16) -- Line: 152
    p16.IsInspectFadingOut = false;
    p16.IsInspecting = false;
    p16.IsShooting = false;
    p16.IsFireHeld = false;
end;

function u1.stopAllAnimations(p17) -- Line: 162
    if not (p17.CharacterAnimator and (p17.Viewmodel and p17.Viewmodel.Animation)) then
        return;
    end;

    p17.Viewmodel.Animation:cancelCrossfade();

    for i, v in pairs(p17.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p17.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p17.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p17.Viewmodel.Animation:stop(i);
        end;
    end;
end;

function u1.reload(p18) -- Line: 182
    if p18.IsInspecting or p18.IsInspectFadingOut then
        p18:cancelInspect(0.25);
    end;
end;

function u1.shoot(u19: any, p20: boolean?) -- Line: 191
    -- upvalues: CharacterResolver (copy), WeaponTimings (copy), Router (copy), SoundController (copy), GetRayIgnore (copy), workspace_CurrentCamera (copy), getBotVictimKey (copy), CreateImpact (copy), CreateBloodSplatter (copy), isBackStab (copy), BreakGlass (copy), CreateMarker (copy), Remotes (copy), ReplicateCharacterAction (copy), HapticsController (copy), HttpService (copy), LocalPlayer (copy), InputController (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(u19.Player);

    if tick() - u19.WeaponEquippedTick <= WeaponTimings.MELEE_EQUIP_LOCKOUT or not (PlayerCharacter and CharacterResolver.isAliveCharacter(PlayerCharacter)) then
        return;
    end;

    if not u19.Properties.FireRate or u19.IsShooting then
        return;
    end;

    if u19.IsInspecting or u19.IsInspectFadingOut then
        u19:cancelInspect(0.25);
    end;

    u19:stopAllAnimations();
    u19.IsInspecting = false;
    u19.IsInspectFadingOut = false;
    u19.IsShooting = true;
    Router.broadcastRouter("UpdatePlayerNoiseCone", "Melee", PlayerCharacter.PrimaryPart.Position, SoundController.GetMeleeRange(u19.Name), nil);
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = GetRayIgnore();
    RaycastParams_new_ret.IgnoreWater = true;
    local v21 = workspace_CurrentCamera.CFrame.LookVector * u19.Properties.Range;
    local Position = workspace_CurrentCamera.CFrame.Position;
    local v22 = workspace:Raycast(Position, v21, RaycastParams_new_ret) or workspace:Spherecast(Position, 1.5, v21, RaycastParams_new_ret);
    local v23 = p20 and "Heavy Swing" or `Swing{math.random(1, 2)}`;

    if v22 then
        local Instance = v22.Instance;
        local PlayerFromInstance = CharacterResolver.getPlayerFromInstance(Instance);
        local v24;

        if PlayerFromInstance == nil then
            v24 = getBotVictimKey(Instance);
        else
            v24 = nil;
        end;

        local Position2 = v22.Position;
        local Material = v22.Material;
        local Normal = v22.Normal;
        local isPlayerCharacter = CharacterResolver.isPlayerCharacter;
        local v25;

        if Instance then
            v25 = Instance:FindFirstAncestorOfClass("Model") or nil;
        else
            v25 = nil;
        end;

        if isPlayerCharacter(v25) then
            local ImpactMaterial = CharacterResolver.getImpactMaterial(Instance, "Blood Splatter");
            CreateImpact(Instance, ImpactMaterial, Position2, Normal, false, true, true);

            if ImpactMaterial == "Blood Splatter" then
                CreateBloodSplatter(Position2, workspace_CurrentCamera.CFrame.LookVector);
            end;

            v23 = p20 and isBackStab(CharacterResolver.getLocalCharacter(), (Instance:FindFirstAncestorOfClass("Model"))) and "BackStab" or v23;
        else
            local Parent = Instance.Parent;
            CreateImpact(Instance, Material.Name, Position2, Normal, false, true, true);

            if Parent and Parent:HasTag("BreakableGlass") then
                BreakGlass(Instance, Position2, v21.Unit);
            elseif not Instance:HasTag("BreakableGlass") then
                CreateMarker(Instance, "Melee", Position2, Normal);
            end;
        end;

        local Send = Remotes.Melee.MeleeAttack.Send;
        local v26 = {
            Direction = workspace_CurrentCamera.CFrame.LookVector * u19.Properties.Range,
            Material = v22.Material.Name,
            Distance = v22.Distance
        };
        local v27;

        if PlayerFromInstance == nil and v24 == nil then
            v27 = Instance;
        else
            v27 = nil;
        end;

        v26.Instance = v27;
        local v28;

        if PlayerFromInstance == nil then
            v28 = v24;
        else
            v28 = PlayerFromInstance.UserId;
        end;

        v26.VictimUserId = v28;
        local v29;

        if PlayerFromInstance == nil and v24 == nil then
            v29 = nil;
        else
            v29 = Instance.Name;
        end;

        v26.HitPartName = v29;
        v26.Position = v22.Position;
        v26.Normal = v22.Normal;
        v26.MeleeAttack = v23;
        v26.Identifier = u19.Identifier;
        Send(v26);
    end;

    ReplicateCharacterAction(v23);
    u19.Viewmodel.Animation:play(v23);
    HapticsController.vibrate(Enum.VibrationMotor.Small, 1.15, 0.2);
    u19.CharacterAnimator:play((v23 == "Swing1" or v23 == "Swing") and "Swing" or v23);
    task.delay(u19.Properties.FireRate * (p20 and 2.05 or 1), function() -- Line: 289
        -- upvalues: u19 (copy), HttpService (ref), LocalPlayer (ref), InputController (ref)
        if not u19.IsDestroyed then
            u19.IsShooting = false;

            if u19.Identifier ~= HttpService:JSONDecode(LocalPlayer:GetAttribute("CurrentEquipped") or "[]").Identifier then
                return;
            end;

            local v30 = InputController.isActionPressed("Fire", { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }) or u19.IsFireHeld;
            local v31 = InputController.isActionPressed("Secondary Fire", { Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2 });

            if v30 or v31 then
                u19:shoot(v31);
            end;
        end;
    end);
end;

function u1.cancelInspect(u32: any, p33: number?, p34: number?) -- Line: 313
    if not (u32.IsInspecting or u32.IsInspectFadingOut) then
        return;
    end;

    local InspectDelayThread = u32.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u32.InspectDelayThread = nil;
    end;

    local u35 = p33 or 1.2;
    u32.IsInspectFadingOut = true;
    u32.IsInspecting = false;
    u32.Viewmodel.Animation:markInspectCancel();
    local CancelDelayThread = u32.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        u32.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = u32.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        u32.FadeCompleteThread = nil;
    end;

    u32.CancelDelayThread = task.delay(p34 or 0.3, function() -- Line: 334
        -- upvalues: u32 (copy), u35 (copy)
        if u32.IsDestroyed then
            return;
        end;

        if not u32.IsInspectFadingOut then
            return;
        end;

        u32.Viewmodel.Animation:crossfadeTo("Idle", u35);
        u32.FadeCompleteThread = task.delay(u35, function() -- Line: 346
            -- upvalues: u32 (ref)
            if not u32.IsDestroyed then
                u32.FadeCompleteThread = nil;
                u32.IsInspectFadingOut = false;
            end;
        end);
    end);
end;

function u1.inspect(u36) -- Line: 357
    -- upvalues: ReplicateCharacterAction (copy)
    if u36.IsShooting then
        return;
    end;

    if u36.IsInspecting and not u36.IsInspectFadingOut then
        return;
    end;

    local v37 = u36.IsInspectFadingOut == true;

    if v37 then
        u36.IsInspectFadingOut = false;
        local CancelDelayThread = u36.CancelDelayThread;

        if CancelDelayThread then
            task.cancel(CancelDelayThread);
            u36.CancelDelayThread = nil;
        end;

        local FadeCompleteThread = u36.FadeCompleteThread;

        if FadeCompleteThread then
            task.cancel(FadeCompleteThread);
            u36.FadeCompleteThread = nil;
        end;

        u36.Viewmodel.Animation:cancelCrossfade();
    end;

    u36.IsInspecting = true;
    u36.IsShooting = false;
    local InspectDelayThread = u36.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u36.InspectDelayThread = nil;
    end;

    local v38 = u36.Viewmodel.Animation:pickInspectVariant();

    if v37 then
        if not u36.Viewmodel.Animation:crossfadeRestart(v38, 0.25) then
            u36:stopAllAnimations();
            u36.Viewmodel.Animation:play(v38);
        end;

        ReplicateCharacterAction("Inspect");
        local Animation = u36.Viewmodel.Animation:getAnimation(v38);

        if Animation then
            u36.InspectDelayThread = task.delay(Animation.Length, function() -- Line: 142
                -- upvalues: u36 (copy)
                if not u36.IsDestroyed then
                    u36.InspectDelayThread = nil;
                    u36.IsInspecting = false;
                end;
            end);
        end;

        return;
    end;

    u36:stopAllAnimations();
    local v39 = u36.Viewmodel.Animation:play(v38);
    ReplicateCharacterAction("Inspect");
    u36.InspectDelayThread = task.delay(v39.Length, function() -- Line: 142
        -- upvalues: u36 (copy)
        if not u36.IsDestroyed then
            u36.InspectDelayThread = nil;
            u36.IsInspecting = false;
        end;
    end);
end;

function u1.drop(p40) -- Line: 406
    -- upvalues: GameState (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy), workspace_CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or (GameState.GetState() == "Warmup" or workspace:GetAttribute("VIPKnifeDropEnabled") ~= true) then
        return false;
    end;

    p40:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
        Direction = workspace_CurrentCamera.CFrame.LookVector,
        Identifier = p40.Identifier
    });

    return true;
end;

function u1.equip(p41) -- Line: 428
    p41.Viewmodel.Animation:stopAnimations();
    p41.CharacterAnimator:stopAnimations();
    p41.CharacterAnimator:play("Idle");
    p41.CharacterAnimator:play("Equip");
    p41.WeaponEquippedTick = tick();
    p41.Viewmodel:equip(false);
    p41.IsInspectFadingOut = false;
    p41.IsInspecting = false;
    p41.IsShooting = false;
    p41.IsFireHeld = false;
end;

function u1.unequip(p42) -- Line: 440
    p42.CharacterAnimator:stopAnimations();
    p42.Viewmodel:unequip();
    p42.IsInspectFadingOut = false;
    p42.IsInspecting = false;
    p42.IsShooting = false;
    p42.IsFireHeld = false;
end;

function u1.new(p43: userdata, p44: string, p45: string, p46: number, p47: string, p48: string, p49: number, p50: any, p51: any, p52: string?, p53: any, p54: table, p55: table?) -- Line: 449
    -- upvalues: WeaponComponent (copy), u1 (copy)
    local v56 = WeaponComponent.new(p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54);
    local v57 = setmetatable(v56, u1);
    v57.IsInspectFadingOut = false;
    v57.IsInspecting = false;
    v57.IsShooting = false;
    v57.IsFireHeld = false;
    v57.AlternativeSwitchTick = 0;
    v57.WeaponEquippedTick = 0;

    return v57;
end;

function u1.destroy(p58) -- Line: 496
    -- upvalues: WeaponComponent (copy)
    if p58.IsDestroyed then
        return;
    end;

    p58.IsDestroyed = true;
    local InspectDelayThread = p58.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        p58.InspectDelayThread = nil;
    end;

    local CancelDelayThread = p58.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        p58.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = p58.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        p58.FadeCompleteThread = nil;
    end;

    if p58.Janitor then
        p58.Janitor:Destroy();
        p58.Janitor = nil;
    end;

    p58.IsInspectFadingOut = nil;
    p58.IsInspecting = nil;
    p58.IsShooting = nil;
    p58.IsFireHeld = nil;
    p58.AlternativeSwitchTick = nil;
    p58.WeaponEquippedTick = nil;
    WeaponComponent.destroy(p58);
end;

return u1;