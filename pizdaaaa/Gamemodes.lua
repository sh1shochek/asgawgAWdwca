-- ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Gamemodes
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Gamemodes
-- Decompile time: 46.13 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("MarketplaceService");
local TeleportService = game:GetService("TeleportService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
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
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local GameStats = ReplicatedStorage.GameStats;
local LocalPlayer = Players.LocalPlayer;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = {};
local u36 = {};
local u37 = {};
local u38 = {};
local u39 = {};
local u40 = {};
local u41 = {};
local u42 = {};
local u43 = {};
local u44 = {};
local u45 = nil;
local u46 = nil;
local u47 = {
    Search = "",
    Sort = "Most Players",
    MinPlayers = 0,
    FriendsOnly = false,
    Regions = {},
    Countries = {},
    Maps = {},
    MaxPlayers = Players.MaxPlayers
};
local u48 = false;
local u49 = false;
local u50 = false;
local u51 = false;
local u52 = nil;
local u53 = nil;
local u54 = 0;
local u55 = nil;
local u56 = nil;
local u57 = nil;
local u58 = nil;
local u59 = nil;
local Color3_new_ret = Color3.new(1, 0.2, 0.2);
local Color3_new_ret2 = Color3.new(1, 0.945098, 0.521569);
local Color3_new_ret3 = Color3.new(0.568627, 1, 0.537255);
local u60 = nil;
local u61 = { "Europe", "North America", "South America", "Asia", "Oceania", "Africa" };
local u62 = { "Most Players", "Fewest Players", "Free Slots", "Most Friends", "Region", "Map" };
local u63 = {
    AD = { "Andorra", 1 },
    AE = { "United Arab Emirates", 4 },
    AF = { "Afghanistan", 4 },
    AG = { "Antigua and Barbuda", 2 },
    AI = { "Anguilla", 2 },
    AL = { "Albania", 1 },
    AM = { "Armenia", 4 },
    AO = { "Angola", 6 },
    AQ = { "Antarctica", 5 },
    AR = { "Argentina", 3 },
    AS = { "American Samoa", 5 },
    AT = { "Austria", 1 },
    AU = { "Australia", 5 },
    AW = { "Aruba", 2 },
    AX = { "Aland Islands", 1 },
    AZ = { "Azerbaijan", 4 },
    BA = { "Bosnia and Herzegovina", 1 },
    BB = { "Barbados", 2 },
    BD = { "Bangladesh", 4 },
    BE = { "Belgium", 1 },
    BF = { "Burkina Faso", 6 },
    BG = { "Bulgaria", 1 },
    BH = { "Bahrain", 4 },
    BI = { "Burundi", 6 },
    BJ = { "Benin", 6 },
    BL = { "Saint Barthelemy", 2 },
    BM = { "Bermuda", 2 },
    BN = { "Brunei", 4 },
    BO = { "Bolivia", 3 },
    BQ = { "Caribbean Netherlands", 2 },
    BR = { "Brazil", 3 },
    BS = { "Bahamas", 2 },
    BT = { "Bhutan", 4 },
    BV = { "Bouvet Island", 5 },
    BW = { "Botswana", 6 },
    BY = { "Belarus", 1 },
    BZ = { "Belize", 2 },
    CA = { "Canada", 2 },
    CC = { "Cocos Islands", 5 },
    CD = { "DR Congo", 6 },
    CF = { "Central African Republic", 6 },
    CG = { "Congo", 6 },
    CH = { "Switzerland", 1 },
    CI = { "Cote d\'Ivoire", 6 },
    CK = { "Cook Islands", 5 },
    CL = { "Chile", 3 },
    CM = { "Cameroon", 6 },
    CN = { "China", 4 },
    CO = { "Colombia", 3 },
    CR = { "Costa Rica", 2 },
    CU = { "Cuba", 2 },
    CV = { "Cape Verde", 6 },
    CW = { "Curacao", 2 },
    CX = { "Christmas Island", 5 },
    CY = { "Cyprus", 1 },
    CZ = { "Czechia", 1 },
    DE = { "Germany", 1 },
    DJ = { "Djibouti", 6 },
    DK = { "Denmark", 1 },
    DM = { "Dominica", 2 },
    DO = { "Dominican Republic", 2 },
    DZ = { "Algeria", 6 },
    EC = { "Ecuador", 3 },
    EE = { "Estonia", 1 },
    EG = { "Egypt", 6 },
    EH = { "Western Sahara", 6 },
    ER = { "Eritrea", 6 },
    ES = { "Spain", 1 },
    ET = { "Ethiopia", 6 },
    FI = { "Finland", 1 },
    FJ = { "Fiji", 5 },
    FK = { "Falkland Islands", 3 },
    FM = { "Micronesia", 5 },
    FO = { "Faroe Islands", 1 },
    FR = { "France", 1 },
    GA = { "Gabon", 6 },
    GB = { "United Kingdom", 1 },
    GD = { "Grenada", 2 },
    GE = { "Georgia", 4 },
    GF = { "French Guiana", 3 },
    GG = { "Guernsey", 1 },
    GH = { "Ghana", 6 },
    GI = { "Gibraltar", 1 },
    GL = { "Greenland", 2 },
    GM = { "Gambia", 6 },
    GN = { "Guinea", 6 },
    GP = { "Guadeloupe", 2 },
    GQ = { "Equatorial Guinea", 6 },
    GR = { "Greece", 1 },
    GS = { "South Georgia", 3 },
    GT = { "Guatemala", 2 },
    GU = { "Guam", 5 },
    GW = { "Guinea-Bissau", 6 },
    GY = { "Guyana", 3 },
    HK = { "Hong Kong", 4 },
    HM = { "Heard Island", 5 },
    HN = { "Honduras", 2 },
    HR = { "Croatia", 1 },
    HT = { "Haiti", 2 },
    HU = { "Hungary", 1 },
    ID = { "Indonesia", 4 },
    IE = { "Ireland", 1 },
    IL = { "Israel", 4 },
    IM = { "Isle of Man", 1 },
    IN = { "India", 4 },
    IO = { "British Indian Ocean Territory", 4 },
    IQ = { "Iraq", 4 },
    IR = { "Iran", 4 },
    IS = { "Iceland", 1 },
    IT = { "Italy", 1 },
    JE = { "Jersey", 1 },
    JM = { "Jamaica", 2 },
    JO = { "Jordan", 4 },
    JP = { "Japan", 4 },
    KE = { "Kenya", 6 },
    KG = { "Kyrgyzstan", 4 },
    KH = { "Cambodia", 4 },
    KI = { "Kiribati", 5 },
    KM = { "Comoros", 6 },
    KN = { "Saint Kitts and Nevis", 2 },
    KP = { "North Korea", 4 },
    KR = { "South Korea", 4 },
    KW = { "Kuwait", 4 },
    KY = { "Cayman Islands", 2 },
    KZ = { "Kazakhstan", 4 },
    LA = { "Laos", 4 },
    LB = { "Lebanon", 4 },
    LC = { "Saint Lucia", 2 },
    LI = { "Liechtenstein", 1 },
    LK = { "Sri Lanka", 4 },
    LR = { "Liberia", 6 },
    LS = { "Lesotho", 6 },
    LT = { "Lithuania", 1 },
    LU = { "Luxembourg", 1 },
    LV = { "Latvia", 1 },
    LY = { "Libya", 6 },
    MA = { "Morocco", 6 },
    MC = { "Monaco", 1 },
    MD = { "Moldova", 1 },
    ME = { "Montenegro", 1 },
    MF = { "Saint Martin", 2 },
    MG = { "Madagascar", 6 },
    MH = { "Marshall Islands", 5 },
    MK = { "North Macedonia", 1 },
    ML = { "Mali", 6 },
    MM = { "Myanmar", 4 },
    MN = { "Mongolia", 4 },
    MO = { "Macao", 4 },
    MP = { "Northern Mariana Islands", 5 },
    MQ = { "Martinique", 2 },
    MR = { "Mauritania", 6 },
    MS = { "Montserrat", 2 },
    MT = { "Malta", 1 },
    MU = { "Mauritius", 6 },
    MV = { "Maldives", 4 },
    MW = { "Malawi", 6 },
    MX = { "Mexico", 2 },
    MY = { "Malaysia", 4 },
    MZ = { "Mozambique", 6 },
    NA = { "Namibia", 6 },
    NC = { "New Caledonia", 5 },
    NE = { "Niger", 6 },
    NF = { "Norfolk Island", 5 },
    NG = { "Nigeria", 6 },
    NI = { "Nicaragua", 2 },
    NL = { "Netherlands", 1 },
    NO = { "Norway", 1 },
    NP = { "Nepal", 4 },
    NR = { "Nauru", 5 },
    NU = { "Niue", 5 },
    NZ = { "New Zealand", 5 },
    OM = { "Oman", 4 },
    PA = { "Panama", 2 },
    PE = { "Peru", 3 },
    PF = { "French Polynesia", 5 },
    PG = { "Papua New Guinea", 5 },
    PH = { "Philippines", 4 },
    PK = { "Pakistan", 4 },
    PL = { "Poland", 1 },
    PM = { "Saint Pierre and Miquelon", 2 },
    PN = { "Pitcairn Islands", 5 },
    PR = { "Puerto Rico", 2 },
    PS = { "Palestine", 4 },
    PT = { "Portugal", 1 },
    PW = { "Palau", 5 },
    PY = { "Paraguay", 3 },
    QA = { "Qatar", 4 },
    RE = { "Reunion", 6 },
    RO = { "Romania", 1 },
    RS = { "Serbia", 1 },
    RU = { "Russia", 1 },
    RW = { "Rwanda", 6 },
    SA = { "Saudi Arabia", 4 },
    SB = { "Solomon Islands", 5 },
    SC = { "Seychelles", 6 },
    SD = { "Sudan", 6 },
    SE = { "Sweden", 1 },
    SG = { "Singapore", 4 },
    SH = { "Saint Helena", 6 },
    SI = { "Slovenia", 1 },
    SJ = { "Svalbard and Jan Mayen", 1 },
    SK = { "Slovakia", 1 },
    SL = { "Sierra Leone", 6 },
    SM = { "San Marino", 1 },
    SN = { "Senegal", 6 },
    SO = { "Somalia", 6 },
    SR = { "Suriname", 3 },
    SS = { "South Sudan", 6 },
    ST = { "Sao Tome and Principe", 6 },
    SV = { "El Salvador", 2 },
    SX = { "Sint Maarten", 2 },
    SY = { "Syria", 4 },
    SZ = { "Eswatini", 6 },
    TC = { "Turks and Caicos Islands", 2 },
    TD = { "Chad", 6 },
    TF = { "French Southern Territories", 6 },
    TG = { "Togo", 6 },
    TH = { "Thailand", 4 },
    TJ = { "Tajikistan", 4 },
    TK = { "Tokelau", 5 },
    TL = { "Timor-Leste", 4 },
    TM = { "Turkmenistan", 4 },
    TN = { "Tunisia", 6 },
    TO = { "Tonga", 5 },
    TR = { "Turkey", 1 },
    TT = { "Trinidad and Tobago", 2 },
    TV = { "Tuvalu", 5 },
    TW = { "Taiwan", 4 },
    TZ = { "Tanzania", 6 },
    UA = { "Ukraine", 1 },
    UG = { "Uganda", 6 },
    UM = { "U.S. Outlying Islands", 5 },
    US = { "United States", 2 },
    UY = { "Uruguay", 3 },
    UZ = { "Uzbekistan", 4 },
    VA = { "Vatican City", 1 },
    VC = { "Saint Vincent and the Grenadines", 2 },
    VE = { "Venezuela", 3 },
    VG = { "British Virgin Islands", 2 },
    VI = { "U.S. Virgin Islands", 2 },
    VN = { "Vietnam", 4 },
    VU = { "Vanuatu", 5 },
    WF = { "Wallis and Futuna", 5 },
    WS = { "Samoa", 5 },
    XK = { "Kosovo", 1 },
    YE = { "Yemen", 4 },
    YT = { "Mayotte", 6 },
    ZA = { "South Africa", 6 },
    ZM = { "Zambia", 6 },
    ZW = { "Zimbabwe", 6 }
};
local Color3_fromRGB_ret = Color3.fromRGB(131, 216, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(167, 255, 135);
local Color3_new_ret4 = Color3.new(1, 1, 1);
local TweenInfo_new_ret = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret3 = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret4 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

local function countryCodeToEmoji(p64) -- Line: 334
    if not p64 or #p64 < 2 then
        return "🌐";
    end;

    local v65 = p64:upper();
    local v66 = v65:sub(1, 1);
    local v67 = v65:sub(2, 2);
    local v68 = v66:byte();
    local v69 = v67:byte();

    return not (v68 and (v69 and (v68 >= 65 and (v68 <= 90 and (v69 >= 65 and v69 <= 90))))) and "🌐" or utf8.char(127462 + (v68 - 65)) .. utf8.char(127462 + (v69 - 65));
end;

local function getColorFromPercentage(p70) -- Line: 358
    -- upvalues: Color3_new_ret (copy), Color3_new_ret2 (copy), Color3_new_ret3 (copy)
    local math_clamp_ret = math.clamp(p70 or 0, 0, 1);

    if math_clamp_ret <= 0.5 then
        return Color3_new_ret:Lerp(Color3_new_ret2, math_clamp_ret / 0.5);
    end;

    return Color3_new_ret2:Lerp(Color3_new_ret3, (math_clamp_ret - 0.5) / 0.5);
end;

local function Plural(p71: number, p72: string) -- Line: 369
    return `{p71} {p72}{p71 == 1 and "" or "S"}`;
end;

local function SearchWords(p73: string) -- Line: 373
    local v74 = {};

    for i in string.gmatch(string.lower(p73), "[%w_]+") do
        table.insert(v74, i);
    end;

    return v74;
end;

local function Subsequence(p75: string, p76: string) -- Line: 383
    local v77 = 1;

    for i = 1, #p76 do
        local v78;

        if string.byte(p76, i) == string.byte(p75, v77) then
            v77 = v77 + 1;

            if #p75 < v77 then
                return true;
            end;

            v78 = i;
        else
            v78 = i;
        end;
    end;

    return false;
end;

local function WordMatch(p79: any, p80: string) -- Line: 399
    -- upvalues: Subsequence (copy)
    for _, v in p79.Tokens do
        if string.find(v, p80, 1, true) then
            return true;
        end;

        if #p80 >= 3 and (string.byte(v) == string.byte(p80) and Subsequence(p80, v)) then
            return true;
        end;
    end;

    return false;
end;

local function FiltersActive() -- Line: 413
    -- upvalues: SearchWords (copy), u47 (copy), Players (copy)
    return #SearchWords(u47.Search) > 0 and true or (next(u47.Regions) ~= nil and true or (next(u47.Countries) ~= nil and true or (next(u47.Maps) ~= nil and true or (u47.MinPlayers > 0 and true or (u47.MaxPlayers < Players.MaxPlayers and true or u47.FriendsOnly)))));
end;

local function Passes(p81: any, p82: table) -- Line: 423
    -- upvalues: u47 (copy), WordMatch (copy)
    if next(u47.Regions) and not u47.Regions[p81.Continent] then
        return false;
    end;

    if next(u47.Countries) and not u47.Countries[p81.ServerRegion] then
        return false;
    end;

    if next(u47.Maps) and not u47.Maps[p81.Map] then
        return false;
    end;

    if p81.Amount < u47.MinPlayers or p81.Amount > u47.MaxPlayers then
        return false;
    end;

    if u47.FriendsOnly and p81.Friends == 0 then
        return false;
    end;

    for _, v in p82 do
        if not WordMatch(p81, v) then
            return false;
        end;
    end;

    return true;
end;

local function Compare(p83, p84) -- Line: 453
    -- upvalues: u47 (copy)
    local Sort = u47.Sort;

    if Sort == "Fewest Players" and p83.Amount ~= p84.Amount then
        return p83.Amount < p84.Amount;
    end;

    if Sort == "Free Slots" and p83.MaxPlayers - p83.Amount ~= p84.MaxPlayers - p84.Amount then
        return p83.MaxPlayers - p83.Amount > p84.MaxPlayers - p84.Amount;
    end;

    if Sort == "Most Friends" and p83.Friends ~= p84.Friends then
        return p83.Friends > p84.Friends;
    end;

    if Sort == "Region" and p83.Place ~= p84.Place then
        return p83.Place < p84.Place;
    end;

    if Sort == "Map" and p83.MapName ~= p84.MapName then
        return p83.MapName < p84.MapName;
    end;

    if p83.Amount == p84.Amount then
        return p83.Number < p84.Number;
    end;

    return p83.Amount > p84.Amount;
end;

local function SetFlags(p85, p86, p87) -- Line: 475
    table.clear(p85);

    for i, v in p86 do
        if v then
            local v88;

            if p87 then
                v88 = p87[i] or i;
            else
                v88 = i;
            end;

            p85[v88] = true;
        end;
    end;
end;

local function SetChipActive(p89: userdata, p90: boolean) -- Line: 485
    -- upvalues: u40 (copy), TweenService (copy), TweenInfo_new_ret2 (copy), Color3_fromRGB_ret (copy), Color3_new_ret4 (copy)
    if u40[p89] == p90 then
        return;
    end;

    u40[p89] = p90;
    TweenService:Create(p89.UIStroke, TweenInfo_new_ret2, {
        Color = p90 and Color3_fromRGB_ret or Color3_new_ret4,
        Transparency = p90 and 0.35 or 0.8
    }):Play();
    TweenService:Create(p89.AutoLeft.TextLabel, TweenInfo_new_ret2, {
        TextColor3 = p90 and Color3_fromRGB_ret or Color3_new_ret4
    }):Play();
end;

local function QueueRefresh(p91: boolean) -- Line: 496
    -- upvalues: u49 (ref), u48 (ref), u1 (copy)
    u49 = u49 or p91;

    if u48 then
        return;
    end;

    u48 = true;
    task.defer(function() -- Line: 505
        -- upvalues: u49 (ref), u48 (ref), u1 (ref)
        local v92 = u49;
        u48 = false;
        u49 = false;
        u1.Refresh(v92);
    end);
end;

local function SetFriendsOnly(p93: boolean) -- Line: 513
    -- upvalues: u47 (copy), u49 (ref), u48 (ref), u1 (copy)
    u47.FriendsOnly = p93;
    u49 = u49 or true;

    if u48 then
        return;
    end;

    u48 = true;
    task.defer(function() -- Line: 505
        -- upvalues: u49 (ref), u48 (ref), u1 (ref)
        local v94 = u49;
        u48 = false;
        u49 = false;
        u1.Refresh(v94);
    end);
end;

local function PlayersAt(p95: number) -- Line: 518
    -- upvalues: u30 (ref), Players (copy)
    local Track = u30.Hit.Track;
    local v96 = (p95 - Track.AbsolutePosition.X) / math.max(1, Track.AbsoluteSize.X);
    local v97 = math.clamp(v96, 0, 1) * Players.MaxPlayers;

    return math.round(v97);
end;

local function DragPlayers(p98: number) -- Line: 524
    -- upvalues: u30 (ref), Players (copy), u52 (ref), u47 (copy), u16 (ref), u1 (copy), u49 (ref), u48 (ref)
    local Track = u30.Hit.Track;
    local v99 = (p98 - Track.AbsolutePosition.X) / math.max(1, Track.AbsoluteSize.X);
    local v100 = math.clamp(v99, 0, 1) * Players.MaxPlayers;
    local math_round_ret = math.round(v100);

    if u52 == "MinPlayers" and u47.MaxPlayers < math_round_ret then
        u47.MinPlayers = u47.MaxPlayers;
        u52 = "MaxPlayers";
    elseif u52 == "MaxPlayers" and math_round_ret < u47.MinPlayers then
        u47.MaxPlayers = u47.MinPlayers;
        u52 = "MinPlayers";
    end;

    if u47[u52] == math_round_ret then
        return;
    end;

    u47[u52] = math_round_ret;
    u16.Play("UI.mainmenu_rollover");
    u1.DrawPlayers();
    u49 = u49 or false;

    if u48 then
        return;
    end;

    u48 = true;
    task.defer(function() -- Line: 505
        -- upvalues: u49 (ref), u48 (ref), u1 (ref)
        local v101 = u49;
        u48 = false;
        u49 = false;
        u1.Refresh(v101);
    end);
end;

local function RefreshFriends() -- Line: 547
    -- upvalues: LocalPlayer (copy), u37 (copy), u5 (ref), u35 (ref), u31 (ref), u1 (copy)
    local success, result = pcall(LocalPlayer.GetFriendsOnline, LocalPlayer, 200);

    if not success then
        return;
    end;

    table.clear(u37);
    local v102 = 0;

    for _, v in result do
        if v.GameId and u5.getMode(v.PlaceId) then
            u37[v.GameId] = (u37[v.GameId] or 0) + 1;
            v102 = v102 + 1;
        end;
    end;

    for _, v in u35 do
        for _, v2 in v do
            v2.Friends = u37[v2.JobId] or 0;
        end;
    end;

    u31.AutoLeft.TextLabel.Text = v102 > 0 and `{v102} Playing` or "None Playing";
    u1.Refresh(false);
end;

function u1.Draw() -- Line: 580
    -- upvalues: u14 (ref), u60 (ref), u11 (ref), u13 (ref), u1 (copy), u15 (ref), u22 (ref), u5 (ref), u16 (ref), TweenService (copy), TweenInfo_new_ret (copy), TeleportService (copy), Players (copy), u18 (copy), u19 (copy), u20 (copy), u17 (copy)
    u14 = u60:CreateTab(u11);
    u13 = u1.remodeMode(u14:CreatePage("Gamemodes", 1, false, false));
    u15 = u14:CreatePage("Servers", 2, true, false);
    u22 = u1.toolbar();
    u1.BindToolbar();

    for i, v in u5.Modes do
        local u103 = u1.modeTemplate(u13);
        local v104 = u14:CreatePage(i, 1, false, true, u15, false, function() -- Line: 590
            -- upvalues: u1 (ref), i (copy)
            u1.Open(i);
        end);
        local u105 = u1.quickGame(v104);
        local v106 = u1.remodeServer(v104);
        u103.ModeName.Text = i;
        u103.Background.Image = `rbxassetid://{v.Thumbnail}`;
        u103.InGame.Text = "0 in Game";
        u103.Parent = u13;
        u103.MouseEnter:Connect(function() -- Line: 604
            -- upvalues: u16 (ref), TweenService (ref), u103 (copy), TweenInfo_new_ret (ref)
            u16.Play("UI.submenu_scroll");
            TweenService:Create(u103.Background, TweenInfo.new(0.5), {
                ImageTransparency = 0
            }):Play();
            TweenService:Create(u103.ModeName, TweenInfo_new_ret, {
                Position = UDim2.fromScale(0.5, 0.74)
            }):Play();
            TweenService:Create(u103.InGame, TweenInfo_new_ret, {
                TextTransparency = 0.2
            }):Play();
        end);
        u103.MouseLeave:Connect(function() -- Line: 612
            -- upvalues: TweenService (ref), u103 (copy), TweenInfo_new_ret (ref)
            TweenService:Create(u103.Background, TweenInfo.new(0.5), {
                ImageTransparency = 0.6
            }):Play();
            TweenService:Create(u103.ModeName, TweenInfo_new_ret, {
                Position = UDim2.fromScale(0.5, 0.761219)
            }):Play();
            TweenService:Create(u103.InGame, TweenInfo_new_ret, {
                TextTransparency = 0.5
            }):Play();
        end);
        u103.MouseButton1Click:Connect(function() -- Line: 618
            -- upvalues: u16 (ref), u14 (ref), i (copy)
            u16.Play("UI.submenu_click");
            u14:OpenTab("Servers");
            u14:OpenTab(i);
        end);
        u105.MouseEnter:Connect(function() -- Line: 625
            -- upvalues: u16 (ref), TweenService (ref), u105 (copy)
            u16.Play("UI.submenu_scroll");
            TweenService:Create(u105, TweenInfo.new(0.5), {
                BackgroundColor3 = Color3.fromRGB(48, 66, 98)
            }):Play();
        end);
        u105.MouseLeave:Connect(function() -- Line: 630
            -- upvalues: TweenService (ref), u105 (copy)
            TweenService:Create(u105, TweenInfo.new(0.5), {
                BackgroundColor3 = Color3.fromRGB(29, 38, 58)
            }):Play();
        end);
        u105.MouseButton1Click:Connect(function() -- Line: 634
            -- upvalues: u16 (ref), TeleportService (ref), v (copy), Players (ref)
            u16.Play("UI.submenu_click");
            TeleportService:Teleport(v.PlaceId, Players.LocalPlayer);
        end);
        u18[i] = v106;
        u19[i] = v104;
        u20[i] = v104.Empty;
        u17[i] = u103;
    end;

    u1.Update();
end;

function u1.BindToolbar() -- Line: 648
    -- upvalues: u22 (ref), u23 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u25 (ref), u24 (ref), u5 (ref), u44 (copy), u43 (copy), u8 (ref), u62 (copy), u47 (copy), u49 (ref), u48 (ref), u1 (copy), u32 (ref), u61 (copy), u33 (ref), u41 (copy), u42 (copy), u34 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), Color3_new_ret4 (copy), TweenInfo_new_ret (copy), u16 (ref), Players (copy), u52 (ref), u53 (ref), DragPlayers (copy), u4 (ref), UserInputService (copy), SetFriendsOnly (copy), Color3_fromRGB_ret (copy)
    local Filters = u22.Filters;
    u23 = Filters.Search;
    u26 = Filters.Sort;
    u27 = Filters.Region;
    u28 = Filters.Country;
    u29 = Filters.Map;
    u30 = Filters.Players;
    u31 = Filters.Friends;
    u25 = Filters.Reset;
    u24 = u22.Status;

    for i, v in u5.Maps do
        u44[v.Name] = i;
        table.insert(u43, v.Name);
    end;

    table.sort(u43);
    u8.NewDropDown(false, u62, "Most Players", "Most Players", function(p107) -- Line: 670
        -- upvalues: u47 (ref), u49 (ref), u48 (ref), u1 (ref)
        u47.Sort = p107;
        u49 = u49 or true;

        if u48 then
            return;
        end;

        u48 = true;
        task.defer(function() -- Line: 505
            -- upvalues: u49 (ref), u48 (ref), u1 (ref)
            local v108 = u49;
            u48 = false;
            u49 = false;
            u1.Refresh(v108);
        end);
    end, u26);
    u32 = select(2, u8.NewMultiDropDown(u61, {}, {}, function(p109) -- Line: 675
        -- upvalues: u47 (ref), u1 (ref), u49 (ref), u48 (ref)
        local Regions = u47.Regions;
        table.clear(Regions);

        for i, v in p109 do
            if v then
                Regions[i] = true;
            end;
        end;

        u1.DrawCountries();
        u49 = u49 or true;

        if u48 then
            return;
        end;

        u48 = true;
        task.defer(function() -- Line: 505
            -- upvalues: u49 (ref), u48 (ref), u1 (ref)
            local v110 = u49;
            u48 = false;
            u49 = false;
            u1.Refresh(v110);
        end);
    end, nil, nil, nil, nil, u27));
    u33 = select(2, u8.NewMultiDropDown(u41, {}, {}, function(p111) -- Line: 681
        -- upvalues: u47 (ref), u42 (ref), u49 (ref), u48 (ref), u1 (ref)
        local Countries = u47.Countries;
        local v112 = u42;
        table.clear(Countries);

        for i, v in p111 do
            if v then
                local v113;

                if v112 then
                    v113 = v112[i] or i;
                else
                    v113 = i;
                end;

                Countries[v113] = true;
            end;
        end;

        u49 = u49 or true;

        if u48 then
            return;
        end;

        u48 = true;
        task.defer(function() -- Line: 505
            -- upvalues: u49 (ref), u48 (ref), u1 (ref)
            local v114 = u49;
            u48 = false;
            u49 = false;
            u1.Refresh(v114);
        end);
    end, nil, nil, nil, nil, u28));
    u34 = select(2, u8.NewMultiDropDown(u43, {}, {}, function(p115) -- Line: 686
        -- upvalues: u47 (ref), u44 (ref), u49 (ref), u48 (ref), u1 (ref)
        local Maps = u47.Maps;
        local v116 = u44;
        table.clear(Maps);

        for i, v in p115 do
            if v then
                local v117;

                if v116 then
                    v117 = v116[i] or i;
                else
                    v117 = i;
                end;

                Maps[v117] = true;
            end;
        end;

        u49 = u49 or true;

        if u48 then
            return;
        end;

        u48 = true;
        task.defer(function() -- Line: 505
            -- upvalues: u49 (ref), u48 (ref), u1 (ref)
            local v118 = u49;
            u48 = false;
            u49 = false;
            u1.Refresh(v118);
        end);
    end, nil, nil, nil, nil, u29));

    for _, v in {
        u26,
        u27,
        u28,
        u29,
        u30,
        u31
    } do
        v.MouseEnter:Connect(function() -- Line: 692
            -- upvalues: TweenService (ref), v (copy), TweenInfo_new_ret2 (ref), Color3_new_ret4 (ref)
            TweenService:Create(v, TweenInfo_new_ret2, {
                BackgroundTransparency = 0.94,
                BackgroundColor3 = Color3_new_ret4
            }):Play();
            TweenService:Create(v.AutoLeft.Caption, TweenInfo_new_ret2, {
                TextTransparency = 0.15
            }):Play();
        end);
        v.MouseLeave:Connect(function() -- Line: 697
            -- upvalues: TweenService (ref), v (copy), TweenInfo_new_ret2 (ref)
            TweenService:Create(v, TweenInfo_new_ret2, {
                BackgroundTransparency = 1
            }):Play();
            TweenService:Create(v.AutoLeft.Caption, TweenInfo_new_ret2, {
                TextTransparency = 0.5
            }):Play();
        end);
    end;

    local TextBox = u23.TextBox;
    TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 707
        -- upvalues: u47 (ref), TextBox (copy), u1 (ref), u49 (ref), u48 (ref)
        u47.Search = TextBox.Text;
        u1.ShowClear(TextBox.Text ~= "");
        u49 = u49 or false;

        if u48 then
            return;
        end;

        u48 = true;
        task.defer(function() -- Line: 505
            -- upvalues: u49 (ref), u48 (ref), u1 (ref)
            local v119 = u49;
            u48 = false;
            u49 = false;
            u1.Refresh(v119);
        end);
    end);
    TextBox.Focused:Connect(function() -- Line: 714
        -- upvalues: TweenService (ref), u23 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u23.Line, TweenInfo_new_ret, {
            BackgroundTransparency = 0.1
        }):Play();
    end);
    TextBox.FocusLost:Connect(function() -- Line: 718
        -- upvalues: TweenService (ref), u23 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u23.Line, TweenInfo_new_ret, {
            BackgroundTransparency = 0.6
        }):Play();
    end);
    u23.Clear.MouseButton1Click:Connect(function() -- Line: 722
        -- upvalues: u16 (ref), TextBox (copy)
        u16.Play("UI.generic_press");
        TextBox.Text = "";
    end);
    u30.Hit.InputBegan:Connect(function(p120) -- Line: 729
        -- upvalues: u30 (ref), Players (ref), u47 (ref), u52 (ref), u53 (ref), u1 (ref), DragPlayers (ref), u4 (ref), UserInputService (ref)
        if p120.UserInputType ~= Enum.UserInputType.MouseButton1 and p120.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local Track = u30.Hit.Track;
        local v121 = (p120.Position.X - Track.AbsolutePosition.X) / math.max(1, Track.AbsoluteSize.X);
        local v122 = math.clamp(v121, 0, 1) * Players.MaxPlayers;
        local math_round_ret = math.round(v122);
        local math_abs_ret = math.abs(math_round_ret - u47.MinPlayers);
        local math_abs_ret2 = math.abs(math_round_ret - u47.MaxPlayers);
        u52 = (math_abs_ret < math_abs_ret2 or math_abs_ret == math_abs_ret2 and math_round_ret < u47.MinPlayers) and "MinPlayers" or "MaxPlayers";
        u53 = p120;
        u1.DrawPlayers();
        DragPlayers(p120.Position.X);
        u4:Add("PlayersDrag", UserInputService.InputChanged:Connect(function(p123) -- Line: 743
            -- upvalues: u53 (ref), DragPlayers (ref)
            if p123.UserInputType == Enum.UserInputType.MouseMovement or p123 == u53 then
                DragPlayers(p123.Position.X);
            end;
        end));
    end);
    UserInputService.InputEnded:Connect(function(p124) -- Line: 750
        -- upvalues: u52 (ref), u53 (ref), u4 (ref), u1 (ref)
        if not u52 then
            return;
        end;

        if p124 == u53 or p124.UserInputType == Enum.UserInputType.MouseButton1 then
            u52 = nil;
            u53 = nil;
            u4:Remove("PlayersDrag");
            u1.DrawPlayers();
        end;
    end);
    u8.ToggleUpdate("Server Browser Friends Only", u31, SetFriendsOnly, false, false, true);
    u31.MouseButton1Click:Connect(function() -- Line: 767
        -- upvalues: u8 (ref), u31 (ref), SetFriendsOnly (ref)
        u8.ToggleUpdate("Server Browser Friends Only", u31, SetFriendsOnly);
    end);
    u25.MouseEnter:Connect(function() -- Line: 773
        -- upvalues: TweenService (ref), u25 (ref), TweenInfo_new_ret2 (ref), Color3_fromRGB_ret (ref)
        TweenService:Create(u25, TweenInfo_new_ret2, {
            TextColor3 = Color3_fromRGB_ret
        }):Play();
    end);
    u25.MouseLeave:Connect(function() -- Line: 777
        -- upvalues: TweenService (ref), u25 (ref), TweenInfo_new_ret2 (ref), Color3_new_ret4 (ref)
        TweenService:Create(u25, TweenInfo_new_ret2, {
            TextColor3 = Color3_new_ret4
        }):Play();
    end);
    u25.MouseButton1Click:Connect(function() -- Line: 781
        -- upvalues: u16 (ref), u1 (ref)
        u16.Play("UI.generic_press");
        u1.ResetFilters();
    end);
    local Current = u24.Current;
    Current.Info:GetPropertyChangedSignal("TextBounds"):Connect(function() -- Line: 790
        -- upvalues: Current (copy)
        Current.Dot.Position = UDim2.new(1, -Current.Info.TextBounds.X - 8, 0.5, 0);
    end);
    TweenService:Create(Current.Dot, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.75
    }):Play();
    u1.DrawPlayers();
end;

function u1.Update() -- Line: 799
    -- upvalues: u45 (ref), u21 (ref), u7 (ref), u63 (copy), u5 (ref), u61 (copy), u37 (copy), SearchWords (copy), u36 (copy), countryCodeToEmoji (copy), u35 (ref), u1 (copy)
    local v125 = {};
    u45 = nil;

    for _, v in u21 do
        local v126 = u7.Gamemodes[v.Mode];
        local v127 = u7.Maps[v.Map];
        local v128 = u7.Countries[v.Country] or "";
        local v129 = u63[v128];

        if not v125[v126] then
            v125[v126] = {};
        end;

        local v130 = u5.Maps[v127];
        local v131 = {
            JobId = v.JobId,
            Number = #v125[v126] + 1,
            Amount = v.Amount,
            Map = v127
        };

        if v130 then
            v127 = v130.Name or v127;
        end;

        v131.MapName = v127;

        if v130 then
            v130 = v130.Thumbnail;
        end;

        v131.Thumbnail = v130;
        v131.MaxPlayers = v.MaxPlayers;
        v131.ServerRegion = v128;
        v131.Country = v129 and (v129[1] or "") or "";
        v131.Continent = v129 and u61[v129[2]] or "";
        v131.Friends = u37[v.JobId] or 0;
        v131.Current = v.JobId == game.JobId;
        v131.Place = `{v131.Continent} {v131.Country}`;
        v131.Tokens = SearchWords((`{v131.Number} {v131.Map} {v131.MapName} {v131.ServerRegion} {v131.Place}`));

        if v131.Country ~= "" then
            u36[v131.ServerRegion] = {
                Name = v131.Country,
                Continent = v131.Continent,
                Label = `{countryCodeToEmoji(v131.ServerRegion)} {v131.Country}`
            };
        end;

        if v131.Current then
            u45 = v131;
        end;

        table.insert(v125[v126], v131);
    end;

    u35 = v125;
    u1.DrawCountries();
    u1.Refresh(false);
end;

function u1.Refresh(p132: boolean) -- Line: 854
    -- upvalues: SearchWords (copy), u47 (copy), u17 (copy), u18 (copy), u35 (ref), Passes (copy), Compare (copy), u1 (copy), u9 (ref), u39 (copy), u20 (copy), u46 (ref)
    local v133 = SearchWords(u47.Search);

    for i, v in u17 do
        local v134 = u18[i];
        local v135 = u35[i] or {};
        local v136 = i;
        local v137 = 0;
        local v138 = 0;
        local v139 = {};

        for _, v2 in v135 do
            v137 = v137 + v2.Amount;

            if Passes(v2, v133) then
                v138 = v138 + v2.Amount;
                table.insert(v139, v2);
            end;
        end;

        table.sort(v139, Compare);
        local v140 = {};

        for _, child in v134:GetChildren() do
            if child:IsA("ImageButton") then
                table.insert(v140, child);
            end;
        end;

        local v141 = 0;

        for i2, v2 in v139 do
            local v142 = v140[i2] or u1.NewServer(v134, v136);

            if p132 or not v142.Visible then
                u9.Reveal(u39[v142], math.min(v141, 12) * 0.03);
                v141 = v141 + 1;
            end;

            u1.DrawServer(v142, v2, i2);
        end;

        for i2 = #v139 + 1, #v140 do
            v140[i2].Visible = false;
            local _ = i2;
        end;

        v.InGame.Text = `{v137} in Game`;
        u1.DrawEmpty(u20[v136], #v135, #v139);

        if v136 == u46 then
            u1.DrawStatus(#v135, #v139, v137, v138);
        end;
    end;

    u1.DrawChips();
    u1.DrawCurrent();
end;

function u1.NewServer(p143: any, u144: string) -- Line: 912
    -- upvalues: u1 (copy), u39 (copy), u9 (ref), u16 (ref), TweenService (copy), u38 (copy), TeleportService (copy), u5 (ref), Players (copy)
    local u145 = u1.serverTemplate(p143);
    u39[u145] = u9.Capture(u145);
    u145.MouseEnter:Connect(function() -- Line: 917
        -- upvalues: u16 (ref), TweenService (ref), u145 (copy)
        u16.Play("UI.submenu_scroll");
        TweenService:Create(u145.Background, TweenInfo.new(0.35), {
            ImageTransparency = 0
        }):Play();
    end);
    u145.MouseLeave:Connect(function() -- Line: 922
        -- upvalues: TweenService (ref), u145 (copy)
        TweenService:Create(u145.Background, TweenInfo.new(0.35), {
            ImageTransparency = 0.6
        }):Play();
    end);
    u145.MouseButton1Click:Connect(function() -- Line: 926
        -- upvalues: u38 (ref), u145 (copy), u16 (ref), TeleportService (ref), u5 (ref), u144 (copy), Players (ref)
        local v146 = u38[u145];

        if v146.Current then
            return;
        end;

        u16.Play("UI.submenu_click");
        TeleportService:TeleportToPlaceInstance(u5.Modes[u144].PlaceId, v146.JobId, Players.LocalPlayer);
    end);

    return u145;
end;

function u1.DrawServer(p147, p148, p149) -- Line: 940
    -- upvalues: u38 (copy), Color3_fromRGB_ret (copy), Color3_new_ret4 (copy), countryCodeToEmoji (copy), TweenService (copy), TweenInfo_new_ret (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), Color3_new_ret3 (copy)
    local v150 = p148.Amount / math.max(1, p148.MaxPlayers);
    u38[p147] = p148;

    if p148.Thumbnail then
        p147.Background.Image = `rbxassetid://{p148.Thumbnail}`;
    end;

    p147.Title.Text = p148.Current and `#{p148.Number} CURRENT` or `#{p148.Number} PUBLIC`;
    p147.Title.TextColor3 = p148.Current and Color3_fromRGB_ret or Color3_new_ret4;
    p147.Info.Text = `{p148.Amount}/{p148.MaxPlayers} | {p148.Map or ""}`;
    p147.Country.Text = countryCodeToEmoji(p148.ServerRegion);
    local Friends = p148.Friends;
    p147.Friends.Text = `{Friends} FRIEND{Friends == 1 and "" or "S"}`;
    p147.Friends.Visible = p148.Friends > 0;
    p147.UIStroke.Enabled = p148.Current;
    local Bar = p147.Bar.Bar;
    local v151 = {
        Size = UDim2.fromScale(1, (math.clamp(v150, 0, 1)))
    };
    local math_clamp_ret = math.clamp(v150 or 0, 0, 1);
    local v152;

    if math_clamp_ret <= 0.5 then
        v152 = Color3_new_ret:Lerp(Color3_new_ret2, math_clamp_ret / 0.5);
    else
        v152 = Color3_new_ret2:Lerp(Color3_new_ret3, (math_clamp_ret - 0.5) / 0.5);
    end;

    v151.BackgroundColor3 = v152;
    TweenService:Create(Bar, TweenInfo_new_ret, v151):Play();
    p147.LayoutOrder = p149;
    p147.Visible = true;
end;

function u1.DrawEmpty(p153: userdata, p154: number, p155: number) -- Line: 966
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    local v156 = p154 == 0 and "NO SERVERS ONLINE" or "NO SERVERS MATCH YOUR FILTERS";
    local v157 = p155 == 0;

    if v157 and (not p153.Visible or p153.Text ~= v156) then
        p153.TextTransparency = 1;
        TweenService:Create(p153, TweenInfo_new_ret, {
            TextTransparency = 0.4
        }):Play();
    end;

    p153.Text = v156;
    p153.Visible = v157;
end;

function u1.DrawStatus(p158: number, p159: number, p160: number, p161: number) -- Line: 979
    -- upvalues: u24 (ref), FiltersActive (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local Count = u24.Count;
    local v162 = FiltersActive() and `{p159} OF {`{p158} SERVER{p158 == 1 and "" or "S"}`}  ·  {`{p161} PLAYER{p161 == 1 and "" or "S"}`}` or `{`{p158} SERVER{p158 == 1 and "" or "S"}`}  ·  {`{p160} PLAYER{p160 == 1 and "" or "S"}`}`;

    if Count.Text ~= v162 then
        Count.Text = v162;
        Count.TextTransparency = 0.8;
        TweenService:Create(Count, TweenInfo_new_ret, {
            TextTransparency = 0.35
        }):Play();
    end;
end;

function u1.DrawCurrent() -- Line: 990
    -- upvalues: GameStats (copy), u63 (copy), countryCodeToEmoji (copy), u5 (ref), u45 (ref), Players (copy), u24 (ref)
    local Attribute = GameStats:GetAttribute("ServerRegion");
    local v163 = u63[Attribute];
    local v164 = countryCodeToEmoji(Attribute);
    local v165 = u5.Maps[GameStats:GetAttribute("Map")];
    local v166 = {};

    if u45 then
        local v167 = `#{u45.Number}`;
        table.insert(v166, v167);
    end;

    if v163 then
        v164 = `{v164} {v163[1]}` or v164;
    end;

    table.insert(v166, v164);

    if v165 then
        table.insert(v166, v165.Name);
    end;

    local v168 = `{#Players:GetPlayers()}/{Players.MaxPlayers}`;
    table.insert(v166, v168);
    u24.Current.Info.Text = `<font color="#83D8FF">CURRENT SERVER</font>   {table.concat(v166, "  ·  ")}`;
end;

function u1.DrawCountries() -- Line: 1012
    -- upvalues: u36 (copy), u47 (copy), u41 (copy), u42 (copy), u33 (ref), u28 (ref), u1 (copy)
    local v169 = {};
    local v170 = {};

    for i, v in u36 do
        if u47.Regions[v.Continent] then
            table.insert(v169, i);
        end;
    end;

    table.sort(v169, function(p171, p172) -- Line: 1021
        -- upvalues: u36 (ref)
        return u36[p171].Name < u36[p172].Name;
    end);
    table.clear(u41);
    table.clear(u42);

    for _, v in v169 do
        local Label = u36[v].Label;
        table.insert(u41, Label);
        u42[Label] = v;

        if u47.Countries[v] then
            table.insert(v170, Label);
        end;
    end;

    for i in u47.Countries do
        if not table.find(v169, i) then
            u47.Countries[i] = nil;
        end;
    end;

    u33.SetValue(v170, true);
    u28.Interactable = #u41 > 0;
    u1.ShowCountry(next(u47.Regions) ~= nil);
end;

function u1.DrawPlayers() -- Line: 1051
    -- upvalues: u47 (copy), Players (copy), u30 (ref), TweenService (copy), TweenInfo_new_ret3 (copy), u52 (ref), Color3_fromRGB_ret (copy), Color3_new_ret4 (copy)
    local v173 = u47.MinPlayers / Players.MaxPlayers;
    local v174 = u47.MaxPlayers / Players.MaxPlayers;
    local Track = u30.Hit.Track;
    TweenService:Create(Track.Fill, TweenInfo_new_ret3, {
        Position = UDim2.fromScale(v173, 0.5),
        Size = UDim2.fromScale(v174 - v173, 1)
    }):Play();
    TweenService:Create(Track.Low, TweenInfo_new_ret3, {
        Position = UDim2.fromScale(v173, 0.5),
        BackgroundColor3 = u52 == "MinPlayers" and Color3_fromRGB_ret or Color3_new_ret4
    }):Play();
    TweenService:Create(Track.High, TweenInfo_new_ret3, {
        Position = UDim2.fromScale(v174, 0.5),
        BackgroundColor3 = u52 == "MaxPlayers" and Color3_fromRGB_ret or Color3_new_ret4
    }):Play();
    u30.AutoLeft.TextLabel.Text = u47.MinPlayers == 0 and u47.MaxPlayers == Players.MaxPlayers and "Any" or (u47.MinPlayers == u47.MaxPlayers and tostring(u47.MinPlayers) or `{u47.MinPlayers}-{u47.MaxPlayers}`);
end;

function u1.DrawChips() -- Line: 1064
    -- upvalues: SetChipActive (copy), u27 (ref), u47 (copy), u28 (ref), u29 (ref), u30 (ref), Players (copy), u31 (ref), u1 (copy), FiltersActive (copy)
    SetChipActive(u27, next(u47.Regions) ~= nil);
    SetChipActive(u28, next(u47.Countries) ~= nil);
    SetChipActive(u29, next(u47.Maps) ~= nil);
    SetChipActive(u30, u47.MinPlayers > 0 and true or u47.MaxPlayers < Players.MaxPlayers);
    SetChipActive(u31, u47.FriendsOnly);
    u1.ShowReset((FiltersActive()));
end;

function u1.ShowCountry(p175: boolean) -- Line: 1074
    -- upvalues: u51 (ref), u28 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if u51 == p175 then
        return;
    end;

    u51 = p175;

    if p175 then
        u28.Visible = true;
    end;

    local v176 = TweenService:Create(u28, TweenInfo_new_ret, {
        Size = UDim2.fromScale(p175 and 0.105 or 0, 0.84)
    });
    v176.Completed:Connect(function(p177) -- Line: 1087
        -- upvalues: u51 (ref), u28 (ref)
        if p177 == Enum.PlaybackState.Completed and not u51 then
            u28.Visible = false;
        end;
    end);
    v176:Play();
end;

function u1.ShowReset(p178: boolean) -- Line: 1096
    -- upvalues: u50 (ref), u25 (ref), TweenService (copy), TweenInfo_new_ret2 (copy)
    if u50 == p178 then
        return;
    end;

    u50 = p178;

    if p178 then
        u25.Visible = true;
    end;

    local v179 = TweenService:Create(u25, TweenInfo_new_ret2, {
        TextTransparency = p178 and 0.2 or 1
    });
    v179.Completed:Connect(function(p180) -- Line: 1109
        -- upvalues: u50 (ref), u25 (ref)
        if p180 == Enum.PlaybackState.Completed and not u50 then
            u25.Visible = false;
        end;
    end);
    v179:Play();
    TweenService:Create(u25.UIStroke, TweenInfo_new_ret2, {
        Transparency = p178 and 0.8 or 1
    }):Play();
end;

function u1.ShowClear(p181: boolean) -- Line: 1119
    -- upvalues: u23 (ref), TweenService (copy), TweenInfo_new_ret2 (copy)
    local Clear = u23.Clear;

    if p181 and not Clear.Visible then
        Clear.TextTransparency = 1;
        TweenService:Create(Clear, TweenInfo_new_ret2, {
            TextTransparency = 0.4
        }):Play();
    end;

    Clear.Visible = p181;
end;

function u1.ResetFilters() -- Line: 1130
    -- upvalues: u8 (ref), u47 (copy), Players (copy), u32 (ref), u34 (ref), u23 (ref), u31 (ref), SetFriendsOnly (copy), u1 (copy), u49 (ref), u48 (ref)
    u8.DropDeactive("GLOBAL");
    table.clear(u47.Regions);
    table.clear(u47.Countries);
    table.clear(u47.Maps);
    local MaxPlayers = Players.MaxPlayers;
    u47.MinPlayers = 0;
    u47.MaxPlayers = MaxPlayers;
    u32.SetValue({}, true);
    u34.SetValue({}, true);
    u23.TextBox.Text = "";
    u8.ToggleUpdate("Server Browser Friends Only", u31, SetFriendsOnly, false, true, true);
    u1.DrawCountries();
    u1.DrawPlayers();
    u49 = u49 or true;

    if u48 then
        return;
    end;

    u48 = true;
    task.defer(function() -- Line: 505
        -- upvalues: u49 (ref), u48 (ref), u1 (ref)
        local v182 = u49;
        u48 = false;
        u49 = false;
        u1.Refresh(v182);
    end);
end;

function u1.SearchOpen() -- Line: 1152
    -- upvalues: u23 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    u23.Line.Size = UDim2.new(0, 0, 0, 2);
    u23.Icon.ImageTransparency = 1;
    u23.TextBox.TextTransparency = 1;
    TweenService:Create(u23.Line, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        Size = UDim2.new(1, 0, 0, 2)
    }):Play();
    TweenService:Create(u23.Icon, TweenInfo_new_ret, {
        ImageTransparency = 0
    }):Play();
    TweenService:Create(u23.TextBox, TweenInfo_new_ret, {
        TextTransparency = 0
    }):Play();
end;

function u1.Open(p183: string) -- Line: 1162
    -- upvalues: u46 (ref), u22 (ref), u19 (copy), u56 (ref), TweenService (copy), TweenInfo_new_ret4 (copy), u1 (copy)
    u46 = p183;
    u22.Parent = u19[p183];
    u22.GroupTransparency = 1;
    u22.Position = UDim2.new(0.5, 0, u56, 10);
    TweenService:Create(u22, TweenInfo_new_ret4, {
        GroupTransparency = 0,
        Position = UDim2.new(0.5, 0, u56, 0)
    }):Play();
    u1.SearchOpen();
    u1.Refresh(true);
end;

function u1.Init(p184) -- Line: 1177
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u60 (ref), u16 (ref), u8 (ref), u9 (ref), u10 (ref), u55 (ref), u56 (ref), u57 (ref), u58 (ref), u59 (ref)
    u2 = p184:GetModule("Gui");
    u3 = u2.GetComponent("MainMenu");
    u4 = p184:GetModule("Maid").new();
    u5 = p184:GetModule("GamemodesData");
    u6 = p184:GetModule("Network");
    u7 = p184:GetModule("Enums");
    u60 = u2.GetComponent("Tabs");
    u16 = p184:GetModule("SoundManager");
    u8 = p184:GetModule("Settings");
    u9 = u2.GetComponent("AnalyticsMotion");
    u10 = p184:GetModule("GetUserPlatform");
    u55 = u10() == "Mobile";
    u56 = u55 and 0.154 or 0.126;
    u57 = u55 and 0.08 or 0.052;
    u58 = u55 and 0.034 or 0.026;
    u59 = u56 + u57 + u58 + 0.014;
end;

function u1.Start(p185) -- Line: 1197
    -- upvalues: u11 (ref), u3 (ref), u1 (copy), u21 (ref), u6 (ref), RefreshFriends (copy), u46 (ref), u19 (copy), u54 (ref)
    u11 = u3.AddTab("Gamemodes");
    u3.AddButton("Gamemodes", u11, UDim2.fromScale(0.075, 0.032), UDim2.fromScale(0.632248, 0.015));
    u1.new();
    u21 = {};
    u1.Draw();
    u6.Gui.ServerListResult.On(function(p186) -- Line: 1206
        -- upvalues: u21 (ref), u1 (ref)
        u21 = p186;
        u1.Update();
    end);
    u6.Gui.RequestServerList.Fire();
    u11:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1213
        -- upvalues: u11 (ref), u6 (ref), RefreshFriends (ref), u46 (ref), u19 (ref), u1 (ref)
        if u11.Visible then
            u6.Gui.RequestServerList.Fire();
            task.spawn(RefreshFriends);

            if u46 and u19[u46].Visible then
                u1.Open(u46);
            end;
        end;
    end);
    task.spawn(function() -- Line: 1224
        -- upvalues: u11 (ref), u6 (ref), u54 (ref), RefreshFriends (ref)
        while task.wait(5) do
            if u11.Visible then
                u6.Gui.RequestServerList.Fire();
                u54 = u54 + 1;

                if u54 % 6 == 0 then
                    task.spawn(RefreshFriends);
                end;
            end;
        end;
    end);
end;

function u1.new() -- Line: 1241
end;

function u1.modeTemplate(p187) -- Line: 1245
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ModeTemplate";
    ImageButton.Active = false;
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(34, 39, 46);
    ImageButton.Position = UDim2.fromScale(-0.000287285, 0.0103509);
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(0.0994573, 0.528889);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.06, 0);
    UICorner.Parent = ImageButton;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Background";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://119939440047927";
    ImageLabel.ImageTransparency = 0.6;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Crop;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.06, 0);
    UICorner2.Parent = ImageLabel;
    ImageLabel.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ModeName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.761219);
    TextLabel.Size = UDim2.fromScale(0.8, 0.1);
    TextLabel.Text = "BUNNY HOP";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.ZIndex = 343;
    TextLabel.Parent = ImageButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "InGame";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.888366);
    TextLabel2.Size = UDim2.fromScale(0.8, 0.0683657);
    TextLabel2.Text = "100 in game";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextTransparency = 0.5;
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = ImageButton;
    ImageButton.Parent = p187;

    return ImageButton;
end;

function u1.serverTemplate(p188) -- Line: 1323
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ServerTemplate";
    ImageButton.Active = false;
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(34, 39, 46);
    ImageButton.Position = UDim2.fromScale(-0.000287285, 0.0103509);
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(0.0994573, 0.528889);
    ImageButton.Visible = false;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.06, 0);
    UICorner.Parent = ImageButton;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.Parent = ImageButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3_fromRGB_ret;
    UIStroke.Enabled = false;
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.2;
    UIStroke.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Background";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://119939440047927";
    ImageLabel.ImageTransparency = 0.6;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Crop;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.06, 0);
    UICorner2.Parent = ImageLabel;
    ImageLabel.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.174359, 0.0999999);
    TextLabel.Size = UDim2.fromScale(0.671796, 0.35);
    TextLabel.Text = "#1 CASUAL";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 343;
    TextLabel.Parent = ImageButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Info";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.468133, 0.59);
    TextLabel2.Size = UDim2.fromScale(0.756044, 0.24);
    TextLabel2.Text = "12/16 | de_dust2";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextTransparency = 0.5;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = ImageButton;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Friends";
    TextLabel3.AnchorPoint = Vector2.new(1, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.95, 0.14);
    TextLabel3.Size = UDim2.fromScale(0.3, 0.26);
    TextLabel3.Text = "1 FRIEND";
    TextLabel3.TextColor3 = Color3_fromRGB_ret2;
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.Visible = false;
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = ImageButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Bar";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.25;
    Frame.Position = UDim2.fromScale(0.0516498, 0.582093);
    Frame.Size = UDim2.fromScale(0.0183148, 0.263267);
    Frame.ZIndex = 343;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(1, 0);
    UICorner3.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Bar";
    Frame2.AnchorPoint = Vector2.new(0.5, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(234, 255, 142);
    Frame2.Position = UDim2.fromScale(0.5, 1);
    Frame2.Size = UDim2.fromScale(1, 0.5);
    Frame2.ZIndex = 343;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(1, 0);
    UICorner4.Parent = Frame2;
    Frame2.Parent = Frame;
    Frame.Parent = ImageButton;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Country";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.0424924, 0.0999999);
    TextLabel4.Size = UDim2.fromScale(0.0930465, 0.35);
    TextLabel4.Text = "🇺🇦";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 343;
    TextLabel4.Parent = ImageButton;
    ImageButton.Parent = p188;

    return ImageButton;
end;

function u1.quickGame(p189) -- Line: 1480
    -- upvalues: u12 (ref)
    u12 = Instance.new("ImageButton");
    u12.Name = "QuickGame";
    u12.Active = false;
    u12.AnchorPoint = Vector2.new(0.5, 0);
    u12.AutoButtonColor = false;
    u12.BackgroundColor3 = Color3.fromRGB(29, 38, 58);
    u12.BackgroundTransparency = 0.05;
    u12.Position = UDim2.fromScale(0.5, 0.89836);
    u12.Selectable = false;
    u12.Size = UDim2.fromScale(0.104751, 0.064371);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.277188, 0.5);
    TextLabel.Size = UDim2.fromScale(0.652562, 0.4);
    TextLabel.Text = "Quick game";
    TextLabel.TextColor3 = Color3.fromRGB(110, 147, 255);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 343;
    TextLabel.Parent = u12;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = u12;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://103848798915389";
    ImageLabel.ImageColor3 = Color3.fromRGB(110, 147, 255);
    ImageLabel.Position = UDim2.fromScale(0.0510796, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = u12;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 2.75;
    UIAspectRatioConstraint.Parent = u12;
    u12.Parent = p189;

    return u12;
end;

function u1.remodeMode(p190) -- Line: 1537
    p190.Name = "Modes";
    p190.Active = true;
    p190.AnchorPoint = Vector2.new(0.5, 1);
    p190.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    p190.BackgroundTransparency = 1;
    p190.BottomImage = "rbxassetid://1195495135";
    p190.MidImage = "rbxassetid://1195495135";
    p190.Position = UDim2.fromScale(0.5, 1);
    p190.ScrollBarImageColor3 = Color3.new();
    p190.ScrollBarImageTransparency = 0.25;
    p190.ScrollBarThickness = 8;
    p190.ScrollingDirection = Enum.ScrollingDirection.Y;
    p190.Size = UDim2.fromScale(0.99, 0.942);
    p190.TopImage = "rbxassetid://1195495135";
    p190.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.008, 0.02);
    UIGridLayout.CellSize = UDim2.fromScale(0.1, 0.35);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 0.55;
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = p190;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0.05, 0);
    UIPadding.PaddingTop = UDim.new(0.01, 0);
    UIPadding.Parent = p190;

    return p190;
end;

function u1.remodeServer(p191) -- Line: 1576
    -- upvalues: u59 (ref), Color3_new_ret4 (copy)
    p191.Name = "Servers";
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Active = true;
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 1);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxassetid://1195495135";
    ScrollingFrame.MidImage = "rbxassetid://1195495135";
    ScrollingFrame.Position = UDim2.fromScale(0.5, 1);
    ScrollingFrame.ScrollBarImageColor3 = Color3.new();
    ScrollingFrame.ScrollBarImageTransparency = 0.25;
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Size = UDim2.fromScale(0.99, 1 - u59);
    ScrollingFrame.TopImage = "rbxassetid://1195495135";
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.004, 0.01);
    UIGridLayout.CellSize = UDim2.fromScale(0.19, 0.105);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 3.88;
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = ScrollingFrame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.02, 0);
    UIPadding.Parent = ScrollingFrame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Empty";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, (u59 + 1) / 2);
    TextLabel.Size = UDim2.fromScale(0.4, 0.03);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3_new_ret4;
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.4;
    TextLabel.Visible = false;
    TextLabel.Parent = p191;
    ScrollingFrame.Parent = p191;

    return ScrollingFrame;
end;

function u1.toolbar() -- Line: 1637
    -- upvalues: u57 (ref), u58 (ref), u56 (ref), u1 (copy)
    local v192 = u57 + u58 + 0.006;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Toolbar";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, u56);
    CanvasGroup.Size = UDim2.fromScale(0.98, v192);
    local Frame = Instance.new("Frame");
    Frame.Name = "Filters";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, u57 / v192);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.Padding = UDim.new(0.006, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 3);
    UIPadding.Parent = Frame;
    local v193 = u1.search();
    v193.LayoutOrder = 1;
    v193.Parent = Frame;
    local v194 = u1.chip("Sort", "SORT BY", 0.095, true);
    v194.LayoutOrder = 2;
    v194.Parent = Frame;
    local v195 = u1.chip("Region", "REGION", 0.095, true);
    v195.LayoutOrder = 3;
    v195.Parent = Frame;
    local v196 = u1.chip("Country", "COUNTRY", 0, true);
    v196.LayoutOrder = 4;
    v196.Visible = false;
    v196.Parent = Frame;
    local v197 = u1.chip("Map", "MAP", 0.095, true);
    v197.LayoutOrder = 5;
    v197.Parent = Frame;
    local v198 = u1.slider();
    v198.LayoutOrder = 6;
    v198.Parent = Frame;
    local v199 = u1.toggle();
    v199.LayoutOrder = 7;
    v199.Parent = Frame;
    local v200 = u1.reset();
    v200.LayoutOrder = 8;
    v200.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local v201 = u1.status();
    v201.Size = UDim2.fromScale(1, u58 / v192);
    v201.Parent = CanvasGroup;

    return CanvasGroup;
end;

function u1.chip(p202: string, p203: string, p204: number, p205: boolean) -- Line: 1707
    -- upvalues: Color3_new_ret4 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p202;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3_new_ret4;
    TextButton.BackgroundTransparency = 1;
    TextButton.ClipsDescendants = true;
    TextButton.Size = UDim2.fromScale(p204, 0.84);
    TextButton.Text = "";
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.12, 0);
    UICorner.Parent = TextButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3_new_ret4;
    UIStroke.Thickness = 1.3;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "AutoLeft";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 10);
    UIPadding.PaddingRight = UDim.new(0, p205 and 22 or 8);
    UIPadding.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Caption";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 0.14);
    TextLabel.Size = UDim2.fromScale(1, 0.28);
    TextLabel.Text = p203;
    TextLabel.TextColor3 = Color3_new_ret4;
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.5;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextLabel";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0, 0.47);
    TextLabel2.Size = UDim2.fromScale(1, 0.38);
    TextLabel2.Text = "Any";
    TextLabel2.TextColor3 = Color3_new_ret4;
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame;
    Frame.Parent = TextButton;

    if p205 then
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.Name = "V";
        TextLabel3.AnchorPoint = Vector2.new(1, 0.5);
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel3.Position = UDim2.new(1, -8, 0.5, 0);
        TextLabel3.Rotation = 90;
        TextLabel3.Size = UDim2.fromScale(0.36, 0.36);
        TextLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        TextLabel3.Text = ">";
        TextLabel3.TextColor3 = Color3_new_ret4;
        TextLabel3.TextScaled = true;
        TextLabel3.TextTransparency = 0.5;
        TextLabel3.Parent = TextButton;
    end;

    return TextButton;
end;

function u1.search() -- Line: 1800
    -- upvalues: Color3_new_ret4 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Search";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(0.18, 0.84);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0.5, 1);
    Frame2.BackgroundColor3 = Color3_new_ret4;
    Frame2.BackgroundTransparency = 0.6;
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 1);
    Frame2.Size = UDim2.new(1, 0, 0, 2);
    Frame2.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://136926548005524";
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.ClearTextOnFocus = false;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3_new_ret4;
    TextBox.PlaceholderText = "SEARCH SERVERS";
    TextBox.Position = UDim2.fromScale(0.14, 0.5);
    TextBox.Size = UDim2.fromScale(0.72, 0.42);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3_new_ret4;
    TextBox.TextScaled = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Clear";
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextButton.Position = UDim2.fromScale(1, 0.5);
    TextButton.Size = UDim2.fromScale(0.5, 0.5);
    TextButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton.Text = "×";
    TextButton.TextColor3 = Color3_new_ret4;
    TextButton.TextScaled = true;
    TextButton.TextTransparency = 0.4;
    TextButton.Visible = false;
    TextButton.Parent = Frame;

    return Frame;
end;

function u1.slider() -- Line: 1870
    -- upvalues: u1 (copy), Color3_new_ret4 (copy)
    local v206 = u1.chip("Players", "PLAYERS", 0.14, false);
    v206.AutoLeft.Size = UDim2.fromScale(0.42, 1);
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Hit";
    TextButton.AnchorPoint = Vector2.new(1, 0);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.Position = UDim2.fromScale(0.98, 0);
    TextButton.Size = UDim2.fromScale(0.56, 1);
    TextButton.Text = "";
    local Frame = Instance.new("Frame");
    Frame.Name = "Track";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3_new_ret4;
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.new(1, -16, 0, 4);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Fill";
    Frame2.AnchorPoint = Vector2.new(0, 0.5);
    Frame2.BackgroundColor3 = Color3_new_ret4;
    Frame2.BackgroundTransparency = 0.4;
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame2;
    Frame2.Parent = Frame;

    for i, v in { "Low", "High" } do
        local Frame3 = Instance.new("Frame");
        Frame3.Name = v;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.BackgroundColor3 = Color3_new_ret4;
        Frame3.BorderSizePixel = 0;
        Frame3.Position = UDim2.fromScale(i - 1, 0.5);
        Frame3.Size = UDim2.fromOffset(12, 12);
        Frame3.ZIndex = 2;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.Name = "UICorner";
        UICorner3.CornerRadius = UDim.new(1, 0);
        UICorner3.Parent = Frame3;
        Frame3.Parent = Frame;
    end;

    Frame.Parent = TextButton;
    TextButton.Parent = v206;

    return v206;
end;

function u1.toggle() -- Line: 1939
    -- upvalues: u1 (copy), Color3_new_ret4 (copy)
    local v207 = u1.chip("Friends", "FRIENDS ONLY", 0.105, false);
    v207.AutoLeft.TextLabel.Text = "None Playing";
    v207.AutoLeft.UIPadding.PaddingRight = UDim.new(0, 32);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BackgroundTransparency = 0.8;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.new(1, -10, 0.5, 0);
    ImageLabel.Size = UDim2.fromScale(0.42, 0.42);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3_new_ret4;
    UIStroke.Thickness = 1;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = ImageLabel;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.2, 0);
    UICorner.Parent = ImageLabel;
    ImageLabel.Parent = v207;

    return v207;
end;

function u1.reset() -- Line: 1974
    -- upvalues: Color3_new_ret4 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Reset";
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextButton.Size = UDim2.fromScale(0.05, 0.84);
    TextButton.Text = "RESET";
    TextButton.TextColor3 = Color3_new_ret4;
    TextButton.TextScaled = true;
    TextButton.TextTransparency = 1;
    TextButton.Visible = false;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.12, 0);
    UICorner.Parent = TextButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3_new_ret4;
    UIStroke.Thickness = 1.3;
    UIStroke.Transparency = 1;
    UIStroke.Parent = TextButton;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.3, 0);
    UIPadding.PaddingLeft = UDim.new(0.12, 0);
    UIPadding.PaddingRight = UDim.new(0.12, 0);
    UIPadding.PaddingTop = UDim.new(0.3, 0);
    UIPadding.Parent = TextButton;

    return TextButton;
end;

function u1.status() -- Line: 2015
    -- upvalues: Color3_new_ret4 (copy), Color3_fromRGB_ret2 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Status";
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Count";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromOffset(3, 0);
    TextLabel.Size = UDim2.fromScale(0.42, 1);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3_new_ret4;
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Current";
    Frame2.AnchorPoint = Vector2.new(1, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.new(1, -3, 0, 0);
    Frame2.Size = UDim2.fromScale(0.56, 1);
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Info";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.RichText = true;
    TextLabel2.Size = UDim2.fromScale(1, 1);
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = Color3_new_ret4;
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Dot";
    Frame3.AnchorPoint = Vector2.new(1, 0.5);
    Frame3.BackgroundColor3 = Color3_fromRGB_ret2;
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0, 0.5);
    Frame3.Size = UDim2.fromScale(0.36, 0.36);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = Frame;

    return Frame;
end;

return u1;