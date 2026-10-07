-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.Invisicam
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.Invisicam
-- Decompile time: 15.40 ms

local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserRaycastUpdateAPI = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI")
local u21 = {
    LIMBS = 2,
    MOVEMENT = 3,
    CORNERS = 4,
    CIRCLE1 = 5,
    CIRCLE2 = 6,
    LIMBMOVE = 7,
    SMART_CIRCLE = 8,
    CHAR_OUTLINE = 9,
}
local u22 = {
    Head = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true,
}
local u32 = {}
u32[1] = (Vector3.new(1, 1, -1))
u32[2] = (Vector3.new(1, -1, -1))
u32[3] = (Vector3.new(-1, -1, -1))
u32[4] = (Vector3.new(-1, 1, -1))
local u38 = RaycastParams.new()
u38.FilterType = Enum.RaycastFilterType.Exclude
local u41 = RaycastParams.new()
u41.FilterType = Enum.RaycastFilterType.Include

local function AssertTypes(a1, ...) -- Line: 74
    local v1 = {}
    local v2 = ""
    for k, v in pairs({...}) do
        v1[v] = true
        v2 = v2 .. (if v2 ~= "" then " or " else "") .. v
    end
    local v3 = type(a1)
    assert(v1[v3], v2 .. " type expected, got: " .. v3)
end

local function Det3x3(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 86
    -- upvalues: 
    return a1 * (a5 * a9 - a6 * a8) - a2 * (a4 * a9 - a6 * a7) + a3 * (a4 * a8 - a5 * a7)
end

local function RayIntersection(a1, a2, a3, a4) -- Line: 104 -- types: a1: vector, a2: vector, a3: vector, a4: vector
    local v1 = a2:Cross(a4)
    local v2 = a3.X - a1.X
    local v3 = a3.Y - a1.Y
    local v4 = a3.Z - a1.Z
    local X = a2.X
    local v5 = -a4.X
    local X_2 = v1.X
    local Y = a2.Y
    local v6 = -a4.Y
    local Y_2 = v1.Y
    local Z = a2.Z
    local v7 = -a4.Z
    local Z_2 = v1.Z
    local v8 = X * (v6 * Z_2 - Y_2 * v7) - v5 * (Y * Z_2 - Y_2 * Z) + X_2 * (Y * v7 - v6 * Z)
    if v8 == 0 then
        return (Vector3.new(0, 0, 0))
    end
    local v9 = -a4.X
    local X_3 = v1.X
    v6 = -a4.Y
    local Y_3 = v1.Y
    local v10 = -a4.Z
    local Z_3 = v1.Z
    local v11 = (v2 * (v6 * Z_3 - Y_3 * v10) - v9 * (v3 * Z_3 - Y_3 * v4) + X_3 * (v3 * v10 - v6 * v4)) / v8
    local X_4 = a2.X
    local X_5 = v1.X
    local Y_4 = a2.Y
    local Y_5 = v1.Y
    local Z_4 = a2.Z
    local Z_5 = v1.Z
    v5 = (X_4 * (v3 * Z_5 - Y_5 * v4) - v2 * (Y_4 * Z_5 - Y_5 * Z_4) + X_5 * (Y_4 * v4 - v3 * Z_4)) / v8
    v9 = a1 + v11 * a2
    local v12 = a3 + v5 * a4
    v6 = v9 + (v12 - v9) * 0.5
    if (v12 - v9).Magnitude < 0.25 then
        return v6
    end
    return (Vector3.new(0, 0, 0))
end

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local u57 = setmetatable({}, BaseOcclusion)
u57.__index = u57

function u57.new() -- Line: 136 -- upvalues: BaseOcclusion (val), u57 (val), u21 (val)
    local v1 = BaseOcclusion.new()
    local v2 = setmetatable(v1, u57)
    v2.char = nil
    v2.humanoidRootPart = nil
    v2.torsoPart = nil
    v2.headPart = nil
    v2.childAddedConn = nil
    v2.childRemovedConn = nil
    v2.ancestryChangedConn = nil
    v2.behaviors = {}
    v2.behaviors[u21.LIMBS] = v2.LimbBehavior
    v2.behaviors[u21.MOVEMENT] = v2.MoveBehavior
    v2.behaviors[u21.CORNERS] = v2.CornerBehavior
    v2.behaviors[u21.CIRCLE1] = v2.CircleBehavior
    v2.behaviors[u21.CIRCLE2] = v2.CircleBehavior
    v2.behaviors[u21.LIMBMOVE] = v2.LimbMoveBehavior
    v2.behaviors[u21.SMART_CIRCLE] = v2.SmartCircleBehavior
    v2.behaviors[u21.CHAR_OUTLINE] = v2.CharacterOutlineBehavior
    v2.mode = u21.SMART_CIRCLE
    v2.behaviorFunction = v2.SmartCircleBehavior
    v2.savedHits = {}
    v2.trackedLimbs = {}
    v2.camera = workspace.CurrentCamera
    v2.enabled = false
    return v2
end

function u57.Enable(a1, a2) -- Line: 170
    a1.enabled = a2
    if not a2 then
        a1:Cleanup()
        if a1.ancestryChangedConn then
            a1.ancestryChangedConn:Disconnect()
            a1.ancestryChangedConn = nil
        end
    end
end

function u57.GetOcclusionMode(a1) -- Line: 182
    return Enum.DevCameraOcclusionMode.Invisicam
end

function u57:LimbBehavior(a2) -- Line: 188
    for k, v in pairs(self.trackedLimbs) do
        a2[#a2 + 1] = k.Position
    end
end

function u57:MoveBehavior(a2) -- Line: 194
    local Position, Velocity, v1, v2
    for i = 1, 3 do
        Position = self.humanoidRootPart.Position
        Velocity = self.humanoidRootPart.Velocity
        v1 = (Vector3.new(Velocity.X, 0, Velocity.Z)).Magnitude / 2
        v2 = (i - 1) * self.humanoidRootPart.CFrame.lookVector * v1
        a2[#a2 + 1] = Position + v2
    end
end

function u57.CornerBehavior(a1, a2) -- Line: 203 -- upvalues: u32 (val)
    local CFrame = a1.humanoidRootPart.CFrame
    local Position = CFrame.Position
    local v1 = CFrame - Position
    local v2 = a1.char:GetExtentsSize() / 2
    a2[#a2 + 1] = Position
    local v3 = #u32
    for i = 1, v3 do
        a2[#a2 + 1] = Position + v1 * (v2 * u32[i])
    end
end

function u57.CircleBehavior(a1, a2) -- Line: 214 -- upvalues: u21 (val)
    local CFrame, v1, v2
    if a1.mode ~= u21.CIRCLE1 then
        local CoordinateFrame = a1.camera.CoordinateFrame
        CFrame = CoordinateFrame - CoordinateFrame.Position + a1.humanoidRootPart.Position
    else
        CFrame = a1.humanoidRootPart.CFrame
    end
    a2[#a2 + 1] = CFrame.Position
    for i = 0, 9 do
        v1 = 0.6283185307179586 * i
        v2 = Vector3.new(math.cos(v1), math.sin(v1), 0) * 3
        a2[#a2 + 1] = CFrame * v2
    end
end

function u57.LimbMoveBehavior(a1, a2) -- Line: 230
    a1:LimbBehavior(a2)
    a1:MoveBehavior(a2)
end

function u57.CharacterOutlineBehavior(a1, a2) -- Line: 235 -- upvalues: UserRaycastUpdateAPI (val), u41 (val)
    local Position_2, v1, v2, v3, v4, v5
    local unit = a1.torsoPart.CFrame.upVector.unit
    local unit_2 = a1.torsoPart.CFrame.rightVector.unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit_2
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit_2
    if a1.headPart then
        a2[#a2 + 1] = a1.headPart.CFrame.p
    end
    local new = CFrame.new
    local X = a1.camera.CoordinateFrame.lookVector.X
    local Z = a1.camera.CoordinateFrame.lookVector.Z
    local v6 = new(Vector3.new(0, 0, 0), (Vector3.new(X, 0, Z)))
    local Position = a1.torsoPart and a1.torsoPart.Position or a1.humanoidRootPart.Position
    local v7 = {a1.torsoPart}
    if a1.headPart then
        v7[#v7 + 1] = a1.headPart
    end
    local v8 = a2
    for i = 1, 24 do
        v1 = 6.283185307179586 * i / 24
        v2 = v6 * (Vector3.new(math.cos(v1), math.sin(v1), 0) * 3)
        v2 = Vector3.new(v2.X, math.max(v2.Y, -2.25), v2.Z)
        if not UserRaycastUpdateAPI then
            v3 = Ray.new(Position + v2, -3 * v2)
            v4, v5 = workspace:FindPartOnRayWithWhitelist(v3, v7, false)
            if v4 then
                v8[#v8 + 1] = v5 + 0.2 * (Position - v5).unit
            end
        else
            u41.FilterDescendantsInstances = v7
            v3 = workspace:Raycast(Position + v2, -3 * v2, u41)
            if v3 then
                Position_2 = v3.Position
                v8[#v8 + 1] = Position_2 + 0.2 * (Position - Position_2).unit
            end
        end
    end
end

function u57.SmartCircleBehavior(a1, a2) -- Line: 289
    -- upvalues: UserRaycastUpdateAPI (val), u38 (val), RayIntersection (val)
    local Normal, Position_2, unit_3, unit_4, unit_6, unit_7, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    local unit = a1.torsoPart.CFrame.upVector.unit
    local unit_2 = a1.torsoPart.CFrame.rightVector.unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit_2
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit_2
    if a1.headPart then
        a2[#a2 + 1] = a1.headPart.CFrame.p
    end
    local v15 = a1.camera.CFrame - a1.camera.CFrame.p
    local v16 = Vector3.new(0, 0.5, 0)
    local Position = a1.torsoPart and a1.torsoPart.Position or a1.humanoidRootPart.Position
    local v17 = v16 + Position
    local v18, v19 = a1, a2
    for i = 1, 24 do
        v14 = 0.2617993877991494 * i - 1.5707963267948966
        v1 = v17 + v15 * (Vector3.new(math.cos(v14), math.sin(v14), 0) * 2.5)
        v2 = v1 - v18.camera.CFrame.p
        if not UserRaycastUpdateAPI then
            v3 = Ray.new(v17, v1 - v17)
            v4, v5, v6 = workspace:FindPartOnRayWithIgnoreList(v3, {v18.char}, false, false)
            v7 = v1
            if v4 then
                v8 = v5 + 0.1 * v6.unit
                v9 = v8 - v17
                unit_6 = v9:Cross(v2).unit:Cross(v6).unit
                unit_7 = (v8 - v18.camera.CFrame.p).unit
                v10 = v9.unit:Dot(-unit_6)
                if not (v10 < v9.unit:Dot(unit_7)) then
                    v7 = v8
                else
                    v7 = RayIntersection(v8, unit_6, v1, v2)
                    if not (0 < v7.Magnitude) then
                        v7 = v8
                    else
                        v10 = Ray.new(v8, v7 - v8)
                        v11, v12, v13 = workspace:FindPartOnRayWithIgnoreList(v10, {v18.char}, false, false)
                        if v11 then
                            v7 = v12 + 0.1 * v13.unit
                        end
                    end
                end
                v10 = Ray.new(v17, v7 - v17)
                v11, v12 = workspace:FindPartOnRayWithIgnoreList(v10, {v18.char}, false, false)
                if v11 then
                    v7 = v12 - 0.1 * (v7 - v17).unit
                end
            end
            v19[#v19 + 1] = v7
        else
            u38.FilterDescendantsInstances = {v18.char}
            v3 = workspace:Raycast(v17, v1 - v17, u38)
            v4 = v1
            if v3 then
                Position_2 = v3.Position
                Normal = v3.Normal
                v7 = Position_2 + 0.1 * Normal.unit
                v8 = v7 - v17
                unit_3 = v8:Cross(v2).unit:Cross(Normal).unit
                unit_4 = (v7 - v18.camera.CFrame.p).unit
                if not ((v8.unit:Dot(-unit_3)) < v8.unit:Dot(unit_4)) then
                    v4 = v7
                else
                    v4 = RayIntersection(v7, unit_3, v1, v2)
                    if not (0 < v4.Magnitude) then
                        v4 = v7
                    else
                        v3 = workspace:Raycast(v7, v4 - v7, u38)
                        if v3 then
                            v4 = v3.Position + 0.1 * v3.Normal.Unit
                        end
                    end
                end
                v3 = workspace:Raycast(v17, v4 - v17, u38)
                if v3 then
                    v4 = v3.Position - 0.1 * (v4 - v17).unit
                end
            end
            v19[#v19 + 1] = v4
        end
    end
end

function u57:CheckTorsoReference() -- Line: 425
    if self.char then
        self.torsoPart = self.char:FindFirstChild("Torso")
        if not self.torsoPart then
            self.torsoPart = self.char:FindFirstChild("UpperTorso")
            if not self.torsoPart then
                self.torsoPart = self.char:FindFirstChild("HumanoidRootPart")
            end
        end
        self.headPart = self.char:FindFirstChild("Head")
    end
end

function u57.CharacterAdded(a1, a2, a3) -- Line: 439
    -- upvalues: Players (val), u22 (val)
    if a3 ~= Players.LocalPlayer then
        return
    end
    if a1.childAddedConn then
        a1.childAddedConn:Disconnect()
        a1.childAddedConn = nil
    end
    if a1.childRemovedConn then
        a1.childRemovedConn:Disconnect()
        a1.childRemovedConn = nil
    end
    if a1.ancestryChangedConn then
        a1.ancestryChangedConn:Disconnect()
        a1.ancestryChangedConn = nil
    end
    a1.char = a2
    a1.trackedLimbs = {}
    a1.childAddedConn = a2.ChildAdded:Connect(function(a1_2) -- Line: 461 -- upvalues: u22 (upval), a1 (val)
        if a1_2:IsA("BasePart") then
            if u22[a1_2.Name] then
                a1.trackedLimbs[a1_2] = true
            end
            if a1_2.Name == "Torso" or a1_2.Name == "UpperTorso" then
                a1.torsoPart = a1_2
            end
            if a1_2.Name == "Head" then
                a1.headPart = a1_2
            end
        end
    end)
    a1.childRemovedConn = a2.ChildRemoved:Connect(function(a1_2) -- Line: 477 -- upvalues: a1 (val)
        a1.trackedLimbs[a1_2] = nil
        a1:CheckTorsoReference()
    end)
    for k, v in pairs(a1.char:GetChildren()) do
        if v:IsA("BasePart") then
            if u22[v.Name] then
                a1.trackedLimbs[v] = true
            end
            if v.Name == "Torso" or v.Name == "UpperTorso" then
                a1.torsoPart = v
            end
            if v.Name == "Head" then
                a1.headPart = v
            end
        end
    end
end

function u57.SetMode(a1, a2) -- Line: 491 -- upvalues: AssertTypes (val), u21 (val) -- types: a1: table, a2: number
    AssertTypes(a2, "number")
    for k, v in pairs(u21) do
        if v == a2 then
            a1.mode = a2
            a1.behaviorFunction = a1.behaviors[a1.mode]
            return
        end
    end
    error("Invalid mode number")
end

function u57.GetObscuredParts(a1) -- Line: 503
    return a1.savedHits
end

function u57:Cleanup() -- Line: 508
    for k, v in pairs(self.savedHits) do
        k.LocalTransparencyModifier = v
    end
end

function u57.Update(a1, a2, a3, a4) -- Line: 514 -- types: a1: table, a2: number, a3: userdata, a4: userdata
    if a1.enabled and a1.char then
        local add, p, p_2, u433, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
        a1.camera = workspace.CurrentCamera
        if not a1.humanoidRootPart then
            local Humanoid = a1.char:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.RootPart then
                a1.humanoidRootPart = Humanoid.RootPart
                if a1.ancestryChangedConn then
                    a1.ancestryChangedConn:Disconnect()
                    a1.ancestryChangedConn = nil
                end
                a1.ancestryChangedConn = a1.humanoidRootPart.AncestryChanged:Connect(function(a1_2, a2) -- Line: 544 -- upvalues: a1 (val)
                    if a1_2 == a1.humanoidRootPart and not a2 then
                        a1.humanoidRootPart = nil
                        if a1.ancestryChangedConn and a1.ancestryChangedConn.Connected then
                            a1.ancestryChangedConn:Disconnect()
                            a1.ancestryChangedConn = nil
                        end
                    end
                end)
                if not a1.torsoPart then
                    a1:CheckTorsoReference()
                    if not a1.torsoPart then
                        return a3, a4
                    end
                end
                v10 = {}
                a1.behaviorFunction(a1, v10)
                u433 = {}
                v11 = {a1.char}

                function add(a1_2) -- Line: 570 -- upvalues: u433 (val), a1 (val)
                    u433[a1_2] = true
                    if not a1.savedHits[a1_2] then
                        a1.savedHits[a1_2] = a1_2.LocalTransparencyModifier
                    end
                end

                v13 = 0
                v1 = {}
                v2 = 0.75
                v3 = 0.75
                p = a1.headPart and a1.headPart.CFrame.p or v10[1]
                p_2 = a1.torsoPart and a1.torsoPart.CFrame.p or v10[2]
                v7 = {p, p_2}
                v12 = a1.camera:GetPartsObscuringTarget(v7, v11)
                v6 = #v12
                for i = 1, v6 do
                    v8 = v12[i]
                    v13 = v13 + 1
                    v1[v8] = true
                    for k, v in pairs(v8:GetChildren()) do
                        if not v:IsA("Decal") and not v:IsA("Texture") then
                            continue
                        end
                        v13 = v13 + 1
                        break
                    end
                end
                if v13 > 0 then
                    v2 = math.pow(0.375 / v13 + 0.375, 1 / v13)
                    v3 = math.pow(0.25 / v13 + 0.25, 1 / v13)
                end
                v12 = a1.camera:GetPartsObscuringTarget(v10, v11)
                v4 = {}
                v5 = #v12
                for j = 1, v5 do
                    v7 = v12[j]
                    v4[v7] = v1[v7] and v2 or v3
                    if v7.Transparency < v4[v7] then
                        u433[v7] = true
                        if not a1.savedHits[v7] then
                            a1.savedHits[v7] = v7.LocalTransparencyModifier
                        end
                    end
                    for k2, k3 in pairs(v7:GetChildren()) do
                        if k3:IsA("Decal") then
                            if k3.Transparency < v4[v7] then
                                v4[k3] = v4[v7]
                                u433[k3] = true
                                if not a1.savedHits[k3] then
                                    a1.savedHits[k3] = k3.LocalTransparencyModifier
                                end
                            end
                        elseif k3:IsA("Texture") and k3.Transparency < v4[v7] then
                            v4[k3] = v4[v7]
                            u433[k3] = true
                            if not a1.savedHits[k3] then
                                a1.savedHits[k3] = k3.LocalTransparencyModifier
                            end
                        end
                    end
                end
                for k4, n in pairs(a1.savedHits) do
                    if not u433[k4] then
                        k4.LocalTransparencyModifier = n
                        a1.savedHits[k4] = nil
                    else
                        v9 = k4.Transparency < 1 and (v4[k4] - k4.Transparency) / (1 - k4.Transparency) or 0
                        k4.LocalTransparencyModifier = v9
                    end
                end
                return a3, a4
            end
            a1.humanoidRootPart = a1.char:FindFirstChild("HumanoidRootPart")
            if not a1.humanoidRootPart then
                return a3, a4
            end
            if a1.ancestryChangedConn then
                a1.ancestryChangedConn:Disconnect()
                a1.ancestryChangedConn = nil
            end
            a1.ancestryChangedConn = a1.humanoidRootPart.AncestryChanged:Connect(function(a1_2, a2) -- Line: 544 -- upvalues: a1 (val)
                if a1_2 == a1.humanoidRootPart and not a2 then
                    a1.humanoidRootPart = nil
                    if a1.ancestryChangedConn and a1.ancestryChangedConn.Connected then
                        a1.ancestryChangedConn:Disconnect()
                        a1.ancestryChangedConn = nil
                    end
                end
            end)
        end
        if not a1.torsoPart then
            a1:CheckTorsoReference()
            if not a1.torsoPart then
                return a3, a4
            end
        end
        v10 = {}
        a1.behaviorFunction(a1, v10)
        u433 = {}
        v11 = {}
        v11[1] = a1.char

        function add(a1_2) -- Line: 570 -- upvalues: u433 (val), a1 (val)
            u433[a1_2] = true
            if not a1.savedHits[a1_2] then
                a1.savedHits[a1_2] = a1_2.LocalTransparencyModifier
            end
        end

        v13 = 0
        v1 = {}
        v2 = 0.75
        v3 = 0.75
        p = a1.headPart and a1.headPart.CFrame.p or v10[1]
        p_2 = a1.torsoPart and a1.torsoPart.CFrame.p or v10[2]
        v7 = {p, p_2}
        v12 = a1.camera:GetPartsObscuringTarget(v7, v11)
        v6 = #v12
        for m = 1, v6 do
            v8 = v12[m]
            v13 = v13 + 1
            v1[v8] = true
            for k5, i5 in pairs(v8:GetChildren()) do
                if not i5:IsA("Decal") and not i5:IsA("Texture") then
                    continue
                end
                v13 = v13 + 1
                break
            end
        end
        if v13 > 0 then
            v2 = math.pow(0.375 / v13 + 0.375, 1 / v13)
            v3 = math.pow(0.25 / v13 + 0.25, 1 / v13)
        end
        v12 = a1.camera:GetPartsObscuringTarget(v10, v11)
        v4 = {}
        v5 = #v12
        for i6 = 1, v5 do
            v7 = v12[i6]
            v4[v7] = v1[v7] and v2 or v3
            if v7.Transparency < v4[v7] then
                u433[v7] = true
                if not a1.savedHits[v7] then
                    a1.savedHits[v7] = v7.LocalTransparencyModifier
                end
            end
            for k6, i7 in pairs(v7:GetChildren()) do
                if i7:IsA("Decal") then
                    if i7.Transparency < v4[v7] then
                        v4[i7] = v4[v7]
                        u433[i7] = true
                        if not a1.savedHits[i7] then
                            a1.savedHits[i7] = i7.LocalTransparencyModifier
                        end
                    end
                elseif i7:IsA("Texture") and i7.Transparency < v4[v7] then
                    v4[i7] = v4[v7]
                    u433[i7] = true
                    if not a1.savedHits[i7] then
                        a1.savedHits[i7] = i7.LocalTransparencyModifier
                    end
                end
            end
        end
        for k7, i8 in pairs(a1.savedHits) do
            if not u433[k7] then
                k7.LocalTransparencyModifier = i8
                a1.savedHits[k7] = nil
            else
                v9 = k7.Transparency < 1 and (v4[k7] - k7.Transparency) / (1 - k7.Transparency) or 0
                k7.LocalTransparencyModifier = v9
            end
        end
        return a3, a4
    end
    return a3, a4
end

return u57