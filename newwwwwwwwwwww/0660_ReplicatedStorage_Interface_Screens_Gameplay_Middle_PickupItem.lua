-- PickupItem (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.PickupItem

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);
local HoverBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb);
local BuyMenuHint = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenuHint);
require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification.Types);
local UDim2_fromScale_ret = UDim2.fromScale(0.9, 0.12);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.225, 0.054);
local TweenInfo_new_ret = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = nil;
local u3 = nil;
local Vector2_new_ret = Vector2.new(0.5, 0.5);
local u4 = false;
local u5 = nil;
local u6 = nil;
local u7 = nil;

local function computePriority(p8, p9) -- Line: 77
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character.PrimaryPart) then
        return false;
    end;

    if p8:GetAttribute("HoveringState") == "Hovering" then
        return true;
    end;

    if p9:GetAttribute("HoveringState") == "Hovering" then
        return false;
    end;

    if p8:GetAttribute("CanPickup") == false then
        return false;
    end;

    if p9:GetAttribute("CanPickup") == false then
        return true;
    end;

    if p8.PrimaryPart and p9.PrimaryPart then
        return (Character.PrimaryPart.Position - p8.PrimaryPart.Position).Magnitude < (Character.PrimaryPart.Position - p9.PrimaryPart.Position).Magnitude;
    end;

    return false;
end;

local function hasHoveredInteractables() -- Line: 103
    -- upvalues: CollectionService (copy)
    return #CollectionService:GetTagged("IsHoveringInteractable") > 0;
end;

local function createCard(p10: userdata?) -- Line: 110
    -- upvalues: ReplicatedStorage (copy), Vector2_new_ret (ref)
    local Notification = ReplicatedStorage.Assets.UI.Notification;
    local v11 = Notification:FindFirstChild("Keybind") or Notification:FindFirstChild("Default");

    if not (v11 and v11:IsA("GuiObject")) then
        warn("[PickupItem]: ReplicatedStorage.Assets.UI.Notification has no \"Keybind\" template");

        return nil;
    end;

    local v12 = v11:Clone();
    v12.Name = "PickupItem";
    v12.LayoutOrder = -1;
    v12.Visible = false;
    Vector2_new_ret = v12.AnchorPoint;

    if not v12:FindFirstChild("Keybind") and (p10 and p10:IsA("ImageButton")) then
        local v13 = p10:Clone();
        v13.Name = "Keybind";
        v13.AnchorPoint = Vector2.new(0, 0.5);
        v13.Size = UDim2.fromScale(0.66, 0.66);
        v13.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        v13.Parent = v12;
    end;

    local TextLabel = v12:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.RichText = true;
        TextLabel.TextWrapped = false;
        TextLabel.TextScaled = false;
    end;

    return v12;
end;

local function paintAccent() -- Line: 147
    -- upvalues: u3 (ref), GetPreferenceColor (copy)
    local v14 = u3;

    if not v14 then
        return;
    end;

    local v15 = GetPreferenceColor();
    v14.Left.BackgroundColor3 = v15;
    v14.Right.BackgroundColor3 = v15;
end;

local function refreshKeybind() -- Line: 158
    -- upvalues: u3 (ref), Tips (copy)
    local v16 = u3;

    if v16 then
        v16 = v16:FindFirstChild("Keybind");
    end;

    if not (v16 and v16:IsA("ImageButton")) then
        return;
    end;

    v16.Visible = Tips.ApplyBindingToKeybind(v16, Tips.ResolveActionBinding("Use"));
end;

local function setCardShown(p17: boolean) -- Line: 170
    -- upvalues: u3 (ref), u4 (ref), GetPreferenceColor (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local v18 = u3;

    if not v18 or p17 == u4 then
        return;
    end;

    u4 = p17;
    v18.Visible = p17;

    if not p17 then
        return;
    end;

    local v19 = u3;

    if v19 then
        local v20 = GetPreferenceColor();
        v19.Left.BackgroundColor3 = v20;
        v19.Right.BackgroundColor3 = v20;
    end;

    if v18:IsA("CanvasGroup") then
        v18.GroupTransparency = 1;
        TweenService:Create(v18, TweenInfo_new_ret, {
            GroupTransparency = 0
        }):Play();
    end;
end;

local function placeCard(p21) -- Line: 190
    -- upvalues: u2 (ref), BuyMenuHint (copy), UDim2_fromScale_ret2 (copy), Vector2_new_ret (ref), UDim2_fromScale_ret (copy)
    local v22 = u2;

    if not v22 then
        return;
    end;

    local FloatingSlot = BuyMenuHint.GetFloatingSlot();

    if not FloatingSlot then
        local Notification = v22:FindFirstChild("Notification");

        if Notification then
            p21.Parent = Notification;
            p21.AnchorPoint = Vector2_new_ret;
            p21.Size = UDim2_fromScale_ret;
        end;

        return;
    end;

    p21.Parent = v22;
    p21.AnchorPoint = Vector2.new(0.5, 1);
    p21.Position = FloatingSlot;
    p21.Size = UDim2_fromScale_ret2;
end;

local u23 = setmetatable({}, {
    __mode = "k"
});

local function layoutCard(p24) -- Line: 223
    -- upvalues: u23 (copy)
    local X = p24.AbsoluteSize.X;

    if X <= 0 then
        return;
    end;

    local TextLabel = p24.TextLabel;
    local Keybind = p24:FindFirstChild("Keybind");
    local v25;

    if Keybind == nil then
        v25 = false;
    else
        v25 = Keybind:IsA("GuiObject") and Keybind.Visible;
    end;

    local v26 = not v25 and 0 or Keybind.AbsoluteSize.X / X;
    local v27 = v25 and 0.02 or 0;
    local v28 = 0.88 - v26 - v27;
    TextLabel.Size = UDim2.fromScale(v28, 1);
    local Y = p24.AbsoluteSize.Y;
    local v29 = v28 * X;
    local v30 = u23[p24];

    if v30 and (v30.Text == TextLabel.Text and (v30.Height == Y and v30.Room == v29)) then
        if TextLabel.TextSize ~= v30.Size then
            TextLabel.TextSize = v30.Size;
        end;
    else
        local math_floor_ret = math.floor(Y * 0.7);
        TextLabel.TextSize = math.max(math_floor_ret, 8);

        if v29 < TextLabel.TextBounds.X then
            local math_floor_ret2 = math.floor(TextLabel.TextSize * v29 / TextLabel.TextBounds.X);
            TextLabel.TextSize = math.max(math_floor_ret2, 8);
        end;

        u23[p24] = {
            Text = TextLabel.Text,
            Height = Y,
            Room = v29,
            Size = TextLabel.TextSize
        };
    end;

    local math_min_ret = math.min(TextLabel.TextBounds.X / X, v28);
    local v31 = 0.5 - (v26 + v27 + math_min_ret) / 2;

    if v25 then
        Keybind.Position = UDim2.fromScale(v31 + v26 * Keybind.AnchorPoint.X, 0.5);
    end;

    TextLabel.Position = UDim2.fromScale(v31 + v26 + v27 + math_min_ret / 2, 0.5);
end;

local function shouldRunUpdate() -- Line: 265
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), CollectionService (copy)
    local v32 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    if v32 then
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v32 = false;
        else
            v32 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
        end;
    end;

    return v32;
end;

local function stopUpdateConnection() -- Line: 271
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function syncUpdateConnection() -- Line: 278
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), CollectionService (copy), u5 (ref), RunServiceController (copy), u1 (copy), u3 (ref), u4 (ref)
    local v33 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    if v33 then
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v33 = false;
        else
            v33 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
        end;
    end;

    if v33 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p34) -- Line: 284
            -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
            local v35 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

            if v35 then
                if LocalPlayer:GetAttribute("IsSpectating") == true then
                    v35 = false;
                else
                    v35 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                end;
            end;

            if v35 then
                u1.Render(p34);

                return;
            end;

            local v36 = u3;

            if v36 and u4 ~= false then
                u4 = false;
                v36.Visible = false;
            end;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    local v37 = u3;

    if v37 and u4 ~= false then
        u4 = false;
        v37.Visible = false;
    end;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function trackCharacter(p38: userdata?) -- Line: 301
    -- upvalues: u6 (ref), u7 (ref), syncUpdateConnection (copy), CharacterResolver (copy), LocalPlayer (copy), CollectionService (copy), u5 (ref), RunServiceController (copy), u1 (copy), u3 (ref), u4 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if p38 then
        u6 = p38:GetAttributeChangedSignal("Dead"):Connect(syncUpdateConnection);
        u7 = p38.ChildAdded:Connect(function(p39: userdata) -- Line: 313
            -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u5 (ref), RunServiceController (ref), u1 (ref), u3 (ref), u4 (ref)
            if p39:IsA("Humanoid") then
                local v40 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

                if v40 then
                    if LocalPlayer:GetAttribute("IsSpectating") == true then
                        v40 = false;
                    else
                        v40 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                    end;
                end;

                if v40 then
                    if u5 then
                        return;
                    end;

                    u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p41) -- Line: 284
                        -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
                        local v42 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

                        if v42 then
                            if LocalPlayer:GetAttribute("IsSpectating") == true then
                                v42 = false;
                            else
                                v42 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                            end;
                        end;

                        if v42 then
                            u1.Render(p41);

                            return;
                        end;

                        local v43 = u3;

                        if v43 and u4 ~= false then
                            u4 = false;
                            v43.Visible = false;
                        end;

                        if u5 then
                            u5:Disconnect();
                            u5 = nil;
                        end;
                    end);

                    return;
                end;

                local v44 = u3;

                if v44 and u4 ~= false then
                    u4 = false;
                    v44.Visible = false;
                end;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end;
        end);
    end;

    local v45 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    if v45 then
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v45 = false;
        else
            v45 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
        end;
    end;

    if v45 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p46) -- Line: 284
            -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
            local v47 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

            if v47 then
                if LocalPlayer:GetAttribute("IsSpectating") == true then
                    v47 = false;
                else
                    v47 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                end;
            end;

            if v47 then
                u1.Render(p46);

                return;
            end;

            local v48 = u3;

            if v48 and u4 ~= false then
                u4 = false;
                v48.Visible = false;
            end;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    local v49 = u3;

    if v49 and u4 ~= false then
        u4 = false;
        v49.Visible = false;
    end;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

function u1.Render(p50) -- Line: 326
    -- upvalues: u3 (ref), HoverBomb (copy), u4 (ref), CollectionService (copy), computePriority (copy), GetSkinDisplayName (copy), Skins (copy), Rarities (copy), u2 (ref), BuyMenuHint (copy), UDim2_fromScale_ret2 (copy), Vector2_new_ret (ref), UDim2_fromScale_ret (copy), setCardShown (copy), layoutCard (copy)
    local v51 = u3;

    if not v51 then
        return;
    end;

    if HoverBomb.GetHoverState() then
        local v52 = u3;

        if v52 then
            if u4 == false then
                return;
            end;

            u4 = false;
            v52.Visible = false;
        end;

        return;
    end;

    local Tagged = CollectionService:GetTagged("IsHoveringInteractable");
    table.sort(Tagged, computePriority);
    local v53 = Tagged[1];

    if not v53 then
        local v54 = u3;

        if v54 then
            if u4 == false then
                return;
            end;

            u4 = false;
            v54.Visible = false;
        end;

        return;
    end;

    local Attribute = v53:GetAttribute("Weapon");
    local Attribute2 = v53:GetAttribute("Skin");
    local v55 = GetSkinDisplayName(Attribute2);
    local Attribute3 = v53:GetAttribute("NameTag");
    local v56 = GetSkinDisplayName.FormatNameLabelText(GetSkinDisplayName.GetWeaponDisplayName(Attribute, Attribute3), Attribute3);
    local SkinInformation = Skins.GetSkinInformation(Attribute, Attribute2);
    assert(SkinInformation, "Skin data not found for weapon: " .. Attribute .. " and skin: " .. Attribute2);
    local v57 = Rarities[SkinInformation.rarity];
    local math_floor_ret = math.floor(v57.Color.R * 255);
    local math_floor_ret2 = math.floor(v57.Color.G * 255);
    local math_floor_ret3 = math.floor(v57.Color.B * 255);
    local TextLabel = v51.TextLabel;
    local v58;

    if Attribute == "C4" then
        v58 = `Pick up <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>C4</b></font>`;
    else
        v58 = `Swap for <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{v56} | {v55}</b></font>`;
    end;

    TextLabel.Text = v58;
    local v59 = u2;

    if v59 then
        local FloatingSlot = BuyMenuHint.GetFloatingSlot();

        if FloatingSlot then
            v51.Parent = v59;
            v51.AnchorPoint = Vector2.new(0.5, 1);
            v51.Position = FloatingSlot;
            v51.Size = UDim2_fromScale_ret2;
        else
            local Notification = v59:FindFirstChild("Notification");

            if Notification then
                v51.Parent = Notification;
                v51.AnchorPoint = Vector2_new_ret;
                v51.Size = UDim2_fromScale_ret;
            end;
        end;
    end;

    setCardShown(true);
    layoutCard(v51);
end;

function u1.Initialize(p60, p61) -- Line: 374
    -- upvalues: u2 (ref), u3 (ref), createCard (copy), CollectionService (copy), syncUpdateConnection (copy), LocalPlayer (copy), trackCharacter (copy), u6 (ref), u7 (ref), CharacterResolver (copy), u5 (ref), RunServiceController (copy), u1 (copy), u4 (ref), DataController (copy), refreshKeybind (copy), UserInputService (copy), Tips (copy), paintAccent (copy)
    u2 = p61.Parent;
    p61.Visible = false;
    u3 = createCard(p61:FindFirstChild("Keybind"));
    CollectionService:GetInstanceAddedSignal("IsHoveringInteractable"):Connect(syncUpdateConnection);
    CollectionService:GetInstanceRemovedSignal("IsHoveringInteractable"):Connect(syncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(syncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(trackCharacter);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 384
        -- upvalues: u6 (ref), u7 (ref), CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u5 (ref), RunServiceController (ref), u1 (ref), u3 (ref), u4 (ref)
        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        if u7 then
            u7:Disconnect();
            u7 = nil;
        end;

        local v62 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

        if v62 then
            if LocalPlayer:GetAttribute("IsSpectating") == true then
                v62 = false;
            else
                v62 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
            end;
        end;

        if v62 then
            if u5 then
                return;
            end;

            u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p63) -- Line: 284
                -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
                local v64 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

                if v64 then
                    if LocalPlayer:GetAttribute("IsSpectating") == true then
                        v64 = false;
                    else
                        v64 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                    end;
                end;

                if v64 then
                    u1.Render(p63);

                    return;
                end;

                local v65 = u3;

                if v65 and u4 ~= false then
                    u4 = false;
                    v65.Visible = false;
                end;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end);

            return;
        end;

        local v66 = u3;

        if v66 and u4 ~= false then
            u4 = false;
            v66.Visible = false;
        end;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;
    end);
    trackCharacter(LocalPlayer.Character);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", refreshKeybind);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(refreshKeybind);
    local v67 = u3;

    if v67 then
        v67 = v67:FindFirstChild("Keybind");
    end;

    if v67 and v67:IsA("ImageButton") then
        v67.Visible = Tips.ApplyBindingToKeybind(v67, Tips.ResolveActionBinding("Use"));
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", paintAccent);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(paintAccent);
end;

return u1;