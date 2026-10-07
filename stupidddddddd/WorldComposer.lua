-- ReplicatedStorage.MovementV2.Client.WorldComposer
-- Script path: ReplicatedStorage.MovementV2.Client.WorldComposer
-- Decompile time: 1.76 ms

require(script.Parent.Parent.Types)
require(script.Parent.Parent.Simulation.Types)
require(script.Parent.Parent.Collision.TopologyBuilder)
require(script.Parent.Parent.Collision.DestructibleFrame)
local World = require(script.Parent.Parent.Collision.World)
require(script.Parent.RemoteBuffer)
require(script.Parent.Parent.Simulation.PlayerContacts)
local Serial = require(script.Parent.Parent.Serial)
local v1 = {}
local u55 = table.freeze({Start = 0, Finish = 1})

function v1.compose(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 78
    -- upvalues: World (val), Serial (val), u55 (val)
    local _mapping = a1._mapping
    local _topology = a1._topology
    local _timeline = a1._timeline
    local _config = a1._config
    if _mapping ~= nil and _topology ~= nil and _timeline ~= nil and _config ~= nil then
        local Query, v1, v2, v3, v4
        if not a6 then
            v2, v3 = _timeline:resolve(a2, a3)
        else
            v2, v3 = _timeline:predict(a2, a3)
        end
        if v2 == nil then
            return nil, v3
        end
        local _cachedStaticWorld = a1._cachedStaticWorld
        if _cachedStaticWorld == nil or a1._cachedStaticFrame ~= v1 then
            _cachedStaticWorld = World.new(_topology, v1)
            a1._cachedStaticFrame = v1
            a1._cachedStaticWorld = _cachedStaticWorld
        end
        local _collisionComposer = a8 or a1._collisionComposer
        local v5 = {
            Mapping = _mapping,
            ServerTick = a2,
            PreviousServerTick = Serial.addUInt32(a2, -1),
            StepSeconds = _config.StepSeconds,
            Interval = u55,
            Topology = _topology,
            Destructibles = v1,
            StaticWorld = _cachedStaticWorld,
            MoverRevision = a4,
            Speculative = a6 == true,
            ContactState = a5,
        }
        if _collisionComposer ~= nil then
            local v6, v7 = _collisionComposer:Compose(v5)
            if v6 == nil then
                return nil, v7 or "CollisionComposerUnavailable"
            end
            Query = v4.Query
            if Query ~= nil
                and type(Query.Sweep) == "function"
                and type(Query.IsClear) == "function"
                and type(Query.CanMove) == "function"
                and type(Query.FindGround) == "function" then
                if type(v4.CanOccupyAtEnd) ~= "function" then
                    return nil, "CollisionComposerMissingEndOccupancy"
                end
                return {ServerTick = a2, Destructibles = v1, Composed = v4}, nil
            end
            return nil, "ComposedCollisionQueryInvalid"
        end
        if a4 ~= nil and a4 ~= 0 then
            return nil, "MoverComposerUnavailable"
        end
        if {
            Query = _cachedStaticWorld,
            CanOccupyAtEnd = function(a1, a2, a3) -- Line: 133 -- upvalues: _cachedStaticWorld (ref)
                local Stance, v3, v4
                return _cachedStaticWorld:CanMove(a2, a3, a1.Stance, nil, 1, 1)
            end,
        } == nil then
            return nil, "CollisionComposerUnavailable"
        end
        Query = v4.Query
        if Query ~= nil
            and type(Query.Sweep) == "function"
            and type(Query.IsClear) == "function"
            and type(Query.CanMove) == "function"
            and type(Query.FindGround) == "function" then
            if type(v4.CanOccupyAtEnd) ~= "function" then
                return nil, "CollisionComposerMissingEndOccupancy"
            end
            return {ServerTick = a2, Destructibles = v1, Composed = v4}, nil
        end
        return nil, "ComposedCollisionQueryInvalid"
    end
    return nil, "CollisionContextUnavailable"
end

return table.freeze(v1)