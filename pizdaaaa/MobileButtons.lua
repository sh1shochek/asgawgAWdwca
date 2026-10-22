-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Settings.MobileButtons
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Settings.MobileButtons
-- Decompile time: 30.53 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
game:GetService("HttpService");
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
game:GetService("GuiService");
local _ = workspace.CurrentCamera;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = true;
local u18 = 20;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local UDim2_new_ret = UDim2.new(0.5, 0, 0, 12);
local u29 = false;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local u36 = false;
local u37 = nil;
local Vector2_zero = Vector2.zero;
local UDim2_new_ret2 = UDim2.new();
local u38 = nil;
local u39 = nil;
local UDim2_new_ret3 = UDim2.new();
local u40 = 0.015;
local UDim2_new_ret4 = UDim2.new();
local u41 = 0.015;
local u42 = 0.5;
local u43 = {};
local u44 = {};
local u45 = 1;
local u46 = nil;

local function UpdateButtonPreviewVisual(p47, p48, p49, p50, p51, p52) -- Line: 61
    if not p47 then
        return;
    end;

    local v53;

    if p52 == true then
        v53 = true;
    elseif p51 then
        v53 = p51 >= 1;
    else
        v53 = p51;
    end;

    local v54 = v53 and 0.85 or (p51 or 0.5);

    if p47:FindFirstChild("Decal") then
        p47.Decal.ImageTransparency = v54;
    end;

    if p47:FindFirstChild("Title") then
        p47.Title.TextTransparency = v54;
    end;

    if p47:FindFirstChild("Disk") then
        p47.Disk.ImageTransparency = v54;
    end;

    if p47:FindFirstChild("Ring") then
        p47.Ring.ImageTransparency = v54;
    end;

    if p47:FindFirstChild("Stick") then
        p47.Stick.ImageTransparency = v54;
    end;

    if p47:FindFirstChild("Strip") then
        p47.Strip.GroupTransparency = v53 and 0.85 or math.clamp((v54 - 0.5) * 2, 0, 1);
    end;

    if p47:FindFirstChild("Fill") then
        p47.Fill.BackgroundTransparency = 0.8 + v54 * 0.2;
        p47.Fill.Stroke.Transparency = v54;
    end;

    if p47:FindFirstChild("Dynamic") then
        p47.Dynamic.Start.BackgroundTransparency = v54;
        p47.Dynamic.End.Stroke.Transparency = v54;
        p47.Dynamic.End.Center.BackgroundTransparency = v54;
    end;
end;

local function UpdateHideButtonState(p55: boolean) -- Line: 95
    -- upvalues: u9 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if not (u9 and u9:FindFirstChild("TextLabel")) then
        return;
    end;

    u9.TextLabel.Text = p55 and "SHOW" or "HIDE";
    TweenService:Create(u9, TweenInfo_new_ret, {
        BackgroundColor3 = p55 and Color3.fromRGB(50, 120, 180) or Color3.fromRGB(120, 50, 50)
    }):Play();
end;

local function UpdateGridToggleState(p56: boolean) -- Line: 101
    -- upvalues: u14 (ref), u15 (ref), TweenService (copy), TweenInfo_new_ret (copy), u16 (ref)
    if not (u14 and u14:FindFirstChild("TextLabel")) then
        return;
    end;

    u15.Text = p56 and "GRID: ON" or "GRID: OFF";
    TweenService:Create(u14, TweenInfo_new_ret, {
        BackgroundColor3 = p56 and Color3.fromRGB(50, 120, 180) or Color3.fromRGB(80, 80, 80)
    }):Play();

    if u16 then
        u16.Visible = p56;
    end;
end;

local function PanelCenter() -- Line: 110
    -- upvalues: u23 (ref), u19 (ref)
    return u23.AbsolutePosition - u19.AbsolutePosition + Vector2.new(u23.AbsoluteSize.X / 2, 0);
end;

local function PlacePanel(p57) -- Line: 114
    -- upvalues: u19 (ref), u23 (ref), UDim2_new_ret (ref)
    local AbsoluteSize = u19.AbsoluteSize;
    local AbsoluteSize2 = u23.AbsoluteSize;
    local v58 = AbsoluteSize2.X / 2 + 8;
    local UDim2_fromOffset = UDim2.fromOffset;
    local X = p57.X;
    local math_max_ret = math.max(v58, AbsoluteSize.X - v58);
    local math_clamp_ret = math.clamp(X, v58, math_max_ret);
    local Y = p57.Y;
    local math_max_ret2 = math.max(8, AbsoluteSize.Y - AbsoluteSize2.Y - 8);
    UDim2_new_ret = UDim2_fromOffset(math_clamp_ret, (math.clamp(Y, 8, math_max_ret2)));
    u23.Position = UDim2_new_ret;
end;

local function FitPanel() -- Line: 123
    -- upvalues: u19 (ref), u26 (ref), u23 (ref), UDim2_new_ret (ref)
    local AbsoluteSize = u19.AbsoluteSize;
    local math_min_ret = math.min((AbsoluteSize.X - 24) / 420, AbsoluteSize.Y / 420);
    u26.Scale = math.clamp(math_min_ret, 0.6, 1.25);
    local v59 = u23.AbsolutePosition - u19.AbsolutePosition + Vector2.new(u23.AbsoluteSize.X / 2, 0);
    local AbsoluteSize2 = u19.AbsoluteSize;
    local AbsoluteSize3 = u23.AbsoluteSize;
    local v60 = AbsoluteSize3.X / 2 + 8;
    local UDim2_fromOffset = UDim2.fromOffset;
    local X = v59.X;
    local math_max_ret = math.max(v60, AbsoluteSize2.X - v60);
    local math_clamp_ret = math.clamp(X, v60, math_max_ret);
    local Y = v59.Y;
    local math_max_ret2 = math.max(8, AbsoluteSize2.Y - AbsoluteSize3.Y - 8);
    UDim2_new_ret = UDim2_fromOffset(math_clamp_ret, (math.clamp(Y, 8, math_max_ret2)));
    u23.Position = UDim2_new_ret;
end;

function u1.Draw() -- Line: 132
    -- upvalues: u6 (ref), u8 (ref), u12 (ref), u18 (ref), UpdateHideButtonState (copy), UpdateGridToggleState (copy), u17 (ref), u27 (ref), u34 (ref), u30 (ref), u44 (copy), u1 (copy), UpdateButtonPreviewVisual (copy), u3 (ref), u38 (ref), u39 (ref), u45 (ref), u36 (ref), u37 (ref), Vector2_zero (ref), UDim2_new_ret2 (ref), u43 (copy), UDim2_new_ret3 (ref), u40 (ref), UDim2_new_ret4 (ref), u41 (ref), u42 (ref), u35 (ref), UserInputService (copy), u20 (ref), u2 (ref), RunService (copy), u24 (ref), u23 (ref), u19 (ref), TweenService (copy), u25 (ref), TweenInfo_new_ret (copy), UDim2_new_ret (ref), FitPanel (copy), u28 (ref), u29 (ref), TweenInfo_new_ret2 (copy), u5 (ref), u46 (ref), u14 (ref), u9 (ref), u21 (ref), u33 (ref), u22 (ref)
    local u61 = true;

    if u6 then
        u6.SetValue(15, true);
    end;

    if u8 then
        u8.SetValue(50, true);
    end;

    if u12 then
        u12.SetValue(u18, true);
    end;

    UpdateHideButtonState(false);
    UpdateGridToggleState(u17);
    u27.Text = "";
    local u62 = u34:GetPlayerSettings().Controls["Mobile Buttons"];
    local u63 = {};

    for i, v in pairs(u62) do
        if typeof(v) == "table" then
            u63[i] = {
                Position = { v.Position[1], v.Position[2] },
                Size = v.Size,
                Transparency = v.Transparency or 0.5,
                Hidden = v.Hidden == true
            };
        end;
    end;

    for i, v in u30.GetData().Controls["Mobile Buttons"] do
        if v.MobileControls then
            local v64 = u62[i];
            local Position = v64.Position;
            local Size = v64.Size;
            local v65 = v64.Transparency or 0.5;
            local v66 = v64.Hidden == true;
            u44[i] = v.Aspect or 1;
            local u67;

            if i == "Thumbstick" then
                u67 = u1.thumbstick(UDim2.fromScale(Position[1], Position[2]), Size);
                local v68 = u62["Thumbstick Style"] == "Dynamic";
                u67.Ring.Visible = not v68;
                u67.Disk.Visible = not v68;
                u67.Stick.Visible = not v68;
                u67.Dynamic.Visible = v68;
            elseif i == "Weapon Bar" then
                u67 = u1.weaponBar(UDim2.fromScale(Position[1], Position[2]), Size, v.Aspect);
            elseif v.Zone then
                u67 = u1.zone(UDim2.fromScale(Position[1], Position[2]), Size, v.Aspect);
            else
                u67 = u1.template(UDim2.fromScale(Position[1], Position[2]), Size, v.Decal, v.Title);
            end;

            UpdateButtonPreviewVisual(u67, i, u67.Position, Size, v65, v66);
            u3:Add(`{i}SButton_InputBegan`, u67.InputBegan:Connect(function(p69: userdata) -- Line: 191
                -- upvalues: u61 (ref), u38 (ref), u67 (ref), u39 (ref), i (copy), u45 (ref), u44 (ref), u27 (ref), u36 (ref), u37 (ref), Vector2_zero (ref), UDim2_new_ret2 (ref), u43 (ref), u62 (copy), u6 (ref), u8 (ref), UpdateHideButtonState (ref), UDim2_new_ret3 (ref), u40 (ref), UDim2_new_ret4 (ref), u41 (ref), u42 (ref)
                if p69.UserInputType ~= Enum.UserInputType.Touch and p69.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return;
                end;

                u61 = false;
                u38 = u67;
                u39 = i;
                u45 = u44[i];
                u27.Text = i:upper();
                u36 = true;
                u37 = p69;
                Vector2_zero = Vector2.new(p69.Position.X, p69.Position.Y);
                UDim2_new_ret2 = u67.Position;

                for _, v2 in pairs(u43) do
                    v2.SelectionStroke.Enabled = false;
                end;

                u38.SelectionStroke.Enabled = true;
                local v70 = u62[u39] or {};
                local v71 = v70.Size or u67.Size.Y.Scale;
                local v72 = v70.Transparency == nil and 0.5 or (v70.Transparency or 0.5);
                local v73 = v70.Hidden == true and true or v72 >= 1;

                if u6 then
                    u6.SetValue(v71 * 100, true);
                end;

                if u8 then
                    u8.SetValue(math.round(v72 * 100), true);
                end;

                UpdateHideButtonState(v73);
                UDim2_new_ret3 = u67.Position;
                u40 = u67.Size.Y.Scale;
                UDim2_new_ret4 = u67.Position;
                u41 = u67.Size.Y.Scale;
                u42 = v72;
            end));
            u43[i] = u67;
            u67.Visible = not u35.LayoutHidden(i, u62);
        end;
    end;

    u3:Add("Drag_InputChanged", UserInputService.InputChanged:Connect(function(p74: userdata) -- Line: 238
        -- upvalues: u36 (ref), u38 (ref), u37 (ref), u20 (ref), u2 (ref), Vector2_zero (ref), UDim2_new_ret2 (ref), u17 (ref), u18 (ref), UDim2_new_ret4 (ref)
        if not (u36 and u38) then
            return;
        end;

        local v75 = u37;

        if v75 then
            if u37.UserInputType == Enum.UserInputType.MouseButton1 then
                v75 = p74.UserInputType == Enum.UserInputType.MouseMovement;
            else
                v75 = false;
            end;
        end;

        if not (p74 == u37 or v75) then
            return;
        end;

        local v76 = u20 and u20.AbsoluteSize or u2 and u2.Handler and u2.Handler.AbsoluteSize;

        if not (v76 and (v76.X > 0 and v76.Y > 0)) then
            return;
        end;

        local v77 = Vector2.new(p74.Position.X, p74.Position.Y) - Vector2_zero;
        local math_clamp_ret = math.clamp(UDim2_new_ret2.X.Scale + v77.X / v76.X, 0, 1);
        local math_clamp_ret2 = math.clamp(UDim2_new_ret2.Y.Scale + v77.Y / v76.Y, 0, 1);

        if u17 and u18 > 0 then
            local v78 = math_clamp_ret2 * v76.Y;
            local v79 = math.round(math_clamp_ret * v76.X / u18) * u18 / v76.X;
            math_clamp_ret = math.clamp(v79, 0, 1);
            local v80 = math.round(v78 / u18) * u18 / v76.Y;
            math_clamp_ret2 = math.clamp(v80, 0, 1);
        end;

        UDim2_new_ret4 = UDim2.fromScale(math_clamp_ret, math_clamp_ret2);
    end));
    u3:Add("Drag_InputEnded", UserInputService.InputEnded:Connect(function(p81: userdata) -- Line: 271
        -- upvalues: u36 (ref), u37 (ref)
        if not u36 then
            return;
        end;

        local v82 = u37;

        if v82 then
            if u37.UserInputType == Enum.UserInputType.MouseButton1 then
                v82 = p81.UserInputType == Enum.UserInputType.MouseButton1;
            else
                v82 = false;
            end;
        end;

        if p81 == u37 or v82 then
            u36 = false;
            u37 = nil;
        end;
    end));
    u3:Add("PostSimulation", RunService.PostSimulation:Connect(function() -- Line: 285
        -- upvalues: u38 (ref), u39 (ref), UDim2_new_ret3 (ref), UDim2_new_ret4 (ref), u40 (ref), u41 (ref), u62 (copy), u45 (ref)
        if not (u38 and u39) then
            return;
        end;

        UDim2_new_ret3 = UDim2_new_ret3:Lerp(UDim2_new_ret4, 0.2);
        u40 = math.lerp(u40, u41, 0.2);
        u62[u39].Size = u41;
        u62[u39].Position = { UDim2_new_ret4.X.Scale, UDim2_new_ret4.Y.Scale };
        u38.Position = UDim2_new_ret3;
        u38.Size = UDim2.fromScale(u40 * u45, u40);
    end));
    local u83 = nil;
    local Vector2_zero2 = Vector2.zero;
    local Vector2_zero3 = Vector2.zero;
    u3:Add("Panel_InputBegan", u24.InputBegan:Connect(function(p84: userdata) -- Line: 304
        -- upvalues: u83 (ref), Vector2_zero2 (ref), Vector2_zero3 (ref), u23 (ref), u19 (ref), TweenService (ref), u25 (ref), TweenInfo_new_ret (ref)
        if u83 or p84.UserInputType ~= Enum.UserInputType.Touch and p84.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        u83 = p84;
        Vector2_zero2 = Vector2.new(p84.Position.X, p84.Position.Y);
        Vector2_zero3 = u23.AbsolutePosition - u19.AbsolutePosition + Vector2.new(u23.AbsoluteSize.X / 2, 0);
        TweenService:Create(u25, TweenInfo_new_ret, {
            Transparency = 0.55
        }):Play();
    end));
    u3:Add("Panel_InputChanged", UserInputService.InputChanged:Connect(function(p85: userdata) -- Line: 316
        -- upvalues: u83 (ref), Vector2_zero3 (ref), Vector2_zero2 (ref), u19 (ref), u23 (ref), UDim2_new_ret (ref)
        local v86;

        if u83 == nil or u83.UserInputType ~= Enum.UserInputType.MouseButton1 then
            v86 = false;
        else
            v86 = p85.UserInputType == Enum.UserInputType.MouseMovement;
        end;

        if p85 == u83 or v86 then
            local v87 = Vector2_zero3 + Vector2.new(p85.Position.X, p85.Position.Y) - Vector2_zero2;
            local AbsoluteSize = u19.AbsoluteSize;
            local AbsoluteSize2 = u23.AbsoluteSize;
            local v88 = AbsoluteSize2.X / 2 + 8;
            local UDim2_fromOffset = UDim2.fromOffset;
            local X = v87.X;
            local math_max_ret = math.max(v88, AbsoluteSize.X - v88);
            local math_clamp_ret = math.clamp(X, v88, math_max_ret);
            local Y = v87.Y;
            local math_max_ret2 = math.max(8, AbsoluteSize.Y - AbsoluteSize2.Y - 8);
            UDim2_new_ret = UDim2_fromOffset(math_clamp_ret, (math.clamp(Y, 8, math_max_ret2)));
            u23.Position = UDim2_new_ret;
        end;
    end));
    u3:Add("Panel_InputEnded", UserInputService.InputEnded:Connect(function(p89: userdata) -- Line: 325
        -- upvalues: u83 (ref), TweenService (ref), u25 (ref), TweenInfo_new_ret (ref)
        local v90;

        if u83 == nil or u83.UserInputType ~= Enum.UserInputType.MouseButton1 then
            v90 = false;
        else
            v90 = p89.UserInputType == Enum.UserInputType.MouseButton1;
        end;

        if p89 == u83 or v90 then
            u83 = nil;
            TweenService:Create(u25, TweenInfo_new_ret, {
                Transparency = 0.85
            }):Play();
        end;
    end));
    u3:Add("Panel_Resize", u19:GetPropertyChangedSignal("AbsoluteSize"):Connect(FitPanel));
    u3:Add("Collapse_MouseButton1Click", u28.MouseButton1Click:Connect(function() -- Line: 337
        -- upvalues: u29 (ref), u28 (ref), TweenService (ref), u23 (ref), TweenInfo_new_ret2 (ref), u19 (ref), UDim2_new_ret (ref)
        u29 = not u29;
        u28.TextLabel.Text = u29 and "+" or "-";
        local v91 = TweenService:Create(u23, TweenInfo_new_ret2, {
            Size = UDim2.fromOffset(420, u29 and 30 or 132)
        });
        v91.Completed:Once(function() -- Line: 342
            -- upvalues: u23 (ref), u19 (ref), UDim2_new_ret (ref)
            local v92 = u23.AbsolutePosition - u19.AbsolutePosition + Vector2.new(u23.AbsoluteSize.X / 2, 0);
            local AbsoluteSize = u19.AbsoluteSize;
            local AbsoluteSize2 = u23.AbsoluteSize;
            local v93 = AbsoluteSize2.X / 2 + 8;
            local UDim2_fromOffset = UDim2.fromOffset;
            local X = v92.X;
            local math_max_ret = math.max(v93, AbsoluteSize.X - v93);
            local math_clamp_ret = math.clamp(X, v93, math_max_ret);
            local Y = v92.Y;
            local math_max_ret2 = math.max(8, AbsoluteSize.Y - AbsoluteSize2.Y - 8);
            UDim2_new_ret = UDim2_fromOffset(math_clamp_ret, (math.clamp(Y, 8, math_max_ret2)));
            u23.Position = UDim2_new_ret;
        end);
        v91:Play();
    end));
    u3:Add("CloseButton_MouseEnter", u5.MouseEnter:Connect(function() -- Line: 348
        -- upvalues: TweenService (ref), u5 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u5, TweenInfo_new_ret, {
            BackgroundTransparency = 0.85
        }):Play();
    end));
    u3:Add("CloseButton_MouseLeave", u5.MouseLeave:Connect(function() -- Line: 352
        -- upvalues: TweenService (ref), u5 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u5, TweenInfo_new_ret, {
            BackgroundTransparency = 0.92
        }):Play();
    end));
    u3:Add("CloseButton_MouseButton1Click", u5.MouseButton1Click:Connect(function() -- Line: 356
        -- upvalues: u61 (ref), u46 (ref), u1 (ref)
        if u61 then
            u1.Visible(false, true);

            return;
        end;

        u46:Create("Exit without saving?", "Are you sure you want to discard unsaved changes?", function() -- Line: 359
            -- upvalues: u1 (ref)
            u1.Visible(false, true);
        end);
    end));
    u3:Add("GridToggle_MouseEnter", u14.MouseEnter:Connect(function() -- Line: 369
        -- upvalues: TweenService (ref), u14 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u14, TweenInfo_new_ret, {
            BackgroundTransparency = 0.2
        }):Play();
    end));
    u3:Add("GridToggle_MouseLeave", u14.MouseLeave:Connect(function() -- Line: 373
        -- upvalues: TweenService (ref), u14 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u14, TweenInfo_new_ret, {
            BackgroundTransparency = 0
        }):Play();
    end));
    u3:Add("GridToggle_MouseButton1Click", u14.MouseButton1Click:Connect(function() -- Line: 377
        -- upvalues: u17 (ref), UpdateGridToggleState (ref)
        u17 = not u17;
        UpdateGridToggleState(u17);
    end));
    u3:Add("HideButton_MouseEnter", u9.MouseEnter:Connect(function() -- Line: 382
        -- upvalues: TweenService (ref), u9 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u9, TweenInfo_new_ret, {
            BackgroundTransparency = 0.2
        }):Play();
    end));
    u3:Add("HideButton_MouseLeave", u9.MouseLeave:Connect(function() -- Line: 386
        -- upvalues: TweenService (ref), u9 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u9, TweenInfo_new_ret, {
            BackgroundTransparency = 0
        }):Play();
    end));
    u3:Add("HideButton_MouseButton1Click", u9.MouseButton1Click:Connect(function() -- Line: 390
        -- upvalues: u38 (ref), u39 (ref), u61 (ref), u62 (copy), u42 (ref), u8 (ref), UpdateHideButtonState (ref), UpdateButtonPreviewVisual (ref)
        if not (u38 and u39) then
            return;
        end;

        u61 = false;
        local v94 = u62[u39];

        if not v94 then
            return;
        end;

        local v95;

        if v94.Hidden == true then
            v95 = true;
        else
            v95 = v94.Transparency and v94.Transparency >= 1;
        end;

        local v96 = not v95;
        v94.Hidden = v96;

        if v96 then
            v94.Transparency = 1;
            u42 = 1;

            if u8 then
                u8.SetValue(100);
            end;
        else
            v94.Transparency = 0.5;
            u42 = 0.5;

            if u8 then
                u8.SetValue(50);
            end;
        end;

        UpdateHideButtonState(v96);
        UpdateButtonPreviewVisual(u38, u39, u38.Position, u38.Size.Y.Scale, v94.Transparency, v94.Hidden);
    end));
    u3:Add("SaveButton_MouseEnter", u21.MouseEnter:Connect(function() -- Line: 418
        -- upvalues: TweenService (ref), u21 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u21, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(18, 188, 103)
        }):Play();
    end));
    u3:Add("SaveButton_MouseLeave", u21.MouseLeave:Connect(function() -- Line: 422
        -- upvalues: TweenService (ref), u21 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u21, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(15, 158, 87)
        }):Play();
    end));
    u3:Add("SaveButton_MouseButton1Click", u21.MouseButton1Click:Connect(function() -- Line: 426
        -- upvalues: u62 (copy), u63 (copy), u34 (ref), u33 (ref), u43 (ref), u44 (ref), UpdateButtonPreviewVisual (ref), u61 (ref)
        local v97 = {};

        for i, v in pairs(u62) do
            if typeof(v) == "table" then
                local v98 = u63[i] or {};

                if (v98.Position == nil or v.Position[1] ~= v98.Position[1]) and true or v.Position[2] ~= v98.Position[2] or (v.Size ~= v98.Size or (v.Transparency ~= v98.Transparency or v.Hidden ~= v98.Hidden)) then
                    v97[i] = {
                        Position = { math.floor(v.Position[1] * 1000) / 1000, math.floor(v.Position[2] * 1000) / 1000 },
                        Size = math.floor(v.Size * 100) / 100,
                        Transparency = math.floor((v.Transparency or 0.5) * 100) / 100,
                        Hidden = v.Hidden == true
                    };
                    u63[i] = {
                        Position = { v.Position[1], v.Position[2] },
                        Size = v.Size,
                        Transparency = v.Transparency,
                        Hidden = v.Hidden
                    };
                    u34.FireConnection("Controls", "Mobile Buttons", i, v);
                end;
            end;
        end;

        u33.Gui.MobileControls.Fire(v97);

        for i, v in pairs(u43) do
            local v99 = u62[i];

            if v99 and v then
                v.Position = UDim2.fromScale(v99.Position[1], v99.Position[2]);
                v.Size = UDim2.fromScale(v99.Size * u44[i], v99.Size);
                UpdateButtonPreviewVisual(v, i, v.Position, v99.Size, v99.Transparency, v99.Hidden);
            end;
        end;

        u61 = true;
    end));
    u3:Add("ResetButton_MouseEnter", u22.MouseEnter:Connect(function() -- Line: 477
        -- upvalues: TweenService (ref), u22 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u22, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(185, 73, 36)
        }):Play();
    end));
    u3:Add("ResetButton_MouseLeave", u22.MouseLeave:Connect(function() -- Line: 481
        -- upvalues: TweenService (ref), u22 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u22, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(158, 62, 30)
        }):Play();
    end));
    u3:Add("ResetButton_MouseButton1Click", u22.MouseButton1Click:Connect(function() -- Line: 485
        -- upvalues: u46 (ref), u38 (ref), u39 (ref), u27 (ref), u30 (ref), u43 (ref), u44 (ref), UpdateButtonPreviewVisual (ref), u62 (copy), u34 (ref), u6 (ref), u8 (ref), UpdateHideButtonState (ref), u61 (ref)
        u46:Create("Changes Reset", "Are you sure you want to reset all changes?", function() -- Line: 486
            -- upvalues: u38 (ref), u39 (ref), u27 (ref), u30 (ref), u43 (ref), u44 (ref), UpdateButtonPreviewVisual (ref), u62 (ref), u34 (ref), u6 (ref), u8 (ref), UpdateHideButtonState (ref), u61 (ref)
            u38 = nil;
            u39 = nil;
            u27.Text = "";

            for i, v in u30.GetData().Controls["Mobile Buttons"] do
                if v.MobileControls then
                    local Default = v.Default;
                    local Position = Default.Position;
                    local Size = Default.Size;
                    local v100 = Default.Transparency or 0.5;
                    local v101 = Default.Hidden == true;
                    local v102 = u43[i];

                    if v102 then
                        v102.SelectionStroke.Enabled = false;
                        v102.Size = UDim2.fromScale(Size * u44[i], Size);
                        v102.Position = UDim2.fromScale(Position[1], Position[2]);
                        UpdateButtonPreviewVisual(v102, i, v102.Position, Size, v100, v101);
                    end;

                    u62[i] = {
                        Position = { Position[1], Position[2] },
                        Size = Size,
                        Transparency = v100,
                        Hidden = v101
                    };
                    u34.FireConnection("Controls", "Mobile Buttons", i, u62[i]);
                end;
            end;

            if u6 then
                u6.SetValue(15);
            end;

            if u8 then
                u8.SetValue(50);
            end;

            UpdateHideButtonState(false);
            u61 = false;
        end);
    end));
end;

function u1.GridGapUpdate(p103) -- Line: 529
    -- upvalues: u18 (ref), u16 (ref)
    local math_round_ret = math.round(p103);
    u18 = math.clamp(math_round_ret, 5, 50);

    if u16 then
        u16.TileSize = UDim2.fromOffset(u18, u18);
    end;
end;

function u1.SliderUpdate(p104) -- Line: 536
    -- upvalues: u41 (ref), u34 (ref), u39 (ref), u38 (ref), u45 (ref)
    u41 = p104 / 100;
    local v105 = u34:GetPlayerSettings().Controls["Mobile Buttons"];

    if u39 and (v105 and v105[u39]) then
        v105[u39].Size = u41;

        if u38 then
            u38.Size = UDim2.fromScale(u41 * u45, u41);
        end;
    end;
end;

function u1.TransSliderUpdate(p106) -- Line: 547
    -- upvalues: u42 (ref), u34 (ref), u39 (ref), UpdateHideButtonState (copy), u38 (ref), UpdateButtonPreviewVisual (copy)
    u42 = math.clamp(p106 / 100, 0, 1);
    local v107 = u34:GetPlayerSettings().Controls["Mobile Buttons"];

    if u39 and (v107 and v107[u39]) then
        v107[u39].Transparency = u42;

        if u42 >= 1 then
            v107[u39].Hidden = true;
            UpdateHideButtonState(true);
        elseif v107[u39].Hidden then
            v107[u39].Hidden = false;
            UpdateHideButtonState(false);
        end;

        if u38 then
            UpdateButtonPreviewVisual(u38, u39, u38.Position, u38.Size.Y.Scale, u42, v107[u39].Hidden);
        end;
    end;
end;

function u1.Clear() -- Line: 566
    -- upvalues: u36 (ref), u37 (ref), u38 (ref), u39 (ref), UDim2_new_ret3 (ref), u40 (ref), UDim2_new_ret4 (ref), u41 (ref), u43 (copy), u16 (ref), u3 (ref)
    u36 = false;
    u37 = nil;
    u38 = nil;
    u39 = nil;
    UDim2_new_ret3 = UDim2.new();
    u40 = 0.1;
    UDim2_new_ret4 = UDim2.new();
    u41 = 0.1;

    for _, v in pairs(u43) do
        v:Destroy();
    end;

    table.clear(u43);

    if u16 then
        u16.Visible = false;
    end;

    u3:Cleanup();
end;

function u1.Visible(p108, p109, p110) -- Line: 587
    -- upvalues: u19 (ref), u1 (copy), u2 (ref), TweenService (copy), Lighting (copy), u16 (ref), u17 (ref), u26 (ref), u23 (ref), UDim2_new_ret (ref), TweenInfo_new_ret2 (copy)
    if (p108 or not u19.Visible) and not p109 then
        u1.Draw();
        u2.Handler.Fade.Position = UDim2.fromScale(2, 0.5);
        TweenService:Create(u2.Handler.Fade, TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(-1, 0.5)
        }):Play();
        task.delay(0.15, function() -- Line: 596
            -- upvalues: Lighting (ref), u2 (ref), u19 (ref), u16 (ref), u17 (ref), u26 (ref), u23 (ref), UDim2_new_ret (ref), TweenService (ref), TweenInfo_new_ret2 (ref)
            if Lighting:FindFirstChild("2") then
                Lighting["2"].Enabled = false;
                Lighting["1"].Enabled = true;
            end;

            Lighting.UI_Blur.Size = 0;
            u2.Handler.MainMenu.Visible = false;
            u2.Handler.DOTS.Visible = false;
            u19.Visible = true;

            if u16 then
                u16.Visible = u17;
            end;

            local AbsoluteSize = u19.AbsoluteSize;
            local math_min_ret = math.min((AbsoluteSize.X - 24) / 420, AbsoluteSize.Y / 420);
            u26.Scale = math.clamp(math_min_ret, 0.6, 1.25);
            local v111 = u23.AbsolutePosition - u19.AbsolutePosition + Vector2.new(u23.AbsoluteSize.X / 2, 0);
            local AbsoluteSize2 = u19.AbsoluteSize;
            local AbsoluteSize3 = u23.AbsoluteSize;
            local v112 = AbsoluteSize3.X / 2 + 8;
            local UDim2_fromOffset = UDim2.fromOffset;
            local X = v111.X;
            local math_max_ret = math.max(v112, AbsoluteSize2.X - v112);
            local math_clamp_ret = math.clamp(X, v112, math_max_ret);
            local Y = v111.Y;
            local math_max_ret2 = math.max(8, AbsoluteSize2.Y - AbsoluteSize3.Y - 8);
            UDim2_new_ret = UDim2_fromOffset(math_clamp_ret, (math.clamp(Y, 8, math_max_ret2)));
            u23.Position = UDim2_new_ret;
            u23.Position = UDim2_new_ret + UDim2.fromOffset(0, -12);
            TweenService:Create(u23, TweenInfo_new_ret2, {
                Position = UDim2_new_ret
            }):Play();
        end);

        return;
    end;

    u1.Clear();

    if p110 then
        u19.Visible = false;

        if u16 then
            u16.Visible = false;
        end;

        return;
    end;

    u2.Handler.Fade.Position = UDim2.fromScale(2, 0.5);
    TweenService:Create(u2.Handler.Fade, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(-1, 0.5)
    }):Play();
    task.delay(0.15, function() -- Line: 622
        -- upvalues: Lighting (ref), u2 (ref), u19 (ref), u16 (ref)
        if Lighting:FindFirstChild("2") then
            Lighting["2"].Enabled = true;
            Lighting["1"].Enabled = false;
        end;

        Lighting.UI_Blur.Size = 72;
        u2.Handler.MainMenu.Visible = true;
        u2.Handler.DOTS.Visible = true;
        u19.Visible = false;

        if u16 then
            u16.Visible = false;
        end;
    end);
end;

function u1.Init(p113) -- Line: 648
    -- upvalues: u2 (ref), u30 (ref), u31 (ref), u32 (ref), u33 (ref), u3 (ref)
    u2 = p113:GetModule("Gui");
    u30 = p113:GetModule("SettingsData");
    u31 = p113:GetModule("Enums");
    u32 = p113:GetModule("SoundManager");
    u33 = p113:GetModule("Network");
    u3 = p113:GetModule("Maid").new();
end;

function u1.Start(p114) -- Line: 659
    -- upvalues: u34 (ref), u46 (ref), u2 (ref), u35 (ref), u1 (copy)
    u34 = p114:GetModule("Settings");
    u46 = u2.GetComponent("Notify");
    u35 = u2.GetComponent("MobileControls");
    u1.new();
end;

function u1.pill(p115: string, p116: string, p117, p118) -- Line: 669
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p115;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = p117;
    TextButton.Size = p118;
    TextButton.Text = "";
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UIClose";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel.Text = p116;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Parent = TextButton;

    return TextButton;
end;

function u1.row(p119: string, p120: number, p121: number) -- Line: 697
    local Frame = Instance.new("Frame");
    Frame.Name = p119;
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p120;
    Frame.Size = UDim2.new(1, 0, 0, p121);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIList";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.Padding = UDim.new(0, 8);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;

    return Frame;
end;

function u1.cell(p122: string, p123: string, p124: number, p125) -- Line: 715
    local Frame = Instance.new("Frame");
    Frame.Name = p122;
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.95;
    Frame.LayoutOrder = p124;
    Frame.Size = p125;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UIClose";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.new(0, 8, 0.5, 0);
    TextLabel.Size = UDim2.new(0.26, 0, 0.6, 0);
    TextLabel.Text = p123;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Holder";
    Frame2.AnchorPoint = Vector2.new(1, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.new(1, -6, 0.5, 0);
    Frame2.Size = UDim2.new(0.74, -14, 0.8, 0);
    Frame2.Parent = Frame;

    return Frame, Frame2;
end;

function u1.slider(p126: string, p127: userdata, p128: number, p129: number, p130: number, p131: boolean, p132: any) -- Line: 752
    -- upvalues: u34 (ref)
    local v133, v134 = u34.NewSlider(p126, p127, p128, p128, p129, p130, p131, p132, 0, "Slider");
    v133.UIAspectRatioConstraint:Destroy();
    v133.AnchorPoint = Vector2.new(0.5, 0.5);
    v133.Position = UDim2.fromScale(0.5, 0.5);
    v133.Size = UDim2.fromScale(1, 1);
    v133.Line.Visible = false;
    v133.SlideText.Visible = false;
    v133.Scroll.AnchorPoint = Vector2.new(0, 0.5);
    v133.Scroll.Position = UDim2.fromScale(0, 0.5);
    v133.Scroll.Size = UDim2.fromScale(0.64, 0.8);
    v133.Value.AnchorPoint = Vector2.new(1, 0.5);
    v133.Value.Position = UDim2.fromScale(1, 0.5);
    v133.Value.Size = UDim2.fromScale(0.32, 0.8);

    return v133, v134;
end;

function u1.new() -- Line: 771
    -- upvalues: u19 (ref), u16 (ref), u18 (ref), u23 (ref), UDim2_new_ret (ref), u25 (ref), u26 (ref), u24 (ref), u27 (ref), u28 (ref), u1 (copy), u4 (ref), u6 (ref), u7 (ref), u8 (ref), u13 (ref), u11 (ref), u12 (ref), u14 (ref), u15 (ref), u9 (ref), u10 (ref), u22 (ref), u5 (ref), u21 (ref), u20 (ref), u2 (ref)
    u19 = Instance.new("Frame");
    u19.Name = "ButtonControls";
    u19.AnchorPoint = Vector2.new(0.5, 0.5);
    u19.BackgroundTransparency = 1;
    u19.ClipsDescendants = true;
    u19.Position = UDim2.fromScale(0.5, 0.5);
    u19.Size = UDim2.fromScale(1, 1);
    u19.Visible = false;
    u16 = Instance.new("ImageLabel");
    u16.Name = "GridCanvas";
    u16.BackgroundTransparency = 1;
    u16.Image = "rbxassetid://91991932054752";
    u16.ImageTransparency = 0.85;
    u16.ScaleType = Enum.ScaleType.Tile;
    u16.TileSize = UDim2.fromOffset(u18, u18);
    u16.Size = UDim2.fromScale(1, 1);
    u16.ZIndex = 1;
    u16.Visible = false;
    u16.Parent = u19;
    u23 = Instance.new("Frame");
    u23.Name = "EditorPanel";
    u23.Active = true;
    u23.AnchorPoint = Vector2.new(0.5, 0);
    u23.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    u23.BackgroundTransparency = 0.08;
    u23.ClipsDescendants = true;
    u23.Position = UDim2_new_ret;
    u23.Size = UDim2.fromOffset(420, 132);
    u23.ZIndex = 10;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 4);
    UICorner.Parent = u23;
    u25 = Instance.new("UIStroke");
    u25.Name = "UIStroke";
    u25.Color = Color3.new(1, 1, 1);
    u25.Transparency = 0.85;
    u25.Parent = u23;
    u26 = Instance.new("UIScale");
    u26.Name = "UIScale";
    u26.Parent = u23;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.new();
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = u23;
    u24 = Instance.new("Frame");
    u24.Name = "Header";
    u24.Active = true;
    u24.BackgroundTransparency = 1;
    u24.Size = UDim2.new(1, 0, 0, 30);
    local Frame = Instance.new("Frame");
    Frame.Name = "Grip";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.7;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(0.5, 0, 0, 5);
    Frame.Size = UDim2.fromOffset(36, 4);
    Frame.Parent = u24;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.new(0, 10, 0.5, 3);
    TextLabel.Size = UDim2.new(0.4, 0, 0, 15);
    TextLabel.Text = "MOBILE BUTTONS";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = u24;
    u27 = Instance.new("TextLabel");
    u27.Name = "Selected";
    u27.AnchorPoint = Vector2.new(1, 0.5);
    u27.BackgroundTransparency = 1;
    u27.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    u27.Position = UDim2.new(1, -40, 0.5, 3);
    u27.Size = UDim2.new(0.45, 0, 0, 14);
    u27.Text = "";
    u27.TextColor3 = Color3.fromRGB(222, 190, 62);
    u27.TextScaled = true;
    u27.TextXAlignment = Enum.TextXAlignment.Right;
    u27.Parent = u24;
    u28 = u1.pill("Collapse", "-", Color3.new(1, 1, 1), UDim2.fromOffset(24, 20));
    u28.AnchorPoint = Vector2.new(1, 0.5);
    u28.BackgroundTransparency = 0.92;
    u28.Position = UDim2.new(1, -8, 0.5, 3);
    u28.Parent = u24;
    u24.Parent = u23;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Body";
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromOffset(0, 30);
    Frame2.Size = UDim2.new(1, 0, 0, 102);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "Padding";
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 2);
    UIPadding.Parent = Frame2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIList";
    UIListLayout.Padding = UDim.new(0, 6);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame2;
    local v135 = u1.row("Sliders", 1, 26);
    local v136, v137 = u1.cell("SizeButtons", "SIZE", 1, UDim2.new(0.5, -4, 1, 0));
    local v139, v140 = u1.slider("Slider", v137, 15, 10, 40, false, function(p138) -- Line: 910
        -- upvalues: u1 (ref)
        u1.SliderUpdate(p138);
    end);
    u4 = v139;
    u6 = v140;
    v136.Parent = v135;
    local v141, v142 = u1.cell("TransButtons", "TRANS", 2, UDim2.new(0.5, -4, 1, 0));
    local v144, v145 = u1.slider("TransSlider", v142, 50, 0, 100, true, function(p143) -- Line: 916
        -- upvalues: u1 (ref)
        u1.TransSliderUpdate(p143);
    end);
    u7 = v144;
    u8 = v145;
    v141.Parent = v135;
    v135.Parent = Frame2;
    local v146 = u1.row("Grid", 2, 26);
    local v147, v148 = u1.cell("GapButtons", "GRID", 1, UDim2.new(0.5, -4, 1, 0));
    u13 = v147;
    local v150, v151 = u1.slider("GapSlider", v148, 20, 5, 50, false, function(p149) -- Line: 927
        -- upvalues: u1 (ref)
        u1.GridGapUpdate(p149);
    end);
    u11 = v150;
    u12 = v151;
    u13.Parent = v146;
    u14 = u1.pill("GridToggleButton", "GRID: ON", Color3.fromRGB(50, 120, 180), UDim2.new(0.25, -6, 1, 0));
    u14.LayoutOrder = 2;
    u15 = u14.TextLabel;
    u14.Parent = v146;
    u9 = u1.pill("HideButton", "HIDE", Color3.fromRGB(120, 50, 50), UDim2.new(0.25, -6, 1, 0));
    u9.LayoutOrder = 3;
    u10 = u9.TextLabel;
    u9.Parent = v146;
    v146.Parent = Frame2;
    local v152 = u1.row("Actions", 3, 30);
    u22 = u1.pill("ResetChanges", "RESET CHANGES", Color3.fromRGB(158, 62, 30), UDim2.new(0.3333333333333333, -5.333333333333333, 1, 0));
    u22.LayoutOrder = 1;
    u22.Parent = v152;
    u5 = u1.pill("CloseButton", "CLOSE", Color3.new(1, 1, 1), UDim2.new(0.3333333333333333, -5.333333333333333, 1, 0));
    u5.BackgroundTransparency = 0.92;
    u5.LayoutOrder = 2;
    u5.Parent = v152;
    u21 = u1.pill("SaveChanges", "APPLY CHANGES", Color3.fromRGB(15, 158, 87), UDim2.new(0.3333333333333333, -5.333333333333333, 1, 0));
    u21.LayoutOrder = 3;
    u21.Parent = v152;
    v152.Parent = Frame2;
    Frame2.Parent = u23;
    u23.Parent = u19;
    u20 = Instance.new("Frame");
    u20.Name = "ContextButtons";
    u20.BackgroundTransparency = 1;
    u20.Size = UDim2.fromScale(1, 1);
    u20.Parent = u19;
    u19.Parent = u2.Handler;
end;

function u1.template(p153, p154, p155, p156) -- Line: 975
    -- upvalues: u20 (ref)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Template";
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageRectOffset = Vector2.new(1, 146);
    ImageButton.ImageRectSize = Vector2.new(144, 144);
    ImageButton.Position = p153;
    ImageButton.Size = UDim2.fromScale(p154, p154);
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.ZIndex = 5;

    if p155 then
        local ImageButton2 = Instance.new("ImageButton");
        ImageButton2.Name = "Decal";
        ImageButton2.Active = false;
        ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageButton2.AutoButtonColor = false;
        ImageButton2.BackgroundTransparency = 1;
        ImageButton2.Image = p155;
        ImageButton2.ImageTransparency = 0.5;
        ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
        ImageButton2.Selectable = false;
        ImageButton2.Size = UDim2.fromScale(0.4, 0.4);
        ImageButton2.ZIndex = 3;
        ImageButton2.Parent = ImageButton;
    end;

    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Disk";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxasset://textures/ui/Input/Disk_padded.png";
    ImageButton2.ImageColor3 = Color3.new();
    ImageButton2.ImageTransparency = 0.5;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.Selectable = false;
    ImageButton2.Size = UDim2.fromScale(1, 1);
    ImageButton2.Parent = ImageButton;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Ring";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxasset://textures/ui/Input/Ring_padded.png";
    ImageButton3.ImageTransparency = 0.5;
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.Selectable = false;
    ImageButton3.Size = UDim2.fromScale(0.935, 0.935);
    ImageButton3.ZIndex = 2;
    ImageButton3.Parent = ImageButton;

    if p156 then
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Title";
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
        TextLabel.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel.Size = UDim2.fromScale(0.75, 0.5);
        TextLabel.Text = p156;
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        TextLabel.TextScaled = true;
        TextLabel.TextTransparency = 0.5;
        TextLabel.ZIndex = 3;
        TextLabel.Parent = ImageButton;
    end;

    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "SelectionStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(222, 190, 62);
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke.Parent = ImageButton;
    UIStroke.Enabled = false;
    ImageButton.Parent = u20;

    return ImageButton;
end;

function u1.zone(p157, p158, p159) -- Line: 1061
    -- upvalues: u20 (ref)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Zone";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = p157;
    ImageButton.Size = UDim2.fromScale(p158 * p159, p158);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.ZIndex = 1;
    local Frame = Instance.new("Frame");
    Frame.Name = "Fill";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.9;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = ImageButton;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.08, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "Stroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.6, 0.14);
    TextLabel.Text = "FIRE ZONE";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 3;
    TextLabel.Parent = ImageButton;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "SelectionStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.fromRGB(222, 190, 62);
    UIStroke2.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke2.Parent = ImageButton;
    UIStroke2.Enabled = false;
    ImageButton.Parent = u20;

    return ImageButton;
end;

function u1.weaponBar(p160, p161, p162) -- Line: 1116
    -- upvalues: u20 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "WeaponBar";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = p160;
    Frame.Size = UDim2.fromScale(p161 * p162, p161);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame.ZIndex = 5;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Strip";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingBottom = UDim.new(0, 2);
    UIPadding.PaddingLeft = UDim.new(0, 2);
    UIPadding.PaddingRight = UDim.new(0, 2);
    UIPadding.PaddingTop = UDim.new(0, 2);
    UIPadding.Parent = CanvasGroup;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.015, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = CanvasGroup;

    for i = 1, 5 do
        local Frame2 = Instance.new("Frame");
        Frame2.Name = tostring(i);
        Frame2.BackgroundColor3 = Color3.new();
        Frame2.BackgroundTransparency = i == 1 and 0.3 or 0.6;
        Frame2.LayoutOrder = i;
        Frame2.Size = UDim2.fromScale(0.185, 1);
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0.18, 0);
        UICorner.Parent = Frame2;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3.new(1, 1, 1);
        UIStroke.Transparency = i == 1 and 0.35 or 0.85;
        UIStroke.Parent = Frame2;
        Frame2.Parent = CanvasGroup;
        local _ = i;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.9, 0.36);
    TextLabel.Text = "WEAPON BAR";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 3;
    TextLabel.Parent = CanvasGroup;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "SelectionStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(222, 190, 62);
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke.Parent = Frame;
    UIStroke.Enabled = false;
    Frame.Parent = u20;

    return Frame;
end;

function u1.thumbstick(p163, p164) -- Line: 1194
    -- upvalues: u20 (ref)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ThumbstickFrame";
    ImageButton.Active = true;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = p163;
    ImageButton.Size = UDim2.fromScale(p164, p164);
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Ring";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxasset://textures/ui/Input/Ring_padded.png";
    ImageButton2.ImageTransparency = 0.5;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.Selectable = false;
    ImageButton2.Size = UDim2.fromScale(0.935, 0.935);
    ImageButton2.ZIndex = 2;
    ImageButton2.Parent = ImageButton;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Disk";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxasset://textures/ui/Input/Disk_padded.png";
    ImageButton3.ImageColor3 = Color3.new();
    ImageButton3.ImageTransparency = 0.5;
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.Selectable = false;
    ImageButton3.Size = UDim2.fromScale(1, 1);
    ImageButton3.Parent = ImageButton;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "Stick";
    ImageButton4.Active = false;
    ImageButton4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton4.AutoButtonColor = false;
    ImageButton4.BackgroundTransparency = 1;
    ImageButton4.Image = "rbxasset://textures/ui/Input/Ring_padded.png";
    ImageButton4.ImageTransparency = 0.5;
    ImageButton4.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton4.Selectable = false;
    ImageButton4.Size = UDim2.fromScale(0.5, 0.5);
    ImageButton4.ZIndex = 3;
    ImageButton4.Parent = ImageButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Dynamic";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Start";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(18, 18, 21);
    Frame2.BackgroundTransparency = 0.5;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "End";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.fromScale(0.365, 0.365);
    Frame3.ZIndex = 3;
    Frame3.Parent = Frame;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0.5, 0);
    UICorner2.Parent = Frame3;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "Stroke";
    UIStroke.Color = Color3.fromRGB(213, 215, 221);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Center";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(213, 215, 221);
    Frame4.BackgroundTransparency = 0.5;
    Frame4.Position = UDim2.fromScale(0.5, 0.5);
    Frame4.Size = UDim2.fromScale(0.74, 0.74);
    Frame4.ZIndex = 3;
    Frame4.Parent = Frame3;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0.5, 0);
    UICorner3.Parent = Frame4;
    Frame.Parent = ImageButton;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "SelectionStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.fromRGB(82, 112, 222);
    UIStroke2.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke2.Parent = ImageButton;
    UIStroke2.Enabled = false;
    ImageButton.Parent = u20;

    return ImageButton;
end;

return u1;