-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);

return function(u1: string, p2: any, p3: userdata, p4: number, u5: any, p6: number, p7: boolean?, u8: function, u9: string) -- Line: 31
    -- upvalues: Janitor (copy), GuiService (copy), UserInputService (copy)
    u5.Name = u1;
    u5.Left.Label.Text = p2.DisplayName or u1;
    u5.LayoutOrder = p4;
    local u10 = p2.HasEnabledToggle or false;
    local u11 = p2.Step or 1;
    local u12 = p2.Max or 100;
    local u13 = p2.Min or 0;
    local u14 = p6;
    local u15 = false;
    local u16 = p7 == nil and true or (p7 or true);
    local u17 = Janitor.new();
    u17:Add(u5, "Destroy");
    local Container = u5.Right.Container;
    local Slider = Container.Left.Slider;
    local Button = Slider.Button;
    local Title = Container.Container.Left.Title;
    Slider.AutoButtonColor = false;
    Slider.Active = false;
    Button.AutoButtonColor = false;
    Button.Active = false;
    Title.Selectable = true;
    Container.Active = false;

    if u5:FindFirstChild("Check") and not u10 then
        u5.Check.Visible = false;
    end;

    local function FormatNumber(p18: number) -- Line: 85
        local v19 = math.round(p18 * 100) / 100;

        if v19 ~= math.floor(v19) then
            return string.format("%.2f", v19):gsub("%.?0+$", "");
        end;

        local math_floor_ret = math.floor(v19);

        return tostring(math_floor_ret);
    end;

    local function UpdateSlider(p20: number, p21: boolean?, p22: boolean?) -- Line: 96
        -- upvalues: u13 (copy), u12 (copy), u11 (copy), u14 (ref), Slider (copy), Button (copy), Title (copy), u8 (copy), u9 (copy), u1 (copy)
        local math_clamp_ret = math.clamp(p20, u13, u12);

        if p22 then
            math_clamp_ret = math.round(math_clamp_ret / u11) * u11;
        end;

        u14 = math_clamp_ret;
        local v23 = (math_clamp_ret - u13) / (u12 - u13);
        Slider.Bar.Size = UDim2.new(v23, 0, 1, 0);
        Button.Position = UDim2.new(v23, 0, 0.5, 0);
        local v24 = math.round(math_clamp_ret * 100) / 100;
        local v25;

        if v24 == math.floor(v24) then
            local math_floor_ret = math.floor(v24);
            v25 = tostring(math_floor_ret);
        else
            v25 = string.format("%.2f", v24):gsub("%.?0+$", "");
        end;

        Title.Text = v25;

        if p21 then
            u8(u9, u1, u14, true);
        end;
    end;

    local function UpdateSliderFromMouse(p26: number, p27: boolean?) -- Line: 115
        -- upvalues: Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        UpdateSlider(u13 + math.clamp((p26 - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), p27, true);
    end;

    local function CommitValue() -- Line: 124
        -- upvalues: u10 (copy), u8 (copy), u9 (copy), u1 (copy), u16 (ref), u14 (ref)
        if u10 then
            u8(u9, u1, {
                Enabled = u16,
                Value = u14
            }, false);

            return;
        end;

        u8(u9, u1, u14, false);
    end;

    local function EndDrag(p28: userdata) -- Line: 132
        -- upvalues: u15 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u16 (ref), u14 (ref)
        if (p28.UserInputType == Enum.UserInputType.MouseButton1 or p28.UserInputType == Enum.UserInputType.Touch) and u15 then
            u15 = false;

            if u10 then
                u8(u9, u1, {
                    Enabled = u16,
                    Value = u14
                }, false);

                return;
            end;

            u8(u9, u1, u14, false);
        end;
    end;

    local math_clamp_ret = math.clamp(u14, u13, u12);
    u14 = math_clamp_ret;
    local v29 = (math_clamp_ret - u13) / (u12 - u13);
    Slider.Bar.Size = UDim2.new(v29, 0, 1, 0);
    Button.Position = UDim2.new(v29, 0, 0.5, 0);
    local v30 = math.round(math_clamp_ret * 100) / 100;
    local v31;

    if v30 == math.floor(v30) then
        local math_floor_ret = math.floor(v30);
        v31 = tostring(math_floor_ret);
    else
        v31 = string.format("%.2f", v30):gsub("%.?0+$", "");
    end;

    Title.Text = v31;
    u17:Add(Slider.InputBegan:Connect(function(p32: userdata) -- Line: 143
        -- upvalues: u16 (ref), u15 (ref), GuiService (ref), Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        if (p32.UserInputType == Enum.UserInputType.MouseButton1 or p32.UserInputType == Enum.UserInputType.Touch) and u16 then
            u15 = true;
            local GuiInset = GuiService:GetGuiInset();
            UpdateSlider(u13 + math.clamp((p32.Position.X - GuiInset.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), nil, true);
        end;
    end), "Disconnect");
    u17:Add(Slider.InputEnded:Connect(EndDrag), "Disconnect");
    u17:Add(Button.InputBegan:Connect(function(p33: userdata) -- Line: 156
        -- upvalues: u16 (ref), u15 (ref), UserInputService (ref), GuiService (ref), Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        if (p33.UserInputType == Enum.UserInputType.MouseButton1 or p33.UserInputType == Enum.UserInputType.Touch) and u16 then
            u15 = true;

            while task.wait(0.01) and u15 do
                local MouseLocation = UserInputService:GetMouseLocation();
                local GuiInset = GuiService:GetGuiInset();
                UpdateSlider(u13 + math.clamp((MouseLocation.X - GuiInset.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), true, true);
            end;
        end;
    end), "Disconnect");
    u17:Add(Button.InputEnded:Connect(EndDrag), "Disconnect");
    u17:Add(UserInputService.InputChanged:Connect(function(p34: userdata) -- Line: 172
        -- upvalues: u15 (ref), Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        if u15 and (p34.UserInputType == Enum.UserInputType.MouseMovement or p34.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(u13 + math.clamp((p34.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), true, true);
        end;
    end), "Disconnect");
    u17:Add(Title.FocusLost:Connect(function() -- Line: 179
        -- upvalues: u16 (ref), Title (copy), u13 (copy), u12 (copy), u14 (ref), Slider (copy), Button (copy), u10 (copy), u8 (copy), u9 (copy), u1 (copy)
        if not u16 then
            return;
        end;

        local v35 = tonumber(Title.Text);

        if not v35 then
            local v36 = math.round(u14 * 100) / 100;
            local v37;

            if v36 == math.floor(v36) then
                local math_floor_ret = math.floor(v36);
                v37 = tostring(math_floor_ret);
            else
                v37 = string.format("%.2f", v36):gsub("%.?0+$", "");
            end;

            Title.Text = v37;

            return;
        end;

        local math_clamp_ret2 = math.clamp(v35, u13, u12);
        u14 = math_clamp_ret2;
        local v38 = (math_clamp_ret2 - u13) / (u12 - u13);
        Slider.Bar.Size = UDim2.new(v38, 0, 1, 0);
        Button.Position = UDim2.new(v38, 0, 0.5, 0);
        local v39 = math.round(math_clamp_ret2 * 100) / 100;
        local v40;

        if v39 == math.floor(v39) then
            local math_floor_ret = math.floor(v39);
            v40 = tostring(math_floor_ret);
        else
            v40 = string.format("%.2f", v39):gsub("%.?0+$", "");
        end;

        Title.Text = v40;

        if u10 then
            u8(u9, u1, {
                Enabled = u16,
                Value = u14
            }, false);

            return;
        end;

        u8(u9, u1, u14, false);
    end), "Disconnect");
    Slider.Selectable = false;
    Container.SelectionGroup = true;
    Container.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
    Container.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
    Container.SelectionBehaviorUp = Enum.SelectionBehavior.Escape;
    Container.SelectionBehaviorDown = Enum.SelectionBehavior.Escape;
    local u41 = nil;

    local function CommitValueSoon() -- Line: 216
        -- upvalues: u41 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u16 (ref), u14 (ref)
        if u41 then
            task.cancel(u41);
            u41 = nil;
        end;

        u41 = task.delay(0.35, function() -- Line: 218
            -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
            u41 = nil;

            if u10 then
                u8(u9, u1, {
                    Enabled = u16,
                    Value = u14
                }, false);

                return;
            end;

            u8(u9, u1, u14, false);
        end);
    end;

    u17:Add(function() -- Line: 209, Name: CancelPendingCommit
        -- upvalues: u41 (ref)
        if u41 then
            task.cancel(u41);
            u41 = nil;
        end;
    end, true);
    local u42 = 0;
    local u43 = "DPad";
    local u44 = 0;
    local u45 = nil;

    local function IsSliderSelected() -- Line: 236
        -- upvalues: GuiService (ref), Slider (copy), Title (copy)
        local SelectedObject = GuiService.SelectedObject;

        return SelectedObject == Slider and true or SelectedObject == Title;
    end;

    local function IsDirectionHeld(p46: number) -- Line: 241
        -- upvalues: u43 (ref), u44 (ref), UserInputService (ref)
        if u43 == "Stick" then
            local v47;

            if math.abs(u44) >= 0.5 then
                v47 = math.sign(u44) == p46;
            else
                v47 = false;
            end;

            return v47;
        end;

        local v48;

        if p46 < 0 then
            v48 = Enum.KeyCode.DPadLeft;
        else
            v48 = Enum.KeyCode.DPadRight;
        end;

        for _, v in UserInputService:GetConnectedGamepads() do
            if UserInputService:IsGamepadButtonDown(v, v48) then
                return true;
            end;
        end;

        return false;
    end;

    local function Nudge(p49: number, p50: number) -- Line: 255
        -- upvalues: UpdateSlider (copy), u14 (ref), u41 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u16 (ref)
        UpdateSlider(u14 + p49 * p50, true, true);

        if u41 then
            task.cancel(u41);
            u41 = nil;
        end;

        u41 = task.delay(0.35, function() -- Line: 218
            -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
            u41 = nil;

            if u10 then
                u8(u9, u1, {
                    Enabled = u16,
                    Value = u14
                }, false);

                return;
            end;

            u8(u9, u1, u14, false);
        end);
    end;

    local function StartHold(u51: number, p52: string) -- Line: 268
        -- upvalues: u42 (ref), u45 (ref), u43 (ref), u11 (copy), UpdateSlider (copy), u14 (ref), u41 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u16 (ref), u12 (copy), u13 (copy), GuiService (ref), Slider (copy), Title (copy), IsDirectionHeld (copy)
        u42 = 0;

        if u45 and coroutine.running() ~= u45 then
            task.cancel(u45);
        end;

        u45 = nil;
        u42 = u51;
        u43 = p52;
        UpdateSlider(u14 + u51 * u11, true, true);

        if u41 then
            task.cancel(u41);
            u41 = nil;
        end;

        u41 = task.delay(0.35, function() -- Line: 218
            -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
            u41 = nil;

            if u10 then
                u8(u9, u1, {
                    Enabled = u16,
                    Value = u14
                }, false);

                return;
            end;

            u8(u9, u1, u14, false);
        end);
        u45 = task.spawn(function() -- Line: 274
            -- upvalues: u11 (ref), u12 (ref), u13 (ref), u16 (ref), u42 (ref), u51 (copy), GuiService (ref), Slider (ref), Title (ref), IsDirectionHeld (ref), UpdateSlider (ref), u14 (ref), u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u45 (ref)
            task.wait(0.35);
            local math_max_ret = math.max(u11, (u12 - u13) / 60);

            while u16 and u42 == u51 do
                local SelectedObject = GuiService.SelectedObject;

                if not ((SelectedObject == Slider or SelectedObject == Title) and IsDirectionHeld(u51)) then
                    break;
                end;

                UpdateSlider(u14 + u51 * math_max_ret, true, true);

                if u41 then
                    task.cancel(u41);
                    u41 = nil;
                end;

                u41 = task.delay(0.35, function() -- Line: 218
                    -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
                    u41 = nil;

                    if u10 then
                        u8(u9, u1, {
                            Enabled = u16,
                            Value = u14
                        }, false);

                        return;
                    end;

                    u8(u9, u1, u14, false);
                end);
                task.wait(0.05);
            end;

            if u42 == u51 then
                u42 = 0;
            end;

            u45 = nil;
        end);
    end;

    u17:Add(function() -- Line: 260, Name: StopHold
        -- upvalues: u42 (ref), u45 (ref)
        u42 = 0;

        if u45 and coroutine.running() ~= u45 then
            task.cancel(u45);
        end;

        u45 = nil;
    end, true);
    u17:Add(UserInputService.InputBegan:Connect(function(p53: userdata) -- Line: 292
        -- upvalues: GuiService (ref), Slider (copy), Title (copy), u16 (ref), u41 (ref), u42 (ref), u45 (ref), u43 (ref), u11 (copy), UpdateSlider (copy), u14 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u12 (copy), u13 (copy), IsDirectionHeld (copy)
        local SelectedObject = GuiService.SelectedObject;

        if not ((SelectedObject == Slider or SelectedObject == Title) and u16) then
            return;
        end;

        if Title:IsFocused() then
            return;
        end;

        if p53.KeyCode == Enum.KeyCode.ButtonA and GuiService.SelectedObject == Title then
            if u41 then
                task.cancel(u41);
                u41 = nil;
            end;

            Title:CaptureFocus();

            return;
        end;

        if p53.KeyCode ~= Enum.KeyCode.DPadLeft then
            if p53.KeyCode == Enum.KeyCode.DPadRight then
                u42 = 0;

                if u45 and coroutine.running() ~= u45 then
                    task.cancel(u45);
                end;

                u45 = nil;
                u42 = 1;
                u43 = "DPad";
                UpdateSlider(u14 + u11 * 1, true, true);

                if u41 then
                    task.cancel(u41);
                    u41 = nil;
                end;

                u41 = task.delay(0.35, function() -- Line: 218
                    -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
                    u41 = nil;

                    if u10 then
                        u8(u9, u1, {
                            Enabled = u16,
                            Value = u14
                        }, false);

                        return;
                    end;

                    u8(u9, u1, u14, false);
                end);
                local u54 = 1;
                u45 = task.spawn(function() -- Line: 274
                    -- upvalues: u11 (ref), u12 (ref), u13 (ref), u16 (ref), u42 (ref), u54 (copy), GuiService (ref), Slider (ref), Title (ref), IsDirectionHeld (ref), UpdateSlider (ref), u14 (ref), u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u45 (ref)
                    task.wait(0.35);
                    local math_max_ret = math.max(u11, (u12 - u13) / 60);

                    while u16 and u42 == u54 do
                        local SelectedObject2 = GuiService.SelectedObject;

                        if not ((SelectedObject2 == Slider or SelectedObject2 == Title) and IsDirectionHeld(u54)) then
                            break;
                        end;

                        UpdateSlider(u14 + u54 * math_max_ret, true, true);

                        if u41 then
                            task.cancel(u41);
                            u41 = nil;
                        end;

                        u41 = task.delay(0.35, function() -- Line: 218
                            -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
                            u41 = nil;

                            if u10 then
                                u8(u9, u1, {
                                    Enabled = u16,
                                    Value = u14
                                }, false);

                                return;
                            end;

                            u8(u9, u1, u14, false);
                        end);
                        task.wait(0.05);
                    end;

                    if u42 == u54 then
                        u42 = 0;
                    end;

                    u45 = nil;
                end);
            end;

            return;
        end;

        u42 = 0;

        if u45 and coroutine.running() ~= u45 then
            task.cancel(u45);
        end;

        u45 = nil;
        u42 = -1;
        u43 = "DPad";
        UpdateSlider(u14 + u11 * -1, true, true);

        if u41 then
            task.cancel(u41);
            u41 = nil;
        end;

        u41 = task.delay(0.35, function() -- Line: 218
            -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
            u41 = nil;

            if u10 then
                u8(u9, u1, {
                    Enabled = u16,
                    Value = u14
                }, false);

                return;
            end;

            u8(u9, u1, u14, false);
        end);
        local u55 = -1;
        u45 = task.spawn(function() -- Line: 274
            -- upvalues: u11 (ref), u12 (ref), u13 (ref), u16 (ref), u42 (ref), u55 (copy), GuiService (ref), Slider (ref), Title (ref), IsDirectionHeld (ref), UpdateSlider (ref), u14 (ref), u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u45 (ref)
            task.wait(0.35);
            local math_max_ret = math.max(u11, (u12 - u13) / 60);

            while u16 and u42 == u55 do
                local SelectedObject2 = GuiService.SelectedObject;

                if not ((SelectedObject2 == Slider or SelectedObject2 == Title) and IsDirectionHeld(u55)) then
                    break;
                end;

                UpdateSlider(u14 + u55 * math_max_ret, true, true);

                if u41 then
                    task.cancel(u41);
                    u41 = nil;
                end;

                u41 = task.delay(0.35, function() -- Line: 218
                    -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
                    u41 = nil;

                    if u10 then
                        u8(u9, u1, {
                            Enabled = u16,
                            Value = u14
                        }, false);

                        return;
                    end;

                    u8(u9, u1, u14, false);
                end);
                task.wait(0.05);
            end;

            if u42 == u55 then
                u42 = 0;
            end;

            u45 = nil;
        end);
    end), "Disconnect");
    u17:Add(UserInputService.InputChanged:Connect(function(p56: userdata) -- Line: 318
        -- upvalues: u44 (ref), u43 (ref), u42 (ref), u45 (ref), GuiService (ref), Slider (copy), Title (copy), u16 (ref), u11 (copy), UpdateSlider (copy), u14 (ref), u41 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u12 (copy), u13 (copy), IsDirectionHeld (copy)
        if p56.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return;
        end;

        local Position = p56.Position;
        u44 = math.abs(Position.X) <= math.abs(Position.Y) and 0 or Position.X;
        local u57 = math.abs(u44) < 0.5 and 0 or math.sign(u44);

        if u57 == 0 then
            if u43 == "Stick" and u42 ~= 0 then
                u42 = 0;

                if u45 and coroutine.running() ~= u45 then
                    task.cancel(u45);
                end;

                u45 = nil;
            end;

            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if not ((SelectedObject == Slider or SelectedObject == Title) and (u16 and not Title:IsFocused())) then
            return;
        end;

        if u42 ~= u57 or u43 ~= "Stick" then
            u42 = 0;

            if u45 and coroutine.running() ~= u45 then
                task.cancel(u45);
            end;

            u45 = nil;
            u42 = u57;
            u43 = "Stick";
            UpdateSlider(u14 + u57 * u11, true, true);

            if u41 then
                task.cancel(u41);
                u41 = nil;
            end;

            u41 = task.delay(0.35, function() -- Line: 218
                -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
                u41 = nil;

                if u10 then
                    u8(u9, u1, {
                        Enabled = u16,
                        Value = u14
                    }, false);

                    return;
                end;

                u8(u9, u1, u14, false);
            end);
            u45 = task.spawn(function() -- Line: 274
                -- upvalues: u11 (ref), u12 (ref), u13 (ref), u16 (ref), u42 (ref), u57 (copy), GuiService (ref), Slider (ref), Title (ref), IsDirectionHeld (ref), UpdateSlider (ref), u14 (ref), u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u45 (ref)
                task.wait(0.35);
                local math_max_ret = math.max(u11, (u12 - u13) / 60);

                while u16 and u42 == u57 do
                    local SelectedObject2 = GuiService.SelectedObject;

                    if not ((SelectedObject2 == Slider or SelectedObject2 == Title) and IsDirectionHeld(u57)) then
                        break;
                    end;

                    UpdateSlider(u14 + u57 * math_max_ret, true, true);

                    if u41 then
                        task.cancel(u41);
                        u41 = nil;
                    end;

                    u41 = task.delay(0.35, function() -- Line: 218
                        -- upvalues: u41 (ref), u10 (ref), u8 (ref), u9 (ref), u1 (ref), u16 (ref), u14 (ref)
                        u41 = nil;

                        if u10 then
                            u8(u9, u1, {
                                Enabled = u16,
                                Value = u14
                            }, false);

                            return;
                        end;

                        u8(u9, u1, u14, false);
                    end);
                    task.wait(0.05);
                end;

                if u42 == u57 then
                    u42 = 0;
                end;

                u45 = nil;
            end);
        end;
    end), "Disconnect");
    u17:Add(UserInputService.InputEnded:Connect(function(p58: userdata) -- Line: 347
        -- upvalues: u44 (ref), u43 (ref), u42 (ref), u45 (ref)
        if p58.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return;
        end;

        u44 = 0;

        if u43 == "Stick" and u42 ~= 0 then
            u42 = 0;

            if u45 and coroutine.running() ~= u45 then
                task.cancel(u45);
            end;

            u45 = nil;
        end;
    end), "Disconnect");

    if u5:FindFirstChild("Check") and u10 then
        u5.Check.ImageLabel.Visible = u16;
        u5.Frame.TextBox.TextEditable = u16;
        Button.Active = u16;
        Slider.Active = u16;
        u5.Slider.Bar.BackgroundTransparency = u16 and 0 or 0.5;
        u5.Slider.Button.ImageTransparency = u16 and 0 or 0.5;
        u5.Frame.TextBox.TextTransparency = u16 and 0 or 0.5;
        u5.Slider.ImageTransparency = u16 and 0 or 0.5;
        u17:Add(u5.Check.MouseButton1Click:Connect(function() -- Line: 375
            -- upvalues: u16 (ref), u5 (copy), Slider (copy), Button (copy), u8 (copy), u9 (copy), u1 (copy), u14 (ref)
            u16 = not u16;
            u5.Check.ImageLabel.Visible = u16;
            Slider.Active = u16;
            Button.Active = u16;
            u5.Frame.TextBox.TextEditable = u16;
            u5.Slider.ImageTransparency = u16 and 0 or 0.5;
            u5.Slider.Bar.BackgroundTransparency = u16 and 0 or 0.5;
            u5.Slider.Button.ImageTransparency = u16 and 0 or 0.5;
            u5.Frame.TextBox.TextTransparency = u16 and 0 or 0.5;
            u8(u9, u1, {
                Enabled = u16,
                Value = u14
            }, false);
        end), "Disconnect");
    end;

    u5.Parent = p3;

    return function() -- Line: 396
        -- upvalues: u15 (ref), u17 (copy)
        u15 = false;
        u17:Cleanup();
    end;
end;