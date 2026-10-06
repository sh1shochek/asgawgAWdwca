-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CommonUtils = script.Parent.Parent.Parent:WaitForChild("CommonUtils");
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local CameraWrapper = require(CommonUtils:WaitForChild("CameraWrapper"));
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local UserFlag = FlagUtil.getUserFlag("UserRaycastUpdateAPI");
local UserFlag2 = FlagUtil.getUserFlag("UserCurrentCameraUpdate2");
local UserFlag3 = FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak");
local u1;

if UserFlag2 then
    u1 = CameraWrapper.new();
else
    u1 = nil;
end;

local u2;

if UserFlag2 then
    u2 = nil;
else
    u2 = workspace.CurrentCamera;
end;

if UserFlag2 then
    u1:Enable();
end;

local math_min = math.min;
local math_tan = math.tan;
local math_rad = math.rad;
local Ray_new = Ray.new;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.IgnoreWater = true;
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.IgnoreWater = true;
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
local u3;

if UserFlag3 then
    u3 = ConnectionUtil.new();
else
    u3 = nil;
end;

local function getTotalTransparency(p4) -- Line: 42
    return 1 - (1 - p4.Transparency) * (1 - p4.LocalTransparencyModifier);
end;

local function eraseFromEnd(p5, p6) -- Line: 46
    for i = #p5, p6 + 1, -1 do
        p5[i] = nil;
        local _ = i;
    end;
end;

local u7 = nil;
local u8 = nil;
local u9;

if UserFlag2 then
    local function updateProjection() -- Line: 56
        -- upvalues: u1 (copy), math_rad (copy), u8 (ref), math_tan (copy), u7 (ref)
        local Camera = u1:getCamera();
        local v10 = math_rad(Camera.FieldOfView);
        local ViewportSize = Camera.ViewportSize;
        local v11 = ViewportSize.X / ViewportSize.Y;
        u8 = math_tan(v10 / 2) * 2;
        u7 = v11 * u8;
    end;

    u1:Connect("FieldOfView", updateProjection);
    u1:Connect("ViewportSize", updateProjection);
    local Camera = u1:getCamera();
    local v12 = math_rad(Camera.FieldOfView);
    local ViewportSize = Camera.ViewportSize;
    local v13 = ViewportSize.X / ViewportSize.Y;
    u8 = math_tan(v12 / 2) * 2;
    u7 = v13 * u8;
    u9 = u1:getCamera().NearPlaneZ;
    u1:Connect("NearPlaneZ", function() -- Line: 72
        -- upvalues: u9 (ref), u1 (copy)
        u9 = u1:getCamera().NearPlaneZ;
    end);
else
    local function v16() -- Line: 78
        -- upvalues: u2 (ref), math_rad (copy), u8 (ref), math_tan (copy), u7 (ref)
        local v14 = math_rad(u2.FieldOfView);
        local ViewportSize = u2.ViewportSize;
        local v15 = ViewportSize.X / ViewportSize.Y;
        u8 = math_tan(v14 / 2) * 2;
        u7 = v15 * u8;
    end;

    u2:GetPropertyChangedSignal("FieldOfView"):Connect(v16);
    u2:GetPropertyChangedSignal("ViewportSize"):Connect(v16);
    local v17 = math_rad(u2.FieldOfView);
    local ViewportSize = u2.ViewportSize;
    local v18 = ViewportSize.X / ViewportSize.Y;
    u8 = math_tan(v17 / 2) * 2;
    u7 = v18 * u8;
    u9 = u2.NearPlaneZ;
    u2:GetPropertyChangedSignal("NearPlaneZ"):Connect(function() -- Line: 92
        -- upvalues: u9 (ref), u2 (ref)
        u9 = u2.NearPlaneZ;
    end);
end;

local u19 = {};
local u20 = {};

local function refreshIgnoreList() -- Line: 102
    -- upvalues: u19 (ref), u20 (copy)
    local v21 = 1;
    u19 = {};

    for _, v in pairs(u20) do
        u19[v21] = v;
        v21 = v21 + 1;
    end;
end;

local function playerAdded(u22) -- Line: 111
    -- upvalues: u20 (copy), u19 (ref), UserFlag3 (copy), u3 (copy)
    local function characterAdded(p23) -- Line: 112
        -- upvalues: u20 (ref), u22 (copy), u19 (ref)
        u20[u22] = p23;
        local v24 = 1;
        u19 = {};

        for _, v in pairs(u20) do
            u19[v24] = v;
            v24 = v24 + 1;
        end;
    end;

    local function characterRemoving() -- Line: 116
        -- upvalues: u20 (ref), u22 (copy), u19 (ref)
        u20[u22] = nil;
        local v25 = 1;
        u19 = {};

        for _, v in pairs(u20) do
            u19[v25] = v;
            v25 = v25 + 1;
        end;
    end;

    if UserFlag3 then
        u3:trackConnection(`{u22.UserId}CharacterAdded`, u22.CharacterAdded:Connect(characterAdded));
        u3:trackConnection(`{u22.UserId}CharacterRemoving`, u22.CharacterRemoving:Connect(characterRemoving));
    else
        u22.CharacterAdded:Connect(characterAdded);
        u22.CharacterRemoving:Connect(characterRemoving);
    end;

    if u22.Character then
        u20[u22] = u22.Character;
        local v26 = 1;
        u19 = {};

        for _, v in pairs(u20) do
            u19[v26] = v;
            v26 = v26 + 1;
        end;
    end;
end;

local function playerRemoving(p27) -- Line: 140
    -- upvalues: u20 (copy), u19 (ref), UserFlag3 (copy), u3 (copy)
    u20[p27] = nil;
    local v28 = 1;
    u19 = {};

    for _, v in pairs(u20) do
        u19[v28] = v;
        v28 = v28 + 1;
    end;

    if UserFlag3 then
        u3:disconnect((`{p27.UserId}CharacterAdded`));
        u3:disconnect((`{p27.UserId}CharacterRemoving`));
    end;
end;

Players.PlayerAdded:Connect(playerAdded);
Players.PlayerRemoving:Connect(playerRemoving);

for _, v in ipairs(Players:GetPlayers()) do
    playerAdded(v);
end;

local v29 = 1;
u19 = {};

for _, v in pairs(u20) do
    u19[v29] = v;
    v29 = v29 + 1;
end;

local u30 = nil;
local u31 = nil;

if UserFlag2 then
    u1:Connect("CameraSubject", function() -- Line: 180
        -- upvalues: u1 (copy), u31 (ref)
        local CameraSubject = u1:getCamera().CameraSubject;

        if CameraSubject and CameraSubject:IsA("Humanoid") then
            u31 = CameraSubject.RootPart;

            return;
        end;

        if CameraSubject and CameraSubject:IsA("BasePart") then
            u31 = CameraSubject;

            return;
        end;

        u31 = nil;
    end);
else
    u2:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 191
        -- upvalues: u2 (ref), u31 (ref)
        local CameraSubject = u2.CameraSubject;

        if CameraSubject:IsA("Humanoid") then
            u31 = CameraSubject.RootPart;

            return;
        end;

        if CameraSubject:IsA("BasePart") then
            u31 = CameraSubject;

            return;
        end;

        u31 = nil;
    end);
end;

local function canOcclude(p32) -- Line: 203
    -- upvalues: u30 (ref)
    local v33;

    if 1 - (1 - p32.Transparency) * (1 - p32.LocalTransparencyModifier) < 0.25 then
        v33 = p32.CanCollide;

        if v33 then
            if u30 == (p32:GetRootPart() or p32) then
                v33 = false;
            else
                v33 = not p32:IsA("TrussPart");
            end;
        end;
    else
        v33 = false;
    end;

    return v33;
end;

local u34 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2)
};

local function getCollisionPoint(p35, p36) -- Line: 230
    -- upvalues: UserFlag (copy), RaycastParams_new_ret (copy), u19 (ref), Ray_new (copy)
    if UserFlag then
        RaycastParams_new_ret.FilterDescendantsInstances = u19;
        local v37;

        repeat
            v37 = workspace:Raycast(p35, p36, RaycastParams_new_ret);

            if v37 then
                if v37.Instance.CanCollide then
                    return v37.Position, true;
                end;

                RaycastParams_new_ret:AddToFilter(v37.Instance);
            end;
        until not v37;
    else
        local v38 = #u19;
        local v39;

        repeat
            local v40;
            v39, v40 = workspace:FindPartOnRayWithIgnoreList(Ray_new(p35, p36), u19, false, true);

            if v39 then
                if v39.CanCollide then
                    local v41 = u19;

                    for i = #v41, v38 + 1, -1 do
                        v41[i] = nil;
                        local _ = i;
                    end;

                    return v40, true;
                end;

                u19[#u19 + 1] = v39;
            end;
        until not v39;

        local v42 = u19;

        for i = #v42, v38 + 1, -1 do
            v42[i] = nil;
            local _ = i;
        end;
    end;

    return p35 + p36, false;
end;

local function queryPoint(p43, p44, p45, p46) -- Line: 266
    -- upvalues: u19 (ref), u9 (ref), UserFlag (copy), RaycastParams_new_ret (copy), u30 (ref), RaycastParams_new_ret2 (copy), Ray_new (copy)
    debug.profilebegin("queryPoint");
    local v47 = #u19;
    local v48 = p45 + u9;
    local v49 = p43 + p44 * v48;
    local v50 = (1 / 0);
    local v51 = (1 / 0);
    local v52 = 0;
    local v53;

    if UserFlag then
        RaycastParams_new_ret.FilterDescendantsInstances = u19;
        local v54 = p43;

        while true do
            local v55 = workspace:Raycast(p43, v49 - p43, RaycastParams_new_ret);

            if not v55 then
                v53 = v50;
                break;
            end;

            v52 = v52 + 1;
            local Instance = v55.Instance;
            local Position = v55.Position;
            v53 = (Position - v54).Magnitude;

            if v52 >= 64 then
                v51 = v53;
                v53 = v50;
            else
                local v56;

                if 1 - (1 - Instance.Transparency) * (1 - Instance.LocalTransparencyModifier) < 0.25 then
                    v56 = Instance.CanCollide;

                    if v56 then
                        if u30 == (Instance:GetRootPart() or Instance) then
                            v56 = false;
                        else
                            v56 = not Instance:IsA("TrussPart");
                        end;
                    end;
                else
                    v56 = false;
                end;

                if v56 then
                    RaycastParams_new_ret2.FilterDescendantsInstances = { Instance };

                    if workspace:Raycast(v49, Position - v49, RaycastParams_new_ret2) then
                        local v57;

                        if p46 then
                            v57 = workspace:Raycast(p46, v49 - p46, RaycastParams_new_ret2) or workspace:Raycast(v49, p46 - v49, RaycastParams_new_ret2);
                        else
                            v57 = false;
                        end;

                        if v57 then
                            v51 = v53;
                            v53 = v50;
                        elseif v48 >= v50 then
                            v53 = v50;
                        end;
                    else
                        v51 = v53;
                        v53 = v50;
                    end;
                else
                    v53 = v50;
                end;
            end;

            RaycastParams_new_ret:AddToFilter(Instance);
            p43 = Position - p44 * 0.001;

            if v51 < (1 / 0) or not Instance then
                break;
            end;

            v50 = v53;
        end;
    else
        local v58 = p43;

        while true do
            local v59;

            if true then
                local v60;
                v59, v60 = workspace:FindPartOnRayWithIgnoreList(Ray_new(p43, v49 - p43), u19, false, true);
                v52 = v52 + 1;

                if v59 then
                    local v61 = v52 >= 64;
                    local v62;

                    if 1 - (1 - v59.Transparency) * (1 - v59.LocalTransparencyModifier) < 0.25 then
                        v62 = v59.CanCollide;

                        if v62 then
                            if u30 == (v59:GetRootPart() or v59) then
                                v62 = false;
                            else
                                v62 = not v59:IsA("TrussPart");
                            end;
                        end;
                    else
                        v62 = false;
                    end;

                    if v62 or v61 then
                        local v63 = { v59 };
                        local v64 = workspace:FindPartOnRayWithWhitelist(Ray_new(v49, v60 - v49), v63, true);
                        v53 = (v60 - v58).Magnitude;

                        if v64 and not v61 then
                            local v65;

                            if p46 then
                                v65 = workspace:FindPartOnRayWithWhitelist(Ray_new(p46, v49 - p46), v63, true) or workspace:FindPartOnRayWithWhitelist(Ray_new(v49, p46 - v49), v63, true);
                            else
                                v65 = false;
                            end;

                            if v65 then
                                v51 = v53;
                                v53 = v50;
                            elseif v48 >= v50 then
                                v53 = v50;
                            end;
                        else
                            v51 = v53;
                            v53 = v50;
                        end;
                    else
                        v53 = v50;
                    end;

                    u19[#u19 + 1] = v59;
                    p43 = v60 - p44 * 0.001;
                else
                    v53 = v50;
                end;
            end;

            if v51 < (1 / 0) or not v59 then
                break;
            end;

            v50 = v53;
        end;

        local v66 = u19;

        for i = #v66, v47 + 1, -1 do
            v66[i] = nil;
            local _ = i;
        end;
    end;

    debug.profileend();

    return v53 - u9, v51 - u9;
end;

local function queryViewport(p67, p68) -- Line: 377
    -- upvalues: u2 (ref), UserFlag2 (copy), u1 (copy), u7 (ref), u8 (ref), u9 (ref), queryPoint (copy)
    debug.profilebegin("queryViewport");
    local p = p67.p;
    local rightVector = p67.rightVector;
    local upVector = p67.upVector;
    local v69 = -p67.lookVector;
    local v70;

    if UserFlag2 then
        v70 = u1:getCamera();
    else
        v70 = u2;
    end;

    u2 = v70;
    local ViewportSize = u2.ViewportSize;
    local v71 = (1 / 0);
    local v72 = (1 / 0);

    for i = 0, 1 do
        local v73 = rightVector * ((i - 0.5) * u7);
        local v74 = i;

        for i2 = 0, 1 do
            local v75, v76 = queryPoint(p + u9 * (v73 + upVector * ((i2 - 0.5) * u8)), v69, p68, u2:ViewportPointToRay(ViewportSize.x * v74, ViewportSize.y * i2).Origin);

            if v76 >= v71 then
                v76 = v71;
            end;

            local v77;

            if v75 < v72 then
                v77 = i2;
                v72 = v75;
                v71 = v76;
            else
                v77 = i2;
                v71 = v76;
            end;
        end;
    end;

    debug.profileend();

    return v72, v71;
end;

local function testPromotion(p78, p79, p80) -- Line: 417
    -- upvalues: getCollisionPoint (copy), math_min (copy), queryPoint (copy), u34 (copy)
    debug.profilebegin("testPromotion");
    local p = p78.p;
    local rightVector = p78.rightVector;
    local upVector = p78.upVector;
    local v81 = -p78.lookVector;
    debug.profilebegin("extrapolate");
    local Magnitude = (getCollisionPoint(p, p80.posVelocity * 1.25) - p).Magnitude;

    for i = 0, math_min(1.25, p80.rotVelocity.magnitude + Magnitude / p80.posVelocity.magnitude), 0.0625 do
        local v82 = p80.extrapolate(i);

        if p79 <= queryPoint(v82.p, -v82.lookVector, p79) then
            return false;
        end;

        local _ = i;
    end;

    debug.profileend();
    debug.profilebegin("testOffsets");

    for _, v in ipairs(u34) do
        local v83 = getCollisionPoint(p, rightVector * v.x + upVector * v.y);

        if queryPoint(v83, (p + v81 * p79 - v83).Unit, p79) == (1 / 0) then
            return false;
        end;
    end;

    debug.profileend();
    debug.profileend();

    return true;
end;

return function(p84, p85, p86) -- Line: 466, Name: Popper
    -- upvalues: u30 (ref), u31 (ref), queryViewport (copy), testPromotion (copy)
    debug.profilebegin("popper");
    u30 = u31 and u31:GetRootPart() or u31;
    local v87, v88 = queryViewport(p84, p85);

    if v88 >= p85 then
        v88 = p85;
    end;

    if v87 < v88 then
        if not testPromotion(p84, p85, p86) then
            v87 = v88;
        end;
    else
        v87 = v88;
    end;

    u30 = nil;
    debug.profileend();

    return v87;
end;