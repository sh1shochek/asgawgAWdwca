-- ReplicatedStorage.GameClient.Tattletale
-- Script path: ReplicatedStorage.GameClient.Tattletale
-- Decompile time: 41.31 ms

-- Decompiled with Potassium's decompiler.

local v1 = {
    string,
    table,
    math,
    bit32,
    buffer,
    coroutine,
    utf8,
    os,
    debug,
    task,
    CFrame,
    Vector3,
    Vector2,
    Instance,
    Ray,
    Color3,
    UDim2
};
local u2 = {
    { game, "GetService" },
    { game, "FindFirstChild" },
    { game, "WaitForChild" },
    { game, "IsA" },
    { game, "GetChildren" },
    { workspace, "Raycast" },
    { workspace, "GetPartBoundsInBox" }
};
local debug_info = debug.info;
local u3 = rawequal;
local u4 = rawget;
local u5 = pcall;
local u6 = type;
local u7 = next;
local u8 = error;
local u9 = tostring;
local u10 = getfenv;
local u11 = setmetatable;
local u12 = getmetatable;
local u13 = gcinfo;
local u14 = collectgarbage;
local u15 = bit32;
local u16 = table;
local u17 = buffer;
local u18 = string;
local u19 = math;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TemplateOverrides = require(ReplicatedStorage.Shared.TemplateOverrides);
local TattleSeal = require(ReplicatedStorage.Shared.TattleSeal);
local u20 = xpcall;
local u21 = select;
local u22 = {};
local v23 = { "pcall", "xpcall", "rawequal", "rawget", "rawset", "type", "typeof", "getmetatable", "setmetatable", "require", "tostring", "tonumber", "select", "next", "pairs", "ipairs", "error", "getfenv", "setfenv", "gcinfo", "collectgarbage", "newproxy", "loadstring", "unpack", "print", "warn", "tick", "time", "wait", "spawn", "delay" };
local u24 = {};
local u25 = {};
local u26 = { function() -- Line: 358
        return game:____();
    end, function() -- Line: 359
        return game.____;
    end, function() -- Line: 360
        game.____ = nil;
    end };

local function MetamethodOf(p27) -- Line: 367
    -- upvalues: u21 (copy), u20 (copy), debug_info (copy)
    return u21(2, u20(p27, function() -- Line: 368
        -- upvalues: debug_info (ref)
        return debug_info(2, "f");
    end));
end;

local u28 = {};
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = { "__index", "__newindex", "__call", "__add", "__sub", "__mul", "__div", "__unm", "__len", "__eq", "__lt", "__le" };
local u34 = { "__index", "__newindex", "__call", "__concat", "__unm", "__add", "__sub", "__mul", "__div", "__idiv", "__mod", "__pow", "__tostring", "__eq", "__lt", "__le", "__len", "__iter" };
local u35 = {
    WalkSpeed = 16,
    JumpPower = 50,
    IsAdmin = false,
    GodMode = false
};
local u36 = nil;
local u37 = nil;
local u38 = nil;
local v39 = {};
local u40 = {
    dex = true,
    darkdex = true,
    infiniteyield = true,
    simplespy = true,
    remotespy = true,
    turtlespy = true,
    hydroxide = true,
    saveinstance = true,
    rayfield = true,
    orion = true,
    cmdx = true,
    fatesadmin = true,
    reviz = true,
    owlhub = true,
    octospy = true,
    synapsex = true
};
local u41 = {
    Highlight = true,
    BillboardGui = true,
    SelectionBox = true,
    SelectionSphere = true,
    BoxHandleAdornment = true,
    SphereHandleAdornment = true,
    CylinderHandleAdornment = true,
    ConeHandleAdornment = true,
    LineHandleAdornment = true,
    ImageHandleAdornment = true
};
local u42 = {
    GetInaccuracy = true,
    Recoil = true,
    ProcessPacket = true,
    ProcessCommand = true,
    ApplyFov = true,
    Process = true,
    Play = true,
    FlushPacket = true,
    CategorizePosition = true,
    BuildCommand = true,
    ProjectVelocity = true,
    DoGroundCheck = true,
    DoStepUp = true,
    DoStepDown = true,
    UpdatePlayerHulls = true
};
local u43 = { "VirtualUser", "VirtualInputManager" };
local u44 = {
    WeaponConstructor = { "GetSpread", "GetInaccuracy", "Recoil", "UpdateAccuracyPenalty", "CalculateNextAttackTime", "ProcessCommand" },
    Camera = { "KickBack", "UpdatePunchAngles", "DecayAimPunchAngle", "DecayViewPunchAngle", "BuildShotCFrame" },
    Movement = { "ClampVelocity", "WalkMove", "AirMove", "CheckJumpButton", "FinishGravity", "Duck", "StartGravity", "CheckFalling", "FullNoClipMove", "LadderMove" },
    CharacterReconciliation = { "HandleNewState" },
    TattleSeal = { "Seed", "Seal" },
    CharacterNetworking = { "ProcessPacket", "FlushPacket" },
    Simulation = { "ProcessCommand", "CategorizePosition" },
    CameraController = { "ApplyFov" },
    WeaponEffects = { "Process" },
    SoundManager = { "Play" },
    CharacterInput = { "BuildCommand" },
    Collision = { "ProjectVelocity", "DoGroundCheck", "DoStepUp", "DoStepDown", "CheckStuck", "UpdatePlayerHulls" },
    Interaction = { "PressE" }
};
local u45 = { { "GameClient" }, { "ClientModules" }, { "Shared" } };
local u46 = {
    GUI = true,
    CSGO_NetGraph = true,
    Lori = true,
    NameTags = true,
    TouchGui = true,
    ProximityPrompts = true,
    Freecam = true,
    Chat = true,
    BubbleChat = true
};
local u47 = {
    "hookfunction",
    "hookmetamethod",
    "getrawmetatable",
    "getnamecallmethod",
    "newcclosure",
    "checkcaller",
    "getgenv",
    "getrenv",
    "getgc",
    "setreadonly",
    "isreadonly",
    "islclosure",
    "iscclosure",
    "clonefunction",
    "restorefunction",
    "replaceclosure",
    "getconstants",
    "getthreads",
    "getreg",
    "getinstances",
    "getnilinstances",
    "getscripts",
    "getrunningscripts",
    "getloadedmodules",
    "filtergc",
    "saveinstance",
    "readfile",
    "writefile",
    "loadfile",
    "listfiles",
    "makefolder",
    "delfile",
    "cloneref",
    "setrawmetatable",
    "makewriteable",
    "getidentity",
    "setidentity",
    "identifyexecutor",
    "getexecutorname",
    "getconnections",
    "firetouchinterest",
    "gethui",
    "getsenv",
    "getcallingscript",
    "getscriptclosure",
    "getscripthash",
    "getcustomasset",
    "getcallbackvalue",
    "gethiddenproperty",
    "sethiddenproperty",
    "setsimulationradius",
    "firesignal",
    "fireclickdetector",
    "fireproximityprompt",
    "setclipboard",
    "request",
    "http_request",
    "syn",
    "fluxus",
    "Drawing",
    "crypt",
    "WebSocket",
    "mousemoverel",
    "mouse1click",
    "iswindowactive",
    "isrbxactive",
    "setfpscap",
    "queue_on_teleport",
    "getupvalues",
    "setupvalue",
    "getprotos",
    "getstack",
    "setstack",
    "run_on_actor",
    "getactors",
    "getactorstates",
    "getluastate",
    "getgamestate",
    "get_current_actor",
    "create_comm_channel",
    "get_comm_channel",
    "on_actor_state_created",
    "isparallel",
    "getfunctionhash",
    "hookproto",
    "isexecutorclosure",
    "isfunctionhooked",
    "isnewcclosure",
    "isprotohooked",
    "newlclosure",
    "restoreproto",
    "setstackhidden",
    "trampoline_call",
    "decompile",
    "getscriptbytecode",
    "getfunctionbytecode",
    "getscriptthread",
    "getscriptfromthread",
    "getmodules",
    "isexecutorthread",
    "dumpstring",
    "getallthreads",
    "gettenv",
    "iswritable",
    "makereadonly",
    "makewritable",
    "setnamecallmethod",
    "gethiddenproperties",
    "getproperties",
    "getthreadidentity",
    "isnetworkowner",
    "isscriptable",
    "setscriptable",
    "setthreadidentity"
};

for _, v in v1 do
    if u6(v) == "table" and u16.isfrozen(v) then
        local v48 = {};
        local v49 = 0;

        for i, v2 in u7, v do
            v48[i] = v2;
            v49 = v49 + 1;
        end;

        u16.insert(u22, {
            Library = v,
            Fields = v48,
            Count = v49
        });
    end;
end;

local v50 = u10(0);

for _, v in v23 do
    u24[v] = v50[v];
end;

for i, v in u2 do
    u25[i] = v[1][v[2]];
end;

for i, v in u26 do
    u28[i] = MetamethodOf(v);
end;

local u51 = debug_info(1, "s");
local u52 = false;
local u53 = u11({}, {
    __mode = "k"
});
local u54 = 0;
local u55 = 0;
local u56 = {};
local u57 = 0;
local u58 = (ReplicatedStorage:GetAttribute("ClientBuild") or 0) + 1;
ReplicatedStorage:SetAttribute("ClientBuild", u58);
local u59 = {};
local u60 = nil;
local u61 = nil;
local u62 = nil;
u5(function() -- Line: 432
    -- upvalues: u61 (ref), u62 (ref)
    local RemoteEvent = Instance.new("RemoteEvent");
    u61 = RemoteEvent.FireServer;
    RemoteEvent:Destroy();
    u62 = game:GetService("Players").LocalPlayer.Kick;
end);

local function Trap(u63) -- Line: 444
    -- upvalues: u34 (copy), u54 (ref), u15 (copy), u7 (copy), u11 (copy)
    local v64 = {
        __metatable = "The metatable is locked"
    };

    for _, v in u34 do
        v64[v] = function() -- Line: 448
            -- upvalues: u54 (ref), u63 (copy), u15 (ref)
            u54 = u15.bor(u54, u63);
        end;
    end;

    function v64.__iter() -- Line: 455
        -- upvalues: u54 (ref), u63 (copy), u15 (ref), u7 (ref)
        u54 = u15.bor(u54, u63);

        return u7, {};
    end;

    function v64.__tostring() -- Line: 460
        -- upvalues: u54 (ref), u63 (copy), u15 (ref)
        u54 = u15.bor(u54, u63);

        return "table";
    end;

    return u11({}, v64);
end;

local u65 = Trap(32);
local u66 = Trap(1024);
local RemoteEvent = Instance.new("RemoteEvent");
local u67 = {};
u67[1] = u67;
local u68 = {
    function() -- Line: 485
        -- upvalues: u66 (copy)
        return workspace:Raycast(Vector3.zero, u66);
    end,

    function() -- Line: 486
        -- upvalues: u66 (copy)
        return workspace:Spherecast(u66, 1, u66);
    end,

    function() -- Line: 487
        -- upvalues: u66 (copy)
        return workspace:Blockcast(u66, u66, u66);
    end,

    function() -- Line: 488
        -- upvalues: u66 (copy)
        return workspace:FindPartOnRay(u66);
    end,

    function() -- Line: 489
        -- upvalues: u66 (copy)
        return workspace:FireServer(u66);
    end,

    function() -- Line: 490
        -- upvalues: u66 (copy)
        return workspace:Kick(u66);
    end
};
local u69 = nil;
local u70 = nil;
local u71 = u11({}, {
    __mode = "v"
});
local u72 = 0;
local u73 = 0;
local u74 = nil;
local u75 = nil;
local u76 = nil;
local u77 = 0;
local u78 = 0;
local u79 = 0;
local u80 = 0.016666666666666666;
local u81 = false;

local function ProbeDepth(u82) -- Line: 520
    -- upvalues: u8 (copy), u33 (copy), u11 (copy), u5 (copy)
    local u83 = 0;
    local u84 = {};

    local function Recurse() -- Line: 524
        -- upvalues: u83 (ref), u8 (ref), u82 (copy), u84 (copy)
        u83 = u83 + 1;

        if u83 > 2000 then
            u8("probe cap");
        end;

        u82(u84, u84, u84);
    end;

    local v85 = {};

    for _, v in u33 do
        v85[v] = Recurse;
    end;

    u11(u84, v85);
    u5(u82, u84, u84, u84);

    return u83;
end;

local function CheckHooks() -- Line: 548
    -- upvalues: u52 (ref), debug_info (copy), u3 (copy), u54 (ref), u15 (copy), u56 (copy), u6 (copy), u61 (ref), u5 (copy), u62 (ref)
    u52 = true;

    if not u3(debug.info, debug_info) then
        u54 = u15.bor(u54, 1);
    end;

    for _, v in u56 do
        local v86 = v.Module[v.Name];

        if u6(v86) == "function" and u3(v86, v.Function) then
            if debug_info(v86, "s") ~= v.Source or debug_info(v86, "a") ~= v.Arity then
                u54 = u15.bor(u54, 1);
            end;
        else
            u54 = u15.bor(u54, 1);
        end;
    end;

    if u61 and u5(u61, workspace) or u62 and u5(u62, workspace, "") then
        u54 = u15.bor(u54, 1);
    end;
end;

local function SnapshotCatalog(p87) -- Line: 574
    -- upvalues: u6 (copy), u17 (copy), u16 (copy), u7 (copy)
    local u88 = {};
    local u89 = {};
    local u90 = {};

    local function Walk(p91) -- Line: 577
        -- upvalues: u6 (ref), u90 (copy), u89 (copy), u17 (ref), u16 (ref), u88 (copy), u7 (ref), Walk (copy)
        local v92 = u6(p91);

        if u90[p91] or v92 ~= "table" and v92 ~= "buffer" then
            return;
        end;

        u90[p91] = true;

        if v92 == "buffer" then
            u89[p91] = u17.tostring(p91);

            return;
        end;

        if u16.isfrozen(p91) then
            u16.insert(u88, p91);
        end;

        for i, v in u7, p91 do
            Walk(i);
            Walk(v);
        end;
    end;

    Walk(p87);

    return u88, u89;
end;

local function CheckCatalog() -- Line: 621
    -- upvalues: u52 (ref), u69 (ref), u70 (ref), SnapshotCatalog (copy), u29 (ref), u16 (copy), u54 (ref), u15 (copy), u17 (copy), u74 (ref), u6 (copy), u53 (copy), u7 (copy), u4 (copy)
    u52 = true;

    if not u69 then
        local v93, v94 = SnapshotCatalog(u29 and u29.GetAllWeapons() or {});
        u69 = v93;
        u70 = v94;

        return;
    end;

    for _, v in u69 do
        if not u16.isfrozen(v) then
            u54 = u15.bor(u54, 1);
            break;
        end;
    end;

    for i, v in u70 do
        if u17.tostring(i) ~= v then
            u54 = u15.bor(u54, 1);
            break;
        end;
    end;

    local v95 = u74 and u29 and u29.Get(u74.Name);

    if v95 then
        v95 = v95.Data;
    end;

    local v96 = u74 and u74.Data;

    if not (v95 and (u6(v96) == "table" and not u53[u74])) then
        return;
    end;

    for i, v in u7, v95 do
        local v97 = u6(v);

        if (v97 == "table" or v97 == "buffer") and u6((u4(v96, i))) ~= v97 then
            u54 = u15.bor(u54, 1);

            return;
        end;
    end;
end;

local function CheckGui(p98: userdata) -- Line: 662
    -- upvalues: u40 (copy), u18 (copy), u54 (ref), u15 (copy), u46 (copy)
    if not p98:IsA("ScreenGui") then
        return;
    end;

    if u40[u18.gsub(u18.lower(p98.Name), "[^%w]", "")] then
        u54 = u15.bor(u54, 64);

        return;
    end;

    if not u46[p98.Name] then
        u54 = u15.bor(u54, 2048);
    end;
end;

local function CheckEsp(p99: any, p100: userdata) -- Line: 681
    -- upvalues: u41 (copy), u54 (ref), u15 (copy)
    if not u41[p100.ClassName] then
        return;
    end;

    if not (p99.Model and p100:IsDescendantOf(p99.Model)) then
        return;
    end;

    local Attribute = game:GetService("Players").LocalPlayer:GetAttribute("Team");
    local v101 = p99.Data and p99.Data.Team;

    if not (Attribute and (Attribute ~= "Spectator" and (v101 and v101 ~= Attribute))) then
        return;
    end;

    if p100:IsA("Highlight") and p100.DepthMode ~= Enum.HighlightDepthMode.AlwaysOnTop then
        return;
    end;

    if p100:IsA("BillboardGui") and not p100.AlwaysOnTop then
        return;
    end;

    u54 = u15.bor(u54, 4096);
end;

local u102 = {
    Highlight = "DepthMode",
    BillboardGui = "AlwaysOnTop"
};

local function WatchMarker(u103: any, u104: userdata) -- Line: 717
    -- upvalues: CheckEsp (copy), u102 (copy)
    CheckEsp(u103, u104);
    local v105 = u102[u104.ClassName];

    if v105 then
        u104:GetPropertyChangedSignal(v105):Connect(function() -- Line: 723
            -- upvalues: CheckEsp (ref), u103 (copy), u104 (copy)
            CheckEsp(u103, u104);
        end);
    end;
end;

local function WatchCharacter(u106) -- Line: 729
    -- upvalues: WatchMarker (copy)
    local Model = u106.Model;

    if not Model then
        return;
    end;

    for _, descendant in Model:GetDescendants() do
        WatchMarker(u106, descendant);
    end;

    Model.DescendantAdded:Connect(function(p107) -- Line: 740
        -- upvalues: WatchMarker (ref), u106 (copy)
        task.defer(WatchMarker, u106, p107);
    end);
end;

local function CheckEnvironment() -- Line: 745
    -- upvalues: u52 (ref), u10 (copy), u47 (copy), u4 (copy), u54 (ref), u15 (copy), CheckGui (copy)
    u52 = true;
    local v108 = u10(0);

    for _, v in u47 do
        if u4(_G, v) ~= nil or u4(v108, v) ~= nil then
            u54 = u15.bor(u54, 64);
            break;
        end;
    end;

    local v109 = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v109 then
        return;
    end;

    for _, child in v109:GetChildren() do
        CheckGui(child);
    end;
end;

local function IsNative(p110) -- Line: 771
    -- upvalues: u6 (copy), debug_info (copy)
    return u6(p110) ~= "function" and true or debug_info(p110, "s") == "[C]";
end;

local function CheckLibraries() -- Line: 775
    -- upvalues: u52 (ref), u22 (copy), u16 (copy), u54 (ref), u15 (copy), u7 (copy), u3 (copy), IsNative (copy), u10 (copy), u24 (copy), u2 (copy), u25 (copy), u26 (copy), MetamethodOf (copy), u28 (copy)
    u52 = true;

    for _, v in u22 do
        local Library = v.Library;
        local Fields = v.Fields;
        local v111 = 0;

        if not u16.isfrozen(Library) then
            u54 = u15.bor(u54, 256);

            return;
        end;

        for i, v2 in u7, Library do
            local v112 = Fields[i];
            v111 = v111 + 1;

            if not ((u3(v112, v2) or v112 ~= v112 and v2 ~= v2) and IsNative(v2)) then
                u54 = u15.bor(u54, 256);

                return;
            end;
        end;

        if v111 ~= v.Count then
            u54 = u15.bor(u54, 256);

            return;
        end;
    end;

    local v113 = u10(0);

    for i, v in u24 do
        local v114 = v113[i];

        if not (u3(v114, v) and IsNative(v114)) then
            u54 = u15.bor(u54, 256);

            return;
        end;
    end;

    for i, v in u2 do
        if not u3(v[1][v[2]], u25[i]) then
            u54 = u15.bor(u54, 256);

            return;
        end;
    end;

    for i, v in u26 do
        local v115 = MetamethodOf(v);

        if not (u3(v115, u28[i]) and IsNative(v115)) then
            u54 = u15.bor(u54, 256);

            return;
        end;
    end;
end;

local function CheckBait() -- Line: 834
    -- upvalues: u52 (ref), u68 (copy), u5 (copy), u54 (ref), u15 (copy), RemoteEvent (copy), u66 (copy), u67 (copy)
    u52 = true;

    for _, v in u68 do
        if u5(v) then
            u54 = u15.bor(u54, 1024);
        end;
    end;

    u5(function() -- Line: 843
        -- upvalues: RemoteEvent (ref), u66 (ref), u67 (ref)
        RemoteEvent:FireServer(u66, u67);
    end);
end;

local u116 = nil;
local u117 = nil;
local u118 = nil;
local u119 = nil;
local u120 = {};

local function CheckInstances() -- Line: 852
    -- upvalues: u52 (ref), u119 (ref), u54 (ref), u15 (copy), u35 (copy), u116 (ref), ReplicatedStorage (copy), u118 (ref), u117 (ref), u120 (copy)
    u52 = true;

    if u119 and u119:GetAttribute("Loaded") then
        u54 = u15.bor(u54, 512);
    end;

    local LocalPlayer = game:GetService("Players").LocalPlayer;

    for i, v in u35 do
        if LocalPlayer:GetAttribute(i) ~= v then
            u54 = u15.bor(u54, 512);
            break;
        end;
    end;

    if u116 and (u116.Parent ~= ReplicatedStorage or u116.Name ~= "ClientIntegrity") then
        u54 = u15.bor(u54, 512);
    end;

    if u118 or u117 and u117.Parent == nil then
        u54 = u15.bor(u54, 512);
    end;

    for _, v in u120 do
        if v.Parent == nil then
            u54 = u15.bor(u54, 512);

            return;
        end;
    end;
end;

local function MetamethodsBehave() -- Line: 885
    -- upvalues: u34 (copy), u7 (copy), u11 (copy), u5 (copy), u9 (copy)
    local u121 = {};
    local v122 = {};

    for _, v in u34 do
        v122[v] = function() -- Line: 890
            -- upvalues: u121 (copy), v (copy)
            u121[v] = (u121[v] or 0) + 1;

            return 1;
        end;
    end;

    function v122.__tostring() -- Line: 896
        -- upvalues: u121 (copy)
        u121.__tostring = (u121.__tostring or 0) + 1;

        return "canary";
    end;

    function v122.__iter() -- Line: 901
        -- upvalues: u121 (copy), u7 (ref)
        u121.__iter = (u121.__iter or 0) + 1;

        return u7, {};
    end;

    local u123 = u11({}, v122);
    local u124 = u11({}, v122);

    if not u5(function() -- Line: 909
        -- upvalues: u123 (copy), u124 (copy), u9 (ref)
        local _ = u123.Missing;
        u123.Written = true;
        u123();
        local _ = u123 .. "x";
        local _ = -u123;
        local _ = u123 + u124;
        local _ = u123 - u124;
        local _ = u123 * u124;
        local _ = u123 / u124;
        local _ = u123 // u124;
        local _ = u123 % u124;
        local _ = u123 ^ u124;
        u9(u123);
        local _ = u123 == u124;
        local _ = u123 < u124;
        local _ = u123 <= u124;
        local _ = #u123;

        for _ in u123 do

        end;
    end) then
        return false;
    end;

    for _, v in u34 do
        if u121[v] ~= 1 then
            return false;
        end;
    end;

    return true;
end;

local function CheckCanaries() -- Line: 945
    -- upvalues: u52 (ref), u65 (copy), u12 (copy), MetamethodsBehave (copy), u54 (ref), u15 (copy), u13 (copy), u14 (copy), u6 (copy), u19 (copy), u72 (ref), u73 (ref), u71 (copy)
    u52 = true;

    if u12(u65) ~= "The metatable is locked" or not MetamethodsBehave() then
        u54 = u15.bor(u54, 128);
    end;

    local v125 = u13();
    local v126 = u14("count");
    u72 = ((u6(v125) ~= "number" or u6(v126) ~= "number") and true or u19.abs(v125 - v126) > 64) and u72 + 1 or 0;
    u73 = u71.Service == nil and u73 + 1 or 0;
    u71.Service = game:GetService("UserInputService");

    if u72 >= 2 or u73 >= 2 then
        u54 = u15.bor(u54, 128);
    end;
end;

local function ProbeNext() -- Line: 969
    -- upvalues: u52 (ref), u57 (ref), u56 (copy), u42 (copy), u3 (copy), ProbeDepth (copy), u54 (ref), u15 (copy)
    u52 = true;
    u57 = u57 % #u56 + 1;
    local v127 = u56[u57];

    if not (v127 and (not u42[v127.Name] and u3(v127.Module[v127.Name], v127.Function))) then
        return;
    end;

    local v128 = ProbeDepth(v127.Function);

    if v127.Depth then
        if v127.Depth >= 2 and v128 ~= v127.Depth then
            u54 = u15.bor(u54, 16);
        end;

        return;
    end;

    v127.Depth = v128;
end;

local function OnWeaponShoot(p129) -- Line: 991
    -- upvalues: u55 (ref), u74 (ref), u75 (ref), u76 (ref), u77 (ref), u78 (ref), u79 (ref), u81 (ref), u54 (ref), u15 (copy), u19 (copy), u80 (ref)
    u55 = (u55 + 1) % 65536;
    local Data = p129.Data;
    local Timer = p129.Timer;
    local v130 = Data.FireRate and Data.FireRate[p129.Mode];

    if p129 ~= u74 or not (v130 and (u75 and Timer >= u75)) then
        u74 = p129;
        u75 = Timer;
        u76 = Data.Ammo;
        u77 = 1;
        u78 = 0;
        u79 = 0;
        u81 = false;

        return;
    end;

    if u76 < Data.Ammo and not u81 then
        u54 = u15.bor(u54, 8);
    end;

    local AltFunction = Data.AltFunction;

    if AltFunction then
        if AltFunction.Name == "Burst" then
            AltFunction = p129.Mode == 2;
        else
            AltFunction = false;
        end;
    end;

    u77 = not AltFunction and Timer <= (p129.FireDelay or -u19.huge) + u80 + 0.0001 and u77 + 1 or 1;
    u78 = u77 >= 5 and (p129.RecoilIndex < 2 and u78 + 1) or 0;

    if u78 >= 3 then
        u54 = u15.bor(u54, 2);
    end;

    u79 = (AltFunction or Timer - u75 >= v130 * 0.8) and 0 or (u79 + 1 or 0);

    if u79 >= 3 then
        u54 = u15.bor(u54, 4);
    end;

    u75 = Timer;
    u76 = Data.Ammo;
    u81 = false;
end;

local function OnRefill() -- Line: 1044
    -- upvalues: u81 (ref)
    u81 = true;
end;

local u131 = {
    OnWeaponShoot,
    OnRefill,
    ProbeDepth,
    SnapshotCatalog,
    MetamethodsBehave,
    IsNative,
    MetamethodOf
};

local function CheckSelf() -- Line: 1051
    -- upvalues: u52 (ref), ReplicatedStorage (copy), u58 (copy), u54 (ref), u15 (copy), u131 (copy), debug_info (copy), u51 (copy)
    u52 = true;

    if ReplicatedStorage:GetAttribute("ClientBuild") ~= u58 then
        u54 = u15.bor(u54, 1);
    end;

    for _, v in u131 do
        if debug_info(v, "s") ~= u51 then
            u54 = u15.bor(u54, 1);

            return;
        end;
    end;
end;

local function RefreshConfig() -- Line: 1067
    -- upvalues: u80 (ref), u30 (ref)
    u80 = u30.Get("Weapon", "RecoilDecayThreshold") / u30.Get("Game", "TickRate");
end;

local function ForgetWeapon(p132) -- Line: 1071
    -- upvalues: u53 (copy), u74 (ref), u75 (ref), u76 (ref)
    if p132 then
        u53[p132] = true;
    end;

    u74 = nil;
    u75 = nil;
    u76 = nil;
end;

local function OnWeaponCreate(p133) -- Line: 1079
    -- upvalues: TemplateOverrides (copy), u53 (copy)
    if p133 and TemplateOverrides.GetWeapons()[p133.Name] then
        u53[p133] = true;
    end;
end;

local function CheckWorld() -- Line: 1086
    -- upvalues: u52 (ref), u54 (ref), u15 (copy), u43 (copy), u59 (copy), u31 (ref), u32 (ref), u19 (copy)
    u52 = true;

    if workspace.Gravity ~= 0 then
        u54 = u15.bor(u54, 16384);
    end;

    for _, v in u43 do
        if not u59[v] and game:FindService(v) then
            u54 = u15.bor(u54, 16384);
            break;
        end;
    end;

    local Max = u31.GetData().Game.Gameplay["Field Of View"].Slider.Max;
    local v134 = u32.IsLockedToScene() and Max and Max or u32.StretchFov(Max);
    local FieldOfView = workspace.CurrentCamera.FieldOfView;

    if v134 + 5 < FieldOfView then
        local v135 = FieldOfView - u32.GetFieldOfView();

        if u19.abs(v135) > 0.01 then
            u54 = u15.bor(u54, 8192);
        end;
    end;
end;

local u136 = u16.freeze({
    CheckWorld,
    CheckSelf,
    CheckHooks,
    CheckCatalog,
    ProbeNext,
    CheckCanaries,
    CheckLibraries,
    CheckInstances,
    CheckBait
});
local u137 = u16.freeze({
    CheckWorld,
    CheckSelf,
    CheckHooks,
    CheckCatalog,
    ProbeNext,
    CheckCanaries,
    CheckLibraries,
    CheckInstances,
    CheckBait,
    CheckEnvironment
});
local u138 = u16.freeze(u16.clone(u136));
local u139 = u16.freeze(u16.clone(u137));

local function KnownAnswerA() -- Line: 1125
    return 1;
end;

local function KnownAnswerB() -- Line: 1126
    return 2;
end;

local u145 = u16.freeze({
    World = function() -- Line: 1143, Name: World
        -- upvalues: u5 (copy), CheckWorld (copy)
        local workspace_Gravity = workspace.Gravity;
        workspace.Gravity = 1;
        u5(CheckWorld);
        workspace.Gravity = workspace_Gravity;
    end,

    Environment = function() -- Line: 1150, Name: Environment
        -- upvalues: u47 (copy), u19 (copy), u4 (copy), u5 (copy), CheckEnvironment (copy)
        local v140 = u47[u19.random(#u47)];
        local v141 = u4(_G, v140);
        rawset(_G, v140, true);
        u5(CheckEnvironment);
        rawset(_G, v140, v141);
    end,

    Gui = function() -- Line: 1158, Name: Gui
        -- upvalues: u5 (copy), CheckGui (copy)
        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "Dex";
        u5(CheckGui, ScreenGui);
        ScreenGui:Destroy();
    end,

    Instances = function() -- Line: 1165, Name: Instances
        -- upvalues: u116 (ref), u5 (copy), CheckInstances (copy)
        local Name = u116.Name;
        u116.Name = Name .. "_";
        u5(CheckInstances);
        u116.Name = Name;
    end,

    Self = function() -- Line: 1172, Name: Self
        -- upvalues: ReplicatedStorage (copy), u58 (copy), u5 (copy), CheckSelf (copy)
        local Attribute = ReplicatedStorage:GetAttribute("ClientBuild");
        ReplicatedStorage:SetAttribute("ClientBuild", u58 + 1);
        u5(CheckSelf);
        ReplicatedStorage:SetAttribute("ClientBuild", Attribute);
    end,

    Hooks = function() -- Line: 1179, Name: Hooks
        -- upvalues: KnownAnswerB (copy), KnownAnswerA (copy), u51 (copy), u56 (copy), u16 (copy), u5 (copy), CheckHooks (copy)
        local v142 = {
            Name = "Probe",
            Arity = 0,
            Module = {
                Probe = KnownAnswerB
            },
            Function = KnownAnswerA,
            Source = u51
        };
        u16.insert(u56, v142);
        u5(CheckHooks);
        u16.remove(u56, u16.find(u56, v142));
    end,

    Libraries = function() -- Line: 1186, Name: Libraries
        -- upvalues: u25 (copy), KnownAnswerA (copy), u5 (copy), CheckLibraries (copy)
        local v143 = u25[1];
        u25[1] = KnownAnswerA;
        u5(CheckLibraries);
        u25[1] = v143;
    end,

    Canaries = function() -- Line: 1193, Name: Canaries
        -- upvalues: u73 (ref), u72 (ref), u71 (copy), u5 (copy), CheckCanaries (copy)
        local v144 = u73;
        u73 = 2;
        u71.Service = nil;
        u5(CheckCanaries);
        u73 = v144;
        u72 = u72;
    end
});
local u146 = 0;

function v39.Init(p147) -- Line: 1208
    -- upvalues: u36 (ref), u37 (ref), u29 (ref), u30 (ref), u38 (ref), u32 (ref), u31 (ref), u44 (copy), TattleSeal (copy), u6 (copy), debug_info (copy), u54 (ref), u15 (copy), u56 (copy), u16 (copy)
    u36 = p147:GetModule("Network");
    u37 = p147:GetModule("WeaponController");
    u29 = p147:GetModule("WeaponManager");
    u30 = p147:GetModule("GameConfiguration");
    u38 = p147:GetModule("Entities");
    u32 = p147:GetModule("CameraController");
    u31 = p147:GetModule("SettingsData");

    for i, v in u44 do
        local v148 = i == "TattleSeal" and TattleSeal or p147:GetModule(i);

        for _, v2 in v do
            local v149;

            if v148 then
                v149 = v148[v2];
            else
                v149 = v148;
            end;

            local v150 = u6(v149) == "function";
            local v151 = {
                Module = v148 or {},
                Name = v2,
                Function = v149,
                Source = v150 and (debug_info(v149, "s") or "?") or "?",
                Arity = v150 and debug_info(v149, "a") or -1
            };

            if v151.Source == "[C]" then
                u54 = u15.bor(u54, 1);
            end;

            u16.insert(u56, v151);
        end;
    end;
end;

function v39.Start(p152) -- Line: 1243
    -- upvalues: u36 (ref), debug_info (copy), TattleSeal (copy), u116 (ref), ReplicatedStorage (copy), u117 (ref), u118 (ref), u46 (copy), CheckGui (copy), u38 (ref), WatchCharacter (copy), u119 (ref), u35 (copy), u43 (copy), u59 (copy), u60 (ref), u45 (copy), u120 (copy), u16 (copy), u37 (ref), OnWeaponShoot (copy), OnRefill (copy), OnWeaponCreate (copy), ForgetWeapon (copy), RefreshConfig (copy), u30 (ref), u137 (copy), u136 (copy), u139 (copy), u138 (copy), u54 (ref), u15 (copy), u3 (copy), u52 (ref), u5 (copy), u51 (copy), u146 (ref), u6 (copy), u145 (copy), u55 (ref)
    local Tattle = u36.Anticheat.Tattle;
    local Fire = Tattle.Fire;
    local u153 = debug_info(Fire, "s");
    local u154 = TattleSeal.Seed(game.JobId, game:GetService("Players").LocalPlayer.UserId);
    local u155 = 0;
    u116 = Instance.new("Folder");
    u116.Name = "ClientIntegrity";
    u116.Parent = ReplicatedStorage;
    u117 = Instance.new("BindableEvent");
    u117.Name = "IntegrityValidate";
    u117.Parent = u116;
    u117.Event:Connect(function() -- Line: 1265
        -- upvalues: u118 (ref)
        u118 = true;
    end);

    for _, child in game:GetService("StarterGui"):GetChildren() do
        u46[child.Name] = true;
    end;

    task.spawn(function() -- Line: 1277
        -- upvalues: CheckGui (ref)
        game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(p156) -- Line: 1280
            -- upvalues: CheckGui (ref)
            task.defer(CheckGui, p156);
        end);
    end);

    for _, v in u38.GetAllCategoryEntities("Character") do
        WatchCharacter(v);
    end;

    u38.OnEntityCreated:Connect(function(p157, p158, p159) -- Line: 1290
        -- upvalues: WatchCharacter (ref)
        if p157 == "Character" then
            WatchCharacter(p159);
        end;
    end);
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("WeaponConfig");
    end;

    u119 = Assets;

    if u119 then
        u119:SetAttribute("Loaded", nil);
    end;

    local LocalPlayer = game:GetService("Players").LocalPlayer;

    for i, v in u35 do
        LocalPlayer:SetAttribute(i, v);
    end;

    for _, v in u43 do
        u59[v] = game:FindService(v) ~= nil;
    end;

    u60 = { LocalPlayer.CameraMaxZoomDistance, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMode };

    for _, v in u45 do
        local v160 = ReplicatedStorage;

        for _, v2 in v do
            if v160 then
                v160 = v160:FindFirstChild(v2);
            end;
        end;

        if v160 then
            u16.insert(u120, v160);
        end;
    end;

    u37.OnWeaponShoot:Connect(OnWeaponShoot);
    u37.OnWeaponReload:Connect(OnRefill);
    u37.OnAmmoCorrected:Connect(OnRefill);
    u37.OnWeaponCreate:Connect(OnWeaponCreate);
    u37.OnDataPatched:Connect(ForgetWeapon);
    RefreshConfig();
    u30.Updated:Connect(function() -- Line: 1339
        -- upvalues: RefreshConfig (ref), ForgetWeapon (ref)
        RefreshConfig();
        ForgetWeapon(nil);
    end);
    task.spawn(function() -- Line: 1344
        -- upvalues: u137 (ref), u136 (ref), u139 (ref), u138 (ref), u16 (ref), u54 (ref), u15 (ref), u3 (ref), u52 (ref), u5 (ref), debug_info (ref), u51 (ref), TattleSeal (ref), u146 (ref), LocalPlayer (copy), u6 (ref), u145 (ref), u153 (copy), Tattle (copy), Fire (copy), u36 (ref), u154 (copy), u155 (ref), u55 (ref)
        local v161 = 0;

        while true do
            task.wait(1);
            v161 = v161 + 1;
            local v162 = v161 >= 4;
            local v163 = v162 and u137 or u136;
            local v164 = v162 and u139 or u138;

            if not (u16.isfrozen(v163) and (u16.isfrozen(v164) and #v163 == #v164)) then
                u54 = u15.bor(u54, 1);
            end;

            for i = 1, #v164 do
                local v165 = v164[i];

                if not u3(v163[i], v165) then
                    u54 = u15.bor(u54, 1);
                end;

                u52 = false;
                local v166;

                if u5(v165) then
                    if u52 and debug_info(v165, "s") == u51 then
                        v166 = i;
                    else
                        u54 = u15.bor(u54, 1);
                        v166 = i;
                    end;
                else
                    u54 = u15.bor(u54, 128);
                    v166 = i;
                end;
            end;

            local CHALLENGES = TattleSeal.CHALLENGES;
            u146 = u146 % #CHALLENGES + 1;
            local Attribute = LocalPlayer:GetAttribute(TattleSeal.CHALLENGE_ATTRIBUTE);
            local v167 = v162 and u6(Attribute) == "number" and (Attribute // 1 or 0) or 0;
            local v168 = v167 > 0 and { CHALLENGES[u146], TattleSeal.Challenge(v167) } or { CHALLENGES[u146] };
            local v169 = 0;

            for i = 1, #v168 do
                local v170 = v168[i];
                local Bit = v170.Bit;
                local v171 = u54;
                u54 = 0;
                u5(u145[v170.Name]);
                local v172 = u15.btest(u54, Bit);
                u54 = v171;
                local v173;

                if v172 then
                    if i == 2 then
                        v169 = Bit;
                        v173 = i;
                    else
                        v173 = i;
                    end;
                else
                    u54 = u15.bor(u54, 1);
                    v173 = i;
                end;
            end;

            if v162 then
                v161 = 0;

                if u153 == "[C]" or (not u3(Tattle.Fire, Fire) or debug_info(Fire, "s") ~= u153) then
                    u5(u36.ClientPing.Fire, 0);
                else
                    if u5(Fire, {
                        Mask = u54,
                        Shots = u55,
                        Echo = TattleSeal.Seal(u154, u155 + 1, u54, u55, v167, v169)
                    }) then
                        u155 = u155 + 1;
                    else
                        u5(Fire, u54);
                    end;

                    u54 = 0;
                end;
            end;
        end;
    end);
end;

return v39;