-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
require(ReplicatedStorage.Database.Custom.Types);
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local u2 = require(ReplicatedStorage.Packages.Signal).new();
u1.OnCasesUpdated = u2;
local u3 = RunService:IsStudio();
local u4 = {};
local u5 = {};
local u6 = 0;

local function ParseUnixTimestamp(p7) -- Line: 38
    if p7 == nil then
        return nil;
    end;

    local v8 = tonumber(p7);

    if v8 then
        if v8 > 10000000000 then
            return math.floor(v8 / 1000);
        end;

        return math.floor(v8);
    end;

    local DateTime_fromIsoDate_ret = DateTime.fromIsoDate(p7);

    if DateTime_fromIsoDate_ret then
        DateTime_fromIsoDate_ret = DateTime_fromIsoDate_ret.UnixTimestamp;
    end;

    return DateTime_fromIsoDate_ret;
end;

local function GetCurrentUnixTimestamp() -- Line: 58
    -- upvalues: Workspace (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow();

    return math.floor(ServerTimeNow);
end;

local function GetNextCaseBoundaryTimestamp() -- Line: 64
    -- upvalues: Workspace (copy), u4 (ref)
    local ServerTimeNow = Workspace:GetServerTimeNow();
    local math_floor_ret = math.floor(ServerTimeNow);
    local v9 = nil;

    for _, v in ipairs(u4) do
        local releaseDate = v.releaseDate;
        local v10;

        if releaseDate == nil then
            v10 = nil;
        else
            local v11 = tonumber(releaseDate);

            if v11 then
                if v11 > 10000000000 then
                    v10 = math.floor(v11 / 1000);
                else
                    v10 = math.floor(v11);
                end;
            else
                v10 = DateTime.fromIsoDate(releaseDate);

                if v10 then
                    v10 = v10.UnixTimestamp;
                end;
            end;
        end;

        if not (v10 and (math_floor_ret < v10 and (v9 == nil or v10 < v9))) then
            v10 = v9;
        end;

        local discontinueDate = v.discontinueDate;

        if discontinueDate == nil then
            v9 = nil;
        else
            local v12 = tonumber(discontinueDate);

            if v12 then
                if v12 > 10000000000 then
                    v9 = math.floor(v12 / 1000);
                else
                    v9 = math.floor(v12);
                end;
            else
                v9 = DateTime.fromIsoDate(discontinueDate);

                if v9 then
                    v9 = v9.UnixTimestamp;
                end;
            end;
        end;

        if not (v9 and (math_floor_ret < v9 and (v10 == nil or v9 < v10))) then
            v9 = v10;
        end;
    end;

    return v9;
end;

local function ScheduleCasesUpdateAtNextBoundary() -- Line: 85
    -- upvalues: u3 (copy), u6 (ref), Workspace (copy), GetNextCaseBoundaryTimestamp (copy), u2 (copy), u4 (ref), ScheduleCasesUpdateAtNextBoundary (copy)
    if u3 then
        return;
    end;

    u6 = u6 + 1;
    local u13 = u6;
    local ServerTimeNow = Workspace:GetServerTimeNow();
    local math_floor_ret = math.floor(ServerTimeNow);
    local v14 = GetNextCaseBoundaryTimestamp();

    if not v14 then
        return;
    end;

    local math_max_ret = math.max(v14 - math_floor_ret, 0);
    task.delay(math_max_ret, function() -- Line: 99
        -- upvalues: u13 (copy), u6 (ref), u2 (ref), u4 (ref), ScheduleCasesUpdateAtNextBoundary (ref)
        if u13 ~= u6 then
            return;
        end;

        if #u2:GetConnections() > 0 then
            u2:Fire(u4);
        end;

        ScheduleCasesUpdateAtNextBoundary();
    end);
end;

local function IsCaseEnabled(p15: any, p16: boolean?) -- Line: 114
    -- upvalues: Workspace (copy), u3 (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow();
    local math_floor_ret = math.floor(ServerTimeNow);

    if u3 and not p16 then
        return true;
    end;

    if p15.status == "inactive" or (p15.status == "discontinued" or not p15.isEnabled) then
        return false;
    end;

    local releaseDate = p15.releaseDate;

    if releaseDate then
        local releaseDate2 = p15.releaseDate;

        if releaseDate2 == nil then
            releaseDate = nil;
        else
            local v17 = tonumber(releaseDate2);

            if v17 then
                if v17 > 10000000000 then
                    releaseDate = math.floor(v17 / 1000);
                else
                    releaseDate = math.floor(v17);
                end;
            else
                releaseDate = DateTime.fromIsoDate(releaseDate2);

                if releaseDate then
                    releaseDate = releaseDate.UnixTimestamp;
                end;
            end;
        end;
    end;

    if releaseDate and math_floor_ret < releaseDate then
        return false;
    end;

    local discontinueDate = p15.discontinueDate;

    if discontinueDate then
        local discontinueDate2 = p15.discontinueDate;

        if discontinueDate2 == nil then
            discontinueDate = nil;
        else
            local v18 = tonumber(discontinueDate2);

            if v18 then
                if v18 > 10000000000 then
                    discontinueDate = math.floor(v18 / 1000);
                else
                    discontinueDate = math.floor(v18);
                end;
            else
                discontinueDate = DateTime.fromIsoDate(discontinueDate2);

                if discontinueDate then
                    discontinueDate = discontinueDate.UnixTimestamp;
                end;
            end;
        end;
    end;

    return (not discontinueDate or discontinueDate > math_floor_ret) and true or false;
end;

local u19 = {
    ["Charm Capsule"] = true,
    Package = true,
    Console = true
};

local function HasCaseModel(p20) -- Line: 143
    -- upvalues: u19 (copy), ReplicatedStorage (copy)
    if u19[p20.caseType] then
        return true;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("CaseModels");
    end;

    local v21;

    if Assets == nil then
        v21 = false;
    else
        v21 = Assets:FindFirstChild(p20.name) ~= nil;
    end;

    return v21;
end;

local function SortByDisplayOrder(p22, p23) -- Line: 155
    -- upvalues: u5 (ref)
    if p22.displayOrder == p23.displayOrder then
        return (u5[p22] or 0) < (u5[p23] or 0);
    end;

    return p22.displayOrder < p23.displayOrder;
end;

local function UpdateAvailableCases(p24) -- Line: 164
    -- upvalues: u4 (ref), HttpService (copy), u5 (ref), ScheduleCasesUpdateAtNextBoundary (copy), u2 (copy)
    u4 = HttpService:JSONDecode(p24);
    u5 = {};

    for i, v in ipairs(u4) do
        u5[v] = i;
    end;

    ScheduleCasesUpdateAtNextBoundary();

    if #u2:GetConnections() > 0 then
        u2:Fire(u4);
    end;
end;

function u1.GetCreationTimestamp(p25) -- Line: 180
    local createdAt = p25.createdAt;
    local v26;

    if createdAt == nil then
        v26 = nil;
    else
        local v27 = tonumber(createdAt);

        if v27 then
            if v27 > 10000000000 then
                v26 = math.floor(v27 / 1000);
            else
                v26 = math.floor(v27);
            end;
        else
            v26 = DateTime.fromIsoDate(createdAt);

            if v26 then
                v26 = v26.UnixTimestamp;
            end;
        end;
    end;

    if not v26 then
        local releaseDate = p25.releaseDate;

        if releaseDate == nil then
            return nil;
        end;

        local v28 = tonumber(releaseDate);

        if v28 then
            if v28 > 10000000000 then
                return math.floor(v28 / 1000);
            end;

            return math.floor(v28);
        end;

        v26 = DateTime.fromIsoDate(releaseDate);

        if v26 then
            v26 = v26.UnixTimestamp;
        end;
    end;

    return v26;
end;

function u1.IsLimited(p29) -- Line: 188
    local discontinueDate = p29.discontinueDate;
    local v30;

    if discontinueDate == nil then
        v30 = nil;
    else
        local v31 = tonumber(discontinueDate);

        if v31 then
            if v31 > 10000000000 then
                v30 = math.floor(v31 / 1000);
            else
                v30 = math.floor(v31);
            end;
        else
            v30 = DateTime.fromIsoDate(discontinueDate);

            if v30 then
                v30 = v30.UnixTimestamp;
            end;
        end;
    end;

    return v30 ~= nil;
end;

function u1.GetBackendOrder(p32) -- Line: 195
    -- upvalues: u5 (ref)
    return u5[p32] or (1 / 0);
end;

function u1.IsCaseEnabled(p33: string) -- Line: 201
    -- upvalues: u1 (copy), IsCaseEnabled (copy)
    local Case = u1.GetCase(p33);
    local v34;

    if Case == nil then
        v34 = false;
    else
        v34 = IsCaseEnabled(Case);
    end;

    return v34;
end;

function u1.IsCaseForSale(p35: string) -- Line: 208
    -- upvalues: u1 (copy), IsCaseEnabled (copy)
    local Case = u1.GetCase(p35);
    local v36;

    if Case == nil then
        v36 = false;
    else
        v36 = IsCaseEnabled(Case, true);
    end;

    return v36;
end;

function u1.HasCaseModel(p37: string) -- Line: 215
    -- upvalues: u1 (copy), u19 (copy), ReplicatedStorage (copy)
    local Case = u1.GetCase(p37);
    local v38;

    if Case == nil then
        v38 = false;
    else
        if u19[Case.caseType] then
            return true;
        end;

        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("CaseModels");
        end;

        if Assets == nil then
            v38 = false;
        else
            v38 = Assets:FindFirstChild(Case.name) ~= nil;
        end;
    end;

    return v38;
end;

function u1.GetCaseByName(p39: string) -- Line: 222
    -- upvalues: u4 (ref)
    if not u4 then
        return nil;
    end;

    for _, v in ipairs(u4) do
        if v.name == p39 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetCase(p40: string) -- Line: 234
    -- upvalues: u4 (ref)
    if not u4 then
        return nil;
    end;

    for _, v in ipairs(u4) do
        if v.caseId == p40 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetFeaturedCases(u41: number) -- Line: 246
    -- upvalues: u4 (ref), IsCaseEnabled (copy), u19 (copy), ReplicatedStorage (copy), SortByDisplayOrder (copy), RemoveFromArray (copy)
    local v42 = {};

    for _, v in ipairs(u4) do
        if v.isFeatured and IsCaseEnabled(v) then
            local v43;

            if u19[v.caseType] then
                v43 = true;
            else
                local Assets = ReplicatedStorage:FindFirstChild("Assets");

                if Assets then
                    Assets = Assets:FindFirstChild("CaseModels");
                end;

                if Assets == nil then
                    v43 = false;
                else
                    v43 = Assets:FindFirstChild(v.name) ~= nil;
                end;
            end;

            if v43 then
                table.insert(v42, v);
            end;
        end;
    end;

    table.sort(v42, SortByDisplayOrder);
    RemoveFromArray(v42, function(p44, p45) -- Line: 255
        -- upvalues: u41 (copy)
        return u41 < p44;
    end);

    return v42;
end;

function u1.GetCases() -- Line: 263
    -- upvalues: u4 (ref), IsCaseEnabled (copy), u19 (copy), ReplicatedStorage (copy), SortByDisplayOrder (copy)
    local v46 = {};

    for _, v in ipairs(u4) do
        if IsCaseEnabled(v) then
            local v47;

            if u19[v.caseType] then
                v47 = true;
            else
                local Assets = ReplicatedStorage:FindFirstChild("Assets");

                if Assets then
                    Assets = Assets:FindFirstChild("CaseModels");
                end;

                if Assets == nil then
                    v47 = false;
                else
                    v47 = Assets:FindFirstChild(v.name) ~= nil;
                end;
            end;

            if v47 then
                table.insert(v46, v);
            end;
        end;
    end;

    table.sort(v46, SortByDisplayOrder);

    return v46;
end;

function u1.ObserveAvailableCases(p48: function) -- Line: 276
    -- upvalues: u2 (copy), u4 (ref)
    local u49 = u2:Connect(p48);

    if u4 then
        p48(u4);
    end;

    return function() -- Line: 281
        -- upvalues: u49 (copy)
        u49:Disconnect();
    end;
end;

local function SyncAvailableCases() -- Line: 289
    -- upvalues: ReplicatedStorage (copy), UpdateAvailableCases (copy)
    local Attribute = ReplicatedStorage:GetAttribute("AvaiableCases");

    if Attribute then
        UpdateAvailableCases(Attribute);
    end;
end;

local Attribute = ReplicatedStorage:GetAttribute("AvaiableCases");

if Attribute then
    UpdateAvailableCases(Attribute);
end;

ReplicatedStorage:GetAttributeChangedSignal("AvaiableCases"):Connect(SyncAvailableCases);

return u1;