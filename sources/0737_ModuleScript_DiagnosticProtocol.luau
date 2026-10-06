-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local u1 = {
    Version = 1,
    TargetName = "MaloniPepperoni",
    MaxClientLogBytes = 12000,
    MaxServerLogBytes = 12000,
    ClientOutputEnabled = false,
    StudioOutputForAllClients = false,
    OwnerTraceEnabled = false,
    DeterminismTraceEnabled = false,
    VerboseGroundTraceEnabled = false,
    AirStrafeTraceEnabled = false,
    PlayerContactOutputEnabled = false
};

function u1.shouldOutputForPlayer(p2: userdata?) -- Line: 61
    -- upvalues: u1 (copy), RunService (copy)
    local ClientOutputEnabled = u1.ClientOutputEnabled;

    if ClientOutputEnabled then
        if p2 == nil then
            ClientOutputEnabled = false;
        else
            ClientOutputEnabled = RunService:IsStudio() and u1.StudioOutputForAllClients or p2.Name == u1.TargetName;
        end;
    end;

    return ClientOutputEnabled;
end;

function u1.shouldReport(p3: userdata?) -- Line: 71
    -- upvalues: u1 (copy), Players (copy)
    if not u1.ClientOutputEnabled then
        return false;
    end;

    if u1.shouldOutputForPlayer(p3) then
        return true;
    end;

    local v4 = Players:FindFirstChild(u1.TargetName);
    local v5;

    if v4 == nil then
        v5 = false;
    else
        v5 = v4:IsA("Player");
    end;

    return v5;
end;

function u1.output(p6: string) -- Line: 83
    -- upvalues: u1 (copy), Players (copy)
    if u1.shouldOutputForPlayer(Players.LocalPlayer) then
        print(p6);
    end;
end;

function u1.outputWarning(p7: string) -- Line: 89
    -- upvalues: u1 (copy), Players (copy)
    if u1.shouldOutputForPlayer(Players.LocalPlayer) then
        warn(p7);
    end;
end;

local table_freeze_ret = table.freeze({
    OwnerCorrection = true,
    Reconciliation = true,
    TraceComparison = true,
    PredictionHitch = true,
    RuntimeWarning = true,
    NetcodeSummary = true
});

local function isFiniteNumber(p8) -- Line: 104
    local v9;

    if typeof(p8) == "number" and (p8 == p8 and p8 > (-1 / 0)) then
        v9 = p8 < (1 / 0);
    else
        v9 = false;
    end;

    return v9;
end;

local function isUInt32(p10) -- Line: 108
    local v11;

    if typeof(p10) == "number" and (p10 % 1 == 0 and p10 >= 0) then
        v11 = p10 <= 4294967295;
    else
        v11 = false;
    end;

    return v11;
end;

local function isOptionalUInt32(p12) -- Line: 112
    local v13;

    if p12 == nil then
        v13 = true;
    elseif typeof(p12) == "number" and (p12 % 1 == 0 and p12 >= 0) then
        v13 = p12 <= 4294967295;
    else
        v13 = false;
    end;

    return v13;
end;

local function validLog(p14: any, p15: number) -- Line: 116
    local v16;

    if typeof(p14) == "string" and (#p14 > 0 and #p14 <= p15) then
        v16 = string.find(p14, "\0", 1, true) == nil;
    else
        v16 = false;
    end;

    return v16;
end;

function u1.isKind(p17) -- Line: 123
    -- upvalues: table_freeze_ret (copy)
    local v18;

    if typeof(p17) == "string" then
        v18 = table_freeze_ret[p17] == true;
    else
        v18 = false;
    end;

    return v18;
end;

function u1.decodeClientReport(p19) -- Line: 128
    -- upvalues: u1 (copy)
    if typeof(p19) ~= "table" then
        return nil;
    end;

    if p19.Version ~= u1.Version or not u1.isKind(p19.Kind) then
        return nil;
    end;

    local Generation = p19.Generation;
    local v20;

    if Generation == nil then
        v20 = true;
    elseif typeof(Generation) == "number" and (Generation % 1 == 0 and Generation >= 0) then
        v20 = Generation <= 4294967295;
    else
        v20 = false;
    end;

    if v20 then
        local ActorId = p19.ActorId;
        local v21;

        if ActorId == nil then
            v21 = true;
        elseif typeof(ActorId) == "number" and (ActorId % 1 == 0 and ActorId >= 0) then
            v21 = ActorId <= 4294967295;
        else
            v21 = false;
        end;

        if v21 then
            local Sequence = p19.Sequence;
            local v22;

            if Sequence == nil then
                v22 = true;
            elseif typeof(Sequence) == "number" and (Sequence % 1 == 0 and Sequence >= 0) then
                v22 = Sequence <= 4294967295;
            else
                v22 = false;
            end;

            if v22 then
                local CommandNumber = p19.CommandNumber;
                local v23;

                if CommandNumber == nil then
                    v23 = true;
                elseif typeof(CommandNumber) == "number" and (CommandNumber % 1 == 0 and CommandNumber >= 0) then
                    v23 = CommandNumber <= 4294967295;
                else
                    v23 = false;
                end;

                if v23 then
                    local ServerTick = p19.ServerTick;
                    local v24;

                    if ServerTick == nil then
                        v24 = true;
                    elseif typeof(ServerTick) == "number" and (ServerTick % 1 == 0 and ServerTick >= 0) then
                        v24 = ServerTick <= 4294967295;
                    else
                        v24 = false;
                    end;

                    if v24 then
                        local ClientServerTime = p19.ClientServerTime;
                        local v25;

                        if typeof(ClientServerTime) == "number" and (ClientServerTime == ClientServerTime and ClientServerTime > (-1 / 0)) then
                            v25 = ClientServerTime < (1 / 0);
                        else
                            v25 = false;
                        end;

                        if v25 then
                            local ClientLog = p19.ClientLog;
                            local MaxClientLogBytes = u1.MaxClientLogBytes;
                            local v26;

                            if typeof(ClientLog) == "string" and (#ClientLog > 0 and #ClientLog <= MaxClientLogBytes) then
                                v26 = string.find(ClientLog, "\0", 1, true) == nil;
                            else
                                v26 = false;
                            end;

                            if v26 then
                                return table.freeze({
                                    Version = u1.Version,
                                    Kind = p19.Kind,
                                    Generation = p19.Generation,
                                    ActorId = p19.ActorId,
                                    Sequence = p19.Sequence,
                                    CommandNumber = p19.CommandNumber,
                                    ServerTick = p19.ServerTick,
                                    ClientServerTime = p19.ClientServerTime,
                                    ClientLog = p19.ClientLog
                                });
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return nil;
end;

function u1.decodeDelivery(p27) -- Line: 160
    -- upvalues: u1 (copy)
    if typeof(p27) ~= "table" then
        return nil;
    end;

    if p27.Version ~= u1.Version or not u1.isKind(p27.Kind) then
        return nil;
    end;

    if type(p27.CorrelationId) == "string" and (#p27.CorrelationId ~= 0 and (#p27.CorrelationId <= 160 and (type(p27.ReporterName) == "string" and (#p27.ReporterName ~= 0 and (#p27.ReporterName <= 20 and (type(p27.ReporterDisplayName) == "string" and (#p27.ReporterDisplayName ~= 0 and #p27.ReporterDisplayName <= 50))))))) then
        local ReporterUserId = p27.ReporterUserId;
        local v28;

        if typeof(ReporterUserId) == "number" and (ReporterUserId == ReporterUserId and ReporterUserId > (-1 / 0)) then
            v28 = ReporterUserId < (1 / 0);
        else
            v28 = false;
        end;

        if v28 then
            local ReceivedServerTime = p27.ReceivedServerTime;
            local v29;

            if typeof(ReceivedServerTime) == "number" and (ReceivedServerTime == ReceivedServerTime and ReceivedServerTime > (-1 / 0)) then
                v29 = ReceivedServerTime < (1 / 0);
            else
                v29 = false;
            end;

            if v29 then
                local ClientLog = p27.ClientLog;
                local MaxClientLogBytes = u1.MaxClientLogBytes;
                local v30;

                if typeof(ClientLog) == "string" and (#ClientLog > 0 and #ClientLog <= MaxClientLogBytes) then
                    v30 = string.find(ClientLog, "\0", 1, true) == nil;
                else
                    v30 = false;
                end;

                if v30 then
                    local ServerLog = p27.ServerLog;
                    local MaxServerLogBytes = u1.MaxServerLogBytes;
                    local v31;

                    if typeof(ServerLog) == "string" and (#ServerLog > 0 and #ServerLog <= MaxServerLogBytes) then
                        v31 = string.find(ServerLog, "\0", 1, true) == nil;
                    else
                        v31 = false;
                    end;

                    if v31 then
                        return table.freeze({
                            Version = u1.Version,
                            CorrelationId = p27.CorrelationId,
                            Kind = p27.Kind,
                            ReporterName = p27.ReporterName,
                            ReporterDisplayName = p27.ReporterDisplayName,
                            ReporterUserId = p27.ReporterUserId,
                            ReceivedServerTime = p27.ReceivedServerTime,
                            ClientLog = p27.ClientLog,
                            ServerLog = p27.ServerLog
                        });
                    end;
                end;
            end;
        end;
    end;

    return nil;
end;

return table.freeze(u1);