-- ReplicatedStorage.Database.Security.Network
-- Script path: ReplicatedStorage.Database.Security.Network
-- Decompile time: 11.07 ms

local compileValidator, copyPacketValue
local v1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local BufferCodec = require(script.BufferCodec)
local u35 = RunService:IsServer()
local u36 = {}
local u37 = nil

local function logPacket(a1, a2, a3, a4) -- Line: 69
    -- upvalues: DebugFlags (val), HttpService (val), u35 (val)
    if not DebugFlags.IsEnabled("NetworkPackets") then
        return
    end
    local success, result = pcall(function() -- Line: 74 -- upvalues: HttpService (upval), a3 (val)
        return HttpService:JSONEncode(a3)
    end)
    local v1 = if not a4 then "" else (" | Player: %*"):format(a4.Name)
    local format = string.format
    local v2 = if not success then "{}" else result
    print(format(
        "%s %s %s | Size: %s%s | Data: %s",
        if not u35 then "[CLIENT]" else "[SERVER]",
        a1,
        a2,
        if not success then "unknown" else string.format("%.3f KB", #result / 1024),
        v1,
        v2
    ))
end

local function getPlayerPosition(a1) -- Line: 94 -- upvalues: u37 (ref) -- types: a1: userdata
    local v1 = assert(u37, "Network player position resolver has not been installed")(a1)
    if typeof(v1) == "Vector3" then
        return v1
    end
    return nil
end

local function getPlayersInRange(a1, a2) -- Line: 100
    -- upvalues: Players (val), u37 (ref)
    local v1, v2
    local v3 = {}
    for i, v in ipairs(Players:GetPlayers()) do
        v1 = assert(u37, "Network player position resolver has not been installed")(v)
        v2 = if typeof(v1) ~= "Vector3" then nil else v1
        if v2 and (v2 - v4).Magnitude <= v5 then
            table.insert(v3, v)
        end
    end
    return v3
end

local function getChildFolder(a1, a2) -- Line: 117 -- upvalues: u35 (val) -- types: a1: userdata, a2: string
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("Folder") then
        return v1
    end
    if not u35 then
        return (a1:WaitForChild(a2))
    end
    local Folder = Instance.new("Folder")
    Folder.Name = a2
    Folder.Parent = a1
    return Folder
end

local function getNamespaceFolder(a1) -- Line: 133 -- upvalues: ReplicatedStorage (val), u35 (val) -- types: a1: string
    local Folder, v1
    local v2 = ReplicatedStorage
    local NetworkRemotes = v2:FindFirstChild("NetworkRemotes")
    if not NetworkRemotes then
        if not u35 then
            v1 = v2:WaitForChild("NetworkRemotes")
        else
            Folder = Instance.new("Folder")
            Folder.Name = "NetworkRemotes"
            Folder.Parent = v2
            v1 = Folder
        end
    elseif NetworkRemotes:IsA("Folder") then
        v1 = NetworkRemotes
    elseif not u35 then
        v1 = v2:WaitForChild("NetworkRemotes")
    else
        Folder = Instance.new("Folder")
        Folder.Name = "NetworkRemotes"
        Folder.Parent = v2
        v1 = Folder
    end
    v2 = v1:FindFirstChild(a1)
    if v2 and v2:IsA("Folder") then
        return v2
    end
    if not u35 then
        return (v1:WaitForChild(a1))
    end
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = a1
    Folder_2.Parent = v1
    return Folder_2
end

local function expectedRemoteClassName(a1) -- Line: 137 -- types: a1: string?
    if a1 == "Unreliable" then
        return "UnreliableRemoteEvent"
    end
    return "RemoteEvent"
end

local function createRemoteForReliability(a1, a2) -- Line: 141 -- types: a1: string, a2: string?
    local v1 = Instance.new(if a2 ~= "Unreliable" then "RemoteEvent" else "UnreliableRemoteEvent")
    v1.Name = a1
    return v1
end

local function validateRemoteForReliability(a1, a2, a3, a4) -- Line: 149
    -- upvalues: 
    local v1 = if a4 ~= "Unreliable" then "RemoteEvent" else "UnreliableRemoteEvent"
    if a1.ClassName ~= v1 then
        error(("[Network] %*.%* requires %*, found %* at %*; refusing to bind a mismatched transport"):format(
            a2,
            a3,
            v1,
            a1.ClassName,
            (a1:GetFullName())
        ), 3)
    end
    return a1
end

local function getPacketRemote(a1, a2, a3) -- Line: 166
    -- upvalues: ReplicatedStorage (val), u35 (val)
    local Folder, Folder_2, v1, v2, v3
    local v4 = ReplicatedStorage
    local NetworkRemotes = v4:FindFirstChild("NetworkRemotes")
    if not NetworkRemotes then
        if not u35 then
            v2 = v4:WaitForChild("NetworkRemotes")
        else
            Folder = Instance.new("Folder")
            Folder.Name = "NetworkRemotes"
            Folder.Parent = v4
            v2 = Folder
        end
    elseif NetworkRemotes:IsA("Folder") then
        v2 = NetworkRemotes
    elseif not u35 then
        v2 = v4:WaitForChild("NetworkRemotes")
    else
        Folder = Instance.new("Folder")
        Folder.Name = "NetworkRemotes"
        Folder.Parent = v4
        v2 = Folder
    end
    v4 = v2:FindFirstChild(a1)
    if not v4 then
        if not u35 then
            v1 = v2:WaitForChild(a1)
        else
            Folder_2 = Instance.new("Folder")
            Folder_2.Name = a1
            Folder_2.Parent = v2
            v1 = Folder_2
        end
    elseif v4:IsA("Folder") then
        v1 = v4
    elseif not u35 then
        v1 = v2:WaitForChild(a1)
    else
        Folder_2 = Instance.new("Folder")
        Folder_2.Name = a1
        Folder_2.Parent = v2
        v1 = Folder_2
    end
    v2 = v1:FindFirstChild(a2)
    if v2 then
        local v5 = if a3 ~= "Unreliable" then "RemoteEvent" else "UnreliableRemoteEvent"
        if v2.ClassName ~= v5 then
            error(("[Network] %*.%* requires %*, found %* at %*; refusing to bind a mismatched transport"):format(
                a1,
                a2,
                v5,
                v2.ClassName,
                (v2:GetFullName())
            ), 3)
        end
        return v2
    end
    if not u35 then
        v4 = v1:WaitForChild(a2)
        v3 = if a3 ~= "Unreliable" then "RemoteEvent" else "UnreliableRemoteEvent"
        if v4.ClassName ~= v3 then
            error(("[Network] %*.%* requires %*, found %* at %*; refusing to bind a mismatched transport"):format(
                a1,
                a2,
                v3,
                v4.ClassName,
                (v4:GetFullName())
            ), 3)
        end
        return v4
    end
    v4 = Instance.new(if a3 ~= "Unreliable" then "RemoteEvent" else "UnreliableRemoteEvent")
    v4.Name = a2
    v4.Parent = v1
    v3 = if a3 ~= "Unreliable" then "RemoteEvent" else "UnreliableRemoteEvent"
    if v4.ClassName ~= v3 then
        error(("[Network] %*.%* requires %*, found %* at %*; refusing to bind a mismatched transport"):format(
            a1,
            a2,
            v3,
            v4.ClassName,
            (v4:GetFullName())
        ), 3)
    end
    return v4
end

local function sendImmediatePacketRejectionFeedback(a1, a2, a3, a4, a5, a6) -- Line: 187
    -- upvalues: u35 (val), getPacketRemote (val), logPacket (val), BufferCodec (val)
    if not u35 then
        return
    end
    if a1 == "Store" then
        if a2 == "OpenCase" or a2 == "OpenConsole" then
            local v1
            local v2 = getPacketRemote("Store", "CaseOpenDenied", nil)
            local v3 = {
                Reason = a5,
                RequestId = if typeof(a4) ~= "table" then nil else if typeof(a4.RequestId) ~= "string" then nil else a4.RequestId,
            }
            local v4 = a6 and math.max(0, (math.round(a6 * 1000))) or nil
            v3.RetryAfterMs = v4
            logPacket("OUTGOING", "Store.CaseOpenDenied", v3, a3)
            v4, v1 = BufferCodec.Encode(v3)
            v2:FireClient(a3, v4, v1)
        end
    end
end

local function canPassRateLimit(a1, a2, a3) -- Line: 215
    -- upvalues: u36 (val)
    local v1 = a3.maximum_requests_per_second or 10
    if v1 <= 0 then
        return true, nil
    end
    local v2 = os.clock()
    local v3 = u36[a1]
    if not v3 then
        u36[a1] = {}
    end
    local v4 = v3[a2]
    local v5 = math.max(1, v1)
    if not v4 then
        v3[a2] = {tokens = v5, lastRefill = v2}
    end
    local v6 = v2 - v4.lastRefill
    if v6 > 0 then
        v4.tokens = math.min(v5, v4.tokens + v6 * v1)
        v4.lastRefill = v2
    end
    if v4.tokens < 1 then
        return false, (1 - v4.tokens) / v1
    end
    v4.tokens = v4.tokens - 1
    return true, nil
end

local function canPassMiddleware(a1, a2, a3) -- Line: 256 -- types: a1: table, a3: userdata
    local middleware = a1.middleware
    if middleware and not middleware(a2, a3) then
        return false
    end
    return true
end

local function isFiniteNumber(a1) -- Line: 265
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 ~= (1 / 0) then
                v1 = a1 ~= (-1 / 0)
            end
        end
    end
    return v1
end

local function isInteger(a1) -- Line: 272
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 ~= (1 / 0) then
                v1 = a1 ~= (-1 / 0)
            end
        end
    end
    if v1 then
        v1 = a1 == math.floor(a1)
    end
    return v1
end

local function u52(a1) -- Line: 276
    return true
end

local u53 = {
    String = "string",
    Bool = "boolean",
    Instance = "Instance",
    CFrame = "CFrame",
    Vec3 = "Vector3",
    Vec2 = "Vector2",
}
local u54 = {
    Uint8 = {0, 255},
    Uint16 = {0, 65535},
    Uint32 = {0, 4294967295},
    Int8 = {-128, 127},
    Int16 = {-32768, 32767},
    Int32 = {-2147483648, 2147483647},
}

function compileValidator(a1) -- Line: 300
    -- upvalues: u52 (val), u53 (val), isFiniteNumber (val), u54 (val), compileValidator (val)
    if type(a1) == "table" and a1._kind ~= nil and a1._kind ~= "Unknown" then
        local _kind = a1._kind
        if _kind == "Nothing" then
            return function(a1) -- Line: 307
                return a1 == nil
            end
        end
        local u9 = u53[_kind]
        if u9 then
            return function(a1) -- Line: 314 -- upvalues: u9 (val)
                return (typeof(a1)) == u9
            end
        end
        if _kind ~= "Float32" and _kind ~= "Float64" then
            local v1
            local v2 = u54[_kind]
            if v2 then
                local u13 = v2[1]
                local u14 = v2[2]
                return function(a1) -- Line: 326 -- upvalues: u13 (val), u14 (val)
                    local v1 = false
                    if typeof(a1) == "number" then
                        v1 = false
                        if a1 == a1 then
                            v1 = false
                            if a1 ~= (1 / 0) then
                                v1 = a1 ~= (-1 / 0)
                            end
                        end
                    end
                    if v1 then
                        v1 = a1 == math.floor(a1)
                    end
                    if v1 then
                        v1 = false
                        if u13 <= a1 then
                            v1 = a1 <= u14
                        end
                    end
                    return v1
                end
            end
            if _kind == "Optional" then
                local u18 = compileValidator(a1.value)
                return function(a1) -- Line: 333 -- upvalues: u18 (val)
                    if a1 == nil then
                        return true
                    end
                    return u18(a1)
                end
            end
            if _kind == "Array" then
                local u22 = compileValidator(a1.value)
                return function(a1) -- Line: 343 -- upvalues: u22 (val)
                    if typeof(a1) ~= "table" then
                        return false
                    end
                    local v1 = #a1
                    for k, v in pairs(a1) do
                        if typeof(k) == "number" and not (k < 1) and not (v1 < k) and k % 1 == 0 then
                            if u22(v) then
                                continue
                            end
                            return false
                        end
                        return false
                    end
                    for i = 1, v1 do
                        if a1[i] == nil then
                            return false
                        end
                    end
                    return true
                end
            end
            if _kind == "Map" then
                local u26 = compileValidator(a1.key)
                local u29 = compileValidator(a1.value)
                return function(a1) -- Line: 371 -- upvalues: u26 (val), u29 (val)
                    if typeof(a1) ~= "table" then
                        return false
                    end
                    for k, v in pairs(a1) do
                        if u26(k) and u29(v) then
                            continue
                        end
                        return false
                    end
                    return true
                end
            end
            if _kind ~= "Struct" then
                return u52
            end
            local value = a1.value
            if typeof(value) ~= "table" then
                return function(a1) -- Line: 389
                    return typeof(a1) == "table"
                end
            end
            local u70 = {}
            local u68 = {}
            for k, v in pairs(value) do
                if typeof(k) == "string" then
                    u70[k] = (compileValidator(v))
                    v1 = false
                    if type(v) == "table" then
                        v1 = v._kind == "Optional"
                    end
                    u68[k] = not v1
                end
            end
            return function(a1) -- Line: 403 -- upvalues: u70 (val), u68 (val)
                local v1
                if typeof(a1) ~= "table" then
                    return false
                end
                local v2 = a1
                for k, v in pairs(u70) do
                    v1 = v2[k]
                    if v1 ~= nil then
                        if not v(v1) then
                            return false
                        end
                    elseif u68[k] then
                        return false
                    end
                end
                for k2, i in pairs(v2) do
                    if typeof(k2) == "string" and u70[k2] ~= nil then
                        continue
                    end
                    return false
                end
                return true
            end
        end
        return isFiniteNumber
    end
    return u52
end

function v1.DefinePacket(a1) -- Line: 435
    return a1
end

function v1.DefineNamespace(a1, a2) -- Line: 439 -- types: a1: string, a2: function
    return a2()
end

function v1.SetPlayerPositionResolver(a1) -- Line: 443 -- upvalues: u35 (val), u37 (ref) -- types: a1: function?
    if not u35 then
        return
    end
    u37 = a1
end

function copyPacketValue(a1) -- Line: 452 -- upvalues: copyPacketValue (val)
    local v1
    if typeof(a1) == "table" then
        local v2
        v1 = {}
        for i, j in a1 do
            v2 = copyPacketValue(i)
            v1[v2] = (copyPacketValue(j))
        end
        return v1
    end
    if typeof(a1) ~= "buffer" then
        return a1
    end
    v1 = buffer.create(buffer.len(a1))
    buffer.copy(v1, 0, a1)
    return v1
end

function v1.CreatePacket(a1, a2, a3, a4) -- Line: 467
    -- upvalues: compileValidator (val), getPacketRemote (val), BufferCodec (val), u35 (val), logPacket (val)
    -- upvalues: Players (val), getPlayersInRange (val), copyPacketValue (val), canPassRateLimit (val)
    -- upvalues: sendImmediatePacketRejectionFeedback (val), Profiler (val)
    local u5 = a4
    if not u5 then
        u5 = {}
    end
    local name = if not u5.name then ("%*.%*"):format(a1, a2) else if u5.name == "" then ("%*.%*"):format(a1, a2) else u5.name
    local u25 = ("Network.Receive.%*"):format(name)
    local u34 = compileValidator(a3 and a3.Value)
    local u44 = getPacketRemote(a1, a2, a3.ReliabilityType)
    local u45 = {}

    local function encodeAfterValidation(a1) -- Line: 485 -- upvalues: u34 (val), BufferCodec (upval)
        if not u34(a1) then
            return nil, nil
        end
        return BufferCodec.Encode(a1)
    end

    function u45.Send(a1) -- Line: 493
        -- upvalues: u35 (upval), u34 (val), BufferCodec (upval), logPacket (upval), name (val), Players (upval)
        -- upvalues: u44 (val)
        local v1, v2
        if u35 then
            return
        end
        if u34(a1) then
            local v3, v4 = BufferCodec.Encode(a1)
            v1 = v3
            v2 = v4
        else
            v1 = nil
            v2 = nil
        end
        if not v1 then
            return
        end
        logPacket("OUTGOING", name, a1, Players.LocalPlayer)
        u44:FireServer(v1, v2)
    end

    function u45.SendTo(a1, a2) -- Line: 507
        -- upvalues: u35 (upval), u34 (val), BufferCodec (upval), logPacket (upval), name (val), u44 (val)
        local v1, v2
        if not u35 or not a2 then
            return
        end
        if u34(a1) then
            local v3, v4 = BufferCodec.Encode(a1)
            v1 = v3
            v2 = v4
        else
            v1 = nil
            v2 = nil
        end
        if not v1 then
            return
        end
        logPacket("OUTGOING", name, a1, a2)
        u44:FireClient(a2, v1, v2)
    end

    function u45.SendToAll(a1) -- Line: 525
        -- upvalues: u35 (upval), u34 (val), BufferCodec (upval), logPacket (upval), name (val), u44 (val)
        local v1, v2
        if not u35 then
            return
        end
        if u34(a1) then
            local v3, v4 = BufferCodec.Encode(a1)
            v1 = v3
            v2 = v4
        else
            v1 = nil
            v2 = nil
        end
        if not v1 then
            return
        end
        logPacket("OUTGOING", name, a1, nil)
        u44:FireAllClients(v1, v2)
    end

    function u45.SendToAllExcept(a1, a2) -- Line: 539
        -- upvalues: u35 (upval), u34 (val), BufferCodec (upval), Players (upval), u44 (val), logPacket (upval)
        -- upvalues: name (val)
        local v1, v2
        if not u35 then
            return
        end
        if u34(a1) then
            local v3, v4 = BufferCodec.Encode(a1)
            v1 = v3
            v2 = v4
        else
            v1 = nil
            v2 = nil
        end
        if not v1 then
            return
        end
        for i, v in ipairs(Players:GetPlayers()) do
            if v ~= a2 then
                u44:FireClient(v, v1, v2)
            end
        end
        logPacket("OUTGOING", name, a1, nil)
    end

    function u45.SendToList(a1, a2) -- Line: 558
        -- upvalues: u35 (upval), u34 (val), BufferCodec (upval), u44 (val), logPacket (upval), name (val)
        if not u35 then
            return
        end
        if a2 and #a2 ~= 0 then
            local v1, v2
            if u34(a1) then
                local v3, v4 = BufferCodec.Encode(a1)
                v1 = v3
                v2 = v4
            else
                v1 = nil
                v2 = nil
            end
            if not v1 then
                return
            end
            for i, v in ipairs(a2) do
                if v then
                    u44:FireClient(v, v1, v2)
                end
            end
            logPacket("OUTGOING", name, a1, nil)
            return
        end
    end

    function u45.SendToProximity(a1, a2) -- Line: 581
        -- upvalues: u35 (upval), u34 (val), BufferCodec (upval), getPlayersInRange (upval), u44 (val)
        -- upvalues: logPacket (upval), name (val)
        local v1, v2, v3
        if not u35 then
            return
        end
        if u34(a1) then
            local v4
            v4, v3 = BufferCodec.Encode(a1)
            v1 = v4
            v2 = v3
        else
            v1 = nil
            v2 = nil
        end
        if not v1 then
            return
        end
        local position = a2.position
        v3 = a2.range or 60
        local v5 = getPlayersInRange(position, v3)
        for i, v in ipairs(v5) do
            u44:FireClient(v, v1, v2)
        end
        if #v5 > 0 then
            logPacket("OUTGOING", name, a1, nil)
        end
    end

    local u54 = {}
    local u55 = nil

    local function dispatch(a1, a2, a3, a4) -- Line: 606
        -- upvalues: copyPacketValue (upval)
        if a4 == nil then
            if a3 and a3.connected then
                task.spawn(a3.callback, a1, a2)
            end
            return
        end
        for i, j in a4 do
            if j.connected then
                task.spawn(j.callback, copyPacketValue(a1), a2)
            end
        end
    end

    local function receive(a1_2, a2_2, a3) -- Line: 619
        -- upvalues: u54 (val), BufferCodec (upval), u35 (upval), canPassRateLimit (upval), name (val), u5 (val)
        -- upvalues: sendImmediatePacketRejectionFeedback (upval), a1 (val), a2 (val), u34 (val), logPacket (upval)
        -- upvalues: dispatch (val)
        local v1 = u54[1]
        local v2 = if not (#u54 > 1) then nil else table.clone(u54)
        local v3, v4 = BufferCodec.Decode(a2_2, a3)
        if not v3 then
            return
        end
        if u35 then
            local v5, v6 = canPassRateLimit(a1_2, name, u5)
            if not v5 then
                sendImmediatePacketRejectionFeedback(a1, a2, a1_2, v4, "RateLimited", v6)
                return
            end
        end
        if not u34(v4) then
            return
        end
        if u35 then
            local middleware = u5.middleware
            if not (if not middleware then true else if middleware(v4, a1_2) then true else false) then
                return
            end
        end
        logPacket("INCOMING", name, v4, a1_2)
        dispatch(v4, a1_2, v1, v2)
    end

    function u45.Listen(a1) -- Line: 644
        -- upvalues: u54 (val), u55 (ref), u35 (upval), u44 (val), Profiler (upval), u25 (val), receive (val)
        local u1 = {connected = true, callback = a1}
        table.insert(u54, u1)
        if u55 == nil then
            u55 = if not u35 then u44.OnClientEvent:Connect(function(a1, a2) -- Line: 653 -- upvalues: Profiler (upval), u25 (upval), receive (upval)
                Profiler.scope(u25, receive, nil, a1, a2)
            end) else u44.OnServerEvent:Connect(function(a1, a2, a3) -- Line: 649 -- upvalues: Profiler (upval), u25 (upval), receive (upval) -- types: a1: userdata
                Profiler.scope(u25, receive, a1, a2, a3)
            end)
        end
        return function() -- Line: 658 -- upvalues: u1 (val), u54 (upval), u55 (upval)
            if not u1.connected then
                return
            end
            u1.connected = false
            table.remove(u54, (table.find(u54, u1)))
            if #u54 == 0 and u55 ~= nil then
                u55:Disconnect()
                u55 = nil
            end
        end
    end

    function u45.Connect(a1) -- Line: 671 -- upvalues: u45 (val) -- types: a1: function
        return u45.Listen(a1)
    end

    function u45.Wait() -- Line: 675 -- upvalues: u35 (upval), u44 (val), BufferCodec (upval)
        local v1, v2, v3, v4
        if u35 then
            local v5
            v1, v2, v3 = u44.OnServerEvent:Wait()
            v4, v5 = BufferCodec.Decode(v2, v3)
            return if not v4 then nil else v5, v1
        end
        v1, v2 = u44.OnClientEvent:Wait()
        v3, v4 = BufferCodec.Decode(v1, v2)
        return if not v3 then nil else v4, nil
    end

    return u45
end

v1.Nothing = table.freeze({_kind = "Nothing"})
v1.Unknown = table.freeze({_kind = "Unknown"})
v1.String = table.freeze({_kind = "String"})
v1.Bool = table.freeze({_kind = "Bool"})
v1.Instance = table.freeze({_kind = "Instance"})
v1.CFrame = table.freeze({_kind = "CFrame"})
v1.Vec3 = table.freeze({_kind = "Vec3"})
v1.Vec2 = table.freeze({_kind = "Vec2"})
v1.Float32 = table.freeze({_kind = "Float32"})
v1.Float64 = table.freeze({_kind = "Float64"})
v1.Uint8 = table.freeze({_kind = "Uint8"})
v1.Uint16 = table.freeze({_kind = "Uint16"})
v1.Uint32 = table.freeze({_kind = "Uint32"})
v1.Int8 = table.freeze({_kind = "Int8"})
v1.Int16 = table.freeze({_kind = "Int16"})
v1.Int32 = table.freeze({_kind = "Int32"})

function v1.Array(a1) -- Line: 708
    return {_kind = "Array", value = a1}
end

function v1.Map(a1, a2) -- Line: 712
    return {_kind = "Map", key = a1, value = a2}
end

function v1.Struct(a1) -- Line: 716
    return {_kind = "Struct", value = a1}
end

function v1.Optional(a1) -- Line: 720
    return {_kind = "Optional", value = a1}
end

if u35 then
    Players.PlayerRemoving:Connect(function(a1) -- Line: 725 -- upvalues: u36 (val)
        u36[a1] = nil
    end)
end
return v1