-- ReplicatedStorage.ClientModules.FrustumCuller
-- Script path: ReplicatedStorage.ClientModules.FrustumCuller
-- Decompile time: 8.15 ms

-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local u1 = {};
u1.__index = u1;

local function getBounds(u2) -- Line: 43
    -- upvalues: getBounds (copy)
    if typeof(u2) ~= "Instance" then
        return nil, nil;
    end;

    if u2:IsA("BasePart") then
        return u2.Position, u2.Size.Magnitude * 0.5;
    end;

    if u2:IsA("Model") then
        local BoundingBox, v3 = u2:GetBoundingBox();

        return BoundingBox.Position, v3.Magnitude * 0.5;
    end;

    if u2:IsA("Attachment") then
        return u2.WorldPosition, 0;
    end;

    if u2:IsA("GuiBase3D") then
        local v4 = u2.Adornee or u2.Parent;

        if v4 then
            return getBounds(v4);
        end;

        return nil, nil;
    end;

    local success, result = pcall(function() -- Line: 66
        -- upvalues: u2 (copy)
        return u2:GetPivot();
    end);

    if success and result then
        return result.Position, 0;
    end;

    return nil, nil;
end;

local function sphereInFrustum(p5: any, p6: vector, p7: number) -- Line: 77
    local v8 = p6.X - p5._px;
    local v9 = p6.Y - p5._py;
    local v10 = p6.Z - p5._pz;
    local v11 = v8 * p5._lx + v9 * p5._ly + v10 * p5._lz;

    if v11 + p7 < p5._near or v11 - p7 > p5._far then
        return false;
    end;

    if v11 * p5._sinH + p7 < math.abs(v8 * p5._rx + v9 * p5._ry + v10 * p5._rz) * p5._cosH then
        return false;
    end;

    return v11 * p5._sinV + p7 >= math.abs(v8 * p5._ux + v9 * p5._uy + v10 * p5._uz) * p5._cosV;
end;

function u1.new(p12: userdata?, p13: number?) -- Line: 95
    -- upvalues: u1 (copy), Workspace (copy)
    local v14 = setmetatable({}, u1);
    v14._camera = p12 or Workspace.CurrentCamera;
    v14._far = p13 or 600;
    v14._registered = {};
    v14._hasPlanes = false;
    v14._managed = false;
    v14._lastCF = nil;
    v14._lastFov = nil;
    v14._lastViewport = nil;

    return v14;
end;

function u1.UpdateFrustum(p15: table, p16, p17: number?, p18, p19: number?) -- Line: 114
    local _camera = p15._camera;

    if not (p16 or _camera) then
        p15._hasPlanes = false;

        return;
    end;

    local v20 = p16 or _camera.CFrame;
    local Position = v20.Position;
    local LookVector = v20.LookVector;
    local RightVector = v20.RightVector;
    local UpVector = v20.UpVector;
    local v21 = p18 or _camera.ViewportSize;
    local v22 = v21.Y > 0 and (v21.X / v21.Y or 1) or 1;
    local v23 = p17 or _camera.FieldOfView;
    local v24 = math.rad(v23) * 0.5 + 0.06981317007977318;
    local v25 = math.tan(v24) * v22;
    local v26 = math.atan(v25) + 0.06981317007977318;
    local Y = Position.Y;
    local Z = Position.Z;
    p15._px = Position.X;
    p15._py = Y;
    p15._pz = Z;
    local Y2 = LookVector.Y;
    local Z2 = LookVector.Z;
    p15._lx = LookVector.X;
    p15._ly = Y2;
    p15._lz = Z2;
    local Y3 = RightVector.Y;
    local Z3 = RightVector.Z;
    p15._rx = RightVector.X;
    p15._ry = Y3;
    p15._rz = Z3;
    local Y4 = UpVector.Y;
    local Z4 = UpVector.Z;
    p15._ux = UpVector.X;
    p15._uy = Y4;
    p15._uz = Z4;
    local math_sin_ret = math.sin(v24);
    local math_cos_ret = math.cos(v24);
    p15._sinV = math_sin_ret;
    p15._cosV = math_cos_ret;
    local math_sin_ret2 = math.sin(v26);
    local math_cos_ret2 = math.cos(v26);
    p15._sinH = math_sin_ret2;
    p15._cosH = math_cos_ret2;
    p15._near = math.abs(p19 or _camera.NearPlaneZ);
    p15._hasPlanes = true;
    p15._managed = p16 ~= nil;
    p15._lastCF = v20;
    p15._lastFov = v23;
    p15._lastViewport = v21;
end;

function u1._ensureFrustum(p27) -- Line: 151
    -- upvalues: Workspace (copy)
    if p27._managed then
        return;
    end;

    local _camera = p27._camera;

    if not (_camera and _camera.Parent) then
        _camera = Workspace.CurrentCamera;
        p27._camera = _camera;
    end;

    if _camera then
        if not (p27._hasPlanes and (_camera.CFrame == p27._lastCF and (_camera.FieldOfView == p27._lastFov and _camera.ViewportSize == p27._lastViewport))) then
            p27:UpdateFrustum();
        end;

        return;
    end;

    p27._hasPlanes = false;
end;

function u1.RegisterObject(p28: table, p29: userdata) -- Line: 177
    if typeof(p29) == "Instance" then
        p28._registered[p29] = true;

        return;
    end;

    warn("FrustumCuller:RegisterObject expected an Instance, got", (typeof(p29)));
end;

function u1.UnregisterObject(p30: table, p31: userdata) -- Line: 185
    p30._registered[p31] = nil;
end;

function u1.Visible(p32, p33) -- Line: 192
    -- upvalues: getBounds (copy), sphereInFrustum (copy)
    if not p32._managed then
        p32:_ensureFrustum();
    end;

    if not p32._hasPlanes then
        return false;
    end;

    local v34, v35 = getBounds(p33);

    return not v34 and true or sphereInFrustum(p32, v34, v35);
end;

function u1.VisiblePoint(p36: table, p37: vector, p38: number?) -- Line: 210
    -- upvalues: sphereInFrustum (copy)
    if not p36._managed then
        p36:_ensureFrustum();
    end;

    if p36._hasPlanes then
        return sphereInFrustum(p36, p37, p38 or 0);
    end;

    return false;
end;

local u39 = nil;

function u1.Shared() -- Line: 224
    -- upvalues: u39 (ref), u1 (copy)
    if not u39 then
        u39 = u1.new();
    end;

    return u39;
end;

function u1.GetVisible(p40) -- Line: 232
    p40:_ensureFrustum();
    local v41 = {};

    for i in p40._registered do
        if i.Parent or i:IsA("Attachment") then
            if p40:Visible(i) then
                table.insert(v41, i);
            end;
        else
            p40._registered[i] = nil;
        end;
    end;

    return v41;
end;

return u1;