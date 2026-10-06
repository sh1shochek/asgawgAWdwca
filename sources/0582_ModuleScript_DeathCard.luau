-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon);
local GetBadgeName = require(ReplicatedStorage.Components.Common.GetBadgeName);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local workspace_CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 0;

local function GetWeaponIcon(p7: any, p8: number) -- Line: 52
    -- upvalues: Skins (copy)
    return Skins.GetWearImageForFloat(p7, p8) or p7.imageAssetId or "";
end;

local function CancelTransitionTween() -- Line: 56
    -- upvalues: u5 (ref)
    local v9 = u5;
    u5 = nil;

    if v9 then
        v9:Cancel();
    end;
end;

local function PlayTransitionTween(p10: number, p11: number) -- Line: 64
    -- upvalues: u5 (ref), TweenService (copy), u3 (ref)
    local v12 = u5;
    u5 = nil;

    if v12 then
        v12:Cancel();
    end;

    local v13 = TweenService:Create(u3, TweenInfo.new(p10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = p11
    });
    u5 = v13;
    v13:Play();

    return v13;
end;

local function TweenBloodScreen(p14: number, p15: number, p16: number) -- Line: 76
    -- upvalues: TweenService (copy), u2 (ref)
    local TweenInfo_new_ret = TweenInfo.new(p14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    TweenService:Create(u2, TweenInfo_new_ret, {
        BackgroundTransparency = p15
    }):Play();
    TweenService:Create(u2.ImageLabel, TweenInfo_new_ret, {
        ImageTransparency = p16
    }):Play();
end;

local function GetCharacterCameraSubject() -- Line: 82
    -- upvalues: CollectionService (copy), LocalPlayer (copy), CharacterResolver (copy)
    local v17 = (-1 / 0);
    local v18 = nil;

    for _, v in CollectionService:GetTagged("Ragdoll") do
        if v:IsA("Model") and (v.Name == LocalPlayer.Name and v:IsDescendantOf(workspace)) then
            local Attribute = v:GetAttribute("RagdollCreatedAt");
            local v19 = typeof(Attribute) ~= "number" and 0 or Attribute;

            if v17 < v19 then
                v18 = v;
                v17 = v19;
            end;
        end;
    end;

    if v18 then
        return CharacterResolver.getCameraPart(v18) or (CharacterResolver.getRootPart(v18) or v18:FindFirstChildOfClass("Humanoid"));
    end;

    return nil;
end;

function u1.updateFrame(p20) -- Line: 108
    -- upvalues: Participants (copy), u4 (ref), Skins (copy), GetSkinDisplayName (copy), GetBadgeName (copy), GetBadgeIcon (copy)
    local v21 = Participants.FromKey(p20.Killer);

    if not (v21 and v21.Parent) then
        u4.Killed.Text = "";
        u4.BadgeFrame.TextLabel.Text = "";
        u4.BadgeIcon.Image = "";
        u4.Profile.Avatar.Image = "";
        u4.Username.Text = "";
        u4.ViewportFrame.Icon.Image = "";

        return false;
    end;

    local SkinInformation = Skins.GetSkinInformation(p20.Weapon, p20.Skin);
    local v22 = GetSkinDisplayName(p20.Skin);
    u4.Killed.Text = `<font color="rgb(255,34,16)">Killed you with their</font> <b>{p20.Weapon} | {v22}</b>`;
    u4.BadgeFrame.TextLabel.Text = GetBadgeName(v21, (v21:GetAttribute("Team")));
    u4.BadgeIcon.Image = GetBadgeIcon(v21, (v21:GetAttribute("Team")));
    u4.Profile.Avatar.Image = Participants.HeadshotImage(v21);
    u4.Username.Text = Participants.DisplayName(v21);
    u4.ViewportFrame.Icon.Image = SkinInformation and (Skins.GetWearImageForFloat(SkinInformation, p20.Float or 0.9999) or (SkinInformation.imageAssetId or "")) or "";

    return true;
end;

function u1.openFrame(p23: boolean?) -- Line: 139
    -- upvalues: u6 (ref), GetCharacterCameraSubject (copy), workspace_CurrentCamera (copy), CameraController (copy), u2 (ref), u4 (ref), u5 (ref), u3 (ref), TweenBloodScreen (copy), TweenService (copy), PlayTransitionTween (copy), u1 (copy)
    u6 = u6 + 1;
    local u24 = u6;

    local function isSequenceStale() -- Line: 142
        -- upvalues: u6 (ref), u24 (copy)
        return u6 ~= u24;
    end;

    local v25 = GetCharacterCameraSubject();

    if v25 then
        workspace_CurrentCamera.CameraSubject = v25;
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Follow;
    CameraController.setPerspective(false, false);
    task.wait(0.15);

    if u6 ~= u24 then
        return;
    end;

    u2.ImageLabel.ImageTransparency = 1;
    u2.BackgroundTransparency = 1;
    u2.Visible = true;
    u4.Position = UDim2.fromScale(0.5, -u4.Size.Y.Scale);
    u4.Visible = p23 ~= false;
    local v26 = u5;
    u5 = nil;

    if v26 then
        v26:Cancel();
    end;

    u3.BackgroundTransparency = 1;
    u3.Visible = true;
    TweenBloodScreen(0.75, 0.75, 0);
    task.wait(0.25);

    if u6 ~= u24 then
        return;
    end;

    if u4.Visible then
        TweenService:Create(u4, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.7)
        }):Play();
    end;

    task.wait(0.35);

    if u6 ~= u24 then
        return;
    end;

    PlayTransitionTween(0.25, 0);
    TweenBloodScreen(0.25, 1, 1);
    local v27 = workspace:GetAttribute("Gamemode") == "Deathmatch" and 8 or 2;
    task.delay(v27, function() -- Line: 189
        -- upvalues: u6 (ref), u24 (copy), u1 (ref)
        if u6 ~= u24 then
            return;
        end;

        u1.closeFrame();
    end);
end;

function u1.closeFrame() -- Line: 197
    -- upvalues: u6 (ref), u2 (ref), u4 (ref), PlayTransitionTween (copy), u5 (ref), u3 (ref)
    u6 = u6 + 1;
    u2.ImageLabel.ImageTransparency = 1;
    u2.BackgroundTransparency = 1;
    u2.Visible = false;
    u4.Position = UDim2.fromScale(0.5, -u4.Size.Y.Scale);
    u4.Visible = false;
    local u28 = PlayTransitionTween(1, 1);
    u28.Completed:Connect(function() -- Line: 209
        -- upvalues: u5 (ref), u28 (copy), u3 (ref)
        if u5 ~= u28 then
            return;
        end;

        u5 = nil;
        u3.BackgroundTransparency = 1;
        u3.Visible = false;
    end);
end;

function u1.Initialize(p29, p30) -- Line: 223
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), LocalPlayer (copy), u1 (copy)
    u2 = p29.Gameplay.Middle.BloodScreen;
    u3 = p29.Gameplay.Middle.Transition;
    u4 = p30;
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 228
        -- upvalues: u1 (ref)
        u1.closeFrame();
    end);
end;

function u1.Start() -- Line: 233
    -- upvalues: Remotes (copy), LocalPlayer (copy), u1 (copy)
    Remotes.UI.UIPlayerKilled.Listen(function(p31) -- Line: 234
        -- upvalues: LocalPlayer (ref), u1 (ref)
        if LocalPlayer.UserId == tonumber(p31.Victim) then
            u1.openFrame(u1.updateFrame(p31));
        end;
    end);
    Remotes.UI.ShowDeathCard.Listen(function(p32) -- Line: 240
        -- upvalues: LocalPlayer (ref), u1 (ref)
        if LocalPlayer.UserId == tonumber(p32.Victim) then
            u1.updateFrame(p32);
        end;
    end);
end;

return u1;