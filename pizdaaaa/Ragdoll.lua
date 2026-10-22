-- ReplicatedStorage.GameClient.Ragdoll
-- Script path: ReplicatedStorage.GameClient.Ragdoll
-- Decompile time: 24.90 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local u2 = {
    CT = "Impacts.Body.BodyImpactCt",
    T = "Impacts.Body.BodyImpactTSoft"
};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.RespectCanCollide = false;
local u11 = {
    Remove = false,
    LimitCount = true,
    MaxCount = 8,
    LimitLifetime = false,
    Lifetime = 10,
    PredictMaxPing = 350
};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = nil;
local u19 = false;

local function RefreshConfig() -- Line: 135
    -- upvalues: u11 (copy), u8 (ref)
    u11.Enabled = u8.Get("Ragdoll", "Enabled");
    u11.FadeSpeed = u8.Get("Ragdoll", "FadeSpeed");
    u11.PredictMaxPing = u8.Get("Ragdoll", "PredictMaxPing");
end;

local function JointPose(p20: userdata) -- Line: 156
    -- upvalues: u7 (ref)
    local v21 = {};

    for _, v in u7.LimbOrder do
        local v22 = p20:FindFirstChild(v);

        if v22 and v22:IsA("BasePart") then
            v21[v] = v22.CFrame;
            local v23 = v;

            for _, child in v22:GetChildren() do
                if child:IsA("Motor6D") and (child.Part1 == v22 and child.Part0) then
                    v21[v23] = (v21[child.Part0.Name] or child.Part0.CFrame) * child.C0 * (v23 == u7.RootLimb and child.Transform or child.Transform.Rotation) * child.C1:Inverse();
                    break;
                end;
            end;
        end;
    end;

    return v21;
end;

local function PrepareModel(p24: userdata, p25: table?) -- Line: 190
    -- upvalues: JointPose (copy), u7 (ref)
    local v26 = p25 or JointPose(p24);
    local v27 = {};
    local v28 = false;

    for _, v in u7.LimbOrder do
        local v29 = p24:FindFirstChild(v);

        if v29 and v29:IsA("BasePart") then
            v27[v] = v29;
            v28 = true;
        end;
    end;

    if not v28 then
        return nil;
    end;

    for _, v in v27 do
        v.Anchored = true;
        v.CanCollide = false;
        v.CanQuery = false;
        v.CanTouch = false;
    end;

    local v30 = {};

    for _, v in p24:QueryDescendants("Motor6D, Highlight, ForceField") do
        if v:IsA("Motor6D") then
            local Part1 = v.Part1;

            if Part1 and v27[Part1.Name] == Part1 then
                v30[Part1.Name] = v.C1.Position;
            end;
        end;

        v:Destroy();
    end;

    for i, v in v27 do
        local v31 = v26[i];

        if v31 then
            v.CFrame = v31;
        end;
    end;

    for _, v in { "HumanoidRootPart", "CollisionBox" } do
        local v32 = p24:FindFirstChild(v);

        if v32 then
            v32:Destroy();
        end;
    end;

    return v27, v30;
end;

local function Impact(p33: any, p34: any, p35: number) -- Line: 269
    -- upvalues: SoundManager (copy), u2 (copy), RaycastParams_new_ret (copy)
    local ImpactSpeed = p34.ImpactSpeed;
    p34.ImpactSpeed = 0;

    if ImpactSpeed < SoundManager.Surfaces.MinSpeed or p35 < p33.NextImpact then
        return;
    end;

    p33.NextImpact = p35 + 0.15;
    local ImpactPosition = p34.ImpactPosition;
    local v36 = {
        Position = ImpactPosition,
        Volume = SoundManager.Surfaces.ImpactVolume(ImpactSpeed)
    };
    SoundManager.Play(SoundManager.Surfaces.HardSpeed <= ImpactSpeed and u2[p33.Team] or "Impacts.Body.BodyMediumImpactSoft", v36);
    local v37 = workspace:Raycast(ImpactPosition, Vector3.new(0, -2, 0), RaycastParams_new_ret);

    if v37 then
        SoundManager.PlaySurfaceImpact(v37.Material.Name, ImpactSpeed, v36);
    end;
end;

local function Build(p38: number, p39: userdata, p40: table, p41: table, p42: any, p43: string?) -- Line: 299
    -- upvalues: u6 (ref), u18 (ref), u15 (copy)
    local v44 = u6.new(p40, p41);

    if v44 then
        u6.ApplyLaunchVelocity(v44, p42.Velocity or Vector3.new(0, 0, 0));
        local Force = p42.Force;

        if Force and vector.magnitude(Force) > 0 then
            local ForceLimb = p42.ForceLimb;

            if ForceLimb == 0 or not ForceLimb then
                ForceLimb = nil;
            end;

            u6.ApplyDeathForce(v44, Force, ForceLimb);
        end;

        p39.Parent = u18;
        local v45 = {
            NextImpact = 0,
            Fading = false,
            Transparency = 0,
            Identifier = p38,
            Model = p39,
            Body = v44,
            Team = p43,
            CreatedAt = os.clock(),
            FadeParts = p39:QueryDescendants("BasePart")
        };
        table.insert(u15, v45);

        return v45;
    end;

    p39:Destroy();
end;

local function DropPending(p46: number) -- Line: 347
    -- upvalues: u13 (copy), u12 (copy)
    local v47 = u13[p46];

    if not v47 then
        return;
    end;

    u13[p46] = nil;
    v47.Model:Destroy();
    u12[p46] = nil;
end;

local function TryBuild(p48: number) -- Line: 364
    -- upvalues: u12 (copy), u13 (copy), Build (copy)
    local v49 = u12[p48];
    local v50 = u13[p48];

    if not (v49 and v50) then
        return;
    end;

    u12[p48] = nil;
    u13[p48] = nil;
    Build(p48, v50.Model, v50.Parts, v50.Pivots, v49, v50.Team);
end;

local function Remove(p51: number) -- Line: 380
    -- upvalues: u15 (copy)
    u15[p51].Model:Destroy();
    table.remove(u15, p51);
end;

local function HideRig(p52: userdata) -- Line: 401
    local v53 = 0;
    local v54 = {};
    local v55 = {};
    local v56 = {};
    local v57 = 0;
    local v58 = {};
    local v59 = {};

    for _, v in p52:QueryDescendants("BasePart, Decal, BillboardGui, Highlight") do
        if v:IsA("BasePart") then
            v53 = v53 + 1;
            v54[v53] = v;
            v55[v53] = v.Transparency;
            v56[v53] = v.CanQuery;
            v.Transparency = 1;
            v.CanQuery = false;
        elseif v:IsA("Decal") then
            v53 = v53 + 1;
            v54[v53] = v;
            v55[v53] = v.Transparency;
            v56[v53] = nil;
            v.Transparency = 1;
        elseif v:IsA("BillboardGui") or v:IsA("Highlight") then
            v57 = v57 + 1;
            v58[v57] = v;
            v59[v57] = v.Enabled;
            v.Enabled = false;
        end;
    end;

    return {
        Parts = v54,
        Transparency = v55,
        Query = v56,
        Overlays = v58,
        Enabled = v59
    };
end;

local function RestoreRig(p60) -- Line: 450
    for i, v in p60.Parts do
        if v.Parent then
            v.Transparency = p60.Transparency[i];
            local v61 = p60.Query[i];

            if v61 ~= nil then
                v.CanQuery = v61;
            end;
        end;
    end;

    for i, v in p60.Overlays do
        if v.Parent then
            v.Enabled = p60.Enabled[i];
        end;
    end;
end;

local function ReconcileHidden(p62: number) -- Line: 485
    -- upvalues: u4 (ref)
    local Entity = u4.GetEntity("Character", p62);

    if Entity then
        Entity.HiddenApplied = nil;
    end;
end;

local function RevertPrediction(p63: number) -- Line: 494
    -- upvalues: u14 (copy), u15 (copy), RestoreRig (copy), u4 (ref)
    local v64 = u14[p63];

    if not v64 then
        return;
    end;

    u14[p63] = nil;

    for i = #u15, 1, -1 do
        if u15[i].Provisional == p63 then
            u15[i].Model:Destroy();
            table.remove(u15, i);
            break;
        end;

        local _ = i;
    end;

    RestoreRig(v64.Hidden);
    local Entity = u4.GetEntity("Character", p63);

    if Entity then
        Entity.HiddenApplied = nil;
    end;

    if v64.HeldWeapon then
        v64.HeldWeapon.Parent = v64.HeldWeaponParent;
    end;
end;

local function SettlePrediction(p65: number, p66: string) -- Line: 524
    -- upvalues: u14 (copy)
    local v67 = u14[p65];

    if not v67 then
        return false;
    end;

    v67[p66] = true;
    v67.Confirmed = true;

    if v67.GotDeath and v67.GotDestroy then
        u14[p65] = nil;

        if v67.HeldWeapon then
            v67.HeldWeapon:Destroy();
        end;
    end;

    return true;
end;

local function Cleanup() -- Line: 547
    -- upvalues: u14 (copy), RestoreRig (copy), u4 (ref), u15 (copy), u13 (copy), u12 (copy)
    for i, v in u14 do
        u14[i] = nil;

        if not v.Confirmed then
            RestoreRig(v.Hidden);
            local Entity = u4.GetEntity("Character", i);

            if Entity then
                Entity.HiddenApplied = nil;
            end;
        end;

        if v.HeldWeapon then
            v.HeldWeapon:Destroy();
        end;
    end;

    for i = #u15, 1, -1 do
        u15[i].Model:Destroy();
        table.remove(u15, i);
        local _ = i;
    end;

    for i, v in u13 do
        u13[i] = nil;
        v.Model:Destroy();
    end;

    table.clear(u12);
end;

u1.Cleanup = Cleanup;

local function Fade(p68: any, p69: number) -- Line: 585
    -- upvalues: u11 (copy)
    p68.Transparency = math.min(p68.Transparency + u11.FadeSpeed * p69, 1);

    for _, v in p68.FadeParts do
        v.Transparency = p68.Transparency;
    end;

    return p68.Transparency >= 1;
end;

local function SimulateEntry(p70: any, p71: number, p72: number, p73: number) -- Line: 600
    -- upvalues: u6 (ref), Impact (copy), u16 (copy), u17 (copy)
    local Body = p70.Body;
    u6.Step(Body, p71);
    Impact(p70, Body, p72);

    if not Body.Sleeping or Body.Interpolating then
        p73 = u6.GetCFrames(Body, u16, u17, p73);
    end;

    return p73;
end;

local function Step(p74: number) -- Line: 614
    -- upvalues: u11 (copy), Cleanup (copy), u13 (copy), u12 (copy), u14 (copy), u4 (ref), RevertPrediction (copy), u15 (copy), SimulateEntry (copy), u16 (copy), u17 (copy)
    local os_clock_ret = os.clock();

    if u11.Remove then
        Cleanup();

        return;
    end;

    for i, v in u13 do
        if v.Deadline <= os_clock_ret then
            local v75 = u13[i];

            if v75 then
                u13[i] = nil;
                v75.Model:Destroy();
                u12[i] = nil;
            end;
        end;
    end;

    for i, v in u14 do
        if not v.Confirmed then
            local Player = v.Player;
            local v76 = Player.Parent ~= nil;
            local v77 = v76 and u4.GetHealth(Player) or 0;

            if v76 and (v77 > 0 and v.Health < v77) or v.Deadline <= os_clock_ret then
                local success, result = pcall(RevertPrediction, i);

                if not success then
                    u14[i] = nil;
                    local v78 = i;

                    for i2 = #u15, 1, -1 do
                        if u15[i2].Provisional == v78 then
                            u15[i2].Model:Destroy();
                            table.remove(u15, i2);
                            break;
                        end;

                        local _ = i2;
                    end;

                    warn((`[Ragdoll] RevertPrediction failed for {v78}: {result}`));
                end;
            end;
        end;
    end;

    local v79 = #u15;
    local v80 = u11.LimitCount and (v79 - u11.MaxCount or 0) or 0;
    local v81 = 0;

    for i = v79, 1, -1 do
        local v82 = u15[i];

        if not (v82.Fading or i > v80 and (not u11.LimitLifetime or os_clock_ret - v82.CreatedAt < u11.Lifetime)) then
            v82.Fading = true;
        end;

        local v83, v84, v85;

        if v82.Fading then
            v82.Transparency = math.min(v82.Transparency + u11.FadeSpeed * p74, 1);
            v83 = i;

            for _, v in v82.FadeParts do
                v.Transparency = v82.Transparency;
            end;

            if v82.Transparency < 1 then
                v84, v85 = pcall(SimulateEntry, v82, p74, os_clock_ret, v81);

                if v84 then
                    v81 = v85;
                else
                    v82.Fading = true;
                    warn((`[Ragdoll] simulation step failed for {v82.Identifier}: {v85}`));
                end;
            end;

            u15[v83].Model:Destroy();
            table.remove(u15, v83);
        else
            v83 = i;
            v84, v85 = pcall(SimulateEntry, v82, p74, os_clock_ret, v81);

            if v84 then
                v81 = v85;
            else
                v82.Fading = true;
                warn((`[Ragdoll] simulation step failed for {v82.Identifier}: {v85}`));
            end;
        end;
    end;

    if v81 == 0 then
        return;
    end;

    workspace:BulkMoveTo(u16, u17, Enum.BulkMoveMode.FireCFrameChanged);
    table.clear(u16);
    table.clear(u17);
end;

function u1.PredictionWindow() -- Line: 734
    -- upvalues: u10 (ref)
    local v86 = u10.GetLocalPing() / 1000 * 2 + 0.2;

    return math.clamp(v86, 0.2, 1);
end;

function u1.PredictDeath(p87: number, p88: any, p89: userdata, p90: any) -- Line: 744
    -- upvalues: u19 (ref), u11 (copy), u10 (ref), u14 (copy), u13 (copy), u12 (copy), PrepareModel (copy), JointPose (copy), Build (copy), u1 (copy), u4 (ref), HideRig (copy), SoundManager (copy)
    if not (u19 and (u11.Enabled and not u11.Remove)) then
        return false;
    end;

    if u10.GetLocalPing() > u11.PredictMaxPing then
        return false;
    end;

    if u14[p87] or (u13[p87] or u12[p87]) then
        return false;
    end;

    local Model = p88.Model;

    if not (Model and (Model.Parent and not p88.Culled)) then
        return false;
    end;

    local CurrentWeaponModel = p88.CurrentWeaponModel;
    local v91;

    if CurrentWeaponModel then
        v91 = CurrentWeaponModel.Parent;
    else
        v91 = CurrentWeaponModel;
    end;

    if CurrentWeaponModel then
        CurrentWeaponModel.Parent = nil;
    end;

    local v92 = Model:Clone();
    local v93, v94 = PrepareModel(v92, (JointPose(Model)));

    for _, v in v92:QueryDescendants("BillboardGui") do
        v:Destroy();
    end;

    if v93 then
        v93 = Build(p87, v92, v93, v94, p90, p88.Data and p88.Data.Team);
    end;

    if not v93 then
        v92:Destroy();

        if CurrentWeaponModel then
            CurrentWeaponModel.Parent = v91;
        end;

        return false;
    end;

    v93.Provisional = p87;
    local v95 = u1.PredictionWindow();
    u14[p87] = {
        Confirmed = false,
        GotDeath = false,
        GotDestroy = false,
        Player = p89,
        Health = u4.GetHealth(p89),
        Hidden = HideRig(Model),
        Deadline = os.clock() + v95,
        HeldWeapon = CurrentWeaponModel,
        HeldWeaponParent = v91
    };

    if CurrentWeaponModel then
        local u96 = u14[p87];
        CurrentWeaponModel.Destroying:Once(function() -- Line: 842
            -- upvalues: u96 (copy), CurrentWeaponModel (copy)
            if u96.HeldWeapon == CurrentWeaponModel then
                u96.HeldWeapon = nil;
            end;
        end);
    end;

    SoundManager.Play("Misc.Death", {
        Position = p90.Origin
    });

    return true;
end;

function u1.Init(p97) -- Line: 855
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (copy), RefreshConfig (copy)
    u3 = p97:GetModule("Network");
    u4 = p97:GetModule("Entities");
    u5 = p97:GetModule("Gui");
    u6 = p97:GetModule("RagdollPhysics");
    u7 = p97:GetModule("RagdollData");
    u8 = p97:GetModule("GameConfiguration");
    u9 = p97:GetModule("Tick");
    u10 = p97:GetModule("ClientModule");
    u11.Enabled = u8.Get("Ragdoll", "Enabled");
    u11.FadeSpeed = u8.Get("Ragdoll", "FadeSpeed");
    u11.PredictMaxPing = u8.Get("Ragdoll", "PredictMaxPing");
    u8.Updated:Connect(RefreshConfig);
end;

function u1.Start(p98) -- Line: 869
    -- upvalues: u18 (ref), RaycastParams_new_ret (copy), u5 (ref), u11 (copy), u3 (ref), u14 (copy), SoundManager (copy), u12 (copy), u13 (copy), Build (copy), u4 (ref), Players (copy), PrepareModel (copy), u19 (ref), u9 (ref), Step (copy)
    u18 = Instance.new("Folder");
    u18.Name = "Ragdolls";
    u18.Parent = workspace;
    RaycastParams_new_ret.FilterDescendantsInstances = { u18, workspace:WaitForChild("Characters") };
    local Component = u5.GetComponent("Settings");
    Component:AddConnection("Game", "Graphics & Visuals", "Remove Ragdolls", function(p99) -- Line: 878
        -- upvalues: u11 (ref)
        u11.Remove = p99;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Limit number of ragdolls", function(p100) -- Line: 881
        -- upvalues: u11 (ref)
        u11.LimitCount = p100;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Maximum number of ragdolls", function(p101) -- Line: 884
        -- upvalues: u11 (ref)
        u11.MaxCount = math.floor(p101);
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Lifetime of ragdolls", function(p102) -- Line: 887
        -- upvalues: u11 (ref)
        u11.LimitLifetime = p102;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Ragdoll Life time", function(p103) -- Line: 890
        -- upvalues: u11 (ref)
        u11.Lifetime = p103;
    end);
    local PlayerSettings = Component:GetPlayerSettings();
    local v104 = PlayerSettings.Game and PlayerSettings.Game["Graphics & Visuals"];

    if v104 then
        u11.Remove = v104["Remove Ragdolls"] or false;
        u11.LimitCount = v104["Limit number of ragdolls"] ~= false;
        u11.MaxCount = math.floor(v104["Maximum number of ragdolls"] or u11.MaxCount);
        u11.LimitLifetime = v104["Lifetime of ragdolls"] or false;
        u11.Lifetime = v104["Ragdoll Life time"] or u11.Lifetime;
    end;

    local CharacterDeath = u3.Entity.CharacterDeath;

    if not CharacterDeath then
        warn("[Ragdoll] Entity.CharacterDeath is missing from the generated Blink. Regenerate it (Blink/SCHEMA_CHANGES.md item 18); ragdolls are off until then.");

        return;
    end;

    CharacterDeath.On(function(p105) -- Line: 921
        -- upvalues: u14 (ref), SoundManager (ref), u11 (ref), u12 (ref), u13 (ref), Build (ref)
        if not u14[p105.Identifier] then
            SoundManager.Play("Misc.Death", {
                Position = p105.Origin
            });
        end;

        if not u11.Enabled or u11.Remove then
            return;
        end;

        local Identifier = p105.Identifier;
        local v106 = u14[Identifier];
        local v107;

        if v106 then
            v106.GotDeath = true;
            v106.Confirmed = true;

            if v106.GotDeath and v106.GotDestroy then
                u14[Identifier] = nil;

                if v106.HeldWeapon then
                    v106.HeldWeapon:Destroy();
                    v107 = true;
                else
                    v107 = true;
                end;
            else
                v107 = true;
            end;
        else
            v107 = false;
        end;

        if v107 then
            return;
        end;

        u12[p105.Identifier] = p105;
        local Identifier2 = p105.Identifier;
        local v108 = u12[Identifier2];
        local v109 = u13[Identifier2];

        if v108 then
            if not v109 then
                return;
            end;

            u12[Identifier2] = nil;
            u13[Identifier2] = nil;
            Build(Identifier2, v109.Model, v109.Parts, v109.Pivots, v108, v109.Team);
        end;
    end);
    u4.OnEntityDestroyed:Connect(function(p110: string, p111: number, p112: any) -- Line: 953
        -- upvalues: u11 (ref), u14 (ref), Players (ref), u12 (ref), PrepareModel (ref), u13 (ref), Build (ref)
        if p110 ~= "Character" or (not u11.Enabled or u11.Remove) then
            return;
        end;

        local v113 = u14[p111];
        local v114;

        if v113 then
            v113.GotDestroy = true;
            v113.Confirmed = true;

            if v113.GotDeath and v113.GotDestroy then
                u14[p111] = nil;

                if v113.HeldWeapon then
                    v113.HeldWeapon:Destroy();
                    v114 = true;
                else
                    v114 = true;
                end;
            else
                v114 = true;
            end;
        else
            v114 = false;
        end;

        if v114 then
            return;
        end;

        local UserId = p112.UserId;

        if UserId and not Players:GetPlayerByUserId(UserId) then
            u12[p111] = nil;

            return;
        end;

        local Model = p112.Model;

        if not (Model and (Model.Parent and not p112.Culled)) then
            return;
        end;

        local v115, v116 = PrepareModel(Model);

        if not v115 then
            return;
        end;

        p112.Model = nil;

        if p112.CurrentWeaponModel then
            p112.CurrentWeaponModel:Destroy();
            p112.CurrentWeaponModel = nil;
        end;

        local v117 = {
            Model = Model,
            Parts = v115,
            Pivots = v116
        };
        v117.Team = p112.Data and p112.Data.Team;
        v117.UserId = UserId;
        v117.Deadline = os.clock() + 0.25;
        u13[p111] = v117;
        local v118 = u12[p111];
        local v119 = u13[p111];

        if v118 then
            if not v119 then
                return;
            end;

            u12[p111] = nil;
            u13[p111] = nil;
            Build(p111, v119.Model, v119.Parts, v119.Pivots, v118, v119.Team);
        end;
    end);
    Players.PlayerRemoving:Connect(function(p120: userdata) -- Line: 1033
        -- upvalues: u13 (ref), u12 (ref)
        local UserId = p120.UserId;

        for i, v in u13 do
            if v.UserId == UserId then
                local v121 = u13[i];

                if v121 then
                    u13[i] = nil;
                    v121.Model:Destroy();
                    u12[i] = nil;
                end;
            end;
        end;
    end);
    u19 = true;
    u9.PostTick.Connect({
        Function = Step,
        Priority = 1,
        SubPriority = 4
    });
end;

return u1;