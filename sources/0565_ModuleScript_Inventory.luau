-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot);
local GetInventoryItemIcon = require(ReplicatedStorage.Components.Common.GetInventoryItemIcon);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local u2 = nil;
local u3 = 0;
local u4 = nil;
local u5 = nil;
local u6 = {};
local u7 = nil;
local u8 = table.find(GetUserPlatform(), "Console") and #GetUserPlatform() <= 1;
local u9 = { {
        type = "Primary",
        space = 1
    }, {
        type = "Secondary",
        space = 1
    }, {
        type = "Melee",
        space = 2
    }, {
        type = "Grenade",
        space = 4
    }, {
        type = "C4",
        space = 1
    } };
local u10 = utf8.char(9733) .. " ";
local Color3_new_ret = Color3.new(1, 1, 1);
local u11 = {};
local u12 = {};
local u13 = nil;

local function getWeaponFrames() -- Line: 117
    -- upvalues: u13 (ref)
    return u13 and { u13.Primary, u13.Secondary, u13.Melee } or nil;
end;

local function isZeusWeapon(p14) -- Line: 124
    local v15;

    if p14 == nil then
        v15 = false;
    else
        v15 = p14.Name == "Zeus x27";
    end;

    return v15;
end;

local function shouldDisplaySkinSuffix(p16: string) -- Line: 128
    local v17;

    if p16 == "Vanilla" then
        v17 = false;
    else
        v17 = p16 ~= "Stock";
    end;

    return v17;
end;

local function getInventoryItemDisplayName(p18: any, p19: string) -- Line: 132
    -- upvalues: u10 (copy), GetSkinDisplayName (copy), LocalPlayer (copy)
    local v20;

    if p19 == "Melee" then
        local v21;

        if p18 == nil then
            v21 = false;
        else
            v21 = p18.Name == "Zeus x27";
        end;

        v20 = v21 and "" or (u10 or "");
    else
        v20 = "";
    end;

    local v22 = GetSkinDisplayName.GetNameTag(p18.NameTag) ~= nil;
    local v23 = v20 .. GetSkinDisplayName.GetWeaponDisplayName(p18.Name, p18.NameTag);

    if p18.Skin and not v22 then
        local v24 = GetSkinDisplayName(p18.Skin);
        local v25;

        if v24 == "Vanilla" then
            v25 = false;
        else
            v25 = v24 ~= "Stock";
        end;

        v23 = v23 .. (v25 and " | " .. v24 or "");
    end;

    local v26 = not (v22 or p18.Name ~= "T Knife" and p18.Name ~= "CT Knife") and "Knife" or v23;
    local OriginalOwner = p18.OriginalOwner;

    if OriginalOwner and (OriginalOwner ~= "" and OriginalOwner ~= LocalPlayer.Name) then
        return `{OriginalOwner}'s "{v26}"`;
    end;

    if v22 then
        v26 = `"{v26}"`;
    end;

    return v26;
end;

local function getWeaponColor(p27) -- Line: 163
    -- upvalues: DataController (copy), LocalPlayer (copy), GetPreferenceColor (copy), GetResolvedSkinInformation (copy), Rarities (copy)
    if not p27 or DataController.Get(LocalPlayer, "Settings.Game.HUD.Glow Weapon with Rarity Color") ~= true then
        return GetPreferenceColor();
    end;

    local v28 = GetResolvedSkinInformation(p27.Name, p27.Skin);
    local v29 = v28 and v28.rarity and Rarities[v28.rarity];

    if v29 then
        return v29.Color;
    end;

    return GetPreferenceColor();
end;

local function getLabelFromContainer(p30: userdata?, p31: string) -- Line: 174
    if not p30 then
        return nil;
    end;

    if p30:IsA(p31) then
        return p30;
    end;

    return p30:FindFirstChildWhichIsA(p31, true);
end;

local function getImageLabelFromContainer(p32: userdata?) -- Line: 186
    -- upvalues: getLabelFromContainer (copy)
    return getLabelFromContainer(p32, "ImageLabel");
end;

local function getTextLabelFromContainer(p33: userdata?) -- Line: 190
    -- upvalues: getLabelFromContainer (copy)
    return getLabelFromContainer(p33, "TextLabel");
end;

local function getMeleeImageLabels(p34) -- Line: 194
    local Weapon = p34:FindFirstChild("Weapon");
    local v35;

    if Weapon then
        v35 = Weapon:FindFirstChild("Melee") or nil;
    else
        v35 = nil;
    end;

    if v35 then
        if not v35:IsA("ImageLabel") then
            v35 = v35:FindFirstChildWhichIsA("ImageLabel", true);
        end;
    else
        v35 = nil;
    end;

    local Zeus = p34:FindFirstChild("Zeus");

    if not Zeus then
        if Weapon then
            Zeus = Weapon:FindFirstChild("Zeus") or nil;
        else
            Zeus = nil;
        end;
    end;

    if Zeus then
        if not Zeus:IsA("ImageLabel") then
            Zeus = Zeus:FindFirstChildWhichIsA("ImageLabel", true);
        end;
    else
        Zeus = nil;
    end;

    if not v35 and (Weapon and Weapon:IsA("Frame")) then
        v35 = Weapon:FindFirstChildOfClass("ImageLabel");
    end;

    return v35, Zeus;
end;

local function getMeleeWeaponNameLabels(p36) -- Line: 209
    local Weapon = p36:FindFirstChild("Weapon");
    local v37;

    if Weapon then
        v37 = Weapon:FindFirstChild("WeaponName") or nil;
    else
        v37 = nil;
    end;

    if v37 then
        if not v37:IsA("TextLabel") then
            v37 = v37:FindFirstChildWhichIsA("TextLabel", true);
        end;
    else
        v37 = nil;
    end;

    local v38 = p36:FindFirstChild("Zeus") or (Weapon and Weapon:FindFirstChild("Zeus") or nil);

    if not v38 then
        return v37, nil;
    end;

    if v38:IsA("TextLabel") then
        return v37, v38;
    end;

    return v37, v38:FindFirstChildWhichIsA("TextLabel", true);
end;

local function getFrameWeaponImageLabel(p39, p40) -- Line: 220
    -- upvalues: getMeleeImageLabels (copy)
    if not p39 then
        return nil;
    end;

    if p39.Name ~= "Melee" then
        return p39.Weapon:FindFirstChildOfClass("ImageLabel");
    end;

    local v41, v42 = getMeleeImageLabels(p39);
    local v43;

    if p40 == nil then
        v43 = false;
    else
        v43 = p40.Name == "Zeus x27";
    end;

    if v43 then
        v41 = v42 or v41;
    end;

    return v41;
end;

local function getFrameWeaponNameLabel(p44, p45) -- Line: 236
    -- upvalues: getMeleeWeaponNameLabels (copy)
    if not p44 then
        return nil;
    end;

    if p44.Name ~= "Melee" then
        return p44.Weapon:FindFirstChild("WeaponName");
    end;

    local v46, v47 = getMeleeWeaponNameLabels(p44);
    local v48;

    if p45 == nil then
        v48 = false;
    else
        v48 = p45.Name == "Zeus x27";
    end;

    if v48 then
        v46 = v47 or v46;
    end;

    return v46;
end;

local function clearFrameWeaponNameLabels(p49) -- Line: 252
    -- upvalues: getMeleeWeaponNameLabels (copy)
    if not p49 then
        return;
    end;

    if p49.Name ~= "Melee" then
        local WeaponName = p49.Weapon:FindFirstChild("WeaponName");

        if WeaponName then
            WeaponName.Visible = false;
            WeaponName.Text = "";
        end;

        return;
    end;

    local v50, v51 = getMeleeWeaponNameLabels(p49);

    if v50 then
        v50.Visible = false;
        v50.Text = "";
    end;

    if v51 then
        v51.Visible = false;
        v51.Text = "";
    end;
end;

local function getVisibleWeaponImageLabel(p52) -- Line: 277
    -- upvalues: getMeleeImageLabels (copy)
    if not p52 then
        return nil;
    end;

    if p52.Name == "Melee" then
        local v53, v54 = getMeleeImageLabels(p52);

        if v54 and v54.Visible then
            return v54;
        end;

        if v53 and v53.Visible then
            return v53;
        end;
    end;

    return p52.Weapon:FindFirstChildOfClass("ImageLabel");
end;

local function updateMeleeInventoryFrame(p55, p56, p57) -- Line: 295
    -- upvalues: getMeleeImageLabels (copy), getMeleeWeaponNameLabels (copy), getWeaponColor (copy), GetSkinDisplayName (copy), getInventoryItemDisplayName (copy)
    local v58, v59 = getMeleeImageLabels(p55);
    local v60, v61 = getMeleeWeaponNameLabels(p55);
    p55:SetAttribute("Slot", 3);
    p55.Keybind.Text = "3";
    local v62 = {};
    local v63 = nil;
    local v64 = nil;

    for _, v in ipairs(p56._items) do
        local v65 = `${v.Name}<{v.Identifier}>`;
        table.insert(v62, v65);
        local v66;

        if v == nil then
            v66 = false;
        else
            v66 = v.Name == "Zeus x27";
        end;

        if v66 then
            v64 = v;
        else
            v63 = v;
        end;
    end;

    if v58 then
        v58.Visible = v63 ~= nil;
    end;

    if v63 and v58 then
        v58.Image = v63.Properties.Icon;
        v58.ImageColor3 = getWeaponColor(v63);
    end;

    if v59 then
        v59.Visible = v64 ~= nil;
    end;

    if v64 and v59 then
        v59.Image = v64.Properties.Icon;
        v59.ImageColor3 = getWeaponColor(v64);
    end;

    local v67;

    if p57 and p57.Properties.Slot == "Melee" then
        v67 = p57;
    else
        v67 = v63 or v64;
    end;

    if v67 then
        local v68;

        if p55 then
            if p55.Name == "Melee" then
                local v69;
                v68, v69 = getMeleeWeaponNameLabels(p55);
                local v70;

                if v67 == nil then
                    v70 = false;
                else
                    v70 = v67.Name == "Zeus x27";
                end;

                if v70 then
                    v68 = v69 or v68;
                end;
            else
                v68 = p55.Weapon:FindFirstChild("WeaponName");
            end;
        else
            v68 = nil;
        end;

        local v71;

        if p57 == nil then
            v71 = false;
        else
            v71 = p57.Properties.Slot == "Melee";
        end;

        if v60 and v60 ~= v68 then
            v60.Visible = false;
        end;

        if v61 and v61 ~= v68 then
            v61.Visible = false;
        end;

        if v68 then
            v68.TextColor3 = getWeaponColor(v67);
            GetSkinDisplayName.ApplyNameLabel(v68, getInventoryItemDisplayName(v67, "Melee"), v67.NameTag);
            v68.Visible = v71;
        end;
    else
        p55.Equip.Visible = false;

        if p55 then
            if p55.Name == "Melee" then
                local v72, v73 = getMeleeWeaponNameLabels(p55);

                if v72 then
                    v72.Visible = false;
                    v72.Text = "";
                end;

                if v73 then
                    v73.Visible = false;
                    v73.Text = "";
                end;
            else
                local WeaponName = p55.Weapon:FindFirstChild("WeaponName");

                if WeaponName then
                    WeaponName.Visible = false;
                    WeaponName.Text = "";
                end;
            end;
        end;

        if v58 then
            v58.Visible = false;
        end;

        if v59 then
            v59.Visible = false;
        end;
    end;
end;

local function getObjectiveKitAttributeName() -- Line: 370
    local Attribute = workspace:GetAttribute("Gamemode");

    return Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);
end;

local function shouldShowObjectiveKitIcon(p74: userdata?) -- Line: 380
    if not p74 or p74:GetAttribute("Team") ~= "Counter-Terrorists" then
        return false;
    end;

    local Attribute = workspace:GetAttribute("Gamemode");
    local v75 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);
    local v76;

    if v75 == nil then
        v76 = false;
    else
        v76 = p74:GetAttribute(v75) == true;
    end;

    return v76;
end;

local function updateObjectiveKitIcon(p77: userdata?) -- Line: 389
    -- upvalues: u13 (ref)
    local DefuseKit = u13.Grenade.DefuseKit;
    local v78;

    if p77 and p77:GetAttribute("Team") == "Counter-Terrorists" then
        local Attribute = workspace:GetAttribute("Gamemode");
        local v79 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

        if v79 == nil then
            v78 = false;
        else
            v78 = p77:GetAttribute(v79) == true;
        end;
    else
        v78 = false;
    end;

    DefuseKit.Visible = v78;
end;

local function resetFadeTimer() -- Line: 393
    -- upvalues: u7 (ref), u6 (copy), u13 (ref)
    if u7 then
        task.cancel(u7);
        u7 = nil;
    end;

    for _, v in u6 do
        v:Cancel();
    end;

    table.clear(u6);
    local v80 = u13 and { u13.Primary, u13.Secondary, u13.Melee } or nil;

    if not v80 then
        return;
    end;

    for _, v in ipairs(v80) do
        if v:IsA("Frame") then
            local Equip = v:FindFirstChild("Equip");

            if Equip and Equip:IsA("Frame") then
                Equip.BackgroundTransparency = 0.225;
            end;

            for _, v2 in v:QueryDescendants("ImageLabel, TextLabel") do
                if v2:IsA("ImageLabel") then
                    v2.ImageTransparency = 0.225;
                else
                    v2.TextTransparency = 0.225;
                end;
            end;
        end;
    end;
end;

local function startFade() -- Line: 429
    -- upvalues: DataController (copy), LocalPlayer (copy), resetFadeTimer (copy), u13 (ref), TweenService (copy), u6 (copy), u7 (ref)
    local v81 = DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") ~= false;
    resetFadeTimer();

    if v81 then
        return;
    end;

    local v82 = u13 and { u13.Primary, u13.Secondary, u13.Melee } or nil;

    if not v82 then
        return;
    end;

    for _, v in ipairs(v82) do
        if v:IsA("Frame") then
            local Equip = v:FindFirstChild("Equip");

            if Equip and Equip:IsA("Frame") then
                local v83 = TweenService:Create(Equip, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                    BackgroundTransparency = 1
                });
                u6[v.Name .. "_Equip"] = v83;
                v83:Play();
            end;

            local v84 = v;

            for _, v2 in v:QueryDescendants("ImageLabel", "TextLabel") do
                local v85 = v2:IsA("ImageLabel") and {
                    ImageTransparency = 1
                } or {
                    TextTransparency = 1
                };
                local v86 = TweenService:Create(v2, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), v85);
                u6[v84.Name .. "_" .. v2:GetFullName()] = v86;
                v86:Play();
            end;
        end;
    end;

    u7 = task.delay(5, function() -- Line: 472
        -- upvalues: u7 (ref)
        u7 = nil;
    end);
end;

local function playPickupFlash(p87: userdata, p88) -- Line: 478
    -- upvalues: TweenService (copy), Color3_new_ret (copy)
    local Attribute = p87:GetAttribute("DefaultSize");

    if not Attribute then
        return;
    end;

    local UDim2_new_ret = UDim2.new(Attribute.X.Scale * 1.1, Attribute.X.Offset * 1.1, Attribute.Y.Scale * 1.1, Attribute.Y.Offset * 1.1);

    for i = 1, 6 do
        local v89 = TweenService:Create(p87, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ImageColor3 = Color3_new_ret,
            Size = UDim2_new_ret
        });
        v89:Play();
        v89.Completed:Wait();
        local v90 = TweenService:Create(p87, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            ImageColor3 = p88,
            Size = Attribute
        });
        v90:Play();
        v90.Completed:Wait();
        local _ = i;
    end;
end;

local function startPickupFlash(u91: string, u92: userdata, u93) -- Line: 518
    -- upvalues: u11 (copy), playPickupFlash (copy)
    if u11[u91] then
        task.cancel(u11[u91]);
        u11[u91] = nil;
    end;

    local Attribute = u92:GetAttribute("DefaultSize");

    if Attribute then
        u92.ImageColor3 = u93;
        u92.Size = Attribute;
    end;

    u11[u91] = task.spawn(function() -- Line: 530
        -- upvalues: playPickupFlash (ref), u92 (copy), u93 (copy), u11 (ref), u91 (copy)
        playPickupFlash(u92, u93);
        u11[u91] = nil;
    end);
end;

local function buildInventorySnapshot(p94) -- Line: 536
    local v95 = {};

    for _, v in p94 do
        local _strict_type = v._settings._strict_type;
        v95[_strict_type] = {};

        for _, v2 in v._items do
            local Identifier = v2.Identifier;

            if Identifier then
                v95[_strict_type][Identifier] = true;
            end;
        end;
    end;

    return v95;
end;

local function detectAndFlashNewItems(p96) -- Line: 551
    -- upvalues: buildInventorySnapshot (copy), u12 (ref), u13 (ref), startPickupFlash (copy), GetPreferenceColor (copy), getMeleeImageLabels (copy), getWeaponColor (copy)
    local v97 = buildInventorySnapshot(p96);

    for _, v in p96 do
        local _strict_type = v._settings._strict_type;
        local v98 = u12[_strict_type] or {};

        for i, v2 in v._items do
            local Identifier = v2.Identifier;

            if Identifier and not v98[Identifier] then
                if _strict_type == "Grenade" then
                    local v99 = u13.Grenade.Grenades:FindFirstChild((tostring(i)));

                    if v99 then
                        local Grenade = v99:FindFirstChild("Grenade");

                        if Grenade and Grenade.Visible then
                            startPickupFlash("Grenade_" .. i, Grenade, GetPreferenceColor());
                        end;
                    end;
                elseif _strict_type == "C4" then
                    local Bomb = u13.Grenade:FindFirstChild("Bomb");

                    if Bomb and Bomb.Visible then
                        startPickupFlash("C4", Bomb, GetPreferenceColor());
                    end;
                else
                    local v100 = u13:FindFirstChild(_strict_type);

                    if v100 and v100:FindFirstChild("Weapon") then
                        local v101;

                        if _strict_type == "Melee" then
                            if v100 then
                                if v100.Name == "Melee" then
                                    local v102;
                                    v101, v102 = getMeleeImageLabels(v100);
                                    local v103;

                                    if v2 == nil then
                                        v103 = false;
                                    else
                                        v103 = v2.Name == "Zeus x27";
                                    end;

                                    if v103 then
                                        v101 = v102 or v101;
                                    end;
                                else
                                    v101 = v100.Weapon:FindFirstChildOfClass("ImageLabel");
                                end;
                            else
                                v101 = nil;
                            end;
                        elseif v100 then
                            if v100.Name == "Melee" then
                                v101, v101 = getMeleeImageLabels(v100);

                                if not (v101 and v101.Visible) then
                                    if not (v101 and v101.Visible) then
                                        v101 = v100.Weapon:FindFirstChildOfClass("ImageLabel");
                                    end;
                                end;
                            else
                                v101 = v100.Weapon:FindFirstChildOfClass("ImageLabel");
                            end;
                        else
                            v101 = nil;
                        end;

                        if v101 and v101.Visible then
                            startPickupFlash(_strict_type .. "_" .. v2.Name, v101, getWeaponColor(v2));
                        end;
                    end;
                end;
            end;
        end;
    end;

    u12 = v97;
end;

local function updateCurrentEquipped(p104: number, p105: any) -- Line: 599
    -- upvalues: u2 (ref), u3 (ref), TweenService (copy), u4 (ref), getMeleeImageLabels (copy), getMeleeWeaponNameLabels (copy), u13 (ref), GetPreferenceColor (copy), getWeaponColor (copy), GetSkinDisplayName (copy), getInventoryItemDisplayName (copy), u8 (copy)
    if u2 then
        if u2.Name == "Grenade" then
            local v106 = u2:WaitForChild("Grenades"):FindFirstChild((tostring(u3)));

            if v106 then
                local Grenade = v106:FindFirstChild("Grenade");
                TweenService:Create(Grenade, TweenInfo.new(0.1), {
                    Size = Grenade:GetAttribute("DefaultSize")
                }):Play();
            end;
        else
            local v107 = u4;

            if not v107 then
                local v108 = u2;

                if v108 then
                    if v108.Name == "Melee" then
                        v107, v107 = getMeleeImageLabels(v108);

                        if not (v107 and v107.Visible) then
                            if not (v107 and v107.Visible) then
                                v107 = v108.Weapon:FindFirstChildOfClass("ImageLabel");
                            end;
                        end;
                    else
                        v107 = v108.Weapon:FindFirstChildOfClass("ImageLabel");
                    end;
                else
                    v107 = nil;
                end;
            end;

            local v109 = u2;

            if v109 then
                if v109.Name == "Melee" then
                    local v110, v111 = getMeleeWeaponNameLabels(v109);

                    if v110 then
                        v110.Visible = false;
                        v110.Text = "";
                    end;

                    if v111 then
                        v111.Visible = false;
                        v111.Text = "";
                    end;
                else
                    local WeaponName = v109.Weapon:FindFirstChild("WeaponName");

                    if WeaponName then
                        WeaponName.Visible = false;
                        WeaponName.Text = "";
                    end;
                end;
            end;

            u2.Equip.Visible = false;

            if v107 then
                TweenService:Create(v107, TweenInfo.new(0.1), {
                    Size = v107:GetAttribute("DefaultSize")
                }):Play();
            end;
        end;
    end;

    local v112 = u13:FindFirstChild((tostring(p105.Properties.Slot)));
    u2 = v112;
    u4 = nil;

    if v112 then
        if v112.Name == "Grenade" then
            local v113 = v112.Grenades:FindFirstChild((tostring(p104)));
            u3 = p104;

            if v113 then
                local Grenade = v113:FindFirstChild("Grenade");
                Grenade.ImageColor3 = GetPreferenceColor();
                TweenService:Create(Grenade, TweenInfo.new(0.1), {
                    Size = Grenade:GetAttribute("DefaultSize") + UDim2.fromScale(0.1, 0.1)
                }):Play();
            end;
        else
            local v114;

            if v112 then
                if v112.Name == "Melee" then
                    local v115;
                    v114, v115 = getMeleeImageLabels(v112);
                    local v116;

                    if p105 == nil then
                        v116 = false;
                    else
                        v116 = p105.Name == "Zeus x27";
                    end;

                    if v116 then
                        v114 = v115 or v114;
                    end;
                else
                    v114 = v112.Weapon:FindFirstChildOfClass("ImageLabel");
                end;
            else
                v114 = nil;
            end;

            local v117;

            if v112 then
                if v112.Name == "Melee" then
                    local v118;
                    v117, v118 = getMeleeWeaponNameLabels(v112);
                    local v119;

                    if p105 == nil then
                        v119 = false;
                    else
                        v119 = p105.Name == "Zeus x27";
                    end;

                    if v119 then
                        v117 = v118 or v117;
                    end;
                else
                    v117 = v112.Weapon:FindFirstChild("WeaponName");
                end;
            else
                v117 = nil;
            end;

            u4 = v114;

            if v114 then
                v114.ImageColor3 = getWeaponColor(p105);
            end;

            if v112 then
                if v112.Name == "Melee" then
                    local v120, v121 = getMeleeWeaponNameLabels(v112);

                    if v120 then
                        v120.Visible = false;
                        v120.Text = "";
                    end;

                    if v121 then
                        v121.Visible = false;
                        v121.Text = "";
                    end;
                else
                    local WeaponName = v112.Weapon:FindFirstChild("WeaponName");

                    if WeaponName then
                        WeaponName.Visible = false;
                        WeaponName.Text = "";
                    end;
                end;
            end;

            if v117 then
                v117.TextColor3 = getWeaponColor(p105);
                GetSkinDisplayName.ApplyNameLabel(v117, getInventoryItemDisplayName(p105, v112.Name), p105.NameTag);
                v117.Visible = true;
            end;

            v112.Equip.Visible = true;

            if v114 then
                TweenService:Create(v114, TweenInfo.new(0.1), {
                    Size = v114:GetAttribute("DefaultSize") + UDim2.fromScale(0.1, 0.1)
                }):Play();
            end;
        end;
    end;

    if not u8 then
        return;
    end;

    if v112 then
        v112 = v112:FindFirstChild("CycleWeaponsIcons");
    end;

    if v112 then
        v112.Visible = u8;
    end;
end;

local function convertInventoryDataToServerLoadout(p122: table) -- Line: 676
    -- upvalues: u9 (copy)
    if not p122 or #p122 == 0 then
        return nil;
    end;

    local v123 = {};

    for i = 1, 5 do
        local v124 = p122[i];
        local v125;

        if v124 then
            v125 = v124._settings;
        else
            v125 = nil;
        end;

        local v126 = {
            _items = {}
        };
        local v127 = {};
        local v128;

        if v125 then
            v128 = v125._strict_slot_space;
        else
            v128 = u9[i].space;
        end;

        v127._strict_slot_space = v128;
        local v129;

        if v125 then
            v129 = v125._strict_type;
        else
            v129 = u9[i].type;
        end;

        v127._strict_type = v129;
        v126._settings = v127;
        v123[i] = v126;
        local v130;

        if v124 then
            v130 = i;

            for _, v in ipairs(v124._items) do
                table.insert(v123[v130]._items, v);
            end;
        else
            v130 = i;
        end;
    end;

    return v123;
end;

local function updateInventoryFrame(p131: any, p132: userdata?) -- Line: 702
    -- upvalues: GetPreferenceColor (copy), u13 (ref), LocalPlayer (copy), InventoryController (copy), updateMeleeInventoryFrame (copy), getWeaponColor (copy), GetSkinDisplayName (copy), getInventoryItemDisplayName (copy), GetInventoryItemIcon (copy)
    local v133 = GetPreferenceColor();
    u13.Grenade.DefuseKit.ImageColor3 = v133;
    u13.Grenade.Bomb.ImageColor3 = v133;
    local v134 = p132 or LocalPlayer;
    local DefuseKit = u13.Grenade.DefuseKit;
    local v135;

    if v134 and v134:GetAttribute("Team") == "Counter-Terrorists" then
        local Attribute = workspace:GetAttribute("Gamemode");
        local v136 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

        if v136 == nil then
            v135 = false;
        else
            v135 = v134:GetAttribute(v136) == true;
        end;
    else
        v135 = false;
    end;

    DefuseKit.Visible = v135;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        u13.Grenade.Bomb.Visible = false;
    end;

    local CurrentEquipped = InventoryController.getCurrentEquipped();

    for _, v in ipairs(p131) do
        if v._settings._strict_type == "Melee" then
            updateMeleeInventoryFrame(u13.Melee, v, CurrentEquipped);
        elseif v._settings._strict_slot_space == 1 then
            local v137 = u13:FindFirstChild(v._settings._strict_type);

            if v137 then
                local v138 = v._items[1];

                if v138 then
                    local Weapon = v137:FindFirstChild("Weapon");
                    v137:SetAttribute("Slot", v138.Slot);
                    v137.Keybind.Text = v138.Slot;

                    if Weapon then
                        local v139 = v137.Weapon:FindFirstChild(v138.Properties.Class);
                        v137.Weapon.WeaponName.TextColor3 = getWeaponColor(v138);
                        GetSkinDisplayName.ApplyNameLabel(v137.Weapon.WeaponName, getInventoryItemDisplayName(v138, v._settings._strict_type), v138.NameTag);
                        local v140;

                        if CurrentEquipped then
                            v140 = CurrentEquipped.Properties.Slot == v._settings._strict_type;
                        else
                            v140 = CurrentEquipped;
                        end;

                        v137.Weapon.WeaponName.Visible = v140;

                        if v139 then
                            for _, child in v137.Weapon:GetChildren() do
                                if child:IsA("ImageLabel") then
                                    child.Visible = child == v139;
                                end;
                            end;

                            v139.Image = v138.Properties.Icon;
                            v139.ImageColor3 = getWeaponColor(v138);
                        end;
                    end;
                else
                    v137.Equip.Visible = false;
                    v137.Weapon.WeaponName.Text = "";
                    v137.Weapon.WeaponName.Visible = false;

                    for _, child in v137.Weapon:GetChildren() do
                        if child:IsA("ImageLabel") then
                            child.Visible = false;
                        end;
                    end;
                end;
            elseif v._settings._strict_type == "C4" then
                u13.Grenade.Bomb.Visible = v._items[1];
            end;
        elseif v._settings._strict_type == "Grenade" then
            local v141 = v;

            for i = 1, 4 do
                local v142 = u13.Grenade.Grenades:FindFirstChild((tostring(i)));
                local v143;

                if v142 then
                    local v144 = v141._items[i];

                    if v144 then
                        v142.Grenade.ImageColor3 = v133;
                        v142.Grenade.Visible = true;
                        v142.Dot.Visible = false;
                        local v145 = GetInventoryItemIcon(v144, (p132 or LocalPlayer):GetAttribute("Team"));

                        if v145 then
                            v142.Grenade.Image = v145;
                            v143 = i;
                        else
                            v143 = i;
                        end;
                    else
                        v142.Grenade.Visible = false;
                        v142.Dot.Visible = true;
                        v143 = i;
                    end;
                else
                    v143 = i;
                end;
            end;
        end;
    end;

    for _, child in u13:GetChildren() do
        if child:IsA("Frame") then
            local v146 = child.Name == "Grenade";
            local v147 = child;

            for _, v in p131 do
                if #v._items > 0 and v._settings._strict_type == v147.Name then
                    v146 = true;
                    break;
                end;
            end;

            v147.Visible = v146;
        end;
    end;
end;

local function updateBotInventoryFrame(p148: userdata) -- Line: 809
    -- upvalues: u9 (copy), HttpService (copy), GetWeaponProperties (copy), updateInventoryFrame (copy), updateCurrentEquipped (copy)
    local v149 = {};

    for i, v in u9 do
        v149[i] = {
            _items = {},
            _settings = {
                _strict_slot_space = v.space,
                _strict_type = v.type
            }
        };
    end;

    local Attribute = p148:GetAttribute("BotGrenades");
    local success, result = pcall(HttpService.JSONDecode, HttpService, type(Attribute) ~= "string" and "[]" or Attribute);

    for i, v in (not success or type(result) ~= "table") and {} or result do
        local v150;

        if type(v) == "string" then
            v150 = GetWeaponProperties(v);
        else
            v150 = nil;
        end;

        if v150 and #v149[4]._items < u9[4].space then
            local _items = v149[4]._items;
            local v151 = {
                Skin = "Stock",
                Float = 0,
                Slot = 4,
                Name = v,
                Identifier = `{v}:{i}`,
                Properties = v150
            };
            table.insert(_items, v151);
        end;
    end;

    local Attribute2 = p148:GetAttribute("CurrentEquipped");
    local success2, result2 = pcall(HttpService.JSONDecode, HttpService, type(Attribute2) ~= "string" and "" or Attribute2);

    if success2 then
        if type(result2) == "table" then
            success2 = type(result2.Name) == "string";
        else
            success2 = false;
        end;
    end;

    local v152;

    if success2 then
        v152 = GetWeaponProperties(result2.Name);
    else
        v152 = nil;
    end;

    local v153 = nil;
    local v154 = 1;

    if v152 then
        for i, v in u9 do
            if v.type == v152.Slot and v.type == "Grenade" then
                for i2, v2 in v149[i]._items do
                    if v2.Name == result2.Name then
                        v154 = i2;
                        v153 = v2;
                        break;
                    end;
                end;

                break;
            end;

            if v.type == v152.Slot then
                v153 = {
                    Name = result2.Name,
                    Skin = result2.Skin,
                    Float = result2.Float,
                    Identifier = result2.Identifier or result2.Name,
                    Properties = v152,
                    Slot = i
                };
                table.insert(v149[i]._items, v153);
            end;
        end;
    end;

    updateInventoryFrame(v149, p148);

    if v153 then
        updateCurrentEquipped(v154, v153);
    end;
end;

local function disconnectBotInventory() -- Line: 873
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function refreshSpectatedInventory(u155: userdata) -- Line: 880
    -- upvalues: u5 (ref), Participants (copy), Remotes (copy), SpectateController (copy), updateBotInventoryFrame (copy), u13 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    if not Participants.IsBot(u155) then
        Remotes.Inventory.RequestSpectatedPlayerInventory.Send(u155);

        return;
    end;

    u5 = u155.AttributeChanged:Connect(function(p156: string) -- Line: 886
        -- upvalues: SpectateController (ref), u155 (copy), updateBotInventoryFrame (ref), u13 (ref)
        if SpectateController.GetPlayer() ~= u155 then
            return;
        end;

        if p156 == "CurrentEquipped" or p156 == "BotGrenades" then
            updateBotInventoryFrame(u155);

            return;
        end;

        if p156 == "HasDefuseKit" or (p156 == "HasRescueKit" or p156 == "Team") then
            local v157 = u155;
            local DefuseKit = u13.Grenade.DefuseKit;
            local v158;

            if v157 and v157:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode");
                local v159 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                if v159 == nil then
                    v158 = false;
                else
                    v158 = v157:GetAttribute(v159) == true;
                end;
            else
                v158 = false;
            end;

            DefuseKit.Visible = v158;
        end;
    end);
    updateBotInventoryFrame(u155);
end;

local function restoreLocalEquipped(p160) -- Line: 900
    -- upvalues: InventoryController (copy), updateCurrentEquipped (copy)
    local CurrentEquipped = InventoryController.getCurrentEquipped();

    if not (p160 and (CurrentEquipped and CurrentEquipped.Identifier)) then
        return;
    end;

    for i = 1, 5 do
        local v161 = p160[i];
        local v162;

        if v161 and v161._items then
            v162 = i;

            for i2, v in ipairs(v161._items) do
                if v.Identifier == CurrentEquipped.Identifier then
                    updateCurrentEquipped(i2, v);

                    return;
                end;
            end;
        else
            v162 = i;
        end;
    end;
end;

function v1.Initialize(p163, p164) -- Line: 921
    -- upvalues: u13 (ref), GetUserPlatform (copy), EquipInventorySlot (copy), InventoryController (copy)
    u13 = p164;
    u13.Visible = table.find(GetUserPlatform(), "Mobile") == nil;
    u13.Active = false;

    for _, v in u13:QueryDescendants("GuiObject") do
        v.Active = false;
    end;

    for _, v in u13:QueryDescendants("ImageLabel, ImageButton") do
        if v.Parent.Name == "Weapon" or (v.Name == "Grenade" or v.Name == "Bomb") then
            v:SetAttribute("DefaultSize", v.Size);
        end;
    end;

    for _, child in u13:GetChildren() do
        if child:IsA("Frame") and child:FindFirstChild("Button") then
            child.Button.MouseButton1Click:Connect(function() -- Line: 941
                -- upvalues: child (copy), EquipInventorySlot (ref)
                local Attribute = child:GetAttribute("Slot");

                if Attribute then
                    EquipInventorySlot(Attribute);
                end;
            end);
        end;
    end;

    for _, child in u13.Grenade.Grenades:GetChildren() do
        if child:IsA("Frame") then
            child:FindFirstChild("Button").MouseButton1Click:Connect(function() -- Line: 952
                -- upvalues: InventoryController (ref), child (copy)
                InventoryController.equip(4, (tonumber(child.Name)));
            end);
        end;
    end;

    local Bomb = u13.Grenade.Bomb;

    if Bomb:IsA("ImageButton") then
        Bomb.MouseButton1Click:Connect(function() -- Line: 960
            -- upvalues: Bomb (copy), InventoryController (ref)
            if Bomb.Visible then
                InventoryController.equip(5, 1);
            end;
        end);
    end;
end;

local function getSpectatedPlayer() -- Line: 969
    -- upvalues: LocalPlayer (copy), SpectateController (copy)
    if LocalPlayer:GetAttribute("IsSpectating") == true then
        return SpectateController.GetPlayer();
    end;

    return nil;
end;

function v1.Start() -- Line: 976
    -- upvalues: InventoryController (copy), LocalPlayer (copy), updateInventoryFrame (copy), detectAndFlashNewItems (copy), updateCurrentEquipped (copy), DataController (copy), startFade (copy), u13 (ref), getWeaponColor (copy), getMeleeImageLabels (copy), getMeleeWeaponNameLabels (copy), SpectateController (copy), refreshSpectatedInventory (copy), Remotes (copy), convertInventoryDataToServerLoadout (copy), u5 (ref), restoreLocalEquipped (copy), Players (copy)
    InventoryController.OnInventoryChanged:Connect(function(p165) -- Line: 978
        -- upvalues: LocalPlayer (ref), updateInventoryFrame (ref), detectAndFlashNewItems (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            updateInventoryFrame(p165);
            detectAndFlashNewItems(p165);
        end;
    end);
    InventoryController.OnInventoryItemEquipped:Connect(function(p166: number, p167: any) -- Line: 987
        -- upvalues: updateCurrentEquipped (ref), DataController (ref), LocalPlayer (ref), startFade (ref)
        updateCurrentEquipped(p166, p167);

        if DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") == false then
            local Slot = p167.Properties.Slot;

            if Slot == "Primary" or (Slot == "Secondary" or (Slot == "Melee" or Slot == "Grenade")) then
                startFade();
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Glow Weapon with Rarity Color", function() -- Line: 1002
        -- upvalues: InventoryController (ref), updateInventoryFrame (ref), u13 (ref), getWeaponColor (ref), getMeleeImageLabels (ref), getMeleeWeaponNameLabels (ref)
        local CurrentInventory = InventoryController.getCurrentInventory();

        if CurrentInventory then
            updateInventoryFrame(CurrentInventory);
        end;

        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if CurrentEquipped then
            local v168 = u13:FindFirstChild((tostring(CurrentEquipped.Properties.Slot)));

            if v168 and v168.Name ~= "Grenade" then
                local v169 = getWeaponColor(CurrentEquipped);
                local v170;

                if v168 then
                    if v168.Name == "Melee" then
                        local v171;
                        v170, v171 = getMeleeImageLabels(v168);
                        local v172;

                        if CurrentEquipped == nil then
                            v172 = false;
                        else
                            v172 = CurrentEquipped.Name == "Zeus x27";
                        end;

                        if v172 then
                            v170 = v171 or v170;
                        end;
                    else
                        v170 = v168.Weapon:FindFirstChildOfClass("ImageLabel");
                    end;
                else
                    v170 = nil;
                end;

                if v170 then
                    v170.ImageColor3 = v169;
                end;

                local v173;

                if v168 then
                    if v168.Name == "Melee" then
                        local v174;
                        v173, v174 = getMeleeWeaponNameLabels(v168);
                        local v175;

                        if CurrentEquipped == nil then
                            v175 = false;
                        else
                            v175 = CurrentEquipped.Name == "Zeus x27";
                        end;

                        if v175 then
                            v173 = v174 or v173;
                        end;
                    else
                        v173 = v168.Weapon:FindFirstChild("WeaponName");
                    end;
                else
                    v173 = nil;
                end;

                if v173 then
                    v173.TextColor3 = v169;
                end;
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 1026, Name: rebuildInventoryVisuals
        -- upvalues: LocalPlayer (ref), SpectateController (ref), refreshSpectatedInventory (ref), InventoryController (ref), updateInventoryFrame (ref)
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            local Player = SpectateController.GetPlayer();

            if Player then
                refreshSpectatedInventory(Player);
            end;
        else
            local CurrentInventory = InventoryController.getCurrentInventory();

            if CurrentInventory then
                updateInventoryFrame(CurrentInventory);
            end;
        end;
    end);

    local function updateLocalObjectiveKitIcon() -- Line: 1044
        -- upvalues: LocalPlayer (ref), u13 (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            local v176 = LocalPlayer;
            local DefuseKit = u13.Grenade.DefuseKit;
            local v177;

            if v176 and v176:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode");
                local v178 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                if v178 == nil then
                    v177 = false;
                else
                    v177 = v176:GetAttribute(v178) == true;
                end;
            else
                v177 = false;
            end;

            DefuseKit.Visible = v177;
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("HasDefuseKit"):Connect(updateLocalObjectiveKitIcon);
    LocalPlayer:GetAttributeChangedSignal("HasRescueKit"):Connect(updateLocalObjectiveKitIcon);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 1055
        -- upvalues: LocalPlayer (ref), u13 (ref), SpectateController (ref), refreshSpectatedInventory (ref), InventoryController (ref), updateInventoryFrame (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            local v179 = LocalPlayer;
            local DefuseKit = u13.Grenade.DefuseKit;
            local v180;

            if v179 and v179:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode");
                local v181 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                if v181 == nil then
                    v180 = false;
                else
                    v180 = v179:GetAttribute(v181) == true;
                end;
            else
                v180 = false;
            end;

            DefuseKit.Visible = v180;
        end;

        if LocalPlayer:GetAttribute("IsSpectating") == true then
            local Player = SpectateController.GetPlayer();

            if Player then
                refreshSpectatedInventory(Player);
            end;
        else
            local CurrentInventory = InventoryController.getCurrentInventory();

            if CurrentInventory then
                updateInventoryFrame(CurrentInventory);
            end;
        end;
    end);
    Remotes.Inventory.SpectatedPlayerInventory.Listen(function(p182: table) -- Line: 1062
        -- upvalues: LocalPlayer (ref), SpectateController (ref), convertInventoryDataToServerLoadout (ref), updateInventoryFrame (ref), updateCurrentEquipped (ref)
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            return;
        end;

        local Player = SpectateController.GetPlayer();

        if not Player or p182.Player ~= Player then
            return;
        end;

        local v183 = convertInventoryDataToServerLoadout(p182.Inventory);

        if not v183 then
            return;
        end;

        updateInventoryFrame(v183, Player);
        local v184 = p182.EquippedSlot or 0;
        local v185 = p182.EquippedSlotSpace or 0;

        if v184 > 0 and v185 > 0 then
            local v186 = v183[v184];

            if v186 and (v186._items and v186._items[v185]) then
                updateCurrentEquipped(v185, v186._items[v185]);
            end;
        end;
    end);
    SpectateController.ListenToSpectate:Connect(function(p187: userdata?) -- Line: 1090
        -- upvalues: refreshSpectatedInventory (ref), u13 (ref), u5 (ref), InventoryController (ref), updateInventoryFrame (ref), restoreLocalEquipped (ref), LocalPlayer (ref)
        if p187 then
            refreshSpectatedInventory(p187);
            local DefuseKit = u13.Grenade.DefuseKit;
            local v188;

            if p187 and p187:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode");
                local v189 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                if v189 == nil then
                    v188 = false;
                else
                    v188 = p187:GetAttribute(v189) == true;
                end;
            else
                v188 = false;
            end;

            DefuseKit.Visible = v188;

            return;
        end;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        local CurrentInventory = InventoryController.getCurrentInventory();

        if CurrentInventory then
            updateInventoryFrame(CurrentInventory);
        end;

        restoreLocalEquipped(CurrentInventory);
        local v190 = LocalPlayer;
        local DefuseKit = u13.Grenade.DefuseKit;
        local v191;

        if v190 and v190:GetAttribute("Team") == "Counter-Terrorists" then
            local Attribute = workspace:GetAttribute("Gamemode");
            local v192 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

            if v192 == nil then
                v191 = false;
            else
                v191 = v190:GetAttribute(v192) == true;
            end;
        else
            v191 = false;
        end;

        DefuseKit.Visible = v191;
    end);

    local function updateSpectatedObjectiveKit() -- Line: 1109
        -- upvalues: LocalPlayer (ref), SpectateController (ref), u13 (ref)
        local v193;

        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v193 = SpectateController.GetPlayer();
        else
            v193 = nil;
        end;

        if v193 then
            local DefuseKit = u13.Grenade.DefuseKit;
            local v194;

            if v193 and v193:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode");
                local v195 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                if v195 == nil then
                    v194 = false;
                else
                    v194 = v193:GetAttribute(v195) == true;
                end;
            else
                v194 = false;
            end;

            DefuseKit.Visible = v194;
        end;
    end;

    local function connectObjectiveKitSignals(p196: userdata) -- Line: 1116
        -- upvalues: LocalPlayer (ref), updateSpectatedObjectiveKit (copy)
        if p196 == LocalPlayer then
            return;
        end;

        p196:GetAttributeChangedSignal("HasDefuseKit"):Connect(updateSpectatedObjectiveKit);
        p196:GetAttributeChangedSignal("HasRescueKit"):Connect(updateSpectatedObjectiveKit);
        p196:GetAttributeChangedSignal("Team"):Connect(updateSpectatedObjectiveKit);
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        connectObjectiveKitSignals(v);
    end;

    Players.PlayerAdded:Connect(connectObjectiveKitSignals);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 1131
        -- upvalues: LocalPlayer (ref), SpectateController (ref), u13 (ref)
        if LocalPlayer:GetAttribute("IsSpectating") then
            local v197;

            if LocalPlayer:GetAttribute("IsSpectating") == true then
                v197 = SpectateController.GetPlayer();
            else
                v197 = nil;
            end;

            if v197 then
                local DefuseKit = u13.Grenade.DefuseKit;
                local v198;

                if v197 and v197:GetAttribute("Team") == "Counter-Terrorists" then
                    local Attribute = workspace:GetAttribute("Gamemode");
                    local v199 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                    if v199 == nil then
                        v198 = false;
                    else
                        v198 = v197:GetAttribute(v199) == true;
                    end;
                else
                    v198 = false;
                end;

                DefuseKit.Visible = v198;
            end;
        else
            local v200 = LocalPlayer;
            local DefuseKit = u13.Grenade.DefuseKit;
            local v201;

            if v200 and v200:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode");
                local v202 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                if v202 == nil then
                    v201 = false;
                else
                    v201 = v200:GetAttribute(v202) == true;
                end;
            else
                v201 = false;
            end;

            DefuseKit.Visible = v201;
        end;
    end);

    if LocalPlayer:GetAttribute("IsSpectating") then
        local v203;

        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v203 = SpectateController.GetPlayer();
        else
            v203 = nil;
        end;

        if v203 then
            local DefuseKit = u13.Grenade.DefuseKit;
            local v204;

            if v203 and v203:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode");
                local v205 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

                if v205 == nil then
                    v204 = false;
                else
                    v204 = v203:GetAttribute(v205) == true;
                end;
            else
                v204 = false;
            end;

            DefuseKit.Visible = v204;
        end;
    else
        local v206 = LocalPlayer;
        local DefuseKit = u13.Grenade.DefuseKit;
        local v207;

        if v206 and v206:GetAttribute("Team") == "Counter-Terrorists" then
            local Attribute = workspace:GetAttribute("Gamemode");
            local v208 = Attribute == "Bomb Defusal" and "HasDefuseKit" or (Attribute == "Hostage Rescue" and "HasRescueKit" or nil);

            if v208 == nil then
                v207 = false;
            else
                v207 = v206:GetAttribute(v208) == true;
            end;
        else
            v207 = false;
        end;

        DefuseKit.Visible = v207;
    end;

    local function requestSpectatedInventoryUpdate() -- Line: 1146
        -- upvalues: LocalPlayer (ref), SpectateController (ref), refreshSpectatedInventory (ref)
        local v209;

        if LocalPlayer:GetAttribute("IsSpectating") == true then
            v209 = SpectateController.GetPlayer();
        else
            v209 = nil;
        end;

        if v209 then
            refreshSpectatedInventory(v209);
        end;
    end;

    Remotes.Inventory.NewInventoryItem.Listen(requestSpectatedInventoryUpdate);
    Remotes.Inventory.RemoveInventoryItem.Listen(requestSpectatedInventoryUpdate);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Item.Always Show Inventory", startFade);
    task.wait(0.1);

    if DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") == false then
        startFade();
    end;
end;

return v1;