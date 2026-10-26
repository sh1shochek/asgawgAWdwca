-- ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local Camera = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("MuzzleFlashes"):WaitForChild("Camera");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetMuzzleFlash = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash);
local AttachGlovesToViewmodel = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToViewmodel);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local BakedViewmodelMirror = require(ReplicatedStorage.Shared.BakedViewmodelMirror);
local ViewmodelHand = require(ReplicatedStorage.Shared.ViewmodelHand);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Animation = require(script.Classes.Animation);
local Bobble = require(script.Classes.Bobble);
local workspace_CurrentCamera = workspace.CurrentCamera;
local table_freeze_ret = table.freeze({});
local u2 = { "Weapon", "WeaponL", "WeaponR", "CharmBase" };
local CFrame_new_ret = CFrame.new(0, 10000, 0);
local u3 = {};
local u4 = 0;
local u5 = nil;
local u6 = {};

local function updateTransparency(p7: userdata, p8: boolean) -- Line: 70
    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local Attribute = descendant:GetAttribute("HiddenTransparency");

            if p8 then
                local Transparency = descendant.Transparency;
                descendant.Transparency = 1;

                if not Attribute then
                    descendant:SetAttribute("HiddenTransparency", Transparency);
                end;
            elseif Attribute then
                descendant.Transparency = Attribute;
            end;
        elseif descendant:IsA("Texture") then
            if p8 then
                if descendant.Transparency < 1 then
                    descendant:SetAttribute("HiddenTransparency", descendant.Transparency);
                    descendant.Transparency = 1;
                end;
            else
                local Attribute = descendant:GetAttribute("HiddenTransparency");

                if Attribute ~= nil then
                    descendant.Transparency = Attribute;
                    descendant:SetAttribute("HiddenTransparency", nil);
                end;
            end;
        end;
    end;
end;

local function setupMuzzleFlashPart(p9: userdata?, p10: any) -- Line: 102
    -- upvalues: GetMuzzleFlash (copy), Camera (copy)
    if not (p9 and p10.MuzzleType) then
        return;
    end;

    GetMuzzleFlash(p9, Camera, p10.MuzzleType, "Motor6D");

    if p10.HasSuppressor then
        GetMuzzleFlash(p9, Camera, "Suppressor", "Motor6D");
    end;
end;

local function stripWeaponGeometry(p11: userdata) -- Line: 115
    -- upvalues: u2 (copy)
    for _, v in ipairs(u2) do
        local v12 = p11:FindFirstChild(v);

        if v12 then
            v12:Destroy();
        end;
    end;
end;

local function findWeaponRoot(p13: userdata) -- Line: 124
    return p13:FindFirstChild("Weapon") or (p13:FindFirstChild("WeaponL") or p13:FindFirstChild("WeaponR"));
end;

local function getViewmodelStash() -- Line: 129
    -- upvalues: u5 (ref), workspace_CurrentCamera (copy)
    local v14 = u5;

    if not v14 or v14.Parent ~= workspace_CurrentCamera then
        v14 = Instance.new("Folder");
        v14.Name = "ViewmodelStash";
        v14.Parent = workspace_CurrentCamera;
        u5 = v14;
    end;

    return v14;
end;

local function getCarryOverKey(p15: any, p16: string, p17: string) -- Line: 141
    -- upvalues: Players (copy)
    if p15.Character or (p15.Player ~= Players.LocalPlayer or p16 == "C4") then
        return nil;
    end;

    local Charm = p15.Charm;
    local v18;

    if type(Charm) == "table" then
        v18 = `{Charm.Skin}:{Charm.Pattern}:{Charm.Position}`;
    else
        v18 = tostring(Charm);
    end;

    local table_concat = table.concat;
    local v19 = {};
    local v20 = p15.ViewmodelCameraWeapon or p16;
    local v21 = tostring(p15.Float);
    local v22;

    if p15.StatTrack == nil then
        v22 = false;
    else
        v22 = p15.StatTrack ~= false;
    end;

    v19[1], v19[2], v19[3], v19[4], v19[5], v19[6], v19[7], v19[8] = v20, p16, p17, v21, tostring(v22), tostring(p15.NameTag), v18, tostring(p15.ViewmodelHideWeaponGeometry == true);

    return table_concat(v19, "|");
end;

local function getCharacterKey(p23: userdata) -- Line: 161
    local Attribute = p23:GetAttribute("Team");
    local v24 = p23:GetAttribute("CharacterName") or workspace:GetAttribute(Attribute == "Counter-Terrorists" and "CTCharacter" or "TCharacter");
    local v25 = p23:FindFirstChild("Body Colors");
    local v26 = p23:FindFirstChild("Torso") or p23:FindFirstChild("UpperTorso");
    local v27;

    if v25 then
        v27 = v25.TorsoColor3;
    elseif v26 and v26:IsA("BasePart") then
        v27 = v26.Color;
    else
        v27 = nil;
    end;

    return table.concat({
        tostring(Attribute),
        tostring(v24),
        tostring(p23:GetAttribute("EquippedGloves")),
        not v27 and "" or v27:ToHex()
    }, "|");
end;

local function isLocalPlayerDead() -- Line: 179
    -- upvalues: Players (copy)
    return Players.LocalPlayer:GetAttribute("Dead") == true;
end;

local function flushCarryOver() -- Line: 183
    -- upvalues: Players (copy), u6 (copy), flushCarryOver (copy)
    if Players.LocalPlayer:GetAttribute("Dead") == true then
        return;
    end;

    local os_clock_ret = os.clock();

    for i = #u6, 1, -1 do
        local v28 = u6[i];
        local v29;

        if v28.Viewmodel.IsDestroyed then
            table.remove(u6, i);
            v29 = i;
        else
            if v28.ExpiresAt <= os_clock_ret then
                table.remove(u6, i);
                v28.Viewmodel:destroy();
                task.delay(0, flushCarryOver);

                return;
            end;

            v29 = i;
        end;
    end;
end;

Players.LocalPlayer:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 204
    -- upvalues: Players (copy), u6 (copy), flushCarryOver (copy)
    if Players.LocalPlayer:GetAttribute("Dead") == true or #u6 == 0 then
        return;
    end;

    local v30 = os.clock() + 5;

    for _, v in u6 do
        v.ExpiresAt = math.max(v.ExpiresAt, v30);
    end;

    task.delay(5.1, flushCarryOver);
end);

local function weldLooseParts(p31: userdata) -- Line: 216
    local PrimaryPart = p31.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local Descendants = p31:GetDescendants();
    local v32 = {};

    for _, v in ipairs(Descendants) do
        if (v:IsA("JointInstance") or v:IsA("WeldConstraint")) and v.Enabled then
            local Part0 = v.Part0;
            local Part1 = v.Part1;

            if Part0 and Part1 then
                v32[Part0] = v32[Part0] or {};
                v32[Part1] = v32[Part1] or {};
                table.insert(v32[Part0], Part1);
                table.insert(v32[Part1], Part0);
            end;
        end;
    end;

    local v33 = { PrimaryPart };
    local v34 = {
        [PrimaryPart] = true
    };

    while #v33 > 0 do
        for _, v in v32[table.remove(v33)] or {} do
            if not v34[v] then
                v34[v] = true;
                table.insert(v33, v);
            end;
        end;
    end;

    local CharmBase = p31:FindFirstChild("CharmBase");

    for _, v in ipairs(Descendants) do
        if v:IsA("BasePart") and (v ~= PrimaryPart and not (CharmBase and v:IsDescendantOf(CharmBase))) then
            v.Anchored = false;

            if not v34[v] then
                local Weld = Instance.new("Weld");
                Weld.Name = "LooseWeld";
                Weld.Part0 = PrimaryPart;
                Weld.Part1 = v;
                Weld.C0 = PrimaryPart.CFrame:ToObjectSpace(v.CFrame);
                Weld.Parent = v;
            end;
        end;
    end;
end;

local function getChargeGuiObject(p35: userdata?, p36: string) -- Line: 264
    if p35 then
        p35 = p35:FindFirstChild("Interactables");
    end;

    if p35 then
        p35 = p35:FindFirstChild("Charge", true);
    end;

    if p35 then
        p35 = p35:FindFirstChildOfClass("SurfaceGui");
    end;

    if not p35 then
        return nil;
    end;

    local v37 = p35:FindFirstChild(p36);

    if v37 and v37:IsA(p36) then
        return v37;
    end;

    return p35:FindFirstChildWhichIsA(p36);
end;

local function getRechargeChargeAlpha(p38) -- Line: 280
    local v39;

    if p38 then
        v39 = p38.Properties;
    else
        v39 = p38;
    end;

    if not v39 then
        return nil;
    end;

    local RechargeTime = v39.RechargeTime;
    local Rounds = v39.Rounds;

    if not (RechargeTime and (Rounds and Rounds > 0)) then
        return nil;
    end;

    local v40 = (tonumber(p38.Rounds) or Rounds) / Rounds;
    local math_clamp_ret = math.clamp(v40, 0, 1);

    if math_clamp_ret >= 1 then
        return 1;
    end;

    local v41 = tonumber(p38.RechargeStartTime);

    if not v41 then
        return math_clamp_ret;
    end;

    local v42 = workspace:GetServerTimeNow() - v41;
    local v43 = math.max(v42, 0) / RechargeTime;
    local v44 = math_clamp_ret + math.clamp(v43, 0, 1) / Rounds;

    return math.clamp(v44, 0, 1);
end;

local Color3_fromRGB_ret = Color3.fromRGB(125, 20, 20);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 235, 140);
local Color3_fromRGB_ret3 = Color3.fromRGB(40, 223, 213);

local function updateChargeFrame(p45: any, p46: number) -- Line: 316
    -- upvalues: getChargeGuiObject (copy), getRechargeChargeAlpha (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local ChargeFillFrame = p45.ChargeFillFrame;

    if not (ChargeFillFrame and ChargeFillFrame.Parent) then
        ChargeFillFrame = getChargeGuiObject(p45.Model, "Frame");
        p45.ChargeFillFrame = ChargeFillFrame;
        local v47;

        if ChargeFillFrame then
            v47 = ChargeFillFrame.Size or nil;
        else
            v47 = nil;
        end;

        p45.ChargeFillBaseSize = v47;
    end;

    local ChargeTextLabel = p45.ChargeTextLabel;

    if not (ChargeTextLabel and ChargeTextLabel.Parent) then
        ChargeTextLabel = getChargeGuiObject(p45.Model, "TextLabel");
        p45.ChargeTextLabel = ChargeTextLabel;
    end;

    local ChargeFillBaseSize = p45.ChargeFillBaseSize;

    if not (ChargeFillFrame and ChargeFillBaseSize) then
        return;
    end;

    local v48 = getRechargeChargeAlpha(p45.WeaponComponent) or 1;
    local DisplayedChargeAlpha = p45.DisplayedChargeAlpha;
    local v49;

    if DisplayedChargeAlpha == nil or v48 < DisplayedChargeAlpha then
        v49 = v48;
    else
        local math_clamp_ret = math.clamp(p46 * 3.5, 0, 1);
        v49 = DisplayedChargeAlpha + (v48 - DisplayedChargeAlpha) * math_clamp_ret;
    end;

    if math.abs(v48 - v49) > 0.001 then
        v48 = v49;
    end;

    local v50 = v48 >= 0.999 and 1 or v48;
    p45.DisplayedChargeAlpha = v50;
    ChargeFillFrame.Size = UDim2.new(ChargeFillBaseSize.X.Scale, ChargeFillBaseSize.X.Offset, 0.8 * v50, 0);
    local v51;

    if v50 >= 0.999 then
        v51 = Color3_fromRGB_ret3;
    else
        v51 = Color3_fromRGB_ret:Lerp(Color3_fromRGB_ret2, v50);
    end;

    ChargeFillFrame.BackgroundColor3 = v51;

    if ChargeTextLabel then
        ChargeTextLabel.Text = `{math.round(v50 * 100)}%`;
        ChargeTextLabel.TextColor3 = v51;
    end;
end;

local function isSprintBlocked(p52) -- Line: 371
    local WeaponComponent = p52.WeaponComponent;

    return (p52.Inspecting == true or (WeaponComponent == nil or (WeaponComponent.IsShooting == true or (WeaponComponent.IsBurstShooting == true or (WeaponComponent.IsFireHeld == true or (WeaponComponent.IsAlternativeFireHeld == true or (WeaponComponent.IsChargeFiring == true or (WeaponComponent.IsAiming == true or (WeaponComponent.IsInspecting == true or WeaponComponent.ThrowStarted == true))))))))) and true or WeaponComponent.IsPlanting == true;
end;

local function findGripPart(p53: userdata) -- Line: 389
    local v54 = p53:FindFirstChild("Right Arm");

    if v54 and v54:IsA("BasePart") then
        return v54, Vector3.new(0, 0, -v54.Size.Z / 2);
    end;

    local Weapon = p53:FindFirstChild("Weapon");
    local v55 = Weapon and Weapon:FindFirstChild("Handle") or p53:FindFirstChild("Handle", true);

    if not (v55 and v55:IsA("BasePart")) then
        v55 = nil;
    end;

    return v55, Vector3.new(0, 0, 0);
end;

local u56 = {};
local u57 = {};

local function singleAssemblyRoot(p58: userdata) -- Line: 404
    local PrimaryPart = p58.PrimaryPart;

    if PrimaryPart == nil then
        return nil;
    end;

    for _, descendant in p58:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.AssemblyRootPart ~= PrimaryPart then
            return nil;
        end;
    end;

    return PrimaryPart;
end;

local function pivotModel(p59: table, p60: userdata, p61) -- Line: 417
    -- upvalues: singleAssemblyRoot (copy), u56 (copy), u57 (copy)
    local os_clock_ret = os.clock();
    local v62 = p59[p60];

    if v62 == nil or v62.CheckAt <= os_clock_ret then
        v62 = {
            Root = singleAssemblyRoot(p60),
            CheckAt = os_clock_ret + 0.5
        };
        p59[p60] = v62;
    end;

    local Root = v62.Root;

    if Root == nil or (Root.Parent == nil or p60.PrimaryPart ~= Root) then
        p60:PivotTo(p61);

        return;
    end;

    local v63 = p61 * Root.PivotOffset:Inverse();
    u56[1] = Root;
    u57[1] = v63;
    workspace:BulkMoveTo(u56, u57, Enum.BulkMoveMode.FireCFrameChanged);
end;

function u1.aim(p64) -- Line: 436
    -- upvalues: workspace_CurrentCamera (copy)
    p64.Bobble:setIsAiming(true);

    if p64.MuzzlePartWeld then
        local CFrame2 = workspace_CurrentCamera.CFrame;
        local WorldPivot = p64.Model.WorldPivot;
        local CFrame3 = p64.MuzzlePartWeld.Part0.CFrame;

        if p64.Mirror then
            WorldPivot = p64.Mirror:ToNormalPose(p64.Model:GetPivot());
            CFrame3 = p64.Mirror:ToNormalPose(CFrame3);
        end;

        local v65 = CFrame2 + CFrame2.UpVector * -0.5 + WorldPivot.LookVector * 1 + WorldPivot.RightVector * 0.1;
        p64.MuzzlePartWeld.C0 = CFrame3:Inverse() * v65;
    end;
end;

function u1.unaim(p66) -- Line: 458
    p66.Bobble:setIsAiming(false);

    if p66.OriginalC0 and p66.MuzzlePartWeld then
        p66.MuzzlePartWeld.C0 = p66.OriginalC0;
    end;
end;

function u1.unhide(p67) -- Line: 467
    -- upvalues: updateTransparency (copy)
    if p67.Hidden then
        updateTransparency(p67.Model, false);
        p67.Hidden = false;
    end;
end;

function u1.hide(p68) -- Line: 476
    -- upvalues: updateTransparency (copy)
    if not p68.Hidden then
        updateTransparency(p68.Model, true);
        p68.Hidden = true;
    end;
end;

function u1.setLowered(p69: any, p70: boolean) -- Line: 486
    if p69.Bobble then
        p69.Bobble:setLowered(p70);
    end;
end;

function u1.equip(p71: any, p72: boolean) -- Line: 494
    -- upvalues: workspace_CurrentCamera (copy)
    p71.IsEquipped = true;

    if not p71.Model then
        return;
    end;

    if p71.Mirror then
        p71.Mirror:PrepareEquip();
    end;

    p71.Model.Parent = workspace_CurrentCamera;

    if p71.LargeWeaponModel then
        p71.LargeWeaponModel.Parent = workspace_CurrentCamera;
    end;

    p71.Animation:stopAnimations();
    p71.Animation:play("Idle");
    p71:unhide();

    if not p72 then
        p71.Animation:play(p71.Animation:pickVariant("Equip"));
    end;
end;

function u1.unequip(p73) -- Line: 520
    -- upvalues: u5 (ref), workspace_CurrentCamera (copy), pivotModel (copy), CFrame_new_ret (copy)
    p73.IsEquipped = false;
    p73.Animation:stopAnimations();
    p73.LastViewmodelPosition = nil;

    if p73.Bobble then
        p73.Bobble:setLowered(false, true);
    end;

    local Model = p73.Model;

    if Model and Model:IsDescendantOf(workspace) then
        local v74 = u5;

        if not v74 or v74.Parent ~= workspace_CurrentCamera then
            v74 = Instance.new("Folder");
            v74.Name = "ViewmodelStash";
            v74.Parent = workspace_CurrentCamera;
            u5 = v74;
        end;

        Model.Parent = v74;
        pivotModel(p73.PivotPlans, Model, CFrame_new_ret);
    end;

    if p73.LargeWeaponModel then
        p73.LargeWeaponModel.Parent = nil;
    end;
end;

function u1.applyCharmImpulse(p75: any, p76: vector) -- Line: 542
    if p75.LargeCharmModel and p75.LargeCharmModel.PrimaryPart then
        local CharmMassCache = p75.CharmMassCache;

        if p75.CharmMassCacheModel ~= p75.LargeCharmModel or typeof(CharmMassCache) ~= "number" then
            CharmMassCache = 0;

            for _, descendant in ipairs(p75.LargeCharmModel:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    CharmMassCache = CharmMassCache + descendant:GetMass();
                end;
            end;

            p75.CharmMassCache = CharmMassCache;
            p75.CharmMassCacheModel = p75.LargeCharmModel;
        end;

        p75.LargeCharmModel.PrimaryPart:ApplyImpulse(p76 * 10 * CharmMassCache);
    end;
end;

function u1.render(p77: any, p78: number) -- Line: 565
    -- upvalues: updateChargeFrame (copy), DataController (copy), table_freeze_ret (copy), isSprintBlocked (copy), workspace_CurrentCamera (copy), ViewmodelHand (copy), pivotModel (copy), findGripPart (copy)
    local v79 = p77.Model and p77.Model:FindFirstChild("Stats");

    if not v79 then
        return;
    end;

    debug.profilebegin("Viewmodel.render.UpdateChargeFrame");
    updateChargeFrame(p77, p78);
    debug.profileend();
    debug.profilebegin("Viewmodel.render.GetViewmodelSettings");
    local v80 = DataController.Get(p77.Player, "Settings.Game.Viewmodel") or table_freeze_ret;
    debug.profileend();

    if p77.Bobble or p77.Inspecting then
        debug.profilebegin("Viewmodel.render.BobbleNextCFrame");
        local NextCFrame, v81, v82 = p77.Bobble:getNextCFrame(p78, (isSprintBlocked(p77)));
        debug.profileend();
        local Value = v79.Rotation.Value;
        local v83 = not p77.Bobble and 0 or p77.Bobble:getLowered();

        if v83 ~= 0 then
            Value = Value + Vector3.new(-0.45, 0.6, 0.25) * v83;
        end;

        local v84 = CFrame.Angles(Value.X, Value.Y, Value.Z) * CFrame.new(v79.Default.Value) * CFrame.new((v80["X Offset"] or 0) / 100, (v80["Y Offset"] or 0) / 100, (v80["Z Offset"] or 0) / 100);
        local v85 = workspace_CurrentCamera.CFrame * NextCFrame * v84;
        debug.profilebegin("Viewmodel.render.PivotModel");
        local PivotPlans = p77.PivotPlans;
        local Mirror = p77.Mirror;

        if Mirror then
            local v86 = not p77.WeaponComponent.Character and ViewmodelHand.IsPlayerLeftHanded(p77.Player);
            Mirror:SetLeftHanded(v86);
            pivotModel(PivotPlans, p77.Model, Mirror:GetDisplayPose(workspace_CurrentCamera.CFrame, v85));
            Mirror:UpdateSurfaces();
        else
            pivotModel(PivotPlans, p77.Model, v85);
        end;

        debug.profileend();

        if p77.Bobble:wantsSprintGrip() and p77.Animation:isIdle() then
            local SprintGripPart = p77.SprintGripPart;
            local SprintGripOffset = p77.SprintGripOffset;

            if SprintGripPart == nil or (SprintGripPart.Parent == nil or SprintGripOffset == nil) then
                SprintGripPart, SprintGripOffset = findGripPart(p77.Model);
                p77.SprintGripPart = SprintGripPart;
                p77.SprintGripOffset = SprintGripOffset;
            end;

            if SprintGripPart and SprintGripOffset then
                local Pivot = p77.Model:GetPivot();
                local CFrame2 = SprintGripPart.CFrame;

                if Mirror then
                    Pivot = Mirror:ToNormalPose(Pivot);
                    CFrame2 = Mirror:ToNormalPose(CFrame2);
                end;

                local v87 = CFrame2:PointToWorldSpace(SprintGripOffset);
                p77.Bobble:setSprintGrip(v84:PointToWorldSpace(Pivot:PointToObjectSpace(v87)));
            end;
        end;

        if p77.LargeWeaponModel and p77.SmallWeaponModel then
            local Pivot = p77.SmallWeaponModel:GetPivot();

            if Mirror then
                Pivot = Mirror:ToNormalPose(Pivot);
            end;

            debug.profilebegin("Viewmodel.render.PivotLargeWeaponModel");
            pivotModel(PivotPlans, p77.LargeWeaponModel, Pivot);
            debug.profileend();
            local Position = v85.Position;

            if p77.LastViewmodelPosition then
                p77:applyCharmImpulse(-(Position - p77.LastViewmodelPosition) * 0.2);
            end;

            p77.LastViewmodelPosition = Position;
        end;

        if p77.Bobble.Scope and p77.Bobble.IsAiming then
            debug.profilebegin("Viewmodel.render.Scope");
            local CFrame2 = workspace_CurrentCamera.CFrame;
            p77.Bobble.Scope:PivotTo(CFrame2 + CFrame2.LookVector * 0.15 + v81 + (v82.X * -CFrame2.LookVector + v82.Y * -CFrame2.UpVector));

            if p77.Bobble.ScopeReticlePart then
                p77.Bobble.ScopeReticlePart.CFrame = CFrame2 * CFrame.Angles(1.5707963267948966, 1.5707963267948966, -1.5707963267948966) + CFrame2.LookVector * 0.15;
            end;

            debug.profileend();
        end;
    end;
end;

function u1.attachSleeves(p88: any, p89: string) -- Line: 666
    -- upvalues: ReplicatedStorage (copy)
    local v90 = ReplicatedStorage.Assets.Sleeves:FindFirstChild(p89);

    if not v90 then
        return;
    end;

    for _, child in ipairs(v90:GetChildren()) do
        local v91 = p88.Model:FindFirstChild(child.Name);

        if v91 then
            local v92 = child:Clone();
            v92.CastShadow = false;
            v92.CanCollide = false;
            v92.CanTouch = false;
            v92.Anchored = false;
            v92.CanQuery = false;
            v92.Name = "Sleeve";
            v92.Size = Vector3.new(v91.Size.X * 1.3, v91.Size.Y * 1.4, v91.Size.Z * 0.79);
            local v93 = v91.Size.Z / 2 - v92.Size.Z / 2;
            v92.Parent = v91;
            local Motor6D = Instance.new("Motor6D", v92);
            Motor6D.Part0 = v91;
            Motor6D.Part1 = v92;
            Motor6D.C1 = CFrame.new(0, -0.02, -v93);
        end;
    end;
end;

local function resolveInventoryGlove(p94: userdata, p95: string) -- Line: 703
    -- upvalues: Router (copy)
    local v96 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p94, p95);

    if v96 then
        return v96.Name, v96.Skin, v96.Float;
    end;

    return nil, nil, nil;
end;

function u1.addAttachments(p97, p98) -- Line: 711
    -- upvalues: Router (copy), u3 (copy), Skins (copy), u4 (ref), AttachGlovesToViewmodel (copy)
    debug.profilebegin("Viewmodel.addAttachments");
    local v99 = nil;
    local v100 = nil;
    local v101 = nil;

    if type(p98) == "string" then
        local v102 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p97.Player, p98);

        if v102 then
            v99 = v102.Name;
            v100 = v102.Skin;
            v101 = v102.Float;
        else
            v99 = nil;
            v100 = nil;
            v101 = nil;
        end;
    elseif type(p98) == "table" then
        local SkinIdentifier = p98.SkinIdentifier;

        if type(SkinIdentifier) == "string" and SkinIdentifier ~= "" then
            local v103 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p97.Player, SkinIdentifier);

            if v103 then
                v99 = v103.Name;
                v100 = v103.Skin;
                v101 = v103.Float;
            else
                v99 = nil;
                v100 = nil;
                v101 = nil;
            end;
        end;

        if not (v99 or (type(p98.Name) ~= "string" or type(p98.Skin) ~= "string")) then
            v99 = p98.Name;
            v100 = p98.Skin;

            if typeof(p98.Float) == "number" then
                v101 = p98.Float;
            else
                v101 = nil;
            end;
        end;
    end;

    if v99 and v100 then
        debug.profilebegin("Viewmodel.addAttachments.GetGloves");
        local v104 = `{v99}|{v100}|{v101 or ""}`;
        local v105 = u3[v104];

        if not v105 then
            local Gloves = Skins.GetGloves(v99, v100, v101);
            v105 = u3[v104];

            if v105 then
                if Gloves then
                    Gloves:Destroy();
                end;
            elseif Gloves then
                if u4 >= 8 then
                    for _, v in u3 do
                        v:Destroy();
                    end;

                    table.clear(u3);
                    u4 = 0;
                end;

                u3[v104] = Gloves;
                u4 = u4 + 1;
                v105 = Gloves;
            else
                v105 = Gloves;
            end;
        end;

        debug.profileend();

        if v105 then
            debug.profilebegin("Viewmodel.addAttachments.AttachGloves");
            AttachGlovesToViewmodel(v105:GetChildren(), p97.Model);
            debug.profileend();
        end;
    end;

    debug.profileend();
end;

function u1.construct(p106: any, p107: userdata, p108: any) -- Line: 767
    -- upvalues: Janitor (copy), Skins (copy), stripWeaponGeometry (copy), getCharacterKey (copy), HttpService (copy), GetMuzzleFlash (copy), Camera (copy), weldLooseParts (copy), ReplicatedStorage (copy), Players (copy), BakedViewmodelMirror (copy)
    debug.profilebegin("Viewmodel.construct");

    if p106.ModelJanitor then
        debug.profilebegin("Viewmodel.construct.DestroyModelJanitor");
        p106.ModelJanitor:Destroy();
        debug.profileend();
    end;

    p106.ModelJanitor = Janitor.new();
    p106.Mirror = nil;
    p106.CharmModel = nil;
    p106.LargeWeaponModel = nil;
    p106.SmallWeaponModel = nil;
    p106.LargeCharmModel = nil;
    p106.LastViewmodelPosition = nil;
    p106.ChargeFillFrame = nil;
    p106.ChargeTextLabel = nil;
    p106.ChargeFillBaseSize = nil;
    p106.DisplayedChargeAlpha = nil;

    if p106.Animation then
        debug.profilebegin("Viewmodel.construct.StopAnimations");
        p106.Animation:stopAnimations();
        debug.profileend();
    end;

    if p106.Model then
        debug.profilebegin("Viewmodel.construct.DestroyPreviousModel");
        p106.Model:Destroy();
        debug.profileend();
        p106.Model = nil;
        p106.SprintGripPart = nil;
        p106.SprintGripOffset = nil;
    end;

    local v109 = p106.CameraModelWeapon or p106.Weapon;
    local Team = p106.Team;

    if v109 ~= "Smoke Grenade" or Team ~= "Counter-Terrorists" and Team ~= "Terrorists" then
        Team = nil;
    end;

    debug.profilebegin("Viewmodel.construct.GetCameraModel");
    p106.Model = Skins.GetCameraModel(v109, p106.Skin, p106.Float, p106.StatTrack, p106.NameTag, p106.Charm, p106.Stickers, Team);
    debug.profileend();

    if not p106.Model and p106.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.GetBaseWeaponModel");
        p106.Model = Skins.GetBaseWeaponModel(v109, "Camera");
        debug.profileend();
    end;

    if not p106.Model then
        debug.profileend();
        error((`Viewmodel.construct: Failed to get camera model for weapon "{v109}" with skin "{p106.Skin}"`));
    end;

    p106.Model.Name = v109;

    if p106.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.StripWeaponGeometry");
        stripWeaponGeometry(p106.Model);
        debug.profileend();
    end;

    p106.CharacterKey = getCharacterKey(p107);
    p106.Team = p107:GetAttribute("Team") or p106.Team;
    local Attribute = p107:GetAttribute("CharacterName");

    if type(Attribute) ~= "string" or Attribute == "" then
        Attribute = workspace:GetAttribute(p106.Team == "Counter-Terrorists" and "CTCharacter" or "TCharacter");
    end;

    if type(Attribute) == "string" and Attribute ~= "" then
        p106:attachSleeves(Attribute);
    end;

    local Attribute2 = p107:GetAttribute("EquippedGloves");

    if type(Attribute2) == "string" and Attribute2 ~= "" then
        debug.profilebegin("Viewmodel.construct.DecodeEquippedGloves");
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute2);
        debug.profileend();

        if success and result then
            p106:addAttachments(result);
        else
            p106:addAttachments(Attribute2);
        end;
    end;

    debug.profilebegin("Viewmodel.construct.SetupDescendants");

    for _, descendant in ipairs(p106.Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "Viewmodel";
            descendant.CanCollide = false;
            descendant.CastShadow = false;
            descendant.CanQuery = true;
            descendant.CanTouch = false;

            if descendant.Name == "HumanoidRootPart" or descendant.Name == "ViewmodelLight" then
                descendant.Transparency = 1;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.SetupArmColors");
    local v110 = p107:FindFirstChild("Body Colors");
    local v111 = nil;

    if v110 then
        v111 = v110.TorsoColor3;
    else
        local v112 = p107:FindFirstChild("Torso") or p107:FindFirstChild("UpperTorso");

        if v112 and v112:IsA("BasePart") then
            v111 = v112.Color;
        end;
    end;

    if v111 then
        for _, v in ipairs({ "Right Arm", "Left Arm" }) do
            local v113 = p106.Model:FindFirstChild(v);

            if v113 and v113:IsA("BasePart") then
                v113.Color = v111;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.CacheMuzzleParts");
    local Interactables = p106.Model:FindFirstChild("Interactables");
    local v114;

    if Interactables then
        v114 = Interactables:FindFirstChild("MuzzlePart", true) or (Interactables:FindFirstChild("MuzzlePartL", true) or Interactables:FindFirstChild("MuzzlePartR", true));
    else
        v114 = Interactables;
    end;

    p106.MuzzlePart = v114;

    if Interactables then
        p106.MuzzlePartL = Interactables:FindFirstChild("MuzzlePartL", true);
        p106.MuzzlePartR = Interactables:FindFirstChild("MuzzlePartR", true);

        if p106.MuzzlePartL and p106.MuzzlePartL:IsA("BasePart") then
            p106.MuzzlePartL.Transparency = 1;
        end;

        if p106.MuzzlePartR and p106.MuzzlePartR:IsA("BasePart") then
            p106.MuzzlePartR.Transparency = 1;
        end;
    end;

    if p106.MuzzlePart and p106.MuzzlePart:IsA("BasePart") then
        p106.MuzzlePart.Transparency = 1;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.ScaleTo");
    p106.Model:ScaleTo(0.1);
    debug.profileend();
    debug.profilebegin("Viewmodel.construct.CacheMuzzleWeld");

    if p106.MuzzlePart and not p106.MuzzlePart:FindFirstChild("WeldConstraint", true) then
        for _, descendant in ipairs(p106.Model:GetDescendants()) do
            if descendant:IsA("Weld") and (descendant.Part1 == v114 or descendant.Part0 == v114) then
                p106.MuzzlePartWeld = descendant;
                p106.OriginalC0 = descendant.C0;
                break;
            end;
        end;
    end;

    debug.profileend();
    local Properties = p108.Properties;

    if Properties then
        if Properties.ShootingOptions == "Dual" then
            local MuzzlePartL = p106.MuzzlePartL;

            if MuzzlePartL and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Camera, "Suppressor", "Motor6D");
                end;
            end;

            local MuzzlePartR = p106.MuzzlePartR;

            if MuzzlePartR and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Camera, "Suppressor", "Motor6D");
                end;
            end;
        else
            local MuzzlePart = p106.MuzzlePart;

            if MuzzlePart and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePart, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart, Camera, "Suppressor", "Motor6D");
                end;
            end;
        end;
    end;

    debug.profilebegin("Viewmodel.construct.FindCharmModel");
    local CharmBase = p106.Model:FindFirstChild("CharmBase", true);

    if CharmBase and CharmBase:IsA("Model") then
        local v115 = CharmBase:FindFirstChildOfClass("Model");

        if v115 and v115.PrimaryPart then
            p106.CharmModel = v115;
        end;
    end;

    debug.profileend();

    if p106.CharmModel then
        debug.profilebegin("Viewmodel.construct.SetupCharmPhysics");
        p106:setupCharmPhysics();
        debug.profileend();
    end;

    debug.profilebegin("Viewmodel.construct.SetModelReferences");

    if p106.Animation then
        p106.Animation:setModel(p106.Model);
    end;

    if p106.Bobble then
        local Bobble2 = p106.Bobble;
        Bobble2.Character = p107;
        Bobble2:setModel(p106.Model);
    end;

    debug.profileend();
    weldLooseParts(p106.Model);
    local ViewmodelMirrors = ReplicatedStorage:FindFirstChild("ViewmodelMirrors");
    local v116;

    if p106.Player == Players.LocalPlayer then
        v116 = not p108.Character and not p106.Inspecting;
    else
        v116 = false;
    end;

    if ViewmodelMirrors then
        ViewmodelMirrors = BakedViewmodelMirror.new(p106.Model, ViewmodelMirrors, v116);
    end;

    if ViewmodelMirrors and p106.ModelJanitor then
        p106.Mirror = ViewmodelMirrors;
        p106.ModelJanitor:Add(ViewmodelMirrors, "Destroy");
    end;

    debug.profilebegin("Viewmodel.construct.FinalEquipState");

    if p106.IsEquipped then
        p106:equip(false);
    else
        p106:unequip();
    end;

    debug.profileend();
    debug.profileend();
end;

function u1.setupCharmPhysics(u117) -- Line: 1020
    -- upvalues: u2 (copy), RunServiceController (copy)
    debug.profilebegin("Viewmodel.setupCharmPhysics");
    local Parent = u117.CharmModel.Parent;

    if not (Parent and Parent.PrimaryPart) then
        debug.profileend();

        return;
    end;

    u117.CharmModel:PivotTo(Parent.PrimaryPart.CFrame * CFrame.new(0, 0, -1));
    local CharmModel = u117.CharmModel;
    local Model = u117.Model;
    local u118 = Model:FindFirstChild("Weapon") or (Model:FindFirstChild("WeaponL") or Model:FindFirstChild("WeaponR"));

    if not u118 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.setupCharmPhysics.CloneLargeProxy");
    local Model2 = Instance.new("Model");
    Model2.Name = u117.Model.Name;
    local u119 = {};

    for _, v in ipairs(u2) do
        local v120 = u117.Model:FindFirstChild(v);

        if v120 then
            local v121 = v120:Clone();
            u119[v120] = v121;
            local Descendants = v121:GetDescendants();

            for i, descendant in v120:GetDescendants() do
                u119[descendant] = Descendants[i];
            end;

            v121.Parent = Model2;
        end;
    end;

    Model2.WorldPivot = u117.Model:GetPivot();
    debug.profileend();
    local u122 = Model2:FindFirstChild("Weapon") or (Model2:FindFirstChild("WeaponL") or Model2:FindFirstChild("WeaponR"));

    if not u122 then
        Model2:Destroy();
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.setupCharmPhysics.TrimLargeProxy");

    local function relink(p123: any, p124: string) -- Line: 1066
        -- upvalues: Model2 (copy), u119 (copy)
        local v125 = p123[p124];

        if v125 == nil or v125:IsDescendantOf(Model2) then
            return true;
        end;

        local v126 = u119[v125];

        if not v126 then
            return false;
        end;

        p123[p124] = v126;

        return true;
    end;

    for _, descendant in ipairs(Model2:GetDescendants()) do
        if descendant.Name == "ViewmodelLight" then
            descendant:Destroy();
        elseif descendant:IsA("JointInstance") or (descendant:IsA("WeldConstraint") or descendant:IsA("NoCollisionConstraint")) then
            local Part0 = descendant.Part0;
            local v127;

            if Part0 == nil or Part0:IsDescendantOf(Model2) then
                v127 = true;
            else
                local v128 = u119[Part0];

                if v128 then
                    descendant.Part0 = v128;
                    v127 = true;
                else
                    v127 = false;
                end;
            end;

            if v127 then
                local Part1 = descendant.Part1;
                local v129;

                if Part1 == nil or Part1:IsDescendantOf(Model2) then
                    v129 = true;
                else
                    local v130 = u119[Part1];

                    if v130 then
                        descendant.Part1 = v130;
                        v129 = true;
                    else
                        v129 = false;
                    end;
                end;

                if not v129 then
                    descendant:Destroy();
                end;
            else
                descendant:Destroy();
            end;
        elseif descendant:IsA("Constraint") then
            local Attachment0 = descendant.Attachment0;
            local v131;

            if Attachment0 == nil or Attachment0:IsDescendantOf(Model2) then
                v131 = true;
            else
                local v132 = u119[Attachment0];

                if v132 then
                    descendant.Attachment0 = v132;
                    v131 = true;
                else
                    v131 = false;
                end;
            end;

            if v131 then
                local Attachment1 = descendant.Attachment1;
                local v133;

                if Attachment1 == nil or Attachment1:IsDescendantOf(Model2) then
                    v133 = true;
                else
                    local v134 = u119[Attachment1];

                    if v134 then
                        descendant.Attachment1 = v134;
                        v133 = true;
                    else
                        v133 = false;
                    end;
                end;

                if not v133 then
                    descendant:Destroy();
                end;
            else
                descendant:Destroy();
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.setupCharmPhysics.ScaleAndPivotProxy");
    Model2:ScaleTo(1 / u117.Model:GetScale());
    Model2:PivotTo(u118.Parent:GetPivot());

    if u122.PrimaryPart then
        u122.PrimaryPart.Anchored = true;
    end;

    local BoundingBox = Model2:GetBoundingBox();

    if Model2.PrimaryPart then
        Model2.PrimaryPart.PivotOffset = Model2.PrimaryPart.CFrame:ToObjectSpace(BoundingBox);
    else
        Model2.WorldPivot = BoundingBox;
    end;

    Model2.PrimaryPart = u122.PrimaryPart;
    debug.profileend();
    debug.profilebegin("Viewmodel.setupCharmPhysics.ConfigureProxyDescendants");

    for _, descendant in ipairs(Model2:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1;
            descendant.CanCollide = true;
        elseif descendant:IsA("Decal") or (descendant:IsA("Texture") or descendant:IsA("Beam")) then
            descendant.Transparency = 1;
        elseif descendant:IsA("SurfaceGui") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.setupCharmPhysics.FindLargeCharm");
    local CharmBase = Model2:FindFirstChild("CharmBase", true);
    local v135;

    if CharmBase and CharmBase:IsA("Model") then
        v135 = CharmBase:FindFirstChildOfClass("Model");

        if v135 then
            for _, descendant in ipairs(v135:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = true;
                    descendant.CollisionGroup = "Charm";
                end;
            end;
        end;
    else
        v135 = nil;
    end;

    debug.profileend();
    u117.LargeWeaponModel = u122.Parent;
    u117.SmallWeaponModel = u118;
    u117.LargeCharmModel = v135;

    if v135 and u117.ModelJanitor then
        local v136 = RunServiceController.CreateBindingName("Classes.Viewmodel.CharmSync");
        u117.ModelJanitor:Add(RunServiceController.BindToPostSimulation(v136, function() -- Line: 1156
            -- upvalues: u117 (copy), CharmModel (copy), u122 (copy), u118 (copy)
            local LargeCharmModel = u117.LargeCharmModel;

            if not (u117.IsEquipped and (LargeCharmModel and (LargeCharmModel.PrimaryPart and CharmModel.PrimaryPart))) then
                return;
            end;

            local v137 = u122:GetPivot():ToObjectSpace(LargeCharmModel:GetPivot());
            local v138 = CFrame.new(v137.Position / 10) * CFrame.fromOrientation(v137:ToOrientation());
            CharmModel:PivotTo(u118:GetPivot() * v138);
        end));
    end;

    if u117.CharmModel.PrimaryPart then
        u117.CharmModel.PrimaryPart.Anchored = true;
    end;

    if not u117.ModelJanitor then
        debug.profileend();

        return;
    end;

    u117.ModelJanitor:Add(function() -- Line: 1182
        -- upvalues: Model2 (copy), u117 (copy)
        Model2:Destroy();
        u117.LargeWeaponModel = nil;
        u117.SmallWeaponModel = nil;
        u117.LargeCharmModel = nil;
    end);
    debug.profileend();
end;

function u1.new(p139: any, p140: string, p141: string, p142: boolean?) -- Line: 1194
    -- upvalues: u1 (copy), Janitor (copy), getCarryOverKey (copy), Sound (copy), Animation (copy), Bobble (copy), CharacterResolver (copy)
    debug.profilebegin("Viewmodel.new");
    local u143 = setmetatable({}, u1);
    u143.Janitor = Janitor.new();
    u143.ModelJanitor = Janitor.new();
    u143.IsDestroyed = false;
    u143.Inspecting = p142;
    u143.Player = p139.Player;
    u143.Team = (p139.Character or u143.Player):GetAttribute("Team");
    u143.WeaponComponent = p139;
    u143.Weapon = p140;
    u143.CameraModelWeapon = p139.ViewmodelCameraWeapon or p140;
    u143.HideWeaponGeometry = p139.ViewmodelHideWeaponGeometry == true;
    u143.Skin = p141;
    u143.StatTrack = p139.StatTrack;
    u143.Stickers = p139.Stickers;
    u143.NameTag = p139.NameTag;
    u143.Float = p139.Float;
    u143.Charm = p139.Charm;
    u143.Hidden = false;
    u143.IsEquipped = false;
    u143.PivotPlans = setmetatable({}, {
        __mode = "k"
    });
    local v144;

    if p142 then
        v144 = nil;
    else
        v144 = getCarryOverKey(p139, p140, p141);
    end;

    u143.CarryOverKey = v144;
    debug.profilebegin("Viewmodel.new.Sound");
    u143.Sound = Sound.new(u143.CameraModelWeapon);
    debug.profileend();
    debug.profilebegin("Viewmodel.new.Animation");
    u143.Animation = Animation.new(u143.Player, u143.Sound);
    debug.profileend();
    debug.profilebegin("Viewmodel.new.Bobble");
    u143.Bobble = Bobble.new(p139);
    debug.profileend();
    local v145 = p139.Character or u143.Player.Character;

    if v145 then
        debug.profilebegin("Viewmodel.new.InitialConstruct");
        local success, result = pcall(u143.construct, u143, v145, p139);
        debug.profileend();

        if not success then
            debug.profileend();
            error(result, 2);
        end;
    end;

    if not p139.Character then
        local u146 = v145;
        u143.Janitor:Add(CharacterResolver.observeCharacter(u143.Player, function(p147) -- Line: 1260
            -- upvalues: u146 (ref), u143 (copy)
            if p147 and p147 ~= u146 then
                u143:adoptCharacter(p147);
            end;

            u146 = nil;

            return function() -- Line: 1265
            end;
        end));
    end;

    u143.Janitor:Add(function() -- Line: 1270
        -- upvalues: u143 (copy)
        if u143.ModelJanitor then
            u143.ModelJanitor:Destroy();
            u143.ModelJanitor = nil;
        end;
    end);
    debug.profileend();

    return u143;
end;

function u1.adoptCharacter(p148: any, p149: userdata) -- Line: 1283
    -- upvalues: getCharacterKey (copy)
    if p148.Model and p148.CharacterKey == getCharacterKey(p149) then
        p148.Bobble.Character = p149;

        return;
    end;

    if p148.WeaponComponent then
        p148:construct(p149, p148.WeaponComponent);
    end;
end;

function u1.release(p150) -- Line: 1294
    -- upvalues: u6 (copy), flushCarryOver (copy)
    local CarryOverKey = p150.CarryOverKey;

    if p150.IsDestroyed or not (p150.Model and CarryOverKey) then
        p150:destroy();

        return;
    end;

    if p150.Bobble.IsAiming then
        p150:unaim();
    end;

    p150:unequip();
    p150.WeaponComponent = nil;
    local v151 = {
        Viewmodel = p150,
        Key = CarryOverKey,
        ExpiresAt = os.clock() + 5
    };
    table.insert(u6, v151);
    task.delay(5.1, flushCarryOver);
end;

function u1.claim(p152: any, p153: string, p154: string) -- Line: 1312
    -- upvalues: getCarryOverKey (copy), u6 (copy)
    local v155 = getCarryOverKey(p152, p153, p154);

    if not v155 then
        return nil;
    end;

    for i, v in u6 do
        local Viewmodel = v.Viewmodel;

        if v.Key == v155 and not Viewmodel.IsDestroyed then
            table.remove(u6, i);
            Viewmodel.WeaponComponent = p152;
            Viewmodel.StatTrack = p152.StatTrack;
            local Character = Viewmodel.Player.Character;

            if not Character or pcall(Viewmodel.adoptCharacter, Viewmodel, Character) then
                return Viewmodel;
            end;

            Viewmodel:destroy();

            return nil;
        end;
    end;

    return nil;
end;

function u1.destroy(p156) -- Line: 1337
    if not p156.IsDestroyed then
        debug.profilebegin("Viewmodel.destroy");
        p156.IsDestroyed = true;

        if p156.Animation then
            p156.Animation:stopAnimations();
            p156.Animation:destroy();
            p156.Animation = nil;
        end;

        if p156.Bobble then
            p156.Bobble:destroy();
            p156.Bobble = nil;
        end;

        if p156.Sound then
            p156.Sound:destroy();
            p156.Sound = nil;
        end;

        if p156.Model then
            p156.Model.Parent = nil;
            p156.Model:Destroy();
            p156.Model = nil;
        end;

        p156.Janitor:Destroy();
        p156.Janitor = nil;
        p156.StatTrack = nil;
        p156.Stickers = nil;
        p156.NameTag = nil;
        p156.Player = nil;
        p156.Weapon = nil;
        p156.Float = nil;
        p156.Charm = nil;
        p156.Skin = nil;
        p156.Team = nil;
        p156.MuzzlePartWeld = nil;
        p156.MuzzlePartL = nil;
        p156.MuzzlePartR = nil;
        p156.MuzzlePart = nil;
        p156.OriginalC0 = nil;
        p156.CharmModel = nil;
        p156.LargeCharmModel = nil;
        p156.LargeWeaponModel = nil;
        debug.profileend();
    end;
end;

return u1;