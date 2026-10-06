-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
game:GetService("Workspace");
local GrenadeParticles = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GrenadeParticles");
local InnerFire = GrenadeParticles:WaitForChild("InnerFire");
local OuterFire = GrenadeParticles:WaitForChild("OuterFire");
local u1 = {};

local function FlatDistance(p2: vector, p3: vector) -- Line: 25
    return (Vector3.new(p2.X, 0, p2.Z) - Vector3.new(p3.X, 0, p3.Z)).Magnitude;
end;

local function GetCenter(p4: table) -- Line: 30
    local v5 = Vector3.new(0, 0, 0);

    for _, v in ipairs(p4) do
        v5 = v5 + v.Position;
    end;

    if #p4 > 0 then
        v5 = v5 / #p4;
    end;

    return v5;
end;

local function DisableEmitters(p6: userdata) -- Line: 42
    for _, child in ipairs(p6:GetChildren()) do
        if child:IsA("BasePart") then
            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;
    end;
end;

local function GetSurfaceCFrame(p7: vector, p8: vector) -- Line: 56
    local Unit = p8.Unit;

    if math.abs(Unit.Y) > 0.99 then
        return CFrame.new(p7);
    end;

    local v9;

    if math.abs(Unit.X) >= math.abs(Unit.Z) then
        v9 = Vector3.new(Unit.X, Unit.Y, 0).Unit;
    else
        v9 = Vector3.new(0, Unit.Y, Unit.Z).Unit;
    end;

    local Vector3_new_ret = Vector3.new(v9.X, 0, v9.Z);

    if Vector3_new_ret.Magnitude < 0.01 then
        return CFrame.new(p7);
    end;

    local Unit2 = Vector3_new_ret.Unit;
    local Vector3_new_ret2 = Vector3.new(Unit2.Z, 0, -Unit2.X);
    local Unit3 = Vector3_new_ret2:Cross(v9).Unit;

    return CFrame.fromMatrix(p7, Vector3_new_ret2, v9, -Unit3);
end;

local function CreateVoxel(p10: vector, p11: number, p12: number, p13: vector, p14: boolean, p15: userdata) -- Line: 92
    -- upvalues: InnerFire (copy), OuterFire (copy), GetSurfaceCFrame (copy)
    local v16 = (p14 and InnerFire or OuterFire):Clone();
    v16.Name = p14 and "InnerFireVoxel" or "OuterFireVoxel";
    v16.Size = Vector3.new(p11, 0.2, p12);
    v16.CFrame = GetSurfaceCFrame(p10, p13);
    v16.Anchored = true;
    v16.CanCollide = false;
    v16.CanQuery = false;
    v16.CanTouch = false;
    v16.CastShadow = false;
    v16.Parent = p15;

    for _, descendant in ipairs(v16:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        end;
    end;

    return v16;
end;

local u17 = {};

function u17.Create(u18: table) -- Line: 127
    -- upvalues: u1 (copy), CreateVoxel (copy), TweenService (copy), u17 (copy)
    debug.profilebegin("VFX.VoxelFire.Create");
    local Folder = Instance.new("Folder");
    Folder.Name = "VoxelFire_" .. u18.FireId;
    u1[u18.FireId] = Folder;
    debug.profilebegin("VFX.VoxelFire.Create.CalculateCenter");
    local Voxels = u18.Voxels;
    local v19 = Vector3.new(0, 0, 0);

    for _, v in ipairs(Voxels) do
        v19 = v19 + v.Position;
    end;

    if #Voxels > 0 then
        v19 = v19 / #Voxels;
    end;

    debug.profileend();
    local CFrame_identity = CFrame.identity;
    debug.profilebegin("VFX.VoxelFire.Create.CreateVoxels");
    local v20 = (1 / 0);
    local v21 = nil;
    local v22 = Vector3.new(0, 0, 0);

    for _, v in ipairs(u18.Voxels) do
        local Position = v.Position;
        local v23 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(v19.X, 0, v19.Z)).Magnitude <= 4;
        local v24 = CreateVoxel(v.Position, v.SizeX, v.SizeZ, v.Normal, v23, Folder);
        local Position2 = v.Position;
        local Position3 = u18.Position;
        local Magnitude = (Vector3.new(Position2.X, 0, Position2.Z) - Vector3.new(Position3.X, 0, Position3.Z)).Magnitude;

        if Magnitude < v20 then
            v22 = v24.Size;
            CFrame_identity = v24.CFrame;
            v21 = v24;
            v20 = Magnitude;
        end;
    end;

    Folder.Parent = workspace:WaitForChild("Debris");
    debug.profileend();

    if v21 then
        debug.profilebegin("VFX.VoxelFire.Create.LandingBurstTween");
        local Vector3_new_ret = Vector3.new(v22.X, 10, v22.Z);
        local v25 = CFrame_identity + CFrame_identity.UpVector * ((Vector3_new_ret.Y - v22.Y) / 2);
        v21.Size = Vector3_new_ret;
        v21.CFrame = v25;
        TweenService:Create(v21, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = v22,
            CFrame = CFrame_identity
        }):Play();
        debug.profileend();
    end;

    task.delay(u18.Duration, function() -- Line: 184
        -- upvalues: u1 (ref), u18 (copy), u17 (ref)
        if u1[u18.FireId] then
            u17.Destroy(u18.FireId);
        end;
    end);
    debug.profileend();
end;

function u17.Destroy(p26: string) -- Line: 192
    -- upvalues: u1 (copy), DisableEmitters (copy)
    debug.profilebegin("VFX.VoxelFire.Destroy");
    local u27 = u1[p26];

    if u27 then
        DisableEmitters(u27);
        task.delay(2, function() -- Line: 199
            -- upvalues: u27 (copy)
            if u27.Parent then
                u27:Destroy();
            end;
        end);
        u1[p26] = nil;
    end;

    debug.profileend();
end;

function u17.Update(u28: table) -- Line: 210
    -- upvalues: u1 (copy), DisableEmitters (copy), CreateVoxel (copy)
    debug.profilebegin("VFX.VoxelFire.Update");
    local u29 = u1[u28.FireId];

    if not u29 then
        debug.profileend();

        return;
    end;

    DisableEmitters(u29);
    task.delay(0.3, function() -- Line: 224
        -- upvalues: u29 (copy), u28 (copy), CreateVoxel (ref)
        debug.profilebegin("VFX.VoxelFire.Update.DelayedRebuild");

        if not u29.Parent then
            debug.profileend();

            return;
        end;

        for _, child in ipairs(u29:GetChildren()) do
            if child:IsA("BasePart") then
                child:Destroy();
            end;
        end;

        if #u28.Voxels == 0 then
            debug.profileend();

            return;
        end;

        local Voxels = u28.Voxels;
        local v30 = Vector3.new(0, 0, 0);

        for _, v in ipairs(Voxels) do
            v30 = v30 + v.Position;
        end;

        if #Voxels > 0 then
            v30 = v30 / #Voxels;
        end;

        local Parent = u29.Parent;
        u29.Parent = nil;

        for _, v in ipairs(u28.Voxels) do
            local Position = v.Position;
            local v31 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(v30.X, 0, v30.Z)).Magnitude <= 4;
            CreateVoxel(v.Position, v.SizeX, v.SizeZ, v.Normal, v31, u29);
        end;

        u29.Parent = Parent;
        debug.profileend();
    end);
    debug.profileend();
end;

function u17.DestroyAll() -- Line: 258
    -- upvalues: u1 (copy)
    debug.profilebegin("VFX.VoxelFire.DestroyAll");

    for i, v in pairs(u1) do
        if v.Parent then
            v:Destroy();
        end;

        u1[i] = nil;
    end;

    debug.profileend();
end;

return u17;