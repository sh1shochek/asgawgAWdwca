-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Signal = require(ReplicatedStorage.Packages.Signal);
local Config = require(script.Parent.Parent.Config);
local DestructibleFrame = require(script.Parent.Parent.Collision.DestructibleFrame);
local Serial = require(script.Parent.Parent.Serial);
local u1 = {};
u1.__index = u1;

local function immutableTransition(p2: number, p3: any) -- Line: 32
    return table.freeze({
        ServerTick = p2,
        Frame = p3
    });
end;

local function latestTransition(p4) -- Line: 39
    return p4._transitions[#p4._transitions];
end;

local function retainedTransition(p5: any, p6: number) -- Line: 43
    -- upvalues: Serial (copy)
    for i = #p5._transitions, 1, -1 do
        local v7 = p5._transitions[i];

        if Serial.deltaUInt32(p6, v7.ServerTick) >= 0 then
            return v7;
        end;

        local _ = i;
    end;

    return nil;
end;

local function requestBaseline(p8: any, p9: string) -- Line: 53
    p8._needsBaseline = true;

    if p8._requestFired then
        return;
    end;

    p8._requestFired = true;
    local v10 = p8._transitions[#p8._transitions];
    p8.BaselineNeeded:Fire(p8._expectedEpoch, v10 == nil and 0 or v10.Frame.Revision, p9);
end;

local function prune(p11: any, p12: number) -- Line: 63
    -- upvalues: Serial (copy)
    while #p11._transitions > 1 and Serial.deltaUInt32(p12, p11._transitions[2].ServerTick) >= p11._retentionTicks do
        table.remove(p11._transitions, 1);
    end;
end;

local function deactivate(p13: any, p14: table, p15: number) -- Line: 73
    -- upvalues: Serial (copy), DestructibleFrame (copy)
    local v16 = 0;
    local v17 = {};
    local v18 = {};

    for _, v in p14 do
        if not (Serial.isUInt16(v) and (v ~= 0 and (p13.Count >= v and v > v16))) then
            return nil, "InvalidDeltaIndices";
        end;

        local v19 = v - 1;
        local v20 = math.floor(v19 / 8) + 1;
        local bit32_lshift_ret = bit32.lshift(1, v19 % 8);
        local v21 = v17[v20];

        if v21 == nil then
            v21 = string.byte(p13.ActiveBits, v20);
            v18[#v18 + 1] = v20;
        end;

        if bit32.band(v21, bit32_lshift_ret) == 0 then
            return nil, "DeltaDeactivatesInactiveSource";
        end;

        local bit32_bnot_ret = bit32.bnot(bit32_lshift_ret);
        v17[v20] = bit32.band(v21, bit32_bnot_ret);
        v16 = v;
    end;

    local table_create_ret = table.create(#v18 * 2 + 1);
    local v22 = 1;

    for _, v in v18 do
        if v22 < v then
            table_create_ret[#table_create_ret + 1] = string.sub(p13.ActiveBits, v22, v - 1);
        end;

        table_create_ret[#table_create_ret + 1] = string.char(v17[v]);
        v22 = v + 1;
    end;

    if v22 <= #p13.ActiveBits then
        table_create_ret[#table_create_ret + 1] = string.sub(p13.ActiveBits, v22);
    end;

    return DestructibleFrame.New(p13.Epoch, p15, p13.Count, table.concat(table_create_ret)), nil;
end;

function u1.new(p23: number, p24: number, p25: number) -- Line: 117
    -- upvalues: Config (copy), Serial (copy), DestructibleFrame (copy), Signal (copy), u1 (copy)
    local v26 = Config.derive(p23);
    local v27 = Serial.isNonZeroUInt16(p24);
    assert(v27, "destructible timeline epoch must be a non-zero u16");
    local v28, v29 = DestructibleFrame.Validate(p24, 0, p25, string.rep("\0", (math.ceil(p25 / 8))));
    assert(v28, v29);
    local v30 = {
        _needsBaseline = true,
        _requestFired = false,
        _expectedEpoch = p24,
        _expectedCount = p25,
        _retentionTicks = v26.PredictionReplayTicks,
        _transitions = {},
        BaselineNeeded = Signal.new()
    };

    return setmetatable(v30, u1);
end;

function u1.fork(p31) -- Line: 143
    -- upvalues: Signal (copy), u1 (copy)
    local table_clone_ret = table.clone(p31);
    table_clone_ret._transitions = table.clone(p31._transitions);
    table_clone_ret.BaselineNeeded = Signal.new();

    return setmetatable(table_clone_ret, u1);
end;

function u1.destroy(p32) -- Line: 150
    p32.BaselineNeeded:Destroy();
    table.clear(p32._transitions);
end;

function u1.needsBaseline(p33) -- Line: 155
    return p33._needsBaseline;
end;

function u1.requestBaseline(p34: table, p35: string) -- Line: 159
    p34._needsBaseline = true;

    if p34._requestFired then
        return;
    end;

    p34._requestFired = true;
    local v36 = p34._transitions[#p34._transitions];
    p34.BaselineNeeded:Fire(p34._expectedEpoch, v36 == nil and 0 or v36.Frame.Revision, p35);
end;

function u1.latestRevision(p37) -- Line: 163
    local v38 = p37._transitions[#p37._transitions];

    return v38 == nil and 0 or v38.Frame.Revision;
end;

function u1.consumeBaseline(p39: table, p40: number, p41: any) -- Line: 168
    -- upvalues: Serial (copy), DestructibleFrame (copy)
    if not Serial.isUInt32(p40) then
        return false, "InvalidBaselineServerTick";
    end;

    local v42, v43 = DestructibleFrame.Validate(p41.Epoch, p41.Revision, p41.Count, p41.ActiveBits);

    if not v42 then
        return false, v43;
    end;

    if p41.Epoch ~= p39._expectedEpoch then
        p39._needsBaseline = true;

        if not p39._requestFired then
            p39._requestFired = true;
            local v44 = p39._transitions[#p39._transitions];
            p39.BaselineNeeded:Fire(p39._expectedEpoch, v44 == nil and 0 or v44.Frame.Revision, "BaselineEpochMismatch");
        end;

        return false, "BaselineEpochMismatch";
    end;

    if p41.Count ~= p39._expectedCount then
        p39._needsBaseline = true;

        if not p39._requestFired then
            p39._requestFired = true;
            local v45 = p39._transitions[#p39._transitions];
            p39.BaselineNeeded:Fire(p39._expectedEpoch, v45 == nil and 0 or v45.Frame.Revision, "BaselineCountMismatch");
        end;

        return false, "BaselineCountMismatch";
    end;

    local v46 = p39._transitions[#p39._transitions];

    if v46 ~= nil and (v46.Frame.Revision == p41.Revision and v46.Frame.ActiveBits == p41.ActiveBits) then
        p39._needsBaseline = false;
        p39._requestFired = false;

        return true, nil, false;
    end;

    local v47 = DestructibleFrame.New(p41.Epoch, p41.Revision, p41.Count, p41.ActiveBits);
    table.clear(p39._transitions);
    p39._transitions[1] = table.freeze({
        ServerTick = p40,
        Frame = v47
    });
    p39._needsBaseline = false;
    p39._requestFired = false;

    return true, nil, true;
end;

function u1.consumeDelta(p48: table, p49: number, p50: number, p51: number, p52: table) -- Line: 200
    -- upvalues: Serial (copy), deactivate (copy), prune (copy)
    if p48._needsBaseline then
        p48._needsBaseline = true;

        if not p48._requestFired then
            p48._requestFired = true;
            local v53 = p48._transitions[#p48._transitions];
            p48.BaselineNeeded:Fire(p48._expectedEpoch, v53 == nil and 0 or v53.Frame.Revision, "DeltaWithoutBaseline");
        end;

        return false, "BaselineRequired";
    end;

    if p49 ~= p48._expectedEpoch then
        p48._needsBaseline = true;

        if not p48._requestFired then
            p48._requestFired = true;
            local v54 = p48._transitions[#p48._transitions];
            p48.BaselineNeeded:Fire(p48._expectedEpoch, v54 == nil and 0 or v54.Frame.Revision, "DeltaEpochMismatch");
        end;

        return false, "DeltaEpochMismatch";
    end;

    if not (Serial.isUInt32(p50) and Serial.isUInt32(p51)) then
        p48._needsBaseline = true;

        if not p48._requestFired then
            p48._requestFired = true;
            local v55 = p48._transitions[#p48._transitions];
            p48.BaselineNeeded:Fire(p48._expectedEpoch, v55 == nil and 0 or v55.Frame.Revision, "InvalidDeltaStamp");
        end;

        return false, "InvalidDeltaStamp";
    end;

    local v56 = p48._transitions[#p48._transitions];

    if v56 == nil then
        p48._needsBaseline = true;

        if not p48._requestFired then
            p48._requestFired = true;
            local v57 = p48._transitions[#p48._transitions];
            p48.BaselineNeeded:Fire(p48._expectedEpoch, v57 == nil and 0 or v57.Frame.Revision, "DeltaWithoutBaseline");
        end;

        return false, "BaselineRequired";
    end;

    if p50 ~= Serial.addUInt32(v56.Frame.Revision, 1) then
        p48._needsBaseline = true;

        if not p48._requestFired then
            p48._requestFired = true;
            local v58 = p48._transitions[#p48._transitions];
            p48.BaselineNeeded:Fire(p48._expectedEpoch, v58 == nil and 0 or v58.Frame.Revision, "DestructibleRevisionGap");
        end;

        return false, "DestructibleRevisionGap";
    end;

    if Serial.deltaUInt32(p51, v56.ServerTick) <= 0 then
        p48._needsBaseline = true;

        if not p48._requestFired then
            p48._requestFired = true;
            local v59 = p48._transitions[#p48._transitions];
            p48.BaselineNeeded:Fire(p48._expectedEpoch, v59 == nil and 0 or v59.Frame.Revision, "DeltaTickNotNewer");
        end;

        return false, "DeltaTickNotNewer";
    end;

    if type(p52) ~= "table" or #p52 == 0 then
        p48._needsBaseline = true;

        if not p48._requestFired then
            p48._requestFired = true;
            local v60 = p48._transitions[#p48._transitions];
            p48.BaselineNeeded:Fire(p48._expectedEpoch, v60 == nil and 0 or v60.Frame.Revision, "InvalidDeltaIndices");
        end;

        return false, "InvalidDeltaIndices";
    end;

    local v61, v62 = deactivate(v56.Frame, p52, p50);

    if v61 ~= nil then
        p48._transitions[#p48._transitions + 1] = table.freeze({
            ServerTick = p51,
            Frame = v61
        });
        prune(p48, p51);

        return true, nil;
    end;

    local v63 = v62 or "InvalidDelta";
    p48._needsBaseline = true;

    if not p48._requestFired then
        p48._requestFired = true;
        local v64 = p48._transitions[#p48._transitions];
        p48.BaselineNeeded:Fire(p48._expectedEpoch, v64 == nil and 0 or v64.Frame.Revision, v63);
    end;

    return false, v62;
end;

function u1.resolve(p65: table, p66: number, p67: number?) -- Line: 246
    -- upvalues: Serial (copy), retainedTransition (copy), prune (copy)
    if not Serial.isUInt32(p66) then
        return nil, "InvalidResolveServerTick";
    end;

    if p67 ~= nil and not Serial.isUInt32(p67) then
        return nil, "InvalidExpectedRevision";
    end;

    if p65._needsBaseline then
        p65._needsBaseline = true;

        if not p65._requestFired then
            p65._requestFired = true;
            local v68 = p65._transitions[#p65._transitions];
            p65.BaselineNeeded:Fire(p65._expectedEpoch, v68 == nil and 0 or v68.Frame.Revision, "BaselineRequired");
        end;

        return nil, "BaselineRequired";
    end;

    local v69 = retainedTransition(p65, p66);

    if v69 == nil then
        p65._needsBaseline = true;

        if not p65._requestFired then
            p65._requestFired = true;
            local v70 = p65._transitions[#p65._transitions];
            p65.BaselineNeeded:Fire(p65._expectedEpoch, v70 == nil and 0 or v70.Frame.Revision, "DestructibleFrameOutsideRetention");
        end;

        return nil, "DestructibleFrameOutsideRetention";
    end;

    if p67 == nil or v69.Frame.Revision == p67 then
        prune(p65, p66);

        return v69.Frame, nil;
    end;

    p65._needsBaseline = true;

    if not p65._requestFired then
        p65._requestFired = true;
        local v71 = p65._transitions[#p65._transitions];
        p65.BaselineNeeded:Fire(p65._expectedEpoch, v71 == nil and 0 or v71.Frame.Revision, "DestructibleRevisionMismatch");
    end;

    return nil, "DestructibleRevisionMismatch";
end;

function u1.predict(p72: table, p73: number, p74: number?) -- Line: 272
    -- upvalues: Serial (copy), retainedTransition (copy)
    if not Serial.isUInt32(p73) then
        return nil, "InvalidResolveServerTick";
    end;

    local v75 = retainedTransition(p72, p73) or p72._transitions[1];

    if v75 == nil then
        return nil, "DestructibleFrameOutsideRetention";
    end;

    if p74 == nil or v75.Frame.Revision == p74 then
        return v75.Frame, nil;
    end;

    return nil, "DestructibleRevisionMismatch";
end;

function u1.peek(p76: table, p77: number, p78: number?) -- Line: 288
    -- upvalues: Serial (copy), retainedTransition (copy)
    if not Serial.isUInt32(p77) then
        return nil, "InvalidResolveServerTick";
    end;

    if p78 ~= nil and not Serial.isUInt32(p78) then
        return nil, "InvalidExpectedRevision";
    end;

    if p76._needsBaseline then
        return nil, "BaselineRequired";
    end;

    local v79 = retainedTransition(p76, p77);

    if v79 == nil then
        return nil, "DestructibleFrameOutsideRetention";
    end;

    if p78 == nil or v79.Frame.Revision == p78 then
        return v79.Frame, nil;
    end;

    return nil, "DestructibleRevisionMismatch";
end;

return table.freeze(u1);