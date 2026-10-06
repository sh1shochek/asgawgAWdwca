-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local u1 = {};

local function GetWeaponProperties(p2: string) -- Line: 46
    -- upvalues: ReplicatedStorage (copy)
    local v3 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p2);

    if not (v3 and v3:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v3);

    return success and result and result or nil;
end;

local function UpdateVisibility(p4: table, p5: any) -- Line: 61
    -- upvalues: LocalPlayer (copy), DataController (copy)
    local v6 = p5 or LocalPlayer:GetAttribute("Team");

    if DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" or v6 ~= p4.CurrentTeam then
        p4.Model.Parent = nil;

        return;
    end;

    if p4.Model.Parent == nil and p4.OriginalParent then
        p4.Model.Parent = p4.OriginalParent;
    end;
end;

local function UpdateAllMarkers(p7) -- Line: 71
    -- upvalues: u1 (copy), UpdateVisibility (copy)
    for _, v in pairs(u1) do
        UpdateVisibility(v, p7);
    end;
end;

local function GetSpectatedTeam() -- Line: 77
    -- upvalues: SpectateController (copy), LocalPlayer (copy)
    local Player = SpectateController.GetPlayer();

    if Player and Player ~= LocalPlayer then
        return Player:GetAttribute("Team");
    end;

    return nil;
end;

local function RefreshAllMarkers() -- Line: 85
    -- upvalues: SpectateController (copy), LocalPlayer (copy), u1 (copy), UpdateVisibility (copy)
    local Player = SpectateController.GetPlayer();
    local v8;

    if Player and Player ~= LocalPlayer then
        v8 = Player:GetAttribute("Team");
    else
        v8 = nil;
    end;

    for _, v in pairs(u1) do
        UpdateVisibility(v, v8);
    end;
end;

local function StyleBillboard(p9: table) -- Line: 92
    -- upvalues: Colors (copy), Skins (copy), ReplicatedStorage (copy), Rarities (copy)
    local v10 = Colors["Team Color"][p9.CurrentTeam];
    p9.Model.Name = p9.Identifier;

    if not v10 then
        return;
    end;

    local v11 = p9.Model:FindFirstChildOfClass("BillboardGui");

    if not (v11 and v11:IsDescendantOf(workspace)) then
        return;
    end;

    local IsDanger = p9.IsDanger;
    local v12;

    if typeof(p9.Weapon) == "string" and (p9.Weapon ~= "" and typeof(p9.Skin) == "string") then
        v12 = p9.Skin ~= "";
    else
        v12 = false;
    end;

    v11.Info.Visible = not IsDanger and not v12;
    local v13;

    if IsDanger then
        v13 = not v12;
    else
        v13 = IsDanger;
    end;

    v11.Danger.Visible = v13;
    v11.Weapon.Visible = v12;

    if v11.Info.Visible then
        v11.Info.ImageColor3 = v10;

        return;
    end;

    if not v12 then
        return;
    end;

    local Weapon = p9.Weapon;
    local SkinInformation = Skins.GetSkinInformation(Weapon, p9.Skin);
    local v14 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Weapon);
    local v15;

    if v14 and v14:IsA("ModuleScript") then
        local success, result = pcall(require, v14);
        v15 = success and result and result or nil;
    else
        v15 = nil;
    end;

    local v16;

    if SkinInformation then
        v16 = Rarities[SkinInformation.rarity];
    else
        v16 = SkinInformation;
    end;

    if SkinInformation and (v15 and v16) then
        v11.Weapon.Icon.ImageColor3 = v16.Color;
        v11.Weapon.Icon.Image = v15.Icon;

        return;
    end;

    v11.Weapon.Visible = false;
    v11.Info.Visible = not IsDanger;
    v11.Danger.Visible = IsDanger;

    if v11.Info.Visible then
        v11.Info.ImageColor3 = v10;
    end;
end;

local function CreatePositionPing(p17: userdata, u18: string) -- Line: 136
    -- upvalues: UpdateVisibility (copy), SpectateController (copy), LocalPlayer (copy), StyleBillboard (copy), u1 (copy)
    local v19 = {
        Weapon = p17:GetAttribute("Weapon"),
        Skin = p17:GetAttribute("Skin"),
        Identifier = u18,
        CurrentTeam = p17:GetAttribute("Team"),
        IsDanger = p17:GetAttribute("IsDanger"),
        OriginalParent = p17.Parent,
        Model = p17
    };
    local Player = SpectateController.GetPlayer();
    local v20;

    if Player and Player ~= LocalPlayer then
        v20 = Player:GetAttribute("Team");
    else
        v20 = nil;
    end;

    UpdateVisibility(v19, v20);
    task.delay(0.016666666666666666, StyleBillboard, v19);
    u1[u18] = v19;

    return function() -- Line: 150
        -- upvalues: u1 (ref), u18 (copy)
        u1[u18] = nil;
    end;
end;

LocalPlayer.CharacterAdded:Connect(function() -- Line: 158
    -- upvalues: u1 (copy), UpdateVisibility (copy)
    for _, v in pairs(u1) do
        UpdateVisibility(v, nil);
    end;
end);
LocalPlayer:GetAttributeChangedSignal("Team"):Connect(RefreshAllMarkers);
DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Player Pings", RefreshAllMarkers);
SpectateController.ListenToSpectate:Connect(function(p21: userdata?) -- Line: 163
    -- upvalues: u1 (copy), UpdateVisibility (copy)
    if p21 then
        p21 = p21:GetAttribute("Team");
    end;

    for _, v in pairs(u1) do
        UpdateVisibility(v, p21);
    end;
end);

return Observers.observeTag("PlayerPositionMarker", function(p22: userdata) -- Line: 170
    -- upvalues: CreatePositionPing (copy), HttpService (copy)
    if p22:IsDescendantOf(workspace) then
        return CreatePositionPing(p22, HttpService:GenerateGUID(false));
    end;

    return nil;
end);