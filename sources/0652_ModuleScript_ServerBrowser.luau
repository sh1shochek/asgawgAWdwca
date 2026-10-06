-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local ServerBrowser = require(ReplicatedStorage.Database.Components.ServerBrowser);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps;
local ServerTemplate = ReplicatedStorage.Assets.UI.ServerBrowser.ServerTemplate;
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Color3_fromRGB_ret = Color3.fromRGB(120, 255, 127);
local table_freeze_ret = table.freeze({
    Transparency = 0.25,
    BlurRadius = UDim.new(0, 14),
    Spread = UDim2.fromOffset(6, 6)
});
local table_freeze_ret2 = table.freeze({
    Transparency = 1,
    BlurRadius = UDim.new(0, 0),
    Spread = UDim2.fromOffset(0, 0)
});
local table_freeze_ret3 = table.freeze({ "Map", "Players", "Score", "Region", "ServerUptime", "ServerId" });
local table_freeze_ret4 = table.freeze({
    casual = "CASUAL",
    competitive = "COMPETITIVE",
    deathmatch = "DEATHMATCH",
    trading = "TRADING"
});
local u2 = nil;
local u3 = "";
local u4 = false;
local u5 = nil;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = false;
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;

local function CommaNumber(p20: number) -- Line: 89
    local math_floor_ret = math.floor(p20);
    local math_max_ret = math.max(math_floor_ret, 0);

    return tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function GetGamemodeLabel(p21) -- Line: 97
    -- upvalues: table_freeze_ret4 (copy)
    return table_freeze_ret4[p21.GameMode] or string.upper((tostring(p21.GameMode)));
end;

local function GetMapName(p22) -- Line: 103
    local GameModeData = p22.GameModeData;

    return GameModeData and GameModeData.MapName or "";
end;

local function GetMapIcon(p23: string) -- Line: 110
    -- upvalues: u14 (copy), Maps (copy)
    if p23 == "" then
        return nil;
    end;

    local v24 = u14[p23];

    if v24 then
        return v24;
    end;

    local v25 = Maps:FindFirstChild(p23);
    local v26 = nil;

    if v25 and v25:IsA("ModuleScript") then
        local success, result = pcall(require, v25);

        if success and typeof(result) == "table" then
            v26 = result.Icon;
        end;
    end;

    if v26 then
        u14[p23] = v26;
    end;

    return v26;
end;

local function FormatScore(p27) -- Line: 139
    local GameModeData = p27.GameModeData;

    if GameModeData then
        GameModeData = GameModeData.Scores;
    end;

    return not GameModeData and "--" or `<font color="rgb(219,199,126)">{GameModeData.T or 0}</font> - <font color="rgb(165,183,212)">{GameModeData.CT or 0}</font>`;
end;

local function FormatUptime(p28: string?) -- Line: 153
    if not p28 or p28 == "" then
        return "--";
    end;

    local success, result = pcall(DateTime.fromIsoDate, p28);

    if not (success and result) then
        return "--";
    end;

    local v29 = DateTime.now().UnixTimestamp - result.UnixTimestamp;
    local math_max_ret = math.max(v29, 0);

    return string.format("%02d:%02d:%02d", math_max_ret // 3600, math_max_ret % 3600 // 60, math_max_ret % 60);
end;

local function GetFriendInServer(p30) -- Line: 169
    -- upvalues: u12 (copy)
    for _, v in p30.Players do
        local v31 = u12[v.UserId];

        if v31 then
            return v31;
        end;
    end;

    return nil;
end;

local function IsCategorySelected(p32: string, p33: string) -- Line: 183
    -- upvalues: u5 (ref)
    local v34 = u5 and u5[p32];

    if not v34 then
        return true;
    end;

    local string_lower_ret = string.lower(p33);

    for _, v in v34 do
        if string.lower(v) == string_lower_ret then
            return true;
        end;
    end;

    return false;
end;

local function MatchesFilters(p35) -- Line: 200
    -- upvalues: IsCategorySelected (copy), u4 (ref), u12 (copy), u3 (ref), ServerBrowser (copy), table_freeze_ret4 (copy)
    if not IsCategorySelected("gameModes", (tostring(p35.GameMode))) then
        return false;
    end;

    local GameModeData = p35.GameModeData;
    local v36 = GameModeData and GameModeData.MapName or "";

    if v36 ~= "" and not IsCategorySelected("maps", v36) then
        return false;
    end;

    local v37, v38, v39, v40, v41, v42;

    if not u4 then
        if u3 == "" then
            return true;
        end;

        v37 = string.lower;
        v38 = table.concat;
        v39 = {};
        v40 = ServerBrowser.GetServerNameFromMatchId(p35.MatchId);
        v41 = p35.GameModeData;
        v39[1], v39[2], v39[3], v39[4] = v40, v41 and v41.MapName or "", p35.Region or "", table_freeze_ret4[p35.GameMode] or string.upper((tostring(p35.GameMode)));
        v42 = v37(v38(v39, " "));

        return string.find(v42, u3, 1, true) ~= nil;
    end;

    local v43;

    for _, v in p35.Players do
        v43 = u12[v.UserId];

        if v43 then
            break;
        end;
    end;

    if not v43 then
        return false;
    end;

    if u3 == "" then
        return true;
    end;

    v37 = string.lower;
    v38 = table.concat;
    v39 = {};
    v40 = ServerBrowser.GetServerNameFromMatchId(p35.MatchId);
    v41 = p35.GameModeData;
    v39[1], v39[2], v39[3], v39[4] = v40, v41 and v41.MapName or "", p35.Region or "", table_freeze_ret4[p35.GameMode] or string.upper((tostring(p35.GameMode)));
    v42 = v37(v38(v39, " "));

    return string.find(v42, u3, 1, true) ~= nil;
end;

local function RequestTeleport(p44: string) -- Line: 230
    -- upvalues: u6 (ref), Remotes (copy)
    local os_clock_ret = os.clock();

    if os_clock_ret - u6 < 1.1 then
        return;
    end;

    u6 = os_clock_ret;
    Remotes.ServerBrowser.Teleport.Send(p44);
end;

local function SetDetailValue(p45: string, p46: string) -- Line: 242
    -- upvalues: u11 (copy)
    local v47 = u11[p45];

    if v47 then
        v47.Text = p46;
    end;
end;

local function RefreshFriendTag(p48) -- Line: 251
    -- upvalues: u17 (ref), u12 (copy), u7 (ref), u13 (copy), Players (copy)
    local FriendTag = u17.FriendTag;
    local u49 = nil;

    for _, v in p48.Players do
        if u12[v.UserId] then
            u49 = v;
            break;
        end;
    end;

    u7 = u7 + 1;
    local u50 = u7;

    if not u49 then
        FriendTag.Visible = false;

        return;
    end;

    FriendTag.Visible = true;
    FriendTag.Username.Text = `{u49.Username} in Server`;
    local Avatar = FriendTag.Player.Avatar;
    local v51 = u13[u49.UserId];

    if v51 then
        Avatar.Image = v51;

        return;
    end;

    Avatar.Image = "";
    task.spawn(function() -- Line: 282
        -- upvalues: Players (ref), u49 (ref), u13 (ref), u50 (copy), u7 (ref), Avatar (copy)
        local success, result = pcall(Players.GetUserThumbnailAsync, Players, u49.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);

        if not (success and result) then
            return;
        end;

        u13[u49.UserId] = result;

        if u50 == u7 then
            Avatar.Image = result;
        end;
    end);
end;

local function GetSelectionShadow(p52: userdata) -- Line: 304
    -- upvalues: Color3_fromRGB_ret (copy), table_freeze_ret2 (copy)
    local SelectionShadow = p52:FindFirstChild("SelectionShadow");

    if SelectionShadow and SelectionShadow:IsA("UIShadow") then
        return SelectionShadow;
    end;

    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "SelectionShadow";
    UIShadow.Color = Color3_fromRGB_ret;
    UIShadow.Transparency = table_freeze_ret2.Transparency;
    UIShadow.BlurRadius = table_freeze_ret2.BlurRadius;
    UIShadow.Spread = table_freeze_ret2.Spread;
    UIShadow.Parent = p52;

    return UIShadow;
end;

local function TweenRowSelection(p53: userdata, p54: boolean) -- Line: 322
    -- upvalues: TweenService (copy), Color3_fromRGB_ret (copy), table_freeze_ret2 (copy), TweenInfo_new_ret (copy), table_freeze_ret (copy)
    local SelectionShadow = p53:FindFirstChild("SelectionShadow");

    if not (SelectionShadow and SelectionShadow:IsA("UIShadow")) then
        SelectionShadow = Instance.new("UIShadow");
        SelectionShadow.Name = "SelectionShadow";
        SelectionShadow.Color = Color3_fromRGB_ret;
        SelectionShadow.Transparency = table_freeze_ret2.Transparency;
        SelectionShadow.BlurRadius = table_freeze_ret2.BlurRadius;
        SelectionShadow.Spread = table_freeze_ret2.Spread;
        SelectionShadow.Parent = p53;
    end;

    local v55;

    if p54 then
        v55 = table_freeze_ret;
    else
        v55 = table_freeze_ret2;
    end;

    TweenService:Create(SelectionShadow, TweenInfo_new_ret, v55):Play();
end;

local function ClearSelection() -- Line: 332
    -- upvalues: u2 (ref), u17 (ref), u10 (copy), TweenService (copy), Color3_fromRGB_ret (copy), table_freeze_ret2 (copy), TweenInfo_new_ret (copy)
    u2 = nil;
    u17.Visible = false;

    for _, v in u10 do
        local SelectionShadow = v:FindFirstChild("SelectionShadow");

        if not (SelectionShadow and SelectionShadow:IsA("UIShadow")) then
            SelectionShadow = Instance.new("UIShadow");
            SelectionShadow.Name = "SelectionShadow";
            SelectionShadow.Color = Color3_fromRGB_ret;
            SelectionShadow.Transparency = table_freeze_ret2.Transparency;
            SelectionShadow.BlurRadius = table_freeze_ret2.BlurRadius;
            SelectionShadow.Spread = table_freeze_ret2.Spread;
            SelectionShadow.Parent = v;
        end;

        TweenService:Create(SelectionShadow, TweenInfo_new_ret, table_freeze_ret2):Play();
    end;
end;

local function RefreshDetails() -- Line: 342
    -- upvalues: u2 (ref), u17 (ref), ServerBrowser (copy), u10 (copy), TweenService (copy), Color3_fromRGB_ret (copy), table_freeze_ret2 (copy), TweenInfo_new_ret (copy), table_freeze_ret4 (copy), GetMapIcon (copy), u11 (copy), FormatUptime (copy), RefreshFriendTag (copy)
    if not u2 then
        u17.Visible = false;

        return;
    end;

    local ServerByMatchId = ServerBrowser.GetServerByMatchId(u2);

    if not ServerByMatchId then
        u2 = nil;
        u17.Visible = false;

        for _, v in u10 do
            local SelectionShadow = v:FindFirstChild("SelectionShadow");

            if not (SelectionShadow and SelectionShadow:IsA("UIShadow")) then
                SelectionShadow = Instance.new("UIShadow");
                SelectionShadow.Name = "SelectionShadow";
                SelectionShadow.Color = Color3_fromRGB_ret;
                SelectionShadow.Transparency = table_freeze_ret2.Transparency;
                SelectionShadow.BlurRadius = table_freeze_ret2.BlurRadius;
                SelectionShadow.Spread = table_freeze_ret2.Spread;
                SelectionShadow.Parent = v;
            end;

            TweenService:Create(SelectionShadow, TweenInfo_new_ret, table_freeze_ret2):Play();
        end;

        return;
    end;

    local GameModeData = ServerByMatchId.GameModeData;
    local v56 = GameModeData and GameModeData.MapName or "";
    local v57 = table_freeze_ret4[ServerByMatchId.GameMode] or string.upper((tostring(ServerByMatchId.GameMode)));
    u17.Visible = true;
    u17.Title.Title.Text = `{string.upper(v56)} | {v57}`;
    u17.Map.Map.Image = GetMapIcon(v56) or "rbxassetid://111859813726258";
    u17.Scroll.Score.Label.Text = ServerByMatchId.GameMode == "trading" and "RAP" or "SCORE";
    u17.Scroll.Map.Visible = ServerByMatchId.GameMode ~= "trading";
    local string_upper_ret = string.upper(v56);
    local Map = u11.Map;

    if Map then
        Map.Text = string_upper_ret;
    end;

    local v58 = `{#ServerByMatchId.Players}/{ServerByMatchId.MaxPlayers}`;
    local Players2 = u11.Players;

    if Players2 then
        Players2.Text = v58;
    end;

    local v59, v60;

    if ServerByMatchId.GameMode == "trading" and ServerByMatchId.GameModeData.Score then
        local math_floor_ret = math.floor(ServerByMatchId.GameModeData.Score);
        local math_floor_ret2 = math.floor(math_floor_ret);
        local math_max_ret = math.max(math_floor_ret2, 0);
        v59 = tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");

        if not v59 then
            v60 = ServerByMatchId.GameModeData;

            if v60 then
                v60 = v60.Scores;
            end;

            v59 = not v60 and "--" or `<font color="rgb(219,199,126)">{v60.T or 0}</font> - <font color="rgb(165,183,212)">{v60.CT or 0}</font>`;
        end;
    else
        v60 = ServerByMatchId.GameModeData;

        if v60 then
            v60 = v60.Scores;
        end;

        v59 = not v60 and "--" or `<font color="rgb(219,199,126)">{v60.T or 0}</font> - <font color="rgb(165,183,212)">{v60.CT or 0}</font>`;
    end;

    local Score = u11.Score;

    if Score then
        Score.Text = v59;
    end;

    local v61 = ServerByMatchId.Region or "--";
    local Region = u11.Region;

    if Region then
        Region.Text = v61;
    end;

    local v62 = FormatUptime(ServerByMatchId.StartedAt);
    local ServerUptime = u11.ServerUptime;

    if ServerUptime then
        ServerUptime.Text = v62;
    end;

    local MatchId = ServerByMatchId.MatchId;
    local ServerId = u11.ServerId;

    if ServerId then
        ServerId.Text = MatchId;
    end;

    RefreshFriendTag(ServerByMatchId);
end;

local function SelectServer(p63: string) -- Line: 375
    -- upvalues: u2 (ref), RefreshDetails (copy), u10 (copy), TweenService (copy), Color3_fromRGB_ret (copy), table_freeze_ret2 (copy), TweenInfo_new_ret (copy), table_freeze_ret (copy)
    u2 = p63;
    RefreshDetails();

    for i, v in u10 do
        local SelectionShadow = v:FindFirstChild("SelectionShadow");

        if not (SelectionShadow and SelectionShadow:IsA("UIShadow")) then
            SelectionShadow = Instance.new("UIShadow");
            SelectionShadow.Name = "SelectionShadow";
            SelectionShadow.Color = Color3_fromRGB_ret;
            SelectionShadow.Transparency = table_freeze_ret2.Transparency;
            SelectionShadow.BlurRadius = table_freeze_ret2.BlurRadius;
            SelectionShadow.Spread = table_freeze_ret2.Spread;
            SelectionShadow.Parent = v;
        end;

        local v64;

        if i == p63 then
            v64 = table_freeze_ret;
        else
            v64 = table_freeze_ret2;
        end;

        TweenService:Create(SelectionShadow, TweenInfo_new_ret, v64):Play();
    end;
end;

local function ApplyServerToRow(p65, p66) -- Line: 386
    -- upvalues: ServerBrowser (copy), table_freeze_ret4 (copy), GetMapIcon (copy)
    local GameModeData = p66.GameModeData;
    local v67 = GameModeData and GameModeData.MapName or "";
    p65.ServerId.Text = ServerBrowser.GetServerNameFromMatchId(p66.MatchId);
    p65.MapName.Text = string.upper(v67);
    p65.PlayerCount.Text = `{#p66.Players}/{p66.MaxPlayers}`;
    local GameModeData2 = p66.GameModeData;

    if GameModeData2 then
        GameModeData2 = GameModeData2.Scores;
    end;

    p65.Score.Text = not GameModeData2 and "--" or `<font color="rgb(219,199,126)">{GameModeData2.T or 0}</font> - <font color="rgb(165,183,212)">{GameModeData2.CT or 0}</font>`;
    p65.Region.Text = p66.Region or "--";
    p65.Gamemode.Text = table_freeze_ret4[p66.GameMode] or string.upper((tostring(p66.GameMode)));
    p65.MapBackground.ImageButton.Image = GetMapIcon(v67) or "";
end;

local function CreateRow(u68: string) -- Line: 399
    -- upvalues: ServerTemplate (copy), Color3_fromRGB_ret (copy), table_freeze_ret2 (copy), ActivateButton (copy), u2 (ref), RefreshDetails (copy), u10 (copy), TweenService (copy), TweenInfo_new_ret (copy), table_freeze_ret (copy), u16 (ref)
    local v69 = ServerTemplate:Clone();
    v69.Name = u68;
    local SelectionShadow = v69:FindFirstChild("SelectionShadow");

    if not (SelectionShadow and SelectionShadow:IsA("UIShadow")) then
        local UIShadow = Instance.new("UIShadow");
        UIShadow.Name = "SelectionShadow";
        UIShadow.Color = Color3_fromRGB_ret;
        UIShadow.Transparency = table_freeze_ret2.Transparency;
        UIShadow.BlurRadius = table_freeze_ret2.BlurRadius;
        UIShadow.Spread = table_freeze_ret2.Spread;
        UIShadow.Parent = v69;
    end;

    local Join = v69:FindFirstChild("Join");

    for _, v in { Join, v69:FindFirstChild("Select"), v69.MapBackground:FindFirstChild("ImageButton") } do
        if v and v:IsA("GuiButton") then
            if v == Join then
                ActivateButton(v);
            end;

            v.MouseButton1Click:Connect(function() -- Line: 411
                -- upvalues: u68 (copy), u2 (ref), RefreshDetails (ref), u10 (ref), TweenService (ref), Color3_fromRGB_ret (ref), table_freeze_ret2 (ref), TweenInfo_new_ret (ref), table_freeze_ret (ref)
                local v70 = u68;
                u2 = v70;
                RefreshDetails();

                for i, v2 in u10 do
                    local SelectionShadow2 = v2:FindFirstChild("SelectionShadow");

                    if not (SelectionShadow2 and SelectionShadow2:IsA("UIShadow")) then
                        SelectionShadow2 = Instance.new("UIShadow");
                        SelectionShadow2.Name = "SelectionShadow";
                        SelectionShadow2.Color = Color3_fromRGB_ret;
                        SelectionShadow2.Transparency = table_freeze_ret2.Transparency;
                        SelectionShadow2.BlurRadius = table_freeze_ret2.BlurRadius;
                        SelectionShadow2.Spread = table_freeze_ret2.Spread;
                        SelectionShadow2.Parent = v2;
                    end;

                    local v71;

                    if i == v70 then
                        v71 = table_freeze_ret;
                    else
                        v71 = table_freeze_ret2;
                    end;

                    TweenService:Create(SelectionShadow2, TweenInfo_new_ret, v71):Play();
                end;
            end);
        end;
    end;

    v69.Parent = u16;

    return v69;
end;

local function RefreshList() -- Line: 423
    -- upvalues: ServerBrowser (copy), MatchesFilters (copy), u10 (copy), CreateRow (copy), ApplyServerToRow (copy), u2 (ref), RefreshDetails (copy), TweenService (copy), Color3_fromRGB_ret (copy), table_freeze_ret2 (copy), TweenInfo_new_ret (copy), table_freeze_ret (copy), u18 (ref), u17 (ref)
    local v72 = {};

    for _, v in ServerBrowser.GetActiveGameServers() do
        if MatchesFilters(v) then
            table.insert(v72, v);
        end;
    end;

    table.sort(v72, function(p73, p74) -- Line: 433
        if #p73.Players == #p74.Players then
            return p73.MatchId < p74.MatchId;
        end;

        return #p73.Players > #p74.Players;
    end);

    local function formatRap(p75: table) -- Line: 440
        local v76 = 0;
        local v77 = 0;

        for _, v in p75 do
            v76 = v76 + 1;
            v77 = v77 + v;
        end;

        return v77 / v76;
    end;

    local v78 = {};

    for i, v in v72 do
        v78[v.MatchId] = true;
        local v79 = u10[v.MatchId];
        local v80, v81;

        if v79 then
            v80 = v;
            v81 = i;
        else
            if v.GameMode == "trading" then
                v81 = i;
                v80 = v;
                local v82 = 0;
                local v83 = 0;

                for _, v2 in v.GameModeData.InventoryValues do
                    v82 = v82 + 1;
                    v83 = v83 + v2;
                end;

                v.GameModeData.Score = v83 / v82;
            else
                v81 = i;
                v80 = v;
            end;

            v79 = CreateRow(v80.MatchId);
            u10[v80.MatchId] = v79;
        end;

        v79.LayoutOrder = v81;
        ApplyServerToRow(v79, v80);

        if v81 == 1 then
            local MatchId = v80.MatchId;
            u2 = MatchId;
            RefreshDetails();

            for i2, v2 in u10 do
                local SelectionShadow = v2:FindFirstChild("SelectionShadow");

                if not (SelectionShadow and SelectionShadow:IsA("UIShadow")) then
                    SelectionShadow = Instance.new("UIShadow");
                    SelectionShadow.Name = "SelectionShadow";
                    SelectionShadow.Color = Color3_fromRGB_ret;
                    SelectionShadow.Transparency = table_freeze_ret2.Transparency;
                    SelectionShadow.BlurRadius = table_freeze_ret2.BlurRadius;
                    SelectionShadow.Spread = table_freeze_ret2.Spread;
                    SelectionShadow.Parent = v2;
                end;

                local v84;

                if i2 == MatchId then
                    v84 = table_freeze_ret;
                else
                    v84 = table_freeze_ret2;
                end;

                TweenService:Create(SelectionShadow, TweenInfo_new_ret, v84):Play();
            end;
        end;
    end;

    for i, v in u10 do
        if not v78[i] then
            v:Destroy();
            u10[i] = nil;
        end;
    end;

    local math_floor_ret = math.floor(#v72);
    local math_max_ret = math.max(math_floor_ret, 0);
    u18.Text = `{tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")} Servers`;

    if not u2 or v78[u2] then
        RefreshDetails();

        return;
    end;

    u2 = nil;
    u17.Visible = false;

    for _, v in u10 do
        local SelectionShadow = v:FindFirstChild("SelectionShadow");

        if not (SelectionShadow and SelectionShadow:IsA("UIShadow")) then
            SelectionShadow = Instance.new("UIShadow");
            SelectionShadow.Name = "SelectionShadow";
            SelectionShadow.Color = Color3_fromRGB_ret;
            SelectionShadow.Transparency = table_freeze_ret2.Transparency;
            SelectionShadow.BlurRadius = table_freeze_ret2.BlurRadius;
            SelectionShadow.Spread = table_freeze_ret2.Spread;
            SelectionShadow.Parent = v;
        end;

        TweenService:Create(SelectionShadow, TweenInfo_new_ret, table_freeze_ret2):Play();
    end;
end;

local function StepUptime(p85: number) -- Line: 492
    -- upvalues: u8 (ref), u2 (ref), ServerBrowser (copy), FormatUptime (copy), u11 (copy)
    u8 = u8 + p85;

    if u8 < 1 then
        return;
    end;

    u8 = 0;

    if not u2 then
        return;
    end;

    local ServerByMatchId = ServerBrowser.GetServerByMatchId(u2);

    if ServerByMatchId then
        local v86 = FormatUptime(ServerByMatchId.StartedAt);
        local ServerUptime = u11.ServerUptime;

        if ServerUptime then
            ServerUptime.Text = v86;
        end;
    end;
end;

local function LoadFriends() -- Line: 511
    -- upvalues: Players (copy), LocalPlayer (copy), u12 (copy), u9 (ref), RefreshList (copy)
    local success, result = pcall(Players.GetFriendsAsync, Players, LocalPlayer.UserId);

    if not (success and result) then
        return;
    end;

    while true do
        for _, v in result:GetCurrentPage() do
            u12[v.Id] = v.Username;
        end;

        if result.IsFinished or not pcall(function() -- Line: 525
            -- upvalues: result (copy)
            result:AdvanceToNextPageAsync();
        end) then
            if u9 then
                RefreshList();
            end;

            return;
        end;
    end;
end;

local function ToggleFriendsOnly() -- Line: 541
    -- upvalues: u4 (ref), u19 (ref), RefreshList (copy)
    u4 = not u4;

    if u19 then
        u19.Visible = u4;
    end;

    RefreshList();
end;

function v1.SetCategoryFilters(p87: table) -- Line: 553
    -- upvalues: u5 (ref), u9 (ref), RefreshList (copy)
    u5 = p87;

    if u9 then
        RefreshList();
    end;
end;

function v1.SetActive(p88: boolean) -- Line: 562
    -- upvalues: u9 (ref), u8 (ref), u15 (ref), RunServiceController (copy), StepUptime (copy), RefreshList (copy)
    if p88 == u9 then
        return;
    end;

    u9 = p88;

    if not p88 then
        if u15 then
            u15:Disconnect();
            u15 = nil;
        end;

        return;
    end;

    u8 = 0;
    u15 = RunServiceController.BindToHeartbeat("UI.ServerBrowser.Uptime", StepUptime);
    RefreshList();
end;

function v1.Initialize(p89) -- Line: 581
    -- upvalues: u16 (ref), u18 (ref), u17 (ref), table_freeze_ret3 (copy), u11 (copy), u3 (ref), RefreshList (copy), u19 (ref), u4 (ref), ToggleFriendsOnly (copy), ActivateButton (copy), u2 (ref), u6 (ref), Remotes (copy)
    local Main = p89.Main;
    local Frame = Main.Frame;
    u16 = Frame.Container;
    u18 = Frame.Top.Title;
    u17 = Main.Categories;

    for _, child in u16:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy();
        end;
    end;

    for _, v in table_freeze_ret3 do
        local v90 = u17.Scroll:FindFirstChild(v);

        if v90 then
            v90 = v90:FindFirstChild("Value");
        end;

        if v90 and v90:IsA("TextLabel") then
            u11[v] = v90;
        else
            warn((`[ServerBrowser] Missing "{v}.Value" label in the details panel`));
        end;
    end;

    u17.Visible = false;
    local SearchBar = Frame.Top.SearchBar;
    local u91 = SearchBar:FindFirstChildWhichIsA("TextBox", true);

    if u91 then
        SearchBar.MouseButton1Click:Connect(function() -- Line: 612
            -- upvalues: u91 (copy)
            u91:CaptureFocus();
        end);
        u91:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 615
            -- upvalues: u3 (ref), u91 (copy), RefreshList (ref)
            u3 = string.lower((string.gsub(u91.Text, "^%s*(.-)%s*$", "%1")));
            RefreshList();
        end);
    else
        warn("[ServerBrowser] No search TextBox found, searching is disabled");
    end;

    local Friends = Frame.Top.Friends;
    local Button = Friends:FindFirstChild("Button");
    local v92;

    if Button then
        v92 = Button:FindFirstChild("Check");
    else
        v92 = Button;
    end;

    if v92 and v92:IsA("GuiObject") then
        u19 = v92;
        v92.Visible = u4;
        Friends.MouseButton1Click:Connect(ToggleFriendsOnly);

        if Button and Button:IsA("GuiButton") then
            Button.MouseButton1Click:Connect(ToggleFriendsOnly);
        end;
    else
        warn("[ServerBrowser] No \"Friends.Button.Check\" mark found, the friends only filter is disabled");
    end;

    ActivateButton(u17.Join);
    u17.Join.MouseButton1Click:Connect(function() -- Line: 640
        -- upvalues: u2 (ref), Main (copy)
        if u2 then
            Main.Prompt.Visible = true;
        end;
    end);
    ActivateButton(Main.Prompt.Buttons.Buttons.Yes);
    Main.Prompt.Buttons.Buttons.Yes.MouseButton1Click:Connect(function() -- Line: 647
        -- upvalues: u2 (ref), u6 (ref), Remotes (ref)
        if u2 then
            local os_clock_ret = os.clock();

            if os_clock_ret - u6 < 1.1 then
                return;
            end;

            u6 = os_clock_ret;
            Remotes.ServerBrowser.Teleport.Send(u2);
        end;
    end);
    ActivateButton(Main.Prompt.Buttons.Buttons.No);
    Main.Prompt.Buttons.Buttons.No.MouseButton1Click:Connect(function() -- Line: 654
        -- upvalues: Main (copy)
        Main.Prompt.Visible = false;
    end);
end;

function v1.Start() -- Line: 661
    -- upvalues: LoadFriends (copy), ServerBrowser (copy), u9 (ref), RefreshList (copy)
    task.spawn(LoadFriends);
    ServerBrowser.OnServerBrowserUpdated:Connect(function() -- Line: 664
        -- upvalues: u9 (ref), RefreshList (ref)
        if u9 then
            RefreshList();
        end;
    end);
end;

return v1;