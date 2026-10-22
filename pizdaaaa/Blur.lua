-- ReplicatedStorage.ClientModules.Blur
-- Script path: ReplicatedStorage.ClientModules.Blur
-- Decompile time: 9.55 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local workspace_CurrentCamera = workspace.CurrentCamera;
local Folder = Instance.new("Folder");
Folder.Name = "Blur";
Folder.Parent = workspace_CurrentCamera;
local u2 = {};
local TweenInfo_new_ret = TweenInfo.new(0.25);
local ScreenPointToRay = workspace_CurrentCamera.ScreenPointToRay;
local CFrame_Angles_ret = CFrame.Angles(1.5707963267948966, 0, 0);
local u3 = false;

local function InstanceWedge() -- Line: 29
    -- upvalues: Folder (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Glass;
    Part.Transparency = 0.9;
    Part.Reflectance = 1;
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.Parent = Folder;
    local SpecialMesh = Instance.new("SpecialMesh");
    SpecialMesh.MeshType = Enum.MeshType.Wedge;
    SpecialMesh.Name = "WedgeMesh";
    SpecialMesh.Parent = Part;

    return Part;
end;

local function DrawTriangle(p4, p5, p6, p7, p8) -- Line: 115
    -- upvalues: CFrame_Angles_ret (copy)
    local vector_magnitude_ret = vector.magnitude(p4 - p5);
    local vector_magnitude_ret2 = vector.magnitude(p5 - p6);
    local vector_magnitude_ret3 = vector.magnitude(p6 - p4);
    local math_max_ret = math.max(vector_magnitude_ret, vector_magnitude_ret2, vector_magnitude_ret3);

    if vector_magnitude_ret == math_max_ret then
        local v9 = p5;
        p5 = p6;
        p6 = p4;
        p4 = v9;
    elseif vector_magnitude_ret2 == math_max_ret then
        local v10 = p5;
        p5 = p4;
        p4 = p6;
        p6 = v10;
    end;

    local vector_magnitude_ret4 = vector.magnitude(p6 - p4);
    local v11 = ((p4 - p6).X * (p5 - p6).X + (p4 - p6).Y * (p5 - p6).Y + (p4 - p6).Z * (p5 - p6).Z) / vector_magnitude_ret4;
    local v12 = vector.magnitude(p5 - p6) ^ 2 - v11 * v11;
    local math_sqrt_ret = math.sqrt(v12);
    local v13 = vector_magnitude_ret4 - v11;
    local CFrame_new_ret = CFrame.new(p4, p6);
    local LookVector = (CFrame_new_ret * CFrame_Angles_ret).LookVector;
    local v14 = p6 + CFrame.new(p6, p4).LookVector * v11;
    local LookVector2 = CFrame.new(v14, p5).LookVector;
    local v15 = LookVector.X * LookVector2.X + LookVector.Y * LookVector2.Y + LookVector.Z * LookVector2.Z;
    local CFrame_Angles_ret2 = CFrame.Angles(0, 0, (math.acos(v15)));
    local v16 = CFrame_new_ret * CFrame_Angles_ret2;

    if vector.magnitude((v16 * CFrame_Angles_ret).LookVector - LookVector2) > 0.01 then
        v16 = v16 * CFrame.Angles(0, 0, math.acos(v15) * -2);
    end;

    local v17 = v16 * CFrame.new(0, math_sqrt_ret / 2, -(v13 + v11 / 2));
    local v18 = CFrame_new_ret * CFrame_Angles_ret2 * CFrame.Angles(0, 3.141592653589793, 0);

    if vector.magnitude((v18 * CFrame_Angles_ret).LookVector - LookVector2) > 0.01 then
        v18 = v18 * CFrame.Angles(0, 0, math.acos(v15) * 2);
    end;

    local v19 = v18 * CFrame.new(0, math_sqrt_ret / 2, v13 / 2);
    p7.WedgeMesh.Scale = Vector3.new(0, math_sqrt_ret / 0.2, v11 / 0.2);
    p7.CFrame = v17;
    p8.WedgeMesh.Scale = Vector3.new(0, math_sqrt_ret / 0.2, v13 / 0.2);
    p8.CFrame = v19;

    return p7, p8;
end;

function DrawQuad(p20, p21, p22, p23, p24)
    -- upvalues: DrawTriangle (copy)
    local v25, v26 = DrawTriangle(p20, p21, p22, p24[1], p24[2]);
    p24[1] = v25;
    p24[2] = v26;
    local v27, v28 = DrawTriangle(p22, p21, p23, p24[3], p24[4]);
    p24[3] = v27;
    p24[4] = v28;
end;

function u1.new(p29, p30) -- Line: 183
    -- upvalues: InstanceWedge (copy), u2 (copy)
    local v31 = {};
    local Frame = Instance.new("Frame");
    Frame.Parent = p30;
    Frame.Size = UDim2.new(1, -10, 1, -20);
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    v31.Frame = Frame;
    v31.Parts = {
        InstanceWedge(),
        InstanceWedge(),
        InstanceWedge(),
        InstanceWedge()
    };
    v31.Enabled = true;
    v31.AbsoluteSize = Frame.AbsoluteSize;
    u2[p29] = v31;

    return v31;
end;

function u1.Enabled(p32, p33) -- Line: 209
    -- upvalues: u2 (copy), u1 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local v34 = u2[p32];

    if not v34 then
        return;
    end;

    v34.Enabled = p33;

    if not p33 then
        for _, v in v34.Parts do
            TweenService:Create(v, TweenInfo_new_ret, {
                Transparency = 1
            }):Play();
        end;

        return;
    end;

    u1.Update(true);

    for _, v in v34.Parts do
        TweenService:Create(v, TweenInfo_new_ret, {
            Transparency = 0.9
        }):Play();
    end;
end;

local CFrame_identity = CFrame.identity;

function u1.Update(p35) -- Line: 231
    -- upvalues: u2 (copy), CFrame_identity (ref), workspace_CurrentCamera (copy), u3 (ref), TweenService (copy), TweenInfo_new_ret (copy), ScreenPointToRay (copy)
    if not next(u2) then
        return;
    end;

    if not p35 and CFrame_identity == workspace_CurrentCamera.CFrame then
        return;
    end;

    if not u3 then
        for _, v in u2 do
            if not v.WasDisabled then
                for _, v2 in v.Parts do
                    v2.Transparency = 1;
                end;

                v.WasDisabled = true;
            end;
        end;

        return;
    end;

    CFrame_identity = workspace_CurrentCamera.CFrame;

    for _, v in u2 do
        if v.Enabled then
            local v36;

            if v.WasDisabled then
                v36 = v;

                for _, v2 in v.Parts do
                    TweenService:Create(v2, TweenInfo_new_ret, {
                        Transparency = 0.9
                    }):Play();
                end;

                v36.WasDisabled = false;
                v36.Redraw = true;
            else
                v36 = v;
            end;

            local Frame = v36.Frame;
            local v37 = 1 - Frame.ZIndex * 0.05;
            local AbsolutePosition = Frame.AbsolutePosition;
            local v38 = AbsolutePosition + Frame.AbsoluteSize;

            if v36.Redraw or (v36.LastTL ~= AbsolutePosition or (v36.LastBR ~= v38 or v36.LastCameraCF ~= CFrame_identity)) then
                v36.Redraw = false;
                v36.LastTL = AbsolutePosition;
                v36.LastBR = v38;
                v36.LastCameraCF = CFrame_identity;
                local Vector2_new_ret = Vector2.new(v38.X, AbsolutePosition.Y);
                local Vector2_new_ret2 = Vector2.new(AbsolutePosition.X, v38.Y);
                DrawQuad(ScreenPointToRay(workspace_CurrentCamera, AbsolutePosition.X, AbsolutePosition.Y, v37).Origin, ScreenPointToRay(workspace_CurrentCamera, Vector2_new_ret.X, Vector2_new_ret.Y, v37).Origin, ScreenPointToRay(workspace_CurrentCamera, Vector2_new_ret2.X, Vector2_new_ret2.Y, v37).Origin, ScreenPointToRay(workspace_CurrentCamera, v38.X, v38.Y, v37).Origin, v36.Parts);
            end;
        end;
    end;
end;

function u1.Start(p39) -- Line: 317
    -- upvalues: u3 (ref)
    local GameSettings = UserSettings().GameSettings;
    u3 = GameSettings.SavedQualityLevel.Value >= 8;
    UserSettings().GameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function() -- Line: 324
        -- upvalues: u3 (ref), GameSettings (copy)
        u3 = GameSettings.SavedQualityLevel.Value >= 8;
    end);
end;

return u1;