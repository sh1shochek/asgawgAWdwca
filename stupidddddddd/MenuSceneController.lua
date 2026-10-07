-- ReplicatedStorage.Controllers.MenuSceneController
-- Script path: ReplicatedStorage.Controllers.MenuSceneController
-- Decompile time: 20.47 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SceneLighting = require(ReplicatedStorage.Components.Common.SceneLighting)
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
u0.MenuCharacterChanged = Signal.new()
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local u52 = nil
local Sound = require(ReplicatedStorage.Classes.Sound)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = workspace.CurrentCamera
local u69 = nil
local Lighting_2 = ReplicatedStorage.Assets.Lighting
local Characters = ReplicatedStorage.Assets.Characters
local u74 = {
    CT = {Entrance = "rbxassetid://96240248165206", Idle = "rbxassetid://77870220857645"},
    T = {Entrance = "rbxassetid://100747011940776", Idle = "rbxassetid://99540873384647"},
}
local u77 = {
    CT = {Character = "IDF", Weapon = "M4A1-S", Glove = "CT Glove"},
    T = {Character = "Anarchist", Weapon = "AK-47", Glove = "T Glove"},
}
local u80 = {}
local v1 = {
    Team = "CT",
    TeamName = "Counter-Terrorists",
    MarkerPart = "CounterTerroristPart",
    Animation = "rbxassetid://81456769299241",
    Weapon = "USP-S",
    HighlightColor = Color3.fromRGB(0, 75, 200),
}
local v2 = {
    Team = "T",
    TeamName = "Terrorists",
    MarkerPart = "TerroristPart",
    Animation = "rbxassetid://128548863350369",
    Weapon = "Glock-18",
    HighlightColor = Color3.fromRGB(255, 220, 50),
}
u80[1] = v1
u80[2] = v2
local u97 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u98 = {"IDF", "Anarchist"}
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u112 = nil
local u113 = nil
local u114 = nil
local u115 = nil
local u117 = Janitor.new()
local u118 = false
local u120 = Janitor.new()
local u122 = Janitor.new()
local u123 = false
local u124 = {}
local u125 = nil
local u126 = nil
local u127 = nil
local u128 = 1
local u129 = nil
local u130 = nil

local function applyGlobalShadowsSetting() -- Line: 164 -- upvalues: SceneLighting (val), u130 (ref)
    SceneLighting.ApplyGlobalShadows(u130)
end

local function applySceneLighting(a1) -- Line: 177
    -- upvalues: Lighting_2 (val), u130 (ref), SceneLighting (val)
    local v1 = Lighting_2:FindFirstChild(a1)
    if not v1 then
        warn((("[MenuSceneController]: No lighting found for scene \"%*\""):format(a1)))
        return
    end
    u130 = SceneLighting.ApplyScene(a1, v1)
end

local function excludeTeamSelectPlaceholders(a1) -- Line: 190 -- upvalues: u98 (val) -- types: a1: userdata
    local TeamSelect, v1
    for i, v in ipairs(a1:GetChildren()) do
        TeamSelect = v:FindFirstChild("TeamSelect")
        if TeamSelect then
            for i2, i3 in ipairs(u98) do
                v1 = TeamSelect:FindFirstChild(i3)
                if v1 then
                    v1.Archivable = false
                end
            end
        end
    end
end

local function getMenuScenesFolder() -- Line: 207
    -- upvalues: u69 (ref), ReplicatedStorage (val), excludeTeamSelectPlaceholders (val)
    if u69 then
        return u69
    end
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    if Assets then
        u69 = Assets:WaitForChild("MenuScenes", 10)
        if u69 then
            excludeTeamSelectPlaceholders(u69)
        end
    end
    return u69
end

local function getRandomMenuScene() -- Line: 224
    -- upvalues: u69 (ref), ReplicatedStorage (val), excludeTeamSelectPlaceholders (val)
    if not u69 then
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        if Assets then
            u69 = Assets:WaitForChild("MenuScenes", 10)
            if u69 then
                excludeTeamSelectPlaceholders(u69)
            end
        end
    end
    local v1 = u69
    local Children = if not v1 then {} else v1:GetChildren()
    if #Children > 0 then
        return Children[math.random(1, #Children)]
    end
    return nil
end

local function isCharacterAlive() -- Line: 235 -- upvalues: CharacterResolver (val)
    return CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter())
end

local function isTeamSelectionActive() -- Line: 241 -- upvalues: PlayerGui (val)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    if not MainGui then
        return false
    end
    local Menu = MainGui:FindFirstChild("Menu")
    local Gameplay = MainGui:FindFirstChild("Gameplay")
    local Middle = Gameplay and Gameplay:FindFirstChild("Middle")
    local Bottom = Gameplay and Gameplay:FindFirstChild("Bottom")
    local TeamSelection = Middle and Middle:FindFirstChild("TeamSelection")
    local Visible = false
    if Menu ~= nil then
        Visible = not Menu.Visible
        if Visible then
            Visible = false
            if Bottom ~= nil then
                Visible = not Bottom.Visible
                if Visible then
                    Visible = false
                    if TeamSelection ~= nil then
                        Visible = TeamSelection.Visible
                    end
                end
            end
        end
    end
    return Visible
end

local function shouldShowMenuScene() -- Line: 263
    -- upvalues: ReplicatedStorage (val), u52 (ref), isTeamSelectionActive (val), LocalPlayer (val)
    -- upvalues: CharacterResolver (val)
    local MenuState = require(ReplicatedStorage.Interface.MenuState)
    if u52 and u52.IsActive() then
        return false
    end
    if not MenuState.IsInspectActive()
        and not workspace:FindFirstChild("InspectScene")
        and not isTeamSelectionActive() then
        local Attribute = LocalPlayer:GetAttribute("Team")
        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            local v1 = require(ReplicatedStorage.Database.Components.GameState).GetState()
            if v1 ~= "Game Ending" and v1 ~= "Map Voting" then
                return not CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) and not LocalPlayer:GetAttribute("IsSpectating")
            end
            return not CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter())
        end
        return false
    end
    return false
end

local function getTeamLoadout(a1) -- Line: 296 -- upvalues: DataController (val), LocalPlayer (val) -- types: a1: string
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    local v2 = false
    if type(v1) == "table" then
        v2 = v1[if a1 ~= "CT" then "Terrorists" else "Counter-Terrorists"]
    end
    if type(v2) == "table" then
        return v2
    end
    return nil
end

local function attachGlovesToCharacter(a1, a2, a3) -- Line: 303
    -- upvalues: ReplicatedStorage (val), DataController (val), LocalPlayer (val), u77 (val)
    -- upvalues: AttachGlovesToCharacter (val)
    local v1
    local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
    local Name = nil
    local Skin = nil
    local Float = nil
    if a3 then
        DataController.WaitForDataLoaded(LocalPlayer)
        local v2 = DataController.Get(LocalPlayer, "Loadout")
        local v3 = false
        if type(v2) == "table" then
            v3 = v2[if a2 ~= "CT" then "Terrorists" else "Counter-Terrorists"]
        end
        v1 = if type(v3) ~= "table" then nil else v3
        local Equipped = v1 and v1.Equipped and v1.Equipped["Equipped Gloves"]
        v3 = false
        if type(Equipped) == "string" then
            v3 = false
            if Equipped ~= "" then
                v3 = DataController.Get(LocalPlayer, "Inventory")
            end
        end
        if type(v3) == "table" then
            for i, v in ipairs(v3) do
                if v and v._id == Equipped then
                    Name = v.Name
                    Skin = v.Skin
                    Float = v.Float
                    a1:SetAttribute("EquippedGloves", ((game:GetService("HttpService")):JSONEncode({SkinIdentifier = Equipped})))
                    break
                end
            end
        end
    end
    local v4 = Name or u77[a2].Glove
    v1 = nil
    if Skin and Float and v4 then
        v1 = Skins.GetGloves(v4, Skin, Float)
    end
    if not v1 and not (ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Weapons"):FindFirstChild(v4)) then
        warn((("[MenuSceneController]: Glove folder not found for \"%*\""):format(v4)))
        return
    end
    local CharacterArmor = a1:FindFirstChild("CharacterArmor")
    if not CharacterArmor then
        CharacterArmor = Instance.new("Folder")
        CharacterArmor.Name = "CharacterArmor"
        CharacterArmor.Parent = a1
    end
    AttachGlovesToCharacter((v1 or nil):GetChildren(), a1, CharacterArmor)
    if v1 and v1.Name == "" then
        v1:Destroy()
    end
end

local function attachWeaponToCharacter(a1, a2, a3, a4, a5) -- Line: 377
    -- upvalues: ReplicatedStorage (val), u77 (val), DataController (val), LocalPlayer (val)
    local v1, v2
    local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
    local Name = nil
    local Skin = nil
    local Float = nil
    local NameTag = nil
    local Weapon = a4 or u77[a2].Weapon
    if a3 then
        DataController.WaitForDataLoaded(LocalPlayer)
        local v3 = DataController.Get(LocalPlayer, "Loadout")
        local v4 = false
        if type(v3) == "table" then
            v4 = v3[if a2 ~= "CT" then "Terrorists" else "Counter-Terrorists"]
        end
        v2 = if type(v4) ~= "table" then nil else v4
        v3 = DataController.Get(LocalPlayer, "Inventory")
        local Loadout = v2 and v2.Loadout and v2.Loadout[a5 or "Rifles"]
        if Loadout and type(Loadout.Options) == "table" and type(v3) == "table" then
            v1 = a1
            for i, v in ipairs(Loadout.Options) do
                if type(v) == "string" and v ~= "" then
                    for i2, i3 in ipairs(v3) do
                        if i3 and i3._id == v and i3.Name == Weapon then
                            Name = i3.Name
                            Skin = i3.Skin
                            Float = i3.Float
                            NameTag = i3.NameTag
                            break
                        end
                    end
                    if Name then
                        break
                    end
                end
            end
        end
    end
    local v5 = Name or Weapon
    v2 = nil
    if Skin and typeof(Skin) == "string" and Skin ~= "" then
        v2 = Skins.GetCharacterModel(v5, Skin, Float, nil, NameTag)
    end
    if not v2 then
        v2 = Skins.GetBaseWeaponModel(v5, "Character")
    end
    if not v2 then
        warn((("[MenuSceneController]: Failed to get weapon model for \"%*\""):format(v5)))
        return
    end
    v2.Name = v5
    local RightHand = v1:FindFirstChild("RightHand")
    if not RightHand then
        warn("[MenuSceneController]: Character missing RightHand")
        v2:Destroy()
        return
    end
    if not v2.PrimaryPart then
        local Weapon_2 = v2:FindFirstChild("Weapon")
        local Insert = Weapon_2 and Weapon_2:FindFirstChild("Insert")
        if not Insert then
            warn("[MenuSceneController]: Weapon model has no PrimaryPart or Insert")
            v2:Destroy()
            return
        else
            v2.PrimaryPart = Insert
        end
    end
    for i4, j in ipairs(v2:GetDescendants()) do
        if j:IsA("BasePart") then
            j.CanCollide = false
            j.CanQuery = false
            j.CanTouch = false
            j.Anchored = false
            j.Massless = true
        end
    end
    v2.Parent = v1
    local Motor6D = Instance.new("Motor6D")
    Motor6D.Name = "WeaponAttachment"
    Motor6D.Part0 = RightHand
    Motor6D.Part1 = v2.PrimaryPart
    Motor6D.Parent = RightHand
    if v5 == "AK-47" then
        Motor6D.C0 = (CFrame.new(-0.251, 0.806, -0.406)) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966)
        return v2
    end
    local Properties = v2:FindFirstChild("Properties")
    if Properties then
        local C0 = Properties:FindFirstChild("C0")
        if C0 then
            Motor6D.C0 = C0.Value
        end
        local C1 = Properties:FindFirstChild("C1")
        if C1 then
            Motor6D.C1 = C1.Value
        end
    end
    return v2
end

local function configureMenuDisplayCharacter(a1) -- Line: 501
    -- upvalues: CharacterResolver (val)
    local v1 = CharacterResolver.getRootPart(a1)
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.CanQuery = false
            v.CanTouch = false
            v.Massless = true
        end
    end
    if v1 then
        v1.Anchored = true
    end
end

local function getTeamSelectStaging(a1) -- Line: 522 -- types: a1: userdata
    local TeamSelect = a1:FindFirstChild("TeamSelect")
    local CamPart = TeamSelect and TeamSelect:FindFirstChild("CamPart")
    if TeamSelect and CamPart and CamPart:IsA("BasePart") then
        return TeamSelect, CamPart
    end
    return nil, nil
end

local function prepareTeamSelectScene(a1) -- Line: 534 -- upvalues: u80 (val) -- types: a1: userdata
    local v1
    local TeamSelect = a1:FindFirstChild("TeamSelect")
    if not TeamSelect then
        return
    end
    for i, v in ipairs(u80) do
        v1 = TeamSelect:FindFirstChild(v.MarkerPart)
        if v1 and v1:IsA("BasePart") then
            v1.Transparency = 1
            v1.CanCollide = false
            v1.CanQuery = false
            v1.CanTouch = false
        end
    end
end

local function ensureSceneLoaded(a1) -- Line: 554
    -- upvalues: u112 (ref), Lighting_2 (val), u130 (ref), SceneLighting (val), prepareTeamSelectScene (val), u120 (val)
    local v1 = u112
    if v1 and v1.Parent then
        return v1
    end
    if not a1 then
        return nil
    end
    local v2 = a1:Clone()
    v2.Parent = workspace
    u112 = v2
    local Name = a1.Name
    local v3 = Lighting_2:FindFirstChild(Name)
    if v3 then
        u130 = SceneLighting.ApplyScene(Name, v3)
    else
        warn((("[MenuSceneController]: No lighting found for scene \"%*\""):format(Name)))
    end
    prepareTeamSelectScene(v2)
    u120:Add(function() -- Line: 571 -- upvalues: u112 (upval)
        if u112 then
            u112:Destroy()
            u112 = nil
        end
    end, true, "MenuSceneCleanup")
    return v2
end

local function releaseSceneIfUnused() -- Line: 583 -- upvalues: u118 (ref), u123 (ref), u120 (val)
    if not u118 and not u123 then
        u120:Cleanup()
        return
    end
end

local function getStagedMenuScene() -- Line: 593
    -- upvalues: u69 (ref), ReplicatedStorage (val), excludeTeamSelectPlaceholders (val)
    local CamPart, TeamSelect, v1
    if not u69 then
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        if Assets then
            u69 = Assets:WaitForChild("MenuScenes", 10)
            if u69 then
                excludeTeamSelectPlaceholders(u69)
            end
        end
    end
    if not u69 then
        return nil
    end
    local v2 = {}
    for i, v in ipairs(v1:GetChildren()) do
        if v:IsA("Model") then
            TeamSelect = v:FindFirstChild("TeamSelect")
            CamPart = TeamSelect and TeamSelect:FindFirstChild("CamPart")
            if if not TeamSelect then nil else if not CamPart then nil else if not CamPart:IsA("BasePart") then nil else TeamSelect then
                table.insert(v2, v)
            end
        end
    end
    if #v2 == 0 then
        return nil
    end
    return v2[math.random(1, #v2)]
end

local function spawnMenuCharacter(a1) -- Line: 614
    -- upvalues: u77 (val), u74 (val), Characters (val), u113 (ref), u114 (ref), u0 (val), u115 (ref)
    -- upvalues: attachWeaponToCharacter (val), attachGlovesToCharacter (val), configureMenuDisplayCharacter (val)
    -- upvalues: CharacterResolver (val), u117 (val), u118 (ref)
    local v1
    local PlayerPart = a1:FindFirstChild("PlayerPart")
    if not PlayerPart then
        return
    end
    local v2 = u77[if math.random(1, 2) ~= 1 then "T" else "CT"]
    local v3 = u74[v1]
    local v4 = Characters:FindFirstChild(v2.Character)
    if not v4 then
        warn((("[MenuSceneController]: Character \"%*\" not found"):format(v2.Character)))
        return
    end
    local v5 = v4:Clone()
    v5.Name = "MenuCharacter"
    u113 = v5
    u114 = v1
    u0.MenuCharacterChanged:Fire((u0.GetMenuCharacterTeam()))
    u115 = attachWeaponToCharacter(v5, v1, true)
    attachGlovesToCharacter(v5, v1, true)
    configureMenuDisplayCharacter(v5)
    v5.Parent = a1
    v5:PivotTo(PlayerPart.CFrame)
    local v6 = CharacterResolver.getOrCreateAnimator(v5)
    if not v6 then
        warn("[MenuSceneController]: Character missing Animator")
        return
    end
    local Animation = Instance.new("Animation")
    Animation.AnimationId = v3.Entrance
    local Animation_2 = Instance.new("Animation")
    Animation_2.AnimationId = v3.Idle
    local v7 = v6:LoadAnimation(Animation)
    local u81 = v6:LoadAnimation(Animation_2)
    u117:Add(Animation, "Destroy", "EntranceAnimation")
    u117:Add(Animation_2, "Destroy", "IdleAnimation")
    u117:Add(v7, "Stop", "EntranceTrack")
    u117:Add(u81, "Stop", "IdleTrack")
    v7.Priority = Enum.AnimationPriority.Action
    v7:Play()
    v7.Stopped:Once(function() -- Line: 670 -- upvalues: u118 (upval), u81 (val)
        if u118 and u81 then
            u81.Looped = true
            u81.Priority = Enum.AnimationPriority.Idle
            u81:Play()
        end
    end)
    u117:Add(function() -- Line: 678 -- upvalues: u113 (upval), u114 (upval), u115 (upval), u0 (upval)
        if u113 then
            u113:Destroy()
            u113 = nil
            u114 = nil
            u115 = nil
            u0.MenuCharacterChanged:Fire(nil)
        end
    end, true, "MenuCharacterCleanup")
end

local function spawnTeamSelectCharacter(a1, a2) -- Line: 692
    -- upvalues: u77 (val), Characters (val), attachWeaponToCharacter (val), attachGlovesToCharacter (val)
    -- upvalues: configureMenuDisplayCharacter (val), u122 (val), u124 (val), CharacterResolver (val)
    local v1 = a1:FindFirstChild(a2.MarkerPart)
    if not v1 then
        warn((("[MenuSceneController]: TeamSelect is missing \"%*\""):format(a2.MarkerPart)))
        return
    end
    local v2 = u77[a2.Team]
    local v3 = Characters:FindFirstChild(v2.Character)
    if not v3 then
        warn((("[MenuSceneController]: Character \"%*\" not found"):format(v2.Character)))
        return
    end
    local v4 = v3:Clone()
    v4.Name = ("TeamSelectCharacter%*"):format(a2.Team)
    attachWeaponToCharacter(v4, a2.Team, true, a2.Weapon, "Pistols")
    attachGlovesToCharacter(v4, a2.Team, true)
    configureMenuDisplayCharacter(v4)
    v4.Parent = a1
    v4:PivotTo(v1.CFrame)
    u122:Add(v4, "Destroy", (("Character%*"):format(a2.Team)))
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "HoverHighlight"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.OutlineColor = a2.HighlightColor
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.Adornee = v4
    Highlight.Parent = v4
    u124[a2.Team] = Highlight
    local v5 = u122
    local v6 = ("Highlight%*"):format(a2.Team)
    v5:Add(function() -- Line: 729 -- upvalues: u124 (upval), a2 (val)
        u124[a2.Team] = nil
    end, true, v6)
    v5 = CharacterResolver.getOrCreateAnimator(v4)
    if not v5 then
        warn((("[MenuSceneController]: TeamSelect character \"%*\" is missing an Animator"):format(a2.Team)))
        return
    end
    local Animation = Instance.new("Animation")
    Animation.AnimationId = a2.Animation
    u122:Add(Animation, "Destroy", (("Animation%*"):format(a2.Team)))
    local v7 = v5:LoadAnimation(Animation)
    u122:Add(v7, "Stop", (("Track%*"):format(a2.Team)))
    v7.Looped = true
    v7.Priority = Enum.AnimationPriority.Idle
    v7:Play()
end

local function getVolumeMultipliers() -- Line: 754 -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100
    local v2 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100
    return v1 / 100, v2 / 100
end

local function updateMenuMusicVolume() -- Line: 760
    -- upvalues: u127 (ref), DataController (val), LocalPlayer (val), u128 (ref)
    if u127 and u127.Parent then
        local v1 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100
        local v2 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")
        local v3 = v1 / 100
        local v4 = (v2 or 100) / 100
        local Attribute = u127:GetAttribute("BaseVolume") or u127.Volume
        u127.Volume = Attribute * v3 * v4 * u128
        return
    end
end

function u0.ShowMenuScene() -- Line: 772
    -- upvalues: CharacterResolver (val), u123 (ref), u118 (ref), CameraController (val), ReplicatedStorage (val)
    -- upvalues: ensureSceneLoaded (val), getRandomMenuScene (val), u120 (val), u130 (ref), SceneLighting (val)
    -- upvalues: CurrentCamera (val), u117 (val), RunServiceController (val), u112 (ref), u0 (val)
    -- upvalues: spawnMenuCharacter (val), u127 (ref), DataController (val), LocalPlayer (val), Sound (val), u126 (ref)
    -- upvalues: PlayerGui (val), u128 (ref)
    if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) or u123 then
        return
    end
    if u118 then
        CameraController.setFOVLock("MenuScene", true, 50)
        CameraController.setMouseEnabled(true)
        return
    end
    if workspace:FindFirstChild("InspectScene") then
        return
    end
    local MenuState = require(ReplicatedStorage.Interface.MenuState)
    if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
        local v1 = ensureSceneLoaded((getRandomMenuScene()))
        if not v1 then
            CameraController.setMouseEnabled(true)
            return
        end
        local CamPart = v1:FindFirstChild("CamPart")
        if not CamPart then
            warn("[MenuSceneController]: Menu scene missing CamPart")
            u120:Cleanup()
            u130 = SceneLighting.RestoreMap(nil, u130)
            return
        end
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = CamPart.CFrame
        CurrentCamera.Focus = CamPart.CFrame
        CameraController.setFOVLock("MenuScene", true, 50)
        CameraController.setMouseEnabled(true)
        u117:Add(RunServiceController.BindToRenderStep("MenuSceneController.CameraUpdate", function() -- Line: 823 -- upvalues: u112 (upval), CamPart (val), CurrentCamera (upval)
            if u112 and CamPart then
                CurrentCamera.CFrame = CamPart.CFrame
                CurrentCamera.Focus = CamPart.CFrame
            end
        end), "Disconnect", "CameraUpdate")
        u118 = true
        u117:Add(RunServiceController.BindToHeartbeat("MenuSceneController.AliveGuard", function() -- Line: 837 -- upvalues: CharacterResolver (upval), u0 (upval)
            if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
                u0.HideMenuScene()
            end
        end), "Disconnect", "AliveGuard")
        spawnMenuCharacter(v1)
        if not u127 or not u127.IsPlaying then
            local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100
            local v3 = Sound.new("Main Menu")
            u126 = v3
            local v4 = {Name = "Main Menu Music", Parent = PlayerGui}
            local u117_2 = v3:play(v4, v2)
            u127 = u117_2
            if u117_2 then
                v4 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                local Volume = u117_2.Volume
                u117_2:SetAttribute("BaseVolume", v2 > 0 and v4 > 0 and Volume / (v2 * v4) or Volume)
                u117_2:SetAttribute("AmbienceVolumeMultiplier", v2)
                if u128 ~= 1 then
                    u117_2.Volume = u117_2.Volume * u128
                end
                u117_2.Destroying:Once(function() -- Line: 880 -- upvalues: u127 (upval), u117_2 (val)
                    if u127 == u117_2 then
                        u127 = nil
                    end
                end)
            end
        end
        return
    end
end

function u0.HideMenuScene(a1, a2, a3) -- Line: 892
    -- upvalues: u118 (ref), ReplicatedStorage (val), u117 (val), u123 (ref), u120 (val), CameraController (val)
    -- upvalues: u130 (ref), SceneLighting (val), CurrentCamera (val), Constants (val), u0 (val)
    local v1, v2
    if not u118 then
        return
    end
    local InspectScene = require(ReplicatedStorage.Interface.MenuState).IsInspectActive() or workspace:FindFirstChild("InspectScene")
    if not InspectScene then
        v2, v1 = a2, a1
    else
        v2 = true
        v1 = true
    end
    u117:Cleanup()
    u118 = false
    if not a3 and not u118 and not u123 then
        u120:Cleanup()
    end
    CameraController.setFOVLock("MenuScene", false)
    if not v2 and not a3 then
        u130 = SceneLighting.RestoreMap(nil, u130)
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
    end
    if not v1 then
        u0.StopMenuMusic()
    end
end

function u0.IsActive() -- Line: 926 -- upvalues: u118 (ref)
    return u118
end

function u0.IsTeamSelectSceneActive() -- Line: 932 -- upvalues: u123 (ref)
    return u123
end

function u0.SetTeamSelectHighlight(a1, a2) -- Line: 939
    -- upvalues: u125 (ref), u80 (val), u124 (val), TweenService (val), u97 (val)
    local v1
    if a2 then
        for i2, i3 in ipairs(u80) do
            v1 = u124[i3.Team]
            if v1 then
                TweenService:Create(v1, u97, {OutlineTransparency = if not (a1 == i3.TeamName) then 1 else 0}):Play()
            end
        end
        return
    end
    if u125 ~= a1 then
        return
    end
    u125 = nil
    for i, v in ipairs(u80) do
        v1 = u124[v.Team]
        if v1 then
            TweenService:Create(v1, u97, {OutlineTransparency = if not (u125 == v.TeamName) then 1 else 0}):Play()
        end
    end
end

function u0.ShowTeamSelectScene() -- Line: 962
    -- upvalues: CharacterResolver (val), LocalPlayer (val), u123 (ref), CameraController (val), u118 (ref), u0 (val)
    -- upvalues: ensureSceneLoaded (val), getStagedMenuScene (val), u120 (val), u112 (ref), u130 (ref)
    -- upvalues: SceneLighting (val), CurrentCamera (val), u122 (val), RunServiceController (val), u80 (val)
    -- upvalues: spawnTeamSelectCharacter (val), isTeamSelectionActive (val)
    if not CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter())
        and not LocalPlayer:GetAttribute("IsSpectating") then
        if u123 then
            CameraController.setFOVLock("TeamSelectScene", true, 70)
            CameraController.setMouseEnabled(true)
            return true
        end
        if u118 then
            u0.HideMenuScene(true, true, true)
        end
        local v1 = ensureSceneLoaded((getStagedMenuScene()))
        local v2 = nil
        local u58 = nil
        if v1 then
            local v3, v4
            local TeamSelect = v1:FindFirstChild("TeamSelect")
            local CamPart = TeamSelect and TeamSelect:FindFirstChild("CamPart")
            if not TeamSelect or not CamPart or not CamPart:IsA("BasePart") then
                v3 = nil
                v4 = nil
            else
                v3 = TeamSelect
                v4 = CamPart
            end
            v2 = v3
            u58 = v4
        end
        if v2 and u58 then
            u123 = true
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CameraSubject = nil
            CurrentCamera.CFrame = u58.CFrame
            CurrentCamera.Focus = u58.CFrame
            CameraController.setFOVLock("TeamSelectScene", true, 70)
            CameraController.setMouseEnabled(true)
            u122:Add(RunServiceController.BindToRenderStep("MenuSceneController.TeamSelectCameraUpdate", function() -- Line: 1007 -- upvalues: CurrentCamera (upval), u58 (ref)
                CurrentCamera.CFrame = u58.CFrame
                CurrentCamera.Focus = u58.CFrame
            end), "Disconnect", "TeamSelectCameraUpdate")
            for i, v in ipairs(u80) do
                spawnTeamSelectCharacter(v2, v)
            end
            local u103 = 0
            u122:Add(RunServiceController.BindToHeartbeat("MenuSceneController.TeamSelectGuard", function(a1) -- Line: 1023
                -- upvalues: u103 (ref), CharacterResolver (upval), isTeamSelectionActive (upval), u0 (upval)
                u103 = u103 + a1
                if u103 < 0.25 then
                    return
                end
                u103 = 0
                if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter())
                    or not isTeamSelectionActive() then
                    u0.HideTeamSelectScene()
                end
            end), "Disconnect", "TeamSelectGuard")
            return true
        end
        if not u118 and not u123 then
            u120:Cleanup()
        end
        if not u112 then
            u130 = SceneLighting.RestoreMap(nil, u130)
        end
        return false
    end
    return false
end

function u0.HideTeamSelectScene() -- Line: 1043
    -- upvalues: u123 (ref), u122 (val), CameraController (val), u125 (ref), u118 (ref), u120 (val), u112 (ref)
    -- upvalues: u130 (ref), SceneLighting (val), CurrentCamera (val)
    if not u123 then
        return
    end
    u122:Cleanup()
    CameraController.setFOVLock("TeamSelectScene", false)
    u123 = false
    u125 = nil
    if not u118 and not u123 then
        u120:Cleanup()
    end
    if not u112 then
        u130 = SceneLighting.RestoreMap(nil, u130)
        CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

function u0.StopMenuMusic() -- Line: 1063 -- upvalues: u127 (ref), u126 (ref)
    if u127 then
        u127:Stop()
        u127 = nil
    end
    if u126 then
        u126:destroy()
        u126 = nil
    end
end

function u0.SetMusicVolumeMultiplier(a1, a2) -- Line: 1076
    -- upvalues: u128 (ref), u127 (ref), u129 (ref), DataController (val), LocalPlayer (val), TweenService (val)
    if not u127 then
        return
    end
    if u129 then
        u129:Cancel()
        u129 = nil
    end
    local v1 = u127:GetAttribute("BaseVolume") or 0.1
    local v2 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100
    local v3 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")
    local v4 = v2 / 100
    local v5 = (v3 or 100) / 100
    v2 = v1 * v4 * v5 * a1
    if a2 and a2 > 0 then
        local v6 = TweenService:Create(u127, TweenInfo.new(a2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Volume = v2})
        u129 = v6
        v6:Play()
        return
    end
    u127.Volume = v2
end

function u0.ApplyMapLighting() -- Line: 171 -- upvalues: u130 (ref), SceneLighting (val)
    u130 = SceneLighting.RestoreMap(nil, u130)
end

function u0.ApplyMenuSceneLighting() -- Line: 1113
    -- upvalues: getRandomMenuScene (val), Lighting_2 (val), u130 (ref), SceneLighting (val), Lighting (val)
    local v1 = getRandomMenuScene()
    if v1 then
        local Name = v1.Name
        local v2 = Lighting_2:FindFirstChild(Name)
        if v2 then
            u130 = SceneLighting.ApplyScene(Name, v2)
        else
            warn((("[MenuSceneController]: No lighting found for scene \"%*\""):format(Name)))
        end
        Lighting.GlobalShadows = true
    end
end

function u0.GetMenuCharacterTeam() -- Line: 1124 -- upvalues: u114 (ref)
    if u114 == "CT" then
        return "Counter-Terrorists"
    end
    if u114 == "T" then
        return "Terrorists"
    end
    return nil
end

function u0.CreateStandaloneCharacter(a1) -- Line: 1133
    -- upvalues: u77 (val), Characters (val), ReplicatedStorage (val), attachGlovesToCharacter (val)
    local v1 = a1 or (if math.random(1, 2) ~= 1 then "T" else "CT")
    local v2 = u77[v1]
    local v3 = Characters:FindFirstChild(v2.Character)
    if not v3 then
        warn((("[MenuSceneController]: Character \"%*\" not found"):format(v2.Character)))
        return nil
    end
    local v4 = v3:Clone()
    v4.Name = "StandaloneCharacter"
    v4.Parent = ReplicatedStorage
    attachGlovesToCharacter(v4, v1, true)
    return v4
end

local function showIfNeeded() -- Line: 1158 -- upvalues: shouldShowMenuScene (val), u0 (val)
    if shouldShowMenuScene() then
        u0.ShowMenuScene()
    end
end

local function recheckLater() -- Line: 1164 -- upvalues: showIfNeeded (val)
    task.delay(0.1, showIfNeeded)
end

function u0.Initialize() -- Line: 1168
    -- upvalues: DataController (val), LocalPlayer (val), applyGlobalShadowsSetting (val), updateMenuMusicVolume (val)
    -- upvalues: shouldShowMenuScene (val), u0 (val), u52 (ref), ReplicatedStorage (val), CharacterResolver (val)
    -- upvalues: showIfNeeded (val), Observers (val), recheckLater (val), u113 (ref), u114 (ref), u115 (ref)
    -- upvalues: attachWeaponToCharacter (val), attachGlovesToCharacter (val), configureMenuDisplayCharacter (val)
    -- upvalues: u117 (val)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", applyGlobalShadowsSetting)
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume", updateMenuMusicVolume)
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateMenuMusicVolume)
    if shouldShowMenuScene() then
        u0.ShowMenuScene()
    end
    task.defer(function() -- Line: 1175 -- upvalues: u52 (upval), ReplicatedStorage (upval)
        if not u52 then
            u52 = require(ReplicatedStorage.Controllers.EndScreenController)
        end
    end)
    CharacterResolver.observeCharacter(LocalPlayer, function(a1, a2) -- Line: 1181
        -- upvalues: showIfNeeded (upval), shouldShowMenuScene (upval), u0 (upval)
        if a2 and a2 ~= a1 then
            task.delay(0.1, showIfNeeded)
        end
        if not a1 then
            return function() end
        end
        if not shouldShowMenuScene() then
            u0.StopMenuMusic()
            u0.HideMenuScene()
        else
            u0.ShowMenuScene()
        end
        local u27 = (a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 1197 -- upvalues: a1 (val), showIfNeeded (upval)
            if a1:GetAttribute("Dead") == true then
                task.delay(0.1, showIfNeeded)
            end
        end)
        return function() -- Line: 1203 -- upvalues: u27 (val)
            u27:Disconnect()
        end
    end)
    Observers.observeAttribute(LocalPlayer, "IsSpectating", function(a1) -- Line: 1208 -- upvalues: u0 (upval), shouldShowMenuScene (upval), showIfNeeded (upval)
        if a1 then
            u0.HideMenuScene()
        elseif shouldShowMenuScene() then
            u0.ShowMenuScene()
        end
        return showIfNeeded
    end)
    Observers.observeAttribute(LocalPlayer, "Team", function(a1) -- Line: 1219 -- upvalues: u0 (upval), shouldShowMenuScene (upval), recheckLater (upval)
        if a1 == "Counter-Terrorists" or a1 == "Terrorists" then
            u0.HideMenuScene()
        elseif shouldShowMenuScene() then
            u0.ShowMenuScene()
        end
        return recheckLater
    end)
    local u49 = DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1230
        -- upvalues: u113 (upval), u114 (upval), u115 (upval), attachWeaponToCharacter (upval)
        -- upvalues: attachGlovesToCharacter (upval), configureMenuDisplayCharacter (upval)
        if u113 and u114 then
            if u115 and u115.Parent then
                u115:Destroy()
                u115 = nil
            end
            local RightHand = u113:FindFirstChild("RightHand")
            if RightHand then
                local WeaponAttachment = RightHand:FindFirstChild("WeaponAttachment")
                if WeaponAttachment then
                    WeaponAttachment:Destroy()
                end
            end
            local CharacterArmor = u113:FindFirstChild("CharacterArmor")
            if CharacterArmor then
                for i, v in ipairs(CharacterArmor:GetChildren()) do
                    if v:IsA("BasePart") and v:FindFirstChild("GloveAttachment") then
                        v:Destroy()
                    end
                end
            end
            u115 = attachWeaponToCharacter(u113, u114, true)
            attachGlovesToCharacter(u113, u114, true)
            configureMenuDisplayCharacter(u113)
            return
        end
    end)
    u117:Add(function() -- Line: 1262 -- upvalues: DataController (upval), LocalPlayer (upval), u49 (val)
        DataController.RemoveListener(LocalPlayer, "Loadout", u49)
    end, true, "LoadoutListener")
    local GameState = require(ReplicatedStorage.Database.Components.GameState)
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
    GameState.ListenToState(function(a1, a2) -- Line: 1268
        -- upvalues: LocalPlayer (upval), SpectateController (val), shouldShowMenuScene (upval), u0 (upval)
        if a2 == "Game Ending" or a2 == "Map Voting" then
            if LocalPlayer:GetAttribute("IsSpectating") then
                SpectateController.Stop(false, true)
            end
            if shouldShowMenuScene() then
                u0.ShowMenuScene()
            end
        end
    end)
end

function u0.Start() end

return u0