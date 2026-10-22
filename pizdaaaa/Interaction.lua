-- ReplicatedStorage.Shared.Simulation.Interaction
-- Script path: ReplicatedStorage.Shared.Simulation.Interaction
-- Decompile time: 9.18 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local buffer_create_ret = buffer.create(4);
local u2 = RunService:IsServer();
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.IgnoreWater = true;
local u3 = nil;

if u2 then
    u3 = workspace.DroppedWeapons;
else
    local Debris = workspace:WaitForChild("Debris");

    if Debris then
        u3 = Debris:WaitForChild("DroppedWeapons");
    end;
end;

local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;

local function GetDroppedWeaponModel(p10) -- Line: 46
    -- upvalues: u3 (ref)
    while p10 and p10.Parent ~= u3 do
        p10 = p10.Parent;
    end;

    return p10;
end;

function u1.AimedWeapon(p11, p12: number, p13: number?) -- Line: 66
    -- upvalues: u5 (ref), u4 (ref), u7 (ref)
    local math_min_ret = math.min(p12, u5.CFG.PickupFallbackRange);
    local Position = p11.Position;
    local LookVector = p11.LookVector;
    local v14 = (1 / 0);
    local v15 = nil;

    for i, v in u4.GetAllCategoryEntities("DroppedWeapon") do
        if vector.magnitude(v.Position - Position) <= math_min_ret + u5.CFG.PickupRewindSlack then
            local _, _, _, v16 = u4.GetStateAtTime(v, p13);
            local v17 = v16 or v;
            local vector_magnitude_ret = vector.magnitude(v17.Position - Position);

            if vector_magnitude_ret < v14 and u7.RayHitsWeapon(v, Position, LookVector, math_min_ret, v17, u5.CFG.PickupPad) then
                v15 = i;
                v14 = vector_magnitude_ret;
            end;
        end;
    end;

    return v15;
end;

function u1.Init(p18) -- Line: 102
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u2 (copy), u9 (ref)
    u4 = p18:GetModule("Entities");
    u5 = p18:GetModule("Config");
    u6 = p18:GetModule("GameConfiguration");
    u7 = p18:GetModule("DroppedPhysics");
    u8 = p18:GetModule("CollisionModule");

    if u2 then
        u9 = p18:GetModule("Map");
    end;
end;

function u1.Start(p19) -- Line: 115
end;

function u1.StopDefusing(p20) -- Line: 120
    -- upvalues: u5 (ref)
    if not p20.Defusing then
        return;
    end;

    if p20.DefuseTimer > (p20.HasDefuseKit and u5.CFG.DefuseTime / 2 or u5.CFG.DefuseTime) - u5.CFG.DefuseLockIn then
        return;
    end;

    p20.Defusing = false;
end;

function u1.PressE(p21: any, p22: boolean, p23: number, p24: number) -- Line: 136
    -- upvalues: u1 (copy), u2 (copy), u3 (ref), RaycastParams_new_ret (copy), u5 (ref), u4 (ref), u6 (ref), u8 (ref), buffer_create_ret (copy)
    local v25;

    if p22 then
        v25 = not p21.PressEDown;
    else
        v25 = p22;
    end;

    p21.PressEDown = p22;
    local v26 = p21.Defusing and not p21.DefuseFinished;

    if not p21.Resimulating and p21.DefuseAdvertised ~= v26 then
        p21.DefuseAdvertised = v26;
        p21.DefuseUpdate:Fire(v26, p21.DefuseTimer);
    end;

    if not p22 then
        p21.DefuseFinished = false;
        u1.StopDefusing(p21);

        if not p21.Defusing then
            return;
        end;
    end;

    if u2 and (v25 and not p21.Defusing) then
        local v27 = #u3:GetChildren() > 0;

        if v27 then
            local Map = workspace:FindFirstChild("Map");
            local v28 = {};

            if Map then
                Map = Map:FindFirstChild("Geometry");
            end;

            v28[1], v28[2] = u3, Map;
            RaycastParams_new_ret.FilterDescendantsInstances = v28;
            local v29 = p21:BuildCameraCFrame(true, true);
            local PickupRange = u5.CFG.PickupRange;
            u4.PushEntitiesToTime("DroppedWeapon", nil, p23, v29.Position, v29.LookVector, PickupRange + u5.CFG.PickupRewindSlack);
            local v30 = workspace:Raycast(v29.Position, v29.LookVector * PickupRange, RaycastParams_new_ret);
            local v31;

            if v30 then
                v31 = v30.Instance;

                while v31 and v31.Parent ~= u3 do
                    v31 = v31.Parent;
                end;
            else
                v31 = v30;
            end;

            if v31 then
                v31 = tonumber(v31.Name);
            end;

            if not v31 then
                if v30 then
                    PickupRange = v30.Distance or PickupRange;
                end;

                v31 = u1.AimedWeapon(v29, PickupRange, p23);
            end;

            if v31 then
                p21.OnPickup:Fire(v31);
            end;

            if v27 then
                u4.Backup();
            end;
        end;
    end;

    if u4.GetAllCategoryEntities("Bomb") then
        local v32 = p21:BuildCameraCFrame(true, true);
        local Position = v32.Position;
        local LookVector = v32.LookVector;
        local DefuseRange = u5.CFG.DefuseRange;
        local v33 = DefuseRange * 1.1612903225806452;
        local v34 = p21.OnGround and u6.Get("Bomb", "CanDefuse")[p21.Team];
        local v35 = p21.Defusing and p21.Constants.DefuseAngleMax or p21.Constants.DefuseAngle;
        local v36 = u2 and 0 or u5.CFG.InterpolationDelay;
        local v37 = nil;

        for _, v in u4.GetAllCategoryEntities("Bomb") do
            if not v34 then
                break;
            end;

            if not (v.Defused or (v.Exploded or (v36 >= v.BlowTimer or v.Defusing ~= 0 and v.Defusing ~= p21.Identifier))) then
                local Position2 = v.Model.PrimaryPart.Position;
                local v38 = Position2.X - Position.X;
                local v39 = Position2.Z - Position.Z;
                local math_sqrt_ret = math.sqrt(v38 * v38 + v39 * v39);

                if DefuseRange >= math_sqrt_ret then
                    local v40 = Position2 - Position;
                    local vector_magnitude_ret = vector.magnitude(v40);

                    if v33 >= vector_magnitude_ret then
                        local vector_dot_ret = vector.dot(LookVector, v40 / vector_magnitude_ret);

                        if vector_dot_ret >= v35 and u8.SweepBox(Position, Position2, Vector3.new(0.02, 0.02, 0.02)).Fraction >= 0.98 then
                            v37 = v;
                            v35 = vector_dot_ret;
                            DefuseRange = math_sqrt_ret;
                        end;
                    end;
                end;
            end;
        end;

        local v41 = v37 ~= nil;
        p21.DefuseBomb = v41 and v37 and v37 or nil;

        if v41 then
            if not (p21.Defusing or p21.DefuseFinished) then
                p21.DefuseTimer = p21.HasDefuseKit and u5.CFG.DefuseTime / 2 or u5.CFG.DefuseTime;
                p21.Defusing = true;
            end;
        else
            u1.StopDefusing(p21);
        end;

        if p21.Defusing then
            buffer.writef32(buffer_create_ret, 0, p21.DefuseTimer - p24);
            local buffer_readf32_ret = buffer.readf32(buffer_create_ret, 0);
            p21.DefuseTimer = math.max(0, buffer_readf32_ret);

            if p21.DefuseTimer <= 0 then
                p21.DefuseFinished = true;

                if not (u2 or (p21.Resimulating or not v37)) then
                    v37.Defused = true;
                end;
            end;

            if not p21.Resimulating then
                p21.DefuseAdvertised = true;
                p21.DefuseUpdate:Fire(true, p21.DefuseTimer);
            end;
        end;
    end;
end;

return u1;