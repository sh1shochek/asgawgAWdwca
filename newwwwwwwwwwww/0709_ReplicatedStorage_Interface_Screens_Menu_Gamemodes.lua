-- Gamemodes (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Menu.Gamemodes

-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
require(ReplicatedStorage.Database.Custom.Types);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local ServerBrowser = require(ReplicatedStorage.Database.Components.ServerBrowser);
local GetBrowserMaps = require(ReplicatedStorage.Database.Components.Common.GetBrowserMaps);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local SetTabSelected = require(ReplicatedStorage.Components.Common.InterfaceAnimations.SetTabSelected);
local AnimateZombiesPromotion = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateZombiesPromotion);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local script_ServerBrowser = require(script.ServerBrowser);
local u2 = { "Gamemodes", "ServerBrowser" };
local table_freeze_ret = table.freeze({
    Defusal = {
        BrowserGamemode = "casual",
        PromptName = "casual",
        TeleportMode = "Defusal"
    },
    Competitive = {
        BrowserGamemode = "competitive",
        PromptName = "competitive",
        TeleportMode = "UnrankedComp"
    },
    Deathmatch = {
        BrowserGamemode = "deathmatch",
        PromptName = "deathmatch",
        TeleportMode = "Deathmatch"
    },
    Trading = {
        BrowserGamemode = "trading",
        PromptName = "trading",
        TeleportMode = "Trading"
    },
    Zombies = {
        PromptName = "zombies",
        TeleportMode = "Survival"
    }
});
local table_freeze_ret2 = table.freeze({
    Casual = "Defusal",
    Competitive = "Competitive",
    Deathmatch = "Deathmatch",
    Survival = "Zombies"
});
local table_freeze_ret3 = table.freeze({
    ["Bomb Defusal"] = "Defusal",
    ["Hostage Rescue"] = "Defusal",
    Deathmatch = "Deathmatch",
    ["Zombie Survival"] = "Zombies"
});
local table_freeze_ret4 = table.freeze({
    [Constants.GAMEMODE_PLACE_IDS.Casual] = "Defusal",
    [Constants.GAMEMODE_PLACE_IDS.Competitive] = "Competitive",
    [Constants.GAMEMODE_PLACE_IDS.Deathmatch] = "Deathmatch",
    [Constants.GAMEMODE_PLACE_IDS.Trading] = "Trading",
    [Constants.GAMEMODE_PLACE_IDS.Survival] = "Zombies"
});
local u3 = "Gamemodes";
local u4 = 0;
local u5 = 0;
local u6 = false;
local u7 = 0;
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {
    gameModes = {},
    regions = { "North America", "Europe", "Asia", "South America", "Oceania" },
    maps = GetBrowserMaps()
};
local u12 = {
    competitive = 0,
    deathmatch = 0,
    trading = 0,
    casual = 0
};
local u13 = nil;
local u14 = nil;
local u15 = nil;

local function CommaNumber(p16: number) -- Line: 126
    local math_floor_ret = math.floor(p16);
    local math_max_ret = math.max(math_floor_ret, 0);

    return tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function GetCurrentCardName() -- Line: 134
    -- upvalues: table_freeze_ret2 (copy), table_freeze_ret3 (copy), table_freeze_ret4 (copy)
    local Attribute = workspace:GetAttribute("ServerGamemode");

    if typeof(Attribute) == "string" and table_freeze_ret2[Attribute] then
        return table_freeze_ret2[Attribute];
    end;

    local Attribute2 = workspace:GetAttribute("Gamemode");

    if typeof(Attribute2) == "string" and table_freeze_ret3[Attribute2] then
        return table_freeze_ret3[Attribute2];
    end;

    return table_freeze_ret4[game.PlaceId];
end;

local function RefreshCurrentCard() -- Line: 151
    -- upvalues: GetCurrentCardName (copy), u8 (copy)
    local v17 = GetCurrentCardName();

    for i, v in u8 do
        if v.Badge then
            v.Badge.Visible = i == v17;
        end;
    end;
end;

local function RefreshPlayerCounts() -- Line: 163
    -- upvalues: u8 (copy), table_freeze_ret (copy), u12 (ref)
    for i, v in u8 do
        local v18 = table_freeze_ret[i];
        local v19;

        if v18 then
            v19 = v18.BrowserGamemode;
        else
            v19 = nil;
        end;

        if v.PlayerCount and (v19 and u12[v19]) then
            local PlayerCount = v.PlayerCount;
            local math_floor_ret = math.floor(u12[v19] or 0);
            local math_max_ret = math.max(math_floor_ret, 0);
            PlayerCount.Text = `{tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")} Online`;
        end;
    end;
end;

local function TrackOnlineTag(p20: userdata) -- Line: 178
    -- upvalues: u10 (copy)
    if p20:IsA("ImageLabel") and not table.find(u10, p20) then
        table.insert(u10, p20);
    end;
end;

local function UntrackOnlineTag(p21: userdata) -- Line: 186
    -- upvalues: u10 (copy)
    local table_find_ret = table.find(u10, p21);

    if table_find_ret then
        table.remove(u10, table_find_ret);
    end;
end;

local function StepOnlineBlink(p22: number) -- Line: 195
    -- upvalues: u5 (ref), u10 (copy)
    u5 = u5 + p22;
    local v23 = math.sin(u5 * 3.141592653589793) * 0.25 + 0.25;

    for _, v in u10 do
        v.ImageTransparency = v23;
    end;
end;

local function SetOnlineBlinkEnabled(p24: boolean) -- Line: 206
    -- upvalues: u13 (ref), RunServiceController (copy), StepOnlineBlink (copy)
    if p24 == (u13 ~= nil) then
        return;
    end;

    if p24 then
        u13 = RunServiceController.BindToHeartbeat("UI.Gamemodes.OnlineBlink", StepOnlineBlink);

        return;
    end;

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;
end;

local function SyncCategorySelection(p25: string, p26: string, p27: boolean) -- Line: 221
    -- upvalues: u11 (copy)
    local v28 = u11[p25];

    if not v28 then
        return;
    end;

    local table_find_ret = table.find(v28, p26);

    if table_find_ret and not p27 then
        table.remove(v28, table_find_ret);

        return;
    end;

    if not table_find_ret and p27 then
        table.insert(v28, p26);
    end;
end;

local function BuildMapCheckboxes(p29: userdata) -- Line: 238
    -- upvalues: u11 (copy)
    local v30 = nil;

    for _, child in p29:GetChildren() do
        if child:IsA("Frame") then
            child.Parent = nil;
            v30 = v30 or child;
        end;
    end;

    if not v30 then
        warn("[Gamemodes] No map checkbox template in the filters, map filtering is disabled");

        return;
    end;

    for i, v in u11.maps do
        local v31 = v30:Clone();
        v31.Name = v;
        v31.LayoutOrder = i;
        v31.Info.Text = v;
        v31.Button.ImageLabel.Visible = true;
        v31.Parent = p29;
    end;

    v30:Destroy();
end;

local function FitCategoryRows(p32: userdata) -- Line: 265
    local function countRows(p33: userdata) -- Line: 266
        local v34 = 0;

        for _, child in p33:GetChildren() do
            if child:IsA("Frame") then
                v34 = v34 + 1;
            end;
        end;

        return v34;
    end;

    local regions = p32:FindFirstChild("regions");
    local v35 = countRows(regions);

    if v35 == 0 then
        return;
    end;

    local v36 = regions.Size.Y.Scale / v35;
    local v37 = 0;
    local v38 = 0;

    for _, child in p32:GetChildren() do
        if child:IsA("GuiObject") then
            v37 = v37 + child.Size.Y.Scale;

            if child:IsA("Frame") then
                child.Size = UDim2.new(child.Size.X, UDim.new(countRows(child) * v36, 0));
            end;

            v38 = v38 + child.Size.Y.Scale;
        end;
    end;

    local v39 = v38 / v37;
    local Parent = p32.Parent;
    Parent.Size = UDim2.new(Parent.Size.X, UDim.new(Parent.Size.Y.Scale * v39, Parent.Size.Y.Offset));

    for _, child in p32:GetChildren() do
        if child:IsA("GuiObject") then
            child.Size = UDim2.new(child.Size.X, UDim.new(child.Size.Y.Scale / v39, child.Size.Y.Offset));
        end;
    end;
end;

local function FiltersChanged() -- Line: 308
    -- upvalues: script_ServerBrowser (copy), u11 (copy), u7 (ref), Remotes (copy)
    script_ServerBrowser.SetCategoryFilters(u11);
    u7 = u7 + 1;
    local u40 = u7;
    task.delay(1, function() -- Line: 313
        -- upvalues: u40 (copy), u7 (ref), Remotes (ref), u11 (ref)
        if u40 ~= u7 then
            return;
        end;

        Remotes.Modes.FetchServers.Send(u11);
    end);
end;

local function VisibilityUpdated() -- Line: 324
    -- upvalues: u14 (ref), u13 (ref), RunServiceController (copy), StepOnlineBlink (copy), GetCurrentCardName (copy), u8 (copy), Remotes (copy), u11 (copy), RefreshPlayerCounts (copy), script_ServerBrowser (copy), u3 (ref)
    local v41 = u14.Visible == true;

    if v41 ~= (u13 ~= nil) then
        if v41 then
            u13 = RunServiceController.BindToHeartbeat("UI.Gamemodes.OnlineBlink", StepOnlineBlink);
        elseif u13 then
            u13:Disconnect();
            u13 = nil;
        end;
    end;

    if v41 then
        local v42 = GetCurrentCardName();

        for i, v in u8 do
            if v.Badge then
                v.Badge.Visible = i == v42;
            end;
        end;

        Remotes.Modes.FetchServers.Send(u11);
        Remotes.Modes.FetchPlayerCounts.Send();
        RefreshPlayerCounts();
    end;

    if v41 then
        v41 = u3 == "ServerBrowser";
    end;

    script_ServerBrowser.SetActive(v41);
end;

function u1.InitializeGamemodeTemplate(u43: userdata, p44: boolean?) -- Line: 340
    -- upvalues: table_freeze_ret (copy), u8 (copy), GetCurrentCardName (copy), u15 (ref), u14 (ref), AnimateZombiesPromotion (copy), ActivateButton (copy)
    local u45 = table_freeze_ret[u43.Name];

    if not u45 then
        warn((`[Gamemodes] Unknown gamemode card "{u43.Name}"`));

        return;
    end;

    local ActivePlayerCount = u43:FindFirstChild("ActivePlayerCount");
    local YouAreHere = u43:FindFirstChild("YouAreHere");
    local Name = u43.Name;
    local v46 = {
        Card = u43
    };

    if not (YouAreHere and (YouAreHere:IsA("GuiObject") and YouAreHere)) then
        YouAreHere = nil;
    end;

    v46.Badge = YouAreHere;

    if not (ActivePlayerCount and (ActivePlayerCount:IsA("TextLabel") and ActivePlayerCount)) then
        ActivePlayerCount = nil;
    end;

    v46.PlayerCount = ActivePlayerCount;
    u8[Name] = v46;

    local function promptJoin() -- Line: 357
        -- upvalues: GetCurrentCardName (ref), u43 (copy), u15 (ref), u45 (copy), u14 (ref)
        if GetCurrentCardName() == u43.Name then
            return;
        end;

        u15 = u45;
        u14.Gamemodes.Prompt.Visible = true;
        u14.Gamemodes.Prompt.TextLabel.Text = `Are you sure you want to join {u45.PromptName}?`;
    end;

    if p44 then
        u43.Selectable = false;
        AnimateZombiesPromotion(u43);
    else
        u43.MouseButton1Click:Connect(promptJoin);
        ActivateButton(u43);
    end;

    local Join = u43:FindFirstChild("Join");

    if Join and Join:IsA("GuiButton") then
        Join.MouseButton1Click:Connect(promptJoin);
        ActivateButton(Join);
    end;
end;

function u1.OpenGamemodesFrame(p47: string) -- Line: 387
    -- upvalues: u3 (ref), u14 (ref), u9 (copy), SetTabSelected (copy), script_ServerBrowser (copy)
    u3 = p47;
    u14.ServerBrowser.Main.Frame.Top.Filters.Categories.Visible = false;

    for _, child in u14:GetChildren() do
        if child:GetAttribute("ButtonFrame") then
            child.Visible = child.Name == p47;
        end;
    end;

    for i, v in u9 do
        SetTabSelected(v, i == p47);
    end;

    local v48;

    if u14.Visible == true then
        v48 = p47 == "ServerBrowser";
    else
        v48 = false;
    end;

    script_ServerBrowser.SetActive(v48);
end;

function u1.Initialize(p49, p50) -- Line: 407
    -- upvalues: u14 (ref), table_freeze_ret (copy), u1 (copy), u9 (copy), ActivateButton (copy), MenuState (copy), u2 (copy), u3 (ref), GuiService (copy), u15 (ref), u4 (ref), Remotes (copy), script_ServerBrowser (copy), u6 (ref), u11 (copy), GamepadNavigation (copy), CloseButtonRegistry (copy), BuildMapCheckboxes (copy), FitCategoryRows (copy), u7 (ref), u12 (ref), RefreshPlayerCounts (copy)
    u14 = p50;

    for _, child in u14.Gamemodes:GetChildren() do
        if child:IsA("GuiObject") then
            if child:IsA("ImageButton") and table_freeze_ret[child.Name] then
                u1.InitializeGamemodeTemplate(child, true);
            else
                for _, child2 in child:GetChildren() do
                    if child2:IsA("ImageButton") and child2:FindFirstChild("ActivePlayerCount") then
                        u1.InitializeGamemodeTemplate(child2);
                    end;
                end;
            end;
        end;
    end;

    for _, child in u14.Buttons:GetChildren() do
        if child:IsA("ImageButton") then
            u9[child.Name] = child;
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 431
                -- upvalues: u1 (ref), child (copy)
                u1.OpenGamemodesFrame(child.Name);
            end);
        end;
    end;

    MenuState.RegisterBumperOverride(u14, function(p51: boolean) -- Line: 439
        -- upvalues: MenuState (ref), u14 (ref), u2 (ref), u3 (ref), u1 (ref), GuiService (ref)
        local NextBumperTab = MenuState.GetNextBumperTab(u14.Buttons, u2, u3, p51);

        if NextBumperTab and NextBumperTab ~= u3 then
            u1.OpenGamemodesFrame(NextBumperTab);
        end;

        local v52 = u14.Buttons:FindFirstChild(u3);

        if v52 and v52:IsA("GuiObject") then
            GuiService.SelectedObject = v52;
        end;

        return true;
    end, u14, u14.Buttons);
    ActivateButton(u14.Gamemodes.Prompt.Buttons.Buttons.Yes);
    ActivateButton(u14.Gamemodes.Prompt.Buttons.Buttons.No);
    u14.Gamemodes.Prompt.Buttons.Buttons.Yes.MouseButton1Click:Connect(function() -- Line: 456
        -- upvalues: ActivateButton (ref), u14 (ref), u15 (ref), u4 (ref), Remotes (ref)
        ActivateButton(u14.Gamemodes.Prompt.Buttons.Buttons.Yes);

        if not u15 then
            return;
        end;

        local os_clock_ret = os.clock();

        if os_clock_ret - u4 < 0.75 then
            return;
        end;

        u4 = os_clock_ret;
        Remotes.Modes.SelectGamemode.Send(u15.TeleportMode);
    end);
    u14.Gamemodes.Prompt.Buttons.Buttons.No.MouseButton1Click:Connect(function() -- Line: 469
        -- upvalues: u15 (ref), u14 (ref)
        u15 = nil;
        u14.Gamemodes.Prompt.Visible = false;
    end);
    script_ServerBrowser.Initialize(u14.ServerBrowser);
    u1.OpenGamemodesFrame("Gamemodes");
    local Search = u14.ServerBrowser.Main.Frame.Top:FindFirstChild("Search");

    if Search and Search:IsA("GuiButton") then
        local Title = Search:FindFirstChild("Title");
        ActivateButton(Search);
        Search.MouseButton1Click:Connect(function() -- Line: 481
            -- upvalues: u6 (ref), Search (copy), Remotes (ref), u11 (ref), Title (copy)
            if not u6 then
                u6 = true;
                Search.Active = false;
                Remotes.Modes.FetchServers.Send(u11);

                for i = 10, 0, -1 do
                    if Title and Title:IsA("TextLabel") then
                        Title.Text = `Search ({i})`;
                    end;

                    local v53;

                    if i > 0 then
                        task.wait(1);
                        v53 = i;
                    else
                        v53 = i;
                    end;
                end;

                if Title and Title:IsA("TextLabel") then
                    Title.Text = "Search";
                end;

                Search.Active = true;
                u6 = false;
            end;
        end);
    end;

    local Filters = u14.ServerBrowser.Main.Frame.Top.Filters;
    local Categories = Filters.Categories;
    Filters.MouseButton1Click:Connect(function() -- Line: 507
        -- upvalues: Categories (copy)
        Categories.Visible = not Categories.Visible;
    end);
    Categories.Active = true;
    Categories.SelectionGroup = true;
    Categories:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 515
        -- upvalues: Categories (copy), GamepadNavigation (ref), GuiService (ref), Filters (copy)
        if Categories.Visible then
            task.defer(function() -- Line: 518
                -- upvalues: Categories (ref), GamepadNavigation (ref)
                if Categories.Visible then
                    GamepadNavigation.Focus(Categories);
                end;
            end);

            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject == nil or SelectedObject:IsDescendantOf(Categories) then
            GamepadNavigation.Focus(Filters);
        end;
    end);
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 532
        -- upvalues: GuiService (ref), Categories (copy), Filters (copy)
        local SelectedObject = GuiService.SelectedObject;

        if Categories.Visible and (SelectedObject and (SelectedObject ~= Filters and not SelectedObject:IsDescendantOf(Categories))) then
            Categories.Visible = false;
        end;
    end);
    CloseButtonRegistry.Add(Categories, nil, function() -- Line: 543
        -- upvalues: Categories (copy)
        Categories.Visible = false;
    end);
    BuildMapCheckboxes(Categories.Maps.List.maps);
    FitCategoryRows(Categories.Maps.List);

    for _, child in Categories.Maps.List:GetChildren() do
        if child:IsA("Frame") then
            local u54 = child;

            for _, child2 in child:GetChildren() do
                if child2:IsA("Frame") then
                    ActivateButton(child2.Button);
                    local Name = child2.Name;
                    local Visible = child2.Button.ImageLabel.Visible;
                    local v55 = u11[u54.Name];

                    if v55 then
                        local table_find_ret = table.find(v55, Name);

                        if table_find_ret and not Visible then
                            table.remove(v55, table_find_ret);
                        elseif not table_find_ret and Visible then
                            table.insert(v55, Name);
                        end;
                    end;

                    child2.Button.MouseButton1Click:Connect(function() -- Line: 559
                        -- upvalues: child2 (copy), u54 (copy), u11 (ref), script_ServerBrowser (ref), u7 (ref), Remotes (ref)
                        child2.Button.ImageLabel.Visible = not child2.Button.ImageLabel.Visible;
                        local Name2 = child2.Name;
                        local Visible2 = child2.Button.ImageLabel.Visible;
                        local v56 = u11[u54.Name];

                        if v56 then
                            local table_find_ret = table.find(v56, Name2);

                            if table_find_ret and not Visible2 then
                                table.remove(v56, table_find_ret);
                            elseif not table_find_ret and Visible2 then
                                table.insert(v56, Name2);
                            end;
                        end;

                        script_ServerBrowser.SetCategoryFilters(u11);
                        u7 = u7 + 1;
                        local u57 = u7;
                        task.delay(1, function() -- Line: 313
                            -- upvalues: u57 (copy), u7 (ref), Remotes (ref), u11 (ref)
                            if u57 ~= u7 then
                                return;
                            end;

                            Remotes.Modes.FetchServers.Send(u11);
                        end);
                    end);
                end;
            end;

            u54.Parent[`{u54.Name}Header`].MouseButton1Click:Connect(function() -- Line: 567
                -- upvalues: u54 (copy)
                u54.Parent[`{u54.Name}Header`].Icon.Rotation = u54.Visible and 180 or 0;
                u54.Visible = not u54.Visible;
            end);
        end;
    end;

    script_ServerBrowser.SetCategoryFilters(u11);
    Remotes.Modes.SendPlayerCounts.Listen(function(p58) -- Line: 576
        -- upvalues: u12 (ref), RefreshPlayerCounts (ref)
        if p58 then
            u12 = p58;
            RefreshPlayerCounts();
        end;
    end);
end;

function u1.Start() -- Line: 586
    -- upvalues: CollectionService (copy), u10 (copy), TrackOnlineTag (copy), UntrackOnlineTag (copy), RefreshCurrentCard (copy), ServerBrowser (copy), RefreshPlayerCounts (copy), u11 (copy), script_ServerBrowser (copy), u7 (ref), Remotes (copy), u14 (ref), VisibilityUpdated (copy), GetCurrentCardName (copy), u8 (copy)
    for _, v in CollectionService:GetTagged("Gamemodes_OnlineTag") do
        if v:IsA("ImageLabel") and not table.find(u10, v) then
            table.insert(u10, v);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("Gamemodes_OnlineTag"):Connect(TrackOnlineTag);
    CollectionService:GetInstanceRemovedSignal("Gamemodes_OnlineTag"):Connect(UntrackOnlineTag);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(RefreshCurrentCard);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(RefreshCurrentCard);
    ServerBrowser.OnServerBrowserUpdated:Connect(RefreshPlayerCounts);
    local Attribute = workspace:GetAttribute("ServerGamemode");
    local gameModes = u11.gameModes;
    local v59 = Attribute and Attribute:lower() or "casual";
    table.insert(gameModes, v59);
    script_ServerBrowser.SetCategoryFilters(u11);
    u7 = u7 + 1;
    local u60 = u7;
    task.delay(1, function() -- Line: 313
        -- upvalues: u60 (copy), u7 (ref), Remotes (ref), u11 (ref)
        if u60 ~= u7 then
            return;
        end;

        Remotes.Modes.FetchServers.Send(u11);
    end);
    u14:GetPropertyChangedSignal("Visible"):Connect(VisibilityUpdated);
    local v61 = GetCurrentCardName();

    for i, v in u8 do
        if v.Badge then
            v.Badge.Visible = i == v61;
        end;
    end;

    RefreshPlayerCounts();
    VisibilityUpdated();
    script_ServerBrowser.Start();
end;

return u1;