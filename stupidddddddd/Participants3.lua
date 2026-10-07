-- ReplicatedStorage.Components.Common.Participants
-- Script path: ReplicatedStorage.Components.Common.Participants
-- Decompile time: 5.59 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CharacterResolver = require(script.Parent.CharacterResolver)
local u20 = {}

local function botFolder() -- Line: 13 -- upvalues: ReplicatedStorage (val)
    return ReplicatedStorage:FindFirstChild("Combatants")
end

function u20.IsBot(a1) -- Line: 17 -- types: a1: userdata?
    local v1 = false
    if a1 ~= nil then
        v1 = not a1:IsA("Player")
    end
    return v1
end

function u20.BotKey(a1) -- Line: 22 -- types: a1: number
    return -(a1 + 1000)
end

function u20.Key(a1) -- Line: 26 -- types: a1: userdata
    if a1:IsA("Player") then
        return a1.UserId
    end
    return (a1:GetAttribute("UserId"))
end

function u20.FromKey(a1) -- Line: 33 -- upvalues: Players (val), ReplicatedStorage (val)
    local v1 = tonumber(a1)
    if v1 ~= nil and v1 ~= 0 then
        if v1 > -1000 then
            return Players:GetPlayerByUserId(v1)
        end
        local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
        if Combatants then
            return (Combatants:FindFirstChild((tostring(-v1 - 1000))))
        end
        return nil
    end
    return nil
end

function u20.Name(a1) -- Line: 45 -- types: a1: userdata
    if a1:IsA("Player") then
        return a1.Name
    end
    local Attribute = a1:GetAttribute("DisplayName")
    if type(Attribute) == "string" then
        return Attribute
    end
    return a1.Name
end

function u20.DisplayName(a1) -- Line: 53 -- upvalues: u20 (val) -- types: a1: userdata
    if a1:IsA("Player") then
        return a1.DisplayName
    end
    return u20.Name(a1)
end

function u20.AvatarUserId(a1) -- Line: 61 -- types: a1: userdata
    if a1:IsA("Player") then
        return a1.UserId
    end
    local Attribute = a1:GetAttribute("AvatarUserId")
    if type(Attribute) == "number" then
        return Attribute
    end
    return 1
end

function u20.HeadshotImage(a1, a2) -- Line: 69 -- upvalues: u20 (val) -- types: a1: userdata, a2: number?
    local v1 = a2 or 150
    return (("rbxthumb://type=AvatarHeadShot&id=%*&w=%*&h=%*"):format(u20.AvatarUserId(a1), v1, v1))
end

function u20.IsAlive(a1) -- Line: 74 -- upvalues: CharacterResolver (val) -- types: a1: userdata?
    if a1 == nil then
        return false
    end
    if a1:IsA("Player") then
        return CharacterResolver.isAlivePlayer(a1)
    end
    local Attribute = a1:GetAttribute("Health")
    local v1 = false
    if a1:GetAttribute("Dead") ~= true then
        v1 = true
        if type(Attribute) == "number" then
            v1 = Attribute > 0
        end
    end
    return v1
end

function u20.FromName(a1) -- Line: 85 -- upvalues: Players (val), ReplicatedStorage (val) -- types: a1: string
    local v1 = Players:FindFirstChild(a1)
    if v1 and v1:IsA("Player") then
        return v1
    end
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
    if Combatants then
        for i, j in Combatants:GetChildren() do
            if j:GetAttribute("DisplayName") == a1 then
                return j
            end
        end
    end
    return nil
end

function u20.GetAll() -- Line: 101 -- upvalues: Players (val), ReplicatedStorage (val)
    local v1 = {}
    for i, j in Players:GetPlayers() do
        v1[#v1 + 1] = j
    end
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
    if Combatants then
        for k, n in Combatants:GetChildren() do
            if n:IsA("Folder") then
                v1[#v1 + 1] = n
            end
        end
    end
    return v1
end

local u33 = {}
local u34 = nil
local u35 = true
local u36 = {}

local function markIndexDirty() -- Line: 123 -- upvalues: u35 (ref)
    u35 = true
end

local function shellIndex(a1) -- Line: 127
    -- upvalues: u34 (ref), u36 (ref), markIndexDirty (val), u35 (ref), u33 (val)
    if a1 ~= u34 then
        for i, j in u36 do
            j:Disconnect()
        end
        u36 = {
            a1.ChildAdded:Connect(markIndexDirty),
            (a1.ChildRemoved:Connect(markIndexDirty)),
        }
        u34 = a1
        u35 = true
    end
    if u35 then
        local Attribute
        u35 = false
        table.clear(u33)
        for k, n in a1:GetChildren() do
            if n:IsA("Model") and n:GetAttribute("Bot") == true then
                Attribute = n:GetAttribute("CombatantId")
                if Attribute ~= nil and u33[Attribute] == nil then
                    u33[Attribute] = n
                end
            end
        end
    end
    return u33
end

function u20.Character(a1) -- Line: 155
    -- upvalues: Workspace (val), shellIndex (val), u35 (ref)
    if a1 == nil then
        return nil
    end
    if a1:IsA("Player") then
        return a1.Character
    end
    local Attribute = a1:GetAttribute("CombatantId")
    local Characters = Workspace:FindFirstChild("Characters")
    if Characters and Attribute ~= nil then
        local v1 = shellIndex(Characters)[Attribute]
        if v1 ~= nil and v1.Parent ~= Characters then
            u35 = true
            v1 = shellIndex(Characters)[Attribute]
        end
        return v1
    end
    return nil
end

function u20.Observe(a1, a2) -- Line: 176
    -- upvalues: Players (val), ReplicatedStorage (val)
    local u73 = {}
    local u74 = {}

    local function add(a1_2) -- Line: 179 -- upvalues: a1 (val) -- types: a1_2: userdata
        if a1_2:IsA("Player") or a1_2:IsA("Folder") then
            task.spawn(a1, a1_2)
        end
    end

    local function remove(a1) -- Line: 184 -- upvalues: a2 (val) -- types: a1: userdata
        if a2 then
            if a1:IsA("Player") or a1:IsA("Folder") then
                task.spawn(a2, a1)
            end
        end
    end

    local function bindFolder(a1_2) -- Line: 189
        -- upvalues: u74 (val), add (val), remove (val), a1 (val)
        for i, j in u74 do
            j:Disconnect()
        end
        table.clear(u74)
        local v1 = u74
        local v2 = #u74 + 1
        v1[v2] = (a1_2.ChildAdded:Connect(add))
        v1 = u74
        v2 = #u74 + 1
        v1[v2] = (a1_2.ChildRemoved:Connect(remove))
        for k, n in a1_2:GetChildren() do
            if n:IsA("Player") or n:IsA("Folder") then
                task.spawn(a1, n)
            end
        end
    end

    u73[#u73 + 1] = (Players.PlayerAdded:Connect(add))
    u73[#u73 + 1] = (Players.PlayerRemoving:Connect(remove))
    u73[#u73 + 1] = (ReplicatedStorage.ChildAdded:Connect(function(a1) -- Line: 202 -- upvalues: bindFolder (val)
        if a1.Name == "Combatants" then
            bindFolder(a1)
        end
    end))
    for i, j in Players:GetPlayers() do
        if j:IsA("Player") or j:IsA("Folder") then
            task.spawn(a1, j)
        end
    end
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
    if Combatants then
        bindFolder(Combatants)
    end
    return function() -- Line: 214 -- upvalues: u73 (val), u74 (val)
        for i, j in u73 do
            j:Disconnect()
        end
        for k, n in u74 do
            n:Disconnect()
        end
    end
end

return (table.freeze(u20))