-- ReplicatedStorage.GameClient.Entities.Character
-- Script path: ReplicatedStorage.GameClient.Entities.Character
-- Decompile time: 19.11 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local Characters = workspace:WaitForChild("Characters");
local Character = ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Character;
local Signal = require(ReplicatedStorage.Shared.Utility.Signal);
local SnapshotInterp = require(ReplicatedStorage.Shared.Utility.SnapshotInterp);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = "Default";
local u14 = false;
local u15 = {};
local u16 = {
    MeshPart = { "TextureID" },
    Decal = { "Texture" },
    Texture = { "Texture" }
};
local u17 = {
    LeftHand = true,
    RightHand = true,
    LowerTorso = true,
    LeftFoot = true,
    RightFoot = true
};

local function ApplyCharacterShadow(p18) -- Line: 57
    -- upvalues: u13 (ref), u17 (copy)
    if p18:IsA("BasePart") then
        local v19;

        if u13 == "Highest" then
            v19 = true;
        elseif u13 == "Default" then
            v19 = not u17[p18.Name];
        else
            v19 = false;
        end;

        p18.CastShadow = v19;
    end;
end;

local function ApplyCharacterShadows(p20: userdata) -- Line: 64
    -- upvalues: u13 (ref), u17 (copy)
    if p20:IsA("BasePart") and p20:IsA("BasePart") then
        local v21;

        if u13 == "Highest" then
            v21 = true;
        elseif u13 == "Default" then
            v21 = not u17[p20.Name];
        else
            v21 = false;
        end;

        p20.CastShadow = v21;
    end;

    for _, v in p20:QueryDescendants("BasePart") do
        if v:IsA("BasePart") then
            local v22;

            if u13 == "Highest" then
                v22 = true;
            elseif u13 == "Default" then
                v22 = not u17[v.Name];
            else
                v22 = false;
            end;

            v.CastShadow = v22;
        end;
    end;
end;

local function GetCharacterGloves(p23: number, p24: string?) -- Line: 73
    -- upvalues: Players (copy), HttpService (copy)
    if p23 then
        p23 = Players:GetPlayerByUserId(p23);
    end;

    if p23 then
        p23 = p23:GetAttribute("WeaponLoadout");
    end;

    if not (p23 and p24) then
        return;
    end;

    local v25 = HttpService:JSONDecode(p23)[p24];

    if v25 then
        v25 = v25["16"];
    end;

    if v25 then
        return {
            WeaponName = v25.WeaponName,
            SkinName = v25.SkinName
        };
    end;
end;

local function ApplyCharacterAccessories(p26) -- Line: 94
    -- upvalues: u14 (ref)
    if p26.Accessories then
        local v27;

        if u14 then
            v27 = nil;
        else
            v27 = p26.Model;
        end;

        p26.Accessories.Parent = v27;
    end;
end;

local function ApplySpawnProtection(p28, p29) -- Line: 101
    local SpawnProtection = p28.Model:FindFirstChild("SpawnProtection");
    local SpawnProtectionHighlight = p28.Model:FindFirstChild("SpawnProtectionHighlight");

    if not p29:GetAttribute("SpawnProtected") then
        if SpawnProtection then
            SpawnProtection:Destroy();
        end;

        if SpawnProtectionHighlight then
            SpawnProtectionHighlight:Destroy();
        end;

        return;
    end;

    local v30 = SpawnProtection or Instance.new("ForceField");
    v30.Name = "SpawnProtection";
    v30.Parent = p28.Model;
    local v31 = SpawnProtectionHighlight or Instance.new("Highlight");
    v31.Name = "SpawnProtectionHighlight";
    v31.DepthMode = Enum.HighlightDepthMode.Occluded;
    v31.FillColor = Color3.fromRGB(110, 147, 255);
    v31.FillTransparency = 0.9;
    v31.OutlineColor = Color3.new(1, 1, 1);
    v31.OutlineTransparency = 0.15;
    v31.Parent = p28.Model;
end;

local function TextureCategory(p32, p33) -- Line: 124
    if p32.CurrentWeaponModel and p33:IsDescendantOf(p32.CurrentWeaponModel) then
        return "Weapon Textures";
    end;

    local v34 = p33;

    while p33 and p33 ~= p32.Model do
        local string_lower_ret = string.lower(p33.Name);
        local v35 = p33:IsA("Accessory") and p33:GetAttribute("Part");

        if string.find(string_lower_ret, "glove", 1, true) or (v35 == "LeftHand" or v35 == "RightHand") then
            return "Glove Textures";
        end;

        p33 = p33.Parent;
    end;

    return p32.Accessories and v34:IsDescendantOf(p32.Accessories) and "Accessory Textures" or "Character Textures";
end;

local function ApplyTextureSetting(p36, p37) -- Line: 148
    -- upvalues: TextureCategory (copy), u15 (copy), u16 (copy)
    local v38 = TextureCategory(p36, p37);

    if not u15[v38] or p36.TextureBackups[p37] then
        return;
    end;

    if p37:IsA("SurfaceAppearance") then
        p36.TextureBackups[p37] = {
            Category = v38,
            Parent = p37.Parent
        };
        p37.Parent = nil;

        return;
    end;

    local v39 = u16[p37.ClassName];

    if not v39 then
        return;
    end;

    local v40 = {
        Category = v38,
        Properties = {}
    };

    for _, v in v39 do
        v40.Properties[v] = p37[v];
        p37[v] = "";
    end;

    p36.TextureBackups[p37] = v40;
end;

local function ApplyCharacterTextures(p41) -- Line: 173
    -- upvalues: u15 (copy), ApplyTextureSetting (copy)
    for i, v in p41.TextureBackups do
        if not u15[v.Category] then
            local v42;

            if v.Parent then
                if v.Parent.Parent then
                    i.Parent = v.Parent;
                    v42 = i;
                else
                    v42 = i;
                end;
            else
                v42 = i;

                for i2, v2 in v.Properties do
                    v42[i2] = v2;
                end;
            end;

            p41.TextureBackups[v42] = nil;
        end;
    end;

    for _, descendant in p41.Model:GetDescendants() do
        ApplyTextureSetting(p41, descendant);
    end;

    if p41.Accessories and not p41.Accessories.Parent then
        for _, descendant in p41.Accessories:GetDescendants() do
            ApplyTextureSetting(p41, descendant);
        end;
    end;
end;

local function DiscardTextureBackups(p43, p44) -- Line: 200
    for i, v in p43.TextureBackups do
        if not p44 or v.Category == p44 then
            if v.Parent then
                i:Destroy();
            end;

            p43.TextureBackups[i] = nil;
        end;
    end;
end;

local u45 = nil;
local u46 = nil;
local u47 = nil;
local u48 = nil;
local u49 = 3;

local function RefreshConfig() -- Line: 216
    -- upvalues: u47 (ref), u6 (ref), u48 (ref), u49 (ref)
    u47 = u6.Get("Character", "StandCollisionSize");
    u48 = u6.Get("Character", "DuckCollisionSize");
    local v50 = u6.Get("Game", "LegSolveTicks") or 3;
    u49 = math.max(v50, 1);
end;

local u51 = nil;
local u52 = nil;
local workspace_CurrentCamera = workspace.CurrentCamera;
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 231
    -- upvalues: workspace_CurrentCamera (ref)
    workspace_CurrentCamera = workspace.CurrentCamera;
end);
local u53 = Vector3.new(0, 0, 0);
local u54 = 1;
local u55 = false;
local u56 = 0;

function v1.BeginFrame(p57: number?) -- Line: 258
    -- upvalues: u56 (ref), workspace_CurrentCamera (ref), u55 (ref), u53 (ref), u9 (ref), u54 (ref)
    u56 = p57 or 0;

    if not workspace_CurrentCamera then
        u55 = false;

        return;
    end;

    u55 = true;
    u53 = u9.GetAppliedCFrame().Position;
    u54 = u9.GetFovDistanceScale();
end;

local function ApparentDistance(p58: vector) -- Line: 271
    -- upvalues: u55 (ref), u53 (ref), u54 (ref)
    return not u55 and 0 or vector.magnitude(u53 - p58) * u54;
end;

local function LODAlpha(p59: number) -- Line: 291
    return math.clamp((p59 - 50) / 70, 0, 1);
end;

local function GroundCastInterval(p60: number) -- Line: 308
    return p60 > 0 and p60 / 6 or 0;
end;

local function LODInterval(p61: number) -- Line: 337
    return p61 / 30;
end;

local function DuckTarget(p62) -- Line: 358
    return p62.Ducking and (p62.Ducked and 0 or 1) or (p62.Ducked and 1 or 0);
end;

local function LadderNormal(p63) -- Line: 375
    return p63.Climbing and p63.LadderNormal or nil;
end;

local function VelocityWithReplicatedY(p64: any, p65: any, p66: any, p67: number) -- Line: 397
    local VelocityY = p66.VelocityY;

    if not VelocityY then
        return p64;
    end;

    local v68 = p65.VelocityY or VelocityY;

    return vector.create(p64.X, v68 + (VelocityY - v68) * p67, p64.Z);
end;

local function SmoothHorizontal(p69: any, p70: vector, p71: number) -- Line: 432
    local SmoothedVelocity = p69.SmoothedVelocity;

    if SmoothedVelocity then
        local v72 = 1 - math.exp(p71 * -16);
        p70 = vector.create(SmoothedVelocity.X + (p70.X - SmoothedVelocity.X) * v72, p70.Y, SmoothedVelocity.Z + (p70.Z - SmoothedVelocity.Z) * v72);
    end;

    p69.SmoothedVelocity = p70;

    return p70;
end;

local function ApplyHidden(p73) -- Line: 455
    -- upvalues: u46 (ref), u8 (ref), u2 (ref)
    local v74 = u46.IsHiddenTarget(p73.Identifier) or false;
    u8.Update(p73);

    if p73.HiddenApplied == v74 then
        return v74;
    end;

    p73.HiddenApplied = v74;
    u2.SetTransparency(p73.Model, v74 and 1 or 0);

    if not v74 then
        u2.SetSilencerTransparency(p73, p73.AnimationMode == 2 and 1 or 0);

        if p73.Defusing then
            u2.SetOffhandTransparency(p73, 1);
        end;
    end;

    return v74;
end;

local function ApplyCull(p75) -- Line: 514
    if not p75.Model then
        return false;
    end;

    local v76 = p75.FogCulled == true;

    if p75.Culled == v76 then
        return v76;
    end;

    p75.Culled = v76;

    if v76 then
        p75.PrimaryPart:PivotTo(p75.CFrame + Vector3.new(0, -1000000, 0));

        return v76;
    end;

    p75.PrimaryPart:PivotTo(p75.CFrame);

    return v76;
end;

local function Render(p77: any, p78: any, p79: number) -- Line: 572
    -- upvalues: u55 (ref), u53 (ref), u54 (ref), u7 (ref), ApplyHidden (copy), u2 (ref), u46 (ref), u56 (ref), u49 (ref)
    local v80 = not u55 and 0 or vector.magnitude(u53 - p77.Position) * u54;
    local math_clamp_ret = math.clamp((v80 - 50) / 70, 0, 1);
    local v81 = u7:VisiblePoint(p77.Position + Vector3.new(0, 2.5, 0), 5);
    local v82;

    if p77.Model then
        v82 = p77.FogCulled == true;

        if p77.Culled ~= v82 then
            p77.Culled = v82;

            if v82 then
                p77.PrimaryPart:PivotTo(p77.CFrame + Vector3.new(0, -1000000, 0));
            else
                p77.PrimaryPart:PivotTo(p77.CFrame);
            end;
        end;
    else
        v82 = false;
    end;

    p77.InFrustum = v81;
    local v83;

    if v81 then
        v83 = not v82;
    else
        v83 = v81;
    end;

    local v84 = ApplyHidden(p77);
    local v85;

    if v83 then
        v85 = not v84;
    else
        v85 = v83;
    end;

    local v86 = p77.AimPunchAngle or Vector3.new(0, 0, 0);
    p77.CFrame = u2.Pose(p77.Model, p77.BodyYaw, p77.Position, p77.Yaw + math.rad(v86.Y), p77.Pitch - math.rad(v86.X), v83);
    p77.LODDelta = (p77.LODDelta or 0) + p79;
    local v87 = p77.LODDelta >= math_clamp_ret / 30;

    if p77.Legs == nil then
        v81 = false;
    elseif v81 then
        v81 = not (v84 or v82);
    end;

    if p77.Legs == nil then
        v85 = false;
    elseif v85 then
        v85 = not v82;
    end;

    if u46.GetCurrentMode() ~= "FirstPerson" and (p77.NameTag and p77.NameTag.Enabled ~= v81) then
        p77.NameTag.Enabled = v81;
        p77.NameTag.Active = v81;
    end;

    if v85 then
        local v88 = not p77.LegsSolved;
        local math_floor_ret = math.floor((u56 + p77.Identifier) / u49);

        if v88 or p77.LegBucket ~= math_floor_ret then
            p77.LegBucket = math_floor_ret;

            if v88 then
                p77.Legs:Snap();
            end;

            local LegDuck = p77.LegDuck;

            if LegDuck then
                p77.Legs.DuckAmount = LegDuck;
            end;

            local v89;

            if p78.Climbing then
                v89 = p78.LadderNormal or nil;
            else
                v89 = nil;
            end;

            if not LegDuck then
                if p77.Ducking then
                    LegDuck = p77.Ducked and 0 or 1;
                else
                    LegDuck = p77.Ducked and 1 or 0;
                end;
            end;

            p77.Legs:Update(nil, p77.CFrame, p77.Velocity, p77.OnGround ~= false, v89, LegDuck, math_clamp_ret > 0 and math_clamp_ret / 6 or 0);
        end;

        if v88 or v87 then
            p77.Legs:Apply((u56 + p77.Identifier) % u49 / u49);
        end;
    end;

    p77.LegsSolved = v85;
    p77.AnimationAlpha = p78.AnimationAlpha;

    if v83 and v87 then
        u2.ChaseAnimationAlpha(p77, p77.LODDelta);
        u2.UpdateAnimation(p77);
        p77.LODDelta = 0;
    end;
end;

local function Interpolate(p90, p91, p92, p93, p94, p95) -- Line: 655
    -- upvalues: u3 (ref), SnapshotInterp (copy), Render (copy)
    p90.Position = vector.lerp(p91.Position, p92.Position, p93);
    p90.Yaw = u3.LerpAngle(p91.Yaw, p92.Yaw, p93);
    p90.Pitch = u3.LerpAngle(p91.Pitch, p92.Pitch, p93);
    p90.AimPunchAngle = vector.lerp(p91.AimPunchAngle or Vector3.new(0, 0, 0), p92.AimPunchAngle or Vector3.new(0, 0, 0), p93);
    p90.Ducked = SnapshotInterp.Snap(p93, p91.Ducked, p92.Ducked);
    p90.Ducking = SnapshotInterp.Snap(p93, p91.Ducking, p92.Ducking);
    p90.OnGround = SnapshotInterp.Snap(p93, p91.OnGround, p92.OnGround);
    p90.LegDuck = p91.LegDuck;
    local v96;

    if p94 > 0 then
        v96 = (p92.Position - p91.Position) / p94;
    else
        v96 = p90.Velocity or Vector3.new(0, 0, 0);
    end;

    local SmoothedVelocity = p90.SmoothedVelocity;

    if SmoothedVelocity then
        local v97 = 1 - math.exp(p95 * -16);
        v96 = vector.create(SmoothedVelocity.X + (v96.X - SmoothedVelocity.X) * v97, v96.Y, SmoothedVelocity.Z + (v96.Z - SmoothedVelocity.Z) * v97);
    end;

    p90.SmoothedVelocity = v96;
    p90.Velocity = v96;
    p90.BodyYaw = u3.LerpAngle(p91.BodyYaw or p91.Yaw, p92.BodyYaw or p92.Yaw, p93);
    Render(p90, p92, p95);
end;

local function Extrapolate(p98, p99, p100, p101, p102, p103) -- Line: 711
    -- upvalues: Render (copy)
    local v104 = (p100.Position - p99.Position) / p102;
    p98.Position = p100.Position + v104 * p101;
    p98.Yaw = p100.Yaw;
    p98.Pitch = p100.Pitch;
    p98.AimPunchAngle = p100.AimPunchAngle or Vector3.new(0, 0, 0);
    p98.Ducked = p100.Ducked;
    p98.Ducking = p100.Ducking;
    p98.OnGround = p100.OnGround;
    p98.LegDuck = p100.LegDuck;
    local SmoothedVelocity = p98.SmoothedVelocity;

    if SmoothedVelocity then
        local v105 = 1 - math.exp(p103 * -16);
        v104 = vector.create(SmoothedVelocity.X + (v104.X - SmoothedVelocity.X) * v105, v104.Y, SmoothedVelocity.Z + (v104.Z - SmoothedVelocity.Z) * v105);
    end;

    p98.SmoothedVelocity = v104;
    local VelocityY = p100.VelocityY;

    if VelocityY then
        local v106 = p99.VelocityY or VelocityY;
        v104 = vector.create(v104.X, v106 + (VelocityY - v106) * 1, v104.Z);
    end;

    p98.Velocity = v104;
    p98.BodyYaw = p100.BodyYaw or p100.Yaw;
    Render(p98, p100, p103);
end;

local function Destroy(p107) -- Line: 741
    -- upvalues: u52 (ref), u8 (ref), u2 (ref)
    u52.Destroy(p107);
    u8.Destroy(p107);

    if p107.SpawnProtectionConnection then
        p107.SpawnProtectionConnection:Disconnect();
    end;

    if p107.Legs then
        p107.Legs:Destroy();
    end;

    if p107.CurrentWeaponChanged then
        p107.CurrentWeaponChanged:Destroy();
    end;

    if p107.CurrentWeaponInventoryDataChanged then
        p107.CurrentWeaponInventoryDataChanged:Destroy();
    end;

    if p107.WeaponInventoryChanged then
        p107.WeaponInventoryChanged:Destroy();
    end;

    u2.DestroyAnimations(p107);

    for i, v in p107.TextureBackups do
        if v.Parent then
            i:Destroy();
        end;

        p107.TextureBackups[i] = nil;
    end;

    if p107.Accessories and not p107.Accessories.Parent then
        p107.Accessories:Destroy();
    end;

    if p107.Model then
        p107.Model:Destroy();
    end;

    table.clear(p107);
end;

function v1.new(p108: number, p109: any) -- Line: 785
    -- upvalues: Signal (ref), u11 (ref), u2 (ref), ApplyCharacterTextures (copy), u12 (ref), u4 (ref), Characters (copy), GetCharacterGloves (copy), u14 (ref), u7 (ref), u5 (ref), u47 (ref), u48 (ref), Character (copy), u52 (ref), u8 (ref), Players (copy), ApplySpawnProtection (copy), ApplyHidden (copy), Interpolate (copy), Extrapolate (copy), Destroy (copy), ApplyCull (copy), ApplyCharacterShadows (copy)
    local u110 = {
        Identifier = p108,
        CurrentWeaponChanged = Signal.new(),
        CurrentWeaponInventoryDataChanged = Signal.new(),
        WeaponInventoryChanged = Signal.new(),
        CharacterCurrentWeapon = u11.GetCharacterCurrentWeapon(p108),
        WeaponInventory = u11.GetCharacterWeaponInventory(p108) or {},
        CurrentWeaponModel = nil,
        CurrentAnimationName = nil,
        TextureBackups = {},
        DirtyShadow = true,
        AnimationAlpha = nil
    };
    u110.CurrentWeaponChanged:Connect(function(p111) -- Line: 807
        -- upvalues: u110 (copy), u2 (ref), ApplyCharacterTextures (ref)
        local CurrentWeaponModel = u110.CurrentWeaponModel;
        u2.EquipWeapon(u110, p111);

        if u110.CurrentWeaponModel ~= CurrentWeaponModel then
            local v112 = u110;

            for i, v in v112.TextureBackups do
                if v.Category == "Weapon Textures" then
                    if v.Parent then
                        i:Destroy();
                    end;

                    v112.TextureBackups[i] = nil;
                end;
            end;
        end;

        ApplyCharacterTextures(u110);
    end);
    u110.CurrentWeaponInventoryDataChanged:Connect(function(p113) -- Line: 816
        -- upvalues: u2 (ref), u110 (copy)
        u2.SyncWeaponAnimation(u110, p113);
    end);
    local v114 = p109.State and (u12:UnpackScheme(p109.State) or {}) or {};
    u110.Position = v114.Position or Vector3.new(0, 0, 0);
    u110.Yaw = v114.Yaw or 0;
    u110.Pitch = v114.Pitch or 0;
    u110.AimPunchAngle = v114.AimPunchAngle or Vector3.new(0, 0, 0);
    u110.BodyYaw = v114.BodyYaw or (v114.Yaw or 0);
    u110.WalkPhase = 0;
    u110.Ducked = v114.Ducked or false;
    u110.Ducking = v114.Ducking or false;
    u110.LegDuck = v114.LegDuck;
    u110.OnGround = v114.OnGround or false;
    u110.Velocity = v114.Velocity;
    u110.AnimationAlpha = v114.AnimationAlpha;
    u110.Health = v114.Health or 100;

    if p109.UserId then
        u110.UserId = p109.UserId;
    else
        warn("NO USER ID");
    end;

    p109.State = nil;
    u110.CFrame = CFrame.identity;
    u110.Movable = true;
    u110.Data = {
        Team = u4.Teams[p109.Team],
        Agent = u4.Items.Agents[p109.Agent]
    };
    u110.Model = u2.new({
        Name = p108,
        Parent = Characters,
        Agent = u110.Data.Agent,
        Gloves = GetCharacterGloves(u110.UserId, u110.Data.Team)
    });

    if u110.Model:FindFirstChildOfClass("AnimationController") then
        u110.Model:FindFirstChildOfClass("AnimationController"):Destroy();
    end;

    u110.Accessories = u110.Model:FindFirstChild("Accessories");

    if u110.Accessories then
        local v115;

        if u14 then
            v115 = nil;
        else
            v115 = u110.Model;
        end;

        u110.Accessories.Parent = v115;
    end;

    ApplyCharacterTextures(u110);
    u110.PrimaryPart = u110.Model.PrimaryPart;
    u110.CollisionBox = u110.Model:FindFirstChild("CollisionBox");
    local v116 = CFrame.new(u110.Position + u2.RenderOffset) * CFrame.fromEulerAnglesYXZ(0, u110.Yaw, 0);
    u110.PrimaryPart:PivotTo(v116);
    u110.CFrame = v116;
    u110.OldCFrame = v116;
    u110.InFrustum = u7:VisiblePoint(u110.Position + Vector3.new(0, 2.5, 0), 5);
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = { u110.Model };
    RaycastParams_new_ret.RespectCanCollide = false;
    u110.Legs = u5.new(u110.Model, {
        DuckDrop = u47.Y - u48.Y,
        LadderReach = u47.X * 0.5,
        WalkFolder = Character.Walk,
        CrouchFolder = Character.Crouch,
        ClimbFolder = Character.Climb
    });

    if u110.Legs then
        u110.Legs:EnableTransforms();
    end;

    u52.Create(u110);
    u8.Update(u110);
    local u117 = u110.UserId and Players:GetPlayerByUserId(u110.UserId);

    if u117 then
        ApplySpawnProtection(u110, u117);
        u110.SpawnProtectionConnection = u117:GetAttributeChangedSignal("SpawnProtected"):Connect(function() -- Line: 923
            -- upvalues: ApplySpawnProtection (ref), u110 (copy), u117 (copy)
            ApplySpawnProtection(u110, u117);
        end);
    end;

    ApplyHidden(u110);
    u110.Interpolate = Interpolate;
    u110.Extrapolate = Extrapolate;
    u110.Destroy = Destroy;
    u110.ApplyCull = ApplyCull;
    u2.InitAnimations(u110, u110.Model);

    if u110.CharacterCurrentWeapon then
        u2.EquipWeapon(u110, u110.CharacterCurrentWeapon);
        ApplyCharacterTextures(u110);
    end;

    ApplyCharacterShadows(u110.Model);

    return u110;
end;

function v1.Init(p118) -- Line: 962
    -- upvalues: u9 (ref), u2 (ref), u3 (ref), u4 (ref), u10 (ref), u51 (ref), u6 (ref), u7 (ref), Signal (ref), u11 (ref), u5 (ref), u45 (ref), u46 (ref), u8 (ref)
    u9 = p118:GetModule("CameraController");
    u2 = p118:GetModule("CharacterModel");
    u3 = p118:GetModule("Math");
    u4 = p118:GetModule("Enums");
    u10 = p118:GetModule("BufferScheme");
    u51 = p118:GetModule("Gui");
    u6 = p118:GetModule("GameConfiguration");
    u7 = p118:GetModule("FrustumCuller").Shared();
    Signal = p118:GetModule("Signal");
    u11 = p118:GetModule("Entities");
    u5 = p118:GetModule("LegSystem") or require(script.Parent.Parent:WaitForChild("LegSystem"));
    u45 = p118:GetModule("CharacterController");
    u46 = p118:GetModule("Spectate");
    u8 = p118:GetModule("SpectatorHighlight");
end;

function v1.Start(p119) -- Line: 982
    -- upvalues: u12 (ref), u10 (ref), u52 (ref), u51 (ref), u13 (ref), Characters (copy), u17 (copy), u14 (ref), u11 (ref), u15 (copy), ApplyCharacterTextures (copy), u47 (ref), u6 (ref), u48 (ref), u49 (ref), RefreshConfig (copy)
    u12 = u10.GetScheme("EntityCharacter");
    u52 = u51.GetComponent("NameTag");
    local Component = u51.GetComponent("Settings");

    local function SetCharacterShadowMode(p120) -- Line: 987
        -- upvalues: u13 (ref), Characters (ref), u17 (ref)
        u13 = p120;

        for _, v in Characters:QueryDescendants("BasePart") do
            if v:IsA("BasePart") then
                local v121;

                if u13 == "Highest" then
                    v121 = true;
                elseif u13 == "Default" then
                    v121 = not u17[v.Name];
                else
                    v121 = false;
                end;

                v.CastShadow = v121;
            end;
        end;
    end;

    local PlayerSettings = Component:GetPlayerSettings();
    u13 = PlayerSettings and (PlayerSettings.Game and PlayerSettings.Game["Graphics & Visuals"]) and (PlayerSettings.Game["Graphics & Visuals"]["Character Shadows"] or "Default") or "Default";

    for _, v in Characters:QueryDescendants("BasePart") do
        if v:IsA("BasePart") then
            local v122;

            if u13 == "Highest" then
                v122 = true;
            elseif u13 == "Default" then
                v122 = not u17[v.Name];
            else
                v122 = false;
            end;

            v.CastShadow = v122;
        end;
    end;

    Component:AddConnection("Game", "Graphics & Visuals", "Character Shadows", SetCharacterShadowMode);

    local function SetRemoveCharacterAccessories(p123) -- Line: 1004
        -- upvalues: u14 (ref), u11 (ref)
        u14 = p123;

        for _, v in u11.GetAllCategoryEntities("Character") do
            if v.Accessories then
                local v124;

                if u14 then
                    v124 = nil;
                else
                    v124 = v.Model;
                end;

                v.Accessories.Parent = v124;
            end;
        end;
    end;

    local v125;

    if PlayerSettings and (PlayerSettings.Game and PlayerSettings.Game["Graphics & Visuals"]) then
        v125 = PlayerSettings.Game["Graphics & Visuals"]["Remove Character Accessories"] or false;
    else
        v125 = false;
    end;

    u14 = v125;

    for _, v in u11.GetAllCategoryEntities("Character") do
        if v.Accessories then
            local v126;

            if u14 then
                v126 = nil;
            else
                v126 = v.Model;
            end;

            v.Accessories.Parent = v126;
        end;
    end;

    Component:AddConnection("Game", "Graphics & Visuals", "Remove Character Accessories", SetRemoveCharacterAccessories);

    local function SetRemovedCharacterTextures(p127) -- Line: 1019
        -- upvalues: u15 (ref), u11 (ref), ApplyCharacterTextures (ref)
        table.clear(u15);

        for i, v in p127 or {} do
            if v == true then
                u15[i] = true;
            elseif typeof(v) == "string" then
                u15[v] = true;
            end;
        end;

        for _, v in u11.GetAllCategoryEntities("Character") do
            ApplyCharacterTextures(v);
        end;
    end;

    SetRemovedCharacterTextures(PlayerSettings and (PlayerSettings.Game and (PlayerSettings.Game["Graphics & Visuals"] and PlayerSettings.Game["Graphics & Visuals"]["Remove Character Textures"])) or {});
    Component:AddConnection("Game", "Graphics & Visuals", "Remove Character Textures", SetRemovedCharacterTextures);
    u47 = u6.Get("Character", "StandCollisionSize");
    u48 = u6.Get("Character", "DuckCollisionSize");
    local v128 = u6.Get("Game", "LegSolveTicks") or 3;
    u49 = math.max(v128, 1);
    u6.Updated:Connect(RefreshConfig);
end;

return v1;