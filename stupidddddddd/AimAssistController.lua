-- ReplicatedStorage.Controllers.AimAssistController
-- Script path: ReplicatedStorage.Controllers.AimAssistController
-- Decompile time: 16.23 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local v1 = GetUserPlatform()
local u57 = false
if table.find(v1, "Mobile") ~= nil then
    u57 = #v1 <= 1
end
local CurrentCamera = Workspace.CurrentCamera
local u60 = true
local u61 = true
local PLAYER = Constants.AIM_ASSIST_CONFIGS.PLAYER
local u65 = {["Counter-Terrorists"] = true, Terrorists = true}
local u68 = {
    AimHeight = 0.6,
    PullAngle = 0.17453292519943295,
    PullRate = 3.2,
    IdlePullShare = 0.25,
    MaxPullSpeed = 0.5235987755982988,
    SettleAngle = 0.002617993877991494,
    TrackingStrength = 0.55,
    TrackingAngle = 0.12217304763960307,
    MaxTrackingSpeed = 3,
    StickDeadzone = 0.15,
}
local u69 = nil
local u70 = (-1 / 0)
local u71 = nil
local u72 = nil
local u73 = 0
local u74 = 0

local function clipSlab(a1, a2, a3, a4, a5, a6) -- Line: 96
    -- upvalues: 
    if (math.abs(a2)) < 0.0001 then
        if not (a1 < a3) and not (a4 < a1) then
            return a5, a6
        end
        return nil, a6
    end
    local v1 = 1 / a2
    local v2 = (a3 - a1) * v1
    local v3 = (a4 - a1) * v1
    if v3 < v2 then
        local v4 = v3
        v3 = v2
        v2 = v4
    end
    local v5 = if not (a5 < v2) then a5 else v2
    local v6 = if not (v3 < a6) then a6 else v3
    if v6 < v5 then
        return nil, v6
    end
    return v5, v6
end

local function rayIntersectsAABB(a1, a2, a3, a4, a5) -- Line: 128
    -- upvalues: 
    local v1, v2, v3, v4, v5, v6, v7
    local X = a1.X
    local X_2 = a2.X
    local X_3 = a3.X
    local X_4 = a4.X
    local v8 = 0
    local v9 = a5
    local v10 = math.abs(X_2)
    if not (v10 < 0.0001) then
        v10 = 1 / X_2
        v1 = (X_3 - X) * v10
        v2 = (X_4 - X) * v10
        if v2 < v1 then
            v3 = v2
            v2 = v1
            v1 = v3
        end
        if v8 < v1 then
            v8 = v1
        end
        if v2 < v9 then
            v9 = v2
        end
        v6 = if not (v9 < v8) then v8 else nil
    else
        v6 = if X < X_3 then nil else if not (X_4 < X) then v8 else nil
    end
    if not v6 then
        return false
    end
    local Y = a1.Y
    local Y_2 = a2.Y
    local Y_3 = a3.Y
    local Y_4 = a4.Y
    v10 = v6
    v1 = v9
    v2 = math.abs(Y_2)
    if not (v2 < 0.0001) then
        v2 = 1 / Y_2
        v3 = (Y_3 - Y) * v2
        v4 = (Y_4 - Y) * v2
        if v4 < v3 then
            v5 = v4
            v4 = v3
            v3 = v5
        end
        if v10 < v3 then
            v10 = v3
        end
        if v4 < v1 then
            v1 = v4
        end
        v7 = if not (v1 < v10) then v10 else nil
    else
        v7 = if Y < Y_3 then nil else if not (Y_4 < Y) then v10 else nil
    end
    v6 = v7
    if not v6 then
        return false
    end
    local Z = a1.Z
    local Z_2 = a2.Z
    local Z_3 = a3.Z
    local Z_4 = a4.Z
    v10 = v6
    v1 = v1
    v2 = math.abs(Z_2)
    if not (v2 < 0.0001) then
        v2 = 1 / Z_2
        v3 = (Z_3 - Z) * v2
        v4 = (Z_4 - Z) * v2
        if v4 < v3 then
            v5 = v4
            v4 = v3
            v3 = v5
        end
        if v10 < v3 then
            v10 = v3
        end
        if v4 < v1 then
            v1 = v4
        end
        v7 = if not (v1 < v10) then v10 else nil
    else
        v7 = if Z < Z_3 then nil else if not (Z_4 < Z) then v10 else nil
    end
    v6 = v7
    v7 = false
    if v6 ~= nil then
        v7 = false
        if v6 >= 0 then
            v7 = v6 <= a5
        end
    end
    return v7
end

local function doesRaycastIntersectSmoke(a1, a2, a3) -- Line: 147
    -- upvalues: Workspace (val), rayIntersectsAABB (val)
    local Position, Size
    local Debris = Workspace:FindFirstChild("Debris")
    if not Debris then
        return false
    end
    local v1, v2, v3 = a1, a2, a3
    for i, v in ipairs(Debris:GetChildren()) do
        if v.Name:match("^VoxelSmoke_") and v:IsA("Folder") then
            for i2, i3 in ipairs(v:GetChildren()) do
                if i3:IsA("BasePart") and i3.Name == "SmokeVoxel" then
                    Size = i3.Size
                    Position = i3.Position
                    if rayIntersectsAABB(v1, v2, Position - Size / 2, Position + Size / 2, v3) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function isEnemyTeam(a1) -- Line: 171 -- upvalues: LocalPlayer (val), u65 (val)
    local Attribute = LocalPlayer:GetAttribute("Team")
    if u65[Attribute] and u65[a1] then
        local v1 = true
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            v1 = Attribute ~= a1
        end
        return v1
    end
    return false
end

local function isEnemyValid(a1) -- Line: 179 -- upvalues: LocalPlayer (val), u65 (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("Team")
    local Attribute_2 = LocalPlayer:GetAttribute("Team")
    if u65[Attribute_2] and u65[Attribute] then
        local v1 = true
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            v1 = Attribute_2 ~= Attribute
        end
        return v1
    end
    return false
end

local function isBotTarget(a1) -- Line: 188 -- upvalues: LocalPlayer (val), u65 (val) -- types: a1: userdata
    local v1 = a1:IsA("Model")
    if v1 then
        v1 = false
        if a1:GetAttribute("Bot") == true then
            v1 = false
            if a1:GetAttribute("Dead") ~= true then
                v1 = false
                if 0 < (tonumber((a1:GetAttribute("Health"))) or 1) then
                    v1 = false
                    if a1:GetAttribute("ClientCharacterPresentationVisible") ~= false then
                        v1 = false
                        if a1.PrimaryPart ~= nil then
                            local Attribute_2 = a1:GetAttribute("Team")
                            local Attribute_3 = LocalPlayer:GetAttribute("Team")
                            if u65[Attribute_3] and u65[Attribute_2] then
                                v1 = true
                                if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                                    v1 = Attribute_3 ~= Attribute_2
                                end
                                return v1
                            end
                            return false
                        end
                    end
                end
            end
        end
    end
    return v1
end

local function getTargetCandidates() -- Line: 199
    -- upvalues: Players (val), LocalPlayer (val), u65 (val), CharacterResolver (val), Workspace (val)
    -- upvalues: isBotTarget (val)
    local Attribute, Attribute_2, v1
    local v2 = {}
    for i, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            Attribute = v:GetAttribute("Team")
            Attribute_2 = LocalPlayer:GetAttribute("Team")
            if not u65[Attribute_2] then
                v1 = false
            elseif u65[Attribute] then
                v1 = true
                if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                    v1 = Attribute_2 ~= Attribute
                end
            else
                v1 = false
            end
            if v1 then
                v1 = CharacterResolver.getPlayerCharacter(v)
                if v1 and v1.PrimaryPart and CharacterResolver.isAliveCharacter(v1) then
                    table.insert(v2, v1)
                end
            end
        end
    end
    local Characters = Workspace:FindFirstChild("Characters")
    if Characters then
        for i2, i3 in ipairs(Characters:GetChildren()) do
            if isBotTarget(i3) then
                table.insert(v2, i3)
            end
        end
    end
    return v2
end

local function getLocalRaycastParams() -- Line: 226 -- upvalues: CharacterResolver (val), Workspace (val)
    local v1 = RaycastParams.new()
    v1.FilterType = Enum.RaycastFilterType.Exclude
    local v2 = {}
    local v3 = CharacterResolver.getLocalCharacter()
    if v3 then
        table.insert(v2, v3)
    end
    local Map = Workspace:FindFirstChild("Map")
    local Barriers = if not Map then nil else Map:FindFirstChild("Barriers")
    if Barriers then
        table.insert(v2, Barriers)
    end
    v1.FilterDescendantsInstances = v2
    return v1
end

local function isTargetVisible(a1, a2) -- Line: 245
    -- upvalues: doesRaycastIntersectSmoke (val), Workspace (val), getLocalRaycastParams (val)
    local Position = a1.PrimaryPart.Position
    local Unit = (Position - a2).Unit
    local Magnitude = (Position - a2).Magnitude
    if doesRaycastIntersectSmoke(a2, Unit, Magnitude) then
        return false
    end
    local v1 = Workspace:Raycast(a2, Unit * Magnitude, (getLocalRaycastParams()))
    local v2 = true
    if v1 ~= nil then
        v2 = a1:IsAncestorOf(v1.Instance)
    end
    return v2
end

local function findBestTarget(a1) -- Line: 261
    -- upvalues: u70 (ref), u69 (ref), getTargetCandidates (val), PLAYER (val), isTargetVisible (val), u71 (ref)
    local Magnitude, Position, Position_2, v1, v2, v3
    local v4 = os.clock()
    if v4 - u70 < 0.004166666666666667 then
        return u69
    end
    local v5 = nil
    local v6 = 0
    local v7 = a1
    for i, v in ipairs((getTargetCandidates())) do
        Position_2 = v.PrimaryPart.Position
        Position = v7.Position
        Magnitude = (Position_2 - Position).Magnitude
        if not (PLAYER.TargetSelection.MaxDistance < Magnitude) then
            v1 = math.acos((math.clamp(v7.LookVector:Dot((Position_2 - Position).Unit), -1, 1)))
            if not (PLAYER.TargetSelection.MaxAngle < v1) and isTargetVisible(v, Position) then
                v2 = v1 / PLAYER.TargetSelection.MaxAngle
                v3 = 1 / (Magnitude + 1) * (1 - v2)
                if v == u71 then
                    v3 = v3 * 1.6
                end
                if v6 < v3 then
                    v5 = v
                end
            end
        end
    end
    u71 = v5
    u69 = v5
    u70 = v4
    return v5
end

local function calculateFrictionMultiplier(a1, a2) -- Line: 309
    -- upvalues: PLAYER (val), CurrentCamera (val)
    if not a2 then
        return PLAYER.Friction.MaxSensitivity
    end
    local Position = a2.PrimaryPart.Position
    local v1, v2 = CurrentCamera:WorldToViewportPoint(Position)
    if v2 and not (v1.Z < 0) then
        local v3 = CurrentCamera.ViewportSize / 2
        local v4 = Vector2.new(v3.X, v3.Y)
        local Magnitude = (Vector2.new(v1.X, v1.Y) - v4).Magnitude
        local Magnitude_2 = (Position - a1.Position).Magnitude
        local v5 = 2 / Magnitude_2 * v3.Y * 2
        local v6 = PLAYER.Friction.BubbleRadius * (v3.Y / Magnitude_2) * 2
        if v6 + v5 / 2 < Magnitude then
            return PLAYER.Friction.MaxSensitivity
        end
        local v7 = math.clamp(math.max(0, Magnitude - v5 / 2) / math.max(v6, 1), 0, 1)
        local v8 = v7 * v7 * (3 - v7 * 2)
        local MinSensitivity = PLAYER.Friction.MinSensitivity
        return MinSensitivity + (PLAYER.Friction.MaxSensitivity - MinSensitivity) * v8
    end
    return PLAYER.Friction.MaxSensitivity
end

local function isUsingController() -- Line: 350 -- upvalues: UserInputService (val)
    return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end

local function isAssistEnabled() -- Line: 359 -- upvalues: u57 (val), UserInputService (val), u60 (ref), u61 (ref)
    if not u57 and UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            return u61
        end
        return false
    end
    return u60
end

local function isFeatureActive(a1) -- Line: 370
    -- upvalues: u57 (val), UserInputService (val), u60 (ref), u61 (ref), FlashEffect (val)
    return a1 and (if u57 then u60 else if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then if not (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) then false else u61 else u60) and not FlashEffect.IsFlashed()
end

local function canTarget() -- Line: 374 -- upvalues: CurrentCamera (val), CharacterResolver (val)
    local v1 = false
    if CurrentCamera ~= nil then
        v1 = CharacterResolver.getLocalCharacter() ~= nil
    end
    return v1
end

function u0.GetFrictionMultiplier() -- Line: 382
    -- upvalues: PLAYER (val), u57 (val), UserInputService (val), u60 (ref), u61 (ref), FlashEffect (val)
    -- upvalues: CurrentCamera (val), CharacterResolver (val), calculateFrictionMultiplier (val), findBestTarget (val)
    local v1 = PLAYER.Friction.Enabled and (if u57 then u60 else if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then if not (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) then false else u61 else u60) and not FlashEffect.IsFlashed()
    if v1 then
        v1 = false
        if CurrentCamera ~= nil then
            v1 = CharacterResolver.getLocalCharacter() ~= nil
        end
        if v1 then
            local CFrame = CurrentCamera.CFrame
            return (calculateFrictionMultiplier(CFrame, (findBestTarget(CFrame))))
        end
    end
    return PLAYER.Friction.MaxSensitivity
end

local function findTargetWithRaycast(a1) -- Line: 394
    -- upvalues: PLAYER (val), getLocalRaycastParams (val), Workspace (val), isBotTarget (val), CharacterResolver (val)
    -- upvalues: LocalPlayer (val), u65 (val), doesRaycastIntersectSmoke (val)
    local Attribute, Attribute_2, LookVector, Magnitude, Parent, v1, v2, v3, v4, v5
    local Position = a1.Position
    local MaxDistance = PLAYER.Magnetism.MaxDistance
    local v6 = getLocalRaycastParams()
    local v7 = PLAYER.Magnetism.MaxAngleHorizontal / 2
    local v8 = PLAYER.Magnetism.MaxAngleVertical / 2
    for i = -1, 1 do
        for j = -1, 1 do
            LookVector = (a1 * CFrame.Angles(j * v8, i * v7, 0)).LookVector
            v1 = Workspace:Raycast(Position, LookVector * MaxDistance, v6)
            if v1 then
                v2 = v1.Instance:FindFirstAncestorOfClass("Model")
                if v2 then
                    Parent = v2
                    while Parent do
                        if not Parent:IsA("Model") then
                            break
                        end
                        if Parent:GetAttribute("Bot") == true then
                            v2 = Parent
                            break
                        end
                        Parent = Parent.Parent
                    end
                    v3 = isBotTarget(v2)
                    if not v3 and CharacterResolver.isPlayerCharacter(v2) then
                        v4 = CharacterResolver.getPlayerFromCharacter(v2)
                        v5 = false
                        if v4 ~= nil then
                            Attribute = v4:GetAttribute("Team")
                            Attribute_2 = LocalPlayer:GetAttribute("Team")
                            if not u65[Attribute_2] then
                                v5 = false
                            elseif u65[Attribute] then
                                v5 = true
                                if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                                    v5 = Attribute_2 ~= Attribute
                                end
                            else
                                v5 = false
                            end
                            if v5 then
                                v5 = CharacterResolver.isAliveCharacter(v2)
                            end
                        end
                        v3 = v5
                    end
                    if v3 then
                        Magnitude = (v1.Position - Position).Magnitude
                        if Magnitude <= MaxDistance
                            and not doesRaycastIntersectSmoke(Position, LookVector, Magnitude) then
                            return v2
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function calculateMagnetismRotation(a1, a2, a3) -- Line: 446
    -- upvalues: PLAYER (val)
    if not a2.PrimaryPart then
        return Vector2.zero
    end
    local Position_2 = a2.PrimaryPart.Position
    local Position = a1.Position
    local LookVector = a1.LookVector
    if PLAYER.Magnetism.MaxDistance < (Position_2 - Position).Magnitude then
        return Vector2.zero
    end
    local Unit = (Position_2 - Position).Unit
    local v1 = math.acos((math.clamp((Vector3.new(LookVector.X, 0, LookVector.Z)).Unit:Dot((Vector3.new(Unit.X, 0, Unit.Z)).Unit), -1, 1)))
    if not (PLAYER.Magnetism.MaxAngleHorizontal < v1)
        and not (v1 <= PLAYER.Magnetism.StopThreshold)
        and not (v1 > 1.5707963267948966) then
        local v2 = math.atan2(-LookVector.X, -LookVector.Z)
        local v3 = math.atan2(-Unit.X, -Unit.Z) - v2
        if v3 > 3.141592653589793 then
            v3 = v3 - 6.283185307179586
        elseif v3 < -3.141592653589793 then
            v3 = v3 + 6.283185307179586
        end
        local v4 = math.abs(v3)
        if v4 < 0.001 then
            return Vector2.zero
        end
        return Vector2.new((if not (v3 > 0) then -1 else 1) * (math.min(PLAYER.Magnetism.PullStrength * a3, v4)), 0)
    end
    return Vector2.zero
end

local function calculateVerticalMagnetismRotation(a1, a2, a3, a4) -- Line: 500
    -- upvalues: PLAYER (val)
    local Head = a2:FindFirstChild("Head")
    if not Head then
        return 0
    end
    local Position_2 = Head.Position
    local VerticalMagnetism = PLAYER.VerticalMagnetism
    local Position = a1.Position
    if VerticalMagnetism.MaxDistance < (Position_2 - Position).Magnitude then
        return 0
    end
    local Unit = (Position_2 - Position).Unit
    local v1 = math.asin((math.clamp(a1.LookVector.Y, -1, 1)))
    local v2 = math.asin((math.clamp(Unit.Y, -1, 1))) - v1
    local v3 = math.abs(v2)
    if not a4 and VerticalMagnetism.MaxAngleVertical < v3 then
        return 0
    end
    if not (v3 <= VerticalMagnetism.StopThreshold) and not (v3 < 0.001) then
        local v4 = math.min(VerticalMagnetism.PullStrength * a3, v3)
        return (if not (v2 > 0) then -1 else 1) * v4
    end
    return 0
end

local function getYawPitch(a1) -- Line: 544 -- types: a1: vector
    return (math.atan2(-a1.X, -a1.Z)), (math.asin((math.clamp(a1.Y, -1, 1))))
end

local function wrapAngle(a1) -- Line: 548 -- types: a1: number
    return (a1 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function getStickActivity() -- Line: 553 -- upvalues: UserInputService (val)
    local v1 = 0
    for i, j in UserInputService:GetConnectedGamepads() do
        for k, n in UserInputService:GetGamepadState(j) do
            if n.KeyCode == Enum.KeyCode.Thumbstick1 or n.KeyCode == Enum.KeyCode.Thumbstick2 then
                v1 = math.max(v1, (Vector2.new(n.Position.X, n.Position.Y)).Magnitude)
            end
        end
    end
    return (math.clamp((v1 - 0.15) / 0.85 * 1.5, 0, 1))
end

local function getAimPoint(a1) -- Line: 568 -- types: a1: userdata
    local PrimaryPart = a1.PrimaryPart
    if not PrimaryPart then
        return nil
    end
    local Head = a1:FindFirstChild("Head")
    if Head and Head:IsA("BasePart") then
        return PrimaryPart.Position:Lerp(Head.Position, 0.6)
    end
    return PrimaryPart.Position
end

local function calculateControllerMagnetism(a1, a2, a3) -- Line: 581
    -- upvalues: u68 (val), u72 (ref), PLAYER (val), getStickActivity (val), u73 (ref), u74 (ref)
    local Position_3
    local PrimaryPart = a2.PrimaryPart
    if PrimaryPart then
        local Head = a2:FindFirstChild("Head")
        Position_3 = if not Head or not Head:IsA("BasePart") then PrimaryPart.Position else PrimaryPart.Position:Lerp(Head.Position, u68.AimHeight)
    else
        Position_3 = nil
    end
    if not Position_3 then
        u72 = nil
        return Vector2.zero
    end
    local v1 = Position_3 - a1.Position
    local Magnitude = v1.Magnitude
    if not (Magnitude < 1) and not (PLAYER.Magnetism.MaxDistance < Magnitude) then
        local v2, v3, v4, v5
        local v6 = v1 / Magnitude
        local v7 = math.atan2(-v6.X, -v6.Z)
        local v8 = math.asin((math.clamp(v6.Y, -1, 1)))
        local LookVector = a1.LookVector
        local v9 = math.atan2(-LookVector.X, -LookVector.Z)
        local v10 = math.asin((math.clamp(LookVector.Y, -1, 1)))
        local v11 = math.acos((math.clamp(a1.LookVector:Dot(v6), -1, 1)))
        local v12 = getStickActivity()
        local v13 = 0
        local v14 = 0
        if u72 == a2 and v11 < 0.12217304763960307 then
            v2 = (v7 - u73 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
            v3 = v8 - u74
            v4 = 3 * a3
            if math.abs(v2) < v4 and math.abs(v3) < v4 then
                v5 = 0.55 * v12 * (1 - v11 / 0.12217304763960307)
                v13 = v2 * v5
                v14 = v3 * v5
            end
        end
        u72 = a2
        u73 = v7
        u74 = v8
        v2 = 0
        v3 = 0
        if v11 > 0.002617993877991494 and v11 < 0.17453292519943295 then
            v4 = 1 - (v11 / 0.17453292519943295) ^ 2
            v5 = 0.25 + 0.75 * v12
            local v15 = (1 - math.exp(-3.2 * a3)) * v4 * v5
            v2 = ((v7 - v9 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v15
            v3 = (v8 - v10) * v15
            local v16 = math.sqrt(v2 * v2 + v3 * v3)
            local v17 = 0.5235987755982988 * a3
            if v17 < v16 then
                v2 = v2 * v17 / v16
                v3 = v3 * v17 / v16
            end
        end
        return Vector2.new(v2 + v13, v3 + v14)
    end
    u72 = nil
    return Vector2.zero
end

function u0.GetMagnetismRotation(a1) -- Line: 635
    -- upvalues: PLAYER (val), u57 (val), UserInputService (val), u60 (ref), u61 (ref), FlashEffect (val)
    -- upvalues: CurrentCamera (val), CharacterResolver (val), u72 (ref), findBestTarget (val)
    -- upvalues: findTargetWithRaycast (val), calculateControllerMagnetism (val), calculateMagnetismRotation (val)
    -- upvalues: calculateVerticalMagnetismRotation (val)
    local v1 = PLAYER.Magnetism.Enabled and (if u57 then u60 else if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then if not (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) then false else u61 else u60) and not FlashEffect.IsFlashed()
    if v1 then
        v1 = false
        if CurrentCamera ~= nil then
            v1 = CharacterResolver.getLocalCharacter() ~= nil
        end
        if v1 then
            v1 = a1 or 0.016666666666666666
            local CFrame = CurrentCamera.CFrame
            local v2 = findBestTarget(CFrame) or findTargetWithRaycast(CFrame)
            if not v2 then
                u72 = nil
                return Vector2.zero
            end
            if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                return calculateControllerMagnetism(CFrame, v2, v1)
            end
            u72 = nil
            local v3 = calculateMagnetismRotation(CFrame, v2, v1)
            local v4 = 0.0001 < (math.abs(v3.X))
            local v5 = 0
            if PLAYER.VerticalMagnetism.Enabled then
                v5 = calculateVerticalMagnetismRotation(CFrame, v2, v1, v4)
            end
            return Vector2.new(v3.X, v5)
        end
    end
    u72 = nil
    return Vector2.zero
end

function u0.GetRecoilAssistMultiplier() -- Line: 670
    -- upvalues: PLAYER (val), u57 (val), UserInputService (val), u60 (ref), u61 (ref), FlashEffect (val)
    -- upvalues: CurrentCamera (val), CharacterResolver (val), findBestTarget (val)
    if not PLAYER.RecoilAssist.Enabled
        or not (if u57 then u60 else if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then if not (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) then false else u61 else u60)
        or FlashEffect.IsFlashed() then
        return 0
    end
    if not PLAYER.RecoilAssist.RequiresTarget then
        return PLAYER.RecoilAssist.ReductionAmount
    end
    local v1 = false
    if CurrentCamera ~= nil then
        v1 = CharacterResolver.getLocalCharacter() ~= nil
    end
    if v1 and findBestTarget(CurrentCamera.CFrame) then
        return PLAYER.RecoilAssist.ReductionAmount
    end
    return 0
end

function u0.GetRecoilAssistScale() -- Line: 684 -- upvalues: u0 (val), u57 (val), PLAYER (val)
    local v1 = u0.GetRecoilAssistMultiplier()
    if v1 <= 0 then
        return (Vector3.new(1, 1, 1))
    end
    local v2 = v1
    if u57 then
        v2 = math.max(v1, PLAYER.RecoilAssist.HorizontalReductionAmount)
    end
    return (Vector3.new(1 - v1, 1 - v2, 1))
end

local u109 = false

function u0.Initialize() -- Line: 706
    -- upvalues: u109 (ref), DataController (val), LocalPlayer (val), u60 (ref), u61 (ref)
    if u109 then
        return
    end
    u109 = true
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Mobile Aim Assist", function(a1) -- Line: 712 -- upvalues: u60 (upval) -- types: a1: boolean?
        u60 = a1 ~= false
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Controller Aim Assist", function(a1) -- Line: 715 -- upvalues: u61 (upval) -- types: a1: boolean?
        u61 = a1 ~= false
    end)
end

return u0