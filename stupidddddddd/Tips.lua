-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips
-- Decompile time: 11.48 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local GetBindIcon = require(ReplicatedStorage.Components.Common.GetBindIcon)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local KeybindParser = require(ReplicatedStorage.Controllers.InputController.KeybindParser)
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
local u75 = UDim2.fromScale(0.985, 0.62)
local u76 = {"Primary", "Secondary", "Melee", "Grenade"}
local u81 = {
    Menu = "Main Menu",
    ChooseTeam = "Choose Team",
    Scoreboard = "Scoreboard",
    Reload = "Reload",
    WeaponMod = "Secondary Fire",
    Plant = "Fire",
}
local u82 = {"Menu", "ChooseTeam", "Scoreboard", "Plant", "WeaponMod", "Reload"}
local u89 = {}
u89.SpectatePrevious = {Computer = Enum.UserInputType.MouseButton1, Console = Enum.KeyCode.ButtonL1}
u89.SpectateNext = {Computer = Enum.UserInputType.MouseButton2, Console = Enum.KeyCode.ButtonR1}
u89.SpectateCamera = {Computer = Enum.KeyCode.Space, Console = Enum.KeyCode.ButtonA}
local u100 = {
    [Enum.KeyCode.LeftControl] = "CTRL",
    [Enum.KeyCode.RightControl] = "CTRL",
    [Enum.KeyCode.LeftShift] = "SHIFT",
    [Enum.KeyCode.RightShift] = "SHIFT",
    [Enum.KeyCode.LeftAlt] = "ALT",
    [Enum.KeyCode.RightAlt] = "ALT",
    [Enum.KeyCode.Tab] = "TAB",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.Space] = "SPACE",
    [Enum.KeyCode.Return] = "ENTER",
    [Enum.KeyCode.Backspace] = "BACK",
}
local u123 = {
    [Enum.UserInputType.MouseButton1] = "LMB",
    [Enum.UserInputType.MouseButton2] = "RMB",
    [Enum.UserInputType.MouseButton3] = "MMB",
}
local u130 = {
    [Enum.KeyCode.ButtonA] = "A",
    [Enum.KeyCode.ButtonB] = "B",
    [Enum.KeyCode.ButtonX] = "X",
    [Enum.KeyCode.ButtonY] = "Y",
    [Enum.KeyCode.ButtonL1] = "LB",
    [Enum.KeyCode.ButtonR1] = "RB",
    [Enum.KeyCode.ButtonL2] = "LT",
    [Enum.KeyCode.ButtonR2] = "RT",
    [Enum.KeyCode.ButtonL3] = "LS",
    [Enum.KeyCode.ButtonR3] = "RS",
}
local u151 = nil
local u152 = nil
local u153 = {}
local u154 = {}
local u155 = {}
local u162 = table.find(GetUserPlatform(), "Mobile") ~= nil
local u163 = true
local u164 = false
local u165 = nil
local u166 = false
local u167 = false
local u168 = nil
local u169 = {Plant = false, Reload = false}
local u171 = RaycastParams.new()
u171.FilterType = Enum.RaycastFilterType.Exclude
u171.IgnoreWater = true

local function decodeJSON(a1) -- Line: 153 -- upvalues: HttpService (val)
    if typeof(a1) ~= "string" then
        return nil
    end
    local success, result = pcall(HttpService.JSONDecode, HttpService, a1)
    if success and typeof(result) == "table" then
        return result
    end
    return nil
end

local function isAlive() -- Line: 161 -- upvalues: CharacterResolver (val), LocalPlayer (val)
    return CharacterResolver.isAliveCharacter(LocalPlayer.Character)
end

local function updateHasBomb() -- Line: 165 -- upvalues: LocalPlayer (val), HttpService (val), u166 (ref)
    local v1
    local Attribute = LocalPlayer:GetAttribute("Slot5")
    if typeof(Attribute) == "string" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
    else
        v1 = nil
    end
    local v2 = false
    if v1 ~= nil then
        v2 = v1.Weapon == "C4"
    end
    u166 = v2
end

local function updateEquippedState() -- Line: 171
    -- upvalues: LocalPlayer (val), HttpService (val), GetWeaponProperties (val), u167 (ref), u168 (ref)
    local v1
    local Attribute = LocalPlayer:GetAttribute("CurrentEquipped")
    if typeof(Attribute) == "string" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
    else
        v1 = nil
    end
    local Name = v1 and v1.Name and GetWeaponProperties(v1.Name)
    local v2 = false
    if Name ~= nil then
        v2 = Name.Class == "Weapon"
    end
    u167 = v2 and Name.MuzzleType ~= "Zeus x27"
    u168 = if v2 then if not Name.HasScope then if not Name.HasSuppressor then if Name.ShootingOptions ~= "Burst" then nil else "Burst Fire" else "Suppressor" else "Scope" else nil
end

local function isInPlantZone() -- Line: 185 -- upvalues: LocalPlayer (val), Players (val), u171 (val)
    local Character_2 = LocalPlayer.Character
    local PrimaryPart = Character_2 and (Character_2.PrimaryPart or Character_2:FindFirstChild("HumanoidRootPart"))
    if not PrimaryPart then
        return false
    end
    local v1 = {workspace.CurrentCamera}
    for i, v in ipairs(Players:GetPlayers()) do
        if v.Character then
            table.insert(v1, v.Character)
        end
    end
    local Map = workspace:FindFirstChild("Map")
    local Barriers = Map and Map:FindFirstChild("Barriers")
    if Barriers then
        table.insert(v1, Barriers)
    end
    u171.FilterDescendantsInstances = v1
    local v2 = workspace:Raycast(PrimaryPart.Position, Vector3.new(-0, -5, -0), u171)
    local v3 = false
    if v2 ~= nil then
        v3 = v2.Instance:HasTag("PlantArea") and v2.Instance:GetAttribute("Site") ~= nil
    end
    return v3
end

local function canReload() -- Line: 212 -- upvalues: InventoryController (val), IsTutorialMode (val)
    local v1 = InventoryController.getCurrentEquipped()
    local Properties = v1 and v1.Properties
    if Properties and Properties.Rounds and not Properties.RechargeTime then
        if not v1.IsReloading and not (Properties.Rounds <= v1.Rounds) then
            local v2 = true
            if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                v2 = IsTutorialMode()
            end
            if v2 and Properties.ReloadAnimationCount == 1 then
                return true
            end
            return 0 < (v1.Capacity or 0)
        end
        return false
    end
    return false
end

local function updateAvailability() -- Line: 230
    -- upvalues: u166 (ref), isInPlantZone (val), u167 (ref), canReload (val), u169 (val)
    local v1 = u166 and isInPlantZone()
    local v2 = u167 and canReload()
    local v3 = true
    if v1 == u169.Plant then
        v3 = v2 ~= u169.Reload
    end
    local v4 = u169
    u169.Plant = v1
    v4.Reload = v2
    return v3
end

local function bindingToText(a1) -- Line: 239 -- upvalues: u123 (val), u100 (val), UserInputService (val)
    if a1.EnumType == Enum.UserInputType then
        return u123[a1]
    end
    local v1 = u100[a1]
    if v1 then
        return v1
    end
    local StringForKeyCode = UserInputService:GetStringForKeyCode(a1)
    if StringForKeyCode and StringForKeyCode ~= "" then
        return string.upper(StringForKeyCode)
    end
    return string.upper(a1.Name)
end

local function getBindLabels(a1) -- Line: 256 -- types: a1: userdata
    local v1 = nil
    local v2 = nil
    for i, v in ipairs(a1:GetChildren()) do
        if v.Name == "Bind" then
            if v:IsA("TextLabel") then
                v1 = v
            elseif v:IsA("ImageLabel") then
                v2 = v
            end
        end
    end
    return v1, v2
end

function u0.IsGamepadPreferred() -- Line: 274 -- upvalues: UserInputService (val)
    return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end

function u0.ResolveActionBinding(a1) -- Line: 279
    -- upvalues: u0 (val), DataController (val), LocalPlayer (val), Pages (val), KeybindParser (val)
    local v1
    local v2 = if not u0.IsGamepadPreferred() then "Computer" else "Console"
    local v3 = nil
    local v4 = false
    local v5 = DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse")
    if typeof(v5) == "table" then
        for k, v in pairs(v5) do
            if typeof(v) == "table" and typeof(v[a1]) == "table" then
                v3 = v[a1][v2]
                v4 = true
                break
            end
        end
    end
    if not v4 then
        v1 = Pages.GetSetting("Keybinds", a1)
        local Default = v1 and v1.Default
        if typeof(Default) == "table" then
            v3 = Default[v2]
        end
    end
    if typeof(v3) == "string" and v3 ~= "" then
        v1 = KeybindParser.parse(v3)
        if typeof(v1) ~= "EnumItem" then
            return nil
        end
        return v1
    end
    return nil
end

function u0.GetActionKeyText(a1) -- Line: 316
    -- upvalues: u0 (val), u130 (val), bindingToText (val)
    local v1 = u0.ResolveActionBinding(a1)
    if not v1 then
        return nil
    end
    local v2 = u130[v1]
    if v2 then
        return v2
    end
    if u0.IsGamepadPreferred() then
        return nil
    end
    return bindingToText(v1)
end

function u0.ApplyBindingToKeybind(a1, a2) -- Line: 332
    -- upvalues: getBindLabels (val), GetBindIcon (val), bindingToText (val)
    local v1, v2 = getBindLabels(a1)
    local v3 = GetBindIcon(a2)
    if v2 and v3 then
        v2.Image = v3
        v2.Visible = true
        if v1 then
            v1.Visible = false
        end
        return true
    end
    local v4 = a2 and bindingToText(a2)
    if v1 and v4 then
        v1.Text = v4
        v1.Visible = true
        if v2 then
            v2.Visible = false
        end
        return true
    end
    if v1 then
        v1.Visible = false
    end
    if v2 then
        v2.Visible = false
    end
    return false
end

local function mirrorX(a1, a2) -- Line: 367 -- types: a1: userdata, a2: Vector2
    return (Vector2.new(1 - a1.X, a1.Y)), UDim2.new(1 - a2.X.Scale, -a2.X.Offset, a2.Y.Scale, a2.Y.Offset)
end

function u0.MirrorRow(a1) -- Line: 374 -- types: a1: userdata
    local Keybind = a1:FindFirstChild("Keybind")
    if Keybind and Keybind:IsA("GuiObject") then
        local AnchorPoint = Keybind.AnchorPoint
        local Position = Keybind.Position
        local v1 = Vector2.new(1 - AnchorPoint.X, AnchorPoint.Y)
        local v2 = UDim2.new(1 - Position.X.Scale, -Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
        Keybind.AnchorPoint = v1
        Keybind.Position = v2
    end
    local Title = a1:FindFirstChild("Title")
    if Title and Title:IsA("TextLabel") then
        local AnchorPoint_2 = Title.AnchorPoint
        local Position_2 = Title.Position
        local v3 = Vector2.new(1 - AnchorPoint_2.X, AnchorPoint_2.Y)
        local v4 = UDim2.new(1 - Position_2.X.Scale, -Position_2.X.Offset, Position_2.Y.Scale, Position_2.Y.Offset)
        Title.AnchorPoint = v3
        Title.Position = v4
        Title.TextXAlignment = Enum.TextXAlignment.Right
    end
    local UIGradient = a1:FindFirstChildOfClass("UIGradient")
    if UIGradient then
        UIGradient.Rotation = UIGradient.Rotation + 180
    end
end

local function mirrorRow(a1) -- Line: 392 -- upvalues: u0 (val) -- types: a1: table
    u0.MirrorRow(a1.Frame)
end

local function createChooseTeamRow() -- Line: 396 -- upvalues: u151 (ref)
    local Menu = u151:FindFirstChild("Menu")
    if not u151:FindFirstChild("ChooseTeam") and Menu and Menu:IsA("GuiObject") then
        local v1 = Menu:Clone()
        v1.Name = "ChooseTeam"
        local Title = v1:FindFirstChild("Title")
        if Title and Title:IsA("TextLabel") then
            Title.Text = "Choose Team"
        end
        v1.Parent = u151
        return
    end
end

local function hideUnusedRows() -- Line: 412 -- upvalues: u151 (ref), u81 (val), u89 (val)
    for i, v in ipairs(u151:GetChildren()) do
        if v:IsA("GuiObject") and not u81[v.Name] and not u89[v.Name] then
            v.Visible = false
        end
    end
end

local function loadRows(a1, a2) -- Line: 420 -- upvalues: u151 (ref), u0 (val) -- types: a1: table, a2: table
    local Keybind, Title, v1, v2
    for k in pairs(a1) do
        v2 = u151:FindFirstChild(k)
        Keybind = v2 and v2:FindFirstChild("Keybind")
        Title = v2 and v2:FindFirstChild("Title")
        if not v2 or not v2:IsA("GuiObject") or not Keybind or not Keybind:IsA("GuiButton") or not Title then
            warn((("[Tips] Row \"%*\" is missing or malformed"):format(k)))
        elseif Title:IsA("TextLabel") then
            v1 = {HasBind = false, Frame = v2, Keybind = Keybind, Title = Title}
            v2.Visible = false
            u0.MirrorRow(v1.Frame)
            v3[k] = v1
        else
            warn((("[Tips] Row \"%*\" is missing or malformed"):format(k)))
        end
    end
end

local function renderBinds() -- Line: 438 -- upvalues: u154 (val), u0 (val), u81 (val), u155 (val), u89 (val)
    for k, v in pairs(u154) do
        v.HasBind = u0.ApplyBindingToKeybind(v.Keybind, u0.ResolveActionBinding(u81[k]))
    end
    local v1 = if not u0.IsGamepadPreferred() then "Computer" else "Console"
    for k2, i in pairs(u155) do
        i.HasBind = u0.ApplyBindingToKeybind(i.Keybind, u89[k2][v1])
    end
end

local function applyGameplayRows() -- Line: 449 -- upvalues: u168 (ref), u154 (val), u169 (val)
    local Frame, HasBind
    if u168 and u154.WeaponMod then
        u154.WeaponMod.Title.Text = u168
    end
    local v1 = {Reload = u169.Reload}
    v1.WeaponMod = u168 ~= nil
    v1.Plant = u169.Plant
    for k, v in pairs(u154) do
        Frame = v.Frame
        HasBind = v.HasBind and v1[k] ~= false
        Frame.Visible = HasBind
    end
end

local function setRowsVisible(a1, a2) -- Line: 465 -- types: a1: table, a2: boolean
    for k, v in pairs(a1) do
        v.Frame.Visible = a2 and v.HasBind
    end
end

local function applySpectateRows(a1) -- Line: 473
    -- upvalues: SpectateController (val), u155 (val)
    local v1 = SpectateController.GetCurrentSpectateInstance() ~= nil
    local v2 = {
        SpectatePrevious = v1,
        SpectateNext = v1,
        SpectateCamera = SpectateController.CanSwitchPerspective(),
    }
    for k, v in pairs(u155) do
        v.Frame.Visible = a1 and v.HasBind and v2[k] ~= false
    end
end

local function setPolling(a1) -- Line: 490
    -- upvalues: u165 (ref), u166 (ref), isInPlantZone (val), u167 (ref), canReload (val), u169 (val)
    -- upvalues: applyGameplayRows (val)
    if a1 == (u165 ~= nil) then
        return
    end
    if a1 then
        u165 = task.spawn(function() -- Line: 496
            -- upvalues: u166 (upval), isInPlantZone (upval), u167 (upval), canReload (upval), u169 (upval)
            -- upvalues: applyGameplayRows (upval)
            local v1, v2, v3, v4
            while true do
                v2 = u166 and isInPlantZone()
                v3 = u167 and canReload()
                v1 = true
                if v2 == u169.Plant then
                    v1 = v3 ~= u169.Reload
                end
                v4 = u169
                u169.Plant = v2
                v4.Reload = v3
                if v1 then
                    applyGameplayRows()
                end
                task.wait(0.25)
            end
        end)
        return
    end
    task.cancel(u165)
    u165 = nil
    local v1 = u169
    u169.Plant = false
    v1.Reload = false
end

local function getMode() -- Line: 514 -- upvalues: u162 (val), u163 (ref), LocalPlayer (val), CharacterResolver (val)
    if not u162 and u163 then
        if LocalPlayer:GetAttribute("IsSpectating") then
            return "Spectate"
        end
        if CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
            return "Gameplay"
        end
        return "Hidden"
    end
    return "Hidden"
end

local function refresh() -- Line: 525
    -- upvalues: u164 (ref), u162 (val), u163 (ref), LocalPlayer (val), CharacterResolver (val), u151 (ref)
    -- upvalues: applySpectateRows (val), setPolling (val), u166 (ref), isInPlantZone (val), u167 (ref), canReload (val)
    -- upvalues: u169 (val), applyGameplayRows (val), u154 (val)
    u164 = false
    local v1 = if u162 then "Hidden" else if u163 then if not LocalPlayer:GetAttribute("IsSpectating") then if not CharacterResolver.isAliveCharacter(LocalPlayer.Character) then "Hidden" else "Gameplay" else "Spectate" else "Hidden"
    u151.Visible = v1 ~= "Hidden"
    applySpectateRows(v1 == "Spectate")
    setPolling(v1 == "Gameplay")
    if v1 ~= "Gameplay" then
        for k, v in pairs(u154) do
            v.Frame.Visible = false
        end
        return
    end
    local v2 = u166 and isInPlantZone()
    local v3 = u167 and canReload()
    if v2 == u169.Plant and v3 ~= u169.Reload then end
    local v4 = u169
    u169.Plant = v2
    v4.Reload = v3
    applyGameplayRows()
end

local function queueRefresh() -- Line: 544 -- upvalues: u164 (ref), refresh (val)
    if u164 then
        return
    end
    u164 = true
    task.defer(refresh)
end

local function onCharacterAdded(a1) -- Line: 552
    -- upvalues: queueRefresh (val), u164 (ref), refresh (val)
    (a1:GetAttributeChangedSignal("Dead")):Connect(queueRefresh)
    ;(a1:GetAttributeChangedSignal("Health")):Connect(queueRefresh)
    local Humanoid = a1:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.Died:Connect(queueRefresh)
    end
    if u164 then
        return
    end
    u164 = true
    task.defer(refresh)
end

local function positionAboveHotbar() -- Line: 568 -- upvalues: u151 (ref), u152 (ref), u153 (val), u75 (val)
    local Parent = u151.Parent
    if Parent and Parent:IsA("GuiObject") then
        local Y = nil
        if u152 and u152.Visible then
            for i, v in ipairs(u153) do
                if v.Visible then
                    if Y == nil or v.AbsolutePosition.Y < Y then
                        Y = v.AbsolutePosition.Y
                    end
                end
            end
        end
        if Y == nil then
            return
        end
        local v1 = Y - Parent.AbsolutePosition.Y - 0.01 * Parent.AbsoluteSize.Y
        u151.Position = UDim2.new(u75.X, UDim.new(0, v1))
        return
    end
end

local function followHotbar(a1) -- Line: 593
    -- upvalues: u152 (ref), positionAboveHotbar (val), u76 (val), u153 (val), u151 (ref)
    local Gameplay = a1:FindFirstChild("Gameplay")
    local Bottom = Gameplay and Gameplay:FindFirstChild("Bottom")
    local Inventory = Bottom and Bottom:FindFirstChild("Inventory")
    if Inventory and Inventory:IsA("GuiObject") then
        local v1
        u152 = Inventory
        ;(Inventory:GetPropertyChangedSignal("Visible")):Connect(positionAboveHotbar)
        for i, v in ipairs(u76) do
            v1 = Inventory:FindFirstChild(v)
            if v1 and v1:IsA("GuiObject") then
                table.insert(u153, v1)
                ;(v1:GetPropertyChangedSignal("AbsolutePosition")):Connect(positionAboveHotbar)
                ;(v1:GetPropertyChangedSignal("Visible")):Connect(positionAboveHotbar)
            end
        end
        local Parent = u151.Parent
        if Parent and Parent:IsA("GuiObject") then
            (Parent:GetPropertyChangedSignal("AbsoluteSize")):Connect(positionAboveHotbar)
        end
        positionAboveHotbar()
        return
    end
    warn("[Tips] Inventory hotbar not found; the tips keep their default position")
end

function u0.Initialize(a1, a2) -- Line: 624
    -- upvalues: u151 (ref), u162 (val), u75 (val), followHotbar (val), createChooseTeamRow (val), hideUnusedRows (val)
    -- upvalues: loadRows (val), u81 (val), u154 (val), u82 (val), u89 (val), u155 (val)
    local v1
    u151 = a2
    u151.Visible = false
    if u162 then
        return
    end
    u151.AnchorPoint = Vector2.new(1, 1)
    u151.Position = u75
    followHotbar(a1)
    local UIListLayout = u151:FindFirstChildOfClass("UIListLayout")
    if UIListLayout then
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    end
    createChooseTeamRow()
    hideUnusedRows()
    loadRows(u81, u154)
    for i, v in ipairs(u82) do
        v1 = u154[v]
        if v1 then
            v1.Frame.LayoutOrder = i
        end
    end
    loadRows(u89, u155)
end

function u0.Start() -- Line: 654
    -- upvalues: u162 (val), LocalPlayer (val), HttpService (val), u166 (ref), updateEquippedState (val)
    -- upvalues: renderBinds (val), DataController (val), u163 (ref), u164 (ref), refresh (val), UserInputService (val)
    -- upvalues: updateHasBomb (val), queueRefresh (val), SpectateController (val), onCharacterAdded (val), u151 (ref)
    -- upvalues: u165 (ref), u169 (val)
    local v1
    if u162 then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("Slot5")
    if typeof(Attribute) == "string" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
    else
        v1 = nil
    end
    local v2 = false
    if v1 ~= nil then
        v2 = v1.Weapon == "C4"
    end
    u166 = v2
    updateEquippedState()
    renderBinds()
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages", function(a1) -- Line: 663 -- upvalues: u163 (upval), u164 (upval), refresh (upval) -- types: a1: boolean?
        u163 = a1 ~= false
        if u164 then
            return
        end
        u164 = true
        task.defer(refresh)
    end)

    local function onBindsChanged() -- Line: 669 -- upvalues: renderBinds (upval), u164 (upval), refresh (upval)
        renderBinds()
        if u164 then
            return
        end
        u164 = true
        task.defer(refresh)
    end

    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", onBindsChanged)
    ;(UserInputService:GetPropertyChangedSignal("PreferredInput")):Connect(onBindsChanged)
    ;(LocalPlayer:GetAttributeChangedSignal("CurrentEquipped")):Connect(function() -- Line: 676 -- upvalues: updateEquippedState (upval), u164 (upval), refresh (upval)
        updateEquippedState()
        if u164 then
            return
        end
        u164 = true
        task.defer(refresh)
    end)
    ;(LocalPlayer:GetAttributeChangedSignal("Slot5")):Connect(updateHasBomb)
    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(queueRefresh)
    SpectateController.ListenToSpectate:Connect(queueRefresh)
    SpectateController.ListenToFreecam:Connect(queueRefresh)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(queueRefresh)
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 689 -- upvalues: LocalPlayer (upval), u151 (upval), u165 (upval), u169 (upval)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            u151.Visible = false
            if not (u165 ~= nil) then
                return
            end
            task.cancel(u165)
            u165 = nil
            local v1 = u169
            u169.Plant = false
            v1.Reload = false
        end
    end)
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    refresh()
end

return u0