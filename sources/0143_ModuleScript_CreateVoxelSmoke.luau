-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Smoke = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GrenadeParticles"):WaitForChild("Smoke");
local u1 = {
    Terrorists = Color3.fromRGB(185, 170, 145),
    ["Counter-Terrorists"] = Color3.fromRGB(155, 170, 190)
};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = nil;

local function StopEmitterLoop() -- Line: 50
    -- upvalues: u6 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function StartEmitterLoop() -- Line: 57
    -- upvalues: u6 (ref), RunServiceController (copy), u5 (copy)
    if u6 then
        return;
    end;

    u6 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62
        -- upvalues: u5 (ref), u6 (ref)
        local v7 = tick();

        for i, v in pairs(u5) do
            if i.Parent and (v.isActive and not v.emissionStopped) then
                local v8, v9;

                if v.lifetimeExtended then
                    v8 = i;
                    v9 = v;
                else
                    v.lifetimeExtended = true;
                    v.activatedTime = v7;
                    v8 = i;
                    v9 = v;

                    for _, v2 in ipairs(v.emitters) do
                        if v2 and v2.Parent then
                            v2.Lifetime = NumberRange.new((1 / 0));
                        end;
                    end;
                end;

                local v10 = v7 - v9.activatedTime;

                if v10 >= 0.8 then
                    v9.emissionStopped = true;
                    u5[v8] = nil;
                elseif 0.1 + 0.30000000000000004 * (v10 / 0.8) <= v7 - v9.lastEmitTime then
                    v9.lastEmitTime = v7;

                    for _, v2 in ipairs(v9.emitters) do
                        if v2 and v2.Parent then
                            v2:Emit(1);
                        end;
                    end;
                end;
            else
                u5[i] = nil;
            end;
        end;

        if next(u5) == nil and u6 then
            u6:Disconnect();
            u6 = nil;
        end;
    end);
end;

local function SetVoxelEmitting(p11: table, p12: boolean) -- Line: 112
    -- upvalues: u5 (copy), u6 (ref), RunServiceController (copy)
    local voxel = p11.voxel;

    if not p12 then
        u5[voxel] = nil;

        if next(u5) == nil and u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        return;
    end;

    u5[voxel] = p11;

    if u6 then
        return;
    end;

    u6 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62
        -- upvalues: u5 (ref), u6 (ref)
        local v13 = tick();

        for i, v in pairs(u5) do
            if i.Parent and (v.isActive and not v.emissionStopped) then
                local v14, v15;

                if v.lifetimeExtended then
                    v14 = i;
                    v15 = v;
                else
                    v.lifetimeExtended = true;
                    v.activatedTime = v13;
                    v14 = i;
                    v15 = v;

                    for _, v2 in ipairs(v.emitters) do
                        if v2 and v2.Parent then
                            v2.Lifetime = NumberRange.new((1 / 0));
                        end;
                    end;
                end;

                local v16 = v13 - v15.activatedTime;

                if v16 >= 0.8 then
                    v15.emissionStopped = true;
                    u5[v14] = nil;
                elseif 0.1 + 0.30000000000000004 * (v16 / 0.8) <= v13 - v15.lastEmitTime then
                    v15.lastEmitTime = v13;

                    for _, v2 in ipairs(v15.emitters) do
                        if v2 and v2.Parent then
                            v2:Emit(1);
                        end;
                    end;
                end;
            else
                u5[i] = nil;
            end;
        end;

        if next(u5) == nil and u6 then
            u6:Disconnect();
            u6 = nil;
        end;
    end);
end;

local function RayIntersectsAABB(p17: vector, p18: vector, p19: vector, p20: vector, p21: number) -- Line: 125
    local v22 = 0;
    local v23;

    if math.abs(p18.X) < 0.0001 then
        if p17.X < p19.X or p17.X > p20.X then
            return false;
        end;

        v23 = p21;
    else
        local v24 = 1 / p18.X;
        local v25 = (p19.X - p17.X) * v24;
        local v26 = (p20.X - p17.X) * v24;

        if v26 >= v25 then
            local v27 = v25;
            v25 = v26;
            v26 = v27;
        end;

        v22 = math.max(v22, v26);
        v23 = math.min(p21, v25);

        if v23 < v22 then
            return false;
        end;
    end;

    if math.abs(p18.Y) < 0.0001 then
        if p17.Y < p19.Y or p17.Y > p20.Y then
            return false;
        end;
    else
        local v28 = 1 / p18.Y;
        local v29 = (p19.Y - p17.Y) * v28;
        local v30 = (p20.Y - p17.Y) * v28;

        if v30 >= v29 then
            local v31 = v29;
            v29 = v30;
            v30 = v31;
        end;

        v22 = math.max(v22, v30);
        v23 = math.min(v23, v29);

        if v23 < v22 then
            return false;
        end;
    end;

    if math.abs(p18.Z) < 0.0001 then
        if p17.Z < p19.Z or p17.Z > p20.Z then
            return false;
        end;
    else
        local v32 = 1 / p18.Z;
        local v33 = (p19.Z - p17.Z) * v32;
        local v34 = (p20.Z - p17.Z) * v32;

        if v34 >= v33 then
            local v35 = v33;
            v33 = v34;
            v34 = v35;
        end;

        v22 = math.max(v22, v34);

        if math.min(v23, v33) < v22 then
            return false;
        end;
    end;

    return v22 <= p21;
end;

local function ConfigureEmitter(p36: userdata, p37: number, p38) -- Line: 196
    local v39 = {};

    for _, v in ipairs(p36.Size.Keypoints) do
        table.insert(v39, NumberSequenceKeypoint.new(v.Time, v.Value * p37, v.Envelope * p37));
    end;

    p36.Size = NumberSequence.new(v39);

    if p38 then
        p36.Color = ColorSequence.new(p38);
    end;

    p36.Enabled = false;
end;

local function CreateVoxel(p40: vector, p41: number, p42: userdata, p43) -- Line: 212
    -- upvalues: Smoke (copy), ConfigureEmitter (copy), u3 (copy)
    local v44 = Smoke:Clone();
    v44.Name = "SmokeVoxel";
    v44.Size = Vector3.new(p41, p41, p41);
    v44.Position = p40;
    v44.Anchored = true;
    v44.CanCollide = false;
    v44.CanQuery = false;
    v44.CanTouch = false;
    v44.CastShadow = false;
    v44.Parent = p42;
    local v45 = p41 / 4;
    local v46 = {};

    for _, descendant in ipairs(v44:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            ConfigureEmitter(descendant, v45, p43);
            table.insert(v46, descendant);
        end;
    end;

    for _, child in ipairs(v44:GetChildren()) do
        if child:IsA("BillboardGui") then
            child:Destroy();
        end;
    end;

    local v47 = p41 / 2;
    local Vector3_new_ret = Vector3.new(v47, v47, v47);
    u3[v44] = {
        isActive = false,
        lastEmitTime = 0,
        lifetimeExtended = false,
        activatedTime = 0,
        emissionStopped = false,
        voxel = v44,
        emitters = v46,
        scaleFactor = v45,
        teamColor = p43,
        minimum = p40 - Vector3_new_ret,
        maximum = p40 + Vector3_new_ret
    };

    return v44;
end;

local function DestroyVoxels(p48: table) -- Line: 260
    -- upvalues: u4 (copy), u5 (copy), u3 (copy)
    for _, v in ipairs(p48) do
        if v:IsA("BasePart") then
            u4[v] = nil;
            u5[v] = nil;
            u3[v] = nil;
            v:Destroy();
        end;
    end;
end;

local function DeploySmoke(p49: userdata, p50: number) -- Line: 274
    -- upvalues: u3 (copy), u4 (copy), u5 (copy), u6 (ref), RunServiceController (copy)
    debug.profilebegin("VFX.VoxelSmoke.DeploySmoke");
    local v51 = Vector3.new(0, 0, 0);
    local v52 = {};

    for _, child in ipairs(p49:GetChildren()) do
        if child:IsA("BasePart") then
            v51 = v51 + child.Position;
            table.insert(v52, child);
        end;
    end;

    if #v52 == 0 then
        debug.profileend();

        return;
    end;

    local v53 = v51 / #v52;
    local v54 = 0;

    for _, v in ipairs(v52) do
        local Magnitude = (v.Position - v53).Magnitude;

        if v54 < Magnitude then
            v54 = Magnitude;
        end;
    end;

    local v55 = v54 == 0 and 1 or v54;

    for _, v in ipairs(v52) do
        task.delay((v.Position - v53).Magnitude / v55 * p50, function() -- Line: 308
            -- upvalues: v (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), RunServiceController (ref)
            if not v.Parent then
                return;
            end;

            local v56 = u3[v];

            if v56 then
                v56.isActive = true;
                u4[v] = v56;
                u5[v56.voxel] = v56;

                if u6 then
                    return;
                end;

                u6 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62
                    -- upvalues: u5 (ref), u6 (ref)
                    local v57 = tick();

                    for i, v2 in pairs(u5) do
                        if i.Parent and (v2.isActive and not v2.emissionStopped) then
                            local v58, v59;

                            if v2.lifetimeExtended then
                                v58 = i;
                                v59 = v2;
                            else
                                v2.lifetimeExtended = true;
                                v2.activatedTime = v57;
                                v58 = i;
                                v59 = v2;

                                for _, v3 in ipairs(v2.emitters) do
                                    if v3 and v3.Parent then
                                        v3.Lifetime = NumberRange.new((1 / 0));
                                    end;
                                end;
                            end;

                            local v60 = v57 - v59.activatedTime;

                            if v60 >= 0.8 then
                                v59.emissionStopped = true;
                                u5[v58] = nil;
                            elseif 0.1 + 0.30000000000000004 * (v60 / 0.8) <= v57 - v59.lastEmitTime then
                                v59.lastEmitTime = v57;

                                for _, v3 in ipairs(v59.emitters) do
                                    if v3 and v3.Parent then
                                        v3:Emit(1);
                                    end;
                                end;
                            end;
                        else
                            u5[i] = nil;
                        end;
                    end;

                    if next(u5) == nil and u6 then
                        u6:Disconnect();
                        u6 = nil;
                    end;
                end);
            end;
        end);
    end;

    debug.profileend();
end;

local function FadeOutSmoke(u61: userdata) -- Line: 324
    -- upvalues: u3 (copy), u4 (copy), u5 (copy), u6 (ref), DestroyVoxels (copy)
    debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke");
    local Children = u61:GetChildren();

    for _, v in ipairs(Children) do
        if v:IsA("BasePart") then
            local v62 = u3[v];

            if v62 then
                v62.isActive = false;
                u4[v] = nil;
                u5[v62.voxel] = nil;

                if next(u5) == nil and u6 then
                    u6:Disconnect();
                    u6 = nil;
                end;

                for _, v2 in ipairs(v62.emitters) do
                    if v2 and v2.Parent then
                        v2.Enabled = false;
                    end;
                end;
            end;
        end;
    end;

    task.delay(6, function() -- Line: 344
        -- upvalues: DestroyVoxels (ref), Children (copy), u5 (ref), u6 (ref), u61 (copy)
        debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke.DelayedCleanup");
        DestroyVoxels(Children);

        if next(u5) == nil and u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        if u61.Parent then
            u61:Destroy();
        end;

        debug.profileend();
    end);
    debug.profileend();
end;

return {
    Create = function(u63: table) -- Line: 365, Name: Create
        -- upvalues: u2 (copy), u1 (copy), CreateVoxel (copy), Workspace (copy), DeploySmoke (copy), FadeOutSmoke (copy)
        debug.profilebegin("VFX.VoxelSmoke.Create");
        local Folder = Instance.new("Folder");
        Folder.Name = "VoxelSmoke_" .. u63.SmokeId;
        u2[u63.SmokeId] = Folder;
        local v64 = u63.Team and u1[u63.Team];
        debug.profilebegin("VFX.VoxelSmoke.Create.CreateVoxels");

        for _, v in ipairs(u63.Voxels) do
            CreateVoxel(v.Position, v.Size, Folder, v64);
        end;

        debug.profileend();
        Folder.Parent = Workspace:WaitForChild("Debris");
        DeploySmoke(Folder, u63.DeployTime);
        task.delay(u63.Duration, function() -- Line: 391
            -- upvalues: u2 (ref), u63 (copy), FadeOutSmoke (ref), Folder (copy)
            if u2[u63.SmokeId] then
                FadeOutSmoke(Folder);
                u2[u63.SmokeId] = nil;
            end;
        end);
        debug.profileend();
    end,

    Destroy = function(p65: string) -- Line: 400, Name: Destroy
        -- upvalues: u2 (copy), FadeOutSmoke (copy)
        debug.profilebegin("VFX.VoxelSmoke.Destroy");
        local v66 = u2[p65];

        if v66 then
            FadeOutSmoke(v66);
            u2[p65] = nil;
        end;

        debug.profileend();
    end,

    DestroyAll = function() -- Line: 410, Name: DestroyAll
        -- upvalues: u2 (copy), DestroyVoxels (copy), u5 (copy), u6 (ref)
        debug.profilebegin("VFX.VoxelSmoke.DestroyAll");

        for i, v in pairs(u2) do
            DestroyVoxels(v:GetChildren());
            v:Destroy();
            u2[i] = nil;
        end;

        if next(u5) == nil and u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        debug.profileend();
    end,

    Disrupt = function(p67: vector, p68: number, p69: number) -- Line: 425, Name: Disrupt
        -- upvalues: u2 (copy), u3 (copy), u4 (copy), u5 (copy), u6 (ref), Smoke (copy), ConfigureEmitter (copy), RunServiceController (copy)
        debug.profilebegin("VFX.VoxelSmoke.Disrupt");

        for _, v in pairs(u2) do
            for _, child in ipairs(v:GetChildren()) do
                if child:IsA("BasePart") and p68 >= (child.Position - p67).Magnitude then
                    local u70 = u3[child];

                    if u70 and u70.isActive then
                        u70.isActive = false;
                        u4[child] = nil;
                        u5[u70.voxel] = nil;

                        if next(u5) == nil and u6 then
                            u6:Disconnect();
                            u6 = nil;
                        end;

                        local scaleFactor = u70.scaleFactor;
                        local u71 = child;

                        for _, v2 in ipairs(u70.emitters) do
                            if v2 and v2.Parent then
                                v2:Destroy();
                            end;
                        end;

                        u70.emitters = {};
                        local teamColor = u70.teamColor;
                        task.delay(p69, function() -- Line: 455
                            -- upvalues: u3 (ref), u71 (copy), Smoke (ref), ConfigureEmitter (ref), scaleFactor (copy), teamColor (copy), u70 (copy), u4 (ref), u5 (ref), u6 (ref), RunServiceController (ref)
                            debug.profilebegin("VFX.VoxelSmoke.Disrupt.RestoreEmitters");

                            if not (u3[u71] and u71.Parent) then
                                debug.profileend();

                                return;
                            end;

                            local v72 = {};

                            for _, descendant in ipairs(Smoke:GetDescendants()) do
                                if descendant:IsA("ParticleEmitter") then
                                    local v73 = descendant:Clone();
                                    ConfigureEmitter(v73, scaleFactor, teamColor);
                                    v73.Parent = u71;
                                    table.insert(v72, v73);
                                end;
                            end;

                            u70.emitters = v72;
                            u70.lastEmitTime = 0;
                            u70.isActive = true;
                            u70.lifetimeExtended = false;
                            u70.activatedTime = 0;
                            u70.emissionStopped = false;
                            u4[u71] = u70;
                            local v74 = u70;
                            u5[v74.voxel] = v74;

                            if not u6 then
                                u6 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62
                                    -- upvalues: u5 (ref), u6 (ref)
                                    local v75 = tick();

                                    for i, v2 in pairs(u5) do
                                        if i.Parent and (v2.isActive and not v2.emissionStopped) then
                                            local v76, v77;

                                            if v2.lifetimeExtended then
                                                v76 = i;
                                                v77 = v2;
                                            else
                                                v2.lifetimeExtended = true;
                                                v2.activatedTime = v75;
                                                v76 = i;
                                                v77 = v2;

                                                for _, v3 in ipairs(v2.emitters) do
                                                    if v3 and v3.Parent then
                                                        v3.Lifetime = NumberRange.new((1 / 0));
                                                    end;
                                                end;
                                            end;

                                            local v78 = v75 - v77.activatedTime;

                                            if v78 >= 0.8 then
                                                v77.emissionStopped = true;
                                                u5[v76] = nil;
                                            elseif 0.1 + 0.30000000000000004 * (v78 / 0.8) <= v75 - v77.lastEmitTime then
                                                v77.lastEmitTime = v75;

                                                for _, v3 in ipairs(v77.emitters) do
                                                    if v3 and v3.Parent then
                                                        v3:Emit(1);
                                                    end;
                                                end;
                                            end;
                                        else
                                            u5[i] = nil;
                                        end;
                                    end;

                                    if next(u5) == nil and u6 then
                                        u6:Disconnect();
                                        u6 = nil;
                                    end;
                                end);
                            end;

                            debug.profileend();
                        end);
                    end;
                end;
            end;
        end;

        debug.profileend();
    end,

    DoesRayIntersectActiveSmoke = function(p79: vector, p80: vector, p81: number) -- Line: 487, Name: DoesRayIntersectActiveSmoke
        -- upvalues: u4 (copy), RayIntersectsAABB (copy)
        for _, v in pairs(u4) do
            if RayIntersectsAABB(p79, p80, v.minimum, v.maximum, p81) then
                return true;
            end;
        end;

        return false;
    end
};