-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local GetWeaponCameraKick = require(ReplicatedStorage.Components.Common.GetWeaponCameraKick);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera);
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam);
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer);
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local Freecam = require(ReplicatedStorage.Classes.Freecam);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Bullet = require(ReplicatedStorage.Components.Weapon.Classes.Bullet);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Spring = require(ReplicatedStorage.Shared.Spring);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Debris = workspace:WaitForChild("Debris");
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u2 = {
    ["Heavy Swing"] = true,
    BackStab = true,
    Swing1 = true,
    Swing2 = true,
    Inspect = true,
    Reload = true,
    Throw = true,
    Use = true
};
local u3 = {
    NoSuppressorShoot = true,
    ShootRight = true,
    ShootLeft = true,
    Shoot = true,
    SlamFire = true
};
local u4 = { 37, 60 };
local u5 = {
    ["Right Arm"] = true,
    ["Left Arm"] = true,
    HumanoidRootPart = true,
    ViewmodelLight = true
};

local function isInspectVariantEvent(p6: string) -- Line: 108
    return p6 == "Inspect" and true or string.match(p6, "^Inspect%d+$") ~= nil;
end;

local function getTransparencyState(p7: any, p8: userdata) -- Line: 112
    local v9 = p7.Transparencies[p8];

    if not v9 then
        v9 = {
            Transparency = p8.Transparency,
            Textures = {}
        };
        p7.Transparencies[p8] = v9;
    end;

    return v9;
end;

local function cacheAndHideInstance(p10: any, p11: userdata) -- Line: 124
    -- upvalues: getTransparencyState (copy)
    if p11:IsA("BasePart") then
        local v12 = getTransparencyState(p10, p11);

        for _, child in p11:GetChildren() do
            if child:IsA("Texture") and not table.find(v12.Textures, child) then
                table.insert(v12.Textures, child);
                child.Parent = nil;
            end;
        end;

        if p11.Transparency < 1 then
            p11.Transparency = 1;
        end;
    elseif p11:IsA("Texture") then
        local Parent = p11.Parent;

        if Parent and Parent:IsA("BasePart") then
            local v13 = getTransparencyState(p10, Parent);

            if not table.find(v13.Textures, p11) then
                table.insert(v13.Textures, p11);
            end;

            p11.Parent = nil;
        end;
    elseif p11:IsA("BillboardGui") then
        p11.Enabled = false;
    end;
end;

local function updateSpectatedRevolverFireMode(p14: any, p15: string) -- Line: 151
    if not (p14 and (p14.Bullet and p14.Properties.ShootingOptions == "Revolver")) then
        return;
    end;

    local FireModes = p14.Properties.FireModes;

    if FireModes then
        FireModes = p15 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    end;

    p14.Bullet:setSpreadConfig(FireModes and FireModes.Spread or p14.Properties.Spread);
end;

local function clearSpectatedRevolverChargeState(p16) -- Line: 162
    if p16 and (p16.Bullet and p16.Properties.ShootingOptions == "Revolver") then
        local FireModes = p16.Properties.FireModes;

        if FireModes then
            FireModes = FireModes.Secondary or FireModes.Primary;
        end;

        p16.Bullet:setSpreadConfig(FireModes and FireModes.Spread or p16.Properties.Spread);
    end;

    p16.IsChargeFiring = false;
    p16.ChargeStartTick = 0;
end;

local function syncSpectatedWeaponState(p17, p18) -- Line: 168
    if not p17 then
        return;
    end;

    p17.IsSuppressed = p18.IsSuppressed;
    p17.Rounds = p18.Rounds;
    p17.Capacity = p18.Capacity;
    p17.RechargeStartTime = p18.RechargeStartTime;
end;

local function syncSpectatedRechargeAfterShot(p19) -- Line: 179
    if not (p19 and (p19.Properties and p19.Properties.RechargeTime)) then
        return;
    end;

    local v20 = tonumber(p19.Properties.Rounds) or 0;
    local v21 = (tonumber(p19.Rounds) or v20) - 1;
    p19.Rounds = math.max(v21, 0);
    p19.RechargeStartTime = workspace:GetServerTimeNow();
end;

local function recreateSpectatedShotEffects(p22) -- Line: 191
    -- upvalues: workspace_CurrentCamera (copy), Debris (copy), RaycastParams_new_ret (copy), CreateTracer (copy), CreateZeusBeam (copy), DataController (copy), LocalPlayer (copy), Camera (copy)
    local v23 = { p22.Character, workspace_CurrentCamera, Debris };
    local Map = workspace:FindFirstChild("Map");
    local v24;

    if Map then
        v24 = Map:FindFirstChild("Barriers");
    else
        v24 = nil;
    end;

    if v24 then
        table.insert(v23, v24);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v23;
    local WeaponComponent2 = p22.WeaponComponent;
    local v25;

    if WeaponComponent2 then
        v25 = WeaponComponent2.Bullet;
    else
        v25 = WeaponComponent2;
    end;

    if v25 and v25._updateShotSpread then
        v25:_updateShotSpread(WeaponComponent2.Properties.AimingOptions, WeaponComponent2.IsAiming);
    end;

    local v26 = workspace:Raycast(workspace_CurrentCamera.CFrame.Position, workspace_CurrentCamera.CFrame.LookVector * p22.WeaponComponent.Properties.Range, RaycastParams_new_ret);
    local v27 = v26 and v26.Distance or p22.WeaponComponent.Properties.Range;
    local MuzzlePart = p22.WeaponComponent.Viewmodel.Model.Interactables:FindFirstChild("MuzzlePart");

    if MuzzlePart then
        CreateTracer(v27, MuzzlePart.Position, workspace_CurrentCamera.CFrame.LookVector);

        if p22.WeaponComponent.Properties.MuzzleType == "Zeus x27" then
            CreateZeusBeam(MuzzlePart);
        end;

        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false then
            local Properties = p22.WeaponComponent.Properties;
            Camera(MuzzlePart, Properties.HasSuppressor and p22.CurrentEquipped.IsSuppressed and "Suppressor" or Properties.MuzzleType);
        end;
    end;
end;

local function getPresentedView(p28) -- Line: 229
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(p28.Player) or p28.CameraPart.CFrame;
end;

local function destroyFreecam(p29) -- Line: 234
    if p29.FreecamInstance then
        p29.FreecamInstance:Stop();
        p29.FreecamInstance:Destroy();
        p29.FreecamInstance = nil;
    end;
end;

local function destroyWeaponComponent(p30) -- Line: 242
    if p30.Bullet then
        p30.Bullet:destroy();
        p30.Bullet = nil;
    end;

    if p30.Janitor then
        p30.Janitor:Destroy();
    end;
end;

local function destroySpectatedWeaponComponent(p31) -- Line: 254
    if p31.WeaponComponent then
        local WeaponComponent2 = p31.WeaponComponent;

        if WeaponComponent2.Bullet then
            WeaponComponent2.Bullet:destroy();
            WeaponComponent2.Bullet = nil;
        end;

        if WeaponComponent2.Janitor then
            WeaponComponent2.Janitor:Destroy();
        end;

        p31.WeaponComponent = nil;
    end;

    for _, v in p31.ParkedWeapons do
        if v.Bullet then
            v.Bullet:destroy();
            v.Bullet = nil;
        end;

        if v.Janitor then
            v.Janitor:Destroy();
        end;
    end;

    table.clear(p31.ParkedWeapons);
    table.clear(p31.ParkedOrder);
end;

local function parkSpectatedWeaponComponent(p32) -- Line: 267
    local WeaponComponent2 = p32.WeaponComponent;
    p32.WeaponComponent = nil;
    local Viewmodel = WeaponComponent2.Viewmodel;
    local Identifier = WeaponComponent2.Identifier;

    if not (Viewmodel and (Identifier and not p32.ParkedWeapons[Identifier])) then
        if WeaponComponent2.Bullet then
            WeaponComponent2.Bullet:destroy();
            WeaponComponent2.Bullet = nil;
        end;

        if WeaponComponent2.Janitor then
            WeaponComponent2.Janitor:Destroy();
        end;

        return;
    end;

    if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
        local FireModes = WeaponComponent2.Properties.FireModes;

        if FireModes then
            FireModes = FireModes.Secondary or FireModes.Primary;
        end;

        WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
    end;

    WeaponComponent2.IsChargeFiring = false;
    WeaponComponent2.ChargeStartTick = 0;

    if WeaponComponent2.CharacterAnimator then
        WeaponComponent2.CharacterAnimator:destroy();
        WeaponComponent2.CharacterAnimator = nil;
    end;

    if Viewmodel.Bobble and Viewmodel.Bobble.IsAiming then
        Viewmodel:unaim();
    end;

    Viewmodel:unequip();
    p32.ParkedWeapons[Identifier] = WeaponComponent2;
    table.insert(p32.ParkedOrder, Identifier);

    if #p32.ParkedOrder > 6 then
        local table_remove_ret = table.remove(p32.ParkedOrder, 1);
        local v33 = p32.ParkedWeapons[table_remove_ret];

        if v33.Bullet then
            v33.Bullet:destroy();
            v33.Bullet = nil;
        end;

        if v33.Janitor then
            v33.Janitor:Destroy();
        end;

        p32.ParkedWeapons[table_remove_ret] = nil;
    end;
end;

local function takeParkedWeaponComponent(p34: any, p35: string) -- Line: 297
    local v36 = p34.ParkedWeapons[p35];

    if v36 then
        p34.ParkedWeapons[p35] = nil;
        table.remove(p34.ParkedOrder, (table.find(p34.ParkedOrder, p35)));
    end;

    return v36;
end;

function u1.UpdateCameraCFrame(p37: any, p38) -- Line: 309
    -- upvalues: Spring (copy)
    if p37.CameraPositionSpring and p37.CameraRotationSpring then
        if (p38.Position - p37.CameraPositionSpring:getPosition()).Magnitude > 8 then
            p37.CameraRotationSpring:reset(p38.LookVector);
            p37.CameraPositionSpring:reset(p38.Position);
        end;
    else
        p37.CameraRotationSpring = Spring.new(1, 35, p38.LookVector);
        p37.CameraPositionSpring = Spring.new(1, 35, p38.Position);
    end;

    p37.CameraRotationSpring:setGoal(p38.LookVector);
    p37.CameraPositionSpring:setGoal(p38.Position);
end;

function u1.UpdateSuppressorState(p39, p40) -- Line: 324
    local Silencer = p40.Viewmodel.Model:FindFirstChild("Silencer", true);

    if Silencer and p40.Properties.HasSuppressor then
        Silencer.Transparency = p39.CurrentEquipped.IsSuppressed and 0 or 1;
    end;
end;

function u1.UpdateSuppressor(p41) -- Line: 333
    if not (p41.WeaponComponent and p41.WeaponComponent.Viewmodel) then
        return;
    end;

    local Silencer = p41.WeaponComponent.Viewmodel.Model:FindFirstChild("Silencer", true);

    if not Silencer then
        return;
    end;

    local Animation = p41.WeaponComponent.Viewmodel.Animation;
    local Animation2 = Animation:getAnimation("RemoveSuppressor");
    local Animation3 = Animation:getAnimation("AddSuppressor");
    local Janitor2 = p41.WeaponComponent.Janitor;

    if Janitor2 then
        local function connectEnded(p42: userdata, u43: boolean) -- Line: 346
            -- upvalues: Janitor2 (copy), Silencer (copy)
            Janitor2:Add(p42.Ended:Connect(function() -- Line: 347
                -- upvalues: u43 (copy), Silencer (ref)
                if u43 == (Silencer.Transparency < 1) then
                    Silencer.Transparency = u43 and 0 or 1;
                end;
            end));
        end;

        Janitor2:Add(Animation2:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 354
            -- upvalues: Silencer (copy)
            Silencer.Transparency = 1;
        end));
        local u44 = false;
        Janitor2:Add(Animation2.Ended:Connect(function() -- Line: 347
            -- upvalues: u44 (copy), Silencer (copy)
            if u44 == (Silencer.Transparency < 1) then
                Silencer.Transparency = u44 and 0 or 1;
            end;
        end));
        Janitor2:Add(Animation3:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 358
            -- upvalues: Animation3 (copy), Silencer (copy)
            if Animation3.IsPlaying then
                task.delay(0.016666666666666666, function() -- Line: 360
                    -- upvalues: Silencer (ref)
                    Silencer.Transparency = 0;
                end);
            end;
        end));
        local u45 = true;
        Janitor2:Add(Animation3.Ended:Connect(function() -- Line: 347
            -- upvalues: u45 (copy), Silencer (copy)
            if u45 == (Silencer.Transparency < 1) then
                Silencer.Transparency = u45 and 0 or 1;
            end;
        end));
    end;

    p41:UpdateSuppressorState(p41.WeaponComponent);
end;

function u1.Switch(p46, p47) -- Line: 373
    -- upvalues: CharacterResolver (copy), workspace_CurrentCamera (copy), CameraController (copy), destroySpectatedWeaponComponent (copy), Constants (copy), Freecam (copy), Remotes (copy)
    if not CharacterResolver.isAliveCharacter(p46.Character) then
        if p46.Character.Parent ~= nil and not p46.Character:IsDescendantOf(workspace) then
            p46.PendingPerspective = p47;
            workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        end;

        return;
    end;

    p46.PendingPerspective = nil;
    p46.PerspectiveState = p47;

    if p46.FreecamInstance then
        p46.FreecamInstance:Stop();
        p46.FreecamInstance:Destroy();
        p46.FreecamInstance = nil;
    end;

    if p47 == "First-Person" then
        p46.TransparencyState = true;
        p46:SetCharacterTransparency(true);
        workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        workspace_CurrentCamera.CameraSubject = p46.CameraPart;

        if p46.CurrentEquipped then
            p46:SetEquipped(p46.CurrentEquipped, false);
        end;

        p46:UpdateScopeState();
        CameraController.setPerspective(true, false);
    elseif p47 == "Third-Person" or p47 == "Free-Cam" then
        p46.TransparencyState = false;
        p46:SetCharacterTransparency(false);

        if p47 == "Third-Person" then
            workspace_CurrentCamera.CameraType = Enum.CameraType.Follow;
            workspace_CurrentCamera.CameraSubject = p46.CameraPart;
        end;

        destroySpectatedWeaponComponent(p46);
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);

        if p47 == "Third-Person" then
            CameraController.setPerspective(false, false, 8);
        else
            local v48 = p46.Janitor:Add(Freecam.new());
            p46.FreecamInstance = v48;
            v48:Start();
        end;
    end;

    Remotes.Spectate.SetSpectatePerspective.Send(p46.PerspectiveState);
end;

function u1.SetEquipped(u49: any, p50: any, p51: boolean) -- Line: 429
    -- upvalues: parkSpectatedWeaponComponent (copy), WeaponComponent (copy), Participants (copy), Bullet (copy)
    local v52 = u49.WeaponComponent and u49.WeaponComponent.Identifier;
    u49.CurrentEquipped = p50;

    if v52 == p50.Identifier then
        local WeaponComponent2 = u49.WeaponComponent;

        if WeaponComponent2 then
            WeaponComponent2.IsSuppressed = p50.IsSuppressed;
            WeaponComponent2.Rounds = p50.Rounds;
            WeaponComponent2.Capacity = p50.Capacity;
            WeaponComponent2.RechargeStartTime = p50.RechargeStartTime;
        end;

        u49:UpdateSuppressorState(u49.WeaponComponent);

        return;
    end;

    if u49.WeaponComponent then
        u49:SetWeaponViewmodelTransparency(false);
        parkSpectatedWeaponComponent(u49);
    end;

    if u49.PerspectiveState == "First-Person" then
        local Identifier = p50.Identifier;
        local v53 = u49.ParkedWeapons[Identifier];

        if v53 then
            u49.ParkedWeapons[Identifier] = nil;
            table.remove(u49.ParkedOrder, (table.find(u49.ParkedOrder, Identifier)));
        end;

        if v53 then
            if v53.StatTrack ~= p50.StatTrack then
                v53:updateStatTrackCounter(p50.StatTrack);
            end;

            if v53 then
                v53.IsSuppressed = p50.IsSuppressed;
                v53.Rounds = p50.Rounds;
                v53.Capacity = p50.Capacity;
                v53.RechargeStartTime = p50.RechargeStartTime;
            end;

            u49.WeaponComponent = v53;
            u49.TransparencyState = true;
            u49:SetCharacterTransparency(true);
            v53.Viewmodel:equip(not p51);

            if v53.Properties.HasSuppressor then
                u49:UpdateSuppressorState(v53);
            end;

            u49:UpdateScopeState();
            u49.CurrentEquippedChanged:Fire(u49.CurrentEquipped);

            return;
        end;

        local success, result = pcall(function() -- Line: 466
            -- upvalues: WeaponComponent (ref), u49 (copy)
            local v54;

            if u49.IsBot then
                v54 = u49.Character;
            else
                v54 = nil;
            end;

            return WeaponComponent.new(u49.Player, u49.CurrentEquipped.Identifier, u49.CurrentEquipped._id, 1, u49.CurrentEquipped.Name, u49.CurrentEquipped.Skin, u49.CurrentEquipped.Float, u49.CurrentEquipped.StatTrack, u49.CurrentEquipped.NameTag, u49.CurrentEquipped.OriginalOwner, u49.CurrentEquipped.Charm, u49.CurrentEquipped.Stickers, v54);
        end);

        if not (success and result) then
            warn((`[Spectate] Failed to create viewmodel for {Participants.Name(u49.Player)} ({u49.CurrentEquipped.Name} | {u49.CurrentEquipped.Skin}): {tostring(result)}`));
            u49.TransparencyState = false;

            if not pcall(function() -- Line: 493
                -- upvalues: u49 (copy)
                u49:SetCharacterTransparency(false);
            end) then
                warn("[Spectate] Failed to restore character transparency after viewmodel creation failure");
            end;

            u49:Switch("Third-Person");
            u49.CurrentEquippedChanged:Fire(u49.CurrentEquipped);

            return;
        end;

        if result.Properties and result.Properties.Spread then
            local v55 = Bullet.new(result, result.Properties);
            result.Bullet = v55;

            if result.Janitor then
                result.Janitor:Add(v55, "destroy", "SpectateBullet");
            end;
        end;

        if result then
            result.IsSuppressed = p50.IsSuppressed;
            result.Rounds = p50.Rounds;
            result.Capacity = p50.Capacity;
            result.RechargeStartTime = p50.RechargeStartTime;
        end;

        u49.WeaponComponent = result;
        u49.TransparencyState = true;
        u49:SetCharacterTransparency(true);
        local Viewmodel = result.Viewmodel;

        if Viewmodel then
            Viewmodel:equip(not p51);

            if result.Properties.HasSuppressor then
                u49:UpdateSuppressor();
            end;
        end;

        u49:UpdateScopeState();
    end;

    u49.CurrentEquippedChanged:Fire(u49.CurrentEquipped);
end;

function u1.UpdateScopeState(p56) -- Line: 536
    -- upvalues: CameraController (copy), Constants (copy), u4 (copy)
    if p56.PerspectiveState ~= "First-Person" or not p56.CurrentEquipped then
        return;
    end;

    local Name = p56.CurrentEquipped.Name;
    local v57 = Name == "AUG" and true or Name == "SG 553";
    local v58;

    if p56.IsBot then
        v58 = p56.Character;
    else
        v58 = p56.Player;
    end;

    local v59 = v58:GetAttribute("ScopeIncrement") or 0;
    local v60 = v59 > 0;
    local v61 = p56.WeaponComponent and p56.WeaponComponent.Viewmodel;

    if not (Name == "AWP" and true or Name == "SSG 08") then
        if v57 then
            if v61 then
                if v60 then
                    if not v61.Hidden then
                        v61:hide();
                    end;

                    if v61.Bobble and (v61.Bobble.Scope and v61.Bobble.ScopeReticlePart) then
                        v61:aim();
                    end;

                    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15);

                    return;
                end;

                if v61.Hidden then
                    v61:unhide();
                end;

                if v61.Bobble and (v61.Bobble.Scope and v61.Bobble.ScopeReticlePart) then
                    v61:unaim();
                end;

                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);

                return;
            end;
        else
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            p56:SetWeaponViewmodelTransparency(false);
        end;

        return;
    end;

    local v62 = v61 and v61.Bobble and v61.Bobble.ScopeReticlePart;

    if v62 then
        v62 = v62:FindFirstChildOfClass("SurfaceGui");
    end;

    if v62 then
        v62.Enabled = false;
    end;

    if v60 then
        v60 = v59 <= 2;
    end;

    local v63;

    if v60 then
        v63 = Constants.DEFAULT_CAMERA_FOV - u4[v59];
    else
        v63 = Constants.DEFAULT_CAMERA_FOV;
    end;

    CameraController.updateCameraFOV(v63);
    p56:SetWeaponViewmodelTransparency(v60);
end;

function u1.SetWeaponViewmodelTransparency(p64: any, p65: boolean) -- Line: 592
    -- upvalues: u5 (copy)
    if not (p64.WeaponComponent and (p64.WeaponComponent.Viewmodel and p64.WeaponComponent.Viewmodel.Model)) then
        return;
    end;

    local Model = p64.WeaponComponent.Viewmodel.Model;

    if not p64.WeaponTransparencyCache then
        p64.WeaponTransparencyCache = {};
    end;

    for _, descendant in ipairs(Model:GetDescendants()) do
        if descendant:IsA("BasePart") and not u5[descendant.Name] then
            if p65 then
                if not p64.WeaponTransparencyCache[descendant] then
                    p64.WeaponTransparencyCache[descendant] = descendant.Transparency;
                end;

                descendant.Transparency = 1;
            else
                local v66 = p64.WeaponTransparencyCache[descendant];

                if v66 ~= nil then
                    descendant.Transparency = v66;
                    p64.WeaponTransparencyCache[descendant] = nil;
                end;
            end;
        end;
    end;
end;

function u1.SetCharacterTransparency(u67: any, p68: boolean) -- Line: 623
    -- upvalues: Janitor (copy), cacheAndHideInstance (copy), RemoveFromArray (copy)
    local Descendants = u67.Character:GetDescendants();

    if u67.IsBot then
        u67.Character:SetAttribute("SpectatedFirstPerson", p68 and true or nil);
    end;

    if p68 then
        if not u67.TransparencyJanitor then
            local v69 = u67.Janitor:Add(Janitor.new());
            u67.TransparencyJanitor = v69;
            v69:Add(u67.Character.DescendantAdded:Connect(function(p70: userdata) -- Line: 635
                -- upvalues: u67 (copy), cacheAndHideInstance (ref)
                if u67.TransparencyState then
                    cacheAndHideInstance(u67, p70);
                end;
            end));
        end;

        for _, v in ipairs(Descendants) do
            cacheAndHideInstance(u67, v);
        end;

        return;
    end;

    if u67.TransparencyJanitor then
        u67.TransparencyJanitor:Destroy();
        u67.TransparencyJanitor = nil;
    end;

    for i, v in pairs(u67.Transparencies) do
        if i and i.Parent then
            i.Transparency = v.Transparency;
            RemoveFromArray(v.Textures, function(p71: any, p72: userdata) -- Line: 654
                -- upvalues: i (copy)
                p72.Parent = i;

                return true;
            end);
        end;
    end;

    for _, v in ipairs(Descendants) do
        if v:IsA("BillboardGui") then
            v.Enabled = true;
        end;
    end;
end;

function u1.AddSpectateEvent(p73: any, p74: string) -- Line: 671
    -- upvalues: recreateSpectatedShotEffects (copy), u3 (copy), GetWeaponCameraKick (copy), syncSpectatedRechargeAfterShot (copy), u2 (copy)
    if not (p73.WeaponComponent and p73.WeaponComponent.Viewmodel) then
        return;
    end;

    local Animation = p73.WeaponComponent.Viewmodel.Animation;
    local WeaponComponent2 = p73.WeaponComponent;

    if p74 == "RevolverChargeStart" then
        if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
            local FireModes = WeaponComponent2.Properties.FireModes;

            if FireModes then
                FireModes = FireModes.Primary;
            end;

            WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
        end;

        WeaponComponent2.IsChargeFiring = true;
        WeaponComponent2.ChargeStartTick = tick();
        Animation:stopAnimations();
        Animation:play("Shoot");
        Animation:play("Idle");

        return;
    end;

    if p74 == "RevolverChargeCancel" then
        if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
            local FireModes = WeaponComponent2.Properties.FireModes;

            if FireModes then
                FireModes = FireModes.Secondary or FireModes.Primary;
            end;

            WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
        end;

        WeaponComponent2.IsChargeFiring = false;
        WeaponComponent2.ChargeStartTick = 0;
        Animation:stopAnimations();
        Animation:play("Idle");

        return;
    end;

    if p74 ~= "RevolverChargeRelease" then
        if u3[p74] then
            if p73.IsBot then
                local CameraShake = WeaponComponent2.Viewmodel.Model:FindFirstChild("CameraShake");

                if CameraShake then
                    local v75, v76 = GetWeaponCameraKick(CameraShake);
                    p73.KickRotationSpring:setDampingRatio(v75.Damper);
                    p73.KickRotationSpring:setFrequency(v75.Speed);
                    p73.KickRotationSpring:setPosition(v75.Value * 0.017453292519943295);
                    p73.KickPositionSpring:setDampingRatio(v76.Damper);
                    p73.KickPositionSpring:setFrequency(v76.Speed);
                    p73.KickPositionSpring:setPosition(v76.Value);
                end;

                WeaponComponent2.Viewmodel.Bobble:addScopeKick();
            end;

            if WeaponComponent2.Properties.ShootingOptions == "Revolver" then
                local v77 = p74 == "SlamFire" and "Secondary" or "Primary";

                if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                    local FireModes = WeaponComponent2.Properties.FireModes;

                    if FireModes then
                        FireModes = v77 == "Secondary" and FireModes.Secondary or FireModes.Primary;
                    end;

                    WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
                end;

                if v77 == "Secondary" then
                    if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                        local FireModes = WeaponComponent2.Properties.FireModes;

                        if FireModes then
                            FireModes = FireModes.Secondary or FireModes.Primary;
                        end;

                        WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
                    end;

                    WeaponComponent2.IsChargeFiring = false;
                    WeaponComponent2.ChargeStartTick = 0;
                else
                    WeaponComponent2.IsChargeFiring = false;
                    WeaponComponent2.ChargeStartTick = 0;
                end;
            end;

            syncSpectatedRechargeAfterShot(WeaponComponent2);
            local v78 = not Animation:getAnimation(p74) and "Shoot" or p74;
            Animation:stopAnimations();
            Animation:play(v78);
            Animation:play("Idle");
            recreateSpectatedShotEffects(p73);

            if WeaponComponent2.Properties.ShootingOptions == "Revolver" and p74 ~= "SlamFire" then
                if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                    local FireModes = WeaponComponent2.Properties.FireModes;

                    if FireModes then
                        FireModes = FireModes.Secondary or FireModes.Primary;
                    end;

                    WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
                end;

                WeaponComponent2.IsChargeFiring = false;
                WeaponComponent2.ChargeStartTick = 0;

                return;
            end;
        else
            if p74 == "Remove Suppressor" or p74 == "Add Suppressor" then
                Animation:stopAnimations();
                Animation:play(string.gsub(p74, " ", ""));
                Animation:play("Idle");

                return;
            end;

            if p74 == "Switch Fire Mode" then
                Animation:stopAnimations();
                Animation:play("Switch");
                Animation:play("Idle");

                return;
            end;

            if p74 == "StartThrow" then
                Animation:stopAnimations();
                Animation:play("StartThrow");
                local v79 = Animation:play("ThrowIdle");

                if v79 then
                    v79.Looped = true;

                    return;
                end;
            else
                if p74 == "Cancel Plant" or p74 == "CancelThrow" then
                    Animation:stopAnimations();
                    Animation:play("Idle");

                    return;
                end;

                if u2[p74] or (p74 == "Inspect" or string.match(p74, "^Inspect%d+$") ~= nil) then
                    local v80 = (p74 == "Inspect" and true or string.match(p74, "^Inspect%d+$") ~= nil) and not Animation:getAnimation(p74) and "Inspect" or p74;
                    Animation:stopAnimations();
                    Animation:play(v80);
                    Animation:play("Idle");
                end;
            end;
        end;

        return;
    end;

    if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
        local FireModes = WeaponComponent2.Properties.FireModes;

        if FireModes then
            FireModes = FireModes.Primary;
        end;

        WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
    end;

    recreateSpectatedShotEffects(p73);

    if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
        local FireModes = WeaponComponent2.Properties.FireModes;

        if FireModes then
            FireModes = FireModes.Secondary or FireModes.Primary;
        end;

        WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
    end;

    WeaponComponent2.IsChargeFiring = false;
    WeaponComponent2.ChargeStartTick = 0;
end;

local function updateSpectatorAutomaticScope(p81: any, p82: number) -- Line: 758
    if p81.PerspectiveState ~= "First-Person" or not p81.CurrentEquipped then
        return;
    end;

    local Name = p81.CurrentEquipped.Name;

    if Name ~= "AUG" and Name ~= "SG 553" then
        return;
    end;

    local v83;

    if p81.IsBot then
        v83 = p81.Character;
    else
        v83 = p81.Player;
    end;

    if (v83:GetAttribute("ScopeIncrement") or 0) <= 0 then
        return;
    end;

    local WeaponComponent2 = p81.WeaponComponent;
    local v84;

    if WeaponComponent2 then
        v84 = WeaponComponent2.Viewmodel;
    else
        v84 = WeaponComponent2;
    end;

    if not (v84 and (v84.Bobble and (v84.Bobble.IsAiming and WeaponComponent2.Bullet))) then
        return;
    end;

    local v85 = WeaponComponent2.Bullet:getBaseSpread() or 0;
    local math_abs_ret = math.abs(v85 - (p81.LastSpreadValue or 0));
    local v86 = (p81.LastScopeUpdateTime or 0) + p82;

    if math_abs_ret < 0.01 and v86 < 0.03333333333333333 then
        p81.LastScopeUpdateTime = v86;

        return;
    end;

    p81.LastScopeUpdateTime = 0;
    p81.LastSpreadValue = v85;
    local ScopeReticlePart = v84.Bobble.ScopeReticlePart;

    if ScopeReticlePart then
        ScopeReticlePart = ScopeReticlePart:FindFirstChildOfClass("SurfaceGui");
    end;

    if ScopeReticlePart then
        ScopeReticlePart = ScopeReticlePart:FindFirstChild("Frame");
    end;

    if ScopeReticlePart then
        ScopeReticlePart = ScopeReticlePart:FindFirstChild("Frame");
    end;

    if ScopeReticlePart then
        local v87 = math.clamp(v85, 0, 2) * 2;
        ScopeReticlePart.Size = UDim2.fromScale(v87 + 2.5, v87 + 2.5);
        ScopeReticlePart.Position = UDim2.fromScale(0.5, 0.5);
    end;
end;

function u1.Render(p88: any, p89: number, p90) -- Line: 805
    -- upvalues: ReplicatedStorage (copy), CharacterGeneration (copy), workspace_CurrentCamera (copy), CameraController (copy), updateSpectatorAutomaticScope (copy)
    if p88.PerspectiveState == "Free-Cam" then
        return;
    end;

    if not p90 and p88.IsBot then
        local BotCharacters = require(ReplicatedStorage.Controllers.CharacterController.BotCharacters);
        local Attribute = p88.Character:GetAttribute("ActorId");
        local v91 = CharacterGeneration.Get(p88.Character);

        if type(Attribute) == "number" and v91 then
            p90 = BotCharacters.GetCamera(Attribute, v91);
        end;
    end;

    if not (p90 or (p88.IsBot or p88.HasRemoteCamera)) then
        p90 = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(p88.Player);
    end;

    if p90 then
        p88:UpdateCameraCFrame(p90);
    end;

    if p88.CameraPositionSpring and p88.CameraRotationSpring then
        p88.CameraPositionSpring:update(p89);
        p88.CameraRotationSpring:update(p89);

        if p88.PerspectiveState == "First-Person" then
            workspace_CurrentCamera.CFrame = CFrame.lookAt(p88.CameraPositionSpring:getPosition(), p88.CameraPositionSpring:getPosition() + p88.CameraRotationSpring:getPosition());

            if p90 then
                workspace_CurrentCamera.CFrame = p90;
            end;

            if p88.IsBot then
                p88.KickRotationSpring:update(p89);
                p88.KickPositionSpring:update(p89);
                local Position = p88.KickRotationSpring:getPosition();
                local v92 = workspace_CurrentCamera;
                v92.CFrame = v92.CFrame * (CFrame.new(p88.KickPositionSpring:getPosition()) * CFrame.Angles(Position.X, Position.Y, Position.Z));
                workspace_CurrentCamera.FieldOfView = CameraController.getTargetFOV();
            end;

            if p88.WeaponComponent and p88.WeaponComponent.Viewmodel then
                p88.WeaponComponent.Viewmodel:render(p89);
            end;

            local WeaponComponent2 = p88.WeaponComponent;

            if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Bullet.updateSpread) then
                WeaponComponent2.Bullet:updateSpread(p89);
            end;

            updateSpectatorAutomaticScope(p88, p89);
        end;
    end;
end;

function u1.new(p93: userdata, p94: userdata, p95: any, p96: boolean?) -- Line: 866
    -- upvalues: u1 (copy), CharacterResolver (copy), Participants (copy), Janitor (copy), Signal (copy), Spring (copy), workspace_CurrentCamera (copy), ReplicatedStorage (copy), LocalPlayer (copy), HttpService (copy), Remotes (copy), Ragdoll (copy), CameraController (copy), Constants (copy), destroySpectatedWeaponComponent (copy)
    local u97 = setmetatable({}, u1);
    local v98 = CharacterResolver.resolve(p94);
    local v99 = `[Spectate] Invalid player character rig for {Participants.Name(p93)}`;
    assert(v98, v99);
    local v100 = p95 or "First-Person";
    u97.Janitor = Janitor.new();
    u97.CurrentEquippedChanged = u97.Janitor:Add(Signal.new());
    u97.StopSpectating = u97.Janitor:Add(Signal.new());
    u97.RootPart = v98.RootPart;
    u97.CameraPart = v98.CameraPart;
    u97.Character = p94;
    u97.Player = p93;
    u97.IsBot = p96 == true;
    u97.KickRotationSpring = Spring.new(1, 1, Vector3.new(0, 0, 0));
    u97.KickPositionSpring = Spring.new(1, 1, Vector3.new(0, 0, 0));
    u97.PerspectiveState = v100;
    u97.TransparencyState = v100 == "First-Person";
    u97.Transparencies = {};
    u97.WeaponTransparencyCache = {};
    u97.ParkedWeapons = {};
    u97.ParkedOrder = {};
    u97.LastScopeUpdateTime = 0;
    u97.LastSpreadValue = 0;
    u97:SetCharacterTransparency(u97.TransparencyState);
    u97:Switch(u97.PerspectiveState);

    if not (u97.IsBot or (u97.PerspectiveState ~= "First-Person" or not u97.Character:IsDescendantOf(workspace))) then
        workspace_CurrentCamera.CFrame = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(u97.Player) or u97.CameraPart.CFrame;
    end;

    LocalPlayer.ReplicationFocus = u97.RootPart;
    u97.Janitor:Add(function() -- Line: 909
        -- upvalues: LocalPlayer (ref)
        LocalPlayer.ReplicationFocus = nil;
    end);

    if u97.Player:GetAttribute("CurrentEquipped") then
        u97:SetEquipped(HttpService:JSONDecode((u97.Player:GetAttribute("CurrentEquipped"))), false);
    end;

    u97.Janitor:Add(u97.Player:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 917
        -- upvalues: u97 (copy), HttpService (ref)
        local Attribute = u97.Player:GetAttribute("CurrentEquipped");

        if Attribute then
            u97:SetEquipped(HttpService:JSONDecode(Attribute), true);
            task.defer(function() -- Line: 922
                -- upvalues: u97 (ref)
                if u97.TransparencyState and u97.PerspectiveState == "First-Person" then
                    u97:SetCharacterTransparency(true);
                end;
            end);
        end;
    end));

    if u97.IsBot then
        local BotCharacters = require(ReplicatedStorage.Controllers.CharacterController.BotCharacters);
        u97.Janitor:Add(BotCharacters.CombatEvent:Connect(function(p101) -- Line: 933
            -- upvalues: u97 (copy)
            if p101.ActorId == u97.Character:GetAttribute("ActorId") then
                u97:AddSpectateEvent(p101.Kind == "Shoot" and "Shoot" or p101.Kind);
            end;
        end));
        u97.Janitor:Add(u97.Player:GetAttributeChangedSignal("ObjectiveAction"):Connect(function() -- Line: 938
            -- upvalues: u97 (copy)
            u97:AddSpectateEvent(u97.Player:GetAttribute("ObjectiveAction") == "Planting" and "Use" or "Cancel Plant");
        end));
    else
        u97.Janitor:Add(Remotes.Spectate.UpdateCameraCFrame.Listen(function(p102) -- Line: 945
            -- upvalues: u97 (copy)
            if p102.UserId ~= u97.Player.UserId then
                return;
            end;

            u97.HasRemoteCamera = true;
            u97:UpdateCameraCFrame(p102.CameraCFrame);
        end));

        if u97.Player:GetAttribute("ScopeIncrement") then
            u97:UpdateScopeState();
        end;

        u97.Janitor:Add(u97.Player:GetAttributeChangedSignal("ScopeIncrement"):Connect(function() -- Line: 956
            -- upvalues: u97 (copy)
            u97:UpdateScopeState();
        end));
    end;

    local function stopSpectating() -- Line: 961
        -- upvalues: u97 (copy)
        u97.StopSpectating:Fire();
    end;

    if CharacterResolver.getHealth(u97.Character) <= 0 then
        task.defer(stopSpectating);
    end;

    u97.Janitor:Add(u97.Character:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 969
        -- upvalues: CharacterResolver (ref), u97 (copy)
        if CharacterResolver.getHealth(u97.Character) <= 0 then
            u97.StopSpectating:Fire();
        end;
    end));

    if u97.Character:GetAttribute("Dead") then
        task.defer(stopSpectating);
    end;

    u97.Janitor:Add(u97.Character:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 979
        -- upvalues: u97 (copy)
        if u97.Character:GetAttribute("Dead") then
            u97.StopSpectating:Fire();
        end;
    end));
    u97.Janitor:Add(Remotes.UI.UIPlayerKilled.Listen(function(p103) -- Line: 986
        -- upvalues: Participants (ref), u97 (copy)
        local Victim = p103.Victim;

        if Victim and tostring(Participants.Key(u97.Player)) == Victim then
            u97.StopSpectating:Fire();
        end;
    end));
    u97.Janitor:Add(u97.Character.AncestryChanged:Connect(function(p104, p105) -- Line: 994
        -- upvalues: u97 (copy), workspace_CurrentCamera (ref), ReplicatedStorage (ref)
        if not p105 then
            u97.StopSpectating:Fire();

            return;
        end;

        local PendingPerspective = u97.PendingPerspective;

        if PendingPerspective and u97.Character:IsDescendantOf(workspace) then
            u97:Switch(PendingPerspective);

            if PendingPerspective == "First-Person" and not (u97.IsBot or u97.CameraPositionSpring) then
                local v106 = u97;
                workspace_CurrentCamera.CFrame = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(v106.Player) or v106.CameraPart.CFrame;
            end;
        end;
    end));
    u97.Janitor:Add(function() -- Line: 1009
        -- upvalues: u97 (copy), CharacterResolver (ref), Ragdoll (ref), CameraController (ref), Constants (ref)
        u97.TransparencyState = false;

        if u97.Character:GetAttribute("Dead") ~= false and true or CharacterResolver.getHealth(u97.Character) <= 0 then
            Ragdoll.HideCharacterLocally(u97.Character);
        elseif next(u97.Transparencies) ~= nil then
            u97:SetCharacterTransparency(false);
        end;

        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end);
    u97.Janitor:Add(function() -- Line: 1022
        -- upvalues: destroySpectatedWeaponComponent (ref), u97 (copy)
        destroySpectatedWeaponComponent(u97);
    end);
    u97.Janitor:Add(function() -- Line: 1025
        -- upvalues: u97 (copy)
        local v107 = u97;

        if v107.FreecamInstance then
            v107.FreecamInstance:Stop();
            v107.FreecamInstance:Destroy();
            v107.FreecamInstance = nil;
        end;
    end);

    return u97;
end;

function u1.newBot(p108: userdata, p109: userdata, p110: any) -- Line: 1033
    -- upvalues: u1 (copy)
    local v111 = p109:GetAttribute("Bot") == true;
    assert(v111, "Expected a bot presentation");

    return u1.new(p108, p109, p110, true);
end;

function u1.Destroy(p112) -- Line: 1041
    p112.Janitor:Destroy();
end;

return u1;