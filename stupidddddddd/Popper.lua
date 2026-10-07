-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
-- Decompile time: 9.64 ms

local NearPlaneZ, v1
local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraWrapper = require(CommonUtils:WaitForChild("CameraWrapper"))
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local UserRaycastUpdateAPI = FlagUtil.getUserFlag("UserRaycastUpdateAPI")
local UserCurrentCameraUpdate2 = FlagUtil.getUserFlag("UserCurrentCameraUpdate2")
local UserPlayerConnectionMemoryLeak = FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")
local u42 = if not UserCurrentCameraUpdate2 then nil else CameraWrapper.new()
local CurrentCamera = if not UserCurrentCameraUpdate2 then workspace.CurrentCamera else nil
if UserCurrentCameraUpdate2 then
    u42:Enable()
end
local min = math.min
local tan = math.tan
local rad = math.rad
local new = Ray.new
local u58 = RaycastParams.new()
u58.IgnoreWater = true
u58.FilterType = Enum.RaycastFilterType.Exclude
local u62 = RaycastParams.new()
u62.IgnoreWater = true
u62.FilterType = Enum.RaycastFilterType.Include
local u73 = if not UserPlayerConnectionMemoryLeak then nil else ConnectionUtil.new()

local function getTotalTransparency(a1) -- Line: 42
    return 1 - (1 - a1.Transparency) * (1 - a1.LocalTransparencyModifier)
end

local function eraseFromEnd(a1, a2) -- Line: 46
    local v1 = #a1
    local v2 = a2 + 1
    for i = v1, v2, -1 do
        a1[i] = nil
    end
end

local u77 = nil
local u78 = nil
if not UserCurrentCameraUpdate2 then
    local function updateProjection_2() -- Line: 78
        -- upvalues: CurrentCamera (ref), rad (val), u78 (ref), tan (val), u77 (ref)
        local v1 = rad(CurrentCamera.FieldOfView)
        local ViewportSize = CurrentCamera.ViewportSize
        local v2 = ViewportSize.X / ViewportSize.Y
        u78 = tan(v1 / 2) * 2
        u77 = v2 * u78
    end

    ;(CurrentCamera:GetPropertyChangedSignal("FieldOfView")):Connect(updateProjection_2)
    ;(CurrentCamera:GetPropertyChangedSignal("ViewportSize")):Connect(updateProjection_2)
    v1 = rad(CurrentCamera.FieldOfView)
    local ViewportSize_2 = CurrentCamera.ViewportSize
    local v2 = ViewportSize_2.X / ViewportSize_2.Y
    u78 = tan(v1 / 2) * 2
    u77 = v2 * u78
    NearPlaneZ = CurrentCamera.NearPlaneZ
    ;(CurrentCamera:GetPropertyChangedSignal("NearPlaneZ")):Connect(function() -- Line: 92 -- upvalues: NearPlaneZ (ref), CurrentCamera (ref)
        NearPlaneZ = CurrentCamera.NearPlaneZ
    end)
else
    local function updateProjection() -- Line: 56 -- upvalues: u42 (val), rad (val), u78 (ref), tan (val), u77 (ref)
        local v1 = u42:getCamera()
        local v2 = rad(v1.FieldOfView)
        local ViewportSize = v1.ViewportSize
        local v3 = ViewportSize.X / ViewportSize.Y
        u78 = tan(v2 / 2) * 2
        u77 = v3 * u78
    end

    u42:Connect("FieldOfView", updateProjection)
    u42:Connect("ViewportSize", updateProjection)
    v1 = u42:getCamera()
    local v3 = rad(v1.FieldOfView)
    local ViewportSize = v1.ViewportSize
    local v4 = ViewportSize.X / ViewportSize.Y
    u78 = tan(v3 / 2) * 2
    u77 = v4 * u78
    NearPlaneZ = u42:getCamera().NearPlaneZ
    u42:Connect("NearPlaneZ", function() -- Line: 72 -- upvalues: NearPlaneZ (ref), u42 (val)
        NearPlaneZ = u42:getCamera().NearPlaneZ
    end)
end
local u161 = {}
local u162 = {}

local function refreshIgnoreList() -- Line: 102 -- upvalues: u161 (ref), u162 (val)
    local v1 = 1
    u161 = {}
    for k, v in pairs(u162) do
        u161[v1] = v
        v1 = v1 + 1
    end
end

local function playerAdded(a1) -- Line: 111
    -- upvalues: u162 (val), u161 (ref), UserPlayerConnectionMemoryLeak (val), u73 (val)
    local function characterAdded(a1_2) -- Line: 112 -- upvalues: u162 (upval), a1 (val), u161 (upval)
        u162[a1] = a1_2
        local v1 = 1
        u161 = {}
        for k, v in pairs(u162) do
            u161[v1] = v
            v1 = v1 + 1
        end
    end

    local function characterRemoving() -- Line: 116 -- upvalues: u162 (upval), a1 (val), u161 (upval)
        u162[a1] = nil
        local v1 = 1
        u161 = {}
        for k, v in pairs(u162) do
            u161[v1] = v
            v1 = v1 + 1
        end
    end

    if not UserPlayerConnectionMemoryLeak then
        a1.CharacterAdded:Connect(characterAdded)
        a1.CharacterRemoving:Connect(characterRemoving)
    else
        u73:trackConnection(("%*CharacterAdded"):format(a1.UserId), (a1.CharacterAdded:Connect(characterAdded)))
        u73:trackConnection(("%*CharacterRemoving"):format(a1.UserId), (a1.CharacterRemoving:Connect(characterRemoving)))
    end
    if a1.Character then
        u162[a1] = a1.Character
        local v1 = 1
        u161 = {}
        for k, v in pairs(u162) do
            u161[v1] = v
            v1 = v1 + 1
        end
    end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(function(a1) -- Line: 140 -- upvalues: u162 (val), u161 (ref), UserPlayerConnectionMemoryLeak (val), u73 (val)
    u162[a1] = nil
    local v1 = 1
    u161 = {}
    for k, v in pairs(u162) do
        u161[v1] = v
        v1 = v1 + 1
    end
    if UserPlayerConnectionMemoryLeak then
        u73:disconnect((("%*CharacterAdded"):format(a1.UserId)))
        u73:disconnect((("%*CharacterRemoving"):format(a1.UserId)))
    end
end)
for i, v in ipairs(Players:GetPlayers()) do
    playerAdded(v)
end
local v5 = 1
u161 = {}
for k, i2 in pairs(u162) do
    u161[v5] = i2
    v5 = v5 + 1
end
local u214 = nil
local u215 = nil
if not UserCurrentCameraUpdate2 then
    (CurrentCamera:GetPropertyChangedSignal("CameraSubject")):Connect(function() -- Line: 191 -- upvalues: CurrentCamera (ref), u215 (ref)
        local CameraSubject = CurrentCamera.CameraSubject
        if CameraSubject:IsA("Humanoid") then
            u215 = CameraSubject.RootPart
            return
        end
        if CameraSubject:IsA("BasePart") then
            u215 = CameraSubject
            return
        end
        u215 = nil
    end)
else
    u42:Connect("CameraSubject", function() -- Line: 180 -- upvalues: u42 (val), u215 (ref)
        local CameraSubject = u42:getCamera().CameraSubject
        if CameraSubject and CameraSubject:IsA("Humanoid") then
            u215 = CameraSubject.RootPart
            return
        end
        if CameraSubject and CameraSubject:IsA("BasePart") then
            u215 = CameraSubject
            return
        end
        u215 = nil
    end)
end

local function canOcclude(a1) -- Line: 203 -- upvalues: u214 (ref)
    local CanCollide = false
    if 1 - (1 - a1.Transparency) * (1 - a1.LocalTransparencyModifier) < 0.25 then
        CanCollide = a1.CanCollide
        if CanCollide then
            CanCollide = false
            if u214 ~= (a1:GetRootPart() or a1) then
                CanCollide = not a1:IsA("TrussPart")
            end
        end
    end
    return CanCollide
end

local u234 = {}
v5 = Vector2.new(0.4, 0)
local v6 = Vector2.new(-0.4, 0)
local v7 = Vector2.new(0, -0.4)
local v8 = Vector2.new(0, 0.4)
u234[1] = v5
u234[2] = v6
u234[3] = v7
u234[4] = v8
u234[5] = Vector2.new(0, 0.2)

local function getCollisionPoint(a1, a2) -- Line: 230
    -- upvalues: UserRaycastUpdateAPI (val), u58 (val), u161 (ref), new (val)
    local v1, v2, v3
    if not UserRaycastUpdateAPI then
        local v4, v5, v6, v7, v8
        v3 = #u161
        v1, v2 = a1, a2
        while true do
            v4, v5 = workspace:FindPartOnRayWithIgnoreList(new(v1, v2), u161, false, true)
            if v4 then
                if v4.CanCollide then
                    v6 = u161
                    v8 = #v6
                    v7 = v3 + 1
                    for k = v8, v7, -1 do
                        v6[k] = nil
                    end
                    return v5, true
                end
                u161[#u161 + 1] = v4
                if not v4 then
                    v4 = u161
                    v7 = #v4
                    v5 = v3 + 1
                    for j = v7, v5, -1 do
                        v4[j] = nil
                    end
                    return v1 + v2, false
                end
            elseif not v4 then
                v4 = u161
                v7 = #v4
                v5 = v3 + 1
                for i = v7, v5, -1 do
                    v4[i] = nil
                end
                return v1 + v2, false
            end
        end
    else
        u58.FilterDescendantsInstances = u161
        v1, v2 = a1, a2
        while true do
            v3 = workspace:Raycast(v1, v2, u58)
            if v3 then
                if v3.Instance.CanCollide then
                    return v3.Position, true
                end
                u58:AddToFilter(v3.Instance)
            end
            if not v3 then
                return v1 + v2, false
            end
        end
    end
end

local function queryPoint(a1, a2, a3, a4) -- Line: 266
    -- upvalues: u161 (ref), NearPlaneZ (ref), UserRaycastUpdateAPI (val), u58 (val), u214 (ref), u62 (val), new (val)
    local v1, v2, v3, v4
    debug.profilebegin("queryPoint")
    local v5 = #u161
    local v6 = a3 + NearPlaneZ
    local v7 = a1 + a2 * v6
    local v8 = (1 / 0)
    local v9 = (1 / 0)
    local v10 = a1
    local v11 = 0
    if not UserRaycastUpdateAPI then
        local CanCollide_2, Magnitude_2, v12, v13, v14, v15, v16
        v1, v4, v2 = a1, a4, a2
        repeat
            v3, v12 = workspace:FindPartOnRayWithIgnoreList(new(v10, v7 - v10), u161, false, true)
            v11 = v11 + 1
            if v3 then
                v13 = v11 >= 64
                CanCollide_2 = false
                if 1 - (1 - v3.Transparency) * (1 - v3.LocalTransparencyModifier) < 0.25 then
                    CanCollide_2 = v3.CanCollide
                    if CanCollide_2 then
                        CanCollide_2 = false
                        if u214 ~= (v3:GetRootPart() or v3) then
                            CanCollide_2 = not v3:IsA("TrussPart")
                        end
                    end
                end
                if CanCollide_2 or v13 then
                    v14 = {v3}
                    v15 = workspace:FindPartOnRayWithWhitelist(new(v7, v12 - v7), v14, true)
                    Magnitude_2 = (v12 - v1).Magnitude
                    if not v15 or v13 then
                        v9 = Magnitude_2
                    else
                        v16 = false
                        if v4 then
                            v16 = workspace:FindPartOnRayWithWhitelist(new(v4, v7 - v4), v14, true) or workspace:FindPartOnRayWithWhitelist(new(v7, v4 - v7), v14, true)
                        end
                        if v16 then
                            v9 = Magnitude_2
                        elseif v6 < v8 then
                            v8 = Magnitude_2
                        end
                    end
                end
                u161[#u161 + 1] = v3
                v10 = v12 - v2 * 0.001
            end
        until v9 < (1 / 0) or not v3
        v3 = u161
        v14 = #v3
        v12 = v5 + 1
        for i = v14, v12, -1 do
            v3[i] = nil
        end
    else
        local CanCollide, Instance, Magnitude, Position
        u58.FilterDescendantsInstances = u161
        v1, v4, v2 = a1, a4, a2
        repeat
            v3 = workspace:Raycast(v10, v7 - v10, u58)
            if not v3 then
                break
            end
            v11 = v11 + 1
            Instance = v3.Instance
            Position = v3.Position
            Magnitude = (Position - v1).Magnitude
            if not (v11 >= 64) then
                CanCollide = false
                if 1 - (1 - Instance.Transparency) * (1 - Instance.LocalTransparencyModifier) < 0.25 then
                    CanCollide = Instance.CanCollide
                    if CanCollide then
                        CanCollide = false
                        if u214 ~= (Instance:GetRootPart() or Instance) then
                            CanCollide = not Instance:IsA("TrussPart")
                        end
                    end
                end
                if CanCollide then
                    u62.FilterDescendantsInstances = {Instance}
                    if not workspace:Raycast(v7, Position - v7, u62)
                        or (if not v4 then false else workspace:Raycast(v4, v7 - v4, u62) or workspace:Raycast(v7, v4 - v7, u62)) then
                        v9 = Magnitude
                    elseif v6 < v8 then
                        v8 = Magnitude
                    end
                end
            else
                v9 = Magnitude
            end
            u58:AddToFilter(Instance)
            v10 = Position - v2 * 0.001
        until v9 < (1 / 0) or not Instance
    end
    debug.profileend()
    return v8 - NearPlaneZ, v9 - NearPlaneZ
end

local function queryViewport(a1, a2) -- Line: 377
    -- upvalues: CurrentCamera (ref), UserCurrentCameraUpdate2 (val), u42 (val), u77 (ref), u78 (ref), NearPlaneZ (ref)
    -- upvalues: queryPoint (val)
    local v1, v2, v3, v4
    debug.profilebegin("queryViewport")
    local p = a1.p
    local rightVector = a1.rightVector
    local upVector = a1.upVector
    local v5 = -a1.lookVector
    CurrentCamera = if not UserCurrentCameraUpdate2 then CurrentCamera else u42:getCamera()
    local ViewportSize = CurrentCamera.ViewportSize
    local v6 = (1 / 0)
    local v7 = (1 / 0)
    for i = 0, 1 do
        v1 = rightVector * ((i - 0.5) * u77)
        for j = 0, 1 do
            v2 = upVector * ((j - 0.5) * u78)
            v3, v4 = queryPoint(
                p + NearPlaneZ * (v1 + v2),
                v5,
                a2,
                (CurrentCamera:ViewportPointToRay(ViewportSize.x * i, ViewportSize.y * j)).Origin
            )
            if v4 < v6 then
                v6 = v4
            end
            if v3 < v7 then
                v7 = v3
            end
        end
    end
    debug.profileend()
    return v7, v6
end

local function testPromotion(a1, a2, a3) -- Line: 417
    -- upvalues: getCollisionPoint (val), min (val), queryPoint (val), u234 (val)
    local v1
    debug.profilebegin("testPromotion")
    local p = a1.p
    local rightVector = a1.rightVector
    local upVector = a1.upVector
    local v2 = -a1.lookVector
    debug.profilebegin("extrapolate")
    for i = 0, (min(1.25, a3.rotVelocity.magnitude + ((getCollisionPoint(p, a3.posVelocity * 1.25)) - p).Magnitude / a3.posVelocity.magnitude)), 0.0625 do
        v1 = a3.extrapolate(i)
        if a2 <= queryPoint(v1.p, -v1.lookVector, a2) then
            return false
        end
    end
    debug.profileend()
    debug.profilebegin("testOffsets")
    for i2, v in ipairs(u234) do
        v1 = getCollisionPoint(p, rightVector * v.x + upVector * v.y)
        if queryPoint(v1, (p + v2 * a2 - v1).Unit, a2) == (1 / 0) then
            return false
        end
    end
    debug.profileend()
    debug.profileend()
    return true
end

return function(a1, a2, a3) -- Line: 466 -- upvalues: u214 (ref), u215 (ref), queryViewport (val), testPromotion (val)
    debug.profilebegin("popper")
    u214 = u215 and u215:GetRootPart() or u215
    local v1 = a2
    local v2, v3 = queryViewport(a1, a2)
    if v3 < v1 then
        v1 = v3
    end
    if v2 < v1 and testPromotion(a1, a2, a3) then
        v1 = v2
    end
    u214 = nil
    debug.profileend()
    return v1
end