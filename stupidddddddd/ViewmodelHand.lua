-- ReplicatedStorage.Shared.ViewmodelHand
-- Script path: ReplicatedStorage.Shared.ViewmodelHand
-- Decompile time: 0.57 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
local u14 = false
local u15 = {}
u15.Changed = Signal.new()

function u15.IsLeftHanded() -- Line: 14 -- upvalues: u14 (ref)
    return u14
end

function u15.IsPlayerLeftHanded(a1) -- Line: 19 -- upvalues: Players (val), u14 (ref) -- types: a1: userdata?
    if a1 == Players.LocalPlayer then
        return u14
    end
    local v1 = false
    if a1 ~= nil then
        v1 = a1:GetAttribute("ViewmodelLeftHanded") == true
    end
    return v1
end

function u15.SetLeftHanded(a1) -- Line: 26
    -- upvalues: u14 (ref), u15 (val), ReplicatedStorage (val)
    if u14 ~= a1 then
        u14 = a1
        u15.Changed:Fire(a1)
        require(ReplicatedStorage.Database.Security.Remotes).Player.SetViewmodelHand.Send(a1)
    end
end

function u15.Toggle() -- Line: 35 -- upvalues: u15 (val), u14 (ref)
    u15.SetLeftHanded(not u14)
end

return (table.freeze(u15))