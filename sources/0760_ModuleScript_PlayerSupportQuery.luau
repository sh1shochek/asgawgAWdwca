-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
require(script.Parent.Parent.Types);
require(script.Parent.Config);
require(script.Parent.Types);
local u1 = {};
u1.__index = u1;

local function halfSize(p2, p3) -- Line: 29
    local v4;

    if p2 == "Ducking" then
        v4 = p3.PlayerSizeDucking;
    else
        v4 = p3.PlayerSizeStanding;
    end;

    return v4 * 0.5;
end;

local function playerGround(p5: any, p6: vector, p7: any, p8: number) -- Line: 33
    -- upvalues: Enums (copy)
    local Position = p5.Motion.Position;
    local Stance = p5.Motion.Stance;

    if Position == nil or Stance == nil then
        return nil;
    end;

    local Config = p5.Config;
    local v9;

    if p7 == "Ducking" then
        v9 = Config.PlayerSizeDucking;
    else
        v9 = Config.PlayerSizeStanding;
    end;

    local v10 = v9 * 0.5;
    local Config2 = p5.Config;
    local v11;

    if Stance == "Ducking" then
        v11 = Config2.PlayerSizeDucking;
    else
        v11 = Config2.PlayerSizeStanding;
    end;

    local v12 = v11 * 0.5;
    local PositionSnapEpsilon = p5.Config.PositionSnapEpsilon;
    local v13 = p6 - Position;

    if math.abs(v13.X) >= v10.X + v12.X or math.abs(v13.Z) >= v10.Z + v12.Z then
        return nil;
    end;

    local v14 = Position.Y + v12.Y;
    local v15 = p6.Y - v10.Y - v14;

    if v15 < -((p5.Config.GroundProbeStartBump or 0) + PositionSnapEpsilon) or p8 + PositionSnapEpsilon < v15 then
        return nil;
    end;

    local Vector3_new_ret = Vector3.new(p6.X, v14 + v10.Y, p6.Z);
    local Velocity = p5.Motion.Velocity;

    return {
        Normal = Vector3.new(0, 1, 0),
        Position = Vector3_new_ret,
        SurfaceFriction = p5.Config.SurfaceFrictionDefault,
        Support = {
            Kind = Enums.SupportKind.Player,
            SourceId = p5.Support.SourceId,
            Anchor = Vector3_new_ret - Position,
            Velocity = Vector3.new(Velocity.X, 0, Velocity.Z)
        }
    };
end;

function u1.FindPlayerGround(p16: table, p17: vector, p18: any, p19: number) -- Line: 73
    -- upvalues: playerGround (copy)
    return playerGround(p16, p17, p18, p19);
end;

function u1.new(p20, p21, p22, p23) -- Line: 77
    -- upvalues: Enums (copy), u1 (copy)
    local v24;

    if p21.Kind == Enums.SupportKind.Player then
        v24 = p21.SourceId ~= 0;
    else
        v24 = false;
    end;

    assert(v24, "player support query requires player ground");
    local v25;

    if p22.Kind == p21.Kind then
        v25 = p22.SourceId == p21.SourceId;
    else
        v25 = false;
    end;

    assert(v25, "player support motion identity mismatch");

    return setmetatable({
        Base = p20,
        Support = p21,
        Motion = p22,
        Config = p23
    }, u1);
end;

function u1.Sweep(p26: table, p27: vector, p28: vector, p29: any, p30: any, p31: number, p32: number) -- Line: 99
    return p26.Base:Sweep(p27, p28, p29, p30, p31, p32);
end;

function u1.SweepWithFloorSupport(p33: table, p34: vector, p35: vector, p36: any, p37: any, p38: number, p39: number) -- Line: 110
    return p33.Base:SweepWithFloorSupport(p34, p35, p36, p37, p38, p39);
end;

function u1.SweepDetailed(p40: table, p41: vector, p42: vector, p43: any, p44: any, p45: number, p46: number) -- Line: 128
    return p40.Base:SweepDetailed(p41, p42, p43, p44, p45, p46);
end;

function u1.SweepWithFloorSupportDetailed(p47: table, p48: vector, p49: vector, p50: any, p51: any, p52: number, p53: number) -- Line: 146
    return p47.Base:SweepWithFloorSupportDetailed(p48, p49, p50, p51, p52, p53);
end;

function u1.IsClear(p54: table, p55: vector, p56: any, p57: number) -- Line: 164
    return p54.Base:IsClear(p55, p56, p57);
end;

function u1.CanMove(p58: table, p59: vector, p60: vector, p61: any, p62: any, p63: number, p64: number) -- Line: 168
    return p58.Base:CanMove(p59, p60, p61, p62, p63, p64);
end;

function u1.FindGround(p65: table, p66: vector, p67: any, p68: number, p69: number, p70: any) -- Line: 179
    -- upvalues: playerGround (copy)
    local v71 = playerGround(p65, p66, p67, p68);

    if v71 == nil then
        return p65.Base:FindGround(p66, p67, p68, p69, p70);
    end;

    return v71;
end;

function u1.FindLadder(p72: table, p73: vector, p74: any, p75: number, p76: number) -- Line: 193
    local FindLadder = p72.Base.FindLadder;

    if FindLadder == nil then
        return nil;
    end;

    return FindLadder(p72.Base, p73, p74, p75, p76);
end;

function u1.SetMovementBounds(p77: table, p78: vector, p79: vector) -- Line: 203
    local SetMovementBounds = p77.Base.SetMovementBounds;

    if SetMovementBounds ~= nil then
        SetMovementBounds(p77.Base, p78, p79);
    end;
end;

return table.freeze(u1);