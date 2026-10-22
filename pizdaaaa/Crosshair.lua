-- ReplicatedStorage.GameClient.Gui.HUD.Crosshair
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Crosshair
-- Decompile time: 29.64 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local workspace_CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
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
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = 0;
local u23 = 0;
local u24 = 0;
local u25 = 0;
local u26 = false;
local u27 = false;
local u28 = false;
local u29 = true;
local u30 = nil;
local u31 = 1;
local u32 = 1;
local u33 = "";
local u34 = nil;
local u35 = nil;
local u36 = false;
local u37 = 0.05;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u38 = 0;
local u39 = 0;
local u40 = 0;
local u41 = nil;
local u42 = 0;
local u43 = nil;
local u44 = nil;
local u45 = 1;
local u46 = 1;
local u47 = 0.7002075382097097;
local UDim2_fromScale_ret = UDim2.fromScale(0.5, 0.5);
local u48 = nil;
local u49 = nil;

local function SetVisible(p50) -- Line: 80
    -- upvalues: u48 (ref), u2 (ref), u30 (ref), u31 (ref), u32 (ref)
    if u48 ~= p50 then
        u48 = p50;
        u2.Visible = p50;

        if not p50 and u30 then
            u30.Text = "";
            u30.TextTransparency = 1;
            u31 = 1;
            u32 = 1;
        end;
    end;
end;

local function GetViewerTeam(p51) -- Line: 93
    -- upvalues: u15 (ref), u14 (ref), LocalPlayer (copy)
    if p51 then
        local SpectateIdentifier = u15.GetSpectateIdentifier();
        local v52 = SpectateIdentifier and u14 and u14.GetEntity("Character", SpectateIdentifier);

        if v52 and (v52.Data and v52.Data.Team) then
            return v52.Data.Team;
        end;
    end;

    return LocalPlayer:GetAttribute("Team");
end;

local function IsEnemy(p53, p54) -- Line: 104
    -- upvalues: u15 (ref), LocalPlayer (copy), GameStats (copy), u14 (ref)
    if not (p53 and (not p53.Culled and p53.Model)) then
        return false;
    end;

    if p54 then
        if u15.GetSpectateIdentifier() == p53.Identifier then
            return false;
        end;
    elseif LocalPlayer and (p53.UserId and p53.UserId == LocalPlayer.UserId) then
        return false;
    end;

    if GameStats:GetAttribute("Gamemode") == "Deathmatch" then
        return true;
    end;

    local v55;

    if p54 then
        local SpectateIdentifier = u15.GetSpectateIdentifier();
        local v56 = SpectateIdentifier and u14 and u14.GetEntity("Character", SpectateIdentifier);

        if v56 and (v56.Data and v56.Data.Team) then
            v55 = v56.Data.Team;
        else
            v55 = LocalPlayer:GetAttribute("Team");
        end;
    else
        v55 = LocalPlayer:GetAttribute("Team");
    end;

    local v57 = p53.Data and p53.Data.Team;

    if v57 and v55 then
        return v57 ~= v55;
    end;

    return false;
end;

local function GetSniperSpreadDistance(p58, p59) -- Line: 126
    -- upvalues: u45 (ref)
    local Data = p58.Data;
    local v60 = Data.Spread[p58.Mode] * u45;
    local Zoom = Data.AltFunction.Zoom;
    local math_max_ret = math.max(p58.ZoomLevel > 1 and Zoom.Second or Zoom.First, 25);
    local v61 = math.max(p59 + v60 - Data.Inaccuracy.Stand[2] * u45 - v60, 0) * 320;
    local v62 = math.rad(math_max_ret) * 0.5;

    return v61 / math.tan(v62);
end;

local u63 = nil;

local function SetPos(p64) -- Line: 140
    -- upvalues: u63 (ref), u2 (ref)
    if u63 ~= p64 then
        u63 = p64;
        u2.Position = p64;
    end;
end;

local u65 = {};

local function GetDisplayInaccuracy(p66, p67) -- Line: 150
    -- upvalues: u65 (copy)
    local v68 = u65;
    local Data = p66.Data;
    local Mode = p66.Mode;
    local Constants = p67.Constants;
    local v69 = Data.Speed[Mode];
    local v70 = Data.Inaccuracy.Move[Mode];
    local v71 = Data.Inaccuracy.JumpInitial[Mode];
    local v72 = Data.Inaccuracy.Stand[Mode];

    if v68.Weapon == p66 and (v68.Penalty == p66.AccuracyPenalty and (v68.Velocity == p67.Velocity and (v68.OnGround == p67.OnGround and (v68.Walk == p67.IsWalking and (v68.Mode == Mode and (v68.Speed == v69 and (v68.Move == v70 and (v68.Jump == v71 and (v68.Stand == v72 and (v68.DuckModifier == Constants.DuckModifier and v68.JumpImpulse == Constants.JumpImpulse)))))))))) then
        return v68.Value;
    end;

    local AccuracyPenalty = p66.AccuracyPenalty;
    v68.Weapon = p66;
    v68.Penalty = AccuracyPenalty;
    local OnGround = p67.OnGround;
    local IsWalking = p67.IsWalking;
    v68.Velocity = p67.Velocity;
    v68.OnGround = OnGround;
    v68.Walk = IsWalking;
    v68.Mode = Mode;
    v68.Speed = v69;
    v68.Move = v70;
    v68.Jump = v71;
    v68.Stand = v72;
    local JumpImpulse = Constants.JumpImpulse;
    v68.DuckModifier = Constants.DuckModifier;
    v68.JumpImpulse = JumpImpulse;
    v68.Value = p66:GetInaccuracy(p67);

    return v68.Value;
end;

function u1.Update(p73) -- Line: 172
    -- upvalues: u15 (ref), u43 (ref), u29 (ref), u48 (ref), u2 (ref), u30 (ref), u31 (ref), u32 (ref), u16 (ref), u14 (ref), u13 (ref), u44 (ref), u1 (copy), UDim2_fromScale_ret (copy), u63 (ref), u6 (ref), u41 (ref), u42 (ref), u40 (ref), u7 (ref), u49 (ref), u4 (ref), GetDisplayInaccuracy (copy), GetSniperSpreadDistance (copy), workspace_CurrentCamera (ref), u45 (ref), u38 (ref), u47 (ref), u39 (ref), u5 (ref), u12 (ref), u46 (ref), u37 (ref), u34 (ref), u35 (ref), RaycastParams_new_ret (copy), IsEnemy (copy), Players (copy), u33 (ref), u36 (ref)
    local v74 = u15.IsSpectating();
    local v75;

    if v74 then
        v75 = u15.GetCurrentMode() == "FirstPerson";
    else
        v75 = v74;
    end;

    if not (u43 or v74) then
        local v76 = u29;

        if u48 ~= v76 then
            u48 = v76;
            u2.Visible = v76;

            if not v76 and u30 then
                u30.Text = "";
                u30.TextTransparency = 1;
                u31 = 1;
                u32 = 1;
            end;
        end;

        if u30 then
            u30.Text = "";
            u30.TextTransparency = 1;
        end;

        return;
    end;

    local v77 = nil;
    local v78 = nil;
    local v79, v80;

    if v75 then
        v79 = u15.GetSpectateWeapon();
        local v81, v82, v83;
        v81, v82, v83, v78, v80 = u16.Sample();
        local SpectateIdentifier = u15.GetSpectateIdentifier();

        if SpectateIdentifier and u14 then
            if not u14.GetEntity("Character", SpectateIdentifier) then
                v80 = v77;
            end;
        else
            v80 = v77;
        end;
    else
        v79 = u13.GetCurrentWeapon();
        v80 = u44 and (u44.RenderAimPunchAngle or u44.AimPunchAngle);
    end;

    if not v79 then
        local v84 = u29;

        if u48 ~= v84 then
            u48 = v84;
            u2.Visible = v84;

            if not v84 and u30 then
                u30.Text = "";
                u30.TextTransparency = 1;
                u31 = 1;
                u32 = 1;
            end;
        end;

        u1.Position(0);
        local v85 = UDim2_fromScale_ret;

        if u63 ~= v85 then
            u63 = v85;
            u2.Position = v85;
        end;

        return;
    end;

    local IsSniper = v79.IsSniper;
    local AltFunction = v79.Data.AltFunction;

    if AltFunction then
        if AltFunction.Name == "ScopeRifle" then
            AltFunction = (v79.IronSightAmount or 0) > 0.5;
        else
            AltFunction = false;
        end;
    end;

    local v86 = u29 and not (IsSniper or AltFunction);

    if u48 ~= v86 then
        u48 = v86;
        u2.Visible = v86;

        if not v86 and u30 then
            u30.Text = "";
            u30.TextTransparency = 1;
            u31 = 1;
            u32 = 1;
        end;
    end;

    local v87 = u6 and ((v79.Data.CrosshairMinDistance or 4) - 4 or 0) or 0;
    local v88 = v79.Data.Ammo or 0;

    if u6 and (v79 == u41 and v88 < u42) then
        u40 = u40 + (u42 - v88) * (v79.Data.CrosshairDeltaDistance or 0);
    end;

    u41 = v79;
    u42 = v88;
    local math_min_ret = math.min(1, p73 * 12);
    u40 = math.lerp(u40, 0, math_min_ret);

    if not u48 then
        if not IsSniper then
            return;
        end;

        if not u7 then
            u49.SetOffset(1);

            return;
        end;
    end;

    if (u4 or IsSniper and u7) and v79.Data.Inaccuracy then
        local v89 = v75 and (v78 or 0) or GetDisplayInaccuracy(v79, u44);

        if IsSniper then
            local v90 = GetSniperSpreadDistance(v79, v89);
            local math_clamp_ret = math.clamp(v90, 0, 100);
            u49.SetOffset(u7 and 1 - math_clamp_ret / 100 or 1);

            return;
        end;

        local v91 = workspace_CurrentCamera.ViewportSize.Y * 0.5;
        u38 = math.clamp((v89 + v79.Data.Spread[v79.Mode] * u45) * v91 / u47, 0, v91);
        u39 = u38;
        u1.Position(u39 + v87);
    else
        u1.Position(v87 + u40);
    end;

    if u5 then
        if v80 and (math.abs(v80.X) > 0.01 or math.abs(v80.Y) > 0.01) then
            local AppliedCFrame = u12.GetAppliedCFrame();
            local v92 = AppliedCFrame * CFrame.Angles(math.rad(v80.X * u46), math.rad(v80.Y * u46), 0);
            local v93, v94 = workspace_CurrentCamera:WorldToViewportPoint(AppliedCFrame.Position + v92.LookVector * 1000);

            if v94 then
                local ViewportSize = workspace_CurrentCamera.ViewportSize;
                local UDim2_fromScale_ret2 = UDim2.fromScale(v93.X / ViewportSize.X, v93.Y / ViewportSize.Y);

                if u63 ~= UDim2_fromScale_ret2 then
                    u63 = UDim2_fromScale_ret2;
                    u2.Position = UDim2_fromScale_ret2;
                end;
            else
                local v95 = UDim2_fromScale_ret;

                if u63 ~= v95 then
                    u63 = v95;
                    u2.Position = v95;
                end;
            end;
        else
            local v96 = UDim2_fromScale_ret;

            if u63 ~= v96 then
                u63 = v96;
                u2.Position = v96;
            end;
        end;
    else
        local v97 = UDim2_fromScale_ret;

        if u63 ~= v97 then
            u63 = v97;
            u2.Position = v97;
        end;
    end;

    u37 = u37 + p73;

    if u48 and workspace_CurrentCamera then
        if u37 >= 0.05 then
            u37 = 0;
            u34 = nil;
            local v98;

            if v75 then
                local SpectateIdentifier = u15.GetSpectateIdentifier();
                v98 = SpectateIdentifier and u14 and u14.GetEntity("Character", SpectateIdentifier);

                if v98 then
                    v98 = v98.Model;
                end;
            else
                v98 = u43 and u43.Model;
            end;

            if v98 ~= u35 then
                u35 = v98;
                RaycastParams_new_ret.FilterDescendantsInstances = v98 and { v98 } or {};
            end;

            local AppliedCFrame = u12.GetAppliedCFrame();
            local v99 = workspace:Raycast(AppliedCFrame.Position, AppliedCFrame.LookVector * 5000, RaycastParams_new_ret);

            if v99 and v99.Instance then
                local Instance2 = v99.Instance;

                for _, v in u14.GetAllCategoryEntities("Character") do
                    if v.Model and Instance2:IsDescendantOf(v.Model) then
                        if IsEnemy(v, v75) then
                            u34 = v;
                        end;

                        break;
                    end;
                end;
            end;

            if u34 then
                local UserId = u34.UserId;

                if UserId then
                    if UserId > 0 then
                        UserId = Players:GetPlayerByUserId(UserId);
                    else
                        UserId = false;
                    end;
                end;

                u33 = `Enemy: {UserId and UserId.Name or (u34.Data and u34.Data.Name or `BOT #{u34.Identifier}`)}`;
            end;
        end;
    else
        u34 = nil;
    end;

    u32 = u34 and 0.5 or 1;
    local math_min_ret2 = math.min(1, p73 * 14);
    u31 = math.lerp(u31, u32, math_min_ret2);

    if u30 then
        if u31 < 0.98 then
            u36 = false;
            u30.TextTransparency = u31;
            u30.Text = u33;

            return;
        end;

        if not u36 then
            u36 = true;
            u30.TextTransparency = 1;
            u30.Text = "";
        end;
    end;
end;

local u100 = -1000000000;
local u101 = -1000000000;
local u102 = -1000000000;

function u1.Position(p103) -- Line: 358
    -- upvalues: u22 (ref), u101 (ref), u25 (ref), u102 (ref), u100 (ref), u19 (ref), u18 (ref), u20 (ref), u21 (ref), u2 (ref)
    local v104 = p103 or 0;

    if u22 == u101 and (u25 == u102 and math.abs(v104 - u100) < 0.25) then
        return;
    end;

    u100 = v104;
    u101 = u22;
    u102 = u25;
    u19.Position = UDim2.new(0.5, 0, 0.5, u22 + v104);
    u18.Position = UDim2.new(0.5, 0, 0.5, -u22 - v104);
    u20.Position = UDim2.new(0.5, -u22 - v104, 0.5, 0);
    u21.Position = UDim2.new(0.5, u22 + v104, 0.5, 0);
    u2.Decal.Size = UDim2.fromOffset(u25 + v104 * 2, u25 + v104 * 2);
end;

function u1.Size(p105, p106) -- Line: 379
    -- upvalues: u2 (ref)
    u2.BottomFrame.Size = UDim2.fromOffset(p105, p106);
    u2.TopFrame.Size = UDim2.fromOffset(p105, p106);
    u2.LeftFrame.Size = UDim2.fromOffset(p106, p105);
    u2.RightFrame.Size = UDim2.fromOffset(p106, p105);
    u2.Dot.Size = UDim2.fromOffset(p105, p105);
end;

function u1.Color(p107) -- Line: 388
    -- upvalues: u2 (ref)
    u2.BottomFrame.BackgroundColor3 = p107;
    u2.TopFrame.BackgroundColor3 = p107;
    u2.LeftFrame.BackgroundColor3 = p107;
    u2.RightFrame.BackgroundColor3 = p107;
    u2.Dot.BackgroundColor3 = p107;
end;

function u1.Transparency(p108) -- Line: 397
    -- upvalues: u2 (ref)
    u2.BottomFrame.BackgroundTransparency = p108;
    u2.TopFrame.BackgroundTransparency = p108;
    u2.LeftFrame.BackgroundTransparency = p108;
    u2.RightFrame.BackgroundTransparency = p108;
    u2.Dot.BackgroundTransparency = p108;
end;

local function SetShape() -- Line: 406
    -- upvalues: u2 (ref), u28 (ref), u27 (ref), u26 (ref)
    u2.BottomFrame.Visible = not u28;
    u2.TopFrame.Visible = not (u28 or u27);
    u2.LeftFrame.Visible = not u28;
    u2.RightFrame.Visible = not u28;
    u2.Dot.Visible = u26 and not u28;
    u2.Decal.Visible = u28;
end;

function u1.Dot(p109) -- Line: 416
    -- upvalues: u26 (ref), u2 (ref), u28 (ref), u27 (ref)
    u26 = p109;
    u2.BottomFrame.Visible = not u28;
    u2.TopFrame.Visible = not (u28 or u27);
    u2.LeftFrame.Visible = not u28;
    u2.RightFrame.Visible = not u28;
    u2.Dot.Visible = u26 and not u28;
    u2.Decal.Visible = u28;
end;

function u1.TStyle(p110) -- Line: 421
    -- upvalues: u27 (ref), u2 (ref), u28 (ref), u26 (ref)
    u27 = p110;
    u2.BottomFrame.Visible = not u28;
    u2.TopFrame.Visible = not (u28 or u27);
    u2.LeftFrame.Visible = not u28;
    u2.RightFrame.Visible = not u28;
    u2.Dot.Visible = u26 and not u28;
    u2.Decal.Visible = u28;
end;

function u1.Decal(p111, p112) -- Line: 426
    -- upvalues: u28 (ref), u2 (ref), u27 (ref), u26 (ref)
    u28 = p111;

    if p111 then
        u2.Decal.Image = p112;
    end;

    u2.BottomFrame.Visible = not u28;
    u2.TopFrame.Visible = not (u28 or u27);
    u2.LeftFrame.Visible = not u28;
    u2.RightFrame.Visible = not u28;
    u2.Dot.Visible = u26 and not u28;
    u2.Decal.Visible = u28;
end;

function u1.ImageColor(p113) -- Line: 435
    -- upvalues: u2 (ref)
    u2.Decal.ImageColor3 = p113;
end;

function u1.ImageTransparency(p114) -- Line: 439
    -- upvalues: u2 (ref)
    u2.Decal.ImageTransparency = p114;
end;

function u1.ImageRotation(p115) -- Line: 443
    -- upvalues: u2 (ref)
    u2.Decal.Rotation = p115;
end;

function u1.ImagePixelated(p116) -- Line: 447
    -- upvalues: u2 (ref)
    u2.Decal.ResampleMode = p116 and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default;
end;

function u1.Outline(p117) -- Line: 451
    -- upvalues: u17 (ref)
    for _, v in u17 do
        if p117 == 0 then
            v.Border.Enabled = false;
        else
            v.Border.Thickness = p117;
            v.Border.Enabled = true;
        end;
    end;
end;

function u1.OutlineTransparency(p118) -- Line: 462
    -- upvalues: u17 (ref)
    for _, v in u17 do
        v.Border.Transparency = p118;
    end;
end;

function u1.OutlineColor(p119) -- Line: 468
    -- upvalues: u17 (ref)
    for _, v in u17 do
        v.Border.Color = p119;
    end;
end;

function u1.SetVisible(p120) -- Line: 474
    -- upvalues: u29 (ref), u10 (ref), RunService (copy), u1 (copy), u48 (ref), u2 (ref), u30 (ref), u31 (ref), u32 (ref)
    u29 = p120;

    if u29 then
        u10:Add("PostSimulation", RunService.PostSimulation:Connect(u1.Update));

        return;
    end;

    if u48 ~= false then
        u48 = false;
        u2.Visible = false;

        if u30 then
            u30.Text = "";
            u30.TextTransparency = 1;
            u31 = 1;
            u32 = 1;
        end;
    end;

    u10:Cleanup();
end;

function u1.Init(p121, p122) -- Line: 484
    -- upvalues: u8 (ref), u9 (ref), u10 (ref), u3 (ref), u49 (ref), u11 (ref), u12 (ref), u45 (ref), u46 (ref), u65 (copy), workspace_CurrentCamera (ref), u13 (ref), u15 (ref), u14 (ref), u16 (ref), u1 (copy), u43 (ref), u44 (ref), u30 (ref), u31 (ref), u32 (ref), u4 (ref), u38 (ref), u39 (ref), u7 (ref), u5 (ref), u22 (ref), u23 (ref), u24 (ref), u6 (ref), u25 (ref), u47 (ref)
    u8 = p121:GetModule("Math");
    u9 = p121:GetModule("Gui");
    u10 = p121:GetModule("Maid").new();
    u3 = u9.GetComponent("Settings");
    u49 = u9.GetComponent("Scope");
    u11 = p121:GetModule("CharacterController");
    u12 = p121:GetModule("CameraController");
    local Module = p121:GetModule("GameConfiguration");

    local function RefreshScales() -- Line: 493
        -- upvalues: u45 (ref), Module (copy), u46 (ref)
        u45 = Module.Get("Weapon", "SpreadScale") or 1;
        u46 = Module.Get("Weapon", "HitboxRecoilScale") or 1;
    end;

    u45 = Module.Get("Weapon", "SpreadScale") or 1;
    u46 = Module.Get("Weapon", "HitboxRecoilScale") or 1;
    Module.Updated:Connect(function() -- Line: 498
        -- upvalues: u65 (ref), u45 (ref), Module (copy), u46 (ref)
        table.clear(u65);
        u45 = Module.Get("Weapon", "SpreadScale") or 1;
        u46 = Module.Get("Weapon", "HitboxRecoilScale") or 1;
    end);
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 502
        -- upvalues: workspace_CurrentCamera (ref)
        workspace_CurrentCamera = workspace.CurrentCamera;
    end);
    u13 = p121:GetModule("WeaponController");
    u15 = p121:GetModule("Spectate");
    u14 = p121:GetModule("Entities");
    u16 = p121:GetModule("SpectateInterp");
    u1.new();
    u11.OnCharacterSpawn:Connect(function(p123) -- Line: 516
        -- upvalues: u43 (ref), u44 (ref)
        u43 = p123;
        u44 = u43.Simulation;
    end);
    u11.OnCharacterDestroy:Connect(function() -- Line: 521
        -- upvalues: u43 (ref), u44 (ref), u65 (ref), u30 (ref), u31 (ref), u32 (ref)
        u43 = nil;
        u44 = nil;
        table.clear(u65);

        if u30 then
            u30.Text = "";
            u30.TextTransparency = 1;
            u31 = 1;
            u32 = 1;
        end;
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Style", function(p124) -- Line: 535
        -- upvalues: u4 (ref), u38 (ref), u39 (ref), u1 (ref)
        u4 = p124 == "Dynamic";

        if not u4 then
            u38 = 0;
            u39 = 0;
            u1.Position();
        end;
    end);
    u3:AddConnection("Game", "Gameplay", "Show Scoped Sniper Rifle Inaccuracy", function(p125) -- Line: 545
        -- upvalues: u7 (ref), u49 (ref)
        u7 = p125;

        if not p125 then
            u49.SetOffset(1);
        end;
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Follow Recoil", function(p126) -- Line: 552
        -- upvalues: u5 (ref)
        u5 = p126;
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Color", function(p127) -- Line: 556
        -- upvalues: u1 (ref)
        u1.Color(Color3.fromRGB(unpack(p127)));
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Gap", function(p128) -- Line: 560
        -- upvalues: u22 (ref), u1 (ref)
        u22 = p128;
        u1.Position();
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Length", function(p129) -- Line: 566
        -- upvalues: u23 (ref), u1 (ref), u24 (ref)
        u23 = p129;
        u1.Size(u24, u23);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Thickness", function(p130) -- Line: 570
        -- upvalues: u24 (ref), u1 (ref), u23 (ref)
        u24 = p130;
        u1.Size(u24, u23);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Dot Enabled", function(p131) -- Line: 575
        -- upvalues: u1 (ref)
        u1.Dot(p131);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair T Style", function(p132) -- Line: 579
        -- upvalues: u1 (ref)
        u1.TStyle(p132);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Outline", function(p133) -- Line: 583
        -- upvalues: u1 (ref)
        u1.Outline(p133);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Outline Transparency", function(p134) -- Line: 587
        -- upvalues: u1 (ref)
        u1.OutlineTransparency(p134);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Outline Color", function(p135) -- Line: 591
        -- upvalues: u1 (ref)
        u1.OutlineColor(Color3.fromRGB(unpack(p135)));
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Transparency", function(p136) -- Line: 595
        -- upvalues: u1 (ref)
        u1.Transparency(p136);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Deployed Weapon Gap", function(p137) -- Line: 599
        -- upvalues: u6 (ref)
        u6 = p137;
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Image", function(p138) -- Line: 603
        -- upvalues: u1 (ref), u3 (ref)
        u1.Decal(p138 ~= "", u3.CrosshairImage(p138));
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Image Size", function(p139) -- Line: 607
        -- upvalues: u25 (ref), u1 (ref)
        u25 = p139;
        u1.Position();
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Image Color", function(p140) -- Line: 613
        -- upvalues: u1 (ref)
        u1.ImageColor(Color3.fromRGB(unpack(p140)));
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Image Transparency", function(p141) -- Line: 617
        -- upvalues: u1 (ref)
        u1.ImageTransparency(p141);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Crosshair Image Rotation", function(p142) -- Line: 621
        -- upvalues: u1 (ref)
        u1.ImageRotation(p142);
    end);
    u3:AddPlayerConnection("Game", "Crosshair", "Pixelated Crosshair Image", function(p143) -- Line: 625
        -- upvalues: u1 (ref)
        u1.ImagePixelated(p143);
    end);
    u3:AddPlayerConnection("Game", "Gameplay", "Field Of View", function(p144) -- Line: 629
        -- upvalues: u47 (ref)
        local v145 = math.rad(p144) * 0.5;
        u47 = math.tan(v145);
    end);
end;

function u1.new() -- Line: 637
    -- upvalues: u2 (ref), u9 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u30 (ref)
    u2 = Instance.new("Frame");
    u2.Name = "Crosshair";
    u2.AnchorPoint = Vector2.new(0.5, 0.5);
    u2.AutoLocalize = false;
    u2.BackgroundTransparency = 1;
    u2.Position = UDim2.fromScale(0.5, 0.5);
    u2.Size = UDim2.fromOffset(50, 50);
    u2.ZIndex = 10;
    u2.Parent = u9.Handler.HUD;
    local Frame = Instance.new("Frame");
    Frame.Name = "RightFrame";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.Position = UDim2.new(0.5, 7, 0.5, 0);
    Frame.Size = UDim2.fromOffset(10, 2);
    Frame.ZIndex = 10;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "Border";
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "Corner";
    UICorner.CornerRadius = UDim.new();
    UICorner.Parent = Frame;
    Frame.Parent = u2;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "LeftFrame";
    Frame2.AnchorPoint = Vector2.new(1, 0.5);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.Position = UDim2.new(0.5, -7, 0.5, 0);
    Frame2.Size = UDim2.fromOffset(10, 2);
    Frame2.ZIndex = 10;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "Border";
    UIStroke2.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "Corner";
    UICorner2.CornerRadius = UDim.new();
    UICorner2.Parent = Frame2;
    Frame2.Parent = u2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "TopFrame";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.Position = UDim2.new(0.5, 0, 0.5, -7);
    Frame3.Size = UDim2.fromOffset(2, 10);
    Frame3.ZIndex = 10;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "Border";
    UIStroke3.Parent = Frame3;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "Corner";
    UICorner3.CornerRadius = UDim.new();
    UICorner3.Parent = Frame3;
    Frame3.Parent = u2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "BottomFrame";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.Position = UDim2.new(0.5, 0, 0.5, 7);
    Frame4.Size = UDim2.fromOffset(2, 10);
    Frame4.ZIndex = 10;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "Border";
    UIStroke4.Parent = Frame4;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "Corner";
    UICorner4.CornerRadius = UDim.new();
    UICorner4.Parent = Frame4;
    Frame4.Parent = u2;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Dot";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.fromOffset(2, 2);
    Frame5.ZIndex = 10;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "Border";
    UIStroke5.Parent = Frame5;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "Corner";
    UICorner5.CornerRadius = UDim.new();
    UICorner5.Parent = Frame5;
    Frame5.Parent = u2;
    u17 = {
        Frame3,
        Frame4,
        Frame2,
        Frame,
        Frame5
    };
    u18 = Frame3;
    u19 = Frame4;
    u20 = Frame2;
    u21 = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Decal";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://503325139";
    ImageLabel.ImageTransparency = 0.35;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromOffset(30, 18);
    ImageLabel.Visible = false;
    ImageLabel.ZIndex = 10;
    ImageLabel.Parent = u2;
    u30 = Instance.new("TextLabel");
    u30.Name = "Enemy";
    u30.AnchorPoint = Vector2.new(0.5, 0.5);
    u30.AutoLocalize = false;
    u30.BackgroundTransparency = 1;
    u30.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u30.LayoutOrder = 1;
    u30.Position = UDim2.new(0.5, 0, 0.505, 50);
    u30.RichText = true;
    u30.Size = UDim2.fromScale(0.25, 0.025);
    u30.Text = "";
    u30.TextColor3 = Color3.fromRGB(253, 46, 49);
    u30.TextSize = 18;
    u30.TextTransparency = 1;
    u30.TextWrapped = true;
    u30.TextYAlignment = Enum.TextYAlignment.Top;
    u30.Parent = u9.Handler.HUD;

    return u2;
end;

return u1;