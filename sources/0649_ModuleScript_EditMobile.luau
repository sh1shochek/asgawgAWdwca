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

local function ShouldShowMobileHUDEditor(p44) -- Line: 210
    -- upvalues: GetUserPlatform (copy), UserInputService (copy)
    local v45 = GetUserPlatform();
    local v46;

    if table.find(v45, "Mobile") == nil then
        v46 = false;
    else
        v46 = #v45 <= 1;
    end;

    return v46 or (p44 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch;
end;

local function CopyPositionAndSize(p47) -- Line: 217
    return {
        Position = {
            X = p47.Position.X,
            Y = p47.Position.Y
        },
        Size = {
            X = p47.Size.X,
            Y = p47.Size.Y
        }
    };
end;

local function DeepCopyLayout(p48) -- Line: 224
    -- upvalues: Mobile (copy), CopyPositionAndSize (copy)
    local v49 = {};

    for _, v in ipairs(Mobile.GetButtonNames()) do
        local v50 = p48[v] or Mobile.GetDefaultButtonLayout(v);
        local v51 = CopyPositionAndSize(v50);
        v51.Transparency = v50.Transparency;
        v51.Enabled = v50.Enabled;
        v49[v] = v51;
    end;

    return v49;
end;

local function GetInputGuiPosition(p52: userdata) -- Line: 238
    -- upvalues: GuiService (copy)
    local GuiInset = GuiService:GetGuiInset();

    return Vector2.new(p52.Position.X - GuiInset.X, p52.Position.Y - GuiInset.Y);
end;

local function GetInputScreenPosition(p53: userdata) -- Line: 245
    return Vector2.new(p53.Position.X, p53.Position.Y);
end;

local function SetChildFrameVisible(p54: userdata?, p55: string, p56: boolean) -- Line: 251
    if not p54 then
        return;
    end;

    local v57 = p54:FindFirstChild(p55);

    if v57 and v57:IsA("Frame") then
        v57.Visible = p56;
    end;
end;

local function PlayUIClick() -- Line: 263
    -- upvalues: Router (copy)
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
end;

local function GetEditMobileEntryButton() -- Line: 269
    -- upvalues: u9 (ref)
    local v58 = u9 and u9:FindFirstChild("Holder");
    local v59 = v58 and v58:IsA("Frame") and v58:FindFirstChild("EditMobile");

    if v59 and v59:IsA("Frame") then
        return v59:FindFirstChild("EditMobile");
    end;

    return nil;
end;

local function GetEditMobileFrame() -- Line: 281
    -- upvalues: u10 (ref), u9 (ref)
    local v60 = u10;

    if v60 and v60.Parent then
        return v60;
    end;

    local v61 = u9;

    if not v61 then
        return nil;
    end;

    local EditMobile = v61:FindFirstChild("EditMobile");

    if EditMobile then
        v61 = EditMobile;
    elseif v61.Name ~= "EditMobile" then
        v61 = EditMobile;
    end;

    u10 = v61;

    return v61;
end;

local function GetMenuTopFrame() -- Line: 302
    -- upvalues: u8 (ref)
    local v62 = u8 and u8:FindFirstChild("Menu");
    local v63 = v62 and v62:IsA("Frame") and v62:FindFirstChild("Top");

    if v63 and v63:IsA("Frame") then
        return v63;
    end;

    return nil;
end;

local function GetEditorButtonsFrame() -- Line: 310
    -- upvalues: u10 (ref), u9 (ref)
    local v64 = u10;

    if not (v64 and v64.Parent) then
        v64 = u9;

        if v64 then
            local EditMobile = v64:FindFirstChild("EditMobile");

            if EditMobile then
                v64 = EditMobile;
            elseif v64.Name ~= "EditMobile" then
                v64 = EditMobile;
            end;

            u10 = v64;
        else
            v64 = nil;
        end;
    end;

    if v64 then
        return v64:FindFirstChild("MobileButtons");
    end;

    return nil;
end;

local function GetGameplayMobileButtonsFrame() -- Line: 320
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

local function ApplyEditorButtonLayout(p65: string) -- Line: 341
    -- upvalues: u10 (ref), u9 (ref), DefaultLayout2 (ref), ApplyMobileButtonLayout (copy)
    local v66 = u10;

    if not (v66 and v66.Parent) then
        v66 = u9;

        if v66 then
            local EditMobile = v66:FindFirstChild("EditMobile");

            if EditMobile then
                v66 = EditMobile;
            elseif v66.Name ~= "EditMobile" then
                v66 = EditMobile;
            end;

            u10 = v66;
        else
            v66 = nil;
        end;
    end;

    local v67;

    if v66 then
        v67 = v66:FindFirstChild("MobileButtons");
    else
        v67 = nil;
    end;

    if not v67 then
        return;
    end;

    local v68 = v67:FindFirstChild(p65);
    local v69 = DefaultLayout2[p65];

    if not (v68 and (v68:IsA("GuiObject") and v69)) then
        return;
    end;

    local v70;

    if v69.Enabled then
        v70 = v69;
    else
        v70 = table.clone(v69);
        v70.Transparency = math.max(v69.Transparency, 0.75);
    end;

    ApplyMobileButtonLayout(v68, v70);
end;

local function ApplyEditorLayout() -- Line: 365
    -- upvalues: Mobile (copy), ApplyEditorButtonLayout (copy)
    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function GetConfigureRefs() -- Line: 386
    -- upvalues: u19 (ref)
    local v71 = u19;

    if not v71 then
        return nil;
    end;

    local Button = v71:FindFirstChild("Button", true);
    local Enabled = v71:FindFirstChild("Enabled");

    if Enabled then
        local Header = Enabled:FindFirstChild("Header");

        if Header then
            Button = Header:FindFirstChild("Button") or Button;
        end;
    end;

    local Transparency = v71:FindFirstChild("Transparency");
    local v72;

    if Transparency then
        v72 = Transparency:FindFirstChild("Slider", true);
    else
        v72 = Transparency;
    end;

    if v72 and not v72:IsA("GuiButton") then
        v72 = v72:FindFirstChild("Slider");
    end;

    if not (Button and (Button:IsA("GuiButton") and (v72 and v72:IsA("GuiButton")))) then
        return nil;
    end;

    local Button2 = v72:FindFirstChild("Button");
    local Bar = v72:FindFirstChild("Bar");

    if not (Button2 and (Button2:IsA("GuiObject") and (Bar and Bar:IsA("GuiObject")))) then
        return nil;
    end;

    if Transparency then
        Transparency = Transparency:FindFirstChild("Amount", true);
    end;

    if Transparency then
        Transparency = Transparency:FindFirstChild("Title");
    end;

    local v73 = {
        Frame = v71,
        EnabledButton = Button,
        EnabledCheck = Button:FindFirstChildWhichIsA("ImageLabel"),
        SliderTrack = v72,
        SliderKnob = Button2,
        SliderBar = Bar
    };

    if not (Transparency and Transparency:IsA("TextBox")) then
        Transparency = nil;
    end;

    v73.ValueBox = Transparency;

    return v73;
end;

local function GetSelectedButtonLayout() -- Line: 431
    -- upvalues: u18 (ref), DefaultLayout2 (ref)
    local v74 = u18;

    if v74 then
        return v74, DefaultLayout2[v74];
    end;

    return nil, nil;
end;

local function RefreshConfigurePanel() -- Line: 441
    -- upvalues: GetConfigureRefs (copy), u18 (ref), DefaultLayout2 (ref), u11 (ref), MAX_TRANSPARENCY (copy)
    local v75 = GetConfigureRefs();

    if not v75 then
        return;
    end;

    local v76 = u18;
    local v77;

    if v76 then
        v77 = DefaultLayout2[v76];
    else
        v76 = nil;
        v77 = nil;
    end;

    if not (u11 and (v76 and v77)) then
        v75.Frame.Visible = false;

        return;
    end;

    v75.Frame.Visible = true;

    if v75.EnabledCheck then
        v75.EnabledCheck.Visible = v77.Enabled;
    end;

    local math_clamp_ret = math.clamp(v77.Transparency / MAX_TRANSPARENCY, 0, 1);
    v75.SliderBar.Size = UDim2.new(math_clamp_ret, 0, v75.SliderBar.Size.Y.Scale, v75.SliderBar.Size.Y.Offset);
    v75.SliderKnob.Position = UDim2.new(math_clamp_ret, 0, v75.SliderKnob.Position.Y.Scale, v75.SliderKnob.Position.Y.Offset);

    if v75.ValueBox and not v75.ValueBox:IsFocused() then
        v75.ValueBox.Text = string.format("%d%%", (math.round(math_clamp_ret * 100)));
    end;
end;

local function SetSelectedButtonTransparency(p78: number) -- Line: 470
    -- upvalues: u18 (ref), DefaultLayout2 (ref), MAX_TRANSPARENCY (copy), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy)
    local v79 = u18;
    local v80;

    if v79 then
        v80 = DefaultLayout2[v79];
    else
        v79 = nil;
        v80 = nil;
    end;

    if not (v79 and v80) then
        return;
    end;

    local v81 = math.clamp(p78, 0, 1) / 0.01;
    local v82 = math.round(v81) * 0.01;
    local v83 = math.clamp(v82, 0, 1) * MAX_TRANSPARENCY;

    if v80.Transparency == v83 then
        return;
    end;

    v80.Transparency = v83;
    ApplyEditorButtonLayout(v79);
    RefreshConfigurePanel();
end;

local function SetSelectedButtonEnabled(p84: boolean) -- Line: 487
    -- upvalues: u18 (ref), DefaultLayout2 (ref), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy)
    local v85 = u18;
    local v86;

    if v85 then
        v86 = DefaultLayout2[v85];
    else
        v85 = nil;
        v86 = nil;
    end;

    if not (v85 and v86) then
        return;
    end;

    v86.Enabled = p84;
    ApplyEditorButtonLayout(v85);
    RefreshConfigurePanel();
end;

local u87 = nil;
local u88 = nil;

local function CreateSelectionHandle(p89: userdata, u90: table) -- Line: 504
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u11 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (copy), u18 (ref), u22 (ref), u24 (ref), u87 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = u90.Name;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(u90.Anchor.X, u90.Anchor.Y);
    Frame.Size = UDim2.fromOffset(17, 17);
    Frame.ZIndex = p89.ZIndex + 2;
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
    Frame.MouseEnter:Connect(function() -- Line: 538
        -- upvalues: u11 (ref), u90 (copy), u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u11 then
            u32 = u90.Cursor;
            local v91 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v91 then
                UserInputService.MouseIcon = v91;
            end;
        end;
    end);
    Frame.MouseLeave:Connect(function() -- Line: 543
        -- upvalues: u32 (ref), u90 (copy), u33 (ref), u34 (ref), UserInputService (ref)
        if u32 == u90.Cursor then
            u32 = nil;
            local v92 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v92 then
                UserInputService.MouseIcon = v92;
            end;
        end;
    end);
    Frame.InputBegan:Connect(function(p93: userdata) -- Line: 549
        -- upvalues: u11 (ref), u18 (ref), u22 (ref), u24 (ref), u87 (ref), u90 (copy), u33 (ref), u34 (ref), u32 (ref), UserInputService (ref)
        if not (u11 and u18) then
            return;
        end;

        local v94;

        if p93.UserInputType == Enum.UserInputType.Touch or p93.UserInputType == Enum.UserInputType.MouseButton1 then
            v94 = p93.UserInputState == Enum.UserInputState.Begin;
        else
            v94 = false;
        end;

        if not v94 then
            return;
        end;

        if u22 or u24 then
            return;
        end;

        u87(u18, u90.Anchor, p93);
        u33 = u90.Cursor;
        local v95 = u33 or (u34 or u32 or "");

        if UserInputService.MouseIcon ~= v95 then
            UserInputService.MouseIcon = v95;
        end;
    end);
    Frame.Parent = p89;
end;

local function GetOrCreateSelectionOutline() -- Line: 566
    -- upvalues: u20 (ref), u10 (ref), u9 (ref), Color3_fromRGB_ret3 (copy), u7 (copy), CreateSelectionHandle (copy), u11 (ref), u18 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (copy), u88 (ref), Color3_fromRGB_ret4 (copy)
    if u20 and u20.Parent then
        return u20;
    end;

    local v96 = u10;

    if not (v96 and v96.Parent) then
        v96 = u9;

        if v96 then
            local EditMobile = v96:FindFirstChild("EditMobile");

            if EditMobile then
                v96 = EditMobile;
            elseif v96.Name ~= "EditMobile" then
                v96 = EditMobile;
            end;

            u10 = v96;
        else
            v96 = nil;
        end;
    end;

    local v97;

    if v96 then
        v97 = v96:FindFirstChild("MobileButtons");
    else
        v97 = nil;
    end;

    if not v97 then
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
    Frame.MouseEnter:Connect(function() -- Line: 600
        -- upvalues: u11 (ref), u18 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u11 and u18 then
            u32 = "rbxasset://SystemCursors/SizeAll";
            local v98 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v98 then
                UserInputService.MouseIcon = v98;
            end;
        end;
    end);
    Frame.MouseLeave:Connect(function() -- Line: 605
        -- upvalues: u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u32 == "rbxasset://SystemCursors/SizeAll" then
            u32 = nil;
            local v99 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v99 then
                UserInputService.MouseIcon = v99;
            end;
        end;
    end);
    Frame.InputBegan:Connect(function(p100: userdata) -- Line: 610
        -- upvalues: u11 (ref), u18 (ref), u88 (ref)
        if u11 and u18 then
            local v101;

            if p100.UserInputType == Enum.UserInputType.Touch or p100.UserInputType == Enum.UserInputType.MouseButton1 then
                v101 = p100.UserInputState == Enum.UserInputState.Begin;
            else
                v101 = false;
            end;

            if v101 then
                u88(u18, p100);
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
    Frame.Parent = v97;
    u20 = Frame;

    return Frame;
end;

local function UpdateSelectionOutline() -- Line: 647
    -- upvalues: GetOrCreateSelectionOutline (copy), u10 (ref), u9 (ref), u18 (ref), u11 (ref), DefaultLayout2 (ref)
    local v102 = GetOrCreateSelectionOutline();
    local v103 = u10;

    if not (v103 and v103.Parent) then
        v103 = u9;

        if v103 then
            local EditMobile = v103:FindFirstChild("EditMobile");

            if EditMobile then
                v103 = EditMobile;
            elseif v103.Name ~= "EditMobile" then
                v103 = EditMobile;
            end;

            u10 = v103;
        else
            v103 = nil;
        end;
    end;

    local v104;

    if v103 then
        v104 = v103:FindFirstChild("MobileButtons");
    else
        v104 = nil;
    end;

    local v105 = u18;

    if not (v102 and v104) then
        return;
    end;

    local v106;

    if v105 then
        v106 = v104:FindFirstChild(v105);
    else
        v106 = v105;
    end;

    if not (u11 and (v106 and v106:IsA("GuiObject"))) then
        v102.Visible = false;

        return;
    end;

    local v107 = v106.AbsolutePosition - v104.AbsolutePosition;
    v102.Position = UDim2.fromOffset(v107.X - 4, v107.Y - 4);
    v102.Size = UDim2.fromOffset(v106.AbsoluteSize.X + 8, v106.AbsoluteSize.Y + 8);
    local SizeLabel = v102:FindFirstChild("SizeLabel");

    if SizeLabel then
        if v105 then
            v105 = DefaultLayout2[v105];
        end;

        if v105 then
            local v108 = `%.{3}f x %.{3}f`;
            SizeLabel.Text = string.format(v108, v105.Size.X, v105.Size.Y);
        else
            SizeLabel.Text = "";
        end;
    end;

    v102.Visible = true;
end;

local u109 = nil;

local function SelectEditorButton(p110: string?) -- Line: 685
    -- upvalues: u18 (ref), RefreshConfigurePanel (copy), u109 (ref), u11 (ref), GetOrCreateSelectionOutline (copy), UpdateSelectionOutline (copy), RunService (copy), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    u18 = p110;
    RefreshConfigurePanel();

    if u109 then
        u109:Disconnect();
        u109 = nil;
    end;

    if p110 and u11 then
        if GetOrCreateSelectionOutline() then
            UpdateSelectionOutline();
            u109 = RunService.RenderStepped:Connect(UpdateSelectionOutline);
        end;
    else
        u22 = nil;
        u33 = nil;
        local v111 = u33 or (u34 or u32 or "");

        if UserInputService.MouseIcon ~= v111 then
            UserInputService.MouseIcon = v111;
        end;

        if u20 then
            u20.Visible = false;
        end;
    end;
end;

local function SetupConfigurePanel(p112: userdata) -- Line: 712
    -- upvalues: u19 (ref), GetConfigureRefs (copy), ActivateButton (copy), u18 (ref), DefaultLayout2 (ref), Router (copy), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy), SetSelectedButtonTransparency (copy), u21 (ref), GuiService (copy), UserInputService (copy)
    local Configure = p112:FindFirstChild("Configure");

    if not (Configure and Configure:IsA("Frame")) then
        warn("[MobileHUDEditor] EditMobile.Configure frame not found; transparency / enabled editing unavailable");

        return;
    end;

    u19 = Configure;
    Configure.Visible = false;
    local v113 = GetConfigureRefs();

    if not v113 then
        warn("[MobileHUDEditor] EditMobile.Configure is missing its Enabled button or slider parts");

        return;
    end;

    ActivateButton(v113.EnabledButton);
    v113.EnabledButton.MouseButton1Click:Connect(function() -- Line: 729
        -- upvalues: u18 (ref), DefaultLayout2 (ref), Router (ref), ApplyEditorButtonLayout (ref), RefreshConfigurePanel (ref)
        local v114 = u18;
        local v115;

        if v114 then
            v115 = DefaultLayout2[v114];
        else
            v115 = nil;
        end;

        if v115 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            local v116 = not v115.Enabled;
            local v117 = u18;
            local v118;

            if v117 then
                v118 = DefaultLayout2[v117];
            else
                v117 = nil;
                v118 = nil;
            end;

            if v117 then
                if not v118 then
                    return;
                end;

                v118.Enabled = v116;
                ApplyEditorButtonLayout(v117);
                RefreshConfigurePanel();
            end;
        end;
    end);
    local SliderTrack = v113.SliderTrack;
    local SliderKnob = v113.SliderKnob;
    SliderTrack.AutoButtonColor = false;

    if SliderKnob:IsA("GuiButton") then
        SliderKnob.AutoButtonColor = false;
    end;

    local function IsPointerInput(p119: userdata) -- Line: 745
        return p119.UserInputType == Enum.UserInputType.MouseButton1 and true or p119.UserInputType == Enum.UserInputType.Touch;
    end;

    local function SetFromScreenX(p120: number) -- Line: 749
        -- upvalues: SliderTrack (copy), SetSelectedButtonTransparency (ref)
        local math_max_ret = math.max(SliderTrack.AbsoluteSize.X, 1);
        SetSelectedButtonTransparency((math.clamp((p120 - SliderTrack.AbsolutePosition.X) / math_max_ret, 0, 1)));
    end;

    local function BeginSliderDrag(p121: userdata) -- Line: 755
        -- upvalues: u21 (ref), GuiService (ref), SliderTrack (copy), SetSelectedButtonTransparency (ref)
        if p121.UserInputType ~= Enum.UserInputType.MouseButton1 and p121.UserInputType ~= Enum.UserInputType.Touch or u21 then
            return;
        end;

        u21 = p121;
        local GuiInset = GuiService:GetGuiInset();
        local X = Vector2.new(p121.Position.X - GuiInset.X, p121.Position.Y - GuiInset.Y).X;
        local math_max_ret = math.max(SliderTrack.AbsoluteSize.X, 1);
        SetSelectedButtonTransparency((math.clamp((X - SliderTrack.AbsolutePosition.X) / math_max_ret, 0, 1)));
    end;

    SliderTrack.InputBegan:Connect(BeginSliderDrag);
    SliderKnob.InputBegan:Connect(BeginSliderDrag);
    UserInputService.InputChanged:Connect(function(p122: userdata) -- Line: 766
        -- upvalues: u21 (ref), GuiService (ref), SliderTrack (copy), SetSelectedButtonTransparency (ref)
        local v123 = u21;

        if not v123 then
            return;
        end;

        if p122 == v123 or v123.UserInputType == Enum.UserInputType.MouseButton1 and p122.UserInputType == Enum.UserInputType.MouseMovement then
            local GuiInset = GuiService:GetGuiInset();
            local X = Vector2.new(p122.Position.X - GuiInset.X, p122.Position.Y - GuiInset.Y).X;
            local math_max_ret = math.max(SliderTrack.AbsoluteSize.X, 1);
            SetSelectedButtonTransparency((math.clamp((X - SliderTrack.AbsolutePosition.X) / math_max_ret, 0, 1)));
        end;
    end);
    UserInputService.InputEnded:Connect(function(p124: userdata) -- Line: 777
        -- upvalues: u21 (ref)
        local v125 = u21;

        if not v125 then
            return;
        end;

        if p124 == v125 or v125.UserInputType == Enum.UserInputType.MouseButton1 and p124.UserInputType == Enum.UserInputType.MouseButton1 then
            u21 = nil;
        end;
    end);
    local ValueBox = v113.ValueBox;

    if ValueBox then
        ValueBox.FocusLost:Connect(function() -- Line: 790
            -- upvalues: ValueBox (copy), SetSelectedButtonTransparency (ref), RefreshConfigurePanel (ref)
            local string_gsub_ret = string.gsub(ValueBox.Text, "[^%d%.]", "");
            local v126 = tonumber(string_gsub_ret);

            if v126 then
                SetSelectedButtonTransparency(v126 / 100);
            end;

            RefreshConfigurePanel();
        end);
    end;
end;

local function HideDashboardPanels() -- Line: 802
    -- upvalues: u9 (ref), u10 (ref), u14 (copy)
    local v127 = u9;
    local v128 = u10;

    if not (v128 and v128.Parent) then
        v128 = u9;

        if v128 then
            local EditMobile = v128:FindFirstChild("EditMobile");

            if EditMobile then
                v128 = EditMobile;
            elseif v128.Name ~= "EditMobile" then
                v128 = EditMobile;
            end;

            u10 = v128;
        else
            v128 = nil;
        end;
    end;

    if not v127 then
        return;
    end;

    for _, child in ipairs(v127:GetChildren()) do
        if child ~= v128 and (child:IsA("GuiObject") and child.Visible) then
            u14[child] = true;
            child.Visible = false;
        end;
    end;
end;

local function RestoreDashboardPanels() -- Line: 821
    -- upvalues: u14 (copy)
    for i in pairs(u14) do
        if i.Parent then
            i.Visible = true;
        end;
    end;

    table.clear(u14);
end;

local function SetDashboardEditorVisibility(p129: boolean) -- Line: 833
    -- upvalues: u10 (ref), u9 (ref), u8 (ref), MenuState (copy), HideDashboardPanels (copy), u14 (copy)
    local v130 = u10;

    if not (v130 and v130.Parent) then
        v130 = u9;

        if v130 then
            local EditMobile = v130:FindFirstChild("EditMobile");

            if EditMobile then
                v130 = EditMobile;
            elseif v130.Name ~= "EditMobile" then
                v130 = EditMobile;
            end;

            u10 = v130;
        else
            v130 = nil;
        end;
    end;

    if v130 then
        v130.Visible = p129;

        if v130 then
            local Action = v130:FindFirstChild("Action");

            if Action and Action:IsA("Frame") then
                Action.Visible = p129;
            end;
        end;

        if v130 then
            local MobileButtons = v130:FindFirstChild("MobileButtons");

            if MobileButtons and MobileButtons:IsA("Frame") then
                MobileButtons.Visible = p129;
            end;
        end;
    end;

    local v131 = u8 and u8:FindFirstChild("Menu");
    local v132 = v131 and v131:IsA("Frame") and v131:FindFirstChild("Top");

    if not (v132 and v132:IsA("Frame")) then
        v132 = nil;
    end;

    if v132 then
        if p129 then
            v132.Visible = false;
        elseif not (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive()) then
            v132.Visible = true;
        end;
    end;

    if p129 then
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

local function EnforceEditorVisibilityLock() -- Line: 859
    -- upvalues: u11 (ref), u8 (ref), u14 (copy)
    if not u11 then
        return;
    end;

    local v133 = u8 and u8:FindFirstChild("Menu");
    local v134 = v133 and v133:IsA("Frame") and v133:FindFirstChild("Top");

    if not (v134 and v134:IsA("Frame")) then
        v134 = nil;
    end;

    if v134 and v134.Visible then
        v134.Visible = false;
    end;

    for i in pairs(u14) do
        if i.Visible then
            i.Visible = false;
        end;
    end;
end;

local function ConnectEditorVisibilityGuards() -- Line: 878
    -- upvalues: u13 (ref), u9 (ref), u8 (ref), EnforceEditorVisibilityLock (copy), u10 (ref)
    if u13 then
        return;
    end;

    local v135 = u9;
    local v136 = u8 and u8:FindFirstChild("Menu");
    local v137 = v136 and v136:IsA("Frame") and v136:FindFirstChild("Top");

    if not (v137 and v137:IsA("Frame")) then
        v137 = nil;
    end;

    if not (v135 or v137) then
        return;
    end;

    u13 = true;

    if v137 then
        v137:GetPropertyChangedSignal("Visible"):Connect(EnforceEditorVisibilityLock);
    end;

    if v135 then
        local v138 = u10;

        if not (v138 and v138.Parent) then
            v138 = u9;

            if v138 then
                local EditMobile = v138:FindFirstChild("EditMobile");

                if EditMobile then
                    v138 = EditMobile;
                elseif v138.Name ~= "EditMobile" then
                    v138 = EditMobile;
                end;

                u10 = v138;
            else
                v138 = nil;
            end;
        end;

        for _, child in ipairs(v135:GetChildren()) do
            if child ~= v138 and child:IsA("GuiObject") then
                child:GetPropertyChangedSignal("Visible"):Connect(EnforceEditorVisibilityLock);
            end;
        end;
    end;
end;

local function ClearEditorInteractionState() -- Line: 907
    -- upvalues: u15 (ref), u16 (ref), u17 (ref), u23 (ref), u24 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy)
    u15 = {};
    u16 = {};
    u17 = {};
    u23 = nil;
    u24 = nil;
    u22 = nil;
    u33 = nil;
    local v139 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v139 then
        UserInputService.MouseIcon = v139;
    end;

    u34 = nil;
    local v140 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v140 then
        UserInputService.MouseIcon = v140;
    end;

    u32 = nil;
    local v141 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v141 then
        UserInputService.MouseIcon = v141;
    end;
end;

local function RemoveTouchFromButton(p142: userdata) -- Line: 921
    -- upvalues: u15 (ref), u16 (ref)
    local v143 = u15[p142];

    if not v143 then
        return nil;
    end;

    u15[p142] = nil;
    local v144 = u16[v143];

    if v144 then
        v144[p142] = nil;

        if next(v144) == nil then
            u16[v143] = nil;
        end;
    end;

    return v143;
end;

local function GetButtonTouches(p145: string) -- Line: 941
    -- upvalues: u16 (ref)
    local v146 = u16[p145];

    if not v146 then
        return {};
    end;

    local v147 = {};

    for i in pairs(v146) do
        table.insert(v147, i);
    end;

    return v147;
end;

local function UpdateEditorButtonLayout(p148: string, p149: any) -- Line: 957
    -- upvalues: DefaultLayout2 (ref), Mobile (copy), ApplyEditorButtonLayout (copy)
    local v150 = DefaultLayout2[p148] or Mobile.GetDefaultButtonLayout(p148);
    local ClampButtonLayout = Mobile.ClampButtonLayout;
    local v151 = {
        Position = p149.Position,
        Size = p149.Size
    };
    local v152;

    if p149.Transparency == nil then
        v152 = v150.Transparency;
    else
        v152 = p149.Transparency;
    end;

    v151.Transparency = v152;
    local v153;

    if p149.Enabled == nil then
        v153 = v150.Enabled;
    else
        v153 = p149.Enabled;
    end;

    v151.Enabled = v153;
    DefaultLayout2[p148] = ClampButtonLayout(v151);
    ApplyEditorButtonLayout(p148);
end;

local function StartEditorDrag(p154: string, p155: userdata) -- Line: 970
    -- upvalues: DefaultLayout2 (ref), u24 (ref), u34 (ref), u33 (ref), u32 (ref), UserInputService (copy), u23 (ref), GuiService (copy), CopyPositionAndSize (copy)
    local v156 = DefaultLayout2[p154];

    if not v156 then
        return;
    end;

    u24 = nil;

    if p155.UserInputType == Enum.UserInputType.MouseButton1 then
        u34 = "rbxasset://SystemCursors/SizeAll";
        local v157 = u33 or u34 or (u32 or "");

        if UserInputService.MouseIcon ~= v157 then
            UserInputService.MouseIcon = v157;
        end;
    end;

    local v158 = {
        buttonName = p154,
        input = p155
    };
    local GuiInset = GuiService:GetGuiInset();
    v158.startPosition = Vector2.new(p155.Position.X - GuiInset.X, p155.Position.Y - GuiInset.Y);
    v158.startLayout = CopyPositionAndSize(v156);
    u23 = v158;
end;

local function StartEditorPinch(p159: string, p160: userdata, p161: userdata) -- Line: 991
    -- upvalues: DefaultLayout2 (ref), u10 (ref), u9 (ref), u23 (ref), u24 (ref), CopyPositionAndSize (copy)
    local v162 = DefaultLayout2[p159];

    if not v162 then
        return;
    end;

    local v163 = u10;

    if not (v163 and v163.Parent) then
        v163 = u9;

        if v163 then
            local EditMobile = v163:FindFirstChild("EditMobile");

            if EditMobile then
                v163 = EditMobile;
            elseif v163.Name ~= "EditMobile" then
                v163 = EditMobile;
            end;

            u10 = v163;
        else
            v163 = nil;
        end;
    end;

    local v164;

    if v163 then
        v164 = v163:FindFirstChild("MobileButtons");
    else
        v164 = nil;
    end;

    if not v164 then
        return;
    end;

    local AbsoluteSize = v164.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local Vector2_new_ret = Vector2.new(p160.Position.X, p160.Position.Y);
    local AbsolutePosition = v164.AbsolutePosition;
    local Magnitude = (Vector2.new(p161.Position.X, p161.Position.Y) - Vector2_new_ret).Magnitude;
    local math_max_ret = math.max(Magnitude, 1);
    local Vector2_new_ret2 = Vector2.new((Vector2_new_ret.X - AbsolutePosition.X) / AbsoluteSize.X, (Vector2_new_ret.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
    local v165 = v162.Size.Y <= 0 and 0.5 or (Vector2_new_ret2.Y - v162.Position.Y) / v162.Size.Y;
    u23 = nil;
    u24 = {
        buttonName = p159,
        anchorInput = p160,
        scaleInput = p161,
        anchorLocalScale = Vector2.new(math.clamp(v162.Size.X <= 0 and 0.5 or (Vector2_new_ret2.X - v162.Position.X) / v162.Size.X, 0, 1), (math.clamp(v165, 0, 1))),
        lastDistance = math_max_ret,
        lastLayout = CopyPositionAndSize(v162)
    };
end;

u87 = function(p166: string, p167, p168: userdata) -- Line: 1042
    -- upvalues: DefaultLayout2 (ref), u23 (ref), u24 (ref), u22 (ref), GuiService (copy)
    local v169 = DefaultLayout2[p166];

    if not v169 then
        return;
    end;

    u23 = nil;
    u24 = nil;
    local v170 = {
        buttonName = p166,
        input = p168,
        handleAnchor = p167
    };
    local GuiInset = GuiService:GetGuiInset();
    v170.startPosition = Vector2.new(p168.Position.X - GuiInset.X, p168.Position.Y - GuiInset.Y);
    v170.startLayout = {
        Position = {
            X = v169.Position.X,
            Y = v169.Position.Y
        },
        Size = {
            X = v169.Size.X,
            Y = v169.Size.Y
        },
        Transparency = v169.Transparency,
        Enabled = v169.Enabled
    };
    u22 = v170;
end;

local function UpdateResizeFromInput(p171: userdata) -- Line: 1064
    -- upvalues: u22 (ref), u10 (ref), u9 (ref), GuiService (copy), Mobile (copy), UpdateEditorButtonLayout (copy)
    local v172 = u22;

    if v172 then
        local input = v172.input;
        local v173;

        if p171 == input then
            v173 = true;
        else
            local UserInputType = p171.UserInputType;
            local UserInputType2 = input.UserInputType;
            v173 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
        end;

        if v173 then
            local v174 = u10;

            if not (v174 and v174.Parent) then
                v174 = u9;

                if v174 then
                    local EditMobile = v174:FindFirstChild("EditMobile");

                    if EditMobile then
                        v174 = EditMobile;
                    elseif v174.Name ~= "EditMobile" then
                        v174 = EditMobile;
                    end;

                    u10 = v174;
                else
                    v174 = nil;
                end;
            end;

            local v175;

            if v174 then
                v175 = v174:FindFirstChild("MobileButtons");
            else
                v175 = nil;
            end;

            if not v175 then
                return;
            end;

            local AbsoluteSize = v175.AbsoluteSize;

            if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                return;
            end;

            local GuiInset = GuiService:GetGuiInset();
            local v176 = Vector2.new(p171.Position.X - GuiInset.X, p171.Position.Y - GuiInset.Y) - v172.startPosition;
            local Vector2_new_ret = Vector2.new(v176.X / AbsoluteSize.X, v176.Y / AbsoluteSize.Y);
            local startLayout = v172.startLayout;
            local handleAnchor = v172.handleAnchor;
            local v177 = v175:FindFirstChild(v172.buttonName);
            local v178;

            if v177 and v177:IsA("GuiObject") then
                v178 = v177.AnchorPoint;
            else
                v178 = Vector2.new(0.5, 0.5);
            end;

            local function resolveSize(p179: number, p180: number, p181: number) -- Line: 1091
                -- upvalues: Mobile (ref)
                if p179 >= 1 then
                    return math.clamp(p180 + p181, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                end;

                if p179 <= 0 then
                    return math.clamp(p180 - p181, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                end;

                return p180;
            end;

            local function resolvePosition(p182: number, p183: number, p184: number, p185: number, p186: number) -- Line: 1101
                if p182 >= 1 then
                    return p184 + p183 * (p186 - p185);
                end;

                if p182 <= 0 then
                    return p184 + (1 - p183) * (p185 - p186);
                end;

                return p184;
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

            local v187;

            if v177 == nil then
                v187 = false;
            else
                v187 = v177:FindFirstChildWhichIsA("UIAspectRatioConstraint", true) ~= nil;
            end;

            if v187 and (startLayout.Size.X > 0 and startLayout.Size.Y > 0) then
                local v188 = startLayout.Size.Y / startLayout.Size.X;
                local v189 = handleAnchor.X ~= 0.5;
                local v190 = handleAnchor.Y ~= 0.5;

                if v189 then
                    v189 = not v190 or math.abs(v176.X) >= math.abs(v176.Y);
                end;

                if v189 then
                    Y2 = math.clamp(X2 * v188, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                    X2 = Y2 / v188;
                else
                    X2 = math.clamp(Y2 / v188, Mobile.MIN_SIZE, Mobile.MAX_SIZE);
                    Y2 = X2 * v188;
                end;
            end;

            local X4 = handleAnchor.X;
            local X5 = v178.X;
            local X6 = startLayout.Position.X;
            local X7 = startLayout.Size.X;

            if X4 >= 1 then
                X6 = X6 + X5 * (X2 - X7);
            elseif X4 <= 0 then
                X6 = X6 + (1 - X5) * (X7 - X2);
            end;

            local Y4 = handleAnchor.Y;
            local Y5 = v178.Y;
            local Y6 = startLayout.Position.Y;
            local Y7 = startLayout.Size.Y;

            if Y4 >= 1 then
                Y6 = Y6 + Y5 * (Y2 - Y7);
            elseif Y4 <= 0 then
                Y6 = Y6 + (1 - Y5) * (Y7 - Y2);
            end;

            UpdateEditorButtonLayout(v172.buttonName, {
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

local function TryStartEditorPinchWithSecondTouch(p191: userdata) -- Line: 1143
    -- upvalues: u23 (ref), u24 (ref), StartEditorPinch (copy)
    local v192 = u23;

    if not (v192 and (not u24 and v192.input ~= p191)) then
        return;
    end;

    StartEditorPinch(v192.buttonName, v192.input, p191);
end;

local function RefreshEditorInteraction(p193: string) -- Line: 1154
    -- upvalues: u24 (ref), GetButtonTouches (copy), u23 (ref), StartEditorDrag (copy), u34 (ref), u33 (ref), u32 (ref), UserInputService (copy)
    if u24 and u24.buttonName == p193 then
        return;
    end;

    local v194 = GetButtonTouches(p193);

    if #v194 <= 0 then
        if u23 and u23.buttonName == p193 then
            u23 = nil;
            u34 = nil;
            local v195 = u33 or u34 or (u32 or "");

            if UserInputService.MouseIcon ~= v195 then
                UserInputService.MouseIcon = v195;
            end;
        end;

        if u24 and u24.buttonName == p193 then
            u24 = nil;
        end;

        return;
    end;

    local v196 = v194[1];
    local v197 = u23;

    if v197 and v197.buttonName == p193 then
        for _, v in ipairs(v194) do
            if v == v197.input then
                v196 = v;
                break;
            end;
        end;
    end;

    StartEditorDrag(p193, v196);
end;

local function UpdateDragFromInput(p198: userdata) -- Line: 1187
    -- upvalues: u23 (ref), u10 (ref), u9 (ref), DefaultLayout2 (ref), GuiService (copy), UpdateEditorButtonLayout (copy)
    local v199 = u23;

    if v199 then
        local input = v199.input;
        local v200;

        if p198 == input then
            v200 = true;
        else
            local UserInputType = p198.UserInputType;
            local UserInputType2 = input.UserInputType;
            v200 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
        end;

        if v200 then
            local v201 = u10;

            if not (v201 and v201.Parent) then
                v201 = u9;

                if v201 then
                    local EditMobile = v201:FindFirstChild("EditMobile");

                    if EditMobile then
                        v201 = EditMobile;
                    elseif v201.Name ~= "EditMobile" then
                        v201 = EditMobile;
                    end;

                    u10 = v201;
                else
                    v201 = nil;
                end;
            end;

            local v202;

            if v201 then
                v202 = v201:FindFirstChild("MobileButtons");
            else
                v202 = nil;
            end;

            local v203 = DefaultLayout2[v199.buttonName];

            if not (v202 and v203) then
                return;
            end;

            local AbsoluteSize = v202.AbsoluteSize;

            if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                return;
            end;

            local GuiInset = GuiService:GetGuiInset();
            local v204 = Vector2.new(p198.Position.X - GuiInset.X, p198.Position.Y - GuiInset.Y) - v199.startPosition;
            UpdateEditorButtonLayout(v199.buttonName, {
                Position = {
                    X = v199.startLayout.Position.X + v204.X / AbsoluteSize.X,
                    Y = v199.startLayout.Position.Y + v204.Y / AbsoluteSize.Y
                },
                Size = {
                    X = v203.Size.X,
                    Y = v203.Size.Y
                }
            });
        end;
    end;
end;

local function UpdatePinchFromInput(p205: userdata) -- Line: 1217
    -- upvalues: u24 (ref), u10 (ref), u9 (ref), UpdateEditorButtonLayout (copy), DefaultLayout2 (ref), CopyPositionAndSize (copy)
    local v206 = u24;

    if not (v206 and (p205 == v206.scaleInput or p205 == v206.anchorInput)) then
        return;
    end;

    local anchorInput = v206.anchorInput;
    local Vector2_new_ret = Vector2.new(anchorInput.Position.X, anchorInput.Position.Y);
    local scaleInput = v206.scaleInput;
    local Vector2_new_ret2 = Vector2.new(scaleInput.Position.X, scaleInput.Position.Y);
    local math_max_ret = math.max((Vector2_new_ret2 - Vector2_new_ret).Magnitude, 1);
    local v207 = math_max_ret / math.max(v206.lastDistance, 1);
    local v208 = v206.lastLayout.Size.X * v207;
    local v209 = v206.lastLayout.Size.Y * v207;
    local v210 = u10;

    if not (v210 and v210.Parent) then
        v210 = u9;

        if v210 then
            local EditMobile = v210:FindFirstChild("EditMobile");

            if EditMobile then
                v210 = EditMobile;
            elseif v210.Name ~= "EditMobile" then
                v210 = EditMobile;
            end;

            u10 = v210;
        else
            v210 = nil;
        end;
    end;

    local v211;

    if v210 then
        v211 = v210:FindFirstChild("MobileButtons");
    else
        v211 = nil;
    end;

    if not v211 then
        return;
    end;

    local AbsoluteSize = v211.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local AbsolutePosition = v211.AbsolutePosition;
    local Vector2_new_ret3 = Vector2.new((Vector2_new_ret.X - AbsolutePosition.X) / AbsoluteSize.X, (Vector2_new_ret.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
    local v212 = Vector2_new_ret3.X - v206.anchorLocalScale.X * v208;
    local v213 = Vector2_new_ret3.Y - v206.anchorLocalScale.Y * v209;

    if v212 ~= v212 or v213 ~= v213 then
        local v214 = (Vector2_new_ret + Vector2_new_ret2) * 0.5;
        local Vector2_new_ret4 = Vector2.new((v214.X - AbsolutePosition.X) / AbsoluteSize.X, (v214.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
        v212 = Vector2_new_ret4.X - v208 / 2;
        v213 = Vector2_new_ret4.Y - v209 / 2;
    end;

    UpdateEditorButtonLayout(v206.buttonName, {
        Position = {
            X = v212,
            Y = v213
        },
        Size = {
            X = v208,
            Y = v209
        }
    });
    local v215 = DefaultLayout2[v206.buttonName];

    if v215 then
        v206.lastLayout = CopyPositionAndSize(v215);
    end;

    v206.lastDistance = math_max_ret;
end;

local function LoadEditorStateFromProfile() -- Line: 1274
    -- upvalues: DataController (copy), LocalPlayer (copy), DefaultLayout (ref), Mobile (copy), DefaultLayout2 (ref), DeepCopyLayout (copy), ApplyEditorButtonLayout (copy)
    local v216 = DataController.Get(LocalPlayer, "MobileButtons");
    DefaultLayout = Mobile.SanitizeLayout(v216);
    DefaultLayout2 = DeepCopyLayout(DefaultLayout);

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function ConnectEditorButtonGesture(p217: userdata) -- Line: 1285
    -- upvalues: u11 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (copy), u88 (ref)
    local Name = p217.Name;
    p217.Active = true;
    p217.MouseEnter:Connect(function() -- Line: 1294
        -- upvalues: u11 (ref), u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u11 then
            u32 = "rbxasset://SystemCursors/SizeAll";
            local v218 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v218 then
                UserInputService.MouseIcon = v218;
            end;
        end;
    end);
    p217.MouseLeave:Connect(function() -- Line: 1299
        -- upvalues: u32 (ref), u33 (ref), u34 (ref), UserInputService (ref)
        if u32 == "rbxasset://SystemCursors/SizeAll" then
            u32 = nil;
            local v219 = u33 or (u34 or u32 or "");

            if UserInputService.MouseIcon ~= v219 then
                UserInputService.MouseIcon = v219;
            end;
        end;
    end);
    p217.InputBegan:Connect(function(p220: userdata) -- Line: 1304
        -- upvalues: u11 (ref), u88 (ref), Name (copy)
        if u11 then
            local v221;

            if p220.UserInputType == Enum.UserInputType.Touch or p220.UserInputType == Enum.UserInputType.MouseButton1 then
                v221 = p220.UserInputState == Enum.UserInputState.Begin;
            else
                v221 = false;
            end;

            if v221 then
                u88(Name, p220);
            end;
        end;
    end);
end;

u88 = function(p222: string, p223: userdata) -- Line: 1314
    -- upvalues: u15 (ref), u22 (ref), u24 (ref), u23 (ref), u16 (ref), u17 (ref), GuiService (copy), u18 (ref), SelectEditorButton (copy), RefreshEditorInteraction (copy)
    if u15[p223] then
        return;
    end;

    if u22 then
        return;
    end;

    local v224 = u24 and u24.buttonName or u23 and u23.buttonName;

    if v224 and v224 ~= p222 then
        return;
    end;

    u15[p223] = p222;
    u16[p222] = u16[p222] or {};
    u16[p222][p223] = true;
    local GuiInset = GuiService:GetGuiInset();
    u17[p223] = Vector2.new(p223.Position.X - GuiInset.X, p223.Position.Y - GuiInset.Y);

    if u18 ~= p222 then
        SelectEditorButton(p222);
    end;

    RefreshEditorInteraction(p222);
end;

local function IsPointInsideGuiObject(p225: userdata?, p226) -- Line: 1342
    if not (p225 and p225.Visible) then
        return false;
    end;

    local AbsolutePosition = p225.AbsolutePosition;
    local v227 = AbsolutePosition + p225.AbsoluteSize;
    local v228;

    if p226.X >= AbsolutePosition.X and (p226.X <= v227.X and p226.Y >= AbsolutePosition.Y) then
        v228 = p226.Y <= v227.Y;
    else
        v228 = false;
    end;

    return v228;
end;

local function TryDeselectFromEmptyTouch(p229: userdata) -- Line: 1353
    -- upvalues: u11 (ref), u18 (ref), u15 (ref), u22 (ref), u24 (ref), u19 (ref), u10 (ref), u9 (ref), RefreshConfigurePanel (copy), u109 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    if not (u11 and u18) then
        return;
    end;

    if u15[p229] then
        return;
    end;

    local v230 = u22;

    if v230 and v230.input == p229 then
        return;
    end;

    local v231 = u24;

    if v231 and (v231.anchorInput == p229 or v231.scaleInput == p229) then
        return;
    end;

    local Vector2_new_ret = Vector2.new(p229.Position.X, p229.Position.Y);
    local v232 = u19;
    local v233;

    if v232 and v232.Visible then
        local AbsolutePosition = v232.AbsolutePosition;
        local v234 = AbsolutePosition + v232.AbsoluteSize;

        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= v234.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
            v233 = Vector2_new_ret.Y <= v234.Y;
        else
            v233 = false;
        end;
    else
        v233 = false;
    end;

    if v233 then
        return;
    end;

    local v235 = u10;

    if not (v235 and v235.Parent) then
        v235 = u9;

        if v235 then
            local EditMobile = v235:FindFirstChild("EditMobile");

            if EditMobile then
                v235 = EditMobile;
            elseif v235.Name ~= "EditMobile" then
                v235 = EditMobile;
            end;

            u10 = v235;
        else
            v235 = nil;
        end;
    end;

    if v235 then
        v235 = v235:FindFirstChild("Action");
    end;

    if v235 and v235:IsA("GuiObject") then
        local v236;

        if v235 and v235.Visible then
            local AbsolutePosition = v235.AbsolutePosition;
            local v237 = AbsolutePosition + v235.AbsoluteSize;

            if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= v237.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                v236 = Vector2_new_ret.Y <= v237.Y;
            else
                v236 = false;
            end;
        else
            v236 = false;
        end;

        if v236 then
            return;
        end;
    end;

    u18 = nil;
    RefreshConfigurePanel();

    if u109 then
        u109:Disconnect();
        u109 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v238 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v238 then
        UserInputService.MouseIcon = v238;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function FindEquippedLoadoutItem(p239: string, p240: string, p241: string) -- Line: 1386
    -- upvalues: DataController (copy), LocalPlayer (copy), u3 (copy)
    local v242 = DataController.Get(LocalPlayer, "Loadout");
    local u243 = DataController.Get(LocalPlayer, "Inventory");
    local v244;

    if typeof(v242) == "table" then
        v244 = v242[p239];
    else
        v244 = false;
    end;

    if typeof(v244) ~= "table" or typeof(u243) ~= "table" then
        return nil;
    end;

    local function findInventoryItem(p245: any, p246: string?) -- Line: 1394
        -- upvalues: u243 (copy)
        if typeof(p245) ~= "string" or p245 == "" then
            return nil;
        end;

        for _, v in ipairs(u243) do
            if typeof(v) == "table" and (v._id == p245 and (p246 == nil or v.Name == p246)) then
                return v;
            end;
        end;

        return nil;
    end;

    if p240 == "Melee" then
        local Equipped = v244.Equipped;

        return typeof(Equipped) == "table" and findInventoryItem(Equipped["Equipped Melee"], nil) or nil;
    end;

    local v247 = u3[p240];

    if typeof(v244.Loadout) == "table" then
        if v247 then
            v247 = v244.Loadout[v247];
        end;
    else
        v247 = false;
    end;

    if typeof(v247) ~= "table" or typeof(v247.Options) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v247.Options) do
        local v248 = findInventoryItem(v, p241);

        if v248 then
            return v248;
        end;
    end;

    return nil;
end;

local function GetLoadoutPreviewIcon(p249: string, p250: any) -- Line: 1429
    -- upvalues: Skins (copy), GetWeaponProperties (copy)
    if p250 then
        p249 = p250.Name or p249;
    end;

    local v251 = p250 and typeof(p250.Skin) == "string" and (p250.Skin or "Stock") or "Stock";
    local SkinInformation = Skins.GetSkinInformation(p249, v251);

    if SkinInformation then
        if SkinInformation.wearImages and SkinInformation.wearImages[1] then
            return SkinInformation.wearImages[1].assetId;
        end;

        if SkinInformation.imageAssetId then
            return SkinInformation.imageAssetId;
        end;
    end;

    local v252 = GetWeaponProperties(p249);

    return v252 and v252.Icon or nil;
end;

local function SetEditorSlotIcon(p253: userdata, p254: string, p255: string?) -- Line: 1448
    local v256 = p253:FindFirstChild(p254);

    if v256 then
        v256 = v256:FindFirstChild("WeaponImage");
    end;

    if v256 and v256:IsA("ImageLabel") then
        v256.Image = p255 or "";
        v256.Visible = p255 ~= nil;
    end;
end;

local function ApplyEditorLoadoutPreview() -- Line: 1459
    -- upvalues: u10 (ref), u9 (ref), u4 (copy), Skins (copy), GetWeaponProperties (copy), ReplicatedStorage (copy), u2 (copy), LocalPlayer (copy), DataController (copy), FindEquippedLoadoutItem (copy), GetLoadoutPreviewIcon (copy)
    local v257 = u10;

    if not (v257 and v257.Parent) then
        v257 = u9;

        if v257 then
            local EditMobile = v257:FindFirstChild("EditMobile");

            if EditMobile then
                v257 = EditMobile;
            elseif v257.Name ~= "EditMobile" then
                v257 = EditMobile;
            end;

            u10 = v257;
        else
            v257 = nil;
        end;
    end;

    local v258;

    if v257 then
        v258 = v257:FindFirstChild("MobileButtons");
    else
        v258 = nil;
    end;

    if not v258 then
        return;
    end;

    for i, v in pairs(u4) do
        local SkinInformation = Skins.GetSkinInformation(v, "Stock");
        local v259, v260;

        if SkinInformation then
            if SkinInformation.wearImages and SkinInformation.wearImages[1] then
                v259 = SkinInformation.wearImages[1].assetId;
            elseif SkinInformation.imageAssetId then
                v259 = SkinInformation.imageAssetId;
            else
                v260 = GetWeaponProperties(v);
                v259 = v260 and v260.Icon or nil;
            end;
        else
            v260 = GetWeaponProperties(v);
            v259 = v260 and v260.Icon or nil;
        end;

        local v261 = v258:FindFirstChild(i);

        if v261 then
            v261 = v261:FindFirstChild("WeaponImage");
        end;

        if v261 and v261:IsA("ImageLabel") then
            v261.Image = v259 or "";
            v261.Visible = v259 ~= nil;
        end;
    end;

    local MenuCharacterTeam = require(ReplicatedStorage.Controllers.MenuSceneController).GetMenuCharacterTeam();

    if not (MenuCharacterTeam and u2[MenuCharacterTeam]) then
        local Attribute = LocalPlayer:GetAttribute("Team");
        MenuCharacterTeam = (typeof(Attribute) ~= "string" or not u2[Attribute]) and "Counter-Terrorists" or Attribute;
    end;

    for i, v in pairs(u2[MenuCharacterTeam]) do
        local v262;

        if DataController.IsDataLoaded(LocalPlayer) then
            v262 = FindEquippedLoadoutItem(MenuCharacterTeam, i, v);
        else
            v262 = nil;
        end;

        local v263 = GetLoadoutPreviewIcon(v, v262);
        local v264 = v258:FindFirstChild(i);

        if v264 then
            v264 = v264:FindFirstChild("WeaponImage");
        end;

        if v264 and v264:IsA("ImageLabel") then
            v264.Image = v263 or "";
            v264.Visible = v263 ~= nil;
        end;
    end;
end;

local function ConvertGuiButtonToFrame(p265: userdata) -- Line: 1494
    local Frame = Instance.new("Frame");
    Frame.Name = p265.Name;
    Frame.AnchorPoint = p265.AnchorPoint;
    Frame.Position = p265.Position;
    Frame.Size = p265.Size;
    Frame.SizeConstraint = p265.SizeConstraint;
    Frame.Rotation = p265.Rotation;
    Frame.ZIndex = p265.ZIndex;
    Frame.LayoutOrder = p265.LayoutOrder;
    Frame.Visible = p265.Visible;
    Frame.BackgroundColor3 = p265.BackgroundColor3;
    Frame.BackgroundTransparency = p265.BackgroundTransparency;
    Frame.BorderSizePixel = p265.BorderSizePixel;
    Frame.ClipsDescendants = p265.ClipsDescendants;

    for _, child in ipairs(p265:GetChildren()) do
        child.Parent = Frame;
    end;

    return Frame;
end;

local function ConvertTreeButtonsToFrames(p266: userdata) -- Line: 1515
    -- upvalues: ConvertGuiButtonToFrame (copy)
    for _, descendant in ipairs(p266:GetDescendants()) do
        if descendant:IsA("GuiButton") then
            ConvertGuiButtonToFrame(descendant).Parent = descendant.Parent;
            descendant:Destroy();
        end;
    end;

    if not p266:IsA("GuiButton") then
        return p266;
    end;

    local v267 = ConvertGuiButtonToFrame(p266);
    p266:Destroy();

    return v267;
end;

local function PopulateEditorButtons() -- Line: 1533
    -- upvalues: u10 (ref), u9 (ref), GetGameplayMobileButtonsFrame (copy), Mobile (copy), ConvertTreeButtonsToFrames (copy), ConnectEditorButtonGesture (copy), ApplyEditorLoadoutPreview (copy)
    local v268 = u10;

    if not (v268 and v268.Parent) then
        v268 = u9;

        if v268 then
            local EditMobile = v268:FindFirstChild("EditMobile");

            if EditMobile then
                v268 = EditMobile;
            elseif v268.Name ~= "EditMobile" then
                v268 = EditMobile;
            end;

            u10 = v268;
        else
            v268 = nil;
        end;
    end;

    local v269;

    if v268 then
        v269 = v268:FindFirstChild("MobileButtons");
    else
        v269 = nil;
    end;

    local v270 = GetGameplayMobileButtonsFrame();

    if not (v269 and v270) then
        return;
    end;

    for _, child in ipairs(v269:GetChildren()) do
        if child:IsA("GuiObject") and Mobile.IsKnownButton(child.Name) then
            child:Destroy();
        end;
    end;

    for _, v in ipairs(Mobile.GetButtonNames()) do
        local v271 = v270:FindFirstChild(v);

        if v271 and v271:IsA("GuiObject") then
            local v272 = v271:Clone();
            v272.Visible = true;
            local Toggled = v272:FindFirstChild("Toggled");

            if Toggled and Toggled:IsA("GuiObject") then
                Toggled.Visible = false;
            end;

            local Equipped = v272:FindFirstChild("Equipped");

            if Equipped and Equipped:IsA("GuiObject") then
                Equipped.Visible = false;
            end;

            local Use = v272:FindFirstChild("Use");

            if Use and Use:IsA("GuiObject") then
                Use.Visible = true;
            end;

            local Defuse = v272:FindFirstChild("Defuse");

            if Defuse and Defuse:IsA("GuiObject") then
                Defuse.Visible = false;
            end;

            local v273 = ConvertTreeButtonsToFrames(v272);
            v273.Parent = v269;
            ConnectEditorButtonGesture(v273);
        end;
    end;

    ApplyEditorLoadoutPreview();
end;

local function SetEditorMode(p274: boolean) -- Line: 1588
    -- upvalues: u11 (ref), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u109 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    u11 = p274;
    SetDashboardEditorVisibility(p274);

    if p274 then
        RefreshConfigurePanel();
    else
        ClearEditorInteractionState();
        u18 = nil;
        RefreshConfigurePanel();

        if u109 then
            u109:Disconnect();
            u109 = nil;
        end;

        u22 = nil;
        u33 = nil;
        local v275 = u33 or (u34 or u32 or "");

        if UserInputService.MouseIcon ~= v275 then
            UserInputService.MouseIcon = v275;
        end;

        if u20 then
            u20.Visible = false;
        end;
    end;
end;

local function EnterMobileHUDEditor() -- Line: 1601
    -- upvalues: GetUserPlatform (copy), UserInputService (copy), u11 (ref), u12 (ref), DataController (copy), LocalPlayer (copy), Router (copy), ClearEditorInteractionState (copy), u10 (ref), u9 (ref), Mobile (copy), PopulateEditorButtons (copy), DefaultLayout (ref), DefaultLayout2 (ref), DeepCopyLayout (copy), ApplyEditorButtonLayout (copy), ApplyEditorLoadoutPreview (copy), u8 (ref), HideDashboardPanels (copy), RefreshConfigurePanel (copy)
    local v276 = GetUserPlatform();
    local v277;

    if table.find(v276, "Mobile") == nil then
        v277 = false;
    else
        v277 = #v276 <= 1;
    end;

    if not v277 and UserInputService:GetLastInputType() ~= Enum.UserInputType.Touch then
        return;
    end;

    if u11 or u12 then
        return;
    end;

    u12 = true;
    local success = pcall(function() -- Line: 1611
        -- upvalues: DataController (ref), LocalPlayer (ref)
        DataController.WaitForDataLoaded(LocalPlayer);
    end);
    u12 = false;

    if not success then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Profile data is still loading. Please try again.");

        return;
    end;

    ClearEditorInteractionState();
    local v278 = u10;

    if not (v278 and v278.Parent) then
        v278 = u9;

        if v278 then
            local EditMobile = v278:FindFirstChild("EditMobile");

            if EditMobile then
                v278 = EditMobile;
            elseif v278.Name ~= "EditMobile" then
                v278 = EditMobile;
            end;

            u10 = v278;
        else
            v278 = nil;
        end;
    end;

    local v279;

    if v278 then
        v279 = v278:FindFirstChild("MobileButtons");
    else
        v279 = nil;
    end;

    local v280 = false;

    if v279 then
        for _, v in ipairs(Mobile.GetButtonNames()) do
            if v279:FindFirstChild(v) then
                v280 = true;
                break;
            end;
        end;
    end;

    if not (v279 and v280) then
        PopulateEditorButtons();
    end;

    local v281 = DataController.Get(LocalPlayer, "MobileButtons");
    DefaultLayout = Mobile.SanitizeLayout(v281);
    DefaultLayout2 = DeepCopyLayout(DefaultLayout);

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;

    ApplyEditorLoadoutPreview();
    u11 = true;
    local v282 = u10;

    if not (v282 and v282.Parent) then
        v282 = u9;

        if v282 then
            local EditMobile = v282:FindFirstChild("EditMobile");

            if EditMobile then
                v282 = EditMobile;
            elseif v282.Name ~= "EditMobile" then
                v282 = EditMobile;
            end;

            u10 = v282;
        else
            v282 = nil;
        end;
    end;

    if v282 then
        v282.Visible = true;

        if v282 then
            local Action = v282:FindFirstChild("Action");

            if Action and Action:IsA("Frame") then
                Action.Visible = true;
            end;
        end;

        if v282 then
            local MobileButtons = v282:FindFirstChild("MobileButtons");

            if MobileButtons and MobileButtons:IsA("Frame") then
                MobileButtons.Visible = true;
            end;
        end;
    end;

    local v283 = u8 and u8:FindFirstChild("Menu");
    local v284 = v283 and v283:IsA("Frame") and v283:FindFirstChild("Top");

    if not (v284 and v284:IsA("Frame")) then
        v284 = nil;
    end;

    if v284 then
        v284.Visible = false;
    end;

    HideDashboardPanels();
    RefreshConfigurePanel();
end;

local function ExitMobileHUDEditor(p285: boolean) -- Line: 1645
    -- upvalues: u11 (ref), DefaultLayout2 (ref), DeepCopyLayout (copy), DefaultLayout (ref), Mobile (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u109 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    if not u11 then
        return;
    end;

    if not p285 then
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

    if u109 then
        u109:Disconnect();
        u109 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v286 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v286 then
        UserInputService.MouseIcon = v286;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function UpdateEditMobileButtonVisibility(p287) -- Line: 1660
    -- upvalues: GetEditMobileEntryButton (copy), GetUserPlatform (copy), UserInputService (copy), u11 (ref), MenuState (copy), SetDashboardEditorVisibility (copy)
    local v288 = GetEditMobileEntryButton();
    local v289;

    if v288 then
        v289 = v288.Parent;
    else
        v289 = v288;
    end;

    local v290 = GetUserPlatform();
    local v291;

    if table.find(v290, "Mobile") == nil then
        v291 = false;
    else
        v291 = #v290 <= 1;
    end;

    local v292 = v291 or (p287 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch;

    if v288 then
        v288.Visible = v292;
    end;

    if v289 and v289:IsA("GuiObject") then
        v289.Visible = v292;
    end;

    if not (v292 or (u11 or (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive()))) then
        SetDashboardEditorVisibility(false);
    end;
end;

local function ResetEditorToDefaults() -- Line: 1682
    -- upvalues: DefaultLayout2 (ref), Mobile (copy), ApplyEditorButtonLayout (copy), RefreshConfigurePanel (copy)
    DefaultLayout2 = Mobile.GetDefaultLayout();

    for _, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v);
    end;

    RefreshConfigurePanel();
end;

local function ApplyLayoutToGameplayButtons(p293) -- Line: 1690
    -- upvalues: GetGameplayMobileButtonsFrame (copy), Mobile (copy), ApplyMobileButtonLayout (copy)
    local v294 = GetGameplayMobileButtonsFrame();

    if not v294 then
        return;
    end;

    for _, v in ipairs(Mobile.GetButtonNames()) do
        local v295 = v294:FindFirstChild(v);
        local v296 = p293[v];

        if v295 and (v295:IsA("GuiObject") and v296) then
            ApplyMobileButtonLayout(v295, v296);
        end;
    end;
end;

local function CommitEditorChanges() -- Line: 1709
    -- upvalues: Mobile (copy), DefaultLayout2 (ref), DeepCopyLayout (copy), DefaultLayout (ref), ApplyLayoutToGameplayButtons (copy), Remotes (copy)
    local v297 = Mobile.SanitizeLayout(DefaultLayout2);
    DefaultLayout2 = DeepCopyLayout(v297);
    DefaultLayout = DeepCopyLayout(v297);
    ApplyLayoutToGameplayButtons(v297);
    Remotes.Player.UpdateMobileButtons.Send({
        Layout = v297
    });
end;

local function HasEditorLayoutChanges() -- Line: 1723
    -- upvalues: Mobile (copy), DefaultLayout2 (ref), DefaultLayout (ref)
    local v298 = Mobile.SanitizeLayout(DefaultLayout2);
    local v299 = Mobile.SanitizeLayout(DefaultLayout);

    return not Mobile.AreLayoutsEqual(v298, v299);
end;

local function ConnectActionButton(p300: userdata, p301: string, p302: function) -- Line: 1731
    -- upvalues: ActivateButton (copy)
    local v303 = p300:FindFirstChild(p301);

    if not (v303 and v303:IsA("GuiButton")) then
        return;
    end;

    ActivateButton(v303);
    v303.MouseButton1Click:Connect(p302);
end;

local function HandleConfirmPressed() -- Line: 1743
    -- upvalues: u11 (ref), Router (copy), Mobile (copy), DefaultLayout2 (ref), DefaultLayout (ref), CommitEditorChanges (copy), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u109 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
    if not u11 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    local v304 = Mobile.SanitizeLayout(DefaultLayout2);
    local v305 = Mobile.SanitizeLayout(DefaultLayout);

    if not Mobile.AreLayoutsEqual(v304, v305) then
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

    if u109 then
        u109:Disconnect();
        u109 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v306 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v306 then
        UserInputService.MouseIcon = v306;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function HandleResetPressed() -- Line: 1757
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

local function HandleBackPressed() -- Line: 1767
    -- upvalues: u11 (ref), Router (copy), DefaultLayout2 (ref), DeepCopyLayout (copy), DefaultLayout (ref), Mobile (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy), ClearEditorInteractionState (copy), u18 (ref), RefreshConfigurePanel (copy), u109 (ref), u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (copy), u20 (ref)
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

    if u109 then
        u109:Disconnect();
        u109 = nil;
    end;

    u22 = nil;
    u33 = nil;
    local v307 = u33 or (u34 or u32 or "");

    if UserInputService.MouseIcon ~= v307 then
        UserInputService.MouseIcon = v307;
    end;

    if u20 then
        u20.Visible = false;
    end;
end;

local function SetupEditMobileEntryButton() -- Line: 1777
    -- upvalues: GetEditMobileEntryButton (copy), ActivateButton (copy), Router (copy), EnterMobileHUDEditor (copy)
    local v308 = GetEditMobileEntryButton();

    if not v308 then
        return;
    end;

    ActivateButton(v308);
    v308.MouseButton1Click:Connect(function() -- Line: 1784
        -- upvalues: Router (ref), EnterMobileHUDEditor (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        EnterMobileHUDEditor();
    end);
end;

local function SetupEditorControls() -- Line: 1792
    -- upvalues: u10 (ref), u9 (ref), HandleConfirmPressed (copy), ActivateButton (copy), HandleResetPressed (copy), HandleBackPressed (copy), SetupConfigurePanel (copy), PopulateEditorButtons (copy)
    local v309 = u10;

    if not (v309 and v309.Parent) then
        v309 = u9;

        if v309 then
            local EditMobile = v309:FindFirstChild("EditMobile");

            if EditMobile then
                v309 = EditMobile;
            elseif v309.Name ~= "EditMobile" then
                v309 = EditMobile;
            end;

            u10 = v309;
        else
            v309 = nil;
        end;
    end;

    if not v309 then
        return;
    end;

    local Action = v309:FindFirstChild("Action");

    if Action and Action:IsA("Frame") then
        local v310 = HandleConfirmPressed;
        local Confirm = Action:FindFirstChild("Confirm");

        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm);
            Confirm.MouseButton1Click:Connect(v310);
        end;

        local v311 = HandleResetPressed;
        local Reset = Action:FindFirstChild("Reset");

        if Reset and Reset:IsA("GuiButton") then
            ActivateButton(Reset);
            Reset.MouseButton1Click:Connect(v311);
        end;

        local v312 = HandleBackPressed;
        local Back = Action:FindFirstChild("Back");

        if Back and Back:IsA("GuiButton") then
            ActivateButton(Back);
            Back.MouseButton1Click:Connect(v312);
        end;
    end;

    SetupConfigurePanel(v309);
    PopulateEditorButtons();
end;

local function ConnectGlobalInputHandlers() -- Line: 1812
    -- upvalues: UserInputService (copy), UpdateEditMobileButtonVisibility (copy), ReplicatedStorage (copy), ApplyEditorLoadoutPreview (copy), DataController (copy), LocalPlayer (copy), Skins (copy), u11 (ref), u23 (ref), u24 (ref), StartEditorPinch (copy), TryDeselectFromEmptyTouch (copy), u22 (ref), UpdateResizeFromInput (copy), UpdatePinchFromInput (copy), UpdateDragFromInput (copy), u33 (ref), u34 (ref), u32 (ref), u15 (ref), u16 (ref), u17 (ref), GuiService (copy), SelectEditorButton (copy), StartEditorDrag (copy), RefreshEditorInteraction (copy)
    UserInputService.LastInputTypeChanged:Connect(function(p313) -- Line: 1813
        -- upvalues: UpdateEditMobileButtonVisibility (ref)
        UpdateEditMobileButtonVisibility(p313);
    end);
    require(ReplicatedStorage.Controllers.MenuSceneController).MenuCharacterChanged:Connect(function() -- Line: 1819
        -- upvalues: ApplyEditorLoadoutPreview (ref)
        ApplyEditorLoadoutPreview();
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1822
        -- upvalues: ApplyEditorLoadoutPreview (ref)
        ApplyEditorLoadoutPreview();
    end);
    Skins.OnItemStockSchemasUpdated:Connect(function() -- Line: 1826
        -- upvalues: ApplyEditorLoadoutPreview (ref)
        ApplyEditorLoadoutPreview();
    end);
    UserInputService.InputBegan:Connect(function(p314: userdata) -- Line: 1830
        -- upvalues: u11 (ref), u23 (ref), u24 (ref), StartEditorPinch (ref), TryDeselectFromEmptyTouch (ref)
        if not u11 then
            return;
        end;

        local v315;

        if p314.UserInputType == Enum.UserInputType.Touch or p314.UserInputType == Enum.UserInputType.MouseButton1 then
            v315 = p314.UserInputState == Enum.UserInputState.Begin;
        else
            v315 = false;
        end;

        if not v315 then
            return;
        end;

        if p314.UserInputType == Enum.UserInputType.Touch then
            local v316 = u23;

            if v316 and (not u24 and v316.input ~= p314) then
                StartEditorPinch(v316.buttonName, v316.input, p314);
            end;
        end;

        task.defer(TryDeselectFromEmptyTouch, p314);
    end);
    UserInputService.InputChanged:Connect(function(p317: userdata) -- Line: 1845
        -- upvalues: u11 (ref), u22 (ref), UpdateResizeFromInput (ref), u24 (ref), UpdatePinchFromInput (ref), u23 (ref), UpdateDragFromInput (ref)
        if not (u11 and (p317.UserInputType == Enum.UserInputType.Touch or p317.UserInputType == Enum.UserInputType.MouseMovement)) then
            return;
        end;

        if u22 then
            UpdateResizeFromInput(p317);

            return;
        end;

        if u24 then
            UpdatePinchFromInput(p317);

            return;
        end;

        if u23 then
            UpdateDragFromInput(p317);
        end;
    end);
    UserInputService.InputEnded:Connect(function(p318: userdata) -- Line: 1861
        -- upvalues: u22 (ref), u33 (ref), u34 (ref), u32 (ref), UserInputService (ref), u24 (ref), u15 (ref), u16 (ref), u17 (ref), GuiService (ref), SelectEditorButton (ref), u23 (ref), StartEditorDrag (ref), RefreshEditorInteraction (ref)
        if p318.UserInputType ~= Enum.UserInputType.Touch and p318.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v319 = u22;

        if v319 then
            local input = v319.input;
            local v320;

            if p318 == input then
                v320 = true;
            else
                local UserInputType = p318.UserInputType;
                local UserInputType2 = input.UserInputType;
                v320 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
            end;

            if v320 then
                u22 = nil;
                u33 = nil;
                local v321 = u33 or (u34 or u32 or "");

                if UserInputService.MouseIcon ~= v321 then
                    UserInputService.MouseIcon = v321;
                end;

                return;
            end;
        end;

        local v322 = false;
        local v323 = nil;
        local v324 = u24;
        local v325;

        if v324 and (p318 == v324.anchorInput or p318 == v324.scaleInput) then
            v325 = v324.buttonName;

            if p318 == v324.scaleInput then
                v323 = v324.anchorInput;
                v322 = true;
            end;

            u24 = nil;
        else
            v325 = nil;
        end;

        local v326 = u15[p318];

        if v326 then
            u15[p318] = nil;
            local v327 = u16[v326];

            if v327 then
                v327[p318] = nil;

                if next(v327) == nil then
                    u16[v326] = nil;
                end;
            end;
        else
            v326 = nil;
        end;

        local v328 = u17[p318];
        u17[p318] = nil;

        if v326 and (not v325 and v328) then
            local GuiInset = GuiService:GetGuiInset();

            if (Vector2.new(p318.Position.X - GuiInset.X, p318.Position.Y - GuiInset.Y) - v328).Magnitude <= 12 then
                SelectEditorButton(v326);
            end;
        end;

        local v329 = u23;

        if v329 then
            local input = v329.input;
            local v330;

            if p318 == input then
                v330 = true;
            else
                local UserInputType = p318.UserInputType;
                local UserInputType2 = input.UserInputType;
                v330 = (UserInputType == Enum.UserInputType.MouseMovement and true or UserInputType == Enum.UserInputType.MouseButton1) and (UserInputType2 == Enum.UserInputType.MouseMovement and true or UserInputType2 == Enum.UserInputType.MouseButton1);
            end;

            if v330 then
                u23 = nil;
                u34 = nil;
                local v331 = u33 or u34 or (u32 or "");

                if UserInputService.MouseIcon ~= v331 then
                    UserInputService.MouseIcon = v331;
                end;
            end;
        end;

        local v332 = v326 or v325;

        if v322 and (v323 and (v332 and u15[v323] == v332)) then
            StartEditorDrag(v332, v323);
        end;

        if v332 then
            RefreshEditorInteraction(v332);
        end;
    end);
end;

function v1.Initialize(p333: userdata, p334: userdata) -- Line: 1922
    -- upvalues: u8 (ref), u9 (ref), u10 (ref), ConnectEditorVisibilityGuards (copy), SetDashboardEditorVisibility (copy), UpdateEditMobileButtonVisibility (copy), UserInputService (copy), GetEditMobileEntryButton (copy), ActivateButton (copy), Router (copy), EnterMobileHUDEditor (copy), SetupEditorControls (copy), ConnectGlobalInputHandlers (copy)
    u8 = p333;
    local EditMobile = p334:FindFirstChild("EditMobile");
    local v335;

    if p334.Name == "EditMobile" then
        v335 = p334.Parent;

        if v335 then
            if not v335:IsA("Frame") then
                v335 = p334;
            end;
        else
            v335 = p334;
        end;
    else
        v335 = p334;
        p334 = EditMobile;
    end;

    u9 = v335;
    u10 = p334;
    ConnectEditorVisibilityGuards();
    SetDashboardEditorVisibility(false);
    UpdateEditMobileButtonVisibility(UserInputService:GetLastInputType());
    local v336 = GetEditMobileEntryButton();

    if v336 then
        ActivateButton(v336);
        v336.MouseButton1Click:Connect(function() -- Line: 1784
            -- upvalues: Router (ref), EnterMobileHUDEditor (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            EnterMobileHUDEditor();
        end);
    end;

    SetupEditorControls();
    ConnectGlobalInputHandlers();
end;

function v1.ShouldShowEntryButton(p337) -- Line: 1950
    -- upvalues: GetUserPlatform (copy), UserInputService (copy)
    local v338 = GetUserPlatform();
    local v339;

    if table.find(v338, "Mobile") == nil then
        v339 = false;
    else
        v339 = #v338 <= 1;
    end;

    return v339 or (p337 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch;
end;

function v1.Open() -- Line: 1956
    -- upvalues: EnterMobileHUDEditor (copy)
    EnterMobileHUDEditor();
end;

return v1;