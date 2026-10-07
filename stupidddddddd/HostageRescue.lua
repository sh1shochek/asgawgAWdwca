-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.HostageRescue
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.HostageRescue
-- Decompile time: 1.97 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local LocalPlayer = Players.LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local u29 = {}
local u30 = nil

local function UpdateTemplateState(a1, a2) -- Line: 37 -- types: a2: string
    a1.Idle.Visible = not (a2 == "Carrying")
    a1.Action.Visible = a2 == "Carrying"
end

local function ClearFrame(a1) -- Line: 42 -- upvalues: u29 (val) -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if u29[v] then
            u29[v]:Destroy()
            u29[v] = nil
        end
    end
end

local function UpdateTemplateSizes() -- Line: 51 -- upvalues: u30 (ref)
    local fromScale, v1
    local v2 = {}
    for i, v in ipairs(u30:GetChildren()) do
        if v:IsA("Frame") then
            table.insert(v2, v)
        end
    end
    for i2, i3 in ipairs(v2) do
        fromScale = UDim2.fromScale
        v1 = 1 / #v2
        i3.Size = fromScale(v1, 1)
    end
end

local function UpdatePosition(a1) -- Line: 64 -- upvalues: u30 (ref) -- types: a1: number
    if not u30 then
        return
    end
    local v1 = 240 - (200 - a1 * 200) + 50
    u30.Position = UDim2.new(0.029, 0, 0, v1)
end

local function UpdateVisibility() -- Line: 76 -- upvalues: u30 (ref)
    if not u30 then
        return
    end
    u30.Visible = workspace:GetAttribute("Gamemode") == "Hostage Rescue"
end

function u0.CreateTemplate(a1) -- Line: 87
    -- upvalues: ReplicatedStorage (val), u30 (ref), UpdateTemplateSizes (val)
    local v1 = ReplicatedStorage.Assets.UI.HostageRescue.Template:Clone()
    v1.Parent = u30
    UpdateTemplateSizes()
    return v1
end

function u0.Initialize(a1, a2) -- Line: 97
    -- upvalues: u30 (ref), DataController (val), LocalPlayer (val), UpdatePosition (val), UpdateVisibility (val)
    -- upvalues: GameState (val), ClearFrame (val), Observers (val), Janitor (val), UpdateTemplateSizes (val), u0 (val)
    -- upvalues: u29 (val)
    u30 = a2
    DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Hud Size", UpdatePosition)
    local v1 = DataController.Get(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Hud Size") or 1
    if u30 then
        local v2 = 240 - (200 - v1 * 200) + 50
        u30.Position = UDim2.new(0.029, 0, 0, v2)
    end
    if u30 then
        u30.Visible = workspace:GetAttribute("Gamemode") == "Hostage Rescue"
    end
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(UpdateVisibility)
    GameState.ListenToState(function(a1, a2) -- Line: 112 -- upvalues: ClearFrame (upval), u30 (upval)
        if a2 == "Buy Period" or a2 == "Warmup" then
            ClearFrame(u30)
        end
    end)
    Observers.observeTag("Hostage", function(a1) -- Line: 119
        -- upvalues: Janitor (upval), UpdateTemplateSizes (upval), u0 (upval), u29 (upval)
        local v1 = Janitor.new()
        v1:Add(UpdateTemplateSizes)
        local u14 = v1:Add((u0.CreateTemplate(a1)))
        u29[u14] = v1
        local v2 = a1:GetAttribute("State") or "Idle"
        u14.Idle.Visible = not (v2 == "Carrying")
        u14.Action.Visible = v2 == "Carrying"
        v1:Add(((a1:GetAttributeChangedSignal("State")):Connect(function() -- Line: 125 -- upvalues: u14 (val), a1 (val)
            local v1 = u14
            local v2 = a1:GetAttribute("State") or "Idle"
            v1.Idle.Visible = not (v2 == "Carrying")
            v1.Action.Visible = v2 == "Carrying"
        end)))
        return function() -- Line: 128 -- upvalues: u29 (upval), u14 (val)
            if u29[u14] then
                u29[u14]:Destroy()
                u29[u14] = nil
            end
        end
    end)
end

return u0