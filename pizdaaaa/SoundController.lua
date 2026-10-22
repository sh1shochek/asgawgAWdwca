-- ReplicatedStorage.Controllers.SoundController
-- Script path: ReplicatedStorage.Controllers.SoundController
-- Decompile time: 14.10 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Sound = require(ReplicatedStorage.Classes.Sound);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local script_MovementSounds = require(script.MovementSounds);
local CurrentCamera = Workspace.CurrentCamera;
local u2 = {};
local u3 = { "Knife", "Bayonet", "Karambit", "Daggers" };
local u4 = {
    Headshot = 1,
    Humiliation = 2,
    MultiKill = 3,
    KillSpree = 4,
    Rampage = 5,
    Dominating = 6,
    ["Monster Kill"] = 7,
    LudicrusKill = 8,
    Unstoppable = 9,
    Godlike = 10
};
local u5 = {
    [2] = "MultiKill",
    [3] = "KillSpree",
    [4] = "Rampage",
    [5] = "Dominating",
    [6] = "Monster Kill",
    [7] = "LudicrusKill",
    [8] = "Unstoppable",
    [9] = "Godlike"
};
local u6 = 0;
local u7 = nil;
local u8 = 0;
local u9 = nil;

local function isMenuOpen() -- Line: 99
    -- upvalues: MenuState (copy)
    return MenuState.GetCurrentScreen() ~= nil;
end;

local function isKnifeWeapon(p10: string) -- Line: 103
    -- upvalues: u3 (copy)
    for _, v in ipairs(u3) do
        if string.find(p10, v) then
            return true;
        end;
    end;

    return false;
end;

local function getSliderMultiplier(p11: string) -- Line: 112
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return (DataController.Get(LocalPlayer, p11) or 50) / 50;
end;

local function getMasterMultiplier() -- Line: 116
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
end;

local function storeBaseVolume(p12: userdata, p13: number) -- Line: 121
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v14 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
    local Volume = p12.Volume;

    if p13 > 0 and v14 > 0 then
        Volume = Volume / (p13 * v14) or Volume;
    end;

    p12:SetAttribute("BaseVolume", Volume);

    return Volume;
end;

local function listenWhileAlive(p15: userdata, u16: string, p17: function) -- Line: 132
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local u18 = DataController.CreateListener(LocalPlayer, u16, p17);
    local u19 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", p17);
    p15.Destroying:Once(function() -- Line: 135
        -- upvalues: DataController (ref), LocalPlayer (ref), u16 (copy), u18 (copy), u19 (copy)
        DataController.RemoveListener(LocalPlayer, u16, u18);
        DataController.RemoveListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", u19);
    end);
end;

local function stopCurrentAccolade() -- Line: 141
    -- upvalues: u7 (ref), u8 (ref)
    if u7 then
        local v20 = u7;
        u7 = nil;
        u8 = 0;

        if v20.Parent then
            v20:Stop();
            v20:Destroy();
        end;
    end;
end;

local function pickAccolade(p21) -- Line: 153
    -- upvalues: u5 (copy), u6 (ref), u4 (copy), isKnifeWeapon (copy)
    local v22 = u5[math.min(u6, 9)];
    local v23 = v22 and (u4[v22] or 0) or 0;

    if p21.Headshot and v23 < 1 then
        v23 = 1;
        v22 = "Headshot";
    end;

    if p21.Weapon and (isKnifeWeapon(p21.Weapon) and v23 < 2) then
        v22 = "Humiliation";
        v23 = 2;
    end;

    return v22, v23;
end;

local function stopBombPlantedMusic() -- Line: 166
    -- upvalues: u9 (ref)
    if u9 then
        if u9.Parent then
            u9:Stop();
            u9:Destroy();
        end;

        u9 = nil;
    end;
end;

local function updateBombPlantedMusicVolume(p24: number?) -- Line: 176
    -- upvalues: u9 (ref), DataController (copy), LocalPlayer (copy)
    if u9 and u9.Parent then
        local v25 = (tonumber(p24) or 50) / 50;
        local v26 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        local v27 = (tonumber(v26) or 100) / 100;
        local Attribute = u9:GetAttribute("BaseVolume");

        if typeof(Attribute) ~= "number" then
            Attribute = u9.Volume;
        end;

        u9.Volume = Attribute * v25 * v27;
    end;
end;

local function GetRollOffDistance(p28: any, p29: number) -- Line: 190
    if p28 and p28.Properties then
        p29 = p28.Properties.RollOffMaxDistance or p29;
    end;

    return p29;
end;

local function GetWeaponAudio(p30: string) -- Line: 194
    -- upvalues: u2 (copy), ReplicatedStorage (copy)
    if u2[p30] then
        return u2[p30];
    end;

    local v31 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p30);

    if v31 then
        local success, result = pcall(require, v31);

        if success and result then
            u2[p30] = result;

            return result;
        end;
    end;

    return nil;
end;

v1.SetBombPlantedMusicVolume = updateBombPlantedMusicVolume;

function v1.GetWeaponShootRange(p32: string, p33: boolean?) -- Line: 216
    -- upvalues: u2 (copy), ReplicatedStorage (copy)
    local v34;

    if u2[p32] then
        v34 = u2[p32];
    else
        local v35 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p32);

        if v35 then
            local v36;
            v36, v34 = pcall(require, v35);

            if v36 and v34 then
                u2[p32] = v34;
            else
                v34 = nil;
            end;
        else
            v34 = nil;
        end;
    end;

    if not v34 then
        return p33 and 50 or 120;
    end;

    if p33 and v34.Silencer then
        local Silencer = v34.Silencer;

        return Silencer and (Silencer.Properties and Silencer.Properties.RollOffMaxDistance) or 50;
    end;

    local Shoot = v34.Shoot;

    return Shoot and (Shoot.Properties and Shoot.Properties.RollOffMaxDistance) or 120;
end;

function v1.GetMeleeRange(p37: string) -- Line: 229
    -- upvalues: u2 (copy), ReplicatedStorage (copy)
    local v38;

    if u2[p37] then
        v38 = u2[p37];
    else
        local v39 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p37);

        if v39 then
            local v40;
            v40, v38 = pcall(require, v39);

            if v40 and v38 then
                u2[p37] = v38;
            else
                v38 = nil;
            end;
        else
            v38 = nil;
        end;
    end;

    if not v38 then
        return 50;
    end;

    local HitOne = v38.HitOne;

    return HitOne and (HitOne.Properties and HitOne.Properties.RollOffMaxDistance) or 50;
end;

function v1.Initialize() -- Line: 240
    -- upvalues: ReplicatedStorage (copy), Sound (copy), Router (copy), MenuState (copy), CurrentCamera (copy), DataController (copy), LocalPlayer (copy), RunServiceController (copy), GameState (copy), IsSurvivalMode (copy), listenWhileAlive (copy), Remotes (copy), FlashEffect (copy), DebugFlags (copy), u9 (ref), CharacterResolver (copy), updateBombPlantedMusicVolume (copy), CollectionService (copy), u6 (ref), u7 (ref), u8 (ref), u5 (copy), u4 (copy), isKnifeWeapon (copy)
    for _, descendant in ipairs(ReplicatedStorage.Database.Audio:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            Sound.createSoundGroup(descendant);
        end;
    end;

    task.spawn(Sound.WarmPersistentSounds);
    Router.observerRouter("RunRoundSound", function(p41: string) -- Line: 251
        -- upvalues: MenuState (ref), Sound (ref), CurrentCamera (ref)
        if MenuState.GetCurrentScreen() == nil then
            return Sound.new("Round"):playOneTime({
                Parent = CurrentCamera,
                Name = p41
            });
        end;
    end);
    Router.observerRouter("PlayCountdownTimer", function() -- Line: 262
        -- upvalues: DataController (ref), LocalPlayer (ref), MenuState (ref), Sound (ref)
        local v42 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Main Menu Volume") or 100) / 100;

        if MenuState.GetCurrentScreen() == nil and v42 > 0 then
            Sound.new("Interface"):playOneTime({
                Name = "Countdown Timer",
                Parent = LocalPlayer.PlayerGui
            }, v42);
        end;

        return nil;
    end);
    local u43 = nil;
    local u44 = nil;
    local u45 = nil;

    local function getBuyPhaseFadeMultiplier(p46: number) -- Line: 278
        return p46 < 6 and 1 or math.max(0, 1 - (p46 - 6) * 0.2);
    end;

    local function disconnectBuyPhaseFade() -- Line: 285
        -- upvalues: u44 (ref)
        if u44 then
            u44:Disconnect();
            u44 = nil;
        end;
    end;

    local function stopBuyPhaseSound() -- Line: 292
        -- upvalues: u43 (ref), u44 (ref), u45 (ref)
        if u43 then
            if u44 then
                u44:Disconnect();
                u44 = nil;
            end;

            if u43.Parent then
                u43:Stop();
                u43:Destroy();
            end;

            u43 = nil;
            u45 = nil;
        end;
    end;

    local function updateBuyPhaseVolume(p47: boolean?) -- Line: 304
        -- upvalues: u43 (ref), DataController (ref), LocalPlayer (ref), u45 (ref), u44 (ref)
        if not (u43 and u43.Parent) then
            return;
        end;

        local v48 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50;
        local v49 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
        local v50 = u43:GetAttribute("BaseVolume") or u43.Volume;
        local v51;

        if p47 and u45 then
            local v52 = tick() - u45;
            v51 = v52 < 6 and 1 or math.max(0, 1 - (v52 - 6) * 0.2);
        else
            v51 = 1;
        end;

        u43.Volume = v50 * v48 * v49 * v51;

        if p47 and u45 then
            local v53 = tick() - u45;

            if (v53 < 6 and 1 or math.max(0, 1 - (v53 - 6) * 0.2)) <= 0 and u43 then
                if u44 then
                    u44:Disconnect();
                    u44 = nil;
                end;

                if u43.Parent then
                    u43:Stop();
                    u43:Destroy();
                end;

                u43 = nil;
                u45 = nil;
            end;
        end;
    end;

    local function playBuyPhaseSound() -- Line: 323
        -- upvalues: LocalPlayer (ref), u43 (ref), u44 (ref), u45 (ref), DataController (ref), Sound (ref), CurrentCamera (ref), RunServiceController (ref), updateBuyPhaseVolume (copy)
        local Attribute = LocalPlayer:GetAttribute("Team");

        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            return;
        end;

        if u43 then
            if u44 then
                u44:Disconnect();
                u44 = nil;
            end;

            if u43.Parent then
                u43:Stop();
                u43:Destroy();
            end;

            u43 = nil;
            u45 = nil;
        end;

        local v54 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50;
        u43 = Sound.new("Round"):play({
            Name = "Buy Phase",
            Parent = CurrentCamera
        }, v54);

        if not u43 then
            return;
        end;

        local u55 = u43;
        u55.Destroying:Once(function() -- Line: 344
            -- upvalues: u43 (ref), u55 (copy), u45 (ref)
            if u43 == u55 then
                u43 = nil;
                u45 = nil;
            end;
        end);
        local v56 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
        local Volume = u55.Volume;

        if v54 > 0 and v56 > 0 then
            Volume = Volume / (v54 * v56) or Volume;
        end;

        u55:SetAttribute("BaseVolume", Volume);
        u45 = tick();
        task.spawn(function() -- Line: 354
            -- upvalues: u44 (ref), RunServiceController (ref), u43 (ref), u45 (ref), updateBuyPhaseVolume (ref)
            u44 = RunServiceController.BindToHeartbeat("SoundController.BuyPhaseFade", function() -- Line: 355
                -- upvalues: u43 (ref), u44 (ref), u45 (ref), updateBuyPhaseVolume (ref)
                if not (u43 and u43.Parent) then
                    if u44 then
                        u44:Disconnect();
                        u44 = nil;
                    end;

                    return;
                end;

                if not u45 then
                    return;
                end;

                local v57 = tick() - u45;
                local v58 = v57 >= 6;
                updateBuyPhaseVolume(v58);

                if v58 and (not (u43 and u43.Parent) or (v57 < 6 and 1 or math.max(0, 1 - (v57 - 6) * 0.2)) <= 0) and u44 then
                    u44:Disconnect();
                    u44 = nil;
                end;
            end);
        end);
    end;

    GameState.ListenToState(function(p59, p60) -- Line: 379
        -- upvalues: playBuyPhaseSound (copy), u43 (ref), u44 (ref), u45 (ref)
        if p60 == "Buy Period" then
            playBuyPhaseSound();

            return;
        end;

        if u43 then
            if u44 then
                u44:Disconnect();
                u44 = nil;
            end;

            if u43.Parent then
                u43:Stop();
                u43:Destroy();
            end;

            u43 = nil;
            u45 = nil;
        end;
    end);
    local u61 = nil;

    local function stopSurvivalMusic() -- Line: 391
        -- upvalues: u61 (ref)
        if u61 then
            if u61.Parent then
                u61:Stop();
                u61:Destroy();
            end;

            u61 = nil;
        end;
    end;

    local function updateSurvivalMusicVolume() -- Line: 402
        -- upvalues: u61 (ref), DataController (ref), LocalPlayer (ref)
        local v62 = u61;

        if v62 and v62.Parent then
            local Attribute = v62:GetAttribute("BaseVolume");

            if typeof(Attribute) ~= "number" then
                Attribute = v62.Volume;
            end;

            v62.Volume = Attribute * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Action Volume") or 50) / 50) * ((DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100);
        end;
    end;

    local function shouldPlaySurvivalMusic() -- Line: 411
        -- upvalues: IsSurvivalMode (ref), LocalPlayer (ref), GameState (ref)
        if not IsSurvivalMode() then
            return false;
        end;

        local Attribute = LocalPlayer:GetAttribute("Team");

        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            return false;
        end;

        local State = GameState.GetState();

        return State == "Round In Progress" and true or State == "Buy Period";
    end;

    local function syncSurvivalMusic() -- Line: 423
        -- upvalues: IsSurvivalMode (ref), LocalPlayer (ref), GameState (ref), u61 (ref), Sound (ref), CurrentCamera (ref), DataController (ref), listenWhileAlive (ref), updateSurvivalMusicVolume (copy)
        local v63;

        if IsSurvivalMode() then
            local Attribute = LocalPlayer:GetAttribute("Team");

            if Attribute == "Counter-Terrorists" or Attribute == "Terrorists" then
                local State = GameState.GetState();
                v63 = State == "Round In Progress" and true or State == "Buy Period";
            else
                v63 = false;
            end;
        else
            v63 = false;
        end;

        if not v63 then
            if u61 then
                if u61.Parent then
                    u61:Stop();
                    u61:Destroy();
                end;

                u61 = nil;
            end;

            return;
        end;

        if u61 and u61.Parent then
            return;
        end;

        local v64 = Sound.new("Survival"):play({
            Name = "Music",
            Parent = CurrentCamera
        }, (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Action Volume") or 50) / 50);
        u61 = v64;

        if v64 then
            listenWhileAlive(v64, "Settings.Audio.Music.Round Action Volume", updateSurvivalMusicVolume);
        end;
    end;

    GameState.ListenToState(function() -- Line: 442
        -- upvalues: syncSurvivalMusic (copy)
        syncSurvivalMusic();
    end);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(syncSurvivalMusic);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(syncSurvivalMusic);
    syncSurvivalMusic();

    local function onBuyPhaseSettingChanged() -- Line: 449
        -- upvalues: updateBuyPhaseVolume (copy), u44 (ref)
        updateBuyPhaseVolume(u44 ~= nil);
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Round Start Volume", onBuyPhaseSettingChanged);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", onBuyPhaseSettingChanged);
    Remotes.Sound.ReplicateSound.Listen(function(p65) -- Line: 455
        -- upvalues: FlashEffect (ref), DebugFlags (ref), u9 (ref), Sound (ref), CharacterResolver (ref), LocalPlayer (ref), MenuState (ref), GameState (ref), DataController (ref), listenWhileAlive (ref), updateBombPlantedMusicVolume (ref)
        local AudioFadeMultiplier = FlashEffect.GetAudioFadeMultiplier();

        if DebugFlags.IsEnabled("WeaponFX") then
            local v66 = p65 and p65.Name and (tostring(p65.Name) or "") or "";
            local v67 = p65 and p65.Class and (tostring(p65.Class) or "") or "";
            local string_lower_ret = string.lower(v66);

            if string.find(string_lower_ret, "shoot", 1, true) or string.find(string_lower_ret, "fire", 1, true) then
                local v68 = warn;
                local v69 = tostring(FlashEffect.IsFlashed());
                local v70;

                if p65 then
                    v70 = p65.Parent;
                else
                    v70 = p65;
                end;

                local v71 = tostring(v70);
                local v72;

                if p65 then
                    v72 = p65.Position;
                else
                    v72 = p65;
                end;

                local v73 = tostring(v72);
                local v74;

                if p65 then
                    v74 = p65.Path;
                else
                    v74 = p65;
                end;

                v68(("[WeaponFX][Client][Sound] recv class=%s name=%s flashed=%s parent=%s position=%s path=%s"):format(v67, v66, v69, v71, v73, (tostring(v74))));
            end;
        end;

        local v75;

        if p65.Name == "Bomb Planted Music" then
            v75 = p65.Class == "Counter-Terrorists";
        else
            v75 = false;
        end;

        if v75 and u9 then
            if u9.Parent then
                u9:Stop();
                u9:Destroy();
            end;

            u9 = nil;
        end;

        if p65.Position then
            Sound.new(p65.Class):PlaySoundAtPosition({
                Position = p65.Position,
                Class = p65.Class,
                Name = p65.Name
            }, tonumber(p65.Duration), AudioFadeMultiplier);

            return;
        end;

        if not (p65.Parent or p65.Path) then
            return;
        end;

        local Parent = p65.Parent;

        if Parent and (Parent:IsA("BasePart") and Parent.Name == "Head") then
            local Parent2 = Parent.Parent;

            if Parent2 and (Parent2:IsA("Model") and (Parent2:IsDescendantOf(workspace) and CharacterResolver.getPlayerFromCharacter(Parent2) == LocalPlayer)) then
                if DebugFlags.IsEnabled("WeaponFX") then
                    warn(("[WeaponFX][Client][Sound] skipped local duplicate head sound name=%s class=%s"):format(tostring(p65.Name), (tostring(p65.Class))));
                end;

                return;
            end;
        end;

        if (p65.Name == "Bomb Planted" or (p65.Name == "Bomb Defused" or p65.Name == "Hostage Rescued")) and MenuState.GetCurrentScreen() ~= nil then
            return;
        end;

        local v76;

        if p65.Name == "Counter-Terrorists Win" or p65.Name == "Terrorists Win" then
            v76 = p65.Class == "Round";
        else
            v76 = false;
        end;

        if v75 then
            if GameState.GetState() ~= "Round In Progress" or MenuState.GetCurrentScreen() ~= nil then
                return;
            end;

            AudioFadeMultiplier = AudioFadeMultiplier * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50);
        elseif v76 then
            if MenuState.GetCurrentScreen() ~= nil then
                return;
            end;

            AudioFadeMultiplier = AudioFadeMultiplier * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50);
        end;

        local u77 = Sound.new(p65.Class):playOneTime({
            Parent = p65.Parent,
            Name = p65.Name,
            Path = p65.Path
        }, AudioFadeMultiplier);

        if not u77 then
            return;
        end;

        if not v76 then
            if v75 then
                u9 = u77;
                local v78 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50;
                local v79 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                local Volume = u77.Volume;

                if v78 > 0 and v79 > 0 then
                    Volume = Volume / (v78 * v79) or Volume;
                end;

                u77:SetAttribute("BaseVolume", Volume);
                listenWhileAlive(u77, "Settings.Audio.Music.Bomb/Hostage Volume", function() -- Line: 565
                    -- upvalues: u9 (ref), updateBombPlantedMusicVolume (ref), DataController (ref), LocalPlayer (ref)
                    if u9 and u9.Parent then
                        updateBombPlantedMusicVolume(DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50);
                    end;
                end);
            end;

            return;
        end;

        local v80 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50;
        local v81 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
        local Volume = u77.Volume;

        if v80 > 0 and v81 > 0 then
            Volume = Volume / (v80 * v81) or Volume;
        end;

        u77:SetAttribute("BaseVolume", Volume);
        listenWhileAlive(u77, "Settings.Audio.Music.Round End Volume", function() -- Line: 554
            -- upvalues: u77 (copy), DataController (ref), LocalPlayer (ref), Volume (copy)
            if u77 and u77.Parent then
                local v82 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50;
                local v83 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                u77.Volume = (u77:GetAttribute("BaseVolume") or Volume) * v82 * v83;
            end;
        end);
    end);

    local function setupBombDefuseListener() -- Line: 574
        -- upvalues: CollectionService (ref), u9 (ref)
        local u84 = CollectionService:GetTagged("Bomb")[1];

        if u84 and u84:IsDescendantOf(workspace) then
            local u85 = nil;
            u85 = u84:GetAttributeChangedSignal("Defused"):Connect(function() -- Line: 578
                -- upvalues: u84 (copy), u9 (ref), u85 (ref)
                if u84:GetAttribute("Defused") then
                    if u9 then
                        if u9.Parent then
                            u9:Stop();
                            u9:Destroy();
                        end;

                        u9 = nil;
                    end;

                    if u85 then
                        u85:Disconnect();
                    end;
                end;
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(function() -- Line: 589
        -- upvalues: setupBombDefuseListener (copy)
        setupBombDefuseListener();
    end);
    task.defer(setupBombDefuseListener);
    GameState.ListenToState(function(p86, p87) -- Line: 594
        -- upvalues: u9 (ref)
        if p87 ~= "Round In Progress" and u9 then
            if u9.Parent then
                u9:Stop();
                u9:Destroy();
            end;

            u9 = nil;
        end;
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p88) -- Line: 601
        -- upvalues: LocalPlayer (ref), u6 (ref), u7 (ref), u8 (ref), u5 (ref), u4 (ref), isKnifeWeapon (ref), Sound (ref)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            return;
        end;

        local v89 = tostring(LocalPlayer.UserId);

        if p88.Victim == v89 then
            u6 = 0;

            if u7 then
                local v90 = u7;
                u7 = nil;
                u8 = 0;

                if v90.Parent then
                    v90:Stop();
                    v90:Destroy();
                end;
            end;

            return;
        end;

        if p88.Killer ~= v89 then
            return;
        end;

        u6 = u6 + 1;
        local u91 = u5[math.min(u6, 9)];
        local u92 = u91 and (u4[u91] or 0) or 0;

        if p88.Headshot and u92 < u4.Headshot then
            u92 = u4.Headshot;
            u91 = "Headshot";
        end;

        if p88.Weapon and (isKnifeWeapon(p88.Weapon) and u92 < u4.Humiliation) then
            u92 = u4.Humiliation;
            u91 = "Humiliation";
        end;

        if not u91 or u92 < u8 then
            return;
        end;

        if u7 then
            local v93 = u7;
            u7 = nil;
            u8 = 0;

            if v93.Parent then
                v93:Stop();
                v93:Destroy();
            end;
        end;

        task.delay(0.2, function() -- Line: 623
            -- upvalues: u92 (copy), u8 (ref), u7 (ref), Sound (ref), LocalPlayer (ref), u91 (copy)
            if u92 < u8 then
                return;
            end;

            if u7 then
                local v94 = u7;
                u7 = nil;
                u8 = 0;

                if v94.Parent then
                    v94:Stop();
                    v94:Destroy();
                end;
            end;

            local u95 = Sound.new("Deathmatch"):play({
                Parent = LocalPlayer.PlayerGui,
                Name = u91
            });

            if u95 then
                u7 = u95;
                u8 = u92;

                local function clearIfCurrent() -- Line: 636
                    -- upvalues: u7 (ref), u95 (copy), u8 (ref)
                    if u7 == u95 then
                        u7 = nil;
                        u8 = 0;
                    end;
                end;

                u95.Ended:Once(clearIfCurrent);
                u95.Destroying:Once(clearIfCurrent);
            end;
        end);
    end);
    Remotes.Sound.StopSoundAtPosition.Listen(function(p96) -- Line: 649
        local Debris = workspace:FindFirstChild("Debris");

        if not Debris then
            return;
        end;

        for _, child in ipairs(Debris:GetChildren()) do
            if child.Name == "Sound" and (child:IsA("BasePart") and (child.Position - p96.Position).Magnitude <= p96.Radius) then
                child:Destroy();
            end;
        end;
    end);
    Router.observerRouter("UpdatePlayerNoiseCone", function() -- Line: 667
        return nil;
    end);
end;

function v1.Start() -- Line: 674
    -- upvalues: script_MovementSounds (copy), LocalPlayer (copy), CharacterResolver (copy), u6 (ref), u7 (ref), u8 (ref), ReplicatedStorage (copy), Sound (copy), RunServiceController (copy)
    local u97 = script_MovementSounds.new(LocalPlayer);
    CharacterResolver.observeCharacter(LocalPlayer, function(p98: userdata?) -- Line: 676
        -- upvalues: u6 (ref), u7 (ref), u8 (ref), u97 (copy)
        if p98 then
            u6 = 0;

            if u7 then
                local v99 = u7;
                u7 = nil;
                u8 = 0;

                if v99.Parent then
                    v99:Stop();
                    v99:Destroy();
                end;
            end;
        end;

        u97:SetCharacter(p98);

        return function() -- Line: 682
            -- upvalues: u97 (ref)
            u97:SetCharacter(nil);
        end;
    end);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    local u100 = {
        MenuSceneController,
        {
            IsActive = MenuSceneController.IsTeamSelectSceneActive
        },
        require(ReplicatedStorage.Controllers.CaseSceneController),
        require(ReplicatedStorage.Controllers.InspectController),
        (require(ReplicatedStorage.Controllers.BlackMarketSceneController))
    };
    local GameplaySoundGroup = Sound.GameplaySoundGroup;
    local u101 = false;

    local function isAnySceneActive() -- Line: 699
        -- upvalues: u100 (copy)
        for _, v in u100 do
            if v.IsActive() then
                return true;
            end;
        end;

        return false;
    end;

    RunServiceController.BindToHeartbeat("SoundController.MovementSounds", function(p102: number) -- Line: 708
        -- upvalues: u97 (copy), u100 (copy), u101 (ref), GameplaySoundGroup (copy)
        u97:Update(p102);
        local v103 = false;

        for _, v in u100 do
            if v.IsActive() then
                v103 = true;
                break;
            end;
        end;

        if v103 ~= u101 then
            u101 = v103;
            GameplaySoundGroup.Volume = v103 and 0 or 1;
        end;
    end);
end;

return v1;