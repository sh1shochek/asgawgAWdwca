-- ReplicatedStorage.Shared.CharacterModel
-- Script path: ReplicatedStorage.Shared.CharacterModel
-- Decompile time: 47.47 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = game:GetService("RunService"):IsServer();
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local Assets = ReplicatedStorage:WaitForChild("Assets");
local RigTemplate = Assets:WaitForChild("RigTemplate");
local Multimeter = Assets:WaitForChild("Multimeter");
local table_freeze_ret = table.freeze({
    Shirt = {
        UpperTorso = true,
        LowerTorso = true,
        LeftUpperArm = true,
        LeftLowerArm = true,
        LeftHand = true,
        RightUpperArm = true,
        RightLowerArm = true,
        RightHand = true
    },
    Pants = {
        LeftUpperLeg = true,
        LeftLowerLeg = true,
        LeftFoot = true,
        RightUpperLeg = true,
        RightLowerLeg = true,
        RightFoot = true
    }
});
local table_freeze_ret2 = table.freeze({
    Head = "HeadColor3",
    UpperTorso = "TorsoColor3",
    LowerTorso = "TorsoColor3",
    LeftUpperLeg = "LeftLegColor3",
    LeftLowerLeg = "LeftLegColor3",
    LeftFoot = "LeftLegColor3",
    LeftUpperArm = "LeftArmColor3",
    LeftLowerArm = "LeftArmColor3",
    LeftHand = "LeftArmColor3",
    RightUpperLeg = "RightLegColor3",
    RightLowerLeg = "RightLegColor3",
    RightFoot = "RightLegColor3",
    RightHand = "RightArmColor3",
    RightUpperArm = "RightArmColor3",
    RightLowerArm = "RightArmColor3"
});
local CFrame_new_ret = CFrame.new(0, 0.799999952, 0);
local CFrame_new_ret2 = CFrame.new(-1, 0.563, 0);
local CFrame_new_ret3 = CFrame.new(1, 0.563, 0);
local CFrame_new_ret4 = CFrame.new(0, 0.2, 0);
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;

local function ApplyAgent(p8: userdata, p9: string) -- Line: 119
    -- upvalues: u3 (ref), u1 (copy), table_freeze_ret2 (copy)
    local Asset = u3.GetItem("Agents", p9).Asset;
    local v10 = {};

    if not Asset then
        return v10;
    end;

    local v11 = Asset:FindFirstChildOfClass("Pants");

    if v11 then
        u1.AddPants(p8, v11.PantsTemplate);
    end;

    local v12 = Asset:FindFirstChildOfClass("Shirt");

    if v12 then
        u1.AddShirt(p8, v12.ShirtTemplate);
    end;

    local v13 = Asset:FindFirstChildOfClass("Decal");

    if v13 then
        local Head = p8.Head;
        local v14 = Head:FindFirstChildOfClass("Decal");

        if v14 then
            v14:Destroy();
        end;

        local v15 = v13:Clone();
        v15.Parent = Head;
        table.insert(v10, v15);
    end;

    for _, child in ipairs(Asset:GetChildren()) do
        if child.ClassName == "Accessory" then
            local v16 = child:Clone();
            u1.AddAccessory(p8, v16);
            table.insert(v10, v16);
        end;
    end;

    local v17 = Asset:FindFirstChildOfClass("BodyColors");

    if v17 then
        for _, child in ipairs(p8:GetChildren()) do
            if child.ClassName == "MeshPart" then
                child.Color = v17[table_freeze_ret2[child.Name]];
            end;
        end;
    end;

    return v10;
end;

local function ApplyGloves(p18: userdata, p19: string, p20: string) -- Line: 201
    -- upvalues: u3 (ref), u1 (copy)
    local Category = u3.GetCategory(p19);
    local Item = u3.GetItem(p19, p20);
    local v21 = {};

    if not (Category and Item) then
        return v21;
    end;

    local WorldModel = Item.WorldModel;
    local v22 = Category.Assets and Category.Assets.CharacterModel;

    if v22 then
        for _, child in v22:GetChildren() do
            if child.ClassName == "Accessory" then
                local v23 = child:Clone();
                local v24 = v23:FindFirstChildWhichIsA("Attachment", true);
                local v25 = v23:GetAttribute("Part") or "";
                local v26 = tostring(v25) .. v23.Name .. (v24 and v24.Name or "");
                local v27;

                if WorldModel and WorldModel[v23.Name] then
                    v27 = v23.Name;
                else
                    v27 = string.find(v26, "Left") and "GloveL" or (string.find(v26, "Right") and "GloveR" or nil);
                end;

                if WorldModel then
                    if v27 then
                        v27 = WorldModel[v27];
                    end;
                else
                    v27 = WorldModel;
                end;

                if not v27 then
                    warn(string.format("ApplyGloves: no WorldModel skin for %s/%s accessory %q", p19, p20, v23.Name));
                end;

                if v27 then
                    for _, descendant in v23:GetDescendants() do
                        if descendant:IsA("SurfaceAppearance") then
                            descendant:Destroy();
                        elseif descendant:IsA("MeshPart") then
                            descendant.TextureID = v27.Value;
                        elseif descendant:IsA("SpecialMesh") then
                            descendant.TextureId = v27.Value;
                        end;
                    end;
                end;

                u1.AddAccessory(p18, v23);
                table.insert(v21, v23);
            end;
        end;
    end;

    return v21;
end;

u1.RenderOffset = Vector3.new(0, 0.45, 0);
u1.ApplyAgent = ApplyAgent;

function u1.RemoveAgent(p28: userdata, p29: table) -- Line: 180
    -- upvalues: RigTemplate (copy)
    for _, v in p29 do
        v:Destroy();
    end;

    for _, child in p28:GetChildren() do
        if child.ClassName == "MeshPart" then
            local v30 = RigTemplate[child.Name];
            child.TextureID = v30.TextureID;
            child.Color = v30.Color;
        end;
    end;

    local Head = p28.Head;

    if not Head:FindFirstChildOfClass("Decal") then
        RigTemplate.Head.face:Clone().Parent = Head;
    end;
end;

u1.ApplyGloves = ApplyGloves;
u1.AnimationIds = {
    Rifle = {
        Loadout = "rbxassetid://100712764403240",
        Match_End_Begin = "rbxassetid://72322136380521",
        Match_End_Idle = "rbxassetid://72551438326286"
    },
    Pistol = {
        Loadout = "rbxassetid://79758193305573",
        Match_End_Begin = "rbxassetid://89703937159949",
        Match_End_Idle = "rbxassetid://73977456705982"
    },
    SMG = {
        Loadout = "rbxassetid://135670383595301",
        Match_End_Begin = "rbxassetid://113990550483001",
        Match_End_Idle = "rbxassetid://130022181119730"
    },
    Heavy = {
        Loadout = "rbxassetid://71768210796089",
        Match_End_Begin = "rbxassetid://125955482640344",
        Match_End_Idle = "rbxassetid://107471215499885"
    },
    ["Sniper Rifle"] = {
        Loadout = "rbxassetid://137201597028603",
        Match_End_Begin = "rbxassetid://108112918311559",
        Match_End_Idle = "rbxassetid://82596759725626"
    }
};

function u1.GetWeaponClass(p31: string) -- Line: 289
    -- upvalues: u6 (ref)
    local v32 = u6.Get(p31);

    if not (v32 and v32.Data) then
        return nil;
    end;

    local Type = v32.Data.Type;

    return Type == "Pistol" and "Pistol" or (Type == "SMG" and "SMG" or ((Type == "Shotgun" or Type == "Heavy") and "Heavy" or ((Type == "SniperRifle" or (Type == "Sniper" or (v32.Data.Muzzle == "Sniper" or v32.Data.AltFunction and v32.Data.AltFunction.Type == "Sniper"))) and "Sniper Rifle" or (Type == "Rifle" and "Rifle" or nil))));
end;

function u1.AddWeapon(p33: userdata, p34: string, p35: string?) -- Line: 311
    -- upvalues: u6 (ref), u1 (copy)
    local CurrentWeapon = p33:FindFirstChild("CurrentWeapon");

    if CurrentWeapon then
        CurrentWeapon:Destroy();
    end;

    local v36 = u6.Get(p34);

    if v36 and (v36.Assets and v36.Assets.CharacterModel) then
        local v37 = v36.Assets.CharacterModel:Clone();
        v37.Name = "CurrentWeapon";

        for _, v in v37:QueryDescendants("BasePart") do
            v.CanQuery = false;
        end;

        u1.ApplyWeaponSkin(v37, p34, p35 or "Stock", nil, true);
        local HandleMotor = v37:FindFirstChild("HandleMotor");

        if HandleMotor then
            local RightHand = p33:FindFirstChild("RightHand");

            if RightHand and v37.PrimaryPart then
                HandleMotor.Part0 = RightHand;
                HandleMotor.Part1 = v37.PrimaryPart;
            end;

            v37.Parent = p33;

            return v37;
        end;

        local HandleMotor1 = v37:FindFirstChild("HandleMotor1");
        local HandleMotor2 = v37:FindFirstChild("HandleMotor2");

        if HandleMotor1 and HandleMotor2 then
            local RightHand = p33:FindFirstChild("RightHand");

            if RightHand and v37.PrimaryPart then
                HandleMotor1.Part0 = RightHand;
                HandleMotor1.Part1 = v37.PrimaryPart;
            end;

            local LeftHand = p33:FindFirstChild("LeftHand");

            if LeftHand then
                HandleMotor2.Part0 = LeftHand;
                HandleMotor2.Part1 = v37[v37.PrimaryPart.Name .. "1"];
            end;

            v37.Parent = p33;

            return v37;
        end;

        local HandleMotorLeft = v37:FindFirstChild("HandleMotorLeft");

        if not HandleMotorLeft then
            v37.Parent = p33;

            return v37;
        end;

        local LeftHand = p33:FindFirstChild("LeftHand");

        if LeftHand and v37.PrimaryPart then
            HandleMotorLeft.Part0 = LeftHand;
            HandleMotorLeft.Part1 = v37.PrimaryPart;
        end;

        v37.Parent = p33;

        return v37;
    end;
end;

function u1.StepBodyYaw(p38: number, p39: number, p40: vector, p41: number) -- Line: 392
    -- upvalues: u5 (ref)
    local v42 = u5.DeltaAngle(p38, p39);

    if vector.magnitude(p40 * Vector3.new(1, 0, 1)) > 0.5 then
        return p38 + math.clamp(v42, p41 * -6.283185307179586, p41 * 6.283185307179586);
    end;

    if math.abs(v42) > 0.7853981633974483 then
        return p39 - math.sign(v42) * 0.7853981633974483;
    end;

    return p38;
end;

local u43 = setmetatable({}, {
    __mode = "k"
});

local function GetPoseMotors(p44: userdata) -- Line: 443
    -- upvalues: u43 (copy)
    local v45 = u43[p44];

    if not v45 then
        v45 = {
            p44.UpperTorso.Waist,
            p44.Head.Neck,
            p44.LeftUpperArm.LeftShoulder,
            p44.RightUpperArm.RightShoulder
        };
        u43[p44] = v45;
    end;

    return v45;
end;

function u1.PoseC0s(p46: number, p47: number, p48: number, p49: table) -- Line: 465
    -- upvalues: u5 (ref), CFrame_new_ret4 (copy), CFrame_new_ret (copy), CFrame_new_ret2 (copy), CFrame_new_ret3 (copy)
    local v50 = u5.DeltaAngle(p46, p47);
    local v51 = -(0.6981317007977318 * math.sin(p48));
    local CFrame_Angles_ret = CFrame.Angles(v51 * 0.5, 0, 0);
    p49[1] = CFrame_new_ret4 * CFrame.fromEulerAnglesYXZ(v51 * 0.6, v50 * 0.6, 0);
    p49[2] = CFrame_new_ret * CFrame.fromEulerAnglesYXZ(v51, v50 * 0.4, 0);
    p49[3] = CFrame_new_ret2 * CFrame_Angles_ret;
    p49[4] = CFrame_new_ret3 * CFrame_Angles_ret;

    return p49;
end;

function u1.PoseC0sBetween(p52: any, p53: any, p54: number, p55: table) -- Line: 484
    -- upvalues: u1 (copy), u5 (ref)
    local vector_lerp_ret = vector.lerp(p52.AimPunchAngle or Vector3.new(0, 0, 0), p53.AimPunchAngle or Vector3.new(0, 0, 0), p54);

    return u1.PoseC0s(u5.LerpAngle(p52.BodyYaw or p52.Yaw, p53.BodyYaw or p53.Yaw, p54), u5.LerpAngle(p52.Yaw, p53.Yaw, p54) + math.rad(vector_lerp_ret.Y), u5.LerpAngle(p52.Pitch, p53.Pitch, p54) - math.rad(vector_lerp_ret.X), p55);
end;

local u56 = {};

function u1.Pose(p57: userdata, p58: number, p59: vector, p60: number, p61: number, p62: boolean?) -- Line: 498
    -- upvalues: u43 (copy), u5 (ref), u1 (copy), u56 (copy)
    if p62 ~= false then
        local v63 = u43[p57];

        if not v63 then
            v63 = {
                p57.UpperTorso.Waist,
                p57.Head.Neck,
                p57.LeftUpperArm.LeftShoulder,
                p57.RightUpperArm.RightShoulder
            };
            u43[p57] = v63;
        end;

        local v64 = u5.DeltaAngle(p58, p60);

        if v63.LastPitch ~= p61 or v63.LastYawOffset ~= v64 then
            local v65 = u1.PoseC0s(p58, p60, p61, u56);
            v63[1].C0 = v65[1];
            v63[2].C0 = v65[2];
            v63[3].C0 = v65[3];
            v63[4].C0 = v65[4];
            v63.LastPitch = p61;
            v63.LastYawOffset = v64;
        end;
    end;

    return CFrame.fromEulerAnglesYXZ(0, p58, 0) + (p59 + Vector3.new(0, 0.45, 0));
end;

local u66 = setmetatable({}, {
    __mode = "kv"
});

local function InvalidateAnimationPose(p67) -- Line: 524
    -- upvalues: u66 (copy)
    local v68 = u66[p67];

    if v68 then
        v68.AnimationTransforms = nil;
        table.clear(v68.AnimationPoseCache);
        v68.AnimationWritesInvalid = true;
    end;
end;

local function ResetAnimationPose(p69) -- Line: 533
    -- upvalues: u66 (copy)
    local v70 = p69.Model and u66[p69.Model];

    if v70 then
        v70.AnimationTransforms = nil;
        table.clear(v70.AnimationPoseCache);
        v70.AnimationWritesInvalid = true;
    end;

    for i in p69.LimbMotors or {} do
        i.Transform = CFrame.identity;
    end;
end;

local u71 = {
    LowerTorso = true,
    LeftUpperLeg = true,
    LeftLowerLeg = true,
    LeftFoot = true,
    RightUpperLeg = true,
    RightLowerLeg = true,
    RightFoot = true
};
u1.BombCodeLength = 8;

function u1.SetBombDisplay(p72: userdata?, p73: number) -- Line: 583
    if p72 then
        p72 = p72:FindFirstChildWhichIsA("TextLabel", true);
    end;

    if p72 then
        local math_clamp_ret = math.clamp(p73, 0, 8);
        p72.Text = string.sub("75384270", 1, math_clamp_ret);
    end;
end;

local function BindBombKeypad(u74: any, u75: userdata) -- Line: 606
    -- upvalues: u1 (copy), SoundManager (copy)
    local Plant = u74.Animators.Plant;

    if not Plant then
        return;
    end;

    local function OnKeypad(p76: string, u77: number) -- Line: 613
        -- upvalues: Plant (copy), u1 (ref), u74 (copy), SoundManager (ref), u75 (copy)
        if Plant.Events[p76] == nil then
            return;
        end;

        Plant:OnEvent(p76, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (ref), u77 (copy), SoundManager (ref), u75 (ref)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u77);

            if u77 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    if Plant.Events.open ~= nil then
        local u78 = 0;
        Plant:OnEvent("open", function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u78 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u78);

            if u78 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v79 = "press" .. 1;

    if Plant.Events[v79] ~= nil then
        local u80 = 1;
        Plant:OnEvent(v79, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u80 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u80);

            if u80 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v81 = "press" .. 2;

    if Plant.Events[v81] ~= nil then
        local u82 = 2;
        Plant:OnEvent(v81, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u82 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u82);

            if u82 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v83 = "press" .. 3;

    if Plant.Events[v83] ~= nil then
        local u84 = 3;
        Plant:OnEvent(v83, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u84 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u84);

            if u84 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v85 = "press" .. 4;

    if Plant.Events[v85] ~= nil then
        local u86 = 4;
        Plant:OnEvent(v85, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u86 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u86);

            if u86 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v87 = "press" .. 5;

    if Plant.Events[v87] ~= nil then
        local u88 = 5;
        Plant:OnEvent(v87, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u88 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u88);

            if u88 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v89 = "press" .. 6;

    if Plant.Events[v89] ~= nil then
        local u90 = 6;
        Plant:OnEvent(v89, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u90 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u90);

            if u90 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v91 = "press" .. 7;

    if Plant.Events[v91] ~= nil then
        local u92 = 7;
        Plant:OnEvent(v91, function() -- Line: 618
            -- upvalues: u1 (ref), u74 (copy), u92 (copy), SoundManager (ref), u75 (copy)
            u1.SetBombDisplay(u74.CurrentWeaponModel, u92);

            if u92 > 0 then
                SoundManager.Play("Bomb.c4_click", {
                    Position = u75:GetPivot().Position
                });
            end;
        end);
    end;

    local v93 = "press" .. 8;

    if Plant.Events[v93] == nil then
        return;
    end;

    local u94 = 8;
    Plant:OnEvent(v93, function() -- Line: 618
        -- upvalues: u1 (ref), u74 (copy), u94 (copy), SoundManager (ref), u75 (copy)
        u1.SetBombDisplay(u74.CurrentWeaponModel, u94);

        if u94 > 0 then
            SoundManager.Play("Bomb.c4_click", {
                Position = u75:GetPivot().Position
            });
        end;
    end);
end;

local u95 = {};

function u1.InitAnimations(p96: any, p97: userdata, p98: string?) -- Line: 638
    -- upvalues: u1 (copy), u4 (ref), u66 (copy), u95 (copy), BindBombKeypad (copy), u71 (copy)
    u1.DestroyAnimations(p96);
    local v99 = u4.GetRig("Character", p98 or "Character") or u4.GetRig("Character", "Character");
    p96.Animators = {};
    p96.LimbMotors = {};
    p96.AnimationTransforms = nil;
    p96.AnimationPoseCache = {};
    p96.AnimationWritesInvalid = true;
    u66[p97] = p96;
    p96.Rig = nil;

    if not v99 then
        local v100 = p98 or "Character";

        if not u95[v100] then
            u95[v100] = true;
            warn((`[CharacterModel] no character rig for '{v100}' and no base 'Character' rig either -- this rig cannot animate`));
        end;

        return;
    end;

    local v101 = u4.LoadRig(v99);
    local Rig = v101.Rig;
    p96.Rig = Rig;

    for i, v in v101.Assets do
        p96.Animators[i] = u4.LoadAnimation(v, i == "Idle" and true or i == "ScopeIdle");
    end;

    BindBombKeypad(p96, p97);

    for _, v in p97:QueryDescendants("Motor6D") do
        local Part1 = v.Part1;
        local v102 = Part1 and not u71[Part1.Name] and Rig.limb_name_to_index[Part1.Name];

        if v102 then
            p96.LimbMotors[v] = Rig.limb_transforms[v102];
        end;
    end;
end;

local function StopOtherAnimators(p103, p104) -- Line: 711
    for _, v in p103.Animators do
        if v ~= p104 then
            local Alpha = v.Track.Alpha;
            v:Stop();

            if v.Looped then
                v.Track.Alpha = Alpha;
            end;
        end;
    end;
end;

function u1.PlayAnimation(p105: any, p106: string, p107: any) -- Line: 727
    -- upvalues: StopOtherAnimators (copy), u1 (copy)
    local v108 = p105.Animators and p105.Animators[p106];

    if not v108 then
        return;
    end;

    local v109 = p106 == "Idle" and true or p106 == "ScopeIdle";
    StopOtherAnimators(p105, v109 and v108 and v108 or p107);

    if p105.CurrentAnimationName == "Plant" and p106 ~= "Plant" then
        u1.SetBombDisplay(p105.CurrentWeaponModel, 0);
    end;

    p105.CurrentAnimationName = p106;

    if not v109 then
        v108.Track.Alpha = 0;
    end;

    v108.Looped = v109;
    v108.Direction = 1;
    v108:Play();
end;

function u1.ReverseAnimation(p110: any, p111: string) -- Line: 758
    -- upvalues: StopOtherAnimators (copy)
    local v112 = p110.Animators and p110.Animators[p111];

    if not v112 then
        return;
    end;

    StopOtherAnimators(p110, v112);
    p110.CurrentAnimationName = p111;
    v112.Looped = false;

    if (p111 == "Scope" or p111 == "ScopeIdle") and v112.Track.Alpha <= 0 then
        v112.Track.Alpha = 1;
    end;

    v112.Direction = -1;
    v112:Play();
end;

local function IsScoped(p113) -- Line: 776
    -- upvalues: u6 (ref)
    local AltFunction = (p113.Data or u6.Get(p113.Name).Data).AltFunction;
    local v114;

    if AltFunction then
        v114 = AltFunction.Name == "Scope" and (p113.ZoomLevel or 0) > 0 and true or AltFunction.Name == "ScopeRifle" and p113.Mode == 2;
    else
        v114 = false;
    end;

    return v114;
end;

local function FireAnimation(p115, p116) -- Line: 784
    -- upvalues: u6 (ref), u4 (ref)
    local Animators = p115.Animators;
    local CharacterAnimation = p116.CharacterAnimation;
    local v117 = (p116.Data or u6.Get(p116.Name).Data).Type == "Melee";
    local v118;

    if v117 then
        v118 = p116.Variant or 0;
    else
        v118 = p116.Mode or 1;
    end;

    if CharacterAnimation and Animators[CharacterAnimation] then
        return CharacterAnimation;
    end;

    if p116.Name == "Dual Berettas" then
        return (p116.Data and p116.Data.Ammo or (p116.Ammo or 0)) % 2 == 0 and "Fire2" or "Fire1";
    end;

    if v118 == 3 and Animators.Stab then
        return "Stab";
    end;

    if (v117 or v118 > 1) and Animators["Fire" .. v118] then
        return "Fire" .. v118;
    end;

    return Animators.Plant and "Plant" or u4.PickVariant(Animators, "Fire");
end;

local function Ammo(p119) -- Line: 815
    return p119.Data and p119.Data.Ammo or p119.Ammo;
end;

local function ReverseScope(p120) -- Line: 819
    -- upvalues: u1 (copy)
    local v121 = p120.Animators.Scope and "Scope" or "ScopeIdle";
    local v122 = p120.Animators[v121];

    if v122 and (v121 ~= p120.CurrentAnimationName or not v122.Playing) then
        v122.Track.Alpha = 1;
    end;

    p120.AnimationPendingScope = nil;
    p120.AnimationPendingUnscope = nil;
    u1.ReverseAnimation(p120, v121);
end;

local function PlayScope(p123) -- Line: 832
    -- upvalues: u1 (copy)
    local v124 = p123.Animators.Scope and "Scope" or "ScopeIdle";
    local v125 = p123.Animators[v124];
    p123.AnimationPendingScope = nil;
    p123.AnimationPendingUnscope = nil;

    if p123.CurrentAnimationName ~= v124 or not (v125 and v125.Playing) then
        u1.PlayAnimation(p123, v124);
    end;
end;

function u1.SetSilencerTransparency(p126: any, p127: number) -- Line: 861
    local v128 = p126.CurrentWeaponModel and p126.SilencerPart;

    if v128 then
        v128.Transparency = p126.HiddenApplied and 1 or p127;
    end;
end;

function u1.SetOffhandTransparency(p129: any, p130: number) -- Line: 891
    -- upvalues: u1 (copy)
    local CurrentWeaponModel = p129.CurrentWeaponModel;
    local v131 = p129.Model and p129.Model:FindFirstChild("LeftHand");

    if not (CurrentWeaponModel and v131) then
        return;
    end;

    for _, v in CurrentWeaponModel:QueryDescendants("Motor6D") do
        local Part1 = v.Part1;

        if Part1 and v.Part0 == v131 then
            u1.SetTransparency(Part1, p130);
        end;
    end;
end;

local function SilencerAnimation(p132: any, p133: boolean) -- Line: 908
    local Animators = p132.Animators;

    if p133 then
        return Animators.SilencerOff and "SilencerOff";
    end;

    return Animators.SilencerOn and "SilencerOn" or (Animators.SilencerON and "SilencerON" or Animators.Silencer and "Silencer");
end;

function u1.AdoptWeaponState(p134, p135) -- Line: 930
    -- upvalues: u6 (ref)
    local v136 = p135 and (p135.SilencerMode or (p135.Mode or 1)) or 1;
    p134.AnimationWeapon = p135;
    local v137;

    if p135 then
        v137 = p135.Reloading or false;
    else
        v137 = false;
    end;

    p134.AnimationReloading = v137;
    local v138;

    if p135 then
        v138 = p135.Firing or false;
    else
        v138 = false;
    end;

    p134.AnimationFiring = v138;
    p134.AnimationMode = v136;
    local v139;

    if p135 then
        local AltFunction = (p135.Data or u6.Get(p135.Name).Data).AltFunction;
        v139 = AltFunction and (AltFunction.Name == "Scope" and (p135.ZoomLevel or 0) > 0 or AltFunction.Name == "ScopeRifle" and p135.Mode == 2) and true or false or false;
    else
        v139 = false;
    end;

    p134.AnimationScoped = v139;

    if p135 then
        p135 = p135.Data and p135.Data.Ammo or p135.Ammo;
    end;

    p134.AnimationAmmo = p135;
    p134.AnimationPendingScope = nil;
    p134.AnimationPendingUnscope = nil;
end;

function u1.SyncWeaponAnimation(p140, p141) -- Line: 946
    -- upvalues: u1 (copy), u6 (ref), u4 (ref), FireAnimation (copy)
    if not p140.Animators then
        return;
    end;

    if p140.AnimationResync then
        p140.AnimationResync = nil;
        u1.AdoptWeaponState(p140, p141);

        return;
    end;

    if p140.AnimationWeapon ~= p141 then
        local v142 = p141 and (p141.SilencerMode or (p141.Mode or 1)) or 1;
        local AnimationWeapon = p140.AnimationWeapon;
        local FogCulled = p140.FogCulled;

        if FogCulled then
            AnimationWeapon = FogCulled;
        elseif AnimationWeapon then
            if p141 then
                if AnimationWeapon.Name == p141.Name then
                    AnimationWeapon = AnimationWeapon.Skin == p141.Skin;
                else
                    AnimationWeapon = false;
                end;
            else
                AnimationWeapon = p141;
            end;
        end;

        u1.AdoptWeaponState(p140, p141);

        if p141 then
            local AltFunction = (p141.Data or u6.Get(p141.Name).Data).AltFunction;

            if AltFunction then
                AltFunction = AltFunction.Name == "Silencer";
            end;

            if AltFunction and (v142 == 3 or v142 == 4) then
                local Animators = p140.Animators;
                local v143;

                if v142 == 3 then
                    v143 = Animators.SilencerOff and "SilencerOff";
                else
                    v143 = Animators.SilencerOn and "SilencerOn" or (Animators.SilencerON and "SilencerON" or Animators.Silencer and "Silencer");
                end;

                u1.PlayAnimation(p140, v143);

                return;
            end;

            if p141.Firing and p140.Animators.Plant then
                u1.PlayAnimation(p140, "Plant");
                p140.Animators.Plant.Track.Alpha = p140.AnimationAlpha or 0;

                return;
            end;

            if not AnimationWeapon then
                u1.PlayAnimation(p140, u4.PickVariant(p140.Animators, "Equip"));
            end;
        end;

        return;
    end;

    if not p141 then
        return;
    end;

    local AltFunction = (p141.Data or u6.Get(p141.Name).Data).AltFunction;
    local v144 = AltFunction and (AltFunction.Name == "Scope" and (p141.ZoomLevel or 0) > 0 or AltFunction.Name == "ScopeRifle" and p141.Mode == 2) and true or false;
    local v145 = v144 ~= p140.AnimationScoped;
    local v146 = p141.SilencerMode or (p141.Mode or 1);
    local v147 = v146 ~= p140.AnimationMode;
    local v148 = v146 == 3 and true or v146 == 4;
    local v149 = p140.AnimationMode == 3 and true or p140.AnimationMode == 4;
    local v150 = p141.Data and p141.Data.Ammo or p141.Ammo;
    local v151;

    if v150 == nil or p140.AnimationAmmo == nil then
        v151 = false;
    else
        v151 = v150 < p140.AnimationAmmo;
    end;

    if not v151 then
        v151 = p141.Firing and not p140.AnimationFiring;
    end;

    local v152;

    if v147 then
        v152 = (p141.Data or u6.Get(p141.Name).Data).AltFunction;

        if v152 then
            v152 = v152.Name == "Silencer";
        end;
    else
        v152 = false;
    end;

    if v147 and v152 then
        if v148 then
            local Animators = p140.Animators;
            local v153;

            if v146 == 3 then
                v153 = Animators.SilencerOff and "SilencerOff";
            else
                v153 = Animators.SilencerOn and "SilencerOn" or (Animators.SilencerON and "SilencerON" or Animators.Silencer and "Silencer");
            end;

            u1.PlayAnimation(p140, v153);
        elseif not v149 then
            local Animators = p140.Animators;
            local v154;

            if v146 == 2 then
                v154 = Animators.SilencerOff and "SilencerOff";
            else
                v154 = Animators.SilencerOn and "SilencerOn" or (Animators.SilencerON and "SilencerON" or Animators.Silencer and "Silencer");
            end;

            u1.PlayAnimation(p140, v154);
        end;
    elseif v151 then
        if v145 then
            p140.AnimationPendingScope = v144 or nil;
            p140.AnimationPendingUnscope = not v144 or nil;
        end;

        local v155 = FireAnimation(p140, p141);
        local v156;

        if p141.Name == "Dual Berettas" then
            v156 = p140.Animators[v155 == "Fire1" and "Fire2" or "Fire1"];
        else
            v156 = false;
        end;

        local v157 = p140.Animators[v155];

        if v156 and not v156.Playing then
            v156 = nil;
        end;

        if v157 and p141.Name == "Dual Berettas" then
            v157.Track.Priority = v156 and (v156.Track.Priority + 1 or 1) or 1;
            v157.Track.StartFadeTime = v156 and 0.05 or 0;
        end;

        u1.PlayAnimation(p140, v155, v156);
        local v158;

        if p141.Name == "Dual Berettas" then
            v158 = p140.Animators.Idle;
        else
            v158 = false;
        end;

        if v158 then
            v158.Track.Priority = 0;
            v158:Play();
        end;
    elseif p140.AnimationFiring and (not p141.Firing and p140.CurrentAnimationName == "Plant") then
        u1.PlayAnimation(p140, "Idle");
    elseif p141.Reloading and not p140.AnimationReloading then
        u1.PlayAnimation(p140, "Reload");
    elseif v145 then
        if v144 then
            p140.AnimationPendingUnscope = nil;
            local CurrentAnimationName = p140.CurrentAnimationName;
            local v159;

            if CurrentAnimationName then
                v159 = p140.Animators[CurrentAnimationName];
            else
                v159 = CurrentAnimationName;
            end;

            local v160 = v159 and v159.Playing and string.find(CurrentAnimationName, "Fire", 1, true) == 1;

            if v160 then
                p140.AnimationPendingScope = true;
            else
                local v161 = p140.Animators.Scope and "Scope" or "ScopeIdle";
                local v162 = p140.Animators[v161];
                p140.AnimationPendingScope = nil;
                p140.AnimationPendingUnscope = nil;

                if p140.CurrentAnimationName ~= v161 or not (v162 and v162.Playing) then
                    u1.PlayAnimation(p140, v161);
                end;
            end;
        else
            p140.AnimationPendingScope = nil;
            local v163 = p140.Animators.Scope and "Scope" or "ScopeIdle";
            local v164 = p140.Animators[v163];

            if v164 and (v163 ~= p140.CurrentAnimationName or not v164.Playing) then
                v164.Track.Alpha = 1;
            end;

            p140.AnimationPendingScope = nil;
            p140.AnimationPendingUnscope = nil;
            u1.ReverseAnimation(p140, v163);
        end;
    end;

    p140.AnimationScoped = v144;
    p140.AnimationAmmo = v150;
    p140.AnimationReloading = p141.Reloading or false;
    p140.AnimationFiring = p141.Firing or false;
    p140.AnimationMode = v146;
end;

function u1.EquipWeapon(p165, p166) -- Line: 1103
    -- upvalues: u1 (copy), u6 (ref)
    local CurrentWeaponModel = p165.CurrentWeaponModel;

    if CurrentWeaponModel and (CurrentWeaponModel.Parent == p165.Model and (p165.Rig and (p165.Rig == p165.EquippedWeaponRig and (p165.EquippedWeaponName == p166.Name and p165.EquippedWeaponSkin == p166.Skin)))) then
        u1.SyncWeaponAnimation(p165, p166);

        return;
    end;

    u1.DestroyAnimations(p165);
    p165.SilencerPart = nil;

    if p165.CurrentWeaponModel then
        p165.CurrentWeaponModel:Destroy();
        p165.CurrentWeaponModel = nil;
    end;

    local CharacterModel = u6.Get(p166.Name).Assets.CharacterModel;

    if CharacterModel then
        CharacterModel = CharacterModel:Clone();

        for _, v in CharacterModel:QueryDescendants("BasePart") do
            v.CanQuery = false;
        end;

        u1.ApplyWeaponSkin(CharacterModel, p166.Name, p166.Skin, nil, true);

        if p166.Name == "Bomb" then
            u1.SetBombDisplay(CharacterModel, 0);
        end;
    end;

    if CharacterModel then
        local HandleMotor = CharacterModel:FindFirstChild("HandleMotor");

        if HandleMotor then
            if p165 and (next(p165) and p165.Model) then
                local RightHand = p165.Model:FindFirstChild("RightHand");

                if RightHand and CharacterModel.PrimaryPart then
                    HandleMotor.Part0 = RightHand;
                    HandleMotor.Part1 = CharacterModel.PrimaryPart;
                end;

                p165.CurrentWeaponModel = CharacterModel;
                CharacterModel.Parent = p165.Model;
            end;
        else
            local HandleMotor1 = CharacterModel:FindFirstChild("HandleMotor1");
            local HandleMotor2 = CharacterModel:FindFirstChild("HandleMotor2");

            if HandleMotor1 and (HandleMotor2 and (p165 and (next(p165) and p165.Model))) then
                local RightHand = p165.Model:FindFirstChild("RightHand");

                if RightHand then
                    HandleMotor1.Part0 = RightHand;
                    HandleMotor1.Part1 = CharacterModel.PrimaryPart;
                end;

                local LeftHand = p165.Model:FindFirstChild("LeftHand");

                if LeftHand then
                    HandleMotor2.Part0 = LeftHand;
                    HandleMotor2.Part1 = CharacterModel[CharacterModel.PrimaryPart.Name .. "1"];
                end;

                p165.CurrentWeaponModel = CharacterModel;
                CharacterModel.Parent = p165.Model;
            else
                local HandleMotorLeft = CharacterModel:FindFirstChild("HandleMotorLeft");

                if HandleMotorLeft and (p165 and (next(p165) and p165.Model)) then
                    local LeftHand = p165.Model:FindFirstChild("LeftHand");

                    if LeftHand then
                        HandleMotorLeft.Part0 = LeftHand;
                        HandleMotorLeft.Part1 = CharacterModel.PrimaryPart;
                    end;

                    p165.CurrentWeaponModel = CharacterModel;
                    CharacterModel.Parent = p165.Model;
                end;
            end;
        end;
    end;

    if p165.HiddenApplied and p165.CurrentWeaponModel then
        u1.SetTransparency(p165.CurrentWeaponModel, 1);
    end;

    local v167 = p165.CurrentWeaponModel and p165.CurrentWeaponModel:FindFirstChild("Silencer", true);

    if not (v167 and (v167:IsA("BasePart") and v167)) then
        v167 = nil;
    end;

    p165.SilencerPart = v167;

    if p165.Defusing then
        u1.SetOffhandTransparency(p165, 1);
    end;

    u1.InitAnimations(p165, p165.Model, p166.Name);
    local Skin = p166.Skin;
    p165.EquippedWeaponName = p166.Name;
    p165.EquippedWeaponSkin = Skin;
    p165.EquippedWeaponRig = p165.Rig;
    u1.SyncWeaponAnimation(p165, p166);
end;

local function ConfigureSpring(p168: userdata, p169: userdata, p170: userdata, p171: boolean?) -- Line: 1244
    if p168.Attachment0 ~= p169 then
        p168.Attachment0 = p169;
    end;

    if p168.Attachment1 ~= p170 then
        p168.Attachment1 = p170;
    end;

    if p168.Coils ~= 20 then
        p168.Coils = 20;
    end;

    if p168.Radius ~= 0.1 then
        p168.Radius = 0.1;
    end;

    if p168.Thickness ~= 0.025 then
        p168.Thickness = 0.025;
    end;

    local v172 = p171 == nil and true or p171;

    if p168.Visible ~= v172 then
        p168.Visible = v172;
    end;

    if not p168.Enabled then
        p168.Enabled = true;
    end;
end;

local function UpdateDefuseSprings(p173: userdata, p174: userdata, p175: boolean?) -- Line: 1269
    -- upvalues: ConfigureSpring (copy)
    local Attachment1 = p173:FindFirstChild("Attachment1", true);
    local Attachment2 = p173:FindFirstChild("Attachment2", true);
    local v176 = Attachment1 and Attachment1:FindFirstChildWhichIsA("SpringConstraint") or (p173:FindFirstChild("SpringConstraint1", true) or p173:FindFirstChild("SpringConstraint", true));
    local v177 = Attachment2 and Attachment2:FindFirstChildWhichIsA("SpringConstraint") or p173:FindFirstChild("SpringConstraint2", true);
    local Attachment12 = p174:FindFirstChild("Attachment1", true);
    local Attachment22 = p174:FindFirstChild("Attachment2", true);
    local v178 = p174:FindFirstChild("Handle") or p174:FindFirstChildWhichIsA("BasePart", true);

    if v178 then
        if Attachment12 and Attachment12.Parent:IsA("Model") then
            Attachment12.Parent = v178;
        end;

        if Attachment22 and Attachment22.Parent:IsA("Model") then
            Attachment22.Parent = v178;
        end;
    end;

    local v179 = p175 == nil and true or p175;

    if v176 and (Attachment1 and (Attachment12 and (Attachment1:IsA("Attachment") and Attachment12:IsA("Attachment")))) then
        ConfigureSpring(v176, Attachment1, Attachment12, v179);
    end;

    if v177 and (Attachment2 and (Attachment22 and (Attachment2:IsA("Attachment") and Attachment22:IsA("Attachment")))) then
        ConfigureSpring(v177, Attachment2, Attachment22, v179);
    end;
end;

function u1.SetDefusing(p180: any, p181: boolean, p182: userdata?) -- Line: 1303
    -- upvalues: u1 (copy), Multimeter (copy), UpdateDefuseSprings (copy)
    if (p180.Defusing or false) == p181 then
        return;
    end;

    p180.Defusing = p181;

    if not p181 then
        if p180.DefuseModel then
            p180.DefuseModel:Destroy();
            p180.DefuseModel = nil;
        end;

        p180.DefuseBombModel = nil;
        u1.SetOffhandTransparency(p180, p180.HiddenApplied and 1 or 0);
        local AnimationWeapon = p180.AnimationWeapon;
        local v183;

        if AnimationWeapon then
            v183 = AnimationWeapon.Name;
        else
            v183 = AnimationWeapon;
        end;

        u1.InitAnimations(p180, p180.Model, v183);

        if AnimationWeapon then
            p180.AnimationWeapon = nil;
            u1.SyncWeaponAnimation(p180, AnimationWeapon);
        end;

        return;
    end;

    local v184 = Multimeter:Clone();
    v184.Name = "Handle";
    v184.CanQuery = false;
    v184.Transparency = p180.HiddenApplied and 1 or 0;
    v184.Handle.Part0 = p180.Model:FindFirstChild("LeftHand");
    v184.Parent = p180.Model;
    p180.DefuseModel = v184;
    p180.DefuseBombModel = p182;
    u1.SetOffhandTransparency(p180, 1);
    local v185 = not p180.HiddenApplied;

    for _, v in v184:QueryDescendants("SpringConstraint") do
        v.Visible = v185;
    end;

    if p182 then
        UpdateDefuseSprings(v184, p182, v185);
    end;

    u1.InitAnimations(p180, p180.Model, "Defuse");

    for i in p180.LimbMotors do
        if p180.CurrentWeaponModel and i:IsDescendantOf(p180.CurrentWeaponModel) then
            p180.LimbMotors[i] = nil;
            p180.AnimationPoseCache[i] = nil;
            i.Transform = CFrame.identity;
        end;
    end;

    u1.PlayAnimation(p180, "Defuse");
    local v186 = p180.Animators and p180.Animators.Defuse;

    if v186 then
        v186.Looped = true;
    end;
end;

function u1.ApplyWeaponSkin(p187: userdata, p188: string, p189: string, p190: any, p191: boolean) -- Line: 1382
    -- upvalues: u7 (ref)
    local WeaponSkin = u7.GetWeaponSkin(p188, p189);

    if not WeaponSkin then
        return;
    end;

    if WeaponSkin.WorldModel and p191 then
        for i, v in WeaponSkin.WorldModel do
            local v192 = p187:FindFirstChild(i);

            if v192 and v192:IsA("MeshPart") then
                v192.TextureID = v.Value;
            end;
        end;

        return;
    end;

    if not WeaponSkin.Assets then
        return;
    end;

    for i, v in WeaponSkin.Assets do
        local v193 = p187:FindFirstChild(i);

        if v193 and v193:IsA("MeshPart") then
            for _, child in v193:GetChildren() do
                if child:IsA("SurfaceAppearance") then
                    child:Destroy();
                end;
            end;

            local v194 = v:Clone();

            if p190 then
                v194.EmissiveTint = p190.Tint;
                v194.EmissiveStrength = p190.Strength;
            end;

            v194.Parent = v193;
        end;
    end;
end;

function u1.ChaseAnimationAlpha(p195: any, p196: number) -- Line: 1460
    local v197 = p195.Animators and p195.Animators[p195.CurrentAnimationName];

    if not (v197 and (v197.Looped and (p195.AnimationAlpha and not p195.Defusing))) then
        return;
    end;

    local Track = v197.Track;
    Track.Alpha = (Track.Alpha + ((p195.AnimationAlpha - Track.Alpha + 0.5) % 1 - 0.5) * math.min(p196 * 30, 1)) % 1;
end;

function u1.UpdateAnimation(p198) -- Line: 1480
    -- upvalues: u1 (copy), u4 (ref), u2 (copy), UpdateDefuseSprings (copy)
    if p198.SilencerPart then
        u1.SetSilencerTransparency(p198, p198.AnimationMode == 2 and 1 or 0);
    end;

    local Rig = p198.Rig;

    if not Rig then
        return;
    end;

    local v199 = p198.Animators[p198.CurrentAnimationName];

    if p198.AnimationPendingUnscope and not (v199 and v199.Playing) then
        local v200 = p198.Animators.Scope and "Scope" or "ScopeIdle";
        local v201 = p198.Animators[v200];

        if v201 and (v200 ~= p198.CurrentAnimationName or not v201.Playing) then
            v201.Track.Alpha = 1;
        end;

        p198.AnimationPendingScope = nil;
        p198.AnimationPendingUnscope = nil;
        u1.ReverseAnimation(p198, v200);
    elseif p198.AnimationPendingScope and not (v199 and v199.Playing) then
        local v202 = p198.Animators.Scope and "Scope" or "ScopeIdle";
        local v203 = p198.Animators[v202];
        p198.AnimationPendingScope = nil;
        p198.AnimationPendingUnscope = nil;

        if p198.CurrentAnimationName ~= v202 or not (v203 and v203.Playing) then
            u1.PlayAnimation(p198, v202);
        end;
    elseif p198.AnimationScoped and (v199 and not (v199.Playing or (p198.CurrentAnimationName == "ScopeIdle" or not p198.Animators.ScopeIdle))) then
        u1.PlayAnimation(p198, "ScopeIdle");
    end;

    local Idle = p198.Animators.Idle;

    if Idle and (not Idle.Playing or p198.CurrentAnimationName ~= "Idle") then
        local v204 = false;

        for i, v in p198.Animators do
            if i ~= "Idle" and v.Playing then
                v204 = true;
                break;
            end;
        end;

        if not v204 then
            p198.CurrentAnimationName = "Idle";
            Idle:Play();
        end;
    end;

    local v205, v206 = u4.Solve(Rig, p198.Animators, u2);

    if not v205 then
        return;
    end;

    if u2 and not (v206 or p198.AnimationWritesInvalid) then
        if not p198.AnimationTransforms then
            local AnimationPoseCache = p198.AnimationPoseCache;

            for i in p198.LimbMotors do
                AnimationPoseCache[i] = i.Transform;
            end;

            p198.AnimationTransforms = AnimationPoseCache;
        end;
    else
        p198.AnimationTransforms = nil;

        for i, v in p198.LimbMotors do
            local position = v.position;
            local quat_vector = v.quat_vector;
            i.Transform = CFrame.new(position.x, position.y, position.z, quat_vector.x, quat_vector.y, quat_vector.z, v.quat_scalar);
        end;

        p198.AnimationWritesInvalid = false;
    end;

    if p198.Defusing and (p198.DefuseModel and p198.DefuseBombModel) then
        UpdateDefuseSprings(p198.DefuseModel, p198.DefuseBombModel, not p198.HiddenApplied);
    end;
end;

function u1.DestroyAnimations(p207) -- Line: 1568
    -- upvalues: u4 (ref), ResetAnimationPose (copy), u66 (copy)
    for _, v in p207.Animators or {} do
        u4.Remove(v);
    end;

    ResetAnimationPose(p207);

    if p207.Model then
        u66[p207.Model] = nil;
    end;

    p207.AnimationTransforms = nil;
    p207.AnimationPoseCache = nil;
    p207.AnimationWritesInvalid = nil;
    p207.Animators = nil;
    p207.LimbMotors = nil;
    p207.Rig = nil;
    p207.CurrentAnimationName = nil;
    p207.DefuseBombModel = nil;
end;

local u208 = setmetatable({}, {
    __mode = "k"
});
local table_freeze_ret3 = table.freeze({});
local u209 = setmetatable({}, {
    __mode = "k"
});

local function GetMotors(p210: userdata) -- Line: 1622
    -- upvalues: u208 (copy)
    local v211 = u208[p210];

    if not v211 then
        v211 = {};

        for _, descendant in p210:GetDescendants() do
            if descendant:IsA("Motor6D") then
                table.insert(v211, descendant);
            end;
        end;

        u208[p210] = v211;
    end;

    return v211;
end;

function u1.CapturePose(p212: userdata, p213: table?) -- Line: 1665
    -- upvalues: GetMotors (copy)
    local v214 = GetMotors(p212);
    local v215 = #v214 * 2;
    local v216 = p213 or table.create(v215);

    for i, v in v214 do
        v216[i * 2 - 1] = v.C0;
        v216[i * 2] = v.Transform;
    end;

    for i = v215 + 1, #v216 do
        v216[i] = nil;
        local _ = i;
    end;

    return v216;
end;

function u1.ApplyPose(p217: userdata, p218: table) -- Line: 1682
    -- upvalues: GetMotors (copy), u66 (copy)
    local v219 = GetMotors(p217);

    if #p218 ~= #v219 * 2 then
        return;
    end;

    local v220 = u66[p217];

    if v220 then
        v220.AnimationTransforms = nil;
        table.clear(v220.AnimationPoseCache);
        v220.AnimationWritesInvalid = true;
    end;

    for i, v in v219 do
        v.C0 = p218[i * 2 - 1];
        v.Transform = p218[i * 2];
    end;
end;

function u1.ApplyPoseInterpolated(p221: userdata, p222: table, p223: table, p224: number) -- Line: 1716
    -- upvalues: GetMotors (copy), u66 (copy), u209 (copy), table_freeze_ret3 (copy)
    local v225 = GetMotors(p221);
    local v226 = #v225 * 2;

    if #p222 ~= v226 or #p223 ~= v226 then
        return;
    end;

    local v227 = u66[p221];

    if v227 then
        v227.AnimationTransforms = nil;
        table.clear(v227.AnimationPoseCache);
        v227.AnimationWritesInvalid = true;
    end;

    local v228 = u209[p221];

    if not v228 then
        v228 = table.create(#v225);

        for i, v in v225 do
            v228[i] = not table_freeze_ret3[v.Name];
        end;

        u209[p221] = v228;
    end;

    local v229 = p224 >= 0.5 and p223 and p223 or p222;

    for i, v in v225 do
        local v230 = i * 2 - 1;

        if v228[i] then
            v.C0 = p222[v230]:Lerp(p223[v230], p224);
            v.Transform = p222[v230 + 1]:Lerp(p223[v230 + 1], p224);
        else
            v.C0 = v229[v230];
            v.Transform = v229[v230 + 1];
        end;
    end;
end;

local table_freeze_ret4 = table.freeze({ "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot" });
u1.HitboxParts = table_freeze_ret4;
local u231 = setmetatable({}, {
    __mode = "k"
});
local u232 = setmetatable({}, {
    __mode = "k"
});

function u1.GetHitboxParts(p233: userdata) -- Line: 1805
    -- upvalues: u231 (copy), table_freeze_ret4 (copy)
    local v234 = u231[p233];

    if not v234 then
        v234 = table.create(#table_freeze_ret4);

        for i, v in table_freeze_ret4 do
            local v235 = p233:FindFirstChild(v);

            if not (v235 and (v235:IsA("BasePart") and v235)) then
                v235 = nil;
            end;

            v234[i] = v235;
        end;

        u231[p233] = v234;
    end;

    return v234;
end;

local u236 = setmetatable({}, {
    __mode = "k"
});
local table_freeze_ret5 = table.freeze({
    UpperTorso = 1,
    Head = 2,
    LeftUpperArm = 3,
    RightUpperArm = 4
});

function u1.GetHitboxJoints(p237: userdata) -- Line: 1839
    -- upvalues: u1 (copy), u236 (copy), table_freeze_ret4 (copy), table_freeze_ret5 (copy)
    local HitboxParts = u1.GetHitboxParts(p237);
    local v238 = u236[p237];

    if v238 and v238.Parts == HitboxParts then
        return v238;
    end;

    local v239 = {};

    for i = 1, #table_freeze_ret4 do
        local v240;

        if HitboxParts[i] then
            v239[HitboxParts[i]] = i;
            v240 = i;
        else
            v240 = i;
        end;
    end;

    local u241 = {
        Parts = HitboxParts,
        Parent = {},
        Motor = {},
        Order = {},
        Posed = {}
    };

    for i, v in table_freeze_ret4 do
        u241.Posed[i] = table_freeze_ret5[v];
    end;

    for _, descendant in p237:GetDescendants() do
        local v242 = descendant:IsA("Motor6D") and v239[descendant.Part1];

        if v242 then
            u241.Motor[v242] = descendant;
            u241.Parent[v242] = v239[descendant.Part0] or 0;
        end;
    end;

    local u243 = {};

    local function Place(p244) -- Line: 1874
        -- upvalues: u243 (copy), u241 (ref), Place (copy)
        if u243[p244] then
            return;
        end;

        u243[p244] = true;
        local v245 = u241.Parent[p244];

        if v245 and v245 ~= 0 then
            Place(v245);
        end;

        table.insert(u241.Order, p244);
    end;

    for i = 1, #table_freeze_ret4 do
        local v246;

        if HitboxParts[i] then
            if u243[i] then
                v246 = i;
            else
                u243[i] = true;
                local v247 = u241.Parent[i];

                if v247 and v247 ~= 0 then
                    Place(v247);
                end;

                table.insert(u241.Order, i);
                v246 = i;
            end;
        else
            v246 = i;
        end;
    end;

    u236[p237] = u241;

    return u241;
end;

local table_freeze_ret6 = table.freeze({
    Head = Vector3.new(0, 0, 0),
    UpperTorso = Vector3.new(0, 0, 0),
    LowerTorso = Vector3.new(0, 0, 0),
    LeftUpperArm = Vector3.new(0, 0, 0),
    LeftLowerArm = Vector3.new(0, 0, 0),
    LeftHand = Vector3.new(0, 0, 0),
    RightUpperArm = Vector3.new(0, 0, 0),
    RightLowerArm = Vector3.new(0, 0, 0),
    RightHand = Vector3.new(0, 0, 0),
    LeftUpperLeg = Vector3.new(0, 0, 0),
    LeftLowerLeg = Vector3.new(0, 0, 0),
    LeftFoot = Vector3.new(0, 0, 0),
    RightUpperLeg = Vector3.new(0, 0, 0),
    RightLowerLeg = Vector3.new(0, 0, 0),
    RightFoot = Vector3.new(0, 0, 0)
});

function u1.GetHitboxBox(p248: userdata, p249: number, p250: userdata) -- Line: 1938
    -- upvalues: table_freeze_ret6 (copy), table_freeze_ret4 (copy)
    return nil, p250.Size * 0.5 + table_freeze_ret6[table_freeze_ret4[p249]];
end;

local function ReleaseChain(p251) -- Line: 1942
    for _, v in p251.Connections do
        v:Disconnect();
    end;

    table.clear(p251.Connections);
end;

local function BuildChain(u252) -- Line: 1949
    -- upvalues: u231 (copy), u1 (copy), table_freeze_ret4 (copy), u232 (copy)
    local u253 = {
        Root = u252.PrimaryPart,
        Joints = {},
        World = {},
        Connections = {}
    };
    local u254 = {
        [u253.Root] = 0
    };
    local u255 = {};
    local u256 = {};

    for _, descendant in u252:GetDescendants() do
        if descendant:IsA("Motor6D") and (descendant.Part0 and descendant.Part1) then
            u255[descendant.Part1] = descendant;
        end;
    end;

    local function Invalidate() -- Line: 1960
        -- upvalues: u253 (copy), u231 (ref), u252 (copy)
        u253.Stale = true;
        u231[u252] = nil;
    end;

    local function Add(p257) -- Line: 1964
        -- upvalues: u256 (copy), u253 (copy), u255 (copy), Add (copy), u254 (copy), Invalidate (copy)
        if not (p257 and (not u256[p257] and p257 ~= u253.Root)) then
            return;
        end;

        u256[p257] = true;
        local u258 = u255[p257];

        if not u258 then
            return;
        end;

        local Part0 = u258.Part0;
        Add(Part0);
        local v259 = #u253.Joints + 1;
        u254[p257] = v259;
        u253.Joints[v259] = {
            Motor = u258,
            Part = p257,
            ParentIndex = u254[Part0] or -1,
            ParentPart = Part0,
            Inverse = u258.C1:Inverse()
        };
        local u260 = u253.Joints[v259];
        local Connections = u253.Connections;
        local PropertyChangedSignal = u258:GetPropertyChangedSignal("C1");
        table.insert(Connections, PropertyChangedSignal:Connect(function() -- Line: 1978
            -- upvalues: u260 (copy), u258 (copy)
            u260.Inverse = u258.C1:Inverse();
            u260.Frame = nil;
        end));
        local Connections2 = u253.Connections;
        local PropertyChangedSignal2 = u258:GetPropertyChangedSignal("Part0");
        table.insert(Connections2, PropertyChangedSignal2:Connect(Invalidate));
        local Connections3 = u253.Connections;
        local PropertyChangedSignal3 = u258:GetPropertyChangedSignal("Part1");
        table.insert(Connections3, PropertyChangedSignal3:Connect(Invalidate));
    end;

    local HitboxParts = u1.GetHitboxParts(u252);

    for i = 1, #table_freeze_ret4 do
        Add(HitboxParts[i]);
        local _ = i;
    end;

    local function DescendantChanged(p261) -- Line: 1986
        -- upvalues: u253 (copy), u231 (ref), u252 (copy)
        if p261:IsA("Motor6D") or p261:IsA("BasePart") then
            u253.Stale = true;
            u231[u252] = nil;
        end;
    end;

    table.insert(u253.Connections, u252.DescendantAdded:Connect(DescendantChanged));
    table.insert(u253.Connections, u252.DescendantRemoving:Connect(DescendantChanged));
    local Connections = u253.Connections;
    local PropertyChangedSignal = u252:GetPropertyChangedSignal("PrimaryPart");
    table.insert(Connections, PropertyChangedSignal:Connect(Invalidate));
    table.insert(u253.Connections, u252.Destroying:Connect(function() -- Line: 1992
        -- upvalues: u253 (copy), u232 (ref), u252 (copy), u231 (ref)
        local v262 = u253;

        for _, v in v262.Connections do
            v:Disconnect();
        end;

        table.clear(v262.Connections);
        u232[u252] = nil;
        u231[u252] = nil;
    end));

    return u253;
end;

function u1.BuildPoseFrames(p263: userdata, p264, p265: any, p266: any, p267: any) -- Line: 1999
    -- upvalues: u232 (copy), BuildChain (copy)
    local v268 = u232[p263];
    local v269 = v268 and not v268.Stale and v268.Root or p263.PrimaryPart;

    if not v269 then
        if v268 then
            for _, v in v268.Connections do
                v:Disconnect();
            end;

            table.clear(v268.Connections);
            u232[p263] = nil;
        end;

        if p266 then
            table.clear(p266);
        end;

        return p266 or {};
    end;

    if not (v268 and (not v268.Stale and v268.Root == v269)) then
        if v268 then
            for _, v in v268.Connections do
                v:Disconnect();
            end;

            table.clear(v268.Connections);
        end;

        v268 = BuildChain(p263);
        u232[p263] = v268;

        if p266 then
            table.clear(p266);
        end;
    end;

    local v270 = p266 or {};
    v270[v268.Root] = p264;

    if v268.LastRoot ~= p264 then
        v268.LastRoot = p264;

        if p267 then
            for _, v in v268.Joints do
                local Motor = v.Motor;
                local v271 = v270[v.ParentPart] or v.ParentPart.CFrame;
                local v272;

                if p265 then
                    v272 = p265[Motor];
                else
                    v272 = p265;
                end;

                local v273;

                if v272 then
                    v273 = v271 * v272 * v.Inverse;
                else
                    v273 = v271 * Motor.C0 * (p267 and p267[Motor] or Motor.Transform) * v.Inverse;
                end;

                v270[v.Part] = v273;
            end;

            return v270;
        end;

        for _, v in v268.Joints do
            local Motor = v.Motor;
            local v274;

            if p265 then
                v274 = p265[Motor];
            else
                v274 = p265;
            end;

            local v275 = v270[v.ParentPart] or v.ParentPart.CFrame;
            local v276;

            if v274 then
                v276 = v275 * v274 * v.Inverse;
            else
                v276 = v275 * Motor.C0 * Motor.Transform * v.Inverse;
            end;

            v270[v.Part] = v276;
        end;

        return v270;
    end;

    local World = v268.World;
    World[0] = p264;

    for i, v in v268.Joints do
        local Motor = v.Motor;
        local v277;

        if p265 then
            v277 = p265[Motor];
        else
            v277 = p265;
        end;

        local v278 = v277 or Motor.C0;
        local v279;

        if v277 then
            v279 = CFrame.identity;
        else
            v279 = p267 and p267[Motor] or Motor.Transform;
        end;

        local ParentIndex = v.ParentIndex;
        local v280;

        if ParentIndex >= 0 then
            v280 = World[ParentIndex];
        else
            v280 = v.ParentPart.CFrame;
        end;

        local Frame = v.Frame;

        if not (Frame and (v.ParentFrame == v280 and (v.C0 == v278 and (v.Transform == v279 and v.Override == v277)))) then
            if v277 then
                Frame = v280 * v278 * v.Inverse;
            else
                Frame = v280 * v278 * v279 * v.Inverse;
            end;

            v.ParentFrame = v280;
            v.C0 = v278;
            v.Transform = v279;
            v.Override = v277;
            v.Frame = Frame;
        end;

        local Part = v.Part;
        World[i] = Frame;
        v270[Part] = Frame;
    end;

    return v270;
end;

function u1.CaptureHitboxes(p281: userdata, p282: table?, p283: any) -- Line: 2068
    -- upvalues: u1 (copy), table_freeze_ret4 (copy)
    local HitboxParts = u1.GetHitboxParts(p281);
    local v284 = #table_freeze_ret4;
    local v285 = p282 or table.create(v284);

    for i = 1, v284 do
        local v286 = HitboxParts[i];
        local v287;

        if v286 then
            v287 = p283 and p283[v286] or (v286.CFrame or nil);
        else
            v287 = nil;
        end;

        v285[i] = v287;
        local _ = i;
    end;

    return v285;
end;

function u1.new(p288) -- Line: 2088
    -- upvalues: RigTemplate (copy), ApplyAgent (copy), ApplyGloves (copy), u1 (copy)
    local v289 = RigTemplate:Clone();

    if not p288 then
        v289.Parent = workspace;

        return v289;
    end;

    local Agent = p288.Agent;

    if Agent then
        ApplyAgent(v289, Agent);
    end;

    local Gloves = p288.Gloves;

    if Gloves then
        ApplyGloves(v289, Gloves.WeaponName, Gloves.SkinName);
    end;

    local Weapon = p288.Weapon;

    if Weapon then
        u1.AddWeapon(v289, Weapon.WeaponName, Weapon.SkinName);
    end;

    v289.Name = p288.Name or "Character";
    v289:PivotTo(p288.CFrame or CFrame.identity);
    v289.Parent = p288.Parent or workspace;

    return v289;
end;

function u1.AddAccessory(p290: any, p291: userdata) -- Line: 2125
    local v292 = p291:FindFirstChildWhichIsA("Attachment", true);

    if not v292 then
        warn("No attachments found in accessory. Accessory was not attached.");

        return;
    end;

    local v293 = nil;
    local Attribute = p291:GetAttribute("Part");

    if Attribute then
        local v294 = p290:FindFirstChild(Attribute);

        if v294 then
            v293 = v294:FindFirstChild(v292.Name);
        end;
    end;

    local v295 = v293 or p290:FindFirstChild(v292.Name, true);

    if not (v295 and v295:IsA("Attachment")) then
        warn(string.format("No attachment named %s found in character. Accessory was not attached.", v292.Name));

        return;
    end;

    local Handle = p291:FindFirstChild("Handle");

    if not Handle then
        warn("Attachment has no handle. Accessory was not attached.");

        return;
    end;

    local v296 = Handle:FindFirstChildOfClass("Weld");

    if v296 then
        v296:Destroy();
    end;

    local v297 = v295.WorldCFrame * v292.CFrame:Inverse() * Handle.CFrame:Inverse();
    local RigidConstraint = Instance.new("RigidConstraint");
    RigidConstraint.Attachment0 = v295;
    RigidConstraint.Attachment1 = v292;
    RigidConstraint.Parent = Handle;

    for _, v in p291:QueryDescendants("BasePart") do
        v.CFrame = v297 * v.CFrame;
        v.CanQuery = false;
    end;

    p291.Parent = p290.Accessories;
end;

function u1.AddShirt(p298: any, p299: number) -- Line: 2188
    -- upvalues: table_freeze_ret (copy)
    for i, _ in table_freeze_ret.Shirt do
        local v300 = p298:FindFirstChild(i);

        if v300 then
            v300.TextureID = p299;
        end;
    end;
end;

function u1.AddPants(p301: any, p302: number) -- Line: 2200
    -- upvalues: table_freeze_ret (copy)
    for i, v in table_freeze_ret.Pants do
        if v then
            local v303 = p301:FindFirstChild(i);

            if v303 then
                v303.TextureID = p302;
            end;
        end;
    end;
end;

function u1.SetObjectTransparency(p304: userdata, p305: number) -- Line: 2246
    if p304:IsA("BasePart") then
        if p304.Name == "HumanoidRootPart" or p304.Name == "CollisionBox" then
            return;
        end;
    elseif not p304:IsA("Decal") then
        local v306 = p305 == 0;

        if p304:IsA("BillboardGui") then
            p304.Enabled = v306;
            p304.Active = v306;

            return;
        end;

        if p304:IsA("SurfaceGui") or p304:IsA("Beam") then
            p304.Enabled = v306;

            return;
        end;

        if p304:IsA("SpringConstraint") then
            p304.Visible = v306;
        end;

        return;
    end;

    if p305 ~= 0 then
        if p304:GetAttribute("AuthoredTransparency") == nil then
            p304:SetAttribute("AuthoredTransparency", p304.Transparency);
        end;

        p304.Transparency = p305;

        return;
    end;

    local Attribute = p304:GetAttribute("AuthoredTransparency");

    if Attribute == nil then
        return;
    end;

    p304.Transparency = Attribute;
    p304:SetAttribute("AuthoredTransparency", nil);
end;

function u1.SetTransparency(p307: any, p308: number) -- Line: 2293
    -- upvalues: u1 (copy)
    u1.SetObjectTransparency(p307, p308);

    for _, v in p307:QueryDescendants("BasePart, Decal, BillboardGui, SurfaceGui, Beam, SpringConstraint") do
        u1.SetObjectTransparency(v, p308);
    end;
end;

function u1.Init(p309) -- Line: 2303
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref)
    u3 = p309:GetModule("ItemManager");
    u4 = p309:GetModule("AnimationManager");
    u5 = p309:GetModule("Math");
    u6 = p309:GetModule("WeaponManager");
    u7 = p309:GetModule("SkinManager");
end;

return u1;