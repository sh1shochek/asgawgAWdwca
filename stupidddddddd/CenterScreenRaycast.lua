-- ReplicatedStorage.Components.Common.CenterScreenRaycast
-- Script path: ReplicatedStorage.Components.Common.CenterScreenRaycast
-- Decompile time: 3.43 ms

local u0 = {}
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local LocalPlayer = Players.LocalPlayer
local u32 = RaycastParams.new()
u32.FilterType = Enum.RaycastFilterType.Exclude
u32.IgnoreWater = true
local u35 = 0
local u36 = -1
local u37 = nil
local u38 = nil
local u39 = nil
local u40 = 0
local u41 = nil
RunServiceController.BindToHeartbeat("Components.CenterScreenRaycast.InvalidateCache", function() -- Line: 36 -- upvalues: u35 (ref)
    u35 = u35 + 1
end)

local function ClearCache() -- Line: 40 -- upvalues: u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref)
    u36 = -1
    u37 = nil
    u38 = nil
    u39 = nil
    u40 = 0
    u41 = nil
end

local function ResolveRaycast(a1) -- Line: 49
    -- upvalues: Workspace (val), CharacterResolver (val), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref)
    -- upvalues: u41 (ref), u35 (ref), u32 (val)
    local CurrentCamera = Workspace.CurrentCamera
    local v1 = CharacterResolver.getLocalCharacter()
    if CurrentCamera and v1 then
        local CFrame = CurrentCamera.CFrame
        local v2 = false
        if u36 == u35 then
            v2 = false
            if u37 == CurrentCamera then
                v2 = false
                if u39 == v1 then
                    v2 = false
                    if u38 == CFrame then
                        v2 = a1 <= u40
                    end
                end
            end
        end
        if v2 then
            return u41
        end
        local Map = Workspace:FindFirstChild("Map")
        local Barriers = if not Map then nil else Map:FindFirstChild("Barriers")
        u32.FilterDescendantsInstances = if not Barriers then {v1, CurrentCamera} else {v1, CurrentCamera, Barriers}
        u41 = Workspace:Raycast(CFrame.Position, CFrame.LookVector * a1, u32)
        u36 = u35
        u37 = CurrentCamera
        u38 = CFrame
        u39 = v1
        u40 = a1
        return u41
    end
    u36 = -1
    u37 = nil
    u38 = nil
    u39 = nil
    u40 = 0
    u41 = nil
    return nil
end

function u0.GetResult(a1) -- Line: 82 -- upvalues: ResolveRaycast (val) -- types: a1: number?
    local v1 = a1 or 10
    local v2 = ResolveRaycast(v1)
    if v2 and not (v1 < v2.Distance) then
        return v2
    end
    return nil
end

function u0.GetInstance(a1) -- Line: 91 -- upvalues: u0 (val) -- types: a1: number?
    local v1 = u0.GetResult(a1)
    if v1 then
        return v1.Instance
    end
    return nil
end

function u0.FindTaggedAncestor(a1, a2) -- Line: 96
    -- upvalues: u0 (val), CollectionService (val)
    local Parent = u0.GetInstance(a2)
    while Parent do
        if CollectionService:HasTag(Parent, a1) then
            return Parent
        end
        Parent = Parent.Parent
    end
    return nil
end

local function RayEntersBox(a1, a2, a3, a4, a5) -- Line: 108
    -- upvalues: 
    local v1, v2, v3, v4, v5, v6
    local v7 = a1:PointToObjectSpace(a3)
    local v8 = a1:VectorToObjectSpace(a4)
    local v9 = a2 / 2
    local v10 = 0
    local v11 = a5
    local v12 = {"X", "Y", "Z"}
    local v13 = nil
    local v14 = nil
    for i, j in v12, v13, v14 do
        v1 = v7[j]
        v2 = v8[j]
        v3 = v9[j]
        v4 = math.abs(v2)
        if not (v4 < 1e-06) then
            v4 = (-v3 - v1) / v2
            v5 = (v3 - v1) / v2
            if v5 < v4 then
                v6 = v5
                v5 = v4
                v4 = v6
            end
            v10 = math.max(v10, v4)
            v11 = math.min(v11, v5)
            if v11 < v10 then
                return nil
            end
        elseif v3 < math.abs(v1) then
            return nil
        end
    end
    return v10
end

function u0.FindTaggedModelInSight(a1, a2) -- Line: 138
    -- upvalues: u0 (val), Workspace (val), CharacterResolver (val), CollectionService (val), RayEntersBox (val)
    local v1 = a2 or 10
    local v2 = u0.FindTaggedAncestor(a1, v1)
    if v2 and v2:IsA("Model") then
        return v2
    end
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera and CharacterResolver.getLocalCharacter() then
        local BoundingBox, BoundingBox_2, Magnitude, v3
        local Position = CurrentCamera.CFrame.Position
        local LookVector = CurrentCamera.CFrame.LookVector
        local v4 = u0.GetResult(v1)
        local v5 = nil
        local v6 = (1 / 0)
        for i, j in CollectionService:GetTagged(a1) do
            if j:IsA("Model") and j:GetAttribute("Destroyed") ~= true then
                BoundingBox, BoundingBox_2 = j:GetBoundingBox()
                Magnitude = (BoundingBox.Position - Position).Magnitude
                if not (v1 + BoundingBox_2.Magnitude / 2 < Magnitude) then
                    v3 = RayEntersBox(BoundingBox, BoundingBox_2, Position, LookVector, v1)
                    if v3 ~= nil and not (v6 <= v3) then
                        if not v4 or not (v4.Distance < v3 - 0.25) or v4.Instance:IsDescendantOf(j) then
                            v5 = j
                        end
                    end
                end
            end
        end
        return v5
    end
    return nil
end

function u0.GetHoveredHostage(a1) -- Line: 175 -- upvalues: LocalPlayer (val), u0 (val) -- types: a1: number?
    if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" then
        return nil
    end
    local v1 = u0.FindTaggedAncestor("Hostage", a1 or 5)
    if v1 and v1:IsA("Model") then
        if v1:GetAttribute("CanRescue") ~= true then
            return nil
        end
        local Attribute = v1:GetAttribute("RescuingPlayer")
        if Attribute and Attribute ~= LocalPlayer.Name then
            return nil
        end
        if v1:GetAttribute("CarryingPlayer") then
            return nil
        end
        return v1
    end
    return nil
end

return u0