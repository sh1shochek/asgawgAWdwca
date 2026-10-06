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

local function computePriority(p8, p9) -- Line: 73
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

local function hasHoveredInteractables() -- Line: 99
    -- upvalues: CollectionService (copy)
    return #CollectionService:GetTagged("IsHoveringInteractable") > 0;
end;

local function createCard(p10: userdata?) -- Line: 106
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
    end;

    return v12;
end;

local function paintAccent() -- Line: 141
    -- upvalues: u3 (ref), GetPreferenceColor (copy)
    local v14 = u3;

    if not v14 then
        return;
    end;

    local v15 = GetPreferenceColor();
    v14.Left.BackgroundColor3 = v15;
    v14.Right.BackgroundColor3 = v15;
end;

local function refreshKeybind() -- Line: 152
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

local function setCardShown(p17: boolean) -- Line: 164
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

local function placeCard(p21) -- Line: 184
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

local function layoutCard(p23) -- Line: 212
    local X = p23.AbsoluteSize.X;

    if X <= 0 then
        return;
    end;

    local TextLabel = p23.TextLabel;
    local Keybind = p23:FindFirstChild("Keybind");
    local v24;

    if Keybind == nil then
        v24 = false;
    else
        v24 = Keybind:IsA("GuiObject") and Keybind.Visible;
    end;

    local v25 = not v24 and 0 or Keybind.AbsoluteSize.X / X;
    local v26 = v24 and 0.02 or 0;
    local v27 = 0.88 - v25 - v26;
    TextLabel.Size = UDim2.fromScale(v27, TextLabel.Size.Y.Scale);
    local math_min_ret = math.min(TextLabel.TextBounds.X / X, v27);
    local v28 = 0.5 - (v25 + v26 + math_min_ret) / 2;

    if v24 then
        Keybind.Position = UDim2.fromScale(v28 + v25 * Keybind.AnchorPoint.X, 0.5);
    end;

    TextLabel.Position = UDim2.fromScale(v28 + v25 + v26 + math_min_ret / 2, 0.5);
end;

local function shouldRunUpdate() -- Line: 239
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), CollectionService (copy)
    local v29 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    if v29 then
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v29 = false;
        else
            v29 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
        end;
    end;

    return v29;
end;

local function stopUpdateConnection() -- Line: 245
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function syncUpdateConnection() -- Line: 252
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), CollectionService (copy), u5 (ref), RunServiceController (copy), u1 (copy), u3 (ref), u4 (ref)
    local v30 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    if v30 then
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v30 = false;
        else
            v30 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
        end;
    end;

    if v30 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p31) -- Line: 258
            -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
            local v32 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

            if v32 then
                if LocalPlayer:GetAttribute("IsSpectating") == true then
                    v32 = false;
                else
                    v32 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                end;
            end;

            if v32 then
                u1.Render(p31);

                return;
            end;

            local v33 = u3;

            if v33 and u4 ~= false then
                u4 = false;
                v33.Visible = false;
            end;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    local v34 = u3;

    if v34 and u4 ~= false then
        u4 = false;
        v34.Visible = false;
    end;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function trackCharacter(p35: userdata?) -- Line: 275
    -- upvalues: u6 (ref), u7 (ref), syncUpdateConnection (copy), CharacterResolver (copy), LocalPlayer (copy), CollectionService (copy), u5 (ref), RunServiceController (copy), u1 (copy), u3 (ref), u4 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if p35 then
        u6 = p35:GetAttributeChangedSignal("Dead"):Connect(syncUpdateConnection);
        u7 = p35.ChildAdded:Connect(function(p36: userdata) -- Line: 287
            -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u5 (ref), RunServiceController (ref), u1 (ref), u3 (ref), u4 (ref)
            if p36:IsA("Humanoid") then
                local v37 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

                if v37 then
                    if LocalPlayer:GetAttribute("IsSpectating") == true then
                        v37 = false;
                    else
                        v37 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                    end;
                end;

                if v37 then
                    if u5 then
                        return;
                    end;

                    u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p38) -- Line: 258
                        -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
                        local v39 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

                        if v39 then
                            if LocalPlayer:GetAttribute("IsSpectating") == true then
                                v39 = false;
                            else
                                v39 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                            end;
                        end;

                        if v39 then
                            u1.Render(p38);

                            return;
                        end;

                        local v40 = u3;

                        if v40 and u4 ~= false then
                            u4 = false;
                            v40.Visible = false;
                        end;

                        if u5 then
                            u5:Disconnect();
                            u5 = nil;
                        end;
                    end);

                    return;
                end;

                local v41 = u3;

                if v41 and u4 ~= false then
                    u4 = false;
                    v41.Visible = false;
                end;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end;
        end);
    end;

    local v42 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    if v42 then
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v42 = false;
        else
            v42 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
        end;
    end;

    if v42 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p43) -- Line: 258
            -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
            local v44 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

            if v44 then
                if LocalPlayer:GetAttribute("IsSpectating") == true then
                    v44 = false;
                else
                    v44 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                end;
            end;

            if v44 then
                u1.Render(p43);

                return;
            end;

            local v45 = u3;

            if v45 and u4 ~= false then
                u4 = false;
                v45.Visible = false;
            end;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    local v46 = u3;

    if v46 and u4 ~= false then
        u4 = false;
        v46.Visible = false;
    end;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

function u1.Render(p47) -- Line: 300
    -- upvalues: u3 (ref), HoverBomb (copy), u4 (ref), CollectionService (copy), computePriority (copy), GetSkinDisplayName (copy), Skins (copy), Rarities (copy), u2 (ref), BuyMenuHint (copy), UDim2_fromScale_ret2 (copy), Vector2_new_ret (ref), UDim2_fromScale_ret (copy), setCardShown (copy), layoutCard (copy)
    local v48 = u3;

    if not v48 then
        return;
    end;

    if HoverBomb.GetHoverState() then
        local v49 = u3;

        if v49 then
            if u4 == false then
                return;
            end;

            u4 = false;
            v49.Visible = false;
        end;

        return;
    end;

    local Tagged = CollectionService:GetTagged("IsHoveringInteractable");
    table.sort(Tagged, computePriority);
    local v50 = Tagged[1];

    if not v50 then
        local v51 = u3;

        if v51 then
            if u4 == false then
                return;
            end;

            u4 = false;
            v51.Visible = false;
        end;

        return;
    end;

    local Attribute = v50:GetAttribute("Weapon");
    local Attribute2 = v50:GetAttribute("Skin");
    local v52 = GetSkinDisplayName(Attribute2);
    local Attribute3 = v50:GetAttribute("NameTag");
    local v53 = GetSkinDisplayName.FormatNameLabelText(GetSkinDisplayName.GetWeaponDisplayName(Attribute, Attribute3), Attribute3);
    local SkinInformation = Skins.GetSkinInformation(Attribute, Attribute2);
    assert(SkinInformation, "Skin data not found for weapon: " .. Attribute .. " and skin: " .. Attribute2);
    local v54 = Rarities[SkinInformation.rarity];
    local math_floor_ret = math.floor(v54.Color.R * 255);
    local math_floor_ret2 = math.floor(v54.Color.G * 255);
    local math_floor_ret3 = math.floor(v54.Color.B * 255);
    v48.TextLabel.Text = `Swap for <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{v53} | {v52}</b></font>`;
    local v55 = u2;

    if v55 then
        local FloatingSlot = BuyMenuHint.GetFloatingSlot();

        if FloatingSlot then
            v48.Parent = v55;
            v48.AnchorPoint = Vector2.new(0.5, 1);
            v48.Position = FloatingSlot;
            v48.Size = UDim2_fromScale_ret2;
        else
            local Notification = v55:FindFirstChild("Notification");

            if Notification then
                v48.Parent = Notification;
                v48.AnchorPoint = Vector2_new_ret;
                v48.Size = UDim2_fromScale_ret;
            end;
        end;
    end;

    setCardShown(true);
    layoutCard(v48);
end;

function u1.Initialize(p56, p57) -- Line: 345
    -- upvalues: u2 (ref), u3 (ref), createCard (copy), CollectionService (copy), syncUpdateConnection (copy), LocalPlayer (copy), trackCharacter (copy), u6 (ref), u7 (ref), CharacterResolver (copy), u5 (ref), RunServiceController (copy), u1 (copy), u4 (ref), DataController (copy), refreshKeybind (copy), UserInputService (copy), Tips (copy), paintAccent (copy)
    u2 = p57.Parent;
    p57.Visible = false;
    u3 = createCard(p57:FindFirstChild("Keybind"));
    CollectionService:GetInstanceAddedSignal("IsHoveringInteractable"):Connect(syncUpdateConnection);
    CollectionService:GetInstanceRemovedSignal("IsHoveringInteractable"):Connect(syncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(syncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(trackCharacter);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 355
        -- upvalues: u6 (ref), u7 (ref), CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u5 (ref), RunServiceController (ref), u1 (ref), u3 (ref), u4 (ref)
        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        if u7 then
            u7:Disconnect();
            u7 = nil;
        end;

        local v58 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

        if v58 then
            if LocalPlayer:GetAttribute("IsSpectating") == true then
                v58 = false;
            else
                v58 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
            end;
        end;

        if v58 then
            if u5 then
                return;
            end;

            u5 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p59) -- Line: 258
                -- upvalues: CharacterResolver (ref), LocalPlayer (ref), CollectionService (ref), u1 (ref), u3 (ref), u4 (ref), u5 (ref)
                local v60 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);

                if v60 then
                    if LocalPlayer:GetAttribute("IsSpectating") == true then
                        v60 = false;
                    else
                        v60 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
                    end;
                end;

                if v60 then
                    u1.Render(p59);

                    return;
                end;

                local v61 = u3;

                if v61 and u4 ~= false then
                    u4 = false;
                    v61.Visible = false;
                end;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end);

            return;
        end;

        local v62 = u3;

        if v62 and u4 ~= false then
            u4 = false;
            v62.Visible = false;
        end;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;
    end);
    trackCharacter(LocalPlayer.Character);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", refreshKeybind);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(refreshKeybind);
    local v63 = u3;

    if v63 then
        v63 = v63:FindFirstChild("Keybind");
    end;

    if v63 and v63:IsA("ImageButton") then
        v63.Visible = Tips.ApplyBindingToKeybind(v63, Tips.ResolveActionBinding("Use"));
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", paintAccent);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(paintAccent);
end;

return u1;