-- ReplicatedStorage.GameClient.BindsController.CharacterBinds
-- Script path: ReplicatedStorage.GameClient.BindsController.CharacterBinds
-- Decompile time: 6.19 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = "Hold";
local u11 = "Hold";
local u12 = "Hold";
local u13 = "Hold";
local u14 = "Toggle";
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = false;
local u20 = false;
local u21 = false;
local u51 = {
    ["Character Forward"] = {
        Callback = function(p22, p23) -- Line: 29, Name: Callback
            -- upvalues: u6 (ref)
            if not u6 then
                return;
            end;

            u6:UpdateForward(p23 == Enum.UserInputState.Begin and -1 or 0);
        end
    },
    ["Character Backward"] = {
        Callback = function(p24, p25) -- Line: 39, Name: Callback
            -- upvalues: u6 (ref)
            if not u6 then
                return;
            end;

            u6:UpdateBackward(p25 == Enum.UserInputState.Begin and 1 or 0);
        end
    },
    ["Character Left"] = {
        Callback = function(p26, p27) -- Line: 49, Name: Callback
            -- upvalues: u6 (ref)
            if not u6 then
                return;
            end;

            u6:UpdateLeft(p27 == Enum.UserInputState.Begin and -1 or 0);
        end
    },
    ["Character Right"] = {
        Callback = function(p28, p29) -- Line: 59, Name: Callback
            -- upvalues: u6 (ref)
            if not u6 then
                return;
            end;

            u6:UpdateRight(p29 == Enum.UserInputState.Begin and 1 or 0);
        end
    },
    ["Character Duck"] = {
        Callback = function(p30, p31, p32) -- Line: 69, Name: Callback
            -- upvalues: u6 (ref), u12 (ref), u14 (ref), u10 (ref), u19 (ref), u15 (ref)
            if not u6 then
                return;
            end;

            local v33;

            if p32 == nil then
                v33 = false;
            else
                v33 = p32.UserInputType == Enum.UserInputType.Touch;
            end;

            local v34;

            if p32 == nil then
                v34 = false;
            else
                v34 = p32.UserInputType.Name:find("Gamepad") ~= nil;
            end;

            local v35 = v33 and u12 or (v34 and u14 or u10);

            if p31 == Enum.UserInputState.Begin then
                if v35 == "Toggle" then
                    u19 = not u19;
                else
                    u19 = true;
                end;
            else
                if v35 ~= "Hold" then
                    return;
                end;

                u19 = false;
            end;

            u6:UpdateAdditionalInput("Duck", u19);

            if v33 then
                if v35 == "Toggle" then
                    v33 = u19;
                else
                    v33 = false;
                end;
            end;

            u15.SetLatched("Character Duck", v33);
        end
    },
    ["Character Jump"] = {
        Callback = function(p36, p37) -- Line: 96, Name: Callback
            -- upvalues: u6 (ref)
            if not u6 then
                return;
            end;

            u6:UpdateAdditionalInput("Jump", p37 == Enum.UserInputState.Begin);
        end
    },
    ["Character Walk"] = {
        Callback = function(p38, p39, p40) -- Line: 106, Name: Callback
            -- upvalues: u6 (ref), u13 (ref), u11 (ref), u20 (ref), u15 (ref)
            if not u6 then
                return;
            end;

            local v41;

            if p40 == nil then
                v41 = false;
            else
                v41 = p40.UserInputType == Enum.UserInputType.Touch;
            end;

            local v42 = v41 and u13 or u11;

            if p39 == Enum.UserInputState.Begin then
                if v42 == "Toggle" then
                    u20 = not u20;
                else
                    u20 = true;
                end;
            else
                if v42 ~= "Hold" then
                    return;
                end;

                u20 = false;
            end;

            u6:UpdateAdditionalInput("Walk", u20);

            if v41 then
                if v42 == "Toggle" then
                    v41 = u20;
                else
                    v41 = false;
                end;
            end;

            u15.SetLatched("Character Walk", v41);
        end
    },
    ["Ping Marker"] = {
        Callback = function(p43, p44) -- Line: 132, Name: Callback
            -- upvalues: u6 (ref), u16 (ref), u5 (ref)
            if not u6 or u16.Navigating() then
                return;
            end;

            if p44 ~= Enum.UserInputState.Begin then
                return;
            end;

            u5.Input();
        end
    },
    ["Character Use"] = {
        Callback = function(p45, p46) -- Line: 146, Name: Callback
            -- upvalues: u6 (ref), u21 (ref), u17 (ref), u18 (ref)
            if not u6 then
                return;
            end;

            local v47 = p46 == Enum.UserInputState.Begin;
            u6:UpdateAdditionalInput("PressE", v47);

            if not v47 then
                if u21 then
                    u21 = false;
                    u17.UpdateKeyState("WishFire", false);
                end;

                return;
            end;

            if not u18.CanPlantHere(u6.Simulation) then
                return;
            end;

            for i, v in u17.GetWeaponInventory() do
                if v.Name == "Bomb" then
                    u21 = true;
                    u17.UpdateKeyState("WishEquip", i);
                    u17.UpdateKeyState("WishFire", true);

                    return;
                end;
            end;
        end
    },
    ["Left Arm Bind"] = {
        Callback = function(p48, p49) -- Line: 184, Name: Callback
            -- upvalues: u6 (ref), u9 (ref), u7 (ref), u8 (ref)
            if p49 ~= Enum.UserInputState.Begin then
                return;
            end;

            if not u6 then
                return;
            end;

            local v50 = u9:GetPlayerSettings().Game.Gameplay["Preferred Viewmodel Left/Right Handedness"] == "Left" and "Right" or "Left";
            u7.Gui.ChangePlayerSetting.Fire({
                I = u8.SettingsNum["Preferred Viewmodel Left/Right Handedness"],
                A = u8.SettingsTabNum.Game,
                B = u8.SettingsPageNum.Gameplay,
                V = u8.SettingsDropdownNum[v50]
            });
            u9.FireConnection("Game", "Gameplay", "Preferred Viewmodel Left/Right Handedness", v50);
        end
    }
};

function v1.Get() -- Line: 212
    -- upvalues: u51 (copy)
    return u51;
end;

function v1.Init(p52) -- Line: 218
    -- upvalues: u2 (ref), u3 (ref), u7 (ref), u8 (ref), u17 (ref), u18 (ref)
    u2 = p52:GetModule("CharacterController");
    u3 = p52:GetModule("Gui");
    u7 = p52:GetModule("Network");
    u8 = p52:GetModule("Enums");
    u17 = p52:GetModule("WeaponController");
    u18 = p52:GetModule("WeaponConstructor");
end;

function v1.Start(p53) -- Line: 227
    -- upvalues: u5 (ref), u3 (ref), u4 (ref), u9 (ref), u15 (ref), u16 (ref), u10 (ref), u19 (ref), u6 (ref), u14 (ref), u12 (ref), u11 (ref), u20 (ref), u13 (ref), u2 (ref), u21 (ref), u17 (ref)
    u5 = u3.GetComponent("Ping");
    u4 = u3.GetComponent("HUD");
    u9 = u3.GetComponent("Settings");
    u15 = u3.GetComponent("MobileControls");
    u16 = u3.GetComponent("Gamepad");
    u9:AddConnection("Controls", "Keybinds", "Duck Mode", function(p54) -- Line: 233
        -- upvalues: u10 (ref), u19 (ref), u6 (ref), u15 (ref)
        u10 = p54;

        if p54 == "Hold" and u19 then
            u19 = false;

            if u6 then
                u6:UpdateAdditionalInput("Duck", false);
            end;

            u15.SetLatched("Character Duck", false);
        end;
    end);
    u9:AddConnection("Controls", "Controller Binds", "Crouch Mode", function(p55) -- Line: 241
        -- upvalues: u14 (ref), u19 (ref), u6 (ref)
        u14 = p55;

        if p55 == "Hold" and u19 then
            u19 = false;

            if u6 then
                u6:UpdateAdditionalInput("Duck", false);
            end;
        end;
    end);
    u9:AddConnection("Controls", "Mobile Buttons", "Crouch Mode", function(p56) -- Line: 248
        -- upvalues: u12 (ref), u19 (ref), u6 (ref), u15 (ref)
        u12 = p56;

        if p56 == "Hold" and u19 then
            u19 = false;

            if u6 then
                u6:UpdateAdditionalInput("Duck", false);
            end;

            u15.SetLatched("Character Duck", false);
        end;
    end);
    u9:AddConnection("Controls", "Keybinds", "Walk Mode", function(p57) -- Line: 256
        -- upvalues: u11 (ref), u20 (ref), u6 (ref), u15 (ref)
        u11 = p57;

        if p57 == "Hold" and u20 then
            u20 = false;

            if u6 then
                u6:UpdateAdditionalInput("Walk", false);
            end;

            u15.SetLatched("Character Walk", false);
        end;
    end);
    u9:AddConnection("Controls", "Mobile Buttons", "Slow Walk Mode", function(p58) -- Line: 264
        -- upvalues: u13 (ref), u20 (ref), u6 (ref), u15 (ref)
        u13 = p58;

        if p58 == "Hold" and u20 then
            u20 = false;

            if u6 then
                u6:UpdateAdditionalInput("Walk", false);
            end;

            u15.SetLatched("Character Walk", false);
        end;
    end);
    u2.OnCharacterSpawn:Connect(function(p59) -- Line: 273
        -- upvalues: u6 (ref), u19 (ref), u20 (ref), u15 (ref)
        u6 = p59;
        u19 = false;
        u20 = false;
        u15.SetLatched("Character Duck", false);
        u15.SetLatched("Character Walk", false);
    end);
    u2.OnCharacterDestroy:Connect(function() -- Line: 280
        -- upvalues: u6 (ref), u19 (ref), u20 (ref), u21 (ref), u17 (ref), u15 (ref)
        u6 = nil;
        u19 = false;
        u20 = false;

        if u21 then
            u21 = false;
            u17.UpdateKeyState("WishFire", false);
        end;

        u15.SetLatched("Character Duck", false);
        u15.SetLatched("Character Walk", false);
    end);
end;

return v1;