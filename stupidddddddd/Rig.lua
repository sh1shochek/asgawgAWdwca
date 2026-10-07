-- ReplicatedStorage.Classes.Ragdoll.Rig
-- Script path: ReplicatedStorage.Classes.Ragdoll.Rig
-- Decompile time: 11.79 ms

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local PartMultipliers = require(script.Parent.Configuration.PartMultipliers)
local RigConfiguration = require(script.Parent.Configuration.RigConfiguration)
local u32 = {}
local BodyParts = RigConfiguration.BodyParts
local JointOrder = RigConfiguration.JointOrder
local Joints = RigConfiguration.Joints
local Colliders = RigConfiguration.Colliders
local NoCollisionPairs = RigConfiguration.NoCollisionPairs
local u41 = setmetatable({}, {__mode = "k"})
local u45 = setmetatable({}, {__mode = "k"})

local function profileScope(a1, a2) -- Line: 59 -- types: a1: string, a2: function
    debug.profilebegin(a1)
    local success, result = pcall(a2)
    debug.profileend()
    if not success then
        error(result, 0)
    end
    return result
end

local function isBodyMotor(a1, a2) -- Line: 69 -- types: a1: userdata, a2: userdata
    local Part0 = a2.Part0
    local Part1 = a2.Part1
    local v1 = false
    if Part0 ~= nil then
        v1 = false
        if Part1 ~= nil then
            v1 = false
            if Part0.Parent == a1 then
                v1 = false
                if Part1.Parent == a1 then
                    v1 = not Part0:HasTag("CharacterAccessory")
                    if v1 then
                        v1 = not Part1:HasTag("CharacterAccessory")
                        if v1 then
                            v1 = false
                            if Part0.Name ~= "CameraPart" then
                                v1 = Part1.Name ~= "CameraPart"
                            end
                        end
                    end
                end
            end
        end
    end
    return v1
end

local function collectBodyMotors(a1) -- Line: 82
    -- upvalues: Joints (val), isBodyMotor (val), JointOrder (val)
    local v1 = {}
    for i, j in a1:GetDescendants() do
        if j:IsA("Motor6D") and Joints[j.Name] ~= nil and v1[j.Name] == nil and isBodyMotor(a1, j) then
            v1[j.Name] = j
        end
    end
    local v2 = {}
    for k, n in JointOrder do
        if not v1[n] then
            table.insert(v2, n)
        end
    end
    return v1, v2
end

local function resolveBodyMotors(a1) -- Line: 105 -- upvalues: collectBodyMotors (val) -- types: a1: userdata
    debug.profilebegin("Ragdoll.Prepare.ResolveMotors")
    local v1, v2 = collectBodyMotors(a1)
    debug.profileend()
    return v1, v2
end

local function waitForBodyMotors(a1) -- Line: 112 -- upvalues: collectBodyMotors (val) -- types: a1: userdata
    local v1, v2
    local v3 = os.clock() + 3
    debug.profilebegin("Ragdoll.Prepare.ResolveMotors")
    local v4, v5 = collectBodyMotors(a1)
    debug.profileend()
    local v6 = v4
    local v7 = v5
    while #v7 > 0 do
        if not a1.Parent or not (os.clock() < v3) then
            break
        end
        task.wait(0.05)
        debug.profilebegin("Ragdoll.Prepare.ResolveMotors")
        v1, v2 = collectBodyMotors(a1)
        debug.profileend()
        v6 = v1
        v7 = v2
    end
    return v6, v7
end

local function configurePreparedBodyPart(a1, a2) -- Line: 126
    -- upvalues: BodyParts (val)
    local v1 = a2:HasTag("CharacterAccessory")
    local v2 = true
    if a2.Name ~= "HumanoidRootPart" then
        v2 = a2.Name == "CameraPart"
    end
    local v3 = a2:GetAttribute("RagdollCollider") == true
    local v4 = if a2.Parent ~= a1 then nil else BodyParts[a2.Name]
    local v5 = false
    if a2.Parent == a1 then
        v5 = not v1
    end
    a2.Anchored = v5
    a2.CanCollide = false
    a2.CanQuery = false
    a2.CanTouch = false
    a2.CollisionGroup = "Debris"
    if v3 or v1 or v2 then
        a2.Massless = true
    elseif v4 ~= nil then
        a2.Massless = v4.Massless
    else
        a2.Massless = true
    end
    local CanCollide = v3
    if not CanCollide then
        CanCollide = false
        if v4 ~= nil then
            CanCollide = v4.CanCollide and not v1 and not v2
        end
    end
    return CanCollide
end

local function getEntryMotor(a1) -- Line: 147 -- types: a1: userdata
    local Motor = a1:FindFirstChild("Motor")
    local Value = if not Motor then nil else if not Motor:IsA("ObjectValue") then nil else Motor.Value
    if Value and Value:IsA("Motor6D") then
        return Value
    end
    return nil
end

local function enablePreparedConstraints(a1) -- Line: 153 -- types: a1: userdata
    for i, j in a1:GetDescendants() do
        if j:IsA("BallSocketConstraint") or j:IsA("HingeConstraint") or j:IsA("NoCollisionConstraint") then
            j.Enabled = true
        end
    end
end

local function findBodyPart(a1, a2) -- Line: 165 -- types: a1: userdata, a2: string
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("BasePart") then
        return v1
    end
    return nil
end

local function createAttachment(a1, a2, a3) -- Line: 170 -- types: a1: userdata, a2: string, a3: userdata
    local Attachment = Instance.new("Attachment")
    Attachment.Name = a2
    Attachment.CFrame = a3
    Attachment.Parent = a1
    return Attachment
end

local function createConstraint(a1, a2, a3, a4, a5) -- Line: 178
    -- upvalues: 
    local v1 = a1:FindFirstChild(a5.Part0)
    local v2 = if not v1 then nil else if not v1:IsA("BasePart") then nil else v1
    local v3 = a1:FindFirstChild(a5.Part1)
    local v4 = if not v3 then nil else if not v3:IsA("BasePart") then nil else v3
    if v2 and v4 then
        v1 = ("Ragdoll_%*_%*"):format(a3, a4)
        local v5 = ("%*_0"):format(v1)
        local Attachment0 = a5.Attachment0
        v3 = Instance.new("Attachment")
        v3.Name = v5
        v3.CFrame = Attachment0
        v3.Parent = v2
        local v6 = ("%*_1"):format(v1)
        local Attachment1 = a5.Attachment1
        v5 = Instance.new("Attachment")
        v5.Name = v6
        v5.CFrame = Attachment1
        v5.Parent = v4
        local v7 = Instance.new(if not (a5.Kind == "BallSocket") then "HingeConstraint" else "BallSocketConstraint")
        v7.Name = "Constraint"
        v7.Attachment0 = v3
        v7.Attachment1 = v5
        v7.LimitsEnabled = a5.LimitsEnabled
        if not v6 then
            v7.LowerAngle = a5.LowerAngle
            v7.UpperAngle = a5.UpperAngle
            v7.ActuatorType = a5.ActuatorType
            v7.AngularResponsiveness = a5.AngularResponsiveness
            v7.AngularSpeed = a5.AngularSpeed
            v7.AngularVelocity = a5.AngularVelocity
            v7.MotorMaxAcceleration = a5.MotorMaxAcceleration
            v7.MotorMaxTorque = a5.MotorMaxTorque
            v7.ServoMaxTorque = a5.ServoMaxTorque
            v7.TargetAngle = a5.TargetAngle
        else
            v7.UpperAngle = a5.UpperAngle
            v7.TwistLimitsEnabled = a5.TwistLimitsEnabled
            v7.TwistLowerAngle = a5.TwistLowerAngle
            v7.TwistUpperAngle = a5.TwistUpperAngle
            v7.MaxFrictionTorque = a5.MaxFrictionTorque
        end
        v7.Radius = a5.Radius
        v7.Restitution = a5.Restitution
        v7.Enabled = false
        v7.Parent = a2
        return
    end
end

local function createColliders(a1) -- Line: 225
    -- upvalues: Colliders (val), RigConfiguration (val)
    local Part, WeldConstraint, v1, v2
    local Folder = Instance.new("Folder")
    Folder.Name = "RagdollColliders"
    local v3 = nil
    local v4 = nil
    local v5 = a1
    for i, j in Colliders, v3, v4 do
        v2 = v5:FindFirstChild(i)
        v1 = if not v2 then nil else if not v2:IsA("BasePart") then nil else v2
        if v1 then
            Part = Instance.new("Part")
            Part.Name = ("Collider_%*"):format(i)
            Part.Shape = Enum.PartType.Ball
            Part.Size = RigConfiguration.ColliderSize
            Part.Transparency = 1
            Part.Anchored = false
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Massless = true
            Part.CFrame = v1.CFrame * j
            Part:SetAttribute("RagdollCollider", true)
            Part.Parent = Folder
            WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Name = "Weld"
            WeldConstraint.Part0 = Part
            WeldConstraint.Part1 = v1
            WeldConstraint.Parent = Part
        end
    end
    Folder.Parent = v5
    return Folder
end

local function createNoCollisionPairs(a1, a2) -- Line: 260
    -- upvalues: NoCollisionPairs (val)
    local NoCollisionConstraint, v1, v2, v3, v4, v5, v6
    local Folder = Instance.new("Folder")
    Folder.Name = "CollisionPairs"
    local v7 = nil
    local v8 = nil
    local v9, v10 = a2, a1
    for i, j in NoCollisionPairs, v7, v8 do
        v5 = string.find(i, "|", 1, true)
        if v5 then
            v4 = v5 - 1
            v2 = v10:FindFirstChild((string.sub(i, 1, v4)))
            v6 = if not v2 then nil else if not v2:IsA("BasePart") then nil else v2
            v4 = v5 + 1
            v3 = v10:FindFirstChild((string.sub(i, v4)))
            v1 = if not v3 then nil else if not v3:IsA("BasePart") then nil else v3
            if v6 and v1 then
                for k = 1, j do
                    NoCollisionConstraint = Instance.new("NoCollisionConstraint")
                    NoCollisionConstraint.Name = ("NoCollision_%*"):format(k)
                    NoCollisionConstraint.Part0 = v6
                    NoCollisionConstraint.Part1 = v1
                    NoCollisionConstraint.Enabled = false
                    NoCollisionConstraint.Parent = Folder
                end
            end
        end
    end
    Folder.Parent = v9
end

local function scheduleLocalSettle(a1) -- Line: 289 -- upvalues: RunService (val) -- types: a1: userdata
    task.delay(5, function() -- Line: 290 -- upvalues: a1 (val), RunService (upval)
        local Magnitude, v1, v2, v3, v4
        local v5 = 0
        local v6 = 0
        while a1.Parent do
            if a1:GetAttribute("Ragdolled") ~= true then
                break
            end
            v1 = RunService.Heartbeat:Wait()
            v5 = v5 + v1
            v2 = true
            v3 = false
            v4 = false
            for i, j in a1:QueryDescendants("BasePart") do
                if not j.Anchored then
                    Magnitude = j.AssemblyLinearVelocity.Magnitude
                    if Magnitude >= 0.13 or 0.13 <= j.AssemblyAngularVelocity.Magnitude then
                        v2 = false
                    end
                    if Magnitude >= 6 then
                        v3 = true
                    end
                    if j.Position.Y < -400 then
                        v4 = true
                    end
                end
            end
            v6 = if not v2 then 0 else v6 + v1
            if not (v6 >= 0.2) then
                if v5 >= 2.5 and not v3 then
                    for k, n in a1:QueryDescendants("BasePart") do
                        n.Anchored = true
                    end
                    return
                end
                if not v4 then
                    continue
                end
            end
            for m, i5 in a1:QueryDescendants("BasePart") do
                i5.Anchored = true
            end
            return
        end
    end)
end

function u32.IsPrepared(a1) -- Line: 333 -- types: a1: userdata
    local RagdollJoints = a1:FindFirstChild("RagdollJoints")
    local RagdollColliders = a1:FindFirstChild("RagdollColliders")
    local v1 = false
    if a1:GetAttribute("RagdollReady") == true then
        v1 = false
        if RagdollJoints ~= nil then
            v1 = RagdollJoints:IsA("Folder")
            if v1 then
                v1 = false
                if RagdollColliders ~= nil then
                    v1 = RagdollColliders:IsA("Folder")
                end
            end
        end
    end
    return v1
end

local function prepare(a1) -- Line: 343
    -- upvalues: u32 (val), waitForBodyMotors (val), JointOrder (val), Joints (val), createConstraint (val)
    -- upvalues: createNoCollisionPairs (val), createColliders (val)
    if u32.IsPrepared(a1) then
        return true
    end
    local u8, v1 = waitForBodyMotors(a1)
    if #v1 > 0 then
        local v2 = table.concat(v1, ", ")
        warn((("[Ragdoll] Skipping preparation for %*; missing body motors: %*"):format(a1:GetFullName(), v2)))
        return false
    end
    debug.profilebegin("Ragdoll.Prepare.Construct")
    local success, result = pcall(function() -- Line: 355
        -- upvalues: a1 (val), JointOrder (upval), u8 (val), Joints (upval), createConstraint (upval)
        -- upvalues: createNoCollisionPairs (upval), createColliders (upval)
        debug.profilebegin("Ragdoll.Prepare.ClearStale")
        local success, result = pcall(function() -- Line: 356 -- upvalues: a1 (upval)
            local v1
            for i, j in {"RagdollJoints", "RagdollColliders"} do
                v1 = a1:FindFirstChild(j)
                if v1 then
                    v1:Destroy()
                end
            end
        end)
        debug.profileend()
        if not success then
            error(result, 0)
        end
        debug.profilebegin("Ragdoll.Prepare.Joints")
        local success_2, result_2 = pcall(function() -- Line: 365
            -- upvalues: a1 (upval), JointOrder (upval), u8 (upval), Joints (upval), createConstraint (upval)
            local Folder_2, ObjectValue, v1
            local Folder = Instance.new("Folder")
            Folder.Name = "RagdollJoints"
            Folder.Parent = a1
            local v2 = 0
            local v3 = nil
            local v4 = nil
            for i, j in JointOrder, v3, v4 do
                v1 = u8[j]
                v2 = v2 + 1
                Folder_2 = Instance.new("Folder")
                Folder_2.Name = string.format("%02d_%s", v2, v1.Name)
                Folder_2.Parent = Folder
                ObjectValue = Instance.new("ObjectValue")
                ObjectValue.Name = "Motor"
                ObjectValue.Value = v1
                ObjectValue.Parent = Folder_2
                for k, n in Joints[j] do
                    createConstraint(a1, Folder_2, v2, k, n)
                end
            end
            return Folder
        end)
        debug.profileend()
        if not success_2 then
            error(result_2, 0)
        end
        local u29 = result_2
        debug.profilebegin("Ragdoll.Prepare.NoCollisionPairs")
        local success_3, result_3 = pcall(function() -- Line: 392 -- upvalues: createNoCollisionPairs (upval), a1 (upval), u29 (val)
            createNoCollisionPairs(a1, u29)
        end)
        debug.profileend()
        if not success_3 then
            error(result_3, 0)
        end
        debug.profilebegin("Ragdoll.Prepare.Colliders")
        local success_4, result_4 = pcall(function() -- Line: 395 -- upvalues: createColliders (upval), a1 (upval)
            createColliders(a1)
        end)
        debug.profileend()
        if not success_4 then
            error(result_4, 0)
        end
        debug.profilebegin("Ragdoll.Prepare.Finalize")
        local success_5, result_5 = pcall(function() -- Line: 398 -- upvalues: a1 (upval)
            a1:SetAttribute("RagdollReady", true)
        end)
        debug.profileend()
        if not success_5 then
            error(result_5, 0)
        end
        return true
    end)
    debug.profileend()
    if not success then
        error(result, 0)
    end
    return result
end

function u32.Prepare(a1) -- Line: 405 -- upvalues: u32 (val), u41 (val), prepare (val) -- types: a1: userdata
    if u32.IsPrepared(a1) then
        return true
    end
    while u41[a1] do
        task.wait()
        if u32.IsPrepared(a1) then
            return true
        end
        if not a1.Parent then
            return false
        end
    end
    u41[a1] = true
    local success, result = pcall(prepare, a1)
    u41[a1] = nil
    if not success then
        error(result, 0)
    end
    return result
end

function u32.CapturePose(a1) -- Line: 430 -- types: a1: userdata
    local v1 = {}
    for i, j in a1:GetChildren() do
        if j:IsA("BasePart") and not j:HasTag("CharacterAccessory") then
            v1[j.Name] = j.CFrame
        end
    end
    return v1
end

function u32.StagePrepared(a1) -- Line: 440
    -- upvalues: u32 (val), u45 (val), configurePreparedBodyPart (val), enablePreparedConstraints (val)
    if not u32.IsPrepared(a1) then
        return false
    end
    if a1:GetAttribute("RagdollStaged") == true and u45[a1] then
        return true
    end
    local u13 = {}
    local u14 = {}
    debug.profilebegin("Ragdoll.Prepare.StageParts")
    local success, result = pcall(function() -- Line: 450 -- upvalues: a1 (val), configurePreparedBodyPart (upval), u14 (val), u13 (val)
        local v1
        for i, j in a1:QueryDescendants("BasePart") do
            v1 = configurePreparedBodyPart(a1, j)
            j.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            j.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            if v1 then
                table.insert(u14, j)
            end
            if j.Parent == a1 and not j:HasTag("CharacterAccessory") then
                table.insert(u13, j)
            end
        end
    end)
    debug.profileend()
    if not success then
        error(result, 0)
    end
    local u30 = {}
    local v1 = {}
    for i, j in u13 do
        v1[i] = j.CFrame
    end
    debug.profilebegin("Ragdoll.Prepare.EnableConstraints")
    local success_2, result_2 = pcall(function() -- Line: 469 -- upvalues: a1 (val), u30 (val), enablePreparedConstraints (upval)
        local Motor, Value, v1
        local RagdollJoints = a1:FindFirstChild("RagdollJoints")
        for i, j in RagdollJoints:GetChildren() do
            Motor = j:FindFirstChild("Motor")
            Value = if not Motor then nil else if not Motor:IsA("ObjectValue") then nil else Motor.Value
            v1 = if not Value then nil else if not Value:IsA("Motor6D") then nil else Value
            if v1 then
                table.insert(u30, v1)
            end
        end
        enablePreparedConstraints(RagdollJoints)
    end)
    debug.profileend()
    if not success_2 then
        error(result_2, 0)
    end
    u45[a1] = {BodyParts = u13, CollidingParts = u14, Motors = u30, PoseCFrames = v1}
    a1:SetAttribute("RagdollStaged", true)
    return true
end

function u32.ResetPrepared(a1) -- Line: 489
    -- upvalues: u32 (val), u45 (val), configurePreparedBodyPart (val), enablePreparedConstraints (val)
    if not u32.IsPrepared(a1) then
        return false
    end
    if not u45[a1] and not u32.StagePrepared(a1) then
        return false
    end
    local u15 = u45[a1]
    debug.profilebegin("Ragdoll.Pool.ResetParts")
    local success, result = pcall(function() -- Line: 498 -- upvalues: a1 (val), configurePreparedBodyPart (upval)
        for i, j in a1:QueryDescendants("BasePart") do
            configurePreparedBodyPart(a1, j)
            j.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            j.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
    debug.profileend()
    if not success then
        error(result, 0)
    end
    debug.profilebegin("Ragdoll.Pool.ResetJoints")
    local success_2, result_2 = pcall(function() -- Line: 505 -- upvalues: u15 (val), a1 (val), enablePreparedConstraints (upval)
        for i, j in u15.Motors do
            if j.Parent then
                j.Enabled = true
            end
        end
        local RagdollJoints = a1:FindFirstChild("RagdollJoints")
        if RagdollJoints and RagdollJoints:IsA("Folder") then
            enablePreparedConstraints(RagdollJoints)
        end
    end)
    debug.profileend()
    if not success_2 then
        error(result_2, 0)
    end
    return true
end

function u32.Activate(a1, a2, a3) -- Line: 520
    -- upvalues: u32 (val), u45 (val), CollectionService (val), RunService (val)
    if a1:GetAttribute("Ragdolled") == true then
        return false
    end
    if not u32.IsPrepared(a1) and not u32.Prepare(a1) then
        return false
    end
    if not u45[a1] and not u32.StagePrepared(a1) then
        return false
    end
    local u27 = u45[a1]
    local BodyParts = u27.BodyParts
    debug.profilebegin("Ragdoll.Activate.DisableMotors")
    local success, result = pcall(function() -- Line: 535 -- upvalues: u27 (val)
        for i, j in u27.Motors do
            j.Enabled = false
        end
    end)
    debug.profileend()
    if not success then
        error(result, 0)
    end
    if a2 then
        debug.profilebegin("Ragdoll.Activate.ApplyPose")
        local success_2, result_2 = pcall(function() -- Line: 543 -- upvalues: BodyParts (val), u27 (val), a2 (val), a1 (val)
            local CFrame, PoseCFrames_2
            local v1 = nil
            local v2 = nil
            for i, j in BodyParts, v1, v2 do
                PoseCFrames_2 = u27.PoseCFrames
                CFrame = a2[j.Name] or j.CFrame
                PoseCFrames_2[i] = CFrame
            end
            if a1:IsDescendantOf(workspace) then
                workspace:BulkMoveTo(BodyParts, u27.PoseCFrames, Enum.BulkMoveMode.FireCFrameChanged)
                return
            end
            for k, n in BodyParts do
                n.CFrame = u27.PoseCFrames[k]
            end
        end)
        debug.profileend()
        if not success_2 then
            error(result_2, 0)
        end
    end
    debug.profilebegin("Ragdoll.Activate.ReleaseParts")
    local success_3, result_3 = pcall(function() -- Line: 559 -- upvalues: u27 (val), BodyParts (val)
        for i, j in u27.CollidingParts do
            j.CanCollide = true
        end
        for k, n in BodyParts do
            n.Anchored = false
        end
    end)
    debug.profileend()
    if not success_3 then
        error(result_3, 0)
    end
    debug.profilebegin("Ragdoll.Activate.ApplyVelocity")
    local success_4, result_4 = pcall(function() -- Line: 568 -- upvalues: BodyParts (val), a3 (val)
        for i, j in BodyParts do
            j.AssemblyLinearVelocity = a3 or Vector3.new(0, 0, 0)
            j.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
    debug.profileend()
    if not success_4 then
        error(result_4, 0)
    end
    debug.profilebegin("Ragdoll.Activate.Finalize")
    local success_5, result_5 = pcall(function() -- Line: 575 -- upvalues: a1 (val), CollectionService (upval), RunService (upval)
        a1:SetAttribute("Ragdolled", true)
        a1:SetAttribute("RagdollCreatedAt", (workspace:GetServerTimeNow()))
        CollectionService:AddTag(a1, "Ragdoll")
        local u21 = a1
        task.delay(5, function() -- Line: 290 -- upvalues: u21 (val), RunService (upval)
            local Magnitude, v1, v2, v3, v4
            local v5 = 0
            local v6 = 0
            while u21.Parent do
                if u21:GetAttribute("Ragdolled") ~= true then
                    break
                end
                v1 = RunService.Heartbeat:Wait()
                v5 = v5 + v1
                v2 = true
                v3 = false
                v4 = false
                for i, j in u21:QueryDescendants("BasePart") do
                    if not j.Anchored then
                        Magnitude = j.AssemblyLinearVelocity.Magnitude
                        if Magnitude >= 0.13 or 0.13 <= j.AssemblyAngularVelocity.Magnitude then
                            v2 = false
                        end
                        if Magnitude >= 6 then
                            v3 = true
                        end
                        if j.Position.Y < -400 then
                            v4 = true
                        end
                    end
                end
                v6 = if not v2 then 0 else v6 + v1
                if not (v6 >= 0.2) then
                    if v5 >= 2.5 and not v3 then
                        for k, n in u21:QueryDescendants("BasePart") do
                            n.Anchored = true
                        end
                        return
                    end
                    if not v4 then
                        continue
                    end
                end
                for m, i5 in u21:QueryDescendants("BasePart") do
                    i5.Anchored = true
                end
                return
            end
        end)
    end)
    debug.profileend()
    if not success_5 then
        error(result_5, 0)
    end
    return true
end

function u32.ApplyImpulse(a1, a2) -- Line: 584
    -- upvalues: GetWeaponProperties (val), PartMultipliers (val), BodyParts (val)
    local v1 = a1:FindFirstChild(a2.Part)
    if v1 and v1:IsA("BasePart") then
        local v2 = GetWeaponProperties(a2.Weapon)
        if not v2 then
            return
        end
        local Direction = a2.Direction
        local Magnitude = if typeof(Direction) ~= "Vector3" then 0 else Direction.Magnitude
        local v3 = if Magnitude ~= Magnitude then Vector3.new(-0, -1, -0) else if not (Magnitude < 0.001) then Direction / Magnitude else Vector3.new(-0, -1, -0)
        local DirectionMultiplier_2 = if typeof(a2.DirectionMultiplier) ~= "number" then 1 else a2.DirectionMultiplier
        local v4 = (v2.RagdollMultiplier or 45) * DirectionMultiplier_2
        local v5 = v4
        local v6 = PartMultipliers[v1.Name]
        if v6 then
            v5 = v5 * (math.random(v6.Minimum, v6.Maximum) / 100)
        end
        local v7 = (if v1.Name ~= "Head" then 0 else 1) + 2.5
        v1.AssemblyLinearVelocity = (v3 * v5 + Vector3.new(-0, -5, -0)) * v7
        local v8 = (v3 * v4 + Vector3.new(-0, -5, -0)) * v7 * 0.1
        for i, j in a1:GetChildren() do
            if j:IsA("BasePart")
                and j ~= v1
                and BodyParts[j.Name] ~= nil
                and not j.Anchored
                and not j:HasTag("CharacterAccessory") then
                j.AssemblyLinearVelocity = j.AssemblyLinearVelocity + v8
            end
        end
        return
    end
end

function u32.DisableJoint(a1, a2) -- Line: 632 -- types: a1: userdata, a2: string
    local RagdollJoints = a1:FindFirstChild("RagdollJoints")
    if RagdollJoints and RagdollJoints:IsA("Folder") then
        local Motor, Value, v1
        for i, j in RagdollJoints:GetChildren() do
            Motor = j:FindFirstChild("Motor")
            Value = if not Motor then nil else if not Motor:IsA("ObjectValue") then nil else Motor.Value
            v1 = if not Value then nil else if not Value:IsA("Motor6D") then nil else Value
            if v1 and v1.Name == a2 then
                for k, n in j:GetDescendants() do
                    if n:IsA("BallSocketConstraint") or n:IsA("HingeConstraint") then
                        n.Enabled = false
                    end
                end
                return
            end
        end
        return
    end
end

return u32