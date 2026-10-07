-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Halftime
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Halftime
-- Decompile time: 1.91 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local u18 = nil
local u19 = 0

local function hideHalftime() -- Line: 21 -- upvalues: u19 (ref), u18 (ref)
    u19 = u19 + 1
    u18.Visible = false
end

local function normalizeTeam(a1) -- Line: 26 -- types: a1: string
    if a1 ~= "Counter-Terrorists" and a1 ~= "CT" then
        if a1 ~= "Terrorists" and a1 ~= "T" then
            return nil
        end
        return "Terrorists"
    end
    return "Counter-Terrorists"
end

local function getHeader() -- Line: 38 -- upvalues: u18 (ref)
    local Title = u18 and u18:FindFirstChild("Title")
    return Title and Title:FindFirstChild("Header")
end

local function getContextLabel(a1) -- Line: 43 -- types: a1: userdata
    local Context = a1:FindFirstChild("Context")
    if Context and Context:IsA("TextLabel") then
        return Context
    end
    return nil
end

local function updateHeaderTeamVisibility(a1, a2) -- Line: 48 -- types: a1: userdata, a2: string
    local v1
    local v2 = not (a2 == "Counter-Terrorists")
    local u17 = false

    local function setVisibleIfGuiObject(a1_2, a2) -- Line: 53
        -- upvalues: a1 (val), u17 (ref)
        local v1 = a1:FindFirstChild(a1_2)
        if v1 and v1:IsA("GuiObject") then
            v1.Visible = a2
            u17 = true
        end
    end

    local CT = a1:FindFirstChild("CT")
    if CT and CT:IsA("GuiObject") then
        CT.Visible = v1
        u17 = true
    end
    local T = a1:FindFirstChild("T")
    if T and T:IsA("GuiObject") then
        T.Visible = v2
        u17 = true
    end
    local PlayingCT = a1:FindFirstChild("PlayingCT")
    if PlayingCT and PlayingCT:IsA("GuiObject") then
        PlayingCT.Visible = v1
        u17 = true
    end
    local PlayingT = a1:FindFirstChild("PlayingT")
    if PlayingT and PlayingT:IsA("GuiObject") then
        PlayingT.Visible = v2
        u17 = true
    end
    return u17
end

local function showHalftime(a1, a2) -- Line: 69
    -- upvalues: u19 (ref), u18 (ref), updateHeaderTeamVisibility (val)
    local v1
    if not (if a1 == "Counter-Terrorists" then "Counter-Terrorists" else if a1 ~= "CT" then if a1 == "Terrorists" then "Terrorists" else if a1 ~= "T" then nil else "Terrorists" else "Counter-Terrorists") then
        warn(("[Halftime] Unsupported NextTeam value: %s"):format((tostring(a1))))
        u19 = u19 + 1
        u18.Visible = false
        return false
    end
    local v2 = "Playing as " .. v1
    local Title = u18 and u18:FindFirstChild("Title")
    local v3 = Title and Title:FindFirstChild("Header")
    if not v3 then
        warn("[Halftime] Missing Title.Header")
        u19 = u19 + 1
        u18.Visible = false
        return false
    end
    local Context = v3:FindFirstChild("Context")
    local v4 = if not Context then nil else if not Context:IsA("TextLabel") then nil else Context
    if not updateHeaderTeamVisibility(v3, v1) and not v4 then
        warn("[Halftime] Missing Title.Header CT/T + PlayingCT/PlayingT visuals and Context TextLabel")
        u19 = u19 + 1
        u18.Visible = false
        return false
    end
    if v4 then
        v4.Text = v2
    end
    u19 = u19 + 1
    local u85 = u19
    u18.Visible = true
    if a2 ~= nil then
        task.delay(math.max(tonumber(a2) or 0, 0), function() -- Line: 105 -- upvalues: u85 (val), u19 (upval), u18 (upval)
            if u85 ~= u19 then
                return
            end
            u18.Visible = false
        end)
    end
    return true
end

function v1.Show(a1, a2) -- Line: 119 -- upvalues: u18 (ref), showHalftime (val) -- types: a1: string, a2: number?
    if u18 then
        return (showHalftime(a1, a2))
    end
    warn("[Halftime] Frame is not initialized")
    return false
end

function v1.Hide() -- Line: 128 -- upvalues: u18 (ref), u19 (ref)
    if not u18 then
        return
    end
    u19 = u19 + 1
    u18.Visible = false
end

function v1.Initialize(a1, a2) -- Line: 136 -- upvalues: u18 (ref), GameState (val), u19 (ref)
    u18 = a2
    u18.Visible = false
    GameState.ListenToState(function(a1, a2) -- Line: 140 -- upvalues: u19 (upval), u18 (upval)
        if a2 == "Buy Period" or a2 == "Round In Progress" then
            u19 = u19 + 1
            u18.Visible = false
        end
    end)
end

return v1