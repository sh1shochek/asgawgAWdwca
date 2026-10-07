-- ReplicatedStorage.Controllers.Observers.Character.Components.Defuser
-- Script path: ReplicatedStorage.Controllers.Observers.Character.Components.Defuser
-- Decompile time: 2.41 ms

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Other = ReplicatedStorage.Assets.Other
local Defuser = Other.Defuser
local DefuseA1 = Other.DefuseA1
local DefuseA2 = Other.DefuseA2
local DefuseB1 = Other.DefuseB1
local DefuseB2 = Other.DefuseB2
local u35 = (CFrame.new(0, -0.2, -0.5)) * CFrame.Angles(0, 3.141592653589793, 0)
local u36 = {}
u36.__index = u36

local function cloneDefusePart(a1, a2, a3) -- Line: 33 -- types: a1: userdata, a2: userdata
    local v1 = a1:Clone()
    local Attachment = v1:FindFirstChild("Attachment")
    local Parent = a2.Parent
    v1.CFrame = Parent.CFrame * a2.CFrame * Attachment.CFrame:Inverse()
    v1.Parent = workspace
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = Parent
    WeldConstraint.Part1 = v1
    WeldConstraint.Parent = v1
    a3:Add(v1)
    return Attachment
end

local function disconnectBeam(a1) -- Line: 50 -- types: a1: userdata?
    if a1 then
        a1.Attachment0 = nil
        a1.Attachment1 = nil
    end
end

local function cleanupVisuals(a1) -- Line: 58
    task.defer(function() -- Line: 59 -- upvalues: a1 (val)
        pcall(function() -- Line: 60 -- upvalues: a1 (upval)
            a1:Destroy()
        end)
    end)
end

local function connectBeam(a1, a2) -- Line: 67 -- types: a1: userdata, a2: userdata
    local Beam = a1.Parent:FindFirstChildWhichIsA("Beam")
    if Beam then
        Beam.Attachment0 = a1
        Beam.Attachment1 = a2
        Beam.Enabled = true
    end
    return Beam
end

function u36.new(a1, a2) -- Line: 78
    -- upvalues: u36 (val), Janitor (val), Observers (val), CollectionService (val), Defuser (val), u35 (val)
    -- upvalues: cloneDefusePart (val), DefuseA1 (val), DefuseA2 (val), DefuseB1 (val), DefuseB2 (val)
    local v1 = setmetatable({}, u36)
    v1.Janitor = Janitor.new()
    local u9 = nil
    local u10 = nil
    local u11 = nil

    local function reset() -- Line: 86 -- upvalues: u10 (ref), u11 (ref), u9 (ref)
        local v1 = u10
        if v1 then
            v1.Attachment0 = nil
            v1.Attachment1 = nil
        end
        v1 = u11
        if v1 then
            v1.Attachment0 = nil
            v1.Attachment1 = nil
        end
        if u9 then
            local u7 = u9
            task.defer(function() -- Line: 59 -- upvalues: u7 (val)
                pcall(function() -- Line: 60 -- upvalues: u7 (upval)
                    u7:Destroy()
                end)
            end)
        end
        u10 = nil
        u11 = nil
        u9 = nil
    end

    v1.Janitor:Add((Observers.observeAttribute(a1, "IsDefusingBomb", function(a1) -- Line: 97
        -- upvalues: u10 (ref), u11 (ref), u9 (ref), reset (val), a2 (val), CollectionService (upval), Janitor (upval)
        -- upvalues: Defuser (upval), u35 (upval), cloneDefusePart (upval), DefuseA1 (upval), DefuseA2 (upval)
        -- upvalues: DefuseB1 (upval), DefuseB2 (upval)
        local v1 = u10
        if v1 then
            v1.Attachment0 = nil
            v1.Attachment1 = nil
        end
        v1 = u11
        if v1 then
            v1.Attachment0 = nil
            v1.Attachment1 = nil
        end
        if u9 then
            local u8 = u9
            task.defer(function() -- Line: 59 -- upvalues: u8 (val)
                pcall(function() -- Line: 60 -- upvalues: u8 (upval)
                    u8:Destroy()
                end)
            end)
        end
        u10 = nil
        u11 = nil
        u9 = nil
        if a1 ~= true then
            return reset
        end
        local LeftHand = a2:FindFirstChild("LeftHand")
        local v2 = CollectionService:GetTagged("Bomb")[1]
        if LeftHand and v2 then
            u9 = Janitor.new()
            local v3 = Defuser:Clone()
            local Handle = v3.Handle
            v3.Parent = a2
            Handle.CFrame = LeftHand.CFrame * u35
            v3.PrimaryPart = Handle
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = LeftHand
            WeldConstraint.Part1 = Handle
            WeldConstraint.Parent = Handle
            u9:Add(v3)
            local Body = v2.Weapon.Body
            local v4 = cloneDefusePart(DefuseA1, Handle:FindFirstChild("AttachmentA"), u9)
            local v5 = cloneDefusePart(DefuseA2, Body:FindFirstChild("AttachmentA"), u9)
            local v6 = cloneDefusePart(DefuseB1, Handle:FindFirstChild("AttachmentB"), u9)
            local v7 = cloneDefusePart(DefuseB2, Body:FindFirstChild("AttachmentB"), u9)
            local Beam = v4.Parent:FindFirstChildWhichIsA("Beam")
            if Beam then
                Beam.Attachment0 = v4
                Beam.Attachment1 = v5
                Beam.Enabled = true
            end
            u10 = Beam
            local Beam_2 = v6.Parent:FindFirstChildWhichIsA("Beam")
            if Beam_2 then
                Beam_2.Attachment0 = v6
                Beam_2.Attachment1 = v7
                Beam_2.Enabled = true
            end
            u11 = Beam_2
            return reset
        end
        return function() end
    end)))
    return v1
end

function u36:Destroy() -- Line: 140
    self.Janitor:Destroy()
end

return u36