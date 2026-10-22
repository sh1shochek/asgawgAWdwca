-- ReplicatedStorage.GameClient.CharacterController.CharacterInput
-- Script path: ReplicatedStorage.GameClient.CharacterController.CharacterInput
-- Decompile time: 12.83 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local UserInputService = game:GetService("UserInputService");
local GameStats = game:GetService("ReplicatedStorage"):WaitForChild("GameStats");
local u2 = GameStats:GetAttribute("State") == "Preparation";
local u3 = workspace:GetAttribute("sv_cheats") == true;
GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 18
    -- upvalues: u2 (ref), GameStats (copy)
    u2 = GameStats:GetAttribute("State") == "Preparation";
end);
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = false;
local u11 = nil;
local u12 = 0;
local u13 = 0;
local u14 = false;
local u15 = -1;
local u16 = "Z";
local u17 = 0;
local u18 = 0;
local u19 = false;
local u20 = false;
local u21 = false;
local u22 = false;
local u23 = false;

local function PollControllerMove() -- Line: 53
    -- upvalues: u11 (ref), UserInputService (copy)
    if not (u11 and UserInputService:GetGamepadConnected(u11)) then
        return Vector2.zero;
    end;

    for _, v in UserInputService:GetGamepadState(u11) do
        if v.KeyCode == Enum.KeyCode.Thumbstick1 then
            local Vector2_new_ret = Vector2.new(v.Position.X, v.Position.Y);
            local Magnitude = Vector2_new_ret.Magnitude;

            return Magnitude > 0.2 and Vector2_new_ret.Unit * math.min((Magnitude - 0.2) / 0.8, 1) or Vector2.zero;
        end;
    end;

    return Vector2.zero;
end;

local function ReadMoveInput(p24, p25, p26) -- Line: 72
    -- upvalues: u10 (ref), u9 (ref), PollControllerMove (copy)
    if u10 then
        local MoveVector = u9.GetMoveVector();

        if p25 == 0 or not p25 then
            p25 = MoveVector.X;
        end;

        if p26 == 0 or not p26 then
            p26 = MoveVector.Z;
        end;

        return p25, p26;
    end;

    local v27 = PollControllerMove();

    if v27.Magnitude >= 0.01 then
        if p25 == 0 or not p25 then
            p25 = v27.X;
        end;

        if p26 == 0 or not p26 then
            p26 = -v27.Y;
        end;

        return p25, p26;
    end;

    local v28 = p24.Left + p24.Right;
    local v29 = p24.Forward + p24.Backward;

    if p25 ~= 0 and p25 then
        v28 = p25;
    end;

    if p26 ~= 0 and p26 then
        v29 = p26;
    end;

    return v28, v29;
end;

local function ProcessMovementInput(p30) -- Line: 91
    -- upvalues: u12 (ref), u13 (ref), u14 (ref), u16 (ref), u15 (ref), u5 (ref), u2 (ref), ReadMoveInput (copy)
    local v31 = u12;
    local v32 = u13;

    if u14 then
        if u16 == "X" then
            v31 = u15;
        else
            v32 = u15;
        end;
    end;

    if not u5.HasFramePriority() then
        local v33, v34 = ReadMoveInput(p30, v31, v32);
        p30.MoveX = v33;
        p30.MoveZ = v34;

        return;
    end;

    p30.PressE = false;

    if u5.IsOnlyFrame("Buymenu") and not u2 then
        local v35, v36 = ReadMoveInput(p30, v31, v32);
        p30.MoveX = v35;
        p30.MoveZ = v36;

        return;
    end;

    p30.Duck = false;
    p30.Walk = false;
    p30.Jump = false;
    p30.MoveX = v31;
    p30.MoveZ = v32;
end;

local function ReleaseJumpCrouch(p37) -- Line: 126
    -- upvalues: u20 (ref), u21 (ref), u23 (ref)
    u20 = false;
    u21 = false;
    p37.Duck = u23;
end;

local function ApplyJumpCrouchAssist(p38) -- Line: 132
    -- upvalues: u19 (ref), u20 (ref), u21 (ref), u23 (ref), u22 (ref)
    if not u19 then
        if u20 then
            u20 = false;
            u21 = false;
            p38.Duck = u23;
        end;

        u22 = p38.Jump;

        return;
    end;

    local Simulation = p38.Simulation;

    if not Simulation then
        return;
    end;

    local OnGround = Simulation.OnGround;

    if p38.Jump and (not u22 and OnGround) then
        u20 = true;
        u21 = false;
    end;

    u22 = p38.Jump;

    if not u20 then
        return;
    end;

    if not OnGround then
        u21 = true;
        p38.Duck = true;

        return;
    end;

    if not u21 then
        if not p38.Jump then
            u20 = false;
            u21 = false;
            p38.Duck = u23;
        end;

        return;
    end;

    u20 = false;
    u21 = false;
    p38.Duck = u23;
end;

local function CreateCommandTable(p39, p40, p41, p42, p43, p44) -- Line: 174
    local v45 = math.sqrt(p39.MoveX ^ 2 + p39.MoveZ ^ 2) * 0.3826834323650898;

    return {
        Inputs = {
            Forward = p39.MoveZ < -v45,
            Backward = v45 < p39.MoveZ,
            Left = p39.MoveX < -v45,
            Right = v45 < p39.MoveX
        },
        AdditionalInputs = {
            Duck = p39.Duck,
            Walk = p39.Walk,
            Jump = p39.Jump,
            PressE = p39.PressE,
            Ping = p39.Ping or false
        },
        Yaw = p40,
        Pitch = p41,
        ClientTick = p42,
        ServerTick = p39.ServerTick,
        RenderTime = p43,
        ReceivedMask = p44
    };
end;

function u1.GetControllerMove() -- Line: 211
    -- upvalues: PollControllerMove (copy)
    return PollControllerMove();
end;

function u1.UpdateLeft(p46: any, p47: number) -- Line: 215
    p46.Left = p47;
    p46.MoveX = p46.Left + p46.Right;
end;

function u1.UpdateRight(p48: any, p49: number) -- Line: 220
    p48.Right = p49;
    p48.MoveX = p48.Left + p48.Right;
end;

function u1.UpdateForward(p50: any, p51: number) -- Line: 225
    p50.Forward = p51;
    p50.MoveZ = p50.Forward + p50.Backward;
end;

function u1.UpdateBackward(p52: any, p53: number) -- Line: 230
    p52.Backward = p53;
    p52.MoveZ = p52.Forward + p52.Backward;
end;

function u1.UpdateAdditionalInput(p54: any, p55: string, p56: any) -- Line: 235
    -- upvalues: u23 (ref)
    p54[p55] = p56;

    if p55 == "Duck" then
        u23 = p56 and true or false;
    end;
end;

function u1.SetForcedMove(p57: string, p58: number) -- Line: 243
    -- upvalues: u3 (ref), u12 (ref), u13 (ref)
    if not u3 then
        return;
    end;

    local v59 = p57:upper();

    if v59 == "X" then
        u12 = p58;

        return;
    end;

    if v59 == "Z" then
        u13 = p58;
    end;
end;

function u1.GetForcedMove(p60: string) -- Line: 253
    -- upvalues: u12 (ref), u13 (ref)
    local v61 = p60:upper();

    if v61 == "X" then
        return u12;
    end;

    return v61 ~= "Z" and 0 or u13;
end;

function u1.ResetForcedMove() -- Line: 263
    -- upvalues: u12 (ref), u13 (ref), u14 (ref), u15 (ref), u17 (ref), u18 (ref)
    u12 = 0;
    u13 = 0;
    u14 = false;
    u15 = 0;
    u17 = 0;
    u18 = 0;
end;

local function RefreshCheats() -- Line: 272
    -- upvalues: u3 (ref), u1 (copy)
    u3 = workspace:GetAttribute("sv_cheats") == true;

    if not u3 then
        u1.ResetForcedMove();
    end;
end;

workspace:GetAttributeChangedSignal("sv_cheats"):Connect(RefreshCheats);

if workspace:GetAttribute("sv_cheats") == true then
    u3 = true;
else
    u3 = false;
end;

if not u3 then
    u1.ResetForcedMove();
end;

function u1.SetAutoWalk(p62: boolean, p63: number?, p64: string?) -- Line: 281
    -- upvalues: u3 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref)
    if p62 then
        p62 = u3;
    end;

    u14 = p62;

    if not p62 then
        u15 = 0;
        u17 = 0;
        u18 = 0;

        return;
    end;

    u15 = (p63 == 1 or p63 == -1) and p63 and p63 or -1;
    u16 = p64 and p64:upper() == "X" and "X" or "Z";
    u17 = 0;
    u18 = 0;
end;

function u1.GetAutoWalk() -- Line: 296
    -- upvalues: u14 (ref), u15 (ref), u16 (ref)
    return u14, u15, u16;
end;

function u1.ToggleAutoWalk(p65: number?, p66: string?) -- Line: 300
    -- upvalues: u14 (ref), u1 (copy)
    local v67 = not u14;
    u1.SetAutoWalk(v67, p65, p66);

    return v67;
end;

function u1.PostPhysicsStep(p68: any, p69: vector, p70: number) -- Line: 306
    -- upvalues: u14 (ref), u3 (ref), u18 (ref), u17 (ref), u15 (ref)
    if not (u14 and u3) then
        return;
    end;

    if u18 > 0 then
        u18 = u18 - 1;
    end;

    if p68 then
        p68 = p68.Simulation;
    end;

    if not p68 then
        return;
    end;

    local v71 = (p68.Position - p69) * Vector3.new(1, 0, 1);
    local vector_dot_ret = vector.dot(v71, v71);
    local vector_dot_ret2 = vector.dot(p68.Velocity * Vector3.new(1, 0, 1), p68.Velocity * Vector3.new(1, 0, 1));
    local v72;

    if vector_dot_ret < 0.0004 then
        v72 = true;
    elseif vector_dot_ret2 < 1 then
        v72 = vector_dot_ret < 0.001;
    else
        v72 = false;
    end;

    if v72 and p68.OnGround then
        u17 = u17 + 1;

        if u17 >= 3 and u18 <= 0 then
            u15 = -u15;
            u17 = 0;
            u18 = 15;
        end;
    else
        u17 = 0;
    end;
end;

function u1.BuildCommand(p73, p74) -- Line: 340
    -- upvalues: u4 (ref), ProcessMovementInput (copy), ApplyJumpCrouchAssist (copy), CreateCommandTable (copy), u7 (ref)
    local MapAngles, v75 = u4.GetMapAngles();
    ProcessMovementInput(p73);
    ApplyJumpCrouchAssist(p73);
    local v76 = CreateCommandTable(p73, MapAngles, v75, p74, u7.GetShotView());

    if p73.Ping then
        p73.Ping = false;
    end;

    return v76;
end;

function u1.Init(p77) -- Line: 356
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u10 (ref)
    u4 = p77:GetModule("CameraController");
    u5 = p77:GetModule("BindsController");
    u6 = p77:GetModule("GetUserPlatform");
    u7 = p77:GetModule("Entities");
    u8 = p77:GetModule("Gui");
    u10 = u6() == "Mobile";
end;

function u1.Start(p78) -- Line: 366
    -- upvalues: u9 (ref), u8 (ref), u19 (ref), UserInputService (copy), u11 (ref)
    u9 = u8.GetComponent("MobileControls");
    local Component = u8.GetComponent("Settings");

    if Component then
        local PlayerSettings = Component:GetPlayerSettings();
        local v79 = PlayerSettings and PlayerSettings.Game and PlayerSettings.Game.Gameplay;

        if v79 and v79["Jump Crouch Assist"] ~= nil then
            u19 = v79["Jump Crouch Assist"];
        end;

        Component:AddConnection("Game", "Gameplay", "Jump Crouch Assist", function(p80) -- Line: 377
            -- upvalues: u19 (ref)
            u19 = p80;
        end);
    end;

    UserInputService.InputChanged:Connect(function(p81: userdata) -- Line: 385
        -- upvalues: u11 (ref)
        if p81.KeyCode == Enum.KeyCode.Thumbstick1 then
            u11 = p81.UserInputType;
        end;
    end);
end;

return u1;