-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = {
    KillTs = true,
    DefuseB = true
};

local function computeInterval(p3: number, p4: number) -- Line: 55
    local v5 = p3 / p4 * 0.9 + 0.1;

    return v5 <= 0.15 and 0.15 or v5;
end;

local function toggleFlashingLight(p6: userdata?) -- Line: 63
    if p6 and (p6:FindFirstChild("Attachment") and p6.Attachment:FindFirstChild("PointLight")) then
        local PointLight = p6.Attachment.PointLight;
        PointLight.Enabled = not PointLight.Enabled;
    end;
end;

local function syncTutorialMarkers(p7) -- Line: 71
    -- upvalues: LocalPlayer (copy), IsTutorialMode (copy), u2 (copy)
    local Attribute = LocalPlayer:GetAttribute("TutorialStep");
    local Attribute2 = p7.Model:GetAttribute("Defused");
    local v8 = p7.IsDefused or (Attribute2 ~= nil and Attribute2 ~= false and true or p7.Model:GetAttribute("Exploding") == true);
    local v9 = IsTutorialMode() and not v8 and u2[Attribute] == true;
    local TutorialBombOutline = p7.Model:FindFirstChild("TutorialBombOutline");

    if not v9 or TutorialBombOutline then
        if not v9 and TutorialBombOutline then
            TutorialBombOutline:Destroy();
        end;

        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "TutorialBombOutline";
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.fromRGB(235, 40, 40);
    Highlight.OutlineTransparency = 0;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Adornee = p7.Model;
    Highlight.Parent = p7.Model;
end;

function u1.updateHeartbeat(p10, p11) -- Line: 98
    -- upvalues: workspace_CurrentCamera (copy)
    if p10.Model:GetAttribute("IsGettingDefused") then
        p10.Model:SetAttribute("CanDefuse", false);

        return;
    end;

    if not (p11.PrimaryPart and p10.Model.PrimaryPart) then
        return;
    end;

    if (p11.PrimaryPart.Position - p10.Model.PrimaryPart.Position).Magnitude > 5 then
        p10.Model:SetAttribute("CanDefuse", false);

        return;
    end;

    local v12 = p10.Model.PrimaryPart.Position - workspace_CurrentCamera.CFrame.Position;
    local Magnitude = v12.Magnitude;

    if Magnitude <= 0 then
        p10.Model:SetAttribute("CanDefuse", false);

        return;
    end;

    local v13 = workspace_CurrentCamera.CFrame.LookVector:Dot(v12 / Magnitude);
    p10.Model:SetAttribute("CanDefuse", v13 >= 0.966);
end;

function u1.new(p14) -- Line: 132
    -- upvalues: u1 (copy), Janitor (copy), Sound (copy), HttpService (copy), RunServiceController (copy), Router (copy), ReplicatedStorage (copy), CharacterResolver (copy), CameraController (copy), HapticsController (copy), LocalPlayer (copy), IsTutorialMode (copy), syncTutorialMarkers (copy)
    local u15 = setmetatable({}, u1);
    u15.Janitor = Janitor.new();
    u15.Sound = Sound.new("C4");
    u15.Janitor:Add(function() -- Line: 137
        -- upvalues: u15 (copy)
        u15.Sound:destroy();
    end);
    u15.Model = p14;
    u15.Data = HttpService:JSONDecode(p14:GetAttribute("BombPlanted"));
    local v16 = typeof(u15.Data.Time) == "number" and u15.Data.Time or workspace:GetServerTimeNow();
    local v17 = typeof(u15.Data.TimeUntilExplode) == "number" and (u15.Data.TimeUntilExplode or 40) or 40;
    u15.TimeUntilExplode = math.max(v17, 0.1);
    u15.ExplodeAt = v16 + u15.TimeUntilExplode;
    u15.NextBeepAt = workspace:GetServerTimeNow();
    u15.IsDefused = false;
    local v18 = RunServiceController.CreateBindingName("Observers.Game.BombPlanted");
    Router.broadcastRouter("CreateNotification", "Bomb", "The bomb has been planted.", 2.5);

    for _, descendant in ipairs(u15.Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanQuery = true;
        end;
    end;

    u15.Janitor:Add(u15.Model:GetAttributeChangedSignal("Defused"):Connect(function() -- Line: 162
        -- upvalues: Router (ref), u15 (copy)
        Router.broadcastRouter("Cancel Defuse Bomb");
        Router.broadcastRouter("CreateNotification", "Bomb", "The bomb has been defused.", 2.5);
        u15.IsDefused = true;
    end));
    u15.Janitor:Add(u15.Model:GetAttributeChangedSignal("Exploding"):Connect(function() -- Line: 169
        -- upvalues: Router (ref), ReplicatedStorage (ref)
        Router.broadcastRouter("Cancel Defuse Bomb");
        local DefuseBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb);

        if DefuseBomb.SetDefuseBlockedUntil then
            DefuseBomb.SetDefuseBlockedUntil(workspace:GetServerTimeNow() + 5);
        end;
    end));
    u15.Janitor:Add(u15.Model:GetAttributeChangedSignal("Exploded"):Connect(function() -- Line: 179
        -- upvalues: CharacterResolver (ref), CameraController (ref), u15 (copy), HapticsController (ref)
        local LocalCharacter = CharacterResolver.getLocalCharacter();

        if LocalCharacter and CharacterResolver.isAliveCharacter(LocalCharacter) then
            CameraController.BombExploded((u15.Model:GetPivot().Position - LocalCharacter:GetPivot().Position).Magnitude);
            HapticsController.vibrate(Enum.VibrationMotor.Large, 1.5, 0.25);
        end;
    end));
    u15.Janitor:Add(RunServiceController.BindToHeartbeat(`{v18}.DefuseCheck`, function(p19: number) -- Line: 187
        -- upvalues: CharacterResolver (ref), LocalPlayer (ref), u15 (copy)
        local LocalCharacter = CharacterResolver.getLocalCharacter();

        if CharacterResolver.isAliveCharacter(LocalCharacter) and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
            u15:updateHeartbeat(LocalCharacter);
        end;
    end));
    u15.Janitor:Add(RunServiceController.BindToHeartbeat(`{v18}.Beep`, function(p20: number) -- Line: 194
        -- upvalues: u15 (copy)
        local ServerTimeNow = workspace:GetServerTimeNow();
        local math_max_ret = math.max(u15.ExplodeAt - ServerTimeNow, 0);
        local v21 = u15.Model:FindFirstChild("Weapon") and u15.Model.Weapon:FindFirstChild("FlashingLight");

        if u15.IsDefused or math_max_ret <= 0 then
            if v21 and (v21:FindFirstChild("Attachment") and v21.Attachment:FindFirstChild("PointLight")) then
                local PointLight = v21.Attachment.PointLight;
                PointLight.Enabled = not PointLight.Enabled;
            end;

            return;
        end;

        if u15.NextBeepAt <= ServerTimeNow then
            local v22 = math_max_ret / u15.TimeUntilExplode * 0.9 + 0.1;
            u15.NextBeepAt = ServerTimeNow + (v22 <= 0.15 and 0.15 or v22);

            if v21 and (v21:FindFirstChild("Attachment") and v21.Attachment:FindFirstChild("PointLight")) then
                local PointLight = v21.Attachment.PointLight;
                PointLight.Enabled = not PointLight.Enabled;
            end;

            local PrimaryPart = u15.Model.PrimaryPart;

            if PrimaryPart then
                u15.Sound:play({
                    Name = "Beep",
                    Parent = PrimaryPart
                });
            end;
        end;
    end));

    if IsTutorialMode() then
        local function sync() -- Line: 219
            -- upvalues: syncTutorialMarkers (ref), u15 (copy)
            syncTutorialMarkers(u15);
        end;

        u15.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("TutorialStep"):Connect(sync));
        u15.Janitor:Add(u15.Model:GetAttributeChangedSignal("Defused"):Connect(sync));
        u15.Janitor:Add(u15.Model:GetAttributeChangedSignal("Exploding"):Connect(sync));
        u15.Janitor:Add(function() -- Line: 225
            -- upvalues: u15 (copy)
            local TutorialBombOutline = u15.Model:FindFirstChild("TutorialBombOutline");

            if TutorialBombOutline then
                TutorialBombOutline:Destroy();
            end;
        end);
        syncTutorialMarkers(u15);
    end;

    return u15;
end;

function u1.destroy(p23) -- Line: 240
    p23.Janitor:Destroy();
end;

return u1;