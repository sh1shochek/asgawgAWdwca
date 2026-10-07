-- ReplicatedStorage.Interface.Screens.Menu.Career.MatchHistory
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.MatchHistory
-- Decompile time: 2.31 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Types)
local Format = require(script.Parent.Format)
local MapIcon = require(script.Parent.MapIcon)
local CareerData = require(script.Parent.CareerData)
local MatchDetails = require(script.Parent.MatchDetails)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local Router = require(ReplicatedStorage.Database.Security.Router)
local u46 = table.freeze({"Template", "ServerBrowserTemplate"})
local u47 = nil
local u48 = nil

local function SetText(a1, a2, a3) -- Line: 36 -- types: a1: userdata, a2: string, a3: string
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("TextLabel") then
        v1.Text = a3
    end
end

local function BindDetailsButton(a1, a2) -- Line: 45
    -- upvalues: Router (val), MatchDetails (val), ActivateButton (val)
    local function open() -- Line: 46 -- upvalues: Router (upval), MatchDetails (upval), a2 (val)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        MatchDetails.Open(a2)
    end

    local Details = a1:FindFirstChild("Details")
    if Details and Details:IsA("GuiButton") then
        ActivateButton(Details)
        Details.MouseButton1Click:Connect(open)
        local Tooltip = Details:FindFirstChild("Tooltip")
        if Tooltip then
            local Title = Tooltip:FindFirstChild("Title")
            local Desc = Tooltip:FindFirstChild("Desc")
            if Title then
                Title.Text = "MATCH DETAILS"
            end
            if Desc then
                Desc.Text = "Open the full scoreboard for this match."
            end
        end
    end
    local MapBackground = a1:FindFirstChild("MapBackground")
    local ImageButton = MapBackground and MapBackground:FindFirstChild("ImageButton")
    if ImageButton and ImageButton:IsA("GuiButton") then
        ImageButton.MouseButton1Click:Connect(open)
    end
end

local function CreateRow(a1, a2) -- Line: 79
    -- upvalues: u48 (ref), Format (val), MatchDetails (val), MapIcon (val), BindDetailsButton (val), u47 (ref)
    local v1 = u48:Clone()
    v1.Name = ("Match_%*"):format(a2)
    v1.LayoutOrder = a2
    v1.Visible = true
    local v2 = string.upper(a1.Map)
    local MapName = v1:FindFirstChild("MapName")
    if MapName and MapName:IsA("TextLabel") then
        MapName.Text = v2
    end
    v2 = Format.DateTime(a1.CompletedAt)
    local Date = v1:FindFirstChild("Date")
    if Date and Date:IsA("TextLabel") then
        Date.Text = v2
    end
    v2 = string.upper(a1.ServerGamemode)
    local Gamemode = v1:FindFirstChild("Gamemode")
    if Gamemode and Gamemode:IsA("TextLabel") then
        Gamemode.Text = v2
    end
    local Score = v1:FindFirstChild("Score")
    if Score then
        Score.RichText = true
        Score.Text = Format.MatchScore(a1.Team, a1.CTScore, a1.TScore)
    end
    local Status = v1:FindFirstChild("Status")
    if Status then
        MatchDetails.ApplyStatus(Status, a1.Result)
    end
    local MapBackground = v1:FindFirstChild("MapBackground")
    local ImageButton = MapBackground and MapBackground:FindFirstChild("ImageButton")
    if ImageButton and ImageButton:IsA("ImageButton") then
        ImageButton.Image = MapIcon.Get(a1.Map)
    end
    BindDetailsButton(v1, a1)
    v1.Parent = u47
end

local function ClearRows() -- Line: 113 -- upvalues: u47 (ref)
    for i, v in ipairs(u47:GetChildren()) do
        if v:IsA("Frame") and string.sub(v.Name, 1, 6) == "Match_" then
            v:Destroy()
        end
    end
end

function v1.Bind(a1) -- Line: 124
    -- upvalues: u47 (ref), u46 (val), u48 (ref), MatchDetails (val)
    local History = a1:FindFirstChild("History")
    local Main = History and History:FindFirstChild("Main")
    local MatchHistory = Main and Main:FindFirstChild("MatchHistory")
    u47 = MatchHistory and MatchHistory:FindFirstChild("Container")
    if not u47 then
        return
    end
    if MatchHistory and MatchHistory:IsA("GuiObject") then
        MatchHistory.Visible = true
    end
    for i, v in ipairs(u47:GetChildren()) do
        if v:IsA("Frame") and table.find(u46, v.Name) ~= nil then
            if not u48 then
                v.Visible = false
            else
                v:Destroy()
            end
        end
    end
    MatchDetails.Bind(a1)
end

function v1.Render() -- Line: 155 -- upvalues: CareerData (val), u47 (ref), u48 (ref), ClearRows (val), CreateRow (val)
    local v1 = CareerData.Get()
    if u47 and u48 and v1 then
        ClearRows()
        for i, v in ipairs(v1.Matches) do
            CreateRow(v, i)
        end
        local Empty = u47:FindFirstChild("Empty")
        if Empty and Empty:IsA("GuiObject") then
            Empty.Visible = #v1.Matches == 0
        end
        return
    end
end

function v1.Close() -- Line: 175 -- upvalues: MatchDetails (val)
    MatchDetails.Close()
end

return v1