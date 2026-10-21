-- ReplicatedStorage.MovementV2.Simulation
-- Script path: ReplicatedStorage.MovementV2.Simulation
-- Decompile time: 7.92 ms

-- Decompiled with Potassium's decompiler.

local Buttons = require(script.Parent.Buttons);
local Serial = require(script.Parent.Serial);
local DamageTag = require(script.Parent.DamageTag);
local Enums = require(script.Parent.Enums);
require(script.Parent.Types);
local script_Config = require(script.Config);
local script_DeterminismTrace = require(script.DeterminismTrace);
local script_PlayerContacts = require(script.PlayerContacts);
require(script.PlayerHullClearance);
local script_PlayerSupportQuery = require(script.PlayerSupportQuery);
local script_ProvenCollisionAdapter = require(script.ProvenCollisionAdapter);
local script_ProvenSimulator = require(script.ProvenSimulator);
local script_Solver = require(script.Solver);
local script_State = require(script.State);
local script_Types = require(script.Types);
local v1 = {};

local function activeSupportVelocity(p2, p3) -- Line: 31
    -- upvalues: Enums (copy)
    if p2.Kind == 0 or p2.SourceId == 0 then
        return Vector3.new(0, 0, 0);
    end;

    local v4;

    if p3 == nil or (p3.Kind ~= p2.Kind or p3.SourceId ~= p2.SourceId) then
        v4 = p2.Velocity;
    else
        v4 = p3.Velocity;
    end;

    if p2.Kind == Enums.SupportKind.Player then
        return Vector3.new(v4.X, 0, v4.Z);
    end;

    return v4;
end;

local function applySupportCarry(p5: any, p6: any, p7: any, p8: any, p9: any, p10: number) -- Line: 44
    -- upvalues: Enums (copy), script_Solver (copy)
    if not (p5.OnGround and (p6.Kind ~= 0 and (p6.SourceId ~= 0 and (p7 ~= nil and (p7.Kind == p6.Kind and (p7.SourceId == p6.SourceId and p7.Delta.Magnitude > p9.PlaneEpsilon)))))) then
        return false, false, Vector3.new(0, 0, 0);
    end;

    local Delta = p7.Delta;

    if p6.Kind == Enums.SupportKind.Mover then
        local Velocity = p7.Velocity;
        Delta = Delta - Vector3.new(Velocity.X, 0, Velocity.Z) * p10;
    end;

    local v11 = script_Solver.slideDisplacement(p5.Position, Delta, p5.Stance, p8, p6, 1, 1, p9);
    p5.Position = v11.Position;

    return v11.Blocked, v11.StartSolid, v11.WallNormal;
end;

local u12 = {
    SourceId = 0,
    Anchor = Vector3.new(0, 0, 0),
    Velocity = Vector3.new(0, 0, 0),
    Kind = Enums.SupportKind.Mover
};

local function applyMoverPush(p13, p14, p15, p16) -- Line: 87
    -- upvalues: Enums (copy), u12 (copy), script_Solver (copy)
    local FindMoverPush = p15.FindMoverPush;
    local PenetratesMover = p15.PenetratesMover;

    if FindMoverPush == nil or PenetratesMover == nil then
        return nil;
    end;

    local v17 = 0;
    local v18 = nil;

    while true do
        local v19;
        v17, v19 = FindMoverPush(p15, p13.Position, p13.Stance, v17, 0.01);

        if v17 == nil then
            break;
        end;

        if p14.Kind ~= Enums.SupportKind.Mover or p14.SourceId ~= v17 then
            u12.SourceId = v17;
            local v20 = script_Solver.slideDisplacement(p13.Position, v19, p13.Stance, p15, u12, 1, 1, p16);

            if PenetratesMover(p15, v17, v20.Position, p13.Stance) then
                v18 = v18 or v17;
            else
                p13.Position = v20.Position;
            end;
        end;
    end;

    return v18;
end;

local u21 = {};
local u22 = {};
local u23 = {};

local function toProvenState(p24: any, p25: vector, p26: any, p27: any) -- Line: 136
    -- upvalues: Enums (copy), Buttons (copy)
    local v28;

    if p24.OnGround then
        v28 = p24.Velocity + p25;
    else
        v28 = p24.Velocity;
    end;

    local v29 = p27 or {};

    if p27 then
        table.clear(p27);
    end;

    v29.Position = p24.Position;
    v29.Velocity = v28;
    v29.OnGround = p24.OnGround;
    v29.GroundSupportIsDynamicPlayer = p24.OnGround and p26.Kind == Enums.SupportKind.Player;
    v29.GroundNormal = p24.GroundNormal;
    v29.GroundSurfaceFriction = p24.GroundSurfaceFriction;
    v29.WallNormal = p24.WallNormal;
    v29.DuckAmount = p24.DuckAmount;
    v29.DuckTimeMsecs = p24.DuckTimeMsecs;
    v29.IsDucking = p24.IsDucking;
    v29.DuckHeld = Buttons.has(p24.PreviousButtons, Buttons.Duck);
    v29.DuckFatigueLevel = p24.DuckSpeed * 10;
    v29.DuckFatigueTimerMsecs = p24.DuckCooldownSeconds * 1000;
    v29.MovementType = p24.MovementMode;
    v29.Stamina = p24.Stamina;
    v29.LastJumpTick = p24.LastJumpCommandNumber == 4294967295 and -1024 or p24.LastJumpCommandNumber;
    v29.JumpHeld = Buttons.has(p24.PreviousButtons, Buttons.Jump);
    v29.JumpBufferTicksRemaining = p24.JumpBufferTicksRemaining;
    v29.JumpHullActive = p24.JumpHullActive;
    v29.StuckStepTicks = p24.StuckStepTicks;

    return v29;
end;

local function toProvenInput(p30: any, p31: number, p32: number, p33: any) -- Line: 165
    -- upvalues: Buttons (copy)
    local v34 = p33 or {};

    if p33 then
        table.clear(p33);
    end;

    v34.Tick = p30.CommandNumber;
    v34.MoveVector = p30.Move;
    v34.LookYaw = p30.LookYaw;
    v34.VerticalLook = p30.VerticalLook;
    v34.Jump = Buttons.has(p30.Buttons, Buttons.Jump);
    v34.Duck = Buttons.has(p30.Buttons, Buttons.Duck);
    v34.Walk = Buttons.has(p30.Buttons, Buttons.Walk);
    local v35 = Buttons.has(p30.Buttons, Buttons.Sprint) and not Buttons.has(p30.Buttons, Buttons.Scoped);
    v34.Sprint = v35;
    v34.BaseMoveSpeed = p31 * p32;

    return v34;
end;

local function outputStance(p36) -- Line: 184
    return (p36.DuckAmount >= 0.999 or p36.JumpHullActive == true) and "Ducking" or "Standing";
end;

function v1.step(p37: any, p38: any, p39: any, p40: number, p41: any, p42: any, p43: any, p44: any, p45: any) -- Line: 188
    -- upvalues: script_Config (copy), script_DeterminismTrace (copy), script_State (copy), Enums (copy), script_PlayerSupportQuery (copy), u21 (copy), applySupportCarry (copy), applyMoverPush (copy), activeSupportVelocity (copy), script_ProvenCollisionAdapter (copy), toProvenState (copy), u22 (copy), toProvenInput (copy), u23 (copy), script_ProvenSimulator (copy), DamageTag (copy), Serial (copy), Buttons (copy)
    local v46;

    if p40 == p40 and p40 > 0 then
        v46 = p40 < (1 / 0);
    else
        v46 = false;
    end;

    assert(v46, "MovementV2 simulation step must be finite and positive");
    assert(p38.Kind == 0 == (p38.SourceId == 0), "MovementV2 support identity is not canonical");
    assert(p37.OnGround == (p38.Kind ~= 0), "MovementV2 state/support ground invariant is broken");
    local v47 = p43 or script_Config.Default;
    script_DeterminismTrace.checkpoint(p44, "simulation.input", p37, p38, p39);
    local v48 = script_State.cloneSupport(p38);
    local v49;

    if v48.Kind == Enums.SupportKind.Player and (p42 ~= nil and (p42.Kind == v48.Kind and (p42.SourceId == v48.SourceId and (p42.Position ~= nil and p42.Stance ~= nil)))) then
        v49 = script_PlayerSupportQuery.new(p41, v48, p42, v47);
    else
        v49 = p41;
    end;

    local v50 = p44 == nil;
    local v51;

    if v50 then
        v51 = script_State.cloneInto(u21, p37);
    else
        v51 = script_State.clone(p37);
    end;

    local v52, v53, v54 = applySupportCarry(v51, v48, p42, v49, v47, p40);
    script_DeterminismTrace.checkpoint(p44, "simulation.supportCarry", v51, v48, p42);
    local v55 = applyMoverPush(v51, v48, p41, v47);
    script_DeterminismTrace.checkpoint(p44, "simulation.moverPush", v51, v48, nil);
    local v56 = activeSupportVelocity(v48, p42);
    local v57;

    if p37.OnGround then
        v57 = p37.Velocity + v56;
    else
        v57 = p37.Velocity;
    end;

    local v58;

    if p37.OnGround then
        v58 = v56;
    else
        v58 = nil;
    end;

    local v59 = script_ProvenCollisionAdapter.acquire(v49, v47, v48, p44, v58, p45);
    local v60;

    if v50 then
        v60 = u22;
    else
        v60 = nil;
    end;

    local v61 = toProvenState(v51, v56, v48, v60);
    local v62;

    if v50 then
        v62 = u23;
    else
        v62 = nil;
    end;

    local v63 = toProvenInput(p39, p37.BaseMoveSpeed, p37.VelocityModifier, v62);
    script_DeterminismTrace.checkpoint(p44, "simulation.provenInput", v61, v48, p39);
    local v64, v65 = script_ProvenSimulator.step(v61, v63, p40, v59, v47, p44);
    script_DeterminismTrace.checkpoint(p44, "simulation.provenOutput", v64, nil, nil);
    local v66 = (v64.DuckAmount >= 0.999 or v64.JumpHullActive == true) and "Ducking" or "Standing";
    local v67 = script_State.noneSupport();
    local OnGround = v64.OnGround;
    local Velocity = v64.Velocity;
    local GroundNormal = v64.GroundNormal;
    local GroundSurfaceFriction = v64.GroundSurfaceFriction;

    if OnGround then
        local v68 = v59:ResolveGroundTrace(v65, v64.Position);

        if v68 == nil then
            v68 = v49:FindGround(v64.Position, v66, math.max(v47.GroundProbeDistance, v47.MaxStepHeight), 1, v48);
        end;

        if v68 == nil then
            GroundSurfaceFriction = v47.SurfaceFrictionDefault;
            OnGround = false;
        else
            v67 = script_State.cloneSupport(v68.Support);
            local v69 = v64.Velocity - v68.Support.Velocity;
            Velocity = Vector3.new(v69.X, 0, v69.Z);
            GroundNormal = v68.Normal;
            GroundSurfaceFriction = v68.SurfaceFriction;
        end;
    end;

    local v70 = {
        Position = v64.Position,
        Velocity = Velocity,
        LookYaw = p39.LookYaw,
        VerticalLook = p39.VerticalLook,
        BaseMoveSpeed = p37.BaseMoveSpeed,
        WeaponMoveSpeed = p37.WeaponMoveSpeed,
        WeaponScopedMoveSpeed = p37.WeaponScopedMoveSpeed,
        VelocityModifier = DamageTag.recover(p37.VelocityModifier, p40),
        MovementTick = Serial.addUInt32(p37.MovementTick, 1),
        MovementMode = v64.MovementType,
        Stance = v66,
        OnGround = OnGround,
        GroundNormal = not OnGround and Vector3.new(0, 1, 0) or GroundNormal
    };

    if v54.Magnitude <= 0 then
        v54 = v64.WallNormal;
    end;

    v70.WallNormal = v54;
    v70.GroundSurfaceFriction = GroundSurfaceFriction;
    v70.DuckAmount = v64.DuckAmount;
    v70.DuckTimeMsecs = v64.DuckTimeMsecs;
    v70.IsDucking = v64.IsDucking;
    v70.DuckSpeed = v64.DuckFatigueLevel / 10;
    v70.DuckCooldownSeconds = v64.DuckFatigueTimerMsecs / 1000;
    v70.Stamina = v64.Stamina;
    v70.LastJumpCommandNumber = v64.LastJumpTick < 0 and 4294967295 or v64.LastJumpTick;
    v70.PreviousButtons = p39.Buttons;
    v70.JumpBufferTicksRemaining = v64.JumpBufferTicksRemaining;
    v70.JumpHullActive = v64.JumpHullActive;
    v70.StuckStepTicks = v64.StuckStepTicks;
    script_DeterminismTrace.checkpoint(p44, "simulation.outputConversion", v70, v67, nil);
    local v71 = not p37.OnGround and v70.OnGround;
    local v72 = p37.OnGround and not v70.OnGround;
    local v73 = v72 and Buttons.has(p39.Buttons, Buttons.Jump) and v64.Velocity.Y > v47.VelocityEpsilon;
    local v74 = {
        Jumped = v73,
        Landed = v71,
        LeftGround = v72
    };
    local v75;

    if v71 then
        v75 = v57.Y;
    else
        v75 = nil;
    end;

    v74.ImpactVelocityY = v75;
    v74.Blocked = v52;
    v74.StartSolid = v53;
    v74.BlockedByMoverId = v55;

    return v70, v67, v74;
end;

v1.Config = script_Config;
v1.DeterminismTrace = script_DeterminismTrace;
v1.PlayerContacts = script_PlayerContacts;
v1.Solver = script_Solver;
v1.State = script_State;
v1.Types = script_Types;

return table.freeze(v1);