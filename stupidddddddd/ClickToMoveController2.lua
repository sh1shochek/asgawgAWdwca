-- StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.ClickToMoveController
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.ClickToMoveController
-- Decompile time: 29.10 ms

local success, result = pcall(function() -- Line: 10
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end)
local u4 = success and result
local success_2, result_2 = pcall(function() -- Line: 14
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end)
local u9 = success_2 and result_2
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserRaycastUpdateAPI = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI")
local u66 = true
local u67 = true
local u68 = false
local u69 = 1
local u70 = 8
local u71 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true,
}
local LocalPlayer = Players.LocalPlayer
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local u94 = RaycastParams.new()
u94.FilterType = Enum.RaycastFilterType.Exclude
local u96 = {}
if not UserRaycastUpdateAPI then
    local FindCharacterAncestor, Raycast

    function FindCharacterAncestor(a1) -- Line: 65 -- upvalues: FindCharacterAncestor (val)
        if not a1 then
            return
        end
        local Humanoid = a1:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            return a1, Humanoid
        end
        return FindCharacterAncestor(a1.Parent)
    end

    u96.FindCharacterAncestor = FindCharacterAncestor

    function Raycast(a1, a2, a3) -- Line: 77
        -- upvalues: Workspace (val), FindCharacterAncestor (val), Raycast (val)
        local v1 = a3 or {}
        local v2, v3, v4, v5 = Workspace:FindPartOnRayWithIgnoreList(a1, v1)
        if not v2 then
            return nil, nil
        end
        if a2 and v2.CanCollide == false then
            local v6
            if not v2 then
                v6 = nil
            else
                local Humanoid = v2:FindFirstChildOfClass("Humanoid")
                if not Humanoid then
                    local v7, v8 = FindCharacterAncestor(v2.Parent)
                    v6 = v8
                else
                    v6 = Humanoid
                end
            end
            if v6 == nil then
                table.insert(v1, v2)
                return Raycast(a1, a2, v1)
            end
        end
        return v2, v3, v4, v5
    end

    u96.Raycast = Raycast
end
local u99 = {}

local function findPlayerHumanoid(a1) -- Line: 99 -- upvalues: u99 (val) -- types: a1: userdata
    local Character = a1 and a1.Character
    if not Character then
        return
    end
    local v1 = u99[a1]
    if v1 and v1.Parent == Character then
        return v1
    end
    u99[a1] = nil
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        u99[a1] = Humanoid
    end
    return Humanoid
end

local u101 = nil
local u102 = nil
local u103 = nil
local u104 = nil

local function GetCharacter() -- Line: 123 -- upvalues: LocalPlayer (val)
    return LocalPlayer and LocalPlayer.Character
end

local function UpdateIgnoreTag(a1) -- Line: 127
    -- upvalues: u102 (ref), u103 (ref), u104 (ref), u101 (ref), LocalPlayer (val), CollectionService (val)
    if a1 == u102 then
        return
    end
    if u103 then
        u103:Disconnect()
        u103 = nil
    end
    if u104 then
        u104:Disconnect()
        u104 = nil
    end
    u102 = a1
    u101 = {LocalPlayer and LocalPlayer.Character}
    if u102 ~= nil then
        for i, v in ipairs((CollectionService:GetTagged(u102))) do
            table.insert(u101, v)
        end
        u103 = (CollectionService:GetInstanceAddedSignal(u102)):Connect(function(a1) -- Line: 147 -- upvalues: u101 (upval)
            table.insert(u101, a1)
        end)
        u104 = (CollectionService:GetInstanceRemovedSignal(u102)):Connect(function(a1) -- Line: 151 -- upvalues: u101 (upval)
            local v1 = #u101
            for i = 1, v1 do
                if u101[i] == a1 then
                    u101[i] = u101[#u101]
                    table.remove(u101)
                    return
                end
            end
        end)
    end
end

local function getIgnoreList() -- Line: 163 -- upvalues: u101 (ref), LocalPlayer (val)
    if u101 then
        return u101
    end
    u101 = {}
    assert(u101, "")
    local Character = LocalPlayer and LocalPlayer.Character
    table.insert(u101, Character)
    return u101
end

local function minV(a1, a2) -- Line: 173 -- types: a1: vector, a2: vector
    return (Vector3.new(math.min(a1.X, a2.X), math.min(a1.Y, a2.Y), (math.min(a1.Z, a2.Z))))
end

local function maxV(a1, a2) -- Line: 176
    return (Vector3.new(math.max(a1.X, a2.X), math.max(a1.Y, a2.Y), (math.max(a1.Z, a2.Z))))
end

local function getCollidableExtentsSize(a1) -- Line: 179 -- types: a1: userdata?
    if a1 ~= nil and a1.PrimaryPart ~= nil then
        local v1, v2, v3, v4
        assert(a1, "")
        assert(a1.PrimaryPart, "")
        local v5 = a1.PrimaryPart.CFrame:Inverse()
        local v6 = Vector3.new((1 / 0), (1 / 0), (1 / 0))
        local v7 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))
        for k, v in pairs(a1:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v4 = v5 * v.CFrame
                v1 = Vector3.new(v.Size.X / 2, v.Size.Y / 2, v.Size.Z / 2)
                for i, i2 in ipairs({
                    Vector3.new(v1.X, v1.Y, v1.Z),
                    Vector3.new(v1.X, v1.Y, -v1.Z),
                    Vector3.new(v1.X, -v1.Y, v1.Z),
                    Vector3.new(v1.X, -v1.Y, -v1.Z),
                    Vector3.new(-v1.X, v1.Y, v1.Z),
                    Vector3.new(-v1.X, v1.Y, -v1.Z),
                    Vector3.new(-v1.X, -v1.Y, v1.Z),
                    (Vector3.new(-v1.X, -v1.Y, -v1.Z)),
                }) do
                    v2 = v4 * i2
                    v3 = v6
                    v6 = Vector3.new(math.min(v3.X, v2.X), math.min(v3.Y, v2.Y), (math.min(v3.Z, v2.Z)))
                    v3 = v7
                    v7 = Vector3.new(math.max(v3.X, v2.X), math.max(v3.Y, v2.Y), (math.max(v3.Z, v2.Z)))
                end
            end
        end
        local v8 = v7 - v6
        if not (v8.X < 0) and not (v8.Y < 0) and not (v8.Z < 0) then
            return v8
        end
        return nil
    end
end

local function Pather(a1, a2, a3) -- Line: 214
    -- upvalues: u68 (ref), LocalPlayer (val), u99 (val), u69 (ref), u4 (val), getCollidableExtentsSize (val), u9 (val)
    -- upvalues: PathfindingService (val), u66 (ref), ClickToMoveDisplay (val), u70 (ref), UserRaycastUpdateAPI (val)
    -- upvalues: u94 (val), u101 (ref), Workspace (val)
    local v1, v2, v3, v4, v5, v6
    local u3 = {}
    if a3 == nil then
        v2 = u68
        v3 = true
    else
        v2 = a3
        v3 = a3
    end
    u3.Cancelled = false
    u3.Started = false
    u3.Finished = Instance.new("BindableEvent")
    u3.PathFailed = Instance.new("BindableEvent")
    u3.PathComputing = false
    u3.PathComputed = false
    u3.OriginalTargetPoint = a1
    u3.TargetPoint = a1
    u3.TargetSurfaceNormal = a2
    u3.DiedConn = nil
    u3.SeatedConn = nil
    u3.BlockedConn = nil
    u3.TeleportedConn = nil
    u3.CurrentPoint = 0
    u3.HumanoidOffsetFromPath = Vector3.new(0, 0, 0)
    u3.CurrentWaypointPosition = nil
    u3.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
    u3.CurrentWaypointPlaneDistance = 0
    u3.CurrentWaypointNeedsJump = false
    u3.CurrentHumanoidPosition = Vector3.new(0, 0, 0)
    u3.CurrentHumanoidVelocity = 0
    u3.NextActionMoveDirection = Vector3.new(0, 0, 0)
    u3.NextActionJump = false
    u3.Timeout = 0
    local v7 = LocalPlayer
    local Character = v7 and v7.Character
    if not Character then
        v4 = nil
    else
        v6 = u99[v7]
        if not v6 or v6.Parent ~= Character then
            u99[v7] = nil
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                u99[v7] = Humanoid
            end
            v4 = Humanoid
        else
            v4 = v6
        end
    end
    u3.Humanoid = v4
    u3.OriginPoint = nil
    u3.AgentCanFollowPath = false
    u3.DirectPath = false
    u3.DirectPathRiseFirst = false
    u3.stopTraverseFunc = nil
    u3.setPointFunc = nil
    u3.pointList = nil
    local Humanoid_2 = u3.Humanoid and u3.Humanoid.RootPart
    if Humanoid_2 then
        u3.OriginPoint = Humanoid_2.CFrame.Position
        v7 = 2
        v5 = 5
        v6 = true
        local SeatPart = u3.Humanoid.SeatPart
        if not SeatPart or not SeatPart:IsA("VehicleSeat") then
            v1 = nil
            if u4 then
                local Character_2 = LocalPlayer and LocalPlayer.Character
                if Character_2 ~= nil then
                    v1 = getCollidableExtentsSize(Character_2)
                end
            end
            if v1 == nil then
                v1 = (LocalPlayer and LocalPlayer.Character):GetExtentsSize()
            end
            assert(v1, "")
            v7 = u69 * 0.5 * math.sqrt(v1.X * v1.X + v1.Z * v1.Z)
            v5 = u69 * v1.Y
            v6 = 0 < u3.Humanoid.JumpPower
            u3.AgentCanFollowPath = true
            u3.DirectPath = v2
            u3.DirectPathRiseFirst = u3.Humanoid.Sit
        else
            v1 = SeatPart:FindFirstAncestorOfClass("Model")
            if v1 then
                local PrimaryPart = v1.PrimaryPart
                v1.PrimaryPart = SeatPart
                if v3 then
                    local ExtentsSize = v1:GetExtentsSize()
                    v7 = u69 * 0.5 * math.sqrt(ExtentsSize.X * ExtentsSize.X + ExtentsSize.Z * ExtentsSize.Z)
                    v5 = u69 * ExtentsSize.Y
                    v6 = false
                    u3.AgentCanFollowPath = true
                    u3.DirectPath = v3
                end
                v1.PrimaryPart = PrimaryPart
            end
        end
        if not u9 then
            u3.pathResult = PathfindingService:CreatePath({AgentRadius = v7, AgentHeight = v5, AgentCanJump = v6})
        else
            u3.pathResult = PathfindingService:CreatePath({AgentCanClimb = true, AgentRadius = v7, AgentHeight = v5, AgentCanJump = v6})
        end
    end

    function u3.Cleanup(a1) -- Line: 332 -- upvalues: u3 (val)
        if u3.stopTraverseFunc then
            u3.stopTraverseFunc()
            u3.stopTraverseFunc = nil
        end
        if u3.BlockedConn then
            u3.BlockedConn:Disconnect()
            u3.BlockedConn = nil
        end
        if u3.DiedConn then
            u3.DiedConn:Disconnect()
            u3.DiedConn = nil
        end
        if u3.SeatedConn then
            u3.SeatedConn:Disconnect()
            u3.SeatedConn = nil
        end
        if u3.TeleportedConn then
            u3.TeleportedConn:Disconnect()
            u3.TeleportedConn = nil
        end
        u3.Started = false
    end

    function u3.Cancel(a1) -- Line: 361 -- upvalues: u3 (val)
        u3.Cancelled = true
        u3:Cleanup()
    end

    function u3.IsActive(a1) -- Line: 366 -- upvalues: u3 (val)
        return u3.AgentCanFollowPath and u3.Started and not u3.Cancelled
    end

    function u3.OnPathInterrupted(a1) -- Line: 370 -- upvalues: u3 (val)
        u3.Cancelled = true
        u3:OnPointReached(false)
    end

    function u3.ComputePath(a1) -- Line: 376 -- upvalues: u3 (val)
        if not u3.OriginPoint then
            return
        end
        if not u3.PathComputed and not u3.PathComputing then
            u3.PathComputing = true
            if u3.AgentCanFollowPath then
                if not u3.DirectPath then
                    u3.pathResult:ComputeAsync(u3.OriginPoint, u3.TargetPoint)
                    u3.pointList = u3.pathResult:GetWaypoints()
                    u3.BlockedConn = u3.pathResult.Blocked:Connect(function(a1) -- Line: 390 -- upvalues: u3 (upval)
                        u3:OnPathBlocked(a1)
                    end)
                    u3.PathComputed = u3.pathResult.Status == Enum.PathStatus.Success
                else
                    u3.pointList = {
                        PathWaypoint.new(u3.OriginPoint, Enum.PathWaypointAction.Walk),
                        (PathWaypoint.new(
                            u3.TargetPoint,
                            u3.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk
                        )),
                    }
                    u3.PathComputed = true
                end
            end
            u3.PathComputing = false
            return
        end
    end

    function u3.IsValidPath(a1) -- Line: 398 -- upvalues: u3 (val)
        u3:ComputePath()
        return u3.PathComputed and u3.AgentCanFollowPath
    end

    u3.Recomputing = false

    function u3.OnPathBlocked(a1, a2) -- Line: 404 -- upvalues: u3 (val), u66 (upval), ClickToMoveDisplay (upval)
        if u3.CurrentPoint <= a2 and not u3.Recomputing then
            u3.Recomputing = true
            if u3.stopTraverseFunc then
                u3.stopTraverseFunc()
                u3.stopTraverseFunc = nil
            end
            u3.OriginPoint = u3.Humanoid.RootPart.CFrame.p
            u3.pathResult:ComputeAsync(u3.OriginPoint, u3.TargetPoint)
            u3.pointList = u3.pathResult:GetWaypoints()
            if #u3.pointList > 0 then
                u3.HumanoidOffsetFromPath = u3.pointList[1].Position - u3.OriginPoint
            end
            u3.PathComputed = u3.pathResult.Status == Enum.PathStatus.Success
            if u66 then
                local v1 = u3
                local v2 = u3
                local v3, v4 = ClickToMoveDisplay.CreatePathDisplay(u3.pointList)
                v1.stopTraverseFunc = v3
                v2.setPointFunc = v4
            end
            if not u3.PathComputed then
                u3.PathFailed:Fire()
                u3:Cleanup()
            else
                u3.CurrentPoint = 1
                u3:OnPointReached(true)
            end
            u3.Recomputing = false
            return
        end
    end

    function u3.OnRenderStepped(a1, a2) -- Line: 440 -- upvalues: u3 (val), u70 (upval) -- types: a1: table, a2: number
        if u3.Started and not u3.Cancelled then
            u3.Timeout = u3.Timeout + a2
            local Timeout = u3.Timeout
            if u70 < Timeout then
                u3:OnPointReached(false)
                return
            end
            u3.CurrentHumanoidPosition = u3.Humanoid.RootPart.Position + u3.HumanoidOffsetFromPath
            u3.CurrentHumanoidVelocity = u3.Humanoid.RootPart.Velocity
            while u3.Started do
                if not u3:IsCurrentWaypointReached() then
                    break
                end
                u3:OnPointReached(true)
            end
            if u3.Started then
                u3.NextActionMoveDirection = u3.CurrentWaypointPosition - u3.CurrentHumanoidPosition
                if not (1e-06 < u3.NextActionMoveDirection.Magnitude) then
                    u3.NextActionMoveDirection = Vector3.new(0, 0, 0)
                else
                    u3.NextActionMoveDirection = u3.NextActionMoveDirection.Unit
                end
                if u3.CurrentWaypointNeedsJump then
                    u3.NextActionJump = true
                    u3.CurrentWaypointNeedsJump = false
                    return
                end
                u3.NextActionJump = false
            end
        end
    end

    function u3.IsCurrentWaypointReached(a1) -- Line: 478 -- upvalues: u3 (val)
        local v1
        if if u3.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then true else (u3.CurrentWaypointPlaneNormal:Dot(u3.CurrentHumanoidPosition)) - u3.CurrentWaypointPlaneDistance < math.max(1, 0.0625 * -(u3.CurrentWaypointPlaneNormal:Dot(u3.CurrentHumanoidVelocity))) then
            u3.CurrentWaypointPosition = nil
            u3.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            u3.CurrentWaypointPlaneDistance = 0
        end
        return v1
    end

    function u3.OnPointReached(a1, a2) -- Line: 504 -- upvalues: u3 (val)
        if a2 and not u3.Cancelled then
            if u3.setPointFunc then
                u3.setPointFunc(u3.CurrentPoint)
            end
            local v1 = u3.CurrentPoint + 1
            if #u3.pointList < v1 then
                if u3.stopTraverseFunc then
                    u3.stopTraverseFunc()
                end
                u3.Finished:Fire()
                u3:Cleanup()
                return
            end
            local v2 = u3.pointList[u3.CurrentPoint]
            local v3 = u3.pointList[v1]
            local State = u3.Humanoid:GetState()
            local v4 = true
            if State ~= Enum.HumanoidStateType.FallingDown then
                v4 = true
                if State ~= Enum.HumanoidStateType.Freefall then
                    v4 = State == Enum.HumanoidStateType.Jumping
                end
            end
            if v4 then
                local v5 = v3.Action == Enum.PathWaypointAction.Jump
                if not v5 and 1 < u3.CurrentPoint then
                    local v6 = v2.Position - u3.pointList[u3.CurrentPoint - 1].Position
                    local v7 = v3.Position - v2.Position
                    v5 = ((Vector2.new(v6.x, v6.z)).Unit:Dot((Vector2.new(v7.x, v7.z)).Unit)) < 0.996
                end
                if v5 then
                    u3.Humanoid.FreeFalling:Wait()
                    wait(0.1)
                end
            end
            u3:MoveToNextWayPoint(v2, v3, v1)
            return
        end
        u3.PathFailed:Fire()
        u3:Cleanup()
    end

    function u3.MoveToNextWayPoint(a1, a2, a3, a4) -- Line: 567
        -- upvalues: u3 (val), u9 (upval)
        u3.CurrentWaypointPlaneNormal = a2.Position - a3.Position
        if not u9 or a3.Label ~= "Climb" then
            u3.CurrentWaypointPlaneNormal = Vector3.new(u3.CurrentWaypointPlaneNormal.X, 0, u3.CurrentWaypointPlaneNormal.Z)
        end
        if not (1e-06 < u3.CurrentWaypointPlaneNormal.Magnitude) then
            u3.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            u3.CurrentWaypointPlaneDistance = 0
        else
            u3.CurrentWaypointPlaneNormal = u3.CurrentWaypointPlaneNormal.Unit
            u3.CurrentWaypointPlaneDistance = u3.CurrentWaypointPlaneNormal:Dot(a3.Position)
        end
        u3.CurrentWaypointNeedsJump = a3.Action == Enum.PathWaypointAction.Jump
        u3.CurrentWaypointPosition = a3.Position
        u3.CurrentPoint = a4
        u3.Timeout = 0
    end

    function u3.Start(a1, a2) -- Line: 599 -- upvalues: u3 (val), ClickToMoveDisplay (upval), u66 (upval)
        if not u3.AgentCanFollowPath then
            u3.PathFailed:Fire()
            return
        end
        if u3.Started then
            return
        end
        u3.Started = true
        ClickToMoveDisplay.CancelFailureAnimation()
        if u66 then
            if a2 == nil or a2 then
                local v1 = u3
                local v2 = u3
                local v3, v4 = ClickToMoveDisplay.CreatePathDisplay(u3.pointList, u3.OriginalTargetPoint)
                v1.stopTraverseFunc = v3
                v2.setPointFunc = v4
            end
        end
        if not (#u3.pointList > 0) then
            u3.PathFailed:Fire()
            if u3.stopTraverseFunc then
                u3.stopTraverseFunc()
            end
            return
        end
        u3.HumanoidOffsetFromPath = Vector3.new(0, u3.pointList[1].Position.Y - u3.OriginPoint.Y, 0)
        u3.CurrentHumanoidPosition = u3.Humanoid.RootPart.Position + u3.HumanoidOffsetFromPath
        u3.CurrentHumanoidVelocity = u3.Humanoid.RootPart.Velocity
        u3.SeatedConn = u3.Humanoid.Seated:Connect(function(a1, a2) -- Line: 626 -- upvalues: u3 (upval)
            u3:OnPathInterrupted()
        end)
        u3.DiedConn = u3.Humanoid.Died:Connect(function() -- Line: 627 -- upvalues: u3 (upval)
            u3:OnPathInterrupted()
        end)
        u3.TeleportedConn = (u3.Humanoid.RootPart:GetPropertyChangedSignal("CFrame")):Connect(function() -- Line: 628 -- upvalues: u3 (upval)
            u3:OnPathInterrupted()
        end)
        u3.CurrentPoint = 1
        u3:OnPointReached(true)
    end

    v7 = u3.TargetPoint + u3.TargetSurfaceNormal * 1.5
    if not UserRaycastUpdateAPI then
        local v8
        v1 = (Ray.new(v7, (Vector3.new(0, -50, 0))))
        if not u101 then
            u101 = {}
            assert(u101, "")
            local Character_5 = LocalPlayer and LocalPlayer.Character
            table.insert(u101, Character_5)
        end
        v6, v8 = Workspace:FindPartOnRayWithIgnoreList(v1, u101)
        if v6 then
            u3.TargetPoint = v8
        end
    else
        if not u101 then
            u101 = {}
            assert(u101, "")
            local Character_4 = LocalPlayer and LocalPlayer.Character
            table.insert(u101, Character_4)
        end
        u94.FilterDescendantsInstances = u101
        v5 = Workspace:Raycast(v7, Vector3.new(-0, -50, -0), u94)
        if v5 then
            u3.TargetPoint = v5.Position
        end
    end
    u3:ComputePath()
    return u3
end

local function CheckAlive() -- Line: 664 -- upvalues: LocalPlayer (val), u99 (val)
    local v1
    local v2 = LocalPlayer
    local Character = v2 and v2.Character
    if not Character then
        v1 = nil
    else
        local v3 = u99[v2]
        if not v3 or v3.Parent ~= Character then
            u99[v2] = nil
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                u99[v2] = Humanoid
            end
            v1 = Humanoid
        else
            v1 = v3
        end
    end
    v2 = false
    if v1 ~= nil then
        v2 = 0 < v1.Health
    end
    return v2
end

local function GetEquippedTool(a1) -- Line: 669 -- types: a1: userdata?
    if a1 ~= nil then
        for k, v in pairs(a1:GetChildren()) do
            if v:IsA("Tool") then
                return v
            end
        end
    end
end

local u127 = nil
local u128 = nil
local u129 = nil

local function CleanupPath() -- Line: 684 -- upvalues: u127 (ref), u128 (ref), u129 (ref)
    if u127 then
        u127:Cancel()
        u127 = nil
    end
    if u128 then
        u128:Disconnect()
        u128 = nil
    end
    if u129 then
        u129:Disconnect()
        u129 = nil
    end
end

local function HandleMoveTo(a1, a2, a3, a4, a5) -- Line: 702
    -- upvalues: u127 (ref), u128 (ref), u129 (ref), GetEquippedTool (val), u67 (ref), ClickToMoveDisplay (val)
    if u127 then
        if u127 then
            u127:Cancel()
            u127 = nil
        end
        if u128 then
            u128:Disconnect()
            u128 = nil
        end
        if u129 then
            u129:Disconnect()
            u129 = nil
        end
    end
    u127 = a1
    a1:Start(a5)
    u128 = a1.Finished.Event:Connect(function() -- Line: 709
        -- upvalues: u127 (upval), u128 (upval), u129 (upval), a3 (val), GetEquippedTool (upval), a4 (val)
        if u127 then
            u127:Cancel()
            u127 = nil
        end
        if u128 then
            u128:Disconnect()
            u128 = nil
        end
        if u129 then
            u129:Disconnect()
            u129 = nil
        end
        if a3 then
            local v1 = GetEquippedTool(a4)
            if v1 then
                v1:Activate()
            end
        end
    end)
    u129 = a1.PathFailed.Event:Connect(function() -- Line: 718
        -- upvalues: u127 (upval), u128 (upval), u129 (upval), a5 (val), u67 (upval), ClickToMoveDisplay (upval)
        -- upvalues: a2 (val)
        if u127 then
            u127:Cancel()
            u127 = nil
        end
        if u128 then
            u128:Disconnect()
            u128 = nil
        end
        if u129 then
            u129:Disconnect()
            u129 = nil
        end
        if a5 == nil or a5 then
            if u67 and (not u127 or not u127:IsActive()) then
                ClickToMoveDisplay.PlayFailureAnimation()
            end
            ClickToMoveDisplay.DisplayFailureWaypoint(a2)
        end
    end)
end

local function ShowPathFailedFeedback(a1) -- Line: 730 -- upvalues: u127 (ref), u67 (ref), ClickToMoveDisplay (val)
    if u127 and u127:IsActive() then
        u127:Cancel()
    end
    if u67 then
        ClickToMoveDisplay.PlayFailureAnimation()
    end
    ClickToMoveDisplay.DisplayFailureWaypoint(a1)
end

function OnTap(a1, a2, a3) -- Line: 740
    -- upvalues: Workspace (val), LocalPlayer (val), u99 (val), UserRaycastUpdateAPI (val), u101 (ref), u94 (val)
    -- upvalues: StarterGui (val), Players (val), u127 (ref), u128 (ref), u129 (ref), Pather (val), HandleMoveTo (val)
    -- upvalues: u67 (ref), ClickToMoveDisplay (val), u96 (val), GetEquippedTool (val)
    local v1, v2
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v3 = LocalPlayer
    local Character_2 = v3 and v3.Character
    if not Character_2 then
        v1 = nil
    else
        v2 = u99[v3]
        if not v2 or v2.Parent ~= Character_2 then
            u99[v3] = nil
            local Humanoid = Character_2:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                u99[v3] = Humanoid
            end
            v1 = Humanoid
        else
            v1 = v2
        end
    end
    local v4 = false
    if v1 ~= nil then
        v4 = 0 < v1.Health
    end
    if not v4 then
        return
    end
    if #a1 ~= 1 and not a2 then
        if #a1 >= 2 and CurrentCamera then
            v4 = GetEquippedTool(Character)
            if v4 then
                v4:Activate()
            end
        end
        return
    end
    if CurrentCamera then
        local v5, v6, v7
        v4 = CurrentCamera:ScreenPointToRay(a1[1].X, a1[1].Y)
        if UserRaycastUpdateAPI then
            local Instance
            v1 = nil
            v3 = nil
            if not u101 then
                u101 = {}
                assert(u101, "")
                local Character_3 = LocalPlayer and LocalPlayer.Character
                table.insert(u101, Character_3)
            end
            v2 = u101 or {}
            local v8, v9 = a3, a2
            repeat
                v5 = true
                u94.FilterDescendantsInstances = v2
                v7 = Workspace:Raycast(v4.Origin, v4.Direction * 1000, u94)
                if v7 then
                    Instance = v7.Instance
                    if not Instance.CanCollide then
                        repeat
                            v1 = Instance:FindFirstChildOfClass("Humanoid")
                            v3 = Instance
                            Instance = Instance.Parent
                        until v1 or not Instance or Instance == Workspace
                        if not v1 then
                            v3 = nil
                            v5 = false
                            table.insert(v2, Instance)
                        end
                    end
                end
            until v5
            if v8
                and v1
                and StarterGui:GetCore("AvatarContextMenuEnabled")
                and Players:GetPlayerFromCharacter(v1.Parent) then
                if u127 then
                    u127:Cancel()
                    u127 = nil
                end
                if u128 then
                    u128:Disconnect()
                    u128 = nil
                end
                if u129 then
                    u129:Disconnect()
                    u129 = nil
                end
                return
            end
            if v7 and Character then
                local Position = v7.Position
                if v9 then
                    Position = v9
                    v3 = nil
                end
                if u127 then
                    u127:Cancel()
                    u127 = nil
                end
                if u128 then
                    u128:Disconnect()
                    u128 = nil
                end
                if u129 then
                    u129:Disconnect()
                    u129 = nil
                end
                v6 = Pather(Position, v7.Normal)
                if v6:IsValidPath() then
                    HandleMoveTo(v6, Position, v3, Character)
                    return
                end
                v6:Cleanup()
                if u127 and u127:IsActive() then
                    u127:Cancel()
                end
                if u67 then
                    ClickToMoveDisplay.PlayFailureAnimation()
                end
                ClickToMoveDisplay.DisplayFailureWaypoint(Position)
                return
            end
            return
        end
        v1 = Ray.new(v4.Origin, v4.Direction * 1000)
        local Raycast = u96.Raycast
        if not u101 then
            u101 = {}
            assert(u101, "")
            local Character_4 = LocalPlayer and LocalPlayer.Character
            table.insert(u101, Character_4)
        end
        v3, v7, v2 = Raycast(v1, true, u101)
        v5, v6 = u96.FindCharacterAncestor(v3)
        if a3
            and v6
            and StarterGui:GetCore("AvatarContextMenuEnabled")
            and Players:GetPlayerFromCharacter(v6.Parent) then
            if u127 then
                u127:Cancel()
                u127 = nil
            end
            if u128 then
                u128:Disconnect()
                u128 = nil
            end
            if u129 then
                u129:Disconnect()
                u129 = nil
            end
            return
        end
        if a2 then
            v7 = a2
            v5 = nil
        end
        if v7 and Character then
            if u127 then
                u127:Cancel()
                u127 = nil
            end
            if u128 then
                u128:Disconnect()
                u128 = nil
            end
            if u129 then
                u129:Disconnect()
                u129 = nil
            end
            local v10 = Pather(v7, v2)
            if v10:IsValidPath() then
                HandleMoveTo(v10, v7, v5, Character)
                return
            end
            v10:Cleanup()
            if u127 and u127:IsActive() then
                u127:Cancel()
            end
            if u67 then
                ClickToMoveDisplay.PlayFailureAnimation()
            end
            ClickToMoveDisplay.DisplayFailureWaypoint(v7)
            return
        end
    end
end

local function DisconnectEvent(a1) -- Line: 850
    if a1 then
        a1:Disconnect()
    end
end

local Keyboard = require(script.Parent:WaitForChild("Keyboard"))
local u150 = setmetatable({}, Keyboard)
u150.__index = u150

function u150.new(a1) -- Line: 861 -- upvalues: Keyboard (val), u150 (val)
    local v1 = Keyboard.new(a1)
    local v2 = setmetatable(v1, u150)
    v2.fingerTouches = {}
    v2.numUnsunkTouches = 0
    v2.mouse1Down = tick()
    v2.mouse1DownPos = Vector2.new()
    v2.mouse2DownTime = tick()
    v2.mouse2DownPos = Vector2.new()
    v2.mouse2UpTime = tick()
    v2.keyboardMoveVector = Vector3.new(0, 0, 0)
    v2.tapConn = nil
    v2.inputBeganConn = nil
    v2.inputChangedConn = nil
    v2.inputEndedConn = nil
    v2.humanoidDiedConn = nil
    v2.characterChildAddedConn = nil
    v2.onCharacterAddedConn = nil
    v2.characterChildRemovedConn = nil
    v2.renderSteppedConn = nil
    v2.menuOpenedConnection = nil
    v2.running = false
    v2.wasdEnabled = false
    return v2
end

function u150:DisconnectEvents() -- Line: 893
    local tapConn = self.tapConn
    if tapConn then
        tapConn:Disconnect()
    end
    local inputBeganConn = self.inputBeganConn
    if inputBeganConn then
        inputBeganConn:Disconnect()
    end
    local inputChangedConn = self.inputChangedConn
    if inputChangedConn then
        inputChangedConn:Disconnect()
    end
    local inputEndedConn = self.inputEndedConn
    if inputEndedConn then
        inputEndedConn:Disconnect()
    end
    local humanoidDiedConn = self.humanoidDiedConn
    if humanoidDiedConn then
        humanoidDiedConn:Disconnect()
    end
    local characterChildAddedConn = self.characterChildAddedConn
    if characterChildAddedConn then
        characterChildAddedConn:Disconnect()
    end
    local onCharacterAddedConn = self.onCharacterAddedConn
    if onCharacterAddedConn then
        onCharacterAddedConn:Disconnect()
    end
    local renderSteppedConn = self.renderSteppedConn
    if renderSteppedConn then
        renderSteppedConn:Disconnect()
    end
    local characterChildRemovedConn = self.characterChildRemovedConn
    if characterChildRemovedConn then
        characterChildRemovedConn:Disconnect()
    end
    local menuOpenedConnection = self.menuOpenedConnection
    if menuOpenedConnection then
        menuOpenedConnection:Disconnect()
    end
end

function u150:OnTouchBegan(a2, a3) -- Line: 906
    if self.fingerTouches[a2] == nil and not a3 then
        self.numUnsunkTouches = self.numUnsunkTouches + 1
    end
    self.fingerTouches[a2] = a3
end

function u150:OnTouchChanged(a2, a3) -- Line: 913
    if self.fingerTouches[a2] == nil then
        self.fingerTouches[a2] = a3
        if not a3 then
            self.numUnsunkTouches = self.numUnsunkTouches + 1
        end
    end
end

function u150:OnTouchEnded(a2, a3) -- Line: 922
    if self.fingerTouches[a2] ~= nil and self.fingerTouches[a2] == false then
        self.numUnsunkTouches = self.numUnsunkTouches - 1
    end
    self.fingerTouches[a2] = nil
end

function u150:OnCharacterAdded(a2) -- Line: 930
    -- upvalues: UserInputService (val), u71 (val), u127 (ref), u128 (ref), u129 (ref), ClickToMoveDisplay (val)
    -- upvalues: GuiService (val)
    self:DisconnectEvents()
    self.inputBeganConn = UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 933
        -- upvalues: self (val), u71 (upval), u127 (upval), u128 (upval), u129 (upval), ClickToMoveDisplay (upval)
        if a1.UserInputType == Enum.UserInputType.Touch then
            self:OnTouchBegan(a1, a2)
        end
        if self.wasdEnabled
            and a2 == false
            and a1.UserInputType == Enum.UserInputType.Keyboard
            and u71[a1.KeyCode] then
            if u127 then
                u127:Cancel()
                u127 = nil
            end
            if u128 then
                u128:Disconnect()
                u128 = nil
            end
            if u129 then
                u129:Disconnect()
                u129 = nil
            end
            ClickToMoveDisplay.CancelFailureAnimation()
        end
        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
            self.mouse1DownTime = tick()
            self.mouse1DownPos = a1.Position
        end
        if a1.UserInputType == Enum.UserInputType.MouseButton2 then
            self.mouse2DownTime = tick()
            self.mouse2DownPos = a1.Position
        end
    end)
    self.inputChangedConn = UserInputService.InputChanged:Connect(function(a1, a2) -- Line: 954 -- upvalues: self (val)
        if a1.UserInputType == Enum.UserInputType.Touch then
            self:OnTouchChanged(a1, a2)
        end
    end)
    self.inputEndedConn = UserInputService.InputEnded:Connect(function(a1, a2) -- Line: 960 -- upvalues: self (val), u127 (upval)
        if a1.UserInputType == Enum.UserInputType.Touch then
            self:OnTouchEnded(a1, a2)
        end
        if a1.UserInputType == Enum.UserInputType.MouseButton2 then
            self.mouse2UpTime = tick()
            local Position = a1.Position
            local v1 = u127 or self.keyboardMoveVector.Magnitude <= 0
            local v2 = self.mouse2UpTime - self.mouse2DownTime
            if v2 < 0.25 and (Position - self.mouse2DownPos).magnitude < 5 and v1 then
                v2 = {Position}
                OnTap(v2)
            end
        end
    end)
    self.tapConn = UserInputService.TouchTap:Connect(function(a1, a2) -- Line: 977
        if not a2 then
            OnTap(a1, nil, true)
        end
    end)
    self.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- Line: 983 -- upvalues: u127 (upval), u128 (upval), u129 (upval)
        if u127 then
            u127:Cancel()
            u127 = nil
        end
        if u128 then
            u128:Disconnect()
            u128 = nil
        end
        if u129 then
            u129:Disconnect()
            u129 = nil
        end
    end)

    local function OnCharacterChildAdded(a1) -- Line: 987 -- upvalues: UserInputService (upval), self (val)
        if UserInputService.TouchEnabled and a1:IsA("Tool") then
            a1.ManualActivationOnly = true
        end
        if a1:IsA("Humanoid") then
            local humanoidDiedConn = self.humanoidDiedConn
            if humanoidDiedConn then
                humanoidDiedConn:Disconnect()
            end
            self.humanoidDiedConn = a1.Died:Connect(function() end)
        end
    end

    self.characterChildAddedConn = a2.ChildAdded:Connect(function(a1) -- Line: 1003 -- upvalues: OnCharacterChildAdded (val)
        OnCharacterChildAdded(a1)
    end)
    self.characterChildRemovedConn = a2.ChildRemoved:Connect(function(a1) -- Line: 1006 -- upvalues: UserInputService (upval)
        if UserInputService.TouchEnabled and a1:IsA("Tool") then
            a1.ManualActivationOnly = false
        end
    end)
    for k, v in pairs(a2:GetChildren()) do
        OnCharacterChildAdded(v)
    end
end

function u150:Start() -- Line: 1018
    self:Enable(true)
end

function u150.Stop(a1) -- Line: 1022
    a1:Enable(false)
end

function u150.CleanupPath(a1) -- Line: 1026 -- upvalues: u127 (ref), u128 (ref), u129 (ref)
    if u127 then
        u127:Cancel()
        u127 = nil
    end
    if u128 then
        u128:Disconnect()
        u128 = nil
    end
    if u129 then
        u129:Disconnect()
        u129 = nil
    end
end

function u150:Enable(a2, a3, a4) -- Line: 1030
    -- upvalues: LocalPlayer (val), u127 (ref), u128 (ref), u129 (ref), UserInputService (val), Keyboard (val)
    if not a2 then
        if self.running then
            self:DisconnectEvents()
            if u127 then
                u127:Cancel()
                u127 = nil
            end
            if u128 then
                u128:Disconnect()
                u128 = nil
            end
            if u129 then
                u129:Disconnect()
                u129 = nil
            end
            if UserInputService.TouchEnabled then
                local Character_2 = LocalPlayer.Character
                if Character_2 then
                    for k, v in pairs(Character_2:GetChildren()) do
                        if v:IsA("Tool") then
                            v.ManualActivationOnly = false
                        end
                    end
                end
            end
            self.running = false
        end
        if self.touchJumpController and not self.jumpEnabled then
            self.touchJumpController:Enable(true)
        end
        self.touchJumpController = nil
    else
        if not self.running then
            if LocalPlayer.Character then
                self:OnCharacterAdded(LocalPlayer.Character)
            end
            self.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(a1) -- Line: 1036 -- upvalues: self (val)
                self:OnCharacterAdded(a1)
            end)
            self.running = true
        end
        self.touchJumpController = a4
        if self.touchJumpController then
            self.touchJumpController:Enable(self.jumpEnabled)
        end
    end
    Keyboard.Enable(self, a2)
    self.wasdEnabled = a2 and a3 or false
    self.enabled = a2
end

function u150:OnRenderStepped(a2) -- Line: 1075 -- upvalues: u127 (ref)
    self.isJumping = false
    if not u127 then
        self.moveVector = self.keyboardMoveVector
        self.moveVectorIsCameraRelative = true
    else
        u127:OnRenderStepped(a2)
        if not u127 then
            self.moveVector = self.keyboardMoveVector
            self.moveVectorIsCameraRelative = true
        else
            self.moveVector = u127.NextActionMoveDirection
            self.moveVectorIsCameraRelative = false
            if u127.NextActionJump then
                self.isJumping = true
            end
        end
    end
    if self.jumpRequested then
        self.isJumping = true
    end
end

function u150.UpdateMovement(a1, a2) -- Line: 1110
    if a2 == Enum.UserInputState.Cancel then
        a1.keyboardMoveVector = Vector3.new(0, 0, 0)
        return
    end
    if a1.wasdEnabled then
        a1.keyboardMoveVector = Vector3.new(a1.leftValue + a1.rightValue, 0, a1.forwardValue + a1.backwardValue)
    end
end

function u150.UpdateJump(a1) end

function u150.SetShowPath(a1, a2) -- Line: 1124 -- upvalues: u66 (ref)
    u66 = a2
end

function u150.GetShowPath(a1) -- Line: 1128 -- upvalues: u66 (ref)
    return u66
end

function u150.SetWaypointTexture(a1, a2) -- Line: 1132 -- upvalues: ClickToMoveDisplay (val)
    ClickToMoveDisplay.SetWaypointTexture(a2)
end

function u150.GetWaypointTexture(a1) -- Line: 1136 -- upvalues: ClickToMoveDisplay (val)
    return ClickToMoveDisplay.GetWaypointTexture()
end

function u150.SetWaypointRadius(a1, a2) -- Line: 1140 -- upvalues: ClickToMoveDisplay (val)
    ClickToMoveDisplay.SetWaypointRadius(a2)
end

function u150.GetWaypointRadius(a1) -- Line: 1144 -- upvalues: ClickToMoveDisplay (val)
    return ClickToMoveDisplay.GetWaypointRadius()
end

function u150.SetEndWaypointTexture(a1, a2) -- Line: 1148 -- upvalues: ClickToMoveDisplay (val)
    ClickToMoveDisplay.SetEndWaypointTexture(a2)
end

function u150.GetEndWaypointTexture(a1) -- Line: 1152 -- upvalues: ClickToMoveDisplay (val)
    return ClickToMoveDisplay.GetEndWaypointTexture()
end

function u150.SetWaypointsAlwaysOnTop(a1, a2) -- Line: 1156 -- upvalues: ClickToMoveDisplay (val)
    ClickToMoveDisplay.SetWaypointsAlwaysOnTop(a2)
end

function u150.GetWaypointsAlwaysOnTop(a1) -- Line: 1160 -- upvalues: ClickToMoveDisplay (val)
    return ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
end

function u150.SetFailureAnimationEnabled(a1, a2) -- Line: 1164 -- upvalues: u67 (ref)
    u67 = a2
end

function u150.GetFailureAnimationEnabled(a1) -- Line: 1168 -- upvalues: u67 (ref)
    return u67
end

function u150.SetIgnoredPartsTag(a1, a2) -- Line: 1172 -- upvalues: UpdateIgnoreTag (val)
    UpdateIgnoreTag(a2)
end

function u150.GetIgnoredPartsTag(a1) -- Line: 1176 -- upvalues: u102 (ref)
    return u102
end

function u150.SetUseDirectPath(a1, a2) -- Line: 1180 -- upvalues: u68 (ref)
    u68 = a2
end

function u150.GetUseDirectPath(a1) -- Line: 1184 -- upvalues: u68 (ref)
    return u68
end

function u150.SetAgentSizeIncreaseFactor(a1, a2) -- Line: 1188 -- upvalues: u69 (ref) -- types: a1: table, a2: number
    u69 = a2 / 100 + 1
end

function u150.GetAgentSizeIncreaseFactor(a1) -- Line: 1192 -- upvalues: u69 (ref)
    return (u69 - 1) * 100
end

function u150.SetUnreachableWaypointTimeout(a1, a2) -- Line: 1196 -- upvalues: u70 (ref)
    u70 = a2
end

function u150.GetUnreachableWaypointTimeout(a1) -- Line: 1200 -- upvalues: u70 (ref)
    return u70
end

function u150.SetUserJumpEnabled(a1, a2) -- Line: 1204
    a1.jumpEnabled = a2
    if a1.touchJumpController then
        a1.touchJumpController:Enable(a2)
    end
end

function u150.GetUserJumpEnabled(a1) -- Line: 1211
    return a1.jumpEnabled
end

function u150.MoveTo(a1, a2, a3, a4) -- Line: 1215 -- upvalues: LocalPlayer (val), Pather (val), HandleMoveTo (val)
    local Character = LocalPlayer.Character
    if Character == nil then
        return false
    end
    local v1 = Pather(a2, Vector3.new(0, 1, 0), a4)
    if v1 and v1:IsValidPath() then
        HandleMoveTo(v1, a2, nil, Character, a3)
        return true
    end
    return false
end

return u150