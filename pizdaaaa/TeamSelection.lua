-- ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.TeamSelection
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.TeamSelection
-- Decompile time: 28.30 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local LocalPlayer = Players.LocalPlayer;
local GameStats = game:GetService("ReplicatedStorage").GameStats;
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
local u17 = {};

local function RefreshConfig() -- Line: 32
    -- upvalues: u17 (copy), u12 (ref)
    u17.TeamLimitEnabled = u12.Get("Team", "TeamLimitEnabled");
end;

local _ = game:GetService("ReplicatedStorage").Assets.Idle;
local _ = {
    CT = Color3.fromRGB(172, 195, 220),
    T = Color3.fromRGB(255, 203, 107)
};
local u18 = {
    CT = {},
    T = {}
};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = {};
local u23 = {};
local TweenInfo_new_ret = TweenInfo.new(1, Enum.EasingStyle.Quart);
local TweenInfo_new_ret2 = TweenInfo.new(0.5, Enum.EasingStyle.Quart);

local function GetEquippedWeapon(p24: string) -- Line: 59
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute("WeaponLoadout");

    if Attribute then
        Attribute = HttpService:JSONDecode(Attribute);
    end;

    if Attribute then
        Attribute = Attribute[p24];
    end;

    if p24 ~= "T" then
        local v25 = false;
        local v26 = "Stock";
        local v27 = false;
        local v28 = "Stock";

        if Attribute then
            for _, v in Attribute do
                if v.WeaponName == "M4A1-S" then
                    v26 = v.SkinName;
                    v25 = true;
                elseif v.WeaponName == "M4A4" then
                    v28 = v.SkinName;
                    v27 = true;
                end;
            end;
        end;

        if v25 and not v27 then
            return "M4A1-S", v26;
        end;

        if v27 then
            return "M4A4", v28;
        end;

        if v25 then
            return "M4A1-S", v26;
        end;

        return "M4A4", "Stock";
    end;

    local v29 = "Stock";

    if Attribute then
        for _, v in Attribute do
            if v.WeaponName == "AK-47" then
                v29 = v.SkinName;
                break;
            end;
        end;
    end;

    return "AK-47", v29;
end;

local function GetEquippedGloves(p30: string) -- Line: 105
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute("WeaponLoadout");

    if Attribute then
        Attribute = HttpService:JSONDecode(Attribute);
    end;

    local v31 = Attribute and Attribute[p30] and Attribute[p30]["16"];

    return v31 and v31.WeaponName or `{p30} Gloves`, v31 and v31.SkinName or "Stock";
end;

local function GetEquippedAgent(p32: string) -- Line: 112
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute("WeaponLoadout");

    if Attribute then
        Attribute = HttpService:JSONDecode(Attribute);
    end;

    local v33 = Attribute and Attribute[p32] and Attribute[p32]["15"];

    return v33 and v33.SkinName or `{p32} Agent`;
end;

local function UpdateTeamAgent(p34: string) -- Line: 119
    -- upvalues: u19 (copy), LocalPlayer (copy), HttpService (copy), u21 (copy), u13 (ref)
    local v35 = u19[p34];

    if not v35 then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("WeaponLoadout");

    if Attribute then
        Attribute = HttpService:JSONDecode(Attribute);
    end;

    local v36 = Attribute and Attribute[p34] and Attribute[p34]["15"];
    local v37 = v36 and v36.SkinName or `{p34} Agent`;
    local v38 = u21[p34];

    if v38 and v38.AgentName == v37 then
        return;
    end;

    if v38 then
        u13.RemoveAgent(v35, v38.Added);
    end;

    u21[p34] = {
        AgentName = v37,
        Added = u13.ApplyAgent(v35, v37)
    };
end;

local function UpdateTeamGloves(p39: string) -- Line: 141
    -- upvalues: u19 (copy), LocalPlayer (copy), HttpService (copy), u20 (copy), u13 (ref)
    local v40 = u19[p39];

    if not v40 then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("WeaponLoadout");

    if Attribute then
        Attribute = HttpService:JSONDecode(Attribute);
    end;

    local v41 = Attribute and Attribute[p39] and Attribute[p39]["16"];
    local v42 = v41 and v41.WeaponName or `{p39} Gloves`;
    local v43 = v41 and v41.SkinName or "Stock";
    local v44 = u20[p39];

    if v44 and (v44.WeaponName == v42 and v44.SkinName == v43) then
        return;
    end;

    for _, v in v44 and v44.Accessories or {} do
        v:Destroy();
    end;

    u20[p39] = {
        WeaponName = v42,
        SkinName = v43,
        Accessories = u13.ApplyGloves(v40, v42, v43)
    };
end;

local function UpdateTeamWeapon(p45: string) -- Line: 164
    -- upvalues: u19 (copy), GetEquippedWeapon (copy), u22 (copy), u13 (ref), UpdateTeamAgent (copy), UpdateTeamGloves (copy)
    local v46 = u19[p45];

    if not v46 then
        return;
    end;

    local v47, v48 = GetEquippedWeapon(p45);
    local v49 = `{v47}_{v48}`;

    if u22[p45] ~= v49 then
        u22[p45] = v49;
        u13.AddWeapon(v46, v47, v48);
    end;

    UpdateTeamAgent(p45);
    UpdateTeamGloves(p45);
end;

function u1.AddUser(p50, u51) -- Line: 183
    -- upvalues: u5 (ref), u1 (copy), Players (copy), u18 (copy)
    local v52 = u5[p50];
    local u53 = u1[`userTemplate{p50}`](v52.Frame);
    u53.Icon.Image = `rbxthumb://type=AvatarHeadShot&id={u51}&w=420&h=420`;
    pcall(function() -- Line: 191
        -- upvalues: u53 (copy), Players (ref), u51 (copy)
        u53.TextLabel.Text = Players:GetNameFromUserIdAsync(u51);
    end);
    v52.ImageButton.Alive.Text = `{#v52.Frame:GetChildren() - 2} Players`;
    u18[p50][u51] = u53;

    return u53;
end;

function u1.RemoveUser(p54) -- Line: 206
    -- upvalues: u18 (copy), u5 (ref)
    for i, v in u18 do
        if v[p54] then
            v[p54]:Destroy();
            v[p54] = nil;
            local v55 = u5[i];
            v55.ImageButton.Alive.Text = `{#v55.Frame:GetChildren() - 2} Players`;
        end;
    end;
end;

function u1.DrawTeamCircle(u56) -- Line: 224
    -- upvalues: u5 (ref), u4 (ref), LocalPlayer (copy), GameStats (copy), u3 (ref), u18 (copy), u17 (copy), u10 (ref), u8 (ref), u9 (ref), u11 (ref), UpdateTeamWeapon (copy), TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), GetEquippedWeapon (copy), u13 (ref), u22 (copy), u19 (copy), u21 (copy), u20 (copy), UpdateTeamAgent (copy), UpdateTeamGloves (copy), u23 (copy), u2 (ref)
    local ImageButton = u5[u56].ImageButton;
    local ImageLabel = ImageButton.ImageLabel;
    ImageLabel.ImageTransparency = 0.3;
    u4:Add(`{u56}Circle_MouseLeave`, ImageButton.MouseButton1Click:Connect(function() -- Line: 229
        -- upvalues: LocalPlayer (ref), u56 (copy), GameStats (ref), u3 (ref), u18 (ref), u17 (ref), u10 (ref), u8 (ref), u9 (ref), u11 (ref)
        if LocalPlayer:GetAttribute("Team") == u56 and GameStats:GetAttribute("State") ~= "MatchEnded" then
            u3.Visible();

            return;
        end;

        local v57 = 0;
        local v58 = 0;

        for i, v in u18 do
            local v59 = i;

            for _ in v do
                if v59 == "CT" then
                    v58 = v58 + 1;
                elseif v59 == "T" then
                    v57 = v57 + 1;
                end;
            end;
        end;

        local Attribute = LocalPlayer:GetAttribute("Team");
        local v60 = u56 == "CT" and v57 and v57 or v58;

        if Attribute ~= "Spectator" then
            v60 = v60 - 1;
        end;

        if u17.TeamLimitEnabled and (Attribute ~= u56 and (u56 ~= "Spectator" and (u56 == "CT" and v58 and v58 or v57) + 1 - v60 > 1)) then
            u10:Create("Teams are unbalanced! Please choose the other team", Color3.fromRGB(255, 151, 153));

            return;
        end;

        u8.Gui.SelectTeam.Fire(u9.TeamsNum[u56]);
        u3.Visible();
        task.delay(1, function() -- Line: 269
            -- upvalues: u11 (ref)
            u11.State();
        end);
    end));

    local function Enter() -- Line: 274
        -- upvalues: UpdateTeamWeapon (ref), u56 (copy), TweenService (ref), ImageLabel (copy), TweenInfo_new_ret (ref), ImageButton (copy), TweenInfo_new_ret2 (ref)
        UpdateTeamWeapon(u56);
        TweenService:Create(ImageLabel, TweenInfo_new_ret, {
            ImageTransparency = 0.1
        }):Play();
        TweenService:Create(ImageButton.Alive, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
    end;

    local function Leave() -- Line: 280
        -- upvalues: TweenService (ref), ImageLabel (copy), TweenInfo_new_ret (ref), ImageButton (copy), TweenInfo_new_ret2 (ref)
        TweenService:Create(ImageLabel, TweenInfo_new_ret, {
            ImageTransparency = 0.4
        }):Play();
        TweenService:Create(ImageButton.Alive, TweenInfo_new_ret2, {
            TextTransparency = 0.25
        }):Play();
    end;

    u4:Add(`{u56}Circle_MouseEnter`, ImageButton.MouseEnter:Connect(Enter));
    u4:Add(`{u56}Circle_Click`, ImageButton.MouseLeave:Connect(Leave));
    u4:Add(`{u56}Circle_SelectionGained`, ImageButton.SelectionGained:Connect(Enter));
    u4:Add(`{u56}Circle_SelectionLost`, ImageButton.SelectionLost:Connect(Leave));
    local WorldModel = Instance.new("WorldModel");
    WorldModel.Parent = ImageButton.ViewportFrame;
    local v61, v62 = GetEquippedWeapon(u56);
    local v63 = u13.new({
        Name = `{u56}_TeamSelection`,
        Parent = WorldModel
    });
    u13.AddWeapon(v63, v61, v62);
    u22[u56] = `{v61}_{v62}`;
    u19[u56] = v63;
    u21[u56] = nil;
    u20[u56] = nil;
    UpdateTeamAgent(u56);
    UpdateTeamGloves(u56);
    local v64 = u13.AnimationIds.Rifle and u13.AnimationIds.Rifle.Loadout or "rbxassetid://95152424446185";
    local Animation = Instance.new("Animation");
    Animation.AnimationId = v64;
    v63.Parent = WorldModel;
    local v65 = v63.Humanoid.Animator:LoadAnimation(Animation);
    v65.Looped = true;
    u23[u56] = v65;

    if u5.Visible and u2.Handler.MainMenu.Visible then
        v65:Play();
    end;

    v63:PivotTo(CFrame.new(0, 0.06, -4.35) * CFrame.new(0, 0, -1.2) * CFrame.Angles(0, math.rad(180 + (u56 == "T" and 30 or 0)), 0));
end;

function u1.DrawSpectatorFrame() -- Line: 326
    -- upvalues: u4 (ref), u7 (ref), u3 (ref), LocalPlayer (copy), u8 (ref), TweenService (copy), TweenInfo_new_ret2 (copy)
    u4:Add("Spectate_MouseLeave", u7.MouseButton1Click:Connect(function() -- Line: 327
        -- upvalues: u3 (ref), LocalPlayer (ref), u8 (ref)
        u3.Visible();

        if LocalPlayer:GetAttribute("Team") == "Spectator" then
            return;
        end;

        u8.Gui.SelectTeam.Fire(3);
    end));
    u4:Add("Spectate_MouseEnter", u7.MouseEnter:Connect(function() -- Line: 337
        -- upvalues: TweenService (ref), u7 (ref), TweenInfo_new_ret2 (ref)
        TweenService:Create(u7, TweenInfo_new_ret2, {
            Transparency = 0.2
        }):Play();
    end));
    u4:Add("Spectate_Click", u7.MouseLeave:Connect(function() -- Line: 341
        -- upvalues: TweenService (ref), u7 (ref), TweenInfo_new_ret2 (ref)
        TweenService:Create(u7, TweenInfo_new_ret2, {
            Transparency = 0.5
        }):Play();
    end));
end;

function u1.Draw() -- Line: 348
    -- upvalues: u1 (copy), GameStats (copy), u14 (ref), Players (copy), u4 (ref), LocalPlayer (copy), UpdateTeamWeapon (copy)
    u1.DrawTeamCircle("T");
    u1.DrawTeamCircle("CT");
    u1.DrawSpectatorFrame();
    GameStats:GetAttributeChangedSignal("Time"):Connect(function() -- Line: 353
        -- upvalues: GameStats (ref), u14 (ref)
        local Attribute = GameStats:GetAttribute("Time");
        u14.Text = string.format("%02d:%02d", math.floor(Attribute / 60), Attribute % 60);
    end);

    for _, v in Players:GetPlayers() do
        local UserId = v.UserId;
        local Attribute = v:GetAttribute("Team");
        u4:Add(`{UserId}_TeamChangedSignal`, v:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 363
            -- upvalues: Attribute (ref), v (copy), u1 (ref), UserId (copy)
            Attribute = v:GetAttribute("Team");
            u1.RemoveUser(UserId);

            if Attribute == "Spectator" then
                return;
            end;

            u1.AddUser(Attribute, UserId);
        end));

        if Attribute ~= "Spectator" then
            u1.AddUser(Attribute, v.UserId);
        end;
    end;

    Players.PlayerAdded:Connect(function(u66) -- Line: 382
        -- upvalues: u4 (ref), u1 (ref)
        local UserId = u66.UserId;
        u4:Add(`{UserId}_TeamChangedSignal`, u66:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 385
            -- upvalues: u66 (copy), u1 (ref), UserId (copy)
            local Attribute = u66:GetAttribute("Team");
            u1.RemoveUser(UserId);

            if Attribute == "Spectator" then
                return;
            end;

            u1.AddUser(Attribute, UserId);
        end));
    end);
    Players.PlayerRemoving:Connect(function(p67) -- Line: 399
        -- upvalues: u1 (ref), u4 (ref)
        local UserId = p67.UserId;
        u1.RemoveUser(UserId);
        u4:Remove((`{UserId}_TeamChangedSignal`));
    end);
    u4:Add("WeaponLoadoutChanged", LocalPlayer:GetAttributeChangedSignal("WeaponLoadout"):Connect(function() -- Line: 406
        -- upvalues: UpdateTeamWeapon (ref)
        UpdateTeamWeapon("T");
        UpdateTeamWeapon("CT");
    end));
end;

function u1.Activate() -- Line: 414
    -- upvalues: UpdateTeamWeapon (copy), u3 (ref), u6 (ref)
    UpdateTeamWeapon("T");
    UpdateTeamWeapon("CT");
    u3.Visible(true);
    u6.Activate();
end;

function u1.Init(p68) -- Line: 423
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u8 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), u15 (ref), u16 (ref), u17 (copy), RefreshConfig (copy)
    u2 = p68:GetModule("Gui");
    u3 = u2.GetComponent("MainMenu");
    u4 = p68:GetModule("Maid").new();
    u8 = p68:GetModule("Network");
    u9 = p68:GetModule("Enums");
    u11 = p68:GetModule("Notification");
    u12 = p68:GetModule("GameConfiguration");
    u13 = p68:GetModule("CharacterModel");
    u15 = p68:GetModule("GetUserPlatform");
    u16 = u15() == "Mobile";
    u17.TeamLimitEnabled = u12.Get("Team", "TeamLimitEnabled");
    u12.Updated:Connect(RefreshConfig);
end;

function u1.Start(p69) -- Line: 440
    -- upvalues: u10 (ref), u2 (ref), u5 (ref), u3 (ref), u6 (ref), u1 (copy), u23 (copy)
    u10 = u2.GetComponent("MenuNotification");
    task.delay(0.1, function() -- Line: 443
        -- upvalues: u5 (ref), u3 (ref), u6 (ref), u1 (ref), u2 (ref), u23 (ref)
        u5 = u3.AddTab("Play");
        u6 = u3.AddButton("Play", u5, UDim2.fromScale(0.0716894, 0.04), UDim2.fromScale(0.5, 0.009));
        u1.new();
        u1.Draw();

        local function PlayCharacters() -- Line: 451
            -- upvalues: u5 (ref), u2 (ref), u23 (ref)
            local v70 = u5.Visible and u2.Handler.MainMenu.Visible;

            for _, v in u23 do
                if v70 and not v.IsPlaying then
                    v:Play(0);
                elseif not v70 and v.IsPlaying then
                    v:Stop(0);
                end;
            end;
        end;

        u5:GetPropertyChangedSignal("Visible"):Connect(PlayCharacters);
        u2.Handler.MainMenu:GetPropertyChangedSignal("Visible"):Connect(PlayCharacters);
    end);
end;

function u1.new() -- Line: 470
    -- upvalues: u14 (ref), u5 (ref), u7 (ref), u16 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Time";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.015);
    Frame.Size = UDim2.fromScale(0.07, 0.035);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://134093119923555";
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    u14 = Instance.new("TextLabel");
    u14.Name = "TextLabel";
    u14.AnchorPoint = Vector2.new(1, 0);
    u14.BackgroundTransparency = 1;
    u14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u14.Position = UDim2.fromScale(1, 0);
    u14.Size = UDim2.fromScale(0.717, 1);
    u14.Text = "10:00";
    u14.TextColor3 = Color3.new(1, 1, 1);
    u14.TextScaled = true;
    u14.Parent = Frame;
    Frame.Parent = u5;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "T";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(0.5, 1);
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ImageButton";
    ImageButton.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Position = UDim2.fromScale(0.95, 0.5);
    ImageButton.Size = UDim2.fromScale(0.5, 0.7);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, -2.01836e-8);
    TextLabel.Size = UDim2.fromScale(1, 0.065);
    TextLabel.Text = "TERRORISTS";
    TextLabel.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.2;
    TextLabel.Parent = ImageButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Alive";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.065);
    TextLabel2.Size = UDim2.fromScale(1, 0.035);
    TextLabel2.Text = "0 Players";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.25;
    TextLabel2.Parent = ImageButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.45);
    ImageLabel2.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel2.Image = "rbxassetid://118442564192259";
    ImageLabel2.ImageTransparency = 0.4;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = ImageLabel2;
    ImageLabel2.Parent = ImageButton;
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "ViewportFrame";
    ViewportFrame.Ambient = Color3.new();
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 1);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.LightColor = Color3.new(1, 1, 1);
    ViewportFrame.LightDirection = Vector3.new(0, 0, -1);
    ViewportFrame.Position = UDim2.fromScale(0.5, 1);
    ViewportFrame.Size = UDim2.fromScale(1, 1);
    ViewportFrame.ZIndex = 4;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 0.8;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = ViewportFrame;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.596886, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(134, 134, 134)) });
    UIGradient.Rotation = 90;
    UIGradient.Parent = ViewportFrame;
    ViewportFrame.Parent = ImageButton;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Blur";
    ImageButton2:SetAttribute("NoSelect", true);
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0.5, 1);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.AutoLocalize = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://6430908053";
    ImageButton2.ImageColor3 = Color3.fromRGB(29, 29, 29);
    ImageButton2.ImageTransparency = 0.28;
    ImageButton2.Position = UDim2.fromScale(0.5, 1.02);
    ImageButton2.ScaleType = Enum.ScaleType.Tile;
    ImageButton2.Size = UDim2.fromScale(0.7, 0.170793);
    ImageButton2.ZIndex = -1;
    ImageButton2.Parent = ImageButton;
    ImageButton.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0, 0.5);
    Frame3.Size = UDim2.fromScale(0.39014, 0.443981);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame3;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = u5;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 0.5);
    Frame4.Size = UDim2.new(0, 2, 0.5, 0);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 1) });
    UIGradient2.Parent = Frame4;
    Frame4.Parent = u5;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "CT";
    Frame5.AnchorPoint = Vector2.new(1, 0);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(1, 0);
    Frame5.Size = UDim2.fromScale(0.5, 1);
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "ImageButton";
    ImageButton3.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Position = UDim2.fromScale(0.05, 0.5);
    ImageButton3.Size = UDim2.fromScale(0.5, 0.7);
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, -2.01836e-8);
    TextLabel3.Size = UDim2.fromScale(1, 0.065);
    TextLabel3.Text = "COUNTER-TERRORISTS";
    TextLabel3.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.2;
    TextLabel3.Parent = ImageButton3;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Alive";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.065);
    TextLabel4.Size = UDim2.fromScale(1, 0.035);
    TextLabel4.Text = "0 Players";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.25;
    TextLabel4.Parent = ImageButton3;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "ImageLabel";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.45);
    ImageLabel3.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel3.Image = "rbxassetid://134307766291506";
    ImageLabel3.ImageTransparency = 0.4;
    local UIScale2 = Instance.new("UIScale");
    UIScale2.Name = "UIScale";
    UIScale2.Parent = ImageLabel3;
    ImageLabel3.Parent = ImageButton3;
    local ViewportFrame2 = Instance.new("ViewportFrame");
    ViewportFrame2.Name = "ViewportFrame";
    ViewportFrame2.Ambient = Color3.new();
    ViewportFrame2.AnchorPoint = Vector2.new(0.5, 1);
    ViewportFrame2.BackgroundTransparency = 1;
    ViewportFrame2.LightColor = Color3.new(1, 1, 1);
    ViewportFrame2.LightDirection = Vector3.new(0, 0, -1);
    ViewportFrame2.Position = UDim2.fromScale(0.5, 1);
    ViewportFrame2.Size = UDim2.fromScale(1, 1);
    ViewportFrame2.ZIndex = 4;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint3.AspectRatio = 0.8;
    UIAspectRatioConstraint3.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint3.Parent = ViewportFrame2;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.596886, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.806228, Color3.fromRGB(192, 192, 192)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(134, 134, 134))
    });
    UIGradient3.Rotation = 90;
    UIGradient3.Parent = ViewportFrame2;
    ViewportFrame2.Parent = ImageButton3;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "Blur";
    ImageButton4:SetAttribute("NoSelect", true);
    ImageButton4.Active = false;
    ImageButton4.AnchorPoint = Vector2.new(0.5, 1);
    ImageButton4.AutoButtonColor = false;
    ImageButton4.AutoLocalize = false;
    ImageButton4.BackgroundTransparency = 1;
    ImageButton4.Image = "rbxassetid://6430908053";
    ImageButton4.ImageColor3 = Color3.fromRGB(29, 29, 29);
    ImageButton4.ImageTransparency = 0.28;
    ImageButton4.Position = UDim2.fromScale(0.5, 1.02);
    ImageButton4.ScaleType = Enum.ScaleType.Tile;
    ImageButton4.Size = UDim2.fromScale(0.7, 0.170793);
    ImageButton4.ZIndex = -1;
    ImageButton4.Parent = ImageButton3;
    ImageButton3.Parent = Frame5;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Frame";
    Frame6.AnchorPoint = Vector2.new(1, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(1, 0.5);
    Frame6.Size = UDim2.fromScale(0.39014, 0.443981);
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = Frame6;
    local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint4.Parent = Frame6;
    Frame6.Parent = Frame5;
    Frame5.Parent = u5;
    u7 = Instance.new("ImageButton");
    u7.Name = "Spectate";
    u7.Active = false;
    u7.AnchorPoint = Vector2.new(0.5, 1);
    u7.AutoButtonColor = false;
    u7.BackgroundColor3 = Color3.new();
    u7.BackgroundTransparency = 0.5;
    u7.BorderColor3 = Color3.new();
    u7.BorderSizePixel = 0;
    u7.Position = UDim2.fromScale(0.5, 1);
    u7.Size = UDim2.fromScale(1, 0.08);
    u7.ZIndex = 10;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Rotation = 90;
    UIGradient4.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.102941, 0.639344), NumberSequenceKeypoint.new(1, 0.978142) });
    UIGradient4.Parent = u7;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(0.5, 1);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = u16 and UDim2.fromScale(0.5, 0.85) or UDim2.fromScale(0.5, 0.8);
    Frame7.Size = u16 and UDim2.fromScale(0.22, 0.6) or UDim2.fromScale(0.1, 0.5);
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "ImageLabel";
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://140396498851452";
    ImageLabel4.ImageTransparency = 0.1;
    ImageLabel4.Size = UDim2.fromScale(1, 1);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = Frame7;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TextLabel";
    TextLabel5.AnchorPoint = Vector2.new(1, 0);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(1, 0);
    TextLabel5.Size = UDim2.fromScale(0.75, 1);
    TextLabel5.Text = "SPECTATE";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextTransparency = 0.1;
    TextLabel5.Parent = Frame7;
    Frame7.Parent = u7;
    u7.Parent = u5;
    local ImageButton5 = Instance.new("ImageButton");
    ImageButton5.Name = "Blur";
    ImageButton5:SetAttribute("NoSelect", true);
    ImageButton5.Active = false;
    ImageButton5.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton5.AutoButtonColor = false;
    ImageButton5.AutoLocalize = false;
    ImageButton5.BackgroundTransparency = 1;
    ImageButton5.Image = "rbxassetid://6430908053";
    ImageButton5.ImageColor3 = Color3.fromRGB(90, 90, 90);
    ImageButton5.Position = UDim2.fromScale(0.5, 0.904751);
    ImageButton5.Size = UDim2.fromScale(1, 0.709866);
    ImageButton5.ZIndex = -1;
    local ImageButton6 = Instance.new("ImageButton");
    ImageButton6.Name = "Blur";
    ImageButton6:SetAttribute("NoSelect", true);
    ImageButton6.Active = false;
    ImageButton6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton6.AutoButtonColor = false;
    ImageButton6.AutoLocalize = false;
    ImageButton6.BackgroundTransparency = 1;
    ImageButton6.Image = "rbxassetid://6430908053";
    ImageButton6.ImageColor3 = Color3.fromRGB(90, 90, 90);
    ImageButton6.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton6.Size = UDim2.fromScale(1.2, 1);
    ImageButton6.ZIndex = -1;
    ImageButton6.Parent = ImageButton5;
    ImageButton5.Parent = u5;
end;

function u1.userTemplateCT(p71) -- Line: 883
    local Frame = Instance.new("Frame");
    Frame.Name = "CT";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 0.2);
    Frame.Visible = true;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.785, 0.499999);
    TextLabel.Size = UDim2.fromScale(0.785288, 0.35);
    TextLabel.Text = "WhyNotMyUsername";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BorderColor3 = Color3.new();
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    ImageLabel.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.75, 0.75);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Shadow";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://101919817272141";
    ImageLabel2.ImageTransparency = 0.399353;
    ImageLabel2.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Slice;
    ImageLabel2.Size = UDim2.new(0.75, 30, 0.75, 30);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel2.ZIndex = -9999;
    ImageLabel2.Parent = Frame;
    Frame.Parent = p71;

    return Frame;
end;

function u1.userTemplateT(p72) -- Line: 938
    local Frame = Instance.new("Frame");
    Frame.Name = "T";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 0.2);
    Frame.Visible = true;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.214712, 0.499999);
    TextLabel.Size = UDim2.fromScale(0.785288, 0.35);
    TextLabel.Text = "WhyNotMyUsername";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BorderColor3 = Color3.new();
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    ImageLabel.Position = UDim2.fromScale(0.1, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.75, 0.75);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Shadow";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://101919817272141";
    ImageLabel2.ImageTransparency = 0.399353;
    ImageLabel2.Position = UDim2.fromScale(0.1, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Slice;
    ImageLabel2.Size = UDim2.new(0.75, 30, 0.75, 30);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel2.ZIndex = -9999;
    ImageLabel2.Parent = Frame;
    Frame.Parent = p72;

    return Frame;
end;

return u1;