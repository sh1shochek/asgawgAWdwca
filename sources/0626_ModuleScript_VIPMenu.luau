-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u2 = RunService:IsStudio();
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps;
local u3 = { {
        Name = "DropKnife",
        Label = "Drop Knife",
        Key = "KnifeDropEnabled"
    }, {
        Name = "FreezeTimer",
        Label = "Freeze Timer",
        Key = "TimerFrozen"
    }, {
        Name = "KillTrading",
        Label = "Kill Trading",
        Key = "KillTradingEnabled"
    }, {
        Name = "InfiniteAmmo",
        Label = "Infinite Ammo",
        Key = "InfiniteAmmoEnabled"
    }, {
        Name = "InfiniteCash",
        Label = "Infinite Cash",
        Key = "InfiniteCashEnabled"
    }, {
        Name = "DisableTeamLimit",
        Label = "Disable Team Limit",
        Key = "DisableTeamLimitEnabled"
    }, {
        Name = "FriendlyFire",
        Label = "Friendly Fire",
        Key = "FriendlyFireEnabled"
    }, {
        Name = "PlayerCollisions",
        Label = "Player Collisions",
        Key = "PlayerCollisionsEnabled"
    }, {
        Name = "CompetitiveMovement",
        Label = "Competitive Movement",
        Key = "CompetitiveMovementEnabled"
    } };
local u4 = { "Easy", "Normal", "Hard", "Expert" };
local u5 = {
    Easy = Color3.fromRGB(126, 211, 133),
    Normal = Color3.fromRGB(238, 238, 238),
    Hard = Color3.fromRGB(240, 168, 76),
    Expert = Color3.fromRGB(236, 88, 88)
};
local u6 = {
    {
        Name = "TerroristBots",
        Label = "Terrorist Bots",
        Key = "BotTerrorists",
        OtherKey = "BotCounterTerrorists",
        Accent = Color3.fromRGB(222, 176, 82)
    },
    {
        Name = "CounterTerroristBots",
        Label = "CT Bots",
        Key = "BotCounterTerrorists",
        OtherKey = "BotTerrorists",
        Accent = Color3.fromRGB(104, 158, 228)
    }
};
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(150, 150, 150);
local Color3_fromRGB_ret3 = Color3.fromRGB(125, 206, 243);
local Color3_fromRGB_ret4 = Color3.fromRGB(92, 92, 92);
local Color3_fromRGB_ret5 = Color3.fromRGB(32, 32, 32);
local Color3_fromRGB_ret6 = Color3.fromRGB(150, 44, 44);
local Color3_fromRGB_ret7 = Color3.fromRGB(236, 96, 96);
local Color3_fromRGB_ret8 = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret9 = Color3.fromRGB(77, 77, 77);
local TweenInfo_new_ret = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret3 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local TweenInfo_new_ret4 = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret5 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local TweenInfo_new_ret6 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u7 = { {
        Name = "Competitive",
        Mode = "COMPETITIVE",
        Description = "Classic round-based rules with economy and no respawns.",
        ServerGamemode = "Competitive",
        Image = "rbxassetid://94623163725066"
    }, {
        Name = "Casual",
        Mode = "CASUAL",
        Description = "Relaxed round-based rules with lighter penalties.",
        ServerGamemode = "Casual",
        Image = "rbxassetid://129151622905807"
    }, {
        Name = "Deathmatch",
        Mode = "DEATHMATCH",
        Description = "Fast respawn combat focused on eliminations.",
        ServerGamemode = "Deathmatch",
        Image = "rbxassetid://102545840590668"
    }, {
        Name = "Surf",
        Mode = "SURF",
        Description = "Slide down ramps with CS:GO surf movement.",
        ServerGamemode = "Surf"
    } };
local u8 = {
    GodMode = {
        Key = "GodModeEnabledPlayers",
        Title = "God Mode"
    },
    ESP = {
        Key = "ESPEnabledPlayers",
        Title = "ESP"
    }
};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = false;
local u13 = nil;
local u14 = {};
local u15 = "Settings";
local u16 = "KickPlayer";
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = false;
local u21 = nil;
local u22 = setmetatable({}, {
    __mode = "k"
});
local u23 = setmetatable({}, {
    __mode = "k"
});
local u24 = Janitor.new();
local u25 = Janitor.new();
local u26 = Janitor.new();
local u27 = Janitor.new();
local u28 = Janitor.new();
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = 0;
local u33 = {};
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = nil;

local function canUseVIPMenu() -- Line: 178
    -- upvalues: u2 (copy), LocalPlayer (copy)
    return u2 or LocalPlayer:GetAttribute("CanUseVIPMenu") == true;
end;

local function hasActiveCharacter() -- Line: 182
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v47;

    if Character == nil then
        v47 = false;
    else
        v47 = Character:IsDescendantOf(workspace);
    end;

    return v47;
end;

local function isOnPlayingTeam() -- Line: 187
    -- upvalues: LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    return Attribute == "Counter-Terrorists" and true or Attribute == "Terrorists";
end;

local function isInGameplayContext() -- Line: 192
    -- upvalues: LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    return Attribute == "Counter-Terrorists" and true or Attribute == "Terrorists" or LocalPlayer:GetAttribute("IsSpectating") == true;
end;

local function getMainGuiFromRoot() -- Line: 196
    -- upvalues: u29 (ref)
    local v48 = u29 and u29.Parent;

    if v48 then
        v48 = v48.Parent;
    end;

    if v48 then
        v48 = v48.Parent;
    end;

    if v48 and v48:IsA("ScreenGui") then
        return v48;
    end;

    return nil;
end;

local function isMainMenuVisible() -- Line: 206
    -- upvalues: u29 (ref)
    local v49 = u29 and u29.Parent;

    if v49 then
        v49 = v49.Parent;
    end;

    if v49 then
        v49 = v49.Parent;
    end;

    if not (v49 and v49:IsA("ScreenGui")) then
        v49 = nil;
    end;

    if not v49 then
        return false;
    end;

    local Menu = v49:FindFirstChild("Menu");
    local v50;

    if Menu == nil then
        v50 = false;
    else
        v50 = Menu:IsA("GuiObject") and Menu.Visible;
    end;

    return v50;
end;

local function isTeamSelectionVisible() -- Line: 216
    -- upvalues: u29 (ref)
    local v51 = u29 and u29.Parent;

    if v51 then
        v51 = v51.Parent;
    end;

    if v51 then
        v51 = v51.Parent;
    end;

    if not (v51 and v51:IsA("ScreenGui")) then
        v51 = nil;
    end;

    if not v51 then
        return false;
    end;

    local Gameplay = v51:FindFirstChild("Gameplay");

    if not (Gameplay and Gameplay:IsA("GuiObject")) then
        return false;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");

    if not (Middle and Middle:IsA("GuiObject")) then
        return false;
    end;

    local TeamSelection = Middle:FindFirstChild("TeamSelection");
    local v52;

    if TeamSelection == nil then
        v52 = false;
    else
        v52 = TeamSelection:IsA("GuiObject") and TeamSelection.Visible;
    end;

    return v52;
end;

local function isLocalPlayerSpectating() -- Line: 236
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("IsSpectating") == true;
end;

local function bindPress(p53: any, p54: userdata, u55: function) -- Line: 240
    if p54:IsA("GuiButton") then
        p53:Add(p54.MouseButton1Click:Connect(u55));

        return;
    end;

    p54.Active = true;
    p53:Add(p54.InputBegan:Connect(function(p56) -- Line: 249
        -- upvalues: u55 (copy)
        local UserInputType = p56.UserInputType;

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        u55();
    end));
end;

local function bindHover(p57: any, p58: userdata, u59: function) -- Line: 259
    p57:Add(p58.MouseEnter:Connect(function() -- Line: 260
        -- upvalues: u59 (copy)
        u59(true);
    end));
    p57:Add(p58.MouseLeave:Connect(function() -- Line: 263
        -- upvalues: u59 (copy)
        u59(false);
    end));
end;

local function tween(p60: userdata, p61: userdata, p62: table) -- Line: 268
    -- upvalues: TweenService (copy)
    local v63 = TweenService:Create(p60, p61, p62);
    v63:Play();

    return v63;
end;

local function paintButton(p64: userdata) -- Line: 274
    -- upvalues: u22 (copy), u23 (copy), TweenInfo_new_ret (copy), TweenService (copy)
    local v65 = u22[p64];

    if v65 then
        if u23[p64] then
            v65 = v65:Lerp(Color3.new(1, 1, 1), 0.12);
        end;

        TweenService:Create(p64, TweenInfo_new_ret, {
            BackgroundColor3 = v65
        }):Play();
    end;
end;

local function setButtonColor(p66: userdata, p67) -- Line: 282
    -- upvalues: u22 (copy), paintButton (copy)
    u22[p66] = p67;
    paintButton(p66);
end;

local function bindButtonHover(p68: any, u69: userdata) -- Line: 287
    -- upvalues: u22 (copy), bindHover (copy), u23 (copy), paintButton (copy)
    u22[u69] = u22[u69] or u69.BackgroundColor3;
    bindHover(p68, u69, function(p70) -- Line: 289
        -- upvalues: u23 (ref), u69 (copy), paintButton (ref)
        u23[u69] = p70 and true or nil;
        paintButton(u69);
    end);
end;

local function getScale(p71: userdata) -- Line: 295
    local v72 = p71:FindFirstChildOfClass("UIScale");

    if not v72 then
        v72 = Instance.new("UIScale");
        v72.Parent = p71;
    end;

    return v72;
end;

local function popIn(p73: userdata, p74: number, p75: number?) -- Line: 305
    -- upvalues: TweenInfo_new_ret5 (copy), TweenService (copy)
    local v76 = p73:FindFirstChildOfClass("UIScale");

    if not v76 then
        v76 = Instance.new("UIScale");
        v76.Parent = p73;
    end;

    v76.Scale = p74;
    local v77;

    if p75 then
        v77 = TweenInfo.new(TweenInfo_new_ret5.Time, TweenInfo_new_ret5.EasingStyle, TweenInfo_new_ret5.EasingDirection, 0, false, p75);
    else
        v77 = TweenInfo_new_ret5;
    end;

    TweenService:Create(v76, v77, {
        Scale = 1
    }):Play();
end;

local function slideIn(p78: userdata, p79) -- Line: 315
    -- upvalues: TweenInfo_new_ret4 (copy), TweenService (copy)
    local Attribute = p78:GetAttribute("BasePosition");

    if typeof(Attribute) ~= "UDim2" then
        Attribute = p78.Position;
        p78:SetAttribute("BasePosition", Attribute);
    end;

    p78.Position = Attribute + p79;
    TweenService:Create(p78, TweenInfo_new_ret4, {
        Position = Attribute
    }):Play();
end;

local function punchLabel(p80: userdata) -- Line: 326
    -- upvalues: TweenInfo_new_ret6 (copy), TweenService (copy)
    local Attribute = p80:GetAttribute("BaseSize");

    if typeof(Attribute) ~= "UDim2" then
        Attribute = p80.Size;
        p80:SetAttribute("BaseSize", Attribute);
    end;

    p80.Size = UDim2.new(Attribute.X.Scale, Attribute.X.Offset, Attribute.Y.Scale * 1.3, Attribute.Y.Offset);
    TweenService:Create(p80, TweenInfo_new_ret6, {
        Size = Attribute
    }):Play();
end;

local function setLabelValue(p81: userdata, p82: string, p83) -- Line: 337
    -- upvalues: punchLabel (copy)
    p81.TextColor3 = p83;

    if p81.Text ~= p82 then
        p81.Text = p82;
        punchLabel(p81);
    end;
end;

local function playClick() -- Line: 345
    -- upvalues: Router (copy)
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
end;

local function clearGenerated(p84: userdata, p85: userdata, p86: table?) -- Line: 349
    for _, child in ipairs(p84:GetChildren()) do
        if child ~= p85 and not (p86 and p86[child.Name]) and child:IsA("GuiObject") then
            child:Destroy();
        end;
    end;

    p85.Visible = false;
end;

local function getTogglePlayers(p87: string) -- Line: 364
    -- upvalues: u9 (ref)
    local v88 = u9[p87];

    if typeof(v88) == "table" then
        return v88;
    end;

    local v89 = {};
    u9[p87] = v89;

    return v89;
end;

local function setLocalTogglePlayer(p90: string, p91: number, p92: boolean) -- Line: 375
    -- upvalues: u9 (ref)
    local v93 = u9[p90];

    if typeof(v93) ~= "table" then
        v93 = {};
        u9[p90] = v93;
    end;

    v93[p91] = nil;
    v93[tostring(p91)] = p92 and true or nil;

    return v93;
end;

local function isPlayerToggleEnabled(p94: string, p95: number) -- Line: 382
    -- upvalues: u9 (ref)
    local v96 = u9[p94];

    if typeof(v96) == "table" then
        return v96[tostring(p95)] == true and true or v96[p95] == true;
    end;

    return false;
end;

local function updateVoteKickHeader() -- Line: 391
    -- upvalues: u39 (ref), u8 (copy), u16 (ref)
    if not u39 then
        return;
    end;

    local v97 = u8[u16];
    u39.Text = string.upper(not v97 and "Kick Player" or v97.Title);
end;

local function updateRootPosition(p98: boolean) -- Line: 401
    -- upvalues: u37 (ref), u29 (ref), TweenInfo_new_ret4 (copy), TweenService (copy)
    local UDim2_new_ret = UDim2.new(0.5, not u37.Visible and 0 or -(u37.AbsoluteSize.X + u29.AbsoluteSize.X * 0.02) / 2, 0.5, 0);

    if p98 then
        TweenService:Create(u29, TweenInfo_new_ret4, {
            Position = UDim2_new_ret
        }):Play();

        return;
    end;

    u29.Position = UDim2_new_ret;
end;

local function setTabVisual(p99: userdata, p100: boolean) -- Line: 411
    -- upvalues: Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret5 (copy), u22 (copy), paintButton (copy)
    local v101;

    if p100 then
        v101 = Color3_fromRGB_ret4;
    else
        v101 = Color3_fromRGB_ret5;
    end;

    u22[p99] = v101;
    paintButton(p99);
    local Selected = p99:FindFirstChild("Selected");

    if Selected and Selected:IsA("GuiObject") then
        Selected.Visible = p100;
    end;
end;

local function staggerCards(p102: userdata) -- Line: 420
    -- upvalues: popIn (copy)
    local v103 = {};

    for _, child in ipairs(p102:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            table.insert(v103, child);
        end;
    end;

    table.sort(v103, function(p104, p105) -- Line: 427
        return p104.LayoutOrder < p105.LayoutOrder;
    end);

    for i, v in ipairs(v103) do
        popIn(v, 0.9, (i - 1) * 0.035);
    end;
end;

local function showPanel(p106: string, p107: boolean?) -- Line: 435
    -- upvalues: u15 (ref), u34 (ref), u35 (ref), u36 (ref), u33 (ref), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret5 (copy), u22 (copy), paintButton (copy), slideIn (copy), staggerCards (copy)
    u15 = p106;
    u34.Visible = p106 == "Settings";
    u35.Visible = p106 == "MapSelect";
    u36.Visible = p106 == "ModeSelect";

    for i, v in pairs(u33) do
        local v108 = i == p106;
        local v109;

        if v108 then
            v109 = Color3_fromRGB_ret4;
        else
            v109 = Color3_fromRGB_ret5;
        end;

        u22[v] = v109;
        paintButton(v);
        local Selected = v:FindFirstChild("Selected");

        if Selected and Selected:IsA("GuiObject") then
            Selected.Visible = v108;
        end;
    end;

    if p107 then
        local v110;

        if p106 == "Settings" then
            v110 = u34;
        elseif p106 == "MapSelect" then
            v110 = u35;
        else
            v110 = u36;
        end;

        slideIn(v110, UDim2.fromOffset(0, 16));

        if p106 ~= "Settings" then
            staggerCards(v110);
        end;
    end;
end;

local function showPlayers() -- Line: 453
    -- upvalues: u39 (ref), u8 (copy), u16 (ref), u37 (ref), slideIn (copy), updateRootPosition (copy)
    if u39 then
        local v111 = u8[u16];
        u39.Text = string.upper(not v111 and "Kick Player" or v111.Title);
    end;

    if not u37.Visible then
        u37.Visible = true;
        slideIn(u37, UDim2.fromOffset(-40, 0));
    end;

    updateRootPosition(true);
end;

local function hidePlayers(p112: boolean) -- Line: 462
    -- upvalues: u37 (ref), updateRootPosition (copy)
    u37.Visible = false;
    updateRootPosition(p112);
end;

local function getMapInfo(p113: string) -- Line: 467
    -- upvalues: u14 (copy), Maps (copy)
    if u14[p113] ~= nil then
        return u14[p113];
    end;

    local v114 = Maps:FindFirstChild(p113);

    if v114 and not v114:IsA("ModuleScript") then
        v114 = v114:FindFirstChild("init");
    end;

    if not (v114 and v114:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v114);

    if not success or typeof(result) ~= "table" then
        result = nil;
    end;

    u14[p113] = result;

    return result;
end;

local function mapSupportsMode(p115: string, p116: string?) -- Line: 484
    -- upvalues: getMapInfo (copy)
    if not p116 then
        return true;
    end;

    local v117 = getMapInfo(p115);

    if v117 then
        v117 = v117.Gamemode;
    end;

    if typeof(v117) ~= "table" then
        return false;
    end;

    local v118 = v117[p116];
    local v119;

    if v118 == nil then
        v119 = false;
    else
        v119 = v118 ~= false;
    end;

    return v119;
end;

local function loadAvailableMaps() -- Line: 499
    -- upvalues: u11 (ref), Maps (copy), u14 (copy), u12 (ref)
    u11 = {};

    for _, child in ipairs(Maps:GetChildren()) do
        local Name = child.Name;
        local v120;

        if child:IsA("ModuleScript") then
            v120 = child;
        else
            v120 = child:FindFirstChild("init");
        end;

        if v120 and v120:IsA("ModuleScript") then
            local success, result = pcall(require, v120);

            if success and (typeof(result) == "table" and result.Hidden ~= true) then
                u14[Name] = result;

                if Name ~= "Tutorial Range" then
                    local v121 = {
                        Name = Name,
                        Icon = typeof(result.Icon) == "string" and (result.Icon or "") or ""
                    };
                    table.insert(u11, v121);
                end;
            end;
        end;
    end;

    table.sort(u11, function(p122, p123) -- Line: 531
        return p122.Name < p123.Name;
    end);
    u12 = true;
end;

local function getGamemodeIcon(p124: string) -- Line: 538
    -- upvalues: u11 (ref), getMapInfo (copy)
    for _, v in ipairs(u11) do
        local Name = v.Name;
        local v125;

        if p124 then
            local v126 = getMapInfo(Name);

            if v126 then
                v126 = v126.Gamemode;
            end;

            if typeof(v126) == "table" then
                local v127 = v126[p124];

                if v127 == nil then
                    v125 = false;
                else
                    v125 = v127 ~= false;
                end;
            else
                v125 = false;
            end;
        else
            v125 = true;
        end;

        if v125 and v.Icon ~= "" then
            return v.Icon;
        end;
    end;

    return nil;
end;

local function setSegments(p128: userdata, p129: number, p130: function, p131) -- Line: 551
    -- upvalues: Color3_fromRGB_ret9 (copy), Color3_fromRGB_ret8 (copy), TweenInfo_new_ret (copy), TweenService (copy)
    local v132 = p128:FindFirstChildOfClass("UIListLayout");
    local v133 = p129 > 4 and 0.012 or 0.03;

    if v132 then
        v132.Padding = UDim.new(v133, 0);
    end;

    local v134 = {};

    for _, child in ipairs(p128:GetChildren()) do
        if child:IsA("Frame") then
            table.insert(v134, child);
        end;
    end;

    for i = #v134 + 1, p129 do
        local Frame = Instance.new("Frame");
        Frame.BorderSizePixel = 0;
        Frame.BackgroundColor3 = Color3_fromRGB_ret9;
        Frame.Parent = p128;
        v134[i] = Frame;
        local _ = i;
    end;

    local v135 = (1 - v133 * (p129 - 1)) / p129;

    for i, v in ipairs(v134) do
        v.Name = tostring(i);
        v.LayoutOrder = i;
        v.Visible = i <= p129;
        v.Size = UDim2.fromScale(v135, 1);
        local v136;

        if p130(i) then
            v136 = p131 or Color3_fromRGB_ret8;
        else
            v136 = Color3_fromRGB_ret9;
        end;

        if v.BackgroundColor3 ~= v136 then
            TweenService:Create(v, TweenInfo_new_ret, {
                BackgroundColor3 = v136
            }):Play();
        end;
    end;
end;

local function setArrowEnabled(p137: userdata, p138: boolean) -- Line: 585
    p137:SetAttribute("Enabled", p138);

    if p137:IsA("ImageButton") then
        p137.ImageTransparency = p138 and 0 or 0.75;
    end;
end;

local function setToggleSelector(p139: table, u140: boolean) -- Line: 592
    -- upvalues: Color3_fromRGB_ret (copy), punchLabel (copy), setSegments (copy)
    local Title = p139.Title;
    local v141 = u140 and "ON" or "OFF";
    Title.TextColor3 = Color3_fromRGB_ret;

    if Title.Text ~= v141 then
        Title.Text = v141;
        punchLabel(Title);
    end;

    setSegments(p139.Bar, 2, function(p142) -- Line: 594
        -- upvalues: u140 (copy)
        return p142 == (u140 and 2 or 1);
    end);
    local Decrease = p139.Decrease;
    Decrease:SetAttribute("Enabled", u140);

    if Decrease:IsA("ImageButton") then
        Decrease.ImageTransparency = u140 and 0 or 0.75;
    end;

    local Increase = p139.Increase;
    local v143 = not u140;
    Increase:SetAttribute("Enabled", v143);

    if Increase:IsA("ImageButton") then
        Increase.ImageTransparency = v143 and 0 or 0.75;
    end;
end;

local function isBotAutoFill() -- Line: 601
    -- upvalues: u9 (ref)
    return u9.BotAutoFill ~= false;
end;

local function areBotsFrozen() -- Line: 605
    -- upvalues: u9 (ref)
    return u9.BotsFrozen == true;
end;

local function getBotCount(p144: string) -- Line: 609
    -- upvalues: u9 (ref)
    local v145 = u9[p144];

    return typeof(v145) ~= "number" and 0 or v145;
end;

local function getBotDifficulty() -- Line: 614
    -- upvalues: u9 (ref), u4 (copy)
    local BotDifficulty = u9.BotDifficulty;

    if table.find(u4, BotDifficulty) then
        return BotDifficulty;
    end;

    return u4[1];
end;

local function refreshBotControls() -- Line: 619
    -- upvalues: u9 (ref), u6 (copy), u19 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), punchLabel (copy), setSegments (copy), u4 (copy), u5 (copy), setToggleSelector (copy)
    local v146 = u9.BotAutoFill ~= false;

    for _, v in ipairs(u6) do
        local v147 = u19[v.Name];

        if v147 then
            local v148 = u9[v.Key];
            local u149 = typeof(v148) ~= "number" and 0 or v148;
            local Title = v147.Title;
            local v150 = tostring(u149);
            local v151;

            if v146 then
                v151 = Color3_fromRGB_ret2;
            else
                v151 = Color3_fromRGB_ret;
            end;

            Title.TextColor3 = v151;

            if Title.Text ~= v150 then
                Title.Text = v150;
                punchLabel(Title);
            end;

            local function v153(p152) -- Line: 627
                -- upvalues: u149 (copy)
                return p152 <= u149;
            end;

            local v154;

            if v146 then
                v154 = Color3_fromRGB_ret2;
            else
                v154 = v.Accent;
            end;

            setSegments(v147.Bar, 14, v153, v154);
            local Decrease = v147.Decrease;
            local v155 = u149 > 0;
            Decrease:SetAttribute("Enabled", v155);

            if Decrease:IsA("ImageButton") then
                Decrease.ImageTransparency = v155 and 0 or 0.75;
            end;

            local Increase = v147.Increase;
            local v156 = u9[v.OtherKey];
            local v157 = u149 + (typeof(v156) ~= "number" and 0 or v156) < 14;
            Increase:SetAttribute("Enabled", v157);

            if Increase:IsA("ImageButton") then
                Increase.ImageTransparency = v157 and 0 or 0.75;
            end;
        end;
    end;

    local BotDifficulty = u19.BotDifficulty;

    if BotDifficulty then
        local BotDifficulty2 = u9.BotDifficulty;

        if not table.find(u4, BotDifficulty2) then
            BotDifficulty2 = u4[1];
        end;

        local table_find_ret = table.find(u4, BotDifficulty2);
        local Title = BotDifficulty.Title;
        local string_upper_ret = string.upper(BotDifficulty2);
        Title.TextColor3 = u5[BotDifficulty2];

        if Title.Text ~= string_upper_ret then
            Title.Text = string_upper_ret;
            punchLabel(Title);
        end;

        setSegments(BotDifficulty.Bar, #u4, function(p158) -- Line: 639
            -- upvalues: table_find_ret (copy)
            return p158 <= table_find_ret;
        end, u5[BotDifficulty2]);
        local Decrease = BotDifficulty.Decrease;
        local v159 = table_find_ret > 1;
        Decrease:SetAttribute("Enabled", v159);

        if Decrease:IsA("ImageButton") then
            Decrease.ImageTransparency = v159 and 0 or 0.75;
        end;

        local Increase = BotDifficulty.Increase;
        local v160 = table_find_ret < #u4;
        Increase:SetAttribute("Enabled", v160);

        if Increase:IsA("ImageButton") then
            Increase.ImageTransparency = v160 and 0 or 0.75;
        end;
    end;

    if u19.BotAutoFill then
        setToggleSelector(u19.BotAutoFill, v146);
    end;

    if u19.BotsFrozen then
        setToggleSelector(u19.BotsFrozen, u9.BotsFrozen == true);
    end;
end;

local function updateToggleIndicators() -- Line: 653
    -- upvalues: u3 (copy), u19 (copy), setToggleSelector (copy), u9 (ref), refreshBotControls (copy)
    for _, v in ipairs(u3) do
        local v161 = u19[v.Name];

        if v161 then
            setToggleSelector(v161, u9[v.Key] == true);
        end;
    end;

    refreshBotControls();
end;

local function setCardSelected(p162: userdata, p163: boolean) -- Line: 663
    -- upvalues: popIn (copy)
    local Badge = p162:FindFirstChild("Badge");

    if Badge and Badge:IsA("GuiObject") then
        local Visible = Badge.Visible;
        Badge.Visible = p163;

        if p163 and not Visible then
            popIn(Badge, 0.5);
        end;
    end;

    local Highlight = p162:FindFirstChild("Highlight", true);

    if Highlight and Highlight:IsA("UIStroke") then
        Highlight.Enabled = p163;
    end;
end;

local function bindCardHover(p164: any, p165: userdata) -- Line: 679
    -- upvalues: bindHover (copy), TweenInfo_new_ret4 (copy), TweenService (copy)
    local Image = p165:FindFirstChild("Image", true);

    if not (Image and Image:IsA("ImageLabel")) then
        return;
    end;

    local ImageColor3 = Image.ImageColor3;
    bindHover(p164, p165, function(p166) -- Line: 686
        -- upvalues: Image (copy), TweenInfo_new_ret4 (ref), ImageColor3 (copy), TweenService (ref)
        local v167 = p166 and 1.06 or 1;
        local v168 = {};
        local v169;

        if p166 then
            v169 = ImageColor3:Lerp(Color3.new(1, 1, 1), 0.35);
        else
            v169 = ImageColor3;
        end;

        v168.ImageColor3 = v169;
        v168.Size = UDim2.fromScale(v167, v167);
        TweenService:Create(Image, TweenInfo_new_ret4, v168):Play();
    end);
end;

local function refreshMaps() -- Line: 698
    -- upvalues: u11 (ref), u17 (copy), u13 (ref), getMapInfo (copy), setCardSelected (copy), u9 (ref)
    for _, v in ipairs(u11) do
        local v170 = u17[v.Name];

        if v170 then
            local Name = v.Name;
            local v171 = u13;
            local v172;

            if v171 then
                local v173 = getMapInfo(Name);

                if v173 then
                    v173 = v173.Gamemode;
                end;

                if typeof(v173) == "table" then
                    local v174 = v173[v171];

                    if v174 == nil then
                        v172 = false;
                    else
                        v172 = v174 ~= false;
                    end;
                else
                    v172 = false;
                end;
            else
                v172 = true;
            end;

            v170.Visible = v172;
            setCardSelected(v170, u9.NextMap == v.Name);
        end;
    end;
end;

local function buildMapEntries() -- Line: 708
    -- upvalues: u12 (ref), u26 (copy), u17 (copy), clearGenerated (copy), u35 (ref), u44 (ref), u11 (ref), bindCardHover (copy), bindPress (copy), Router (copy), u9 (ref), Remotes (copy), refreshMaps (copy)
    if not u12 then
        return;
    end;

    u26:Cleanup();
    table.clear(u17);
    clearGenerated(u35, u44, nil);

    for i, v in ipairs(u11) do
        local v175 = u44:Clone();
        v175.Name = v.Name;
        v175.LayoutOrder = i;
        v175.Visible = true;
        v175:FindFirstChild("Image", true).Image = v.Icon;
        v175:WaitForChild("MapName").Text = string.upper(v.Name);
        bindCardHover(u26, v175);
        bindPress(u26, v175, function() -- Line: 729
            -- upvalues: Router (ref), u9 (ref), v (copy), Remotes (ref), refreshMaps (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u9.NextMap = v.Name;
            Remotes.VIP.SetSetting.Send({
                Key = "NextMap",
                Value = v.Name
            });
            refreshMaps();
        end);
        v175.Parent = u35;
        u17[v.Name] = v175;
    end;

    refreshMaps();
end;

local function refreshModeCards() -- Line: 743
    -- upvalues: u9 (ref), u13 (ref), u7 (copy), u18 (copy), setCardSelected (copy)
    local v176;

    if typeof(u9.NextGamemode) == "string" then
        v176 = u9.NextGamemode;
    else
        v176 = u13;
    end;

    for _, v in ipairs(u7) do
        local v177 = u18[v.Name];

        if v177 then
            setCardSelected(v177, v176 == v.ServerGamemode);
        end;
    end;
end;

local function buildModeCards() -- Line: 754
    -- upvalues: u27 (copy), u18 (copy), clearGenerated (copy), u36 (ref), u45 (ref), u7 (copy), getGamemodeIcon (copy), bindCardHover (copy), bindPress (copy), Router (copy), u13 (ref), Remotes (copy), refreshModeCards (copy), showPanel (copy), refreshMaps (copy)
    u27:Cleanup();
    table.clear(u18);
    clearGenerated(u36, u45, nil);
    local v178 = u36:FindFirstChildOfClass("UIListLayout");
    local v179 = #u7;
    local v180 = (1 - (not v178 and 0 or v178.Padding.Scale) * (v179 - 1)) / v179;

    for i, v in ipairs(u7) do
        local v181 = u45:Clone();
        v181.Name = v.Name;
        v181.LayoutOrder = i;
        v181.Size = UDim2.fromScale(v180, 1);
        v181.Visible = true;
        local Mode = v181:WaitForChild("Mode");
        local Description = v181:WaitForChild("Description");
        local Image = v181:FindFirstChild("Image", true);
        Mode.Text = v.Mode;
        Description.Text = v.Description;
        Image.Image = v.Image or (getGamemodeIcon(v.ServerGamemode) or "");
        bindCardHover(u27, v181);
        bindPress(u27, v181, function() -- Line: 780
            -- upvalues: Router (ref), u13 (ref), v (copy), Remotes (ref), refreshModeCards (ref), showPanel (ref), refreshMaps (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u13 = v.ServerGamemode;
            Remotes.VIP.SetSetting.Send({
                Key = "NextGamemode",
                Value = v.ServerGamemode
            });
            refreshModeCards();
            showPanel("MapSelect", true);
            refreshMaps();
        end);
        v181.Parent = u36;
        u18[v.Name] = v181;
    end;

    refreshModeCards();
end;

local function renderPlayers() -- Line: 796
    -- upvalues: u28 (copy), clearGenerated (copy), u38 (ref), u46 (ref), u8 (copy), u16 (ref), u10 (ref), LocalPlayer (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy), u9 (ref), Color3_fromRGB_ret7 (copy), u22 (copy), bindHover (copy), u23 (copy), paintButton (copy), bindPress (copy), Router (copy), Remotes (copy), u37 (ref), updateRootPosition (copy)
    u28:Cleanup();
    clearGenerated(u38, u46, nil);
    local u182 = u8[u16];
    local v183 = 1;

    for _, v in ipairs(u10) do
        if u16 ~= "KickPlayer" or v.UserId ~= LocalPlayer.UserId then
            local u184 = u46:Clone();
            u184.Name = tostring(v.UserId);
            u184.LayoutOrder = v183;
            u184.Visible = true;
            v183 = v183 + 1;
            local Left = u184:WaitForChild("Left");
            local Avatar = Left:WaitForChild("Avatar");
            local Name = Left:WaitForChild("Name");
            local Bomb = Avatar:WaitForChild("Bomb");
            local State = u184:WaitForChild("Right"):WaitForChild("State");
            local Selected = u184:WaitForChild("Selected");
            Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={v.UserId}&w=150&h=150`;
            Name.Text = v.DisplayName;
            Bomb.Visible = v.Team == "Terrorists";

            local function setToggleModeVisual(p185: boolean) -- Line: 824
                -- upvalues: Selected (copy), State (copy), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret2 (ref)
                Selected.Visible = p185;
                State.Text = p185 and "ON" or "OFF";
                local v186;

                if p185 then
                    v186 = Color3_fromRGB_ret3;
                else
                    v186 = Color3_fromRGB_ret2;
                end;

                State.TextColor3 = v186;
            end;

            if u182 then
                local UserId = v.UserId;
                local v187 = u9[u182.Key];
                local v188;

                if typeof(v187) == "table" then
                    v188 = v187[tostring(UserId)] == true and true or v187[UserId] == true;
                else
                    v188 = false;
                end;

                Selected.Visible = v188;
                State.Text = v188 and "ON" or "OFF";
                local v189;

                if v188 then
                    v189 = Color3_fromRGB_ret3;
                else
                    v189 = Color3_fromRGB_ret2;
                end;

                State.TextColor3 = v189;
            else
                Selected.Visible = false;
                State.Text = "KICK";
                State.TextColor3 = Color3_fromRGB_ret7;
            end;

            u22[u184] = u22[u184] or u184.BackgroundColor3;
            bindHover(u28, u184, function(p190) -- Line: 289
                -- upvalues: u23 (ref), u184 (copy), paintButton (ref)
                u23[u184] = p190 and true or nil;
                paintButton(u184);
            end);
            bindPress(u28, u184, function() -- Line: 839
                -- upvalues: Router (ref), u182 (copy), v (copy), u9 (ref), Selected (copy), State (copy), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret2 (ref), Remotes (ref), u37 (ref), updateRootPosition (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if not u182 then
                    Selected.Visible = true;
                    Remotes.VIP.ExecuteAction.Send({
                        Action = "KickPlayer",
                        Params = v.UserId
                    });
                    u37.Visible = false;
                    updateRootPosition(true);

                    return;
                end;

                local UserId = v.UserId;
                local v191 = u9[u182.Key];
                local v192;

                if typeof(v191) == "table" then
                    v192 = v191[tostring(UserId)] == true and true or v191[UserId] == true;
                else
                    v192 = false;
                end;

                local v193 = not v192;
                local Key = u182.Key;
                local UserId2 = v.UserId;
                local v194 = u9[Key];

                if typeof(v194) ~= "table" then
                    v194 = {};
                    u9[Key] = v194;
                end;

                v194[UserId2] = nil;
                v194[tostring(UserId2)] = v193 and true or nil;
                Selected.Visible = v193;
                State.Text = v193 and "ON" or "OFF";
                local v195;

                if v193 then
                    v195 = Color3_fromRGB_ret3;
                else
                    v195 = Color3_fromRGB_ret2;
                end;

                State.TextColor3 = v195;
                Remotes.VIP.SetSetting.Send({
                    Key = u182.Key,
                    Value = v194
                });
            end);
            u184.Parent = u38;
        end;
    end;
end;

local function renderSettings() -- Line: 860
    -- upvalues: u25 (copy), clearGenerated (copy), u34 (ref), u41 (ref), u42 (ref), u43 (ref), u40 (ref), u19 (copy), u22 (copy), bindHover (copy), u23 (copy), paintButton (copy), bindPress (copy), Router (copy), setToggleSelector (copy), u3 (copy), u9 (ref), Remotes (copy), refreshBotControls (copy), u6 (copy), u4 (copy), isBotAutoFill (copy), areBotsFrozen (copy), u16 (ref), u8 (copy), renderPlayers (copy), u39 (ref), u37 (ref), slideIn (copy), updateRootPosition (copy), Color3_fromRGB_ret6 (copy)
    u25:Cleanup();
    clearGenerated(u34, u41, {
        InputTemplate = true,
        ClickTemplate = true,
        SectionTemplate = true
    });
    u42.Visible = false;
    u43.Visible = false;
    u40.Visible = false;
    table.clear(u19);
    local u196 = 0;

    local function createSection(p197: string, p198: string, p199: number) -- Line: 871
        -- upvalues: u196 (ref), u40 (ref), u34 (ref)
        u196 = u196 + 1;
        local math_ceil_ret = math.ceil(p199 / 2);
        local v200 = math_ceil_ret * 0.115 + (math_ceil_ret - 1) * 0.022;
        local v201 = v200 + 0.07;
        local v202 = u40:Clone();
        v202.Name = p197;
        v202.LayoutOrder = u196;
        v202.Size = UDim2.fromScale(1, v201);
        v202.Visible = true;
        local Label = v202:WaitForChild("Label");
        Label.Text = p198;
        Label.Size = UDim2.fromScale(1, 0.035 / v201);
        local Grid = v202:WaitForChild("Grid");
        Grid.Position = UDim2.fromScale(0, 0.07 / v201);
        Grid.Size = UDim2.fromScale(1, v200 / v201);
        local v203 = Grid:FindFirstChildOfClass("UIGridLayout");
        v203.CellSize = UDim2.fromScale(0.492, 0.115 / v200);
        v203.CellPadding = UDim2.fromScale(0.016, 0.022 / v200);
        v202.Parent = u34;

        return Grid;
    end;

    local function createRow(p204: userdata, p205: userdata, p206: string, p207: string) -- Line: 898
        local v208 = p204:Clone();
        v208.Name = p206;
        v208.LayoutOrder = #p205:GetChildren();
        v208.Visible = true;
        v208:WaitForChild("Left"):WaitForChild("Label").Text = p207;
        v208.Parent = p205;

        return v208;
    end;

    local function createSelector(p209: userdata, p210: string, p211: string, u212: function, u213: function, u214: function?) -- Line: 910
        -- upvalues: u41 (ref), u25 (ref), u22 (ref), bindHover (ref), u23 (ref), paintButton (ref), bindPress (ref), Router (ref), u19 (ref)
        local v215 = u41:Clone();
        v215.Name = p210;
        v215.LayoutOrder = #p209:GetChildren();
        v215.Visible = true;
        v215:WaitForChild("Left"):WaitForChild("Label").Text = p211;
        v215.Parent = p209;
        local Switch = v215:WaitForChild("Right"):WaitForChild("Switch");
        local Selection = Switch:WaitForChild("Selection");
        local v216 = {
            Row = v215,
            Title = Selection:WaitForChild("Title"),
            Bar = Selection:WaitForChild("Frame"),
            Decrease = Switch:WaitForChild("Left"),
            Increase = Switch:WaitForChild("Right")
        };
        Switch.AutoButtonColor = false;
        u22[Switch] = u22[Switch] or Switch.BackgroundColor3;
        bindHover(u25, Switch, function(p217) -- Line: 289
            -- upvalues: u23 (ref), Switch (copy), paintButton (ref)
            u23[Switch] = p217 and true or nil;
            paintButton(Switch);
        end);

        local function step(u218: userdata, u219: function) -- Line: 931
            -- upvalues: bindPress (ref), u25 (ref), Router (ref)
            bindPress(u25, u218, function() -- Line: 932
                -- upvalues: u218 (copy), Router (ref), u219 (copy)
                if u218:GetAttribute("Enabled") ~= false then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u219();
                end;
            end);
        end;

        local Decrease = v216.Decrease;
        bindPress(u25, Decrease, function() -- Line: 932
            -- upvalues: Decrease (copy), Router (ref), u212 (copy)
            if Decrease:GetAttribute("Enabled") ~= false then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u212();
            end;
        end);
        local Increase = v216.Increase;
        bindPress(u25, Increase, function() -- Line: 932
            -- upvalues: Increase (copy), Router (ref), u213 (copy)
            if Increase:GetAttribute("Enabled") ~= false then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u213();
            end;
        end);

        if u214 then
            local u220 = false;

            local function markArrow() -- Line: 945
                -- upvalues: u220 (ref)
                u220 = true;
                task.defer(function() -- Line: 947
                    -- upvalues: u220 (ref)
                    u220 = false;
                end);
            end;

            u25:Add(v216.Decrease.MouseButton1Down:Connect(markArrow));
            u25:Add(v216.Increase.MouseButton1Down:Connect(markArrow));
            bindPress(u25, Switch, function() -- Line: 953
                -- upvalues: u220 (ref), Router (ref), u214 (copy)
                if not u220 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u214();
                end;
            end);
        end;

        u19[p210] = v216;

        return v216;
    end;

    local function createToggle(p221: userdata, p222: string, p223: string, u224: function, u225: function) -- Line: 965
        -- upvalues: setToggleSelector (ref), createSelector (copy)
        local u226 = nil;

        local function set(p227: boolean) -- Line: 973
            -- upvalues: u224 (copy), u225 (copy), setToggleSelector (ref), u226 (ref)
            if p227 == u224() then
                return;
            end;

            u225(p227);
            setToggleSelector(u226, p227);
        end;

        u226 = createSelector(p221, p222, p223, function() -- Line: 980
            -- upvalues: u224 (copy), u225 (copy), setToggleSelector (ref), u226 (ref)
            if u224() == false then
                return;
            end;

            u225(false);
            setToggleSelector(u226, false);
        end, function() -- Line: 982
            -- upvalues: u224 (copy), u225 (copy), setToggleSelector (ref), u226 (ref)
            if u224() == true then
                return;
            end;

            u225(true);
            setToggleSelector(u226, true);
        end, function() -- Line: 984
            -- upvalues: u224 (copy), u225 (copy), setToggleSelector (ref), u226 (ref)
            local v228 = not u224();

            if v228 == u224() then
                return;
            end;

            u225(v228);
            setToggleSelector(u226, v228);
        end);
        setToggleSelector(u226, u224());
    end;

    local v229 = createSection("MatchRules", "MATCH RULES", #u3 + 1);

    for _, v in ipairs(u3) do
        createToggle(v229, v.Name, v.Label, function() -- Line: 993
            -- upvalues: u9 (ref), v (copy)
            return u9[v.Key] == true;
        end, function(p230) -- Line: 995
            -- upvalues: u9 (ref), v (copy), Remotes (ref)
            u9[v.Key] = p230;
            Remotes.VIP.SetSetting.Send({
                Key = v.Key,
                Value = p230
            });
        end);
    end;

    local v231 = u42:Clone();
    v231.Name = "SetTimer";
    v231.LayoutOrder = #v229:GetChildren();
    v231.Visible = true;
    v231:WaitForChild("Left"):WaitForChild("Label").Text = "Set Timer";
    v231.Parent = v229;
    local u232 = v231:FindFirstChildWhichIsA("TextBox", true);
    u232.Text = "";
    u25:Add(u232.FocusLost:Connect(function() -- Line: 1005
        -- upvalues: u232 (copy), Remotes (ref)
        local v233 = tonumber(u232.Text);

        if not v233 then
            u232.Text = "";

            return;
        end;

        local Send = Remotes.VIP.ExecuteAction.Send;
        local v234 = {
            Action = "SetTimer"
        };
        local math_floor_ret = math.floor(v233);
        v234.Params = math.clamp(math_floor_ret, 0, 9999);
        Send(v234);
        u232.Text = "";
    end));
    local v235 = createSection("Bots", "BOTS", 5);

    local function changeBotCount(p236: table, p237: number) -- Line: 1019
        -- upvalues: u9 (ref), refreshBotControls (ref), Remotes (ref)
        local v238 = u9[p236.Key];
        local v239 = (typeof(v238) ~= "number" and 0 or v238) + p237;

        if v239 >= 0 then
            local v240 = u9[p236.OtherKey];

            if v239 + (typeof(v240) ~= "number" and 0 or v240) <= 14 then
                u9[p236.Key] = v239;
                u9.BotAutoFill = false;
                refreshBotControls();
                Remotes.VIP.SetSetting.Send({
                    Key = p236.Key,
                    Value = v239
                });
            end;
        end;
    end;

    for _, v in ipairs(u6) do
        createSelector(v235, v.Name, v.Label, function() -- Line: 1031
            -- upvalues: changeBotCount (copy), v (copy)
            changeBotCount(v, -1);
        end, function() -- Line: 1033
            -- upvalues: changeBotCount (copy), v (copy)
            changeBotCount(v, 1);
        end);
    end;

    local function shiftBotDifficulty(p241: number) -- Line: 1038
        -- upvalues: u4 (ref), u9 (ref), refreshBotControls (ref), Remotes (ref)
        local table_find = table.find;
        local BotDifficulty = u9.BotDifficulty;

        if not table.find(u4, BotDifficulty) then
            BotDifficulty = u4[1];
        end;

        local v242 = table_find(u4, BotDifficulty);
        local v243 = u4[math.clamp(v242 + p241, 1, #u4)];
        u9.BotDifficulty = v243;
        refreshBotControls();
        Remotes.VIP.SetSetting.Send({
            Key = "BotDifficulty",
            Value = v243
        });
    end;

    createSelector(v235, "BotDifficulty", "Bot Difficulty", function() -- Line: 1045
        -- upvalues: shiftBotDifficulty (copy)
        shiftBotDifficulty(-1);
    end, function() -- Line: 1047
        -- upvalues: shiftBotDifficulty (copy)
        shiftBotDifficulty(1);
    end);
    createToggle(v235, "BotAutoFill", "Auto Fill Bots", isBotAutoFill, function(p244) -- Line: 1051
        -- upvalues: u9 (ref), refreshBotControls (ref), Remotes (ref)
        u9.BotAutoFill = p244;
        refreshBotControls();
        Remotes.VIP.SetSetting.Send({
            Key = "BotAutoFill",
            Value = p244
        });
    end);
    createToggle(v235, "BotsFrozen", "Freeze Bots", areBotsFrozen, function(p245) -- Line: 1057
        -- upvalues: u9 (ref), Remotes (ref)
        u9.BotsFrozen = p245;
        Remotes.VIP.SetSetting.Send({
            Key = "BotsFrozen",
            Value = p245
        });
    end);

    local function openPlayers(p246: string) -- Line: 1063
        -- upvalues: u16 (ref), u8 (ref), Remotes (ref), renderPlayers (ref), u39 (ref), u37 (ref), slideIn (ref), updateRootPosition (ref)
        u16 = p246;

        if u8[p246] then
            Remotes.VIP.RequestData.Send("State");
        end;

        Remotes.VIP.RequestData.Send("PlayerList");
        renderPlayers();

        if u39 then
            local v247 = u8[u16];
            u39.Text = string.upper(not v247 and "Kick Player" or v247.Title);
        end;

        if not u37.Visible then
            u37.Visible = true;
            slideIn(u37, UDim2.fromOffset(-40, 0));
        end;

        updateRootPosition(true);
    end;

    local v251 = {
        {
            Name = "GodMode",
            Label = "God Mode",
            Button = "PLAYERS",

            Callback = function() -- Line: 1078, Name: Callback
                -- upvalues: u16 (ref), u8 (ref), Remotes (ref), renderPlayers (ref), u39 (ref), u37 (ref), slideIn (ref), updateRootPosition (ref)
                u16 = "GodMode";

                if u8.GodMode then
                    Remotes.VIP.RequestData.Send("State");
                end;

                Remotes.VIP.RequestData.Send("PlayerList");
                renderPlayers();

                if u39 then
                    local v248 = u8[u16];
                    u39.Text = string.upper(not v248 and "Kick Player" or v248.Title);
                end;

                if not u37.Visible then
                    u37.Visible = true;
                    slideIn(u37, UDim2.fromOffset(-40, 0));
                end;

                updateRootPosition(true);
            end
        },
        {
            Name = "ESP",
            Label = "ESP",
            Button = "PLAYERS",

            Callback = function() -- Line: 1086, Name: Callback
                -- upvalues: u16 (ref), u8 (ref), Remotes (ref), renderPlayers (ref), u39 (ref), u37 (ref), slideIn (ref), updateRootPosition (ref)
                u16 = "ESP";

                if u8.ESP then
                    Remotes.VIP.RequestData.Send("State");
                end;

                Remotes.VIP.RequestData.Send("PlayerList");
                renderPlayers();

                if u39 then
                    local v249 = u8[u16];
                    u39.Text = string.upper(not v249 and "Kick Player" or v249.Title);
                end;

                if not u37.Visible then
                    u37.Visible = true;
                    slideIn(u37, UDim2.fromOffset(-40, 0));
                end;

                updateRootPosition(true);
            end
        },
        {
            Name = "KickPlayer",
            Label = "Kick Player",
            Button = "PLAYERS",

            Callback = function() -- Line: 1094, Name: Callback
                -- upvalues: u16 (ref), u8 (ref), Remotes (ref), renderPlayers (ref), u39 (ref), u37 (ref), slideIn (ref), updateRootPosition (ref)
                u16 = "KickPlayer";

                if u8.KickPlayer then
                    Remotes.VIP.RequestData.Send("State");
                end;

                Remotes.VIP.RequestData.Send("PlayerList");
                renderPlayers();

                if u39 then
                    local v250 = u8[u16];
                    u39.Text = string.upper(not v250 and "Kick Player" or v250.Title);
                end;

                if not u37.Visible then
                    u37.Visible = true;
                    slideIn(u37, UDim2.fromOffset(-40, 0));
                end;

                updateRootPosition(true);
            end
        },
        {
            Name = "ResetScore",
            Label = "Reset Score",
            Button = "RESET",

            Callback = function() -- Line: 1102, Name: Callback
                -- upvalues: Remotes (ref)
                Remotes.VIP.ExecuteAction.Send({
                    Action = "ResetScore",
                    Params = nil
                });
            end
        },
        {
            Name = "EndGame",
            Label = "End Current Game",
            Button = "END GAME",
            Danger = true,

            Callback = function() -- Line: 1111, Name: Callback
                -- upvalues: Remotes (ref)
                Remotes.VIP.ExecuteAction.Send({
                    Action = "EndGame",
                    Params = nil
                });
            end
        }
    };
    local v252 = createSection("Actions", "SERVER ACTIONS", #v251);

    for _, v in ipairs(v251) do
        local Name = v.Name;
        local Label = v.Label;
        local v253 = u43:Clone();
        v253.Name = Name;
        v253.LayoutOrder = #v252:GetChildren();
        v253.Visible = true;
        v253:WaitForChild("Left"):WaitForChild("Label").Text = Label;
        v253.Parent = v252;
        local Action = v253:FindFirstChild("Action", true);
        Action:WaitForChild("Title").Text = v.Button;

        if v.Danger then
            Action.BackgroundColor3 = Color3_fromRGB_ret6;
        end;

        u22[Action] = u22[Action] or Action.BackgroundColor3;
        bindHover(u25, Action, function(p254) -- Line: 289
            -- upvalues: u23 (ref), Action (copy), paintButton (ref)
            u23[Action] = p254 and true or nil;
            paintButton(Action);
        end);
        bindPress(u25, Action, function() -- Line: 1128
            -- upvalues: Router (ref), v (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            v.Callback();
        end);
    end;

    refreshBotControls();
end;

local function setupTabs() -- Line: 1140
    -- upvalues: u33 (ref), u24 (copy), u22 (copy), bindHover (copy), u23 (copy), paintButton (copy), bindPress (copy), u15 (ref), Router (copy), u13 (ref), refreshMaps (copy), refreshModeCards (copy), updateToggleIndicators (copy), showPanel (copy)
    for i, v in pairs(u33) do
        u22[v] = u22[v] or v.BackgroundColor3;
        bindHover(u24, v, function(p255) -- Line: 289
            -- upvalues: u23 (ref), v (copy), paintButton (ref)
            u23[v] = p255 and true or nil;
            paintButton(v);
        end);
        bindPress(u24, v, function() -- Line: 1143
            -- upvalues: u15 (ref), i (copy), Router (ref), u13 (ref), refreshMaps (ref), refreshModeCards (ref), updateToggleIndicators (ref), showPanel (ref)
            if u15 == i then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if i == "MapSelect" then
                u13 = nil;
                refreshMaps();
            elseif i == "ModeSelect" then
                refreshModeCards();
            else
                updateToggleIndicators();
            end;

            showPanel(i, true);
        end);
    end;
end;

local function setupCloseButtons() -- Line: 1162
    -- upvalues: u37 (ref), u24 (copy), u22 (copy), bindHover (copy), u23 (copy), paintButton (copy), bindPress (copy), Router (copy), updateRootPosition (copy), u29 (ref), u1 (copy), CloseButtonRegistry (copy)
    local Close = u37:WaitForChild("Header"):FindFirstChild("Close");

    if Close and Close:IsA("GuiButton") then
        u22[Close] = u22[Close] or Close.BackgroundColor3;
        bindHover(u24, Close, function(p256) -- Line: 289
            -- upvalues: u23 (ref), Close (copy), paintButton (ref)
            u23[Close] = p256 and true or nil;
            paintButton(Close);
        end);
        bindPress(u24, Close, function() -- Line: 1166
            -- upvalues: Router (ref), u37 (ref), updateRootPosition (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u37.Visible = false;
            updateRootPosition(true);
        end);
    end;

    local Close2 = u29:WaitForChild("Close");

    if Close2 and Close2:IsA("GuiButton") then
        u22[Close2] = u22[Close2] or Close2.BackgroundColor3;
        bindHover(u24, Close2, function(p257) -- Line: 289
            -- upvalues: u23 (ref), Close2 (copy), paintButton (ref)
            u23[Close2] = p257 and true or nil;
            paintButton(Close2);
        end);
        bindPress(u24, Close2, function() -- Line: 1175
            -- upvalues: Router (ref), u1 (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.closeFrame();
        end);
    end;

    CloseButtonRegistry.Add(u29, nil, function() -- Line: 1182
        -- upvalues: u37 (ref), updateRootPosition (ref), u1 (ref)
        if not u37.Visible then
            u1.closeFrame();

            return;
        end;

        u37.Visible = false;
        updateRootPosition(true);
    end);
end;

function u1.openFrame() -- Line: 1194
    -- upvalues: u2 (copy), LocalPlayer (copy), u29 (ref), EndScreenController (copy), MenuState (copy), isTeamSelectionVisible (copy), u20 (ref), CameraController (copy), u21 (ref), u37 (ref), showPanel (copy), u15 (ref), u30 (ref), TweenInfo_new_ret2 (copy), TweenService (copy), u31 (ref), u32 (ref), Remotes (copy), refreshMaps (copy), refreshModeCards (copy)
    if (u2 or LocalPlayer:GetAttribute("CanUseVIPMenu") == true) and (u29 and not (EndScreenController.IsActive() or (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive()))) then
        local Attribute = LocalPlayer:GetAttribute("Team");

        if Attribute == "Counter-Terrorists" and true or Attribute == "Terrorists" or LocalPlayer:GetAttribute("IsSpectating") == true then
            local v258 = u29 and u29.Parent;

            if v258 then
                v258 = v258.Parent;
            end;

            if v258 then
                v258 = v258.Parent;
            end;

            if not (v258 and v258:IsA("ScreenGui")) then
                v258 = nil;
            end;

            local v259;

            if v258 then
                local Menu = v258:FindFirstChild("Menu");

                if Menu == nil then
                    v259 = false;
                else
                    v259 = Menu:IsA("GuiObject") and Menu.Visible;
                end;
            else
                v259 = false;
            end;

            if not (v259 or (isTeamSelectionVisible() or u20)) then
                CameraController.setForceLockOverride("VIPMenu", true);

                if LocalPlayer:GetAttribute("IsSpectating") ~= true then
                    local Character = LocalPlayer.Character;
                    local v260;

                    if Character == nil then
                        v260 = false;
                    else
                        v260 = Character:IsDescendantOf(workspace);
                    end;

                    if v260 then
                        CameraController.setPerspective(true, true);
                    end;
                end;

                if u21 then
                    u21:Cancel();
                    u21 = nil;
                end;

                u20 = true;
                u29.Visible = true;
                u37.Visible = false;
                u29.Position = UDim2.new(0.5, not u37.Visible and 0 or -(u37.AbsoluteSize.X + u29.AbsoluteSize.X * 0.02) / 2, 0.5, 0);
                showPanel(u15, true);
                u30.Scale = 0.94;
                TweenService:Create(u30, TweenInfo_new_ret2, {
                    Scale = 1
                }):Play();

                if u31 then
                    u31.BackgroundTransparency = 1;
                    TweenService:Create(u31, TweenInfo_new_ret2, {
                        BackgroundTransparency = u32
                    }):Play();
                end;

                Remotes.VIP.RequestData.Send("State");
                Remotes.VIP.RequestData.Send("PlayerList");
                refreshMaps();
                refreshModeCards();
            end;
        end;
    end;
end;

function u1.closeFrame() -- Line: 1236
    -- upvalues: u29 (ref), CameraController (copy), LocalPlayer (copy), u20 (ref), u30 (ref), TweenInfo_new_ret3 (copy), TweenService (copy), u31 (ref), u21 (ref)
    if not u29 then
        return;
    end;

    CameraController.setForceLockOverride("VIPMenu", false);

    if LocalPlayer:GetAttribute("IsSpectating") ~= true then
        local Character = LocalPlayer.Character;
        local v261;

        if Character == nil then
            v261 = false;
        else
            v261 = Character:IsDescendantOf(workspace);
        end;

        if v261 then
            CameraController.setPerspective(true, false);
        end;
    end;

    if not u20 then
        return;
    end;

    u20 = false;
    local u262 = TweenService:Create(u30, TweenInfo_new_ret3, {
        Scale = 0.94
    });
    u262:Play();

    if u31 then
        TweenService:Create(u31, TweenInfo_new_ret3, {
            BackgroundTransparency = 1
        }):Play();
    end;

    u21 = u262;
    u262.Completed:Connect(function(p263) -- Line: 1256
        -- upvalues: u21 (ref), u262 (copy), u29 (ref)
        if p263 == Enum.PlaybackState.Completed and u21 == u262 then
            u21 = nil;
            u29.Visible = false;
        end;
    end);
end;

function u1.toggleFrame() -- Line: 1264
    -- upvalues: u29 (ref), u20 (ref), u1 (copy)
    if not u29 then
        return;
    end;

    if u20 then
        u1.closeFrame();

        return;
    end;

    u1.openFrame();
end;

function u1.Initialize(p264: userdata, p265: userdata) -- Line: 1279
    -- upvalues: u29 (ref), u30 (ref), u31 (ref), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u42 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), loadAvailableMaps (copy), u15 (ref), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret5 (copy), u22 (copy), paintButton (copy), renderSettings (copy), buildModeCards (copy), buildMapEntries (copy), u24 (copy), u20 (ref), CameraController (copy), u9 (ref), updateToggleIndicators (copy), refreshMaps (copy), refreshModeCards (copy), renderPlayers (copy), Remotes (copy), u10 (ref)
    u29 = p265;
    local v266 = p265:FindFirstChildOfClass("UIScale");

    if not v266 then
        v266 = Instance.new("UIScale");
        v266.Parent = p265;
    end;

    u30 = v266;
    u31 = p265:FindFirstChild("Backdrop");

    if u31 then
        u32 = u31.BackgroundTransparency;
    end;

    local Frame = p265:WaitForChild("Frame");
    u33 = {
        Settings = Frame:WaitForChild("Settings"),
        MapSelect = Frame:WaitForChild("MapSelect"),
        ModeSelect = Frame:WaitForChild("ModeSelect")
    };
    u34 = p265:WaitForChild("ScrollingFrame");
    u35 = p265:WaitForChild("SelectMap");
    u36 = p265:WaitForChild("SelectMode");
    u37 = p265:WaitForChild("VoteKick");
    u38 = u37:WaitForChild("Container");
    u39 = u37:WaitForChild("Header"):WaitForChild("Title");
    u40 = u34:WaitForChild("SectionTemplate");
    u41 = u34:WaitForChild("ToggleTemplate");
    u42 = u34:WaitForChild("InputTemplate");
    u43 = u34:WaitForChild("ClickTemplate");
    u44 = u35:WaitForChild("Template");
    u45 = u36:WaitForChild("Template");
    u46 = u38:WaitForChild("Template");
    loadAvailableMaps();
    u29.Visible = false;
    u37.Visible = false;
    u15 = "Settings";
    u34.Visible = true;
    u35.Visible = false;
    u36.Visible = false;

    for i, v in pairs(u33) do
        local v267 = i == "Settings";
        local v268;

        if v267 then
            v268 = Color3_fromRGB_ret4;
        else
            v268 = Color3_fromRGB_ret5;
        end;

        u22[v] = v268;
        paintButton(v);
        local Selected = v:FindFirstChild("Selected");

        if Selected and Selected:IsA("GuiObject") then
            Selected.Visible = v267;
        end;
    end;

    renderSettings();
    buildModeCards();
    buildMapEntries();
    u24:Add(u29:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1315
        -- upvalues: u29 (ref), u20 (ref), CameraController (ref)
        if u29.Visible then
            return;
        end;

        u20 = false;
        CameraController.setForceLockOverride("VIPMenu", false);
    end));
    u24:Add(Remotes.VIP.SyncState.Listen(function(p269) -- Line: 1326, Name: applyState
        -- upvalues: u9 (ref), u29 (ref), updateToggleIndicators (ref), refreshMaps (ref), refreshModeCards (ref), u37 (ref), renderPlayers (ref)
        u9 = p269;

        if not u29.Visible then
            return;
        end;

        updateToggleIndicators();
        refreshMaps();
        refreshModeCards();

        if u37.Visible then
            renderPlayers();
        end;
    end));
    u24:Add(Remotes.VIP.DataResponse.Listen(function(p270) -- Line: 1341
        -- upvalues: u9 (ref), u29 (ref), updateToggleIndicators (ref), refreshMaps (ref), refreshModeCards (ref), u37 (ref), renderPlayers (ref), u10 (ref)
        if p270.Type == "State" then
            u9 = p270.Data;

            if not u29.Visible then
                return;
            end;

            updateToggleIndicators();
            refreshMaps();
            refreshModeCards();

            if u37.Visible then
                renderPlayers();
            end;
        elseif p270.Type == "PlayerList" then
            u10 = p270.Data;

            if u29.Visible and u37.Visible then
                renderPlayers();
            end;
        end;
    end));
end;

function u1.Start() -- Line: 1353
    -- upvalues: setupTabs (copy), setupCloseButtons (copy), updateToggleIndicators (copy)
    setupTabs();
    setupCloseButtons();
    updateToggleIndicators();
end;

return u1;