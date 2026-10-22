-- ReplicatedStorage.GameClient.SpectateInterp
-- Script path: ReplicatedStorage.GameClient.SpectateInterp
-- Decompile time: 14.38 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = 64;
local u6 = 64;
local u7 = 0;
local u8 = nil;
local u9 = false;

local function IsFiniteNumber(p10) -- Line: 163
    local v11;

    if type(p10) == "number" and (p10 == p10 and p10 ~= (1 / 0)) then
        v11 = p10 ~= (-1 / 0);
    else
        v11 = false;
    end;

    return v11;
end;

local function ToVector(p12) -- Line: 175
    local v13 = typeof(p12);

    if v13 == "vector" then
        return p12 == p12 and p12 and p12 or nil;
    end;

    if v13 ~= "Vector3" then
        return nil;
    end;

    local X = p12.X;
    local v14;

    if type(X) == "number" and (X == X and X ~= (1 / 0)) then
        v14 = X ~= (-1 / 0);
    else
        v14 = false;
    end;

    if v14 then
        local Y = p12.Y;
        local v15;

        if type(Y) == "number" and (Y == Y and Y ~= (1 / 0)) then
            v15 = Y ~= (-1 / 0);
        else
            v15 = false;
        end;

        if v15 then
            local Z = p12.Z;
            local v16;

            if type(Z) == "number" and (Z == Z and Z ~= (1 / 0)) then
                v16 = Z ~= (-1 / 0);
            else
                v16 = false;
            end;

            if v16 then
                return vector.create(p12.X, p12.Y, p12.Z);
            end;
        end;
    end;

    return nil;
end;

local function ToAbsoluteTick(p17: number) -- Line: 210
    -- upvalues: u3 (ref)
    local v18 = u3 and u3.GetLatestSnapshotTick() or 0;

    if v18 <= 0 then
        return nil;
    end;

    return v18 + ((p17 - v18 + 32768) % 65536 - 32768);
end;

local function LerpAngle(p19: number, p20: number, p21: number) -- Line: 231
    return p19 + ((p20 - p19 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p21;
end;

local function LerpOptional(p22: number?, p23: number?, p24: number) -- Line: 239
    if p22 == nil then
        return p23;
    end;

    if p23 == nil then
        return p22;
    end;

    return p22 + (p23 - p22) * p24;
end;

local function CanExtrapolate(p25: number, p26: number?, p27: number) -- Line: 264
    local v28;

    if p26 == nil or p25 > p26 then
        v28 = false;
    else
        v28 = p27 - p25 <= 0.5;
    end;

    return v28;
end;

local function FindBracket(p29: number) -- Line: 273
    -- upvalues: u4 (ref)
    for i = u4.Count - 1, 1, -1 do
        local v30 = u4:Get(i);

        if v30 and v30.DisplayTick <= p29 then
            return v30, u4:Get(i + 1);
        end;

        local _ = i;
    end;

    return nil, nil;
end;

local function BuildCFrame(p31: any, p32: number, p33: number, p34: number) -- Line: 294
    return CFrame.fromEulerAnglesYXZ(p32, p33, p34) + p31;
end;

local function Pose(p35) -- Line: 300
    local Position = p35.Position;

    return CFrame.fromEulerAnglesYXZ(p35.Pitch, p35.Yaw, p35.Roll) + Position, p35.AnimationName, p35.AnimationAlpha, p35.Inaccuracy, p35.AimPunchAngle, p35.Velocity;
end;

local function Blend(p36: any, p37: any, p38: number) -- Line: 316
    local v39 = p36.Position + (p37.Position - p36.Position) * p38;
    local Pitch = p36.Pitch;
    local Yaw = p36.Yaw;
    local Roll = p36.Roll;
    local v40 = CFrame.fromEulerAnglesYXZ(Pitch + ((p37.Pitch - Pitch + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p38, Yaw + ((p37.Yaw - Yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p38, Roll + ((p37.Roll - Roll + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p38) + v39;
    local AnimationName = p36.AnimationName;
    local AnimationAlpha = p36.AnimationAlpha;

    if p36.AnimationName == p37.AnimationName then
        local v41 = p36.AnimationAlpha and p37.AnimationAlpha;

        if v41 then
            if math.abs(p37.AnimationAlpha - p36.AnimationAlpha) > 0.5 then
                v41 = true;
            elseif p37.AnimationAlpha < p36.AnimationAlpha then
                v41 = (p37.AnimationName or ""):sub(1, 7) ~= "Inspect";
            else
                v41 = false;
            end;
        end;

        AnimationAlpha = v41 and p37.AnimationAlpha;

        if not AnimationAlpha then
            AnimationAlpha = p36.AnimationAlpha;
            local AnimationAlpha2 = p37.AnimationAlpha;

            if AnimationAlpha == nil then
                AnimationAlpha = AnimationAlpha2;
            elseif AnimationAlpha2 ~= nil then
                AnimationAlpha = AnimationAlpha + (AnimationAlpha2 - AnimationAlpha) * p38;
            end;
        end;
    end;

    local Inaccuracy = p36.Inaccuracy;
    local Inaccuracy2 = p37.Inaccuracy;

    if Inaccuracy == nil then
        Inaccuracy = Inaccuracy2;
    elseif Inaccuracy2 ~= nil then
        Inaccuracy = Inaccuracy + (Inaccuracy2 - Inaccuracy) * p38;
    end;

    local AimPunchAngle = p36.AimPunchAngle;
    local v42;

    if AimPunchAngle and p37.AimPunchAngle then
        v42 = AimPunchAngle + (p37.AimPunchAngle - AimPunchAngle) * p38;
    else
        v42 = AimPunchAngle or p37.AimPunchAngle;
    end;

    local Velocity = p36.Velocity;
    local v43;

    if Velocity and p37.Velocity then
        v43 = Velocity + (p37.Velocity - Velocity) * p38;
    else
        v43 = Velocity or p37.Velocity;
    end;

    return v40, AnimationName, AnimationAlpha, Inaccuracy, v42, v43;
end;

function u1.Smoothstep(p44: number) -- Line: 375
    return p44 * p44 * (3 - p44 * 2);
end;

function u1.SetTickRate(p45: number) -- Line: 390
    -- upvalues: u6 (ref), u5 (ref), u4 (ref), u1 (copy)
    local v46;

    if type(p45) == "number" and (p45 == p45 and p45 ~= (1 / 0)) then
        v46 = p45 ~= (-1 / 0);
    else
        v46 = false;
    end;

    if not v46 or p45 <= 0 then
        warn((`[SpectateInterp] SetTickRate got {tostring(p45)}; falling back to 64`));
        p45 = 64;
    end;

    local math_clamp_ret = math.clamp(p45, 1, 1000);
    u6 = math_clamp_ret;
    local math_ceil_ret = math.ceil(math_clamp_ret * 1);
    local math_max_ret = math.max(8, math_ceil_ret);

    if math_max_ret ~= u5 then
        u5 = math_max_ret;
        u4 = nil;
    end;

    u1.Reset();
end;

function u1.Push(p47: any, p48: number, p49: boolean?, p50: number?) -- Line: 422
    -- upvalues: u9 (ref), ToVector (copy), u3 (ref), u4 (ref), u2 (ref), u5 (ref), u7 (ref), u8 (ref)
    if type(p47) ~= "table" then
        if not u9 then
            u9 = true;
            warn((`[SpectateInterp] Push expected a table, got {typeof(p47)}; packet dropped`));
        end;

        return;
    end;

    local v51;

    if type(p48) == "number" and (p48 == p48 and p48 ~= (1 / 0)) then
        v51 = p48 ~= (-1 / 0);
    else
        v51 = false;
    end;

    if not v51 then
        if not u9 then
            u9 = true;
            warn((`[SpectateInterp] Push expected a finite server tick, got {tostring(p48)}; packet dropped`));
        end;

        return;
    end;

    local v52 = ToVector(p47.Position);

    if v52 then
        local Pitch = p47.Pitch;
        local v53;

        if type(Pitch) == "number" and (Pitch == Pitch and Pitch ~= (1 / 0)) then
            v53 = Pitch ~= (-1 / 0);
        else
            v53 = false;
        end;

        if v53 then
            local Yaw = p47.Yaw;
            local v54;

            if type(Yaw) == "number" and (Yaw == Yaw and Yaw ~= (1 / 0)) then
                v54 = Yaw ~= (-1 / 0);
            else
                v54 = false;
            end;

            if v54 then
                local Roll = p47.Roll;
                local v55;

                if type(Roll) == "number" and (Roll == Roll and Roll ~= (1 / 0)) then
                    v55 = Roll ~= (-1 / 0);
                else
                    v55 = false;
                end;

                if v55 then
                    local v56 = p48 % 65536;
                    local v57 = u3 and u3.GetLatestSnapshotTick() or 0;
                    local v58;

                    if v57 <= 0 then
                        v58 = nil;
                    else
                        v58 = v57 + ((v56 - v57 + 32768) % 65536 - 32768);
                    end;

                    if not v58 then
                        return;
                    end;

                    if not u4 then
                        if not u2 then
                            return;
                        end;

                        u4 = u2.new(u5);
                    end;

                    local v59 = u4:Newest();

                    if v59 and v58 <= v59.Tick then
                        return;
                    end;

                    p47.Position = v52;
                    p47.Velocity = ToVector(p47.Velocity);
                    local v60 = p50 or os.clock();
                    u7 = v60;

                    if p49 ~= false then
                        u8 = v60;
                    end;

                    u4:Push(v58, nil, p47).DisplayTick = v58;

                    return;
                end;
            end;
        end;
    end;

    if not u9 then
        u9 = true;
        warn("[SpectateInterp] dropped a snapshot with a missing or non-finite Position/Pitch/Yaw/Roll");
    end;
end;

function u1.Sample(p61: number?, p62: number?, p63: number?) -- Line: 510
    -- upvalues: u4 (ref), Pose (copy), u3 (ref), u6 (ref), u7 (ref), u8 (ref), Blend (copy), FindBracket (copy)
    if not u4 or u4.Count == 0 then
        return nil;
    end;

    local v64 = u4:Newest();

    if u4.Count == 1 then
        return Pose(v64.Snapshot);
    end;

    if not p61 then
        if not u3 then
            return Pose(v64.Snapshot);
        end;

        p61, p62 = u3.GetPlayheadTick();
    end;

    local v65 = p62 or u6;

    if p61 <= 0 then
        return Pose(v64.Snapshot);
    end;

    local v66 = p63 or os.clock();
    local v67 = u4:Get(1);

    if p61 <= v67.DisplayTick then
        return Pose(v67.Snapshot);
    end;

    if v64.DisplayTick > p61 then
        local v68, v69 = FindBracket(p61);

        if not (v68 and v69) then
            return Pose(v64.Snapshot);
        end;

        local v70 = v69.DisplayTick - v68.DisplayTick;

        return Blend(v68.Snapshot, v69.Snapshot, v70 > 0 and ((p61 - v68.DisplayTick) / v70 or 0) or 0);
    end;

    local v71 = u4:Get(u4.Count - 1);
    local v72 = v64.DisplayTick - v71.DisplayTick;
    local v73 = u7;
    local v74 = u8;
    local v75;

    if v74 == nil or v73 > v74 then
        v75 = false;
    else
        v75 = v66 - v73 <= 0.5;
    end;

    if not v75 or v72 <= 0 then
        return Pose(v64.Snapshot);
    end;

    local v76 = math.min((p61 - v64.DisplayTick) / v65, 0.25) * v65;

    return Blend(v71.Snapshot, v64.Snapshot, 1 + v76 / v72);
end;

function u1.Reset() -- Line: 602
    -- upvalues: u4 (ref), u7 (ref), u8 (ref)
    if u4 then
        u4:Clear();
    end;

    u7 = 0;
    u8 = nil;
end;

function u1.BlendPose(p77, p78, p79: number, p80: function?) -- Line: 628
    if not p77 then
        return p78;
    end;

    if not p78 then
        return p77;
    end;

    local v81;

    if type(p79) == "number" and (p79 == p79 and p79 ~= (1 / 0)) then
        v81 = p79 ~= (-1 / 0);
    else
        v81 = false;
    end;

    if not v81 then
        return p78;
    end;

    local math_clamp_ret = math.clamp(p79, 0, 1);

    if p80 then
        local v82 = p80(math_clamp_ret);
        math_clamp_ret = math.clamp(v82, 0, 1);
    end;

    return p77:Lerp(p78, math_clamp_ret);
end;

function u1.Init(p83) -- Line: 653
    -- upvalues: u2 (ref), u3 (ref)
    u2 = p83:GetModule("SnapshotRing");
    u3 = p83:GetModule("Entities");
end;

return u1;