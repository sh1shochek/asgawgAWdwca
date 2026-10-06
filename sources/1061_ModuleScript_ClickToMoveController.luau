-- Decompiled with Potassium's decompiler.

local success, result = pcall(function() -- Line: 10
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding");
end);
local u1 = success and result;
local success2, result2 = pcall(function() -- Line: 14
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2");
end);
local u2 = success2 and result2;
local UserInputService = game:GetService("UserInputService");
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
game:GetService("Debris");
local StarterGui = game:GetService("StarterGui");
local Workspace = game:GetService("Workspace");
local CollectionService = game:GetService("CollectionService");
local GuiService = game:GetService("GuiService");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local UserFlag = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI");
local u3 = true;
local u4 = true;
local u5 = false;
local u6 = 1;
local u7 = 8;
local u8 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true
};
local LocalPlayer = Players.LocalPlayer;
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"));
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local u9 = {};

if not UserFlag then
    local function FindCharacterAncestor(p10) -- Line: 65
        -- upvalues: FindCharacterAncestor (copy)
        if p10 then
            local v11 = p10:FindFirstChildOfClass("Humanoid");

            if v11 then
                return p10, v11;
            end;

            return FindCharacterAncestor(p10.Parent);
        end;
    end;

    u9.FindCharacterAncestor = FindCharacterAncestor;

    local function Raycast(p12: any, p13: boolean, p14: table) -- Line: 77
        -- upvalues: Workspace (copy), FindCharacterAncestor (copy), Raycast (copy)
        local v15 = p14 or {};
        local v16, v17, v18, v19 = Workspace:FindPartOnRayWithIgnoreList(p12, v15);

        if not v16 then
            return nil, nil;
        end;

        if p13 and v16.CanCollide == false then
            local v20;

            if v16 then
                v20 = v16:FindFirstChildOfClass("Humanoid");

                if not v20 then
                    local v21;
                    v21, v20 = FindCharacterAncestor(v16.Parent);
                end;
            else
                v20 = nil;
            end;

            if v20 == nil then
                table.insert(v15, v16);

                return Raycast(p12, p13, v15);
            end;
        end;

        return v16, v17, v18, v19;
    end;

    u9.Raycast = Raycast;
end;

local u22 = {};

local function findPlayerHumanoid(p23: userdata) -- Line: 99
    -- upvalues: u22 (copy)
    local v24;

    if p23 then
        v24 = p23.Character;
    else
        v24 = p23;
    end;

    if v24 then
        local v25 = u22[p23];

        if v25 and v25.Parent == v24 then
            return v25;
        end;

        u22[p23] = nil;
        local v26 = v24:FindFirstChildOfClass("Humanoid");

        if v26 then
            u22[p23] = v26;
        end;

        return v26;
    end;
end;

local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;

local function GetCharacter() -- Line: 123
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer and LocalPlayer.Character;
end;

local function UpdateIgnoreTag(p31) -- Line: 127
    -- upvalues: u28 (ref), u29 (ref), u30 (ref), u27 (ref), LocalPlayer (copy), CollectionService (copy)
    if p31 == u28 then
        return;
    end;

    if u29 then
        u29:Disconnect();
        u29 = nil;
    end;

    if u30 then
        u30:Disconnect();
        u30 = nil;
    end;

    u28 = p31;
    local v32 = {};
    v32[1] = LocalPlayer and LocalPlayer.Character;
    u27 = v32;

    if u28 ~= nil then
        local Tagged = CollectionService:GetTagged(u28);

        for _, v in ipairs(Tagged) do
            table.insert(u27, v);
        end;

        u29 = CollectionService:GetInstanceAddedSignal(u28):Connect(function(p33) -- Line: 147
            -- upvalues: u27 (ref)
            table.insert(u27, p33);
        end);
        u30 = CollectionService:GetInstanceRemovedSignal(u28):Connect(function(p34) -- Line: 151
            -- upvalues: u27 (ref)
            for i = 1, #u27 do
                if u27[i] == p34 then
                    u27[i] = u27[#u27];
                    table.remove(u27);

                    return;
                end;

                local _ = i;
            end;
        end);
    end;
end;

local function getIgnoreList() -- Line: 163
    -- upvalues: u27 (ref), LocalPlayer (copy)
    if u27 then
        return u27;
    end;

    u27 = {};
    assert(u27, "");
    table.insert(u27, LocalPlayer and LocalPlayer.Character);

    return u27;
end;

local function minV(p35: vector, p36: vector) -- Line: 173
    local math_min_ret = math.min(p35.X, p36.X);
    local math_min_ret2 = math.min(p35.Y, p36.Y);
    local math_min_ret3 = math.min(p35.Z, p36.Z);

    return Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
end;

local function maxV(p37, p38) -- Line: 176
    local math_max_ret = math.max(p37.X, p38.X);
    local math_max_ret2 = math.max(p37.Y, p38.Y);
    local math_max_ret3 = math.max(p37.Z, p38.Z);

    return Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
end;

local function getCollidableExtentsSize(p39: userdata?) -- Line: 179
    if p39 ~= nil and p39.PrimaryPart ~= nil then
        assert(p39, "");
        assert(p39.PrimaryPart, "");
        local v40 = p39.PrimaryPart.CFrame:Inverse();
        local v41 = Vector3.new(inf, inf, inf);
        local v42 = Vector3.new(-inf, -inf, -inf);

        for _, descendant in pairs(p39:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.CanCollide then
                local v43 = v40 * descendant.CFrame;
                local Vector3_new_ret = Vector3.new(descendant.Size.X / 2, descendant.Size.Y / 2, descendant.Size.Z / 2);
                local v44 = {
                    Vector3.new(Vector3_new_ret.X, Vector3_new_ret.Y, Vector3_new_ret.Z),
                    Vector3.new(Vector3_new_ret.X, Vector3_new_ret.Y, -Vector3_new_ret.Z),
                    Vector3.new(Vector3_new_ret.X, -Vector3_new_ret.Y, Vector3_new_ret.Z),
                    Vector3.new(Vector3_new_ret.X, -Vector3_new_ret.Y, -Vector3_new_ret.Z),
                    Vector3.new(-Vector3_new_ret.X, Vector3_new_ret.Y, Vector3_new_ret.Z),
                    Vector3.new(-Vector3_new_ret.X, Vector3_new_ret.Y, -Vector3_new_ret.Z),
                    Vector3.new(-Vector3_new_ret.X, -Vector3_new_ret.Y, Vector3_new_ret.Z),
                    (Vector3.new(-Vector3_new_ret.X, -Vector3_new_ret.Y, -Vector3_new_ret.Z))
                };

                for _, v in ipairs(v44) do
                    local v45 = v43 * v;
                    local math_min_ret = math.min(v41.X, v45.X);
                    local math_min_ret2 = math.min(v41.Y, v45.Y);
                    local math_min_ret3 = math.min(v41.Z, v45.Z);
                    v41 = Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
                    local math_max_ret = math.max(v42.X, v45.X);
                    local math_max_ret2 = math.max(v42.Y, v45.Y);
                    local math_max_ret3 = math.max(v42.Z, v45.Z);
                    v42 = Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
                end;
            end;
        end;

        local v46 = v42 - v41;

        if v46.X < 0 or (v46.Y < 0 or v46.Z < 0) then
            return nil;
        end;

        return v46;
    end;
end;

local function Pather(p47: any, p48: any, p49: boolean?) -- Line: 214
    -- upvalues: u5 (ref), LocalPlayer (copy), u22 (copy), u6 (ref), u1 (copy), getCollidableExtentsSize (copy), u2 (copy), PathfindingService (copy), u3 (ref), ClickToMoveDisplay (copy), u7 (ref), UserFlag (copy), RaycastParams_new_ret (copy), u27 (ref), Workspace (copy)
    local u50 = {};
    local v51;

    if p49 == nil then
        v51 = u5;
        p49 = true;
    else
        v51 = p49;
    end;

    u50.Cancelled = false;
    u50.Started = false;
    u50.Finished = Instance.new("BindableEvent");
    u50.PathFailed = Instance.new("BindableEvent");
    u50.PathComputing = false;
    u50.PathComputed = false;
    u50.OriginalTargetPoint = p47;
    u50.TargetPoint = p47;
    u50.TargetSurfaceNormal = p48;
    u50.DiedConn = nil;
    u50.SeatedConn = nil;
    u50.BlockedConn = nil;
    u50.TeleportedConn = nil;
    u50.CurrentPoint = 0;
    u50.HumanoidOffsetFromPath = Vector3.new(0, 0, 0);
    u50.CurrentWaypointPosition = nil;
    u50.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
    u50.CurrentWaypointPlaneDistance = 0;
    u50.CurrentWaypointNeedsJump = false;
    u50.CurrentHumanoidPosition = Vector3.new(0, 0, 0);
    u50.CurrentHumanoidVelocity = 0;
    u50.NextActionMoveDirection = Vector3.new(0, 0, 0);
    u50.NextActionJump = false;
    u50.Timeout = 0;
    local v52 = LocalPlayer;
    local v53;

    if v52 then
        v53 = v52.Character;
    else
        v53 = v52;
    end;

    local v54;

    if v53 then
        v54 = u22[v52];

        if not v54 or v54.Parent ~= v53 then
            u22[v52] = nil;
            v54 = v53:FindFirstChildOfClass("Humanoid");

            if v54 then
                u22[v52] = v54;
            end;
        end;
    else
        v54 = nil;
    end;

    u50.Humanoid = v54;
    u50.OriginPoint = nil;
    u50.AgentCanFollowPath = false;
    u50.DirectPath = false;
    u50.DirectPathRiseFirst = false;
    u50.stopTraverseFunc = nil;
    u50.setPointFunc = nil;
    u50.pointList = nil;
    local v55 = u50.Humanoid and u50.Humanoid.RootPart;

    if v55 then
        u50.OriginPoint = v55.CFrame.Position;
        local v56 = 2;
        local v57 = 5;
        local v58 = true;
        local SeatPart = u50.Humanoid.SeatPart;

        if SeatPart and SeatPart:IsA("VehicleSeat") then
            local v59 = SeatPart:FindFirstAncestorOfClass("Model");

            if v59 then
                local PrimaryPart = v59.PrimaryPart;
                v59.PrimaryPart = SeatPart;

                if p49 then
                    local ExtentsSize = v59:GetExtentsSize();
                    v56 = u6 * 0.5 * math.sqrt(ExtentsSize.X * ExtentsSize.X + ExtentsSize.Z * ExtentsSize.Z);
                    v57 = u6 * ExtentsSize.Y;
                    u50.AgentCanFollowPath = true;
                    u50.DirectPath = p49;
                    v58 = false;
                end;

                v59.PrimaryPart = PrimaryPart;
            end;
        else
            local v60 = nil;

            if u1 then
                local v61 = LocalPlayer and LocalPlayer.Character;

                if v61 ~= nil then
                    v60 = getCollidableExtentsSize(v61);
                end;
            end;

            if v60 == nil then
                v60 = (LocalPlayer and LocalPlayer.Character):GetExtentsSize();
            end;

            assert(v60, "");
            v56 = u6 * 0.5 * math.sqrt(v60.X * v60.X + v60.Z * v60.Z);
            v57 = u6 * v60.Y;
            v58 = u50.Humanoid.JumpPower > 0;
            u50.AgentCanFollowPath = true;
            u50.DirectPath = v51;
            u50.DirectPathRiseFirst = u50.Humanoid.Sit;
        end;

        if u2 then
            u50.pathResult = PathfindingService:CreatePath({
                AgentCanClimb = true,
                AgentRadius = v56,
                AgentHeight = v57,
                AgentCanJump = v58
            });
        else
            u50.pathResult = PathfindingService:CreatePath({
                AgentRadius = v56,
                AgentHeight = v57,
                AgentCanJump = v58
            });
        end;
    end;

    function u50.Cleanup(p62) -- Line: 332
        -- upvalues: u50 (copy)
        if u50.stopTraverseFunc then
            u50.stopTraverseFunc();
            u50.stopTraverseFunc = nil;
        end;

        if u50.BlockedConn then
            u50.BlockedConn:Disconnect();
            u50.BlockedConn = nil;
        end;

        if u50.DiedConn then
            u50.DiedConn:Disconnect();
            u50.DiedConn = nil;
        end;

        if u50.SeatedConn then
            u50.SeatedConn:Disconnect();
            u50.SeatedConn = nil;
        end;

        if u50.TeleportedConn then
            u50.TeleportedConn:Disconnect();
            u50.TeleportedConn = nil;
        end;

        u50.Started = false;
    end;

    function u50.Cancel(p63) -- Line: 361
        -- upvalues: u50 (copy)
        u50.Cancelled = true;
        u50:Cleanup();
    end;

    function u50.IsActive(p64) -- Line: 366
        -- upvalues: u50 (copy)
        return u50.AgentCanFollowPath and u50.Started and not u50.Cancelled;
    end;

    function u50.OnPathInterrupted(p65) -- Line: 370
        -- upvalues: u50 (copy)
        u50.Cancelled = true;
        u50:OnPointReached(false);
    end;

    function u50.ComputePath(p66) -- Line: 376
        -- upvalues: u50 (copy)
        if u50.OriginPoint then
            if u50.PathComputed or u50.PathComputing then
                return;
            end;

            u50.PathComputing = true;

            if u50.AgentCanFollowPath then
                if u50.DirectPath then
                    u50.pointList = { PathWaypoint.new(u50.OriginPoint, Enum.PathWaypointAction.Walk), PathWaypoint.new(u50.TargetPoint, u50.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk) };
                    u50.PathComputed = true;
                else
                    u50.pathResult:ComputeAsync(u50.OriginPoint, u50.TargetPoint);
                    u50.pointList = u50.pathResult:GetWaypoints();
                    u50.BlockedConn = u50.pathResult.Blocked:Connect(function(p67) -- Line: 390
                        -- upvalues: u50 (ref)
                        u50:OnPathBlocked(p67);
                    end);
                    u50.PathComputed = u50.pathResult.Status == Enum.PathStatus.Success;
                end;
            end;

            u50.PathComputing = false;
        end;
    end;

    function u50.IsValidPath(p68) -- Line: 398
        -- upvalues: u50 (copy)
        u50:ComputePath();

        return u50.PathComputed and u50.AgentCanFollowPath;
    end;

    u50.Recomputing = false;

    function u50.OnPathBlocked(p69, p70) -- Line: 404
        -- upvalues: u50 (copy), u3 (ref), ClickToMoveDisplay (ref)
        if u50.CurrentPoint > p70 or u50.Recomputing then
            return;
        end;

        u50.Recomputing = true;

        if u50.stopTraverseFunc then
            u50.stopTraverseFunc();
            u50.stopTraverseFunc = nil;
        end;

        u50.OriginPoint = u50.Humanoid.RootPart.CFrame.p;
        u50.pathResult:ComputeAsync(u50.OriginPoint, u50.TargetPoint);
        u50.pointList = u50.pathResult:GetWaypoints();

        if #u50.pointList > 0 then
            u50.HumanoidOffsetFromPath = u50.pointList[1].Position - u50.OriginPoint;
        end;

        u50.PathComputed = u50.pathResult.Status == Enum.PathStatus.Success;

        if u3 then
            local v71, v72 = ClickToMoveDisplay.CreatePathDisplay(u50.pointList);
            u50.stopTraverseFunc = v71;
            u50.setPointFunc = v72;
        end;

        if u50.PathComputed then
            u50.CurrentPoint = 1;
            u50:OnPointReached(true);
        else
            u50.PathFailed:Fire();
            u50:Cleanup();
        end;

        u50.Recomputing = false;
    end;

    function u50.OnRenderStepped(p73: table, p74: number) -- Line: 440
        -- upvalues: u50 (copy), u7 (ref)
        if u50.Started and not u50.Cancelled then
            u50.Timeout = u50.Timeout + p74;

            if u7 < u50.Timeout then
                u50:OnPointReached(false);

                return;
            end;

            u50.CurrentHumanoidPosition = u50.Humanoid.RootPart.Position + u50.HumanoidOffsetFromPath;
            u50.CurrentHumanoidVelocity = u50.Humanoid.RootPart.Velocity;

            while u50.Started and u50:IsCurrentWaypointReached() do
                u50:OnPointReached(true);
            end;

            if u50.Started then
                u50.NextActionMoveDirection = u50.CurrentWaypointPosition - u50.CurrentHumanoidPosition;

                if u50.NextActionMoveDirection.Magnitude > 1e-6 then
                    u50.NextActionMoveDirection = u50.NextActionMoveDirection.Unit;
                else
                    u50.NextActionMoveDirection = Vector3.new(0, 0, 0);
                end;

                if u50.CurrentWaypointNeedsJump then
                    u50.NextActionJump = true;
                    u50.CurrentWaypointNeedsJump = false;

                    return;
                end;

                u50.NextActionJump = false;
            end;
        end;
    end;

    function u50.IsCurrentWaypointReached(p75) -- Line: 478
        -- upvalues: u50 (copy)
        local v76;

        if u50.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            v76 = true;
        else
            local v77 = u50.CurrentWaypointPlaneNormal:Dot(u50.CurrentHumanoidPosition) - u50.CurrentWaypointPlaneDistance;
            local v78 = 0.0625 * -u50.CurrentWaypointPlaneNormal:Dot(u50.CurrentHumanoidVelocity);
            v76 = v77 < math.max(1, v78);
        end;

        if v76 then
            u50.CurrentWaypointPosition = nil;
            u50.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u50.CurrentWaypointPlaneDistance = 0;
        end;

        return v76;
    end;

    function u50.OnPointReached(p79, p80) -- Line: 504
        -- upvalues: u50 (copy)
        if not p80 or u50.Cancelled then
            u50.PathFailed:Fire();
            u50:Cleanup();

            return;
        end;

        if u50.setPointFunc then
            u50.setPointFunc(u50.CurrentPoint);
        end;

        local v81 = u50.CurrentPoint + 1;

        if #u50.pointList < v81 then
            if u50.stopTraverseFunc then
                u50.stopTraverseFunc();
            end;

            u50.Finished:Fire();
            u50:Cleanup();

            return;
        end;

        local v82 = u50.pointList[u50.CurrentPoint];
        local v83 = u50.pointList[v81];
        local State = u50.Humanoid:GetState();

        if (State == Enum.HumanoidStateType.FallingDown or State == Enum.HumanoidStateType.Freefall) and true or State == Enum.HumanoidStateType.Jumping then
            local v84 = v83.Action == Enum.PathWaypointAction.Jump;

            if not v84 and u50.CurrentPoint > 1 then
                local v85 = v82.Position - u50.pointList[u50.CurrentPoint - 1].Position;
                local v86 = v83.Position - v82.Position;
                v84 = Vector2.new(v85.x, v85.z).Unit:Dot(Vector2.new(v86.x, v86.z).Unit) < 0.996;
            end;

            if v84 then
                u50.Humanoid.FreeFalling:Wait();
                wait(0.1);
            end;
        end;

        u50:MoveToNextWayPoint(v82, v83, v81);
    end;

    function u50.MoveToNextWayPoint(p87: table, p88: userdata, p89: userdata, p90: number) -- Line: 567
        -- upvalues: u50 (copy), u2 (ref)
        u50.CurrentWaypointPlaneNormal = p88.Position - p89.Position;

        if not u2 or p89.Label ~= "Climb" then
            u50.CurrentWaypointPlaneNormal = Vector3.new(u50.CurrentWaypointPlaneNormal.X, 0, u50.CurrentWaypointPlaneNormal.Z);
        end;

        if u50.CurrentWaypointPlaneNormal.Magnitude > 1e-6 then
            u50.CurrentWaypointPlaneNormal = u50.CurrentWaypointPlaneNormal.Unit;
            u50.CurrentWaypointPlaneDistance = u50.CurrentWaypointPlaneNormal:Dot(p89.Position);
        else
            u50.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u50.CurrentWaypointPlaneDistance = 0;
        end;

        u50.CurrentWaypointNeedsJump = p89.Action == Enum.PathWaypointAction.Jump;
        u50.CurrentWaypointPosition = p89.Position;
        u50.CurrentPoint = p90;
        u50.Timeout = 0;
    end;

    function u50.Start(p91, p92) -- Line: 599
        -- upvalues: u50 (copy), ClickToMoveDisplay (ref), u3 (ref)
        if not u50.AgentCanFollowPath then
            u50.PathFailed:Fire();

            return;
        end;

        if u50.Started then
            return;
        end;

        u50.Started = true;
        ClickToMoveDisplay.CancelFailureAnimation();

        if u3 and (p92 == nil or p92) then
            local v93, v94 = ClickToMoveDisplay.CreatePathDisplay(u50.pointList, u50.OriginalTargetPoint);
            u50.stopTraverseFunc = v93;
            u50.setPointFunc = v94;
        end;

        if #u50.pointList <= 0 then
            u50.PathFailed:Fire();

            if u50.stopTraverseFunc then
                u50.stopTraverseFunc();
            end;

            return;
        end;

        u50.HumanoidOffsetFromPath = Vector3.new(0, u50.pointList[1].Position.Y - u50.OriginPoint.Y, 0);
        u50.CurrentHumanoidPosition = u50.Humanoid.RootPart.Position + u50.HumanoidOffsetFromPath;
        u50.CurrentHumanoidVelocity = u50.Humanoid.RootPart.Velocity;
        u50.SeatedConn = u50.Humanoid.Seated:Connect(function(p95, p96) -- Line: 626
            -- upvalues: u50 (ref)
            u50:OnPathInterrupted();
        end);
        u50.DiedConn = u50.Humanoid.Died:Connect(function() -- Line: 627
            -- upvalues: u50 (ref)
            u50:OnPathInterrupted();
        end);
        u50.TeleportedConn = u50.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 628
            -- upvalues: u50 (ref)
            u50:OnPathInterrupted();
        end);
        u50.CurrentPoint = 1;
        u50:OnPointReached(true);
    end;

    local v97 = u50.TargetPoint + u50.TargetSurfaceNormal * 1.5;

    if UserFlag then
        local v98;

        if u27 then
            v98 = u27;
        else
            u27 = {};
            assert(u27, "");
            table.insert(u27, LocalPlayer and LocalPlayer.Character);
            v98 = u27;
        end;

        RaycastParams_new_ret.FilterDescendantsInstances = v98;
        local v99 = Workspace:Raycast(v97, Vector3.new(-0, -50, -0), RaycastParams_new_ret);

        if v99 then
            u50.TargetPoint = v99.Position;
        end;
    else
        local Ray_new_ret = Ray.new(v97, Vector3.new(0, -50, 0));
        local v100;

        if u27 then
            v100 = u27;
        else
            u27 = {};
            assert(u27, "");
            table.insert(u27, LocalPlayer and LocalPlayer.Character);
            v100 = u27;
        end;

        local v101, v102 = Workspace:FindPartOnRayWithIgnoreList(Ray_new_ret, v100);

        if v101 then
            u50.TargetPoint = v102;
        end;
    end;

    u50:ComputePath();

    return u50;
end;

local function CheckAlive() -- Line: 664
    -- upvalues: LocalPlayer (copy), u22 (copy)
    local v103 = LocalPlayer;
    local v104;

    if v103 then
        v104 = v103.Character;
    else
        v104 = v103;
    end;

    local v105;

    if v104 then
        v105 = u22[v103];

        if not v105 or v105.Parent ~= v104 then
            u22[v103] = nil;
            v105 = v104:FindFirstChildOfClass("Humanoid");

            if v105 then
                u22[v103] = v105;
            end;
        end;
    else
        v105 = nil;
    end;

    local v106;

    if v105 == nil then
        v106 = false;
    else
        v106 = v105.Health > 0;
    end;

    return v106;
end;

local function GetEquippedTool(p107: userdata?) -- Line: 669
    if p107 ~= nil then
        for _, child in pairs(p107:GetChildren()) do
            if child:IsA("Tool") then
                return child;
            end;
        end;
    end;
end;

local u108 = nil;
local u109 = nil;
local u110 = nil;

local function CleanupPath() -- Line: 684
    -- upvalues: u108 (ref), u109 (ref), u110 (ref)
    if u108 then
        u108:Cancel();
        u108 = nil;
    end;

    if u109 then
        u109:Disconnect();
        u109 = nil;
    end;

    if u110 then
        u110:Disconnect();
        u110 = nil;
    end;
end;

local function HandleMoveTo(p111, u112, u113, u114, u115) -- Line: 702
    -- upvalues: u108 (ref), u109 (ref), u110 (ref), GetEquippedTool (copy), u4 (ref), ClickToMoveDisplay (copy)
    if u108 then
        if u108 then
            u108:Cancel();
            u108 = nil;
        end;

        if u109 then
            u109:Disconnect();
            u109 = nil;
        end;

        if u110 then
            u110:Disconnect();
            u110 = nil;
        end;
    end;

    u108 = p111;
    p111:Start(u115);
    u109 = p111.Finished.Event:Connect(function() -- Line: 709
        -- upvalues: u108 (ref), u109 (ref), u110 (ref), u113 (copy), GetEquippedTool (ref), u114 (copy)
        if u108 then
            u108:Cancel();
            u108 = nil;
        end;

        if u109 then
            u109:Disconnect();
            u109 = nil;
        end;

        if u110 then
            u110:Disconnect();
            u110 = nil;
        end;

        local v116 = u113 and GetEquippedTool(u114);

        if v116 then
            v116:Activate();
        end;
    end);
    u110 = p111.PathFailed.Event:Connect(function() -- Line: 718
        -- upvalues: u108 (ref), u109 (ref), u110 (ref), u115 (copy), u4 (ref), ClickToMoveDisplay (ref), u112 (copy)
        if u108 then
            u108:Cancel();
            u108 = nil;
        end;

        if u109 then
            u109:Disconnect();
            u109 = nil;
        end;

        if u110 then
            u110:Disconnect();
            u110 = nil;
        end;

        if u115 == nil or u115 then
            local v117 = u4;

            if v117 then
                local v118 = u108 and u108:IsActive();
                v117 = not v118;
            end;

            if v117 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(u112);
        end;
    end);
end;

local function ShowPathFailedFeedback(p119) -- Line: 730
    -- upvalues: u108 (ref), u4 (ref), ClickToMoveDisplay (copy)
    if u108 and u108:IsActive() then
        u108:Cancel();
    end;

    if u4 then
        ClickToMoveDisplay.PlayFailureAnimation();
    end;

    ClickToMoveDisplay.DisplayFailureWaypoint(p119);
end;

function OnTap(p120: table, p121: vector?, p122: boolean?)
    -- upvalues: Workspace (copy), LocalPlayer (copy), u22 (copy), UserFlag (copy), u27 (ref), RaycastParams_new_ret (copy), StarterGui (copy), Players (copy), u108 (ref), u109 (ref), u110 (ref), Pather (copy), HandleMoveTo (copy), u4 (ref), ClickToMoveDisplay (copy), u9 (copy), GetEquippedTool (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local Character = LocalPlayer.Character;
    local v123 = LocalPlayer;
    local v124;

    if v123 then
        v124 = v123.Character;
    else
        v124 = v123;
    end;

    local v125;

    if v124 then
        v125 = u22[v123];

        if not v125 or v125.Parent ~= v124 then
            u22[v123] = nil;
            v125 = v124:FindFirstChildOfClass("Humanoid");

            if v125 then
                u22[v123] = v125;
            end;
        end;
    else
        v125 = nil;
    end;

    local v126;

    if v125 == nil then
        v126 = false;
    else
        v126 = v125.Health > 0;
    end;

    if not v126 then
        return;
    end;

    if #p120 ~= 1 and not p121 then
        local v127 = #p120 >= 2 and (CurrentCamera and GetEquippedTool(Character));

        if v127 then
            v127:Activate();
        end;

        return;
    end;

    if not CurrentCamera then
        return;
    end;

    local v128 = CurrentCamera:ScreenPointToRay(p120[1].X, p120[1].Y);

    if not UserFlag then
        local Ray_new_ret = Ray.new(v128.Origin, v128.Direction * 1000);
        local Raycast = u9.Raycast;
        local v129;

        if u27 then
            v129 = u27;
        else
            u27 = {};
            assert(u27, "");
            table.insert(u27, LocalPlayer and LocalPlayer.Character);
            v129 = u27;
        end;

        local v130, v131, v132 = Raycast(Ray_new_ret, true, v129);
        local v133, v134 = u9.FindCharacterAncestor(v130);

        if p122 and (v134 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v134.Parent))) then
            if u108 then
                u108:Cancel();
                u108 = nil;
            end;

            if u109 then
                u109:Disconnect();
                u109 = nil;
            end;

            if u110 then
                u110:Disconnect();
                u110 = nil;
            end;

            return;
        end;

        if p121 then
            v133 = nil;
        else
            p121 = v131;
        end;

        if p121 and Character then
            if u108 then
                u108:Cancel();
                u108 = nil;
            end;

            if u109 then
                u109:Disconnect();
                u109 = nil;
            end;

            if u110 then
                u110:Disconnect();
                u110 = nil;
            end;

            local v135 = Pather(p121, v132);

            if v135:IsValidPath() then
                HandleMoveTo(v135, p121, v133, Character);

                return;
            end;

            v135:Cleanup();

            if u108 and u108:IsActive() then
                u108:Cancel();
            end;

            if u4 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(p121);

            return;
        end;

        return;
    end;

    local v136 = nil;
    local v137 = nil;
    local v138;

    if u27 then
        v138 = u27;
    else
        u27 = {};
        assert(u27, "");
        table.insert(u27, LocalPlayer and LocalPlayer.Character);
        v138 = u27;
    end;

    if not v138 then
        v138 = {};
    end;

    while true do
        local v139 = true;
        RaycastParams_new_ret.FilterDescendantsInstances = v138;
        local v140 = Workspace:Raycast(v128.Origin, v128.Direction * 1000, RaycastParams_new_ret);
        local v141, v142;

        if v140 then
            local Instance2 = v140.Instance;

            if not Instance2.CanCollide then
                local v143;

                while true do
                    v136 = Instance2:FindFirstChildOfClass("Humanoid");
                    v143 = Instance2.Parent;

                    if v136 or (not v143 or v143 == Workspace) then
                        break;
                    end;

                    Instance2 = v143;
                end;

                if v136 then
                    v137 = Instance2;
                else
                    table.insert(v138, v143);
                    v139 = false;
                    v137 = nil;
                end;

                if v139 then
                    if p122 and (v136 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v136.Parent))) then
                        if u108 then
                            u108:Cancel();
                            u108 = nil;
                        end;

                        if u109 then
                            u109:Disconnect();
                            u109 = nil;
                        end;

                        if u110 then
                            u110:Disconnect();
                            u110 = nil;
                        end;

                        return;
                    end;

                    if not (v140 and Character) then
                        return;
                    end;

                    v141 = v140.Position;

                    if p121 then
                        v137 = nil;
                    else
                        p121 = v141;
                    end;

                    if u108 then
                        u108:Cancel();
                        u108 = nil;
                    end;

                    if u109 then
                        u109:Disconnect();
                        u109 = nil;
                    end;

                    if u110 then
                        u110:Disconnect();
                        u110 = nil;
                    end;

                    v142 = Pather(p121, v140.Normal);

                    if v142:IsValidPath() then
                        HandleMoveTo(v142, p121, v137, Character);

                        return;
                    end;

                    v142:Cleanup();

                    if u108 and u108:IsActive() then
                        u108:Cancel();
                    end;

                    if u4 then
                        ClickToMoveDisplay.PlayFailureAnimation();
                    end;

                    ClickToMoveDisplay.DisplayFailureWaypoint(p121);

                    return;
                end;
            end;
        end;

        if v139 then
            if p122 and (v136 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v136.Parent))) then
                if u108 then
                    u108:Cancel();
                    u108 = nil;
                end;

                if u109 then
                    u109:Disconnect();
                    u109 = nil;
                end;

                if u110 then
                    u110:Disconnect();
                    u110 = nil;
                end;

                return;
            end;

            if not (v140 and Character) then
                return;
            end;

            v141 = v140.Position;

            if p121 then
                v137 = nil;
            else
                p121 = v141;
            end;

            if u108 then
                u108:Cancel();
                u108 = nil;
            end;

            if u109 then
                u109:Disconnect();
                u109 = nil;
            end;

            if u110 then
                u110:Disconnect();
                u110 = nil;
            end;

            v142 = Pather(p121, v140.Normal);

            if v142:IsValidPath() then
                HandleMoveTo(v142, p121, v137, Character);

                return;
            end;

            v142:Cleanup();

            if u108 and u108:IsActive() then
                u108:Cancel();
            end;

            if u4 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(p121);

            return;
        end;
    end;
end;

local function DisconnectEvent(p144) -- Line: 850
    if p144 then
        p144:Disconnect();
    end;
end;

local Keyboard = require(script.Parent:WaitForChild("Keyboard"));
local u145 = setmetatable({}, Keyboard);
u145.__index = u145;

function u145.new(p146) -- Line: 861
    -- upvalues: Keyboard (copy), u145 (copy)
    local v147 = Keyboard.new(p146);
    local v148 = setmetatable(v147, u145);
    v148.fingerTouches = {};
    v148.numUnsunkTouches = 0;
    v148.mouse1Down = tick();
    v148.mouse1DownPos = Vector2.new();
    v148.mouse2DownTime = tick();
    v148.mouse2DownPos = Vector2.new();
    v148.mouse2UpTime = tick();
    v148.keyboardMoveVector = Vector3.new(0, 0, 0);
    v148.tapConn = nil;
    v148.inputBeganConn = nil;
    v148.inputChangedConn = nil;
    v148.inputEndedConn = nil;
    v148.humanoidDiedConn = nil;
    v148.characterChildAddedConn = nil;
    v148.onCharacterAddedConn = nil;
    v148.characterChildRemovedConn = nil;
    v148.renderSteppedConn = nil;
    v148.menuOpenedConnection = nil;
    v148.running = false;
    v148.wasdEnabled = false;

    return v148;
end;

function u145.DisconnectEvents(p149) -- Line: 893
    local tapConn = p149.tapConn;

    if tapConn then
        tapConn:Disconnect();
    end;

    local inputBeganConn = p149.inputBeganConn;

    if inputBeganConn then
        inputBeganConn:Disconnect();
    end;

    local inputChangedConn = p149.inputChangedConn;

    if inputChangedConn then
        inputChangedConn:Disconnect();
    end;

    local inputEndedConn = p149.inputEndedConn;

    if inputEndedConn then
        inputEndedConn:Disconnect();
    end;

    local humanoidDiedConn = p149.humanoidDiedConn;

    if humanoidDiedConn then
        humanoidDiedConn:Disconnect();
    end;

    local characterChildAddedConn = p149.characterChildAddedConn;

    if characterChildAddedConn then
        characterChildAddedConn:Disconnect();
    end;

    local onCharacterAddedConn = p149.onCharacterAddedConn;

    if onCharacterAddedConn then
        onCharacterAddedConn:Disconnect();
    end;

    local renderSteppedConn = p149.renderSteppedConn;

    if renderSteppedConn then
        renderSteppedConn:Disconnect();
    end;

    local characterChildRemovedConn = p149.characterChildRemovedConn;

    if characterChildRemovedConn then
        characterChildRemovedConn:Disconnect();
    end;

    local menuOpenedConnection = p149.menuOpenedConnection;

    if menuOpenedConnection then
        menuOpenedConnection:Disconnect();
    end;
end;

function u145.OnTouchBegan(p150, p151, p152) -- Line: 906
    if p150.fingerTouches[p151] == nil and not p152 then
        p150.numUnsunkTouches = p150.numUnsunkTouches + 1;
    end;

    p150.fingerTouches[p151] = p152;
end;

function u145.OnTouchChanged(p153, p154, p155) -- Line: 913
    if p153.fingerTouches[p154] == nil then
        p153.fingerTouches[p154] = p155;

        if not p155 then
            p153.numUnsunkTouches = p153.numUnsunkTouches + 1;
        end;
    end;
end;

function u145.OnTouchEnded(p156, p157, p158) -- Line: 922
    if p156.fingerTouches[p157] ~= nil and p156.fingerTouches[p157] == false then
        p156.numUnsunkTouches = p156.numUnsunkTouches - 1;
    end;

    p156.fingerTouches[p157] = nil;
end;

function u145.OnCharacterAdded(u159, p160) -- Line: 930
    -- upvalues: UserInputService (copy), u8 (copy), u108 (ref), u109 (ref), u110 (ref), ClickToMoveDisplay (copy), GuiService (copy)
    u159:DisconnectEvents();
    u159.inputBeganConn = UserInputService.InputBegan:Connect(function(p161, p162) -- Line: 933
        -- upvalues: u159 (copy), u8 (ref), u108 (ref), u109 (ref), u110 (ref), ClickToMoveDisplay (ref)
        if p161.UserInputType == Enum.UserInputType.Touch then
            u159:OnTouchBegan(p161, p162);
        end;

        if u159.wasdEnabled and (p162 == false and (p161.UserInputType == Enum.UserInputType.Keyboard and u8[p161.KeyCode])) then
            if u108 then
                u108:Cancel();
                u108 = nil;
            end;

            if u109 then
                u109:Disconnect();
                u109 = nil;
            end;

            if u110 then
                u110:Disconnect();
                u110 = nil;
            end;

            ClickToMoveDisplay.CancelFailureAnimation();
        end;

        if p161.UserInputType == Enum.UserInputType.MouseButton1 then
            u159.mouse1DownTime = tick();
            u159.mouse1DownPos = p161.Position;
        end;

        if p161.UserInputType == Enum.UserInputType.MouseButton2 then
            u159.mouse2DownTime = tick();
            u159.mouse2DownPos = p161.Position;
        end;
    end);
    u159.inputChangedConn = UserInputService.InputChanged:Connect(function(p163, p164) -- Line: 954
        -- upvalues: u159 (copy)
        if p163.UserInputType == Enum.UserInputType.Touch then
            u159:OnTouchChanged(p163, p164);
        end;
    end);
    u159.inputEndedConn = UserInputService.InputEnded:Connect(function(p165, p166) -- Line: 960
        -- upvalues: u159 (copy), u108 (ref)
        if p165.UserInputType == Enum.UserInputType.Touch then
            u159:OnTouchEnded(p165, p166);
        end;

        if p165.UserInputType == Enum.UserInputType.MouseButton2 then
            u159.mouse2UpTime = tick();
            local Position = p165.Position;

            if u159.mouse2UpTime - u159.mouse2DownTime < 0.25 and ((Position - u159.mouse2DownPos).magnitude < 5 and (u108 or u159.keyboardMoveVector.Magnitude <= 0)) then
                OnTap({ Position });
            end;
        end;
    end);
    u159.tapConn = UserInputService.TouchTap:Connect(function(p167, p168) -- Line: 977
        if not p168 then
            OnTap(p167, nil, true);
        end;
    end);
    u159.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- Line: 983
        -- upvalues: u108 (ref), u109 (ref), u110 (ref)
        if u108 then
            u108:Cancel();
            u108 = nil;
        end;

        if u109 then
            u109:Disconnect();
            u109 = nil;
        end;

        if u110 then
            u110:Disconnect();
            u110 = nil;
        end;
    end);

    local function OnCharacterChildAdded(p169) -- Line: 987
        -- upvalues: UserInputService (ref), u159 (copy)
        if UserInputService.TouchEnabled and p169:IsA("Tool") then
            p169.ManualActivationOnly = true;
        end;

        if p169:IsA("Humanoid") then
            local humanoidDiedConn = u159.humanoidDiedConn;

            if humanoidDiedConn then
                humanoidDiedConn:Disconnect();
            end;

            u159.humanoidDiedConn = p169.Died:Connect(function() -- Line: 995
            end);
        end;
    end;

    u159.characterChildAddedConn = p160.ChildAdded:Connect(function(p170) -- Line: 1003
        -- upvalues: OnCharacterChildAdded (copy)
        OnCharacterChildAdded(p170);
    end);
    u159.characterChildRemovedConn = p160.ChildRemoved:Connect(function(p171) -- Line: 1006
        -- upvalues: UserInputService (ref)
        if UserInputService.TouchEnabled and p171:IsA("Tool") then
            p171.ManualActivationOnly = false;
        end;
    end);

    for _, child in pairs(p160:GetChildren()) do
        OnCharacterChildAdded(child);
    end;
end;

function u145.Start(p172) -- Line: 1018
    p172:Enable(true);
end;

function u145.Stop(p173) -- Line: 1022
    p173:Enable(false);
end;

function u145.CleanupPath(p174) -- Line: 1026
    -- upvalues: u108 (ref), u109 (ref), u110 (ref)
    if u108 then
        u108:Cancel();
        u108 = nil;
    end;

    if u109 then
        u109:Disconnect();
        u109 = nil;
    end;

    if u110 then
        u110:Disconnect();
        u110 = nil;
    end;
end;

function u145.Enable(u175: table, p176: boolean, p177: boolean, p178: any) -- Line: 1030
    -- upvalues: LocalPlayer (copy), u108 (ref), u109 (ref), u110 (ref), UserInputService (copy), Keyboard (copy)
    if p176 then
        if not u175.running then
            if LocalPlayer.Character then
                u175:OnCharacterAdded(LocalPlayer.Character);
            end;

            u175.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(p179) -- Line: 1036
                -- upvalues: u175 (copy)
                u175:OnCharacterAdded(p179);
            end);
            u175.running = true;
        end;

        u175.touchJumpController = p178;

        if u175.touchJumpController then
            u175.touchJumpController:Enable(u175.jumpEnabled);
        end;
    else
        if u175.running then
            u175:DisconnectEvents();

            if u108 then
                u108:Cancel();
                u108 = nil;
            end;

            if u109 then
                u109:Disconnect();
                u109 = nil;
            end;

            if u110 then
                u110:Disconnect();
                u110 = nil;
            end;

            if UserInputService.TouchEnabled then
                local Character = LocalPlayer.Character;

                if Character then
                    for _, child in pairs(Character:GetChildren()) do
                        if child:IsA("Tool") then
                            child.ManualActivationOnly = false;
                        end;
                    end;
                end;
            end;

            u175.running = false;
        end;

        if u175.touchJumpController and not u175.jumpEnabled then
            u175.touchJumpController:Enable(true);
        end;

        u175.touchJumpController = nil;
    end;

    Keyboard.Enable(u175, p176);
    u175.wasdEnabled = p176 and p177 and p177 or false;
    u175.enabled = p176;
end;

function u145.OnRenderStepped(p180, p181) -- Line: 1075
    -- upvalues: u108 (ref)
    p180.isJumping = false;

    if u108 then
        u108:OnRenderStepped(p181);

        if u108 then
            p180.moveVector = u108.NextActionMoveDirection;
            p180.moveVectorIsCameraRelative = false;

            if u108.NextActionJump then
                p180.isJumping = true;
            end;
        else
            p180.moveVector = p180.keyboardMoveVector;
            p180.moveVectorIsCameraRelative = true;
        end;
    else
        p180.moveVector = p180.keyboardMoveVector;
        p180.moveVectorIsCameraRelative = true;
    end;

    if p180.jumpRequested then
        p180.isJumping = true;
    end;
end;

function u145.UpdateMovement(p182, p183) -- Line: 1110
    if p183 == Enum.UserInputState.Cancel then
        p182.keyboardMoveVector = Vector3.new(0, 0, 0);

        return;
    end;

    if p182.wasdEnabled then
        p182.keyboardMoveVector = Vector3.new(p182.leftValue + p182.rightValue, 0, p182.forwardValue + p182.backwardValue);
    end;
end;

function u145.UpdateJump(p184) -- Line: 1119
end;

function u145.SetShowPath(p185, p186) -- Line: 1124
    -- upvalues: u3 (ref)
    u3 = p186;
end;

function u145.GetShowPath(p187) -- Line: 1128
    -- upvalues: u3 (ref)
    return u3;
end;

function u145.SetWaypointTexture(p188, p189) -- Line: 1132
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointTexture(p189);
end;

function u145.GetWaypointTexture(p190) -- Line: 1136
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointTexture();
end;

function u145.SetWaypointRadius(p191, p192) -- Line: 1140
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointRadius(p192);
end;

function u145.GetWaypointRadius(p193) -- Line: 1144
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointRadius();
end;

function u145.SetEndWaypointTexture(p194, p195) -- Line: 1148
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetEndWaypointTexture(p195);
end;

function u145.GetEndWaypointTexture(p196) -- Line: 1152
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetEndWaypointTexture();
end;

function u145.SetWaypointsAlwaysOnTop(p197, p198) -- Line: 1156
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p198);
end;

function u145.GetWaypointsAlwaysOnTop(p199) -- Line: 1160
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointsAlwaysOnTop();
end;

function u145.SetFailureAnimationEnabled(p200, p201) -- Line: 1164
    -- upvalues: u4 (ref)
    u4 = p201;
end;

function u145.GetFailureAnimationEnabled(p202) -- Line: 1168
    -- upvalues: u4 (ref)
    return u4;
end;

function u145.SetIgnoredPartsTag(p203, p204) -- Line: 1172
    -- upvalues: UpdateIgnoreTag (copy)
    UpdateIgnoreTag(p204);
end;

function u145.GetIgnoredPartsTag(p205) -- Line: 1176
    -- upvalues: u28 (ref)
    return u28;
end;

function u145.SetUseDirectPath(p206, p207) -- Line: 1180
    -- upvalues: u5 (ref)
    u5 = p207;
end;

function u145.GetUseDirectPath(p208) -- Line: 1184
    -- upvalues: u5 (ref)
    return u5;
end;

function u145.SetAgentSizeIncreaseFactor(p209: table, p210: number) -- Line: 1188
    -- upvalues: u6 (ref)
    u6 = p210 / 100 + 1;
end;

function u145.GetAgentSizeIncreaseFactor(p211) -- Line: 1192
    -- upvalues: u6 (ref)
    return (u6 - 1) * 100;
end;

function u145.SetUnreachableWaypointTimeout(p212, p213) -- Line: 1196
    -- upvalues: u7 (ref)
    u7 = p213;
end;

function u145.GetUnreachableWaypointTimeout(p214) -- Line: 1200
    -- upvalues: u7 (ref)
    return u7;
end;

function u145.SetUserJumpEnabled(p215, p216) -- Line: 1204
    p215.jumpEnabled = p216;

    if p215.touchJumpController then
        p215.touchJumpController:Enable(p216);
    end;
end;

function u145.GetUserJumpEnabled(p217) -- Line: 1211
    return p217.jumpEnabled;
end;

function u145.MoveTo(p218, p219, p220, p221) -- Line: 1215
    -- upvalues: LocalPlayer (copy), Pather (copy), HandleMoveTo (copy)
    local Character = LocalPlayer.Character;

    if Character == nil then
        return false;
    end;

    local v222 = Pather(p219, Vector3.new(0, 1, 0), p221);

    if not (v222 and v222:IsValidPath()) then
        return false;
    end;

    HandleMoveTo(v222, p219, nil, Character, p220);

    return true;
end;

return u145;