-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons
-- Decompile time: 40.34 ms

local u0 = {}
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local MobileAutoShootController = require(ReplicatedStorage.Controllers.MobileAutoShootController)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local InspectController = require(ReplicatedStorage.Controllers.InspectController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local HintController = require(ReplicatedStorage.Controllers.HintController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CanPlayerUseChatService = require(ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService)
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast)
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea)
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local ApplyMobileButtonLayout = require(ReplicatedStorage.Components.Common.ApplyMobileButtonLayout)
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Promise = require(ReplicatedStorage.Shared.Promise)
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection)
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu)
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard)
local Chat = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat)
local HoverBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb)
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top)
local ChatModes = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.ChatModes)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Buttons = require(script.Buttons)
local Loadout = require(script.Loadout)
local TouchIntent = require(script.TouchIntent)
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local CameraInput = require((((LocalPlayer:WaitForChild("PlayerScripts")):WaitForChild("PlayerModule")):WaitForChild("CameraModule")):WaitForChild("CameraInput"))
local u246 = RaycastParams.new()
u246.FilterType = Enum.RaycastFilterType.Exclude
u246.IgnoreWater = false
local v1 = GetUserPlatform()
local u258 = table.find(v1, "Mobile")
if u258 then
    u258 = #v1 <= 1
end
local u259 = nil
local u260 = nil
local u261 = nil
local u262 = nil
local u263 = false
local u264 = 0
local u265 = false
local u266 = {}
local u267 = {}
local u268 = {}
local u273 = TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
local BUTTONS_WITH_EXPLICIT_INPUT_ENDED = Buttons.BUTTONS_WITH_EXPLICIT_INPUT_ENDED
local BUTTONS_WITH_EXPLICIT_HANDLERS = Buttons.BUTTONS_WITH_EXPLICIT_HANDLERS
local BUTTONS_EXCLUDED_FROM_CLEARING = Buttons.BUTTONS_EXCLUDED_FROM_CLEARING
local BUTTONS_WITH_CAMERA_DRAG = Buttons.BUTTONS_WITH_CAMERA_DRAG
local SPECTATE_MOBILE_BUTTONS = Buttons.SPECTATE_MOBILE_BUTTONS
local GAMEPLAY_MOBILE_BUTTONS = Buttons.GAMEPLAY_MOBILE_BUTTONS
local u281 = {"EndScreen", "Halftime"}
local u284 = nil
local u285 = nil
local u286 = nil

local function GetWeaponDataFromInstance(a1) -- Line: 133 -- upvalues: CollectionService (val) -- types: a1: userdata?
    local Attribute, Attribute_2
    local Parent = a1
    while Parent do
        if CollectionService:HasTag(Parent, "WeaponDropped") then
            Attribute = Parent:GetAttribute("Weapon")
            Attribute_2 = Parent:GetAttribute("Skin")
            if not Attribute or not Attribute_2 then
                break
            end
            return Attribute, Attribute_2, Parent.Name
        end
        Parent = Parent.Parent
    end
    return nil, nil, nil
end

local function GetPingRaycastResult(...) -- Line: 150 -- upvalues: CurrentCamera (val), u246 (val)
    local Instance
    local v1 = {CurrentCamera, ...}
    u246.FilterDescendantsInstances = v1
    local v2 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * 1000, u246)
    while v2 do
        if not v2.Instance then
            break
        end
        Instance = v2.Instance
        if not Instance:IsA("BasePart") or Instance.Transparency <= 0.98 then
            break
        end
        table.insert(v1, Instance)
        u246.FilterDescendantsInstances = v1
        v2 = workspace:Raycast(v2.Position, CurrentCamera.CFrame.LookVector.Unit * (1000 - v2.Distance), u246)
    end
    return v2
end

local function ValidateButtonTouch(a1, a2) -- Line: 177 -- upvalues: u266 (val) -- types: a1: userdata, a2: userdata?
    local v1 = u266[a1]
    local v2 = false
    if v1 ~= nil then
        v2 = true
        if a2 ~= nil then
            v2 = a2 == v1
        end
    end
    return v2
end

local function IsNewTouch(a1) -- Line: 182 -- types: a1: userdata
    return a1.UserInputState == Enum.UserInputState.Begin
end

local function IsPressInput(a1) -- Line: 186 -- types: a1: userdata
    local v1 = true
    if a1.UserInputType ~= Enum.UserInputType.Touch then
        v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
    end
    return v1
end

local u295 = nil

local function TrackButtonTouchStart(a1, a2) -- Line: 193
    -- upvalues: u266 (val), BUTTONS_WITH_CAMERA_DRAG (val), TouchIntent (val), u295 (ref)
    if not u266[a1] and a2.UserInputState == Enum.UserInputState.Begin then
        u266[a1] = a2
        if not BUTTONS_WITH_CAMERA_DRAG[a1.Name] then
            TouchIntent.track(a2, a1, function(a1_2) -- Line: 199 -- upvalues: u295 (upval), a1 (val) -- types: a1_2: userdata
                if u295 then
                    u295(a1, a1_2)
                end
            end)
        end
    end
end

local function TrackButtonTouchEnd(a1, a2) -- Line: 208 -- upvalues: u266 (val) -- types: a1: userdata, a2: userdata
    if u266[a1] == a2 then
        u266[a1] = nil
    end
end

local function IsInputInsideButton(a1, a2) -- Line: 215 -- types: a1: userdata, a2: userdata
    local Position = a2.Position
    local AbsolutePosition = a1.AbsolutePosition
    local AbsoluteSize = a1.AbsoluteSize
    local v1 = false
    if AbsolutePosition.X <= Position.X then
        v1 = false
        if Position.X <= AbsolutePosition.X + AbsoluteSize.X then
            v1 = false
            if AbsolutePosition.Y <= Position.Y then
                v1 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y
            end
        end
    end
    return v1
end

local function SetButtonVisibility(a1, a2) -- Line: 225
    -- upvalues: u284 (ref), u268 (val)
    local v1 = u284:FindFirstChild(a1)
    if v1 then
        v1.Visible = a2 and not u268[a1]
    end
end

local function SetToggledIndicator(a1, a2) -- Line: 232 -- types: a1: userdata?, a2: boolean
    local Toggled = a1 and a1:FindFirstChild("Toggled")
    if Toggled and Toggled:IsA("GuiObject") and Toggled.Visible ~= a2 then
        Toggled.Visible = a2
    end
end

local function IsAlternativeActionActive() -- Line: 239 -- upvalues: u260 (ref), InventoryController (val)
    if u260 ~= nil then
        return true
    end
    local v1 = InventoryController.getCurrentEquipped()
    local Viewmodel = v1 and v1.Viewmodel and v1.Viewmodel.Bobble
    return (Viewmodel and Viewmodel.IsAiming) == true
end

local function UpdateToggledIndicators() -- Line: 251
    -- upvalues: u284 (ref), CharacterController (val), Leaderboard (val), u260 (ref), InventoryController (val)
    local Crouch = u284:FindFirstChild("Crouch")
    local v1 = CharacterController.GetCrouchState() == true
    local Toggled = Crouch and Crouch:FindFirstChild("Toggled")
    if Toggled and Toggled:IsA("GuiObject") and Toggled.Visible ~= v1 then
        Toggled.Visible = v1
    end
    local ToggleWalk = u284:FindFirstChild("ToggleWalk")
    v1 = CharacterController.GetWalkState() == true
    local Toggled_2 = ToggleWalk and ToggleWalk:FindFirstChild("Toggled")
    if Toggled_2 and Toggled_2:IsA("GuiObject") and Toggled_2.Visible ~= v1 then
        Toggled_2.Visible = v1
    end
    local ToggleScoreboard = u284:FindFirstChild("ToggleScoreboard")
    v1 = Leaderboard.IsOpen() == true
    local Toggled_3 = ToggleScoreboard and ToggleScoreboard:FindFirstChild("Toggled")
    if Toggled_3 and Toggled_3:IsA("GuiObject") and Toggled_3.Visible ~= v1 then
        Toggled_3.Visible = v1
    end
    local AlternativeAction = u284:FindFirstChild("AlternativeAction")
    if u260 == nil then
        local v2 = InventoryController.getCurrentEquipped()
        local Viewmodel = v2 and v2.Viewmodel and v2.Viewmodel.Bobble
        v1 = (Viewmodel and Viewmodel.IsAiming) == true
    else
        v1 = true
    end
    local Toggled_4 = AlternativeAction and AlternativeAction:FindFirstChild("Toggled")
    if Toggled_4 and Toggled_4:IsA("GuiObject") and Toggled_4.Visible ~= v1 then
        Toggled_4.Visible = v1
    end
end

local function UpdateButtonVisibilityForSpectate(a1) -- Line: 258
    -- upvalues: u284 (ref), GAMEPLAY_MOBILE_BUTTONS (val), SPECTATE_MOBILE_BUTTONS (val), u268 (val), Loadout (val)
    -- upvalues: u265 (ref)
    local v1, v2
    if not u284 then
        return
    end
    local v3 = a1
    for i, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
        v1 = not v3 or table.find(SPECTATE_MOBILE_BUTTONS, v) ~= nil
        v2 = u284:FindFirstChild(v)
        if v2 then
            v2.Visible = v1 and not u268[v]
        end
    end
    for i2, i3 in ipairs(Loadout.GetSlotButtonNames()) do
        v1 = not v3 and Loadout.IsSlotFilled(i3)
        v2 = u284:FindFirstChild(i3)
        if v2 then
            v2.Visible = v1 and not u268[i3]
        end
    end
    if not u265 then
        local Chat = u284:FindFirstChild("Chat")
        if Chat then
            Chat.Visible = false
        end
    end
end

local function IsSiblingFrameVisible(a1) -- Line: 275 -- upvalues: u285 (ref), u284 (ref) -- types: a1: string
    local Parent = u285 or u284 and u284.Parent
    local v1 = Parent and Parent:FindFirstChild(a1)
    local Visible = false
    if v1 ~= nil then
        Visible = v1:IsA("GuiObject") and v1.Visible
    end
    return Visible
end

local function GetDesiredFrameVisibility(a1) -- Line: 281
    -- upvalues: u258 (val), u281 (val), u285 (ref), u284 (ref), LocalPlayer (val)
    local Parent_2, Visible_2, v1
    if not u258 then
        return false
    end
    for i, v in ipairs(u281) do
        Parent_2 = u285 or u284 and u284.Parent
        v1 = Parent_2 and Parent_2:FindFirstChild(v)
        Visible_2 = false
        if v1 ~= nil then
            Visible_2 = v1:IsA("GuiObject") and v1.Visible
        end
        if Visible_2 then
            return false
        end
    end
    local Character = LocalPlayer.Character
    if Character == a1 then
        Character = nil
    end
    local v2 = false
    if Character ~= nil then
        v2 = Character:IsDescendantOf(workspace)
    end
    local Parent = u285 or u284 and u284.Parent
    local TeamSelection = Parent and Parent:FindFirstChild("TeamSelection")
    local Visible = false
    if TeamSelection ~= nil then
        Visible = TeamSelection:IsA("GuiObject") and TeamSelection.Visible
    end
    if Visible and not v2 then
        return false
    end
    return v2 or LocalPlayer:GetAttribute("IsSpectating") == true
end

local u313 = nil

local function RefreshButtonVisibility(a1, a2) -- Line: 306
    -- upvalues: u284 (ref), GetDesiredFrameVisibility (val), LocalPlayer (val), u313 (ref)
    -- upvalues: UpdateButtonVisibilityForSpectate (val)
    if not u284 then
        return
    end
    local v1 = GetDesiredFrameVisibility(a1)
    local Visible = u284.Visible
    u284.Visible = v1
    local v2 = LocalPlayer:GetAttribute("IsSpectating") == true
    if v1 then
        if a2 ~= false or not Visible or u313 ~= v2 then
            UpdateButtonVisibilityForSpectate(v2)
        end
    end
    u313 = v2
end

local function GetHoveredHostage() -- Line: 321 -- upvalues: CenterScreenRaycast (val)
    return CenterScreenRaycast.GetHoveredHostage()
end

local function GetHoveredBreakableDoor() -- Line: 325 -- upvalues: CenterScreenRaycast (val), CollectionService (val)
    local v1 = {}
    local v2 = CenterScreenRaycast.FindTaggedModelInSight("BreakableDoor", 8)
    if v2 and v2:IsA("Model") and v2:GetAttribute("Destroyed") ~= true then
        local BreakableDoorHingePivot, BreakableDoorHingePivot_2
        table.insert(v1, v2)
        for i, j in CollectionService:GetTagged("BreakableDoor") do
            if j ~= v2 and j:GetAttribute("Destroyed") ~= true then
                BreakableDoorHingePivot = v2:FindFirstChild("BreakableDoorHingePivot")
                BreakableDoorHingePivot_2 = j:FindFirstChild("BreakableDoorHingePivot")
                if BreakableDoorHingePivot
                    and BreakableDoorHingePivot_2
                    and not (20 < (BreakableDoorHingePivot.Position - BreakableDoorHingePivot_2.Position).Magnitude) then
                    table.insert(v1, j)
                end
            end
        end
    end
    return v1
end

local function MultiplyUdim2(a1, a2) -- Line: 353 -- types: a1: RaycastResult, a2: number
    return UDim2.fromScale(a1.X.Scale * a2, a1.Y.Scale * a2)
end

local function GetButtonRestingSize(a1) -- Line: 357 -- upvalues: u267 (val) -- types: a1: userdata
    return u267[a1] or a1.Size
end

local function SetButtonRestingSize(a1, a2) -- Line: 361
    -- upvalues: u267 (val)
    u267[a1] = a2 or a1.Size
end

local function TweenButtonToRestingScale(a1, a2) -- Line: 365
    -- upvalues: TweenService (val), u273 (val), u267 (val)
    local v1 = {}
    local Size = u267[a1] or a1.Size
    v1.Size = UDim2.fromScale(Size.X.Scale * a2, Size.Y.Scale * a2)
    TweenService:Create(a1, u273, v1):Play()
end

function u295(a1, a2) -- Line: 373
    -- upvalues: u266 (val), TweenButtonToRestingScale (val)
    if u266[a1] == a2 then
        u266[a1] = nil
    end
    TweenButtonToRestingScale(a1, 1)
end

local function GetCurrentEquipped() -- Line: 381 -- upvalues: Promise (val), InventoryController (val)
    return (Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
        local v1 = InventoryController.getCurrentEquipped()
        if v1 then
            a1(v1)
            return
        end
        a2("Failed to fetch current equipped")
    end)):catch(warn)
end

local function SetInteractIcon(a1, a2) -- Line: 393
    -- upvalues: u284 (ref), u268 (val)
    u284.Interact.Defuse.Visible = a1
    u284.Interact.Use.Visible = a2
    local Interact = u284:FindFirstChild("Interact")
    if Interact then
        Interact.Visible = (a1 or a2) and not u268.Interact
    end
end

local function UpdateInteractButton() -- Line: 399
    -- upvalues: u284 (ref), CollectionService (val), u263 (ref), LocalPlayer (val), HoverBomb (val)
    -- upvalues: CenterScreenRaycast (val), GetHoveredBreakableDoor (val), u268 (val)
    if not u284 then
        return
    end
    if u284.Shop.Visible then
        u284.Interact.Defuse.Visible = false
        u284.Interact.Use.Visible = false
        local Interact = u284:FindFirstChild("Interact")
        if Interact then
            Interact.Visible = false
        end
        return
    end
    local v1 = CollectionService:GetTagged("Bomb")[1]
    local Attribute = v1 and (v1:GetAttribute("Defused") or v1:GetAttribute("Exploding") or v1:GetAttribute("Exploded"))
    local v2 = u263 or LocalPlayer:GetAttribute("IsDefusingBomb") == true
    local Attribute_2 = v1 and not Attribute and HoverBomb.IsDefuseAllowed() and (v2 or v1:GetAttribute("CanDefuse") and not v1:GetAttribute("IsGettingDefused"))
    local v3 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
    local v4 = CenterScreenRaycast.GetHoveredHostage() ~= nil
    local v5 = GetHoveredBreakableDoor()
    local v6 = false
    if v5 ~= nil then
        v6 = #v5 > 0
    end
    if Attribute_2 then
        u284.Interact.Defuse.Visible = true
        u284.Interact.Use.Visible = false
        local Interact_2 = u284:FindFirstChild("Interact")
        if not Interact_2 then
            return
        end
        Interact_2.Visible = not u268.Interact
        return
    end
    local v7 = v3 or v4 or v6
    u284.Interact.Defuse.Visible = false
    u284.Interact.Use.Visible = v7
    local Interact_3 = u284:FindFirstChild("Interact")
    if Interact_3 then
        Interact_3.Visible = v7 and not u268.Interact
    end
end

local function HasAlternativeAction(a1) -- Line: 447 -- upvalues: GameState (val)
    if a1 and a1.Properties then
        local Properties = a1.Properties
        if Properties.HasScope ~= true and Properties.HasSuppressor ~= true then
            if Properties.ShootingOptions ~= "Burst" and Properties.ShootingOptions ~= "Revolver" then
                local v1 = Properties.Type == "Equipment"
                local v2 = true
                if Properties.Class ~= "Grenade" then
                    v2 = Properties.Slot == "Grenade"
                end
                if not v1 and not v2 then
                    return false
                end
                if GameState.GetState() ~= "Buy Period" then
                    return true
                end
                return false
            end
            return true
        end
        return true
    end
    return false
end

local function UpdateAlternativeActionButton() -- Line: 467
    -- upvalues: SpectateController (val), u284 (ref), HasAlternativeAction (val), InventoryController (val), u268 (val)
    if SpectateController.IsLocalPlayerDead() then
        local AlternativeAction = u284:FindFirstChild("AlternativeAction")
        if AlternativeAction then
            AlternativeAction.Visible = false
        end
        return
    end
    local v1 = HasAlternativeAction(InventoryController.getCurrentEquipped())
    local AlternativeAction_2 = u284:FindFirstChild("AlternativeAction")
    if AlternativeAction_2 then
        AlternativeAction_2.Visible = v1 and not u268.AlternativeAction
    end
end

local function CanDropCurrentEquipped(a1) -- Line: 476
    -- upvalues: SpectateController (val), IsTutorialMode (val), GameState (val)
    if a1 and not SpectateController.IsLocalPlayerDead() and not IsTutorialMode() then
        local Properties = a1.Properties
        if not Properties then
            return false
        end
        local v1 = false
        if Properties.Class == "Melee" then
            v1 = workspace:GetAttribute("VIPKnifeDropEnabled") == true
        end
        if not Properties.Droppable and not v1 then
            return false
        end
        if GameState.GetState() ~= "Warmup" and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            if Properties.Class == "C4" and a1.IsPlanting then
                return false
            end
            return true
        end
        return false
    end
    return false
end

local function UpdateDropButton() -- Line: 501
    -- upvalues: CanDropCurrentEquipped (val), InventoryController (val), u284 (ref), u268 (val)
    local v1 = CanDropCurrentEquipped(InventoryController.getCurrentEquipped())
    local Drop = u284:FindFirstChild("Drop")
    if Drop then
        Drop.Visible = v1 and not u268.Drop
    end
end

local function UpdateReloadButton() -- Line: 505
    -- upvalues: SpectateController (val), u284 (ref), InventoryController (val), u268 (val)
    if SpectateController.IsLocalPlayerDead() then
        local Reload = u284:FindFirstChild("Reload")
        if Reload then
            Reload.Visible = false
        end
        return
    end
    local v1 = InventoryController.getCurrentEquipped()
    local v2 = false
    if v1 ~= nil then
        v2 = v1.Properties.Class == "Weapon"
    end
    local Reload_2 = u284:FindFirstChild("Reload")
    if Reload_2 then
        Reload_2.Visible = v2 and not u268.Reload
    end
end

local function UpdatePingButton() -- Line: 516
    -- upvalues: LocalPlayer (val), SpectateController (val), u284 (ref), u268 (val)
    if not (LocalPlayer:GetAttribute("IsSpectating") == true) and not SpectateController.IsLocalPlayerDead() then
        local v1 = workspace:GetAttribute("Gamemode") ~= "Deathmatch"
        local Ping = u284:FindFirstChild("Ping")
        if Ping then
            Ping.Visible = v1 and not u268.Ping
        end
        return
    end
    local Ping_2 = u284:FindFirstChild("Ping")
    if Ping_2 then
        Ping_2.Visible = false
    end
end

local function UpdateInspectButton() -- Line: 526
    -- upvalues: u284 (ref), SpectateController (val), InventoryController (val), u268 (val)
    if not u284:FindFirstChild("Inspect") then
        return
    end
    if SpectateController.IsLocalPlayerDead() then
        local Inspect = u284:FindFirstChild("Inspect")
        if Inspect then
            Inspect.Visible = false
        end
        return
    end
    local v1 = InventoryController.getCurrentEquipped()
    local Viewmodel = v1 and v1.Viewmodel and v1.Viewmodel.Animation
    local v2 = false
    if Viewmodel ~= nil then
        v2 = false
        if Viewmodel.hasInspectAnimation ~= nil then
            v2 = Viewmodel:hasInspectAnimation()
        end
    end
    local v3 = v2 == true
    local Inspect_2 = u284:FindFirstChild("Inspect")
    if Inspect_2 then
        Inspect_2.Visible = v3 and not u268.Inspect
    end
end

local function GetRarityRGB(a1) -- Line: 544
    return (math.floor(a1.Color.R * 255)), (math.floor(a1.Color.G * 255)), (math.floor(a1.Color.B * 255))
end

local function BindPressFeedback(a1) -- Line: 552
    -- upvalues: TrackButtonTouchStart (val), u266 (val), TweenButtonToRestingScale (val)
    a1.InputBegan:Connect(function(a1_2) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), a1 (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1_2.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1_2.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1_2.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(a1, a1_2)
            if u266[a1] == a1_2 then
                TweenButtonToRestingScale(a1, 0.9)
            end
        end
    end)
end

local function BindTapButton(a1, a2) -- Line: 567
    -- upvalues: TrackButtonTouchStart (val), u266 (val), TweenButtonToRestingScale (val)
    a1.InputBegan:Connect(function(a1_2) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), a1 (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1_2.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1_2.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1_2.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(a1, a1_2)
            if u266[a1] == a1_2 then
                TweenButtonToRestingScale(a1, 0.9)
            end
        end
    end)
    a1.InputEnded:Connect(function(a1_2) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), a1 (val), u266 (upval), a2 (val)
        local v1 = true
        if a1_2.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1_2.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(a1, 1)
        local v2 = u266[a1]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1_2 ~= nil then
                v1 = a1_2 == v2
            end
        end
        if not v1 then
            v1 = a1
            if u266[v1] == a1_2 then
                u266[v1] = nil
            end
            return
        end
        v1 = a1
        if u266[v1] == a1_2 then
            u266[v1] = nil
        end
        a2()
    end)
end

function u0.HighlightButton(a1, a2) -- Line: 588
    -- upvalues: u284 (ref), u266 (val), u267 (val), TweenService (val)
    local u7 = u284
    if u7 then
        u7 = u284:FindFirstChild(a1)
    end
    if u7 and u7:IsA("TextButton") and not u266[u7] then
        local Size = u267[u7] or u7.Size
        local v1 = math.max(1, (math.round(a2 / 1)))
        u7.Size = Size
        local v2 = TweenService:Create(u7, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, v1 - 1, true), {
            Size = UDim2.fromScale(Size.X.Scale * 1.2, Size.Y.Scale * 1.2),
        })
        v2.Completed:Once(function(a1) -- Line: 602 -- upvalues: u7 (val), u267 (upval)
            if a1 == Enum.PlaybackState.Completed then
                local v1 = u7
                local Size = u267[v1] or v1.Size
                u7.Size = Size
            end
        end)
        v2:Play()
        return
    end
end

function u0.setupButton(a1) -- Line: 610
    -- upvalues: Profiler (val), u267 (val), BUTTONS_WITH_EXPLICIT_HANDLERS (val), TrackButtonTouchStart (val)
    -- upvalues: u266 (val), TweenButtonToRestingScale (val), BUTTONS_EXCLUDED_FROM_CLEARING (val)
    -- upvalues: BUTTONS_WITH_EXPLICIT_INPUT_ENDED (val)
    Profiler.mark("UI.MobileButtons.SetupButton")
    u267[a1] = a1.Size
    a1.InputBegan:Connect(function(a1_2) -- Line: 615
        -- upvalues: BUTTONS_WITH_EXPLICIT_HANDLERS (upval), a1 (val), TrackButtonTouchStart (upval), u266 (upval)
        -- upvalues: TweenButtonToRestingScale (upval)
        local v1 = true
        if a1_2.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1_2.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1_2.UserInputState == Enum.UserInputState.Begin then
            if not BUTTONS_WITH_EXPLICIT_HANDLERS[a1.Name] then
                TrackButtonTouchStart(a1, a1_2)
            end
            if u266[a1] == a1_2 then
                TweenButtonToRestingScale(a1, 0.9)
            end
        end
    end)
    if not BUTTONS_EXCLUDED_FROM_CLEARING[a1.Name] then
        a1.InputChanged:Connect(function(a1_2) -- Line: 633
            -- upvalues: u266 (upval), a1 (val), TweenButtonToRestingScale (upval)
            if a1_2.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if u266[a1] == a1_2 then
                local v1 = a1
                local Position = a1_2.Position
                local AbsolutePosition = v1.AbsolutePosition
                local AbsoluteSize = v1.AbsoluteSize
                local v2 = false
                if AbsolutePosition.X <= Position.X then
                    v2 = false
                    if Position.X <= AbsolutePosition.X + AbsoluteSize.X then
                        v2 = false
                        if AbsolutePosition.Y <= Position.Y then
                            v2 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                        end
                    end
                end
                if not v2 then
                    v2 = a1
                    if u266[v2] == a1_2 then
                        u266[v2] = nil
                    end
                    TweenButtonToRestingScale(a1, 1)
                end
            end
        end)
    end
    a1.InputEnded:Connect(function(a1_2) -- Line: 649
        -- upvalues: TweenButtonToRestingScale (upval), a1 (val), BUTTONS_WITH_EXPLICIT_INPUT_ENDED (upval)
        -- upvalues: u266 (upval)
        local v1 = true
        if a1_2.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1_2.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(a1, 1)
        if not BUTTONS_WITH_EXPLICIT_INPUT_ENDED[a1.Name] then
            v1 = a1
            if u266[v1] == a1_2 then
                u266[v1] = nil
            end
        end
    end)
end

function u0.Initialize(a1, a2) -- Line: 663
    -- upvalues: Profiler (val), u284 (ref), u285 (ref), u262 (ref), u263 (ref), LocalPlayer (val), u286 (ref)
    -- upvalues: u267 (val), u258 (val), Loadout (val), u268 (val), TrackButtonTouchStart (val), u266 (val)
    -- upvalues: TouchIntent (val), CharacterController (val), TweenButtonToRestingScale (val), Promise (val)
    -- upvalues: InventoryController (val), CanDropCurrentEquipped (val), Skins (val), Rarities (val), Router (val)
    -- upvalues: u259 (ref), MobileAutoShootController (val), SpectateController (val), GameState (val)
    -- upvalues: CameraInput (val), u260 (ref), CaseSceneController (val), BlackMarketSceneController (val)
    -- upvalues: InspectController (val), CollectionService (val), HoverBomb (val), CenterScreenRaycast (val)
    -- upvalues: GetHoveredBreakableDoor (val), Remotes (val), BuyMenu (val), u261 (ref), Leaderboard (val)
    -- upvalues: IsTutorialMode (val), Chat (val), Top (val), u265 (ref), ChatModes (val), HintController (val)
    -- upvalues: TeamSelection (val), DataController (val), CharacterResolver (val), GetPingRaycastResult (val)
    -- upvalues: GetWeaponDataFromInstance (val), u264 (ref), u0 (val), RunServiceController (val)
    -- upvalues: GetDesiredFrameVisibility (val), u313 (ref), UpdateButtonVisibilityForSpectate (val), IsInBuyArea (val)
    -- upvalues: TutorialPurchaseLock (val), UpdateInteractButton (val), UpdateInspectButton (val)
    -- upvalues: UpdatePingButton (val), HasAlternativeAction (val), UpdateToggledIndicators (val)
    -- upvalues: UserInputService (val)
    local Toggled
    Profiler.mark("UI.MobileButtons.Initialize")
    u284 = a2
    u285 = a2.Parent
    u262 = nil
    u263 = false
    local u12 = a2:FindFirstAncestorOfClass("ScreenGui")
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if u12 and PlayerGui then
        local MobileControlsGui = PlayerGui:FindFirstChild("MobileControlsGui")
        if not MobileControlsGui or not MobileControlsGui:IsA("ScreenGui") then
            MobileControlsGui = Instance.new("ScreenGui")
            MobileControlsGui.Name = "MobileControlsGui"
            MobileControlsGui.ResetOnSpawn = false
            MobileControlsGui.IgnoreGuiInset = u12.IgnoreGuiInset
            MobileControlsGui.ScreenInsets = u12.ScreenInsets
            MobileControlsGui.SafeAreaCompatibility = u12.SafeAreaCompatibility
            MobileControlsGui.ClipToDeviceSafeArea = u12.ClipToDeviceSafeArea
            MobileControlsGui.ZIndexBehavior = u12.ZIndexBehavior
            MobileControlsGui.DisplayOrder = 1000
            MobileControlsGui.Parent = PlayerGui
        end
        u286 = MobileControlsGui
        a2.Parent = MobileControlsGui
        local u43 = u285
        local Parent = u43
        if Parent then
            Parent = u43.Parent
        end

        local function syncHostVisibility() -- Line: 693
            -- upvalues: u12 (val), Parent (val), u43 (val), MobileControlsGui (ref)
            local Enabled = u12.Enabled
            if Enabled then
                if Parent == nil or not Parent:IsA("GuiObject") then
                    Enabled = true
                    if u43 ~= nil then
                        Enabled = not u43:IsA("GuiObject") or u43.Visible
                    end
                else
                    Enabled = Parent.Visible
                    if Enabled then
                        Enabled = true
                        if u43 ~= nil then
                            Enabled = not u43:IsA("GuiObject") or u43.Visible
                        end
                    end
                end
            end
            if MobileControlsGui.Enabled ~= Enabled then
                MobileControlsGui.Enabled = Enabled
            end
        end

        ;(u12:GetPropertyChangedSignal("Enabled")):Connect(syncHostVisibility)
        if Parent and Parent:IsA("GuiObject") then
            (Parent:GetPropertyChangedSignal("Visible")):Connect(syncHostVisibility)
        end
        if u43 and u43:IsA("GuiObject") then
            (u43:GetPropertyChangedSignal("Visible")):Connect(syncHostVisibility)
        end
        local Enabled = u12.Enabled
        if Enabled then
            if Parent == nil or not Parent:IsA("GuiObject") then
                Enabled = true
                if u43 ~= nil then
                    Enabled = not u43:IsA("GuiObject") or u43.Visible
                end
            else
                Enabled = Parent.Visible
                if Enabled then
                    Enabled = true
                    if u43 ~= nil then
                        Enabled = not u43:IsA("GuiObject") or u43.Visible
                    end
                end
            end
        end
        if MobileControlsGui.Enabled ~= Enabled then
            MobileControlsGui.Enabled = Enabled
        end
    end
    for i, v in ipairs(u284:GetChildren()) do
        if v:IsA("TextButton") then
            u267[v] = v.Size or v.Size
        end
        Toggled = v and v:FindFirstChild("Toggled")
        if Toggled and Toggled:IsA("GuiObject") and Toggled.Visible ~= false then
            Toggled.Visible = false
        end
    end
    if not u258 then
        u284.Visible = false
        return
    end
    Loadout.Initialize(u284, function(a1, a2) -- Line: 722
        -- upvalues: LocalPlayer (upval), u284 (upval), u268 (upval)
        local v1 = a2 and LocalPlayer:GetAttribute("IsSpectating") ~= true
        local v2 = u284:FindFirstChild(a1)
        if v2 then
            v2.Visible = v1 and not u268[a1]
        end
    end)
    local Parent_2 = u285 and u285.Parent
    local Top_2 = Parent_2 and Parent_2:FindFirstChild("Top")
    if Top_2 then
        local v1 = Top_2:FindFirstChild("Bomb Defusal")
        if v1 then
            v1.Size = UDim2.new(0.6, 0, 0.75, 0)
        end
    end
    u284.Jump.InputBegan:Connect(function(a1) -- Line: 740
        -- upvalues: TrackButtonTouchStart (upval), u284 (upval), u266 (upval), TouchIntent (upval)
        -- upvalues: CharacterController (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if not (a1.UserInputState == Enum.UserInputState.Begin) then
            return
        end
        TrackButtonTouchStart(u284.Jump, a1)
        local Jump = u284.Jump
        local v2 = u266[Jump]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if v1 then
            TouchIntent.onTap(a1, CharacterController.jump)
        end
    end)
    local Crouch = u284.Crouch

    local function u161() -- Line: 754 -- upvalues: CharacterController (upval)
        CharacterController.crouch(not CharacterController.GetCrouchState())
    end

    Crouch.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), Crouch (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Crouch, a1)
            if u266[Crouch] == a1 then
                TweenButtonToRestingScale(Crouch, 0.9)
            end
        end
    end)
    Crouch.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), Crouch (val), u266 (upval), u161 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(Crouch, 1)
        local v2 = u266[Crouch]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = Crouch
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = Crouch
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u161()
    end)
    local ToggleWalk = u284.ToggleWalk

    local function u174() -- Line: 759 -- upvalues: LocalPlayer (upval), CharacterController (upval)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") then
            CharacterController.walk(not CharacterController.GetWalkState())
        end
    end

    ToggleWalk.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), ToggleWalk (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(ToggleWalk, a1)
            if u266[ToggleWalk] == a1 then
                TweenButtonToRestingScale(ToggleWalk, 0.9)
            end
        end
    end)
    ToggleWalk.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), ToggleWalk (val), u266 (upval), u174 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(ToggleWalk, 1)
        local v2 = u266[ToggleWalk]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = ToggleWalk
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = ToggleWalk
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u174()
    end)
    u284.Drop.InputEnded:Connect(function(a1) -- Line: 766
        -- upvalues: u284 (upval), u266 (upval), Promise (upval), InventoryController (upval)
        -- upvalues: CanDropCurrentEquipped (upval), Skins (upval), Rarities (upval), Router (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        local Drop = u284.Drop
        local v2 = u266[Drop]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        local Drop_2 = u284.Drop
        if u266[Drop_2] == a1 then
            u266[Drop_2] = nil
        end
        if not v1 then
            return
        end
        ;((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
            local v1 = InventoryController.getCurrentEquipped()
            if v1 then
                a1(v1)
                return
            end
            a2("Failed to fetch current equipped")
        end)):catch(warn)):andThen(function(a1) -- Line: 776 -- upvalues: CanDropCurrentEquipped (upval), Skins (upval), Rarities (upval), Router (upval)
            if a1 and CanDropCurrentEquipped(a1) then
                local v1 = Skins.GetSkinInformation(a1.Name, a1.Skin)
                assert(v1, "Skin data not found for weapon: " .. a1.Name .. " and skin: " .. a1.Skin)
                local v2 = Rarities[v1.rarity]
                local v3 = (math.floor(v2.Color.R * 255))
                local v4 = (math.floor(v2.Color.G * 255))
                local v5 = math.floor(v2.Color.B * 255)
                if a1:drop() then
                    Router.broadcastRouter(
                        "CreateNotification",
                        "Item Dropped",
                        ("You dropped your <font color = \"rgb(%*, %*, %*)\"><b>%* | %*</b></font>"):format(v3, v4, v5, a1.Name, a1.Skin),
                        2
                    )
                end
            end
        end)
    end)
    local Reload = u284.Reload

    local function u194() -- Line: 800 -- upvalues: Promise (upval), InventoryController (upval)
        ((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
            local v1 = InventoryController.getCurrentEquipped()
            if v1 then
                a1(v1)
                return
            end
            a2("Failed to fetch current equipped")
        end)):catch(warn)):andThen(function(a1) -- Line: 801
            if a1 then
                a1:reload()
            end
        end)
    end

    Reload.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), Reload (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Reload, a1)
            if u266[Reload] == a1 then
                TweenButtonToRestingScale(Reload, 0.9)
            end
        end
    end)
    Reload.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), Reload (val), u266 (upval), u194 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(Reload, 1)
        local v2 = u266[Reload]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = Reload
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = Reload
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u194()
    end)
    u284.Shoot.Active = true
    local u208 = false
    u284.Shoot.InputBegan:Connect(function(a1) -- Line: 868
        -- upvalues: u259 (upval), LocalPlayer (upval), SpectateController (upval), GameState (upval), Router (upval)
        -- upvalues: u208 (ref), MobileAutoShootController (upval), TweenButtonToRestingScale (upval), u284 (upval)
        -- upvalues: Promise (upval), InventoryController (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if v1 and not u259 and a1.UserInputState == Enum.UserInputState.Begin then
            u259 = a1
            if not LocalPlayer:GetAttribute("IsPlayerChatting")
                and not SpectateController.IsLocalPlayerDead()
                and LocalPlayer.Character
                and GameState.GetState() ~= "Buy Period" then
                Router.broadcastRouter("Cancel Defuse Bomb")
                u208 = true
                MobileAutoShootController.SetManualFireHeld(true)
                TweenButtonToRestingScale(u284.Shoot, 0.9)
                ;((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
                    local v1 = InventoryController.getCurrentEquipped()
                    if v1 then
                        a1(v1)
                        return
                    end
                    a2("Failed to fetch current equipped")
                end)):catch(warn)):andThen(function(a1) -- Line: 893
                    if not a1 then
                        return
                    end
                    if a1.Properties.Class ~= "Weapon" then
                        if a1.Properties.Class == "Melee" then
                            a1.IsFireHeld = true
                            a1:shoot()
                            return
                        end
                        if a1.Properties.Class == "C4" then
                            a1:shoot()
                            return
                        end
                        if a1.Properties.Slot == "Grenade" then
                            a1:StartThrow()
                        end
                        return
                    end
                    if a1.Properties.ShootingOptions == "Revolver" then
                        a1:startRevolverCharge(nil)
                        return
                    end
                    if a1.AlternativeShootingOption ~= "Burst" then
                        a1.IsFireHeld = true
                        a1:shoot()
                        return
                    end
                    if a1.IsBurstShooting then
                        return
                    end
                    a1.IsFireHeld = true
                    a1:fireBurst()
                end)
                return
            end
            return
        end
    end)
    u284.Shoot.InputEnded:Connect(function(a1, a2) -- Line: 813
        -- upvalues: u259 (upval), u208 (ref), MobileAutoShootController (upval), TweenButtonToRestingScale (upval)
        -- upvalues: u284 (upval), Promise (upval), InventoryController (upval)
        if a1 ~= u259 then
            return
        end
        if not a2 and a1.UserInputState ~= Enum.UserInputState.End then
            return
        end
        u259 = nil
        if not u208 then
            return
        end
        u208 = false
        MobileAutoShootController.SetManualFireHeld(false)
        TweenButtonToRestingScale(u284.Shoot, 1)
        ;((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
            local v1 = InventoryController.getCurrentEquipped()
            if v1 then
                a1(v1)
                return
            end
            a2("Failed to fetch current equipped")
        end)):catch(warn)):andThen(function(a1) -- Line: 834
            if not a1 then
                return
            end
            if a1.Properties.Class ~= "Weapon" then
                if a1.Properties.Class == "Melee" then
                    a1.IsFireHeld = false
                    return
                end
                if a1.Properties.Class == "C4" then
                    a1:cancel()
                    return
                end
                if a1.Properties.Slot == "Grenade" then
                    a1:Throw("Far")
                end
                return
            end
            if a1.Properties.ShootingOptions ~= "Revolver" then
                a1.IsFireHeld = false
                return
            end
            local FireModes = a1.Properties.FireModes and a1.Properties.FireModes.Primary
            if not FireModes or FireModes.CancelOnRelease ~= false then
                a1:cancelRevolverCharge(false)
                return
            end
            a1.IsFireHeld = false
            a1.FireInputBinding = nil
        end)
    end)
    u284.Shoot.InputChanged:Connect(function(a1) -- Line: 937 -- upvalues: u259 (upval), CameraInput (upval) -- types: a1: userdata
        if a1 == u259 and a1.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(a1.Delta.X, a1.Delta.Y))
        end
    end)
    u284.AlternativeAction.Active = true
    u284.AlternativeAction.InputBegan:Connect(function(a1) -- Line: 983
        -- upvalues: u260 (upval), TweenButtonToRestingScale (upval), u284 (upval), Promise (upval)
        -- upvalues: InventoryController (upval), LocalPlayer (upval), SpectateController (upval)
        -- upvalues: CaseSceneController (upval), BlackMarketSceneController (upval), InspectController (upval)
        -- upvalues: GameState (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if v1 and not u260 and a1.UserInputState == Enum.UserInputState.Begin then
            u260 = a1
            TweenButtonToRestingScale(u284.AlternativeAction, 0.9)
            ;((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
                local v1 = InventoryController.getCurrentEquipped()
                if v1 then
                    a1(v1)
                    return
                end
                a2("Failed to fetch current equipped")
            end)):catch(warn)):andThen(function(a1) -- Line: 993
                -- upvalues: LocalPlayer (upval), SpectateController (upval), CaseSceneController (upval)
                -- upvalues: BlackMarketSceneController (upval), InspectController (upval), GameState (upval)
                if not a1 then
                    return
                end
                if not LocalPlayer:GetAttribute("IsPlayerChatting")
                    and not SpectateController.IsLocalPlayerDead()
                    and not CaseSceneController.IsActive()
                    and not BlackMarketSceneController.IsActive()
                    and not InspectController.IsActive() then
                    local Properties = a1.Properties
                    if Properties.ShootingOptions == "Revolver" then
                        a1:startRevolverSecondaryFire(nil)
                        return
                    end
                    if Properties.Class ~= "Grenade" and Properties.Slot ~= "Grenade" then
                        if Properties.HasScope then
                            a1:scope(true)
                            return
                        end
                        if Properties.HasSuppressor then
                            if a1.IsSuppressed then
                                a1:removeSuppressor()
                                return
                            end
                            a1:addSuppressor()
                            return
                        end
                        if Properties.ShootingOptions == "Burst" then
                            a1:updateFireMode()
                            return
                        end
                        if Properties.Type ~= "Equipment" then
                            return
                        end
                        if GameState.GetState() ~= "Buy Period" then
                            a1:shoot(true)
                        end
                        return
                    end
                    if GameState.GetState() ~= "Buy Period" then
                        a1:StartThrow()
                    end
                    return
                end
            end)
            return
        end
    end)
    u284.AlternativeAction.InputEnded:Connect(function(a1, a2) -- Line: 946
        -- upvalues: u260 (upval), TweenButtonToRestingScale (upval), u284 (upval), Promise (upval)
        -- upvalues: InventoryController (upval), GameState (upval)
        if a1 ~= u260 then
            return
        end
        if not a2 and a1.UserInputState ~= Enum.UserInputState.End then
            return
        end
        u260 = nil
        TweenButtonToRestingScale(u284.AlternativeAction, 1)
        ;((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
            local v1 = InventoryController.getCurrentEquipped()
            if v1 then
                a1(v1)
                return
            end
            a2("Failed to fetch current equipped")
        end)):catch(warn)):andThen(function(a1) -- Line: 962 -- upvalues: GameState (upval)
            if not a1 then
                return
            end
            local Properties = a1.Properties
            if Properties.ShootingOptions == "Revolver" then
                a1:stopRevolverSecondaryFire()
                return
            end
            if Properties.Slot == "Grenade" and GameState.GetState() ~= "Buy Period" then
                if a1.ThrowStarted and not a1.ThrowFinished then
                    a1:Throw("Near")
                end
                return
            end
        end)
    end)
    u284.AlternativeAction.InputChanged:Connect(function(a1) -- Line: 1044 -- upvalues: u260 (upval), CameraInput (upval) -- types: a1: userdata
        if a1 == u260 and a1.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(a1.Delta.X, a1.Delta.Y))
        end
    end)
    u284.Interact.Active = true
    u262 = nil
    u284.Interact.InputBegan:Connect(function(a1) -- Line: 1054
        -- upvalues: u262 (upval), TrackButtonTouchStart (upval), u284 (upval), CollectionService (upval)
        -- upvalues: HoverBomb (upval), u263 (upval), Router (upval), CenterScreenRaycast (upval), LocalPlayer (upval)
        -- upvalues: GetHoveredBreakableDoor (upval), CharacterController (upval), Remotes (upval), Skins (upval)
        -- upvalues: Rarities (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if v1 and not u262 then
            v1 = a1.UserInputState == Enum.UserInputState.Begin
            if v1 then
                local Attribute_4, Attribute_5, Tagged, v2, v3, v4, v5, v6, v7, v8, v9
                u262 = a1
                TrackButtonTouchStart(u284.Interact, a1)
                v1 = CollectionService:GetTagged("Bomb")[1]
                if v1
                    and v1:GetAttribute("CanDefuse")
                    and not v1:GetAttribute("Defused")
                    and HoverBomb.IsDefuseAllowed() then
                    u263 = true
                    Router.broadcastRouter("Start Defuse Bomb")
                    return
                end
                local v10 = CenterScreenRaycast.GetHoveredHostage()
                if v10 then
                    local Attribute = LocalPlayer:GetAttribute("Team")
                    if not LocalPlayer:GetAttribute("IsCarryingHostage")
                        and not LocalPlayer:GetAttribute("IsRescuingHostage")
                        and Attribute == "Counter-Terrorists" then
                        local Attribute_2 = v10:GetAttribute("RescuingPlayer")
                        local Attribute_3 = v10:GetAttribute("CarryingPlayer")
                        if Attribute_2 and Attribute_2 ~= LocalPlayer.Name then
                            v5 = GetHoveredBreakableDoor()
                            if #v5 > 0 then
                                v6 = nil
                                v7 = nil
                                for i, j in v5, v6, v7 do
                                    v9 = CharacterController.PredictDoorUse(j)
                                    Remotes.BreakableDoor.Use.Send({
                                        Model = j,
                                        ServerTick = if v9 == nil then nil else v9.ServerTick,
                                        TargetAngle = if v9 == nil then nil else v9.TargetAngle,
                                        RequestId = if v9 == nil then nil else v9.RequestId,
                                    })
                                end
                                return
                            end
                            Tagged = CollectionService:GetTagged("IsHoveringInteractable")
                            if #Tagged == 0 then
                                return
                            end
                            v6 = Tagged[1]
                            Attribute_4 = v6:GetAttribute("Weapon")
                            Attribute_5 = v6:GetAttribute("Skin")
                            if Attribute_4 == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
                                return
                            end
                            if v6:GetAttribute("CanPickup") then
                                v8 = Skins.GetSkinInformation(Attribute_4, Attribute_5)
                                if v8 then
                                    v4 = Rarities[v8.rarity]
                                    v9 = (math.floor(v4.Color.R * 255))
                                    v2 = (math.floor(v4.Color.G * 255))
                                    v3 = math.floor(v4.Color.B * 255)
                                    Router.broadcastRouter("CreateNotification", "Item Picked Up", ("You picked up a <font color = \"rgb(%*, %*, %*)\"><b>%* | %*</b></font>"):format(
                                        v9,
                                        v2,
                                        v3,
                                        if not Attribute_4:find("Zeus") then Attribute_4 else "Taser",
                                        Attribute_5
                                    ), 2)
                                end
                                Remotes.Inventory.PickupWeapon.Send({AllowAutoEquip = true, Identity = v6.Name})
                            end
                            return
                        end
                        if not Attribute_3 then
                            Router.broadcastRouter("Start Rescue Hostage")
                            return
                        end
                    end
                end
                v5 = GetHoveredBreakableDoor()
                if #v5 > 0 then
                    v6 = nil
                    v7 = nil
                    for k, n in v5, v6, v7 do
                        v9 = CharacterController.PredictDoorUse(n)
                        Remotes.BreakableDoor.Use.Send({
                            Model = n,
                            ServerTick = if v9 == nil then nil else v9.ServerTick,
                            TargetAngle = if v9 == nil then nil else v9.TargetAngle,
                            RequestId = if v9 == nil then nil else v9.RequestId,
                        })
                    end
                    return
                end
                Tagged = CollectionService:GetTagged("IsHoveringInteractable")
                if #Tagged == 0 then
                    return
                end
                v6 = Tagged[1]
                Attribute_4 = v6:GetAttribute("Weapon")
                Attribute_5 = v6:GetAttribute("Skin")
                if Attribute_4 == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
                    return
                end
                if v6:GetAttribute("CanPickup") then
                    v8 = Skins.GetSkinInformation(Attribute_4, Attribute_5)
                    if v8 then
                        v4 = Rarities[v8.rarity]
                        v9 = (math.floor(v4.Color.R * 255))
                        v2 = (math.floor(v4.Color.G * 255))
                        v3 = math.floor(v4.Color.B * 255)
                        Router.broadcastRouter("CreateNotification", "Item Picked Up", ("You picked up a <font color = \"rgb(%*, %*, %*)\"><b>%* | %*</b></font>"):format(
                            v9,
                            v2,
                            v3,
                            if not Attribute_4:find("Zeus") then Attribute_4 else "Taser",
                            Attribute_5
                        ), 2)
                    end
                    Remotes.Inventory.PickupWeapon.Send({AllowAutoEquip = true, Identity = v6.Name})
                end
                return
            end
        end
    end)

    local function ProcessEndInteract(a1) -- Line: 1142
        -- upvalues: u262 (upval), u263 (upval), LocalPlayer (upval), u284 (upval), u266 (upval)
        -- upvalues: CollectionService (upval), Router (upval)
        if a1 ~= u262 then
            return
        end
        local v1 = u263 or LocalPlayer:GetAttribute("IsDefusingBomb") == true
        u262 = nil
        u263 = false
        local Interact = u284.Interact
        if u266[Interact] == a1 then
            u266[Interact] = nil
        end
        if CollectionService:GetTagged("Bomb")[1] and v1 then
            Router.broadcastRouter("Cancel Defuse Bomb")
            return
        end
        if LocalPlayer:GetAttribute("IsRescuingHostage") then
            Router.broadcastRouter("Cancel Rescue Hostage")
        end
    end

    u284.Interact.InputEnded:Connect(ProcessEndInteract)
    u284.Interact.InputChanged:Connect(function(a1) -- Line: 1166 -- upvalues: u262 (upval), CameraInput (upval) -- types: a1: userdata
        if a1 == u262 and a1.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(a1.Delta.X, a1.Delta.Y))
        end
    end)
    local Shop = u284.Shop
    local toggleFrame = BuyMenu.toggleFrame
    Shop.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), Shop (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Shop, a1)
            if u266[Shop] == a1 then
                TweenButtonToRestingScale(Shop, 0.9)
            end
        end
    end)
    Shop.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), Shop (val), u266 (upval), toggleFrame (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(Shop, 1)
        local v2 = u266[Shop]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = Shop
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = Shop
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        toggleFrame()
    end)

    local function ProcessEndScoreboard(a1, a2) -- Line: 1176
        -- upvalues: u261 (upval), TweenButtonToRestingScale (upval), u284 (upval), u266 (upval)
        if a1 ~= u261 then
            return
        end
        if not a2 and a1.UserInputState ~= Enum.UserInputState.End then
            return
        end
        u261 = nil
        TweenButtonToRestingScale(u284.ToggleScoreboard, 1)
        local ToggleScoreboard = u284.ToggleScoreboard
        if u266[ToggleScoreboard] == a1 then
            u266[ToggleScoreboard] = nil
        end
    end

    u284.ToggleScoreboard.InputBegan:Connect(function(a1) -- Line: 1189
        -- upvalues: u261 (upval), LocalPlayer (upval), TrackButtonTouchStart (upval), u284 (upval)
        -- upvalues: TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if v1
            and not u261
            and not LocalPlayer:GetAttribute("IsPlayerChatting")
            and a1.UserInputState == Enum.UserInputState.Begin then
            u261 = a1
            TrackButtonTouchStart(u284.ToggleScoreboard, a1)
            TweenButtonToRestingScale(u284.ToggleScoreboard, 0.9)
            return
        end
    end)
    u284.ToggleScoreboard.InputEnded:Connect(function(a1) -- Line: 1204
        -- upvalues: u261 (upval), u284 (upval), u266 (upval), TweenButtonToRestingScale (upval), Leaderboard (upval)
        if a1 ~= u261 then
            return
        end
        local ToggleScoreboard = u284.ToggleScoreboard
        local v1 = u266[ToggleScoreboard]
        local v2 = false
        if v1 ~= nil then
            v2 = true
            if a1 ~= nil then
                v2 = a1 == v1
            end
        end
        if a1 == u261 then
            u261 = nil
            TweenButtonToRestingScale(u284.ToggleScoreboard, 1)
            local ToggleScoreboard_2 = u284.ToggleScoreboard
            if u266[ToggleScoreboard_2] == a1 then
                u266[ToggleScoreboard_2] = nil
            end
        end
        if not v2 then
            return
        end
        if Leaderboard.IsOpen() then
            Leaderboard.closeFrame()
            return
        end
        Leaderboard.openFrame()
    end)
    local Menu = u284.Menu

    local function u313_2() -- Line: 1222 -- upvalues: IsTutorialMode (upval), Chat (upval), Top (upval)
        if IsTutorialMode() then
            return
        end
        Chat.CloseChat()
        Top.ToggleMenu()
    end

    Menu.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), Menu (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Menu, a1)
            if u266[Menu] == a1 then
                TweenButtonToRestingScale(Menu, 0.9)
            end
        end
    end)
    Menu.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), Menu (val), u266 (upval), u313_2 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(Menu, 1)
        local v2 = u266[Menu]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = Menu
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = Menu
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u313_2()
    end)
    local Chat_2 = u284.Chat

    local function u326() -- Line: 1231 -- upvalues: u265 (upval), Chat (upval), ChatModes (upval)
        if not u265 then
            return
        end
        Chat.ToggleChat(ChatModes.Modes.All)
    end

    Chat_2.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), Chat_2 (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Chat_2, a1)
            if u266[Chat_2] == a1 then
                TweenButtonToRestingScale(Chat_2, 0.9)
            end
        end
    end)
    Chat_2.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), Chat_2 (val), u266 (upval), u326 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(Chat_2, 1)
        local v2 = u266[Chat_2]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = Chat_2
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = Chat_2
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u326()
    end)
    local Inspect = u284.Inspect

    local function u339() -- Line: 1240
        -- upvalues: LocalPlayer (upval), CaseSceneController (upval), BlackMarketSceneController (upval)
        -- upvalues: InspectController (upval), InventoryController (upval), HintController (upval)
        if not LocalPlayer:GetAttribute("IsPlayerChatting")
            and not CaseSceneController.IsActive()
            and not BlackMarketSceneController.IsActive()
            and not InspectController.IsActive() then
            local v1 = InventoryController.getCurrentEquipped()
            if v1 then
                v1:inspect()
                HintController:clearHint("Inspect")
            end
            return
        end
    end

    Inspect.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), Inspect (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Inspect, a1)
            if u266[Inspect] == a1 then
                TweenButtonToRestingScale(Inspect, 0.9)
            end
        end
    end)
    Inspect.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), Inspect (val), u266 (upval), u339 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(Inspect, 1)
        local v2 = u266[Inspect]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = Inspect
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = Inspect
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u339()
    end)
    local SwapTeam = u284.SwapTeam

    local function u352() -- Line: 1256 -- upvalues: LocalPlayer (upval), TeamSelection (upval)
        if LocalPlayer:GetAttribute("IsSpectating") then
            TeamSelection.openFrame()
            return
        end
        if LocalPlayer.Character then
            TeamSelection.ToggleTeamSelection()
        end
    end

    SwapTeam.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), SwapTeam (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(SwapTeam, a1)
            if u266[SwapTeam] == a1 then
                TweenButtonToRestingScale(SwapTeam, 0.9)
            end
        end
    end)
    SwapTeam.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), SwapTeam (val), u266 (upval), u352 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(SwapTeam, 1)
        local v2 = u266[SwapTeam]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = SwapTeam
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = SwapTeam
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u352()
    end)
    local Ping = u284.Ping

    local function u365() -- Line: 1265
        -- upvalues: DataController (upval), LocalPlayer (upval), CharacterResolver (upval)
        -- upvalues: GetPingRaycastResult (upval), GetWeaponDataFromInstance (upval), Remotes (upval), u264 (upval)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch"
            and DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") ~= "Disabled"
            and CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
            local v1 = GetPingRaycastResult(LocalPlayer.Character)
            if not v1 then
                return
            end
            local v2, v3, v4 = GetWeaponDataFromInstance(v1.Instance)
            if not v2 or not v3 or not v4 then
                Remotes.Ping.CreatePlayerPositionPing.Send({IsDanger = tick() - u264 < 0.5, Position = v1.Position})
            else
                Remotes.Ping.CreatePlayerPositionPing.Send({
                    IsDanger = false,
                    Position = v1.Position,
                    WeaponIdentity = v4,
                    WeaponName = v2,
                    WeaponSkin = v3,
                })
            end
            u264 = tick()
            return
        end
    end

    Ping.InputBegan:Connect(function(a1) -- Line: 553
        -- upvalues: TrackButtonTouchStart (upval), Ping (val), u266 (upval), TweenButtonToRestingScale (upval)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        if a1.UserInputState == Enum.UserInputState.Begin then
            TrackButtonTouchStart(Ping, a1)
            if u266[Ping] == a1 then
                TweenButtonToRestingScale(Ping, 0.9)
            end
        end
    end)
    Ping.InputEnded:Connect(function(a1) -- Line: 569
        -- upvalues: TweenButtonToRestingScale (upval), Ping (val), u266 (upval), u365 (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v1 then
            return
        end
        TweenButtonToRestingScale(Ping, 1)
        local v2 = u266[Ping]
        v1 = false
        if v2 ~= nil then
            v1 = true
            if a1 ~= nil then
                v1 = a1 == v2
            end
        end
        if not v1 then
            v1 = Ping
            if u266[v1] == a1 then
                u266[v1] = nil
            end
            return
        end
        v1 = Ping
        if u266[v1] == a1 then
            u266[v1] = nil
        end
        u365()
    end)
    for i2, i3 in ipairs(u284:GetChildren()) do
        if i3:IsA("TextButton") and i3.Name ~= "Shoot" and i3.Name ~= "AlternativeAction" then
            u0.setupButton(i3)
        end
    end
    RunServiceController.BindToHeartbeat("UI.MobileButtons.UpdateVisibility", function() -- Line: 1304
        -- upvalues: Profiler (upval), u284 (upval), GetDesiredFrameVisibility (upval), LocalPlayer (upval)
        -- upvalues: u313 (upval), UpdateButtonVisibilityForSpectate (upval), IsInBuyArea (upval)
        -- upvalues: TutorialPurchaseLock (upval), u268 (upval), IsTutorialMode (upval), UpdateInteractButton (upval)
        -- upvalues: UpdateInspectButton (upval), SpectateController (upval), InventoryController (upval)
        -- upvalues: CanDropCurrentEquipped (upval), UpdatePingButton (upval), HasAlternativeAction (upval)
        -- upvalues: UpdateToggledIndicators (upval)
        local v1
        Profiler.mark("UI.MobileButtons.Heartbeat")
        if u284 then
            local v2 = GetDesiredFrameVisibility(nil)
            local Visible = u284.Visible
            u284.Visible = v2
            v1 = LocalPlayer:GetAttribute("IsSpectating") == true
            if v2 then
                if not Visible or u313 ~= v1 then
                    UpdateButtonVisibilityForSpectate(v1)
                end
            end
            u313 = v1
        end
        if not u284.Visible then
            return
        end
        local v3 = not (LocalPlayer:GetAttribute("IsSpectating") == true)
        if v3 then
            v3 = false
            if LocalPlayer:GetAttribute("BuyMenu") == true then
                v3 = IsInBuyArea(LocalPlayer) and not TutorialPurchaseLock.isBuyMenuLocked(LocalPlayer)
            end
        end
        local Shop = u284:FindFirstChild("Shop")
        if Shop then
            Shop.Visible = v3 and not u268.Shop
        end
        if IsTutorialMode() then
            local Menu = u284:FindFirstChild("Menu")
            if Menu then
                Menu.Visible = false
            end
        end
        UpdateInteractButton()
        UpdateInspectButton()
        if not SpectateController.IsLocalPlayerDead() then
            v3 = InventoryController.getCurrentEquipped()
            v1 = false
            if v3 ~= nil then
                v1 = v3.Properties.Class == "Weapon"
            end
            local Reload_2 = u284:FindFirstChild("Reload")
            if Reload_2 then
                Reload_2.Visible = v1 and not u268.Reload
            end
        else
            local Reload = u284:FindFirstChild("Reload")
            if Reload then
                Reload.Visible = false
            end
        end
        v3 = CanDropCurrentEquipped(InventoryController.getCurrentEquipped())
        local Drop = u284:FindFirstChild("Drop")
        if Drop then
            Drop.Visible = v3 and not u268.Drop
        end
        UpdatePingButton()
        if not SpectateController.IsLocalPlayerDead() then
            v3 = HasAlternativeAction(InventoryController.getCurrentEquipped())
            local AlternativeAction_2 = u284:FindFirstChild("AlternativeAction")
            if AlternativeAction_2 then
                AlternativeAction_2.Visible = v3 and not u268.AlternativeAction
            end
        else
            local AlternativeAction = u284:FindFirstChild("AlternativeAction")
            if AlternativeAction then
                AlternativeAction.Visible = false
            end
        end
        UpdateToggledIndicators()
    end)
    UserInputService.InputChanged:Connect(function(a1) -- Line: 1328
        -- upvalues: u259 (upval), u260 (upval), u262 (upval), CameraInput (upval)
        if a1 == u259 or a1 == u260 or a1 == u262 then
            CameraInput.addTouchMove(Vector2.new(a1.Delta.X, a1.Delta.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(a1) -- Line: 1335
        -- upvalues: u259 (upval), u208 (ref), MobileAutoShootController (upval), TweenButtonToRestingScale (upval)
        -- upvalues: u284 (upval), Promise (upval), InventoryController (upval), u260 (upval), GameState (upval)
        -- upvalues: u261 (upval), u266 (upval), ProcessEndInteract (val)
        local v1 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if v1 then
            if a1 == u259 then
                u259 = nil
                if u208 then
                    u208 = false
                    MobileAutoShootController.SetManualFireHeld(false)
                    TweenButtonToRestingScale(u284.Shoot, 1)
                    ;((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
                        local v1 = InventoryController.getCurrentEquipped()
                        if v1 then
                            a1(v1)
                            return
                        end
                        a2("Failed to fetch current equipped")
                    end)):catch(warn)):andThen(function(a1) -- Line: 834
                        if not a1 then
                            return
                        end
                        if a1.Properties.Class ~= "Weapon" then
                            if a1.Properties.Class == "Melee" then
                                a1.IsFireHeld = false
                                return
                            end
                            if a1.Properties.Class == "C4" then
                                a1:cancel()
                                return
                            end
                            if a1.Properties.Slot == "Grenade" then
                                a1:Throw("Far")
                            end
                            return
                        end
                        if a1.Properties.ShootingOptions ~= "Revolver" then
                            a1.IsFireHeld = false
                            return
                        end
                        local FireModes = a1.Properties.FireModes and a1.Properties.FireModes.Primary
                        if not FireModes or FireModes.CancelOnRelease ~= false then
                            a1:cancelRevolverCharge(false)
                            return
                        end
                        a1.IsFireHeld = false
                        a1.FireInputBinding = nil
                    end)
                end
            end
            if a1 == u260 then
                u260 = nil
                TweenButtonToRestingScale(u284.AlternativeAction, 1)
                ;((Promise.new(function(a1, a2) -- Line: 382 -- upvalues: InventoryController (upval)
                    local v1 = InventoryController.getCurrentEquipped()
                    if v1 then
                        a1(v1)
                        return
                    end
                    a2("Failed to fetch current equipped")
                end)):catch(warn)):andThen(function(a1) -- Line: 962 -- upvalues: GameState (upval)
                    if not a1 then
                        return
                    end
                    local Properties = a1.Properties
                    if Properties.ShootingOptions == "Revolver" then
                        a1:stopRevolverSecondaryFire()
                        return
                    end
                    if Properties.Slot == "Grenade" and GameState.GetState() ~= "Buy Period" then
                        if a1.ThrowStarted and not a1.ThrowFinished then
                            a1:Throw("Near")
                        end
                        return
                    end
                end)
            end
            if a1 == u261 then
                u261 = nil
                TweenButtonToRestingScale(u284.ToggleScoreboard, 1)
                local ToggleScoreboard = u284.ToggleScoreboard
                if u266[ToggleScoreboard] == a1 then
                    u266[ToggleScoreboard] = nil
                end
            end
            ProcessEndInteract(a1)
            for k, v in pairs(u266) do
                if v == a1 then
                    u266[k] = nil
                end
            end
        end
    end)
end

function u0.Start() -- Line: 1354
    -- upvalues: Profiler (val), u284 (ref), u258 (val), u265 (ref), CanPlayerUseChatService (val), LocalPlayer (val)
    -- upvalues: GetDesiredFrameVisibility (val), UpdateButtonVisibilityForSpectate (val), u313 (ref), Loadout (val)
    -- upvalues: u260 (ref), u261 (ref), Leaderboard (val), RefreshButtonVisibility (val), u281 (val), u285 (ref)
    -- upvalues: DataController (val), Mobile (val), u268 (val), ApplyMobileButtonLayout (val), u267 (val)
    debug.setmemorycategory("UI.MobileButtons.Start")
    Profiler.mark("UI.MobileButtons.Start")
    u284.Visible = false
    if u258 then
        task.spawn(function() -- Line: 1362
            -- upvalues: u265 (upval), CanPlayerUseChatService (upval), LocalPlayer (upval), u284 (upval)
            -- upvalues: GetDesiredFrameVisibility (upval), UpdateButtonVisibilityForSpectate (upval), u313 (upval)
            u265 = CanPlayerUseChatService(LocalPlayer)
            if not u284 then
                return
            end
            local v1 = GetDesiredFrameVisibility(nil)
            local Visible = u284.Visible
            u284.Visible = v1
            local v2 = LocalPlayer:GetAttribute("IsSpectating") == true
            if v1 then
                UpdateButtonVisibilityForSpectate(v2)
            end
            u313 = v2
        end)
        Loadout.Start()
        if u284 then
            local v1 = GetDesiredFrameVisibility(nil)
            local Visible = u284.Visible
            u284.Visible = v1
            local v2 = LocalPlayer:GetAttribute("IsSpectating") == true
            if v1 then
                UpdateButtonVisibilityForSpectate(v2)
            end
            u313 = v2
        end
    end
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 1375
        -- upvalues: u284 (upval), GetDesiredFrameVisibility (upval), LocalPlayer (upval)
        -- upvalues: UpdateButtonVisibilityForSpectate (upval), u313 (upval)
        if not u284 then
            return
        end
        local v1 = GetDesiredFrameVisibility(nil)
        local Visible = u284.Visible
        u284.Visible = v1
        local v2 = LocalPlayer:GetAttribute("IsSpectating") == true
        if v1 then
            UpdateButtonVisibilityForSpectate(v2)
        end
        u313 = v2
    end)
    LocalPlayer.CharacterRemoving:Connect(function(a1) -- Line: 1380
        -- upvalues: u260 (upval), u261 (upval), Leaderboard (upval), u284 (upval), GetDesiredFrameVisibility (upval)
        -- upvalues: LocalPlayer (upval), UpdateButtonVisibilityForSpectate (upval), u313 (upval)
        u260 = nil
        u261 = nil
        Leaderboard.closeFrame()
        if not u284 then
            return
        end
        local v1 = GetDesiredFrameVisibility(a1)
        local Visible = u284.Visible
        u284.Visible = v1
        local v2 = LocalPlayer:GetAttribute("IsSpectating") == true
        if v1 then
            UpdateButtonVisibilityForSpectate(v2)
        end
        u313 = v2
    end)
    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(RefreshButtonVisibility)
    local u121 = {}
    local v3 = u281
    u121[1] = "TeamSelection"
    u121[2] = table.unpack(v3)
    local v4 = u285
    if v4 then
        local Visible_2, v5, v6

        local function watchSiblingFrame(a1) -- Line: 1395
            -- upvalues: u121 (val), RefreshButtonVisibility (upval), u284 (upval), GetDesiredFrameVisibility (upval)
            -- upvalues: LocalPlayer (upval), UpdateButtonVisibilityForSpectate (upval), u313 (upval)
            if a1:IsA("GuiObject") and table.find(u121, a1.Name) then
                (a1:GetPropertyChangedSignal("Visible")):Connect(RefreshButtonVisibility)
                if not u284 then
                    return
                end
                local v1 = GetDesiredFrameVisibility(nil)
                local Visible = u284.Visible
                u284.Visible = v1
                local v2 = LocalPlayer:GetAttribute("IsSpectating") == true
                if v1 then
                    UpdateButtonVisibilityForSpectate(v2)
                end
                u313 = v2
            end
        end

        for i, j in v4:GetChildren() do
            if j:IsA("GuiObject") and table.find(u121, j.Name) then
                (j:GetPropertyChangedSignal("Visible")):Connect(RefreshButtonVisibility)
                if u284 then
                    v6 = GetDesiredFrameVisibility(nil)
                    Visible_2 = u284.Visible
                    u284.Visible = v6
                    v5 = LocalPlayer:GetAttribute("IsSpectating") == true
                    if v6 then
                        UpdateButtonVisibilityForSpectate(v5)
                    end
                    u313 = v5
                end
            end
        end
        v4.ChildAdded:Connect(watchSiblingFrame)
    end
    DataController.CreateListener(LocalPlayer, "MobileButtons", function(a1) -- Line: 1409
        -- upvalues: Mobile (upval), u268 (upval), u284 (upval), ApplyMobileButtonLayout (upval), u267 (upval)
        -- upvalues: GetDesiredFrameVisibility (upval), LocalPlayer (upval), UpdateButtonVisibilityForSpectate (upval)
        -- upvalues: u313 (upval)
        local v1
        if typeof(a1) ~= "table" then
            return
        end
        local v2 = Mobile.SanitizeLayout(a1)
        table.clear(u268)
        for k, v in pairs(v2) do
            v1 = u284:FindFirstChild(k)
            if v1 and v1:IsA("GuiObject") then
                ApplyMobileButtonLayout(v1, v)
                u267[v1] = v1.Size or v1.Size
                if not v.Enabled then
                    u268[k] = true
                end
            end
        end
        if not u284 then
            return
        end
        local v3 = GetDesiredFrameVisibility(nil)
        local Visible = u284.Visible
        u284.Visible = v3
        local v4 = LocalPlayer:GetAttribute("IsSpectating") == true
        if v3 then
            UpdateButtonVisibilityForSpectate(v4)
        end
        u313 = v4
    end)
end

return u0