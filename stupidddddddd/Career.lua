-- ReplicatedStorage.Interface.Screens.Menu.Career
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career
-- Decompile time: 3.10 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local CareerData = require(script.CareerData)
local Selection = require(script.Selection)
local Overview = require(script.Overview)
local WeaponStats = require(script.WeaponStats)
local MatchHistory = require(script.MatchHistory)
local WeaponIcon = require(script.WeaponIcon)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local SetTabSelected = require(ReplicatedStorage.Components.Common.InterfaceAnimations.SetTabSelected)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local u58 = table.freeze({
    Overview = "Overview",
    MatchHistory = "Matchhistory",
    WeaponStats = "WeaponStats",
    Leaderboard = "Leaderboard",
})
local u65 = table.freeze({"Overview", "MatchHistory", "WeaponStats", "Leaderboard"})
local u66 = nil
local u67 = nil
local u68 = "Overview"
local u69 = {}

local function GetPage(a1) -- Line: 56 -- upvalues: u67 (ref) -- types: a1: string
    local v1 = u67:FindFirstChild(a1)
    if v1 and v1:IsA("Frame") then
        return v1
    end
    return nil
end

local function UpdateTabButtons() -- Line: 64 -- upvalues: u69 (val), SetTabSelected (val), u68 (ref)
    local v1
    for k, v in pairs(u69) do
        v1 = k == u68
        SetTabSelected(v, v1)
    end
end

local function ShowTab(a1) -- Line: 72
    -- upvalues: u68 (ref), u58 (val), u67 (ref), MatchHistory (val), u69 (val), SetTabSelected (val), Overview (val)
    local v1, v2, v3
    local v4 = a1
    for k, v in pairs(u58) do
        v2 = u67:FindFirstChild(v)
        v1 = if not v2 then nil else if not v2:IsA("Frame") then nil else v2
        if v1 then
            v1.Visible = k == v4
        end
    end
    if v4 ~= "MatchHistory" then
        MatchHistory.Close()
    end
    for k2, i in pairs(u69) do
        v3 = k2 == a1
        SetTabSelected(i, v3)
    end
    Overview.RefreshSelection()
end

local function SelectTab(a1) -- Line: 93 -- upvalues: u68 (ref), Router (val), ShowTab (val) -- types: a1: string
    if u68 == a1 then
        return
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
    ShowTab(a1)
end

local function Render() -- Line: 104 -- upvalues: Overview (val), WeaponStats (val), MatchHistory (val)
    Overview.Render()
    WeaponStats.Render()
    MatchHistory.Render()
end

function v1.Initialize(a1, a2) -- Line: 113
    -- upvalues: u66 (ref), u67 (ref), u58 (val), u69 (val), ActivateButton (val), u68 (ref), Router (val)
    -- upvalues: ShowTab (val), Overview (val), WeaponStats (val), MatchHistory (val), MenuState (val), u65 (val)
    -- upvalues: GuiService (val)
    local v1
    u66 = a2
    u67 = a2:WaitForChild("Pages")
    u66.Visible = false
    local Categories = (a2:WaitForChild("Top")):WaitForChild("Categories")
    for k in pairs(u58) do
        v1 = Categories:FindFirstChild(k)
        if v1 and v1:IsA("GuiButton") then
            u69[k] = v1
            ActivateButton(v1)
            v1.MouseButton1Click:Connect(function() -- Line: 124 -- upvalues: k (val), u68 (upval), Router (upval), ShowTab (upval)
                local v1 = k
                if u68 == v1 then
                    return
                end
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                ShowTab(v1)
            end)
        end
    end
    local Overview_2 = u58.Overview
    local v2 = u67:FindFirstChild(Overview_2)
    local v3 = if not v2 then nil else if not v2:IsA("Frame") then nil else v2
    if v3 then
        Overview.Bind(v3)
        Overview.BindTab(u69.Overview)
    end
    local WeaponStats_2 = u58.WeaponStats
    local v4 = u67:FindFirstChild(WeaponStats_2)
    local v5 = if not v4 then nil else if not v4:IsA("Frame") then nil else v4
    if v5 then
        WeaponStats.Bind(v5)
    end
    local MatchHistory_2 = u58.MatchHistory
    local v6 = u67:FindFirstChild(MatchHistory_2)
    v2 = if not v6 then nil else if not v6:IsA("Frame") then nil else v6
    if v2 then
        MatchHistory.Bind(v2)
    end
    v6 = u66
    MenuState.RegisterBumperOverride(v6, function(a1) -- Line: 147
        -- upvalues: MenuState (upval), Categories (val), u65 (upval), u68 (upval), Router (upval), ShowTab (upval)
        -- upvalues: GuiService (upval), u58 (upval), u67 (upval), u69 (upval)
        local v1 = MenuState.GetNextBumperTab(Categories, u65, u68, a1)
        if v1 and u68 ~= v1 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            ShowTab(v1)
        end
        local SelectedObject = GuiService.SelectedObject
        local v2 = u58[u68]
        local v3 = u67:FindFirstChild(v2)
        local v4 = if not v3 then nil else if not v3:IsA("Frame") then nil else v3
        v2 = false
        if SelectedObject ~= nil then
            v2 = SelectedObject:IsDescendantOf(Categories)
        end
        v3 = false
        if SelectedObject ~= nil then
            v3 = SelectedObject:IsDescendantOf(u67) and not (v4 and SelectedObject:IsDescendantOf(v4))
        end
        if v2 or v3 then
            GuiService.SelectedObject = u69[u68]
        end
        return true
    end)
    ShowTab("Overview")
end

function v1.Start() -- Line: 173
    -- upvalues: CareerData (val), Render (val), Selection (val), WeaponIcon (val), Overview (val), WeaponStats (val)
    -- upvalues: MatchHistory (val), MenuState (val), u66 (ref), ShowTab (val)
    CareerData.Listen()
    CareerData.Changed:Connect(Render)
    Selection.Changed:Connect(Render)
    WeaponIcon.Changed:Connect(function() -- Line: 181 -- upvalues: CareerData (upval), Overview (upval), WeaponStats (upval), MatchHistory (upval)
        if CareerData.IsLoaded() then
            Overview.Render()
            WeaponStats.Render()
            MatchHistory.Render()
        end
    end)
    MenuState.OnScreenChanged:Connect(function(a1, a2) -- Line: 188
        -- upvalues: u66 (upval), MatchHistory (upval), ShowTab (upval), CareerData (upval), Overview (upval)
        -- upvalues: WeaponStats (upval)
        if a2 ~= "Career" then
            if u66 and not u66.Visible then
                MatchHistory.Close()
            end
            return
        end
        ShowTab("Overview")
        CareerData.Request()
        Overview.Render()
        WeaponStats.Render()
        MatchHistory.Render()
    end)
    if CareerData.IsLoaded() then
        Overview.Render()
        WeaponStats.Render()
        MatchHistory.Render()
    end
end

return v1