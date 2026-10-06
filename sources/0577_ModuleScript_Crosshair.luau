-- Decompiled with Potassium's decompiler.

local u1 = {};
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local CurrentCamera = Workspace.CurrentCamera;
local Settings = require(script:WaitForChild("Settings"));
local u2 = {};
local u3 = { "Up", "Down", "Left", "Right" };
local u4 = nil;
local u5 = nil;

local function rotationToPx(p6) -- Line: 54
    -- upvalues: CurrentCamera (copy)
    local ViewportSize = CurrentCamera.ViewportSize;
    local v7, v8;

    if ViewportSize.X > ViewportSize.Y then
        v7 = CurrentCamera.MaxAxisFieldOfView;
        v8 = CurrentCamera.FieldOfView;
    else
        v7 = CurrentCamera.FieldOfView;
        v8 = CurrentCamera.MaxAxisFieldOfView;
    end;

    if typeof(p6) == "number" then
        return p6 / v8 * ViewportSize.Y;
    end;

    return p6 / Vector2.new(v7, v8) * ViewportSize;
end;

local function shouldShowCrosshair(p9) -- Line: 75
    -- upvalues: u4 (ref)
    local Parent = u4.Parent;

    return p9.Properties.ShowCrosshair and not (Parent.TeamSelection.Visible or Parent.Leaderboard.Visible or (Parent.EndScreen.Visible or Parent.BuyMenu.Visible)) and not p9.IsAiming;
end;

local function calculateBloomScaleFromSpread(p10: number) -- Line: 89
    -- upvalues: CurrentCamera (copy)
    local math_clamp_ret = math.clamp(p10 / 2, 0, 30);
    local ViewportSize = CurrentCamera.ViewportSize;
    local v11, v12;

    if ViewportSize.X > ViewportSize.Y then
        v11 = CurrentCamera.MaxAxisFieldOfView;
        v12 = CurrentCamera.FieldOfView;
    else
        v11 = CurrentCamera.FieldOfView;
        v12 = CurrentCamera.MaxAxisFieldOfView;
    end;

    local v13;

    if typeof(math_clamp_ret) == "number" then
        v13 = math_clamp_ret / v12 * ViewportSize.Y;
    else
        v13 = math_clamp_ret / Vector2.new(v11, v12) * ViewportSize;
    end;

    return v13 / 15 + 1;
end;

local function getCrosshairDisplayState(p14) -- Line: 95
    if p14 and p14.getCrosshairDisplayState then
        return p14:getCrosshairDisplayState();
    end;

    return nil;
end;

local function getDisplayedOuterSpread(p15, p16) -- Line: 103
    return (not p16 or type(p16.OuterSpread) ~= "number") and (p15.getSpread and (p15:getSpread() or 0) or 0) or p16.OuterSpread;
end;

local function getDynamicSpreadPixels(p17: number) -- Line: 115
    return math.max(0, (p17 - 1) * 15);
end;

local function getConfiguredGapPixels(p18: number?) -- Line: 119
    -- upvalues: Settings (ref)
    return (p18 or Settings.Gap) * 5 / 5;
end;

local function getRestingGapPixels(p19) -- Line: 123
    -- upvalues: Settings (ref)
    local v20;

    if p19 then
        v20 = p19.Gap;
    else
        v20 = p19;
    end;

    local v21 = (v20 or Settings.Gap) * 5 / 5;

    if p19 and p19["Crosshair Style"] == "Classic" then
        return v21;
    end;

    return v21 + 5;
end;

local u22 = nil;

local function getRecoilAssistScale() -- Line: 138
    -- upvalues: u22 (ref), ReplicatedStorage (copy)
    if not u22 then
        local success, result = pcall(function() -- Line: 140
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if not success then
            return Vector3.new(1, 1, 1);
        end;

        u22 = result;
    end;

    return u22.GetRecoilAssistScale();
end;

local function calculateRecoilOffset(p23) -- Line: 153
    -- upvalues: Settings (ref), CameraController (copy), u22 (ref), ReplicatedStorage (copy), CurrentCamera (copy)
    if not (p23.Recoil and (p23.Properties and (p23.Properties.Recoil and Settings["Follow Recoil"]))) then
        return UDim2.new();
    end;

    local v24 = 1 - p23.Properties.Recoil.CameraScale;
    local WeaponKickRotation = CameraController.getWeaponKickRotation();
    local RotationValue = p23.Recoil.RotationValue;
    local v25, v26, v27, v28, v29, v30, v31, v32;

    if not u22 then
        local success, result = pcall(function() -- Line: 140
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if not success then
            v25 = Vector3.new(1, 1, 1);
            v26 = RotationValue * v25;
            v27 = Vector2.new(v26.Y - WeaponKickRotation.Y, v26.X - WeaponKickRotation.X) * 57.29577951308232;
            v28 = CurrentCamera.ViewportSize;

            if v28.X > v28.Y then
                v29 = CurrentCamera.MaxAxisFieldOfView;
                v30 = CurrentCamera.FieldOfView;
            else
                v29 = CurrentCamera.FieldOfView;
                v30 = CurrentCamera.MaxAxisFieldOfView;
            end;

            if typeof(v27) == "number" then
                v31 = v27 / v30 * v28.Y;
            else
                v31 = v27 / Vector2.new(v29, v30) * v28;
            end;

            v32 = v31 * Vector2.new(CameraController.getAspectRatioStretch(), 1) * -v24 / CurrentCamera.ViewportSize;

            return UDim2.fromScale(v32.X, v32.Y);
        end;

        u22 = result;
    end;

    v25 = u22.GetRecoilAssistScale();
    v26 = RotationValue * v25;
    v27 = Vector2.new(v26.Y - WeaponKickRotation.Y, v26.X - WeaponKickRotation.X) * 57.29577951308232;
    v28 = CurrentCamera.ViewportSize;

    if v28.X > v28.Y then
        v29 = CurrentCamera.MaxAxisFieldOfView;
        v30 = CurrentCamera.FieldOfView;
    else
        v29 = CurrentCamera.FieldOfView;
        v30 = CurrentCamera.MaxAxisFieldOfView;
    end;

    if typeof(v27) == "number" then
        v31 = v27 / v30 * v28.Y;
    else
        v31 = v27 / Vector2.new(v29, v30) * v28;
    end;

    v32 = v31 * Vector2.new(CameraController.getAspectRatioStretch(), 1) * -v24 / CurrentCamera.ViewportSize;

    return UDim2.fromScale(v32.X, v32.Y);
end;

local function updateAutomaticScope(p33: any, p34) -- Line: 188
    -- upvalues: CurrentCamera (copy), CameraController (copy)
    if not p33.IsAiming or p33.Properties.AimingOptions ~= "AutomaticScope" then
        return;
    end;

    if not p33.getBaseSpread then
        return;
    end;

    local ScopeReticlePart = p33.Viewmodel.Bobble.ScopeReticlePart;

    if not ScopeReticlePart then
        return;
    end;

    local v35 = p33:getBaseSpread() or 0;
    local Frame = ScopeReticlePart.SurfaceGui.Frame.Frame;
    local math_rad_ret = math.rad(CurrentCamera.FieldOfView / 2);
    local v36 = math.tan(math_rad_ret) * 2 * 0.15;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v37 = ViewportSize.X / ViewportSize.Y / CameraController.getAspectRatioStretch() * v36 / 0.15;
    local v38 = math.clamp(v35, 0, 2) * 2;
    Frame.Size = UDim2.fromScale(v38 + 2.5, v38 + 2.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5) + UDim2.new(p34.X.Scale * v37, 0, p34.Y.Scale * (v36 / 0.15), 0);
end;

local function updateTickPositions(p39: any, p40: number, p41: any, p42: number?) -- Line: 222
    -- upvalues: Settings (ref)
    if not p39 then
        return;
    end;

    local v43;

    if p41 then
        v43 = p41.Gap;
    else
        v43 = p41;
    end;

    local v44 = (v43 or Settings.Gap) * 5 / 5;

    if not p41 or p41["Crosshair Style"] ~= "Classic" then
        v44 = v44 + 5;
    end;

    local v45 = v44 + (p42 or 0) + (p40 - 1) * 15;
    p39.Right.Position = UDim2.new(0.5, v45, 0.5, 0);
    p39.Down.Position = UDim2.new(0.5, 0, 0.5, v45);
    p39.Left.Position = UDim2.new(0.5, -v45, 0.5, 0);
    p39.Up.Position = UDim2.new(0.5, 0, 0.5, -v45);
end;

local function resetTickPositions(p46, p47) -- Line: 240
    -- upvalues: updateTickPositions (copy)
    updateTickPositions(p46, 1, p47);
end;

local function applyTickVisuals(p48: any, p49, p50: number, p51: any, p52: number) -- Line: 244
    -- upvalues: u3 (copy)
    if not p48 then
        return;
    end;

    for _, v in ipairs(u3) do
        local v53 = p48:FindFirstChild(v);

        if v53 then
            v53.BackgroundColor3 = p49;
            v53.BackgroundTransparency = 1 - p50;
            local v54;

            if v == "Up" then
                v54 = p51["T Style"];
            else
                v54 = false;
            end;

            v53.Visible = not v54;
            local v55 = 15 * (p51.Length / 5) * p52;
            local v56 = 2 * (p51.Thickness / 1);

            if v == "Up" or v == "Down" then
                v53.Size = UDim2.new(0, v56, 0, v55);
            else
                v53.Size = UDim2.new(0, v55, 0, v56);
            end;

            if p51.Outline.Enabled then
                v53.BorderSizePixel = p51.Outline.Value;
                v53.BorderColor3 = Color3.new(0, 0, 0);
            else
                v53.BorderSizePixel = 0;
            end;
        end;
    end;
end;

local function hideTickFrames(p57: userdata?) -- Line: 282
    if not p57 then
        return;
    end;

    for _, child in pairs(p57:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false;
        end;
    end;
end;

function u1.ResetCrosshair() -- Line: 296
    -- upvalues: u4 (ref), Settings (ref), updateTickPositions (copy), u5 (ref), InventoryController (copy)
    if not u4 then
        return;
    end;

    u4.Position = UDim2.fromScale(0.5, 0.5);
    updateTickPositions(u4.Ticks, 1, Settings);
    updateTickPositions(u5, 1, Settings);
    local CurrentEquipped = InventoryController.getCurrentEquipped();

    if not CurrentEquipped or typeof(CurrentEquipped) ~= "table" then
        return;
    end;

    if CurrentEquipped.IsAiming and (CurrentEquipped.Properties and CurrentEquipped.Properties.AimingOptions == "AutomaticScope") then
        local Viewmodel = CurrentEquipped.Viewmodel;

        if Viewmodel and Viewmodel.Bobble then
            local ScopeReticlePart = Viewmodel.Bobble.ScopeReticlePart;
            local v58 = ScopeReticlePart and (ScopeReticlePart.SurfaceGui and ScopeReticlePart.SurfaceGui.Frame) and ScopeReticlePart.SurfaceGui.Frame:FindFirstChild("Frame");

            if v58 then
                v58.Position = UDim2.fromScale(0.5, 0.5);
                v58.Size = UDim2.fromScale(2.5, 2.5);
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

function u1.UpdateCrosshair(p59: number) -- Line: 335
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy), Settings (ref), DataController (copy), u4 (ref), hideTickFrames (copy), u5 (ref), InventoryController (copy), u2 (copy), MarketplaceService (copy), applyTickVisuals (copy), CurrentCamera (copy), calculateRecoilOffset (copy), updateAutomaticScope (copy), updateTickPositions (copy)
    local v60 = LocalPlayer:GetAttribute("IsSpectating") == true;
    local v61 = false;
    local v62 = nil;

    if v60 then
        local CurrentSpectateInstance = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance();

        if CurrentSpectateInstance and (not CurrentSpectateInstance.IsBot and Settings["Show Player Crosshairs"] == true) then
            v62 = DataController.Get(CurrentSpectateInstance.Player, "Settings.Game.Crosshair");

            if v62 then
                v61 = true;
            end;
        end;

        if CurrentSpectateInstance and (CurrentSpectateInstance.PerspectiveState == "First-Person" and CurrentSpectateInstance.CurrentEquipped) then
            local Name = CurrentSpectateInstance.CurrentEquipped.Name;

            if Name == "AWP" and true or Name == "SSG 08" or (Name == "AUG" and true or Name == "SG 553") and (CurrentSpectateInstance.Player:GetAttribute("ScopeIncrement") or 0) > 0 then
                u4.Visible = false;
                hideTickFrames(u4.Ticks);
                hideTickFrames(u5);

                if u4.Dot then
                    u4.Dot.Visible = false;
                end;

                if u4.Crosshair then
                    u4.Crosshair.Visible = false;
                end;

                return;
            end;

            local v63 = v61 and v62 and v62 or Settings;
            local v64 = v63["Crosshair Style"] == "Image";

            if u4.Ticks then
                u4.Ticks.Visible = not v64;

                for _, child in pairs(u4.Ticks:GetChildren()) do
                    if child:IsA("Frame") then
                        child.Visible = true;
                    end;
                end;
            end;

            if u4.Dot then
                u4.Dot.Visible = not v64 and v63["Center Dot"];
            end;

            if u4.Crosshair then
                u4.Crosshair.Visible = v64;
            end;
        elseif CurrentSpectateInstance and CurrentSpectateInstance.PerspectiveState == "First-Person" then
            u4.Visible = true;
        end;
    end;

    local Character = LocalPlayer.Character;
    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v65 = v60 and not CurrentEquipped and {
        IsAiming = false,
        Properties = {
            ShowCrosshair = true,
            AimingOptions = "None"
        }
    } or CurrentEquipped;

    if not (v60 or Character and v65) then
        return;
    end;

    local u66 = v61 and v62 and v62 or Settings;
    local v67 = u66.Alpha.Enabled and (u66.Alpha.Value / 255 or 1) or 1;
    local Color3_fromRGB_ret = Color3.fromRGB(u66.Red, u66.Green, u66.Blue);
    local v68;

    if u66["Crosshair Style"] == "Classic" and (v65 and v65.getCrosshairDisplayState) then
        v68 = v65:getCrosshairDisplayState();
    else
        v68 = nil;
    end;

    local v69 = u66["Crosshair Style"] == "Image";
    local v70 = not v69;
    local v71 = false;
    u4.Dot.Visible = not v69 and u66["Center Dot"];
    u4.Crosshair.Visible = v69;

    if v69 then
        local v72 = "rbxassetid://" .. tostring(u66["Crosshair Image"]);
        local success, result = pcall(function() -- Line: 450
            -- upvalues: u2 (ref), u66 (copy), MarketplaceService (ref)
            return u2[u66["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u66["Crosshair Image"]), Enum.InfoType.Asset);
        end);

        if success then
            u2[u66["Crosshair Image"]] = result;

            if result.AssetTypeId == 13 then
                v72 = `https://www.roblox.com/asset-thumbnail/image?assetId={u66["Crosshair Image"]}&width=420&height=420&format=png`;
            end;
        end;

        u4.Crosshair.Image = v72;
        u4.Crosshair.ImageColor3 = Color3_fromRGB_ret;
        u4.Crosshair.ImageTransparency = 1 - v67;
    else
        local v73 = v67 * 0.5;

        if u66["Crosshair Style"] ~= "Classic" then
            v73 = v67;
        end;

        applyTickVisuals(u4.Ticks, Color3_fromRGB_ret, v73, u66, u66["Crosshair Style"] == "Classic" and 0.35 or 1);
        applyTickVisuals(u5, Color3_fromRGB_ret, v67 * 1, u66, 0.65);

        if u4.Dot and u66["Center Dot"] then
            u4.Dot.BackgroundColor3 = Color3_fromRGB_ret;
            u4.Dot.BackgroundTransparency = 1 - v67;

            if u66.Outline.Enabled then
                u4.Dot.BorderSizePixel = u66.Outline.Value;
                u4.Dot.BorderColor3 = Color3.new(0, 0, 0);
            else
                u4.Dot.BorderSizePixel = 0;
            end;
        end;
    end;

    local Parent = u4.Parent;
    u4.Visible = v65.Properties.ShowCrosshair and not (Parent.TeamSelection.Visible or Parent.Leaderboard.Visible or (Parent.EndScreen.Visible or Parent.BuyMenu.Visible)) and not v65.IsAiming;
    local UDim2_new_ret = UDim2.new();
    local v74 = 1;

    if u4.Visible or v65.Properties.AimingOptions == "AutomaticScope" then
        if u66["Crosshair Style"] == "Classic" then
            local v75;

            if v68 and type(v68.OuterSpread) == "number" then
                v75 = v68.OuterSpread;
            else
                v75 = v65.getSpread and (v65:getSpread() or 0) or 0;
            end;

            local math_clamp_ret = math.clamp(v75 / 2, 0, 30);
            local ViewportSize = CurrentCamera.ViewportSize;
            local v76, v77;

            if ViewportSize.X > ViewportSize.Y then
                v76 = CurrentCamera.MaxAxisFieldOfView;
                v77 = CurrentCamera.FieldOfView;
            else
                v76 = CurrentCamera.FieldOfView;
                v77 = CurrentCamera.MaxAxisFieldOfView;
            end;

            local v78;

            if typeof(math_clamp_ret) == "number" then
                v78 = math_clamp_ret / v77 * ViewportSize.Y;
            else
                v78 = math_clamp_ret / Vector2.new(v76, v77) * ViewportSize;
            end;

            v74 = v78 / 15 + 1;
        end;

        UDim2_new_ret = calculateRecoilOffset(v65);
    end;

    updateAutomaticScope(v65, UDim2_new_ret);
    u4.Position = UDim2.fromScale(0.5, 0.5) + UDim2_new_ret;

    if not v69 then
        if u66["Crosshair Style"] == "Classic" then
            local math_max_ret = math.max(0, (v74 - 1) * 15);

            if v68 then
                v68 = v68.InnerSpread;
            end;

            local v79;

            if type(v68) == "number" then
                local math_clamp_ret = math.clamp(v68 / 2, 0, 30);
                local ViewportSize = CurrentCamera.ViewportSize;
                local v80, v81;

                if ViewportSize.X > ViewportSize.Y then
                    v80 = CurrentCamera.MaxAxisFieldOfView;
                    v81 = CurrentCamera.FieldOfView;
                else
                    v80 = CurrentCamera.FieldOfView;
                    v81 = CurrentCamera.MaxAxisFieldOfView;
                end;

                local v82;

                if typeof(math_clamp_ret) == "number" then
                    v82 = math_clamp_ret / v81 * ViewportSize.Y;
                else
                    v82 = math_clamp_ret / Vector2.new(v80, v81) * ViewportSize;
                end;

                v79 = math.max(0, (v82 / 15 + 1 - 1) * 15);
            else
                v79 = math.min(math_max_ret, 7);
            end;

            local v83;

            if u66 then
                v83 = u66.Gap;
            else
                v83 = u66;
            end;

            local v84 = (v83 or Settings.Gap) * 5 / 5;

            if not u66 or u66["Crosshair Style"] ~= "Classic" then
                v84 = v84 + 5;
            end;

            local v85 = u66["Center Dot"] and v84 + v79 <= 0;
            local v86 = u66["Center Dot"] and v84 + math_max_ret <= 0;
            v71 = not v85;

            if u5 and not v85 then
                updateTickPositions(u5, v79 / 15 + 1, u66);
            end;

            if v86 then
                updateTickPositions(u4.Ticks, 1, u66);
                v70 = false;
            else
                updateTickPositions(u4.Ticks, math_max_ret / 15 + 1, u66);
                v70 = true;
            end;
        else
            v70 = true;
            updateTickPositions(u4.Ticks, v74, u66);

            if u5 then
                updateTickPositions(u5, 1, u66);
            end;
        end;
    end;

    u4.Ticks.Visible = v70;

    if u5 then
        u5.Visible = v71;
    end;
end;

function u1.Initialize(p87, p88) -- Line: 563
    -- upvalues: u4 (ref), u5 (ref), DataController (copy), LocalPlayer (copy), Settings (ref), u1 (copy), RunServiceController (copy), Remotes (copy)
    u4 = p88;
    u5 = u4:FindFirstChild("InnerTicks");

    if not u5 and u4.Ticks then
        local v89 = u4.Ticks:Clone();
        v89.Name = "InnerTicks";
        v89.Visible = false;
        v89.Parent = u4;
        u5 = v89;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.Crosshair", function(p90) -- Line: 576
        -- upvalues: Settings (ref), u1 (ref)
        Settings = p90;
        task.delay(0.1, function() -- Line: 578
            -- upvalues: u1 (ref)
            u1.UpdateCrosshair(0);
        end);
    end);
    RunServiceController.BindToRenderStep("UI.Crosshair.Update", u1.UpdateCrosshair);
    Remotes.Character.CharacterDied.Listen(u1.ResetCrosshair);
end;

return u1;