-- ReplicatedStorage.Controllers.SurvivalVoiceController
-- Script path: ReplicatedStorage.Controllers.SurvivalVoiceController
-- Decompile time: 12.89 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Players = game:GetService("Players");
local Sound = require(ReplicatedStorage.Classes.Sound);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local HordeController = require(ReplicatedStorage.Controllers.HordeController);
local GeneratorController = require(ReplicatedStorage.Controllers.GeneratorController);
local SurvivalState = require(ReplicatedStorage.Components.Common.SurvivalState);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local SurvivalBuyRules = require(ReplicatedStorage.Components.Common.SurvivalBuyRules);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u2 = {
    Surrounded = 30,
    Reloading = 20,
    ["Headshot Streak"] = 15,
    ["Upgrade Reminder"] = 60,
    ["Captain Laugh Gasp"] = 45,
    ["Captain Laugh Hysterical"] = 90,
    ["Generator A Under Attack"] = 25,
    ["Generator B Under Attack"] = 25
};
local NumberRange_new_ret = NumberRange.new(20, 120);
local u3 = {
    Rifle = true,
    Heavy = true
};
local u4 = {
    Kevlar = true,
    ["Kevlar + Helmet"] = true
};
local LocalPlayer = Players.LocalPlayer;
local Random_new_ret = Random.new();
local u5 = nil;
local u6 = false;
local u7 = 0;
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = false;
local u14 = false;
local u15 = 0;
local u16 = 0;
local u17 = nil;
local u18 = 100;
local u19 = (-1 / 0);
local u20 = 100;
local u21 = 0;
local u22 = 0;
local u23 = 0;
local u24 = 0;
local u25 = 0;
local u26 = nil;

local function now() -- Line: 144
    return os.clock();
end;

local function hasLine(p27: string) -- Line: 148
    -- upvalues: u5 (ref)
    local v28 = u5;
    local v29;

    if v28 == nil or v28.Sounds == nil then
        v29 = false;
    else
        v29 = v28.Sounds:FindFirstChild(p27) ~= nil;
    end;

    return v29;
end;

local function speak(p30: string) -- Line: 153
    -- upvalues: u5 (ref), SoundService (copy), u9 (copy), u6 (ref), u7 (ref), u8 (copy), speak (copy)
    local v31 = u5;

    if not v31 then
        return;
    end;

    local v32 = v31:playOneTime({
        Name = p30,
        Parent = SoundService
    });

    if not v32 then
        return;
    end;

    u9[p30] = os.clock();
    u6 = true;
    u7 = u7 + 1;
    local u33 = u7;

    local function finished() -- Line: 166
        -- upvalues: u33 (copy), u7 (ref), u6 (ref), u8 (ref), speak (ref)
        if u33 ~= u7 then
            return;
        end;

        u6 = false;

        while #u8 > 0 do
            local table_remove_ret = table.remove(u8, 1);

            if os.clock() - table_remove_ret.At <= 4 then
                speak(table_remove_ret.Name);

                return;
            end;
        end;
    end;

    v32.Ended:Once(finished);
    task.delay(6, finished);
end;

local function canPlay(p34: string) -- Line: 183
    -- upvalues: u2 (copy), IsSurvivalMode (copy), u5 (ref), u9 (copy)
    local v35 = u2[p34] or 4;
    local v36 = IsSurvivalMode();

    if v36 then
        local v37 = u5;

        if v37 == nil or v37.Sounds == nil then
            v36 = false;
        else
            v36 = v37.Sounds:FindFirstChild(p34) ~= nil;
        end;

        if v36 then
            v36 = v35 <= os.clock() - (u9[p34] or (-1 / 0));
        end;
    end;

    return v36;
end;

local function isStanding() -- Line: 188
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), SurvivalDowned (copy)
    local v38 = CharacterResolver.isAlivePlayer(LocalPlayer) and not SurvivalDowned.IsDowned(LocalPlayer);

    return v38;
end;

local function getRootPosition() -- Line: 192
    -- upvalues: CharacterResolver (copy)
    local RootPart = CharacterResolver.getRootPart(CharacterResolver.getLocalCharacter());

    if RootPart then
        return RootPart.Position;
    end;

    return nil;
end;

local function onGeneratorState(p39) -- Line: 199
    -- upvalues: u10 (copy), u11 (copy), u12 (copy), u1 (copy)
    local Key = p39.Key;

    if Key == "" then
        table.clear(u10);
        table.clear(u11);
        table.clear(u12);

        return;
    end;

    local v40 = u10[Key];
    u10[Key] = p39.Destroyed;

    if v40 == nil then
        local v41;

        if p39.MaxHealth > 0 then
            v41 = p39.Health / p39.MaxHealth < 0.25;
        else
            v41 = false;
        end;

        u12[Key] = v41;

        return;
    end;

    if p39.Destroyed then
        if not v40 then
            u1.Play(`Generator {Key} Offline`, 3);
            local v42 = 0;

            for _, v in u10 do
                if not v then
                    v42 = v42 + 1;
                end;
            end;

            if v42 == 1 then
                u1.Play("One Generator Left", 3);
            end;
        end;

        return;
    end;

    if p39.Drop <= 0 then
        return;
    end;

    local os_clock_ret = os.clock();
    local v43 = u11[Key];
    u11[Key] = os_clock_ret;

    if (p39.MaxHealth <= 0 and 1 or p39.Health / p39.MaxHealth) >= 0.25 or u12[Key] then
        if not v43 or os_clock_ret - v43 >= 15 then
            u1.Play(`Generator {Key} Under Attack`, 2);
        end;

        return;
    end;

    u12[Key] = true;
    u1.Play(`Generator {Key} Failing`, 2);
end;

local function getPrimaries() -- Line: 249
    -- upvalues: u17 (ref), ReplicatedStorage (copy)
    local v44 = u17;

    if v44 then
        return v44;
    end;

    local v45 = {};

    for _, child in ReplicatedStorage.Database.Custom.Weapons:GetChildren() do
        if child:IsA("ModuleScript") then
            local success, result = pcall(require, child);

            if success and (type(result) == "table" and (result.Slot == "Primary" and type(result.Cost) == "number")) then
                table.insert(v45, {
                    Name = child.Name,
                    Team = result.Team,
                    Cost = result.Cost
                });
            end;
        end;
    end;

    u17 = v45;

    return v45;
end;

local function hasAffordableUpgrade() -- Line: 275
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy), getPrimaries (copy), SurvivalBuyRules (copy)
    local Attribute = LocalPlayer:GetAttribute("Money");

    if typeof(Attribute) ~= "number" then
        return false;
    end;

    local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
    local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
    local CurrentInventory = InventoryController.getCurrentInventory();

    if CurrentInventory then
        CurrentInventory = CurrentInventory[NumberSlots.Primary];
    end;

    if CurrentInventory then
        CurrentInventory = CurrentInventory._items[1];
    end;

    local Attribute2 = LocalPlayer:GetAttribute("Team");
    local v46 = 0;
    local v47 = getPrimaries();

    if CurrentInventory then
        for _, v in v47 do
            if v.Name == CurrentInventory.Name then
                v46 = SurvivalBuyRules.GetPrice(v.Name, v.Cost);
                break;
            end;
        end;
    end;

    for _, v in v47 do
        if v.Team == "Both" or (v.Team == nil or v.Team == Attribute2) then
            local Price = SurvivalBuyRules.GetPrice(v.Name, v.Cost);

            if v46 < Price and Price <= Attribute then
                return true;
            end;
        end;
    end;

    return false;
end;

local function onResupplyChanged() -- Line: 308
    -- upvalues: SurvivalState (copy), u1 (copy), u16 (ref), CharacterResolver (copy), LocalPlayer (copy), SurvivalDowned (copy), hasAffordableUpgrade (copy)
    local Wave = SurvivalState.GetWave();

    if not SurvivalState.IsResupply() or Wave <= 1 then
        return;
    end;

    u1.Play("Buy Period Start", 3);
    task.delay(12, function() -- Line: 315
        -- upvalues: SurvivalState (ref), Wave (copy), u16 (ref), CharacterResolver (ref), LocalPlayer (ref), SurvivalDowned (ref), hasAffordableUpgrade (ref), u1 (ref)
        if SurvivalState.IsResupply() and (SurvivalState.GetWave() == Wave and u16 ~= Wave) then
            local v48 = CharacterResolver.isAlivePlayer(LocalPlayer) and not SurvivalDowned.IsDowned(LocalPlayer);

            if v48 and hasAffordableUpgrade() then
                u1.Play("Upgrade Reminder", 1);
            end;
        end;
    end);
end;

local function onWaveStarted() -- Line: 328
    -- upvalues: SurvivalState (copy), u1 (copy), u13 (ref), u15 (ref), Random_new_ret (copy), NumberRange_new_ret (copy)
    if SurvivalState.GetWaveElapsed() == nil then
        return;
    end;

    local Wave = SurvivalState.GetWave();
    u1.Play("Buy Period End", 3);

    if SurvivalState.IsFlamingWave() then
        task.delay(0.1, u1.Play, "Captain Flaming Wave", 3);
    elseif Wave >= 5 and not u13 then
        u13 = true;
        task.delay(0.1, u1.Play, "Captain Laugh Horde", 3);
    end;

    if Wave >= 15 and (u15 ~= Wave and Random_new_ret:NextNumber() < 0.35) then
        u15 = Wave;
        task.delay(Random_new_ret:NextNumber(NumberRange_new_ret.Min, NumberRange_new_ret.Max), function() -- Line: 344
            -- upvalues: SurvivalState (ref), Wave (copy), u1 (ref)
            if SurvivalState.GetWave() == Wave and SurvivalState.GetWaveElapsed() ~= nil then
                u1.Play("Captain Laugh Hysterical", 2);
            end;
        end);
    end;
end;

local function onWaveChanged() -- Line: 352
    -- upvalues: SurvivalState (copy), u13 (ref), u14 (ref), u15 (ref)
    if SurvivalState.GetWave() <= 1 then
        u13 = false;
        u14 = false;
        u15 = 0;
    end;
end;

local function recountDowned() -- Line: 363
    -- upvalues: Players (copy), SurvivalDowned (copy), u24 (ref), u1 (copy)
    local v49 = 0;

    for _, v in Players:GetPlayers() do
        if SurvivalDowned.IsDowned(v) then
            v49 = v49 + 1;
        end;
    end;

    if v49 >= 2 and u24 < 2 then
        u1.Play("Captain Laugh Gasp", 2);
    end;

    u24 = v49;
end;

local function watchPlayer(p50: userdata) -- Line: 376
    -- upvalues: SurvivalDowned (copy), recountDowned (copy)
    p50:GetAttributeChangedSignal(SurvivalDowned.DOWNED_ATTRIBUTE):Connect(recountDowned);
end;

local function onHealthChanged() -- Line: 382
    -- upvalues: LocalPlayer (copy), u18 (ref), u20 (ref), u19 (ref)
    local Attribute = LocalPlayer:GetAttribute("Health");

    if typeof(Attribute) ~= "number" then
        return;
    end;

    u18 = u20;
    u20 = Attribute;
    u19 = os.clock();
end;

local function endKillChain(p51: number) -- Line: 392
    -- upvalues: u22 (ref), u21 (ref), u1 (copy)
    if p51 ~= u22 then
        return;
    end;

    local v52 = u21;
    u21 = 0;

    if v52 >= 5 then
        u1.Play("Massacre", 1);

        return;
    end;

    if v52 >= 3 then
        u1.Play("Triple Kill", 1);

        return;
    end;

    if v52 == 2 then
        u1.Play("Double Kill", 1);
    end;
end;

local function onHitConfirmed(p53: boolean, p54: boolean) -- Line: 407
    -- upvalues: IsSurvivalMode (copy), u21 (ref), u22 (ref), endKillChain (copy), u23 (ref), u1 (copy)
    if not (p54 and IsSurvivalMode()) then
        return;
    end;

    u21 = u21 + 1;
    u22 = u22 + 1;
    task.delay(1.25, endKillChain, u22);
    u23 = not p53 and 0 or u23 + 1;

    if u23 >= 3 then
        u23 = 0;
        u1.Play("Headshot Streak", 1);
    end;
end;

local function scanSurroundings() -- Line: 422
    -- upvalues: u25 (ref), IsSurvivalMode (copy), SurvivalState (copy), CharacterResolver (copy), LocalPlayer (copy), SurvivalDowned (copy), HordeController (copy), u1 (copy)
    local os_clock_ret = os.clock();

    if os_clock_ret - u25 < 0.5 then
        return;
    end;

    u25 = os_clock_ret;

    if IsSurvivalMode() and SurvivalState.GetWaveElapsed() ~= nil then
        local v55 = CharacterResolver.isAlivePlayer(LocalPlayer) and not SurvivalDowned.IsDowned(LocalPlayer);

        if v55 then
            local RootPart = CharacterResolver.getRootPart(CharacterResolver.getLocalCharacter());
            local v56;

            if RootPart then
                v56 = RootPart.Position;
            else
                v56 = nil;
            end;

            if v56 and HordeController.CountNear(v56, 14, 8) >= 6 then
                u1.Play("Surrounded", 1);
            end;
        end;
    end;
end;

local function evaluateScanning() -- Line: 438
    -- upvalues: IsSurvivalMode (copy), SurvivalState (copy), u26 (ref), RunServiceController (copy), scanSurroundings (copy)
    local v57 = IsSurvivalMode() and SurvivalState.GetWaveElapsed() ~= nil;

    if v57 and not u26 then
        u26 = RunServiceController.BindToHeartbeat("SurvivalVoiceController.Scan", scanSurroundings);

        return;
    end;

    if not v57 and u26 then
        u26:Disconnect();
        u26 = nil;
    end;
end;

local function onGamemodeChanged() -- Line: 449
    -- upvalues: IsSurvivalMode (copy), u8 (copy), SurvivalState (copy), u26 (ref), RunServiceController (copy), scanSurroundings (copy)
    if not IsSurvivalMode() then
        table.clear(u8);
    end;

    local v58 = IsSurvivalMode() and SurvivalState.GetWaveElapsed() ~= nil;

    if v58 and not u26 then
        u26 = RunServiceController.BindToHeartbeat("SurvivalVoiceController.Scan", scanSurroundings);

        return;
    end;

    if not v58 and u26 then
        u26:Disconnect();
        u26 = nil;
    end;
end;

function u1.Play(p59: string, p60: number?) -- Line: 461
    -- upvalues: u2 (copy), IsSurvivalMode (copy), u5 (ref), u9 (copy), u6 (ref), speak (copy), u8 (copy)
    local v61 = u2[p59] or 4;
    local v62 = IsSurvivalMode();

    if v62 then
        local v63 = u5;

        if v63 == nil or v63.Sounds == nil then
            v62 = false;
        else
            v62 = v63.Sounds:FindFirstChild(p59) ~= nil;
        end;

        if v62 then
            v62 = v61 <= os.clock() - (u9[p59] or (-1 / 0));
        end;
    end;

    if not v62 then
        return;
    end;

    if not u6 then
        speak(p59);

        return;
    end;

    for _, v in u8 do
        if v.Name == p59 then
            return;
        end;
    end;

    local v64 = #u8 + 1;
    local v65 = p60 or 1;

    for i, v in u8 do
        if v.Priority < v65 then
            v64 = i;
            break;
        end;
    end;

    local v66 = {
        Name = p59,
        Priority = v65,
        At = os.clock()
    };
    table.insert(u8, v64, v66);

    if #u8 > 2 then
        table.remove(u8);
    end;
end;

function u1.OnHealthKit() -- Line: 489
    -- upvalues: u19 (ref), u20 (ref), u18 (ref), u1 (copy)
    local v67;

    if os.clock() - u19 <= 0.5 and u18 < u20 then
        v67 = u18;
    else
        v67 = u20;
    end;

    u1.Play(v67 < 25 and "Health Kit Close Call" or "Health Kit");
end;

function u1.OnAmmoCrate() -- Line: 497
    -- upvalues: u1 (copy)
    u1.Play("Max Ammo");
end;

function u1.OnPurchase(p68: string, p69: boolean, p70: string?) -- Line: 502
    -- upvalues: u4 (copy), u1 (copy), u16 (ref), SurvivalState (copy), u3 (copy), u14 (ref)
    if p69 then
        if u4[p68] then
            u1.Play("Armor Bought");

            return;
        end;

        if p68 == "Ammo" then
            u1.Play("Ammo Bought");
        end;

        return;
    end;

    u16 = SurvivalState.GetWave();

    if not (p70 and (u3[p70] and not u14)) then
        u1.Play("Weapon Bought");

        return;
    end;

    u14 = true;
    u1.Play("First Big Purchase");
end;

function u1.OnReload() -- Line: 522
    -- upvalues: IsSurvivalMode (copy), SurvivalState (copy), CharacterResolver (copy), HordeController (copy), u1 (copy)
    if not IsSurvivalMode() or SurvivalState.GetWaveElapsed() == nil then
        return;
    end;

    local RootPart = CharacterResolver.getRootPart(CharacterResolver.getLocalCharacter());
    local v71;

    if RootPart then
        v71 = RootPart.Position;
    else
        v71 = nil;
    end;

    if v71 and HordeController.CountNear(v71, 18, 8) >= 2 then
        u1.Play("Reloading");
    end;
end;

function u1.Start() -- Line: 538
    -- upvalues: u5 (ref), Sound (copy), GeneratorController (copy), onGeneratorState (copy), HordeController (copy), onHitConfirmed (copy), SurvivalState (copy), onResupplyChanged (copy), onWaveStarted (copy), onWaveChanged (copy), Players (copy), SurvivalDowned (copy), recountDowned (copy), watchPlayer (copy), LocalPlayer (copy), u20 (ref), u18 (ref), onHealthChanged (copy), evaluateScanning (copy), onGamemodeChanged (copy), IsSurvivalMode (copy), u26 (ref), RunServiceController (copy), scanSurroundings (copy)
    u5 = Sound.new("ZombieSurvival");
    GeneratorController.Bind(onGeneratorState);
    HordeController.HitConfirmed:Connect(onHitConfirmed);
    workspace:GetAttributeChangedSignal(SurvivalState.RESUPPLY_ATTRIBUTE):Connect(onResupplyChanged);
    workspace:GetAttributeChangedSignal(SurvivalState.WAVE_STARTED_ATTRIBUTE):Connect(onWaveStarted);
    workspace:GetAttributeChangedSignal(SurvivalState.WAVE_ATTRIBUTE):Connect(onWaveChanged);

    for _, v in Players:GetPlayers() do
        v:GetAttributeChangedSignal(SurvivalDowned.DOWNED_ATTRIBUTE):Connect(recountDowned);
    end;

    Players.PlayerAdded:Connect(watchPlayer);
    Players.PlayerRemoving:Connect(function() -- Line: 553
        -- upvalues: recountDowned (ref)
        task.defer(recountDowned);
    end);
    local Attribute = LocalPlayer:GetAttribute("Health");

    if typeof(Attribute) == "number" then
        u20 = Attribute;
        u18 = Attribute;
    end;

    LocalPlayer:GetAttributeChangedSignal("Health"):Connect(onHealthChanged);
    workspace:GetAttributeChangedSignal(SurvivalState.WAVE_STARTED_ATTRIBUTE):Connect(evaluateScanning);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(onGamemodeChanged);
    local v72 = IsSurvivalMode() and SurvivalState.GetWaveElapsed() ~= nil;

    if v72 and not u26 then
        u26 = RunServiceController.BindToHeartbeat("SurvivalVoiceController.Scan", scanSurroundings);

        return;
    end;

    if not v72 and u26 then
        u26:Disconnect();
        u26 = nil;
    end;
end;

return u1;