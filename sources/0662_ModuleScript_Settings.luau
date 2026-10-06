-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
require(script:WaitForChild("Types"));
local BindDisplay = require(script:WaitForChild("BindDisplay"));
local LocalPlayer = Players.LocalPlayer;
local Settings = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Settings");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local EditMobile = require(ReplicatedStorage.Interface.Screens.Menu.Dashboard.EditMobile);
local CrosshairPreview = require(script.Templates.CrosshairPreview);
local Dropdown = require(script.Templates.Dropdown);
local Keybind = require(script.Templates.Keybind);
local Number = require(script.Templates.Number);
local Toggle = require(script.Templates.Toggle);
local Slider = require(script.Templates.Slider);
local Color3_fromRGB_ret = Color3.fromRGB(34, 38, 47);
local Color3_fromRGB_ret2 = Color3.fromRGB(125, 206, 243);
local u2 = { "Global Shadows", "Glass Shatter", "First Person Tracers", "Muzzle Flash", "Ragdolls" };
local Color3_fromRGB_ret3 = Color3.fromRGB(255, 255, 255);
local u3 = { "Info" };
local u4 = {
    Keybinds = { "Keyboard & Mouse Settings", "Movement Keys", "Weapon Keys", "UI Keys", "Communication Options" },
    Game = { "Item", "HUD", "Crosshair", "Viewmodel", "Radar/Tablet", "Other" },
    Audio = { "Audio", "Music", "Voice Chat", "Other" }
};
local u5 = { "Video", "Audio", "Game", "Keybinds" };
local u6 = {
    Video = "Video",
    Audio = "Audio",
    Game = "Game",
    Keybinds = "Keyboard/Mouse"
};
local u7 = nil;
local u8 = {};
local u9 = nil;
local u10 = 0;
local u11 = nil;
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = nil;
local u17 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = 0;
local u24 = nil;
local u25 = "Video";
local u26 = {
    CrosshairPreviewTemplate = nil,
    DropdownTemplate = nil,
    KeybindTemplate = nil,
    NumberTemplate = nil,
    ToggleTemplate = nil,
    SliderTemplate = nil
};

local function NOOP() -- Line: 217
end;

local function DeepCopy(p27) -- Line: 219
    -- upvalues: DeepCopy (copy)
    if type(p27) ~= "table" then
        return p27;
    end;

    local v28 = {};

    for i, v in pairs(p27) do
        v28[i] = DeepCopy(v);
    end;

    return v28;
end;

local function ResolveSettingPath(p29: any, p30: string) -- Line: 232
    local string_split_ret = string.split(p30, ".");

    for i = 2, #string_split_ret - 1 do
        local v31 = string_split_ret[i];

        if type(p29[v31]) ~= "table" then
            p29[v31] = {};
        end;

        p29 = p29[v31];
        local _ = i;
    end;

    return p29, string_split_ret[#string_split_ret];
end;

local function DeepEqual(p32, p33) -- Line: 247
    -- upvalues: DeepEqual (copy)
    if p32 == p33 then
        return true;
    end;

    if type(p32) ~= type(p33) then
        return false;
    end;

    if type(p32) ~= "table" then
        return false;
    end;

    local v34 = {};

    for i, v in pairs(p32) do
        if not DeepEqual(v, p33[i]) then
            return false;
        end;

        v34[i] = true;
    end;

    for i in pairs(p33) do
        if not v34[i] then
            return false;
        end;
    end;

    return true;
end;

local function GetDatabasePageName(p35: string) -- Line: 282
    -- upvalues: u6 (copy)
    return u6[p35] or p35;
end;

local function BuildSettingPath(p36: string, p37: string, p38: string) -- Line: 287
    -- upvalues: u6 (copy)
    return `Settings.{u6[p36] or p36}.{p37}.{p38}`;
end;

local function RegisterSettingMetadata(p39: string, p40: string, p41: string) -- Line: 293
    -- upvalues: u6 (copy), u13 (copy)
    u13[p41] = {
        pageName = p39,
        categoryName = p40,
        settingName = p41,
        settingPath = `Settings.{u6[p39] or p39}.{p40}.{p41}`
    };
end;

local function CaptureSelectedControl(p42: userdata) -- Line: 307
    -- upvalues: GuiService (copy)
    local SelectedObject = GuiService.SelectedObject;

    if not (SelectedObject and SelectedObject:IsDescendantOf(p42)) then
        return nil;
    end;

    local v43 = {};

    while SelectedObject and SelectedObject.Parent ~= p42 do
        table.insert(v43, 1, SelectedObject.Name);
        SelectedObject = SelectedObject.Parent;
    end;

    return SelectedObject and {
        row = SelectedObject.Name,
        path = v43
    } or nil;
end;

local function RestoreSelectedControl(p44: userdata, p45: table?) -- Line: 327
    -- upvalues: GuiService (copy)
    if not p45 then
        return;
    end;

    local v46 = p44:FindFirstChild(p45.row);

    if not v46 then
        return;
    end;

    local v47 = v46;

    for _, v in ipairs(p45.path) do
        if v46 then
            v46 = v46:FindFirstChild(v);
        end;
    end;

    if v46 and (v46:IsA("GuiObject") and (v46.Selectable and v46.Visible)) then
        GuiService.SelectedObject = v46;

        return;
    end;

    for _, descendant in ipairs(v47:GetDescendants()) do
        if descendant:IsA("GuiObject") and (descendant.Selectable and descendant.Visible) then
            GuiService.SelectedObject = descendant;

            return;
        end;
    end;
end;

local function ClearContainer(p48: userdata) -- Line: 356
    -- upvalues: u25 (ref), u14 (copy), u15 (copy), u7 (ref)
    local v49 = u25;

    if u14[v49] then
        u14[v49]:Cleanup();
        u14[v49] = nil;
    end;

    if v49 == "Keybinds" then
        table.clear(u15);
        u7 = nil;
    end;

    for _, child in ipairs(p48:GetChildren()) do
        if child:IsA("GuiObject") and (child.Name ~= "Header" and child.Name ~= "Title") then
            child:Destroy();
        end;
    end;
end;

local function GetSettingValue(p50: string, u51: string) -- Line: 380
    -- upvalues: u16 (ref), u6 (copy)
    if not u16 then
        return nil;
    end;

    local v52 = u16[u6[p50] or p50];

    if not v52 then
        return nil;
    end;

    local function searchInTable(p53) -- Line: 394
        -- upvalues: u51 (copy), searchInTable (copy)
        for i, v in pairs(p53) do
            if i == u51 then
                return v;
            end;

            if type(v) == "table" then
                local v54 = searchInTable(v);

                if v54 ~= nil then
                    return v54;
                end;
            end;
        end;

        return nil;
    end;

    return searchInTable(v52);
end;

local function CreateCategoryHeader(p55: string, p56: userdata, p57: number) -- Line: 411
    -- upvalues: Color3_fromRGB_ret2 (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = `Category_{p55}`;
    TextLabel.Text = string.upper(p55);
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextSize = 14;
    TextLabel.TextColor3 = Color3_fromRGB_ret2;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(1, 0, 0, 35);
    TextLabel.LayoutOrder = p57;
    TextLabel.Parent = p56;

    return TextLabel;
end;

local function CreateDivider(p58: userdata, p59: number) -- Line: 427
    -- upvalues: Settings (copy)
    local v60 = Settings:WaitForChild("Divider"):Clone();
    v60.LayoutOrder = p59;
    v60.Parent = p58;

    return v60;
end;

local function UpdateCanvasSize(p61: userdata) -- Line: 434
    local v62 = p61:FindFirstChildOfClass("UIListLayout");

    if v62 then
        p61.CanvasSize = UDim2.new(0, 0, 0, v62.AbsoluteContentSize.Y + 50);
    end;
end;

local function CheckKeybindConflict(p63: string, p64: string, p65: string) -- Line: 442
    -- upvalues: u15 (copy)
    if p63 == "" or p63 == "None" then
        return nil;
    end;

    local v66 = u15[`{p65}:{p63}`];

    if v66 and v66 ~= p64 then
        return v66;
    end;

    return nil;
end;

local function RegisterKeybind(p67: string, p68: string, p69: string) -- Line: 457
    -- upvalues: u15 (copy)
    if p67 == "" or p67 == "None" then
        return;
    end;

    u15[`{p69}:{p67}`] = p68;
end;

local function UnregisterKeybind(p70: string, p71: string) -- Line: 466
    -- upvalues: u15 (copy)
    if p70 == "" or p70 == "None" then
        return;
    end;

    u15[`{p71}:{p70}`] = nil;
end;

local function GetKeybindPlatformFrame(p72: userdata, p73: string) -- Line: 475
    local Right = p72:FindFirstChild("Right");

    if not (Right and Right:IsA("Frame")) then
        return nil;
    end;

    local v74 = Right:FindFirstChild(p73);

    if v74 and v74:IsA("GuiObject") then
        return v74;
    end;

    return nil;
end;

local function GetKeybindTextBox(p75: userdata) -- Line: 491
    -- upvalues: BindDisplay (copy)
    return BindDisplay.GetTextBox(p75);
end;

local function GetKeybindPlatformFromTextBox(p76: userdata) -- Line: 496
    local Parent = p76.Parent;

    while Parent do
        local Parent2 = Parent.Parent;

        if Parent2 and (Parent2.Name == "Right" and Parent:IsA("GuiObject")) then
            return Parent;
        end;

        Parent = Parent2;
    end;

    return nil;
end;

local function GetKeybindSettingTemplate(p77: userdata) -- Line: 508
    -- upvalues: u12 (copy)
    local Parent = p77.Parent;

    if not Parent or Parent.Name ~= "Right" then
        return nil;
    end;

    local Parent2 = Parent.Parent;

    if not (Parent2 and Parent2:IsA("GuiObject")) then
        return nil;
    end;

    local Keybinds = u12.Keybinds;

    if Keybinds and Keybinds[Parent2.Name] == Parent2 then
        return Parent2;
    end;

    return nil;
end;

local function GetRenderedKeybindBox(p78: string, p79: string) -- Line: 529
    -- upvalues: u12 (copy), GetKeybindTextBox (copy)
    if not (u12.Keybinds and u12.Keybinds[p78]) then
        return nil, nil;
    end;

    local Right = u12.Keybinds[p78]:FindFirstChild("Right");
    local v80;

    if Right and Right:IsA("Frame") then
        v80 = Right:FindFirstChild(p79);

        if not (v80 and v80:IsA("GuiObject")) then
            v80 = nil;
        end;
    else
        v80 = nil;
    end;

    if v80 then
        return v80, GetKeybindTextBox(v80);
    end;

    return nil, nil;
end;

local function RememberKeybindTextColor(p81: userdata) -- Line: 550
    if p81:GetAttribute("DefaultTextColor") == nil then
        p81:SetAttribute("DefaultTextColor", p81.TextColor3);
    end;
end;

local function GetKeybindTextColor(p82: userdata) -- Line: 556
    local Attribute = p82:GetAttribute("DefaultTextColor");

    if typeof(Attribute) == "Color3" then
        return Attribute;
    end;

    return p82.TextColor3;
end;

local function HighlightReplacedKeybind(p83: string, p84: string) -- Line: 562
    -- upvalues: u12 (copy), BindDisplay (copy)
    local v85, v86;

    if u12.Keybinds and u12.Keybinds[p83] then
        local Right = u12.Keybinds[p83]:FindFirstChild("Right");

        if Right and Right:IsA("Frame") then
            v85 = Right:FindFirstChild(p84);

            if not (v85 and v85:IsA("GuiObject")) then
                v85 = nil;
            end;
        else
            v85 = nil;
        end;

        if v85 then
            v86 = BindDisplay.GetTextBox(v85);
        else
            v86 = nil;
            v85 = nil;
        end;
    else
        v86 = nil;
        v85 = nil;
    end;

    if not v86 then
        return;
    end;

    if v86:GetAttribute("DefaultTextColor") == nil then
        v86:SetAttribute("DefaultTextColor", v86.TextColor3);
    end;

    v86.TextColor3 = Color3.fromRGB(255, 90, 90);
    BindDisplay.SetConflict(v85, true);
end;

local function ClearKeybindHighlight(p87: string, p88: string) -- Line: 574
    -- upvalues: u12 (copy), BindDisplay (copy), TweenService (copy)
    local v89, v90;

    if u12.Keybinds and u12.Keybinds[p87] then
        local Right = u12.Keybinds[p87]:FindFirstChild("Right");

        if Right and Right:IsA("Frame") then
            v89 = Right:FindFirstChild(p88);

            if not (v89 and v89:IsA("GuiObject")) then
                v89 = nil;
            end;
        else
            v89 = nil;
        end;

        if v89 then
            v90 = BindDisplay.GetTextBox(v89);
        else
            v90 = nil;
            v89 = nil;
        end;
    else
        v90 = nil;
        v89 = nil;
    end;

    if not v90 then
        return;
    end;

    if v90:GetAttribute("DefaultTextColor") == nil then
        v90:SetAttribute("DefaultTextColor", v90.TextColor3);
    end;

    local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v91 = {};
    local Attribute = v90:GetAttribute("DefaultTextColor");

    if typeof(Attribute) ~= "Color3" then
        Attribute = v90.TextColor3;
    end;

    v91.TextColor3 = Attribute;
    TweenService:Create(v90, TweenInfo_new_ret, v91):Play();
    BindDisplay.SetConflict(v89, false);
end;

local function ScrollToTemplate(p92: string) -- Line: 590
    -- upvalues: u12 (copy), TweenService (copy)
    if not (u12.Keybinds and u12.Keybinds[p92]) then
        return;
    end;

    local v93 = u12.Keybinds[p92];
    local Parent = v93.Parent;

    if not (Parent and Parent:IsA("ScrollingFrame")) then
        return;
    end;

    local Y = Parent.AbsoluteSize.Y;
    local math_max_ret = math.max(0, v93.AbsolutePosition.Y - Parent.AbsolutePosition.Y + Parent.CanvasPosition.Y - Y / 2 + v93.AbsoluteSize.Y / 2);
    local math_min_ret = math.min(math_max_ret, Parent.CanvasSize.Y.Offset - Y);
    TweenService:Create(Parent, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, math_min_ret)
    }):Play();
end;

local function SwapKeybinds(p94: string, u95: string, p96: string, p97: string, p98: string?) -- Line: 620
    -- upvalues: u16 (ref), u6 (copy), u1 (copy), u15 (copy), u12 (copy), BindDisplay (copy), ScrollToTemplate (copy)
    if p98 == p96 then
        p98 = nil;
    end;

    local v99;

    if u16 then
        local v100 = u16[u6.Keybinds or "Keybinds"];

        if v100 then
            local function u103(p101) -- Line: 394
                -- upvalues: u95 (copy), u103 (copy)
                for i, v in pairs(p101) do
                    if i == u95 then
                        return v;
                    end;

                    if type(v) == "table" then
                        local v102 = u103(v);

                        if v102 ~= nil then
                            return v102;
                        end;
                    end;
                end;

                return nil;
            end;

            v99 = u103(v100);
        else
            v99 = nil;
        end;
    else
        v99 = nil;
    end;

    local v104 = type(v99) ~= "table" and {} or table.clone(v99);
    v104[p97] = p98 or "";
    u1.SettingChanged("Keybinds", u95, v104);

    if p98 and (p98 ~= "" and (p98 ~= "" and p98 ~= "None")) then
        u15[`{p97}:{p98}`] = u95;
    end;

    if u12.Keybinds and u12.Keybinds[u95] then
        local Right = u12.Keybinds[u95]:FindFirstChild("Right");
        local v105;

        if Right and Right:IsA("Frame") then
            v105 = Right:FindFirstChild(p97);

            if not (v105 and v105:IsA("GuiObject")) then
                v105 = nil;
            end;
        else
            v105 = nil;
        end;

        if v105 then
            BindDisplay.Apply(v105, p98 or "");
        end;
    end;

    local v106, v107;

    if u12.Keybinds and u12.Keybinds[p94] then
        local Right = u12.Keybinds[p94]:FindFirstChild("Right");

        if Right and Right:IsA("Frame") then
            v106 = Right:FindFirstChild(p97);

            if not (v106 and v106:IsA("GuiObject")) then
                v106 = nil;
            end;
        else
            v106 = nil;
        end;

        if v106 then
            v107 = BindDisplay.GetTextBox(v106);
        else
            v107 = nil;
            v106 = nil;
        end;
    else
        v107 = nil;
        v106 = nil;
    end;

    if v107 then
        if v107:GetAttribute("DefaultTextColor") == nil then
            v107:SetAttribute("DefaultTextColor", v107.TextColor3);
        end;

        v107.TextColor3 = Color3.fromRGB(255, 90, 90);
        BindDisplay.SetConflict(v106, true);
    end;

    local v108, v109;

    if u12.Keybinds and u12.Keybinds[u95] then
        local Right = u12.Keybinds[u95]:FindFirstChild("Right");

        if Right and Right:IsA("Frame") then
            v108 = Right:FindFirstChild(p97);

            if not (v108 and v108:IsA("GuiObject")) then
                v108 = nil;
            end;
        else
            v108 = nil;
        end;

        if v108 then
            v109 = BindDisplay.GetTextBox(v108);
        else
            v109 = nil;
            v108 = nil;
        end;
    else
        v109 = nil;
        v108 = nil;
    end;

    if v109 then
        if v109:GetAttribute("DefaultTextColor") == nil then
            v109:SetAttribute("DefaultTextColor", v109.TextColor3);
        end;

        v109.TextColor3 = Color3.fromRGB(255, 90, 90);
        BindDisplay.SetConflict(v108, true);
    end;

    ScrollToTemplate(u95);
end;

local function IsAnyGamepadButtonDown(p110) -- Line: 672
    -- upvalues: UserInputService (copy)
    for _, v in UserInputService:GetConnectedGamepads() do
        if UserInputService:IsGamepadButtonDown(v, p110) then
            return true;
        end;
    end;

    return false;
end;

local function RestoreListeningSelection(u111: string?) -- Line: 686
    -- upvalues: u24 (ref), IsAnyGamepadButtonDown (copy), GuiService (copy)
    local u112 = u24;
    u24 = nil;

    if not u112 then
        return;
    end;

    if u111 then
        u111 = string.match(u111, "^Enum%.KeyCode%.(.+)$");
    end;

    local success, result = pcall(function() -- Line: 694
        -- upvalues: u111 (copy)
        return Enum.KeyCode[u111];
    end);

    if not (u111 and success) then
        result = nil;
    end;

    task.spawn(function() -- Line: 699
        -- upvalues: result (copy), IsAnyGamepadButtonDown (ref), u112 (copy), GuiService (ref)
        local v113 = os.clock() + 1;

        while result and (os.clock() < v113 and IsAnyGamepadButtonDown(result)) do
            task.wait();
        end;

        if u112.Parent and GuiService.SelectedObject == nil then
            GuiService.SelectedObject = u112;
        end;
    end);
end;

local function ReenableScrolling() -- Line: 712
    -- upvalues: u25 (ref), u20 (ref)
    if u25 ~= "Keybinds" then
        return;
    end;

    local Keybinds = u20.Frame.List:FindFirstChild("Keybinds");

    if Keybinds then
        Keybinds = Keybinds.Bottom.Scroll;
    end;

    if Keybinds then
        Keybinds.ScrollingEnabled = true;
    end;
end;

local function HandleKeybindCapture(p114: userdata, p115: string) -- Line: 724
    -- upvalues: u22 (ref), u12 (copy), u19 (ref), u25 (ref), u20 (ref), RestoreListeningSelection (copy), u15 (copy), u16 (ref), u6 (copy), BindDisplay (copy), ClearKeybindHighlight (copy), u10 (ref), u9 (ref), u11 (ref), u1 (copy), SwapKeybinds (copy)
    if not u22 then
        return;
    end;

    local Parent = p114.Parent;
    local v116;

    if Parent and Parent.Name == "Right" then
        v116 = Parent.Parent;

        if v116 and v116:IsA("GuiObject") then
            local Keybinds = u12.Keybinds;

            if not Keybinds or Keybinds[v116.Name] ~= v116 then
                v116 = nil;
            end;
        else
            v116 = nil;
        end;
    else
        v116 = nil;
    end;

    if not v116 then
        local v117 = u22;
        u19 = nil;
        u22 = nil;
        v117:ReleaseFocus();

        if u25 == "Keybinds" then
            local Keybinds = u20.Frame.List:FindFirstChild("Keybinds");

            if Keybinds then
                Keybinds = Keybinds.Bottom.Scroll;
            end;

            if Keybinds then
                Keybinds.ScrollingEnabled = true;
            end;
        end;

        RestoreListeningSelection(p115);

        return;
    end;

    local Name = v116.Name;
    local Name2 = p114.Name;
    local v118;

    if p115 == "" or p115 == "None" then
        v118 = nil;
    else
        v118 = u15[`{Name2}:{p115}`];

        if not v118 or v118 == Name then
            v118 = nil;
        end;
    end;

    local v119 = v118 ~= nil;
    local v120 = u25;
    local v121;

    if u16 then
        local v122 = u16[u6[v120] or v120];

        if v122 then
            local function u125(p123) -- Line: 394
                -- upvalues: Name (copy), u125 (copy)
                for i, v in pairs(p123) do
                    if i == Name then
                        return v;
                    end;

                    if type(v) == "table" then
                        local v124 = u125(v);

                        if v124 ~= nil then
                            return v124;
                        end;
                    end;
                end;

                return nil;
            end;

            v121 = u125(v122);
        else
            v121 = nil;
        end;
    else
        v121 = nil;
    end;

    local v126 = v121 or {};
    local v127 = {
        Computer = type(v126) ~= "table" and "" or v126.Computer,
        Console = type(v126) ~= "table" and "" or v126.Console
    };
    local v128 = v127[Name2];

    if v128 and (v128 ~= "" and (v128 ~= "" and v128 ~= "None")) then
        u15[`{Name2}:{v128}`] = nil;
    end;

    v127[Name2] = p115;

    if p115 ~= "" and p115 ~= "None" then
        u15[`{Name2}:{p115}`] = Name;
    end;

    BindDisplay.Apply(p114, p115);
    BindDisplay.SetConflict(p114, v119);

    if v119 then
        u22.TextColor3 = Color3.fromRGB(255, 90, 90);
    else
        local v129 = u22;
        local Attribute = v129:GetAttribute("DefaultTextColor");

        if typeof(Attribute) ~= "Color3" then
            Attribute = v129.TextColor3;
        end;

        u22.TextColor3 = Attribute;
        ClearKeybindHighlight(Name, Name2);
    end;

    if v119 then
        u10 = u10 + 1;
        u9 = u10;
        u11 = Name2;
    end;

    u1.SettingChanged(u25, Name, v127, false, v119);

    if v119 and v118 then
        SwapKeybinds(Name, v118, p115, Name2, v128);
    end;

    u9 = nil;
    u11 = nil;
    local v130 = u22;
    u19 = nil;
    u22 = nil;
    v130:ReleaseFocus();

    if u25 == "Keybinds" then
        local Keybinds = u20.Frame.List:FindFirstChild("Keybinds");

        if Keybinds then
            Keybinds = Keybinds.Bottom.Scroll;
        end;

        if Keybinds then
            Keybinds.ScrollingEnabled = true;
        end;
    end;

    RestoreListeningSelection(p115);
end;

local function CancelKeybindListening() -- Line: 808
    -- upvalues: u22 (ref), GetKeybindPlatformFromTextBox (copy), BindDisplay (copy), u19 (ref), u25 (ref), u20 (ref), RestoreListeningSelection (copy)
    if not u22 then
        return;
    end;

    local v131 = u22;
    local v132 = GetKeybindPlatformFromTextBox(v131);

    if v132 then
        BindDisplay.Apply(v132, u19 or "");
    else
        v131.Text = "";
    end;

    local Attribute = v131:GetAttribute("DefaultTextColor");

    if typeof(Attribute) ~= "Color3" then
        Attribute = v131.TextColor3;
    end;

    v131.TextColor3 = Attribute;
    u19 = nil;
    u22 = nil;
    v131:ReleaseFocus();

    if u25 == "Keybinds" then
        local Keybinds = u20.Frame.List:FindFirstChild("Keybinds");

        if Keybinds then
            Keybinds = Keybinds.Bottom.Scroll;
        end;

        if Keybinds then
            Keybinds.ScrollingEnabled = true;
        end;
    end;

    RestoreListeningSelection();
end;

local function AddToHistory(p133: string, p134: any, p135: any) -- Line: 831
    -- upvalues: u8 (copy), u9 (ref)
    table.insert(u8, {
        path = p133,
        oldValue = p134,
        newValue = p135,
        batch = u9
    });

    while #u8 > 50 do
        table.remove(u8, 1);
    end;
end;

function u1.RenderPage(u136: string) -- Line: 849
    -- upvalues: Profiler (copy), Pages (copy), u20 (ref), CaptureSelectedControl (copy), ClearContainer (copy), u4 (copy), u12 (copy), u14 (copy), Janitor (copy), CreateCategoryHeader (copy), u16 (ref), u6 (copy), u1 (copy), u26 (copy), GuiService (copy), UserInputService (copy), IsAnyGamepadButtonDown (copy), RunService (copy), CloseButtonRegistry (copy), ActivateButton (copy), GetUserPlatform (copy), u13 (copy), CrosshairPreview (copy), NOOP (copy), u25 (ref), Toggle (copy), Number (copy), Slider (copy), Dropdown (copy), Settings (copy), u21 (ref), u15 (copy), u7 (ref), BindDisplay (copy), Keybind (copy), GetKeybindPlatformFromTextBox (copy), u22 (ref), u19 (ref), u23 (ref), Color3_fromRGB_ret2 (copy), u24 (ref), CancelKeybindListening (copy), RestoreSelectedControl (copy)
    Profiler.mark("UI.Settings.RenderPage");

    if not Pages.GetPage(u136) then
        warn((`[Settings] Page '{u136}' not found in configuration`));

        return;
    end;

    local u137 = u20.Frame.List:FindFirstChild(u136);

    if not u137 then
        warn((`[Settings] Page frame '{u136}' not found in UI`));

        return;
    end;

    local Scroll = u137.Bottom.Scroll;
    local v138 = CaptureSelectedControl(Scroll);
    ClearContainer(Scroll);
    local Header = u137.Header.Heading.Header;

    if Header then
        Header.Text = string.upper(u136) .. " SETTINGS";
    end;

    local Title = u137.Header.Title;

    if Title then
        Title.Text = Pages.Descriptions[u136] or "";
    end;

    local Categories = Pages.GetCategories(u136);
    local u139 = u4[u136];

    if u139 then
        table.sort(Categories, function(p140, p141) -- Line: 884
            -- upvalues: u139 (copy)
            return (table.find(u139, p140) or 999) < (table.find(u139, p141) or 999);
        end);
    end;

    u12[u136] = {};

    if not u14[u136] then
        u14[u136] = Janitor.new();
    end;

    local v142 = 0;

    for _, v in ipairs(Categories) do
        CreateCategoryHeader(v, Scroll, v142);
        v142 = v142 + 1;
        local Category = Pages.GetCategory(u136, v);
        local v143 = v;
        local v144 = {};

        for i, v2 in pairs(Category) do
            if not i:match("^_Divider_") then
                table.insert(v144, {
                    name = i,
                    config = v2
                });
            end;
        end;

        table.sort(v144, function(p145, p146) -- Line: 919
            local v147 = p145.config.Order or 999;
            local v148 = p146.config.Order or 999;

            if v147 == v148 then
                return p145.name < p146.name;
            end;

            return v147 < v148;
        end);
        local u149;

        if u136 == "Game" and v143 == "Crosshair" then
            if u137:FindFirstChild("ChangeColor") then
                u137.ChangeColor:Destroy();
            end;

            if u137.Bottom.Scroll:FindFirstChild("ColorPickerTemplate") then
                u137.Bottom.Scroll.ColorPickerTemplate:Destroy();
            end;

            local function clampChannel(p150: number) -- Line: 940
                local math_round_ret = math.round(p150);

                return math.clamp(math_round_ret, 0, 255);
            end;

            local u151 = {};
            local v152;

            if u16 then
                local v153 = u16[u6[u136] or u136];

                if v153 then
                    local u154 = "Red";

                    local function u157(p155) -- Line: 394
                        -- upvalues: u154 (copy), u157 (copy)
                        for i, v2 in pairs(p155) do
                            if i == u154 then
                                return v2;
                            end;

                            if type(v2) == "table" then
                                local v156 = u157(v2);

                                if v156 ~= nil then
                                    return v156;
                                end;
                            end;
                        end;

                        return nil;
                    end;

                    v152 = u157(v153);
                else
                    v152 = nil;
                end;
            else
                v152 = nil;
            end;

            local v158 = tonumber(v152) or 0;
            local math_round_ret = math.round(v158);
            u151.Red = math.clamp(math_round_ret, 0, 255);
            local v159;

            if u16 then
                local v160 = u16[u6[u136] or u136];

                if v160 then
                    local u161 = "Green";

                    local function u164(p162) -- Line: 394
                        -- upvalues: u161 (copy), u164 (copy)
                        for i, v2 in pairs(p162) do
                            if i == u161 then
                                return v2;
                            end;

                            if type(v2) == "table" then
                                local v163 = u164(v2);

                                if v163 ~= nil then
                                    return v163;
                                end;
                            end;
                        end;

                        return nil;
                    end;

                    v159 = u164(v160);
                else
                    v159 = nil;
                end;
            else
                v159 = nil;
            end;

            local v165 = tonumber(v159) or 255;
            local math_round_ret2 = math.round(v165);
            u151.Green = math.clamp(math_round_ret2, 0, 255);
            local v166;

            if u16 then
                local v167 = u16[u6[u136] or u136];

                if v167 then
                    local u168 = "Blue";

                    local function u171(p169) -- Line: 394
                        -- upvalues: u168 (copy), u171 (copy)
                        for i, v2 in pairs(p169) do
                            if i == u168 then
                                return v2;
                            end;

                            if type(v2) == "table" then
                                local v170 = u171(v2);

                                if v170 ~= nil then
                                    return v170;
                                end;
                            end;
                        end;

                        return nil;
                    end;

                    v166 = u171(v167);
                else
                    v166 = nil;
                end;
            else
                v166 = nil;
            end;

            local v172 = tonumber(v166) or 0;
            local math_round_ret3 = math.round(v172);
            u151.Blue = math.clamp(math_round_ret3, 0, 255);

            local function saveColors() -- Line: 950
                -- upvalues: u1 (ref), u136 (copy), u151 (copy)
                u1.SettingChanged(u136, "Red", u151.Red);
                u1.SettingChanged(u136, "Green", u151.Green);
                u1.SettingChanged(u136, "Blue", u151.Blue);
            end;

            local function setColorsFromColor3(p173) -- Line: 956
                -- upvalues: u151 (copy)
                local math_round_ret4 = math.round(p173.R * 255);
                u151.Red = math.clamp(math_round_ret4, 0, 255);
                local math_round_ret5 = math.round(p173.G * 255);
                u151.Green = math.clamp(math_round_ret5, 0, 255);
                local math_round_ret6 = math.round(p173.B * 255);
                u151.Blue = math.clamp(math_round_ret6, 0, 255);
            end;

            local u174 = u26.ChangeColor:Clone();
            u174.Parent = u137;
            u149 = u26.ColorPickerTemplate:Clone();
            u149.Parent = u137.Bottom.Scroll;
            local Label = u149:FindFirstChild("Label", true);

            if Label and Label:IsA("TextLabel") then
                Label.Text = "Crosshair Color";
            end;

            local UpdateColorPicker = u174:FindFirstChild("UpdateColorPicker", true);
            local ColorPicker = u174:FindFirstChild("ColorPicker", true);
            local Hue = u174:FindFirstChild("Hue", true);
            local v175 = nil;
            local v176 = nil;
            local u177;

            if ColorPicker then
                u177 = ColorPicker:FindFirstChild("Pick", true);

                if not (u177 and u177:IsA("GuiObject")) then
                    u177 = v175;
                end;
            else
                u177 = v175;
            end;

            local u178;

            if Hue then
                u178 = Hue:FindFirstChild("Arrow", true);

                if not (u178 and u178:IsA("GuiObject")) then
                    u178 = v176;
                end;
            else
                u178 = v176;
            end;

            local function color3ToHex(p179) -- Line: 994
                return string.format("#%02X%02X%02X", math.round(p179.R * 255), math.round(p179.G * 255), (math.round(p179.B * 255)));
            end;

            local Color3_toHSV_ret, u180, u181 = Color3.toHSV(Color3.fromRGB(u151.Red, u151.Green, u151.Blue));

            local function setColorsFromHSV() -- Line: 1005
                -- upvalues: Color3_toHSV_ret (ref), u180 (ref), u181 (ref), u151 (copy)
                local Color3_fromHSV_ret = Color3.fromHSV(math.clamp(Color3_toHSV_ret, 0, 1), math.clamp(u180, 0, 1), (math.clamp(u181, 0, 1)));
                local math_round_ret4 = math.round(Color3_fromHSV_ret.R * 255);
                u151.Red = math.clamp(math_round_ret4, 0, 255);
                local math_round_ret5 = math.round(Color3_fromHSV_ret.G * 255);
                u151.Green = math.clamp(math_round_ret5, 0, 255);
                local math_round_ret6 = math.round(Color3_fromHSV_ret.B * 255);
                u151.Blue = math.clamp(math_round_ret6, 0, 255);
            end;

            local function syncHSVFromRGB() -- Line: 1011
                -- upvalues: u151 (copy), Color3_toHSV_ret (ref), u180 (ref), u181 (ref)
                local Color3_toHSV_ret2, v182, v183 = Color3.toHSV(Color3.fromRGB(u151.Red, u151.Green, u151.Blue));

                if v182 > 0 then
                    Color3_toHSV_ret = Color3_toHSV_ret2;
                end;

                u180 = v182;
                u181 = v183;
            end;

            local function signalUpdateColorPicker() -- Line: 1023
                -- upvalues: UpdateColorPicker (copy), u151 (copy)
                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                end;
            end;

            local function setIndicatorFromAbsolutePoint(p184: userdata, p185: userdata, p186, p187: boolean, p188: boolean) -- Line: 1029
                local Parent = p184.Parent;

                if not (Parent and Parent:IsA("GuiObject")) then
                    return;
                end;

                local AbsolutePosition = p185.AbsolutePosition;
                local AbsoluteSize = p185.AbsoluteSize;
                local AbsoluteSize2 = p184.AbsoluteSize;
                local AbsolutePosition2 = Parent.AbsolutePosition;

                if AbsoluteSize.X <= 0 or (AbsoluteSize.Y <= 0 or (AbsoluteSize2.X <= 0 or AbsoluteSize2.Y <= 0)) then
                    return;
                end;

                local v189 = AbsoluteSize2.X * 0.5;
                local v190 = AbsoluteSize2.Y * 0.5;
                local math_clamp_ret = math.clamp(p186.X, AbsolutePosition.X, AbsolutePosition.X + AbsoluteSize.X);
                local math_clamp_ret2 = math.clamp(p186.Y, AbsolutePosition.Y, AbsolutePosition.Y + AbsoluteSize.Y);
                local v191 = math_clamp_ret - v189 - AbsolutePosition2.X;
                local v192 = math_clamp_ret2 - v190 - AbsolutePosition2.Y;

                if not p187 then
                    v191 = p184.Position.X.Offset;
                end;

                if not p188 then
                    v192 = p184.Position.Y.Offset;
                end;

                p184.Position = UDim2.new(p187 and 0 or p184.Position.X.Scale, v191, p188 and 0 or p184.Position.Y.Scale, v192);
            end;

            local function updateColorPicker() -- Line: 1069
                -- upvalues: u151 (copy), u174 (copy), Color3_toHSV_ret (ref), u180 (ref), u149 (ref), ColorPicker (copy), u177 (ref), setIndicatorFromAbsolutePoint (copy), Hue (copy), u178 (ref), u181 (ref)
                local Color3_fromRGB_ret4 = Color3.fromRGB(u151.Red, u151.Green, u151.Blue);
                u174.Hue.BackgroundColor3 = Color3.fromHSV(Color3_toHSV_ret, math.max(u180, 0.01), 1);
                u149.ColorPreview.BackgroundColor3 = Color3_fromRGB_ret4;
                u174.Preview.BackgroundColor3 = Color3_fromRGB_ret4;
                u174.Hex.Container.Left.Title.Text = string.format("#%02X%02X%02X", math.round(Color3_fromRGB_ret4.R * 255), math.round(Color3_fromRGB_ret4.G * 255), (math.round(Color3_fromRGB_ret4.B * 255)));

                for _, child in u149.Right:GetChildren() do
                    if u151[child.Name] ~= nil then
                        child.Container.Left.Title.Text = tostring(u151[child.Name]);
                    end;
                end;

                for _, child in u174.RGB:GetChildren() do
                    if child:IsA("Frame") then
                        child.Container.Left.Title.Text = tostring(u151[child.Name]);
                    end;
                end;

                if ColorPicker and (ColorPicker:IsA("GuiObject") and u177) then
                    local AbsoluteSize = ColorPicker.AbsoluteSize;

                    if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
                        local v193 = math.clamp(Color3_toHSV_ret, 0, 1) * AbsoluteSize.X;
                        local v194 = (1 - math.clamp(u180, 0, 1)) * AbsoluteSize.Y;
                        setIndicatorFromAbsolutePoint(u177, ColorPicker, ColorPicker.AbsolutePosition + Vector2.new(v193, v194), true, true);
                    end;
                end;

                if Hue and (Hue:IsA("GuiObject") and u178) then
                    local AbsoluteSize = Hue.AbsoluteSize;

                    if AbsoluteSize.Y > 0 then
                        local v195 = (1 - math.clamp(u181, 0, 1)) * AbsoluteSize.Y;
                        setIndicatorFromAbsolutePoint(u178, Hue, Hue.AbsolutePosition + Vector2.new(AbsoluteSize.X * 0.5, v195), false, true);
                    end;
                end;
            end;

            local function commitColorChange() -- Line: 1112
                -- upvalues: updateColorPicker (copy), UpdateColorPicker (copy), u151 (copy)
                updateColorPicker();

                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                end;
            end;

            local function getMouseLocation() -- Line: 1117
                -- upvalues: GuiService (ref), UserInputService (ref)
                local GuiInset = GuiService:GetGuiInset();

                return UserInputService:GetMouseLocation() - GuiInset;
            end;

            local function setPickerFromMouse(p196) -- Line: 1122
                -- upvalues: ColorPicker (copy), Color3_toHSV_ret (ref), u180 (ref), u181 (ref), u151 (copy), updateColorPicker (copy), UpdateColorPicker (copy)
                if not (ColorPicker and ColorPicker:IsA("GuiObject")) then
                    return;
                end;

                local AbsoluteSize = ColorPicker.AbsoluteSize;

                if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                    return;
                end;

                local AbsolutePosition = ColorPicker.AbsolutePosition;
                local math_clamp_ret = math.clamp((p196.X - AbsolutePosition.X) / AbsoluteSize.X, 0, 1);
                local math_clamp_ret2 = math.clamp((p196.Y - AbsolutePosition.Y) / AbsoluteSize.Y, 0, 1);
                Color3_toHSV_ret = math_clamp_ret;
                u180 = 1 - math_clamp_ret2;
                local Color3_fromHSV_ret = Color3.fromHSV(math.clamp(Color3_toHSV_ret, 0, 1), math.clamp(u180, 0, 1), (math.clamp(u181, 0, 1)));
                local math_round_ret4 = math.round(Color3_fromHSV_ret.R * 255);
                u151.Red = math.clamp(math_round_ret4, 0, 255);
                local math_round_ret5 = math.round(Color3_fromHSV_ret.G * 255);
                u151.Green = math.clamp(math_round_ret5, 0, 255);
                local math_round_ret6 = math.round(Color3_fromHSV_ret.B * 255);
                u151.Blue = math.clamp(math_round_ret6, 0, 255);
                updateColorPicker();

                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                end;
            end;

            local function setHueFromMouse(p197) -- Line: 1143
                -- upvalues: Hue (copy), u181 (ref), Color3_toHSV_ret (ref), u180 (ref), u151 (copy), updateColorPicker (copy), UpdateColorPicker (copy)
                if not (Hue and Hue:IsA("GuiObject")) then
                    return;
                end;

                local AbsoluteSize = Hue.AbsoluteSize;

                if AbsoluteSize.Y <= 0 then
                    return;
                end;

                u181 = 1 - math.clamp((p197.Y - Hue.AbsolutePosition.Y) / AbsoluteSize.Y, 0, 1);
                local Color3_fromHSV_ret = Color3.fromHSV(math.clamp(Color3_toHSV_ret, 0, 1), math.clamp(u180, 0, 1), (math.clamp(u181, 0, 1)));
                local math_round_ret4 = math.round(Color3_fromHSV_ret.R * 255);
                u151.Red = math.clamp(math_round_ret4, 0, 255);
                local math_round_ret5 = math.round(Color3_fromHSV_ret.G * 255);
                u151.Green = math.clamp(math_round_ret5, 0, 255);
                local math_round_ret6 = math.round(Color3_fromHSV_ret.B * 255);
                u151.Blue = math.clamp(math_round_ret6, 0, 255);
                updateColorPicker();

                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                end;
            end;

            local u198 = false;
            local u199 = false;

            local function bindDragStart(p200: userdata?, u201: function) -- Line: 1164
                -- upvalues: u14 (ref), u136 (copy)
                if p200 and p200:IsA("GuiObject") then
                    u14[u136]:Add(p200.InputBegan:Connect(function(p202: userdata) -- Line: 1167
                        -- upvalues: u201 (copy)
                        if p202.UserInputType == Enum.UserInputType.MouseButton1 then
                            u201();
                        end;
                    end), "Disconnect");
                end;
            end;

            bindDragStart(ColorPicker, function() -- Line: 1177
                -- upvalues: u198 (ref), setPickerFromMouse (copy), GuiService (ref), UserInputService (ref)
                u198 = true;
                local GuiInset = GuiService:GetGuiInset();
                setPickerFromMouse(UserInputService:GetMouseLocation() - GuiInset);
            end);
            bindDragStart(Hue, function() -- Line: 1182
                -- upvalues: u199 (ref), setHueFromMouse (copy), GuiService (ref), UserInputService (ref)
                u199 = true;
                local GuiInset = GuiService:GetGuiInset();
                setHueFromMouse(UserInputService:GetMouseLocation() - GuiInset);
            end);
            u14[u136]:Add(UserInputService.InputChanged:Connect(function(p203: userdata) -- Line: 1188
                -- upvalues: GuiService (ref), UserInputService (ref), u198 (ref), setPickerFromMouse (copy), u199 (ref), setHueFromMouse (copy)
                if p203.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return;
                end;

                local GuiInset = GuiService:GetGuiInset();
                local v204 = UserInputService:GetMouseLocation() - GuiInset;

                if u198 then
                    setPickerFromMouse(v204);

                    return;
                end;

                if u199 then
                    setHueFromMouse(v204);
                end;
            end), "Disconnect");
            u14[u136]:Add(UserInputService.InputEnded:Connect(function(p205: userdata) -- Line: 1204
                -- upvalues: u198 (ref), u199 (ref)
                if p205.UserInputType == Enum.UserInputType.MouseButton1 then
                    u198 = false;
                    u199 = false;
                end;
            end), "Disconnect");
            updateColorPicker();

            local function bindChannelInput(u206: any, u207: boolean) -- Line: 1216
                -- upvalues: u151 (copy), u1 (ref), u136 (copy), Color3_toHSV_ret (ref), u180 (ref), u181 (ref), updateColorPicker (copy), UpdateColorPicker (copy)
                u206.Container.Left.Title.FocusLost:Connect(function() -- Line: 1217
                    -- upvalues: u206 (copy), u151 (ref), u207 (copy), u1 (ref), u136 (ref), Color3_toHSV_ret (ref), u180 (ref), u181 (ref), updateColorPicker (ref), UpdateColorPicker (ref)
                    local v208 = tonumber(u206.Container.Left.Title.Text) or u151[u206.Name];
                    local Name = u206.Name;
                    local math_round_ret4 = math.round(v208);
                    u151[Name] = math.clamp(math_round_ret4, 0, 255);

                    if u207 then
                        u1.SettingChanged(u136, "Red", u151.Red);
                        u1.SettingChanged(u136, "Green", u151.Green);
                        u1.SettingChanged(u136, "Blue", u151.Blue);
                    end;

                    local Color3_toHSV_ret2, v209, v210 = Color3.toHSV(Color3.fromRGB(u151.Red, u151.Green, u151.Blue));

                    if v209 > 0 then
                        Color3_toHSV_ret = Color3_toHSV_ret2;
                    end;

                    u180 = v209;
                    u181 = v210;
                    updateColorPicker();

                    if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                        UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                    end;
                end);
            end;

            local u211 = {
                [u174.Hex] = u174.Hex.Container.Left.Title
            };

            for _, child in u149.Right:GetChildren() do
                if u151[child.Name] ~= nil then
                    local u212 = true;
                    child.Container.Left.Title.FocusLost:Connect(function() -- Line: 1217
                        -- upvalues: child (copy), u151 (copy), u212 (copy), u1 (ref), u136 (copy), Color3_toHSV_ret (ref), u180 (ref), u181 (ref), updateColorPicker (copy), UpdateColorPicker (copy)
                        local v213 = tonumber(child.Container.Left.Title.Text) or u151[child.Name];
                        local Name = child.Name;
                        local math_round_ret4 = math.round(v213);
                        u151[Name] = math.clamp(math_round_ret4, 0, 255);

                        if u212 then
                            u1.SettingChanged(u136, "Red", u151.Red);
                            u1.SettingChanged(u136, "Green", u151.Green);
                            u1.SettingChanged(u136, "Blue", u151.Blue);
                        end;

                        local Color3_toHSV_ret2, v214, v215 = Color3.toHSV(Color3.fromRGB(u151.Red, u151.Green, u151.Blue));

                        if v214 > 0 then
                            Color3_toHSV_ret = Color3_toHSV_ret2;
                        end;

                        u180 = v214;
                        u181 = v215;
                        updateColorPicker();

                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                        end;
                    end);
                    local Title2 = child.Container.Left.Title;
                    Title2.Selectable = false;

                    if child:IsA("GuiButton") then
                        child.Activated:Connect(function() -- Line: 1241
                            -- upvalues: Title2 (copy)
                            Title2:CaptureFocus();
                        end);
                    end;
                end;
            end;

            for _, child in u174.RGB:GetChildren() do
                if child:IsA("Frame") then
                    local u216 = false;
                    child.Container.Left.Title.FocusLost:Connect(function() -- Line: 1217
                        -- upvalues: child (copy), u151 (copy), u216 (copy), u1 (ref), u136 (copy), Color3_toHSV_ret (ref), u180 (ref), u181 (ref), updateColorPicker (copy), UpdateColorPicker (copy)
                        local v217 = tonumber(child.Container.Left.Title.Text) or u151[child.Name];
                        local Name = child.Name;
                        local math_round_ret4 = math.round(v217);
                        u151[Name] = math.clamp(math_round_ret4, 0, 255);

                        if u216 then
                            u1.SettingChanged(u136, "Red", u151.Red);
                            u1.SettingChanged(u136, "Green", u151.Green);
                            u1.SettingChanged(u136, "Blue", u151.Blue);
                        end;

                        local Color3_toHSV_ret2, v218, v219 = Color3.toHSV(Color3.fromRGB(u151.Red, u151.Green, u151.Blue));

                        if v218 > 0 then
                            Color3_toHSV_ret = Color3_toHSV_ret2;
                        end;

                        u180 = v218;
                        u181 = v219;
                        updateColorPicker();

                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                        end;
                    end);
                    u211[child] = child.Container.Left.Title;
                end;
            end;

            local u220 = u149.ColorPreview:FindFirstChildWhichIsA("GuiButton") or u149.ColorPreview;

            if not (ColorPicker and ColorPicker:IsA("GuiObject")) then
                ColorPicker = nil;
            end;

            if not (Hue and Hue:IsA("GuiObject")) then
                Hue = nil;
            end;

            local Red = u174.RGB:FindFirstChild("Red");
            local Green = u174.RGB:FindFirstChild("Green");
            local Blue = u174.RGB:FindFirstChild("Blue");
            local u221 = 0;

            if ColorPicker then
                ColorPicker.Selectable = true;
            end;

            if Hue then
                Hue.Selectable = true;
            end;

            u174.SelectionGroup = true;
            u174.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
            u174.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
            u174.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
            u174.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;

            local function getGamepadDirection() -- Line: 1289
                -- upvalues: UserInputService (ref), IsAnyGamepadButtonDown (ref)
                local Vector2_zero = Vector2.zero;

                for _, v2 in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
                    if v2.KeyCode == Enum.KeyCode.Thumbstick1 then
                        local Vector2_new_ret = Vector2.new(v2.Position.X, -v2.Position.Y);

                        if Vector2_new_ret.Magnitude >= 0.2 then
                            Vector2_zero = Vector2_zero + Vector2_new_ret;
                        end;
                    end;
                end;

                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadLeft) then
                    Vector2_zero = Vector2_zero - Vector2.xAxis;
                end;

                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadRight) then
                    Vector2_zero = Vector2_zero + Vector2.xAxis;
                end;

                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadUp) then
                    Vector2_zero = Vector2_zero - Vector2.yAxis;
                end;

                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadDown) then
                    Vector2_zero = Vector2_zero + Vector2.yAxis;
                end;

                if Vector2_zero.Magnitude > 1 then
                    return Vector2_zero.Unit;
                end;

                return Vector2_zero;
            end;

            local function setNextSelection(p222: userdata?, p223: userdata?, p224: userdata?, p225: userdata?, p226: userdata?) -- Line: 1317
                if not p222 then
                    return;
                end;

                if p222.NextSelectionUp ~= p223 then
                    p222.NextSelectionUp = p223;
                end;

                if p222.NextSelectionDown ~= p224 then
                    p222.NextSelectionDown = p224;
                end;

                if p222.NextSelectionLeft ~= p225 then
                    p222.NextSelectionLeft = p225;
                end;

                if p222.NextSelectionRight ~= p226 then
                    p222.NextSelectionRight = p226;
                end;
            end;

            local Hex = u174.Hex;
            local Apply = u174.Buttons.Buttons.Apply;
            local Close = u174.Buttons.Buttons.Close;

            if Red then
                if Red.NextSelectionUp ~= ColorPicker then
                    Red.NextSelectionUp = ColorPicker;
                end;

                if Red.NextSelectionDown ~= Hex then
                    Red.NextSelectionDown = Hex;
                end;

                if Red.NextSelectionLeft ~= Red then
                    Red.NextSelectionLeft = Red;
                end;

                if Red.NextSelectionRight ~= Green then
                    Red.NextSelectionRight = Green;
                end;
            end;

            if Green then
                if Green.NextSelectionUp ~= ColorPicker then
                    Green.NextSelectionUp = ColorPicker;
                end;

                if Green.NextSelectionDown ~= Hex then
                    Green.NextSelectionDown = Hex;
                end;

                if Green.NextSelectionLeft ~= Red then
                    Green.NextSelectionLeft = Red;
                end;

                if Green.NextSelectionRight ~= Blue then
                    Green.NextSelectionRight = Blue;
                end;
            end;

            local v227 = Hue or ColorPicker;

            if Blue then
                if Blue.NextSelectionUp ~= v227 then
                    Blue.NextSelectionUp = v227;
                end;

                if Blue.NextSelectionDown ~= Hex then
                    Blue.NextSelectionDown = Hex;
                end;

                if Blue.NextSelectionLeft ~= Green then
                    Blue.NextSelectionLeft = Green;
                end;

                if Blue.NextSelectionRight ~= Blue then
                    Blue.NextSelectionRight = Blue;
                end;
            end;

            if Hex then
                if Hex.NextSelectionUp ~= Green then
                    Hex.NextSelectionUp = Green;
                end;

                if Hex.NextSelectionDown ~= Apply then
                    Hex.NextSelectionDown = Apply;
                end;

                if Hex.NextSelectionLeft ~= Hex then
                    Hex.NextSelectionLeft = Hex;
                end;

                if Hex.NextSelectionRight ~= Hex then
                    Hex.NextSelectionRight = Hex;
                end;
            end;

            if Apply then
                if Apply.NextSelectionUp ~= Hex then
                    Apply.NextSelectionUp = Hex;
                end;

                if Apply.NextSelectionDown ~= Apply then
                    Apply.NextSelectionDown = Apply;
                end;

                if Apply.NextSelectionLeft ~= Apply then
                    Apply.NextSelectionLeft = Apply;
                end;

                if Apply.NextSelectionRight ~= Close then
                    Apply.NextSelectionRight = Close;
                end;
            end;

            if Close then
                if Close.NextSelectionUp ~= Hex then
                    Close.NextSelectionUp = Hex;
                end;

                if Close.NextSelectionDown ~= Close then
                    Close.NextSelectionDown = Close;
                end;

                if Close.NextSelectionLeft ~= Apply then
                    Close.NextSelectionLeft = Apply;
                end;

                if Close.NextSelectionRight ~= Close then
                    Close.NextSelectionRight = Close;
                end;
            end;

            local function movePicker(p228) -- Line: 1355
                -- upvalues: Color3_toHSV_ret (ref), u180 (ref), u181 (ref), u151 (copy), updateColorPicker (copy), UpdateColorPicker (copy)
                Color3_toHSV_ret = math.clamp(Color3_toHSV_ret + p228.X, 0, 1);
                u180 = math.clamp(u180 - p228.Y, 0, 1);
                local Color3_fromHSV_ret = Color3.fromHSV(math.clamp(Color3_toHSV_ret, 0, 1), math.clamp(u180, 0, 1), (math.clamp(u181, 0, 1)));
                local math_round_ret4 = math.round(Color3_fromHSV_ret.R * 255);
                u151.Red = math.clamp(math_round_ret4, 0, 255);
                local math_round_ret5 = math.round(Color3_fromHSV_ret.G * 255);
                u151.Green = math.clamp(math_round_ret5, 0, 255);
                local math_round_ret6 = math.round(Color3_fromHSV_ret.B * 255);
                u151.Blue = math.clamp(math_round_ret6, 0, 255);
                updateColorPicker();

                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                end;
            end;

            local function moveBrightness(p229) -- Line: 1362
                -- upvalues: u181 (ref), Color3_toHSV_ret (ref), u180 (ref), u151 (copy), updateColorPicker (copy), UpdateColorPicker (copy)
                u181 = math.clamp(u181 - p229.Y, 0, 1);
                local Color3_fromHSV_ret = Color3.fromHSV(math.clamp(Color3_toHSV_ret, 0, 1), math.clamp(u180, 0, 1), (math.clamp(u181, 0, 1)));
                local math_round_ret4 = math.round(Color3_fromHSV_ret.R * 255);
                u151.Red = math.clamp(math_round_ret4, 0, 255);
                local math_round_ret5 = math.round(Color3_fromHSV_ret.G * 255);
                u151.Green = math.clamp(math_round_ret5, 0, 255);
                local math_round_ret6 = math.round(Color3_fromHSV_ret.B * 255);
                u151.Blue = math.clamp(math_round_ret6, 0, 255);
                updateColorPicker();

                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                end;
            end;

            u14[u136]:Add(RunService.Heartbeat:Connect(function(p230: number) -- Line: 1369
                -- upvalues: GuiService (ref), u174 (copy), getGamepadDirection (copy), ColorPicker (copy), Color3_toHSV_ret (ref), u180 (ref), u181 (ref), u151 (copy), updateColorPicker (copy), UpdateColorPicker (copy), Red (copy), Hue (copy), Blue (copy)
                local SelectedObject = GuiService.SelectedObject;

                if not (u174.Visible and SelectedObject) then
                    return;
                end;

                local v231 = getGamepadDirection() * (p230 / 2);

                if SelectedObject == ColorPicker then
                    if v231 ~= Vector2.zero then
                        Color3_toHSV_ret = math.clamp(Color3_toHSV_ret + v231.X, 0, 1);
                        u180 = math.clamp(u180 - v231.Y, 0, 1);
                        local Color3_fromHSV_ret = Color3.fromHSV(math.clamp(Color3_toHSV_ret, 0, 1), math.clamp(u180, 0, 1), (math.clamp(u181, 0, 1)));
                        local math_round_ret4 = math.round(Color3_fromHSV_ret.R * 255);
                        u151.Red = math.clamp(math_round_ret4, 0, 255);
                        local math_round_ret5 = math.round(Color3_fromHSV_ret.G * 255);
                        u151.Green = math.clamp(math_round_ret5, 0, 255);
                        local math_round_ret6 = math.round(Color3_fromHSV_ret.B * 255);
                        u151.Blue = math.clamp(math_round_ret6, 0, 255);
                        updateColorPicker();

                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                        end;
                    end;

                    local v232;

                    if u180 > 0 then
                        v232 = SelectedObject;
                    else
                        v232 = Red;
                    end;

                    local v233;

                    if Color3_toHSV_ret < 1 then
                        v233 = SelectedObject;
                    else
                        v233 = Hue;
                    end;

                    if not SelectedObject then
                        return;
                    end;

                    if SelectedObject.NextSelectionUp ~= SelectedObject then
                        SelectedObject.NextSelectionUp = SelectedObject;
                    end;

                    if SelectedObject.NextSelectionDown ~= v232 then
                        SelectedObject.NextSelectionDown = v232;
                    end;

                    if SelectedObject.NextSelectionLeft ~= SelectedObject then
                        SelectedObject.NextSelectionLeft = SelectedObject;
                    end;

                    if SelectedObject.NextSelectionRight ~= v233 then
                        SelectedObject.NextSelectionRight = v233;
                    end;
                elseif SelectedObject == Hue then
                    if v231.Y ~= 0 then
                        u181 = math.clamp(u181 - v231.Y, 0, 1);
                        local Color3_fromHSV_ret = Color3.fromHSV(math.clamp(Color3_toHSV_ret, 0, 1), math.clamp(u180, 0, 1), (math.clamp(u181, 0, 1)));
                        local math_round_ret4 = math.round(Color3_fromHSV_ret.R * 255);
                        u151.Red = math.clamp(math_round_ret4, 0, 255);
                        local math_round_ret5 = math.round(Color3_fromHSV_ret.G * 255);
                        u151.Green = math.clamp(math_round_ret5, 0, 255);
                        local math_round_ret6 = math.round(Color3_fromHSV_ret.B * 255);
                        u151.Blue = math.clamp(math_round_ret6, 0, 255);
                        updateColorPicker();

                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                        end;
                    end;

                    local v234;

                    if u181 > 0 then
                        v234 = SelectedObject;
                    else
                        v234 = Blue;
                    end;

                    local v235 = ColorPicker;

                    if not SelectedObject then
                        return;
                    end;

                    if SelectedObject.NextSelectionUp ~= SelectedObject then
                        SelectedObject.NextSelectionUp = SelectedObject;
                    end;

                    if SelectedObject.NextSelectionDown ~= v234 then
                        SelectedObject.NextSelectionDown = v234;
                    end;

                    if SelectedObject.NextSelectionLeft ~= v235 then
                        SelectedObject.NextSelectionLeft = v235;
                    end;

                    if SelectedObject.NextSelectionRight ~= SelectedObject then
                        SelectedObject.NextSelectionRight = SelectedObject;
                    end;
                end;
            end), "Disconnect");

            local function hideColorPopup() -- Line: 1398
                -- upvalues: UserInputService (ref), u174 (copy)
                local FocusedTextBox = UserInputService:GetFocusedTextBox();

                if FocusedTextBox and FocusedTextBox:IsDescendantOf(u174) then
                    FocusedTextBox:ReleaseFocus();
                end;

                u174.Visible = false;
            end;

            local function closeColorPopup() -- Line: 1407
                -- upvalues: GuiService (ref), UserInputService (ref), u174 (copy), u220 (copy)
                local SelectedObject = GuiService.SelectedObject;
                local v236;

                if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                    v236 = SelectedObject == nil and true or SelectedObject:IsDescendantOf(u174);
                else
                    v236 = false;
                end;

                local FocusedTextBox = UserInputService:GetFocusedTextBox();

                if FocusedTextBox and FocusedTextBox:IsDescendantOf(u174) then
                    FocusedTextBox:ReleaseFocus();
                end;

                u174.Visible = false;

                if v236 and (u220:IsA("GuiButton") and u220:IsDescendantOf(game)) then
                    GuiService.SelectedObject = u220;
                end;
            end;

            CloseButtonRegistry.Add(u174, nil, closeColorPopup);
            u14[u136]:Add(function() -- Line: 1423
                -- upvalues: CloseButtonRegistry (ref), u174 (copy)
                CloseButtonRegistry.Remove(u174);
            end, true);
            local Parent = u174.Parent;

            while Parent and Parent:IsA("GuiObject") do
                u14[u136]:Add(Parent:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1437
                    -- upvalues: u174 (copy), Parent (copy), UserInputService (ref)
                    if u174.Visible and not Parent.Visible then
                        local FocusedTextBox = UserInputService:GetFocusedTextBox();

                        if FocusedTextBox and FocusedTextBox:IsDescendantOf(u174) then
                            FocusedTextBox:ReleaseFocus();
                        end;

                        u174.Visible = false;
                    end;
                end), "Disconnect");
                Parent = Parent.Parent;
            end;

            local v237 = {
                ColorPicker,
                Hue,
                Red,
                Green,
                Blue,
                Hex,
                Apply
            };
            local v238 = nil;
            local u239 = {};

            for i = 1, #v237 do
                local v240 = v237[i];
                local v241;

                if v240 then
                    if v238 then
                        u239[v238] = v240;
                    end;

                    v238 = v240;
                    v241 = i;
                else
                    v241 = i;
                end;
            end;

            local u242 = nil;
            u14[u136]:Add(UserInputService.InputBegan:Connect(function(p243: userdata) -- Line: 1465
                -- upvalues: u174 (copy), UserInputService (ref), GuiService (ref), u242 (ref), u221 (ref), u211 (copy)
                if not u174.Visible or UserInputService:GetFocusedTextBox() then
                    return;
                end;

                local SelectedObject = GuiService.SelectedObject;

                if p243.KeyCode ~= Enum.KeyCode.ButtonA then
                    if p243.KeyCode == Enum.KeyCode.ButtonY and (SelectedObject and u211[SelectedObject]) then
                        u211[SelectedObject]:CaptureFocus();
                    end;

                    return;
                end;

                if os.clock() - u221 < 0.1 then
                    SelectedObject = nil;
                end;

                u242 = SelectedObject;
            end), "Disconnect");
            u14[u136]:Add(UserInputService.InputEnded:Connect(function(p244: userdata) -- Line: 1483
                -- upvalues: u242 (ref), u239 (copy), u174 (copy), GuiService (ref)
                if p244.KeyCode ~= Enum.KeyCode.ButtonA then
                    return;
                end;

                local u245 = u242;
                u242 = nil;
                local u246;

                if u245 then
                    u246 = u239[u245];
                else
                    u246 = u245;
                end;

                if not u246 then
                    return;
                end;

                task.defer(function() -- Line: 1496
                    -- upvalues: u174 (ref), GuiService (ref), u245 (copy), u246 (copy)
                    if u174.Visible and GuiService.SelectedObject == u245 then
                        GuiService.SelectedObject = u246;
                    end;
                end);
            end), "Disconnect");

            if u220:IsA("GuiButton") then
                ActivateButton(u220);
                u220.MouseButton1Click:Connect(function() -- Line: 1507
                    -- upvalues: GuiService (ref), u137 (copy), updateColorPicker (copy), ColorPicker (copy), u221 (ref)
                    local v247 = GuiService.SelectedObject ~= nil;
                    u137.ChangeColor.Visible = true;
                    updateColorPicker();

                    if v247 and ColorPicker then
                        u221 = os.clock();
                        GuiService.SelectedObject = ColorPicker;
                    end;
                end);
            end;

            ActivateButton(u137.ChangeColor.Buttons.Buttons.Close);
            u137.ChangeColor.Buttons.Buttons.Close.MouseButton1Click:Connect(closeColorPopup);
            u174.Hex.Container.Left.Title.FocusLost:Connect(function() -- Line: 1522
                -- upvalues: u174 (copy), u151 (copy), Color3_toHSV_ret (ref), u180 (ref), u181 (ref), updateColorPicker (copy), UpdateColorPicker (copy)
                local success, result = pcall(Color3.fromHex, u174.Hex.Container.Left.Title.Text);

                if success and result then
                    local math_round_ret4 = math.round(result.R * 255);
                    u151.Red = math.clamp(math_round_ret4, 0, 255);
                    local math_round_ret5 = math.round(result.G * 255);
                    u151.Green = math.clamp(math_round_ret5, 0, 255);
                    local math_round_ret6 = math.round(result.B * 255);
                    u151.Blue = math.clamp(math_round_ret6, 0, 255);
                    local Color3_toHSV_ret2, v248, v249 = Color3.toHSV(Color3.fromRGB(u151.Red, u151.Green, u151.Blue));

                    if v248 > 0 then
                        Color3_toHSV_ret = Color3_toHSV_ret2;
                    end;

                    u180 = v248;
                    u181 = v249;
                    updateColorPicker();

                    if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                        UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                    end;
                end;
            end);
            ActivateButton(u137.ChangeColor.Buttons.Buttons.Apply);
            u137.ChangeColor.Buttons.Buttons.Apply.MouseButton1Click:Connect(function() -- Line: 1532
                -- upvalues: closeColorPopup (copy), updateColorPicker (copy), UpdateColorPicker (copy), u151 (copy), u1 (ref), u136 (copy)
                closeColorPopup();
                updateColorPicker();

                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u151.Red, u151.Green, u151.Blue);
                end;

                u1.SettingChanged(u136, "Red", u151.Red);
                u1.SettingChanged(u136, "Green", u151.Green);
                u1.SettingChanged(u136, "Blue", u151.Blue);
            end);
        else
            u149 = nil;
        end;

        for _, v2 in ipairs(v144) do
            if v2.name == "Red" or (v2.name == "Green" or v2.name == "Blue") then
                u149.LayoutOrder = v142;
                v142 = v142 + 1;
            else
                local config = v2.config;
                local name = v2.name;
                local u250 = nil;
                local v251 = nil;
                local v252, v253, v254, u255, v256, v257, v258, u259, v260, v261, v262, v263, u264, v265, v266, v267, v268, u269, v270, v271, v272, u273, v274, v275, v276, u277, v278, v279, v280, v281, v282;

                if config.Platform then
                    local v283 = GetUserPlatform();

                    if table.find(v283, config.Platform) ~= nil then
                        u13[name] = {
                            pageName = u136,
                            categoryName = v143,
                            settingName = name,
                            settingPath = `Settings.{u6[u136] or u136}.{v143}.{name}`
                        };

                        if config.Type == "CrosshairPreview" then
                            if u26.CrosshairPreviewTemplate then
                                u250 = u26.CrosshairPreviewTemplate:Clone();
                                v251 = CrosshairPreview(Scroll, v142, u250, u20.Share, function() -- Line: 1576
                                    -- upvalues: u16 (ref)
                                    return u16 and u16.Game and u16.Game.Crosshair;
                                end, NOOP, NOOP, NOOP);

                                if u250 then
                                    u12[u136][name] = u250;
                                    v142 = v142 + 1;
                                end;

                                if v251 then
                                    u14[u136]:Add(v251, true, (`Template_{name}`));
                                end;

                                v252 = Settings:WaitForChild("Divider"):Clone();
                                v252.LayoutOrder = v142;
                                v252.Parent = Scroll;
                                v142 = v142 + 1;
                            end;

                            warn("[Settings] CrosshairPreviewTemplate not loaded");
                        else
                            if config.Type == "Toggle" then
                                assert(u26.ToggleTemplate, "ToggleTemplate not loaded");
                                u250 = u26.ToggleTemplate:Clone();
                                v253 = u25;

                                if u16 then
                                    v254 = u16[u6[v253] or v253];

                                    if v254 then
                                        u255 = function(p284) -- Line: 394, Name: searchInTable
                                            -- upvalues: name (copy), u255 (copy)
                                            for i, v3 in pairs(p284) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v285 = u255(v3);

                                                    if v285 ~= nil then
                                                        return v285;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v256 = u255(v254);
                                    else
                                        v256 = nil;
                                    end;
                                else
                                    v256 = nil;
                                end;

                                if v256 == nil then
                                    v256 = config.Default;
                                end;

                                v251 = Toggle(name, config, Scroll, v142, u250, v256, u1.SettingChanged, u25);
                            elseif config.Type == "Number" then
                                assert(u26.NumberTemplate, "NumberTemplate not loaded");
                                u250 = u26.NumberTemplate:Clone();
                                v257 = u25;

                                if u16 then
                                    v258 = u16[u6[v257] or v257];

                                    if v258 then
                                        u259 = function(p286) -- Line: 394, Name: searchInTable
                                            -- upvalues: name (copy), u259 (copy)
                                            for i, v3 in pairs(p286) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v287 = u259(v3);

                                                    if v287 ~= nil then
                                                        return v287;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v260 = u259(v258);
                                    else
                                        v260 = nil;
                                    end;
                                else
                                    v260 = nil;
                                end;

                                v251 = Number(name, config, Scroll, v142, u250, tonumber(v260 or config.Default) or config.Default, u1.SettingChanged, u25);
                            elseif config.Type == "Slider" then
                                assert(u26.SliderTemplate, "SliderTemplate not loaded");
                                u250 = u26.SliderTemplate:Clone();
                                v261 = nil;

                                if config.HasEnabledToggle then
                                    v262 = u25;

                                    if u16 then
                                        v263 = u16[u6[v262] or v262];

                                        if v263 then
                                            u264 = function(p288) -- Line: 394, Name: searchInTable
                                                -- upvalues: name (copy), u264 (copy)
                                                for i, v3 in pairs(p288) do
                                                    if i == name then
                                                        return v3;
                                                    end;

                                                    if type(v3) == "table" then
                                                        local v289 = u264(v3);

                                                        if v289 ~= nil then
                                                            return v289;
                                                        end;
                                                    end;
                                                end;

                                                return nil;
                                            end;

                                            v265 = u264(v263);
                                        else
                                            v265 = nil;
                                        end;
                                    else
                                        v265 = nil;
                                    end;

                                    if type(v265) == "table" then
                                        v266 = tonumber(v265.Value) or config.Default;
                                        v261 = v265.Enabled;

                                        if v261 == nil then
                                            if config.DefaultEnabled == nil then
                                                v261 = true;
                                            else
                                                v261 = config.DefaultEnabled;
                                            end;
                                        end;
                                    else
                                        v266 = tonumber(v265) or config.Default;

                                        if config.DefaultEnabled == nil then
                                            v261 = true;
                                        else
                                            v261 = config.DefaultEnabled;
                                        end;
                                    end;
                                else
                                    v267 = u25;

                                    if u16 then
                                        v268 = u16[u6[v267] or v267];

                                        if v268 then
                                            u269 = function(p290) -- Line: 394, Name: searchInTable
                                                -- upvalues: name (copy), u269 (copy)
                                                for i, v3 in pairs(p290) do
                                                    if i == name then
                                                        return v3;
                                                    end;

                                                    if type(v3) == "table" then
                                                        local v291 = u269(v3);

                                                        if v291 ~= nil then
                                                            return v291;
                                                        end;
                                                    end;
                                                end;

                                                return nil;
                                            end;

                                            v270 = u269(v268);
                                        else
                                            v270 = nil;
                                        end;
                                    else
                                        v270 = nil;
                                    end;

                                    v266 = tonumber(v270 or config.Default) or config.Default;
                                end;

                                v251 = Slider(name, config, Scroll, v142, u250, v266, v261, u1.SettingChanged, u25);
                            elseif config.Type == "Dropdown" then
                                assert(u26.DropdownTemplate, "DropdownTemplate not loaded");
                                u250 = u26.DropdownTemplate:Clone();
                                v271 = u25;

                                if u16 then
                                    v272 = u16[u6[v271] or v271];

                                    if v272 then
                                        u273 = function(p292) -- Line: 394, Name: searchInTable
                                            -- upvalues: name (copy), u273 (copy)
                                            for i, v3 in pairs(p292) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v293 = u273(v3);

                                                    if v293 ~= nil then
                                                        return v293;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v274 = u273(v272);
                                    else
                                        v274 = nil;
                                    end;
                                else
                                    v274 = nil;
                                end;

                                v251 = Dropdown(name, config, Scroll, v142, u250, v274 or config.Default, u1.SettingChanged, u25, Settings, function() -- Line: 1684
                                    -- upvalues: u21 (ref)
                                    return u21;
                                end, function(p294: userdata?) -- Line: 1687
                                    -- upvalues: u21 (ref)
                                    u21 = p294;
                                end);
                            elseif config.Type == "Keybind" then
                                assert(u26.KeybindTemplate, "KeybindTemplate not loaded");
                                u250 = u26.KeybindTemplate:Clone();
                                v275 = u25;

                                if u16 then
                                    v276 = u16[u6[v275] or v275];

                                    if v276 then
                                        u277 = function(p295) -- Line: 394, Name: searchInTable
                                            -- upvalues: name (copy), u277 (copy)
                                            for i, v3 in pairs(p295) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v296 = u277(v3);

                                                    if v296 ~= nil then
                                                        return v296;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v278 = u277(v276);
                                    else
                                        v278 = nil;
                                    end;
                                else
                                    v278 = nil;
                                end;

                                v279 = v278 or {};

                                if type(v279) == "table" then
                                    for _, v3 in ipairs({ "Computer", "Console" }) do
                                        v280 = v279[v3];

                                        if v280 and v280 ~= "" then
                                            if v280 == "" or v280 == "None" then
                                                v281 = nil;
                                            else
                                                v281 = u15[`{v3}:{v280}`];

                                                if not v281 or v281 == name then
                                                    v281 = nil;
                                                end;
                                            end;

                                            if v281 then
                                                v282 = u7 or {};
                                                u7 = v282;
                                                v282[v3] = v282[v3] or {};
                                                table.insert(v282[v3], {
                                                    action = name,
                                                    keybind = v280
                                                });
                                                table.insert(v282[v3], {
                                                    action = v281,
                                                    keybind = v280
                                                });
                                            end;

                                            if v280 ~= "" then
                                                if v280 ~= "None" then
                                                    u15[`{v3}:{v280}`] = name;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;

                                v251 = Keybind(name, config, Scroll, v142, u250, v279, function(p297: string, u298: string, p299: any) -- Line: 1728, Name: saveResetKeybinds
                                    -- upvalues: u16 (ref), u6 (ref), u250 (copy), BindDisplay (ref), u1 (ref)
                                    local v300;

                                    if u16 then
                                        local v301 = u16[u6[p297] or p297];

                                        if v301 then
                                            local function u304(p302) -- Line: 394
                                                -- upvalues: u298 (copy), u304 (copy)
                                                for i, v3 in pairs(p302) do
                                                    if i == u298 then
                                                        return v3;
                                                    end;

                                                    if type(v3) == "table" then
                                                        local v303 = u304(v3);

                                                        if v303 ~= nil then
                                                            return v303;
                                                        end;
                                                    end;
                                                end;

                                                return nil;
                                            end;

                                            v300 = u304(v301);
                                        else
                                            v300 = nil;
                                        end;
                                    else
                                        v300 = nil;
                                    end;

                                    local v305 = {};

                                    for _, v3 in ipairs({ "Computer", "Console" }) do
                                        local Right = u250:FindFirstChild("Right");
                                        local v306;

                                        if Right and Right:IsA("Frame") then
                                            v306 = Right:FindFirstChild(v3);

                                            if not (v306 and v306:IsA("GuiObject")) then
                                                v306 = nil;
                                            end;
                                        else
                                            v306 = nil;
                                        end;

                                        local v307;

                                        if v306 then
                                            v307 = BindDisplay.GetReset(v306);
                                        else
                                            v307 = nil;
                                        end;

                                        local v308;

                                        if type(v300) == "table" then
                                            v308 = v300[v3];
                                        else
                                            v308 = nil;
                                        end;

                                        if p299[v3] == "" and (v307 and not v307.Visible) then
                                            v305[v3] = "";
                                        elseif v308 == nil then
                                            v305[v3] = p299[v3];
                                        else
                                            v305[v3] = v308;
                                        end;
                                    end;

                                    u1.SettingChanged(p297, u298, v305);
                                end, u25, function(u309: userdata, p310: string, p311: number) -- Line: 1756
                                    -- upvalues: GetKeybindPlatformFromTextBox (ref), u25 (ref), name (copy), u16 (ref), u6 (ref), u22 (ref), u19 (ref), u23 (ref), Color3_fromRGB_ret2 (ref), BindDisplay (ref), Scroll (copy), UserInputService (ref), u24 (ref), GuiService (ref), CancelKeybindListening (ref)
                                    local v312 = GetKeybindPlatformFromTextBox(u309);
                                    local v313 = u25;
                                    local u314 = name;
                                    local v315;

                                    if u16 then
                                        local v316 = u16[u6[v313] or v313];

                                        if v316 then
                                            local function u319(p317) -- Line: 394
                                                -- upvalues: u314 (copy), u319 (copy)
                                                for i, v3 in pairs(p317) do
                                                    if i == u314 then
                                                        return v3;
                                                    end;

                                                    if type(v3) == "table" then
                                                        local v318 = u319(v3);

                                                        if v318 ~= nil then
                                                            return v318;
                                                        end;
                                                    end;
                                                end;

                                                return nil;
                                            end;

                                            v315 = u319(v316);
                                        else
                                            v315 = nil;
                                        end;
                                    else
                                        v315 = nil;
                                    end;

                                    local v320;

                                    if v312 and type(v315) == "table" then
                                        v320 = v315[v312.Name];
                                    else
                                        v320 = nil;
                                    end;

                                    u22 = u309;

                                    if type(v320) == "string" then
                                        p310 = v320;
                                    end;

                                    u19 = p310;
                                    u23 = p311;
                                    u309.Text = "Press a key...";

                                    if u309:GetAttribute("DefaultTextColor") == nil then
                                        u309:SetAttribute("DefaultTextColor", u309.TextColor3);
                                    end;

                                    u309.TextColor3 = Color3_fromRGB_ret2;

                                    if v312 then
                                        BindDisplay.HideIcon(v312);
                                    end;

                                    Scroll.ScrollingEnabled = false;

                                    if not string.match(UserInputService:GetLastInputType().Name, "^Gamepad%d+$") then
                                        u309.FocusLost:Once(function() -- Line: 1798
                                            -- upvalues: u22 (ref), u309 (copy), CancelKeybindListening (ref)
                                            task.defer(function() -- Line: 1799
                                                -- upvalues: u22 (ref), u309 (ref), CancelKeybindListening (ref)
                                                if u22 == u309 then
                                                    CancelKeybindListening();
                                                end;
                                            end);
                                        end);

                                        return;
                                    end;

                                    u24 = GuiService.SelectedObject;
                                    GuiService.SelectedObject = nil;
                                    u309:ReleaseFocus();
                                end, NOOP);
                            end;

                            if u250 then
                                u12[u136][name] = u250;
                                v142 = v142 + 1;
                            end;

                            if v251 then
                                u14[u136]:Add(v251, true, (`Template_{name}`));
                            end;

                            v252 = Settings:WaitForChild("Divider"):Clone();
                            v252.LayoutOrder = v142;
                            v252.Parent = Scroll;
                            v142 = v142 + 1;
                        end;
                    end;
                else
                    u13[name] = {
                        pageName = u136,
                        categoryName = v143,
                        settingName = name,
                        settingPath = `Settings.{u6[u136] or u136}.{v143}.{name}`
                    };

                    if config.Type ~= "CrosshairPreview" then
                        if config.Type == "Toggle" then
                            assert(u26.ToggleTemplate, "ToggleTemplate not loaded");
                            u250 = u26.ToggleTemplate:Clone();
                            v253 = u25;

                            if u16 then
                                v254 = u16[u6[v253] or v253];

                                if v254 then
                                    u255 = function(p284) -- Line: 394, Name: searchInTable
                                        -- upvalues: name (copy), u255 (copy)
                                        for i, v3 in pairs(p284) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v285 = u255(v3);

                                                if v285 ~= nil then
                                                    return v285;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v256 = u255(v254);
                                else
                                    v256 = nil;
                                end;
                            else
                                v256 = nil;
                            end;

                            if v256 == nil then
                                v256 = config.Default;
                            end;

                            v251 = Toggle(name, config, Scroll, v142, u250, v256, u1.SettingChanged, u25);
                        elseif config.Type == "Number" then
                            assert(u26.NumberTemplate, "NumberTemplate not loaded");
                            u250 = u26.NumberTemplate:Clone();
                            v257 = u25;

                            if u16 then
                                v258 = u16[u6[v257] or v257];

                                if v258 then
                                    u259 = function(p286) -- Line: 394, Name: searchInTable
                                        -- upvalues: name (copy), u259 (copy)
                                        for i, v3 in pairs(p286) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v287 = u259(v3);

                                                if v287 ~= nil then
                                                    return v287;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v260 = u259(v258);
                                else
                                    v260 = nil;
                                end;
                            else
                                v260 = nil;
                            end;

                            v251 = Number(name, config, Scroll, v142, u250, tonumber(v260 or config.Default) or config.Default, u1.SettingChanged, u25);
                        elseif config.Type == "Slider" then
                            assert(u26.SliderTemplate, "SliderTemplate not loaded");
                            u250 = u26.SliderTemplate:Clone();
                            v261 = nil;

                            if config.HasEnabledToggle then
                                v262 = u25;

                                if u16 then
                                    v263 = u16[u6[v262] or v262];

                                    if v263 then
                                        u264 = function(p288) -- Line: 394, Name: searchInTable
                                            -- upvalues: name (copy), u264 (copy)
                                            for i, v3 in pairs(p288) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v289 = u264(v3);

                                                    if v289 ~= nil then
                                                        return v289;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v265 = u264(v263);
                                    else
                                        v265 = nil;
                                    end;
                                else
                                    v265 = nil;
                                end;

                                if type(v265) == "table" then
                                    v266 = tonumber(v265.Value) or config.Default;
                                    v261 = v265.Enabled;

                                    if v261 == nil then
                                        if config.DefaultEnabled == nil then
                                            v261 = true;
                                        else
                                            v261 = config.DefaultEnabled;
                                        end;
                                    end;
                                else
                                    v266 = tonumber(v265) or config.Default;

                                    if config.DefaultEnabled == nil then
                                        v261 = true;
                                    else
                                        v261 = config.DefaultEnabled;
                                    end;
                                end;
                            else
                                v267 = u25;

                                if u16 then
                                    v268 = u16[u6[v267] or v267];

                                    if v268 then
                                        u269 = function(p290) -- Line: 394, Name: searchInTable
                                            -- upvalues: name (copy), u269 (copy)
                                            for i, v3 in pairs(p290) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v291 = u269(v3);

                                                    if v291 ~= nil then
                                                        return v291;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v270 = u269(v268);
                                    else
                                        v270 = nil;
                                    end;
                                else
                                    v270 = nil;
                                end;

                                v266 = tonumber(v270 or config.Default) or config.Default;
                            end;

                            v251 = Slider(name, config, Scroll, v142, u250, v266, v261, u1.SettingChanged, u25);
                        elseif config.Type == "Dropdown" then
                            assert(u26.DropdownTemplate, "DropdownTemplate not loaded");
                            u250 = u26.DropdownTemplate:Clone();
                            v271 = u25;

                            if u16 then
                                v272 = u16[u6[v271] or v271];

                                if v272 then
                                    u273 = function(p292) -- Line: 394, Name: searchInTable
                                        -- upvalues: name (copy), u273 (copy)
                                        for i, v3 in pairs(p292) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v293 = u273(v3);

                                                if v293 ~= nil then
                                                    return v293;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v274 = u273(v272);
                                else
                                    v274 = nil;
                                end;
                            else
                                v274 = nil;
                            end;

                            v251 = Dropdown(name, config, Scroll, v142, u250, v274 or config.Default, u1.SettingChanged, u25, Settings, function() -- Line: 1684
                                -- upvalues: u21 (ref)
                                return u21;
                            end, function(p294: userdata?) -- Line: 1687
                                -- upvalues: u21 (ref)
                                u21 = p294;
                            end);
                        elseif config.Type == "Keybind" then
                            assert(u26.KeybindTemplate, "KeybindTemplate not loaded");
                            u250 = u26.KeybindTemplate:Clone();
                            v275 = u25;

                            if u16 then
                                v276 = u16[u6[v275] or v275];

                                if v276 then
                                    u277 = function(p295) -- Line: 394, Name: searchInTable
                                        -- upvalues: name (copy), u277 (copy)
                                        for i, v3 in pairs(p295) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v296 = u277(v3);

                                                if v296 ~= nil then
                                                    return v296;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v278 = u277(v276);
                                else
                                    v278 = nil;
                                end;
                            else
                                v278 = nil;
                            end;

                            v279 = v278 or {};

                            if type(v279) == "table" then
                                for _, v3 in ipairs({ "Computer", "Console" }) do
                                    v280 = v279[v3];

                                    if v280 and v280 ~= "" then
                                        if v280 == "" or v280 == "None" then
                                            v281 = nil;
                                        else
                                            v281 = u15[`{v3}:{v280}`];

                                            if not v281 or v281 == name then
                                                v281 = nil;
                                            end;
                                        end;

                                        if v281 then
                                            v282 = u7 or {};
                                            u7 = v282;
                                            v282[v3] = v282[v3] or {};
                                            table.insert(v282[v3], {
                                                action = name,
                                                keybind = v280
                                            });
                                            table.insert(v282[v3], {
                                                action = v281,
                                                keybind = v280
                                            });
                                        end;

                                        if v280 ~= "" then
                                            if v280 ~= "None" then
                                                u15[`{v3}:{v280}`] = name;
                                            end;
                                        end;
                                    end;
                                end;
                            end;

                            v251 = Keybind(name, config, Scroll, v142, u250, v279, function(p297: string, u298: string, p299: any) -- Line: 1728, Name: saveResetKeybinds
                                -- upvalues: u16 (ref), u6 (ref), u250 (copy), BindDisplay (ref), u1 (ref)
                                local v300;

                                if u16 then
                                    local v301 = u16[u6[p297] or p297];

                                    if v301 then
                                        local function u304(p302) -- Line: 394
                                            -- upvalues: u298 (copy), u304 (copy)
                                            for i, v3 in pairs(p302) do
                                                if i == u298 then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v303 = u304(v3);

                                                    if v303 ~= nil then
                                                        return v303;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v300 = u304(v301);
                                    else
                                        v300 = nil;
                                    end;
                                else
                                    v300 = nil;
                                end;

                                local v305 = {};

                                for _, v3 in ipairs({ "Computer", "Console" }) do
                                    local Right = u250:FindFirstChild("Right");
                                    local v306;

                                    if Right and Right:IsA("Frame") then
                                        v306 = Right:FindFirstChild(v3);

                                        if not (v306 and v306:IsA("GuiObject")) then
                                            v306 = nil;
                                        end;
                                    else
                                        v306 = nil;
                                    end;

                                    local v307;

                                    if v306 then
                                        v307 = BindDisplay.GetReset(v306);
                                    else
                                        v307 = nil;
                                    end;

                                    local v308;

                                    if type(v300) == "table" then
                                        v308 = v300[v3];
                                    else
                                        v308 = nil;
                                    end;

                                    if p299[v3] == "" and (v307 and not v307.Visible) then
                                        v305[v3] = "";
                                    elseif v308 == nil then
                                        v305[v3] = p299[v3];
                                    else
                                        v305[v3] = v308;
                                    end;
                                end;

                                u1.SettingChanged(p297, u298, v305);
                            end, u25, function(u309: userdata, p310: string, p311: number) -- Line: 1756
                                -- upvalues: GetKeybindPlatformFromTextBox (ref), u25 (ref), name (copy), u16 (ref), u6 (ref), u22 (ref), u19 (ref), u23 (ref), Color3_fromRGB_ret2 (ref), BindDisplay (ref), Scroll (copy), UserInputService (ref), u24 (ref), GuiService (ref), CancelKeybindListening (ref)
                                local v312 = GetKeybindPlatformFromTextBox(u309);
                                local v313 = u25;
                                local u314 = name;
                                local v315;

                                if u16 then
                                    local v316 = u16[u6[v313] or v313];

                                    if v316 then
                                        local function u319(p317) -- Line: 394
                                            -- upvalues: u314 (copy), u319 (copy)
                                            for i, v3 in pairs(p317) do
                                                if i == u314 then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v318 = u319(v3);

                                                    if v318 ~= nil then
                                                        return v318;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v315 = u319(v316);
                                    else
                                        v315 = nil;
                                    end;
                                else
                                    v315 = nil;
                                end;

                                local v320;

                                if v312 and type(v315) == "table" then
                                    v320 = v315[v312.Name];
                                else
                                    v320 = nil;
                                end;

                                u22 = u309;

                                if type(v320) == "string" then
                                    p310 = v320;
                                end;

                                u19 = p310;
                                u23 = p311;
                                u309.Text = "Press a key...";

                                if u309:GetAttribute("DefaultTextColor") == nil then
                                    u309:SetAttribute("DefaultTextColor", u309.TextColor3);
                                end;

                                u309.TextColor3 = Color3_fromRGB_ret2;

                                if v312 then
                                    BindDisplay.HideIcon(v312);
                                end;

                                Scroll.ScrollingEnabled = false;

                                if not string.match(UserInputService:GetLastInputType().Name, "^Gamepad%d+$") then
                                    u309.FocusLost:Once(function() -- Line: 1798
                                        -- upvalues: u22 (ref), u309 (copy), CancelKeybindListening (ref)
                                        task.defer(function() -- Line: 1799
                                            -- upvalues: u22 (ref), u309 (ref), CancelKeybindListening (ref)
                                            if u22 == u309 then
                                                CancelKeybindListening();
                                            end;
                                        end);
                                    end);

                                    return;
                                end;

                                u24 = GuiService.SelectedObject;
                                GuiService.SelectedObject = nil;
                                u309:ReleaseFocus();
                            end, NOOP);
                        end;

                        if u250 then
                            u12[u136][name] = u250;
                            v142 = v142 + 1;
                        end;

                        if v251 then
                            u14[u136]:Add(v251, true, (`Template_{name}`));
                        end;

                        v252 = Settings:WaitForChild("Divider"):Clone();
                        v252.LayoutOrder = v142;
                        v252.Parent = Scroll;
                        v142 = v142 + 1;
                    end;

                    if u26.CrosshairPreviewTemplate then
                        u250 = u26.CrosshairPreviewTemplate:Clone();
                        v251 = CrosshairPreview(Scroll, v142, u250, u20.Share, function() -- Line: 1576
                            -- upvalues: u16 (ref)
                            return u16 and u16.Game and u16.Game.Crosshair;
                        end, NOOP, NOOP, NOOP);

                        if u250 then
                            u12[u136][name] = u250;
                            v142 = v142 + 1;
                        end;

                        if v251 then
                            u14[u136]:Add(v251, true, (`Template_{name}`));
                        end;

                        v252 = Settings:WaitForChild("Divider"):Clone();
                        v252.LayoutOrder = v142;
                        v252.Parent = Scroll;
                        v142 = v142 + 1;
                    end;

                    warn("[Settings] CrosshairPreviewTemplate not loaded");
                end;
            end;
        end;
    end;

    local v321 = Scroll:FindFirstChildOfClass("UIListLayout");

    if v321 then
        Scroll.CanvasSize = UDim2.new(0, 0, 0, v321.AbsoluteContentSize.Y + 50);
    end;

    RestoreSelectedControl(Scroll, v138);

    if u136 == "Keybinds" and u7 then
        Profiler.defer("UI.Settings.HighlightDuplicateKeybindsDeferred", function() -- Line: 1835
            -- upvalues: u7 (ref), u12 (ref), BindDisplay (ref)
            local v322 = {};

            for i, v in pairs(u7) do
                local v323 = i;

                for _, v2 in ipairs(v) do
                    local v324 = `{v2.action}:{v323}`;

                    if not v322[v324] then
                        local action = v2.action;
                        local v325, v326;

                        if u12.Keybinds and u12.Keybinds[action] then
                            local Right = u12.Keybinds[action]:FindFirstChild("Right");

                            if Right and Right:IsA("Frame") then
                                v325 = Right:FindFirstChild(v323);

                                if not (v325 and v325:IsA("GuiObject")) then
                                    v325 = nil;
                                end;
                            else
                                v325 = nil;
                            end;

                            if v325 then
                                v326 = BindDisplay.GetTextBox(v325);
                            else
                                v326 = nil;
                                v325 = nil;
                            end;
                        else
                            v326 = nil;
                            v325 = nil;
                        end;

                        if v326 then
                            if v326:GetAttribute("DefaultTextColor") == nil then
                                v326:SetAttribute("DefaultTextColor", v326.TextColor3);
                            end;

                            v326.TextColor3 = Color3.fromRGB(255, 90, 90);
                            BindDisplay.SetConflict(v325, true);
                        end;

                        v322[v324] = true;
                    end;
                end;
            end;

            u7 = nil;
        end);
    end;
end;

local function UpdateTabHighlight(p327: userdata, p328: boolean) -- Line: 1856
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy)
    p327:SetAttribute("Selected", p328 and true or nil);
    local Selected = p327:FindFirstChild("Selected");

    if Selected and Selected:IsA("GuiObject") then
        Selected.Visible = p328;
        local v329;

        if p328 then
            v329 = Color3_fromRGB_ret2;
        else
            v329 = Color3_fromRGB_ret;
        end;

        p327.BackgroundColor3 = v329;

        return;
    end;

    local v330;

    if p328 then
        v330 = Color3_fromRGB_ret2;
    else
        v330 = Color3_fromRGB_ret3;
    end;

    local Title = p327:FindFirstChild("Title", true);

    if Title and Title:IsA("TextLabel") then
        Title.TextColor3 = v330;
    end;

    local Icon = p327:FindFirstChild("Icon", true);

    if Icon and Icon:IsA("ImageLabel") then
        Icon.ImageColor3 = v330;
    end;

    local v331 = p327:FindFirstChildOfClass("UIStroke");

    if v331 then
        v331.Color = v330;
    end;
end;

local function GetSidebarColumn() -- Line: 1885
    -- upvalues: u20 (ref)
    local Categories = u20.Frame:FindFirstChild("Categories");

    if Categories and Categories:IsA("GuiObject") then
        return Categories;
    end;

    return nil;
end;

local function GetTabContainers() -- Line: 1891
    -- upvalues: u20 (ref)
    return { u20.Top.Categories };
end;

function u1.Open(p332: string) -- Line: 1903
    -- upvalues: Profiler (copy), u25 (ref), u20 (ref), u12 (copy), u1 (copy), UpdateTabHighlight (copy)
    Profiler.mark("UI.Settings.Open");
    u25 = p332;

    for _, child in ipairs(u20.Frame.List:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false;
        end;
    end;

    local v333 = u20.Frame.List:FindFirstChild(p332);

    if v333 then
        v333.Visible = true;

        if not u12[p332] then
            u1.RenderPage(p332);
        end;
    end;

    for _, v in ipairs({ u20.Top.Categories }) do
        for _, child in ipairs(v:GetChildren()) do
            if child:IsA("ImageButton") then
                UpdateTabHighlight(child, child.Name == p332);
            end;
        end;
    end;
end;

function u1.SettingChanged(p334: string, u335: string, p336: any, p337: boolean?, p338: boolean?) -- Line: 1936
    -- upvalues: Profiler (copy), u16 (ref), u13 (copy), Pages (copy), u6 (copy), ReplicatedStorage (copy), u2 (copy), Router (copy), u25 (ref), u12 (copy), u1 (copy), DeepEqual (copy), u15 (copy), u11 (ref), ClearKeybindHighlight (copy), AddToHistory (copy), u17 (copy), DeepCopy (copy), u18 (ref), ResolveSettingPath (copy), Remotes (copy), u10 (ref), u9 (ref), u8 (copy)
    Profiler.mark("UI.Settings.SettingChanged");

    if not u16 then
        warn("[Settings] CurrentSettings is nil");

        return;
    end;

    local v339 = u13[u335];

    if not v339 then
        local Setting = Pages.GetSetting(p334, u335);

        if not (Setting and Setting.Category) then
            warn((`[Settings] Could not find metadata or config for setting: {u335}`));

            return;
        end;

        v339 = {
            pageName = p334,
            categoryName = Setting.Category,
            settingName = u335,
            settingPath = `Settings.{u6[p334] or p334}.{Setting.Category}.{u335}`
        };
    end;

    local settingPath = v339.settingPath;

    if settingPath == "Settings.Audio.Music.Bomb/Hostage Volume" then
        require(ReplicatedStorage.Controllers.SoundController).SetBombPlantedMusicVolume(p336);
    elseif settingPath == "Settings.Video.Advanced.Aspect Ratio" then
        require(ReplicatedStorage.Controllers.CameraController).SetAspectRatio(p336);
    end;

    if p337 then
        return;
    end;

    if p334 == "Video" and (p336 == true and table.find(u2, u335)) then
        local v340;

        if u16 then
            local v341 = u16[u6.Video or "Video"];

            if v341 then
                local u342 = "Potato Mode";

                local function u345(p343) -- Line: 394
                    -- upvalues: u342 (copy), u345 (copy)
                    for i, v in pairs(p343) do
                        if i == u342 then
                            return v;
                        end;

                        if type(v) == "table" then
                            local v344 = u345(v);

                            if v344 ~= nil then
                                return v344;
                            end;
                        end;
                    end;

                    return nil;
                end;

                v340 = u345(v341);
            else
                v340 = nil;
            end;
        else
            v340 = nil;
        end;

        if v340 == true then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You can\'t turn this on while Potato Mode is enabled");

            if u25 == "Video" and u12[u25] then
                task.defer(u1.RenderPage, u25);
            end;

            return;
        end;
    end;

    local v346;

    if u16 then
        local v347 = u16[u6[p334] or p334];

        if v347 then
            local function u350(p348) -- Line: 394
                -- upvalues: u335 (copy), u350 (copy)
                for i, v in pairs(p348) do
                    if i == u335 then
                        return v;
                    end;

                    if type(v) == "table" then
                        local v349 = u350(v);

                        if v349 ~= nil then
                            return v349;
                        end;
                    end;
                end;

                return nil;
            end;

            v346 = u350(v347);
        else
            v346 = nil;
        end;
    else
        v346 = nil;
    end;

    if DeepEqual(v346, p336) and not p338 then
        return;
    end;

    local v351 = u16;
    local v352 = u6[p334] or p334;

    if not v351[v352] then
        v351[v352] = {};
    end;

    local v353 = v351[v352];

    if not v353[v339.categoryName] then
        v353[v339.categoryName] = {};
    end;

    v353[v339.categoryName][u335] = p336;

    if p334 == "Keybinds" and (type(v346) == "table" and type(p336) == "table") then
        for _, v in ipairs({ "Computer", "Console" }) do
            local v354 = v346[v];
            local v355;

            if type(v354) == "string" then
                v355 = v354 ~= p336[v];
            else
                v355 = false;
            end;

            if v355 and (u15[`{v}:{v354}`] == u335 and v354 ~= "") then
                if v354 ~= "None" then
                    u15[`{v}:{v354}`] = nil;
                end;
            end;
        end;
    end;

    local v356 = p334 == "Keybinds" and u16[v352];

    if v356 then
        require(ReplicatedStorage.Controllers.InputController).loadActionsFromDatabase(v356);
    end;

    if p334 == "Keybinds" and type(p336) == "table" then
        for _, v in ipairs({ "Computer", "Console" }) do
            local v357 = p336[v];
            local v358;

            if v357 then
                v358 = v357 ~= "";
            else
                v358 = v357;
            end;

            local v359 = not v358;

            if not v359 then
                local v360;

                if v357 == "" or v357 == "None" then
                    v360 = nil;
                else
                    v360 = u15[`{v}:{v357}`];

                    if not v360 or v360 == u335 then
                        v360 = nil;
                    end;
                end;

                v359 = not v360;
            end;

            if v359 and v ~= u11 then
                Profiler.defer("UI.Settings.ClearKeybindHighlightDeferred", ClearKeybindHighlight, u335, v);
            end;
        end;
    end;

    AddToHistory(settingPath, v346, p336);
    u17[settingPath] = {
        Value = DeepCopy(p336),
        SentAt = os.clock()
    };

    if u18 then
        local v361, v362 = ResolveSettingPath(u18, settingPath);
        v361[v362] = DeepCopy(p336);
    end;

    Remotes.Player.UpdatePlayerSettings.Send({
        Value = p336,
        Path = settingPath
    });

    if p334 == "Video" and (u335 == "Potato Mode" and (p336 == true and v346 ~= true)) then
        u10 = u10 + 1;
        u9 = u10;
        u8[#u8].batch = u9;

        for _, v in ipairs(u2) do
            u1.SettingChanged("Video", v, false);
        end;

        u9 = nil;

        if u25 == "Video" and u12[u25] then
            u1.RenderPage(u25);
        end;
    end;

    if p334 == "Video" and (u335 == "Potato Mode" and (p336 == false and v346 == true)) then
        Router.broadcastRouter(
            "CreateMenuNotification",
            "Error",
            "Potato mode has been disabled. Please rejoin for this change to take effect"
        );
    end;
end;

function u1.UpdateSettings(p363) -- Line: 2115
    -- upvalues: Profiler (copy), u16 (ref), u17 (copy), ResolveSettingPath (copy), DeepEqual (copy), DeepCopy (copy), u18 (ref), u25 (ref), u12 (copy), u1 (copy)
    Profiler.mark("UI.Settings.UpdateSettings");
    u16 = p363;
    local os_clock_ret = os.clock();

    for i, v in u17 do
        local v364, v365 = ResolveSettingPath(p363, i);

        if DeepEqual(v364[v365], v.Value) or os_clock_ret - v.SentAt > 5 then
            u17[i] = nil;
        else
            v364[v365] = DeepCopy(v.Value);
        end;
    end;

    if u18 and DeepEqual(p363, u18) then
        return;
    end;

    u18 = DeepCopy(p363);

    if u25 and u12[u25] then
        u1.RenderPage(u25);
    end;
end;

function u1.ResetCrosshair() -- Line: 2143
    -- upvalues: u1 (copy)
    for i, v in pairs({
        ["Crosshair Style"] = "Classic",
        ["Crosshair Image"] = 0,
        ["Follow Recoil"] = true,
        ["Center Dot"] = true,
        ["T Style"] = false,
        Red = 0,
        Green = 255,
        Blue = 0,
        Length = 5,
        Thickness = 1,
        Gap = 0,
        Outline = {
            Enabled = true,
            Value = 1
        },
        Alpha = {
            Enabled = false,
            Value = 200
        },
        ["Friendly Fire Reticle Warning"] = true,
        ["Use Crosshair Color for Scope Dot"] = true,
        ["Show my crosshair when spectating bots"] = false,
        ["Show Player Crosshairs"] = false
    }) do
        u1.SettingChanged("Game", i, v);
    end;

    u1.RenderPage("Game");
end;

function u1.ShareCrosshair() -- Line: 2172
    -- upvalues: u16 (ref), u20 (ref)
    if not (u16 and (u16.Game and u16.Game.Crosshair)) then
        warn("[Settings] No crosshair settings to share");

        return;
    end;

    local HttpService = game:GetService("HttpService");
    local Crosshair = u16.Game.Crosshair;
    local success, result = pcall(function() -- Line: 2182
        -- upvalues: HttpService (copy), Crosshair (copy)
        return HttpService:JSONEncode(Crosshair);
    end);

    if not (success and result) then
        warn("[Settings] Failed to encode crosshair settings:", result);

        return;
    end;

    u20.Share.Visible = true;
    u20.Share.TextBox.Text = result;
    u20.Share.TextBox:CaptureFocus();
    u20.Share.TextBox.CursorPosition = #result + 1;
end;

function u1.ImportCrosshair(u366: string) -- Line: 2197
    -- upvalues: u1 (copy), u20 (ref)
    local HttpService = game:GetService("HttpService");
    local success, result = pcall(function() -- Line: 2200
        -- upvalues: HttpService (copy), u366 (copy)
        return HttpService:JSONDecode(u366);
    end);

    if not (success and (result and type(result) == "table")) then
        warn("[Settings] Failed to import crosshair settings - invalid code");

        return;
    end;

    for i, v in pairs(result) do
        u1.SettingChanged("Game", i, v);
    end;

    u1.RenderPage("Game");
    u20.Share.Visible = false;
end;

function u1.ResetPage(u367: string) -- Line: 2218
    -- upvalues: Pages (copy), u1 (copy)
    local Page = Pages.GetPage(u367);

    if not Page then
        warn((`[Settings] Page '{u367}' not found`));

        return;
    end;

    local function resetSetting(p368: string, p369: any) -- Line: 2225
        -- upvalues: u1 (ref), u367 (copy)
        if not p368:match("^_Divider_") and p369.Default ~= nil then
            u1.SettingChanged(u367, p368, p369.HasEnabledToggle and {
                Enabled = p369.DefaultEnabled or false,
                Value = p369.Default
            } or p369.Default);
        end;
    end;

    local v370;

    if u367 == "Video" then
        v370 = Page["Potato Mode"];
    else
        v370 = nil;
    end;

    if v370 then
        resetSetting("Potato Mode", v370);
    end;

    for i, v in pairs(Page) do
        if not v370 or i ~= "Potato Mode" then
            resetSetting(i, v);
        end;
    end;

    u1.RenderPage(u367);
end;

function u1.UndoLastChange() -- Line: 2258
    -- upvalues: u8 (copy), Remotes (copy), u16 (ref), ReplicatedStorage (copy), Router (copy), u25 (ref), u1 (copy)
    if #u8 == 0 then
        warn("[Settings] No changes to undo");

        return;
    end;

    local table_remove_ret = table.remove(u8);

    if not table_remove_ret then
        return;
    end;

    local function undoChange(p371: table) -- Line: 2269
        -- upvalues: Remotes (ref), u16 (ref), ReplicatedStorage (ref), Router (ref)
        Remotes.Player.UpdatePlayerSettings.Send({
            Path = p371.path,
            Value = p371.oldValue
        });
        local string_split_ret = string.split(p371.path, ".");

        if #string_split_ret >= 3 then
            local v372 = u16;

            for i = 2, #string_split_ret - 1 do
                local v373 = string_split_ret[i];

                if not v372[v373] then
                    return;
                end;

                v372 = v372[v373];
                local _ = i;
            end;

            v372[string_split_ret[#string_split_ret]] = p371.oldValue;
        end;

        if p371.path == "Settings.Video.Advanced.Aspect Ratio" then
            require(ReplicatedStorage.Controllers.CameraController).SetAspectRatio(p371.oldValue);
        end;

        if p371.path == "Settings.Video.Presets.Potato Mode" and (p371.newValue == true and p371.oldValue ~= true) then
            Router.broadcastRouter(
                "CreateMenuNotification",
                "Error",
                "Potato mode has been disabled. Please rejoin for this change to take effect"
            );
        end;
    end;

    undoChange(table_remove_ret);

    while table_remove_ret.batch and (#u8 > 0 and u8[#u8].batch == table_remove_ret.batch) do
        undoChange((table.remove(u8)));
    end;

    if u25 then
        u1.RenderPage(u25);
    end;
end;

local function SetupEditMobileTabButton(u374: userdata) -- Line: 2318
    -- upvalues: EditMobile (copy), UserInputService (copy), ActivateButton (copy), ReplicatedStorage (copy), MenuState (copy)
    local function UpdateButtonVisibility(p375) -- Line: 2319
        -- upvalues: u374 (copy), EditMobile (ref)
        u374.Visible = EditMobile.ShouldShowEntryButton(p375);
    end;

    u374.Visible = EditMobile.ShouldShowEntryButton(nil);
    UserInputService.LastInputTypeChanged:Connect(UpdateButtonVisibility);
    ActivateButton(u374);
    u374.MouseButton1Click:Connect(function() -- Line: 2327
        -- upvalues: ReplicatedStorage (ref), MenuState (ref), EditMobile (ref)
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Dashboard");

        if MenuState.GetCurrentScreen() ~= "Dashboard" then
            return;
        end;

        EditMobile.Open();
    end);
end;

function u1.Initialize(p376: userdata, p377: any) -- Line: 2338
    -- upvalues: Profiler (copy), u20 (ref), u26 (copy), Settings (copy), u3 (copy), SetupEditMobileTabButton (copy), ActivateButton (copy), u1 (copy), MenuState (copy), u22 (ref), u5 (copy), u25 (ref), GuiService (copy), UserInputService (copy), u23 (ref), u19 (ref), RestoreListeningSelection (copy), GetKeybindPlatformFromTextBox (copy), CancelKeybindListening (copy), CloseButtonRegistry (copy), HandleKeybindCapture (copy), u21 (ref)
    Profiler.mark("UI.Settings.Initialize");
    u20 = p377;
    u26.CrosshairPreviewTemplate = Settings:WaitForChild("CrosshairPreviewTemplate");
    u26.ColorPickerTemplate = Settings:WaitForChild("ColorPickerTemplate");
    u26.ChangeColor = Settings:WaitForChild("ChangeColor");
    u26.ToggleTemplate = Settings:WaitForChild("ToggleTemplate");
    u26.DropdownTemplate = Settings:WaitForChild("DropdownTemplate");
    u26.NumberTemplate = Settings:WaitForChild("NumberTemplate");
    u26.SliderTemplate = Settings:WaitForChild("SliderTemplate");
    u26.KeybindTemplate = Settings:WaitForChild("KeybindTemplate");
    local Categories = u20.Frame:FindFirstChild("Categories");

    if not (Categories and Categories:IsA("GuiObject")) then
        Categories = nil;
    end;

    if Categories then
        Categories.Visible = false;
    end;

    for _, v in ipairs(u3) do
        local v378 = u20.Frame:FindFirstChild(v);

        if v378 and v378:IsA("GuiObject") then
            v378.Visible = false;
        end;
    end;

    for _, v in ipairs({ u20.Top.Categories }) do
        for _, child in ipairs(v:GetChildren()) do
            if child:IsA("ImageButton") then
                if child.Name == "EditMobile" then
                    SetupEditMobileTabButton(child);
                else
                    ActivateButton(child);
                    child.MouseButton1Click:Connect(function() -- Line: 2379
                        -- upvalues: u1 (ref), child (copy)
                        u1.Open(child.Name);
                    end);
                end;
            end;
        end;
    end;

    MenuState.RegisterBumperOverride(u20, function(p379: boolean) -- Line: 2386
        -- upvalues: u22 (ref), MenuState (ref), u20 (ref), u5 (ref), u25 (ref), u1 (ref), GuiService (ref)
        if u22 then
            return true;
        end;

        local NextBumperTab = MenuState.GetNextBumperTab(u20.Top.Categories, u5, u25, p379);

        if NextBumperTab and NextBumperTab ~= u25 then
            u1.Open(NextBumperTab);
        end;

        local v380 = u20.Top.Categories:FindFirstChild(u25);

        if v380 and v380:IsA("GuiObject") then
            GuiService.SelectedObject = v380;
        end;

        return true;
    end);
    u20.Reset.MouseButton1Click:Connect(function() -- Line: 2407
        -- upvalues: u1 (ref), u25 (ref)
        u1.ResetPage(u25);
    end);

    if u20:FindFirstChild("Share") then
        u20.Share.Visible = false;
        u20.Share.List.Cancel.MouseButton1Click:Connect(function() -- Line: 2415
            -- upvalues: u20 (ref)
            u20.Share.Visible = false;
        end);
        u20.Share.List.Copy.MouseButton1Click:Connect(function() -- Line: 2419
            -- upvalues: u20 (ref)
            u20.Share.TextBox:CaptureFocus();
            u20.Share.TextBox.CursorPosition = #u20.Share.TextBox.Text + 1;
        end);
        u20.Share.List.Import.MouseButton1Click:Connect(function() -- Line: 2425
            -- upvalues: u1 (ref), u20 (ref)
            u1.ImportCrosshair(u20.Share.TextBox.Text);
        end);
    end;

    UserInputService.InputBegan:Connect(function(p381: userdata, p382: boolean) -- Line: 2431
        -- upvalues: u22 (ref), u23 (ref), u19 (ref), u25 (ref), u20 (ref), RestoreListeningSelection (ref), GetKeybindPlatformFromTextBox (ref), CancelKeybindListening (ref), CloseButtonRegistry (ref), HandleKeybindCapture (ref)
        if not u22 then
            return;
        end;

        if p381.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        if tick() - u23 < 0.1 then
            return;
        end;

        if not u22.Parent then
            u22 = nil;
            u19 = nil;

            if u25 == "Keybinds" then
                local Keybinds = u20.Frame.List:FindFirstChild("Keybinds");

                if Keybinds then
                    Keybinds = Keybinds.Bottom.Scroll;
                end;

                if Keybinds then
                    Keybinds.ScrollingEnabled = true;
                end;
            end;

            RestoreListeningSelection();

            return;
        end;

        local v383 = GetKeybindPlatformFromTextBox(u22);

        if not v383 then
            CancelKeybindListening();

            return;
        end;

        local v384 = "";

        if p381.UserInputType == Enum.UserInputType.Keyboard then
            if p381.KeyCode == Enum.KeyCode.Escape then
                CancelKeybindListening();

                return;
            end;

            v384 = `Enum.KeyCode.{p381.KeyCode.Name}`;
        elseif p381.UserInputType == Enum.UserInputType.MouseButton1 or (p381.UserInputType == Enum.UserInputType.MouseButton2 or p381.UserInputType == Enum.UserInputType.MouseButton3) then
            v384 = `Enum.UserInputType.{p381.UserInputType.Name}`;
        elseif string.match(p381.UserInputType.Name, "^Gamepad%d+$") then
            v384 = `Enum.KeyCode.{p381.KeyCode.Name}`;
            CloseButtonRegistry.MarkUsed();
        end;

        if v384 ~= "" then
            HandleKeybindCapture(v383, v384);
        end;
    end);
    UserInputService.InputChanged:Connect(function(p385: userdata, p386: boolean) -- Line: 2487
        -- upvalues: u22 (ref), u23 (ref), u19 (ref), u25 (ref), u20 (ref), RestoreListeningSelection (ref), GetKeybindPlatformFromTextBox (ref), CancelKeybindListening (ref), HandleKeybindCapture (ref)
        if not u22 then
            return;
        end;

        if p385.UserInputType ~= Enum.UserInputType.MouseWheel then
            return;
        end;

        if tick() - u23 < 0.1 then
            return;
        end;

        if not u22.Parent then
            u19 = nil;
            u22 = nil;

            if u25 == "Keybinds" then
                local Keybinds = u20.Frame.List:FindFirstChild("Keybinds");

                if Keybinds then
                    Keybinds = Keybinds.Bottom.Scroll;
                end;

                if Keybinds then
                    Keybinds.ScrollingEnabled = true;
                end;
            end;

            RestoreListeningSelection();

            return;
        end;

        local v387 = GetKeybindPlatformFromTextBox(u22);

        if not v387 then
            CancelKeybindListening();

            return;
        end;

        local Z = p385.Position.Z;

        if Z > 0 then
            HandleKeybindCapture(v387, "Enum.CustomInputType.ScrollWheelUp");

            return;
        end;

        if Z < 0 then
            HandleKeybindCapture(v387, "Enum.CustomInputType.ScrollWheelDown");
        end;
    end);
    UserInputService.InputBegan:Connect(function(p388: userdata) -- Line: 2527
        -- upvalues: u22 (ref), u21 (ref), CloseButtonRegistry (ref), GuiService (ref)
        if p388.KeyCode ~= Enum.KeyCode.ButtonB or u22 then
            return;
        end;

        local v389 = u21;

        if not (v389 and v389.Visible) then
            return;
        end;

        CloseButtonRegistry.MarkUsed();
        v389.Visible = false;
        local Parent = v389.Parent;

        if Parent then
            Parent.Visible = false;
        end;

        for _, child in ipairs(v389:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy();
            end;
        end;

        u21 = nil;

        if Parent then
            Parent = Parent.Parent;
        end;

        if Parent and Parent:IsA("GuiButton") then
            GuiService.SelectedObject = Parent;
        end;
    end);
    UserInputService.InputBegan:Connect(function(p390: userdata, p391: boolean) -- Line: 2556
        -- upvalues: u21 (ref)
        if p390.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v392 = u21;

        if not (v392 and v392.Visible) then
            return;
        end;

        local Position = p390.Position;

        if not (v392.Parent and v392.Parent.Parent) then
            return;
        end;

        local Options = v392.Parent.Parent:FindFirstChild("Options");

        if not Options then
            return;
        end;

        local Button = Options.Button;

        if not Button then
            return;
        end;

        local function isInside(p393: userdata) -- Line: 2585
            -- upvalues: Position (copy)
            local AbsolutePosition = p393.AbsolutePosition;
            local AbsoluteSize = p393.AbsoluteSize;
            local v394;

            if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
                v394 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v394 = false;
            end;

            return v394;
        end;

        local AbsolutePosition = Button.AbsolutePosition;
        local AbsoluteSize = Button.AbsoluteSize;
        local v395;

        if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
            v395 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v395 = false;
        end;

        if not v395 then
            local AbsolutePosition2 = v392.AbsolutePosition;
            local AbsoluteSize2 = v392.AbsoluteSize;
            local v396;

            if Position.X >= AbsolutePosition2.X and (Position.X <= AbsolutePosition2.X + AbsoluteSize2.X and Position.Y >= AbsolutePosition2.Y) then
                v396 = Position.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y;
            else
                v396 = false;
            end;

            if not v396 then
                v392.Visible = false;
                u21 = nil;
            end;
        end;
    end);
end;

function u1.Start() -- Line: 2600
    -- upvalues: Profiler (copy), u1 (copy), DataController (copy), LocalPlayer (copy)
    debug.setmemorycategory("UI.Settings.Start");
    Profiler.mark("UI.Settings.Start");
    u1.Open("Video");
    DataController.CreateListener(LocalPlayer, "Settings", function(p397) -- Line: 2606
        -- upvalues: u1 (ref)
        u1.UpdateSettings(p397);
    end);
end;

return u1;