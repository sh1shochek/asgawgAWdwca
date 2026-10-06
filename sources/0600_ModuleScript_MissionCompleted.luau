-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ConfigController = require(ReplicatedStorage.Controllers.ConfigController);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Missions = require(ReplicatedStorage.Database.Custom.GameStats.Missions);
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys);
require(ReplicatedStorage.Database.Custom.Types);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local UDim2_fromScale_ret = UDim2.fromScale(0.5, -1.5);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.1, 1);
local UDim2_fromScale_ret3 = UDim2.fromScale(0.5, -0.25);
local UDim2_fromScale_ret4 = UDim2.fromScale(8, 1);
local u1 = {
    hourly = Color3.fromRGB(208, 182, 68),
    daily = Color3.fromRGB(21, 208, 11),
    weekly = Color3.fromRGB(76, 154, 255),
    monthly = Color3.fromRGB(160, 68, 191)
};
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);
local u2 = {
    hourly = "HOURLY MISSION",
    daily = "DAILY MISSION",
    weekly = "WEEKLY MISSION",
    monthly = "MONTHLY MISSION"
};
local v3 = {};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = {};
local u13 = false;
local u14 = {};
local u15 = false;
local u16 = nil;
local u17 = nil;

local function CommaNumber(p18: number) -- Line: 96
    return tostring(p18):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function ColorToHex(p19) -- Line: 100
    return string.format("#%02X%02X%02X", math.round(p19.R * 255), math.round(p19.G * 255), (math.round(p19.B * 255)));
end;

local function GetMissionKey(p20) -- Line: 109
    return `{p20.MissionId}:{p20.CreatedAt}`;
end;

local function GetCreditRewardAmount(p21: any, p22: number) -- Line: 113
    -- upvalues: ConfigKeys (copy), ConfigController (copy)
    local v23 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p21];
    local v24 = not v23 and 1 or ConfigController.GetRewardMultiplier(v23);

    return math.round(p22 * v24);
end;

local function CancelActiveTweens() -- Line: 119
    -- upvalues: u11 (copy)
    for _, v in u11 do
        v:Cancel();
    end;

    table.clear(u11);
end;

local function PlayTween(p25: userdata, p26: userdata, p27: table) -- Line: 126
    -- upvalues: TweenService (copy), u11 (copy)
    local v28 = TweenService:Create(p25, p26, p27);
    table.insert(u11, v28);
    v28:Play();

    return v28;
end;

local function SetTextLabelTransparent(p29: userdata, p30: boolean) -- Line: 133
    local v31 = p30 and 1 or 0;
    p29.TextTransparency = v31;
    p29.TextStrokeTransparency = v31;
end;

local function SetImageLabelTransparent(p32: userdata, p33: boolean) -- Line: 139
    p32.ImageTransparency = p33 and 1 or 0;
end;

local function SetContentTransparent(p34: boolean) -- Line: 143
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    if u6 then
        local v35 = u6;
        local v36 = p34 and 1 or 0;
        v35.TextTransparency = v36;
        v35.TextStrokeTransparency = v36;
    end;

    if u7 then
        local v37 = u7;
        local v38 = p34 and 1 or 0;
        v37.TextTransparency = v38;
        v37.TextStrokeTransparency = v38;
    end;

    if u8 then
        u8.ImageTransparency = p34 and 1 or 0;
    end;

    if u9 then
        u9.ImageTransparency = p34 and 1 or 0;
    end;
end;

local function ResetFramePresentation() -- Line: 158
    -- upvalues: u11 (copy), u5 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    for _, v in u11 do
        v:Cancel();
    end;

    table.clear(u11);

    if u5 then
        u5.Position = UDim2_fromScale_ret;
        u5.Size = UDim2_fromScale_ret2;
    end;

    if u6 then
        local v39 = u6;
        v39.TextTransparency = 1;
        v39.TextStrokeTransparency = 1;
    end;

    if u7 then
        local v40 = u7;
        v40.TextTransparency = 1;
        v40.TextStrokeTransparency = 1;
    end;

    if u8 then
        u8.ImageTransparency = 1;
    end;

    if u9 then
        u9.ImageTransparency = 1;
    end;
end;

local function HidePopup() -- Line: 169
    -- upvalues: u4 (ref), u11 (copy), u5 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    if u4 then
        u4.Visible = false;

        for _, v in u11 do
            v:Cancel();
        end;

        table.clear(u11);

        if u5 then
            u5.Position = UDim2_fromScale_ret;
            u5.Size = UDim2_fromScale_ret2;
        end;

        if u6 then
            local v41 = u6;
            v41.TextTransparency = 1;
            v41.TextStrokeTransparency = 1;
        end;

        if u7 then
            local v42 = u7;
            v42.TextTransparency = 1;
            v42.TextStrokeTransparency = 1;
        end;

        if u8 then
            u8.ImageTransparency = 1;
        end;

        if u9 then
            u9.ImageTransparency = 1;
        end;
    end;
end;

local function ApplyHUDColor() -- Line: 176
    -- upvalues: u5 (ref), GetPreferenceColor (copy)
    if u5 then
        u5.BackgroundColor3 = GetPreferenceColor();
    end;
end;

local function IsMissionsNotificationsEnabled() -- Line: 182
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return DataController.Get(LocalPlayer, "Settings.Game.HUD.Enable Missions Notifications") ~= false;
end;

local function ShowEntry(p43: table, u44: function) -- Line: 186
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u11 (copy), Color3_fromRGB_ret (copy), u10 (ref), u9 (ref), GetPreferenceColor (copy), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), Router (copy), UDim2_fromScale_ret3 (copy), TweenService (copy), u17 (ref), UDim2_fromScale_ret4 (copy)
    if not (u4 and (u5 and (u6 and (u7 and u8)))) then
        return;
    end;

    for _, v in u11 do
        v:Cancel();
    end;

    table.clear(u11);
    u6.RichText = true;
    u6.TextColor3 = Color3_fromRGB_ret;
    u6.Text = `<font color="{p43.colorHex}">{p43.typeLabel}</font> COMPLETED`;
    u7.Text = p43.objective;

    if p43.creditAmount then
        u8.Image = "rbxassetid://129921992230064";

        if u10 then
            u10.Text = `x{tostring(p43.creditAmount):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        end;
    end;

    u8.Visible = p43.creditAmount ~= nil;

    if u9 then
        u9.Visible = p43.creditAmount ~= nil;
    end;

    if u5 then
        u5.BackgroundColor3 = GetPreferenceColor();
    end;

    u5.Position = UDim2_fromScale_ret;
    u5.Size = UDim2_fromScale_ret2;

    if u6 then
        local v45 = u6;
        v45.TextTransparency = 1;
        v45.TextStrokeTransparency = 1;
    end;

    if u7 then
        local v46 = u7;
        v46.TextTransparency = 1;
        v46.TextStrokeTransparency = 1;
    end;

    if u8 then
        u8.ImageTransparency = 1;
    end;

    if u9 then
        u9.ImageTransparency = 1;
    end;

    u4.Visible = true;
    Router.broadcastRouter("RunInterfaceSound", "Mission Completed");
    local v47 = TweenService:Create(u5, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
        Position = UDim2_fromScale_ret3
    });
    table.insert(u11, v47);
    v47:Play();
    v47.Completed:Once(function(p48) -- Line: 223
        -- upvalues: u17 (ref), u4 (ref), u5 (ref), UDim2_fromScale_ret4 (ref), TweenService (ref), u11 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u44 (copy)
        if p48 == Enum.PlaybackState.Completed then
            task.delay(0.1, function() -- Line: 229
                -- upvalues: u4 (ref), u5 (ref), u17 (ref), UDim2_fromScale_ret4 (ref), TweenService (ref), u11 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u44 (ref)
                if not (u4 and (u4.Visible and u5)) then
                    u17();

                    return;
                end;

                local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Linear);
                local v49 = TweenService:Create(u5, TweenInfo_new_ret, {
                    Size = UDim2_fromScale_ret4
                });
                table.insert(u11, v49);
                v49:Play();

                if u6 then
                    local v50 = TweenService:Create(u6, TweenInfo_new_ret, {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0
                    });
                    table.insert(u11, v50);
                    v50:Play();
                end;

                if u7 then
                    local v51 = TweenService:Create(u7, TweenInfo_new_ret, {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0
                    });
                    table.insert(u11, v51);
                    v51:Play();
                end;

                if u8 then
                    local v52 = TweenService:Create(u8, TweenInfo_new_ret, {
                        ImageTransparency = 0
                    });
                    table.insert(u11, v52);
                    v52:Play();
                end;

                if u9 then
                    local v53 = TweenService:Create(u9, TweenInfo_new_ret, {
                        ImageTransparency = 0
                    });
                    table.insert(u11, v53);
                    v53:Play();
                end;

                task.delay(0.5, u44);
            end);

            return;
        end;

        u17();
    end);
end;

u17 = function() -- Line: 263, Name: FinishDisplay
    -- upvalues: u14 (copy), u15 (ref), u16 (ref), u4 (ref), u11 (copy), u5 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    table.remove(u14, 1);
    u15 = false;

    if #u14 > 0 then
        u16();

        return;
    end;

    if u4 then
        u4.Visible = false;

        for _, v in u11 do
            v:Cancel();
        end;

        table.clear(u11);

        if u5 then
            u5.Position = UDim2_fromScale_ret;
            u5.Size = UDim2_fromScale_ret2;
        end;

        if u6 then
            local v54 = u6;
            v54.TextTransparency = 1;
            v54.TextStrokeTransparency = 1;
        end;

        if u7 then
            local v55 = u7;
            v55.TextTransparency = 1;
            v55.TextStrokeTransparency = 1;
        end;

        if u8 then
            u8.ImageTransparency = 1;
        end;

        if u9 then
            u9.ImageTransparency = 1;
        end;
    end;
end;

u16 = function() -- Line: 273, Name: ProcessQueue
    -- upvalues: u15 (ref), u14 (copy), u4 (ref), u11 (copy), u5 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref), ShowEntry (copy), u17 (ref)
    if u15 then
        return;
    end;

    local v56 = u14[1];

    if not v56 then
        if u4 then
            u4.Visible = false;

            for _, v in u11 do
                v:Cancel();
            end;

            table.clear(u11);

            if u5 then
                u5.Position = UDim2_fromScale_ret;
                u5.Size = UDim2_fromScale_ret2;
            end;

            if u6 then
                local v57 = u6;
                v57.TextTransparency = 1;
                v57.TextStrokeTransparency = 1;
            end;

            if u7 then
                local v58 = u7;
                v58.TextTransparency = 1;
                v58.TextStrokeTransparency = 1;
            end;

            if u8 then
                u8.ImageTransparency = 1;
            end;

            if u9 then
                u9.ImageTransparency = 1;
            end;
        end;

        return;
    end;

    u15 = true;
    ShowEntry(v56, function() -- Line: 285
        -- upvalues: u17 (ref)
        task.delay(3, u17);
    end);
end;

local function BuildEntry(p59) -- Line: 290
    -- upvalues: Missions (copy), ConfigKeys (copy), ConfigController (copy), u2 (copy), u1 (copy), Color3_fromRGB_ret2 (copy)
    local MissionDefinition = Missions.GetMissionDefinition(p59.MissionId);

    if not MissionDefinition then
        return nil;
    end;

    local Type = MissionDefinition.Type;
    local v60 = nil;
    local v61 = MissionDefinition.Rewards and MissionDefinition.Rewards[1];

    if v61 and (v61.type == "Credits" and typeof(v61.amount) == "number") then
        local amount = v61.amount;
        local v62 = ConfigKeys.Shared.MissionCreditRewardMultipliers[Type];
        local v63 = not v62 and 1 or ConfigController.GetRewardMultiplier(v62);
        v60 = math.round(amount * v63);
    end;

    local v64 = {
        typeLabel = u2[Type] or "MISSION"
    };
    local v65 = u1[Type] or Color3_fromRGB_ret2;
    v64.colorHex = string.format("#%02X%02X%02X", math.round(v65.R * 255), math.round(v65.G * 255), (math.round(v65.B * 255)));
    v64.objective = MissionDefinition.DisplayName or MissionDefinition.MissionId;
    v64.creditAmount = v60;

    return v64;
end;

local function EnqueueDisplayEntry(p66: table) -- Line: 311
    -- upvalues: u14 (copy), u16 (ref)
    table.insert(u14, p66);
    u16();
end;

local function OnMissionsChanged(p67) -- Line: 316
    -- upvalues: u12 (copy), u13 (ref), DataController (copy), LocalPlayer (copy), BuildEntry (copy), u14 (copy), u16 (ref)
    if typeof(p67) ~= "table" then
        return;
    end;

    local v68 = {};

    for _, v in ipairs(p67) do
        if typeof(v) == "table" and typeof(v.MissionId) == "string" then
            local v69 = `{v.MissionId}:{v.CreatedAt}`;
            v68[v69] = true;

            if (v.Progress or 0) >= (v.Target or (1 / 0)) and not v.IsClaimed and not u12[v69] then
                u12[v69] = true;

                if u13 and DataController.Get(LocalPlayer, "Settings.Game.HUD.Enable Missions Notifications") ~= false then
                    local v70 = BuildEntry(v);

                    if v70 then
                        table.insert(u14, v70);
                        u16();
                    end;
                end;
            end;
        end;
    end;

    for i in pairs(u12) do
        if not v68[i] then
            u12[i] = nil;
        end;
    end;

    u13 = true;
end;

function v3.Initialize(p71: userdata, p72: userdata) -- Line: 357
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u10 (ref), u9 (ref), u11 (copy), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), GetPreferenceColor (copy), DataController (copy), LocalPlayer (copy), OnMissionsChanged (copy)
    u4 = p72;
    u5 = p72:FindFirstChild("Frame");
    local v73 = u5 and u5:FindFirstChild("Container");
    local v74;

    if v73 then
        v74 = v73:FindFirstChild("Info");
    else
        v74 = v73;
    end;

    local v75;

    if v73 then
        v75 = v73:FindFirstChild("Reward");
    else
        v75 = v73;
    end;

    local v76;

    if v74 then
        v76 = v74:FindFirstChild("Title");
    else
        v76 = v74;
    end;

    u6 = v76;

    if v74 then
        v74 = v74:FindFirstChild("Objective");
    end;

    u7 = v74;

    if v75 then
        v75 = v75:FindFirstChild("Icon");
    end;

    u8 = v75;
    local v77 = u8 and u8:FindFirstChild("Amount");
    u10 = v77;

    if v73 then
        for _, descendant in v73:GetDescendants() do
            if descendant:IsA("ImageLabel") and descendant ~= u8 then
                u9 = descendant;
                break;
            end;
        end;
    end;

    if not (u5 and (u6 and (u7 and u8))) then
        warn("[MissionCompleted] Missing expected UI elements; popup disabled.");

        return;
    end;

    p72.Visible = false;

    for _, v in u11 do
        v:Cancel();
    end;

    table.clear(u11);

    if u5 then
        u5.Position = UDim2_fromScale_ret;
        u5.Size = UDim2_fromScale_ret2;
    end;

    if u6 then
        local v78 = u6;
        v78.TextTransparency = 1;
        v78.TextStrokeTransparency = 1;
    end;

    if u7 then
        local v79 = u7;
        v79.TextTransparency = 1;
        v79.TextStrokeTransparency = 1;
    end;

    if u8 then
        u8.ImageTransparency = 1;
    end;

    if u9 then
        u9.ImageTransparency = 1;
    end;

    local function refreshHUDColor() -- Line: 386
        -- upvalues: u4 (ref), u5 (ref), GetPreferenceColor (ref)
        if u4 and (u4.Visible and u5) then
            u5.BackgroundColor3 = GetPreferenceColor();
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Missions", OnMissionsChanged);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshHUDColor);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshHUDColor);
end;

return v3;