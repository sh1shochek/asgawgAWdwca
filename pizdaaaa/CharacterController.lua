-- ReplicatedStorage.GameClient.CharacterController
-- Script path: ReplicatedStorage.GameClient.CharacterController
-- Decompile time: 13.34 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Footsteps = require(ReplicatedStorage.GameClient.Footsteps);
local ValueCodec = require(ReplicatedStorage.Shared.ValueCodec);
local TemplateOverrides = require(ReplicatedStorage.Shared.TemplateOverrides);
local ZoneVolumes = require(ReplicatedStorage.Shared.ZoneVolumes);
local LocalPlayer = Players.LocalPlayer;
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u2 = nil;
local u3 = {};
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
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;

local function RefreshConfig() -- Line: 33
    -- upvalues: u3 (copy), u8 (ref)
    u3.TickRate = u8.Get("Game", "TickRate");
    u3.BuyZoneAnywhere = u8.Get("BuyZone", "Anywhere");
end;

local u27 = {};
local u28 = nil;
local u29 = nil;

local function CollectBuyZones(p30: string?) -- Line: 55
    -- upvalues: u27 (ref), ZoneVolumes (copy)
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Zones");
    end;

    if Map then
        Map = Map:FindFirstChild("BuyZones");
    end;

    local Collect = ZoneVolumes.Collect;

    if p30 then
        if Map then
            Map = Map:FindFirstChild(p30);
        end;
    else
        Map = p30;
    end;

    u27 = Collect(Map);
end;

local function UpdateBuyZone(p31) -- Line: 68
    -- upvalues: u28 (ref), u3 (copy), u27 (ref), ZoneVolumes (copy), u29 (ref), LocalPlayer (copy)
    local v32 = u28;

    if v32 and not u3.BuyZoneAnywhere then
        local Simulation = p31.Simulation;

        if p31.BuyPosition ~= Simulation.Position or (p31.BuyHeight ~= Simulation.Height or p31.BuyZones ~= u27) then
            local Height = Simulation.Height;
            p31.BuyPosition = Simulation.Position;
            p31.BuyHeight = Height;
            p31.BuyZones = u27;
            local v33 = Simulation.Position + vector.create(0, Simulation.Height + 0.45, 0);
            p31.BuyZoneResult = ZoneVolumes.At(u27, v33) ~= nil;
        end;

        v32 = p31.BuyZoneResult;
    end;

    if u29 ~= v32 then
        u29 = v32;
        LocalPlayer:SetAttribute("InBuyZone", v32);
    end;
end;

local function Destroy(p34) -- Line: 87
    -- upvalues: u1 (copy), u24 (ref), u2 (ref)
    u1.OnCharacterDestroy:Fire(p34);
    u24.ResetForcedMove();
    p34.Simulation:Destroy();
    p34.Maid:Destroy();
    table.clear(p34);
    u2 = nil;
end;

function u1.new(p35: vector, p36: number, p37: number?) -- Line: 103
    -- upvalues: u24 (ref), u26 (ref), Destroy (copy), u15 (ref), u10 (ref), u5 (ref), LocalPlayer (copy), u14 (ref), CollectBuyZones (copy), u22 (ref), u6 (ref), Footsteps (copy), UpdateBuyZone (copy), u25 (ref), u1 (copy)
    local u38 = {
        UpdateLeft = u24.UpdateLeft,
        UpdateRight = u24.UpdateRight,
        UpdateForward = u24.UpdateForward,
        UpdateBackward = u24.UpdateBackward,
        UpdateAdditionalInput = u24.UpdateAdditionalInput,
        HandleNewState = u26.HandleNewState,
        GetMisPredictionOffset = u26.GetMisPredictionOffset,
        Destroy = Destroy,
        CurrentServerState = nil,
        PreviousServerState = nil,
        LastConfirmedServerState = 0,
        Simulation = u15.new(p35),
        PreviousSimulation = nil,
        StepTimer = {},
        SimulationCache = u10.new(u5.HistorySize(2))
    };
    u38.Simulation:SetTeam(LocalPlayer:GetAttribute("Team"));
    u38.Simulation:SetIdentifier(p36);
    u14.GiveFreeEquipment(u38.Simulation, nil);
    CollectBuyZones(LocalPlayer:GetAttribute("Team"));
    u38.SpawnTick = p37 or 0;
    local ServerFrame = u22.GetServerFrame();
    u38.ServerTick = math.max(ServerFrame, u38.SpawnTick);
    u38.MisPrediction = Vector3.new(0, 0, 0);
    u38.MisPredictionTime = 0;
    u38.ReconciliationCorrection = 0;
    u38.PredictedCommands = {};
    u38.Commands = {};
    u38.TotalCommandCount = 0;
    u38.IdleCommandCount = 0;
    u38.StateHistory = u10.new(u5.HistorySize(2));
    u38.WeaponStateHistory = u10.new(u5.HistorySize(2));
    u38.WeaponSimulationCache = u10.new(u5.HistorySize(2));
    u38.CurrentCommand = nil;
    u38.Maid = u6.new();
    u38.IdleTicks = 0;
    u38.IdleStateTicks = 0;
    u38.PendingIdleCommand = nil;
    u38.Left = 0;
    u38.Right = 0;
    u38.Backward = 0;
    u38.Forward = 0;
    u38.MoveX = 0;
    u38.MoveZ = 0;
    u38.Jump = false;
    u38.Walk = false;
    u38.Duck = false;
    u38.PressE = false;
    u38.Maid:Add("Character_ProcessPhysics", u5.OnTick.Connect({
        Function = function(p39) -- Line: 196
            -- upvalues: u38 (copy), u5 (ref), u24 (ref), Footsteps (ref), UpdateBuyZone (ref)
            if u38.CurrentServerState ~= u38.PreviousServerState then
                u38:HandleNewState();
            end;

            local Tick = u5.GetTick();
            local v40 = u24.BuildCommand(u38, Tick);
            u38.CurrentCommand = v40;
            local ByTick = u38.SimulationCache:GetByTick(Tick - 1);
            u38.PreviousSimulation = ByTick and ByTick.Snapshot or nil;
            local Position = u38.Simulation.Position;
            u38.Simulation:ProcessCommand(v40, p39);
            u24.PostPhysicsStep(u38, Position, p39);
            Footsteps.UpdateLocal(u38.StepTimer, u38.Simulation, p39);
            UpdateBuyZone(u38);
            u38.SimulationCache:PushFilled(Tick, nil, u38.Simulation.WriteState, u38.Simulation);
        end,

        Priority = 1,
        SubPriority = 1
    }));
    u38.Maid:Add("Character_FallDamageSound", u38.Simulation.Health:Connect(function() -- Line: 230
        -- upvalues: u38 (copy), Footsteps (ref)
        if not u38.Simulation.Resimulating then
            Footsteps.PlayLocalFallDamage();
        end;
    end));
    u38.Maid:Add("Character_ProcessPacket", u5.OnTick.Connect({
        Function = function() -- Line: 237
            -- upvalues: u25 (ref), u38 (copy)
            u25.ProcessPacket(u38);
        end,

        Priority = 1,
        SubPriority = 999
    }));
    u38.Maid:Add("Character_FlushPacket", u5.PostTick.Connect({
        Function = function() -- Line: 254
            -- upvalues: u25 (ref), u38 (copy)
            u25.FlushPacket(u38);
        end,

        Priority = 4,
        SubPriority = 1
    }));
    u1.OnCharacterSpawn:Fire(u38);
    u1.OnPostCharacterSpawn:Fire(u38);

    return u38;
end;

function u1.IsAlive() -- Line: 274
    -- upvalues: u2 (ref)
    local v41 = u2 and next(u2);

    return v41;
end;

function u1.GetCharacter() -- Line: 278
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.Init(p42) -- Line: 284
    -- upvalues: u5 (ref), u4 (ref), u6 (ref), u7 (ref), u8 (ref), u10 (ref), u17 (ref), u9 (ref), u23 (ref), u1 (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u20 (ref), u22 (ref), u24 (ref), u25 (ref), u26 (ref), u3 (copy), RefreshConfig (copy), u28 (ref), GameStats (copy), u29 (ref), LocalPlayer (copy)
    u5 = p42:GetModule("Tick");
    u4 = p42:GetModule("Network");
    u6 = p42:GetModule("Maid");
    u7 = p42:GetModule("Table");
    u8 = p42:GetModule("GameConfiguration");
    u10 = p42:GetModule("SnapshotRing");
    u17 = p42:GetModule("BufferScheme");
    u9 = p42:GetModule("GetUserPlatform");
    u23 = p42:GetModule("Signal");
    u1.OnCharacterSpawn = u23.new();
    u1.OnCharacterDestroy = u23.new();
    u1.OnPostCharacterSpawn = u23.new();
    u11 = p42:GetModule("CameraController");
    u12 = p42:GetModule("BindsController");
    u13 = p42:GetModule("WeaponController");
    u14 = p42:GetModule("WeaponConstructor");
    u15 = p42:GetModule("Simulation");
    u16 = p42:GetModule("Entities");
    u20 = p42:GetModule("Gui");
    u22 = p42:GetModule("ClientModule");
    u24 = p42:GetModule("CharacterInput");
    u25 = p42:GetModule("CharacterNetworking");
    u26 = p42:GetModule("CharacterReconciliation");
    u3.TickRate = u8.Get("Game", "TickRate");
    u3.BuyZoneAnywhere = u8.Get("BuyZone", "Anywhere");
    u8.Updated:Connect(RefreshConfig);

    local function RefreshCanBuy() -- Line: 326
        -- upvalues: u28 (ref), GameStats (ref)
        u28 = GameStats:GetAttribute("CanBuy") and true or false;
    end;

    local function RefreshReportedBuyZone() -- Line: 329
        -- upvalues: u29 (ref), LocalPlayer (ref)
        u29 = LocalPlayer:GetAttribute("InBuyZone");
    end;

    GameStats:GetAttributeChangedSignal("CanBuy"):Connect(RefreshCanBuy);
    LocalPlayer:GetAttributeChangedSignal("InBuyZone"):Connect(RefreshReportedBuyZone);
    u28 = GameStats:GetAttribute("CanBuy") and true or false;
    u29 = LocalPlayer:GetAttribute("InBuyZone");
end;

function u1.Start(p43) -- Line: 339
    -- upvalues: u18 (ref), u17 (ref), u19 (ref), u21 (ref), u20 (ref), CollectBuyZones (copy), LocalPlayer (copy), u4 (ref), u2 (ref), u1 (copy), ValueCodec (copy), TemplateOverrides (copy)
    u18 = u17.GetScheme("CharacterState");
    u19 = u17.GetScheme("WeaponState");
    u21 = u20.GetComponent("MobileControls");
    p43:GetModule("NewMapAdded").OnMapAdded:Connect(function() -- Line: 345
        -- upvalues: CollectBuyZones (ref), LocalPlayer (ref)
        CollectBuyZones(LocalPlayer:GetAttribute("Team"));
    end);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 348
        -- upvalues: CollectBuyZones (ref), LocalPlayer (ref)
        CollectBuyZones(LocalPlayer:GetAttribute("Team"));
    end);
    u4.Character.CreateCharacter.On(function(p44: vector, p45: number, p46: number?) -- Line: 352
        -- upvalues: u2 (ref), u1 (ref)
        u2 = u1.new(p44, p45, p46);
    end);
    u4.Character.DestroyCharacter.On(function() -- Line: 356
        -- upvalues: u2 (ref)
        u2:Destroy();
    end);
    u4.Character.HandleNewState.On(function(p47) -- Line: 360
        -- upvalues: u1 (ref), u2 (ref)
        if not u1.IsAlive() then
            return;
        end;

        local CurrentServerState = u2.CurrentServerState;

        if CurrentServerState and p47.CurrentServerTick <= CurrentServerState.CurrentServerTick then
            return;
        end;

        u2.CurrentServerState = p47;
        u2.LastStateArrival = os.clock();
    end);
    u4.Character.SimulationProperty.On(function(p48: string, p49: boolean) -- Line: 380
        -- upvalues: u2 (ref)
        if u2 and u2.Simulation then
            u2.Simulation[p48] = p49;
        end;
    end);
    u4.SimulationConstants.On(function(p50) -- Line: 388
        -- upvalues: u1 (ref), u2 (ref)
        if not u1.IsAlive() then
            return;
        end;

        local Simulation = u2.Simulation;

        if p50.Noclip ~= nil then
            Simulation.Noclip = p50.Noclip;
        end;

        for _, v in p50.Constants do
            if Simulation.Constants[v.Key] ~= nil then
                Simulation.Constants[v.Key] = v.Value;
            end;
        end;
    end);
    u4.Character.CharacterConstantBalls.On(function(p51) -- Line: 408
        -- upvalues: u1 (ref), u2 (ref), ValueCodec (ref)
        if not u1.IsAlive() then
            return;
        end;

        local Constants = u2.Simulation.Constants;

        if Constants[p51.Key] ~= nil then
            Constants[p51.Key] = ValueCodec.Decode(p51.Value);
        end;
    end);
    u4.Character.CharacterTemplateBalls.On(function(p52) -- Line: 420
        -- upvalues: TemplateOverrides (ref), u1 (ref), u2 (ref)
        local v53 = TemplateOverrides.HandleSimulationTemplate(p52);

        if v53 and u1.IsAlive() then
            local Constants = u2.Simulation.Constants;

            for _, v in ipairs(v53) do
                if Constants[v.Key] ~= nil then
                    Constants[v.Key] = v.Value;
                end;
            end;
        end;
    end);
end;

return u1;