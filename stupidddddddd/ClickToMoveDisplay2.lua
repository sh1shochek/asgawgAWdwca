-- StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay
-- Decompile time: 8.83 ms

local v1 = {}
local u1 = "rbxasset://textures/ui/traildot.png"
local u2 = "rbxasset://textures/ui/waypoint.png"
local u3 = false
local u9 = UDim2.new(0, 42, 0, 50)
local u13 = Vector2.new(0, 0.5)
local u17 = Vector2.new(0, 1)
local u21 = Vector2.new(0, 0.5)
local u25 = Vector2.new(0.1, 0.5)
local u29 = Vector2.new(-0.1, 0.5)
local u33 = Vector2.new(1.5, 1.5)
local u35 = RaycastParams.new()
u35.FilterType = Enum.RaycastFilterType.Exclude
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserRaycastUpdateAPI = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI")
local LocalPlayer = Players.LocalPlayer

local function CreateWaypointTemplates() -- Line: 55
    -- upvalues: u33 (ref), u3 (ref), u1 (ref), u9 (val), u13 (val), u2 (ref), u21 (val)
    local Part = Instance.new("Part")
    Part.Size = Vector3.new(1, 1, 1)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Name = "TrailDot"
    Part.Transparency = 1
    local ImageHandleAdornment = Instance.new("ImageHandleAdornment")
    ImageHandleAdornment.Name = "TrailDotImage"
    ImageHandleAdornment.Size = u33
    ImageHandleAdornment.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    ImageHandleAdornment.AlwaysOnTop = u3
    ImageHandleAdornment.Image = u1
    ImageHandleAdornment.Adornee = Part
    ImageHandleAdornment.Parent = Part
    local Part_2 = Instance.new("Part")
    Part_2.Size = Vector3.new(2, 2, 2)
    Part_2.Anchored = true
    Part_2.CanCollide = false
    Part_2.Name = "EndWaypoint"
    Part_2.Transparency = 1
    local ImageHandleAdornment_2 = Instance.new("ImageHandleAdornment")
    ImageHandleAdornment_2.Name = "TrailDotImage"
    ImageHandleAdornment_2.Size = u33
    ImageHandleAdornment_2.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    ImageHandleAdornment_2.AlwaysOnTop = u3
    ImageHandleAdornment_2.Image = u1
    ImageHandleAdornment_2.Adornee = Part_2
    ImageHandleAdornment_2.Parent = Part_2
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "EndWaypointBillboard"
    BillboardGui.Size = u9
    BillboardGui.LightInfluence = 0
    BillboardGui.SizeOffset = u13
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Adornee = Part_2
    BillboardGui.Parent = Part_2
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Image = u2
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.new(1, 0, 1, 0)
    ImageLabel.Parent = BillboardGui
    local Part_3 = Instance.new("Part")
    Part_3.Size = Vector3.new(2, 2, 2)
    Part_3.Anchored = true
    Part_3.CanCollide = false
    Part_3.Name = "FailureWaypoint"
    Part_3.Transparency = 1
    local ImageHandleAdornment_3 = Instance.new("ImageHandleAdornment")
    ImageHandleAdornment_3.Name = "TrailDotImage"
    ImageHandleAdornment_3.Size = u33
    ImageHandleAdornment_3.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    ImageHandleAdornment_3.AlwaysOnTop = u3
    ImageHandleAdornment_3.Image = u1
    ImageHandleAdornment_3.Adornee = Part_3
    ImageHandleAdornment_3.Parent = Part_3
    local BillboardGui_2 = Instance.new("BillboardGui")
    BillboardGui_2.Name = "FailureWaypointBillboard"
    BillboardGui_2.Size = u9
    BillboardGui_2.LightInfluence = 0
    BillboardGui_2.SizeOffset = u21
    BillboardGui_2.AlwaysOnTop = true
    BillboardGui_2.Adornee = Part_3
    BillboardGui_2.Parent = Part_3
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0, 0, 0, 0)
    Frame.Position = UDim2.new(0.5, 0, 1, 0)
    Frame.Parent = BillboardGui_2
    local ImageLabel_2 = Instance.new("ImageLabel")
    ImageLabel_2.Image = u2
    ImageLabel_2.BackgroundTransparency = 1
    ImageLabel_2.Position = UDim2.new(0, -u9.X.Offset / 2, 0, -u9.Y.Offset)
    ImageLabel_2.Size = u9
    ImageLabel_2.Parent = Frame
    return Part, Part_2, Part_3
end

local u76, u77, u78 = CreateWaypointTemplates()

local function getTrailDotParent() -- Line: 141 -- upvalues: Workspace (val)
    local CurrentCamera = Workspace.CurrentCamera
    local ClickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay")
    if not ClickToMoveDisplay then
        ClickToMoveDisplay = Instance.new("Model")
        ClickToMoveDisplay.Name = "ClickToMoveDisplay"
        ClickToMoveDisplay.Parent = CurrentCamera
    end
    return ClickToMoveDisplay
end

local function placePathWaypoint(a1, a2) -- Line: 152
    -- upvalues: UserRaycastUpdateAPI (val), u35 (val), Workspace (val), LocalPlayer (val)
    local v1, v2
    if not UserRaycastUpdateAPI then
        local v3, v4
        v1 = Ray.new(a2 + Vector3.new(0, 2.5, 0), (Vector3.new(0, -10, 0)))
        v2 = Workspace
        local v5 = {Workspace.CurrentCamera, LocalPlayer.Character}
        v2, v3, v4 = v2:FindPartOnRayWithIgnoreList(v1, v5)
        if v2 then
            a1.CFrame = CFrame.new(v3, v3 + v4)
            local CurrentCamera_2 = Workspace.CurrentCamera
            v5 = CurrentCamera_2:FindFirstChild("ClickToMoveDisplay")
            if not v5 then
                v5 = Instance.new("Model")
                v5.Name = "ClickToMoveDisplay"
                v5.Parent = CurrentCamera_2
            end
            a1.Parent = v5
        end
        return
    end
    u35.FilterDescendantsInstances = {Workspace.CurrentCamera, LocalPlayer.Character}
    v1 = Workspace:Raycast(a2 + Vector3.new(0, 2.5, 0), Vector3.new(-0, -10, -0), u35)
    if not v1 then
        return
    end
    a1.CFrame = CFrame.lookAlong(v1.Position, v1.Normal)
    local CurrentCamera = Workspace.CurrentCamera
    v2 = CurrentCamera:FindFirstChild("ClickToMoveDisplay")
    if not v2 then
        v2 = Instance.new("Model")
        v2.Name = "ClickToMoveDisplay"
        v2.Parent = CurrentCamera
    end
    a1.Parent = v2
end

local u81 = {}
u81.__index = u81

function u81:Destroy() -- Line: 177
    self.DisplayModel:Destroy()
end

function u81.NewDisplayModel(a1, a2) -- Line: 181 -- upvalues: u76 (ref), placePathWaypoint (val)
    local v1 = u76:Clone()
    placePathWaypoint(v1, a2)
    return v1
end

function u81.new(a1, a2) -- Line: 187 -- upvalues: u81 (val)
    local v1 = setmetatable({}, u81)
    v1.DisplayModel = v1:NewDisplayModel(a1)
    v1.ClosestWayPoint = a2
    return v1
end

local u85 = {}
u85.__index = u85

function u85:Destroy() -- Line: 199
    self.Destroyed = true
    self.Tween:Cancel()
    self.DisplayModel:Destroy()
end

function u85.NewDisplayModel(a1, a2) -- Line: 205 -- upvalues: u77 (ref), placePathWaypoint (val)
    local v1 = u77:Clone()
    placePathWaypoint(v1, a2)
    return v1
end

function u85:CreateTween() -- Line: 211 -- upvalues: TweenService (val), u17 (val)
    local v1 = TweenService:Create(
        self.DisplayModel.EndWaypointBillboard,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true),
        {SizeOffset = u17}
    )
    v1:Play()
    return v1
end

function u85:TweenInFrom(a2) -- Line: 222 -- upvalues: TweenService (val) -- types: self: table, a2: vector
    local v1 = a2 - self.DisplayModel.Position
    self.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, v1.Y, 0)
    local v2 = TweenService:Create(
        self.DisplayModel.EndWaypointBillboard,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {StudsOffset = Vector3.new(0, 0, 0)}
    )
    v2:Play()
    return v2
end

function u85.new(a1, a2, a3) -- Line: 236 -- upvalues: u85 (val) -- types: a1: vector, a2: number?, a3: vector?
    local u6 = setmetatable({}, u85)
    u6.DisplayModel = u6:NewDisplayModel(a1)
    u6.Destroyed = false
    if not a3 or not (5 < (a3 - a1).Magnitude) then
        u6.Tween = u6:CreateTween()
    else
        u6.Tween = u6:TweenInFrom(a3)
        coroutine.wrap(function() -- Line: 243 -- upvalues: u6 (val)
            u6.Tween.Completed:Wait()
            if not u6.Destroyed then
                u6.Tween = u6:CreateTween()
            end
        end)()
    end
    u6.ClosestWayPoint = a2
    return u6
end

local u91 = {}
u91.__index = u91

function u91:Hide() -- Line: 260
    self.DisplayModel.Parent = nil
end

function u91:Destroy() -- Line: 264
    self.DisplayModel:Destroy()
end

function u91.NewDisplayModel(a1, a2) -- Line: 268
    -- upvalues: u78 (ref), placePathWaypoint (val), UserRaycastUpdateAPI (val), u35 (val), Workspace (val)
    -- upvalues: LocalPlayer (val)
    local v1, v2
    local v3 = u78:Clone()
    placePathWaypoint(v3, a2)
    if not UserRaycastUpdateAPI then
        local v4, v5
        v1 = Ray.new(a2 + Vector3.new(0, 2.5, 0), (Vector3.new(0, -10, 0)))
        v2 = Workspace
        local v6 = {Workspace.CurrentCamera, LocalPlayer.Character}
        v2, v4, v5 = v2:FindPartOnRayWithIgnoreList(v1, v6)
        if v2 then
            v3.CFrame = CFrame.new(v4, v4 + v5)
            local CurrentCamera_2 = Workspace.CurrentCamera
            v6 = CurrentCamera_2:FindFirstChild("ClickToMoveDisplay")
            if not v6 then
                v6 = Instance.new("Model")
                v6.Name = "ClickToMoveDisplay"
                v6.Parent = CurrentCamera_2
            end
            v3.Parent = v6
        end
        return v3
    end
    u35.FilterDescendantsInstances = {Workspace.CurrentCamera, LocalPlayer.Character}
    v1 = Workspace:Raycast(a2 + Vector3.new(0, 2.5, 0), Vector3.new(-0, -10, -0), u35)
    if not v1 then
        return v3
    end
    v3.CFrame = CFrame.lookAlong(v1.Position, v1.Normal)
    local CurrentCamera = Workspace.CurrentCamera
    v2 = CurrentCamera:FindFirstChild("ClickToMoveDisplay")
    if not v2 then
        v2 = Instance.new("Model")
        v2.Name = "ClickToMoveDisplay"
        v2.Parent = CurrentCamera
    end
    v3.Parent = v2
    return v3
end

function u91:RunFailureTween() -- Line: 292 -- upvalues: TweenService (val), u25 (val), u29 (val), u21 (val)
    wait(0.125)
    local v1 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v2 = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, v1, {SizeOffset = u25})
    v2:Play()
    TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, v1, {Rotation = 10}):Play()
    v2.Completed:wait()
    local v3 = TweenService:Create(
        self.DisplayModel.FailureWaypointBillboard,
        TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true),
        {SizeOffset = u29}
    )
    v3:Play()
    v1 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)
    TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, v1, {ImageColor3 = Color3.new(0.75, 0.75, 0.75)}):Play()
    TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, v1, {Rotation = -10}):Play()
    v3.Completed:wait()
    v1 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v4 = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, v1, {SizeOffset = u21})
    v4:Play()
    TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, v1, {Rotation = 0}):Play()
    v4.Completed:wait()
    wait(0.125)
end

function u91.new(a1) -- Line: 341 -- upvalues: u91 (val)
    local v1 = setmetatable({}, u91)
    v1.DisplayModel = v1:NewDisplayModel(a1)
    return v1
end

local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://2874840706"
local u101 = nil

local function getFailureAnimationTrack(a1) -- Line: 355 -- upvalues: u101 (ref), Animation (val)
    if a1 == nil then
        return u101
    end
    u101 = a1:LoadAnimation(Animation)
    assert(u101, "")
    u101.Priority = Enum.AnimationPriority.Action
    u101.Looped = false
    return u101
end

local function findPlayerHumanoid() -- Line: 366 -- upvalues: LocalPlayer (val)
    local Character = LocalPlayer.Character
    if Character then
        return Character:FindFirstChildOfClass("Humanoid")
    end
end

local function createTrailDots(a1, a2) -- Line: 373 -- upvalues: u81 (val), u85 (val) -- types: a1: table, a2: vector
    local v1, v2
    local v3 = {}
    local v4 = 1
    local v5 = #a1 - 1
    for i = 1, v5 do
        v1 = (a1[i].Position - a1[#a1].Position).Magnitude < 3
        v2 = false
        if i % 2 == 0 then
            v2 = not v1
        end
        if v2 then
            v3[v4] = (u81.new(a1[i].Position, i))
            v4 = v4 + 1
        end
    end
    table.insert(v3, (u85.new(a1[#a1].Position, #a1, a2)))
    local v6 = {}
    v4 = 1
    for j = #v3, 1, -1 do
        v6[v4] = v3[j]
        v4 = v4 + 1
    end
    return v6
end

local function getTrailDotScale(a1, a2) -- Line: 398 -- types: a1: number, a2: userdata
    return a2 * (math.clamp(a1 - 10, 0, 90) / 90 * 1.5 + 1)
end

local u106 = 0

function v1.CreatePathDisplay(a1, a2) -- Line: 407
    -- upvalues: u106 (ref), createTrailDots (val), RunService (val), Workspace (val), u33 (ref)
    u106 = u106 + 1
    local u7 = createTrailDots(a1, a2)

    local function removePathBeforePoint(a1) -- Line: 411 -- upvalues: u7 (val)
        local v1
        for i = #u7, 1, -1 do
            v1 = u7[i]
            if not (v1.ClosestWayPoint <= a1) then
                break
            end
            v1:Destroy()
            u7[i] = nil
        end
    end

    local u11 = "ClickToMoveResizeTrail" .. u106
    RunService:BindToRenderStep(u11, Enum.RenderPriority.Camera.Value - 1, function() -- Line: 425 -- upvalues: u7 (val), RunService (upval), u11 (val), Workspace (upval), u33 (upval)
        local Magnitude, TrailDotImage
        if #u7 == 0 then
            RunService:UnbindFromRenderStep(u11)
            return
        end
        local p = Workspace.CurrentCamera.CFrame.p
        local v1 = #u7
        for i = 1, v1 do
            TrailDotImage = u7[i].DisplayModel:FindFirstChild("TrailDotImage")
            if TrailDotImage then
                Magnitude = (u7[i].DisplayModel.Position - p).Magnitude
                TrailDotImage.Size = u33 * (math.clamp(Magnitude - 10, 0, 90) / 90 * 1.5 + 1)
            end
        end
    end)
    return function() -- Line: 441 -- upvalues: removePathBeforePoint (val), a1 (val)
        removePathBeforePoint(#a1)
    end, removePathBeforePoint
end

local u108 = nil

function v1.DisplayFailureWaypoint(a1) -- Line: 449 -- upvalues: u108 (ref), u91 (val)
    if u108 then
        u108:Hide()
    end
    local u10 = u91.new(a1)
    u108 = u10
    coroutine.wrap(function() -- Line: 455 -- upvalues: u10 (ref)
        u10:RunFailureTween()
        u10:Destroy()
        u10 = nil
    end)()
end

function v1.CreateEndWaypoint(a1) -- Line: 462 -- upvalues: u85 (val)
    return u85.new(a1)
end

function v1.PlayFailureAnimation() -- Line: 466 -- upvalues: LocalPlayer (val), u101 (ref), Animation (val)
    local Character = LocalPlayer.Character
    local v1 = if not Character then nil else Character:FindFirstChildOfClass("Humanoid")
    if v1 then
        if v1 ~= nil then
            u101 = v1:LoadAnimation(Animation)
            assert(u101, "")
            u101.Priority = Enum.AnimationPriority.Action
            u101.Looped = false
        end
        u101:Play()
    end
end

function v1.CancelFailureAnimation() -- Line: 474 -- upvalues: u101 (ref)
    if u101 ~= nil and u101.IsPlaying then
        u101:Stop()
    end
end

function v1.SetWaypointTexture(a1) -- Line: 480
    -- upvalues: u1 (ref), u76 (ref), u77 (ref), u78 (ref), CreateWaypointTemplates (val)
    u1 = a1
    local v1, v2, v3 = CreateWaypointTemplates()
    u76 = v1
    u77 = v2
    u78 = v3
end

function v1.GetWaypointTexture() -- Line: 485 -- upvalues: u1 (ref)
    return u1
end

function v1.SetWaypointRadius(a1) -- Line: 489
    -- upvalues: u33 (ref), u76 (ref), u77 (ref), u78 (ref), CreateWaypointTemplates (val)
    u33 = Vector2.new(a1, a1)
    local v1, v2, v3 = CreateWaypointTemplates()
    u76 = v1
    u77 = v2
    u78 = v3
end

function v1.GetWaypointRadius() -- Line: 494 -- upvalues: u33 (ref)
    return u33.X
end

function v1.SetEndWaypointTexture(a1) -- Line: 498
    -- upvalues: u2 (ref), u76 (ref), u77 (ref), u78 (ref), CreateWaypointTemplates (val)
    u2 = a1
    local v1, v2, v3 = CreateWaypointTemplates()
    u76 = v1
    u77 = v2
    u78 = v3
end

function v1.GetEndWaypointTexture() -- Line: 503 -- upvalues: u2 (ref)
    return u2
end

function v1.SetWaypointsAlwaysOnTop(a1) -- Line: 507
    -- upvalues: u3 (ref), u76 (ref), u77 (ref), u78 (ref), CreateWaypointTemplates (val)
    u3 = a1
    local v1, v2, v3 = CreateWaypointTemplates()
    u76 = v1
    u77 = v2
    u78 = v3
end

function v1.GetWaypointsAlwaysOnTop() -- Line: 512 -- upvalues: u3 (ref)
    return u3
end

return v1