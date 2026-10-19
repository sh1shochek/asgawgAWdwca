-- Grenade (ModuleScript)
-- full path: ReplicatedStorage.Controllers.Observers.Game.Grenade

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GrenadeSimulator = require(ReplicatedStorage.Shared.GrenadeSimulator);
local CreateGrenadeBurst = require(ReplicatedStorage.Components.Common.VFXLibary.CreateGrenadeBurst);
local Debris = workspace:WaitForChild("Debris");
local u1 = {};

local function hideAsDebris(p2: userdata) -- Line: 47
    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "Debris";
            descendant.Transparency = 1;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
        end;
    end;
end;

local function destroyAfter(u3: userdata, p4: number) -- Line: 59
    task.delay(p4, function() -- Line: 60
        -- upvalues: u3 (copy)
        if u3.Parent then
            u3:Destroy();
        end;
    end);
end;

local u14 = {
    ["Decoy Grenade"] = function(p5, p6, u7) -- Line: 69
        -- upvalues: hideAsDebris (copy)
        hideAsDebris(u7);
        task.delay(0.5, function() -- Line: 60
            -- upvalues: u7 (copy)
            if u7.Parent then
                u7:Destroy();
            end;
        end);
    end,

    Flashbang = function(p8, p9, u10) -- Line: 74
        -- upvalues: hideAsDebris (copy), ReplicatedStorage (copy), CreateGrenadeBurst (copy)
        hideAsDebris(u10);
        local Flashbang = ReplicatedStorage.Assets.GrenadeParticles:FindFirstChild("Flashbang");

        if Flashbang and Flashbang:IsA("BasePart") then
            CreateGrenadeBurst(Flashbang, p9, nil);
        end;

        task.delay(3, function() -- Line: 60
            -- upvalues: u10 (copy)
            if u10.Parent then
                u10:Destroy();
            end;
        end);
    end,

    ["HE Grenade"] = function(p11, p12, u13) -- Line: 82
        -- upvalues: hideAsDebris (copy), CreateGrenadeBurst (copy), ReplicatedStorage (copy)
        hideAsDebris(u13);
        CreateGrenadeBurst(ReplicatedStorage.Assets.GrenadeParticles["HE Grenade"], p12, "HE Grenade");
        task.delay(3, function() -- Line: 60
            -- upvalues: u13 (copy)
            if u13.Parent then
                u13:Destroy();
            end;
        end);
    end
};

local function createRaycastParams(p15: userdata, p16: string?) -- Line: 92
    -- upvalues: Debris (copy), CharacterResolver (copy)
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    local v17 = { p15, Debris };
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        table.insert(v17, LocalCharacter);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v17;
    RaycastParams_new_ret.RespectCanCollide = false;
    RaycastParams_new_ret.IgnoreWater = true;

    if p16 then
        RaycastParams_new_ret.CollisionGroup = p16;
    end;

    return RaycastParams_new_ret;
end;

local function startClientPrediction(u18: table) -- Line: 111
    -- upvalues: RunServiceController (copy), GrenadeSimulator (copy)
    local u19 = nil;
    u19 = RunServiceController.BindToRenderStep(`Observers.Game.Grenade.{u18.id}.Predict`, function(p20) -- Line: 113
        -- upvalues: u18 (copy), u19 (ref), GrenadeSimulator (ref)
        if u18.isResolved then
            u19:Disconnect();

            return;
        end;

        if not u18.model.Parent then
            u19:Disconnect();
            u18.isResolved = true;

            return;
        end;

        u18.state = GrenadeSimulator.simulate(u18.state, u18.config, u18.raycastParams, p20).state;
        local math_min_ret = math.min(1, p20 * 20);
        u18.visualPosition = u18.visualPosition:Lerp(u18.state.position, math_min_ret);
        local Magnitude = u18.state.velocity.Magnitude;

        if Magnitude < 2 then
            u18.angularVelocity = u18.angularVelocity * math.max(0, 1 - p20 * 8);
        elseif Magnitude < 5 then
            u18.angularVelocity = u18.angularVelocity * math.max(0, 1 - p20 * 3);
        end;

        if u18.angularVelocity.Magnitude > 0.01 then
            local angularVelocity = u18.angularVelocity;
            local CFrame_fromAxisAngle_ret = CFrame.fromAxisAngle(angularVelocity.Unit, angularVelocity.Magnitude * p20);
            u18.visualRotation = u18.visualRotation * CFrame_fromAxisAngle_ret;
        end;

        if u18.model.PrimaryPart then
            u18.model:PivotTo(CFrame.new(u18.visualPosition) * u18.visualRotation);
        end;
    end);
    u18.janitor:Add(u19, "Disconnect");
end;

local function reconcileState(p21: table, p22: vector, p23: vector) -- Line: 153
    local Magnitude = (p21.state.position - p22).Magnitude;

    if Magnitude <= 8 then
        if Magnitude > 2 then
            p21.state.position = p21.state.position:Lerp(p22, 0.08);
            p21.state.velocity = p21.state.velocity:Lerp(p23, 0.08);
        end;

        return;
    end;

    p21.state.position = p22;
    p21.state.velocity = p23;
    p21.visualPosition = p22;
end;

Remotes.Projectile.Spawn.Listen(function(u24) -- Line: 170
    -- upvalues: ReplicatedStorage (copy), Debris (copy), Janitor (copy), createRaycastParams (copy), u1 (copy), RunServiceController (copy), GrenadeSimulator (copy)
    local Id = u24.Id;
    local State = u24.State;
    local Physics = u24.Physics;
    task.defer(function() -- Line: 176
        -- upvalues: ReplicatedStorage (ref), u24 (copy), Id (copy), State (copy), Debris (ref), Janitor (ref), Physics (copy), createRaycastParams (ref), u1 (ref), RunServiceController (ref), GrenadeSimulator (ref)
        local v25 = ReplicatedStorage.Assets.Weapons:FindFirstChild(u24.Weapon);

        if v25 then
            v25 = v25:FindFirstChild("Character");
        end;

        if not v25 then
            warn("[Client Grenade] Base model not found for:", u24.Weapon);

            return;
        end;

        local v26 = v25:Clone();
        v26.Name = Id;
        v26:PivotTo(CFrame.new(State.Position));
        v26:SetAttribute("GrenadeName", u24.Weapon);
        v26:AddTag("Grenade");
        v26.Parent = Debris;

        for _, descendant in v26:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
            end;
        end;

        local v27 = Janitor.new();
        v27:Add(v26, "Destroy");
        local v28 = {
            angularVelocity = Vector3.new(0, 0, 0),
            simulationTime = 0,
            bounceCount = 0,
            isGrounded = false,
            isAtRest = false,
            hasTouched = false,
            accumulatedTime = 0,
            position = State.Position,
            velocity = State.Velocity,
            timestamp = State.StartTime or workspace:GetServerTimeNow(),
            isJumpThrow = State.IsJumpThrow or false
        };
        local v29 = u24.Weapon == "Molotov" and true or u24.Weapon == "Incendiary Grenade";
        local v30 = {
            rangeScale = 1,
            isNearThrow = false,
            radius = Physics.Radius,
            restitution = Physics.Restitution,
            maxBounces = Physics.MaxBounces
        };
        local v31;

        if Physics.FuseTime > 0 then
            v31 = Physics.FuseTime;
        else
            v31 = nil;
        end;

        v30.fuseTime = v31;
        v30.minimumFuseTime = v29 and 0.1 or nil;
        v30.explodeOnFloorImpact = v29 and true or nil;
        local Velocity = State.Velocity;
        local v32;

        if Velocity.Magnitude > 1 then
            local v33 = Velocity:Cross(Vector3.new(0, 1, 0));
            v32 = (v33.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v33.Unit) * Velocity.Magnitude * 0.5;
        else
            v32 = Vector3.new(0, 0, 0);
        end;

        local u34 = {
            isResolved = false,
            id = Id,
            model = v26,
            state = v28,
            config = v30,
            raycastParams = createRaycastParams(v26, Physics.CollisionGroup),
            visualPosition = State.Position,
            visualRotation = CFrame.identity,
            angularVelocity = v32,
            janitor = v27
        };
        u1[Id] = u34;
        local u35 = nil;
        u35 = RunServiceController.BindToRenderStep(`Observers.Game.Grenade.{u34.id}.Predict`, function(p36) -- Line: 113
            -- upvalues: u34 (copy), u35 (ref), GrenadeSimulator (ref)
            if u34.isResolved then
                u35:Disconnect();

                return;
            end;

            if not u34.model.Parent then
                u35:Disconnect();
                u34.isResolved = true;

                return;
            end;

            u34.state = GrenadeSimulator.simulate(u34.state, u34.config, u34.raycastParams, p36).state;
            local math_min_ret = math.min(1, p36 * 20);
            u34.visualPosition = u34.visualPosition:Lerp(u34.state.position, math_min_ret);
            local Magnitude = u34.state.velocity.Magnitude;

            if Magnitude < 2 then
                u34.angularVelocity = u34.angularVelocity * math.max(0, 1 - p36 * 8);
            elseif Magnitude < 5 then
                u34.angularVelocity = u34.angularVelocity * math.max(0, 1 - p36 * 3);
            end;

            if u34.angularVelocity.Magnitude > 0.01 then
                local angularVelocity = u34.angularVelocity;
                local CFrame_fromAxisAngle_ret = CFrame.fromAxisAngle(angularVelocity.Unit, angularVelocity.Magnitude * p36);
                u34.visualRotation = u34.visualRotation * CFrame_fromAxisAngle_ret;
            end;

            if u34.model.PrimaryPart then
                u34.model:PivotTo(CFrame.new(u34.visualPosition) * u34.visualRotation);
            end;
        end);
        u34.janitor:Add(u35, "Disconnect");
    end);
end);
Remotes.Projectile.Bounce.Listen(function(p37) -- Line: 257
    -- upvalues: u1 (copy), reconcileState (copy)
    local v38 = u1[p37.Id];

    if not v38 then
        return;
    end;

    reconcileState(v38, p37.Position, p37.Velocity);
    v38.state.bounceCount = p37.BounceIndex;
    v38.state.hasTouched = true;
    local Velocity = p37.Velocity;
    local v39 = Velocity - v38.state.velocity;

    if v39.Magnitude > 1 then
        local v40 = v39:Cross(Velocity);
        local v41;

        if v40.Magnitude > 0.1 then
            v41 = v40.Unit;
        else
            local v42 = Velocity:Cross(Vector3.new(0, 1, 0));
            v41 = v42.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v42.Unit;
        end;

        v38.angularVelocity = v38.angularVelocity + v41 * v39.Magnitude * 0.5;
    end;
end);
Remotes.Projectile.Resolve.Listen(function(p43) -- Line: 284
    -- upvalues: u1 (copy)
    local v44 = u1[p43.Id];

    if not v44 then
        return;
    end;

    v44.state.position = p43.Position;
    v44.state.isAtRest = true;
    v44.isResolved = true;
    v44.angularVelocity = Vector3.new(0, 0, 0);

    if v44.model.PrimaryPart then
        v44.model:PivotTo(CFrame.new(p43.Position) * v44.visualRotation);
    end;

    v44.model:SetAttribute("SimulationFinished", true);
    u1[p43.Id] = nil;
end);

return Observers.observeTag("Grenade", function(u45: userdata) -- Line: 308
    -- upvalues: u14 (copy), Janitor (copy), u1 (copy)
    local Attribute = u45:GetAttribute("GrenadeName");

    if Attribute then
        local u46 = u14[Attribute];
        local u47 = Janitor.new();
        u47:Add(u45:GetAttributeChangedSignal("SimulationFinished"):Connect(function() -- Line: 317
            -- upvalues: u45 (copy), u46 (copy), u47 (copy)
            local PrimaryPart = u45.PrimaryPart;

            if not (PrimaryPart and u45:GetAttribute("SimulationFinished")) then
                return;
            end;

            if u46 then
                u46(u47, PrimaryPart.Position, u45);

                return;
            end;

            for _, descendant in u45:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Transparency = 1;
                    descendant.CanCollide = false;
                end;
            end;

            local u48 = u45;
            task.delay(0.5, function() -- Line: 60
                -- upvalues: u48 (copy)
                if u48.Parent then
                    u48:Destroy();
                end;
            end);
        end));

        return function() -- Line: 338
            -- upvalues: u1 (ref), u45 (copy), u47 (copy)
            local v49 = u1[u45.Name];

            if v49 then
                v49.isResolved = true;
                u1[u45.Name] = nil;
            end;

            u47:Destroy();
        end;
    end;
end);