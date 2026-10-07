-- ReplicatedStorage.MovementV2.DiagnosticProtocol
-- Script path: ReplicatedStorage.MovementV2.DiagnosticProtocol
-- Decompile time: 5.54 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local u10 = {
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
    PlayerContactOutputEnabled = false,
}

function u10.shouldOutputForPlayer(a1) -- Line: 61 -- upvalues: u10 (val), RunService (val) -- types: a1: userdata?
    local ClientOutputEnabled = u10.ClientOutputEnabled
    if ClientOutputEnabled then
        ClientOutputEnabled = false
        if a1 ~= nil then
            ClientOutputEnabled = RunService:IsStudio() and u10.StudioOutputForAllClients or a1.Name == u10.TargetName
        end
    end
    return ClientOutputEnabled
end

function u10.shouldReport(a1) -- Line: 71 -- upvalues: u10 (val), Players (val) -- types: a1: userdata?
    if not u10.ClientOutputEnabled then
        return false
    end
    if u10.shouldOutputForPlayer(a1) then
        return true
    end
    local v1 = Players:FindFirstChild(u10.TargetName)
    local v2 = false
    if v1 ~= nil then
        v2 = v1:IsA("Player")
    end
    return v2
end

function u10.output(a1) -- Line: 83 -- upvalues: u10 (val), Players (val) -- types: a1: string
    if u10.shouldOutputForPlayer(Players.LocalPlayer) then
        print(a1)
    end
end

function u10.outputWarning(a1) -- Line: 89 -- upvalues: u10 (val), Players (val) -- types: a1: string
    if u10.shouldOutputForPlayer(Players.LocalPlayer) then
        warn(a1)
    end
end

local u28 = table.freeze({
    OwnerCorrection = true,
    Reconciliation = true,
    TraceComparison = true,
    PredictionHitch = true,
    RuntimeWarning = true,
    NetcodeSummary = true,
})

local function isFiniteNumber(a1) -- Line: 104
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    return v1
end

local function isUInt32(a1) -- Line: 108
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= 4294967295
            end
        end
    end
    return v1
end

local function isOptionalUInt32(a1) -- Line: 112
    local v1 = true
    if a1 ~= nil then
        v1 = false
        if typeof(a1) == "number" then
            v1 = false
            if a1 % 1 == 0 then
                v1 = false
                if a1 >= 0 then
                    v1 = a1 <= 4294967295
                end
            end
        end
    end
    return v1
end

local function validLog(a1, a2) -- Line: 116 -- types: a2: number
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if #a1 > 0 then
            v1 = false
            if #a1 <= a2 then
                v1 = string.find(a1, "\000", 1, true) == nil
            end
        end
    end
    return v1
end

function u10.isKind(a1) -- Line: 123 -- upvalues: u28 (val)
    local v1 = false
    if typeof(a1) == "string" then
        v1 = u28[a1] == true
    end
    return v1
end

function u10.decodeClientReport(a1) -- Line: 128 -- upvalues: u10 (val)
    if typeof(a1) ~= "table" then
        return nil
    end
    if a1.Version == u10.Version and u10.isKind(a1.Kind) then
        local Generation = a1.Generation
        local v1 = true
        if Generation ~= nil then
            v1 = false
            if typeof(Generation) == "number" then
                v1 = false
                if Generation % 1 == 0 then
                    v1 = false
                    if Generation >= 0 then
                        v1 = Generation <= 4294967295
                    end
                end
            end
        end
        if v1 then
            local ActorId = a1.ActorId
            v1 = true
            if ActorId ~= nil then
                v1 = false
                if typeof(ActorId) == "number" then
                    v1 = false
                    if ActorId % 1 == 0 then
                        v1 = false
                        if ActorId >= 0 then
                            v1 = ActorId <= 4294967295
                        end
                    end
                end
            end
            if v1 then
                local Sequence = a1.Sequence
                v1 = true
                if Sequence ~= nil then
                    v1 = false
                    if typeof(Sequence) == "number" then
                        v1 = false
                        if Sequence % 1 == 0 then
                            v1 = false
                            if Sequence >= 0 then
                                v1 = Sequence <= 4294967295
                            end
                        end
                    end
                end
                if v1 then
                    local CommandNumber = a1.CommandNumber
                    v1 = true
                    if CommandNumber ~= nil then
                        v1 = false
                        if typeof(CommandNumber) == "number" then
                            v1 = false
                            if CommandNumber % 1 == 0 then
                                v1 = false
                                if CommandNumber >= 0 then
                                    v1 = CommandNumber <= 4294967295
                                end
                            end
                        end
                    end
                    if v1 then
                        local ServerTick = a1.ServerTick
                        v1 = true
                        if ServerTick ~= nil then
                            v1 = false
                            if typeof(ServerTick) == "number" then
                                v1 = false
                                if ServerTick % 1 == 0 then
                                    v1 = false
                                    if ServerTick >= 0 then
                                        v1 = ServerTick <= 4294967295
                                    end
                                end
                            end
                        end
                        if v1 then
                            local ClientServerTime = a1.ClientServerTime
                            v1 = false
                            if typeof(ClientServerTime) == "number" then
                                v1 = false
                                if ClientServerTime == ClientServerTime then
                                    v1 = false
                                    if ClientServerTime > (-1 / 0) then
                                        v1 = ClientServerTime < (1 / 0)
                                    end
                                end
                            end
                            if v1 then
                                local ClientLog = a1.ClientLog
                                v1 = false
                                if typeof(ClientLog) == "string" then
                                    v1 = false
                                    if #ClientLog > 0 then
                                        v1 = false
                                        if #ClientLog <= u10.MaxClientLogBytes then
                                            v1 = string.find(ClientLog, "\000", 1, true) == nil
                                        end
                                    end
                                end
                                if v1 then
                                    return (table.freeze({
                                        Version = u10.Version,
                                        Kind = a1.Kind,
                                        Generation = a1.Generation,
                                        ActorId = a1.ActorId,
                                        Sequence = a1.Sequence,
                                        CommandNumber = a1.CommandNumber,
                                        ServerTick = a1.ServerTick,
                                        ClientServerTime = a1.ClientServerTime,
                                        ClientLog = a1.ClientLog,
                                    }))
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    return nil
end

function u10.decodeDelivery(a1) -- Line: 160 -- upvalues: u10 (val)
    if typeof(a1) ~= "table" then
        return nil
    end
    if a1.Version == u10.Version and u10.isKind(a1.Kind) then
        if type(a1.CorrelationId) == "string" and #a1.CorrelationId ~= 0 then
            local v1 = #a1.CorrelationId
            if not (v1 > 160) and type(a1.ReporterName) == "string" and #a1.ReporterName ~= 0 then
                v1 = #a1.ReporterName
                if not (v1 > 20) and type(a1.ReporterDisplayName) == "string" and #a1.ReporterDisplayName ~= 0 then
                    v1 = #a1.ReporterDisplayName
                    if not (v1 > 50) then
                        local ReporterUserId = a1.ReporterUserId
                        v1 = false
                        if typeof(ReporterUserId) == "number" then
                            v1 = false
                            if ReporterUserId == ReporterUserId then
                                v1 = false
                                if ReporterUserId > (-1 / 0) then
                                    v1 = ReporterUserId < (1 / 0)
                                end
                            end
                        end
                        if v1 then
                            local ReceivedServerTime = a1.ReceivedServerTime
                            v1 = false
                            if typeof(ReceivedServerTime) == "number" then
                                v1 = false
                                if ReceivedServerTime == ReceivedServerTime then
                                    v1 = false
                                    if ReceivedServerTime > (-1 / 0) then
                                        v1 = ReceivedServerTime < (1 / 0)
                                    end
                                end
                            end
                            if v1 then
                                local ClientLog = a1.ClientLog
                                v1 = false
                                if typeof(ClientLog) == "string" then
                                    v1 = false
                                    if #ClientLog > 0 then
                                        v1 = false
                                        if #ClientLog <= u10.MaxClientLogBytes then
                                            v1 = string.find(ClientLog, "\000", 1, true) == nil
                                        end
                                    end
                                end
                                if v1 then
                                    local ServerLog = a1.ServerLog
                                    v1 = false
                                    if typeof(ServerLog) == "string" then
                                        v1 = false
                                        if #ServerLog > 0 then
                                            v1 = false
                                            if #ServerLog <= u10.MaxServerLogBytes then
                                                v1 = string.find(ServerLog, "\000", 1, true) == nil
                                            end
                                        end
                                    end
                                    if v1 then
                                        return (table.freeze({
                                            Version = u10.Version,
                                            CorrelationId = a1.CorrelationId,
                                            Kind = a1.Kind,
                                            ReporterName = a1.ReporterName,
                                            ReporterDisplayName = a1.ReporterDisplayName,
                                            ReporterUserId = a1.ReporterUserId,
                                            ReceivedServerTime = a1.ReceivedServerTime,
                                            ClientLog = a1.ClientLog,
                                            ServerLog = a1.ServerLog,
                                        }))
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    return nil
end

return table.freeze(u10)