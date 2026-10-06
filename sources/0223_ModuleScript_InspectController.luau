-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SceneLighting = require(ReplicatedStorage.Components.Common.SceneLighting);
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.Database.Custom.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Viewmodel = require(ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local ApplyMobileButtonLayout = require(ReplicatedStorage.Components.Common.ApplyMobileButtonLayout);
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v2 = GetUserPlatform();
local u3 = table.find(v2, "Mobile") and #v2 <= 1;
local workspace_CurrentCamera = workspace.CurrentCamera;
local u4 = nil;
local Lighting = ReplicatedStorage.Assets.Lighting;
local PreviewTemplate = ReplicatedStorage.Assets.UI.Inspect:WaitForChild("PreviewTemplate");
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = false;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = Janitor.new();
local u19 = "Weapon";
local u20 = false;
local u21 = nil;
local u22 = false;
local DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV;
local CFrame_Angles_ret = CFrame.Angles(0, -1.5707963267948966, 0);
local u23 = { "FAMAS", "AK-47", "M4A1-S", "Glock-18", "USP-S" };
local u24 = {
    Weapon = true,
    Melee = true,
    Glove = true
};
local u25 = { "HiddenTransparency", "_CaseScenePrevTransparency", "_InspectPrevTransparency" };
local u26 = false;
local Vector2_zero = Vector2.zero;
local u27 = 40;
local u28 = 40;
local u29 = 0;
local u30 = 0;
local u31 = 0;
local u32 = 0;
local UDim2_fromScale_ret = UDim2.fromScale(0.5, 0.075);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.317, 0.054);
local UDim2_fromScale_ret3 = UDim2.fromScale(0.243, 0.054);
local UDim2_fromScale_ret4 = UDim2.fromScale(0.5, 0.143);
local TweenInfo_new_ret = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u33 = {
    {
        Wear = "Factory New",
        Display = "Mint Condition",
        Min = 0,
        Max = 0.07,
        Color = Color3.fromRGB(0, 255, 127)
    },
    {
        Wear = "Minimal Wear",
        Display = "Near-Mint",
        Min = 0.07,
        Max = 0.15,
        Color = Color3.fromRGB(0, 170, 255)
    },
    {
        Wear = "Field-Tested",
        Display = "Standard-Grade",
        Min = 0.15,
        Max = 0.38,
        Color = Color3.fromRGB(255, 255, 0)
    },
    {
        Wear = "Well-Worn",
        Display = "Combat-Worn",
        Min = 0.38,
        Max = 0.45,
        Color = Color3.fromRGB(255, 85, 0)
    },
    {
        Wear = "Battle-Scarred",
        Display = "War-Torn",
        Min = 0.45,
        Max = 1,
        Color = Color3.fromRGB(255, 0, 0)
    }
};
local u34 = {};
local u35 = nil;
local u36 = nil;
local u37 = 1;
local u38 = false;

local function commaNumber(p39: number) -- Line: 157
    return tostring(p39):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function applyMapLighting() -- Line: 163
    -- upvalues: u11 (ref), SceneLighting (copy)
    u11 = SceneLighting.RestoreMap(nil, u11);
end;

local function applySceneLighting(p40: string) -- Line: 169
    -- upvalues: Lighting (copy), u11 (ref), SceneLighting (copy)
    local v41 = Lighting:FindFirstChild(p40) or Lighting:FindFirstChild("Menu");

    if not v41 then
        return;
    end;

    u11 = SceneLighting.ApplyScene(p40, v41);
end;

local function getInspectScenesFolder() -- Line: 184
    -- upvalues: u4 (ref), ReplicatedStorage (copy)
    if u4 then
        return u4;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        u4 = Assets:WaitForChild("InspectScenes", 10);
    end;

    return u4;
end;

local function getRandomInspectScene() -- Line: 197
    -- upvalues: u4 (ref), ReplicatedStorage (copy)
    local v42;

    if u4 then
        v42 = u4;
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            u4 = Assets:WaitForChild("InspectScenes", 10);
        end;

        v42 = u4;
    end;

    if not v42 then
        return nil;
    end;

    local v43 = {};

    for _, child in ipairs(v42:GetChildren()) do
        if child:IsA("Model") then
            table.insert(v43, child);
        end;
    end;

    if #v43 > 0 then
        return v43[math.random(1, #v43)];
    end;

    return nil;
end;

local function activateInspectSceneFlags(p44: userdata) -- Line: 216
    for _, descendant in ipairs(p44:GetDescendants()) do
        local v45 = descendant:IsA("Model") and descendant:FindFirstChild("csFlag");

        if v45 and (v45:IsA("Model") and not descendant:HasTag("Flag")) then
            descendant:AddTag("Flag");
        end;
    end;
end;

local function pivotInspectWeapon(p46: userdata, p47: userdata, p48) -- Line: 228
    -- upvalues: CFrame_Angles_ret (copy), u8 (ref)
    local v49 = p47.CFrame * p48 * CFrame_Angles_ret;

    if u8 then
        v49 = v49 * p46:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
    end;

    p46:PivotTo(v49);
end;

local function updateWeaponTransform() -- Line: 239
    -- upvalues: u14 (ref), u16 (ref), u30 (ref), u29 (ref), CFrame_Angles_ret (copy), u8 (ref)
    if not (u14 and u16) then
        return;
    end;

    local WeaponPart = u16:FindFirstChild("WeaponPart");

    if WeaponPart then
        local CFrame_Angles_ret2 = CFrame.Angles(0, math.rad(u30), (math.rad(u29)));
        local v50 = u14;
        local v51 = WeaponPart.CFrame * CFrame_Angles_ret2 * CFrame_Angles_ret;

        if u8 then
            v51 = v51 * v50:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
        end;

        v50:PivotTo(v51);
    end;
end;

local function handleDragInput(p52) -- Line: 253
    -- upvalues: u32 (ref), u31 (ref)
    u32 = u32 + p52.X * 0.5;
    u31 = math.clamp(u31 + p52.Y * 0.5, -80, 80);
end;

local function handleFOVInput(p53: number) -- Line: 261
    -- upvalues: u19 (ref), u28 (ref)
    if u19 == "Viewmodel" then
        return;
    end;

    u28 = math.clamp(u28 - p53 * 2, 20, 70);
end;

local function getTouchCount() -- Line: 272
    -- upvalues: u34 (ref)
    local v54 = 0;

    for _ in pairs(u34) do
        v54 = v54 + 1;
    end;

    return v54;
end;

local function getPinchDistance() -- Line: 282
    -- upvalues: u34 (ref)
    local v55 = {};

    for _, v in pairs(u34) do
        table.insert(v55, v);
    end;

    if #v55 >= 2 then
        return (v55[1] - v55[2]).Magnitude;
    end;

    return nil;
end;

local function getInspectFrame() -- Line: 295
    -- upvalues: MenuState (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    return MenuFrame;
end;

local function setMenuBackdrop(p56: userdata, p57: boolean, p58: boolean) -- Line: 302
    -- upvalues: MenuState (copy)
    MenuState.SetBlurEnabled(p57);
    p56.BackgroundTransparency = p57 and 0.15 or 1;
    local Pattern = p56:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = p58;
    end;
end;

local function hideOtherMenuScreens(p59: userdata, p60: string) -- Line: 314
    for _, child in ipairs(p59:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= p60 and (child.Name ~= "Inspect" and child.Name ~= "InspectFrame"))) then
            child.Visible = false;
        end;
    end;
end;

local function hideMenuFrames() -- Line: 330
    -- upvalues: MenuState (copy), u13 (ref), MenuSceneController (copy)
    MenuState.EnterInspect();
    local MenuFrame = MenuState.GetMenuFrame();

    if not MenuFrame then
        return;
    end;

    u13 = MenuSceneController.IsActive();

    if u13 then
        MenuSceneController.HideMenuScene(true);
        MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5);
    end;

    MenuState.SetBlurEnabled(false);
    MenuFrame.BackgroundTransparency = 1;
    local Pattern = MenuFrame:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = false;
    end;

    local Top = MenuFrame:FindFirstChild("Top");

    if Top then
        Top.Visible = false;
    end;

    for _, child in ipairs(MenuFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Top" then
            child.Visible = child.Name == "Inspect" and true or child.Name == "InspectFrame";
        end;
    end;
end;

local function getFloatPreviewClosedPosition(p61: userdata, p62: userdata) -- Line: 361
    local Position = p61.Position;

    return UDim2.new(-(p61.Size.X.Scale * p62.Position.X.Scale), -(p61.Size.X.Offset + p62.Position.X.Offset), Position.Y.Scale, Position.Y.Offset);
end;

local function setFloatPreviewArrowDirection(p63: userdata, p64: boolean) -- Line: 371
    local TextLabel = p63:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Rotation = p64 and 0 or 180;
    end;
end;

local function storeFloatPreviewOpenPosition(p65: userdata) -- Line: 380
    local Position = p65.Position;
    p65:SetAttribute("OpenPositionXScale", Position.X.Scale);
    p65:SetAttribute("OpenPositionXOffset", Position.X.Offset);
    p65:SetAttribute("OpenPositionYScale", Position.Y.Scale);
    p65:SetAttribute("OpenPositionYOffset", Position.Y.Offset);
end;

local function getStoredFloatPreviewOpenPosition(p66: userdata) -- Line: 390
    return UDim2.new(p66:GetAttribute("OpenPositionXScale") or p66.Position.X.Scale, p66:GetAttribute("OpenPositionXOffset") or p66.Position.X.Offset, p66:GetAttribute("OpenPositionYScale") or p66.Position.Y.Scale, p66:GetAttribute("OpenPositionYOffset") or p66.Position.Y.Offset);
end;

local function bindClickButton(p67: userdata, p68: string, p69: function) -- Line: 401
    -- upvalues: ActivateButton (copy)
    local v70 = p67:FindFirstChild(p68);

    if v70 and v70:IsA("GuiButton") then
        ActivateButton(v70);
        v70.MouseButton1Click:Connect(p69);
    end;
end;

local function initializeInspectButtons() -- Line: 411
    -- upvalues: MenuState (copy), ActivateButton (copy), CloseButtonRegistry (copy), u1 (copy), storeFloatPreviewOpenPosition (copy), getFloatPreviewClosedPosition (copy), TweenService (copy), TweenInfo_new_ret (copy), DataController (copy), LocalPlayer (copy), Mobile (copy), ApplyMobileButtonLayout (copy), Router (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    local v71;

    if MenuFrame then
        v71 = MenuFrame:FindFirstChild("Bottom");
    else
        v71 = MenuFrame;
    end;

    if not v71 then
        return;
    end;

    local Close = v71.Container.Buttons:FindFirstChild("Close");

    if Close and Close:IsA("GuiButton") then
        ActivateButton(Close);
        CloseButtonRegistry.Add(MenuFrame, Close, function() -- Line: 421
            -- upvalues: u1 (ref)
            u1.HideInspect();
        end);
    end;

    local Middle = v71:FindFirstChild("Middle");

    if Middle then
        Middle = Middle:FindFirstChild("Buttons");
    end;

    if Middle then
        for _, v in ipairs({ "Viewmodel", "Weapon" }) do
            local v72 = Middle:FindFirstChild(v);

            if v72 and v72:IsA("GuiButton") then
                ActivateButton(v72);
            end;
        end;
    end;

    local FloatPreviews = MenuFrame:FindFirstChild("FloatPreviews");

    if FloatPreviews then
        FloatPreviews.Visible = false;
        local ToggleButton = FloatPreviews:FindFirstChild("ToggleButton");

        if ToggleButton and ToggleButton:IsA("GuiButton") then
            ActivateButton(ToggleButton);
            storeFloatPreviewOpenPosition(FloatPreviews);
            local Position = FloatPreviews.Position;
            local u73 = getFloatPreviewClosedPosition(FloatPreviews, ToggleButton);
            FloatPreviews:SetAttribute("IsOpen", true);
            local TextLabel = ToggleButton:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Rotation = 0;
            end;

            local u74 = nil;
            ToggleButton.Activated:Connect(function() -- Line: 452
                -- upvalues: FloatPreviews (copy), ToggleButton (copy), u74 (ref), TweenService (ref), TweenInfo_new_ret (ref), Position (copy), u73 (copy)
                local v75 = FloatPreviews:GetAttribute("IsOpen") == false;
                FloatPreviews:SetAttribute("IsOpen", v75);
                local TextLabel2 = ToggleButton:FindFirstChild("TextLabel");

                if TextLabel2 and TextLabel2:IsA("TextLabel") then
                    TextLabel2.Rotation = v75 and 0 or 180;
                end;

                if u74 then
                    u74:Cancel();
                end;

                local v76 = {};
                local v77;

                if v75 then
                    v77 = Position;
                else
                    v77 = u73;
                end;

                v76.Position = v77;
                local v78 = TweenService:Create(FloatPreviews, TweenInfo_new_ret, v76);
                u74 = v78;
                v78:Play();
            end);
        end;
    end;

    local MobileButtons = MenuFrame:FindFirstChild("MobileButtons");

    if MobileButtons then
        local Inspect = MobileButtons:FindFirstChild("Inspect");

        if Inspect and Inspect:IsA("TextButton") then
            ActivateButton(Inspect);
            Inspect.MouseButton1Click:Connect(function() -- Line: 476
                -- upvalues: u1 (ref)
                u1.PlayInspectAnimation();
            end);
            local v79 = DataController.Get(LocalPlayer, "MobileButtons");
            local Inspect2 = Mobile.SanitizeLayout(v79).Inspect;

            if Inspect2 then
                ApplyMobileButtonLayout(Inspect, Inspect2);
            end;
        end;

        MobileButtons.Visible = false;
    end;

    local Charm = v71.Middle:FindFirstChild("Charm");

    if Charm then
        local function v80() -- Line: 492
            -- upvalues: u1 (ref)
            u1.CycleCharmPosition();
        end;

        local Next = Charm:FindFirstChild("Next");

        if Next and Next:IsA("GuiButton") then
            ActivateButton(Next);
            Next.MouseButton1Click:Connect(v80);
        end;

        local function v81() -- Line: 495
            -- upvalues: Router (ref)
            Router.broadcastRouter("ConfirmCharmAttachment");
        end;

        local Confirm = Charm:FindFirstChild("Confirm");

        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm);
            Confirm.MouseButton1Click:Connect(v81);
        end;
    end;
end;

local function updateInspectMobileButtonsVisibility() -- Line: 503
    -- upvalues: MenuState (copy), u22 (ref), u19 (ref), u3 (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("MobileButtons");
    end;

    local v82;

    if MenuFrame then
        v82 = MenuFrame:FindFirstChild("Inspect");
    else
        v82 = MenuFrame;
    end;

    if not v82 then
        return;
    end;

    local v83 = u22;

    if v83 then
        if u19 == "Viewmodel" then
            v83 = u3;
        else
            v83 = false;
        end;
    end;

    MenuFrame.Visible = v83;
    v82.Visible = v83;
end;

local u84 = { {
        Name = "Inspect",
        Action = "Inspect",
        Title = "Inspect"
    }, {
        Name = "Cancel",
        Action = "Reload",
        Title = "Cancel"
    } };

local function refreshInspectTips() -- Line: 527
    -- upvalues: MenuState (copy), ReplicatedStorage (copy), u22 (ref), u19 (ref), UserInputService (copy), u84 (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Tips");
    end;

    if not (MenuFrame and MenuFrame:IsA("GuiObject")) then
        return;
    end;

    local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);

    if not MenuFrame:GetAttribute("Mirrored") then
        MenuFrame:SetAttribute("Mirrored", true);
        MenuFrame.AnchorPoint = Vector2.new(1, MenuFrame.AnchorPoint.Y);
        local v85 = MenuFrame:FindFirstChildOfClass("UIListLayout");

        if v85 then
            v85.HorizontalAlignment = Enum.HorizontalAlignment.Right;
        end;

        for _, child in MenuFrame:GetChildren() do
            if child:IsA("GuiObject") then
                Tips.MirrorRow(child);
            end;
        end;
    end;

    local v86 = u22;

    if v86 then
        if u19 == "Viewmodel" then
            v86 = UserInputService.PreferredInput ~= Enum.PreferredInput.Touch;
        else
            v86 = false;
        end;
    end;

    local v87 = false;

    for _, v in u84 do
        local v88 = MenuFrame:FindFirstChild(v.Name);

        if v88 and v88:IsA("GuiObject") then
            local Title = v88:FindFirstChild("Title");

            if Title and Title:IsA("TextLabel") then
                Title.Text = v.Title;
            end;

            local Keybind = v88:FindFirstChild("Keybind");

            if Keybind and Keybind:IsA("GuiObject") then
                Keybind.Selectable = false;
            end;

            local v89;

            if v86 then
                if Keybind == nil then
                    v89 = false;
                else
                    v89 = Keybind:IsA("GuiButton") and Tips.ApplyBindingToKeybind(Keybind, Tips.ResolveActionBinding(v.Action));
                end;
            else
                v89 = v86;
            end;

            v88.Visible = v89;
            v87 = v87 or v89;
        end;
    end;

    MenuFrame.Visible = v87;
end;

local function updateCharmFrameVisibility() -- Line: 586
    -- upvalues: MenuState (copy), Router (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Bottom");
    end;

    if not MenuFrame then
        return;
    end;

    local Charm = MenuFrame.Middle:FindFirstChild("Charm");
    local Buttons = MenuFrame.Middle:FindFirstChild("Buttons");

    if Charm then
        Charm.Visible = Router.broadcastRouter("HasPendingCharmAttachment") or false;
        Buttons.Visible = not Charm.Visible;
    end;
end;

local function getItemClass(p90) -- Line: 604
    -- upvalues: GetWeaponProperties (copy)
    if p90.Name then
        local success, result = pcall(GetWeaponProperties, p90.Name);

        if success and result then
            return result.Class;
        end;
    end;

    return nil;
end;

local function isGloveInventoryItem(p91) -- Line: 616
    -- upvalues: GetWeaponProperties (copy)
    local v92;

    if p91 == nil then
        v92 = false;
    elseif p91.Type == "Glove" then
        v92 = true;
    else
        local v93;

        if p91.Name then
            local success, result = pcall(GetWeaponProperties, p91.Name);

            if success and result then
                v93 = result.Class;
            else
                v93 = nil;
            end;
        else
            v93 = nil;
        end;

        v92 = v93 == "Glove";
    end;

    return v92;
end;

local function supportsViewmodelInspect(p94) -- Line: 622
    -- upvalues: u24 (copy), GetWeaponProperties (copy)
    local v95;

    if u24[p94.Type] == true then
        v95 = true;
    else
        local v96;

        if p94.Name then
            local success, result = pcall(GetWeaponProperties, p94.Name);

            if success and result then
                v96 = result.Class;
            else
                v96 = nil;
            end;
        else
            v96 = nil;
        end;

        v95 = u24[v96] == true;
    end;

    return v95;
end;

local function cleanupGloveViewmodelInspectAnimation() -- Line: 629
    -- upvalues: u5 (ref), u6 (ref)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;
end;

local function playGloveViewmodelInspectAnimation() -- Line: 646
    -- upvalues: u5 (ref), u7 (ref)
    if not u5 then
        return;
    end;

    if u7 and u7.Animation then
        u7.Animation:stopAnimations();
    end;

    if u5.IsPlaying then
        u5:Stop(0);
    end;

    u5.TimePosition = 0;
    u5:Play(0, 1, 1);
end;

local function setupGloveViewmodelInspectAnimation() -- Line: 665
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if not (u7 and u7.Animation) then
        return;
    end;

    local Animator = u7.Animation.Animator;

    if not Animator then
        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://135926544677482";
    local success, result = pcall(function() -- Line: 680
        -- upvalues: Animator (copy), Animation (copy)
        return Animator:LoadAnimation(Animation);
    end);

    if not (success and result) then
        Animation:Destroy();

        return;
    end;

    u6 = Animation;
    u5 = result;

    if not u5 then
        return;
    end;

    if u7 and u7.Animation then
        u7.Animation:stopAnimations();
    end;

    if u5.IsPlaying then
        u5:Stop(0);
    end;

    u5.TimePosition = 0;
    u5:Play(0, 1, 1);
end;

local function resolveInspectViewmodelSkin(p97: string, p98: string?) -- Line: 697
    -- upvalues: Skins (copy)
    local v99 = not (p98 and (p98 ~= "" and p98)) and "Vanilla" or p98;

    for _, v in ipairs({ v99, "Vanilla", "Default" }) do
        if Skins.GetSkinInformation(p97, v) then
            return v;
        end;
    end;

    local AllSkinsForWeapon = Skins.GetAllSkinsForWeapon(p97);

    if AllSkinsForWeapon and (AllSkinsForWeapon[1] and AllSkinsForWeapon[1].skin) then
        return AllSkinsForWeapon[1].skin;
    end;

    return v99;
end;

local function resolveGloveProxyWeapon() -- Line: 715
    -- upvalues: u23 (copy), Skins (copy)
    for _, v in ipairs(u23) do
        local BaseWeaponModel = Skins.GetBaseWeaponModel(v, "Camera");

        if BaseWeaponModel then
            BaseWeaponModel:Destroy();

            return v;
        end;
    end;

    return "FAMAS";
end;

local function clearViewmodelHorizontalOffset(p100) -- Line: 730
    local Stats = p100.Model:FindFirstChild("Stats");

    if Stats then
        Stats = Stats:FindFirstChild("Default");
    end;

    local v101;

    if Stats then
        v101 = Stats.Value;
    else
        v101 = Stats;
    end;

    if typeof(v101) == "Vector3" then
        Stats.Value = Vector3.new(0.05, v101.Y, v101.Z);
    end;
end;

local function cleanupWeaponInspect() -- Line: 742
    -- upvalues: u14 (ref), u8 (ref)
    if u14 then
        u14:Destroy();
        u14 = nil;
    end;

    u8 = nil;
end;

local function cleanupViewmodelInspect() -- Line: 750
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:destroy();
        u7 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    InputController.enableGroup("Gameplay");
end;

local function cleanupInspectMode() -- Line: 765
    -- upvalues: u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy)
    if u19 ~= "Weapon" then
        if u19 == "Viewmodel" then
            if u5 then
                if u5.IsPlaying then
                    u5:Stop(0);
                end;

                u5:Destroy();
                u5 = nil;
            end;

            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            if u7 then
                u7:destroy();
                u7 = nil;
            end;

            if u10 then
                u10:Destroy();
                u10 = nil;
            end;

            InputController.enableGroup("Gameplay");
        end;

        return;
    end;

    if u14 then
        u14:Destroy();
        u14 = nil;
    end;

    u8 = nil;
end;

local function prepareInspectWeapon(p102: userdata, p103: boolean) -- Line: 775
    -- upvalues: u14 (ref), u8 (ref)
    p102.Name = "InspectWeapon";
    u14 = p102;
    u8 = p102:FindFirstChild("InspectPivot", true);
    local CharmBase = p102:FindFirstChild("CharmBase", true);

    for _, descendant in ipairs(p102:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CastShadow = false;

            if p103 then
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Anchored = p102.PrimaryPart == descendant;
            elseif CharmBase and descendant:IsDescendantOf(CharmBase) then
                descendant.Anchored = false;
            else
                descendant.CanCollide = descendant:IsA("MeshPart");
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Anchored = true;
            end;
        end;
    end;
end;

local function setupWeaponInspect(p104) -- Line: 805
    -- upvalues: u16 (ref), Skins (copy), prepareInspectWeapon (copy), CFrame_Angles_ret (copy), u8 (ref)
    if not u16 then
        return;
    end;

    local WeaponPart = u16:FindFirstChild("WeaponPart");

    if not WeaponPart then
        warn("[InspectController]: Inspect scene missing WeaponPart");

        return;
    end;

    local v105 = p104.Type == "Glove";
    local v106 = p104.Type == "Charm";
    local v107;

    if v105 then
        local Gloves = Skins.GetGloves(p104.Name, p104.Skin, p104.Float);

        if Gloves and Gloves:IsA("BasePart") then
            v107 = Instance.new("Model");
            v107.Name = p104.Name;
            Gloves.Parent = v107;
            v107.PrimaryPart = Gloves;
        else
            v107 = Gloves;
        end;
    elseif v106 then
        v107 = Skins.GetCharmModel(p104.Skin, p104.Pattern or 1);
    elseif p104.Type == "Badge" then
        v107 = Skins.GetBadgeModel(p104.Skin);
    else
        v107 = Skins.GetCharacterModel(p104.Name, p104.Skin, p104.Float, p104.StatTrack, p104.NameTag, p104.Charm, p104.Stickers);
    end;

    if not v107 then
        warn(`[InspectController]: Failed to get model for "{p104.Name}"`, p104);

        return;
    end;

    prepareInspectWeapon(v107, v106);

    if v105 and (p104.Name == "T Glove" or p104.Name == "CT Glove") then
        local v108 = {};

        for _, child in ipairs(v107:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(v108, child);
            end;
        end;

        if #v108 >= 2 then
            local v109 = v107:FindFirstChild("RightGlove") or v108[1];

            for _, v in ipairs(v108) do
                if v ~= v109 then
                    v:Destroy();
                end;
            end;
        end;
    end;

    v107.Parent = u16;
    local v110 = WeaponPart.CFrame * CFrame.identity * CFrame_Angles_ret;

    if u8 then
        v110 = v110 * v107:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
    end;

    v107:PivotTo(v110);
end;

local function setupViewmodelInspect(u111) -- Line: 877
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), LocalPlayer (copy), GetWeaponProperties (copy), MenuSceneController (copy), HttpService (copy), Router (copy), u37 (ref), resolveGloveProxyWeapon (copy), resolveInspectViewmodelSkin (copy), Viewmodel (copy), workspace_CurrentCamera (copy), setupGloveViewmodelInspectAnimation (copy), u25 (copy)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:destroy();
        u7 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    InputController.enableGroup("Gameplay");
    local v112 = LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and "CT" or "T";
    local v113;

    if u111 == nil then
        v113 = false;
    elseif u111.Type == "Glove" then
        v113 = true;
    else
        local v114;

        if u111.Name then
            local success, result = pcall(GetWeaponProperties, u111.Name);

            if success and result then
                v114 = result.Class;
            else
                v114 = nil;
            end;
        else
            v114 = nil;
        end;

        v113 = v114 == "Glove";
    end;

    local v115 = MenuSceneController.CreateStandaloneCharacter(v112);

    if not v115 then
        warn("[InspectController]: Failed to create standalone character for viewmodel");

        return;
    end;

    if v113 then
        local v116 = {
            Name = u111.Name,
            Skin = u111.Skin,
            Float = u111.Float
        };

        if u111._id and u111._id ~= "" then
            v116.SkinIdentifier = u111._id;
        end;

        v115:SetAttribute("EquippedGloves", HttpService:JSONEncode(v116));
    end;

    u10 = v115;
    local Charm = u111.Charm;
    local v117 = Router.broadcastRouter("HasPendingCharmAttachment") and type(Charm) == "table" and {
        _id = Charm._id,
        Position = tostring(u37)
    } or Charm;
    local u118 = {
        Player = LocalPlayer,
        Character = v115,
        StatTrack = u111.StatTrack,
        Stickers = u111.Stickers,
        NameTag = u111.NameTag,
        Float = u111.Float,
        Charm = v117
    };
    local Name = u111.Name;
    local u119;

    if v113 then
        Name = resolveGloveProxyWeapon();
        u119 = "Stock";
    else
        u119 = resolveInspectViewmodelSkin(Name, u111.Skin);
    end;

    u118.ViewmodelCameraWeapon = Name;
    u118.ViewmodelHideWeaponGeometry = v113;
    local success, result = pcall(function() -- Line: 939
        -- upvalues: Viewmodel (ref), u118 (copy), u111 (copy), u119 (ref)
        return Viewmodel.new(u118, u111.Name, u119, true);
    end);

    if not (success and result) then
        warn(`[InspectController]: Failed to create viewmodel ({Name} | {u119})`, result);

        if u5 then
            if u5.IsPlaying then
                u5:Stop(0);
            end;

            u5:Destroy();
            u5 = nil;
        end;

        if u6 then
            u6:Destroy();
            u6 = nil;
        end;

        if u7 then
            u7:destroy();
            u7 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        InputController.enableGroup("Gameplay");

        return;
    end;

    u7 = result;
    u7:equip(v113);

    if not u7.Model then
        return;
    end;

    if u7.Model.Parent ~= workspace_CurrentCamera then
        u7.Model.Parent = workspace_CurrentCamera;
    end;

    if u7.Hidden then
        u7:unhide();
    end;

    if v113 then
        local Stats = u7.Model:FindFirstChild("Stats");

        if Stats then
            Stats = Stats:FindFirstChild("Default");
        end;

        local v120;

        if Stats then
            v120 = Stats.Value;
        else
            v120 = Stats;
        end;

        if typeof(v120) == "Vector3" then
            Stats.Value = Vector3.new(0.05, v120.Y, v120.Z);
        end;

        setupGloveViewmodelInspectAnimation();
    end;

    task.defer(function() -- Line: 971
        -- upvalues: u7 (ref), u25 (ref)
        if not (u7 and u7.Model) then
            return;
        end;

        for _, descendant in ipairs(u7.Model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CastShadow = false;

                if descendant.Name ~= "HumanoidRootPart" and (descendant.Name ~= "ViewmodelLight" and (descendant.Name ~= "MuzzlePart" and descendant.Name ~= "MuzzlePartL")) and descendant.Name ~= "MuzzlePartR" then
                    local v121 = descendant;
                    local v122 = nil;

                    for _, v in ipairs(u25) do
                        v122 = v121:GetAttribute(v);

                        if v122 ~= nil then
                            v121:SetAttribute(v, nil);
                            break;
                        end;
                    end;

                    if v122 == nil then
                        if v121.Transparency >= 1 and (v121.Name == "Right Arm" or v121.Name == "Left Arm") then
                            v121.Transparency = 0;
                        end;
                    else
                        v121.Transparency = v122;
                    end;
                end;
            elseif descendant:IsA("SurfaceGui") then
                if descendant:GetAttribute("_InspectPrevSurfaceGuiEnabled") then
                    descendant:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil);
                end;

                if descendant:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") then
                    descendant:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil);
                end;

                descendant.Enabled = true;
            end;
        end;
    end);
end;

local function applyInspectMode(p123: string) -- Line: 1018
    -- upvalues: u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), MenuState (copy), u22 (ref), u3 (copy), refreshInspectTips (copy), setupWeaponInspect (copy), u28 (ref), setupViewmodelInspect (copy), DEFAULT_CAMERA_FOV (copy)
    local v124 = u9;

    if not v124 then
        return;
    end;

    if u19 == "Weapon" then
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        u8 = nil;
    elseif u19 == "Viewmodel" then
        if u5 then
            if u5.IsPlaying then
                u5:Stop(0);
            end;

            u5:Destroy();
            u5 = nil;
        end;

        if u6 then
            u6:Destroy();
            u6 = nil;
        end;

        if u7 then
            u7:destroy();
            u7 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        InputController.enableGroup("Gameplay");
    end;

    u19 = p123;
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("MobileButtons");
    end;

    local v125;

    if MenuFrame then
        v125 = MenuFrame:FindFirstChild("Inspect");
    else
        v125 = MenuFrame;
    end;

    if v125 then
        local v126 = u22;

        if v126 then
            if u19 == "Viewmodel" then
                v126 = u3;
            else
                v126 = false;
            end;
        end;

        MenuFrame.Visible = v126;
        v125.Visible = v126;
    end;

    refreshInspectTips();

    if p123 ~= "Weapon" then
        if p123 == "Viewmodel" then
            InputController.disableGroup("Gameplay");
            setupViewmodelInspect(v124);
            u28 = DEFAULT_CAMERA_FOV;
        end;

        return;
    end;

    setupWeaponInspect(v124);
    u28 = 40;
    InputController.enableGroup("Gameplay");
end;

local function setInspectMode(p127: string) -- Line: 1043
    -- upvalues: u9 (ref), GetWeaponProperties (copy), u19 (ref), u20 (ref), u21 (ref), applyInspectMode (copy), u22 (ref)
    local v128 = u9;

    if not v128 then
        return;
    end;

    local v129;

    if v128 == nil then
        v129 = false;
    elseif v128.Type == "Glove" then
        v129 = true;
    else
        local v130;

        if v128.Name then
            local success, result = pcall(GetWeaponProperties, v128.Name);

            if success and result then
                v130 = result.Class;
            else
                v130 = nil;
            end;
        else
            v130 = nil;
        end;

        v129 = v130 == "Glove";
    end;

    local v131 = v129 and p127 == "Weapon" and "Viewmodel" or p127;

    if u19 == v131 then
        return;
    end;

    if u20 then
        u21 = v131;

        return;
    end;

    u20 = true;

    while v131 do
        local success, result = pcall(applyInspectMode, v131);

        if not success then
            warn(`[InspectController]: Failed to apply inspect mode "{v131}"`, result);
        end;

        v131 = u21;
        u21 = nil;

        if v131 == u19 or not u22 then
            v131 = nil;
        end;
    end;

    u20 = false;
end;

local function tween(p132, p133) -- Line: 1085
    -- upvalues: TweenService (copy)
    if p132 then
        TweenService:Create(p132, TweenInfo.new(0.2), p133):Play();
    end;
end;

local function updateButtonVisuals(p134: string, p135: userdata, p136: boolean) -- Line: 1091
    -- upvalues: u19 (ref), TweenService (copy)
    local HoverFrame = p135:FindFirstChild("HoverFrame");
    local SelectFrame = p135:FindFirstChild("SelectFrame");
    local ImageLabel = p135:FindFirstChild("ImageLabel");
    local v137;

    if u19 == p134 then
        v137 = p134 ~= "Info";
    else
        v137 = false;
    end;

    if v137 then
        local v138 = {
            BackgroundTransparency = 1
        };

        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v138):Play();
        end;

        local v139 = {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(95, 95, 95)
        };

        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v139):Play();
        end;

        local v140 = {
            ImageColor3 = Color3.fromRGB(210, 210, 210)
        };

        if ImageLabel then
            TweenService:Create(ImageLabel, TweenInfo.new(0.2), v140):Play();
        end;
    else
        local v141 = {
            BackgroundTransparency = 1
        };

        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v141):Play();
        end;

        local v142 = {
            ImageColor3 = Color3.fromRGB(255, 255, 255)
        };

        if ImageLabel then
            TweenService:Create(ImageLabel, TweenInfo.new(0.2), v142):Play();
        end;

        local v143 = {
            BackgroundTransparency = p136 and 0 or 1
        };

        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v143):Play();
        end;
    end;
end;

local function refreshAllButtons(p144: table, p145: string) -- Line: 1109
    -- upvalues: updateButtonVisuals (copy)
    for i, v in pairs(p144) do
        if v and v:IsA("GuiButton") then
            updateButtonVisuals(i, v, i == p145);
        end;
    end;
end;

local function formatInfoText(p146: string, p147: string) -- Line: 1117
    return `<b><font color="rgb(175,175,175)">{p146}</font></b>: <font color="rgb(255,255,255)">{p147}</font>`;
end;

local function scaleInfoFrameToFit(p148: userdata, p149: table) -- Line: 1121
    -- upvalues: workspace_CurrentCamera (copy), TextService (copy)
    local math_floor_ret = math.floor(workspace_CurrentCamera.ViewportSize.Y * 0.025);
    local math_clamp_ret = math.clamp(math_floor_ret, 8, 32);
    local v150 = 0;

    for _, v in ipairs(p149) do
        if v and (v:IsA("TextLabel") and v.Text ~= "") then
            v.TextScaled = false;
            local TextSize = TextService:GetTextSize(v.Text:gsub("<[^>]*>", ""), math_clamp_ret, Enum.Font.Gotham, Vector2.new((1 / 0), (1 / 0)));

            if v150 < TextSize.X then
                v150 = TextSize.X;
            end;

            v.TextSize = math_clamp_ret;
            v.TextWrapped = false;
        end;
    end;

    if v150 > 0 then
        p148.Size = UDim2.new(0.05, v150, p148.Size.Y.Scale, p148.Size.Y.Offset);
    end;
end;

local function showInfoFrame(p151: userdata, p152: any, p153: userdata?) -- Line: 1150
    -- upvalues: Skins (copy), scaleInfoFrameToFit (copy)
    local Information = p151:FindFirstChild("Information");

    if not Information then
        return;
    end;

    if p153 then
        Information.Position = UDim2.new(0, p153.AbsolutePosition.X + p153.AbsoluteSize.X / 2 - Information.Parent.AbsolutePosition.X + Information.AbsoluteSize.X / 2, Information.Position.Y.Scale, Information.Position.Y.Offset);
    end;

    Information.Visible = true;
    local SkinInformation = Skins.GetSkinInformation(p152.Name, p152.Skin);
    local v154;

    if SkinInformation then
        local _, v155 = Skins.GetWearNameForFloat(SkinInformation, p152.Float or 0);
        v154 = v155 or "Mint Condition";
    else
        v154 = "Mint Condition";
    end;

    local v156 = p152.Type == "Charm";
    local Exterior = Information:FindFirstChild("Exterior");

    if Exterior then
        Exterior.Visible = not v156;

        if not v156 then
            Exterior.RichText = true;
            Exterior.Text = `<b><font color="rgb(175,175,175)">Exterior</font></b>: <font color="rgb(255,255,255)">{v154}</font>`;
        end;
    end;

    local Tradeable = Information:FindFirstChild("Tradeable");

    if Tradeable then
        Tradeable.RichText = true;
        Tradeable.Text = `<b><font color="rgb(175,175,175)">Tradeable</font></b>: <font color="rgb(255,255,255)">{p152.IsTradeable and "Yes" or "No"}</font>`;
    end;

    local Serial = Information:FindFirstChild("Serial");

    if Serial then
        Serial.RichText = true;
        local Serial2 = p152.Serial;
        Serial.Text = `<b><font color="rgb(175,175,175)">Serial</font></b>: <font color="rgb(255,255,255)">{typeof(Serial2) ~= "number" and "N/A" or `#{tostring(Serial2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`}</font>`;
    end;

    local Pattern = Information:FindFirstChild("Pattern");

    if Pattern then
        if v156 then
            Pattern.Visible = true;
            Pattern.RichText = true;
            Pattern.Text = `<b><font color="rgb(175,175,175)">Pattern</font></b>: <font color="rgb(255,255,255)">{tostring(p152.Pattern or 0)}</font>`;
        elseif p152.Skin:find("PATTERN") then
            local _, v157 = table.unpack(p152.Skin:split("_PATTERN_"));
            Pattern.Text = `<b><font color="rgb(175,175,175)">Pattern</font></b>: <font color="rgb(255,255,255)">{v157}</font>`;
            Pattern.Visible = true;
        else
            Pattern.Visible = false;
        end;
    end;

    local Float = Information:FindFirstChild("Float");

    if Float then
        Float.Visible = not v156;

        if not v156 then
            Float.RichText = true;
            Float.Text = `<b><font color="rgb(175,175,175)">Float</font></b>: <font color="rgb(255,255,255)">{string.format("%.14f", p152.Float or 0)}</font>`;
        end;
    end;

    task.defer(function() -- Line: 1230
        -- upvalues: Exterior (copy), Tradeable (copy), Serial (copy), Pattern (copy), Float (copy), scaleInfoFrameToFit (ref), Information (copy)
        local v158 = {};

        if Exterior and Exterior.Visible then
            table.insert(v158, Exterior);
        end;

        if Tradeable then
            table.insert(v158, Tradeable);
        end;

        if Serial then
            table.insert(v158, Serial);
        end;

        if Pattern and Pattern.Visible then
            table.insert(v158, Pattern);
        end;

        if Float and Float.Visible then
            table.insert(v158, Float);
        end;

        scaleInfoFrameToFit(Information, v158);
    end);
end;

local function hideInfoFrame(p159: userdata) -- Line: 1252
    local Information = p159:FindFirstChild("Information");

    if Information then
        Information.Visible = false;
    end;
end;

local function isStoreOriginInspect() -- Line: 1260
    -- upvalues: MenuState (copy), PlayerGui (copy)
    if MenuState.IsCaseSceneActive() or (MenuState.GetScreenBeforeCaseScene() == "Store" or MenuState.GetCurrentScreen() == "Store") then
        return true;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Menu");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Store");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("CaseContent");
    end;

    local v160;

    if MainGui == nil then
        v160 = false;
    else
        v160 = MainGui:GetAttribute("WasVisibleBeforeInspect") == true;
    end;

    return v160;
end;

local function shouldHideInfoButton() -- Line: 1277
    -- upvalues: isStoreOriginInspect (copy)
    return isStoreOriginInspect();
end;

local function tryShowInfoFrame(p161: userdata?, p162: userdata) -- Line: 1281
    -- upvalues: u9 (ref), isStoreOriginInspect (copy), showInfoFrame (copy)
    if p161 and (u9 and (not isStoreOriginInspect() and u9.Type ~= "Badge")) then
        showInfoFrame(p161, u9, p162);
    end;
end;

local function setupButtonEvents(u163: userdata, u164: string, u165: table, u166: userdata?) -- Line: 1287
    -- upvalues: u18 (copy), updateButtonVisuals (copy), u9 (ref), isStoreOriginInspect (copy), showInfoFrame (copy), u19 (ref), setInspectMode (copy), refreshAllButtons (copy)
    u18:Add(u163.MouseEnter:Connect(function() -- Line: 1294
        -- upvalues: updateButtonVisuals (ref), u164 (copy), u163 (copy), u166 (copy), u9 (ref), isStoreOriginInspect (ref), showInfoFrame (ref)
        updateButtonVisuals(u164, u163, true);

        if u164 == "Info" then
            local v167 = u166;
            local v168 = u163;

            if v167 and (u9 and (not isStoreOriginInspect() and u9.Type ~= "Badge")) then
                showInfoFrame(v167, u9, v168);
            end;
        end;
    end), "Disconnect", "InspectButton_Enter_" .. u164);
    u18:Add(u163.MouseLeave:Connect(function() -- Line: 1305
        -- upvalues: updateButtonVisuals (ref), u164 (copy), u163 (copy), u166 (copy)
        updateButtonVisuals(u164, u163, false);
        local v169 = u164 == "Info" and (u166 and u166:FindFirstChild("Information"));

        if v169 then
            v169.Visible = false;
        end;
    end), "Disconnect", "InspectButton_Leave_" .. u164);

    if u164 == "Info" then
        u18:Add(u163.Activated:Connect(function() -- Line: 1317
            -- upvalues: u166 (copy), u163 (copy), u9 (ref), isStoreOriginInspect (ref), showInfoFrame (ref)
            local v170 = u166;
            local v171 = u163;

            if v170 and (u9 and (not isStoreOriginInspect() and u9.Type ~= "Badge")) then
                showInfoFrame(v170, u9, v171);
            end;
        end), "Disconnect", "InspectButton_Activated_Info");

        return;
    end;

    u18:Add(u163.MouseButton1Click:Connect(function() -- Line: 1325
        -- upvalues: u19 (ref), u164 (copy), setInspectMode (ref), refreshAllButtons (ref), u165 (copy)
        if u19 ~= u164 then
            setInspectMode(u164);
            refreshAllButtons(u165, u164);
        end;
    end), "Disconnect", "InspectButton_Click_" .. u164);
end;

local function setupInspectButtons(p172: userdata, p173: any) -- Line: 1339
    -- upvalues: u24 (copy), GetWeaponProperties (copy), isStoreOriginInspect (copy), updateButtonVisuals (copy), setupButtonEvents (copy)
    local Middle = p172:FindFirstChild("Bottom").Middle;

    if Middle then
        Middle = Middle:FindFirstChild("Buttons");
    end;

    if not Middle then
        return;
    end;

    local v174;

    if u24[p173.Type] == true then
        v174 = true;
    else
        local v175;

        if p173.Name then
            local success, result = pcall(GetWeaponProperties, p173.Name);

            if success and result then
                v175 = result.Class;
            else
                v175 = nil;
            end;
        else
            v175 = nil;
        end;

        v174 = u24[v175] == true;
    end;

    local v176;

    if p173 == nil then
        v176 = false;
    elseif p173.Type == "Glove" then
        v176 = true;
    else
        local v177;

        if p173.Name then
            local success, result = pcall(GetWeaponProperties, p173.Name);

            if success and result then
                v177 = result.Class;
            else
                v177 = nil;
            end;
        else
            v177 = nil;
        end;

        v176 = v177 == "Glove";
    end;

    local v178 = {
        Info = Middle:FindFirstChild("Info"),
        Viewmodel = Middle:FindFirstChild("Viewmodel"),
        Weapon = Middle:FindFirstChild("Weapon")
    };
    local v179 = isStoreOriginInspect();
    local v180 = p173.Type == "Badge";

    for i, v in pairs(v178) do
        if v and v:IsA("GuiButton") then
            if i == "Info" then
                v.Visible = not v179 and not v180;
            elseif i == "Weapon" then
                local v181;

                if v174 then
                    v181 = not v176;
                else
                    v181 = v174;
                end;

                v.Visible = v181;
            else
                v.Visible = v174;
            end;

            updateButtonVisuals(i, v, false);
            setupButtonEvents(v, i, v178, p172);
        end;
    end;
end;

local function getWearPreviewChance(p182: any, p183: string) -- Line: 1377
    for _, v in ipairs(p182.floatChances or {}) do
        if v.wear == p183 then
            return v.chance;
        end;
    end;

    return nil;
end;

local function formatWearPreviewChance(p184: number?) -- Line: 1387
    return not p184 and "" or string.format("%.2f%%", p184);
end;

local function getWearPreviewFloat(p185, p186) -- Line: 1393
    local math_max_ret = math.max(p185.floatRange.min, p186.Min);
    local math_min_ret = math.min(p185.floatRange.max, p186.Max - 1e-12);

    if math_min_ret < math_max_ret then
        return nil;
    end;

    return math.clamp((math_max_ret + math_min_ret) / 2, 0, 1);
end;

local function refreshActiveInspectItem(p187) -- Line: 1405
    -- upvalues: u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), setupWeaponInspect (copy), setupViewmodelInspect (copy)
    u9 = p187;

    if u19 == "Weapon" then
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        u8 = nil;
    elseif u19 == "Viewmodel" then
        if u5 then
            if u5.IsPlaying then
                u5:Stop(0);
            end;

            u5:Destroy();
            u5 = nil;
        end;

        if u6 then
            u6:Destroy();
            u6 = nil;
        end;

        if u7 then
            u7:destroy();
            u7 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        InputController.enableGroup("Gameplay");
    end;

    if u19 == "Weapon" then
        setupWeaponInspect(p187);

        return;
    end;

    if u19 == "Viewmodel" then
        InputController.disableGroup("Gameplay");
        setupViewmodelInspect(p187);
    end;
end;

local function getStatTrakPreviewChance(p188) -- Line: 1420
    return (p188.type == "Glove" or p188.supportsStatTrak == false) and 0 or (p188.statTrakChance or 0);
end;

local function setKillTrakBadgeVisible(p189: userdata, p190: boolean) -- Line: 1430
    for _, v in ipairs({ "Bottom", "Middle", "Description", "Statrak" }) do
        if p189 then
            p189 = p189:FindFirstChild(v);
        end;
    end;

    if p189 and p189:IsA("GuiObject") then
        p189.Visible = p190;
    end;
end;

local function updateStatTrakToggle(u191: userdata, p192: userdata, p193: boolean) -- Line: 1443
    -- upvalues: u38 (ref), u18 (copy), setKillTrakBadgeVisible (copy), u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), setupWeaponInspect (copy), setupViewmodelInspect (copy)
    local KillTrak = p192:FindFirstChild("KillTrak");

    if not KillTrak then
        return;
    end;

    KillTrak.Visible = p193;
    local Button = KillTrak:FindFirstChild("Button");

    if not (Button and Button:IsA("GuiButton")) then
        return;
    end;

    local CheckmarkImage = Button:FindFirstChild("CheckmarkImage");

    if CheckmarkImage then
        CheckmarkImage.Visible = u38;
    end;

    u18:Add(Button.Activated:Connect(function() -- Line: 1467
        -- upvalues: u38 (ref), CheckmarkImage (copy), setKillTrakBadgeVisible (ref), u191 (copy), u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (ref), setupWeaponInspect (ref), setupViewmodelInspect (ref)
        u38 = not u38;

        if CheckmarkImage then
            CheckmarkImage.Visible = u38;
        end;

        setKillTrakBadgeVisible(u191, u38);
        local v194 = u9;

        if v194 then
            local table_clone_ret = table.clone(v194);
            table_clone_ret.StatTrack = u38 and 0 or false;
            u9 = table_clone_ret;

            if u19 == "Weapon" then
                if u14 then
                    u14:Destroy();
                    u14 = nil;
                end;

                u8 = nil;
            elseif u19 == "Viewmodel" then
                if u5 then
                    if u5.IsPlaying then
                        u5:Stop(0);
                    end;

                    u5:Destroy();
                    u5 = nil;
                end;

                if u6 then
                    u6:Destroy();
                    u6 = nil;
                end;

                if u7 then
                    u7:destroy();
                    u7 = nil;
                end;

                if u10 then
                    u10:Destroy();
                    u10 = nil;
                end;

                InputController.enableGroup("Gameplay");
            end;

            if u19 == "Weapon" then
                setupWeaponInspect(table_clone_ret);

                return;
            end;

            if u19 == "Viewmodel" then
                InputController.disableGroup("Gameplay");
                setupViewmodelInspect(table_clone_ret);
            end;
        end;
    end), "Disconnect", "FloatPreview_StatTrakToggle");
end;

local function updateFloatPreviewRow(p195: userdata, p196: any, p197: any, p198: number, p199: number?) -- Line: 1492
    -- upvalues: u33 (copy), Skins (copy), Rarities (copy)
    p195.Name = p196.Wear;
    p195.Visible = true;
    p195.LayoutOrder = table.find(u33, p196) or 0;
    p195:SetAttribute("Wear", p196.Wear);
    p195:SetAttribute("PreviewFloat", p198);
    local Left = p195:FindFirstChild("Left");
    local v200;

    if Left then
        v200 = Left:FindFirstChild("Label");
    else
        v200 = Left;
    end;

    if v200 and v200:IsA("TextLabel") then
        v200.Text = p196.Display;
        v200.TextColor3 = p196.Color;
    end;

    if Left then
        Left = Left:FindFirstChild("Percent");
    end;

    if Left and Left:IsA("TextLabel") then
        Left.Text = not p199 and "" or string.format("%.2f%%", p199);
    end;

    local Bar = p195:FindFirstChild("Bar");

    if Bar then
        Bar = Bar:FindFirstChild("Current");
    end;

    if Bar and Bar:IsA("Frame") then
        local Size = Bar.Size;
        local math_clamp_ret = math.clamp((p199 or 0) / 100, 0, 1);
        Bar.Size = UDim2.new(math_clamp_ret, 0, Size.Y.Scale, Size.Y.Offset);
        Bar.BackgroundColor3 = p196.Color;
    end;

    local Icon = p195:FindFirstChild("Icon", true);

    if Icon and Icon:IsA("ImageLabel") then
        Icon.Image = Skins.GetWearImageForFloat(p197, p198) or (p197.imageAssetId or "");
    end;

    local v201 = Rarities[p197.rarity];

    if v201 then
        local RarityFrame = p195:FindFirstChild("RarityFrame", true);

        if RarityFrame and RarityFrame:IsA("Frame") then
            RarityFrame.BackgroundColor3 = v201.Color;
        end;

        local Rarity = p195:FindFirstChild("Rarity", true);

        if Rarity and Rarity:IsA("ImageLabel") then
            Rarity.ImageColor3 = v201.Color;
        end;
    end;
end;

local function updateFloatPreviewFrame(p202: userdata, p203: any, p204: any) -- Line: 1547
    -- upvalues: getStoredFloatPreviewOpenPosition (copy), isStoreOriginInspect (copy), u38 (ref), updateStatTrakToggle (copy), u33 (copy), getWearPreviewChance (copy), PreviewTemplate (copy), updateFloatPreviewRow (copy), u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), setupWeaponInspect (copy), setupViewmodelInspect (copy), ActivateButton (copy), u18 (copy)
    local FloatPreviews = p202:FindFirstChild("FloatPreviews");

    if not FloatPreviews then
        return;
    end;

    local Container = FloatPreviews:FindFirstChild("Container");

    if not Container then
        FloatPreviews.Visible = false;

        return;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    local v205;

    if p204 == nil or p203.HideWearDetails ~= true then
        v205 = false;
    else
        v205 = p203.Type ~= "Charm";
    end;

    FloatPreviews.Visible = v205;

    if not (v205 and p204) then
        return;
    end;

    Container.Visible = true;
    FloatPreviews.Position = getStoredFloatPreviewOpenPosition(FloatPreviews);
    FloatPreviews:SetAttribute("IsOpen", true);
    local ToggleButton = FloatPreviews:FindFirstChild("ToggleButton");

    if ToggleButton and ToggleButton:IsA("GuiButton") then
        local TextLabel = ToggleButton:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Rotation = 0;
        end;
    end;

    local v206;

    if ((p204.type == "Glove" or p204.supportsStatTrak == false) and 0 or (p204.statTrakChance or 0)) > 0 then
        v206 = isStoreOriginInspect();
    else
        v206 = false;
    end;

    if not v206 then
        u38 = false;
    end;

    updateStatTrakToggle(p202, FloatPreviews, v206);

    for _, v in ipairs(u33) do
        local math_max_ret = math.max(p204.floatRange.min, v.Min);
        local math_min_ret = math.min(p204.floatRange.max, v.Max - 1e-12);
        local u207;

        if math_min_ret < math_max_ret then
            u207 = nil;
        else
            u207 = math.clamp((math_max_ret + math_min_ret) / 2, 0, 1);
        end;

        local v208 = getWearPreviewChance(p204, v.Wear);

        if u207 and (v208 and v208 > 0) then
            local v209 = PreviewTemplate:Clone();
            updateFloatPreviewRow(v209, v, p204, u207, v208);

            local function selectWearPreview() -- Line: 1604
                -- upvalues: u9 (ref), u207 (copy), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (ref), setupWeaponInspect (ref), setupViewmodelInspect (ref)
                local v210 = u9;

                if not v210 then
                    return;
                end;

                local table_clone_ret = table.clone(v210);
                table_clone_ret.Float = u207;
                table_clone_ret.HideWearDetails = true;
                table_clone_ret.ShowFullPriceRange = true;
                u9 = table_clone_ret;

                if u19 == "Weapon" then
                    if u14 then
                        u14:Destroy();
                        u14 = nil;
                    end;

                    u8 = nil;
                elseif u19 == "Viewmodel" then
                    if u5 then
                        if u5.IsPlaying then
                            u5:Stop(0);
                        end;

                        u5:Destroy();
                        u5 = nil;
                    end;

                    if u6 then
                        u6:Destroy();
                        u6 = nil;
                    end;

                    if u7 then
                        u7:destroy();
                        u7 = nil;
                    end;

                    if u10 then
                        u10:Destroy();
                        u10 = nil;
                    end;

                    InputController.enableGroup("Gameplay");
                end;

                if u19 == "Weapon" then
                    setupWeaponInspect(table_clone_ret);

                    return;
                end;

                if u19 == "Viewmodel" then
                    InputController.disableGroup("Gameplay");
                    setupViewmodelInspect(table_clone_ret);
                end;
            end;

            local Inspect = v209:FindFirstChild("Inspect");

            if Inspect and Inspect:IsA("GuiObject") then
                Inspect.Visible = false;
            end;

            local Button = v209:FindFirstChild("Button");

            if Button and Button:IsA("GuiButton") then
                ActivateButton(Button);
                u18:Add(Button.Activated:Connect(selectWearPreview), "Disconnect", "FloatPreview_Button_" .. v.Wear);
            end;

            v209.Parent = Container;
        end;
    end;
end;

local function updateCollectionData(p211: userdata, p212: any) -- Line: 1639
    -- upvalues: Collections (copy), UDim2_fromScale_ret (copy), UDim2_fromScale_ret3 (copy), UDim2_fromScale_ret2 (copy), UDim2_fromScale_ret4 (copy)
    if p212 then
        p212 = p212.collection;
    end;

    local v213;

    if p212 then
        v213 = Collections.GetCollectionByName(p212);
    else
        v213 = p212;
    end;

    local v214 = v213 ~= nil;
    local Collection = p211.Top.Frame.Frame.TextInfo:FindFirstChild("Collection");

    if Collection and Collection:IsA("TextLabel") then
        Collection.Visible = v214;
        Collection.Text = p212 or "";
    end;

    local CollectionIcon = p211.Top.Frame.Frame:FindFirstChild("CollectionIcon");

    if CollectionIcon and CollectionIcon:IsA("ImageLabel") then
        CollectionIcon.Image = v213 and v213.imageAssetId or "";
        CollectionIcon.Visible = v214;
    end;

    local WeaponName = p211:FindFirstChild("WeaponName");

    if WeaponName and WeaponName:IsA("TextLabel") then
        WeaponName.Position = UDim2_fromScale_ret;
        local v215;

        if v214 then
            v215 = UDim2_fromScale_ret3;
        else
            v215 = UDim2_fromScale_ret2;
        end;

        WeaponName.Size = v215;
        WeaponName.TextXAlignment = Enum.TextXAlignment.Center;
    end;

    local Rarity = p211:FindFirstChild("Rarity");

    if Rarity and Rarity:IsA("Frame") then
        Rarity.Position = UDim2_fromScale_ret4;
    end;
end;

local function updateInspectFrameUI(p216) -- Line: 1670
    -- upvalues: PlayerGui (copy), setupInspectButtons (copy), isStoreOriginInspect (copy), Skins (copy), updateFloatPreviewFrame (copy), GetSkinDisplayName (copy), updateCollectionData (copy), Rarities (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Menu");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Inspect") or MainGui:FindFirstChild("InspectFrame");
    end;

    if not MainGui then
        return;
    end;

    setupInspectButtons(MainGui, p216);
    local v217 = isStoreOriginInspect() and MainGui:FindFirstChild("Information");

    if v217 then
        v217.Visible = false;
    end;

    local SkinInformation = Skins.GetSkinInformation(p216.Name, p216.Skin);
    updateFloatPreviewFrame(MainGui, p216, SkinInformation);
    local Item = MainGui.Top.Frame.Frame.TextInfo:FindFirstChild("Item");

    if Item and Item:IsA("TextLabel") then
        local v218 = GetSkinDisplayName(p216.Skin);
        GetSkinDisplayName.ApplyNameLabel(Item, (SkinInformation and SkinInformation.type == "Melee" and "★ " or "") .. GetSkinDisplayName.GetWeaponDisplayName(p216.Name, p216.NameTag) .. " | " .. v218, p216.NameTag);
    end;

    if SkinInformation then
        updateCollectionData(MainGui, SkinInformation);
        local Rarity = MainGui.Top.Frame:FindFirstChild("Rarity");
        local v219 = Rarity and (Rarity:IsA("Frame") and SkinInformation.rarity) and Rarities[SkinInformation.rarity];

        if v219 then
            Rarity.BackgroundColor3 = v219.Color;
        end;
    end;

    local Description = MainGui.Bottom.Middle:FindFirstChild("Description");

    if Description then
        local v220 = typeof(p216.StatTrack) == "number" and true or p216.StatTrack == true;
        Description.Statrak.Visible = v220;
        Description.Description.Text = SkinInformation and SkinInformation.description or "";
    end;
end;

local function hideViewmodels() -- Line: 1725
    -- upvalues: u17 (ref), workspace_CurrentCamera (copy), u7 (ref)
    u17 = {};

    for _, child in ipairs(workspace_CurrentCamera:GetChildren()) do
        if child:IsA("Model") and (child.Name ~= "InspectScene" and (not u7 or u7.Model ~= child)) then
            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") or descendant:IsA("Texture") then
                    if descendant.Transparency < 1 then
                        descendant:SetAttribute("_InspectPrevTransparency", descendant.Transparency);
                        descendant.Transparency = 1;
                    end;
                elseif descendant:IsA("SurfaceGui") and descendant.Enabled then
                    descendant:SetAttribute("_InspectPrevSurfaceGuiEnabled", true);
                    descendant.Enabled = false;
                end;
            end;

            table.insert(u17, child);
        end;
    end;
end;

local function showViewmodels() -- Line: 1752
    -- upvalues: u17 (ref)
    for _, v in ipairs(u17) do
        if v and v.Parent then
            for _, descendant in ipairs(v:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local Attribute = descendant:GetAttribute("_InspectPrevTransparency");

                    if Attribute ~= nil then
                        descendant.Transparency = Attribute;
                        descendant:SetAttribute("_InspectPrevTransparency", nil);
                    end;
                elseif descendant:IsA("SurfaceGui") then
                    if descendant:GetAttribute("_InspectPrevSurfaceGuiEnabled") ~= nil then
                        descendant.Enabled = true;
                        descendant:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil);
                    end;
                elseif descendant:IsA("Texture") then
                    local Attribute = descendant:GetAttribute("_InspectPrevTransparency");

                    if Attribute == nil then
                        descendant.Transparency = 0.3;
                    else
                        descendant.Transparency = Attribute;
                        descendant:SetAttribute("_InspectPrevTransparency", nil);
                    end;
                end;
            end;
        end;
    end;

    u17 = {};
end;

local function restoreMenuFrames() -- Line: 1787
    -- upvalues: MenuState (copy), u13 (ref), MenuSceneController (copy), hideOtherMenuScreens (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if not (MenuFrame and MenuFrame.Visible) then
        u13 = false;
        MenuState.ExitInspect();

        return;
    end;

    local v221 = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");

    if v221 and v221:IsA("GuiObject") then
        local MobileButtons = v221:FindFirstChild("MobileButtons");
        v221.Visible = false;

        if MobileButtons then
            MobileButtons.Visible = false;
        end;
    end;

    local ScreenBeforeInspect = MenuState.GetScreenBeforeInspect();
    local v222 = u13;
    u13 = false;
    MenuState.ExitInspect();

    if v222 then
        MenuSceneController.ShowMenuScene();
        MenuSceneController.SetMusicVolumeMultiplier(1, 0.5);
    end;

    local Top = MenuFrame:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    if ScreenBeforeInspect then
        local v223 = MenuFrame:FindFirstChild(ScreenBeforeInspect);

        if v223 then
            hideOtherMenuScreens(MenuFrame, ScreenBeforeInspect);
            v223.Visible = true;

            if MenuState.IsCaseSceneActive() and ScreenBeforeInspect == "Store" or MenuState.IsSceneScreen(ScreenBeforeInspect) then
                MenuState.SetBlurEnabled(false);
                MenuFrame.BackgroundTransparency = 1;
                local Pattern = MenuFrame:FindFirstChild("Pattern");

                if Pattern then
                    Pattern.Visible = false;
                end;
            else
                local v224;

                if ScreenBeforeInspect == "Dashboard" then
                    v224 = false;
                else
                    v224 = ScreenBeforeInspect ~= "Play";
                end;

                local v225 = not v224;
                MenuState.SetBlurEnabled(v224);
                MenuFrame.BackgroundTransparency = v224 and 0.15 or 1;
                local Pattern = MenuFrame:FindFirstChild("Pattern");

                if Pattern then
                    Pattern.Visible = v225;
                end;
            end;
        end;
    else
        hideOtherMenuScreens(MenuFrame, "Dashboard");
        local Dashboard = MenuFrame:FindFirstChild("Dashboard");

        if Dashboard then
            Dashboard.Visible = true;
        end;

        MenuState.SetBlurEnabled(false);
        MenuFrame.BackgroundTransparency = 1;
        local Pattern = MenuFrame:FindFirstChild("Pattern");

        if Pattern then
            Pattern.Visible = true;
        end;
    end;
end;

local function abortInspectScene(p226: string) -- Line: 1854
    -- upvalues: u16 (ref), ReplicatedStorage (copy), u11 (ref), SceneLighting (copy), restoreMenuFrames (copy)
    warn(p226);

    if u16 then
        u16.Parent = ReplicatedStorage;
        u16 = nil;
    end;

    u11 = SceneLighting.RestoreMap(nil, u11);
    restoreMenuFrames();
end;

local function resetInspectView(p227: number) -- Line: 1866
    -- upvalues: u29 (ref), u30 (ref), u31 (ref), u32 (ref), u27 (ref), u28 (ref)
    u29 = 0;
    u30 = 0;
    u31 = 0;
    u32 = 0;
    u27 = p227;
    u28 = p227;
end;

function u1.ShowInspect(p228) -- Line: 1878
    -- upvalues: u22 (ref), u1 (copy), Router (copy), u36 (ref), u37 (ref), u9 (ref), u38 (ref), u19 (ref), GetWeaponProperties (copy), hideMenuFrames (copy), hideViewmodels (copy), updateCharmFrameVisibility (copy), updateInspectFrameUI (copy), u12 (ref), restoreMenuFrames (copy), u16 (ref), activateInspectSceneFlags (copy), u15 (ref), Lighting (copy), u11 (ref), SceneLighting (copy), ReplicatedStorage (copy), InputController (copy), setupViewmodelInspect (copy), setupWeaponInspect (copy), DEFAULT_CAMERA_FOV (copy), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u27 (ref), u28 (ref), workspace_CurrentCamera (copy), CameraController (copy), u18 (copy), RunServiceController (copy), UserInputService (copy), u7 (ref), u14 (ref), CFrame_Angles_ret (copy), u8 (ref), u26 (ref), Vector2_zero (ref), LocalPlayer (copy), u34 (ref), u35 (ref), getPinchDistance (copy), MenuState (copy), u3 (copy), refreshInspectTips (copy)
    if u22 then
        u1.HideInspect();
    end;

    if Router.broadcastRouter("HasPendingCharmAttachment") then
        u36 = p228;
        u37 = 1;
    else
        u36 = nil;
    end;

    u9 = p228;
    u38 = false;
    local v229;

    if p228 == nil then
        v229 = false;
    elseif p228.Type == "Glove" then
        v229 = true;
    else
        local v230;

        if p228.Name then
            local success, result = pcall(GetWeaponProperties, p228.Name);

            if success and result then
                v230 = result.Class;
            else
                v230 = nil;
            end;
        else
            v230 = nil;
        end;

        v229 = v230 == "Glove";
    end;

    u19 = v229 and "Viewmodel" or "Weapon";
    hideMenuFrames();
    hideViewmodels();
    updateCharmFrameVisibility();
    updateInspectFrameUI(p228);

    if not u12 then
        warn("[InspectController]: No preloaded inspect scene available");
        restoreMenuFrames();

        return;
    end;

    if u12.Parent ~= workspace then
        u12.Parent = workspace;
    end;

    u16 = u12;
    activateInspectSceneFlags(u16);

    if u15 then
        local v231 = u15;
        local v232 = Lighting:FindFirstChild(v231) or Lighting:FindFirstChild("Menu");

        if v232 then
            u11 = SceneLighting.ApplyScene(v231, v232);
        end;
    end;

    local u233;

    if u16 then
        u233 = u16:FindFirstChild("CamPart");
    else
        u233 = nil;
    end;

    if not u233 then
        warn("[InspectController]: Inspect scene missing CamPart");

        if u16 then
            u16.Parent = ReplicatedStorage;
            u16 = nil;
        end;

        u11 = SceneLighting.RestoreMap(nil, u11);
        restoreMenuFrames();

        return;
    end;

    if not (u16 and u16:FindFirstChild("WeaponPart")) then
        warn("[InspectController]: Inspect scene missing WeaponPart");

        if u16 then
            u16.Parent = ReplicatedStorage;
            u16 = nil;
        end;

        u11 = SceneLighting.RestoreMap(nil, u11);
        restoreMenuFrames();

        return;
    end;

    if u19 == "Viewmodel" then
        InputController.disableGroup("Gameplay");
        setupViewmodelInspect(p228);
    else
        InputController.enableGroup("Gameplay");
        setupWeaponInspect(p228);
    end;

    local v234 = u19 ~= "Viewmodel" and 40 or DEFAULT_CAMERA_FOV;
    u29 = 0;
    u30 = 0;
    u31 = 0;
    u32 = 0;
    u27 = v234;
    u28 = v234;
    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CFrame = u233.CFrame;
    workspace_CurrentCamera.Focus = u233.CFrame;
    CameraController.updateCameraFOV(u19 ~= "Viewmodel" and 40 or DEFAULT_CAMERA_FOV);
    CameraController.setForceLockOverride("Inspect", true);
    u18:Add(RunServiceController.BindToRenderStep("InspectController.CameraUpdate", function(p235) -- Line: 1950
        -- upvalues: u27 (ref), u28 (ref), u16 (ref), u233 (copy), workspace_CurrentCamera (ref), CameraController (ref), u19 (ref), UserInputService (ref), u32 (ref), u31 (ref), u7 (ref), u29 (ref), u30 (ref), u14 (ref), CFrame_Angles_ret (ref), u8 (ref)
        local math_min_ret = math.min(1, p235 * 8);
        u27 = u27 + (u28 - u27) * math_min_ret;

        if u16 and u233 then
            workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
            workspace_CurrentCamera.CFrame = u233.CFrame;
            workspace_CurrentCamera.Focus = u233.CFrame;
            workspace_CurrentCamera.FieldOfView = CameraController.clampFOV(u27);
        end;

        if u19 == "Weapon" and UserInputService.GamepadEnabled then
            local LastInputType = UserInputService:GetLastInputType();
            local GamepadState = UserInputService:GetGamepadState((LastInputType == Enum.UserInputType.Gamepad1 or (LastInputType == Enum.UserInputType.Gamepad2 or (LastInputType == Enum.UserInputType.Gamepad3 or LastInputType == Enum.UserInputType.Gamepad4))) and LastInputType and LastInputType or Enum.UserInputType.Gamepad1);

            if GamepadState then
                for _, v in pairs(GamepadState) do
                    if v.KeyCode == Enum.KeyCode.Thumbstick2 then
                        local Vector2_new_ret = Vector2.new(v.Position.X, v.Position.Y);

                        if Vector2_new_ret.Magnitude > 0.1 then
                            local Vector2_new_ret2 = Vector2.new(Vector2_new_ret.X * 0.5 * 60 * p235 * 4.75, Vector2_new_ret.Y * 0.5 * 60 * p235 * 4.75);
                            u32 = u32 + Vector2_new_ret2.X * 0.5;
                            u31 = math.clamp(u31 + Vector2_new_ret2.Y * 0.5, -80, 80);
                        end;
                    elseif (v.KeyCode == Enum.KeyCode.ButtonR2 or v.KeyCode == Enum.KeyCode.ButtonL2) and v.Position.Z > 0.1 then
                        local v236;

                        if v.KeyCode == Enum.KeyCode.ButtonR2 then
                            v236 = -v.Position.Z;
                        else
                            v236 = v.Position.Z;
                        end;

                        local v237 = v236 * 2 * 30 * p235 * 0.55;

                        if u19 ~= "Viewmodel" then
                            u28 = math.clamp(u28 - v237 * 2, 20, 70);
                        end;
                    end;
                end;
            end;
        end;

        if u19 == "Viewmodel" and u7 then
            u7:render(p235);

            return;
        end;

        if u19 == "Weapon" then
            local math_min_ret2 = math.min(1, p235 * 10);
            u29 = u29 + (u31 - u29) * math_min_ret2;
            u30 = u30 + (u32 - u30) * math_min_ret2;

            if u14 then
                if not u16 then
                    return;
                end;

                local WeaponPart = u16:FindFirstChild("WeaponPart");

                if WeaponPart then
                    local CFrame_Angles_ret2 = CFrame.Angles(0, math.rad(u30), (math.rad(u29)));
                    local v238 = u14;
                    local v239 = WeaponPart.CFrame * CFrame_Angles_ret2 * CFrame_Angles_ret;

                    if u8 then
                        v239 = v239 * v238:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
                    end;

                    v238:PivotTo(v239);
                end;
            end;
        end;
    end), "Disconnect", "CameraUpdate");
    u18:Add(UserInputService.InputBegan:Connect(function(p240, p241) -- Line: 2026
        -- upvalues: u26 (ref), Vector2_zero (ref), InputController (ref), LocalPlayer (ref), u1 (ref), u34 (ref), u35 (ref), getPinchDistance (ref)
        if p240.UserInputType == Enum.UserInputType.MouseButton1 then
            u26 = true;
            Vector2_zero = Vector2.new(p240.Position.X, p240.Position.Y);
        end;

        if table.find(InputController.getActionKeybinds("Inspect"), p240.KeyCode) then
            if LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            u1.PlayInspectAnimation();
        end;

        if table.find(InputController.getActionKeybinds("Reload"), p240.KeyCode) then
            if LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            u1.CancelInspectAnimation();
        end;

        if p240.UserInputType == Enum.UserInputType.Touch then
            u34[p240] = Vector2.new(p240.Position.X, p240.Position.Y);
            local v242 = 0;

            for _ in pairs(u34) do
                v242 = v242 + 1;
            end;

            if v242 == 1 then
                u26 = true;
                Vector2_zero = Vector2.new(p240.Position.X, p240.Position.Y);
            end;

            u35 = getPinchDistance();
        end;
    end), "Disconnect", "InputBegan");
    u18:Add(UserInputService.InputChanged:Connect(function(p243, p244) -- Line: 2061
        -- upvalues: u26 (ref), Vector2_zero (ref), u32 (ref), u31 (ref), u34 (ref), getPinchDistance (ref), u35 (ref), u19 (ref), u28 (ref)
        if p243.UserInputType == Enum.UserInputType.MouseMovement and u26 then
            local Vector2_new_ret = Vector2.new(p243.Position.X, p243.Position.Y);
            local v245 = Vector2_new_ret - Vector2_zero;
            u32 = u32 + v245.X * 0.5;
            u31 = math.clamp(u31 + v245.Y * 0.5, -80, 80);
            Vector2_zero = Vector2_new_ret;
        end;

        if p243.UserInputType == Enum.UserInputType.Touch then
            local Vector2_new_ret = Vector2.new(p243.Position.X, p243.Position.Y);
            u34[p243] = Vector2_new_ret;
            local v246 = 0;

            for _ in pairs(u34) do
                v246 = v246 + 1;
            end;

            if v246 == 1 and u26 then
                local v247 = Vector2_new_ret - Vector2_zero;
                u32 = u32 + v247.X * 0.5;
                u31 = math.clamp(u31 + v247.Y * 0.5, -80, 80);
                Vector2_zero = Vector2_new_ret;
            end;

            if v246 >= 2 then
                local v248 = getPinchDistance();

                if v248 and u35 then
                    local v249 = (v248 - u35) * 0.01;

                    if u19 ~= "Viewmodel" then
                        u28 = math.clamp(u28 - v249 * 2, 20, 70);
                    end;
                end;

                u35 = v248;
            end;
        end;

        if p243.UserInputType == Enum.UserInputType.MouseWheel then
            if u19 == "Viewmodel" then
                return;
            end;

            u28 = math.clamp(u28 - p243.Position.Z * 2, 20, 70);
        end;
    end), "Disconnect", "InputChanged");
    u18:Add(UserInputService.InputEnded:Connect(function(p250, p251) -- Line: 2102
        -- upvalues: u26 (ref), u34 (ref), u35 (ref), getPinchDistance (ref)
        if p250.UserInputType == Enum.UserInputType.MouseButton1 then
            u26 = false;
        end;

        if p250.UserInputType == Enum.UserInputType.Touch then
            u34[p250] = nil;
            local v252 = 0;

            for _ in pairs(u34) do
                v252 = v252 + 1;
            end;

            if v252 == 0 then
                u26 = false;
            end;

            u35 = getPinchDistance();
        end;
    end), "Disconnect", "InputEnded");
    u18:Add(function() -- Line: 2119
        -- upvalues: u14 (ref), u8 (ref), u16 (ref), u12 (ref), ReplicatedStorage (ref), u26 (ref), u34 (ref), u35 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u27 (ref), u28 (ref)
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        u8 = nil;

        if u16 then
            if u16 == u12 then
                u16.Parent = ReplicatedStorage;
            else
                u16:Destroy();
            end;

            u16 = nil;
        end;

        u26 = false;
        u34 = {};
        u35 = nil;
        u29 = 0;
        u30 = 0;
        u31 = 0;
        u32 = 0;
        u27 = 40;
        u28 = 40;
    end, true, "InspectCleanup");
    u22 = true;
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("MobileButtons");
    end;

    local v253;

    if MenuFrame then
        v253 = MenuFrame:FindFirstChild("Inspect");
    else
        v253 = MenuFrame;
    end;

    if v253 then
        local v254 = u22;

        if v254 then
            if u19 == "Viewmodel" then
                v254 = u3;
            else
                v254 = false;
            end;
        end;

        MenuFrame.Visible = v254;
        v253.Visible = v254;
    end;

    refreshInspectTips();
end;

function u1.HideInspect(p255: boolean?) -- Line: 2143
    -- upvalues: u22 (ref), u21 (ref), u18 (copy), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), u14 (ref), u8 (ref), MenuState (copy), CaseSceneController (copy), u11 (ref), SceneLighting (copy), workspace_CurrentCamera (copy), CameraController (copy), Constants (copy), restoreMenuFrames (copy), u13 (ref), showViewmodels (copy), u17 (ref), u36 (ref), u37 (ref), u19 (ref), u3 (copy), refreshInspectTips (copy)
    if not u22 then
        return;
    end;

    u21 = nil;
    u18:Cleanup();

    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:destroy();
        u7 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    InputController.enableGroup("Gameplay");

    if u14 then
        u14:Destroy();
        u14 = nil;
    end;

    u8 = nil;

    if MenuState.IsCaseSceneActive() then
        CaseSceneController.ApplyCaseSceneLighting();
    else
        u11 = SceneLighting.RestoreMap(nil, u11);
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Custom;
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    CameraController.setForceLockOverride("Inspect", false);

    if p255 then
        MenuState.ExitInspect();
        u13 = false;
    else
        restoreMenuFrames();
    end;

    if MenuState.IsCaseSceneActive() then
        u17 = {};
    else
        showViewmodels();
    end;

    u36 = nil;
    u37 = 1;
    u22 = false;
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("MobileButtons");
    end;

    local v256;

    if MenuFrame then
        v256 = MenuFrame:FindFirstChild("Inspect");
    else
        v256 = MenuFrame;
    end;

    if v256 then
        local v257 = u22;

        if v257 then
            if u19 == "Viewmodel" then
                v257 = u3;
            else
                v257 = false;
            end;
        end;

        MenuFrame.Visible = v257;
        v256.Visible = v257;
    end;

    refreshInspectTips();
end;

function u1.IsActive() -- Line: 2193
    -- upvalues: u22 (ref)
    return u22;
end;

function u1.CycleCharmPosition() -- Line: 2199
    -- upvalues: u22 (ref), u36 (ref), u37 (ref), u1 (copy)
    if not (u22 and u36) then
        return;
    end;

    u37 = u37 % 4 + 1;
    u1.RefreshWeaponWithCharm((tostring(u37)));
end;

function u1.RefreshWeaponWithCharm(p258: string) -- Line: 2212
    -- upvalues: u22 (ref), u16 (ref), u36 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u19 (ref), u14 (ref), u8 (ref), Skins (copy), prepareInspectWeapon (copy), CFrame_Angles_ret (copy), u7 (ref), u10 (ref)
    if not (u22 and (u16 and u36)) then
        return;
    end;

    local v259 = u16;
    local v260 = u36;

    if not v259:FindFirstChild("WeaponPart") then
        return;
    end;

    local v261 = u29;
    local v262 = u30;
    local v263 = u31;
    local v264 = u32;
    local Charm = v260.Charm;
    local v265 = type(Charm) == "table" and {
        _id = Charm._id,
        Position = p258
    } or p258;

    if u19 == "Weapon" then
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        u8 = nil;
        local CharacterModel = Skins.GetCharacterModel(v260.Name, v260.Skin, v260.Float, v260.StatTrack, v260.NameTag, v265, v260.Stickers);

        if not CharacterModel then
            warn((`[InspectController]: Failed to refresh weapon model for charm position {p258}`));

            return;
        end;

        prepareInspectWeapon(CharacterModel, false);
        CharacterModel.Parent = v259;
        u29 = v261;
        u30 = v262;
        u31 = v263;
        u32 = v264;
        local v266 = u14 and u16 and u16:FindFirstChild("WeaponPart");

        if v266 then
            local CFrame_Angles_ret2 = CFrame.Angles(0, math.rad(u30), (math.rad(u29)));
            local v267 = u14;
            local v268 = v266.CFrame * CFrame_Angles_ret2 * CFrame_Angles_ret;

            if u8 then
                v268 = v268 * v267:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
            end;

            v267:PivotTo(v268);
        end;
    end;

    if u7 and u10 then
        u7.Charm = v265;
        u7:construct(u10, nil);
    end;
end;

function u1.PlayInspectAnimation() -- Line: 2279
    -- upvalues: u19 (ref), u7 (ref), u9 (ref), GetWeaponProperties (copy), u5 (ref)
    if u19 ~= "Viewmodel" or not u7 then
        return;
    end;

    local v269 = u9;
    local v270;

    if v269 == nil then
        v270 = false;
    elseif v269.Type == "Glove" then
        v270 = true;
    else
        local v271;

        if v269.Name then
            local success, result = pcall(GetWeaponProperties, v269.Name);

            if success and result then
                v271 = result.Class;
            else
                v271 = nil;
            end;
        else
            v271 = nil;
        end;

        v270 = v271 == "Glove";
    end;

    if not v270 then
        if u7.Animation then
            local v272 = u7.Animation:pickInspectVariant();
            u7.Animation:stopAnimations();
            u7.Animation:play("Idle");
            u7.Animation:play(v272);
        end;

        return;
    end;

    if not u5 then
        return;
    end;

    if u7 and u7.Animation then
        u7.Animation:stopAnimations();
    end;

    if u5.IsPlaying then
        u5:Stop(0);
    end;

    u5.TimePosition = 0;
    u5:Play(0, 1, 1);
end;

function u1.CancelInspectAnimation() -- Line: 2296
    -- upvalues: u19 (ref), u7 (ref), u9 (ref), GetWeaponProperties (copy), u5 (ref)
    if u19 ~= "Viewmodel" or not u7 then
        return;
    end;

    local v273 = u9;
    local v274;

    if v273 == nil then
        v274 = false;
    elseif v273.Type == "Glove" then
        v274 = true;
    else
        local v275;

        if v273.Name then
            local success, result = pcall(GetWeaponProperties, v273.Name);

            if success and result then
                v275 = result.Class;
            else
                v275 = nil;
            end;
        else
            v275 = nil;
        end;

        v274 = v275 == "Glove";
    end;

    if v274 then
        if u5 and u5.IsPlaying then
            u5:Stop(0.25);
        end;
    elseif u7.Animation then
        u7.Animation:markInspectCancel();
        u7.Animation:crossfadeTo("Idle", 0.25);
    end;
end;

function u1.Initialize() -- Line: 2314
    -- upvalues: DataController (copy), LocalPlayer (copy), SceneLighting (copy), u11 (ref), refreshInspectTips (copy), UserInputService (copy), getRandomInspectScene (copy), u15 (ref), u12 (ref), ReplicatedStorage (copy), u22 (ref), u1 (copy), Router (copy), u37 (ref)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 2315
        -- upvalues: SceneLighting (ref), u11 (ref)
        SceneLighting.ApplyGlobalShadows(u11);
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", refreshInspectTips);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(refreshInspectTips);
    local v276 = getRandomInspectScene();

    if v276 then
        u15 = v276.Name;
        u12 = v276;
        v276.Name = "InspectScene";
        v276.Parent = ReplicatedStorage;
    else
        warn("[InspectController]: No inspect scene found to preload in ReplicatedStorage.Assets.InspectScenes");
    end;

    UserInputService.InputBegan:Connect(function(p277, p278) -- Line: 2336
        -- upvalues: u22 (ref), u1 (ref)
        if p278 then
            return;
        end;

        if p277.KeyCode == Enum.KeyCode.Escape and u22 then
            u1.HideInspect();
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 2346
        -- upvalues: u22 (ref), u1 (ref)
        if u22 then
            u1.HideInspect();
        end;
    end);
    Router.observerRouter("WeaponInspect", function(p279: string, p280: string, p281: number?, p282: any, p283: any, p284: any, p285: table?, p286: string?, p287: number?, p288: string?, p289: number?, p290: boolean?, p291: boolean?, p292: boolean?) -- Line: 2354
        -- upvalues: ReplicatedStorage (ref), u1 (ref)
        if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
            return;
        end;

        u1.ShowInspect({
            _id = p288 or "inspect_" .. p279 .. "_" .. p280,
            Name = p279,
            Skin = p280,
            Float = p281,
            StatTrack = p282,
            NameTag = p283,
            Charm = p284,
            Stickers = p285,
            Type = p286,
            Pattern = p287,
            Serial = p289,
            IsTradeable = p290,
            HideWearDetails = p291,
            ShowFullPriceRange = p292
        });
    end);
    Router.observerRouter("WeaponInspectClose", function() -- Line: 2397
        -- upvalues: u1 (ref)
        u1.HideInspect();
    end);
    Router.observerRouter("WeaponInspectCloseForGameEnd", function() -- Line: 2402
        -- upvalues: u1 (ref)
        u1.HideInspect(true);
    end);
    Router.observerRouter("IsInspectActive", function() -- Line: 2406
        -- upvalues: u22 (ref)
        return u22;
    end);
    Router.observerRouter("GetCurrentCharmPosition", function() -- Line: 2410
        -- upvalues: u37 (ref)
        return u37;
    end);
end;

function u1.Start() -- Line: 2415
    -- upvalues: initializeInspectButtons (copy)
    initializeInspectButtons();
end;

return u1;