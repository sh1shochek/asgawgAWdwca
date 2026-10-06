-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u1 = {};
local u2 = 1;
local u3 = { "rbxassetid://99157237752211", "rbxassetid://123264229164215", "rbxassetid://93651340552187" };

local function applyOutline(p4: userdata, p5: boolean, p6: number) -- Line: 36
    if not p5 then
        p4.BorderSizePixel = 0;

        return;
    end;

    p4.BorderSizePixel = p6;
    p4.BorderColor3 = Color3.new(0, 0, 0);
end;

local function updateCrosshairPreview(p7: userdata, u8: table, p9: number?) -- Line: 45
    -- upvalues: u1 (copy), MarketplaceService (copy)
    if not u8 then
        return;
    end;

    if not p7.Visible then
        return;
    end;

    if not p7:IsDescendantOf(game) then
        return;
    end;

    local v10 = p9 or 1;
    local Alpha = u8.Alpha;
    local v11 = not (Alpha and (type(Alpha) == "table" and (Alpha.Enabled and type(Alpha.Value) == "number"))) and 1 or Alpha.Value / 255;
    local v12 = u8.Green or 255;
    local v13 = u8.Blue or 0;
    local Color3_fromRGB_ret = Color3.fromRGB(tonumber(u8.Red or 0) or 0, tonumber(v12) or 255, tonumber(v13) or 0);
    local v14 = u8["Crosshair Style"];
    local v15 = v14 == "Image";
    local Ticks = p7:FindFirstChild("Ticks");
    local Dot = p7:FindFirstChild("Dot");
    local Crosshair = p7:FindFirstChild("Crosshair");

    if not (Ticks and (Dot and Crosshair)) then
        return;
    end;

    Ticks.Visible = not v15;
    Dot.Visible = not v15 and u8["Center Dot"] == true;
    Crosshair.Visible = v15;

    if v15 then
        local v16 = "rbxassetid://" .. tostring(u8["Crosshair Image"]);
        local success, result = pcall(function() -- Line: 104
            -- upvalues: u1 (ref), u8 (copy), MarketplaceService (ref)
            return u1[u8["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u8["Crosshair Image"]), Enum.InfoType.Asset);
        end);

        if success then
            u1[u8["Crosshair Image"]] = result;

            if result.AssetTypeId == 13 then
                v16 = `https://www.roblox.com/asset-thumbnail/image?assetId={u8["Crosshair Image"]}&width=420&height=420&format=png`;
            end;
        end;

        Crosshair.Image = type(v16) == "string" and v16 and v16 or "rbxassetid://00000000";
        Crosshair.ImageColor3 = Color3_fromRGB_ret;
        Crosshair.ImageTransparency = 1 - v11;

        return;
    end;

    local Outline = u8.Outline;
    local v17, v18;

    if Outline and type(Outline) == "table" then
        v17 = Outline.Enabled == true;
        v18 = tonumber(Outline.Value) or 1;
    else
        v17 = false;
        v18 = 1;
    end;

    for _, v in ipairs({ "Up", "Down", "Left", "Right" }) do
        local v19 = Ticks:FindFirstChild(v);

        if v19 then
            v19.BackgroundColor3 = Color3_fromRGB_ret;
            v19.BackgroundTransparency = 1 - v11;
            v19.Visible = true;
            local v20 = tonumber(u8.Length) or 5;
            local v21 = tonumber(u8.Thickness) or 1;
            local v22 = 15 * (v20 / 5);
            local v23 = 2 * (v21 / 1);

            if v == "Up" or v == "Down" then
                v19.Size = UDim2.new(0, v23, 0, v22);
            else
                v19.Size = UDim2.new(0, v22, 0, v23);
            end;

            if v17 then
                v19.BorderSizePixel = v18;
                v19.BorderColor3 = Color3.new(0, 0, 0);
            else
                v19.BorderSizePixel = 0;
            end;
        end;
    end;

    local Up = Ticks:FindFirstChild("Up");

    if Up then
        Up.Visible = u8["T Style"] ~= true;
    end;

    if Dot and u8["Center Dot"] == true then
        Dot.BackgroundColor3 = Color3_fromRGB_ret;
        Dot.BackgroundTransparency = 1 - v11;

        if v17 then
            Dot.BorderSizePixel = v18;
            Dot.BorderColor3 = Color3.new(0, 0, 0);
        else
            Dot.BorderSizePixel = 0;
        end;
    end;

    local v24 = 5 + (tonumber(u8.Gap) or -1) * 5 / 5;

    if v14 == "Classic" then
        v24 = v24 * v10;
    end;

    local Right = Ticks:FindFirstChild("Right");
    local Down = Ticks:FindFirstChild("Down");
    local Left = Ticks:FindFirstChild("Left");
    local Up2 = Ticks:FindFirstChild("Up");

    if Right then
        Right.Position = UDim2.new(0.5, v24, 0.5, 0);
    end;

    if Down then
        Down.Position = UDim2.new(0.5, 0, 0.5, v24);
    end;

    if Left then
        Left.Position = UDim2.new(0.5, -v24, 0.5, 0);
    end;

    if Up2 then
        Up2.Position = UDim2.new(0.5, 0, 0.5, -v24);
    end;
end;

return function(p25: userdata, u26: number, u27: any, p28: userdata, u29: function, p30: function, p31: function, p32: function) -- Line: 195
    -- upvalues: ActivateButton (copy), u2 (ref), u3 (copy), ReplicatedStorage (copy), Janitor (copy), LocalPlayer (copy), updateCrosshairPreview (copy), RunServiceController (copy)
    u27.LayoutOrder = u26;
    ActivateButton(u27.Left);
    ActivateButton(u27.Right);
    local u33 = {};

    local function swapToIndex() -- Line: 212
        -- upvalues: u33 (copy), u2 (ref), u27 (copy), u3 (ref)
        for i, v in u33 do
            v.BackgroundColor3 = i == u2 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(38, 38, 38);
        end;

        u27.ImageLabel.Image = u3[u2];
    end;

    for i, _ in u3 do
        local v34 = ReplicatedStorage.Assets.UI.Settings.Dot:Clone();
        v34.LayoutOrder = i;
        v34.Parent = u27.Switch;
        u33[i] = v34;
        ActivateButton(v34);
        v34.MouseButton1Click:Connect(function() -- Line: 226
            -- upvalues: u2 (ref), i (copy), swapToIndex (copy)
            u2 = i;
            swapToIndex();
        end);
    end;

    u27.Left.Selectable = true;
    u27.Right.Selectable = true;
    u27.Left.Active = true;
    u27.Right.Active = true;
    u27.Left.Activated:Connect(function() -- Line: 239
        -- upvalues: u2 (ref), u3 (ref), swapToIndex (copy)
        local v35;

        if u2 <= 1 then
            v35 = #u3;
        else
            v35 = u2 - 1;
        end;

        u2 = v35;
        swapToIndex();
    end);
    u27.Right.Activated:Connect(function() -- Line: 243
        -- upvalues: u2 (ref), u3 (ref), swapToIndex (copy)
        u2 = u2 >= #u3 and 1 or u2 + 1;
        swapToIndex();
    end);
    swapToIndex();
    local u36 = Janitor.new();
    u36:Add(u27, "Destroy");
    local Crosshair = u27.Crosshair;
    local u37 = 0;
    local u38 = nil;

    local function isPreviewVisible() -- Line: 260
        -- upvalues: u27 (copy), LocalPlayer (ref)
        local v39 = u27:FindFirstAncestorOfClass("ScrollingFrame");

        if not (v39 and v39:IsDescendantOf(LocalPlayer.PlayerGui)) then
            return false;
        end;

        local v40 = u27;

        while v40 and v40 ~= LocalPlayer.PlayerGui do
            if v40:IsA("GuiObject") and not v40.Visible then
                return false;
            end;

            v40 = v40.Parent;
        end;

        return true;
    end;

    local function stopPreviewUpdate() -- Line: 277
        -- upvalues: u38 (ref)
        if u38 then
            u38:Disconnect();
            u38 = nil;
        end;
    end;

    local function updatePreviewStep(p41: number, p42: number) -- Line: 284
        -- upvalues: isPreviewVisible (copy), u38 (ref), u29 (copy), u37 (ref), updateCrosshairPreview (ref), Crosshair (copy)
        if not isPreviewVisible() then
            if u38 then
                u38:Disconnect();
                u38 = nil;
            end;

            return;
        end;

        local v43 = u29();

        if not v43 then
            return;
        end;

        local v44 = 1;

        if v43["Crosshair Style"] == "Classic" then
            u37 = u37 + p42;
            local v45 = math.sin(u37 * 3.141592653589793 * 2 * 0.25) * 2 + 1;
            v44 = math.max(v45, 0.75);
        else
            u37 = 0;
        end;

        updateCrosshairPreview(Crosshair, v43, v44);
    end;

    u27.Parent = p25;

    local function syncPreviewUpdate() -- Line: 315
        -- upvalues: isPreviewVisible (copy), u38 (ref), RunServiceController (ref), u26 (copy), updatePreviewStep (copy)
        if not isPreviewVisible() then
            if u38 then
                u38:Disconnect();
                u38 = nil;
            end;

            return;
        end;

        if u38 then
            return;
        end;

        u38 = RunServiceController.BindToStepped(`UI.CrosshairPreview.{u26}`, updatePreviewStep);
        updatePreviewStep(0, 0);
    end;

    local u46 = {};

    local function refreshVisibilityConnections() -- Line: 338
        -- upvalues: u46 (copy), u27 (copy), LocalPlayer (ref), syncPreviewUpdate (copy)
        for _, v in ipairs(u46) do
            v:Disconnect();
        end;

        table.clear(u46);
        local v47 = u27;

        while v47 and v47 ~= LocalPlayer.PlayerGui do
            if v47:IsA("GuiObject") then
                local PropertyChangedSignal = v47:GetPropertyChangedSignal("Visible");
                table.insert(u46, PropertyChangedSignal:Connect(syncPreviewUpdate));
            end;

            v47 = v47.Parent;
        end;
    end;

    refreshVisibilityConnections();
    u36:Add(u27.AncestryChanged:Connect(function() -- Line: 352
        -- upvalues: refreshVisibilityConnections (copy), isPreviewVisible (copy), u38 (ref), RunServiceController (ref), u26 (copy), updatePreviewStep (copy)
        refreshVisibilityConnections();

        if not isPreviewVisible() then
            if u38 then
                u38:Disconnect();
                u38 = nil;
            end;

            return;
        end;

        if u38 then
            return;
        end;

        u38 = RunServiceController.BindToStepped(`UI.CrosshairPreview.{u26}`, updatePreviewStep);
        updatePreviewStep(0, 0);
    end), "Disconnect");
    u36:Add(function() -- Line: 331, Name: clearVisibilityConnections
        -- upvalues: u46 (copy)
        for _, v in ipairs(u46) do
            v:Disconnect();
        end;

        table.clear(u46);
    end, true);
    u36:Add(stopPreviewUpdate, true);

    if isPreviewVisible() then
        if not u38 then
            u38 = RunServiceController.BindToStepped(`UI.CrosshairPreview.{u26}`, updatePreviewStep);
            updatePreviewStep(0, 0);
        end;
    elseif u38 then
        u38:Disconnect();
        u38 = nil;
    end;

    return function() -- Line: 361
        -- upvalues: u36 (copy)
        u36:Cleanup();
    end;
end;