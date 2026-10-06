-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SceneLighting = require(ReplicatedStorage.Components.Common.SceneLighting);
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
u1.MenuCharacterChanged = Signal.new();
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u2 = nil;
local Sound = require(ReplicatedStorage.Classes.Sound);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local workspace_CurrentCamera = workspace.CurrentCamera;
local u3 = nil;
local Lighting2 = ReplicatedStorage.Assets.Lighting;
local Characters = ReplicatedStorage.Assets.Characters;
local u4 = {
    CT = {
        Entrance = "rbxassetid://96240248165206",
        Idle = "rbxassetid://77870220857645"
    },
    T = {
        Entrance = "rbxassetid://100747011940776",
        Idle = "rbxassetid://99540873384647"
    }
};
local u5 = {
    CT = {
        Character = "IDF",
        Weapon = "M4A1-S",
        Glove = "CT Glove"
    },
    T = {
        Character = "Anarchist",
        Weapon = "AK-47",
        Glove = "T Glove"
    }
};
local u6 = {
    {
        Team = "CT",
        TeamName = "Counter-Terrorists",
        MarkerPart = "CounterTerroristPart",
        Animation = "rbxassetid://81456769299241",
        Weapon = "USP-S",
        HighlightColor = Color3.fromRGB(0, 75, 200)
    },
    {
        Team = "T",
        TeamName = "Terrorists",
        MarkerPart = "TerroristPart",
        Animation = "rbxassetid://128548863350369",
        Weapon = "Glock-18",
        HighlightColor = Color3.fromRGB(255, 220, 50)
    }
};
local TweenInfo_new_ret = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u7 = { "IDF", "Anarchist" };
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = Janitor.new();
local u13 = false;
local u14 = Janitor.new();
local u15 = Janitor.new();
local u16 = false;
local u17 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = 1;
local u22 = nil;
local u23 = nil;

local function applyGlobalShadowsSetting() -- Line: 164
    -- upvalues: SceneLighting (copy), u23 (ref)
    SceneLighting.ApplyGlobalShadows(u23);
end;

local function applyMapLighting() -- Line: 171
    -- upvalues: u23 (ref), SceneLighting (copy)
    u23 = SceneLighting.RestoreMap(nil, u23);
end;

local function applySceneLighting(p24: string) -- Line: 177
    -- upvalues: Lighting2 (copy), u23 (ref), SceneLighting (copy)
    local v25 = Lighting2:FindFirstChild(p24);

    if v25 then
        u23 = SceneLighting.ApplyScene(p24, v25);

        return;
    end;

    warn((`[MenuSceneController]: No lighting found for scene "{p24}"`));
end;

local function excludeTeamSelectPlaceholders(p26: userdata) -- Line: 190
    -- upvalues: u7 (copy)
    for _, child in ipairs(p26:GetChildren()) do
        local TeamSelect = child:FindFirstChild("TeamSelect");

        if TeamSelect then
            for _, v in ipairs(u7) do
                local v27 = TeamSelect:FindFirstChild(v);

                if v27 then
                    v27.Archivable = false;
                end;
            end;
        end;
    end;
end;

local function getMenuScenesFolder() -- Line: 207
    -- upvalues: u3 (ref), ReplicatedStorage (copy), excludeTeamSelectPlaceholders (copy)
    if u3 then
        return u3;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    u3 = Assets and Assets:WaitForChild("MenuScenes", 10);

    if u3 then
        excludeTeamSelectPlaceholders(u3);
    end;

    return u3;
end;

local function getRandomMenuScene() -- Line: 224
    -- upvalues: u3 (ref), ReplicatedStorage (copy), excludeTeamSelectPlaceholders (copy)
    local v28;

    if u3 then
        v28 = u3;
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets");
        u3 = Assets and Assets:WaitForChild("MenuScenes", 10);

        if u3 then
            excludeTeamSelectPlaceholders(u3);
        end;

        v28 = u3;
    end;

    local v29 = not v28 and {} or v28:GetChildren();

    if #v29 > 0 then
        return v29[math.random(1, #v29)];
    end;

    return nil;
end;

local function isCharacterAlive() -- Line: 235
    -- upvalues: CharacterResolver (copy)
    return CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter());
end;

local function isTeamSelectionActive() -- Line: 241
    -- upvalues: PlayerGui (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return false;
    end;

    local Menu = MainGui:FindFirstChild("Menu");
    local Gameplay = MainGui:FindFirstChild("Gameplay");
    local v30;

    if Gameplay then
        v30 = Gameplay:FindFirstChild("Middle");
    else
        v30 = Gameplay;
    end;

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    if v30 then
        v30 = v30:FindFirstChild("TeamSelection");
    end;

    local v31;

    if Menu == nil then
        v31 = false;
    else
        v31 = not Menu.Visible;

        if v31 then
            if Gameplay == nil then
                v31 = false;
            else
                v31 = not Gameplay.Visible;

                if v31 then
                    if v30 == nil then
                        v31 = false;
                    else
                        v31 = v30.Visible;
                    end;
                end;
            end;
        end;
    end;

    return v31;
end;

local function shouldShowMenuScene() -- Line: 263
    -- upvalues: ReplicatedStorage (copy), u2 (ref), isTeamSelectionActive (copy), LocalPlayer (copy), CharacterResolver (copy)
    local MenuState = require(ReplicatedStorage.Interface.MenuState);

    if u2 and u2.IsActive() or (MenuState.IsInspectActive() or (workspace:FindFirstChild("InspectScene") or isTeamSelectionActive())) then
        return false;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");

    if Attribute == "Counter-Terrorists" or Attribute == "Terrorists" then
        return false;
    end;

    local State = require(ReplicatedStorage.Database.Components.GameState).GetState();

    if State == "Game Ending" or State == "Map Voting" then
        return not CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter());
    end;

    local v32 = not CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) and not LocalPlayer:GetAttribute("IsSpectating");

    return v32;
end;

local function getTeamLoadout(p33: string) -- Line: 296
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v34 = DataController.Get(LocalPlayer, "Loadout");
    local v35;

    if type(v34) == "table" then
        v35 = v34[p33 == "CT" and "Counter-Terrorists" or "Terrorists"];
    else
        v35 = false;
    end;

    if type(v35) == "table" then
        return v35;
    end;

    return nil;
end;

local function attachGlovesToCharacter(p36: userdata, p37: string, p38: boolean) -- Line: 303
    -- upvalues: ReplicatedStorage (copy), DataController (copy), LocalPlayer (copy), u5 (copy), AttachGlovesToCharacter (copy)
    local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
    local v39 = nil;
    local v40 = nil;
    local v41 = nil;

    if p38 then
        DataController.WaitForDataLoaded(LocalPlayer);
        local v42 = DataController.Get(LocalPlayer, "Loadout");
        local v43;

        if type(v42) == "table" then
            v43 = v42[p37 == "CT" and "Counter-Terrorists" or "Terrorists"];
        else
            v43 = false;
        end;

        if type(v43) ~= "table" then
            v43 = nil;
        end;

        local v44 = v43 and v43.Equipped and v43.Equipped["Equipped Gloves"];
        local v45;

        if type(v44) == "string" and v44 ~= "" then
            v45 = DataController.Get(LocalPlayer, "Inventory");
        else
            v45 = false;
        end;

        if type(v45) == "table" then
            for _, v in ipairs(v45) do
                if v and v._id == v44 then
                    v39 = v.Name;
                    v40 = v.Skin;
                    v41 = v.Float;
                    p36:SetAttribute("EquippedGloves", game:GetService("HttpService"):JSONEncode({
                        SkinIdentifier = v44
                    }));
                    break;
                end;
            end;
        end;
    end;

    local v46 = v39 or u5[p37].Glove;
    local v47;

    if v40 and (v41 and v46) then
        v47 = Skins.GetGloves(v46, v40, v41);
    else
        v47 = nil;
    end;

    local v48;

    if v47 then
        v48 = nil;
    else
        v48 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Weapons"):FindFirstChild(v46);

        if not v48 then
            warn((`[MenuSceneController]: Glove folder not found for "{v46}"`));

            return;
        end;
    end;

    local CharacterArmor = p36:FindFirstChild("CharacterArmor");

    if not CharacterArmor then
        CharacterArmor = Instance.new("Folder");
        CharacterArmor.Name = "CharacterArmor";
        CharacterArmor.Parent = p36;
    end;

    AttachGlovesToCharacter((v47 or v48):GetChildren(), p36, CharacterArmor);

    if v47 and v47.Name == "" then
        v47:Destroy();
    end;
end;

local function attachWeaponToCharacter(p49: userdata, p50: string, p51: boolean, p52: string?, p53: string?) -- Line: 377
    -- upvalues: ReplicatedStorage (copy), u5 (copy), DataController (copy), LocalPlayer (copy)
    local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
    local v54 = nil;
    local v55 = nil;
    local v56 = nil;
    local v57 = nil;
    local v58 = p52 or u5[p50].Weapon;

    if p51 then
        DataController.WaitForDataLoaded(LocalPlayer);
        local v59 = DataController.Get(LocalPlayer, "Loadout");
        local v60;

        if type(v59) == "table" then
            v60 = v59[p50 == "CT" and "Counter-Terrorists" or "Terrorists"];
        else
            v60 = false;
        end;

        if type(v60) ~= "table" then
            v60 = nil;
        end;

        local v61 = DataController.Get(LocalPlayer, "Inventory");
        local v62 = v60 and v60.Loadout and v60.Loadout[p53 or "Rifles"];

        if v62 and (type(v62.Options) == "table" and type(v61) == "table") then
            for _, v in ipairs(v62.Options) do
                if type(v) == "string" and v ~= "" then
                    local v63 = v;

                    for _, v2 in ipairs(v61) do
                        if v2 and (v2._id == v63 and v2.Name == v58) then
                            v54 = v2.Name;
                            v55 = v2.Skin;
                            v56 = v2.Float;
                            v57 = v2.NameTag;
                            break;
                        end;
                    end;

                    if v54 then
                        break;
                    end;
                end;
            end;
        end;
    end;

    local v64 = v54 or v58;
    local v65;

    if v55 and (typeof(v55) == "string" and v55 ~= "") then
        v65 = Skins.GetCharacterModel(v64, v55, v56, nil, v57);
    else
        v65 = nil;
    end;

    local v66 = v65 or Skins.GetBaseWeaponModel(v64, "Character");

    if not v66 then
        warn((`[MenuSceneController]: Failed to get weapon model for "{v64}"`));

        return;
    end;

    v66.Name = v64;
    local RightHand = p49:FindFirstChild("RightHand");

    if RightHand then
        if not v66.PrimaryPart then
            local Weapon = v66:FindFirstChild("Weapon");

            if Weapon then
                Weapon = Weapon:FindFirstChild("Insert");
            end;

            if not Weapon then
                warn("[MenuSceneController]: Weapon model has no PrimaryPart or Insert");
                v66:Destroy();

                return;
            end;

            v66.PrimaryPart = Weapon;
        end;

        for _, descendant in ipairs(v66:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Anchored = false;
                descendant.Massless = true;
            end;
        end;

        v66.Parent = p49;
        local Motor6D = Instance.new("Motor6D");
        Motor6D.Name = "WeaponAttachment";
        Motor6D.Part0 = RightHand;
        Motor6D.Part1 = v66.PrimaryPart;
        Motor6D.Parent = RightHand;

        if v64 == "AK-47" then
            Motor6D.C0 = CFrame.new(-0.251, 0.806, -0.406) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);

            return v66;
        end;

        local Properties = v66:FindFirstChild("Properties");

        if Properties then
            local C0 = Properties:FindFirstChild("C0");

            if C0 then
                Motor6D.C0 = C0.Value;
            end;

            local C1 = Properties:FindFirstChild("C1");

            if C1 then
                Motor6D.C1 = C1.Value;
            end;
        end;

        return v66;
    end;

    warn("[MenuSceneController]: Character missing RightHand");
    v66:Destroy();
end;

local function configureMenuDisplayCharacter(p67: userdata) -- Line: 501
    -- upvalues: CharacterResolver (copy)
    local RootPart = CharacterResolver.getRootPart(p67);

    for _, descendant in ipairs(p67:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
        end;
    end;

    if RootPart then
        RootPart.Anchored = true;
    end;
end;

local function getTeamSelectStaging(p68: userdata) -- Line: 522
    local TeamSelect = p68:FindFirstChild("TeamSelect");
    local v69;

    if TeamSelect then
        v69 = TeamSelect:FindFirstChild("CamPart");
    else
        v69 = TeamSelect;
    end;

    if TeamSelect and (v69 and v69:IsA("BasePart")) then
        return TeamSelect, v69;
    end;

    return nil, nil;
end;

local function prepareTeamSelectScene(p70: userdata) -- Line: 534
    -- upvalues: u6 (copy)
    local TeamSelect = p70:FindFirstChild("TeamSelect");

    if not TeamSelect then
        return;
    end;

    for _, v in ipairs(u6) do
        local v71 = TeamSelect:FindFirstChild(v.MarkerPart);

        if v71 and v71:IsA("BasePart") then
            v71.Transparency = 1;
            v71.CanCollide = false;
            v71.CanQuery = false;
            v71.CanTouch = false;
        end;
    end;
end;

local function ensureSceneLoaded(p72: userdata?) -- Line: 554
    -- upvalues: u8 (ref), Lighting2 (copy), u23 (ref), SceneLighting (copy), prepareTeamSelectScene (copy), u14 (copy)
    local v73 = u8;

    if v73 and v73.Parent then
        return v73;
    end;

    if not p72 then
        return nil;
    end;

    local v74 = p72:Clone();
    v74.Parent = workspace;
    u8 = v74;
    local Name = p72.Name;
    local v75 = Lighting2:FindFirstChild(Name);

    if v75 then
        u23 = SceneLighting.ApplyScene(Name, v75);
    else
        warn((`[MenuSceneController]: No lighting found for scene "{Name}"`));
    end;

    prepareTeamSelectScene(v74);
    u14:Add(function() -- Line: 571
        -- upvalues: u8 (ref)
        if u8 then
            u8:Destroy();
            u8 = nil;
        end;
    end, true, "MenuSceneCleanup");

    return v74;
end;

local function releaseSceneIfUnused() -- Line: 583
    -- upvalues: u13 (ref), u16 (ref), u14 (copy)
    if u13 or u16 then
        return;
    end;

    u14:Cleanup();
end;

local function getStagedMenuScene() -- Line: 593
    -- upvalues: u3 (ref), ReplicatedStorage (copy), excludeTeamSelectPlaceholders (copy)
    local v76;

    if u3 then
        v76 = u3;
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets");
        u3 = Assets and Assets:WaitForChild("MenuScenes", 10);

        if u3 then
            excludeTeamSelectPlaceholders(u3);
        end;

        v76 = u3;
    end;

    if not v76 then
        return nil;
    end;

    local v77 = {};

    for _, child in ipairs(v76:GetChildren()) do
        if child:IsA("Model") then
            local TeamSelect = child:FindFirstChild("TeamSelect");
            local v78;

            if TeamSelect then
                v78 = TeamSelect:FindFirstChild("CamPart");
            else
                v78 = TeamSelect;
            end;

            if not (TeamSelect and (v78 and v78:IsA("BasePart"))) then
                TeamSelect = nil;
            end;

            if TeamSelect then
                table.insert(v77, child);
            end;
        end;
    end;

    if #v77 == 0 then
        return nil;
    end;

    return v77[math.random(1, #v77)];
end;

local function spawnMenuCharacter(p79: userdata) -- Line: 614
    -- upvalues: u5 (copy), u4 (copy), Characters (copy), u9 (ref), u10 (ref), u1 (copy), u11 (ref), attachWeaponToCharacter (copy), attachGlovesToCharacter (copy), configureMenuDisplayCharacter (copy), CharacterResolver (copy), u12 (copy), u13 (ref)
    local PlayerPart = p79:FindFirstChild("PlayerPart");

    if not PlayerPart then
        return;
    end;

    local v80 = math.random(1, 2) == 1 and "CT" or "T";
    local v81 = u5[v80];
    local v82 = u4[v80];
    local v83 = Characters:FindFirstChild(v81.Character);

    if not v83 then
        warn((`[MenuSceneController]: Character "{v81.Character}" not found`));

        return;
    end;

    local v84 = v83:Clone();
    v84.Name = "MenuCharacter";
    u9 = v84;
    u10 = v80;
    u1.MenuCharacterChanged:Fire(u1.GetMenuCharacterTeam());
    u11 = attachWeaponToCharacter(v84, v80, true);
    attachGlovesToCharacter(v84, v80, true);
    configureMenuDisplayCharacter(v84);
    v84.Parent = p79;
    v84:PivotTo(PlayerPart.CFrame);
    local OrCreateAnimator = CharacterResolver.getOrCreateAnimator(v84);

    if not OrCreateAnimator then
        warn("[MenuSceneController]: Character missing Animator");

        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = v82.Entrance;
    local Animation2 = Instance.new("Animation");
    Animation2.AnimationId = v82.Idle;
    local v85 = OrCreateAnimator:LoadAnimation(Animation);
    local u86 = OrCreateAnimator:LoadAnimation(Animation2);
    u12:Add(Animation, "Destroy", "EntranceAnimation");
    u12:Add(Animation2, "Destroy", "IdleAnimation");
    u12:Add(v85, "Stop", "EntranceTrack");
    u12:Add(u86, "Stop", "IdleTrack");
    v85.Priority = Enum.AnimationPriority.Action;
    v85:Play();
    v85.Stopped:Once(function() -- Line: 670
        -- upvalues: u13 (ref), u86 (copy)
        if u13 and u86 then
            u86.Looped = true;
            u86.Priority = Enum.AnimationPriority.Idle;
            u86:Play();
        end;
    end);
    u12:Add(function() -- Line: 678
        -- upvalues: u9 (ref), u10 (ref), u11 (ref), u1 (ref)
        if u9 then
            u9:Destroy();
            u9 = nil;
            u10 = nil;
            u11 = nil;
            u1.MenuCharacterChanged:Fire(nil);
        end;
    end, true, "MenuCharacterCleanup");
end;

local function spawnTeamSelectCharacter(p87: userdata, u88: table) -- Line: 692
    -- upvalues: u5 (copy), Characters (copy), attachWeaponToCharacter (copy), attachGlovesToCharacter (copy), configureMenuDisplayCharacter (copy), u15 (copy), u17 (copy), CharacterResolver (copy)
    local v89 = p87:FindFirstChild(u88.MarkerPart);

    if not v89 then
        warn((`[MenuSceneController]: TeamSelect is missing "{u88.MarkerPart}"`));

        return;
    end;

    local v90 = u5[u88.Team];
    local v91 = Characters:FindFirstChild(v90.Character);

    if not v91 then
        warn((`[MenuSceneController]: Character "{v90.Character}" not found`));

        return;
    end;

    local v92 = v91:Clone();
    v92.Name = `TeamSelectCharacter{u88.Team}`;
    attachWeaponToCharacter(v92, u88.Team, true, u88.Weapon, "Pistols");
    attachGlovesToCharacter(v92, u88.Team, true);
    configureMenuDisplayCharacter(v92);
    v92.Parent = p87;
    v92:PivotTo(v89.CFrame);
    u15:Add(v92, "Destroy", (`Character{u88.Team}`));
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "HoverHighlight";
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.OutlineColor = u88.HighlightColor;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.Adornee = v92;
    Highlight.Parent = v92;
    u17[u88.Team] = Highlight;
    u15:Add(function() -- Line: 729
        -- upvalues: u17 (ref), u88 (copy)
        u17[u88.Team] = nil;
    end, true, (`Highlight{u88.Team}`));
    local OrCreateAnimator = CharacterResolver.getOrCreateAnimator(v92);

    if not OrCreateAnimator then
        warn((`[MenuSceneController]: TeamSelect character "{u88.Team}" is missing an Animator`));

        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = u88.Animation;
    u15:Add(Animation, "Destroy", (`Animation{u88.Team}`));
    local v93 = OrCreateAnimator:LoadAnimation(Animation);
    u15:Add(v93, "Stop", (`Track{u88.Team}`));
    v93.Looped = true;
    v93.Priority = Enum.AnimationPriority.Idle;
    v93:Play();
end;

local function getVolumeMultipliers() -- Line: 754
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v94 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100;
    local v95 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;

    return v94 / 100, v95 / 100;
end;

local function updateMenuMusicVolume() -- Line: 760
    -- upvalues: u20 (ref), DataController (copy), LocalPlayer (copy), u21 (ref)
    if not (u20 and u20.Parent) then
        return;
    end;

    local v96 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100;
    local v97 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
    u20.Volume = (u20:GetAttribute("BaseVolume") or u20.Volume) * (v96 / 100) * (v97 / 100) * u21;
end;

function u1.ShowMenuScene() -- Line: 772
    -- upvalues: CharacterResolver (copy), u16 (ref), u13 (ref), CameraController (copy), ReplicatedStorage (copy), ensureSceneLoaded (copy), getRandomMenuScene (copy), u14 (copy), u23 (ref), SceneLighting (copy), workspace_CurrentCamera (copy), u12 (copy), RunServiceController (copy), u8 (ref), u1 (copy), spawnMenuCharacter (copy), u20 (ref), DataController (copy), LocalPlayer (copy), Sound (copy), u19 (ref), PlayerGui (copy), u21 (ref)
    if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
        return;
    end;

    if u16 then
        return;
    end;

    if u13 then
        CameraController.setFOVLock("MenuScene", true, 50);
        CameraController.setMouseEnabled(true);

        return;
    end;

    if workspace:FindFirstChild("InspectScene") then
        return;
    end;

    local MenuState = require(ReplicatedStorage.Interface.MenuState);

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    local v98 = ensureSceneLoaded((getRandomMenuScene()));

    if not v98 then
        CameraController.setMouseEnabled(true);

        return;
    end;

    local CamPart = v98:FindFirstChild("CamPart");

    if not CamPart then
        warn("[MenuSceneController]: Menu scene missing CamPart");
        u14:Cleanup();
        u23 = SceneLighting.RestoreMap(nil, u23);

        return;
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CFrame = CamPart.CFrame;
    workspace_CurrentCamera.Focus = CamPart.CFrame;
    CameraController.setFOVLock("MenuScene", true, 50);
    CameraController.setMouseEnabled(true);
    u12:Add(RunServiceController.BindToRenderStep("MenuSceneController.CameraUpdate", function() -- Line: 823
        -- upvalues: u8 (ref), CamPart (copy), workspace_CurrentCamera (ref)
        if u8 and CamPart then
            workspace_CurrentCamera.CFrame = CamPart.CFrame;
            workspace_CurrentCamera.Focus = CamPart.CFrame;
        end;
    end), "Disconnect", "CameraUpdate");
    u13 = true;
    u12:Add(RunServiceController.BindToHeartbeat("MenuSceneController.AliveGuard", function() -- Line: 837
        -- upvalues: CharacterResolver (ref), u1 (ref)
        if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
            u1.HideMenuScene();
        end;
    end), "Disconnect", "AliveGuard");
    spawnMenuCharacter(v98);

    if not (u20 and u20.IsPlaying) then
        local v99 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100;
        local v100 = Sound.new("Main Menu");
        u19 = v100;
        local u101 = v100:play({
            Name = "Main Menu Music",
            Parent = PlayerGui
        }, v99);
        u20 = u101;

        if u101 then
            local v102 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
            local Volume = u101.Volume;

            if v99 > 0 and v102 > 0 then
                Volume = Volume / (v99 * v102) or Volume;
            end;

            u101:SetAttribute("BaseVolume", Volume);
            u101:SetAttribute("AmbienceVolumeMultiplier", v99);

            if u21 ~= 1 then
                u101.Volume = u101.Volume * u21;
            end;

            u101.Destroying:Once(function() -- Line: 880
                -- upvalues: u20 (ref), u101 (copy)
                if u20 == u101 then
                    u20 = nil;
                end;
            end);
        end;
    end;
end;

function u1.HideMenuScene(p103: boolean?, p104: boolean?, p105: boolean?) -- Line: 892
    -- upvalues: u13 (ref), ReplicatedStorage (copy), u12 (copy), u16 (ref), u14 (copy), CameraController (copy), u23 (ref), SceneLighting (copy), workspace_CurrentCamera (copy), Constants (copy), u1 (copy)
    if not u13 then
        return;
    end;

    if require(ReplicatedStorage.Interface.MenuState).IsInspectActive() or workspace:FindFirstChild("InspectScene") then
        p104 = true;
        p103 = true;
    end;

    u12:Cleanup();
    u13 = false;

    if not (p105 or (u13 or u16)) then
        u14:Cleanup();
    end;

    CameraController.setFOVLock("MenuScene", false);

    if not (p104 or p105) then
        u23 = SceneLighting.RestoreMap(nil, u23);
        workspace_CurrentCamera.CameraType = Enum.CameraType.Custom;
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end;

    if not p103 then
        u1.StopMenuMusic();
    end;
end;

function u1.IsActive() -- Line: 926
    -- upvalues: u13 (ref)
    return u13;
end;

function u1.IsTeamSelectSceneActive() -- Line: 932
    -- upvalues: u16 (ref)
    return u16;
end;

function u1.SetTeamSelectHighlight(p106: string, p107: boolean) -- Line: 939
    -- upvalues: u18 (ref), u6 (copy), u17 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if p107 then
        u18 = p106;
    else
        if u18 ~= p106 then
            return;
        end;

        u18 = nil;
    end;

    for _, v in ipairs(u6) do
        local v108 = u17[v.Team];

        if v108 then
            TweenService:Create(v108, TweenInfo_new_ret, {
                OutlineTransparency = u18 == v.TeamName and 0 or 1
            }):Play();
        end;
    end;
end;

function u1.ShowTeamSelectScene() -- Line: 962
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), u16 (ref), CameraController (copy), u13 (ref), u1 (copy), ensureSceneLoaded (copy), getStagedMenuScene (copy), u14 (copy), u8 (ref), u23 (ref), SceneLighting (copy), workspace_CurrentCamera (copy), u15 (copy), RunServiceController (copy), u6 (copy), spawnTeamSelectCharacter (copy), isTeamSelectionActive (copy)
    if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) or LocalPlayer:GetAttribute("IsSpectating") then
        return false;
    end;

    if u16 then
        CameraController.setFOVLock("TeamSelectScene", true, 70);
        CameraController.setMouseEnabled(true);

        return true;
    end;

    if u13 then
        u1.HideMenuScene(true, true, true);
    end;

    local v109 = ensureSceneLoaded((getStagedMenuScene()));
    local v110, u111;

    if v109 then
        v110 = v109:FindFirstChild("TeamSelect");

        if v110 then
            u111 = v110:FindFirstChild("CamPart");
        else
            u111 = v110;
        end;

        if not (v110 and (u111 and u111:IsA("BasePart"))) then
            v110 = nil;
            u111 = nil;
        end;
    else
        v110 = nil;
        u111 = nil;
    end;

    if not (v110 and u111) then
        if not (u13 or u16) then
            u14:Cleanup();
        end;

        if not u8 then
            u23 = SceneLighting.RestoreMap(nil, u23);
        end;

        return false;
    end;

    u16 = true;
    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CameraSubject = nil;
    workspace_CurrentCamera.CFrame = u111.CFrame;
    workspace_CurrentCamera.Focus = u111.CFrame;
    CameraController.setFOVLock("TeamSelectScene", true, 70);
    CameraController.setMouseEnabled(true);
    u15:Add(RunServiceController.BindToRenderStep("MenuSceneController.TeamSelectCameraUpdate", function() -- Line: 1007
        -- upvalues: workspace_CurrentCamera (ref), u111 (ref)
        workspace_CurrentCamera.CFrame = u111.CFrame;
        workspace_CurrentCamera.Focus = u111.CFrame;
    end), "Disconnect", "TeamSelectCameraUpdate");

    for _, v in ipairs(u6) do
        spawnTeamSelectCharacter(v110, v);
    end;

    local u112 = 0;
    u15:Add(RunServiceController.BindToHeartbeat("MenuSceneController.TeamSelectGuard", function(p113: number) -- Line: 1023
        -- upvalues: u112 (ref), CharacterResolver (ref), isTeamSelectionActive (ref), u1 (ref)
        u112 = u112 + p113;

        if u112 < 0.25 then
            return;
        end;

        u112 = 0;

        if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) or not isTeamSelectionActive() then
            u1.HideTeamSelectScene();
        end;
    end), "Disconnect", "TeamSelectGuard");

    return true;
end;

function u1.HideTeamSelectScene() -- Line: 1043
    -- upvalues: u16 (ref), u15 (copy), CameraController (copy), u18 (ref), u13 (ref), u14 (copy), u8 (ref), u23 (ref), SceneLighting (copy), workspace_CurrentCamera (copy)
    if not u16 then
        return;
    end;

    u15:Cleanup();
    CameraController.setFOVLock("TeamSelectScene", false);
    u16 = false;
    u18 = nil;

    if not (u13 or u16) then
        u14:Cleanup();
    end;

    if not u8 then
        u23 = SceneLighting.RestoreMap(nil, u23);
        workspace_CurrentCamera.CameraType = Enum.CameraType.Custom;
    end;
end;

function u1.StopMenuMusic() -- Line: 1063
    -- upvalues: u20 (ref), u19 (ref)
    if u20 then
        u20:Stop();
        u20 = nil;
    end;

    if u19 then
        u19:destroy();
        u19 = nil;
    end;
end;

function u1.SetMusicVolumeMultiplier(p114: number, p115: number?) -- Line: 1076
    -- upvalues: u21 (ref), u20 (ref), u22 (ref), DataController (copy), LocalPlayer (copy), TweenService (copy)
    u21 = p114;

    if not u20 then
        return;
    end;

    if u22 then
        u22:Cancel();
        u22 = nil;
    end;

    local v116 = u20:GetAttribute("BaseVolume") or 0.1;
    local v117 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100;
    local v118 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
    local v119 = v116 * (v117 / 100) * (v118 / 100) * u21;

    if not p115 or p115 <= 0 then
        u20.Volume = v119;

        return;
    end;

    local v120 = TweenService:Create(u20, TweenInfo.new(p115, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = v119
    });
    u22 = v120;
    v120:Play();
end;

u1.ApplyMapLighting = applyMapLighting;

function u1.ApplyMenuSceneLighting() -- Line: 1113
    -- upvalues: getRandomMenuScene (copy), Lighting2 (copy), u23 (ref), SceneLighting (copy), Lighting (copy)
    local v121 = getRandomMenuScene();

    if v121 then
        local Name = v121.Name;
        local v122 = Lighting2:FindFirstChild(Name);

        if v122 then
            u23 = SceneLighting.ApplyScene(Name, v122);
        else
            warn((`[MenuSceneController]: No lighting found for scene "{Name}"`));
        end;

        Lighting.GlobalShadows = true;
    end;
end;

function u1.GetMenuCharacterTeam() -- Line: 1124
    -- upvalues: u10 (ref)
    return u10 == "CT" and "Counter-Terrorists" or (u10 == "T" and "Terrorists" or nil);
end;

function u1.CreateStandaloneCharacter(p123: string?) -- Line: 1133
    -- upvalues: u5 (copy), Characters (copy), ReplicatedStorage (copy), attachGlovesToCharacter (copy)
    local v124 = p123 or (math.random(1, 2) == 1 and "CT" or "T");
    local v125 = u5[v124];
    local v126 = Characters:FindFirstChild(v125.Character);

    if not v126 then
        warn((`[MenuSceneController]: Character "{v125.Character}" not found`));

        return nil;
    end;

    local v127 = v126:Clone();
    v127.Name = "StandaloneCharacter";
    v127.Parent = ReplicatedStorage;
    attachGlovesToCharacter(v127, v124, true);

    return v127;
end;

local function showIfNeeded() -- Line: 1158
    -- upvalues: shouldShowMenuScene (copy), u1 (copy)
    if shouldShowMenuScene() then
        u1.ShowMenuScene();
    end;
end;

local function recheckLater() -- Line: 1164
    -- upvalues: showIfNeeded (copy)
    task.delay(0.1, showIfNeeded);
end;

function u1.Initialize() -- Line: 1168
    -- upvalues: DataController (copy), LocalPlayer (copy), applyGlobalShadowsSetting (copy), updateMenuMusicVolume (copy), shouldShowMenuScene (copy), u1 (copy), u2 (ref), ReplicatedStorage (copy), CharacterResolver (copy), showIfNeeded (copy), Observers (copy), recheckLater (copy), u9 (ref), u10 (ref), u11 (ref), attachWeaponToCharacter (copy), attachGlovesToCharacter (copy), configureMenuDisplayCharacter (copy), u12 (copy)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", applyGlobalShadowsSetting);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume", updateMenuMusicVolume);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateMenuMusicVolume);

    if shouldShowMenuScene() then
        u1.ShowMenuScene();
    end;

    task.defer(function() -- Line: 1175
        -- upvalues: u2 (ref), ReplicatedStorage (ref)
        if not u2 then
            u2 = require(ReplicatedStorage.Controllers.EndScreenController);
        end;
    end);
    CharacterResolver.observeCharacter(LocalPlayer, function(u128: userdata?, p129: userdata?) -- Line: 1181
        -- upvalues: showIfNeeded (ref), shouldShowMenuScene (ref), u1 (ref)
        if p129 and p129 ~= u128 then
            task.delay(0.1, showIfNeeded);
        end;

        if not u128 then
            return function() -- Line: 1187
            end;
        end;

        if shouldShowMenuScene() then
            u1.ShowMenuScene();
        else
            u1.StopMenuMusic();
            u1.HideMenuScene();
        end;

        local u130 = u128:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 1197
            -- upvalues: u128 (copy), showIfNeeded (ref)
            if u128:GetAttribute("Dead") == true then
                task.delay(0.1, showIfNeeded);
            end;
        end);

        return function() -- Line: 1203
            -- upvalues: u130 (copy)
            u130:Disconnect();
        end;
    end);
    Observers.observeAttribute(LocalPlayer, "IsSpectating", function(p131) -- Line: 1208
        -- upvalues: u1 (ref), shouldShowMenuScene (ref), showIfNeeded (ref)
        if p131 then
            u1.HideMenuScene();
        elseif shouldShowMenuScene() then
            u1.ShowMenuScene();
        end;

        return showIfNeeded;
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function(p132) -- Line: 1219
        -- upvalues: u1 (ref), shouldShowMenuScene (ref), recheckLater (ref)
        if p132 == "Counter-Terrorists" or p132 == "Terrorists" then
            u1.HideMenuScene();
        elseif shouldShowMenuScene() then
            u1.ShowMenuScene();
        end;

        return recheckLater;
    end);
    local u134 = DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1230, Name: updateMenuCharacterLoadout
        -- upvalues: u9 (ref), u10 (ref), u11 (ref), attachWeaponToCharacter (ref), attachGlovesToCharacter (ref), configureMenuDisplayCharacter (ref)
        if not (u9 and u10) then
            return;
        end;

        if u11 and u11.Parent then
            u11:Destroy();
            u11 = nil;
        end;

        local RightHand = u9:FindFirstChild("RightHand");
        local v133 = RightHand and RightHand:FindFirstChild("WeaponAttachment");

        if v133 then
            v133:Destroy();
        end;

        local CharacterArmor = u9:FindFirstChild("CharacterArmor");

        if CharacterArmor then
            for _, child in ipairs(CharacterArmor:GetChildren()) do
                if child:IsA("BasePart") and child:FindFirstChild("GloveAttachment") then
                    child:Destroy();
                end;
            end;
        end;

        u11 = attachWeaponToCharacter(u9, u10, true);
        attachGlovesToCharacter(u9, u10, true);
        configureMenuDisplayCharacter(u9);
    end);
    u12:Add(function() -- Line: 1262
        -- upvalues: DataController (ref), LocalPlayer (ref), u134 (copy)
        DataController.RemoveListener(LocalPlayer, "Loadout", u134);
    end, true, "LoadoutListener");
    local GameState = require(ReplicatedStorage.Database.Components.GameState);
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
    GameState.ListenToState(function(p135, p136) -- Line: 1268
        -- upvalues: LocalPlayer (ref), SpectateController (copy), shouldShowMenuScene (ref), u1 (ref)
        if p136 == "Game Ending" or p136 == "Map Voting" then
            if LocalPlayer:GetAttribute("IsSpectating") then
                SpectateController.Stop(false, true);
            end;

            if shouldShowMenuScene() then
                u1.ShowMenuScene();
            end;
        end;
    end);
end;

function u1.Start() -- Line: 1279
end;

return u1;