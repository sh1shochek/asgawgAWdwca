-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
require(ReplicatedStorage.Database.Custom.Types);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local ServerBrowser = require(ReplicatedStorage.Database.Components.ServerBrowser);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local SetTabSelected = require(ReplicatedStorage.Components.Common.InterfaceAnimations.SetTabSelected);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local script_ServerBrowser = require(script.ServerBrowser);
local u2 = { "Gamemodes", "ServerBrowser" };
local table_freeze_ret = table.freeze({
    Defusal = {
        BrowserGamemode = "casual",
        TeleportMode = "Defusal"
    },
    Competitive = {
        BrowserGamemode = "competitive",
        TeleportMode = "UnrankedComp"
    },
    Deathmatch = {
        BrowserGamemode = "deathmatch",
        TeleportMode = "Deathmatch"
    },
    Trading = {
        BrowserGamemode = "trading",
        TeleportMode = "Trading"
    }
});
local table_freeze_ret2 = table.freeze({
    Casual = "Defusal",
    Competitive = "Competitive",
    Deathmatch = "Deathmatch"
});
local table_freeze_ret3 = table.freeze({
    ["Bomb Defusal"] = "Defusal",
    ["Hostage Rescue"] = "Defusal",
    Deathmatch = "Deathmatch"
});
local table_freeze_ret4 = table.freeze({
    [Constants.GAMEMODE_PLACE_IDS.Casual] = "Defusal",
    [Constants.GAMEMODE_PLACE_IDS.Competitive] = "Competitive",
    [Constants.GAMEMODE_PLACE_IDS.Deathmatch] = "Deathmatch",
    [Constants.GAMEMODE_PLACE_IDS.Trading] = "Trading"
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
    maps = { "Oasis", "Reactor", "Hellena" }
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

local function CommaNumber(p16: number) -- Line: 114
    local math_floor_ret = math.floor(p16);
    local math_max_ret = math.max(math_floor_ret, 0);

    return tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function GetCurrentCardName() -- Line: 122
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

local function RefreshCurrentCard() -- Line: 139
    -- upvalues: GetCurrentCardName (copy), u8 (copy)
    local v17 = GetCurrentCardName();

    for i, v in u8 do
        if v.Badge then
            v.Badge.Visible = i == v17;
        end;
    end;
end;

local function RefreshPlayerCounts() -- Line: 151
    -- upvalues: u8 (copy), table_freeze_ret (copy), u12 (ref)
    for i, v in u8 do
        local v18 = table_freeze_ret[i];

        if v18 and u12[v18.BrowserGamemode] then
            local PlayerCount = v.PlayerCount;
            local math_floor_ret = math.floor(u12[v18.BrowserGamemode] or 0);
            local math_max_ret = math.max(math_floor_ret, 0);
            PlayerCount.Text = `{tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")} Online`;
        end;
    end;
end;

local function TrackOnlineTag(p19: userdata) -- Line: 165
    -- upvalues: u10 (copy)
    if p19:IsA("ImageLabel") and not table.find(u10, p19) then
        table.insert(u10, p19);
    end;
end;

local function UntrackOnlineTag(p20: userdata) -- Line: 173
    -- upvalues: u10 (copy)
    local table_find_ret = table.find(u10, p20);

    if table_find_ret then
        table.remove(u10, table_find_ret);
    end;
end;

local function StepOnlineBlink(p21: number) -- Line: 182
    -- upvalues: u5 (ref), u10 (copy)
    u5 = u5 + p21;
    local v22 = math.sin(u5 * 3.141592653589793) * 0.25 + 0.25;

    for _, v in u10 do
        v.ImageTransparency = v22;
    end;
end;

local function SetOnlineBlinkEnabled(p23: boolean) -- Line: 193
    -- upvalues: u13 (ref), RunServiceController (copy), StepOnlineBlink (copy)
    if p23 == (u13 ~= nil) then
        return;
    end;

    if p23 then
        u13 = RunServiceController.BindToHeartbeat("UI.Gamemodes.OnlineBlink", StepOnlineBlink);

        return;
    end;

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;
end;

local function SyncCategorySelection(p24: string, p25: string, p26: boolean) -- Line: 208
    -- upvalues: u11 (copy)
    local v27 = u11[p24];

    if not v27 then
        return;
    end;

    local table_find_ret = table.find(v27, p25);

    if table_find_ret and not p26 then
        table.remove(v27, table_find_ret);

        return;
    end;

    if not table_find_ret and p26 then
        table.insert(v27, p25);
    end;
end;

local function FiltersChanged() -- Line: 225
    -- upvalues: script_ServerBrowser (copy), u11 (copy), u7 (ref), Remotes (copy)
    script_ServerBrowser.SetCategoryFilters(u11);
    u7 = u7 + 1;
    local u28 = u7;
    task.delay(1, function() -- Line: 230
        -- upvalues: u28 (copy), u7 (ref), Remotes (ref), u11 (ref)
        if u28 ~= u7 then
            return;
        end;

        Remotes.Modes.FetchServers.Send(u11);
    end);
end;

local function VisibilityUpdated() -- Line: 241
    -- upvalues: u14 (ref), u13 (ref), RunServiceController (copy), StepOnlineBlink (copy), GetCurrentCardName (copy), u8 (copy), Remotes (copy), u11 (copy), RefreshPlayerCounts (copy), script_ServerBrowser (copy), u3 (ref)
    local v29 = u14.Visible == true;

    if v29 ~= (u13 ~= nil) then
        if v29 then
            u13 = RunServiceController.BindToHeartbeat("UI.Gamemodes.OnlineBlink", StepOnlineBlink);
        elseif u13 then
            u13:Disconnect();
            u13 = nil;
        end;
    end;

    if v29 then
        local v30 = GetCurrentCardName();

        for i, v in u8 do
            if v.Badge then
                v.Badge.Visible = i == v30;
            end;
        end;

        Remotes.Modes.FetchServers.Send(u11);
        Remotes.Modes.FetchPlayerCounts.Send();
        RefreshPlayerCounts();
    end;

    if v29 then
        v29 = u3 == "ServerBrowser";
    end;

    script_ServerBrowser.SetActive(v29);
end;

function u1.InitializeGamemodeTemplate(u31: userdata) -- Line: 257
    -- upvalues: table_freeze_ret (copy), u8 (copy), ActivateButton (copy), GetCurrentCardName (copy), u15 (ref), u14 (ref)
    local u32 = table_freeze_ret[u31.Name];

    if not u32 then
        warn((`[Gamemodes] Unknown gamemode card "{u31.Name}"`));

        return;
    end;

    local ActivePlayerCount = u31:FindFirstChild("ActivePlayerCount");
    local YouAreHere = u31:FindFirstChild("YouAreHere");
    local Name = u31.Name;
    local v33 = {
        Card = u31
    };

    if not (YouAreHere and (YouAreHere:IsA("GuiObject") and YouAreHere)) then
        YouAreHere = nil;
    end;

    v33.Badge = YouAreHere;

    if not (ActivePlayerCount and (ActivePlayerCount:IsA("TextLabel") and ActivePlayerCount)) then
        ActivePlayerCount = nil;
    end;

    v33.PlayerCount = ActivePlayerCount;
    u8[Name] = v33;
    ActivateButton(u31);
    u31.MouseButton1Click:Connect(function() -- Line: 275
        -- upvalues: GetCurrentCardName (ref), u31 (copy), u15 (ref), u32 (copy), u14 (ref)
        if GetCurrentCardName() == u31.Name then
            return;
        end;

        u15 = u32;
        u14.Gamemodes.Prompt.Visible = true;
        u14.Gamemodes.Prompt.TextLabel.Text = `Are you sure you want to join {u32.BrowserGamemode}?`;
    end);
end;

function u1.OpenGamemodesFrame(p34: string) -- Line: 289
    -- upvalues: u3 (ref), u14 (ref), u9 (copy), SetTabSelected (copy), script_ServerBrowser (copy)
    u3 = p34;

    for _, child in u14:GetChildren() do
        if child:GetAttribute("ButtonFrame") then
            child.Visible = child.Name == p34;
        end;
    end;

    for i, v in u9 do
        SetTabSelected(v, i == p34);
    end;

    local v35;

    if u14.Visible == true then
        v35 = p34 == "ServerBrowser";
    else
        v35 = false;
    end;

    script_ServerBrowser.SetActive(v35);
end;

function u1.Initialize(p36, p37) -- Line: 307
    -- upvalues: u14 (ref), u1 (copy), u9 (copy), ActivateButton (copy), MenuState (copy), u2 (copy), u3 (ref), GuiService (copy), u15 (ref), u4 (ref), Remotes (copy), script_ServerBrowser (copy), u6 (ref), u11 (copy), u7 (ref), u12 (ref), RefreshPlayerCounts (copy)
    u14 = p37;

    for _, child in u14.Gamemodes:GetChildren() do
        if child:IsA("GuiObject") then
            for _, child2 in child:GetChildren() do
                if child2:IsA("ImageButton") and child2:FindFirstChild("ActivePlayerCount") then
                    u1.InitializeGamemodeTemplate(child2);
                end;
            end;
        end;
    end;

    for _, child in u14.Buttons:GetChildren() do
        if child:IsA("ImageButton") then
            u9[child.Name] = child;
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 326
                -- upvalues: u1 (ref), child (copy)
                u1.OpenGamemodesFrame(child.Name);
            end);
        end;
    end;

    MenuState.RegisterBumperOverride(u14, function(p38: boolean) -- Line: 334
        -- upvalues: MenuState (ref), u14 (ref), u2 (ref), u3 (ref), u1 (ref), GuiService (ref)
        local NextBumperTab = MenuState.GetNextBumperTab(u14.Buttons, u2, u3, p38);

        if NextBumperTab and NextBumperTab ~= u3 then
            u1.OpenGamemodesFrame(NextBumperTab);
        end;

        local v39 = u14.Buttons:FindFirstChild(u3);

        if v39 and v39:IsA("GuiObject") then
            GuiService.SelectedObject = v39;
        end;

        return true;
    end, u14, u14.Buttons);
    ActivateButton(u14.Gamemodes.Prompt.Buttons.Buttons.Yes);
    ActivateButton(u14.Gamemodes.Prompt.Buttons.Buttons.No);
    u14.Gamemodes.Prompt.Buttons.Buttons.Yes.MouseButton1Click:Connect(function() -- Line: 351
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
    u14.Gamemodes.Prompt.Buttons.Buttons.No.MouseButton1Click:Connect(function() -- Line: 364
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
        Search.MouseButton1Click:Connect(function() -- Line: 376
            -- upvalues: u6 (ref), Search (copy), Remotes (ref), u11 (ref), Title (copy)
            if not u6 then
                u6 = true;
                Search.Active = false;
                Remotes.Modes.FetchServers.Send(u11);

                for i = 10, 0, -1 do
                    if Title and Title:IsA("TextLabel") then
                        Title.Text = `Search ({i})`;
                    end;

                    local v40;

                    if i > 0 then
                        task.wait(1);
                        v40 = i;
                    else
                        v40 = i;
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

    u14.ServerBrowser.Main.Frame.Top.Filters.MouseButton1Click:Connect(function() -- Line: 400
        -- upvalues: u14 (ref)
        u14.ServerBrowser.Main.Frame.Top.Filters.Categories.Visible = not u14.ServerBrowser.Main.Frame.Top.Filters.Categories.Visible;
    end);

    for _, child in u14.ServerBrowser.Main.Frame.Top.Filters.Categories.Maps.List:GetChildren() do
        if child:IsA("Frame") then
            local u41 = child;

            for _, child2 in child:GetChildren() do
                if child2:IsA("Frame") then
                    ActivateButton(child2.Button);
                    local Name = child2.Name;
                    local Visible = child2.Button.ImageLabel.Visible;
                    local v42 = u11[u41.Name];

                    if v42 then
                        local table_find_ret = table.find(v42, Name);

                        if table_find_ret and not Visible then
                            table.remove(v42, table_find_ret);
                        elseif not table_find_ret and Visible then
                            table.insert(v42, Name);
                        end;
                    end;

                    child2.Button.MouseButton1Click:Connect(function() -- Line: 414
                        -- upvalues: child2 (copy), u41 (copy), u11 (ref), script_ServerBrowser (ref), u7 (ref), Remotes (ref)
                        child2.Button.ImageLabel.Visible = not child2.Button.ImageLabel.Visible;
                        local Name2 = child2.Name;
                        local Visible2 = child2.Button.ImageLabel.Visible;
                        local v43 = u11[u41.Name];

                        if v43 then
                            local table_find_ret = table.find(v43, Name2);

                            if table_find_ret and not Visible2 then
                                table.remove(v43, table_find_ret);
                            elseif not table_find_ret and Visible2 then
                                table.insert(v43, Name2);
                            end;
                        end;

                        script_ServerBrowser.SetCategoryFilters(u11);
                        u7 = u7 + 1;
                        local u44 = u7;
                        task.delay(1, function() -- Line: 230
                            -- upvalues: u44 (copy), u7 (ref), Remotes (ref), u11 (ref)
                            if u44 ~= u7 then
                                return;
                            end;

                            Remotes.Modes.FetchServers.Send(u11);
                        end);
                    end);
                end;
            end;

            u41.Parent[`{u41.Name}Header`].MouseButton1Click:Connect(function() -- Line: 422
                -- upvalues: u41 (copy)
                u41.Parent[`{u41.Name}Header`].Icon.Rotation = u41.Visible and 180 or 0;
                u41.Visible = not u41.Visible;
            end);
        end;
    end;

    script_ServerBrowser.SetCategoryFilters(u11);
    Remotes.Modes.SendPlayerCounts.Listen(function(p45) -- Line: 431
        -- upvalues: u12 (ref), RefreshPlayerCounts (ref)
        if p45 then
            u12 = p45;
            RefreshPlayerCounts();
        end;
    end);
end;

function u1.Start() -- Line: 441
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
    local v46 = Attribute and Attribute:lower() or "casual";
    table.insert(gameModes, v46);
    script_ServerBrowser.SetCategoryFilters(u11);
    u7 = u7 + 1;
    local u47 = u7;
    task.delay(1, function() -- Line: 230
        -- upvalues: u47 (copy), u7 (ref), Remotes (ref), u11 (ref)
        if u47 ~= u7 then
            return;
        end;

        Remotes.Modes.FetchServers.Send(u11);
    end);
    u14:GetPropertyChangedSignal("Visible"):Connect(VisibilityUpdated);
    local v48 = GetCurrentCardName();

    for i, v in u8 do
        if v.Badge then
            v.Badge.Visible = i == v48;
        end;
    end;

    RefreshPlayerCounts();
    VisibilityUpdated();
    script_ServerBrowser.Start();
end;

return u1;