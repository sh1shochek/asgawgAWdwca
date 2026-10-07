-- ReplicatedStorage.Controllers.DataController
-- Script path: ReplicatedStorage.Controllers.DataController
-- Decompile time: 4.31 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Promise = require(ReplicatedStorage.Shared.Promise)
local Sift = require(ReplicatedStorage.Packages.Sift)
local u40 = {"Serial", "Pattern"}
local u43 = {"OriginalOwner", "Owner"}
local u46 = {}
local u47 = {}

local function FireListeners(a1, a2, a3) -- Line: 42
    -- upvalues: u0 (val), Promise (val)
    local v1 = u0.Get(a1, a2)
    for k, v in pairs(a3) do
        Promise.try(v, v1)
    end
end

local function ExecuteListeners(a1, a2) -- Line: 52
    -- upvalues: u47 (val), FireListeners (val)
    local v1
    local v2 = u47[a1]
    if not v2 then
        return
    end
    local v3 = ""
    for i, v in ipairs(a2) do
        v3 = if not (i <= 1) then ("%*.%*"):format(v3, v) else v
        v1 = v2[v3]
        if v1 then
            FireListeners(v4, v3, v1)
        end
    end
end

local function DenormalizeInventoryItemFromRemote(a1) -- Line: 69 -- upvalues: Sift (val), u40 (val), u43 (val)
    local v1
    local v2 = Sift.Dictionary.copyDeep(a1)
    local v3 = nil
    local v4 = nil
    for i, j in u40, v3, v4 do
        if v2[j] ~= nil and typeof(v2[j]) == "string" then
            v1 = tonumber(v2[j]) or v2[j]
            v2[j] = v1
        end
    end
    if v2.MetaData and typeof(v2.MetaData) == "table" then
        local MetaData_4, v5
        v3 = nil
        v4 = nil
        for k, n in u43, v3, v4 do
            if v2.MetaData[n] ~= nil then
                v5 = v2.MetaData[n]
                if typeof(v5) == "string" then
                    MetaData_4 = v2.MetaData
                    v5 = tonumber(v2.MetaData[n]) or v2.MetaData[n]
                    MetaData_4[n] = v5
                end
            end
        end
    end
    return v2
end

local function ShouldDenormalizeInventoryItem(a1) -- Line: 89
    if typeof(a1) ~= "table" then
        return false
    end
    local MetaData = a1.MetaData
    local v1 = typeof(MetaData) == "table"
    local v2 = true
    if typeof(a1.Serial) ~= "string" then
        v2 = true
        if typeof(a1.Pattern) ~= "string" then
            if not v1 then
                v2 = v1 and typeof(MetaData.Owner) == "string"
            else
                v2 = true
                if typeof(MetaData.OriginalOwner) ~= "string" then
                    v2 = v1 and typeof(MetaData.Owner) == "string"
                end
            end
        end
    end
    return v2
end

function u0.ApplyInventoryDelta(a1, a2, a3) -- Line: 104
    -- upvalues: u46 (val), ShouldDenormalizeInventoryItem (val), DenormalizeInventoryItemFromRemote (val)
    -- upvalues: ExecuteListeners (val)
    local v1 = u46[a1]
    if v1 and v1.Inventory then
        local v2, v3
        local v4 = false
        if a3 then
            local v5
            v3 = {}
            for i, v in ipairs(a3) do
                v3[v] = true
            end
            for i2 = #v1.Inventory, 1, -1 do
                v5 = v1.Inventory[i2]
                if v5 and v5._id and v3[v5._id] then
                    table.remove(v1.Inventory, i2)
                    v4 = true
                end
            end
        end
        v3 = {}
        for i3, j in ipairs(v1.Inventory) do
            if j and j._id then
                v3[j._id] = true
            end
        end
        for i4, k in ipairs(a2) do
            v2 = if not ShouldDenormalizeInventoryItem(k) then k else DenormalizeInventoryItemFromRemote(k)
            if v2 and v2._id and not v3[v2._id] then
                table.insert(v1.Inventory, v2)
                v3[v2._id] = true
                v4 = true
            end
        end
        if v4 then
            ExecuteListeners(a1, {"Inventory"})
        end
        return
    end
end

function u0.IsDataLoaded(a1) -- Line: 150 -- upvalues: u46 (val) -- types: a1: userdata
    return u46[a1] ~= nil
end

function u0.WaitForDataLoaded(a1) -- Line: 156 -- upvalues: u46 (val) -- types: a1: userdata
    local v1 = 0
    local v2 = a1
    while not u46[v2] do
        v1 = v1 + task.wait()
        if v1 >= 60 then
            error((("[DataController] Failed to load player profile for %* after %* seconds"):format(v2.Name, 60)))
        end
    end
    return u46[v2]
end

function u0.Get(a1, ...) -- Line: 169 -- upvalues: u46 (val) -- types: a1: userdata
    local v1
    local v2 = u46[a1]
    if not v2 then
        return nil
    end
    local v3 = {}
    for i, j in table.pack(...) do
        v1 = v2
        for k, n in string.split(j, ".") do
            v1 = v1[n]
            if not v1 then
                break
            end
        end
        table.insert(v3, v1)
    end
    return table.unpack(v3)
end

function u0.RemoveListener(a1, a2, a3) -- Line: 192
    -- upvalues: u47 (val)
    if u47[a1] and u47[a1][a2] then
        local v1 = u47[a1][a2]
        v1[a3] = nil
        if next(u47[a1][a2]) == nil then
            v1 = u47[a1]
            v1[a2] = nil
        end
    end
end

function u0.CreateListener(a1, a2, a3) -- Line: 204
    -- upvalues: HttpService (val), u47 (val), u0 (val), Promise (val)
    local v1 = HttpService:GenerateGUID(false)
    local v2 = u47[a1] or {}
    u47[a1] = v2
    local v3 = u47[a1]
    v2 = u47[a1][a2] or {}
    v3[a2] = v2
    u47[a1][a2][v1] = a3
    v3 = u0.Get(a1, a2)
    if v3 ~= nil then
        Promise.try(a3, v3)
    end
    return v1
end

function u0.Initialize() -- Line: 220
    -- upvalues: Remotes (val), u47 (val), Stock (val), u46 (val), FireListeners (val), ExecuteListeners (val)
    Remotes.PlayerData.PlayerDataEvent.Listen(function(a1) -- Line: 221
        -- upvalues: u47 (upval), Stock (upval), u46 (upval), FireListeners (upval)
        local v1 = u47[a1.Player]
        if a1.Data and a1.Data.Inventory then
            Stock.InjectStockItems(a1.Data.Inventory)
        end
        u46[a1.Player] = a1.Data
        if v1 then
            for k, v in pairs(v1) do
                FireListeners(a1.Player, k, v)
            end
        end
    end)
    Remotes.PlayerData.PlayerDataChanged.Listen(function(a1) -- Line: 234 -- upvalues: u46 (upval), ExecuteListeners (upval) -- types: a1: table
        local v1, v2, v3, v4
        local Player = a1.Player
        local v5 = u46[Player]
        if not v5 then
            warn((("[DataController] Received data change for %* but profile not loaded yet. Requesting full profile."):format(Player.Name)))
            return
        end
        for k, v in pairs(a1.Data) do
            v3 = string.split(k, ".")
            v4 = v5
            v1 = #v3 - 1
            for i = 1, v1 do
                v2 = v3[i]
                if typeof(v4[v2]) ~= "table" then
                    v4[v2] = {}
                end
                v4 = v4[v2]
            end
            v4[v3[#v3]] = v
            ExecuteListeners(Player, v3)
        end
    end)
end

function u0.Start() -- Line: 259 -- upvalues: Remotes (val), Players (val), u0 (val), u47 (val), u46 (val)
    Remotes.PlayerData.RetrieveAllPlayerData.Send()
    Remotes.Store.NewInventoryItem.Listen(function(a1) -- Line: 262 -- upvalues: Players (upval), u0 (upval) -- types: a1: table
        local v1 = tonumber(a1.Player)
        if not v1 then
            return
        end
        local PlayerByUserId = Players:GetPlayerByUserId(v1)
        if PlayerByUserId and PlayerByUserId:IsDescendantOf(Players) then
            u0.ApplyInventoryDelta(PlayerByUserId, a1.Items, a1.DeletedItemIds)
        end
    end)
    Players.PlayerRemoving:Connect(function(a1) -- Line: 270 -- upvalues: u47 (upval), u46 (upval) -- types: a1: userdata
        u47[a1] = nil
        u46[a1] = nil
    end)
end

return u0