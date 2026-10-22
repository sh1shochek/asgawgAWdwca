-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.ContainerAnalytics
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.ContainerAnalytics
-- Decompile time: 17.51 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = {};
local u22 = {};
local u23 = {};
local u24 = {};
local u25 = {};
local u26 = {};
local u27 = { "Mil-Spec", "Restricted", "Classified", "Covert", "Exceeding Rare" };
local u28 = {
    Frame = { "BackgroundTransparency" },
    TextLabel = { "TextTransparency" },
    ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
    UIStroke = { "Transparency" }
};
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.6, Enum.EasingStyle.Quint);

local function FormatNumber(p29: number) -- Line: 53
    local math_floor_ret = math.floor(p29);

    return tostring(math_floor_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function CaptureFade(p30: userdata) -- Line: 57
    -- upvalues: u28 (copy)
    local v31 = {};

    for _, v in { p30, unpack(p30:GetDescendants()) } do
        local v32 = u28[v.ClassName];

        if v32 then
            local v33 = v;

            for _, v2 in v32 do
                if v33[v2] < 1 then
                    table.insert(v31, { v33, v2, v33[v2] });
                end;
            end;
        end;
    end;

    return v31;
end;

local function FadeIn(p34: any, p35: number) -- Line: 77
    -- upvalues: TweenService (copy)
    local TweenInfo_new_ret3 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, p35);

    for _, v in p34.Fades do
        local v36, v37, v38 = unpack(v);
        v36[v37] = 1;
        TweenService:Create(v36, TweenInfo_new_ret3, {
            [v37] = v38
        }):Play();
    end;

    p34.Holder.Position = UDim2.fromOffset(12, 0);
    TweenService:Create(p34.Holder, TweenInfo_new_ret3, {
        Position = UDim2.new()
    }):Play();
end;

local function ItemInfo(p39: string) -- Line: 91
    -- upvalues: u3 (ref), u4 (ref), u5 (ref)
    local v40, v41 = unpack(p39:split("_"));
    local v42 = u3.GetItem(v40, v41) or u4.GetWeaponSkin(v40, v41);

    if v42 then
        return `{(u3.GetCategory(v40) or u5.Get(v40)).DisplayName or v40} | {v42.DisplayName or v41}`, `rbxassetid://{v42.Thumbnail}`;
    end;

    return p39, "";
end;

local function CaseThumbnail(p43: string?) -- Line: 104
    -- upvalues: u3 (ref)
    if p43 then
        p43 = u3.GetItem("Containers", p43);
    end;

    return p43 and `rbxassetid://{p43.Thumbnail}` or "rbxassetid://81975307552462";
end;

local function DrawCounter(p44: any, p45: number, p46: boolean) -- Line: 110
    -- upvalues: TweenService (copy), TweenInfo_new_ret2 (copy)
    if p46 then
        p44.Counter.Value = 0;
    end;

    TweenService:Create(p44.Counter, TweenInfo_new_ret2, {
        Value = p45
    }):Play();
end;

local function DrawBars(p47: any, p48: boolean) -- Line: 118
    -- upvalues: u27 (copy), u25 (copy), TweenService (copy)
    for i, v in u27 do
        local Holder = u25[i].Holder;
        local v49 = p47.Rarities[v] or 0;
        local v50 = p47.Opened > 0 and (v49 / p47.Opened or 0) or 0;
        local TweenInfo_new_ret3 = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, p48 and 0.1 + (i - 1) * 0.05 or 0);
        local Count = Holder.Count;
        local math_floor_ret = math.floor(v49);
        Count.Text = tostring(math_floor_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        Holder.Percent.Text = string.format("%.1f%%", v50 * 100);

        if p48 then
            Holder.Bar.Fill.Size = UDim2.fromScale(0, 1);
        end;

        TweenService:Create(Holder.Bar.Fill, TweenInfo_new_ret3, {
            Size = UDim2.fromScale(v50, 1)
        }):Play();
    end;
end;

local function DrawSelection(p51: boolean) -- Line: 136
    -- upvalues: u20 (ref), u19 (ref), u10 (ref), u3 (ref), u11 (ref), u22 (copy), u14 (ref), u17 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u18 (ref), DrawBars (copy)
    local v52 = u20 and u19.Cases[u20] or u19;
    u10.Header.Title.Text = u20 and string.upper(u20) or "ALL CASES";
    local Icon = u10.Header.Thumbnail.Icon;
    local v53 = u20;

    if v53 then
        v53 = u3.GetItem("Containers", v53);
    end;

    Icon.Image = v53 and `rbxassetid://{v53.Thumbnail}` or "rbxassetid://81975307552462";
    local Article = u11.Header.Article;
    local math_floor_ret = math.floor(#u22);
    Article.Text = `{tostring(math_floor_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")} RECENT DROPS`;
    u14.Frame.Visible = #u22 == 0;
    local v54 = u17;
    local Opened = v52.Opened;

    if p51 then
        v54.Counter.Value = 0;
    end;

    TweenService:Create(v54.Counter, TweenInfo_new_ret2, {
        Value = Opened
    }):Play();
    local v55 = u18;
    local KillTracks = v52.KillTracks;

    if p51 then
        v55.Counter.Value = 0;
    end;

    TweenService:Create(v55.Counter, TweenInfo_new_ret2, {
        Value = KillTracks
    }):Play();
    DrawBars(v52, p51);
end;

local function DrawCaseRow(p56, p57) -- Line: 150
    -- upvalues: u3 (ref), u19 (ref), u20 (ref)
    local Holder = p56.Holder;
    local v58 = p57.Name and u3.GetItem("Containers", p57.Name);
    local v59 = v58 and v58.Color or Color3.new(1, 1, 1);
    local v60 = u19.Opened > 0 and (p57.Opened / u19.Opened or 0) or 0;
    p56.Name = p57.Name;
    local Thumbnail = Holder.Thumbnail;
    local Name = p57.Name;

    if Name then
        Name = u3.GetItem("Containers", Name);
    end;

    Thumbnail.Image = Name and `rbxassetid://{Name.Thumbnail}` or "rbxassetid://81975307552462";
    Holder.CaseName.Text = p57.Name and (string.upper(p57.Name) or "ALL CASES") or "ALL CASES";
    local Count = Holder.Count;
    local math_floor_ret = math.floor(p57.Opened);
    Count.Text = `{tostring(math_floor_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")} OPENED`;
    Holder.Share.Text = `{math.round(v60 * 100)}%`;
    Holder.Bar.Fill.BackgroundColor3 = v59;
    Holder.Bar.Fill.Size = UDim2.fromScale(v60, 1);
    Holder.Accent.BackgroundColor3 = v59;
    Holder.Accent.BackgroundTransparency = p57.Name == u20 and 0 or 1;
end;

local function DrawHistoryRow(p61, p62) -- Line: 168
    -- upvalues: ItemInfo (copy), u6 (ref)
    local Holder = p61.Holder;
    local v63, v64 = ItemInfo(p62.I);
    local v65 = u6[p62.R];
    Holder.Strip.BackgroundColor3 = v65;
    Holder.Thumbnail.Image = v64;
    local ItemName = Holder.ItemName;

    if p62.K then
        v63 = `KillTrackᴷ⁺ {v63}` or v63;
    end;

    ItemName.Text = v63;
    Holder.Rarity.Text = string.upper(p62.R);
    Holder.Rarity.TextColor3 = v65;
    Holder.Case.Text = string.upper(p62.C);
    Holder.Date.Text = DateTime.fromUnixTimestamp(p62.T):FormatLocalTime("MMM D, HH:mm", "en-us");
end;

local function CaseRow(p66: number) -- Line: 182
    -- upvalues: u23 (copy), u1 (copy), CaptureFade (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local v67 = u23[p66];

    if v67 then
        return v67;
    end;

    local v68 = u1.caseRow();
    v68.LayoutOrder = p66;
    local u69 = {
        Frame = v68,
        Holder = v68.Holder,
        Fades = CaptureFade(v68.Holder)
    };
    v68.MouseButton1Click:Connect(function() -- Line: 198
        -- upvalues: u1 (ref), u69 (ref)
        u1.Select(u69.Name);
    end);
    v68.MouseEnter:Connect(function() -- Line: 202
        -- upvalues: TweenService (ref), u69 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u69.Holder, TweenInfo_new_ret, {
            BackgroundTransparency = 0.9
        }):Play();
    end);
    v68.MouseLeave:Connect(function() -- Line: 206
        -- upvalues: TweenService (ref), u69 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u69.Holder, TweenInfo_new_ret, {
            BackgroundTransparency = 0.96
        }):Play();
    end);
    u23[p66] = u69;

    return u69;
end;

local function HistoryRow(p70: number) -- Line: 215
    -- upvalues: u24 (copy), u1 (copy), CaptureFade (copy)
    local v71 = u24[p70];

    if v71 then
        return v71;
    end;

    local v72 = u1.historyRow(p70);
    v72.LayoutOrder = p70;
    local v73 = {
        Frame = v72,
        Holder = v72.Holder,
        Fades = CaptureFade(v72.Holder)
    };
    u24[p70] = v73;

    return v73;
end;

local function LoadCases(p74: number) -- Line: 236
    -- upvalues: u21 (copy), CaseRow (copy), DrawCaseRow (copy), u12 (ref)
    local math_min_ret = math.min(p74 * 20, #u21);

    for i = (p74 - 1) * 20 + 1, math_min_ret do
        local v75 = CaseRow(i);
        DrawCaseRow(v75, u21[i]);
        v75.Frame.Parent = u12;
        local _ = i;
    end;

    return math_min_ret < #u21;
end;

local function LoadHistory(p76: number) -- Line: 250
    -- upvalues: u22 (copy), u24 (copy), u1 (copy), CaptureFade (copy), DrawHistoryRow (copy), u13 (ref)
    local math_min_ret = math.min(p76 * 20, #u22);

    for i = (p76 - 1) * 20 + 1, math_min_ret do
        local v77 = u24[i];

        if not v77 then
            local v78 = u1.historyRow(i);
            v78.LayoutOrder = i;
            v77 = {
                Frame = v78,
                Holder = v78.Holder,
                Fades = CaptureFade(v78.Holder)
            };
            u24[i] = v77;
        end;

        DrawHistoryRow(v77, u22[i]);
        v77.Frame.Parent = u13;
        local _ = i;
    end;

    return math_min_ret < #u22;
end;

local function BuildHistory() -- Line: 264
    -- upvalues: u22 (copy), u19 (ref), u20 (ref), u16 (ref)
    table.clear(u22);

    for _, v in u19.History do
        if not u20 or v.C == u20 then
            table.insert(u22, v);
        end;
    end;

    u16:Reset();
    u16:LoadNextPage();
end;

local function BuildCases() -- Line: 277
    -- upvalues: u21 (copy), u19 (ref), u15 (ref)
    table.clear(u21);

    for i, v in u19.Cases do
        table.insert(u21, {
            Name = i,
            Opened = v.Opened
        });
    end;

    table.sort(u21, function(p79, p80) -- Line: 284
        if p79.Opened == p80.Opened then
            return p79.Name < p80.Name;
        end;

        return p79.Opened > p80.Opened;
    end);
    table.insert(u21, 1, {
        Opened = u19.Opened
    });
    u15:Reset();
    u15:LoadNextPage();
end;

function u1.Draw() -- Line: 300
    -- upvalues: LocalPlayer (copy), u22 (copy), u19 (ref), HttpService (copy), u20 (ref), BuildCases (copy), BuildHistory (copy), DrawSelection (copy), u9 (ref), FadeIn (copy), u24 (copy)
    local Attribute = LocalPlayer:GetAttribute("ContainerStats");
    local v81 = u22[1];
    u19 = Attribute and HttpService:JSONDecode(Attribute) or {
        Opened = 0,
        KillTracks = 0,
        Rarities = {},
        Cases = {},
        History = {}
    };

    if u20 and not u19.Cases[u20] then
        u20 = nil;
    end;

    BuildCases();
    BuildHistory();
    DrawSelection(false);

    if not u9.Visible then
        return;
    end;

    for i = 1, math.min(10, #u22) do
        local v82 = u22[i];

        if v81 and (v82.T == v81.T and (v82.I == v81.I and v82.C == v81.C)) then
            break;
        end;

        FadeIn(u24[i], (i - 1) * 0.05);
        local _ = i;
    end;
end;

function u1.Select(p83: string?) -- Line: 329
    -- upvalues: u20 (ref), u8 (ref), u23 (copy), TweenService (copy), TweenInfo_new_ret (copy), BuildHistory (copy), DrawSelection (copy), u22 (copy), FadeIn (copy), u24 (copy), u14 (ref)
    if p83 == u20 then
        return;
    end;

    u20 = p83;
    u8.Play("UI.generic_press");

    for _, v in u23 do
        TweenService:Create(v.Holder.Accent, TweenInfo_new_ret, {
            BackgroundTransparency = v.Name == u20 and 0 or 1
        }):Play();
    end;

    BuildHistory();
    DrawSelection(true);

    for i = 1, math.min(10, #u22) do
        FadeIn(u24[i], (i - 1) * 0.03);
        local _ = i;
    end;

    if u14.Frame.Visible then
        FadeIn(u14, 0.1);
    end;
end;

function u1.Open() -- Line: 354
    -- upvalues: u12 (ref), u13 (ref), u21 (copy), FadeIn (copy), u23 (copy), u26 (copy), u25 (copy), u22 (copy), u24 (copy), u14 (ref), DrawSelection (copy)
    u12.CanvasPosition = Vector2.zero;
    u13.CanvasPosition = Vector2.zero;

    for i = 1, math.min(10, #u21) do
        FadeIn(u23[i], (i - 1) * 0.035);
        local _ = i;
    end;

    for i, v in u26 do
        FadeIn(v, 0.06 + (i - 1) * 0.05);
    end;

    for i, v in u25 do
        FadeIn(v, 0.12 + (i - 1) * 0.035);
    end;

    for i = 1, math.min(10, #u22) do
        FadeIn(u24[i], (i - 1) * 0.035 + 0.18);
        local _ = i;
    end;

    if u14.Frame.Visible then
        FadeIn(u14, 0.2);
    end;

    DrawSelection(true);
end;

function u1.Init(p84) -- Line: 383
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    u2 = p84:GetModule("Gui");
    u3 = p84:GetModule("ItemManager");
    u4 = p84:GetModule("SkinManager");
    u5 = p84:GetModule("WeaponManager");
    u6 = p84:GetModule("RarityColors");
    u7 = p84:GetModule("VirtualScroller");
    u8 = p84:GetModule("SoundManager");
end;

function u1.new(p85) -- Line: 395
    -- upvalues: u2 (ref), u9 (ref), u1 (copy), u12 (ref), u10 (ref), u17 (ref), u18 (ref), u6 (ref), u26 (copy), CaptureFade (copy), u27 (copy), u25 (copy), u11 (ref), u13 (ref), u14 (ref), u15 (ref), u7 (ref), LoadCases (copy), u16 (ref), LoadHistory (copy)
    local Component = u2.GetComponent("Leaderboards");
    u9 = Instance.new("Frame");
    u9.Name = "Containers";
    u9.Active = true;
    u9.AnchorPoint = Vector2.new(0.5, 0);
    u9.BackgroundColor3 = Color3.new();
    u9.BackgroundTransparency = 0.9;
    u9.ClipsDescendants = true;
    u9.Position = UDim2.fromScale(0.5, 0.0580001);
    u9.Selectable = true;
    u9.SelectionGroup = true;
    u9.Size = UDim2.fromScale(1, 0.94);
    u9.Visible = false;
    local v86 = Component.title();
    v86.Title.Text = "Containers";
    v86.Article.Text = "Every case you opened and what it dropped";
    v86.Icon.Image = "rbxassetid://116423516483038";
    v86.Parent = u9;
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.194361);
    Frame.Size = UDim2.fromScale(0.761979, 0.745084);
    Frame.Parent = u9;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.015, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    local v87 = u1.panel("Cases", 0.27, 1, "CASES", "SELECT A CASE TO FILTER", "rbxassetid://81975307552462");
    v87.Parent = Frame;
    u12 = u1.list(0.14);
    u12.Parent = v87;
    u10 = u1.panel("Selection", 0.3, 2, "ALL CASES", "DROPS BY RARITY", "rbxassetid://81975307552462");
    u10.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Stats";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.15);
    Frame2.Size = UDim2.fromScale(0.92, 0.16);
    Frame2.Parent = u10;
    u17 = u1.stat("Opened", "OPENED", Color3.new(1, 1, 1));
    u17.Parent = Frame2;
    u18 = u1.stat("KillTrack", "KILLTRACK", u6.KillTrack);
    u18.AnchorPoint = Vector2.new(1, 0);
    u18.Position = UDim2.fromScale(1, 0);
    u18.Parent = Frame2;

    for _, v in { u17, u18 } do
        local v88 = {
            Holder = v.Holder,
            Fades = CaptureFade(v.Holder)
        };
        table.insert(u26, v88);
    end;

    u1.line(0.345).Parent = u10;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Rarities";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.375);
    Frame3.Size = UDim2.fromScale(0.92, 0.6);
    Frame3.Parent = u10;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Padding = UDim.new(0.045, 0);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = Frame3;

    for i, v in u27 do
        local v89 = u1.rarityRow(v);
        v89.LayoutOrder = i;
        v89.Parent = Frame3;
        u25[i] = {
            Frame = v89,
            Holder = v89.Holder,
            Fades = CaptureFade(v89.Holder)
        };
    end;

    u11 = u1.panel("History", 0.4, 3, "HISTORY", "RECENT DROPS", "rbxassetid://107995524735706");
    u11.Parent = Frame;
    u13 = u1.list(0.105);
    u13.Parent = u11;
    local v90 = Component.empty({
        Icon = "rbxassetid://107995524735706",
        Hint = "Open a container to start your history"
    });
    v90.Position = UDim2.fromScale(0.5, 0.145);
    v90.Size = UDim2.fromScale(0.94, 0.835);
    v90.Holder.Title.Text = "NO CASES OPENED YET";
    v90.Parent = u11;
    u14 = {
        Frame = v90,
        Holder = v90.Holder,
        Fades = CaptureFade(v90.Holder)
    };
    u15 = u7.new(u12, LoadCases);
    u16 = u7.new(u13, LoadHistory);
    u9.Parent = p85;

    return u9;
end;

function u1.line(p91: number) -- Line: 517
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(184, 184, 184);
    Frame.BackgroundTransparency = 0.5;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, p91);
    Frame.Size = UDim2.new(0.92, 0, 0, 1);

    return Frame;
end;

function u1.panel(p92: string, p93: number, p94: number, p95: string, p96: string, p97: string) -- Line: 530
    -- upvalues: u2 (ref), u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = p92;
    Frame.BackgroundColor3 = Color3.fromRGB(39, 39, 39);
    Frame.BackgroundTransparency = 0.4;
    Frame.LayoutOrder = p94;
    Frame.Size = UDim2.fromScale(p93, 1);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(184, 184, 184);
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.02, 0);
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Header";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.025);
    Frame2.Size = UDim2.fromScale(0.92, 0.08);
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Thumbnail";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.8;
    Frame3.Position = UDim2.fromScale(0, 0.5);
    Frame3.Size = UDim2.fromScale(1, 1);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame3.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame3;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Thickness = 1.5;
    UIStroke2.Transparency = 0.8;
    UIStroke2.Parent = Frame3;
    u2.GetComponent("Leaderboards").icon({
        Icon = p97
    }, 0).Parent = Frame3;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.2, 0.02);
    TextLabel.Size = UDim2.fromScale(0.8, 0.55);
    TextLabel.Text = p95;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Article";
    TextLabel2.AnchorPoint = Vector2.new(0, 1);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.2, 0.98);
    TextLabel2.Size = UDim2.fromScale(0.8, 0.3);
    TextLabel2.Text = p96;
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.5;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame2;
    u1.line(0.125).Parent = Frame;

    return Frame;
end;

function u1.list(p98: number) -- Line: 612
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "List";
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.Position = UDim2.fromScale(0.5, 0.145);
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(184, 184, 184);
    ScrollingFrame.ScrollBarImageTransparency = 0.5;
    ScrollingFrame.ScrollBarThickness = 3;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Selectable = false;
    ScrollingFrame.Size = UDim2.fromScale(0.94, 0.835);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.CellPadding = UDim2.fromOffset(0, 4);
    UIGridLayout.CellSize = UDim2.fromScale(1, p98);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = ScrollingFrame;

    return ScrollingFrame;
end;

function u1.stat(p99: string, p100: string, p101) -- Line: 640
    local Frame = Instance.new("Frame");
    Frame.Name = p99;
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(0.485, 1);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Holder";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.96;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.12, 0);
    UICorner.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Value";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.08, 0.12);
    TextLabel.Size = UDim2.fromScale(0.84, 0.48);
    TextLabel.Text = "0";
    TextLabel.TextColor3 = p101;
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Label";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.08, 0.66);
    TextLabel2.Size = UDim2.fromScale(0.84, 0.2);
    TextLabel2.Text = p100;
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.45;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame2;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "Counter";
    NumberValue.Parent = Frame;
    NumberValue.Changed:Connect(function(p102) -- Line: 694
        -- upvalues: TextLabel (copy)
        local math_floor_ret = math.floor(p102);
        TextLabel.Text = tostring(math_floor_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end);

    return Frame;
end;

function u1.rarityRow(p103: string) -- Line: 701
    -- upvalues: u6 (ref)
    local v104 = u6[p103];
    local Frame = Instance.new("Frame");
    Frame.Name = p103;
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 0.155);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Holder";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Size = UDim2.fromScale(0.5, 0.42);
    TextLabel.Text = string.upper(p103);
    TextLabel.TextColor3 = v104;
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Count";
    TextLabel2.AnchorPoint = Vector2.new(1, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.8, 0);
    TextLabel2.Size = UDim2.fromScale(0.28, 0.42);
    TextLabel2.Text = "0";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.Parent = Frame2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Percent";
    TextLabel3.AnchorPoint = Vector2.new(1, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(1, 0);
    TextLabel3.Size = UDim2.fromScale(0.18, 0.42);
    TextLabel3.Text = "0.0%";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.5;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Bar";
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.92;
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0, 0.62);
    Frame3.Size = UDim2.fromScale(1, 0.22);
    Frame3.Parent = Frame2;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Fill";
    Frame4.BackgroundColor3 = v104;
    Frame4.BorderSizePixel = 0;
    Frame4.Size = UDim2.fromScale(0, 1);
    Frame4.Parent = Frame3;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame4;

    return Frame;
end;

function u1.caseRow() -- Line: 792
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Case";
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.Text = "";
    local Frame = Instance.new("Frame");
    Frame.Name = "Holder";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.96;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = TextButton;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.18, 0);
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Accent";
    Frame2.AnchorPoint = Vector2.new(0, 0.5);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0, 0.5);
    Frame2.Size = UDim2.new(0, 3, 0.6, 0);
    Frame2.Parent = Frame;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Thumbnail";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "";
    ImageLabel.Position = UDim2.fromScale(0.03, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.72, 0.72);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "CaseName";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.25, 0.14);
    TextLabel.Size = UDim2.fromScale(0.5, 0.34);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Count";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.25, 0.52);
    TextLabel2.Size = UDim2.fromScale(0.5, 0.24);
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.4;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Share";
    TextLabel3.AnchorPoint = Vector2.new(1, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.96, 0.14);
    TextLabel3.Size = UDim2.fromScale(0.22, 0.34);
    TextLabel3.Text = "";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Bar";
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.9;
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.25, 0.84);
    Frame3.Size = UDim2.new(0.71, 0, 0, 2);
    Frame3.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Fill";
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderSizePixel = 0;
    Frame4.Size = UDim2.fromScale(0, 1);
    Frame4.Parent = Frame3;

    return TextButton;
end;

function u1.historyRow(p105: number) -- Line: 904
    local Frame = Instance.new("Frame");
    Frame:SetAttribute("Select", true);
    Frame.Name = tostring(p105);
    Frame.BackgroundTransparency = 1;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Holder";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = p105 % 2 == 0 and 0.96 or 0.985;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.18, 0);
    UICorner.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Strip";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0, 0.5);
    Frame3.Size = UDim2.new(0, 3, 0.6, 0);
    Frame3.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Thumbnail";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "";
    ImageLabel.Position = UDim2.fromScale(0.03, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.85, 0.85);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ItemName";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.16, 0.14);
    TextLabel.Size = UDim2.fromScale(0.54, 0.36);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Rarity";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.16, 0.56);
    TextLabel2.Size = UDim2.fromScale(0.4, 0.26);
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Date";
    TextLabel3.AnchorPoint = Vector2.new(1, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.97, 0.14);
    TextLabel3.Size = UDim2.fromScale(0.26, 0.32);
    TextLabel3.Text = "";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.2;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.Parent = Frame2;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Case";
    TextLabel4.AnchorPoint = Vector2.new(1, 0);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.97, 0.56);
    TextLabel4.Size = UDim2.fromScale(0.26, 0.26);
    TextLabel4.Text = "";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.5;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel4.Parent = Frame2;

    return Frame;
end;

return u1;