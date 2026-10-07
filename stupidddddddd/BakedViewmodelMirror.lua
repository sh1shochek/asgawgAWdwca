-- ReplicatedStorage.Shared.BakedViewmodelMirror
-- Script path: ReplicatedStorage.Shared.BakedViewmodelMirror
-- Decompile time: 10.54 ms

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ViewmodelHand = require(ReplicatedStorage.Shared.ViewmodelHand)
local u32 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, 1)
local u46 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, -1)
local u47 = {SurfaceAppearance = true, Decal = true, Texture = true}
local u48 = {}
u48.__index = u48
local u49 = {}
local u50 = {}
local u51 = {}
local u52 = {}
local u53 = false
local u54 = {}
local u55 = false
local u56 = false
local u57 = false
local u58 = 0
local u59 = {}

local function isLoaded(a1) -- Line: 32 -- upvalues: u50 (val), ContentProvider (val) -- types: a1: userdata
    local MeshId = a1.MeshId
    if u50[MeshId] then
        return true
    end
    if (ContentProvider:GetAssetFetchStatus(MeshId)) ~= Enum.AssetFetchStatus.Success then
        return false
    end
    u50[MeshId] = true
    return true
end

local function waitForQuiet() -- Line: 44 -- upvalues: u58 (ref)
    local v1 = os.clock() - u58
    while v1 < 2 do
        task.wait(2 - v1)
        v1 = os.clock() - u58
    end
end

local function runDownloads() -- Line: 53
    -- upvalues: u52 (val), waitForQuiet (val), u51 (val), u50 (val), ContentProvider (val), u53 (ref)
    local MeshId, v1, v2, v3
    while true do
        if not (#u52 > 0) then
            break
        end
        waitForQuiet()
        v1 = {}
        while #v1 < 8 do
            if not (#u52 > 0) then
                break
            end
            v2 = table.remove(u52, 1)
            u51[v2.MeshId] = nil
            MeshId = v2.MeshId
            if u50[MeshId] then
                v3 = true
            elseif (ContentProvider:GetAssetFetchStatus(MeshId)) ~= Enum.AssetFetchStatus.Success then
                v3 = false
            else
                u50[MeshId] = true
                v3 = true
            end
            if not v3 then
                table.insert(v1, v2)
            end
        end
        if #v1 > 0 then
            pcall(ContentProvider.PreloadAsync, ContentProvider, v1)
            task.wait(0.25)
        end
    end
    u53 = false
end

local function queueDownloads(a1) -- Line: 72
    -- upvalues: u51 (val), u50 (val), u52 (val), u53 (ref), runDownloads (val)
    for i, j in a1 do
        if not u51[j.MeshId] and not u50[j.MeshId] then
            u51[j.MeshId] = true
            table.insert(u52, j)
        end
    end
    if not u53 and #u52 > 0 then
        u53 = true
        task.spawn(runDownloads)
    end
end

local function runBuilds() -- Line: 86 -- upvalues: u54 (val), waitForQuiet (val), RunService (val), u55 (ref)
    local v1
    while true do
        if not (#u54 > 0) then
            break
        end
        waitForQuiet()
        RunService.Heartbeat:Wait()
        v1 = table.remove(u54, 1)
        if v1.Model and not v1.Twins then
            v1:BuildTwins()
        end
    end
    u55 = false
end

local function queueBuild(a1) -- Line: 98 -- upvalues: u54 (val), u55 (ref), runBuilds (val)
    table.insert(u54, a1)
    if not u55 then
        u55 = true
        task.spawn(runBuilds)
    end
end

local function preloadBothHands(a1) -- Line: 107 -- upvalues: ContentProvider (val)
    local v1 = {}
    for i, j in a1.Entries do
        table.insert(v1, j.part)
        table.insert(v1, j.bake)
    end
    task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, v1)
end

local function activate() -- Line: 117
    -- upvalues: u56 (ref), u49 (val), u54 (val), u55 (ref), runBuilds (val), preloadBothHands (val)
    -- upvalues: ReplicatedStorage (val), queueDownloads (val)
    if u56 then
        return
    end
    u56 = true
    local v1 = {}
    local v2 = nil
    local v3 = nil
    for i in u49, v2, v3 do
        table.insert(u54, i)
        if not u55 then
            u55 = true
            task.spawn(runBuilds)
        end
        preloadBothHands(i)
    end
    local ViewmodelMirrors = ReplicatedStorage:FindFirstChild("ViewmodelMirrors")
    for j, k in if not ViewmodelMirrors then {} else ViewmodelMirrors:GetChildren() do
        if k:IsA("MeshPart") then
            table.insert(v1, k)
        end
    end
    queueDownloads(v1)
end

local function modifierSet(a1) -- Line: 137 -- types: a1: userdata
    local v1 = {a1}
    for i, j in a1:GetChildren() do
        if j:IsA("Decal") then
            table.insert(v1, j)
        end
    end
    return v1
end

function u48.ReflectPose(a1, a2) -- Line: 147 -- upvalues: u32 (val) -- types: a1: userdata, a2: userdata
    return a1 * u32 * a1:ToObjectSpace(a2)
end

function u48.new(a1, a2, a3) -- Line: 152
    -- upvalues: u59 (val), u48 (val), u49 (val), u58 (ref), u56 (ref), u54 (val), u55 (ref), runBuilds (val)
    -- upvalues: preloadBothHands (val), queueDownloads (val)
    local v1, v2
    local v3 = {}
    local v4, v5, v6 = a1, a3, a2
    for i, j in a1:GetDescendants() do
        if j:IsA("MeshPart") then
            v2 = j.MeshId:match("%d+")
            v1 = v2 and v6:FindFirstChild(v2)
            if v1 and v1:IsA("MeshPart") then
                table.insert(v3, {part = j, bake = v1})
                continue
            end
            if not u59[j.MeshId] then
                u59[j.MeshId] = true
                warn((("[BakedViewmodelMirror] No left-hand bake for %* (%*)"):format(j:GetFullName(), j.MeshId)))
            end
            return nil
        end
    end
    local v7 = {
        Hand = "Right",
        Visible = true,
        Twins = false,
        Model = v4,
        Entries = v3,
        Surfaces = {},
        Ready = {},
    }
    local v8 = setmetatable(v7, u48)
    u49[v8] = true
    u58 = os.clock()
    if not u56 then
        if v5 then
            queueDownloads(v8:Bakes())
        end
        return v8
    end
    table.insert(u54, v8)
    if not u55 then
        u55 = true
        task.spawn(runBuilds)
    end
    preloadBothHands(v8)
    return v8
end

function u48:Bakes() -- Line: 189
    local v1 = {}
    for i, j in self.Entries do
        table.insert(v1, j.bake)
    end
    return v1
end

function u48:HandReady(a2) -- Line: 198 -- upvalues: u50 (val), ContentProvider (val) -- types: self: table, a2: string
    if not self.Ready[a2] then
        local MeshId, bake, v1
        local Entries = self.Entries
        local v2 = nil
        local v3 = nil
        local v4, v5 = self, a2
        for i, j in Entries, v2, v3 do
            bake = if v5 ~= "Left" then j.part else j.bake
            MeshId = bake.MeshId
            if u50[MeshId] then
                v1 = true
            elseif (ContentProvider:GetAssetFetchStatus(MeshId)) ~= Enum.AssetFetchStatus.Success then
                v1 = false
            else
                u50[MeshId] = true
                v1 = true
            end
            if not v1 then
                return false
            end
        end
        v4.Ready[v5] = true
    end
    return true
end

function u48:BuildTwins() -- Line: 211 -- upvalues: u47 (val), modifierSet (val)
    if not self.Twins and self.Model then
        local Weld, part, v1
        local v2 = nil
        local v3 = nil
        local v4 = self
        for i, j in self.Entries, v2, v3 do
            part = j.part
            v1 = j.bake:Clone()
            v1.Name = part.Name
            v1.Archivable = false
            v1.Anchored = false
            v1.Massless = true
            v1.CanCollide = false
            v1.CanQuery = false
            v1.CanTouch = false
            v1.CastShadow = part.CastShadow
            v1.EnableFluidForces = false
            v1.CollisionGroup = part.CollisionGroup
            v1.Size = part.Size
            v1.Color = part.Color
            v1.Material = part.Material
            v1.MaterialVariant = part.MaterialVariant
            v1.Reflectance = part.Reflectance
            v1.TextureID = part.TextureID
            v1.Transparency = part.Transparency
            v1.DoubleSided = false
            for k, n in part:GetChildren() do
                if u47[n.ClassName] then
                    n:Clone().Parent = v1
                end
            end
            Weld = Instance.new("Weld")
            Weld.Part0 = part
            Weld.Part1 = v1
            Weld.Parent = v1
            v1.CFrame = part.CFrame
            j.twin = v1
            j.sourceSet = modifierSet(part)
            j.twinSet = modifierSet(v1)
        end
        v4:CreateSurfaces()
        v4.Twins = true
        v4:WriteVisibility()
        for m, i5 in v4.Entries do
            if i5.part.Parent then
                i5.twin.Parent = i5.part
            end
        end
        return
    end
end

function u48:CreateSurfaces() -- Line: 262
    local Adornee, Part
    local Folder = Instance.new("Folder")
    Folder.Name = "ViewmodelSurfaceDisplays"
    self.SurfaceFolder = Folder
    for i, j in self.Model:GetDescendants() do
        if j:IsA("SurfaceGui") then
            Adornee = j.Adornee or j.Parent
            if Adornee and Adornee:IsA("BasePart") and Adornee:IsDescendantOf(self.Model) then
                Part = Instance.new("Part")
                Part.Name = j.Name
                Part.Anchored = true
                Part.Transparency = 1
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
                Part.CastShadow = false
                Part.Parent = Folder
                table.insert(self.Surfaces, {gui = j, part = Adornee, proxy = Part, originalAdornee = j.Adornee})
            end
        end
    end
    self.ParentConnection = (self.Model:GetPropertyChangedSignal("Parent")):Connect(function() -- Line: 285 -- upvalues: self (val)
        self:UpdateSurfaceParent()
    end)
end

function u48.PrepareEquip(a1) -- Line: 291 -- upvalues: u56 (ref)
    if u56 and not a1.Twins then
        a1:BuildTwins()
    end
end

function u48:WriteVisibility() -- Line: 298 -- upvalues: u57 (ref)
    local gui, proxy
    if not self.Twins then
        return
    end
    local v1 = self.Hand == "Left"
    local Visible = self.Visible and not u57
    local v2 = if v1 then 1 else if not Visible then 1 else 0
    local v3 = if not v1 then 1 else if not Visible then 1 else 0
    local v4 = nil
    local v5 = nil
    local v6 = self
    for i, j in self.Entries, v4, v5 do
        for k, n in j.sourceSet do
            n.LocalTransparencyModifier = v2
        end
        for m, i5 in j.twinSet do
            i5.LocalTransparencyModifier = v3
        end
    end
    v4 = nil
    v5 = nil
    for i6, i7 in v6.Surfaces, v4, v5 do
        gui = i7.gui
        proxy = if not v1 then i7.originalAdornee else i7.proxy
        gui.Adornee = proxy
    end
    v6:UpdateSurfaceParent()
end

function u48:SyncTransparency() -- Line: 320
    local Transparency
    for i, j in self.Entries do
        Transparency = j.part.Transparency
        if j.twin.Transparency ~= Transparency then
            j.twin.Transparency = Transparency
        end
    end
end

function u48.SetLeftHanded(a1, a2) -- Line: 330
    -- upvalues: activate (val), ContentProvider (val)
    local v1, v2, v3, v4, v5
    if (if not a2 then "Right" else "Left") == a1.Hand and a1.Visible then
        if a2 then
            a1:SyncTransparency()
        end
        return
    end
    if not a1.Twins then
        if not a2 then
            return
        end
        activate()
        a1:BuildTwins()
    end
    if not (v3 ~= a1.Hand) then
        v1 = a1
    else
        a1.Hand = v3
        a1.PendingSince = os.clock()
        if a1:HandReady(v3) then
            v1 = a1
        else
            v5 = {}
            local Entries = a1.Entries
            local v6 = nil
            local v7 = nil
            v2, v1 = a2, a1
            for i, j in Entries, v6, v7 do
                table.insert(v5, if not v2 then j.part else j.bake)
            end
            task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, v5)
        end
    end
    v5 = v1:HandReady(v3) or 1.5 <= os.clock() - v1.PendingSince
    if v5 and v2 then
        v1:SyncTransparency()
    end
    if v4 or v5 ~= v1.Visible then
        v1.Visible = v5
        v1:WriteVisibility()
    end
end

function u48.SetSuppressed(a1) -- Line: 369 -- upvalues: u57 (ref), u49 (val) -- types: a1: boolean
    u57 = a1
    if not a1 then
        for i in u49 do
            i:WriteVisibility()
        end
    end
end

function u48:UpdateSurfaceParent() -- Line: 378
    local Model = self.Model
    if self.SurfaceFolder and Model then
        local CurrentCamera = workspace.CurrentCamera
        local Visible = false
        if self.Hand == "Left" then
            Visible = self.Visible
        end
        self.SurfaceFolder.Parent = if not Visible then nil else if Model.Parent ~= CurrentCamera then nil else CurrentCamera
    end
end

function u48.GetDisplayPose(a1, a2, a3) -- Line: 389
    -- upvalues: u48 (val)
    a1.LastCamera = a2
    if a1.Hand == "Left" then
        return (u48.ReflectPose(a2, a3))
    end
    return a3
end

function u48.UpdateSurfaces(a1) -- Line: 394 -- upvalues: u32 (val), u46 (val)
    if a1.Hand == "Left" and a1.Visible then
        local Face, v1
        local v2 = nil
        local v3 = nil
        for i, j in a1.Surfaces, v2, v3 do
            Face = j.gui.Face
            v1 = if Face == Enum.NormalId.Front then u32 else if Face ~= Enum.NormalId.Back then u46 else u32
            j.proxy.Size = j.part.Size
            j.proxy.CFrame = j.part.CFrame * v1
        end
        return
    end
end

function u48.ToNormalPose(a1, a2) -- Line: 408 -- upvalues: u48 (val) -- types: a1: table, a2: userdata
    if a1.Hand == "Left" and a1.LastCamera then
        return u48.ReflectPose(a1.LastCamera, a2)
    end
    return a2
end

function u48:Destroy() -- Line: 415 -- upvalues: u49 (val)
    u49[self] = nil
    if self.ParentConnection then
        self.ParentConnection:Disconnect()
    end
    for i, j in self.Surfaces do
        if j.gui.Parent then
            j.gui.Adornee = j.originalAdornee
        end
    end
    if self.SurfaceFolder then
        self.SurfaceFolder:Destroy()
    end
    table.clear(self.Surfaces)
    for k, n in self.Entries do
        if n.twin then
            n.twin:Destroy()
        end
    end
    table.clear(self.Entries)
    self.Model = nil
end

ViewmodelHand.Changed:Connect(function(a1) -- Line: 438 -- upvalues: activate (val) -- types: a1: boolean
    if a1 then
        activate()
    end
end)
return u48