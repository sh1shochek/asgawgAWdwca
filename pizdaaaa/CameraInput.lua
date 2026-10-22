-- ReplicatedStorage.GameClient.CameraController.CameraInput
-- Script path: ReplicatedStorage.GameClient.CameraController.CameraInput
-- Decompile time: 12.34 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local RunService = game:GetService("RunService");
local GameSettings = UserSettings().GameSettings;
local u2 = false;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local MouseSensitivity = GameSettings.MouseSensitivity;
local u9 = 1;
local u10 = 1;
local u11 = 0.7;
local u12 = false;
local u13 = false;
local Vector2_zero = Vector2.zero;
local u14 = 0;
local u15 = 0;
local u16 = 0;
local u17 = 0;
local u18 = nil;
local u19 = nil;

local function IsWeaponZoomed(p20) -- Line: 47
    if not p20 then
        return false;
    end;

    if p20.ZoomLevel and p20.ZoomLevel > 0 then
        return true;
    end;

    local v21 = p20.Data and p20.Data.AltFunction;

    return v21 and (v21.Name == "ScopeRifle" and p20.Mode == 2) and true or false;
end;

local function ApplyTouchLook(p22) -- Line: 67
    -- upvalues: u10 (ref), u9 (ref), u8 (ref), u3 (ref), u11 (ref), u14 (ref), u15 (ref)
    local v23 = u10 * 0.017453292519943295 * u9;

    if u8 then
        u8.ReportLook(p22.Magnitude * v23);
        v23 = v23 * u8.GetFrictionMultiplier();
    end;

    local v24 = u3 and u3.GetCurrentWeapon();
    local v25;

    if v24 then
        if v24.ZoomLevel and v24.ZoomLevel > 0 then
            v25 = true;
        else
            local v26 = v24.Data and v24.Data.AltFunction;
            v25 = v26 and (v26.Name == "ScopeRifle" and v24.Mode == 2) and true or false;
        end;
    else
        v25 = false;
    end;

    if v25 then
        v23 = v23 * u11;
    end;

    u14 = u14 - p22.X * v23;

    if u14 < -3.141592653589793 then
        u14 = u14 + 6.283185307179586;
    elseif u14 > 3.141592653589793 then
        u14 = u14 - 6.283185307179586;
    end;

    local v27 = p22.Y * u15 >= 0 and 1 or (1 - (math.abs(u15) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25;
    u15 = math.clamp(u15 + p22.Y * 0.66 * v27 * v23, -1.55334, 1.55334);
end;

function v1.GetAngles() -- Line: 98
    -- upvalues: u14 (ref), u15 (ref)
    return u14, u15;
end;

function v1.SetAngles(p28: number, p29: number) -- Line: 102
    -- upvalues: u14 (ref), u15 (ref)
    u14 = p28;
    u15 = p29;
end;

function v1.GetMapAngles() -- Line: 107
    -- upvalues: u14 (ref), u18 (ref), u15 (ref), u19 (ref), u16 (ref), u17 (ref)
    if u14 ~= u18 or u15 ~= u19 then
        local math_map_ret = math.map(u14, -3.141592653589793, 3.141592653589793, 0, 65535);
        u16 = math.floor(math_map_ret);
        local math_map_ret2 = math.map(u15, -1.55334, 1.55334, 0, 65535);
        u17 = math.floor(math_map_ret2);
        u18 = u14;
        u19 = u15;
    end;

    return u16, u17;
end;

function v1.SetSensitivityFieldOfViewMultiplier(p30: number) -- Line: 117
    -- upvalues: u9 (ref)
    u9 = p30;
end;

function v1.ApplyAimAssist(p31: number, p32: number) -- Line: 123
    -- upvalues: u14 (ref), u15 (ref)
    if p31 ~= 0 then
        u14 = u14 + p31;

        if u14 < -3.141592653589793 then
            u14 = u14 + 6.283185307179586;
        elseif u14 > 3.141592653589793 then
            u14 = u14 - 6.283185307179586;
        end;
    end;

    if p32 ~= 0 then
        u15 = math.clamp(u15 + p32, -1.55334, 1.55334);
    end;
end;

function v1.AddTouchDelta(p33) -- Line: 138
    -- upvalues: ApplyTouchLook (copy)
    ApplyTouchLook(p33);
end;

function v1.Init(p34) -- Line: 144
    -- upvalues: u6 (ref), u2 (ref), u3 (ref), u7 (ref), u4 (ref), u8 (ref)
    u6 = p34:GetModule("CameraController");
    u2 = p34:GetModule("GetUserPlatform")() == "Mobile";
    u3 = p34:GetModule("WeaponController");
    u7 = p34:GetModule("BindsController");
    u4 = p34:GetModule("Gui");
    u8 = p34:GetModule("MobileAimAssist");
end;

function v1.Start(p35) -- Line: 158
    -- upvalues: GameSettings (copy), MouseSensitivity (ref), ContextActionService (copy), u3 (ref), u11 (ref), u12 (ref), u10 (ref), u9 (ref), u14 (ref), u15 (ref), u13 (ref), Vector2_zero (ref), RunService (copy), u7 (ref), u8 (ref), u2 (ref), UserInputService (copy), ApplyTouchLook (copy), u5 (ref), u4 (ref)
    GameSettings:GetPropertyChangedSignal("MouseSensitivity"):Connect(function() -- Line: 159
        -- upvalues: MouseSensitivity (ref), GameSettings (ref)
        MouseSensitivity = GameSettings.MouseSensitivity;
    end);
    ContextActionService:BindAction("MouseMovement", function(p36: any, p37: any, p38: userdata) -- Line: 163
        -- upvalues: u3 (ref), u11 (ref), u12 (ref), MouseSensitivity (ref), u10 (ref), u9 (ref), u14 (ref), u15 (ref), u13 (ref)
        local Delta = p38.Delta;
        local CurrentWeapon = u3.GetCurrentWeapon();
        local v39;

        if CurrentWeapon then
            if CurrentWeapon.ZoomLevel and CurrentWeapon.ZoomLevel > 0 then
                v39 = true;
            else
                local v40 = CurrentWeapon.Data and CurrentWeapon.Data.AltFunction;
                v39 = v40 and (v40.Name == "ScopeRifle" and CurrentWeapon.Mode == 2) and true or false;
            end;
        else
            v39 = false;
        end;

        if v39 then
            Delta = Delta * u11;
        end;

        if u12 then
            local v41 = 0.022 / MouseSensitivity * u10 * u9;
            u14 = u14 - math.rad(Delta.X * v41);
            local math_rad_ret = math.rad(Delta.Y * v41);
            u15 = math.clamp(u15 + math_rad_ret * (u13 and -1 or 1), -1.55334, 1.55334);
        else
            local v42 = u9 * u10;
            u14 = u14 - Delta.X * 0.00872664619 * v42;
            u15 = math.clamp(u15 + Delta.Y * 0.00671951752 * v42 * (u13 and -1 or 1), -1.55334, 1.55334);
        end;

        if u14 < -3.141592653589793 then
            u14 = u14 + 6.283185307179586;

            return;
        end;

        if u14 > 3.141592653589793 then
            u14 = u14 - 6.283185307179586;
        end;
    end, false, Enum.UserInputType.MouseMovement);
    ContextActionService:BindAction("ControllerCamera", function(p43: any, p44: any, p45: userdata) -- Line: 192
        -- upvalues: Vector2_zero (ref)
        Vector2_zero = (p44 == Enum.UserInputState.End or p44 == Enum.UserInputState.Cancel) and Vector2.zero or Vector2.new(p45.Position.X, p45.Position.Y);

        return Enum.ContextActionResult.Pass;
    end, false, Enum.KeyCode.Thumbstick2);
    RunService.RenderStepped:Connect(function(p46) -- Line: 198
        -- upvalues: Vector2_zero (ref), u7 (ref), u10 (ref), u9 (ref), u8 (ref), u3 (ref), u11 (ref), u14 (ref), u15 (ref), u13 (ref)
        if Vector2_zero.Magnitude < 0.15 or u7.HasFramePriority() then
            return;
        end;

        local v47 = u10 * u9;

        if u8 then
            u8.ReportLook(Vector2_zero.Magnitude * 3.141592653589793 * v47 * p46);
            v47 = v47 * u8.GetFrictionMultiplier();
        end;

        local CurrentWeapon = u3.GetCurrentWeapon();
        local v48;

        if CurrentWeapon then
            if CurrentWeapon.ZoomLevel and CurrentWeapon.ZoomLevel > 0 then
                v48 = true;
            else
                local v49 = CurrentWeapon.Data and CurrentWeapon.Data.AltFunction;
                v48 = v49 and (v49.Name == "ScopeRifle" and CurrentWeapon.Mode == 2) and true or false;
            end;
        else
            v48 = false;
        end;

        if v48 then
            v47 = v47 * u11;
        end;

        u14 = u14 - Vector2_zero.X * 3.141592653589793 * v47 * p46;
        u15 = math.clamp(u15 + Vector2_zero.Y * 2.443460952792061 * v47 * (u13 and 1 or -1) * p46, -1.55334, 1.55334);

        if u14 < -3.141592653589793 then
            u14 = u14 + 6.283185307179586;

            return;
        end;

        if u14 > 3.141592653589793 then
            u14 = u14 - 6.283185307179586;
        end;
    end);

    if u2 then
        local Touch = Enum.UserInputType.Touch;
        local u50 = {};
        local u51 = 0;
        UserInputService.InputBegan:Connect(function(p52: userdata, p53: boolean) -- Line: 230
            -- upvalues: Touch (copy), u50 (copy), u51 (ref)
            if p52.UserInputType == Touch then
                u50[p52] = p53;

                if not p53 then
                    u51 = math.max(0, u51) + 1;
                end;
            end;
        end);
        UserInputService.InputEnded:Connect(function(p54: userdata) -- Line: 239
            -- upvalues: Touch (copy), u50 (copy), u51 (ref)
            if p54.UserInputType == Touch then
                if u50[p54] == false then
                    u51 = math.max(0, u51 - 1);
                end;

                u50[p54] = nil;
            end;
        end);
        UserInputService.InputChanged:Connect(function(p55: userdata, p56: boolean) -- Line: 248
            -- upvalues: Touch (copy), u50 (copy), u51 (ref), ApplyTouchLook (ref)
            if p55.UserInputType ~= Touch then
                return;
            end;

            if u50[p55] == nil then
                u50[p55] = p56;

                if not p56 then
                    u51 = math.max(0, u51) + 1;
                end;
            end;

            if u51 < 1 or u50[p55] ~= false then
                return;
            end;

            ApplyTouchLook(p55.Delta);
        end);
    end;

    u5 = u4.GetComponent("Settings");
    (function() -- Line: 270, Name: ApplyPlayerSettings
        -- upvalues: u5 (ref), u11 (ref), u10 (ref), u12 (ref), u13 (ref)
        local v57 = u5 and u5:GetPlayerSettings();

        if v57 then
            v57 = v57.Controls;
        end;

        if v57 then
            local Sensitivity = v57.Sensitivity;

            if Sensitivity then
                if Sensitivity["Zoom Sensitivity"] ~= nil then
                    u11 = Sensitivity["Zoom Sensitivity"];
                end;

                if Sensitivity.Sensitivity ~= nil then
                    u10 = Sensitivity.Sensitivity;
                end;

                if Sensitivity["CS Sensitivity Enabled"] ~= nil then
                    u12 = Sensitivity["CS Sensitivity Enabled"];
                end;
            end;

            local Keybinds = v57.Keybinds;

            if Keybinds and Keybinds["Reverse Mouse"] ~= nil then
                u13 = Keybinds["Reverse Mouse"];
            end;
        end;
    end)();
    u5:AddConnection("Controls", "Sensitivity", "Sensitivity", function(p58) -- Line: 295
        -- upvalues: u10 (ref)
        u10 = p58;
    end);
    u5:AddConnection("Controls", "Sensitivity", "Zoom Sensitivity", function(p59) -- Line: 298
        -- upvalues: u11 (ref)
        u11 = p59;
    end);
    u5:AddConnection("Controls", "Sensitivity", "CS Sensitivity Enabled", function(p60) -- Line: 301
        -- upvalues: u12 (ref)
        u12 = p60;
    end);
    u5:AddConnection("Controls", "Keybinds", "Reverse Mouse", function(p61) -- Line: 304
        -- upvalues: u13 (ref)
        u13 = p61;
    end);
end;

return v1;