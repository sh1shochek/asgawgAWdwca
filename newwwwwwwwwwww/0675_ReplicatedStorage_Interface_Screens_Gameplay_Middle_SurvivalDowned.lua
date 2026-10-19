-- SurvivalDowned (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.SurvivalDowned

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local GetBindIcon = require(ReplicatedStorage.Components.Common.GetBindIcon);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret3 = Color3.fromRGB(214, 41, 41);
local UDim2_fromScale_ret = UDim2.fromScale(0.5, 0.62);
local Vector2_new_ret = Vector2.new(0.5, 0);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.5, 0.42);
local Vector2_new_ret2 = Vector2.new(0.5, 1);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function displayName(p6: userdata?) -- Line: 77
    return not p6 and "A TEAMMATE" or string.upper(p6.DisplayName);
end;

local function helpers(p7: userdata?) -- Line: 82
    -- upvalues: SurvivalDowned (copy)
    local v8 = SurvivalDowned.GetReviverCount(p7) - 1;

    return v8 <= 0 and "" or ` +{v8}`;
end;

local function applyPanelLayout() -- Line: 87
    -- upvalues: u2 (ref), UserInputService (copy), Vector2_new_ret2 (copy), Vector2_new_ret (copy), UDim2_fromScale_ret2 (copy), UDim2_fromScale_ret (copy)
    local v9 = u2;

    if not v9 then
        return;
    end;

    local v10 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
    local v11;

    if v10 then
        v11 = Vector2_new_ret2;
    else
        v11 = Vector2_new_ret;
    end;

    v9.AnchorPoint = v11;
    local v12;

    if v10 then
        v12 = UDim2_fromScale_ret2;
    else
        v12 = UDim2_fromScale_ret;
    end;

    v9.Position = v12;
end;

local function bindPromptKey(p13, p14) -- Line: 98
    -- upvalues: SurvivalDowned (copy), GetBindIcon (copy), Tips (copy)
    local v15 = nil;
    local v16;

    if p14 == Enum.PreferredInput.Touch then
        v16 = SurvivalDowned.TOUCH_USE_IMAGE;
    else
        v16 = GetBindIcon(Tips.ResolveActionBinding("Use"));

        if v16 then
            v15 = nil;
        else
            v15 = Tips.GetActionKeyText("Use") or "E";
        end;
    end;

    p13.Key.Icon.Image = v16 or "";
    p13.Key.Icon.Visible = v16 ~= nil;
    p13.Key.Text.Text = v15 or "";
    p13.Key.Text.Visible = v15 ~= nil;
end;

local function showPanel(p17: userdata?, p18: string, p19: string, p20: number, p21) -- Line: 114
    -- upvalues: u2 (ref), UserInputService (copy), u4 (ref), u5 (ref), bindPromptKey (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy)
    local v22 = u2;

    if not v22 then
        return;
    end;

    v22.Visible = true;
    v22.Key.Visible = p17 ~= nil;

    if p17 then
        local PreferredInput = UserInputService.PreferredInput;

        if p17 ~= u4 or PreferredInput ~= u5 then
            u4 = p17;
            u5 = PreferredInput;
            bindPromptKey(v22, PreferredInput);
        end;
    else
        u4 = nil;
    end;

    local Panel = v22.Panel;

    if Panel.Title.Text ~= p18 then
        Panel.Title.Text = p18;
    end;

    if Panel.Amount.Text ~= p19 then
        Panel.Amount.Text = p19;
    end;

    local v23;

    if p21 == Color3_fromRGB_ret3 then
        v23 = Color3_fromRGB_ret3;
    else
        v23 = Color3_fromRGB_ret;
    end;

    Panel.Title.TextColor3 = v23;
    local Bar = Panel.Track.Bar;
    Bar.Size = UDim2.fromScale(math.clamp(p20, 0, 1), 1);
    Bar.BackgroundColor3 = p21;
    Bar.Glow.ImageColor3 = p21;
    Bar.Glow.Visible = p20 > 0.02;
end;

local function hidePanel() -- Line: 145
    -- upvalues: u2 (ref), u4 (ref)
    local v24 = u2;

    if v24 and v24.Visible then
        v24.Visible = false;
        u4 = nil;
    end;
end;

local function updateVignette(p25: boolean) -- Line: 153
    -- upvalues: u3 (ref), SurvivalDowned (copy), LocalPlayer (copy)
    local v26 = u3;

    if not v26 then
        return;
    end;

    if v26.Visible ~= p25 then
        v26.Visible = p25;
    end;

    if p25 then
        local v27 = SurvivalDowned.GetBleedOutLeft(LocalPlayer) / SurvivalDowned.BLEED_OUT_SECONDS;
        local v28 = os.clock() * 3.141592653589793 * 2 / 1.1;
        local v29 = (math.sin(v28) + 1) / 2;
        local v30 = math.clamp(1 - v27, 0, 1) * 0.6 + v29 * 0.4;
        v26.Vignette.ImageTransparency = v30 * -0.3 + 0.35;
    end;
end;

function u1.Update(p31: userdata?) -- Line: 174
    -- upvalues: SurvivalDowned (copy), LocalPlayer (copy), updateVignette (copy), showPanel (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), u2 (ref), u4 (ref)
    local v32 = SurvivalDowned.IsDowned(LocalPlayer);
    updateVignette(v32);

    if v32 then
        local Reviver = SurvivalDowned.GetReviver(LocalPlayer);
        local ReviveProgress = SurvivalDowned.GetReviveProgress(LocalPlayer);

        if not (Reviver and ReviveProgress) then
            local BleedOutLeft = SurvivalDowned.GetBleedOutLeft(LocalPlayer);
            showPanel(nil, "DOWNED", `{math.ceil(BleedOutLeft)}s`, BleedOutLeft / SurvivalDowned.BLEED_OUT_SECONDS, Color3_fromRGB_ret3);

            return;
        end;

        local v33 = not Reviver and "A TEAMMATE" or string.upper(Reviver.DisplayName);
        local v34 = SurvivalDowned.GetReviverCount(LocalPlayer) - 1;
        showPanel(nil, `BEING REVIVED BY {v33}{v34 <= 0 and "" or ` +{v34}`}`, `{math.floor(ReviveProgress * 100)}%`, ReviveProgress, Color3_fromRGB_ret2);

        return;
    end;

    if not SurvivalDowned.IsReviving(LocalPlayer) then
        if p31 then
            showPanel(p31, `HOLD TO {SurvivalDowned.GetReviver(p31) and "HELP REVIVE" or "REVIVE"} {not p31 and "A TEAMMATE" or string.upper(p31.DisplayName)}`, "", 0, Color3_fromRGB_ret2);

            return;
        end;

        local v35 = u2;

        if v35 and v35.Visible then
            v35.Visible = false;
            u4 = nil;
        end;

        return;
    end;

    local ReviveTarget = SurvivalDowned.GetReviveTarget(LocalPlayer);
    local v36 = ReviveTarget and (SurvivalDowned.GetReviveProgress(ReviveTarget) or 0) or 0;
    local v37 = not ReviveTarget and "A TEAMMATE" or string.upper(ReviveTarget.DisplayName);
    local v38 = SurvivalDowned.GetReviverCount(ReviveTarget) - 1;
    showPanel(nil, `REVIVING {v37}{v38 <= 0 and "" or ` +{v38}`}`, `{math.floor(v36 * 100)}%`, v36, Color3_fromRGB_ret2);
end;

function u1.Hide() -- Line: 202
    -- upvalues: u3 (ref), u2 (ref), u4 (ref)
    local v39 = u3;

    if v39 and v39.Visible ~= false then
        v39.Visible = false;
    end;

    local v40 = u2;

    if v40 and v40.Visible then
        v40.Visible = false;
        u4 = nil;
    end;
end;

function u1.Initialize(p41: userdata, p42: userdata) -- Line: 210
    -- upvalues: u2 (ref), u3 (ref), u1 (copy), UserInputService (copy), Vector2_new_ret2 (copy), Vector2_new_ret (copy), UDim2_fromScale_ret2 (copy), UDim2_fromScale_ret (copy), applyPanelLayout (copy)
    u2 = p42;
    u3 = p41.Gameplay.DownedVignette;
    u1.Hide();
    local v43 = u2;

    if v43 then
        local v44 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
        local v45;

        if v44 then
            v45 = Vector2_new_ret2;
        else
            v45 = Vector2_new_ret;
        end;

        v43.AnchorPoint = v45;
        local v46;

        if v44 then
            v46 = UDim2_fromScale_ret2;
        else
            v46 = UDim2_fromScale_ret;
        end;

        v43.Position = v46;
    end;

    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(applyPanelLayout);
end;

return u1;