-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Radar
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Radar
-- Decompile time: 59.51 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local CreateVoxelSmoke = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local u126 = table.find(GetUserPlatform(), "Mobile")
if u126 then
    u126 = #GetUserPlatform() <= 1
end
local Radar = ReplicatedStorage.Assets.UI.Radar

local function GetCurrentCamera() -- Line: 54 -- upvalues: Workspace (val)
    return Workspace.CurrentCamera
end

local u135 = if not u126 then 200 else 120
local u140 = Color3.fromRGB(255, 255, 255)

local function GetEffectiveScale(a1) -- Line: 67 -- upvalues: u126 (val) -- types: a1: number
    if u126 then
        return (a1 - 1) * 0.5 + 1
    end
    return a1
end

local function RoundToPixel(a1) -- Line: 74 -- types: a1: number
    return (math.floor(a1 + 0.5))
end

local u145 = if not u126 then 50 else 30
local u148 = if not u126 then 35 else 21
local u149 = {
    DeadTeammate = 13,
    LocalPlayer = 15,
    Teammate = 14,
    Enemy = 17,
    Bomb = 19,
    Site = 16,
    EnemyQuestionMark = 20,
    Hostage = 18,
}
local u150 = {Vertigo = 387, ["Winter Vertigo"] = 387, Reactor = 67.388}

local function GetUpperLayerHeight(a1) -- Line: 130 -- upvalues: u150 (val) -- types: a1: string?
    if a1 then
        return u150[a1]
    end
    return nil
end

local function IsDeathmatchGamemode() -- Line: 134 -- upvalues: Workspace (val)
    local v1 = true
    if Workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
        v1 = Workspace:GetAttribute("ServerGamemode") == "Deathmatch"
    end
    return v1
end

local v1 = {A = {-0.02, 0.04}, B = {-0.015, -0.005}}
local v2 = {A = {0.0425, 0.005}, B = {-0.01, -0.01}}
local u173 = {Mirage = v1, ["Winter Mirage"] = v1, Vertigo = v2, ["Winter Vertigo"] = v2}
u173.Seaside = {A = {-0.01, -0.01}, B = {0, 0.02}}
u173["Dust 2"] = {A = {-0.06, -0.04}, B = {-0.065, -0.02}}
local u192 = Color3.fromRGB(255, 0, 0)
local u197 = Color3.fromRGB(255, 0, 0)
local u202 = Color3.fromRGB(255, 255, 255)
local u203 = nil
local u204 = {
    {"Radar Centers The Player", "CentersPlayer"},
    {"Radar Hud Size", "Scale"},
    {"Radar Is Rotating", "Rotation"},
    {"Radar Map Zoom", "Zoom"},
}
local u217 = {CentersPlayer = true, Rotation = false, Zoom = 0.7, Scale = 1}
local u218 = nil
local u219 = nil

local function getRadarCharacter(a1) -- Line: 202
    -- upvalues: Participants (val), CharacterResolver (val)
    local v1
    if not a1 then
        return nil
    end
    if not a1:IsA("Player") then
        v1 = Participants.Character(a1)
        if v1 and v1:IsDescendantOf(workspace) then
            return v1
        end
        return nil
    end
    v1 = CharacterResolver.getPlayerCharacter(a1)
    if v1 and v1:IsDescendantOf(workspace) then
        return v1
    end
    return nil
end

local function getRadarObserverCharacter(a1) -- Line: 216
    -- upvalues: getRadarCharacter (val), CharacterResolver (val)
    local v1 = getRadarCharacter(a1)
    if v1 and CharacterResolver.isAliveCharacter(v1) then
        if a1 and a1:GetAttribute("Dead") == true then
            return nil
        end
        return v1
    end
    return nil
end

local function GetMinimapReference() -- Line: 229 -- upvalues: CollectionService (val)
    local Attribute, v1
    local Map = workspace:FindFirstChild("Map")
    if not Map then
        return nil
    end
    for i, v in ipairs(CollectionService:GetTagged("Minimap")) do
        if v:IsA("BasePart") and v:IsDescendantOf(Map) then
            Attribute = v:GetAttribute("TextureSize")
            v1 = if typeof(Attribute) ~= "number" then 1024 else if not (Attribute > 0) then 1024 else Attribute
            return {
                Size = v.Size,
                Upper = v:FindFirstChild("Upper"),
                Lower = v:FindFirstChild("Lower"),
                Part = v,
                TextureSize = v1,
            }
        end
    end
    return nil
end

local function GetTeammateDisplayColor(a1, a2) -- Line: 256
    -- upvalues: getRadarCharacter (val), Colors (val)
    if not a2 then
        return nil
    end
    local v1 = getRadarCharacter(a1)
    return v1 and v1:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][a2]
end

local function createRadarInstance(a1, a2, a3) -- Line: 266
    -- upvalues: Profiler (val), u218 (ref), u0 (val), u203 (ref)
    Profiler.mark("UI.Radar.CreateRadarForCharacter")
    if u218 then
        u218:Destroy()
        u218 = nil
    end
    local v1 = u0.new(u203, a1)
    u218 = v1
    v1.LocalPlayer = a2
    v1.Team = a2:GetAttribute("Team")
    v1.IsSpectating = a3 or false
    if a3 then
        v1.MapImage.Rotation = 90
        if v1.UpperMapImage then
            v1.UpperMapImage.Rotation = 90
        end
    end
    if a1 then
        v1.Janitor:Add(((a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 290 -- upvalues: u218 (upval), a1 (val)
            if u218 and a1:GetAttribute("Dead") then
                u218:Destroy()
                u218 = nil
            end
        end)))
    end
end

local function GetSiteParts() -- Line: 299 -- upvalues: CollectionService (val)
    local Attribute
    local v1 = {}
    for i, v in ipairs(CollectionService:GetTagged("PlantArea")) do
        if v:IsA("BasePart") then
            Attribute = v:GetAttribute("Site")
            if Attribute == "A" or Attribute == "B" then
                if not v1[Attribute] then
                    v1[Attribute] = {}
                end
                table.insert(v1[Attribute], v.CFrame)
            end
        end
    end
    return v1
end

local function GetSiteCenter(a1) -- Line: 315 -- types: a1: table
    if #a1 == 0 then
        return (Vector3.new(0, 0, 0))
    end
    local v1 = Vector3.new(0, 0, 0)
    for i, v in ipairs(a1) do
        v1 = v1 + v.Position
    end
    return v1 / #a1
end

local u251 = {}
local u252 = 0

local function PlayerHasBomb(a1) -- Line: 330
    -- upvalues: u251 (val), HttpService (val), u252 (ref)
    local Attribute = a1:GetAttribute("Slot5")
    if not Attribute then
        return false
    end
    local v1 = u251[Attribute]
    if v1 ~= nil then
        return v1
    end
    local v2 = HttpService:JSONDecode(Attribute)
    local v3 = false
    if v2 ~= nil then
        v3 = v2.Weapon == "C4"
    end
    if u252 >= 64 then
        table.clear(u251)
        u252 = 0
    end
    u251[Attribute] = v3
    u252 = u252 + 1
    return v3
end

local function PlayerIsCarryingHostage(a1) -- Line: 355 -- types: a1: userdata
    return a1:GetAttribute("IsCarryingHostage") == true
end

local u260 = RaycastParams.new()
u260.FilterType = Enum.RaycastFilterType.Exclude
u260.CollisionGroup = "Bullet"
u260.IgnoreWater = true

local function GetObserverSpottingRay(a1, a2, a3, a4) -- Line: 364
    -- upvalues: Workspace (val), CharacterResolver (val)
    local LookVector, Magnitude, Position, Unit, v1
    if a1 == a3 then
        local CurrentCamera = Workspace.CurrentCamera
        if not CurrentCamera then
            return nil, nil, nil
        end
        local CFrame = CurrentCamera.CFrame
        Position = CFrame.Position
        LookVector = CFrame.LookVector
        v1 = a4 - Position
        Magnitude = v1.Magnitude
        if not (Magnitude <= 1e-06) and not (Magnitude > 200) then
            Unit = v1.Unit
            if (Unit:Dot(LookVector)) <= 0.65 then
                return nil, nil, nil
            end
            return Position, Unit, Magnitude
        end
        return nil, nil, nil
    end
    v1 = CharacterResolver.getHead(a2)
    if v1 then
        Position = v1.Position
        LookVector = v1.CFrame.LookVector
        v1 = a4 - Position
        Magnitude = v1.Magnitude
        if not (Magnitude <= 1e-06) and not (Magnitude > 200) then
            Unit = v1.Unit
            if (Unit:Dot(LookVector)) <= 0.65 then
                return nil, nil, nil
            end
            return Position, Unit, Magnitude
        end
        return nil, nil, nil
    end
    local v2 = CharacterResolver.getRootPart(a2)
    if not v2 then
        return nil, nil, nil
    end
    Position = v2.Position + Vector3.new(0, 1.5, 0)
    LookVector = v2.CFrame.LookVector
    v1 = a4 - Position
    Magnitude = v1.Magnitude
    if not (Magnitude <= 1e-06) and not (Magnitude > 200) then
        Unit = v1.Unit
        if (Unit:Dot(LookVector)) <= 0.65 then
            return nil, nil, nil
        end
        return Position, Unit, Magnitude
    end
    return nil, nil, nil
end

local function HasClearSpottingLine(a1, a2, a3, a4) -- Line: 411
    -- upvalues: CreateVoxelSmoke (val), u260 (val), Workspace (val)
    if CreateVoxelSmoke.DoesRayIntersectActiveSmoke(a1, a2, a3) then
        return false
    end
    u260.FilterDescendantsInstances = a4
    return Workspace:Raycast(a1, a2 * a3, u260) == nil
end

local u270 = {}
local u274 = setmetatable({}, {__mode = "k"})

local function CanObserverSpot(a1, a2, a3, a4, a5) -- Line: 430
    -- upvalues: getRadarCharacter (val), CharacterResolver (val), GetObserverSpottingRay (val), u270 (val)
    -- upvalues: CreateVoxelSmoke (val), u260 (val), Workspace (val)
    if a1 ~= a5 and a1:GetAttribute("Team") == a2 then
        local v1, v2, v3
        local v4 = getRadarCharacter(a1)
        if not (if not v4 then nil else if CharacterResolver.isAliveCharacter(v4) then if not a1 then v4 else if a1:GetAttribute("Dead") ~= true then v4 else nil else nil) then
            return false
        end
        v4, v2, v3 = GetObserverSpottingRay(a1, v1, a4, a3)
        if v4 and v2 and v3 then
            u270[1] = v1
            if CreateVoxelSmoke.DoesRayIntersectActiveSmoke(v4, v2, v3) then
                return false
            end
            u260.FilterDescendantsInstances = u270
            return Workspace:Raycast(v4, v2 * v3, u260) == nil
        end
        return false
    end
    return false
end

local function IsVisibleToTeam(a1, a2, a3, a4, a5) -- Line: 456
    -- upvalues: u270 (val), Workspace (val), CollectionService (val), u274 (val), CanObserverSpot (val)
    -- upvalues: Participants (val)
    table.clear(u270)
    u270[1] = Workspace
    local Map = Workspace:FindFirstChild("Map")
    local Barriers = if not Map then nil else Map:FindFirstChild("Barriers")
    if Barriers then
        table.insert(u270, Barriers)
    end
    if a3 then
        table.insert(u270, a3)
    end
    for i, v in ipairs(CollectionService:GetTagged("Hostage")) do
        if v:IsA("Model") and v ~= a3 then
            table.insert(u270, v)
        end
    end
    local v1 = if not a3 then nil else u274[a3]
    if v1 and CanObserverSpot(v1, a1, a2, a4, a5) then
        return true
    end
    for i2, i3 in ipairs(Participants.GetAll()) do
        if i3 ~= v1 and CanObserverSpot(i3, a1, a2, a4, a5) then
            if a3 then
                u274[a3] = i3
            end
            return true
        end
    end
    return false
end

local function ReadCachedVisibility(a1, a2) -- Line: 497 -- types: a2: number
    if a1 and a2 - a1.UpdatedAt <= 0.1 then
        return a1.Visible
    end
    return nil
end

local function GetEnemyVisibility(a1, a2, a3, a4, a5) -- Line: 504
    -- upvalues: CharacterResolver (val), IsVisibleToTeam (val)
    local v1 = a1.EnemyVisibilityCache[a2]
    local Visible = if not v1 then nil else if not (a5 - v1.UpdatedAt <= 0.1) then nil else v1.Visible
    if Visible ~= nil then
        return Visible
    end
    if a1.EnemyVisibilityChecksRemaining <= 0 then
        if v1 then
            return v1.Visible
        end
        return false
    end
    a1.EnemyVisibilityChecksRemaining = a1.EnemyVisibilityChecksRemaining - 1
    local v2 = false
    local v3 = CharacterResolver.getRootPart(a3)
    if v3 then
        local v4 = CharacterResolver.getHead(a3)
        v2 = IsVisibleToTeam(a1.Team, if not v4 then v3.Position + Vector3.new(0, 1.5, 0) else v4.Position, a3, a1.LocalPlayer, a4)
    end
    a1.EnemyVisibilityCache[a2] = {Visible = v2, UpdatedAt = a5}
    return v2
end

local function GetBombVisibility(a1, a2, a3, a4) -- Line: 538
    -- upvalues: IsVisibleToTeam (val)
    local BombVisibilityCache = a1.BombVisibilityCache
    local Visible = if not BombVisibilityCache then nil else if not (a4 - BombVisibilityCache.UpdatedAt <= 0.1) then nil else BombVisibilityCache.Visible
    if Visible ~= nil then
        return Visible
    end
    local v1 = IsVisibleToTeam("Counter-Terrorists", a2, a3, a1.LocalPlayer)
    a1.BombVisibilityCache = {Visible = v1, UpdatedAt = a4}
    return v1
end

local function GetHostageVisibility(a1, a2, a3, a4, a5) -- Line: 552
    -- upvalues: IsVisibleToTeam (val)
    local v1 = a1.HostageVisibilityCache[a2]
    local Visible = if not v1 then nil else if not (a5 - v1.UpdatedAt <= 0.1) then nil else v1.Visible
    if Visible ~= nil then
        return Visible
    end
    v1 = IsVisibleToTeam("Terrorists", a3, a4, a1.LocalPlayer)
    a1.HostageVisibilityCache[a2] = {Visible = v1, UpdatedAt = a5}
    return v1
end

local function HideDirectionIndicators(a1) -- Line: 573 -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v.Name == "Direction" and v:IsA("ImageLabel") then
            v.Visible = false
        end
    end
end

local u282 = {Teammate = "Player", Enemy = "Enemy", DeadTeammate = "Dead"}

local function CreateIcon(a1, a2, a3) -- Line: 587
    -- upvalues: u282 (val), Radar (val), u149 (val), HideDirectionIndicators (val)
    local v1 = u282[a2]
    if not v1 then
        error((("Invalid icon type: %*"):format(a2)))
    end
    local v2 = Radar[v1]:Clone()
    v2.ZIndex = u149[a2]
    v2.Position = UDim2.fromScale(0.5, 0.5)
    v2.AnchorPoint = Vector2.new(0.5, 0.5)
    v2.Size = UDim2.fromOffset(a3, a3)
    v2.Parent = a1
    HideDirectionIndicators(v2)
    return v2
end

local function GetHostageAsset() -- Line: 605 -- upvalues: Radar (val)
    local Hostage = Radar:FindFirstChild("Hostage")
    if Hostage and Hostage:IsA("ImageLabel") then
        return Hostage
    end
    return Radar.Player
end

local function ApplyEnemyIconImage(a1, a2) -- Line: 614
    -- upvalues: PlayerHasBomb (val), Radar (val)
    if PlayerHasBomb(a2) then
        a1.Image = Radar.Bomb.Image
        a1.Size = UDim2.fromOffset(14, 14)
        return
    end
    if not (a2:GetAttribute("IsCarryingHostage") == true) then
        a1.Image = Radar.Player.Image
        a1.Size = UDim2.fromOffset(12, 12)
        return
    end
    local Hostage = Radar:FindFirstChild("Hostage")
    a1.Image = (if not Hostage then Radar.Player else if not Hostage:IsA("ImageLabel") then Radar.Player else Hostage).Image
    a1.Size = UDim2.fromOffset(30, 30)
end

local function GetYawUIDeg(a1, a2) -- Line: 628 -- types: a1: vector, a2: userdata?
    local v1 = Vector3.new(a1.X, 0, a1.Z)
    local Unit = if not (v1.Magnitude < 1e-06) then v1.Unit else Vector3.new(0, 0, 1)
    if a2 then
        Unit = a2.CFrame:VectorToObjectSpace(Unit)
    end
    local X_2 = Unit.X
    local Z_2 = Unit.Z
    local v2 = -X_2
    return (math.deg((math.atan2(-Z_2, v2))) + 90) % 360
end

local function ProjectToRadar(a1, a2, a3, a4, a5) -- Line: 660 -- types: a3: vector, a4: number?, a5: number?
    local Size = a2.Size
    local TextureSize = a2.TextureSize
    local v1 = a2.Part.CFrame:PointToObjectSpace(a3)
    local X = v1.X
    local Z = v1.Z
    local v2 = -X
    local v3 = -Z
    local v4 = v2 / Size.X + 0.5
    local v5 = v3 / Size.Z + 0.5
    local ImageRectOffset = a1.MapImage.ImageRectOffset
    local ImageRectSize = a1.MapImage.ImageRectSize
    if a4 and a5 then
        v4 = v4 + a4 * ImageRectSize.X / TextureSize
        v5 = v5 + a5 * ImageRectSize.Y / TextureSize
    end
    local v6 = v4 * TextureSize
    local v7 = v5 * TextureSize
    local v8 = v6 - ImageRectOffset.X
    local v9 = v7 - ImageRectOffset.Y
    local v10 = v8 / ImageRectSize.X
    local v11 = v9 / ImageRectSize.Y
    if a1.MapImage.Rotation ~= 0 then
        local v12 = math.rad(a1.MapImage.Rotation)
        local v13 = math.cos(v12)
        local v14 = math.sin(v12)
        local v15 = v10 - 0.5
        local v16 = v11 - 0.5
        v10 = 0.5 + (v15 * v13 - v16 * v14)
        v11 = 0.5 + (v15 * v14 + v16 * v13)
    end
    return v10, v11
end

local function ClampToRadarCircle(a1, a2, a3) -- Line: 714 -- types: a1: number, a2: number, a3: number
    local v1 = a1 - 0.5
    local v2 = a2 - 0.5
    local v3 = math.sqrt(v1 * v1 + v2 * v2)
    if not (v3 > 0.5) then
        return a1, a2, v3
    end
    local v4 = v1 / v3
    local v5 = v2 / v3
    return v4 * a3 + 0.5, v5 * a3 + 0.5, v3
end

local function GetClampedRadarPosition(a1, a2, a3) -- Line: 729
    -- upvalues: ProjectToRadar (val), ClampToRadarCircle (val)
    local v1, v2 = ProjectToRadar(a1, a2, a3)
    return ClampToRadarCircle(v1, v2, 0.5)
end

local function ScheduleDeadIconFade(a1, a2) -- Line: 738 -- upvalues: TweenService (val) -- types: a2: string
    task.delay(2, function() -- Line: 739 -- upvalues: a1 (val), a2 (val), TweenService (upval)
        local v1 = a1.Icons[a2]
        if v1 and v1.Instance and v1.Instance.Parent then
            a1.FadedDeadIcons[a2] = true
            local v2 = TweenService:Create(v1.Instance, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {ImageTransparency = 1})
            v2:Play()
            v2.Completed:Connect(function() -- Line: 754 -- upvalues: a1 (upval), a2 (upval)
                if a1.Icons[a2] then
                    a1:RemoveIcon(a2)
                end
            end)
        end
    end)
end

local function CreateRadarCircle(a1, a2, a3) -- Line: 764 -- upvalues: u202 (val) -- types: a2: string, a3: boolean
    local Frame = Instance.new("Frame")
    Frame.Name = a2
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.ZIndex = 14
    Frame.Parent = a1.RadarContainer
    if a3 then
        Frame.Visible = false
    end
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = u202
    UIStroke.Thickness = 2
    UIStroke.Transparency = 1
    UIStroke.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame
    return Frame
end

local function GetCircleRadius(a1, a2) -- Line: 791 -- upvalues: u126 (val), u135 (val) -- types: a2: number
    local v1 = math.clamp(a1.Zoom or 0.5, 0.1, 1)
    local v2 = a1.Scale or 1
    local v3 = if not u126 then v2 else (v2 - 1) * 0.5 + 1
    local v4 = a2 * (0.5 / v1) * v3
    local v5 = u135 / 2 * v3
    return (math.min(v4, v5)), v5
end

local function IsCharacterMoving(a1) -- Line: 800
    if not a1 then
        return false
    end
    local GlobalDirection = a1.GlobalDirection
    local GlobalVelocity = a1.GlobalVelocity
    if GlobalDirection and GlobalVelocity then
        local Magnitude = (Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z)).Magnitude
        local v1 = true
        if not (0.1 < GlobalDirection.Magnitude) then
            v1 = Magnitude > 0.1
        end
        return v1
    end
    return false
end

local function GetSiteShift(a1, a2) -- Line: 814 -- upvalues: u173 (val) -- types: a1: string?, a2: string
    local v1 = if not a1 then nil else u173[a1]
    local v2 = v1 and v1[a2]
    if v2 then
        return v2[1], v2[2]
    end
    return nil, nil
end

local function ClearEnemyTracking(a1, a2) -- Line: 824 -- types: a2: string
    a1.EnemyVisibilityState[a2] = nil
    a1.EnemyLastSeenPositions[a2] = nil
    a1.EnemyLastSeenPositions[a2 .. "_Frozen"] = nil
end

local function CreateDeadIcon(a1, a2, a3, a4) -- Line: 831
    -- upvalues: CreateIcon (val), Participants (val), Radar (val), TweenService (val)
    local v1 = CreateIcon(a1.RadarContainer, "DeadTeammate", 12)
    v1.Name = (Participants.Name(a2)) .. "_Dead"
    v1.ImageTransparency = 0
    if a4 then
        v1.ImageColor3 = a4
    end
    a1.Icons[a3] = {Type = "DeadTeammate", Instance = v1, Player = a2, DefaultSize = Radar.Dead.Size}
    task.delay(2, function() -- Line: 739 -- upvalues: a1 (val), a3 (val), TweenService (upval)
        local v1 = a1.Icons[a3]
        if v1 and v1.Instance and v1.Instance.Parent then
            a1.FadedDeadIcons[a3] = true
            local v2 = TweenService:Create(v1.Instance, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {ImageTransparency = 1})
            v2:Play()
            v2.Completed:Connect(function() -- Line: 754 -- upvalues: a1 (upval), a3 (upval)
                if a1.Icons[a3] then
                    a1:RemoveIcon(a3)
                end
            end)
        end
    end)
    return v1
end

function u0:GetTrackedPosition() -- Line: 854 -- upvalues: SpectateController (val), Workspace (val)
    if SpectateController.IsFreecamActive() then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera then
            return CurrentCamera.CFrame.Position
        end
    end
    local Character = self.Character
    local PrimaryPart = Character and Character.PrimaryPart
    return PrimaryPart and PrimaryPart.Position
end

function u0:WorldToRadar(a2) -- Line: 867
    -- upvalues: SpectateController (val), CharacterResolver (val), ProjectToRadar (val)
    if not self.MinimapReference then
        return nil
    end
    if not SpectateController.IsFreecamActive() and not CharacterResolver.getRootPart(self.Character) then
        return nil
    end
    local MinimapReference = self.MinimapReference
    local Size = MinimapReference.Size
    if Size.X ~= 0 and Size.Z ~= 0 then
        local ImageRectSize = self.MapImage.ImageRectSize
        if ImageRectSize.X ~= 0 and ImageRectSize.Y ~= 0 then
            local v1, v2 = ProjectToRadar(self, MinimapReference, a2)
            return Vector2.new(v1, v2)
        end
        return nil
    end
    return nil
end

local function CalculateClampedPosition(a1, a2, a3) -- Line: 892
    -- upvalues: Workspace (val), GuiService (val)
    local v1, v2, v3, v4
    local CurrentCamera = Workspace.CurrentCamera
    local ViewportSize = if not CurrentCamera then a1.AbsoluteSize else CurrentCamera.ViewportSize
    local X = ViewportSize.X
    local Y = ViewportSize.Y
    local X_2 = GuiService:GetGuiInset().X
    local v5 = X_2 + 50
    local AnchorPoint = a1.AnchorPoint
    local v6 = a3.X.Scale * X + a3.X.Offset
    local v7 = a3.Y.Scale * Y + a3.Y.Offset
    if AnchorPoint.X ~= 0.5 or AnchorPoint.Y ~= 0.5 then
        v1 = v6 - AnchorPoint.X * a2
        v2 = v7 - AnchorPoint.Y * a2
        v3 = v1 + a2
        v4 = v2 + a2
    else
        v1 = v6 - a2 / 2
        v2 = v7 - a2 / 2
        v3 = v6 + a2 / 2
        v4 = v7 + a2 / 2
    end
    local v8 = 0
    local v9 = 0
    if v1 < X_2 + 10 then
        v8 = X_2 + 10 - v1
    end
    if X - 10 < v3 then
        v8 = X - 10 - v3
    end
    if v2 < v5 + 10 then
        v9 = v5 + 10 - v2
    end
    if Y - 10 < v4 then
        v9 = Y - 10 - v4
    end
    return UDim2.new(UDim.new(0, v6 + v8), UDim.new(0, v7 + v9))
end

function u0:UpdateIcon(a2, a3, a4) -- Line: 943 -- types: a2: string, a3: vector, a4: number?
    local v1, v2
    local v3 = self.Icons[a2]
    if not v3 then
        return
    end
    local v4 = self:WorldToRadar(a3)
    if not v4 then
        v3.Instance.Visible = false
        return
    end
    local X = v4.X
    local Y = v4.Y
    local v5 = X - 0.5
    local v6 = Y - 0.5
    local v7 = math.sqrt(v5 * v5 + v6 * v6)
    if not (v7 > 0.5) then
        v1 = X
        v2 = Y
    else
        local v8 = v5 / v7
        local v9 = v6 / v7
        v1 = v8 * 0.5 + 0.5
        v2 = v9 * 0.5 + 0.5
    end
    v3.Instance.Visible = true
    v3.Instance.Position = UDim2.fromScale(v1, v2)
    if a4 then
        v3.Instance.Rotation = math.deg(a4)
    end
end

function u0:UpdateTeammateIcon(a2, a3, a4) -- Line: 966
    -- upvalues: ProjectToRadar (val)
    local v1 = self.Icons[a2]
    if not v1 then
        return
    end
    local Instance = v1.Instance
    if Instance and Instance:IsA("GuiObject") then
        local v2, v3
        if not self.MinimapReference then
            Instance.Visible = false
            return
        end
        local v4, v5 = ProjectToRadar(self, self.MinimapReference, a3)
        local v6 = v4 - 0.5
        local v7 = v5 - 0.5
        local v8 = math.sqrt(v6 * v6 + v7 * v7)
        if not (v8 > 0.5) then
            v2 = v4
            v3 = v5
        else
            local v9 = v6 / v8
            local v10 = v7 / v8
            v2 = v9 * 0.5 + 0.5
            v3 = v10 * 0.5 + 0.5
        end
        Instance.Position = UDim2.fromScale(v2, v3)
        Instance.Visible = true
        if a4 and Instance:IsA("ImageLabel") then
            Instance.Rotation = math.deg(a4)
        end
        return
    end
end

function u0:CreatePlayerIcon(a2, a3) -- Line: 994
    -- upvalues: PlayerHasBomb (val), Radar (val), u197 (val), HideDirectionIndicators (val), getRadarCharacter (val)
    -- upvalues: Colors (val), CreateIcon (val), Participants (val)
    local v1, v2
    if a3 ~= "Enemy" then
        local Attribute = a2:GetAttribute("Team")
        if Attribute then
            local v3 = getRadarCharacter(a2)
            v2 = v3 and v3:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Attribute]
        else
            v2 = nil
        end
        v1 = CreateIcon(self.RadarContainer, a3, 12)
        if v2 then
            v1.ImageColor3 = v2
        end
    else
        v2 = PlayerHasBomb(a2)
        local v4 = a2:GetAttribute("IsCarryingHostage") == true
        if v2 then
            v1 = Radar.Bomb:Clone()
            v1.Size = UDim2.fromOffset(14, 14)
        elseif not v4 then
            v1 = Radar.Player:Clone()
            v1.Size = UDim2.fromOffset(12, 12)
        else
            local Hostage = Radar:FindFirstChild("Hostage")
            v1 = (if not Hostage then Radar.Player else if not Hostage:IsA("ImageLabel") then Radar.Player else Hostage):Clone()
            v1.Size = UDim2.fromOffset(30, 30)
        end
        v1.ImageColor3 = u197
        v1.ZIndex = 17
        v1.Position = UDim2.fromScale(0.5, 0.5)
        v1.AnchorPoint = Vector2.new(0.5, 0.5)
        v1.Parent = self.RadarContainer
        HideDirectionIndicators(v1)
    end
    v1.Name = Participants.Name(a2)
    v2 = (Participants.Key(a2)) .. "_" .. a3
    self.Icons[v2] = {Instance = v1, Player = a2, Type = a3}
    return v2
end

function u0:RemoveIcon(a2) -- Line: 1039 -- types: a2: string
    local v1 = self.Icons[a2]
    if v1 then
        v1.Instance:Destroy()
        self.Icons[a2] = nil
    end
end

function u0:RefreshPlayerIcon(a2) -- Line: 1048 -- upvalues: Participants (val) -- types: a2: userdata
    local v1 = Participants.Key(a2)
    local v2 = v1 .. "_Player"
    local v3 = v1 .. "_Dead"
    self:RemoveIcon(v2)
    self:RemoveIcon(v3)
    self.EnemyVisibilityCache[v2] = nil
    self.EnemyVisibilityState[v2] = nil
    self.EnemyLastSeenPositions[v2] = nil
    self.EnemyLastSeenPositions[v2 .. "_Frozen"] = nil
    self.DeadPlayerPositions[v1] = nil
    self.FadedDeadIcons[v3] = nil
end

function u0:RefreshIconsOnTeamChange() -- Line: 1060
    -- upvalues: LocalPlayer (val), getRadarCharacter (val), Colors (val)
    local Team = self.Team
    local Attribute = LocalPlayer:GetAttribute("Team")
    if not Attribute then
        return
    end
    self.Team = Attribute
    if self.Team == Team then
        return
    end
    for k, v in pairs(self.Icons) do
        if v.Player and v.Player ~= LocalPlayer then
            self:RemoveIcon(k)
        end
    end
    table.clear(self.EnemyVisibilityCache)
    table.clear(self.HostageVisibilityCache)
    self.BombVisibilityCache = nil
    self.EnemyVisibilityState = {}
    self.EnemyLastSeenPositions = {}
    self.DeadPlayerPositions = {}
    self.FadedDeadIcons = {}
    if self.Icons.LocalPlayer then
        local v1
        local Instance = self.Icons.LocalPlayer.Instance
        local LocalPlayer_2 = self.LocalPlayer
        local Team_2 = self.Team
        if Team_2 then
            local v2 = getRadarCharacter(LocalPlayer_2)
            v1 = v2 and v2:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Team_2]
        else
            v1 = nil
        end
        if v1 then
            Instance.ImageColor3 = v1
        end
    end
end

function u0:UpdatePlayerIcons() -- Line: 1101
    -- upvalues: Profiler (val), Workspace (val), CharacterResolver (val), SpectateController (val), Radar (val)
    -- upvalues: LocalPlayer (val), getRadarCharacter (val), Colors (val), u140 (val), PlayerHasBomb (val)
    -- upvalues: Participants (val), u197 (val), CreateDeadIcon (val), GetEnemyVisibility (val)
    -- upvalues: ApplyEnemyIconImage (val), TweenService (val), ProjectToRadar (val)
    local AnchorPoint, AnchorPoint_2, Attribute_4, EnemyLastSeenPositions_4, FadeTween, FadeTween_2, ImageLabel, Instance_3, Instance_4, Instance_5, Position_2, Position_4, Position_6, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    Profiler.mark("UI.Radar.UpdatePlayerIcons")
    local v15 = true
    if Workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
        v15 = Workspace:GetAttribute("ServerGamemode") == "Deathmatch"
    end
    local v16 = tick()
    local v17 = CharacterResolver.getRootPart(self.Character)
    local v18 = nil
    if SpectateController.IsFreecamActive() then
        local CurrentCamera = Workspace.CurrentCamera
        v18 = CurrentCamera and CurrentCamera.CFrame
    end
    local v19 = v18 ~= nil
    for k, v in pairs(self.Icons) do
        if v.Instance.Parent == nil then
            self.Icons[k] = nil
        end
    end
    local MinimapReference = self.MinimapReference and self.MinimapReference.Part
    local CFrame_2 = v18 or v17 and v17.CFrame
    if CFrame_2 then
        local v20, v21
        if not self.Icons.LocalPlayer then
            local v22 = Radar.Player:Clone()
            v22.Position = UDim2.fromScale(0.5, 0.5)
            v22.AnchorPoint = Vector2.new(0.5, 0.5)
            v22.ZIndex = 15
            v22.Parent = self.RadarContainer
            v22.Name = "LocalPlayer"
            self.Icons.LocalPlayer = {Type = "Teammate", Instance = v22, Player = self.LocalPlayer}
        end
        local Instance_2 = self.Icons.LocalPlayer.Instance
        Instance_2.Visible = true
        if not v19 then
            local v23
            local LocalPlayer_2 = self.LocalPlayer
            local Team = self.Team
            if Team then
                v21 = getRadarCharacter(LocalPlayer_2)
                v23 = v21 and v21:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Team]
            else
                v23 = nil
            end
            if v23 then
                Instance_2.ImageColor3 = v23
            end
        else
            local Attribute = LocalPlayer:GetAttribute("Team")
            if Attribute then
                v21 = getRadarCharacter(LocalPlayer)
                v20 = v21 and v21:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Attribute]
            else
                v20 = nil
            end
            if not v20 then
                v20 = u140
            end
            Instance_2.ImageColor3 = v20
        end
        if v19 or not PlayerHasBomb(self.LocalPlayer) then
            Instance_2.Image = Radar.Player.Image
            Instance_2.Size = UDim2.fromOffset(12, 12)
        else
            Instance_2.Image = Radar.Bomb.Image
            Instance_2.Size = UDim2.fromOffset(14, 14)
        end
        v20 = 0
        if MinimapReference then
            local LookVector = CFrame_2.LookVector
            v1 = Vector3.new(LookVector.X, 0, LookVector.Z)
            local Unit = if not (v1.Magnitude < 1e-06) then v1.Unit else Vector3.new(0, 0, 1)
            if MinimapReference then
                Unit = MinimapReference.CFrame:VectorToObjectSpace(Unit)
            end
            local X_2 = Unit.X
            local Z_2 = Unit.Z
            v2 = -X_2
            v20 = (math.deg((math.atan2(-Z_2, v2))) + 90) % 360 + self.MapImage.Rotation + 0
        end
        self:UpdateIcon("LocalPlayer", CFrame_2.Position, (math.rad(v20)))
    end
    for i, i2 in ipairs(Participants.GetAll()) do
        v1 = Participants.Key(i2)
        local u328 = v1 .. "_Player"
        if v19 or i2 ~= self.LocalPlayer then
            v3 = v1 .. "_Dead"
            v4 = getRadarCharacter(i2)
            v5 = CharacterResolver.getRootPart(v4)
            Attribute_4 = i2:GetAttribute("Team")
            if not Attribute_4 then
                self:RemoveIcon(u328)
                self:RemoveIcon(v3)
                self.EnemyVisibilityState[u328] = nil
                self.EnemyLastSeenPositions[u328] = nil
                self.EnemyLastSeenPositions[u328 .. "_Frozen"] = nil
                self.DeadPlayerPositions[v1] = nil
                self.FadedDeadIcons[v3] = nil
            elseif Attribute_4 ~= "Spectators" then
                Position_2 = self.DeadPlayerPositions[v1]
                v8 = true
                if Position_2 == nil then
                    v8 = false
                    if v4 ~= nil then
                        v8 = v4:GetAttribute("Dead") == true
                    end
                end
                if i2:GetAttribute("Dead") == true then
                    v8 = true
                end
                v9 = v15 or not (v19 or Attribute_4 == self.Team)
                if not v8 then
                    if v4 and v5 then
                        self:RemoveIcon(v3)
                        self.DeadPlayerPositions[v1] = nil
                        self.FadedDeadIcons[v3] = nil
                        v10 = self.Icons[u328]
                        if v10 and v9 ~= (v10.Type ~= "Teammate") then
                            self:RemoveIcon(u328)
                        end
                        if not self.Icons[u328] then
                            v11 = self:CreatePlayerIcon(i2, if not v9 then "Teammate" else "Enemy")
                            self.Icons[u328] = self.Icons[v11]
                            self.Icons[v11] = nil
                            if v9 then
                                self.Icons[u328].Instance.Visible = false
                            end
                        end
                    end
                    v10 = self.Icons[u328]
                    if v9 then
                        if v10 then
                            v11 = Participants.IsAlive(i2)
                            if v4 or v11 then
                                v12 = v19
                                if not v12 then
                                    v12 = false
                                    if v4 ~= nil then
                                        v12 = GetEnemyVisibility(self, u328, v4, i2, v16)
                                    end
                                end
                                if not v12 then
                                    if self.EnemyVisibilityState[u328] then
                                        Instance_5 = v10.Instance
                                        Position_6 = nil
                                        AnchorPoint_2 = nil
                                        FadeTween_2 = v10.FadeTween
                                        if FadeTween_2 then
                                            FadeTween_2:Cancel()
                                            v10.FadeTween = nil
                                        end
                                        if Instance_5:IsA("ImageLabel") or Instance_5:IsA("TextLabel") then
                                            Position_6 = Instance_5.Position
                                            AnchorPoint_2 = Instance_5.AnchorPoint
                                            Instance_5:Destroy()
                                        end
                                        local u747 = Radar.EnemySeen:Clone()
                                        u747.Name = (Participants.Name(i2)) .. "_QuestionMark"
                                        u747.Position = Position_6
                                        u747.AnchorPoint = AnchorPoint_2
                                        u747.ZIndex = 20
                                        u747.TextTransparency = 0
                                        u747.Visible = true
                                        u747.Parent = self.RadarContainer
                                        v10.Instance = u747
                                        v10.Type = "EnemyQuestionMark"
                                        if self.EnemyLastSeenPositions[u328] then
                                            EnemyLastSeenPositions_4 = self.EnemyLastSeenPositions
                                            v14 = u328 .. "_Frozen"
                                            EnemyLastSeenPositions_4[v14] = self.EnemyLastSeenPositions[u328]
                                        end
                                        task.delay(0.1, function() -- Line: 1378 -- upvalues: self (val), u328 (val), u747 (val), TweenService (upval)
                                            local v1 = self.Icons[u328]
                                            if v1 and v1.Instance == u747 and u747:IsA("TextLabel") then
                                                local u11 = u747
                                                u11.TextTransparency = 0
                                                local u23 = TweenService:Create(
                                                    u11,
                                                    TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
                                                    {TextTransparency = 1}
                                                )
                                                u23:Play()
                                                v1.FadeTween = u23
                                                u23.Completed:Connect(function(a1) -- Line: 1399 -- upvalues: self (upval), u328 (upval), u11 (val), u23 (val)
                                                    local v1 = self.Icons[u328]
                                                    if a1 == Enum.PlaybackState.Completed
                                                        and v1
                                                        and v1.Instance == u11
                                                        and v1.FadeTween == u23 then
                                                        self:RemoveIcon(u328)
                                                        self.EnemyLastSeenPositions[u328 .. "_Frozen"] = nil
                                                    end
                                                end)
                                            end
                                        end)
                                    end
                                    if v10.Type ~= "EnemyQuestionMark" then
                                        v10.Instance.Visible = false
                                    else
                                        v13 = self.EnemyLastSeenPositions[u328 .. "_Frozen"]
                                        if v13 then
                                            self:UpdateQuestionMarkIcon(u328, v13)
                                        end
                                    end
                                else
                                    if v10.Type == "EnemyQuestionMark" then
                                        FadeTween = v10.FadeTween
                                        if FadeTween then
                                            FadeTween:Cancel()
                                            v10.FadeTween = nil
                                        end
                                        Instance_3 = v10.Instance
                                        if Instance_3:IsA("TextLabel") then
                                            Position_4 = Instance_3.Position
                                            AnchorPoint = Instance_3.AnchorPoint
                                            Instance_3:Destroy()
                                            ImageLabel = Instance.new("ImageLabel")
                                            ImageLabel.Name = (Participants.Name(i2)) .. "_Enemy"
                                            ApplyEnemyIconImage(ImageLabel, i2)
                                            ImageLabel.ImageColor3 = u197
                                            ImageLabel.BackgroundTransparency = 1
                                            ImageLabel.BorderSizePixel = 0
                                            ImageLabel.Position = Position_4
                                            ImageLabel.AnchorPoint = AnchorPoint
                                            ImageLabel.ZIndex = 17
                                            ImageLabel.Visible = true
                                            ImageLabel.Parent = self.RadarContainer
                                            v10.Instance = ImageLabel
                                            v10.Type = "Enemy"
                                            self.EnemyLastSeenPositions[u328 .. "_Frozen"] = nil
                                        end
                                    end
                                    if not v5 then
                                        self:RemoveIcon(u328)
                                    else
                                        Instance_4 = v10.Instance
                                        Instance_4.Visible = true
                                        Instance_4.ImageColor3 = u197
                                        ApplyEnemyIconImage(Instance_4, i2)
                                        self:UpdateTeammateIcon(u328, v5.Position, nil)
                                        self.EnemyLastSeenPositions[u328] = v5.Position
                                    end
                                end
                                if self.Icons[u328] then
                                    self.EnemyVisibilityState[u328] = v12
                                end
                            else
                                self:RemoveIcon(u328)
                                v12 = self.EnemyLastSeenPositions[u328] or self.EnemyLastSeenPositions[u328 .. "_Frozen"]
                                if v12 then
                                    self.DeadPlayerPositions[v1] = v12
                                    if not self.Icons[v3] and not self.FadedDeadIcons[v3] then
                                        CreateDeadIcon(self, i2, v3, u197)
                                    end
                                end
                                self.EnemyVisibilityState[u328] = nil
                                self.EnemyLastSeenPositions[u328] = nil
                                self.EnemyLastSeenPositions[u328 .. "_Frozen"] = nil
                            end
                        end
                    elseif not v5 then
                        self:RemoveIcon(u328)
                    else
                        self:UpdateTeammateIcon(u328, v5.Position, nil)
                    end
                else
                    self:RemoveIcon(u328)
                    if not Position_2 and v5 then
                        Position_2 = v5.Position
                        self.DeadPlayerPositions[v1] = Position_2
                    end
                    if Position_2 and not self.Icons[v3] and not self.FadedDeadIcons[v3] then
                        if v9 then
                            v10 = u197
                        elseif Attribute_4 then
                            v11 = getRadarCharacter(i2)
                            v10 = v11 and v11:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Attribute_4]
                        else
                            v10 = nil
                        end
                        CreateDeadIcon(self, i2, v3, v10)
                    end
                    if v9 then
                        self.EnemyVisibilityState[u328] = nil
                        self.EnemyLastSeenPositions[u328] = nil
                        self.EnemyLastSeenPositions[u328 .. "_Frozen"] = nil
                    end
                end
            else
                self:RemoveIcon(u328)
                self:RemoveIcon(v3)
                self.EnemyVisibilityState[u328] = nil
                self.EnemyLastSeenPositions[u328] = nil
                self.EnemyLastSeenPositions[u328 .. "_Frozen"] = nil
                self.DeadPlayerPositions[v1] = nil
                self.FadedDeadIcons[v3] = nil
            end
        else
            self:RemoveIcon(u328)
        end
    end
    for k2, j in pairs(self.DeadPlayerPositions) do
        v1 = self.Icons[k2 .. "_Dead"]
        if v1 and self.MinimapReference then
            v5, v6 = ProjectToRadar(self, self.MinimapReference, j)
            v7 = v5 - 0.5
            v8 = v6 - 0.5
            v9 = math.sqrt(v7 * v7 + v8 * v8)
            if not (v9 > 0.5) then
                v2 = v5
                v3 = v6
            else
                v10 = v7 / v9
                v11 = v8 / v9
                v2 = v10 * 0.5 + 0.5
                v3 = v11 * 0.5 + 0.5
            end
            v1.Instance.Position = UDim2.fromScale(v2, v3)
            v1.Instance.Visible = true
        end
    end
end

local function SetBombIconAppearance(a1, a2, a3) -- Line: 1446 -- types: a1: userdata, a2: number, a3: userdata?
    if not a1:IsA("ImageLabel") and not a1:IsA("ImageButton") then
        if a1:IsA("TextLabel") or a1:IsA("TextButton") then
            a1.TextTransparency = a2
        end
        return
    end
    a1.ImageTransparency = a2
    if not a3 then
        return
    end
    a1.ImageColor3 = a3
end

function u0:UpdateBombIcon() -- Line: 1457
    -- upvalues: Profiler (val), CollectionService (val), Workspace (val), Radar (val), ProjectToRadar (val), u192 (val)
    -- upvalues: SetBombIconAppearance (val), IsVisibleToTeam (val)
    local v1, v2
    Profiler.mark("UI.Radar.UpdateBombIcon")
    local v3 = nil
    local v4 = self.Team == "Counter-Terrorists"
    local v5 = CollectionService:GetTagged("Bomb")[1]
    if Workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v5 = nil
    end
    if not v5 then
        for i, v in ipairs(CollectionService:GetTagged("WeaponDropped")) do
            if v:IsA("Model") and v.PrimaryPart and v:GetAttribute("Weapon") == "C4" then
                v3 = v
                break
            end
        end
    elseif not v5:IsA("Model") then
        for i2, i3 in ipairs(CollectionService:GetTagged("WeaponDropped")) do
            if i3:IsA("Model") and i3.PrimaryPart and i3:GetAttribute("Weapon") == "C4" then
                v3 = i3
                break
            end
        end
    elseif not v5.PrimaryPart then
        for i4, j in ipairs(CollectionService:GetTagged("WeaponDropped")) do
            if j:IsA("Model") and j.PrimaryPart and j:GetAttribute("Weapon") == "C4" then
                v3 = j
                break
            end
        end
    else
        v3 = v5
    end
    if not v3 then
        if self.Icons.Bomb then
            self.Icons.Bomb.Instance.Visible = false
            self.BombIsVisible = false
            self.BombFadeStartTime = nil
        end
        self.BombVisibilityCache = nil
        return
    end
    if not self.Icons.Bomb then
        local v6 = Radar.Bomb:Clone()
        v6.Position = UDim2.fromScale(0.5, 0.5)
        v6.AnchorPoint = Vector2.new(0.5, 0.5)
        v6.Parent = self.RadarContainer
        v6.Size = UDim2.fromOffset(14, 14)
        v6.ZIndex = 19
        v6.Name = "Bomb"
        self.Icons.Bomb = {Type = "Bomb", Instance = v6}
    end
    local Instance = self.Icons.Bomb.Instance
    if not self.MinimapReference then
        Instance.Visible = false
        return
    end
    local Position = v3.PrimaryPart.Position
    local v7, v8 = ProjectToRadar(self, self.MinimapReference, Position)
    local v9 = v7 - 0.5
    local v10 = v8 - 0.5
    local v11 = math.sqrt(v9 * v9 + v10 * v10)
    if not (v11 > 0.5) then
        v1 = v7
        v2 = v8
    else
        local v12 = v9 / v11
        local v13 = v10 / v11
        v1 = v12 * 0.5 + 0.5
        v2 = v13 * 0.5 + 0.5
    end
    Instance.Position = UDim2.fromScale(v1, v2)
    if v4 and not v5 then
        local v14 = tick()
        local BombVisibilityCache = self.BombVisibilityCache
        local Visible = if not BombVisibilityCache then nil else if not (v14 - BombVisibilityCache.UpdatedAt <= 0.1) then nil else BombVisibilityCache.Visible
        if Visible == nil then
            v10 = IsVisibleToTeam("Counter-Terrorists", Position, v3, self.LocalPlayer)
            self.BombVisibilityCache = {Visible = v10, UpdatedAt = v14}
            v7 = v10
        else
            v7 = Visible
        end
        if v7 then
            if not self.BombIsVisible then
                self.BombFadeStartTime = nil
            end
            self.BombIsVisible = true
            Instance.Visible = true
            SetBombIconAppearance(Instance, 0, u192)
            return
        end
        if self.BombIsVisible then
            self.BombFadeStartTime = v14
        end
        self.BombIsVisible = false
        if not self.BombFadeStartTime then
            Instance.Visible = false
            return
        end
        v7 = math.clamp((v14 - self.BombFadeStartTime) / 8, 0, 1)
        if v7 >= 1 then
            Instance.Visible = false
            return
        end
        Instance.Visible = true
        if not Instance:IsA("ImageLabel") and not Instance:IsA("ImageButton") then
            if not Instance:IsA("TextLabel") and not Instance:IsA("TextButton") then
                return
            end
            Instance.TextTransparency = v7
            return
        end
        Instance.ImageTransparency = v7
        return
    end
    Instance.Visible = true
    SetBombIconAppearance(Instance, 0, if not v5 then nil else if not v4 then nil else if not (v11 > 0.5) then nil else u192)
end

function u0:UpdateQuestionMarkIcon(a2, a3) -- Line: 1562
    -- upvalues: ProjectToRadar (val)
    local v1 = self.Icons[a2]
    if v1 and self.MinimapReference then
        local Instance = v1.Instance
        if Instance and Instance:IsA("TextLabel") then
            local v2, v3
            local v4, v5 = ProjectToRadar(self, self.MinimapReference, a3)
            local v6 = v4 - 0.5
            local v7 = v5 - 0.5
            local v8 = math.sqrt(v6 * v6 + v7 * v7)
            if not (v8 > 0.5) then
                v2 = v4
                v3 = v5
            else
                local v9 = v6 / v8
                local v10 = v7 / v8
                v2 = v9 * 0.5 + 0.5
                v3 = v10 * 0.5 + 0.5
            end
            Instance.Position = UDim2.fromScale(v2, v3)
            Instance.Visible = true
            return
        end
        return
    end
end

function u0:UpdateSiteIcons() -- Line: 1582 -- upvalues: Profiler (val), Radar (val), u173 (val), ProjectToRadar (val)
    local Attribute, DefaultSize, Icons, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
    Profiler.mark("UI.Radar.UpdateSiteIcons")
    local v17 = self
    for k, v in pairs(self.SiteParts) do
        v13 = "Site_" .. k
        if #v ~= 0 then
            v15 = Vector3.new(0, 0, 0)
            for i, i2 in ipairs(v) do
                v15 = v15 + i2.Position
            end
            v14 = v15 / #v
        else
            v14 = Vector3.new(0, 0, 0)
        end
        if v17.Icons[v13] then
            v15 = v17.Icons[v13]
            if v17.MinimapReference then
                v1 = 0.5 / math.clamp(v17.Settings.Zoom or 0.5, 0.1, 1)
                Attribute = workspace:GetAttribute("Map")
                v5 = if not Attribute then nil else u173[Attribute]
                v6 = v5 and v5[k]
                if not v6 then
                    v2 = nil
                    v3 = nil
                else
                    v2 = v6[1]
                    v3 = v6[2]
                end
                if v2 and v3 then
                    v2 = v2 * v1
                    v3 = v3 * v1
                end
                v4, v5 = ProjectToRadar(v17, v17.MinimapReference, v14, v2, v3)
                v8 = v4 - 0.5
                v9 = v5 - 0.5
                v10 = math.sqrt(v8 * v8 + v9 * v9)
                if not (v10 > 0.5) then
                    v6 = v4
                    v7 = v5
                else
                    v11 = v8 / v10
                    v12 = v9 / v10
                    v6 = v11 * 0.485 + 0.5
                    v7 = v12 * 0.485 + 0.5
                end
                v15.Instance.Position = UDim2.fromScale(v6, v7)
                v15.Instance.Visible = true
                DefaultSize = v15.DefaultSize
                if DefaultSize then
                    if not (v10 > 0.5) then
                        v15.Instance.Size = UDim2.new(DefaultSize.X.Scale * v1, DefaultSize.X.Offset * v1, DefaultSize.Y.Scale * v1, DefaultSize.Y.Offset * v1)
                    else
                        v15.Instance.Size = DefaultSize
                    end
                end
            else
                v15.Instance.Visible = false
            end
        else
            v15 = Radar:FindFirstChild(k)
            if v15 then
                v16 = v15:Clone()
                v16.Name = k .. "_Icon"
                v16.Position = UDim2.fromScale(0.5, 0.5)
                v16.AnchorPoint = Vector2.new(0.5, 0.5)
                v16.ZIndex = 16
                v16.Visible = true
                if v16:IsA("TextLabel") then
                    v16.TextXAlignment = Enum.TextXAlignment.Center
                    v16.TextYAlignment = Enum.TextYAlignment.Center
                end
                v16.Parent = v17.RadarContainer
                Icons = v17.Icons
                v2 = {Type = "Site", Instance = v16, DefaultSize = v15.Size}
                Icons[v13] = v2
                v15 = v17.Icons[v13]
                if v17.MinimapReference then
                    v1 = 0.5 / math.clamp(v17.Settings.Zoom or 0.5, 0.1, 1)
                    Attribute = workspace:GetAttribute("Map")
                    v5 = if not Attribute then nil else u173[Attribute]
                    v6 = v5 and v5[k]
                    if not v6 then
                        v2 = nil
                        v3 = nil
                    else
                        v2 = v6[1]
                        v3 = v6[2]
                    end
                    if v2 and v3 then
                        v2 = v2 * v1
                        v3 = v3 * v1
                    end
                    v4, v5 = ProjectToRadar(v17, v17.MinimapReference, v14, v2, v3)
                    v8 = v4 - 0.5
                    v9 = v5 - 0.5
                    v10 = math.sqrt(v8 * v8 + v9 * v9)
                    if not (v10 > 0.5) then
                        v6 = v4
                        v7 = v5
                    else
                        v11 = v8 / v10
                        v12 = v9 / v10
                        v6 = v11 * 0.485 + 0.5
                        v7 = v12 * 0.485 + 0.5
                    end
                    v15.Instance.Position = UDim2.fromScale(v6, v7)
                    v15.Instance.Visible = true
                    DefaultSize = v15.DefaultSize
                    if DefaultSize then
                        if not (v10 > 0.5) then
                            v15.Instance.Size = UDim2.new(
                                DefaultSize.X.Scale * v1,
                                DefaultSize.X.Offset * v1,
                                DefaultSize.Y.Scale * v1,
                                DefaultSize.Y.Offset * v1
                            )
                        else
                            v15.Instance.Size = DefaultSize
                        end
                    end
                else
                    v15.Instance.Visible = false
                end
            else
                warn((("Site icon template not found for: %*"):format(k)))
            end
        end
    end
end

function u0:UpdateHostageIcons() -- Line: 1657
    -- upvalues: Profiler (val), CollectionService (val), Radar (val), HideDirectionIndicators (val), Players (val)
    -- upvalues: getRadarCharacter (val), ProjectToRadar (val), GetHostageVisibility (val)
    local Attribute, Hostage, Name, Position, Team, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    Profiler.mark("UI.Radar.UpdateHostageIcons")
    local v12 = tick()
    local v13 = {}
    local v14 = self
    for i, v in ipairs(CollectionService:GetTagged("Hostage")) do
        if v:IsA("Model") and v.PrimaryPart then
            Name = v.Name
            v11 = "Hostage_" .. Name
            v13[v11] = true
            if not v14.Icons[v11] then
                Hostage = Radar:FindFirstChild("Hostage")
                v1 = (if not Hostage then Radar.Player else if not Hostage:IsA("ImageLabel") then Radar.Player else Hostage):Clone()
                v1.Position = UDim2.fromScale(0.5, 0.5)
                v1.AnchorPoint = Vector2.new(0.5, 0.5)
                v1.Parent = v14.RadarContainer
                v1.Size = UDim2.fromOffset(30, 30)
                v1.ZIndex = 18
                v1.Name = "Hostage_" .. Name
                v1.Visible = true
                HideDirectionIndicators(v1)
                v14.Icons[v11] = {Type = "Hostage", Instance = v1}
            end
            v1 = v14.Icons[v11]
            if v14.MinimapReference then
                Position = v.PrimaryPart.Position
                Attribute = v:GetAttribute("CarryingPlayer")
                if Attribute then
                    v2 = Players:FindFirstChild(Attribute)
                    v3 = if not v2 then nil else if not v2:IsA("Player") then nil else getRadarCharacter(v2)
                    if v3 and v3.PrimaryPart then
                        Position = v3.PrimaryPart.Position
                    end
                end
                v4, v5 = ProjectToRadar(v14, v14.MinimapReference, Position)
                v6 = v4 - 0.5
                v7 = v5 - 0.5
                v8 = math.sqrt(v6 * v6 + v7 * v7)
                if not (v8 > 0.5) then
                    v2 = v4
                    v3 = v5
                else
                    v9 = v6 / v8
                    v10 = v7 / v8
                    v2 = v9 * 0.5 + 0.5
                    v3 = v10 * 0.5 + 0.5
                end
                v1.Instance.Position = UDim2.fromScale(v2, v3)
                Team = v14.Team
                if Attribute == nil then
                    v1.Instance.Visible = Team == "Terrorists"
                elseif Team ~= "Terrorists" then
                    v1.Instance.Visible = true
                else
                    v1.Instance.Visible = GetHostageVisibility(v14, v11, Position, v, v12)
                end
            else
                v1.Instance.Visible = false
            end
        end
    end
    for k, i2 in pairs(v14.Icons) do
        if i2.Type == "Hostage" and not v13[k] then
            v14.HostageVisibilityCache[k] = nil
            v14:RemoveIcon(k)
        end
    end
end

function u0:UpdateMinimapTexture() -- Line: 1732 -- upvalues: Profiler (val), u150 (val), Workspace (val)
    local v1, v2
    Profiler.mark("UI.Radar.UpdateMinimapTexture")
    if not self.MinimapReference then
        return
    end
    local MinimapReference = self.MinimapReference
    local Part = MinimapReference.Part
    if Part then
        local Lower = Part:FindFirstChild("Lower")
        local Upper = Part:FindFirstChild("Upper")
        if Lower and Lower:IsA("Decal") then
            MinimapReference.Lower = Lower
        end
        if Upper and Upper:IsA("Decal") then
            MinimapReference.Upper = Upper
        end
    end
    local Lower_2 = MinimapReference.Lower or MinimapReference.Upper
    if not Lower_2 then
        return
    end
    self.MapImage.Image = Lower_2.Texture
    self.MapImage.ImageTransparency = 0
    if not Lower_2.Texture:match("%d+") then
        return
    end
    local TextureSize = MinimapReference.TextureSize
    local Attribute = workspace:GetAttribute("Map")
    local v3 = if not Attribute then nil else u150[Attribute]
    local Upper_2 = MinimapReference.Upper
    local UpperMapImage = self.UpperMapImage
    local v4 = false
    if v3 ~= nil then
        v4 = false
        if Upper_2 ~= nil then
            v4 = UpperMapImage ~= nil
        end
    end
    local TrackedPosition = self:GetTrackedPosition()
    if v4 and UpperMapImage and Upper_2 then
        UpperMapImage.Image = Upper_2.Texture
        if TrackedPosition then
            v1 = false
            if v3 ~= nil then
                v1 = v3 <= TrackedPosition.Y
            end
            UpperMapImage.ImageTransparency = if not v1 then 1 else 0
        end
    end
    local v5 = 90
    if not TrackedPosition then
        v1 = Vector2.new(0, 0)
        v2 = Vector2.new(TextureSize, TextureSize)
    else
        local v6 = Part.CFrame:PointToObjectSpace(TrackedPosition)
        local Size = MinimapReference.Size
        local X = v6.X
        local Z = v6.Z
        local v7 = -X
        local v8 = -Z
        local v9 = v7 / Size.X + 0.5
        local v10 = v8 / Size.Z + 0.5
        local v11 = TextureSize * math.clamp(self.Settings.Zoom or 0.7, 0.1, 1) * 0.5
        local v12 = math.clamp(v9 * TextureSize - v11 / 2, 0, TextureSize - v11)
        local v13 = math.clamp(v10 * TextureSize - v11 / 2, 0, TextureSize - v11)
        v1 = Vector2.new(math.floor(v12 + 0.5), (math.floor(v13 + 0.5)))
        v2 = Vector2.new(v11, v11)
        if not self.IsSpectating and self.Settings.Rotation then
            local CurrentCamera = Workspace.CurrentCamera
            if CurrentCamera then
                local LookVector = CurrentCamera.CFrame.LookVector
                local v14 = Vector3.new(LookVector.X, 0, LookVector.Z)
                local Unit = if not (v14.Magnitude < 1e-06) then v14.Unit else Vector3.new(0, 0, 1)
                if Part then
                    Unit = Part.CFrame:VectorToObjectSpace(Unit)
                end
                local X_3 = Unit.X
                local Z_3 = Unit.Z
                local v15 = -X_3
                v5 = -((math.deg((math.atan2(-Z_3, v15))) + 90) % 360) + 90 - 90
            end
        end
    end
    self.MapImage.ImageRectOffset = v1
    self.MapImage.ImageRectSize = v2
    self.MapImage.Rotation = v5
    if v4 and UpperMapImage then
        UpperMapImage.ImageRectOffset = v1
        UpperMapImage.ImageRectSize = v2
        UpperMapImage.Rotation = v5
    end
end

function u0:ApplySettings() -- Line: 1836
    -- upvalues: Profiler (val), u126 (val), u135 (val), CalculateClampedPosition (val)
    Profiler.mark("UI.Radar.ApplySettings")
    self.MapImage.Size = UDim2.fromScale(1, 1)
    if self.UpperMapImage then
        self.UpperMapImage.Size = UDim2.fromScale(1, 1)
    end
    local v1 = self.Settings.Scale or 1
    v1 = u135 * (if not u126 then v1 else (v1 - 1) * 0.5 + 1)
    self.Frame.Size = UDim2.fromOffset(v1, v1)
    self.RadarContainer.Size = UDim2.fromOffset(v1, v1)
    local v2 = UDim2.new(0, 10, 0, 10)
    self.Frame.Position = CalculateClampedPosition(self.Frame, v1, v2)
    self:UpdateMinimapTexture()
end

function u0:FlashRadarBorder() -- Line: 1857 -- upvalues: u203 (ref), u202 (val), GetPreferenceColor (val)
    if u203 and u203.Radar then
        local UIStroke = u203.Radar.UIStroke
        if not UIStroke then
            return
        end
        UIStroke.Color = u202
        if self.BorderRestoreTask then
            task.cancel(self.BorderRestoreTask)
            self.BorderRestoreTask = nil
        end
        self.BorderRestoreTask = task.delay(0.2, function() -- Line: 1878 -- upvalues: u203 (upval), GetPreferenceColor (upval), self (val)
            if u203 and u203.Radar and u203.Radar.UIStroke then
                u203.Radar.UIStroke.Color = GetPreferenceColor()
            end
            self.BorderRestoreTask = nil
        end)
        return
    end
end

function u0:ShowWeaponCircle() -- Line: 1886 -- upvalues: CreateRadarCircle (val), u135 (val), u126 (val)
    local WeaponCircle = self.WeaponCircle
    if not WeaponCircle then
        WeaponCircle = CreateRadarCircle(self, "WeaponCircle", true)
        self.WeaponCircle = WeaponCircle
    end
    local UIStroke = WeaponCircle:FindFirstChildOfClass("UIStroke")
    if not UIStroke then
        return
    end
    local v1 = u135 / 2
    local v2 = self.Settings.Scale or 1
    v1 = v1 * (if not u126 then v2 else (v2 - 1) * 0.5 + 1) * 2
    WeaponCircle.Size = UDim2.fromOffset(v1, v1)
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0
    WeaponCircle.Visible = true
    if self.WeaponCircleHideTask then
        task.cancel(self.WeaponCircleHideTask)
        self.WeaponCircleHideTask = nil
    end
    self.WeaponCircleHideTask = task.delay(0.2, function() -- Line: 1913 -- upvalues: UIStroke (val), WeaponCircle (ref), self (val)
        UIStroke.Transparency = 1
        WeaponCircle.Visible = false
        self.WeaponCircleHideTask = nil
    end)
end

function u0:ShowKnifeCircle() -- Line: 1920 -- upvalues: CreateRadarCircle (val), u148 (val), u126 (val), u135 (val)
    local v1
    local KnifeCircle = self.KnifeCircle
    if not KnifeCircle then
        KnifeCircle = CreateRadarCircle(self, "KnifeCircle", true)
        self.KnifeCircle = KnifeCircle
    end
    local UIStroke = KnifeCircle:FindFirstChildOfClass("UIStroke")
    if not UIStroke then
        return
    end
    local Settings = self.Settings
    local v2 = math.clamp(Settings.Zoom or 0.5, 0.1, 1)
    local v3 = Settings.Scale or 1
    local v4 = if not u126 then v3 else (v3 - 1) * 0.5 + 1
    local v5 = u148 * (0.5 / v2) * v4
    local v6 = u135 / 2 * v4
    local v7 = math.min(v5, v6)
    local v8 = v7 * 2
    KnifeCircle.Size = UDim2.fromOffset(v8, v8)
    UIStroke.Thickness = if not (v7 == v6) then 1 else 2
    UIStroke.Transparency = if not v1 then 0.5 else 0
    KnifeCircle.Visible = true
    task.delay(0.2, function() -- Line: 1943 -- upvalues: UIStroke (val), KnifeCircle (ref)
        UIStroke.Transparency = 1
        KnifeCircle.Visible = false
    end)
end

local function CancelRunningCircleDelay(a1) -- Line: 1949
    if a1.RunningCircleDelayTask then
        task.cancel(a1.RunningCircleDelayTask)
        a1.RunningCircleDelayTask = nil
    end
end

function u0:UpdateRunningCircle() -- Line: 1956
    -- upvalues: CharacterResolver (val), CharacterController (val), CreateRadarCircle (val), u145 (val), u126 (val)
    -- upvalues: u135 (val)
    if self.Character and self.Character.PrimaryPart then
        local v1
        if not CharacterResolver.isAliveCharacter(self.Character) then
            return
        end
        local v2 = CharacterController.getCurrentCharacter()
        if v2 then
            local GlobalDirection = v2.GlobalDirection
            local GlobalVelocity = v2.GlobalVelocity
            if not GlobalDirection or not GlobalVelocity then
                v1 = false
            else
                local Magnitude = (Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z)).Magnitude
                v1 = true
                if not (0.1 < GlobalDirection.Magnitude) then
                    v1 = Magnitude > 0.1
                end
            end
        else
            v1 = false
        end
        local v3 = CharacterController.GetWalkState() or false
        local v4 = v1 and not v3
        local IsJumping = v2 and v2.IsJumping or false
        local v5 = v4 or IsJumping
        local RunningCircle = self.RunningCircle
        if not RunningCircle then
            self.RunningCircle = (CreateRadarCircle(self, "RunningCircle", false))
        end
        local UIStroke = RunningCircle:FindFirstChildOfClass("UIStroke")
        if not UIStroke then
            return
        end
        local Settings = self.Settings
        local v6 = u145
        local v7 = math.clamp(Settings.Zoom or 0.5, 0.1, 1)
        local v8 = Settings.Scale or 1
        local v9 = if not u126 then v8 else (v8 - 1) * 0.5 + 1
        local v10 = v6 * (0.5 / v7) * v9
        local v11 = u135 / 2 * v9
        local v12 = math.min(v10, v11)
        local v13 = v12 * 2
        RunningCircle.Size = UDim2.fromOffset(v13, v13)
        UIStroke.Thickness = if not (v12 == v11) then 1 else 2
        if not v5 then
            if self.RunningCircleDelayTask then
                task.cancel(self.RunningCircleDelayTask)
                self.RunningCircleDelayTask = nil
            end
            RunningCircle.Visible = false
            UIStroke.Transparency = 1
        else
            UIStroke.Transparency = if not v6 then 0.5 else 0
            if IsJumping then
                if self.RunningCircleDelayTask then
                    task.cancel(self.RunningCircleDelayTask)
                    self.RunningCircleDelayTask = nil
                end
                RunningCircle.Visible = true
            elseif v4 then
                if not self.WasRunning then
                    if self.RunningCircleDelayTask then
                        task.cancel(self.RunningCircleDelayTask)
                        self.RunningCircleDelayTask = nil
                    end
                    RunningCircle.Visible = false
                    UIStroke.Transparency = 1
                    self.RunningCircleDelayTask = task.delay(0.4, function() -- Line: 2006 -- upvalues: self (val), CharacterController (upval), u145 (upval), u126 (upval), u135 (upval)
                        if self.Character and self.Character.PrimaryPart then
                            local v1
                            local v2 = CharacterController.getCurrentCharacter()
                            if v2 then
                                local GlobalDirection = v2.GlobalDirection
                                local GlobalVelocity = v2.GlobalVelocity
                                if not GlobalDirection or not GlobalVelocity then
                                    v1 = false
                                else
                                    local Magnitude = (Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z)).Magnitude
                                    v1 = true
                                    if not (0.1 < GlobalDirection.Magnitude) then
                                        v1 = Magnitude > 0.1
                                    end
                                end
                            else
                                v1 = false
                            end
                            v2 = CharacterController.GetWalkState() or false
                            if v1 and not v2 and self.RunningCircle then
                                local RunningCircle = self.RunningCircle
                                local UIStroke = RunningCircle:FindFirstChildOfClass("UIStroke")
                                if UIStroke then
                                    local Settings = self.Settings
                                    local v3 = u145
                                    local v4 = math.clamp(Settings.Zoom or 0.5, 0.1, 1)
                                    local v5 = Settings.Scale or 1
                                    local v6 = if not u126 then v5 else (v5 - 1) * 0.5 + 1
                                    local v7 = v3 * (0.5 / v4) * v6
                                    local v8 = u135 / 2 * v6
                                    UIStroke.Transparency = if math.min(v7, v8) ~= v8 then 0.5 else 0
                                    RunningCircle.Visible = true
                                end
                            end
                            self.RunningCircleDelayTask = nil
                            return
                        end
                        self.RunningCircleDelayTask = nil
                    end)
                elseif not self.RunningCircleDelayTask then
                    RunningCircle.Visible = true
                end
            end
        end
        self.WasRunning = v5
        return
    end
end

function u0:CreateDeadIconForPlayer(a2, a3) -- Line: 2044
    -- upvalues: Participants (val), Workspace (val), u197 (val), getRadarCharacter (val), Colors (val)
    -- upvalues: CreateDeadIcon (val), ProjectToRadar (val)
    self:RemoveIcon((Participants.Key(a2)) .. "_Player")
    local v1 = (Participants.Key(a2)) .. "_Dead"
    if not self.Icons[v1] and not self.FadedDeadIcons[v1] then
        local v2, v3
        local Attribute = a2:GetAttribute("Team")
        local v4 = true
        if Workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            v4 = Workspace:GetAttribute("ServerGamemode") == "Deathmatch"
        end
        if not v4 then
            v4 = Attribute ~= self.Team
        end
        if v4 then
            v2 = u197
        elseif Attribute then
            v3 = getRadarCharacter(a2)
            v2 = v3 and v3:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Attribute]
        else
            v2 = nil
        end
        v3 = CreateDeadIcon(self, a2, v1, v2)
        if a3 and self.MinimapReference then
            local v5, v6
            local v7, v8 = ProjectToRadar(self, self.MinimapReference, a3)
            local v9 = v7 - 0.5
            local v10 = v8 - 0.5
            local v11 = math.sqrt(v9 * v9 + v10 * v10)
            if not (v11 > 0.5) then
                v5 = v7
                v6 = v8
            else
                local v12 = v9 / v11
                local v13 = v10 / v11
                v5 = v12 * 0.5 + 0.5
                v6 = v13 * 0.5 + 0.5
            end
            v3.Position = UDim2.fromScale(v5, v6)
            v3.Visible = true
        end
        return
    end
end

function u0:Render(a2) -- Line: 2066 -- upvalues: Profiler (val) -- types: a2: number
    Profiler.mark("UI.Radar.Render")
    self.EnemyVisibilityChecksRemaining = 2
    self:UpdateMinimapTexture()
    self:UpdatePlayerIcons()
    self:UpdateBombIcon()
    self:UpdateSiteIcons()
    self:UpdateHostageIcons()
    self:UpdateRunningCircle()
end

local function DestroyUpperMapImages(a1) -- Line: 2079
    if a1.UpperMapImage then
        a1.UpperMapImage:Destroy()
        a1.UpperMapImage = nil
    end
    for i, v in ipairs(a1.RadarContainer:GetChildren()) do
        if v.Name == "UpperMap" and v:IsA("ImageLabel") then
            v:Destroy()
        end
    end
end

local function CreateUpperMapImage(a1) -- Line: 2092 -- upvalues: u150 (val)
    local Attribute = workspace:GetAttribute("Map")
    local v1 = if not Attribute then nil else u150[Attribute]
    if v1 ~= nil and a1.MinimapReference and a1.MinimapReference.Upper then
        v1 = a1.MapImage:Clone()
        v1.Name = "UpperMap"
        v1.ZIndex = 2
        v1.Parent = a1.RadarContainer
        return v1
    end
    return nil
end

function u0.new(a1, a2) -- Line: 2108
    -- upvalues: Profiler (val), u0 (val), Janitor (val), LocalPlayer (val), GetMinimapReference (val)
    -- upvalues: CreateUpperMapImage (val), IsTutorialMode (val), u217 (val), GetSiteParts (val), Router (val)
    -- upvalues: RunServiceController (val), CharacterResolver (val), Players (val), Participants (val), Remotes (val)
    -- upvalues: DestroyUpperMapImages (val)
    Profiler.mark("UI.Radar.New")
    local u9 = setmetatable({}, u0)
    u9.Janitor = Janitor.new()
    u9.Frame = a1
    u9.RadarContainer = a1.Radar
    u9.MapImage = a1.Radar.Map
    u9.MapImage.AnchorPoint = Vector2.new(0.5, 0.5)
    u9.MapImage.Position = UDim2.fromScale(0.5, 0.5)
    u9.MapImage.ZIndex = 1
    u9.LocalPlayer = LocalPlayer
    u9.Character = a2
    u9.Team = LocalPlayer:GetAttribute("Team")
    u9.MinimapReference = GetMinimapReference()
    u9.UpperMapImage = CreateUpperMapImage(u9)
    if u9.UpperMapImage then
        u9.UpperMapImage.BackgroundTransparency = 1
    end
    u9.Frame.Visible = not IsTutorialMode()
    u9.Janitor:Add(function() -- Line: 2141 -- upvalues: u9 (val), IsTutorialMode (upval)
        u9.Frame.Visible = not IsTutorialMode()
    end)
    u9.Settings = u217
    u9.IsSpectating = false
    u9.Icons = {}
    u9.SiteParts = GetSiteParts()
    u9.DeadPlayerPositions = {}
    u9.FadedDeadIcons = {}
    u9.EnemyVisibilityState = {}
    u9.EnemyLastSeenPositions = {}
    u9.EnemyVisibilityCache = {}
    u9.EnemyVisibilityChecksRemaining = 0
    u9.HostageVisibilityCache = {}
    u9.WasRunning = false
    u9.BombIsVisible = false
    u9:ApplySettings()
    local broadcastRouter = Router.broadcastRouter

    function Router.broadcastRouter(a1, ...) -- Line: 2173
        -- upvalues: broadcastRouter (val), u9 (val)
        local v1 = broadcastRouter(a1, ...)
        if a1 == "UpdatePlayerNoiseCone" then
            local v2, v3 = ...
            if v3
                and u9.Character
                and u9.Character.PrimaryPart
                and (v3 - u9.Character.PrimaryPart.Position).Magnitude < 5 then
                if v2 == "Melee" then
                    u9:ShowKnifeCircle()
                    return v1
                end
                if v2 == "Weapon" then
                    u9:ShowWeaponCircle()
                    u9:FlashRadarBorder()
                end
            end
        end
        return v1
    end

    u9.Janitor:Add(function() -- Line: 2194 -- upvalues: Router (upval), broadcastRouter (val)
        Router.broadcastRouter = broadcastRouter
    end)
    local u78 = 0
    u9.Janitor:Add((RunServiceController.BindToRenderStep("UI.Radar.Update", function(a1) -- Line: 2200 -- upvalues: Profiler (upval), u78 (ref), u9 (val) -- types: a1: number
        Profiler.mark("UI.Radar.RenderStepped")
        u78 = u78 + a1
        if u78 >= 0.016666666666666666 then
            u9:Render(a1)
            u78 = math.min(u78 - 0.016666666666666666, 0.008333333333333333)
        end
    end)))
    u9.Janitor:Add(((LocalPlayer:GetAttributeChangedSignal("Team")):Connect(function() -- Line: 2211 -- upvalues: u9 (val)
        u9:RefreshIconsOnTeamChange()
    end)))

    local function setupPlayerListeners(a1) -- Line: 2216
        -- upvalues: u9 (val), CharacterResolver (upval)
        if a1 == u9.LocalPlayer then
            return
        end
        u9.Janitor:Add(((a1:GetAttributeChangedSignal("Team")):Connect(function() -- Line: 2221 -- upvalues: u9 (upval), a1 (val)
            u9:RefreshPlayerIcon(a1)
        end)))
        u9.Janitor:Add((CharacterResolver.observeCharacter(a1, function(a1_2, a2) -- Line: 2225 -- upvalues: u9 (upval), a1 (val)
            if a1_2 ~= a2 then
                u9:RefreshPlayerIcon(a1)
            end
            return nil
        end)))
    end

    for i, v in ipairs(Players:GetPlayers()) do
        setupPlayerListeners(v)
    end
    u9.Janitor:Add((Players.PlayerAdded:Connect(setupPlayerListeners)))
    u9.Janitor:Add((Players.PlayerRemoving:Connect(function(a1) -- Line: 2240 -- upvalues: u9 (val) -- types: a1: userdata
        for k, v in pairs(u9.Icons) do
            if v.Player == a1 then
                u9:RemoveIcon(k)
            end
        end
        u9.DeadPlayerPositions[a1.UserId] = nil
        u9.FadedDeadIcons[a1.UserId .. "_Dead"] = nil
        u9.EnemyVisibilityCache[a1.UserId .. "_Player"] = nil
    end)))
    local u139 = {}
    u9.Janitor:Add((Participants.Observe(function(a1) -- Line: 2253 -- upvalues: u139 (val), u9 (val) -- types: a1: userdata
        if not a1:IsA("Player") and not u139[a1] then
            local function refresh() -- Line: 2257 -- upvalues: u9 (upval), a1 (val)
                u9:RefreshPlayerIcon(a1)
            end

            u139[a1] = {
                (a1:GetAttributeChangedSignal("Team")):Connect(refresh),
                ((a1:GetAttributeChangedSignal("Generation")):Connect(refresh)),
            }
            return
        end
    end, function(a1) -- Line: 2265 -- upvalues: u139 (val), u9 (val) -- types: a1: userdata
        if a1:IsA("Player") then
            return
        end
        local v1 = u139[a1]
        if v1 then
            for i, j in v1 do
                j:Disconnect()
            end
            u139[a1] = nil
        end
        for k, v in pairs(u9.Icons) do
            if v.Player == a1 then
                u9:RemoveIcon(k)
            end
        end
        u9:RefreshPlayerIcon(a1)
    end)))
    u9.Janitor:Add(function() -- Line: 2283 -- upvalues: u139 (val)
        local v1 = nil
        local v2 = nil
        for i, j in u139, v1, v2 do
            for k, n in j do
                n:Disconnect()
            end
        end
        table.clear(u139)
    end)
    u9.Janitor:Add((Remotes.UI.UIPlayerKilled.Listen(function(a1) -- Line: 2293 -- upvalues: Participants (upval), LocalPlayer (upval), u9 (val)
        local v1 = Participants.FromKey(a1.Victim)
        if v1 and v1 ~= LocalPlayer then
            local DeathPosition = a1.DeathPosition
            if not DeathPosition then
                return
            end
            u9.DeadPlayerPositions[Participants.Key(v1)] = DeathPosition
            u9:CreateDeadIconForPlayer(v1, DeathPosition)
            return
        end
    end)))
    u9.Janitor:Add(((workspace:GetAttributeChangedSignal("Map")):Connect(function() -- Line: 2310
        -- upvalues: u9 (val), GetMinimapReference (upval), GetSiteParts (upval), DestroyUpperMapImages (upval)
        -- upvalues: CreateUpperMapImage (upval)
        u9.MinimapReference = GetMinimapReference()
        u9.SiteParts = GetSiteParts()
        DestroyUpperMapImages(u9)
        u9.MapImage.Image = ""
        u9.MapImage.ImageTransparency = 0
        u9.MapImage.ImageRectOffset = Vector2.new(0, 0)
        u9.MapImage.ImageRectSize = Vector2.new(1024, 1024)
        u9.MapImage.Rotation = 0
        u9.MapImage.Visible = true
        u9.MapImage.Size = UDim2.fromScale(1, 1)
        u9.UpperMapImage = CreateUpperMapImage(u9)
        u9:UpdateMinimapTexture()
        for k in pairs(u9.Icons) do
            u9:RemoveIcon(k)
        end
        table.clear(u9.EnemyVisibilityState)
        table.clear(u9.EnemyLastSeenPositions)
        table.clear(u9.EnemyVisibilityCache)
        table.clear(u9.HostageVisibilityCache)
        u9.BombVisibilityCache = nil
        table.clear(u9.DeadPlayerPositions)
        table.clear(u9.FadedDeadIcons)
    end)))
    u9.Janitor:Add(function() -- Line: 2342 -- upvalues: u9 (val), DestroyUpperMapImages (upval)
        for k, v in pairs(u9.Icons) do
            if v.Instance and v.Instance.Parent then
                v.Instance:Destroy()
            end
        end
        table.clear(u9.Icons)
        table.clear(u9.EnemyVisibilityState)
        table.clear(u9.EnemyLastSeenPositions)
        DestroyUpperMapImages(u9)
        local v1 = u9
        if v1.RunningCircleDelayTask then
            task.cancel(v1.RunningCircleDelayTask)
            v1.RunningCircleDelayTask = nil
        end
        if u9.RunningCircle then
            u9.RunningCircle:Destroy()
            u9.RunningCircle = nil
        end
        if u9.KnifeCircle then
            u9.KnifeCircle:Destroy()
            u9.KnifeCircle = nil
        end
        if u9.WeaponCircleHideTask then
            task.cancel(u9.WeaponCircleHideTask)
            u9.WeaponCircleHideTask = nil
        end
        if u9.WeaponCircle then
            u9.WeaponCircle:Destroy()
            u9.WeaponCircle = nil
        end
        v1 = u9
        if v1.BorderRestoreTask then
            task.cancel(v1.BorderRestoreTask)
            v1.BorderRestoreTask = nil
        end
    end)
    return u9
end

function u0:Destroy() -- Line: 2385
    self.Janitor:Destroy()
end

function u0.Initialize(a1, a2) -- Line: 2392
    -- upvalues: Profiler (val), u203 (ref), IsTutorialMode (val), u204 (val), DataController (val), LocalPlayer (val)
    -- upvalues: u217 (val), u218 (ref), GetPreferenceColor (val), CharacterResolver (val), u202 (val)
    Profiler.mark("UI.Radar.Initialize")
    u203 = a2

    local function syncTutorialVisibility() -- Line: 2403 -- upvalues: IsTutorialMode (upval), u203 (upval)
        if IsTutorialMode() then
            u203.Visible = false
        end
    end

    if IsTutorialMode() then
        u203.Visible = false
    end
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(syncTutorialVisibility)
    ;(workspace:GetAttributeChangedSignal("ServerGamemode")):Connect(syncTutorialVisibility)
    for i, j in u204 do
        DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet." .. j[1], function(a1) -- Line: 2415 -- upvalues: u217 (upval), j (val), u218 (upval)
            u217[j[2]] = a1
            if u218 then
                u218:ApplySettings()
            end
        end)
    end
    u203.Radar.UIStroke.Color = GetPreferenceColor()
    CharacterResolver.observeCharacter(LocalPlayer, function() -- Line: 2427 -- upvalues: u203 (upval), GetPreferenceColor (upval)
        u203.Radar.UIStroke.Color = GetPreferenceColor()
        return nil
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 2433 -- upvalues: u203 (upval), u218 (upval), u202 (upval), GetPreferenceColor (upval)
        if u203 and u203.Radar and u203.Radar.UIStroke then
            local UIStroke = u203.Radar.UIStroke
            local v1 = false
            if u218 ~= nil then
                v1 = u218.BorderRestoreTask ~= nil
            end
            if not v1 or UIStroke.Color ~= u202 then
                UIStroke.Color = GetPreferenceColor()
            end
        end
    end)
end

local function observeBotCharacter(a1, a2) -- Line: 2446
    -- upvalues: getRadarCharacter (val)
    local u4 = getRadarCharacter(a1)
    a2(u4)

    local function refresh() -- Line: 2449 -- upvalues: getRadarCharacter (upval), a1 (val), u4 (ref), a2 (val)
        local v1 = getRadarCharacter(a1)
        if v1 ~= u4 then
            u4 = v1
            a2(v1)
        end
    end

    local u9 = {}
    u9[1] = (a1:GetAttributeChangedSignal("Generation")):Connect(refresh)
    local Characters = workspace:FindFirstChild("Characters")
    if Characters then
        table.insert(u9, (Characters.ChildAdded:Connect(refresh)))
        table.insert(u9, (Characters.ChildRemoved:Connect(refresh)))
    end
    return function() -- Line: 2462 -- upvalues: u9 (val)
        for i, j in u9 do
            j:Disconnect()
        end
    end
end

local function observeRadarTarget(a1, a2) -- Line: 2469
    -- upvalues: u219 (ref), createRadarInstance (val), SpectateController (val), LocalPlayer (val), Profiler (val)
    -- upvalues: u218 (ref), u0 (val), u203 (ref), CharacterResolver (val), observeBotCharacter (val)
    if u219 then
        u219()
        u219 = nil
    end

    local function onCharacter(a1_2) -- Line: 2475
        -- upvalues: createRadarInstance (upval), a1 (val), a2 (val), SpectateController (upval), LocalPlayer (upval)
        -- upvalues: Profiler (upval), u218 (upval), u0 (upval), u203 (upval)
        if a1_2 and a1_2:IsDescendantOf(workspace) then
            createRadarInstance(a1_2, a1, a2)
            return
        end
        if not SpectateController.IsFreecamActive() then
            if u218 and u218.LocalPlayer == a1 then
                u218:Destroy()
                u218 = nil
            end
            return
        end
        local v1 = LocalPlayer
        Profiler.mark("UI.Radar.CreateRadarForCharacter")
        if u218 then
            u218:Destroy()
            u218 = nil
        end
        local v2 = u0.new(u203, nil)
        u218 = v2
        v2.LocalPlayer = v1
        v2.Team = v1:GetAttribute("Team")
        v2.IsSpectating = true
        v2.MapImage.Rotation = 90
        if not v2.UpperMapImage then
            return
        end
        v2.UpperMapImage.Rotation = 90
    end

    if a1:IsA("Player") then
        u219 = CharacterResolver.observeCharacter(a1, function(a1) -- Line: 2488 -- upvalues: onCharacter (val) -- types: a1: userdata?
            onCharacter(a1)
            if not a1 then
                return nil
            end
            local u8 = a1:IsDescendantOf(workspace)
            local u13 = a1.AncestryChanged:Connect(function() -- Line: 2497 -- upvalues: a1 (val), u8 (ref), onCharacter (upval)
                local v1 = a1:IsDescendantOf(workspace)
                if v1 ~= u8 then
                    u8 = v1
                    onCharacter(a1)
                end
            end)
            return function() -- Line: 2504 -- upvalues: u13 (val)
                u13:Disconnect()
            end
        end)
        return
    end
    u219 = observeBotCharacter(a1, onCharacter)
end

function u0.Start() -- Line: 2513
    -- upvalues: observeRadarTarget (val), LocalPlayer (val), SpectateController (val), u218 (ref), Profiler (val)
    -- upvalues: u0 (val), u203 (ref)
    observeRadarTarget(LocalPlayer, false)
    SpectateController.ListenToSpectate:Connect(function(a1) -- Line: 2517 -- upvalues: observeRadarTarget (upval), LocalPlayer (upval) -- types: a1: userdata?
        if a1 then
            observeRadarTarget(a1, true)
            return
        end
        observeRadarTarget(LocalPlayer, false)
    end)
    SpectateController.ListenToFreecam:Connect(function() -- Line: 2526 -- upvalues: u218 (upval), LocalPlayer (upval), Profiler (upval), u0 (upval), u203 (upval)
        if not u218 then
            local v1 = LocalPlayer
            Profiler.mark("UI.Radar.CreateRadarForCharacter")
            if u218 then
                u218:Destroy()
                u218 = nil
            end
            local v2 = u0.new(u203, nil)
            u218 = v2
            v2.LocalPlayer = v1
            v2.Team = v1:GetAttribute("Team")
            v2.IsSpectating = true
            v2.MapImage.Rotation = 90
            if v2.UpperMapImage then
                v2.UpperMapImage.Rotation = 90
            end
        end
    end)
end

return u0