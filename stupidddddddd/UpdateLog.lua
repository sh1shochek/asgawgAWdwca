-- ReplicatedStorage.Interface.Screens.Menu.UpdateLog
-- Script path: ReplicatedStorage.Interface.Screens.Menu.UpdateLog
-- Decompile time: 1.65 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local UpdateLogs = require(ReplicatedStorage.Database.Custom.UpdateLogs)
local u21 = nil
local u22 = nil
local u23 = nil
local u24 = nil

local function buildLog(a1) -- Line: 36
    -- upvalues: ReplicatedStorage (val), u22 (ref), u23 (ref), ActivateButton (val), u24 (ref)
    local v1, v2
    local v3 = ReplicatedStorage.Assets.UI.Updates.Update:Clone()
    v3.Name = a1.Date
    v3.Container.HEADING.Text = a1.Title
    v3.Container.DATE.Text = a1.Date
    v3.Parent = u22
    local v4 = ReplicatedStorage.Assets.UI.Updates.Date:Clone()
    v4.Image = a1.Banner
    v4.Info.Mode.Text = a1.Title
    v4.Info.Description.Text = a1.Date
    v4.Name = a1.Date
    v4.Parent = u23.Content.UpdateDates.Container
    local v5 = nil
    local v6 = nil
    for i, j in a1.Headers, v5, v6 do
        v2 = ReplicatedStorage.Assets.UI.Updates.Category:Clone()
        v2.Category.Text = ("[%*]"):format(j.Title)
        v2.Parent = v3.Container
        for k, n in j.Logs do
            v1 = ReplicatedStorage.Assets.UI.Updates.Log:Clone()
            v1.Log.Text = n
            v1.Parent = v2
        end
    end
    ActivateButton(v4)
    v4.MouseButton1Click:Connect(function() -- Line: 63 -- upvalues: u22 (upval), a1 (val), u24 (upval)
        local v1
        for i, j in u22:GetChildren() do
            if j:IsA("Frame") then
                v1 = j.Name == a1.Date
                j.Visible = v1
            end
        end
        u24.Image = a1.Banner
        u24.Description.Text = a1.Date
    end)
    return v3
end

function v1.Initialize(a1, a2) -- Line: 81
    -- upvalues: u21 (ref), u22 (ref), u23 (ref), u24 (ref), UpdateLogs (val), buildLog (val), ActivateButton (val)
    -- upvalues: MenuState (val)
    local v1
    u21 = a2
    u22 = u21.Main.UpdateScroller
    u23 = u21.Main.Sidebar
    u24 = u23.Heading
    u24.Image = UpdateLogs[1].Banner
    u24.Description.Text = UpdateLogs[1].Date
    local v2 = #UpdateLogs
    for i = 1, v2 do
        v1 = buildLog(UpdateLogs[i])
        v1.Visible = i == 1
    end
    local Close = u21.Close
    ActivateButton(Close)
    Close.MouseButton1Click:Connect(function() -- Line: 97 -- upvalues: u21 (upval)
        u21.Visible = false
    end)

    local function updateDashboardSectionsVisibility() -- Line: 102 -- upvalues: u21 (upval)
        local Dashboard = u21.Parent:FindFirstChild("Dashboard")
        if not Dashboard then
            return
        end
        local Visible = u21.Visible
        local Left = Dashboard:FindFirstChild("Left")
        local News = Left and Left:FindFirstChild("News")
        local Featured = Left and Left:FindFirstChild("Featured")
        local Rewards = Dashboard:FindFirstChild("Rewards")
        if News then
            News.Visible = not Visible
        end
        if Featured then
            Featured.Visible = not Visible
        end
        if Rewards then
            Rewards.Visible = not Visible
        end
    end

    ;(u21:GetPropertyChangedSignal("Visible")):Connect(updateDashboardSectionsVisibility)
    updateDashboardSectionsVisibility()
    MenuState.OnScreenChanged:Connect(function(a1, a2) -- Line: 128 -- upvalues: u21 (upval)
        if a2 ~= nil and a2 ~= "Dashboard" then
            u21.Visible = false
        end
    end)
end

return v1