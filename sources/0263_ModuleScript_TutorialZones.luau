-- Decompiled with Potassium's decompiler.

local v1 = {};
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Sound = require(ReplicatedStorage.Classes.Sound);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    Spot = Color3.fromRGB(255, 236, 60),
    T = Color3.fromRGB(255, 184, 40),
    CT = Color3.fromRGB(80, 170, 255),
    Site = Color3.fromRGB(255, 20, 20),
    Bomb = Color3.fromRGB(255, 20, 20)
};
local NumberRange_new_ret = NumberRange.new(0, 0.2);
local Quint = Enum.EasingStyle.Quint;
local Back = Enum.EasingStyle.Back;
local u3 = {
    Spot = 0.5,
    Bomb = 0.5
};
local u4 = { "Characters", "Debris", "TutorialDummies", "TutorialEscorts", "TutorialRetakers", "TutorialCTSquad", "TutorialBAttackers" };
local u5 = nil;
local u6 = nil;

local function floorY(p7: vector) -- Line: 109
    -- upvalues: u4 (copy), LocalPlayer (copy)
    local v8 = { workspace.CurrentCamera };
    local Map = workspace:FindFirstChild("Map");

    if Map then
        for _, v in { "Zones", "Geometry", "Barriers" } do
            local v9 = Map:FindFirstChild(v);

            if v9 then
                table.insert(v8, v9);
            end;
        end;
    end;

    for _, v in u4 do
        local v10 = workspace:FindFirstChild(v);

        if v10 then
            table.insert(v8, v10);
        end;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v8, Character);
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = v8;
    local v11 = p7 + Vector3.new(0, 6, 0);
    local v12 = 36;

    for i = 1, 4 do
        local v13 = workspace:Raycast(v11, Vector3.new(0, -v12, 0), RaycastParams_new_ret);

        if not v13 then
            break;
        end;

        local Instance2 = v13.Instance;

        if v13.Normal.Y > 0.7 and (Instance2:IsA("BasePart") and Instance2.Transparency < 0.9) then
            return v13.Position.Y;
        end;

        v12 = v12 - (v11.Y - v13.Position.Y + 0.05);
        v11 = v13.Position - Vector3.new(0, 0.05, 0);

        if v12 <= 0 then
            break;
        end;

        local _ = i;
    end;

    return p7.Y;
end;

local function floorFrame(p14) -- Line: 155
    -- upvalues: floorY (copy)
    local Vector3_new_ret = Vector3.new(p14.RightVector.X, 0, p14.RightVector.Z);
    local v15 = Vector3_new_ret.Magnitude <= 0.01 and Vector3.new(1, 0, 0) or Vector3_new_ret.Unit;
    local Position = p14.Position;
    local CFrame_fromMatrix = CFrame.fromMatrix;
    local X = Position.X;
    local v16 = floorY(Position);

    return CFrame_fromMatrix(Vector3.new(X, v16, Position.Z), v15, Vector3.new(0, 1, 0));
end;

local function buildWall(p17: userdata, p18, p19: table) -- Line: 163
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.Parent = p17;

    for _, v in { Enum.NormalId.Front, Enum.NormalId.Back } do
        local SurfaceGui = Instance.new("SurfaceGui");
        SurfaceGui.Face = v;
        SurfaceGui.LightInfluence = 0;
        SurfaceGui.Brightness = 3;
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud;
        SurfaceGui.PixelsPerStud = 40;
        SurfaceGui.Parent = Part;
        local Frame = Instance.new("Frame");
        Frame.Size = UDim2.fromScale(1, 1);
        Frame.BackgroundColor3 = p18;
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Rotation = 90;
        UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.55), NumberSequenceKeypoint.new(1, 0) });
        UIGradient.Parent = Frame;
        Frame.Parent = SurfaceGui;
        table.insert(p19, Frame);
    end;

    return Part;
end;

local function layoutWalls(p20: table, p21, p22: number, p23: number) -- Line: 201
    local v24 = p21 * CFrame.new(0, 0.77, 0);
    local CFrame_Angles_ret = CFrame.Angles(0, 1.5707963267948966, 0);
    local Vector3_new_ret = Vector3.new(p22 * 2, 1.5, 0.01);
    local Vector3_new_ret2 = Vector3.new(p23 * 2, 1.5, 0.01);
    local v25 = p20[1];
    local v26 = p20[1];
    local v27 = v24 * CFrame.new(0, 0, -p23);
    v25.Size = Vector3_new_ret;
    v26.CFrame = v27;
    local v28 = p20[2];
    local v29 = p20[2];
    local v30 = v24 * CFrame.new(0, 0, p23);
    v28.Size = Vector3_new_ret;
    v29.CFrame = v30;
    local v31 = p20[3];
    local v32 = p20[3];
    local v33 = v24 * CFrame.new(-p22, 0, 0) * CFrame_Angles_ret;
    v31.Size = Vector3_new_ret2;
    v32.CFrame = v33;
    local v34 = p20[4];
    local v35 = p20[4];
    local v36 = v24 * CFrame.new(p22, 0, 0) * CFrame_Angles_ret;
    v34.Size = Vector3_new_ret2;
    v35.CFrame = v36;
end;

local function buildWalls(p37) -- Line: 213
    -- upvalues: buildWall (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "TutorialZone";
    Folder.Parent = workspace.CurrentCamera;
    local v38 = {};

    return Folder, {
        buildWall(Folder, p37, v38),
        buildWall(Folder, p37, v38),
        buildWall(Folder, p37, v38),
        buildWall(Folder, p37, v38)
    }, v38;
end;

local u39 = nil;
local u40 = {};
local u41 = 0;

local function getGlow() -- Line: 230
    -- upvalues: u39 (ref), u40 (copy), LocalPlayer (copy)
    local v42 = u39;

    if v42 and v42.Parent then
        return u40;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "TutorialArrivalGlow";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 5;
    table.clear(u40);

    for _, v in {
        {
            UDim2.fromScale(0.5, 0),
            UDim2.fromScale(1, 0.09),
            Vector2.new(0.5, 0),
            90
        },
        {
            UDim2.fromScale(0.5, 1),
            UDim2.fromScale(1, 0.09),
            Vector2.new(0.5, 1),
            -90
        },
        {
            UDim2.fromScale(0, 0.5),
            UDim2.fromScale(0.09, 1),
            Vector2.new(0, 0.5),
            0
        },
        {
            UDim2.fromScale(1, 0.5),
            UDim2.fromScale(0.09, 1),
            Vector2.new(1, 0.5),
            180
        }
    } do
        local Frame = Instance.new("Frame");
        local v43 = v[2];
        local v44 = v[3];
        Frame.Position = v[1];
        Frame.Size = v43;
        Frame.AnchorPoint = v44;
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Rotation = v[4];
        UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.35, 0.6), NumberSequenceKeypoint.new(1, 1) });
        UIGradient.Parent = Frame;
        Frame.Parent = ScreenGui;
        table.insert(u40, Frame);
    end;

    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
    u39 = ScreenGui;

    return u40;
end;

local function playArrival(p45) -- Line: 270
    -- upvalues: Sound (copy), getGlow (copy), u41 (ref), TweenService (copy)
    Sound.new("Deathmatch"):playOneTime({
        Name = "Deathmatch HP Bonus",
        Parent = workspace.CurrentCamera
    });
    local u46 = getGlow();
    u41 = u41 + 1;
    local u47 = u41;
    local TweenInfo_new_ret = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for _, v in u46 do
        v.BackgroundColor3 = p45;
        TweenService:Create(v, TweenInfo_new_ret, {
            BackgroundTransparency = 0.55
        }):Play();
    end;

    task.delay(0.05, function() -- Line: 283
        -- upvalues: u47 (copy), u41 (ref), u46 (copy), TweenService (ref)
        if u47 ~= u41 then
            return;
        end;

        local TweenInfo_new_ret2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in u46 do
            TweenService:Create(v, TweenInfo_new_ret2, {
                BackgroundTransparency = 1
            }):Play();
        end;
    end);
end;

local function isInZone(p48: table, p49: vector) -- Line: 294
    local Room = p48.Room;

    if Room then
        local v50 = Room.CFrame:PointToObjectSpace(p49);

        if math.abs(v50.X) <= Room.Half.X and (math.abs(v50.Y) <= Room.Half.Y and math.abs(v50.Z) <= Room.Half.Z) then
            return true;
        end;
    end;

    local v51 = p48.Base:PointToObjectSpace(p49);
    local v52;

    if math.abs(v51.X) <= p48.HalfX + p48.Margin and (math.abs(v51.Z) <= p48.HalfZ + p48.Margin and v51.Y > -4) then
        v52 = v51.Y < 10;
    else
        v52 = false;
    end;

    return v52;
end;

local function buildZone(p53: string, p54: string, p55, p56: number, p57: number, p58: table?) -- Line: 313
    -- upvalues: u2 (copy), floorY (copy), buildWalls (copy), layoutWalls (copy), u3 (copy)
    local v59 = u2[p54] or u2.Spot;
    local Vector3_new_ret = Vector3.new(p55.RightVector.X, 0, p55.RightVector.Z);
    local v60 = Vector3_new_ret.Magnitude <= 0.01 and Vector3.new(1, 0, 0) or Vector3_new_ret.Unit;
    local Position = p55.Position;
    local CFrame_fromMatrix = CFrame.fromMatrix;
    local X = Position.X;
    local v61 = floorY(Position);
    local v62 = CFrame_fromMatrix(Vector3.new(X, v61, Position.Z), v60, Vector3.new(0, 1, 0));
    local v63 = p56 * 0.5;
    local v64 = p57 * 0.5;
    local v65, v66, v67 = buildWalls(v59);
    layoutWalls(v66, v62, v63, v64);

    return {
        Morph = nil,
        Transparency = 1,
        WasOutside = false,
        Entered = false,
        Key = p53,
        Kind = p54,
        Folder = v65,
        Walls = v66,
        Frames = v67,
        ShownAt = os.clock(),
        Base = v62,
        HalfX = v63,
        HalfZ = v64,
        Margin = u3[p54] or 3.5,
        Room = p58,
        Color = v59
    };
end;

local function morphZone(p68: table, p69: string, p70: string, p71, p72: number, p73: number) -- Line: 347
    -- upvalues: floorY (copy), u3 (copy)
    p68.Morph = {
        Base = p68.Base,
        HalfX = p68.HalfX,
        HalfZ = p68.HalfZ,
        StartedAt = os.clock()
    };
    p68.Key = p69;
    p68.Kind = p70;
    local Vector3_new_ret = Vector3.new(p71.RightVector.X, 0, p71.RightVector.Z);
    local v74 = Vector3_new_ret.Magnitude <= 0.01 and Vector3.new(1, 0, 0) or Vector3_new_ret.Unit;
    local Position = p71.Position;
    local CFrame_fromMatrix = CFrame.fromMatrix;
    local X = Position.X;
    local v75 = floorY(Position);
    local v76 = CFrame_fromMatrix(Vector3.new(X, v75, Position.Z), v74, Vector3.new(0, 1, 0));
    p68.Base = v76;
    p68.HalfX = p72 * 0.5;
    p68.HalfZ = p73 * 0.5;
    p68.Margin = u3[p70] or 3.5;
    p68.Room = nil;
    p68.WasOutside = false;
    p68.Entered = false;
end;

local function draw() -- Line: 356
    -- upvalues: u5 (ref), buildWalls (copy), layoutWalls (copy), TweenService (copy), Quint (copy), Back (copy), CharacterResolver (copy), isInZone (copy), playArrival (copy), NumberRange_new_ret (copy)
    local v77 = u5;

    if not v77 then
        return;
    end;

    if not v77.Folder.Parent then
        local v78, v79, v80 = buildWalls(v77.Color);
        v77.Folder = v78;
        v77.Walls = v79;
        v77.Frames = v80;
        v77.Transparency = 1;

        if not v77.Morph then
            layoutWalls(v77.Walls, v77.Base, v77.HalfX, v77.HalfZ);
        end;
    end;

    local Morph = v77.Morph;

    if Morph then
        local v81 = (os.clock() - Morph.StartedAt) / 0.9;
        local math_clamp_ret = math.clamp(v81, 0, 1);
        local Value = TweenService:GetValue(math_clamp_ret, Quint, Enum.EasingDirection.Out);
        local Value2 = TweenService:GetValue(math_clamp_ret, Back, Enum.EasingDirection.Out);
        layoutWalls(v77.Walls, Morph.Base:Lerp(v77.Base, Value), math.max(Morph.HalfX + (v77.HalfX - Morph.HalfX) * Value2, 0.25), (math.max(Morph.HalfZ + (v77.HalfZ - Morph.HalfZ) * Value2, 0.25)));

        if math_clamp_ret >= 1 then
            v77.Morph = nil;
        end;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        LocalCharacter = CharacterResolver.getRootPart(LocalCharacter);
    end;

    if LocalCharacter and not v77.Entered then
        if isInZone(v77, LocalCharacter.Position) then
            if v77.WasOutside then
                v77.Entered = true;
                playArrival(v77.Color);
            end;
        else
            v77.WasOutside = true;
        end;
    end;

    local v82 = os.clock() - v77.ShownAt;
    local v83 = math.sin(v82 * 3.141592653589793 * 2 / 2.4) * 0.5 + 0.5;
    local v84;

    if v77.Morph then
        v84 = NumberRange_new_ret.Min;
    else
        v84 = NumberRange_new_ret.Max - (NumberRange_new_ret.Max - NumberRange_new_ret.Min) * v83;
    end;

    local math_clamp_ret = math.clamp(v82 / 0.4, 0, 1);
    local v85 = math.floor((1 - (1 - v84) * math_clamp_ret) * 50 + 0.5) / 50;

    if v85 == v77.Transparency then
        return;
    end;

    v77.Transparency = v85;

    for _, v in v77.Frames do
        v.BackgroundTransparency = v85;
    end;
end;

local function clear() -- Line: 412
    -- upvalues: u5 (ref), TweenService (copy), u6 (ref), RunServiceController (copy)
    local v86 = u5;
    u5 = nil;

    if v86 then
        local Folder = v86.Folder;
        local TweenInfo_new_ret = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, v in v86.Frames do
            TweenService:Create(v, TweenInfo_new_ret, {
                BackgroundTransparency = 1
            }):Play();
        end;

        task.delay(0.6, function() -- Line: 422
            -- upvalues: Folder (copy)
            Folder:Destroy();
        end);
    end;

    if u6 then
        RunServiceController.Unbind("Heartbeat", "TutorialZones.Draw");
        u6 = nil;
    end;
end;

local function sync() -- Line: 432
    -- upvalues: IsTutorialMode (copy), LocalPlayer (copy), clear (copy), u5 (ref), HttpService (copy), morphZone (copy), buildZone (copy), draw (copy), u6 (ref), RunServiceController (copy)
    local v87;

    if IsTutorialMode() then
        v87 = LocalPlayer:GetAttribute("TutorialZone");
    else
        v87 = nil;
    end;

    if typeof(v87) ~= "string" or v87 == "" then
        clear();

        return;
    end;

    if u5 and u5.Key == v87 then
        return;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, v87);

    if not (success and (typeof(result) == "table" and (typeof(result.c) == "table" and typeof(result.s) == "table"))) then
        clear();

        return;
    end;

    local CFrame_new_ret = CFrame.new(table.unpack(result.c));
    local v88 = tonumber(result.s[1]);
    local v89 = tonumber(result.s[2]);

    if not (v88 and (v89 and (v88 > 0 and v89 > 0))) then
        clear();

        return;
    end;

    local v90 = nil;
    local a = result.a;

    if typeof(a) == "table" and (typeof(a.c) == "table" and typeof(a.s) == "table") then
        local v91 = tonumber(a.s[1]);
        local v92 = tonumber(a.s[2]);
        local v93 = tonumber(a.s[3]);
        v90 = v91 and (v92 and v93) and {
            CFrame = CFrame.new(table.unpack(a.c)),
            Half = Vector3.new(v91, v92, v93) * 0.5
        } or v90;
    end;

    local v94 = tostring(result.k);
    local v95 = u5;

    if v95 and (v95.Kind == "Site" and (v94 == "Bomb" and v95.Folder.Parent)) then
        morphZone(v95, v87, v94, CFrame_new_ret, v88, v89);

        return;
    end;

    clear();
    u5 = buildZone(v87, v94, CFrame_new_ret, v88, v89, v90);
    draw();
    u6 = RunServiceController.BindToHeartbeat("TutorialZones.Draw", draw);
end;

function v1.IsInside(p96: vector) -- Line: 473
    -- upvalues: u5 (ref), isInZone (copy)
    local v97 = u5;
    local v98;

    if v97 == nil then
        v98 = false;
    else
        v98 = isInZone(v97, p96);
    end;

    return v98;
end;

function v1.Start() -- Line: 478
    -- upvalues: LocalPlayer (copy), sync (copy)
    LocalPlayer:GetAttributeChangedSignal("TutorialZone"):Connect(sync);
    sync();
end;

return v1;