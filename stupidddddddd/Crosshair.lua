-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Crosshair
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Crosshair
-- Decompile time: 28.93 ms

local u0 = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local CurrentCamera = Workspace.CurrentCamera
local Settings = require(script:WaitForChild("Settings"))
local u63 = {}
local u64 = {"Up", "Down", "Left", "Right"}
local u69 = nil
local u70 = nil

local function rotationToPx(a1) -- Line: 54 -- upvalues: CurrentCamera (val)
    local FieldOfView, MaxAxisFieldOfView
    local ViewportSize = CurrentCamera.ViewportSize
    if not (ViewportSize.Y < ViewportSize.X) then
        MaxAxisFieldOfView = CurrentCamera.FieldOfView
        FieldOfView = CurrentCamera.MaxAxisFieldOfView
    else
        MaxAxisFieldOfView = CurrentCamera.MaxAxisFieldOfView
        FieldOfView = CurrentCamera.FieldOfView
    end
    if typeof(a1) == "number" then
        return a1 / FieldOfView * ViewportSize.Y
    end
    return a1 / Vector2.new(MaxAxisFieldOfView, FieldOfView) * ViewportSize
end

local function shouldShowCrosshair(a1) -- Line: 75 -- upvalues: u69 (ref)
    local ShowCrosshair = a1.Properties.ShowCrosshair
    local Parent = u69.Parent
    return ShowCrosshair and not Parent.TeamSelection.Visible and not Parent.Leaderboard.Visible and not Parent.EndScreen.Visible and not Parent.BuyMenu.Visible and not a1.IsAiming
end

local function calculateBloomScaleFromSpread(a1) -- Line: 89 -- upvalues: CurrentCamera (val) -- types: a1: number
    local FieldOfView, MaxAxisFieldOfView
    local v1 = math.clamp(a1 / 2, 0, 30)
    local ViewportSize = CurrentCamera.ViewportSize
    if not (ViewportSize.Y < ViewportSize.X) then
        MaxAxisFieldOfView = CurrentCamera.FieldOfView
        FieldOfView = CurrentCamera.MaxAxisFieldOfView
    else
        MaxAxisFieldOfView = CurrentCamera.MaxAxisFieldOfView
        FieldOfView = CurrentCamera.FieldOfView
    end
    local v2 = if typeof(v1) ~= "number" then v1 / Vector2.new(MaxAxisFieldOfView, FieldOfView) * ViewportSize else v1 / FieldOfView * ViewportSize.Y
    return v2 / 15 + 1
end

local function getCrosshairDisplayState(a1) -- Line: 95
    if a1 and a1.getCrosshairDisplayState then
        return a1:getCrosshairDisplayState()
    end
    return nil
end

local function getDisplayedOuterSpread(a1, a2) -- Line: 103
    if a2 and type(a2.OuterSpread) == "number" then
        return a2.OuterSpread
    end
    if not a1.getSpread then
        return 0
    end
    return a1:getSpread() or 0
end

local function getDynamicSpreadPixels(a1) -- Line: 115 -- types: a1: number
    return (math.max(0, (a1 - 1) * 15))
end

local function getConfiguredGapPixels(a1) -- Line: 119 -- upvalues: Settings (ref) -- types: a1: number?
    return (a1 or Settings.Gap) * 5 / 5
end

local function getRestingGapPixels(a1) -- Line: 123 -- upvalues: Settings (ref)
    local v1 = (a1 and a1.Gap or Settings.Gap) * 5 / 5
    if a1 and a1["Crosshair Style"] == "Classic" then
        return v1
    end
    return v1 + 5
end

local u79 = nil

local function getRecoilAssistScale() -- Line: 138 -- upvalues: u79 (ref), ReplicatedStorage (val)
    if not u79 then
        local success, result = pcall(function() -- Line: 140 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Controllers.AimAssistController)
        end)
        if not success then
            return (Vector3.new(1, 1, 1))
        end
        u79 = result
    end
    return u79.GetRecoilAssistScale()
end

local function calculateRecoilOffset(a1) -- Line: 153
    -- upvalues: Settings (ref), CameraController (val), u79 (ref), ReplicatedStorage (val), CurrentCamera (val)
    if a1.Recoil and a1.Properties and a1.Properties.Recoil and Settings["Follow Recoil"] then
        local FieldOfView, MaxAxisFieldOfView, v1
        local v2 = 1 - a1.Properties.Recoil.CameraScale
        local v3 = CameraController.getWeaponKickRotation()
        local RotationValue = a1.Recoil.RotationValue
        if u79 then
            v1 = u79.GetRecoilAssistScale()
        else
            local success, result = pcall(function() -- Line: 140 -- upvalues: ReplicatedStorage (upval)
                return require(ReplicatedStorage.Controllers.AimAssistController)
            end)
            v1 = if success then result.GetRecoilAssistScale() else Vector3.new(1, 1, 1)
        end
        local v4 = RotationValue * v1
        v1 = Vector2.new(v4.Y - v3.Y, v4.X - v3.X) * 57.29577951308232
        local ViewportSize = CurrentCamera.ViewportSize
        if not (ViewportSize.Y < ViewportSize.X) then
            MaxAxisFieldOfView = CurrentCamera.FieldOfView
            FieldOfView = CurrentCamera.MaxAxisFieldOfView
        else
            MaxAxisFieldOfView = CurrentCamera.MaxAxisFieldOfView
            FieldOfView = CurrentCamera.FieldOfView
        end
        local v5 = if typeof(v1) ~= "number" then v1 / Vector2.new(MaxAxisFieldOfView, FieldOfView) * ViewportSize else v1 / FieldOfView * ViewportSize.Y
        local v6 = v5 * Vector2.new(CameraController.getAspectRatioStretch(), 1) * -v2 / CurrentCamera.ViewportSize
        return UDim2.fromScale(v6.X, v6.Y)
    end
    return UDim2.new()
end

local function updateAutomaticScope(a1, a2) -- Line: 188
    -- upvalues: CurrentCamera (val), CameraController (val)
    if a1.IsAiming and a1.Properties.AimingOptions == "AutomaticScope" then
        if not a1.getBaseSpread then
            return
        end
        local ScopeReticlePart = a1.Viewmodel.Bobble.ScopeReticlePart
        if not ScopeReticlePart then
            return
        end
        local v1 = a1:getBaseSpread() or 0
        local Frame = ScopeReticlePart.SurfaceGui.Frame.Frame
        local v2 = math.tan((math.rad(CurrentCamera.FieldOfView / 2))) * 2 * 0.15
        local ViewportSize = CurrentCamera.ViewportSize
        local v3 = ViewportSize.X / ViewportSize.Y / (CameraController.getAspectRatioStretch()) * v2 / 0.15
        local v4 = v2 / 0.15
        local v5 = math.clamp(v1, 0, 2) * 2
        Frame.Size = UDim2.fromScale(v5 + 2.5, v5 + 2.5)
        Frame.Position = (UDim2.fromScale(0.5, 0.5)) + UDim2.new(a2.X.Scale * v3, 0, a2.Y.Scale * v4, 0)
        return
    end
end

local function updateTickPositions(a1, a2, a3, a4) -- Line: 222
    -- upvalues: Settings (ref)
    if not a1 then
        return
    end
    local v1 = (a3 and a3.Gap or Settings.Gap) * 5 / 5
    local v2 = (if not a3 then v1 + 5 else if a3["Crosshair Style"] ~= "Classic" then v1 + 5 else v1) + (a4 or 0) + (a2 - 1) * 15
    a1.Right.Position = UDim2.new(0.5, v2, 0.5, 0)
    a1.Down.Position = UDim2.new(0.5, 0, 0.5, v2)
    a1.Left.Position = UDim2.new(0.5, -v2, 0.5, 0)
    a1.Up.Position = UDim2.new(0.5, 0, 0.5, -v2)
end

local function resetTickPositions(a1, a2) -- Line: 240 -- upvalues: updateTickPositions (val)
    updateTickPositions(a1, 1, a2)
end

local function applyTickVisuals(a1, a2, a3, a4, a5) -- Line: 244
    -- upvalues: u64 (val)
    local v1, v2, v3
    if not a1 then
        return
    end
    local v4, v5, v6, v7, v8 = a1, a2, a3, a4, a5
    for i, v in ipairs(u64) do
        v1 = v4:FindFirstChild(v)
        if v1 then
            v1.BackgroundColor3 = v5
            v1.BackgroundTransparency = 1 - v6
            v3 = false
            if v == "Up" then
                v3 = v7["T Style"]
            end
            v1.Visible = not v3
            v2 = 15 * (v7.Length / 5) * v8
            v3 = 2 * (v7.Thickness / 1)
            if v == "Up" then
                v1.Size = UDim2.new(0, v3, 0, v2)
            elseif v ~= "Down" then
                v1.Size = UDim2.new(0, v2, 0, v3)
            else
                v1.Size = UDim2.new(0, v3, 0, v2)
            end
            if not v7.Outline.Enabled then
                v1.BorderSizePixel = 0
            else
                v1.BorderSizePixel = v7.Outline.Value
                v1.BorderColor3 = Color3.new(0, 0, 0)
            end
        end
    end
end

local function hideTickFrames(a1) -- Line: 282 -- types: a1: userdata?
    if not a1 then
        return
    end
    for k, v in pairs(a1:GetChildren()) do
        if v:IsA("Frame") then
            v.Visible = false
        end
    end
end

function u0.ResetCrosshair() -- Line: 296
    -- upvalues: u69 (ref), Settings (ref), updateTickPositions (val), u70 (ref), InventoryController (val)
    if not u69 then
        return
    end
    u69.Position = UDim2.fromScale(0.5, 0.5)
    local v1 = Settings
    updateTickPositions(u69.Ticks, 1, v1)
    updateTickPositions(u70, 1, Settings)
    local v2 = InventoryController.getCurrentEquipped()
    if v2 and typeof(v2) == "table" then
        if v2.IsAiming and v2.Properties and v2.Properties.AimingOptions == "AutomaticScope" then
            local Viewmodel = v2.Viewmodel
            if Viewmodel and Viewmodel.Bobble then
                local ScopeReticlePart = Viewmodel.Bobble.ScopeReticlePart
                if ScopeReticlePart and ScopeReticlePart.SurfaceGui and ScopeReticlePart.SurfaceGui.Frame then
                    local Frame = ScopeReticlePart.SurfaceGui.Frame:FindFirstChild("Frame")
                    if Frame then
                        Frame.Position = UDim2.fromScale(0.5, 0.5)
                        Frame.Size = UDim2.fromScale(2.5, 2.5)
                    end
                end
            end
        end
        local Recoil = v2.Recoil
        if Recoil then
            Recoil.Value = Vector2.zero
            Recoil.RecoveryStartTime = 0
            Recoil.Time = 0
            Recoil.RotationValue = Vector3.new(0, 0, 0)
        end
        return
    end
end

function u0.UpdateCrosshair(a1) -- Line: 335
    -- upvalues: LocalPlayer (val), ReplicatedStorage (val), Settings (ref), DataController (val), u69 (ref)
    -- upvalues: hideTickFrames (val), u70 (ref), InventoryController (val), u63 (val), MarketplaceService (val)
    -- upvalues: applyTickVisuals (val), CurrentCamera (val), calculateRecoilOffset (val), updateAutomaticScope (val)
    -- upvalues: updateTickPositions (val)
    local Character, Dot_2, FieldOfView, FieldOfView_2, Gap, InnerSpread, MaxAxisFieldOfView, MaxAxisFieldOfView_2, Parent, ShowCrosshair, ViewportSize, ViewportSize_2, result, success, u192, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
    local v16 = LocalPlayer:GetAttribute("IsSpectating") == true
    local v17 = false
    local v18 = nil
    if v16 then
        local v19 = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance()
        if v19
            and not v19.IsBot
            and Settings["Show Player Crosshairs"] == true
            and (DataController.Get(v19.Player, "Settings.Game.Crosshair")) then
            v17 = true
        end
        if v19 and v19.PerspectiveState == "First-Person" and v19.CurrentEquipped then
            local Name = v19.CurrentEquipped.Name
            local v20 = true
            if Name ~= "AWP" then
                v20 = Name == "SSG 08"
            end
            v14 = true
            if Name ~= "AUG" then
                v14 = Name == "SG 553"
            end
            v1 = 0 < (v19.Player:GetAttribute("ScopeIncrement") or 0)
            if v20 then
                u69.Visible = false
                hideTickFrames(u69.Ticks)
                hideTickFrames(u70)
                if u69.Dot then
                    u69.Dot.Visible = false
                end
                if u69.Crosshair then
                    u69.Crosshair.Visible = false
                end
                return
            end
            if v14 and v1 then
                u69.Visible = false
                hideTickFrames(u69.Ticks)
                hideTickFrames(u70)
                if u69.Dot then
                    u69.Dot.Visible = false
                end
                if u69.Crosshair then
                    u69.Crosshair.Visible = false
                end
                return
            end
            v2 = v17 and v18 or Settings
            v3 = v2["Crosshair Style"] == "Image"
            if u69.Ticks then
                u69.Ticks.Visible = not v3
                for k2, i in pairs(u69.Ticks:GetChildren()) do
                    if i:IsA("Frame") then
                        i.Visible = true
                    end
                end
            end
            if u69.Dot then
                u69.Dot.Visible = not v3 and v2["Center Dot"]
            end
            if u69.Crosshair then
                u69.Crosshair.Visible = v3
            end
            Character = LocalPlayer.Character
            v13 = InventoryController.getCurrentEquipped()
            if v16 and not v13 then
                v13 = {IsAiming = false, Properties = {ShowCrosshair = true, AimingOptions = "None"}}
            end
            if v16 then
                if not v17 then
                    u192 = Settings
                else
                    u192 = v18
                    if not u192 then
                        u192 = Settings
                    end
                end
                v14 = u192.Alpha.Enabled and u192.Alpha.Value / 255 or 1
                v15 = Color3.fromRGB(u192.Red, u192.Green, u192.Blue)
                v1 = if u192["Crosshair Style"] ~= "Classic" then nil else if not v13 then nil else if v13.getCrosshairDisplayState then v13:getCrosshairDisplayState() else nil
                v3 = not (u192["Crosshair Style"] == "Image")
                v4 = false
                Dot_2 = u69.Dot
                v6 = not v2 and u192["Center Dot"]
                Dot_2.Visible = v6
                u69.Crosshair.Visible = v2
                if not v2 then
                    v5 = v14 * 1
                    v6 = v14 * 0.5
                    applyTickVisuals(
                        u69.Ticks,
                        v15,
                        if u192["Crosshair Style"] ~= "Classic" then v14 else v6,
                        u192,
                        if u192["Crosshair Style"] ~= "Classic" then 1 else 0.35
                    )
                    applyTickVisuals(u70, v15, v5, u192, 0.65)
                    if u69.Dot and u192["Center Dot"] then
                        u69.Dot.BackgroundColor3 = v15
                        u69.Dot.BackgroundTransparency = 1 - v14
                        if not u192.Outline.Enabled then
                            u69.Dot.BorderSizePixel = 0
                        else
                            u69.Dot.BorderSizePixel = u192.Outline.Value
                            u69.Dot.BorderColor3 = Color3.new(0, 0, 0)
                        end
                    end
                else
                    v5 = "rbxassetid://" .. tostring(u192["Crosshair Image"])
                    success, result = pcall(function() -- Line: 450 -- upvalues: u63 (upval), u192 (val), MarketplaceService (upval)
                        return u63[u192["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u192["Crosshair Image"]), Enum.InfoType.Asset)
                    end)
                    if success then
                        u63[u192["Crosshair Image"]] = result
                        if result.AssetTypeId == 13 then
                            v5 = ("https://www.roblox.com/asset-thumbnail/image?assetId=%*&width=420&height=420&format=png"):format(u192["Crosshair Image"])
                        end
                    end
                    u69.Crosshair.Image = v5
                    u69.Crosshair.ImageColor3 = v15
                    u69.Crosshair.ImageTransparency = 1 - v14
                end
                v5 = u69
                ShowCrosshair = v13.Properties.ShowCrosshair
                Parent = u69.Parent
                v5.Visible = ShowCrosshair and not Parent.TeamSelection.Visible and not Parent.Leaderboard.Visible and not Parent.EndScreen.Visible and not Parent.BuyMenu.Visible and not v13.IsAiming
                v5 = UDim2.new()
                v6 = 1
                if u69.Visible or v13.Properties.AimingOptions == "AutomaticScope" then
                    if u192["Crosshair Style"] == "Classic" then
                        v7 = math.clamp(
                            (if not v1 then v13.getSpread and v13:getSpread() or 0 else if type(v1.OuterSpread) ~= "number" then v13.getSpread and v13:getSpread() or 0 else v1.OuterSpread) / 2,
                            0,
                            30
                        )
                        ViewportSize = CurrentCamera.ViewportSize
                        if not (ViewportSize.Y < ViewportSize.X) then
                            MaxAxisFieldOfView = CurrentCamera.FieldOfView
                            FieldOfView = CurrentCamera.MaxAxisFieldOfView
                        else
                            MaxAxisFieldOfView = CurrentCamera.MaxAxisFieldOfView
                            FieldOfView = CurrentCamera.FieldOfView
                        end
                        v8 = if typeof(v7) ~= "number" then v7 / Vector2.new(MaxAxisFieldOfView, FieldOfView) * ViewportSize else v7 / FieldOfView * ViewportSize.Y
                        v6 = v8 / 15 + 1
                    end
                    v5 = calculateRecoilOffset(v13)
                end
                updateAutomaticScope(v13, v5)
                u69.Position = UDim2.fromScale(0.5, 0.5) + v5
                if not v2 then
                    if not (u192["Crosshair Style"] == "Classic") then
                        v3 = true
                        updateTickPositions(u69.Ticks, v6, u192)
                        if u70 then
                            updateTickPositions(u70, 1, u192)
                        end
                    else
                        v7 = math.max(0, (v6 - 1) * 15)
                        InnerSpread = v1 and v1.InnerSpread
                        if type(InnerSpread) ~= "number" then
                            v9 = math.min(v7, 7)
                        else
                            v11 = math.clamp(InnerSpread / 2, 0, 30)
                            ViewportSize_2 = CurrentCamera.ViewportSize
                            if not (ViewportSize_2.Y < ViewportSize_2.X) then
                                MaxAxisFieldOfView_2 = CurrentCamera.FieldOfView
                                FieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                            else
                                MaxAxisFieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                                FieldOfView_2 = CurrentCamera.FieldOfView
                            end
                            v9 = math.max(
                                0,
                                ((if typeof(v11) ~= "number" then v11 / Vector2.new(MaxAxisFieldOfView_2, FieldOfView_2) * ViewportSize_2 else v11 / FieldOfView_2 * ViewportSize_2.Y) / 15 + 1 - 1) * 15
                            )
                        end
                        Gap = u192 and u192.Gap
                        v11 = (Gap or Settings.Gap) * 5 / 5
                        v10 = if not u192 then v11 + 5 else if u192["Crosshair Style"] ~= "Classic" then v11 + 5 else v11
                        v11 = u192["Center Dot"] and v10 + v9 <= 0
                        v12 = u192["Center Dot"] and v10 + v7 <= 0
                        v4 = not v11
                        if u70 and not v11 then
                            updateTickPositions(u70, v9 / 15 + 1, u192)
                        end
                        if not v12 then
                            v3 = true
                            updateTickPositions(u69.Ticks, v7 / 15 + 1, u192)
                        else
                            v3 = false
                            updateTickPositions(u69.Ticks, 1, u192)
                        end
                    end
                end
                u69.Ticks.Visible = v3
                if u70 then
                    u70.Visible = v4
                end
                return
            end
            if Character and v13 then
                if not v17 then
                    u192 = Settings
                else
                    u192 = v18
                    if not u192 then
                        u192 = Settings
                    end
                end
                v14 = u192.Alpha.Enabled and u192.Alpha.Value / 255 or 1
                v15 = Color3.fromRGB(u192.Red, u192.Green, u192.Blue)
                v1 = if u192["Crosshair Style"] ~= "Classic" then nil else if not v13 then nil else if v13.getCrosshairDisplayState then v13:getCrosshairDisplayState() else nil
                v3 = not (u192["Crosshair Style"] == "Image")
                v4 = false
                Dot_2 = u69.Dot
                v6 = not v2 and u192["Center Dot"]
                Dot_2.Visible = v6
                u69.Crosshair.Visible = v2
                if not v2 then
                    v5 = v14 * 1
                    v6 = v14 * 0.5
                    applyTickVisuals(
                        u69.Ticks,
                        v15,
                        if u192["Crosshair Style"] ~= "Classic" then v14 else v6,
                        u192,
                        if u192["Crosshair Style"] ~= "Classic" then 1 else 0.35
                    )
                    applyTickVisuals(u70, v15, v5, u192, 0.65)
                    if u69.Dot and u192["Center Dot"] then
                        u69.Dot.BackgroundColor3 = v15
                        u69.Dot.BackgroundTransparency = 1 - v14
                        if not u192.Outline.Enabled then
                            u69.Dot.BorderSizePixel = 0
                        else
                            u69.Dot.BorderSizePixel = u192.Outline.Value
                            u69.Dot.BorderColor3 = Color3.new(0, 0, 0)
                        end
                    end
                else
                    v5 = "rbxassetid://" .. tostring(u192["Crosshair Image"])
                    success, result = pcall(function() -- Line: 450 -- upvalues: u63 (upval), u192 (val), MarketplaceService (upval)
                        return u63[u192["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u192["Crosshair Image"]), Enum.InfoType.Asset)
                    end)
                    if success then
                        u63[u192["Crosshair Image"]] = result
                        if result.AssetTypeId == 13 then
                            v5 = ("https://www.roblox.com/asset-thumbnail/image?assetId=%*&width=420&height=420&format=png"):format(u192["Crosshair Image"])
                        end
                    end
                    u69.Crosshair.Image = v5
                    u69.Crosshair.ImageColor3 = v15
                    u69.Crosshair.ImageTransparency = 1 - v14
                end
                v5 = u69
                ShowCrosshair = v13.Properties.ShowCrosshair
                Parent = u69.Parent
                v5.Visible = ShowCrosshair and not Parent.TeamSelection.Visible and not Parent.Leaderboard.Visible and not Parent.EndScreen.Visible and not Parent.BuyMenu.Visible and not v13.IsAiming
                v5 = UDim2.new()
                v6 = 1
                if u69.Visible or v13.Properties.AimingOptions == "AutomaticScope" then
                    if u192["Crosshair Style"] == "Classic" then
                        v7 = math.clamp(
                            (if not v1 then v13.getSpread and v13:getSpread() or 0 else if type(v1.OuterSpread) ~= "number" then v13.getSpread and v13:getSpread() or 0 else v1.OuterSpread) / 2,
                            0,
                            30
                        )
                        ViewportSize = CurrentCamera.ViewportSize
                        if not (ViewportSize.Y < ViewportSize.X) then
                            MaxAxisFieldOfView = CurrentCamera.FieldOfView
                            FieldOfView = CurrentCamera.MaxAxisFieldOfView
                        else
                            MaxAxisFieldOfView = CurrentCamera.MaxAxisFieldOfView
                            FieldOfView = CurrentCamera.FieldOfView
                        end
                        v8 = if typeof(v7) ~= "number" then v7 / Vector2.new(MaxAxisFieldOfView, FieldOfView) * ViewportSize else v7 / FieldOfView * ViewportSize.Y
                        v6 = v8 / 15 + 1
                    end
                    v5 = calculateRecoilOffset(v13)
                end
                updateAutomaticScope(v13, v5)
                u69.Position = UDim2.fromScale(0.5, 0.5) + v5
                if not v2 then
                    if not (u192["Crosshair Style"] == "Classic") then
                        v3 = true
                        updateTickPositions(u69.Ticks, v6, u192)
                        if u70 then
                            updateTickPositions(u70, 1, u192)
                        end
                    else
                        v7 = math.max(0, (v6 - 1) * 15)
                        InnerSpread = v1 and v1.InnerSpread
                        if type(InnerSpread) ~= "number" then
                            v9 = math.min(v7, 7)
                        else
                            v11 = math.clamp(InnerSpread / 2, 0, 30)
                            ViewportSize_2 = CurrentCamera.ViewportSize
                            if not (ViewportSize_2.Y < ViewportSize_2.X) then
                                MaxAxisFieldOfView_2 = CurrentCamera.FieldOfView
                                FieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                            else
                                MaxAxisFieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                                FieldOfView_2 = CurrentCamera.FieldOfView
                            end
                            v9 = math.max(
                                0,
                                ((if typeof(v11) ~= "number" then v11 / Vector2.new(MaxAxisFieldOfView_2, FieldOfView_2) * ViewportSize_2 else v11 / FieldOfView_2 * ViewportSize_2.Y) / 15 + 1 - 1) * 15
                            )
                        end
                        Gap = u192 and u192.Gap
                        v11 = (Gap or Settings.Gap) * 5 / 5
                        v10 = if not u192 then v11 + 5 else if u192["Crosshair Style"] ~= "Classic" then v11 + 5 else v11
                        v11 = u192["Center Dot"] and v10 + v9 <= 0
                        v12 = u192["Center Dot"] and v10 + v7 <= 0
                        v4 = not v11
                        if u70 and not v11 then
                            updateTickPositions(u70, v9 / 15 + 1, u192)
                        end
                        if not v12 then
                            v3 = true
                            updateTickPositions(u69.Ticks, v7 / 15 + 1, u192)
                        else
                            v3 = false
                            updateTickPositions(u69.Ticks, 1, u192)
                        end
                    end
                end
                u69.Ticks.Visible = v3
                if u70 then
                    u70.Visible = v4
                end
                return
            end
            return
        end
        if v19 and v19.PerspectiveState == "First-Person" then
            u69.Visible = true
        end
    end
    Character = LocalPlayer.Character
    v13 = InventoryController.getCurrentEquipped()
    if v16 and not v13 then
        v13 = {IsAiming = false, Properties = {ShowCrosshair = true, AimingOptions = "None"}}
    end
    if v16 then
        if not v17 then
            u192 = Settings
        else
            u192 = v18
            if not u192 then
                u192 = Settings
            end
        end
        v14 = u192.Alpha.Enabled and u192.Alpha.Value / 255 or 1
        v15 = Color3.fromRGB(u192.Red, u192.Green, u192.Blue)
        v1 = if u192["Crosshair Style"] ~= "Classic" then nil else if not v13 then nil else if v13.getCrosshairDisplayState then v13:getCrosshairDisplayState() else nil
        v3 = not (u192["Crosshair Style"] == "Image")
        v4 = false
        Dot_2 = u69.Dot
        v6 = not v2 and u192["Center Dot"]
        Dot_2.Visible = v6
        u69.Crosshair.Visible = v2
        if not v2 then
            v5 = v14 * 1
            v6 = v14 * 0.5
            applyTickVisuals(
                u69.Ticks,
                v15,
                if u192["Crosshair Style"] ~= "Classic" then v14 else v6,
                u192,
                if u192["Crosshair Style"] ~= "Classic" then 1 else 0.35
            )
            applyTickVisuals(u70, v15, v5, u192, 0.65)
            if u69.Dot and u192["Center Dot"] then
                u69.Dot.BackgroundColor3 = v15
                u69.Dot.BackgroundTransparency = 1 - v14
                if not u192.Outline.Enabled then
                    u69.Dot.BorderSizePixel = 0
                else
                    u69.Dot.BorderSizePixel = u192.Outline.Value
                    u69.Dot.BorderColor3 = Color3.new(0, 0, 0)
                end
            end
        else
            v5 = "rbxassetid://" .. tostring(u192["Crosshair Image"])
            success, result = pcall(function() -- Line: 450 -- upvalues: u63 (upval), u192 (val), MarketplaceService (upval)
                return u63[u192["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u192["Crosshair Image"]), Enum.InfoType.Asset)
            end)
            if success then
                u63[u192["Crosshair Image"]] = result
                if result.AssetTypeId == 13 then
                    v5 = ("https://www.roblox.com/asset-thumbnail/image?assetId=%*&width=420&height=420&format=png"):format(u192["Crosshair Image"])
                end
            end
            u69.Crosshair.Image = v5
            u69.Crosshair.ImageColor3 = v15
            u69.Crosshair.ImageTransparency = 1 - v14
        end
        v5 = u69
        ShowCrosshair = v13.Properties.ShowCrosshair
        Parent = u69.Parent
        v5.Visible = ShowCrosshair and not Parent.TeamSelection.Visible and not Parent.Leaderboard.Visible and not Parent.EndScreen.Visible and not Parent.BuyMenu.Visible and not v13.IsAiming
        v5 = UDim2.new()
        v6 = 1
        if u69.Visible or v13.Properties.AimingOptions == "AutomaticScope" then
            if u192["Crosshair Style"] == "Classic" then
                v7 = math.clamp(
                    (if not v1 then v13.getSpread and v13:getSpread() or 0 else if type(v1.OuterSpread) ~= "number" then v13.getSpread and v13:getSpread() or 0 else v1.OuterSpread) / 2,
                    0,
                    30
                )
                ViewportSize = CurrentCamera.ViewportSize
                if not (ViewportSize.Y < ViewportSize.X) then
                    MaxAxisFieldOfView = CurrentCamera.FieldOfView
                    FieldOfView = CurrentCamera.MaxAxisFieldOfView
                else
                    MaxAxisFieldOfView = CurrentCamera.MaxAxisFieldOfView
                    FieldOfView = CurrentCamera.FieldOfView
                end
                v8 = if typeof(v7) ~= "number" then v7 / Vector2.new(MaxAxisFieldOfView, FieldOfView) * ViewportSize else v7 / FieldOfView * ViewportSize.Y
                v6 = v8 / 15 + 1
            end
            v5 = calculateRecoilOffset(v13)
        end
        updateAutomaticScope(v13, v5)
        u69.Position = UDim2.fromScale(0.5, 0.5) + v5
        if not v2 then
            if not (u192["Crosshair Style"] == "Classic") then
                v3 = true
                updateTickPositions(u69.Ticks, v6, u192)
                if u70 then
                    updateTickPositions(u70, 1, u192)
                end
            else
                v7 = math.max(0, (v6 - 1) * 15)
                InnerSpread = v1 and v1.InnerSpread
                if type(InnerSpread) ~= "number" then
                    v9 = math.min(v7, 7)
                else
                    v11 = math.clamp(InnerSpread / 2, 0, 30)
                    ViewportSize_2 = CurrentCamera.ViewportSize
                    if not (ViewportSize_2.Y < ViewportSize_2.X) then
                        MaxAxisFieldOfView_2 = CurrentCamera.FieldOfView
                        FieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                    else
                        MaxAxisFieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                        FieldOfView_2 = CurrentCamera.FieldOfView
                    end
                    v9 = math.max(
                        0,
                        ((if typeof(v11) ~= "number" then v11 / Vector2.new(MaxAxisFieldOfView_2, FieldOfView_2) * ViewportSize_2 else v11 / FieldOfView_2 * ViewportSize_2.Y) / 15 + 1 - 1) * 15
                    )
                end
                Gap = u192 and u192.Gap
                v11 = (Gap or Settings.Gap) * 5 / 5
                v10 = if not u192 then v11 + 5 else if u192["Crosshair Style"] ~= "Classic" then v11 + 5 else v11
                v11 = u192["Center Dot"] and v10 + v9 <= 0
                v12 = u192["Center Dot"] and v10 + v7 <= 0
                v4 = not v11
                if u70 and not v11 then
                    updateTickPositions(u70, v9 / 15 + 1, u192)
                end
                if not v12 then
                    v3 = true
                    updateTickPositions(u69.Ticks, v7 / 15 + 1, u192)
                else
                    v3 = false
                    updateTickPositions(u69.Ticks, 1, u192)
                end
            end
        end
        u69.Ticks.Visible = v3
        if u70 then
            u70.Visible = v4
        end
        return
    end
    if Character and v13 then
        if not v17 then
            u192 = Settings
        else
            u192 = v18
            if not u192 then
                u192 = Settings
            end
        end
        v14 = u192.Alpha.Enabled and u192.Alpha.Value / 255 or 1
        v15 = Color3.fromRGB(u192.Red, u192.Green, u192.Blue)
        v1 = if u192["Crosshair Style"] ~= "Classic" then nil else if not v13 then nil else if v13.getCrosshairDisplayState then v13:getCrosshairDisplayState() else nil
        v3 = not (u192["Crosshair Style"] == "Image")
        v4 = false
        Dot_2 = u69.Dot
        v6 = not v2 and u192["Center Dot"]
        Dot_2.Visible = v6
        u69.Crosshair.Visible = v2
        if not v2 then
            v5 = v14 * 1
            v6 = v14 * 0.5
            applyTickVisuals(
                u69.Ticks,
                v15,
                if u192["Crosshair Style"] ~= "Classic" then v14 else v6,
                u192,
                if u192["Crosshair Style"] ~= "Classic" then 1 else 0.35
            )
            applyTickVisuals(u70, v15, v5, u192, 0.65)
            if u69.Dot and u192["Center Dot"] then
                u69.Dot.BackgroundColor3 = v15
                u69.Dot.BackgroundTransparency = 1 - v14
                if not u192.Outline.Enabled then
                    u69.Dot.BorderSizePixel = 0
                else
                    u69.Dot.BorderSizePixel = u192.Outline.Value
                    u69.Dot.BorderColor3 = Color3.new(0, 0, 0)
                end
            end
        else
            v5 = "rbxassetid://" .. tostring(u192["Crosshair Image"])
            success, result = pcall(function() -- Line: 450 -- upvalues: u63 (upval), u192 (val), MarketplaceService (upval)
                return u63[u192["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u192["Crosshair Image"]), Enum.InfoType.Asset)
            end)
            if success then
                u63[u192["Crosshair Image"]] = result
                if result.AssetTypeId == 13 then
                    v5 = ("https://www.roblox.com/asset-thumbnail/image?assetId=%*&width=420&height=420&format=png"):format(u192["Crosshair Image"])
                end
            end
            u69.Crosshair.Image = v5
            u69.Crosshair.ImageColor3 = v15
            u69.Crosshair.ImageTransparency = 1 - v14
        end
        v5 = u69
        ShowCrosshair = v13.Properties.ShowCrosshair
        Parent = u69.Parent
        v5.Visible = ShowCrosshair and not Parent.TeamSelection.Visible and not Parent.Leaderboard.Visible and not Parent.EndScreen.Visible and not Parent.BuyMenu.Visible and not v13.IsAiming
        v5 = UDim2.new()
        v6 = 1
        if u69.Visible or v13.Properties.AimingOptions == "AutomaticScope" then
            if u192["Crosshair Style"] == "Classic" then
                v7 = math.clamp(
                    (if not v1 then v13.getSpread and v13:getSpread() or 0 else if type(v1.OuterSpread) ~= "number" then v13.getSpread and v13:getSpread() or 0 else v1.OuterSpread) / 2,
                    0,
                    30
                )
                ViewportSize = CurrentCamera.ViewportSize
                if not (ViewportSize.Y < ViewportSize.X) then
                    MaxAxisFieldOfView = CurrentCamera.FieldOfView
                    FieldOfView = CurrentCamera.MaxAxisFieldOfView
                else
                    MaxAxisFieldOfView = CurrentCamera.MaxAxisFieldOfView
                    FieldOfView = CurrentCamera.FieldOfView
                end
                v8 = if typeof(v7) ~= "number" then v7 / Vector2.new(MaxAxisFieldOfView, FieldOfView) * ViewportSize else v7 / FieldOfView * ViewportSize.Y
                v6 = v8 / 15 + 1
            end
            v5 = calculateRecoilOffset(v13)
        end
        updateAutomaticScope(v13, v5)
        u69.Position = UDim2.fromScale(0.5, 0.5) + v5
        if not v2 then
            if not (u192["Crosshair Style"] == "Classic") then
                v3 = true
                updateTickPositions(u69.Ticks, v6, u192)
                if u70 then
                    updateTickPositions(u70, 1, u192)
                end
            else
                v7 = math.max(0, (v6 - 1) * 15)
                InnerSpread = v1 and v1.InnerSpread
                if type(InnerSpread) ~= "number" then
                    v9 = math.min(v7, 7)
                else
                    v11 = math.clamp(InnerSpread / 2, 0, 30)
                    ViewportSize_2 = CurrentCamera.ViewportSize
                    if not (ViewportSize_2.Y < ViewportSize_2.X) then
                        MaxAxisFieldOfView_2 = CurrentCamera.FieldOfView
                        FieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                    else
                        MaxAxisFieldOfView_2 = CurrentCamera.MaxAxisFieldOfView
                        FieldOfView_2 = CurrentCamera.FieldOfView
                    end
                    v9 = math.max(
                        0,
                        ((if typeof(v11) ~= "number" then v11 / Vector2.new(MaxAxisFieldOfView_2, FieldOfView_2) * ViewportSize_2 else v11 / FieldOfView_2 * ViewportSize_2.Y) / 15 + 1 - 1) * 15
                    )
                end
                Gap = u192 and u192.Gap
                v11 = (Gap or Settings.Gap) * 5 / 5
                v10 = if not u192 then v11 + 5 else if u192["Crosshair Style"] ~= "Classic" then v11 + 5 else v11
                v11 = u192["Center Dot"] and v10 + v9 <= 0
                v12 = u192["Center Dot"] and v10 + v7 <= 0
                v4 = not v11
                if u70 and not v11 then
                    updateTickPositions(u70, v9 / 15 + 1, u192)
                end
                if not v12 then
                    v3 = true
                    updateTickPositions(u69.Ticks, v7 / 15 + 1, u192)
                else
                    v3 = false
                    updateTickPositions(u69.Ticks, 1, u192)
                end
            end
        end
        u69.Ticks.Visible = v3
        if u70 then
            u70.Visible = v4
        end
        return
    end
end

function u0.Initialize(a1, a2) -- Line: 563
    -- upvalues: u69 (ref), u70 (ref), DataController (val), LocalPlayer (val), Settings (ref), u0 (val)
    -- upvalues: RunServiceController (val), Remotes (val)
    u69 = a2
    u70 = u69:FindFirstChild("InnerTicks")
    if not u70 and u69.Ticks then
        local v1 = u69.Ticks:Clone()
        v1.Name = "InnerTicks"
        v1.Visible = false
        v1.Parent = u69
        u70 = v1
    end
    DataController.CreateListener(LocalPlayer, "Settings.Game.Crosshair", function(a1) -- Line: 576 -- upvalues: Settings (upval), u0 (upval)
        Settings = a1
        task.delay(0.1, function() -- Line: 578 -- upvalues: u0 (upval)
            u0.UpdateCrosshair(0)
        end)
    end)
    RunServiceController.BindToRenderStep("UI.Crosshair.Update", u0.UpdateCrosshair)
    Remotes.Character.CharacterDied.Listen(u0.ResetCrosshair)
end

return u0