-- ReplicatedStorage.Database.Components.GameState
-- Script path: ReplicatedStorage.Database.Components.GameState
-- Decompile time: 2.65 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Database.Custom.Types)
local Observers = require(ReplicatedStorage.Packages.Observers)
local u19 = {"Map Voting", "Game Ending", "Warmup", "Round In Progress", "Buy Period", "Intermission"}

local function isValidState(a1) -- Line: 29 -- upvalues: u19 (val) -- types: a1: string
    assert(table.find(u19, a1), (("\"%*\" is not a valid state!"):format(a1)))
    return true
end

return {
    GetState = function() -- Line: 40
        return (workspace:GetAttribute("GameState"))
    end,
    GetStateAtTime = function(a1) -- Line: 46 -- upvalues: u19 (val) -- types: a1: number?
        local Attribute = workspace:GetAttribute("GameState")
        local Attribute_2 = workspace:GetAttribute("ScheduledGameState")
        local Attribute_3 = workspace:GetAttribute("ScheduledGameStateServerTime")
        if typeof(a1) == "number"
            and a1 == a1
            and typeof(Attribute_3) == "number"
            and Attribute_3 <= a1
            and typeof(Attribute_2) == "string"
            and table.find(u19, Attribute_2) ~= nil then
            return Attribute_2
        end
        local Attribute_4 = workspace:GetAttribute("GameStateTransitionServerTime")
        local Attribute_5 = workspace:GetAttribute("PreviousGameState")
        if typeof(a1) == "number"
            and a1 == a1
            and typeof(Attribute_4) == "number"
            and a1 < Attribute_4
            and typeof(Attribute_5) == "string"
            and table.find(u19, Attribute_5) ~= nil then
            return Attribute_5
        end
        return Attribute
    end,
    SetState = function(a1) -- Line: 75 -- upvalues: RunService (val), u19 (val)
        assert(RunService:IsServer(), "This method is only available to the server.")
        assert(table.find(u19, a1), (("\"%*\" is not a valid state!"):format(a1)))
        if true then
            local Attribute = workspace:GetAttribute("GameState")
            if Attribute == a1 then
                return
            end
            local Attribute_2 = workspace:GetAttribute("ScheduledGameState")
            local Attribute_3 = workspace:GetAttribute("ScheduledGameStateServerTime")
            local ServerTimeNow = if Attribute_2 ~= a1 then workspace:GetServerTimeNow() else if typeof(Attribute_3) ~= "number" then workspace:GetServerTimeNow() else Attribute_3
            workspace:SetAttribute("PreviousGameState", Attribute)
            workspace:SetAttribute("GameStateTransitionServerTime", ServerTimeNow)
            workspace:SetAttribute("GameState", a1)
            workspace:SetAttribute("ScheduledGameState", nil)
            workspace:SetAttribute("ScheduledGameStateServerTime", nil)
        end
    end,
    ScheduleState = function(a1, a2) -- Line: 94 -- upvalues: RunService (val), u19 (val) -- types: a2: number
        assert(RunService:IsServer(), "This method is only available to the server.")
        local v1 = false
        if a2 == a2 then
            v1 = false
            if a2 > (-1 / 0) then
                v1 = a2 < (1 / 0)
            end
        end
        assert(v1)
        assert(table.find(u19, a1), (("\"%*\" is not a valid state!"):format(a1)))
        if true then
            workspace:SetAttribute("ScheduledGameStateServerTime", a2)
            workspace:SetAttribute("ScheduledGameState", a1)
        end
    end,
    CancelScheduledState = function() -- Line: 104 -- upvalues: RunService (val)
        assert(RunService:IsServer(), "This method is only available to the server.")
        workspace:SetAttribute("ScheduledGameState", nil)
        workspace:SetAttribute("ScheduledGameStateServerTime", nil)
    end,
    ListenToState = function(a1) -- Line: 110 -- upvalues: Observers (val) -- types: a1: function
        local u1 = nil
        return (Observers.observeAttribute(workspace, "GameState", function(a1_2) -- Line: 112 -- upvalues: a1 (val), u1 (ref)
            a1(u1, a1_2)
            u1 = a1_2
        end))
    end,
}