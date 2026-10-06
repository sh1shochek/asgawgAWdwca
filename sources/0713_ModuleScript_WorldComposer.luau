-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
require(script.Parent.Parent.Simulation.Types);
require(script.Parent.Parent.Collision.TopologyBuilder);
require(script.Parent.Parent.Collision.DestructibleFrame);
local World = require(script.Parent.Parent.Collision.World);
require(script.Parent.RemoteBuffer);
require(script.Parent.Parent.Simulation.PlayerContacts);
local Serial = require(script.Parent.Parent.Serial);
local v1 = {};
local table_freeze_ret = table.freeze({
    Start = 0,
    Finish = 1
});

function v1.compose(p2: table, p3: number, p4: number?, p5: number?, p6: any, p7: boolean?, p8: any, p9: any) -- Line: 78
    -- upvalues: World (copy), Serial (copy), table_freeze_ret (copy)
    local _mapping = p2._mapping;
    local _topology = p2._topology;
    local _timeline = p2._timeline;
    local _config = p2._config;

    if _mapping == nil or (_topology == nil or (_timeline == nil or _config == nil)) then
        return nil, "CollisionContextUnavailable";
    end;

    local v10, v11;

    if p7 then
        v10, v11 = _timeline:predict(p3, p4);
    else
        v10, v11 = _timeline:resolve(p3, p4);
    end;

    if v10 == nil then
        return nil, v11;
    end;

    local _cachedStaticWorld = p2._cachedStaticWorld;

    if _cachedStaticWorld == nil or p2._cachedStaticFrame ~= v10 then
        _cachedStaticWorld = World.new(_topology, v10);
        p2._cachedStaticFrame = v10;
        p2._cachedStaticWorld = _cachedStaticWorld;
    end;

    local v12 = p9 or p2._collisionComposer;
    local v13 = {
        Mapping = _mapping,
        ServerTick = p3,
        PreviousServerTick = Serial.addUInt32(p3, -1),
        StepSeconds = _config.StepSeconds,
        Interval = table_freeze_ret,
        Topology = _topology,
        Destructibles = v10,
        StaticWorld = _cachedStaticWorld,
        MoverRevision = p5,
        Speculative = p7 == true,
        ContactState = p6
    };
    local v14 = nil;
    local v15;

    if v12 == nil then
        if p5 ~= nil and p5 ~= 0 then
            return nil, "MoverComposerUnavailable";
        end;

        v15 = {
            Query = _cachedStaticWorld,

            CanOccupyAtEnd = function(p16, p17, p18) -- Line: 133, Name: CanOccupyAtEnd
                -- upvalues: _cachedStaticWorld (ref)
                return _cachedStaticWorld:CanMove(p17, p18, p16.Stance, nil, 1, 1);
            end
        };
    else
        v15, v14 = v12:Compose(v13);
    end;

    if v15 == nil then
        return nil, v14 or "CollisionComposerUnavailable";
    end;

    local Query = v15.Query;

    if Query == nil or (type(Query.Sweep) ~= "function" or (type(Query.IsClear) ~= "function" or (type(Query.CanMove) ~= "function" or type(Query.FindGround) ~= "function"))) then
        return nil, "ComposedCollisionQueryInvalid";
    end;

    if type(v15.CanOccupyAtEnd) == "function" then
        return {
            ServerTick = p3,
            Destructibles = v10,
            Composed = v15
        }, nil;
    end;

    return nil, "CollisionComposerMissingEndOccupancy";
end;

return table.freeze(v1);