-- ReplicatedStorage.Handler.Loader
-- Script path: ReplicatedStorage.Handler.Loader
-- Decompile time: 11.46 ms

-- Decompiled with Potassium's decompiler.

os.clock();
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Gui = ReplicatedStorage.GameClient.Gui;
local u1 = {};

for _, child in ReplicatedStorage.Shared.Managers:GetChildren() do
    u1[child] = true;
end;

local u2 = {
    Server = true,
    Types = true,
    MinkowskiSumInstance = true,
    QuickHull2 = true,
    TrianglePart = true,
    Writer = true,
    Reader = true,
    Sizes = true,
    Crunchyroll = true
};
local u3 = {
    BufferScheme = true,
    Crunchyroll = true,
    AnimationManager = true
};
local u4 = {};
local u5 = {};
local u6 = { "ClientModules.ArcadeEffects", "ClientModules.DebugVisualizers", "ClientModules.ClientModule", "Shared.Simulation.Config", "Shared.KeyframeWalk", "Shared.LegSystem", "GameClient.PhysicsController" };
local u7 = {
    RemoteEvent = true,
    UnreliableRemoteEvent = true,
    RemoteFunction = true
};
local u8 = { "Workspace", "Players", "ReplicatedStorage", "ReplicatedFirst", "Lighting", "StarterGui", "StarterPlayer", "StarterPack", "SoundService", "Teams", "TextChatService" };
local Maps = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Maps");
local WeaponConfig = ReplicatedStorage.Assets:FindFirstChild("WeaponConfig");
local Random_new_ret = Random.new();

local function LoadModule(p9: userdata) -- Line: 66
    -- upvalues: u2 (ref), Gui (copy), u3 (ref), Maps (copy), WeaponConfig (copy), u1 (copy), u5 (copy), u4 (copy)
    local Name = p9.Name;

    if u2[Name] then
        return;
    end;

    if p9:IsDescendantOf(Gui) or u3[p9.Parent.Name] then
        return;
    end;

    if p9:IsDescendantOf(Maps) then
        return;
    end;

    if p9 == WeaponConfig then
        return;
    end;

    local v10 = false;

    for i, _ in u1 do
        if p9:IsDescendantOf(i) then
            v10 = true;
            break;
        end;
    end;

    if v10 then
        return;
    end;

    os.clock();
    local v11 = require(p9);
    table.insert(u5, p9);
    u4[Name == "Client" and "Network" or Name] = v11;

    if typeof(v11) ~= "function" and (v11.Init or v11.Initialization) then
        function v11.GetModule(p12, p13) -- Line: 116
            -- upvalues: u4 (ref)
            return u4[p13];
        end;
    end;
end;

local function RandomName() -- Line: 122
    -- upvalues: Random_new_ret (copy)
    local table_create_ret = table.create(16);

    for i = 1, 16 do
        local v14 = Random_new_ret:NextInteger(1, 62);
        table_create_ret[i] = string.sub("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", v14, v14);
        local _ = i;
    end;

    return table.concat(table_create_ret);
end;

local function Rename(u15: userdata) -- Line: 134
    -- upvalues: RandomName (copy)
    pcall(function() -- Line: 135
        -- upvalues: u15 (copy), RandomName (ref)
        u15.Name = RandomName();
    end);
end;

local function RenameRemote(u16: userdata) -- Line: 140
    -- upvalues: u7 (copy), RandomName (copy)
    if u7[u16.ClassName] then
        pcall(function() -- Line: 135
            -- upvalues: u16 (copy), RandomName (ref)
            u16.Name = RandomName();
        end);
    end;
end;

local function Scramble() -- Line: 159
    -- upvalues: u6 (copy), ReplicatedStorage (copy), u5 (copy), RandomName (copy), u7 (copy), RenameRemote (copy), u8 (copy)
    local v17 = {};

    for _, v in u6 do
        local v18 = ReplicatedStorage;

        for i in string.gmatch(v, "[^.]+") do
            if v18 then
                v18 = v18:FindFirstChild(i);
            end;
        end;

        if v18 then
            v17[v18] = true;
        end;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v19 = {};

    for _, v in u5 do
        if not (v17[v] or (#v:GetChildren() > 0 or Assets and v:IsDescendantOf(Assets))) then
            table.insert(v19, v);
        end;
    end;

    for _, v in v19 do
        v.Name = RandomName();
        v.Parent = nil;
    end;

    for _, descendant in ReplicatedStorage:GetDescendants() do
        if u7[descendant.ClassName] then
            pcall(function() -- Line: 135
                -- upvalues: descendant (copy), RandomName (ref)
                descendant.Name = RandomName();
            end);
        end;
    end;

    ReplicatedStorage.DescendantAdded:Connect(RenameRemote);

    for _, v in u8 do
        local u20 = game:FindService(v);

        if u20 then
            pcall(function() -- Line: 135
                -- upvalues: u20 (copy), RandomName (ref)
                u20.Name = RandomName();
            end);
        end;
    end;
end;

local function InitModule(p21: any, p22: userdata) -- Line: 206
    if typeof(p22) ~= "function" and p22.Init then
        os.clock();
        p22:Init();
    end;
end;

local function StartModule(p23: any, p24: userdata) -- Line: 214
    if typeof(p24) ~= "function" and p24.Start then
        os.clock();
        p24:Start();
    end;
end;

local function Start2Module(p25: any, p26: userdata) -- Line: 222
    if typeof(p26) ~= "function" and p26.Start2 then
        os.clock();
        p26:Start2();
    end;
end;

for _, v in ReplicatedStorage:QueryDescendants("ModuleScript") do
    local success, result = pcall(LoadModule, v);

    if not success then
        warn((`Failed to load {v.Name} | {result}`));
    end;
end;

for i, v in u4 do
    local success, result = pcall(InitModule, i, v);

    if not success then
        warn((`Failed to Init {i} | {result}`));
    end;
end;

for i, v in u4 do
    task.defer(function() -- Line: 252
        -- upvalues: StartModule (copy), i (copy), v (copy)
        local success, result = pcall(StartModule, i, v);

        if not success then
            warn((`Failed to Start {i} | {result}`));
        end;
    end);
end;

for i, v in u4 do
    task.defer(function() -- Line: 262
        -- upvalues: Start2Module (copy), i (copy), v (copy)
        local success, result = pcall(Start2Module, i, v);

        if not success then
            warn((`Failed to Start2 {i} | {result}`));
        end;
    end);
end;

table.clear(u2);
u2 = nil;
table.clear(u3);
u3 = nil;
u4.Network.Player.PlayerLoaded.Fire();