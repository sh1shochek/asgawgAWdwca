-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local PartMultipliers = require(script.Parent.Configuration.PartMultipliers);
local RigConfiguration = require(script.Parent.Configuration.RigConfiguration);
local u1 = {};
local BodyParts = RigConfiguration.BodyParts;
local JointOrder = RigConfiguration.JointOrder;
local Joints = RigConfiguration.Joints;
local Colliders = RigConfiguration.Colliders;
local NoCollisionPairs = RigConfiguration.NoCollisionPairs;
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = setmetatable({}, {
    __mode = "k"
});

local function profileScope(p4: string, p5: function) -- Line: 59
    debug.profilebegin(p4);
    local success, result = pcall(p5);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    return result;
end;

local function isBodyMotor(p6: userdata, p7: userdata) -- Line: 69
    local Part0 = p7.Part0;
    local Part1 = p7.Part1;
    local v8;

    if Part0 == nil or (Part1 == nil or (Part0.Parent ~= p6 or Part1.Parent ~= p6)) then
        v8 = false;
    else
        v8 = not (Part0:HasTag("CharacterAccessory") or Part1:HasTag("CharacterAccessory"));

        if v8 then
            if Part0.Name == "CameraPart" then
                v8 = false;
            else
                v8 = Part1.Name ~= "CameraPart";
            end;
        end;
    end;

    return v8;
end;

local function collectBodyMotors(p9: userdata) -- Line: 82
    -- upvalues: Joints (copy), isBodyMotor (copy), JointOrder (copy)
    local v10 = {};

    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("Motor6D") and (Joints[descendant.Name] ~= nil and (v10[descendant.Name] == nil and isBodyMotor(p9, descendant))) then
            v10[descendant.Name] = descendant;
        end;
    end;

    local v11 = {};

    for _, v in JointOrder do
        if not v10[v] then
            table.insert(v11, v);
        end;
    end;

    return v10, v11;
end;

local function resolveBodyMotors(p12: userdata) -- Line: 105
    -- upvalues: collectBodyMotors (copy)
    debug.profilebegin("Ragdoll.Prepare.ResolveMotors");
    local v13, v14 = collectBodyMotors(p12);
    debug.profileend();

    return v13, v14;
end;

local function waitForBodyMotors(p15: userdata) -- Line: 112
    -- upvalues: collectBodyMotors (copy)
    local v16 = os.clock() + 3;
    debug.profilebegin("Ragdoll.Prepare.ResolveMotors");
    local v17, v18 = collectBodyMotors(p15);
    debug.profileend();

    while #v18 > 0 and (p15.Parent and os.clock() < v16) do
        task.wait(0.05);
        debug.profilebegin("Ragdoll.Prepare.ResolveMotors");
        v17, v18 = collectBodyMotors(p15);
        debug.profileend();
    end;

    return v17, v18;
end;

local function configurePreparedBodyPart(p19: userdata, p20: userdata) -- Line: 126
    -- upvalues: BodyParts (copy)
    local v21 = p20:HasTag("CharacterAccessory");
    local v22 = p20.Name == "HumanoidRootPart" and true or p20.Name == "CameraPart";
    local v23 = p20:GetAttribute("RagdollCollider") == true;
    local v24;

    if p20.Parent == p19 then
        v24 = BodyParts[p20.Name];
    else
        v24 = nil;
    end;

    local v25;

    if p20.Parent == p19 then
        v25 = not v21;
    else
        v25 = false;
    end;

    p20.Anchored = v25;
    p20.CanCollide = false;
    p20.CanQuery = false;
    p20.CanTouch = false;
    p20.CollisionGroup = "Debris";

    if v23 or (v21 or (v22 or v24 == nil)) then
        p20.Massless = true;
    else
        p20.Massless = v24.Massless;
    end;

    if not v23 then
        if v24 == nil then
            v23 = false;
        else
            v23 = v24.CanCollide and not v21 and not v22;
        end;
    end;

    return v23;
end;

local function getEntryMotor(p26: userdata) -- Line: 147
    local Motor = p26:FindFirstChild("Motor");
    local v27;

    if Motor and Motor:IsA("ObjectValue") then
        v27 = Motor.Value;
    else
        v27 = nil;
    end;

    if v27 and v27:IsA("Motor6D") then
        return v27;
    end;

    return nil;
end;

local function enablePreparedConstraints(p28: userdata) -- Line: 153
    for _, descendant in p28:GetDescendants() do
        if descendant:IsA("BallSocketConstraint") or (descendant:IsA("HingeConstraint") or descendant:IsA("NoCollisionConstraint")) then
            descendant.Enabled = true;
        end;
    end;
end;

local function findBodyPart(p29: userdata, p30: string) -- Line: 165
    local v31 = p29:FindFirstChild(p30);

    if v31 and v31:IsA("BasePart") then
        return v31;
    end;

    return nil;
end;

local function createAttachment(p32: userdata, p33: string, p34) -- Line: 170
    local Attachment = Instance.new("Attachment");
    Attachment.Name = p33;
    Attachment.CFrame = p34;
    Attachment.Parent = p32;

    return Attachment;
end;

local function createConstraint(p35: userdata, p36: userdata, p37: number, p38: number, p39: any) -- Line: 178
    local v40 = p35:FindFirstChild(p39.Part0);

    if not (v40 and v40:IsA("BasePart")) then
        v40 = nil;
    end;

    local v41 = p35:FindFirstChild(p39.Part1);

    if not (v41 and v41:IsA("BasePart")) then
        v41 = nil;
    end;

    if not (v40 and v41) then
        return;
    end;

    local v42 = `Ragdoll_{p37}_{p38}`;
    local v43 = `{v42}_0`;
    local Attachment0 = p39.Attachment0;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = v43;
    Attachment.CFrame = Attachment0;
    Attachment.Parent = v40;
    local v44 = `{v42}_1`;
    local Attachment1 = p39.Attachment1;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Name = v44;
    Attachment2.CFrame = Attachment1;
    Attachment2.Parent = v41;
    local v45 = p39.Kind == "BallSocket";
    local Instance_new_ret = Instance.new(v45 and "BallSocketConstraint" or "HingeConstraint");
    Instance_new_ret.Name = "Constraint";
    Instance_new_ret.Attachment0 = Attachment;
    Instance_new_ret.Attachment1 = Attachment2;
    Instance_new_ret.LimitsEnabled = p39.LimitsEnabled;

    if v45 then
        Instance_new_ret.UpperAngle = p39.UpperAngle;
        Instance_new_ret.TwistLimitsEnabled = p39.TwistLimitsEnabled;
        Instance_new_ret.TwistLowerAngle = p39.TwistLowerAngle;
        Instance_new_ret.TwistUpperAngle = p39.TwistUpperAngle;
        Instance_new_ret.MaxFrictionTorque = p39.MaxFrictionTorque;
    else
        Instance_new_ret.LowerAngle = p39.LowerAngle;
        Instance_new_ret.UpperAngle = p39.UpperAngle;
        Instance_new_ret.ActuatorType = p39.ActuatorType;
        Instance_new_ret.AngularResponsiveness = p39.AngularResponsiveness;
        Instance_new_ret.AngularSpeed = p39.AngularSpeed;
        Instance_new_ret.AngularVelocity = p39.AngularVelocity;
        Instance_new_ret.MotorMaxAcceleration = p39.MotorMaxAcceleration;
        Instance_new_ret.MotorMaxTorque = p39.MotorMaxTorque;
        Instance_new_ret.ServoMaxTorque = p39.ServoMaxTorque;
        Instance_new_ret.TargetAngle = p39.TargetAngle;
    end;

    Instance_new_ret.Radius = p39.Radius;
    Instance_new_ret.Restitution = p39.Restitution;
    Instance_new_ret.Enabled = false;
    Instance_new_ret.Parent = p36;
end;

local function createColliders(p46: userdata) -- Line: 225
    -- upvalues: Colliders (copy), RigConfiguration (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "RagdollColliders";

    for i, v in Colliders do
        local v47 = p46:FindFirstChild(i);

        if not (v47 and v47:IsA("BasePart")) then
            v47 = nil;
        end;

        if v47 then
            local Part = Instance.new("Part");
            Part.Name = `Collider_{i}`;
            Part.Shape = Enum.PartType.Ball;
            Part.Size = RigConfiguration.ColliderSize;
            Part.Transparency = 1;
            Part.Anchored = false;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Massless = true;
            Part.CFrame = v47.CFrame * v;
            Part:SetAttribute("RagdollCollider", true);
            Part.Parent = Folder;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Name = "Weld";
            WeldConstraint.Part0 = Part;
            WeldConstraint.Part1 = v47;
            WeldConstraint.Parent = Part;
        end;
    end;

    Folder.Parent = p46;

    return Folder;
end;

local function createNoCollisionPairs(p48: userdata, p49: userdata) -- Line: 260
    -- upvalues: NoCollisionPairs (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "CollisionPairs";

    for i, v in NoCollisionPairs do
        local string_find_ret = string.find(i, "|", 1, true);

        if string_find_ret then
            local v50 = p48:FindFirstChild((string.sub(i, 1, string_find_ret - 1)));

            if not (v50 and v50:IsA("BasePart")) then
                v50 = nil;
            end;

            local v51 = p48:FindFirstChild((string.sub(i, string_find_ret + 1)));

            if not (v51 and v51:IsA("BasePart")) then
                v51 = nil;
            end;

            if v50 and v51 then
                for i2 = 1, v do
                    local NoCollisionConstraint = Instance.new("NoCollisionConstraint");
                    NoCollisionConstraint.Name = `NoCollision_{i2}`;
                    NoCollisionConstraint.Part0 = v50;
                    NoCollisionConstraint.Part1 = v51;
                    NoCollisionConstraint.Enabled = false;
                    NoCollisionConstraint.Parent = Folder;
                    local _ = i2;
                end;
            end;
        end;
    end;

    Folder.Parent = p49;
end;

local function scheduleLocalSettle(u52: userdata) -- Line: 289
    -- upvalues: RunService (copy)
    task.delay(5, function() -- Line: 290
        -- upvalues: u52 (copy), RunService (ref)
        local v53 = 0;
        local v54 = 0;

        while u52.Parent and u52:GetAttribute("Ragdolled") == true do
            local v55 = RunService.Heartbeat:Wait();
            v53 = v53 + v55;
            local v56 = true;
            local v57 = false;
            local v58 = false;

            for _, v in u52:QueryDescendants("BasePart") do
                if not v.Anchored then
                    local Magnitude = v.AssemblyLinearVelocity.Magnitude;

                    if Magnitude >= 0.13 or v.AssemblyAngularVelocity.Magnitude >= 0.13 then
                        v56 = false;
                    end;

                    v57 = Magnitude >= 6 and true or v57;

                    if v.Position.Y < -400 then
                        v58 = true;
                    end;
                end;
            end;

            v54 = not v56 and 0 or v54 + v55;

            if v54 >= 0.2 or v53 >= 2.5 and not v57 or v58 then
                for _, v in u52:QueryDescendants("BasePart") do
                    v.Anchored = true;
                end;

                return;
            end;
        end;
    end);
end;

function u1.IsPrepared(p59: userdata) -- Line: 333
    local RagdollJoints = p59:FindFirstChild("RagdollJoints");
    local RagdollColliders = p59:FindFirstChild("RagdollColliders");
    local v60;

    if p59:GetAttribute("RagdollReady") == true and RagdollJoints ~= nil then
        v60 = RagdollJoints:IsA("Folder");

        if v60 then
            if RagdollColliders == nil then
                v60 = false;
            else
                v60 = RagdollColliders:IsA("Folder");
            end;
        end;
    else
        v60 = false;
    end;

    return v60;
end;

local function prepare(u61: userdata) -- Line: 343
    -- upvalues: u1 (copy), waitForBodyMotors (copy), JointOrder (copy), Joints (copy), createConstraint (copy), createNoCollisionPairs (copy), createColliders (copy)
    if u1.IsPrepared(u61) then
        return true;
    end;

    local u62, v63 = waitForBodyMotors(u61);

    if #v63 > 0 then
        local table_concat_ret = table.concat(v63, ", ");
        warn((`[Ragdoll] Skipping preparation for {u61:GetFullName()}; missing body motors: {table_concat_ret}`));

        return false;
    end;

    local function v72() -- Line: 355
        -- upvalues: u61 (copy), JointOrder (ref), u62 (copy), Joints (ref), createConstraint (ref), createNoCollisionPairs (ref), createColliders (ref)
        local function v65() -- Line: 356
            -- upvalues: u61 (ref)
            for _, v in { "RagdollJoints", "RagdollColliders" } do
                local v64 = u61:FindFirstChild(v);

                if v64 then
                    v64:Destroy();
                end;
            end;
        end;

        debug.profilebegin("Ragdoll.Prepare.ClearStale");
        local success, result = pcall(v65);
        debug.profileend();

        if not success then
            error(result, 0);
        end;

        local function v68() -- Line: 365
            -- upvalues: u61 (ref), JointOrder (ref), u62 (ref), Joints (ref), createConstraint (ref)
            local Folder = Instance.new("Folder");
            Folder.Name = "RagdollJoints";
            Folder.Parent = u61;
            local v66 = 0;

            for _, v in JointOrder do
                local v67 = u62[v];
                v66 = v66 + 1;
                local Folder2 = Instance.new("Folder");
                Folder2.Name = string.format("%02d_%s", v66, v67.Name);
                Folder2.Parent = Folder;
                local ObjectValue = Instance.new("ObjectValue");
                ObjectValue.Name = "Motor";
                ObjectValue.Value = v67;
                ObjectValue.Parent = Folder2;

                for i, v2 in Joints[v] do
                    createConstraint(u61, Folder2, v66, i, v2);
                end;
            end;

            return Folder;
        end;

        debug.profilebegin("Ragdoll.Prepare.Joints");
        local success2, result2 = pcall(v68);
        debug.profileend();

        if not success2 then
            error(result2, 0);
        end;

        local function v69() -- Line: 392
            -- upvalues: createNoCollisionPairs (ref), u61 (ref), result2 (copy)
            createNoCollisionPairs(u61, result2);
        end;

        debug.profilebegin("Ragdoll.Prepare.NoCollisionPairs");
        local success3, result3 = pcall(v69);
        debug.profileend();

        if not success3 then
            error(result3, 0);
        end;

        local function v70() -- Line: 395
            -- upvalues: createColliders (ref), u61 (ref)
            createColliders(u61);
        end;

        debug.profilebegin("Ragdoll.Prepare.Colliders");
        local success4, result4 = pcall(v70);
        debug.profileend();

        if not success4 then
            error(result4, 0);
        end;

        local function v71() -- Line: 398
            -- upvalues: u61 (ref)
            u61:SetAttribute("RagdollReady", true);
        end;

        debug.profilebegin("Ragdoll.Prepare.Finalize");
        local success5, result5 = pcall(v71);
        debug.profileend();

        if not success5 then
            error(result5, 0);
        end;

        return true;
    end;

    debug.profilebegin("Ragdoll.Prepare.Construct");
    local success, result = pcall(v72);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    return result;
end;

function u1.Prepare(p73: userdata) -- Line: 405
    -- upvalues: u1 (copy), u2 (copy), prepare (copy)
    if u1.IsPrepared(p73) then
        return true;
    end;

    while u2[p73] do
        task.wait();

        if u1.IsPrepared(p73) then
            return true;
        end;

        if not p73.Parent then
            return false;
        end;
    end;

    u2[p73] = true;
    local success, result = pcall(prepare, p73);
    u2[p73] = nil;

    if not success then
        error(result, 0);
    end;

    return result;
end;

function u1.CapturePose(p74: userdata) -- Line: 430
    local v75 = {};

    for _, child in p74:GetChildren() do
        if child:IsA("BasePart") and not child:HasTag("CharacterAccessory") then
            v75[child.Name] = child.CFrame;
        end;
    end;

    return v75;
end;

function u1.StagePrepared(u76: userdata) -- Line: 440
    -- upvalues: u1 (copy), u3 (copy), configurePreparedBodyPart (copy), enablePreparedConstraints (copy)
    if not u1.IsPrepared(u76) then
        return false;
    end;

    if u76:GetAttribute("RagdollStaged") == true and u3[u76] then
        return true;
    end;

    local u77 = {};
    local u78 = {};

    local function v80() -- Line: 450
        -- upvalues: u76 (copy), configurePreparedBodyPart (ref), u78 (copy), u77 (copy)
        for _, v in u76:QueryDescendants("BasePart") do
            local v79 = configurePreparedBodyPart(u76, v);
            v.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

            if v79 then
                table.insert(u78, v);
            end;

            if v.Parent == u76 and not v:HasTag("CharacterAccessory") then
                table.insert(u77, v);
            end;
        end;
    end;

    debug.profilebegin("Ragdoll.Prepare.StageParts");
    local success, result = pcall(v80);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    local v81 = {};
    local u82 = {};

    for i, v in u77 do
        v81[i] = v.CFrame;
    end;

    local function v84() -- Line: 469
        -- upvalues: u76 (copy), u82 (copy), enablePreparedConstraints (ref)
        local RagdollJoints = u76:FindFirstChild("RagdollJoints");

        for _, child in RagdollJoints:GetChildren() do
            local Motor = child:FindFirstChild("Motor");
            local v83;

            if Motor and Motor:IsA("ObjectValue") then
                v83 = Motor.Value;
            else
                v83 = nil;
            end;

            if not (v83 and v83:IsA("Motor6D")) then
                v83 = nil;
            end;

            if v83 then
                table.insert(u82, v83);
            end;
        end;

        enablePreparedConstraints(RagdollJoints);
    end;

    debug.profilebegin("Ragdoll.Prepare.EnableConstraints");
    local success2, result2 = pcall(v84);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    u3[u76] = {
        BodyParts = u77,
        CollidingParts = u78,
        Motors = u82,
        PoseCFrames = v81
    };
    u76:SetAttribute("RagdollStaged", true);

    return true;
end;

function u1.ResetPrepared(u85: userdata) -- Line: 489
    -- upvalues: u1 (copy), u3 (copy), configurePreparedBodyPart (copy), enablePreparedConstraints (copy)
    if not u1.IsPrepared(u85) then
        return false;
    end;

    if not (u3[u85] or u1.StagePrepared(u85)) then
        return false;
    end;

    local u86 = u3[u85];

    local function v87() -- Line: 498
        -- upvalues: u85 (copy), configurePreparedBodyPart (ref)
        for _, v in u85:QueryDescendants("BasePart") do
            configurePreparedBodyPart(u85, v);
            v.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;

    debug.profilebegin("Ragdoll.Pool.ResetParts");
    local success, result = pcall(v87);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    local function v88() -- Line: 505
        -- upvalues: u86 (copy), u85 (copy), enablePreparedConstraints (ref)
        for _, v in u86.Motors do
            if v.Parent then
                v.Enabled = true;
            end;
        end;

        local RagdollJoints = u85:FindFirstChild("RagdollJoints");

        if RagdollJoints and RagdollJoints:IsA("Folder") then
            enablePreparedConstraints(RagdollJoints);
        end;
    end;

    debug.profilebegin("Ragdoll.Pool.ResetJoints");
    local success2, result2 = pcall(v88);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    return true;
end;

function u1.Activate(u89: userdata, u90: table?, u91: vector?) -- Line: 520
    -- upvalues: u1 (copy), u3 (copy), CollectionService (copy), RunService (copy)
    if u89:GetAttribute("Ragdolled") == true then
        return false;
    end;

    if not (u1.IsPrepared(u89) or u1.Prepare(u89)) then
        return false;
    end;

    if not (u3[u89] or u1.StagePrepared(u89)) then
        return false;
    end;

    local u92 = u3[u89];
    local BodyParts2 = u92.BodyParts;
    debug.profilebegin("Ragdoll.Activate.DisableMotors");
    local success, result = pcall(function() -- Line: 535
        -- upvalues: u92 (copy)
        for _, v in u92.Motors do
            v.Enabled = false;
        end;
    end);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    if u90 then
        debug.profilebegin("Ragdoll.Activate.ApplyPose");
        local success2, result2 = pcall(function() -- Line: 543
            -- upvalues: BodyParts2 (copy), u92 (copy), u90 (copy), u89 (copy)
            for i, v in BodyParts2 do
                u92.PoseCFrames[i] = u90[v.Name] or v.CFrame;
            end;

            if u89:IsDescendantOf(workspace) then
                workspace:BulkMoveTo(BodyParts2, u92.PoseCFrames, Enum.BulkMoveMode.FireCFrameChanged);

                return;
            end;

            for i, v in BodyParts2 do
                v.CFrame = u92.PoseCFrames[i];
            end;
        end);
        debug.profileend();

        if not success2 then
            error(result2, 0);
        end;
    end;

    debug.profilebegin("Ragdoll.Activate.ReleaseParts");
    local success2, result2 = pcall(function() -- Line: 559
        -- upvalues: u92 (copy), BodyParts2 (copy)
        for _, v in u92.CollidingParts do
            v.CanCollide = true;
        end;

        for _, v in BodyParts2 do
            v.Anchored = false;
        end;
    end);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    debug.profilebegin("Ragdoll.Activate.ApplyVelocity");
    local success3, result3 = pcall(function() -- Line: 568
        -- upvalues: BodyParts2 (copy), u91 (copy)
        for _, v in BodyParts2 do
            v.AssemblyLinearVelocity = u91 or Vector3.new(0, 0, 0);
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end);
    debug.profileend();

    if not success3 then
        error(result3, 0);
    end;

    local function v100() -- Line: 575
        -- upvalues: u89 (copy), CollectionService (ref), RunService (ref)
        u89:SetAttribute("Ragdolled", true);
        u89:SetAttribute("RagdollCreatedAt", workspace:GetServerTimeNow());
        CollectionService:AddTag(u89, "Ragdoll");
        local u93 = u89;
        task.delay(5, function() -- Line: 290
            -- upvalues: u93 (copy), RunService (ref)
            local v94 = 0;
            local v95 = 0;

            while u93.Parent and u93:GetAttribute("Ragdolled") == true do
                local v96 = RunService.Heartbeat:Wait();
                v94 = v94 + v96;
                local v97 = true;
                local v98 = false;
                local v99 = false;

                for _, v in u93:QueryDescendants("BasePart") do
                    if not v.Anchored then
                        local Magnitude = v.AssemblyLinearVelocity.Magnitude;

                        if Magnitude >= 0.13 or v.AssemblyAngularVelocity.Magnitude >= 0.13 then
                            v97 = false;
                        end;

                        v98 = Magnitude >= 6 and true or v98;

                        if v.Position.Y < -400 then
                            v99 = true;
                        end;
                    end;
                end;

                v95 = not v97 and 0 or v95 + v96;

                if v95 >= 0.2 or v94 >= 2.5 and not v98 or v99 then
                    for _, v in u93:QueryDescendants("BasePart") do
                        v.Anchored = true;
                    end;

                    return;
                end;
            end;
        end);
    end;

    debug.profilebegin("Ragdoll.Activate.Finalize");
    local success4, result4 = pcall(v100);
    debug.profileend();

    if not success4 then
        error(result4, 0);
    end;

    return true;
end;

function u1.ApplyImpulse(p101: userdata, p102: any) -- Line: 584
    -- upvalues: GetWeaponProperties (copy), PartMultipliers (copy), BodyParts (copy)
    local v103 = p101:FindFirstChild(p102.Part);

    if not (v103 and v103:IsA("BasePart")) then
        return;
    end;

    local v104 = GetWeaponProperties(p102.Weapon);

    if not v104 then
        return;
    end;

    local Direction = p102.Direction;
    local v105 = typeof(Direction) ~= "Vector3" and 0 or Direction.Magnitude;
    local v106 = (v105 ~= v105 or v105 < 0.001) and Vector3.new(-0, -1, -0) or Direction / v105;
    local v107 = typeof(p102.DirectionMultiplier) ~= "number" and 1 or p102.DirectionMultiplier;
    local v108 = (v104.RagdollMultiplier or 45) * v107;
    local v109 = PartMultipliers[v103.Name];
    local v110;

    if v109 then
        v110 = v108 * (math.random(v109.Minimum, v109.Maximum) / 100);
    else
        v110 = v108;
    end;

    local v111 = (v103.Name == "Head" and 1 or 0) + 2.5;
    v103.AssemblyLinearVelocity = (v106 * v110 + Vector3.new(-0, -5, -0)) * v111;
    local v112 = (v106 * v108 + Vector3.new(-0, -5, -0)) * v111 * 0.1;

    for _, child in p101:GetChildren() do
        if child:IsA("BasePart") and (child ~= v103 and (BodyParts[child.Name] ~= nil and not (child.Anchored or child:HasTag("CharacterAccessory")))) then
            child.AssemblyLinearVelocity = child.AssemblyLinearVelocity + v112;
        end;
    end;
end;

function u1.DisableJoint(p113: userdata, p114: string) -- Line: 632
    local RagdollJoints = p113:FindFirstChild("RagdollJoints");

    if not (RagdollJoints and RagdollJoints:IsA("Folder")) then
        return;
    end;

    for _, child in RagdollJoints:GetChildren() do
        local Motor = child:FindFirstChild("Motor");
        local v115;

        if Motor and Motor:IsA("ObjectValue") then
            v115 = Motor.Value;
        else
            v115 = nil;
        end;

        if not (v115 and v115:IsA("Motor6D")) then
            v115 = nil;
        end;

        if v115 and v115.Name == p114 then
            for _, descendant in child:GetDescendants() do
                if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
                    descendant.Enabled = false;
                end;
            end;

            return;
        end;
    end;
end;

return u1;