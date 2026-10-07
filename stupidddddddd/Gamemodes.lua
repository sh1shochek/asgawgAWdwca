-- ReplicatedStorage.Interface.Screens.Menu.Gamemodes
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Gamemodes
-- Decompile time: 9.44 ms

local u0 = {}
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
require(ReplicatedStorage.Database.Custom.Types)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local ServerBrowser = require(ReplicatedStorage.Database.Components.ServerBrowser)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local SetTabSelected = require(ReplicatedStorage.Components.Common.InterfaceAnimations.SetTabSelected)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local ServerBrowser_2 = require(script.ServerBrowser)
local u60 = {"Gamemodes", "ServerBrowser"}
local u69 = table.freeze({
    Defusal = {BrowserGamemode = "casual", TeleportMode = "Defusal"},
    Competitive = {BrowserGamemode = "competitive", TeleportMode = "UnrankedComp"},
    Deathmatch = {BrowserGamemode = "deathmatch", TeleportMode = "Deathmatch"},
    Trading = {BrowserGamemode = "trading", TeleportMode = "Trading"},
})
local u72 = table.freeze({Casual = "Defusal", Competitive = "Competitive", Deathmatch = "Deathmatch"})
local u78 = table.freeze({["Bomb Defusal"] = "Defusal", ["Hostage Rescue"] = "Defusal", Deathmatch = "Deathmatch"})
local u93 = table.freeze({
    [Constants.GAMEMODE_PLACE_IDS.Casual] = "Defusal",
    [Constants.GAMEMODE_PLACE_IDS.Competitive] = "Competitive",
    [Constants.GAMEMODE_PLACE_IDS.Deathmatch] = "Deathmatch",
    [Constants.GAMEMODE_PLACE_IDS.Trading] = "Trading",
})
local u94 = "Gamemodes"
local u95 = 0
local u96 = 0
local u97 = false
local u98 = 0
local u99 = {}
local u100 = {}
local u101 = {}
local u102 = {
    gameModes = {},
    regions = {"North America", "Europe", "Asia", "South America", "Oceania"},
    maps = {"Oasis", "Reactor", "Hellena"},
}
local u114 = {competitive = 0, deathmatch = 0, trading = 0, casual = 0}
local u119 = nil
local u120 = nil
local u121 = nil

local function CommaNumber(a1) -- Line: 114 -- types: a1: number
    return (tostring((math.max(math.floor(a1), 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local function GetCurrentCardName() -- Line: 122 -- upvalues: u72 (val), u78 (val), u93 (val)
    local Attribute = workspace:GetAttribute("ServerGamemode")
    if typeof(Attribute) == "string" and u72[Attribute] then
        return u72[Attribute]
    end
    local Attribute_2 = workspace:GetAttribute("Gamemode")
    if typeof(Attribute_2) == "string" and u78[Attribute_2] then
        return u78[Attribute_2]
    end
    return u93[game.PlaceId]
end

local function RefreshCurrentCard() -- Line: 139 -- upvalues: GetCurrentCardName (val), u99 (val)
    local v1 = GetCurrentCardName()
    local v2 = nil
    local v3 = nil
    for i, j in u99, v2, v3 do
        if j.Badge then
            j.Badge.Visible = i == v1
        end
    end
end

local function RefreshPlayerCounts() -- Line: 151 -- upvalues: u99 (val), u69 (val), u114 (ref)
    local v1, v2
    for i, j in u99 do
        v1 = u69[i]
        if v1 and u114[v1.BrowserGamemode] then
            v2 = u114[v1.BrowserGamemode] or 0
            j.PlayerCount.Text = ("%* Online"):format((tostring((math.max(math.floor(v2), 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")))
        end
    end
end

local function TrackOnlineTag(a1) -- Line: 165 -- upvalues: u101 (val) -- types: a1: userdata
    if a1:IsA("ImageLabel") and not table.find(u101, a1) then
        table.insert(u101, a1)
    end
end

local function UntrackOnlineTag(a1) -- Line: 173 -- upvalues: u101 (val) -- types: a1: userdata
    local v1 = table.find(u101, a1)
    if v1 then
        table.remove(u101, v1)
    end
end

local function StepOnlineBlink(a1) -- Line: 182 -- upvalues: u96 (ref), u101 (val) -- types: a1: number
    u96 = u96 + a1
    local v1 = math.sin(u96 * 3.141592653589793) * 0.25 + 0.25
    for i, j in u101 do
        j.ImageTransparency = v1
    end
end

local function SetOnlineBlinkEnabled(a1) -- Line: 193
    -- upvalues: u119 (ref), RunServiceController (val), StepOnlineBlink (val)
    if a1 == (u119 ~= nil) then
        return
    end
    if a1 then
        u119 = RunServiceController.BindToHeartbeat("UI.Gamemodes.OnlineBlink", StepOnlineBlink)
        return
    end
    if u119 then
        u119:Disconnect()
        u119 = nil
    end
end

local function SyncCategorySelection(a1, a2, a3) -- Line: 208
    -- upvalues: u102 (val)
    local v1 = u102[a1]
    if not v1 then
        return
    end
    local v2 = table.find(v1, a2)
    if v2 and not a3 then
        table.remove(v1, v2)
        return
    end
    if not v2 and a3 then
        table.insert(v1, a2)
    end
end

local function FiltersChanged() -- Line: 225 -- upvalues: ServerBrowser_2 (val), u102 (val), u98 (ref), Remotes (val)
    ServerBrowser_2.SetCategoryFilters(u102)
    u98 = u98 + 1
    local u6 = u98
    task.delay(1, function() -- Line: 230 -- upvalues: u6 (val), u98 (upval), Remotes (upval), u102 (upval)
        if u6 ~= u98 then
            return
        end
        Remotes.Modes.FetchServers.Send(u102)
    end)
end

local function VisibilityUpdated() -- Line: 241
    -- upvalues: u120 (ref), u119 (ref), RunServiceController (val), StepOnlineBlink (val), GetCurrentCardName (val)
    -- upvalues: u99 (val), Remotes (val), u102 (val), RefreshPlayerCounts (val), ServerBrowser_2 (val), u94 (ref)
    local v1 = u120.Visible == true
    if v1 ~= (u119 ~= nil) then
        if v1 then
            u119 = RunServiceController.BindToHeartbeat("UI.Gamemodes.OnlineBlink", StepOnlineBlink)
        elseif u119 then
            u119:Disconnect()
            u119 = nil
        end
    end
    if v1 then
        local v2 = GetCurrentCardName()
        local v3 = nil
        local v4 = nil
        for i, j in u99, v3, v4 do
            if j.Badge then
                j.Badge.Visible = i == v2
            end
        end
        Remotes.Modes.FetchServers.Send(u102)
        Remotes.Modes.FetchPlayerCounts.Send()
        RefreshPlayerCounts()
    end
    ServerBrowser_2.SetActive(v1 and u94 == "ServerBrowser")
end

function u0.InitializeGamemodeTemplate(a1) -- Line: 257
    -- upvalues: u69 (val), u99 (val), ActivateButton (val), GetCurrentCardName (val), u121 (ref), u120 (ref)
    local u3 = u69[a1.Name]
    if not u3 then
        warn((("[Gamemodes] Unknown gamemode card \"%*\""):format(a1.Name)))
        return
    end
    local ActivePlayerCount = a1:FindFirstChild("ActivePlayerCount")
    local YouAreHere = a1:FindFirstChild("YouAreHere")
    local Name_2 = a1.Name
    local v1 = {Card = a1}
    v1.Badge = YouAreHere and YouAreHere:IsA("GuiObject") and YouAreHere or nil
    v1.PlayerCount = ActivePlayerCount and ActivePlayerCount:IsA("TextLabel") and ActivePlayerCount or nil
    u99[Name_2] = v1
    ActivateButton(a1)
    a1.MouseButton1Click:Connect(function() -- Line: 275 -- upvalues: GetCurrentCardName (upval), a1 (val), u121 (upval), u3 (val), u120 (upval)
        if GetCurrentCardName() == a1.Name then
            return
        end
        u121 = u3
        u120.Gamemodes.Prompt.Visible = true
        u120.Gamemodes.Prompt.TextLabel.Text = ("Are you sure you want to join %*?"):format(u3.BrowserGamemode)
    end)
end

function u0.OpenGamemodesFrame(a1) -- Line: 289
    -- upvalues: u94 (ref), u120 (ref), u100 (val), SetTabSelected (val), ServerBrowser_2 (val)
    local v1, v2
    u94 = a1
    local v3 = a1
    for i, j in u120:GetChildren() do
        if j:GetAttribute("ButtonFrame") then
            v1 = j.Name == v3
            j.Visible = v1
        end
    end
    local v4 = nil
    local v5 = nil
    for k, n in u100, v4, v5 do
        v2 = k == v3
        SetTabSelected(n, v2)
    end
    local SetActive = ServerBrowser_2.SetActive
    v4 = false
    if u120.Visible == true then
        v4 = v3 == "ServerBrowser"
    end
    SetActive(v4)
end

function u0.Initialize(a1, a2) -- Line: 307
    -- upvalues: u120 (ref), u0 (val), u100 (val), ActivateButton (val), MenuState (val), u60 (val), u94 (ref)
    -- upvalues: GuiService (val), u121 (ref), u95 (ref), Remotes (val), ServerBrowser_2 (val), u97 (ref), u102 (val)
    -- upvalues: u98 (ref), u114 (ref), RefreshPlayerCounts (val)
    local Name_2, Name_3, Visible, v1, v2
    u120 = a2
    for i, j in u120.Gamemodes:GetChildren() do
        if j:IsA("GuiObject") then
            for k, n in j:GetChildren() do
                if n:IsA("ImageButton") and n:FindFirstChild("ActivePlayerCount") then
                    u0.InitializeGamemodeTemplate(n)
                end
            end
        end
    end
    for m, i5 in u120.Buttons:GetChildren() do
        if i5:IsA("ImageButton") then
            u100[i5.Name] = i5
            ActivateButton(i5)
            i5.MouseButton1Click:Connect(function() -- Line: 326 -- upvalues: u0 (upval), i5 (val)
                u0.OpenGamemodesFrame(i5.Name)
            end)
        end
    end
    local v3 = u120
    MenuState.RegisterBumperOverride(v3, function(a1) -- Line: 334
        -- upvalues: MenuState (upval), u120 (upval), u60 (upval), u94 (upval), u0 (upval), GuiService (upval)
        local v1 = MenuState.GetNextBumperTab(u120.Buttons, u60, u94, a1)
        if v1 and v1 ~= u94 then
            u0.OpenGamemodesFrame(v1)
        end
        local v2 = u94
        local v3 = u120.Buttons:FindFirstChild(v2)
        if v3 and v3:IsA("GuiObject") then
            GuiService.SelectedObject = v3
        end
        return true
    end, u120, u120.Buttons)
    ActivateButton(u120.Gamemodes.Prompt.Buttons.Buttons.Yes)
    ActivateButton(u120.Gamemodes.Prompt.Buttons.Buttons.No)
    u120.Gamemodes.Prompt.Buttons.Buttons.Yes.MouseButton1Click:Connect(function() -- Line: 351 -- upvalues: ActivateButton (upval), u120 (upval), u121 (upval), u95 (upval), Remotes (upval)
        ActivateButton(u120.Gamemodes.Prompt.Buttons.Buttons.Yes)
        if not u121 then
            return
        end
        local v1 = os.clock()
        if v1 - u95 < 0.75 then
            return
        end
        u95 = v1
        Remotes.Modes.SelectGamemode.Send(u121.TeleportMode)
    end)
    u120.Gamemodes.Prompt.Buttons.Buttons.No.MouseButton1Click:Connect(function() -- Line: 364 -- upvalues: u121 (upval), u120 (upval)
        u121 = nil
        u120.Gamemodes.Prompt.Visible = false
    end)
    ServerBrowser_2.Initialize(u120.ServerBrowser)
    u0.OpenGamemodesFrame("Gamemodes")
    local Search = u120.ServerBrowser.Main.Frame.Top:FindFirstChild("Search")
    if Search and Search:IsA("GuiButton") then
        local Title = Search:FindFirstChild("Title")
        ActivateButton(Search)
        Search.MouseButton1Click:Connect(function() -- Line: 376 -- upvalues: u97 (upval), Search (val), Remotes (upval), u102 (upval), Title (val)
            if not u97 then
                u97 = true
                Search.Active = false
                Remotes.Modes.FetchServers.Send(u102)
                for i = 10, 0, -1 do
                    if Title and Title:IsA("TextLabel") then
                        Title.Text = ("Search (%*)"):format(i)
                    end
                    if i > 0 then
                        task.wait(1)
                    end
                end
                if Title and Title:IsA("TextLabel") then
                    Title.Text = "Search"
                end
                Search.Active = true
                u97 = false
            end
        end)
    end
    u120.ServerBrowser.Main.Frame.Top.Filters.MouseButton1Click:Connect(function() -- Line: 400 -- upvalues: u120 (upval)
        u120.ServerBrowser.Main.Frame.Top.Filters.Categories.Visible = not u120.ServerBrowser.Main.Frame.Top.Filters.Categories.Visible
    end)
    for i6, i7 in u120.ServerBrowser.Main.Frame.Top.Filters.Categories.Maps.List:GetChildren() do
        if i7:IsA("Frame") then
            for i8, i9 in i7:GetChildren() do
                if i9:IsA("Frame") then
                    ActivateButton(i9.Button)
                    Name_2 = i7.Name
                    Name_3 = i9.Name
                    Visible = i9.Button.ImageLabel.Visible
                    v1 = u102[Name_2]
                    if v1 then
                        v2 = table.find(v1, Name_3)
                        if not v2 then
                            if not v2 and Visible then
                                table.insert(v1, Name_3)
                            end
                        elseif not Visible then
                            table.remove(v1, v2)
                        elseif not v2 and Visible then
                            table.insert(v1, Name_3)
                        end
                    end
                    i9.Button.MouseButton1Click:Connect(function() -- Line: 414
                        -- upvalues: i9 (val), i7 (val), u102 (upval), ServerBrowser_2 (upval), u98 (upval)
                        -- upvalues: Remotes (upval)
                        i9.Button.ImageLabel.Visible = not i9.Button.ImageLabel.Visible
                        local Name = i7.Name
                        local Name_2 = i9.Name
                        local Visible = i9.Button.ImageLabel.Visible
                        local v1 = u102[Name]
                        if v1 then
                            local v2 = table.find(v1, Name_2)
                            if not v2 then
                                if not v2 and Visible then
                                    table.insert(v1, Name_2)
                                end
                            elseif not Visible then
                                table.remove(v1, v2)
                            elseif not v2 and Visible then
                                table.insert(v1, Name_2)
                            end
                        end
                        ServerBrowser_2.SetCategoryFilters(u102)
                        u98 = u98 + 1
                        local u40 = u98
                        task.delay(1, function() -- Line: 230 -- upvalues: u40 (val), u98 (upval), Remotes (upval), u102 (upval)
                            if u40 ~= u98 then
                                return
                            end
                            Remotes.Modes.FetchServers.Send(u102)
                        end)
                    end)
                end
            end
            i7.Parent[(("%*Header"):format(i7.Name))].MouseButton1Click:Connect(function() -- Line: 422 -- upvalues: i7 (val)
                local Icon = i7.Parent[("%*Header"):format(i7.Name)].Icon
                Icon.Rotation = if not i7.Visible then 0 else 180
                i7.Visible = not i7.Visible
            end)
        end
    end
    ServerBrowser_2.SetCategoryFilters(u102)
    Remotes.Modes.SendPlayerCounts.Listen(function(a1) -- Line: 431 -- upvalues: u114 (upval), RefreshPlayerCounts (upval)
        if a1 then
            u114 = a1
            RefreshPlayerCounts()
        end
    end)
end

function u0.Start() -- Line: 441
    -- upvalues: CollectionService (val), u101 (val), TrackOnlineTag (val), UntrackOnlineTag (val)
    -- upvalues: RefreshCurrentCard (val), ServerBrowser (val), RefreshPlayerCounts (val), u102 (val)
    -- upvalues: ServerBrowser_2 (val), u98 (ref), Remotes (val), u120 (ref), VisibilityUpdated (val)
    -- upvalues: GetCurrentCardName (val), u99 (val)
    for i, j in CollectionService:GetTagged("Gamemodes_OnlineTag") do
        if j:IsA("ImageLabel") and not table.find(u101, j) then
            table.insert(u101, j)
        end
    end
    ;(CollectionService:GetInstanceAddedSignal("Gamemodes_OnlineTag")):Connect(TrackOnlineTag)
    ;(CollectionService:GetInstanceRemovedSignal("Gamemodes_OnlineTag")):Connect(UntrackOnlineTag)
    ;(workspace:GetAttributeChangedSignal("ServerGamemode")):Connect(RefreshCurrentCard)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(RefreshCurrentCard)
    ServerBrowser.OnServerBrowserUpdated:Connect(RefreshPlayerCounts)
    local Attribute = workspace:GetAttribute("ServerGamemode")
    table.insert(u102.gameModes, Attribute and Attribute:lower() or "casual")
    ServerBrowser_2.SetCategoryFilters(u102)
    u98 = u98 + 1
    local u78 = u98
    task.delay(1, function() -- Line: 230 -- upvalues: u78 (val), u98 (upval), Remotes (upval), u102 (upval)
        if u78 ~= u98 then
            return
        end
        Remotes.Modes.FetchServers.Send(u102)
    end)
    ;(u120:GetPropertyChangedSignal("Visible")):Connect(VisibilityUpdated)
    local v1 = GetCurrentCardName()
    local v2 = nil
    local v3 = nil
    for k, n in u99, v2, v3 do
        if n.Badge then
            n.Badge.Visible = k == v1
        end
    end
    RefreshPlayerCounts()
    VisibilityUpdated()
    ServerBrowser_2.Start()
end

return u0