-- ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Inventory.TradeUp
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Inventory.TradeUp
-- Decompile time: 12.90 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("HttpService");
local TweenService = game:GetService("TweenService");
local _ = game:GetService("Players").LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = {};
local u9 = 0;
local u10 = nil;
local u11 = false;
local u12 = false;

function u1.Draw(p13) -- Line: 24
    -- upvalues: u2 (ref), u11 (ref), TweenService (copy), u12 (ref), u8 (copy), u4 (ref), u1 (copy), u5 (ref)
    local Proceed = (nil).Down.Proceed;
    local Clear = (nil).Down.Clear;
    u2:AddConnection("Proceed_MouseEnter", Proceed.MouseEnter:Connect(function() -- Line: 57
        -- upvalues: u11 (ref), TweenService (ref), Proceed (copy)
        if not u11 then
            return;
        end;

        TweenService:Create(Proceed, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(15, 158, 87)
        }):Play();
    end));
    u2:AddConnection("Proceed_MouseLeave", Proceed.MouseLeave:Connect(function() -- Line: 64
        -- upvalues: u11 (ref), TweenService (ref), Proceed (copy)
        if not u11 then
            return;
        end;

        TweenService:Create(Proceed, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(18, 188, 103)
        }):Play();
    end));
    u2:AddConnection("Proceed_Click", Proceed.MouseButton1Click:Connect(function() -- Line: 71
        -- upvalues: u11 (ref), u12 (ref), u8 (ref), u4 (ref), u1 (ref), u5 (ref)
        if not u11 then
            return;
        end;

        if not u12 then
            return;
        end;

        local v14 = {};

        for _, v in u8 do
            table.insert(v14, v);
        end;

        u4.TradeUp.Fire(v14);
        u1:Reset();
        u5:AESGsagsag();
    end));
    u2:AddConnection("Clear_MouseEnter", Clear.MouseEnter:Connect(function() -- Line: 95
        -- upvalues: TweenService (ref), Clear (copy)
        TweenService:Create(Clear, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.9
        }):Play();
    end));
    u2:AddConnection("Clear_MouseLeave", Clear.MouseLeave:Connect(function() -- Line: 99
        -- upvalues: TweenService (ref), Clear (copy)
        TweenService:Create(Clear, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play();
    end));
    u2:AddConnection("Clear_Click", Clear.MouseButton1Click:Connect(function() -- Line: 103
        -- upvalues: u1 (ref)
        u1:Reset(true);
    end));
    u2:AddConnection("Toggle_MouseEnter", (nil).Main.Exchange.Toggle.MouseEnter:Connect(function() -- Line: 112
        -- upvalues: TweenService (ref)
        TweenService:Create((nil).Main.Exchange.Toggle, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.9
        }):Play();
    end));
    u2:AddConnection("Toggle_MouseLeave", (nil).Main.Exchange.Toggle.MouseLeave:Connect(function() -- Line: 116
        -- upvalues: TweenService (ref)
        TweenService:Create((nil).Main.Exchange.Toggle, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play();
    end));
    u2:AddConnection("Toggle_Click", (nil).Main.Exchange.Toggle.MouseButton1Click:Connect(function() -- Line: 119
        -- upvalues: u1 (ref)
        u1:Toggle();
    end));
    u1:Toggle(true);
    u1:UpdateToggle();
end;

function u1.AddToExchange(p15, p16, p17, p18, p19, p20) -- Line: 127
    -- upvalues: u8 (copy), u10 (ref), u12 (ref), u9 (ref), u1 (copy)
    if p17 == "Exotic" or p17 == "Vanilla" then
        return;
    end;

    if u8[p16] then
        return;
    end;

    if u10 then
        if u10 ~= p17 then
            return;
        end;

        if u12 then
            return;
        end;
    else
        u10 = p17;
    end;

    u8[p16] = {
        WeaponName = p18,
        SkinName = p19,
        SkinId = p20
    };
    u9 = u9 + 1;
    u1:Toggle(true);
    u1:UpdateToggle();
    p16.Parent = (nil).Main.Exchange.ScrollingFrame;
end;

function u1.BackToInventory(p21, p22) -- Line: 167
    -- upvalues: u8 (copy), u9 (ref), u10 (ref), u1 (copy)
    if not u8[p22] then
        return;
    end;

    if u9 <= 1 then
        u10 = nil;
    end;

    u8[p22] = nil;
    u9 = u9 - 1;
    u1:Toggle(true);
    u1:UpdateToggle();
    p22.Parent = (nil).Main.Inventory.ScrollingFrame;
end;

function u1.UpdateToggle(p23) -- Line: 186
    -- upvalues: u10 (ref), u9 (ref), u12 (ref), TweenService (copy)
    local v24 = u10 == "Elite" and 5 or 10;
    (nil).Main.Inventory.Top.Title.Text = `{#(nil).Main.Inventory.ScrollingFrame:GetChildren() - 2} Eligible for Exchange`;
    (nil).Main.Exchange.Top.Title.Text = `{u9}/{v24} for Exchange`;

    if u9 == v24 then
        u12 = true;
        TweenService:Create((nil).Main.Exchange.Toggle.Title, TweenInfo.new(0.25), {
            TextTransparency = 0
        }):Play();
        TweenService:Create((nil).Main.Exchange.Toggle.ImageButton.UIStroke, TweenInfo.new(0.25), {
            Transparency = 0
        }):Play();

        return;
    end;

    u12 = false;
    TweenService:Create((nil).Main.Exchange.Toggle.Title, TweenInfo.new(0.25), {
        TextTransparency = 0.5
    }):Play();
    TweenService:Create((nil).Main.Exchange.Toggle.ImageButton.UIStroke, TweenInfo.new(0.25), {
        Transparency = 0.5
    }):Play();
end;

function u1.Toggle(p25, p26) -- Line: 203
    -- upvalues: u12 (ref), TweenService (copy), u11 (ref)
    if not u12 then
        TweenService:Create((nil).Main.Exchange.Toggle.ImageButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play();
        TweenService:Create((nil).Down.Proceed, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(12, 132, 72)
        }):Play();
        TweenService:Create((nil).Down.Proceed.TextLabel, TweenInfo.new(0.25), {
            TextTransparency = 0.5
        }):Play();

        return;
    end;

    u11 = not u11;

    if p26 then
        u11 = false;
    end;

    if u11 then
        TweenService:Create((nil).Main.Exchange.Toggle.ImageButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 0
        }):Play();
        TweenService:Create((nil).Down.Proceed, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(18, 188, 103)
        }):Play();
        TweenService:Create((nil).Down.Proceed.TextLabel, TweenInfo.new(0.25), {
            TextTransparency = 0
        }):Play();

        return;
    end;

    TweenService:Create((nil).Main.Exchange.Toggle.ImageButton, TweenInfo.new(0.25), {
        BackgroundTransparency = 1
    }):Play();
    TweenService:Create((nil).Down.Proceed, TweenInfo.new(0.25), {
        BackgroundColor3 = Color3.fromRGB(12, 132, 72)
    }):Play();
    TweenService:Create((nil).Down.Proceed.TextLabel, TweenInfo.new(0.25), {
        TextTransparency = 0.5
    }):Play();
end;

function u1.Reset(p27, p28) -- Line: 230
    -- upvalues: u8 (copy), u1 (copy), u9 (ref), u10 (ref)
    if p28 then
        for i in u8 do
            u1:BackToInventory(i);
        end;
    else
        for i in u8 do
            if u9 <= 1 then
                u10 = nil;
            end;

            u8[i] = nil;
            u9 = u9 - 1;
        end;
    end;

    u9 = 0;
    u1:Toggle(true);
    u1:UpdateToggle();
end;

function u1.Init(p29, p30, p31) -- Line: 258
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u6 (ref), u7 (ref), u5 (ref)
    u2 = p29:GetModule("Maid").new();
    u3 = p29:GetModule("Enums");
    u4 = p29:GetModule("Blink");
    u6 = p29:GetModule("ItemManager");
    u7 = p29:GetModule("SkinManager");
    u5 = p29:GetModule("Inventory");
end;

function u1.new() -- Line: 280
    local Frame = Instance.new("Frame");
    Frame.Name = "TradeUp";
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0, 0);
    Frame.Size = UDim2.fromScale(1, 0.942);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Tip";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.04);
    Frame2.Size = UDim2.fromScale(0.5, 0.045);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "MainText";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.05, 0.5);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(1, 0.8);
    TextLabel.Text = "Exchange: items of <font transparency=\"0\" weight=\"bold\"><b>identical quality</b></font> Receive: <font transparency=\"0\" weight=\"bold\"><b>1 item of the next highest quality, from a collection of one of the items provided</b></font>";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.25;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconInfo";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://80205853195967";
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Main";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.08);
    Frame3.Size = UDim2.fromScale(1, 0.82);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.8;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Size = UDim2.new(1, 0, 0, 1);
    Frame4.Parent = Frame3;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Line";
    Frame5.AnchorPoint = Vector2.new(0.5, 0);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BackgroundTransparency = 0.8;
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.new(0.5, 0, 0, 1);
    Frame5.Size = UDim2.new(0, 1, 1, 0);
    Frame5.Parent = Frame3;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Inventory";
    Frame6.BackgroundTransparency = 1;
    Frame6.Size = UDim2.fromScale(0.5, 1);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Top";
    Frame7.BackgroundTransparency = 1;
    Frame7.Size = UDim2.fromScale(1, 0.08);
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "TextButton";
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.fromEnum(Enum.Font.SourceSans);
    TextButton.Position = UDim2.fromScale(0.98, 0.5);
    TextButton.Size = UDim2.fromScale(0.16, 0.6);
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.TextTransparency = 1;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextLabel";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.05, 0.5);
    TextLabel2.Size = UDim2.fromScale(1, 0.5);
    TextLabel2.Text = "AKR";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel2.Parent = TextButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "V";
    ImageLabel2.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://125527069434921";
    ImageLabel2.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel2.Rotation = 90;
    ImageLabel2.Size = UDim2.fromScale(0.4, 0.4);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = TextButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 1.3;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = TextButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextButton;
    TextButton.Parent = Frame7;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.LayoutOrder = 4;
    TextLabel3.Position = UDim2.fromScale(0.04, 0.5);
    TextLabel3.RichText = true;
    TextLabel3.Size = UDim2.fromScale(0.3, 0.4);
    TextLabel3.Text = "5 Eligible for Exchange";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.25;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.ZIndex = 9;
    TextLabel3.Parent = Frame7;
    Frame7.Parent = Frame6;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ScrollingFrame";
    ScrollingFrame.Active = true;
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.Position = UDim2.fromScale(0.05, 0.1);
    ScrollingFrame.ScrollBarThickness = 6;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Size = UDim2.fromScale(0.85, 0.9);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.BorderSizePixel = 0;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.03, 0.1);
    UIGridLayout.CellSize = UDim2.fromScale(0.22, 0.24);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.425;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = ScrollingFrame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.01, 0);
    UIPadding.PaddingLeft = UDim.new(0.012, 0);
    UIPadding.PaddingRight = UDim.new(0.012, 0);
    UIPadding.PaddingTop = UDim.new(0.01, 0);
    UIPadding.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame6;
    Frame6.Parent = Frame3;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Exchange";
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0);
    Frame8.Size = UDim2.fromScale(0.5, 1);
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Top";
    Frame9.BackgroundTransparency = 1;
    Frame9.Size = UDim2.fromScale(1, 0.08);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.LayoutOrder = 4;
    TextLabel4.Position = UDim2.fromScale(0.04, 0.5);
    TextLabel4.RichText = true;
    TextLabel4.Size = UDim2.fromScale(0.3, 0.4);
    TextLabel4.Text = "5/5 for Exchange";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.25;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame9;
    Frame9.Parent = Frame8;
    local ScrollingFrame2 = Instance.new("ScrollingFrame");
    ScrollingFrame2.Name = "ScrollingFrame";
    ScrollingFrame2.Active = true;
    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame2.BackgroundTransparency = 1;
    ScrollingFrame2.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame2.CanvasSize = UDim2.fromScale(0, 0.9);
    ScrollingFrame2.Position = UDim2.fromScale(0.05, 0.1);
    ScrollingFrame2.ScrollBarThickness = 6;
    ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame2.Size = UDim2.fromScale(0.85, 0.9);
    ScrollingFrame2.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIGridLayout2 = Instance.new("UIGridLayout");
    UIGridLayout2.Name = "UIGridLayout";
    UIGridLayout2.CellPadding = UDim2.fromScale(0.03, 0.1);
    UIGridLayout2.CellSize = UDim2.fromScale(0.22, 0.24);
    UIGridLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 1.425;
    UIAspectRatioConstraint2.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint2.Parent = UIGridLayout2;
    UIGridLayout2.Parent = ScrollingFrame2;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingLeft = UDim.new(0.012, 0);
    UIPadding2.PaddingRight = UDim.new(0.012, 0);
    UIPadding2.PaddingTop = UDim.new(0.02, 0);
    UIPadding2.Parent = ScrollingFrame2;
    ScrollingFrame2.Parent = Frame8;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Toggle";
    TextButton2.AnchorPoint = Vector2.new(1, 1);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundTransparency = 1;
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton2.LayoutOrder = 2;
    TextButton2.Position = UDim2.fromScale(0.9898, 0.98);
    TextButton2.Size = UDim2.fromScale(0.2298, 0.06);
    TextButton2.Text = "";
    TextButton2.TextColor3 = Color3.new();
    TextButton2.TextSize = 14;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.new(0.225001, 0, 0.5, -1);
    TextLabel5.Size = UDim2.fromScale(0.732354, 0.6);
    TextLabel5.Text = "READY TO TRADE UP";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.Parent = TextButton2;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ImageButton";
    ImageButton.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = UDim2.fromScale(0.05, 0.5);
    ImageButton.Size = UDim2.new(0.6, -4, 0.6, -4);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke2.Thickness = 0.1;
    UIStroke2.Parent = ImageButton;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.02, 0);
    UICorner2.Parent = ImageButton;
    ImageButton.Parent = TextButton2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "Corner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = TextButton2;
    TextButton2.Parent = Frame8;
    Frame8.Parent = Frame3;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Line";
    Frame10.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame10.BackgroundTransparency = 0.8;
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0, 1);
    Frame10.Size = UDim2.new(1, 0, 0, 1);
    Frame10.Parent = Frame3;
    Frame3.Parent = Frame;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Down";
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(0, 0.9);
    Frame11.Size = UDim2.fromScale(1, 0.1);
    Frame11.ZIndex = 53215;
    local UIPadding3 = Instance.new("UIPadding");
    UIPadding3.Name = "PaddingDown";
    UIPadding3.PaddingBottom = UDim.new(0.225, 0);
    UIPadding3.PaddingRight = UDim.new(0.04, 0);
    UIPadding3.PaddingTop = UDim.new(0.225, 0);
    UIPadding3.Parent = Frame11;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "ListLayoutDown";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.01, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame11;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Clear";
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Size = UDim2.fromScale(0.06, 1);
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "Corner1";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = ImageButton2;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "TextLabel";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.fromEnum(Enum.Font.Oswald);
    TextLabel6.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel6.Size = UDim2.fromScale(0.9, 0.6);
    TextLabel6.Text = "CLEAR ITEMS";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel6.ZIndex = 343;
    TextLabel6.Parent = ImageButton2;
    ImageButton2.Parent = Frame11;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Proceed";
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ImageButton3.Size = UDim2.fromScale(0.05, 1);
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "CornerClose";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = ImageButton3;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "TextLabel";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.fromEnum(Enum.Font.Oswald);
    TextLabel7.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel7.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel7.Text = "PROCEED...";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel7.ZIndex = 343;
    TextLabel7.Parent = ImageButton3;
    ImageButton3.Parent = Frame11;
    Frame11.Parent = Frame;
    Frame.Parent = Parent;
end;

return u1;