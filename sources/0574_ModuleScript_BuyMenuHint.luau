-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local IsBotLobby = require(ReplicatedStorage.Components.Common.IsBotLobby);
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock);
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);
local HoverBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb);
local Notification = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification);
require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification.Types);
local UDim2_fromScale_ret = UDim2.fromScale(0.225, 0.054);
local TweenInfo_new_ret = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2;

if table.find(GetUserPlatform(), "Mobile") == nil then
    u2 = false;
else
    u2 = #GetUserPlatform() <= 1;
end;

local u3 = false;
local u4 = false;
local u5 = false;
local u6 = (1 / 0);
local u7 = nil;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = false;
local u13 = 0;
local u14 = (-1 / 0);

local function IsBuyMenuScreenOpen() -- Line: 112
    -- upvalues: u8 (ref)
    local v15 = u8 and u8:FindFirstChild("BuyMenu");
    local v16;

    if v15 == nil then
        v16 = false;
    else
        v16 = v15:IsA("GuiObject") and v15.Visible;
    end;

    return v16;
end;

local function IsTouchInput() -- Line: 117
    -- upvalues: UserInputService (copy)
    return UserInputService.PreferredInput == Enum.PreferredInput.Touch;
end;

local function DecodeAttribute(p17: string) -- Line: 123
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute(p17);

    if typeof(Attribute) ~= "string" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

    if success and typeof(result) == "table" then
        return result;
    end;

    return nil;
end;

local function IsCarryingBomb() -- Line: 133
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute("Slot5");
    local v18;

    if typeof(Attribute) == "string" then
        local v19;
        v19, v18 = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if not v19 or typeof(v18) ~= "table" then
            v18 = nil;
        end;
    else
        v18 = nil;
    end;

    local v20;

    if v18 == nil then
        v20 = false;
    else
        v20 = v18.Weapon == "C4";
    end;

    return v20;
end;

local function IsBombEquipped() -- Line: 138
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute("CurrentEquipped");
    local v21;

    if typeof(Attribute) == "string" then
        local v22;
        v22, v21 = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if not v22 or typeof(v21) ~= "table" then
            v21 = nil;
        end;
    else
        v21 = nil;
    end;

    local v23;

    if v21 == nil then
        v23 = false;
    else
        v23 = v21.Name == "C4";
    end;

    return v23;
end;

local function CanPromptBomb() -- Line: 144
    -- upvalues: IsTutorialMode (copy), LocalPlayer (copy), HttpService (copy)
    local v24 = IsTutorialMode();

    if v24 then
        local Attribute = LocalPlayer:GetAttribute("Slot5");
        local v25;

        if typeof(Attribute) == "string" then
            local v26;
            v26, v25 = pcall(HttpService.JSONDecode, HttpService, Attribute);

            if not v26 or typeof(v25) ~= "table" then
                v25 = nil;
            end;
        else
            v25 = nil;
        end;

        if v25 == nil then
            v24 = false;
        else
            v24 = v25.Weapon == "C4";
        end;

        if not v24 then
            local Attribute2 = LocalPlayer:GetAttribute("CurrentEquipped");
            local v27;

            if typeof(Attribute2) == "string" then
                local v28;
                v28, v27 = pcall(HttpService.JSONDecode, HttpService, Attribute2);

                if not v28 or typeof(v27) ~= "table" then
                    v27 = nil;
                end;
            else
                v27 = nil;
            end;

            if v27 == nil then
                v24 = false;
            else
                v24 = v27.Name == "C4";
            end;
        end;
    end;

    return v24;
end;

local function IsOnTutorialStep(p29: string) -- Line: 148
    -- upvalues: IsTutorialMode (copy), LocalPlayer (copy)
    local v30 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == p29;

    return v30;
end;

local function HasShotPracticeRifle() -- Line: 153
    -- upvalues: LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute("TutorialObjective");
    local v31;

    if typeof(Attribute) == "string" then
        v31 = string.find(Attribute, "^Reload") ~= nil;
    else
        v31 = false;
    end;

    return v31;
end;

local function IsStoodOnPlantArea() -- Line: 163
    -- upvalues: LocalPlayer (copy), RaycastParams_new_ret (copy)
    local Character = LocalPlayer.Character;
    local v32;

    if Character then
        v32 = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart");
    else
        v32 = Character;
    end;

    if not (Character and v32) then
        return false;
    end;

    local v33 = { Character, workspace.CurrentCamera };
    local Debris = workspace:FindFirstChild("Debris");

    if Debris then
        table.insert(v33, Debris);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v33;
    local v34 = workspace:Raycast(v32.Position, Vector3.new(-0, -5, -0), RaycastParams_new_ret);
    local v35;

    if v34 == nil then
        v35 = false;
    else
        v35 = v34.Instance:HasTag("PlantArea") and v34.Instance:GetAttribute("Site") ~= nil;
    end;

    return v35;
end;

local u54 = {
    {
        Text = "EQUIP BOMB",
        Action = "Explosives & Traps",
        GamepadAction = "Cycle Weapons Right",
        GamepadText = "CYCLE TO THE BOMB",
        MobileText = "TAP HERE TO EQUIP BOMB",

        OnTap = function() -- Line: 200, Name: OnTap
            -- upvalues: InventoryController (copy)
            InventoryController.equip(5, 1);
        end,

        IsAvailable = function() -- Line: 203, Name: IsAvailable
            -- upvalues: u5 (ref), LocalPlayer (copy), HttpService (copy)
            local v36 = u5;

            if v36 then
                local Attribute = LocalPlayer:GetAttribute("Slot5");
                local v37;

                if typeof(Attribute) == "string" then
                    local v38;
                    v38, v37 = pcall(HttpService.JSONDecode, HttpService, Attribute);

                    if not v38 or typeof(v37) ~= "table" then
                        v37 = nil;
                    end;
                else
                    v37 = nil;
                end;

                if v37 == nil then
                    v36 = false;
                else
                    v36 = v37.Weapon == "C4";
                end;

                if v36 then
                    local Attribute2 = LocalPlayer:GetAttribute("CurrentEquipped");
                    local v39;

                    if typeof(Attribute2) == "string" then
                        local v40;
                        v40, v39 = pcall(HttpService.JSONDecode, HttpService, Attribute2);

                        if not v40 or typeof(v39) ~= "table" then
                            v39 = nil;
                        end;
                    else
                        v39 = nil;
                    end;

                    local v41;

                    if v39 == nil then
                        v41 = false;
                    else
                        v41 = v39.Name == "C4";
                    end;

                    v36 = not v41;
                end;
            end;

            return v36;
        end
    },
    {
        Text = "HOLD TO PLANT BOMB",
        Action = "Fire",
        MobileButton = "Shoot",

        IsAvailable = function() -- Line: 212, Name: IsAvailable
            -- upvalues: u5 (ref), LocalPlayer (copy), HttpService (copy)
            local v42 = u5;

            if v42 then
                local Attribute = LocalPlayer:GetAttribute("CurrentEquipped");
                local v43;

                if typeof(Attribute) == "string" then
                    local v44;
                    v44, v43 = pcall(HttpService.JSONDecode, HttpService, Attribute);

                    if not v44 or typeof(v43) ~= "table" then
                        v43 = nil;
                    end;
                else
                    v43 = nil;
                end;

                if v43 == nil then
                    v42 = false;
                else
                    v42 = v43.Name == "C4";
                end;
            end;

            return v42;
        end
    },
    {
        Text = "HOLD TO DEFUSE BOMB",
        Action = "Use",
        MobileButton = "Interact",

        IsAvailable = function() -- Line: 220, Name: IsAvailable
            -- upvalues: IsTutorialMode (copy), LocalPlayer (copy), HoverBomb (copy)
            local v45 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "DefuseB";

            if v45 then
                if LocalPlayer:GetAttribute("IsDefusingBomb") == true then
                    v45 = false;
                else
                    v45 = HoverBomb.GetHoverState();
                end;
            end;

            return v45;
        end
    },
    {
        Text = "LOOK AT THE BOMB",

        IsAvailable = function() -- Line: 230, Name: IsAvailable
            -- upvalues: IsTutorialMode (copy), LocalPlayer (copy), HoverBomb (copy)
            local v46 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "DefuseB";

            if v46 then
                if LocalPlayer:GetAttribute("IsDefusingBomb") == true then
                    v46 = false;
                else
                    v46 = HoverBomb.IsInDefuseRange();
                end;
            end;

            return v46;
        end
    },
    {
        Text = "GO TO THE BOMB",

        IsAvailable = function() -- Line: 239, Name: IsAvailable
            -- upvalues: IsTutorialMode (copy), LocalPlayer (copy)
            local v47 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "DefuseB" and LocalPlayer:GetAttribute("IsDefusingBomb") ~= true;

            return v47;
        end
    },
    {
        Text = "SHOOT",
        Action = "Fire",
        MobileButton = "Shoot",

        IsAvailable = function() -- Line: 248, Name: IsAvailable
            -- upvalues: IsTutorialMode (copy), LocalPlayer (copy)
            local v48 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "PracticeAK";

            if v48 then
                local Attribute = LocalPlayer:GetAttribute("TutorialObjective");
                local v49;

                if typeof(Attribute) == "string" then
                    v49 = string.find(Attribute, "^Reload") ~= nil;
                else
                    v49 = false;
                end;

                v48 = not v49;
            end;

            return v48;
        end
    },
    {
        Text = "RELOAD",
        Action = "Reload",
        MobileButton = "Reload",

        IsAvailable = function() -- Line: 256, Name: IsAvailable
            -- upvalues: IsTutorialMode (copy), LocalPlayer (copy)
            local v50 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "PracticeAK";

            if v50 then
                local Attribute = LocalPlayer:GetAttribute("TutorialObjective");

                if typeof(Attribute) == "string" then
                    v50 = string.find(Attribute, "^Reload") ~= nil;
                else
                    v50 = false;
                end;
            end;

            return v50;
        end
    },
    {
        Text = "BUY MENU",
        Action = "Buy Menu",
        MobileButton = "Shop",
        MobileText = "TAP THE SHOP BUTTON",

        IsAvailable = function() -- Line: 266, Name: IsAvailable
            -- upvalues: u4 (ref), LocalPlayer (copy), u8 (ref), TutorialPurchaseLock (copy)
            local v51 = u4;

            if v51 then
                if LocalPlayer:GetAttribute("BuyMenu") == true then
                    local v52 = u8 and u8:FindFirstChild("BuyMenu");
                    local v53;

                    if v52 == nil then
                        v53 = false;
                    else
                        v53 = v52:IsA("GuiObject") and v52.Visible;
                    end;

                    v51 = not v53 and not TutorialPurchaseLock.isBuyMenuLocked(LocalPlayer);
                else
                    v51 = false;
                end;
            end;

            return v51;
        end
    }
};

local function ResolvePromptBinding(p55: table) -- Line: 278
    -- upvalues: Tips (copy)
    if not p55.Action then
        return nil;
    end;

    local v56 = Tips.ResolveActionBinding(p55.Action);

    if not v56 and (p55.GamepadAction and Tips.IsGamepadPreferred()) then
        v56 = Tips.ResolveActionBinding(p55.GamepadAction);
    end;

    return v56;
end;

local u57 = nil;
local u58 = nil;
local u59 = nil;

local function GetPromptParts() -- Line: 296
    -- upvalues: u11 (ref), u57 (ref), u58 (ref), u59 (ref)
    local v60 = u11;

    if not (v60 and v60.Parent) then
        return nil, nil;
    end;

    if v60 == u57 and (u58 and (u58.Parent == v60 and (u59 == nil or u59.Parent == v60))) then
        return u58, u59;
    end;

    local TextLabel = v60:FindFirstChild("TextLabel");
    local Keybind = v60:FindFirstChild("Keybind");

    if not (TextLabel and TextLabel:IsA("TextLabel")) then
        warn((`[BuyMenuHint]: {v60:GetFullName()} has no TextLabel child; the prompt cannot render`));

        return nil, nil;
    end;

    u57 = v60;
    u58 = TextLabel;

    if not (Keybind and Keybind:IsA("ImageButton")) then
        Keybind = nil;
    end;

    u59 = Keybind;

    return u58, u59;
end;

local function RefreshPrompt() -- Line: 321
    -- upvalues: u7 (ref), GetPromptParts (copy), UserInputService (copy), Tips (copy), u11 (ref)
    local v61 = u7;
    local v62, v63 = GetPromptParts();

    if not (v61 and v62) then
        return;
    end;

    local v64 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
    local v65;

    if v64 and v61.MobileText then
        v65 = v61.MobileText;
    elseif Tips.IsGamepadPreferred() and v61.GamepadText then
        v65 = v61.GamepadText;
    else
        v65 = v61.Text;
    end;

    v62.Text = string.upper(v65);

    if v63 then
        local v66;

        if v61.Action == nil then
            v66 = false;
        else
            v66 = not v64;

            if v66 then
                local ApplyBindingToKeybind = Tips.ApplyBindingToKeybind;
                local v67;

                if v61.Action then
                    v67 = Tips.ResolveActionBinding(v61.Action);

                    if not v67 and (v61.GamepadAction and Tips.IsGamepadPreferred()) then
                        v67 = Tips.ResolveActionBinding(v61.GamepadAction);
                    end;
                else
                    v67 = nil;
                end;

                v66 = ApplyBindingToKeybind(v63, v67);
            end;
        end;

        v63.Visible = v66;
    end;

    local v68 = u11;

    if v68 then
        v68 = v68:FindFirstChild("TapTarget");
    end;

    if v68 and v68:IsA("GuiObject") then
        if v64 then
            v64 = v61.OnTap ~= nil;
        end;

        v68.Visible = v64;
    end;
end;

local function HighlightMobileButton(p69: table) -- Line: 351
    -- upvalues: u14 (ref), UserInputService (copy), ReplicatedStorage (copy)
    if not p69.MobileButton then
        return;
    end;

    u14 = os.clock();

    if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
        return;
    end;

    require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons).HighlightButton(p69.MobileButton, 2);
end;

local u70 = nil;
local u71 = 0;
local u72 = 0;
local u73 = 0;

local function LayoutKeybind() -- Line: 377
    -- upvalues: u11 (ref), GetPromptParts (copy), u70 (ref), u71 (ref), u72 (ref), u73 (ref)
    local v74 = u11;

    if not (v74 and v74.Parent) then
        return;
    end;

    local v75, v76 = GetPromptParts();

    if not v75 then
        return;
    end;

    local X = v74.AbsoluteSize.X;

    if X <= 0 then
        return;
    end;

    local X2 = v75.TextBounds.X;
    local v77 = not (v76 and v76.Visible) and -1 or v76.AbsoluteSize.X;

    if v75 == u70 and (X == u71 and (X2 == u72 and v77 == u73)) then
        return;
    end;

    u70 = v75;
    u71 = X;
    u72 = X2;
    u73 = v77;
    local v78 = X2 / X;

    if not v76 or v77 < 0 then
        v75.Position = UDim2.fromScale(0.5, 0.5);

        return;
    end;

    local v79 = v77 / X;
    local v80 = 0.5 - (v79 + 0.02 + v78) / 2;
    v76.Position = UDim2.fromScale(v80 + v79 * v76.AnchorPoint.X, 0.5);
    v75.Position = UDim2.fromScale(v80 + v79 + 0.02 + v78 / 2, 0.5);
end;

local function FindCommanderBox() -- Line: 415
    -- upvalues: IsTutorialMode (copy), u8 (ref)
    if not IsTutorialMode() then
        return nil;
    end;

    local v81 = u8;

    if v81 then
        v81 = v81:FindFirstChild("TutorialDialogue");
    end;

    if v81 and v81:IsA("GuiObject") then
        return v81;
    end;

    return nil;
end;

local function GetLayoutOrigin() -- Line: 426
    -- upvalues: u8 (ref)
    local v82 = u8;

    if v82 and v82:IsA("GuiBase2d") then
        return v82.AbsolutePosition;
    end;

    return Vector2.zero;
end;

local function GetTutorialCardSlot() -- Line: 436
    -- upvalues: IsTutorialMode (copy), u8 (ref)
    local v83;

    if IsTutorialMode() then
        v83 = u8;

        if v83 then
            v83 = v83:FindFirstChild("TutorialDialogue");
        end;

        if not (v83 and v83:IsA("GuiObject")) then
            v83 = nil;
        end;
    else
        v83 = nil;
    end;

    if not v83 then
        return UDim2.fromScale(0.5, 0.74);
    end;

    local v84 = u8;
    local v85;

    if v84 and v84:IsA("GuiBase2d") then
        v85 = v84.AbsolutePosition;
    else
        v85 = Vector2.zero;
    end;

    local Y = v83.AbsolutePosition.Y;

    for _, child in v83:GetChildren() do
        if child:IsA("GuiObject") and child.Visible then
            Y = math.min(Y, child.AbsolutePosition.Y);
        end;
    end;

    return UDim2.fromOffset(v83.AbsolutePosition.X + v83.AbsoluteSize.X / 2 - v85.X, Y - v85.Y - 10);
end;

local function LayoutTutorialCard() -- Line: 454
    -- upvalues: u11 (ref), u12 (ref), u8 (ref), u13 (ref), GetTutorialCardSlot (copy), IsTutorialMode (copy)
    local v86 = u11;

    if not (u12 and (v86 and (v86.Parent and u8))) then
        return;
    end;

    local v87 = (os.clock() - u13) / 0.3;
    local v88 = (1 - math.clamp(v87, 0, 1)) ^ 2 * 12;
    v86.AnchorPoint = Vector2.new(0.5, 1);
    v86.Position = GetTutorialCardSlot() + UDim2.fromOffset(0, v88);
    local v89;

    if IsTutorialMode() then
        v89 = u8;

        if v89 then
            v89 = v89:FindFirstChild("TutorialDialogue");
        end;

        if not (v89 and v89:IsA("GuiObject")) then
            v89 = nil;
        end;
    else
        v89 = nil;
    end;

    if v89 then
        v86.ZIndex = v89.ZIndex;
    end;
end;

local function CreateKeycap() -- Line: 473
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Keybind";
    ImageButton.AutoButtonColor = false;
    ImageButton.Active = false;
    ImageButton.Image = "";
    ImageButton.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageButton.BackgroundTransparency = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.2, 0);
    UICorner.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Bind";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.TextScaled = true;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold);
    TextLabel.TextColor3 = Color3.fromRGB(20, 20, 20);
    TextLabel.ZIndex = 2;
    TextLabel.Parent = ImageButton;

    return ImageButton;
end;

local function EnsureKeycapImage(p90: userdata) -- Line: 505
    for _, child in p90:GetChildren() do
        if child.Name == "Bind" and child:IsA("ImageLabel") then
            return;
        end;
    end;

    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Bind";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Visible = false;
    ImageLabel.ZIndex = 3;
    ImageLabel.Parent = p90;
end;

local function CreateTutorialCard() -- Line: 528
    -- upvalues: u8 (ref), ReplicatedStorage (copy), UDim2_fromScale_ret (copy), u9 (ref), CreateKeycap (copy), EnsureKeycapImage (copy), u7 (ref), UserInputService (copy), GetPreferenceColor (copy), TweenService (copy), TweenInfo_new_ret (copy), u13 (ref)
    local v91 = u8;
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("UI");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Notification");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Keybind") or Assets:FindFirstChild("Default");
    end;

    if not (v91 and (Assets and Assets:IsA("GuiObject"))) then
        return nil;
    end;

    local v92 = Assets:Clone();
    v92.Name = "TutorialPrompt";
    v92.Size = UDim2_fromScale_ret;
    v92.LayoutOrder = 0;
    local Keybind = v92:FindFirstChild("Keybind");

    if not (Keybind and Keybind:IsA("ImageButton")) then
        if u9 then
            Keybind = u9:Clone();
        else
            Keybind = CreateKeycap();
        end;

        Keybind.Name = "Keybind";
        Keybind.AnchorPoint = Vector2.new(0, 0.5);
        Keybind.Size = UDim2.fromScale(0.7, 0.7);
        Keybind.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Keybind.ZIndex = 3;
        Keybind.Parent = v92;
    end;

    EnsureKeycapImage(Keybind);
    local TextLabel = v92:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.TextWrapped = false;
    end;

    local TextButton = Instance.new("TextButton");
    TextButton.Name = "TapTarget";
    TextButton.BackgroundTransparency = 1;
    TextButton.Text = "";
    TextButton.Size = UDim2.fromScale(1, 1);
    TextButton.ZIndex = 10;
    TextButton.Visible = false;
    TextButton.Activated:Connect(function() -- Line: 569
        -- upvalues: u7 (ref), UserInputService (ref)
        local v93 = u7;

        if v93 and v93.OnTap and UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            v93.OnTap();
        end;
    end);
    TextButton.Parent = v92;
    local v94 = GetPreferenceColor();

    for _, v in { "Left", "Right" } do
        local v95 = v92:FindFirstChild(v);

        if v95 and v95:IsA("GuiObject") then
            v95.BackgroundColor3 = v94;
        end;
    end;

    if v92:IsA("CanvasGroup") then
        v92.GroupTransparency = 1;
        TweenService:Create(v92, TweenInfo_new_ret, {
            GroupTransparency = 0
        }):Play();
    end;

    u13 = os.clock();
    v92.Parent = v91;

    return v92;
end;

local function RemoveTutorialCard(u96: userdata) -- Line: 594
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    if not u96:IsA("CanvasGroup") then
        u96:Destroy();

        return;
    end;

    local v97 = TweenService:Create(u96, TweenInfo_new_ret, {
        GroupTransparency = 1
    });
    v97.Completed:Once(function() -- Line: 600
        -- upvalues: u96 (copy)
        u96:Destroy();
    end);
    v97:Play();
end;

local function ResolvePrompt() -- Line: 609
    -- upvalues: u54 (copy)
    for _, v in ipairs(u54) do
        if v.IsAvailable() then
            return v;
        end;
    end;

    return nil;
end;

local function RemoveCard() -- Line: 621
    -- upvalues: u11 (ref), u12 (ref), RemoveTutorialCard (copy), Notification (copy)
    local v98 = u11;
    u11 = nil;

    if u12 then
        if v98 and v98.Parent then
            RemoveTutorialCard(v98);
        end;
    else
        Notification.removeNotification("BuyMenuHint");
    end;
end;

local function ShowPrompt(p99: table?) -- Line: 633
    -- upvalues: u7 (ref), u3 (ref), IsTutorialMode (copy), IsBotLobby (copy), u11 (ref), u12 (ref), RemoveTutorialCard (copy), Notification (copy), u14 (ref), HighlightMobileButton (copy), RefreshPrompt (copy), CreateTutorialCard (copy)
    local v100 = p99 ~= u7;
    u7 = p99;
    u3 = p99 ~= nil;
    local v101 = IsTutorialMode() or IsBotLobby();

    if u11 and u12 ~= v101 then
        local v102 = u11;
        u11 = nil;

        if u12 then
            if v102 and v102.Parent then
                RemoveTutorialCard(v102);
            end;
        else
            Notification.removeNotification("BuyMenuHint");
        end;
    end;

    if not p99 then
        if u11 or v100 then
            local v103 = u11;
            u11 = nil;

            if u12 then
                if v103 and v103.Parent then
                    RemoveTutorialCard(v103);

                    return;
                end;
            else
                Notification.removeNotification("BuyMenuHint");
            end;
        end;

        return;
    end;

    if v100 or os.clock() - u14 >= 2 then
        HighlightMobileButton(p99);
    end;

    if u11 and u11.Parent then
        if v100 then
            RefreshPrompt();
        end;

        return;
    end;

    u12 = v101;

    if u12 then
        u11 = CreateTutorialCard();
    else
        u11 = Notification.createNotification("Keybind", "BuyMenuHint", string.upper(p99.Text), 0);
    end;

    RefreshPrompt();
end;

local function ShouldRunUpdate() -- Line: 687
    -- upvalues: LocalPlayer (copy), CharacterResolver (copy), IsTutorialMode (copy), u2 (copy), IsBotLobby (copy)
    if LocalPlayer:GetAttribute("IsSpectating") == true then
        return false;
    end;

    if not CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
        return false;
    end;

    if IsTutorialMode() then
        return true;
    end;

    if u2 and not IsBotLobby() then
        return false;
    end;

    local v104;

    if LocalPlayer:GetAttribute("BuyMenu") == true then
        v104 = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
    else
        v104 = false;
    end;

    return v104;
end;

local function StopUpdateConnection() -- Line: 707
    -- upvalues: u10 (ref), u4 (ref), u5 (ref), u6 (ref)
    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    u4 = false;
    u5 = false;
    u6 = (1 / 0);
end;

local function SyncUpdateConnection() -- Line: 719
    -- upvalues: ShouldRunUpdate (copy), u10 (ref), u6 (ref), RunServiceController (copy), u7 (ref), u3 (ref), IsTutorialMode (copy), IsBotLobby (copy), u11 (ref), u12 (ref), RemoveTutorialCard (copy), Notification (copy), u4 (ref), u5 (ref), LocalPlayer (copy), IsInBuyArea (copy), HttpService (copy), IsStoodOnPlantArea (copy), ShowPrompt (copy), u54 (copy), LayoutKeybind (copy), LayoutTutorialCard (copy)
    if ShouldRunUpdate() then
        if u10 then
            return;
        end;

        u6 = (1 / 0);
        u10 = RunServiceController.BindToHeartbeat("UI.BuyMenuHint.Update", function(p105: number) -- Line: 726
            -- upvalues: ShouldRunUpdate (ref), u7 (ref), u3 (ref), IsTutorialMode (ref), IsBotLobby (ref), u11 (ref), u12 (ref), RemoveTutorialCard (ref), Notification (ref), u10 (ref), u4 (ref), u5 (ref), u6 (ref), LocalPlayer (ref), IsInBuyArea (ref), HttpService (ref), IsStoodOnPlantArea (ref), ShowPrompt (ref), u54 (ref), LayoutKeybind (ref), LayoutTutorialCard (ref)
            if not ShouldRunUpdate() then
                local v106 = u7 ~= nil;
                u7 = nil;
                u3 = false;

                if u11 and u12 ~= (IsTutorialMode() or IsBotLobby()) then
                    local v107 = u11;
                    u11 = nil;

                    if u12 then
                        if v107 and v107.Parent then
                            RemoveTutorialCard(v107);
                        end;
                    else
                        Notification.removeNotification("BuyMenuHint");
                    end;
                end;

                if u11 or v106 then
                    local v108 = u11;
                    u11 = nil;

                    if u12 then
                        if v108 and v108.Parent then
                            RemoveTutorialCard(v108);
                        end;
                    else
                        Notification.removeNotification("BuyMenuHint");
                    end;
                end;

                if u10 then
                    u10:Disconnect();
                    u10 = nil;
                end;

                u4 = false;
                u5 = false;
                u6 = (1 / 0);

                return;
            end;

            u6 = u6 + p105;

            if u6 >= 0.2 then
                u6 = 0;
                local v109;

                if LocalPlayer:GetAttribute("BuyMenu") == true then
                    v109 = IsInBuyArea(LocalPlayer);
                else
                    v109 = false;
                end;

                u4 = v109;
                local v110 = IsTutorialMode();

                if v110 then
                    local Attribute = LocalPlayer:GetAttribute("Slot5");
                    local v111;

                    if typeof(Attribute) == "string" then
                        local v112;
                        v112, v111 = pcall(HttpService.JSONDecode, HttpService, Attribute);

                        if not v112 or typeof(v111) ~= "table" then
                            v111 = nil;
                        end;
                    else
                        v111 = nil;
                    end;

                    if v111 == nil then
                        v110 = false;
                    else
                        v110 = v111.Weapon == "C4";
                    end;

                    if not v110 then
                        local Attribute2 = LocalPlayer:GetAttribute("CurrentEquipped");
                        local v113;

                        if typeof(Attribute2) == "string" then
                            local v114;
                            v114, v113 = pcall(HttpService.JSONDecode, HttpService, Attribute2);

                            if not v114 or typeof(v113) ~= "table" then
                                v113 = nil;
                            end;
                        else
                            v113 = nil;
                        end;

                        if v113 == nil then
                            v110 = false;
                        else
                            v110 = v113.Name == "C4";
                        end;
                    end;
                end;

                if v110 then
                    v110 = IsStoodOnPlantArea();
                end;

                u5 = v110;
            end;

            local v115 = nil;

            for _, v in ipairs(u54) do
                if v.IsAvailable() then
                    v115 = v;
                    break;
                end;
            end;

            ShowPrompt(v115);

            if u3 then
                LayoutKeybind();
                LayoutTutorialCard();
            end;
        end);

        return;
    end;

    local v116 = u7 ~= nil;
    u7 = nil;
    u3 = false;

    if u11 and u12 ~= (IsTutorialMode() or IsBotLobby()) then
        local v117 = u11;
        u11 = nil;

        if u12 then
            if v117 and v117.Parent then
                RemoveTutorialCard(v117);
            end;
        else
            Notification.removeNotification("BuyMenuHint");
        end;
    end;

    if u11 or v116 then
        local v118 = u11;
        u11 = nil;

        if u12 then
            if v118 and v118.Parent then
                RemoveTutorialCard(v118);
            end;
        else
            Notification.removeNotification("BuyMenuHint");
        end;
    end;

    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    u4 = false;
    u5 = false;
    u6 = (1 / 0);
end;

function v1.GetHintState() -- Line: 756
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.GetFloatingSlot() -- Line: 765
    -- upvalues: IsTutorialMode (copy), IsBotLobby (copy), u11 (ref), u12 (ref), u8 (ref), GetTutorialCardSlot (copy)
    if not (IsTutorialMode() or IsBotLobby()) then
        return nil;
    end;

    local v119 = u11;

    if not (u12 and (v119 and v119.Parent)) then
        return GetTutorialCardSlot();
    end;

    local v120 = u8;
    local v121;

    if v120 and v120:IsA("GuiBase2d") then
        v121 = v120.AbsolutePosition;
    else
        v121 = Vector2.zero;
    end;

    return UDim2.fromOffset(v119.AbsolutePosition.X + v119.AbsoluteSize.X / 2 - v121.X, v119.AbsolutePosition.Y - v121.Y - 10);
end;

function v1.Initialize(p122: any, p123: userdata) -- Line: 786
    -- upvalues: u8 (ref), u9 (ref), u7 (ref), u3 (ref), IsTutorialMode (copy), IsBotLobby (copy), u11 (ref), u12 (ref), RemoveTutorialCard (copy), Notification (copy), DataController (copy), LocalPlayer (copy), RefreshPrompt (copy), UserInputService (copy), SyncUpdateConnection (copy)
    u8 = p123.Parent;
    local Keybind = p123:FindFirstChild("Keybind");

    if not (Keybind and Keybind:IsA("ImageButton")) then
        Keybind = nil;
    end;

    u9 = Keybind;
    p123.Visible = false;
    local v124 = u7 ~= nil;
    u7 = nil;
    u3 = false;

    if u11 and u12 ~= (IsTutorialMode() or IsBotLobby()) then
        local v125 = u11;
        u11 = nil;

        if u12 then
            if v125 and v125.Parent then
                RemoveTutorialCard(v125);
            end;
        else
            Notification.removeNotification("BuyMenuHint");
        end;
    end;

    if u11 or v124 then
        local v126 = u11;
        u11 = nil;

        if u12 then
            if v126 and v126.Parent then
                RemoveTutorialCard(v126);
            end;
        else
            Notification.removeNotification("BuyMenuHint");
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p127) -- Line: 795
        -- upvalues: RefreshPrompt (ref)
        if p127 then
            task.defer(RefreshPrompt);
        end;
    end);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(RefreshPrompt);
    LocalPlayer:GetAttributeChangedSignal("BuyMenu"):Connect(SyncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(SyncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(SyncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(SyncUpdateConnection);
    LocalPlayer.CharacterRemoving:Connect(SyncUpdateConnection);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(SyncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("Slot5"):Connect(SyncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("CurrentEquipped"):Connect(SyncUpdateConnection);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(SyncUpdateConnection);
    workspace:GetAttributeChangedSignal("BotLobby"):Connect(SyncUpdateConnection);
    SyncUpdateConnection();
end;

return v1;