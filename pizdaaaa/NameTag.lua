-- ReplicatedStorage.GameClient.Gui.Misc.NameTag
-- Script path: ReplicatedStorage.GameClient.Gui.Misc.NameTag
-- Decompile time: 14.18 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("Debris");
game:GetService("HttpService");
local LocalPlayer = Players.LocalPlayer;
local GameStats = ReplicatedStorage.GameStats;
local workspace_CurrentCamera = workspace.CurrentCamera;
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 23
    -- upvalues: workspace_CurrentCamera (ref)
    workspace_CurrentCamera = workspace.CurrentCamera;
end);
local NameTag = ReplicatedStorage.Assets:WaitForChild("NameTag");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local _ = {
    CT = Color3.fromRGB(172, 195, 220),
    T = Color3.fromRGB(255, 203, 107),
    Spectator = Color3.fromRGB(120, 120, 120)
};
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = {};
local u14 = (1 / 0);
local u15 = true;
local u16 = nil;
local u17 = nil;
local CanvasGroup = NameTag.CanvasGroup;
local UDim2_new_ret = UDim2.new(CanvasGroup.Position.X.Scale, CanvasGroup.Position.X.Offset, 0.3, CanvasGroup.Position.Y.Offset);
local UDim2_new_ret2 = UDim2.new(0.45, CanvasGroup.Size.X.Offset, CanvasGroup.Size.Y.Scale, CanvasGroup.Size.Y.Offset);

local function PlaceStretchedTags() -- Line: 61
    -- upvalues: workspace_CurrentCamera (ref), u5 (ref), u10 (ref), UDim2_new_ret (copy), CanvasGroup (copy), UDim2_new_ret2 (copy)
    local v18 = workspace_CurrentCamera;
    local AppliedCFrame = u5.GetAppliedCFrame();
    local v19 = math.abs(AppliedCFrame.YVector.Magnitude - 1) > 0.0001;
    local v20 = AppliedCFrame.Rotation:Orthonormalize();
    local Y = v18.ViewportSize.Y;
    local v21 = math.rad(v18.FieldOfView) / 2;
    local v22 = Y / (math.tan(v21) * 2);

    for _, v in u10.GetAllCategoryEntities("Character") do
        local NameTag2 = v.NameTag;
        local NameTagHolder = v.NameTagHolder;
        local NameTagFrame = v.NameTagFrame;
        local v23;

        if NameTag2 then
            v23 = NameTag2.Adornee;
        else
            v23 = NameTag2;
        end;

        if NameTagHolder and v23 then
            local v24 = v19 and NameTagHolder and NameTagHolder or NameTag2;

            if NameTagFrame.Parent ~= v24 then
                NameTagFrame.Parent = v24;
                NameTagFrame.Position = v19 and UDim2_new_ret or CanvasGroup.Position;
                NameTagFrame.Size = v19 and UDim2_new_ret2 or CanvasGroup.Size;
            end;

            if v19 then
                local v25 = v23.Position + NameTag2.StudsOffsetWorldSpace + v20 * NameTag2.StudsOffset;
                local v26 = v18:WorldToViewportPoint(v25);
                local Enabled = NameTag2.Enabled;

                if Enabled then
                    if v26.Z > 0 then
                        Enabled = (v25 - AppliedCFrame.Position).Magnitude <= NameTag2.MaxDistance;
                    else
                        Enabled = false;
                    end;
                end;

                NameTagHolder.Visible = Enabled;

                if Enabled then
                    local Size = NameTag2.Size;
                    local v27 = v22 / v26.Z;
                    NameTagHolder.Size = UDim2.fromOffset(Size.X.Offset + Size.X.Scale * v27, Size.Y.Offset + Size.Y.Scale * v27);
                    NameTagHolder.Position = UDim2.fromOffset(v26.X, v26.Y);
                end;
            end;
        end;
    end;
end;

function u1.Create(p28) -- Line: 104
    -- upvalues: u7 (ref), NameTag (copy), Players (copy), u6 (ref), u11 (ref), u4 (ref), u10 (ref), u17 (ref), u1 (copy)
    local Team = p28.Data.Team;

    if u7 ~= "Spectator" and u7 ~= Team then
        return;
    end;

    local v29 = NameTag:Clone();
    local CanvasGroup2 = v29.CanvasGroup;
    local UserId = p28.UserId;
    local u30;

    if UserId then
        u30 = Players:GetPlayerByUserId(UserId);
    else
        u30 = UserId;
    end;

    local Color = u6.GetColor(u30 or p28, Team);

    if u30 then
        local Name = u30.Name;
        local Health = p28.Health;

        local function UpdateWeaponDisplay(p31) -- Line: 123
            -- upvalues: CanvasGroup2 (copy), u11 (ref)
            if not (p31 and p31.Name) then
                CanvasGroup2.Equipment.Weapon.Visible = false;

                return;
            end;

            CanvasGroup2.Equipment.Weapon.Image = `rbxassetid://{u11.Get(p31.Name).GuiInformation.Icon}`;
            CanvasGroup2.Equipment.Weapon.Visible = true;
        end;

        CanvasGroup2.PlayerName.Text = Name;
        CanvasGroup2.PlayerName.TextLabel.Text = Name;
        CanvasGroup2.Health.Text = `{Health}%`;
        CanvasGroup2.Health.TextLabel.Text = `{Health}%`;
        local CharacterCurrentWeapon = p28.CharacterCurrentWeapon;

        if CharacterCurrentWeapon and CharacterCurrentWeapon.Name then
            CanvasGroup2.Equipment.Weapon.Image = `rbxassetid://{u11.Get(CharacterCurrentWeapon.Name).GuiInformation.Icon}`;
            CanvasGroup2.Equipment.Weapon.Visible = true;
        else
            CanvasGroup2.Equipment.Weapon.Visible = false;
        end;

        u4:Add(`{UserId}_Health`, u10.OnHealthUpdate:Connect(function(p32, p33) -- Line: 140
            -- upvalues: UserId (copy), Health (ref), CanvasGroup2 (copy)
            if p32 ~= UserId then
                return;
            end;

            Health = p33;
            CanvasGroup2.Health.Text = `{Health}%`;
            CanvasGroup2.Health.TextLabel.Text = `{Health}%`;
        end));
        u4:Add(`{UserId}_Color`, u30:GetAttributeChangedSignal("Color"):Connect(function() -- Line: 151
            -- upvalues: u6 (ref), u30 (copy), Team (copy), CanvasGroup2 (copy)
            local Color2 = u6.GetColor(u30, Team);
            CanvasGroup2.PlayerName.TextLabel.TextColor3 = Color2;
            CanvasGroup2.Health.TextLabel.TextColor3 = Color2;
            CanvasGroup2.Point.ImageLabel.ImageColor3 = Color2;
        end));

        if p28.CurrentWeaponChanged then
            u4:Add(`{UserId}_CurrentWeapon`, p28.CurrentWeaponChanged:Connect(function(p34) -- Line: 159
                -- upvalues: CanvasGroup2 (copy), u11 (ref)
                if not (p34 and p34.Name) then
                    CanvasGroup2.Equipment.Weapon.Visible = false;

                    return;
                end;

                CanvasGroup2.Equipment.Weapon.Image = `rbxassetid://{u11.Get(p34.Name).GuiInformation.Icon}`;
                CanvasGroup2.Equipment.Weapon.Visible = true;
            end));
        end;
    else
        local v35 = `BOT #{p28.Identifier}`;
        CanvasGroup2.PlayerName.Text = v35;
        CanvasGroup2.PlayerName.TextLabel.Text = v35;
        CanvasGroup2.Equipment.Weapon.Visible = false;
    end;

    CanvasGroup2.PlayerName.TextLabel.TextColor3 = Color;
    CanvasGroup2.Health.TextLabel.TextColor3 = Color;
    CanvasGroup2.Point.ImageLabel.ImageColor3 = Color;
    v29.Adornee = p28.Model:FindFirstChild("Head");
    v29.Parent = p28.Model;
    local Frame = Instance.new("Frame");
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Visible = false;
    Frame.Parent = u17;
    p28.NameTag = v29;
    p28.NameTagFrame = CanvasGroup2;
    p28.NameTagHolder = Frame;
    u1.ApplyNameTagSettings(p28);
end;

function u1.ApplyNameTagSettings(p36) -- Line: 192
    -- upvalues: u15 (ref), u13 (ref), u14 (ref)
    local NameTag2 = p36.NameTag;

    if not NameTag2 then
        return;
    end;

    local NameTagFrame = p36.NameTagFrame;
    NameTag2.Enabled = u15;
    NameTagFrame.Point.Visible = u13.Pips ~= false;
    NameTagFrame.PlayerName.Visible = u13.Names ~= false;
    NameTagFrame.Health.Visible = u13.Health ~= false;
    NameTagFrame.Equipment.Visible = u13.Equipment ~= false;
    NameTag2.MaxDistance = u14;
end;

local function RefreshAllNameTags() -- Line: 208
    -- upvalues: u10 (ref), u1 (copy)
    for _, v in u10.GetAllCategoryEntities("Character") do
        if v.NameTag then
            u1.ApplyNameTagSettings(v);
        end;
    end;
end;

function u1.Update(p37) -- Line: 216
    -- upvalues: u7 (ref), u1 (copy)
    local NameTag2 = p37.NameTag;

    if u7 == "Spectator" or u7 == p37.Data.Team then
        if not NameTag2 then
            u1.Create(p37);
        end;

        return;
    end;

    u1.Destroy(p37);
end;

function u1.Destroy(p38) -- Line: 230
    -- upvalues: u4 (ref)
    local NameTag2 = p38.NameTag;

    if NameTag2 then
        local UserId = p38.UserId;
        NameTag2:Destroy();
        p38.NameTagHolder:Destroy();
        u4:Removes(`{UserId}_Health`, `{UserId}_CurrentWeapon`, (`{UserId}_Color`));
        p38.NameTag = nil;
        p38.NameTagFrame = nil;
        p38.NameTagHolder = nil;
    end;
end;

function u1.Init(p39) -- Line: 246
    -- upvalues: u2 (ref), u8 (ref), u3 (ref), u4 (ref), u9 (ref), u5 (ref), u10 (ref), u11 (ref), u12 (ref), u6 (ref), u16 (ref), u17 (ref), LocalPlayer (copy), u15 (ref), RefreshAllNameTags (copy), u13 (ref), u14 (ref)
    u2 = p39:GetModule("Gui");
    u8 = p39:GetModule("Network");
    u3 = p39:GetModule("SoundManager");
    u4 = p39:GetModule("Maid").new();
    u9 = p39:GetModule("CharacterController");
    u5 = p39:GetModule("CameraController");
    u10 = p39:GetModule("Entities");
    u11 = p39:GetModule("WeaponManager");
    u12 = p39:GetModule("FrustumCuller").Shared();
    u6 = p39:GetModule("PlayerColor");
    u16 = u2.GetComponent("Settings");
    u17 = Instance.new("ScreenGui");
    u17.Name = "NameTags";
    u17.IgnoreGuiInset = true;
    u17.ResetOnSpawn = false;
    u17.Parent = LocalPlayer:WaitForChild("PlayerGui");
    u16:AddConnection("Game", "Graphics & Visuals", "Show NameTag", function(p40) -- Line: 266
        -- upvalues: u15 (ref), RefreshAllNameTags (ref)
        u15 = p40;
        RefreshAllNameTags();
    end);
    u16:AddConnection("Game", "Graphics & Visuals", "Show Nametag", function(p41) -- Line: 271
        -- upvalues: u13 (ref), RefreshAllNameTags (ref)
        u13 = {
            Pips = false,
            Names = false,
            Health = false,
            Equipment = false
        };

        for i, v in p41 or {} do
            if v == true then
                u13[i] = true;
            elseif typeof(v) == "string" then
                u13[v] = true;
            end;
        end;

        RefreshAllNameTags();
    end);
    u16:AddConnection("Game", "Graphics & Visuals", "Nametag Draw Distance", function(p42) -- Line: 285
        -- upvalues: u14 (ref), RefreshAllNameTags (ref)
        u14 = p42 > 0 and p42 and p42 or (1 / 0);
        RefreshAllNameTags();
    end);
end;

function u1.Start(p43) -- Line: 292
    -- upvalues: RunService (copy), PlaceStretchedTags (copy), u7 (ref), LocalPlayer (copy), u10 (ref), u1 (copy), GameStats (copy), Players (copy), u6 (ref)
    RunService:BindToRenderStep("NameTagStretch", Enum.RenderPriority.Last.Value, PlaceStretchedTags);
    u7 = LocalPlayer:GetAttribute("Team");
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 297
        -- upvalues: u7 (ref), LocalPlayer (ref), u10 (ref), u1 (ref)
        u7 = LocalPlayer:GetAttribute("Team");

        for _, v in u10.GetAllCategoryEntities("Character") do
            u1.Update(v);
        end;
    end);
    GameStats:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 305
        -- upvalues: u10 (ref), Players (ref), u6 (ref)
        for _, v in u10.GetAllCategoryEntities("Character") do
            if v.NameTag then
                local NameTagFrame = v.NameTagFrame;
                local UserId = v.UserId;

                if UserId then
                    UserId = Players:GetPlayerByUserId(UserId);
                end;

                local Color = u6.GetColor(UserId or v, v.Data.Team);
                NameTagFrame.PlayerName.TextLabel.TextColor3 = Color;
                NameTagFrame.Health.TextLabel.TextColor3 = Color;
                NameTagFrame.Point.ImageLabel.ImageColor3 = Color;
            end;
        end;
    end);
end;

return u1;