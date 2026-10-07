-- StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.CameraInput
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.CameraInput
-- Decompile time: 10.64 ms

local BindableEvent_4
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserCameraInputDt = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local LocalPlayer = Players.LocalPlayer
local Value = Enum.ContextActionPriority.Medium.Value
local u70 = Vector2.new(1, 0.77) * 0.06981317007977318
local u59 = Vector2.new(1, 0.77) * 0.008726646259971648
local u64 = Vector2.new(1, 0.77) * 0.12217304763960307
local u69 = Vector2.new(1, 0.66) * 0.017453292519943295
if UserCameraInputDt then
    u70 = u70 * 60
end
local success, result = pcall(function() -- Line: 41
    return UserSettings():IsUserFeatureEnabled("UserResetTouchStateOnMenuOpen")
end)
local u76 = success and result
local success_2, result_2 = pcall(function() -- Line: 49
    return UserSettings():IsUserFeatureEnabled("UserClearPanOnCameraDisable")
end)
local u82 = success_2 and result_2
local BindableEvent = Instance.new("BindableEvent")
local BindableEvent_2 = Instance.new("BindableEvent")
local Event = BindableEvent.Event
local Event_2 = BindableEvent_2.Event
UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 63 -- upvalues: BindableEvent (val)
    if not a2 and a1.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent:Fire()
    end
end)
UserInputService.InputEnded:Connect(function(a1, a2) -- Line: 69 -- upvalues: BindableEvent_2 (val)
    if a1.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent_2:Fire()
    end
end)

local function thumbstickCurve(a1) -- Line: 80
    local v1 = ((math.exp(((math.abs(a1)) - 0.1) / 0.9 * 2)) - 1) / 6.38905609893065
    return (math.sign(a1)) * math.clamp(v1, 0, 1)
end

local function adjustTouchPitchSensitivity(a1) -- Line: 94 -- types: a1: userdata
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return a1
    end
    local v1 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
    if 0 <= a1.Y * v1 then
        return a1
    end
    return Vector2.new(1, (1 - ((math.abs(v1)) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25) * a1
end

local function isInDynamicThumbstickArea(a1) -- Line: 120 -- upvalues: LocalPlayer (val) -- types: a1: vector
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local TouchGui = PlayerGui and PlayerGui:FindFirstChild("TouchGui")
    local TouchControlFrame = TouchGui and TouchGui:FindFirstChild("TouchControlFrame")
    local DynamicThumbstickFrame = TouchControlFrame and TouchControlFrame:FindFirstChild("DynamicThumbstickFrame")
    if not DynamicThumbstickFrame or not TouchGui.Enabled then
        return false
    end
    local AbsolutePosition = DynamicThumbstickFrame.AbsolutePosition
    local v1 = AbsolutePosition + DynamicThumbstickFrame.AbsoluteSize
    local v2 = false
    if AbsolutePosition.X <= a1.X then
        v2 = false
        if AbsolutePosition.Y <= a1.Y then
            v2 = false
            if a1.X <= v1.X then
                v2 = a1.Y <= v1.Y
            end
        end
    end
    return v2
end

local u109 = 0.016666666666666666
RunService.Stepped:Connect(function(a1, a2) -- Line: 145 -- upvalues: u109 (ref)
    u109 = a2
end)
local v1 = {}
local u117 = {}
local u118 = 0

local function incPanInputCount() -- Line: 155 -- upvalues: u118 (ref)
    u118 = math.max(0, u118 + 1)
end

local function decPanInputCount() -- Line: 159 -- upvalues: u118 (ref)
    u118 = math.max(0, u118 - 1)
end

local function resetPanInputCount() -- Line: 163 -- upvalues: u118 (ref)
    u118 = 0
end

local u122 = 1
local u123 = 1
local u124 = {}
u124.Thumbstick2 = Vector2.new()
local u127 = {Left = 0, Right = 0, I = 0, O = 0}
local u128 = {Wheel = 0, Pinch = 0}
u128.Movement = Vector2.new()
u128.Pan = Vector2.new()
local u133 = {Pinch = 0}
u133.Move = Vector2.new()
local BindableEvent_3 = Instance.new("BindableEvent")
v1.gamepadZoomPress = BindableEvent_3.Event
if not VRService.VREnabled then
    BindableEvent_4 = nil
else
    BindableEvent_4 = Instance.new("BindableEvent")
    if not BindableEvent_4 then
        BindableEvent_4 = nil
    end
end
if VRService.VREnabled then
    v1.gamepadReset = BindableEvent_4.Event
end

function v1.getRotationActivated() -- Line: 210 -- upvalues: u118 (ref), u124 (val)
    local v1 = true
    if not (u118 > 0) then
        v1 = 0 < u124.Thumbstick2.Magnitude
    end
    return v1
end

function v1.addTouchMove(a1) -- Line: 214 -- upvalues: u133 (val) -- types: a1: userdata
    local v1 = u133
    v1.Move = v1.Move + a1
end

function v1.setTouchSensitivity(a1) -- Line: 219 -- upvalues: u122 (ref) -- types: a1: number
    u122 = math.clamp(a1 or 1, 0.1, 10)
end

function v1.setGamepadAssistMultiplier(a1) -- Line: 224 -- upvalues: u123 (ref) -- types: a1: number
    u123 = math.clamp(a1 or 1, 0, 1)
end

function v1.getRotation(a1, a2) -- Line: 228
    -- upvalues: UserGameSettings (val), UserCameraInputDt (val), u127 (val), u109 (ref), u124 (val), u123 (ref)
    -- upvalues: u128 (val), adjustTouchPitchSensitivity (val), u133 (val), u70 (ref), u59 (val), u64 (val), u69 (val)
    -- upvalues: u122 (ref)
    local v1 = Vector2.new(1, UserGameSettings:GetCameraYInvertValue())
    local v2 = if not UserCameraInputDt then (Vector2.new(u127.Right - u127.Left, 0)) * u109 else Vector2.new(u127.Right - u127.Left, 0) * a1
    local v3 = u124.Thumbstick2 * UserGameSettings.GamepadCameraSensitivity * u123
    if UserCameraInputDt then
        v3 = v3 * a1
    end
    local Movement = u128.Movement
    local Pan = u128.Pan
    local v4 = adjustTouchPitchSensitivity(u133.Move)
    if a2 then
        v2 = Vector2.new()
    end
    return (v2 * 2.0943951023931953 + v3 * u70 + Movement * u59 + Pan * u64 + v4 * u69 * u122) * v1
end

function v1.getZoomDelta() -- Line: 281 -- upvalues: u127 (val), u128 (val), u133 (val)
    local v1 = u127.O - u127.I
    local v2 = -u128.Wheel + u128.Pinch
    local v3 = -u133.Pinch
    return v1 * 0.1 + v2 * 1 + v3 * 0.04
end

local function thumbstick(a1, a2, a3) -- Line: 289 -- upvalues: u124 (val), thumbstickCurve (ref)
    local Position = a3.Position
    u124[a3.KeyCode.Name] = (Vector2.new(thumbstickCurve(Position.X), -thumbstickCurve(Position.Y)))
    return Enum.ContextActionResult.Pass
end

local function mouseMovement(a1) -- Line: 295 -- upvalues: u128 (val)
    local Delta = a1.Delta
    u128.Movement = Vector2.new(Delta.X, Delta.Y)
end

local function mouseWheel(a1, a2, a3) -- Line: 300 -- upvalues: u128 (val)
    u128.Wheel = a3.Position.Z
    return Enum.ContextActionResult.Pass
end

local function keypress(a1, a2, a3) -- Line: 305 -- upvalues: u127 (val)
    local Name = a3.KeyCode.Name
    u127[Name] = if a2 ~= Enum.UserInputState.Begin then 0 else 1
end

local function gamepadZoomPress(a1, a2, a3) -- Line: 309 -- upvalues: BindableEvent_3 (val)
    if a2 == Enum.UserInputState.Begin then
        BindableEvent_3:Fire()
    end
end

local function gamepadReset(a1, a2, a3) -- Line: 315 -- upvalues: BindableEvent_4 (val)
    if a2 == Enum.UserInputState.Begin then
        BindableEvent_4:Fire()
    end
end

local function resetInputDevices() -- Line: 321
    -- upvalues: u124 (val), u127 (val), u128 (val), u133 (val), u82 (ref), u118 (ref)
    for k, v in pairs({u124, u127, u128, u133}) do
        for k2, i in pairs(v) do
            if type(i) ~= "boolean" then
                v[k2] = v[k2] * 0
            else
                v[k2] = false
            end
        end
    end
    if u82 then
        u118 = 0
    end
end

local u232 = {}
local u233 = nil
local u234 = nil

local function touchBegan(a1, a2) -- Line: 349
    -- upvalues: u233 (ref), isInDynamicThumbstickArea (val), u118 (ref), u232 (ref)
    assert(a1.UserInputType == Enum.UserInputType.Touch)
    assert(a1.UserInputState == Enum.UserInputState.Begin)
    if u233 == nil and isInDynamicThumbstickArea(a1.Position) and not a2 then
        u233 = a1
        return
    end
    if not a2 then
        u118 = math.max(0, u118 + 1)
    end
    u232[a1] = a2
end

local function touchEnded(a1, a2) -- Line: 369
    -- upvalues: u233 (ref), u232 (ref), u234 (ref), u118 (ref)
    assert(a1.UserInputType == Enum.UserInputType.Touch)
    assert(a1.UserInputState == Enum.UserInputState.End)
    if a1 == u233 then
        u233 = nil
    end
    if u232[a1] == false then
        u234 = nil
        u118 = math.max(0, u118 - 1)
    end
    u232[a1] = nil
end

local function touchChanged(a1, a2) -- Line: 388 -- upvalues: u233 (ref), u232 (ref), u133 (val), u234 (ref)
    local v1
    assert(a1.UserInputType == Enum.UserInputType.Touch)
    assert(a1.UserInputState == Enum.UserInputState.Change)
    if a1 == u233 then
        return
    end
    if u232[a1] == nil then
        u232[a1] = a2
    end
    local v2 = {}
    for k, v in pairs(u232) do
        if not v then
            table.insert(v2, k)
        end
    end
    if #v2 == 1 and u232[a1] == false then
        local Delta = a1.Delta
        v1 = u133
        v1.Move = v1.Move + Vector2.new(Delta.X, Delta.Y)
    end
    if #v2 ~= 2 then
        u234 = nil
        return
    end
    local Magnitude = (v2[1].Position - v2[2].Position).Magnitude
    if u234 then
        v1 = u133
        v1.Pinch = v1.Pinch + (Magnitude - u234)
    end
    u234 = Magnitude
end

local function resetTouchState() -- Line: 432 -- upvalues: u232 (ref), u233 (ref), u234 (ref), u76 (ref), u118 (ref)
    u232 = {}
    u233 = nil
    u234 = nil
    if u76 then
        u118 = 0
    end
end

local function pointerAction(a1, a2, a3, a4) -- Line: 442 -- upvalues: u128 (val)
    if not a4 then
        u128.Wheel = a1
        u128.Pan = a2
        u128.Pinch = -a3
    end
end

local function inputBegan(a1, a2) -- Line: 450 -- upvalues: touchBegan (ref), u118 (ref)
    if a1.UserInputType == Enum.UserInputType.Touch then
        touchBegan(a1, a2)
        return
    end
    if a1.UserInputType == Enum.UserInputType.MouseButton2 and not a2 then
        u118 = math.max(0, u118 + 1)
    end
end

local function inputChanged(a1, a2) -- Line: 459 -- upvalues: touchChanged (ref), u128 (val)
    if a1.UserInputType == Enum.UserInputType.Touch then
        touchChanged(a1, a2)
        return
    end
    if a1.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = a1.Delta
        u128.Movement = Vector2.new(Delta.X, Delta.Y)
    end
end

local function inputEnded(a1, a2) -- Line: 468 -- upvalues: touchEnded (ref), u118 (ref)
    if a1.UserInputType == Enum.UserInputType.Touch then
        touchEnded(a1, a2)
        return
    end
    if a1.UserInputType == Enum.UserInputType.MouseButton2 then
        u118 = math.max(0, u118 - 1)
    end
end

local u249 = false

function v1.setInputEnabled(a1) -- Line: 479
    -- upvalues: u249 (ref), resetInputDevices (val), resetTouchState (ref), ContextActionService (val)
    -- upvalues: thumbstick (val), Value (val), keypress (val), VRService (val), gamepadReset (val)
    -- upvalues: gamepadZoomPress (val), u117 (ref), UserInputService (val), inputBegan (val), inputChanged (val)
    -- upvalues: inputEnded (val), pointerAction (val), u76 (ref)
    if u249 == a1 then
        return
    end
    resetInputDevices()
    resetTouchState()
    if not a1 then
        ContextActionService:UnbindAction("RbxCameraThumbstick")
        ContextActionService:UnbindAction("RbxCameraMouseMove")
        ContextActionService:UnbindAction("RbxCameraMouseWheel")
        ContextActionService:UnbindAction("RbxCameraKeypress")
        ContextActionService:UnbindAction("RbxCameraGamepadZoom")
        if VRService.VREnabled then
            ContextActionService:UnbindAction("RbxCameraGamepadReset")
        end
        for k, v in pairs(u117) do
            v:Disconnect()
        end
        u117 = {}
        return
    end
    ContextActionService:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, Value, Enum.KeyCode.Thumbstick2)
    ContextActionService:BindActionAtPriority("RbxCameraKeypress", keypress, false, Value, Enum.KeyCode.I)
    if VRService.VREnabled then
        ContextActionService:BindAction("RbxCameraGamepadReset", gamepadReset, false, Enum.KeyCode.ButtonL3)
    end
    ContextActionService:BindAction("RbxCameraGamepadZoom", gamepadZoomPress, false, Enum.KeyCode.ButtonR3)
    table.insert(u117, (UserInputService.InputBegan:Connect(inputBegan)))
    table.insert(u117, (UserInputService.InputChanged:Connect(inputChanged)))
    table.insert(u117, (UserInputService.InputEnded:Connect(inputEnded)))
    table.insert(u117, (UserInputService.PointerAction:Connect(pointerAction)))
    if not u76 then
        return
    end
    local GuiService = game:GetService("GuiService")
    table.insert(u117, (GuiService.MenuOpened:connect(resetTouchState)))
end

function v1.getInputEnabled() -- Line: 551 -- upvalues: u249 (ref)
    return u249
end

function v1.resetInputForFrameEnd() -- Line: 555 -- upvalues: u128 (val), u133 (val)
    u128.Movement = Vector2.new()
    u133.Move = Vector2.new()
    u133.Pinch = 0
    u128.Wheel = 0
    u128.Pan = Vector2.new()
    u128.Pinch = 0
end

UserInputService.WindowFocused:Connect(resetInputDevices)
UserInputService.WindowFocusReleased:Connect(resetInputDevices)
local u278 = false
local u279 = false
local u280 = 0

function v1.getHoldPan() -- Line: 576 -- upvalues: u278 (ref)
    return u278
end

function v1.getTogglePan() -- Line: 580 -- upvalues: u279 (ref)
    return u279
end

function v1.getPanning() -- Line: 584 -- upvalues: u279 (ref), u278 (ref)
    return u279 or u278
end

function v1.setTogglePan(a1) -- Line: 588 -- upvalues: u279 (ref) -- types: a1: boolean
    u279 = a1
end

local u285 = false
local u286 = nil
local u287 = nil

function v1.enableCameraToggleInput() -- Line: 596
    -- upvalues: u285 (ref), u278 (ref), u279 (ref), u286 (ref), u287 (ref), Event (ref), u280 (ref), Event_2 (ref)
    -- upvalues: UserInputService (val)
    if u285 then
        return
    end
    u285 = true
    u278 = false
    u279 = false
    if u286 then
        u286:Disconnect()
    end
    if u287 then
        u287:Disconnect()
    end
    u286 = Event:Connect(function() -- Line: 613 -- upvalues: u278 (upval), u280 (upval)
        u278 = true
        u280 = tick()
    end)
    u287 = Event_2:Connect(function() -- Line: 618 -- upvalues: u278 (upval), u280 (upval), u279 (upval), UserInputService (upval)
        u278 = false
        if tick() - u280 < 0.3 then
            if u279 or UserInputService:GetMouseDelta().Magnitude < 2 then
                u279 = not u279
            end
        end
    end)
end

function v1.disableCameraToggleInput() -- Line: 626 -- upvalues: u285 (ref), u286 (ref), u287 (ref)
    if not u285 then
        return
    end
    u285 = false
    if u286 then
        u286:Disconnect()
        u286 = nil
    end
    if u287 then
        u287:Disconnect()
        u287 = nil
    end
end

return v1