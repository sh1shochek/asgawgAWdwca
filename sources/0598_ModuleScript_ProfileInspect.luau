-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetRankTitle = require(ReplicatedStorage.Components.Common.GetRankTitle);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
require(ReplicatedStorage.Database.Custom.Types);
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local Settings = require(ReplicatedStorage.Interface.Screens.Menu.Settings);
local Report = require(script.Parent.Parent.Report);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    ["Show Player Crosshairs"] = true,
    ["Show my crosshair when spectating bots"] = true
};
local u3 = nil;
local u4 = nil;
local u5 = {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;

local function getBadgeIconFromItem(p12) -- Line: 39
    -- upvalues: Skins (copy)
    if typeof(p12) ~= "table" or p12.Name ~= "Badge" then
        return "";
    end;

    local SkinInformation = Skins.GetSkinInformation(p12.Name, p12.Skin);

    return SkinInformation and (Skins.GetWearImageForFloat(SkinInformation, p12.Float or 0.9999) or SkinInformation.imageAssetId or "") or "";
end;

local function collectPinLabels(p13: userdata) -- Line: 52
    local v14 = {};

    for _, child in p13:GetChildren() do
        if child:IsA("ImageLabel") and child.Name == "Pin" then
            table.insert(v14, child);
        end;
    end;

    table.sort(v14, function(p15: userdata, p16: userdata) -- Line: 60
        return p15.LayoutOrder < p16.LayoutOrder;
    end);

    return v14;
end;

local function getEquippedBadgeId(p17, p18) -- Line: 67
    if typeof(p18) ~= "table" or not p17 then
        return nil;
    end;

    local v19 = p18[p17];

    if typeof(v19) ~= "table" or typeof(v19.Equipped) ~= "table" then
        return nil;
    end;

    local v20 = v19.Equipped["Equipped Badge"];

    if typeof(v20) == "string" and v20 ~= "" then
        return v20;
    end;

    return nil;
end;

local function populatePins(p21: userdata) -- Line: 81
    -- upvalues: DataController (copy), Skins (copy), u5 (ref)
    local Attribute = p21:GetAttribute("Team");
    local v22, v23 = DataController.Get(p21, "Loadout", "Inventory");
    local v24;

    if typeof(v22) == "table" and Attribute then
        local v25 = v22[Attribute];

        if typeof(v25) == "table" and typeof(v25.Equipped) == "table" then
            v24 = v25.Equipped["Equipped Badge"];

            if typeof(v24) ~= "string" or v24 == "" then
                v24 = nil;
            end;
        else
            v24 = nil;
        end;
    else
        v24 = nil;
    end;

    local v26 = nil;

    if v24 and typeof(v23) == "table" then
        for _, v in ipairs(v23) do
            if typeof(v) == "table" and (v._id == v24 and (v.Name == "Badge" and typeof(v.Skin) == "string")) then
                v26 = v.Skin;
                break;
            end;
        end;
    end;

    local v27 = nil;
    local v28 = {};
    local v29 = {};

    if typeof(v23) == "table" then
        for _, v in ipairs(v23) do
            if typeof(v) == "table" and (v.Name == "Badge" and (typeof(v.Skin) == "string" and (v.Skin ~= "" and not v29[v.Skin]))) then
                local v30;

                if typeof(v) == "table" and v.Name == "Badge" then
                    local SkinInformation = Skins.GetSkinInformation(v.Name, v.Skin);
                    v30 = SkinInformation and (Skins.GetWearImageForFloat(SkinInformation, v.Float or 0.9999) or (SkinInformation.imageAssetId or "")) or "";
                else
                    v30 = "";
                end;

                if v30 ~= "" then
                    v29[v.Skin] = true;

                    if v26 and v.Skin == v26 then
                        v27 = v30;
                    else
                        table.insert(v28, v30);
                    end;
                end;
            end;
        end;
    end;

    for i, v in ipairs(u5) do
        local v31;

        if i == 1 then
            v31 = v27;
        else
            v31 = v28[i - 1];
        end;

        if v31 then
            v.Image = v31;
            v.Visible = true;
        else
            v.Visible = false;
        end;
    end;
end;

local function populateLevel(p32: userdata) -- Line: 137
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), DataController (copy), GetRankTitle (copy), LevelsIcon (copy)
    if not (u6 and (u7 and u8)) then
        return;
    end;

    local v33 = DataController.Get(p32, "Level");
    local v34, v35, v36;

    if typeof(v33) == "table" then
        v34 = v33.Level or 1;
        v35 = v33.Experience or 0;
        v36 = v33.NextExperienceRequirement or 1000;
    else
        v34 = 1;
        v36 = 1000;
        v35 = 0;
    end;

    u6.Text = `[{GetRankTitle(v34)} Rank {v34}]`;
    u7.Image = LevelsIcon[tostring(v34)] or "";
    local v37 = v35 / math.max(v36, 1);
    local math_clamp_ret = math.clamp(v37, 0, 1);
    local Y = u8.Size.Y;
    u8.Size = UDim2.new(math_clamp_ret, 0, Y.Scale, Y.Offset);
end;

local function updateActionButtons(p38: userdata?) -- Line: 161
    -- upvalues: Participants (copy), u9 (ref), LocalPlayer (copy), u10 (ref)
    local v39 = Participants.IsBot(p38);

    if u9 then
        local v40;

        if p38 == nil or p38 == LocalPlayer then
            v40 = false;
        else
            v40 = not v39;
        end;

        u9.Active = v40;
    end;

    if u10 then
        u10.Visible = not v39;
        local v41;

        if p38 == nil then
            v41 = false;
        else
            v41 = not v39;
        end;

        u10.Active = v41;
    end;
end;

local function copyPlayerCrosshair(p42: userdata) -- Line: 174
    -- upvalues: LocalPlayer (copy), Participants (copy), DataController (copy), u2 (copy), Settings (copy)
    if p42 == LocalPlayer or Participants.IsBot(p42) then
        return;
    end;

    local v43 = DataController.Get(p42, "Settings.Game.Crosshair");

    if typeof(v43) ~= "table" then
        return;
    end;

    for i, v in pairs(v43) do
        if not u2[i] then
            Settings.SettingChanged("Game", i, v);
        end;
    end;
end;

function v1.Bind(p44: userdata) -- Line: 191
    -- upvalues: u3 (ref), u4 (ref), u6 (ref), u7 (ref), u8 (ref), u5 (ref), collectPinLabels (copy), u9 (ref), ActivateButton (copy), u11 (ref), copyPlayerCrosshair (copy), u10 (ref), LocalPlayer (copy), Participants (copy), Report (copy)
    local Info = p44:FindFirstChild("Info");
    local v45;

    if Info then
        v45 = Info:FindFirstChild("Player");
    else
        v45 = Info;
    end;

    local v46;

    if Info then
        v46 = Info:FindFirstChild("Pins");
    else
        v46 = Info;
    end;

    local v47;

    if Info then
        v47 = Info:FindFirstChild("Level");
    else
        v47 = Info;
    end;

    local v48;

    if v47 then
        v48 = v47:FindFirstChild("LevelBar");
    else
        v48 = v47;
    end;

    if v45 then
        v45 = v45:FindFirstChild("Avatar");
    end;

    u3 = v45;

    if Info then
        Info = Info:FindFirstChild("Username");
    end;

    u4 = Info;
    local v49;

    if v47 then
        v49 = v47:FindFirstChild("TextLabel");
    else
        v49 = v47;
    end;

    u6 = v49;

    if v47 then
        v47 = v47:FindFirstChild("Rank");
    end;

    u7 = v47;

    if v48 then
        v48 = v48:FindFirstChild("Current");
    end;

    u8 = v48;
    u5 = not (v46 and v46:IsA("Frame")) and {} or collectPinLabels(v46);
    local CopyCrosshair = p44:FindFirstChild("CopyCrosshair");

    if CopyCrosshair and CopyCrosshair:IsA("ImageButton") then
        u9 = CopyCrosshair;
        ActivateButton(CopyCrosshair);
        CopyCrosshair.MouseButton1Click:Connect(function() -- Line: 210
            -- upvalues: u11 (ref), copyPlayerCrosshair (ref)
            if u11 then
                copyPlayerCrosshair(u11);
            end;
        end);
    end;

    local Report2 = p44:FindFirstChild("Report");

    if Report2 and Report2:IsA("ImageButton") then
        u10 = Report2;
        ActivateButton(Report2);
        Report2.MouseButton1Click:Connect(function() -- Line: 221
            -- upvalues: u11 (ref), LocalPlayer (ref), Participants (ref), Report (ref)
            if u11 and (u11 ~= LocalPlayer and not Participants.IsBot(u11)) then
                Report.Open(u11);
            end;
        end);
    end;
end;

local function clearAccountDetails() -- Line: 229
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    for _, v in u5 do
        v.Visible = false;
    end;

    if u6 then
        u6.Text = "";
    end;

    if u7 then
        u7.Image = "";
    end;

    if u8 then
        local Y = u8.Size.Y;
        u8.Size = UDim2.new(0, 0, Y.Scale, Y.Offset);
    end;
end;

function v1.Populate(p50: userdata) -- Line: 248
    -- upvalues: u11 (ref), Participants (copy), u9 (ref), LocalPlayer (copy), u10 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), populatePins (copy), populateLevel (copy)
    u11 = p50;
    local v51 = Participants.IsBot(p50);

    if u9 then
        local v52;

        if p50 == nil or p50 == LocalPlayer then
            v52 = false;
        else
            v52 = not v51;
        end;

        u9.Active = v52;
    end;

    if u10 then
        u10.Visible = not v51;
        local v53;

        if p50 == nil then
            v53 = false;
        else
            v53 = not v51;
        end;

        u10.Active = v53;
    end;

    if u3 then
        u3.Image = Participants.HeadshotImage(p50);
    end;

    if u4 then
        u4.Text = Participants.Name(p50);
    end;

    if not Participants.IsBot(p50) then
        populatePins(p50);
        populateLevel(p50);

        return;
    end;

    for _, v in u5 do
        v.Visible = false;
    end;

    if u6 then
        u6.Text = "";
    end;

    if u7 then
        u7.Image = "";
    end;

    if u8 then
        local Y = u8.Size.Y;
        u8.Size = UDim2.new(0, 0, Y.Scale, Y.Offset);
    end;

    if u6 then
        u6.Text = "[Bot]";
    end;
end;

function v1.Reset() -- Line: 272
    -- upvalues: u11 (ref), Participants (copy), u9 (ref), u10 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u3 (ref), u4 (ref)
    u11 = nil;
    local v54 = Participants.IsBot(nil);

    if u9 then
        u9.Active = false;
    end;

    if u10 then
        u10.Visible = not v54;
        u10.Active = false;
    end;

    for _, v in u5 do
        v.Visible = false;
    end;

    if u6 then
        u6.Text = "";
    end;

    if u7 then
        u7.Image = "";
    end;

    if u8 then
        local Y = u8.Size.Y;
        u8.Size = UDim2.new(0, 0, Y.Scale, Y.Offset);
    end;

    if u3 then
        u3.Image = "";
    end;

    if u4 then
        u4.Text = "";
    end;
end;

return v1;