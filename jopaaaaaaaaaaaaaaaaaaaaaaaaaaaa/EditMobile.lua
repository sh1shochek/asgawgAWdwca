-- ReplicatedStorage.Interface.Screens.Menu.Dashboard.EditMobile
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Dashboard.EditMobile
-- Decompile time: 40.78 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local ApplyMobileButtonLayout = require(ReplicatedStorage.Components.Common.ApplyMobileButtonLayout);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local u2 = {
    ["Counter-Terrorists"] = {
        Primary = "M4A4",
        Secondary = "USP-S",
        Melee = "CT Knife"
    },
    Terrorists = {
        Primary = "AK-47",
        Secondary = "Glock-18",
        Melee = "T Knife"
    }
};
local u3 = {
    Primary = "Rifles",
    Secondary = "Pistols"
};
local u4 = {
    Bomb = "C4",
    Grenade1 = "HE Grenade",
    Grenade2 = "Flashbang",
    Grenade3 = "Smoke Grenade",
    Grenade4 = "Molotov"
};
local MAX_TRANSPARENCY = Mobile.MAX_TRANSPARENCY;

local function TransparencyToSlider(p5: number) -- Line: 50
    -- upvalues: MAX_TRANSPARENCY (copy)
    return math.clamp(p5 / MAX_TRANSPARENCY, 0, 1);
end;

local function SliderToTransparency(p6: number) -- Line: 54
    -- upvalues: MAX_TRANSPARENCY (copy)
    return math.clamp(p6, 0, 1) * MAX_TRANSPARENCY;
end;

local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(40, 40, 40);
local Color3_fromRGB_ret3 = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 200, 0);
local u7 = {
    {
        Name = "TopLeft",
        Cursor = "rbxasset://SystemCursors/SizeNWSE",
        Anchor = Vector2.new(0, 0)
    },
    {
        Name = "TopRight",
        Cursor = "rbxasset://SystemCursors/SizeNESW",
        Anchor = Vector2.new(1, 0)
    },
    {
        Name = "BottomLeft",
        Cursor = "rbxasset://SystemCursors/SizeNESW",
        Anchor = Vector2.new(0, 1)
    },
    {
        Name = "BottomRight",
        Cursor = "rbxasset://SystemCursors/SizeNWSE",
        Anchor = Vector2.new(1, 1)
    },
    {
        Name = "Top",
        Cursor = "rbxasset://SystemCursors/SizeNS",
        Anchor = Vector2.new(0.5, 0)
    },
    {
        Name = "Bottom",
        Cursor = "rbxasset://SystemCursors/SizeNS",
        Anchor = Vector2.new(0.5, 1)
    },
    {
        Name = "Left",
        Cursor = "rbxasset://SystemCursors/SizeEW",
        Anchor = Vector2.new(0, 0.5)
    },
    {
        Name = "Right",
        Cursor = "rbxasset://SystemCursors/SizeEW",
        Anchor = Vector2.new(1, 0.5)
    }
};
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = false;
local u12 = false;
local DefaultLayout = Mobile.GetDefaultLayout();
local DefaultLayout2 = Mobile.GetDefaultLayout();
local u13 = false;
local u14 = {};
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;

local function IsTouchInputType(p25) -- Line: 139
    return p25 == Enum.UserInputType.Touch;
end;

local function IsPointerPress(p26: userdata) -- Line: 147
    local v27;

    if p26.UserInputType == Enum.UserInputType.Touch or p26.UserInputType == Enum.UserInputType.MouseButton1 then
        v27 = p26.UserInputState == Enum.UserInputState.Begin;
    else
        v27 = false;
    end;

    return v27;
end;

local function IsPointerMove(p28: userdata) -- Line: 152
    return p28.UserInputType == Enum.UserInputType.Touch and true or p28.UserInputType == Enum.UserInputType.MouseMovement;
end;

local function IsPointerRelease(p29: userdata) -- Line: 156
    return p29.UserInputType == Enum.UserInputType.Touch and true or p29.UserInputType == Enum.UserInputType.MouseButton1;
end;

local function IsSamePointer(p30: userdata, p31: userdata) -- Line: 162
    if p30 == p31 then
        return true;
    end;

    local UserInputType = p30.UserInputType;
    local UserInputType2 = p31.UserInputType;

    return (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
end;

local u32 = nil;
local u33 = nil;
local u34 = nil;

local function RefreshMouseCursor() -- Line: 183
    -- upvalues: u33 (ref), u34 (ref), u32 (ref), UserInputService (copy)
    local v35 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v35 then
        UserInputService.MouseIcon = v35;
    end;
end;

local function SetHoveredCursor(p36: string?) -- Line: 190
    -- upvalues: u32 (ref), u33 (ref), u34 (ref), UserInputService (copy)
    u32 = p36;
    local v37 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v37 then
        UserInputService.MouseIcon = v37;
    end;
end;

local function SetActiveResizeCursor(p38: string?) -- Line: 195
    -- upvalues: u33 (ref), u34 (ref), u32 (ref), UserInputService (copy)
    u33 = p38;
    local v39 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v39 then
        UserInputService.MouseIcon = v39;
    end;
end;

local function SetActiveDragCursor(p40: string?) -- Line: 200
    -- upvalues: u34 (ref), u33 (ref), u32 (ref), UserInputService (copy)
    u34 = p40;
    local v41 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v41 then
        UserInputService.MouseIcon = v41;
    end;
end;

local function IsMobilePlatform() -- Line: 205
    -- upvalues: GetUserPlatform (copy)
    local v42 = GetUserPlatform();
    local v43;

    if table.find(v42, "Mobile") == nil then
        v43 = false;
    else
        v43 = #v42 <= 1;
    end;

    return v43;
end;

local function CanUseVIPMenu() -- Line: 213
    -- upvalues: RunService (copy), LocalPlayer (copy)
    if RunService:IsStudio() then
        return true;
    end;

    local v44;

    if workspace:GetAttribute("IsVIPServer") == true then
        v44 = LocalPlayer:GetAttribute("CanUseVIPMenu") == true;
    else
        v44 = false;
    end;

    return v44;
end;

local function ShouldShowMobileHUDEditor(p45) -- Line: 222
    -- upvalues: GetUserPlatform (copy), UserInputService (copy)
    local v46 = GetUserPlatform();
    local v47;

    if table.find(v46, "Mobile") == nil then
        v47 = false;
    else
        v47 = #v46 <= 1;
    end;

    return v47 or (UserInputService.PreferredInput == Enum.PreferredInput.Touch and true or (p45 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch);
end;

local function CopyPositionAndSize(p48) -- Line: 231
    return {
        Position = {
            X = p48.Position.X,
            Y = p48.Position.Y
        },
        Size = {
            X = p48.Size.X,
            Y = p48.Size.Y
        }
    };
end;

local function DeepCopyLayout(p49) -- Line: 238
    -- upvalues: Mobile (copy), CopyPositionAndSize (copy)
    local v50 = {};

    for _, v in ipairs(Mobile.GetButtonNames()) do
        local v51 = p49[v] or Mobile.GetDefaultButtonLayout(v);
        local v52 = CopyPositionAndSize(v51);
        v52.Transparency = v51.Transparency;
        v52.Enabled = v51.Enabled;
        v50[v] = v52;
    end;

    return v50;
end;

local function GetInputGuiPosition(p53: userdata) -- Line: 252
    -- upvalues: GuiService (copy)
    local GuiInset = GuiService:GetGuiInset();

    return Vector2.new(p53.Position.X - GuiInset.X, p53.Position.Y - GuiInset.Y);
end;

local function GetInputScreenPosition(p54: userdata) -- Line: 259
    return Vector2.new(p54.Position.X, p54.Position.Y);
end;

local function SetChildFrameVisible(p55: userdata?, p56: string, p57: boolean) -- Line: 265
    if not p55 then
        return;
    end;

    local v58 = p55:FindFirstChild(p56);

    if v58 and v58:IsA("Frame") then
        v58.Visible = p57;
    end;
end;

local function PlayUIClick() -- Line: 277
    -- upvalues: Router (copy)
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
end;

local function GetEditMobileEntryButton() -- Line: 283
    -- upvalues: u9 (ref)
    local v59 = u9 and u9:FindFirstChild("Holder");
    local v60 = v59 and v59:IsA("Frame") and v59:FindFirstChild("EditMobile");

    if v60 and v60:IsA("Frame") then
        return v60:FindFirstChild("EditMobile");
    end;

    return nil;
end;

local function GetEditMobileFrame() -- Line: 295
    -- upvalues: u10 (ref), u9 (ref)
    local v61 = u10;

    if v61 and v61.Parent then
        return v61;
    end;

    local v62 = u9;

    if not v62 then
        return nil;
    end;

    local EditMobile = v62:FindFirstChild("EditMobile");

    if EditMobile then
        v62 = EditMobile;
    elseif v62.Name ~= "EditMobile" then
        v62 = EditMobile;
    end;

    u10 = v62;

    return v62;
end;

local function GetMenuTopFrame() -- Line: 316
    -- upvalues: u8 (ref)
    local v63 = u8 and u8:FindFirstChild("Menu");
    local v64 = v63 and v63:IsA("Frame") and v63:FindFirstChild("Top");

    if v64 and v64:IsA("Frame") then
        return v64;
    end;

    return nil;
end;

local function GetEditorButtonsFrame() -- Line: 324
    -- upvalues: u10 (ref), u9 (ref)
    local v65 = u10;

    if not (v65 and v65.Parent) then
        v65 = u9;

        if v65 then
            local EditMobile = v65:FindFirstChild("EditMobile");

            if EditMobile then
                v65 = EditMobile;
            elseif v65.Name ~= "EditMobile" then
                v65 = EditMobile;
            end;

            u10 = v65;
        else
            v65 = nil;
        end;
    end;

    if v65 then
        return v65:FindFirstChild("MobileButtons");
    end;

    return nil;
end;

local function GetGameplayMobileButtonsFrame() -- Line: 334
    -- upvalues: u8 (ref)
    if not u8 then
        return nil;
    end;

    local Parent = u8.Parent;

    if Parent then
        Parent = Parent:FindFirstChild("MobileControlsGui");
    end;

    if Parent then
        Parent = Parent:FindFirstChild("MobileButtons");
    end;

    if Parent and Parent:IsA("Frame") then
        return Parent;
    end;

    local Gameplay = u8:FindFirstChild("Gameplay");

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Middle");
    end;

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("MobileButtons");
    end;

    if Gameplay and Gameplay:IsA("Frame") then
        return Gameplay;
    end;

    return nil;
end;

local function ApplyEditorButtonLayout(p66: string) -- Line: 355
    -- upvalues: u10 (ref), u9 (ref), DefaultLayout2 (ref), ApplyMobileButtonLayout (copy)
    local v67 = u10;

    if not (v67 and v67.Parent) then
        v67 = u9;

        if v67 then
            local EditMobile = v67:FindFirstChild("EditMobile");

            if EditMobile then
                v67 = EditMobile;
            elseif v67.Name ~= "EditMobile" then
                v67 = EditMobile;
            end;

            u10 = v67;
        else
            v67 = nil;
        end;
    end;

    local v68;

    if v67 then
        v68 = v67:FindFirstChild("MobileButtons");
    else
        v68 = nil;
    end;

    if not v68 then
        return;
    end;

    local v69 = v68:FindFirstChild(p66);
    local v70 = DefaultLayout2[p66];

    if not (v69 and (v69:IsA("GuiObject") and v70)) then
        return;
    end;

    local v71;

    if v70.Enabled then
        v71 = v70;
    else
        v71 = table.clone(v70);
        v71.Transparency = math.max(v70.Transparency, 0.75);
    end;

    ApplyMobileButtonLayout(v69, v71);
end;

local function ApplyEditorLayout() -- Line: 379
    -- upvalues: Mobile (copy), ApplyEditorButtonLayout (copy)
    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function GetConfigureRefs() -- Line: 400
    -- upvalues: u19 (ref)
    local v72 = u19;

    if not v72 then
        return nil;
    end;

    local Button = v72:FindFirstChild("Button", true);
    local Enabled = v72:FindFirstChild("Enabled");

    if Enabled then
        local Header = Enabled:FindFirstChild("Header");

        if Header then
            Button = Header:FindFirstChild("Button") or Button;
        end;
    end;

    local Transparency = v72:FindFirstChild("Transparency");
    local v73;

    if Transparency then
        v73 = Transparency:FindFirstChild("Slider", true);
    else
        v73 = Transparency;
    end;

    if v73 and not v73:IsA("GuiButton") then
        v73 = v73:FindFirstChild("Slider");
    end;

    if not (Button and (Button:IsA("GuiButton") and (v73 and v73:IsA("GuiButton")))) then
        return nil;
    end;

    local Button2 = v73:FindFirstChild("Button");
    local Bar = v73:FindFirstChild("Bar");

    if not (Button2 and (Button2:IsA("GuiObject") and (Bar and Bar:IsA("GuiObject")))) then
        return nil;
    end;

    if Transparency then
        Transparency = Transparency:FindFirstChild("Amount", true);
    end;

    if Transparency then
        Transparency = Transparency:FindFirstChild("Title");
    end;

    local v74 = {
        Frame = v72,
        EnabledButton = Button,
        EnabledCheck = Button:FindFirstChildWhichIsA("ImageLabel"),
        SliderTrack = v73,
        SliderKnob = Button2,
        SliderBar = Bar
    };

    if not (Transparency and Transparency:IsA("TextBox")) then
        Transparency = nil;
    end;

    v74.ValueBox = Transparency;

    return v74;
end;

local function GetSelectedButtonLayout() -- Line: 445
    -- upvalues: u18 (ref), DefaultLayout2 (ref)
    local v75 = u18;

    if v75 then
        return v75, DefaultLayout2[v75];
    end;

    return nil, nil;
end;

local function RefreshConfigurePanel() -- Line: 455
    -- upvalues: GetConfigureRefs (copy), u18 (ref), DefaultLayout2 (ref), u11 (ref), MAX_TRANSPARENCY (copy)
    local v76 = GetConfigureRefs();

    if not v76 then
        return;
    end;

    local v77 = u18;
    local v78;

    if v77 then
        v78 = DefaultLayout2[v77];
    else
        v77 = nil;
        v78 = nil;
    end;

    if not (u11 and (v77 and v78)) then
        v76.Frame.Visible = false;

        return;
    end;

    v76.Frame.Visible = true;

    if v76.EnabledCheck then
        v76.EnabledCheck.Visible = v78.Enabled;
    end;

    local math_clamp_ret = math.clamp(v78.Transparency / MAX_TRANSPARENCY, 0, 1);
    v76.SliderBar.Size = UDim2.new(math_clamp_ret, 0, v76.SliderBar.Size.Y.Scale, v76.SliderBar.Size.Y.Offset);
    v76.SliderKnob.Position = UDim2.new(math_clamp_ret, 0, v76.SliderKnob.Position.Y.Scale, v76.SliderKnob.Position.Y.Offset);

    if v76.ValueBox and not v76.ValueBox:IsFocused() then
        v76.ValueBox.Text = string.format("%d%%", (math.round(math_clamp_ret * 100)));
    end;
end;

local function SetSelectedButtonTransparency(p79: number) -- Line: 484
    -- upvalues: u18 (ref), DefaultLayout2 (ref), MAX_TRANSPARENCY (copy), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy)
    local v80 = u18;
    local v81;

    if v80 then
        v81 = DefaultLayout2[v80];
    else
        v80 = nil;
        v81 = nil;
    end;

    if not (v80 and v81) then
        return;
    end;

    local v82 = math.clamp(p79, 0, 1) / 0.01;
    local v83 = math.round(v82) * 0.01;
    local v84 = math.clamp(v83, 0, 1) * MAX_TRANSPARENCY;

    if v81.Transparency == v84 then
        return;
    end;

    v81.Transparency = v84;
    ApplyEditorButtonLayout(v80);
    RefreshConfigurePanel();
end;

local function SetSelectedButtonEnabled(p85: boolean) -- Line: 501
    -- upvalues: u18 (ref), DefaultLayout2 (ref), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy)
    local v86 = u18;
    local v87;

    if v86 then
        v87 = DefaultLayout2[v86];
    else
        v86 = nil;
        v87 = nil;
    end;

    if not (v86 and v87) then
        return;
    end;

    v87.Enabled = p85;
    ApplyEditorButtonLayout(v86);
    RefreshConfigurePanel();
end;

local u88 = nil;
local u89 = nil;

local function CreateSelectionHandle(p90: userdata, u91: table) -- Line: 518
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u11 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (copy), u18 (ref), u22 (ref), u24 (ref), u88 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = u91.Name;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(u91.Anchor.X, u91.Anchor.Y);
    Frame.Size = UDim2.fromOffset(17, 17);
    Frame.ZIndex = p90.ZIndex + 2;
    Frame.Active = true;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Square";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromOffset(7, 7);
    Frame2.BackgroundColor3 = Color3_fromRGB_ret;
    Frame2.BorderSizePixel = 0;
    Frame2.ZIndex = Frame.ZIndex;
    Frame2.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 1;
    UIStroke.Color = Color3_fromRGB_ret2;
    UIStroke.Parent = Frame2;
    Frame.MouseEnter:Connect(function() -- Line: 552
        -- upvalues: u11 (ref), u91 (copy), u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u11 then
            u32 = u91.Cursor;
            local v92 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v92 then
                UserInputService.MouseIcon = v92;
            end;
        end;
    end);
    Frame.MouseLeave:Connect(function() -- Line: 557
        -- upvalues: u32 (ref), u91 (copy), u33 (ref), u34 (ref), UserInputService (ref)
        if u32 == u91.Cursor then
            u32 = nil;
            local v93 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v93 then
                UserInputService.MouseIcon = v93;
            end;
        end;
    end);
    Frame.InputBegan:Connect(function(p94: userdata) -- Line: 563
        -- upvalues: u11 (ref), u18 (ref), u22 (ref), u24 (ref), u88 (ref), u91 (copy), u33 (ref), u34 (ref), u32 (ref), UserInputService (ref)
        if not (u11 and u18) then
            return;
        end;

        local v95;

        if p94.UserInputType == Enum.UserInputType.Touch or p94.UserInputType == Enum.UserInputType.MouseButton1 then
            v95 = p94.UserInputState == Enum.UserInputState.Begin;
        else
            v95 = false;
        end;

        if not v95 then
            return;
        end;

        if u22 or u24 then
            return;
        end;

        u88(u18, u91.Anchor, p94);
        u33 = u91.Cursor;
        local v96 = u33 or (u34 or u32 or "");

        if UserInputService.MouseIcon ~= v96 then
            UserInputService.MouseIcon = v96;
        end;
    end);
    Frame.Parent = p90;
end;

local function GetOrCreateSelectionOutline() -- Line: 580
    -- upvalues: u20 (ref), u10 (ref), u9 (ref), Color3_fromRGB_ret3 (copy), u7 (copy), CreateSelectionHandle (copy), u11 (ref), u18 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (copy), u89 (ref), Color3_fromRGB_ret4 (copy)
    if u20 and u20.Parent then
        return u20;
    end;

    local v97 = u10;

    if not (v97 and v97.Parent) then
        v97 = u9;

        if v97 then
            local EditMobile = v97:FindFirstChild("EditMobile");

            if EditMobile then
                v97 = EditMobile;
            elseif v97.Name ~= "EditMobile" then
                v97 = EditMobile;
            end;

            u10 = v97;
        else
            v97 = nil;
        end;
    end;

    local v98;

    if v97 then
        v98 = v97:FindFirstChild("MobileButtons");
    else
        v98 = nil;
    end;

    if not v98 then
        return nil;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "Selection";
    Frame.AnchorPoint = Vector2.new(0, 0);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 50;
    Frame.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "Stroke";
    UIStroke.Thickness = 2;
    UIStroke.Color = Color3_fromRGB_ret3;
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke.Parent = Frame;

    for _, v in ipairs(u7) do
        CreateSelectionHandle(Frame, v);
    end;

    Frame.Active = true;
    Frame.MouseEnter:Connect(function() -- Line: 614
        -- upvalues: u11 (ref), u18 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u11 and u18 then
            u32 = "rbxasset://SystemCursors/SizeAll";
            local v99 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v99 then
                UserInputService.MouseIcon = v99;
            end;
        end;
    end);
    Frame.MouseLeave:Connect(function() -- Line: 619
        -- upvalues: u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u32 == "rbxasset://SystemCursors/SizeAll" then
            u32 = nil;
            local v100 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v100 then
                UserInputService.MouseIcon = v100;
            end;
        end;
    end);
    Frame.InputBegan:Connect(function(p101: userdata) -- Line: 624
        -- upvalues: u11 (ref), u18 (ref), u89 (ref)
        if u11 and u18 then
            local v102;

            if p101.UserInputType == Enum.UserInputType.Touch or p101.UserInputType == Enum.UserInputType.MouseButton1 then
                v102 = p101.UserInputState == Enum.UserInputState.Begin;
            else
                v102 = false;
            end;

            if v102 then
                u89(u18, p101);
            end;
        end;
    end);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "SizeLabel";
    TextLabel.AnchorPoint = Vector2.new(1, 0);
    TextLabel.Position = UDim2.new(1, 0, 1, 7);
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
    TextLabel.Size = UDim2.fromOffset(0, 0);
    TextLabel.BackgroundColor3 = Color3_fromRGB_ret4;
    TextLabel.BorderSizePixel = 0;
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.Font = Enum.Font.GothamMedium;
    TextLabel.TextSize = 12;
    TextLabel.Text = "";
    TextLabel.ZIndex = Frame.ZIndex + 1;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingLeft = UDim.new(0, 6);
    UIPadding.PaddingRight = UDim.new(0, 6);
    UIPadding.PaddingTop = UDim.new(0, 2);
    UIPadding.PaddingBottom = UDim.new(0, 2);
    UIPadding.Parent = TextLabel;
    TextLabel.Parent = Frame;
    Frame.Parent = v98;
    u20 = Frame;

    return Frame;
end;

local function UpdateSelectionOutline() -- Line: 661
    -- upvalues: GetOrCreateSelectionOutline (copy), u10 (ref), u9 (ref), u18 (ref), u11 (ref), DefaultLayout2 (ref)
    local v103 = GetOrCreateSelectionOutline();
    local v104 = u10;

    if not (v104 and v104.Parent) then
        v104 = u9;

        if v104 then
            local EditMobile = v104:FindFirstChild("EditMobile");

            if EditMobile then
                v104 = EditMobile;
            elseif v104.Name ~= "EditMobile" then
                v104 = EditMobile;
            end;

            u10 = v104;
        else
            v104 = nil;
        end;
    end;

    local v105;

    if v104 then
        v105 = v104:FindFirstChild("MobileButtons");
    else
        v105 = nil;
    end;

    local v106 = u18;

    if not (v103 and v105) then
        return;
    end;

    local v107;

    if v106 then
        v107 = v105:FindFirstChild(v106);
    else
        v107 = v106;
    end;

    if not (u11 and (v107 and v107:IsA("GuiObject"))) then
        v103.Visible = false;

        return;
    end;

    local v108 = v107.AbsolutePosition - v105.AbsolutePosition;
    v103.Position = UDim2.fromOffset(v108.X - 4, v108.Y - 4);
    v103.Size = UDim2.fromOffset(v107.AbsoluteSize.X + 8, v107.AbsoluteSize.Y + 8);
    local SizeLabel = v103:FindFirstChild("SizeLabel");

    if SizeLabel then
        if v106 then
            v106 = DefaultLayout2[v106];
        end;

        if v106 then
            local v109 = `%.{3}f x %.{3}f`;
            SizeLabel.Text = string.format(v109, v106.Size.X, v106.Size.Y);
        else
            SizeLabel.Text = "";
        end;
    end;

    v103.Visible = true;
end;

local u110 = nil;

local function SelectEditorButton(p111: string?) -- Line: 699
    -- upvalues: u18 (ref), RefreshConfigurePanel (copy), u110 (ref), u11 (ref), GetOrCreateSelectionOutline (copy), UpdateSelectionOutline (copy), RunService (copy), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    u18 = p111;
    RefreshConfigurePanel();

    if u110 then
        u110:Disconnect();
        u110 = nil;
    end;

    if p111 and u11 then
        if GetOrCreateSelectionOutline() then
            UpdateSelectionOutline();
            u110 = RunService.RenderStepped:Connect(UpdateSelectionOutline);
        end;
    else
        u22 = nil;
        u33 = nil;
        local v112 = u33 or (u34 or u32 or "");

        if UserInputService.MouseIcon ~= v112 then
            UserInputService.MouseIcon = v112;
        end;

        if u20 then
            u20.Visible = false;
        end;
    end;
end;

local function SetupConfigurePanel(p113: userdata) -- Line: 726
    -- upvalues: u19 (ref), GetConfigureRefs (copy), ActivateButton (copy), u18 (ref), DefaultLayout2 (ref), Router (copy), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy), SetSelectedButtonTransparency (copy), u21 (ref), GuiService (copy), UserInputService (copy)
    local Configure = p113:FindFirstChild("Configure");

    if not (Configure and Configure:IsA("Frame")) then
        warn("[MobileHUDEditor] EditMobile.Configure frame not found; transparency / enabled editing unavailable");

        return;
    end;

    u19 = Configure;
    Configure.Visible = false;
    local v114 = GetConfigureRefs();

    if not v114 then
        warn("[MobileHUDEditor] EditMobile.Configure is missing its Enabled button or slider parts");

        return;
    end;

    ActivateButton(v114.EnabledButton);
    v114.EnabledButton.MouseButton1Click:Connect(function() -- Line: 743
        -- upvalues: u18 (ref), DefaultLayout2 (ref), Router (ref), ApplyEditorButtonLayout (ref), RefreshConfigurePanel (ref)
        local v115 = u18;
        local v116;

        if v115 then
            v116 = DefaultLayout2[v115];
        else
            v116 = nil;
        end;

        if v116 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            local v117 = not v116.Enabled;
            local v118 = u18;
            local v119;

            if v118 then
                v119 = DefaultLayout2[v118];
            else
                v118 = nil;
                v119 = nil;
            end;

            if v118 then
                if not v119 then
                    return;
                end;

                v119.Enabled = v117;
                ApplyEditorButtonLayout(v118);
                RefreshConfigurePanel();
            end;
        end;
    end);
    local SliderTrack = v114.SliderTrack;
    local SliderKnob = v114.SliderKnob;
    SliderTrack.AutoButtonColor = false;

    if SliderKnob:IsA("GuiButton") then
        SliderKnob.AutoButtonColor = false;
    end;

    local function IsPointerInput(p120: userdata) -- Line: 759
        return p120.UserInputType == Enum.UserInputType.MouseButton1 and true or p120.UserInputType == Enum.UserInputType.Touch;
    end;

    local function SetFromScreenX(p121: number) -- Line: 763
        -- upvalues: SliderTrack (copy), SetSelectedButtonTransparency (ref)
        local math_max_ret = math.max(SliderTrack.AbsoluteSize.X, 1);
        SetSelectedButtonTransparency((math.clamp((p121 - SliderTrack.AbsolutePosition.X) / math_max_ret, 0, 1)));
    end;

    local function BeginSliderDrag(p122: userdata) -- Line: 769
        -- upvalues: u21 (ref), GuiService (ref), SliderTrack (copy), SetSelectedButtonTransparency (ref)
        if p122.UserInputType ~= Enum.UserInputType.MouseButton1 and p122.UserInputType ~= Enum.UserInputType.Touch or u21 then
            return;
        end;

        u21 = p122;
        local GuiInset = GuiService:GetGuiInset();
        local X = Vector2.new(p122.Position.X - GuiInset.X, p122.Position.Y - GuiInset.Y).X;
        local math_max_ret = math.max(SliderTrack.AbsoluteSize.X, 1);
        SetSelectedButtonTransparency((math.clamp((X - SliderTrack.AbsolutePosition.X) / math_max_ret, 0, 1)));
    end;

    SliderTrack.InputBegan:Connect(BeginSliderDrag);
    SliderKnob.InputBegan:Connect(BeginSliderDrag);
    UserInputService.InputChanged:Connect(function(p123: userdata) -- Line: 780
        -- upvalues: u21 (ref), GuiService (ref), SliderTrack (copy), SetSelectedButtonTransparency (ref)
        local v124 = u21;

        if not v124 then
            return;
        end;

        if p123 == v124 or v124.UserInputType == Enum.UserInputType.MouseButton1 and p123.UserInputType == Enum.UserInputType.MouseMovement then
            local GuiInset = GuiService:GetGuiInset();
            local X = Vector2.new(p123.Position.X - GuiInset.X, p123.Position.Y - GuiInset.Y).X;
            local math_max_ret = math.max(SliderTrack.AbsoluteSize.X, 1);
            SetSelectedButtonTransparency((math.clamp((X - SliderTrack.AbsolutePosition.X) / math_max_ret, 0, 1)));
        end;
    end);
    UserInputService.InputEnded:Connect(function(p125: userdata) -- Line: 791
        -- upvalues: u21 (ref)
        local v126 = u21;

        if not v126 then
            return;
        end;

        if p125 == v126 or v126.UserInputType == Enum.UserInputType.MouseButton1 and p125.UserInputType == Enum.UserInputType.MouseButton1 then
            u21 = nil;
        end;
    end);
    local ValueBox = v114.ValueBox;

    if ValueBox then
        ValueBox.FocusLost:Connect(function() -- Line: 804
            -- upvalues: ValueBox (copy), SetSelectedButtonTransparency (ref), RefreshConfigurePanel (ref)
            local string_gsub_ret = string.gsub(ValueBox.Text, "[^%d%.]", "");
            local v127 = tonumber(string_gsub_ret);

            if v127 then
                SetSelectedButtonTransparency(v127 / 100);
            end;

            RefreshConfigurePanel();
        end);
    end;
end;

local function HideDashboardPanels() -- Line: 816
    -- upvalues: u9 (ref), u10 (ref), u14 (copy)
    local v128 = u9;
    local v129 = u10;

    if not (v129 and v129.Parent) then
        v129 = u9;

        if v129 then
            local EditMobile = v129:FindFirstChild("EditMobile");

            if EditMobile then
                v129 = EditMobile;
            elseif v129.Name ~= "EditMobile" then
                v129 = EditMobile;
            end;

            u10 = v129;
        else
            v129 = nil;
        end;
    end;

    if not v128 then
        return;
    end;

    for _, child in ipairs(v128:GetChildren()) do
        if child ~= v129 and (child:IsA("GuiObject") and child.Visible) then
            u14[child] = true;
            child.Visible = false;
        end;
    end;
end;

local function RestoreDashboardPanels() -- Line: 835
    -- upvalues: u14 (copy)
    for i in pairs(u14) do
        if i.Parent then
            i.Visible = true;
        end;
    end;

    table.clear(u14);
end;

local function SetDashboardEditorVisibility(p130: boolean) -- Line: 847
    -- upvalues: u10 (ref), u9 (ref), u8 (ref), MenuState (copy), HideDashboardPanels (copy), u14 (copy)
    local v131 = u10;

    if not (v131 and v131.Parent) then
        v131 = u9;

        if v131 then
            local EditMobile = v131:FindFirstChild("EditMobile");

            if EditMobile then
                v131 = EditMobile;
            elseif v131.Name ~= "EditMobile" then
                v131 = EditMobile;
            end;

            u10 = v131;
        else
            v131 = nil;
        end;
    end;

    if v131 then
        v131.Visible = p130;

        if v131 then
            local Action = v131:FindFirstChild("Action");

            if Action and Action:IsA("Frame") then
                Action.Visible = p130;
            end;
        end;

        if v131 then
            local MobileButtons = v131:FindFirstChild("MobileButtons");

            if MobileButtons and MobileButtons:IsA("Frame") then
                MobileButtons.Visible = p130;
            end;
        end;
    end;

    local v132 = u8 and u8:FindFirstChild("Menu");
    local v133 = v132 and v132:IsA("Frame") and v132:FindFirstChild("Top");

    if not (v133 and v133:IsA("Frame")) then
        v133 = nil;
    end;

    if v133 then
        if p130 then
            v133.Visible = false;
        elseif not (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive()) then
            v133.Visible = true;
        end;
    end;

    if p130 then
        HideDashboardPanels();

        return;
    end;

    for i in pairs(u14) do
        if i.Parent then
            i.Visible = true;
        end;
    end;

    table.clear(u14);
end;

local function EnforceEditorVisibilityLock() -- Line: 873
    -- upvalues: u11 (ref), u8 (ref), u14 (copy)
    if not u11 then
        return;
    end;

    local v134 = u8 and u8:FindFirstChild("Menu");
    local v135 = v134 and v134:IsA("Frame") and v134:FindFirstChild("Top");

    if not (v135 and v135:IsA("Frame")) then
        v135 = nil;
    end;

    if v135 and v135.Visible then
        v135.Visible = false;
    end;

    for i in pairs(u14) do
        if i.Visible then
            i.Visible = false;
        end;
    end;
end;

local function ConnectEditorVisibilityGuards() -- Line: 892
    -- upvalues: u13 (ref), u9 (ref), u8 (ref), EnforceEditorVisibilityLock (copy), u10 (ref)
    if u13 then
        return;
    end;

    local v136 = u9;
    local v137 = u8 and u8:FindFirstChild("Menu");
    local v138 = v137 and v137:IsA("Frame") and v137:FindFirstChild("Top");

    if not (v138 and v138:IsA("Frame")) then
        v138 = nil;
    end;

    if not (v136 or v138) then
        return;
    end;

    u13 = true;

    if v138 then
        v138:GetPropertyChangedSignal("Visible"):Connect(EnforceEditorVisibilityLock);
    end;

    if v136 then
        local v139 = u10;

        if not (v139 and v139.Parent) then
            v139 = u9;

            if v139 then
                local EditMobile = v139:FindFirstChild("EditMobile");

                if EditMobile then
                    v139 = EditMobile;
                elseif v139.Name ~= "EditMobile" then
                    v139 = EditMobile;
                end;

                u10 = v139;
            else
                v139 = nil;
            end;
        end;

        for _, child in ipairs(v136:GetChildren()) do
            if child ~= v139 and child:IsA("GuiObject") then
                child:GetPropertyChangedSignal("Visible"):Connect(EnforceEditorVisibilityLock);
            end;
        end;
    end;
end;

local function ClearEditorInteractionState() -- Line: 921
    -- upvalues: u15 (ref), u16 (ref), u17 (ref), u23 (ref), u24 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy)
    u15 = {};
    u16 = {};
    u17 = {};
    u23 = nil;
    u24 = nil;
    u22 = nil;
    u33 = nil;
    local v140 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v140 then
        UserInputService.MouseIcon = v140;
    end;

    u34 = nil;
    local v141 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v141 then
        UserInputService.MouseIcon = v141;
    end;

    u32 = nil;
    local v142 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v142 then
        UserInputService.MouseIcon = v142;
    end;
end;

local function RemoveTouchFromButton(p143: userdata) -- Line: 935
    -- upvalues: u15 (ref), u16 (ref)
    local v144 = u15[p143];

    if not v144 then
        return nil;
    end;

    u15[p143] = nil;
    local v145 = u16[v144];

    if v145 then
        v145[p143] = nil;

        if next(v145) == nil then
            u16[v144] = nil;
        end;
    end;

    return v144;
end;

local function GetButtonTouches(p146: string) -- Line: 955
    -- upvalues: u16 (ref)
    local v147 = u16[p146];

    if not v147 then
        return {};
    end;

    local v148 = {};

    for i in pairs(v147) do
        table.insert(v148, i);
    end;

    return v148;
end;

local function UpdateEditorButtonLayout(p149: string, p150: any) -- Line: 971
    -- upvalues: DefaultLayout2 (ref), Mobile (copy), ApplyEditorButtonLayout (copy)
    local v151 = DefaultLayout2[p149] or Mobile.GetDefaultButtonLayout(p149);
    local ClampButtonLayout = Mobile.ClampButtonLayout;
    local v152 = {
        Position = p150.Position,
        Size = p150.Size
    };
    local v153;

    if p150.Transparency == nil then
        v153 = v151.Transparency;
    else
        v153 = p150.Transparency;
    end;

    v152.Transparency = v153;
    local v154;

    if p150.Enabled == nil then
        v154 = v151.Enabled;
    else
        v154 = p150.Enabled;
    end;

    v152.Enabled = v154;
    DefaultLayout2[p149] = ClampButtonLayout(v152);
    ApplyEditorButtonLayout(p149);
end;

local function StartEditorDrag(p155: string, p156: userdata) -- Line: 984
    -- upvalues: DefaultLayout2 (ref), u24 (ref), u34 (ref), u33 (ref), u32 (ref), UserInputService (copy), u23 (ref), GuiService (copy), CopyPositionAndSize (copy)
    local v157 = DefaultLayout2[p155];

    if not v157 then
        return;
    end;

    u24 = nil;

    if p156.UserInputType == Enum.UserInputType.MouseButton1 then
        u34 = "rbxasset://SystemCursors/SizeAll";
        local v158 = u33 or u34 or (u32 or "");

        if UserInputService.MouseIcon ~= v158 then
            UserInputService.MouseIcon = v158;
        end;
    end;

    local v159 = {
        buttonName = p155,
        input = p156
    };
    local GuiInset = GuiService:GetGuiInset();
    v159.startPosition = Vector2.new(p156.Position.X - GuiInset.X, p156.Position.Y - GuiInset.Y);
    v159.startLayout = CopyPositionAndSize(v157);
    u23 = v159;
end;

local function StartEditorPinch(p160: string, p161: userdata, p162: userdata) -- Line: 1005
    -- upvalues: DefaultLayout2 (ref), u10 (ref), u9 (ref), u23 (ref), u24 (ref), CopyPositionAndSize (copy)
    local v163 = DefaultLayout2[p160];

    if not v163 then
        return;
    end;

    local v164 = u10;

    if not (v164 and v164.Parent) then
        v164 = u9;

        if v164 then
            local EditMobile = v164:FindFirstChild("EditMobile");

            if EditMobile then
                v164 = EditMobile;
            elseif v164.Name ~= "EditMobile" then
                v164 = EditMobile;
            end;

            u10 = v164;
        else
            v164 = nil;
        end;
    end;

    local v165;

    if v164 then
        v165 = v164:FindFirstChild("MobileButtons");
    else
        v165 = nil;
    end;

    if not v165 then
        return;
    end;

    local AbsoluteSize = v165.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local Vector2_new_ret = Vector2.new(p161.Position.X, p161.Position.Y);
    local AbsolutePosition = v165.AbsolutePosition;
    local Magnitude = (Vector2.new(p162.Position.X, p162.Position.Y) - Vector2_new_ret).Magnitude;
    local math_max_ret = math.max(Magnitude, 1);
    local Vector2_new_ret2 = Vector2.new((Vector2_new_ret.X - AbsolutePosition.X) / AbsoluteSize.X, (Vector2_new_ret.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
    local v166 = v163.Size.Y <= 0 and 0.5 or (Vector2_new_ret2.Y - v163.Position.Y) / v163.Size.Y;
    u23 = nil;
    u24 = {
        buttonName = p160,
        anchorInput = p161,
        scaleInput = p162,
        anchorLocalScale = Vector2.new(math.clamp(v163.Size.X <= 0 and 0.5 or (Vector2_new_ret2.X - v163.Position.X) / v163.Size.X, 0, 1), (math.clamp(v166, 0, 1))),
        lastDistance = math_max_ret,
        lastLayout = CopyPositionAndSize(v163)
    };
end;

u88 = function(p167: string, p168, p169: userdata) -- Line: 1056
    -- upvalues: DefaultLayout2 (ref), u23 (ref), u24 (ref), u22 (ref), GuiService (copy)
    local v170 = DefaultLayout2[p167];

    if not v170 then
        return;
    end;

    u23 = nil;
    u24 = nil;
    local v171 = {
        buttonName = p167,
        input = p169,
        handleAnchor = p168
    };
    local GuiInset = GuiService:GetGuiInset();
    v171.startPosition = Vector2.new(p169.Position.X - GuiInset.X, p169.Position.Y - GuiInset.Y);
    v171.startLayout = {
        Position = {
            X = v170.Position.X,
            Y = v170.Position.Y
        },
        Size = {
            X = v170.Size.X,
            Y = v170.Size.Y
        },
        Transparency = v170.Transparency,
        Enabled = v170.Enabled
    };
    u22 = v171;
end;

local function UpdateResizeFromInput(p172: userdata) -- Line: 1078
    -- upvalues: u22 (ref), u10 (ref), u9 (ref), GuiService (copy), Mobile (copy), UpdateEditorButtonLayout (copy)
    local v173 = u22;

    if v173 then
        local input = v173.input;
        local v174;

        if p172 == input then
            v174 = true;
        else
            local UserInputType = p172.UserInputType;
            local UserInputType2 = input.UserInputType;
            v174 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
        end;

        if v174 then
            local v175 = u10;

            if not (v175 and v175.Parent) then
                v175 = u9;

                if v175 then
                    local EditMobile = v175:FindFirstChild("EditMobile");

                    if EditMobile then
                        v175 = EditMobile;
                    elseif v175.Name ~= "EditMobile" then
                        v175 = EditMobile;
                    end;

                    u10 = v175;
                else
                    v175 = nil;
                end;
            end;

            local v176;

            if v175 then
                v176 = v175:FindFirstChild("MobileButtons");
            else
                v176 = nil;
            end;

            if not v176 then
                return;
            end;

            local AbsoluteSize = v176.AbsoluteSize;

            if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                return;
            end;

            local GuiInset = GuiService:GetGuiInset();
            local v177 = Vector2.new(p172.Position.X - GuiInset.X, p172.Position.Y - GuiInset.Y) - v173.startPosition;
            local Vector2_new_ret = Vector2.new(v177.X / AbsoluteSize.X, v177.Y / AbsoluteSize.Y);
            local startLayout = v173.startLayout;
            local handleAnchor = v173.handleAnchor;
            local v178 = v176:FindFirstChild(v173.buttonName);
            local v179;

            if v178 and v178:IsA("GuiObject") then
                v179 = v178.AnchorPoint;
            else
                v179 = Vector2.new(0.5, 0.5);
            end;

            local function resolveSize(p180: number, p181: number, p182: number) -- Line: 1105
                -- upvalues: Mobile (ref)
                if p180 >= 1 then
                    return math.clamp(p181 + p182, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                end;

                if p180 <= 0 then
                    return math.clamp(p181 - p182, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                end;

                return p181;
            end;

            local function resolvePosition(p183: number, p184: number, p185: number, p186: number, p187: number) -- Line: 1115
                if p183 >= 1 then
                    return p185 + p184 * (p187 - p186);
                end;

                if p183 <= 0 then
                    return p185 + (1 - p184) * (p186 - p187);
                end;

                return p185;
            end;

            local X = handleAnchor.X;
            local X2 = startLayout.Size.X;
            local X3 = Vector2_new_ret.X;

            if X >= 1 then
                X2 = math.clamp(X2 + X3, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
            elseif X <= 0 then
                X2 = math.clamp(X2 - X3, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
            end;

            local Y = handleAnchor.Y;
            local Y2 = startLayout.Size.Y;
            local Y3 = Vector2_new_ret.Y;

            if Y >= 1 then
                Y2 = math.clamp(Y2 + Y3, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
            elseif Y <= 0 then
                Y2 = math.clamp(Y2 - Y3, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
            end;

            local v188;

            if v178 == nil then
                v188 = false;
            else
                v188 = v178:FindFirstChildWhichIsA("UIAspectRatioConstraint", true) ~= nil;
            end;

            if v188 and (startLayout.Size.X > 0 and startLayout.Size.Y > 0) then
                local v189 = startLayout.Size.Y / startLayout.Size.X;
                local v190 = handleAnchor.X ~= 0.5;
                local v191 = handleAnchor.Y ~= 0.5;

                if v190 then
                    v190 = not v191 or math.abs(v177.X) >= math.abs(v177.Y);
                end;

                if v190 then
                    Y2 = math.clamp(X2 * v189, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                    X2 = Y2 / v189;
                else
                    X2 = math.clamp(Y2 / v189, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                    Y2 = X2 * v189;
                end;
            end;

            local X4 = handleAnchor.X;
            local X5 = v179.X;
            local X6 = startLayout.Position.X;
            local X7 = startLayout.Size.X;

            if X4 >= 1 then
                X6 = X6 + X5 * (X2 - X7);
            elseif X4 <= 0 then
                X6 = X6 + (1 - X5) * (X7 - X2);
            end;

            local Y4 = handleAnchor.Y;
            local Y5 = v179.Y;
            local Y6 = startLayout.Position.Y;
            local Y7 = startLayout.Size.Y;

            if Y4 >= 1 then
                Y6 = Y6 + Y5 * (Y2 - Y7);
            elseif Y4 <= 0 then
                Y6 = Y6 + (1 - Y5) * (Y7 - Y2);
            end;

            UpdateEditorButtonLayout(v173.buttonName, {
                Position = {
                    X = X6,
                    Y = Y6
                },
                Size = {
                    X = X2,
                    Y = Y2
                }
            });
        end;
    end;
end;

local function TryStartEditorPinchWithSecondTouch(p192: userdata) -- Line: 1157
    -- upvalues: u23 (ref), u24 (ref), StartEditorPinch (copy)
    local v193 = u23;

    if not (v193 and (not u24 and v193.input ~= p192)) then
        return;
    end;

    StartEditorPinch(v193.buttonName, v193.input, p192);
end;

local function RefreshEditorInteraction(p194: string) -- Line: 1168
    -- upvalues: u24 (ref), GetButtonTouches (copy), u23 (ref), StartEditorDrag (copy), u34 (ref), u33 (ref), u32 (ref), UserInputService (copy)
    if u24 and u24.buttonName == p194 then
        return;
    end;

    local v195 = GetButtonTouches(p194);

    if #v195 <= 0 then
        if u23 and u23.buttonName == p194 then
            u23 = nil;
            u34 = nil;
            local v196 = u33 or u34 or (u32 or "");

            if UserInputService.MouseIcon ~= v196 then
                UserInputService.MouseIcon = v196;
            end;
        end;

        if u24 and u24.buttonName == p194 then
            u24 = nil;
        end;

        return;
    end;

    local v197 = v195[1];
    local v198 = u23;

    if v198 and v198.buttonName == p194 then
        for _, v in ipairs(v195) do
            if v == v198.input then
                v197 = v;
                break;
            end;
        end;
    end;

    StartEditorDrag(p194, v197);
end;

local function UpdateDragFromInput(p199: userdata) -- Line: 1201
    -- upvalues: u23 (ref), u10 (ref), u9 (ref), DefaultLayout2 (ref), GuiService (copy), UpdateEditorButtonLayout (copy)
    local v200 = u23;

    if v200 then
        local input = v200.input;
        local v201;

        if p199 == input then
            v201 = true;
        else
            local UserInputType = p199.UserInputType;
            local UserInputType2 = input.UserInputType;
            v201 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
        end;

        if v201 then
            local v202 = u10;

            if not (v202 and v202.Parent) then
                v202 = u9;

                if v202 then
                    local EditMobile = v202:FindFirstChild("EditMobile");

                    if EditMobile then
                        v202 = EditMobile;
                    elseif v202.Name ~= "EditMobile" then
                        v202 = EditMobile;
                    end;

                    u10 = v202;
                else
                    v202 = nil;
                end;
            end;

            local v203;

            if v202 then
                v203 = v202:FindFirstChild("MobileButtons");
            else
                v203 = nil;
            end;

            local v204 = DefaultLayout2[v200.buttonName];

            if not (v203 and v204) then
                return;
            end;

            local AbsoluteSize = v203.AbsoluteSize;

            if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                return;
            end;

            local GuiInset = GuiService:GetGuiInset();
            local v205 = Vector2.new(p199.Position.X - GuiInset.X, p199.Position.Y - GuiInset.Y) - v200.startPosition;
            UpdateEditorButtonLayout(v200.buttonName, {
                Position = {
                    X = v200.startLayout.Position.X + v205.X / AbsoluteSize.X,
                    Y = v200.startLayout.Position.Y + v205.Y / AbsoluteSize.Y
                },
                Size = {
                    X = v204.Size.X,
                    Y = v204.Size.Y
                }
            });
        end;
    end;
end;

local function UpdatePinchFromInput(p206: userdata) -- Line: 1231
    -- upvalues: u24 (ref), u10 (ref), u9 (ref), UpdateEditorButtonLayout (copy), DefaultLayout2 (ref), CopyPositionAndSize (copy)
    local v207 = u24;

    if not (v207 and (p206 == v207.scaleInput or p206 == v207.anchorInput)) then
        return;
    end;

    local anchorInput = v207.anchorInput;
    local Vector2_new_ret = Vector2.new(anchorInput.Position.X, anchorInput.Position.Y);
    local scaleInput = v207.scaleInput;
    local Vector2_new_ret2 = Vector2.new(scaleInput.Position.X, scaleInput.Position.Y);
    local math_max_ret = math.max((Vector2_new_ret2 - Vector2_new_ret).Magnitude, 1);
    local v208 = math_max_ret / math.max(v207.lastDistance, 1);
    local v209 = v207.lastLayout.Size.X * v208;
    local v210 = v207.lastLayout.Size.Y * v208;
    local v211 = u10;

    if not (v211 and v211.Parent) then
        v211 = u9;

        if v211 then
            local EditMobile = v211:FindFirstChild("EditMobile");

            if EditMobile then
                v211 = EditMobile;
            elseif v211.Name ~= "EditMobile" then
                v211 = EditMobile;
            end;

            u10 = v211;
        else
            v211 = nil;
        end;
    end;

    local v212;

    if v211 then
        v212 = v211:FindFirstChild("MobileButtons");
    else
        v212 = nil;
    end;

    if not v212 then
        return;
    end;

    local AbsoluteSize = v212.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local AbsolutePosition = v212.AbsolutePosition;
    local Vector2_new_ret3 = Vector2.new((Vector2_new_ret.X - AbsolutePosition.X) / AbsoluteSize.X, (Vector2_new_ret.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
    local v213 = Vector2_new_ret3.X - v207.anchorLocalScale.X * v209;
    local v214 = Vector2_new_ret3.Y - v207.anchorLocalScale.Y * v210;

    if v213 ~= v213 or v214 ~= v214 then
        local v215 = (Vector2_new_ret + Vector2_new_ret2) * 0.5;
        local Vector2_new_ret4 = Vector2.new((v215.X - AbsolutePosition.X) / AbsoluteSize.X, (v215.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
        v213 = Vector2_new_ret4.X - v209 / 2;
        v214 = Vector2_new_ret4.Y - v210 / 2;
    end;

    UpdateEditorButtonLayout(v207.buttonName, {
        Position = {
            X = v213,
            Y = v214
        },
        Size = {
            X = v209,
            Y = v210
        }
    });
    local v216 = DefaultLayout2[v207.buttonName];

    if v216 then
        v207.lastLayout = CopyPositionAndSize(v216);
    end;

    v207.lastDistance = math_max_ret;
end;

local function LoadEditorStateFromProfile() -- Line: 1288
    -- upvalues: DataController (copy), LocalPlayer (copy), DefaultLayout (ref), Mobile (copy), DefaultLayout2 (ref), DeepCopyLayout (copy), ApplyEditorButtonLayout (copy)
    local v217 = DataController.Get(LocalPlayer, "MobileButtons");
    DefaultLayout = Mobile.SanitizeLayout(v217);
    DefaultLayout2 = DeepCopyLayout(DefaultLayout);

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function ConnectEditorButtonGesture(p218: userdata) -- Line: 1299
    -- upvalues: u11 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (copy), u89 (ref)
    local Name = p218.Name;
    p218.Active = true;
    p218.MouseEnter:Connect(function() -- Line: 1308
        -- upvalues: u11 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u11 then
            u32 = "rbxasset://SystemCursors/SizeAll";
            local v219 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v219 then
                UserInputService.MouseIcon = v219;
            end;
        end;
    end);
    p218.MouseLeave:Connect(function() -- Line: 1313
        -- upvalues: u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u32 == "rbxasset://SystemCursors/SizeAll" then
            u32 = nil;
            local v220 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v220 then
                UserInputService.MouseIcon = v220;
            end;
        end;
    end);
    p218.InputBegan:Connect(function(p221: userdata) -- Line: 1318
        -- upvalues: u11 (ref), u89 (ref), Name (copy)
        if u11 then
            local v222;

            if p221.UserInputType == Enum.UserInputType.Touch or p221.UserInputType == Enum.UserInputType.MouseButton1 then
                v222 = p221.UserInputState == Enum.UserInputState.Begin;
            else
                v222 = false;
            end;

            if v222 then
                u89(Name, p221);
            end;
        end;
    end);
end;

u89 = function(p223: string, p224: userdata) -- Line: 1328
    -- upvalues: u15 (ref), u22 (ref), u24 (ref), u23 (ref), u16 (ref), u17 (ref), GuiService (copy), u18 (ref), SelectEditorButton (copy), RefreshEditorInteraction (copy)
    if u15[p224] then
        return;
    end;

    if u22 then
        return;
    end;

    local v225 = u24 and u24.buttonName or u23 and u23.buttonName;

    if v225 and v225 ~= p223 then
        return;
    end;

    u15[p224] = p223;
    u16[p223] = u16[p223] or {};
    u16[p223][p224] = true;
    local GuiInset = GuiService:GetGuiInset();
    u17[p224] = Vector2.new(p224.Position.X - GuiInset.X, p224.Position.Y - GuiInset.Y);

    if u18 ~= p223 then
        SelectEditorButton(p223);
    end;

    RefreshEditorInteraction(p223);
end;

local function IsPointInsideGuiObject(p226: userdata?, p227) -- Line: 1356
    if not (p226 and p226.Visible) then
        return false;
    end;

    local AbsolutePosition = p226.AbsolutePosition;
    local v228 = AbsolutePosition + p226.AbsoluteSize;
    local v229;

    if p227.X >= AbsolutePosition.X and (p227.X <= v228.X and p227.Y >= AbsolutePosition.Y) then
        v229 = p227.Y <= v228.Y;
    else
        v229 = false;
    end;

    return v229;
end;

local function TryDeselectFromEmptyTouch(p230: userdata) -- Line: 1367
    -- upvalues: u11 (ref), u18 (ref), u15 (ref), u22 (ref), u24 (ref), u19 (ref), u10 (ref), u9 (ref), RefreshConfigurePanel (copy), u110 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    if not (u11 and u18) then
        return;
    end;

    if u15[p230] then
        return;
    end;

    local v231 = u22;

    if v231 and v231.input == p230 then
        return;
    end;

    local v232 = u24;

    if v232 and (v232.anchorInput == p230 or v232.scaleInput == p230) then
        return;
    end;

    local Vector2_new_ret = Vector2.new(p230.Position.X, p230.Position.Y);
    local v233 = u19;
    local v234;

    if v233 and v233.Visible then
        local AbsolutePosition = v233.AbsolutePosition;
        local v235 = AbsolutePosition + v233.AbsoluteSize;

        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= v235.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
            v234 = Vector2_new_ret.Y <= v235.Y;
        else
            v234 = false;
        end;
    else
        v234 = false;
    end;

    if v234 then
        return;
    end;

    local v236 = u10;

    if not (v236 and v236.Parent) then
        v236 = u9;

        if v236 then
            local EditMobile = v236:FindFirstChild("EditMobile");

            if EditMobile then
                v236 = EditMobile;
            elseif v236.Name ~= "EditMobile" then
                v236 = EditMobile;
            end;

            u10 = v236;
        else
            v236 = nil;
        end;
    end;

    if v236 then
        v236 = v236:FindFirstChild("Action");
    end;

    if v236 and v236:IsA("GuiObject") then
        local v237;

        if v236 and v236.Visible then
            local AbsolutePosition = v236.AbsolutePosition;
            local v238 = AbsolutePosition + v236.AbsoluteSize;

            if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= v238.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                v237 = Vector2_new_ret.Y <= v238.Y;
            else
                v237 = false;
            end;
        else
            v237 = false;
        end;

        if v237 then
            return;
        end;
    end;

    u18 = nil;
    RefreshConfigurePanel();

    if u110 then
        u110:Disconnect();
        u110 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v239 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v239 then
        UserInputService.MouseIcon = v239;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function FindEquippedLoadoutItem(p240: string, p241: string, p242: string) -- Line: 1400
    -- upvalues: DataController (copy), LocalPlayer (copy), u3 (copy)
    local v243 = DataController.Get(LocalPlayer, "Loadout");
    local u244 = DataController.Get(LocalPlayer, "Inventory");
    local v245;

    if typeof(v243) == "table" then
        v245 = v243[p240];
    else
        v245 = false;
    end;

    if typeof(v245) ~= "table" or typeof(u244) ~= "table" then
        return nil;
    end;

    local function findInventoryItem(p246: any, p247: string?) -- Line: 1408
        -- upvalues: u244 (copy)
        if typeof(p246) ~= "string" or p246 == "" then
            return nil;
        end;

        for _, v in ipairs(u244) do
            if typeof(v) == "table" and (v._id == p246 and (p247 == nil or v.Name == p247)) then
                return v;
            end;
        end;

        return nil;
    end;

    if p241 == "Melee" then
        local Equipped = v245.Equipped;

        return typeof(Equipped) == "table" and findInventoryItem(Equipped["Equipped Melee"], nil) or nil;
    end;

    local v248 = u3[p241];

    if typeof(v245.Loadout) == "table" then
        if v248 then
            v248 = v245.Loadout[v248];
        end;
    else
        v248 = false;
    end;

    if typeof(v248) ~= "table" or typeof(v248.Options) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v248.Options) do
        local v249 = findInventoryItem(v, p242);

        if v249 then
            return v249;
        end;
    end;

    return nil;
end;

local function GetLoadoutPreviewIcon(p250: string, p251: any) -- Line: 1443
    -- upvalues: Skins (copy), GetWeaponProperties (copy)
    if p251 then
        p250 = p251.Name or p250;
    end;

    local v252 = p251 and typeof(p251.Skin) == "string" and (p251.Skin or "Stock") or "Stock";
    local SkinInformation = Skins.GetSkinInformation(p250, v252);

    if SkinInformation then
        if SkinInformation.wearImages and SkinInformation.wearImages[1] then
            return SkinInformation.wearImages[1].assetId;
        end;

        if SkinInformation.imageAssetId then
            return SkinInformation.imageAssetId;
        end;
    end;

    local v253 = GetWeaponProperties(p250);

    return v253 and v253.Icon or nil;
end;

local function SetEditorSlotIcon(p254: userdata, p255: string, p256: string?) -- Line: 1462
    local v257 = p254:FindFirstChild(p255);

    if v257 then
        v257 = v257:FindFirstChild("WeaponImage");
    end;

    if v257 and v257:IsA("ImageLabel") then
        v257.Image = p256 or "";
        v257.Visible = p256 ~= nil;
    end;
end;

local function ApplyEditorLoadoutPreview() -- Line: 1473
    -- upvalues: u10 (ref), u9 (ref), u4 (copy), Skins (copy), GetWeaponProperties (copy), ReplicatedStorage (copy), u2 (copy), LocalPlayer (copy), DataController (copy), FindEquippedLoadoutItem (copy), GetLoadoutPreviewIcon (copy)
    local v258 = u10;

    if not (v258 and v258.Parent) then
        v258 = u9;

        if v258 then
            local EditMobile = v258:FindFirstChild("EditMobile");

            if EditMobile then
                v258 = EditMobile;
            elseif v258.Name ~= "EditMobile" then
                v258 = EditMobile;
            end;

            u10 = v258;
        else
            v258 = nil;
        end;
    end;

    local v259;

    if v258 then
        v259 = v258:FindFirstChild("MobileButtons");
    else
        v259 = nil;
    end;

    if not v259 then
        return;
    end;

    for i, v in pairs(u4) do
        local SkinInformation = Skins.GetSkinInformation(v, "Stock");
        local v260, v261;

        if SkinInformation then
            if SkinInformation.wearImages and SkinInformation.wearImages[1] then
                v260 = SkinInformation.wearImages[1].assetId;
            elseif SkinInformation.imageAssetId then
                v260 = SkinInformation.imageAssetId;
            else
                v261 = GetWeaponProperties(v);
                v260 = v261 and v261.Icon or nil;
            end;
        else
            v261 = GetWeaponProperties(v);
            v260 = v261 and v261.Icon or nil;
        end;

        local v262 = v259:FindFirstChild(i);

        if v262 then
            v262 = v262:FindFirstChild("WeaponImage");
        end;

        if v262 and v262:IsA("ImageLabel") then
            v262.Image = v260 or "";
            v262.Visible = v260 ~= nil;
        end;
    end;

    local MenuCharacterTeam = require(ReplicatedStorage.Controllers.MenuSceneController).GetMenuCharacterTeam();

    if not (MenuCharacterTeam and u2[MenuCharacterTeam]) then
        local Attribute = LocalPlayer:GetAttribute("Team");
        MenuCharacterTeam = (typeof(Attribute) ~= "string" or not u2[Attribute]) and "Counter-Terrorists" or Attribute;
    end;

    for i, v in pairs(u2[MenuCharacterTeam]) do
        local v263;

        if DataController.IsDataLoaded(LocalPlayer) then
            v263 = FindEquippedLoadoutItem(MenuCharacterTeam, i, v);
        else
            v263 = nil;
        end;

        local v264 = GetLoadoutPreviewIcon(v, v263);
        local v265 = v259:FindFirstChild(i);

        if v265 then
            v265 = v265:FindFirstChild("WeaponImage");
        end;

        if v265 and v265:IsA("ImageLabel") then
            v265.Image = v264 or "";
            v265.Visible = v264 ~= nil;
        end;
    end;
end;

local function ConvertGuiButtonToFrame(p266: userdata) -- Line: 1508
    local Frame = Instance.new("Frame");
    Frame.Name = p266.Name;
    Frame.AnchorPoint = p266.AnchorPoint;
    Frame.Position = p266.Position;
    Frame.Size = p266.Size;
    Frame.SizeConstraint = p266.SizeConstraint;
    Frame.Rotation = p266.Rotation;
    Frame.ZIndex = p266.ZIndex;
    Frame.LayoutOrder = p266.LayoutOrder;
    Frame.Visible = p266.Visible;
    Frame.BackgroundColor3 = p266.BackgroundColor3;
    Frame.BackgroundTransparency = p266.BackgroundTransparency;
    Frame.BorderSizePixel = p266.BorderSizePixel;
    Frame.ClipsDescendants = p266.ClipsDescendants;

    for _, child in ipairs(p266:GetChildren()) do
        child.Parent = Frame;
    end;

    return Frame;
end;

local function ConvertTreeButtonsToFrames(p267: userdata) -- Line: 1529
    -- upvalues: ConvertGuiButtonToFrame (copy)
    for _, descendant in ipairs(p267:GetDescendants()) do
        if descendant:IsA("GuiButton") then
            ConvertGuiButtonToFrame(descendant).Parent = descendant.Parent;
            descendant:Destroy();
        end;
    end;

    if not p267:IsA("GuiButton") then
        return p267;
    end;

    local v268 = ConvertGuiButtonToFrame(p267);
    p267:Destroy();

    return v268;
end;

local function PopulateEditorButtons() -- Line: 1547
    -- upvalues: u10 (ref), u9 (ref), GetGameplayMobileButtonsFrame (copy), Mobile (copy), RunService (copy), LocalPlayer (copy), ConvertTreeButtonsToFrames (copy), ConnectEditorButtonGesture (copy), ApplyEditorLoadoutPreview (copy)
    local v269 = u10;

    if not (v269 and v269.Parent) then
        v269 = u9;

        if v269 then
            local EditMobile = v269:FindFirstChild("EditMobile");

            if EditMobile then
                v269 = EditMobile;
            elseif v269.Name ~= "EditMobile" then
                v269 = EditMobile;
            end;

            u10 = v269;
        else
            v269 = nil;
        end;
    end;

    local v270;

    if v269 then
        v270 = v269:FindFirstChild("MobileButtons");
    else
        v270 = nil;
    end;

    local v271 = GetGameplayMobileButtonsFrame();

    if not (v270 and v271) then
        return;
    end;

    for _, child in ipairs(v270:GetChildren()) do
        if child:IsA("GuiObject") and Mobile.IsKnownButton(child.Name) then
            child:Destroy();
        end;
    end;

    for _, v in ipairs(Mobile.GetButtonNames()) do
        local v272 = v271:FindFirstChild(v);

        if v272 and v272:IsA("GuiObject") then
            local v273, v274, v275, v276, v277, v278;

            if v == "VIP" then
                local v279;

                if RunService:IsStudio() then
                    v279 = true;
                elseif workspace:GetAttribute("IsVIPServer") == true then
                    v279 = LocalPlayer:GetAttribute("CanUseVIPMenu") == true;
                else
                    v279 = false;
                end;

                if v279 then
                    v273 = v272:Clone();
                    v273.Visible = true;
                    v274 = v273:FindFirstChild("Toggled");

                    if v274 and v274:IsA("GuiObject") then
                        v274.Visible = false;
                    end;

                    v275 = v273:FindFirstChild("Equipped");

                    if v275 and v275:IsA("GuiObject") then
                        v275.Visible = false;
                    end;

                    v276 = v273:FindFirstChild("Use");

                    if v276 and v276:IsA("GuiObject") then
                        v276.Visible = true;
                    end;

                    v277 = v273:FindFirstChild("Defuse");

                    if v277 and v277:IsA("GuiObject") then
                        v277.Visible = false;
                    end;

                    v278 = ConvertTreeButtonsToFrames(v273);
                    v278.Parent = v270;
                    ConnectEditorButtonGesture(v278);
                end;
            else
                v273 = v272:Clone();
                v273.Visible = true;
                v274 = v273:FindFirstChild("Toggled");

                if v274 and v274:IsA("GuiObject") then
                    v274.Visible = false;
                end;

                v275 = v273:FindFirstChild("Equipped");

                if v275 and v275:IsA("GuiObject") then
                    v275.Visible = false;
                end;

                v276 = v273:FindFirstChild("Use");

                if v276 and v276:IsA("GuiObject") then
                    v276.Visible = true;
                end;

                v277 = v273:FindFirstChild("Defuse");

                if v277 and v277:IsA("GuiObject") then
                    v277.Visible = false;
                end;

                v278 = ConvertTreeButtonsToFrames(v273);
                v278.Parent = v270;
                ConnectEditorButtonGesture(v278);
            end;
        end;
    end;

    ApplyEditorLoadoutPreview();
end;

local function SetEditorMode(p280: boolean) -- Line: 1606
    -- upvalues: u11 (ref), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u110 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    u11 = p280;
    SetDashboardEditorVisibility(p280);

    if p280 then
        RefreshConfigurePanel();
    else
        ClearEditorInteractionState();
        u18 = nil;
        RefreshConfigurePanel();

        if u110 then
            u110:Disconnect();
            u110 = nil;
        end;

        u22 = nil;
        u33 = nil;
        local v281 = u33 or (u34 or u32 or "");

        if UserInputService.MouseIcon ~= v281 then
            UserInputService.MouseIcon = v281;
        end;

        if u20 then
            u20.Visible = false;
        end;
    end;
end;

local function EnterMobileHUDEditor() -- Line: 1619
    -- upvalues: GetUserPlatform (copy), UserInputService (copy), u11 (ref), u12 (ref), DataController (copy), LocalPlayer (copy), Router (copy), ClearEditorInteractionState (copy), u10 (ref), u9 (ref), Mobile (copy), PopulateEditorButtons (copy), DefaultLayout (ref), DefaultLayout2 (ref), DeepCopyLayout (copy), ApplyEditorButtonLayout (copy), ApplyEditorLoadoutPreview (copy), u8 (ref), HideDashboardPanels (copy), RefreshConfigurePanel (copy)
    local v282 = GetUserPlatform();
    local v283;

    if table.find(v282, "Mobile") == nil then
        v283 = false;
    else
        v283 = #v282 <= 1;
    end;

    if not (v283 or (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService:GetLastInputType() == Enum.UserInputType.Touch)) then
        return;
    end;

    if u11 or u12 then
        return;
    end;

    u12 = true;
    local success = pcall(function() -- Line: 1629
        -- upvalues: DataController (ref), LocalPlayer (ref)
        DataController.WaitForDataLoaded(LocalPlayer);
    end);
    u12 = false;

    if not success then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Profile data is still loading. Please try again.");

        return;
    end;

    ClearEditorInteractionState();
    local v284 = u10;

    if not (v284 and v284.Parent) then
        v284 = u9;

        if v284 then
            local EditMobile = v284:FindFirstChild("EditMobile");

            if EditMobile then
                v284 = EditMobile;
            elseif v284.Name ~= "EditMobile" then
                v284 = EditMobile;
            end;

            u10 = v284;
        else
            v284 = nil;
        end;
    end;

    local v285;

    if v284 then
        v285 = v284:FindFirstChild("MobileButtons");
    else
        v285 = nil;
    end;

    local v286 = false;

    if v285 then
        for _, v in ipairs(Mobile.GetButtonNames()) do
            if v285:FindFirstChild(v) then
                v286 = true;
                break;
            end;
        end;
    end;

    if not (v285 and v286) then
        PopulateEditorButtons();
    end;

    local v287 = DataController.Get(LocalPlayer, "MobileButtons");
    DefaultLayout = Mobile.SanitizeLayout(v287);
    DefaultLayout2 = DeepCopyLayout(DefaultLayout);

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;

    ApplyEditorLoadoutPreview();
    u11 = true;
    local v288 = u10;

    if not (v288 and v288.Parent) then
        v288 = u9;

        if v288 then
            local EditMobile = v288:FindFirstChild("EditMobile");

            if EditMobile then
                v288 = EditMobile;
            elseif v288.Name ~= "EditMobile" then
                v288 = EditMobile;
            end;

            u10 = v288;
        else
            v288 = nil;
        end;
    end;

    if v288 then
        v288.Visible = true;

        if v288 then
            local Action = v288:FindFirstChild("Action");

            if Action and Action:IsA("Frame") then
                Action.Visible = true;
            end;
        end;

        if v288 then
            local MobileButtons = v288:FindFirstChild("MobileButtons");

            if MobileButtons and MobileButtons:IsA("Frame") then
                MobileButtons.Visible = true;
            end;
        end;
    end;

    local v289 = u8 and u8:FindFirstChild("Menu");
    local v290 = v289 and v289:IsA("Frame") and v289:FindFirstChild("Top");

    if not (v290 and v290:IsA("Frame")) then
        v290 = nil;
    end;

    if v290 then
        v290.Visible = false;
    end;

    HideDashboardPanels();
    RefreshConfigurePanel();
end;

local function ExitMobileHUDEditor(p291: boolean) -- Line: 1663
    -- upvalues: u11 (ref), DefaultLayout2 (ref), DeepCopyLayout (copy), DefaultLayout (ref), Mobile (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u110 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    if not u11 then
        return;
    end;

    if not p291 then
        DefaultLayout2 = DeepCopyLayout(DefaultLayout);

        for _, v in ipairs(Mobile.GetButtonNames()) do
            ApplyEditorButtonLayout(v);
        end;
    end;

    u11 = false;
    SetDashboardEditorVisibility(false);
    ClearEditorInteractionState();
    u18 = nil;
    RefreshConfigurePanel();

    if u110 then
        u110:Disconnect();
        u110 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v292 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v292 then
        UserInputService.MouseIcon = v292;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function UpdateEditMobileButtonVisibility(p293) -- Line: 1678
    -- upvalues: GetEditMobileEntryButton (copy), GetUserPlatform (copy), UserInputService (copy), u11 (ref), MenuState (copy), SetDashboardEditorVisibility (copy)
    local v294 = GetEditMobileEntryButton();
    local v295;

    if v294 then
        v295 = v294.Parent;
    else
        v295 = v294;
    end;

    local v296 = GetUserPlatform();
    local v297;

    if table.find(v296, "Mobile") == nil then
        v297 = false;
    else
        v297 = #v296 <= 1;
    end;

    local v298 = v297 or (UserInputService.PreferredInput == Enum.PreferredInput.Touch and true or (p293 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch);

    if v294 then
        v294.Visible = v298;
    end;

    if v295 and v295:IsA("GuiObject") then
        v295.Visible = v298;
    end;

    if not (v298 or (u11 or (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive()))) then
        SetDashboardEditorVisibility(false);
    end;
end;

local function ResetEditorToDefaults() -- Line: 1700
    -- upvalues: DefaultLayout2 (ref), Mobile (copy), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy)
    DefaultLayout2 = Mobile.GetDefaultLayout();

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;

    RefreshConfigurePanel();
end;

local function ApplyLayoutToGameplayButtons(p299) -- Line: 1708
    -- upvalues: GetGameplayMobileButtonsFrame (copy), Mobile (copy), ApplyMobileButtonLayout (copy)
    local v300 = GetGameplayMobileButtonsFrame();

    if not v300 then
        return;
    end;

    for _, v in ipairs(Mobile.GetButtonNames()) do
        local v301 = v300:FindFirstChild(v);
        local v302 = p299[v];

        if v301 and (v301:IsA("GuiObject") and v302) then
            ApplyMobileButtonLayout(v301, v302);
        end;
    end;
end;

local function CommitEditorChanges() -- Line: 1727
    -- upvalues: Mobile (copy), DefaultLayout2 (ref), DeepCopyLayout (copy), DefaultLayout (ref), ApplyLayoutToGameplayButtons (copy), Remotes (copy)
    local v303 = Mobile.SanitizeLayout(DefaultLayout2);
    DefaultLayout2 = DeepCopyLayout(v303);
    DefaultLayout = DeepCopyLayout(v303);
    ApplyLayoutToGameplayButtons(v303);
    Remotes.Player.UpdateMobileButtons.Send({
        Layout = v303
    });
end;

local function HasEditorLayoutChanges() -- Line: 1741
    -- upvalues: Mobile (copy), DefaultLayout2 (ref), DefaultLayout (ref)
    local v304 = Mobile.SanitizeLayout(DefaultLayout2);
    local v305 = Mobile.SanitizeLayout(DefaultLayout);

    return not Mobile.AreLayoutsEqual(v304, v305);
end;

local function ConnectActionButton(p306: userdata, p307: string, p308: function) -- Line: 1749
    -- upvalues: ActivateButton (copy)
    local v309 = p306:FindFirstChild(p307);

    if not (v309 and v309:IsA("GuiButton")) then
        return;
    end;

    ActivateButton(v309);
    v309.MouseButton1Click:Connect(p308);
end;

local function HandleConfirmPressed() -- Line: 1761
    -- upvalues: u11 (ref), Router (copy), Mobile (copy), DefaultLayout2 (ref), DefaultLayout (ref), CommitEditorChanges (copy), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u110 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    if not u11 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    local v310 = Mobile.SanitizeLayout(DefaultLayout2);
    local v311 = Mobile.SanitizeLayout(DefaultLayout);

    if not Mobile.AreLayoutsEqual(v310, v311) then
        CommitEditorChanges();
    end;

    if not u11 then
        return;
    end;

    u11 = false;
    SetDashboardEditorVisibility(false);
    ClearEditorInteractionState();
    u18 = nil;
    RefreshConfigurePanel();

    if u110 then
        u110:Disconnect();
        u110 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v312 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v312 then
        UserInputService.MouseIcon = v312;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function HandleResetPressed() -- Line: 1775
    -- upvalues: u11 (ref), Router (copy), DefaultLayout2 (ref), Mobile (copy), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy)
    if not u11 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    DefaultLayout2 = Mobile.GetDefaultLayout();

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;

    RefreshConfigurePanel();
end;

local function HandleBackPressed() -- Line: 1785
    -- upvalues: u11 (ref), Router (copy), DefaultLayout2 (ref), DeepCopyLayout (copy), DefaultLayout (ref), Mobile (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u110 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    if not u11 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");

    if not u11 then
        return;
    end;

    DefaultLayout2 = DeepCopyLayout(DefaultLayout);

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;

    u11 = false;
    SetDashboardEditorVisibility(false);
    ClearEditorInteractionState();
    u18 = nil;
    RefreshConfigurePanel();

    if u110 then
        u110:Disconnect();
        u110 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v313 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v313 then
        UserInputService.MouseIcon = v313;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function SetupEditMobileEntryButton() -- Line: 1795
    -- upvalues: GetEditMobileEntryButton (copy), ActivateButton (copy), Router (copy), EnterMobileHUDEditor (copy)
    local v314 = GetEditMobileEntryButton();

    if not v314 then
        return;
    end;

    ActivateButton(v314);
    v314.MouseButton1Click:Connect(function() -- Line: 1802
        -- upvalues: Router (ref), EnterMobileHUDEditor (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        EnterMobileHUDEditor();
    end);
end;

local function SetupEditorControls() -- Line: 1810
    -- upvalues: u10 (ref), u9 (ref), HandleConfirmPressed (copy), ActivateButton (copy), HandleResetPressed (copy), HandleBackPressed (copy), SetupConfigurePanel (copy), PopulateEditorButtons (copy)
    local v315 = u10;

    if not (v315 and v315.Parent) then
        v315 = u9;

        if v315 then
            local EditMobile = v315:FindFirstChild("EditMobile");

            if EditMobile then
                v315 = EditMobile;
            elseif v315.Name ~= "EditMobile" then
                v315 = EditMobile;
            end;

            u10 = v315;
        else
            v315 = nil;
        end;
    end;

    if not v315 then
        return;
    end;

    local Action = v315:FindFirstChild("Action");

    if Action and Action:IsA("Frame") then
        local v316 = HandleConfirmPressed;
        local Confirm = Action:FindFirstChild("Confirm");

        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm);
            Confirm.MouseButton1Click:Connect(v316);
        end;

        local v317 = HandleResetPressed;
        local Reset = Action:FindFirstChild("Reset");

        if Reset and Reset:IsA("GuiButton") then
            ActivateButton(Reset);
            Reset.MouseButton1Click:Connect(v317);
        end;

        local v318 = HandleBackPressed;
        local Back = Action:FindFirstChild("Back");

        if Back and Back:IsA("GuiButton") then
            ActivateButton(Back);
            Back.MouseButton1Click:Connect(v318);
        end;
    end;

    SetupConfigurePanel(v315);
    PopulateEditorButtons();
end;

local function ConnectGlobalInputHandlers() -- Line: 1830
    -- upvalues: UserInputService (copy), UpdateEditMobileButtonVisibility (copy), ReplicatedStorage (copy), ApplyEditorLoadoutPreview (copy), DataController (copy), LocalPlayer (copy), Skins (copy), u11 (ref), u23 (ref), u24 (ref), StartEditorPinch (copy), TryDeselectFromEmptyTouch (copy), u22 (ref), UpdateResizeFromInput (copy), UpdatePinchFromInput (copy), UpdateDragFromInput (copy), u33 (ref), u34 (ref), u32 (ref), u15 (ref), u16 (ref), u17 (ref), GuiService (copy), SelectEditorButton (copy), StartEditorDrag (copy), RefreshEditorInteraction (copy)
    UserInputService.LastInputTypeChanged:Connect(function(p319) -- Line: 1831
        -- upvalues: UpdateEditMobileButtonVisibility (ref)
        UpdateEditMobileButtonVisibility(p319);
    end);
    require(ReplicatedStorage.Controllers.MenuSceneController).MenuCharacterChanged:Connect(function() -- Line: 1837
        -- upvalues: ApplyEditorLoadoutPreview (ref)
        ApplyEditorLoadoutPreview();
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1840
        -- upvalues: ApplyEditorLoadoutPreview (ref)
        ApplyEditorLoadoutPreview();
    end);
    Skins.OnItemStockSchemasUpdated:Connect(function() -- Line: 1844
        -- upvalues: ApplyEditorLoadoutPreview (ref)
        ApplyEditorLoadoutPreview();
    end);
    UserInputService.InputBegan:Connect(function(p320: userdata) -- Line: 1848
        -- upvalues: u11 (ref), u23 (ref), u24 (ref), StartEditorPinch (ref), TryDeselectFromEmptyTouch (ref)
        if not u11 then
            return;
        end;

        local v321;

        if p320.UserInputType == Enum.UserInputType.Touch or p320.UserInputType == Enum.UserInputType.MouseButton1 then
            v321 = p320.UserInputState == Enum.UserInputState.Begin;
        else
            v321 = false;
        end;

        if not v321 then
            return;
        end;

        if p320.UserInputType == Enum.UserInputType.Touch then
            local v322 = u23;

            if v322 and (not u24 and v322.input ~= p320) then
                StartEditorPinch(v322.buttonName, v322.input, p320);
            end;
        end;

        task.defer(TryDeselectFromEmptyTouch, p320);
    end);
    UserInputService.InputChanged:Connect(function(p323: userdata) -- Line: 1863
        -- upvalues: u11 (ref), u22 (ref), UpdateResizeFromInput (ref), u24 (ref), UpdatePinchFromInput (ref), u23 (ref), UpdateDragFromInput (ref)
        if not (u11 and (p323.UserInputType == Enum.UserInputType.Touch or p323.UserInputType == Enum.UserInputType.MouseMovement)) then
            return;
        end;

        if u22 then
            UpdateResizeFromInput(p323);

            return;
        end;

        if u24 then
            UpdatePinchFromInput(p323);

            return;
        end;

        if u23 then
            UpdateDragFromInput(p323);
        end;
    end);
    UserInputService.InputEnded:Connect(function(p324: userdata) -- Line: 1879
        -- upvalues: u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (ref), u24 (ref), u15 (ref), u16 (ref), u17 (ref), GuiService (ref), SelectEditorButton (ref), u23 (ref), StartEditorDrag (ref), RefreshEditorInteraction (ref)
        if p324.UserInputType ~= Enum.UserInputType.Touch and p324.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v325 = u22;

        if v325 then
            local input = v325.input;
            local v326;

            if p324 == input then
                v326 = true;
            else
                local UserInputType = p324.UserInputType;
                local UserInputType2 = input.UserInputType;
                v326 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
            end;

            if v326 then
                u22 = nil;
                u33 = nil;
                local v327 = u33 or (u34 or u32 or "");

                if UserInputService.MouseIcon ~= v327 then
                    UserInputService.MouseIcon = v327;
                end;

                return;
            end;
        end;

        local v328 = false;
        local v329 = nil;
        local v330 = u24;
        local v331;

        if v330 and (p324 == v330.anchorInput or p324 == v330.scaleInput) then
            v331 = v330.buttonName;

            if p324 == v330.scaleInput then
                v329 = v330.anchorInput;
                v328 = true;
            end;

            u24 = nil;
        else
            v331 = nil;
        end;

        local v332 = u15[p324];

        if v332 then
            u15[p324] = nil;
            local v333 = u16[v332];

            if v333 then
                v333[p324] = nil;

                if next(v333) == nil then
                    u16[v332] = nil;
                end;
            end;
        else
            v332 = nil;
        end;

        local v334 = u17[p324];
        u17[p324] = nil;

        if v332 and (not v331 and v334) then
            local GuiInset = GuiService:GetGuiInset();

            if (Vector2.new(p324.Position.X - GuiInset.X, p324.Position.Y - GuiInset.Y) - v334).Magnitude <= 12 then
                SelectEditorButton(v332);
            end;
        end;

        local v335 = u23;

        if v335 then
            local input = v335.input;
            local v336;

            if p324 == input then
                v336 = true;
            else
                local UserInputType = p324.UserInputType;
                local UserInputType2 = input.UserInputType;
                v336 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
            end;

            if v336 then
                u23 = nil;
                u34 = nil;
                local v337 = u33 or u34 or (u32 or "");

                if UserInputService.MouseIcon ~= v337 then
                    UserInputService.MouseIcon = v337;
                end;
            end;
        end;

        local v338 = v332 or v331;

        if v328 and (v329 and (v338 and u15[v329] == v338)) then
            StartEditorDrag(v338, v329);
        end;

        if v338 then
            RefreshEditorInteraction(v338);
        end;
    end);
end;

function v1.Initialize(p339: userdata, p340: userdata) -- Line: 1940
    -- upvalues: u8 (ref), u9 (ref), u10 (ref), ConnectEditorVisibilityGuards (copy), SetDashboardEditorVisibility (copy), UpdateEditMobileButtonVisibility (copy), UserInputService (copy), GetEditMobileEntryButton (copy), ActivateButton (copy), Router (copy), EnterMobileHUDEditor (copy), SetupEditorControls (copy), ConnectGlobalInputHandlers (copy)
    u8 = p339;
    local EditMobile = p340:FindFirstChild("EditMobile");
    local v341;

    if p340.Name == "EditMobile" then
        v341 = p340.Parent;

        if v341 then
            if not v341:IsA("Frame") then
                v341 = p340;
            end;
        else
            v341 = p340;
        end;
    else
        v341 = p340;
        p340 = EditMobile;
    end;

    u9 = v341;
    u10 = p340;
    ConnectEditorVisibilityGuards();
    SetDashboardEditorVisibility(false);
    UpdateEditMobileButtonVisibility(UserInputService:GetLastInputType());
    local v342 = GetEditMobileEntryButton();

    if v342 then
        ActivateButton(v342);
        v342.MouseButton1Click:Connect(function() -- Line: 1802
            -- upvalues: Router (ref), EnterMobileHUDEditor (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            EnterMobileHUDEditor();
        end);
    end;

    SetupEditorControls();
    ConnectGlobalInputHandlers();
end;

function v1.ShouldShowEntryButton(p343) -- Line: 1968
    -- upvalues: GetUserPlatform (copy), UserInputService (copy)
    local v344 = GetUserPlatform();
    local v345;

    if table.find(v344, "Mobile") == nil then
        v345 = false;
    else
        v345 = #v344 <= 1;
    end;

    return v345 or (UserInputService.PreferredInput == Enum.PreferredInput.Touch and true or (p343 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch);
end;

function v1.Open() -- Line: 1974
    -- upvalues: EnterMobileHUDEditor (copy)
    EnterMobileHUDEditor();
end;

return v1;