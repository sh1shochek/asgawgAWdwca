-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
require(ReplicatedStorage.Database.Custom.Types);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
require(ReplicatedStorage.Database.Components.Libraries.Cases);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = 0;

local function GetRandomCaseItem(p6) -- Line: 47
    local v7 = 0;

    for _, v in ipairs(p6.contents) do
        v7 = v7 + v.weight;
    end;

    local v8 = math.random() * v7;
    local v9 = 0;

    for _, v in ipairs(p6.contents) do
        v9 = v9 + v.weight;

        if v8 <= v9 then
            return v, v.isSpecial or false;
        end;
    end;

    local v10 = p6.contents[1];

    return v10, v10.isSpecial or false;
end;

local function GenerateScrollItemList(p11: any, p12: any, p13: number, p14: boolean) -- Line: 66
    -- upvalues: u4 (ref), GetRandomCaseItem (copy)
    local v15 = {};

    for i = 1, u4.CASE_SCROLL_ITEM_COUNT do
        local v16;

        if i == p13 then
            table.insert(v15, {
                item = p12,
                isGold = p14
            });
            v16 = i;
        else
            local v17, v18 = GetRandomCaseItem(p11);
            table.insert(v15, {
                item = v17,
                isGold = v18
            });
            v16 = i;
        end;
    end;

    return v15;
end;

local function CreateScrollItem(p19: userdata, p20: table, p21: number, p22) -- Line: 100
    -- upvalues: ReplicatedStorage (copy), Rarities (copy), Skins (copy), u4 (ref)
    local CaseScroll = ReplicatedStorage.Assets.UI.Store.CaseScroll;
    local v23;

    if p20.isGold then
        v23 = CaseScroll:FindFirstChild("GoldTemplate");
    else
        v23 = CaseScroll:FindFirstChild("ItemTemplate");
    end;

    if not v23 then
        warn("[Store] Missing case scroll template");

        return;
    end;

    local v24 = v23:Clone();
    v24.Name = tostring(p21);
    v24.LayoutOrder = p21;
    v24.Size = p22;
    v24.SizeConstraint = Enum.SizeConstraint.RelativeXY;
    v24.AutomaticSize = Enum.AutomaticSize.None;
    v24.Parent = p19;

    if p20.isGold then
        v24.Frame.Icon.Image = u4.SPECIAL_CASE_ICONS[string.lower(p20.item.skin.skinName)] or u4.DEFAULT_CASE_ICON;
    else
        local v25 = Rarities[p20.item.rarity];
        local SkinInformation = Skins.GetSkinInformation(p20.item.skin.weaponName, p20.item.skin.skinName);
        local Frame = v24:FindFirstChild("Frame");

        if v25 and (SkinInformation and Frame) then
            local RarityFrame = Frame:FindFirstChild("RarityFrame");
            local v26 = RarityFrame and RarityFrame:FindFirstChild("UIGradient");

            if v26 then
                v26.Color = v25.ColorSequence;
            end;

            local Icon = Frame:FindFirstChild("Icon");

            if Icon then
                local v27;

                if SkinInformation then
                    if SkinInformation.wearImages and SkinInformation.wearImages[1] then
                        v27 = SkinInformation.wearImages[1].assetId;
                    elseif SkinInformation.charmImages and SkinInformation.charmImages[1] then
                        v27 = SkinInformation.charmImages[1].assetId;
                    else
                        v27 = SkinInformation.imageAssetId or "";
                    end;
                else
                    v27 = "";
                end;

                Icon.Image = v27;
            end;

            local Rarity = Frame:FindFirstChild("Rarity");

            if Rarity then
                Rarity.ImageColor3 = v25.Color;
            end;
        end;
    end;
end;

local function PopulateScrollContainer(p28: userdata, p29: table, p30, p31: number) -- Line: 147
    -- upvalues: CreateScrollItem (copy)
    for _, child in ipairs(p28:GetChildren()) do
        if child:IsA("Frame") or (child:IsA("ImageLabel") or child:IsA("ImageButton")) then
            child:Destroy();
        end;
    end;

    local v32 = p28:FindFirstChildOfClass("UIListLayout");

    if v32 then
        v32.FillDirection = Enum.FillDirection.Horizontal;
        v32.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        v32.VerticalAlignment = Enum.VerticalAlignment.Center;
        v32.Padding = UDim.new(0, p31);
    end;

    for i, v in ipairs(p29) do
        CreateScrollItem(p28, v, i, p30);
    end;
end;

local function ConfigureScrollContainer(p33: userdata, p34: number) -- Line: 172
    local math_max_ret = math.max(p33.AbsoluteSize.X, 1);
    local math_max_ret2 = math.max(p34 / math_max_ret, 1);
    p33.CanvasSize = UDim2.fromScale(math_max_ret2, 0);
    p33:SetAttribute("ScrollMaxOffset", (math.max(0, p34 - math_max_ret)));
    p33:SetAttribute("ScrollViewportWidth", math_max_ret);
end;

local function CalculateTargetOffset(p35: userdata, p36: number, p37: number, p38: number, p39: number) -- Line: 182
    local math_max_ret = math.max(p35.AbsoluteSize.X, 1);
    local math_max_ret2 = math.max(0, p36 - math_max_ret);

    return math_max_ret2 <= 0 and 0 or math.clamp((p37 - 0.5) * p38 - math_max_ret * 0.5 + p39, 0, math_max_ret2);
end;

local function AnimateScroll(u40: userdata, u41: userdata, u42: number, u43: number, u44: number, u45: function) -- Line: 200
    -- upvalues: u4 (ref), TweenService (copy), u3 (ref), RunServiceController (copy)
    local TweenInfo_new_ret = TweenInfo.new(u4.CASE_SCROLL_DURATION, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
    local u46 = TweenService:Create(u40, TweenInfo_new_ret, {
        CanvasPosition = Vector2.new(u42, 0)
    });
    local u47 = TweenService:Create(u41, TweenInfo_new_ret, {
        CanvasPosition = Vector2.new(u43, 0)
    });
    u3.currentTween = u46;
    u3.currentZoomTween = u47;
    local u48 = 0;
    local u49 = nil;

    local function stopRender() -- Line: 222
        -- upvalues: u49 (ref), u3 (ref)
        if u49 then
            u49:Disconnect();
            u49 = nil;
            u3.renderConnection = nil;
        end;
    end;

    u49 = RunServiceController.BindToRenderStep("UI.Store.CaseOpeningSounds", function() -- Line: 229
        -- upvalues: u3 (ref), u49 (ref), u40 (copy), u44 (copy), u48 (ref), u4 (ref), u45 (copy), u46 (copy)
        if not u3.isOpening then
            if u49 then
                u49:Disconnect();
                u49 = nil;
                u3.renderConnection = nil;
            end;

            return;
        end;

        local v50 = math.floor(u44 <= 0 and 0 or u40.CanvasPosition.X / u44) + 1;

        if u48 < v50 and v50 <= u4.CASE_SCROLL_ITEM_COUNT then
            u45(v50);
            u48 = v50;
        end;

        if u46.PlaybackState == Enum.PlaybackState.Completed and u49 then
            u49:Disconnect();
            u49 = nil;
            u3.renderConnection = nil;
        end;
    end);
    u3.renderConnection = u49;
    u46.Completed:Connect(function() -- Line: 252
        -- upvalues: u46 (copy), u3 (ref), u49 (ref)
        if u46 == u3.currentTween and u49 then
            u49:Disconnect();
            u49 = nil;
            u3.renderConnection = nil;
        end;
    end);
    task.delay(u4.CASE_SCROLL_DURATION * 0.86, function() -- Line: 259
        -- upvalues: u46 (copy), u3 (ref), u40 (copy), u41 (copy), u47 (copy), u42 (copy), u43 (copy), u49 (ref)
        if u46 ~= u3.currentTween then
            return;
        end;

        if u46.PlaybackState == Enum.PlaybackState.Completed then
            return;
        end;

        if u40.Parent ~= nil and u41.Parent ~= nil then
            u46:Cancel();
            u47:Cancel();
            u40.CanvasPosition = Vector2.new(u42, 0);
            u41.CanvasPosition = Vector2.new(u43, 0);
        end;

        if u49 then
            u49:Disconnect();
            u49 = nil;
            u3.renderConnection = nil;
        end;
    end);
    u46:Play();
    u47:Play();

    return u46;
end;

local function FindWinningItem(p51, p52) -- Line: 283
    for _, v in ipairs(p51.contents) do
        if v.skin.skinName == p52.Skin and v.skin.weaponName == p52.Name then
            return v, v.isSpecial or false;
        end;
    end;

    if p52.Type == "Melee" or p52.Type == "Glove" then
        return {
            isSpecial = true,
            rarity = "Special",
            skinId = "",
            weight = 0,
            skin = {
                weaponName = p52.Name,
                skinName = p52.Skin,
                type = p52.Type
            }
        }, true;
    end;

    local v53 = p51.contents[1];

    return v53, v53.isSpecial or false;
end;

local function ResetProgressBar() -- Line: 309
    -- upvalues: u3 (ref), u2 (ref)
    if u3.progressRightTween then
        u3.progressRightTween:Cancel();
        u3.progressRightTween = nil;
    end;

    if u3.progressRightProxy then
        u3.progressRightProxy:Destroy();
        u3.progressRightProxy = nil;
    end;

    if not u2 then
        return;
    end;

    local ProgressBar = u2.Menu.OpenCase.Contents:FindFirstChild("ProgressBar");

    if not ProgressBar then
        return;
    end;

    for _, v in { "RightGradient", "LeftGradient" } do
        local v54 = ProgressBar:FindFirstChild(v);
        local v55 = v54 and v54:FindFirstChild("ProgressBarImage") and v54.ProgressBarImage:FindFirstChild("UIGradient");

        if v55 then
            v55.Transparency = NumberSequence.new(1);
            v55.Rotation = 90;
        end;
    end;
end;

local function MakeArcTransparency(p56: number, p57: number, p58: number) -- Line: 340
    if p56 <= 0.001 then
        return NumberSequence.new(p58);
    end;

    if p56 >= 0.999 then
        return NumberSequence.new(p57);
    end;

    local math_clamp_ret = math.clamp(p56 - 0.05, 0, 0.999);
    local math_clamp_ret2 = math.clamp(p56, math_clamp_ret + 0.001, 1);

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, p57),
        NumberSequenceKeypoint.new(math_clamp_ret, p57),
        NumberSequenceKeypoint.new(math_clamp_ret2, p58),
        NumberSequenceKeypoint.new(1, p58)
    });
end;

local function MakeFillTransparency(p59: number) -- Line: 357
    -- upvalues: MakeArcTransparency (copy)
    return MakeArcTransparency(p59, 0, 1);
end;

local function MakeEraseTransparency(p60: number) -- Line: 361
    -- upvalues: MakeArcTransparency (copy)
    return MakeArcTransparency(p60, 1, 0);
end;

local function AnimateProgressBar(p61: number) -- Line: 367
    -- upvalues: ResetProgressBar (copy), u2 (ref), u5 (ref), u4 (ref), u3 (ref), TweenService (copy), MakeFillTransparency (copy), MakeEraseTransparency (copy), Profiler (copy)
    ResetProgressBar();

    if not u2 then
        return;
    end;

    local ProgressBar = u2.Menu.OpenCase.Contents:FindFirstChild("ProgressBar");

    if not ProgressBar then
        return;
    end;

    local LeftGradient = ProgressBar:FindFirstChild("LeftGradient");
    local RightGradient = ProgressBar:FindFirstChild("RightGradient");

    if not (LeftGradient and RightGradient) then
        return;
    end;

    local ProgressBarImage = LeftGradient:FindFirstChild("ProgressBarImage");
    local ProgressBarImage2 = RightGradient:FindFirstChild("ProgressBarImage");

    if not (ProgressBarImage and ProgressBarImage2) then
        return;
    end;

    local UIGradient = ProgressBarImage:FindFirstChild("UIGradient");
    local UIGradient2 = ProgressBarImage2:FindFirstChild("UIGradient");

    if not (UIGradient and UIGradient2) then
        return;
    end;

    LeftGradient.ClipsDescendants = true;
    RightGradient.ClipsDescendants = true;
    UIGradient.Rotation = 90;
    UIGradient2.Rotation = -90;
    UIGradient.Transparency = NumberSequence.new(1);
    UIGradient2.Transparency = NumberSequence.new(1);
    ProgressBar.Visible = true;
    u5 = u5 + 1;
    local u62 = u5;
    local u63 = p61 / u4.PROGRESS_BAR_LOOPS / 4;

    local function runPhase(u64: userdata, u65: function, p66: number) -- Line: 407
        -- upvalues: u3 (ref), u62 (copy), u5 (ref), TweenService (ref)
        if not u3.isOpening or u62 ~= u5 then
            return false;
        end;

        local NumberValue = Instance.new("NumberValue");
        NumberValue.Value = 0;
        local v68 = NumberValue.Changed:Connect(function(p67) -- Line: 418
            -- upvalues: u64 (copy), u65 (copy)
            u64.Transparency = u65(p67);
        end);
        u3.progressRightProxy = NumberValue;
        local v69 = TweenService:Create(NumberValue, TweenInfo.new(p66, Enum.EasingStyle.Linear), {
            Value = 1
        });
        u3.progressRightTween = v69;
        v69:Play();
        v69.Completed:Wait();
        v68:Disconnect();
        NumberValue:Destroy();
        u3.progressRightProxy = nil;
        u3.progressRightTween = nil;

        return u3.isOpening and u62 == u5;
    end;

    local u70 = {
        { UIGradient, MakeFillTransparency },
        { UIGradient2, MakeFillTransparency },
        { UIGradient, MakeEraseTransparency },
        { UIGradient2, MakeEraseTransparency }
    };
    Profiler.spawn("UI.Store.ProgressBarThread", function() -- Line: 444
        -- upvalues: u4 (ref), u70 (copy), runPhase (copy), u63 (copy)
        for i = 1, u4.PROGRESS_BAR_LOOPS do
            local _ = i;

            for _, v in u70 do
                if not runPhase(v[1], v[2], u63) then
                    return;
                end;
            end;
        end;
    end);
end;

local function RunScrollAnimation(p71, p72) -- Line: 457
    -- upvalues: u3 (ref), u2 (ref), FindWinningItem (copy), GenerateScrollItemList (copy), u4 (ref), PopulateScrollContainer (copy), ConfigureScrollContainer (copy), AnimateScroll (copy), Router (copy), AnimateProgressBar (copy), TweenService (copy)
    if not u3.isOpening then
        return nil;
    end;

    local OpenCase = u2.Menu.OpenCase;
    local CanvasGroup = OpenCase:FindFirstChild("CanvasGroup");
    local Zoom = OpenCase:FindFirstChild("Zoom");

    if not (CanvasGroup and Zoom) then
        warn("[Store] Missing CanvasGroup or Zoom group in OpenCase UI");

        return nil;
    end;

    local Container = CanvasGroup:FindFirstChild("Container");
    local Container2 = Zoom:FindFirstChild("Container");

    if not (Container and Container2) then
        warn("[Store] Missing scroll containers for case opening");

        return nil;
    end;

    local v73, v74 = FindWinningItem(p71, p72);
    local v75 = GenerateScrollItemList(p71, v73, u4.CASE_SCROLL_WINNING_INDEX, v74);
    local v76 = u2 and u2.AbsoluteSize or Vector2.new(u4.CASE_SCROLL_ITEM_WIDTH * 5, 1000);
    local math_max_ret = math.max(v76.X / 5, 1);
    local math_max_ret2 = math.max(math_max_ret * 0.65, 1);
    local UDim2_fromOffset_ret = UDim2.fromOffset(math_max_ret, math_max_ret2);
    local UDim2_fromOffset_ret2 = UDim2.fromOffset(math_max_ret, math_max_ret2 * 1.125);
    local Line = OpenCase:FindFirstChild("Line");

    if Line and Line:IsA("GuiObject") then
        Line.Size = UDim2.new(0.003, 0, 0, math_max_ret2 * 1.125);
    end;

    PopulateScrollContainer(Container, v75, UDim2_fromOffset_ret, u4.CASE_SCROLL_ITEM_PADDING);
    PopulateScrollContainer(Container2, v75, UDim2_fromOffset_ret2, u4.CASE_SCROLL_ITEM_PADDING);
    Container.CanvasPosition = Vector2.new(0, 0);
    Container2.CanvasPosition = Vector2.new(0, 0);
    local u77 = math_max_ret + u4.CASE_SCROLL_ITEM_PADDING;
    local u78 = u4.CASE_SCROLL_ITEM_COUNT * u77;
    task.wait();
    ConfigureScrollContainer(Container, u78);
    ConfigureScrollContainer(Container2, u78);
    local X = v76.X;
    local math_random_ret = math.random(-math.floor(X / 11), (math.floor(X / 22)));
    local CASE_SCROLL_WINNING_INDEX = u4.CASE_SCROLL_WINNING_INDEX;
    local math_max_ret3 = math.max(Container.AbsoluteSize.X, 1);
    local math_max_ret4 = math.max(0, u78 - math_max_ret3);
    local v79 = math_max_ret4 <= 0 and 0 or math.clamp((CASE_SCROLL_WINNING_INDEX - 0.5) * u77 - math_max_ret3 * 0.5 + math_random_ret, 0, math_max_ret4);
    local CASE_SCROLL_WINNING_INDEX2 = u4.CASE_SCROLL_WINNING_INDEX;
    local math_max_ret5 = math.max(Container2.AbsoluteSize.X, 1);
    local math_max_ret6 = math.max(0, u78 - math_max_ret5);
    local v80 = math_max_ret6 <= 0 and 0 or math.clamp((CASE_SCROLL_WINNING_INDEX2 - 0.5) * u77 - math_max_ret5 * 0.5 + math_random_ret, 0, math_max_ret6);
    Container:SetAttribute("_scrollTarget", v79);
    Container2:SetAttribute("_scrollTarget", v80);
    local u81 = tick();
    local v82 = AnimateScroll(Container, Container2, v79, v80, u77, function() -- Line: 506
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    AnimateProgressBar(u4.CASE_SCROLL_DURATION);
    u3.viewportConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 512
        -- upvalues: u3 (ref), Container (copy), u78 (copy), u4 (ref), u77 (copy), math_random_ret (copy), Container2 (copy), u81 (copy), TweenService (ref)
        if not u3.isOpening then
            return;
        end;

        local CASE_SCROLL_WINNING_INDEX3 = u4.CASE_SCROLL_WINNING_INDEX;
        local math_max_ret7 = math.max(Container.AbsoluteSize.X, 1);
        local math_max_ret8 = math.max(0, u78 - math_max_ret7);
        local v83 = math_max_ret8 <= 0 and 0 or math.clamp((CASE_SCROLL_WINNING_INDEX3 - 0.5) * u77 - math_max_ret7 * 0.5 + math_random_ret, 0, math_max_ret8);
        local CASE_SCROLL_WINNING_INDEX4 = u4.CASE_SCROLL_WINNING_INDEX;
        local math_max_ret9 = math.max(Container2.AbsoluteSize.X, 1);
        local math_max_ret10 = math.max(0, u78 - math_max_ret9);
        local v84 = math_max_ret10 <= 0 and 0 or math.clamp((CASE_SCROLL_WINNING_INDEX4 - 0.5) * u77 - math_max_ret9 * 0.5 + math_random_ret, 0, math_max_ret10);

        if u3.currentTween then
            u3.currentTween:Cancel();
        end;

        if u3.currentZoomTween then
            u3.currentZoomTween:Cancel();
        end;

        local v85 = u4.CASE_SCROLL_DURATION - (tick() - u81);
        local math_max_ret11 = math.max(0.1, v85);
        local TweenInfo_new_ret = TweenInfo.new(math_max_ret11, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local v86 = TweenService:Create(Container, TweenInfo_new_ret, {
            CanvasPosition = Vector2.new(v83, 0)
        });
        local v87 = TweenService:Create(Container2, TweenInfo_new_ret, {
            CanvasPosition = Vector2.new(v84, 0)
        });
        u3.currentTween = v86;
        u3.currentZoomTween = v87;
        v86:Play();
        v87:Play();
    end);

    if v82 then
        while u3.isOpening do
            local currentTween = u3.currentTween;

            if not currentTween then
                break;
            end;

            currentTween.Completed:Wait();

            if u3.currentTween == currentTween then
                break;
            end;
        end;
    end;

    if u3.viewportConnection then
        u3.viewportConnection:Disconnect();
        u3.viewportConnection = nil;
    end;

    u3.currentTween = nil;
    u3.currentZoomTween = nil;

    return v73;
end;

function v1.Bind(p88: userdata, p89: table, p90: table) -- Line: 561
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    u2 = p88;
    u3 = p89;
    u4 = p90;
end;

function v1.GetStoreItemIcon(p91) -- Line: 86
    if not p91 then
        return "";
    end;

    if p91.wearImages and p91.wearImages[1] then
        return p91.wearImages[1].assetId;
    end;

    return not (p91.charmImages and p91.charmImages[1]) and (p91.imageAssetId or "") or p91.charmImages[1].assetId;
end;

v1.ResetProgressBar = ResetProgressBar;
v1.RunScrollAnimation = RunScrollAnimation;

return v1;