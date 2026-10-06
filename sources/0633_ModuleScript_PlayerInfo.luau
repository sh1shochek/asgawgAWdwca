-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
require(ReplicatedStorage.Database.Custom.Types);
local TweenInfo_new_ret = TweenInfo.new(0.66, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local u2 = { "Slot1", "Slot2", "Slot3" };
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = false;
local LocalPlayer = Players.LocalPlayer;

local function commaNumber(p9: number) -- Line: 54
    return tostring(p9):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function getItemProperties(p10: string, p11: string) -- Line: 58
    -- upvalues: ReplicatedStorage (copy)
    local v12 = ReplicatedStorage.Database.Custom:FindFirstChild(p10) or ReplicatedStorage.Database.Custom.GameStats:FindFirstChild(p10);

    if not (v12 and v12:IsA("Folder")) then
        return nil;
    end;

    local v13 = v12:FindFirstChild(p11);

    if not (v13 and v13:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v13);

    return success and result and result or nil;
end;

local function playerHasBomb(p14: userdata) -- Line: 74
    -- upvalues: HttpService (copy)
    local Attribute = p14:GetAttribute("Slot5");

    if not Attribute then
        return false;
    end;

    local v15 = HttpService:JSONDecode(Attribute);

    if v15 then
        v15 = v15.Weapon == "C4";
    end;

    return v15;
end;

local function decodeTableAttribute(u16) -- Line: 85
    -- upvalues: HttpService (copy)
    if typeof(u16) ~= "string" or u16 == "" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 90
        -- upvalues: HttpService (ref), u16 (copy)
        return HttpService:JSONDecode(u16);
    end);

    if success and typeof(result) == "table" then
        return result;
    end;

    return nil;
end;

local function parseArmorAttribute(u17) -- Line: 96
    -- upvalues: HttpService (copy)
    local v18;

    if typeof(u17) == "string" and u17 ~= "" then
        local v19;
        v19, v18 = pcall(function() -- Line: 90
            -- upvalues: HttpService (ref), u17 (copy)
            return HttpService:JSONDecode(u17);
        end);

        if not v19 or typeof(v18) ~= "table" then
            v18 = nil;
        end;
    else
        v18 = nil;
    end;

    return v18 and {
        Type = tostring(v18.Type) or "",
        Health = tonumber(v18.Health) or 0
    } or nil;
end;

local function getWeaponNameFromSlotAttribute(u20) -- Line: 108
    -- upvalues: HttpService (copy)
    local v21;

    if typeof(u20) == "string" and u20 ~= "" then
        local v22;
        v22, v21 = pcall(function() -- Line: 90
            -- upvalues: HttpService (ref), u20 (copy)
            return HttpService:JSONDecode(u20);
        end);

        if not v22 or typeof(v21) ~= "table" then
            v21 = nil;
        end;
    else
        v21 = nil;
    end;

    if v21 then
        v21 = v21.Weapon;
    end;

    if typeof(v21) == "string" and v21 ~= "" then
        return v21;
    end;

    return nil;
end;

local function setChildVisible(p23: userdata?, p24: string, p25: boolean) -- Line: 114
    if p23 then
        p23 = p23:FindFirstChild(p24);
    end;

    if p23 then
        p23.Visible = p25;
    end;
end;

local function getTemplateHealthParts(p26: userdata) -- Line: 121
    local Health = p26:FindFirstChild("Health");
    local v27;

    if Health then
        v27 = Health:FindFirstChild("Bar");
    else
        v27 = Health;
    end;

    return Health, v27;
end;

local function setTemplateLifeState(p28: userdata, p29: boolean) -- Line: 127
    local Health = p28:FindFirstChild("Health");
    local v30;

    if Health then
        v30 = Health:FindFirstChild("Bar");
    else
        v30 = Health;
    end;

    local PlayerBackground = p28:FindFirstChild("PlayerBackground");
    local v31;

    if PlayerBackground then
        v31 = PlayerBackground:FindFirstChild("Player");
    else
        v31 = PlayerBackground;
    end;

    local v32;

    if v31 then
        v32 = v31:FindFirstChild("X");
    else
        v32 = v31;
    end;

    local Info = p28:FindFirstChild("Info");

    if p29 then
        if v30 then
            v30.Size = UDim2.fromScale(0, 1);
        end;

        if Health then
            Health.Visible = false;
        end;

        if v31 then
            v31.ImageTransparency = 0.5;
        end;

        if v32 then
            v32.Visible = true;
        end;

        if Info then
            Info.BackgroundTransparency = 0.75;
            local v33;

            if Info then
                v33 = Info:FindFirstChild("Weapon");
            else
                v33 = Info;
            end;

            if v33 then
                v33.Visible = false;
            end;

            local v34;

            if Info then
                v34 = Info:FindFirstChild("Grenades");
            else
                v34 = Info;
            end;

            if v34 then
                v34.Visible = false;
            end;

            if Info then
                Info = Info:FindFirstChild("Items");
            end;

            if Info then
                Info.Visible = false;
            end;
        end;

        if PlayerBackground then
            PlayerBackground.Transparency = 0.5;

            return Health, v30;
        end;
    else
        if v31 then
            v31.ImageTransparency = 0;
        end;

        if v32 then
            v32.Visible = false;
        end;

        if Info then
            Info.BackgroundTransparency = 0;
        end;

        if PlayerBackground then
            PlayerBackground.Transparency = 0;
        end;
    end;

    return Health, v30;
end;

local function updateTemplateGrenades(p35: userdata, p36: number) -- Line: 179
    -- upvalues: u5 (copy), getItemProperties (copy)
    local Info = p35:FindFirstChild("Info");

    if not Info then
        return;
    end;

    local Grenades = Info:FindFirstChild("Grenades");

    if not Grenades then
        return;
    end;

    local v37 = u5[p36] or {};

    for i = 1, 4 do
        local v38 = Grenades:FindFirstChild((tostring(i)));
        local v39;

        if v38 then
            local v40 = v37[i];

            if v40 then
                local v41 = getItemProperties("Weapons", v40);
                v38.Image = v41 and v41.Icon or "";
                v38.Visible = true;
                v39 = i;
            else
                v38.Image = "";
                v38.Visible = false;
                v39 = i;
            end;
        else
            v39 = i;
        end;
    end;

    Grenades.Visible = true;
end;

local function isTeammate(p42: userdata) -- Line: 209
    -- upvalues: LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    if Attribute then
        return Attribute == p42:GetAttribute("Team");
    end;

    return false;
end;

local function summarizeDamageArray(p43: table?) -- Line: 217
    if not p43 or #p43 == 0 then
        return nil, nil;
    end;

    local v44 = 0;

    for _, v in p43 do
        v44 = v44 + v;
    end;

    return v44, #p43;
end;

local function setDamageLabel(p45: userdata?, p46: number?, p47: number?) -- Line: 233
    if not p45 then
        return;
    end;

    p45.Text = not p46 and "" or `{math.min(p46, 100)} in {p47}`;
    p45.Visible = p46 ~= nil;
end;

local function updateDamageFromMatrix(p48: userdata?, p49: table?, p50: table?) -- Line: 241
    if not (p48 and p48.Parent) then
        return;
    end;

    local Info = p48:FindFirstChild("Info");

    if not Info then
        return;
    end;

    local Damages = Info:FindFirstChild("Damages");

    if not Damages then
        return;
    end;

    local v51, v52;

    if p49 and #p49 ~= 0 then
        v51 = #p49;
        v52 = 0;

        for _, v in p49 do
            v52 = v52 + v;
        end;
    else
        v52 = nil;
        v51 = nil;
    end;

    local v53, v54;

    if p50 and #p50 ~= 0 then
        v53 = #p50;
        v54 = 0;

        for _, v in p50 do
            v54 = v54 + v;
        end;
    else
        v54 = nil;
        v53 = nil;
    end;

    Damages.Visible = v52 ~= nil and true or v54 ~= nil;
    local Outgoing = Damages:FindFirstChild("Outgoing");

    if Outgoing then
        Outgoing.Text = not v52 and "" or `{math.min(v52, 100)} in {v51}`;
        Outgoing.Visible = v52 ~= nil;
    end;

    local Incoming = Damages:FindFirstChild("Incoming");

    if not Incoming then
        return;
    end;

    Incoming.Text = not v54 and "" or `{math.min(v54, 100)} in {v53}`;
    Incoming.Visible = v54 ~= nil;
end;

local function setTemplateKills(p55: userdata, p56: number) -- Line: 265
    local Kills = p55:FindFirstChild("Kills");

    if not Kills then
        return;
    end;

    for i = 1, 5 do
        local v57 = Kills:FindFirstChild((tostring(i)));
        local v58;

        if v57 then
            v57.Visible = i <= p56;
            v58 = i;
        else
            v58 = i;
        end;
    end;
end;

local function hideTeammateOnlyInfo(p59: userdata) -- Line: 279
    local v60;

    if p59 then
        v60 = p59:FindFirstChild("DefuseKit");
    else
        v60 = p59;
    end;

    if v60 then
        v60.Visible = false;
    end;

    local v61;

    if p59 then
        v61 = p59:FindFirstChild("Bomb");
    else
        v61 = p59;
    end;

    if v61 then
        v61.Visible = false;
    end;

    local Info = p59:FindFirstChild("Info");

    for _, v in ipairs({ "Weapon", "Cash", "Items", "Grenades" }) do
        local v62;

        if Info then
            v62 = Info:FindFirstChild(v);
        else
            v62 = Info;
        end;

        if v62 then
            v62.Visible = false;
        end;
    end;
end;

local function getCompetitiveStroke(p63: userdata) -- Line: 289
    local PlayerBackground = p63:FindFirstChild("PlayerBackground");

    if PlayerBackground then
        PlayerBackground = PlayerBackground:FindFirstChildOfClass("UIStroke");
    end;

    return PlayerBackground;
end;

local function ensureDefaultStrokeColor(p64: userdata) -- Line: 294
    local Attribute = p64:GetAttribute("DefaultStrokeColor");

    if not Attribute then
        Attribute = p64.Color;
        p64:SetAttribute("DefaultStrokeColor", Attribute);
    end;

    return Attribute or p64.Color;
end;

local function refreshCompetitiveStrokeColorForPlayer(p65: userdata) -- Line: 304
    -- upvalues: u3 (copy), Participants (copy), LocalPlayer (copy)
    local v66 = u3[Participants.Key(p65)];

    if not (v66 and v66.Parent) then
        return;
    end;

    local PlayerBackground = v66:FindFirstChild("PlayerBackground");

    if PlayerBackground then
        PlayerBackground = PlayerBackground:FindFirstChildOfClass("UIStroke");
    end;

    if not PlayerBackground then
        return;
    end;

    local Attribute = PlayerBackground:GetAttribute("DefaultStrokeColor");

    if not Attribute then
        Attribute = PlayerBackground.Color;
        PlayerBackground:SetAttribute("DefaultStrokeColor", Attribute);
    end;

    local v67 = Attribute or PlayerBackground.Color;
    local Attribute2 = LocalPlayer:GetAttribute("Team");
    local v68;

    if Attribute2 then
        v68 = Attribute2 == p65:GetAttribute("Team");
    else
        v68 = false;
    end;

    if v68 then
        PlayerBackground.Color = p65:GetAttribute("CompetitivePlayerColor") or v67;

        return;
    end;

    PlayerBackground.Color = v67;
end;

local function shouldShowInfoForPlayer(p69: userdata) -- Line: 326
    -- upvalues: u8 (ref), LocalPlayer (copy), u6 (copy), Participants (copy), u7 (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return true;
    end;

    if workspace:GetAttribute("GameState") == "Warmup" or not u8 then
        return false;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");
    local v70;

    if Attribute then
        v70 = Attribute == p69:GetAttribute("Team");
    else
        v70 = false;
    end;

    if v70 then
        return true;
    end;

    local v71 = u6[Participants.Key(p69)] or 0;
    local v72 = u7[Participants.Key(p69)] == true;

    return v71 > 0 and true or v72;
end;

local function setTemplateInfoRevealed(u73: userdata, p74: userdata, p75: boolean) -- Line: 344
    -- upvalues: LocalPlayer (copy), Participants (copy), u4 (copy), Janitor (copy), u2 (copy), HttpService (copy), getItemProperties (copy), Observers (copy), updateTemplateGrenades (copy), hideTeammateOnlyInfo (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if not (p74 and p74.Parent) then
        return;
    end;

    local Info = p74:FindFirstChild("Info");

    if not Info then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");
    local v76;

    if Attribute then
        v76 = Attribute == u73:GetAttribute("Team");
    else
        v76 = false;
    end;

    local v77 = `{p75}|{v76}|{not Participants.IsAlive(u73)}|{u73:GetAttribute("IsSpectating") == true}`;

    if Info:GetAttribute("RevealKey") == v77 then
        return;
    end;

    Info:SetAttribute("RevealKey", v77);
    local v78 = u4[Info];

    if v78 then
        v78:Cleanup();
    else
        v78 = Janitor.new();
        v78:LinkToInstance(p74);
        u4[Info] = v78;
    end;

    local Attribute2 = Info:GetAttribute("OriginalSize");

    if not Attribute2 then
        Attribute2 = Info.Size;
        Info:SetAttribute("OriginalSize", Attribute2);

        if not p75 then
            Info.Size = UDim2.fromScale(1, 0);
        end;
    end;

    if not p75 then
        local v79 = TweenService:Create(Info, TweenInfo_new_ret, {
            Size = UDim2.fromScale(1, 0)
        });
        v79:Play();
        v78:Add(v79.Completed:Once(function(p80) -- Line: 454
            -- upvalues: Info (copy)
            if p80 == Enum.PlaybackState.Completed then
                Info.Visible = false;
            end;
        end));

        return;
    end;

    local Attribute3 = LocalPlayer:GetAttribute("Team");
    local v81;

    if Attribute3 then
        v81 = Attribute3 == u73:GetAttribute("Team");
    else
        v81 = false;
    end;

    if v81 then
        local v82 = u73:GetAttribute("IsSpectating") == true;
        local v83 = Participants.IsAlive(u73) and not v82;
        local Weapon = Info:FindFirstChild("Weapon");

        if Weapon then
            local function updateEquippedWeaponImageFromSlots() -- Line: 387
                -- upvalues: u2 (ref), u73 (copy), HttpService (ref), getItemProperties (ref), Weapon (copy)
                local v84 = nil;

                for _, v in ipairs(u2) do
                    local Attribute4 = u73:GetAttribute(v);

                    if typeof(Attribute4) == "string" and Attribute4 ~= "" then
                        local v85;
                        v85, v84 = pcall(function() -- Line: 90
                            -- upvalues: HttpService (ref), Attribute4 (copy)
                            return HttpService:JSONDecode(Attribute4);
                        end);

                        if not v85 or typeof(v84) ~= "table" then
                            v84 = nil;
                        end;
                    else
                        v84 = nil;
                    end;

                    if v84 then
                        v84 = v84.Weapon;
                    end;

                    if typeof(v84) ~= "string" or v84 == "" then
                        v84 = nil;
                    end;

                    if v84 then
                        break;
                    end;
                end;

                if v84 then
                    v84 = getItemProperties("Weapons", v84);
                end;

                Weapon.Image = v84 and v84.Icon or "";
            end;

            for _, v in ipairs(u2) do
                v78:Add(u73:GetAttributeChangedSignal(v):Connect(updateEquippedWeaponImageFromSlots));
            end;

            updateEquippedWeaponImageFromSlots();
            Weapon.Visible = v83;
        end;

        local Cash = Info:FindFirstChild("Cash");

        if Cash then
            v78:Add(Observers.observeAttribute(u73, "Money", function(p86) -- Line: 410
                -- upvalues: Cash (copy)
                Cash.Text = p86 and `${tostring(p86):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}` or "";

                return nil;
            end));
            Cash.Visible = true;
        end;

        local Items = Info:FindFirstChild("Items");

        if Items then
            local Armor = Items:FindFirstChild("Armor");

            if Armor then
                local function updateArmor() -- Line: 422
                    -- upvalues: u73 (copy), HttpService (ref), Armor (copy)
                    local Attribute4 = u73:GetAttribute("Armor");
                    local v87;

                    if typeof(Attribute4) == "string" and Attribute4 ~= "" then
                        local v88;
                        v88, v87 = pcall(function() -- Line: 90
                            -- upvalues: HttpService (ref), Attribute4 (copy)
                            return HttpService:JSONDecode(Attribute4);
                        end);

                        if not v88 or typeof(v87) ~= "table" then
                            v87 = nil;
                        end;
                    else
                        v87 = nil;
                    end;

                    local v89 = v87 and {
                        Type = tostring(v87.Type) or "",
                        Health = tonumber(v87.Health) or 0
                    } or nil;
                    local v90;

                    if v89 == nil then
                        v90 = false;
                    else
                        v90 = v89.Health > 0;
                    end;

                    Armor.Visible = v90;
                end;

                v78:Add(u73:GetAttributeChangedSignal("Armor"):Connect(updateArmor));
                local Attribute4 = u73:GetAttribute("Armor");
                local v91;

                if typeof(Attribute4) == "string" and Attribute4 ~= "" then
                    local v92;
                    v92, v91 = pcall(function() -- Line: 90
                        -- upvalues: HttpService (ref), Attribute4 (copy)
                        return HttpService:JSONDecode(Attribute4);
                    end);

                    if not v92 or typeof(v91) ~= "table" then
                        v91 = nil;
                    end;
                else
                    v91 = nil;
                end;

                local v93 = v91 and {
                    Type = tostring(v91.Type) or "",
                    Health = tonumber(v91.Health) or 0
                } or nil;
                local v94;

                if v93 == nil then
                    v94 = false;
                else
                    v94 = v93.Health > 0;
                end;

                Armor.Visible = v94;
            end;

            local Bomb = Items:FindFirstChild("Bomb");

            if Bomb then
                v78:Add(u73:GetAttributeChangedSignal("Slot5"):Connect(function() -- Line: 433
                    -- upvalues: Bomb (copy), u73 (copy), HttpService (ref)
                    local Attribute4 = u73:GetAttribute("Slot5");
                    local v95;

                    if Attribute4 then
                        v95 = HttpService:JSONDecode(Attribute4);

                        if v95 then
                            v95 = v95.Weapon == "C4";
                        end;
                    else
                        v95 = false;
                    end;

                    Bomb.Visible = v95;
                end));
                local Attribute4 = u73:GetAttribute("Slot5");
                local v96;

                if Attribute4 then
                    v96 = HttpService:JSONDecode(Attribute4);

                    if v96 then
                        v96 = v96.Weapon == "C4";
                    end;
                else
                    v96 = false;
                end;

                Bomb.Visible = v96;
            end;

            Items.Visible = true;
        end;

        updateTemplateGrenades(p74, Participants.Key(u73));
    else
        hideTeammateOnlyInfo(p74);
    end;

    Info.Visible = true;
    TweenService:Create(Info, TweenInfo_new_ret, {
        Size = Attribute2
    }):Play();
end;

local function refreshTemplateInfoVisibilityForPlayer(p97: userdata) -- Line: 462
    -- upvalues: u3 (copy), Participants (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    local v98 = u3[Participants.Key(p97)];

    if not (v98 and v98.Parent) then
        return;
    end;

    setTemplateInfoRevealed(p97, v98, (shouldShowInfoForPlayer(p97)));
end;

local function refreshAllTemplateInfoVisibility() -- Line: 471
    -- upvalues: u3 (copy), Participants (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    for i, v in u3 do
        local v99 = Participants.FromKey(i);

        if v99 and (v and v.Parent) then
            local v100 = u3[Participants.Key(v99)];

            if v100 then
                if v100.Parent then
                    setTemplateInfoRevealed(v99, v100, (shouldShowInfoForPlayer(v99)));
                end;
            end;
        end;
    end;
end;

local function setupBombDefusalTemplate(p101: any, u102: userdata, u103: userdata) -- Line: 480
    -- upvalues: Participants (copy), LocalPlayer (copy), TweenService (copy), setTemplateLifeState (copy), u8 (ref), u3 (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy), refreshCompetitiveStrokeColorForPlayer (copy), HttpService (copy), Observers (copy)
    local Attribute = u103:GetAttribute("Team");
    local Attribute2 = workspace:GetAttribute("Gamemode");

    local function u104() -- Line: 483
    end;

    local function getPlayerHealthRatio() -- Line: 485
        -- upvalues: u103 (copy)
        local Attribute3 = u103:GetAttribute("Health");
        local Attribute4 = u103:GetAttribute("MaxHealth");

        if typeof(Attribute3) ~= "number" or (typeof(Attribute4) ~= "number" or Attribute4 <= 0) then
            return 0;
        end;

        local v105 = math.floor(Attribute3) / Attribute4;

        return math.clamp(v105, 0, 1);
    end;

    local function updateHealthBar(p106: boolean) -- Line: 494
        -- upvalues: u102 (copy), Participants (ref), u103 (copy), LocalPlayer (ref), TweenService (ref)
        local Health = u102:FindFirstChild("Health");
        local v107;

        if Health then
            v107 = Health:FindFirstChild("Bar");
        else
            v107 = Health;
        end;

        local v108 = Participants.IsAlive(u103) and u103:GetAttribute("IsSpectating") ~= true;

        if v108 then
            local v109 = u103;
            local Attribute3 = LocalPlayer:GetAttribute("Team");
            local v110;

            if Attribute3 then
                v110 = Attribute3 == v109:GetAttribute("Team");
            else
                v110 = false;
            end;

            if v110 and (Health and v107) then
                Health.Visible = true;
                local UDim2_fromScale = UDim2.fromScale;
                local Attribute4 = u103:GetAttribute("Health");
                local Attribute5 = u103:GetAttribute("MaxHealth");
                local v111;

                if typeof(Attribute4) == "number" and (typeof(Attribute5) == "number" and Attribute5 > 0) then
                    local v112 = math.floor(Attribute4) / Attribute5;
                    v111 = math.clamp(v112, 0, 1);
                else
                    v111 = 0;
                end;

                local v113 = UDim2_fromScale(v111, 1);

                if p106 then
                    TweenService:Create(v107, TweenInfo.new(0.25), {
                        Size = v113
                    }):Play();

                    return;
                end;

                v107.Size = v113;
            end;
        end;
    end;

    local function updateLifeState() -- Line: 510
        -- upvalues: u102 (copy), u103 (copy), Participants (ref), setTemplateLifeState (ref), u8 (ref), u3 (ref), setTemplateInfoRevealed (ref), shouldShowInfoForPlayer (ref), LocalPlayer (ref), refreshCompetitiveStrokeColorForPlayer (ref), u104 (ref)
        if not u102.Parent then
            return;
        end;

        local v114 = u103:GetAttribute("IsSpectating") == true;
        local v115 = not Participants.IsAlive(u103) or v114;
        setTemplateLifeState(u102, v115);

        if not v115 and u8 then
            local v116 = u103;
            local v117 = u3[Participants.Key(v116)];

            if v117 and v117.Parent then
                setTemplateInfoRevealed(v116, v117, (shouldShowInfoForPlayer(v116)));
            end;
        end;

        local Health = u102:FindFirstChild("Health");
        local v118;

        if Health then
            v118 = Health:FindFirstChild("Bar");
        else
            v118 = Health;
        end;

        local v119 = Participants.IsAlive(u103) and u103:GetAttribute("IsSpectating") ~= true;

        if v119 then
            local v120 = u103;
            local Attribute3 = LocalPlayer:GetAttribute("Team");
            local v121;

            if Attribute3 then
                v121 = Attribute3 == v120:GetAttribute("Team");
            else
                v121 = false;
            end;

            if v121 and (Health and v118) then
                Health.Visible = true;
                local UDim2_fromScale = UDim2.fromScale;
                local Attribute4 = u103:GetAttribute("Health");
                local Attribute5 = u103:GetAttribute("MaxHealth");
                local v122;

                if typeof(Attribute4) == "number" and (typeof(Attribute5) == "number" and Attribute5 > 0) then
                    local v123 = math.floor(Attribute4) / Attribute5;
                    v122 = math.clamp(v123, 0, 1);
                else
                    v122 = 0;
                end;

                v118.Size = UDim2_fromScale(v122, 1);
            end;
        end;

        refreshCompetitiveStrokeColorForPlayer(u103);
        u104();
    end;

    p101:Add(u103:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 526
        -- upvalues: updateLifeState (copy), updateHealthBar (copy)
        updateLifeState();
        updateHealthBar(true);
    end));
    p101:Add(u103:GetAttributeChangedSignal("MaxHealth"):Connect(updateLifeState));
    p101:Add(u103:GetAttributeChangedSignal("Dead"):Connect(updateLifeState));
    p101:Add(u103:GetAttributeChangedSignal("IsSpectating"):Connect(updateLifeState));
    p101:Add(u103:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(function() -- Line: 533
        -- upvalues: refreshCompetitiveStrokeColorForPlayer (ref), u103 (copy)
        refreshCompetitiveStrokeColorForPlayer(u103);
    end));
    updateLifeState();

    if Attribute == "Terrorists" then
        u104 = function() -- Line: 540
            -- upvalues: u103 (copy), LocalPlayer (ref), HttpService (ref), u102 (copy), Participants (ref)
            local Attribute3 = u103:GetAttribute("Team");
            local Attribute4 = LocalPlayer:GetAttribute("Team");
            local v124 = HttpService:JSONDecode(u103:GetAttribute("Slot5") or "[]");
            local Bomb = u102:FindFirstChild("Bomb");

            if Bomb then
                local v125 = Participants.IsAlive(u103);

                if v125 then
                    if Attribute3 == Attribute4 then
                        if v124 then
                            v124 = v124.Weapon == "C4";
                        end;
                    else
                        v124 = false;
                    end;
                else
                    v124 = v125;
                end;

                Bomb.Visible = v124;
            end;
        end;

        p101:Add(Observers.observeAttribute(u103, "Slot5", function(p126) -- Line: 554
            -- upvalues: u104 (ref), u102 (copy)
            u104();

            return function() -- Line: 557
                -- upvalues: u102 (ref)
                local v127 = u102;

                if v127 then
                    v127 = v127:FindFirstChild("Bomb");
                end;

                if v127 then
                    v127.Visible = false;
                end;
            end;
        end));
        u104();
    elseif Attribute == "Counter-Terrorists" then
        u104 = function() -- Line: 563
            -- upvalues: LocalPlayer (ref), u103 (copy), Attribute2 (copy), u102 (copy), Participants (ref)
            local Attribute3 = LocalPlayer:GetAttribute("Team");
            local Attribute4 = u103:GetAttribute("Team");
            local v128;

            if Attribute2 == "Hostage Rescue" then
                v128 = u103:GetAttribute("HasRescueKit") == true;
            else
                v128 = u103:GetAttribute("HasDefuseKit") == true;
            end;

            local DefuseKit = u102:FindFirstChild("DefuseKit");

            if DefuseKit then
                v128 = Participants.IsAlive(u103);

                if v128 then
                    if v128 then
                        v128 = Attribute4 == Attribute3;
                    end;
                end;

                DefuseKit.Visible = v128;
            end;
        end;

        local function hideObjectiveKits() -- Line: 579
            -- upvalues: u102 (copy)
            local v129 = u102;

            if v129 then
                v129 = v129:FindFirstChild("DefuseKit");
            end;

            if v129 then
                v129.Visible = false;
            end;
        end;

        p101:Add(Observers.observeAttribute(u103, "HasDefuseKit", function(p130) -- Line: 583
            -- upvalues: u104 (ref), hideObjectiveKits (copy)
            u104();

            return hideObjectiveKits;
        end));
        p101:Add(Observers.observeAttribute(u103, "HasRescueKit", function(p131) -- Line: 588
            -- upvalues: u104 (ref), hideObjectiveKits (copy)
            u104();

            return hideObjectiveKits;
        end));
        u104();
    end;
end;

local function setupDeathmatchTemplate(p132: any, u133: userdata, p134: userdata) -- Line: 597
    -- upvalues: Colors (copy), Observers (copy)
    local Attribute = p134:GetAttribute("Team");
    local Info = u133:FindFirstChild("Info");

    if Info then
        local UIStroke = Info:FindFirstChild("UIStroke");

        if UIStroke then
            UIStroke.Color = Colors["Team Color"][Attribute];
        end;

        local Amount = Info:FindFirstChild("Amount");

        if Amount then
            Amount.Text = "0";
        end;
    end;

    local UIStroke = u133:FindFirstChild("UIStroke");

    if UIStroke then
        UIStroke.Color = Colors["Team Color"][Attribute];
    end;

    p132:Add(Observers.observeAttribute(p134, "Score", function(p135) -- Line: 620
        -- upvalues: u133 (copy)
        local Info2 = u133:FindFirstChild("Info");

        if Info2 then
            Info2 = Info2:FindFirstChild("Amount");
        end;

        if Info2 then
            Info2.Text = tostring(p135);
        end;

        u133.LayoutOrder = -p135;

        return nil;
    end));
end;

local function refreshCompetitiveStrokeColors() -- Line: 632
    -- upvalues: u3 (copy), Participants (copy), refreshCompetitiveStrokeColorForPlayer (copy)
    for i, v in u3 do
        local v136 = Participants.FromKey(i);

        if v136 and (v and v.Parent) then
            refreshCompetitiveStrokeColorForPlayer(v136);
        end;
    end;
end;

local function destroyCachedTemplate(p137: number) -- Line: 642
    -- upvalues: u3 (copy), u4 (copy)
    local v138 = u3[p137];

    if not v138 then
        return;
    end;

    local Info = v138:FindFirstChild("Info");
    local v139 = Info and u4[Info];

    if v139 then
        v139:Destroy();
        u4[Info] = nil;
    end;

    if v138.Parent then
        v138:Destroy();
    end;

    u3[p137] = nil;
end;

function u1.createTemplate(p140: userdata, p141: userdata) -- Line: 667
    -- upvalues: Participants (copy), u3 (copy), u4 (copy), Janitor (copy), ReplicatedStorage (copy), setupDeathmatchTemplate (copy), LocalPlayer (copy), setupBombDefusalTemplate (copy), refreshCompetitiveStrokeColors (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    local v142 = Participants.Key(p140);
    local v143 = u3[v142];

    if v143 then
        local Info = v143:FindFirstChild("Info");
        local v144 = Info and u4[Info];

        if v144 then
            v144:Destroy();
            u4[Info] = nil;
        end;

        if v143.Parent then
            v143:Destroy();
        end;

        u3[v142] = nil;
    end;

    local Attribute = workspace:GetAttribute("Gamemode");
    local Attribute2 = p140:GetAttribute("Team");

    if Attribute2 ~= "Terrorists" and Attribute2 ~= "Counter-Terrorists" then
        return nil;
    end;

    local v145 = Janitor.new();
    local u146;

    if Attribute == "Deathmatch" then
        u146 = ReplicatedStorage.Assets.UI.Deathmatch.PlayerTemplate:Clone();
    else
        if Attribute ~= "Bomb Defusal" and Attribute ~= "Hostage Rescue" then
            v145:Destroy();

            return nil;
        end;

        local v147 = ReplicatedStorage.Assets.UI.BombDefusal:FindFirstChild(Attribute2);

        if not v147 then
            warn((`[PlayerInfo]: Missing player template for team {Attribute2}`));
            v145:Destroy();

            return nil;
        end;

        u146 = v147:Clone();
    end;

    if not u146 then
        v145:Destroy();

        return nil;
    end;

    local v148 = u146;

    if v148 then
        v148 = v148:FindFirstChild("Bomb");
    end;

    if v148 then
        v148.Visible = false;
    end;

    local Info = u146:FindFirstChild("Info");

    if Info then
        local Attribute3 = Info:GetAttribute("OriginalSize");
        local v149 = Attribute3 or Info.Size;

        if not Attribute3 then
            Info:SetAttribute("OriginalSize", v149);
        end;

        if Attribute == "Deathmatch" then
            Info.Size = v149;
            Info.Visible = true;
        else
            Info.Size = UDim2.fromScale(1, 0);
            Info.Visible = false;
        end;

        Info:SetAttribute("RevealKey", nil);
    end;

    local PlayerBackground = u146:FindFirstChild("PlayerBackground");

    if PlayerBackground then
        PlayerBackground = PlayerBackground:FindFirstChild("Player");
    end;

    if PlayerBackground and PlayerBackground:IsA("ImageLabel") then
        PlayerBackground.Image = Participants.HeadshotImage(p140, 420);
    end;

    u146.Parent = p141;
    u3[Participants.Key(p140)] = u146;
    local PlayerBackground2 = u146:FindFirstChild("PlayerBackground");

    if PlayerBackground2 then
        PlayerBackground2 = PlayerBackground2:FindFirstChildOfClass("UIStroke");
    end;

    if PlayerBackground2 then
        local Attribute3 = PlayerBackground2:GetAttribute("DefaultStrokeColor");

        if not Attribute3 then
            Attribute3 = PlayerBackground2.Color;
            PlayerBackground2:SetAttribute("DefaultStrokeColor", Attribute3);
        end;

        if not Attribute3 then
            local _ = PlayerBackground2.Color;
        end;
    end;

    if Attribute == "Deathmatch" then
        setupDeathmatchTemplate(v145, u146, p140);
    else
        local Health = u146:FindFirstChild("Health");

        if Health then
            Health.Visible = LocalPlayer:GetAttribute("Team") == Attribute2;
        end;

        setupBombDefusalTemplate(v145, u146, p140);
        refreshCompetitiveStrokeColors();
        local v150 = u3[Participants.Key(p140)];

        if v150 and v150.Parent then
            setTemplateInfoRevealed(p140, v150, (shouldShowInfoForPlayer(p140)));
        end;
    end;

    v145:Add(function() -- Line: 752
        -- upvalues: u146 (ref)
        u146:Destroy();
    end);

    return v145;
end;

function u1.cleanupTemplate(p151: userdata) -- Line: 759
    -- upvalues: Participants (copy), u3 (copy), u4 (copy), u6 (copy), u7 (copy), refreshCompetitiveStrokeColors (copy)
    local v152 = Participants.Key(p151);
    local v153 = u3[v152];

    if v153 then
        local Info = v153:FindFirstChild("Info");
        local v154 = Info and u4[Info];

        if v154 then
            v154:Destroy();
            u4[Info] = nil;
        end;

        if v153.Parent then
            v153:Destroy();
        end;

        u3[v152] = nil;
    end;

    u3[v152] = nil;
    u6[v152] = nil;
    u7[v152] = nil;
    refreshCompetitiveStrokeColors();
end;

function u1.refreshCompetitiveColors() -- Line: 769
    -- upvalues: refreshCompetitiveStrokeColors (copy)
    refreshCompetitiveStrokeColors();
end;

function u1.applyTemplateLifeState(p155: userdata, p156: boolean) -- Line: 773
    -- upvalues: setTemplateLifeState (copy)
    return setTemplateLifeState(p155, p156);
end;

function u1.setTeammateInfoRevealed(p157: boolean) -- Line: 777
    -- upvalues: u8 (ref), refreshAllTemplateInfoVisibility (copy)
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        p157 = false;
    end;

    u8 = p157;
    refreshAllTemplateInfoVisibility();
end;

function u1.updateTeammateGrenades(p158: table) -- Line: 787
    -- upvalues: u5 (copy), Participants (copy), u3 (copy), updateTemplateGrenades (copy)
    for _, v in p158 do
        local v159 = tonumber(v.userId);

        if v159 then
            u5[v159] = v.grenades or {};
            local v160 = Participants.FromKey(v159);
            local v161 = u3[v159];

            if v160 and (v161 and v161.Parent) then
                updateTemplateGrenades(v161, v159);
            end;
        end;
    end;
end;

function u1.incrementTemplateKills(p162: number) -- Line: 805
    -- upvalues: GameState (copy), u6 (copy), u3 (copy), setTemplateKills (copy), Participants (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    if GameState.GetState() == "Warmup" then
        return;
    end;

    u6[p162] = (u6[p162] or 0) + 1;
    local v163 = u3[p162];

    if v163 and v163.Parent then
        setTemplateKills(v163, u6[p162]);
    end;

    local v164 = Participants.FromKey(p162);
    local v165 = v164 and u3[Participants.Key(v164)];

    if v165 then
        if not v165.Parent then
            return;
        end;

        setTemplateInfoRevealed(v164, v165, (shouldShowInfoForPlayer(v164)));
    end;
end;

function u1.updateRoundDamageMatrix(p166: table) -- Line: 823
    -- upvalues: Participants (copy), u7 (copy), u3 (copy), updateDamageFromMatrix (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    local v167 = p166.outgoing or {};
    local v168 = p166.incoming or {};

    for _, v in Participants.GetAll() do
        local v169 = Participants.Key(v);
        local v170 = tostring(v169);
        local v171 = v167[v170] or nil;
        local v172 = v168[v170] or nil;
        local v173;

        if v171 == nil then
            v173 = false;
        else
            v173 = #v171 > 0;
        end;

        local v174;

        if v172 == nil then
            v174 = false;
        else
            v174 = #v172 > 0;
        end;

        local v175 = u7[v169] == true;
        local v176 = v173 or v174;
        u7[v169] = v176;
        updateDamageFromMatrix(u3[v169], v171, v172);

        if v175 ~= v176 then
            local v177 = u3[Participants.Key(v)];

            if v177 then
                if v177.Parent then
                    setTemplateInfoRevealed(v, v177, (shouldShowInfoForPlayer(v)));
                end;
            end;
        end;
    end;
end;

function u1.getTemplateByUserId(p178: number) -- Line: 848
    -- upvalues: u3 (copy)
    return u3[p178];
end;

Remotes.UI.TeammateGrenades.Listen(u1.updateTeammateGrenades);
Remotes.UI.RoundDamageMatrix.Listen(u1.updateRoundDamageMatrix);
GameState.ListenToState(function(p179: string?, p180: string) -- Line: 858
    -- upvalues: u3 (copy), u6 (copy), u7 (copy), setTemplateKills (copy), refreshAllTemplateInfoVisibility (copy)
    if p179 == "Buy Period" and p180 ~= "Buy Period" then
        for i, v in u3 do
            u6[i] = nil;
            u7[i] = nil;

            if v and v.Parent then
                setTemplateKills(v, 0);
            end;
        end;
    end;

    refreshAllTemplateInfoVisibility();
end);
Players.PlayerRemoving:Connect(function(p181: userdata) -- Line: 874
    -- upvalues: u1 (copy)
    u1.cleanupTemplate(p181);
end);

return u1;