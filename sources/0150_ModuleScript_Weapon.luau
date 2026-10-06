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
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local PlayerHitPrediction = require(ReplicatedStorage.Components.Common.PlayerHitPrediction);
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction);
local GetWeaponCameraKick = require(ReplicatedStorage.Components.Common.GetWeaponCameraKick);
local WeaponTimings = require(ReplicatedStorage.Components.Common.WeaponTimings);
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
workspace:GetAttributeChangedSignal("VIPInfiniteAmmoEnabled"):Connect(function() -- Line: 79
    -- upvalues: u5 (ref)
    u5 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true;
end);
local u6 = {};

for _, child in ipairs(ReplicatedStorage.Database.Custom.Weapons:GetChildren()) do
    if child:IsA("ModuleScript") then
        u6[child.Name] = require(child);
    end;
end;

local function botVictimKey(p7: userdata) -- Line: 100
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

local function isPlayer(p9: userdata) -- Line: 109
    -- upvalues: CharacterResolver (copy)
    if p9 then
        p9 = p9:FindFirstAncestorOfClass("Model");
    end;

    local v10;

    if p9 == nil then
        v10 = false;
    else
        v10 = CharacterResolver.getPlayerFromCharacter(p9) ~= nil and true or (p9:GetAttribute("Bot") == true and true or CharacterResolver.isTutorialDummy(p9));
    end;

    return v10;
end;

local function isEquippedLocal(p11) -- Line: 121
    return not p11.IsDestroyed and p11.IsEquipped == true;
end;

local function isJustEquipped(p12) -- Line: 127
    -- upvalues: WeaponTimings (copy)
    return tick() - p12.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT;
end;

local function getEquipPulloutDuration(p13) -- Line: 133
    -- upvalues: WeaponTimings (copy)
    local Animation = p13.Viewmodel.Animation:getAnimation("Equip");
    local v14;

    if Animation then
        v14 = Animation.Length;
    else
        v14 = nil;
    end;

    return WeaponTimings.PulloutSeconds(v14);
end;

local function isLocalPlayerDefusing() -- Line: 140
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("IsDefusingBomb") == true and true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true;
end;

local function clearFireInputState(p15) -- Line: 146
    p15.IsFireHeld = false;
    p15.FireInputBinding = nil;
    p15.IsAlternativeFireHeld = false;
    p15.AlternativeFireInputBinding = nil;
    p15.HasPendingChargeRequest = false;
end;

local function cancelThreadField(p16: any, p17: string) -- Line: 156
    local v18 = p16[p17];

    if v18 then
        task.cancel(v18);
        p16[p17] = nil;
    end;
end;

local function disconnectField(p19: any, p20: string) -- Line: 164
    local v21 = p19[p20];

    if v21 and v21.Connected then
        v21:Disconnect();
    end;

    p19[p20] = nil;
end;

local function refreshHeldBinding(p22: any, p23: string, p24: string) -- Line: 173
    -- upvalues: InputController (copy)
    local v25 = p22[p24];

    if p22[p23] == true and (v25 and not InputController.isBindingPressed(v25)) then
        p22[p23] = false;
        p22[p24] = nil;
    end;

    return p22[p23] == true;
end;

local function playOtherSound(p26: string) -- Line: 182
    -- upvalues: Other (copy), LocalPlayer (copy)
    return Other:play({
        Parent = LocalPlayer.PlayerGui,
        Name = p26
    });
end;

local function setSniperScoped(p27: any, p28: boolean) -- Line: 192
    if p27.Name == "SSG 08" or p27.Name == "AWP" then
        p27.IsSniperScoped = p28;

        if p27.Name == "AWP" and p27.Player then
            p27.Player:SetAttribute("IsSniperScoped", p28);
        end;
    end;
end;

local function restoreDefaultFovUnlessSceneActive() -- Line: 204
    -- upvalues: ReplicatedStorage (copy), CameraController (copy), Constants (copy)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);

    if not (CaseSceneController.IsActive() or (MenuSceneController.IsActive() or BlackMarketSceneController.IsActive())) then
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end;
end;

local function getPressedActionBinding(p29: string, p30: table?) -- Line: 219
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

local function isRevolverWeapon(p31) -- Line: 244
    return p31.Properties.ShootingOptions == "Revolver";
end;

local function getRevolverFireMode(p32, p33) -- Line: 250
    local FireModes = p32.Properties.FireModes;

    if FireModes then
        return p33 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    end;

    return nil;
end;

local function getActiveFireRate(p34, p35) -- Line: 264
    local FireModes = p34.Properties.FireModes;
    local v36;

    if FireModes then
        v36 = p35 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v36 = nil;
    end;

    return v36 and v36.FireRate or (p34.Properties.FireRate or 0.1);
end;

local function applyActiveSpreadProfile(p37, p38) -- Line: 271
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

local function buildActiveRecoilPattern(p40, p41) -- Line: 281
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

local function applyActiveRecoilProfile(p43, p44) -- Line: 296
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

local function applyActiveWeaponModeProfiles(p49, p50) -- Line: 322
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

local function applyRevolverRestingWeaponModeProfiles(p52) -- Line: 327
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

local function applyRevolverChargeStartSpread(p54, p55) -- Line: 333
    if not (p54.Bullet and (p55 and p55.ChargeStartSpread)) then
        return;
    end;

    local v56 = p55.Spread or p54.Properties.Spread;

    if not v56 then
        return;
    end;

    p54.Bullet:setBaseSpreadForConfig(p55.ChargeStartSpread, v56);
end;

local function startRechargeTimer(u57) -- Line: 348
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
        u57.RechargeThread = task.delay(math_max_ret, function() -- Line: 381
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

local function resolveFireAnimationNames(p60: any, p61: string, p62: string, p63: any) -- Line: 394
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

local function clearRevolverChargeTracking(p65) -- Line: 432
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

local function resetRevolverChargeState(p66) -- Line: 439
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

local function stopRevolverChargeAnimation(p67: any, p68: boolean?) -- Line: 450
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

local function completeRevolverChargeShot(p71) -- Line: 470
    -- upvalues: CharacterResolver (copy), GameState (copy), LocalPlayer (copy), applyActiveRecoilProfile (copy)
    if p71.IsDestroyed or not (p71.IsEquipped and p71.IsChargeFiring) then
        return;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();
    local v72 = not LocalCharacter or LocalCharacter:GetAttribute("Dead");

    if v72 or GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) then
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

local function scheduleInspectEnd(u74: any, p75: number) -- Line: 496
    u74.InspectDelayThread = task.delay(p75, function() -- Line: 497
        -- upvalues: u74 (copy)
        if not u74.IsDestroyed then
            u74.InspectDelayThread = nil;
            u74.IsInspecting = false;
        end;
    end);
end;

local function resetActionState(p76) -- Line: 507
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

local function adjustSuppressor(p77: any, p78: string, p79: string, p80: boolean) -- Line: 525
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

function u1.getSpread(p81) -- Line: 547
    return p81.Bullet:getTrueSpread();
end;

function u1.getCrosshairDisplayState(p82) -- Line: 553
    return nil;
end;

function u1.getBaseSpread(p83) -- Line: 559
    return p83.Bullet:getBaseSpread();
end;

function u1.cancelRevolverCharge(p84: any, p85: boolean?, p86: boolean?) -- Line: 565
    -- upvalues: applyActiveRecoilProfile (copy), stopRevolverChargeAnimation (copy), ReplicateCharacterAction (copy)
    local IsChargeFiring = p84.IsChargeFiring;
    local ChargeThread = p84.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        p84.ChargeThread = nil;
    end;

    local ChargeShootConnection = p84.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    p84.ChargeShootConnection = nil;
    p84.HasPendingChargeRequest = false;
    p84.IsChargeFiring = false;
    p84.ChargeStartTick = 0;
    p84.CurrentWalkSpeedOverride = nil;

    if p84.Properties.ShootingOptions == "Revolver" then
        if p84.Bullet then
            local FireModes = p84.Properties.FireModes;
            local v87;

            if FireModes then
                v87 = FireModes.Secondary or FireModes.Primary;
            else
                v87 = nil;
            end;

            p84.Bullet:setSpreadConfig(v87 and v87.Spread or p84.Properties.Spread);
        end;

        applyActiveRecoilProfile(p84, "Secondary");
    end;

    if IsChargeFiring then
        stopRevolverChargeAnimation(p84, p86);

        if p86 ~= false and (p84.IsEquipped and not p84.IsDestroyed) then
            ReplicateCharacterAction("RevolverChargeCancel");
        end;
    end;

    if p85 ~= true then
        p84.IsFireHeld = false;
        p84.FireInputBinding = nil;
    end;
end;

function u1.startRevolverCharge(u88, p89) -- Line: 585
    -- upvalues: WeaponTimings (copy), CharacterResolver (copy), GameState (copy), LocalPlayer (copy), applyActiveRecoilProfile (copy), resolveFireAnimationNames (copy), completeRevolverChargeShot (copy), Remotes (copy), ReplicateCharacterAction (copy)
    if u88.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    local FireModes = u88.Properties.FireModes;
    local v90;

    if FireModes then
        v90 = FireModes.Primary;
    else
        v90 = nil;
    end;

    if not v90 or v90.InputBehavior ~= "Charge" then
        return;
    end;

    u88:stopRevolverSecondaryFire();
    local v91 = tick() - u88.WeaponEquippedTick;
    local Animation = u88.Viewmodel.Animation:getAnimation("Equip");
    local v92;

    if Animation then
        v92 = Animation.Length;
    else
        v92 = nil;
    end;

    if v91 <= WeaponTimings.PulloutSeconds(v92) then
        return;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter and LocalCharacter:GetAttribute("Dead") then
        return;
    end;

    if GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) then
        u88.IsFireHeld = false;
        u88.FireInputBinding = nil;
        u88.IsAlternativeFireHeld = false;
        u88.AlternativeFireInputBinding = nil;
        u88.HasPendingChargeRequest = false;

        return;
    end;

    if u88.IsAdjustingSuppressor or (u88.IsReloading or u88.IsChargeFiring) then
        return;
    end;

    if u88.IsShooting then
        local v93 = tick() - u88.ShootRequestTick;
        local FireModes2 = u88.Properties.FireModes;
        local v94;

        if FireModes2 then
            v94 = FireModes2.Primary;
        else
            v94 = nil;
        end;

        if math.max(0, (v94 and v94.FireRate or (u88.Properties.FireRate or 0.1)) - v93) <= 0.15 then
            u88.IsFireHeld = true;
            u88.FireInputBinding = p89;
            u88.HasPendingChargeRequest = true;
        end;

        return;
    end;

    if u88.Rounds <= 0 then
        u88.IsFireHeld = false;
        u88.FireInputBinding = nil;
        u88:reload();

        return;
    end;

    u88.IsFireHeld = true;
    u88.FireInputBinding = p89;
    u88.HasPendingChargeRequest = false;
    u88.IsChargeFiring = true;
    u88.ChargeStartTick = tick();
    u88.CurrentWalkSpeedOverride = v90.HoldWalkSpeed or u88.Properties.WalkSpeed;

    if u88.Bullet then
        local FireModes2 = u88.Properties.FireModes;
        local v95;

        if FireModes2 then
            v95 = FireModes2.Primary;
        else
            v95 = nil;
        end;

        u88.Bullet:setSpreadConfig(v95 and v95.Spread or u88.Properties.Spread);
    end;

    applyActiveRecoilProfile(u88, "Primary");
    local v96 = u88.Bullet and (v90 and v90.ChargeStartSpread) and (v90.Spread or u88.Properties.Spread);

    if v96 then
        u88.Bullet:setBaseSpreadForConfig(v90.ChargeStartSpread, v96);
    end;

    if u88.IsInspecting or u88.IsInspectFadingOut then
        u88:cancelInspect(nil, nil, true);
    end;

    local ChargeThread = u88.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        u88.ChargeThread = nil;
    end;

    local ChargeShootConnection = u88.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    u88.ChargeShootConnection = nil;
    u88:stopAllAnimations();
    local v97, v98 = resolveFireAnimationNames(u88, "Shoot", "Shoot", "Primary");
    local v99 = u88.Viewmodel.Animation:play(v97);

    if v99 then
        v99:AdjustSpeed(1);
        u88.ChargeShootConnection = v99:GetMarkerReachedSignal("Shoot"):Connect(function() -- Line: 655
            -- upvalues: completeRevolverChargeShot (ref), u88 (copy)
            completeRevolverChargeShot(u88);
        end);
    end;

    local v100 = u88.CharacterAnimator:play(v98);

    if v100 then
        v100:AdjustSpeed(1);
    end;

    Remotes.Sound.ReplicateSound.Send({
        Name = "Prepare",
        Class = u88.Name
    });
    ReplicateCharacterAction("RevolverChargeStart");

    if not v99 then
        u88.ChargeThread = task.delay(v90.ChargeTime or 0, function() -- Line: 672
            -- upvalues: completeRevolverChargeShot (ref), u88 (copy)
            completeRevolverChargeShot(u88);
        end);
    end;
end;

function u1.startRevolverSecondaryFire(p101, p102) -- Line: 680
    -- upvalues: GameState (copy), LocalPlayer (copy), applyActiveRecoilProfile (copy)
    if p101.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    if GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) then
        p101.IsFireHeld = false;
        p101.FireInputBinding = nil;
        p101.IsAlternativeFireHeld = false;
        p101.AlternativeFireInputBinding = nil;
        p101.HasPendingChargeRequest = false;

        return;
    end;

    p101:cancelRevolverCharge(false, false);
    p101.IsAlternativeFireHeld = true;
    p101.AlternativeFireInputBinding = p102;

    if p101.Bullet then
        local FireModes = p101.Properties.FireModes;
        local v103;

        if FireModes then
            v103 = FireModes.Secondary or FireModes.Primary;
        else
            v103 = nil;
        end;

        p101.Bullet:setSpreadConfig(v103 and v103.Spread or p101.Properties.Spread);
    end;

    applyActiveRecoilProfile(p101, "Secondary");

    if p101.IsShooting or (p101.IsReloading or p101.IsAdjustingSuppressor) then
        return;
    end;

    if p101.Rounds > 0 then
        p101:shoot("Secondary");

        return;
    end;

    p101:reload();
end;

function u1.stopRevolverSecondaryFire(p104) -- Line: 708
    -- upvalues: applyActiveRecoilProfile (copy)
    p104.IsAlternativeFireHeld = false;
    p104.AlternativeFireInputBinding = nil;

    if not p104.IsChargeFiring and p104.Properties.ShootingOptions == "Revolver" then
        if p104.Bullet then
            local FireModes = p104.Properties.FireModes;
            local v105;

            if FireModes then
                v105 = FireModes.Secondary or FireModes.Primary;
            else
                v105 = nil;
            end;

            p104.Bullet:setSpreadConfig(v105 and v105.Spread or p104.Properties.Spread);
        end;

        applyActiveRecoilProfile(p104, "Secondary");
    end;
end;

function u1.stopAllAnimations(p106) -- Line: 718
    if not (p106.CharacterAnimator and (p106.Viewmodel and p106.Viewmodel.Animation)) then
        return;
    end;

    p106.Viewmodel.Animation:cancelCrossfade();

    for i, v in pairs(p106.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p106.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p106.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p106.Viewmodel.Animation:stop(i);
        end;
    end;
end;

function u1.removeSuppressor(p107) -- Line: 738
    -- upvalues: adjustSuppressor (copy)
    adjustSuppressor(p107, "RemoveSuppressor", "Remove Suppressor", true);
end;

function u1.addSuppressor(p108) -- Line: 742
    -- upvalues: adjustSuppressor (copy)
    adjustSuppressor(p108, "AddSuppressor", "Add Suppressor", false);
end;

function u1.scope(p109: any, p110: boolean) -- Line: 748
    -- upvalues: WeaponTimings (copy), Other (copy), LocalPlayer (copy), CameraController (copy), Constants (copy), u2 (copy), Remotes (copy)
    if not p109.Viewmodel or tick() - p109.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return;
    end;

    if p109.IsAdjustingSuppressor or (p109.IsReloading or p109.IsShooting and p109.Properties.AimingOptions ~= "AutomaticScope") or p109.IsDestroyed then
        return;
    end;

    if p109.Properties.HasScope then
        if not p109.IsAiming then
            p109:stopAllAnimations();
        end;

        p109.IsBurstShooting = false;
        p109.IsInspecting = false;
        p109.IsReloading = false;
        p109.IsShooting = false;

        if not p109.IsAiming then
            p109.ScopeStartTick = tick();
        end;

        p109.IsAiming = true;

        if p109.Name == "SSG 08" or p109.Name == "AWP" then
            p109.IsSniperScoped = true;

            if p109.Name == "AWP" and p109.Player then
                p109.Player:SetAttribute("IsSniperScoped", true);
            end;
        end;

        if p109.Properties.AimingOptions == "SniperScope" then
            if not p109.Viewmodel.Hidden then
                p109.Viewmodel:hide();
            end;

            Other:play({
                Name = "Toggle Scope",
                Parent = LocalPlayer.PlayerGui
            });
            local v111;

            if p110 then
                p109.CurrentScopeIncrement = p109.CurrentScopeIncrement + 1;

                if p109.CurrentScopeIncrement >= 3 then
                    p109:unscope(nil, nil, "Toggle Scope");

                    return;
                end;

                v111 = p109.CurrentScopeIncrement;
            else
                v111 = 1;
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - u2[v111]);
            Remotes.Inventory.UpdateScopeIncrement.Send({
                SoundName = "Toggle Scope",
                Increment = v111
            });

            return;
        end;

        if p109.Properties.AimingOptions == "AutomaticScope" then
            if p109.CurrentScopeIncrement == 1 then
                p109:unscope();

                return;
            end;

            p109.CurrentScopeIncrement = 1;

            if not p109.Viewmodel.Hidden then
                p109.Viewmodel:hide();
            end;

            p109.Viewmodel:aim();
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * p109.CurrentScopeIncrement);
            Remotes.Inventory.UpdateScopeIncrement.Send({
                SoundName = "Scope In",
                Increment = p109.CurrentScopeIncrement
            });
            Other:play({
                Name = "Scope In",
                Parent = LocalPlayer.PlayerGui
            });
        end;
    end;
end;

function u1.unscope(p112: any, p113: boolean?, p114: boolean?, p115: string?) -- Line: 830
    -- upvalues: WeaponTimings (copy), Remotes (copy), restoreDefaultFovUnlessSceneActive (copy), CameraController (copy), Constants (copy), Other (copy), LocalPlayer (copy)
    if not (p114 or tick() - p112.WeaponEquippedTick > WeaponTimings.EQUIP_ACTION_LOCKOUT and not p112.IsAdjustingSuppressor) then
        return;
    end;

    if p112.Properties.HasScope then
        if p112.IsAiming then
            p112:stopAllAnimations();
        end;

        if p112.CurrentScopeIncrement > 0 or p112.IsAiming then
            Remotes.Inventory.UpdateScopeIncrement.Send({
                Increment = 0,
                SoundName = p115 == nil and p112.Properties.AimingOptions == "AutomaticScope" and "Scope Out" or p115
            });
        end;

        if not p113 then
            p112.CurrentScopeIncrement = 0;
        end;

        p112.IsInspecting = false;
        p112.IsReloading = false;
        p112.IsAiming = false;
        p112.ScopeStartTick = 0;

        if p112.Name == "SSG 08" or p112.Name == "AWP" then
            p112.IsSniperScoped = false;

            if p112.Name == "AWP" and p112.Player then
                p112.Player:SetAttribute("IsSniperScoped", false);
            end;
        end;

        if p112.Properties.AimingOptions == "SniperScope" then
            if p112.Viewmodel.Hidden then
                p112.Viewmodel:unhide();
            end;

            restoreDefaultFovUnlessSceneActive();

            if p113 then
                p112.CurrentScopeIncrement = math.clamp(p112.CurrentScopeIncrement - 1, 0, 3);
            end;
        elseif p112.Properties.AimingOptions == "AutomaticScope" then
            p112.CurrentScopeIncrement = 0;
            p112.Viewmodel:unaim();

            if p112.Viewmodel.Hidden then
                p112.Viewmodel:unhide();
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * p112.CurrentScopeIncrement);
            Other:play({
                Name = "Scope Out",
                Parent = LocalPlayer.PlayerGui
            });
        end;
    end;
end;

function u1.cancelInspect(u116: any, p117: number?, p118: number?, p119: boolean?) -- Line: 888
    if not (u116.IsInspecting or u116.IsInspectFadingOut) then
        return;
    end;

    local InspectDelayThread = u116.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u116.InspectDelayThread = nil;
    end;

    local CancelDelayThread = u116.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        u116.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = u116.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        u116.FadeCompleteThread = nil;
    end;

    if p119 then
        u116.IsInspecting = false;
        u116.IsInspectFadingOut = false;
        u116.Viewmodel.Animation:markInspectCancel();
        u116.Viewmodel.Animation:cancelCrossfade();

        return;
    end;

    local u120 = p117 or 0.25;
    u116.IsInspectFadingOut = true;
    u116.IsInspecting = false;
    u116.Viewmodel.Animation:markInspectCancel();
    u116.CancelDelayThread = task.delay(p118 or 0.3, function() -- Line: 917
        -- upvalues: u116 (copy), u120 (copy)
        if u116.IsDestroyed then
            return;
        end;

        if not u116.IsInspectFadingOut then
            return;
        end;

        u116.Viewmodel.Animation:crossfadeTo("Idle", u120);
        u116.FadeCompleteThread = task.delay(u120, function() -- Line: 929
            -- upvalues: u116 (ref)
            if not u116.IsDestroyed then
                u116.FadeCompleteThread = nil;
                u116.IsInspectFadingOut = false;
            end;
        end);
    end);
end;

function u1.inspect(u121) -- Line: 940
    -- upvalues: WeaponTimings (copy), ReplicateCharacterAction (copy)
    if tick() - u121.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return;
    end;

    if u121.IsChargeFiring then
        u121:cancelRevolverCharge(false, false);
    end;

    u121:stopRevolverSecondaryFire();

    if u121.IsAdjustingSuppressor or (u121.IsShooting or (u121.IsReloading or u121.IsAiming)) then
        return;
    end;

    if u121.IsInspecting and not u121.IsInspectFadingOut then
        return;
    end;

    local v122 = u121.IsInspectFadingOut == true;

    if v122 then
        u121.IsInspectFadingOut = false;
        local CancelDelayThread = u121.CancelDelayThread;

        if CancelDelayThread then
            task.cancel(CancelDelayThread);
            u121.CancelDelayThread = nil;
        end;

        local FadeCompleteThread = u121.FadeCompleteThread;

        if FadeCompleteThread then
            task.cancel(FadeCompleteThread);
            u121.FadeCompleteThread = nil;
        end;

        u121.Viewmodel.Animation:cancelCrossfade();
    end;

    u121.IsBurstShooting = false;
    u121.IsInspecting = true;
    u121.IsReloading = false;
    u121.IsShooting = false;
    u121.ScopeStartTick = 0;
    u121.IsAiming = false;
    local InspectDelayThread = u121.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        u121.InspectDelayThread = nil;
    end;

    local v123 = u121.Viewmodel.Animation:pickInspectVariant();

    if v122 then
        if not u121.Viewmodel.Animation:crossfadeRestart(v123, 0.25) then
            u121:stopAllAnimations();
            u121.Viewmodel.Animation:play(v123);
        end;

        ReplicateCharacterAction("Inspect");
        local Animation = u121.Viewmodel.Animation:getAnimation(v123);

        if Animation then
            u121.InspectDelayThread = task.delay(Animation.Length, function() -- Line: 497
                -- upvalues: u121 (copy)
                if not u121.IsDestroyed then
                    u121.InspectDelayThread = nil;
                    u121.IsInspecting = false;
                end;
            end);
        end;

        return;
    end;

    u121:stopAllAnimations();
    local v124 = u121.Viewmodel.Animation:play(v123);
    ReplicateCharacterAction("Inspect");
    u121.InspectDelayThread = task.delay(v124.Length, function() -- Line: 497
        -- upvalues: u121 (copy)
        if not u121.IsDestroyed then
            u121.InspectDelayThread = nil;
            u121.IsInspecting = false;
        end;
    end);
end;

function u1.fireBurst(u125) -- Line: 1002
    -- upvalues: WeaponTimings (copy), HintController (copy)
    u125.IsBurstShooting = true;
    task.spawn(function() -- Line: 1005
        -- upvalues: WeaponTimings (ref), u125 (copy), HintController (ref)
        for i = 1, WeaponTimings.BURST_SHOT_COUNT do
            if not u125.IsEquipped then
                break;
            end;

            u125:shoot();

            if u125.Rounds <= 0 then
                HintController:createHint("Reload");
            end;

            task.wait(WeaponTimings.BURST_SHOT_INTERVAL);
            local _ = i;
        end;

        task.wait(WeaponTimings.BURST_COOLDOWN);
        u125.IsBurstShooting = false;
    end);
end;

function u1.updateFireMode(p126) -- Line: 1027
    -- upvalues: WeaponTimings (copy), Other (copy), LocalPlayer (copy), ReplicateCharacterAction (copy), Router (copy)
    if tick() - p126.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return;
    end;

    if p126.IsShooting or (p126.IsReloading or (p126.IsBurstShooting or p126.IsChargeFiring)) then
        return;
    end;

    Other:play({
        Name = "Switch Fire Mode",
        Parent = LocalPlayer.PlayerGui
    });
    p126:stopAllAnimations();
    p126.Viewmodel.Animation:play("Switch");
    p126.AlternativeSwitchTick = tick();
    p126.AlternativeShootingOption = p126.AlternativeShootingOption == "Burst" and "Default" or "Burst";
    ReplicateCharacterAction("Switch Fire Mode");
    local v127 = p126.Properties.Automatic and "Switched to automatic" or "Switched to semi-automatic";
    Router.broadcastRouter("CreateNotification", "Switched Fire Mode", p126.AlternativeShootingOption == "Default" and v127 and v127 or "Switched to burst-fire mode", 2.5);
end;

function u1.drop(p128) -- Line: 1062
    -- upvalues: GameState (copy), IsTutorialMode (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy), workspace_CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or (GameState.GetState() == "Warmup" or (IsTutorialMode() or not p128.Properties.Droppable)) then
        return false;
    end;

    p128:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
        Direction = workspace_CurrentCamera.CFrame.LookVector,
        Identifier = p128.Identifier
    });

    return true;
end;

function u1.reload(u129) -- Line: 1083
    -- upvalues: IsTutorialMode (copy), WeaponTimings (copy), playOtherSound (copy), HttpService (copy), ReplicateCharacterAction (copy), Remotes (copy), HintController (copy)
    local u130 = workspace:GetAttribute("Gamemode") == "Deathmatch" and true or IsTutorialMode();
    local u131;

    if u130 then
        u131 = u129.Properties.ReloadAnimationCount == 1;
    else
        u131 = u130;
    end;

    if tick() - u129.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return;
    end;

    if u129.IsChargeFiring then
        u129:cancelRevolverCharge(false, false);
    end;

    u129:stopRevolverSecondaryFire();

    if u129.IsAdjustingSuppressor or (u129.IsReloading or u129.IsShooting) then
        return;
    end;

    if u129.Properties.Rounds == u129.Rounds or u129.Properties.RechargeTime then
        if u129.IsInspecting or u129.IsInspectFadingOut then
            u129:cancelInspect(0.25);
        end;

        return;
    end;

    if u129.Capacity <= 0 and not u131 then
        if u129.IsInspecting or u129.IsInspectFadingOut then
            u129:cancelInspect(0.25);
        end;

        return playOtherSound("No Ammo");
    end;

    if u129.IsAiming then
        u129:unscope();
    end;

    if not (u129.Properties.Rounds and u129.Properties.ReloadAnimationCount) then
        return;
    end;

    if u129.IsInspecting or u129.IsInspectFadingOut then
        u129:cancelInspect(nil, nil, true);
    end;

    u129:stopAllAnimations();
    u129.ReloadStartTick = tick();
    u129.IsBurstShooting = false;
    u129.IsInspecting = false;
    u129.IsReloading = true;
    u129.IsShooting = false;
    u129.CurrentWalkSpeedOverride = nil;

    if u129.Properties.ReloadAnimationCount > 1 then
        local u132 = u129.Properties.Rounds / u129.Properties.ReloadAnimationCount;
        local u133 = HttpService:GenerateGUID(false);
        u129.CurrentReloadIdentity = u133;
        local v134 = u129.Viewmodel.Animation:play("ReloadStart");
        task.wait(v134.Length * 0.75);

        for i = 1, math.ceil((u129.Properties.Rounds - u129.Rounds) / u132) do
            if not u129.IsReloading or u129.CurrentReloadIdentity ~= u133 then
                return;
            end;

            if u129.Rounds >= u129.Properties.Rounds then
                break;
            end;

            local v135 = u129.Viewmodel.Animation:play("ReloadAction");

            if not v135 then
                error((`Client failed to fetch reload animation for {u129.Name}.`));
            end;

            u129.CharacterAnimator:play("Reload");
            ReplicateCharacterAction("Reload");
            v135:GetMarkerReachedSignal("MagOut"):Once(function() -- Line: 1150
                -- upvalues: Remotes (ref), u129 (copy)
                Remotes.Inventory.CreateMagazine.Send(u129.Identifier);
            end);
            v135:GetMarkerReachedSignal("MagIn"):Once(function() -- Line: 1153
                -- upvalues: u129 (copy), u133 (copy), u132 (copy), Remotes (ref), u130 (copy)
                local v136 = u129;

                if not (not v136.IsDestroyed and v136.IsEquipped == true) or u129.CurrentReloadIdentity ~= u133 then
                    return;
                end;

                local math_min_ret = math.min(u132, u129.Capacity, u129.Properties.Rounds - u129.Rounds);

                if math_min_ret > 0 then
                    Remotes.Inventory.ReloadWeapon.Send({
                        Identifier = u129.Identifier,
                        Capacity = u129.Capacity,
                        Rounds = u129.Rounds
                    });
                    u129.Rounds = u129.Rounds + math_min_ret;

                    if not u130 then
                        u129.Capacity = u129.Capacity - math_min_ret;
                    end;
                end;
            end);
            task.wait(v135.Length);
            local _ = i;
        end;

        if u129.IsReloading and u129.CurrentReloadIdentity == u133 then
            u129.Viewmodel.Animation:play("ReloadEnd").Ended:Once(function() -- Line: 1176
                -- upvalues: u129 (copy)
                u129.IsReloading = false;
            end);
        end;
    else
        local u137 = HttpService:GenerateGUID(false);
        u129.CurrentReloadIdentity = u137;
        local u138 = u129.Viewmodel.Animation:play("Reload");
        local v139 = `Client failed to fetch reload animation for {u129.Name}.`;
        assert(u138, v139);
        u129.CharacterAnimator:play("Reload");
        ReplicateCharacterAction("Reload");
        u138:GetMarkerReachedSignal("MagOut"):Once(function() -- Line: 1187
            -- upvalues: Remotes (ref), u129 (copy)
            Remotes.Inventory.CreateMagazine.Send(u129.Identifier);
        end);
        u138:GetMarkerReachedSignal("MagIn"):Once(function() -- Line: 1190
            -- upvalues: u129 (copy), u137 (copy), Remotes (ref), HintController (ref), u131 (copy), u130 (copy)
            local v140 = u129;

            if not (not v140.IsDestroyed and v140.IsEquipped == true) or u129.CurrentReloadIdentity ~= u137 then
                return;
            end;

            local math_abs_ret = math.abs(u129.Properties.Rounds - u129.Rounds);
            Remotes.Inventory.ReloadWeapon.Send({
                Identifier = u129.Identifier,
                Rounds = u129.Rounds,
                Capacity = u129.Capacity
            });
            HintController:clearHint("Reload");

            if not u131 then
                if u129.Capacity - math_abs_ret > 0 then
                    u129.Rounds = u129.Properties.Rounds;

                    if not u130 then
                        u129.Capacity = math.max(0, u129.Capacity - math_abs_ret);

                        return;
                    end;
                elseif u129.Capacity - math_abs_ret <= 0 then
                    u129.Rounds = u129.Rounds + u129.Capacity;

                    if not u130 then
                        u129.Capacity = 0;
                    end;
                end;

                return;
            end;

            u129.Rounds = u129.Properties.Rounds;
            u129.Capacity = u129.Properties.Capacity;
        end);
        local ReloadTrackFinishedConnection = u129.ReloadTrackFinishedConnection;

        if ReloadTrackFinishedConnection and ReloadTrackFinishedConnection.Connected then
            ReloadTrackFinishedConnection:Disconnect();
        end;

        u129.ReloadTrackFinishedConnection = nil;
        u129.ReloadTrackFinishedConnection = u138:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 1217
            -- upvalues: u129 (copy), u138 (copy)
            if u129.IsDestroyed then
                return;
            end;

            if not u138.IsPlaying and u129.WeaponEquippedTick < u129.ReloadStartTick then
                u129.IsReloading = false;
            end;

            local v141 = u129;
            local ReloadTrackFinishedConnection2 = v141.ReloadTrackFinishedConnection;

            if ReloadTrackFinishedConnection2 and ReloadTrackFinishedConnection2.Connected then
                ReloadTrackFinishedConnection2:Disconnect();
            end;

            v141.ReloadTrackFinishedConnection = nil;
        end);
    end;
end;

function u1.shoot(u142, p143) -- Line: 1232
    -- upvalues: LocalPlayer (copy), WeaponTimings (copy), CharacterResolver (copy), GameState (copy), u1 (ref), u6 (copy), Other (copy), CameraController (copy), u5 (ref), resolveFireAnimationNames (copy), startRechargeTimer (copy), SoundController (copy), Router (copy), applyActiveRecoilProfile (copy), Remotes (copy), DataController (copy), CreateZeusBeam (copy), Camera (copy), CreateTracer (copy), CreateImpact (copy), CreateBloodSplatter (copy), botVictimKey (copy), PlayerHitPrediction (copy), BreakGlass (copy), CreateMarker (copy), GetWeaponCameraKick (copy), ReplicateCharacterAction (copy), HapticsController (copy), InputController (copy)
    local v144 = p143 or "Primary";
    local FireModes = u142.Properties.FireModes;
    local v145;

    if FireModes then
        v145 = v144 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v145 = nil;
    end;

    local u146 = v145 and v145.FireRate or (u142.Properties.FireRate or 0.1);
    local v147 = u142.Properties.ShootingOptions == "Revolver";

    if v147 then
        if v144 == "Primary" then
            v147 = u142.IsChargeFiring;
        else
            v147 = false;
        end;
    end;

    local Animation = u142.Viewmodel.Animation:getAnimation("Equip");

    if LocalPlayer:GetAttribute("IsDefusingBomb") == true and true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true then
        u142.IsFireHeld = false;
        u142.FireInputBinding = nil;
        u142.IsAlternativeFireHeld = false;
        u142.AlternativeFireInputBinding = nil;
        u142.HasPendingChargeRequest = false;

        if u142.IsChargeFiring then
            u142:cancelRevolverCharge(false, false);
        end;

        return;
    end;

    if tick() - u142.WeaponEquippedTick <= Animation.Length * WeaponTimings.EQUIP_PULLOUT_FRACTION or CharacterResolver.getLocalCharacter() and CharacterResolver.getLocalCharacter():GetAttribute("Dead") then
        return;
    end;

    if GameState.GetState() == "Buy Period" then
        return;
    end;

    if pcall(function() -- Line: 1259
        -- upvalues: u142 (copy)
        local Properties = u142.Properties;
        Properties.FireRate = Properties.FireRate + 1e-7;
    end) then
        u1 = {};

        while true do

        end;
    end;

    if u6 and u6[u142.Name] then
        local v148 = u6[u142.Name];

        if u142.Properties.FireRate < v148.FireRate or (u142.Properties.BulletsPerShot > v148.BulletsPerShot or (u142.Properties.Range > v148.Range or u142.Properties.Penetration > v148.Penetration)) then
            u1 = {};

            while true do

            end;
        end;
    end;

    if not (u142.Properties.FireRate and (u142.Properties.BulletsPerShot and not (u142.IsAdjustingSuppressor or u142.IsReloading and u142.Properties.MuzzleType ~= "ShotGun"))) then
        return;
    end;

    local PlayerCharacter = CharacterResolver.getPlayerCharacter(u142.Player);

    if not (PlayerCharacter and u142.CharacterAnimator) then
        return;
    end;

    if u142.AlternativeShootingOption ~= "Burst" then
        u142.ShootRequestTick = tick();
    end;

    if u142.IsShooting and u142.AlternativeShootingOption == "Default" then
        return;
    end;

    local Interactables = u142.Viewmodel.Model:FindFirstChild("Interactables");

    if not Interactables then
        return;
    end;

    if u142.Rounds <= 0 then
        u142:reload();

        return;
    end;

    local Rounds = u142.Properties.Rounds;

    if Rounds and u142.Rounds <= Rounds * 0.2 then
        Other:play({
            Name = "Low Ammo Fire",
            Parent = LocalPlayer.PlayerGui
        });
    end;

    local v149 = u142.IsAiming and u142.Properties.AimingOptions == "AutomaticScope" and "AimShoot" or "Shoot";
    local v150 = u142.Properties.HasSuppressor and not u142.IsSuppressed and "NoSuppressorShoot" or "Shoot";
    CameraController.toWeaponFirePosition();

    if not v147 and (u142.IsInspecting or u142.IsInspectFadingOut) then
        u142:cancelInspect(nil, nil, true);
    end;

    if not v147 then
        u142:stopAllAnimations();
    end;

    u142.CurrentReloadIdentity = nil;
    u142.IsInspecting = false;
    u142.IsInspectFadingOut = false;
    u142.IsReloading = false;
    u142.IsShooting = true;
    local ChargeThread = u142.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        u142.ChargeThread = nil;
    end;

    local ChargeShootConnection = u142.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    u142.ChargeShootConnection = nil;
    u142.HasPendingChargeRequest = false;
    u142.IsChargeFiring = false;
    u142.ChargeStartTick = 0;
    u142.CurrentWalkSpeedOverride = nil;

    if not u5 then
        u142.Rounds = u142.Rounds - 1;
    end;

    u142.RechargeStartTime = workspace:GetServerTimeNow();

    if u142.Properties.ShootingOptions == "Dual" then
        u142.ShootingHand = u142.ShootingHand == "Left" and "Right" or "Left";
        v149 = "Shoot" .. u142.ShootingHand;
        v150 = "Shoot" .. u142.ShootingHand;
    end;

    local v151, v152 = resolveFireAnimationNames(u142, v150, v149, v144);
    local v153;

    if v147 then
        v153 = v151;
    else
        v153 = u142.Viewmodel.Animation:pickVariant(v151);
    end;

    if u142.Properties.MuzzleType ~= "ShotGun" then
        u142.CharacterAnimator:adjustAnimationSpeed(v152, u146);
    end;

    if u142.Rounds > 150 then
        return;
    end;

    startRechargeTimer(u142);
    local Position = PlayerCharacter.PrimaryPart.Position;
    local WeaponShootRange = SoundController.GetWeaponShootRange(u142.Name, (u142.Properties.HasSuppressor and u142.IsSuppressed) == true);
    Router.broadcastRouter("UpdatePlayerNoiseCone", "Weapon", Position, WeaponShootRange, nil);

    if u142.Bullet then
        local FireModes2 = u142.Properties.FireModes;
        local v154;

        if FireModes2 then
            v154 = v144 == "Secondary" and FireModes2.Secondary or FireModes2.Primary;
        else
            v154 = nil;
        end;

        u142.Bullet:setSpreadConfig(v154 and v154.Spread or u142.Properties.Spread);
    end;

    applyActiveRecoilProfile(u142, v144);
    local v155 = u142.Properties.ShootingOptions == "Dual" and (u142.ShootingHand == "Left" and Interactables:FindFirstChild("MuzzlePartL") or Interactables:FindFirstChild("MuzzlePartR")) or Interactables.MuzzlePart;
    local Position2 = v155.Position;
    debug.profilebegin("Weapon.BuildShootPacket");
    local v156 = {};
    local v157 = {};

    for i = 1, u142.Properties.BulletsPerShot do
        local v158 = u142.Bullet:create(u142.Properties.AimingOptions, u142.IsAiming);
        local v159;

        if v158 then
            table.insert(v156, v158);
            table.insert(v157, {
                Direction = v158.Direction,
                Origin = v158.Origin
            });
            v159 = i;
        else
            v159 = i;
        end;
    end;

    debug.profileend();

    if v147 and u142.Properties.ShootingOptions == "Revolver" then
        if u142.Bullet then
            local FireModes2 = u142.Properties.FireModes;
            local v160;

            if FireModes2 then
                v160 = FireModes2.Secondary or FireModes2.Primary;
            else
                v160 = nil;
            end;

            u142.Bullet:setSpreadConfig(v160 and v160.Spread or u142.Properties.Spread);
        end;

        applyActiveRecoilProfile(u142, "Secondary");
    end;

    debug.profilebegin("Weapon.SendShootPacket");
    u142.ShotSeq = u142.ShotSeq + 1;
    Remotes.Inventory.ShootWeapon.Send({
        IsSniperScoped = u142.IsSniperScoped,
        ShootingHand = u142.ShootingHand,
        Identifier = u142.Identifier,
        Seq = u142.ShotSeq,
        Bullets = v157,
        ViewTick = Router.broadcastRouter("GetRemoteViewTick")
    });
    debug.profileend();
    debug.profilebegin("Weapon.ShootVFX");
    local v161 = DataController.Get(LocalPlayer, "Settings.Video.Presets.First Person Tracers") ~= false;
    local v162 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false;

    if v162 then
        local v163;

        if u142.Properties.AimingOptions == "AutomaticScope" then
            v163 = u142.IsAiming;
        else
            v163 = false;
        end;

        v162 = not v163;
    end;

    local v164 = DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true;
    local v165 = u142.Properties.MuzzleType == "Zeus x27";

    if v165 then
        CreateZeusBeam(v155);
    end;

    if v162 and #v156 > 0 then
        Camera(v155, u142.Properties.HasSuppressor and u142.IsSuppressed and "Suppressor" or u142.Properties.MuzzleType);
    end;

    for _, v in ipairs(v156) do
        local v166 = false;

        if v161 then
            CreateTracer(v.Distance, Position2, v.Direction);
        end;

        local v167 = v;
        local v168 = false;

        for _, v2 in ipairs(v.Hits) do
            local Instance = v2.Instance;
            local Position3 = v2.Position;
            local Material = v2.Material;
            local Normal = v2.Normal;
            local Exit = v2.Exit;
            local v169;

            if Instance then
                v169 = Instance:FindFirstAncestorOfClass("Model");
            else
                v169 = Instance;
            end;

            local v170;

            if v169 == nil then
                v170 = false;
            else
                v170 = (CharacterResolver.getPlayerFromCharacter(v169) ~= nil or v169:GetAttribute("Bot") == true) and true or CharacterResolver.isTutorialDummy(v169);
            end;

            if v170 then
                if v164 then
                    local PlayerFromInstance = CharacterResolver.getPlayerFromInstance(Instance);
                    local ImpactMaterial = CharacterResolver.getImpactMaterial(Instance, "Blood Splatter");
                    CreateImpact(Instance, ImpactMaterial, Position3, Normal, Exit, false, true, nil, v168, nil, v165);

                    if ImpactMaterial == "Blood Splatter" and not (Exit or v165) then
                        CreateBloodSplatter(Position3, v167.Direction);
                    end;

                    local v171;

                    if PlayerFromInstance then
                        v171 = PlayerFromInstance.UserId;
                    else
                        v171 = botVictimKey(Instance);
                    end;

                    if v171 and not Exit then
                        PlayerHitPrediction.Record(u142.ShotSeq, v171, Instance.Name, Position3);
                    end;
                end;
            else
                v168 = not Exit and true or v168;

                if not v165 then
                    local v172 = not Exit and not v166;
                    CreateImpact(Instance, Material, Position3, Normal, Exit, false, true, nil, nil, nil, nil, not v172);
                    v166 = v172 and true or v166;
                end;

                local Parent = Instance.Parent;

                if Parent and (Parent:HasTag("BreakableGlass") and not Exit) then
                    BreakGlass(Instance, Position3, v167.Direction);
                elseif not (v165 or (Instance:HasTag("BreakableGlass") or Parent and Parent:HasTag("BreakableGlass"))) then
                    CreateMarker(Instance, "Bullet", Position3, Normal);
                end;

                if Parent and (Parent:HasTag("BreakableDoor") and (u142.Properties.Penetration or 0) <= 0) then
                    break;
                end;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Weapon.ShootTail");

    if u142.Viewmodel.Model.CameraShake then
        CameraController.weaponKick(GetWeaponCameraKick(u142.Viewmodel.Model.CameraShake));
    end;

    u142.Viewmodel.Bobble:addScopeKick();

    if u142.Viewmodel.applyCharmImpulse then
        local Pivot = u142.Viewmodel.Model:GetPivot();

        if u142.Viewmodel.Mirror then
            Pivot = u142.Viewmodel.Mirror:ToNormalPose(Pivot);
        end;

        u142.Viewmodel:applyCharmImpulse(Pivot.LookVector * -1 + Pivot.UpVector * 0.3);
    end;

    if u142.Recoil then
        local Recoil = u142.Recoil;
        Recoil.Time = Recoil.Time + u146;
    end;

    ReplicateCharacterAction(v147 and "RevolverChargeRelease" or v151);
    local u173 = u142.IsAiming and u142.Properties.AimingOptions == "SniperScope";

    if u173 then
        u142:unscope(true);
    end;

    debug.profilebegin("Weapon.ShootAnimations");
    local v174;

    if v147 then
        v174 = u142.Viewmodel.Animation:getAnimation(v151);
    else
        v174 = u142.Viewmodel.Animation:play(v153);
    end;

    if v147 then
        if not (v174 and v174.IsPlaying) then
            u142.Viewmodel.Animation:play(v151);
            u142.CharacterAnimator:play(v152);
        end;
    else
        u142.CharacterAnimator:play(v152);
    end;

    debug.profileend();
    debug.profilebegin("Weapon.ShootHaptics");
    HapticsController.vibrate(Enum.VibrationMotor.Small, 1.25, 0.225);
    debug.profileend();
    local ShootDelayThread = u142.ShootDelayThread;

    if ShootDelayThread then
        task.cancel(ShootDelayThread);
        u142.ShootDelayThread = nil;
    end;

    local os_clock_ret = os.clock();
    local NextShotDue = u142.NextShotDue;
    local v175;

    if NextShotDue and os_clock_ret - NextShotDue < 0.035 then
        v175 = NextShotDue + u146;
    else
        v175 = os_clock_ret + u146;
    end;

    u142.NextShotDue = v175;
    local ShootRequestTick = u142.ShootRequestTick;
    u142.ShootDelayThread = task.delay(v175 - os_clock_ret, function() -- Line: 1578
        -- upvalues: u142 (copy), u173 (copy), DataController (ref), LocalPlayer (ref), InputController (ref), u146 (copy), ShootRequestTick (copy)
        if u142.IsDestroyed then
            return;
        end;

        u142.IsShooting = false;
        u142.ShootDelayThread = nil;
        local v176 = u142;

        if not (not v176.IsDestroyed and v176.IsEquipped == true) then
            return;
        end;

        if u173 and (u142.ShootRequestTick > u142.WeaponEquippedTick and (u142.Rounds > 0 and DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Re-Zoom Sniper Rifle after Shot") == true)) then
            u142:scope(true);
        end;

        if u142.Properties.ShootingOptions ~= "Revolver" then
            local v177 = tick();
            local math_min_ret = math.min(0.15, u146);
            local v178;

            if ShootRequestTick < u142.ShootRequestTick then
                v178 = v177 - u142.ShootRequestTick <= math_min_ret;
            else
                v178 = false;
            end;

            local v179 = u142;
            local FireInputBinding = v179.FireInputBinding;

            if v179.IsFireHeld == true and (FireInputBinding and not InputController.isBindingPressed(FireInputBinding)) then
                v179.IsFireHeld = false;
                v179.FireInputBinding = nil;
            end;

            local v180 = v179.IsFireHeld == true;

            if u142.Properties.Automatic and v180 then
                v178 = v180;
            else
                local v181 = not u142.Properties.Automatic;

                if v181 then
                    if v178 then
                        v178 = not v180;
                    end;
                else
                    v178 = v181;
                end;
            end;

            if not (v178 and (u142.Properties.ShootingOptions ~= "Burst" or u142.AlternativeShootingOption ~= "Burst")) then
                return;
            end;

            if u142.Rounds > 0 then
                u142:shoot();

                return;
            end;

            u142:reload();

            return;
        end;

        local v182 = u142;
        local AlternativeFireInputBinding = v182.AlternativeFireInputBinding;

        if v182.IsAlternativeFireHeld == true and (AlternativeFireInputBinding and not InputController.isBindingPressed(AlternativeFireInputBinding)) then
            v182.IsAlternativeFireHeld = false;
            v182.AlternativeFireInputBinding = nil;
        end;

        local FireModes2 = u142.Properties.FireModes;
        local v183;

        if FireModes2 then
            v183 = FireModes2.Secondary or FireModes2.Primary;
        else
            v183 = nil;
        end;

        if v182.IsAlternativeFireHeld == true and (v183 and v183.HoldRepeat) then
            if u142.Rounds > 0 then
                u142:shoot("Secondary");

                return;
            end;

            u142:reload();

            return;
        end;

        local v184 = u142;
        local FireInputBinding = v184.FireInputBinding;

        if v184.IsFireHeld == true and (FireInputBinding and not InputController.isBindingPressed(FireInputBinding)) then
            v184.IsFireHeld = false;
            v184.FireInputBinding = nil;
        end;

        local v185 = v184.IsFireHeld == true;
        local FireModes3 = u142.Properties.FireModes;
        local v186;

        if FireModes3 then
            v186 = FireModes3.Primary;
        else
            v186 = nil;
        end;

        if not (v185 and (v186 and v186.HoldRepeat)) then
            if u142.HasPendingChargeRequest == true then
                u142.HasPendingChargeRequest = false;

                if v185 then
                    u142:startRevolverCharge(u142.FireInputBinding);
                end;
            end;

            return;
        end;

        if u142.Rounds > 0 then
            u142:startRevolverCharge(u142.FireInputBinding);

            return;
        end;

        u142:reload();
    end);
    debug.profileend();
end;

function u1.equip(u187) -- Line: 1658
    -- upvalues: CameraController (copy), WeaponTimings (copy), GameState (copy), LocalPlayer (copy), InputController (copy), getPressedActionBinding (copy), u4 (copy), u3 (copy), applyActiveRecoilProfile (copy)
    u187.IsEquipped = true;
    CameraController.resetWeaponRecoil();

    if u187.Bullet then
        u187.Bullet:setActive(true);
    end;

    if u187.Viewmodel.Hidden then
        u187.Viewmodel:unhide();
    end;

    u187.Viewmodel.Animation:stopAnimations();
    u187.CharacterAnimator:stopAnimations();
    u187.CharacterAnimator:play("Idle");
    u187.CharacterAnimator:play("Equip");
    u187.WeaponEquippedTick = tick();
    u187.Viewmodel:equip(false);
    u187.Janitor:Remove("EquipDelayFire");
    local task_delay = task.delay;
    local Animation = u187.Viewmodel.Animation:getAnimation("Equip");
    local v188;

    if Animation then
        v188 = Animation.Length;
    else
        v188 = nil;
    end;

    local u192 = task_delay(WeaponTimings.PulloutSeconds(v188), function() -- Line: 1675
        -- upvalues: u187 (copy), GameState (ref), LocalPlayer (ref), InputController (ref), getPressedActionBinding (ref), u4 (ref), u3 (ref)
        if u187.IsDestroyed or (not u187.IsEquipped or GameState.GetState() == "Buy Period") then
            return;
        end;

        if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true and LocalPlayer:GetAttribute("IsLocallyDefusingBomb") ~= true then
            if u187.Properties.ShootingOptions == "Revolver" and (u187.IsAlternativeFireHeld or InputController.isActionActive("SecondaryFire")) then
                local v189 = u187.AlternativeFireInputBinding or getPressedActionBinding("SecondaryFire", u4);

                if v189 or u187.IsAlternativeFireHeld then
                    u187:startRevolverSecondaryFire(v189);

                    return;
                end;
            end;

            if not InputController.isActionActive("Fire") then
                return;
            end;

            local v190 = getPressedActionBinding("Fire", u3);

            if v190 then
                if u187.Properties.ShootingOptions == "Revolver" then
                    u187:startRevolverCharge(v190);

                    return;
                end;

                u187.IsFireHeld = true;
                u187.FireInputBinding = v190;
                u187:shoot();
            end;

            return;
        end;

        local v191 = u187;
        v191.IsFireHeld = false;
        v191.FireInputBinding = nil;
        v191.IsAlternativeFireHeld = false;
        v191.AlternativeFireInputBinding = nil;
        v191.HasPendingChargeRequest = false;
    end);
    u187.Janitor:Add(function() -- Line: 1710
        -- upvalues: u192 (copy)
        task.cancel(u192);
    end, false, "EquipDelayFire");
    u187.CurrentScopeIncrement = 0;
    u187.ScopeStartTick = 0;
    u187.IsFireHeld = false;
    u187.FireInputBinding = nil;
    u187.IsAlternativeFireHeld = false;
    u187.AlternativeFireInputBinding = nil;
    u187.HasPendingChargeRequest = false;
    u187.IsBurstShooting = false;
    u187.IsInspectFadingOut = false;
    u187.IsInspecting = false;
    u187.IsReloading = false;
    u187.IsShooting = false;
    u187.IsAiming = false;
    u187.IsChargeFiring = false;
    u187.IsAdjustingSuppressor = false;
    u187.CurrentWalkSpeedOverride = nil;
    u187.ChargeStartTick = 0;
    u187.ChargeThread = nil;
    u187.ChargeShootConnection = nil;

    if u187.Properties.ShootingOptions == "Revolver" then
        if u187.Bullet then
            local FireModes = u187.Properties.FireModes;
            local v193;

            if FireModes then
                v193 = FireModes.Secondary or FireModes.Primary;
            else
                v193 = nil;
            end;

            u187.Bullet:setSpreadConfig(v193 and v193.Spread or u187.Properties.Spread);
        end;

        applyActiveRecoilProfile(u187, "Secondary");
    end;

    if u187.Name == "SSG 08" or u187.Name == "AWP" then
        u187.IsSniperScoped = false;

        if u187.Name == "AWP" and u187.Player then
            u187.Player:SetAttribute("IsSniperScoped", false);
        end;
    end;
end;

function u1.unequip(p194) -- Line: 1722
    -- upvalues: CameraController (copy), restoreDefaultFovUnlessSceneActive (copy)
    p194.IsEquipped = false;
    CameraController.resetWeaponRecoil();

    if p194.Bullet then
        p194.Bullet:setActive(false);
    end;

    p194:cancelRevolverCharge(false, false);
    p194:stopRevolverSecondaryFire();
    p194.Janitor:Remove("EquipDelayFire");
    local ShootDelayThread = p194.ShootDelayThread;

    if ShootDelayThread then
        task.cancel(ShootDelayThread);
        p194.ShootDelayThread = nil;
    end;

    restoreDefaultFovUnlessSceneActive();
    p194.CharacterAnimator:stopAnimations();
    p194.Viewmodel:unequip();

    if p194.IsAiming or p194.CurrentScopeIncrement > 0 then
        p194:unscope(nil, true);
    end;

    if p194.Viewmodel.Hidden then
        p194.Viewmodel:unhide();
    end;

    p194.IsFireHeld = false;
    p194.FireInputBinding = nil;
    p194.IsAlternativeFireHeld = false;
    p194.AlternativeFireInputBinding = nil;
    p194.HasPendingChargeRequest = false;
    p194.IsBurstShooting = false;
    p194.IsInspectFadingOut = false;
    p194.IsInspecting = false;
    p194.IsReloading = false;
    p194.IsShooting = false;
    p194.IsAiming = false;
    p194.IsChargeFiring = false;
    p194.IsAdjustingSuppressor = false;
    p194.CurrentWalkSpeedOverride = nil;
    p194.ChargeStartTick = 0;
    p194.ChargeThread = nil;
    p194.ChargeShootConnection = nil;

    if p194.Name == "SSG 08" or p194.Name == "AWP" then
        p194.IsSniperScoped = false;

        if p194.Name == "AWP" and p194.Player then
            p194.Player:SetAttribute("IsSniperScoped", false);
        end;
    end;

    if p194.Recoil then
        p194.Recoil.Function = p194.Recoil.Functions.Default;
        p194.Recoil.ActiveFireRate = p194.Properties.FireRate or 0.1;
        p194.Recoil.Value = Vector2.zero;
        p194.Recoil.RecoveryValue = Vector2.zero;
        p194.Recoil.RecoveryTime = 0;
        p194.Recoil.RecoveryStartTime = 0;
        p194.Recoil.Time = 0;
    end;
end;

function u1.createSuppressor(u195) -- Line: 1758
    -- upvalues: Remotes (copy)
    local v196 = u195.Viewmodel and u195.Viewmodel.Model;

    if not v196 then
        return;
    end;

    local Silencer = v196:FindFirstChild("Silencer", true);

    if not Silencer then
        return;
    end;

    Silencer.Transparency = u195.IsSuppressed and 0 or 1;
    local Identifier = u195.Identifier;

    local function _(p197: number) -- Line: 1774
        -- upvalues: u195 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        if u195.IsDestroyed then
            return;
        end;

        Silencer.Transparency = p197;
        Remotes.Inventory.UpdateWeaponSuppressor.Send({
            Identifier = Identifier,
            State = p197 == 0
        });
    end;

    local u198 = false;
    local Animation = u195.Viewmodel.Animation:getAnimation("RemoveSuppressor");
    local Animation2 = u195.Viewmodel.Animation:getAnimation("AddSuppressor");
    u195.Janitor:Add(Animation:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 1789
        -- upvalues: u195 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        if u195.IsDestroyed then
            return;
        end;

        Silencer.Transparency = 1;
        Remotes.Inventory.UpdateWeaponSuppressor.Send({
            State = false,
            Identifier = Identifier
        });
    end));
    u195.Janitor:Add(Animation.Ended:Connect(function() -- Line: 1792
        -- upvalues: u195 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        u195.IsAdjustingSuppressor = false;

        if Silencer.Transparency >= 1 then
            if not u195.IsDestroyed then
                Silencer.Transparency = 1;
                Remotes.Inventory.UpdateWeaponSuppressor.Send({
                    State = false,
                    Identifier = Identifier
                });
            end;

            u195.IsSuppressed = false;
        end;
    end));
    u195.Janitor:Add(Animation2:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 1801
        -- upvalues: u198 (ref), u195 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        u198 = true;

        if not u195.IsDestroyed then
            Silencer.Transparency = 0;
            Remotes.Inventory.UpdateWeaponSuppressor.Send({
                State = true,
                Identifier = Identifier
            });
        end;

        u195.IsSuppressed = true;
    end));
    u195.Janitor:Add(Animation2:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 1806
        -- upvalues: Animation2 (copy), u198 (ref), Silencer (copy)
        if Animation2.IsPlaying then
            u198 = false;
            task.delay(0.016666666666666666, function() -- Line: 1809
                -- upvalues: Animation2 (ref), Silencer (ref)
                if Animation2.IsPlaying then
                    Silencer.Transparency = 0;
                end;
            end);
        end;
    end));
    u195.Janitor:Add(Animation2.Ended:Connect(function() -- Line: 1816
        -- upvalues: u195 (copy), u198 (ref), Silencer (copy)
        u195.IsAdjustingSuppressor = false;

        if not u198 then
            Silencer.Transparency = 1;
        end;
    end));
end;

function u1.setupRecoil(u199) -- Line: 1826
    -- upvalues: RunServiceController (copy), CameraController (copy)
    local Recoil = u199.Properties.Recoil;

    if not Recoil then
        return;
    end;

    local RecoverySpeed = Recoil.RecoverySpeed;
    local Scale = Recoil.Scale;
    local Damper = Recoil.Damper;
    local Speed = Recoil.Speed;
    local CameraScale = Recoil.CameraScale;
    local Identifier = u199.Identifier;
    local v200 = Recoil.Pattern(u199.Properties);
    u199.Recoil = {
        RotationValue = Vector3.new(0, 0, 0),
        Time = 0,
        RecoveryTime = 0,
        RecoveryStartTime = 0,
        Function = v200,
        Functions = {
            Default = v200
        },
        Value = Vector2.zero,
        ActiveFireRate = u199.Properties.FireRate or 0.1,
        RecoveryValue = Vector2.zero
    };
    local Recoil2 = u199.Recoil;
    u199.Janitor:Add(RunServiceController.BindToStepped(`Components.Weapon.{u199.Identifier}.Recoil`, function(p201: any, p202: number) -- Line: 1859
        -- upvalues: u199 (copy), Recoil2 (copy), RecoverySpeed (copy), Scale (copy), Identifier (copy), CameraController (ref), Damper (copy), Speed (copy), CameraScale (copy)
        if u199.IsDestroyed or not u199.IsEquipped then
            return;
        end;

        local v203 = Recoil2.Function(Recoil2.Time);

        if u199.IsShooting then
            Recoil2.Value = v203;
            Recoil2.RecoveryValue = v203;
            Recoil2.RecoveryTime = Recoil2.Time;
            Recoil2.RecoveryStartTime = os.clock();
        else
            local v204 = Recoil2.RecoveryValue.Magnitude / RecoverySpeed;

            if Recoil2.Value.Magnitude > 0 and v204 > 0 then
                local v205 = os.clock() - Recoil2.RecoveryStartTime;
                Recoil2.Value = Recoil2.RecoveryValue:Lerp(Vector2.zero, (math.clamp(v205 / v204, 0, 1)));
            end;

            if Recoil2.Time > 0 then
                Recoil2.Time = math.max(Recoil2.Time - Recoil2.RecoveryTime * RecoverySpeed * p202, 0);
            end;
        end;

        local v206 = Vector3.new(Recoil2.Value.Y, Recoil2.Value.X, 0) * math.rad(Scale);
        Recoil2.RotationValue = v206;

        if not (u199.IsDestroyed or (not u199.IsEquipped or u199.Identifier ~= Identifier)) then
            CameraController.setWeaponRecoil({
                Value = v206,
                Damper = Damper,
                Speed = Speed
            }, CameraScale);
        end;
    end), "Disconnect", "RecoilConnection");
end;

function u1.new(p207: userdata, p208: string, p209: string, p210: number, p211: string, p212: string, p213: number, p214: any, p215: any, p216: string?, p217: any, p218: table, p219: any) -- Line: 1907
    -- upvalues: WeaponComponent (copy), u1 (ref), Bullet (copy), applyActiveRecoilProfile (copy), restoreDefaultFovUnlessSceneActive (copy), CharacterResolver (copy), startRechargeTimer (copy)
    local v220 = WeaponComponent.new(p207, p208, p209, p210, p211, p212, p213, p214, p215, p216, p217, p218);
    local u221 = setmetatable(v220, u1);
    u221.IsEquipped = false;
    local v222 = p219 or {};
    u221.Bullet = Bullet.new(u221, u221.Properties);
    u221.Capacity = v222.Capacity or u221.Properties.Capacity;
    u221.Rounds = v222.Rounds or u221.Properties.Rounds;
    u221.RechargeStartTime = v222.RechargeStartTime;
    u221.AlternativeShootingOption = "Default";
    u221.AlternativeSwitchTick = 0;
    u221.IsBurstShooting = false;
    u221.ShootingHand = "Right";
    u221.HasPendingChargeRequest = false;
    u221.IsAlternativeFireHeld = false;
    u221.IsChargeFiring = false;
    u221.IsAdjustingSuppressor = false;
    u221.IsInspectFadingOut = false;
    u221.IsInspecting = false;
    u221.IsReloading = false;
    u221.IsShooting = false;
    u221.IsAiming = false;
    u221.IsFireHeld = false;
    local v223;

    if v222.IsSuppressed == nil then
        v223 = u221.Properties.HasSuppressor;
    else
        v223 = v222.IsSuppressed;
    end;

    u221.IsSuppressed = v223;
    u221.IsSniperScoped = false;
    u221.CurrentScopeIncrement = 0;
    u221.WeaponEquippedTick = 0;
    u221.ChargeStartTick = 0;
    u221.ShootRequestTick = 0;
    u221.ShotSeq = 0;
    u221.ReloadStartTick = 0;
    u221.ScopeStartTick = 0;
    u221:setupRecoil();

    if u221.Properties.ShootingOptions == "Revolver" then
        if u221.Bullet then
            local FireModes = u221.Properties.FireModes;
            local v224;

            if FireModes then
                v224 = FireModes.Secondary or FireModes.Primary;
            else
                v224 = nil;
            end;

            u221.Bullet:setSpreadConfig(v224 and v224.Spread or u221.Properties.Spread);
        end;

        applyActiveRecoilProfile(u221, "Secondary");
    end;

    u221.Janitor:Add(function() -- Line: 1994
        -- upvalues: u221 (copy), restoreDefaultFovUnlessSceneActive (ref)
        u221:cancelRevolverCharge(false, false);
        u221:stopRevolverSecondaryFire();

        if u221.Bullet then
            u221.Bullet:destroy();
            u221.Bullet = nil;
        end;

        if u221.IsAiming then
            restoreDefaultFovUnlessSceneActive();
        end;
    end);

    if u221.Properties.HasSuppressor then
        if u221.Viewmodel and u221.Viewmodel.Model then
            u221:createSuppressor();
        else
            local u225 = nil;
            u225 = CharacterResolver.observeCharacter(u221.Player, function(p226) -- Line: 2013
                -- upvalues: u221 (copy), u225 (ref)
                if not p226 then
                    return nil;
                end;

                task.defer(function() -- Line: 2018
                    -- upvalues: u221 (ref), u225 (ref)
                    if u221.IsDestroyed or not (u221.Viewmodel and u221.Viewmodel.Model) then
                        return;
                    end;

                    if u225 then
                        u225();
                        u225 = nil;
                    end;

                    u221:createSuppressor();
                end);

                return nil;
            end);
            u221.Janitor:Add(function() -- Line: 2030
                -- upvalues: u225 (ref)
                if u225 then
                    u225();
                    u225 = nil;
                end;
            end);
        end;
    end;

    if u221.Rounds < (u221.Properties.Rounds or u221.Rounds) then
        startRechargeTimer(u221);
    end;

    return u221;
end;

function u1.destroy(p227) -- Line: 2050
    -- upvalues: WeaponComponent (copy)
    if p227.IsDestroyed then
        return;
    end;

    p227.IsDestroyed = true;
    local ReloadTrackFinishedConnection = p227.ReloadTrackFinishedConnection;

    if ReloadTrackFinishedConnection and ReloadTrackFinishedConnection.Connected then
        ReloadTrackFinishedConnection:Disconnect();
    end;

    p227.ReloadTrackFinishedConnection = nil;
    local ShootDelayThread = p227.ShootDelayThread;

    if ShootDelayThread then
        task.cancel(ShootDelayThread);
        p227.ShootDelayThread = nil;
    end;

    local ChargeThread = p227.ChargeThread;

    if ChargeThread then
        task.cancel(ChargeThread);
        p227.ChargeThread = nil;
    end;

    local RechargeThread = p227.RechargeThread;

    if RechargeThread then
        task.cancel(RechargeThread);
        p227.RechargeThread = nil;
    end;

    local ChargeShootConnection = p227.ChargeShootConnection;

    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect();
    end;

    p227.ChargeShootConnection = nil;
    local InspectDelayThread = p227.InspectDelayThread;

    if InspectDelayThread then
        task.cancel(InspectDelayThread);
        p227.InspectDelayThread = nil;
    end;

    local CancelDelayThread = p227.CancelDelayThread;

    if CancelDelayThread then
        task.cancel(CancelDelayThread);
        p227.CancelDelayThread = nil;
    end;

    local FadeCompleteThread = p227.FadeCompleteThread;

    if FadeCompleteThread then
        task.cancel(FadeCompleteThread);
        p227.FadeCompleteThread = nil;
    end;

    p227.Recoil = nil;

    if p227.Bullet then
        p227.Bullet:destroy();
        p227.Bullet = nil;
    end;

    p227.Janitor:Destroy();
    p227.Janitor = nil;
    p227.AlternativeShootingOption = nil;
    p227.AlternativeSwitchTick = nil;
    p227.CurrentReloadIdentity = nil;
    p227.CurrentScopeIncrement = nil;
    p227.WeaponEquippedTick = nil;
    p227.ChargeStartTick = nil;
    p227.ShootRequestTick = nil;
    p227.ReloadStartTick = nil;
    p227.ShootingHand = nil;
    p227.CurrentWalkSpeedOverride = nil;
    p227.HasPendingChargeRequest = nil;
    p227.IsAlternativeFireHeld = nil;
    p227.AlternativeFireInputBinding = nil;
    p227.IsChargeFiring = nil;
    p227.ChargeThread = nil;
    p227.ChargeShootConnection = nil;
    WeaponComponent.destroy(p227);
end;

return u1;