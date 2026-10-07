-- ReplicatedStorage.Controllers.EntityController.Entities.Deathmatch_Health_Kit
-- Script path: ReplicatedStorage.Controllers.EntityController.Entities.Deathmatch_Health_Kit
-- Decompile time: 1.34 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Health = ((ReplicatedStorage:WaitForChild("Assets")):WaitForChild("Deathmatch")):WaitForChild("Health")
local Debris = workspace:WaitForChild("Debris")

local function AttemptEntityPickup(a1) -- Line: 45 -- upvalues: Players (val), CharacterResolver (val), Remotes (val)
    local v1 = os.clock()
    if v1 - a1.LastRequest < 0.5 or Players.LocalPlayer:GetAttribute("BuyMenu") then
        return
    end
    local v2 = CharacterResolver.getLocalCharacter()
    if not CharacterResolver.isAliveCharacter(v2) then
        return
    end
    local v3 = CharacterResolver.getRootPart(v2)
    if v3 and not (6 < (v3.Position - a1.Position).Magnitude) then
        a1.LastRequest = v1
        Remotes.Entity.InteractWithEntity.Send({Action = "Pickup", EntityId = a1.EntityId})
        return
    end
end

function u0.new(a1, a2, a3) -- Line: 76
    -- upvalues: Health (val), RunServiceController (val), u0 (val), Debris (val), AttemptEntityPickup (val)
    local v1 = {
        LastRequest = 0,
        Elapsed = 0,
        EntityId = a1,
        Position = a3,
        Model = Health:Clone(),
        BindingName = RunServiceController.CreateBindingName("DeathmatchHealthKit"),
    }
    local u14 = setmetatable(v1, u0)
    for i, j in u14.Model:GetDescendants() do
        if j:IsA("BasePart") then
            j.CanCollide = false
            j.CanQuery = false
            j.CanTouch = false
            j.Anchored = true
        end
    end
    u14.Model:PivotTo((CFrame.new(a3)))
    u14.Model.Parent = Debris
    RunServiceController.BindToHeartbeat(u14.BindingName, function(a1) -- Line: 99 -- upvalues: u14 (val), AttemptEntityPickup (upval) -- types: a1: number
        local v1 = u14
        v1.Elapsed = v1.Elapsed + a1
        u14.Model:PivotTo((CFrame.new(u14.Position + Vector3.new(0, math.sin(u14.Elapsed * 0.5 * 2 * 3.141592653589793) * 0.15 + 0.2, 0))) * (CFrame.Angles(0, u14.Elapsed * 1.5707963267948966, 0)))
        AttemptEntityPickup(u14)
    end)
    return u14
end

function u0:Destroy(a2) -- Line: 114
    -- upvalues: RunServiceController (val), Players (val), Router (val)
    RunServiceController.Unbind("Heartbeat", self.BindingName)
    self.Model:Destroy()
    if a2 == Players.LocalPlayer.UserId then
        Router.broadcastRouter("DeathmatchHealthClaimed")
    end
end

return u0