-- ReplicatedStorage.GameClient.Gui.Misc.Gamepad
-- Script path: ReplicatedStorage.GameClient.Gui.Misc.Gamepad
-- Decompile time: 39.59 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local GamepadService = game:GetService("GamepadService");
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
local LocalPlayer = Players.LocalPlayer;
local u16 = nil;
local u17 = nil;
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = {};
local u23 = setmetatable({}, {
    __mode = "k"
});
local u24 = setmetatable({}, {
    __mode = "k"
});
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = false;
local u31 = 0;
local u32 = false;
local u33 = false;
local u34 = nil;
local u35 = nil;
local u36 = 0;
local u37 = 0;
local u38 = nil;
local u39 = false;
local u40 = false;
local u41 = false;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local Color3_fromRGB_ret = Color3.fromRGB(131, 216, 255);
local Color3_new_ret = Color3.new(1, 1, 1);
local u47 = {
    {
        Name = "Select",
        Text = "SELECT",
        Keys = { Enum.KeyCode.ButtonA }
    },
    {
        Name = "Back",
        Text = "BACK",
        Keys = { Enum.KeyCode.ButtonB }
    },
    {
        Name = "Pointer",
        Text = "MOVE",
        Keys = { Enum.KeyCode.Thumbstick1 },

        When = function() -- Line: 52, Name: When
            -- upvalues: u41 (ref)
            return u41;
        end
    },
    {
        Name = "Move",
        Text = "MOVE",
        Root = "MainMenu",
        Section = "Loadout",
        Keys = { Enum.KeyCode.ButtonX }
    },
    {
        Name = "Remove",
        Text = "REMOVE",
        Root = "MainMenu",
        Keys = { Enum.KeyCode.ButtonX },

        When = function() -- Line: 56, Name: When
            -- upvalues: u5 (ref), u41 (ref), u44 (ref), GuiService (copy)
            return u5.Binds[u41 and u44 or GuiService.SelectedObject] ~= nil;
        end
    },
    {
        Name = "Menu",
        Text = "MENU",
        Root = "MainMenu",
        Keys = { Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1 }
    },
    {
        Name = "Tabs",
        Text = "TABS",
        Root = "MainMenu",
        Keys = { Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 }
    },
    {
        Name = "Scroll",
        Text = "SCROLL",
        Root = "MainMenu",
        Keys = { Enum.KeyCode.Thumbstick2 }
    },
    {
        Name = "Hue",
        Text = "HUE",
        Root = "ColorPicker",
        Keys = { Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 }
    },
    {
        Name = "Cursor",
        Text = "MOVE",
        Root = "ColorPicker",
        Keys = { Enum.KeyCode.Thumbstick1 },

        When = function() -- Line: 63, Name: When
            -- upvalues: u5 (ref), GuiService (copy)
            local v45 = u5.Pickers[u5.ActivePicker];
            local v46;

            if v45 == nil then
                v46 = false;
            else
                v46 = GuiService.SelectedObject == v45.Saturation;
            end;

            return v46;
        end
    },
    {
        Name = "Shade",
        Text = "SHADE",
        Root = "ColorPicker",
        Keys = { Enum.KeyCode.Thumbstick2 }
    },
    {
        Name = "Rotate",
        Text = "ROTATE",
        Root = "Inspect",
        Keys = { Enum.KeyCode.Thumbstick2 },

        When = function() -- Line: 69, Name: When
            -- upvalues: u12 (ref)
            return u12.StickerMode() == nil;
        end
    },
    {
        Name = "Zoom",
        Text = "ZOOM",
        Root = "Inspect",
        Keys = { Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 },

        When = function() -- Line: 72, Name: When
            -- upvalues: u12 (ref)
            return u12.StickerMode() == nil;
        end
    },
    {
        Name = "StickerMove",
        Text = "MOVE",
        Root = "Inspect",
        Keys = { Enum.KeyCode.Thumbstick2 },

        When = function() -- Line: 75, Name: When
            -- upvalues: u12 (ref)
            return u12.StickerMode() == "Apply";
        end
    },
    {
        Name = "StickerRotate",
        Text = "ROTATE",
        Root = "Inspect",
        Keys = { Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 },

        When = function() -- Line: 78, Name: When
            -- upvalues: u12 (ref)
            return u12.StickerMode() == "Apply";
        end
    },
    {
        Name = "StickerZoom",
        Text = "ZOOM",
        Root = "Inspect",
        Keys = { Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown },

        When = function() -- Line: 81, Name: When
            -- upvalues: u12 (ref)
            return u12.StickerMode() == "Apply";
        end
    },
    {
        Name = "Browse",
        Text = "BROWSE",
        Root = "Inspect",
        Keys = { Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1 },

        When = function() -- Line: 84, Name: When
            -- upvalues: u12 (ref)
            return u12.CanBrowse();
        end
    },
    {
        Name = "Cancel",
        Text = "CANCEL",
        Capture = true,
        Keys = { Enum.KeyCode.Thumbstick1 }
    },
    {
        Name = "Players",
        Text = "SELECT",
        Free = true,
        Keys = { Enum.KeyCode.ButtonL2 },

        When = function() -- Line: 88, Name: When
            -- upvalues: u2 (ref)
            return u2.Handler.HUD.Visible and u2.Handler.HUD.Scoreboard.Visible;
        end
    }
};
local u48 = {
    [Enum.KeyCode.DPadUp] = "NextSelectionUp",
    [Enum.KeyCode.DPadDown] = "NextSelectionDown",
    [Enum.KeyCode.DPadLeft] = "NextSelectionLeft",
    [Enum.KeyCode.DPadRight] = "NextSelectionRight"
};
local TweenInfo_new_ret = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

local function Gamepad() -- Line: 106
    -- upvalues: u33 (ref), u4 (ref)
    return u33 or u4() == "Console";
end;

local function Find(p49: string, p50: userdata?) -- Line: 110
    -- upvalues: u2 (ref)
    local v51 = (p50 or u2.Handler):FindFirstChild(p49);

    if not (v51 and (v51.Visible and v51)) then
        v51 = nil;
    end;

    return v51;
end;

local function Shown(p52: userdata) -- Line: 116
    -- upvalues: u2 (ref)
    while p52 and p52 ~= u2.Handler do
        if p52:IsA("GuiObject") and not p52.Visible then
            return false;
        end;

        p52 = p52.Parent;
    end;

    return p52 == u2.Handler;
end;

local function Classify(p53: userdata) -- Line: 130
    if p53:IsA("GuiButton") or p53:IsA("TextBox") then
        p53.Selectable = not p53:GetAttribute("NoSelect");

        return;
    end;

    if p53:IsA("GuiObject") then
        p53.Selectable = p53:GetAttribute("Select") == true;
    end;
end;

local function Stick(p54) -- Line: 138
    -- upvalues: u34 (ref), UserInputService (copy)
    if u34 then
        return u34[p54] or Vector3.new(0, 0, 0);
    end;

    for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
        if v.KeyCode == p54 then
            return v.Position;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

local function Down(p55) -- Line: 152
    -- upvalues: u34 (ref), UserInputService (copy)
    if u34 then
        return u34[p55] == true;
    end;

    return UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, p55);
end;

local function Pointed(p56) -- Line: 160
    -- upvalues: UserInputService (copy), GuiService (copy), LocalPlayer (copy)
    local v57 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset();

    for _, v in LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(v57.X, v57.Y) do
        if p56[v] then
            return v;
        end;
    end;

    return nil;
end;

local function Point(p58: boolean, p59: userdata?) -- Line: 172
    -- upvalues: GamepadService (copy), u41 (ref)
    if p58 and not GamepadService.GamepadCursorEnabled then
        GamepadService:EnableGamepadCursor(p59);
    elseif not p58 and (u41 and GamepadService.GamepadCursorEnabled) then
        GamepadService:DisableGamepadCursor();
    end;

    u41 = p58;
end;

local function Remember() -- Line: 182
    -- upvalues: UserInputService (copy), GuiService (copy), u2 (ref), u43 (ref)
    local v60 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset() - u2.Handler.AbsolutePosition;
    u43.Position = UDim2.fromOffset(v60.X, v60.Y);
end;

local function Select(p61: userdata?) -- Line: 188
    -- upvalues: GuiService (copy), u27 (ref)
    if not p61 then
        return;
    end;

    GuiService:Select(p61);
    u27 = GuiService.SelectedObject;
end;

local function Focus(p62: userdata?) -- Line: 197
    -- upvalues: Shown (copy), GuiService (copy), u27 (ref)
    if p62 and (p62.Selectable and Shown(p62)) then
        GuiService.SelectedObject = p62;
        u27 = p62;

        return;
    end;

    if not p62 then
        return;
    end;

    GuiService:Select(p62);
    u27 = GuiService.SelectedObject;
end;

local function SectionTabs() -- Line: 207
    -- upvalues: u8 (ref), u7 (ref)
    local CurrentTab = u8.GetCurrentTab();

    if CurrentTab then
        CurrentTab = u7.Find(CurrentTab);
    end;

    return CurrentTab;
end;

local function Enter() -- Line: 213
    -- upvalues: u40 (ref), u8 (ref), u7 (ref), GuiService (copy), u27 (ref), Shown (copy)
    if u40 then
        return;
    end;

    local CurrentTab = u8.GetCurrentTab();

    if CurrentTab then
        CurrentTab = u7.Find(CurrentTab);
    end;

    local CurrentTab2 = u8.GetCurrentTab();

    if CurrentTab then
        CurrentTab2 = CurrentTab.CurrentTab and CurrentTab.CurrentTab.Name == "PageUnder" and CurrentTab.CurrentTabUnder or (CurrentTab.CurrentTab or CurrentTab.HolderUI);
    end;

    if CurrentTab2 then
        GuiService:Select(CurrentTab2);
        u27 = GuiService.SelectedObject;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if CurrentTab and not (SelectedObject and (SelectedObject:IsDescendantOf(CurrentTab2) and Shown(SelectedObject))) then
        local ActiveButton = CurrentTab.ActiveButton;

        if ActiveButton and (ActiveButton.Selectable and Shown(ActiveButton)) then
            GuiService.SelectedObject = ActiveButton;
            u27 = ActiveButton;

            return;
        end;

        if not ActiveButton then
            return;
        end;

        GuiService:Select(ActiveButton);
        u27 = GuiService.SelectedObject;
    end;
end;

local function Resolve() -- Line: 234
    -- upvalues: u18 (ref), Shown (copy)
    for _, v in u18 do
        local v63 = v.Get();

        if v63 and Shown(v63) then
            return v, v63;
        end;
    end;

    return nil, nil;
end;

local function Trap(p64: userdata) -- Line: 246
    -- upvalues: u20 (copy)
    if u20[p64] then
        return;
    end;

    u20[p64] = true;
    p64.SelectionGroup = true;
    p64.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
    p64.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
    p64.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
    p64.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
end;

local function Choose(p65: any, p66: userdata) -- Line: 260
    -- upvalues: u19 (copy), Shown (copy), GuiService (copy), u27 (ref), Enter (copy)
    local v67 = u19[p65.Name];

    if v67 and (v67:IsDescendantOf(p66) and (v67.Selectable and Shown(v67))) then
        GuiService.SelectedObject = v67;
        u27 = v67;

        return;
    end;

    if p65.Focus then
        local v68 = p65.Focus();

        if v68 and (v68.Selectable and Shown(v68)) then
            GuiService.SelectedObject = v68;
            u27 = v68;
        elseif v68 then
            GuiService:Select(v68);
            u27 = GuiService.SelectedObject;
        end;
    elseif p65.Name == "MainMenu" then
        Enter();
    end;

    local SelectedObject = GuiService.SelectedObject;

    if not (SelectedObject and (SelectedObject:IsDescendantOf(p66) and Shown(SelectedObject))) then
        if not p66 then
            return;
        end;

        GuiService:Select(p66);
        u27 = GuiService.SelectedObject;
    end;
end;

local function Redirect(p69: userdata, p70: userdata) -- Line: 282
    -- upvalues: u7 (ref), u24 (copy), Shown (copy), GuiService (copy), u27 (ref)
    local v71, v72 = u7.Locate(p69);
    local v73, v74, v75 = u7.Locate(p70);

    if not v73 or v71 ~= v73 then
        return;
    end;

    local v76 = nil;

    if v74 and v72 ~= v74 then
        if v72 then
            v76 = v75;
        else
            u24[v73] = p69;
            v76 = v75;
        end;
    elseif v72 and not v74 then
        v76 = u24[v73];
    end;

    if v76 and (v76 ~= p70 and (v76.Selectable and Shown(v76))) and v76:IsDescendantOf(v74 or v73.Hold) then
        GuiService.SelectedObject = v76;
        u27 = v76;
    end;
end;

local function ShowHints(p77: boolean) -- Line: 308
    -- upvalues: u32 (ref), TweenService (copy), u16 (ref), TweenInfo_new_ret (copy)
    if u32 == p77 then
        return;
    end;

    u32 = p77;
    TweenService:Create(u16, TweenInfo_new_ret, {
        GroupTransparency = p77 and 0 or 1
    }):Play();
end;

local function DrawHints() -- Line: 318
    -- upvalues: u8 (ref), u7 (ref), u47 (copy), u25 (ref), u5 (ref), u21 (copy)
    local CurrentTab = u8.GetCurrentTab();

    if CurrentTab then
        CurrentTab = u7.Find(CurrentTab);
    end;

    local CurrentTab2 = u8.GetCurrentTab();
    local v78 = false;

    for _, v in u47 do
        local v79;

        if u25 then
            if u5.Capturing then
                v79 = v.Capture == true;
            else
                v79 = not (v.Free or v.Capture) and (not v.Root or u25.Name == v.Root);
            end;
        else
            v79 = v.Free == true;
        end;

        if v.Name == "Tabs" then
            if v79 then
                v79 = CurrentTab ~= nil;
            end;
        end;

        if v.Section then
            if v79 then
                if CurrentTab2 == nil then
                    v79 = false;
                else
                    v79 = CurrentTab2.Name == v.Section;
                end;
            end;
        end;

        if v.When then
            if v79 then
                v79 = v.When();
            end;
        end;

        u21[v.Name].Visible = v79;
        v78 = v78 or v79;
    end;

    return v78;
end;

local function RefreshIcons() -- Line: 353
    -- upvalues: u47 (copy), u21 (copy), UserInputService (copy)
    for _, v in u47 do
        local v80 = v;

        for i, v2 in v.Keys do
            u21[v80.Name][`Icon{i}`].Image = UserInputService:GetImageForKeyCode(v2);
        end;
    end;
end;

local function Scroll(p81: number) -- Line: 361
    -- upvalues: u34 (ref), UserInputService (copy), GuiService (copy), u25 (ref)
    local Thumbstick2 = Enum.KeyCode.Thumbstick2;
    local v82;

    if u34 then
        v82 = u34[Thumbstick2] or Vector3.new(0, 0, 0);
    else
        v82 = Vector3.new(0, 0, 0);

        for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
            if v.KeyCode == Thumbstick2 then
                v82 = v.Position;
                break;
            end;
        end;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if math.abs(v82.Y) < 0.3 or (not SelectedObject or u25.Name ~= "MainMenu") then
        return;
    end;

    local v83 = SelectedObject:FindFirstAncestorWhichIsA("ScrollingFrame");

    if not v83 then
        return;
    end;

    local math_max_ret = math.max(0, v83.AbsoluteCanvasSize.Y - v83.AbsoluteWindowSize.Y);
    v83.CanvasPosition = Vector2.new(v83.CanvasPosition.X, (math.clamp(v83.CanvasPosition.Y - v82.Y * p81 * v83.AbsoluteWindowSize.Y * 1.6, 0, math_max_ret)));
end;

local function Step(p84: any, p85: number) -- Line: 381
    -- upvalues: u5 (ref), u6 (ref), u38 (ref), u3 (ref)
    local v86 = u5.flags[p84.Name];
    local v87;

    if p84.Values then
        local v88 = (table.find(p84.Values, v86) or 1) + p85;
        local math_clamp_ret = math.clamp(v88, 1, #p84.Values);
        v87 = p84.Values[math_clamp_ret];
    else
        local v89 = p84.Percent and 0.1 or 1;
        local v90 = math.round((p84.Max - p84.Min) / 40 / v89) * v89;
        local v91 = (v86 + math.max(v89, v90) * p85) / v89;
        local v92 = math.round(v91) * v89;
        v87 = math.clamp(v92, p84.Min, p84.Max);
    end;

    if v87 == v86 then
        u6.Play("Edge");

        return;
    end;

    p84.Set(v87, true);
    u38 = p84;
    u3.Play("UI.mainmenu_rollover");
    u6.Play("Hover");
end;

local function Slide(p93: number) -- Line: 407
    -- upvalues: u5 (ref), GuiService (copy), u34 (ref), UserInputService (copy), u38 (ref), u36 (ref), u37 (ref), Step (copy)
    local v94 = u5.Sliders[GuiService.SelectedObject];
    local v95 = 0;

    if v94 then
        local Thumbstick1 = Enum.KeyCode.Thumbstick1;
        local v96;

        if u34 then
            v96 = u34[Thumbstick1] or Vector3.new(0, 0, 0);
        else
            v96 = Vector3.new(0, 0, 0);

            for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
                if v.KeyCode == Thumbstick1 then
                    v96 = v.Position;
                    break;
                end;
            end;
        end;

        local X = v96.X;
        local DPadRight = Enum.KeyCode.DPadRight;
        local v97;

        if u34 then
            v97 = u34[DPadRight] == true;
        else
            v97 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, DPadRight);
        end;

        if v97 or X > 0.6 then
            v95 = 1;
        else
            local DPadLeft = Enum.KeyCode.DPadLeft;
            local v98;

            if u34 then
                v98 = u34[DPadLeft] == true;
            else
                v98 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, DPadLeft);
            end;

            if v98 or X < -0.6 then
                v95 = -1;
            end;
        end;
    end;

    if v95 == 0 then
        if u38 then
            u38.Set(u5.flags[u38.Name]);
            u38 = nil;
        end;

        u36 = 0;
        u37 = 0;

        return;
    end;

    if v95 == u36 then
        u37 = u37 + p93;

        if u37 >= 0.07 then
            u37 = 0;
            Step(v94, v95);
        end;

        return;
    end;

    u36 = v95;
    u37 = -0.35;
    Step(v94, v95);
end;

local function Pick(p99: number) -- Line: 445
    -- upvalues: u5 (ref), GuiService (copy), u34 (ref), UserInputService (copy), u39 (ref)
    local v100 = u5.Pickers[u5.ActivePicker];
    local SelectedObject = GuiService.SelectedObject;
    local v101, v102, v103 = v100.Get();
    local Thumbstick1 = Enum.KeyCode.Thumbstick1;
    local v104;

    if u34 then
        v104 = u34[Thumbstick1] or Vector3.new(0, 0, 0);
    else
        v104 = Vector3.new(0, 0, 0);

        for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
            if v.KeyCode == Thumbstick1 then
                v104 = v.Position;
                break;
            end;
        end;
    end;

    local Thumbstick2 = Enum.KeyCode.Thumbstick2;
    local v105;

    if u34 then
        v105 = u34[Thumbstick2] or Vector3.new(0, 0, 0);
    else
        v105 = Vector3.new(0, 0, 0);

        for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
            if v.KeyCode == Thumbstick2 then
                v105 = v.Position;
                break;
            end;
        end;
    end;

    local ButtonR2 = Enum.KeyCode.ButtonR2;
    local v106;

    if u34 then
        v106 = u34[ButtonR2] or Vector3.new(0, 0, 0);
    else
        v106 = Vector3.new(0, 0, 0);

        for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
            if v.KeyCode == ButtonR2 then
                v106 = v.Position;
                break;
            end;
        end;
    end;

    local Z = v106.Z;
    local ButtonL2 = Enum.KeyCode.ButtonL2;
    local v107;

    if u34 then
        v107 = u34[ButtonL2] or Vector3.new(0, 0, 0);
    else
        v107 = Vector3.new(0, 0, 0);

        for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
            if v.KeyCode == ButtonL2 then
                v107 = v.Position;
                break;
            end;
        end;
    end;

    local v108 = Z - v107.Z;
    local DPadRight = Enum.KeyCode.DPadRight;
    local v109;

    if u34 then
        v109 = u34[DPadRight] == true;
    else
        v109 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, DPadRight);
    end;

    local DPadLeft = Enum.KeyCode.DPadLeft;
    local v110;

    if u34 then
        v110 = u34[DPadLeft] == true;
    else
        v110 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, DPadLeft);
    end;

    local v111 = (v109 and 1 or 0) - (v110 and 1 or 0);
    local DPadUp = Enum.KeyCode.DPadUp;
    local v112;

    if u34 then
        v112 = u34[DPadUp] == true;
    else
        v112 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, DPadUp);
    end;

    local DPadDown = Enum.KeyCode.DPadDown;
    local v113;

    if u34 then
        v113 = u34[DPadDown] == true;
    else
        v113 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, DPadDown);
    end;

    local v114 = (v112 and 1 or 0) - (v113 and 1 or 0);

    if math.abs(v104.X) > 0.3 then
        v111 = v104.X;
    end;

    if math.abs(v104.Y) > 0.3 then
        v114 = v104.Y;
    end;

    local v115 = p99 * 0.6;

    if math.abs(v108) > 0.1 then
        v101 = v101 + v108 * v115;
    end;

    if v105.Magnitude > 0.3 then
        v102 = v102 + v105.X * v115;
        v103 = v103 + v105.Y * v115;
    end;

    if SelectedObject == v100.Saturation then
        v102 = v102 + v111 * v115;
        v103 = v103 + v114 * v115;
    elseif SelectedObject == v100.Hue then
        v101 = v101 + v111 * v115;
    elseif SelectedObject == v100.Lightness then
        v103 = v103 - v111 * v115;
    end;

    local math_clamp_ret = math.clamp(v101, 0, 1);
    local math_clamp_ret2 = math.clamp(v102, 0, 1);
    local math_clamp_ret3 = math.clamp(v103, 0, 1);
    local v116, v117, v118 = v100.Get();

    if math_clamp_ret == v116 and (math_clamp_ret2 == v117 and math_clamp_ret3 == v118) then
        if u39 then
            u39 = false;
            v100.Commit();
        end;

        return;
    end;

    v100.Set(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
    u39 = true;
end;

local function Update(p119: number) -- Line: 498
    -- upvalues: GuiService (copy), u33 (ref), u4 (ref), u30 (ref), u2 (ref), u41 (ref), GamepadService (copy), u32 (ref), TweenService (copy), u16 (ref), TweenInfo_new_ret (copy), RefreshIcons (copy), u26 (ref), u31 (ref), Resolve (copy), u25 (ref), u42 (ref), DrawHints (copy), u20 (copy), u40 (ref), u5 (ref), u43 (ref), UserInputService (copy), u44 (ref), LocalPlayer (copy), Pick (copy), u29 (ref), u34 (ref), Shown (copy), u27 (ref), u19 (copy), Choose (copy), Scroll (copy), Slide (copy)
    if GuiService.MenuIsOpen then
        return;
    end;

    if not u33 and u4() ~= "Console" then
        if u30 and (GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(u2.Handler)) then
            GuiService.SelectedObject = nil;
        end;

        u30 = false;

        if u41 and GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor();
        end;

        u41 = false;

        if u32 == false then
            return;
        end;

        u32 = false;
        TweenService:Create(u16, TweenInfo_new_ret, {
            GroupTransparency = 1
        }):Play();

        return;
    end;

    if not u30 then
        u30 = true;
        RefreshIcons();
    end;

    local os_clock_ret = os.clock();

    if not u26 and os_clock_ret < u31 then
        return;
    end;

    u31 = os_clock_ret + 0.1;
    local v120, v121 = Resolve();
    u25 = v120;
    u26 = v121;

    if not v121 then
        if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(u2.Handler) then
            GuiService.SelectedObject = nil;
        end;

        u42 = nil;

        if u41 and GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor();
        end;

        u41 = false;
        local v122 = DrawHints();

        if u32 == v122 then
            return;
        end;

        u32 = v122;
        TweenService:Create(u16, TweenInfo_new_ret, {
            GroupTransparency = v122 and 0 or 1
        }):Play();

        return;
    end;

    if not u20[v121] then
        u20[v121] = true;
        v121.SelectionGroup = true;
        v121.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
        v121.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
        v121.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
        v121.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
    end;

    local v123 = DrawHints();

    if u32 ~= v123 then
        u32 = v123;
        TweenService:Create(u16, TweenInfo_new_ret, {
            GroupTransparency = v123 and 0 or 1
        }):Play();
    end;

    if not u40 then
        if u41 and GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor();
        end;

        u41 = false;

        if u5.Capturing then
            if GuiService.SelectedObject then
                u29 = GuiService.SelectedObject;
                GuiService.SelectedObject = nil;
            end;

            return;
        end;

        if u29 then
            local ButtonA = Enum.KeyCode.ButtonA;
            local v124;

            if u34 then
                v124 = u34[ButtonA] == true;
            else
                v124 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, ButtonA);
            end;

            if v124 then
                return;
            end;

            local v125 = u29;

            if v125 and (v125.Selectable and Shown(v125)) then
                GuiService.SelectedObject = v125;
                u27 = v125;
            elseif v125 then
                GuiService:Select(v125);
                u27 = GuiService.SelectedObject;
            end;

            u29 = nil;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject and (SelectedObject:IsDescendantOf(v121) and Shown(SelectedObject)) then
            u19[v120.Name] = SelectedObject;
        else
            Choose(v120, v121);
        end;

        Scroll(p119);
        Slide(p119);

        if v120.Name == "ColorPicker" then
            Pick(p119);
        end;

        return;
    end;

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(u2.Handler) then
        GuiService.SelectedObject = nil;
    end;

    local v126;

    if v120 == u42 then
        v126 = false;
    else
        v126 = v120.Focus and v120.Focus();
    end;

    u42 = v120;

    if u5.Capturing then
        if u41 and GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor();
        end;

        u41 = false;
    elseif v126 then
        GamepadService:EnableGamepadCursor(v126);
        u41 = true;
    else
        local v127 = u43;

        if not GamepadService.GamepadCursorEnabled then
            GamepadService:EnableGamepadCursor(v127);
        end;

        u41 = true;
    end;

    if u41 then
        local v128 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset() - u2.Handler.AbsolutePosition;
        u43.Position = UDim2.fromOffset(v128.X, v128.Y);
        local v129;

        if v120.Name == "MainMenu" then
            local Binds = u5.Binds;
            local v130 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
            v129 = nil;

            for _, v in LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(v130.X, v130.Y) do
                if Binds[v] then
                    v129 = v;
                    break;
                end;
            end;

            if not v129 then
                v129 = nil;
            end;
        else
            v129 = nil;
        end;

        u44 = v129;
    end;

    if v120.Name == "ColorPicker" then
        Pick(p119);
    end;
end;

local function CycleMenu(p131: number) -- Line: 613
    -- upvalues: u8 (ref), u6 (ref), Enter (copy)
    u8.CycleTab(p131);
    u6.Play("Tab");
    Enter();
end;

local function CycleTabs(p132: number) -- Line: 620
    -- upvalues: u8 (ref), u7 (ref), u6 (ref), u3 (ref), Enter (copy)
    local CurrentTab = u8.GetCurrentTab();

    if CurrentTab then
        CurrentTab = u7.Find(CurrentTab);
    end;

    if not (CurrentTab and CurrentTab:Cycle(p132)) then
        u6.Play("Edge");

        return;
    end;

    u3.Play("UI.submenu_click");
    u6.Play("Tab");
    Enter();
end;

local function CheckEdge(p133) -- Line: 634
    -- upvalues: GuiService (copy), u48 (copy), u6 (ref)
    local SelectedObject = GuiService.SelectedObject;

    if not SelectedObject or SelectedObject[u48[p133]] == SelectedObject then
        return;
    end;

    task.delay(0.05, function() -- Line: 641
        -- upvalues: GuiService (ref), SelectedObject (copy), u6 (ref)
        if GuiService.SelectedObject == SelectedObject then
            u6.Play("Edge");
        end;
    end);
end;

local function Confirm(p134: userdata) -- Line: 648
    -- upvalues: u25 (ref), u5 (ref), Shown (copy), GuiService (copy), u27 (ref), u23 (copy)
    local v135;

    if u25.Name == "ColorPicker" then
        v135 = u5.Pickers[u5.ActivePicker];
    else
        v135 = false;
    end;

    if not v135 or p134 ~= v135.Saturation then
        if u23[p134] then
            u23[p134]();
        end;

        return;
    end;

    local Hue = v135.Hue;

    if Hue and (Hue.Selectable and Shown(Hue)) then
        GuiService.SelectedObject = Hue;
        u27 = Hue;

        return;
    end;

    if not Hue then
        return;
    end;

    GuiService:Select(Hue);
    u27 = GuiService.SelectedObject;
end;

local function Handle(p136) -- Line: 661
    -- upvalues: u35 (ref), u22 (copy), GuiService (copy), u1 (copy), u6 (ref), u25 (ref), u5 (ref), Shown (copy), u27 (ref), u23 (copy), u8 (ref), Enter (copy), CycleTabs (copy), u48 (copy)
    if u35 and u35(p136) then
        return;
    end;

    local v137 = u22[p136];

    if v137 then
        for _, v in v137 do
            if v() then
                return;
            end;
        end;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if p136 == Enum.KeyCode.ButtonB then
        u1.Back();

        return;
    end;

    if p136 == Enum.KeyCode.ButtonA then
        if SelectedObject then
            u6.Play("Click");
            local v138;

            if u25.Name == "ColorPicker" then
                v138 = u5.Pickers[u5.ActivePicker];
            else
                v138 = false;
            end;

            if v138 and SelectedObject == v138.Saturation then
                local Hue = v138.Hue;

                if Hue and (Hue.Selectable and Shown(Hue)) then
                    GuiService.SelectedObject = Hue;
                    u27 = Hue;

                    return;
                end;

                if not Hue then
                    return;
                end;

                GuiService:Select(Hue);
                u27 = GuiService.SelectedObject;

                return;
            end;

            if u23[SelectedObject] then
                u23[SelectedObject]();
            end;
        end;
    else
        if u25.Name == "MainMenu" and (p136 == Enum.KeyCode.ButtonL1 or p136 == Enum.KeyCode.ButtonR1) then
            u8.CycleTab(p136 == Enum.KeyCode.ButtonR1 and 1 or -1);
            u6.Play("Tab");
            Enter();

            return;
        end;

        if u25.Name == "MainMenu" and (p136 == Enum.KeyCode.ButtonL2 or p136 == Enum.KeyCode.ButtonR2) then
            CycleTabs(p136 == Enum.KeyCode.ButtonR2 and 1 or -1);

            return;
        end;

        local u139 = u48[p136] and GuiService.SelectedObject;

        if u139 then
            if u139[u48[p136]] == u139 then
                return;
            end;

            task.delay(0.05, function() -- Line: 641
                -- upvalues: GuiService (ref), u139 (copy), u6 (ref)
                if GuiService.SelectedObject == u139 then
                    u6.Play("Edge");
                end;
            end);
        end;
    end;
end;

local function OnInput(p140: userdata) -- Line: 694
    -- upvalues: u25 (ref), u33 (ref), u4 (ref), GuiService (copy), u5 (ref), UserInputService (copy), Handle (copy)
    if not (u25 and ((u33 or u4() == "Console") and not (GuiService.MenuIsOpen or (u5.Capturing or UserInputService:GetFocusedTextBox())))) then
        return;
    end;

    Handle(p140.KeyCode);
end;

function u1.Navigating() -- Line: 704
    -- upvalues: GuiService (copy), u29 (ref), u41 (ref), u2 (ref)
    local SelectedObject = GuiService.SelectedObject;
    local v141;

    if u29 == nil then
        v141 = u41;

        if not v141 then
            if SelectedObject == nil then
                v141 = false;
            else
                v141 = SelectedObject:IsDescendantOf(u2.Handler);
            end;
        end;
    else
        v141 = true;
    end;

    return v141;
end;

function u1.Back() -- Line: 710
    -- upvalues: u25 (ref), u6 (ref)
    if not (u25 and u25.Back) then
        return;
    end;

    u6.Play("Back");
    u25.Back();
end;

function u1.Bind(p142: userdata, p143: any) -- Line: 719
    -- upvalues: u23 (copy)
    u23[p142] = p143;
end;

function u1.Action(p144, p145) -- Line: 723
    -- upvalues: u22 (copy)
    u22[p144] = u22[p144] or {};
    table.insert(u22[p144], p145);
end;

function u1.Override(p146) -- Line: 729
    -- upvalues: u35 (ref)
    u35 = p146;
end;

function u1.Force(p147: boolean) -- Line: 733
    -- upvalues: u33 (ref)
    u33 = p147;
end;

function u1.SetVirtual(p148) -- Line: 737
    -- upvalues: u34 (ref)
    u34 = p148;
end;

function u1.Press(p149) -- Line: 741
    -- upvalues: u25 (ref), Handle (copy)
    if u25 then
        Handle(p149);
    end;
end;

function u1.Step(p150: number) -- Line: 747
    -- upvalues: Update (copy)
    Update(p150);
end;

function u1.Active() -- Line: 751
    -- upvalues: u25 (ref)
    return u25 and u25.Name;
end;

function u1.Init(p151) -- Line: 757
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u6 (ref), u15 (ref)
    u2 = p151:GetModule("Gui");
    u3 = p151:GetModule("SoundManager");
    u4 = p151:GetModule("GetUserPlatform");
    u5 = p151:GetModule("Settings");
    u7 = u2.GetComponent("Tabs");
    u8 = u2.GetComponent("MainMenu");
    u9 = u2.GetComponent("Notify");
    u10 = u2.GetComponent("Inventory");
    u11 = u2.GetComponent("Gift");
    u12 = u2.GetComponent("Inspect");
    u13 = u2.GetComponent("CaseInspect");
    u14 = u2.GetComponent("Buymenu");
    u6 = u2.GetComponent("Haptics");
    u15 = u2.GetComponent("Score");
end;

function u1.Start(p152) -- Line: 774
    -- upvalues: u18 (ref), u2 (ref), u9 (ref), u5 (ref), u10 (ref), u11 (ref), GuiService (copy), Shown (copy), u27 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u8 (ref), u1 (copy), u41 (ref), u44 (ref), u6 (ref), u17 (ref), LocalPlayer (copy), TweenService (copy), u16 (ref), u43 (ref), u40 (ref), Classify (copy), u28 (ref), u33 (ref), u4 (ref), u3 (ref), Redirect (copy), UserInputService (copy), OnInput (copy), RefreshIcons (copy), RunService (copy), Update (copy)
    u18 = {
        {
            Name = "Notify",

            Get = function() -- Line: 778, Name: Get
                -- upvalues: u2 (ref)
                local Notify = u2.Handler:FindFirstChild("Notify");

                if not (Notify and (Notify.Visible and Notify)) then
                    Notify = nil;
                end;

                return Notify;
            end,

            Back = function() -- Line: 781, Name: Back
                -- upvalues: u9 (ref)
                u9.Close();
            end
        },
        {
            Name = "Dropdown",

            Get = function() -- Line: 787, Name: Get
                -- upvalues: u2 (ref)
                local Dropdown = u2.Handler:FindFirstChild("Dropdown");

                if not (Dropdown and (Dropdown:GetAttribute("Visible") and Dropdown)) then
                    Dropdown = nil;
                end;

                return Dropdown;
            end,

            Back = function() -- Line: 792, Name: Back
                -- upvalues: u5 (ref)
                u5.DropDeactive("GLOBAL");
            end
        },
        {
            Name = "RightClick",

            Get = function() -- Line: 798, Name: Get
                -- upvalues: u10 (ref), u2 (ref)
                return u10.IsBusy() and u2.Handler:FindFirstChild("InventoryRightClick") or nil;
            end,

            Back = function() -- Line: 801, Name: Back
                -- upvalues: u10 (ref)
                u10.CloseClick();
            end
        },
        {
            Name = "Gift",

            Get = function() -- Line: 807, Name: Get
                -- upvalues: u2 (ref)
                local gui = u2.Handler:FindFirstChild("gui");

                if not (gui and (gui.Visible and gui)) then
                    gui = nil;
                end;

                return gui;
            end,

            Back = function() -- Line: 810, Name: Back
                -- upvalues: u11 (ref)
                u11.Close();
            end
        },
        {
            Name = "ColorPicker",

            Get = function() -- Line: 816, Name: Get
                -- upvalues: u5 (ref)
                return u5.ActivePicker;
            end,

            Focus = function() -- Line: 819, Name: Focus
                -- upvalues: u5 (ref)
                return u5.Pickers[u5.ActivePicker].Saturation;
            end,

            Back = function() -- Line: 822, Name: Back
                -- upvalues: u5 (ref), GuiService (ref), Shown (ref), u27 (ref)
                local v153 = u5.Pickers[u5.ActivePicker];

                if GuiService.SelectedObject ~= v153.Saturation then
                    v153.Close();

                    return;
                end;

                local Hue = v153.Hue;

                if Hue and (Hue.Selectable and Shown(Hue)) then
                    GuiService.SelectedObject = Hue;
                    u27 = Hue;

                    return;
                end;

                if not Hue then
                    return;
                end;

                GuiService:Select(Hue);
                u27 = GuiService.SelectedObject;
            end
        },
        {
            Name = "Inspect",

            Get = function() -- Line: 835, Name: Get
                -- upvalues: u2 (ref)
                local Inspect = u2.Handler:FindFirstChild("Inspect");

                if not (Inspect and (Inspect.Visible and Inspect)) then
                    Inspect = nil;
                end;

                return Inspect;
            end,

            Back = function() -- Line: 838, Name: Back
                -- upvalues: u12 (ref)
                u12.Close();
            end
        },
        {
            Name = "CaseInspect",

            Get = function() -- Line: 844, Name: Get
                -- upvalues: u2 (ref), u13 (ref)
                local CaseInspect = u2.Handler:FindFirstChild("CaseInspect");

                if not (CaseInspect and (CaseInspect.Visible and CaseInspect)) then
                    CaseInspect = nil;
                end;

                if CaseInspect and u13.IsOpeningCase() then
                    return CaseInspect.MainInspect.SkipBar;
                end;

                if CaseInspect then
                    local RareItems = (CaseInspect or u2.Handler):FindFirstChild("RareItems");

                    if not (RareItems and (RareItems.Visible and RareItems)) then
                        RareItems = nil;
                    end;

                    CaseInspect = RareItems or CaseInspect;
                end;

                return CaseInspect;
            end,

            Focus = function() -- Line: 853, Name: Focus
                -- upvalues: u2 (ref), u13 (ref)
                local CaseInspect = u2.Handler.CaseInspect;

                if u13.IsOpeningCase() then
                    return CaseInspect.MainInspect.SkipBar.Skip;
                end;

                if CaseInspect.RareItems.Visible then
                    return CaseInspect.RareItems.Main.RightDown.Close;
                end;

                local RightDown = CaseInspect.MainInspect.DownBar.RightDown;

                for _, v in { "Unlock", "Credits", "Close" } do
                    if RightDown[v].Visible then
                        return RightDown[v];
                    end;
                end;
            end,

            Back = function() -- Line: 872, Name: Back
                -- upvalues: u13 (ref)
                u13.Back();
            end
        },
        {
            Name = "Buymenu",

            Get = function() -- Line: 878, Name: Get
                -- upvalues: u2 (ref)
                local Buymenu = (u2.Handler.HUD or u2.Handler):FindFirstChild("Buymenu");

                if not (Buymenu and (Buymenu.Visible and Buymenu)) then
                    Buymenu = nil;
                end;

                return Buymenu;
            end,

            Back = function() -- Line: 881, Name: Back
                -- upvalues: u14 (ref)
                u14.Visible();
            end
        },
        {
            Name = "Profile",

            Get = function() -- Line: 887, Name: Get
                -- upvalues: u15 (ref), u2 (ref)
                local v154;

                if u15.IsPinned() then
                    local Profile = (u2.Handler.HUD or u2.Handler):FindFirstChild("Profile");

                    if not (Profile and (Profile.Visible and Profile)) then
                        Profile = nil;
                    end;

                    v154 = Profile or nil;
                else
                    v154 = nil;
                end;

                return v154;
            end,

            Back = function() -- Line: 890, Name: Back
                -- upvalues: u15 (ref)
                u15.Back();
            end
        },
        {
            Name = "Scoreboard",

            Get = function() -- Line: 896, Name: Get
                -- upvalues: u15 (ref), u2 (ref)
                local v155;

                if u15.IsPinned() then
                    local Scoreboard = (u2.Handler.HUD or u2.Handler):FindFirstChild("Scoreboard");

                    if not (Scoreboard and (Scoreboard.Visible and Scoreboard)) then
                        Scoreboard = nil;
                    end;

                    v155 = Scoreboard or nil;
                else
                    v155 = nil;
                end;

                return v155;
            end,

            Back = function() -- Line: 899, Name: Back
                -- upvalues: u15 (ref)
                u15.Back();
            end
        },
        {
            Name = "MatchEnd",

            Get = function() -- Line: 905, Name: Get
                -- upvalues: u2 (ref)
                local MatchEnd = u2.Handler:FindFirstChild("MatchEnd");

                if not (MatchEnd and (MatchEnd.Visible and MatchEnd)) then
                    MatchEnd = nil;
                end;

                return MatchEnd;
            end
        },
        {
            Name = "MainMenu",

            Get = function() -- Line: 911, Name: Get
                -- upvalues: u2 (ref)
                local MainMenu = u2.Handler:FindFirstChild("MainMenu");

                if not (MainMenu and (MainMenu.Visible and MainMenu)) then
                    MainMenu = nil;
                end;

                return MainMenu;
            end,

            Back = function() -- Line: 914, Name: Back
                -- upvalues: u8 (ref)
                local CurrentTab = u8.GetCurrentTab();

                if CurrentTab and CurrentTab.Name ~= "Home" then
                    u8.OpenTab("Home");

                    return;
                end;

                u8.Visible();
            end
        }
    };
    u1.Action(Enum.KeyCode.ButtonX, function() -- Line: 927
        -- upvalues: u5 (ref), u41 (ref), u44 (ref), GuiService (ref), u6 (ref)
        local v156 = u5.Binds[u41 and u44 or GuiService.SelectedObject];

        if not v156 then
            return false;
        end;

        v156();
        u6.Play("Click");

        return true;
    end);
    GuiService.AutoSelectGuiEnabled = false;
    u17 = u1.selection();
    LocalPlayer.PlayerGui.SelectionImageObject = u17;
    TweenService:Create(u17.UIStroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.45
    }):Play();
    u16 = u1.hints();
    u16.Parent = u2.Handler;
    u43 = u1.pointer();
    u43.Parent = u2.Handler;
    u5:AddConnection("Controls", "Controller Binds", "Menu Navigation", function(p157) -- Line: 953
        -- upvalues: u40 (ref)
        u40 = p157 == "Cursor";
    end);

    for _, descendant in u2.Handler:GetDescendants() do
        Classify(descendant);
    end;

    u2.Handler.DescendantAdded:Connect(Classify);
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 963
        -- upvalues: GuiService (ref), u28 (ref), u27 (ref), u33 (ref), u4 (ref), u3 (ref), u6 (ref), Redirect (ref)
        local SelectedObject = GuiService.SelectedObject;
        local v158 = u28;
        u28 = SelectedObject;

        if not (SelectedObject and SelectedObject ~= u27 and (u33 or u4() == "Console")) then
            u27 = nil;

            return;
        end;

        u3.Play("UI.submenu_scroll");
        u6.Play("Hover");

        if v158 then
            Redirect(v158, SelectedObject);
        end;
    end);
    UserInputService.InputBegan:Connect(OnInput);
    UserInputService.GamepadConnected:Connect(RefreshIcons);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(RefreshIcons);
    RunService.Heartbeat:Connect(Update);
end;

function u1.selection() -- Line: 992
    -- upvalues: Color3_new_ret (copy), Color3_fromRGB_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "GamepadSelection";
    Frame.BackgroundColor3 = Color3_new_ret;
    Frame.BackgroundTransparency = 0.9;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromOffset(-3, -3);
    Frame.Size = UDim2.new(1, 6, 1, 6);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 6);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3_fromRGB_ret;
    UIStroke.Thickness = 2;
    UIStroke.Parent = Frame;

    return Frame;
end;

function u1.pointer() -- Line: 1016
    local Frame = Instance.new("Frame");
    Frame.Name = "GamepadPointer";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Interactable = false;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromOffset(2, 2);

    return Frame;
end;

function u1.hints() -- Line: 1028
    -- upvalues: u47 (copy), Color3_new_ret (copy), u21 (copy)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "GamepadHints";
    CanvasGroup.AnchorPoint = Vector2.new(1, 1);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Interactable = false;
    CanvasGroup.Position = UDim2.fromScale(0.96, 0.955);
    CanvasGroup.Size = UDim2.fromScale(0.6, 0.03);
    CanvasGroup.ZIndex = 1000;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.012, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = CanvasGroup;

    for i, v in u47 do
        local Frame = Instance.new("Frame");
        Frame.Name = v.Name;
        Frame.BackgroundTransparency = 1;
        Frame.LayoutOrder = i;
        Frame.Size = UDim2.fromScale(#v.Keys * 0.03 + 0.08, 1);
        local UIListLayout2 = Instance.new("UIListLayout");
        UIListLayout2.Name = "UIListLayout";
        UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout2.Padding = UDim.new(0, 4);
        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout2.Parent = Frame;
        local v159 = v;

        for i2 in v.Keys do
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = `Icon{i2}`;
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.LayoutOrder = i2;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.Size = UDim2.fromScale(1, 1);
            ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
            ImageLabel.Parent = Frame;
        end;

        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Label";
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel.LayoutOrder = #v159.Keys + 1;
        TextLabel.Size = UDim2.fromScale(0.6, 0.62);
        TextLabel.Text = v159.Text;
        TextLabel.TextColor3 = Color3_new_ret;
        TextLabel.TextScaled = true;
        TextLabel.TextTransparency = 0.15;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel.Parent = Frame;
        u21[v159.Name] = Frame;
        Frame.Parent = CanvasGroup;
    end;

    return CanvasGroup;
end;

return u1;