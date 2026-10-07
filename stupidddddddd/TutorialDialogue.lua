-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.TutorialDialogue
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.TutorialDialogue
-- Decompile time: 33.73 ms

local playTypewriter
local v1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Tutorial = require(ReplicatedStorage.Database.Audio.Tutorial)
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips)
local Router = require(ReplicatedStorage.Database.Security.Router)
local u73 = nil
local u74 = nil
local u75 = nil
local u76 = "Hidden"
local u77 = nil
local u78 = nil
local u79 = nil
local u80 = nil
local Left = Enum.TextXAlignment.Left
local u86 = Color3.fromRGB(238, 238, 238)
local u87 = {}
local u88 = false
local u89 = false
local u90 = 0
local u91 = 0
local u92 = 0
local u93 = 0
local u94 = nil
local u95 = nil
local u96 = false
local u97 = 0
local u98 = false
local u99 = 0
local u100 = 0
local u101 = 0
local u102 = {}
local u103 = nil
local u104 = nil
local u105 = nil
local u106 = nil
local u107 = false
local u111 = UDim2.fromScale(0.5, 0.85)
local u115 = UDim2.fromScale(0, 0.03)
local u120 = Color3.fromRGB(255, 200, 70)
local u121 = nil

local function findMiddle(a1) -- Line: 110 -- types: a1: userdata?
    local Gameplay = a1 and a1:FindFirstChild("Gameplay")
    if Gameplay then
        return (Gameplay:FindFirstChild("Middle"))
    end
    return nil
end

local function findDialogueFrame(a1) -- Line: 115 -- upvalues: u73 (ref) -- types: a1: userdata?
    local v1
    if a1 and a1:IsA("GuiObject") and a1.Name == "TutorialDialogue" then
        return a1
    end
    local v2 = u73
    local Gameplay = v2 and v2:FindFirstChild("Gameplay")
    if not (if not Gameplay then nil else Gameplay:FindFirstChild("Middle")) then
        if a1 and a1:IsA("GuiObject") then
            return a1
        end
        return nil
    end
    local TutorialDialogue = v1:FindFirstChild("TutorialDialogue")
    if TutorialDialogue and TutorialDialogue:IsA("GuiObject") then
        return TutorialDialogue
    end
    if a1 and a1:IsA("GuiObject") then
        return a1
    end
    return nil
end

local function findTextLabel(a1) -- Line: 131 -- types: a1: userdata
    local Objective = a1:FindFirstChild("Objective")
    if not Objective then
        return nil
    end
    if Objective:IsA("TextLabel") then
        return Objective
    end
    if Objective:IsA("GuiObject") then
        return Objective:FindFirstChildWhichIsA("TextLabel", true)
    end
    return nil
end

local function findTabLabel(a1) -- Line: 146 -- types: a1: userdata
    local TextLabel
    for i, j in a1:GetChildren() do
        if j:IsA("Frame") and j.Name ~= "Main" then
            TextLabel = j:FindFirstChildWhichIsA("TextLabel")
            if TextLabel then
                return TextLabel
            end
        end
    end
    return nil
end

local function bindDialogue(a1) -- Line: 158
    -- upvalues: findDialogueFrame (val), u74 (ref), u75 (ref), u77 (ref), findTabLabel (val), Left (ref), u86 (ref)
    -- upvalues: u73 (ref), u78 (ref), u79 (ref), u80 (ref)
    local v1 = findDialogueFrame(a1)
    if not v1 then
        return false
    end
    if u74 ~= v1 then
        local u235, v2
        u74 = v1
        local Objective = v1:FindFirstChild("Objective")
        u75 = if Objective then if not Objective:IsA("TextLabel") then if not Objective:IsA("GuiObject") then nil else Objective:FindFirstChildWhichIsA("TextLabel", true) else Objective else nil
        u77 = findTabLabel(v1)
        for i, j in v1:GetChildren() do
            if j:IsA("ImageLabel") then
                j:Destroy()
            end
        end
        local v3 = u75
        if v3 then
            Left = v3.TextXAlignment
            u86 = v3.TextColor3
        end
        local TutorialSkipHint = v1:FindFirstChild("TutorialSkipHint")
        if TutorialSkipHint then
            TutorialSkipHint:Destroy()
        end
        local Frame = Instance.new("Frame")
        Frame.Name = "TutorialSkipHint"
        Frame.AnchorPoint = Vector2.new(1, 1)
        Frame.Position = UDim2.new(1, 0, 0, -3)
        Frame.Size = UDim2.fromScale(0.5, 0.3)
        Frame.BackgroundTransparency = 1
        Frame.Visible = false
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 6)
        UIListLayout.Parent = Frame
        local v4 = u73
        local Gameplay = v4 and v4:FindFirstChild("Gameplay")
        local v5 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
        local Tips = v5 and v5:FindFirstChild("Tips")
        local Frame_2 = Tips and Tips:FindFirstChildWhichIsA("Frame")
        local Keybind = Frame_2 and Frame_2:FindFirstChild("Keybind")
        local Title = Frame_2 and Frame_2:FindFirstChild("Title")
        if not Keybind or not Keybind:IsA("ImageButton") then
            v2 = Instance.new("ImageButton")
            v2.AutoButtonColor = false
            v2.Image = ""
            v2.BackgroundColor3 = Color3.new(1, 1, 1)
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0.15, 0)
            UICorner.Parent = v2
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "Bind"
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel.Position = UDim2.fromScale(0.5, 0.5)
            TextLabel.Size = UDim2.fromScale(0.9, 0.7)
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextScaled = true
            TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
            TextLabel.TextColor3 = Color3.new(0, 0, 0)
            TextLabel.Parent = v2
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Name = "Bind"
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
            ImageLabel.Size = UDim2.fromScale(0.9, 0.7)
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.Visible = false
            ImageLabel.Parent = v2
        else
            v2 = Keybind:Clone()
        end
        v2.Name = "Keybind"
        v2.Active = false
        v2.AnchorPoint = Vector2.zero
        v2.Position = UDim2.new()
        v2.Size = UDim2.fromScale(1, 1)
        v2.SizeConstraint = Enum.SizeConstraint.RelativeYY
        v2.LayoutOrder = 1
        v2.Visible = true
        v2.Parent = Frame
        if not Title or not Title:IsA("TextLabel") then
            u235 = Instance.new("TextLabel")
            u235.BackgroundTransparency = 1
            u235.TextColor3 = Color3.new(1, 1, 1)
            u235.TextStrokeTransparency = 0.4
            u235.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic)
        else
            u235 = Title:Clone()
        end
        u235.Name = "Label"
        u235.AnchorPoint = Vector2.zero
        u235.Position = UDim2.new()
        u235.AutomaticSize = Enum.AutomaticSize.X
        u235.Size = UDim2.fromScale(0, 1)
        u235.TextScaled = false
        u235.TextSize = 18
        u235.TextXAlignment = Enum.TextXAlignment.Left
        u235.LayoutOrder = 2
        u235.Parent = Frame
        ;(Frame:GetPropertyChangedSignal("AbsoluteSize")):Connect(function() -- Line: 268 -- upvalues: u235 (ref), Frame (val)
            u235.TextSize = math.max(math.floor(Frame.AbsoluteSize.Y * 0.72), 8)
        end)
        Frame.Parent = v1
        u78 = Frame
        u79 = v2
        u80 = u235
    end
    return u75 ~= nil
end

local u128 = false
local u129 = nil

local function onSkipAction(a1, a2) -- Line: 282 -- upvalues: u129 (ref) -- types: a1: string
    if a2 == Enum.UserInputState.Begin then
        u129()
    end
    return Enum.ContextActionResult.Sink
end

local function refreshSkipHint() -- Line: 290 -- upvalues: u79 (ref), u80 (ref), UserInputService (val), Tips (val)
    local v1 = u79
    local v2 = u80
    if v1 and v2 then
        local v3 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
        local DPadUp = if not Tips.IsGamepadPreferred() then Enum.KeyCode.E else Enum.KeyCode.DPadUp
        v1.Visible = not v3 and Tips.ApplyBindingToKeybind(v1, DPadUp)
        v2.Text = if not v3 then "Skip" else "Tap here to skip"
        return
    end
end

local function updateSkipHint() -- Line: 302
    -- upvalues: u78 (ref), u76 (ref), u98 (ref), LocalPlayer (val), refreshSkipHint (val), u128 (ref)
    -- upvalues: ContextActionService (val), onSkipAction (val)
    local v1 = u78
    if not v1 then
        return
    end
    local v2 = false
    if u76 == "Commander" then
        v2 = u98 and LocalPlayer:GetAttribute("TutorialStep") ~= "DefuseB"
    end
    v1.Visible = v2
    if v2 then
        refreshSkipHint()
    end
    if v2 and not u128 then
        u128 = true
        ContextActionService:BindActionAtPriority(
            "TutorialSkipDialogue",
            onSkipAction,
            false,
            Enum.ContextActionPriority.High.Value,
            Enum.KeyCode.E,
            Enum.KeyCode.DPadUp
        )
        return
    end
    if not v2 and u128 then
        u128 = false
        ContextActionService:UnbindAction("TutorialSkipDialogue")
    end
end

local function setMode(a1) -- Line: 329
    -- upvalues: u76 (ref), u87 (val), updateSkipHint (val), u77 (ref), u75 (ref), Left (ref), u86 (ref)
    u76 = a1
    for i, j in u87 do
        j:Cancel()
    end
    table.clear(u87)
    if a1 == "Hidden" then
        updateSkipHint()
        return
    end
    local v1 = a1 == "Objective"
    if u77 then
        u77.Text = if not v1 then "COMMANDER" else "OBJECTIVE"
    end
    local v2 = u75
    if v2 then
        v2.TextXAlignment = if not v1 then Left else Enum.TextXAlignment.Center
        v2.TextColor3 = u86
    end
    updateSkipHint()
end

local function stopDialogueAudio() -- Line: 351 -- upvalues: u105 (ref)
    local v1 = u105
    u105 = nil
    if v1 then
        v1:Stop()
        v1:Destroy()
    end
end

local function createVoiceSound(a1, a2) -- Line: 360
    -- upvalues: DataController (val), LocalPlayer (val), SoundService (val)
    local Sound = Instance.new("Sound")
    Sound.Name = "TutorialDialogueVoice"
    Sound.SoundId = a1
    Sound.Volume = (tonumber((DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume"))) or 100) / 100
    Sound.Looped = false
    local Gameplay = SoundService:FindFirstChild("Gameplay")
    if Gameplay and Gameplay:IsA("SoundGroup") then
        Sound.SoundGroup = Gameplay
    end
    if a2 then
        Sound.PlaybackRegionsEnabled = true
        Sound.PlaybackRegion = a2
    end
    Sound.Parent = SoundService
    return Sound
end

local function isTrailingOff(a1) -- Line: 379 -- types: a1: userdata
    local TimeLength = a1.TimeLength
    if TimeLength <= 0 then
        return false
    end
    local v1 = if not a1.PlaybackRegionsEnabled then TimeLength else math.min(a1.PlaybackRegion.Max, TimeLength)
    local v2 = false
    if v1 - a1.TimePosition <= 0.8 then
        v2 = a1.PlaybackLoudness <= 6
    end
    return v2
end

local u137 = false

local function preloadVoices() -- Line: 391
    -- upvalues: u137 (ref), Tutorial (val), SoundService (val), ContentProvider (val)
    local Sound, audioId
    if u137 then
        return
    end
    u137 = true
    local Folder = Instance.new("Folder")
    Folder.Name = "TutorialVoicePreload"
    local u41 = {}
    local v1 = {}
    local v2 = nil
    local v3 = nil
    for i, j in Tutorial, v2, v3 do
        audioId = if typeof(j) ~= "table" then nil else j.audioId
        if typeof(audioId) == "string" and not v1[audioId] then
            v1[audioId] = true
            Sound = Instance.new("Sound")
            Sound.SoundId = audioId
            Sound.Parent = Folder
            table.insert(u41, Sound)
        end
    end
    Folder.Parent = SoundService
    task.spawn(function() -- Line: 412 -- upvalues: ContentProvider (upval), u41 (val)
        pcall(ContentProvider.PreloadAsync, ContentProvider, u41)
    end)
end

local function waitForVoiceSound(a1) -- Line: 422 -- types: a1: userdata
    local v1 = os.clock() + 2
    while not a1.IsLoaded do
        if not (os.clock() < v1) then
            break
        end
        task.wait(0.05)
    end
end

local function resolveCommanderLine(a1) -- Line: 434 -- upvalues: Tutorial (val) -- types: a1: string
    local v1 = Tutorial[a1]
    if typeof(v1) == "table" and typeof(v1.text) == "string" then
        local audioId = v1.audioId
        local v2 = if typeof(audioId) ~= "string" then nil else audioId
        local region = v1.region
        local v3 = if typeof(region) ~= "table" then nil else NumberRange.new(region[1], region[2])
        local pages = v1.pages
        if typeof(pages) == "table" and #pages > 0 then
            return (table.clone(pages)), v2, v3
        end
        return {v1.text}, v2, v3
    end
    return {a1}, nil, nil
end

local function reportCommanderIdle() -- Line: 450 -- upvalues: u99 (ref), u100 (ref), Remotes (val)
    if u99 <= u100 then
        return
    end
    u100 = u99
    Remotes.Tutorial.ClientEvent.Send((("CommanderIdle:%*"):format(u99)))
end

local function isMenuOpen() -- Line: 458 -- upvalues: u73 (ref)
    local Menu = u73 and u73:FindFirstChild("Menu")
    local Visible = false
    if Menu ~= nil then
        Visible = Menu:IsA("GuiObject") and Menu.Visible
    end
    return Visible
end

local function isGameplayVisible() -- Line: 463 -- upvalues: u73 (ref)
    local Gameplay = u73 and u73:FindFirstChild("Gameplay")
    local Visible = false
    if Gameplay ~= nil then
        Visible = Gameplay:IsA("GuiObject") and Gameplay.Visible
    end
    return Visible
end

local function hasPlayingTeam() -- Line: 468 -- upvalues: LocalPlayer (val)
    local Attribute = LocalPlayer:GetAttribute("Team")
    local v1 = true
    if Attribute ~= "Terrorists" then
        v1 = Attribute == "Counter-Terrorists"
    end
    return v1
end

local function shouldShowDialogue() -- Line: 473
    -- upvalues: IsTutorialMode (val), u73 (ref), GameState (val), LocalPlayer (val)
    if IsTutorialMode() and workspace:GetAttribute("TutorialActive") == true then
        local Menu = u73 and u73:FindFirstChild("Menu")
        local Visible = false
        if Menu ~= nil then
            Visible = Menu:IsA("GuiObject") and Menu.Visible
        end
        if not Visible then
            local Gameplay = u73 and u73:FindFirstChild("Gameplay")
            local Visible_2 = false
            if Gameplay ~= nil then
                Visible_2 = Gameplay:IsA("GuiObject") and Gameplay.Visible
            end
            if Visible_2 then
                local v1 = GameState.GetState()
                if v1 ~= "Game Ending" and v1 ~= "Map Voting" then
                    local Attribute = LocalPlayer:GetAttribute("Team")
                    local v2 = true
                    if Attribute ~= "Terrorists" then
                        v2 = Attribute == "Counter-Terrorists"
                    end
                    return v2
                end
                return false
            end
        end
        return false
    end
    return false
end

local function liftNotifications(a1) -- Line: 488
    -- upvalues: u73 (ref), u121 (ref), u74 (ref), u77 (ref)
    local v1 = u73
    local Gameplay = v1 and v1:FindFirstChild("Gameplay")
    local v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
    local Notification = v2 and v2:FindFirstChild("Notification")
    if Notification and Notification:IsA("GuiObject") then
        local Position = u121 or Notification.Position
        u121 = Position
        Notification.Position = Position
        local v3 = u74
        if a1 and v3 then
            local Y = v3.AbsolutePosition.Y
            local Parent = u77 and u77.Parent
            if Parent and Parent:IsA("GuiObject") then
                Y = math.min(Y, Parent.AbsolutePosition.Y)
            end
            local v4 = Notification.AbsolutePosition.Y + Notification.AbsoluteSize.Y + 6 - Y
            if v4 > 0 then
                Notification.Position = Position - UDim2.fromOffset(0, v4)
            end
            return
        end
        return
    end
end

local function hideBox() -- Line: 512
    -- upvalues: u76 (ref), u87 (val), updateSkipHint (val), u74 (ref), u73 (ref), u121 (ref)
    u76 = "Hidden"
    for i, j in u87 do
        j:Cancel()
    end
    table.clear(u87)
    updateSkipHint()
    if u74 then
        u74.Visible = false
    end
    local v1 = u73
    local Gameplay = v1 and v1:FindFirstChild("Gameplay")
    local v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
    local Notification = v2 and v2:FindFirstChild("Notification")
    if Notification then
        if not Notification:IsA("GuiObject") then
            return
        end
        local Position = u121 or Notification.Position
        u121 = Position
        Notification.Position = Position
    end
end

local function clearObjective() -- Line: 521
    -- upvalues: u93 (ref), u97 (ref), u96 (ref), u94 (ref), u95 (ref), u76 (ref), u87 (val), updateSkipHint (val)
    -- upvalues: u74 (ref), u73 (ref), u121 (ref)
    u93 = u93 + 1
    u97 = u97 + 1
    u96 = false
    u94 = nil
    u95 = nil
    if u76 == "Objective" then
        u76 = "Hidden"
        for i, j in u87 do
            j:Cancel()
        end
        table.clear(u87)
        updateSkipHint()
        if u74 then
            u74.Visible = false
        end
        local v1 = u73
        local Gameplay = v1 and v1:FindFirstChild("Gameplay")
        local v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
        local Notification = v2 and v2:FindFirstChild("Notification")
        if Notification then
            if not Notification:IsA("GuiObject") then
                return
            end
            local Position = u121 or Notification.Position
            u121 = Position
            Notification.Position = Position
        end
    end
end

local function hideDialogue() -- Line: 533
    -- upvalues: u92 (ref), u98 (ref), u102 (val), u103 (ref), u104 (ref), u105 (ref), u88 (ref), u89 (ref), u90 (ref)
    -- upvalues: u93 (ref), u97 (ref), u96 (ref), u94 (ref), u95 (ref), u76 (ref), u87 (val), updateSkipHint (val)
    -- upvalues: u74 (ref), u73 (ref), u121 (ref)
    local v1, v2
    u92 = u92 + 1
    if u98 or #u102 > 0 then
        v1 = {}
        if u103 then
            table.insert(v1, u103)
        end
        table.move(u102, 1, #u102, #v1 + 1, v1)
        if #v1 > 0 then
            u104 = v1
        end
    end
    v1 = u105
    u105 = nil
    if v1 then
        v1:Stop()
        v1:Destroy()
    end
    u103 = nil
    u98 = false
    u88 = false
    u89 = false
    u90 = u90 + 1
    table.clear(u102)
    u93 = u93 + 1
    u97 = u97 + 1
    u96 = false
    u94 = nil
    u95 = nil
    if u76 == "Objective" then
        u76 = "Hidden"
        for i, j in u87 do
            j:Cancel()
        end
        table.clear(u87)
        updateSkipHint()
        if u74 then
            u74.Visible = false
        end
        v2 = u73
        local Gameplay = v2 and v2:FindFirstChild("Gameplay")
        v1 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
        local Notification = v1 and v1:FindFirstChild("Notification")
        if Notification and Notification:IsA("GuiObject") then
            local Position = u121 or Notification.Position
            u121 = Position
            Notification.Position = Position
        end
    end
    u76 = "Hidden"
    for k, n in u87 do
        n:Cancel()
    end
    table.clear(u87)
    updateSkipHint()
    if u74 then
        u74.Visible = false
    end
    v2 = u73
    local Gameplay_2 = v2 and v2:FindFirstChild("Gameplay")
    v1 = if not Gameplay_2 then nil else Gameplay_2:FindFirstChild("Middle")
    local Notification_2 = v1 and v1:FindFirstChild("Notification")
    if Notification_2 then
        if not Notification_2:IsA("GuiObject") then
            return
        end
        local Position_2 = u121 or Notification_2.Position
        u121 = Position_2
        Notification_2.Position = Position_2
    end
end

local function findBuyMenu() -- Line: 557 -- upvalues: u73 (ref)
    local v1 = u73
    local Gameplay = v1 and v1:FindFirstChild("Gameplay")
    local v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
    local BuyMenu = v2 and v2:FindFirstChild("BuyMenu")
    if BuyMenu and BuyMenu:IsA("GuiObject") then
        return BuyMenu
    end
    return nil
end

local function restPosition() -- Line: 563 -- upvalues: u73 (ref), u111 (val), u115 (val)
    local v1 = u73
    local Gameplay = v1 and v1:FindFirstChild("Gameplay")
    local v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
    local BuyMenu = v2 and v2:FindFirstChild("BuyMenu")
    local v3 = if not BuyMenu then nil else if not BuyMenu:IsA("GuiObject") then nil else BuyMenu
    if v3 and v3.Visible then
        return u111 + u115
    end
    return u111
end

local function showDialogue() -- Line: 571
    -- upvalues: shouldShowDialogue (val), hideDialogue (val), u74 (ref), u73 (ref), u111 (val), u115 (val)
    -- upvalues: liftNotifications (val)
    if not shouldShowDialogue() then
        hideDialogue()
        return
    end
    if u74 then
        local v1 = u74
        local v2 = u73
        local Gameplay = v2 and v2:FindFirstChild("Gameplay")
        local v3 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
        local BuyMenu = v3 and v3:FindFirstChild("BuyMenu")
        local v4 = if not BuyMenu then nil else if not BuyMenu:IsA("GuiObject") then nil else BuyMenu
        v1.Position = if not v4 then u111 else if not v4.Visible then u111 else u111 + u115
        u74.Visible = true
        liftNotifications(true)
    end
end

function v1.IsDialogueName(a1) -- Line: 106 -- types: a1: string
    return a1 == "TutorialDialogue"
end

function v1.IsActive() -- Line: 585 -- upvalues: u98 (ref)
    return u98
end

local function utf8Len(a1) -- Line: 589 -- types: a1: string
    local success, result = pcall(utf8.len, a1)
    if success and typeof(result) == "number" then
        return result
    end
    return #a1
end

local u155 = nil
local u156 = nil
local u157 = nil

local function returnToObjective() -- Line: 603
    -- upvalues: u96 (ref), u89 (ref), u94 (ref), shouldShowDialogue (val), u156 (ref), u76 (ref), u87 (val)
    -- upvalues: updateSkipHint (val), u74 (ref), u73 (ref), u121 (ref)
    if not u96 and not u89 then
        if u94 and shouldShowDialogue() then
            u156(false)
            return
        end
        u76 = "Hidden"
        for i, j in u87 do
            j:Cancel()
        end
        table.clear(u87)
        updateSkipHint()
        if u74 then
            u74.Visible = false
        end
        local v1 = u73
        local Gameplay = v1 and v1:FindFirstChild("Gameplay")
        local v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
        local Notification = v2 and v2:FindFirstChild("Notification")
        if Notification then
            if not Notification:IsA("GuiObject") then
                return
            end
            local Position = u121 or Notification.Position
            u121 = Position
            Notification.Position = Position
        end
        return
    end
end

local function finishCommander(a1) -- Line: 616
    -- upvalues: u103 (ref), u98 (ref), updateSkipHint (val), u99 (ref), u100 (ref), Remotes (val), LocalPlayer (val)
    -- upvalues: u96 (ref), u157 (ref), u88 (ref), u91 (ref), u92 (ref), u89 (ref), u94 (ref), shouldShowDialogue (val)
    -- upvalues: u156 (ref), u76 (ref), u87 (val), u74 (ref), u73 (ref), u121 (ref)
    local Gameplay, Notification, Position, v1, v2, v3
    u103 = nil
    u98 = false
    updateSkipHint()
    if not (u99 <= u100) then
        u100 = u99
        Remotes.Tutorial.ClientEvent.Send((("CommanderIdle:%*"):format(u99)))
    end
    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderId")
    if not u96 then
        u88 = true
        u91 = u91 + 1
        v1 = u91
        task.wait(0.25)
        if v1 == u91 then
            u88 = false
        end
        if a1 == u92 and not u98 and not u96 then
            if u89 then
                return
            end
            if u94 and shouldShowDialogue() then
                u156(false)
                return
            end
            u76 = "Hidden"
            for k, n in u87 do
                n:Cancel()
            end
            table.clear(u87)
            updateSkipHint()
            if u74 then
                u74.Visible = false
            end
            v3 = u73
            Gameplay = v3 and v3:FindFirstChild("Gameplay")
            v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
            Notification = v2 and v2:FindFirstChild("Notification")
            if Notification then
                if not Notification:IsA("GuiObject") then
                    return
                end
                Position = u121 or Notification.Position
                u121 = Position
                Notification.Position = Position
            end
        end
        return
    end
    if typeof(Attribute) == "number" and Attribute ~= u99 then
        u88 = true
        u91 = u91 + 1
        v1 = u91
        task.wait(0.25)
        if v1 == u91 then
            u88 = false
        end
        if a1 == u92 and not u98 and not u96 then
            if u89 then
                return
            end
            if u94 and shouldShowDialogue() then
                u156(false)
                return
            end
            u76 = "Hidden"
            for i, j in u87 do
                j:Cancel()
            end
            table.clear(u87)
            updateSkipHint()
            if u74 then
                u74.Visible = false
            end
            v3 = u73
            Gameplay = v3 and v3:FindFirstChild("Gameplay")
            v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
            Notification = v2 and v2:FindFirstChild("Notification")
            if Notification then
                if not Notification:IsA("GuiObject") then
                    return
                end
                Position = u121 or Notification.Position
                u121 = Position
                Notification.Position = Position
            end
        end
        return
    end
    u157()
end

function playTypewriter(a1, a2) -- Line: 639
    -- upvalues: bindDialogue (val), u74 (ref), u75 (ref), u92 (ref), u98 (ref), u88 (ref), u89 (ref), u90 (ref)
    -- upvalues: u93 (ref), setMode (val), shouldShowDialogue (val), hideDialogue (val), u73 (ref), u111 (val)
    -- upvalues: u115 (val), liftNotifications (val), playTypewriter (val), u105 (ref), u102 (val), u155 (ref)
    -- upvalues: finishCommander (val)
    if not bindDialogue(u74) then
        return
    end
    local v1 = u75
    if u74 and v1 then
        local TimeLength, v2, v3, v4
        u92 = u92 + 1
        local v5 = u92
        u98 = true
        u88 = false
        u89 = false
        u90 = u90 + 1
        u93 = u93 + 1
        setMode("Commander")
        if not shouldShowDialogue() then
            hideDialogue()
        elseif u74 then
            local v6 = u74
            local v7 = u73
            local Gameplay = v7 and v7:FindFirstChild("Gameplay")
            v3 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
            local BuyMenu = v3 and v3:FindFirstChild("BuyMenu")
            v2 = if not BuyMenu then nil else if not BuyMenu:IsA("GuiObject") then nil else BuyMenu
            v6.Position = if not v2 then u111 else if not v2.Visible then u111 else u111 + u115
            u74.Visible = true
            liftNotifications(true)
        end
        v1.Text = a1
        v1.MaxVisibleGraphemes = 0
        local success, result = pcall(utf8.len, a1)
        local v8 = if not success then #a1 else if typeof(result) ~= "number" then #a1 else result
        for i = 1, v8 do
            if v5 ~= u92 then
                return
            end
            v1.MaxVisibleGraphemes = i
            task.wait(0.035)
        end
        if v5 ~= u92 then
            return
        end
        v1.MaxVisibleGraphemes = -1
        if a2 and #a2 > 0 then
            v8 = table.remove(a2, 1)
            task.wait(1.25)
            if v5 == u92 and typeof(v8) == "string" then
                playTypewriter(v8, a2)
                return
            end
            return
        end
        v8 = nil
        while v5 == u92 do
            v2 = u105
            if not v2 or not v2.IsPlaying then
                break
            end
            TimeLength = v2.TimeLength
            if not (TimeLength <= 0) then
                v4 = if not v2.PlaybackRegionsEnabled then TimeLength else math.min(v2.PlaybackRegion.Max, TimeLength)
                v3 = false
                if v4 - v2.TimePosition <= 0.8 then
                    v3 = v2.PlaybackLoudness <= 6
                end
            else
                v3 = false
            end
            if v3 then
                v3 = v8 or os.clock()
                if 0.2 <= os.clock() - v3 then
                    break
                end
            end
            task.wait(0.03)
        end
        if v5 ~= u92 then
            return
        end
        if #u102 > 0 then
            u155()
            return
        end
        finishCommander(v5)
        return
    end
end

function u155() -- Line: 718
    -- upvalues: u102 (val), u103 (ref), resolveCommanderLine (val), u92 (ref), u98 (ref), u105 (ref), u106 (ref)
    -- upvalues: u107 (ref), playTypewriter (val), createVoiceSound (val), waitForVoiceSound (val)
    local v1 = table.remove(u102, 1)
    if typeof(v1) == "string" and v1 ~= "" then
        u103 = v1
        local v2, v3, v4 = resolveCommanderLine(v1)
        local v5 = table.remove(v2, 1)
        if typeof(v5) ~= "string" then
            return
        end
        u92 = u92 + 1
        local v6 = u92
        u98 = true
        local v7 = u105
        u105 = nil
        if v7 then
            v7:Stop()
            v7:Destroy()
        end
        if u106 and not u107 then
            u106:Stop()
        end
        v7 = os.clock() + 6
        while u106 do
            if not u106.IsPlaying or not (os.clock() < v7) then
                break
            end
            task.wait(0.05)
        end
        if v6 ~= u92 then
            return
        end
        if typeof(v3) == "string" and v3 ~= "" then
            local u68 = createVoiceSound(v3, v4)
            waitForVoiceSound(u68)
            if v6 ~= u92 then
                u68:Destroy()
                return
            end
            u105 = u68
            u68:Play()
            u68.Ended:Once(function() -- Line: 765 -- upvalues: u105 (upval), u68 (val)
                if u105 == u68 then
                    u105 = nil
                    u68:Destroy()
                end
            end)
            playTypewriter(v5, v2)
            return
        end
        playTypewriter(v5, v2)
        return
    end
end

function u129() -- Line: 775
    -- upvalues: u98 (ref), shouldShowDialogue (val), u105 (ref), u92 (ref), u102 (val), u155 (ref), u103 (ref)
    -- upvalues: u88 (ref), u99 (ref), u100 (ref), Remotes (val), u96 (ref), u89 (ref), u94 (ref), u156 (ref), u76 (ref)
    -- upvalues: u87 (val), updateSkipHint (val), u74 (ref), u73 (ref), u121 (ref)
    if u98 and shouldShowDialogue() then
        local v1 = u105
        u105 = nil
        if v1 then
            v1:Stop()
            v1:Destroy()
        end
        u92 = u92 + 1
        if #u102 > 0 then
            task.spawn(u155)
            return
        end
        u103 = nil
        u98 = false
        u88 = false
        if not (u99 <= u100) then
            u100 = u99
            Remotes.Tutorial.ClientEvent.Send((("CommanderIdle:%*"):format(u99)))
        end
        if not u96 then
            if u89 then
                return
            end
            if u94 and shouldShowDialogue() then
                u156(false)
                return
            end
            u76 = "Hidden"
            for i, j in u87 do
                j:Cancel()
            end
            table.clear(u87)
            updateSkipHint()
            if u74 then
                u74.Visible = false
            end
            local v2 = u73
            local Gameplay = v2 and v2:FindFirstChild("Gameplay")
            v1 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
            local Notification = v1 and v1:FindFirstChild("Notification")
            if Notification then
                if not Notification:IsA("GuiObject") then
                    return
                end
                local Position = u121 or Notification.Position
                u121 = Position
                Notification.Position = Position
            end
        end
        return
    end
end

local function flashObjective() -- Line: 793
    -- upvalues: u75 (ref), u120 (val), TweenService (val), u86 (ref), u87 (val)
    local v1 = u75
    if not v1 then
        return
    end
    local v2 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    v1.TextColor3 = u120
    local v3 = TweenService:Create(v1, v2, {TextColor3 = u86})
    table.insert(u87, v3)
    v3:Play()
end

local function typeObjective(a1) -- Line: 805
    -- upvalues: u75 (ref), u93 (ref), flashObjective (val), u76 (ref)
    local v1 = u75
    if not v1 then
        return
    end
    u93 = u93 + 1
    local v2 = u93
    v1.Text = a1
    v1.MaxVisibleGraphemes = 0
    flashObjective()
    local success, result = pcall(utf8.len, a1)
    for i = 1, if not success then #a1 else if typeof(result) ~= "number" then #a1 else result do
        if v2 == u93 and u76 == "Objective" then
            continue
        end
        return
    end
    if v2 == u93 and u76 == "Objective" then
        v1.MaxVisibleGraphemes = -1
    end
end

function u156(a1) -- Line: 828
    -- upvalues: u94 (ref), u75 (ref), u96 (ref), u98 (ref), u88 (ref), u89 (ref), shouldShowDialogue (val)
    -- upvalues: setMode (val), hideDialogue (val), u74 (ref), u73 (ref), u111 (val), u115 (val)
    -- upvalues: liftNotifications (val), typeObjective (val), u93 (ref)
    local v1 = u94
    local v2 = u75
    if v1 and v2 and not u96 and not u98 and not u88 and not u89 then
        if not shouldShowDialogue() then
            return
        end
        setMode("Objective")
        if not shouldShowDialogue() then
            hideDialogue()
        elseif u74 then
            local v3 = u74
            local v4 = u73
            local Gameplay = v4 and v4:FindFirstChild("Gameplay")
            local v5 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
            local BuyMenu = v5 and v5:FindFirstChild("BuyMenu")
            local v6 = if not BuyMenu then nil else if not BuyMenu:IsA("GuiObject") then nil else BuyMenu
            v3.Position = if not v6 then u111 else if not v6.Visible then u111 else u111 + u115
            u74.Visible = true
            liftNotifications(true)
        end
        if a1 then
            task.spawn(typeObjective, v1)
            return
        end
        u93 = u93 + 1
        v2.Text = v1
        v2.MaxVisibleGraphemes = -1
        return
    end
end

local function isCommanderBusy() -- Line: 849
    -- upvalues: LocalPlayer (val), u98 (ref), u88 (ref), u89 (ref), u102 (val), u99 (ref)
    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderId")
    local v1 = u98
    if not v1 then
        v1 = u88
        if not v1 then
            v1 = u89
            if not v1 then
                v1 = true
                if not (#u102 > 0) then
                    v1 = false
                    if typeof(Attribute) == "number" then
                        v1 = Attribute ~= u99
                    end
                end
            end
        end
    end
    return v1
end

local function showTip(a1) -- Line: 859
    -- upvalues: u75 (ref), u98 (ref), shouldShowDialogue (val), u90 (ref), u89 (ref), u93 (ref), setMode (val)
    -- upvalues: hideDialogue (val), u74 (ref), u73 (ref), u111 (val), u115 (val), liftNotifications (val), u96 (ref)
    -- upvalues: u94 (ref), u156 (ref), u76 (ref), u87 (val), updateSkipHint (val), u121 (ref)
    local v1 = u75
    if v1 and not u98 and shouldShowDialogue() then
        local v2, v3
        u90 = u90 + 1
        local v4 = u90
        u89 = true
        u93 = u93 + 1
        setMode("Commander")
        if not shouldShowDialogue() then
            hideDialogue()
        elseif u74 then
            v2 = u74
            local v5 = u73
            local Gameplay = v5 and v5:FindFirstChild("Gameplay")
            local v6 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
            local BuyMenu = v6 and v6:FindFirstChild("BuyMenu")
            v3 = if not BuyMenu then nil else if not BuyMenu:IsA("GuiObject") then nil else BuyMenu
            v2.Position = if not v3 then u111 else if not v3.Visible then u111 else u111 + u115
            u74.Visible = true
            liftNotifications(true)
        end
        v1.Text = a1
        v1.MaxVisibleGraphemes = 0
        v2 = os.clock()
        local success, result = pcall(utf8.len, a1)
        for i = 1, if not success then #a1 else if typeof(result) ~= "number" then #a1 else result do
            if v4 ~= u90 then
                return
            end
            v1.MaxVisibleGraphemes = i
            task.wait(0.035)
        end
        if v4 ~= u90 then
            return
        end
        v1.MaxVisibleGraphemes = -1
        task.wait((math.max(4 - (os.clock() - v2), 0)))
        if v4 == u90 then
            u89 = false
            if not u96 then
                if u89 then
                    return
                end
                if u94 and shouldShowDialogue() then
                    u156(false)
                    return
                end
                u76 = "Hidden"
                for j, k in u87 do
                    k:Cancel()
                end
                table.clear(u87)
                updateSkipHint()
                if u74 then
                    u74.Visible = false
                end
                v3 = u73
                local Gameplay_2 = v3 and v3:FindFirstChild("Gameplay")
                local v7 = if not Gameplay_2 then nil else Gameplay_2:FindFirstChild("Middle")
                local Notification = v7 and v7:FindFirstChild("Notification")
                if Notification then
                    if not Notification:IsA("GuiObject") then
                        return
                    end
                    local Position = u121 or Notification.Position
                    u121 = Position
                    Notification.Position = Position
                end
            end
        end
        return
    end
end

local function holdObjective() -- Line: 892
    -- upvalues: u96 (ref), u97 (ref), u93 (ref), u76 (ref), u87 (val), updateSkipHint (val), u74 (ref), u73 (ref)
    -- upvalues: u121 (ref), LocalPlayer (val), u98 (ref), u88 (ref), u89 (ref), u102 (val), u99 (ref), u156 (ref)
    u96 = true
    u97 = u97 + 1
    local u3 = u97
    u93 = u93 + 1
    if u76 == "Objective" then
        u76 = "Hidden"
        for i, j in u87 do
            j:Cancel()
        end
        table.clear(u87)
        updateSkipHint()
        if u74 then
            u74.Visible = false
        end
        local v1 = u73
        local Gameplay = v1 and v1:FindFirstChild("Gameplay")
        local v2 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
        local Notification = v2 and v2:FindFirstChild("Notification")
        if Notification and Notification:IsA("GuiObject") then
            local Position = u121 or Notification.Position
            u121 = Position
            Notification.Position = Position
        end
    end
    local u59 = os.clock()
    task.spawn(function() -- Line: 902
        -- upvalues: u3 (val), u97 (upval), LocalPlayer (upval), u98 (upval), u88 (upval), u89 (upval), u102 (upval)
        -- upvalues: u99 (upval), u59 (val), u96 (upval), u156 (upval)
        local Attribute, v1
        task.wait(0.3)
        while u3 == u97 do
            Attribute = LocalPlayer:GetAttribute("TutorialCommanderId")
            v1 = u98
            if not v1 then
                v1 = u88
                if not v1 then
                    v1 = u89
                    if not v1 then
                        v1 = true
                        if not (#u102 > 0) then
                            v1 = false
                            if typeof(Attribute) == "number" then
                                v1 = Attribute ~= u99
                            end
                        end
                    end
                end
            end
            if v1 and not (45 < os.clock() - u59) then
                task.wait(0.1)
                continue
            end
            u96 = false
            u156(true)
            return
        end
    end)
end

local function syncObjective() -- Line: 916
    -- upvalues: shouldShowDialogue (val), hideDialogue (val), bindDialogue (val), u74 (ref), LocalPlayer (val)
    -- upvalues: u93 (ref), u97 (ref), u96 (ref), u94 (ref), u95 (ref), u76 (ref), u87 (val), updateSkipHint (val)
    -- upvalues: u73 (ref), u121 (ref), u156 (ref), holdObjective (val)
    local v1, v2
    if not shouldShowDialogue() then
        hideDialogue()
        return
    end
    if not bindDialogue(u74) then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("TutorialObjective")
    local Attribute_2 = LocalPlayer:GetAttribute("TutorialStep")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        v1 = if typeof(Attribute_2) ~= "string" then "" else Attribute_2
        if Attribute == u94 then
            if u76 == "Hidden" then
                u156(false)
            end
            return
        end
        v2 = v1 ~= u95
        local v3 = u94
        local v4 = (string.gsub(Attribute, "%d", "")) ~= string.gsub(v3 or "", "%d", "")
        u94 = Attribute
        u95 = v1
        if v2 then
            holdObjective()
            return
        end
        if not u96 and u76 ~= "Commander" then
            u156(v4)
            return
        end
        return
    end
    u93 = u93 + 1
    u97 = u97 + 1
    u96 = false
    u94 = nil
    u95 = nil
    if u76 == "Objective" then
        u76 = "Hidden"
        for i, j in u87 do
            j:Cancel()
        end
        table.clear(u87)
        updateSkipHint()
        if u74 then
            u74.Visible = false
        end
        v2 = u73
        local Gameplay = v2 and v2:FindFirstChild("Gameplay")
        v1 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
        local Notification = v1 and v1:FindFirstChild("Notification")
        if Notification then
            if not Notification:IsA("GuiObject") then
                return
            end
            local Position = u121 or Notification.Position
            u121 = Position
            Notification.Position = Position
        end
    end
end

function u157() -- Line: 957
    -- upvalues: LocalPlayer (val), u98 (ref), u102 (val), u89 (ref), u94 (ref), u95 (ref), u88 (ref), u91 (ref)
    -- upvalues: u96 (ref), u97 (ref), u156 (ref)
    local Attribute = LocalPlayer:GetAttribute("TutorialObjective")
    local Attribute_2 = LocalPlayer:GetAttribute("TutorialStep")
    if typeof(Attribute) == "string" and Attribute ~= "" and not u98 and not (#u102 > 0) and not u89 then
        u94 = Attribute
        u95 = if typeof(Attribute_2) ~= "string" then "" else Attribute_2
        u88 = false
        u91 = u91 + 1
        u96 = false
        u97 = u97 + 1
        u156(true)
        return
    end
end

local u171 = false
local u172 = nil

local function scheduleCommanderRetry() -- Line: 985
    -- upvalues: u171 (ref), LocalPlayer (val), u99 (ref), shouldShowDialogue (val), u172 (ref)
    if u171 then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderId")
    if typeof(Attribute) == "number" and Attribute ~= u99 then
        u171 = true
        task.spawn(function() -- Line: 995
            -- upvalues: LocalPlayer (upval), u99 (upval), shouldShowDialogue (upval), u171 (upval), u172 (upval)
            local Attribute
            local v1 = os.clock() + 30
            while os.clock() < v1 do
                task.wait(0.25)
                Attribute = LocalPlayer:GetAttribute("TutorialCommanderId")
                if typeof(Attribute) ~= "number" or Attribute == u99 then
                    break
                end
                if shouldShowDialogue() then
                    u171 = false
                    u172()
                    return
                end
            end
            u171 = false
        end)
        return
    end
end

function u172() -- Line: 1018
    -- upvalues: shouldShowDialogue (val), hideDialogue (val), scheduleCommanderRetry (val), LocalPlayer (val)
    -- upvalues: u99 (ref), u104 (ref), u98 (ref), u102 (val), u155 (ref)
    if not shouldShowDialogue() then
        hideDialogue()
        scheduleCommanderRetry()
        return
    end
    local Attribute = LocalPlayer:GetAttribute("TutorialCommander")
    local Attribute_2 = LocalPlayer:GetAttribute("TutorialCommanderId")
    local v1 = false
    if typeof(Attribute) == "string" then
        v1 = false
        if Attribute ~= "" then
            v1 = false
            if typeof(Attribute_2) == "number" then
                v1 = Attribute_2 ~= u99
            end
        end
    end
    if not v1 then
        local v2 = u104
        if v2 and not u98 then
            u104 = nil
            table.move(v2, 1, #v2, #u102 + 1, u102)
            task.spawn(u155)
        end
        return
    end
    u104 = nil
    u99 = Attribute_2
    table.clear(u102)
    for i, j in string.split(Attribute, "\n") do
        if j ~= "" then
            table.insert(u102, j)
        end
    end
    if not u98 then
        task.spawn(u155)
    end
end

local function syncCommanderVoice() -- Line: 1059
    -- upvalues: LocalPlayer (val), u101 (ref), shouldShowDialogue (val), u98 (ref), u102 (val), u106 (ref), u107 (ref)
    -- upvalues: resolveCommanderLine (val), showTip (val), u157 (ref), createVoiceSound (val)
    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderVoice")
    local Attribute_2 = LocalPlayer:GetAttribute("TutorialCommanderVoiceId")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        if typeof(Attribute_2) == "number" and Attribute_2 ~= u101 then
            local Attribute_4, bare, release, u125, v1, v2, v3, v4
            if not shouldShowDialogue() then
                return
            end
            u101 = Attribute_2
            local Attribute_3 = LocalPlayer:GetAttribute("TutorialCommanderVoiceStep")
            local v5 = LocalPlayer:GetAttribute("TutorialCommanderVoicePriority") == true
            if not u98 then
                v1 = #u102
                if not (v1 > 0) then
                    if typeof(Attribute_3) == "string"
                        and LocalPlayer:GetAttribute("TutorialStep") ~= Attribute_3 then
                        return
                    end
                    if not v5 and u106 and u107 then
                        return
                    end
                    v1, v2, v3 = resolveCommanderLine(Attribute)
                    if not v2 then
                        return
                    end
                    if v5 then
                        v4 = table.concat(v1, " ")
                        Attribute_4 = LocalPlayer:GetAttribute("TutorialObjective")

                        function bare(a1) -- Line: 1118 -- types: a1: string
                            return (string.gsub(string.lower(a1), "[^%w]", ""))
                        end

                        if typeof(Attribute_4) ~= "string" then
                            task.spawn(showTip, v4)
                        elseif (string.gsub(string.lower(Attribute_4), "[^%w]", "")) == string.gsub(string.lower(v4), "[^%w]", "") then
                            u157()
                        else
                            task.spawn(showTip, v4)
                        end
                    end
                    v4 = u106
                    u106 = nil
                    u107 = false
                    if v4 then
                        v4:Stop()
                        v4:Destroy()
                    end
                    u125 = createVoiceSound(v2, v3)
                    u125:Play()
                    u106 = u125
                    u107 = v5

                    function release() -- Line: 1142 -- upvalues: u106 (upval), u125 (val), u107 (upval)
                        if u106 == u125 then
                            u106 = nil
                            u107 = false
                            u125:Destroy()
                        end
                    end

                    u125.Ended:Once(release)
                    u125.Stopped:Once(release)
                    if v5 then
                        task.delay(15, function() -- Line: 1156 -- upvalues: u106 (upval), u125 (val), u107 (upval)
                            if u106 == u125 then
                                u107 = false
                            end
                        end)
                    end
                    return
                end
            end
            if not v5 then
                return
            end
            v1 = os.clock() + 30
            while true do
                if u98 then
                    if u101 == Attribute_2 and not (v1 <= os.clock()) then
                        task.wait(0.05)
                        continue
                    end
                    return
                end
                if not (#u102 > 0) then
                    break
                end
                if u101 == Attribute_2 and not (v1 <= os.clock()) then
                    task.wait(0.05)
                    continue
                end
                return
            end
            if not shouldShowDialogue() then
                return
            end
            if typeof(Attribute_3) == "string" and LocalPlayer:GetAttribute("TutorialStep") ~= Attribute_3 then
                return
            end
            if not v5 and u106 and u107 then
                return
            end
            v1, v2, v3 = resolveCommanderLine(Attribute)
            if not v2 then
                return
            end
            if v5 then
                v4 = table.concat(v1, " ")
                Attribute_4 = LocalPlayer:GetAttribute("TutorialObjective")

                function bare(a1) -- Line: 1118 -- types: a1: string
                    return (string.gsub(string.lower(a1), "[^%w]", ""))
                end

                if typeof(Attribute_4) ~= "string" then
                    task.spawn(showTip, v4)
                elseif (string.gsub(string.lower(Attribute_4), "[^%w]", "")) == string.gsub(string.lower(v4), "[^%w]", "") then
                    u157()
                else
                    task.spawn(showTip, v4)
                end
            end
            v4 = u106
            u106 = nil
            u107 = false
            if v4 then
                v4:Stop()
                v4:Destroy()
            end
            u125 = createVoiceSound(v2, v3)
            u125:Play()
            u106 = u125
            u107 = v5

            function release() -- Line: 1142 -- upvalues: u106 (upval), u125 (val), u107 (upval)
                if u106 == u125 then
                    u106 = nil
                    u107 = false
                    u125:Destroy()
                end
            end

            u125.Ended:Once(release)
            u125.Stopped:Once(release)
            if v5 then
                task.delay(15, function() -- Line: 1156 -- upvalues: u106 (upval), u125 (val), u107 (upval)
                    if u106 == u125 then
                        u107 = false
                    end
                end)
            end
            return
        end
        return
    end
end

local function syncDialogue() -- Line: 1168
    -- upvalues: IsTutorialMode (val), preloadVoices (val), u172 (ref), syncObjective (val), syncCommanderVoice (val)
    if IsTutorialMode() then
        preloadVoices()
    end
    u172()
    syncObjective()
    task.spawn(syncCommanderVoice)
end

function v1.Initialize(a1, a2) -- Line: 1179
    -- upvalues: u73 (ref), bindDialogue (val), u74 (ref), setMode (val), u76 (ref), u75 (ref)
    u73 = a1
    bindDialogue(a2)
    if u74 then
        u74.Visible = false
        setMode("Commander")
        u76 = "Hidden"
    end
    if u75 then
        u75.Text = ""
        u75.MaxVisibleGraphemes = 0
    end
    local Parent = u74 and u74.Parent and u74.Parent:FindFirstChild("TutorialObjective")
    if Parent then
        Parent:Destroy()
    end
end

function v1.Start() -- Line: 1198
    -- upvalues: bindDialogue (val), u74 (ref), u75 (ref), LocalPlayer (val), syncObjective (val), updateSkipHint (val)
    -- upvalues: u172 (ref), syncCommanderVoice (val), syncDialogue (val), IsTutorialMode (val), Router (val)
    -- upvalues: GameState (val), preloadVoices (val), u73 (ref), hideDialogue (val), u111 (val), u115 (val)
    -- upvalues: liftNotifications (val), u129 (ref), UserInputService (val)
    bindDialogue(u74)
    if u74 and u75 then
        (LocalPlayer:GetAttributeChangedSignal("TutorialObjective")):Connect(syncObjective)
        ;(LocalPlayer:GetAttributeChangedSignal("TutorialStep")):Connect(syncObjective)
        ;(LocalPlayer:GetAttributeChangedSignal("TutorialStep")):Connect(updateSkipHint)
        ;(LocalPlayer:GetAttributeChangedSignal("TutorialCommander")):Connect(u172)
        ;(LocalPlayer:GetAttributeChangedSignal("TutorialCommanderId")):Connect(u172)
        ;(LocalPlayer:GetAttributeChangedSignal("TutorialCommanderVoice")):Connect(syncCommanderVoice)
        ;(LocalPlayer:GetAttributeChangedSignal("TutorialCommanderVoiceId")):Connect(syncCommanderVoice)
        ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(syncDialogue)
        local Attribute = LocalPlayer:GetAttribute("Team")
        ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(function() -- Line: 1216 -- upvalues: LocalPlayer (upval), IsTutorialMode (upval), Attribute (ref), Router (upval)
            local Attribute_2 = LocalPlayer:GetAttribute("Team")
            if IsTutorialMode() and Attribute == "Terrorists" and Attribute_2 == "Counter-Terrorists" then
                Router.broadcastRouter(
                    "CreateNotification",
                    "Team Changed",
                    "You are now a Counter-Terrorist. The players in this room are your teammates",
                    6
                )
            end
            Attribute = Attribute_2
        end)
        ;(workspace:GetAttributeChangedSignal("ServerGamemode")):Connect(syncDialogue)
        ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(syncDialogue)
        ;(workspace:GetAttributeChangedSignal("TutorialActive")):Connect(syncDialogue)
        GameState.ListenToState(function() -- Line: 1226
            -- upvalues: IsTutorialMode (upval), preloadVoices (upval), u172 (upval), syncObjective (upval)
            -- upvalues: syncCommanderVoice (upval)
            if IsTutorialMode() then
                preloadVoices()
            end
            u172()
            syncObjective()
            task.spawn(syncCommanderVoice)
        end)
        local Menu = u73
        if Menu then
            Menu = u73:FindFirstChild("Menu")
        end
        if Menu and Menu:IsA("GuiObject") then
            (Menu:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 1232
                -- upvalues: Menu (val), hideDialogue (upval), IsTutorialMode (upval), preloadVoices (upval)
                -- upvalues: u172 (upval), syncObjective (upval), syncCommanderVoice (upval)
                if Menu.Visible then
                    hideDialogue()
                    return
                end
                if IsTutorialMode() then
                    preloadVoices()
                end
                u172()
                syncObjective()
                task.spawn(syncCommanderVoice)
            end)
        end
        local v1 = u73
        local Gameplay_2 = v1 and v1:FindFirstChild("Gameplay")
        local v2 = if not Gameplay_2 then nil else Gameplay_2:FindFirstChild("Middle")
        local BuyMenu = v2 and v2:FindFirstChild("BuyMenu")
        local v3 = if not BuyMenu then nil else if not BuyMenu:IsA("GuiObject") then nil else BuyMenu
        if v3 then
            (v3:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 1244 -- upvalues: u74 (upval), u73 (upval), u111 (upval), u115 (upval), liftNotifications (upval)
                if u74 and u74.Visible then
                    local v1 = u74
                    local v2 = u73
                    local Gameplay = v2 and v2:FindFirstChild("Gameplay")
                    local v3 = if not Gameplay then nil else Gameplay:FindFirstChild("Middle")
                    local BuyMenu = v3 and v3:FindFirstChild("BuyMenu")
                    local v4 = if not BuyMenu then nil else if not BuyMenu:IsA("GuiObject") then nil else BuyMenu
                    v1.Position = if not v4 then u111 else if not v4.Visible then u111 else u111 + u115
                    liftNotifications(true)
                end
            end)
        end
        local Gameplay = u73
        if Gameplay then
            Gameplay = u73:FindFirstChild("Gameplay")
        end
        if Gameplay and Gameplay:IsA("GuiObject") then
            (Gameplay:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 1254
                -- upvalues: Gameplay (val), hideDialogue (upval), IsTutorialMode (upval), preloadVoices (upval)
                -- upvalues: u172 (upval), syncObjective (upval), syncCommanderVoice (upval)
                if not Gameplay.Visible then
                    hideDialogue()
                    return
                end
                if IsTutorialMode() then
                    preloadVoices()
                end
                u172()
                syncObjective()
                task.spawn(syncCommanderVoice)
            end)
        end
        u74.InputBegan:Connect(function(a1) -- Line: 1264 -- upvalues: LocalPlayer (upval), u129 (upval)
            if a1.UserInputType ~= Enum.UserInputType.Touch
                or LocalPlayer:GetAttribute("TutorialStep") == "DefuseB" then
                return
            end
            u129()
        end)
        UserInputService.LastInputTypeChanged:Connect(updateSkipHint)
        ;(UserInputService:GetPropertyChangedSignal("PreferredInput")):Connect(updateSkipHint)
        if IsTutorialMode() then
            preloadVoices()
        end
        u172()
        syncObjective()
        task.spawn(syncCommanderVoice)
        return
    end
end

return v1