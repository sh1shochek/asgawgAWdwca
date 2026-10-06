-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local CalculateGridRenderCount = require(ReplicatedStorage.Components.Common.CalculateGridRenderCount);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local ApplyWearAndSerialBadges = require(ReplicatedStorage.Components.Common.ApplyWearAndSerialBadges);
local Router = require(ReplicatedStorage.Database.Security.Router);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Signal = require(ReplicatedStorage.Packages.Signal);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local script_Actions = require(script.Actions);
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float", "Serial" };
local u3 = nil;
local u4 = nil;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = {};
local u10 = 0;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
u1.OnItemSelected = Signal.new();
u1.OnClosed = Signal.new();

local function MultiplyUdim2(p17, p18: number) -- Line: 91
    return UDim2.new(p17.X.Scale * p18, p17.X.Offset, p17.Y.Scale * p18, p17.Y.Offset);
end;

local function ClearFrame(p19: userdata, p20: string) -- Line: 97
    for _, child in ipairs(p19:GetChildren()) do
        if child.ClassName == p20 or child:IsA("GuiButton") then
            child:Destroy();
        end;
    end;
end;

local function CloseWithoutSelection() -- Line: 107
    -- upvalues: u1 (copy), u3 (ref)
    u1.OnClosed:Fire(u3);
    u1.Hide();
end;

local function OnItemSelected(p21) -- Line: 112
    -- upvalues: u3 (ref), u1 (copy)
    if u3 then
        u1.OnItemSelected:Fire(p21, u3);
        u1.Hide();
    end;
end;

local function AnimateSortButton(u22: userdata, u23: any, u24: string, u25: userdata) -- Line: 121
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), Router (copy), u7 (ref), u1 (copy)
    u23.MouseEnter:Connect(function() -- Line: 127
        -- upvalues: TweenService (ref), u23 (copy), TweenInfo_new_ret (ref)
        TweenService:Create(u23, TweenInfo_new_ret, {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u23.MouseLeave:Connect(function() -- Line: 131
        -- upvalues: TweenService (ref), u23 (copy), TweenInfo_new_ret (ref)
        TweenService:Create(u23, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end);
    u23.MouseButton1Click:Connect(function() -- Line: 135
        -- upvalues: Router (ref), u7 (ref), u24 (copy), u1 (ref), u25 (copy), u22 (copy), u23 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u7 = u24;
        u1.PopulateItems();
        u25.Text = u24;

        for _, child in ipairs(u22:GetChildren()) do
            if child:IsA("TextButton") then
                child.Frame.BackgroundTransparency = child == u23 and 0 or 1;
            end;
        end;

        u22.Visible = false;
    end);
end;

local function AnimateButton(u26) -- Line: 151
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    local Size = u26.Size;

    local function tweenToScale(p27: number) -- Line: 153
        -- upvalues: TweenService (ref), u26 (copy), TweenInfo_new_ret (ref), Size (copy)
        local v28 = {};
        local v29 = Size;
        v28.Size = UDim2.new(v29.X.Scale * p27, v29.X.Offset, v29.Y.Scale * p27, v29.Y.Offset);
        TweenService:Create(u26, TweenInfo_new_ret, v28):Play();
    end;

    u26.MouseEnter:Connect(function() -- Line: 157
        -- upvalues: TweenService (ref), u26 (copy), TweenInfo_new_ret (ref), Size (copy)
        local v30 = {};
        local v31 = Size;
        v30.Size = UDim2.new(v31.X.Scale * 0.95, v31.X.Offset, v31.Y.Scale * 0.95, v31.Y.Offset);
        TweenService:Create(u26, TweenInfo_new_ret, v30):Play();
    end);
    u26.MouseLeave:Connect(function() -- Line: 160
        -- upvalues: TweenService (ref), u26 (copy), TweenInfo_new_ret (ref), Size (copy)
        local v32 = {};
        local v33 = Size;
        v32.Size = UDim2.new(v33.X.Scale * 1, v33.X.Offset, v33.Y.Scale * 1, v33.Y.Offset);
        TweenService:Create(u26, TweenInfo_new_ret, v32):Play();
    end);
    u26.MouseButton1Down:Connect(function() -- Line: 163
        -- upvalues: TweenService (ref), u26 (copy), TweenInfo_new_ret (ref), Size (copy)
        local v34 = {};
        local v35 = Size;
        v34.Size = UDim2.new(v35.X.Scale * 0.9, v35.X.Offset, v35.Y.Scale * 0.9, v35.Y.Offset);
        TweenService:Create(u26, TweenInfo_new_ret, v34):Play();
    end);
    u26.MouseButton1Up:Connect(function() -- Line: 166
        -- upvalues: TweenService (ref), u26 (copy), TweenInfo_new_ret (ref), Size (copy)
        local v36 = {};
        local v37 = Size;
        v36.Size = UDim2.new(v37.X.Scale * 0.95, v37.X.Offset, v37.Y.Scale * 0.95, v37.Y.Offset);
        TweenService:Create(u26, TweenInfo_new_ret, v36):Play();
    end);
end;

local function CalculateUseItemFrameInitialRenderCount() -- Line: 173
    -- upvalues: u12 (ref), CalculateGridRenderCount (copy)
    return not (u12 and u12.Visible) and 50 or CalculateGridRenderCount(u12);
end;

local function UseItemFrameLoadMoreItems() -- Line: 182
    -- upvalues: u12 (ref), u10 (ref), u9 (ref), u1 (copy), OnItemSelected (copy)
    if not u12 then
        return;
    end;

    local math_min_ret = math.min(u10 + 25, #u9);

    for i = u10 + 1, math_min_ret do
        local v38 = u9[i];
        local v39;

        if v38 and not u12:FindFirstChild(v38._id) then
            u1.CreateItemTemplate(v38, OnItemSelected);
            v39 = i;
        else
            v39 = i;
        end;
    end;

    u10 = math_min_ret;
end;

local function UseItemFrameOnScrollPositionChanged() -- Line: 201
    -- upvalues: u12 (ref), u10 (ref), u9 (ref), UseItemFrameLoadMoreItems (copy)
    if not u12 then
        return;
    end;

    local v40 = u12.AbsoluteCanvasSize.Y - u12.AbsoluteSize.Y;

    if v40 > 0 and (u10 < #u9 and v40 - u12.CanvasPosition.Y < 200) then
        UseItemFrameLoadMoreItems();
    end;
end;

local function FindContainerAndSort(p41: userdata) -- Line: 220
    -- upvalues: u12 (ref), u16 (ref)
    local Tabs = p41:FindFirstChild("Tabs");

    if not Tabs then
        return;
    end;

    local Inventory = Tabs:FindFirstChild("Inventory");

    if Inventory then
        u12 = Inventory:FindFirstChild("Container");
        u16 = Inventory:FindFirstChild("Sort");
    end;
end;

local function SetupSortButton(u42: userdata) -- Line: 233
    -- upvalues: u7 (ref), Router (copy), u2 (copy), AnimateSortButton (copy)
    local TextLabel = u42:FindFirstChild("Frame"):FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = "Newest";
        u7 = "Newest";
    end;

    u42.MouseButton1Click:Connect(function() -- Line: 240
        -- upvalues: u42 (copy), Router (ref)
        local Options = u42:FindFirstChild("Options");

        if Options then
            Options.Visible = not Options.Visible;
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;
    end);
    local Options = u42:FindFirstChild("Options");

    if not (Options and TextLabel) then
        return;
    end;

    for _, v in u2 do
        local v43 = Options:FindFirstChild(v);

        if v43 then
            AnimateSortButton(Options, v43, v, TextLabel);
        end;
    end;
end;

local function findReverseSortButton(p44: userdata) -- Line: 262
    -- upvalues: u16 (ref)
    local Frame = p44:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChild("Right");
    end;

    if Frame then
        Frame = Frame:FindFirstChild("Top");
    end;

    if Frame then
        Frame = Frame:FindFirstChild("ReverseSort");
    end;

    if Frame and Frame:IsA("GuiButton") then
        return Frame;
    end;

    local v45 = u16 and u16:FindFirstChild("ReverseSort");

    if v45 and v45:IsA("GuiButton") then
        return v45;
    end;

    return nil;
end;

local function setupReverseSortButton(p46: userdata) -- Line: 274
    -- upvalues: findReverseSortButton (copy), u8 (ref), u1 (copy), Router (copy)
    local v47 = findReverseSortButton(p46);

    if not v47 then
        return;
    end;

    local u48 = v47:FindFirstChildOfClass("ImageLabel");
    v47.Selectable = true;
    v47.Activated:Connect(function() -- Line: 282
        -- upvalues: u8 (ref), u48 (copy), u1 (ref), Router (ref)
        u8 = not u8;

        if u48 then
            u48.Rotation = u8 and 180 or 0;
        end;

        u1.PopulateItems();
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
end;

local function SetupTopBar(p49: userdata) -- Line: 294
    -- upvalues: u13 (ref), u14 (ref), CloseButtonRegistry (copy), u11 (ref), Router (copy), u1 (copy), u3 (ref)
    local Top = p49:FindFirstChild("Top");

    if not Top then
        return true;
    end;

    u13 = Top:FindFirstChild("TextLabel");
    u14 = Top:FindFirstChild("Close");

    if not u14 then
        return false;
    end;

    CloseButtonRegistry.Add(u11, u14, function() -- Line: 306
        -- upvalues: Router (ref), u1 (ref), u3 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u1.OnClosed:Fire(u3);
        u1.Hide();
    end);

    return true;
end;

local function ConnectScrollLoading() -- Line: 313
    -- upvalues: u12 (ref), u10 (ref), u9 (ref), UseItemFrameLoadMoreItems (copy)
    if u12 then
        u12:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 315
            -- upvalues: u12 (ref), u10 (ref), u9 (ref), UseItemFrameLoadMoreItems (ref)
            if not u12 then
                return;
            end;

            local v50 = u12.AbsoluteCanvasSize.Y - u12.AbsoluteSize.Y;

            if v50 > 0 and (u10 < #u9 and v50 - u12.CanvasPosition.Y < 200) then
                UseItemFrameLoadMoreItems();
            end;
        end);
    end;
end;

local function ConnectStateListeners() -- Line: 322
    -- upvalues: DataController (copy), LocalPlayer (copy), u1 (copy), MenuState (copy), u3 (ref)
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 323
        -- upvalues: u1 (ref)
        if u1.IsVisible() then
            u1.PopulateItems();
        end;
    end);
    MenuState.OnScreenChanged:Connect(function() -- Line: 329
        -- upvalues: u1 (ref), u3 (ref)
        if u1.IsVisible() then
            u1.OnClosed:Fire(u3);
            u1.Hide();
        end;
    end);

    local function closeWhenActivated(p51: boolean) -- Line: 335
        -- upvalues: u1 (ref), u3 (ref)
        if p51 and u1.IsVisible() then
            u1.OnClosed:Fire(u3);
            u1.Hide();
        end;
    end;

    MenuState.OnInspectStateChanged:Connect(closeWhenActivated);
    MenuState.OnCaseSceneStateChanged:Connect(closeWhenActivated);
end;

local function EnsureInitialized() -- Line: 347
    -- upvalues: u5 (ref), u15 (ref), PlayerGui (copy), u11 (ref), u12 (ref), u16 (ref), SetupSortButton (copy), findReverseSortButton (copy), u8 (ref), u1 (copy), Router (copy), SetupTopBar (copy), ConnectStateListeners (copy), u10 (ref), u9 (ref), UseItemFrameLoadMoreItems (copy)
    if u5 then
        return true;
    end;

    u15 = PlayerGui:FindFirstChild("MainGui");

    if not u15 then
        warn("[UseItemFrame] MainGui not found");

        return false;
    end;

    local Menu = u15:FindFirstChild("Menu");

    if not Menu then
        warn("[UseItemFrame] Menu frame not found");

        return false;
    end;

    u11 = Menu:FindFirstChild("UseItemFrame");

    if not u11 then
        warn("[UseItemFrame] UseItemFrame not found in Menu");

        return false;
    end;

    local Tabs = u11:FindFirstChild("Tabs");
    local v52 = Tabs and Tabs:FindFirstChild("Inventory");

    if v52 then
        u12 = v52:FindFirstChild("Container");
        u16 = v52:FindFirstChild("Sort");
    end;

    local v53 = u16 and u16:FindFirstChild("Button");

    if v53 then
        SetupSortButton(v53);
    end;

    local v54 = findReverseSortButton(u11);

    if v54 then
        local u55 = v54:FindFirstChildOfClass("ImageLabel");
        v54.Selectable = true;
        v54.Activated:Connect(function() -- Line: 282
            -- upvalues: u8 (ref), u55 (copy), u1 (ref), Router (ref)
            u8 = not u8;

            if u55 then
                u55.Rotation = u8 and 180 or 0;
            end;

            u1.PopulateItems();
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
    end;

    if SetupTopBar(u11) then
        ConnectStateListeners();

        if u12 then
            u12:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 315
                -- upvalues: u12 (ref), u10 (ref), u9 (ref), UseItemFrameLoadMoreItems (ref)
                if not u12 then
                    return;
                end;

                local v56 = u12.AbsoluteCanvasSize.Y - u12.AbsoluteSize.Y;

                if v56 > 0 and (u10 < #u9 and v56 - u12.CanvasPosition.Y < 200) then
                    UseItemFrameLoadMoreItems();
                end;
            end);
        end;

        u5 = true;

        return true;
    end;
end;

function u1.CreateItemTemplate(u57: any, u58: function) -- Line: 395
    -- upvalues: u12 (ref), Cases (copy), GetResolvedSkinInformation (copy), Rarities (copy), Skins (copy), ReplicatedStorage (copy), ApplyWearAndSerialBadges (copy), GetSkinDisplayName (copy), Router (copy), AnimateButton (copy)
    if not (u57 and u57._id) then
        return;
    end;

    if not u12 then
        return;
    end;

    local v59 = u57.Type == "Case";
    local v60 = v59 and Cases.GetCaseByName(u57.Skin) or GetResolvedSkinInformation(u57.Name, u57.Skin);

    if not v60 then
        return;
    end;

    local v61 = Rarities[v59 and v60.caseRarity or v60.rarity];
    local v62 = nil;

    if v59 then
        v62 = v60.imageAssetId or "";
    elseif u57.Type == "Charm" then
        local Pattern = u57.Pattern;

        if Pattern and v60.charmImages then
            for _, v in ipairs(v60.charmImages) do
                if v.pattern == Pattern then
                    v62 = v.assetId;
                    break;
                end;
            end;
        end;

        if not v62 then
            v62 = v60.imageAssetId or "";
        end;
    else
        v62 = Skins.GetWearImageForFloat(v60, u57.Float or 0.9999) or (v60.imageAssetId or "");
    end;

    local v63 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone();
    v63.ItemContent.Rarity.BackgroundColor3 = v61.Color;
    v63.Parent = u12;
    v63.ItemContent.Content.Icon.Image = v62;
    v63.Name = u57._id;
    ApplyWearAndSerialBadges(v63, u57, v60);
    local Charm = v63.ItemContent:FindFirstChild("Charm");

    if Charm and Charm:IsA("ImageLabel") then
        Charm.Visible = false;
        Charm.Image = "";
    end;

    local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(u57.Name, u57.NameTag);

    if u57.StatTrack then
        WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
    end;

    GetSkinDisplayName.ApplyNameLabel(v63.Bottom.Footer.WeaponName, WeaponDisplayName, u57.NameTag);
    v63.Bottom.Footer.SkinName.Text = v59 and v60.skin or u57.Skin;

    if u57.Type == "Charm" then
        v63.MouseButton2Click:Connect(function() -- Line: 461
            -- upvalues: Router (ref), u57 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Router.broadcastRouter("WeaponInspect", u57.Name, u57.Skin, u57.Float, u57.StatTrack, u57.NameTag, u57.Charm, u57.Stickers, u57.Type, u57.Pattern, u57._id, u57.Serial, u57.IsTradeable);
        end);
    end;

    v63.MouseButton1Click:Connect(function() -- Line: 481
        -- upvalues: Router (ref), u58 (copy), u57 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u58(u57);
    end);
    AnimateButton(v63);
end;

function u1.PopulateItems() -- Line: 491
    -- upvalues: u12 (ref), ClearFrame (copy), u10 (ref), u9 (ref), DataController (copy), LocalPlayer (copy), Grenades (copy), u4 (ref), u3 (ref), u7 (ref), u16 (ref), Sort (copy), u6 (ref), u8 (ref), CalculateGridRenderCount (copy), u1 (copy), OnItemSelected (copy)
    if not u12 then
        return;
    end;

    ClearFrame(u12, "Frame");
    u10 = 0;
    u9 = {};
    local v64 = DataController.Get(LocalPlayer, "Inventory");

    if not v64 or type(v64) ~= "table" then
        return;
    end;

    for _, v in ipairs(v64) do
        local v65;

        if v then
            v65 = Grenades[v.Name];
        else
            v65 = v;
        end;

        local v66;

        if v then
            v66 = v.Type == "Case";
        else
            v66 = v;
        end;

        if v and (v._id and v.Name) and (v66 or v.Skin) and not (v65 or v66) and (not (u4 and u3) or u4(v, u3)) then
            table.insert(u9, v);
        end;
    end;

    local SortComparisonFunction = Sort.GetSortComparisonFunction(u7 or u16 and u16.Button.Frame.TextLabel.Text or "Newest", LocalPlayer, function() -- Line: 530
        -- upvalues: u6 (ref)
        return u6;
    end);

    if SortComparisonFunction then
        if u8 then
            table.sort(u9, function(p67, p68) -- Line: 536
                -- upvalues: SortComparisonFunction (copy)
                local v69, v70 = SortComparisonFunction(p67, p68);

                if v70 then
                    return v69;
                end;

                return SortComparisonFunction(p68, p67);
            end);
        else
            table.sort(u9, SortComparisonFunction);
        end;
    end;

    local v71 = not (u12 and u12.Visible) and 50 or CalculateGridRenderCount(u12);
    local math_max_ret = math.max(v71, 50);
    local math_min_ret = math.min(math_max_ret, #u9);

    for i = 1, math_min_ret do
        local v72 = u9[i];
        local v73;

        if v72 then
            u1.CreateItemTemplate(v72, OnItemSelected);
            v73 = i;
        else
            v73 = i;
        end;
    end;

    u10 = math_min_ret;
end;

function u1.Show(p74, p75) -- Line: 565
    -- upvalues: EnsureInitialized (copy), u11 (ref), u3 (ref), u4 (ref), u13 (ref), u1 (copy)
    if not EnsureInitialized() then
        warn("[UseItemFrame] Failed to initialize");

        return;
    end;

    if not u11 then
        return;
    end;

    u3 = p74;
    u4 = p75;

    if u13 then
        local SourceItem = p74.SourceItem;

        if SourceItem then
            local v76 = (SourceItem.StatTrack and "KillTrak™ " or "") .. SourceItem.Name;

            if SourceItem.Skin then
                v76 = v76 .. " | " .. SourceItem.Skin;
            end;

            u13.Text = `Select an item to use with {v76}`;
        elseif p74.Title then
            u13.Text = p74.Title;
        else
            u13.Text = "Select an item";
        end;
    end;

    u1.PopulateItems();
    u11.Visible = true;
end;

function u1.Hide() -- Line: 601
    -- upvalues: u11 (ref), u3 (ref), u4 (ref)
    if u11 then
        u11.Visible = false;
    end;

    u3 = nil;
    u4 = nil;
end;

function u1.IsVisible() -- Line: 612
    -- upvalues: u11 (ref)
    return u11 and u11.Visible or false;
end;

function u1.Initialize(p77: any, p78: userdata) -- Line: 619
    -- upvalues: u15 (ref), u11 (ref), u12 (ref), u16 (ref), SetupSortButton (copy), findReverseSortButton (copy), u8 (ref), u1 (copy), Router (copy), SetupTopBar (copy), u10 (ref), u9 (ref), UseItemFrameLoadMoreItems (copy), u5 (ref)
    u15 = p77;
    u11 = p78;
    local Tabs = p78:FindFirstChild("Tabs");
    local v79 = Tabs and Tabs:FindFirstChild("Inventory");

    if v79 then
        u12 = v79:FindFirstChild("Container");
        u16 = v79:FindFirstChild("Sort");
    end;

    local v80 = u16 and u16:FindFirstChild("Button");

    if v80 then
        SetupSortButton(v80);
    end;

    local v81 = findReverseSortButton(p78);

    if v81 then
        local u82 = v81:FindFirstChildOfClass("ImageLabel");
        v81.Selectable = true;
        v81.Activated:Connect(function() -- Line: 282
            -- upvalues: u8 (ref), u82 (copy), u1 (ref), Router (ref)
            u8 = not u8;

            if u82 then
                u82.Rotation = u8 and 180 or 0;
            end;

            u1.PopulateItems();
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
    end;

    if not SetupTopBar(p78) then
        return;
    end;

    if u12 then
        u12:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 315
            -- upvalues: u12 (ref), u10 (ref), u9 (ref), UseItemFrameLoadMoreItems (ref)
            if not u12 then
                return;
            end;

            local v83 = u12.AbsoluteCanvasSize.Y - u12.AbsoluteSize.Y;

            if v83 > 0 and (u10 < #u9 and v83 - u12.CanvasPosition.Y < 200) then
                UseItemFrameLoadMoreItems();
            end;
        end);
    end;

    p78.Visible = false;
    u5 = true;
end;

function u1.Start() -- Line: 646
    -- upvalues: script_Actions (copy), ConnectStateListeners (copy)
    script_Actions.InitializeAll();
    ConnectStateListeners();
end;

Collections.ObserveAvailableCollections(function(p84) -- Line: 655
    -- upvalues: u6 (ref)
    u6 = p84;
end);

function u1.TriggerAction(p85: string, p86: any) -- Line: 659
    -- upvalues: script_Actions (copy), u1 (copy)
    local v87 = script_Actions.Get(p85);

    if v87 then
        u1.Show(v87.GetContext(p86), v87.GetFilter(p86));

        return;
    end;

    warn((`[UseItemFrame] Unknown action type: {p85}`));
end;

function u1.GetActions() -- Line: 669
    -- upvalues: script_Actions (copy)
    return script_Actions;
end;

return u1;