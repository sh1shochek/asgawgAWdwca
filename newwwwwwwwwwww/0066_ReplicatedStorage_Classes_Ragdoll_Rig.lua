-- Rig (ModuleScript)
-- full path: ReplicatedStorage.Classes.Ragdoll.Rig

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local PartMultipliers = require(script.Parent.Configuration.PartMultipliers);
local RigConfiguration = require(script.Parent.Configuration.RigConfiguration);
local R6Configuration = require(script.Parent.Configuration.R6Configuration);
local u1 = {};
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = setmetatable({}, {
    __mode = "k"
});

local function profileScope(p4: string, p5: function) -- Line: 71
    debug.profilebegin(p4);
    local success, result = pcall(p5);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    return result;
end;

function u1.IsR6(p6: userdata) -- Line: 84
    local HumanoidRootPart = p6:FindFirstChild("HumanoidRootPart");
    local v7;

    if HumanoidRootPart == nil then
        v7 = false;
    else
        v7 = HumanoidRootPart:FindFirstChild("RootJoint") ~= nil;
    end;

    return v7;
end;

local function specFor(p8: userdata) -- Line: 90
    -- upvalues: u1 (copy), R6Configuration (copy), RigConfiguration (copy)
    if u1.IsR6(p8) then
        return R6Configuration;
    end;

    return RigConfiguration;
end;

local function isBodyMotor(p9: userdata, p10: userdata) -- Line: 94
    local Part0 = p10.Part0;
    local Part1 = p10.Part1;
    local v11;

    if Part0 == nil or (Part1 == nil or (Part0.Parent ~= p9 or Part1.Parent ~= p9)) then
        v11 = false;
    else
        v11 = not (Part0:HasTag("CharacterAccessory") or Part1:HasTag("CharacterAccessory"));

        if v11 then
            if Part0.Name == "CameraPart" then
                v11 = false;
            else
                v11 = Part1.Name ~= "CameraPart";
            end;
        end;
    end;

    return v11;
end;

local function collectBodyMotors(p12: userdata) -- Line: 107
    -- upvalues: u1 (copy), R6Configuration (copy), RigConfiguration (copy), isBodyMotor (copy)
    local v13;

    if u1.IsR6(p12) then
        v13 = R6Configuration;
    else
        v13 = RigConfiguration;
    end;

    local v14 = {};

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("Motor6D") and (v13.Joints[descendant.Name] ~= nil and (v14[descendant.Name] == nil and isBodyMotor(p12, descendant))) then
            v14[descendant.Name] = descendant;
        end;
    end;

    local v15 = {};

    for _, v in v13.JointOrder do
        if not v14[v] then
            table.insert(v15, v);
        end;
    end;

    return v14, v15;
end;

local function resolveBodyMotors(p16: userdata) -- Line: 131
    -- upvalues: collectBodyMotors (copy)
    debug.profilebegin("Ragdoll.Prepare.ResolveMotors");
    local v17, v18 = collectBodyMotors(p16);
    debug.profileend();

    return v17, v18;
end;

local function waitForBodyMotors(p19: userdata) -- Line: 138
    -- upvalues: collectBodyMotors (copy)
    local v20 = os.clock() + 3;
    debug.profilebegin("Ragdoll.Prepare.ResolveMotors");
    local v21, v22 = collectBodyMotors(p19);
    debug.profileend();

    while #v22 > 0 and (p19.Parent and os.clock() < v20) do
        task.wait(0.05);
        debug.profilebegin("Ragdoll.Prepare.ResolveMotors");
        v21, v22 = collectBodyMotors(p19);
        debug.profileend();
    end;

    return v21, v22;
end;

local function preparedPartPhysics(p23: userdata, p24: table, p25: userdata) -- Line: 153
    local v26 = p25:HasTag("CharacterAccessory");
    local v27 = p25.Name == "HumanoidRootPart" and true or p25.Name == "CameraPart";
    local v28 = p25:GetAttribute("RagdollCollider") == true;
    local v29;

    if p25.Parent == p23 then
        v29 = p24.BodyParts[p25.Name];
    else
        v29 = nil;
    end;

    local v30 = (v28 or (v26 or (v27 or v29 == nil))) and true or v29.Massless;

    if not v28 then
        if v29 == nil then
            v28 = false;
        else
            v28 = v29.CanCollide and (not v26 and not v27);
        end;
    end;

    return v30, v28;
end;

local function configurePreparedBodyPart(p31: userdata, p32: table, p33: userdata) -- Line: 167
    -- upvalues: preparedPartPhysics (copy)
    local v34, v35 = preparedPartPhysics(p31, p32, p33);
    local v36;

    if p33.Parent == p31 then
        v36 = not p33:HasTag("CharacterAccessory");
    else
        v36 = false;
    end;

    if p33.Anchored ~= v36 then
        p33.Anchored = v36;
    end;

    p33.CanCollide = false;
    p33.CanQuery = false;
    p33.CanTouch = false;

    if p33.CollisionGroup ~= "Debris" then
        p33.CollisionGroup = "Debris";
    end;

    if p33.Massless ~= v34 then
        p33.Massless = v34;
    end;

    return v35;
end;

local function getEntryMotor(p37: userdata) -- Line: 186
    local Motor = p37:FindFirstChild("Motor");
    local v38;

    if Motor and Motor:IsA("ObjectValue") then
        v38 = Motor.Value;
    else
        v38 = nil;
    end;

    if v38 and v38:IsA("Motor6D") then
        return v38;
    end;

    return nil;
end;

local function enablePreparedConstraints(p39: userdata) -- Line: 192
    for _, descendant in p39:GetDescendants() do
        if descendant:IsA("Constraint") then
            descendant.Enabled = true;
        end;
    end;
end;

local function findBodyPart(p40: userdata, p41: string) -- Line: 201
    local v42 = p40:FindFirstChild(p41);

    if v42 and v42:IsA("BasePart") then
        return v42;
    end;

    return nil;
end;

local function createAttachment(p43: userdata, p44: string, p45) -- Line: 206
    local Attachment = Instance.new("Attachment");
    Attachment.Name = p44;
    Attachment.CFrame = p45;
    Attachment.Parent = p43;

    return Attachment;
end;

local function createConstraint(p46: userdata, p47: userdata, p48: number, p49: number, p50: any, p51: userdata) -- Line: 216
    local v52 = p46:FindFirstChild(p50.Part0);

    if not (v52 and v52:IsA("BasePart")) then
        v52 = nil;
    end;

    local v53 = p46:FindFirstChild(p50.Part1);

    if not (v53 and v53:IsA("BasePart")) then
        v53 = nil;
    end;

    if not (v52 and v53) then
        return;
    end;

    local v54 = `Ragdoll_{p48}_{p49}`;
    local v55 = p50.FromMotor == true;
    local v56 = `{v54}_0`;
    local v57;

    if v55 then
        v57 = p51.C0;
    else
        v57 = p50.Attachment0;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = v56;
    Attachment.CFrame = v57;
    Attachment.Parent = v52;
    local v58 = `{v54}_1`;
    local v59;

    if v55 then
        v59 = p51.C1;
    else
        v59 = p50.Attachment1;
    end;

    local Attachment2 = Instance.new("Attachment");
    Attachment2.Name = v58;
    Attachment2.CFrame = v59;
    Attachment2.Parent = v53;
    local v60 = p50.Kind == "BallSocket";
    local Instance_new_ret = Instance.new(v60 and "BallSocketConstraint" or "HingeConstraint");
    Instance_new_ret.Name = "Constraint";
    Instance_new_ret.Attachment0 = Attachment;
    Instance_new_ret.Attachment1 = Attachment2;
    Instance_new_ret.LimitsEnabled = p50.LimitsEnabled;

    if v60 then
        Instance_new_ret.UpperAngle = p50.UpperAngle;
        Instance_new_ret.TwistLimitsEnabled = p50.TwistLimitsEnabled;
        Instance_new_ret.TwistLowerAngle = p50.TwistLowerAngle;
        Instance_new_ret.TwistUpperAngle = p50.TwistUpperAngle;
        Instance_new_ret.MaxFrictionTorque = p50.MaxFrictionTorque;
    else
        Instance_new_ret.LowerAngle = p50.LowerAngle;
        Instance_new_ret.UpperAngle = p50.UpperAngle;
        Instance_new_ret.ActuatorType = p50.ActuatorType;
        Instance_new_ret.AngularResponsiveness = p50.AngularResponsiveness;
        Instance_new_ret.AngularSpeed = p50.AngularSpeed;
        Instance_new_ret.AngularVelocity = p50.AngularVelocity;
        Instance_new_ret.MotorMaxAcceleration = p50.MotorMaxAcceleration;
        Instance_new_ret.MotorMaxTorque = p50.MotorMaxTorque;
        Instance_new_ret.ServoMaxTorque = p50.ServoMaxTorque;
        Instance_new_ret.TargetAngle = p50.TargetAngle;
    end;

    Instance_new_ret.Radius = p50.Radius;
    Instance_new_ret.Restitution = p50.Restitution;
    Instance_new_ret.Enabled = false;
    Instance_new_ret.Parent = p47;
end;

local function createColliders(p61: userdata) -- Line: 267
    -- upvalues: u1 (copy), R6Configuration (copy), RigConfiguration (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "RagdollColliders";
    local v62;

    if u1.IsR6(p61) then
        v62 = R6Configuration;
    else
        v62 = RigConfiguration;
    end;

    for i, v in v62.Colliders do
        local v63 = p61:FindFirstChild(i);

        if not (v63 and v63:IsA("BasePart")) then
            v63 = nil;
        end;

        if v63 then
            local Part = Instance.new("Part");
            Part.Name = `Collider_{i}`;
            Part.Shape = Enum.PartType.Ball;
            Part.Size = v62.ColliderSize;
            Part.Transparency = 1;
            Part.Anchored = false;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Massless = true;
            Part.CFrame = v63.CFrame * v;
            Part:SetAttribute("RagdollCollider", true);
            Part.Parent = Folder;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Name = "Weld";
            WeldConstraint.Part0 = Part;
            WeldConstraint.Part1 = v63;
            WeldConstraint.Parent = Part;
        end;
    end;

    Folder.Parent = p61;

    return Folder;
end;

local function scheduleLocalSettle(u64: userdata, p65: number, u66: number?) -- Line: 306
    -- upvalues: u3 (copy), RunService (copy)
    local Attribute = u64:GetAttribute("RagdollCreatedAt");
    task.delay(p65, function() -- Line: 308
        -- upvalues: u3 (ref), u64 (copy), Attribute (copy), RunService (ref), u66 (copy)
        local v67 = 0;
        local v68 = 0;
        local v69 = u3[u64];
        local v70;

        if v69 then
            v70 = v69.BodyParts;
        else
            v70 = u64:QueryDescendants("BasePart");
        end;

        local function isSameRagdoll() -- Line: 317
            -- upvalues: u64 (ref), Attribute (ref)
            local v71;

            if u64.Parent == nil or u64:GetAttribute("Ragdolled") ~= true then
                v71 = false;
            else
                v71 = u64:GetAttribute("RagdollCreatedAt") == Attribute;
            end;

            return v71;
        end;

        while true do
            local v72;

            if u64.Parent == nil or u64:GetAttribute("Ragdolled") ~= true then
                v72 = false;
            else
                v72 = u64:GetAttribute("RagdollCreatedAt") == Attribute;
            end;

            if not v72 then
                return;
            end;

            local v73 = RunService.Heartbeat:Wait();
            local v74;

            if u64.Parent == nil or u64:GetAttribute("Ragdolled") ~= true then
                v74 = false;
            else
                v74 = u64:GetAttribute("RagdollCreatedAt") == Attribute;
            end;

            if not v74 then
                return;
            end;

            v67 = v67 + v73;
            local v75 = true;
            local v76 = false;
            local v77 = false;

            for _, v in v70 do
                if not v.Anchored and v.Parent ~= nil then
                    local Magnitude = v.AssemblyLinearVelocity.Magnitude;

                    if Magnitude >= 0.13 or v.AssemblyAngularVelocity.Magnitude >= 0.13 then
                        v75 = false;
                    end;

                    v76 = Magnitude >= 6 and true or v76;

                    if v.Position.Y < -400 then
                        v77 = true;
                    end;
                end;
            end;

            v68 = not v75 and 0 or v68 + v73;

            if v68 >= 0.2 or (u66 or 2.5) <= v67 and not v76 or v77 then
                if v69 and v69.Pooled then
                    for _, v in v70 do
                        if not v.Anchored then
                            v.Anchored = true;
                        end;
                    end;

                    return;
                end;

                for _, v in u64:QueryDescendants("BasePart") do
                    v.Anchored = true;
                end;

                return;
            end;
        end;
    end);
end;

function u1.IsPrepared(p78: userdata) -- Line: 378
    local RagdollJoints = p78:FindFirstChild("RagdollJoints");
    local RagdollColliders = p78:FindFirstChild("RagdollColliders");
    local v79;

    if p78:GetAttribute("RagdollReady") == true and RagdollJoints ~= nil then
        v79 = RagdollJoints:IsA("Folder");

        if v79 then
            if RagdollColliders == nil then
                v79 = false;
            else
                v79 = RagdollColliders:IsA("Folder");
            end;
        end;
    else
        v79 = false;
    end;

    return v79;
end;

local function prepare(u80: userdata) -- Line: 388
    -- upvalues: u1 (copy), waitForBodyMotors (copy), R6Configuration (copy), RigConfiguration (copy), createConstraint (copy), createColliders (copy)
    if u1.IsPrepared(u80) then
        return true;
    end;

    local u81, v82 = waitForBodyMotors(u80);

    if #v82 > 0 then
        local table_concat_ret = table.concat(v82, ", ");
        warn((`[Ragdoll] Skipping preparation for {u80:GetFullName()}; missing body motors: {table_concat_ret}`));

        return false;
    end;

    local function v91() -- Line: 400
        -- upvalues: u80 (copy), u1 (ref), R6Configuration (ref), RigConfiguration (ref), u81 (copy), createConstraint (ref), createColliders (ref)
        local function v84() -- Line: 401
            -- upvalues: u80 (ref)
            for _, v in { "RagdollJoints", "RagdollColliders" } do
                local v83 = u80:FindFirstChild(v);

                if v83 then
                    v83:Destroy();
                end;
            end;
        end;

        debug.profilebegin("Ragdoll.Prepare.ClearStale");
        local success, result = pcall(v84);
        debug.profileend();

        if not success then
            error(result, 0);
        end;

        local function v88() -- Line: 410
            -- upvalues: u80 (ref), u1 (ref), R6Configuration (ref), RigConfiguration (ref), u81 (ref), createConstraint (ref)
            local Folder = Instance.new("Folder");
            Folder.Name = "RagdollJoints";
            Folder.Parent = u80;
            local v85;

            if u1.IsR6(u80) then
                v85 = R6Configuration;
            else
                v85 = RigConfiguration;
            end;

            local v86 = 0;

            for _, v in v85.JointOrder do
                local v87 = u81[v];
                v86 = v86 + 1;
                local Folder2 = Instance.new("Folder");
                Folder2.Name = string.format("%02d_%s", v86, v87.Name);
                Folder2.Parent = Folder;
                local ObjectValue = Instance.new("ObjectValue");
                ObjectValue.Name = "Motor";
                ObjectValue.Value = v87;
                ObjectValue.Parent = Folder2;

                for i, v2 in v85.Joints[v] do
                    createConstraint(u80, Folder2, v86, i, v2, v87);
                end;
            end;

            return Folder;
        end;

        debug.profilebegin("Ragdoll.Prepare.Joints");
        local success2, result2 = pcall(v88);
        debug.profileend();

        if not success2 then
            error(result2, 0);
        end;

        local function v89() -- Line: 441
            -- upvalues: createColliders (ref), u80 (ref)
            createColliders(u80);
        end;

        debug.profilebegin("Ragdoll.Prepare.Colliders");
        local success3, result3 = pcall(v89);
        debug.profileend();

        if not success3 then
            error(result3, 0);
        end;

        local function v90() -- Line: 444
            -- upvalues: u80 (ref)
            u80:SetAttribute("RagdollReady", true);
        end;

        debug.profilebegin("Ragdoll.Prepare.Finalize");
        local success4, result4 = pcall(v90);
        debug.profileend();

        if not success4 then
            error(result4, 0);
        end;

        return true;
    end;

    debug.profilebegin("Ragdoll.Prepare.Construct");
    local success, result = pcall(v91);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    return result;
end;

function u1.Prepare(p92: userdata) -- Line: 451
    -- upvalues: u1 (copy), u2 (copy), prepare (copy)
    if u1.IsPrepared(p92) then
        return true;
    end;

    while u2[p92] do
        task.wait();

        if u1.IsPrepared(p92) then
            return true;
        end;

        if not p92.Parent then
            return false;
        end;
    end;

    u2[p92] = true;
    local success, result = pcall(prepare, p92);
    u2[p92] = nil;

    if not success then
        error(result, 0);
    end;

    return result;
end;

function u1.CapturePose(p93: userdata) -- Line: 476
    local v94 = {};

    for _, child in p93:GetChildren() do
        if child:IsA("BasePart") and not child:HasTag("CharacterAccessory") then
            v94[child.Name] = child.CFrame;
        end;
    end;

    return v94;
end;

function u1.MatchPreparedMass(p95: userdata) -- Line: 488
    -- upvalues: u1 (copy), R6Configuration (copy), RigConfiguration (copy), preparedPartPhysics (copy)
    if not u1.IsPrepared(p95) then
        return;
    end;

    local v96;

    if u1.IsR6(p95) then
        v96 = R6Configuration;
    else
        v96 = RigConfiguration;
    end;

    for _, v in p95:QueryDescendants("BasePart") do
        local v97 = preparedPartPhysics(p95, v96, v);

        if v.Massless ~= v97 then
            v.Massless = v97;
        end;
    end;
end;

function u1.StagePrepared(u98: userdata) -- Line: 501
    -- upvalues: u1 (copy), u3 (copy), R6Configuration (copy), RigConfiguration (copy), configurePreparedBodyPart (copy), enablePreparedConstraints (copy)
    if not u1.IsPrepared(u98) then
        return false;
    end;

    if u98:GetAttribute("RagdollStaged") == true and u3[u98] then
        return true;
    end;

    local u99 = {};
    local u100 = {};
    local u101;

    if u1.IsR6(u98) then
        u101 = R6Configuration;
    else
        u101 = RigConfiguration;
    end;

    local function v103() -- Line: 512
        -- upvalues: u98 (copy), configurePreparedBodyPart (ref), u101 (copy), u100 (copy), u99 (copy)
        for _, v in u98:QueryDescendants("BasePart") do
            local v102 = configurePreparedBodyPart(u98, u101, v);
            v.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

            if v102 then
                table.insert(u100, v);
            end;

            if v.Parent == u98 and not v:HasTag("CharacterAccessory") then
                table.insert(u99, v);
            end;
        end;
    end;

    debug.profilebegin("Ragdoll.Prepare.StageParts");
    local success, result = pcall(v103);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    local v104 = {};
    local u105 = {};

    for i, v in u99 do
        v104[i] = v.CFrame;
    end;

    local function v107() -- Line: 531
        -- upvalues: u98 (copy), u105 (copy), enablePreparedConstraints (ref)
        local RagdollJoints = u98:FindFirstChild("RagdollJoints");

        for _, child in RagdollJoints:GetChildren() do
            local Motor = child:FindFirstChild("Motor");
            local v106;

            if Motor and Motor:IsA("ObjectValue") then
                v106 = Motor.Value;
            else
                v106 = nil;
            end;

            if not (v106 and v106:IsA("Motor6D")) then
                v106 = nil;
            end;

            if v106 then
                table.insert(u105, v106);
            end;
        end;

        enablePreparedConstraints(RagdollJoints);
    end;

    debug.profilebegin("Ragdoll.Prepare.EnableConstraints");
    local success2, result2 = pcall(v107);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    u3[u98] = {
        BodyParts = u99,
        CollidingParts = u100,
        Motors = u105,
        PoseCFrames = v104
    };
    u98:SetAttribute("RagdollStaged", true);

    return true;
end;

function u1.StagePooled(p108: userdata, p109: table?) -- Line: 563
    -- upvalues: u1 (copy), R6Configuration (copy), RigConfiguration (copy), preparedPartPhysics (copy), u3 (copy)
    if not u1.IsPrepared(p108) then
        return false;
    end;

    local v110 = {};
    local v111 = {};
    local v112 = {};
    local v113;

    if u1.IsR6(p108) then
        v113 = R6Configuration;
    else
        v113 = RigConfiguration;
    end;

    for _, v in p108:QueryDescendants("BasePart") do
        v110[#v110 + 1] = v;
        local _, v114 = preparedPartPhysics(p108, v113, v);

        if v114 then
            v112[#v112 + 1] = v;
        end;

        if v.Parent == p108 and not v:HasTag("CharacterAccessory") then
            v111[#v111 + 1] = v;
        end;
    end;

    local v115 = {};
    local v116 = {};

    for _, child in p108:FindFirstChild("RagdollJoints"):GetChildren() do
        local Motor = child:FindFirstChild("Motor");
        local v117;

        if Motor and Motor:IsA("ObjectValue") then
            v117 = Motor.Value;
        else
            v117 = nil;
        end;

        if not (v117 and v117:IsA("Motor6D")) then
            v117 = nil;
        end;

        local v118;

        if v117 == nil or p109 == nil then
            v118 = false;
        else
            v118 = p109[v117.Name] == true;
        end;

        if v117 and not v118 then
            v116[#v116 + 1] = v117;
        end;

        for _, descendant in child:GetDescendants() do
            if descendant:IsA("Constraint") then
                descendant.Enabled = false;

                if not v118 then
                    v115[#v115 + 1] = descendant;
                end;
            end;
        end;
    end;

    u3[p108] = {
        BodyParts = v111,
        CollidingParts = v112,
        Motors = v116,
        PoseCFrames = {},
        Pooled = {
            Parts = v110,
            Constraints = v115
        }
    };
    p108:SetAttribute("RagdollStaged", true);

    return true;
end;

function u1.ResetPrepared(u119: userdata) -- Line: 613
    -- upvalues: u1 (copy), u3 (copy), R6Configuration (copy), RigConfiguration (copy), configurePreparedBodyPart (copy), enablePreparedConstraints (copy)
    if not u1.IsPrepared(u119) then
        return false;
    end;

    if not (u3[u119] or u1.StagePrepared(u119)) then
        return false;
    end;

    local u120 = u3[u119];
    local u121;

    if u1.IsR6(u119) then
        u121 = R6Configuration;
    else
        u121 = RigConfiguration;
    end;

    local function v122() -- Line: 623
        -- upvalues: u119 (copy), configurePreparedBodyPart (ref), u121 (copy)
        for _, v in u119:QueryDescendants("BasePart") do
            configurePreparedBodyPart(u119, u121, v);
            v.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;

    debug.profilebegin("Ragdoll.Pool.ResetParts");
    local success, result = pcall(v122);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    local function v123() -- Line: 630
        -- upvalues: u120 (copy), u119 (copy), enablePreparedConstraints (ref)
        for _, v in u120.Motors do
            if v.Parent then
                v.Enabled = true;
            end;
        end;

        local RagdollJoints = u119:FindFirstChild("RagdollJoints");

        if RagdollJoints and RagdollJoints:IsA("Folder") then
            enablePreparedConstraints(RagdollJoints);
        end;
    end;

    debug.profilebegin("Ragdoll.Pool.ResetJoints");
    local success2, result2 = pcall(v123);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    return true;
end;

function u1.Activate(u124: userdata, u125: table?, u126: vector?, u127: number?, u128: number?) -- Line: 647
    -- upvalues: u1 (copy), u3 (copy), CollectionService (copy), RunService (copy)
    if u124:GetAttribute("Ragdolled") == true then
        return false;
    end;

    if not (u1.IsPrepared(u124) or u1.Prepare(u124)) then
        return false;
    end;

    if not (u3[u124] or u1.StagePrepared(u124)) then
        return false;
    end;

    local u129 = u3[u124];
    local BodyParts = u129.BodyParts;
    debug.profilebegin("Ragdoll.Activate.DisableMotors");
    local success, result = pcall(function() -- Line: 668
        -- upvalues: u129 (copy)
        for _, v in u129.Motors do
            v.Enabled = false;
        end;
    end);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    if u125 then
        debug.profilebegin("Ragdoll.Activate.ApplyPose");
        local success2, result2 = pcall(function() -- Line: 676
            -- upvalues: BodyParts (copy), u129 (copy), u125 (copy), u124 (copy)
            for i, v in BodyParts do
                u129.PoseCFrames[i] = u125[v.Name] or v.CFrame;
            end;

            if u124:IsDescendantOf(workspace) then
                workspace:BulkMoveTo(BodyParts, u129.PoseCFrames, Enum.BulkMoveMode.FireCFrameChanged);

                return;
            end;

            for i, v in BodyParts do
                v.CFrame = u129.PoseCFrames[i];
            end;
        end);
        debug.profileend();

        if not success2 then
            error(result2, 0);
        end;
    end;

    local Pooled = u129.Pooled;

    if Pooled then
        debug.profilebegin("Ragdoll.Activate.ReleasePooled");
        local success2, result2 = pcall(function() -- Line: 694
            -- upvalues: Pooled (copy), u129 (copy), BodyParts (copy)
            for _, v in Pooled.Constraints do
                v.Enabled = true;
            end;

            for _, v in Pooled.Parts do
                if v.CanQuery then
                    v.CanQuery = false;
                end;
            end;

            for _, v in u129.CollidingParts do
                if v.CollisionGroup ~= "Debris" then
                    v.CollisionGroup = "Debris";
                end;

                v.CanCollide = true;
            end;

            for _, v in BodyParts do
                if v.Anchored then
                    v.Anchored = false;
                end;
            end;
        end);
        debug.profileend();

        if not success2 then
            error(result2, 0);
        end;
    else
        debug.profilebegin("Ragdoll.Activate.ReleaseParts");
        local success2, result2 = pcall(function() -- Line: 717
            -- upvalues: u129 (copy), BodyParts (copy)
            for _, v in u129.CollidingParts do
                v.CanCollide = true;
            end;

            for _, v in BodyParts do
                v.Anchored = false;
            end;
        end);
        debug.profileend();

        if not success2 then
            error(result2, 0);
        end;
    end;

    debug.profilebegin("Ragdoll.Activate.ApplyVelocity");
    local success2, result2 = pcall(function() -- Line: 727
        -- upvalues: BodyParts (copy), u126 (copy)
        for _, v in BodyParts do
            v.AssemblyLinearVelocity = u126 or Vector3.new(0, 0, 0);
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    local function v143() -- Line: 734
        -- upvalues: u124 (copy), CollectionService (ref), u127 (copy), u128 (copy), u3 (ref), RunService (ref)
        u124:SetAttribute("Ragdolled", true);
        u124:SetAttribute("RagdollCreatedAt", workspace:GetServerTimeNow());
        CollectionService:AddTag(u124, "Ragdoll");
        local u130 = u124;
        local u131 = u128;
        local Attribute = u130:GetAttribute("RagdollCreatedAt");
        task.delay(u127 or 5, function() -- Line: 308
            -- upvalues: u3 (ref), u130 (copy), Attribute (copy), RunService (ref), u131 (copy)
            local v132 = 0;
            local v133 = 0;
            local v134 = u3[u130];
            local v135;

            if v134 then
                v135 = v134.BodyParts;
            else
                v135 = u130:QueryDescendants("BasePart");
            end;

            local function _() -- Line: 317
                -- upvalues: u130 (ref), Attribute (ref)
                local v136;

                if u130.Parent == nil or u130:GetAttribute("Ragdolled") ~= true then
                    v136 = false;
                else
                    v136 = u130:GetAttribute("RagdollCreatedAt") == Attribute;
                end;

                return v136;
            end;

            while true do
                local v137;

                if u130.Parent == nil or u130:GetAttribute("Ragdolled") ~= true then
                    v137 = false;
                else
                    v137 = u130:GetAttribute("RagdollCreatedAt") == Attribute;
                end;

                if not v137 then
                    return;
                end;

                local v138 = RunService.Heartbeat:Wait();
                local v139;

                if u130.Parent == nil or u130:GetAttribute("Ragdolled") ~= true then
                    v139 = false;
                else
                    v139 = u130:GetAttribute("RagdollCreatedAt") == Attribute;
                end;

                if not v139 then
                    return;
                end;

                v132 = v132 + v138;
                local v140 = true;
                local v141 = false;
                local v142 = false;

                for _, v in v135 do
                    if not v.Anchored and v.Parent ~= nil then
                        local Magnitude = v.AssemblyLinearVelocity.Magnitude;

                        if Magnitude >= 0.13 or v.AssemblyAngularVelocity.Magnitude >= 0.13 then
                            v140 = false;
                        end;

                        v141 = Magnitude >= 6 and true or v141;

                        if v.Position.Y < -400 then
                            v142 = true;
                        end;
                    end;
                end;

                v133 = not v140 and 0 or v133 + v138;

                if v133 >= 0.2 or (u131 or 2.5) <= v132 and not v141 or v142 then
                    if v134 and v134.Pooled then
                        for _, v in v135 do
                            if not v.Anchored then
                                v.Anchored = true;
                            end;
                        end;

                        return;
                    end;

                    for _, v in u130:QueryDescendants("BasePart") do
                        v.Anchored = true;
                    end;

                    return;
                end;
            end;
        end);
    end;

    debug.profilebegin("Ragdoll.Activate.Finalize");
    local success3, result3 = pcall(v143);
    debug.profileend();

    if not success3 then
        error(result3, 0);
    end;

    return true;
end;

function u1.Deactivate(p144: userdata) -- Line: 746
    -- upvalues: u3 (copy), CollectionService (copy)
    local v145 = u3[p144];
    local v146;

    if v145 then
        v146 = v145.Pooled;
    else
        v146 = v145;
    end;

    if v145 and v146 then
        for _, v in v146.Constraints do
            v.Enabled = false;
        end;

        for _, v in v145.Motors do
            v.Enabled = true;
        end;

        p144:SetAttribute("Ragdolled", nil);
        p144:SetAttribute("RagdollCreatedAt", nil);
        CollectionService:RemoveTag(p144, "Ragdoll");

        return;
    end;

    u3[p144] = nil;
    local RagdollJoints = p144:FindFirstChild("RagdollJoints");

    if RagdollJoints and RagdollJoints:IsA("Folder") then
        for _, descendant in RagdollJoints:GetDescendants() do
            if descendant:IsA("Constraint") then
                descendant.Enabled = false;
            end;
        end;

        for _, child in RagdollJoints:GetChildren() do
            local Motor = child:FindFirstChild("Motor");
            local v147;

            if Motor and Motor:IsA("ObjectValue") then
                v147 = Motor.Value;
            else
                v147 = nil;
            end;

            if not (v147 and v147:IsA("Motor6D")) then
                v147 = nil;
            end;

            if v147 then
                v147.Enabled = true;
            end;
        end;
    elseif v145 then
        for _, v in v145.Motors do
            v.Enabled = true;
        end;
    end;

    p144:SetAttribute("RagdollStaged", nil);
    p144:SetAttribute("Ragdolled", nil);
    p144:SetAttribute("RagdollCreatedAt", nil);
    CollectionService:RemoveTag(p144, "Ragdoll");
end;

function u1.ApplyImpulse(p148: userdata, p149: any) -- Line: 787
    -- upvalues: GetWeaponProperties (copy), PartMultipliers (copy), u1 (copy), R6Configuration (copy), RigConfiguration (copy)
    local v150 = p148:FindFirstChild(p149.Part);

    if not (v150 and v150:IsA("BasePart")) then
        return;
    end;

    local v151 = GetWeaponProperties(p149.Weapon);

    if not v151 then
        return;
    end;

    local Direction = p149.Direction;
    local v152 = typeof(Direction) ~= "Vector3" and 0 or Direction.Magnitude;
    local v153 = (v152 ~= v152 or v152 < 0.001) and Vector3.new(-0, -1, -0) or Direction / v152;
    local v154 = typeof(p149.DirectionMultiplier) ~= "number" and 1 or p149.DirectionMultiplier;
    local v155 = (v151.RagdollMultiplier or 45) * v154;
    local v156 = PartMultipliers[v150.Name];
    local v157;

    if v156 then
        v157 = v155 * (math.random(v156.Minimum, v156.Maximum) / 100);
    else
        v157 = v155;
    end;

    local v158 = (v150.Name == "Head" and 1 or 0) + 2.5;
    v150.AssemblyLinearVelocity = (v153 * v157 + Vector3.new(-0, -5, -0)) * v158;
    local v159 = (v153 * v155 + Vector3.new(-0, -5, -0)) * v158 * 0.1;
    local v160;

    if u1.IsR6(p148) then
        v160 = R6Configuration;
    else
        v160 = RigConfiguration;
    end;

    local BodyParts = v160.BodyParts;

    for _, child in p148:GetChildren() do
        if child:IsA("BasePart") and (child ~= v150 and (BodyParts[child.Name] ~= nil and not (child.Anchored or child:HasTag("CharacterAccessory")))) then
            child.AssemblyLinearVelocity = child.AssemblyLinearVelocity + v159;
        end;
    end;
end;

function u1.DisableJoint(p161: userdata, p162: string) -- Line: 836
    local RagdollJoints = p161:FindFirstChild("RagdollJoints");

    if not (RagdollJoints and RagdollJoints:IsA("Folder")) then
        return;
    end;

    for _, child in RagdollJoints:GetChildren() do
        local Motor = child:FindFirstChild("Motor");
        local v163;

        if Motor and Motor:IsA("ObjectValue") then
            v163 = Motor.Value;
        else
            v163 = nil;
        end;

        if not (v163 and v163:IsA("Motor6D")) then
            v163 = nil;
        end;

        if v163 and v163.Name == p162 then
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