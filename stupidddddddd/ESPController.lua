-- ReplicatedStorage.Controllers.ESPController
-- Script path: ReplicatedStorage.Controllers.ESPController
-- Decompile time: 2.13 ms

local v1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local u26 = Color3.fromRGB(255, 70, 70)
local u31 = Color3.fromRGB(255, 255, 255)
local u32 = {}
local u33 = nil
local u34 = false

local function isEnemy(a1) -- Line: 30
    -- upvalues: LocalPlayer (val), Participants (val), Workspace (val)
    if a1 ~= LocalPlayer and Participants.IsAlive(a1) then
        local v1
        if Workspace:GetAttribute("Gamemode") == "Deathmatch" then
            return true
        end
        local Attribute = a1:GetAttribute("Team")
        if Attribute == "Terrorists" then
            v1 = Attribute ~= LocalPlayer:GetAttribute("Team")
        else
            v1 = false
            if Attribute == "Counter-Terrorists" then
                v1 = Attribute ~= LocalPlayer:GetAttribute("Team")
            end
        end
        return v1
    end
    return false
end

local function getContainer() -- Line: 41 -- upvalues: u33 (ref), Workspace (val)
    if u33 and u33.Parent then
        return u33
    end
    local Folder = Instance.new("Folder")
    Folder.Name = "VIPESP"
    Folder.Parent = Workspace.CurrentCamera
    u33 = Folder
    return Folder
end

local function clear() -- Line: 52 -- upvalues: u32 (val)
    for i, j in u32 do
        j:Destroy()
    end
    table.clear(u32)
end

local function refresh() -- Line: 59
    -- upvalues: Participants (val), isEnemy (val), Workspace (val), u32 (val), u26 (val), u31 (val), u33 (ref)
    local Folder, Highlight, v1, v2
    local v3 = {}
    for i, j in Participants.GetAll() do
        if isEnemy(j) then
            v1 = Participants.Character(j)
            if v1 and v1:IsDescendantOf(Workspace) then
                v3[v1] = true
            end
        end
    end
    for k, n in u32 do
        if not v3[k] then
            n:Destroy()
            u32[k] = nil
        end
    end
    local v4 = nil
    local v5 = nil
    for m in v3, v4, v5 do
        if u32[m] == nil then
            Highlight = Instance.new("Highlight")
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = u26
            Highlight.FillTransparency = 0.55
            Highlight.OutlineColor = u31
            Highlight.OutlineTransparency = 0
            Highlight.Adornee = m
            if not u33 or not u33.Parent then
                Folder = Instance.new("Folder")
                Folder.Name = "VIPESP"
                Folder.Parent = Workspace.CurrentCamera
                u33 = Folder
                v2 = Folder
            else
                v2 = u33
            end
            Highlight.Parent = v2
            u32[m] = Highlight
        end
    end
end

local function run() -- Line: 90 -- upvalues: u34 (ref), LocalPlayer (val), refresh (val), u32 (val)
    if u34 then
        return
    end
    u34 = true
    task.spawn(function() -- Line: 95 -- upvalues: LocalPlayer (upval), refresh (upval), u32 (upval), u34 (upval)
        while LocalPlayer:GetAttribute("VIPESP") == true do
            refresh()
            task.wait(0.25)
        end
        for i, j in u32 do
            j:Destroy()
        end
        table.clear(u32)
        u34 = false
    end)
end

function v1.Start() -- Line: 108 -- upvalues: LocalPlayer (val), u34 (ref), refresh (val), u32 (val)
    (LocalPlayer:GetAttributeChangedSignal("VIPESP")):Connect(function() -- Line: 109 -- upvalues: LocalPlayer (upval), u34 (upval), refresh (upval), u32 (upval)
        if LocalPlayer:GetAttribute("VIPESP") == true then
            if u34 then
                return
            end
            u34 = true
            task.spawn(function() -- Line: 95 -- upvalues: LocalPlayer (upval), refresh (upval), u32 (upval), u34 (upval)
                while LocalPlayer:GetAttribute("VIPESP") == true do
                    refresh()
                    task.wait(0.25)
                end
                for i, j in u32 do
                    j:Destroy()
                end
                table.clear(u32)
                u34 = false
            end)
        end
    end)
    if LocalPlayer:GetAttribute("VIPESP") == true then
        if u34 then
            return
        end
        u34 = true
        task.spawn(function() -- Line: 95 -- upvalues: LocalPlayer (upval), refresh (upval), u32 (upval), u34 (upval)
            while LocalPlayer:GetAttribute("VIPESP") == true do
                refresh()
                task.wait(0.25)
            end
            for i, j in u32 do
                j:Destroy()
            end
            table.clear(u32)
            u34 = false
        end)
    end
end

return v1