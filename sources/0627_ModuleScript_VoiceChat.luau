-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local VoiceChat = require(ReplicatedStorage.Controllers.InputController.Actions.VoiceChat);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u2 = { "IsSpectating", "Team", "CompetitivePlayerColor", "Dead", "Health" };
local u3 = nil;
local u4 = nil;
local u5 = {};
local u6 = nil;

local function compareVisibleEntries(p7: table, p8: table) -- Line: 63
    if p7.IsSpeaking ~= p8.IsSpeaking then
        return p7.IsSpeaking;
    end;

    if p7.LastSpokeAt == p8.LastSpokeAt then
        return p7.Player.UserId < p8.Player.UserId;
    end;

    return p7.LastSpokeAt > p8.LastSpokeAt;
end;

local function updateVisibleTemplates(p9: number) -- Line: 75
    -- upvalues: u5 (copy), compareVisibleEntries (copy), u3 (ref), u6 (ref)
    local v10 = {};

    for _, v in pairs(u5) do
        local IsSpeaking = v.IsSpeaking;

        if not IsSpeaking and v.StoppedAt then
            IsSpeaking = p9 - v.StoppedAt < 2.85;
        end;

        if IsSpeaking then
            table.insert(v10, v);
        else
            v.Alpha = 1;
            v.Frame.Visible = false;
        end;
    end;

    table.sort(v10, compareVisibleEntries);
    local v11 = 0;

    for i, v in ipairs(v10) do
        local v12 = i <= 3;
        v.Frame.LayoutOrder = i;
        v.Frame.Visible = v12;

        if v12 then
            v11 = v11 + 1;

            if v.IsSpeaking or not v.StoppedAt then
                v.Alpha = 0;
            else
                v.Alpha = math.clamp((p9 - v.StoppedAt - 2.5) / 0.35, 0, 1);
            end;

            local v13 = v;

            for i2, v2 in pairs(v.OriginalTransparency) do
                if i2.Parent then
                    local v14 = i2;

                    for i3, v3 in pairs(v2) do
                        v14[i3] = v3 + (1 - v3) * v13.Alpha;
                    end;
                end;
            end;
        end;
    end;

    if u3 then
        u3.Visible = v11 > 0;
    end;

    if #v10 == 0 and u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function ensureRenderConnection() -- Line: 131
    -- upvalues: u6 (ref), RunServiceController (copy), updateVisibleTemplates (copy)
    if u6 then
        return;
    end;

    u6 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 136
        -- upvalues: updateVisibleTemplates (ref)
        updateVisibleTemplates(os.clock());
    end);
end;

local function updateEntry(p15: table, p16: boolean?) -- Line: 141
    -- upvalues: Colors (copy), CharacterResolver (copy)
    local Attribute = p15.Player:GetAttribute("Team");
    local Attribute2 = p15.Player:GetAttribute("CompetitivePlayerColor");

    if not Attribute2 and Attribute then
        Attribute2 = Colors["Team Color"][Attribute];
    end;

    if p16 ~= nil then
        p15.SpeakingIcon.Visible = p16;
        p15.NotSpeakingIcon.Visible = not p16;
    end;

    local v17 = p15.Player:GetAttribute("IsSpectating") == true and true or p15.Player:GetAttribute("Team") == "Spectators";
    p15.DeadFrame.Visible = v17 or not CharacterResolver.isAlivePlayer(p15.Player);

    if Attribute2 then
        p15.ColorGraphic.BackgroundColor3 = Attribute2;
    end;
end;

local function createEntry(p18: userdata) -- Line: 161
    -- upvalues: u5 (copy), u4 (ref), u3 (ref), u2 (copy), updateEntry (copy)
    if u5[p18] then
        return u5[p18];
    end;

    if not (u4 and u3) then
        return nil;
    end;

    local v19 = u4:Clone();
    v19.Name = tostring(p18.UserId);
    v19.Visible = false;
    v19.Parent = u3;
    local Profile = v19.Profile;
    v19.DisplayName.Text = p18.DisplayName;
    Profile.Image = `rbxthumb://type=AvatarHeadShot&id={p18.UserId}&w=150&h=150`;
    local u20 = {
        Alpha = 1,
        IsSpeaking = false,
        LastSpokeAt = 0,
        StoppedAt = nil,
        ColorGraphic = v19.ColorDot.Graphic,
        Connections = {},
        DeadFrame = Profile.IsKilled,
        Frame = v19,
        NotSpeakingIcon = v19.IsNotSpeaking,
        OriginalTransparency = {},
        Player = p18,
        SpeakingIcon = v19.IsSpeaking
    };
    local v21 = { v19 };

    for _, descendant in ipairs(v19:GetDescendants()) do
        table.insert(v21, descendant);
    end;

    for _, v in ipairs(v21) do
        local v22 = {};

        if v:IsA("GuiObject") then
            v22.BackgroundTransparency = v.BackgroundTransparency;
        end;

        if v:IsA("TextLabel") or (v:IsA("TextButton") or v:IsA("TextBox")) then
            v22.TextTransparency = v.TextTransparency;
            v22.TextStrokeTransparency = v.TextStrokeTransparency;
        end;

        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v22.ImageTransparency = v.ImageTransparency;
        end;

        if v:IsA("UIStroke") then
            v22.Transparency = v.Transparency;
        end;

        if next(v22) then
            u20.OriginalTransparency[v] = v22;
        end;
    end;

    for _, v in ipairs(u2) do
        local Connections = u20.Connections;
        local AttributeChangedSignal = p18:GetAttributeChangedSignal(v);
        table.insert(Connections, AttributeChangedSignal:Connect(function() -- Line: 229
            -- upvalues: updateEntry (ref), u20 (copy)
            updateEntry(u20);
        end));
    end;

    u5[p18] = u20;
    updateEntry(u20, false);

    return u20;
end;

local function destroyEntry(p23: userdata) -- Line: 240
    -- upvalues: u5 (copy), updateVisibleTemplates (copy)
    local v24 = u5[p23];

    if not v24 then
        return;
    end;

    u5[p23] = nil;

    for _, v in ipairs(v24.Connections) do
        v:Disconnect();
    end;

    table.clear(v24.Connections);
    v24.Frame:Destroy();
    updateVisibleTemplates(os.clock());
end;

local function setPlayerSpeaking(p25: userdata, p26: boolean) -- Line: 257
    -- upvalues: u5 (copy), createEntry (copy), updateEntry (copy), updateVisibleTemplates (copy), u6 (ref), RunServiceController (copy)
    local v27 = u5[p25] or createEntry(p25);

    if not v27 then
        return;
    end;

    v27.IsSpeaking = p26;

    if p26 then
        v27.Alpha = 0;
        v27.LastSpokeAt = os.clock();
        v27.StoppedAt = nil;
    else
        v27.StoppedAt = os.clock();
    end;

    updateEntry(v27, p26);
    updateVisibleTemplates(os.clock());

    if u6 then
        return;
    end;

    u6 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 136
        -- upvalues: updateVisibleTemplates (ref)
        updateVisibleTemplates(os.clock());
    end);
end;

function v1.Initialize(p28: userdata, p29: userdata) -- Line: 282
    -- upvalues: u3 (ref), u4 (ref)
    local Template = p29.Template;
    u3 = p29;
    u4 = Template;
    Template.Visible = false;
    u3.Visible = false;
end;

function v1.Start() -- Line: 292
    -- upvalues: u4 (ref), VoiceChat (copy), setPlayerSpeaking (copy), Players (copy), createEntry (copy), destroyEntry (copy), u5 (copy), updateEntry (copy), updateVisibleTemplates (copy), u6 (ref), RunServiceController (copy)
    if not u4 then
        return;
    end;

    VoiceChat.SpeakingChanged:Connect(setPlayerSpeaking);
    Players.PlayerAdded:Connect(createEntry);
    Players.PlayerRemoving:Connect(destroyEntry);

    for _, v in ipairs(Players:GetPlayers()) do
        createEntry(v);

        if VoiceChat.IsPlayerSpeaking(v) then
            local v30 = u5[v] or createEntry(v);

            if v30 then
                v30.IsSpeaking = true;
                v30.Alpha = 0;
                v30.LastSpokeAt = os.clock();
                v30.StoppedAt = nil;
                updateEntry(v30, true);
                updateVisibleTemplates(os.clock());

                if not u6 then
                    u6 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 136
                        -- upvalues: updateVisibleTemplates (ref)
                        updateVisibleTemplates(os.clock());
                    end);
                end;
            end;
        end;
    end;

    updateVisibleTemplates(os.clock());
end;

return v1;