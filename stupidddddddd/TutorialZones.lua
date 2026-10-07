-- ReplicatedStorage.Controllers.TutorialZones
-- Script path: ReplicatedStorage.Controllers.TutorialZones
-- Decompile time: 8.61 ms

local v1 = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Sound = require(ReplicatedStorage.Classes.Sound)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local LocalPlayer = Players.LocalPlayer
local u40 = {}
u40.Spot = Color3.fromRGB(255, 236, 60)
u40.T = Color3.fromRGB(255, 184, 40)
u40.CT = Color3.fromRGB(80, 170, 255)
u40.Site = Color3.fromRGB(255, 20, 20)
u40.Bomb = Color3.fromRGB(255, 20, 20)
local u69 = NumberRange.new(0, 0.2)
local Quint = Enum.EasingStyle.Quint
local Back = Enum.EasingStyle.Back
local u72 = {Spot = 0.5, Bomb = 0.5}
local u74 = {
    "Characters",
    "Debris",
    "TutorialDummies",
    "TutorialEscorts",
    "TutorialRetakers",
    "TutorialCTSquad",
    "TutorialBAttackers",
}
local u82 = nil
local u83 = nil

local function floorY(a1) -- Line: 109 -- upvalues: u74 (val), LocalPlayer (val) -- types: a1: vector
    local Instance, v1, v2
    local v3 = {workspace.CurrentCamera}
    local Map = workspace:FindFirstChild("Map")
    if Map then
        for i, j in {"Zones", "Geometry", "Barriers"} do
            v2 = Map:FindFirstChild(j)
            if v2 then
                table.insert(v3, v2)
            end
        end
    end
    for k, n in u74 do
        v2 = workspace:FindFirstChild(n)
        if v2 then
            table.insert(v3, v2)
        end
    end
    local Character = LocalPlayer.Character
    if Character then
        table.insert(v3, Character)
    end
    local v4 = RaycastParams.new()
    v4.FilterType = Enum.RaycastFilterType.Exclude
    v4.FilterDescendantsInstances = v3
    local v5 = a1 + Vector3.new(0, 6, 0)
    local v6 = 36
    for m = 1, 4 do
        v1 = workspace:Raycast(v5, Vector3.new(0, -v6, 0), v4)
        if not v1 then
            break
        end
        Instance = v1.Instance
        if 0.7 < v1.Normal.Y and Instance:IsA("BasePart") and Instance.Transparency < 0.9 then
            return v1.Position.Y
        end
        v6 = v6 - (v5.Y - v1.Position.Y + 0.05)
        v5 = v1.Position - Vector3.new(0, 0.05000000074505806, 0)
        if v6 <= 0 then
            break
        end
    end
    return a1.Y
end

local function floorFrame(a1) -- Line: 155 -- upvalues: floorY (val) -- types: a1: userdata
    local v1 = Vector3.new(a1.RightVector.X, 0, a1.RightVector.Z)
    local Unit = if not (0.01 < v1.Magnitude) then Vector3.new(1, 0, 0) else v1.Unit
    local Position = a1.Position
    return CFrame.fromMatrix(Vector3.new(Position.X, floorY(Position), Position.Z), Unit, (Vector3.new(0, 1, 0)))
end

local function buildWall(a1, a2, a3) -- Line: 163 -- types: a1: userdata, a2: userdata, a3: table
    local Frame, SurfaceGui, UIGradient
    local Part = Instance.new("Part")
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Parent = a1
    for i, j in {Enum.NormalId.Front, Enum.NormalId.Back} do
        SurfaceGui = Instance.new("SurfaceGui")
        SurfaceGui.Face = j
        SurfaceGui.LightInfluence = 0
        SurfaceGui.Brightness = 3
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        SurfaceGui.PixelsPerStud = 40
        SurfaceGui.Parent = Part
        Frame = Instance.new("Frame")
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.BackgroundColor3 = a2
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        UIGradient = Instance.new("UIGradient")
        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.55),
            (NumberSequenceKeypoint.new(1, 0)),
        })
        UIGradient.Parent = Frame
        Frame.Parent = SurfaceGui
        table.insert(a3, Frame)
    end
    return Part
end

local function layoutWalls(a1, a2, a3, a4) -- Line: 201 -- types: a1: table, a2: userdata, a3: number, a4: number
    local v1 = a2 * CFrame.new(0, 0.77, 0)
    local v2 = CFrame.Angles(0, 1.5707963267948966, 0)
    local v3 = Vector3.new(a3 * 2, 1.5, 0.01)
    local v4 = Vector3.new(a4 * 2, 1.5, 0.01)
    local v5 = a1[1]
    local v6 = a1[1]
    local v7 = v1 * (CFrame.new(0, 0, -a4))
    v5.Size = v3
    v6.CFrame = v7
    v5 = a1[2]
    v6 = a1[2]
    v7 = v1 * (CFrame.new(0, 0, a4))
    v5.Size = v3
    v6.CFrame = v7
    v5 = a1[3]
    v6 = a1[3]
    v7 = v1 * (CFrame.new(-a3, 0, 0)) * v2
    v5.Size = v4
    v6.CFrame = v7
    v5 = a1[4]
    v6 = a1[4]
    v7 = v1 * (CFrame.new(a3, 0, 0)) * v2
    v5.Size = v4
    v6.CFrame = v7
end

local function buildWalls(a1) -- Line: 213 -- upvalues: buildWall (val) -- types: a1: userdata
    local Folder = Instance.new("Folder")
    Folder.Name = "TutorialZone"
    Folder.Parent = workspace.CurrentCamera
    local v1 = {}
    return Folder, {
        buildWall(Folder, a1, v1),
        buildWall(Folder, a1, v1),
        buildWall(Folder, a1, v1),
        (buildWall(Folder, a1, v1)),
    }, v1
end

local u89 = nil
local u90 = {}
local u91 = 0

local function getGlow() -- Line: 230 -- upvalues: u89 (ref), u90 (val), LocalPlayer (val)
    local Frame, UIGradient, v1, v2, v3
    local v4 = u89
    if v4 and v4.Parent then
        return u90
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TutorialArrivalGlow"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 5
    table.clear(u90)
    for i, j in {
        {
            UDim2.fromScale(0.5, 0),
            UDim2.fromScale(1, 0.09),
            Vector2.new(0.5, 0),
            90,
        },
        {
            UDim2.fromScale(0.5, 1),
            UDim2.fromScale(1, 0.09),
            Vector2.new(0.5, 1),
            -90,
        },
        {
            UDim2.fromScale(0, 0.5),
            UDim2.fromScale(0.09, 1),
            Vector2.new(0, 0.5),
            0,
        },
        {
            UDim2.fromScale(1, 0.5),
            UDim2.fromScale(0.09, 1),
            Vector2.new(1, 0.5),
            180,
        },
    } do
        Frame = Instance.new("Frame")
        v3 = j[1]
        v1 = j[2]
        v2 = j[3]
        Frame.Position = v3
        Frame.Size = v1
        Frame.AnchorPoint = v2
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        UIGradient = Instance.new("UIGradient")
        UIGradient.Rotation = j[4]
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.35, 0.6),
            (NumberSequenceKeypoint.new(1, 1)),
        })
        UIGradient.Parent = Frame
        Frame.Parent = ScreenGui
        table.insert(u90, Frame)
    end
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    u89 = ScreenGui
    return u90
end

local function playArrival(a1) -- Line: 270
    -- upvalues: Sound (val), getGlow (val), u91 (ref), TweenService (val)
    (Sound.new("Deathmatch")):playOneTime({Name = "Deathmatch HP Bonus", Parent = workspace.CurrentCamera})
    local u12 = getGlow()
    u91 = u91 + 1
    local u15 = u91
    local v1 = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for i, j in u12 do
        j.BackgroundColor3 = a1
        TweenService:Create(j, v1, {BackgroundTransparency = 0.55}):Play()
    end
    task.delay(0.05, function() -- Line: 283 -- upvalues: u15 (val), u91 (upval), u12 (val), TweenService (upval)
        if u15 ~= u91 then
            return
        end
        local v1 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        for i, j in u12 do
            TweenService:Create(j, v1, {BackgroundTransparency = 1}):Play()
        end
    end)
end

local function isInZone(a1, a2) -- Line: 294 -- types: a1: table, a2: vector
    local v1
    local Room = a1.Room
    if Room then
        v1 = Room.CFrame:PointToObjectSpace(a2)
        if (math.abs(v1.X)) <= Room.Half.X
            and (math.abs(v1.Y)) <= Room.Half.Y
            and (math.abs(v1.Z)) <= Room.Half.Z then
            return true
        end
    end
    v1 = a1.Base:PointToObjectSpace(a2)
    local v2 = false
    if (math.abs(v1.X)) <= a1.HalfX + a1.Margin then
        v2 = false
        if (math.abs(v1.Z)) <= a1.HalfZ + a1.Margin then
            v2 = false
            if -4 < v1.Y then
                v2 = v1.Y < 10
            end
        end
    end
    return v2
end

local function buildZone(a1, a2, a3, a4, a5, a6) -- Line: 313
    -- upvalues: u40 (val), floorY (val), buildWalls (val), layoutWalls (val), u72 (val)
    local Spot = u40[a2] or u40.Spot
    local v1 = Vector3.new(a3.RightVector.X, 0, a3.RightVector.Z)
    local Unit = if not (0.01 < v1.Magnitude) then Vector3.new(1, 0, 0) else v1.Unit
    local Position = a3.Position
    local v2 = CFrame.fromMatrix(Vector3.new(Position.X, floorY(Position), Position.Z), Unit, (Vector3.new(0, 1, 0)))
    v1 = a4 * 0.5
    local v3 = a5 * 0.5
    local v4, v5, v6 = buildWalls(Spot)
    layoutWalls(v5, v2, v1, v3)
    return {
        Transparency = 1,
        WasOutside = false,
        Entered = false,
        Key = a1,
        Kind = a2,
        Folder = v4,
        Walls = v5,
        Frames = v6,
        ShownAt = os.clock(),
        Base = v2,
        HalfX = v1,
        HalfZ = v3,
        Margin = u72[a2] or 3.5,
        Room = a6,
        Color = Spot,
    }
end

local function morphZone(a1, a2, a3, a4, a5, a6) -- Line: 347
    -- upvalues: floorY (val), u72 (val)
    a1.Morph = {
        Base = a1.Base,
        HalfX = a1.HalfX,
        HalfZ = a1.HalfZ,
        StartedAt = os.clock(),
    }
    a1.Key = a2
    a1.Kind = a3
    local v1 = Vector3.new(a4.RightVector.X, 0, a4.RightVector.Z)
    local Unit = if not (0.01 < v1.Magnitude) then Vector3.new(1, 0, 0) else v1.Unit
    local Position = a4.Position
    local v2 = CFrame.fromMatrix(Vector3.new(Position.X, floorY(Position), Position.Z), Unit, (Vector3.new(0, 1, 0)))
    v1 = a5 * 0.5
    local v3 = a6 * 0.5
    a1.Base = v2
    a1.HalfX = v1
    a1.HalfZ = v3
    a1.Margin = u72[a3] or 3.5
    a1.Room = nil
    a1.WasOutside = false
    a1.Entered = false
end

local function draw() -- Line: 356
    -- upvalues: u82 (ref), buildWalls (val), layoutWalls (val), TweenService (val), Quint (val), Back (val)
    -- upvalues: CharacterResolver (val), isInZone (val), playArrival (val), u69 (val)
    local v1, v2
    local v3 = u82
    if not v3 then
        return
    end
    if not v3.Folder.Parent then
        local v4
        v4, v1, v2 = buildWalls(v3.Color)
        v3.Folder = v4
        v3.Walls = v1
        v3.Frames = v2
        v3.Transparency = 1
        if not v3.Morph then
            layoutWalls(v3.Walls, v3.Base, v3.HalfX, v3.HalfZ)
        end
    end
    local Morph = v3.Morph
    if Morph then
        v1 = math.clamp((os.clock() - Morph.StartedAt) / 0.9, 0, 1)
        local Value = TweenService:GetValue(v1, Quint, Enum.EasingDirection.Out)
        local Value_2 = TweenService:GetValue(v1, Back, Enum.EasingDirection.Out)
        layoutWalls(
            v3.Walls,
            Morph.Base:Lerp(v3.Base, Value),
            math.max(Morph.HalfX + (v3.HalfX - Morph.HalfX) * Value_2, 0.25),
            (math.max(Morph.HalfZ + (v3.HalfZ - Morph.HalfZ) * Value_2, 0.25))
        )
        if v1 >= 1 then
            v3.Morph = nil
        end
    end
    v1 = CharacterResolver.getLocalCharacter()
    v2 = v1 and CharacterResolver.getRootPart(v1)
    if v2 and not v3.Entered then
        if not isInZone(v3, v2.Position) then
            v3.WasOutside = true
        elseif v3.WasOutside then
            v3.Entered = true
            playArrival(v3.Color)
        end
    end
    local v5 = os.clock() - v3.ShownAt
    local v6 = math.sin(v5 * 3.141592653589793 * 2 / 2.4) * 0.5 + 0.5
    local Min = if not v3.Morph then u69.Max - (u69.Max - u69.Min) * v6 else u69.Min
    local v7 = math.clamp(v5 / 0.4, 0, 1)
    local v8 = math.floor((1 - (1 - Min) * v7) * 50 + 0.5) / 50
    if v8 == v3.Transparency then
        return
    end
    v3.Transparency = v8
    for i, j in v3.Frames do
        j.BackgroundTransparency = v8
    end
end

local function clear() -- Line: 412 -- upvalues: u82 (ref), TweenService (val), u83 (ref), RunServiceController (val)
    local v1 = u82
    u82 = nil
    if v1 then
        local Folder = v1.Folder
        local v2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        for i, j in v1.Frames do
            TweenService:Create(j, v2, {BackgroundTransparency = 1}):Play()
        end
        task.delay(0.6, function() -- Line: 422 -- upvalues: Folder (val)
            Folder:Destroy()
        end)
    end
    if u83 then
        RunServiceController.Unbind("Heartbeat", "TutorialZones.Draw")
        u83 = nil
    end
end

local function sync() -- Line: 432
    -- upvalues: IsTutorialMode (val), LocalPlayer (val), clear (val), u82 (ref), HttpService (val), morphZone (val)
    -- upvalues: buildZone (val), draw (val), u83 (ref), RunServiceController (val)
    local Attribute = if not IsTutorialMode() then nil else LocalPlayer:GetAttribute("TutorialZone")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        if u82 and u82.Key == Attribute then
            return
        end
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        if success and typeof(result) == "table" and typeof(result.c) == "table" and typeof(result.s) == "table" then
            local v1 = CFrame.new(table.unpack(result.c))
            local v2 = tonumber(result.s[1])
            local v3 = tonumber(result.s[2])
            if v2 and v3 and not (v2 <= 0) and not (v3 <= 0) then
                local v4, v5
                local v6 = nil
                local a = result.a
                if typeof(a) == "table" and typeof(a.c) == "table" and typeof(a.s) == "table" then
                    v4 = tonumber(a.s[1])
                    v5 = tonumber(a.s[2])
                    local v7 = tonumber(a.s[3])
                    if v4 and v5 and v7 then
                        v6 = {
                            CFrame = CFrame.new(table.unpack(a.c)),
                            Half = Vector3.new(v4, v5, v7) * 0.5,
                        }
                    end
                end
                v4 = tostring(result.k)
                v5 = u82
                if v5 and v5.Kind == "Site" and v4 == "Bomb" and v5.Folder.Parent then
                    morphZone(v5, Attribute, v4, v1, v2, v3)
                    return
                end
                clear()
                u82 = buildZone(Attribute, v4, v1, v2, v3, v6)
                draw()
                u83 = RunServiceController.BindToHeartbeat("TutorialZones.Draw", draw)
                return
            end
            clear()
            return
        end
        clear()
        return
    end
    clear()
end

function v1.IsInside(a1) -- Line: 473 -- upvalues: u82 (ref), isInZone (val) -- types: a1: vector
    local v1 = u82
    local v2 = false
    if v1 ~= nil then
        v2 = isInZone(v1, a1)
    end
    return v2
end

function v1.Start() -- Line: 478 -- upvalues: LocalPlayer (val), sync (val)
    (LocalPlayer:GetAttributeChangedSignal("TutorialZone")):Connect(sync)
    sync()
end

return v1