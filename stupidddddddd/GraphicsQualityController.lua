-- ReplicatedStorage.Controllers.GraphicsQualityController
-- Script path: ReplicatedStorage.Controllers.GraphicsQualityController
-- Decompile time: 4.55 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MaterialService = game:GetService("MaterialService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local PotatoColors = require(script.PotatoColors)
local u34 = {BloomEffect = true, SunRaysEffect = true, DepthOfFieldEffect = true, Clouds = true}
local u35 = {SurfaceAppearance = true, Texture = true}
local LocalPlayer = Players.LocalPlayer
local u37 = false
local u38 = {}
local u39 = {}
local u43 = setmetatable({}, {__mode = "k"})
local u47 = setmetatable({}, {__mode = "k"})

local function assetIdOf(a1) -- Line: 69 -- types: a1: string
    return (tonumber((string.match(a1, "(%d+)$"))))
end

local function colorOf(a1) -- Line: 75
    return Color3.fromRGB(a1[1], a1[2], a1[3])
end

local function multiplyColors(a1, a2) -- Line: 81 -- types: a1: userdata, a2: userdata
    return Color3.new(a1.R * a2.R, a1.G * a2.G, a1.B * a2.B)
end

local function tintForMaterialVariant(a1) -- Line: 89
    -- upvalues: u43 (val), u39 (val), PotatoColors (val)
    if u43[a1] then
        return
    end
    u43[a1] = true
    local MaterialVariant = if a1.MaterialVariant == "" then u39[a1.Material] else a1.MaterialVariant
    local v1 = if not MaterialVariant then nil else PotatoColors.MaterialVariants[("%*/%*"):format(a1.Material.Name, MaterialVariant)]
    if v1 then
        local Color = a1.Color
        local v2 = Color3.fromRGB(v1[1], v1[2], v1[3])
        a1.Color = Color3.new(Color.R * v2.R, Color.G * v2.G, Color.B * v2.B)
    end
end

local function tintForRemovedSurface(a1) -- Line: 106 -- upvalues: PotatoColors (val), u47 (val) -- types: a1: userdata
    local Parent = a1.Parent
    if Parent and Parent:IsA("BasePart") then
        local Color, Color3_2, Texture_2, v1, v2, v3
        local v4 = 1
        local v5 = 1
        if a1:IsA("Texture") then
            v3 = tonumber((string.match(a1.Texture, "(%d+)$")))
            v2 = if not v3 then nil else PotatoColors.Textures[v3]
            Texture_2 = a1.Texture
            Color3_2 = a1.Color3
            v4 = 1 - a1.Transparency
            if v2 and Texture_2 then
                if a1:IsA("Texture") or a1.AlphaMode == Enum.AlphaMode.Overlay then
                    v5 = v2[4]
                end
                v3 = u47[Parent]
                if not v3 then
                    u47[Parent] = {}
                end
                if v3[Texture_2] then
                    return
                end
                v3[Texture_2] = true
                Color = Parent.Color
                v1 = Color3.fromRGB(v2[1], v2[2], v2[3])
                Parent.Color = Color:Lerp(Color3.new(v1.R * Color3_2.R, v1.G * Color3_2.G, v1.B * Color3_2.B), v5 * v4)
                return
            end
            return
        end
        if a1:IsA("SurfaceAppearance") and Parent:IsA("MeshPart") then
            v3 = tonumber((string.match(Parent.MeshId, "(%d+)$")))
            v2 = if not v3 then nil else PotatoColors.SurfaceAppearances[v3]
            Texture_2 = "SurfaceAppearance"
            Color3_2 = a1.Color
            if v2 and Texture_2 then
                if a1:IsA("Texture") or a1.AlphaMode == Enum.AlphaMode.Overlay then
                    v5 = v2[4]
                end
                v3 = u47[Parent]
                if not v3 then
                    u47[Parent] = {}
                end
                if v3[Texture_2] then
                    return
                end
                v3[Texture_2] = true
                Color = Parent.Color
                v1 = Color3.fromRGB(v2[1], v2[2], v2[3])
                Parent.Color = Color:Lerp(Color3.new(v1.R * Color3_2.R, v1.G * Color3_2.G, v1.B * Color3_2.B), v5 * v4)
                return
            end
            return
        end
        return
    end
end

local function stripMaterialInstance(a1) -- Line: 157 -- types: a1: userdata
    if a1:IsA("MaterialVariant") then
        a1:Destroy()
    end
end

local function stripEffectInstance(a1) -- Line: 165 -- upvalues: u34 (val) -- types: a1: userdata
    if u34[a1.ClassName] then
        a1:Destroy()
    end
end

local function isInsideRig(a1) -- Line: 175 -- upvalues: Workspace (val) -- types: a1: userdata
    local Parent = a1.Parent
    while Parent do
        if Parent == Workspace then
            break
        end
        if Parent:IsA("Model") then
            if not Parent:FindFirstChild("HumanoidRootPart")
                and not Parent:FindFirstChildOfClass("Humanoid")
                and not Parent:FindFirstChildOfClass("AnimationController") then
                Parent = Parent.Parent
                continue
            end
            return true
        end
        Parent = Parent.Parent
    end
    return false
end

local function stripMapInstance(a1) -- Line: 195
    -- upvalues: u35 (val), isInsideRig (val), tintForRemovedSurface (val), tintForMaterialVariant (val)
    if not u35[a1.ClassName] and not a1:IsA("BasePart") then
        if u35[a1.ClassName] then
            tintForRemovedSurface(a1)
            a1:Destroy()
            return
        end
        if a1:IsA("BasePart") then
            a1.CastShadow = false
            tintForMaterialVariant(a1)
            return
        end
        if a1:IsA("Light") then
            a1.Shadows = false
        end
        return
    end
    if isInsideRig(a1) then
        return
    end
    if u35[a1.ClassName] then
        tintForRemovedSurface(a1)
        a1:Destroy()
        return
    end
    if a1:IsA("BasePart") then
        a1.CastShadow = false
        tintForMaterialVariant(a1)
        return
    end
    if a1:IsA("Light") then
        a1.Shadows = false
    end
end

local function stripContainer(a1, a2, a3) -- Line: 216 -- types: a1: userdata, a2: function, a3: boolean
    (if not a3 then a1.ChildAdded else a1.DescendantAdded):Connect(function(a1) -- Line: 219 -- upvalues: a2 (val) -- types: a1: userdata
        task.defer(a2, a1)
    end)
    local v1 = if not a3 then a1:GetChildren() else a1:GetDescendants()
    local v2 = nil
    local v3 = nil
    for i, j in v1, v2, v3 do
        if j.Parent then
            a2(j)
        end
        if i % 2000 == 0 then
            task.wait()
        end
    end
end

local function resetBaseMaterialOverrides() -- Line: 238 -- upvalues: MaterialService (val), u39 (val)
    local result, success
    for i, j in Enum.Material:GetEnumItems() do
        success, result = pcall(MaterialService.GetBaseMaterialOverride, MaterialService, j)
        if success and result ~= "" then
            u39[j] = result
        end
        pcall(MaterialService.SetBaseMaterialOverride, MaterialService, j, "")
    end
end

local function stopAnimatedProps() -- Line: 250 -- upvalues: u38 (ref)
    local v1 = u38
    u38 = {}
    for i, j in v1 do
        task.spawn(j)
    end
end

local function applyPotatoMode() -- Line: 260
    -- upvalues: u37 (ref), stopAnimatedProps (val), resetBaseMaterialOverrides (val), stripContainer (val)
    -- upvalues: MaterialService (val), stripMaterialInstance (val), Lighting (val), stripEffectInstance (val)
    -- upvalues: Workspace (val), stripMapInstance (val)
    if u37 then
        return
    end
    u37 = true
    stopAnimatedProps()
    resetBaseMaterialOverrides()
    task.spawn(stripContainer, MaterialService, stripMaterialInstance, true)
    task.spawn(stripContainer, Lighting, stripEffectInstance, false)
    task.spawn(stripContainer, Workspace.Terrain, stripEffectInstance, false)
    local Map = Workspace:FindFirstChild("Map")
    if Map then
        task.spawn(stripContainer, Map, stripMapInstance, true)
    end
    Workspace.ChildAdded:Connect(function(a1) -- Line: 277 -- upvalues: stripContainer (upval), stripMapInstance (upval) -- types: a1: userdata
        if a1.Name == "Map" then
            task.spawn(stripContainer, a1, stripMapInstance, true)
        end
    end)
end

function v1.RunAnimatedProp(a1) -- Line: 291 -- upvalues: u37 (ref), u38 (ref) -- types: a1: function
    if u37 then
        return nil
    end
    local u4 = a1()
    if not u4 then
        return nil
    end
    local u6 = {}
    u38[u6] = u4
    return function() -- Line: 304 -- upvalues: u38 (upval), u6 (val), u4 (val)
        if u38[u6] then
            u38[u6] = nil
            u4()
        end
    end
end

function v1.Start() -- Line: 315 -- upvalues: DataController (val), LocalPlayer (val), applyPotatoMode (val)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Potato Mode", function(a1) -- Line: 317 -- upvalues: applyPotatoMode (upval)
        if a1 == true then
            applyPotatoMode()
        end
        return nil
    end)
end

return v1