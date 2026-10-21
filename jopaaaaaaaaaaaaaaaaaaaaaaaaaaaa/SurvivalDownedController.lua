-- ReplicatedStorage.Controllers.SurvivalDownedController
-- Script path: ReplicatedStorage.Controllers.SurvivalDownedController
-- Decompile time: 7.96 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SurvivalDowned = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.SurvivalDowned);
local SurvivalDowned2 = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Color3_fromRGB_ret = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret2 = Color3.fromRGB(214, 41, 41);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u2 = {};
local u3 = nil;
local u4 = nil;
local u5 = 0;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = 0;
local u10 = nil;
local u11 = 0;
local u12 = nil;

local function makeMarker(p13: userdata, p14: userdata) -- Line: 90
    -- upvalues: ReplicatedStorage (copy), PlayerGui (copy)
    local v15 = ReplicatedStorage.Assets.UI.Survival.DownedMarker:Clone();
    v15.Name = `Downed_{p13.UserId}`;
    v15.Adornee = p14;
    v15.Parent = PlayerGui;

    return v15;
end;

local function dropMarker(p16: userdata) -- Line: 99
    -- upvalues: u2 (copy)
    local v17 = u2[p16];

    if v17 then
        v17:Destroy();
        u2[p16] = nil;
    end;
end;

local function shellRoot(p18: userdata) -- Line: 107
    -- upvalues: CharacterResolver (copy), CharacterController (copy)
    return CharacterResolver.getRootPart(CharacterController.GetRemoteShell(p18));
end;

local function downedBar(p19: userdata) -- Line: 112
    -- upvalues: SurvivalDowned2 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local ReviveProgress = SurvivalDowned2.GetReviveProgress(p19);

    if ReviveProgress then
        return ReviveProgress, Color3_fromRGB_ret;
    end;

    return SurvivalDowned2.GetBleedOutLeft(p19) / SurvivalDowned2.BLEED_OUT_SECONDS, Color3_fromRGB_ret2;
end;

local function updateMarkers(p20: boolean) -- Line: 120
    -- upvalues: u2 (copy), Players (copy), SurvivalDowned2 (copy), LocalPlayer (copy), CharacterResolver (copy), CharacterController (copy), ReplicatedStorage (copy), PlayerGui (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    for i in u2 do
        if not (p20 and (i.Parent == Players and SurvivalDowned2.IsDowned(i))) then
            local v21 = u2[i];

            if v21 then
                v21:Destroy();
                u2[i] = nil;
            end;
        end;
    end;

    if not p20 then
        return;
    end;

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer and SurvivalDowned2.IsDowned(v) then
            local RootPart = CharacterResolver.getRootPart(CharacterController.GetRemoteShell(v));

            if RootPart then
                local v22 = u2[v];

                if not v22 then
                    v22 = ReplicatedStorage.Assets.UI.Survival.DownedMarker:Clone();
                    v22.Name = `Downed_{v.UserId}`;
                    v22.Adornee = RootPart;
                    v22.Parent = PlayerGui;
                end;

                u2[v] = v22;

                if v22.Adornee ~= RootPart then
                    v22.Adornee = RootPart;
                end;

                local ReviveProgress = SurvivalDowned2.GetReviveProgress(v);
                local v23;

                if ReviveProgress then
                    v23 = Color3_fromRGB_ret;
                else
                    ReviveProgress = SurvivalDowned2.GetBleedOutLeft(v) / SurvivalDowned2.BLEED_OUT_SECONDS;
                    v23 = Color3_fromRGB_ret2;
                end;

                v22.Track.Bar.Size = UDim2.fromScale(math.clamp(ReviveProgress, 0, 1), 1);
                v22.Track.Bar.BackgroundColor3 = v23;
            else
                local v24 = u2[v];

                if v24 then
                    v24:Destroy();
                    u2[v] = nil;
                end;
            end;
        end;
    end;
end;

local function findReviveTarget() -- Line: 153
    -- upvalues: SurvivalDowned2 (copy), LocalPlayer (copy), CharacterResolver (copy), IsPlayingTeam (copy), Players (copy), CharacterController (copy)
    if SurvivalDowned2.AreHandsBusy(LocalPlayer) or not CharacterResolver.isAlivePlayer(LocalPlayer) then
        return nil;
    end;

    local RootPart = CharacterResolver.getRootPart(CharacterResolver.getLocalCharacter());

    if not (RootPart and IsPlayingTeam(LocalPlayer:GetAttribute("Team"))) then
        return nil;
    end;

    local v25 = (1 / 0);
    local v26 = nil;

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer and SurvivalDowned2.IsDowned(v) then
            local RootPart2 = CharacterResolver.getRootPart(CharacterController.GetRemoteShell(v));

            if RootPart2 and SurvivalDowned2.IsInReviveRange(RootPart.Position, RootPart2.Position) then
                local Magnitude = (RootPart2.Position - RootPart.Position).Magnitude;

                if Magnitude < v25 then
                    v26 = v;
                    v25 = Magnitude;
                end;
            end;
        end;
    end;

    return v26;
end;

local function areHandsBusy() -- Line: 181
    -- upvalues: InventoryController (copy), SurvivalDowned2 (copy), LocalPlayer (copy)
    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v27;

    if CurrentEquipped then
        v27 = CurrentEquipped.Properties.Slot;
    else
        v27 = nil;
    end;

    return not SurvivalDowned2.CanUseSlot(LocalPlayer, v27);
end;

local function releaseHands() -- Line: 188
    -- upvalues: InventoryController (copy)
    local CurrentEquipped = InventoryController.getCurrentEquipped();

    if not CurrentEquipped then
        return;
    end;

    local Properties = CurrentEquipped.Properties;

    if Properties.Class == "Weapon" then
        if CurrentEquipped.IsChargeFiring then
            CurrentEquipped:cancelRevolverCharge(false);
        end;

        CurrentEquipped:releaseFireInput();

        if Properties.HasScope then
            CurrentEquipped:unscope(nil, true);
        end;

        if CurrentEquipped.IsReloading then
            CurrentEquipped.CurrentReloadIdentity = nil;
            CurrentEquipped.IsReloading = false;
            CurrentEquipped:stopAllAnimations();
        end;
    else
        if Properties.Class == "Melee" then
            CurrentEquipped:releaseFireInput();

            return;
        end;

        if Properties.Slot == "Grenade" and (CurrentEquipped.ThrowStarted and not CurrentEquipped.ThrowFinished) then
            CurrentEquipped:Cancel();
        end;
    end;
end;

local function poseViewmodel(p28: string?) -- Line: 223
    -- upvalues: InventoryController (copy), u7 (ref), u8 (ref)
    local v29;

    if p28 then
        v29 = InventoryController.getCurrentEquipped();
    else
        v29 = nil;
    end;

    local v30;

    if v29 then
        v30 = v29.Viewmodel;
    else
        v30 = nil;
    end;

    if v30 ~= u7 then
        if u7 and not u7.IsDestroyed then
            u7:setLowered(false);
            u7:unhide();
        end;

        u7 = v30;
        u8 = nil;
    end;

    if not v30 or v30.IsDestroyed then
        u7 = nil;
        u8 = nil;

        return;
    end;

    v30:setLowered(p28 == "Lowered");

    if p28 == "Hidden" then
        v30:hide();
    elseif u8 == "Hidden" then
        v30:unhide();
    end;

    u8 = p28;
end;

local function updateHands(p31: string?) -- Line: 246
    -- upvalues: u6 (ref), releaseHands (copy), poseViewmodel (copy)
    if p31 and not u6 then
        releaseHands();
    end;

    poseViewmodel(p31);
    u6 = p31;
end;

local function getDesaturation() -- Line: 257
    -- upvalues: u10 (ref), Lighting (copy)
    local v32 = u10;

    if v32 and v32.Parent == Lighting then
        return v32;
    end;

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "DownedColorCorrection";
    ColorCorrectionEffect.Enabled = false;
    ColorCorrectionEffect.Parent = Lighting;
    u10 = ColorCorrectionEffect;

    return ColorCorrectionEffect;
end;

local function updateDesaturation(p33: boolean, p34: number) -- Line: 271
    -- upvalues: u10 (ref), Lighting (copy), u11 (ref)
    local v35 = p33 and 1 or 0;
    local v36;

    if u10 == nil then
        v36 = false;
    else
        v36 = u10.Parent == Lighting;
    end;

    if u11 == v35 and (v35 == 0 or v36) then
        return;
    end;

    local v37 = p34 / 0.6;
    local v38;

    if u11 < v35 then
        v38 = math.min(v35, u11 + v37);
    else
        v38 = math.max(v35, u11 - v37);
    end;

    u11 = v38;
    local v39 = u10;

    if not v39 or v39.Parent ~= Lighting then
        v39 = Instance.new("ColorCorrectionEffect");
        v39.Name = "DownedColorCorrection";
        v39.Enabled = false;
        v39.Parent = Lighting;
        u10 = v39;
    end;

    v39.Saturation = -(u11 * u11 * (3 - u11 * 2));
    v39.Enabled = u11 > 0;
end;

local function isActive() -- Line: 289
    -- upvalues: IsSurvivalMode (copy), u4 (ref), SurvivalDowned2 (copy), LocalPlayer (copy), Players (copy)
    if not IsSurvivalMode() then
        return false;
    end;

    if u4 or SurvivalDowned2.IsReviving(LocalPlayer) then
        return true;
    end;

    for _, v in Players:GetPlayers() do
        if SurvivalDowned2.IsDowned(v) then
            return true;
        end;
    end;

    return false;
end;

local function stopUpdating() -- Line: 304
    -- upvalues: u12 (ref), u3 (ref), SurvivalDowned (copy)
    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    u3 = nil;
    SurvivalDowned.Hide();
end;

local function update(p40: number) -- Line: 313
    -- upvalues: IsSurvivalMode (copy), u9 (ref), updateMarkers (copy), u3 (ref), findReviveTarget (copy), SurvivalDowned2 (copy), LocalPlayer (copy), u4 (ref), u5 (ref), InventoryController (copy), u6 (ref), releaseHands (copy), poseViewmodel (copy), updateDesaturation (copy), SurvivalDowned (copy), isActive (copy), u11 (ref), u7 (ref), u2 (copy), u12 (ref)
    local v41 = IsSurvivalMode();
    local os_clock_ret = os.clock();

    if os_clock_ret - u9 >= 0.06666666666666667 then
        u9 = os_clock_ret;
        updateMarkers(v41);
        local v42;

        if v41 then
            v42 = findReviveTarget();
        else
            v42 = nil;
        end;

        u3 = v42;
    end;

    local v43;

    if v41 then
        v43 = SurvivalDowned2.IsDowned(LocalPlayer);
    else
        v43 = v41;
    end;

    local v44;

    if v41 then
        v44 = SurvivalDowned2.IsReviving(LocalPlayer);
    else
        v44 = v41;
    end;

    if u4 and (v44 or os_clock_ret - u5 > 0.6) then
        u4 = nil;
    end;

    local v45;

    if v41 then
        local CurrentEquipped = InventoryController.getCurrentEquipped();
        local v46;

        if CurrentEquipped then
            v46 = CurrentEquipped.Properties.Slot;
        else
            v46 = nil;
        end;

        v45 = not SurvivalDowned2.CanUseSlot(LocalPlayer, v46) and (v44 and "Lowered" or "Hidden") or nil;
    else
        v45 = nil;
    end;

    if v45 and not u6 then
        releaseHands();
    end;

    poseViewmodel(v45);
    u6 = v45;
    updateDesaturation(v43, p40);

    if v41 then
        SurvivalDowned.Update(u3);
    else
        SurvivalDowned.Hide();
    end;

    if not (isActive() or (u11 ~= 0 or (u7 ~= nil or next(u2) ~= nil))) then
        if u12 then
            u12:Disconnect();
            u12 = nil;
        end;

        u3 = nil;
        SurvivalDowned.Hide();
    end;
end;

local function evaluateUpdating() -- Line: 342
    -- upvalues: u12 (ref), isActive (copy), u9 (ref), RunServiceController (copy), update (copy)
    if not u12 and isActive() then
        u9 = 0;
        u12 = RunServiceController.BindToRenderSteppedEvent("SurvivalDownedController.Update", update);
    end;
end;

local function watchPlayer(p47: userdata) -- Line: 349
    -- upvalues: SurvivalDowned2 (copy), evaluateUpdating (copy)
    p47:GetAttributeChangedSignal(SurvivalDowned2.DOWNED_ATTRIBUTE):Connect(evaluateUpdating);
    p47:GetAttributeChangedSignal(SurvivalDowned2.REVIVING_ATTRIBUTE):Connect(evaluateUpdating);
end;

function v1.WantsUse() -- Line: 359
    -- upvalues: u3 (ref), SurvivalDowned2 (copy), LocalPlayer (copy)
    return u3 ~= nil and true or SurvivalDowned2.IsReviving(LocalPlayer);
end;

function v1.TryStartRevive() -- Line: 365
    -- upvalues: IsSurvivalMode (copy), SurvivalDowned2 (copy), LocalPlayer (copy), findReviveTarget (copy), u4 (ref), u5 (ref), Remotes (copy), u12 (ref), isActive (copy), u9 (ref), RunServiceController (copy), update (copy)
    if not IsSurvivalMode() or SurvivalDowned2.AreHandsBusy(LocalPlayer) then
        return false;
    end;

    local v48 = findReviveTarget();

    if not v48 then
        return false;
    end;

    local os_clock_ret = os.clock();
    u4 = v48;
    u5 = os_clock_ret;
    Remotes.Survival.StartRevive.Send({
        Target = v48.UserId
    });

    if not u12 and isActive() then
        u9 = 0;
        u12 = RunServiceController.BindToRenderSteppedEvent("SurvivalDownedController.Update", update);
    end;

    return true;
end;

function v1.StopRevive() -- Line: 380
    -- upvalues: u4 (ref), SurvivalDowned2 (copy), LocalPlayer (copy), Remotes (copy)
    if u4 or SurvivalDowned2.IsReviving(LocalPlayer) then
        u4 = nil;
        Remotes.Survival.CancelRevive.Send();
    end;
end;

function v1.Start() -- Line: 390
    -- upvalues: InventoryController (copy), u6 (ref), SurvivalDowned2 (copy), LocalPlayer (copy), releaseHands (copy), poseViewmodel (copy), Players (copy), evaluateUpdating (copy), watchPlayer (copy), u12 (ref), isActive (copy), u9 (ref), RunServiceController (copy), update (copy)
    InventoryController.OnInventoryItemEquipped:Connect(function() -- Line: 393
        -- upvalues: u6 (ref), InventoryController (ref), SurvivalDowned2 (ref), LocalPlayer (ref), releaseHands (ref), poseViewmodel (ref)
        if u6 then
            local CurrentEquipped = InventoryController.getCurrentEquipped();
            local v49;

            if CurrentEquipped then
                v49 = CurrentEquipped.Properties.Slot;
            else
                v49 = nil;
            end;

            if not SurvivalDowned2.CanUseSlot(LocalPlayer, v49) then
                releaseHands();
                poseViewmodel(u6);
            end;
        end;
    end);

    for _, v in Players:GetPlayers() do
        v:GetAttributeChangedSignal(SurvivalDowned2.DOWNED_ATTRIBUTE):Connect(evaluateUpdating);
        v:GetAttributeChangedSignal(SurvivalDowned2.REVIVING_ATTRIBUTE):Connect(evaluateUpdating);
    end;

    Players.PlayerAdded:Connect(watchPlayer);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(evaluateUpdating);

    if not u12 and isActive() then
        u9 = 0;
        u12 = RunServiceController.BindToRenderSteppedEvent("SurvivalDownedController.Update", update);
    end;
end;

return v1;