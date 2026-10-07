-- ReplicatedStorage.Controllers.Observers.Character
-- Script path: ReplicatedStorage.Controllers.Observers.Character
-- Decompile time: 12.80 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local CharacterHighlight = require(ReplicatedStorage.Classes.CharacterHighlight)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local Defuser = require(script.Components.Defuser)
local u77 = {}
u77["Counter-Terrorists"] = Color3.fromRGB(25, 80, 170)
u77.Terrorists = Color3.fromRGB(255, 215, 70)
local u88 = {}
local u89 = {}
local u90 = {}

local function AreNameTagsVisible() -- Line: 54
    -- upvalues: SpectateController (val), LocalPlayer (val), BlackMarketSceneController (val)
    local v1
    local v2 = SpectateController.GetPlayer()
    if v2 == nil then
        v1 = not BlackMarketSceneController.IsActive()
    else
        v1 = false
        if v2 == LocalPlayer then
            v1 = not BlackMarketSceneController.IsActive()
        end
    end
    return v1
end

local function GetNameTagDisplayColor(a1, a2) -- Line: 62 -- types: a1: userdata?, a2: userdata
    if a1 then
        local Attribute = a1:GetAttribute("CompetitivePlayerColor")
        if Attribute then
            return Attribute
        end
    end
    return a2
end

local function ApplyNameTagTextColor(a1, a2) -- Line: 74 -- types: a1: userdata, a2: userdata
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
            v.TextColor3 = a2
        end
    end
end

local function RefreshNameTagArrowColors() -- Line: 84
    -- upvalues: u90 (val), u77 (val), Participants (val), ApplyNameTagTextColor (val)
    local Attribute, Attribute_2, v1, v2, v3
    for k, v in pairs(u90) do
        Attribute = k:GetAttribute("Team")
        v1 = if not Attribute then nil else u77[Attribute]
        if v1 then
            v3 = Participants.Character(k)
            if not v3 then
                v2 = v1
            else
                Attribute_2 = v3:GetAttribute("CompetitivePlayerColor")
                v2 = if not Attribute_2 then v1 else Attribute_2
            end
            if v.Arrow.Parent then
                v.Arrow.Arrow.ImageColor3 = v2
            end
            if v.NameTag.Parent then
                ApplyNameTagTextColor(v.NameTag, v2)
            end
        end
    end
end

;(workspace:GetAttributeChangedSignal("ServerGamemode")):Connect(RefreshNameTagArrowColors)

local function CleanupNameTagJanitor(a1) -- Line: 104
    -- upvalues: u89 (val), RefreshNameTagArrowColors (val)
    if u89[a1] then
        u89[a1]:Destroy()
        u89[a1] = nil
        RefreshNameTagArrowColors()
    end
end

local function GetParticipantCharacter(a1) -- Line: 115
    -- upvalues: CharacterResolver (val), Participants (val)
    if a1:IsA("Player") then
        return CharacterResolver.getPlayerCharacter(a1)
    end
    return Participants.Character(a1)
end

local function getCharacterHealthText(a1) -- Line: 124 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    return (("%*%%"):format((math.ceil((CharacterResolver.getHealth(a1)) / (math.max(CharacterResolver.getMaxHealth(a1), 1)) * 100))))
end

local function CreateNameTag(a1, a2, a3) -- Line: 132
    -- upvalues: u77 (val), CharacterResolver (val), u89 (val), RefreshNameTagArrowColors (val), Janitor (val)
    -- upvalues: ReplicatedStorage (val), PlayerGui (val), Participants (val), ApplyNameTagTextColor (val)
    -- upvalues: HttpService (val), Observers (val), GetWeaponProperties (val), u90 (val), SpectateController (val)
    -- upvalues: LocalPlayer (val), BlackMarketSceneController (val)
    local u4 = u77[a3]
    if not u4 then
        return nil
    end
    local v1 = CharacterResolver.getHead(a2)
    if v1 then
        local v2 = workspace
        if a2:IsDescendantOf(v2) then
            local v3
            if u89[a1] then
                u89[a1]:Destroy()
                u89[a1] = nil
                RefreshNameTagArrowColors()
            end
            local v4 = Janitor.new()
            local u38 = v4:Add((ReplicatedStorage.Assets.Other.Character.Arrow:Clone()))
            if not a2 then
                v2 = u4
            else
                local Attribute = a2:GetAttribute("CompetitivePlayerColor")
                v2 = if not Attribute then u4 else Attribute
            end
            u38.Arrow.ImageColor3 = v2
            u38.Adornee = v1
            u38.Parent = PlayerGui
            local u68 = v4:Add((ReplicatedStorage.Assets.Other.Character.NameTag:Clone()))
            u68.Info.PlayerName.Text = ("%*"):format((Participants.DisplayName(a1)))
            u68.Info.Weapons.Bomb.Visible = false
            u68.Adornee = v1
            u68.Parent = PlayerGui
            u68.Info.Health.Text = ("%*%%"):format((math.ceil((CharacterResolver.getHealth(a2)) / (math.max(CharacterResolver.getMaxHealth(a2), 1)) * 100)))
            ApplyNameTagTextColor(u68, v2)
            v4:Add(((a2:GetAttributeChangedSignal("CompetitivePlayerColor")):Connect(function() -- Line: 167 -- upvalues: a2 (val), u4 (val), u38 (val), u68 (val), ApplyNameTagTextColor (upval)
                local v1
                local v2 = a2
                local v3 = u4
                if not v2 then
                    v1 = v3
                else
                    local Attribute = v2:GetAttribute("CompetitivePlayerColor")
                    v1 = if not Attribute then v3 else Attribute
                end
                if u38.Parent and u38:FindFirstChild("Arrow") then
                    u38.Arrow.ImageColor3 = v1
                end
                if u68.Parent then
                    ApplyNameTagTextColor(u68, v1)
                end
            end)))

            local function updateHealthText() -- Line: 177 -- upvalues: u68 (val), a2 (val), CharacterResolver (upval)
                if u68.Parent and u68:FindFirstChild("Info") then
                    local v1 = a2
                    u68.Info.Health.Text = ("%*%%"):format((math.ceil((CharacterResolver.getHealth(v1)) / (math.max(CharacterResolver.getMaxHealth(v1), 1)) * 100)))
                end
            end

            v4:Add(((a2:GetAttributeChangedSignal("Health")):Connect(updateHealthText)))
            v4:Add(((a2:GetAttributeChangedSignal("MaxHealth")):Connect(updateHealthText)))

            local function updateBombIcon(a1, a2) -- Line: 186 -- upvalues: u68 (val)
                local v1 = false
                if a2 ~= nil then
                    v1 = a2.Weapon == "C4"
                end
                local v2 = false
                if a1 ~= nil then
                    v2 = a1.Name == "C4"
                end
                local v3 = v1 and not v2
                u68.Info.Weapons.Bomb.Visible = v3
            end

            local function decodeAttribute(a1_2) -- Line: 192
                -- upvalues: a1 (val), HttpService (upval)
                local Attribute = a1:GetAttribute(a1_2)
                if Attribute then
                    return (HttpService:JSONDecode(Attribute))
                end
                return nil
            end

            v4:Add((Observers.observeAttribute(a1, "CurrentEquipped", function(a1_2) -- Line: 197 -- upvalues: u68 (val), HttpService (upval), GetWeaponProperties (upval), a1 (val)
                if u68.Parent and u68:FindFirstChild("Info") then
                    local v1
                    local v2 = HttpService:JSONDecode(a1_2 or "[]")
                    local Gun = u68.Info.Weapons.Gun
                    if not v2 or not v2.Name then
                        Gun.Visible = false
                    else
                        v1 = GetWeaponProperties(v2.Name)
                        Gun.Image = v1 and v1.Icon or ""
                        Gun.Visible = v1 or false
                    end
                    local Attribute = a1:GetAttribute("Slot5")
                    v1 = if not Attribute then nil else HttpService:JSONDecode(Attribute)
                    local v3 = false
                    if v1 ~= nil then
                        v3 = v1.Weapon == "C4"
                    end
                    local v4 = false
                    if v2 ~= nil then
                        v4 = v2.Name == "C4"
                    end
                    local v5 = v3 and not v4
                    u68.Info.Weapons.Bomb.Visible = v5
                    return function() -- Line: 213 -- upvalues: u68 (upval)
                        if u68:FindFirstChild("Info") then
                            u68.Info.Weapons.Gun.Visible = false
                        end
                    end
                end
                return function() end
            end)))
            v4:Add((Observers.observeAttribute(a1, "Slot5", function(a1_2) -- Line: 220 -- upvalues: u68 (val), a1 (val), HttpService (upval)
                if u68.Parent and u68:FindFirstChild("Info") then
                    local Attribute = a1:GetAttribute("CurrentEquipped")
                    local v1 = if not Attribute then nil else HttpService:JSONDecode(Attribute)
                    local v2 = HttpService:JSONDecode(a1_2 or "[]")
                    local v3 = false
                    if v2 ~= nil then
                        v3 = v2.Weapon == "C4"
                    end
                    local v4 = false
                    if v1 ~= nil then
                        v4 = v1.Name == "C4"
                    end
                    local v5 = v3 and not v4
                    u68.Info.Weapons.Bomb.Visible = v5
                    return function() -- Line: 227 -- upvalues: u68 (upval)
                        if u68:FindFirstChild("Info") then
                            u68.Info.Weapons.Bomb.Visible = false
                        end
                    end
                end
                return function() end
            end)))
            u89[a1] = v4
            u90[a1] = {Arrow = u38, NameTag = u68}
            local v5 = SpectateController.GetPlayer()
            if v5 == nil then
                v3 = not BlackMarketSceneController.IsActive()
            else
                v3 = false
                if v5 == LocalPlayer then
                    v3 = not BlackMarketSceneController.IsActive()
                end
            end
            u38.Enabled = v3
            u68.Enabled = v3
            v4:Add(function() -- Line: 243 -- upvalues: u90 (upval), a1 (val)
                u90[a1] = nil
            end)

            local function cleanupIfCharacterBecameStale() -- Line: 247
                -- upvalues: a1 (val), CharacterResolver (upval), Participants (upval), a2 (val), u89 (upval)
                -- upvalues: RefreshNameTagArrowColors (upval)
                local v1 = true
                local v2 = a1
                if (if not v2:IsA("Player") then Participants.Character(v2) else CharacterResolver.getPlayerCharacter(v2)) == a2 then
                    v1 = not a2:IsDescendantOf(workspace) or not CharacterResolver.isAliveCharacter(a2)
                end
                if v1 then
                    local v3 = a1
                    if u89[v3] then
                        u89[v3]:Destroy()
                        u89[v3] = nil
                        RefreshNameTagArrowColors()
                    end
                end
            end

            v4:Add(((a2:GetAttributeChangedSignal("Dead")):Connect(cleanupIfCharacterBecameStale)))
            v4:Add(((a2:GetAttributeChangedSignal("Health")):Connect(cleanupIfCharacterBecameStale)))
            v4:Add((a2.AncestryChanged:Connect(cleanupIfCharacterBecameStale)))
            RefreshNameTagArrowColors()
            return v4
        end
    end
    return nil
end

local function ReleaseCameraToMenu() -- Line: 267 -- upvalues: SpectateController (val), CameraController (val)
    if SpectateController.IsTakingOverCamera() then
        return
    end
    CameraController.setPerspective(false, true)
end

local function characterAdded(a1) -- Line: 277
    -- upvalues: CameraController (val), ReleaseCameraToMenu (val), BlackMarketSceneController (val)
    -- upvalues: InputController (val)
    CameraController.setPerspective(true, false)
    a1:Add(ReleaseCameraToMenu)
    if not BlackMarketSceneController.IsActive() then
        InputController.enableGroup("Gameplay")
    end
    a1:Add(function() -- Line: 285 -- upvalues: InputController (upval)
        InputController.disableGroup("Gameplay")
    end)
end

local function RefreshNameTagVisibility() -- Line: 292
    -- upvalues: SpectateController (val), LocalPlayer (val), BlackMarketSceneController (val), u90 (val)
    local v1
    local v2 = SpectateController.GetPlayer()
    if v2 == nil then
        v1 = not BlackMarketSceneController.IsActive()
    else
        v1 = false
        if v2 == LocalPlayer then
            v1 = not BlackMarketSceneController.IsActive()
        end
    end
    for k, v in pairs(u90) do
        v.Arrow.Enabled = v1
        v.NameTag.Enabled = v1
    end
end

SpectateController.ListenToSpectate:Connect(RefreshNameTagVisibility)
BlackMarketSceneController.OnActiveChanged:Connect(RefreshNameTagVisibility)

local function observeRemoteCharacter(a1, a2, a3) -- Line: 306
    -- upvalues: CharacterController (val), Janitor (val), u89 (val), RefreshNameTagArrowColors (val)
    -- upvalues: CharacterResolver (val), Defuser (val), CharacterHighlight (val), LocalPlayer (val)
    -- upvalues: SpectateController (val), BlackMarketSceneController (val), Observers (val), CreateNameTag (val)
    local u27
    local u7 = not a1:IsA("Player")
    local Attribute = a1:GetAttribute("Team")
    if Attribute == "Counter-Terrorists" then
        u27 = Color3.fromRGB(0, 75, 200)
        if not u27 then
            if Attribute ~= "Terrorists" then
                u27 = Color3.fromRGB(255, 255, 255)
            else
                u27 = Color3.fromRGB(255, 220, 50)
                if not u27 then
                    u27 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    elseif Attribute ~= "Terrorists" then
        u27 = Color3.fromRGB(255, 255, 255)
    else
        u27 = Color3.fromRGB(255, 220, 50)
        if not u27 then
            u27 = Color3.fromRGB(255, 255, 255)
        end
    end
    if not u7 then
        CharacterController.TrackCharacter(a1, a2)
        a3:Add(function() -- Line: 318 -- upvalues: CharacterController (upval), a1 (val), a2 (val)
            CharacterController.UntrackCharacter(a1, a2)
        end)
    end
    local Attribute_2 = workspace:GetAttribute("Gamemode")
    local u59 = true
    if Attribute ~= "Terrorists" then
        u59 = Attribute == "Counter-Terrorists"
    end
    local u64 = u59
    if u64 then
        u64 = Attribute_2 ~= "Deathmatch"
    end
    local u67 = Janitor.new()
    a3:Add(function() -- Line: 327 -- upvalues: u67 (ref), a1 (val), u89 (upval), RefreshNameTagArrowColors (upval)
        u67:Destroy()
        local v1 = a1
        if u89[v1] then
            u89[v1]:Destroy()
            u89[v1] = nil
            RefreshNameTagArrowColors()
        end
    end)

    local function rebuildRemoteVisuals() -- Line: 332
        -- upvalues: u67 (ref), Janitor (upval), a2 (val), CharacterResolver (upval), a1 (val), u89 (upval)
        -- upvalues: RefreshNameTagArrowColors (upval), u7 (val), Defuser (upval), u59 (val), Attribute_2 (val)
        -- upvalues: CharacterHighlight (upval), u27 (val), LocalPlayer (upval), SpectateController (upval)
        -- upvalues: BlackMarketSceneController (upval), Observers (upval), Attribute (val), u64 (val)
        -- upvalues: CreateNameTag (upval)
        u67:Destroy()
        u67 = Janitor.new()
        if a2:GetAttribute("Dead") ~= true and CharacterResolver.isAliveCharacter(a2) then
            if not u7 then
                local u21 = Defuser.new(a1, a2)
                u67:Add(function() -- Line: 343 -- upvalues: u21 (val)
                    u21:Destroy()
                end)
            end
            if u59 then
                local Occluded = if Attribute_2 ~= "Deathmatch" then Enum.HighlightDepthMode.AlwaysOnTop else Enum.HighlightDepthMode.Occluded
                local u46 = u67:Add((CharacterHighlight.new(a2, {
                    OutlineTransparency = 0.4,
                    FillTransparency = 0.7,
                    DepthMode = Occluded,
                    FillColor = Color3.fromRGB(255, 255, 255),
                    OutlineColor = u27,
                })))

                local function updateHighlightVisible() -- Line: 360
                    -- upvalues: a2 (upval), a1 (upval), LocalPlayer (upval), SpectateController (upval), u46 (val)
                    -- upvalues: BlackMarketSceneController (upval)
                    if not a2.Parent then
                        return
                    end
                    local Attribute = workspace:GetAttribute("Gamemode")
                    local Attribute_2 = workspace:GetAttribute("GameState")
                    local Attribute_3 = a1:GetAttribute("Team")
                    local v1 = a2:GetAttribute("Dead") == true
                    local v2 = a1:GetAttribute("Invincible") == true
                    local v3 = LocalPlayer:GetAttribute("IsSpectating") == true
                    local v4 = SpectateController.GetPlayer()
                    local Attribute_4 = v4 and v4:GetAttribute("Team")
                    local v5 = SpectateController.GetCurrentSpectateInstance()
                    local v6 = false
                    if v5 ~= nil then
                        v6 = v5.PerspectiveState == "First-Person"
                    end
                    local v7 = v4 == a1
                    local v8 = LocalPlayer:GetAttribute("Team") == Attribute_3
                    local v9 = v3 and v6 and v7
                    local v10 = false
                    if Attribute ~= "Deathmatch" then
                        v10 = v3
                        if v10 then
                            v10 = false
                            if Attribute_4 == Attribute_3 then
                                v10 = not v9
                            end
                        end
                    end
                    local v11 = v8 or v3 and Attribute_4 == Attribute_3
                    local v12 = v2
                    if v12 then
                        v12 = not v9
                        if v12 then
                            v12 = true
                            if Attribute ~= "Deathmatch" then
                                v12 = true
                                if Attribute_2 ~= "Warmup" then
                                    v12 = v11
                                end
                            end
                        end
                    end
                    local Occluded = if not v12 then if Attribute ~= "Deathmatch" then Enum.HighlightDepthMode.AlwaysOnTop else Enum.HighlightDepthMode.Occluded else if Attribute_2 ~= "Warmup" then if Attribute ~= "Deathmatch" then Enum.HighlightDepthMode.AlwaysOnTop else Enum.HighlightDepthMode.Occluded else Enum.HighlightDepthMode.Occluded
                    if u46.Highlight and u46.Highlight.Parent then
                        u46.Highlight.DepthMode = Occluded
                    end
                    if not v1 and not BlackMarketSceneController.IsActive() then
                        u46.OutlineOnly = v10 and not v12
                        u46:UpdateState(v12 or v10)
                        return
                    end
                    u46.OutlineOnly = false
                    u46:UpdateState(false)
                end

                updateHighlightVisible()
                u67:Add(((a1:GetAttributeChangedSignal("Invincible")):Connect(updateHighlightVisible)))
                u67:Add((SpectateController.ListenToSpectate:Connect(function() -- Line: 408 -- upvalues: updateHighlightVisible (val)
                    updateHighlightVisible()
                end)))
                u67:Add((BlackMarketSceneController.OnActiveChanged:Connect(function() -- Line: 411 -- upvalues: updateHighlightVisible (val)
                    updateHighlightVisible()
                end)))
                for i, j in {
                    {LocalPlayer, "IsSpectating"},
                    {LocalPlayer, "SpectatePerspective"},
                    {LocalPlayer, "Team"},
                    {a1, "Team"},
                    {workspace, "GameState"},
                } do
                    u67:Add((Observers.observeAttribute(j[1], j[2], function() -- Line: 415 -- upvalues: updateHighlightVisible (val)
                        updateHighlightVisible()
                        return function() end
                    end)))
                end
            end
            if (LocalPlayer:GetAttribute("Team")) == Attribute and u64 then
                CreateNameTag(a1, a2, Attribute)
                u67:Add(function() -- Line: 434 -- upvalues: a1 (upval), u89 (upval), RefreshNameTagArrowColors (upval)
                    local v1 = a1
                    if u89[v1] then
                        u89[v1]:Destroy()
                        u89[v1] = nil
                        RefreshNameTagArrowColors()
                    end
                end)
            end
            return
        end
        local v1 = a1
        if u89[v1] then
            u89[v1]:Destroy()
            u89[v1] = nil
            RefreshNameTagArrowColors()
        end
    end

    rebuildRemoteVisuals()
    a3:Add(((a2:GetAttributeChangedSignal("Dead")):Connect(rebuildRemoteVisuals)))
    local u110 = a2:IsDescendantOf(workspace)
    a3:Add((a2.AncestryChanged:Connect(function() -- Line: 448 -- upvalues: a2 (val), u110 (ref), rebuildRemoteVisuals (val)
        local v1 = a2:IsDescendantOf(workspace)
        if v1 ~= u110 then
            u110 = v1
            rebuildRemoteVisuals()
        end
    end)))
    if LocalPlayer:GetAttribute("IsSpectating") and not SpectateController.GetCurrentSpectateInstance() then
        SpectateController.Next()
    end
end

local u122 = {}

local function GetBotDescriptor(a1) -- Line: 469 -- upvalues: ReplicatedStorage (val) -- types: a1: userdata
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
    local Attribute = a1:GetAttribute("CombatantId")
    if Combatants and Attribute ~= nil then
        return (Combatants:FindFirstChild((tostring(Attribute))))
    end
    return nil
end

local function BotShellRemoved(a1) -- Line: 475 -- upvalues: u122 (val) -- types: a1: userdata
    local v1 = u122[a1]
    if v1 then
        u122[a1] = nil
        v1:Destroy()
    end
end

local function BotShellAdded(a1) -- Line: 483
    -- upvalues: ReplicatedStorage (val), u122 (val), u88 (val), Janitor (val), u89 (val)
    -- upvalues: RefreshNameTagArrowColors (val), observeRemoteCharacter (val)
    if a1:IsA("Model") and a1:GetAttribute("Bot") == true then
        local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
        local Attribute = a1:GetAttribute("CombatantId")
        local u25 = if not Combatants or Attribute == nil then nil else Combatants:FindFirstChild((tostring(Attribute)))
        if not u25 then
            return
        end
        local v1 = u122[a1]
        if v1 then
            u122[a1] = nil
            v1:Destroy()
        end
        if u88[u25] then
            u88[u25]:Destroy()
        end
        local u46 = Janitor.new()
        u122[a1] = u46
        u88[u25] = u46
        u46:Add(function() -- Line: 500 -- upvalues: u88 (upval), u25 (val), u46 (val)
            if u88[u25] == u46 then
                u88[u25] = nil
            end
        end)
        if u89[u25] then
            u89[u25]:Destroy()
            u89[u25] = nil
            RefreshNameTagArrowColors()
        end
        observeRemoteCharacter(u25, a1, u46)
        return
    end
end

local u126 = false

local function BindBotCharacters(a1) -- Line: 511
    -- upvalues: u126 (ref), BotShellAdded (val), BotShellRemoved (val)
    if u126 then
        return
    end
    u126 = true
    a1.ChildAdded:Connect(BotShellAdded)
    a1.ChildRemoved:Connect(BotShellRemoved)
    for i, j in a1:GetChildren() do
        task.spawn(BotShellAdded, j)
    end
end

local Characters = workspace:FindFirstChild("Characters")
if not Characters then
    local u136 = nil
    local v1 = workspace.ChildAdded:Connect(function(a1) -- Line: 528 -- upvalues: BindBotCharacters (val), u136 (ref)
        if a1.Name == "Characters" then
            BindBotCharacters(a1)
            if u136 then
                u136:Disconnect()
            end
        end
    end)
else
    BindBotCharacters(Characters)
end
return (Observers.observeCharacter(function(a1, a2) -- Line: 541
    -- upvalues: u88 (val), Janitor (val), u89 (val), RefreshNameTagArrowColors (val), LocalPlayer (val)
    -- upvalues: characterAdded (val), SpectateController (val), CameraController (val), InputController (val)
    -- upvalues: Participants (val), CreateNameTag (val), observeRemoteCharacter (val)
    if u88[a1] then
        u88[a1]:Destroy()
        u88[a1] = nil
    end
    local u133 = Janitor.new()
    u88[a1] = u133
    if u89[a1] then
        u89[a1]:Destroy()
        u89[a1] = nil
        RefreshNameTagArrowColors()
    end
    if LocalPlayer ~= a1 then
        observeRemoteCharacter(a1, a2, u133)
    else
        local Attribute, Attribute_2, v1
        characterAdded(u133)
        u133:Add(((a2:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 555
            -- upvalues: a2 (val), SpectateController (upval), CameraController (upval), InputController (upval)
            if a2:GetAttribute("Dead") == true then
                if not SpectateController.IsTakingOverCamera() then
                    CameraController.setPerspective(false, true)
                end
                InputController.disableGroup("Gameplay")
            end
        end)))
        for k in pairs(u89) do
            if u89[k] then
                u89[k]:Destroy()
                u89[k] = nil
                RefreshNameTagArrowColors()
            end
        end
        for i, v in ipairs(Participants.GetAll()) do
            if v ~= LocalPlayer then
                v1 = Participants.Character(v)
                if v1 and v1:IsDescendantOf(workspace) then
                    Attribute = LocalPlayer:GetAttribute("Team")
                    Attribute_2 = v:GetAttribute("Team")
                    if Attribute == Attribute_2 then
                        if Attribute_2 == "Terrorists" then
                            if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                                CreateNameTag(v, v1, Attribute_2)
                                if u88[v] then
                                    u88[v]:Add(function() -- Line: 582 -- upvalues: v (val), u89 (upval), RefreshNameTagArrowColors (upval)
                                        local v1 = v
                                        if u89[v1] then
                                            u89[v1]:Destroy()
                                            u89[v1] = nil
                                            RefreshNameTagArrowColors()
                                        end
                                    end)
                                end
                            end
                        elseif Attribute_2 == "Counter-Terrorists"
                            and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                            CreateNameTag(v, v1, Attribute_2)
                            if u88[v] then
                                u88[v]:Add(function() -- Line: 582 -- upvalues: v (val), u89 (upval), RefreshNameTagArrowColors (upval)
                                    local v1 = v
                                    if u89[v1] then
                                        u89[v1]:Destroy()
                                        u89[v1] = nil
                                        RefreshNameTagArrowColors()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
    return function() -- Line: 593 -- upvalues: u133 (val)
        u133:Destroy()
    end
end))