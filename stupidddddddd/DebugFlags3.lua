-- ReplicatedStorage.Shared.DebugFlags
-- Script path: ReplicatedStorage.Shared.DebugFlags
-- Decompile time: 0.31 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
    IsEnabled = function(a1) -- Line: 11 -- upvalues: ReplicatedStorage (val) -- types: a1: string
        return ReplicatedStorage:GetAttribute("Debug_" .. a1) == true
    end,
}