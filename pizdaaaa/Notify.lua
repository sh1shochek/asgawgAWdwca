-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Notify
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Notify
-- Decompile time: 23.16 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("ReplicatedStorage");
game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = false;
local Color3_fromRGB_ret = Color3.fromRGB(240, 240, 240);
local Color3_fromRGB_ret2 = Color3.fromRGB(150, 150, 150);
local Color3_fromRGB_ret3 = Color3.fromRGB(80, 80, 86);
local Color3_fromRGB_ret4 = Color3.fromRGB(230, 115, 115);
local TweenInfo_new_ret = TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.65, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local TweenInfo_new_ret3 = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local TweenInfo_new_ret4 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret5 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local TweenInfo_new_ret6 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

local function Format(p7: number) -- Line: 38
    return tostring(p7):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function Balances() -- Line: 42
    -- upvalues: LocalPlayer (copy), u4 (ref)
    local v8 = LocalPlayer:GetAttribute("LockedKredits") or 0;

    return u4.Get("Credits") - v8, v8;
end;

local function Payable(p9) -- Line: 48
    -- upvalues: LocalPlayer (copy), u4 (ref)
    local v10 = LocalPlayer:GetAttribute("LockedKredits") or 0;

    return {
        Own = p9 <= u4.Get("Credits") - v10,
        Locked = p9 <= v10
    };
end;

local function Layout(p11: boolean) -- Line: 57
    -- upvalues: u5 (ref)
    local v12 = p11 and 0.3 or 0.2;
    u5.Size = UDim2.fromScale(0.25, v12);
    u5.Title.Size = UDim2.fromScale(1, 0.06 / v12);
    u5.Title.Price.Visible = p11;
    u5.AreYouSure.Position = UDim2.fromScale(0.5, p11 and 0.235 or 0.375);
    u5.AreYouSure.Size = UDim2.fromScale(0.9, p11 and 0.073 or 0.125);
    u5.Confirm.Position = UDim2.fromScale(0.775, 1 - 0.02 / v12);
    u5.Confirm.Size = UDim2.fromScale(0.2, 0.04 / v12);
    u5.Close.Position = UDim2.fromScale(0.95, 1 - 0.02 / v12);
    u5.Close.Size = UDim2.fromScale(0.15, 0.04 / v12);
    u5.Pay.Visible = p11;
end;

local function DrawPay(p13) -- Line: 72
    -- upvalues: LocalPlayer (copy), u4 (ref), u6 (ref), u5 (ref), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), TweenService (copy), TweenInfo_new_ret6 (copy), Color3_fromRGB_ret4 (copy)
    local v14 = LocalPlayer:GetAttribute("LockedKredits") or 0;
    local v15 = u4.Get("Credits") - v14;
    local v16 = LocalPlayer:GetAttribute("LockedKredits") or 0;
    local v17 = {
        Own = p13 <= u4.Get("Credits") - v16,
        Locked = p13 <= v16
    };

    if not v17[u6 and "Locked" or "Own"] then
        u6 = v17.Locked;
    end;

    for _, v in { u5.Pay.Own, u5.Pay.Locked } do
        local v18 = v.Name == "Locked" and v14 and v14 or v15;
        local v19 = v17[v.Name];
        local v20;

        if v19 then
            v20 = v.Name == "Locked" == u6;
        else
            v20 = v19;
        end;

        local v21 = v20 and Color3_fromRGB_ret or (v19 and Color3_fromRGB_ret2 or Color3_fromRGB_ret3);
        v.Balance.Text = tostring(v18):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        v.After.Text = v19 and `{tostring(v18 - p13):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")} after` or `needs {tostring(p13):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        TweenService:Create(v, TweenInfo_new_ret6, {
            BackgroundTransparency = v20 and 0.9 or 1
        }):Play();
        TweenService:Create(v.UIStroke, TweenInfo_new_ret6, {
            Transparency = v20 and 0.55 or 0.88
        }):Play();
        TweenService:Create(v.Accent, TweenInfo_new_ret6, {
            BackgroundTransparency = v20 and 0 or 1
        }):Play();
        TweenService:Create(v.Ring.UIStroke, TweenInfo_new_ret6, {
            Transparency = v19 and 0.35 or 0.8
        }):Play();
        TweenService:Create(v.Ring.Dot, TweenInfo_new_ret6, {
            BackgroundTransparency = v20 and 0 or 1
        }):Play();
        TweenService:Create(v.Icon, TweenInfo_new_ret6, {
            ImageColor3 = v21
        }):Play();
        TweenService:Create(v.Title, TweenInfo_new_ret6, {
            TextColor3 = v21
        }):Play();
        TweenService:Create(v.Balance, TweenInfo_new_ret6, {
            TextColor3 = v21
        }):Play();
        TweenService:Create(v.Sub, TweenInfo_new_ret6, {
            TextColor3 = v19 and Color3_fromRGB_ret2 or Color3_fromRGB_ret3
        }):Play();
        TweenService:Create(v.After, TweenInfo_new_ret6, {
            TextColor3 = v19 and Color3_fromRGB_ret2 or Color3_fromRGB_ret4
        }):Play();
    end;
end;

function u1.Create(p22, p23, p24, u25, u26) -- Line: 102
    -- upvalues: u5 (ref), LocalPlayer (copy), Layout (copy), DrawPay (copy), u2 (ref), u4 (ref), u6 (ref), TweenService (copy), TweenInfo_new_ret6 (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), TweenInfo_new_ret4 (copy), TweenInfo_new_ret5 (copy), TweenInfo_new_ret3 (copy)
    if u5.Visible then
        return;
    end;

    local u27;

    if u26 == nil then
        u27 = false;
    else
        u27 = (LocalPlayer:GetAttribute("LockedKredits") or 0) > 0;
    end;

    Layout(u27);

    if u27 then
        u5.Title.Price.Amount.Text = tostring(u26):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        DrawPay(u26);

        for _, v in { u5.Pay.Own, u5.Pay.Locked } do
            u2:Add(`Pay{v.Name}Click`, v.MouseButton1Click:Connect(function() -- Line: 116
                -- upvalues: u26 (copy), LocalPlayer (ref), u4 (ref), v (copy), u6 (ref), DrawPay (ref)
                local v28 = u26;
                local v29 = LocalPlayer:GetAttribute("LockedKredits") or 0;

                if not ({
                    Own = v28 <= u4.Get("Credits") - v29,
                    Locked = v28 <= v29
                })[v.Name] then
                    return;
                end;

                u6 = v.Name == "Locked";
                DrawPay(u26);
            end));
            u2:Add(`Pay{v.Name}Enter`, v.MouseEnter:Connect(function() -- Line: 125
                -- upvalues: u26 (copy), LocalPlayer (ref), u4 (ref), v (copy), u6 (ref), TweenService (ref), TweenInfo_new_ret6 (ref)
                local v30 = u26;
                local v31 = LocalPlayer:GetAttribute("LockedKredits") or 0;

                if ({
                    Own = v30 <= u4.Get("Credits") - v31,
                    Locked = v30 <= v31
                })[v.Name] and v.Name == "Locked" ~= u6 then
                    TweenService:Create(v, TweenInfo_new_ret6, {
                        BackgroundTransparency = 0.95
                    }):Play();
                end;
            end));
            u2:Add(`Pay{v.Name}Leave`, v.MouseLeave:Connect(function() -- Line: 131
                -- upvalues: DrawPay (ref), u26 (copy)
                DrawPay(u26);
            end));
        end;
    end;

    u5.Visible = true;
    u5.GroupTransparency = 1;
    u5.UIStroke.Transparency = 1;
    u5.UIScale.Scale = 2;
    u5.Title.TextLabel.Text = p23;
    u5.AreYouSure.Text = p24;
    TweenService:Create(u5, TweenInfo_new_ret, {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(u5.UIScale, TweenInfo_new_ret2, {
        Scale = 1
    }):Play();
    TweenService:Create(u5.UIStroke, TweenInfo_new_ret, {
        Transparency = 0
    }):Play();

    for _, v in { "Confirm", "Close" } do
        local u32 = u5[v];
        u32.BackgroundTransparency = 1;
        u2:Add(`{v}InputBegan`, u32.InputBegan:Connect(function() -- Line: 161
            -- upvalues: TweenService (ref), u32 (copy), TweenInfo_new_ret4 (ref)
            TweenService:Create(u32, TweenInfo_new_ret4, {
                BackgroundTransparency = 0.85
            }):Play();
        end));
        u2:Add(`{v}InputEnded`, u32.InputEnded:Connect(function() -- Line: 166
            -- upvalues: TweenService (ref), u32 (copy), TweenInfo_new_ret5 (ref)
            TweenService:Create(u32, TweenInfo_new_ret5, {
                BackgroundTransparency = 1
            }):Play();
        end));
        u2:Add(`{v}Click`, u32.MouseButton1Click:Connect(function() -- Line: 171
            -- upvalues: v (copy), u27 (copy), u26 (copy), LocalPlayer (ref), u4 (ref), u6 (ref), u2 (ref), u25 (copy), TweenService (ref), u5 (ref), TweenInfo_new_ret3 (ref)
            if v == "Confirm" and u27 then
                local v33 = u26;
                local v34 = LocalPlayer:GetAttribute("LockedKredits") or 0;

                if not ({
                    Own = v33 <= u4.Get("Credits") - v34,
                    Locked = v33 <= v34
                })[u6 and "Locked" or "Own"] then
                    return;
                end;
            end;

            u2:Removes(
                "ConfirmInputBegan",
                "ConfirmInputEnded",
                "ConfirmClick",
                "CloseInputBegan",
                "CloseInputEnded",
                "CloseClick",
                "PayOwnClick",
                "PayLockedClick",
                "PayOwnEnter",
                "PayLockedEnter",
                "PayOwnLeave",
                "PayLockedLeave"
            );

            if v == "Confirm" then
                u25(u27 and u6);
            end;

            TweenService:Create(u5, TweenInfo_new_ret3, {
                GroupTransparency = 1
            }):Play();
            TweenService:Create(u5.UIScale, TweenInfo_new_ret3, {
                Scale = 2
            }):Play();
            TweenService:Create(u5.UIStroke, TweenInfo_new_ret3, {
                Transparency = 1
            }):Play();
            task.delay(0.4, function() -- Line: 192
                -- upvalues: u5 (ref)
                u5.Visible = false;
            end);
        end));
    end;
end;

function u1.Close() -- Line: 199
    -- upvalues: u2 (ref), u5 (ref)
    u2:Removes(
        "ConfirmInputBegan",
        "ConfirmInputEnded",
        "ConfirmClick",
        "CloseInputBegan",
        "CloseInputEnded",
        "CloseClick",
        "PayOwnClick",
        "PayLockedClick",
        "PayOwnEnter",
        "PayLockedEnter",
        "PayOwnLeave",
        "PayLockedLeave"
    );
    u5.GroupTransparency = 1;
    u5.UIStroke.Transparency = 1;
    u5.UIScale.Scale = 2;
    u5.Visible = false;
end;

function u1.Init(p35, p36) -- Line: 210
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u1 (copy)
    u2 = p35:GetModule("Maid").new();
    u3 = p35:GetModule("Gui");
    u4 = p35:GetModule("ProfileData");
    u5 = u1.new();
end;

function u1.new() -- Line: 218
    -- upvalues: u3 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Notify";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.AutoLocalize = false;
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(18, 19, 24);
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(0.25, 0.2);
    CanvasGroup.ZIndex = 1000;
    CanvasGroup.LayoutOrder = 1000;
    CanvasGroup.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(112, 112, 112);
    UIStroke.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "Title";
    Frame.AutoLocalize = false;
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 0.3);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.Text = "Case Buy Confirm";
    TextLabel.TextColor3 = Color3.fromRGB(145, 145, 145);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 6;
    TextLabel.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.225, 0);
    UIPadding.PaddingLeft = UDim.new(0.05, 0);
    UIPadding.PaddingRight = UDim.new(0.05, 0);
    UIPadding.PaddingTop = UDim.new(0.225, 0);
    UIPadding.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = CanvasGroup;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "AreYouSure";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = 4;
    TextLabel2.Position = UDim2.fromScale(0.5, 0.375);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.125);
    TextLabel2.Text = "Are you sure you want to buy Legacy Case?";
    TextLabel2.TextColor3 = Color3.fromRGB(231, 231, 231);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 6;
    TextLabel2.Parent = CanvasGroup;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Close";
    TextButton.AnchorPoint = Vector2.new(1, 1);
    TextButton.AutoButtonColor = false;
    TextButton.AutoLocalize = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.fromEnum(Enum.Font.SourceSans);
    TextButton.LayoutOrder = 1;
    TextButton.Position = UDim2.fromScale(0.95, 0.9);
    TextButton.Size = UDim2.fromScale(0.15, 0.2);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.ZIndex = 3;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextButton;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.9, 0.8);
    TextLabel3.Text = "CLOSE";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextSize = 20;
    TextLabel3.TextWrapped = true;
    TextLabel3.Parent = TextButton;
    TextButton.Parent = CanvasGroup;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Confirm";
    TextButton2.AnchorPoint = Vector2.new(1, 1);
    TextButton2.AutoButtonColor = false;
    TextButton2.AutoLocalize = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.9;
    TextButton2.FontFace = Font.fromEnum(Enum.Font.SourceSans);
    TextButton2.LayoutOrder = 1;
    TextButton2.Position = UDim2.fromScale(0.775, 0.9);
    TextButton2.Size = UDim2.fromScale(0.2, 0.2);
    TextButton2.Text = "";
    TextButton2.TextColor3 = Color3.new();
    TextButton2.TextSize = 14;
    TextButton2.ZIndex = 3;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = TextButton2;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "TextLabel";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel4.Size = UDim2.fromScale(0.9, 0.8);
    TextLabel4.Text = "CONFIRM";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextSize = 20;
    TextLabel4.TextWrapped = true;
    TextLabel4.Parent = TextButton2;
    TextButton2.Parent = CanvasGroup;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Minus";
    TextButton3.AnchorPoint = Vector2.new(0, 1);
    TextButton3.AutoButtonColor = false;
    TextButton3.AutoLocalize = false;
    TextButton3.BackgroundTransparency = 1;
    TextButton3.FontFace = Font.fromEnum(Enum.Font.SourceSans);
    TextButton3.LayoutOrder = 1;
    TextButton3.Position = UDim2.fromScale(0.1, 0.9);
    TextButton3.Size = UDim2.fromScale(0.15, 0.15);
    TextButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton3.Text = "";
    TextButton3.TextColor3 = Color3.new();
    TextButton3.TextSize = 14;
    TextButton3.Visible = false;
    TextButton3.ZIndex = 3;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = TextButton3;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TextLabel";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel5.Size = UDim2.fromScale(1, 1);
    TextLabel5.Text = "-";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.Parent = TextButton3;
    TextButton3.Parent = CanvasGroup;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Amount";
    TextLabel6.AnchorPoint = Vector2.new(0, 1);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel6.LayoutOrder = 4;
    TextLabel6.Position = UDim2.fromScale(0.2, 0.9);
    TextLabel6.Size = UDim2.fromScale(0.1, 0.15);
    TextLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel6.Text = "1";
    TextLabel6.TextColor3 = Color3.fromRGB(147, 147, 147);
    TextLabel6.TextScaled = true;
    TextLabel6.TextTransparency = 0.6;
    TextLabel6.Visible = false;
    TextLabel6.ZIndex = 6;
    TextLabel6.Parent = CanvasGroup;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "Plus";
    TextButton4.AnchorPoint = Vector2.new(0, 1);
    TextButton4.AutoButtonColor = false;
    TextButton4.AutoLocalize = false;
    TextButton4.BackgroundTransparency = 1;
    TextButton4.FontFace = Font.fromEnum(Enum.Font.SourceSans);
    TextButton4.LayoutOrder = 1;
    TextButton4.Position = UDim2.fromScale(0.3, 0.9);
    TextButton4.Size = UDim2.fromScale(0.15, 0.15);
    TextButton4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton4.Text = "";
    TextButton4.TextColor3 = Color3.new();
    TextButton4.TextSize = 14;
    TextButton4.Visible = false;
    TextButton4.ZIndex = 3;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = TextButton4;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "TextLabel";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel7.Size = UDim2.fromScale(1, 1);
    TextLabel7.Text = "+";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.Parent = TextButton4;
    TextButton4.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Price";
    Frame2.AnchorPoint = Vector2.new(1, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(1, 0.5);
    Frame2.Size = UDim2.fromScale(0.3, 1);
    Frame2.Visible = false;
    Frame2.ZIndex = 6;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Amount";
    TextLabel8.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.8, 0.5);
    TextLabel8.Size = UDim2.fromScale(0.75, 0.9);
    TextLabel8.Text = "0";
    TextLabel8.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel8.TextScaled = true;
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel8.ZIndex = 6;
    TextLabel8.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://138240378050344";
    ImageLabel.ImageColor3 = Color3.fromRGB(240, 240, 240);
    ImageLabel.Position = UDim2.fromScale(1, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.ZIndex = 6;
    ImageLabel.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Pay";
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.05, 0.335);
    Frame3.Size = UDim2.fromScale(0.9, 0.425);
    Frame3.Visible = false;
    Frame3.ZIndex = 3;

    for i, v in { { "Own", "rbxassetid://138240378050344", "KREDITS", "Stays tradable" }, { "Locked", "rbxassetid://108829592125034", "TRADELOCKED", "Will be tradelocked" } } do
        local TextButton5 = Instance.new("TextButton");
        TextButton5.Name = v[1];
        TextButton5.AutoButtonColor = false;
        TextButton5.AutoLocalize = false;
        TextButton5.BackgroundColor3 = Color3.new(1, 1, 1);
        TextButton5.BackgroundTransparency = 1;
        TextButton5.ClipsDescendants = true;
        TextButton5.Position = UDim2.fromScale(0, (i - 1) * 0.53);
        TextButton5.Size = UDim2.fromScale(1, 0.47);
        TextButton5.Text = "";
        TextButton5.ZIndex = 3;
        local UICorner5 = Instance.new("UICorner");
        UICorner5.Name = "UICorner";
        UICorner5.CornerRadius = UDim.new(0.12, 0);
        UICorner5.Parent = TextButton5;
        local UIStroke2 = Instance.new("UIStroke");
        UIStroke2.Name = "UIStroke";
        UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke2.Color = Color3.new(1, 1, 1);
        UIStroke2.Transparency = 0.88;
        UIStroke2.Parent = TextButton5;
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "Accent";
        Frame4.BackgroundColor3 = Color3.fromRGB(240, 240, 240);
        Frame4.BackgroundTransparency = 1;
        Frame4.BorderSizePixel = 0;
        Frame4.Position = UDim2.fromScale(0, 0.2);
        Frame4.Size = UDim2.new(0, 3, 0.6, 0);
        Frame4.ZIndex = 4;
        Frame4.Parent = TextButton5;
        local Frame5 = Instance.new("Frame");
        Frame5.Name = "Ring";
        Frame5.AnchorPoint = Vector2.new(0, 0.5);
        Frame5.BackgroundTransparency = 1;
        Frame5.Position = UDim2.fromScale(0.035, 0.5);
        Frame5.Size = UDim2.fromScale(0.3, 0.3);
        Frame5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame5.ZIndex = 4;
        local UICorner6 = Instance.new("UICorner");
        UICorner6.Name = "UICorner";
        UICorner6.CornerRadius = UDim.new(0.5, 0);
        UICorner6.Parent = Frame5;
        local UIStroke3 = Instance.new("UIStroke");
        UIStroke3.Name = "UIStroke";
        UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke3.Color = Color3.new(1, 1, 1);
        UIStroke3.Transparency = 0.35;
        UIStroke3.Parent = Frame5;
        local Frame6 = Instance.new("Frame");
        Frame6.Name = "Dot";
        Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame6.BackgroundColor3 = Color3.fromRGB(240, 240, 240);
        Frame6.BackgroundTransparency = 1;
        Frame6.BorderSizePixel = 0;
        Frame6.Position = UDim2.fromScale(0.5, 0.5);
        Frame6.Size = UDim2.fromScale(0.5, 0.5);
        Frame6.ZIndex = 4;
        local UICorner7 = Instance.new("UICorner");
        UICorner7.Name = "UICorner";
        UICorner7.CornerRadius = UDim.new(0.5, 0);
        UICorner7.Parent = Frame6;
        Frame6.Parent = Frame5;
        Frame5.Parent = TextButton5;
        local ImageLabel2 = Instance.new("ImageLabel");
        ImageLabel2.Name = "Icon";
        ImageLabel2.AnchorPoint = Vector2.new(0, 0.5);
        ImageLabel2.BackgroundTransparency = 1;
        ImageLabel2.Image = v[2];
        ImageLabel2.ImageColor3 = Color3.fromRGB(150, 150, 150);
        ImageLabel2.Position = UDim2.fromScale(0.1, 0.5);
        ImageLabel2.ScaleType = Enum.ScaleType.Fit;
        ImageLabel2.Size = UDim2.fromScale(0.36, 0.36);
        ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        ImageLabel2.ZIndex = 4;
        ImageLabel2.Parent = TextButton5;
        local TextLabel9 = Instance.new("TextLabel");
        TextLabel9.Name = "Title";
        TextLabel9.AnchorPoint = Vector2.new(0, 1);
        TextLabel9.AutoLocalize = false;
        TextLabel9.BackgroundTransparency = 1;
        TextLabel9.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
        TextLabel9.Position = UDim2.fromScale(0.165, 0.52);
        TextLabel9.Size = UDim2.fromScale(0.45, 0.3);
        TextLabel9.Text = v[3];
        TextLabel9.TextColor3 = Color3.fromRGB(150, 150, 150);
        TextLabel9.TextScaled = true;
        TextLabel9.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel9.ZIndex = 4;
        TextLabel9.Parent = TextButton5;
        local TextLabel10 = Instance.new("TextLabel");
        TextLabel10.Name = "Sub";
        TextLabel10.AutoLocalize = false;
        TextLabel10.BackgroundTransparency = 1;
        TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        TextLabel10.Position = UDim2.fromScale(0.165, 0.56);
        TextLabel10.Size = UDim2.fromScale(0.45, 0.22);
        TextLabel10.Text = v[4];
        TextLabel10.TextColor3 = Color3.fromRGB(150, 150, 150);
        TextLabel10.TextScaled = true;
        TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel10.ZIndex = 4;
        TextLabel10.Parent = TextButton5;
        local TextLabel11 = Instance.new("TextLabel");
        TextLabel11.Name = "Balance";
        TextLabel11.AnchorPoint = Vector2.new(1, 1);
        TextLabel11.AutoLocalize = false;
        TextLabel11.BackgroundTransparency = 1;
        TextLabel11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel11.Position = UDim2.fromScale(0.965, 0.52);
        TextLabel11.Size = UDim2.fromScale(0.35, 0.3);
        TextLabel11.Text = "0";
        TextLabel11.TextColor3 = Color3.fromRGB(150, 150, 150);
        TextLabel11.TextScaled = true;
        TextLabel11.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel11.ZIndex = 4;
        TextLabel11.Parent = TextButton5;
        local TextLabel12 = Instance.new("TextLabel");
        TextLabel12.Name = "After";
        TextLabel12.AnchorPoint = Vector2.new(1, 0);
        TextLabel12.AutoLocalize = false;
        TextLabel12.BackgroundTransparency = 1;
        TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        TextLabel12.Position = UDim2.fromScale(0.965, 0.56);
        TextLabel12.Size = UDim2.fromScale(0.35, 0.22);
        TextLabel12.Text = "";
        TextLabel12.TextColor3 = Color3.fromRGB(150, 150, 150);
        TextLabel12.TextScaled = true;
        TextLabel12.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel12.ZIndex = 4;
        TextLabel12.Parent = TextButton5;
        TextButton5.Parent = Frame3;
    end;

    Frame3.Parent = CanvasGroup;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0, 5);
    UICorner5.Parent = CanvasGroup;
    CanvasGroup.Parent = u3.Handler;

    return CanvasGroup;
end;

return u1;