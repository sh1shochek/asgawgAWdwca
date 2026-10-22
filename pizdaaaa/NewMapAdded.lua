-- ReplicatedStorage.ClientModules.NewMapAdded
-- Script path: ReplicatedStorage.ClientModules.NewMapAdded
-- Decompile time: 7.92 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
local ContentProvider = game:GetService("ContentProvider");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
game:GetService("MaterialService");
local script_MapLighting = require(script.MapLighting);
local script_MapAmbience = require(script.MapAmbience);
local u2 = nil;
local u3 = {};
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = false;

local function PreloadMaps(p19: table) -- Line: 60
    -- upvalues: u18 (ref), ReplicatedStorage (copy), u17 (copy), ContentProvider (copy), RunService (copy)
    if u18 then
        return;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Maps");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Preload");
    end;

    if not Assets then
        return;
    end;

    local u20 = {};

    for _, v in p19 do
        if not u17[v] then
            local v21 = Assets:FindFirstChild(v);

            if v21 and v21:IsA("StringValue") then
                u17[v] = true;

                for i in string.gmatch(v21.Value, "[^\n]+") do
                    table.insert(u20, i);
                end;
            end;
        end;
    end;

    if #u20 == 0 then
        return;
    end;

    u18 = true;
    task.spawn(function() -- Line: 99
        -- upvalues: u20 (copy), ContentProvider (ref), RunService (ref), u18 (ref)
        os.clock();

        for i = 1, #u20, 32 do
            local math_min_ret = math.min(i + 32 - 1, #u20);
            pcall(ContentProvider.PreloadAsync, ContentProvider, table.move(u20, i, math_min_ret, 1, {}));
            RunService.Heartbeat:Wait();
            local _ = i;
        end;

        u18 = false;
    end);
end;

local function RunModification(p22, u23, u24) -- Line: 116
    for _, v in p22 do
        local v25 = v;

        for _, v2 in v do
            local _, result = pcall(function() -- Line: 119
                -- upvalues: v2 (copy), u23 (copy), u24 (copy)
                local v26 = v2[u23];

                if v26 then
                    v26(v2, u24);
                end;
            end);

            if result then
                warn("NewMapAdded Modification", v2, v25, result);
            end;
        end;
    end;
end;

local function UnloadMofications() -- Line: 134
    -- upvalues: RunModification (copy), u3 (ref)
    RunModification(u3, "Destroy");
    table.clear(u3);
end;

local function LoadModifications(p27: string?) -- Line: 142
    -- upvalues: ReplicatedStorage (copy), u3 (ref), RunModification (copy), u1 (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Maps");
    end;

    if p27 then
        if Assets then
            Assets = Assets:FindFirstChild(p27);
        end;
    else
        Assets = p27;
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Modifications");
    end;

    if Assets then
        local v28 = {
            Shared = {},
            Client = {}
        };

        for _, v in { "Client", "Shared" } do
            local v29 = Assets:FindFirstChild(v);

            if v29 then
                local v30 = v28[v];
                local v31 = v;

                for _, child in ipairs(v29:GetChildren()) do
                    v30[child.Name] = require(child);
                end;

                if not next(v30) then
                    v28[v31] = nil;
                end;
            end;
        end;

        u3 = v28;
        RunModification(u3, "Init", u1);
        RunModification(u3, "Start", u1);
    end;
end;

u1.Lighting = script_MapLighting;
u1.Ambience = script_MapAmbience;

function u1.OverrideEverything(p32: boolean) -- Line: 185
    -- upvalues: script_MapLighting (copy), script_MapAmbience (copy)
    script_MapLighting.OverrideEverything(p32);
    script_MapAmbience.SetActive(p32 ~= false);
end;

function u1.UpdatePlayerSettings() -- Line: 192
    -- upvalues: script_MapLighting (copy)
    script_MapLighting.UpdatePlayerSettings();
end;

function u1.GetRandomSpawn() -- Line: 196
    local Map = workspace:FindFirstChild("Map");

    if not Map then
        return;
    end;

    local Spawns = Map:FindFirstChild("Spawns");

    if not Spawns then
        return;
    end;

    local v33 = Spawns:QueryDescendants("BasePart");

    if #v33 ~= 0 then
        return v33[math.random(1, #v33)];
    end;
end;

function u1.Init(p34) -- Line: 217
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u13 (ref), u8 (ref), u9 (ref), u10 (ref), u14 (ref), u12 (ref), u15 (ref), u16 (ref), script_MapLighting (copy), u1 (copy), u2 (ref), script_MapAmbience (copy), LoadModifications (copy), GameStats (copy), HttpService (copy), PreloadMaps (copy), RunModification (copy), u3 (ref)
    u4 = p34:GetModule("Tick");
    u5 = p34:GetModule("Network");
    u6 = p34:GetModule("Entities");
    u7 = p34:GetModule("CollisionModule");
    u13 = p34:GetModule("WeaponConstructor");
    u8 = p34:GetModule("Bullet");
    u9 = p34:GetModule("Signal");
    u10 = p34:GetModule("Gui");
    u14 = p34:GetModule("BindsController");
    u12 = p34:GetModule("WeaponController");
    u15 = p34:GetModule("ParticleHandler");
    u16 = p34:GetModule("Ragdoll");
    script_MapLighting:Init(u14);
    u1.OnMapAdded = u9.new();
    u1.OnMapRemove = u9.new();
    u5.OnMapAdded.On(function(p35) -- Line: 242
        -- upvalues: u2 (ref), u1 (ref), script_MapLighting (ref), u14 (ref), script_MapAmbience (ref), LoadModifications (ref)
        os.clock();
        u2 = workspace:WaitForChild("Map", 30);

        if not u2 then
            return;
        end;

        os.clock();
        u1.OnMapAdded:Fire(u2);
        script_MapLighting.ApplyMapSettings(p35, not u14.FramePriority.MainMenu);
        script_MapAmbience.Start(p35, u2, not u14.FramePriority.MainMenu);
        LoadModifications(p35);
    end);
    GameStats:GetAttributeChangedSignal("MapVote"):Connect(function() -- Line: 268
        -- upvalues: GameStats (ref), HttpService (ref), PreloadMaps (ref)
        local Attribute = GameStats:GetAttribute("MapVote");

        if type(Attribute) ~= "string" then
            return;
        end;

        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if not success or type(result) ~= "table" then
            return;
        end;

        local v36 = {};

        for i in result do
            table.insert(v36, i);
        end;

        PreloadMaps(v36);
    end);
    u5.OnMapRemoving.On(function() -- Line: 290
        -- upvalues: u1 (ref), script_MapAmbience (ref), u2 (ref), RunModification (ref), u3 (ref), u7 (ref), u14 (ref), script_MapLighting (ref)
        u1.OnMapRemove:Fire();
        script_MapAmbience.Stop();
        u2 = nil;
        RunModification(u3, "Destroy");
        table.clear(u3);
        u7.Cleanup();
        u7.Generated = false;

        if not u14.FramePriority.MainMenu then
            script_MapLighting.ApplyNoTexture(false);
            script_MapLighting.OverrideEverything(false);
        end;

        script_MapLighting.ClearLightingData();
    end);
    u5.RoundReset.On(function() -- Line: 308
        -- upvalues: u6 (ref), u15 (ref), u16 (ref), u12 (ref)
        for _, v in { "DroppedWeapon", "Bomb" } do
            local v37 = v;

            for i in u6.GetAllCategoryEntities(v) do
                u6.Destroy(v37, i);
            end;
        end;

        u15.ClearBulletHoles();
        u16.Cleanup();

        for _, child in workspace.Debris:GetChildren() do
            if child:IsA("Model") then
                child:Destroy();
            end;
        end;

        local CurrentWeapon = u12.GetCurrentWeapon();

        if CurrentWeapon then
            CurrentWeapon:Reset();
        end;
    end);
end;

function u1.Start2(p38) -- Line: 338
    -- upvalues: u5 (ref), u7 (ref), u11 (ref), u10 (ref), script_MapLighting (copy), u14 (ref), u2 (ref), LoadModifications (copy), GameStats (copy), u1 (copy)
    u5.GenerateCollision.On(function(u39) -- Line: 339
        -- upvalues: u7 (ref)
        task.spawn(function() -- Line: 340
            -- upvalues: u7 (ref), u39 (copy)
            u7.GenerateCollision(u39);
        end);
    end);
    u11 = u10.GetComponent("Settings");
    script_MapLighting:Init(u14, u11);
    u2 = workspace:FindFirstChild("Map");

    if u2 then
        LoadModifications(GameStats:GetAttribute("Map"));
        script_MapLighting.ApplyMapSettings(GameStats:GetAttribute("Map"), not u14.FramePriority.MainMenu);
        u1.OnMapAdded:Fire(u2);
    end;
end;

return u1;