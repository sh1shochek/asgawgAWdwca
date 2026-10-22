-- ReplicatedStorage.Cutscenes.TutorialIntro.IntroPlayer
-- Script path: ReplicatedStorage.Cutscenes.TutorialIntro.IntroPlayer
-- Decompile time: 12.09 ms

-- Decompiled with Potassium's decompiler.

local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider");
local u1 = {};
u1.__index = u1;

local function cframeOf(p2: table) -- Line: 57
    return CFrame.new(p2[1], p2[2], p2[3], p2[4], p2[5], p2[6], p2[7], p2[8], p2[9], p2[10], p2[11], p2[12]);
end;

local function sampleTrack(p3: table, p4: number, p5: number) -- Line: 61
    -- upvalues: cframeOf (copy)
    local math_max_ret = math.max(0, p4 * p5);
    local math_floor_ret = math.floor(math_max_ret);
    local v6 = #p3;

    if v6 - 1 <= math_floor_ret then
        return cframeOf(p3[v6]);
    end;

    local v7 = p3[math_floor_ret + 1];
    local CFrame_new_ret = CFrame.new(v7[1], v7[2], v7[3], v7[4], v7[5], v7[6], v7[7], v7[8], v7[9], v7[10], v7[11], v7[12]);
    local v8 = p3[math_floor_ret + 2];

    return CFrame_new_ret:Lerp(CFrame.new(v8[1], v8[2], v8[3], v8[4], v8[5], v8[6], v8[7], v8[8], v8[9], v8[10], v8[11], v8[12]), math_max_ret - math_floor_ret);
end;

local function sampleNumber(p9: table, p10: number, p11: number) -- Line: 73
    local math_max_ret = math.max(0, p10 * p11);
    local math_floor_ret = math.floor(math_max_ret);
    local v12 = #p9;

    if v12 - 1 <= math_floor_ret then
        return p9[v12];
    end;

    return p9[math_floor_ret + 1] + (p9[math_floor_ret + 2] - p9[math_floor_ret + 1]) * (math_max_ret - math_floor_ret);
end;

local function smoother(p13: number) -- Line: 83
    local math_clamp_ret = math.clamp(p13, 0, 1);

    return math_clamp_ret * math_clamp_ret * math_clamp_ret * (math_clamp_ret * (math_clamp_ret * 6 - 15) + 10);
end;

local function window(p14: number, p15: table?) -- Line: 88
    if not p15 then
        return 0;
    end;

    local math_clamp_ret = math.clamp((p14 - p15[1]) / (p15[2] - p15[1]), 0, 1);

    return math_clamp_ret * math_clamp_ret * math_clamp_ret * (math_clamp_ret * (math_clamp_ret * 6 - 15) + 10);
end;

local function buildActor(p16: any, p17: string, p18: any) -- Line: 95
    -- upvalues: KeyframeSequenceProvider (copy)
    local Options = p16.Options;
    local v19 = Options.CharacterTemplate:Clone();
    v19.Name = "Intro_" .. p17;

    for _, descendant in v19:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
        elseif descendant:IsA("Sound") then
            descendant:Destroy();
        end;
    end;

    local UpperTorso = v19:FindFirstChild("UpperTorso");

    if UpperTorso then
        UpperTorso = UpperTorso:FindFirstChild("Head");
    end;

    if UpperTorso and UpperTorso:IsA("Motor6D") then
        UpperTorso:Destroy();
    end;

    local HumanoidRootPart = v19:FindFirstChild("HumanoidRootPart");
    HumanoidRootPart.Anchored = true;

    if Options.HeadMeshScale then
        local Head = v19:FindFirstChild("Head");

        if Head then
            Head = Head:FindFirstChildOfClass("SpecialMesh");
        end;

        if Head then
            Head.Scale = Vector3.new(1, 1, 1) * Options.HeadMeshScale;
        end;
    end;

    local AnimationController = Instance.new("AnimationController");
    AnimationController.Parent = v19;
    local Animator = Instance.new("Animator");
    Animator.Parent = AnimationController;
    local v20 = Options.WeaponTemplate:Clone();
    v20.Name = "AK-47";
    local Weapon = v20:FindFirstChild("Weapon");

    if Weapon then
        for _, v in { "Hitbox", "Insert" } do
            local v21 = Weapon:FindFirstChild(v);

            if v21 then
                v21:Destroy();
            end;
        end;
    end;

    for _, descendant in v20:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
        elseif descendant:IsA("Sound") or descendant:IsA("Light") then
            descendant:Destroy();
        end;
    end;

    v20.Parent = v19;
    local WeaponHold = p18.WeaponHold;
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = WeaponHold.MotorName;
    Motor6D.Part0 = v19:FindFirstChild(WeaponHold.Part0);

    if Weapon then
        Weapon = Weapon:FindFirstChild(WeaponHold.Part1);
    end;

    Motor6D.Part1 = Weapon;
    local C0 = WeaponHold.C0;
    Motor6D.C0 = CFrame.new(C0[1], C0[2], C0[3], C0[4], C0[5], C0[6], C0[7], C0[8], C0[9], C0[10], C0[11], C0[12]);
    local C1 = WeaponHold.C1;
    Motor6D.C1 = CFrame.new(C1[1], C1[2], C1[3], C1[4], C1[5], C1[6], C1[7], C1[8], C1[9], C1[10], C1[11], C1[12]);
    Motor6D.Parent = Motor6D.Part0;
    local v22 = p18.Root[1];
    HumanoidRootPart.CFrame = CFrame.new(v22[1], v22[2], v22[3], v22[4], v22[5], v22[6], v22[7], v22[8], v22[9], v22[10], v22[11], v22[12]);
    v19.Parent = p16.Folder;

    local function load(p23: userdata, p24: any, p25: boolean) -- Line: 165
        -- upvalues: KeyframeSequenceProvider (ref), Animator (copy)
        local v26;

        if p23:IsA("KeyframeSequence") then
            v26 = Instance.new("Animation");
            v26.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(p23);
        else
            v26 = p23;
        end;

        local v27 = Animator:LoadAnimation(v26);
        v27.Looped = p25;
        v27.Priority = p24;

        return v27;
    end;

    local v28 = Options.Animations[p17];
    local Core = Enum.AnimationPriority.Core;
    local v29;

    if v28:IsA("KeyframeSequence") then
        v29 = Instance.new("Animation");
        v29.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(v28);
    else
        v29 = v28;
    end;

    local v30 = Animator:LoadAnimation(v29);
    v30.Looped = false;
    v30.Priority = Core;
    local HoldAnimation = Options.HoldAnimation;
    local Idle = Enum.AnimationPriority.Idle;
    local v31;

    if HoldAnimation:IsA("KeyframeSequence") then
        v31 = Instance.new("Animation");
        v31.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(HoldAnimation);
    else
        v31 = HoldAnimation;
    end;

    local v32 = Animator:LoadAnimation(v31);
    v32.Looped = true;
    v32.Priority = Idle;
    local v33 = Options.LeftArmAnimations[p17];
    local Action = Enum.AnimationPriority.Action;
    local v34;

    if v33:IsA("KeyframeSequence") then
        v34 = Instance.new("Animation");
        v34.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(v33);
    else
        v34 = v33;
    end;

    local v35 = Animator:LoadAnimation(v34);
    v35.Looped = false;
    v35.Priority = Action;
    local v36 = {};

    for _, descendant in v19:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            table.insert(v36, { descendant, descendant.Transparency });
            descendant.Transparency = 1;
        end;
    end;

    return {
        Hidden = true,
        Animated = false,
        Model = v19,
        Root = HumanoidRootPart,
        Track = v30,
        Hold = v32,
        LeftArm = v35,
        Rig = p18,
        Parts = v36
    };
end;

local function buildOverlay(p37: userdata) -- Line: 203
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "TutorialIntroOverlay";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 50;
    ScreenGui.ResetOnSpawn = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "BarTop";
    Frame.BackgroundColor3 = Color3.new(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 0.12);
    Frame.Parent = ScreenGui;
    local v38 = Frame:Clone();
    v38.Name = "BarBottom";
    v38.AnchorPoint = Vector2.new(0, 1);
    v38.Position = UDim2.fromScale(0, 1);
    v38.Parent = ScreenGui;
    ScreenGui.Parent = p37;

    return {
        Bar = 0.12,
        Screen = ScreenGui,
        Top = Frame,
        Bottom = v38
    };
end;

function u1.new(p39: table) -- Line: 225
    -- upvalues: u1 (copy), buildActor (copy), buildOverlay (copy)
    local v40 = setmetatable({}, u1);
    v40.Options = p39;
    v40.Data = p39.Data;
    v40.Fps = p39.Data.Fps;
    v40.Duration = p39.Data.Duration;
    v40.CutFrames = {};

    for i, v in p39.Data.Events do
        if string.sub(i, 1, 4) == "Shot" and type(v) == "number" then
            v40.CutFrames[math.floor(v * v40.Fps + 0.5)] = true;
        end;
    end;

    v40.Camera = p39.Camera or workspace.CurrentCamera;
    local Folder = Instance.new("Folder");
    Folder.Name = "TutorialIntro";
    Folder.Parent = p39.Parent or workspace;
    v40.Folder = Folder;
    v40.Actors = {};

    for i, v in p39.Data.Rigs do
        v40.Actors[i] = buildActor(v40, i, v);
    end;

    v40.Truck = p39.TruckBuilder.build(Folder);
    v40.Roots = {};

    for _, v in v40.Actors do
        table.insert(v40.Roots, v.Root);
    end;

    if p39.Atmosphere then
        v40.Atmosphere = p39.Atmosphere.new({
            Data = p39.Data,
            Folder = Folder,
            Camera = v40.Camera,
            SunDirection = p39.SunDirection
        });
    end;

    local v41 = p39.Map and p39.Map:FindFirstChild("TutorialDoors");

    if v41 then
        v41 = v41:FindFirstChild("DockDoor");
    end;

    if v41 and v41:IsA("Model") then
        v40.DockDoor = v41;
        v40.DockDoorClosed = v41:GetPivot();
        v40.DockDoorOffset = v41:GetAttribute("OpenOffset") or Vector3.new(0, 10.5, 0);
    end;

    if p39.Gui then
        v40.Overlay = buildOverlay(p39.Gui);
    end;

    v40.Started = false;
    v40:Update(0);

    return v40;
end;

function u1.Start(p42) -- Line: 275
    for _, v in p42.Actors do
        v.Track:Play(0, 1, 1);
        v.Hold:Play(0, 1, 1);
        v.LeftArm:Play(0, 0.0001, 1);
    end;

    p42.Started = true;
    p42.LastClock = nil;
end;

function u1.Time(p43) -- Line: 288
    for _, v in p43.Actors do
        if v.Track.IsPlaying then
            return v.Track.TimePosition;
        end;
    end;

    return p43.Duration;
end;

function u1.Update(p44: table, p45: number?) -- Line: 298
    -- upvalues: sampleTrack (copy)
    local v46 = p45 or (not p44.Started and 0 or p44:Time());
    local math_clamp_ret = math.clamp(v46, 0, p44.Duration);
    local Data = p44.Data;
    local Fps = p44.Fps;
    local v47 = not p44.LastClock and 0 or math.clamp(math_clamp_ret - p44.LastClock, 0, 0.1);
    p44.LastClock = math_clamp_ret;

    for _, v in p44.Actors do
        v.Root.CFrame = sampleTrack(v.Rig.Root, math_clamp_ret, Fps);

        if p44.Started then
            local math_min_ret = math.min(math_clamp_ret + v47, p44.Duration);
            local LeftArm = v.LeftArm;
            local LeftArmWeight = v.Rig.LeftArmWeight;
            local math_max_ret = math.max(0, math_min_ret * Fps);
            local math_floor_ret = math.floor(math_max_ret);
            local v48 = #LeftArmWeight;
            local v49;

            if v48 - 1 <= math_floor_ret then
                v49 = LeftArmWeight[v48];
            else
                v49 = LeftArmWeight[math_floor_ret + 1] + (LeftArmWeight[math_floor_ret + 2] - LeftArmWeight[math_floor_ret + 1]) * (math_max_ret - math_floor_ret);
            end;

            LeftArm:AdjustWeight(math.max(v49, 0.0001), 0);
        end;

        if p44.Started and v.Track.TimePosition > 0 then
            v.Animated = true;
        end;

        local HiddenFrom = v.Rig.HiddenFrom;
        local v50 = not v.Animated;

        if not v50 then
            if HiddenFrom == nil then
                v50 = false;
            else
                v50 = HiddenFrom <= math_clamp_ret;
            end;
        end;

        if v50 ~= v.Hidden then
            v.Hidden = v50;

            for _, v2 in v.Parts do
                v2[1].Transparency = v50 and 1 or v2[2];
            end;
        end;
    end;

    local math_min_ret = math.min(math_clamp_ret, (Data.Truck.SettledFrame - 1) / Fps);
    local v51 = sampleTrack(Data.Truck.Body, math_min_ret, Fps);
    local v52 = sampleTrack(Data.Truck.Wheels, math_min_ret, Fps);
    p44.Options.TruckBuilder.place(p44.Truck, v51, v52);
    local Atmosphere = p44.Atmosphere;

    if Atmosphere then
        Atmosphere:Update(math_clamp_ret, v47, v51, v52, p44.Roots);
    end;

    local Camera = p44.Camera;
    Camera.CameraType = Enum.CameraType.Scriptable;
    local math_floor_ret = math.floor(math_clamp_ret * Fps + 0.01);
    local v53;

    if p44.CutFrames[math_floor_ret + 1] then
        v53 = math_floor_ret / Fps;
    else
        v53 = math_clamp_ret;
    end;

    local v54 = sampleTrack(Data.Camera, v53, Fps);

    if Atmosphere then
        v54 = v54 * Atmosphere:Shake(v53);
    end;

    Camera.CFrame = v54;
    local CameraFov = Data.CameraFov;
    local math_max_ret = math.max(0, v53 * Fps);
    local math_floor_ret2 = math.floor(math_max_ret);
    local v55 = #CameraFov;
    local v56;

    if v55 - 1 <= math_floor_ret2 then
        v56 = CameraFov[v55];
    else
        v56 = CameraFov[math_floor_ret2 + 1] + (CameraFov[math_floor_ret2 + 2] - CameraFov[math_floor_ret2 + 1]) * (math_max_ret - math_floor_ret2);
    end;

    Camera.FieldOfView = v56;
    local Events = Data.Events;

    if p44.DockDoor then
        local DockDoor = p44.DockDoor;
        local DockDoorClosed = p44.DockDoorClosed;
        local DockDoorOffset = p44.DockDoorOffset;
        local DockDoorOpen = Events.DockDoorOpen;
        local v57;

        if DockDoorOpen then
            local math_clamp_ret2 = math.clamp((math_clamp_ret - DockDoorOpen[1]) / (DockDoorOpen[2] - DockDoorOpen[1]), 0, 1);
            v57 = math_clamp_ret2 * math_clamp_ret2 * math_clamp_ret2 * (math_clamp_ret2 * (math_clamp_ret2 * 6 - 15) + 10);
        else
            v57 = 0;
        end;

        DockDoor:PivotTo(DockDoorClosed + DockDoorOffset * v57);
    end;

    local Overlay = p44.Overlay;

    if Overlay then
        local LetterboxRetract = Events.LetterboxRetract;
        local v58;

        if LetterboxRetract then
            local math_clamp_ret2 = math.clamp((math_clamp_ret - LetterboxRetract[1]) / (LetterboxRetract[2] - LetterboxRetract[1]), 0, 1);
            v58 = math_clamp_ret2 * math_clamp_ret2 * math_clamp_ret2 * (math_clamp_ret2 * (math_clamp_ret2 * 6 - 15) + 10);
        else
            v58 = 0;
        end;

        Overlay.Top.Position = UDim2.fromScale(0, -Overlay.Bar * v58);
        Overlay.Bottom.Position = UDim2.fromScale(0, 1 + Overlay.Bar * v58);
    end;

    return p44.Duration <= math_clamp_ret;
end;

function u1.Destroy(p59) -- Line: 357
    for _, v in p59.Actors do
        v.Track:Stop(0);
        v.Hold:Stop(0);
        v.LeftArm:Stop(0);
    end;

    if p59.Overlay then
        p59.Overlay.Screen:Destroy();
    end;

    if p59.Atmosphere then
        p59.Atmosphere:Destroy();
    end;

    p59.Folder:Destroy();
end;

return u1;