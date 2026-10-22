-- ReplicatedStorage.GameClient.WeaponController.Viewmodel
-- Script path: ReplicatedStorage.GameClient.WeaponController.Viewmodel
-- Decompile time: 53.04 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local AssetService = game:GetService("AssetService");
local _ = Players.LocalPlayer;
local _ = workspace.CurrentCamera;
local Assets = ReplicatedStorage:WaitForChild("Assets");
local KillTrack = Assets:WaitForChild("KillTrack");
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
local u17 = nil;
local CFrame_fromMatrix_ret = CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(0, 0, -1), Vector3.new(1, 0, 0), Vector3.new(0, -1, 0));
local u18 = { 0.7, 1, 1.35 };
local u19 = 0.0694;
local u20 = 0;
local u21 = nil;
local u22 = 0;
local u23 = 0;
local u24 = 0;
local u25 = 0;
local u26 = 0;
local u27 = 0;
local u28 = 0;
local u29 = 1;
local u30 = 0;
local u31 = 0;
local CFrame_identity = CFrame.identity;
local u32 = {};
local u33 = "All";
local u34 = false;
local u35 = false;
local u36 = false;
local u37 = false;
local u38 = false;
local u39 = false;
local u40 = false;
local u41 = nil;
local u42 = false;
local u43 = 0;
local u44 = 1;
local u45 = nil;
local u46 = nil;
local u47 = nil;
local u48 = 0.11104000000000001;
local u49 = 0;
local u50 = false;
local u51 = false;
local table_create_ret = table.create(128, 0);
local table_create_ret2 = table.create(128, Vector3.new(0, 0, 0));
local u52 = 0;
local u53 = 1;
local u54 = nil;
local u55 = nil;
local u56 = 0;
local u57 = 0;
local u58 = 0;
local u59 = 1;
local u60 = 2;
local u61 = 0;

function u1.ShouldLowerWhileRunning(p62) -- Line: 154
    local AltFunction = p62.Data.AltFunction;
    local v63;

    if (p62.ZoomLevel or 0) == 0 then
        if AltFunction then
            if AltFunction.Name == "ScopeRifle" then
                AltFunction = p62.Mode == 2;
            else
                AltFunction = false;
            end;
        end;

        v63 = not AltFunction;
    else
        v63 = false;
    end;

    return v63;
end;

local function RefreshWeaponCache(p64) -- Line: 160
    -- upvalues: u54 (ref), u55 (ref), u56 (ref), u57 (ref), u58 (ref), u59 (ref), u60 (ref), u61 (ref), u1 (copy)
    local Mode = p64.Mode;
    local Data = p64.Data;
    u54 = p64;
    u55 = Mode;
    local Inaccuracy = Data.Inaccuracy;
    u56 = Inaccuracy.Stand[Mode];
    u57 = Inaccuracy.Duck[Mode];
    u58 = (p64.IsSniper and 0.15 or 18) * 1.5;
    u59 = (1000 - Data.Speed[Mode] * 14.40922190201729) * 0.00028;
    u60 = u59 * 2;
    u61 = u1.ShouldLowerWhileRunning(p64) and 0.025199999999999997 or 0;
end;

local function zfill(p65, p66) -- Line: 183
    local v67 = tostring(p65);
    local v68 = #v67;

    if p66 <= v68 then
        return v67;
    end;

    return string.rep("0", p66 - v68) .. v67;
end;

local function RecordCameraRing(p69: vector, p70: number) -- Line: 195
    -- upvalues: u52 (ref), table_create_ret (copy), table_create_ret2 (copy)
    u52 = u52 + 1;
    local v71 = (u52 - 1) % 128 + 1;
    table_create_ret[v71] = p70;
    table_create_ret2[v71] = p69;
end;

local function GetAngleAt(p72: number) -- Line: 202
    -- upvalues: u52 (ref), u53 (ref), table_create_ret (copy), table_create_ret2 (copy)
    if u52 == 0 then
        return nil;
    end;

    local math_max_ret = math.max(1, u52 - 128 + 1);
    local math_clamp_ret = math.clamp(u53, math_max_ret, u52);

    while math_max_ret < math_clamp_ret and p72 < table_create_ret[(math_clamp_ret - 1) % 128 + 1] do
        math_clamp_ret = math_clamp_ret - 1;
    end;

    while math_clamp_ret < u52 and table_create_ret[math_clamp_ret % 128 + 1] <= p72 do
        math_clamp_ret = math_clamp_ret + 1;
    end;

    u53 = math_clamp_ret;
    local v73 = (math_clamp_ret - 1) % 128 + 1;
    local v74 = table_create_ret[v73];
    local v75 = table_create_ret2[v73];

    if math_clamp_ret == u52 or p72 <= v74 then
        return v75;
    end;

    local v76 = math_clamp_ret % 128 + 1;
    local v77 = table_create_ret[v76] - v74;

    return vector.lerp(v75, table_create_ret2[v76], v77 > 0 and (p72 - v74) / v77 or 0);
end;

local function CalculateBobCycle(p78: number) -- Line: 230
    return p78 < 0.5 and 3.141592653589793 * p78 * 2 or 3.141592653589793 + 3.141592653589793 * (p78 - 0.5) * 2;
end;

local function CalculateBobbing(p79, p80, p81, p82) -- Line: 235
    -- upvalues: u54 (ref), u55 (ref), u56 (ref), u57 (ref), u58 (ref), u59 (ref), u60 (ref), u61 (ref), u1 (copy), u21 (ref), u20 (ref), u22 (ref), u24 (ref), u23 (ref), u25 (ref), u26 (ref), u19 (ref), u27 (ref)
    if p80 ~= u54 or p80.Mode ~= u55 then
        local Mode = p80.Mode;
        local Data = p80.Data;
        u54 = p80;
        u55 = Mode;
        local Inaccuracy = Data.Inaccuracy;
        u56 = Inaccuracy.Stand[Mode];
        u57 = Inaccuracy.Duck[Mode];
        u58 = (p80.IsSniper and 0.15 or 18) * 1.5;
        u59 = (1000 - Data.Speed[Mode] * 14.40922190201729) * 0.00028;
        u60 = u59 * 2;
        u61 = u1.ShouldLowerWhileRunning(p80) and 0.025199999999999997 or 0;
    end;

    local v83 = vector.magnitude(p79.Velocity * Vector3.new(1, 0, 1)) * 14.40922190201729;
    local math_min_ret = math.min(v83, 320);
    local v84 = u21;

    if v84 ~= nil then
        local v85 = p81 * 640;
        math_min_ret = math.clamp(math_min_ret, v84 - v85, v84 + v85);
    end;

    u21 = math_min_ret;
    u20 = u20 + p81 * math_min_ret * 0.003125;
    local v86;

    if p80.Reloading or p80.Name == "Dual Berettas" then
        v86 = 0;
    else
        local v87 = u56;

        if p79.Ducking or p79.Ducked then
            p82 = u57 or p82;
        end;

        local v88;

        if p82 < v87 then
            v88 = u58;
        else
            p82 = math.min(p82, 0.082);
            v88 = 0.75;
        end;

        v86 = math.max((p82 - v87) * v88, -0.1);
    end;

    local v89 = p80.ViewmodelAccuracyPosition or 0;
    local v90 = v89 + (v86 * 80 - v89) * math.min(p81 * 4, 1);
    p80.ViewmodelAccuracyPosition = v90;
    local v91 = u59;
    local v92 = math_min_ret * (p79.OnGround and 0.00625 or 0.00425);
    local v93 = u20 % v91 / v91;
    u22 = v92 * 0.4;
    u22 = u22 * 0.3 + u22 * 0.7 * math.sin(v93 < 0.5 and 3.141592653589793 * v93 * 2 or 3.141592653589793 + 3.141592653589793 * (v93 - 0.5) * 2);
    u24 = u22;
    u22 = math.clamp(u22 - u61 * math_min_ret + v90 * 0.2, -7, 4);
    local v94 = u60;
    local v95 = u20 % v94 / v94;
    u23 = v92 * 0.6;
    u23 = u23 * 0.3 + u23 * 0.7 * math.sin(v95 < 0.5 and 3.141592653589793 * v95 * 2 or 3.141592653589793 + 3.141592653589793 * (v95 - 0.5) * 2);
    u25 = u23;
    u23 = math.clamp(u23 + v90 * 0.25, -8, 8);
    u26 = u22 * u19;
    u27 = u23 * u19;
end;

local function CalculateSwayOffset(p96: vector, p97: vector, p98: vector) -- Line: 321
    -- upvalues: u49 (ref), u52 (ref), table_create_ret (copy), table_create_ret2 (copy), u40 (ref), GetAngleAt (copy), u51 (ref), u48 (ref)
    u52 = u52 + 1;
    local v99 = (u52 - 1) % 128 + 1;
    table_create_ret[v99] = u49;
    table_create_ret2[v99] = p96;

    if u40 then
        return Vector3.new(0, 0, 0);
    end;

    local v100 = GetAngleAt(u49 - 0.1);

    if not v100 then
        return Vector3.new(0, 0, 0);
    end;

    local v101 = p96 * (1 - vector.dot(v100, p96));
    local v102 = p97 * vector.dot(v100, p97);
    local v103 = p98 * vector.dot(v100, p98);

    if u51 then
        v102 = -v102 or v102;
    end;

    local v104 = math.abs(p98.Y) - 0.02;

    return (v101 - v103 + v102) * u48 * math.clamp(v104, 0, 1);
end;

local function CalculateFinalResult(p105, p106: any, p107: number, p108: number) -- Line: 351
    -- upvalues: u51 (ref), u39 (ref), u44 (ref), u43 (ref), u26 (ref), u27 (ref), u40 (ref), CalculateSwayOffset (copy), u49 (ref), u52 (ref), table_create_ret (copy), table_create_ret2 (copy), u28 (ref), u19 (ref), u30 (ref), u29 (ref), u31 (ref), u45 (ref), u46 (ref), u47 (ref)
    local LookVector = p105.LookVector;
    local RightVector = p105.RightVector;
    local UpVector = p105.UpVector;
    local v109;

    if u51 then
        v109 = -RightVector or RightVector;
    else
        v109 = RightVector;
    end;

    local v110 = 0;
    local v111, v112;

    if u39 then
        v111 = 0;
        v112 = 0;
    else
        local v113 = p106.OnGround and 0 or (u44 * 1.5 or 0);
        local v114 = v113 - u43;
        local v115 = p107 * 3.5;

        if v115 < v114 then
            u43 = u43 + v115;
        elseif v114 < -v115 then
            u43 = u43 - v115;
        else
            u43 = v113;
        end;

        local v116 = u26 * 0.4;
        v111 = -(v116 + u43 * 0.2) * 0.017453292519943295;
        v112 = -(u27 * 0.3) * 0.017453292519943295;

        if p108 ~= 0 then
            p105 = p105 + (LookVector * v116 + Vector3.new(0, 1, 0) * (u26 * 0.1 - u43 * u44) + v109 * u27 * 0.2) * p108;
        end;
    end;

    if not u40 then
        if p108 == 0 then
            u52 = u52 + 1;
            local v117 = (u52 - 1) % 128 + 1;
            table_create_ret[v117] = u49;
            table_create_ret2[v117] = LookVector;
        else
            p105 = p105 + CalculateSwayOffset(LookVector, RightVector, UpVector) * p108;
        end;

        local v118 = vector.dot(p106.Velocity, RightVector) * 14.40922190201729;
        local math_clamp_ret = math.clamp(v118 * 0.003125, -1, 1);
        u28 = u28 + (math_clamp_ret - u28) * math.min(p107 * 12.5, 1);

        if p108 ~= 0 then
            p105 = p105 + v109 * (u28 * 1.5 * u19) * p108;
        end;

        local v119 = math_clamp_ret > 0.15 and 1 or (math_clamp_ret < -0.15 and -1 or 0);

        if v119 == u30 then
            if u29 < 1 then
                u29 = math.min(u29 + p107 / 0.55, 1);
            end;
        else
            if v119 ~= 0 then
                u29 = 0;
            end;

            u30 = v119;
        end;

        local v120 = u29;
        u31 = u31 + (((not p106.OnGround or v119 == 0) and 0 or math.clamp(v118 / 250, -1, 1) * -2.5 * (1 - v120 * v120)) - u31) * math.min(p107 * 20, 1);
        v110 = v110 + u31 * 0.017453292519943295;
    end;

    if p108 ~= 0 and (v111 ~= 0 or (v112 ~= 0 or v110 ~= 0)) then
        if u45 ~= u44 then
            local Vector3_new_ret = Vector3.new(u44 * 1.35, u44 * -1.1, u44 * -2.5);
            u46 = CFrame.new(Vector3_new_ret);
            u47 = CFrame.new(-Vector3_new_ret);
            u45 = u44;
        end;

        local CFrame_fromEulerAnglesXYZ_ret = CFrame.fromEulerAnglesXYZ(v111 * p108, v112 * p108, v110 * p108);
        p105 = p105 * u46 * CFrame_fromEulerAnglesXYZ_ret * u47;
    end;

    return p105;
end;

function u1.ApplyAnimatedTint(u121: userdata, p122: any, p123: string?) -- Line: 474
    -- upvalues: TweenService (copy)
    local v124;

    if p122.Actions and p123 then
        v124 = p122.Actions[p123] or p122;
    else
        v124 = p122;
    end;

    if v124 and (v124[1] and (v124[2] and v124[3])) then
        local v125 = v124[1];
        local u126 = v124[2];
        local u127 = v124[3];
        local u128 = v124.EasingStyle or (p122.EasingStyle or Enum.EasingStyle.Sine);
        local u129 = v124.EasingDirection or (p122.EasingDirection or Enum.EasingDirection.InOut);

        local function PlayLoop() -- Line: 487
            -- upvalues: TweenService (ref), u121 (copy), u127 (copy), u128 (copy), u129 (copy), u126 (copy)
            local v130 = TweenService:Create(u121, TweenInfo.new(u127, u128, u129, -1, true), {
                EmissiveStrength = u126
            });
            v130:Play();

            return v130;
        end;

        if not (p122.Actions and u121:GetAttribute("AnimatedTintStarted")) then
            u121:SetAttribute("AnimatedTintStarted", true);
            u121.EmissiveStrength = v125;

            return PlayLoop();
        end;

        local v131 = TweenService:Create(u121, TweenInfo.new(u127, u128, u129), {
            EmissiveStrength = v125
        });
        v131.Completed:Once(function(p132) -- Line: 508
            -- upvalues: PlayLoop (copy)
            if p132 == Enum.PlaybackState.Completed then
                PlayLoop();
            end;
        end);
        v131:Play();

        return v131;
    end;
end;

function u1.PlayAnimatedTint(p133: any, p134: string) -- Line: 518
    -- upvalues: u7 (ref), u1 (copy)
    local WeaponSkin = u7.GetWeaponSkin(p133.Name, p133.Skin);

    if WeaponSkin then
        WeaponSkin = WeaponSkin.AnimatedTint;
    end;

    local v135;

    if WeaponSkin then
        v135 = WeaponSkin.Actions;
    else
        v135 = WeaponSkin;
    end;

    local v136;

    if v135 then
        v136 = v135[p134];
    else
        v136 = v135;
    end;

    if not v135 then
        p133.AnimatedTintAction = p134;

        return;
    end;

    local v137 = v136 and p133.Viewmodel and p133.Viewmodel:FindFirstChild("Weapon");

    if not (v136 and v137) then
        return;
    end;

    local v138 = v135[p133.AnimatedTintAction];

    if v138 and (v138[4] or (1 / 0)) < (v136[4] or (1 / 0)) then
        return;
    end;

    p133.AnimatedTintAction = p134;

    for _, v in v137:QueryDescendants("SurfaceAppearance") do
        u1.ApplyAnimatedTint(v, WeaponSkin, p134);
    end;
end;

local function ApplyViewmodelNoGloves(p139: userdata, p140: boolean) -- Line: 555
    -- upvalues: ReplicatedStorage (copy)
    if not p139 then
        return;
    end;

    if p140 then
        local v141 = p139:FindFirstChild("Left Arm");
        local v142 = v141 and v141:FindFirstChild("GloveL");

        if v142 then
            v142.Parent = ReplicatedStorage;
        end;

        local v143 = p139:FindFirstChild("Right Arm");
        local v144 = v143 and v143:FindFirstChild("GloveR");

        if v144 then
            v144.Parent = ReplicatedStorage;
        end;
    else
        local GloveL = ReplicatedStorage:FindFirstChild("GloveL");
        local v145 = GloveL and p139:FindFirstChild("Left Arm");

        if v145 then
            GloveL.Parent = v145;
        end;

        local GloveR = ReplicatedStorage:FindFirstChild("GloveR");
        local v146 = GloveR and p139:FindFirstChild("Right Arm");

        if v146 then
            GloveR.Parent = v146;
        end;
    end;
end;

local function ApplyViewmodelNoSleeves(p147: userdata, p148: boolean) -- Line: 601
    -- upvalues: ReplicatedStorage (copy)
    if not p147 then
        return;
    end;

    if p148 then
        local v149 = p147:FindFirstChild("Left Arm");
        local v150 = v149 and v149:FindFirstChild("SleeveL");

        if v150 then
            v150.Parent = ReplicatedStorage;
        end;

        local v151 = p147:FindFirstChild("Right Arm");
        local v152 = v151 and v151:FindFirstChild("SleeveR");

        if v152 then
            v152.Parent = ReplicatedStorage;
        end;
    else
        local SleeveL = ReplicatedStorage:FindFirstChild("SleeveL");
        local v153 = SleeveL and p147:FindFirstChild("Left Arm");

        if v153 then
            SleeveL.Parent = v153;
        end;

        local SleeveR = ReplicatedStorage:FindFirstChild("SleeveR");
        local v154 = SleeveR and p147:FindFirstChild("Right Arm");

        if v154 then
            SleeveR.Parent = v154;
        end;
    end;
end;

local function ApplyScopeDotColor(p155) -- Line: 647
    -- upvalues: u42 (ref), u41 (ref)
    local v156;

    if p155 then
        v156 = p155.Viewmodel;
    else
        v156 = p155;
    end;

    if v156 then
        v156 = v156:FindFirstChild("Dot");
    end;

    if v156 then
        v156.Color = u42 and u41 or p155.ScopeDotColor;
    end;
end;

function u1.ApplyKillTrackColor(p157) -- Line: 656
    -- upvalues: u3 (ref)
    local v158 = p157 or u3;

    if not (v158 and v158.KillTrackText) then
        return;
    end;

    local v159 = v158.Data and v158.Data.Type == "Melee" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 102, 0);
    local KillTrackText = v158.KillTrackText;

    if v158.KillTrackColor then
        v159 = Color3.fromRGB(unpack(v158.KillTrackColor)) or v159;
    end;

    KillTrackText.TextColor3 = v159;
end;

function u1.GetKillTrackColor() -- Line: 667
    -- upvalues: u3 (ref)
    local v160 = u3 and u3.Data and u3.Data.Type == "Melee" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 102, 0);

    if u3 and u3.KillTrackColor then
        v160 = Color3.fromRGB(unpack(u3.KillTrackColor)) or v160;
    end;

    return v160;
end;

local function ApplyScopeDotTransparency(p161: any, p162: number) -- Line: 682
    local v163;

    if p161 then
        v163 = p161.Viewmodel;
    else
        v163 = p161;
    end;

    if not v163 then
        return;
    end;

    if p161.ScopeDotSource ~= v163 then
        p161.ScopeDotSource = v163;
        p161.ScopeDot = v163:FindFirstChild("Dot");
        p161.ScopeDotLastTransparency = nil;
    end;

    local ScopeDot = p161.ScopeDot;

    if not ScopeDot then
        return;
    end;

    local math_lerp_ret = math.lerp(1, p161.ScopeDotTransparency, p162);

    if p161.ScopeDotLastTransparency ~= math_lerp_ret then
        p161.ScopeDotLastTransparency = math_lerp_ret;
        ScopeDot.Transparency = math_lerp_ret;
    end;
end;

local function SnapshotVisible(p164) -- Line: 714
    local v165 = {};

    for _, v in p164:QueryDescendants("BasePart:not([Transparency = 1])") do
        v165[v] = v.Transparency;
    end;

    local v166 = {};

    for _, v in p164:QueryDescendants("TextLabel:not([TextTransparency = 1])") do
        v166[v] = v.TextTransparency;
    end;

    local v167 = {};

    for _, v in p164:QueryDescendants("SurfaceGui:not([Enabled = false])") do
        v167[v] = v.Enabled;
    end;

    local v168 = {};

    for _, v in p164:QueryDescendants("UIStroke:not([Transparency = 1])") do
        v168[v] = v.Transparency;
    end;

    return v165, v166, v167, v168;
end;

local function SourceBias(p169: number) -- Line: 742
    return p169 ^ 2.321928094887362;
end;

local function SourceGain(p170: number) -- Line: 746
    return p170 < 0.5 and (p170 * 2) ^ 2.321928094887362 * 0.5 or 1 - (2 - p170 * 2) ^ 2.321928094887362 * 0.5;
end;

function u1.GetIronSightMotionScale(p171) -- Line: 752
    local v172 = p171.IronSightAmount or 0;

    return 1 - (v172 < 0.5 and (v172 * 2) ^ 2.321928094887362 * 0.5 or 1 - (2 - v172 * 2) ^ 2.321928094887362 * 0.5);
end;

function u1.CalculateIronSightOffset(p173: any, p174: number, p175: vector?) -- Line: 756
    -- upvalues: u5 (ref), u12 (ref)
    local AltFunction = p173.Data.AltFunction;

    if not AltFunction or AltFunction.Name ~= "ScopeRifle" then
        local v176 = p173.IronSightAmount or 0;

        return CFrame.identity, v176 < 0.5 and (v176 * 2) ^ 2.321928094887362 * 0.5 or 1 - (2 - v176 * 2) ^ 2.321928094887362 * 0.5;
    end;

    local v177 = p173.Mode == 2 and not (p173.Equipping or (p173.Reloading or p173.Inspecting)) and 1 or 0;
    local v178 = u5.Approach(v177, p173.IronSightAmount or 0, (v177 == 1 and AltFunction.PullUpSpeed or AltFunction.PutDownSpeed) * p174);
    local v179 = p173.Data.Speed[p173.Mode];
    local v180;

    if p175 and v179 > 0 then
        local v181 = vector.magnitude(p175) / v179;
        v180 = math.clamp(v181, 0, 1) or 0;
    else
        v180 = 0;
    end;

    local v182 = u5.Approach(v180, p173.IronSightSpeedRatio or 0, p174 * 10);
    local v183 = u5.Approach(0, p173.ScopeDotBlur or 0, p174 * 2);
    p173.IronSightAmount = v178;
    p173.IronSightSpeedRatio = v182;
    p173.ScopeDotBlur = v183;

    if u12.InFirstPersonView() then
        local SetFOVAmount = u12.SetFOVAmount;
        local SettingsFieldOfView = u12.GetSettingsFieldOfView();
        SetFOVAmount((math.lerp(SettingsFieldOfView, AltFunction.FOV, v178)));
    end;

    local v184 = v178 < 0.5 and (v178 * 2) ^ 2.321928094887362 * 0.5 or 1 - (2 - v178 * 2) ^ 2.321928094887362 * 0.5;
    local v185 = v184 * (1 - math.max(v183, v182 * 0.5)) ^ 2.321928094887362;
    local v186;

    if p173 then
        v186 = p173.Viewmodel;
    else
        v186 = p173;
    end;

    if v186 then
        if p173.ScopeDotSource ~= v186 then
            p173.ScopeDotSource = v186;
            p173.ScopeDot = v186:FindFirstChild("Dot");
            p173.ScopeDotLastTransparency = nil;
        end;

        local ScopeDot = p173.ScopeDot;

        if ScopeDot then
            local math_lerp_ret = math.lerp(1, p173.ScopeDotTransparency, v185);

            if p173.ScopeDotLastTransparency ~= math_lerp_ret then
                p173.ScopeDotLastTransparency = math_lerp_ret;
                ScopeDot.Transparency = math_lerp_ret;
            end;
        end;
    end;

    local v187 = p173.IronSightOffset or AltFunction.Offset;

    if v184 == 0 then
        return CFrame.identity, v184;
    end;

    if v184 == 1 then
        return v187, v184;
    end;

    return CFrame.identity:Lerp(v187, v184), v184;
end;

function u1.RestoreScale(p188) -- Line: 796
    -- upvalues: u44 (ref), u19 (ref), u48 (ref)
    local v189 = p188.ViewmodelScale * 0.0694;
    u44 = p188.ViewmodelScale;
    u19 = v189;
    u48 = v189 * 1.6;
end;

function u1.ResetIronSight(p190) -- Line: 804
    -- upvalues: u12 (ref)
    p190.IronSightAmount = 0;

    if not u12.IsLockedToScene() then
        u12.SetFOVAmount(u12.GetSettingsFieldOfView());
    end;

    local v191;

    if p190 then
        v191 = p190.Viewmodel;
    else
        v191 = p190;
    end;

    if not v191 then
        return;
    end;

    if p190.ScopeDotSource ~= v191 then
        p190.ScopeDotSource = v191;
        p190.ScopeDot = v191:FindFirstChild("Dot");
        p190.ScopeDotLastTransparency = nil;
    end;

    local ScopeDot = p190.ScopeDot;

    if not ScopeDot then
        return;
    end;

    local math_lerp_ret = math.lerp(1, p190.ScopeDotTransparency, 0);

    if p190.ScopeDotLastTransparency ~= math_lerp_ret then
        p190.ScopeDotLastTransparency = math_lerp_ret;
        ScopeDot.Transparency = math_lerp_ret;
    end;
end;

local function ApplyViewmodelSkin(p192, p193) -- Line: 815
    -- upvalues: u7 (ref), u1 (copy)
    local Weapon = p192.Viewmodel.Weapon;
    local Emissive = p192.Emissive;
    local WeaponSkin = u7.GetWeaponSkin(p192.Name, p192.Skin);

    if WeaponSkin.WorldModel and p193 then
        for i, v in WeaponSkin.WorldModel do
            local v194 = Weapon:FindFirstChild(i);

            if v194 and v194:IsA("MeshPart") then
                local v195 = v194:FindFirstChildOfClass("SurfaceAppearance");

                if v195 then
                    v195:Destroy();
                end;

                v194.TextureID = v.Value;
            end;
        end;

        return;
    end;

    if WeaponSkin.Assets then
        for i, v in WeaponSkin.Assets do
            local v196 = Weapon:FindFirstChild(i);

            if v196 then
                v196.TextureID = "";
                local v197 = v:Clone();

                if Emissive then
                    v197.EmissiveTint = Emissive.Tint;
                    v197.EmissiveStrength = Emissive.Strength;
                end;

                if WeaponSkin.AnimatedTint then
                    u1.ApplyAnimatedTint(v197, WeaponSkin.AnimatedTint);
                end;

                v197.Parent = v196;
            end;
        end;
    end;
end;

local function ApplyViewmodelNoTexture(p198: any, p199: boolean) -- Line: 871
    -- upvalues: ReplicatedStorage (copy), u38 (ref), ApplyViewmodelSkin (copy)
    local v200 = p198 and p198.Viewmodel and p198.Viewmodel.Weapon;

    if not v200 then
        return;
    end;

    if p199 then
        for _, v in v200:QueryDescendants("SurfaceAppearance") do
            v.Parent = ReplicatedStorage;
        end;

        for _, v in v200:QueryDescendants("MeshPart") do
            v.TextureID = "";
        end;

        return;
    end;

    if u38 then
        ApplyViewmodelSkin(p198, true);

        return;
    end;

    for _, child in ReplicatedStorage:GetChildren() do
        if child:IsA("SurfaceAppearance") then
            child.Parent = v200[child.Name];
        end;
    end;
end;

local function ApplyViewmodelGloveSkin(p201: userdata, p202: any, p203: boolean) -- Line: 897
    if not (p201 and p202) then
        return;
    end;

    for i, v in {
        L = "Left",
        R = "Right"
    } do
        local v204 = p201:FindFirstChild(v .. " Arm");

        if v204 then
            v204 = v204:FindFirstChild("Glove" .. i);
        end;

        if v204 then
            local v205 = v204:FindFirstChildOfClass("SurfaceAppearance");

            if p203 and p202.WorldModel then
                if v205 then
                    v205:Destroy();
                end;

                local v206 = p202.WorldModel["Glove" .. i];

                if v206 then
                    v204.TextureID = v206.Value;
                end;
            elseif p202.Assets then
                v204.TextureID = "";

                if not v205 then
                    local v207 = p202.Assets["Glove" .. i];

                    if v207 then
                        v207:Clone().Parent = v204;
                    end;
                end;
            end;
        end;
    end;
end;

local u208 = setmetatable({}, {
    __mode = "k"
});

local function ApplyViewmodelSleeveSkin(p209: userdata, p210: any, p211: boolean) -- Line: 937
    -- upvalues: u208 (copy)
    if not (p209 and (p210 and p210.WorldModel)) then
        return;
    end;

    local WorldModel = p210.WorldModel;

    for i, v in {
        L = "Left",
        R = "Right"
    } do
        local v212 = p209:FindFirstChild(v .. " Arm");

        if v212 then
            v212 = v212:FindFirstChild("Sleeve" .. i);
        end;

        if v212 then
            if p211 then
                local v213 = v212:FindFirstChildOfClass("SurfaceAppearance");

                if v213 then
                    u208[v212] = v213;
                    v213.Parent = nil;
                end;

                local v214 = WorldModel["Sleeve" .. i];

                if v214 then
                    v212.TextureID = v214.Value;
                end;
            else
                local v215 = u208[v212];

                if v215 then
                    v212.TextureID = "";
                    v215.Parent = v212;
                    u208[v212] = nil;
                end;
            end;
        end;
    end;
end;

function u1.StickerProjector(p216: userdata, p217: number, p218: vector, p219: number, p220: number?) -- Line: 976
    -- upvalues: CFrame_fromMatrix_ret (copy), u18 (copy)
    local v221 = CFrame.new(p216.CFrame * (p218 * p217)) * p216:GetPivot().Rotation * CFrame_fromMatrix_ret * CFrame.Angles(0, math.rad(p219), 0.05235987755982989);

    return {
        cframe = CFrame.fromMatrix(v221.Position, v221.XVector, v221.YVector, -v221.ZVector) * CFrame.Angles(0, 3.141592653589793, 0),
        size = Vector3.new(1, 1, 1) * (p217 * 0.5 * (u18[p220] or 1)),
        rect = Rect.new(0, 0, 1, 1)
    };
end;

function u1.StickerTargets(p222: userdata) -- Line: 986
    local v223 = {};

    for _, child in p222:GetChildren() do
        if child:IsA("MeshPart") and child.Transparency < 1 then
            table.insert(v223, child);
        end;
    end;

    return v223;
end;

local u224 = false;
local u225 = {};

local function NewTriCollector() -- Line: 1009
    return {
        Tris = {},

        AddTri = function(p226, ...) -- Line: 1013, Name: AddTri
            local Tris = p226.Tris;

            if #Tris < 60000 then
                for i = 1, 9 do
                    Tris[#Tris + 1] = select(i, ...);
                    local _ = i;
                end;
            end;
        end
    };
end;

local function BuildStickerMesh(p227) -- Line: 1028
    -- upvalues: AssetService (copy)
    local u228 = AssetService:CreateEditableMesh();

    if not u228 then
        return nil;
    end;

    local u229 = {};
    local u230 = {};
    local u231 = {};

    local function Vertex(p232: vector, p233) -- Line: 1037
        -- upvalues: u229 (copy), u228 (copy), u230 (copy)
        local v234 = u229[p232];

        if not v234 then
            v234 = u228:AddVertex(p232);
            u229[p232] = v234;
            u230[p232] = u228:AddUV(p233);
        end;

        return v234;
    end;

    local function Normal(p235: vector) -- Line: 1049
        -- upvalues: u231 (copy), u228 (copy)
        local v236 = u231[p235];

        if not v236 then
            v236 = u228:AddNormal(p235);
            u231[p235] = v236;
        end;

        return v236;
    end;

    for i = 0, #p227 - 9, 9 do
        local v237 = p227[i + 1];
        local v238 = p227[i + 2];
        local v239 = p227[i + 3];
        local v240;

        if v237 == v238 or (v238 == v239 or v237 == v239) then
            v240 = i;
        else
            local v241 = p227[i + 7];
            local v242 = u229[v237];

            if not v242 then
                v242 = u228:AddVertex(v237);
                u229[v237] = v242;
                u230[v237] = u228:AddUV(v241);
            end;

            local v243 = p227[i + 8];
            local v244 = u229[v238];

            if not v244 then
                v244 = u228:AddVertex(v238);
                u229[v238] = v244;
                u230[v238] = u228:AddUV(v243);
            end;

            local v245 = p227[i + 9];
            local v246 = u229[v239];

            if not v246 then
                v246 = u228:AddVertex(v239);
                u229[v239] = v246;
                u230[v239] = u228:AddUV(v245);
            end;

            local v247 = p227[i + 4];
            local v248 = u231[v247];

            if not v248 then
                v248 = u228:AddNormal(v247);
                u231[v247] = v248;
            end;

            local v249 = p227[i + 5];
            local v250 = u231[v249];

            if not v250 then
                v250 = u228:AddNormal(v249);
                u231[v249] = v250;
            end;

            local v251 = p227[i + 6];
            local v252 = u231[v251];

            if not v252 then
                v252 = u228:AddNormal(v251);
                u231[v251] = v252;
            end;

            local v253 = u228:AddTriangle(v242, v244, v246);
            u228:SetFaceNormals(v253, { v248, v250, v252 });
            u228:SetFaceUVs(v253, { u230[v237], u230[v238], u230[v239] });
            local v254 = u228:AddTriangle(v242, v246, v244);
            u228:SetFaceNormals(v254, { v248, v252, v250 });
            u228:SetFaceUVs(v254, { u230[v237], u230[v239], u230[v238] });
            v240 = i;
        end;
    end;

    return u228;
end;

local function CopyToFixedMesh(p255) -- Line: 1083
    -- upvalues: BuildStickerMesh (copy), AssetService (copy)
    local v256 = BuildStickerMesh(p255);

    if not v256 then
        return nil;
    end;

    local success, result = pcall(AssetService.CreateEditableMeshAsync, AssetService, Content.fromObject(v256));
    v256:Destroy();

    return success and result and result or nil;
end;

local function FreezeStickerMesh(p257) -- Line: 1096
    -- upvalues: u224 (ref), u225 (copy), CopyToFixedMesh (copy), AssetService (copy)
    local v258 = p257[1];
    local v259 = p257[1];

    for i = 0, #p257 - 9, 9 do
        local v260 = i;

        for i2 = 1, 3 do
            v258 = v258:Min(p257[v260 + i2]);
            v259 = v259:Max(p257[v260 + i2]);
            local _ = i2;
        end;
    end;

    local v261 = (v258 + v259) / 2;

    for i = 0, #p257 - 9, 9 do
        local v262 = i + 1;
        p257[v262] = p257[v262] - v261;
        local v263 = i + 2;
        p257[v263] = p257[v263] - v261;
        local v264 = i + 3;
        p257[v264] = p257[v264] - v261;
        local _ = i;
    end;

    if u224 then
        table.insert(u225, coroutine.running());
        coroutine.yield();
    end;

    u224 = true;
    local success, result = pcall(CopyToFixedMesh, p257);
    local table_remove_ret = table.remove(u225, 1);

    while table_remove_ret and coroutine.status(table_remove_ret) ~= "suspended" do
        table_remove_ret = table.remove(u225, 1);
    end;

    if table_remove_ret then
        task.spawn(table_remove_ret);
    else
        u224 = false;
    end;

    if not (success and result) then
        return nil;
    end;

    local CreateMeshPartAsync = AssetService.CreateMeshPartAsync;
    local Content_fromObject_ret = Content.fromObject(result);
    local success2, result2 = pcall(CreateMeshPartAsync, AssetService, Content_fromObject_ret, {
        CollisionFidelity = Enum.CollisionFidelity.Box,
        RenderFidelity = Enum.RenderFidelity.Precise,
        FluidFidelity = Enum.FluidFidelity.UseCollisionGeometry
    });

    if not success2 then
        result2 = nil;
    end;

    if not result2 then
        if result then
            result:Destroy();
        end;

        return nil;
    end;

    result2.CanCollide = false;
    result2.CanQuery = false;
    result2.CanTouch = false;
    result2.CastShadow = false;
    result2.EnableFluidForces = false;
    result2.Color = Color3.new(1, 1, 1);
    result2.Anchored = true;
    result2.CFrame = CFrame.new(v261);

    return {
        meshPart = result2,
        editableMesh = result
    };
end;

local function ParallelEach(p265, u266) -- Line: 1171
    local u267 = #p265;
    local coroutine_running_ret = coroutine.running();
    local u268 = false;

    for _, v in p265 do
        task.spawn(function() -- Line: 1177
            -- upvalues: u266 (copy), v (copy), u267 (ref), u268 (ref), coroutine_running_ret (copy)
            local success, result = pcall(u266, v);

            if not success then
                warn("Sticker projection failed:", result);
            end;

            u267 = u267 - 1;

            if u267 == 0 and u268 then
                task.spawn(coroutine_running_ret);
            end;
        end);
    end;

    if u267 > 0 then
        coroutine.yield();
    end;
end;

function u1.ProjectSticker(p269: table, u270: any, u271: any, u272: number) -- Line: 1198
    -- upvalues: ParallelEach (copy), NewTriCollector (copy), u17 (ref), FreezeStickerMesh (copy)
    local v273 = u270.size.Magnitude / 2;
    local v274 = {};
    local u275 = {};

    for _, v in p269 do
        if v:IsA("MeshPart") and (v.Position - u270.cframe.Position).Magnitude <= v.Size.Magnitude / 2 + v273 then
            table.insert(v274, v);
        end;
    end;

    ParallelEach(v274, function(p276) -- Line: 1210
        -- upvalues: NewTriCollector (ref), u17 (ref), u272 (copy), u270 (copy), FreezeStickerMesh (ref), u271 (copy), u275 (copy)
        local v277 = NewTriCollector();
        u17:ProjectMeshAsync(v277, { p276 }, {}, u272);
        local decalThickness = u17.decalThickness;
        u17.decalThickness = decalThickness * u270.size.X / 0.5;
        u17:ProjectMeshAsync(v277, { p276 }, { u270 }, u272);
        u17.decalThickness = decalThickness;

        if #v277.Tris == 0 then
            return;
        end;

        local v278 = FreezeStickerMesh(v277.Tris);

        if not v278 then
            warn("Sticker skipped: EditableMesh budget exhausted");

            return;
        end;

        local meshPart = v278.meshPart;
        meshPart.Name = "Sticker";
        meshPart.TextureID = u271.Asset;
        meshPart.Material = Enum.Material.Metal;
        meshPart.Transparency = 0.03;

        if u271.SurfaceAppereance then
            u271.SurfaceAppereance:Clone().Parent = meshPart;
        end;

        u275[p276] = v278;
    end);

    return u275;
end;

local function AttachStickers(u279) -- Line: 1246
    -- upvalues: u6 (ref), u1 (copy), ParallelEach (copy), u8 (ref)
    local Weapon = u279.Viewmodel.Weapon;
    local u280 = u6.Get(u279.Name).Assets.InspectModel:Clone();
    local u281 = nil;
    local u282 = {};

    for _, v in u1.StickerTargets(u280) do
        local v283 = Weapon:FindFirstChild(v.Name);

        if v283 then
            u281 = u281 or v283.Size.X / v.Size.X;
            table.insert(u282, v);
        end;
    end;

    if not u281 then
        u280:Destroy();

        return;
    end;

    u280:ScaleTo(u280:GetScale() * u281);
    local u284 = {};

    for _, v in u279.Stickers do
        table.insert(u284, v);
    end;

    ParallelEach(u284, function(p285) -- Line: 1274
        -- upvalues: u1 (ref), u280 (copy), u281 (ref), u282 (copy), u8 (ref), u284 (copy), u279 (copy), Weapon (copy)
        local v286 = u1.StickerProjector(u280.PrimaryPart, u281, Vector3.new(unpack(p285.Position)), p285.Rotation, p285.Size);

        for i, v in u1.ProjectSticker(u282, v286, u8.GetItem("Stickers", p285.StickerName), table.find(u284, p285) - 1) do
            local meshPart = v.meshPart;

            if u279.StickerMeshes then
                local u287 = Weapon[i.Name];
                local Weld = Instance.new("Weld");
                Weld.Part0 = u287;
                Weld.Part1 = meshPart;
                Weld.C0 = i.CFrame:ToObjectSpace(meshPart.CFrame);
                Weld.Parent = meshPart;
                meshPart.Anchored = false;
                meshPart.Transparency = u287.Transparency == 1 and 1 or 0.03;
                meshPart.Parent = u279.Viewmodel;
                u279.VisiblePartsMap[meshPart] = 0.03;
                u287:GetPropertyChangedSignal("Transparency"):Connect(function() -- Line: 1299
                    -- upvalues: meshPart (copy), u287 (copy)
                    meshPart.Transparency = u287.Transparency == 1 and 1 or 0.03;
                end);
                table.insert(u279.StickerMeshes, v);
            else
                meshPart:Destroy();
                v.editableMesh:Destroy();
            end;
        end;
    end);
    u280:Destroy();
end;

function u1.new(u288, p289) -- Line: 1309
    -- upvalues: u6 (ref), u7 (ref), u34 (ref), ApplyViewmodelSkin (copy), u38 (ref), KillTrack (copy), Assets (copy), u8 (ref), ApplyViewmodelGloveSkin (copy), ApplyViewmodelSleeveSkin (copy), ReplicatedFirst (copy), u15 (ref), u13 (ref), u16 (ref), u14 (ref), SnapshotVisible (copy), AttachStickers (copy)
    local v290 = u6.Get(u288.Name);
    u7.GetWeaponSkin(u288.Name, u288.Skin);
    local v291 = v290.Assets.Viewmodel:Clone();
    u288.Viewmodel = v291;
    u288.PrimaryPart = v291.PrimaryPart;
    local Weapon = u288.Viewmodel.Weapon;

    if not u34 then
        ApplyViewmodelSkin(u288, u38);
    end;

    local v292 = u288.KillTrack and v291:FindFirstChild("KillTrack");

    if v292 then
        local v293 = u288.Data and u288.Data.Type == "Melee";
        local v294 = KillTrack:FindFirstChild(v293 and "Melee" or "Weapon"):Clone();
        local Motor6D = Instance.new("Motor6D");
        Motor6D.Part0 = v294.PrimaryPart;
        Motor6D.Part1 = v292;
        Motor6D.Parent = v294;
        v294.Parent = v292;
        local Foreground = v294.Track.Text.SurfaceGui.Foreground;

        if v293 then
            Motor6D.C0 = CFrame.Angles(0, 1.5707963267948966, 0);
            Foreground.Text = (`{math.clamp(u288.KillTrack, 0, 999999)}`):gsub("0", "O");
            Foreground.TextTransparency = 0.8;
        else
            local v295 = `{math.clamp(u288.KillTrack, 0, 999999)}`;
            local v296 = tostring(v295);
            local v297 = #v296;

            if v297 < 6 then
                v296 = string.rep("0", 6 - v297) .. v296;
            end;

            Foreground.Text = v296;
        end;

        local v298 = v293 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 102, 0);

        if u288.KillTrackColor then
            v298 = Color3.fromRGB(unpack(u288.KillTrackColor)) or v298;
        end;

        Foreground.TextColor3 = v298;
        u288.KillTrackText = Foreground;
    end;

    local v299 = u288.NameTag and v291:FindFirstChild("NameTag");

    if v299 then
        local v300 = Assets:FindFirstChild("WeaponNameTag"):Clone();
        local Motor6D = Instance.new("Motor6D");
        Motor6D.Part0 = v300.PrimaryPart;
        Motor6D.Part1 = v299;
        Motor6D.Parent = v300;
        v300.Parent = v299;
        v300.Tag.Text.SurfaceGui.Foreground.Text = u288.NameTag;
    end;

    local Arms = v291.Arms;
    local Team = p289.Team;
    local v301 = u7.GetArmsSkin(p289.Agent) or u7.GetArmsSkin("Stock" .. (Team or "CT"));

    if not v301 then
        warn((`[Viewmodel] no arms skin for team '{Team}' -- falling back to StockCT`));
        v301 = u7.GetArmsSkin("StockCT");
    end;

    local Assets2 = v301.Assets;
    u288.ArmsData = v301;
    local v302 = {};

    for _, child in Assets2.Arms:Clone():GetChildren() do
        local v303 = Arms:FindFirstChild(child.Name);
        local v304;

        if v303 then
            v304 = child;

            for _, child2 in v303:GetChildren() do
                if child2.ClassName == "Motor6D" or child2.ClassName == "Weld" then
                    child2.Parent = v304;
                end;
            end;

            if v303.Transparency ~= 1 then
                v302[v303] = v304;
            end;

            v303:Destroy();
        else
            v304 = child;
        end;

        v304.Parent = Arms;
    end;

    for _, v in v291:QueryDescendants("Motor6D, Weld") do
        local v305 = v302[v.Part0];
        local v306 = v302[v.Part1];

        if v305 then
            v.Part0 = v305;
        end;

        if v306 then
            v.Part1 = v306;
        end;
    end;

    local v307 = p289.Gloves or {
        WeaponName = "Fingerless",
        SkinName = "Vanilla"
    };
    local Category = u8.GetCategory(v307.WeaponName);
    local Item = u8.GetItem(v307.WeaponName, v307.SkinName);
    local Model = Category.Model;

    if Model then
        Model = Model:Clone();
    end;

    u288.GloveItem = Item;
    local Sleeves = Assets2.Sleeves;

    if Sleeves then
        Sleeves = Sleeves:Clone();
    end;

    for i, v in {
        L = "Left",
        R = "Right"
    } do
        local v308 = Arms:FindFirstChild(v .. " Arm");

        if v308 then
            local v309 = Model and Model:FindFirstChild("Glove" .. i);

            if v309 then
                local Weld = Instance.new("Weld");
                Weld.Part0 = v308;
                Weld.Part1 = v309;
                Weld.C0 = Category[v .. "GloveWeldPosition"];
                Weld.Parent = v308;
                v309.Parent = v308;
            end;

            if Sleeves then
                local v310 = Sleeves:FindFirstChild("Sleeve" .. i);

                if v310 then
                    local Weld = Instance.new("Weld");
                    Weld.Part0 = v308;
                    Weld.Part1 = v310;
                    Weld.C0 = v301["Sleeve" .. v .. "Position"];
                    Weld.Parent = v308;
                    v310.Parent = v308;
                end;
            end;
        end;
    end;

    ApplyViewmodelGloveSkin(Arms, Item, u38);
    ApplyViewmodelSleeveSkin(Arms, v301, u38);

    for _, descendant in v291:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.CastShadow = false;
        end;
    end;

    v291.Parent = ReplicatedFirst;
    u288.StickerMeshes = {};
    local v311 = {};
    local v312 = {};
    u288.Animators = v311;
    u288.Rig = nil;
    u288.LimbMotors = v312;
    u288.PoseIsReset = false;
    local Rig = u15.GetRig("Weapon", u288.Name);

    if Rig then
        local v313 = u15.LoadRig(Rig);
        local Rig2 = v313.Rig;
        local limb_name_to_index = Rig2.limb_name_to_index;
        u288.Rig = Rig2;

        for i, v in v313.Assets do
            local v314 = u15.LoadAnimation(v, i == "Idle");
            v311[i] = v314;
            local v315 = i;

            for _, v2 in u13.AnimationEventNames do
                if v314.Events[v2] ~= nil then
                    local WeaponSound = u16.GetWeaponSound(u288.Name, v2);
                    local u316;

                    if v315 == "Plant" then
                        u316 = v2 == "open" and 0 or tonumber(string.match(v2, "^press(%d+)$"));
                    else
                        u316 = nil;
                    end;

                    local u317;

                    if v315 == "Plant" and u316 ~= nil then
                        u317 = u316 > 0;
                    else
                        u317 = false;
                    end;

                    v314:OnEvent(v2, function() -- Line: 1587
                        -- upvalues: u316 (ref), u14 (ref), Weapon (copy), WeaponSound (copy), u288 (copy), u16 (ref), u317 (copy)
                        if u316 then
                            u14.SetBombDisplay(Weapon, u316);
                        end;

                        if WeaponSound and not u288.SilentEvents then
                            u16.Play(WeaponSound, {
                                LocalReplicated = u288.Reloading or u317
                            });
                        end;
                    end);
                end;
            end;
        end;

        local limb_transforms = Rig2.limb_transforms;

        for _, v in v291:QueryDescendants("Motor6D") do
            local Part1 = v.Part1;

            if Part1 then
                Part1 = limb_name_to_index[Part1.Name];
            end;

            if Part1 then
                v312[v] = limb_transforms[Part1];
            end;
        end;

        if u288.Animators.SilencerOff then
            u288.Animators.SilencerOff:OnEvent("screwhide", function() -- Line: 1630
                -- upvalues: Weapon (copy)
                local Silencer = Weapon:FindFirstChild("Silencer", true);

                if Silencer and Silencer:IsA("BasePart") then
                    Silencer.Transparency = 1;
                end;
            end);
        end;

        if u288.Animators.SilencerOn then
            u288.Animators.SilencerOn:OnEvent("screwshow", function() -- Line: 1639
                -- upvalues: Weapon (copy)
                local Silencer = Weapon:FindFirstChild("Silencer", true);

                if Silencer and Silencer:IsA("BasePart") then
                    Silencer.Transparency = 0;
                end;
            end);
        end;

        if u288.Animators.Plant and Weapon then
            u14.SetBombDisplay(Weapon, 0);
        end;
    end;

    local CFrame2 = p289.CFrame;

    if CFrame2 then
        v291:PivotTo(CFrame2);
    end;

    local Scale = p289.Scale;

    if Scale then
        v291:ScaleTo(Scale);
    end;

    u288.ViewmodelScale = v291:GetScale();
    v291.Parent = p289.Parent or nil;
    local v318 = u288.Data and u288.Data.AltFunction;

    if v318 and (v318.Name == "Silencer" and u288.Mode ~= 1) then
        local Silencer = Weapon:FindFirstChild("Silencer", true);

        if Silencer and Silencer:IsA("BasePart") then
            Silencer.Transparency = 1;
        end;
    end;

    u288.ViewmodelIsVisible = false;
    local v319, v320, v321, v322 = SnapshotVisible(v291);
    u288.VisiblePartsMap = v319;
    u288.VisibleTextsMap = v320;
    u288.VisibleGuisMap = v321;
    u288.VisibleStrokesMap = v322;
    local AIM = v291:FindFirstChild("AIM");

    if AIM then
        u288.IronSightOffset = AIM.CFrame:ToObjectSpace(u288.PrimaryPart.CFrame);
    end;

    local Dot = u288.Viewmodel:FindFirstChild("Dot");
    u288.ScopeDot = Dot;

    if Dot then
        Dot = Dot.Color;
    end;

    u288.ScopeDotColor = Dot;
    u288.ScopeDotTransparency = 0.3;
    u288.ScopeDotBlur = 0;
    local v323;

    if u288 then
        v323 = u288.Viewmodel;
    else
        v323 = u288;
    end;

    if v323 then
        if u288.ScopeDotSource ~= v323 then
            u288.ScopeDotSource = v323;
            u288.ScopeDot = v323:FindFirstChild("Dot");
            u288.ScopeDotLastTransparency = nil;
        end;

        local ScopeDot = u288.ScopeDot;

        if ScopeDot then
            local math_lerp_ret = math.lerp(1, u288.ScopeDotTransparency, 0);

            if u288.ScopeDotLastTransparency ~= math_lerp_ret then
                u288.ScopeDotLastTransparency = math_lerp_ret;
                ScopeDot.Transparency = math_lerp_ret;
            end;
        end;
    end;

    if u288.Stickers and next(u288.Stickers) then
        task.spawn(AttachStickers, u288);
    end;

    return u288;
end;

function u1.SetSkin(p324: any, p325: string) -- Line: 1711
    -- upvalues: u7 (ref), u1 (copy)
    local WeaponSkin = u7.GetWeaponSkin(p324.Name, p325);
    local v326 = p324.Viewmodel and p324.Viewmodel:FindFirstChild("Weapon");

    if not (WeaponSkin and v326) then
        return false;
    end;

    for i, v in WeaponSkin.Assets do
        local v327 = v326:FindFirstChild(i);

        if v327 then
            local v328 = v327:FindFirstChildOfClass("SurfaceAppearance");

            if v328 then
                v328:Destroy();
            end;

            local v329 = v:Clone();

            if WeaponSkin.AnimatedTint then
                u1.ApplyAnimatedTint(v329, WeaponSkin.AnimatedTint);
            end;

            v329.Parent = v327;
        end;
    end;

    p324.Skin = p325;
    p324.AnimatedTintAction = nil;

    return true;
end;

function u1.Destroy(p330) -- Line: 1747
    -- upvalues: u15 (ref), u49 (ref), u52 (ref), u53 (ref), u54 (ref), u55 (ref)
    local Animators = p330.Animators;

    for i, v in Animators do
        u15.Remove(v);
        Animators[i] = nil;
    end;

    for _, v in p330.StickerMeshes do
        v.editableMesh:Destroy();
    end;

    p330.StickerMeshes = nil;
    p330.Viewmodel:Destroy();
    p330.Animators = nil;
    p330.Rig = nil;
    p330.LimbMotors = nil;
    p330.LastPoseRig = nil;
    p330.LastPoseScale = nil;
    p330.LastPoseMotors = nil;
    p330.VisiblePartsMap = nil;
    p330.VisibleTextsMap = nil;
    p330.VisibleGuisMap = nil;
    p330.VisibleStrokesMap = nil;
    p330.KillTrackText = nil;
    u49 = 0;
    u52 = 0;
    u53 = 1;

    if u54 == p330 then
        u54 = nil;
        u55 = nil;
    end;
end;

function u1.SetVisible(p331: any, p332: boolean) -- Line: 1779
    -- upvalues: SnapshotVisible (copy)
    if p331.ViewmodelIsVisible == p332 then
        return;
    end;

    p331.ViewmodelIsVisible = p332;

    if not p332 then
        local v333, v334, v335, v336 = SnapshotVisible(p331.Viewmodel);
        p331.VisiblePartsMap = v333;
        p331.VisibleTextsMap = v334;
        p331.VisibleGuisMap = v335;
        p331.VisibleStrokesMap = v336;
    end;

    for i, v in p331.VisiblePartsMap do
        i.Transparency = not p332 and 1 or v;
    end;

    for i, v in p331.VisibleTextsMap do
        i.TextTransparency = not p332 and 1 or v;
    end;

    if p331.VisibleGuisMap then
        for i, v in p331.VisibleGuisMap do
            local v337;

            if p332 then
                v337 = v;
            else
                v337 = false;
            end;

            i.Enabled = v337;
        end;
    end;

    if p331.VisibleStrokesMap then
        for i, v in p331.VisibleStrokesMap do
            i.Transparency = not p332 and 1 or v;
        end;
    end;
end;

function u1.SolveAnimation(p338) -- Line: 1812
    -- upvalues: u15 (ref)
    local Rig = p338.Rig;

    if not Rig then
        return false;
    end;

    local v339, v340 = u15.Solve(Rig, p338.Animators, true);

    if not v339 then
        return false;
    end;

    p338.PoseFadeLeft = nil;
    local ViewmodelScale = p338.ViewmodelScale;

    if not (v340 or (p338.PoseIsReset or (p338.LastPoseRig ~= Rig or (p338.LastPoseScale ~= ViewmodelScale or p338.LastPoseMotors ~= p338.LimbMotors)))) then
        return true;
    end;

    local LimbMotors = p338.LimbMotors;
    p338.LastPoseRig = Rig;
    p338.LastPoseScale = ViewmodelScale;
    p338.LastPoseMotors = LimbMotors;
    p338.PoseIsReset = false;

    for i, v in p338.LimbMotors do
        local position = v.position;
        local quat_vector = v.quat_vector;
        i.Transform = CFrame.new(position.x * ViewmodelScale, position.y * ViewmodelScale, position.z * ViewmodelScale, quat_vector.x, quat_vector.y, quat_vector.z, v.quat_scalar);
    end;

    return true;
end;

function u1.SetOffsetPresets(p341) -- Line: 1846
    -- upvalues: u32 (ref)
    u32 = p341;
end;

function u1.ResetPose(p342: any, p343: number?) -- Line: 1850
    local LimbMotors = p342.LimbMotors;

    if not LimbMotors or p342.PoseIsReset then
        return;
    end;

    local PoseFadeLeft = p342.PoseFadeLeft;

    if not PoseFadeLeft then
        for i in LimbMotors do
            i.Transform = CFrame.identity;
        end;

        p342.PoseIsReset = true;

        return;
    end;

    if not p343 then
        return;
    end;

    local math_min_ret = math.min(p343 / PoseFadeLeft, 1);

    for i in LimbMotors do
        i.Transform = i.Transform:Lerp(CFrame.identity, math_min_ret);
    end;

    if math_min_ret < 1 then
        p342.PoseFadeLeft = PoseFadeLeft - p343;

        return;
    end;

    p342.PoseFadeLeft = nil;
    p342.PoseIsReset = true;
end;

function u1.CalculateView(p344, p345: any, p346: any, p347: number, p348: number) -- Line: 1893
    -- upvalues: u51 (ref), u50 (ref), u49 (ref), u1 (copy), u33 (ref), u32 (ref), CFrame_identity (ref), CalculateBobbing (copy), CalculateFinalResult (copy), u21 (ref), u12 (ref)
    if not p346.ViewmodelIsVisible then
        return p344;
    end;

    u51 = u50 and p346.Data.Type ~= "Bomb";
    u49 = u49 + p347;
    local CurrentAnimator = p346.CurrentAnimator;

    if not (CurrentAnimator and CurrentAnimator.Playing) then
        local v349 = vector.magnitude(p345.Velocity * Vector3.new(1, 0, 1)) > 1 and "Move" or "Idle";

        if p346.AnimatedTintAction ~= v349 then
            u1.PlayAnimatedTint(p346, v349);
        end;
    end;

    if not (u1.SolveAnimation(p346) or p346.Reloading) then
        u1.ResetPose(p346, p347);
    end;

    local AltFunction = p346.Data.AltFunction;

    if AltFunction then
        AltFunction = AltFunction.Name == "ScopeRifle";
    end;

    local v350, v351 = u1.CalculateIronSightOffset(p346, p347, p345.Velocity);
    local v352 = AltFunction and v351 and v351 or 0;
    local v353;

    if p346.Name == u33 then
        v353 = false;
    else
        v353 = u32[p346.Name] or u32.All;
    end;

    local v354 = v353 and CFrame.new(v353[1] / 10, v353[2] / 10, v353[3] / 10) or CFrame_identity;
    local v355;

    if v352 == 0 then
        v355 = p344 * v354;
    elseif v352 < 1 then
        v355 = p344 * CFrame.identity:Lerp(v354, 1 - v352);
    else
        v355 = p344;
    end;

    CalculateBobbing(p345, p346, p347, p348);
    local v356 = 1 - v351;
    local v357 = CalculateFinalResult(v355, p345, p347, v356);

    if v356 ~= 0 then
        v357 = u12.ApplyShake(v357, 0.1 * (1 + (u21 or 0) * 0.003125 * 0.75) * v356);
    end;

    local v358 = p345._AimPunchAngle or (p345.RenderAimPunchAngle or p345.AimPunchAngle);
    local v359 = 0.005672320068981571 * v356;
    local v360 = u51 and -v358.Y or v358.Y;

    if v359 ~= 0 and v358 ~= Vector3.new(0, 0, 0) then
        v357 = v357 * CFrame.fromEulerAnglesYXZ(v358.X * v359, v360 * v359, v358.Z * v359);
    end;

    if u51 then
        v357 = CFrame.fromMatrix(v357.Position, v357.XVector, v357.YVector, -v357.ZVector) * CFrame.Angles(0, 3.141592653589793, 0);
    end;

    if v350 ~= CFrame.identity then
        local AppliedScretchAmount = u12.GetAppliedScretchAmount();

        if AppliedScretchAmount ~= 1 then
            v350 = v350 + vector.create(0, v350.Y * (1 / AppliedScretchAmount - 1), 0);
        end;

        v357 = v357 * v350;
    end;

    local v361 = p344:PointToObjectSpace(v357.Position);
    local HandSwitchFromPosition = p346.HandSwitchFromPosition;
    local v362;

    if HandSwitchFromPosition then
        local math_min_ret = math.min((p346.HandSwitchBlend or 0) + p347 / 0.12, 1);
        p346.HandSwitchBlend = math_min_ret;
        v362 = vector.lerp(HandSwitchFromPosition, v361, math_min_ret < 0.5 and (math_min_ret * 2) ^ 2.321928094887362 * 0.5 or 1 - (2 - math_min_ret * 2) ^ 2.321928094887362 * 0.5);
        v357 = v357 + p344:VectorToWorldSpace(v362 - v361);

        if math_min_ret == 1 then
            p346.HandSwitchFromPosition = nil;
            p346.HandSwitchBlend = nil;
        end;
    else
        v362 = v361;
    end;

    p346.LastViewmodelPosition = v362;

    return v357;
end;

local table_create_ret3 = table.create(1);
local table_create_ret4 = table.create(1);

function u1.Render(p363, p364: any, p365: any, p366: number, p367: number) -- Line: 2019
    -- upvalues: u1 (copy), table_create_ret3 (copy), table_create_ret4 (copy)
    local PrimaryPart = p365.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local v368 = u1.CalculateView(p363, p364, p365, p366, p367);
    table_create_ret3[1] = PrimaryPart;
    table_create_ret4[1] = v368;
    workspace:BulkMoveTo(table_create_ret3, table_create_ret4, Enum.BulkMoveMode.FireCFrameChanged);
end;

function u1.Init(p369) -- Line: 2035
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u13 (ref), u7 (ref), u8 (ref), u15 (ref), u16 (ref), u14 (ref), u17 (ref), u10 (ref), u11 (ref), u12 (ref)
    u4 = p369:GetModule("Tick");
    u5 = p369:GetModule("Math");
    u6 = p369:GetModule("WeaponManager");
    u13 = p369:GetModule("WeaponConstructor");
    u7 = p369:GetModule("SkinManager");
    u8 = p369:GetModule("ItemManager");
    u15 = p369:GetModule("AnimationManager");
    u16 = p369:GetModule("SoundManager");
    u14 = p369:GetModule("CharacterModel");
    u17 = p369:GetModule("ProjectDecal");
    u10 = p369:GetModule("WeaponController");
    u11 = p369:GetModule("CharacterController");
    u12 = p369:GetModule("CameraController");
end;

function u1.Start(p370) -- Line: 2053
    -- upvalues: u9 (ref), u10 (ref), u2 (ref), u3 (ref), u42 (ref), u41 (ref), u1 (copy), u34 (ref), ReplicatedStorage (copy), u37 (ref), u36 (ref), ApplyViewmodelNoTexture (copy), u11 (ref)
    u9 = p370:GetModule("Gui");
    u10.OnWeaponChanged:Connect(function(p371) -- Line: 2056
        -- upvalues: u2 (ref), u3 (ref), u42 (ref), u41 (ref), u1 (ref), u34 (ref), ReplicatedStorage (ref), u37 (ref), u36 (ref)
        local Viewmodel = p371.Viewmodel;
        local Arms = Viewmodel.Arms;
        u2 = Viewmodel;
        u3 = p371;
        p371.HandSwitchFromPosition = nil;
        p371.HandSwitchBlend = nil;
        p371.LastViewmodelPosition = nil;
        local v372;

        if p371 then
            v372 = p371.Viewmodel;
        else
            v372 = p371;
        end;

        if v372 then
            v372 = v372:FindFirstChild("Dot");
        end;

        if v372 then
            v372.Color = u42 and u41 or p371.ScopeDotColor;
        end;

        u1.ApplyKillTrackColor(p371);

        if u34 then
            local v373 = p371 and p371.Viewmodel and p371.Viewmodel.Weapon;

            if v373 then
                for _, v in v373:QueryDescendants("SurfaceAppearance") do
                    v.Parent = ReplicatedStorage;
                end;

                for _, v in v373:QueryDescendants("MeshPart") do
                    v.TextureID = "";
                end;
            end;
        end;

        if u37 and Arms then
            local v374 = Arms:FindFirstChild("Left Arm");
            local v375 = v374 and v374:FindFirstChild("GloveL");

            if v375 then
                v375.Parent = ReplicatedStorage;
            end;

            local v376 = Arms:FindFirstChild("Right Arm");
            local v377 = v376 and v376:FindFirstChild("GloveR");

            if v377 then
                v377.Parent = ReplicatedStorage;
            end;
        end;

        if u36 then
            if not Arms then
                return;
            end;

            local v378 = Arms:FindFirstChild("Left Arm");
            local v379 = v378 and v378:FindFirstChild("SleeveL");

            if v379 then
                v379.Parent = ReplicatedStorage;
            end;

            local v380 = Arms:FindFirstChild("Right Arm");
            local v381 = v380 and v380:FindFirstChild("SleeveR");

            if v381 then
                v381.Parent = ReplicatedStorage;
            end;
        end;
    end);
    u10.OnWeaponShoot:Connect(function(p382) -- Line: 2081
        local AltFunction = p382.Data.AltFunction;

        if AltFunction and (AltFunction.Name == "ScopeRifle" and (p382.IronSightAmount or 0) > 0) then
            local v383 = (p382.ScopeDotBlur or 0) + 0.22 + math.random() * 0.06;
            p382.ScopeDotBlur = math.clamp(v383, 0, 1);
        end;
    end);
    u10.OnWeaponUnequip:Connect(function(p384) -- Line: 2088
        -- upvalues: u34 (ref), ApplyViewmodelNoTexture (ref), u37 (ref), ReplicatedStorage (ref), u36 (ref)
        local Arms = p384.Viewmodel.Arms;

        if u34 then
            ApplyViewmodelNoTexture(p384, false);
        end;

        if u37 and Arms then
            local GloveL = ReplicatedStorage:FindFirstChild("GloveL");
            local v385 = GloveL and Arms:FindFirstChild("Left Arm");

            if v385 then
                GloveL.Parent = v385;
            end;

            local GloveR = ReplicatedStorage:FindFirstChild("GloveR");
            local v386 = GloveR and Arms:FindFirstChild("Right Arm");

            if v386 then
                GloveR.Parent = v386;
            end;
        end;

        if u36 then
            if not Arms then
                return;
            end;

            local SleeveL = ReplicatedStorage:FindFirstChild("SleeveL");
            local v387 = SleeveL and Arms:FindFirstChild("Left Arm");

            if v387 then
                SleeveL.Parent = v387;
            end;

            local SleeveR = ReplicatedStorage:FindFirstChild("SleeveR");
            local v388 = SleeveR and Arms:FindFirstChild("Right Arm");

            if v388 then
                SleeveR.Parent = v388;
            end;
        end;
    end);
    u10.OnKillTrackChanged:Connect(function(p389) -- Line: 2105
        if not p389.Viewmodel then
            return;
        end;

        local KillTrackText = p389.KillTrackText;

        if not KillTrackText then
            return;
        end;

        if p389.Data and p389.Data.Type == "Melee" then
            KillTrackText.Text = (`{math.clamp(p389.KillTrack, 0, 999999)}`):gsub("0", "O");

            return;
        end;

        local v390 = `{math.clamp(p389.KillTrack, 0, 999999)}`;
        local v391 = tostring(v390);
        local v392 = #v391;

        if v392 < 6 then
            v391 = string.rep("0", 6 - v392) .. v391;
        end;

        KillTrackText.Text = v391;
    end);
    u10.OnKillTrackColorChanged:Connect(function(p393) -- Line: 2126
        -- upvalues: u1 (ref)
        u1.ApplyKillTrackColor(p393);
    end);
    u11.OnCharacterDestroy:Connect(function() -- Line: 2130
        -- upvalues: u2 (ref), u3 (ref)
        u2 = nil;
        u3 = nil;
    end);
end;

function u1.Start2(p394) -- Line: 2136
    -- upvalues: u9 (ref), CFrame_identity (ref), u33 (ref), u50 (ref), u10 (ref), u35 (ref), u34 (ref), u2 (ref), ApplyViewmodelNoTexture (copy), u3 (ref), u36 (ref), ApplyViewmodelNoSleeves (copy), u37 (ref), ApplyViewmodelNoGloves (copy), u38 (ref), ApplyViewmodelSkin (copy), ApplyViewmodelGloveSkin (copy), ApplyViewmodelSleeveSkin (copy), u39 (ref), u40 (ref), u41 (ref), u42 (ref)
    local Component = u9.GetComponent("Settings");
    local u395 = 0;
    local u396 = 0;
    local u397 = 0;
    CFrame_identity = CFrame.identity;
    Component:AddPlayerConnection("Game", "Viewmodel", "Viewmodel Preset", function(p398) -- Line: 2142
        -- upvalues: u33 (ref)
        u33 = p398;
    end);
    Component:AddPlayerConnection("Game", "Viewmodel", "Viewmodel Offset X", function(p399) -- Line: 2145
        -- upvalues: u395 (ref), CFrame_identity (ref), u396 (ref), u397 (ref)
        u395 = p399 / 10;
        CFrame_identity = CFrame.new(u395, u396, u397);
    end);
    Component:AddPlayerConnection("Game", "Viewmodel", "Viewmodel Offset Y", function(p400) -- Line: 2149
        -- upvalues: u396 (ref), CFrame_identity (ref), u395 (ref), u397 (ref)
        u396 = p400 / 10;
        CFrame_identity = CFrame.new(u395, u396, u397);
    end);
    Component:AddPlayerConnection("Game", "Viewmodel", "Viewmodel Offset Z", function(p401) -- Line: 2153
        -- upvalues: u397 (ref), CFrame_identity (ref), u395 (ref), u396 (ref)
        u397 = p401 / 10;
        CFrame_identity = CFrame.new(u395, u396, u397);
    end);
    Component:AddPlayerConnection("Game", "Gameplay", "Preferred Viewmodel Left/Right Handedness", function(p402) -- Line: 2158
        -- upvalues: u50 (ref), u10 (ref), u35 (ref)
        local v403 = p402 == "Left";

        if u50 == v403 then
            return;
        end;

        u50 = v403;
        local CurrentWeapon = u10.GetCurrentWeapon();

        if CurrentWeapon then
            local AltFunction = CurrentWeapon.Data.AltFunction;

            if AltFunction then
                if AltFunction.Name == "ScopeRifle" then
                    AltFunction = CurrentWeapon.Mode == 2 and true or (CurrentWeapon.IronSightAmount or 0) > 0;
                else
                    AltFunction = false;
                end;
            end;

            if AltFunction then
                CurrentWeapon.HandSwitchFromPosition = nil;
                CurrentWeapon.HandSwitchBlend = nil;

                return;
            end;

            CurrentWeapon.HandSwitchFromPosition = CurrentWeapon.LastViewmodelPosition;
            CurrentWeapon.HandSwitchBlend = 0;

            if not (CurrentWeapon.Inspecting or u35) then
                CurrentWeapon:PlayAnimation("Equip", true, 0.12);
            end;
        end;
    end);
    Component:AddConnection("Game", "Viewmodel", "Remove Equip Animation on Hand Switch", function(p404) -- Line: 2184
        -- upvalues: u35 (ref)
        u35 = p404;
    end);
    Component:AddConnection("Game", "Viewmodel", "Remove Viewmodel Texture", function(p405) -- Line: 2188
        -- upvalues: u34 (ref), u2 (ref), ApplyViewmodelNoTexture (ref), u3 (ref)
        u34 = p405;

        if u2 then
            ApplyViewmodelNoTexture(u3, p405);
        end;
    end);
    Component:AddConnection("Game", "Viewmodel", "Remove Viewmodel Sleeves", function(p406) -- Line: 2196
        -- upvalues: u36 (ref), u2 (ref), ApplyViewmodelNoSleeves (ref)
        u36 = p406;

        if u2 then
            ApplyViewmodelNoSleeves(u2.Arms, p406);
        end;
    end);
    Component:AddConnection("Game", "Viewmodel", "Remove Viewmodel Gloves", function(p407) -- Line: 2204
        -- upvalues: u37 (ref), u2 (ref), ApplyViewmodelNoGloves (ref)
        u37 = p407;

        if u2 then
            ApplyViewmodelNoGloves(u2.Arms, p407);
        end;
    end);
    Component:AddConnection("Game", "Viewmodel", "Remove PBR Textures on Viewmodel", function(p408) -- Line: 2212
        -- upvalues: u38 (ref), u2 (ref), u34 (ref), ApplyViewmodelSkin (ref), u3 (ref), ApplyViewmodelGloveSkin (ref), ApplyViewmodelSleeveSkin (ref)
        u38 = p408;

        if u2 then
            if not u34 then
                ApplyViewmodelSkin(u3, p408);
            end;

            ApplyViewmodelGloveSkin(u2.Arms, u3.GloveItem, p408);
            ApplyViewmodelSleeveSkin(u2.Arms, u3.ArmsData, p408);
        end;
    end);
    Component:AddPlayerConnection("Game", "Viewmodel", "Remove Viewmodel Bobbing", function(p409) -- Line: 2224
        -- upvalues: u39 (ref)
        u39 = p409;
    end);
    Component:AddPlayerConnection("Game", "Viewmodel", "Remove Viewmodel Sway", function(p410) -- Line: 2228
        -- upvalues: u40 (ref)
        u40 = p410;
    end);
    Component:AddPlayerConnection("Game", "Crosshair", "Crosshair Color", function(p411) -- Line: 2232
        -- upvalues: u41 (ref), u3 (ref), u42 (ref)
        u41 = Color3.fromRGB(unpack(p411));
        local v412 = u3;
        local v413;

        if v412 then
            v413 = v412.Viewmodel;
        else
            v413 = v412;
        end;

        if v413 then
            v413 = v413:FindFirstChild("Dot");
        end;

        if v413 then
            v413.Color = u42 and u41 or v412.ScopeDotColor;
        end;
    end);
    Component:AddPlayerConnection("Game", "Crosshair", "Use Crosshair Color for Scope Dot", function(p414) -- Line: 2237
        -- upvalues: u42 (ref), u3 (ref), u41 (ref)
        u42 = p414;
        local v415 = u3;
        local v416;

        if v415 then
            v416 = v415.Viewmodel;
        else
            v416 = v415;
        end;

        if v416 then
            v416 = v416:FindFirstChild("Dot");
        end;

        if v416 then
            v416.Color = u42 and u41 or v415.ScopeDotColor;
        end;
    end);
end;

return u1;