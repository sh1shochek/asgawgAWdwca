-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GrenadeSimulator = require(ReplicatedStorage.Shared.GrenadeSimulator);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Debris = workspace:WaitForChild("Debris");
local u1 = {};

local function hideAsDebris(p2: userdata) -- Line: 49
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

local function destroyAfter(u3: userdata, p4: number) -- Line: 61
    task.delay(p4, function() -- Line: 62
        -- upvalues: u3 (copy)
        if u3.Parent then
            u3:Destroy();
        end;
    end);
end;

local function spawnImpactParticles(p5: any, p6: userdata, p7: vector, p8: string?) -- Line: 69
    -- upvalues: Debris (copy), Sound (copy)
    local v9 = p5:Add(p6:Clone());
    v9.CFrame = CFrame.new(p7);
    v9.Parent = Debris;
    v9.Anchored = true;

    if p8 then
        Sound.new(p8):playOneTime({
            Name = "Explode",
            Parent = v9
        });
    end;

    for _, descendant in ipairs(v9:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            task.delay(descendant:GetAttribute("EmitDelay") or 0, function() -- Line: 84
                -- upvalues: descendant (copy)
                descendant:Emit(descendant:GetAttribute("EmitCount") or 1);
            end);
        end;
    end;
end;

local u19 = {
    ["Decoy Grenade"] = function(p10, p11, u12) -- Line: 93
        -- upvalues: hideAsDebris (copy)
        hideAsDebris(u12);
        task.delay(0.5, function() -- Line: 62
            -- upvalues: u12 (copy)
            if u12.Parent then
                u12:Destroy();
            end;
        end);
    end,

    Flashbang = function(p13, p14, u15) -- Line: 98
        -- upvalues: hideAsDebris (copy), ReplicatedStorage (copy), spawnImpactParticles (copy)
        hideAsDebris(u15);
        local Flashbang = ReplicatedStorage.Assets.GrenadeParticles:FindFirstChild("Flashbang");

        if Flashbang then
            spawnImpactParticles(p13, Flashbang, p14, nil);
        end;

        task.delay(3, function() -- Line: 62
            -- upvalues: u15 (copy)
            if u15.Parent then
                u15:Destroy();
            end;
        end);
    end,

    ["HE Grenade"] = function(p16, p17, u18) -- Line: 106
        -- upvalues: hideAsDebris (copy), spawnImpactParticles (copy), ReplicatedStorage (copy)
        hideAsDebris(u18);
        spawnImpactParticles(p16, ReplicatedStorage.Assets.GrenadeParticles["HE Grenade"], p17, "HE Grenade");
        task.delay(3, function() -- Line: 62
            -- upvalues: u18 (copy)
            if u18.Parent then
                u18:Destroy();
            end;
        end);
    end
};

local function createRaycastParams(p20: userdata, p21: string?) -- Line: 116
    -- upvalues: Debris (copy), CharacterResolver (copy)
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    local v22 = { p20, Debris };
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        table.insert(v22, LocalCharacter);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v22;
    RaycastParams_new_ret.RespectCanCollide = false;
    RaycastParams_new_ret.IgnoreWater = true;

    if p21 then
        RaycastParams_new_ret.CollisionGroup = p21;
    end;

    return RaycastParams_new_ret;
end;

local function startClientPrediction(u23: table) -- Line: 135
    -- upvalues: RunServiceController (copy), GrenadeSimulator (copy)
    local u24 = nil;
    u24 = RunServiceController.BindToRenderStep(`Observers.Game.Grenade.{u23.id}.Predict`, function(p25) -- Line: 137
        -- upvalues: u23 (copy), u24 (ref), GrenadeSimulator (ref)
        if u23.isResolved then
            u24:Disconnect();

            return;
        end;

        if not u23.model.Parent then
            u24:Disconnect();
            u23.isResolved = true;

            return;
        end;

        u23.state = GrenadeSimulator.simulate(u23.state, u23.config, u23.raycastParams, p25).state;
        local math_min_ret = math.min(1, p25 * 20);
        u23.visualPosition = u23.visualPosition:Lerp(u23.state.position, math_min_ret);
        local Magnitude = u23.state.velocity.Magnitude;

        if Magnitude < 2 then
            u23.angularVelocity = u23.angularVelocity * math.max(0, 1 - p25 * 8);
        elseif Magnitude < 5 then
            u23.angularVelocity = u23.angularVelocity * math.max(0, 1 - p25 * 3);
        end;

        if u23.angularVelocity.Magnitude > 0.01 then
            local angularVelocity = u23.angularVelocity;
            local CFrame_fromAxisAngle_ret = CFrame.fromAxisAngle(angularVelocity.Unit, angularVelocity.Magnitude * p25);
            u23.visualRotation = u23.visualRotation * CFrame_fromAxisAngle_ret;
        end;

        if u23.model.PrimaryPart then
            u23.model:PivotTo(CFrame.new(u23.visualPosition) * u23.visualRotation);
        end;
    end);
    u23.janitor:Add(u24, "Disconnect");
end;

local function reconcileState(p26: table, p27: vector, p28: vector) -- Line: 177
    local Magnitude = (p26.state.position - p27).Magnitude;

    if Magnitude <= 8 then
        if Magnitude > 2 then
            p26.state.position = p26.state.position:Lerp(p27, 0.08);
            p26.state.velocity = p26.state.velocity:Lerp(p28, 0.08);
        end;

        return;
    end;

    p26.state.position = p27;
    p26.state.velocity = p28;
    p26.visualPosition = p27;
end;

Remotes.Projectile.Spawn.Listen(function(u29) -- Line: 194
    -- upvalues: ReplicatedStorage (copy), Debris (copy), Janitor (copy), createRaycastParams (copy), u1 (copy), RunServiceController (copy), GrenadeSimulator (copy)
    local Id = u29.Id;
    local State = u29.State;
    local Physics = u29.Physics;
    task.defer(function() -- Line: 200
        -- upvalues: ReplicatedStorage (ref), u29 (copy), Id (copy), State (copy), Debris (ref), Janitor (ref), Physics (copy), createRaycastParams (ref), u1 (ref), RunServiceController (ref), GrenadeSimulator (ref)
        local v30 = ReplicatedStorage.Assets.Weapons:FindFirstChild(u29.Weapon);

        if v30 then
            v30 = v30:FindFirstChild("Character");
        end;

        if not v30 then
            warn("[Client Grenade] Base model not found for:", u29.Weapon);

            return;
        end;

        local v31 = v30:Clone();
        v31.Name = Id;
        v31:PivotTo(CFrame.new(State.Position));
        v31:SetAttribute("GrenadeName", u29.Weapon);
        v31:AddTag("Grenade");
        v31.Parent = Debris;

        for _, descendant in v31:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
            end;
        end;

        local v32 = Janitor.new();
        v32:Add(v31, "Destroy");
        local v33 = {
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
        local v34 = u29.Weapon == "Molotov" and true or u29.Weapon == "Incendiary Grenade";
        local v35 = {
            rangeScale = 1,
            isNearThrow = false,
            radius = Physics.Radius,
            restitution = Physics.Restitution,
            maxBounces = Physics.MaxBounces
        };
        local v36;

        if Physics.FuseTime > 0 then
            v36 = Physics.FuseTime;
        else
            v36 = nil;
        end;

        v35.fuseTime = v36;
        v35.minimumFuseTime = v34 and 0.1 or nil;
        v35.explodeOnFloorImpact = v34 and true or nil;
        local Velocity = State.Velocity;
        local v37;

        if Velocity.Magnitude > 1 then
            local v38 = Velocity:Cross(Vector3.new(0, 1, 0));
            v37 = (v38.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v38.Unit) * Velocity.Magnitude * 0.5;
        else
            v37 = Vector3.new(0, 0, 0);
        end;

        local u39 = {
            isResolved = false,
            id = Id,
            model = v31,
            state = v33,
            config = v35,
            raycastParams = createRaycastParams(v31, Physics.CollisionGroup),
            visualPosition = State.Position,
            visualRotation = CFrame.identity,
            angularVelocity = v37,
            janitor = v32
        };
        u1[Id] = u39;
        local u40 = nil;
        u40 = RunServiceController.BindToRenderStep(`Observers.Game.Grenade.{u39.id}.Predict`, function(p41) -- Line: 137
            -- upvalues: u39 (copy), u40 (ref), GrenadeSimulator (ref)
            if u39.isResolved then
                u40:Disconnect();

                return;
            end;

            if not u39.model.Parent then
                u40:Disconnect();
                u39.isResolved = true;

                return;
            end;

            u39.state = GrenadeSimulator.simulate(u39.state, u39.config, u39.raycastParams, p41).state;
            local math_min_ret = math.min(1, p41 * 20);
            u39.visualPosition = u39.visualPosition:Lerp(u39.state.position, math_min_ret);
            local Magnitude = u39.state.velocity.Magnitude;

            if Magnitude < 2 then
                u39.angularVelocity = u39.angularVelocity * math.max(0, 1 - p41 * 8);
            elseif Magnitude < 5 then
                u39.angularVelocity = u39.angularVelocity * math.max(0, 1 - p41 * 3);
            end;

            if u39.angularVelocity.Magnitude > 0.01 then
                local angularVelocity = u39.angularVelocity;
                local CFrame_fromAxisAngle_ret = CFrame.fromAxisAngle(angularVelocity.Unit, angularVelocity.Magnitude * p41);
                u39.visualRotation = u39.visualRotation * CFrame_fromAxisAngle_ret;
            end;

            if u39.model.PrimaryPart then
                u39.model:PivotTo(CFrame.new(u39.visualPosition) * u39.visualRotation);
            end;
        end);
        u39.janitor:Add(u40, "Disconnect");
    end);
end);
Remotes.Projectile.Bounce.Listen(function(p42) -- Line: 281
    -- upvalues: u1 (copy), reconcileState (copy)
    local v43 = u1[p42.Id];

    if not v43 then
        return;
    end;

    reconcileState(v43, p42.Position, p42.Velocity);
    v43.state.bounceCount = p42.BounceIndex;
    v43.state.hasTouched = true;
    local Velocity = p42.Velocity;
    local v44 = Velocity - v43.state.velocity;

    if v44.Magnitude > 1 then
        local v45 = v44:Cross(Velocity);
        local v46;

        if v45.Magnitude > 0.1 then
            v46 = v45.Unit;
        else
            local v47 = Velocity:Cross(Vector3.new(0, 1, 0));
            v46 = v47.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v47.Unit;
        end;

        v43.angularVelocity = v43.angularVelocity + v46 * v44.Magnitude * 0.5;
    end;
end);
Remotes.Projectile.Resolve.Listen(function(p48) -- Line: 308
    -- upvalues: u1 (copy)
    local v49 = u1[p48.Id];

    if not v49 then
        return;
    end;

    v49.state.position = p48.Position;
    v49.state.isAtRest = true;
    v49.isResolved = true;
    v49.angularVelocity = Vector3.new(0, 0, 0);

    if v49.model.PrimaryPart then
        v49.model:PivotTo(CFrame.new(p48.Position) * v49.visualRotation);
    end;

    v49.model:SetAttribute("SimulationFinished", true);
    u1[p48.Id] = nil;
end);

return Observers.observeTag("Grenade", function(u50: userdata) -- Line: 332
    -- upvalues: u19 (copy), Janitor (copy), u1 (copy)
    local Attribute = u50:GetAttribute("GrenadeName");

    if Attribute then
        local u51 = u19[Attribute];
        local u52 = Janitor.new();
        u52:Add(u50:GetAttributeChangedSignal("SimulationFinished"):Connect(function() -- Line: 341
            -- upvalues: u50 (copy), u51 (copy), u52 (copy)
            local PrimaryPart = u50.PrimaryPart;

            if not (PrimaryPart and u50:GetAttribute("SimulationFinished")) then
                return;
            end;

            if u51 then
                u51(u52, PrimaryPart.Position, u50);

                return;
            end;

            for _, descendant in u50:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Transparency = 1;
                    descendant.CanCollide = false;
                end;
            end;

            local u53 = u50;
            task.delay(0.5, function() -- Line: 62
                -- upvalues: u53 (copy)
                if u53.Parent then
                    u53:Destroy();
                end;
            end);
        end));

        return function() -- Line: 362
            -- upvalues: u1 (ref), u50 (copy), u52 (copy)
            local v54 = u1[u50.Name];

            if v54 then
                v54.isResolved = true;
                u1[u50.Name] = nil;
            end;

            u52:Destroy();
        end;
    end;
end);