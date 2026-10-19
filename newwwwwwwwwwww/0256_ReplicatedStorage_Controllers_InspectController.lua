-- InspectController (ModuleScript)
-- full path: ReplicatedStorage.Controllers.InspectController

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

local function isPointerOverButton(p52: vector) -- Line: 254
    -- upvalues: PlayerGui (copy)
    for _, v in PlayerGui:GetGuiObjectsAtPosition(p52.X, p52.Y) do
        if v:IsA("GuiButton") and (v.Visible and v.Active) then
            return true;
        end;
    end;

    return false;
end;

local function handleDragInput(p53) -- Line: 265
    -- upvalues: u32 (ref), u31 (ref)
    u32 = u32 + p53.X * 0.5;
    u31 = math.clamp(u31 + p53.Y * 0.5, -80, 80);
end;

local function handleFOVInput(p54: number) -- Line: 273
    -- upvalues: u19 (ref), u28 (ref)
    if u19 == "Viewmodel" then
        return;
    end;

    u28 = math.clamp(u28 - p54 * 2, 20, 70);
end;

local function getTouchCount() -- Line: 284
    -- upvalues: u34 (ref)
    local v55 = 0;

    for _ in pairs(u34) do
        v55 = v55 + 1;
    end;

    return v55;
end;

local function getPinchDistance() -- Line: 294
    -- upvalues: u34 (ref)
    local v56 = {};

    for _, v in pairs(u34) do
        table.insert(v56, v);
    end;

    if #v56 >= 2 then
        return (v56[1] - v56[2]).Magnitude;
    end;

    return nil;
end;

local function getInspectFrame() -- Line: 307
    -- upvalues: MenuState (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    return MenuFrame;
end;

local function setMenuBackdrop(p57: userdata, p58: boolean, p59: boolean) -- Line: 314
    -- upvalues: MenuState (copy)
    MenuState.SetBlurEnabled(p58);
    p57.BackgroundTransparency = p58 and 0.15 or 1;
    local Pattern = p57:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = p59;
    end;
end;

local function hideOtherMenuScreens(p60: userdata, p61: string) -- Line: 326
    for _, child in ipairs(p60:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= p61 and (child.Name ~= "Inspect" and child.Name ~= "InspectFrame"))) then
            child.Visible = false;
        end;
    end;
end;

local function hideMenuFrames() -- Line: 342
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

local function getFloatPreviewClosedPosition(p62: userdata, p63: userdata) -- Line: 373
    local Position = p62.Position;

    return UDim2.new(-(p62.Size.X.Scale * p63.Position.X.Scale), -(p62.Size.X.Offset + p63.Position.X.Offset), Position.Y.Scale, Position.Y.Offset);
end;

local function setFloatPreviewArrowDirection(p64: userdata, p65: boolean) -- Line: 383
    local TextLabel = p64:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Rotation = p65 and 0 or 180;
    end;
end;

local function storeFloatPreviewOpenPosition(p66: userdata) -- Line: 392
    local Position = p66.Position;
    p66:SetAttribute("OpenPositionXScale", Position.X.Scale);
    p66:SetAttribute("OpenPositionXOffset", Position.X.Offset);
    p66:SetAttribute("OpenPositionYScale", Position.Y.Scale);
    p66:SetAttribute("OpenPositionYOffset", Position.Y.Offset);
end;

local function getStoredFloatPreviewOpenPosition(p67: userdata) -- Line: 402
    return UDim2.new(p67:GetAttribute("OpenPositionXScale") or p67.Position.X.Scale, p67:GetAttribute("OpenPositionXOffset") or p67.Position.X.Offset, p67:GetAttribute("OpenPositionYScale") or p67.Position.Y.Scale, p67:GetAttribute("OpenPositionYOffset") or p67.Position.Y.Offset);
end;

local function bindClickButton(p68: userdata, p69: string, p70: function) -- Line: 413
    -- upvalues: ActivateButton (copy)
    local v71 = p68:FindFirstChild(p69);

    if v71 and v71:IsA("GuiButton") then
        ActivateButton(v71);
        v71.MouseButton1Click:Connect(p70);
    end;
end;

local function initializeInspectButtons() -- Line: 423
    -- upvalues: MenuState (copy), ActivateButton (copy), CloseButtonRegistry (copy), u1 (copy), storeFloatPreviewOpenPosition (copy), getFloatPreviewClosedPosition (copy), TweenService (copy), TweenInfo_new_ret (copy), DataController (copy), LocalPlayer (copy), Mobile (copy), ApplyMobileButtonLayout (copy), Router (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    local v72;

    if MenuFrame then
        v72 = MenuFrame:FindFirstChild("Bottom");
    else
        v72 = MenuFrame;
    end;

    if not v72 then
        return;
    end;

    local Close = v72.Container.Buttons:FindFirstChild("Close");

    if Close and Close:IsA("GuiButton") then
        ActivateButton(Close);
        CloseButtonRegistry.Add(MenuFrame, Close, function() -- Line: 433
            -- upvalues: u1 (ref)
            u1.HideInspect();
        end);
    end;

    local Middle = v72:FindFirstChild("Middle");

    if Middle then
        Middle = Middle:FindFirstChild("Buttons");
    end;

    if Middle then
        for _, v in ipairs({ "Viewmodel", "Weapon" }) do
            local v73 = Middle:FindFirstChild(v);

            if v73 and v73:IsA("GuiButton") then
                ActivateButton(v73);
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
            local u74 = getFloatPreviewClosedPosition(FloatPreviews, ToggleButton);
            FloatPreviews:SetAttribute("IsOpen", true);
            local TextLabel = ToggleButton:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Rotation = 0;
            end;

            local u75 = nil;
            ToggleButton.Activated:Connect(function() -- Line: 464
                -- upvalues: FloatPreviews (copy), ToggleButton (copy), u75 (ref), TweenService (ref), TweenInfo_new_ret (ref), Position (copy), u74 (copy)
                local v76 = FloatPreviews:GetAttribute("IsOpen") == false;
                FloatPreviews:SetAttribute("IsOpen", v76);
                local TextLabel2 = ToggleButton:FindFirstChild("TextLabel");

                if TextLabel2 and TextLabel2:IsA("TextLabel") then
                    TextLabel2.Rotation = v76 and 0 or 180;
                end;

                if u75 then
                    u75:Cancel();
                end;

                local v77 = {};
                local v78;

                if v76 then
                    v78 = Position;
                else
                    v78 = u74;
                end;

                v77.Position = v78;
                local v79 = TweenService:Create(FloatPreviews, TweenInfo_new_ret, v77);
                u75 = v79;
                v79:Play();
            end);
        end;
    end;

    local MobileButtons = MenuFrame:FindFirstChild("MobileButtons");

    if MobileButtons then
        local Inspect = MobileButtons:FindFirstChild("Inspect");

        if Inspect and Inspect:IsA("TextButton") then
            ActivateButton(Inspect);
            Inspect.MouseButton1Click:Connect(function() -- Line: 488
                -- upvalues: u1 (ref)
                u1.PlayInspectAnimation();
            end);
            local v80 = DataController.Get(LocalPlayer, "MobileButtons");
            local Inspect2 = Mobile.SanitizeLayout(v80).Inspect;

            if Inspect2 then
                ApplyMobileButtonLayout(Inspect, Inspect2);
            end;
        end;

        MobileButtons.Visible = false;
    end;

    local Charm = v72.Middle:FindFirstChild("Charm");

    if Charm then
        local function v81() -- Line: 504
            -- upvalues: u1 (ref)
            u1.CycleCharmPosition();
        end;

        local Next = Charm:FindFirstChild("Next");

        if Next and Next:IsA("GuiButton") then
            ActivateButton(Next);
            Next.MouseButton1Click:Connect(v81);
        end;

        local function v82() -- Line: 507
            -- upvalues: Router (ref)
            Router.broadcastRouter("ConfirmCharmAttachment");
        end;

        local Confirm = Charm:FindFirstChild("Confirm");

        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm);
            Confirm.MouseButton1Click:Connect(v82);
        end;
    end;
end;

local function updateInspectMobileButtonsVisibility() -- Line: 515
    -- upvalues: MenuState (copy), u22 (ref), u19 (ref), u3 (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("MobileButtons");
    end;

    local v83;

    if MenuFrame then
        v83 = MenuFrame:FindFirstChild("Inspect");
    else
        v83 = MenuFrame;
    end;

    if not v83 then
        return;
    end;

    local v84 = u22;

    if v84 then
        if u19 == "Viewmodel" then
            v84 = u3;
        else
            v84 = false;
        end;
    end;

    MenuFrame.Visible = v84;
    v83.Visible = v84;
end;

local function getItemClass(p85) -- Line: 529
    -- upvalues: GetWeaponProperties (copy)
    if p85.Name then
        local success, result = pcall(GetWeaponProperties, p85.Name);

        if success and result then
            return result.Class;
        end;
    end;

    return nil;
end;

local function isGloveInventoryItem(p86) -- Line: 541
    -- upvalues: GetWeaponProperties (copy)
    local v87;

    if p86 == nil then
        v87 = false;
    elseif p86.Type == "Glove" then
        v87 = true;
    else
        local v88;

        if p86.Name then
            local success, result = pcall(GetWeaponProperties, p86.Name);

            if success and result then
                v88 = result.Class;
            else
                v88 = nil;
            end;
        else
            v88 = nil;
        end;

        v87 = v88 == "Glove";
    end;

    return v87;
end;

local u89 = { {
        Name = "Inspect",
        Action = "Inspect",
        Title = "Inspect"
    }, {
        Name = "Cancel",
        Action = "Reload",
        Title = "Cancel"
    } };

local function refreshInspectTips() -- Line: 557
    -- upvalues: MenuState (copy), ReplicatedStorage (copy), u22 (ref), u19 (ref), UserInputService (copy), u89 (copy), u9 (ref), GetWeaponProperties (copy)
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
        local v90 = MenuFrame:FindFirstChildOfClass("UIListLayout");

        if v90 then
            v90.HorizontalAlignment = Enum.HorizontalAlignment.Right;
        end;

        for _, child in MenuFrame:GetChildren() do
            if child:IsA("GuiObject") then
                Tips.MirrorRow(child);
            end;
        end;
    end;

    local v91 = u22;

    if v91 then
        if u19 == "Viewmodel" then
            v91 = UserInputService.PreferredInput ~= Enum.PreferredInput.Touch;
        else
            v91 = false;
        end;
    end;

    local v92 = false;

    for _, v in u89 do
        local v93 = MenuFrame:FindFirstChild(v.Name);

        if v93 and v93:IsA("GuiObject") then
            local Title = v93:FindFirstChild("Title");

            if Title and Title:IsA("TextLabel") then
                Title.Text = v.Title;
            end;

            local Keybind = v93:FindFirstChild("Keybind");

            if Keybind and Keybind:IsA("GuiObject") then
                Keybind.Selectable = false;
            end;

            local v94;

            if v.Name == "Cancel" then
                local v95 = u9;

                if v95 == nil then
                    v94 = false;
                elseif v95.Type == "Glove" then
                    v94 = true;
                else
                    local v96;

                    if v95.Name then
                        local success, result = pcall(GetWeaponProperties, v95.Name);

                        if success and result then
                            v96 = result.Class;
                        else
                            v96 = nil;
                        end;
                    else
                        v96 = nil;
                    end;

                    v94 = v96 == "Glove";
                end;
            else
                v94 = false;
            end;

            local v97 = not v94;

            if v91 then
                if v97 then
                    if Keybind == nil then
                        v97 = false;
                    else
                        v97 = Keybind:IsA("GuiButton") and Tips.ApplyBindingToKeybind(Keybind, Tips.ResolveActionBinding(v.Action));
                    end;
                end;
            else
                v97 = v91;
            end;

            v93.Visible = v97;
            v92 = v92 or v97;
        end;
    end;

    MenuFrame.Visible = v92;
end;

local function updateCharmFrameVisibility() -- Line: 619
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

local function supportsViewmodelInspect(p98) -- Line: 637
    -- upvalues: u24 (copy), GetWeaponProperties (copy)
    local v99;

    if u24[p98.Type] == true then
        v99 = true;
    else
        local v100;

        if p98.Name then
            local success, result = pcall(GetWeaponProperties, p98.Name);

            if success and result then
                v100 = result.Class;
            else
                v100 = nil;
            end;
        else
            v100 = nil;
        end;

        v99 = u24[v100] == true;
    end;

    return v99;
end;

local function cleanupGloveViewmodelInspectAnimation() -- Line: 644
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

local function playGloveViewmodelInspectAnimation() -- Line: 661
    -- upvalues: u5 (ref), u7 (ref)
    if not u5 or u5.IsPlaying then
        return;
    end;

    if u7 and u7.Animation then
        u7.Animation:stopAnimations();
    end;

    u5.TimePosition = 0;
    u5:Play(0, 1, 1);
end;

local function setupGloveViewmodelInspectAnimation() -- Line: 677
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
    local success, result = pcall(function() -- Line: 692
        -- upvalues: Animator (copy), Animation (copy)
        return Animator:LoadAnimation(Animation);
    end);

    if not (success and result) then
        Animation:Destroy();

        return;
    end;

    u6 = Animation;
    u5 = result;

    if u5 then
        if u5.IsPlaying then
            return;
        end;

        if u7 and u7.Animation then
            u7.Animation:stopAnimations();
        end;

        u5.TimePosition = 0;
        u5:Play(0, 1, 1);
    end;
end;

local function resolveInspectViewmodelSkin(p101: string, p102: string?) -- Line: 709
    -- upvalues: Skins (copy)
    local v103 = not (p102 and (p102 ~= "" and p102)) and "Vanilla" or p102;

    for _, v in ipairs({ v103, "Vanilla", "Default" }) do
        if Skins.GetSkinInformation(p101, v) then
            return v;
        end;
    end;

    local AllSkinsForWeapon = Skins.GetAllSkinsForWeapon(p101);

    if AllSkinsForWeapon and (AllSkinsForWeapon[1] and AllSkinsForWeapon[1].skin) then
        return AllSkinsForWeapon[1].skin;
    end;

    return v103;
end;

local function resolveGloveProxyWeapon() -- Line: 727
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

local function clearViewmodelHorizontalOffset(p104) -- Line: 742
    local Stats = p104.Model:FindFirstChild("Stats");

    if Stats then
        Stats = Stats:FindFirstChild("Default");
    end;

    local v105;

    if Stats then
        v105 = Stats.Value;
    else
        v105 = Stats;
    end;

    if typeof(v105) == "Vector3" then
        Stats.Value = Vector3.new(0.05, v105.Y, v105.Z);
    end;
end;

local function cleanupWeaponInspect() -- Line: 754
    -- upvalues: u14 (ref), u8 (ref)
    if u14 then
        u14:Destroy();
        u14 = nil;
    end;

    u8 = nil;
end;

local function cleanupViewmodelInspect() -- Line: 762
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

local function cleanupInspectMode() -- Line: 777
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

local function prepareInspectWeapon(p106: userdata, p107: boolean) -- Line: 787
    -- upvalues: u14 (ref), u8 (ref)
    p106.Name = "InspectWeapon";
    u14 = p106;
    u8 = p106:FindFirstChild("InspectPivot", true);
    local CharmBase = p106:FindFirstChild("CharmBase", true);

    for _, descendant in ipairs(p106:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CastShadow = false;

            if p107 then
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Anchored = p106.PrimaryPart == descendant;
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

local function setupWeaponInspect(p108) -- Line: 817
    -- upvalues: u16 (ref), Skins (copy), prepareInspectWeapon (copy), CFrame_Angles_ret (copy), u8 (ref)
    if not u16 then
        return;
    end;

    local WeaponPart = u16:FindFirstChild("WeaponPart");

    if not WeaponPart then
        warn("[InspectController]: Inspect scene missing WeaponPart");

        return;
    end;

    local v109 = p108.Type == "Glove";
    local v110 = p108.Type == "Charm";
    local v111;

    if v109 then
        local Gloves = Skins.GetGloves(p108.Name, p108.Skin, p108.Float);

        if Gloves and Gloves:IsA("BasePart") then
            v111 = Instance.new("Model");
            v111.Name = p108.Name;
            Gloves.Parent = v111;
            v111.PrimaryPart = Gloves;
        else
            v111 = Gloves;
        end;
    elseif v110 then
        v111 = Skins.GetCharmModel(p108.Skin, p108.Pattern or 1);
    elseif p108.Type == "Badge" then
        v111 = Skins.GetBadgeModel(p108.Skin);
    else
        v111 = Skins.GetInspectModel(p108.Name, p108.Skin, p108.Float, p108.StatTrack, p108.NameTag, p108.Charm, p108.Stickers);
    end;

    if not v111 then
        warn(`[InspectController]: Failed to get model for "{p108.Name}"`, p108);

        return;
    end;

    prepareInspectWeapon(v111, v110);

    if v109 and (p108.Name == "T Glove" or p108.Name == "CT Glove") then
        local v112 = {};

        for _, child in ipairs(v111:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(v112, child);
            end;
        end;

        if #v112 >= 2 then
            local v113 = v111:FindFirstChild("RightGlove") or v112[1];

            for _, v in ipairs(v112) do
                if v ~= v113 then
                    v:Destroy();
                end;
            end;
        end;
    end;

    v111.Parent = u16;
    local v114 = WeaponPart.CFrame * CFrame.identity * CFrame_Angles_ret;

    if u8 then
        v114 = v114 * v111:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
    end;

    v111:PivotTo(v114);
end;

local function setupViewmodelInspect(u115) -- Line: 889
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
    local v116 = LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and "CT" or "T";
    local v117;

    if u115 == nil then
        v117 = false;
    elseif u115.Type == "Glove" then
        v117 = true;
    else
        local v118;

        if u115.Name then
            local success, result = pcall(GetWeaponProperties, u115.Name);

            if success and result then
                v118 = result.Class;
            else
                v118 = nil;
            end;
        else
            v118 = nil;
        end;

        v117 = v118 == "Glove";
    end;

    local v119 = MenuSceneController.CreateStandaloneCharacter(v116);

    if not v119 then
        warn("[InspectController]: Failed to create standalone character for viewmodel");

        return;
    end;

    if v117 then
        local v120 = {
            Name = u115.Name,
            Skin = u115.Skin,
            Float = u115.Float
        };

        if u115._id and u115._id ~= "" then
            v120.SkinIdentifier = u115._id;
        end;

        v119:SetAttribute("EquippedGloves", HttpService:JSONEncode(v120));
    end;

    u10 = v119;
    local Charm = u115.Charm;
    local v121 = Router.broadcastRouter("HasPendingCharmAttachment") and type(Charm) == "table" and {
        _id = Charm._id,
        Position = tostring(u37)
    } or Charm;
    local u122 = {
        Player = LocalPlayer,
        Character = v119,
        StatTrack = u115.StatTrack,
        Stickers = u115.Stickers,
        NameTag = u115.NameTag,
        Float = u115.Float,
        Charm = v121
    };
    local Name = u115.Name;
    local u123;

    if v117 then
        Name = resolveGloveProxyWeapon();
        u123 = "Stock";
    else
        u123 = resolveInspectViewmodelSkin(Name, u115.Skin);
    end;

    u122.ViewmodelCameraWeapon = Name;
    u122.ViewmodelHideWeaponGeometry = v117;
    local success, result = pcall(function() -- Line: 951
        -- upvalues: Viewmodel (ref), u122 (copy), u115 (copy), u123 (ref)
        return Viewmodel.new(u122, u115.Name, u123, true);
    end);

    if not (success and result) then
        warn(`[InspectController]: Failed to create viewmodel ({Name} | {u123})`, result);

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
    u7:equip(v117);

    if not u7.Model then
        return;
    end;

    if u7.Model.Parent ~= workspace_CurrentCamera then
        u7.Model.Parent = workspace_CurrentCamera;
    end;

    if u7.Hidden then
        u7:unhide();
    end;

    if v117 then
        local Stats = u7.Model:FindFirstChild("Stats");

        if Stats then
            Stats = Stats:FindFirstChild("Default");
        end;

        local v124;

        if Stats then
            v124 = Stats.Value;
        else
            v124 = Stats;
        end;

        if typeof(v124) == "Vector3" then
            Stats.Value = Vector3.new(0.05, v124.Y, v124.Z);
        end;

        setupGloveViewmodelInspectAnimation();
    end;

    task.defer(function() -- Line: 983
        -- upvalues: u7 (ref), u25 (ref)
        if not (u7 and u7.Model) then
            return;
        end;

        for _, descendant in ipairs(u7.Model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CastShadow = false;

                if descendant.Name ~= "HumanoidRootPart" and (descendant.Name ~= "ViewmodelLight" and (descendant.Name ~= "MuzzlePart" and descendant.Name ~= "MuzzlePartL")) and descendant.Name ~= "MuzzlePartR" then
                    local v125 = descendant;
                    local v126 = nil;

                    for _, v in ipairs(u25) do
                        v126 = v125:GetAttribute(v);

                        if v126 ~= nil then
                            v125:SetAttribute(v, nil);
                            break;
                        end;
                    end;

                    if v126 == nil then
                        if v125.Transparency >= 1 and (v125.Name == "Right Arm" or v125.Name == "Left Arm") then
                            v125.Transparency = 0;
                        end;
                    else
                        v125.Transparency = v126;
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

local function applyInspectMode(p127: string) -- Line: 1030
    -- upvalues: u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), MenuState (copy), u22 (ref), u3 (copy), refreshInspectTips (copy), setupWeaponInspect (copy), u28 (ref), setupViewmodelInspect (copy), DEFAULT_CAMERA_FOV (copy), u1 (copy)
    local v128 = u9;

    if not v128 then
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

    u19 = p127;
    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");
    end;

    if MenuFrame then
        MenuFrame = MenuFrame:FindFirstChild("MobileButtons");
    end;

    local v129;

    if MenuFrame then
        v129 = MenuFrame:FindFirstChild("Inspect");
    else
        v129 = MenuFrame;
    end;

    if v129 then
        local v130 = u22;

        if v130 then
            if u19 == "Viewmodel" then
                v130 = u3;
            else
                v130 = false;
            end;
        end;

        MenuFrame.Visible = v130;
        v129.Visible = v130;
    end;

    refreshInspectTips();

    if p127 ~= "Weapon" then
        if p127 == "Viewmodel" then
            InputController.disableGroup("Gameplay");
            setupViewmodelInspect(v128);
            u28 = DEFAULT_CAMERA_FOV;
            u1.PlayInspectAnimation();
        end;

        return;
    end;

    setupWeaponInspect(v128);
    u28 = 40;
    InputController.enableGroup("Gameplay");
end;

local function setInspectMode(p131: string) -- Line: 1057
    -- upvalues: u9 (ref), GetWeaponProperties (copy), u19 (ref), u20 (ref), u21 (ref), applyInspectMode (copy), u22 (ref)
    local v132 = u9;

    if not v132 then
        return;
    end;

    local v133;

    if v132 == nil then
        v133 = false;
    elseif v132.Type == "Glove" then
        v133 = true;
    else
        local v134;

        if v132.Name then
            local success, result = pcall(GetWeaponProperties, v132.Name);

            if success and result then
                v134 = result.Class;
            else
                v134 = nil;
            end;
        else
            v134 = nil;
        end;

        v133 = v134 == "Glove";
    end;

    local v135 = v133 and p131 == "Weapon" and "Viewmodel" or p131;

    if u19 == v135 then
        return;
    end;

    if u20 then
        u21 = v135;

        return;
    end;

    u20 = true;

    while v135 do
        local success, result = pcall(applyInspectMode, v135);

        if not success then
            warn(`[InspectController]: Failed to apply inspect mode "{v135}"`, result);
        end;

        v135 = u21;
        u21 = nil;

        if v135 == u19 or not u22 then
            v135 = nil;
        end;
    end;

    u20 = false;
end;

local function tween(p136, p137) -- Line: 1099
    -- upvalues: TweenService (copy)
    if p136 then
        TweenService:Create(p136, TweenInfo.new(0.2), p137):Play();
    end;
end;

local function updateButtonVisuals(p138: string, p139: userdata, p140: boolean) -- Line: 1105
    -- upvalues: u19 (ref), TweenService (copy)
    local HoverFrame = p139:FindFirstChild("HoverFrame");
    local SelectFrame = p139:FindFirstChild("SelectFrame");
    local ImageLabel = p139:FindFirstChild("ImageLabel");
    local v141;

    if u19 == p138 then
        v141 = p138 ~= "Info";
    else
        v141 = false;
    end;

    if v141 then
        local v142 = {
            BackgroundTransparency = 1
        };

        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v142):Play();
        end;

        local v143 = {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(95, 95, 95)
        };

        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v143):Play();
        end;

        local v144 = {
            ImageColor3 = Color3.fromRGB(210, 210, 210)
        };

        if ImageLabel then
            TweenService:Create(ImageLabel, TweenInfo.new(0.2), v144):Play();
        end;
    else
        local v145 = {
            BackgroundTransparency = 1
        };

        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v145):Play();
        end;

        local v146 = {
            ImageColor3 = Color3.fromRGB(255, 255, 255)
        };

        if ImageLabel then
            TweenService:Create(ImageLabel, TweenInfo.new(0.2), v146):Play();
        end;

        local v147 = {
            BackgroundTransparency = p140 and 0 or 1
        };

        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v147):Play();
        end;
    end;
end;

local function refreshAllButtons(p148: table, p149: string) -- Line: 1123
    -- upvalues: updateButtonVisuals (copy)
    for i, v in pairs(p148) do
        if v and v:IsA("GuiButton") then
            updateButtonVisuals(i, v, i == p149);
        end;
    end;
end;

local function formatInfoText(p150: string, p151: string) -- Line: 1131
    return `<b><font color="rgb(175,175,175)">{p150}</font></b>: <font color="rgb(255,255,255)">{p151}</font>`;
end;

local function scaleInfoFrameToFit(p152: userdata, p153: table) -- Line: 1135
    -- upvalues: workspace_CurrentCamera (copy), TextService (copy)
    local math_floor_ret = math.floor(workspace_CurrentCamera.ViewportSize.Y * 0.025);
    local math_clamp_ret = math.clamp(math_floor_ret, 8, 32);
    local v154 = 0;

    for _, v in ipairs(p153) do
        if v and (v:IsA("TextLabel") and v.Text ~= "") then
            v.TextScaled = false;
            local TextSize = TextService:GetTextSize(v.Text:gsub("<[^>]*>", ""), math_clamp_ret, Enum.Font.Gotham, Vector2.new((1 / 0), (1 / 0)));

            if v154 < TextSize.X then
                v154 = TextSize.X;
            end;

            v.TextSize = math_clamp_ret;
            v.TextWrapped = false;
        end;
    end;

    if v154 > 0 then
        p152.Size = UDim2.new(0.05, v154, p152.Size.Y.Scale, p152.Size.Y.Offset);
    end;
end;

local function showInfoFrame(p155: userdata, p156: any, p157: userdata?) -- Line: 1164
    -- upvalues: Skins (copy), scaleInfoFrameToFit (copy)
    local Information = p155:FindFirstChild("Information");

    if not Information then
        return;
    end;

    if p157 then
        Information.Position = UDim2.new(0, p157.AbsolutePosition.X + p157.AbsoluteSize.X / 2 - Information.Parent.AbsolutePosition.X + Information.AbsoluteSize.X / 2, Information.Position.Y.Scale, Information.Position.Y.Offset);
    end;

    Information.Visible = true;
    local SkinInformation = Skins.GetSkinInformation(p156.Name, p156.Skin);
    local v158;

    if SkinInformation then
        local _, v159 = Skins.GetWearNameForFloat(SkinInformation, p156.Float or 0);
        v158 = v159 or "Mint Condition";
    else
        v158 = "Mint Condition";
    end;

    local v160 = p156.Type == "Charm";
    local Exterior = Information:FindFirstChild("Exterior");

    if Exterior then
        Exterior.Visible = not v160;

        if not v160 then
            Exterior.RichText = true;
            Exterior.Text = `<b><font color="rgb(175,175,175)">Exterior</font></b>: <font color="rgb(255,255,255)">{v158}</font>`;
        end;
    end;

    local Tradeable = Information:FindFirstChild("Tradeable");

    if Tradeable then
        Tradeable.RichText = true;
        Tradeable.Text = `<b><font color="rgb(175,175,175)">Tradeable</font></b>: <font color="rgb(255,255,255)">{p156.IsTradeable and "Yes" or "No"}</font>`;
    end;

    local Serial = Information:FindFirstChild("Serial");

    if Serial then
        Serial.RichText = true;
        local Serial2 = p156.Serial;
        Serial.Text = `<b><font color="rgb(175,175,175)">Serial</font></b>: <font color="rgb(255,255,255)">{typeof(Serial2) ~= "number" and "N/A" or `#{tostring(Serial2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`}</font>`;
    end;

    local Pattern = Information:FindFirstChild("Pattern");

    if Pattern then
        if v160 then
            Pattern.Visible = true;
            Pattern.RichText = true;
            Pattern.Text = `<b><font color="rgb(175,175,175)">Pattern</font></b>: <font color="rgb(255,255,255)">{tostring(p156.Pattern or 0)}</font>`;
        elseif p156.Skin:find("PATTERN") then
            local _, v161 = table.unpack(p156.Skin:split("_PATTERN_"));
            Pattern.Text = `<b><font color="rgb(175,175,175)">Pattern</font></b>: <font color="rgb(255,255,255)">{v161}</font>`;
            Pattern.Visible = true;
        else
            Pattern.Visible = false;
        end;
    end;

    local Float = Information:FindFirstChild("Float");

    if Float then
        Float.Visible = not v160;

        if not v160 then
            Float.RichText = true;
            Float.Text = `<b><font color="rgb(175,175,175)">Float</font></b>: <font color="rgb(255,255,255)">{string.format("%.14f", p156.Float or 0)}</font>`;
        end;
    end;

    task.defer(function() -- Line: 1244
        -- upvalues: Exterior (copy), Tradeable (copy), Serial (copy), Pattern (copy), Float (copy), scaleInfoFrameToFit (ref), Information (copy)
        local v162 = {};

        if Exterior and Exterior.Visible then
            table.insert(v162, Exterior);
        end;

        if Tradeable then
            table.insert(v162, Tradeable);
        end;

        if Serial then
            table.insert(v162, Serial);
        end;

        if Pattern and Pattern.Visible then
            table.insert(v162, Pattern);
        end;

        if Float and Float.Visible then
            table.insert(v162, Float);
        end;

        scaleInfoFrameToFit(Information, v162);
    end);
end;

local function hideInfoFrame(p163: userdata) -- Line: 1266
    local Information = p163:FindFirstChild("Information");

    if Information then
        Information.Visible = false;
    end;
end;

local function isStoreOriginInspect() -- Line: 1274
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

    local v164;

    if MainGui == nil then
        v164 = false;
    else
        v164 = MainGui:GetAttribute("WasVisibleBeforeInspect") == true;
    end;

    return v164;
end;

local function shouldHideInfoButton() -- Line: 1291
    -- upvalues: isStoreOriginInspect (copy)
    return isStoreOriginInspect();
end;

local function tryShowInfoFrame(p165: userdata?, p166: userdata) -- Line: 1295
    -- upvalues: u9 (ref), isStoreOriginInspect (copy), showInfoFrame (copy)
    if p165 and (u9 and (not isStoreOriginInspect() and u9.Type ~= "Badge")) then
        showInfoFrame(p165, u9, p166);
    end;
end;

local function setupButtonEvents(u167: userdata, u168: string, u169: table, u170: userdata?) -- Line: 1301
    -- upvalues: u18 (copy), updateButtonVisuals (copy), u9 (ref), isStoreOriginInspect (copy), showInfoFrame (copy), u19 (ref), setInspectMode (copy), refreshAllButtons (copy), u1 (copy)
    u18:Add(u167.MouseEnter:Connect(function() -- Line: 1308
        -- upvalues: updateButtonVisuals (ref), u168 (copy), u167 (copy), u170 (copy), u9 (ref), isStoreOriginInspect (ref), showInfoFrame (ref)
        updateButtonVisuals(u168, u167, true);

        if u168 == "Info" then
            local v171 = u170;
            local v172 = u167;

            if v171 and (u9 and (not isStoreOriginInspect() and u9.Type ~= "Badge")) then
                showInfoFrame(v171, u9, v172);
            end;
        end;
    end), "Disconnect", "InspectButton_Enter_" .. u168);
    u18:Add(u167.MouseLeave:Connect(function() -- Line: 1319
        -- upvalues: updateButtonVisuals (ref), u168 (copy), u167 (copy), u170 (copy)
        updateButtonVisuals(u168, u167, false);
        local v173 = u168 == "Info" and (u170 and u170:FindFirstChild("Information"));

        if v173 then
            v173.Visible = false;
        end;
    end), "Disconnect", "InspectButton_Leave_" .. u168);

    if u168 == "Info" then
        u18:Add(u167.Activated:Connect(function() -- Line: 1331
            -- upvalues: u170 (copy), u167 (copy), u9 (ref), isStoreOriginInspect (ref), showInfoFrame (ref)
            local v174 = u170;
            local v175 = u167;

            if v174 and (u9 and (not isStoreOriginInspect() and u9.Type ~= "Badge")) then
                showInfoFrame(v174, u9, v175);
            end;
        end), "Disconnect", "InspectButton_Activated_Info");

        return;
    end;

    u18:Add(u167.MouseButton1Click:Connect(function() -- Line: 1339
        -- upvalues: u19 (ref), u168 (copy), setInspectMode (ref), refreshAllButtons (ref), u169 (copy), u1 (ref)
        if u19 == u168 then
            if u168 == "Viewmodel" then
                u1.PlayInspectAnimation();
            end;

            return;
        end;

        setInspectMode(u168);
        refreshAllButtons(u169, u168);
    end), "Disconnect", "InspectButton_Click_" .. u168);
end;

local function setupInspectButtons(p176: userdata, p177: any) -- Line: 1356
    -- upvalues: u24 (copy), GetWeaponProperties (copy), isStoreOriginInspect (copy), updateButtonVisuals (copy), setupButtonEvents (copy)
    local Middle = p176:FindFirstChild("Bottom").Middle;

    if Middle then
        Middle = Middle:FindFirstChild("Buttons");
    end;

    if not Middle then
        return;
    end;

    local v178;

    if u24[p177.Type] == true then
        v178 = true;
    else
        local v179;

        if p177.Name then
            local success, result = pcall(GetWeaponProperties, p177.Name);

            if success and result then
                v179 = result.Class;
            else
                v179 = nil;
            end;
        else
            v179 = nil;
        end;

        v178 = u24[v179] == true;
    end;

    local v180;

    if p177 == nil then
        v180 = false;
    elseif p177.Type == "Glove" then
        v180 = true;
    else
        local v181;

        if p177.Name then
            local success, result = pcall(GetWeaponProperties, p177.Name);

            if success and result then
                v181 = result.Class;
            else
                v181 = nil;
            end;
        else
            v181 = nil;
        end;

        v180 = v181 == "Glove";
    end;

    local v182 = {
        Info = Middle:FindFirstChild("Info"),
        Viewmodel = Middle:FindFirstChild("Viewmodel"),
        Weapon = Middle:FindFirstChild("Weapon")
    };
    local v183 = isStoreOriginInspect();
    local v184 = p177.Type == "Badge";

    for i, v in pairs(v182) do
        if v and v:IsA("GuiButton") then
            if i == "Info" then
                v.Visible = not v183 and not v184;
            elseif i == "Weapon" then
                local v185;

                if v178 then
                    v185 = not v180;
                else
                    v185 = v178;
                end;

                v.Visible = v185;
            else
                v.Visible = v178;
            end;

            updateButtonVisuals(i, v, false);
            setupButtonEvents(v, i, v182, p176);
        end;
    end;
end;

local function getWearPreviewChance(p186: any, p187: string) -- Line: 1394
    for _, v in ipairs(p186.floatChances or {}) do
        if v.wear == p187 then
            return v.chance;
        end;
    end;

    return nil;
end;

local function formatWearPreviewChance(p188: number?) -- Line: 1404
    return not p188 and "" or string.format("%.2f%%", p188);
end;

local function getWearPreviewFloat(p189, p190) -- Line: 1410
    local math_max_ret = math.max(p189.floatRange.min, p190.Min);
    local math_min_ret = math.min(p189.floatRange.max, p190.Max - 1e-12);

    if math_min_ret < math_max_ret then
        return nil;
    end;

    return math.clamp((math_max_ret + math_min_ret) / 2, 0, 1);
end;

local function refreshActiveInspectItem(p191) -- Line: 1422
    -- upvalues: u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), setupWeaponInspect (copy), setupViewmodelInspect (copy)
    u9 = p191;

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
        setupWeaponInspect(p191);

        return;
    end;

    if u19 == "Viewmodel" then
        InputController.disableGroup("Gameplay");
        setupViewmodelInspect(p191);
    end;
end;

local function getStatTrakPreviewChance(p192) -- Line: 1437
    return (p192.type == "Glove" or p192.supportsStatTrak == false) and 0 or (p192.statTrakChance or 0);
end;

local function setKillTrakBadgeVisible(p193: userdata, p194: boolean) -- Line: 1447
    for _, v in ipairs({ "Bottom", "Middle", "Description", "Statrak" }) do
        if p193 then
            p193 = p193:FindFirstChild(v);
        end;
    end;

    if p193 and p193:IsA("GuiObject") then
        p193.Visible = p194;
    end;
end;

local function updateStatTrakToggle(u195: userdata, p196: userdata, p197: boolean) -- Line: 1460
    -- upvalues: u38 (ref), u18 (copy), setKillTrakBadgeVisible (copy), u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), setupWeaponInspect (copy), setupViewmodelInspect (copy)
    local KillTrak = p196:FindFirstChild("KillTrak");

    if not KillTrak then
        return;
    end;

    KillTrak.Visible = p197;
    local Button = KillTrak:FindFirstChild("Button");

    if not (Button and Button:IsA("GuiButton")) then
        return;
    end;

    local CheckmarkImage = Button:FindFirstChild("CheckmarkImage");

    if CheckmarkImage then
        CheckmarkImage.Visible = u38;
    end;

    u18:Add(Button.Activated:Connect(function() -- Line: 1484
        -- upvalues: u38 (ref), CheckmarkImage (copy), setKillTrakBadgeVisible (ref), u195 (copy), u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (ref), setupWeaponInspect (ref), setupViewmodelInspect (ref)
        u38 = not u38;

        if CheckmarkImage then
            CheckmarkImage.Visible = u38;
        end;

        setKillTrakBadgeVisible(u195, u38);
        local v198 = u9;

        if v198 then
            local table_clone_ret = table.clone(v198);
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

local function updateFloatPreviewRow(p199: userdata, p200: any, p201: any, p202: number, p203: number?) -- Line: 1509
    -- upvalues: u33 (copy), Skins (copy), Rarities (copy)
    p199.Name = p200.Wear;
    p199.Visible = true;
    p199.LayoutOrder = table.find(u33, p200) or 0;
    p199:SetAttribute("Wear", p200.Wear);
    p199:SetAttribute("PreviewFloat", p202);
    local Left = p199:FindFirstChild("Left");
    local v204;

    if Left then
        v204 = Left:FindFirstChild("Label");
    else
        v204 = Left;
    end;

    if v204 and v204:IsA("TextLabel") then
        v204.Text = p200.Display;
        v204.TextColor3 = p200.Color;
    end;

    if Left then
        Left = Left:FindFirstChild("Percent");
    end;

    if Left and Left:IsA("TextLabel") then
        Left.Text = not p203 and "" or string.format("%.2f%%", p203);
    end;

    local Bar = p199:FindFirstChild("Bar");

    if Bar then
        Bar = Bar:FindFirstChild("Current");
    end;

    if Bar and Bar:IsA("Frame") then
        local Size = Bar.Size;
        local math_clamp_ret = math.clamp((p203 or 0) / 100, 0, 1);
        Bar.Size = UDim2.new(math_clamp_ret, 0, Size.Y.Scale, Size.Y.Offset);
        Bar.BackgroundColor3 = p200.Color;
    end;

    local Icon = p199:FindFirstChild("Icon", true);

    if Icon and Icon:IsA("ImageLabel") then
        Icon.Image = Skins.GetWearImageForFloat(p201, p202) or (p201.imageAssetId or "");
    end;

    local v205 = Rarities[p201.rarity];

    if v205 then
        local RarityFrame = p199:FindFirstChild("RarityFrame", true);

        if RarityFrame and RarityFrame:IsA("Frame") then
            RarityFrame.BackgroundColor3 = v205.Color;
        end;

        local Rarity = p199:FindFirstChild("Rarity", true);

        if Rarity and Rarity:IsA("ImageLabel") then
            Rarity.ImageColor3 = v205.Color;
        end;
    end;
end;

local function updateFloatPreviewFrame(p206: userdata, p207: any, p208: any) -- Line: 1564
    -- upvalues: getStoredFloatPreviewOpenPosition (copy), isStoreOriginInspect (copy), u38 (ref), updateStatTrakToggle (copy), u33 (copy), getWearPreviewChance (copy), PreviewTemplate (copy), updateFloatPreviewRow (copy), u9 (ref), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), setupWeaponInspect (copy), setupViewmodelInspect (copy), ActivateButton (copy), u18 (copy)
    local FloatPreviews = p206:FindFirstChild("FloatPreviews");

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

    local v209;

    if p208 == nil or p207.HideWearDetails ~= true then
        v209 = false;
    else
        v209 = p207.Type ~= "Charm";
    end;

    FloatPreviews.Visible = v209;

    if not (v209 and p208) then
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

    local v210;

    if ((p208.type == "Glove" or p208.supportsStatTrak == false) and 0 or (p208.statTrakChance or 0)) > 0 then
        v210 = isStoreOriginInspect();
    else
        v210 = false;
    end;

    if not v210 then
        u38 = false;
    end;

    updateStatTrakToggle(p206, FloatPreviews, v210);

    for _, v in ipairs(u33) do
        local math_max_ret = math.max(p208.floatRange.min, v.Min);
        local math_min_ret = math.min(p208.floatRange.max, v.Max - 1e-12);
        local u211;

        if math_min_ret < math_max_ret then
            u211 = nil;
        else
            u211 = math.clamp((math_max_ret + math_min_ret) / 2, 0, 1);
        end;

        local v212 = getWearPreviewChance(p208, v.Wear);

        if u211 and (v212 and v212 > 0) then
            local v213 = PreviewTemplate:Clone();
            updateFloatPreviewRow(v213, v, p208, u211, v212);

            local function selectWearPreview() -- Line: 1621
                -- upvalues: u9 (ref), u211 (copy), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (ref), setupWeaponInspect (ref), setupViewmodelInspect (ref)
                local v214 = u9;

                if not v214 then
                    return;
                end;

                local table_clone_ret = table.clone(v214);
                table_clone_ret.Float = u211;
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

            local Inspect = v213:FindFirstChild("Inspect");

            if Inspect and Inspect:IsA("GuiObject") then
                Inspect.Visible = false;
            end;

            local Button = v213:FindFirstChild("Button");

            if Button and Button:IsA("GuiButton") then
                ActivateButton(Button);
                u18:Add(Button.Activated:Connect(selectWearPreview), "Disconnect", "FloatPreview_Button_" .. v.Wear);
            end;

            v213.Parent = Container;
        end;
    end;
end;

local function updateCollectionData(p215: userdata, p216: any) -- Line: 1656
    -- upvalues: Collections (copy), UDim2_fromScale_ret (copy), UDim2_fromScale_ret3 (copy), UDim2_fromScale_ret2 (copy), UDim2_fromScale_ret4 (copy)
    if p216 then
        p216 = p216.collection;
    end;

    local v217;

    if p216 then
        v217 = Collections.GetCollectionByName(p216);
    else
        v217 = p216;
    end;

    local v218 = v217 ~= nil;
    local Collection = p215.Top.Frame.Frame.TextInfo:FindFirstChild("Collection");

    if Collection and Collection:IsA("TextLabel") then
        Collection.Visible = v218;
        Collection.Text = p216 or "";
    end;

    local CollectionIcon = p215.Top.Frame.Frame:FindFirstChild("CollectionIcon");

    if CollectionIcon and CollectionIcon:IsA("ImageLabel") then
        CollectionIcon.Image = v217 and v217.imageAssetId or "";
        CollectionIcon.Visible = v218;
    end;

    local WeaponName = p215:FindFirstChild("WeaponName");

    if WeaponName and WeaponName:IsA("TextLabel") then
        WeaponName.Position = UDim2_fromScale_ret;
        local v219;

        if v218 then
            v219 = UDim2_fromScale_ret3;
        else
            v219 = UDim2_fromScale_ret2;
        end;

        WeaponName.Size = v219;
        WeaponName.TextXAlignment = Enum.TextXAlignment.Center;
    end;

    local Rarity = p215:FindFirstChild("Rarity");

    if Rarity and Rarity:IsA("Frame") then
        Rarity.Position = UDim2_fromScale_ret4;
    end;
end;

local function updateInspectFrameUI(p220) -- Line: 1687
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

    setupInspectButtons(MainGui, p220);
    local v221 = isStoreOriginInspect() and MainGui:FindFirstChild("Information");

    if v221 then
        v221.Visible = false;
    end;

    local SkinInformation = Skins.GetSkinInformation(p220.Name, p220.Skin);
    updateFloatPreviewFrame(MainGui, p220, SkinInformation);
    local Item = MainGui.Top.Frame.Frame.TextInfo:FindFirstChild("Item");

    if Item and Item:IsA("TextLabel") then
        local v222 = GetSkinDisplayName(p220.Skin);
        GetSkinDisplayName.ApplyNameLabel(Item, (SkinInformation and SkinInformation.type == "Melee" and "★ " or "") .. GetSkinDisplayName.GetWeaponDisplayName(p220.Name, p220.NameTag) .. " | " .. v222, p220.NameTag);
    end;

    if SkinInformation then
        updateCollectionData(MainGui, SkinInformation);
        local Rarity = MainGui.Top.Frame:FindFirstChild("Rarity");
        local v223 = Rarity and (Rarity:IsA("Frame") and SkinInformation.rarity) and Rarities[SkinInformation.rarity];

        if v223 then
            Rarity.BackgroundColor3 = v223.Color;
        end;
    end;

    local Description = MainGui.Bottom.Middle:FindFirstChild("Description");

    if Description then
        local v224 = typeof(p220.StatTrack) == "number" and true or p220.StatTrack == true;
        Description.Statrak.Visible = v224;
        Description.Description.Text = SkinInformation and SkinInformation.description or "";
    end;
end;

local function hideViewmodels() -- Line: 1742
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

local function showViewmodels() -- Line: 1769
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

local function restoreMenuFrames() -- Line: 1804
    -- upvalues: MenuState (copy), u13 (ref), MenuSceneController (copy), hideOtherMenuScreens (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if not (MenuFrame and MenuFrame.Visible) then
        u13 = false;
        MenuState.ExitInspect();

        return;
    end;

    local v225 = MenuFrame:FindFirstChild("Inspect") or MenuFrame:FindFirstChild("InspectFrame");

    if v225 and v225:IsA("GuiObject") then
        local MobileButtons = v225:FindFirstChild("MobileButtons");
        v225.Visible = false;

        if MobileButtons then
            MobileButtons.Visible = false;
        end;
    end;

    local ScreenBeforeInspect = MenuState.GetScreenBeforeInspect();
    local v226 = u13;
    u13 = false;
    MenuState.ExitInspect();

    if v226 then
        MenuSceneController.ShowMenuScene();
        MenuSceneController.SetMusicVolumeMultiplier(1, 0.5);
    end;

    local Top = MenuFrame:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    if ScreenBeforeInspect then
        local v227 = MenuFrame:FindFirstChild(ScreenBeforeInspect);

        if v227 then
            hideOtherMenuScreens(MenuFrame, ScreenBeforeInspect);
            v227.Visible = true;

            if MenuState.IsCaseSceneActive() and ScreenBeforeInspect == "Store" or MenuState.IsSceneScreen(ScreenBeforeInspect) then
                MenuState.SetBlurEnabled(false);
                MenuFrame.BackgroundTransparency = 1;
                local Pattern = MenuFrame:FindFirstChild("Pattern");

                if Pattern then
                    Pattern.Visible = false;
                end;
            else
                local v228;

                if ScreenBeforeInspect == "Dashboard" then
                    v228 = false;
                else
                    v228 = ScreenBeforeInspect ~= "Play";
                end;

                local v229 = not v228;
                MenuState.SetBlurEnabled(v228);
                MenuFrame.BackgroundTransparency = v228 and 0.15 or 1;
                local Pattern = MenuFrame:FindFirstChild("Pattern");

                if Pattern then
                    Pattern.Visible = v229;
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

local function abortInspectScene(p230: string) -- Line: 1871
    -- upvalues: u16 (ref), ReplicatedStorage (copy), u11 (ref), SceneLighting (copy), restoreMenuFrames (copy)
    warn(p230);

    if u16 then
        u16.Parent = ReplicatedStorage;
        u16 = nil;
    end;

    u11 = SceneLighting.RestoreMap(nil, u11);
    restoreMenuFrames();
end;

local function resetInspectView(p231: number) -- Line: 1883
    -- upvalues: u29 (ref), u30 (ref), u31 (ref), u32 (ref), u27 (ref), u28 (ref)
    u29 = 0;
    u30 = 0;
    u31 = 0;
    u32 = 0;
    u27 = p231;
    u28 = p231;
end;

function u1.ShowInspect(p232) -- Line: 1895
    -- upvalues: u22 (ref), u1 (copy), Router (copy), u36 (ref), u37 (ref), u9 (ref), u38 (ref), u19 (ref), GetWeaponProperties (copy), hideMenuFrames (copy), hideViewmodels (copy), updateCharmFrameVisibility (copy), updateInspectFrameUI (copy), u12 (ref), restoreMenuFrames (copy), u16 (ref), activateInspectSceneFlags (copy), u15 (ref), Lighting (copy), u11 (ref), SceneLighting (copy), ReplicatedStorage (copy), InputController (copy), setupViewmodelInspect (copy), setupWeaponInspect (copy), DEFAULT_CAMERA_FOV (copy), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u27 (ref), u28 (ref), workspace_CurrentCamera (copy), CameraController (copy), u18 (copy), RunServiceController (copy), UserInputService (copy), u7 (ref), u14 (ref), CFrame_Angles_ret (copy), u8 (ref), u26 (ref), Vector2_zero (ref), isPointerOverButton (copy), LocalPlayer (copy), u34 (ref), u35 (ref), getPinchDistance (copy), MenuState (copy), u3 (copy), refreshInspectTips (copy)
    if u22 then
        u1.HideInspect();
    end;

    if Router.broadcastRouter("HasPendingCharmAttachment") then
        u36 = p232;
        u37 = 1;
    else
        u36 = nil;
    end;

    u9 = p232;
    u38 = false;
    local v233;

    if p232 == nil then
        v233 = false;
    elseif p232.Type == "Glove" then
        v233 = true;
    else
        local v234;

        if p232.Name then
            local success, result = pcall(GetWeaponProperties, p232.Name);

            if success and result then
                v234 = result.Class;
            else
                v234 = nil;
            end;
        else
            v234 = nil;
        end;

        v233 = v234 == "Glove";
    end;

    u19 = v233 and "Viewmodel" or "Weapon";
    hideMenuFrames();
    hideViewmodels();
    updateCharmFrameVisibility();
    updateInspectFrameUI(p232);

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
        local v235 = u15;
        local v236 = Lighting:FindFirstChild(v235) or Lighting:FindFirstChild("Menu");

        if v236 then
            u11 = SceneLighting.ApplyScene(v235, v236);
        end;
    end;

    local u237;

    if u16 then
        u237 = u16:FindFirstChild("CamPart");
    else
        u237 = nil;
    end;

    if not u237 then
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
        setupViewmodelInspect(p232);
    else
        InputController.enableGroup("Gameplay");
        setupWeaponInspect(p232);
    end;

    local v238 = u19 ~= "Viewmodel" and 40 or DEFAULT_CAMERA_FOV;
    u29 = 0;
    u30 = 0;
    u31 = 0;
    u32 = 0;
    u27 = v238;
    u28 = v238;
    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CFrame = u237.CFrame;
    workspace_CurrentCamera.Focus = u237.CFrame;
    CameraController.updateCameraFOV(u19 ~= "Viewmodel" and 40 or DEFAULT_CAMERA_FOV);
    CameraController.setForceLockOverride("Inspect", true);
    u18:Add(RunServiceController.BindToRenderStep("InspectController.CameraUpdate", function(p239) -- Line: 1967
        -- upvalues: u27 (ref), u28 (ref), u16 (ref), u237 (copy), workspace_CurrentCamera (ref), CameraController (ref), u19 (ref), UserInputService (ref), u32 (ref), u31 (ref), u7 (ref), u29 (ref), u30 (ref), u14 (ref), CFrame_Angles_ret (ref), u8 (ref)
        local math_min_ret = math.min(1, p239 * 8);
        u27 = u27 + (u28 - u27) * math_min_ret;

        if u16 and u237 then
            workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
            workspace_CurrentCamera.CFrame = u237.CFrame;
            workspace_CurrentCamera.Focus = u237.CFrame;
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
                            local Vector2_new_ret2 = Vector2.new(Vector2_new_ret.X * 0.5 * 60 * p239 * 4.75, Vector2_new_ret.Y * 0.5 * 60 * p239 * 4.75);
                            u32 = u32 + Vector2_new_ret2.X * 0.5;
                            u31 = math.clamp(u31 + Vector2_new_ret2.Y * 0.5, -80, 80);
                        end;
                    elseif (v.KeyCode == Enum.KeyCode.ButtonR2 or v.KeyCode == Enum.KeyCode.ButtonL2) and v.Position.Z > 0.1 then
                        local v240;

                        if v.KeyCode == Enum.KeyCode.ButtonR2 then
                            v240 = -v.Position.Z;
                        else
                            v240 = v.Position.Z;
                        end;

                        local v241 = v240 * 2 * 30 * p239 * 0.55;

                        if u19 ~= "Viewmodel" then
                            u28 = math.clamp(u28 - v241 * 2, 20, 70);
                        end;
                    end;
                end;
            end;
        end;

        if u19 == "Viewmodel" and u7 then
            u7:render(p239);

            return;
        end;

        if u19 == "Weapon" then
            local math_min_ret2 = math.min(1, p239 * 10);
            u29 = u29 + (u31 - u29) * math_min_ret2;
            u30 = u30 + (u32 - u30) * math_min_ret2;

            if u14 then
                if not u16 then
                    return;
                end;

                local WeaponPart = u16:FindFirstChild("WeaponPart");

                if WeaponPart then
                    local CFrame_Angles_ret2 = CFrame.Angles(0, math.rad(u30), (math.rad(u29)));
                    local v242 = u14;
                    local v243 = WeaponPart.CFrame * CFrame_Angles_ret2 * CFrame_Angles_ret;

                    if u8 then
                        v243 = v243 * v242:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
                    end;

                    v242:PivotTo(v243);
                end;
            end;
        end;
    end), "Disconnect", "CameraUpdate");
    u18:Add(UserInputService.InputBegan:Connect(function(p244, p245) -- Line: 2043
        -- upvalues: u26 (ref), Vector2_zero (ref), isPointerOverButton (ref), u1 (ref), InputController (ref), LocalPlayer (ref), u34 (ref), u35 (ref), getPinchDistance (ref)
        if p244.UserInputType == Enum.UserInputType.MouseButton1 then
            u26 = true;
            Vector2_zero = Vector2.new(p244.Position.X, p244.Position.Y);

            if not isPointerOverButton(p244.Position) then
                u1.PlayInspectAnimation();
            end;
        end;

        if table.find(InputController.getActionKeybinds("Inspect"), p244.KeyCode) then
            if LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            u1.PlayInspectAnimation();
        end;

        if table.find(InputController.getActionKeybinds("Reload"), p244.KeyCode) then
            if LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            u1.CancelInspectAnimation();
        end;

        if p244.UserInputType == Enum.UserInputType.Touch then
            u34[p244] = Vector2.new(p244.Position.X, p244.Position.Y);
            local v246 = 0;

            for _ in pairs(u34) do
                v246 = v246 + 1;
            end;

            if v246 == 1 then
                u26 = true;
                Vector2_zero = Vector2.new(p244.Position.X, p244.Position.Y);
            end;

            u35 = getPinchDistance();
        end;
    end), "Disconnect", "InputBegan");
    u18:Add(UserInputService.InputChanged:Connect(function(p247, p248) -- Line: 2083
        -- upvalues: u26 (ref), Vector2_zero (ref), u32 (ref), u31 (ref), u34 (ref), getPinchDistance (ref), u35 (ref), u19 (ref), u28 (ref)
        if p247.UserInputType == Enum.UserInputType.MouseMovement and u26 then
            local Vector2_new_ret = Vector2.new(p247.Position.X, p247.Position.Y);
            local v249 = Vector2_new_ret - Vector2_zero;
            u32 = u32 + v249.X * 0.5;
            u31 = math.clamp(u31 + v249.Y * 0.5, -80, 80);
            Vector2_zero = Vector2_new_ret;
        end;

        if p247.UserInputType == Enum.UserInputType.Touch then
            local Vector2_new_ret = Vector2.new(p247.Position.X, p247.Position.Y);
            u34[p247] = Vector2_new_ret;
            local v250 = 0;

            for _ in pairs(u34) do
                v250 = v250 + 1;
            end;

            if v250 == 1 and u26 then
                local v251 = Vector2_new_ret - Vector2_zero;
                u32 = u32 + v251.X * 0.5;
                u31 = math.clamp(u31 + v251.Y * 0.5, -80, 80);
                Vector2_zero = Vector2_new_ret;
            end;

            if v250 >= 2 then
                local v252 = getPinchDistance();

                if v252 and u35 then
                    local v253 = (v252 - u35) * 0.01;

                    if u19 ~= "Viewmodel" then
                        u28 = math.clamp(u28 - v253 * 2, 20, 70);
                    end;
                end;

                u35 = v252;
            end;
        end;

        if p247.UserInputType == Enum.UserInputType.MouseWheel then
            if u19 == "Viewmodel" then
                return;
            end;

            u28 = math.clamp(u28 - p247.Position.Z * 2, 20, 70);
        end;
    end), "Disconnect", "InputChanged");
    u18:Add(UserInputService.InputEnded:Connect(function(p254, p255) -- Line: 2124
        -- upvalues: u26 (ref), u34 (ref), u35 (ref), getPinchDistance (ref)
        if p254.UserInputType == Enum.UserInputType.MouseButton1 then
            u26 = false;
        end;

        if p254.UserInputType == Enum.UserInputType.Touch then
            u34[p254] = nil;
            local v256 = 0;

            for _ in pairs(u34) do
                v256 = v256 + 1;
            end;

            if v256 == 0 then
                u26 = false;
            end;

            u35 = getPinchDistance();
        end;
    end), "Disconnect", "InputEnded");
    u18:Add(function() -- Line: 2141
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

    local v257;

    if MenuFrame then
        v257 = MenuFrame:FindFirstChild("Inspect");
    else
        v257 = MenuFrame;
    end;

    if v257 then
        local v258 = u22;

        if v258 then
            if u19 == "Viewmodel" then
                v258 = u3;
            else
                v258 = false;
            end;
        end;

        MenuFrame.Visible = v258;
        v257.Visible = v258;
    end;

    refreshInspectTips();
end;

function u1.HideInspect(p259: boolean?) -- Line: 2165
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

    if p259 then
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

    local v260;

    if MenuFrame then
        v260 = MenuFrame:FindFirstChild("Inspect");
    else
        v260 = MenuFrame;
    end;

    if v260 then
        local v261 = u22;

        if v261 then
            if u19 == "Viewmodel" then
                v261 = u3;
            else
                v261 = false;
            end;
        end;

        MenuFrame.Visible = v261;
        v260.Visible = v261;
    end;

    refreshInspectTips();
end;

function u1.IsActive() -- Line: 2215
    -- upvalues: u22 (ref)
    return u22;
end;

function u1.CycleCharmPosition() -- Line: 2221
    -- upvalues: u22 (ref), u36 (ref), u37 (ref), u1 (copy)
    if not (u22 and u36) then
        return;
    end;

    u37 = u37 % 4 + 1;
    u1.RefreshWeaponWithCharm((tostring(u37)));
end;

function u1.RefreshWeaponWithCharm(p262: string) -- Line: 2234
    -- upvalues: u22 (ref), u16 (ref), u36 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u19 (ref), u14 (ref), u8 (ref), Skins (copy), prepareInspectWeapon (copy), CFrame_Angles_ret (copy), u7 (ref), u10 (ref)
    if not (u22 and (u16 and u36)) then
        return;
    end;

    local v263 = u16;
    local v264 = u36;

    if not v263:FindFirstChild("WeaponPart") then
        return;
    end;

    local v265 = u29;
    local v266 = u30;
    local v267 = u31;
    local v268 = u32;
    local Charm = v264.Charm;
    local v269 = type(Charm) == "table" and {
        _id = Charm._id,
        Position = p262
    } or p262;

    if u19 == "Weapon" then
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        u8 = nil;
        local InspectModel = Skins.GetInspectModel(v264.Name, v264.Skin, v264.Float, v264.StatTrack, v264.NameTag, v269, v264.Stickers);

        if not InspectModel then
            warn((`[InspectController]: Failed to refresh weapon model for charm position {p262}`));

            return;
        end;

        prepareInspectWeapon(InspectModel, false);
        InspectModel.Parent = v263;
        u29 = v265;
        u30 = v266;
        u31 = v267;
        u32 = v268;
        local v270 = u14 and u16 and u16:FindFirstChild("WeaponPart");

        if v270 then
            local CFrame_Angles_ret2 = CFrame.Angles(0, math.rad(u30), (math.rad(u29)));
            local v271 = u14;
            local v272 = v270.CFrame * CFrame_Angles_ret2 * CFrame_Angles_ret;

            if u8 then
                v272 = v272 * v271:GetPivot():ToObjectSpace(u8.WorldCFrame):Inverse();
            end;

            v271:PivotTo(v272);
        end;
    end;

    if u7 and u10 then
        u7.Charm = v269;
        u7:construct(u10, nil);
    end;
end;

function u1.PlayInspectAnimation() -- Line: 2301
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
        if u5 then
            if u5.IsPlaying then
                return;
            end;

            if u7 and u7.Animation then
                u7.Animation:stopAnimations();
            end;

            u5.TimePosition = 0;
            u5:Play(0, 1, 1);
        end;
    elseif u7.Animation then
        local v276 = u7.Animation:pickInspectVariant();
        u7.Animation:stopAnimations();
        u7.Animation:play("Idle");
        u7.Animation:play(v276);
    end;
end;

function u1.CancelInspectAnimation() -- Line: 2318
    -- upvalues: u19 (ref), u7 (ref), u9 (ref), GetWeaponProperties (copy)
    if u19 ~= "Viewmodel" or not u7 then
        return;
    end;

    local v277 = u9;
    local v278;

    if v277 == nil then
        v278 = false;
    elseif v277.Type == "Glove" then
        v278 = true;
    else
        local v279;

        if v277.Name then
            local success, result = pcall(GetWeaponProperties, v277.Name);

            if success and result then
                v279 = result.Class;
            else
                v279 = nil;
            end;
        else
            v279 = nil;
        end;

        v278 = v279 == "Glove";
    end;

    if v278 then
        return;
    end;

    if u7.Animation then
        u7.Animation:markInspectCancel();
        u7.Animation:crossfadeTo("Idle", 0.25);
    end;
end;

function u1.Initialize() -- Line: 2335
    -- upvalues: DataController (copy), LocalPlayer (copy), SceneLighting (copy), u11 (ref), refreshInspectTips (copy), UserInputService (copy), getRandomInspectScene (copy), u15 (ref), u12 (ref), ReplicatedStorage (copy), u22 (ref), u1 (copy), Router (copy), u37 (ref)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 2336
        -- upvalues: SceneLighting (ref), u11 (ref)
        SceneLighting.ApplyGlobalShadows(u11);
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", refreshInspectTips);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(refreshInspectTips);
    local v280 = getRandomInspectScene();

    if v280 then
        u15 = v280.Name;
        u12 = v280;
        v280.Name = "InspectScene";
        v280.Parent = ReplicatedStorage;
    else
        warn("[InspectController]: No inspect scene found to preload in ReplicatedStorage.Assets.InspectScenes");
    end;

    UserInputService.InputBegan:Connect(function(p281, p282) -- Line: 2357
        -- upvalues: u22 (ref), u1 (ref)
        if p282 then
            return;
        end;

        if p281.KeyCode == Enum.KeyCode.Escape and u22 then
            u1.HideInspect();
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 2367
        -- upvalues: u22 (ref), u1 (ref)
        if u22 then
            u1.HideInspect();
        end;
    end);
    Router.observerRouter("WeaponInspect", function(p283: string, p284: string, p285: number?, p286: any, p287: any, p288: any, p289: table?, p290: string?, p291: number?, p292: string?, p293: number?, p294: boolean?, p295: boolean?, p296: boolean?) -- Line: 2375
        -- upvalues: ReplicatedStorage (ref), u1 (ref)
        if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
            return;
        end;

        u1.ShowInspect({
            _id = p292 or "inspect_" .. p283 .. "_" .. p284,
            Name = p283,
            Skin = p284,
            Float = p285,
            StatTrack = p286,
            NameTag = p287,
            Charm = p288,
            Stickers = p289,
            Type = p290,
            Pattern = p291,
            Serial = p293,
            IsTradeable = p294,
            HideWearDetails = p295,
            ShowFullPriceRange = p296
        });
    end);
    Router.observerRouter("WeaponInspectClose", function() -- Line: 2418
        -- upvalues: u1 (ref)
        u1.HideInspect();
    end);
    Router.observerRouter("WeaponInspectCloseForGameEnd", function() -- Line: 2423
        -- upvalues: u1 (ref)
        u1.HideInspect(true);
    end);
    Router.observerRouter("IsInspectActive", function() -- Line: 2427
        -- upvalues: u22 (ref)
        return u22;
    end);
    Router.observerRouter("GetCurrentCharmPosition", function() -- Line: 2431
        -- upvalues: u37 (ref)
        return u37;
    end);
end;

function u1.Start() -- Line: 2436
    -- upvalues: initializeInspectButtons (copy)
    initializeInspectButtons();
end;

return u1;