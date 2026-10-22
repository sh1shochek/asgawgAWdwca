-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Gift
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Gift
-- Decompile time: 19.23 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    Tab = nil,
    CurrentName = "",
    CurrentSelected = nil,
    CurrentTab = nil,
    CurrentFriends = {},
    CurrentSearch = {}
};
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local MarketplaceService = game:GetService("MarketplaceService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local TweenInfo_new_ret = TweenInfo.new(0.25);
local u6 = nil;

function u1.AddFriend(p7: userdata) -- Line: 33
    -- upvalues: u1 (copy), u4 (ref), Players (copy)
    for _, v in ipairs(u1.CurrentFriends) do
        if v.Name == p7 then
            return;
        end;
    end;

    local v8 = u1.user();
    v8.Visible = false;
    v8.Parent = u4.List;
    v8.DisplayName.Text = p7.DisplayName;
    v8.PlayerName.Text = p7.Username;
    v8.Name = p7.DisplayName .. ":" .. p7.Username;
    v8.PlayerIcon.Image = Players:GetUserThumbnailAsync(p7.Id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
    u1.PlayerSelect(v8.bt);

    if u1.Tab.Name == "Global" then
        v8.Visible = true;
    end;

    table.insert(u1.CurrentFriends, v8);
end;

function u1.AddUser(p9: userdata, p10: number) -- Line: 59
    -- upvalues: u1 (copy), u4 (ref), Players (copy)
    local v11 = u1.user();
    v11.Parent = u4.List;
    v11.DisplayName.Text = p9;
    v11.PlayerName.Text = p9;
    v11.Name = p9;
    v11.PlayerIcon.Image = Players:GetUserThumbnailAsync(p10, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
    u1.PlayerSelect(v11.bt);
    v11.Visible = true;
    table.insert(u1.CurrentFriends, v11);
    table.insert(u1.CurrentSearch, v11);
end;

function u1.ListVisible(p12: boolean) -- Line: 76
    -- upvalues: u1 (copy)
    for _, v in u1.CurrentFriends do
        v.Visible = p12;
    end;
end;

function u1.PlayerSelect(u13: userdata) -- Line: 82
    -- upvalues: u3 (ref), u1 (copy), TweenService (copy), u4 (ref), u6 (ref)
    u3:Add(`PlayerSelect_{u13.Parent.Name}`, u13.MouseButton1Click:Connect(function() -- Line: 83
        -- upvalues: u1 (ref), TweenService (ref), u13 (copy), u4 (ref), u6 (ref)
        if u1.CurrentSelected ~= nil then
            TweenService:Create(u1.CurrentSelected, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.9
            }):Play();
        end;

        TweenService:Create(u13.Parent, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.7
        }):Play();
        u1.CurrentSelected = u13.Parent;
        u4.AreYouSure.Text = `Are you sure you want to gift "{u6}" to {u13.Parent.PlayerName.Text}?`;
    end));
end;

function u1.Create(u14: number, u15: any) -- Line: 95
    -- upvalues: u4 (ref), TweenService (copy), TweenInfo_new_ret (copy), MarketplaceService (copy), u6 (ref), u5 (ref), Players (copy), u1 (copy), u3 (ref)
    u4.Visible = true;
    TweenService:Create(u4, TweenInfo_new_ret, {
        GroupTransparency = 0
    }):Play();
    local success, result = pcall(function() -- Line: 101
        -- upvalues: MarketplaceService (ref), u14 (copy)
        return MarketplaceService:GetProductInfoAsync(u14, Enum.InfoType.GamePass);
    end);

    if not success then
        success, result = pcall(function() -- Line: 106
            -- upvalues: MarketplaceService (ref), u14 (copy)
            return MarketplaceService:GetProductInfoAsync(u14, Enum.InfoType.Product);
        end);
    end;

    u6 = (u5.Gamepasses[u14] or u5.DevProducts[u14]).Name;
    u4.Robux.Title.Text = success and result.PriceInRobux or "???";
    u4.AreYouSure.Text = `Are you sure you want to gift "{u6}" to {Players.LocalPlayer.DisplayName}?`;

    if #u1.CurrentFriends == 0 then
        task.defer(function() -- Line: 121
            -- upvalues: Players (ref), u1 (ref)
            pcall(function() -- Line: 122
                -- upvalues: Players (ref), u1 (ref)
                for _, v in Players:GetFriendsAsync(Players.LocalPlayer.UserId):GetCurrentPage() do
                    u1.AddFriend(v);
                end;
            end);
        end);
    end;

    for _, child in u4.Buttons:GetChildren() do
        if child:IsA("TextButton") then
            u3:Add(`{child.Name}Switch`, child.MouseButton1Click:Connect(function() -- Line: 132
                -- upvalues: u1 (ref), TweenService (ref), child (copy)
                if u1.Tab ~= nil then
                    TweenService:Create(u1.Tab, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play();
                end;

                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.9
                }):Play();
                u1.Tab = child;

                if child.Name == "Server" then
                    u1.ListVisible(false);
                    u1.CurrentTab = "Server";

                    return;
                end;

                u1.CurrentTab = "Global";
                u1.ListVisible(true);
            end));
        end;
    end;

    local u16 = 0;
    u3:Add("Search", u4.Search.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 159
        -- upvalues: u4 (ref), u1 (ref), u16 (ref), Players (ref)
        local v17 = u4.Search.TextBox.Text:lower();

        for _, child in ipairs(u4.List:GetChildren()) do
            if child:IsA("Frame") then
                if v17 == "" or string.find(child.Name:lower(), v17, 1, true) then
                    if u1.CurrentTab == "Global" then
                        child.Visible = true;
                    end;
                else
                    child.Visible = false;
                end;
            end;
        end;

        if u1.CurrentTab == "Global" then
            if #u1.CurrentSearch > 0 then
                for _, v in ipairs(u1.CurrentSearch) do
                    if v ~= u1.CurrentSelected then
                        v:Destroy();
                    end;
                end;

                table.clear(u1.CurrentSearch);
            end;

            if v17 == "" then
                return;
            end;

            u16 = u16 + 1;
            local v18 = u16;

            if tonumber(v17) then
                local success2, result2 = pcall(Players.GetNameFromUserIdAsync, Players, v17);

                if success2 and v18 == u16 then
                    u1.AddUser(result2, v17);
                end;
            else
                local success2, result2 = pcall(Players.GetUserIdFromNameAsync, Players, v17);

                if success2 and v18 == u16 then
                    u1.AddUser(v17, result2);
                end;
            end;
        end;
    end));

    for _, child in u4:GetChildren() do
        if child:IsA("TextButton") then
            u3:Add(`{child.Name}Enter`, child.MouseEnter:Connect(function() -- Line: 210
                -- upvalues: TweenService (ref), child (copy)
                TweenService:Create(child, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.9
                }):Play();
            end));
            u3:Add(`{child.Name}Leave`, child.MouseLeave:Connect(function() -- Line: 214
                -- upvalues: TweenService (ref), child (copy)
                TweenService:Create(child, TweenInfo.new(0.3), {
                    BackgroundTransparency = 1
                }):Play();
            end));
            u3:Add(`{child.Name}Click`, child.MouseButton1Click:Connect(function() -- Line: 219
                -- upvalues: child (copy), u1 (ref), u15 (copy), Players (ref), u4 (ref)
                if child.Name ~= "Close" then
                    if not u1.CurrentSelected then
                        return;
                    end;

                    local Text = u1.CurrentSelected.PlayerName.Text;

                    if not Text then
                        return;
                    end;

                    u15(Players:GetUserIdFromNameAsync(Text));
                end;

                u4.Visible = false;
            end));
        end;
    end;

    u1.Tab = u4.Buttons.Server;
    u1.CurrentName = u4.Buttons.Server.Name;
end;

function u1.Close() -- Line: 245
    -- upvalues: u4 (ref)
    u4.Visible = false;
end;

function u1.Init(p19) -- Line: 249
    -- upvalues: u2 (ref), u3 (ref), u5 (ref)
    u2 = p19:GetModule("Gui");
    u3 = p19:GetModule("Maid").new();
    u5 = p19:GetModule("GamepassesData");
end;

function u1.Start(p20) -- Line: 255
    -- upvalues: u4 (ref), u1 (copy), Players (copy), u3 (ref)
    u4 = u1.new();

    for _, v in Players:GetPlayers() do
        if v ~= Players.LocalPlayer then
            local v21 = u1.user();
            v21.Parent = u4.List;
            v21.DisplayName.Text = v.DisplayName;
            v21.PlayerName.Text = v.Name;
            v21.Name = v.DisplayName .. ":" .. v.Name;
            v21.PlayerIcon.Image = Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
            u1.PlayerSelect(v21.bt);
            v21.Visible = true;
        end;
    end;

    Players.PlayerAdded:Connect(function(p22) -- Line: 278
        -- upvalues: u1 (ref), u4 (ref), Players (ref)
        local v23 = u1.user();
        v23.Parent = u4.List;
        v23.DisplayName.Text = p22.DisplayName;
        v23.PlayerName.Text = p22.Name;
        v23.Name = p22.DisplayName .. ":" .. p22.Name;
        v23.PlayerIcon.Image = Players:GetUserThumbnailAsync(p22.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
        u1.PlayerSelect(v23.bt);
        v23.Visible = false;

        if u1.CurrentName ~= "Global" then
            v23.Visible = true;
        end;
    end);
    Players.PlayerRemoving:Connect(function(p24) -- Line: 296
        -- upvalues: u4 (ref), u3 (ref), u1 (ref)
        local v25 = p24.DisplayName .. ":" .. p24.Name;
        local v26 = u4.List:FindFirstChild(v25);

        if v26 then
            if u3.Remove then
                u3:Remove((`PlayerSelect_{v25}`));
            else
                u3[`PlayerSelect_{v25}`] = nil;
            end;

            if u1.CurrentSelected == v26 then
                u1.CurrentSelected = nil;
                u4.AreYouSure.Text = "Select a player to gift.";
            end;

            v26:Destroy();
        end;
    end);
end;

function u1.new() -- Line: 317
    -- upvalues: u2 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "gui";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.AutoLocalize = false;
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(18, 19, 24);
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(0.3, 0.8);
    CanvasGroup.ZIndex = 10;
    CanvasGroup.Parent = u2.Handler;
    CanvasGroup.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(112, 112, 112);
    UIStroke.Transparency = 1;
    UIStroke.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "Title";
    Frame.AutoLocalize = false;
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 0.08);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.Text = "Gamepass Gift Purchase";
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
    TextLabel2.Position = UDim2.fromScale(0.5, 0.819031);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.0809691);
    TextLabel2.Text = "Are you sure you want to gift Носки кота в сапогах for WhyNotMyUsername?";
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
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.LayoutOrder = 1;
    TextButton.Position = UDim2.fromScale(0.95, 0.985);
    TextButton.Size = UDim2.fromScale(0.125, 0.06);
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
    TextLabel3.Size = UDim2.fromScale(0.9, 0.5);
    TextLabel3.Text = "CLOSE";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.Parent = TextButton;
    TextButton.Parent = CanvasGroup;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Confirm";
    TextButton2.AnchorPoint = Vector2.new(1, 1);
    TextButton2.AutoButtonColor = false;
    TextButton2.AutoLocalize = false;
    TextButton2.BackgroundTransparency = 1;
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton2.LayoutOrder = 1;
    TextButton2.Position = UDim2.fromScale(0.8, 0.985);
    TextButton2.Size = UDim2.fromScale(0.175, 0.06);
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
    TextLabel4.Size = UDim2.fromScale(0.9, 0.5);
    TextLabel4.Text = "CONFIRM";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.Parent = TextButton2;
    TextButton2.Parent = CanvasGroup;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.01, 0);
    UICorner3.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Robux";
    ImageLabel.AnchorPoint = Vector2.new(0, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.05, 0.985);
    ImageLabel.Selectable = true;
    ImageLabel.Size = UDim2.fromScale(0.46, 0.06);
    ImageLabel.ZIndex = 10;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Icon";
    TextLabel5.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.LayoutOrder = 1;
    TextLabel5.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel5.RichText = true;
    TextLabel5.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel5.Text = "";
    TextLabel5.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel5.Parent = ImageLabel;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Title";
    TextLabel6.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel6.LayoutOrder = 4;
    TextLabel6.Position = UDim2.fromScale(0.24, 0.5);
    TextLabel6.Size = UDim2.fromScale(0.75, 0.8);
    TextLabel6.Text = "80";
    TextLabel6.TextColor3 = Color3.fromRGB(231, 231, 231);
    TextLabel6.TextScaled = true;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.ZIndex = 6;
    TextLabel6.Parent = ImageLabel;
    ImageLabel.Parent = CanvasGroup;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "List";
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundColor3 = Color3.new();
    ScrollingFrame.BackgroundTransparency = 0.7;
    ScrollingFrame.BorderColor3 = Color3.new();
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.BottomImage = "";
    ScrollingFrame.Position = UDim2.fromScale(0.5, 0.5);
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.Selectable = false;
    ScrollingFrame.Size = UDim2.fromScale(0.9, 0.6);
    ScrollingFrame.TopImage = "";
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0, 5);
    UICorner4.Parent = ScrollingFrame;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellSize = UDim2.fromScale(1, 0.14);
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = ScrollingFrame;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0, 4);
    UIPadding2.PaddingLeft = UDim.new(0, 8);
    UIPadding2.PaddingRight = UDim.new(0, 8);
    UIPadding2.PaddingTop = UDim.new(0, 4);
    UIPadding2.Parent = ScrollingFrame;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.fromRGB(112, 112, 112);
    UIStroke2.Parent = ScrollingFrame;
    ScrollingFrame.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Search";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BackgroundTransparency = 0.7;
    Frame2.Position = UDim2.fromScale(0.5, 0.1525);
    Frame2.Size = UDim2.fromScale(0.9, 0.04);
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0, 5);
    UICorner5.Parent = Frame2;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.fromRGB(112, 112, 112);
    UIStroke3.Parent = Frame2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://81609851522222";
    ImageLabel2.ImageTransparency = 0.6;
    ImageLabel2.Position = UDim2.fromScale(0.01, 0.5);
    ImageLabel2.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = Frame2;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0.5, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
    TextBox.PlaceholderText = "...";
    TextBox.Position = UDim2.fromScale(0.5, 0.5);
    TextBox.Size = UDim2.fromScale(0.8, 0.8);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.fromRGB(231, 231, 231);
    TextBox.TextScaled = true;
    TextBox.TextTransparency = 0.1;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextBox.Parent = Frame2;
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Buttons";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.7;
    Frame3.Position = UDim2.fromScale(0.5, 0.09);
    Frame3.Size = UDim2.fromScale(0.9, 0.0541386);
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.CornerRadius = UDim.new(0, 5);
    UICorner6.Parent = Frame3;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.fromRGB(112, 112, 112);
    UIStroke4.Parent = Frame3;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Server";
    TextButton3.AnchorPoint = Vector2.new(0, 0.5);
    TextButton3.AutoButtonColor = false;
    TextButton3.AutoLocalize = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.9;
    TextButton3.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton3.LayoutOrder = 1;
    TextButton3.Position = UDim2.fromScale(0, 0.5);
    TextButton3.Size = UDim2.fromScale(0.5, 1);
    TextButton3.Text = "";
    TextButton3.TextColor3 = Color3.new();
    TextButton3.TextSize = 14;
    TextButton3.ZIndex = 3;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.Name = "UICorner";
    UICorner7.CornerRadius = UDim.new(0.1, 0);
    UICorner7.Parent = TextButton3;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "TextLabel";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.569309, 0.5);
    TextLabel7.Size = UDim2.fromScale(0.698476, 0.7);
    TextLabel7.Text = "SERVER";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.Parent = TextButton3;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "PlayerIcon";
    ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://77908467945808";
    ImageLabel3.ImageTransparency = 0.6;
    ImageLabel3.Position = UDim2.fromScale(0.05, 0.5);
    ImageLabel3.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = TextButton3;
    TextButton3.Parent = Frame3;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "Global";
    TextButton4.AnchorPoint = Vector2.new(1, 0.5);
    TextButton4.AutoButtonColor = false;
    TextButton4.AutoLocalize = false;
    TextButton4.BackgroundTransparency = 1;
    TextButton4.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton4.LayoutOrder = 1;
    TextButton4.Position = UDim2.fromScale(1, 0.5);
    TextButton4.Size = UDim2.fromScale(0.5, 1);
    TextButton4.Text = "";
    TextButton4.TextColor3 = Color3.new();
    TextButton4.TextSize = 14;
    TextButton4.ZIndex = 3;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.Name = "UICorner";
    UICorner8.CornerRadius = UDim.new(0.1, 0);
    UICorner8.Parent = TextButton4;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "TextLabel";
    TextLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.569309, 0.5);
    TextLabel8.Size = UDim2.fromScale(0.698476, 0.7);
    TextLabel8.Text = "GLOBAL";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.Parent = TextButton4;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "PlayerIcon";
    ImageLabel4.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://98657745866039";
    ImageLabel4.ImageTransparency = 0.6;
    ImageLabel4.Position = UDim2.fromScale(0.05, 0.5);
    ImageLabel4.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = TextButton4;
    TextButton4.Parent = Frame3;
    Frame3.Parent = CanvasGroup;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 0.63;
    UIAspectRatioConstraint.Parent = CanvasGroup;

    return CanvasGroup;
end;

function u1.user() -- Line: 754
    local Frame = Instance.new("Frame");
    Frame.Name = "PlayerFrame";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.9;
    Frame.Size = UDim2.fromOffset(100, 100);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "PlayerIcon";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.ImageTransparency = 0.1;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "DisplayName";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.2, 0.4);
    TextLabel.Size = UDim2.fromScale(0.6, 0.45);
    TextLabel.Text = "WhyNotMyUsername";
    TextLabel.TextColor3 = Color3.fromRGB(231, 231, 231);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.1;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 6;
    TextLabel.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "PlayerName";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = 4;
    TextLabel2.Position = UDim2.fromScale(0.2, 0.725);
    TextLabel2.Size = UDim2.fromScale(0.6, 0.35);
    TextLabel2.Text = "@WhyNotMyUsername";
    TextLabel2.TextColor3 = Color3.fromRGB(231, 231, 231);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.5;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 6;
    TextLabel2.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "FriendIcon";
    ImageLabel2.AnchorPoint = Vector2.new(1, 1);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://102910578348292";
    ImageLabel2.ImageTransparency = 0.6;
    ImageLabel2.Position = UDim2.fromScale(1, 1);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = Frame;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "bt";
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Size = UDim2.fromScale(1, 1);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.Parent = Frame;

    return Frame;
end;

return u1;