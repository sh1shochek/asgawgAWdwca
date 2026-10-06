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
    v34.BaseMoveSpeed = p31 * p32;

    return v34;
end;

local function outputStance(p35) -- Line: 181
    return (p35.DuckAmount >= 0.999 or p35.JumpHullActive == true) and "Ducking" or "Standing";
end;

function v1.step(p36: any, p37: any, p38: any, p39: number, p40: any, p41: any, p42: any, p43: any, p44: any) -- Line: 185
    -- upvalues: script_Config (copy), script_DeterminismTrace (copy), script_State (copy), Enums (copy), script_PlayerSupportQuery (copy), u21 (copy), applySupportCarry (copy), applyMoverPush (copy), activeSupportVelocity (copy), script_ProvenCollisionAdapter (copy), toProvenState (copy), u22 (copy), toProvenInput (copy), u23 (copy), script_ProvenSimulator (copy), DamageTag (copy), Serial (copy), Buttons (copy)
    local v45;

    if p39 == p39 and p39 > 0 then
        v45 = p39 < (1 / 0);
    else
        v45 = false;
    end;

    assert(v45, "MovementV2 simulation step must be finite and positive");
    assert(p37.Kind == 0 == (p37.SourceId == 0), "MovementV2 support identity is not canonical");
    assert(p36.OnGround == (p37.Kind ~= 0), "MovementV2 state/support ground invariant is broken");
    local v46 = p42 or script_Config.Default;
    script_DeterminismTrace.checkpoint(p43, "simulation.input", p36, p37, p38);
    local v47 = script_State.cloneSupport(p37);
    local v48;

    if v47.Kind == Enums.SupportKind.Player and (p41 ~= nil and (p41.Kind == v47.Kind and (p41.SourceId == v47.SourceId and (p41.Position ~= nil and p41.Stance ~= nil)))) then
        v48 = script_PlayerSupportQuery.new(p40, v47, p41, v46);
    else
        v48 = p40;
    end;

    local v49 = p43 == nil;
    local v50;

    if v49 then
        v50 = script_State.cloneInto(u21, p36);
    else
        v50 = script_State.clone(p36);
    end;

    local v51, v52, v53 = applySupportCarry(v50, v47, p41, v48, v46, p39);
    script_DeterminismTrace.checkpoint(p43, "simulation.supportCarry", v50, v47, p41);
    local v54 = applyMoverPush(v50, v47, p40, v46);
    script_DeterminismTrace.checkpoint(p43, "simulation.moverPush", v50, v47, nil);
    local v55 = activeSupportVelocity(v47, p41);
    local v56;

    if p36.OnGround then
        v56 = p36.Velocity + v55;
    else
        v56 = p36.Velocity;
    end;

    local v57;

    if p36.OnGround then
        v57 = v55;
    else
        v57 = nil;
    end;

    local v58 = script_ProvenCollisionAdapter.acquire(v48, v46, v47, p43, v57, p44);
    local v59;

    if v49 then
        v59 = u22;
    else
        v59 = nil;
    end;

    local v60 = toProvenState(v50, v55, v47, v59);
    local v61;

    if v49 then
        v61 = u23;
    else
        v61 = nil;
    end;

    local v62 = toProvenInput(p38, p36.BaseMoveSpeed, p36.VelocityModifier, v61);
    script_DeterminismTrace.checkpoint(p43, "simulation.provenInput", v60, v47, p38);
    local v63, v64 = script_ProvenSimulator.step(v60, v62, p39, v58, v46, p43);
    script_DeterminismTrace.checkpoint(p43, "simulation.provenOutput", v63, nil, nil);
    local v65 = (v63.DuckAmount >= 0.999 or v63.JumpHullActive == true) and "Ducking" or "Standing";
    local v66 = script_State.noneSupport();
    local OnGround = v63.OnGround;
    local Velocity = v63.Velocity;
    local GroundNormal = v63.GroundNormal;
    local GroundSurfaceFriction = v63.GroundSurfaceFriction;

    if OnGround then
        local v67 = v58:ResolveGroundTrace(v64, v63.Position);

        if v67 == nil then
            v67 = v48:FindGround(v63.Position, v65, math.max(v46.GroundProbeDistance, v46.MaxStepHeight), 1, v47);
        end;

        if v67 == nil then
            GroundSurfaceFriction = v46.SurfaceFrictionDefault;
            OnGround = false;
        else
            v66 = script_State.cloneSupport(v67.Support);
            local v68 = v63.Velocity - v67.Support.Velocity;
            Velocity = Vector3.new(v68.X, 0, v68.Z);
            GroundNormal = v67.Normal;
            GroundSurfaceFriction = v67.SurfaceFriction;
        end;
    end;

    local v69 = {
        Position = v63.Position,
        Velocity = Velocity,
        LookYaw = p38.LookYaw,
        VerticalLook = p38.VerticalLook,
        BaseMoveSpeed = p36.BaseMoveSpeed,
        WeaponMoveSpeed = p36.WeaponMoveSpeed,
        WeaponScopedMoveSpeed = p36.WeaponScopedMoveSpeed,
        VelocityModifier = DamageTag.recover(p36.VelocityModifier, p39),
        MovementTick = Serial.addUInt32(p36.MovementTick, 1),
        MovementMode = v63.MovementType,
        Stance = v65,
        OnGround = OnGround,
        GroundNormal = not OnGround and Vector3.new(0, 1, 0) or GroundNormal
    };

    if v53.Magnitude <= 0 then
        v53 = v63.WallNormal;
    end;

    v69.WallNormal = v53;
    v69.GroundSurfaceFriction = GroundSurfaceFriction;
    v69.DuckAmount = v63.DuckAmount;
    v69.DuckTimeMsecs = v63.DuckTimeMsecs;
    v69.IsDucking = v63.IsDucking;
    v69.DuckSpeed = v63.DuckFatigueLevel / 10;
    v69.DuckCooldownSeconds = v63.DuckFatigueTimerMsecs / 1000;
    v69.Stamina = v63.Stamina;
    v69.LastJumpCommandNumber = v63.LastJumpTick < 0 and 4294967295 or v63.LastJumpTick;
    v69.PreviousButtons = p38.Buttons;
    v69.JumpBufferTicksRemaining = v63.JumpBufferTicksRemaining;
    v69.JumpHullActive = v63.JumpHullActive;
    v69.StuckStepTicks = v63.StuckStepTicks;
    script_DeterminismTrace.checkpoint(p43, "simulation.outputConversion", v69, v66, nil);
    local v70 = not p36.OnGround and v69.OnGround;
    local v71 = p36.OnGround and not v69.OnGround;
    local v72 = v71 and Buttons.has(p38.Buttons, Buttons.Jump) and v63.Velocity.Y > v46.VelocityEpsilon;
    local v73 = {
        Jumped = v72,
        Landed = v70,
        LeftGround = v71
    };
    local v74;

    if v70 then
        v74 = v56.Y;
    else
        v74 = nil;
    end;

    v73.ImpactVelocityY = v74;
    v73.Blocked = v51;
    v73.StartSolid = v52;
    v73.BlockedByMoverId = v54;

    return v69, v66, v73;
end;

v1.Config = script_Config;
v1.DeterminismTrace = script_DeterminismTrace;
v1.PlayerContacts = script_PlayerContacts;
v1.Solver = script_Solver;
v1.State = script_State;
v1.Types = script_Types;

return table.freeze(v1);