-- ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo
-- Decompile time: 19.86 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors)
require(ReplicatedStorage.Database.Custom.Types)
local u60 = TweenInfo.new(0.66, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local u61 = {"Slot1", "Slot2", "Slot3"}
local u65 = {}
local u66 = {}
local u67 = {}
local u68 = {}
local u69 = {}
local u70 = false
local LocalPlayer = Players.LocalPlayer

local function commaNumber(a1) -- Line: 54 -- types: a1: number
    return tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function getItemProperties(a1, a2) -- Line: 58
    -- upvalues: ReplicatedStorage (val)
    local v1 = ReplicatedStorage.Database.Custom:FindFirstChild(a1) or ReplicatedStorage.Database.Custom.GameStats:FindFirstChild(a1)
    if v1 and v1:IsA("Folder") then
        local v2 = v1:FindFirstChild(a2)
        if v2 and v2:IsA("ModuleScript") then
            local success, result = pcall(require, v2)
            if success and result then
                return result
            end
            return nil
        end
        return nil
    end
    return nil
end

local function playerHasBomb(a1) -- Line: 74 -- upvalues: HttpService (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("Slot5")
    if not Attribute then
        return false
    end
    local v1 = HttpService:JSONDecode(Attribute)
    return v1 and v1.Weapon == "C4"
end

local function decodeTableAttribute(a1) -- Line: 85 -- upvalues: HttpService (val)
    if typeof(a1) == "string" and a1 ~= "" then
        local success, result = pcall(function() -- Line: 90 -- upvalues: HttpService (upval), a1 (val)
            return HttpService:JSONDecode(a1)
        end)
        if success and typeof(result) == "table" then
            return result
        end
        return nil
    end
    return nil
end

local function parseArmorAttribute(a1) -- Line: 96 -- upvalues: HttpService (val)
    local v1
    if typeof(a1) ~= "string" then
        v1 = nil
    elseif a1 ~= "" then
        local success, result = pcall(function() -- Line: 90 -- upvalues: HttpService (upval), a1 (val)
            return HttpService:JSONDecode(a1)
        end)
        v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
    else
        v1 = nil
    end
    if not v1 then
        return nil
    end
    return {Type = tostring(v1.Type) or "", Health = tonumber(v1.Health) or 0}
end

local function getWeaponNameFromSlotAttribute(a1) -- Line: 108 -- upvalues: HttpService (val)
    local v1
    if typeof(a1) ~= "string" then
        v1 = nil
    elseif a1 ~= "" then
        local success, result = pcall(function() -- Line: 90 -- upvalues: HttpService (upval), a1 (val)
            return HttpService:JSONDecode(a1)
        end)
        v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
    else
        v1 = nil
    end
    local Weapon = v1 and v1.Weapon
    if typeof(Weapon) == "string" and Weapon ~= "" then
        return Weapon
    end
    return nil
end

local function setChildVisible(a1, a2, a3) -- Line: 114 -- types: a1: userdata?, a2: string, a3: boolean
    local v1 = a1 and a1:FindFirstChild(a2)
    if v1 then
        v1.Visible = a3
    end
end

local function getTemplateHealthParts(a1) -- Line: 121 -- types: a1: userdata
    local Health = a1:FindFirstChild("Health")
    return Health, Health and Health:FindFirstChild("Bar")
end

local function setTemplateLifeState(a1, a2) -- Line: 127 -- types: a1: userdata, a2: boolean
    local Health = a1:FindFirstChild("Health")
    local Bar = Health and Health:FindFirstChild("Bar")
    local v1 = Health
    local v2 = Bar
    local PlayerBackground = a1:FindFirstChild("PlayerBackground")
    local Player = PlayerBackground and PlayerBackground:FindFirstChild("Player")
    local X = Player and Player:FindFirstChild("X")
    local Info = a1:FindFirstChild("Info")
    if not a2 then
        if Player then
            Player.ImageTransparency = 0
        end
        if X then
            X.Visible = false
        end
        if Info then
            Info.BackgroundTransparency = 0
        end
        if PlayerBackground then
            PlayerBackground.Transparency = 0
        end
        return v1, v2
    end
    if v2 then
        v2.Size = UDim2.fromScale(0, 1)
    end
    if v1 then
        v1.Visible = false
    end
    if Player then
        Player.ImageTransparency = 0.5
    end
    if X then
        X.Visible = true
    end
    if Info then
        Info.BackgroundTransparency = 0.75
        local Weapon = Info and Info:FindFirstChild("Weapon")
        if Weapon then
            Weapon.Visible = false
        end
        local Grenades = Info and Info:FindFirstChild("Grenades")
        if Grenades then
            Grenades.Visible = false
        end
        local Items = Info and Info:FindFirstChild("Items")
        if Items then
            Items.Visible = false
        end
    end
    if not PlayerBackground then
        return v1, v2
    end
    PlayerBackground.Transparency = 0.5
    return v1, v2
end

local function updateTemplateGrenades(a1, a2) -- Line: 179
    -- upvalues: u67 (val), getItemProperties (val)
    local v1, v2, v3
    local Info = a1:FindFirstChild("Info")
    if not Info then
        return
    end
    local Grenades = Info:FindFirstChild("Grenades")
    if not Grenades then
        return
    end
    local v4 = u67[a2] or {}
    for i = 1, 4 do
        v2 = Grenades:FindFirstChild((tostring(i)))
        if v2 then
            v3 = v4[i]
            if not v3 then
                v2.Image = ""
                v2.Visible = false
            else
                v1 = getItemProperties("Weapons", v3)
                v2.Image = v1 and v1.Icon or ""
                v2.Visible = true
            end
        end
    end
    Grenades.Visible = true
end

local function isTeammate(a1) -- Line: 209 -- upvalues: LocalPlayer (val) -- types: a1: userdata
    local Attribute = LocalPlayer:GetAttribute("Team")
    if not Attribute then
        return false
    end
    return Attribute == a1:GetAttribute("Team")
end

local function summarizeDamageArray(a1) -- Line: 217 -- types: a1: table?
    if a1 and #a1 ~= 0 then
        local v1 = 0
        local v2 = #a1
        for i, j in a1 do
            v1 = v1 + j
        end
        return v1, v2
    end
    return nil, nil
end

local function setDamageLabel(a1, a2, a3) -- Line: 233 -- types: a1: userdata?, a2: number?, a3: number?
    if not a1 then
        return
    end
    a1.Text = if not a2 then "" else ("%* in %*"):format(math.min(a2, 100), a3)
    a1.Visible = a2 ~= nil
end

local function updateDamageFromMatrix(a1, a2, a3) -- Line: 241 -- types: a1: userdata?, a2: table?, a3: table?
    if a1 and a1.Parent then
        local v1, v2, v3, v4, v5
        local Info = a1:FindFirstChild("Info")
        if not Info then
            return
        end
        local Damages = Info:FindFirstChild("Damages")
        if not Damages then
            return
        end
        if not a2 then
            v1 = nil
            v2 = nil
        elseif #a2 ~= 0 then
            v3 = 0
            v4 = #a2
            for i, j in a2 do
                v3 = v3 + j
            end
            v1 = v3
            v2 = v4
        else
            v1 = nil
            v2 = nil
        end
        if not a3 then
            v3 = nil
            v4 = nil
        elseif #a3 ~= 0 then
            v5 = 0
            local v6 = #a3
            for k, n in a3 do
                v5 = v5 + n
            end
            v3 = v5
            v4 = v6
        else
            v3 = nil
            v4 = nil
        end
        v5 = true
        if v1 == nil then
            v5 = v3 ~= nil
        end
        Damages.Visible = v5
        local Outgoing = Damages:FindFirstChild("Outgoing")
        if Outgoing then
            Outgoing.Text = if not v1 then "" else ("%* in %*"):format(math.min(v1, 100), v2)
            Outgoing.Visible = v1 ~= nil
        end
        local Incoming = Damages:FindFirstChild("Incoming")
        if not Incoming then
            return
        end
        Incoming.Text = if not v3 then "" else ("%* in %*"):format(math.min(v3, 100), v4)
        Incoming.Visible = v3 ~= nil
        return
    end
end

local function setTemplateKills(a1, a2) -- Line: 265 -- types: a1: userdata, a2: number
    local v1
    local Kills = a1:FindFirstChild("Kills")
    if not Kills then
        return
    end
    for i = 1, 5 do
        v1 = Kills:FindFirstChild((tostring(i)))
        if v1 then
            v1.Visible = i <= a2
        end
    end
end

local function hideTeammateOnlyInfo(a1) -- Line: 279 -- types: a1: userdata
    local v1
    local DefuseKit = a1 and a1:FindFirstChild("DefuseKit")
    if DefuseKit then
        DefuseKit.Visible = false
    end
    local Bomb = a1 and a1:FindFirstChild("Bomb")
    if Bomb then
        Bomb.Visible = false
    end
    local Info = a1:FindFirstChild("Info")
    for i, v in ipairs({"Weapon", "Cash", "Items", "Grenades"}) do
        v1 = Info and Info:FindFirstChild(v)
        if v1 then
            v1.Visible = false
        end
    end
end

local function getCompetitiveStroke(a1) -- Line: 289 -- types: a1: userdata
    local PlayerBackground = a1:FindFirstChild("PlayerBackground")
    return PlayerBackground and PlayerBackground:FindFirstChildOfClass("UIStroke")
end

local function ensureDefaultStrokeColor(a1) -- Line: 294 -- types: a1: userdata
    local Attribute = a1:GetAttribute("DefaultStrokeColor")
    if not Attribute then
        a1:SetAttribute("DefaultStrokeColor", a1.Color)
    end
    return Attribute or a1.Color
end

local function refreshCompetitiveStrokeColorForPlayer(a1) -- Line: 304
    -- upvalues: u65 (val), Participants (val), LocalPlayer (val)
    local v1 = u65[Participants.Key(a1)]
    if v1 and v1.Parent then
        local PlayerBackground = v1:FindFirstChild("PlayerBackground")
        local v2 = PlayerBackground and PlayerBackground:FindFirstChildOfClass("UIStroke")
        if not v2 then
            return
        end
        local Attribute = v2:GetAttribute("DefaultStrokeColor")
        if not Attribute then
            v2:SetAttribute("DefaultStrokeColor", v2.Color)
        end
        local Color = Attribute or v2.Color
        local Attribute_2 = LocalPlayer:GetAttribute("Team")
        if not (if Attribute_2 then Attribute_2 == a1:GetAttribute("Team") else false) then
            v2.Color = Color
            return
        end
        v2.Color = a1:GetAttribute("CompetitivePlayerColor") or Color
        return
    end
end

local function shouldShowInfoForPlayer(a1) -- Line: 326
    -- upvalues: u70 (ref), LocalPlayer (val), u68 (val), Participants (val), u69 (val)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return true
    end
    if workspace:GetAttribute("GameState") ~= "Warmup" and u70 then
        local Attribute = LocalPlayer:GetAttribute("Team")
        if if Attribute then Attribute == a1:GetAttribute("Team") else false then
            return true
        end
        local v1 = u68[Participants.Key(a1)] or 0
        local v2 = u69[Participants.Key(a1)] == true
        local v3 = true
        if not (v1 > 0) then
            v3 = v2
        end
        return v3
    end
    return false
end

local function setTemplateInfoRevealed(a1, a2, a3) -- Line: 344
    -- upvalues: LocalPlayer (val), Participants (val), u66 (val), Janitor (val), u61 (val), HttpService (val)
    -- upvalues: getItemProperties (val), Observers (val), updateTemplateGrenades (val), hideTeammateOnlyInfo (val)
    -- upvalues: TweenService (val), u60 (val)
    if a2 and a2.Parent then
        local v1
        local Info = a2:FindFirstChild("Info")
        if not Info then
            return
        end
        local Attribute_2 = LocalPlayer:GetAttribute("Team")
        local v2 = not Participants.IsAlive(a1)
        local v3 = a1:GetAttribute("IsSpectating") == true
        local v4 = ("%*|%*|%*|%*"):format(a3, if Attribute_2 then Attribute_2 == a1:GetAttribute("Team") else false, v2, v3)
        if Info:GetAttribute("RevealKey") == v4 then
            return
        end
        Info:SetAttribute("RevealKey", v4)
        local v5 = u66[Info]
        if v5 then
            v5:Cleanup()
        else
            v5 = Janitor.new()
            v5:LinkToInstance(a2)
            u66[Info] = v5
        end
        local Attribute_3 = Info:GetAttribute("OriginalSize")
        if not Attribute_3 then
            Info:SetAttribute("OriginalSize", Info.Size)
            if not a3 then
                Info.Size = UDim2.fromScale(1, 0)
            end
        end
        if not a3 then
            v1 = TweenService:Create(Info, u60, {Size = UDim2.fromScale(1, 0)})
            v1:Play()
            v5:Add((v1.Completed:Once(function(a1) -- Line: 454 -- upvalues: Info (val)
                if a1 == Enum.PlaybackState.Completed then
                    Info.Visible = false
                end
            end)))
            return
        end
        local Attribute_4 = LocalPlayer:GetAttribute("Team")
        v1 = if Attribute_4 then Attribute_4 == a1:GetAttribute("Team") else false
        if not v1 then
            hideTeammateOnlyInfo(a2)
        else
            v1 = a1:GetAttribute("IsSpectating") == true
            v2 = Participants.IsAlive(a1) and not v1
            local Weapon = Info:FindFirstChild("Weapon")
            if Weapon then
                local function updateEquippedWeaponImageFromSlots() -- Line: 387
                    -- upvalues: u61 (upval), a1 (val), HttpService (upval), getItemProperties (upval), Weapon (val)
                    local Weapon_2, result, success, v1
                    local v2 = nil
                    for i, v in ipairs(u61) do
                        local Attribute = a1:GetAttribute(v)
                        if typeof(Attribute) ~= "string" then
                            v1 = nil
                        elseif Attribute ~= "" then
                            success, result = pcall(function() -- Line: 90 -- upvalues: HttpService (upval), Attribute (val)
                                return HttpService:JSONDecode(Attribute)
                            end)
                            v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
                        else
                            v1 = nil
                        end
                        Weapon_2 = v1 and v1.Weapon
                        if if typeof(Weapon_2) ~= "string" then nil else if Weapon_2 == "" then nil else Weapon_2 then
                            break
                        end
                    end
                    local v3 = v2 and getItemProperties("Weapons", v2)
                    Weapon.Image = v3 and v3.Icon or ""
                end

                for i, v in ipairs(u61) do
                    v5:Add(((a1:GetAttributeChangedSignal(v)):Connect(updateEquippedWeaponImageFromSlots)))
                end
                updateEquippedWeaponImageFromSlots()
                Weapon.Visible = v2
            end
            local Cash = Info:FindFirstChild("Cash")
            if Cash then
                v5:Add((Observers.observeAttribute(a1, "Money", function(a1) -- Line: 410 -- upvalues: Cash (val)
                    local v1 = a1 and ("$%*"):format((tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))) or ""
                    Cash.Text = v1
                    return nil
                end)))
                Cash.Visible = true
            end
            local Items = Info:FindFirstChild("Items")
            if Items then
                local v6, v7
                local Armor = Items:FindFirstChild("Armor")
                if Armor then
                    v5:Add(((a1:GetAttributeChangedSignal("Armor")):Connect(function() -- Line: 422 -- upvalues: a1 (val), HttpService (upval), Armor (val)
                        local v1, v2
                        local Attribute = a1:GetAttribute("Armor")
                        if typeof(Attribute) ~= "string" then
                            v2 = nil
                        elseif Attribute ~= "" then
                            local success, result = pcall(function() -- Line: 90 -- upvalues: HttpService (upval), Attribute (val)
                                return HttpService:JSONDecode(Attribute)
                            end)
                            v2 = if not success then nil else if typeof(result) ~= "table" then nil else result
                        else
                            v2 = nil
                        end
                        if v2 then
                            v1 = {Type = tostring(v2.Type) or ""}
                            v1.Health = tonumber(v2.Health) or 0
                        else
                            v1 = nil
                        end
                        v2 = false
                        if v1 ~= nil then
                            v2 = 0 < v1.Health
                        end
                        Armor.Visible = v2
                    end)))
                    local Attribute = a1:GetAttribute("Armor")
                    if typeof(Attribute) ~= "string" then
                        v7 = nil
                    elseif Attribute ~= "" then
                        local success, result = pcall(function() -- Line: 90 -- upvalues: HttpService (upval), Attribute (val)
                            return HttpService:JSONDecode(Attribute)
                        end)
                        v7 = if not success then nil else if typeof(result) ~= "table" then nil else result
                    else
                        v7 = nil
                    end
                    if v7 then
                        v6 = {Type = tostring(v7.Type) or ""}
                        v6.Health = tonumber(v7.Health) or 0
                    else
                        v6 = nil
                    end
                    local v8 = false
                    if v6 ~= nil then
                        v8 = 0 < v6.Health
                    end
                    Armor.Visible = v8
                end
                local Bomb = Items:FindFirstChild("Bomb")
                if Bomb then
                    v5:Add(((a1:GetAttributeChangedSignal("Slot5")):Connect(function() -- Line: 433 -- upvalues: Bomb (val), a1 (val), HttpService (upval)
                        local v1
                        local Attribute = a1:GetAttribute("Slot5")
                        if Attribute then
                            local v2 = HttpService:JSONDecode(Attribute)
                            v1 = v2 and v2.Weapon == "C4"
                        else
                            v1 = false
                        end
                        Bomb.Visible = v1
                    end)))
                    local Attribute_5 = a1:GetAttribute("Slot5")
                    if Attribute_5 then
                        v7 = HttpService:JSONDecode(Attribute_5)
                        v6 = v7 and v7.Weapon == "C4"
                    else
                        v6 = false
                    end
                    Bomb.Visible = v6
                end
                Items.Visible = true
            end
            updateTemplateGrenades(a2, Participants.Key(a1))
        end
        Info.Visible = true
        TweenService:Create(Info, u60, {Size = Attribute_3}):Play()
        return
    end
end

local function refreshTemplateInfoVisibilityForPlayer(a1) -- Line: 462
    -- upvalues: u65 (val), Participants (val), setTemplateInfoRevealed (val), shouldShowInfoForPlayer (val)
    local v1 = u65[Participants.Key(a1)]
    if v1 and v1.Parent then
        setTemplateInfoRevealed(a1, v1, (shouldShowInfoForPlayer(a1)))
        return
    end
end

local function refreshAllTemplateInfoVisibility() -- Line: 471
    -- upvalues: u65 (val), Participants (val), setTemplateInfoRevealed (val), shouldShowInfoForPlayer (val)
    local v1, v2
    for i, j in u65 do
        v1 = Participants.FromKey(i)
        if v1 and j and j.Parent then
            v2 = u65[Participants.Key(v1)]
            if v2 and v2.Parent then
                setTemplateInfoRevealed(v1, v2, (shouldShowInfoForPlayer(v1)))
            end
        end
    end
end

local function setupBombDefusalTemplate(a1, a2, a3) -- Line: 480
    -- upvalues: Participants (val), LocalPlayer (val), TweenService (val), setTemplateLifeState (val), u70 (ref)
    -- upvalues: u65 (val), setTemplateInfoRevealed (val), shouldShowInfoForPlayer (val)
    -- upvalues: refreshCompetitiveStrokeColorForPlayer (val), HttpService (val), Observers (val)
    local Attribute_2 = a3:GetAttribute("Team")
    local Attribute = workspace:GetAttribute("Gamemode")

    local function u12() end

    local function getPlayerHealthRatio() -- Line: 485 -- upvalues: a3 (val)
        local Attribute = a3:GetAttribute("Health")
        local Attribute_2 = a3:GetAttribute("MaxHealth")
        if typeof(Attribute) == "number" and typeof(Attribute_2) == "number" and not (Attribute_2 <= 0) then
            return (math.clamp(math.floor(Attribute) / Attribute_2, 0, 1))
        end
        return 0
    end

    local function updateHealthBar(a1) -- Line: 494
        -- upvalues: a2 (val), Participants (upval), a3 (val), LocalPlayer (upval), TweenService (upval)
        local Health = a2:FindFirstChild("Health")
        local Bar = Health and Health:FindFirstChild("Bar")
        local v1 = Health
        local v2 = Bar
        local v3 = Participants.IsAlive(a3) and a3:GetAttribute("IsSpectating") ~= true
        if v3 then
            local Attribute = LocalPlayer:GetAttribute("Team")
            local v4 = if Attribute then Attribute == a3:GetAttribute("Team") else false
            if v4 and v1 and v2 then
                v1.Visible = true
                local fromScale = UDim2.fromScale
                local Attribute_2 = a3:GetAttribute("Health")
                local Attribute_3 = a3:GetAttribute("MaxHealth")
                v4 = fromScale(
                    if typeof(Attribute_2) ~= "number" or typeof(Attribute_3) ~= "number" then 0 else if not (Attribute_3 <= 0) then math.clamp(math.floor(Attribute_2) / Attribute_3, 0, 1) else 0,
                    1
                )
                if a1 then
                    TweenService:Create(v2, TweenInfo.new(0.25), {Size = v4}):Play()
                    return
                end
                v2.Size = v4
                return
            end
        end
    end

    local function updateLifeState() -- Line: 510
        -- upvalues: a2 (val), a3 (val), Participants (upval), setTemplateLifeState (upval), u70 (upval), u65 (upval)
        -- upvalues: setTemplateInfoRevealed (upval), shouldShowInfoForPlayer (upval), LocalPlayer (upval)
        -- upvalues: refreshCompetitiveStrokeColorForPlayer (upval), u12 (ref)
        local v1, v2
        if not a2.Parent then
            return
        end
        local v3 = a3:GetAttribute("IsSpectating") == true
        local v4 = not Participants.IsAlive(a3) or v3
        setTemplateLifeState(a2, v4)
        if not v4 and u70 then
            v1 = a3
            v2 = u65[Participants.Key(v1)]
            if v2 and v2.Parent then
                setTemplateInfoRevealed(v1, v2, (shouldShowInfoForPlayer(v1)))
            end
        end
        local Health = a2:FindFirstChild("Health")
        local Bar = Health and Health:FindFirstChild("Bar")
        v1 = Health
        v2 = Bar
        local v5 = Participants.IsAlive(a3) and a3:GetAttribute("IsSpectating") ~= true
        if v5 then
            local Attribute = LocalPlayer:GetAttribute("Team")
            if (if Attribute then Attribute == a3:GetAttribute("Team") else false) and v1 and v2 then
                v1.Visible = true
                local fromScale = UDim2.fromScale
                local Attribute_2 = a3:GetAttribute("Health")
                local Attribute_3 = a3:GetAttribute("MaxHealth")
                v2.Size = fromScale(
                    if typeof(Attribute_2) ~= "number" or typeof(Attribute_3) ~= "number" then 0 else if not (Attribute_3 <= 0) then math.clamp(math.floor(Attribute_2) / Attribute_3, 0, 1) else 0,
                    1
                )
            end
        end
        refreshCompetitiveStrokeColorForPlayer(a3)
        u12()
    end

    a1:Add(((a3:GetAttributeChangedSignal("Health")):Connect(function() -- Line: 526 -- upvalues: updateLifeState (val), updateHealthBar (val)
        updateLifeState()
        updateHealthBar(true)
    end)))
    a1:Add(((a3:GetAttributeChangedSignal("MaxHealth")):Connect(updateLifeState)))
    a1:Add(((a3:GetAttributeChangedSignal("Dead")):Connect(updateLifeState)))
    a1:Add(((a3:GetAttributeChangedSignal("IsSpectating")):Connect(updateLifeState)))
    a1:Add(((a3:GetAttributeChangedSignal("CompetitivePlayerColor")):Connect(function() -- Line: 533 -- upvalues: refreshCompetitiveStrokeColorForPlayer (upval), a3 (val)
        refreshCompetitiveStrokeColorForPlayer(a3)
    end)))
    updateLifeState()
    if Attribute_2 == "Terrorists" then
        function u12() -- Line: 540
            -- upvalues: a3 (val), LocalPlayer (upval), HttpService (upval), a2 (val), Participants (upval)
            local Attribute = a3:GetAttribute("Team")
            local Attribute_2 = LocalPlayer:GetAttribute("Team")
            local Attribute_3 = a3:GetAttribute("Slot5")
            local v1 = HttpService:JSONDecode(Attribute_3 or "[]")
            local Bomb = a2:FindFirstChild("Bomb")
            if Bomb then
                local v2 = Participants.IsAlive(a3)
                if v2 then
                    v2 = false
                    if Attribute == Attribute_2 then
                        v2 = v1 and v1.Weapon == "C4"
                    end
                end
                Bomb.Visible = v2
            end
        end

        a1:Add((Observers.observeAttribute(a3, "Slot5", function(a1) -- Line: 554 -- upvalues: u12 (ref), a2 (val)
            u12()
            return function() -- Line: 557 -- upvalues: a2 (upval)
                local v1 = a2
                local Bomb = v1 and v1:FindFirstChild("Bomb")
                if Bomb then
                    Bomb.Visible = false
                end
            end
        end)))
        u12()
    elseif Attribute_2 == "Counter-Terrorists" then
        function u12() -- Line: 563
            -- upvalues: LocalPlayer (upval), a3 (val), Attribute (val), a2 (val), Participants (upval)
            local Attribute_2 = LocalPlayer:GetAttribute("Team")
            local Attribute_3 = a3:GetAttribute("Team")
            local v1 = if Attribute ~= "Hostage Rescue" then a3:GetAttribute("HasDefuseKit") == true else a3:GetAttribute("HasRescueKit") == true
            local DefuseKit = a2:FindFirstChild("DefuseKit")
            if DefuseKit then
                local v2 = Participants.IsAlive(a3) and v1 and Attribute_3 == Attribute_2
                DefuseKit.Visible = v2
            end
        end

        local function hideObjectiveKits() -- Line: 579 -- upvalues: a2 (val)
            local v1 = a2
            local DefuseKit = v1 and v1:FindFirstChild("DefuseKit")
            if DefuseKit then
                DefuseKit.Visible = false
            end
        end

        a1:Add((Observers.observeAttribute(a3, "HasDefuseKit", function(a1) -- Line: 583 -- upvalues: u12 (ref), hideObjectiveKits (val)
            u12()
            return hideObjectiveKits
        end)))
        a1:Add((Observers.observeAttribute(a3, "HasRescueKit", function(a1) -- Line: 588 -- upvalues: u12 (ref), hideObjectiveKits (val)
            u12()
            return hideObjectiveKits
        end)))
        u12()
    end
end

local function setupDeathmatchTemplate(a1, a2, a3) -- Line: 597
    -- upvalues: Colors (val), Observers (val)
    local Attribute = a3:GetAttribute("Team")
    local Info = a2:FindFirstChild("Info")
    if Info then
        local UIStroke = Info:FindFirstChild("UIStroke")
        if UIStroke then
            UIStroke.Color = Colors["Team Color"][Attribute]
        end
        local Amount = Info:FindFirstChild("Amount")
        if Amount then
            Amount.Text = "0"
        end
    end
    local UIStroke_2 = a2:FindFirstChild("UIStroke")
    if UIStroke_2 then
        UIStroke_2.Color = Colors["Team Color"][Attribute]
    end
    a1:Add((Observers.observeAttribute(a3, "Score", function(a1) -- Line: 620 -- upvalues: a2 (val)
        local Info = a2:FindFirstChild("Info")
        local Amount = Info and Info:FindFirstChild("Amount")
        if Amount then
            Amount.Text = tostring(a1)
        end
        a2.LayoutOrder = -a1
        return nil
    end)))
end

local function refreshCompetitiveStrokeColors() -- Line: 632
    -- upvalues: u65 (val), Participants (val), refreshCompetitiveStrokeColorForPlayer (val)
    local v1
    for i, j in u65 do
        v1 = Participants.FromKey(i)
        if v1 and j and j.Parent then
            refreshCompetitiveStrokeColorForPlayer(v1)
        end
    end
end

local function destroyCachedTemplate(a1) -- Line: 642 -- upvalues: u65 (val), u66 (val) -- types: a1: number
    local v1 = u65[a1]
    if not v1 then
        return
    end
    local Info = v1:FindFirstChild("Info")
    if Info then
        local v2 = u66[Info]
        if v2 then
            v2:Destroy()
            u66[Info] = nil
        end
    end
    if v1.Parent then
        v1:Destroy()
    end
    u65[a1] = nil
end

function u0.createTemplate(a1, a2) -- Line: 667
    -- upvalues: Participants (val), u65 (val), u66 (val), Janitor (val), ReplicatedStorage (val)
    -- upvalues: setupDeathmatchTemplate (val), LocalPlayer (val), setupBombDefusalTemplate (val)
    -- upvalues: refreshCompetitiveStrokeColors (val), setTemplateInfoRevealed (val), shouldShowInfoForPlayer (val)
    local Attribute_3, Attribute_4, Bomb, Color, Health, Info_2, Player, PlayerBackground, PlayerBackground_2, Size, u84, v1, v2, v3
    local v4 = Participants.Key(a1)
    local v5 = u65[v4]
    if v5 then
        local Info = v5:FindFirstChild("Info")
        if Info then
            local v6 = u66[Info]
            if v6 then
                v6:Destroy()
                u66[Info] = nil
            end
        end
        if v5.Parent then
            v5:Destroy()
        end
        u65[v4] = nil
    end
    local Attribute = workspace:GetAttribute("Gamemode")
    local Attribute_2 = a1:GetAttribute("Team")
    if Attribute_2 ~= "Terrorists" and Attribute_2 ~= "Counter-Terrorists" then
        return nil
    end
    local v7 = Janitor.new()
    if Attribute == "Deathmatch" then
        u84 = ReplicatedStorage.Assets.UI.Deathmatch.PlayerTemplate:Clone()
        if not u84 then
            v7:Destroy()
            return nil
        end
        v2 = u84
        Bomb = v2 and v2:FindFirstChild("Bomb")
        if Bomb then
            Bomb.Visible = false
        end
        Info_2 = u84:FindFirstChild("Info")
        if Info_2 then
            Attribute_3 = Info_2:GetAttribute("OriginalSize")
            Size = Attribute_3 or Info_2.Size
            if not Attribute_3 then
                Info_2:SetAttribute("OriginalSize", Size)
            end
            if Attribute ~= "Deathmatch" then
                Info_2.Size = UDim2.fromScale(1, 0)
                Info_2.Visible = false
            else
                Info_2.Size = Size
                Info_2.Visible = true
            end
            Info_2:SetAttribute("RevealKey", nil)
        end
        PlayerBackground = u84:FindFirstChild("PlayerBackground")
        Player = PlayerBackground and PlayerBackground:FindFirstChild("Player")
        if Player and Player:IsA("ImageLabel") then
            Player.Image = Participants.HeadshotImage(a1, 420)
        end
        u84.Parent = a2
        u65[Participants.Key(a1)] = u84
        PlayerBackground_2 = u84:FindFirstChild("PlayerBackground")
        v3 = PlayerBackground_2 and PlayerBackground_2:FindFirstChildOfClass("UIStroke")
        if v3 then
            Attribute_4 = v3:GetAttribute("DefaultStrokeColor")
            if not Attribute_4 then
                v3:SetAttribute("DefaultStrokeColor", v3.Color)
            end
            if not Attribute_4 then
                Color = v3.Color
            end
        end
        if Attribute ~= "Deathmatch" then
            Health = u84:FindFirstChild("Health")
            if Health then
                Health.Visible = LocalPlayer:GetAttribute("Team") == Attribute_2
            end
            setupBombDefusalTemplate(v7, u84, a1)
            refreshCompetitiveStrokeColors()
            v1 = u65[Participants.Key(a1)]
            if v1 and v1.Parent then
                setTemplateInfoRevealed(a1, v1, (shouldShowInfoForPlayer(a1)))
            end
        else
            setupDeathmatchTemplate(v7, u84, a1)
        end
        v7:Add(function() -- Line: 752 -- upvalues: u84 (ref)
            u84:Destroy()
        end)
        return v7
    end
    if Attribute ~= "Bomb Defusal" and Attribute ~= "Hostage Rescue" then
        v7:Destroy()
        return nil
    end
    v2 = ReplicatedStorage.Assets.UI.BombDefusal:FindFirstChild(Attribute_2)
    if not v2 then
        warn((("[PlayerInfo]: Missing player template for team %*"):format(Attribute_2)))
        v7:Destroy()
        return nil
    end
    u84 = v2:Clone()
    if not u84 then
        v7:Destroy()
        return nil
    end
    v2 = u84
    Bomb = v2 and v2:FindFirstChild("Bomb")
    if Bomb then
        Bomb.Visible = false
    end
    Info_2 = u84:FindFirstChild("Info")
    if Info_2 then
        Attribute_3 = Info_2:GetAttribute("OriginalSize")
        Size = Attribute_3 or Info_2.Size
        if not Attribute_3 then
            Info_2:SetAttribute("OriginalSize", Size)
        end
        if Attribute ~= "Deathmatch" then
            Info_2.Size = UDim2.fromScale(1, 0)
            Info_2.Visible = false
        else
            Info_2.Size = Size
            Info_2.Visible = true
        end
        Info_2:SetAttribute("RevealKey", nil)
    end
    PlayerBackground = u84:FindFirstChild("PlayerBackground")
    Player = PlayerBackground and PlayerBackground:FindFirstChild("Player")
    if Player and Player:IsA("ImageLabel") then
        Player.Image = Participants.HeadshotImage(a1, 420)
    end
    u84.Parent = a2
    u65[Participants.Key(a1)] = u84
    PlayerBackground_2 = u84:FindFirstChild("PlayerBackground")
    v3 = PlayerBackground_2 and PlayerBackground_2:FindFirstChildOfClass("UIStroke")
    if v3 then
        Attribute_4 = v3:GetAttribute("DefaultStrokeColor")
        if not Attribute_4 then
            v3:SetAttribute("DefaultStrokeColor", v3.Color)
        end
        if not Attribute_4 then
            Color = v3.Color
        end
    end
    if Attribute ~= "Deathmatch" then
        Health = u84:FindFirstChild("Health")
        if Health then
            Health.Visible = LocalPlayer:GetAttribute("Team") == Attribute_2
        end
        setupBombDefusalTemplate(v7, u84, a1)
        refreshCompetitiveStrokeColors()
        v1 = u65[Participants.Key(a1)]
        if v1 and v1.Parent then
            setTemplateInfoRevealed(a1, v1, (shouldShowInfoForPlayer(a1)))
        end
    else
        setupDeathmatchTemplate(v7, u84, a1)
    end
    v7:Add(function() -- Line: 752 -- upvalues: u84 (ref)
        u84:Destroy()
    end)
    return v7
end

function u0.cleanupTemplate(a1) -- Line: 759
    -- upvalues: Participants (val), u65 (val), u66 (val), u68 (val), u69 (val), refreshCompetitiveStrokeColors (val)
    local v1 = Participants.Key(a1)
    local v2 = u65[v1]
    if v2 then
        local Info = v2:FindFirstChild("Info")
        if Info then
            local v3 = u66[Info]
            if v3 then
                v3:Destroy()
                u66[Info] = nil
            end
        end
        if v2.Parent then
            v2:Destroy()
        end
        u65[v1] = nil
    end
    u65[v1] = nil
    u68[v1] = nil
    u69[v1] = nil
    refreshCompetitiveStrokeColors()
end

function u0.refreshCompetitiveColors() -- Line: 769 -- upvalues: refreshCompetitiveStrokeColors (val)
    refreshCompetitiveStrokeColors()
end

function u0.applyTemplateLifeState(a1, a2) -- Line: 773
    -- upvalues: setTemplateLifeState (val)
    return setTemplateLifeState(a1, a2)
end

function u0.setTeammateInfoRevealed(a1) -- Line: 777
    -- upvalues: u70 (ref), refreshAllTemplateInfoVisibility (val)
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        a1 = false
    end
    u70 = a1
    refreshAllTemplateInfoVisibility()
end

function u0.updateTeammateGrenades(a1) -- Line: 787
    -- upvalues: u67 (val), Participants (val), u65 (val), updateTemplateGrenades (val)
    local v1, v2, v3
    local v4 = nil
    local v5 = nil
    for i, j in a1, v4, v5 do
        v1 = tonumber(j.userId)
        if v1 then
            u67[v1] = j.grenades or {}
            v2 = Participants.FromKey(v1)
            v3 = u65[v1]
            if v2 and v3 and v3.Parent then
                updateTemplateGrenades(v3, v1)
            end
        end
    end
end

function u0.incrementTemplateKills(a1) -- Line: 805
    -- upvalues: GameState (val), u68 (val), u65 (val), setTemplateKills (val), Participants (val)
    -- upvalues: setTemplateInfoRevealed (val), shouldShowInfoForPlayer (val)
    if GameState.GetState() == "Warmup" then
        return
    end
    u68[a1] = (u68[a1] or 0) + 1
    local v1 = u65[a1]
    if v1 and v1.Parent then
        setTemplateKills(v1, u68[a1])
    end
    local v2 = Participants.FromKey(a1)
    if v2 then
        local v3 = u65[Participants.Key(v2)]
        if v3 then
            if not v3.Parent then
                return
            end
            setTemplateInfoRevealed(v2, v3, (shouldShowInfoForPlayer(v2)))
        end
    end
end

function u0.updateRoundDamageMatrix(a1) -- Line: 823
    -- upvalues: Participants (val), u69 (val), u65 (val), updateDamageFromMatrix (val), setTemplateInfoRevealed (val)
    -- upvalues: shouldShowInfoForPlayer (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9
    local outgoing = a1.outgoing or {}
    local incoming = a1.incoming or {}
    for i, j in Participants.GetAll() do
        v8 = Participants.Key(j)
        v9 = tostring(v8)
        v1 = outgoing[v9] or nil
        v2 = incoming[v9] or nil
        v3 = false
        if v1 ~= nil then
            v3 = #v1 > 0
        end
        v4 = false
        if v2 ~= nil then
            v4 = #v2 > 0
        end
        v5 = u69[v8] == true
        v6 = v3 or v4
        u69[v8] = v6
        updateDamageFromMatrix(u65[v8], v1, v2)
        if v5 ~= v6 then
            v7 = u65[Participants.Key(j)]
            if v7 and v7.Parent then
                setTemplateInfoRevealed(j, v7, (shouldShowInfoForPlayer(j)))
            end
        end
    end
end

function u0.getTemplateByUserId(a1) -- Line: 848 -- upvalues: u65 (val) -- types: a1: number
    return u65[a1]
end

Remotes.UI.TeammateGrenades.Listen(u0.updateTeammateGrenades)
Remotes.UI.RoundDamageMatrix.Listen(u0.updateRoundDamageMatrix)
GameState.ListenToState(function(a1, a2) -- Line: 858
    -- upvalues: u65 (val), u68 (val), u69 (val), setTemplateKills (val), refreshAllTemplateInfoVisibility (val)
    if a1 == "Buy Period" and a2 ~= "Buy Period" then
        for i, j in u65 do
            u68[i] = nil
            u69[i] = nil
            if j and j.Parent then
                setTemplateKills(j, 0)
            end
        end
    end
    refreshAllTemplateInfoVisibility()
end)
Players.PlayerRemoving:Connect(function(a1) -- Line: 874 -- upvalues: u0 (val) -- types: a1: userdata
    u0.cleanupTemplate(a1)
end)
return u0