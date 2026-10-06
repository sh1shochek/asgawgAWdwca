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

local function updateTransparency(p7: userdata, p8: boolean) -- Line: 67
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

local function setupMuzzleFlashPart(p9: userdata?, p10: any) -- Line: 99
    -- upvalues: GetMuzzleFlash (copy), Camera (copy)
    if not (p9 and p10.MuzzleType) then
        return;
    end;

    GetMuzzleFlash(p9, Camera, p10.MuzzleType, "Motor6D");

    if p10.HasSuppressor then
        GetMuzzleFlash(p9, Camera, "Suppressor", "Motor6D");
    end;
end;

local function stripWeaponGeometry(p11: userdata) -- Line: 112
    -- upvalues: u2 (copy)
    for _, v in ipairs(u2) do
        local v12 = p11:FindFirstChild(v);

        if v12 then
            v12:Destroy();
        end;
    end;
end;

local function findWeaponRoot(p13: userdata) -- Line: 121
    return p13:FindFirstChild("Weapon") or (p13:FindFirstChild("WeaponL") or p13:FindFirstChild("WeaponR"));
end;

local function getViewmodelStash() -- Line: 126
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

local function getCarryOverKey(p15: any, p16: string, p17: string) -- Line: 138
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

local function getCharacterKey(p23: userdata) -- Line: 158
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

local function isLocalPlayerDead() -- Line: 176
    -- upvalues: Players (copy)
    return Players.LocalPlayer:GetAttribute("Dead") == true;
end;

local function flushCarryOver() -- Line: 180
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

Players.LocalPlayer:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 201
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

local function weldLooseParts(p31: userdata) -- Line: 213
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

local function getChargeGuiObject(p35: userdata?, p36: string) -- Line: 261
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

local function getRechargeChargeAlpha(p38) -- Line: 277
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

local function updateChargeFrame(p45: any, p46: number) -- Line: 313
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

local u52 = {};
local u53 = {};

local function singleAssemblyRoot(p54: userdata) -- Line: 371
    local PrimaryPart = p54.PrimaryPart;

    if PrimaryPart == nil then
        return nil;
    end;

    for _, descendant in p54:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.AssemblyRootPart ~= PrimaryPart then
            return nil;
        end;
    end;

    return PrimaryPart;
end;

local function pivotModel(p55: table, p56: userdata, p57) -- Line: 384
    -- upvalues: singleAssemblyRoot (copy), u52 (copy), u53 (copy)
    local os_clock_ret = os.clock();
    local v58 = p55[p56];

    if v58 == nil or v58.CheckAt <= os_clock_ret then
        v58 = {
            Root = singleAssemblyRoot(p56),
            CheckAt = os_clock_ret + 0.5
        };
        p55[p56] = v58;
    end;

    local Root = v58.Root;

    if Root == nil or (Root.Parent == nil or p56.PrimaryPart ~= Root) then
        p56:PivotTo(p57);

        return;
    end;

    local v59 = p57 * Root.PivotOffset:Inverse();
    u52[1] = Root;
    u53[1] = v59;
    workspace:BulkMoveTo(u52, u53, Enum.BulkMoveMode.FireCFrameChanged);
end;

function u1.aim(p60) -- Line: 403
    -- upvalues: workspace_CurrentCamera (copy)
    p60.Bobble:setIsAiming(true);

    if p60.MuzzlePartWeld then
        local CFrame2 = workspace_CurrentCamera.CFrame;
        local WorldPivot = p60.Model.WorldPivot;
        local CFrame3 = p60.MuzzlePartWeld.Part0.CFrame;

        if p60.Mirror then
            WorldPivot = p60.Mirror:ToNormalPose(p60.Model:GetPivot());
            CFrame3 = p60.Mirror:ToNormalPose(CFrame3);
        end;

        local v61 = CFrame2 + CFrame2.UpVector * -0.5 + WorldPivot.LookVector * 1 + WorldPivot.RightVector * 0.1;
        p60.MuzzlePartWeld.C0 = CFrame3:Inverse() * v61;
    end;
end;

function u1.unaim(p62) -- Line: 425
    p62.Bobble:setIsAiming(false);

    if p62.OriginalC0 and p62.MuzzlePartWeld then
        p62.MuzzlePartWeld.C0 = p62.OriginalC0;
    end;
end;

function u1.unhide(p63) -- Line: 434
    -- upvalues: updateTransparency (copy)
    if p63.Hidden then
        updateTransparency(p63.Model, false);
        p63.Hidden = false;
    end;
end;

function u1.hide(p64) -- Line: 443
    -- upvalues: updateTransparency (copy)
    if not p64.Hidden then
        updateTransparency(p64.Model, true);
        p64.Hidden = true;
    end;
end;

function u1.equip(p65: any, p66: boolean) -- Line: 452
    -- upvalues: workspace_CurrentCamera (copy)
    p65.IsEquipped = true;

    if not p65.Model then
        return;
    end;

    if p65.Mirror then
        p65.Mirror:PrepareEquip();
    end;

    p65.Model.Parent = workspace_CurrentCamera;

    if p65.LargeWeaponModel then
        p65.LargeWeaponModel.Parent = workspace_CurrentCamera;
    end;

    p65.Animation:stopAnimations();
    p65.Animation:play("Idle");
    p65:unhide();

    if not p66 then
        p65.Animation:play(p65.Animation:pickVariant("Equip"));
    end;
end;

function u1.unequip(p67) -- Line: 478
    -- upvalues: u5 (ref), workspace_CurrentCamera (copy), pivotModel (copy), CFrame_new_ret (copy)
    p67.IsEquipped = false;
    p67.Animation:stopAnimations();
    p67.LastViewmodelPosition = nil;
    local Model = p67.Model;

    if Model and Model:IsDescendantOf(workspace) then
        local v68 = u5;

        if not v68 or v68.Parent ~= workspace_CurrentCamera then
            v68 = Instance.new("Folder");
            v68.Name = "ViewmodelStash";
            v68.Parent = workspace_CurrentCamera;
            u5 = v68;
        end;

        Model.Parent = v68;
        pivotModel(p67.PivotPlans, Model, CFrame_new_ret);
    end;

    if p67.LargeWeaponModel then
        p67.LargeWeaponModel.Parent = nil;
    end;
end;

function u1.applyCharmImpulse(p69: any, p70: vector) -- Line: 497
    if p69.LargeCharmModel and p69.LargeCharmModel.PrimaryPart then
        local CharmMassCache = p69.CharmMassCache;

        if p69.CharmMassCacheModel ~= p69.LargeCharmModel or typeof(CharmMassCache) ~= "number" then
            CharmMassCache = 0;

            for _, descendant in ipairs(p69.LargeCharmModel:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    CharmMassCache = CharmMassCache + descendant:GetMass();
                end;
            end;

            p69.CharmMassCache = CharmMassCache;
            p69.CharmMassCacheModel = p69.LargeCharmModel;
        end;

        p69.LargeCharmModel.PrimaryPart:ApplyImpulse(p70 * 10 * CharmMassCache);
    end;
end;

function u1.render(p71: any, p72: number) -- Line: 520
    -- upvalues: updateChargeFrame (copy), DataController (copy), table_freeze_ret (copy), workspace_CurrentCamera (copy), ViewmodelHand (copy), pivotModel (copy)
    local v73 = p71.Model and p71.Model:FindFirstChild("Stats");

    if not v73 then
        return;
    end;

    debug.profilebegin("Viewmodel.render.UpdateChargeFrame");
    updateChargeFrame(p71, p72);
    debug.profileend();
    debug.profilebegin("Viewmodel.render.GetViewmodelSettings");
    local v74 = DataController.Get(p71.Player, "Settings.Game.Viewmodel") or table_freeze_ret;
    debug.profileend();

    if p71.Bobble or p71.Inspecting then
        debug.profilebegin("Viewmodel.render.BobbleNextCFrame");
        local NextCFrame, v75, v76 = p71.Bobble:getNextCFrame(p72);
        debug.profileend();
        local Value = v73.Rotation.Value;
        local v77 = workspace_CurrentCamera.CFrame * NextCFrame * CFrame.Angles(Value.X, Value.Y, Value.Z) * CFrame.new(v73.Default.Value) * CFrame.new((v74["X Offset"] or 0) / 100, (v74["Y Offset"] or 0) / 100, (v74["Z Offset"] or 0) / 100);
        debug.profilebegin("Viewmodel.render.PivotModel");
        local PivotPlans = p71.PivotPlans;
        local Mirror = p71.Mirror;

        if Mirror then
            local v78 = not p71.WeaponComponent.Character and ViewmodelHand.IsPlayerLeftHanded(p71.Player);
            Mirror:SetLeftHanded(v78);
            pivotModel(PivotPlans, p71.Model, Mirror:GetDisplayPose(workspace_CurrentCamera.CFrame, v77));
            Mirror:UpdateSurfaces();
        else
            pivotModel(PivotPlans, p71.Model, v77);
        end;

        debug.profileend();

        if p71.LargeWeaponModel and p71.SmallWeaponModel then
            local Pivot = p71.SmallWeaponModel:GetPivot();

            if Mirror then
                Pivot = Mirror:ToNormalPose(Pivot);
            end;

            debug.profilebegin("Viewmodel.render.PivotLargeWeaponModel");
            pivotModel(PivotPlans, p71.LargeWeaponModel, Pivot);
            debug.profileend();
            local Position = v77.Position;

            if p71.LastViewmodelPosition then
                p71:applyCharmImpulse(-(Position - p71.LastViewmodelPosition) * 0.2);
            end;

            p71.LastViewmodelPosition = Position;
        end;

        if p71.Bobble.Scope and p71.Bobble.IsAiming then
            debug.profilebegin("Viewmodel.render.Scope");
            local CFrame2 = workspace_CurrentCamera.CFrame;
            p71.Bobble.Scope:PivotTo(CFrame2 + CFrame2.LookVector * 0.15 + v75 + (v76.X * -CFrame2.LookVector + v76.Y * -CFrame2.UpVector));

            if p71.Bobble.ScopeReticlePart then
                p71.Bobble.ScopeReticlePart.CFrame = CFrame2 * CFrame.Angles(1.5707963267948966, 1.5707963267948966, -1.5707963267948966) + CFrame2.LookVector * 0.15;
            end;

            debug.profileend();
        end;
    end;
end;

function u1.attachSleeves(p79: any, p80: string) -- Line: 600
    -- upvalues: ReplicatedStorage (copy)
    local v81 = ReplicatedStorage.Assets.Sleeves:FindFirstChild(p80);

    if not v81 then
        return;
    end;

    for _, child in ipairs(v81:GetChildren()) do
        local v82 = p79.Model:FindFirstChild(child.Name);

        if v82 then
            local v83 = child:Clone();
            v83.CastShadow = false;
            v83.CanCollide = false;
            v83.CanTouch = false;
            v83.Anchored = false;
            v83.CanQuery = false;
            v83.Name = "Sleeve";
            v83.Size = Vector3.new(v82.Size.X * 1.3, v82.Size.Y * 1.4, v82.Size.Z * 0.79);
            local v84 = v82.Size.Z / 2 - v83.Size.Z / 2;
            v83.Parent = v82;
            local Motor6D = Instance.new("Motor6D", v83);
            Motor6D.Part0 = v82;
            Motor6D.Part1 = v83;
            Motor6D.C1 = CFrame.new(0, -0.02, -v84);
        end;
    end;
end;

local function resolveInventoryGlove(p85: userdata, p86: string) -- Line: 637
    -- upvalues: Router (copy)
    local v87 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p85, p86);

    if v87 then
        return v87.Name, v87.Skin, v87.Float;
    end;

    return nil, nil, nil;
end;

function u1.addAttachments(p88, p89) -- Line: 645
    -- upvalues: Router (copy), u3 (copy), Skins (copy), u4 (ref), AttachGlovesToViewmodel (copy)
    debug.profilebegin("Viewmodel.addAttachments");
    local v90 = nil;
    local v91 = nil;
    local v92 = nil;

    if type(p89) == "string" then
        local v93 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p88.Player, p89);

        if v93 then
            v90 = v93.Name;
            v91 = v93.Skin;
            v92 = v93.Float;
        else
            v90 = nil;
            v91 = nil;
            v92 = nil;
        end;
    elseif type(p89) == "table" then
        local SkinIdentifier = p89.SkinIdentifier;

        if type(SkinIdentifier) == "string" and SkinIdentifier ~= "" then
            local v94 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p88.Player, SkinIdentifier);

            if v94 then
                v90 = v94.Name;
                v91 = v94.Skin;
                v92 = v94.Float;
            else
                v90 = nil;
                v91 = nil;
                v92 = nil;
            end;
        end;

        if not (v90 or (type(p89.Name) ~= "string" or type(p89.Skin) ~= "string")) then
            v90 = p89.Name;
            v91 = p89.Skin;

            if typeof(p89.Float) == "number" then
                v92 = p89.Float;
            else
                v92 = nil;
            end;
        end;
    end;

    if v90 and v91 then
        debug.profilebegin("Viewmodel.addAttachments.GetGloves");
        local v95 = `{v90}|{v91}|{v92 or ""}`;
        local v96 = u3[v95];

        if not v96 then
            local Gloves = Skins.GetGloves(v90, v91, v92);
            v96 = u3[v95];

            if v96 then
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

                u3[v95] = Gloves;
                u4 = u4 + 1;
                v96 = Gloves;
            else
                v96 = Gloves;
            end;
        end;

        debug.profileend();

        if v96 then
            debug.profilebegin("Viewmodel.addAttachments.AttachGloves");
            AttachGlovesToViewmodel(v96:GetChildren(), p88.Model);
            debug.profileend();
        end;
    end;

    debug.profileend();
end;

function u1.construct(p97: any, p98: userdata, p99: any) -- Line: 701
    -- upvalues: Janitor (copy), Skins (copy), stripWeaponGeometry (copy), getCharacterKey (copy), HttpService (copy), GetMuzzleFlash (copy), Camera (copy), weldLooseParts (copy), ReplicatedStorage (copy), Players (copy), BakedViewmodelMirror (copy)
    debug.profilebegin("Viewmodel.construct");

    if p97.ModelJanitor then
        debug.profilebegin("Viewmodel.construct.DestroyModelJanitor");
        p97.ModelJanitor:Destroy();
        debug.profileend();
    end;

    p97.ModelJanitor = Janitor.new();
    p97.Mirror = nil;
    p97.CharmModel = nil;
    p97.LargeWeaponModel = nil;
    p97.SmallWeaponModel = nil;
    p97.LargeCharmModel = nil;
    p97.LastViewmodelPosition = nil;
    p97.ChargeFillFrame = nil;
    p97.ChargeTextLabel = nil;
    p97.ChargeFillBaseSize = nil;
    p97.DisplayedChargeAlpha = nil;

    if p97.Animation then
        debug.profilebegin("Viewmodel.construct.StopAnimations");
        p97.Animation:stopAnimations();
        debug.profileend();
    end;

    if p97.Model then
        debug.profilebegin("Viewmodel.construct.DestroyPreviousModel");
        p97.Model:Destroy();
        debug.profileend();
        p97.Model = nil;
    end;

    local v100 = p97.CameraModelWeapon or p97.Weapon;
    local Team = p97.Team;

    if v100 ~= "Smoke Grenade" or Team ~= "Counter-Terrorists" and Team ~= "Terrorists" then
        Team = nil;
    end;

    debug.profilebegin("Viewmodel.construct.GetCameraModel");
    p97.Model = Skins.GetCameraModel(v100, p97.Skin, p97.Float, p97.StatTrack, p97.NameTag, p97.Charm, p97.Stickers, Team);
    debug.profileend();

    if not p97.Model and p97.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.GetBaseWeaponModel");
        p97.Model = Skins.GetBaseWeaponModel(v100, "Camera");
        debug.profileend();
    end;

    if not p97.Model then
        debug.profileend();
        error((`Viewmodel.construct: Failed to get camera model for weapon "{v100}" with skin "{p97.Skin}"`));
    end;

    p97.Model.Name = v100;

    if p97.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.StripWeaponGeometry");
        stripWeaponGeometry(p97.Model);
        debug.profileend();
    end;

    p97.CharacterKey = getCharacterKey(p98);
    p97.Team = p98:GetAttribute("Team") or p97.Team;
    local Attribute = p98:GetAttribute("CharacterName");

    if type(Attribute) ~= "string" or Attribute == "" then
        Attribute = workspace:GetAttribute(p97.Team == "Counter-Terrorists" and "CTCharacter" or "TCharacter");
    end;

    if type(Attribute) == "string" and Attribute ~= "" then
        p97:attachSleeves(Attribute);
    end;

    local Attribute2 = p98:GetAttribute("EquippedGloves");

    if type(Attribute2) == "string" and Attribute2 ~= "" then
        debug.profilebegin("Viewmodel.construct.DecodeEquippedGloves");
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute2);
        debug.profileend();

        if success and result then
            p97:addAttachments(result);
        else
            p97:addAttachments(Attribute2);
        end;
    end;

    debug.profilebegin("Viewmodel.construct.SetupDescendants");

    for _, descendant in ipairs(p97.Model:GetDescendants()) do
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
    local v101 = p98:FindFirstChild("Body Colors");
    local v102 = nil;

    if v101 then
        v102 = v101.TorsoColor3;
    else
        local v103 = p98:FindFirstChild("Torso") or p98:FindFirstChild("UpperTorso");

        if v103 and v103:IsA("BasePart") then
            v102 = v103.Color;
        end;
    end;

    if v102 then
        for _, v in ipairs({ "Right Arm", "Left Arm" }) do
            local v104 = p97.Model:FindFirstChild(v);

            if v104 and v104:IsA("BasePart") then
                v104.Color = v102;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.CacheMuzzleParts");
    local Interactables = p97.Model:FindFirstChild("Interactables");
    local v105;

    if Interactables then
        v105 = Interactables:FindFirstChild("MuzzlePart", true) or (Interactables:FindFirstChild("MuzzlePartL", true) or Interactables:FindFirstChild("MuzzlePartR", true));
    else
        v105 = Interactables;
    end;

    p97.MuzzlePart = v105;

    if Interactables then
        p97.MuzzlePartL = Interactables:FindFirstChild("MuzzlePartL", true);
        p97.MuzzlePartR = Interactables:FindFirstChild("MuzzlePartR", true);

        if p97.MuzzlePartL and p97.MuzzlePartL:IsA("BasePart") then
            p97.MuzzlePartL.Transparency = 1;
        end;

        if p97.MuzzlePartR and p97.MuzzlePartR:IsA("BasePart") then
            p97.MuzzlePartR.Transparency = 1;
        end;
    end;

    if p97.MuzzlePart and p97.MuzzlePart:IsA("BasePart") then
        p97.MuzzlePart.Transparency = 1;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.ScaleTo");
    p97.Model:ScaleTo(0.1);
    debug.profileend();
    debug.profilebegin("Viewmodel.construct.CacheMuzzleWeld");

    if p97.MuzzlePart and not p97.MuzzlePart:FindFirstChild("WeldConstraint", true) then
        for _, descendant in ipairs(p97.Model:GetDescendants()) do
            if descendant:IsA("Weld") and (descendant.Part1 == v105 or descendant.Part0 == v105) then
                p97.MuzzlePartWeld = descendant;
                p97.OriginalC0 = descendant.C0;
                break;
            end;
        end;
    end;

    debug.profileend();
    local Properties = p99.Properties;

    if Properties then
        if Properties.ShootingOptions == "Dual" then
            local MuzzlePartL = p97.MuzzlePartL;

            if MuzzlePartL and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Camera, "Suppressor", "Motor6D");
                end;
            end;

            local MuzzlePartR = p97.MuzzlePartR;

            if MuzzlePartR and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Camera, "Suppressor", "Motor6D");
                end;
            end;
        else
            local MuzzlePart = p97.MuzzlePart;

            if MuzzlePart and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePart, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart, Camera, "Suppressor", "Motor6D");
                end;
            end;
        end;
    end;

    debug.profilebegin("Viewmodel.construct.FindCharmModel");
    local CharmBase = p97.Model:FindFirstChild("CharmBase", true);

    if CharmBase and CharmBase:IsA("Model") then
        local v106 = CharmBase:FindFirstChildOfClass("Model");

        if v106 and v106.PrimaryPart then
            p97.CharmModel = v106;
        end;
    end;

    debug.profileend();

    if p97.CharmModel then
        debug.profilebegin("Viewmodel.construct.SetupCharmPhysics");
        p97:setupCharmPhysics();
        debug.profileend();
    end;

    debug.profilebegin("Viewmodel.construct.SetModelReferences");

    if p97.Animation then
        p97.Animation:setModel(p97.Model);
    end;

    if p97.Bobble then
        local Bobble2 = p97.Bobble;
        Bobble2.Character = p98;
        Bobble2:setModel(p97.Model);
    end;

    debug.profileend();
    weldLooseParts(p97.Model);
    local ViewmodelMirrors = ReplicatedStorage:FindFirstChild("ViewmodelMirrors");
    local v107;

    if p97.Player == Players.LocalPlayer then
        v107 = not p99.Character and not p97.Inspecting;
    else
        v107 = false;
    end;

    if ViewmodelMirrors then
        ViewmodelMirrors = BakedViewmodelMirror.new(p97.Model, ViewmodelMirrors, v107);
    end;

    if ViewmodelMirrors and p97.ModelJanitor then
        p97.Mirror = ViewmodelMirrors;
        p97.ModelJanitor:Add(ViewmodelMirrors, "Destroy");
    end;

    debug.profilebegin("Viewmodel.construct.FinalEquipState");

    if p97.IsEquipped then
        p97:equip(false);
    else
        p97:unequip();
    end;

    debug.profileend();
    debug.profileend();
end;

function u1.setupCharmPhysics(u108) -- Line: 953
    -- upvalues: u2 (copy), RunServiceController (copy)
    debug.profilebegin("Viewmodel.setupCharmPhysics");
    local Parent = u108.CharmModel.Parent;

    if not (Parent and Parent.PrimaryPart) then
        debug.profileend();

        return;
    end;

    u108.CharmModel:PivotTo(Parent.PrimaryPart.CFrame * CFrame.new(0, 0, -1));
    local CharmModel = u108.CharmModel;
    local Model = u108.Model;
    local u109 = Model:FindFirstChild("Weapon") or (Model:FindFirstChild("WeaponL") or Model:FindFirstChild("WeaponR"));

    if not u109 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.setupCharmPhysics.CloneLargeProxy");
    local Model2 = Instance.new("Model");
    Model2.Name = u108.Model.Name;
    local u110 = {};

    for _, v in ipairs(u2) do
        local v111 = u108.Model:FindFirstChild(v);

        if v111 then
            local v112 = v111:Clone();
            u110[v111] = v112;
            local Descendants = v112:GetDescendants();

            for i, descendant in v111:GetDescendants() do
                u110[descendant] = Descendants[i];
            end;

            v112.Parent = Model2;
        end;
    end;

    Model2.WorldPivot = u108.Model:GetPivot();
    debug.profileend();
    local u113 = Model2:FindFirstChild("Weapon") or (Model2:FindFirstChild("WeaponL") or Model2:FindFirstChild("WeaponR"));

    if not u113 then
        Model2:Destroy();
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.setupCharmPhysics.TrimLargeProxy");

    local function relink(p114: any, p115: string) -- Line: 999
        -- upvalues: Model2 (copy), u110 (copy)
        local v116 = p114[p115];

        if v116 == nil or v116:IsDescendantOf(Model2) then
            return true;
        end;

        local v117 = u110[v116];

        if not v117 then
            return false;
        end;

        p114[p115] = v117;

        return true;
    end;

    for _, descendant in ipairs(Model2:GetDescendants()) do
        if descendant.Name == "ViewmodelLight" then
            descendant:Destroy();
        elseif descendant:IsA("JointInstance") or (descendant:IsA("WeldConstraint") or descendant:IsA("NoCollisionConstraint")) then
            local Part0 = descendant.Part0;
            local v118;

            if Part0 == nil or Part0:IsDescendantOf(Model2) then
                v118 = true;
            else
                local v119 = u110[Part0];

                if v119 then
                    descendant.Part0 = v119;
                    v118 = true;
                else
                    v118 = false;
                end;
            end;

            if v118 then
                local Part1 = descendant.Part1;
                local v120;

                if Part1 == nil or Part1:IsDescendantOf(Model2) then
                    v120 = true;
                else
                    local v121 = u110[Part1];

                    if v121 then
                        descendant.Part1 = v121;
                        v120 = true;
                    else
                        v120 = false;
                    end;
                end;

                if not v120 then
                    descendant:Destroy();
                end;
            else
                descendant:Destroy();
            end;
        elseif descendant:IsA("Constraint") then
            local Attachment0 = descendant.Attachment0;
            local v122;

            if Attachment0 == nil or Attachment0:IsDescendantOf(Model2) then
                v122 = true;
            else
                local v123 = u110[Attachment0];

                if v123 then
                    descendant.Attachment0 = v123;
                    v122 = true;
                else
                    v122 = false;
                end;
            end;

            if v122 then
                local Attachment1 = descendant.Attachment1;
                local v124;

                if Attachment1 == nil or Attachment1:IsDescendantOf(Model2) then
                    v124 = true;
                else
                    local v125 = u110[Attachment1];

                    if v125 then
                        descendant.Attachment1 = v125;
                        v124 = true;
                    else
                        v124 = false;
                    end;
                end;

                if not v124 then
                    descendant:Destroy();
                end;
            else
                descendant:Destroy();
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.setupCharmPhysics.ScaleAndPivotProxy");
    Model2:ScaleTo(1 / u108.Model:GetScale());
    Model2:PivotTo(u109.Parent:GetPivot());

    if u113.PrimaryPart then
        u113.PrimaryPart.Anchored = true;
    end;

    local BoundingBox = Model2:GetBoundingBox();

    if Model2.PrimaryPart then
        Model2.PrimaryPart.PivotOffset = Model2.PrimaryPart.CFrame:ToObjectSpace(BoundingBox);
    else
        Model2.WorldPivot = BoundingBox;
    end;

    Model2.PrimaryPart = u113.PrimaryPart;
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
    local v126;

    if CharmBase and CharmBase:IsA("Model") then
        v126 = CharmBase:FindFirstChildOfClass("Model");

        if v126 then
            for _, descendant in ipairs(v126:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = true;
                    descendant.CollisionGroup = "Charm";
                end;
            end;
        end;
    else
        v126 = nil;
    end;

    debug.profileend();
    u108.LargeWeaponModel = u113.Parent;
    u108.SmallWeaponModel = u109;
    u108.LargeCharmModel = v126;

    if v126 and u108.ModelJanitor then
        local v127 = RunServiceController.CreateBindingName("Classes.Viewmodel.CharmSync");
        u108.ModelJanitor:Add(RunServiceController.BindToPostSimulation(v127, function() -- Line: 1089
            -- upvalues: u108 (copy), CharmModel (copy), u113 (copy), u109 (copy)
            local LargeCharmModel = u108.LargeCharmModel;

            if not (u108.IsEquipped and (LargeCharmModel and (LargeCharmModel.PrimaryPart and CharmModel.PrimaryPart))) then
                return;
            end;

            local v128 = u113:GetPivot():ToObjectSpace(LargeCharmModel:GetPivot());
            local v129 = CFrame.new(v128.Position / 10) * CFrame.fromOrientation(v128:ToOrientation());
            CharmModel:PivotTo(u109:GetPivot() * v129);
        end));
    end;

    if u108.CharmModel.PrimaryPart then
        u108.CharmModel.PrimaryPart.Anchored = true;
    end;

    if not u108.ModelJanitor then
        debug.profileend();

        return;
    end;

    u108.ModelJanitor:Add(function() -- Line: 1115
        -- upvalues: Model2 (copy), u108 (copy)
        Model2:Destroy();
        u108.LargeWeaponModel = nil;
        u108.SmallWeaponModel = nil;
        u108.LargeCharmModel = nil;
    end);
    debug.profileend();
end;

function u1.new(p130: any, p131: string, p132: string, p133: boolean?) -- Line: 1127
    -- upvalues: u1 (copy), Janitor (copy), getCarryOverKey (copy), Sound (copy), Animation (copy), Bobble (copy), CharacterResolver (copy)
    debug.profilebegin("Viewmodel.new");
    local u134 = setmetatable({}, u1);
    u134.Janitor = Janitor.new();
    u134.ModelJanitor = Janitor.new();
    u134.IsDestroyed = false;
    u134.Inspecting = p133;
    u134.Player = p130.Player;
    u134.Team = (p130.Character or u134.Player):GetAttribute("Team");
    u134.WeaponComponent = p130;
    u134.Weapon = p131;
    u134.CameraModelWeapon = p130.ViewmodelCameraWeapon or p131;
    u134.HideWeaponGeometry = p130.ViewmodelHideWeaponGeometry == true;
    u134.Skin = p132;
    u134.StatTrack = p130.StatTrack;
    u134.Stickers = p130.Stickers;
    u134.NameTag = p130.NameTag;
    u134.Float = p130.Float;
    u134.Charm = p130.Charm;
    u134.Hidden = false;
    u134.IsEquipped = false;
    u134.PivotPlans = setmetatable({}, {
        __mode = "k"
    });
    local v135;

    if p133 then
        v135 = nil;
    else
        v135 = getCarryOverKey(p130, p131, p132);
    end;

    u134.CarryOverKey = v135;
    debug.profilebegin("Viewmodel.new.Sound");
    u134.Sound = Sound.new(u134.CameraModelWeapon);
    debug.profileend();
    debug.profilebegin("Viewmodel.new.Animation");
    u134.Animation = Animation.new(u134.Player, u134.Sound);
    debug.profileend();
    debug.profilebegin("Viewmodel.new.Bobble");
    u134.Bobble = Bobble.new(p130);
    debug.profileend();
    local v136 = p130.Character or u134.Player.Character;

    if v136 then
        debug.profilebegin("Viewmodel.new.InitialConstruct");
        local success, result = pcall(u134.construct, u134, v136, p130);
        debug.profileend();

        if not success then
            debug.profileend();
            error(result, 2);
        end;
    end;

    if not p130.Character then
        local u137 = v136;
        u134.Janitor:Add(CharacterResolver.observeCharacter(u134.Player, function(p138) -- Line: 1193
            -- upvalues: u137 (ref), u134 (copy)
            if p138 and p138 ~= u137 then
                u134:adoptCharacter(p138);
            end;

            u137 = nil;

            return function() -- Line: 1198
            end;
        end));
    end;

    u134.Janitor:Add(function() -- Line: 1203
        -- upvalues: u134 (copy)
        if u134.ModelJanitor then
            u134.ModelJanitor:Destroy();
            u134.ModelJanitor = nil;
        end;
    end);
    debug.profileend();

    return u134;
end;

function u1.adoptCharacter(p139: any, p140: userdata) -- Line: 1216
    -- upvalues: getCharacterKey (copy)
    if p139.Model and p139.CharacterKey == getCharacterKey(p140) then
        p139.Bobble.Character = p140;

        return;
    end;

    if p139.WeaponComponent then
        p139:construct(p140, p139.WeaponComponent);
    end;
end;

function u1.release(p141) -- Line: 1227
    -- upvalues: u6 (copy), flushCarryOver (copy)
    local CarryOverKey = p141.CarryOverKey;

    if p141.IsDestroyed or not (p141.Model and CarryOverKey) then
        p141:destroy();

        return;
    end;

    if p141.Bobble.IsAiming then
        p141:unaim();
    end;

    p141:unequip();
    p141.WeaponComponent = nil;
    local v142 = {
        Viewmodel = p141,
        Key = CarryOverKey,
        ExpiresAt = os.clock() + 5
    };
    table.insert(u6, v142);
    task.delay(5.1, flushCarryOver);
end;

function u1.claim(p143: any, p144: string, p145: string) -- Line: 1245
    -- upvalues: getCarryOverKey (copy), u6 (copy)
    local v146 = getCarryOverKey(p143, p144, p145);

    if not v146 then
        return nil;
    end;

    for i, v in u6 do
        local Viewmodel = v.Viewmodel;

        if v.Key == v146 and not Viewmodel.IsDestroyed then
            table.remove(u6, i);
            Viewmodel.WeaponComponent = p143;
            Viewmodel.StatTrack = p143.StatTrack;
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

function u1.destroy(p147) -- Line: 1270
    if not p147.IsDestroyed then
        debug.profilebegin("Viewmodel.destroy");
        p147.IsDestroyed = true;

        if p147.Animation then
            p147.Animation:stopAnimations();
            p147.Animation:destroy();
            p147.Animation = nil;
        end;

        if p147.Bobble then
            p147.Bobble:destroy();
            p147.Bobble = nil;
        end;

        if p147.Sound then
            p147.Sound:destroy();
            p147.Sound = nil;
        end;

        if p147.Model then
            p147.Model.Parent = nil;
            p147.Model:Destroy();
            p147.Model = nil;
        end;

        p147.Janitor:Destroy();
        p147.Janitor = nil;
        p147.StatTrack = nil;
        p147.Stickers = nil;
        p147.NameTag = nil;
        p147.Player = nil;
        p147.Weapon = nil;
        p147.Float = nil;
        p147.Charm = nil;
        p147.Skin = nil;
        p147.Team = nil;
        p147.MuzzlePartWeld = nil;
        p147.MuzzlePartL = nil;
        p147.MuzzlePartR = nil;
        p147.MuzzlePart = nil;
        p147.OriginalC0 = nil;
        p147.CharmModel = nil;
        p147.LargeCharmModel = nil;
        p147.LargeWeaponModel = nil;
        debug.profileend();
    end;
end;

return u1;