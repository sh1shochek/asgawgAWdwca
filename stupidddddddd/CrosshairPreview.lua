-- ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.CrosshairPreview
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.CrosshairPreview
-- Decompile time: 6.65 ms

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
require(script.Parent.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local u36 = {}
local u37 = 1
local u38 = {"rbxassetid://99157237752211", "rbxassetid://123264229164215", "rbxassetid://93651340552187"}

local function applyOutline(a1, a2, a3) -- Line: 36 -- types: a1: userdata, a2: boolean, a3: number
    if not a2 then
        a1.BorderSizePixel = 0
        return
    end
    a1.BorderSizePixel = a3
    a1.BorderColor3 = Color3.new(0, 0, 0)
end

local function updateCrosshairPreview(a1, a2, a3) -- Line: 45
    -- upvalues: u36 (val), MarketplaceService (val)
    if not a2 or not a1.Visible then
        return
    end
    if not a1:IsDescendantOf(game) then
        return
    end
    local v1 = a3 or 1
    local Alpha = a2.Alpha
    local v2 = 1
    if Alpha and type(Alpha) == "table" and Alpha.Enabled and type(Alpha.Value) == "number" then
        v2 = Alpha.Value / 255
    end
    local v3 = a2.Red or 0
    local v4 = a2.Green or 255
    local v5 = a2.Blue or 0
    local fromRGB = Color3.fromRGB
    local v6 = tonumber(v4) or 255
    local v7 = fromRGB(tonumber(v3) or 0, v6, tonumber(v5) or 0)
    local v8 = a2["Crosshair Style"]
    v6 = v8 == "Image"
    local v9 = v8 == "Classic"
    local Ticks = a1:FindFirstChild("Ticks")
    local Dot = a1:FindFirstChild("Dot")
    local Crosshair = a1:FindFirstChild("Crosshair")
    if Ticks and Dot and Crosshair then
        local v10, v11, v12, v13, v14
        Ticks.Visible = not v6
        local v15 = not v6 and a2["Center Dot"] == true
        Dot.Visible = v15
        Crosshair.Visible = v6
        if v6 then
            v15 = "rbxassetid://" .. tostring(a2["Crosshair Image"])
            local success, result = pcall(function() -- Line: 104 -- upvalues: u36 (upval), a2 (val), MarketplaceService (upval)
                return u36[a2["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(a2["Crosshair Image"]), Enum.InfoType.Asset)
            end)
            if success then
                u36[a2["Crosshair Image"]] = result
                if result.AssetTypeId == 13 then
                    v15 = ("https://www.roblox.com/asset-thumbnail/image?assetId=%*&width=420&height=420&format=png"):format(a2["Crosshair Image"])
                end
            end
            local v16 = v15
            Crosshair.Image = not (type(v16) ~= "string") and v16 or "rbxassetid://00000000"
            Crosshair.ImageColor3 = v7
            Crosshair.ImageTransparency = 1 - v2
            return
        end
        local Outline = a2.Outline
        local v17 = false
        local v18 = 1
        if Outline and type(Outline) == "table" then
            v17 = Outline.Enabled == true
            v18 = tonumber(Outline.Value) or 1
        end
        for i, v in ipairs({"Up", "Down", "Left", "Right"}) do
            v10 = Ticks:FindFirstChild(v)
            if v10 then
                v10.BackgroundColor3 = v7
                v10.BackgroundTransparency = 1 - v2
                v10.Visible = true
                v11 = tonumber(a2.Length) or 5
                v12 = tonumber(a2.Thickness) or 1
                v13 = 15 * (v11 / 5)
                v14 = 2 * (v12 / 1)
                if v == "Up" then
                    v10.Size = UDim2.new(0, v14, 0, v13)
                elseif v ~= "Down" then
                    v10.Size = UDim2.new(0, v13, 0, v14)
                else
                    v10.Size = UDim2.new(0, v14, 0, v13)
                end
                if not v17 then
                    v10.BorderSizePixel = 0
                else
                    v10.BorderSizePixel = v18
                    v10.BorderColor3 = Color3.new(0, 0, 0)
                end
            end
        end
        local Up = Ticks:FindFirstChild("Up")
        if Up then
            Up.Visible = not (a2["T Style"] == true)
        end
        if Dot and a2["Center Dot"] == true then
            Dot.BackgroundColor3 = v7
            Dot.BackgroundTransparency = 1 - v2
            if not v17 then
                Dot.BorderSizePixel = 0
            else
                Dot.BorderSizePixel = v18
                Dot.BorderColor3 = Color3.new(0, 0, 0)
            end
        end
        local v19 = 5 + (tonumber(a2.Gap) or -1) * 5 / 5
        if v9 then
            v19 = v19 * v1
        end
        local Right = Ticks:FindFirstChild("Right")
        local Down = Ticks:FindFirstChild("Down")
        local Left = Ticks:FindFirstChild("Left")
        local Up_2 = Ticks:FindFirstChild("Up")
        if Right then
            Right.Position = UDim2.new(0.5, v19, 0.5, 0)
        end
        if Down then
            Down.Position = UDim2.new(0.5, 0, 0.5, v19)
        end
        if Left then
            Left.Position = UDim2.new(0.5, -v19, 0.5, 0)
        end
        if Up_2 then
            Up_2.Position = UDim2.new(0.5, 0, 0.5, -v19)
        end
        return
    end
end

return function(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 195
    -- upvalues: ActivateButton (val), u37 (ref), u38 (val), ReplicatedStorage (val), Janitor (val), LocalPlayer (val)
    -- upvalues: updateCrosshairPreview (val), RunServiceController (val)
    local v1
    a3.LayoutOrder = a2
    ActivateButton(a3.Left)
    ActivateButton(a3.Right)
    local u14 = {}

    local function swapToIndex() -- Line: 212 -- upvalues: u14 (val), u37 (upval), a3 (val), u38 (upval)
        local v1
        local v2 = nil
        local v3 = nil
        for i, j in u14, v2, v3 do
            v1 = not (i ~= u37) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(38, 38, 38)
            j.BackgroundColor3 = v1
        end
        a3.ImageLabel.Image = u38[u37]
    end

    for i, j in u38 do
        v1 = ReplicatedStorage.Assets.UI.Settings.Dot:Clone()
        v1.LayoutOrder = i
        v1.Parent = a3.Switch
        u14[i] = v1
        ActivateButton(v1)
        v1.MouseButton1Click:Connect(function() -- Line: 226 -- upvalues: u37 (upval), i (val), swapToIndex (val)
            u37 = i
            swapToIndex()
        end)
    end
    a3.Left.Selectable = true
    a3.Right.Selectable = true
    a3.Left.Active = true
    a3.Right.Active = true
    a3.Left.Activated:Connect(function() -- Line: 239 -- upvalues: u37 (upval), u38 (upval), swapToIndex (val)
        u37 = if not (u37 <= 1) then u37 - 1 else #u38
        swapToIndex()
    end)
    a3.Right.Activated:Connect(function() -- Line: 243 -- upvalues: u37 (upval), u38 (upval), swapToIndex (val)
        local v1 = u37
        u37 = if not (#u38 <= v1) then u37 + 1 else 1
        swapToIndex()
    end)
    swapToIndex()
    local u52 = Janitor.new()
    u52:Add(a3, "Destroy")
    local Crosshair = a3.Crosshair
    local u59 = 0
    local u60 = nil

    local function isPreviewVisible() -- Line: 260 -- upvalues: a3 (val), LocalPlayer (upval)
        local v1 = a3:FindFirstAncestorOfClass("ScrollingFrame")
        if v1 and v1:IsDescendantOf(LocalPlayer.PlayerGui) then
            local Parent = a3
            while Parent do
                if Parent == LocalPlayer.PlayerGui then
                    break
                end
                if Parent:IsA("GuiObject") and not Parent.Visible then
                    return false
                end
                Parent = Parent.Parent
            end
            return true
        end
        return false
    end

    local function updatePreviewStep(a1, a2) -- Line: 284
        -- upvalues: isPreviewVisible (val), u60 (ref), a5 (val), u59 (ref), updateCrosshairPreview (upval)
        -- upvalues: Crosshair (val)
        if not isPreviewVisible() then
            if u60 then
                u60:Disconnect()
                u60 = nil
            end
            return
        end
        local v1 = a5()
        if not v1 then
            return
        end
        local v2 = 1
        if v1["Crosshair Style"] ~= "Classic" then
            u59 = 0
        else
            u59 = u59 + a2
            v2 = math.max(math.sin(u59 * 3.141592653589793 * 2 * 0.25) * 2 + 1, 0.75)
        end
        updateCrosshairPreview(Crosshair, v1, v2)
    end

    a3.Parent = a1

    local function syncPreviewUpdate() -- Line: 315
        -- upvalues: isPreviewVisible (val), u60 (ref), RunServiceController (upval), a2 (val), updatePreviewStep (val)
        if not isPreviewVisible() then
            if u60 then
                u60:Disconnect()
                u60 = nil
            end
            return
        end
        if u60 then
            return
        end
        u60 = RunServiceController.BindToStepped(("UI.CrosshairPreview.%*"):format(a2), updatePreviewStep)
        updatePreviewStep(0, 0)
    end

    local u68 = {}

    local function refreshVisibilityConnections() -- Line: 338
        -- upvalues: u68 (val), a3 (val), LocalPlayer (upval), syncPreviewUpdate (val)
        for i, v in ipairs(u68) do
            v:Disconnect()
        end
        table.clear(u68)
        local Parent = a3
        while Parent do
            if Parent == LocalPlayer.PlayerGui then
                break
            end
            if Parent:IsA("GuiObject") then
                table.insert(u68, ((Parent:GetPropertyChangedSignal("Visible")):Connect(syncPreviewUpdate)))
            end
            Parent = Parent.Parent
        end
    end

    refreshVisibilityConnections()
    u52:Add(a3.AncestryChanged:Connect(function() -- Line: 352
        -- upvalues: refreshVisibilityConnections (val), isPreviewVisible (val), u60 (ref), RunServiceController (upval)
        -- upvalues: a2 (val), updatePreviewStep (val)
        refreshVisibilityConnections()
        if not isPreviewVisible() then
            if u60 then
                u60:Disconnect()
                u60 = nil
            end
            return
        end
        if u60 then
            return
        end
        u60 = RunServiceController.BindToStepped(("UI.CrosshairPreview.%*"):format(a2), updatePreviewStep)
        updatePreviewStep(0, 0)
    end), "Disconnect")
    u52:Add(function() -- Line: 331 -- upvalues: u68 (val)
        for i, v in ipairs(u68) do
            v:Disconnect()
        end
        table.clear(u68)
    end, true)
    u52:Add(function() -- Line: 277 -- upvalues: u60 (ref)
        if u60 then
            u60:Disconnect()
            u60 = nil
        end
    end, true)
    if not isPreviewVisible() then
        if u60 then
            u60:Disconnect()
        end
    elseif not u60 then
        local v2 = RunServiceController.BindToStepped(("UI.CrosshairPreview.%*"):format(a2), updatePreviewStep)
        updatePreviewStep(0, 0)
    end
    return function() -- Line: 361 -- upvalues: u52 (val)
        u52:Cleanup()
    end
end