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

local function isMenuOpen() -- Line: 97
    -- upvalues: MenuState (copy)
    return MenuState.GetCurrentScreen() ~= nil;
end;

local function isKnifeWeapon(p10: string) -- Line: 101
    -- upvalues: u3 (copy)
    for _, v in ipairs(u3) do
        if string.find(p10, v) then
            return true;
        end;
    end;

    return false;
end;

local function getSliderMultiplier(p11: string) -- Line: 110
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return (DataController.Get(LocalPlayer, p11) or 50) / 50;
end;

local function getMasterMultiplier() -- Line: 114
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
end;

local function storeBaseVolume(p12: userdata, p13: number) -- Line: 119
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v14 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
    local Volume = p12.Volume;

    if p13 > 0 and v14 > 0 then
        Volume = Volume / (p13 * v14) or Volume;
    end;

    p12:SetAttribute("BaseVolume", Volume);

    return Volume;
end;

local function listenWhileAlive(p15: userdata, u16: string, p17: function) -- Line: 130
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local u18 = DataController.CreateListener(LocalPlayer, u16, p17);
    local u19 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", p17);
    p15.Destroying:Once(function() -- Line: 133
        -- upvalues: DataController (ref), LocalPlayer (ref), u16 (copy), u18 (copy), u19 (copy)
        DataController.RemoveListener(LocalPlayer, u16, u18);
        DataController.RemoveListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", u19);
    end);
end;

local function stopCurrentAccolade() -- Line: 139
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

local function pickAccolade(p21) -- Line: 151
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

local function stopBombPlantedMusic() -- Line: 164
    -- upvalues: u9 (ref)
    if u9 then
        if u9.Parent then
            u9:Stop();
            u9:Destroy();
        end;

        u9 = nil;
    end;
end;

local function updateBombPlantedMusicVolume(p24: number?) -- Line: 174
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

local function GetRollOffDistance(p28: any, p29: number) -- Line: 188
    if p28 and p28.Properties then
        p29 = p28.Properties.RollOffMaxDistance or p29;
    end;

    return p29;
end;

local function GetWeaponAudio(p30: string) -- Line: 192
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

function v1.GetWeaponShootRange(p32: string, p33: boolean?) -- Line: 214
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

function v1.GetMeleeRange(p37: string) -- Line: 227
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

function v1.Initialize() -- Line: 238
    -- upvalues: ReplicatedStorage (copy), Sound (copy), Router (copy), MenuState (copy), CurrentCamera (copy), DataController (copy), LocalPlayer (copy), RunServiceController (copy), GameState (copy), Remotes (copy), FlashEffect (copy), DebugFlags (copy), u9 (ref), CharacterResolver (copy), listenWhileAlive (copy), updateBombPlantedMusicVolume (copy), CollectionService (copy), u6 (ref), u7 (ref), u8 (ref), u5 (copy), u4 (copy), isKnifeWeapon (copy)
    for _, descendant in ipairs(ReplicatedStorage.Database.Audio:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            Sound.createSoundGroup(descendant);
        end;
    end;

    task.spawn(Sound.WarmPersistentSounds);
    Router.observerRouter("RunRoundSound", function(p41: string) -- Line: 249
        -- upvalues: MenuState (ref), Sound (ref), CurrentCamera (ref)
        if MenuState.GetCurrentScreen() == nil then
            return Sound.new("Round"):playOneTime({
                Parent = CurrentCamera,
                Name = p41
            });
        end;
    end);
    Router.observerRouter("PlayCountdownTimer", function() -- Line: 260
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

    local function getBuyPhaseFadeMultiplier(p46: number) -- Line: 276
        return p46 < 6 and 1 or math.max(0, 1 - (p46 - 6) * 0.2);
    end;

    local function disconnectBuyPhaseFade() -- Line: 283
        -- upvalues: u44 (ref)
        if u44 then
            u44:Disconnect();
            u44 = nil;
        end;
    end;

    local function stopBuyPhaseSound() -- Line: 290
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

    local function updateBuyPhaseVolume(p47: boolean?) -- Line: 302
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

    local function playBuyPhaseSound() -- Line: 321
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
        u55.Destroying:Once(function() -- Line: 342
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
        task.spawn(function() -- Line: 352
            -- upvalues: u44 (ref), RunServiceController (ref), u43 (ref), u45 (ref), updateBuyPhaseVolume (ref)
            u44 = RunServiceController.BindToHeartbeat("SoundController.BuyPhaseFade", function() -- Line: 353
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

    GameState.ListenToState(function(p59, p60) -- Line: 377
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

    local function onBuyPhaseSettingChanged() -- Line: 385
        -- upvalues: updateBuyPhaseVolume (copy), u44 (ref)
        updateBuyPhaseVolume(u44 ~= nil);
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Round Start Volume", onBuyPhaseSettingChanged);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", onBuyPhaseSettingChanged);
    Remotes.Sound.ReplicateSound.Listen(function(p61) -- Line: 391
        -- upvalues: FlashEffect (ref), DebugFlags (ref), u9 (ref), Sound (ref), CharacterResolver (ref), LocalPlayer (ref), MenuState (ref), GameState (ref), DataController (ref), listenWhileAlive (ref), updateBombPlantedMusicVolume (ref)
        local AudioFadeMultiplier = FlashEffect.GetAudioFadeMultiplier();

        if DebugFlags.IsEnabled("WeaponFX") then
            local v62 = p61 and p61.Name and (tostring(p61.Name) or "") or "";
            local v63 = p61 and p61.Class and (tostring(p61.Class) or "") or "";
            local string_lower_ret = string.lower(v62);

            if string.find(string_lower_ret, "shoot", 1, true) or string.find(string_lower_ret, "fire", 1, true) then
                local v64 = warn;
                local v65 = tostring(FlashEffect.IsFlashed());
                local v66;

                if p61 then
                    v66 = p61.Parent;
                else
                    v66 = p61;
                end;

                local v67 = tostring(v66);
                local v68;

                if p61 then
                    v68 = p61.Position;
                else
                    v68 = p61;
                end;

                local v69 = tostring(v68);
                local v70;

                if p61 then
                    v70 = p61.Path;
                else
                    v70 = p61;
                end;

                v64(("[WeaponFX][Client][Sound] recv class=%s name=%s flashed=%s parent=%s position=%s path=%s"):format(v63, v62, v65, v67, v69, (tostring(v70))));
            end;
        end;

        local v71;

        if p61.Name == "Bomb Planted Music" then
            v71 = p61.Class == "Counter-Terrorists";
        else
            v71 = false;
        end;

        if v71 and u9 then
            if u9.Parent then
                u9:Stop();
                u9:Destroy();
            end;

            u9 = nil;
        end;

        if p61.Position then
            Sound.new(p61.Class):PlaySoundAtPosition({
                Position = p61.Position,
                Class = p61.Class,
                Name = p61.Name
            }, tonumber(p61.Duration), AudioFadeMultiplier);

            return;
        end;

        if not (p61.Parent or p61.Path) then
            return;
        end;

        local Parent = p61.Parent;

        if Parent and (Parent:IsA("BasePart") and Parent.Name == "Head") then
            local Parent2 = Parent.Parent;

            if Parent2 and (Parent2:IsA("Model") and (Parent2:IsDescendantOf(workspace) and CharacterResolver.getPlayerFromCharacter(Parent2) == LocalPlayer)) then
                if DebugFlags.IsEnabled("WeaponFX") then
                    warn(("[WeaponFX][Client][Sound] skipped local duplicate head sound name=%s class=%s"):format(tostring(p61.Name), (tostring(p61.Class))));
                end;

                return;
            end;
        end;

        if (p61.Name == "Bomb Planted" or (p61.Name == "Bomb Defused" or p61.Name == "Hostage Rescued")) and MenuState.GetCurrentScreen() ~= nil then
            return;
        end;

        local v72;

        if p61.Name == "Counter-Terrorists Win" or p61.Name == "Terrorists Win" then
            v72 = p61.Class == "Round";
        else
            v72 = false;
        end;

        if v71 then
            if GameState.GetState() ~= "Round In Progress" or MenuState.GetCurrentScreen() ~= nil then
                return;
            end;

            AudioFadeMultiplier = AudioFadeMultiplier * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50);
        elseif v72 then
            if MenuState.GetCurrentScreen() ~= nil then
                return;
            end;

            AudioFadeMultiplier = AudioFadeMultiplier * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50);
        end;

        local u73 = Sound.new(p61.Class):playOneTime({
            Parent = p61.Parent,
            Name = p61.Name,
            Path = p61.Path
        }, AudioFadeMultiplier);

        if not u73 then
            return;
        end;

        if not v72 then
            if v71 then
                u9 = u73;
                local v74 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50;
                local v75 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                local Volume = u73.Volume;

                if v74 > 0 and v75 > 0 then
                    Volume = Volume / (v74 * v75) or Volume;
                end;

                u73:SetAttribute("BaseVolume", Volume);
                listenWhileAlive(u73, "Settings.Audio.Music.Bomb/Hostage Volume", function() -- Line: 501
                    -- upvalues: u9 (ref), updateBombPlantedMusicVolume (ref), DataController (ref), LocalPlayer (ref)
                    if u9 and u9.Parent then
                        updateBombPlantedMusicVolume(DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50);
                    end;
                end);
            end;

            return;
        end;

        local v76 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50;
        local v77 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
        local Volume = u73.Volume;

        if v76 > 0 and v77 > 0 then
            Volume = Volume / (v76 * v77) or Volume;
        end;

        u73:SetAttribute("BaseVolume", Volume);
        listenWhileAlive(u73, "Settings.Audio.Music.Round End Volume", function() -- Line: 490
            -- upvalues: u73 (copy), DataController (ref), LocalPlayer (ref), Volume (copy)
            if u73 and u73.Parent then
                local v78 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50;
                local v79 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                u73.Volume = (u73:GetAttribute("BaseVolume") or Volume) * v78 * v79;
            end;
        end);
    end);

    local function setupBombDefuseListener() -- Line: 510
        -- upvalues: CollectionService (ref), u9 (ref)
        local u80 = CollectionService:GetTagged("Bomb")[1];

        if u80 and u80:IsDescendantOf(workspace) then
            local u81 = nil;
            u81 = u80:GetAttributeChangedSignal("Defused"):Connect(function() -- Line: 514
                -- upvalues: u80 (copy), u9 (ref), u81 (ref)
                if u80:GetAttribute("Defused") then
                    if u9 then
                        if u9.Parent then
                            u9:Stop();
                            u9:Destroy();
                        end;

                        u9 = nil;
                    end;

                    if u81 then
                        u81:Disconnect();
                    end;
                end;
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(function() -- Line: 525
        -- upvalues: setupBombDefuseListener (copy)
        setupBombDefuseListener();
    end);
    task.defer(setupBombDefuseListener);
    GameState.ListenToState(function(p82, p83) -- Line: 530
        -- upvalues: u9 (ref)
        if p83 ~= "Round In Progress" and u9 then
            if u9.Parent then
                u9:Stop();
                u9:Destroy();
            end;

            u9 = nil;
        end;
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p84) -- Line: 537
        -- upvalues: LocalPlayer (ref), u6 (ref), u7 (ref), u8 (ref), u5 (ref), u4 (ref), isKnifeWeapon (ref), Sound (ref)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            return;
        end;

        local v85 = tostring(LocalPlayer.UserId);

        if p84.Victim == v85 then
            u6 = 0;

            if u7 then
                local v86 = u7;
                u7 = nil;
                u8 = 0;

                if v86.Parent then
                    v86:Stop();
                    v86:Destroy();
                end;
            end;

            return;
        end;

        if p84.Killer ~= v85 then
            return;
        end;

        u6 = u6 + 1;
        local u87 = u5[math.min(u6, 9)];
        local u88 = u87 and (u4[u87] or 0) or 0;

        if p84.Headshot and u88 < u4.Headshot then
            u88 = u4.Headshot;
            u87 = "Headshot";
        end;

        if p84.Weapon and (isKnifeWeapon(p84.Weapon) and u88 < u4.Humiliation) then
            u88 = u4.Humiliation;
            u87 = "Humiliation";
        end;

        if not u87 or u88 < u8 then
            return;
        end;

        if u7 then
            local v89 = u7;
            u7 = nil;
            u8 = 0;

            if v89.Parent then
                v89:Stop();
                v89:Destroy();
            end;
        end;

        task.delay(0.2, function() -- Line: 559
            -- upvalues: u88 (copy), u8 (ref), u7 (ref), Sound (ref), LocalPlayer (ref), u87 (copy)
            if u88 < u8 then
                return;
            end;

            if u7 then
                local v90 = u7;
                u7 = nil;
                u8 = 0;

                if v90.Parent then
                    v90:Stop();
                    v90:Destroy();
                end;
            end;

            local u91 = Sound.new("Deathmatch"):play({
                Parent = LocalPlayer.PlayerGui,
                Name = u87
            });

            if u91 then
                u7 = u91;
                u8 = u88;

                local function clearIfCurrent() -- Line: 572
                    -- upvalues: u7 (ref), u91 (copy), u8 (ref)
                    if u7 == u91 then
                        u7 = nil;
                        u8 = 0;
                    end;
                end;

                u91.Ended:Once(clearIfCurrent);
                u91.Destroying:Once(clearIfCurrent);
            end;
        end);
    end);
    Remotes.Sound.StopSoundAtPosition.Listen(function(p92) -- Line: 585
        local Debris = workspace:FindFirstChild("Debris");

        if not Debris then
            return;
        end;

        for _, child in ipairs(Debris:GetChildren()) do
            if child.Name == "Sound" and (child:IsA("BasePart") and (child.Position - p92.Position).Magnitude <= p92.Radius) then
                child:Destroy();
            end;
        end;
    end);
    Router.observerRouter("UpdatePlayerNoiseCone", function() -- Line: 603
        return nil;
    end);
end;

function v1.Start() -- Line: 610
    -- upvalues: script_MovementSounds (copy), LocalPlayer (copy), CharacterResolver (copy), u6 (ref), u7 (ref), u8 (ref), ReplicatedStorage (copy), Sound (copy), RunServiceController (copy)
    local u93 = script_MovementSounds.new(LocalPlayer);
    CharacterResolver.observeCharacter(LocalPlayer, function(p94: userdata?) -- Line: 612
        -- upvalues: u6 (ref), u7 (ref), u8 (ref), u93 (copy)
        if p94 then
            u6 = 0;

            if u7 then
                local v95 = u7;
                u7 = nil;
                u8 = 0;

                if v95.Parent then
                    v95:Stop();
                    v95:Destroy();
                end;
            end;
        end;

        u93:SetCharacter(p94);

        return function() -- Line: 618
            -- upvalues: u93 (ref)
            u93:SetCharacter(nil);
        end;
    end);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    local u96 = {
        MenuSceneController,
        {
            IsActive = MenuSceneController.IsTeamSelectSceneActive
        },
        require(ReplicatedStorage.Controllers.CaseSceneController),
        require(ReplicatedStorage.Controllers.InspectController),
        (require(ReplicatedStorage.Controllers.BlackMarketSceneController))
    };
    local GameplaySoundGroup = Sound.GameplaySoundGroup;
    local u97 = false;

    local function isAnySceneActive() -- Line: 635
        -- upvalues: u96 (copy)
        for _, v in u96 do
            if v.IsActive() then
                return true;
            end;
        end;

        return false;
    end;

    RunServiceController.BindToHeartbeat("SoundController.MovementSounds", function(p98: number) -- Line: 644
        -- upvalues: u93 (copy), u96 (copy), u97 (ref), GameplaySoundGroup (copy)
        u93:Update(p98);
        local v99 = false;

        for _, v in u96 do
            if v.IsActive() then
                v99 = true;
                break;
            end;
        end;

        if v99 ~= u97 then
            u97 = v99;
            GameplaySoundGroup.Volume = v99 and 0 or 1;
        end;
    end);
end;

return v1;