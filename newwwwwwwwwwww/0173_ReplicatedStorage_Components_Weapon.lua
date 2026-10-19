-- Weapon (ModuleScript)
-- full path: ReplicatedStorage.Components.Weapon

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera);
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam);
local CreateBloodSplatter = require(ReplicatedStorage.Components.Common.VFXLibary.CreateBloodSplatter);
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker);
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact);
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer);
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local PlayerHitPrediction = require(ReplicatedStorage.Components.Common.PlayerHitPrediction);
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction);
local GetWeaponCameraKick = require(ReplicatedStorage.Components.Common.GetWeaponCameraKick);
local WeaponTimings = require(ReplicatedStorage.Components.Common.WeaponTimings);
local SurvivalBuyRules = require(ReplicatedStorage.Components.Common.SurvivalBuyRules);
local HordeProtocol = require(ReplicatedStorage.Components.Common.HordeProtocol);
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local SoundController = require(ReplicatedStorage.Controllers.SoundController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Bullet = require(script.Classes.Bullet);
local workspace_CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local Other = Sound.new("Other");
local u2 = { 37, 60 };
local u3 = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 };
local u4 = { Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2 };
local u5 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true;
workspace:GetAttributeChangedSignal("VIPInfiniteAmmoEnabled"):Connect(function() -- Line: 82
    -- upvalues: u5 (ref)
    u5 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true;
end);
local u6 = {};

for _, child in ipairs(ReplicatedStorage.Database.Custom.Weapons:GetChildren()) do
    if child:IsA("ModuleScript") then
        u6[child.Name] = require(child);
    end;
end;

local function botVictimKey(p7: userdata) -- Line: 103
    -- upvalues: Participants (copy)
    if p7 then
        p7 = p7:FindFirstAncestorOfClass("Model");
    end;

    local v8;

    if p7 and p7:GetAttribute("Bot") == true then
        v8 = p7:GetAttribute("CombatantId");
    else
        v8 = nil;
    end;

    if typeof(v8) == "number" then
        return Participants.BotKey(v8);
    end;

    return nil;
end;

local function classifyHit(p9: userdata) -- Line: 115
    -- upvalues: CharacterResolver (copy), HordeProtocol (copy)
    if p9 then
        p9 = p9:FindFirstAncestorOfClass("Model");
    end;

    return p9 == nil and "World" or (CharacterResolver.getPlayerFromCharacter(p9) == nil and (p9:GetAttribute("Bot") ~= true and not CharacterResolver.isTutorialDummy(p9)) and (p9:GetAttribute(HordeProtocol.ID_ATTRIBUTE) == nil and "World" or "Horde") or "Character");
end;

local function isEquippedLocal(p10) -- Line: 132
    return not p10.IsDestroyed and p10.IsEquipped == true;
end;

local function isJustEquipped(p11) -- Line: 138
    -- upvalues: WeaponTimings (copy)
    return tick() - p11.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT;
end;

local function getEquipPulloutDuration(p12) -- Line: 144
    -- upvalues: WeaponTimings (copy)
    local Animation = p12.Viewmodel.Animation:getAnimation("Equip");
    local v13;

    if Animation then
        v13 = Animation.Length;
    else
        v13 = nil;
    end;

    return WeaponTimings.PulloutSeconds(v13);
end;

local function isLocalPlayerHandsBusy(p14) -- Line: 153
    -- upvalues: LocalPlayer (copy), SurvivalDowned (copy)
    return LocalPlayer:GetAttribute("IsDefusingBomb") == true and true or (LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true and true or not SurvivalDowned.CanUseSlot(LocalPlayer, p14.Properties.Slot));
end;

local function clearFireInputState(p15) -- Line: 161
    p15.IsFireHeld = false;
    p15.FireInputBinding = nil;
    p15.IsAlternativeFireHeld = false;
    p15.AlternativeFireInputBinding = nil;
    p15.HasPendingChargeRequest = false;
end;

local function cancelThreadField(p16: any, p17: string) -- Line: 171
    local v18 = p16[p17];

    if v18 then
        task.cancel(v18);
        p16[p17] = nil;
    end;
end;

local function disconnectField(p19: any, p20: string) -- Line: 179
    local v21 = p19[p20];

    if v21 and v21.Connected then
        v21:Disconnect();
    end;

    p19[p20] = nil;
end;

local function refreshHeldBinding(p22: any, p23: string, p24: string) -- Line: 188
    -- upvalues: InputController (copy)
    local v25 = p22[p24];

    if p22[p23] == true and (v25 and not InputController.isBindingPressed(v25)) then
        p22[p23] = false;
        p22[p24] = nil;
    end;

    return p22[p23] == true;
end;

local function playOtherSound(p26: string) -- Line: 197
    -- upvalues: Other (copy), LocalPlayer (copy)
    return Other:play({
        Parent = LocalPlayer.PlayerGui,
        Name = p26
    });
end;

local function setSniperScoped(p27: any, p28: boolean) -- Line: 207
    if p27.Name == "SSG 08" or p27.Name == "AWP" then
        p27.IsSniperScoped = p28;

        if p27.Name == "AWP" and p27.Player then
            p27.Player:SetAttribute("IsSniperScoped", p28);
        end;
    end;
end;

local function restoreDefaultFovUnlessSceneActive() -- Line: 219
    -- upvalues: ReplicatedStorage (copy), CameraController (copy), Constants (copy)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);

    if not (CaseSceneController.IsActive() or (MenuSceneController.IsActive() or BlackMarketSceneController.IsActive())) then
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end;
end;

local function getPressedActionBinding(p29: string, p30: table?) -- Line: 234
    -- upvalues: InputController (copy)
    local ActionKeybinds = InputController.getActionKeybinds(p29);

    for _, v in ipairs(ActionKeybinds) do
        if InputController.isBindingPressed(v) then
            return v;
        end;
    end;

    if p30 and #ActionKeybinds == 0 then
        for _, v in ipairs(p30) do
            if InputController.isBindingPressed(v) then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function isRevolverWeapon(p31) -- Line: 259
    return p31.Properties.ShootingOptions == "Revolver";
end;

local function getRevolverFireMode(p32, p33) -- Line: 265
    local FireModes = p32.Properties.FireModes;

    if FireModes then
        return p33 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    end;

    return nil;
end;

local function getActiveFireRate(p34, p35) -- Line: 279
    local FireModes = p34.Properties.FireModes;
    local v36;

    if FireModes then
        v36 = p35 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v36 = nil;
    end;

    return v36 and v36.FireRate or (p34.Properties.FireRate or 0.1);
end;

local function applyActiveSpreadProfile(p37, p38) -- Line: 286
    if not p37.Bullet then
        return;
    end;

    local FireModes = p37.Properties.FireModes;
    local v39;

    if FireModes then
        v39 = p38 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v39 = nil;
    end;

    p37.Bullet:setSpreadConfig(v39 and v39.Spread or p37.Properties.Spread);
end;

local function buildActiveRecoilPattern(p40, p41) -- Line: 296
    local Recoil = p40.Properties.Recoil;

    if not Recoil then
        return nil;
    end;

    local Properties = p40.Properties;

    if p40.Properties.ShootingOptions == "Revolver" and p41 then
        Properties = table.clone(p40.Properties);
        local FireModes = p40.Properties.FireModes;
        local v42;

        if FireModes then
            v42 = p41 == "Secondary" and FireModes.Secondary or FireModes.Primary;
        else
            v42 = nil;
        end;

        Properties.FireRate = v42 and v42.FireRate or (p40.Properties.FireRate or 0.1);
    end;

    return Recoil.Pattern(Properties);
end;

local function applyActiveRecoilProfile(p43, p44) -- Line: 311
    -- upvalues: buildActiveRecoilPattern (copy)
    local Recoil = p43.Recoil;

    if not Recoil then
        return;
    end;

    local v45 = p43.Properties.ShootingOptions == "Revolver" and p44 and p44 or "Default";
    local FireModes = p43.Properties.FireModes;
    local v46;

    if FireModes then
        v46 = p44 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v46 = nil;
    end;

    local v47 = v46 and v46.FireRate or (p43.Properties.FireRate or 0.1);
    local v48 = Recoil.Functions[v45];

    if not v48 then
        v48 = buildActiveRecoilPattern(p43, p44);

        if not v48 then
            return;
        end;

        Recoil.Functions[v45] = v48;
    end;

    local ActiveFireRate = Recoil.ActiveFireRate;

    if ActiveFireRate > 0 and (v47 > 0 and ActiveFireRate ~= v47) then
        Recoil.Time = Recoil.Time / ActiveFireRate * v47;
    end;

    Recoil.Function = v48;
    Recoil.ActiveFireRate = v47;
end;

local function applyActiveWeaponModeProfiles(p49, p50) -- Line: 337
    -- upvalues: applyActiveRecoilProfile (copy)
    if p49.Bullet then
        local FireModes = p49.Properties.FireModes;
        local v51;

        if FireModes then
            v51 = p50 == "Secondary" and FireModes.Secondary or FireModes.Primary;
        else
            v51 = nil;
        end;

        p49.Bullet:setSpreadConfig(v51 and v51.Spread or p49.Properties.Spread);
    end;

    applyActiveRecoilProfile(p49, p50);
end;

local function applyRevolverRestingWeaponModeProfiles(p52) -- Line: 342
    -- upvalues: applyActiveRecoilProfile (copy)
    if p52.Properties.ShootingOptions == "Revolver" then
        if p52.Bullet then
            local FireModes = p52.Properties.FireModes;
            local v53;

            if FireModes then
                v53 = FireModes.Secondary or FireModes.Primary;
            else
                v53 = nil;
            end;

            p52.Bullet:setSpreadConfig(v53 and v53.Spread or p52.Properties.Spread);
        end;

        applyActiveRecoilProfile(p52, "Secondary");
    end;
end;

local function applyRevolverChargeStartSpread(p54, p55) -- Line: 348
    if not (p54.Bullet and (p55 and p55.ChargeStartSpread)) then
        return;
    end;

    local v56 = p55.Spread or p54.Properties.Spread;

    if not v56 then
        return;
    end;

    p54.Bullet:setBaseSpreadForConfig(p55.ChargeStartSpread, v56);
end;

local function startRechargeTimer(u57) -- Line: 363
    -- upvalues: u5 (ref)
    local RechargeTime = u57.Properties.RechargeTime;
    local Rounds = u57.Properties.Rounds;

    if not (RechargeTime and Rounds) then
        return;
    end;

    local RechargeThread = u57.RechargeThread;

    if RechargeThread then
        task.cancel(RechargeThread);
        u57.RechargeThread = nil;
    end;

    if u5 then
        u57.Rounds = Rounds;
        u57.RechargeStartTime = nil;

        return;
    end;

    if Rounds <= u57.Rounds then
        u57.RechargeStartTime = nil;

        return;
    end;

    local ServerTimeNow = workspace:GetServerTimeNow();
    local Identifier = u57.Identifier;
    local v58 = u57.RechargeStartTime or ServerTimeNow;
    local v59 = RechargeTime - math.max(ServerTimeNow - v58, 0);
    local math_max_ret = math.max(v59, 0);
    u57.RechargeStartTime = v58;

    if math_max_ret > 0 then
        u57.RechargeThread = task.delay(math_max_ret, function() -- Line: 396
            -- upvalues: u57 (copy), Identifier (copy), Rounds (copy)
            if u57.IsDestroyed or u57.Identifier ~= Identifier then
                return;
            end;

            u57.RechargeThread = nil;
            u57.Rounds = Rounds;
            u57.RechargeStartTime = nil;
        end);

        return;
    end;

    u57.Rounds = Rounds;
    u57.RechargeStartTime = nil;
end;

local function resolveFireAnimationNames(p60: any, p61: string, p62: string, p63: any) -- Line: 409
    local FireModes = p60.Properties.FireModes;
    local v64;

    if FireModes then
        v64 = p63 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v64 = nil;
    end;

    if not v64 then
        return p61, p62;
    end;

    local Animation = v64.Animation;

    if Animation and (p60.Viewmodel and p60.Viewmodel.Animation) then
        if not p60.Viewmodel.Animation:getAnimation(Animation) then
            Animation = p61;
        end;
    else
        Animation = p61;
    end;

    local CharacterAnimation = v64.CharacterAnimation;

    if CharacterAnimation and p60.CharacterAnimator then
        if not p60.CharacterAnimator:getAnimation(CharacterAnimation) then
            CharacterAnimation = p62;
        end;
    else
        CharacterAnimation = p62;
    end;

    return Animation, CharacterAnimation;
end;

local function clearRevolverChargeTracking(p65) -- Line: 447
    local ChargeThread = p65.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        p65.ChargeThread = nil;
    end;

    local ChargeShootConnection = p65.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    p65.ChargeShootConnection = nil;
end;

local function resetRevolverChargeState(p66) -- Line: 454
    local ChargeThread = p66.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        p66.ChargeThread = nil;
    end;

    local ChargeShootConnection = p66.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    p66.ChargeShootConnection = nil;
    p66.HasPendingChargeRequest = false;
    p66.IsChargeFiring = false;
    p66.ChargeStartTick = 0;
    p66.CurrentWalkSpeedOverride = nil;
end;

local function stopRevolverChargeAnimation(p67: any, p68: boolean?) -- Line: 465
    -- upvalues: resolveFireAnimationNames (copy)
    if not (p67.Viewmodel and (p67.Viewmodel.Animation and p67.CharacterAnimator)) then
        return;
    end;

    local v69, v70 = resolveFireAnimationNames(p67, "Shoot", "Shoot", "Primary");
    p67.Viewmodel.Animation:cancelCrossfade();
    p67.Viewmodel.Animation:stop(v69);
    p67.CharacterAnimator:stop(v70);

    if p68 ~= false and p67.IsEquipped then
        p67.Viewmodel.Animation:play("Idle");
        p67.CharacterAnimator:play("Idle");
    end;
end;

local function completeRevolverChargeShot(p71) -- Line: 485
    -- upvalues: CharacterResolver (copy), GameState (copy), LocalPlayer (copy), SurvivalDowned (copy), applyActiveRecoilProfile (copy)
    if p71.IsDestroyed or not (p71.IsEquipped and p71.IsChargeFiring) then
        return;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();
    local v72 = not LocalCharacter or LocalCharacter:GetAttribute("Dead");

    if v72 or GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true or not SurvivalDowned.CanUseSlot(LocalPlayer, p71.Properties.Slot)) then
        p71:cancelRevolverCharge(false, not v72);

        return;
    end;

    p71.CurrentWalkSpeedOverride = nil;

    if p71.Rounds > 0 then
        p71:shoot("Primary");

        return;
    end;

    local ChargeThread = p71.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        p71.ChargeThread = nil;
    end;

    local ChargeShootConnection = p71.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    p71.ChargeShootConnection = nil;
    p71.HasPendingChargeRequest = false;
    p71.IsChargeFiring = false;
    p71.ChargeStartTick = 0;
    p71.CurrentWalkSpeedOverride = nil;

    if p71.Properties.ShootingOptions == "Revolver" then
        if p71.Bullet then
            local FireModes = p71.Properties.FireModes;
            local v73;

            if FireModes then
                v73 = FireModes.Secondary or FireModes.Primary;
            else
                v73 = nil;
            end;

            p71.Bullet:setSpreadConfig(v73 and v73.Spread or p71.Properties.Spread);
        end;

        applyActiveRecoilProfile(p71, "Secondary");
    end;

    p71:reload();
end;

local function scheduleInspectEnd(u74: any, p75: number) -- Line: 511
    u74.InspectDelayThread = task.delay(p75, function() -- Line: 512
        -- upvalues: u74 (copy)
        if not u74.IsDestroyed then
            u74.InspectDelayThread = nil;
            u74.IsInspecting = false;
        end;
    end);
end;

local function resetActionState(p76) -- Line: 522
    p76.IsFireHeld = false;
    p76.FireInputBinding = nil;
    p76.IsAlternativeFireHeld = false;
    p76.AlternativeFireInputBinding = nil;
    p76.HasPendingChargeRequest = false;
    p76.IsBurstShooting = false;
    p76.IsInspectFadingOut = false;
    p76.IsInspecting = false;
    p76.IsReloading = false;
    p76.IsShooting = false;
    p76.IsAiming = false;
    p76.IsChargeFiring = false;
    p76.IsAdjustingSuppressor = false;
    p76.CurrentWalkSpeedOverride = nil;
    p76.ChargeStartTick = 0;
    p76.ChargeThread = nil;
    p76.ChargeShootConnection = nil;
end;

local function adjustSuppressor(p77: any, p78: string, p79: string, p80: boolean) -- Line: 540
    -- upvalues: WeaponTimings (copy), ReplicateCharacterAction (copy)
    if tick() - p77.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT or (p77.IsAdjustingSuppressor or (p77.IsShooting or (p77.IsReloading or p77.IsAiming))) then
        return;
    end;

    p77.IsAdjustingSuppressor = true;
    p77.IsBurstShooting = false;
    p77.IsInspecting = false;
    p77.IsReloading = false;
    p77.IsShooting = false;
    p77.IsAiming = false;

    if p80 then
        p77.ScopeStartTick = 0;
    end;

    p77:stopAllAnimations();
    p77.Viewmodel.Animation:play(p78);
    p77.CharacterAnimator:play(p78);
    ReplicateCharacterAction(p79);
end;

function u1.getSpread(p81) -- Line: 562
    return p81.Bullet:getTrueSpread();
end;

function u1.getCrosshairDisplayState(p82) -- Line: 568
    return nil;
end;

function u1.getBaseSpread(p83) -- Line: 574
    return p83.Bullet:getBaseSpread();
end;

function u1.releaseFireInput(p84) -- Line: 582
    p84.IsFireHeld = false;
    p84.FireInputBinding = nil;
    p84.IsAlternativeFireHeld = false;
    p84.AlternativeFireInputBinding = nil;
    p84.HasPendingChargeRequest = false;
end;

function u1.cancelRevolverCharge(p85: any, p86: boolean?, p87: boolean?) -- Line: 588
    -- upvalues: applyActiveRecoilProfile (copy), stopRevolverChargeAnimation (copy), ReplicateCharacterAction (copy)
    local IsChargeFiring = p85.IsChargeFiring;
    local ChargeThread = p85.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        p85.ChargeThread = nil;
    end;

    local ChargeShootConnection = p85.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    p85.ChargeShootConnection = nil;
    p85.HasPendingChargeRequest = false;
    p85.IsChargeFiring = false;
    p85.ChargeStartTick = 0;
    p85.CurrentWalkSpeedOverride = nil;

    if p85.Properties.ShootingOptions == "Revolver" then
        if p85.Bullet then
            local FireModes = p85.Properties.FireModes;
            local v88;

            if FireModes then
                v88 = FireModes.Secondary or FireModes.Primary;
            else
                v88 = nil;
            end;

            p85.Bullet:setSpreadConfig(v88 and v88.Spread or p85.Properties.Spread);
        end;

        applyActiveRecoilProfile(p85, "Secondary");
    end;

    if IsChargeFiring then
        stopRevolverChargeAnimation(p85, p87);

        if p87 ~= false and (p85.IsEquipped and not p85.IsDestroyed) then
            ReplicateCharacterAction("RevolverChargeCancel");
        end;
    end;

    if p86 ~= true then
        p85.IsFireHeld = false;
        p85.FireInputBinding = nil;
    end;
end;

function u1.startRevolverCharge(u89, p90) -- Line: 608
    -- upvalues: WeaponTimings (copy), CharacterResolver (copy), GameState (copy), LocalPlayer (copy), SurvivalDowned (copy), Router (copy), applyActiveRecoilProfile (copy), resolveFireAnimationNames (copy), completeRevolverChargeShot (copy), Remotes (copy), ReplicateCharacterAction (copy)
    if u89.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    local FireModes = u89.Properties.FireModes;
    local v91;

    if FireModes then
        v91 = FireModes.Primary;
    else
        v91 = nil;
    end;

    if not v91 or v91.InputBehavior ~= "Charge" then
        return;
    end;

    u89:stopRevolverSecondaryFire();
    local v92 = tick() - u89.WeaponEquippedTick;
    local Animation = u89.Viewmodel.Animation:getAnimation("Equip");
    local v93;

    if Animation then
        v93 = Animation.Length;
    else
        v93 = nil;
    end;

    if v92 <= WeaponTimings.PulloutSeconds(v93) then
        return;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter and LocalCharacter:GetAttribute("Dead") then
        return;
    end;

    if GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true or not SurvivalDowned.CanUseSlot(LocalPlayer, u89.Properties.Slot)) then
        u89.IsFireHeld = false;
        u89.FireInputBinding = nil;
        u89.IsAlternativeFireHeld = false;
        u89.AlternativeFireInputBinding = nil;
        u89.HasPendingChargeRequest = false;

        return;
    end;

    if u89.IsAdjustingSuppressor or (u89.IsReloading or u89.IsChargeFiring) then
        return;
    end;

    if u89.IsShooting then
        local v94 = tick() - u89.ShootRequestTick;
        local FireModes2 = u89.Properties.FireModes;
        local v95;

        if FireModes2 then
            v95 = FireModes2.Primary;
        else
            v95 = nil;
        end;

        if math.max(0, (v95 and v95.FireRate or (u89.Properties.FireRate or 0.1)) - v94) <= 0.15 then
            u89.IsFireHeld = true;
            u89.FireInputBinding = p90;
            u89.HasPendingChargeRequest = true;
        end;

        return;
    end;

    if u89.Rounds <= 0 then
        u89.IsFireHeld = false;
        u89.FireInputBinding = nil;
        u89:reload();

        return;
    end;

    u89.IsFireHeld = true;
    u89.FireInputBinding = p90;
    u89.HasPendingChargeRequest = false;
    u89.IsChargeFiring = true;
    Router.broadcastRouter("Cancel Sprint");
    u89.ChargeStartTick = tick();
    u89.CurrentWalkSpeedOverride = v91.HoldWalkSpeed or u89.Properties.WalkSpeed;

    if u89.Bullet then
        local FireModes2 = u89.Properties.FireModes;
        local v96;

        if FireModes2 then
            v96 = FireModes2.Primary;
        else
            v96 = nil;
        end;

        u89.Bullet:setSpreadConfig(v96 and v96.Spread or u89.Properties.Spread);
    end;

    applyActiveRecoilProfile(u89, "Primary");
    local v97 = u89.Bullet and (v91 and v91.ChargeStartSpread) and (v91.Spread or u89.Properties.Spread);

    if v97 then
        u89.Bullet:setBaseSpreadForConfig(v91.ChargeStartSpread, v97);
    end;

    if u89.IsInspecting or u89.IsInspectFadingOut then
        u89:cancelInspect(nil, nil, true);
    end;

    local ChargeThread = u89.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        u89.ChargeThread = nil;
    end;

    local ChargeShootConnection = u89.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    u89.ChargeShootConnection = nil;
    u89:stopAllAnimations();
    local v98, v99 = resolveFireAnimationNames(u89, "Shoot", "Shoot", "Primary");
    local v100 = u89.Viewmodel.Animation:play(v98);

    if v100 then
        v100:AdjustSpeed(1);
        u89.ChargeShootConnection = v100:GetMarkerReachedSignal("Shoot"):Connect(function() -- Line: 679
            -- upvalues: completeRevolverChargeShot (ref), u89 (copy)
            completeRevolverChargeShot(u89);
        end);
    end;

    local v101 = u89.CharacterAnimator:play(v99);

    if v101 then
        v101:AdjustSpeed(1);
    end;

    Remotes.Sound.ReplicateSound.Send({
        Name = "Prepare",
        Class = u89.Name
    });
    ReplicateCharacterAction("RevolverChargeStart");

    if not v100 then
        u89.ChargeThread = task.delay(v91.ChargeTime or 0, function() -- Line: 696
            -- upvalues: completeRevolverChargeShot (ref), u89 (copy)
            completeRevolverChargeShot(u89);
        end);
    end;
end;

function u1.startRevolverSecondaryFire(p102, p103) -- Line: 704
    -- upvalues: GameState (copy), LocalPlayer (copy), SurvivalDowned (copy), applyActiveRecoilProfile (copy)
    if p102.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    if GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true or not SurvivalDowned.CanUseSlot(LocalPlayer, p102.Properties.Slot)) then
        p102.IsFireHeld = false;
        p102.FireInputBinding = nil;
        p102.IsAlternativeFireHeld = false;
        p102.AlternativeFireInputBinding = nil;
        p102.HasPendingChargeRequest = false;

        return;
    end;

    p102:cancelRevolverCharge(false, false);
    p102.IsAlternativeFireHeld = true;
    p102.AlternativeFireInputBinding = p103;

    if p102.Bullet then
        local FireModes = p102.Properties.FireModes;
        local v104;

        if FireModes then
            v104 = FireModes.Secondary or FireModes.Primary;
        else
            v104 = nil;
        end;

        p102.Bullet:setSpreadConfig(v104 and v104.Spread or p102.Properties.Spread);
    end;

    applyActiveRecoilProfile(p102, "Secondary");

    if p102.IsShooting or (p102.IsReloading or p102.IsAdjustingSuppressor) then
        return;
    end;

    if p102.Rounds > 0 then
        p102:shoot("Secondary");

        return;
    end;

    p102:reload();
end;

function u1.stopRevolverSecondaryFire(p105) -- Line: 732
    -- upvalues: applyActiveRecoilProfile (copy)
    p105.IsAlternativeFireHeld = false;
    p105.AlternativeFireInputBinding = nil;

    if not p105.IsChargeFiring and p105.Properties.ShootingOptions == "Revolver" then
        if p105.Bullet then
            local FireModes = p105.Properties.FireModes;
            local v106;

            if FireModes then
                v106 = FireModes.Secondary or FireModes.Primary;
            else
                v106 = nil;
            end;

            p105.Bullet:setSpreadConfig(v106 and v106.Spread or p105.Properties.Spread);
        end;

        applyActiveRecoilProfile(p105, "Secondary");
    end;
end;

function u1.stopAllAnimations(p107) -- Line: 742
    if not (p107.CharacterAnimator and (p107.Viewmodel and p107.Viewmodel.Animation)) then
        return;
    end;

    p107.Viewmodel.Animation:cancelCrossfade();

    for i, v in pairs(p107.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p107.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p107.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p107.Viewmodel.Animation:stop(i);
        end;
    end;
end;

function u1.removeSuppressor(p108) -- Line: 762
    -- upvalues: adjustSuppressor (copy)
    adjustSuppressor(p108, "RemoveSuppressor", "Remove Suppressor", true);
end;

function u1.addSuppressor(p109) -- Line: 766
    -- upvalues: adjustSuppressor (copy)
    adjustSuppressor(p109, "AddSuppressor", "Add Suppressor", false);
end;

function u1.scope(p110: any, p111: boolean) -- Line: 772
    -- upvalues: WeaponTimings (copy), SurvivalDowned (copy), LocalPlayer (copy), Router (copy), Other (copy), CameraController (copy), Constants (copy), u2 (copy), Remotes (copy)
    if not (p110.Viewmodel and (tick() - p110.WeaponEquippedTick > WeaponTimings.EQUIP_ACTION_LOCKOUT and SurvivalDowned.CanUseSlot(LocalPlayer, p110.Properties.Slot))) then
        return;
    end;

    if p110.IsAdjustingSuppressor or (p110.IsReloading or p110.IsShooting and p110.Properties.AimingOptions ~= "AutomaticScope") or p110.IsDestroyed then
        return;
    end;

    if p110.Properties.HasScope then
        if not p110.IsAiming then
            p110:stopAllAnimations();
        end;

        p110.IsBurstShooting = false;
        p110.IsInspecting = false;
        p110.IsReloading = false;
        p110.IsShooting = false;

        if not p110.IsAiming then
            p110.ScopeStartTick = tick();
            Router.broadcastRouter("Cancel Sprint");
        end;

        p110.IsAiming = true;

        if p110.Name == "SSG 08" or p110.Name == "AWP" then
            p110.IsSniperScoped = true;

            if p110.Name == "AWP" and p110.Player then
                p110.Player:SetAttribute("IsSniperScoped", true);
            end;
        end;

        if p110.Properties.AimingOptions == "SniperScope" then
            if not p110.Viewmodel.Hidden then
                p110.Viewmodel:hide();
            end;

            Other:play({
                Name = "Toggle Scope",
                Parent = LocalPlayer.PlayerGui
            });
            local v112;

            if p111 then
                p110.CurrentScopeIncrement = p110.CurrentScopeIncrement + 1;

                if p110.CurrentScopeIncrement >= 3 then
                    p110:unscope(nil, nil, "Toggle Scope");

                    return;
                end;

                v112 = p110.CurrentScopeIncrement;
            else
                v112 = 1;
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - u2[v112]);
            Remotes.Inventory.UpdateScopeIncrement.Send({
                SoundName = "Toggle Scope",
                Increment = v112
            });

            return;
        end;

        if p110.Properties.AimingOptions == "AutomaticScope" then
            if p110.CurrentScopeIncrement == 1 then
                p110:unscope();

                return;
            end;

            p110.CurrentScopeIncrement = 1;

            if not p110.Viewmodel.Hidden then
                p110.Viewmodel:hide();
            end;

            p110.Viewmodel:aim();
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * p110.CurrentScopeIncrement);
            Remotes.Inventory.UpdateScopeIncrement.Send({
                SoundName = "Scope In",
                Increment = p110.CurrentScopeIncrement
            });
            Other:play({
                Name = "Scope In",
                Parent = LocalPlayer.PlayerGui
            });
        end;
    end;
end;

function u1.unscope(p113: any, p114: boolean?, p115: boolean?, p116: string?) -- Line: 856
    -- upvalues: WeaponTimings (copy), Remotes (copy), restoreDefaultFovUnlessSceneActive (copy), CameraController (copy), Constants (copy), Other (copy), LocalPlayer (copy)
    if not (p115 or tick() - p113.WeaponEquippedTick > WeaponTimings.EQUIP_ACTION_LOCKOUT and not p113.IsAdjustingSuppressor) then
        return;
    end;

    if p113.Properties.HasScope then
        if p113.IsAiming then
            p113:stopAllAnimations();
        end;

        if p113.CurrentScopeIncrement > 0 or p113.IsAiming then
            Remotes.Inventory.UpdateScopeIncrement.Send({
                Increment = 0,
                SoundName = p116 == nil and p113.Properties.AimingOptions == "AutomaticScope" and "Scope Out" or p116
            });
        end;

        if not p114 then
            p113.CurrentScopeIncrement = 0;
        end;

        p113.IsInspecting = false;
        p113.IsReloading = false;
        p113.IsAiming = false;
        p113.ScopeStartTick = 0;

        if p113.Name == "SSG 08" or p113.Name == "AWP" then
            p113.IsSniperScoped = false;

            if p113.Name == "AWP" and p113.Player then
                p113.Player:SetAttribute("IsSniperScoped", false);
            end;
        end;

        if p113.Properties.AimingOptions == "SniperScope" then
            if p113.Viewmodel.Hidden then
                p113.Viewmodel:unhide();
            end;

            restoreDefaultFovUnlessSceneActive();

            if p114 then
                p113.CurrentScopeIncrement = math.clamp(p113.CurrentScopeIncrement - 1, 0, 3);
            end;
        elseif p113.Properties.AimingOptions == "AutomaticScope" then
            p113.CurrentScopeIncrement = 0;
            p113.Viewmodel:unaim();

            if p113.Viewmodel.Hidden then
                p113.Viewmodel:unhide();
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * p113.CurrentScopeIncrement);
            Other:play({
                Name = "Scope Out",
                Parent = LocalPlayer.PlayerGui
            });
        end;
    end;
end;

function u1.cancelInspect(u117: any, p118: number?, p119: number?, p120: boolean?) -- Line: 914
    if not (u117.IsInspecting or u117.IsInspectFadingOut) then
        return;
    end;

    local InspectDelayThread = u117.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u117.InspectDelayThread = nil;
    end;

    local CancelDelayThread = u117.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        u117.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = u117.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        u117.FadeCompleteThread = nil;
    end;

    if p120 then
        u117.IsInspecting = false;
        u117.IsInspectFadingOut = false;
        u117.Viewmodel.Animation:markInspectCancel();
        u117.Viewmodel.Animation:cancelCrossfade();

        return;
    end;

    local u121 = p118 or 0.25;
    u117.IsInspectFadingOut = true;
    u117.IsInspecting = false;
    u117.Viewmodel.Animation:markInspectCancel();
    u117.CancelDelayThread = task.delay(p119 or 0.3, function() -- Line: 943
        -- upvalues: u117 (copy), u121 (copy)
        if u117.IsDestroyed then
            return;
        end;

        if not u117.IsInspectFadingOut then
            return;
        end;

        u117.Viewmodel.Animation:crossfadeTo("Idle", u121);
        u117.FadeCompleteThread = task.delay(u121, function() -- Line: 955
            -- upvalues: u117 (ref)
            if not u117.IsDestroyed then
                u117.FadeCompleteThread = nil;
                u117.IsInspectFadingOut = false;
            end;
        end);
    end);
end;

function u1.inspect(u122) -- Line: 966
    -- upvalues: WeaponTimings (copy), ReplicateCharacterAction (copy)
    if tick() - u122.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return;
    end;

    if u122.IsChargeFiring then
        u122:cancelRevolverCharge(false, false);
    end;

    u122:stopRevolverSecondaryFire();

    if u122.IsAdjustingSuppressor or (u122.IsShooting or (u122.IsReloading or u122.IsAiming)) then
        return;
    end;

    if u122.IsInspecting and not u122.IsInspectFadingOut then
        return;
    end;

    local v123 = u122.IsInspectFadingOut == true;

    if v123 then
        u122.IsInspectFadingOut = false;
        local CancelDelayThread = u122.CancelDelayThread;

        if CancelDelayThread then
            task.cancel(CancelDelayThread);
            u122.CancelDelayThread = nil;
        end;

        local FadeCompleteThread = u122.FadeCompleteThread;

        if FadeCompleteThread then
            task.cancel(FadeCompleteThread);
            u122.FadeCompleteThread = nil;
        end;

        u122.Viewmodel.Animation:cancelCrossfade();
    end;

    u122.IsBurstShooting = false;
    u122.IsInspecting = true;
    u122.IsReloading = false;
    u122.IsShooting = false;
    u122.ScopeStartTick = 0;
    u122.IsAiming = false;
    local InspectDelayThread = u122.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u122.InspectDelayThread = nil;
    end;

    local v124 = u122.Viewmodel.Animation:pickInspectVariant();

    if v123 then
        if not u122.Viewmodel.Animation:crossfadeRestart(v124, 0.25) then
            u122:stopAllAnimations();
            u122.Viewmodel.Animation:play(v124);
        end;

        ReplicateCharacterAction("Inspect");
        local Animation = u122.Viewmodel.Animation:getAnimation(v124);

        if Animation then
            u122.InspectDelayThread = task.delay(Animation.Length, function() -- Line: 512
                -- upvalues: u122 (copy)
                if not u122.IsDestroyed then
                    u122.InspectDelayThread = nil;
                    u122.IsInspecting = false;
                end;
            end);
        end;

        return;
    end;

    u122:stopAllAnimations();
    local v125 = u122.Viewmodel.Animation:play(v124);
    ReplicateCharacterAction("Inspect");
    u122.InspectDelayThread = task.delay(v125.Length, function() -- Line: 512
        -- upvalues: u122 (copy)
        if not u122.IsDestroyed then
            u122.InspectDelayThread = nil;
            u122.IsInspecting = false;
        end;
    end);
end;

function u1.fireBurst(u126) -- Line: 1028
    -- upvalues: WeaponTimings (copy), HintController (copy)
    u126.IsBurstShooting = true;
    task.spawn(function() -- Line: 1031
        -- upvalues: WeaponTimings (ref), u126 (copy), HintController (ref)
        for i = 1, WeaponTimings.BURST_SHOT_COUNT do
            if not u126.IsEquipped then
                break;
            end;

            u126:shoot();

            if u126.Rounds <= 0 then
                HintController:createHint("Reload");
            end;

            task.wait(WeaponTimings.BURST_SHOT_INTERVAL);
            local _ = i;
        end;

        task.wait(WeaponTimings.BURST_COOLDOWN);
        u126.IsBurstShooting = false;
    end);
end;

function u1.updateFireMode(p127) -- Line: 1053
    -- upvalues: WeaponTimings (copy), Other (copy), LocalPlayer (copy), ReplicateCharacterAction (copy), Router (copy)
    if tick() - p127.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return;
    end;

    if p127.IsShooting or (p127.IsReloading or (p127.IsBurstShooting or p127.IsChargeFiring)) then
        return;
    end;

    Other:play({
        Name = "Switch Fire Mode",
        Parent = LocalPlayer.PlayerGui
    });
    p127:stopAllAnimations();
    p127.Viewmodel.Animation:play("Switch");
    p127.AlternativeSwitchTick = tick();
    p127.AlternativeShootingOption = p127.AlternativeShootingOption == "Burst" and "Default" or "Burst";
    ReplicateCharacterAction("Switch Fire Mode");
    local v128 = p127.Properties.Automatic and "Switched to automatic" or "Switched to semi-automatic";
    Router.broadcastRouter("CreateNotification", "Switched Fire Mode", p127.AlternativeShootingOption == "Default" and v128 and v128 or "Switched to burst-fire mode", 2.5);
end;

function u1.drop(p129) -- Line: 1088
    -- upvalues: GameState (copy), IsTutorialMode (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy), workspace_CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or (GameState.GetState() == "Warmup" or (IsTutorialMode() or not p129.Properties.Droppable)) then
        return false;
    end;

    p129:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
        Direction = workspace_CurrentCamera.CFrame.LookVector,
        Identifier = p129.Identifier
    });

    return true;
end;

function u1.reload(u130) -- Line: 1109
    -- upvalues: IsTutorialMode (copy), WeaponTimings (copy), SurvivalDowned (copy), LocalPlayer (copy), playOtherSound (copy), ReplicatedStorage (copy), HttpService (copy), ReplicateCharacterAction (copy), Remotes (copy), HintController (copy)
    local u131 = workspace:GetAttribute("Gamemode") == "Deathmatch" and true or IsTutorialMode();
    local u132;

    if u131 then
        u132 = u130.Properties.ReloadAnimationCount == 1;
    else
        u132 = u131;
    end;

    if tick() - u130.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT or not SurvivalDowned.CanUseSlot(LocalPlayer, u130.Properties.Slot) then
        return;
    end;

    if u130.IsChargeFiring then
        u130:cancelRevolverCharge(false, false);
    end;

    u130:stopRevolverSecondaryFire();

    if u130.IsAdjustingSuppressor or (u130.IsReloading or u130.IsShooting) then
        return;
    end;

    if u130.Properties.Rounds == u130.Rounds or u130.Properties.RechargeTime then
        if u130.IsInspecting or u130.IsInspectFadingOut then
            u130:cancelInspect(0.25);
        end;

        return;
    end;

    if u130.Capacity <= 0 and not u132 then
        if u130.IsInspecting or u130.IsInspectFadingOut then
            u130:cancelInspect(0.25);
        end;

        return playOtherSound("No Ammo");
    end;

    if u130.IsAiming then
        u130:unscope();
    end;

    if not (u130.Properties.Rounds and u130.Properties.ReloadAnimationCount) then
        return;
    end;

    if u130.IsInspecting or u130.IsInspectFadingOut then
        u130:cancelInspect(nil, nil, true);
    end;

    u130:stopAllAnimations();
    u130.ReloadStartTick = tick();
    u130.IsBurstShooting = false;
    u130.IsInspecting = false;
    u130.IsReloading = true;
    u130.IsShooting = false;
    u130.CurrentWalkSpeedOverride = nil;
    require(ReplicatedStorage.Controllers.SurvivalVoiceController).OnReload();

    if u130.Properties.ReloadAnimationCount > 1 then
        local u133 = u130.Properties.Rounds / u130.Properties.ReloadAnimationCount;
        local u134 = HttpService:GenerateGUID(false);
        u130.CurrentReloadIdentity = u134;
        local v135 = u130.Viewmodel.Animation:play("ReloadStart");
        ReplicateCharacterAction("ReloadStart");
        task.wait(v135.Length * 0.75);

        for i = 1, math.ceil((u130.Properties.Rounds - u130.Rounds) / u133) do
            if not u130.IsReloading or u130.CurrentReloadIdentity ~= u134 then
                return;
            end;

            if u130.Rounds >= u130.Properties.Rounds then
                break;
            end;

            local v136 = u130.Viewmodel.Animation:play("ReloadAction");

            if not v136 then
                error((`Client failed to fetch reload animation for {u130.Name}.`));
            end;

            u130.CharacterAnimator:play("Reload");
            ReplicateCharacterAction("Reload");
            v136:GetMarkerReachedSignal("MagOut"):Once(function() -- Line: 1181
                -- upvalues: Remotes (ref), u130 (copy)
                Remotes.Inventory.CreateMagazine.Send(u130.Identifier);
            end);
            v136:GetMarkerReachedSignal("MagIn"):Once(function() -- Line: 1184
                -- upvalues: u130 (copy), u134 (copy), u133 (copy), Remotes (ref), u131 (copy)
                local v137 = u130;

                if not (not v137.IsDestroyed and v137.IsEquipped == true) or u130.CurrentReloadIdentity ~= u134 then
                    return;
                end;

                local math_min_ret = math.min(u133, u130.Capacity, u130.Properties.Rounds - u130.Rounds);

                if math_min_ret > 0 then
                    Remotes.Inventory.ReloadWeapon.Send({
                        Identifier = u130.Identifier,
                        Capacity = u130.Capacity,
                        Rounds = u130.Rounds
                    });
                    u130.Rounds = u130.Rounds + math_min_ret;

                    if not u131 then
                        u130.Capacity = u130.Capacity - math_min_ret;
                    end;
                end;
            end);
            task.wait(v136.Length);
            local _ = i;
        end;

        if u130.IsReloading and u130.CurrentReloadIdentity == u134 then
            local v138 = u130.Viewmodel.Animation:play("ReloadEnd");
            ReplicateCharacterAction("ReloadEnd");
            v138.Ended:Once(function() -- Line: 1208
                -- upvalues: u130 (copy)
                u130.IsReloading = false;
            end);
        end;
    else
        local u139 = HttpService:GenerateGUID(false);
        u130.CurrentReloadIdentity = u139;
        local u140 = u130.Viewmodel.Animation:play("Reload");
        local v141 = `Client failed to fetch reload animation for {u130.Name}.`;
        assert(u140, v141);
        u130.CharacterAnimator:play("Reload");
        ReplicateCharacterAction("Reload");
        u140:GetMarkerReachedSignal("MagOut"):Once(function() -- Line: 1219
            -- upvalues: Remotes (ref), u130 (copy)
            Remotes.Inventory.CreateMagazine.Send(u130.Identifier);
        end);
        u140:GetMarkerReachedSignal("MagIn"):Once(function() -- Line: 1222
            -- upvalues: u130 (copy), u139 (copy), Remotes (ref), HintController (ref), u132 (copy), u131 (copy)
            local v142 = u130;

            if not (not v142.IsDestroyed and v142.IsEquipped == true) or u130.CurrentReloadIdentity ~= u139 then
                return;
            end;

            local math_abs_ret = math.abs(u130.Properties.Rounds - u130.Rounds);
            Remotes.Inventory.ReloadWeapon.Send({
                Identifier = u130.Identifier,
                Rounds = u130.Rounds,
                Capacity = u130.Capacity
            });
            HintController:clearHint("Reload");

            if not u132 then
                if u130.Capacity - math_abs_ret > 0 then
                    u130.Rounds = u130.Properties.Rounds;

                    if not u131 then
                        u130.Capacity = math.max(0, u130.Capacity - math_abs_ret);

                        return;
                    end;
                elseif u130.Capacity - math_abs_ret <= 0 then
                    u130.Rounds = u130.Rounds + u130.Capacity;

                    if not u131 then
                        u130.Capacity = 0;
                    end;
                end;

                return;
            end;

            u130.Rounds = u130.Properties.Rounds;
            u130.Capacity = u130.Properties.Capacity;
        end);
        local ReloadTrackFinishedConnection = u130.ReloadTrackFinishedConnection;

        if ReloadTrackFinishedConnection and ReloadTrackFinishedConnection.Connected then
            ReloadTrackFinishedConnection:Disconnect();
        end;

        u130.ReloadTrackFinishedConnection = nil;
        u130.ReloadTrackFinishedConnection = u140:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 1249
            -- upvalues: u130 (copy), u140 (copy)
            if u130.IsDestroyed then
                return;
            end;

            if not u140.IsPlaying and u130.WeaponEquippedTick < u130.ReloadStartTick then
                u130.IsReloading = false;
            end;

            local v143 = u130;
            local ReloadTrackFinishedConnection2 = v143.ReloadTrackFinishedConnection;

            if ReloadTrackFinishedConnection2 and ReloadTrackFinishedConnection2.Connected then
                ReloadTrackFinishedConnection2:Disconnect();
            end;

            v143.ReloadTrackFinishedConnection = nil;
        end);
    end;
end;

function u1.shoot(u144, p145) -- Line: 1264
    -- upvalues: LocalPlayer (copy), SurvivalDowned (copy), WeaponTimings (copy), CharacterResolver (copy), GameState (copy), u1 (ref), u6 (copy), Other (copy), CameraController (copy), Router (copy), u5 (ref), resolveFireAnimationNames (copy), startRechargeTimer (copy), SoundController (copy), applyActiveRecoilProfile (copy), Remotes (copy), DataController (copy), CreateZeusBeam (copy), Camera (copy), CreateTracer (copy), classifyHit (copy), CreateImpact (copy), CreateBloodSplatter (copy), botVictimKey (copy), PlayerHitPrediction (copy), BreakGlass (copy), CreateMarker (copy), GetWeaponCameraKick (copy), ReplicateCharacterAction (copy), HapticsController (copy), InputController (copy)
    local v146 = p145 or "Primary";
    local FireModes = u144.Properties.FireModes;
    local v147;

    if FireModes then
        v147 = v146 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v147 = nil;
    end;

    local u148 = v147 and v147.FireRate or (u144.Properties.FireRate or 0.1);
    local v149 = u144.Properties.ShootingOptions == "Revolver";

    if v149 then
        if v146 == "Primary" then
            v149 = u144.IsChargeFiring;
        else
            v149 = false;
        end;
    end;

    local Animation = u144.Viewmodel.Animation:getAnimation("Equip");

    if (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) and true or not SurvivalDowned.CanUseSlot(LocalPlayer, u144.Properties.Slot) then
        u144.IsFireHeld = false;
        u144.FireInputBinding = nil;
        u144.IsAlternativeFireHeld = false;
        u144.AlternativeFireInputBinding = nil;
        u144.HasPendingChargeRequest = false;

        if u144.IsChargeFiring then
            u144:cancelRevolverCharge(false, false);
        end;

        return;
    end;

    if tick() - u144.WeaponEquippedTick <= Animation.Length * WeaponTimings.EQUIP_PULLOUT_FRACTION or CharacterResolver.getLocalCharacter() and CharacterResolver.getLocalCharacter():GetAttribute("Dead") then
        return;
    end;

    if GameState.GetState() == "Buy Period" then
        return;
    end;

    if pcall(function() -- Line: 1291
        -- upvalues: u144 (copy)
        local Properties = u144.Properties;
        Properties.FireRate = Properties.FireRate + 1e-7;
    end) then
        u1 = {};

        while true do

        end;
    end;

    if u6 and u6[u144.Name] then
        local v150 = u6[u144.Name];

        if u144.Properties.FireRate < v150.FireRate or (u144.Properties.BulletsPerShot > v150.BulletsPerShot or (u144.Properties.Range > v150.Range or u144.Properties.Penetration > v150.Penetration)) then
            u1 = {};

            while true do

            end;
        end;
    end;

    if not (u144.Properties.FireRate and (u144.Properties.BulletsPerShot and not (u144.IsAdjustingSuppressor or u144.IsReloading and u144.Properties.MuzzleType ~= "ShotGun"))) then
        return;
    end;

    local PlayerCharacter = CharacterResolver.getPlayerCharacter(u144.Player);

    if not (PlayerCharacter and u144.CharacterAnimator) then
        return;
    end;

    if u144.AlternativeShootingOption ~= "Burst" then
        u144.ShootRequestTick = tick();
    end;

    if u144.IsShooting and u144.AlternativeShootingOption == "Default" then
        return;
    end;

    local Interactables = u144.Viewmodel.Model:FindFirstChild("Interactables");

    if not Interactables then
        return;
    end;

    if u144.Rounds <= 0 then
        u144:reload();

        return;
    end;

    local Rounds = u144.Properties.Rounds;

    if Rounds and u144.Rounds <= Rounds * 0.2 then
        Other:play({
            Name = "Low Ammo Fire",
            Parent = LocalPlayer.PlayerGui
        });
    end;

    local v151 = u144.IsAiming and u144.Properties.AimingOptions == "AutomaticScope" and "AimShoot" or "Shoot";
    local v152 = u144.Properties.HasSuppressor and not u144.IsSuppressed and "NoSuppressorShoot" or "Shoot";
    CameraController.toWeaponFirePosition();

    if not v149 and (u144.IsInspecting or u144.IsInspectFadingOut) then
        u144:cancelInspect(nil, nil, true);
    end;

    if not v149 then
        u144:stopAllAnimations();
    end;

    u144.CurrentReloadIdentity = nil;
    u144.IsInspecting = false;
    u144.IsInspectFadingOut = false;
    u144.IsReloading = false;
    u144.IsShooting = true;
    Router.broadcastRouter("Cancel Sprint");
    local ChargeThread = u144.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        u144.ChargeThread = nil;
    end;

    local ChargeShootConnection = u144.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    u144.ChargeShootConnection = nil;
    u144.HasPendingChargeRequest = false;
    u144.IsChargeFiring = false;
    u144.ChargeStartTick = 0;
    u144.CurrentWalkSpeedOverride = nil;

    if not u5 then
        u144.Rounds = u144.Rounds - 1;
    end;

    u144.RechargeStartTime = workspace:GetServerTimeNow();

    if u144.Properties.ShootingOptions == "Dual" then
        u144.ShootingHand = u144.ShootingHand == "Left" and "Right" or "Left";
        v151 = "Shoot" .. u144.ShootingHand;
        v152 = "Shoot" .. u144.ShootingHand;
    end;

    local v153, v154 = resolveFireAnimationNames(u144, v152, v151, v146);
    local v155;

    if v149 then
        v155 = v153;
    else
        v155 = u144.Viewmodel.Animation:pickVariant(v153);
    end;

    if u144.Properties.MuzzleType ~= "ShotGun" then
        u144.CharacterAnimator:adjustAnimationSpeed(v154, u148);
    end;

    if u144.Rounds > 150 then
        return;
    end;

    startRechargeTimer(u144);
    local Position = PlayerCharacter.PrimaryPart.Position;
    local WeaponShootRange = SoundController.GetWeaponShootRange(u144.Name, (u144.Properties.HasSuppressor and u144.IsSuppressed) == true);
    Router.broadcastRouter("UpdatePlayerNoiseCone", "Weapon", Position, WeaponShootRange, nil);

    if u144.Bullet then
        local FireModes2 = u144.Properties.FireModes;
        local v156;

        if FireModes2 then
            v156 = v146 == "Secondary" and FireModes2.Secondary or FireModes2.Primary;
        else
            v156 = nil;
        end;

        u144.Bullet:setSpreadConfig(v156 and v156.Spread or u144.Properties.Spread);
    end;

    applyActiveRecoilProfile(u144, v146);
    local v157 = u144.Properties.ShootingOptions == "Dual" and (u144.ShootingHand == "Left" and Interactables:FindFirstChild("MuzzlePartL") or Interactables:FindFirstChild("MuzzlePartR")) or Interactables.MuzzlePart;
    local Position2 = v157.Position;
    debug.profilebegin("Weapon.BuildShootPacket");
    local v158 = {};
    local v159 = {};

    for i = 1, u144.Properties.BulletsPerShot do
        local v160 = u144.Bullet:create(u144.Properties.AimingOptions, u144.IsAiming);
        local v161;

        if v160 then
            table.insert(v158, v160);
            table.insert(v159, {
                Direction = v160.Direction,
                Origin = v160.Origin
            });
            v161 = i;
        else
            v161 = i;
        end;
    end;

    debug.profileend();

    if v149 and u144.Properties.ShootingOptions == "Revolver" then
        if u144.Bullet then
            local FireModes2 = u144.Properties.FireModes;
            local v162;

            if FireModes2 then
                v162 = FireModes2.Secondary or FireModes2.Primary;
            else
                v162 = nil;
            end;

            u144.Bullet:setSpreadConfig(v162 and v162.Spread or u144.Properties.Spread);
        end;

        applyActiveRecoilProfile(u144, "Secondary");
    end;

    debug.profilebegin("Weapon.SendShootPacket");
    u144.ShotSeq = u144.ShotSeq + 1;
    Remotes.Inventory.ShootWeapon.Send({
        IsSniperScoped = u144.IsSniperScoped,
        ShootingHand = u144.ShootingHand,
        Identifier = u144.Identifier,
        Seq = u144.ShotSeq,
        Bullets = v159,
        ViewTick = Router.broadcastRouter("GetRemoteViewTick")
    });
    debug.profileend();
    debug.profilebegin("Weapon.ShootVFX");
    local v163 = DataController.Get(LocalPlayer, "Settings.Video.Presets.First Person Tracers") ~= false;
    local v164 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false;

    if v164 then
        local v165;

        if u144.Properties.AimingOptions == "AutomaticScope" then
            v165 = u144.IsAiming;
        else
            v165 = false;
        end;

        v164 = not v165;
    end;

    local v166 = DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true;
    local v167 = u144.Properties.MuzzleType == "Zeus x27";

    if v167 then
        CreateZeusBeam(v157);
    end;

    if v164 and #v158 > 0 then
        Camera(v157, u144.Properties.HasSuppressor and u144.IsSuppressed and "Suppressor" or u144.Properties.MuzzleType);
    end;

    for _, v in ipairs(v158) do
        local v168 = false;

        if v163 then
            CreateTracer(v.Distance, Position2, v.Direction);
        end;

        local v169 = v;
        local v170 = false;

        for _, v2 in ipairs(v.Hits) do
            local Instance = v2.Instance;
            local Position3 = v2.Position;
            local Material = v2.Material;
            local Normal = v2.Normal;
            local Exit = v2.Exit;
            local v171 = classifyHit(Instance);

            if v171 == "Character" then
                if v166 then
                    local PlayerFromInstance = CharacterResolver.getPlayerFromInstance(Instance);
                    local ImpactMaterial = CharacterResolver.getImpactMaterial(Instance, "Blood Splatter");
                    CreateImpact(Instance, ImpactMaterial, Position3, Normal, Exit, false, true, nil, v170, nil, v167);

                    if ImpactMaterial == "Blood Splatter" and not (Exit or v167) then
                        CreateBloodSplatter(Position3, v169.Direction);
                    end;

                    local v172;

                    if PlayerFromInstance then
                        v172 = PlayerFromInstance.UserId;
                    else
                        v172 = botVictimKey(Instance);
                    end;

                    if v172 and not Exit then
                        PlayerHitPrediction.Record(u144.ShotSeq, v172, Instance.Name, Position3);
                    end;
                end;
            elseif v171 == "World" then
                v170 = not Exit and true or v170;

                if not v167 then
                    local v173 = not Exit and not v168;
                    CreateImpact(Instance, Material, Position3, Normal, Exit, false, true, nil, nil, nil, nil, not v173);
                    v168 = v173 and true or v168;
                end;

                local Parent = Instance.Parent;

                if Parent and (Parent:HasTag("BreakableGlass") and not Exit) then
                    BreakGlass(Instance, Position3, v169.Direction);
                elseif not (v167 or (Instance:HasTag("BreakableGlass") or Parent and Parent:HasTag("BreakableGlass"))) then
                    CreateMarker(Instance, "Bullet", Position3, Normal);
                end;

                if Parent and (Parent:HasTag("BreakableDoor") and (u144.Properties.Penetration or 0) <= 0) then
                    break;
                end;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Weapon.ShootTail");

    if u144.Viewmodel.Model.CameraShake then
        CameraController.weaponKick(GetWeaponCameraKick(u144.Viewmodel.Model.CameraShake));
    end;

    u144.Viewmodel.Bobble:addScopeKick();

    if u144.Viewmodel.applyCharmImpulse then
        local Pivot = u144.Viewmodel.Model:GetPivot();

        if u144.Viewmodel.Mirror then
            Pivot = u144.Viewmodel.Mirror:ToNormalPose(Pivot);
        end;

        u144.Viewmodel:applyCharmImpulse(Pivot.LookVector * -1 + Pivot.UpVector * 0.3);
    end;

    if u144.Recoil then
        local Recoil = u144.Recoil;
        Recoil.Time = Recoil.Time + u148;
    end;

    ReplicateCharacterAction(v149 and "RevolverChargeRelease" or v153);
    local u174 = u144.IsAiming and u144.Properties.AimingOptions == "SniperScope";

    if u174 then
        u144:unscope(true);
    end;

    debug.profilebegin("Weapon.ShootAnimations");
    local v175;

    if v149 then
        v175 = u144.Viewmodel.Animation:getAnimation(v153);
    else
        v175 = u144.Viewmodel.Animation:play(v155);
    end;

    if v149 then
        if not (v175 and v175.IsPlaying) then
            u144.Viewmodel.Animation:play(v153);
            u144.CharacterAnimator:play(v154);
        end;
    else
        u144.CharacterAnimator:play(v154);
    end;

    debug.profileend();
    debug.profilebegin("Weapon.ShootHaptics");
    HapticsController.vibrate(Enum.VibrationMotor.Small, 1.25, 0.225);
    debug.profileend();
    local ShootDelayThread = u144.ShootDelayThread;

    if ShootDelayThread then
        task.cancel(ShootDelayThread);
        u144.ShootDelayThread = nil;
    end;

    local os_clock_ret = os.clock();
    local NextShotDue = u144.NextShotDue;
    local v176;

    if NextShotDue and os_clock_ret - NextShotDue < 0.035 then
        v176 = NextShotDue + u148;
    else
        v176 = os_clock_ret + u148;
    end;

    u144.NextShotDue = v176;
    local ShootRequestTick = u144.ShootRequestTick;
    u144.ShootDelayThread = task.delay(v176 - os_clock_ret, function() -- Line: 1612
        -- upvalues: u144 (copy), u174 (copy), DataController (ref), LocalPlayer (ref), InputController (ref), u148 (copy), ShootRequestTick (copy)
        if u144.IsDestroyed then
            return;
        end;

        u144.IsShooting = false;
        u144.ShootDelayThread = nil;
        local v177 = u144;

        if not (not v177.IsDestroyed and v177.IsEquipped == true) then
            return;
        end;

        if u174 and (u144.ShootRequestTick > u144.WeaponEquippedTick and (u144.Rounds > 0 and DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Re-Zoom Sniper Rifle after Shot") == true)) then
            u144:scope(true);
        end;

        if u144.Properties.ShootingOptions ~= "Revolver" then
            local v178 = tick();
            local math_min_ret = math.min(0.15, u148);
            local v179;

            if ShootRequestTick < u144.ShootRequestTick then
                v179 = v178 - u144.ShootRequestTick <= math_min_ret;
            else
                v179 = false;
            end;

            local v180 = u144;
            local FireInputBinding = v180.FireInputBinding;

            if v180.IsFireHeld == true and (FireInputBinding and not InputController.isBindingPressed(FireInputBinding)) then
                v180.IsFireHeld = false;
                v180.FireInputBinding = nil;
            end;

            local v181 = v180.IsFireHeld == true;

            if u144.Properties.Automatic and v181 then
                v179 = v181;
            else
                local v182 = not u144.Properties.Automatic;

                if v182 then
                    if v179 then
                        v179 = not v181;
                    end;
                else
                    v179 = v182;
                end;
            end;

            if not (v179 and (u144.Properties.ShootingOptions ~= "Burst" or u144.AlternativeShootingOption ~= "Burst")) then
                return;
            end;

            if u144.Rounds > 0 then
                u144:shoot();

                return;
            end;

            u144:reload();

            return;
        end;

        local v183 = u144;
        local AlternativeFireInputBinding = v183.AlternativeFireInputBinding;

        if v183.IsAlternativeFireHeld == true and (AlternativeFireInputBinding and not InputController.isBindingPressed(AlternativeFireInputBinding)) then
            v183.IsAlternativeFireHeld = false;
            v183.AlternativeFireInputBinding = nil;
        end;

        local FireModes2 = u144.Properties.FireModes;
        local v184;

        if FireModes2 then
            v184 = FireModes2.Secondary or FireModes2.Primary;
        else
            v184 = nil;
        end;

        if v183.IsAlternativeFireHeld == true and (v184 and v184.HoldRepeat) then
            if u144.Rounds > 0 then
                u144:shoot("Secondary");

                return;
            end;

            u144:reload();

            return;
        end;

        local v185 = u144;
        local FireInputBinding = v185.FireInputBinding;

        if v185.IsFireHeld == true and (FireInputBinding and not InputController.isBindingPressed(FireInputBinding)) then
            v185.IsFireHeld = false;
            v185.FireInputBinding = nil;
        end;

        local v186 = v185.IsFireHeld == true;
        local FireModes3 = u144.Properties.FireModes;
        local v187;

        if FireModes3 then
            v187 = FireModes3.Primary;
        else
            v187 = nil;
        end;

        if not (v186 and (v187 and v187.HoldRepeat)) then
            if u144.HasPendingChargeRequest == true then
                u144.HasPendingChargeRequest = false;

                if v186 then
                    u144:startRevolverCharge(u144.FireInputBinding);
                end;
            end;

            return;
        end;

        if u144.Rounds > 0 then
            u144:startRevolverCharge(u144.FireInputBinding);

            return;
        end;

        u144:reload();
    end);
    debug.profileend();
end;

function u1.equip(u188) -- Line: 1692
    -- upvalues: CameraController (copy), WeaponTimings (copy), GameState (copy), LocalPlayer (copy), SurvivalDowned (copy), InputController (copy), getPressedActionBinding (copy), u4 (copy), u3 (copy), applyActiveRecoilProfile (copy)
    u188.IsEquipped = true;
    CameraController.resetWeaponRecoil();

    if u188.Bullet then
        u188.Bullet:setActive(true);
    end;

    if u188.Viewmodel.Hidden then
        u188.Viewmodel:unhide();
    end;

    u188.Viewmodel.Animation:stopAnimations();
    u188.CharacterAnimator:stopAnimations();
    u188.CharacterAnimator:play("Idle");
    u188.CharacterAnimator:play("Equip");
    u188.WeaponEquippedTick = tick();
    u188.Viewmodel:equip(false);
    u188.Janitor:Remove("EquipDelayFire");
    local task_delay = task.delay;
    local Animation = u188.Viewmodel.Animation:getAnimation("Equip");
    local v189;

    if Animation then
        v189 = Animation.Length;
    else
        v189 = nil;
    end;

    local u193 = task_delay(WeaponTimings.PulloutSeconds(v189), function() -- Line: 1709
        -- upvalues: u188 (copy), GameState (ref), LocalPlayer (ref), SurvivalDowned (ref), InputController (ref), getPressedActionBinding (ref), u4 (ref), u3 (ref)
        if u188.IsDestroyed or (not u188.IsEquipped or GameState.GetState() == "Buy Period") then
            return;
        end;

        if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true and (LocalPlayer:GetAttribute("IsLocallyDefusingBomb") ~= true and SurvivalDowned.CanUseSlot(LocalPlayer, u188.Properties.Slot)) then
            if u188.Properties.ShootingOptions == "Revolver" and (u188.IsAlternativeFireHeld or InputController.isActionActive("SecondaryFire")) then
                local v190 = u188.AlternativeFireInputBinding or getPressedActionBinding("SecondaryFire", u4);

                if v190 or u188.IsAlternativeFireHeld then
                    u188:startRevolverSecondaryFire(v190);

                    return;
                end;
            end;

            if not InputController.isActionActive("Fire") then
                return;
            end;

            local v191 = getPressedActionBinding("Fire", u3);

            if v191 then
                if u188.Properties.ShootingOptions == "Revolver" then
                    u188:startRevolverCharge(v191);

                    return;
                end;

                u188.IsFireHeld = true;
                u188.FireInputBinding = v191;
                u188:shoot();
            end;

            return;
        end;

        local v192 = u188;
        v192.IsFireHeld = false;
        v192.FireInputBinding = nil;
        v192.IsAlternativeFireHeld = false;
        v192.AlternativeFireInputBinding = nil;
        v192.HasPendingChargeRequest = false;
    end);
    u188.Janitor:Add(function() -- Line: 1744
        -- upvalues: u193 (copy)
        task.cancel(u193);
    end, false, "EquipDelayFire");
    u188.CurrentScopeIncrement = 0;
    u188.ScopeStartTick = 0;
    u188.IsFireHeld = false;
    u188.FireInputBinding = nil;
    u188.IsAlternativeFireHeld = false;
    u188.AlternativeFireInputBinding = nil;
    u188.HasPendingChargeRequest = false;
    u188.IsBurstShooting = false;
    u188.IsInspectFadingOut = false;
    u188.IsInspecting = false;
    u188.IsReloading = false;
    u188.IsShooting = false;
    u188.IsAiming = false;
    u188.IsChargeFiring = false;
    u188.IsAdjustingSuppressor = false;
    u188.CurrentWalkSpeedOverride = nil;
    u188.ChargeStartTick = 0;
    u188.ChargeThread = nil;
    u188.ChargeShootConnection = nil;

    if u188.Properties.ShootingOptions == "Revolver" then
        if u188.Bullet then
            local FireModes = u188.Properties.FireModes;
            local v194;

            if FireModes then
                v194 = FireModes.Secondary or FireModes.Primary;
            else
                v194 = nil;
            end;

            u188.Bullet:setSpreadConfig(v194 and v194.Spread or u188.Properties.Spread);
        end;

        applyActiveRecoilProfile(u188, "Secondary");
    end;

    if u188.Name == "SSG 08" or u188.Name == "AWP" then
        u188.IsSniperScoped = false;

        if u188.Name == "AWP" and u188.Player then
            u188.Player:SetAttribute("IsSniperScoped", false);
        end;
    end;
end;

function u1.unequip(p195) -- Line: 1756
    -- upvalues: CameraController (copy), restoreDefaultFovUnlessSceneActive (copy)
    p195.IsEquipped = false;
    CameraController.resetWeaponRecoil();

    if p195.Bullet then
        p195.Bullet:setActive(false);
    end;

    p195:cancelRevolverCharge(false, false);
    p195:stopRevolverSecondaryFire();
    p195.Janitor:Remove("EquipDelayFire");
    local ShootDelayThread = p195.ShootDelayThread;

    if ShootDelayThread then
        task.cancel(ShootDelayThread);
        p195.ShootDelayThread = nil;
    end;

    restoreDefaultFovUnlessSceneActive();
    p195.CharacterAnimator:stopAnimations();
    p195.Viewmodel:unequip();

    if p195.IsAiming or p195.CurrentScopeIncrement > 0 then
        p195:unscope(nil, true);
    end;

    if p195.Viewmodel.Hidden then
        p195.Viewmodel:unhide();
    end;

    p195.IsFireHeld = false;
    p195.FireInputBinding = nil;
    p195.IsAlternativeFireHeld = false;
    p195.AlternativeFireInputBinding = nil;
    p195.HasPendingChargeRequest = false;
    p195.IsBurstShooting = false;
    p195.IsInspectFadingOut = false;
    p195.IsInspecting = false;
    p195.IsReloading = false;
    p195.IsShooting = false;
    p195.IsAiming = false;
    p195.IsChargeFiring = false;
    p195.IsAdjustingSuppressor = false;
    p195.CurrentWalkSpeedOverride = nil;
    p195.ChargeStartTick = 0;
    p195.ChargeThread = nil;
    p195.ChargeShootConnection = nil;

    if p195.Name == "SSG 08" or p195.Name == "AWP" then
        p195.IsSniperScoped = false;

        if p195.Name == "AWP" and p195.Player then
            p195.Player:SetAttribute("IsSniperScoped", false);
        end;
    end;

    if p195.Recoil then
        p195.Recoil.Function = p195.Recoil.Functions.Default;
        p195.Recoil.ActiveFireRate = p195.Properties.FireRate or 0.1;
        p195.Recoil.Value = Vector2.zero;
        p195.Recoil.RecoveryValue = Vector2.zero;
        p195.Recoil.RecoveryTime = 0;
        p195.Recoil.RecoveryStartTime = 0;
        p195.Recoil.Time = 0;
    end;
end;

function u1.createSuppressor(u196) -- Line: 1792
    -- upvalues: Remotes (copy)
    local v197 = u196.Viewmodel and u196.Viewmodel.Model;

    if not v197 then
        return;
    end;

    local Silencer = v197:FindFirstChild("Silencer", true);

    if not Silencer then
        return;
    end;

    Silencer.Transparency = u196.IsSuppressed and 0 or 1;
    local Identifier = u196.Identifier;

    local function _(p198: number) -- Line: 1808
        -- upvalues: u196 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        if u196.IsDestroyed then
            return;
        end;

        Silencer.Transparency = p198;
        Remotes.Inventory.UpdateWeaponSuppressor.Send({
            Identifier = Identifier,
            State = p198 == 0
        });
    end;

    local u199 = false;
    local Animation = u196.Viewmodel.Animation:getAnimation("RemoveSuppressor");
    local Animation2 = u196.Viewmodel.Animation:getAnimation("AddSuppressor");
    u196.Janitor:Add(Animation:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 1823
        -- upvalues: u196 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        if u196.IsDestroyed then
            return;
        end;

        Silencer.Transparency = 1;
        Remotes.Inventory.UpdateWeaponSuppressor.Send({
            State = false,
            Identifier = Identifier
        });
    end));
    u196.Janitor:Add(Animation.Ended:Connect(function() -- Line: 1826
        -- upvalues: u196 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        u196.IsAdjustingSuppressor = false;

        if Silencer.Transparency >= 1 then
            if not u196.IsDestroyed then
                Silencer.Transparency = 1;
                Remotes.Inventory.UpdateWeaponSuppressor.Send({
                    State = false,
                    Identifier = Identifier
                });
            end;

            u196.IsSuppressed = false;
        end;
    end));
    u196.Janitor:Add(Animation2:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 1835
        -- upvalues: u199 (ref), u196 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        u199 = true;

        if not u196.IsDestroyed then
            Silencer.Transparency = 0;
            Remotes.Inventory.UpdateWeaponSuppressor.Send({
                State = true,
                Identifier = Identifier
            });
        end;

        u196.IsSuppressed = true;
    end));
    u196.Janitor:Add(Animation2:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 1840
        -- upvalues: Animation2 (copy), u199 (ref), Silencer (copy)
        if Animation2.IsPlaying then
            u199 = false;
            task.delay(0.016666666666666666, function() -- Line: 1843
                -- upvalues: Animation2 (ref), Silencer (ref)
                if Animation2.IsPlaying then
                    Silencer.Transparency = 0;
                end;
            end);
        end;
    end));
    u196.Janitor:Add(Animation2.Ended:Connect(function() -- Line: 1850
        -- upvalues: u196 (copy), u199 (ref), Silencer (copy)
        u196.IsAdjustingSuppressor = false;

        if not u199 then
            Silencer.Transparency = 1;
        end;
    end));
end;

function u1.setupRecoil(u200) -- Line: 1860
    -- upvalues: RunServiceController (copy), CameraController (copy)
    local Recoil = u200.Properties.Recoil;

    if not Recoil then
        return;
    end;

    local RecoverySpeed = Recoil.RecoverySpeed;
    local Scale = Recoil.Scale;
    local Damper = Recoil.Damper;
    local Speed = Recoil.Speed;
    local CameraScale = Recoil.CameraScale;
    local Identifier = u200.Identifier;
    local v201 = Recoil.Pattern(u200.Properties);
    u200.Recoil = {
        RotationValue = Vector3.new(0, 0, 0),
        Time = 0,
        RecoveryTime = 0,
        RecoveryStartTime = 0,
        Function = v201,
        Functions = {
            Default = v201
        },
        Value = Vector2.zero,
        ActiveFireRate = u200.Properties.FireRate or 0.1,
        RecoveryValue = Vector2.zero
    };
    local Recoil2 = u200.Recoil;
    u200.Janitor:Add(RunServiceController.BindToStepped(`Components.Weapon.{u200.Identifier}.Recoil`, function(p202: any, p203: number) -- Line: 1893
        -- upvalues: u200 (copy), Recoil2 (copy), RecoverySpeed (copy), Scale (copy), Identifier (copy), CameraController (ref), Damper (copy), Speed (copy), CameraScale (copy)
        if u200.IsDestroyed or not u200.IsEquipped then
            return;
        end;

        local v204 = Recoil2.Function(Recoil2.Time);

        if u200.IsShooting then
            Recoil2.Value = v204;
            Recoil2.RecoveryValue = v204;
            Recoil2.RecoveryTime = Recoil2.Time;
            Recoil2.RecoveryStartTime = os.clock();
        else
            local v205 = Recoil2.RecoveryValue.Magnitude / RecoverySpeed;

            if Recoil2.Value.Magnitude > 0 and v205 > 0 then
                local v206 = os.clock() - Recoil2.RecoveryStartTime;
                Recoil2.Value = Recoil2.RecoveryValue:Lerp(Vector2.zero, (math.clamp(v206 / v205, 0, 1)));
            end;

            if Recoil2.Time > 0 then
                Recoil2.Time = math.max(Recoil2.Time - Recoil2.RecoveryTime * RecoverySpeed * p203, 0);
            end;
        end;

        local v207 = Vector3.new(Recoil2.Value.Y, Recoil2.Value.X, 0) * math.rad(Scale);
        Recoil2.RotationValue = v207;

        if not (u200.IsDestroyed or (not u200.IsEquipped or u200.Identifier ~= Identifier)) then
            CameraController.setWeaponRecoil({
                Value = v207,
                Damper = Damper,
                Speed = Speed
            }, CameraScale);
        end;
    end), "Disconnect", "RecoilConnection");
end;

function u1.new(p208: userdata, p209: string, p210: string, p211: number, p212: string, p213: string, p214: number, p215: any, p216: any, p217: string?, p218: any, p219: table, p220: any) -- Line: 1941
    -- upvalues: WeaponComponent (copy), u1 (ref), Bullet (copy), SurvivalBuyRules (copy), applyActiveRecoilProfile (copy), restoreDefaultFovUnlessSceneActive (copy), CharacterResolver (copy), startRechargeTimer (copy)
    local v221 = WeaponComponent.new(p208, p209, p210, p211, p212, p213, p214, p215, p216, p217, p218, p219);
    local u222 = setmetatable(v221, u1);
    u222.IsEquipped = false;
    local v223 = p220 or {};
    u222.Bullet = Bullet.new(u222, u222.Properties);
    u222.Capacity = v223.Capacity or SurvivalBuyRules.GetFullReserve(u222.Properties);
    u222.Rounds = v223.Rounds or u222.Properties.Rounds;
    u222.RechargeStartTime = v223.RechargeStartTime;
    u222.AlternativeShootingOption = "Default";
    u222.AlternativeSwitchTick = 0;
    u222.IsBurstShooting = false;
    u222.ShootingHand = "Right";
    u222.HasPendingChargeRequest = false;
    u222.IsAlternativeFireHeld = false;
    u222.IsChargeFiring = false;
    u222.IsAdjustingSuppressor = false;
    u222.IsInspectFadingOut = false;
    u222.IsInspecting = false;
    u222.IsReloading = false;
    u222.IsShooting = false;
    u222.IsAiming = false;
    u222.IsFireHeld = false;
    local v224;

    if v223.IsSuppressed == nil then
        v224 = u222.Properties.HasSuppressor;
    else
        v224 = v223.IsSuppressed;
    end;

    u222.IsSuppressed = v224;
    u222.IsSniperScoped = false;
    u222.CurrentScopeIncrement = 0;
    u222.WeaponEquippedTick = 0;
    u222.ChargeStartTick = 0;
    u222.ShootRequestTick = 0;
    u222.ShotSeq = 0;
    u222.ReloadStartTick = 0;
    u222.ScopeStartTick = 0;
    u222:setupRecoil();

    if u222.Properties.ShootingOptions == "Revolver" then
        if u222.Bullet then
            local FireModes = u222.Properties.FireModes;
            local v225;

            if FireModes then
                v225 = FireModes.Secondary or FireModes.Primary;
            else
                v225 = nil;
            end;

            u222.Bullet:setSpreadConfig(v225 and v225.Spread or u222.Properties.Spread);
        end;

        applyActiveRecoilProfile(u222, "Secondary");
    end;

    u222.Janitor:Add(function() -- Line: 2028
        -- upvalues: u222 (copy), restoreDefaultFovUnlessSceneActive (ref)
        u222:cancelRevolverCharge(false, false);
        u222:stopRevolverSecondaryFire();

        if u222.Bullet then
            u222.Bullet:destroy();
            u222.Bullet = nil;
        end;

        if u222.IsAiming then
            restoreDefaultFovUnlessSceneActive();
        end;
    end);

    if u222.Properties.HasSuppressor then
        if u222.Viewmodel and u222.Viewmodel.Model then
            u222:createSuppressor();
        else
            local u226 = nil;
            u226 = CharacterResolver.observeCharacter(u222.Player, function(p227) -- Line: 2047
                -- upvalues: u222 (copy), u226 (ref)
                if not p227 then
                    return nil;
                end;

                task.defer(function() -- Line: 2052
                    -- upvalues: u222 (ref), u226 (ref)
                    if u222.IsDestroyed or not (u222.Viewmodel and u222.Viewmodel.Model) then
                        return;
                    end;

                    if u226 then
                        u226();
                        u226 = nil;
                    end;

                    u222:createSuppressor();
                end);

                return nil;
            end);
            u222.Janitor:Add(function() -- Line: 2064
                -- upvalues: u226 (ref)
                if u226 then
                    u226();
                    u226 = nil;
                end;
            end);
        end;
    end;

    if u222.Rounds < (u222.Properties.Rounds or u222.Rounds) then
        startRechargeTimer(u222);
    end;

    return u222;
end;

function u1.destroy(p228) -- Line: 2084
    -- upvalues: WeaponComponent (copy)
    if p228.IsDestroyed then
        return;
    end;

    p228.IsDestroyed = true;
    local ReloadTrackFinishedConnection = p228.ReloadTrackFinishedConnection;

    if ReloadTrackFinishedConnection and ReloadTrackFinishedConnection.Connected then
        ReloadTrackFinishedConnection:Disconnect();
    end;

    p228.ReloadTrackFinishedConnection = nil;
    local ShootDelayThread = p228.ShootDelayThread;

    if ShootDelayThread then
        task.cancel(ShootDelayThread);
        p228.ShootDelayThread = nil;
    end;

    local ChargeThread = p228.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        p228.ChargeThread = nil;
    end;

    local RechargeThread = p228.RechargeThread;

    if RechargeThread then
        task.cancel(RechargeThread);
        p228.RechargeThread = nil;
    end;

    local ChargeShootConnection = p228.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    p228.ChargeShootConnection = nil;
    local InspectDelayThread = p228.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        p228.InspectDelayThread = nil;
    end;

    local CancelDelayThread = p228.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        p228.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = p228.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        p228.FadeCompleteThread = nil;
    end;

    p228.Recoil = nil;

    if p228.Bullet then
        p228.Bullet:destroy();
        p228.Bullet = nil;
    end;

    p228.Janitor:Destroy();
    p228.Janitor = nil;
    p228.AlternativeShootingOption = nil;
    p228.AlternativeSwitchTick = nil;
    p228.CurrentReloadIdentity = nil;
    p228.CurrentScopeIncrement = nil;
    p228.WeaponEquippedTick = nil;
    p228.ChargeStartTick = nil;
    p228.ShootRequestTick = nil;
    p228.ReloadStartTick = nil;
    p228.ShootingHand = nil;
    p228.CurrentWalkSpeedOverride = nil;
    p228.HasPendingChargeRequest = nil;
    p228.IsAlternativeFireHeld = nil;
    p228.AlternativeFireInputBinding = nil;
    p228.IsChargeFiring = nil;
    p228.ChargeThread = nil;
    p228.ChargeShootConnection = nil;
    WeaponComponent.destroy(p228);
end;

return u1;