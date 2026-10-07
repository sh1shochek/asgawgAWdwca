-- ReplicatedStorage.Controllers.Observers.Game.TugBoat
-- Script path: ReplicatedStorage.Controllers.Observers.Game.TugBoat
-- Decompile time: 1.28 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController)
local Janitor = require(ReplicatedStorage.Shared.Janitor)

local function UpdateBoat(a1, a2, a3, a4) -- Line: 20 -- types: a2: number, a3: table, a4: table
    a3[1] = a3[1] + a2
    local Handle = a1.Handle
    if Handle then
        local v1 = workspace
        if Handle:IsDescendantOf(v1) then
            if not a4[1] then
                a4[1] = Handle.CFrame
            end
            local v2 = a4[1]
            local v3 = a3[1]
            v1 = math.sin(v3 * 0.8) * 0.05235987755982989
            local v4 = math.cos(v3 * 0.8 * 0.7) * 0.05235987755982989 * 0.8
            local v5 = math.sin(v3 * 0.5) * 0.15
            local v6 = math.sin(v3 * 1.2) * 0.1
            local v7 = v2.Position + (v2.LookVector * v5 + Vector3.new(0, v6, 0))
            local v8 = CFrame.Angles(v1, 0, 0)
            local v9 = CFrame.Angles(0, 0, v4)
            local v10 = v2 * v8 * v9
            Handle.CFrame = v10 + (v7 - v10.Position)
            return
        end
    end
end

return Observers.observeTag("TugBoat", function(a1) -- Line: 56
    -- upvalues: GraphicsQualityController (val), Janitor (val), RunServiceController (val), UpdateBoat (val)
    if not a1:IsDescendantOf(workspace) then
        return
    end
    return GraphicsQualityController.RunAnimatedProp(function() -- Line: 62 -- upvalues: Janitor (upval), RunServiceController (upval), UpdateBoat (upval), a1 (val)
        local u2 = Janitor.new()
        local u3 = {nil}
        local u5 = {0}
        local v1 = RunServiceController.CreateBindingName("Observers.Game.TugBoat.Update")
        u2:Add((RunServiceController.BindToHeartbeat(v1, function(a1_2) -- Line: 67 -- upvalues: UpdateBoat (upval), a1 (upval), u5 (val), u3 (val) -- types: a1_2: number
            UpdateBoat(a1, a1_2, u5, u3)
        end)))
        return function() -- Line: 70 -- upvalues: u2 (val)
            u2:Destroy()
        end
    end)
end)