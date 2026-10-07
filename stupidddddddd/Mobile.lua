-- ReplicatedStorage.Database.Custom.GameStats.UI.Mobile
-- Script path: ReplicatedStorage.Database.Custom.GameStats.UI.Mobile
-- Decompile time: 6.64 ms

local u0 = {}
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
u0.MIN_SIZE = 0.04
u0.MAX_SIZE = 0.4
u0.MIN_POSITION = -2
u0.MAX_POSITION = 2
u0.DEFAULT_TRANSPARENCY = 0
u0.MAX_TRANSPARENCY = 0.65
u0.DEFAULT_ENABLED = true
local u28 = {"Gameplay", "Middle", "MobileButtons"}
local u32 = {
    Position = {X = 0.5, Y = 0.5},
    Size = {X = 0.1, Y = 0.1},
    Transparency = u0.DEFAULT_TRANSPARENCY,
    Enabled = u0.DEFAULT_ENABLED,
}
local u37 = nil
local u38 = nil

local function IsFiniteNumber(a1) -- Line: 58
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 ~= (1 / 0) then
                v1 = a1 ~= (-1 / 0)
            end
        end
    end
    return v1
end

local function CopyButtonLayout(a1) -- Line: 64 -- types: a1: table
    return {
        Position = {X = a1.Position.X, Y = a1.Position.Y},
        Size = {X = a1.Size.X, Y = a1.Size.Y},
        Transparency = a1.Transparency,
        Enabled = a1.Enabled,
    }
end

local function FindAuthoredMainGui() -- Line: 75
    -- upvalues: StarterGui (val), RunService (val), Players (val), ReplicatedStorage (val)
    local MainGui = StarterGui:FindFirstChild("MainGui")
    if MainGui then
        return MainGui
    end
    if not RunService:IsClient() then
        local Assets = ReplicatedStorage:WaitForChild("Assets", 10)
        local UI = Assets and Assets:WaitForChild("UI", 10)
        return UI and UI:WaitForChild("MainGui", 10)
    end
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 10)
    local MainGui_2 = PlayerGui and PlayerGui:WaitForChild("MainGui", 10)
    if MainGui_2 then
        task.wait()
    end
    return MainGui_2
end

local function FindButtonsFrameUnder(a1) -- Line: 100 -- upvalues: u28 (val) -- types: a1: userdata?
    local v1 = a1
    for i, v in ipairs(u28) do
        if not v1 then
            return nil
        end
        v1 = v1:FindFirstChild(v)
    end
    return v1
end

local function FindHostedButtonsFrame() -- Line: 112 -- upvalues: RunService (val), Players (val)
    if not RunService:IsClient() then
        return nil
    end
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local MobileControlsGui = PlayerGui and PlayerGui:FindFirstChild("MobileControlsGui")
    return MobileControlsGui and MobileControlsGui:FindFirstChild("MobileButtons")
end

local function FindAuthoredButtonsFrame(a1) -- Line: 121
    -- upvalues: FindAuthoredMainGui (val), RunService (val), Players (val), FindButtonsFrameUnder (val)
    local MobileControlsGui, PlayerGui, v1
    local v2 = a1 or FindAuthoredMainGui()
    local v3 = os.clock() + 10
    while true do
        if RunService:IsClient() then
            PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            MobileControlsGui = PlayerGui and PlayerGui:FindFirstChild("MobileControlsGui")
            v1 = MobileControlsGui and MobileControlsGui:FindFirstChild("MobileButtons")
        else
            v1 = nil
        end
        if not v1 then
            v1 = FindButtonsFrameUnder(v2)
        end
        if v1 then
            return v1
        end
        if v3 <= os.clock() then
            return nil
        end
        task.wait(0.1)
    end
end

local function IsConfigurableButton(a1) -- Line: 139 -- types: a1: userdata
    return a1:IsA("TextButton")
end

local function BuildDefaultLayout(a1) -- Line: 144
    -- upvalues: FindAuthoredButtonsFrame (val), u0 (val)
    local v1 = {}
    local v2 = {}
    local v3 = FindAuthoredButtonsFrame(a1)
    if not v3 then
        warn("[MobileHUD] Authored MobileButtons frame not found; defaults are empty")
    else
        for i, v in ipairs(v3:GetChildren()) do
            if v:IsA("TextButton") and v:IsA("GuiObject") then
                v1[v.Name] = {
                    Position = {X = v.Position.X.Scale, Y = v.Position.Y.Scale},
                    Size = {X = v.Size.X.Scale, Y = v.Size.Y.Scale},
                    Transparency = u0.DEFAULT_TRANSPARENCY,
                    Enabled = u0.DEFAULT_ENABLED,
                }
                table.insert(v2, v.Name)
            end
        end
    end
    table.sort(v2)
    return v1, v2
end

local function EnsureDefaults() -- Line: 171 -- upvalues: u37 (ref), u38 (ref), BuildDefaultLayout (val)
    if u37 and u38 then
        return u37, u38
    end
    local v1, v2 = BuildDefaultLayout()
    if #v2 > 0 then
        u37 = v1
        u38 = v2
    end
    return v1, v2
end

local function HasValidPositionAndSize(a1) -- Line: 185
    if typeof(a1) ~= "table" then
        return false
    end
    local Position = a1.Position
    local Size = a1.Size
    if typeof(Position) == "table" and typeof(Size) == "table" then
        local X = Position.X
        local v1 = false
        if typeof(X) == "number" then
            v1 = false
            if X == X then
                v1 = false
                if X ~= (1 / 0) then
                    v1 = X ~= (-1 / 0)
                end
            end
        end
        if v1 then
            local Y = Position.Y
            v1 = false
            if typeof(Y) == "number" then
                v1 = false
                if Y == Y then
                    v1 = false
                    if Y ~= (1 / 0) then
                        v1 = Y ~= (-1 / 0)
                    end
                end
            end
            if v1 then
                local X_2 = Size.X
                v1 = false
                if typeof(X_2) == "number" then
                    v1 = false
                    if X_2 == X_2 then
                        v1 = false
                        if X_2 ~= (1 / 0) then
                            v1 = X_2 ~= (-1 / 0)
                        end
                    end
                end
                if v1 then
                    local Y_2 = Size.Y
                    v1 = false
                    if typeof(Y_2) == "number" then
                        v1 = false
                        if Y_2 == Y_2 then
                            v1 = false
                            if Y_2 ~= (1 / 0) then
                                v1 = Y_2 ~= (-1 / 0)
                            end
                        end
                    end
                end
            end
        end
        return v1
    end
    return false
end

function u0.CaptureDefaults(a1) -- Line: 204
    -- upvalues: BuildDefaultLayout (val), u37 (ref), u38 (ref)
    local v1, v2 = BuildDefaultLayout(a1)
    if #v2 > 0 then
        u37 = v1
        u38 = v2
    end
end

function u0.GetButtonNames() -- Line: 212 -- upvalues: u37 (ref), u38 (ref), BuildDefaultLayout (val)
    local v1, v2, v3
    if not u37 then
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v3
    elseif u38 then
        v1 = u38
    else
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v3
    end
    return table.clone(v1)
end

function u0.GetDefaultLayout() -- Line: 219
    -- upvalues: u37 (ref), u38 (ref), BuildDefaultLayout (val), CopyButtonLayout (val)
    local v1, v2, v3
    if not u37 then
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v2
    elseif u38 then
        v1 = u37
    else
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v2
    end
    v2 = {}
    for k, v in pairs(v1) do
        v2[k] = (CopyButtonLayout(v))
    end
    return v2
end

function u0.GetDefaultButtonLayout(a1) -- Line: 230
    -- upvalues: u37 (ref), u38 (ref), BuildDefaultLayout (val), CopyButtonLayout (val), u32 (val)
    local v1, v2, v3
    if not u37 then
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v2
    elseif u38 then
        v1 = u37
    else
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v2
    end
    v2 = v1[a1]
    if v2 then
        return (CopyButtonLayout(v2))
    end
    return (CopyButtonLayout(u32))
end

function u0.IsKnownButton(a1) -- Line: 241
    -- upvalues: u37 (ref), u38 (ref), BuildDefaultLayout (val)
    local v1, v2, v3
    if not u37 then
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v2
    elseif u38 then
        v1 = u37
    else
        v2, v3 = BuildDefaultLayout()
        if #v3 > 0 then
            u37 = v2
            u38 = v3
        end
        v1 = v2
    end
    return v1[a1] ~= nil
end

function u0.ClampButtonLayout(a1) -- Line: 248 -- upvalues: u0 (val) -- types: a1: table
    return {
        Position = {
            X = math.clamp(a1.Position.X, u0.MIN_POSITION, u0.MAX_POSITION),
            Y = math.clamp(a1.Position.Y, u0.MIN_POSITION, u0.MAX_POSITION),
        },
        Size = {
            X = math.clamp(a1.Size.X, u0.MIN_SIZE, u0.MAX_SIZE),
            Y = math.clamp(a1.Size.Y, u0.MIN_SIZE, u0.MAX_SIZE),
        },
        Transparency = math.clamp(a1.Transparency, 0, u0.MAX_TRANSPARENCY),
        Enabled = a1.Enabled == true,
    }
end

function u0.SanitizeLayout(a1) -- Line: 266 -- upvalues: u0 (val), HasValidPositionAndSize (val)
    local ClampButtonLayout, Enabled_2, Transparency, Transparency_2, v1, v2, v3
    local v4 = u0.GetDefaultLayout()
    if typeof(a1) ~= "table" then
        return v4
    end
    for k, v in pairs(v4) do
        v2 = a1[k]
        if HasValidPositionAndSize(v2) then
            ClampButtonLayout = u0.ClampButtonLayout
            v3 = {
                Position = {X = v2.Position.X, Y = v2.Position.Y},
                Size = {X = v2.Size.X, Y = v2.Size.Y},
            }
            Transparency = v2.Transparency
            v1 = false
            if typeof(Transparency) == "number" then
                v1 = false
                if Transparency == Transparency then
                    v1 = false
                    if Transparency ~= (1 / 0) then
                        v1 = Transparency ~= (-1 / 0)
                    end
                end
            end
            Transparency_2 = if not v1 then v.Transparency else v2.Transparency
            v3.Transparency = Transparency_2
            Enabled_2 = if typeof(v2.Enabled) ~= "boolean" then v.Enabled else v2.Enabled
            v3.Enabled = Enabled_2
            v4[k] = (ClampButtonLayout(v3))
        end
    end
    return v4
end

function u0.AreButtonLayoutsEqual(a1, a2) -- Line: 291 -- types: a1: table, a2: table
    local v1 = false
    if a1.Position.X == a2.Position.X then
        v1 = false
        if a1.Position.Y == a2.Position.Y then
            v1 = false
            if a1.Size.X == a2.Size.X then
                v1 = false
                if a1.Size.Y == a2.Size.Y then
                    v1 = false
                    if a1.Transparency == a2.Transparency then
                        v1 = a1.Enabled == a2.Enabled
                    end
                end
            end
        end
    end
    return v1
end

function u0.AreLayoutsEqual(a1, a2) -- Line: 302 -- upvalues: u0 (val) -- types: a1: table, a2: table
    local v1, v2
    for i, v in ipairs(u0.GetButtonNames()) do
        v1 = a1[v] or u0.GetDefaultButtonLayout(v)
        v2 = v3[v] or u0.GetDefaultButtonLayout(v)
        if not u0.AreButtonLayoutsEqual(v1, v2) then
            return false
        end
    end
    return true
end

return u0