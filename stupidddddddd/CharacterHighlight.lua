-- ReplicatedStorage.Classes.CharacterHighlight
-- Script path: ReplicatedStorage.Classes.CharacterHighlight
-- Decompile time: 1.42 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Spring = require(ReplicatedStorage.Shared.Spring)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)

local function applyFill(a1, a2) -- Line: 26 -- types: a2: number
    local FillColor, v1
    if not a1.OutlineOnly then
        FillColor = a1.Properties.FillColor
        v1 = a2
    else
        FillColor = a1.Properties.OutlineColor:Lerp(Color3.new(1, 1, 1), 0.2)
        v1 = 0.9
    end
    if a1.AppliedFillColor ~= FillColor then
        a1.Highlight.FillColor = FillColor
        a1.AppliedFillColor = FillColor
    end
    if a1.AppliedFillTransparency ~= v1 then
        a1.Highlight.FillTransparency = v1
        a1.AppliedFillTransparency = v1
    end
end

function u0.UpdateState(a1, a2) -- Line: 45 -- upvalues: applyFill (val) -- types: a2: boolean
    if a1.Highlight and a1.Highlight.Parent then
        if a1.IsEnabled ~= a2 then
            if a2 then
                applyFill(a1, a1.CurrentTransparency:getPosition())
            end
            a1.Highlight.Enabled = a2
            a1.IsEnabled = a2
        end
        return
    end
end

function u0.new(a1, a2) -- Line: 62
    -- upvalues: u0 (val), Janitor (val), Spring (val), CharacterResolver (val), RunServiceController (val)
    -- upvalues: applyFill (val)
    local u5 = setmetatable({}, u0)
    u5.Janitor = Janitor.new()
    u5.CurrentTransparency = Spring.new(0.95, 1.5, 0.6)
    u5.Properties = a2
    u5.Character = a1
    local v1 = u5.Janitor:Add((Instance.new("Highlight", a1)))
    v1.Enabled = false
    v1.OutlineTransparency = a2.OutlineTransparency
    v1.FillTransparency = a2.FillTransparency
    v1.OutlineColor = a2.OutlineColor
    v1.DepthMode = a2.DepthMode
    v1.FillColor = a2.FillColor
    u5.Highlight = v1
    u5.IsEnabled = false
    u5.OutlineOnly = false
    if CharacterResolver.isAliveCharacter(a1) then
        u5.Janitor:Add(((a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 91 -- upvalues: a1 (val), u5 (val)
            if a1:GetAttribute("Dead") then
                u5:Destroy()
            end
        end)))
    end
    u5.Janitor:Add((RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName("Classes.CharacterHighlight.Pulse"), function(a1) -- Line: 100 -- upvalues: u5 (val), applyFill (upval) -- types: a1: number
        if u5.IsEnabled and u5.Highlight and u5.Highlight.Parent then
            local v1 = u5.CurrentTransparency:getPosition()
            u5.CurrentTransparency:update(a1)
            if v1 >= 0.8 then
                u5.CurrentTransparency:setGoal(0.6)
            elseif v1 <= 0.6 then
                u5.CurrentTransparency:setGoal(0.8)
            end
            applyFill(u5, v1)
            return
        end
    end)))
    return u5
end

function u0:Destroy() -- Line: 125
    self.Janitor:Destroy()
end

return u0