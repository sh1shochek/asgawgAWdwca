-- ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Slider
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Slider
-- Decompile time: 13.18 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
require(script.Parent.Parent.Types)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
return function(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 31
    -- upvalues: Janitor (val), GuiService (val), UserInputService (val)
    local u24
    a5.Name = a1
    a5.Left.Label.Text = a2.DisplayName or a1
    a5.LayoutOrder = a4
    local u14 = a2.HasEnabledToggle or false
    local u16 = a2.Step or 1
    local u18 = a2.Max or 100
    local u20 = a2.Min or 0
    local u21 = a6
    local u22 = false
    if a7 == nil then
        u24 = true
    else
        u24 = a7
        if not u24 then
            u24 = true
        end
    end
    local u27 = Janitor.new()
    u27:Add(a5, "Destroy")
    local Container = a5.Right.Container
    local Slider = Container.Left.Slider
    local Button = Slider.Button
    local Title = Container.Container.Left.Title
    Slider.AutoButtonColor = false
    Slider.Active = false
    Button.AutoButtonColor = false
    Button.Active = false
    Title.Selectable = true
    Container.Active = false
    if a5:FindFirstChild("Check") and not u14 then
        a5.Check.Visible = false
    end

    local function FormatNumber(a1) -- Line: 85 -- types: a1: number
        local v1 = math.round(a1 * 100) / 100
        if v1 == math.floor(v1) then
            return (tostring((math.floor(v1))))
        end
        return (string.format("%.2f", v1)):gsub("%.?0+$", "")
    end

    local function UpdateSlider(a1_2, a2, a3) -- Line: 96
        -- upvalues: u20 (val), u18 (val), u16 (val), u21 (ref), Slider (val), Button (val), Title (val), a8 (val)
        -- upvalues: a9 (val), a1 (val)
        local v1 = math.clamp(a1_2, u20, u18)
        if a3 then
            v1 = (math.round(v1 / u16)) * u16
        end
        local v2 = (v1 - u20) / (u18 - u20)
        Slider.Bar.Size = UDim2.new(v2, 0, 1, 0)
        Button.Position = UDim2.new(v2, 0, 0.5, 0)
        local v3 = math.round(v1 * 100) / 100
        Title.Text = if v3 ~= math.floor(v3) then (string.format("%.2f", v3)):gsub("%.?0+$", "") else tostring((math.floor(v3)))
        if a2 then
            a8(a9, a1, v1, true)
        end
    end

    local function UpdateSliderFromMouse(a1, a2) -- Line: 115
        -- upvalues: Slider (val), u20 (val), u18 (val), UpdateSlider (val)
        local X = Slider.AbsolutePosition.X
        local X_2 = Slider.AbsoluteSize.X
        UpdateSlider(u20 + (math.clamp((a1 - X) / X_2, 0, 1)) * (u18 - u20), a2, true)
    end

    local function CommitValue() -- Line: 124 -- upvalues: u14 (val), a8 (val), a9 (val), a1 (val), u24 (ref), u21 (ref)
        if u14 then
            a8(a9, a1, {Enabled = u24, Value = u21}, false)
            return
        end
        a8(a9, a1, u21, false)
    end

    local function EndDrag(a1_2) -- Line: 132
        -- upvalues: u22 (ref), u14 (val), a8 (val), a9 (val), a1 (val), u24 (ref), u21 (ref)
        if a1_2.UserInputType ~= Enum.UserInputType.MouseButton1
            and a1_2.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if u22 then
            u22 = false
            if u14 then
                a8(a9, a1, {Enabled = u24, Value = u21}, false)
                return
            end
            a8(a9, a1, u21, false)
        end
    end

    local v1 = math.clamp(u21, u20, u18)
    u21 = v1
    local v2 = (v1 - u20) / (u18 - u20)
    Slider.Bar.Size = UDim2.new(v2, 0, 1, 0)
    Button.Position = UDim2.new(v2, 0, 0.5, 0)
    local v3 = math.round(v1 * 100) / 100
    Title.Text = if v3 ~= math.floor(v3) then (string.format("%.2f", v3)):gsub("%.?0+$", "") else tostring((math.floor(v3)))
    u27:Add(Slider.InputBegan:Connect(function(a1) -- Line: 143
        -- upvalues: u24 (ref), u22 (ref), GuiService (upval), Slider (val), u20 (val), u18 (val), UpdateSlider (val)
        local X, X_2, v1
        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
            if u24 then
                u22 = true
                v1 = a1.Position.X - (GuiService:GetGuiInset()).X
                X = Slider.AbsolutePosition.X
                X_2 = Slider.AbsoluteSize.X
                UpdateSlider(u20 + (math.clamp((v1 - X) / X_2, 0, 1)) * (u18 - u20), nil, true)
            end
        elseif a1.UserInputType == Enum.UserInputType.Touch and u24 then
            u22 = true
            v1 = a1.Position.X - (GuiService:GetGuiInset()).X
            X = Slider.AbsolutePosition.X
            X_2 = Slider.AbsoluteSize.X
            UpdateSlider(u20 + (math.clamp((v1 - X) / X_2, 0, 1)) * (u18 - u20), nil, true)
        end
    end), "Disconnect")
    u27:Add(Slider.InputEnded:Connect(EndDrag), "Disconnect")
    u27:Add(Button.InputBegan:Connect(function(a1) -- Line: 156
        -- upvalues: u24 (ref), u22 (ref), UserInputService (upval), GuiService (upval), Slider (val), u20 (val)
        -- upvalues: u18 (val), UpdateSlider (val)
        local X, X_2, v1
        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
            if u24 then
                u22 = true
                while task.wait(0.01) do
                    if not u22 then
                        break
                    end
                    v1 = (UserInputService:GetMouseLocation()).X - (GuiService:GetGuiInset()).X
                    X = Slider.AbsolutePosition.X
                    X_2 = Slider.AbsoluteSize.X
                    UpdateSlider(u20 + (math.clamp((v1 - X) / X_2, 0, 1)) * (u18 - u20), true, true)
                end
            end
        elseif a1.UserInputType == Enum.UserInputType.Touch and u24 then
            u22 = true
            while task.wait(0.01) do
                if not u22 then
                    break
                end
                v1 = (UserInputService:GetMouseLocation()).X - (GuiService:GetGuiInset()).X
                X = Slider.AbsolutePosition.X
                X_2 = Slider.AbsoluteSize.X
                UpdateSlider(u20 + (math.clamp((v1 - X) / X_2, 0, 1)) * (u18 - u20), true, true)
            end
        end
    end), "Disconnect")
    u27:Add(Button.InputEnded:Connect(EndDrag), "Disconnect")
    u27:Add(UserInputService.InputChanged:Connect(function(a1) -- Line: 172
        -- upvalues: u22 (ref), Slider (val), u20 (val), u18 (val), UpdateSlider (val)
        if u22 then
            if a1.UserInputType == Enum.UserInputType.MouseMovement
                or a1.UserInputType == Enum.UserInputType.Touch then
                local X = a1.Position.X
                local X_2 = Slider.AbsolutePosition.X
                local X_3 = Slider.AbsoluteSize.X
                UpdateSlider(u20 + (math.clamp((X - X_2) / X_3, 0, 1)) * (u18 - u20), true, true)
            end
        end
    end), "Disconnect")
    u27:Add(Title.FocusLost:Connect(function() -- Line: 179
        -- upvalues: u24 (ref), Title (val), u20 (val), u18 (val), u21 (ref), Slider (val), Button (val), u14 (val)
        -- upvalues: a8 (val), a9 (val), a1 (val)
        if not u24 then
            return
        end
        local v1 = tonumber(Title.Text)
        if not v1 then
            local v2 = math.round(u21 * 100) / 100
            Title.Text = if v2 ~= math.floor(v2) then (string.format("%.2f", v2)):gsub("%.?0+$", "") else tostring((math.floor(v2)))
            return
        end
        local v3 = math.clamp(v1, u20, u18)
        u21 = v3
        local v4 = (v3 - u20) / (u18 - u20)
        Slider.Bar.Size = UDim2.new(v4, 0, 1, 0)
        Button.Position = UDim2.new(v4, 0, 0.5, 0)
        local v5 = math.round(v3 * 100) / 100
        Title.Text = if v5 ~= math.floor(v5) then (string.format("%.2f", v5)):gsub("%.?0+$", "") else tostring((math.floor(v5)))
        if u14 then
            a8(a9, a1, {Enabled = u24, Value = u21}, false)
            return
        end
        a8(a9, a1, u21, false)
    end), "Disconnect")
    Slider.Selectable = false
    Container.SelectionGroup = true
    Container.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
    Container.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
    Container.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
    Container.SelectionBehaviorDown = Enum.SelectionBehavior.Escape
    local u219 = nil

    local function CommitValueSoon() -- Line: 216
        -- upvalues: u219 (ref), u14 (val), a8 (val), a9 (val), a1 (val), u24 (ref), u21 (ref)
        if u219 then
            task.cancel(u219)
            u219 = nil
        end
        u219 = task.delay(0.35, function() -- Line: 218
            -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval), u21 (upval)
            u219 = nil
            if u14 then
                a8(a9, a1, {Enabled = u24, Value = u21}, false)
                return
            end
            a8(a9, a1, u21, false)
        end)
    end

    u27:Add(function() -- Line: 209 -- upvalues: u219 (ref)
        if u219 then
            task.cancel(u219)
            u219 = nil
        end
    end, true)
    local u227 = 0
    local u228 = "DPad"
    local u229 = 0
    local u230 = nil

    local function IsSliderSelected() -- Line: 236 -- upvalues: GuiService (upval), Slider (val), Title (val)
        local SelectedObject = GuiService.SelectedObject
        local v1 = true
        if SelectedObject ~= Slider then
            v1 = SelectedObject == Title
        end
        return v1
    end

    local function IsDirectionHeld(a1) -- Line: 241
        -- upvalues: u228 (ref), u229 (ref), UserInputService (upval)
        if u228 == "Stick" then
            local v1 = false
            if 0.5 <= (math.abs(u229)) then
                v1 = math.sign(u229) == a1
            end
            return v1
        end
        local DPadLeft = if not (a1 < 0) then Enum.KeyCode.DPadRight else Enum.KeyCode.DPadLeft
        for i, j in UserInputService:GetConnectedGamepads() do
            if UserInputService:IsGamepadButtonDown(j, DPadLeft) then
                return true
            end
        end
        return false
    end

    local function Nudge(a1_2, a2) -- Line: 255
        -- upvalues: UpdateSlider (val), u21 (ref), u219 (ref), u14 (val), a8 (val), a9 (val), a1 (val), u24 (ref)
        UpdateSlider(u21 + a1_2 * a2, true, true)
        if u219 then
            task.cancel(u219)
            u219 = nil
        end
        u219 = task.delay(0.35, function() -- Line: 218
            -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval), u21 (upval)
            u219 = nil
            if u14 then
                a8(a9, a1, {Enabled = u24, Value = u21}, false)
                return
            end
            a8(a9, a1, u21, false)
        end)
    end

    local function StartHold(a1_2, a2) -- Line: 268
        -- upvalues: u227 (ref), u230 (ref), u228 (ref), u16 (val), UpdateSlider (val), u21 (ref), u219 (ref), u14 (val)
        -- upvalues: a8 (val), a9 (val), a1 (val), u24 (ref), u18 (val), u20 (val), GuiService (upval), Slider (val)
        -- upvalues: Title (val), IsDirectionHeld (val)
        u227 = 0
        if u230 and coroutine.running() ~= u230 then
            task.cancel(u230)
        end
        u230 = nil
        u227 = a1_2
        u228 = a2
        UpdateSlider(u21 + a1_2 * u16, true, true)
        if u219 then
            task.cancel(u219)
            u219 = nil
        end
        u219 = task.delay(0.35, function() -- Line: 218
            -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval), u21 (upval)
            u219 = nil
            if u14 then
                a8(a9, a1, {Enabled = u24, Value = u21}, false)
                return
            end
            a8(a9, a1, u21, false)
        end)
        u230 = task.spawn(function() -- Line: 274
            -- upvalues: u16 (upval), u18 (upval), u20 (upval), u24 (upval), u227 (upval), a1_2 (val)
            -- upvalues: GuiService (upval), Slider (upval), Title (upval), IsDirectionHeld (upval)
            -- upvalues: UpdateSlider (upval), u21 (upval), u219 (upval), u14 (upval), a8 (upval), a9 (upval)
            -- upvalues: a1 (upval), u230 (upval)
            local SelectedObject, v1
            task.wait(0.35)
            local v2 = math.max(u16, (u18 - u20) / 60)
            while u24 do
                if u227 ~= a1_2 then
                    break
                end
                SelectedObject = GuiService.SelectedObject
                v1 = true
                if SelectedObject ~= Slider then
                    v1 = SelectedObject == Title
                end
                if not v1 or not IsDirectionHeld(a1_2) then
                    break
                end
                UpdateSlider(u21 + a1_2 * v2, true, true)
                if u219 then
                    task.cancel(u219)
                    u219 = nil
                end
                u219 = task.delay(0.35, function() -- Line: 218
                    -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval), u21 (upval)
                    u219 = nil
                    if u14 then
                        a8(a9, a1, {Enabled = u24, Value = u21}, false)
                        return
                    end
                    a8(a9, a1, u21, false)
                end)
                task.wait(0.05)
            end
            if u227 == a1_2 then
                u227 = 0
            end
            u230 = nil
        end)
    end

    u27:Add(function() -- Line: 260 -- upvalues: u227 (ref), u230 (ref)
        u227 = 0
        if u230 and coroutine.running() ~= u230 then
            task.cancel(u230)
        end
        u230 = nil
    end, true)
    u27:Add(UserInputService.InputBegan:Connect(function(a1_2) -- Line: 292
        -- upvalues: GuiService (upval), Slider (val), Title (val), u24 (ref), u219 (ref), u227 (ref), u230 (ref)
        -- upvalues: u228 (ref), u16 (val), UpdateSlider (val), u21 (ref), u14 (val), a8 (val), a9 (val), a1 (val)
        -- upvalues: u18 (val), u20 (val), IsDirectionHeld (val)
        local SelectedObject = GuiService.SelectedObject
        local v1 = true
        if SelectedObject ~= Slider then
            v1 = SelectedObject == Title
        end
        if v1 and u24 then
            if Title:IsFocused() then
                return
            end
            if a1_2.KeyCode == Enum.KeyCode.ButtonA and GuiService.SelectedObject == Title then
                if u219 then
                    task.cancel(u219)
                    u219 = nil
                end
                Title:CaptureFocus()
                return
            end
            if a1_2.KeyCode == Enum.KeyCode.DPadLeft then
                u227 = 0
                if u230 and coroutine.running() ~= u230 then
                    task.cancel(u230)
                end
                u230 = nil
                u227 = -1
                u228 = "DPad"
                UpdateSlider(u21 + u16 * -1, true, true)
                if u219 then
                    task.cancel(u219)
                    u219 = nil
                end
                u219 = task.delay(0.35, function() -- Line: 218
                    -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval), u21 (upval)
                    u219 = nil
                    if u14 then
                        a8(a9, a1, {Enabled = u24, Value = u21}, false)
                        return
                    end
                    a8(a9, a1, u21, false)
                end)
                local spawn = task.spawn
                local u61 = -1
                u230 = spawn(function() -- Line: 274
                    -- upvalues: u16 (upval), u18 (upval), u20 (upval), u24 (upval), u227 (upval), u61 (val)
                    -- upvalues: GuiService (upval), Slider (upval), Title (upval), IsDirectionHeld (upval)
                    -- upvalues: UpdateSlider (upval), u21 (upval), u219 (upval), u14 (upval), a8 (upval), a9 (upval)
                    -- upvalues: a1 (upval), u230 (upval)
                    local SelectedObject, v1
                    task.wait(0.35)
                    local v2 = math.max(u16, (u18 - u20) / 60)
                    while u24 do
                        if u227 ~= u61 then
                            break
                        end
                        SelectedObject = GuiService.SelectedObject
                        v1 = true
                        if SelectedObject ~= Slider then
                            v1 = SelectedObject == Title
                        end
                        if not v1 or not IsDirectionHeld(u61) then
                            break
                        end
                        UpdateSlider(u21 + u61 * v2, true, true)
                        if u219 then
                            task.cancel(u219)
                            u219 = nil
                        end
                        u219 = task.delay(0.35, function() -- Line: 218
                            -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval)
                            -- upvalues: u21 (upval)
                            u219 = nil
                            if u14 then
                                a8(a9, a1, {Enabled = u24, Value = u21}, false)
                                return
                            end
                            a8(a9, a1, u21, false)
                        end)
                        task.wait(0.05)
                    end
                    if u227 == u61 then
                        u227 = 0
                    end
                    u230 = nil
                end)
                return
            end
            if a1_2.KeyCode == Enum.KeyCode.DPadRight then
                u227 = 0
                if u230 and coroutine.running() ~= u230 then
                    task.cancel(u230)
                end
                u230 = nil
                u227 = 1
                u228 = "DPad"
                UpdateSlider(u21 + u16 * 1, true, true)
                if u219 then
                    task.cancel(u219)
                    u219 = nil
                end
                u219 = task.delay(0.35, function() -- Line: 218
                    -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval), u21 (upval)
                    u219 = nil
                    if u14 then
                        a8(a9, a1, {Enabled = u24, Value = u21}, false)
                        return
                    end
                    a8(a9, a1, u21, false)
                end)
                local spawn_2 = task.spawn
                local u95 = 1
                u230 = spawn_2(function() -- Line: 274
                    -- upvalues: u16 (upval), u18 (upval), u20 (upval), u24 (upval), u227 (upval), u95 (val)
                    -- upvalues: GuiService (upval), Slider (upval), Title (upval), IsDirectionHeld (upval)
                    -- upvalues: UpdateSlider (upval), u21 (upval), u219 (upval), u14 (upval), a8 (upval), a9 (upval)
                    -- upvalues: a1 (upval), u230 (upval)
                    local SelectedObject, v1
                    task.wait(0.35)
                    local v2 = math.max(u16, (u18 - u20) / 60)
                    while u24 do
                        if u227 ~= u95 then
                            break
                        end
                        SelectedObject = GuiService.SelectedObject
                        v1 = true
                        if SelectedObject ~= Slider then
                            v1 = SelectedObject == Title
                        end
                        if not v1 or not IsDirectionHeld(u95) then
                            break
                        end
                        UpdateSlider(u21 + u95 * v2, true, true)
                        if u219 then
                            task.cancel(u219)
                            u219 = nil
                        end
                        u219 = task.delay(0.35, function() -- Line: 218
                            -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval)
                            -- upvalues: u21 (upval)
                            u219 = nil
                            if u14 then
                                a8(a9, a1, {Enabled = u24, Value = u21}, false)
                                return
                            end
                            a8(a9, a1, u21, false)
                        end)
                        task.wait(0.05)
                    end
                    if u227 == u95 then
                        u227 = 0
                    end
                    u230 = nil
                end)
            end
            return
        end
    end), "Disconnect")
    u27:Add(UserInputService.InputChanged:Connect(function(a1_2) -- Line: 318
        -- upvalues: u229 (ref), u228 (ref), u227 (ref), u230 (ref), GuiService (upval), Slider (val), Title (val)
        -- upvalues: u24 (ref), u16 (val), UpdateSlider (val), u21 (ref), u219 (ref), u14 (val), a8 (val), a9 (val)
        -- upvalues: a1 (val), u18 (val), u20 (val), IsDirectionHeld (val)
        if a1_2.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end
        local Position = a1_2.Position
        local v1 = math.abs(Position.X)
        u229 = if not (math.abs(Position.Y) < v1) then 0 else Position.X
        local u20_2 = if not (0.5 <= (math.abs(u229))) then 0 else math.sign(u229)
        if u20_2 == 0 then
            if u228 == "Stick" and u227 ~= 0 then
                u227 = 0
                if u230 and coroutine.running() ~= u230 then
                    task.cancel(u230)
                end
                u230 = nil
            end
            return
        end
        local SelectedObject = GuiService.SelectedObject
        v1 = true
        if SelectedObject ~= Slider then
            v1 = SelectedObject == Title
        end
        if v1 and u24 and not Title:IsFocused() then
            if u227 ~= u20_2 or u228 ~= "Stick" then
                u227 = 0
                if u230 and coroutine.running() ~= u230 then
                    task.cancel(u230)
                end
                u230 = nil
                u227 = u20_2
                u228 = "Stick"
                UpdateSlider(u21 + u20_2 * u16, true, true)
                if u219 then
                    task.cancel(u219)
                    u219 = nil
                end
                u219 = task.delay(0.35, function() -- Line: 218
                    -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval), u21 (upval)
                    u219 = nil
                    if u14 then
                        a8(a9, a1, {Enabled = u24, Value = u21}, false)
                        return
                    end
                    a8(a9, a1, u21, false)
                end)
                u230 = task.spawn(function() -- Line: 274
                    -- upvalues: u16 (upval), u18 (upval), u20 (upval), u24 (upval), u227 (upval), u20_2 (val)
                    -- upvalues: GuiService (upval), Slider (upval), Title (upval), IsDirectionHeld (upval)
                    -- upvalues: UpdateSlider (upval), u21 (upval), u219 (upval), u14 (upval), a8 (upval), a9 (upval)
                    -- upvalues: a1 (upval), u230 (upval)
                    local SelectedObject, v1
                    task.wait(0.35)
                    local v2 = math.max(u16, (u18 - u20) / 60)
                    while u24 do
                        if u227 ~= u20_2 then
                            break
                        end
                        SelectedObject = GuiService.SelectedObject
                        v1 = true
                        if SelectedObject ~= Slider then
                            v1 = SelectedObject == Title
                        end
                        if not v1 or not IsDirectionHeld(u20_2) then
                            break
                        end
                        UpdateSlider(u21 + u20_2 * v2, true, true)
                        if u219 then
                            task.cancel(u219)
                            u219 = nil
                        end
                        u219 = task.delay(0.35, function() -- Line: 218
                            -- upvalues: u219 (upval), u14 (upval), a8 (upval), a9 (upval), a1 (upval), u24 (upval)
                            -- upvalues: u21 (upval)
                            u219 = nil
                            if u14 then
                                a8(a9, a1, {Enabled = u24, Value = u21}, false)
                                return
                            end
                            a8(a9, a1, u21, false)
                        end)
                        task.wait(0.05)
                    end
                    if u227 == u20_2 then
                        u227 = 0
                    end
                    u230 = nil
                end)
            end
            return
        end
    end), "Disconnect")
    u27:Add(UserInputService.InputEnded:Connect(function(a1) -- Line: 347 -- upvalues: u229 (ref), u228 (ref), u227 (ref), u230 (ref) -- types: a1: userdata
        if a1.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end
        u229 = 0
        if u228 == "Stick" and u227 ~= 0 then
            u227 = 0
            if u230 and coroutine.running() ~= u230 then
                task.cancel(u230)
            end
            u230 = nil
        end
    end), "Disconnect")
    if a5:FindFirstChild("Check") and u14 then
        a5.Check.ImageLabel.Visible = u24
        a5.Frame.TextBox.TextEditable = u24
        Button.Active = u24
        Slider.Active = u24
        local v4 = if not u24 then 0.5 else 0
        a5.Slider.Bar.BackgroundTransparency = v4
        v4 = if not u24 then 0.5 else 0
        a5.Slider.Button.ImageTransparency = v4
        v4 = if not u24 then 0.5 else 0
        a5.Frame.TextBox.TextTransparency = v4
        v4 = if not u24 then 0.5 else 0
        a5.Slider.ImageTransparency = v4
        u27:Add(a5.Check.MouseButton1Click:Connect(function() -- Line: 375
            -- upvalues: u24 (ref), a5 (val), Slider (val), Button (val), a8 (val), a9 (val), a1 (val), u21 (ref)
            u24 = not u24
            a5.Check.ImageLabel.Visible = u24
            Slider.Active = u24
            Button.Active = u24
            a5.Frame.TextBox.TextEditable = u24
            local v1 = if not u24 then 0.5 else 0
            a5.Slider.ImageTransparency = v1
            v1 = if not u24 then 0.5 else 0
            a5.Slider.Bar.BackgroundTransparency = v1
            v1 = if not u24 then 0.5 else 0
            a5.Slider.Button.ImageTransparency = v1
            v1 = if not u24 then 0.5 else 0
            a5.Frame.TextBox.TextTransparency = v1
            a8(a9, a1, {Enabled = u24, Value = u21}, false)
        end), "Disconnect")
    end
    a5.Parent = a3
    return function() -- Line: 396 -- upvalues: u22 (ref), u27 (val)
        u22 = false
        u27:Cleanup()
    end
end