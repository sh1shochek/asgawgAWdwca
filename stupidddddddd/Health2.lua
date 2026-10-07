-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Health
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Health
-- Decompile time: 2.37 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local HudTarget = require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local u44 = (require(ReplicatedStorage.Shared.Janitor)).new()
local u45 = 0
local u46 = nil
local u47 = nil

function u0.animateFrame() -- Line: 48 -- upvalues: u47 (ref), TweenService (val), Debris (val)
    local v1 = u47.Amount:Clone()
    v1.TextColor3 = Color3.fromRGB(255, 0, 4)
    v1.ZIndex = u47.ZIndex - 1
    v1.Parent = u47
    TweenService:Create(u47.Amount.UIScale, TweenInfo.new(0.07), {Scale = 1.1}):Play()
    task.wait(0.07)
    TweenService:Create(u47.Amount.UIScale, TweenInfo.new(0.07, Enum.EasingStyle.Elastic), {Scale = 1}):Play()
    TweenService:Create(v1, TweenInfo.new(0.5), {Position = v1.Position + UDim2.fromScale(0, 0.25)}):Play()
    TweenService:Create(v1, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    Debris:AddItem(v1, 0.5)
end

function u0.updateFrame(a1, a2) -- Line: 62
    -- upvalues: u47 (ref), GetPreferenceColor (val), TweenService (val), u45 (ref), u0 (val)
    if a2 <= 0 then
        return
    end
    local v1 = a1 / a2
    u47.Amount.Text = tostring((math.ceil(a1)))
    u47.Frame.Bar.BackgroundColor3 = GetPreferenceColor()
    u47.Amount.TextColor3 = GetPreferenceColor()
    u47.Glow.ImageTransparency = 1
    TweenService:Create(
        u47.Frame.Bar,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.fromScale(v1, 1)}
    ):Play()
    if v1 <= 0.5 then
        u47.Glow.ImageTransparency = math.max((0.5 - v1) * 2, 0.3)
    end
    if a1 < u45 then
        task.spawn(u0.animateFrame)
    end
    u45 = a1
end

local function updateFromAttributes(a1) -- Line: 85 -- upvalues: u0 (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("Health")
    local Attribute_2 = a1:GetAttribute("MaxHealth")
    if typeof(Attribute) == "number" and typeof(Attribute_2) == "number" and Attribute_2 > 0 then
        u0.updateFrame(math.max(Attribute, 0), Attribute_2)
    end
end

local function trackPlayer(a1) -- Line: 93 -- upvalues: u44 (val), u46 (ref), u0 (val), u45 (ref) -- types: a1: userdata
    u44:Cleanup()
    u46 = a1

    local function update() -- Line: 97 -- upvalues: a1 (val), u0 (upval)
        local v1 = a1
        local Attribute = v1:GetAttribute("Health")
        local Attribute_2 = v1:GetAttribute("MaxHealth")
        if typeof(Attribute) == "number" and typeof(Attribute_2) == "number" and Attribute_2 > 0 then
            u0.updateFrame(math.max(Attribute, 0), Attribute_2)
        end
    end

    local Attribute = a1:GetAttribute("Health")
    u45 = if typeof(Attribute) ~= "number" then 0 else Attribute
    u44:Add(((a1:GetAttributeChangedSignal("Health")):Connect(update)))
    u44:Add(((a1:GetAttributeChangedSignal("MaxHealth")):Connect(update)))
    local Attribute_2 = a1:GetAttribute("Health")
    local Attribute_3 = a1:GetAttribute("MaxHealth")
    if typeof(Attribute_2) == "number" and typeof(Attribute_3) == "number" and Attribute_3 > 0 then
        u0.updateFrame(math.max(Attribute_2, 0), Attribute_3)
    end
end

function u0.Initialize(a1, a2) -- Line: 111
    -- upvalues: u47 (ref), HudTarget (val), u46 (ref), u0 (val), DataController (val), LocalPlayer (val)
    HudTarget.DisableInput(a2)

    local function refreshPreferenceColor() -- Line: 117 -- upvalues: u46 (upval), u0 (upval)
        if u46 then
            local v1 = u46
            local Attribute = v1:GetAttribute("Health")
            local Attribute_2 = v1:GetAttribute("MaxHealth")
            if typeof(Attribute) == "number" and typeof(Attribute_2) == "number" and Attribute_2 > 0 then
                u0.updateFrame(math.max(Attribute, 0), Attribute_2)
            end
        end
    end

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(refreshPreferenceColor)
end

function u0.Start() -- Line: 128 -- upvalues: HudTarget (val), trackPlayer (val)
    HudTarget.Follow(trackPlayer)
end

return u0