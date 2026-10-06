-- Decompiled with Potassium's decompiler.

local u1 = {};
local ContextActionService = game:GetService("ContextActionService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local u2 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
};
local u3 = {
    [Enum.UserInputType.Keyboard] = true,
    [Enum.UserInputType.MouseMovement] = true,
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true,
    [Enum.UserInputType.MouseButton3] = true,
    [Enum.UserInputType.MouseWheel] = true,
    [Enum.UserInputType.Touch] = true
};
u1.NO_FALLBACK_ATTRIBUTE = "GamepadNavigationNoFallback";
local u4 = Enum.ContextActionPriority.High.Value + 1000;
local Thumbstick2 = Enum.KeyCode.Thumbstick2;
local u5 = {
    [Enum.KeyCode.DPadUp] = Vector2.new(0, -1),
    [Enum.KeyCode.DPadDown] = Vector2.new(0, 1),
    [Enum.KeyCode.DPadLeft] = Vector2.new(-1, 0),
    [Enum.KeyCode.DPadRight] = Vector2.new(1, 0)
};
local u6 = false;
local u7 = false;
local u8 = false;
local u9 = nil;
local u10 = 0;
local u11 = 0;
local Vector2_zero = Vector2.zero;
local u12 = nil;
local u13 = "Y";
local Vector2_zero2 = Vector2.zero;
local u14 = 0;
local u15 = nil;
local u16 = 0;

local function isGamepadInput(p17) -- Line: 128
    -- upvalues: u2 (copy)
    return u2[p17] == true;
end;

local function isEffectivelyVisible(p18: userdata) -- Line: 134
    -- upvalues: LocalPlayer (copy)
    while p18 do
        if p18:IsA("GuiObject") and not p18.Visible then
            return false;
        end;

        if p18:IsA("LayerCollector") then
            local v19 = p18.Enabled and p18:IsDescendantOf(LocalPlayer);

            return v19;
        end;

        p18 = p18.Parent;
    end;

    return false;
end;

local function isUsable(p20: userdata?) -- Line: 149
    -- upvalues: isEffectivelyVisible (copy)
    if not (p20 and (p20.Parent and p20:IsA("GuiObject"))) then
        return false;
    end;

    if not (p20.Selectable and p20.Interactable) then
        return false;
    end;

    local AbsoluteSize = p20.AbsoluteSize;
    local v21;

    if AbsoluteSize.X > 1 and AbsoluteSize.Y > 1 then
        v21 = isEffectivelyVisible(p20);
    else
        v21 = false;
    end;

    return v21;
end;

local function isWithin(p22: userdata?, p23: userdata) -- Line: 162
    local v24;

    if p22 == nil then
        v24 = false;
    else
        v24 = p22 == p23 and true or p22:IsDescendantOf(p23);
    end;

    return v24;
end;

local function getNavigatedSelection() -- Line: 169
    -- upvalues: GuiService (copy), isUsable (copy)
    local SelectedObject = GuiService.SelectedObject;

    if isUsable(SelectedObject) then
        return SelectedObject;
    end;

    return nil;
end;

local function isMenuUp() -- Line: 176
    -- upvalues: MenuState (copy), isEffectivelyVisible (copy)
    local MenuFrame = MenuState.GetMenuFrame();
    local v25;

    if MenuFrame == nil then
        v25 = false;
    else
        v25 = isEffectivelyVisible(MenuFrame);
    end;

    return v25;
end;

local function getSelectionBehavior(p26: userdata, p27) -- Line: 183
    if p27.X < 0 then
        return p26.SelectionBehaviorLeft;
    end;

    if p27.X > 0 then
        return p26.SelectionBehaviorRight;
    end;

    if p27.Y < 0 then
        return p26.SelectionBehaviorUp;
    end;

    return p26.SelectionBehaviorDown;
end;

local function isTrappingGroup(p28: userdata, p29) -- Line: 196
    if not p28.SelectionGroup then
        return false;
    end;

    if not p29 then
        return (p28.SelectionBehaviorUp == Enum.SelectionBehavior.Stop or (p28.SelectionBehaviorDown == Enum.SelectionBehavior.Stop or p28.SelectionBehaviorLeft == Enum.SelectionBehavior.Stop)) and true or p28.SelectionBehaviorRight == Enum.SelectionBehavior.Stop;
    end;

    local v30;

    if p29.X < 0 then
        v30 = p28.SelectionBehaviorLeft;
    elseif p29.X > 0 then
        v30 = p28.SelectionBehaviorRight;
    elseif p29.Y < 0 then
        v30 = p28.SelectionBehaviorUp;
    else
        v30 = p28.SelectionBehaviorDown;
    end;

    return v30 == Enum.SelectionBehavior.Stop;
end;

local function getLayer(p31: userdata, p32) -- Line: 212
    -- upvalues: MenuState (copy), isTrappingGroup (copy)
    local MenuFrame = MenuState.GetMenuFrame();
    local Parent = p31.Parent;

    while Parent do
        if Parent:IsA("LayerCollector") then
            return Parent;
        end;

        if Parent:IsA("GuiObject") then
            if isTrappingGroup(Parent, p32) then
                return Parent;
            end;

            if MenuFrame and Parent.Parent == MenuFrame then
                return Parent;
            end;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

local function isFallbackDisabled(p33: userdata) -- Line: 234
    while p33 and not p33:IsA("LayerCollector") do
        if p33:GetAttribute("GamepadNavigationNoFallback") == true then
            return true;
        end;

        p33 = p33.Parent;
    end;

    local v34;

    if p33 == nil then
        v34 = false;
    else
        v34 = p33:GetAttribute("GamepadNavigationNoFallback") == true;
    end;

    return v34;
end;

local function scrollIntoView(p35: userdata) -- Line: 252
    local Parent = p35.Parent;

    while Parent and not Parent:IsA("LayerCollector") do
        if Parent:IsA("ScrollingFrame") then
            local AbsoluteWindowSize = Parent.AbsoluteWindowSize;
            local v36 = p35.AbsolutePosition - Parent.AbsolutePosition;
            local v37 = v36 + p35.AbsoluteSize;

            local function shift(p38: number, p39: number, p40: number) -- Line: 263
                if p38 < 0 then
                    return p38;
                end;

                return p40 >= p39 and 0 or math.min(p39 - p40, p38);
            end;

            local X = v36.X;
            local X2 = v37.X;
            local X3 = AbsoluteWindowSize.X;

            if X >= 0 then
                X = X3 >= X2 and 0 or math.min(X2 - X3, X);
            end;

            local Y = v36.Y;
            local Y2 = v37.Y;
            local Y3 = AbsoluteWindowSize.Y;

            if Y >= 0 then
                Y = Y3 >= Y2 and 0 or math.min(Y2 - Y3, Y);
            end;

            if X ~= 0 or Y ~= 0 then
                local CanvasPosition = Parent.CanvasPosition;
                local v41 = Parent.AbsoluteCanvasSize - AbsoluteWindowSize;
                local Vector2_new = Vector2.new;
                local v42 = CanvasPosition.X + X;
                local math_max_ret = math.max(0, v41.X);
                local math_clamp_ret = math.clamp(v42, 0, math_max_ret);
                local v43 = CanvasPosition.Y + Y;
                local math_max_ret2 = math.max(0, v41.Y);
                Parent.CanvasPosition = Vector2_new(math_clamp_ret, (math.clamp(v43, 0, math_max_ret2)));
            end;
        end;

        Parent = Parent.Parent;
    end;
end;

local function setSelection(u44: userdata?) -- Line: 291
    -- upvalues: scrollIntoView (copy), GuiService (copy)
    if u44 then
        scrollIntoView(u44);
    end;

    if GuiService.SelectedObject == u44 then
        return true;
    end;

    local v45 = pcall(function() -- Line: 298
        -- upvalues: GuiService (ref), u44 (copy)
        GuiService.SelectedObject = u44;
    end) and GuiService.SelectedObject == u44;

    return v45;
end;

local function getNextSelectionProperty(p46) -- Line: 307
    return p46.X == 0 and (p46.Y < 0 and "NextSelectionUp" or "NextSelectionDown") or (p46.X < 0 and "NextSelectionLeft" or "NextSelectionRight");
end;

local function navigateFallback(u47, u48: number) -- Line: 317
    -- upvalues: GuiService (copy), isUsable (copy), UserInputService (copy), isFallbackDisabled (copy), u10 (ref), u12 (ref), u11 (ref), u1 (copy), getLayer (copy), scrollIntoView (copy)
    local SelectedObject = GuiService.SelectedObject;

    if not isUsable(SelectedObject) then
        SelectedObject = nil;
    end;

    if not SelectedObject or (GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox()) then
        return;
    end;

    local v49;

    if u47.X == 0 then
        v49 = u47.Y < 0 and "NextSelectionUp" or "NextSelectionDown";
    else
        v49 = u47.X < 0 and "NextSelectionLeft" or "NextSelectionRight";
    end;

    if SelectedObject[v49] ~= nil or isFallbackDisabled(SelectedObject) then
        return;
    end;

    local os_clock_ret = os.clock();
    task.delay(0.06, function() -- Line: 327
        -- upvalues: GuiService (ref), SelectedObject (copy), u10 (ref), u48 (copy), u12 (ref), u11 (ref), os_clock_ret (copy), u1 (ref), getLayer (ref), u47 (copy), isUsable (ref), scrollIntoView (ref)
        if GuiService.SelectedObject ~= SelectedObject or (u10 >= u48 - 0.05 or (GuiService.MenuIsOpen or (u12 or (os_clock_ret < u11 or not u1.IsGamepadActive())))) then
            return;
        end;

        local v50 = getLayer(SelectedObject, u47);

        if not v50 then
            return;
        end;

        local v51 = SelectedObject.AbsolutePosition + SelectedObject.AbsoluteSize / 2;
        local v52 = (1 / 0);
        local u53 = nil;

        for _, descendant in v50:GetDescendants() do
            if descendant ~= SelectedObject and (descendant:IsA("GuiObject") and (not descendant:IsA("ScrollingFrame") and isUsable(descendant))) then
                local v54 = descendant.AbsolutePosition + descendant.AbsoluteSize / 2 - v51;
                local v55 = v54:Dot(u47);

                if v55 > 1 then
                    local v56 = v55 + (v54 - u47 * v55).Magnitude * 2;

                    if v56 < v52 then
                        u53 = descendant;
                        v52 = v56;
                    end;
                end;
            end;
        end;

        if u53 then
            if u53 then
                scrollIntoView(u53);
            end;

            if GuiService.SelectedObject == u53 then
                return;
            end;

            if pcall(function() -- Line: 298
                -- upvalues: GuiService (ref), u53 (copy)
                GuiService.SelectedObject = u53;
            end) then
                local _ = GuiService.SelectedObject == u53;
            end;
        end;
    end);
end;

local function refreshCameraStickHold() -- Line: 387
    -- upvalues: MenuState (copy), isEffectivelyVisible (copy), u7 (ref), ContextActionService (copy), GuiService (copy), isUsable (copy), u12 (ref), u4 (copy), Thumbstick2 (copy)
    local MenuFrame = MenuState.GetMenuFrame();
    local v57;

    if MenuFrame == nil then
        v57 = false;
    else
        v57 = isEffectivelyVisible(MenuFrame);
    end;

    if v57 == u7 then
        return;
    end;

    u7 = v57;

    if v57 then
        ContextActionService:BindActionAtPriority("GamepadNavigationMenuCameraStick", function(p58: any, p59: any, p60: userdata) -- Line: 401
            -- upvalues: GuiService (ref), isUsable (ref), u12 (ref)
            if p59 ~= Enum.UserInputState.End and (p59 ~= Enum.UserInputState.Cancel and p60.Position.Magnitude >= 0.1) then
                local SelectedObject = GuiService.SelectedObject;

                if not isUsable(SelectedObject) then
                    SelectedObject = nil;
                end;

                if SelectedObject ~= nil or u12 then
                    return Enum.ContextActionResult.Sink;
                end;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, u4, Thumbstick2);

        return;
    end;

    ContextActionService:UnbindAction("GamepadNavigationMenuCameraStick");
end;

local function getMaxCanvas(p61: userdata, p62: string) -- Line: 421
    local AbsoluteCanvasSize = p61.AbsoluteCanvasSize;
    local AbsoluteWindowSize = p61.AbsoluteWindowSize;
    local v63;

    if p62 == "X" then
        v63 = AbsoluteCanvasSize.X - AbsoluteWindowSize.X;
    else
        v63 = AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y;
    end;

    return math.max(0, v63);
end;

local function canScrollAlong(p64: userdata, p65: string) -- Line: 429
    -- upvalues: isEffectivelyVisible (copy)
    local ScrollingDirection = p64.ScrollingDirection;
    local v66;

    if ScrollingDirection == Enum.ScrollingDirection.XY then
        v66 = true;
    else
        local v67;

        if p65 == "X" then
            v67 = Enum.ScrollingDirection.X;
        else
            v67 = Enum.ScrollingDirection.Y;
        end;

        v66 = ScrollingDirection == v67;
    end;

    local ScrollingEnabled = p64.ScrollingEnabled;

    if ScrollingEnabled then
        if v66 then
            v66 = false;
            local AbsoluteCanvasSize = p64.AbsoluteCanvasSize;
            local AbsoluteWindowSize = p64.AbsoluteWindowSize;
            local v68;

            if p65 == "X" then
                v68 = AbsoluteCanvasSize.X - AbsoluteWindowSize.X;
            else
                v68 = AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y;
            end;

            if math.max(0, v68) > 1 then
                v66 = isEffectivelyVisible(p64);
            end;
        end;
    else
        v66 = ScrollingEnabled;
    end;

    return v66;
end;

local function getStickAxis() -- Line: 439
    -- upvalues: Vector2_zero (ref)
    local math_abs_ret = math.abs(Vector2_zero.X);
    local math_abs_ret2 = math.abs(Vector2_zero.Y);

    return math_abs_ret2 > 0.3 and math_abs_ret <= math_abs_ret2 and "Y" or (math_abs_ret > 0.3 and math_abs_ret2 < math_abs_ret and "X" or nil);
end;

local function findTallestList(p69: userdata) -- Line: 451
    -- upvalues: canScrollAlong (copy)
    local v70 = nil;

    for _, descendant in p69:GetDescendants() do
        if descendant:IsA("ScrollingFrame") and (canScrollAlong(descendant, "Y") and (not v70 or descendant.AbsoluteWindowSize.Y > v70.AbsoluteWindowSize.Y)) then
            v70 = descendant;
        end;
    end;

    return v70;
end;

local function getOpenScreenOutside(p71: userdata) -- Line: 468
    -- upvalues: MenuState (copy), isEffectivelyVisible (copy)
    local MenuFrame = MenuState.GetMenuFrame();
    local CurrentScreen = MenuState.GetCurrentScreen();

    if MenuFrame and CurrentScreen then
        local v72;

        if p71 == nil then
            v72 = false;
        else
            v72 = p71 == MenuFrame and true or p71:IsDescendantOf(MenuFrame);
        end;

        if v72 then
            local v73 = MenuFrame:FindFirstChild(CurrentScreen);

            if v73 and (v73:IsA("GuiObject") and isEffectivelyVisible(v73)) then
                local v74;

                if p71 == nil then
                    v74 = false;
                else
                    v74 = p71 == v73 and true or p71:IsDescendantOf(v73);
                end;

                if not v74 then
                    return v73;
                end;
            end;

            return nil;
        end;
    end;

    return nil;
end;

local function getStickScrollFrame(p75: string) -- Line: 484
    -- upvalues: GuiService (copy), isUsable (copy), canScrollAlong (copy), isFallbackDisabled (copy), getLayer (copy), findTallestList (copy), getOpenScreenOutside (copy)
    local SelectedObject = GuiService.SelectedObject;

    if not isUsable(SelectedObject) then
        SelectedObject = nil;
    end;

    if not SelectedObject then
        return nil;
    end;

    local Parent = SelectedObject.Parent;

    while Parent and not Parent:IsA("LayerCollector") do
        if Parent:IsA("ScrollingFrame") and canScrollAlong(Parent, p75) then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    if p75 == "X" or isFallbackDisabled(SelectedObject) then
        return nil;
    end;

    local v76 = getLayer(SelectedObject);

    if v76 then
        v76 = findTallestList(v76);
    end;

    if v76 then
        return v76;
    end;

    local v77 = getOpenScreenOutside(SelectedObject);

    if v77 then
        v77 = findTallestList(v77);
    end;

    return v77;
end;

local function canStartStickScroll() -- Line: 517
    -- upvalues: u1 (copy), GuiService (copy), isUsable (copy), UserInputService (copy), MenuState (copy)
    local v78 = u1.IsGamepadActive();

    if v78 then
        v78 = false;
        local SelectedObject = GuiService.SelectedObject;

        if not isUsable(SelectedObject) then
            SelectedObject = nil;
        end;

        if SelectedObject ~= nil then
            v78 = not (GuiService.MenuIsOpen or (UserInputService:GetFocusedTextBox() or MenuState.IsInspectActive())) and not MenuState.IsCaseSceneActive();
        end;
    end;

    return v78;
end;

local function isInView(p79: userdata, p80: userdata) -- Line: 529
    local AbsolutePosition = p80.AbsolutePosition;
    local v81 = AbsolutePosition + p80.AbsoluteWindowSize;
    local AbsolutePosition2 = p79.AbsolutePosition;
    local v82 = AbsolutePosition2 + p79.AbsoluteSize;
    local v83;

    if AbsolutePosition2.X >= AbsolutePosition.X - 1 and (AbsolutePosition2.Y >= AbsolutePosition.Y - 1 and v82.X <= v81.X + 1) then
        v83 = v82.Y <= v81.Y + 1;
    else
        v83 = false;
    end;

    return v83;
end;

local function findButtonInView(p84: userdata, p85: userdata?, p86: string) -- Line: 544
    -- upvalues: isUsable (copy)
    local v87 = p84.AbsolutePosition + p84.AbsoluteWindowSize / 2;

    if p85 then
        local v88;

        if p85 == nil then
            v88 = false;
        else
            v88 = p85 == p84 and true or p85:IsDescendantOf(p84);
        end;

        if v88 then
            local v89 = p85.AbsolutePosition + p85.AbsoluteSize / 2;

            if p86 == "Y" then
                v87 = Vector2.new(v89.X, v87.Y);
            else
                v87 = Vector2.new(v87.X, v89.Y);
            end;
        end;
    end;

    local v90 = (1 / 0);
    local v91 = nil;

    for _, descendant in p84:GetDescendants() do
        if descendant:IsA("GuiObject") and not (descendant:IsA("ScrollingFrame") or (descendant:IsA("TextBox") or not isUsable(descendant))) then
            local AbsolutePosition = p84.AbsolutePosition;
            local v92 = AbsolutePosition + p84.AbsoluteWindowSize;
            local AbsolutePosition2 = descendant.AbsolutePosition;
            local v93 = AbsolutePosition2 + descendant.AbsoluteSize;
            local v94;

            if AbsolutePosition2.X >= AbsolutePosition.X - 1 and (AbsolutePosition2.Y >= AbsolutePosition.Y - 1 and v93.X <= v92.X + 1) then
                v94 = v93.Y <= v92.Y + 1;
            else
                v94 = false;
            end;

            if v94 then
                local Magnitude = (descendant.AbsolutePosition + descendant.AbsoluteSize / 2 - v87).Magnitude;

                if Magnitude < v90 then
                    v91 = descendant;
                    v90 = Magnitude;
                end;
            end;
        end;
    end;

    return v91;
end;

local function startStickScroll(p95: userdata, p96: string) -- Line: 576
    -- upvalues: u12 (ref), u13 (ref), Vector2_zero2 (ref), u14 (ref), GuiService (copy), ContextActionService (copy), u4 (copy)
    u12 = p95;
    u13 = p96;
    Vector2_zero2 = p95.CanvasPosition;
    u14 = os.clock();
    GuiService.GuiNavigationEnabled = false;
    ContextActionService:BindActionAtPriority("GamepadNavigationStickScrollSink", function() -- Line: 583
        return Enum.ContextActionResult.Sink;
    end, false, u4, Enum.KeyCode.Thumbstick1, Enum.KeyCode.ButtonA);
end;

local function stopStickScroll() -- Line: 590
    -- upvalues: u12 (ref), GuiService (copy), ContextActionService (copy), u1 (copy), u11 (ref), u14 (ref), Vector2_zero2 (ref), isUsable (copy), findButtonInView (copy), u13 (ref), scrollIntoView (copy)
    local v97 = u12;
    u12 = nil;
    GuiService.GuiNavigationEnabled = true;
    ContextActionService:UnbindAction("GamepadNavigationStickScrollSink");

    if not v97 then
        return;
    end;

    if not (u1.IsGamepadActive() and (u14 >= u11 and (v97.CanvasPosition - Vector2_zero2).Magnitude >= 1)) then
        return;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if not isUsable(SelectedObject) then
        SelectedObject = nil;
    end;

    if SelectedObject then
        local v98;

        if SelectedObject == nil then
            v98 = false;
        else
            v98 = SelectedObject == v97 and true or SelectedObject:IsDescendantOf(v97);
        end;

        if v98 then
            local AbsolutePosition = v97.AbsolutePosition;
            local v99 = AbsolutePosition + v97.AbsoluteWindowSize;
            local AbsolutePosition2 = SelectedObject.AbsolutePosition;
            local v100 = AbsolutePosition2 + SelectedObject.AbsoluteSize;
            local v101;

            if AbsolutePosition2.X >= AbsolutePosition.X - 1 and (AbsolutePosition2.Y >= AbsolutePosition.Y - 1 and v100.X <= v99.X + 1) then
                v101 = v100.Y <= v99.Y + 1;
            else
                v101 = false;
            end;

            if v101 then
                return;
            end;
        end;
    end;

    local u102 = findButtonInView(v97, SelectedObject, u13);

    if u102 then
        u11 = os.clock();

        if u102 then
            scrollIntoView(u102);
        end;

        if GuiService.SelectedObject == u102 then
            return;
        end;

        if pcall(function() -- Line: 298
            -- upvalues: GuiService (ref), u102 (copy)
            GuiService.SelectedObject = u102;
        end) then
            local _ = GuiService.SelectedObject == u102;
        end;
    end;
end;

local function updateStickScroll(p103: number) -- Line: 624
    -- upvalues: u12 (ref), u13 (ref), u1 (copy), GuiService (copy), MenuState (copy), canScrollAlong (copy), Vector2_zero (ref), stopStickScroll (copy)
    local u104 = u12;

    if not u104 then
        return;
    end;

    local u105 = u13;
    local success, result = pcall(function() -- Line: 633
        -- upvalues: u1 (ref), GuiService (ref), MenuState (ref), canScrollAlong (ref), u104 (copy), u105 (copy)
        local v106 = u1.IsGamepadActive() and not (GuiService.MenuIsOpen or MenuState.IsInspectActive()) and canScrollAlong(u104, u105);

        return v106;
    end);
    local math_abs_ret = math.abs(Vector2_zero.X);
    local math_abs_ret2 = math.abs(Vector2_zero.Y);

    if (math_abs_ret2 > 0.3 and math_abs_ret <= math_abs_ret2 and "Y" or (math_abs_ret > 0.3 and math_abs_ret2 < math_abs_ret and "X" or nil)) ~= u105 or not (success and result) then
        stopStickScroll();

        return;
    end;

    local v107;

    if u105 == "Y" then
        v107 = Vector2_zero.Y;
    else
        v107 = Vector2_zero.X;
    end;

    local v108 = (math.abs(v107) - 0.3) / 0.7;
    local math_clamp_ret = math.clamp(v108, 0, 1);
    local AbsoluteWindowSize = u104.AbsoluteWindowSize;
    local v109 = math.sign(v107) * math_clamp_ret * math_clamp_ret * 1.6;
    local v110;

    if u105 == "Y" then
        v110 = AbsoluteWindowSize.Y;
    else
        v110 = AbsoluteWindowSize.X;
    end;

    local v111 = v109 * v110 * p103;
    local CanvasPosition = u104.CanvasPosition;
    local AbsoluteCanvasSize = u104.AbsoluteCanvasSize;
    local AbsoluteWindowSize2 = u104.AbsoluteWindowSize;
    local v112;

    if u105 == "X" then
        v112 = AbsoluteCanvasSize.X - AbsoluteWindowSize2.X;
    else
        v112 = AbsoluteCanvasSize.Y - AbsoluteWindowSize2.Y;
    end;

    local math_max_ret = math.max(0, v112);
    local v113;

    if u105 == "Y" then
        v113 = Vector2.new(CanvasPosition.X, (math.clamp(CanvasPosition.Y - v111, 0, math_max_ret)));
    else
        v113 = Vector2.new(math.clamp(CanvasPosition.X + v111, 0, math_max_ret), CanvasPosition.Y);
    end;

    u104.CanvasPosition = v113;
end;

function u1.IsGamepadActive() -- Line: 664
    -- upvalues: UserInputService (copy), u2 (copy), u3 (copy)
    local LastInputType = UserInputService:GetLastInputType();

    if u2[LastInputType] == true then
        return true;
    end;

    return not u3[LastInputType] and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad;
end;

u1.IsUsable = isUsable;
u1.ScrollIntoView = scrollIntoView;

function u1.FindFirstSelectable(p114: userdata) -- Line: 680
    -- upvalues: isUsable (copy)
    local v115 = (1 / 0);
    local v116 = nil;

    for _, descendant in p114:GetDescendants() do
        if descendant:IsA("GuiObject") and (not descendant:IsA("ScrollingFrame") and isUsable(descendant)) then
            local AbsolutePosition = descendant.AbsolutePosition;
            local v117 = math.floor(AbsolutePosition.Y / 8) * 100000 + AbsolutePosition.X;

            if descendant:IsA("TextBox") then
                v117 = v117 + 1000000000;
            end;

            if v117 < v115 then
                v116 = descendant;
                v115 = v117;
            end;
        end;
    end;

    return v116;
end;

function u1.Focus(u118: userdata?) -- Line: 706
    -- upvalues: u1 (copy), isUsable (copy), u11 (ref), scrollIntoView (copy), GuiService (copy)
    if not (u118 and u1.IsGamepadActive()) then
        return false;
    end;

    if not isUsable(u118) or u118:IsA("ScrollingFrame") then
        u118 = u1.FindFirstSelectable(u118);
    end;

    if not u118 then
        return false;
    end;

    u11 = os.clock();

    if u118 then
        scrollIntoView(u118);
    end;

    if GuiService.SelectedObject == u118 then
        return true;
    end;

    local v119 = pcall(function() -- Line: 298
        -- upvalues: GuiService (ref), u118 (copy)
        GuiService.SelectedObject = u118;
    end) and GuiService.SelectedObject == u118;

    return v119;
end;

function u1.TrapPopup(u120: userdata, u121: function?) -- Line: 730
    -- upvalues: GuiService (copy), u1 (copy), isUsable (copy)
    u120.SelectionGroup = true;
    u120.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
    u120.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
    u120.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
    u120.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
    local u122 = nil;

    local function onVisibilityChanged() -- Line: 739
        -- upvalues: u120 (copy), GuiService (ref), u122 (ref), u121 (copy), u1 (ref), isUsable (ref)
        if u120.Visible and u120.Parent then
            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject then
                local v123 = u120;
                local v124;

                if SelectedObject == nil then
                    v124 = false;
                else
                    v124 = SelectedObject == v123 and true or SelectedObject:IsDescendantOf(v123);
                end;

                if v124 then
                    SelectedObject = nil;
                end;
            else
                SelectedObject = nil;
            end;

            u122 = SelectedObject;
            task.defer(function() -- Line: 744
                -- upvalues: u120 (ref), GuiService (ref), u121 (ref), u1 (ref)
                if u120.Visible and u120.Parent then
                    local SelectedObject2 = GuiService.SelectedObject;
                    local v125 = u120;
                    local v126;

                    if SelectedObject2 == nil then
                        v126 = false;
                    else
                        v126 = SelectedObject2 == v125 and true or SelectedObject2:IsDescendantOf(v125);
                    end;

                    if not v126 then
                        local v127 = u121 and u121();

                        if not (v127 and u1.Focus(v127)) then
                            u1.Focus(u120);
                        end;
                    end;
                end;
            end);

            return;
        end;

        local v128 = u122;
        u122 = nil;
        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject == nil then
            if isUsable(v128) then
                u1.Focus(v128);
            end;
        else
            local v129 = u120;
            local v130;

            if SelectedObject == nil then
                v130 = false;
            else
                v130 = SelectedObject == v129 and true or SelectedObject:IsDescendantOf(v129);
            end;

            if v130 or not isUsable(SelectedObject) then
                if isUsable(v128) then
                    u1.Focus(v128);
                end;
            end;
        end;
    end;

    u120:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged);
    u120.AncestryChanged:Connect(function() -- Line: 766
        -- upvalues: u120 (copy), u122 (ref), onVisibilityChanged (copy)
        if u120.Parent == nil and u122 then
            task.defer(onVisibilityChanged);
        end;
    end);

    if u120.Visible then
        onVisibilityChanged();
    end;
end;

function u1.Initialize() -- Line: 779
    -- upvalues: u6 (ref), UserInputService (copy), u5 (copy), u2 (copy), navigateFallback (copy), GuiService (copy), u10 (ref), u8 (ref), u9 (ref), Thumbstick2 (copy), Vector2_zero (ref), u15 (ref), u12 (ref), u16 (ref), canStartStickScroll (copy), getStickScrollFrame (copy), startStickScroll (copy), RunService (copy), updateStickScroll (copy), refreshCameraStickHold (copy)
    if u6 then
        return;
    end;

    u6 = true;
    UserInputService.InputBegan:Connect(function(p131: userdata) -- Line: 785
        -- upvalues: u5 (ref), u2 (ref), navigateFallback (ref)
        local v132 = u5[p131.KeyCode];

        if v132 and u2[p131.UserInputType] == true then
            navigateFallback(v132, os.clock());
        end;
    end);
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 792
        -- upvalues: u10 (ref)
        u10 = os.clock();
    end);
    UserInputService.InputChanged:Connect(function(p133: userdata) -- Line: 796
        -- upvalues: u8 (ref), u9 (ref), navigateFallback (ref), Thumbstick2 (ref), Vector2_zero (ref), u15 (ref), u12 (ref), u16 (ref), canStartStickScroll (ref), getStickScrollFrame (ref), startStickScroll (ref)
        if p133.KeyCode == Enum.KeyCode.Thumbstick1 then
            local Vector2_new_ret = Vector2.new(p133.Position.X, p133.Position.Y);

            if Vector2_new_ret.Magnitude <= 0.2 then
                u8 = false;
                u9 = nil;

                return;
            end;

            local v134 = u9 or os.clock();
            u9 = v134;

            if not u8 and Vector2_new_ret.Magnitude >= 0.8 then
                u8 = true;
                local v135;

                if math.abs(Vector2_new_ret.X) > math.abs(Vector2_new_ret.Y) then
                    v135 = Vector2.new(math.sign(Vector2_new_ret.X), 0);
                else
                    v135 = Vector2.new(0, -math.sign(Vector2_new_ret.Y));
                end;

                navigateFallback(v135, v134);
            end;

            return;
        end;

        if p133.KeyCode ~= Thumbstick2 then
            return;
        end;

        Vector2_zero = Vector2.new(p133.Position.X, p133.Position.Y);
        local math_abs_ret = math.abs(Vector2_zero.X);
        local math_abs_ret2 = math.abs(Vector2_zero.Y);
        local v136 = math_abs_ret2 > 0.3 and math_abs_ret <= math_abs_ret2 and "Y" or (math_abs_ret > 0.3 and math_abs_ret2 < math_abs_ret and "X" or nil);

        if v136 then
            if not (u12 or v136 == u15 and os.clock() - u16 <= 0.25) and canStartStickScroll() then
                local os_clock_ret = os.clock();
                u15 = v136;
                u16 = os_clock_ret;
                local v137 = getStickScrollFrame(v136);

                if v137 then
                    startStickScroll(v137, v136);
                end;
            end;

            return;
        end;

        u15 = nil;
    end);
    UserInputService.InputEnded:Connect(function(p138: userdata) -- Line: 842
        -- upvalues: u8 (ref), u9 (ref), Thumbstick2 (ref), Vector2_zero (ref), u15 (ref)
        if p138.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            if p138.KeyCode == Thumbstick2 then
                Vector2_zero = Vector2.zero;
                u15 = nil;
            end;

            return;
        end;

        u8 = false;
        u9 = nil;
    end);
    UserInputService.GamepadDisconnected:Connect(function() -- Line: 852
        -- upvalues: Vector2_zero (ref), u15 (ref), u8 (ref), u9 (ref)
        Vector2_zero = Vector2.zero;
        u15 = nil;
        u8 = false;
        u9 = nil;
    end);
    RunService.RenderStepped:Connect(updateStickScroll);
    task.spawn(function() -- Line: 863
        -- upvalues: refreshCameraStickHold (ref)
        while true do
            refreshCameraStickHold();
            task.wait(0.25);
        end;
    end);
end;

return u1;