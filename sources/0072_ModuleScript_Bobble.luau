-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = Vector2.new(0.02, 0.015) / 50;

local function removeY(p3: vector) -- Line: 38
    return p3 * Vector3.new(1, 0, 1);
end;

local function toVector3(p4) -- Line: 42
    return Vector3.new(p4.X, p4.Y, 0);
end;

local function toggleScopeVisibility(p5: userdata, p6: boolean) -- Line: 46
    for _, descendant in pairs(p5:GetDescendants()) do
        if descendant:IsA("MeshPart") then
            descendant.Transparency = p6 == true and 0 or 1;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p6;
        end;
    end;
end;

local function applySkinToScope(p7: userdata, p8: userdata) -- Line: 56
    if p7.ClassName ~= "Model" or p8.ClassName ~= "Model" then
        return;
    end;

    local function clearSurfaceAppearances(p9: userdata) -- Line: 59
        for _, child in pairs(p9:GetChildren()) do
            if child.ClassName == "SurfaceAppearance" then
                child:Destroy();
            end;
        end;
    end;

    for _, child in pairs(p7:GetChildren()) do
        local v10 = p8:FindFirstChild(child.Name);

        if v10 then
            local v11 = v10:FindFirstChildWhichIsA("SurfaceAppearance");

            if v11 then
                local v12 = v11:Clone();
                v12.Name = v10.Name;
                clearSurfaceAppearances(child);
                v12.Parent = child;
            end;
        end;
    end;
end;

function u1.addScopeKick(p13) -- Line: 82
    if p13.IsDestroyed or not p13.ScopeSpring then
        return;
    end;

    p13.ScopeSpring:impulse(Vector2.new(5, 1));
end;

function u1.getMovementVelocity(p14) -- Line: 91
    -- upvalues: RuntimeKinematics (copy), workspace_CurrentCamera (copy)
    local Character = p14.Character;

    if not Character then
        p14.IsInAir = false;

        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v15, _, _, _, v16 = RuntimeKinematics.resolve(Character, Character.PrimaryPart);
    p14.IsInAir = not v16;

    if v15.Magnitude <= 0.1 then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v17 = v15.Unit * math.min(v15.Magnitude, 50);

    return v17, workspace_CurrentCamera.CFrame:VectorToObjectSpace(v17);
end;

function u1.getNextCFrame(p18: any, p19: number) -- Line: 108
    -- upvalues: workspace_CurrentCamera (copy), u2 (copy)
    if p18.IsDestroyed then
        return CFrame.identity, Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v20 = (p19 <= 0 or p19 ~= p19) and 0.016666666666666666 or p19;
    local MovementVelocity, v21 = p18:getMovementVelocity();
    local v22 = v21 * Vector3.new(1, 0, 1);
    local Magnitude = MovementVelocity.Magnitude;
    local Magnitude2 = (MovementVelocity * Vector3.new(1, 0, 1)).Magnitude;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local v23, v24, _ = CFrame2:ToObjectSpace(p18.LastCameraCFrame):ToOrientation();
    local v25 = Vector2.new(v23, v24) / v20;
    local v26 = p18.RenderTime + v20 * Magnitude * 0.1;
    local v27 = Vector3.new(0.0011111111, 0.0011111111, 0) * Vector3.new(v25.Y, -v25.X, 0);
    local X = v22.X;
    local math_abs_ret = math.abs(v22.X);
    local math_abs_ret2 = math.abs(v21.Z);
    local math_max_ret = math.max(math_abs_ret, math_abs_ret2);
    local v28 = Vector3.new(0.0004, 0.0007, 0.0011) * Vector3.new(X, -Magnitude2, math_max_ret);
    local v29 = Vector2.new(math.sin(v26 * 3.141592653589793 * 2), (math.sin(v26 * 3.141592653589793 * 4))) * (u2 * 0.5) * Magnitude2;

    if p18.IsInAir then
        v28 = v28 + Vector3.new(0, -0.02, 0);
        v29 = v29 * 0.3;
    end;

    p18.MovementShiftSpring:setGoal(v28);
    p18.CameraShiftSpring:setGoal(v27 ~= v27 and Vector3.new(0, 0, 0) or v27);
    p18.BobbleSpring:setGoal(v29);
    p18.ScopeSpring:setGoal(Vector2.zero);
    p18.MovementShiftSpring:update(v20);
    p18.CameraShiftSpring:update(v20);
    p18.BobbleSpring:update(v20);
    p18.ScopeSpring:update(v20);
    p18.LastCameraCFrame = CFrame2;
    p18.RenderTime = v26;
    local Position = p18.MovementShiftSpring:getPosition();
    local Position2 = p18.CameraShiftSpring:getPosition();
    local Position3 = p18.BobbleSpring:getPosition();
    local Vector3_new_ret = Vector3.new(Position3.X, Position3.Y, 0);
    local Position4 = p18.ScopeSpring:getPosition();
    local math_rad_ret = math.rad(-Position.X * 250);
    local v30;

    if p18.IsAiming then
        v30 = 0.08726646259971647;
        math_rad_ret = 0;
    else
        v30 = 0;
    end;

    local Vector3_new_ret2 = Vector3.new(Position4.X, Position4.Y, 0);

    return CFrame.new(Position + Position2 + Vector3_new_ret) * CFrame.Angles(0, v30, math_rad_ret), Vector3_new_ret + Position, Vector3_new_ret2;
end;

function u1.setIsAiming(p31: any, p32: boolean) -- Line: 189
    -- upvalues: toggleScopeVisibility (copy)
    p31.IsAiming = p32;
    toggleScopeVisibility(p31.Scope, p32);
    toggleScopeVisibility(p31.ScopeReticlePart, p32);
end;

function u1.setModel(p33: any, p34: userdata) -- Line: 198
    -- upvalues: workspace_CurrentCamera (copy), toggleScopeVisibility (copy), applySkinToScope (copy)
    if not p34 then
        return;
    end;

    if p33.Scope then
        p33.Scope:Destroy();
        p33.Scope = nil;
    end;

    if p33.ScopeReticlePart then
        p33.ScopeReticlePart:Destroy();
        p33.ScopeReticlePart = nil;
    end;

    local Name = p34.Name;

    if Name == "AUG" or Name == "SG 553" then
        local Weapon = p34:FindFirstChild("Weapon");

        if Weapon and Weapon:FindFirstChild("ScopeSplit") then
            local ScopeSplit = Weapon.ScopeSplit;
            local Part = ScopeSplit:FindFirstChild("Part");

            if Part then
                p33.ScopeReticlePart = p33.Janitor:Add(Part:Clone());
                p33.ScopeReticlePart.Parent = workspace_CurrentCamera;
            end;

            local v35 = p33.Janitor:Add(ScopeSplit:Clone());
            p33.Scope = v35;
            v35.Parent = workspace_CurrentCamera;
            toggleScopeVisibility(v35, false);

            if Name == "AUG" then
                local Part2 = v35:FindFirstChild("Part");

                if Part2 then
                    Part2 = Part2:FindFirstChild("SurfaceGui");
                end;

                if Part2 then
                    Part2 = Part2:FindFirstChild("Frame");
                end;

                if Part2 then
                    Part2.Visible = false;
                end;
            end;

            applySkinToScope(v35, Weapon);
            ScopeSplit:Destroy();
        end;
    end;
end;

function u1.new(p36) -- Line: 247
    -- upvalues: u1 (copy), Janitor (copy), CharacterResolver (copy), Spring (copy), workspace_CurrentCamera (copy)
    local u37 = setmetatable({}, u1);
    u37.Janitor = Janitor.new();
    u37.IsDestroyed = false;
    u37.Character = p36.Character or CharacterResolver.getPlayerCharacter(p36.Player);
    u37.IsAiming = false;
    u37.CameraShiftSpring = Spring.new(0.7, 18, Vector3.new(0, 0, 0));
    u37.MovementShiftSpring = Spring.new(1, 15, Vector3.new(0, 0, 0));
    u37.BobbleSpring = Spring.new(1, 20, Vector2.zero);
    u37.ScopeSpring = Spring.new(1, 20, Vector2.zero);
    u37.LastCameraCFrame = workspace_CurrentCamera.CFrame;
    u37.RenderTime = 0;
    u37.IsInAir = false;

    if not p36.Character then
        u37.Janitor:Add(CharacterResolver.observeCharacter(p36.Player, function(p38) -- Line: 277
            -- upvalues: u37 (copy)
            u37.Character = p38;

            return function() -- Line: 279
            end;
        end));
    end;

    return u37;
end;

function u1.destroy(p39) -- Line: 290
    if p39.IsDestroyed then
        return;
    end;

    p39.IsDestroyed = true;
    p39.Janitor:Destroy();
    p39.Janitor = nil;
    p39.CameraShiftSpring = nil;
    p39.MovementShiftSpring = nil;
    p39.BobbleSpring = nil;
    p39.ScopeSpring = nil;
    p39.Character = nil;
    p39.Scope = nil;
    p39.ScopeReticlePart = nil;
end;

return u1;