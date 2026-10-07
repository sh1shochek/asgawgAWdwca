-- ReplicatedStorage.Database.Components.Libraries.Cases
-- Script path: ReplicatedStorage.Database.Components.Libraries.Cases
-- Decompile time: 5.69 ms

local ScheduleCasesUpdateAtNextBoundary
local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
require(ReplicatedStorage.Database.Custom.Types)
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray)
local u37 = require(ReplicatedStorage.Packages.Signal).new()
u0.OnCasesUpdated = u37
local u40 = RunService:IsStudio()
local u41 = {}
local u42 = {}
local u43 = 0

local function ParseUnixTimestamp(a1) -- Line: 38
    if a1 == nil then
        return nil
    end
    local v1 = tonumber(a1)
    if not v1 then
        local v2 = DateTime.fromIsoDate(a1)
        return v2 and v2.UnixTimestamp
    end
    if v1 > 10000000000 then
        return (math.floor(v1 / 1000))
    end
    return (math.floor(v1))
end

local function GetCurrentUnixTimestamp() -- Line: 58 -- upvalues: Workspace (val)
    return (math.floor((Workspace:GetServerTimeNow())))
end

local function GetNextCaseBoundaryTimestamp() -- Line: 64 -- upvalues: Workspace (val), u41 (ref)
    local UnixTimestamp, UnixTimestamp_2, discontinueDate, releaseDate, v1, v2, v3
    local v4 = math.floor((Workspace:GetServerTimeNow()))
    local v5 = nil
    for i, v in ipairs(u41) do
        releaseDate = v.releaseDate
        if releaseDate ~= nil then
            v3 = tonumber(releaseDate)
            if not v3 then
                v1 = DateTime.fromIsoDate(releaseDate)
                UnixTimestamp = v1 and v1.UnixTimestamp
            else
                UnixTimestamp = if not (v3 > 10000000000) then math.floor(v3) else math.floor(v3 / 1000)
            end
        else
            UnixTimestamp = nil
        end
        if UnixTimestamp and v4 < UnixTimestamp then
            if v5 == nil or UnixTimestamp < v5 then
                v5 = UnixTimestamp
            end
        end
        discontinueDate = v.discontinueDate
        if discontinueDate ~= nil then
            v1 = tonumber(discontinueDate)
            if not v1 then
                v2 = DateTime.fromIsoDate(discontinueDate)
                UnixTimestamp_2 = v2 and v2.UnixTimestamp
            else
                UnixTimestamp_2 = if not (v1 > 10000000000) then math.floor(v1) else math.floor(v1 / 1000)
            end
        else
            UnixTimestamp_2 = nil
        end
        if UnixTimestamp_2 and v4 < UnixTimestamp_2 then
            if v5 == nil or UnixTimestamp_2 < v5 then
                v5 = UnixTimestamp_2
            end
        end
    end
    return v5
end

function ScheduleCasesUpdateAtNextBoundary() -- Line: 85
    -- upvalues: u40 (val), u43 (ref), Workspace (val), GetNextCaseBoundaryTimestamp (val), u37 (val), u41 (ref)
    -- upvalues: ScheduleCasesUpdateAtNextBoundary (val)
    if u40 then
        return
    end
    u43 = u43 + 1
    local u3 = u43
    local v1 = math.floor((Workspace:GetServerTimeNow()))
    local v2 = GetNextCaseBoundaryTimestamp()
    if not v2 then
        return
    end
    task.delay(math.max(v2 - v1, 0), function() -- Line: 99
        -- upvalues: u3 (val), u43 (upval), u37 (upval), u41 (upval), ScheduleCasesUpdateAtNextBoundary (upval)
        if u3 ~= u43 then
            return
        end
        if #u37:GetConnections() > 0 then
            u37:Fire(u41)
        end
        ScheduleCasesUpdateAtNextBoundary()
    end)
end

local function IsCaseEnabled(a1, a2) -- Line: 114 -- upvalues: Workspace (val), u40 (val) -- types: a2: boolean?
    local v1 = math.floor((Workspace:GetServerTimeNow()))
    if u40 and not a2 then
        return true
    end
    if a1.status ~= "inactive" and a1.status ~= "discontinued" and a1.isEnabled then
        local v2
        local releaseDate = a1.releaseDate
        if releaseDate then
            local releaseDate_2 = a1.releaseDate
            if releaseDate_2 ~= nil then
                local v3 = tonumber(releaseDate_2)
                if not v3 then
                    v2 = DateTime.fromIsoDate(releaseDate_2)
                    releaseDate = v2 and v2.UnixTimestamp
                else
                    releaseDate = if not (v3 > 10000000000) then math.floor(v3) else math.floor(v3 / 1000)
                end
            else
                releaseDate = nil
            end
        end
        if releaseDate and v1 < releaseDate then
            return false
        end
        local discontinueDate = a1.discontinueDate
        if discontinueDate then
            local discontinueDate_2 = a1.discontinueDate
            if discontinueDate_2 ~= nil then
                v2 = tonumber(discontinueDate_2)
                if not v2 then
                    local v4 = DateTime.fromIsoDate(discontinueDate_2)
                    discontinueDate = v4 and v4.UnixTimestamp
                else
                    discontinueDate = if not (v2 > 10000000000) then math.floor(v2) else math.floor(v2 / 1000)
                end
            else
                discontinueDate = nil
            end
        end
        if discontinueDate and discontinueDate <= v1 then
            return false
        end
        return true
    end
    return false
end

local u49 = {["Charm Capsule"] = true, Package = true, Console = true}

local function HasCaseModel(a1) -- Line: 143 -- upvalues: u49 (val), ReplicatedStorage (val)
    if u49[a1.caseType] then
        return true
    end
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local CaseModels = Assets and Assets:FindFirstChild("CaseModels")
    local v1 = false
    if CaseModels ~= nil then
        v1 = CaseModels:FindFirstChild(a1.name) ~= nil
    end
    return v1
end

local function SortByDisplayOrder(a1, a2) -- Line: 155 -- upvalues: u42 (ref)
    if a1.displayOrder ~= a2.displayOrder then
        return a1.displayOrder < a2.displayOrder
    end
    return (u42[a1] or 0) < (u42[a2] or 0)
end

local function UpdateAvailableCases(a1) -- Line: 164
    -- upvalues: u41 (ref), HttpService (val), u42 (ref), ScheduleCasesUpdateAtNextBoundary (val), u37 (val)
    u41 = HttpService:JSONDecode(a1)
    u42 = {}
    for i, v in ipairs(u41) do
        u42[v] = i
    end
    ScheduleCasesUpdateAtNextBoundary()
    if #u37:GetConnections() > 0 then
        u37:Fire(u41)
    end
end

function u0.GetCreationTimestamp(a1) -- Line: 180
    local UnixTimestamp, v1, v2
    local createdAt = a1.createdAt
    if createdAt ~= nil then
        v1 = tonumber(createdAt)
        if not v1 then
            v2 = DateTime.fromIsoDate(createdAt)
            UnixTimestamp = v2 and v2.UnixTimestamp
        else
            UnixTimestamp = if not (v1 > 10000000000) then math.floor(v1) else math.floor(v1 / 1000)
        end
    else
        UnixTimestamp = nil
    end
    if not UnixTimestamp then
        local releaseDate = a1.releaseDate
        if releaseDate == nil then
            return nil
        end
        v1 = tonumber(releaseDate)
        if v1 then
            if v1 > 10000000000 then
                return (math.floor(v1 / 1000))
            end
            return (math.floor(v1))
        end
        v2 = DateTime.fromIsoDate(releaseDate)
        UnixTimestamp = v2 and v2.UnixTimestamp
    end
    return UnixTimestamp
end

function u0.IsLimited(a1) -- Line: 188
    local UnixTimestamp
    local discontinueDate = a1.discontinueDate
    if discontinueDate ~= nil then
        local v1 = tonumber(discontinueDate)
        if not v1 then
            local v2 = DateTime.fromIsoDate(discontinueDate)
            UnixTimestamp = v2 and v2.UnixTimestamp
        else
            UnixTimestamp = if not (v1 > 10000000000) then math.floor(v1) else math.floor(v1 / 1000)
        end
    else
        UnixTimestamp = nil
    end
    return UnixTimestamp ~= nil
end

function u0.GetBackendOrder(a1) -- Line: 195 -- upvalues: u42 (ref)
    return u42[a1] or (1 / 0)
end

function u0.IsCaseEnabled(a1) -- Line: 201 -- upvalues: u0 (val), IsCaseEnabled (val) -- types: a1: string
    local v1 = u0.GetCase(a1)
    local v2 = false
    if v1 ~= nil then
        v2 = IsCaseEnabled(v1)
    end
    return v2
end

function u0.IsCaseForSale(a1) -- Line: 208 -- upvalues: u0 (val), IsCaseEnabled (val) -- types: a1: string
    local v1 = u0.GetCase(a1)
    local v2 = false
    if v1 ~= nil then
        v2 = IsCaseEnabled(v1, true)
    end
    return v2
end

function u0.HasCaseModel(a1) -- Line: 215 -- upvalues: u0 (val), u49 (val), ReplicatedStorage (val) -- types: a1: string
    local v1 = u0.GetCase(a1)
    local v2 = false
    if v1 ~= nil then
        if u49[v1.caseType] then
            return true
        end
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local CaseModels = Assets and Assets:FindFirstChild("CaseModels")
        v2 = false
        if CaseModels ~= nil then
            v2 = CaseModels:FindFirstChild(v1.name) ~= nil
        end
    end
    return v2
end

function u0.GetCaseByName(a1) -- Line: 222 -- upvalues: u41 (ref) -- types: a1: string
    if not u41 then
        return nil
    end
    for i, v in ipairs(u41) do
        if v.name == a1 then
            return v
        end
    end
    return nil
end

function u0.GetCase(a1) -- Line: 234 -- upvalues: u41 (ref) -- types: a1: string
    if not u41 then
        return nil
    end
    for i, v in ipairs(u41) do
        if v.caseId == a1 then
            return v
        end
    end
    return nil
end

function u0.GetFeaturedCases(a1) -- Line: 246
    -- upvalues: u41 (ref), IsCaseEnabled (val), u49 (val), ReplicatedStorage (val), SortByDisplayOrder (val)
    -- upvalues: RemoveFromArray (val)
    local Assets, CaseModels, v1
    local v2 = {}
    for i, v in ipairs(u41) do
        if v.isFeatured and IsCaseEnabled(v) then
            if not u49[v.caseType] then
                Assets = ReplicatedStorage:FindFirstChild("Assets")
                CaseModels = Assets and Assets:FindFirstChild("CaseModels")
                v1 = false
                if CaseModels ~= nil then
                    v1 = CaseModels:FindFirstChild(v.name) ~= nil
                end
            else
                v1 = true
            end
            if v1 then
                table.insert(v2, v)
            end
        end
    end
    table.sort(v2, SortByDisplayOrder)
    RemoveFromArray(v2, function(a1_2, a2) -- Line: 255 -- upvalues: a1 (val)
        return a1 < a1_2
    end)
    return v2
end

function u0.GetCases() -- Line: 263
    -- upvalues: u41 (ref), IsCaseEnabled (val), u49 (val), ReplicatedStorage (val), SortByDisplayOrder (val)
    local Assets, CaseModels, v1
    local v2 = {}
    for i, v in ipairs(u41) do
        if IsCaseEnabled(v) then
            if not u49[v.caseType] then
                Assets = ReplicatedStorage:FindFirstChild("Assets")
                CaseModels = Assets and Assets:FindFirstChild("CaseModels")
                v1 = false
                if CaseModels ~= nil then
                    v1 = CaseModels:FindFirstChild(v.name) ~= nil
                end
            else
                v1 = true
            end
            if v1 then
                table.insert(v2, v)
            end
        end
    end
    table.sort(v2, SortByDisplayOrder)
    return v2
end

function u0.ObserveAvailableCases(a1) -- Line: 276 -- upvalues: u37 (val), u41 (ref) -- types: a1: function
    local u5 = u37:Connect(a1)
    if u41 then
        a1(u41)
    end
    return function() -- Line: 281 -- upvalues: u5 (val)
        u5:Disconnect()
    end
end

local Attribute = ReplicatedStorage:GetAttribute("AvaiableCases")
if Attribute then
    UpdateAvailableCases(Attribute)
end
;(ReplicatedStorage:GetAttributeChangedSignal("AvaiableCases")):Connect(function() -- Line: 289 -- upvalues: ReplicatedStorage (val), UpdateAvailableCases (val)
    local Attribute = ReplicatedStorage:GetAttribute("AvaiableCases")
    if Attribute then
        UpdateAvailableCases(Attribute)
    end
end)
return u0