-- Network (ModuleScript)
-- full path: ReplicatedStorage.Database.Security.Network

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local script_BufferCodec = require(script.BufferCodec);
local u2 = RunService:IsServer();
local u3 = {};
local u4 = nil;

local function logPacket(p5: string, p6: string, u7: any, p8: userdata?) -- Line: 70
    -- upvalues: DebugFlags (copy), HttpService (copy), u2 (copy)
    if not DebugFlags.IsEnabled("NetworkPackets") then
        return;
    end;

    local success, result = pcall(function() -- Line: 75
        -- upvalues: HttpService (ref), u7 (copy)
        return HttpService:JSONEncode(u7);
    end);
    local v9 = not success and "unknown" or string.format("%.3f KB", #result / 1024);
    local v10 = not p8 and "" or ` | Player: {p8.Name}`;
    print(string.format("%s %s %s | Size: %s%s | Data: %s", u2 and "[SERVER]" or "[CLIENT]", p5, p6, v9, v10, not success and "{}" or result));
end;

local function getPlayerPosition(p11: userdata) -- Line: 95
    -- upvalues: u4 (ref)
    local v12 = assert(u4, "Network player position resolver has not been installed")(p11);

    if typeof(v12) == "Vector3" then
        return v12;
    end;

    return nil;
end;

local function getPlayersInRange(p13: vector, p14: number) -- Line: 101
    -- upvalues: Players (copy), u4 (ref)
    local v15 = {};

    for _, v in ipairs(Players:GetPlayers()) do
        local v16 = assert(u4, "Network player position resolver has not been installed")(v);

        if typeof(v16) ~= "Vector3" then
            v16 = nil;
        end;

        if v16 and (v16 - p13).Magnitude <= p14 then
            table.insert(v15, v);
        end;
    end;

    return v15;
end;

local function getChildFolder(p17: userdata, p18: string) -- Line: 118
    -- upvalues: u2 (copy)
    local v19 = p17:FindFirstChild(p18);

    if v19 and v19:IsA("Folder") then
        return v19;
    end;

    if not u2 then
        return p17:WaitForChild(p18);
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = p18;
    Folder.Parent = p17;

    return Folder;
end;

local function getNamespaceFolder(p20: string) -- Line: 134
    -- upvalues: ReplicatedStorage (copy), u2 (copy)
    local v21 = ReplicatedStorage;
    local NetworkRemotes = v21:FindFirstChild("NetworkRemotes");

    if not (NetworkRemotes and NetworkRemotes:IsA("Folder")) then
        if u2 then
            NetworkRemotes = Instance.new("Folder");
            NetworkRemotes.Name = "NetworkRemotes";
            NetworkRemotes.Parent = v21;
        else
            NetworkRemotes = v21:WaitForChild("NetworkRemotes");
        end;
    end;

    local v22 = NetworkRemotes:FindFirstChild(p20);

    if v22 and v22:IsA("Folder") then
        return v22;
    end;

    if not u2 then
        return NetworkRemotes:WaitForChild(p20);
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = p20;
    Folder.Parent = NetworkRemotes;

    return Folder;
end;

local function expectedRemoteClassName(p23: string?) -- Line: 138
    return p23 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent";
end;

local function createRemoteForReliability(p24: string, p25: string?) -- Line: 142
    local Instance_new_ret = Instance.new(p25 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent");
    Instance_new_ret.Name = p24;

    return Instance_new_ret;
end;

local function validateRemoteForReliability(p26: userdata, p27: string, p28: string, p29: string?) -- Line: 150
    local v30 = p29 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent";

    if p26.ClassName ~= v30 then
        error(`[Network] {p27}.{p28} requires {v30}, found {p26.ClassName} at {p26:GetFullName()}; refusing to bind a mismatched transport`, 3);
    end;

    return p26;
end;

local function getPacketRemote(p31: string, p32: string, p33: string?) -- Line: 167
    -- upvalues: ReplicatedStorage (copy), u2 (copy)
    local v34 = ReplicatedStorage;
    local NetworkRemotes = v34:FindFirstChild("NetworkRemotes");

    if not (NetworkRemotes and NetworkRemotes:IsA("Folder")) then
        if u2 then
            NetworkRemotes = Instance.new("Folder");
            NetworkRemotes.Name = "NetworkRemotes";
            NetworkRemotes.Parent = v34;
        else
            NetworkRemotes = v34:WaitForChild("NetworkRemotes");
        end;
    end;

    local v35 = NetworkRemotes:FindFirstChild(p31);

    if not (v35 and v35:IsA("Folder")) then
        if u2 then
            v35 = Instance.new("Folder");
            v35.Name = p31;
            v35.Parent = NetworkRemotes;
        else
            v35 = NetworkRemotes:WaitForChild(p31);
        end;
    end;

    local v36 = v35:FindFirstChild(p32);

    if v36 then
        local v37 = p33 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent";

        if v36.ClassName ~= v37 then
            error(`[Network] {p31}.{p32} requires {v37}, found {v36.ClassName} at {v36:GetFullName()}; refusing to bind a mismatched transport`, 3);
        end;

        return v36;
    end;

    if not u2 then
        local v38 = v35:WaitForChild(p32);
        local v39 = p33 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent";

        if v38.ClassName ~= v39 then
            error(`[Network] {p31}.{p32} requires {v39}, found {v38.ClassName} at {v38:GetFullName()}; refusing to bind a mismatched transport`, 3);
        end;

        return v38;
    end;

    local Instance_new_ret = Instance.new(p33 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent");
    Instance_new_ret.Name = p32;
    Instance_new_ret.Parent = v35;
    local v40 = p33 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent";

    if Instance_new_ret.ClassName ~= v40 then
        error(`[Network] {p31}.{p32} requires {v40}, found {Instance_new_ret.ClassName} at {Instance_new_ret:GetFullName()}; refusing to bind a mismatched transport`, 3);
    end;

    return Instance_new_ret;
end;

local function sendImmediatePacketRejectionFeedback(p41: string, p42: string, p43: userdata, p44: any, p45: string, p46: number?) -- Line: 188
    -- upvalues: u2 (copy), getPacketRemote (copy), logPacket (copy), script_BufferCodec (copy)
    if not u2 then
        return;
    end;

    if p41 == "Store" and (p42 == "OpenCase" or p42 == "OpenConsole") then
        local v47 = getPacketRemote("Store", "CaseOpenDenied", nil);
        local v48;

        if typeof(p44) == "table" and typeof(p44.RequestId) == "string" then
            v48 = p44.RequestId;
        else
            v48 = nil;
        end;

        local v49 = {
            Reason = p45,
            RequestId = v48
        };
        local v50;

        if p46 then
            local math_round_ret = math.round(p46 * 1000);
            v50 = math.max(0, math_round_ret) or nil;
        else
            v50 = nil;
        end;

        v49.RetryAfterMs = v50;
        logPacket("OUTGOING", "Store.CaseOpenDenied", v49, p43);
        local v51, v52 = script_BufferCodec.Encode(v49);
        v47:FireClient(p43, v51, v52);
    end;
end;

local function canPassRateLimit(p53: userdata, p54: string, p55: table) -- Line: 216
    -- upvalues: u3 (copy)
    local v56 = p55.maximum_requests_per_second or 10;

    if v56 <= 0 then
        return true, nil;
    end;

    local os_clock_ret = os.clock();
    local v57 = u3[p53];

    if not v57 then
        v57 = {};
        u3[p53] = v57;
    end;

    local v58 = v57[p54];
    local math_max_ret = math.max(1, v56);

    if not v58 then
        v58 = {
            tokens = math_max_ret,
            lastRefill = os_clock_ret
        };
        v57[p54] = v58;
    end;

    local v59 = os_clock_ret - v58.lastRefill;

    if v59 > 0 then
        v58.tokens = math.min(math_max_ret, v58.tokens + v59 * v56);
        v58.lastRefill = os_clock_ret;
    end;

    if v58.tokens < 1 then
        return false, (1 - v58.tokens) / v56;
    end;

    v58.tokens = v58.tokens - 1;

    return true, nil;
end;

local function canPassMiddleware(p60: table, p61: any, p62: userdata) -- Line: 257
    local middleware = p60.middleware;

    return (not middleware or middleware(p61, p62)) and true or false;
end;

local function isFiniteNumber(p63) -- Line: 266
    local v64;

    if typeof(p63) == "number" and (p63 == p63 and p63 ~= (1 / 0)) then
        v64 = p63 ~= (-1 / 0);
    else
        v64 = false;
    end;

    return v64;
end;

local function isInteger(p65) -- Line: 273
    local v66;

    if typeof(p65) == "number" and (p65 == p65 and p65 ~= (1 / 0)) then
        v66 = p65 ~= (-1 / 0);
    else
        v66 = false;
    end;

    if v66 then
        v66 = p65 == math.floor(p65);
    end;

    return v66;
end;

local function u68(p67) -- Line: 277
    return true;
end;

local u69 = {
    String = "string",
    Bool = "boolean",
    Instance = "Instance",
    CFrame = "CFrame",
    Vec3 = "Vector3",
    Vec2 = "Vector2"
};
local u70 = {
    Uint8 = { 0, 255 },
    Uint16 = { 0, 65535 },
    Uint32 = { 0, 4294967295 },
    Int8 = { -128, 127 },
    Int16 = { -32768, 32767 },
    Int32 = { -2147483648, 2147483647 }
};

local function compileValidator(p71) -- Line: 301
    -- upvalues: u68 (copy), u69 (copy), isFiniteNumber (copy), u70 (copy), compileValidator (copy)
    if type(p71) ~= "table" or (p71._kind == nil or p71._kind == "Unknown") then
        return u68;
    end;

    local _kind = p71._kind;

    if _kind == "Nothing" then
        return function(p72) -- Line: 308
            return p72 == nil;
        end;
    end;

    local u73 = u69[_kind];

    if u73 then
        return function(p74) -- Line: 315
            -- upvalues: u73 (copy)
            return typeof(p74) == u73;
        end;
    end;

    if _kind == "Float32" or _kind == "Float64" then
        return isFiniteNumber;
    end;

    local v75 = u70[_kind];

    if v75 then
        local u76 = v75[1];
        local u77 = v75[2];

        return function(p78) -- Line: 327
            -- upvalues: u76 (copy), u77 (copy)
            local v79;

            if typeof(p78) == "number" and (p78 == p78 and p78 ~= (1 / 0)) then
                v79 = p78 ~= (-1 / 0);
            else
                v79 = false;
            end;

            if v79 then
                v79 = p78 == math.floor(p78);
            end;

            if v79 then
                if u76 <= p78 then
                    v79 = p78 <= u77;
                else
                    v79 = false;
                end;
            end;

            return v79;
        end;
    end;

    if _kind == "Optional" then
        local u80 = compileValidator(p71.value);

        return function(p81) -- Line: 334
            -- upvalues: u80 (copy)
            return p81 == nil and true or u80(p81);
        end;
    end;

    if _kind == "Array" then
        local u82 = compileValidator(p71.value);

        return function(p83) -- Line: 344
            -- upvalues: u82 (copy)
            if typeof(p83) ~= "table" then
                return false;
            end;

            local v84 = #p83;

            for i, v in pairs(p83) do
                if typeof(i) ~= "number" or (i < 1 or (v84 < i or i % 1 ~= 0)) then
                    return false;
                end;

                if not u82(v) then
                    return false;
                end;
            end;

            for i = 1, v84 do
                if p83[i] == nil then
                    return false;
                end;

                local _ = i;
            end;

            return true;
        end;
    end;

    if _kind == "Map" then
        local u85 = compileValidator(p71.key);
        local u86 = compileValidator(p71.value);

        return function(p87) -- Line: 372
            -- upvalues: u85 (copy), u86 (copy)
            if typeof(p87) ~= "table" then
                return false;
            end;

            for i, v in pairs(p87) do
                if not (u85(i) and u86(v)) then
                    return false;
                end;
            end;

            return true;
        end;
    end;

    if _kind ~= "Struct" then
        return u68;
    end;

    local value = p71.value;

    if typeof(value) ~= "table" then
        return function(p88) -- Line: 390
            return typeof(p88) == "table";
        end;
    end;

    local u89 = {};
    local u90 = {};

    for i, v in pairs(value) do
        if typeof(i) == "string" then
            u89[i] = compileValidator(v);
            local v91;

            if type(v) == "table" then
                v91 = v._kind == "Optional";
            else
                v91 = false;
            end;

            u90[i] = not v91;
        end;
    end;

    return function(p92) -- Line: 404
        -- upvalues: u89 (copy), u90 (copy)
        if typeof(p92) ~= "table" then
            return false;
        end;

        for i, v in pairs(u89) do
            local v93 = p92[i];

            if v93 == nil then
                if u90[i] then
                    return false;
                end;
            elseif not v(v93) then
                return false;
            end;
        end;

        for i, _ in pairs(p92) do
            if typeof(i) ~= "string" or u89[i] == nil then
                return false;
            end;
        end;

        return true;
    end;
end;

function v1.DefinePacket(p94) -- Line: 436
    return p94;
end;

function v1.DefineNamespace(p95: string, p96: function) -- Line: 440
    return p96();
end;

function v1.SetPlayerPositionResolver(p97: function?) -- Line: 444
    -- upvalues: u2 (copy), u4 (ref)
    if not u2 then
        return;
    end;

    u4 = p97;
end;

local function copyPacketValue(p98) -- Line: 453
    -- upvalues: copyPacketValue (copy)
    if typeof(p98) == "table" then
        local v99 = {};

        for i, v in p98 do
            v99[copyPacketValue(i)] = copyPacketValue(v);
        end;

        return v99;
    end;

    if typeof(p98) ~= "buffer" then
        return p98;
    end;

    local buffer_create_ret = buffer.create(buffer.len(p98));
    buffer.copy(buffer_create_ret, 0, p98);

    return buffer_create_ret;
end;

function v1.CreatePacket(u100: string, u101: string, p102: any, p103: table?) -- Line: 468
    -- upvalues: compileValidator (copy), getPacketRemote (copy), script_BufferCodec (copy), u2 (copy), logPacket (copy), Players (copy), getPlayersInRange (copy), copyPacketValue (copy), canPassRateLimit (copy), sendImmediatePacketRejectionFeedback (copy), Profiler (copy)
    local u104 = p103 or {};
    local u105;

    if u104.name and u104.name ~= "" then
        u105 = u104.name;
    else
        u105 = `{u100}.{u101}`;
    end;

    local u106 = `Network.Receive.{u105}`;
    local v107;

    if p102 then
        v107 = p102.Value;
    else
        v107 = p102;
    end;

    local u108 = compileValidator(v107);
    local u109 = getPacketRemote(u100, u101, p102.ReliabilityType);
    local u110 = {};
    local u111 = (-1 / 0);

    local function warnInvalidPayload(p112) -- Line: 489
        -- upvalues: u111 (ref), u105 (copy)
        local os_clock_ret = os.clock();

        if os_clock_ret - u111 < 5 then
            return;
        end;

        u111 = os_clock_ret;
        local v113 = {};

        if typeof(p112) == "table" then
            for i, v in p112 do
                local v114 = `{tostring(i)}={typeof(v)}`;
                table.insert(v113, v114);
            end;

            table.sort(v113);
        else
            local v115 = typeof(p112);
            table.insert(v113, v115);
        end;

        warn((`[Network] dropped {u105}: payload does not match its schema ({table.concat(v113, ", ")})`));
    end;

    local function encodeAfterValidation(p116) -- Line: 507
        -- upvalues: u108 (copy), warnInvalidPayload (copy), script_BufferCodec (ref)
        if u108(p116) then
            return script_BufferCodec.Encode(p116);
        end;

        warnInvalidPayload(p116);

        return nil, nil;
    end;

    function u110.Send(p117) -- Line: 516
        -- upvalues: u2 (ref), u108 (copy), warnInvalidPayload (copy), script_BufferCodec (ref), logPacket (ref), u105 (copy), Players (ref), u109 (copy)
        if u2 then
            return;
        end;

        local v118, v119;

        if u108(p117) then
            v118, v119 = script_BufferCodec.Encode(p117);
        else
            warnInvalidPayload(p117);
            v118 = nil;
            v119 = nil;
        end;

        if not v118 then
            return;
        end;

        logPacket("OUTGOING", u105, p117, Players.LocalPlayer);
        u109:FireServer(v118, v119);
    end;

    function u110.SendTo(p120: any, p121: userdata) -- Line: 530
        -- upvalues: u2 (ref), u108 (copy), warnInvalidPayload (copy), script_BufferCodec (ref), logPacket (ref), u105 (copy), u109 (copy)
        if not u2 then
            return;
        end;

        if not p121 then
            return;
        end;

        local v122, v123;

        if u108(p120) then
            v122, v123 = script_BufferCodec.Encode(p120);
        else
            warnInvalidPayload(p120);
            v122 = nil;
            v123 = nil;
        end;

        if not v122 then
            return;
        end;

        logPacket("OUTGOING", u105, p120, p121);
        u109:FireClient(p121, v122, v123);
    end;

    function u110.SendToAll(p124) -- Line: 548
        -- upvalues: u2 (ref), u108 (copy), warnInvalidPayload (copy), script_BufferCodec (ref), logPacket (ref), u105 (copy), u109 (copy)
        if not u2 then
            return;
        end;

        local v125, v126;

        if u108(p124) then
            v125, v126 = script_BufferCodec.Encode(p124);
        else
            warnInvalidPayload(p124);
            v125 = nil;
            v126 = nil;
        end;

        if not v125 then
            return;
        end;

        logPacket("OUTGOING", u105, p124, nil);
        u109:FireAllClients(v125, v126);
    end;

    function u110.SendToAllExcept(p127: any, p128: userdata) -- Line: 562
        -- upvalues: u2 (ref), u108 (copy), warnInvalidPayload (copy), script_BufferCodec (ref), Players (ref), u109 (copy), logPacket (ref), u105 (copy)
        if not u2 then
            return;
        end;

        local v129, v130;

        if u108(p127) then
            v129, v130 = script_BufferCodec.Encode(p127);
        else
            warnInvalidPayload(p127);
            v129 = nil;
            v130 = nil;
        end;

        if not v129 then
            return;
        end;

        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= p128 then
                u109:FireClient(v, v129, v130);
            end;
        end;

        logPacket("OUTGOING", u105, p127, nil);
    end;

    function u110.SendToList(p131: any, p132: table) -- Line: 581
        -- upvalues: u2 (ref), u108 (copy), warnInvalidPayload (copy), script_BufferCodec (ref), u109 (copy), logPacket (ref), u105 (copy)
        if not u2 then
            return;
        end;

        if not p132 or #p132 == 0 then
            return;
        end;

        local v133, v134;

        if u108(p131) then
            v133, v134 = script_BufferCodec.Encode(p131);
        else
            warnInvalidPayload(p131);
            v133 = nil;
            v134 = nil;
        end;

        if not v133 then
            return;
        end;

        for _, v in ipairs(p132) do
            if v then
                u109:FireClient(v, v133, v134);
            end;
        end;

        logPacket("OUTGOING", u105, p131, nil);
    end;

    function u110.SendToProximity(p135: any, p136: table) -- Line: 604
        -- upvalues: u2 (ref), u108 (copy), warnInvalidPayload (copy), script_BufferCodec (ref), getPlayersInRange (ref), u109 (copy), logPacket (ref), u105 (copy)
        if not u2 then
            return;
        end;

        local v137, v138;

        if u108(p135) then
            v137, v138 = script_BufferCodec.Encode(p135);
        else
            warnInvalidPayload(p135);
            v137 = nil;
            v138 = nil;
        end;

        if not v137 then
            return;
        end;

        local v139 = getPlayersInRange(p136.position, p136.range or 60);

        for _, v in ipairs(v139) do
            u109:FireClient(v, v137, v138);
        end;

        if #v139 > 0 then
            logPacket("OUTGOING", u105, p135, nil);
        end;
    end;

    local u140 = {};
    local u141 = nil;

    local function dispatch(p142: any, p143: userdata?, p144: any, p145: table?) -- Line: 629
        -- upvalues: copyPacketValue (ref)
        if p145 == nil then
            if p144 and p144.connected then
                task.spawn(p144.callback, p142, p143);
            end;

            return;
        end;

        for _, v in p145 do
            if v.connected then
                task.spawn(v.callback, copyPacketValue(p142), p143);
            end;
        end;
    end;

    local function receive(p146: userdata?, p147: any, p148: any) -- Line: 642
        -- upvalues: u140 (copy), script_BufferCodec (ref), u2 (ref), canPassRateLimit (ref), u105 (copy), u104 (copy), sendImmediatePacketRejectionFeedback (ref), u100 (copy), u101 (copy), u108 (copy), logPacket (ref), dispatch (copy)
        local v149 = u140[1];
        local v150;

        if #u140 > 1 then
            v150 = table.clone(u140);
        else
            v150 = nil;
        end;

        local v151, v152 = script_BufferCodec.Decode(p147, p148);

        if not v151 then
            return;
        end;

        if u2 then
            local v153, v154 = canPassRateLimit(p146, u105, u104);

            if not v153 then
                sendImmediatePacketRejectionFeedback(u100, u101, p146, v152, "RateLimited", v154);

                return;
            end;
        end;

        if not u108(v152) then
            return;
        end;

        if u2 then
            local middleware = u104.middleware;

            if middleware and not middleware(v152, p146) then
                return;
            end;
        end;

        logPacket("INCOMING", u105, v152, p146);
        dispatch(v152, p146, v149, v150);
    end;

    function u110.Listen(p155: function) -- Line: 667
        -- upvalues: u140 (copy), u141 (ref), u2 (ref), u109 (copy), Profiler (ref), u106 (copy), receive (copy)
        local u156 = {
            connected = true,
            callback = p155
        };
        table.insert(u140, u156);

        if u141 == nil then
            if u2 then
                u141 = u109.OnServerEvent:Connect(function(p157: userdata, p158: any, p159: any) -- Line: 672
                    -- upvalues: Profiler (ref), u106 (ref), receive (ref)
                    Profiler.scope(u106, receive, p157, p158, p159);
                end);
            else
                u141 = u109.OnClientEvent:Connect(function(p160, p161) -- Line: 676
                    -- upvalues: Profiler (ref), u106 (ref), receive (ref)
                    Profiler.scope(u106, receive, nil, p160, p161);
                end);
            end;
        end;

        return function() -- Line: 681
            -- upvalues: u156 (copy), u140 (ref), u141 (ref)
            if not u156.connected then
                return;
            end;

            u156.connected = false;
            table.remove(u140, (table.find(u140, u156)));

            if #u140 == 0 and u141 ~= nil then
                u141:Disconnect();
                u141 = nil;
            end;
        end;
    end;

    function u110.Connect(p162: function) -- Line: 694
        -- upvalues: u110 (copy)
        return u110.Listen(p162);
    end;

    function u110.Wait() -- Line: 698
        -- upvalues: u2 (ref), u109 (copy), script_BufferCodec (ref)
        if u2 then
            local v163, v164, v165 = u109.OnServerEvent:Wait();
            local v166, v167 = script_BufferCodec.Decode(v164, v165);

            if not v166 then
                v167 = nil;
            end;

            return v167, v163;
        end;

        local v168, v169 = u109.OnClientEvent:Wait();
        local v170, v171 = script_BufferCodec.Decode(v168, v169);

        if not v170 then
            v171 = nil;
        end;

        return v171, nil;
    end;

    return u110;
end;

v1.Nothing = table.freeze({
    _kind = "Nothing"
});
v1.Unknown = table.freeze({
    _kind = "Unknown"
});
v1.String = table.freeze({
    _kind = "String"
});
v1.Bool = table.freeze({
    _kind = "Bool"
});
v1.Instance = table.freeze({
    _kind = "Instance"
});
v1.CFrame = table.freeze({
    _kind = "CFrame"
});
v1.Vec3 = table.freeze({
    _kind = "Vec3"
});
v1.Vec2 = table.freeze({
    _kind = "Vec2"
});
v1.Float32 = table.freeze({
    _kind = "Float32"
});
v1.Float64 = table.freeze({
    _kind = "Float64"
});
v1.Uint8 = table.freeze({
    _kind = "Uint8"
});
v1.Uint16 = table.freeze({
    _kind = "Uint16"
});
v1.Uint32 = table.freeze({
    _kind = "Uint32"
});
v1.Int8 = table.freeze({
    _kind = "Int8"
});
v1.Int16 = table.freeze({
    _kind = "Int16"
});
v1.Int32 = table.freeze({
    _kind = "Int32"
});

function v1.Array(p172) -- Line: 731
    return {
        _kind = "Array",
        value = p172
    };
end;

function v1.Map(p173, p174) -- Line: 735
    return {
        _kind = "Map",
        key = p173,
        value = p174
    };
end;

function v1.Struct(p175) -- Line: 739
    return {
        _kind = "Struct",
        value = p175
    };
end;

function v1.Optional(p176) -- Line: 743
    return {
        _kind = "Optional",
        value = p176
    };
end;

if u2 then
    Players.PlayerRemoving:Connect(function(p177) -- Line: 748
        -- upvalues: u3 (copy)
        u3[p177] = nil;
    end);
end;

return v1;