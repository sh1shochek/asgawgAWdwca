-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local VRService = game:GetService("VRService");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local UserFlag = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt");
local LocalPlayer = Players.LocalPlayer;
local Value = Enum.ContextActionPriority.Medium.Value;
local u1 = Vector2.new(1, 0.77) * 0.06981317007977318;
local u2 = Vector2.new(1, 0.77) * 0.008726646259971648;
local u3 = Vector2.new(1, 0.77) * 0.12217304763960307;
local u4 = Vector2.new(1, 0.66) * 0.017453292519943295;

if UserFlag then
    u1 = u1 * 60;
end;

local success, result = pcall(function() -- Line: 41
    return UserSettings():IsUserFeatureEnabled("UserResetTouchStateOnMenuOpen");
end);
local u5 = success and result;
local success2, result2 = pcall(function() -- Line: 49
    return UserSettings():IsUserFeatureEnabled("UserClearPanOnCameraDisable");
end);
local u6 = success2 and result2;
local BindableEvent = Instance.new("BindableEvent");
local BindableEvent2 = Instance.new("BindableEvent");
local Event = BindableEvent.Event;
local Event2 = BindableEvent2.Event;
UserInputService.InputBegan:Connect(function(p7, p8) -- Line: 63
    -- upvalues: BindableEvent (copy)
    if not p8 and p7.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent:Fire();
    end;
end);
UserInputService.InputEnded:Connect(function(p9, p10) -- Line: 69
    -- upvalues: BindableEvent2 (copy)
    if p9.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent2:Fire();
    end;
end);

local function thumbstickCurve(p11) -- Line: 80
    local v12 = (math.abs(p11) - 0.1) / 0.9 * 2;
    local v13 = (math.exp(v12) - 1) / 6.38905609893065;

    return math.sign(p11) * math.clamp(v13, 0, 1);
end;

local function adjustTouchPitchSensitivity(p14) -- Line: 94
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return p14;
    end;

    local v15 = workspace_CurrentCamera.CFrame:ToEulerAnglesYXZ();

    if p14.Y * v15 >= 0 then
        return p14;
    end;

    local v16 = (1 - (math.abs(v15) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25;

    return Vector2.new(1, v16) * p14;
end;

local function isInDynamicThumbstickArea(p17: vector) -- Line: 120
    -- upvalues: LocalPlayer (copy)
    local v18 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v18 then
        v18 = v18:FindFirstChild("TouchGui");
    end;

    local v19;

    if v18 then
        v19 = v18:FindFirstChild("TouchControlFrame");
    else
        v19 = v18;
    end;

    if v19 then
        v19 = v19:FindFirstChild("DynamicThumbstickFrame");
    end;

    if not v19 then
        return false;
    end;

    if not v18.Enabled then
        return false;
    end;

    local AbsolutePosition = v19.AbsolutePosition;
    local v20 = AbsolutePosition + v19.AbsoluteSize;
    local v21;

    if p17.X >= AbsolutePosition.X and (p17.Y >= AbsolutePosition.Y and p17.X <= v20.X) then
        v21 = p17.Y <= v20.Y;
    else
        v21 = false;
    end;

    return v21;
end;

local u22 = 0.016666666666666666;
RunService.Stepped:Connect(function(p23, p24) -- Line: 145
    -- upvalues: u22 (ref)
    u22 = p24;
end);
local v25 = {};
local u26 = {};
local u27 = 0;

local function incPanInputCount() -- Line: 155
    -- upvalues: u27 (ref)
    u27 = math.max(0, u27 + 1);
end;

local function decPanInputCount() -- Line: 159
    -- upvalues: u27 (ref)
    u27 = math.max(0, u27 - 1);
end;

local function resetPanInputCount() -- Line: 163
    -- upvalues: u27 (ref)
    u27 = 0;
end;

local u28 = 1;
local u29 = 1;
local u30 = {
    Thumbstick2 = Vector2.new()
};
local u31 = {
    Left = 0,
    Right = 0,
    I = 0,
    O = 0
};
local u32 = {
    Wheel = 0,
    Pinch = 0,
    Movement = Vector2.new(),
    Pan = Vector2.new()
};
local u33 = {
    Pinch = 0,
    Move = Vector2.new()
};
local BindableEvent3 = Instance.new("BindableEvent");
v25.gamepadZoomPress = BindableEvent3.Event;
local u34 = VRService.VREnabled and Instance.new("BindableEvent") or nil;

if VRService.VREnabled then
    v25.gamepadReset = u34.Event;
end;

function v25.getRotationActivated() -- Line: 210
    -- upvalues: u27 (ref), u30 (copy)
    return u27 > 0 and true or u30.Thumbstick2.Magnitude > 0;
end;

function v25.addTouchMove(p35) -- Line: 214
    -- upvalues: u33 (copy)
    local v36 = u33;
    v36.Move = v36.Move + p35;
end;

function v25.setTouchSensitivity(p37: number) -- Line: 219
    -- upvalues: u28 (ref)
    u28 = math.clamp(p37 or 1, 0.1, 10);
end;

function v25.setGamepadAssistMultiplier(p38: number) -- Line: 224
    -- upvalues: u29 (ref)
    u29 = math.clamp(p38 or 1, 0, 1);
end;

function v25.getRotation(p39: any, p40: boolean?) -- Line: 228
    -- upvalues: UserGameSettings (copy), UserFlag (copy), u31 (copy), u22 (ref), u30 (copy), u29 (ref), u32 (copy), adjustTouchPitchSensitivity (copy), u33 (copy), u1 (ref), u2 (copy), u3 (copy), u4 (copy), u28 (ref)
    local Vector2_new_ret = Vector2.new(1, UserGameSettings:GetCameraYInvertValue());
    local v41;

    if UserFlag then
        v41 = Vector2.new(u31.Right - u31.Left, 0) * p39;
    else
        v41 = Vector2.new(u31.Right - u31.Left, 0) * u22;
    end;

    local v42 = u30.Thumbstick2 * UserGameSettings.GamepadCameraSensitivity * u29;

    if UserFlag then
        v42 = v42 * p39;
    end;

    local Movement = u32.Movement;
    local Pan = u32.Pan;
    local v43 = adjustTouchPitchSensitivity(u33.Move);

    if p40 then
        v41 = Vector2.new();
    end;

    return (v41 * 2.0943951023931953 + v42 * u1 + Movement * u2 + Pan * u3 + v43 * u4 * u28) * Vector2_new_ret;
end;

function v25.getZoomDelta() -- Line: 281
    -- upvalues: u31 (copy), u32 (copy), u33 (copy)
    return (u31.O - u31.I) * 0.1 + (-u32.Wheel + u32.Pinch) * 1 + -u33.Pinch * 0.04;
end;

local function thumbstick(p44, p45, p46) -- Line: 289
    -- upvalues: u30 (copy), thumbstickCurve (ref)
    local Position = p46.Position;
    u30[p46.KeyCode.Name] = Vector2.new(thumbstickCurve(Position.X), -thumbstickCurve(Position.Y));

    return Enum.ContextActionResult.Pass;
end;

local function mouseMovement(p47) -- Line: 295
    -- upvalues: u32 (copy)
    local Delta = p47.Delta;
    u32.Movement = Vector2.new(Delta.X, Delta.Y);
end;

local function mouseWheel(p48, p49, p50) -- Line: 300
    -- upvalues: u32 (copy)
    u32.Wheel = p50.Position.Z;

    return Enum.ContextActionResult.Pass;
end;

local function keypress(p51, p52, p53) -- Line: 305
    -- upvalues: u31 (copy)
    u31[p53.KeyCode.Name] = p52 == Enum.UserInputState.Begin and 1 or 0;
end;

local function gamepadZoomPress(p54, p55, p56) -- Line: 309
    -- upvalues: BindableEvent3 (copy)
    if p55 == Enum.UserInputState.Begin then
        BindableEvent3:Fire();
    end;
end;

local function gamepadReset(p57, p58, p59) -- Line: 315
    -- upvalues: u34 (copy)
    if p58 == Enum.UserInputState.Begin then
        u34:Fire();
    end;
end;

local function resetInputDevices() -- Line: 321
    -- upvalues: u30 (copy), u31 (copy), u32 (copy), u33 (copy), u6 (ref), u27 (ref)
    for _, v in pairs({
        u30,
        u31,
        u32,
        u33
    }) do
        local v60 = v;

        for i, v2 in pairs(v) do
            if type(v2) == "boolean" then
                v60[i] = false;
            else
                v60[i] = v60[i] * 0;
            end;
        end;
    end;

    if u6 then
        u27 = 0;
    end;
end;

local u61 = {};
local u62 = nil;
local u63 = nil;

local function touchBegan(p64: userdata, p65: boolean) -- Line: 349
    -- upvalues: u62 (ref), isInDynamicThumbstickArea (copy), u27 (ref), u61 (ref)
    assert(p64.UserInputType == Enum.UserInputType.Touch);
    assert(p64.UserInputState == Enum.UserInputState.Begin);

    if u62 == nil and (isInDynamicThumbstickArea(p64.Position) and not p65) then
        u62 = p64;

        return;
    end;

    if not p65 then
        u27 = math.max(0, u27 + 1);
    end;

    u61[p64] = p65;
end;

local function touchEnded(p66: userdata, p67: boolean) -- Line: 369
    -- upvalues: u62 (ref), u61 (ref), u63 (ref), u27 (ref)
    assert(p66.UserInputType == Enum.UserInputType.Touch);
    assert(p66.UserInputState == Enum.UserInputState.End);

    if p66 == u62 then
        u62 = nil;
    end;

    if u61[p66] == false then
        u63 = nil;
        u27 = math.max(0, u27 - 1);
    end;

    u61[p66] = nil;
end;

local function touchChanged(p68, p69) -- Line: 388
    -- upvalues: u62 (ref), u61 (ref), u33 (copy), u63 (ref)
    assert(p68.UserInputType == Enum.UserInputType.Touch);
    assert(p68.UserInputState == Enum.UserInputState.Change);

    if p68 == u62 then
        return;
    end;

    if u61[p68] == nil then
        u61[p68] = p69;
    end;

    local v70 = {};

    for i, v in pairs(u61) do
        if not v then
            table.insert(v70, i);
        end;
    end;

    if #v70 == 1 and u61[p68] == false then
        local Delta = p68.Delta;
        local v71 = u33;
        v71.Move = v71.Move + Vector2.new(Delta.X, Delta.Y);
    end;

    if #v70 ~= 2 then
        u63 = nil;

        return;
    end;

    local Magnitude = (v70[1].Position - v70[2].Position).Magnitude;

    if u63 then
        local v72 = u33;
        v72.Pinch = v72.Pinch + (Magnitude - u63);
    end;

    u63 = Magnitude;
end;

local function resetTouchState() -- Line: 432
    -- upvalues: u61 (ref), u62 (ref), u63 (ref), u5 (ref), u27 (ref)
    u61 = {};
    u62 = nil;
    u63 = nil;

    if u5 then
        u27 = 0;
    end;
end;

local function pointerAction(p73, p74, p75, p76) -- Line: 442
    -- upvalues: u32 (copy)
    if not p76 then
        u32.Wheel = p73;
        u32.Pan = p74;
        u32.Pinch = -p75;
    end;
end;

local function inputBegan(p77, p78) -- Line: 450
    -- upvalues: touchBegan (ref), u27 (ref)
    if p77.UserInputType == Enum.UserInputType.Touch then
        touchBegan(p77, p78);

        return;
    end;

    if p77.UserInputType == Enum.UserInputType.MouseButton2 and not p78 then
        u27 = math.max(0, u27 + 1);
    end;
end;

local function inputChanged(p79, p80) -- Line: 459
    -- upvalues: touchChanged (ref), u32 (copy)
    if p79.UserInputType == Enum.UserInputType.Touch then
        touchChanged(p79, p80);

        return;
    end;

    if p79.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = p79.Delta;
        u32.Movement = Vector2.new(Delta.X, Delta.Y);
    end;
end;

local function inputEnded(p81, p82) -- Line: 468
    -- upvalues: touchEnded (ref), u27 (ref)
    if p81.UserInputType == Enum.UserInputType.Touch then
        touchEnded(p81, p82);

        return;
    end;

    if p81.UserInputType == Enum.UserInputType.MouseButton2 then
        u27 = math.max(0, u27 - 1);
    end;
end;

local u83 = false;

function v25.setInputEnabled(p84) -- Line: 479
    -- upvalues: u83 (ref), resetInputDevices (copy), resetTouchState (ref), ContextActionService (copy), thumbstick (copy), Value (copy), keypress (copy), VRService (copy), gamepadReset (copy), gamepadZoomPress (copy), u26 (ref), UserInputService (copy), inputBegan (copy), inputChanged (copy), inputEnded (copy), pointerAction (copy), u5 (ref)
    if u83 == p84 then
        return;
    end;

    u83 = p84;
    resetInputDevices();
    resetTouchState();

    if u83 then
        ContextActionService:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, Value, Enum.KeyCode.Thumbstick2);
        ContextActionService:BindActionAtPriority("RbxCameraKeypress", keypress, false, Value, Enum.KeyCode.I);

        if VRService.VREnabled then
            ContextActionService:BindAction("RbxCameraGamepadReset", gamepadReset, false, Enum.KeyCode.ButtonL3);
        end;

        ContextActionService:BindAction("RbxCameraGamepadZoom", gamepadZoomPress, false, Enum.KeyCode.ButtonR3);
        table.insert(u26, UserInputService.InputBegan:Connect(inputBegan));
        table.insert(u26, UserInputService.InputChanged:Connect(inputChanged));
        table.insert(u26, UserInputService.InputEnded:Connect(inputEnded));
        table.insert(u26, UserInputService.PointerAction:Connect(pointerAction));

        if u5 then
            local MenuOpened = game:GetService("GuiService").MenuOpened;
            table.insert(u26, MenuOpened:connect(resetTouchState));
        end;
    else
        ContextActionService:UnbindAction("RbxCameraThumbstick");
        ContextActionService:UnbindAction("RbxCameraMouseMove");
        ContextActionService:UnbindAction("RbxCameraMouseWheel");
        ContextActionService:UnbindAction("RbxCameraKeypress");
        ContextActionService:UnbindAction("RbxCameraGamepadZoom");

        if VRService.VREnabled then
            ContextActionService:UnbindAction("RbxCameraGamepadReset");
        end;

        for _, v in pairs(u26) do
            v:Disconnect();
        end;

        u26 = {};
    end;
end;

function v25.getInputEnabled() -- Line: 551
    -- upvalues: u83 (ref)
    return u83;
end;

function v25.resetInputForFrameEnd() -- Line: 555
    -- upvalues: u32 (copy), u33 (copy)
    u32.Movement = Vector2.new();
    u33.Move = Vector2.new();
    u33.Pinch = 0;
    u32.Wheel = 0;
    u32.Pan = Vector2.new();
    u32.Pinch = 0;
end;

UserInputService.WindowFocused:Connect(resetInputDevices);
UserInputService.WindowFocusReleased:Connect(resetInputDevices);
local u85 = false;
local u86 = false;
local u87 = 0;

function v25.getHoldPan() -- Line: 576
    -- upvalues: u85 (ref)
    return u85;
end;

function v25.getTogglePan() -- Line: 580
    -- upvalues: u86 (ref)
    return u86;
end;

function v25.getPanning() -- Line: 584
    -- upvalues: u86 (ref), u85 (ref)
    return u86 or u85;
end;

function v25.setTogglePan(p88: boolean) -- Line: 588
    -- upvalues: u86 (ref)
    u86 = p88;
end;

local u89 = false;
local u90 = nil;
local u91 = nil;

function v25.enableCameraToggleInput() -- Line: 596
    -- upvalues: u89 (ref), u85 (ref), u86 (ref), u90 (ref), u91 (ref), Event (ref), u87 (ref), Event2 (ref), UserInputService (copy)
    if u89 then
        return;
    end;

    u89 = true;
    u85 = false;
    u86 = false;

    if u90 then
        u90:Disconnect();
    end;

    if u91 then
        u91:Disconnect();
    end;

    u90 = Event:Connect(function() -- Line: 613
        -- upvalues: u85 (ref), u87 (ref)
        u85 = true;
        u87 = tick();
    end);
    u91 = Event2:Connect(function() -- Line: 618
        -- upvalues: u85 (ref), u87 (ref), u86 (ref), UserInputService (ref)
        u85 = false;

        if tick() - u87 < 0.3 and (u86 or UserInputService:GetMouseDelta().Magnitude < 2) then
            u86 = not u86;
        end;
    end);
end;

function v25.disableCameraToggleInput() -- Line: 626
    -- upvalues: u89 (ref), u90 (ref), u91 (ref)
    if not u89 then
        return;
    end;

    u89 = false;

    if u90 then
        u90:Disconnect();
        u90 = nil;
    end;

    if u91 then
        u91:Disconnect();
        u91 = nil;
    end;
end;

return v25;