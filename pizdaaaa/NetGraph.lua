-- ReplicatedStorage.GameClient.Gui.HUD.NetGraph
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.NetGraph
-- Decompile time: 24.17 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Stats = game:GetService("Stats");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Color3_fromRGB_ret = Color3.fromRGB(230, 230, 179);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 31);
local Color3_fromRGB_ret3 = Color3.fromRGB(255, 125, 31);
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 31, 31);
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
local u11 = {};
local u12 = "Off";
local u13 = "Right";
local u14 = 0;
local u15 = 64;
local u16 = false;
local u17 = true;
local u18 = true;
local u19 = 0;
local u20 = 0;
local u21 = {};
local table_create_ret = table.create(30, 0.016666666666666666);
local u22 = 1;
local u23 = {
    FrameTimeMs = 3.5,
    FrameStdDevMs = 0.4,
    TickVarMs = 0.012,
    TickRate = 64
};
local u24 = 0;
local u25 = 0;
local os_clock_ret = os.clock();
local u26 = nil;
local u27 = 0;
local u28 = 0;
local u29 = 0;
local u30 = 0;
local u31 = 0;
local u32 = false;
local u33 = 0;
local u34 = 0;

local function BuildLine(p35: string, p36: string, p37: string, p38: number) -- Line: 77
    return p36 .. string.rep(" ", (math.max(2, p38 - #p35))) .. p37;
end;

local function GetColorFromVariance(p39: number, p40: number, p41: number, p42: number, p43: number) -- Line: 82
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy)
    if p40 <= 0 then
        return Color3_fromRGB_ret;
    end;

    local v44 = math.abs(p40 - p39) / p40;

    if p43 < v44 then
        return Color3_fromRGB_ret4;
    end;

    if p42 < v44 then
        return Color3_fromRGB_ret3;
    end;

    if p41 < v44 then
        return Color3_fromRGB_ret2;
    end;

    return Color3_fromRGB_ret;
end;

local function CalculateFrameVar() -- Line: 98
    -- upvalues: table_create_ret (copy)
    local v45 = #table_create_ret;

    if v45 < 2 then
        return 0;
    end;

    local v46 = 0;

    for _, v in ipairs(table_create_ret) do
        v46 = v46 + v;
    end;

    local v47 = v46 / v45;
    local v48 = 0;

    for _, v in ipairs(table_create_ret) do
        local v49 = v - v47;
        v48 = v48 + v49 * v49;
    end;

    return math.sqrt(v48 / v45) * 1000;
end;

local function GetServerTypeString() -- Line: 116
    -- upvalues: ReplicatedStorage (copy), RunService (copy)
    local GameStats = ReplicatedStorage:FindFirstChild("GameStats");

    if GameStats then
        GameStats = GameStats:GetAttribute("ServerRegion");
    end;

    return (not GameStats or GameStats == "") and (RunService:IsStudio() and "Server Region: local" or "Server Region") or "Server Region: " .. tostring(GameStats);
end;

local function CreateLabel(p50: userdata, p51: number) -- Line: 130
    -- upvalues: u16 (ref), Color3_fromRGB_ret (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Line" .. p51;
    TextLabel.LayoutOrder = p51;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(1, 0, 0, 14);
    TextLabel.Font = Enum.Font.RobotoMono;
    TextLabel.TextSize = u16 and 14 or 12;
    TextLabel.TextColor3 = Color3_fromRGB_ret;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.TextStrokeTransparency = 0.2;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.RichText = true;
    TextLabel.Parent = p50;

    return TextLabel;
end;

local function UpdateLayout() -- Line: 148
    -- upvalues: u9 (ref), u16 (ref), u11 (ref), u13 (ref), u14 (ref), u15 (ref)
    if not u9 then
        return;
    end;

    local v52 = u16 and 14 or 12;
    local v53 = v52 + 2;

    for _, v in ipairs(u11) do
        v.TextSize = v52;
        v.Size = UDim2.new(1, 0, 0, v53);
    end;

    if u13 == "Left" then
        u9.AnchorPoint = Vector2.new(0, 1);
        u9.Position = UDim2.new(0, u14 + 10, 1, -u15);

        for _, v in ipairs(u11) do
            v.TextXAlignment = Enum.TextXAlignment.Left;
        end;

        return;
    end;

    if u13 == "Center" then
        u9.AnchorPoint = Vector2.new(0.5, 1);
        u9.Position = UDim2.new(0.5, u14, 1, -u15);

        for _, v in ipairs(u11) do
            v.TextXAlignment = Enum.TextXAlignment.Center;
        end;

        return;
    end;

    u9.AnchorPoint = Vector2.new(1, 1);
    u9.Position = UDim2.new(1, -u14 - 10, 1, -u15);

    for _, v in ipairs(u11) do
        v.TextXAlignment = Enum.TextXAlignment.Right;
    end;
end;

local function BuildUI() -- Line: 182
    -- upvalues: u8 (ref), u12 (ref), u9 (ref), u10 (ref), u11 (ref), CreateLabel (copy), UpdateLayout (copy), LocalPlayer (copy)
    if u8 then
        u8:Destroy();
        u8 = nil;
    end;

    u8 = Instance.new("ScreenGui");
    u8.Name = "CSGO_NetGraph";
    u8.IgnoreGuiInset = true;
    u8.DisplayOrder = 9999;
    u8.ResetOnSpawn = false;
    u8.Enabled = u12 ~= "Off";
    u9 = Instance.new("Frame");
    u9.Name = "Container";
    u9.BackgroundTransparency = 1;
    u9.Size = UDim2.new(0, 540, 0, 0);
    u9.AutomaticSize = Enum.AutomaticSize.Y;
    u9.ClipsDescendants = false;
    u9.Parent = u8;
    u10 = Instance.new("Frame");
    u10.Name = "TextContainer";
    u10.BackgroundTransparency = 1;
    u10.Size = UDim2.new(1, 0, 1, 0);
    u10.AutomaticSize = Enum.AutomaticSize.Y;
    u10.Parent = u9;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Padding = UDim.new(0, 0);
    UIListLayout.Parent = u10;
    u11 = {};

    for i = 1, 6 do
        local v54 = CreateLabel(u10, i);
        table.insert(u11, v54);
        local _ = i;
    end;

    UpdateLayout();
    u8.Parent = LocalPlayer:WaitForChild("PlayerGui");
end;

local function Hex(p55) -- Line: 227
    local math_floor_ret = math.floor(p55.R * 255 + 0.5);
    local math_floor_ret2 = math.floor(p55.G * 255 + 0.5);
    local math_floor_ret3 = math.floor(p55.B * 255 + 0.5);

    return string.format("#%02X%02X%02X", math_floor_ret, math_floor_ret2, math_floor_ret3);
end;

local function Colored(p56, p57: string) -- Line: 234
    local string_format = string.format;
    local math_floor_ret = math.floor(p56.R * 255 + 0.5);
    local math_floor_ret2 = math.floor(p56.G * 255 + 0.5);
    local math_floor_ret3 = math.floor(p56.B * 255 + 0.5);

    return string_format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret, math_floor_ret2, math_floor_ret3), p57);
end;

local function UpdateNetGraphText() -- Line: 238
    -- upvalues: u8 (ref), u17 (ref), u10 (ref), u4 (ref), u23 (copy), u19 (ref), CalculateFrameVar (copy), u3 (ref), u7 (ref), u32 (ref), u29 (ref), u30 (ref), u31 (ref), u28 (ref), u33 (ref), u34 (ref), Color3_fromRGB_ret (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy), ReplicatedStorage (copy), RunService (copy), u18 (ref), Colored (copy), u12 (ref), u11 (ref), u24 (ref), u25 (ref)
    if not (u8 and (u8.Enabled and u17)) then
        if u10 then
            u10.Visible = false;
        end;

        return;
    end;

    u10.Visible = true;
    local v58 = u4 and (u4.Get and u4.Get("Game", "TickRate")) or (u23.TickRate or 64);
    local v59 = u19;
    local v60 = CalculateFrameVar();
    local v61 = u3 and (u3.GetLocalPing and u3.GetLocalPing()) or 0;
    local v62, v63, v64, v65, v66;

    if u7 and u7.GetInterpolationStats then
        local InterpolationStats, v67, v68, v69, _, _, v70 = u7.GetInterpolationStats();
        v62 = v67 or 0;
        v63 = InterpolationStats or 0;
        v64 = v68 or 0;
        v65 = v70 or 0;
        v66 = v69 or 0;
    else
        v62 = 0;
        v63 = 0;
        v64 = 0;
        v65 = 0;
        v66 = 0;
    end;

    local v71 = u3 and (u3.GetNetworkDebugStats and u3.GetNetworkDebugStats()) or {};
    local os_clock_ret2 = os.clock();

    if u32 then
        if os_clock_ret2 - u28 >= 0.5 then
            local math_max_ret = math.max(0, v65 - u29);
            local math_max_ret2 = math.max(0, v66 - u30);
            u29 = v65;
            u30 = v66;
            local v72 = v58 * (os_clock_ret2 - u28);
            local v73 = v71.LostCommandPercent or 0;
            local v74 = v71.FakeCommandCount or 0;
            local math_max_ret3 = math.max(0, v74 - u31);
            u31 = v74;
            local math_max_ret4 = math.max(math_max_ret > 0 and v72 > 0 and (math_max_ret / (v72 + math_max_ret) * 100 or 0) or 0, v73);
            local math_round_ret = math.round(math_max_ret4);
            u33 = math.clamp(math_round_ret, 0, 100);
            local math_max_ret5 = math.max(math_max_ret2 > 0 and v72 > 0 and (math_max_ret2 / v72 * 100 or 0) or 0, math_max_ret3 > 0 and (v72 > 0 and math_max_ret3 / v72 * 100) or 0, (v59 <= 0 or v59 >= v58 * 0.85) and 0 or (1 - v59 / v58) * 100);
            local math_round_ret2 = math.round(math_max_ret5);
            u34 = math.clamp(math_round_ret2, 0, 100);
            u28 = os_clock_ret2;
        end;
    else
        u32 = true;
        u29 = v65;
        u30 = v66;
        u31 = v71.FakeCommandCount or 0;
        u28 = os_clock_ret2;
    end;

    local v75 = u33;
    local v76 = u34;
    local v77 = Color3_fromRGB_ret;

    if v61 > 150 then
        v77 = Color3_fromRGB_ret4;
    elseif v61 > 90 then
        v77 = Color3_fromRGB_ret3;
    elseif v61 > 60 then
        v77 = Color3_fromRGB_ret2;
    end;

    local v78 = v75 > 5 and Color3_fromRGB_ret4 or (v75 > 0 and Color3_fromRGB_ret3 or Color3_fromRGB_ret);
    local v79 = v76 > 5 and Color3_fromRGB_ret4 or (v76 > 0 and Color3_fromRGB_ret3 or Color3_fromRGB_ret);
    local v80 = Color3_fromRGB_ret;
    local v81 = Color3_fromRGB_ret;
    local FrameTimeMs = u23.FrameTimeMs;
    local FrameStdDevMs = u23.FrameStdDevMs;
    local TickVarMs = u23.TickVarMs;
    local v82 = Color3_fromRGB_ret;

    if 1000 / v58 * 0.9 < FrameTimeMs then
        local v83 = 1000 / v58;

        if v83 <= 0 then
            v82 = Color3_fromRGB_ret;
        else
            local v84 = math.abs(v83 - FrameTimeMs) / v83;

            if v84 > 0.75 then
                v82 = Color3_fromRGB_ret4;
            elseif v84 > 0.5 then
                v82 = Color3_fromRGB_ret3;
            elseif v84 > 0.25 then
                v82 = Color3_fromRGB_ret2;
            else
                v82 = Color3_fromRGB_ret;
            end;
        end;
    end;

    local GameStats = ReplicatedStorage:FindFirstChild("GameStats");

    if GameStats then
        GameStats = GameStats:GetAttribute("ServerRegion");
    end;

    local v85;

    if GameStats and GameStats ~= "" then
        v85 = "Server Region: " .. tostring(GameStats);
    else
        v85 = RunService:IsStudio() and "Server Region: local" or "Server Region";
    end;

    local v86 = 2 / v58 * 1000;
    local v87 = Color3_fromRGB_ret;

    if v63 > 0 then
        v86 = v63 * 1000;

        if v63 < 1 / v58 then
            v87 = Color3_fromRGB_ret4;
        elseif v64 < 0 then
            v87 = Color3_fromRGB_ret3;
        elseif v62 > 0.015 then
            v87 = Color3_fromRGB_ret2;
        end;
    end;

    local math_floor_ret = math.floor(v61 + 0.5);
    local v88;

    if u18 then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        local v89 = workspace_CurrentCamera and workspace_CurrentCamera.CFrame or CFrame.identity;
        local Position = v89.Position;
        local v90, v91 = v89:ToEulerAnglesYXZ();
        local math_deg_ret = math.deg(v91);
        local math_deg_ret2 = math.deg(v90);
        local string_format_ret = string.format("pos: %6.1f %6.1f %6.1f", Position.X, Position.Y, Position.Z);
        local string_format_ret2 = string.format("pos: %s", Colored(Color3_fromRGB_ret, string.format("%6.1f %6.1f %6.1f", Position.X, Position.Y, Position.Z)));
        local string_format = string.format;
        local v92 = Color3_fromRGB_ret;
        local string_format_ret3 = string.format("%5.1f", math_deg_ret);
        local string_format2 = string.format;
        local math_floor_ret2 = math.floor(v92.R * 255 + 0.5);
        local math_floor_ret3 = math.floor(v92.G * 255 + 0.5);
        local math_floor_ret4 = math.floor(v92.B * 255 + 0.5);
        local v93 = string_format("yaw: %s   pitch: %s", string_format2("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret2, math_floor_ret3, math_floor_ret4), string_format_ret3), Colored(Color3_fromRGB_ret, string.format("%5.1f", math_deg_ret2)));
        v88 = string_format_ret2 .. string.rep(" ", (math.max(2, 30 - #string_format_ret))) .. v93;
    else
        v88 = nil;
    end;

    if u12 == "1: Text" then
        local string_format_ret = string.format("fps: %4d   var: %4.1f ms   ping: %d ms", v59, v60, math_floor_ret);
        local string_format_ret2 = string.format("fps: %4d   var: %4.1f ms   ping: %s", v59, v60, Colored(v77, string.format("%d ms", math_floor_ret)));
        local string_format_ret3 = string.format("up: %4.1f/s", v58);
        local string_format = string.format;
        local math_floor_ret2 = math.floor(v80.R * 255 + 0.5);
        local math_floor_ret3 = math.floor(v80.G * 255 + 0.5);
        local math_floor_ret4 = math.floor(v80.B * 255 + 0.5);
        local v94 = string_format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret2, math_floor_ret3, math_floor_ret4), string_format_ret3);
        u11[1].Text = string_format_ret2 .. string.rep(" ", (math.max(2, 42 - #string_format_ret))) .. v94;
        u11[1].Visible = true;
        local string_format_ret4 = string.format("loss: %2d%%   choke: %2d%%", v75, v76);
        local string_format2 = string.format;
        local string_format_ret5 = string.format("%2d%%", v75);
        local string_format3 = string.format;
        local math_floor_ret5 = math.floor(v78.R * 255 + 0.5);
        local math_floor_ret6 = math.floor(v78.G * 255 + 0.5);
        local math_floor_ret7 = math.floor(v78.B * 255 + 0.5);
        local v95 = string_format2("loss: %s   choke: %s", string_format3("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret5, math_floor_ret6, math_floor_ret7), string_format_ret5), Colored(v79, string.format("%2d%%", v76)));
        local string_format4 = string.format;
        local string_format_ret6 = string.format("cmd: %4.1f/s", v58);
        local string_format5 = string.format;
        local math_floor_ret8 = math.floor(v81.R * 255 + 0.5);
        local math_floor_ret9 = math.floor(v81.G * 255 + 0.5);
        local math_floor_ret10 = math.floor(v81.B * 255 + 0.5);
        local v96 = string_format4("%s   %s", string_format5("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret8, math_floor_ret9, math_floor_ret10), string_format_ret6), Colored(Color3_fromRGB_ret, v85));
        u11[2].Text = v95 .. string.rep(" ", (math.max(2, 30 - #string_format_ret4))) .. v96;
        u11[2].Visible = true;
        local string_format_ret7 = string.format("tick: %4.1f   ", v58);
        local string_format_ret8 = string.format("sv: %4.1f +- %3.1f ms   var: %5.3f ms", FrameTimeMs, FrameStdDevMs, TickVarMs);
        local string_format6 = string.format;
        local math_floor_ret11 = math.floor(v82.R * 255 + 0.5);
        local math_floor_ret12 = math.floor(v82.G * 255 + 0.5);
        local math_floor_ret13 = math.floor(v82.B * 255 + 0.5);
        local v97 = string_format6("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret11, math_floor_ret12, math_floor_ret13), string_format_ret8);
        u11[3].Text = string_format_ret7 .. v97;
        u11[3].Visible = true;

        if u18 and v88 then
            u11[4].Text = v88;
            u11[4].Visible = true;
        else
            u11[4].Visible = false;
        end;

        u11[5].Visible = false;
        u11[6].Visible = false;

        return;
    end;

    local string_format_ret = string.format("fps: %4d   var: %4.1f ms   ping: %d ms", v59, v60, math_floor_ret);
    local string_format_ret2 = string.format("fps: %4d   var: %4.1f ms   ping: %s", v59, v60, Colored(v77, string.format("%d ms", math_floor_ret)));
    local string_format_ret3 = string.format("up: %4.1f/s", v58);
    local string_format = string.format;
    local math_floor_ret2 = math.floor(v80.R * 255 + 0.5);
    local math_floor_ret3 = math.floor(v80.G * 255 + 0.5);
    local math_floor_ret4 = math.floor(v80.B * 255 + 0.5);
    local v98 = string_format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret2, math_floor_ret3, math_floor_ret4), string_format_ret3);
    u11[1].Text = string_format_ret2 .. string.rep(" ", (math.max(2, 42 - #string_format_ret))) .. v98;
    u11[1].Visible = true;
    local v99 = u24 * 1024 / math.max(v58, 1) + 0.5;
    local math_floor_ret5 = math.floor(v99);
    local string_format_ret4 = string.format("%5.2fk/s", u24);
    local string_format_ret5 = string.format("in:  %4d   %s   lerp: %4.1f ms", math_floor_ret5, string_format_ret4, v86);
    local string_format_ret6 = string.format("in:  %4d   %s   %s", math_floor_ret5, string_format_ret4, Colored(v87, string.format("lerp: %4.1f ms", v86)));
    local string_format_ret7 = string.format("%4.1f/s", v58);
    u11[2].Text = string_format_ret6 .. string.rep(" ", (math.max(2, 42 - #string_format_ret5))) .. string_format_ret7;
    u11[2].Visible = true;
    local v100 = u25 * 1024 / math.max(v58, 1) + 0.5;
    local math_floor_ret6 = math.floor(v100);
    local string_format_ret8 = string.format("%5.2fk/s", u25);
    local string_format_ret9 = string.format("out: %4d   %s", math_floor_ret6, string_format_ret8);
    local string_format_ret10 = string.format("out: %4d   %s", math_floor_ret6, string_format_ret8);
    local string_format_ret11 = string.format("%4.1f/s", v58);
    u11[3].Text = string_format_ret10 .. string.rep(" ", (math.max(2, 42 - #string_format_ret9))) .. string_format_ret11;
    u11[3].Visible = true;
    local string_format_ret12 = string.format("loss: %2d%%   choke: %2d%%", v75, v76);
    local string_format2 = string.format;
    local string_format_ret13 = string.format("%2d%%", v75);
    local string_format3 = string.format;
    local math_floor_ret7 = math.floor(v78.R * 255 + 0.5);
    local math_floor_ret8 = math.floor(v78.G * 255 + 0.5);
    local math_floor_ret9 = math.floor(v78.B * 255 + 0.5);
    local v101 = string_format2("loss: %s   choke: %s", string_format3("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret7, math_floor_ret8, math_floor_ret9), string_format_ret13), Colored(v79, string.format("%2d%%", v76)));
    local string_format4 = string.format;
    local string_format_ret14 = string.format("cmd: %4.1f/s", v58);
    local string_format5 = string.format;
    local math_floor_ret10 = math.floor(v81.R * 255 + 0.5);
    local math_floor_ret11 = math.floor(v81.G * 255 + 0.5);
    local math_floor_ret12 = math.floor(v81.B * 255 + 0.5);
    local v102 = string_format4("%s   %s", string_format5("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret10, math_floor_ret11, math_floor_ret12), string_format_ret14), Colored(Color3_fromRGB_ret, v85));
    u11[4].Text = v101 .. string.rep(" ", (math.max(2, 30 - #string_format_ret12))) .. v102;
    u11[4].Visible = true;
    local string_format_ret15 = string.format("tick: %4.1f   ", v58);
    local string_format_ret16 = string.format("sv: %4.1f +- %3.1f ms   var: %5.3f ms", FrameTimeMs, FrameStdDevMs, TickVarMs);
    local string_format6 = string.format;
    local math_floor_ret13 = math.floor(v82.R * 255 + 0.5);
    local math_floor_ret14 = math.floor(v82.G * 255 + 0.5);
    local math_floor_ret15 = math.floor(v82.B * 255 + 0.5);
    local v103 = string_format6("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math_floor_ret13, math_floor_ret14, math_floor_ret15), string_format_ret16);
    u11[5].Text = string_format_ret15 .. v103;
    u11[5].Visible = true;

    if not (u18 and v88) then
        u11[6].Visible = false;

        return;
    end;

    u11[6].Text = v88;
    u11[6].Visible = true;
end;

local function OnRenderStep(p104: number) -- Line: 457
    -- upvalues: u20 (ref), u21 (copy), u19 (ref), table_create_ret (copy), u22 (ref), os_clock_ret (ref), u24 (ref), Stats (copy), u25 (ref), u27 (ref), UpdateNetGraphText (copy)
    u20 = u20 + p104;

    if u20 > 0.01 then
        local math_ceil_ret = math.ceil(1 / p104);
        table.insert(u21, math_ceil_ret);

        if #u21 > 40 then
            local v105 = 0;

            for _, v in u21 do
                v105 = v105 + v;
            end;

            u19 = math.ceil(v105 / #u21);
            table.clear(u21);
        elseif u19 == 0 then
            u19 = math_ceil_ret;
        end;

        u20 = 0;
    end;

    table_create_ret[u22] = p104;
    u22 = u22 % 30 + 1;
    local os_clock_ret2 = os.clock();

    if os_clock_ret2 - os_clock_ret >= 0.25 then
        u24 = Stats.DataReceiveKbps;
        u25 = Stats.DataSendKbps;
        os_clock_ret = os_clock_ret2;
    end;

    u27 = u27 + p104;

    if u27 >= 0.05 then
        u27 = 0;
        UpdateNetGraphText();
    end;
end;

function u1.SetMode(p106) -- Line: 500
    -- upvalues: u12 (ref), u8 (ref), u3 (ref), u26 (ref), RunService (copy), OnRenderStep (copy), UpdateNetGraphText (copy)
    local v107 = type(p106) == "number" and (p106 == 1 and "1: Text" or (p106 == 2 and "2: Detailed Text" or "Off")) or p106;
    u12 = tostring(v107 or "Off");

    if u12 ~= "1: Text" and u12 ~= "2: Detailed Text" then
        u12 = "Off";
    end;

    if u8 then
        u8.Enabled = u12 ~= "Off";
    end;

    if u12 == "Off" then
        if u26 then
            u26:Disconnect();
            u26 = nil;
        end;
    else
        if u3 and u3.SetNetworkDebugEnabled then
            u3.SetNetworkDebugEnabled(true);
        end;

        if not u26 then
            u26 = RunService.PreRender:Connect(OnRenderStep);
        end;
    end;

    UpdateNetGraphText();
end;

function u1.SetAlignment(p108) -- Line: 537
    -- upvalues: u13 (ref), UpdateLayout (copy)
    local v109 = type(p108) == "number" and (p108 == 1 and "Right" or (p108 == 2 and "Center" or (p108 == 3 and "Left" or "Right"))) or p108;
    u13 = tostring(v109 or "Right");
    UpdateLayout();
end;

function u1.SetPositionX(p110: number) -- Line: 545
    -- upvalues: u14 (ref), UpdateLayout (copy)
    u14 = tonumber(p110) or 0;
    UpdateLayout();
end;

function u1.SetPositionY(p111: number) -- Line: 550
    -- upvalues: u15 (ref), UpdateLayout (copy)
    u15 = tonumber(p111) or 64;
    UpdateLayout();
end;

function u1.SetProportionalFont(p112: boolean) -- Line: 555
    -- upvalues: u16 (ref), UpdateLayout (copy)
    u16 = p112 and true or false;
    UpdateLayout();
end;

function u1.SetTextEnabled(p113: boolean) -- Line: 560
    -- upvalues: u17 (ref), UpdateNetGraphText (copy)
    u17 = p113 and true or false;
    UpdateNetGraphText();
end;

function u1.SetShowCameraInfo(p114: boolean) -- Line: 565
    -- upvalues: u18 (ref), UpdateNetGraphText (copy)
    u18 = p114 and true or false;
    UpdateNetGraphText();
end;

function u1.Init(p115) -- Line: 572
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u7 (ref), BuildUI (copy), u23 (copy)
    u2 = p115:GetModule("Gui");
    u3 = p115:GetModule("ClientModule");
    u4 = p115:GetModule("GameConfiguration");
    u5 = p115:GetModule("Network");
    u7 = p115:GetModule("Entities");
    BuildUI();

    if u5 and u5.ServerPerformanceStats then
        u5.ServerPerformanceStats.On(function(p116) -- Line: 583
            -- upvalues: u23 (ref)
            if p116 then
                u23.FrameTimeMs = p116.ServerFrameTimeMs or u23.FrameTimeMs;
                u23.FrameStdDevMs = p116.ServerFrameStdDevMs or u23.FrameStdDevMs;
                u23.TickVarMs = p116.ServerTickVarMs or u23.TickVarMs;
                u23.TickRate = p116.TickRate or u23.TickRate;
            end;
        end);
    end;
end;

function u1.Start(p117) -- Line: 594
    -- upvalues: u6 (ref), u2 (ref), u1 (copy)
    u6 = u2.GetComponent("Settings");

    if u6 then
        u6:AddConnection("Game", "HUD & UI", "Net Graph", u1.SetMode);
        u6:AddConnection("Game", "HUD & UI", "Net Graph Alignment", u1.SetAlignment);
        u6:AddConnection("Game", "HUD & UI", "Net Graph Position X", u1.SetPositionX);
        u6:AddConnection("Game", "HUD & UI", "Net Graph Position Y", u1.SetPositionY);
        u6:AddConnection("Game", "HUD & UI", "Net Graph Proportional Font", u1.SetProportionalFont);
        u6:AddConnection("Game", "HUD & UI", "Net Graph Text", u1.SetTextEnabled);
        u6:AddConnection("Game", "HUD & UI", "Net Graph Show Camera Info", u1.SetShowCameraInfo);
        local v118 = u6:GetPlayerSettings() or {};
        local v119 = v118.Game and v118.Game["HUD & UI"];

        if v119 then
            u1.SetAlignment(v119["Net Graph Alignment"] or "Right");
            u1.SetPositionX(v119["Net Graph Position X"] or 0);
            u1.SetPositionY(v119["Net Graph Position Y"] or 64);
            u1.SetProportionalFont(v119["Net Graph Proportional Font"] or false);
            u1.SetTextEnabled(v119["Net Graph Text"] ~= false);
            u1.SetShowCameraInfo(v119["Net Graph Show Camera Info"] ~= false);
            u1.SetMode(v119["Net Graph"] or "Off");
        end;
    end;
end;

return u1;