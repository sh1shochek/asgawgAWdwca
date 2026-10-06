-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
require(script.Parent.Parent.Types);
require(script.Parent.Config);
require(script.Parent.Types);
local DeterminismTrace = require(script.Parent.DeterminismTrace);
local ProvenMath = require(script.Parent.ProvenMath);
local PlayerContacts = require(script.Parent.PlayerContacts);
local PlayerLanding = require(script.Parent.PlayerLanding);
require(script.Parent.PlayerHullClearance);
local ProvenSimulator = require(script.Parent.ProvenSimulator);
local v1 = {};

local function cloneSupport(p2) -- Line: 24
    return {
        Kind = p2.Kind,
        SourceId = p2.SourceId,
        Anchor = p2.Anchor,
        Velocity = p2.Velocity
    };
end;

local function emptySupport() -- Line: 33
    -- upvalues: Enums (copy)
    return {
        SourceId = 0,
        Anchor = Vector3.new(0, 0, 0),
        Velocity = Vector3.new(0, 0, 0),
        Kind = Enums.SupportKind.None
    };
end;

local function clearGround(p3: any, p4: vector, p5: any) -- Line: 42
    -- upvalues: Enums (copy)
    p3.OnGround = false;
    p3.GroundNormal = Vector3.new(0, 1, 0);
    p3.GroundSurfaceFriction = p5.SurfaceFrictionDefault;
    p3.Velocity = p4;

    return {
        SourceId = 0,
        Anchor = Vector3.new(0, 0, 0),
        Velocity = Vector3.new(0, 0, 0),
        Kind = Enums.SupportKind.None
    };
end;

local function applyGroundVelocity(p6: any, p7: vector, p8: any, p9: vector, p10: number, p11: any) -- Line: 50
    -- upvalues: PlayerContacts (copy), ProvenMath (copy)
    local v12 = {
        Kind = p8.Kind,
        SourceId = p8.SourceId,
        Anchor = p8.Anchor,
        Velocity = p8.Velocity
    };
    local v13 = PlayerContacts.fromWorldVelocity(p7, v12);
    local v14 = ProvenMath.clipVelocity(v13, p9);

    if math.abs(p9.Y - 1) <= p11.PlaneEpsilon then
        v14 = Vector3.new(v14.X, 0, v14.Z);
    end;

    p6.OnGround = true;
    p6.MovementMode = "Walking";
    p6.GroundNormal = p9;
    p6.GroundSurfaceFriction = math.max(p10, 0);
    p6.Velocity = v14;

    return v12, v14 + v12.Velocity;
end;

function v1.finalize(p15: any, p16: any, p17: any, p18: any, p19: any, p20: any, p21: any, p22: any, p23: number, p24: any, p25: any, p26: any) -- Line: 73
    -- upvalues: PlayerLanding (copy), PlayerContacts (copy), Enums (copy), DeterminismTrace (copy), ProvenMath (copy), applyGroundVelocity (copy), ProvenSimulator (copy)
    if PlayerLanding.needsStanding(p17) then
        if p20.Stance == "Standing" then
            p17.Stance = "Standing";
            p17.JumpHullActive = false;
        else
            p21 = nil;
        end;
    end;

    local v27 = PlayerContacts.toWorldVelocity(p17.Velocity, p18);
    local Landed = p19.Landed;
    local ImpactVelocityY = p19.ImpactVelocityY;
    local OnGround = p15.OnGround;

    if OnGround then
        if p16.Kind == Enums.SupportKind.Player then
            OnGround = p17.OnGround;

            if OnGround then
                if p18.Kind == Enums.SupportKind.Player then
                    OnGround = p18.SourceId == p16.SourceId;
                else
                    OnGround = false;
                end;
            end;
        else
            OnGround = false;
        end;
    end;

    local v28 = p20.Position ~= p17.Position;
    local v29 = p20.WorldVelocity ~= v27;
    p17.Position = p20.Position;
    local WorldVelocity = p20.WorldVelocity;
    DeterminismTrace.checkpoint(p25, "runtime.playerContacts.bodyCommit", p17, p18, nil);

    if not (v28 or (v29 or (p21 ~= nil or p18.Kind == Enums.SupportKind.Player))) then
        DeterminismTrace.checkpoint(p25, "runtime.playerContacts.groundFinalize", p17, p18, nil);
        DeterminismTrace.checkpoint(p25, "runtime.playerContacts.eventsFinalize", p17, p18, nil);

        return p17, p18, p19;
    end;

    local v30;

    if p17.OnGround then
        v30 = p18;
    else
        v30 = nil;
    end;

    local v31;

    if p21 == nil then
        if OnGround and (p18.Kind == Enums.SupportKind.Player and p18.SourceId == p16.SourceId) then
            local v32 = ProvenMath.clipVelocity(p17.Velocity + (p20.WorldVelocity - v27), Vector3.new(0, 1, 0));
            local Vector3_new_ret = Vector3.new(v32.X, 0, v32.Z);
            v31 = {
                Kind = p18.Kind,
                SourceId = p18.SourceId,
                Anchor = p18.Anchor,
                Velocity = p18.Velocity
            };
            p17.OnGround = true;
            p17.MovementMode = "Walking";
            p17.GroundNormal = Vector3.new(0, 1, 0);
            p17.GroundSurfaceFriction = p24.SurfaceFrictionDefault;
            p17.Velocity = Vector3_new_ret;
            local _ = Vector3_new_ret + v31.Velocity;
        elseif v28 or p18.Kind == Enums.SupportKind.Player then
            local v33 = p22:FindGround(p17.Position, p17.Stance, p24.GroundProbeDistance, 1, v30);
            local v34;

            if v33 == nil or v33.Normal.Y < p24.WalkableFloor then
                v34 = false;
            else
                v34 = WorldVelocity.Y - v33.Support.Velocity.Y <= p24.GroundClearVelocity;
            end;

            if v34 and (v33 ~= nil and PlayerLanding.needsStanding(p17)) then
                v33 = PlayerLanding.restoreWorldGround(v33, p22, p24, p26, p25);

                if v33 == nil or v33.Normal.Y < p24.WalkableFloor then
                    v34 = false;
                else
                    v34 = WorldVelocity.Y - v33.Support.Velocity.Y <= p24.GroundClearVelocity;
                end;

                if v34 then
                    p17.Stance = "Standing";
                    p17.JumpHullActive = false;
                end;
            end;

            if v34 and v33 ~= nil then
                p17.Position = v33.Position;
                local Stance = p17.Stance;
                p20.Position = v33.Position;
                p20.Stance = Stance;
                local v35;
                v31, v35 = applyGroundVelocity(p17, WorldVelocity, v33.Support, v33.Normal, v33.SurfaceFriction, p24);
            else
                p17.OnGround = false;
                p17.GroundNormal = Vector3.new(0, 1, 0);
                p17.GroundSurfaceFriction = p24.SurfaceFrictionDefault;
                p17.Velocity = WorldVelocity;
                v31 = {
                    SourceId = 0,
                    Anchor = Vector3.new(0, 0, 0),
                    Velocity = Vector3.new(0, 0, 0),
                    Kind = Enums.SupportKind.None
                };
            end;
        elseif p17.OnGround then
            local v36;
            v31, v36 = applyGroundVelocity(p17, WorldVelocity, p18, p17.GroundNormal, p17.GroundSurfaceFriction, p24);
        else
            p17.OnGround = false;
            p17.GroundNormal = Vector3.new(0, 1, 0);
            p17.GroundSurfaceFriction = p24.SurfaceFrictionDefault;
            p17.Velocity = WorldVelocity;
            v31 = {
                SourceId = 0,
                Anchor = Vector3.new(0, 0, 0),
                Velocity = Vector3.new(0, 0, 0),
                Kind = Enums.SupportKind.None
            };
        end;
    elseif OnGround and p21.SourceId == p16.SourceId then
        local v37 = ProvenMath.clipVelocity(p17.Velocity + (p20.WorldVelocity - v27), Vector3.new(0, 1, 0));
        local Vector3_new_ret = Vector3.new(v37.X, 0, v37.Z);
        v31 = {
            Kind = p21.Kind,
            SourceId = p21.SourceId,
            Anchor = p21.Anchor,
            Velocity = p21.Velocity
        };
        p17.OnGround = true;
        p17.MovementMode = "Walking";
        p17.GroundNormal = Vector3.new(0, 1, 0);
        p17.GroundSurfaceFriction = p24.SurfaceFrictionDefault;
        p17.Velocity = Vector3_new_ret;
        local _ = Vector3_new_ret + v31.Velocity;
    else
        local v38;
        v31, v38 = applyGroundVelocity(p17, WorldVelocity, p21, Vector3.new(0, 1, 0), p24.SurfaceFrictionDefault, p24);
    end;

    DeterminismTrace.checkpoint(p25, "runtime.playerContacts.groundFinalize", p17, v31, nil);

    if p17.OnGround and p17.DuckAmount >= 0.999 then
        p17.JumpHullActive = false;
    end;

    local v39 = not p15.OnGround and p17.OnGround;
    local v40 = p15.OnGround and not p17.OnGround;
    local v41;

    if v39 then
        v41 = ImpactVelocityY or p15.Velocity.Y;
    else
        v41 = nil;
    end;

    if Landed and not v39 then
        p17.Stamina = ProvenSimulator.finishStamina(p15.Stamina, nil, 1 / p23, p24);
    elseif v39 and (not Landed and v41 ~= nil) then
        p17.Stamina = ProvenSimulator.finishStamina(p15.Stamina, v41, 1 / p23, p24);
        p17.Velocity = ProvenSimulator.applyLandingVelocity(p17.Velocity, p24);
    end;

    p19.Landed = v39;
    p19.LeftGround = v40;
    p19.ImpactVelocityY = v41;
    DeterminismTrace.checkpoint(p25, "runtime.playerContacts.eventsFinalize", p17, v31, nil);
    assert(p17.OnGround == (v31.Kind ~= Enums.SupportKind.None), "post-contact ground invariant is broken");

    return p17, v31, p19;
end;

return table.freeze(v1);