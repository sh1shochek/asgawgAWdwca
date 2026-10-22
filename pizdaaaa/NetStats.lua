-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.NetStats
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.NetStats
-- Decompile time: 59.00 ms

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local TextService = game:GetService("TextService");
local UserInputService = game:GetService("UserInputService");
local Stats = game:GetService("Stats");
local u1 = {
    trace = Color3.fromRGB(135, 203, 255),
    phase = Color3.fromRGB(181, 146, 255),
    success = Color3.fromRGB(94, 232, 141),
    warn = Color3.fromRGB(255, 203, 107),
    error = Color3.fromRGB(255, 104, 120),
    key = Color3.fromRGB(116, 204, 255),
    value = Color3.fromRGB(255, 213, 126),
    muted = Color3.fromRGB(148, 156, 166),
    text = Color3.fromRGB(235, 239, 245),
    background = Color3.fromRGB(0, 0, 0)
};
local u4 = (function(p2) -- Line: 91, Name: flattenConfigGroups
    local v3 = {};

    for _, v in p2 do
        for i, v2 in v do
            v3[i] = v2;
        end;
    end;

    return v3;
end)({
    runtime = {
        enabled = true,
        studioOnly = true,
        template = nil,
        theme = nil
    },
    ui = {
        rightOffset = 12,
        leftOffset = 12,
        bottomOffset = 5,
        anchor = "tr",
        topOffset = 52,
        maxWidth = 0,
        minWidth = 118,
        rowHeight = 17,
        gap = 5,
        padX = 7,
        cornerRadius = 0.3,
        textSize = 10,
        textYOffset = -1,
        displayOrder = 118,
        font = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        measureFont = Enum.Font.RobotoMono
    },
    scale = {
        uiScale = true,
        scaleBaseWidth = 1280,
        minScale = 0.9,
        maxScale = 1.12
    },
    rows = {
        maxItems = 30,
        liveInterval = 0.5
    },
    motion = {
        motionTime = 0.46,
        exitTime = 0.66,
        fadeTime = 0.22,
        motionStyle = Enum.EasingStyle.Quint
    },
    graphs = {
        graphWidth = 220,
        graphHeight = 30,
        graphColumns = 40,
        graphTweenTime = 0.18
    },
    monitor = {
        monitorEnabled = true,
        interval = 0.1,
        minInterval = 0.04,
        spikeMs = 85,
        spikeHoldSeconds = 6,
        slowTraceMs = 8,
        slowTraceCooldown = 4
    }
});
local u5 = {
    columnGap = 1,
    columnTransparency = 0.14,
    gradientFade = 0.45,
    heat = 0.18,
    floor = 1
};

local function clampDelay(p6, p7, p8) -- Line: 113
    local v9 = tonumber(p6) or (tonumber(p7) or 0);
    local v10 = tonumber(p8) or 0;

    return math.max(v10, v9);
end;

local function ms(p11) -- Line: 118
    return p11 >= 100 and string.format("%.0fms", p11) or string.format("%.1fms", p11);
end;

local function compactSource(p12) -- Line: 122
    return p12 == "untracked-frame" and "untracked" or p12;
end;

local function perfName(p13, p14) -- Line: 126
    return string.format("%s.%s", p13, p14);
end;

local function resolveParent(p15) -- Line: 130
    -- upvalues: Players (copy)
    if p15 then
        return p15;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:WaitForChild("PlayerGui");
    end;

    return LocalPlayer;
end;

local function resolveAnchor(p16) -- Line: 138
    local string_lower_ret = string.lower((tostring(p16 or "tr")));
    local v17 = (string_lower_ret == "topright" or string_lower_ret == "top-right") and "tr" or ((string_lower_ret == "topleft" or string_lower_ret == "top-left") and "tl" or ((string_lower_ret == "bottomright" or string_lower_ret == "bottom-right") and "br" or ((string_lower_ret == "bottomleft" or string_lower_ret == "bottom-left") and "bl" or string_lower_ret)));

    if v17 == "tl" then
        return Vector2.new(0, 0), UDim2.new(0, 0, 0, 0);
    end;

    if v17 == "bl" then
        return Vector2.new(0, 1), UDim2.new(0, 0, 1, 0);
    end;

    if v17 == "br" then
        return Vector2.new(1, 1), UDim2.new(1, 0, 1, 0);
    end;

    return Vector2.new(1, 0), UDim2.new(1, 0, 0, 0);
end;

local function normalizeEvent(p18) -- Line: 162
    return type(p18) ~= "table" and {
        tone = "trace",
        scope = "runtime",
        action = tostring(p18 or "event")
    } or p18;
end;

local u19 = {};
u19.__index = u19;

function u19.new(p20) -- Line: 186
    -- upvalues: u19 (copy)
    return setmetatable({
        theme = p20
    }, u19);
end;

function u19.escape(p21) -- Line: 192
    return tostring(p21):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;");
end;

function u19.hex(p22) -- Line: 196
    local math_floor_ret = math.floor(p22.R * 255 + 0.5);
    local math_floor_ret2 = math.floor(p22.G * 255 + 0.5);
    local math_floor_ret3 = math.floor(p22.B * 255 + 0.5);

    return string.format("#%02X%02X%02X", math_floor_ret, math_floor_ret2, math_floor_ret3);
end;

function u19.colored(p23, p24, p25) -- Line: 203
    -- upvalues: u19 (copy)
    return string.format("<font color=\"%s\">%s</font>", u19.hex(p24), u19.escape(p25));
end;

function u19.field(p26, p27, p28) -- Line: 207
    return string.format("%s=%s", p26:colored(p26.theme.key, p27), p26:colored(p26.theme.value, p28));
end;

function u19.joinFields(p29, p30) -- Line: 211
    return table.concat(p30, p29:colored(p29.theme.muted, " "));
end;

function u19.fields(p31, p32) -- Line: 215
    if type(p32) ~= "table" then
        return "";
    end;

    local v33 = {};

    for i in p32 do
        table.insert(v33, i);
    end;

    table.sort(v33);
    local v34 = {};

    for _, v in v33 do
        local v35 = p32[v];

        if type(v35) == "function" then
            local success, result = pcall(v35);
            v35 = success and result and result or "err";
        end;

        if v35 ~= nil then
            table.insert(v34, p31:field(v, v35));
        end;
    end;

    return p31:joinFields(v34);
end;

function u19.hasLiveFields(p36, p37) -- Line: 243
    if type(p37) ~= "table" then
        return false;
    end;

    for _, v in p37 do
        if type(v) == "function" then
            return true;
        end;
    end;

    return false;
end;

function u19.plainText(p38) -- Line: 255
    return tostring(p38):gsub("<[^>]->", "");
end;

function u19.eventLine(p39, p40) -- Line: 259
    local v41 = p40.tone or "trace";
    local v42 = p40.scope or "runtime";
    local v43 = p40.action or "event";
    local v44 = p39:fields(p40.fields);
    local v45 = p39:colored(p39.theme[v41] or p39.theme.trace, string.upper(v41));
    local string_format_ret = string.format("%s %s %s", v45, p39:colored(p39.theme.muted, v42), p39:colored(p39.theme.text, v43));

    if v44 ~= "" then
        string_format_ret = string.format("%s %s", string_format_ret, v44) or string_format_ret;
    end;

    return string_format_ret;
end;

local u46 = {};
u46.__index = u46;

local function sameGoal(p47, p48) -- Line: 275
    if not p47 then
        return false;
    end;

    for i, v in p48 do
        if p47[i] ~= v then
            return false;
        end;
    end;

    for i in p47 do
        if p48[i] == nil then
            return false;
        end;
    end;

    return true;
end;

function u46.new(p49) -- Line: 292
    -- upvalues: u46 (copy)
    local v50 = {
        config = p49,
        tracks = setmetatable({}, {
            __mode = "k"
        })
    };

    return setmetatable(v50, u46);
end;

function u46.track(p51, p52) -- Line: 299
    local v53 = p51.tracks[p52];

    if not v53 then
        v53 = {};
        p51.tracks[p52] = v53;
    end;

    return v53;
end;

function u46.to(p54, p55, p56, p57, p58) -- Line: 308
    -- upvalues: TweenService (copy)
    local v59 = p54:track(p55);
    local v60 = v59[p56];

    if v60 and not v60.done then
        local goal = v60.goal;
        local v61;

        if goal then
            v61 = true;

            for i, v in p57 do
                if goal[i] ~= v then
                    v61 = false;
                    break;
                end;
            end;

            for i in goal do
                if p57[i] == nil then
                    v61 = false;
                    break;
                end;
            end;
        else
            v61 = false;
        end;

        if v61 then
            return v60.tween;
        end;
    end;

    if v60 then
        v60.tween:Cancel();
    end;

    local u62 = {
        done = false,
        goal = p57,
        tween = TweenService:Create(p55, TweenInfo.new(p58 or p54.config.motionTime, p54.config.motionStyle, Enum.EasingDirection.Out), p57)
    };
    v59[p56] = u62;
    u62.tween.Completed:Once(function() -- Line: 324
        -- upvalues: u62 (copy)
        u62.done = true;
    end);
    u62.tween:Play();

    return u62.tween;
end;

function u46.cancel(p63, p64, p65) -- Line: 332
    local v66 = p63.tracks[p64];

    if not v66 then
        return;
    end;

    if p65 then
        local v67 = v66[p65];

        if v67 then
            v67.tween:Cancel();
            v66[p65] = nil;
        end;

        return;
    end;

    for _, v in v66 do
        v.tween:Cancel();
    end;

    p63.tracks[p64] = nil;
end;

local u68 = {};
u68.__index = u68;

local function graphWidth(p69) -- Line: 358
    return math.min(p69.config.graphWidth, p69:maxLineWidth());
end;

local function graphHeight(p70) -- Line: 362
    return p70.config.graphHeight;
end;

local function graphBlockHeight(p71) -- Line: 366
    return p71.config.graphHeight + p71.config.gap + p71.config.rowHeight;
end;

function u68.new(p72) -- Line: 370
    -- upvalues: u68 (copy)
    return setmetatable({
        render = p72,
        cards = {},
        order = {}
    }, u68);
end;

function u68.top(p73) -- Line: 378
    return 0;
end;

function u68.height(p74) -- Line: 382
    local v75 = 0;

    for _, v in p74.order do
        if not v.dead then
            v75 = v75 + 1;
        end;
    end;

    if v75 == 0 then
        return 0;
    end;

    local render = p74.render;

    return v75 * (render.config.graphHeight + render.config.gap + render.config.rowHeight) + v75 * p74.render:scaled(p74.render.config.gap);
end;

function u68.layout(p76, p77) -- Line: 395
    local render = p76.render;
    local math_min_ret = math.min(render.config.graphWidth, render:maxLineWidth());
    local graphHeight2 = render.config.graphHeight;
    local v78 = render:scaled(render.config.gap);

    for _, v in p76.order do
        if not v.dead then
            p76:syncCard(v);
            local v79 = render:rowAnchorPoint();
            local v80 = render:rowX();
            v.frame.AnchorPoint = v79;
            v.textFrame.AnchorPoint = v79;
            render.motion:to(v.frame, "move", {
                Position = UDim2.new(v80, 0, 0, p77),
                Size = UDim2.fromOffset(math_min_ret, graphHeight2)
            }, render.config.motionTime);
            render.motion:to(v.textFrame, "move", {
                Position = UDim2.new(v80, 0, 0, p77 + graphHeight2 + v78),
                Size = UDim2.fromOffset(v.textWidth, render:scaled(render.config.rowHeight))
            }, render.config.motionTime);
            p77 = p77 + (render.config.graphHeight + render.config.gap + render.config.rowHeight) + v78;
        end;
    end;
end;

function u68.applyTheme(p81) -- Line: 427
    local render = p81.render;

    for _, v in p81.order do
        v.frame.BackgroundColor3 = render.theme.background;
        v.textFrame.BackgroundColor3 = render.theme.background;
        v.head.TextColor3 = render.theme.text;
        local v82 = v;

        for _, v2 in v.columns do
            v2.BackgroundColor3 = render.theme[v82.tone] or render.theme.trace;
        end;

        p81:redraw(v82);
    end;
end;

function u68.toneColor(p83, p84) -- Line: 440
    return p83.render.theme[p84.tone] or p83.render.theme.trace;
end;

function u68.thresholdTone(p85, p86, p87) -- Line: 444
    return p86.failBelow and p87 <= p86.failBelow and "error" or (p86.warnBelow and p87 <= p86.warnBelow and "warn" or (p86.warnAt and p86.warnAt <= p87 and (p86.failAt and p86.failAt <= p87 and "error" or "warn") or p86.tone));
end;

function u68.heatColor(p88, p89, p90) -- Line: 457
    return (p88.render.theme[p89] or p88.render.theme.trace):Lerp(p88.render.theme.text, p90);
end;

function u68.plotHeight(p91) -- Line: 461
    return p91.render.config.graphHeight - p91.render:scaled(6);
end;

function u68.columnWidth(p92, p93, p94) -- Line: 465
    local math_max_ret = math.max(1, p92.render.config.graphColumns);
    local render = p92.render;
    local v95 = (math.min(render.config.graphWidth, render:maxLineWidth()) - p92.render.config.padX * 2 - p94 * (math_max_ret - 1)) / math_max_ret;

    return math.max(1, v95);
end;

function u68.placeColumns(p96, p97) -- Line: 471
    local columnGap = p97.style.columnGap;
    local v98 = p96:columnWidth(p97, columnGap);
    p97.columnWidth = v98;

    for i, v in p97.columns do
        v.Position = UDim2.new(0, (i - 1) * (v98 + columnGap), 1, 0);
        v.Size = UDim2.new(0, math.ceil(v98), 0, v.Size.Y.Offset);
    end;
end;

function u68.buildColumns(u99, u100) -- Line: 481
    local style = u100.style;
    local v101 = u99:toneColor(u100);

    for i = 1, u99.render.config.graphColumns do
        local Frame = Instance.new("Frame");
        Frame.Name = string.format("Col%d", i);
        Frame.AnchorPoint = Vector2.new(0, 1);
        Frame.BackgroundColor3 = v101;
        Frame.BackgroundTransparency = style.columnTransparency;
        Frame.BorderSizePixel = 0;
        Frame.Active = true;
        Frame.Parent = u100.plot;

        if style.gradientFade then
            local UIGradient = Instance.new("UIGradient");
            UIGradient.Rotation = 90;
            UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, style.gradientFade) });
            UIGradient.Parent = Frame;
        end;

        u100.columns[i] = Frame;
        Frame.MouseEnter:Connect(function() -- Line: 507
            -- upvalues: u99 (copy), u100 (copy), i (copy)
            u99:showTooltip(u100, i);
        end);
        local _ = i;
    end;
end;

function u68.tooltipText(p102, p103, p104) -- Line: 513
    local v105 = p103.window[p104];

    if v105 == nil then
        return string.format("%s: --", p103.name);
    end;

    return string.format("%s [%d]: %s", p103.name, p104, p102:formatValue(p103, v105));
end;

function u68.positionTooltip(p106, p107) -- Line: 521
    -- upvalues: UserInputService (copy)
    local v108 = p107.tooltip.TextBounds.X + p106.render:scaled(8);
    local v109 = p106.render:scaled(p106.render.config.rowHeight);
    local AbsolutePosition = p106.render.stack.AbsolutePosition;
    local AbsoluteSize = p106.render.stack.AbsoluteSize;
    local MouseLocation = UserInputService:GetMouseLocation();
    local v110 = MouseLocation.X - AbsolutePosition.X;
    local v111 = MouseLocation.Y - AbsolutePosition.Y - v109 - p106.render:scaled(34);
    local math_floor_ret = math.floor(v108 / 2);
    local v112 = AbsoluteSize.X - math.floor(v108 / 2);
    local math_clamp_ret = math.clamp(v110, math_floor_ret, v112);
    local math_clamp_ret2 = math.clamp(v111, v109, AbsoluteSize.Y);
    p107.tooltip.Size = UDim2.fromOffset(v108, v109);
    local v113 = p106.render:scaled(4);
    p107.tooltipShadow.Size = UDim2.fromOffset(v108 + v113, v109 + v113);
    p106.render.motion:to(p107.tooltip, "tooltipMove", {
        Position = UDim2.fromOffset(math_clamp_ret, math_clamp_ret2)
    }, 0.1);
    p106.render.motion:to(p107.tooltipShadow, "tooltipMove", {
        Position = UDim2.fromOffset(math_clamp_ret, math_clamp_ret2 + math.floor(v113 / 2))
    }, 0.1);
end;

function u68.showTooltip(p114, p115, p116) -- Line: 548
    p115.tooltip.Text = p114:tooltipText(p115, p116);
    p114:positionTooltip(p115);
    p115.tooltip.Visible = true;
    p115.tooltipShadow.Visible = true;
    p115.hoveredIndex = p116;
    p114.render.motion:to(p115.tooltip, "fade", {
        TextTransparency = 0
    }, p114.render.config.fadeTime);
    p114.render.motion:to(p115.tooltipShadow, "fade", {
        ImageTransparency = 0.88
    }, p114.render.config.fadeTime);
end;

function u68.hideTooltip(p117, u118) -- Line: 564
    u118.hoveredIndex = nil;
    p117.render.motion:to(u118.tooltip, "fade", {
        TextTransparency = 1
    }, p117.render.config.fadeTime);
    p117.render.motion:to(u118.tooltipShadow, "fade", {
        ImageTransparency = 1
    }, p117.render.config.fadeTime);
    task.delay(p117.render.config.fadeTime, function() -- Line: 575
        -- upvalues: u118 (copy)
        if u118.hoveredIndex == nil then
            u118.tooltip.Visible = false;
            u118.tooltipShadow.Visible = false;
        end;
    end);
    p117:slice(u118);
    p117:updateStats(u118);
    p117:autoRange(u118);
    p117.render:layout();
end;

function u68.sizeColumn(p119, p120, p121, p122) -- Line: 588
    if p120.heights[p121] == p122 then
        return;
    end;

    p120.heights[p121] = p122;
    local v123 = p120.columns[p121];
    local UDim2_new_ret = UDim2.new(0, math.ceil(p120.columnWidth or v123.Size.X.Offset), 0, p122);

    if v123.Size ~= UDim2_new_ret then
        v123.Size = UDim2_new_ret;
    end;
end;

function u68.drawColumns(p124, p125) -- Line: 613
    local style = p125.style;
    local v126 = p124:plotHeight();
    local v127 = p125.range[1];
    local math_max_ret = math.max(p125.range[2] - v127, 1e-6);
    p124:placeColumns(p125);
    local v128 = p125.samples[#p125.samples];
    local v129 = p124:heatColor(v128 and p124:thresholdTone(p125, v128) or p125.tone, 0);

    for i = 1, p124.render.config.graphColumns do
        local v130 = p125.window[i];
        local floor = style.floor;
        local v131 = p125.columns[i];
        local v132;

        if v130 == nil then
            v132 = v129;
        else
            local math_clamp_ret = math.clamp((v130 - v127) / math_max_ret, 0, 1);
            local floor2 = style.floor;
            local math_floor_ret = math.floor(math_clamp_ret * (v126 - 1) + 0.5);
            floor = math.max(floor2, math_floor_ret);
            v132 = p124:heatColor(p124:thresholdTone(p125, v130), math_clamp_ret * style.heat);
        end;

        if v131.BackgroundColor3 ~= v132 then
            v131.BackgroundColor3 = v132;
        end;

        p124:sizeColumn(p125, i, floor);
        local _ = i;
    end;
end;

function u68.formatValue(p133, p134, p135) -- Line: 649
    if p134.format then
        local success, result = pcall(p134.format, p135);

        if success then
            return tostring(result);
        end;
    end;

    local v136 = (math.abs(p135) >= 100 and string.format("%.0f", p135) or string.format("%.1f", p135)):gsub("%.0$", "");

    if p134.unit ~= "" then
        v136 = string.format("%s%s", v136, p134.unit) or v136;
    end;

    return v136;
end;

function u68.headLine(p137, p138) -- Line: 661
    local render = p137.render;
    local v139 = render.format:colored(render.theme[p138.tone] or render.theme.trace, p138.name);
    local v140 = render.format:colored(render.theme.value, p138.display or "--");
    local string_format_ret = string.format("%s: %s", v139, v140);

    if #p138.window > 0 then
        local v141 = render.format:joinFields({ render.format:field("min", p137:formatValue(p138, p138.minSeen)), render.format:field("max", p137:formatValue(p138, p138.maxSeen)), render.format:field("avg", p137:formatValue(p138, p138.avgSeen)) });
        string_format_ret = string.format("%s %s", string_format_ret, v141);
    end;

    return string_format_ret;
end;

function u68.fitText(p142, p143) -- Line: 678
    local v144 = p142:headLine(p143);
    p143.head.Text = v144;
    p143.textWidth = p142.render:measuredWidth(v144);
    p142.render:syncLabel(p143.head);
end;

function u68.slice(p145, p146) -- Line: 685
    local graphColumns = p145.render.config.graphColumns;
    local math_max_ret = math.max(1, #p146.samples - graphColumns + 1);
    local v147 = #p146.samples - math_max_ret + 1;
    local v148 = {};

    if v147 <= 0 then
        p146.window = v148;

        return v148;
    end;

    if v147 == 1 then
        local v149 = p146.samples[math_max_ret];

        for i = 1, graphColumns do
            table.insert(v148, v149);
            local _ = i;
        end;
    else
        for i = 1, graphColumns do
            local v150 = (i - 1) / math.max(graphColumns - 1, 1) * (v147 - 1);
            local math_floor_ret = math.floor(v150);
            local math_min_ret = math.min(math_floor_ret + 1, v147 - 1);
            local v151 = p146.samples[math_max_ret + math_floor_ret];
            table.insert(v148, v151 + (p146.samples[math_max_ret + math_min_ret] - v151) * (v150 - math_floor_ret));
            local _ = i;
        end;
    end;

    p146.window = v148;

    return v148;
end;

function u68.updateStats(p152, p153) -- Line: 718
    local v154 = (1 / 0);
    local v155 = (-1 / 0);
    local v156 = 0;

    for _, v in p153.window do
        v154 = math.min(v154, v);
        v155 = math.max(v155, v);
        v156 = v156 + v;
    end;

    p153.minSeen = v154 == (1 / 0) and 0 or v154;
    p153.maxSeen = v155 == (-1 / 0) and 0 or v155;
    p153.avgSeen = #p153.window > 0 and (v156 / #p153.window or 0) or 0;
end;

function u68.autoRange(p157, p158) -- Line: 734
    if p158.fixedRange then
        return;
    end;

    local v159 = (1 / 0);
    local v160 = (-1 / 0);

    for _, v in p158.window do
        v159 = math.min(v159, v);
        v160 = math.max(v160, v);
    end;

    if v159 == (1 / 0) then
        return;
    end;

    local v161 = (v160 - v159) * 0.15;

    if v161 <= 0 then
        local v162 = math.abs(v160) * 0.1;
        v161 = math.max(v162, 1e-6);
    end;

    local v163;

    if v160 <= 0 then
        v163 = v159 - v161;
    else
        v163 = math.max(0, v159 - v161);
    end;

    local v164 = v160 + v161;

    if v164 <= v163 then
        v164 = v163 + 1e-6;
    end;

    p158.range = { v163, v164 };
end;

function u68.redraw(p165, p166) -- Line: 764
    p165:drawColumns(p166);
end;

function u68.syncCard(p167, p168) -- Line: 768
    local render = p167.render;
    local math_min_ret = math.min(render.config.graphWidth, render:maxLineWidth());
    local graphHeight2 = render.config.graphHeight;
    local v169 = render:scaled(render.config.padX);
    p167:fitText(p168);
    p168.plot.Position = UDim2.fromOffset(v169, render:scaled(3));
    p168.plot.Size = UDim2.fromOffset(math_min_ret - v169 * 2, graphHeight2 - render:scaled(6));
    p167:redraw(p168);
end;

function u68.make(u170, p171, p172) -- Line: 780
    -- upvalues: u5 (copy)
    if u170.cards[p171] then
        return;
    end;

    local render = u170.render;
    local v173 = p172 or {};
    render.serial = render.serial + 1;
    local v174 = 0;
    local v175 = 1;

    if type(v173.range) == "table" then
        v174 = tonumber(v173.range[1]) or v174;
        v175 = tonumber(v173.range[2]) or v175;

        if v175 <= v174 then
            v175 = v174 + 1;
        end;
    end;

    local u176 = {
        columnWidth = 1,
        hoveredIndex = nil,
        tooltip = nil,
        tooltipShadow = nil,
        display = "--",
        minSeen = 0,
        maxSeen = 0,
        avgSeen = 0,
        dead = false,
        name = p171,
        tone = v173.tone or "trace",
        style = u5,
        unit = v173.unit or "",
        format = v173.format,
        samples = {},
        window = {},
        columns = {},
        heights = {},
        range = { v174, v175 },
        fixedRange = v173.range ~= nil,
        warnAt = tonumber(v173.warnAt),
        failAt = tonumber(v173.failAt),
        warnBelow = tonumber(v173.warnBelow),
        failBelow = tonumber(v173.failBelow),
        textWidth = render:scaled(render.config.minWidth)
    };
    local math_min_ret = math.min(render.config.graphWidth, render:maxLineWidth());
    local graphHeight2 = render.config.graphHeight;
    local Frame = Instance.new("Frame");
    Frame.Name = string.format("LoriGraph_%d", render.serial);
    Frame.AnchorPoint = render:rowAnchorPoint();
    local v177 = render:offscreenPosition(math_min_ret);
    Frame.Position = UDim2.new(v177.X.Scale, v177.X.Offset, 0, u170:top());
    Frame.Size = UDim2.fromOffset(math_min_ret, graphHeight2);
    Frame.BackgroundColor3 = render.theme.background;
    Frame.BackgroundTransparency = 0.62;
    Frame.BorderSizePixel = 0;
    Frame.ClipsDescendants = true;
    Frame.Parent = render.stack;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = render:cornerRadius();
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Plot";
    Frame2.Active = true;
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderSizePixel = 0;
    Frame2.ClipsDescendants = true;
    Frame2.Parent = Frame;
    Frame2.MouseLeave:Connect(function() -- Line: 853
        -- upvalues: u176 (copy), u170 (copy)
        if u176.hoveredIndex ~= nil then
            u170:hideTooltip(u176);
        end;
    end);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = string.format("LoriGraphText_%d", render.serial);
    Frame3.AnchorPoint = render:rowAnchorPoint();
    Frame3.Position = UDim2.new(v177.X.Scale, v177.X.Offset, 0, u170:top() + graphHeight2 + render:scaled(render.config.gap));
    Frame3.Size = UDim2.fromOffset(math_min_ret, render:scaled(render.config.rowHeight));
    Frame3.BackgroundColor3 = render.theme.background;
    Frame3.BackgroundTransparency = 0.62;
    Frame3.BorderSizePixel = 0;
    Frame3.ClipsDescendants = true;
    Frame3.Parent = render.stack;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = render:cornerRadius();
    UICorner2.Parent = Frame3;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Line";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = render.config.font;
    TextLabel.RichText = true;
    TextLabel.TextColor3 = render.theme.text;
    TextLabel.TextTransparency = 1;
    TextLabel.TextTruncate = Enum.TextTruncate.None;
    TextLabel.TextWrapped = false;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.Parent = Frame3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "TooltipShadow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://1316045217";
    ImageLabel.ImageColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.ImageTransparency = 1;
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.SliceCenter = Rect.new(10, 10, 118, 118);
    ImageLabel.Visible = false;
    ImageLabel.ZIndex = 5;
    ImageLabel.Parent = render.stack;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Tooltip";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.BorderSizePixel = 0;
    TextLabel2.FontFace = render.config.font;
    TextLabel2.RichText = false;
    TextLabel2.TextColor3 = render.theme.text;
    TextLabel2.TextSize = render.config.textSize;
    TextLabel2.TextTransparency = 1;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel2.Visible = false;
    TextLabel2.ZIndex = 6;
    TextLabel2.Size = UDim2.fromOffset(render:scaled(92), render:scaled(render.config.rowHeight));
    TextLabel2.Parent = render.stack;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = render:cornerRadius();
    UICorner3.Parent = TextLabel2;
    u176.textFrame = Frame3;
    u176.tooltip = TextLabel2;
    u176.tooltipShadow = ImageLabel;
    u176.frame = Frame;
    u176.plot = Frame2;
    u176.head = TextLabel;
    u170:buildColumns(u176);
    u170:fitText(u176);
    u170:syncCard(u176);
    table.insert(u170.order, u176);
    u170.cards[p171] = u176;
    render:layout();
    render.motion:to(Frame, "move", {
        Position = UDim2.new(render:rowX(), 0, 0, Frame.Position.Y.Offset),
        Size = UDim2.fromOffset(math_min_ret, graphHeight2)
    }, render.config.motionTime);
    render.motion:to(Frame3, "move", {
        Position = UDim2.new(render:rowX(), 0, 0, Frame3.Position.Y.Offset),
        Size = UDim2.fromOffset(u176.textWidth, render:scaled(render.config.rowHeight))
    }, render.config.motionTime);
    render:fadeIn(TextLabel);
end;

function u68.push(p178, p179, p180) -- Line: 949
    local v181 = p178.cards[p179];

    if not v181 or v181.dead then
        return;
    end;

    local v182 = tonumber(p180);

    if v182 == nil then
        return;
    end;

    table.insert(v181.samples, v182);

    while #v181.samples > p178.render.config.graphColumns * 2 do
        table.remove(v181.samples, 1);
    end;

    v181.display = p178:formatValue(v181, v182);

    if v181.hoveredIndex ~= nil then
        return;
    end;

    p178:slice(v181);
    p178:updateStats(v181);
    p178:autoRange(v181);
    p178.render:layout();
end;

function u68.rescale(p183, p184, p185) -- Line: 977
    local v186 = p183.cards[p184];
    local v187 = tonumber(p185) or 1;

    if not v186 or v187 <= 0 then
        return;
    end;

    v186.fixedRange = true;
    local v188 = (v186.range[1] + v186.range[2]) / 2;
    local math_max_ret = math.max((v186.range[2] - v186.range[1]) / 2 * v187, 0.5);
    v186.range = { v188 - math_max_ret, v188 + math_max_ret };
    p183:redraw(v186);
end;

function u68.remove(u189, p190) -- Line: 991
    local u191 = u189.cards[p190];

    if not u191 or u191.dead then
        return;
    end;

    local render = u189.render;
    u191.dead = true;
    u189.cards[p190] = nil;
    render.motion:cancel(u191.frame);
    render.motion:cancel(u191.textFrame);
    local v192 = render:offscreenPosition((math.min(render.config.graphWidth, render:maxLineWidth())));
    render.motion:to(u191.frame, "move", {
        Position = UDim2.new(v192.X.Scale, v192.X.Offset, 0, u191.frame.Position.Y.Offset)
    }, render.config.exitTime);
    render.motion:to(u191.textFrame, "move", {
        Position = UDim2.new(v192.X.Scale, v192.X.Offset, 0, u191.textFrame.Position.Y.Offset)
    }, render.config.exitTime);
    task.delay(render.config.exitTime + 0.04, function() -- Line: 1013
        -- upvalues: u189 (copy), u191 (copy), render (copy)
        local table_find_ret = table.find(u189.order, u191);

        if table_find_ret then
            table.remove(u189.order, table_find_ret);
        end;

        u191.frame:Destroy();
        u191.textFrame:Destroy();
        u191.tooltip:Destroy();
        u191.tooltipShadow:Destroy();
        render:layout();
    end);
end;

function u68.clear(p193) -- Line: 1026
    for _, v in p193.order do
        if v.frame then
            v.frame:Destroy();
        end;

        if v.textFrame then
            v.textFrame:Destroy();
        end;

        if v.tooltip then
            v.tooltip:Destroy();
        end;

        if v.tooltipShadow then
            v.tooltipShadow:Destroy();
        end;
    end;

    table.clear(p193.cards);
    table.clear(p193.order);
end;

local u194 = {};
u194.__index = u194;

function u194.new(p195, p196, p197, p198) -- Line: 1050
    -- upvalues: u46 (copy), u194 (copy)
    local v199 = {
        mounted = false,
        graph = nil,
        stack = nil,
        scale = 1,
        viewportConnection = nil,
        cameraConnection = nil,
        serial = 0,
        gui = nil,
        monitorRows = p198 or 0,
        monitorFrames = {},
        monitorLabels = {},
        motion = u46.new(p195),
        config = p195,
        format = p197,
        theme = p196,
        items = {},
        keyed = {}
    };

    return setmetatable(v199, u194);
end;

function u194.viewportWidth(p200) -- Line: 1073
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local v201 = CurrentCamera and CurrentCamera.ViewportSize.X or 0;

    return v201 < 200 and 1280 or v201;
end;

function u194.scaleFactor(p202) -- Line: 1082
    if p202.config.uiScale == false then
        return 1;
    end;

    if type(p202.config.uiScale) == "number" then
        return math.max(0.05, p202.config.uiScale);
    end;

    local v203 = tonumber(p202.config.scaleBaseWidth) or 1280;
    local math_max_ret = math.max(1, v203);
    local v204 = tonumber(p202.config.minScale) or 0.9;
    local v205 = tonumber(p202.config.maxScale) or 1.12;
    local v206 = p202:viewportWidth() / math_max_ret;

    return math.clamp(v206, v204, v205);
end;

function u194.updateScale(p207) -- Line: 1095
    p207.scale = p207:scaleFactor();
end;

function u194.scaled(p208, p209) -- Line: 1099
    local math_floor_ret = math.floor(p209 * p208.scale + 0.5);

    return math.max(1, math_floor_ret);
end;

function u194.isLeftAligned(p210) -- Line: 1103
    return p210.stack and p210.stack.AnchorPoint.X == 0;
end;

function u194.rowAnchorPoint(p211) -- Line: 1107
    if p211:isLeftAligned() then
        return Vector2.new(0, 0);
    end;

    return Vector2.new(1, 0);
end;

function u194.rowX(p212) -- Line: 1111
    return p212:isLeftAligned() and 0 or 1;
end;

function u194.cornerRadius(p213) -- Line: 1115
    local cornerRadius = p213.config.cornerRadius;

    if type(cornerRadius) ~= "number" then
        return UDim.new(0, p213:scaled(p213.config.rowHeight * 0.3));
    end;

    if cornerRadius <= 1 then
        return UDim.new(0, p213:scaled(p213.config.rowHeight * cornerRadius));
    end;

    return UDim.new(0, p213:scaled(cornerRadius));
end;

function u194.offscreenPosition(p214, p215) -- Line: 1126
    local v216 = p214:offscreen(p215);

    if p214:isLeftAligned() then
        return UDim2.new(0, -v216, 0, 0);
    end;

    return UDim2.new(1, v216, 0, 0);
end;

function u194.viewportLimit(p217) -- Line: 1134
    local v218 = p217:scaled(p217.config.minWidth);
    local v219 = p217:viewportWidth() - p217.config.rightOffset * 2 - 24;

    return math.max(v218, v219);
end;

function u194.maxLineWidth(p220) -- Line: 1138
    local v221 = type(p220.config.maxWidth) == "number" and (p220.config.maxWidth or (1 / 0)) or (1 / 0);
    local v222 = v221 <= 0 and (1 / 0) or p220:scaled(v221);
    local v223 = p220:scaled(p220.config.minWidth);
    local math_min_ret = math.min(v222, p220:viewportLimit());

    return math.max(v223, math_min_ret);
end;

function u194.contentHeight(p224) -- Line: 1148
    local v225 = p224:scaled(p224.config.rowHeight) + p224:scaled(p224.config.gap);
    local v226 = #p224.items;
    local v227 = v226 > 0 and (v226 * v225 - p224:scaled(p224.config.gap) or 0) or 0;

    return p224:monitorOffset() + v227;
end;

function u194.updateStackSize(p228) -- Line: 1155
    if not p228.stack then
        return;
    end;

    p228:updateScale();
    local v229 = p228:scaled(p228.config.rowHeight);
    local math_max_ret = math.max(v229, p228:contentHeight());
    p228.motion:to(p228.stack, "size", {
        Size = UDim2.fromOffset(p228:maxLineWidth(), math_max_ret)
    }, p228.config.motionTime);
end;

function u194.bindViewport(u230) -- Line: 1166
    -- upvalues: Workspace (copy)
    if u230.viewportConnection then
        u230.viewportConnection:Disconnect();
        u230.viewportConnection = nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        u230.viewportConnection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 1173
            -- upvalues: u230 (copy)
            u230:updateScale();
            u230:layout();
        end);
    end;

    if not u230.cameraConnection then
        u230.cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 1179
            -- upvalues: u230 (copy)
            u230:bindViewport();
            u230:updateScale();
            u230:layout();
        end);
    end;
end;

function u194.offscreen(p231, p232) -- Line: 1187
    local v233 = p232 or p231:maxLineWidth();

    return math.max(v233, p231:scaled(p231.config.minWidth)) + p231:scaled(32);
end;

function u194.measuredWidth(p234, p235) -- Line: 1191
    -- upvalues: u19 (copy), TextService (copy)
    local v236 = u19.plainText(p235);

    if v236 == "" then
        return p234:scaled(p234.config.minWidth);
    end;

    local X = TextService:GetTextSize(v236, p234:scaled(p234.config.textSize), p234.config.measureFont, Vector2.new(100000, p234:scaled(p234.config.rowHeight))).X;
    local v237 = math.ceil(X) + p234:scaled(p234.config.padX) * 2;
    local v238 = p234:scaled(p234.config.minWidth);

    return math.clamp(v237, v238, p234:maxLineWidth());
end;

function u194.syncLabel(p239, p240) -- Line: 1209
    p240.Position = UDim2.fromOffset(p239:scaled(p239.config.padX), p239.config.textYOffset * p239.scale);
    p240.Size = UDim2.new(1, -p239:scaled(p239.config.padX) * 2, 1, 0);
    p240.TextSize = p239:scaled(p239.config.textSize);
end;

function u194.monitorOffset(p241) -- Line: 1215
    local v242 = p241.config.monitorEnabled and ((p241:scaled(p241.config.rowHeight) + p241:scaled(p241.config.gap)) * p241.monitorRows or 0) or 0;

    return p241:graphOffset() + v242;
end;

function u194.graphOffset(p243) -- Line: 1222
    return p243.graph and p243.graph:height() or 0;
end;

function u194.monitorY(p244, p245) -- Line: 1226
    return p244:graphOffset() + (p245 - 1) * (p244:scaled(p244.config.rowHeight) + p244:scaled(p244.config.gap));
end;

function u194.rowY(p246, p247) -- Line: 1230
    return p246:monitorOffset() + (p247 - 1) * (p246:scaled(p246.config.rowHeight) + p246:scaled(p246.config.gap));
end;

function u194.buildRow(p248, p249, p250) -- Line: 1234
    local v251 = p248:measuredWidth(p249);
    local Frame = Instance.new("Frame");
    Frame.Name = p250;
    Frame.AnchorPoint = p248:rowAnchorPoint();
    Frame.Size = UDim2.fromOffset(v251, p248:scaled(p248.config.rowHeight));
    Frame.BackgroundColor3 = p248.theme.background;
    Frame.BackgroundTransparency = 0.62;
    Frame.BorderSizePixel = 0;
    Frame.ClipsDescendants = true;
    Frame.Parent = p248.stack;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = p248:cornerRadius();
    UICorner.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Line";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = p248.config.font;
    TextLabel.RichText = true;
    TextLabel.Text = p249;
    TextLabel.TextColor3 = p248.theme.text;
    TextLabel.TextTruncate = Enum.TextTruncate.None;
    TextLabel.TextWrapped = false;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.Parent = Frame;
    p248:syncLabel(TextLabel);

    return Frame, TextLabel, v251;
end;

function u194.moveTo(p252, p253, p254, p255, p256) -- Line: 1268
    p253.AnchorPoint = p252:rowAnchorPoint();
    p252.motion:to(p253, "move", {
        Position = UDim2.new(p252:rowX(), 0, 0, p254),
        Size = UDim2.fromOffset(p255, p252:scaled(p252.config.rowHeight))
    }, p256);
end;

function u194.fadeIn(p257, p258) -- Line: 1276
    p257.motion:to(p258, "fade", {
        TextTransparency = 0
    }, p257.config.fadeTime);
end;

function u194.layout(p259) -- Line: 1280
    p259:updateStackSize();

    if p259.graph then
        p259.graph:layout(p259.graph:top());
    end;

    for i, v in p259.monitorFrames do
        local v260 = p259.monitorLabels[i];

        if v and v260 then
            p259:syncLabel(v260);
            p259:moveTo(v, p259:monitorY(i), p259:measuredWidth(v260.Text), p259.config.motionTime);
        end;
    end;

    for i, v in ipairs(p259.items) do
        if not v.dead then
            p259:syncLabel(v.label);
            v.width = p259:measuredWidth(v.label.Text);
            p259:moveTo(v.frame, p259:rowY(i), v.width, p259.config.motionTime);
        end;
    end;
end;

function u194.applyTheme(p261) -- Line: 1304
    for _, v in p261.monitorFrames do
        v.BackgroundColor3 = p261.theme.background;
    end;

    for _, v in p261.monitorLabels do
        v.TextColor3 = p261.theme.text;
    end;

    for _, v in p261.items do
        v.frame.BackgroundColor3 = p261.theme.background;
        v.label.TextColor3 = p261.theme.text;
    end;

    if p261.graph then
        p261.graph:applyTheme();
    end;
end;

function u194.setMonitorRows(p262, p263) -- Line: 1320
    p262.monitorRows = p263 or 0;
    p262:layout();
end;

function u194.dropKey(p264, p265) -- Line: 1325
    if p265.key and p264.keyed[p265.key] == p265 then
        p264.keyed[p265.key] = nil;
    end;
end;

function u194.needsLive(p266, p267) -- Line: 1331
    return p267.liveInterval or p266.format:hasLiveFields(p267.fields);
end;

function u194.liveDelay(p268, p269) -- Line: 1335
    local v270;

    if p269.liveInterval == nil then
        v270 = p268.config.liveInterval;
    else
        v270 = p269.liveInterval;
    end;

    local v271 = p268.config.minInterval or 0;
    local v272 = tonumber(v270) or 0;

    return math.max(v271, v272);
end;

function u194.refreshItem(p273, p274, p275) -- Line: 1340
    local v276 = p273.format:eventLine(p275);
    p274.label.Text = v276;
    p274.width = p273:measuredWidth(v276);
    p273:layout();
end;

function u194.startLive(u277, u278) -- Line: 1347
    if u278.liveRunning or not u277:needsLive(u278.event) then
        return;
    end;

    u278.liveRunning = true;
    task.spawn(function() -- Line: 1352
        -- upvalues: u278 (copy), u277 (copy)
        while not u278.dead do
            local event = u278.event;

            if not (event and u277:needsLive(event)) then
                break;
            end;

            task.wait(u277:liveDelay(event));

            if u278.dead then
                break;
            end;

            local event2 = u278.event;

            if not (event2 and u277:needsLive(event2)) then
                break;
            end;

            u277:refreshItem(u278, event2);
        end;

        u278.liveRunning = false;
    end);
end;

function u194.makeItem(u279, p280) -- Line: 1372
    u279.serial = u279.serial + 1;
    local v281, v282, v283 = u279:buildRow(u279.format:eventLine(p280), string.format("Lori_%d", u279.serial));
    local v284 = u279:offscreenPosition(v283);
    v281.Position = UDim2.new(v284.X.Scale, v284.X.Offset, 0, u279:rowY(1));
    v282.TextTransparency = 1;
    local u285 = {
        dead = false,
        liveRunning = false,
        key = p280.key,
        frame = v281,
        label = v282,
        width = v283,
        event = p280
    };
    table.insert(u279.items, 1, u285);

    if p280.key then
        u279.keyed[p280.key] = u285;
    end;

    while #u279.items > u279.config.maxItems do
        local table_remove_ret = table.remove(u279.items);
        table_remove_ret.dead = true;
        u279.motion:cancel(table_remove_ret.frame);
        u279:dropKey(table_remove_ret);
        table_remove_ret.frame:Destroy();
    end;

    u279:layout();
    u279:fadeIn(v282);

    if not p280.sticky then
        task.delay(p280.duration or 3.2, function() -- Line: 1407
            -- upvalues: u279 (copy), u285 (copy)
            u279:destroyItem(u285);
        end);
    end;

    u279:startLive(u285);
end;

function u194.updateItem(p286, p287, p288) -- Line: 1415
    p287.event = p288;
    p286:refreshItem(p287, p288);
    p286:startLive(p287);
end;

function u194.destroyItem(u289, u290) -- Line: 1421
    if u290.dead then
        return;
    end;

    u290.dead = true;
    local frame = u290.frame;
    local v291 = u289:offscreenPosition(u290.width);
    u289.motion:to(frame, "move", {
        Position = UDim2.new(v291.X.Scale, v291.X.Offset, 0, frame.Position.Y.Offset)
    }, u289.config.exitTime);
    task.delay(u289.config.exitTime + 0.04, function() -- Line: 1433
        -- upvalues: u289 (copy), u290 (copy), frame (copy)
        local table_find_ret = table.find(u289.items, u290);

        if table_find_ret then
            table.remove(u289.items, table_find_ret);
        end;

        u289:dropKey(u290);
        u289.motion:cancel(frame);
        frame:Destroy();
        u289:layout();
    end);
end;

function u194.updateMonitorLine(p292, p293, p294) -- Line: 1445
    if not (p292.config.monitorEnabled and p292.stack) then
        return;
    end;

    p292:updateStackSize();
    local v295 = p292.format:eventLine(p294);
    local v296 = p292:measuredWidth(v295);
    local v297 = p292:monitorY(p293);
    local v298 = p292.monitorFrames[p293];
    local v299 = p292.monitorLabels[p293];

    if v298 and (v298.Parent and v299) then
        v299.Text = v295;
    else
        v298, v299 = p292:buildRow(v295, p294.name or string.format("Monitor%d", p293));
        local v300 = p292:offscreenPosition(v296);
        v298.Position = UDim2.new(v300.X.Scale, v300.X.Offset, 0, v297);
        v299.TextTransparency = 1;
        p292.monitorFrames[p293] = v298;
        p292.monitorLabels[p293] = v299;
        p292:fadeIn(v299);
    end;

    p292:syncLabel(v299);
    p292:moveTo(v298, v297, v296, p292.config.motionTime);
end;

function u194.mount(p301, p302) -- Line: 1473
    -- upvalues: Players (copy), resolveAnchor (copy), u68 (copy)
    if not p302 then
        p302 = Players.LocalPlayer;

        if p302 then
            p302 = p302:WaitForChild("PlayerGui");
        end;
    end;

    if not p302 then
        return;
    end;

    if p301.mounted and (p301.gui and p301.gui.Parent) then
        return;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "Lori";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = p301.config.displayOrder;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = p302;
    local Frame = Instance.new("Frame");
    Frame.Name = "Stack";
    local v303, v304 = resolveAnchor(p301.config.anchor);
    local v305;

    if v303.X == 1 then
        v305 = -p301.config.rightOffset;
    else
        v305 = p301.config.leftOffset;
    end;

    local v306;

    if v303.Y == 1 then
        v306 = -p301.config.bottomOffset;
    else
        v306 = p301.config.topOffset;
    end;

    Frame.AnchorPoint = v303;
    Frame.Position = v304 + UDim2.fromOffset(v305, v306);
    Frame.Size = UDim2.fromOffset(p301:scaled(p301.config.minWidth), p301:scaled(p301.config.rowHeight));
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Parent = ScreenGui;
    p301.gui = ScreenGui;
    p301.stack = Frame;
    p301.graph = u68.new(p301);
    p301:updateScale();
    p301:updateStackSize();
    p301:bindViewport();
    p301.mounted = true;
end;

function u194.unmount(p307) -- Line: 1513
    for _, v in p307.items do
        v.dead = true;
    end;

    table.clear(p307.monitorFrames);
    table.clear(p307.monitorLabels);
    table.clear(p307.items);
    table.clear(p307.keyed);

    if p307.viewportConnection then
        p307.viewportConnection:Disconnect();
    end;

    if p307.cameraConnection then
        p307.cameraConnection:Disconnect();
    end;

    if p307.gui then
        p307.gui:Destroy();
    end;

    p307.gui = nil;
    p307.stack = nil;
    p307.graph = nil;
    p307.viewportConnection = nil;
    p307.cameraConnection = nil;
    p307.scale = 1;
    p307.mounted = false;
end;

function u194.push(p308, p309) -- Line: 1542
    if not p308.stack then
        return;
    end;

    local v310 = p309 and p309.key and p308.keyed[p309.key];

    if v310 and not v310.dead then
        p308:updateItem(v310, p309);

        return;
    end;

    p308:makeItem(p309 or {
        action = "event"
    });
end;

function u194.dismiss(p311, p312) -- Line: 1556
    local v313 = p311.keyed[p312];

    if v313 then
        p311:destroyItem(v313);
    end;
end;

function u194.clear(p314) -- Line: 1563
    for _, v in ipairs(table.clone(p314.items)) do
        p314:destroyItem(v);
    end;

    if p314.graph then
        p314.graph:clear();
    end;
end;

function u194.makeGraph(p315, p316, p317) -- Line: 1572
    if p315.graph then
        p315.graph:make(p316, p317);
    end;
end;

function u194.pushGraph(p318, p319, p320) -- Line: 1578
    if p318.graph then
        p318.graph:push(p319, p320);
    end;
end;

function u194.rescaleGraph(p321, p322, p323) -- Line: 1584
    if p321.graph then
        p321.graph:rescale(p322, p323);
    end;
end;

function u194.removeGraph(p324, p325) -- Line: 1590
    if p324.graph then
        p324.graph:remove(p325);
    end;
end;

local u326 = {};
u326.__index = u326;

function u326.new(p327, p328) -- Line: 1601
    -- upvalues: u326 (copy)
    return setmetatable({
        slowestMs = 0,
        slowestName = "none",
        lastSpikeMs = 0,
        lastSpikeAt = 0,
        lastSlowTraceAt = 0,
        config = p327,
        onSlowTrace = p328,
        window = {},
        sources = {}
    }, u326);
end;

function u326.recordSpike(p329, p330) -- Line: 1615
    if p329.config.spikeMs <= p330 then
        p329.lastSpikeMs = p330;
        p329.lastSpikeAt = os.clock();
    end;
end;

function u326.add(p331, p332, p333, p334, p335, p336) -- Line: 1622
    local string_format_ret = string.format("%s.%s", p333, p334);
    local v337 = p331.window[p332] or {
        count = 0,
        totalMs = 0,
        slowestMs = 0,
        slowestName = "none"
    };
    v337.count = v337.count + 1;
    v337.totalMs = v337.totalMs + p335;

    if v337.slowestMs < p335 then
        v337.slowestMs = p335;
        v337.slowestName = string_format_ret;
    end;

    p331.window[p332] = v337;
    local v338 = p331.sources[string_format_ret] or {
        count = 0,
        totalMs = 0,
        slowestMs = 0,
        kind = p332
    };
    v338.count = v338.count + 1;
    v338.totalMs = v338.totalMs + p335;
    v338.kind = p332;

    if v338.slowestMs < p335 then
        v338.slowestMs = p335;
    end;

    p331.sources[string_format_ret] = v338;

    if p331.slowestMs < p335 then
        p331.slowestMs = p335;
        p331.slowestName = string_format_ret;
    end;

    local os_clock_ret = os.clock();

    if p331.config.slowTraceMs <= p335 and os_clock_ret - p331.lastSlowTraceAt >= p331.config.slowTraceCooldown then
        p331.lastSlowTraceAt = os_clock_ret;

        if p331.onSlowTrace then
            p331.onSlowTrace(p332, p333, p334, p335, p336);
        end;
    end;
end;

function u326.summary(p339) -- Line: 1656
    local raycast = p339.window.raycast;
    local spherecast = p339.window.spherecast;
    local blockcast = p339.window.blockcast;
    local manual = p339.window.manual;
    local v340 = (raycast and (raycast.count or 0) or 0) + (spherecast and (spherecast.count or 0) or 0) + (blockcast and (blockcast.count or 0) or 0);
    local v341;

    if p339.lastSpikeMs > 0 then
        v341 = os.clock() - p339.lastSpikeAt <= p339.config.spikeHoldSeconds;
    else
        v341 = false;
    end;

    local v342 = {
        casts = v340,
        ray = raycast and raycast.count or 0,
        sphere = spherecast and spherecast.count or 0,
        block = blockcast and blockcast.count or 0,
        manual = manual and manual.count or 0
    };
    local v343;

    if p339.slowestMs > 0 then
        local slowestName = p339.slowestName;
        local slowestMs = p339.slowestMs;
        v343 = string.format("%s:%s", slowestName == "untracked-frame" and "untracked" or slowestName, slowestMs >= 100 and string.format("%.0fms", slowestMs) or string.format("%.1fms", slowestMs)) or "-";
    else
        v343 = "-";
    end;

    v342.max = v343;
    local v344;

    if v341 then
        local lastSpikeMs = p339.lastSpikeMs;
        v344 = lastSpikeMs >= 100 and string.format("%.0fms", lastSpikeMs) or string.format("%.1fms", lastSpikeMs) or "-";
    else
        v344 = "-";
    end;

    v342.spike = v344;
    v342.spikeActive = v341;

    return v342;
end;

function u326.causeSummary(p345, p346) -- Line: 1676
    local slowestName = p345.slowestName;
    local slowestMs = p345.slowestMs;
    local v347 = 0;
    local v348 = 0;
    local v349 = "none";
    local v350 = 0;

    for i, v in p345.sources do
        v347 = v347 + v.totalMs;

        if v348 < v.totalMs then
            v348 = v.totalMs;
            v350 = v.count;
            v349 = i;
        end;
    end;

    local v351;

    if p345.lastSpikeMs > 0 then
        v351 = os.clock() - p345.lastSpikeAt <= p345.config.spikeHoldSeconds;
    else
        v351 = false;
    end;

    local math_max_ret = math.max(p346 or 0, v351 and (p345.lastSpikeMs or 0) or 0);
    local math_max_ret2 = math.max(0, math_max_ret - v347);

    if math_max_ret >= 28 and math.max(v347, 4) < math_max_ret2 then
        slowestMs = math_max_ret2;
        v348 = slowestMs;
        local v352 = slowestMs;
        slowestMs = v348;
        v352 = v348;
        v349 = "untracked-frame";
        v350 = 1;
        slowestName = "untracked-frame";
    elseif v351 and v349 == "none" then
        v348 = p345.lastSpikeMs;
        slowestMs = p345.lastSpikeMs;
        v349 = "untracked-frame";
        v350 = 1;
        slowestName = "untracked-frame";
    end;

    local v353 = {
        top = v349 == "untracked-frame" and "untracked" or v349,
        total = v348 > 0 and (v348 >= 100 and string.format("%.0fms", v348) or string.format("%.1fms", v348) or "0ms") or "0ms",
        count = v350,
        max = slowestMs > 0 and (string.format("%s:%s", slowestName == "untracked-frame" and "untracked" or slowestName, slowestMs >= 100 and string.format("%.0fms", slowestMs) or string.format("%.1fms", slowestMs)) or "-") or "-"
    };
    local v354;

    if v351 then
        local lastSpikeMs = p345.lastSpikeMs;
        v354 = lastSpikeMs >= 100 and string.format("%.0fms", lastSpikeMs) or string.format("%.1fms", lastSpikeMs) or "-";
    else
        v354 = "-";
    end;

    v353.spike = v354;
    v353.tracked = v347 > 0 and (v347 >= 100 and string.format("%.0fms", v347) or string.format("%.1fms", v347) or "0ms") or "0ms";
    v353.spikeActive = v351;

    return v353;
end;

function u326.resetWindow(p355) -- Line: 1721
    table.clear(p355.window);
    table.clear(p355.sources);
    p355.slowestMs = 0;
    p355.slowestName = "none";
end;

function u326.reset(p356) -- Line: 1728
    p356:resetWindow();
    p356.lastSpikeMs = 0;
    p356.lastSpikeAt = 0;
    p356.lastSlowTraceAt = 0;
end;

local u364 = {
    applyAliases = function(p357) -- Line: 1739, Name: applyAliases
        if typeof(p357.position) == "Vector2" then
            p357.rightOffset = p357.position.X;
            p357.topOffset = p357.position.Y;
        end;

        if type(p357.leftOffset) ~= "number" then
            p357.leftOffset = p357.rightOffset;
        end;

        if type(p357.bottomOffset) ~= "number" then
            p357.bottomOffset = p357.gap;
        end;

        if type(p357.anchor) == "string" then
            p357.anchor = string.lower(p357.anchor);
        end;

        if type(p357.width) == "number" then
            p357.maxWidth = p357.width;
        end;

        if type(p357.fontSize) == "number" then
            p357.textSize = p357.fontSize;
        end;

        if type(p357.monitorInterval) == "number" then
            p357.interval = p357.monitorInterval;
        end;

        local v358 = tonumber(p357.minInterval) or (tonumber(0.04) or 0);
        local v359 = tonumber(0) or 0;
        p357.minInterval = math.max(v359, v358);
        local minInterval = p357.minInterval;
        local v360 = tonumber(p357.interval) or (tonumber(0.1) or 0);
        local v361 = tonumber(minInterval) or 0;
        p357.interval = math.max(v361, v360);
        local interval = p357.interval;
        local minInterval2 = p357.minInterval;
        local v362 = tonumber(p357.liveInterval) or (tonumber(interval) or 0);
        local v363 = tonumber(minInterval2) or 0;
        p357.liveInterval = math.max(v363, v362);
        p357.monitorInterval = p357.interval;
    end
};

function u364.merge(p365) -- Line: 1775
    -- upvalues: u4 (copy), u364 (copy)
    local table_clone_ret = table.clone(u4);

    if type(p365) == "table" then
        for i, v in p365 do
            table_clone_ret[i] = v;
        end;
    end;

    u364.applyAliases(table_clone_ret);

    return table_clone_ret;
end;

function u364.mergeTheme(p366) -- Line: 1786
    -- upvalues: u1 (copy)
    local table_clone_ret = table.clone(u1);

    if type(p366) == "table" then
        for i, v in p366 do
            table_clone_ret[i] = v;
        end;
    end;

    return table_clone_ret;
end;

local u367 = {};
local u368 = {
    FPS = "FpsGraph",
    Frame = "Frame",
    Memory = "MemGraph",
    Ping = "PingGraph",
    Pressure = "Pressure"
};

function u367.register(u369) -- Line: 1808
    -- upvalues: u368 (copy)
    function u369.addItem(p370, p371) -- Line: 1809
        -- upvalues: u369 (copy)
        table.insert(u369.Blacklist, p371);

        return u369;
    end;

    for i, v in u368 do
        u369[i] = function() -- Line: 1815
            -- upvalues: u369 (copy), v (copy)
            return u369:addItem(v);
        end;
    end;

    return u369;
end;

function u367.new() -- Line: 1823
    -- upvalues: u367 (copy)
    local v372 = setmetatable({
        Blacklist = {}
    }, {
        __type = "Item Blacklist"
    });

    return u367.register(v372);
end;

local u373 = {};
u373.__index = u373;

function u373.new() -- Line: 1835
    -- upvalues: u373 (copy)
    return setmetatable({
        id = "runtime.fpsgraph",
        connection = nil,
        client = nil,
        lastSample = 0,
        fps = 60
    }, u373);
end;

function u373.start(u374, u375) -- Line: 1845
    -- upvalues: RunService (copy)
    if u374.connection then
        return;
    end;

    u374.client = u375;
    u375.render:makeGraph("fps", {
        tone = "success",
        unit = "fps",
        style = "bars",
        warnBelow = 45,
        failBelow = 30
    });
    u374.connection = RunService.RenderStepped:Connect(function(p376) -- Line: 1859
        -- upvalues: u374 (copy), u375 (copy)
        u374.fps = u374.fps + (1 / math.max(p376, 0.0001) - u374.fps) * 0.1;
        local os_clock_ret = os.clock();

        if os_clock_ret - u374.lastSample < u375.config.monitorInterval then
            return;
        end;

        u374.lastSample = os_clock_ret;
        u375.render:pushGraph("fps", u374.fps);
    end);
end;

function u373.stop(p377) -- Line: 1872
    if p377.connection then
        p377.connection:Disconnect();
    end;

    if p377.client then
        p377.client.render:removeGraph("fps");
    end;

    p377.connection = nil;
    p377.client = nil;
    p377.lastSample = 0;
    p377.fps = 60;
end;

local u378 = {};
u378.__index = u378;

function u378.new(p379) -- Line: 1888
    -- upvalues: u378 (copy)
    return setmetatable({
        id = "runtime.frame",
        renderConnection = nil,
        heartbeatConnection = nil,
        accum = 0,
        framesSeen = 0,
        heartbeatAccum = 0,
        heartbeatFrames = 0,
        row = p379
    }, u378);
end;

function u378.start(u380, u381) -- Line: 1901
    -- upvalues: RunService (copy)
    if u380.renderConnection then
        return;
    end;

    u381.render:updateMonitorLine(u380.row, {
        action = "core",
        scope = "runtime.frame",
        tone = "phase",
        name = "Frame",
        fields = {
            dt = "--",
            r = "--",
            hb = "--",
            sp = "--"
        }
    });
    u380.heartbeatConnection = RunService.Heartbeat:Connect(function(p382) -- Line: 1914
        -- upvalues: u380 (copy)
        u380.heartbeatAccum = u380.heartbeatAccum + p382;
        u380.heartbeatFrames = u380.heartbeatFrames + 1;
    end);
    u380.renderConnection = RunService.RenderStepped:Connect(function(p383) -- Line: 1919
        -- upvalues: u381 (copy), u380 (copy)
        local v384 = p383 * 1000;
        u381.perf:recordSpike(v384);
        u380.accum = u380.accum + p383;
        u380.framesSeen = u380.framesSeen + 1;

        if u380.accum < u381.config.monitorInterval then
            return;
        end;

        local math_floor_ret = math.floor(u380.framesSeen / u380.accum + 0.5);
        local v385 = u380.accum / math.max(u380.framesSeen, 1) * 1000;
        u381.monitor.frameMs = v385;

        if u380.heartbeatAccum > 0 then
            u381.monitor.heartbeatMs = u380.heartbeatAccum / math.max(u380.heartbeatFrames, 1) * 1000;
            u380.heartbeatFrames = 0;
            u380.heartbeatAccum = 0;
        end;

        local v386;

        if u381.perf.lastSpikeMs > 0 then
            v386 = os.clock() - u381.perf.lastSpikeAt <= u381.config.spikeHoldSeconds;
        else
            v386 = false;
        end;

        u381.render:updateMonitorLine(u380.row, {
            scope = "runtime.frame",
            action = "core",
            name = "Frame",
            fields = {
                sp = v386 and string.format("%.1fms", u381.perf.lastSpikeMs) or "-",
                hb = string.format("%.1fms", u381.monitor.heartbeatMs),
                r = string.format("%.1fms", v385),
                dt = string.format("%.1fms", v384)
            },
            tone = math_floor_ret >= 55 and (v385 < 19 and not v386) and "success" or (math_floor_ret >= 40 and v385 < 28 and "warn" or "error")
        });
        u380.accum = 0;
        u380.framesSeen = 0;
    end);
end;

function u378.stop(p387) -- Line: 1964
    if p387.renderConnection then
        p387.renderConnection:Disconnect();
    end;

    if p387.heartbeatConnection then
        p387.heartbeatConnection:Disconnect();
    end;

    p387.renderConnection = nil;
    p387.heartbeatConnection = nil;
    p387.accum = 0;
    p387.framesSeen = 0;
    p387.heartbeatAccum = 0;
    p387.heartbeatFrames = 0;
end;

local u388 = {};
u388.__index = u388;

local function totalMemory() -- Line: 1982
    -- upvalues: Stats (copy)
    local success, result = pcall(function() -- Line: 1983
        -- upvalues: Stats (ref)
        return Stats:GetTotalMemoryUsageMb();
    end);

    return success and result and result or 0;
end;

function u388.new() -- Line: 1989
    -- upvalues: u388 (copy)
    return setmetatable({
        id = "runtime.memgraph",
        connection = nil,
        client = nil,
        lastSample = 0
    }, u388);
end;

function u388.start(u389, u390) -- Line: 1998
    -- upvalues: RunService (copy), Stats (copy)
    if u389.connection then
        return;
    end;

    u389.client = u390;
    u390.render:makeGraph("mem", {
        tone = "phase",
        style = "bars",
        unit = "mb",
        warnAt = 3000,
        failAt = 6000
    });
    u389.connection = RunService.RenderStepped:Connect(function() -- Line: 2012
        -- upvalues: u389 (copy), u390 (copy), Stats (ref)
        local os_clock_ret = os.clock();

        if os_clock_ret - u389.lastSample < u390.config.monitorInterval then
            return;
        end;

        u389.lastSample = os_clock_ret;
        local render = u390.render;
        local success, result = pcall(function() -- Line: 1983
            -- upvalues: Stats (ref)
            return Stats:GetTotalMemoryUsageMb();
        end);
        render:pushGraph("mem", success and result and result or 0);
    end);
end;

function u388.stop(p391) -- Line: 2022
    if p391.connection then
        p391.connection:Disconnect();
    end;

    if p391.client then
        p391.client.render:removeGraph("mem");
    end;

    p391.connection = nil;
    p391.client = nil;
    p391.lastSample = 0;
end;

local u392 = {};
u392.__index = u392;

local function pingMs() -- Line: 2037
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return 0;
    end;

    local success, result = pcall(function() -- Line: 2042
        -- upvalues: LocalPlayer (copy)
        return LocalPlayer:GetNetworkPing();
    end);

    return success and (tonumber(result) or 0) * 1000 or 0;
end;

function u392.new() -- Line: 2048
    -- upvalues: u392 (copy)
    return setmetatable({
        id = "runtime.pinggraph",
        connection = nil,
        client = nil,
        lastSample = 0
    }, u392);
end;

function u392.start(u393, u394) -- Line: 2057
    -- upvalues: RunService (copy), Players (copy)
    if u393.connection then
        return;
    end;

    u393.client = u394;
    u394.render:makeGraph("ping", {
        tone = "warn",
        style = "bars",
        unit = "ms",
        warnAt = 120,
        failAt = 220
    });
    u393.connection = RunService.RenderStepped:Connect(function() -- Line: 2071
        -- upvalues: u393 (copy), u394 (copy), Players (ref)
        local os_clock_ret = os.clock();

        if os_clock_ret - u393.lastSample < u394.config.monitorInterval then
            return;
        end;

        u393.lastSample = os_clock_ret;
        local render = u394.render;
        local LocalPlayer = Players.LocalPlayer;
        local v395;

        if LocalPlayer then
            local success, result = pcall(function() -- Line: 2042
                -- upvalues: LocalPlayer (copy)
                return LocalPlayer:GetNetworkPing();
            end);
            v395 = success and (tonumber(result) or 0) * 1000 or 0;
        else
            v395 = 0;
        end;

        render:pushGraph("ping", v395);
    end);
end;

function u392.stop(p396) -- Line: 2081
    if p396.connection then
        p396.connection:Disconnect();
    end;

    if p396.client then
        p396.client.render:removeGraph("ping");
    end;

    p396.connection = nil;
    p396.client = nil;
    p396.lastSample = 0;
end;

local u397 = {};
u397.__index = u397;

function u397.new(p398) -- Line: 2096
    -- upvalues: u397 (copy)
    return setmetatable({
        id = "runtime.perf",
        connection = nil,
        lastPerf = 0,
        row = p398
    }, u397);
end;

function u397.start(u399, u400) -- Line: 2105
    -- upvalues: RunService (copy)
    if u399.connection then
        return;
    end;

    u400.render:updateMonitorLine(u399.row, {
        scope = "runtime.perf",
        action = "pressure",
        name = "Pressure",
        tone = "phase",
        fields = {
            peak = "-",
            why = "-",
            t = "0ms",
            own = "0ms",
            cast = 0
        }
    });
    u399.connection = RunService.RenderStepped:Connect(function() -- Line: 2118
        -- upvalues: u399 (copy), u400 (copy)
        local os_clock_ret = os.clock();

        if os_clock_ret - u399.lastPerf < u400.config.monitorInterval then
            return;
        end;

        u399.lastPerf = os_clock_ret;
        local v401 = u400.perf:summary();
        local v402 = u400.perf:causeSummary(u400.monitor.frameMs);
        u400.render:updateMonitorLine(u399.row, {
            action = "pressure",
            scope = "runtime.perf",
            name = "Pressure",
            fields = {
                cast = v401.casts,
                own = v402.tracked,
                peak = v401.max,
                why = v402.top,
                t = v402.total
            },
            tone = v402.spikeActive and "error" or ((u400.monitor.frameMs >= 28 or u400.monitor.heartbeatMs >= 28) and "warn" or "phase")
        });
        u400.perf:resetWindow();
    end);
end;

function u397.stop(p403) -- Line: 2150
    if p403.connection then
        p403.connection:Disconnect();
    end;

    p403.connection = nil;
    p403.lastPerf = 0;
end;

local u404 = {};
u404.__index = u404;
local u405 = {};

local function performanceTemplate(p406) -- Line: 2168
    -- upvalues: u378 (copy), u397 (copy), u392 (copy), u373 (copy), u388 (copy)
    local function toSet(p407) -- Line: 2169
        local v408 = {};

        if typeof(p407) == "table" then
            for _, v in p407 do
                v408[v] = true;
            end;
        end;

        return v408;
    end;

    local v409 = {};

    if typeof(p406) == "table" then
        for _, v in p406 do
            v409[v] = true;
        end;
    end;

    local v410 = {};

    for _, v in {
        {
            name = "Frame",
            row = 1,
            module = u378
        },
        {
            name = "Pressure",
            row = 2,
            module = u397
        },
        {
            name = "PingGraph",
            module = u392
        },
        {
            name = "FpsGraph",
            module = u373
        },
        {
            name = "MemGraph",
            module = u388
        }
    } do
        if not v409[v.name] then
            table.insert(v410, v.module.new(v.row));
        end;
    end;

    return {
        id = "performance",
        monitorRows = 2,
        providers = v410
    };
end;

local function emptyTemplate() -- Line: 2160
    return {
        id = "empty",
        monitorRows = 0,
        providers = {}
    };
end;

local function bindDotMethods(u411, p412, p413) -- Line: 169
    for _, v in p413 do
        local u414 = p412[v];

        u411[v] = function(p415, ...) -- Line: 172
            -- upvalues: u411 (copy), u414 (copy)
            if p415 == u411 then
                return u414(u411, ...);
            end;

            return u414(u411, p415, ...);
        end;
    end;
end;

for _, v in { "config", "template", "templateBlacklist", "theme" } do
    u405[v] = true;
end;

local function normalizeTemplateBlacklist(p416) -- Line: 2213
    if not p416 then
        return {};
    end;

    if getmetatable(p416) then
        local v417 = getmetatable(p416);

        if rawget(v417, "__type") == "Item Blacklist" then
            return p416.Blacklist;
        end;
    end;

    return p416;
end;

local function resolveTemplate(p418, p419) -- Line: 2222
    if p419 then
        if getmetatable(p419) then
            local v420 = getmetatable(p419);

            if rawget(v420, "__type") == "Item Blacklist" then
                p419 = p419.Blacklist;
            end;
        end;
    else
        p419 = {};
    end;

    if type(p418) == "function" then
        return p418(p419);
    end;

    return type(p418) ~= "table" and {
        id = "empty",
        monitorRows = 0,
        providers = {}
    } or p418;
end;

local function applyConfig(p421, p422) -- Line: 2234
    -- upvalues: u405 (copy), u364 (copy)
    if type(p422) ~= "table" then
        return;
    end;

    for i, v in p422 do
        if not u405[i] then
            p421[i] = v;
        end;
    end;

    if type(p422.config) == "table" then
        for i, v in p422.config do
            p421[i] = v;
        end;
    end;

    if type(p422.monitorInterval) == "number" and type(p422.interval) ~= "number" then
        p421.interval = p422.monitorInterval;
    end;

    if type(p422.config) == "table" and (type(p422.config.monitorInterval) == "number" and type(p422.config.interval) ~= "number") then
        p421.interval = p422.config.monitorInterval;
    end;

    u364.applyAliases(p421);
end;

local function configFromOptions(p423) -- Line: 2260
    -- upvalues: applyConfig (copy), u364 (copy)
    local v424 = {};
    applyConfig(v424, p423);

    return u364.merge(v424);
end;

local function bindChannel(u425, u426, u427) -- Line: 2266
    u425[u426] = function(p428, p429, p430, p431) -- Line: 2267
        -- upvalues: u425 (copy), u426 (copy), u427 (copy)
        local v432;

        if p428 == u425 then
            v432 = p428;
        else
            v432 = u425;
        end;

        if p428 == u425 then
            p428 = p429;
        end;

        return v432._client[u426](v432._client, u427, p428, p430, p431);
    end;
end;

function u404.new(p433) -- Line: 2274
    -- upvalues: applyConfig (copy), u364 (copy), u19 (copy), u194 (copy), u404 (copy), u326 (copy), bindDotMethods (copy)
    local v434 = p433 or {};
    local v435 = v434.templateBlacklist or {};
    local v436 = {};
    applyConfig(v436, v434);
    local v437 = u364.merge(v436);
    local v438 = u364.mergeTheme(v434.theme or v437.theme);
    local v439 = v434.template or v437.template;

    if v435 then
        if getmetatable(v435) then
            local v440 = getmetatable(v435);

            if rawget(v440, "__type") == "Item Blacklist" then
                v435 = v435.Blacklist;
            end;
        end;
    else
        v435 = {};
    end;

    local v441;

    if type(v439) == "function" then
        v441 = v439(v435);
    else
        v441 = type(v439) ~= "table" and {
            id = "empty",
            monitorRows = 0,
            providers = {}
        } or v439;
    end;

    local v442 = u19.new(v438);
    local v443 = {
        perf = nil,
        mounted = false,
        config = v437,
        theme = v438,
        template = v441,
        format = v442,
        render = u194.new(v437, v438, v442, v441.monitorRows or 0),
        providers = v441.providers or {},
        monitor = {
            frameMs = 0,
            heartbeatMs = 0
        },
        channels = {},
        watches = {}
    };
    local u444 = setmetatable(v443, u404);
    u444.perf = u326.new(v437, function(p445, p446, p447, p448, p449) -- Line: 2302
        -- upvalues: u444 (copy)
        local v450 = {
            scope = p446,
            action = p447,
            ms = string.format("%.2f", p448),
            kind = p445
        };

        if type(p449) == "table" then
            for i, v in p449 do
                v450[i] = v;
            end;
        end;

        u444:warn("runtime.perf", "slow", v450, 4);
    end);
    bindDotMethods(u444, u404, { "isActive", "setTheme", "setTemplate", "mount", "unmount", "push", "dismiss", "begin", "finish", "record", "time", "measure", "watch", "graph", "inspect", "emit", "channel", "group", "raycast", "spherecast", "blockcast", "trace", "info", "phase", "success", "warn", "fail", "error", "clear", "destroy" });

    return u444;
end;

function u404.isActive(p451) -- Line: 2353
    -- upvalues: RunService (copy)
    if p451.config.enabled then
        return not p451.config.studioOnly or RunService:IsStudio();
    end;

    return false;
end;

function u404.setTheme(p452, p453) -- Line: 2360
    -- upvalues: u364 (copy), u19 (copy)
    p452.theme = u364.mergeTheme(p453);
    p452.format = u19.new(p452.theme);
    p452.render.theme = p452.theme;
    p452.render.format = p452.format;
    p452.render:applyTheme();
end;

function u404.setTemplate(p454, p455, p456) -- Line: 2368
    for _, v in p454.providers do
        v:stop();
    end;

    if p456 then
        if getmetatable(p456) then
            local v457 = getmetatable(p456);

            if rawget(v457, "__type") == "Item Blacklist" then
                p456 = p456.Blacklist;
            end;
        end;
    else
        p456 = {};
    end;

    local v458;

    if type(p455) == "function" then
        v458 = p455(p456);
    else
        v458 = type(p455) ~= "table" and {
            id = "empty",
            monitorRows = 0,
            providers = {}
        } or p455;
    end;

    p454.template = v458;
    p454.providers = v458.providers or {};
    p454.render:setMonitorRows(v458.monitorRows or 0);

    if p454.mounted and p454.config.monitorEnabled then
        for _, v in p454.providers do
            v:start(p454);
        end;
    end;
end;

function u404.mount(p459, p460, p461) -- Line: 2386
    -- upvalues: applyConfig (copy)
    if p461 then
        applyConfig(p459.config, p461);

        if p461.theme then
            p459:setTheme(p461.theme);
        end;

        if p461.template then
            p459:setTemplate(p461.template, (rawget(p461, "templateBlacklist")));
        end;
    end;

    if not p459:isActive() then
        return;
    end;

    p459.render:mount(p460);

    if p459.mounted then
        return;
    end;

    p459.mounted = true;

    if p459.config.monitorEnabled then
        for _, v in p459.providers do
            v:start(p459);
        end;
    end;
end;

function u404.unmount(p462) -- Line: 2416
    for _, v in p462.providers do
        v:stop();
    end;

    for _, v in table.clone(p462.watches) do
        v:disconnect();
    end;

    table.clear(p462.watches);
    p462.perf:reset();
    p462.monitor.frameMs = 0;
    p462.monitor.heartbeatMs = 0;
    p462.render:unmount();
    p462.mounted = false;
end;

function u404.push(p463, p464) -- Line: 2433
    if not p463:isActive() then
        return;
    end;

    local v465 = type(p464) ~= "table" and {
        tone = "trace",
        scope = "runtime",
        action = tostring(p464 or "event")
    } or p464;

    if not p463.render.mounted then
        p463:mount();
    end;

    p463.render:push(v465);
end;

function u404.dismiss(p466, p467) -- Line: 2444
    p466.render:dismiss(p467);
end;

function u404.begin(p468, p469, p470) -- Line: 2448
    return {
        scope = p469 or "runtime",
        action = p470 or "work",
        started = os.clock()
    };
end;

function u404.finish(p471, p472, p473) -- Line: 2456
    if type(p472) ~= "table" then
        return 0;
    end;

    local v474 = (os.clock() - p472.started) * 1000;
    p471.perf:add("manual", p472.scope or "runtime", p472.action or "work", v474, p473);

    return v474;
end;

function u404.record(p475, p476, p477, p478, p479) -- Line: 2466
    p475.perf:add("manual", p476 or "runtime", p477 or "work", tonumber(p478) or 0, p479);
end;

function u404.time(u480, p481, p482) -- Line: 2470
    local u483 = u480:begin(p481, p482);

    return function(p484) -- Line: 2472
        -- upvalues: u480 (copy), u483 (copy)
        return u480:finish(u483, p484);
    end;
end;

function u404.measure(p485, p486, p487, p488) -- Line: 2477
    local v489 = p485:begin(p486, p487);
    local success, result = pcall(p488);
    local v490 = p485:finish(v489);

    if not success then
        p485:fail(p486, p487 or "measure", {
            error = result,
            ms = string.format("%.2f", v490)
        }, 6);
        error(result);
    end;

    return result, v490;
end;

function u404.watch(u491, u492, p493, p494) -- Line: 2488
    -- upvalues: bindDotMethods (copy)
    local v495 = p494 or {};
    local v496 = {
        sticky = true,
        fields = p493
    };
    local v497;

    if v495.interval == nil then
        v497 = u491.config.liveInterval;
    else
        v497 = v495.interval;
    end;

    v496.liveInterval = v497;
    v496.action = v495.action or "watch";
    v496.scope = v495.scope or u492;
    v496.tone = v495.tone or "phase";
    v496.key = u492;
    u491:push(v496);
    local v499 = {
        disconnect = function(p498) -- Line: 2504, Name: disconnect
            -- upvalues: u491 (copy), u492 (copy)
            p498.connected = false;
            u491:dismiss(u492);
            u491.watches[u492] = nil;
        end,

        connected = true
    };
    bindDotMethods(v499, v499, { "disconnect" });
    u491.watches[u492] = v499;

    return v499;
end;

function u404.graph(u500, u501, p502) -- Line: 2517
    -- upvalues: bindDotMethods (copy)
    if not u500:isActive() then
        local v506 = {
            push = function(p503) -- Line: 2520, Name: push
            end,

            rescale = function(p504) -- Line: 2521, Name: rescale
            end,

            remove = function(p505) -- Line: 2522, Name: remove
            end
        };
        bindDotMethods(v506, v506, { "push", "rescale", "remove" });

        return v506;
    end;

    if not u500.render.mounted then
        u500:mount();
    end;

    u500.render:makeGraph(u501, p502);
    local v512 = {
        push = function(p507, p508) -- Line: 2536, Name: push
            -- upvalues: u500 (copy), u501 (copy)
            u500.render:pushGraph(u501, p508);
        end,

        rescale = function(p509, p510) -- Line: 2540, Name: rescale
            -- upvalues: u500 (copy), u501 (copy)
            u500.render:rescaleGraph(u501, p510);
        end,

        remove = function(p511) -- Line: 2544, Name: remove
            -- upvalues: u500 (copy), u501 (copy)
            u500.render:removeGraph(u501);
        end
    };
    bindDotMethods(v512, v512, { "push", "rescale", "remove" });

    return v512;
end;

function u404.inspect(p513, p514, p515, p516) -- Line: 2552
    local v517 = {};

    if type(p515) == "table" then
        local v518 = 0;

        for i, v in p515 do
            v518 = v518 + 1;

            if v518 > 12 then
                v517[".."] = "more";
                break;
            end;

            v517[tostring(i)] = v;
        end;
    else
        v517.value = p515;
    end;

    p513:trace(p514 or "inspect", "value", v517, p516 or 6);
end;

function u404.emit(p519, p520, p521, p522, p523, p524) -- Line: 2570
    p519:push({
        fields = p523,
        duration = p524,
        action = p522,
        scope = p521,
        tone = p520
    });
end;

function u404.channel(p525, u526) -- Line: 2580
    -- upvalues: bindDotMethods (copy)
    local v527 = p525.channels[u526];

    if v527 then
        return v527;
    end;

    local u528 = {};

    for _, v in { "trace", "info", "phase", "success", "warn", "fail", "error" } do
        u528[v] = function(p529, p530, p531, p532) -- Line: 2267
            -- upvalues: u528 (copy), v (copy), u526 (copy)
            local v533;

            if p529 == u528 then
                v533 = p529;
            else
                v533 = u528;
            end;

            if p529 == u528 then
                p529 = p530;
            end;

            return v533._client[v](v533._client, u526, p529, p531, p532);
        end;
    end;

    function u528.watch(p534, p535, p536) -- Line: 2591
        -- upvalues: u526 (copy)
        local v537 = p536 or {};
        v537.scope = u526;

        return p534._client:watch(u526, p535, v537);
    end;

    function u528.time(p538, p539) -- Line: 2597
        -- upvalues: u526 (copy)
        return p538._client:time(u526, p539);
    end;

    function u528.measure(p540, p541, p542) -- Line: 2601
        -- upvalues: u526 (copy)
        return p540._client:measure(u526, p541, p542);
    end;

    u528._client = p525;
    bindDotMethods(u528, u528, { "watch", "time", "measure" });
    p525.channels[u526] = u528;

    return u528;
end;

function u404.group(p543, p544) -- Line: 2612
    return p543:channel(p544);
end;

function u404.raycast(p545, p546, p547, p548, p549) -- Line: 2616
    -- upvalues: Workspace (copy)
    local os_clock_ret = os.clock();
    local v550 = Workspace:Raycast(p547, p548, p549);
    p545.perf:add("raycast", p546 or "runtime", "raycast", (os.clock() - os_clock_ret) * 1000, {
        hit = v550 and v550.Instance and (v550.Instance.Name or "none") or "none"
    });

    return v550;
end;

function u404.spherecast(p551, p552, p553, p554, p555, p556) -- Line: 2625
    -- upvalues: Workspace (copy)
    local os_clock_ret = os.clock();
    local v557 = Workspace:Spherecast(p553, p554, p555, p556);
    p551.perf:add("spherecast", p552 or "runtime", "spherecast", (os.clock() - os_clock_ret) * 1000, {
        hit = v557 and v557.Instance and (v557.Instance.Name or "none") or "none"
    });

    return v557;
end;

function u404.blockcast(p558, p559, p560, p561, p562, p563) -- Line: 2634
    -- upvalues: Workspace (copy)
    local os_clock_ret = os.clock();
    local v564 = Workspace:Blockcast(p560, p561, p562, p563);
    p558.perf:add("blockcast", p559 or "runtime", "blockcast", (os.clock() - os_clock_ret) * 1000, {
        hit = v564 and v564.Instance and (v564.Instance.Name or "none") or "none"
    });

    return v564;
end;

function u404.trace(p565, p566, p567, p568, p569) -- Line: 2643
    p565:emit("trace", p566, p567, p568, p569);
end;

function u404.info(p570, p571, p572, p573, p574) -- Line: 2647
    p570:trace(p571, p572, p573, p574);
end;

function u404.phase(p575, p576, p577, p578, p579) -- Line: 2651
    p575:emit("phase", p576, p577, p578, p579);
end;

function u404.success(p580, p581, p582, p583, p584) -- Line: 2655
    p580:emit("success", p581, p582, p583, p584);
end;

function u404.warn(p585, p586, p587, p588, p589) -- Line: 2659
    p585:emit("warn", p586, p587, p588, p589);
end;

function u404.fail(p590, p591, p592, p593, p594) -- Line: 2663
    p590:emit("error", p591, p592, p593, p594);
end;

function u404.error(p595, p596, p597, p598, p599) -- Line: 2667
    p595:fail(p596, p597, p598, p599);
end;

function u404.clear(p600) -- Line: 2671
    p600.render:clear();
end;

function u404.destroy(p601) -- Line: 2675
    p601:unmount();
end;

local u602 = {
    Templates = {}
};
local u603 = nil;

local function getDefaultClient() -- Line: 2687
    -- upvalues: u603 (ref), u404 (copy)
    if not u603 then
        u603 = u404.new();
    end;

    return u603;
end;

local function callDefault(p604, ...) -- Line: 2694
    -- upvalues: u603 (ref), u404 (copy)
    if not u603 then
        u603 = u404.new();
    end;

    local v605 = u603;

    return v605[p604](v605, ...);
end;

local function forward(u606) -- Line: 2699
    -- upvalues: u602 (copy), callDefault (copy)
    u602[u606] = function(...) -- Line: 2700
        -- upvalues: callDefault (ref), u606 (copy)
        return callDefault(u606, ...);
    end;
end;

function u602.create(p607) -- Line: 2705
    -- upvalues: u404 (copy)
    return u404.new(p607);
end;

function u602.unmount() -- Line: 2709
    -- upvalues: u603 (ref)
    if u603 then
        u603:unmount();
    end;
end;

function u602.destroy() -- Line: 2715
    -- upvalues: u603 (ref)
    if u603 then
        u603:destroy();
        u603 = nil;
    end;
end;

u602.Templates = table.freeze({
    Performance = performanceTemplate,
    Empty = emptyTemplate,
    ItemBlacklister = u367
});
u602.Themes = {
    Default = u1
};

for _, v in { "mount", "setTheme", "setTemplate", "push", "dismiss", "begin", "finish", "record", "time", "measure", "watch", "graph", "inspect", "channel", "group", "raycast", "spherecast", "blockcast", "trace", "info", "phase", "success", "warn", "fail", "error", "clear" } do
    u602[v] = function(...) -- Line: 2700
        -- upvalues: callDefault (copy), v (copy)
        return callDefault(v, ...);
    end;
end;

return table.freeze(u602);