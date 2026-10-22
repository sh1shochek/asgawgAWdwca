-- ReplicatedStorage.Components.Melee
-- Script path: ReplicatedStorage.Components.Melee
-- Decompile time: 11.28 ms

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
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local HordeProtocol = require(ReplicatedStorage.Components.Common.HordeProtocol);
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

local function isPlayer(p2: userdata) -- Line: 94
    -- upvalues: CharacterResolver (copy)
    return CharacterResolver.isPlayerCharacter(p2 and p2:FindFirstAncestorOfClass("Model") or nil);
end;

local function cancelThreadField(p3: any, p4: string) -- Line: 100
    local v5 = p3[p4];

    if v5 then
        task.cancel(v5);
        p3[p4] = nil;
    end;
end;

local function isCurrentEquipped(p6: string) -- Line: 110
    -- upvalues: HttpService (copy), LocalPlayer (copy)
    return HttpService:JSONDecode(LocalPlayer:GetAttribute("CurrentEquipped") or "[]").Identifier == p6;
end;

local function isBackStab(p7: userdata, p8: userdata) -- Line: 116
    -- upvalues: CharacterResolver (copy)
    local RootPart = CharacterResolver.getRootPart(p7);
    local RootPart2 = CharacterResolver.getRootPart(p8);

    if RootPart and RootPart2 then
        local v9 = RootPart2.CFrame.LookVector:Dot((RootPart.Position - RootPart2.Position).Unit);
        local math_acos_ret = math.acos(v9);

        return math.deg(math_acos_ret) > 100;
    end;
end;

local function getBotVictimKey(p10: userdata) -- Line: 129
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

local function getHordeServerPart(p14: userdata) -- Line: 145
    -- upvalues: HordeProtocol (copy)
    local v15 = p14:FindFirstAncestorOfClass("Model");
    local v16;

    if v15 then
        v16 = v15:GetAttribute(HordeProtocol.ID_ATTRIBUTE);
    else
        v16 = nil;
    end;

    if typeof(v16) ~= "number" then
        return nil;
    end;

    local v17 = workspace:FindFirstChild(HordeProtocol.HITBOX_FOLDER);
    local v18;

    if v17 then
        v18 = v17:FindFirstChild(HordeProtocol.modelName(v16));
    else
        v18 = nil;
    end;

    if not v18 then
        return nil;
    end;

    local Head = v15:FindFirstChild("Head");
    local v19;

    if p14.Name == "Head" or p14.Name == "Helmet" then
        v19 = true;
    elseif Head == nil then
        v19 = false;
    else
        v19 = p14:IsDescendantOf(Head);
    end;

    local v20 = v18:FindFirstChild(v19 and "Head" or "Torso");

    if v20 and v20:IsA("BasePart") then
        return v20;
    end;

    return nil;
end;

local function scheduleInspectEnd(u21: any, p22: number) -- Line: 166
    u21.InspectDelayThread = task.delay(p22, function() -- Line: 167
        -- upvalues: u21 (copy)
        if not u21.IsDestroyed then
            u21.InspectDelayThread = nil;
            u21.IsInspecting = false;
        end;
    end);
end;

local function resetActionState(p23) -- Line: 177
    p23.IsInspectFadingOut = false;
    p23.IsInspecting = false;
    p23.IsShooting = false;
    p23.IsFireHeld = false;
end;

function u1.stopAllAnimations(p24) -- Line: 187
    if not (p24.CharacterAnimator and (p24.Viewmodel and p24.Viewmodel.Animation)) then
        return;
    end;

    p24.Viewmodel.Animation:cancelCrossfade();

    for i, v in pairs(p24.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p24.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p24.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p24.Viewmodel.Animation:stop(i);
        end;
    end;
end;

function u1.reload(p25) -- Line: 207
    if p25.IsInspecting or p25.IsInspectFadingOut then
        p25:cancelInspect(0.25);
    end;
end;

function u1.shoot(u26: any, p27: boolean?) -- Line: 216
    -- upvalues: CharacterResolver (copy), WeaponTimings (copy), SurvivalDowned (copy), Router (copy), SoundController (copy), GetRayIgnore (copy), workspace_CurrentCamera (copy), getHordeServerPart (copy), getBotVictimKey (copy), CreateImpact (copy), CreateBloodSplatter (copy), isBackStab (copy), BreakGlass (copy), CreateMarker (copy), Remotes (copy), ReplicateCharacterAction (copy), HapticsController (copy), HttpService (copy), LocalPlayer (copy), InputController (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(u26.Player);

    if tick() - u26.WeaponEquippedTick <= WeaponTimings.MELEE_EQUIP_LOCKOUT or not (PlayerCharacter and (CharacterResolver.isAliveCharacter(PlayerCharacter) and not SurvivalDowned.AreHandsBusy(u26.Player))) then
        return;
    end;

    if not u26.Properties.FireRate or u26.IsShooting then
        return;
    end;

    if u26.IsInspecting or u26.IsInspectFadingOut then
        u26:cancelInspect(0.25);
    end;

    u26:stopAllAnimations();
    u26.IsInspecting = false;
    u26.IsInspectFadingOut = false;
    u26.IsShooting = true;
    Router.broadcastRouter("Cancel Sprint");
    Router.broadcastRouter("UpdatePlayerNoiseCone", "Melee", PlayerCharacter.PrimaryPart.Position, SoundController.GetMeleeRange(u26.Name), nil);
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = GetRayIgnore();
    RaycastParams_new_ret.IgnoreWater = true;
    local v28 = workspace_CurrentCamera.CFrame.LookVector * u26.Properties.Range;
    local Position = workspace_CurrentCamera.CFrame.Position;
    local v29 = workspace:Raycast(Position, v28, RaycastParams_new_ret) or workspace:Spherecast(Position, 1.5, v28, RaycastParams_new_ret);
    local v30 = p27 and "Heavy Swing" or `Swing{math.random(1, 2)}`;

    if v29 then
        local Instance = v29.Instance;
        local v31 = getHordeServerPart(Instance);
        local v32 = v31 or Instance;
        local PlayerFromInstance = CharacterResolver.getPlayerFromInstance(v32);
        local v33;

        if PlayerFromInstance == nil then
            v33 = getBotVictimKey(v32);
        else
            v33 = nil;
        end;

        local Position2 = v29.Position;
        local Material = v29.Material;
        local Normal = v29.Normal;

        if v31 ~= nil then
            CreateImpact(Instance, "Blood Splatter", Position2, Normal, false, true, true);
            CreateBloodSplatter(Position2, workspace_CurrentCamera.CFrame.LookVector);
            local v34 = Instance:FindFirstAncestorOfClass("Model");
            v30 = p27 and (v34 and isBackStab(PlayerCharacter, v34)) and "BackStab" or v30;
        else
            local isPlayerCharacter = CharacterResolver.isPlayerCharacter;
            local v35;

            if v32 then
                v35 = v32:FindFirstAncestorOfClass("Model") or nil;
            else
                v35 = nil;
            end;

            if isPlayerCharacter(v35) then
                local ImpactMaterial = CharacterResolver.getImpactMaterial(v32, "Blood Splatter");
                CreateImpact(v32, ImpactMaterial, Position2, Normal, false, true, true);

                if ImpactMaterial == "Blood Splatter" then
                    CreateBloodSplatter(Position2, workspace_CurrentCamera.CFrame.LookVector);
                end;

                v30 = p27 and isBackStab(CharacterResolver.getLocalCharacter(), (v32:FindFirstAncestorOfClass("Model"))) and "BackStab" or v30;
            else
                local Parent = v32.Parent;
                CreateImpact(v32, Material.Name, Position2, Normal, false, true, true);

                if Parent and Parent:HasTag("BreakableGlass") then
                    BreakGlass(v32, Position2, v28.Unit);
                elseif not v32:HasTag("BreakableGlass") then
                    CreateMarker(v32, "Melee", Position2, Normal);
                end;
            end;
        end;

        local Send = Remotes.Melee.MeleeAttack.Send;
        local v36 = {
            Direction = workspace_CurrentCamera.CFrame.LookVector * u26.Properties.Range,
            Material = v29.Material.Name,
            Distance = v29.Distance
        };
        local v37;

        if PlayerFromInstance == nil and v33 == nil then
            v37 = v32;
        else
            v37 = nil;
        end;

        v36.Instance = v37;
        local v38;

        if PlayerFromInstance == nil then
            v38 = v33;
        else
            v38 = PlayerFromInstance.UserId;
        end;

        v36.VictimUserId = v38;
        local v39;

        if PlayerFromInstance == nil and v33 == nil then
            v39 = nil;
        else
            v39 = v32.Name;
        end;

        v36.HitPartName = v39;
        v36.Position = v29.Position;
        v36.Normal = v29.Normal;
        v36.MeleeAttack = v30;
        v36.Identifier = u26.Identifier;
        Send(v36);
    end;

    ReplicateCharacterAction(v30);
    u26.Viewmodel.Animation:play(v30);
    HapticsController.vibrate(Enum.VibrationMotor.Small, 1.15, 0.2);
    u26.CharacterAnimator:play((v30 == "Swing1" or v30 == "Swing") and "Swing" or v30);
    task.delay(u26.Properties.FireRate * (p27 and 2.05 or 1), function() -- Line: 328
        -- upvalues: u26 (copy), HttpService (ref), LocalPlayer (ref), InputController (ref)
        if not u26.IsDestroyed then
            u26.IsShooting = false;

            if u26.Identifier ~= HttpService:JSONDecode(LocalPlayer:GetAttribute("CurrentEquipped") or "[]").Identifier then
                return;
            end;

            local v40 = InputController.isActionPressed("Fire", { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }) or u26.IsFireHeld;
            local v41 = InputController.isActionPressed("Secondary Fire", { Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2 });

            if v40 or v41 then
                u26:shoot(v41);
            end;
        end;
    end);
end;

function u1.releaseFireInput(p42) -- Line: 353
    p42.IsFireHeld = false;
end;

function u1.cancelInspect(u43: any, p44: number?, p45: number?) -- Line: 359
    if not (u43.IsInspecting or u43.IsInspectFadingOut) then
        return;
    end;

    local InspectDelayThread = u43.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u43.InspectDelayThread = nil;
    end;

    local u46 = p44 or 1.2;
    u43.IsInspectFadingOut = true;
    u43.IsInspecting = false;
    u43.Viewmodel.Animation:markInspectCancel();
    local CancelDelayThread = u43.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        u43.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = u43.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        u43.FadeCompleteThread = nil;
    end;

    u43.CancelDelayThread = task.delay(p45 or 0.3, function() -- Line: 380
        -- upvalues: u43 (copy), u46 (copy)
        if u43.IsDestroyed then
            return;
        end;

        if not u43.IsInspectFadingOut then
            return;
        end;

        u43.Viewmodel.Animation:crossfadeTo("Idle", u46);
        u43.FadeCompleteThread = task.delay(u46, function() -- Line: 392
            -- upvalues: u43 (ref)
            if not u43.IsDestroyed then
                u43.FadeCompleteThread = nil;
                u43.IsInspectFadingOut = false;
            end;
        end);
    end);
end;

function u1.inspect(u47) -- Line: 403
    -- upvalues: ReplicateCharacterAction (copy)
    if u47.IsShooting then
        return;
    end;

    if u47.IsInspecting and not u47.IsInspectFadingOut then
        return;
    end;

    local v48 = u47.IsInspectFadingOut == true;

    if v48 then
        u47.IsInspectFadingOut = false;
        local CancelDelayThread = u47.CancelDelayThread;

        if CancelDelayThread then
            task.cancel(CancelDelayThread);
            u47.CancelDelayThread = nil;
        end;

        local FadeCompleteThread = u47.FadeCompleteThread;

        if FadeCompleteThread then
            task.cancel(FadeCompleteThread);
            u47.FadeCompleteThread = nil;
        end;

        u47.Viewmodel.Animation:cancelCrossfade();
    end;

    u47.IsInspecting = true;
    u47.IsShooting = false;
    local InspectDelayThread = u47.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u47.InspectDelayThread = nil;
    end;

    local v49 = u47.Viewmodel.Animation:pickInspectVariant();

    if v48 then
        if not u47.Viewmodel.Animation:crossfadeRestart(v49, 0.25) then
            u47:stopAllAnimations();
            u47.Viewmodel.Animation:play(v49);
        end;

        ReplicateCharacterAction("Inspect");
        local Animation = u47.Viewmodel.Animation:getAnimation(v49);

        if Animation then
            u47.InspectDelayThread = task.delay(Animation.Length, function() -- Line: 167
                -- upvalues: u47 (copy)
                if not u47.IsDestroyed then
                    u47.InspectDelayThread = nil;
                    u47.IsInspecting = false;
                end;
            end);
        end;

        return;
    end;

    u47:stopAllAnimations();
    local v50 = u47.Viewmodel.Animation:play(v49);
    ReplicateCharacterAction("Inspect");
    u47.InspectDelayThread = task.delay(v50.Length, function() -- Line: 167
        -- upvalues: u47 (copy)
        if not u47.IsDestroyed then
            u47.InspectDelayThread = nil;
            u47.IsInspecting = false;
        end;
    end);
end;

function u1.drop(p51) -- Line: 452
    -- upvalues: GameState (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy), workspace_CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or (GameState.GetState() == "Warmup" or workspace:GetAttribute("VIPKnifeDropEnabled") ~= true) then
        return false;
    end;

    p51:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
        Direction = workspace_CurrentCamera.CFrame.LookVector,
        Identifier = p51.Identifier
    });

    return true;
end;

function u1.equip(p52) -- Line: 474
    p52.Viewmodel.Animation:stopAnimations();
    p52.CharacterAnimator:stopAnimations();
    p52.CharacterAnimator:play("Idle");
    p52.CharacterAnimator:play("Equip");
    p52.WeaponEquippedTick = tick();
    p52.Viewmodel:equip(false);
    p52.IsInspectFadingOut = false;
    p52.IsInspecting = false;
    p52.IsShooting = false;
    p52.IsFireHeld = false;
end;

function u1.unequip(p53) -- Line: 486
    p53.CharacterAnimator:stopAnimations();
    p53.Viewmodel:unequip();
    p53.IsInspectFadingOut = false;
    p53.IsInspecting = false;
    p53.IsShooting = false;
    p53.IsFireHeld = false;
end;

function u1.new(p54: userdata, p55: string, p56: string, p57: number, p58: string, p59: string, p60: number, p61: any, p62: any, p63: string?, p64: any, p65: table, p66: table?) -- Line: 495
    -- upvalues: WeaponComponent (copy), u1 (copy)
    local v67 = WeaponComponent.new(p54, p55, p56, p57, p58, p59, p60, p61, p62, p63, p64, p65);
    local v68 = setmetatable(v67, u1);
    v68.IsInspectFadingOut = false;
    v68.IsInspecting = false;
    v68.IsShooting = false;
    v68.IsFireHeld = false;
    v68.AlternativeSwitchTick = 0;
    v68.WeaponEquippedTick = 0;

    return v68;
end;

function u1.destroy(p69) -- Line: 542
    -- upvalues: WeaponComponent (copy)
    if p69.IsDestroyed then
        return;
    end;

    p69.IsDestroyed = true;
    local InspectDelayThread = p69.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        p69.InspectDelayThread = nil;
    end;

    local CancelDelayThread = p69.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        p69.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = p69.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        p69.FadeCompleteThread = nil;
    end;

    if p69.Janitor then
        p69.Janitor:Destroy();
        p69.Janitor = nil;
    end;

    p69.IsInspectFadingOut = nil;
    p69.IsInspecting = nil;
    p69.IsShooting = nil;
    p69.IsFireHeld = nil;
    p69.AlternativeSwitchTick = nil;
    p69.WeaponEquippedTick = nil;
    WeaponComponent.destroy(p69);
end;

return u1;