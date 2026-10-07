-- ReplicatedStorage.Cutscenes.TutorialIntro.IntroPlayer
-- Script path: ReplicatedStorage.Cutscenes.TutorialIntro.IntroPlayer
-- Decompile time: 8.59 ms

local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local u5 = {}
u5.__index = u5

local function cframeOf(a1) -- Line: 53 -- types: a1: table
    return CFrame.new(a1[1], a1[2], a1[3], a1[4], a1[5], a1[6], a1[7], a1[8], a1[9], a1[10], a1[11], a1[12])
end

local function sampleTrack(a1, a2, a3) -- Line: 57
    -- upvalues: cframeOf (val)
    local v1 = math.max(0, a2 * a3)
    local v2 = math.floor(v1)
    local v3 = #a1
    if v3 - 1 <= v2 then
        return cframeOf(a1[v3])
    end
    local v4 = a1[v2 + 1]
    local v5 = CFrame.new(v4[1], v4[2], v4[3], v4[4], v4[5], v4[6], v4[7], v4[8], v4[9], v4[10], v4[11], v4[12])
    local v6 = a1[v2 + 2]
    return v5:Lerp(CFrame.new(v6[1], v6[2], v6[3], v6[4], v6[5], v6[6], v6[7], v6[8], v6[9], v6[10], v6[11], v6[12]), v1 - v2)
end

local function sampleNumber(a1, a2, a3) -- Line: 69 -- types: a1: table, a2: number, a3: number
    local v1 = math.max(0, a2 * a3)
    local v2 = math.floor(v1)
    local v3 = #a1
    if v3 - 1 <= v2 then
        return a1[v3]
    end
    return a1[v2 + 1] + (a1[v2 + 2] - a1[v2 + 1]) * (v1 - v2)
end

local function smoother(a1) -- Line: 79 -- types: a1: number
    local v1 = math.clamp(a1, 0, 1)
    return v1 * v1 * v1 * (v1 * (v1 * 6 - 15) + 10)
end

local function window(a1, a2) -- Line: 84 -- types: a1: number, a2: table?
    if not a2 then
        return 0
    end
    local v1 = math.clamp((a1 - a2[1]) / (a2[2] - a2[1]), 0, 1)
    return v1 * v1 * v1 * (v1 * (v1 * 6 - 15) + 10)
end

local function buildActor(a1, a2, a3) -- Line: 91 -- upvalues: KeyframeSequenceProvider (val) -- types: a2: string
    local v1, v2, v3, v4
    local Options = a1.Options
    local v5 = Options.CharacterTemplate:Clone()
    v5.Name = "Intro_" .. a2
    for i, j in v5:GetDescendants() do
        if j:IsA("BasePart") then
            j.Anchored = false
            j.CanCollide = false
            j.CanQuery = false
            j.CanTouch = false
            j.Massless = true
        elseif j:IsA("Sound") then
            j:Destroy()
        end
    end
    local UpperTorso = v5:FindFirstChild("UpperTorso")
    local Head = UpperTorso and UpperTorso:FindFirstChild("Head")
    if Head and Head:IsA("Motor6D") then
        Head:Destroy()
    end
    local HumanoidRootPart = v5:FindFirstChild("HumanoidRootPart")
    HumanoidRootPart.Anchored = true
    if Options.HeadMeshScale then
        local Head_2 = v5:FindFirstChild("Head")
        local SpecialMesh = Head_2 and Head_2:FindFirstChildOfClass("SpecialMesh")
        if SpecialMesh then
            SpecialMesh.Scale = Vector3.new(1, 1, 1) * Options.HeadMeshScale
        end
    end
    local AnimationController = Instance.new("AnimationController")
    AnimationController.Parent = v5
    local Animator = Instance.new("Animator")
    Animator.Parent = AnimationController
    local v6 = Options.WeaponTemplate:Clone()
    v6.Name = "AK-47"
    local Weapon = v6:FindFirstChild("Weapon")
    if Weapon then
        for k, n in {"Hitbox", "Insert"} do
            v1 = Weapon:FindFirstChild(n)
            if v1 then
                v1:Destroy()
            end
        end
    end
    local v7, v8, v9 = a3, a1, a2
    for m, i5 in v6:GetDescendants() do
        if i5:IsA("BasePart") then
            i5.Anchored = false
            i5.CanCollide = false
            i5.CanQuery = false
            i5.CanTouch = false
            i5.Massless = true
        elseif i5:IsA("Sound") or i5:IsA("Light") then
            i5:Destroy()
        end
    end
    v6.Parent = v5
    local WeaponHold = v7.WeaponHold
    local Motor6D = Instance.new("Motor6D")
    Motor6D.Name = WeaponHold.MotorName
    Motor6D.Part0 = v5:FindFirstChild(WeaponHold.Part0)
    Motor6D.Part1 = Weapon and Weapon:FindFirstChild(WeaponHold.Part1)
    local C0 = WeaponHold.C0
    Motor6D.C0 = CFrame.new(C0[1], C0[2], C0[3], C0[4], C0[5], C0[6], C0[7], C0[8], C0[9], C0[10], C0[11], C0[12])
    local C1 = WeaponHold.C1
    Motor6D.C1 = CFrame.new(C1[1], C1[2], C1[3], C1[4], C1[5], C1[6], C1[7], C1[8], C1[9], C1[10], C1[11], C1[12])
    Motor6D.Parent = Motor6D.Part0
    local v10 = v7.Root[1]
    HumanoidRootPart.CFrame = CFrame.new(v10[1], v10[2], v10[3], v10[4], v10[5], v10[6], v10[7], v10[8], v10[9], v10[10], v10[11], v10[12])
    v5.Parent = v8.Folder

    local function load(a1, a2, a3) -- Line: 161
        -- upvalues: KeyframeSequenceProvider (upval), Animator (val)
        local v1
        if not a1:IsA("KeyframeSequence") then
            v1 = a1
        else
            v1 = Instance.new("Animation")
            v1.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(a1)
        end
        local v2 = Animator:LoadAnimation(v1)
        v2.Looped = a3
        v2.Priority = a2
        return v2
    end

    local v11 = Options.Animations[v9]
    local Core = Enum.AnimationPriority.Core
    if not v11:IsA("KeyframeSequence") then
        v2 = v11
    else
        v2 = Instance.new("Animation")
        v2.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(v11)
    end
    v10 = Animator:LoadAnimation(v2)
    v10.Looped = false
    v10.Priority = Core
    local HoldAnimation = Options.HoldAnimation
    local Idle = Enum.AnimationPriority.Idle
    if not HoldAnimation:IsA("KeyframeSequence") then
        v3 = HoldAnimation
    else
        v3 = Instance.new("Animation")
        v3.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(HoldAnimation)
    end
    v11 = Animator:LoadAnimation(v3)
    v11.Looped = true
    v11.Priority = Idle
    v2 = Options.LeftArmAnimations[v9]
    local Action = Enum.AnimationPriority.Action
    if not v2:IsA("KeyframeSequence") then
        v4 = v2
    else
        v4 = Instance.new("Animation")
        v4.AnimationId = KeyframeSequenceProvider:RegisterKeyframeSequence(v2)
    end
    v1 = Animator:LoadAnimation(v4)
    v1.Looped = false
    v1.Priority = Action
    v2 = {}
    for i6, i7 in v5:GetDescendants() do
        if i7:IsA("BasePart") or i7:IsA("Decal") then
            table.insert(v2, {i7, i7.Transparency})
            i7.Transparency = 1
        end
    end
    return {
        Hidden = true,
        Animated = false,
        Model = v5,
        Root = HumanoidRootPart,
        Track = v10,
        Hold = v11,
        LeftArm = v1,
        Rig = v7,
        Parts = v2,
    }
end

local function buildOverlay(a1) -- Line: 199 -- types: a1: userdata
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TutorialIntroOverlay"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 50
    ScreenGui.ResetOnSpawn = false
    local Frame = Instance.new("Frame")
    Frame.Name = "BarTop"
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 0.12)
    Frame.Parent = ScreenGui
    local v1 = Frame:Clone()
    v1.Name = "BarBottom"
    v1.AnchorPoint = Vector2.new(0, 1)
    v1.Position = UDim2.fromScale(0, 1)
    v1.Parent = ScreenGui
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Title"
    Frame_2.BackgroundTransparency = 1
    Frame_2.AnchorPoint = Vector2.new(0, 1)
    Frame_2.Position = UDim2.fromScale(0.035, 0.85)
    Frame_2.Size = UDim2.fromScale(0.3, 0.1)
    Frame_2.Parent = ScreenGui
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Main"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 0.62)
    TextLabel.Font = Enum.Font.GothamBlack
    TextLabel.Text = "BLOXSTRIKE"
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextScaled = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame_2
    local v2 = TextLabel:Clone()
    v2.Name = "Sub"
    v2.Text = "T R A I N I N G"
    v2.Font = Enum.Font.GothamBold
    v2.Position = UDim2.fromScale(0.005, 0.66)
    v2.Size = UDim2.fromScale(1, 0.3)
    v2.TextColor3 = Color3.fromRGB(235, 235, 235)
    v2.Parent = Frame_2
    local Frame_3 = Instance.new("Frame")
    Frame_3.Name = "Rule"
    Frame_3.BorderSizePixel = 0
    Frame_3.BackgroundColor3 = Color3.fromRGB(230, 120, 40)
    Frame_3.Position = UDim2.fromScale(0.005, 0.635)
    Frame_3.Size = UDim2.fromScale(0.55, 0.025)
    Frame_3.Parent = Frame_2
    ScreenGui.Parent = a1
    return {
        Bar = 0.12,
        Screen = ScreenGui,
        Top = Frame,
        Bottom = v1,
        Title = Frame_2,
        Main = TextLabel,
        Sub = v2,
        Rule = Frame_3,
    }
end

function u5.new(a1) -- Line: 253 -- upvalues: u5 (val), buildActor (val), buildOverlay (val) -- types: a1: table
    local CutFrames, Fps
    local v1 = setmetatable({}, u5)
    v1.Options = a1
    v1.Data = a1.Data
    v1.Fps = a1.Data.Fps
    v1.Duration = a1.Data.Duration
    v1.CutFrames = {}
    for i, j in a1.Data.Events do
        if string.sub(i, 1, 4) == "Shot" and type(j) == "number" then
            CutFrames = v1.CutFrames
            Fps = v1.Fps
            CutFrames[(math.floor(j * Fps + 0.5))] = true
        end
    end
    local Camera = a1.Camera or workspace.CurrentCamera
    v1.Camera = Camera
    local Folder = Instance.new("Folder")
    Folder.Name = "TutorialIntro"
    local Parent = a1.Parent or workspace
    Folder.Parent = Parent
    v1.Folder = Folder
    v1.Actors = {}
    for k, n in a1.Data.Rigs do
        v1.Actors[k] = (buildActor(v1, k, n))
    end
    v1.Truck = a1.TruckBuilder.build(Folder)
    local Map = a1.Map and a1.Map:FindFirstChild("TutorialDoors")
    local DockDoor = Map and Map:FindFirstChild("DockDoor")
    if DockDoor and DockDoor:IsA("Model") then
        v1.DockDoor = DockDoor
        v1.DockDoorClosed = DockDoor:GetPivot()
        v1.DockDoorOffset = DockDoor:GetAttribute("OpenOffset") or Vector3.new(0, 10.5, 0)
    end
    if a1.Gui then
        v1.Overlay = buildOverlay(a1.Gui)
    end
    v1.Started = false
    v1:Update(0)
    return v1
end

function u5.Start(a1) -- Line: 291
    for i, j in a1.Actors do
        j.Track:Play(0, 1, 1)
        j.Hold:Play(0, 1, 1)
        j.LeftArm:Play(0, 0.0001, 1)
    end
    a1.Started = true
    a1.LastClock = nil
end

function u5:Time() -- Line: 304
    for i, j in self.Actors do
        if j.Track.IsPlaying then
            return j.Track.TimePosition
        end
    end
    return self.Duration
end

function u5:Update(a2) -- Line: 314 -- upvalues: sampleTrack (val) -- types: self: table, a2: number?
    local HiddenFrom, LeftArm, LeftArmWeight, v1, v2, v3, v4, v5, v6, v7
    local v8 = math.clamp(a2 or (if not self.Started then 0 else self:Time()), 0, self.Duration)
    local Data = self.Data
    local Fps = self.Fps
    local v9 = if not self.LastClock then 0 else math.clamp(v8 - self.LastClock, 0, 0.1)
    self.LastClock = v8
    local v10 = nil
    local v11 = nil
    local v12 = self
    for i, j in self.Actors, v10, v11 do
        j.Root.CFrame = sampleTrack(j.Rig.Root, v8, Fps)
        if v12.Started then
            v1 = math.min(v8 + v9, v12.Duration)
            LeftArm = j.LeftArm
            LeftArmWeight = j.Rig.LeftArmWeight
            v5 = math.max(0, v1 * Fps)
            v6 = math.floor(v5)
            v7 = #LeftArmWeight
            LeftArm:AdjustWeight(math.max(
                if not (v7 - 1 <= v6) then LeftArmWeight[v6 + 1] + (LeftArmWeight[v6 + 2] - LeftArmWeight[v6 + 1]) * (v5 - v6) else LeftArmWeight[v7],
                0.0001
            ), 0)
        end
        if v12.Started and 0 < j.Track.TimePosition then
            j.Animated = true
        end
        HiddenFrom = j.Rig.HiddenFrom
        v2 = not j.Animated
        if not v2 then
            v2 = false
            if HiddenFrom ~= nil then
                v2 = HiddenFrom <= v8
            end
        end
        if v2 ~= j.Hidden then
            j.Hidden = v2
            v3 = nil
            v4 = nil
            for k, n in j.Parts, v3, v4 do
                n[1].Transparency = if not v2 then n[2] else 1
            end
        end
    end
    local Camera = v12.Camera
    Camera.CameraType = Enum.CameraType.Scriptable
    v10 = v8
    v11 = math.floor(v8 * Fps + 0.01)
    if v12.CutFrames[v11 + 1] then
        v10 = v11 / Fps
    end
    Camera.CFrame = sampleTrack(Data.Camera, v10, Fps)
    local CameraFov = Data.CameraFov
    v2 = math.max(0, v10 * Fps)
    local v13 = math.floor(v2)
    v3 = #CameraFov
    local v14 = if not (v3 - 1 <= v13) then CameraFov[v13 + 1] + (CameraFov[v13 + 2] - CameraFov[v13 + 1]) * (v2 - v13) else CameraFov[v3]
    Camera.FieldOfView = v14
    v14 = math.min(v8, (Data.Truck.SettledFrame - 1) / Fps)
    v12.Options.TruckBuilder.place(v12.Truck, sampleTrack(Data.Truck.Body, v14, Fps), sampleTrack(Data.Truck.Wheels, v14, Fps))
    local Events = Data.Events
    if v12.DockDoor then
        local DockDoor = v12.DockDoor
        local DockDoorClosed = v12.DockDoorClosed
        local DockDoorOffset = v12.DockDoorOffset
        local DockDoorOpen = Events.DockDoorOpen
        if DockDoorOpen then
            local v15 = math.clamp((v8 - DockDoorOpen[1]) / (DockDoorOpen[2] - DockDoorOpen[1]), 0, 1)
            v5 = v15 * v15 * v15 * (v15 * (v15 * 6 - 15) + 10)
        else
            v5 = 0
        end
        DockDoor:PivotTo(DockDoorClosed + DockDoorOffset * v5)
    end
    local Overlay = v12.Overlay
    if Overlay then
        local v16
        local LetterboxRetract = Events.LetterboxRetract
        if LetterboxRetract then
            v4 = math.clamp((v8 - LetterboxRetract[1]) / (LetterboxRetract[2] - LetterboxRetract[1]), 0, 1)
            v2 = v4 * v4 * v4 * (v4 * (v4 * 6 - 15) + 10)
        else
            v2 = 0
        end
        Overlay.Top.Position = UDim2.fromScale(0, -Overlay.Bar * v2)
        Overlay.Bottom.Position = UDim2.fromScale(0, 1 + Overlay.Bar * v2)
        local TitleIn = Events.TitleIn
        if TitleIn then
            v5 = math.clamp((v8 - TitleIn[1]) / (TitleIn[2] - TitleIn[1]), 0, 1)
            v3 = v5 * v5 * v5 * (v5 * (v5 * 6 - 15) + 10)
        else
            v3 = 0
        end
        local TitleOut = Events.TitleOut
        if TitleOut then
            v7 = math.clamp((v8 - TitleOut[1]) / (TitleOut[2] - TitleOut[1]), 0, 1)
            v16 = v7 * v7 * v7 * (v7 * (v7 * 6 - 15) + 10)
        else
            v16 = 0
        end
        v13 = v3 * (1 - v16)
        Overlay.Main.TextTransparency = 1 - v13
        Overlay.Sub.TextTransparency = 1 - v13
        Overlay.Rule.BackgroundTransparency = 1 - v13
        Overlay.Title.Position = UDim2.fromScale(0.035 - (1 - v13) * 0.01, 1 - Overlay.Bar - 0.03)
    end
    return v12.Duration <= v8
end

function u5:Destroy() -- Line: 371
    for i, j in self.Actors do
        j.Track:Stop(0)
        j.Hold:Stop(0)
        j.LeftArm:Stop(0)
    end
    if self.Overlay then
        self.Overlay.Screen:Destroy()
    end
    self.Folder:Destroy()
end

return u5