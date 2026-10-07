-- Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick
-- Decompile time: 9.92 ms

local Value = Enum.ContextActionPriority.High.Value
local u2 = {0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75}
local u10 = #u2
local u15 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local success, result = pcall(function() -- Line: 37
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2")
end)
local u51 = success and result
local success_2, result_2 = pcall(function() -- Line: 44
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local u57 = success_2 and result_2
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local u78 = setmetatable({}, BaseCharacterController)
u78.__index = u78

function u78.new() -- Line: 61 -- upvalues: BaseCharacterController (val), u78 (val)
    local v1 = BaseCharacterController.new()
    local v2 = setmetatable(v1, u78)
    v2.moveTouchObject = nil
    v2.moveTouchLockedIn = false
    v2.moveTouchFirstChanged = false
    v2.moveTouchStartPosition = nil
    v2.startImage = nil
    v2.endImage = nil
    v2.middleImages = {}
    v2.startImageFadeTween = nil
    v2.endImageFadeTween = nil
    v2.middleImageFadeTweens = {}
    v2.isFirstTouch = true
    v2.thumbstickFrame = nil
    v2.onRenderSteppedConn = nil
    v2.fadeInAndOutBalance = 0.5
    v2.fadeInAndOutHalfDuration = 0.3
    v2.hasFadedBackgroundInPortrait = false
    v2.hasFadedBackgroundInLandscape = false
    v2.tweenInAlphaStart = nil
    v2.tweenOutAlphaStart = nil
    return v2
end

function u78.GetIsJumping(a1) -- Line: 96
    local isJumping = a1.isJumping
    a1.isJumping = false
    return isJumping
end

function u78.Enable(a1, a2, a3) -- Line: 102
    -- upvalues: u51 (ref), ContextActionService (val)
    if a2 == nil then
        return false
    end
    local v1 = not not a2
    if a1.enabled == v1 then
        return true
    end
    if not v1 then
        if not u51 then
            ContextActionService:UnbindAction("DynamicThumbstickAction")
        else
            a1:UnbindContextActions()
        end
        a1:OnInputEnded()
    else
        if not a1.thumbstickFrame then
            a1:Create(a3)
        end
        a1:BindContextActions()
    end
    a1.enabled = v1
    a1.thumbstickFrame.Visible = v1
    return nil
end

function u78:OnInputEnded() -- Line: 131
    self.moveTouchObject = nil
    self.moveVector = Vector3.new(0, 0, 0)
    self:FadeThumbstick(false)
end

function u78:FadeThumbstick(a2) -- Line: 137
    -- upvalues: TweenService (val), u15 (val), u2 (val)
    local middleImageFadeTweens, v1, v2, v3, v4, v5
    if not a2 and self.moveTouchObject then
        return
    end
    if self.isFirstTouch then
        return
    end
    if self.startImageFadeTween then
        self.startImageFadeTween:Cancel()
    end
    if self.endImageFadeTween then
        self.endImageFadeTween:Cancel()
    end
    local v6 = #self.middleImages
    local v7 = self
    for i = 1, v6 do
        if v7.middleImageFadeTweens[i] then
            v7.middleImageFadeTweens[i]:Cancel()
        end
    end
    if not v1 then
        local middleImageFadeTweens_2
        v7.startImageFadeTween = TweenService:Create(v7.startImage, u15, {ImageTransparency = 1})
        v7.startImageFadeTween:Play()
        v7.endImageFadeTween = TweenService:Create(v7.endImage, u15, {ImageTransparency = 1})
        v7.endImageFadeTween:Play()
        v6 = #v7.middleImages
        for j = 1, v6 do
            middleImageFadeTweens_2 = v7.middleImageFadeTweens
            v3 = TweenService
            v4 = v7.middleImages[j]
            middleImageFadeTweens_2[j] = (v3:Create(v4, u15, {ImageTransparency = 1}))
            v7.middleImageFadeTweens[j]:Play()
        end
        return
    end
    v7.startImageFadeTween = TweenService:Create(v7.startImage, u15, {ImageTransparency = 0})
    v7.startImageFadeTween:Play()
    v7.endImageFadeTween = TweenService:Create(v7.endImage, u15, {ImageTransparency = 0.2})
    v7.endImageFadeTween:Play()
    v6 = #v7.middleImages
    for k = 1, v6 do
        middleImageFadeTweens = v7.middleImageFadeTweens
        v3 = TweenService
        v4 = v7.middleImages[k]
        v5 = u15
        v2 = {ImageTransparency = u2[k]}
        middleImageFadeTweens[k] = (v3:Create(v4, v5, v2))
        v7.middleImageFadeTweens[k]:Play()
    end
end

function u78.FadeThumbstickFrame(a1, a2, a3) -- Line: 180 -- types: a1: table, a2: number, a3: number
    a1.fadeInAndOutHalfDuration = a2 * 0.5
    a1.fadeInAndOutBalance = a3
    a1.tweenInAlphaStart = tick()
end

function u78:InputInFrame(a2) -- Line: 186 -- types: self: table, a2: userdata
    local AbsolutePosition = self.thumbstickFrame.AbsolutePosition
    local v1 = AbsolutePosition + self.thumbstickFrame.AbsoluteSize
    local Position = a2.Position
    if AbsolutePosition.X <= Position.X
        and AbsolutePosition.Y <= Position.Y
        and Position.X <= v1.X
        and Position.Y <= v1.Y then
        return true
    end
    return false
end

function u78:DoFadeInBackground() -- Line: 198 -- upvalues: LocalPlayer (ref)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local hasFadedBackgroundInPortrait = false
    if PlayerGui then
        if PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft
            or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            hasFadedBackgroundInPortrait = self.hasFadedBackgroundInLandscape
            self.hasFadedBackgroundInLandscape = true
        elseif PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            hasFadedBackgroundInPortrait = self.hasFadedBackgroundInPortrait
            self.hasFadedBackgroundInPortrait = true
        end
    end
    if not hasFadedBackgroundInPortrait then
        self.fadeInAndOutHalfDuration = 0.3
        self.fadeInAndOutBalance = 0.5
        self.tweenInAlphaStart = tick()
    end
end

function u78:DoMove(a2) -- Line: 221 -- types: self: table, a2: vector
    local v1 = a2
    if not (v1.Magnitude < self.radiusOfDeadZone) then
        v1 = v1.Unit * (1 - math.max(0, (self.radiusOfMaxSpeed - v1.Magnitude) / self.radiusOfMaxSpeed))
        v1 = Vector3.new(v1.X, 0, v1.Y)
    else
        v1 = Vector3.new(0, 0, 0)
    end
    self.moveVector = v1
end

function u78:LayoutMiddleImages(a2, a3) -- Line: 239
    -- upvalues: u10 (val)
    local v1, v2, v3, v4, v5
    local v6 = self.thumbstickSize / 2 + self.middleSize
    local v7 = a3 - a2
    local v8 = v7.Magnitude - self.thumbstickRingSize / 2 - self.middleSize
    local Unit = v7.Unit
    local v9 = self.middleSpacing * u10
    local middleSpacing = self.middleSpacing
    if v9 < v8 then
        middleSpacing = v8 / u10
    end
    local v10, v11 = self, a3
    for i = 1, u10 do
        v1 = v10.middleImages[i]
        v2 = v6 + middleSpacing * (i - 2)
        v3 = v6 + middleSpacing * (i - 1)
        if not (v2 < v8) then
            v1.Visible = false
        else
            v4 = v11 - Unit * v3
            v5 = math.clamp(1 - (v3 - v8) / middleSpacing, 0, 1)
            v1.Visible = true
            v1.Position = UDim2.new(0, v4.X, 0, v4.Y)
            v1.Size = UDim2.new(0, v10.middleSize * v5, 0, v10.middleSize * v5)
        end
    end
end

function u78:MoveStick(a2) -- Line: 270
    local v1 = (Vector2.new(self.moveTouchStartPosition.X, self.moveTouchStartPosition.Y)) - self.thumbstickFrame.AbsolutePosition
    local v2 = (Vector2.new(a2.X, a2.Y)) - self.thumbstickFrame.AbsolutePosition
    self.endImage.Position = UDim2.new(0, v2.X, 0, v2.Y)
    self:LayoutMiddleImages(v1, v2)
end

function u78:BindContextActions() -- Line: 278
    -- upvalues: TweenService (val), u51 (ref), ContextActionService (val), Value (val), UserInputService (val)
    local function inputBegan(a1) -- Line: 279 -- upvalues: self (val), TweenService (upval)
        if self.moveTouchObject or not self:InputInFrame(a1) then
            return Enum.ContextActionResult.Pass
        end
        if self.isFirstTouch then
            self.isFirstTouch = false
            local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
            TweenService:Create(self.startImage, v1, {Size = UDim2.new(0, 0, 0, 0)}):Play()
            TweenService:Create(self.endImage, v1, {
                Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize),
                ImageColor3 = Color3.new(0, 0, 0),
            }):Play()
        end
        self.moveTouchLockedIn = false
        self.moveTouchObject = a1
        self.moveTouchStartPosition = a1.Position
        self.moveTouchFirstChanged = true
        self:DoFadeInBackground()
        return Enum.ContextActionResult.Pass
    end

    local function inputChanged(a1) -- Line: 311 -- upvalues: self (val) -- types: a1: userdata
        local v1
        if a1 ~= self.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end
        if self.moveTouchFirstChanged then
            self.moveTouchFirstChanged = false
            v1 = Vector2.new(a1.Position.X - self.thumbstickFrame.AbsolutePosition.X, a1.Position.Y - self.thumbstickFrame.AbsolutePosition.Y)
            self.startImage.Visible = true
            self.startImage.Position = UDim2.new(0, v1.X, 0, v1.Y)
            self.endImage.Visible = true
            self.endImage.Position = self.startImage.Position
            self:FadeThumbstick(true)
            self:MoveStick(a1.Position)
        end
        self.moveTouchLockedIn = true
        v1 = Vector2.new(a1.Position.X - self.moveTouchStartPosition.X, a1.Position.Y - self.moveTouchStartPosition.Y)
        if 0 < (math.abs(v1.X)) or 0 < (math.abs(v1.Y)) then
            self:DoMove(v1)
            self:MoveStick(a1.Position)
        end
        return Enum.ContextActionResult.Sink
    end

    local function inputEnded(a1) -- Line: 344 -- upvalues: self (val)
        if a1 == self.moveTouchObject then
            self:OnInputEnded()
            if self.moveTouchLockedIn then
                return Enum.ContextActionResult.Sink
            end
        end
        return Enum.ContextActionResult.Pass
    end

    local v1 = ContextActionService
    local v2 = Value
    local Touch = Enum.UserInputType.Touch
    v1:BindActionAtPriority("DynamicThumbstickAction", function(a1, a2, a3) -- Line: 354 -- upvalues: inputBegan (val), u51 (upval), self (val), inputChanged (val)
        if a2 == Enum.UserInputState.Begin then
            return (inputBegan(a3))
        end
        if a2 == Enum.UserInputState.Change then
            if not u51 then
                return (inputChanged(a3))
            end
            if a3 == self.moveTouchObject then
                return Enum.ContextActionResult.Sink
            end
            return Enum.ContextActionResult.Pass
        end
        if a2 ~= Enum.UserInputState.End then
            if a2 == Enum.UserInputState.Cancel then
                self:OnInputEnded()
            end
            return
        end
        if a3 == self.moveTouchObject then
            self:OnInputEnded()
            if self.moveTouchLockedIn then
                return Enum.ContextActionResult.Sink
            end
        end
        return Enum.ContextActionResult.Pass
    end, false, v2, Touch)
    if u51 then
        self.TouchMovedCon = UserInputService.TouchMoved:Connect(function(a1, a2) -- Line: 382 -- upvalues: inputChanged (val) -- types: a1: userdata, a2: boolean
            inputChanged(a1)
        end)
    end
end

function u78:UnbindContextActions() -- Line: 388 -- upvalues: ContextActionService (val)
    ContextActionService:UnbindAction("DynamicThumbstickAction")
    if self.TouchMovedCon then
        self.TouchMovedCon:Disconnect()
    end
end

function u78:Create(a2) -- Line: 396
    -- upvalues: u57 (ref), u10 (val), u2 (val), RunService (val), UserInputService (val), GuiService (val)
    -- upvalues: LocalPlayer (ref)
    local v1
    if self.thumbstickFrame then
        self.thumbstickFrame:Destroy()
        self.thumbstickFrame = nil
        if self.onRenderSteppedConn then
            self.onRenderSteppedConn:Disconnect()
            self.onRenderSteppedConn = nil
        end
        if self.absoluteSizeChangedConn then
            self.absoluteSizeChangedConn:Disconnect()
            self.absoluteSizeChangedConn = nil
        end
    end
    local u23 = if not u57 then 0 else 100

    local function layoutThumbstickFrame(a1) -- Line: 411 -- upvalues: self (val), u23 (val) -- types: a1: boolean
        if a1 then
            self.thumbstickFrame.Size = UDim2.new(1, u23, 0.4, u23)
            self.thumbstickFrame.Position = UDim2.new(0, -u23, 0.6, 0)
            return
        end
        self.thumbstickFrame.Size = UDim2.new(0.4, u23, 0.6666666666666666, u23)
        self.thumbstickFrame.Position = UDim2.new(0, -u23, 0.3333333333333333, 0)
    end

    self.thumbstickFrame = Instance.new("Frame")
    self.thumbstickFrame.BorderSizePixel = 0
    self.thumbstickFrame.Name = "DynamicThumbstickFrame"
    self.thumbstickFrame.Visible = false
    self.thumbstickFrame.BackgroundTransparency = 1
    self.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.thumbstickFrame.Active = false
    self.thumbstickFrame.Size = UDim2.new(0.4, u23, 0.6666666666666666, u23)
    self.thumbstickFrame.Position = UDim2.new(0, -u23, 0.3333333333333333, 0)
    self.startImage = Instance.new("ImageLabel")
    self.startImage.Name = "ThumbstickStart"
    self.startImage.Visible = true
    self.startImage.BackgroundTransparency = 1
    self.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    self.startImage.ImageRectOffset = Vector2.new(1, 1)
    self.startImage.ImageRectSize = Vector2.new(144, 144)
    self.startImage.ImageColor3 = Color3.new(0, 0, 0)
    self.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
    self.startImage.ZIndex = 10
    self.startImage.Parent = self.thumbstickFrame
    self.endImage = Instance.new("ImageLabel")
    self.endImage.Name = "ThumbstickEnd"
    self.endImage.Visible = true
    self.endImage.BackgroundTransparency = 1
    self.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    self.endImage.ImageRectOffset = Vector2.new(1, 1)
    self.endImage.ImageRectSize = Vector2.new(144, 144)
    self.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
    self.endImage.ZIndex = 10
    self.endImage.Parent = self.thumbstickFrame
    for i = 1, u10 do
        self.middleImages[i] = (Instance.new("ImageLabel"))
        v1 = self.middleImages[i]
        v1.Name = "ThumbstickMiddle"
        v1 = self.middleImages[i]
        v1.Visible = false
        v1 = self.middleImages[i]
        v1.BackgroundTransparency = 1
        v1 = self.middleImages[i]
        v1.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        v1 = self.middleImages[i]
        v1.ImageRectOffset = Vector2.new(1, 1)
        v1 = self.middleImages[i]
        v1.ImageRectSize = Vector2.new(144, 144)
        v1 = self.middleImages[i]
        v1.ImageTransparency = u2[i]
        v1 = self.middleImages[i]
        v1.AnchorPoint = Vector2.new(0.5, 0.5)
        v1 = self.middleImages[i]
        v1.ZIndex = 9
        v1 = self.middleImages[i]
        v1.Parent = self.thumbstickFrame
    end

    local function ResizeThumbstick() -- Line: 467 -- upvalues: a2 (val), self (val), u23 (val)
        local AbsoluteSize = a2.AbsoluteSize
        if not (500 < (math.min(AbsoluteSize.X, AbsoluteSize.Y))) then
            self.thumbstickSize = 45
            self.thumbstickRingSize = 20
            self.middleSize = 10
            self.middleSpacing = 14
            self.radiusOfDeadZone = 2
            self.radiusOfMaxSpeed = 20
        else
            self.thumbstickSize = 90
            self.thumbstickRingSize = 40
            self.middleSize = 20
            self.middleSpacing = 28
            self.radiusOfDeadZone = 4
            self.radiusOfMaxSpeed = 40
        end
        self.startImage.Position = UDim2.new(0, self.thumbstickRingSize * 3.3 + u23, 1, -self.thumbstickRingSize * 2.8 - u23)
        self.startImage.Size = UDim2.new(0, self.thumbstickRingSize * 3.7, 0, self.thumbstickRingSize * 3.7)
        self.endImage.Position = self.startImage.Position
        self.endImage.Size = UDim2.new(0, self.thumbstickSize * 0.8, 0, self.thumbstickSize * 0.8)
    end

    ResizeThumbstick()
    self.absoluteSizeChangedConn = (a2:GetPropertyChangedSignal("AbsoluteSize")):Connect(ResizeThumbstick)
    local u201 = nil

    local function onCurrentCameraChanged() -- Line: 505 -- upvalues: u201 (ref), layoutThumbstickFrame (val)
        if u201 then
            u201:Disconnect()
            u201 = nil
        end
        local CurrentCamera = workspace.CurrentCamera
        if CurrentCamera then
            u201 = (CurrentCamera:GetPropertyChangedSignal("ViewportSize")):Connect(function() -- Line: 512 -- upvalues: CurrentCamera (val), layoutThumbstickFrame (upval)
                local ViewportSize = CurrentCamera.ViewportSize
                local v1 = ViewportSize.X < ViewportSize.Y
                layoutThumbstickFrame(v1)
            end)
            local ViewportSize = CurrentCamera.ViewportSize
            local v1 = ViewportSize.X < ViewportSize.Y
            layoutThumbstickFrame(v1)
        end
    end

    ;(workspace:GetPropertyChangedSignal("CurrentCamera")):Connect(onCurrentCameraChanged)
    if workspace.CurrentCamera then
        onCurrentCameraChanged()
    end
    self.moveTouchStartPosition = nil
    self.startImageFadeTween = nil
    self.endImageFadeTween = nil
    self.middleImageFadeTweens = {}
    self.onRenderSteppedConn = RunService.RenderStepped:Connect(function() -- Line: 532 -- upvalues: self (val)
        local v1, v2
        if self.tweenInAlphaStart == nil then
            if self.tweenOutAlphaStart ~= nil then
                v1 = tick() - self.tweenOutAlphaStart
                v2 = self.fadeInAndOutHalfDuration * 2 - self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance
                self.thumbstickFrame.BackgroundTransparency = math.min(v1 / v2, 1) * 0.35 + 0.65
                if v2 < v1 then
                    self.tweenOutAlphaStart = nil
                end
            end
            return
        end
        v1 = tick() - self.tweenInAlphaStart
        v2 = self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance
        self.thumbstickFrame.BackgroundTransparency = 1 - math.min(v1 / v2, 1) * 0.35
        if not (v2 < v1) then
            return
        end
        self.tweenOutAlphaStart = tick()
        self.tweenInAlphaStart = nil
    end)
    self.onTouchEndedConn = UserInputService.TouchEnded:connect(function(a1) -- Line: 551 -- upvalues: self (val) -- types: a1: userdata
        if a1 == self.moveTouchObject then
            self:OnInputEnded()
        end
    end)
    GuiService.MenuOpened:connect(function() -- Line: 557 -- upvalues: self (val)
        if self.moveTouchObject then
            self:OnInputEnded()
        end
    end)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    while not PlayerGui do
        LocalPlayer.ChildAdded:wait()
        PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    end
    local u258 = nil
    local u265 = true
    if PlayerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.LandscapeLeft then
        u265 = PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
    end

    local function longShowBackground() -- Line: 573 -- upvalues: self (val)
        self.fadeInAndOutHalfDuration = 2.5
        self.fadeInAndOutBalance = 0.05
        self.tweenInAlphaStart = tick()
    end

    local v2 = (PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation")):Connect(function() -- Line: 579 -- upvalues: u265 (val), PlayerGui (ref), u258 (ref), self (val)
        if u265 and PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            u258:disconnect()
            self.fadeInAndOutHalfDuration = 2.5
            self.fadeInAndOutBalance = 0.05
            self.tweenInAlphaStart = tick()
            if u265 then
                self.hasFadedBackgroundInPortrait = true
                return
            end
            self.hasFadedBackgroundInLandscape = true
            return
        end
        if not u265 and PlayerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait then
            u258:disconnect()
            self.fadeInAndOutHalfDuration = 2.5
            self.fadeInAndOutBalance = 0.05
            self.tweenInAlphaStart = tick()
            if u265 then
                self.hasFadedBackgroundInPortrait = true
                return
            end
            self.hasFadedBackgroundInLandscape = true
        end
    end)
    self.thumbstickFrame.Parent = a2
    if not game:IsLoaded() then
        coroutine.wrap(function() -- Line: 599 -- upvalues: self (val)
            game.Loaded:Wait()
            self.fadeInAndOutHalfDuration = 2.5
            self.fadeInAndOutBalance = 0.05
            self.tweenInAlphaStart = tick()
        end)()
    else
        self.fadeInAndOutHalfDuration = 2.5
        self.fadeInAndOutBalance = 0.05
        self.tweenInAlphaStart = tick()
    end
end

return u78