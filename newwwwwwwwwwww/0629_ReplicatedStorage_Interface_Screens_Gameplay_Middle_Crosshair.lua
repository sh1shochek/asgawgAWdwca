-- Crosshair (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Crosshair

-- Decompiled with Potassium's decompiler.

local u1 = {};
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local HordeController = require(ReplicatedStorage.Controllers.HordeController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local CurrentCamera = Workspace.CurrentCamera;
local Settings = require(script:WaitForChild("Settings"));
local u2 = {};
local u3 = { "Up", "Down", "Left", "Right" };
local u4 = { { 1, -1, 45 }, { -1, 1, 45 }, { -1, -1, -45 }, { 1, 1, -45 } };
local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(214, 41, 41);
local Color3_fromRGB_ret3 = Color3.fromRGB(255, 220, 140);
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = {};

local function rotationToPx(p11) -- Line: 74
    -- upvalues: CurrentCamera (copy)
    local ViewportSize = CurrentCamera.ViewportSize;
    local v12, v13;

    if ViewportSize.X > ViewportSize.Y then
        v12 = CurrentCamera.MaxAxisFieldOfView;
        v13 = CurrentCamera.FieldOfView;
    else
        v12 = CurrentCamera.FieldOfView;
        v13 = CurrentCamera.MaxAxisFieldOfView;
    end;

    if typeof(p11) == "number" then
        return p11 / v13 * ViewportSize.Y;
    end;

    return p11 / Vector2.new(v12, v13) * ViewportSize;
end;

local function shouldShowCrosshair(p14) -- Line: 95
    -- upvalues: u5 (ref)
    local Parent = u5.Parent;

    return p14.Properties.ShowCrosshair and not (Parent.TeamSelection.Visible or Parent.Leaderboard.Visible or (Parent.EndScreen.Visible or Parent.BuyMenu.Visible)) and not p14.IsAiming;
end;

local function calculateBloomScaleFromSpread(p15: number) -- Line: 109
    -- upvalues: CurrentCamera (copy)
    local math_clamp_ret = math.clamp(p15 / 2, 0, 30);
    local ViewportSize = CurrentCamera.ViewportSize;
    local v16, v17;

    if ViewportSize.X > ViewportSize.Y then
        v16 = CurrentCamera.MaxAxisFieldOfView;
        v17 = CurrentCamera.FieldOfView;
    else
        v16 = CurrentCamera.FieldOfView;
        v17 = CurrentCamera.MaxAxisFieldOfView;
    end;

    local v18;

    if typeof(math_clamp_ret) == "number" then
        v18 = math_clamp_ret / v17 * ViewportSize.Y;
    else
        v18 = math_clamp_ret / Vector2.new(v16, v17) * ViewportSize;
    end;

    return v18 / 15 + 1;
end;

local function getCrosshairDisplayState(p19) -- Line: 115
    if p19 and p19.getCrosshairDisplayState then
        return p19:getCrosshairDisplayState();
    end;

    return nil;
end;

local function getDisplayedOuterSpread(p20, p21) -- Line: 123
    return (not p21 or type(p21.OuterSpread) ~= "number") and (p20.getSpread and (p20:getSpread() or 0) or 0) or p21.OuterSpread;
end;

local function getDynamicSpreadPixels(p22: number) -- Line: 135
    return math.max(0, (p22 - 1) * 15);
end;

local function getConfiguredGapPixels(p23: number?) -- Line: 139
    -- upvalues: Settings (ref)
    return (p23 or Settings.Gap) * 5 / 5;
end;

local function getRestingGapPixels(p24) -- Line: 143
    -- upvalues: Settings (ref)
    local v25;

    if p24 then
        v25 = p24.Gap;
    else
        v25 = p24;
    end;

    local v26 = (v25 or Settings.Gap) * 5 / 5;

    if p24 and p24["Crosshair Style"] == "Classic" then
        return v26;
    end;

    return v26 + 5;
end;

local u27 = nil;

local function getRecoilAssistScale() -- Line: 158
    -- upvalues: u27 (ref), ReplicatedStorage (copy)
    if not u27 then
        local success, result = pcall(function() -- Line: 160
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if not success then
            return Vector3.new(1, 1, 1);
        end;

        u27 = result;
    end;

    return u27.GetRecoilAssistScale();
end;

local function calculateRecoilOffset(p28) -- Line: 173
    -- upvalues: Settings (ref), CameraController (copy), u27 (ref), ReplicatedStorage (copy), CurrentCamera (copy)
    if not (p28.Recoil and (p28.Properties and (p28.Properties.Recoil and Settings["Follow Recoil"]))) then
        return UDim2.new();
    end;

    local v29 = 1 - p28.Properties.Recoil.CameraScale;
    local WeaponKickRotation = CameraController.getWeaponKickRotation();
    local RotationValue = p28.Recoil.RotationValue;
    local v30, v31, v32, v33, v34, v35, v36, v37;

    if not u27 then
        local success, result = pcall(function() -- Line: 160
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if not success then
            v30 = Vector3.new(1, 1, 1);
            v31 = RotationValue * v30;
            v32 = Vector2.new(v31.Y - WeaponKickRotation.Y, v31.X - WeaponKickRotation.X) * 57.29577951308232;
            v33 = CurrentCamera.ViewportSize;

            if v33.X > v33.Y then
                v34 = CurrentCamera.MaxAxisFieldOfView;
                v35 = CurrentCamera.FieldOfView;
            else
                v34 = CurrentCamera.FieldOfView;
                v35 = CurrentCamera.MaxAxisFieldOfView;
            end;

            if typeof(v32) == "number" then
                v36 = v32 / v35 * v33.Y;
            else
                v36 = v32 / Vector2.new(v34, v35) * v33;
            end;

            v37 = v36 * Vector2.new(CameraController.getAspectRatioStretch(), 1) * -v29 / CurrentCamera.ViewportSize;

            return UDim2.fromScale(v37.X, v37.Y);
        end;

        u27 = result;
    end;

    v30 = u27.GetRecoilAssistScale();
    v31 = RotationValue * v30;
    v32 = Vector2.new(v31.Y - WeaponKickRotation.Y, v31.X - WeaponKickRotation.X) * 57.29577951308232;
    v33 = CurrentCamera.ViewportSize;

    if v33.X > v33.Y then
        v34 = CurrentCamera.MaxAxisFieldOfView;
        v35 = CurrentCamera.FieldOfView;
    else
        v34 = CurrentCamera.FieldOfView;
        v35 = CurrentCamera.MaxAxisFieldOfView;
    end;

    if typeof(v32) == "number" then
        v36 = v32 / v35 * v33.Y;
    else
        v36 = v32 / Vector2.new(v34, v35) * v33;
    end;

    v37 = v36 * Vector2.new(CameraController.getAspectRatioStretch(), 1) * -v29 / CurrentCamera.ViewportSize;

    return UDim2.fromScale(v37.X, v37.Y);
end;

local function updateAutomaticScope(p38: any, p39) -- Line: 208
    -- upvalues: CurrentCamera (copy), CameraController (copy)
    if not p38.IsAiming or p38.Properties.AimingOptions ~= "AutomaticScope" then
        return;
    end;

    if not p38.getBaseSpread then
        return;
    end;

    local ScopeReticlePart = p38.Viewmodel.Bobble.ScopeReticlePart;

    if not ScopeReticlePart then
        return;
    end;

    local v40 = p38:getBaseSpread() or 0;
    local Frame = ScopeReticlePart.SurfaceGui.Frame.Frame;
    local math_rad_ret = math.rad(CurrentCamera.FieldOfView / 2);
    local v41 = math.tan(math_rad_ret) * 2 * 0.15;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v42 = ViewportSize.X / ViewportSize.Y / CameraController.getAspectRatioStretch() * v41 / 0.15;
    local v43 = math.clamp(v40, 0, 2) * 2;
    Frame.Size = UDim2.fromScale(v43 + 2.5, v43 + 2.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5) + UDim2.new(p39.X.Scale * v42, 0, p39.Y.Scale * (v41 / 0.15), 0);
end;

local function updateTickPositions(p44: any, p45: number, p46: any, p47: number?) -- Line: 242
    -- upvalues: Settings (ref)
    if not p44 then
        return;
    end;

    local v48;

    if p46 then
        v48 = p46.Gap;
    else
        v48 = p46;
    end;

    local v49 = (v48 or Settings.Gap) * 5 / 5;

    if not p46 or p46["Crosshair Style"] ~= "Classic" then
        v49 = v49 + 5;
    end;

    local v50 = v49 + (p47 or 0) + (p45 - 1) * 15;
    p44.Right.Position = UDim2.new(0.5, v50, 0.5, 0);
    p44.Down.Position = UDim2.new(0.5, 0, 0.5, v50);
    p44.Left.Position = UDim2.new(0.5, -v50, 0.5, 0);
    p44.Up.Position = UDim2.new(0.5, 0, 0.5, -v50);
end;

local function resetTickPositions(p51, p52) -- Line: 260
    -- upvalues: updateTickPositions (copy)
    updateTickPositions(p51, 1, p52);
end;

local function applyTickVisuals(p53: any, p54, p55: number, p56: any, p57: number) -- Line: 264
    -- upvalues: u3 (copy)
    if not p53 then
        return;
    end;

    for _, v in ipairs(u3) do
        local v58 = p53:FindFirstChild(v);

        if v58 then
            v58.BackgroundColor3 = p54;
            v58.BackgroundTransparency = 1 - p55;
            local v59;

            if v == "Up" then
                v59 = p56["T Style"];
            else
                v59 = false;
            end;

            v58.Visible = not v59;
            local v60 = 15 * (p56.Length / 5) * p57;
            local v61 = 2 * (p56.Thickness / 1);

            if v == "Up" or v == "Down" then
                v58.Size = UDim2.new(0, v61, 0, v60);
            else
                v58.Size = UDim2.new(0, v60, 0, v61);
            end;

            if p56.Outline.Enabled then
                v58.BorderSizePixel = p56.Outline.Value;
                v58.BorderColor3 = Color3.new(0, 0, 0);
            else
                v58.BorderSizePixel = 0;
            end;
        end;
    end;
end;

local function hideTickFrames(p62: userdata?) -- Line: 302
    if not p62 then
        return;
    end;

    for _, child in pairs(p62:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false;
        end;
    end;
end;

function u1.ResetCrosshair() -- Line: 316
    -- upvalues: u5 (ref), Settings (ref), updateTickPositions (copy), u6 (ref), InventoryController (copy)
    if not u5 then
        return;
    end;

    u5.Position = UDim2.fromScale(0.5, 0.5);
    updateTickPositions(u5.Ticks, 1, Settings);
    updateTickPositions(u6, 1, Settings);
    local CurrentEquipped = InventoryController.getCurrentEquipped();

    if not CurrentEquipped or typeof(CurrentEquipped) ~= "table" then
        return;
    end;

    if CurrentEquipped.IsAiming and (CurrentEquipped.Properties and CurrentEquipped.Properties.AimingOptions == "AutomaticScope") then
        local Viewmodel = CurrentEquipped.Viewmodel;

        if Viewmodel and Viewmodel.Bobble then
            local ScopeReticlePart = Viewmodel.Bobble.ScopeReticlePart;
            local v63 = ScopeReticlePart and (ScopeReticlePart.SurfaceGui and ScopeReticlePart.SurfaceGui.Frame) and ScopeReticlePart.SurfaceGui.Frame:FindFirstChild("Frame");

            if v63 then
                v63.Position = UDim2.fromScale(0.5, 0.5);
                v63.Size = UDim2.fromScale(2.5, 2.5);
            end;
        end;
    end;

    local Recoil = CurrentEquipped.Recoil;

    if Recoil then
        Recoil.Value = Vector2.zero;
        Recoil.RecoveryStartTime = 0;
        Recoil.Time = 0;
        Recoil.RotationValue = Vector3.new(0, 0, 0);
    end;
end;

function u1.UpdateCrosshair(p64: number) -- Line: 355
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy), Settings (ref), DataController (copy), u5 (ref), hideTickFrames (copy), u6 (ref), InventoryController (copy), u2 (copy), MarketplaceService (copy), applyTickVisuals (copy), CurrentCamera (copy), calculateRecoilOffset (copy), updateAutomaticScope (copy), updateTickPositions (copy)
    local v65 = LocalPlayer:GetAttribute("IsSpectating") == true;
    local v66 = false;
    local v67 = nil;

    if v65 then
        local CurrentSpectateInstance = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance();

        if CurrentSpectateInstance and (not CurrentSpectateInstance.IsBot and Settings["Show Player Crosshairs"] == true) then
            v67 = DataController.Get(CurrentSpectateInstance.Player, "Settings.Game.Crosshair");

            if v67 then
                v66 = true;
            end;
        end;

        if CurrentSpectateInstance and (CurrentSpectateInstance.PerspectiveState == "First-Person" and CurrentSpectateInstance.CurrentEquipped) then
            local Name = CurrentSpectateInstance.CurrentEquipped.Name;

            if Name == "AWP" and true or Name == "SSG 08" or (Name == "AUG" and true or Name == "SG 553") and (CurrentSpectateInstance.Player:GetAttribute("ScopeIncrement") or 0) > 0 then
                u5.Visible = false;
                hideTickFrames(u5.Ticks);
                hideTickFrames(u6);

                if u5.Dot then
                    u5.Dot.Visible = false;
                end;

                if u5.Crosshair then
                    u5.Crosshair.Visible = false;
                end;

                return;
            end;

            local v68 = v66 and v67 and v67 or Settings;
            local v69 = v68["Crosshair Style"] == "Image";

            if u5.Ticks then
                u5.Ticks.Visible = not v69;

                for _, child in pairs(u5.Ticks:GetChildren()) do
                    if child:IsA("Frame") then
                        child.Visible = true;
                    end;
                end;
            end;

            if u5.Dot then
                u5.Dot.Visible = not v69 and v68["Center Dot"];
            end;

            if u5.Crosshair then
                u5.Crosshair.Visible = v69;
            end;
        elseif CurrentSpectateInstance and CurrentSpectateInstance.PerspectiveState == "First-Person" then
            u5.Visible = true;
        end;
    end;

    local Character = LocalPlayer.Character;
    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v70 = v65 and not CurrentEquipped and {
        IsAiming = false,
        Properties = {
            ShowCrosshair = true,
            AimingOptions = "None"
        }
    } or CurrentEquipped;

    if not (v65 or Character and v70) then
        return;
    end;

    local u71 = v66 and v67 and v67 or Settings;
    local v72 = u71.Alpha.Enabled and (u71.Alpha.Value / 255 or 1) or 1;
    local Color3_fromRGB_ret4 = Color3.fromRGB(u71.Red, u71.Green, u71.Blue);
    local v73;

    if u71["Crosshair Style"] == "Classic" and (v70 and v70.getCrosshairDisplayState) then
        v73 = v70:getCrosshairDisplayState();
    else
        v73 = nil;
    end;

    local v74 = u71["Crosshair Style"] == "Image";
    local v75 = not v74;
    local v76 = false;
    u5.Dot.Visible = not v74 and u71["Center Dot"];
    u5.Crosshair.Visible = v74;

    if v74 then
        local v77 = "rbxassetid://" .. tostring(u71["Crosshair Image"]);
        local success, result = pcall(function() -- Line: 470
            -- upvalues: u2 (ref), u71 (copy), MarketplaceService (ref)
            return u2[u71["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u71["Crosshair Image"]), Enum.InfoType.Asset);
        end);

        if success then
            u2[u71["Crosshair Image"]] = result;

            if result.AssetTypeId == 13 then
                v77 = `https://www.roblox.com/asset-thumbnail/image?assetId={u71["Crosshair Image"]}&width=420&height=420&format=png`;
            end;
        end;

        u5.Crosshair.Image = v77;
        u5.Crosshair.ImageColor3 = Color3_fromRGB_ret4;
        u5.Crosshair.ImageTransparency = 1 - v72;
    else
        local v78 = v72 * 0.5;

        if u71["Crosshair Style"] ~= "Classic" then
            v78 = v72;
        end;

        applyTickVisuals(u5.Ticks, Color3_fromRGB_ret4, v78, u71, u71["Crosshair Style"] == "Classic" and 0.35 or 1);
        applyTickVisuals(u6, Color3_fromRGB_ret4, v72 * 1, u71, 0.65);

        if u5.Dot and u71["Center Dot"] then
            u5.Dot.BackgroundColor3 = Color3_fromRGB_ret4;
            u5.Dot.BackgroundTransparency = 1 - v72;

            if u71.Outline.Enabled then
                u5.Dot.BorderSizePixel = u71.Outline.Value;
                u5.Dot.BorderColor3 = Color3.new(0, 0, 0);
            else
                u5.Dot.BorderSizePixel = 0;
            end;
        end;
    end;

    local Parent = u5.Parent;
    u5.Visible = v70.Properties.ShowCrosshair and not (Parent.TeamSelection.Visible or Parent.Leaderboard.Visible or (Parent.EndScreen.Visible or Parent.BuyMenu.Visible)) and not v70.IsAiming;
    local UDim2_new_ret = UDim2.new();
    local v79 = 1;

    if u5.Visible or v70.Properties.AimingOptions == "AutomaticScope" then
        if u71["Crosshair Style"] == "Classic" then
            local v80;

            if v73 and type(v73.OuterSpread) == "number" then
                v80 = v73.OuterSpread;
            else
                v80 = v70.getSpread and (v70:getSpread() or 0) or 0;
            end;

            local math_clamp_ret = math.clamp(v80 / 2, 0, 30);
            local ViewportSize = CurrentCamera.ViewportSize;
            local v81, v82;

            if ViewportSize.X > ViewportSize.Y then
                v81 = CurrentCamera.MaxAxisFieldOfView;
                v82 = CurrentCamera.FieldOfView;
            else
                v81 = CurrentCamera.FieldOfView;
                v82 = CurrentCamera.MaxAxisFieldOfView;
            end;

            local v83;

            if typeof(math_clamp_ret) == "number" then
                v83 = math_clamp_ret / v82 * ViewportSize.Y;
            else
                v83 = math_clamp_ret / Vector2.new(v81, v82) * ViewportSize;
            end;

            v79 = v83 / 15 + 1;
        end;

        UDim2_new_ret = calculateRecoilOffset(v70);
    end;

    updateAutomaticScope(v70, UDim2_new_ret);
    u5.Position = UDim2.fromScale(0.5, 0.5) + UDim2_new_ret;

    if not v74 then
        if u71["Crosshair Style"] == "Classic" then
            local math_max_ret = math.max(0, (v79 - 1) * 15);

            if v73 then
                v73 = v73.InnerSpread;
            end;

            local v84;

            if type(v73) == "number" then
                local math_clamp_ret = math.clamp(v73 / 2, 0, 30);
                local ViewportSize = CurrentCamera.ViewportSize;
                local v85, v86;

                if ViewportSize.X > ViewportSize.Y then
                    v85 = CurrentCamera.MaxAxisFieldOfView;
                    v86 = CurrentCamera.FieldOfView;
                else
                    v85 = CurrentCamera.FieldOfView;
                    v86 = CurrentCamera.MaxAxisFieldOfView;
                end;

                local v87;

                if typeof(math_clamp_ret) == "number" then
                    v87 = math_clamp_ret / v86 * ViewportSize.Y;
                else
                    v87 = math_clamp_ret / Vector2.new(v85, v86) * ViewportSize;
                end;

                v84 = math.max(0, (v87 / 15 + 1 - 1) * 15);
            else
                v84 = math.min(math_max_ret, 7);
            end;

            local v88;

            if u71 then
                v88 = u71.Gap;
            else
                v88 = u71;
            end;

            local v89 = (v88 or Settings.Gap) * 5 / 5;

            if not u71 or u71["Crosshair Style"] ~= "Classic" then
                v89 = v89 + 5;
            end;

            local v90 = u71["Center Dot"] and v89 + v84 <= 0;
            local v91 = u71["Center Dot"] and v89 + math_max_ret <= 0;
            v76 = not v90;

            if u6 and not v90 then
                updateTickPositions(u6, v84 / 15 + 1, u71);
            end;

            if v91 then
                updateTickPositions(u5.Ticks, 1, u71);
                v75 = false;
            else
                updateTickPositions(u5.Ticks, math_max_ret / 15 + 1, u71);
                v75 = true;
            end;
        else
            v75 = true;
            updateTickPositions(u5.Ticks, v79, u71);

            if u6 then
                updateTickPositions(u6, 1, u71);
            end;
        end;
    end;

    u5.Ticks.Visible = v75;

    if u6 then
        u6.Visible = v76;
    end;
end;

local function buildHitmarker() -- Line: 581
    -- upvalues: u9 (copy), u4 (copy), Color3_fromRGB_ret (copy), u5 (ref), u7 (ref), u8 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Hitmarker";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromOffset(0, 0);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = 3;
    Frame.Visible = false;
    local UIScale = Instance.new("UIScale");
    UIScale.Parent = Frame;
    table.clear(u9);

    for _, v in u4 do
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Arm";
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame2.Position = UDim2.fromOffset(v[1] * 6.717514421272201, v[2] * 6.717514421272201);
        Frame2.Size = UDim2.fromOffset(2, 9);
        Frame2.Rotation = v[3];
        Frame2.BorderSizePixel = 0;
        Frame2.BackgroundColor3 = Color3_fromRGB_ret;
        Frame2.ZIndex = 3;
        Frame2.Parent = Frame;
        u9[#u9 + 1] = Frame2;
    end;

    Frame.Parent = u5;
    u7 = Frame;
    u8 = UIScale;
end;

function u1.ShowHitmarker(p92: boolean, p93: boolean) -- Line: 612
    -- upvalues: u7 (ref), u8 (ref), u10 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy), u9 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local u94 = u7;
    local u95 = u8;

    if not (u94 and u95) then
        return;
    end;

    for _, v in u10 do
        v:Cancel();
    end;

    table.clear(u10);
    local v96;

    if p93 then
        v96 = Color3_fromRGB_ret2;
    elseif p92 then
        v96 = Color3_fromRGB_ret3;
    else
        v96 = Color3_fromRGB_ret;
    end;

    for _, v in u9 do
        v.BackgroundColor3 = v96;
        v.BackgroundTransparency = 0;
        local v97 = TweenService:Create(v, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        });
        v97:Play();
        u10[#u10 + 1] = v97;
    end;

    u95.Scale = p93 and 1.5525 or 1.35;
    local v98 = TweenService:Create(u95, TweenInfo_new_ret, {
        Scale = 1
    });
    v98:Play();
    u10[#u10 + 1] = v98;
    u94.Visible = true;
    v98.Completed:Once(function() -- Line: 634
        -- upvalues: u95 (copy), u94 (copy)
        if u95.Scale == 1 then
            u94.Visible = false;
        end;
    end);
end;

function u1.Initialize(p99, p100) -- Line: 644
    -- upvalues: u5 (ref), buildHitmarker (copy), HordeController (copy), u1 (copy), u6 (ref), DataController (copy), LocalPlayer (copy), Settings (ref), RunServiceController (copy), Remotes (copy)
    u5 = p100;
    buildHitmarker();
    HordeController.HitConfirmed:Connect(u1.ShowHitmarker);
    u6 = u5:FindFirstChild("InnerTicks");

    if not u6 and u5.Ticks then
        local v101 = u5.Ticks:Clone();
        v101.Name = "InnerTicks";
        v101.Visible = false;
        v101.Parent = u5;
        u6 = v101;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.Crosshair", function(p102) -- Line: 659
        -- upvalues: Settings (ref), u1 (ref)
        Settings = p102;
        task.delay(0.1, function() -- Line: 661
            -- upvalues: u1 (ref)
            u1.UpdateCrosshair(0);
        end);
    end);
    RunServiceController.BindToRenderStep("UI.Crosshair.Update", u1.UpdateCrosshair);
    Remotes.Character.CharacterDied.Listen(u1.ResetCrosshair);
end;

return u1;