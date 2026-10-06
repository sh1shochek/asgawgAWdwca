-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local GuiInset = GuiService:GetGuiInset();
local script_Parent = script.Parent;
local Shared = script_Parent.Parent.Shared;
local Tab = require(script_Parent.Tab);
local Style = require(script_Parent.Style);
local Constants = require(Shared.Constants);
local script_TabFrame = require(script.TabFrame);
local u1 = {
    internal = {
        ActiveTab = nil,
        ActiveContentTabFrame = nil,
        Tabs = {}
    },
    private = {
        Dragging = false,
        InterfaceCreated = false,
        InterfaceElements = {
            Tabs = nil,
            ContentFrame = nil,
            ScreenGui = nil
        },
        Tabs = {}
    },
    interface = {}
};

function u1.internal.focusModule(p2: string) -- Line: 43
    -- upvalues: u1 (copy), Tab (copy)
    local ActiveTab = u1.internal.ActiveTab;

    if ActiveTab and ActiveTab.Name == p2 then
        return;
    end;

    local TabConstructor = Tab.getTabConstructor(p2);

    if not TabConstructor then
        return;
    end;

    local ActiveContentTabFrame = u1.internal.ActiveContentTabFrame;

    if not ActiveContentTabFrame then
        return;
    end;

    if ActiveTab then
        u1.internal.Tabs[ActiveTab.Name]:Unfocus();
        ActiveTab.Destructor();
        local Children = ActiveContentTabFrame:GetChildren();

        if #Children > 0 then
            warn((`Tab '{ActiveTab.Name}' didn't cleanup unmounted interface properly, there are leftover elements:`));

            for _, v in Children do
                warn((`  ╠ {v.Name}({v.ClassName})`));
                v:Destroy();
            end;
        end;
    end;

    u1.internal.ActiveTab = {
        Name = p2,
        Destructor = TabConstructor(ActiveContentTabFrame)
    };
    u1.internal.Tabs[p2]:Focus();
end;

function u1.internal.tabAdded(u3: string) -- Line: 83
    -- upvalues: script_TabFrame (copy), u1 (copy)
    local v4 = script_TabFrame.new(u3, u1.private.InterfaceElements.Tabs, u1.private.InterfaceElements.ContentFrame);
    v4.TabActivated:Connect(function() -- Line: 90
        -- upvalues: u1 (ref), u3 (copy)
        u1.internal.focusModule(u3);
    end);
    u1.internal.Tabs[u3] = v4;

    if not u1.internal.ActiveTab then
        u1.internal.focusModule(u3);
    end;
end;

function u1.private.CreateInterface(u5) -- Line: 101
    -- upvalues: Style (copy), Constants (copy), GuiInset (copy), UserInputService (copy), Players (copy), u1 (copy)
    assert(not u5.InterfaceCreated, "Tried to create interface when it was already created!");
    u5.InterfaceCreated = true;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromOffset(624, 375);
    Frame.BackgroundTransparency = 0.15;
    Frame.BackgroundColor3 = Style.BACKGROUND;
    Frame.BorderSizePixel = 0;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(98, 114, 164);
    UIStroke.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Header";
    TextLabel.AutoLocalize = false;
    TextLabel.Size = UDim2.new(1, 0, 0, 18);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = "DEBUG TOOLS";
    TextLabel.TextColor3 = Style.TEXT;
    TextLabel.TextSize = 18;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.BackgroundColor3 = Style.COLOR_WHITE;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Version";
    TextLabel2.AutoLocalize = false;
    TextLabel2.Size = UDim2.new(1, 0, 0, 18);
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Text = Constants.VERSION;
    TextLabel2.TextColor3 = Style.TEXT;
    TextLabel2.TextSize = 10;
    TextLabel2.TextTransparency = 0.75;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel2.BackgroundColor3 = Style.COLOR_WHITE;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.BorderSizePixel = 0;
    TextLabel2.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 8);
    UIPadding.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 4);
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Content Frame";
    Frame2.Position = UDim2.fromOffset(0, 24);
    Frame2.Size = UDim2.new(1, 0, 1, -24);
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderSizePixel = 0;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Active Tab Content";
    Frame3.AnchorPoint = Vector2.new(0, 1);
    Frame3.Position = UDim2.fromScale(0, 1);
    Frame3.Size = UDim2.new(1, 0, 1, -16);
    Frame3.BackgroundTransparency = 1;
    Frame3.BorderSizePixel = 0;
    Frame3.ClipsDescendants = true;
    Frame3.ZIndex = 2;
    Frame3.Parent = Frame2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Tabs";
    Frame4.Size = UDim2.new(1, 0, 0, 16);
    Frame4.BackgroundTransparency = 1;
    Frame4.BorderSizePixel = 0;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.SortOrder = Enum.SortOrder.Name;
    UIListLayout.Parent = Frame4;
    Frame4.Parent = Frame2;
    Frame2.Parent = Frame;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Drag Detector";
    TextButton.Position = UDim2.new(0, -8, 0, -8);
    TextButton.Size = UDim2.new(1, 16, 0, 30);
    TextButton.BorderSizePixel = 0;
    TextButton.Text = "";
    TextButton.BackgroundTransparency = 1;
    TextButton.Modal = true;
    TextButton.Parent = Frame;
    TextButton.InputBegan:Connect(function(p6: userdata) -- Line: 210
        -- upvalues: u5 (copy), Frame (copy), GuiInset (ref), UserInputService (ref)
        if u5.Dragging or p6.UserInputType ~= Enum.UserInputType.MouseButton1 and p6.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v7 = Vector2.new(Frame.AbsolutePosition.X, Frame.AbsolutePosition.Y) + GuiInset;
        u5.Dragging = true;
        u5.DragOffset = v7 - UserInputService:GetMouseLocation();
        u5.InputChangedConnection = UserInputService.InputChanged:Connect(function(p8: userdata) -- Line: 229
            -- upvalues: Frame (ref), u5 (ref), GuiInset (ref)
            if p8.UserInputType ~= Enum.UserInputType.MouseMovement and p8.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            local v9 = -(Frame.AbsoluteSize * -Frame.AnchorPoint);
            local v10 = Vector2.new(p8.Position.X, p8.Position.Y) + u5.DragOffset + GuiInset + v9;
            local Vector2_new_ret = Vector2.new(math.max(0, v10.X), (math.max(0, v10.Y)));
            Frame.Position = UDim2.fromOffset(Vector2_new_ret.X, Vector2_new_ret.Y);
        end);
        u5.InputEndedConnection = UserInputService.InputEnded:Connect(function(p11: userdata) -- Line: 249
            -- upvalues: u5 (ref)
            if p11.UserInputType ~= Enum.UserInputType.MouseButton1 and p11.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            u5.Dragging = false;
            u5.InputEndedConnection:Disconnect();
            u5.InputChangedConnection:Disconnect();
        end);
    end);
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "[DEBUG] Main Interface";
    ScreenGui.DisplayOrder = Constants.DEBUG_TOOL_DISPLAY_ORDER;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Enabled = false;
    Frame.Parent = ScreenGui;
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui;
    u5.InterfaceElements.ContentFrame = Frame2;
    u5.InterfaceElements.Tabs = Frame4;
    u5.InterfaceElements.ScreenGui = ScreenGui;
    u1.internal.ActiveContentTabFrame = Frame3;
    ScreenGui.DescendantAdded:Connect(function(p12: userdata) -- Line: 283
        if not (p12:IsA("TextLabel") or (p12:IsA("TextButton") or p12:IsA("TextBox"))) then
            return;
        end;

        if p12.AutoLocalize then
            warn((`A descendant was added to Debug Tools interface that has AutoLocalize enabled, every Instance that inherits GuiBase2d should have it's AutoLocalize property set to false!\n{p12:GetFullName()}`));
        end;

        p12.AutoLocalize = false;
    end);
end;

function u1.private.ListenToModules(p13) -- Line: 302
    -- upvalues: Tab (copy), u1 (copy)
    for _, v in Tab.getAllTabs() do
        u1.internal.tabAdded(v);
    end;

    Tab.TabAdded:Connect(function(p14) -- Line: 307
        -- upvalues: u1 (ref)
        u1.internal.tabAdded(p14);
    end);
end;

function u1.interface.init() -- Line: 312
    -- upvalues: u1 (copy)
    u1.private:CreateInterface();
    u1.private:ListenToModules();
end;

function u1.interface.switchVisibility() -- Line: 317
    -- upvalues: u1 (copy)
    local ScreenGui = u1.private.InterfaceElements.ScreenGui;

    if not ScreenGui then
        return;
    end;

    ScreenGui.Enabled = not ScreenGui.Enabled;
end;

return u1.interface;