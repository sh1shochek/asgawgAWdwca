-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local UserFlag = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI");
local u1 = {
    LIMBS = 2,
    MOVEMENT = 3,
    CORNERS = 4,
    CIRCLE1 = 5,
    CIRCLE2 = 6,
    LIMBMOVE = 7,
    SMART_CIRCLE = 8,
    CHAR_OUTLINE = 9
};
local u2 = {
    Head = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true
};
local u3 = { Vector3.new(1, 1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, -1, -1), Vector3.new(-1, 1, -1) };
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;

local function AssertTypes(p4, ...) -- Line: 74
    local v5 = {};
    local v6 = "";

    for _, v in pairs({ ... }) do
        v5[v] = true;
        v6 = v6 .. (v6 == "" and "" or " or ") .. v;
    end;

    local v7 = type(p4);
    assert(v5[v7], v6 .. " type expected, got: " .. v7);
end;

local function Det3x3(p8: number, p9: number, p10: number, p11: number, p12: number, p13: number, p14: number, p15: number, p16: number) -- Line: 86
    return p8 * (p12 * p16 - p13 * p15) - p9 * (p11 * p16 - p13 * p14) + p10 * (p11 * p15 - p12 * p14);
end;

local function RayIntersection(p17: vector, p18: vector, p19: vector, p20: vector) -- Line: 104
    local v21 = p18:Cross(p20);
    local v22 = p19.X - p17.X;
    local v23 = p19.Y - p17.Y;
    local v24 = p19.Z - p17.Z;
    local Y = p18.Y;
    local v25 = -p20.Y;
    local Y2 = v21.Y;
    local Z = p18.Z;
    local v26 = -p20.Z;
    local Z2 = v21.Z;
    local v27 = p18.X * (v25 * Z2 - Y2 * v26) - -p20.X * (Y * Z2 - Y2 * Z) + v21.X * (Y * v26 - v25 * Z);

    if v27 == 0 then
        return Vector3.new(0, 0, 0);
    end;

    local v28 = -p20.Y;
    local Y3 = v21.Y;
    local v29 = -p20.Z;
    local Z3 = v21.Z;
    local Y4 = p18.Y;
    local Y5 = v21.Y;
    local Z4 = p18.Z;
    local Z5 = v21.Z;
    local v30 = p17 + (v22 * (v28 * Z3 - Y3 * v29) - -p20.X * (v23 * Z3 - Y3 * v24) + v21.X * (v23 * v29 - v28 * v24)) / v27 * p18;
    local v31 = p19 + (p18.X * (v23 * Z5 - Y5 * v24) - v22 * (Y4 * Z5 - Y5 * Z4) + v21.X * (Y4 * v24 - v23 * Z4)) / v27 * p20;

    return (v31 - v30).Magnitude >= 0.25 and Vector3.new(0, 0, 0) or v30 + (v31 - v30) * 0.5;
end;

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"));
local u32 = setmetatable({}, BaseOcclusion);
u32.__index = u32;

function u32.new() -- Line: 136
    -- upvalues: BaseOcclusion (copy), u32 (copy), u1 (copy)
    local v33 = BaseOcclusion.new();
    local v34 = setmetatable(v33, u32);
    v34.char = nil;
    v34.humanoidRootPart = nil;
    v34.torsoPart = nil;
    v34.headPart = nil;
    v34.childAddedConn = nil;
    v34.childRemovedConn = nil;
    v34.ancestryChangedConn = nil;
    v34.behaviors = {};
    v34.behaviors[u1.LIMBS] = v34.LimbBehavior;
    v34.behaviors[u1.MOVEMENT] = v34.MoveBehavior;
    v34.behaviors[u1.CORNERS] = v34.CornerBehavior;
    v34.behaviors[u1.CIRCLE1] = v34.CircleBehavior;
    v34.behaviors[u1.CIRCLE2] = v34.CircleBehavior;
    v34.behaviors[u1.LIMBMOVE] = v34.LimbMoveBehavior;
    v34.behaviors[u1.SMART_CIRCLE] = v34.SmartCircleBehavior;
    v34.behaviors[u1.CHAR_OUTLINE] = v34.CharacterOutlineBehavior;
    v34.mode = u1.SMART_CIRCLE;
    v34.behaviorFunction = v34.SmartCircleBehavior;
    v34.savedHits = {};
    v34.trackedLimbs = {};
    v34.camera = workspace.CurrentCamera;
    v34.enabled = false;

    return v34;
end;

function u32.Enable(p35, p36) -- Line: 170
    p35.enabled = p36;

    if not p36 then
        p35:Cleanup();

        if p35.ancestryChangedConn then
            p35.ancestryChangedConn:Disconnect();
            p35.ancestryChangedConn = nil;
        end;
    end;
end;

function u32.GetOcclusionMode(p37) -- Line: 182
    return Enum.DevCameraOcclusionMode.Invisicam;
end;

function u32.LimbBehavior(p38, p39) -- Line: 188
    for i, _ in pairs(p38.trackedLimbs) do
        p39[#p39 + 1] = i.Position;
    end;
end;

function u32.MoveBehavior(p40, p41) -- Line: 194
    for i = 1, 3 do
        local Position = p40.humanoidRootPart.Position;
        local Velocity = p40.humanoidRootPart.Velocity;
        local v42 = Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude / 2;
        p41[#p41 + 1] = Position + (i - 1) * p40.humanoidRootPart.CFrame.lookVector * v42;
        local _ = i;
    end;
end;

function u32.CornerBehavior(p43, p44) -- Line: 203
    -- upvalues: u3 (copy)
    local CFrame2 = p43.humanoidRootPart.CFrame;
    local Position = CFrame2.Position;
    local v45 = CFrame2 - Position;
    local v46 = p43.char:GetExtentsSize() / 2;
    p44[#p44 + 1] = Position;

    for i = 1, #u3 do
        p44[#p44 + 1] = Position + v45 * (v46 * u3[i]);
        local _ = i;
    end;
end;

function u32.CircleBehavior(p47, p48) -- Line: 214
    -- upvalues: u1 (copy)
    local v49;

    if p47.mode == u1.CIRCLE1 then
        v49 = p47.humanoidRootPart.CFrame;
    else
        local CoordinateFrame = p47.camera.CoordinateFrame;
        v49 = CoordinateFrame - CoordinateFrame.Position + p47.humanoidRootPart.Position;
    end;

    p48[#p48 + 1] = v49.Position;

    for i = 0, 9 do
        local v50 = 0.6283185307179586 * i;
        local math_cos_ret = math.cos(v50);
        local math_sin_ret = math.sin(v50);
        local v51 = Vector3.new(math_cos_ret, math_sin_ret, 0) * 3;
        p48[#p48 + 1] = v49 * v51;
        local _ = i;
    end;
end;

function u32.LimbMoveBehavior(p52, p53) -- Line: 230
    p52:LimbBehavior(p53);
    p52:MoveBehavior(p53);
end;

function u32.CharacterOutlineBehavior(p54, p55) -- Line: 235
    -- upvalues: UserFlag (copy), RaycastParams_new_ret2 (copy)
    local unit = p54.torsoPart.CFrame.upVector.unit;
    local unit2 = p54.torsoPart.CFrame.rightVector.unit;
    p55[#p55 + 1] = p54.torsoPart.CFrame.p;
    p55[#p55 + 1] = p54.torsoPart.CFrame.p + unit;
    p55[#p55 + 1] = p54.torsoPart.CFrame.p - unit;
    p55[#p55 + 1] = p54.torsoPart.CFrame.p + unit2;
    p55[#p55 + 1] = p54.torsoPart.CFrame.p - unit2;

    if p54.headPart then
        p55[#p55 + 1] = p54.headPart.CFrame.p;
    end;

    local CFrame_new_ret = CFrame.new(Vector3.new(0, 0, 0), (Vector3.new(p54.camera.CoordinateFrame.lookVector.X, 0, p54.camera.CoordinateFrame.lookVector.Z)));
    local v56 = p54.torsoPart and p54.torsoPart.Position or p54.humanoidRootPart.Position;
    local v57 = { p54.torsoPart };

    if p54.headPart then
        v57[#v57 + 1] = p54.headPart;
    end;

    for i = 1, 24 do
        local v58 = 6.283185307179586 * i / 24;
        local math_cos_ret = math.cos(v58);
        local math_sin_ret = math.sin(v58);
        local v59 = CFrame_new_ret * (Vector3.new(math_cos_ret, math_sin_ret, 0) * 3);
        local X = v59.X;
        local math_max_ret = math.max(v59.Y, -2.25);
        local Vector3_new_ret = Vector3.new(X, math_max_ret, v59.Z);
        local v60;

        if UserFlag then
            RaycastParams_new_ret2.FilterDescendantsInstances = v57;
            local v61 = workspace:Raycast(v56 + Vector3_new_ret, -3 * Vector3_new_ret, RaycastParams_new_ret2);

            if v61 then
                local Position = v61.Position;
                p55[#p55 + 1] = Position + 0.2 * (v56 - Position).unit;
                v60 = i;
            else
                v60 = i;
            end;
        else
            local Ray_new_ret = Ray.new(v56 + Vector3_new_ret, -3 * Vector3_new_ret);
            local v62, v63 = workspace:FindPartOnRayWithWhitelist(Ray_new_ret, v57, false);

            if v62 then
                p55[#p55 + 1] = v63 + 0.2 * (v56 - v63).unit;
                v60 = i;
            else
                v60 = i;
            end;
        end;
    end;
end;

function u32.SmartCircleBehavior(p64, p65) -- Line: 289
    -- upvalues: UserFlag (copy), RaycastParams_new_ret (copy), RayIntersection (copy)
    local unit = p64.torsoPart.CFrame.upVector.unit;
    local unit2 = p64.torsoPart.CFrame.rightVector.unit;
    p65[#p65 + 1] = p64.torsoPart.CFrame.p;
    p65[#p65 + 1] = p64.torsoPart.CFrame.p + unit;
    p65[#p65 + 1] = p64.torsoPart.CFrame.p - unit;
    p65[#p65 + 1] = p64.torsoPart.CFrame.p + unit2;
    p65[#p65 + 1] = p64.torsoPart.CFrame.p - unit2;

    if p64.headPart then
        p65[#p65 + 1] = p64.headPart.CFrame.p;
    end;

    local v66 = p64.camera.CFrame - p64.camera.CFrame.p;
    local v67 = Vector3.new(0, 0.5, 0) + (p64.torsoPart and p64.torsoPart.Position or p64.humanoidRootPart.Position);

    for i = 1, 24 do
        local v68 = 0.2617993877991494 * i - 1.5707963267948966;
        local math_cos_ret = math.cos(v68);
        local math_sin_ret = math.sin(v68);
        local v69 = v67 + v66 * (Vector3.new(math_cos_ret, math_sin_ret, 0) * 2.5);
        local v70 = v69 - p64.camera.CFrame.p;
        local v71;

        if UserFlag then
            RaycastParams_new_ret.FilterDescendantsInstances = { p64.char };
            local v72 = workspace:Raycast(v67, v69 - v67, RaycastParams_new_ret);

            if v72 then
                local Normal = v72.Normal;
                local v73 = v72.Position + 0.1 * Normal.unit;
                local v74 = v73 - v67;
                local unit3 = v74:Cross(v70).unit:Cross(Normal).unit;
                local unit4 = (v73 - p64.camera.CFrame.p).unit;

                if v74.unit:Dot(-unit3) < v74.unit:Dot(unit4) then
                    v69 = RayIntersection(v73, unit3, v69, v70);

                    if v69.Magnitude > 0 then
                        local v75 = workspace:Raycast(v73, v69 - v73, RaycastParams_new_ret);

                        if v75 then
                            v69 = v75.Position + 0.1 * v75.Normal.Unit;
                        end;
                    else
                        v69 = v73;
                    end;
                else
                    v69 = v73;
                end;

                local v76 = workspace:Raycast(v67, v69 - v67, RaycastParams_new_ret);

                if v76 then
                    v69 = v76.Position - 0.1 * (v69 - v67).unit;
                end;
            end;

            p65[#p65 + 1] = v69;
            v71 = i;
        else
            local Ray_new_ret = Ray.new(v67, v69 - v67);
            local v77, v78, v79 = workspace:FindPartOnRayWithIgnoreList(Ray_new_ret, { p64.char }, false, false);

            if v77 then
                local v80 = v78 + 0.1 * v79.unit;
                local v81 = v80 - v67;
                local unit3 = v81:Cross(v70).unit:Cross(v79).unit;
                local unit4 = (v80 - p64.camera.CFrame.p).unit;

                if v81.unit:Dot(-unit3) < v81.unit:Dot(unit4) then
                    v69 = RayIntersection(v80, unit3, v69, v70);

                    if v69.Magnitude > 0 then
                        local Ray_new_ret2 = Ray.new(v80, v69 - v80);
                        local v82, v83, v84 = workspace:FindPartOnRayWithIgnoreList(Ray_new_ret2, { p64.char }, false, false);

                        if v82 then
                            v69 = v83 + 0.1 * v84.unit;
                        end;
                    else
                        v69 = v80;
                    end;
                else
                    v69 = v80;
                end;

                local Ray_new_ret2 = Ray.new(v67, v69 - v67);
                local v85, v86, _ = workspace:FindPartOnRayWithIgnoreList(Ray_new_ret2, { p64.char }, false, false);

                if v85 then
                    v69 = v86 - 0.1 * (v69 - v67).unit;
                end;
            end;

            p65[#p65 + 1] = v69;
            v71 = i;
        end;
    end;
end;

function u32.CheckTorsoReference(p87) -- Line: 425
    if p87.char then
        p87.torsoPart = p87.char:FindFirstChild("Torso");

        if not p87.torsoPart then
            p87.torsoPart = p87.char:FindFirstChild("UpperTorso");

            if not p87.torsoPart then
                p87.torsoPart = p87.char:FindFirstChild("HumanoidRootPart");
            end;
        end;

        p87.headPart = p87.char:FindFirstChild("Head");
    end;
end;

function u32.CharacterAdded(u88: table, p89: userdata, p90: userdata) -- Line: 439
    -- upvalues: Players (copy), u2 (copy)
    if p90 ~= Players.LocalPlayer then
        return;
    end;

    if u88.childAddedConn then
        u88.childAddedConn:Disconnect();
        u88.childAddedConn = nil;
    end;

    if u88.childRemovedConn then
        u88.childRemovedConn:Disconnect();
        u88.childRemovedConn = nil;
    end;

    if u88.ancestryChangedConn then
        u88.ancestryChangedConn:Disconnect();
        u88.ancestryChangedConn = nil;
    end;

    u88.char = p89;
    u88.trackedLimbs = {};
    u88.childAddedConn = p89.ChildAdded:Connect(function(p91) -- Line: 461, Name: childAdded
        -- upvalues: u2 (ref), u88 (copy)
        if p91:IsA("BasePart") then
            if u2[p91.Name] then
                u88.trackedLimbs[p91] = true;
            end;

            if p91.Name == "Torso" or p91.Name == "UpperTorso" then
                u88.torsoPart = p91;
            end;

            if p91.Name == "Head" then
                u88.headPart = p91;
            end;
        end;
    end);
    u88.childRemovedConn = p89.ChildRemoved:Connect(function(p92) -- Line: 477, Name: childRemoved
        -- upvalues: u88 (copy)
        u88.trackedLimbs[p92] = nil;
        u88:CheckTorsoReference();
    end);

    for _, child in pairs(u88.char:GetChildren()) do
        if child:IsA("BasePart") then
            if u2[child.Name] then
                u88.trackedLimbs[child] = true;
            end;

            if child.Name == "Torso" or child.Name == "UpperTorso" then
                u88.torsoPart = child;
            end;

            if child.Name == "Head" then
                u88.headPart = child;
            end;
        end;
    end;
end;

function u32.SetMode(p93: table, p94: number) -- Line: 491
    -- upvalues: AssertTypes (copy), u1 (copy)
    AssertTypes(p94, "number");

    for _, v in pairs(u1) do
        if v == p94 then
            p93.mode = p94;
            p93.behaviorFunction = p93.behaviors[p93.mode];

            return;
        end;
    end;

    error("Invalid mode number");
end;

function u32.GetObscuredParts(p95) -- Line: 503
    return p95.savedHits;
end;

function u32.Cleanup(p96) -- Line: 508
    for i, v in pairs(p96.savedHits) do
        i.LocalTransparencyModifier = v;
    end;
end;

function u32.Update(u97: table, p98: number, p99, p100) -- Line: 514
    if not (u97.enabled and u97.char) then
        return p99, p100;
    end;

    u97.camera = workspace.CurrentCamera;

    if not u97.humanoidRootPart then
        local v101 = u97.char:FindFirstChildOfClass("Humanoid");

        if v101 and v101.RootPart then
            u97.humanoidRootPart = v101.RootPart;
        else
            u97.humanoidRootPart = u97.char:FindFirstChild("HumanoidRootPart");

            if not u97.humanoidRootPart then
                return p99, p100;
            end;
        end;

        if u97.ancestryChangedConn then
            u97.ancestryChangedConn:Disconnect();
            u97.ancestryChangedConn = nil;
        end;

        u97.ancestryChangedConn = u97.humanoidRootPart.AncestryChanged:Connect(function(p102, p103) -- Line: 544
            -- upvalues: u97 (copy)
            if p102 == u97.humanoidRootPart and not p103 then
                u97.humanoidRootPart = nil;

                if u97.ancestryChangedConn and u97.ancestryChangedConn.Connected then
                    u97.ancestryChangedConn:Disconnect();
                    u97.ancestryChangedConn = nil;
                end;
            end;
        end);
    end;

    if not u97.torsoPart then
        u97:CheckTorsoReference();

        if not u97.torsoPart then
            return p99, p100;
        end;
    end;

    local v104 = {};
    u97.behaviorFunction(u97, v104);
    local u105 = {};
    local v106 = { u97.char };

    local function add(p107) -- Line: 570
        -- upvalues: u105 (copy), u97 (copy)
        u105[p107] = true;

        if not u97.savedHits[p107] then
            u97.savedHits[p107] = p107.LocalTransparencyModifier;
        end;
    end;

    local PartsObscuringTarget = u97.camera:GetPartsObscuringTarget({ u97.headPart and u97.headPart.CFrame.p or v104[1], u97.torsoPart and u97.torsoPart.CFrame.p or v104[2] }, v106);
    local v108 = 0;
    local v109 = {};
    local v110 = 0.75;
    local v111 = 0.75;

    for i = 1, #PartsObscuringTarget do
        local v112 = PartsObscuringTarget[i];
        v108 = v108 + 1;
        v109[v112] = true;
        local _ = i;

        for _, child in pairs(v112:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                v108 = v108 + 1;
                break;
            end;
        end;
    end;

    if v108 > 0 then
        v110 = math.pow(0.375 / v108 + 0.375, 1 / v108);
        v111 = math.pow(0.25 / v108 + 0.25, 1 / v108);
    end;

    local PartsObscuringTarget2 = u97.camera:GetPartsObscuringTarget(v104, v106);
    local v113 = {};

    for i = 1, #PartsObscuringTarget2 do
        local v114 = PartsObscuringTarget2[i];
        v113[v114] = v109[v114] and v110 and v110 or v111;

        if v114.Transparency < v113[v114] then
            u105[v114] = true;

            if not u97.savedHits[v114] then
                u97.savedHits[v114] = v114.LocalTransparencyModifier;
            end;
        end;

        local _ = i;

        for _, child in pairs(v114:GetChildren()) do
            if (child:IsA("Decal") or child:IsA("Texture")) and child.Transparency < v113[v114] then
                v113[child] = v113[v114];
                u105[child] = true;

                if not u97.savedHits[child] then
                    u97.savedHits[child] = child.LocalTransparencyModifier;
                end;
            end;
        end;
    end;

    for i, v in pairs(u97.savedHits) do
        if u105[i] then
            i.LocalTransparencyModifier = i.Transparency < 1 and ((v113[i] - i.Transparency) / (1 - i.Transparency) or 0) or 0;
        else
            i.LocalTransparencyModifier = v;
            u97.savedHits[i] = nil;
        end;
    end;

    return p99, p100;
end;

return u32;