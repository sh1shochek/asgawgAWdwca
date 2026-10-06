-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local u2 = {
    Menu = "Main Menu",
    TeamSelect = "Choose Team"
};
local u3 = nil;
local u4 = nil;
local u5 = table.find(GetUserPlatform(), "Mobile") ~= nil;
local u6 = true;
local u7 = Janitor.new();

local function updateADRDisplay(p8: userdata, p9: number?) -- Line: 61
    -- upvalues: Participants (copy), u3 (ref), Colors (copy)
    local Attribute = p8:GetAttribute("Team");

    if not Attribute then
        return;
    end;

    if p9 == nil and (Participants.IsBot(p8) and p8:GetAttribute("ADR") == nil) then
        u3.ADR.Text = "";

        return;
    end;

    local v10 = Colors["Team Color"][Attribute];
    local v11 = p9 or (p8:GetAttribute("ADR") or 0);
    local v12 = math.floor(v11 * 10) / 10;
    local math_floor_ret = math.floor(v10.R * 255);
    local math_floor_ret2 = math.floor(v10.G * 255);
    local math_floor_ret3 = math.floor(v10.B * 255);
    u3.ADR.Text = `<font color="rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})">ADR:</font> {v12}`;
end;

local function isRoundBasedGamemode() -- Line: 81
    local Attribute = workspace:GetAttribute("Gamemode");
    local v13;

    if Attribute == nil then
        v13 = false;
    else
        v13 = Attribute ~= "Deathmatch";
    end;

    return v13;
end;

local function updateRespawnNextVisibility() -- Line: 86
    -- upvalues: u3 (ref), LocalPlayer (copy), IsPlayingTeam (copy)
    if not u3 then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");
    local RespawnNext = u3.RespawnNext;
    local v14 = IsPlayingTeam(Attribute);

    if v14 then
        local Attribute2 = workspace:GetAttribute("Gamemode");

        if Attribute2 == nil then
            v14 = false;
        else
            v14 = Attribute2 ~= "Deathmatch";
        end;
    end;

    RespawnNext.Visible = v14;
end;

local function updateSpectateTips() -- Line: 94
    -- upvalues: u3 (ref), u6 (ref), u5 (copy), u2 (copy), Tips (copy)
    if not u3 then
        return;
    end;

    local Tips2 = u3:FindFirstChild("Tips");

    if not (Tips2 and Tips2:IsA("GuiObject")) then
        return;
    end;

    local v15 = u6 and not u5;
    Tips2.Visible = v15;
    local RespawnNext = u3.RespawnNext;

    if v15 then
        for i, v in pairs(u2) do
            local v16 = Tips2:FindFirstChild(i);

            if v16 and v16:IsA("GuiObject") then
                local Keybind = v16:FindFirstChild("Keybind");
                local v17;

                if Keybind and Keybind:IsA("GuiButton") then
                    v17 = Tips.ApplyBindingToKeybind(Keybind, Tips.ResolveActionBinding(v));
                else
                    v17 = false;
                end;

                v16.Visible = v17;
            end;
        end;
    end;

    RespawnNext.Position = UDim2.new(RespawnNext.Position.X.Scale, RespawnNext.Position.X.Offset, not v15 and -0.2 or Tips2.Position.Y.Scale - RespawnNext.Size.Y.Scale / 2, 0);
end;

function u1.UpdateFrame(u18: userdata) -- Line: 130
    -- upvalues: SpectateController (copy), u3 (ref), Participants (copy), Colors (copy), GetBadgeIcon (copy), u7 (copy), Observers (copy), updateADRDisplay (copy), GetSkinDisplayName (copy)
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();
    u3.Player.Player.Avatar.Image = Participants.HeadshotImage(u18);
    u3.Username.Text = Participants.Name(u18);
    local Attribute = u18:GetAttribute("Team");

    if Attribute then
        local v19 = Colors["Team Color"][Attribute];
        u3.Username.TextColor3 = v19;
        u3.Badge.Image = GetBadgeIcon(u18, Attribute);
        u3.Frame1.BackgroundColor3 = v19;
        u3.Frame2.BackgroundColor3 = v19;
        u3.Player.Outline.ImageColor3 = v19;
    end;

    u7:Cleanup();
    u7:Add(Observers.observeAttribute(u18, "ADR", function(p20) -- Line: 148
        -- upvalues: updateADRDisplay (ref), u18 (copy)
        if typeof(p20) == "number" then
            updateADRDisplay(u18, p20);
        end;
    end));
    updateADRDisplay(u18);

    if not CurrentSpectateInstance then
        return;
    end;

    if CurrentSpectateInstance.CurrentEquipped then
        local CurrentEquipped = CurrentSpectateInstance.CurrentEquipped;
        u3.Skin.Text = GetSkinDisplayName(CurrentEquipped.Skin);
        GetSkinDisplayName.ApplyNameLabel(u3.Weapon, GetSkinDisplayName.GetWeaponDisplayName(CurrentEquipped.Name, CurrentEquipped.NameTag), CurrentEquipped.NameTag);
    end;

    u7:Add(CurrentSpectateInstance.CurrentEquippedChanged:Connect(function(p21) -- Line: 170
        -- upvalues: u3 (ref), GetSkinDisplayName (ref)
        if p21 then
            u3.Skin.Text = GetSkinDisplayName(p21.Skin or "");
            GetSkinDisplayName.ApplyNameLabel(u3.Weapon, GetSkinDisplayName.GetWeaponDisplayName(p21.Name, p21.NameTag), p21.NameTag);
        end;
    end));
end;

function u1.OpenFrame() -- Line: 182
    -- upvalues: u4 (ref), u3 (ref), LocalPlayer (copy), IsPlayingTeam (copy), updateSpectateTips (copy)
    u4.Gameplay.Bottom.Middle.Team.Visible = false;
    u3.Visible = true;

    if u3 then
        local Attribute = LocalPlayer:GetAttribute("Team");
        local RespawnNext = u3.RespawnNext;
        local v22 = IsPlayingTeam(Attribute);

        if v22 then
            local Attribute2 = workspace:GetAttribute("Gamemode");

            if Attribute2 == nil then
                v22 = false;
            else
                v22 = Attribute2 ~= "Deathmatch";
            end;
        end;

        RespawnNext.Visible = v22;
    end;

    updateSpectateTips();
end;

function u1.CloseFrame() -- Line: 189
    -- upvalues: u3 (ref), u7 (copy), LocalPlayer (copy), Workspace (copy), ReplicatedStorage (copy)
    u3.Visible = false;
    u7:Cleanup();
    local Character = LocalPlayer.Character;
    local Attribute = LocalPlayer:GetAttribute("Team");

    if Character and (Character:IsDescendantOf(Workspace) and (Attribute and Attribute ~= "Spectators")) then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Middle.Team).OpenFrame();
    end;
end;

function u1.Initialize(p23, p24) -- Line: 204
    -- upvalues: u4 (ref), u3 (ref)
    u4 = p23;
    u3 = p24;
end;

function u1.Start() -- Line: 208
    -- upvalues: SpectateController (copy), u1 (copy), LocalPlayer (copy), updateRespawnNextVisibility (copy), DataController (copy), u6 (ref), updateSpectateTips (copy), UserInputService (copy)
    SpectateController.ListenToSpectate:Connect(function(p25) -- Line: 209
        -- upvalues: u1 (ref)
        if not p25 then
            u1.CloseFrame();

            return;
        end;

        u1.UpdateFrame(p25);
        u1.OpenFrame();
    end);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(updateRespawnNextVisibility);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateRespawnNextVisibility);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages", function(p26: boolean?) -- Line: 222
        -- upvalues: u6 (ref), updateSpectateTips (ref)
        u6 = p26 ~= false;
        updateSpectateTips();
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", updateSpectateTips);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(updateSpectateTips);
end;

return u1;