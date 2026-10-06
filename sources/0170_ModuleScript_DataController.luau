-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Promise = require(ReplicatedStorage.Shared.Promise);
local Sift = require(ReplicatedStorage.Packages.Sift);
local u2 = { "Serial", "Pattern" };
local u3 = { "OriginalOwner", "Owner" };
local u4 = {};
local u5 = {};

local function FireListeners(p6: userdata, p7: string, p8: table) -- Line: 42
    -- upvalues: u1 (copy), Promise (copy)
    local v9 = u1.Get(p6, p7);

    for _, v in pairs(p8) do
        Promise.try(v, v9);
    end;
end;

local function ExecuteListeners(p10: userdata, p11: table) -- Line: 52
    -- upvalues: u5 (copy), FireListeners (copy)
    local v12 = u5[p10];

    if not v12 then
        return;
    end;

    local v13 = "";

    for i, v in ipairs(p11) do
        if i <= 1 then
            v13 = v;
        else
            v13 = `{v13}.{v}`;
        end;

        local v14 = v12[v13];

        if v14 then
            FireListeners(p10, v13, v14);
        end;
    end;
end;

local function DenormalizeInventoryItemFromRemote(p15) -- Line: 69
    -- upvalues: Sift (copy), u2 (copy), u3 (copy)
    local v16 = Sift.Dictionary.copyDeep(p15);

    for _, v in u2 do
        if v16[v] ~= nil and typeof(v16[v]) == "string" then
            v16[v] = tonumber(v16[v]) or v16[v];
        end;
    end;

    if v16.MetaData and typeof(v16.MetaData) == "table" then
        for _, v in u3 do
            if v16.MetaData[v] ~= nil and typeof(v16.MetaData[v]) == "string" then
                v16.MetaData[v] = tonumber(v16.MetaData[v]) or v16.MetaData[v];
            end;
        end;
    end;

    return v16;
end;

local function ShouldDenormalizeInventoryItem(p17) -- Line: 89
    if typeof(p17) ~= "table" then
        return false;
    end;

    local MetaData = p17.MetaData;
    local v18 = typeof(MetaData) == "table";

    if typeof(p17.Serial) == "string" or (typeof(p17.Pattern) == "string" or v18 and typeof(MetaData.OriginalOwner) == "string") then
        v18 = true;
    elseif v18 then
        v18 = typeof(MetaData.Owner) == "string";
    end;

    return v18;
end;

function u1.ApplyInventoryDelta(p19: userdata, p20: table, p21: table?) -- Line: 104
    -- upvalues: u4 (copy), ShouldDenormalizeInventoryItem (copy), DenormalizeInventoryItemFromRemote (copy), ExecuteListeners (copy)
    local v22 = u4[p19];

    if not (v22 and v22.Inventory) then
        return;
    end;

    local v23 = false;

    if p21 then
        local v24 = {};

        for _, v in ipairs(p21) do
            v24[v] = true;
        end;

        for i = #v22.Inventory, 1, -1 do
            local v25 = v22.Inventory[i];
            local v26;

            if v25 and (v25._id and v24[v25._id]) then
                table.remove(v22.Inventory, i);
                v26 = i;
                v23 = true;
            else
                v26 = i;
            end;
        end;
    end;

    local v27 = {};

    for _, v in ipairs(v22.Inventory) do
        if v and v._id then
            v27[v._id] = true;
        end;
    end;

    for _, v in ipairs(p20) do
        local v28;

        if ShouldDenormalizeInventoryItem(v) then
            v28 = DenormalizeInventoryItemFromRemote(v);
        else
            v28 = v;
        end;

        if v28 and (v28._id and not v27[v28._id]) then
            table.insert(v22.Inventory, v28);
            v27[v28._id] = true;
            v23 = true;
        end;
    end;

    if v23 then
        ExecuteListeners(p19, { "Inventory" });
    end;
end;

function u1.IsDataLoaded(p29: userdata) -- Line: 150
    -- upvalues: u4 (copy)
    return u4[p29] ~= nil;
end;

function u1.WaitForDataLoaded(p30: userdata) -- Line: 156
    -- upvalues: u4 (copy)
    local v31 = 0;

    while not u4[p30] do
        v31 = v31 + task.wait();

        if v31 >= 60 then
            error((`[DataController] Failed to load player profile for {p30.Name} after {60} seconds`));
        end;
    end;

    return u4[p30];
end;

function u1.Get(p32: userdata, ...) -- Line: 169
    -- upvalues: u4 (copy)
    local v33 = u4[p32];

    if not v33 then
        return nil;
    end;

    local v34 = {};

    for _, v in table.pack(...) do
        local v35 = v33;

        for _, v2 in string.split(v, ".") do
            v33 = v33[v2];

            if not v33 then
                break;
            end;
        end;

        table.insert(v34, v33);
        v33 = v35;
    end;

    return table.unpack(v34);
end;

function u1.RemoveListener(p36: userdata, p37: string, p38: string) -- Line: 192
    -- upvalues: u5 (copy)
    if u5[p36] and u5[p36][p37] then
        u5[p36][p37][p38] = nil;

        if next(u5[p36][p37]) == nil then
            u5[p36][p37] = nil;
        end;
    end;
end;

function u1.CreateListener(p39: userdata, p40: string, p41: function) -- Line: 204
    -- upvalues: HttpService (copy), u5 (copy), u1 (copy), Promise (copy)
    local v42 = HttpService:GenerateGUID(false);
    u5[p39] = u5[p39] or {};
    u5[p39][p40] = u5[p39][p40] or {};
    u5[p39][p40][v42] = p41;
    local v43 = u1.Get(p39, p40);

    if v43 ~= nil then
        Promise.try(p41, v43);
    end;

    return v42;
end;

function u1.Initialize() -- Line: 220
    -- upvalues: Remotes (copy), u5 (copy), Stock (copy), u4 (copy), FireListeners (copy), ExecuteListeners (copy)
    Remotes.PlayerData.PlayerDataEvent.Listen(function(p44: table) -- Line: 221
        -- upvalues: u5 (ref), Stock (ref), u4 (ref), FireListeners (ref)
        local v45 = u5[p44.Player];

        if p44.Data and p44.Data.Inventory then
            Stock.InjectStockItems(p44.Data.Inventory);
        end;

        u4[p44.Player] = p44.Data;

        if v45 then
            for i, v in pairs(v45) do
                FireListeners(p44.Player, i, v);
            end;
        end;
    end);
    Remotes.PlayerData.PlayerDataChanged.Listen(function(p46: table) -- Line: 234
        -- upvalues: u4 (ref), ExecuteListeners (ref)
        local Player = p46.Player;
        local v47 = u4[Player];

        if v47 then
            for i, v in pairs(p46.Data) do
                local string_split_ret = string.split(i, ".");
                local v48 = v47;

                for i2 = 1, #string_split_ret - 1 do
                    local v49 = string_split_ret[i2];

                    if typeof(v47[v49]) ~= "table" then
                        v47[v49] = {};
                    end;

                    v47 = v47[v49];
                    local _ = i2;
                end;

                v47[string_split_ret[#string_split_ret]] = v;
                ExecuteListeners(Player, string_split_ret);
                v47 = v48;
            end;

            return;
        end;

        warn((`[DataController] Received data change for {Player.Name} but profile not loaded yet. Requesting full profile.`));
    end);
end;

function u1.Start() -- Line: 259
    -- upvalues: Remotes (copy), Players (copy), u1 (copy), u5 (copy), u4 (copy)
    Remotes.PlayerData.RetrieveAllPlayerData.Send();
    Remotes.Store.NewInventoryItem.Listen(function(p50: table) -- Line: 262
        -- upvalues: Players (ref), u1 (ref)
        local v51 = tonumber(p50.Player);

        if not v51 then
            return;
        end;

        local PlayerByUserId = Players:GetPlayerByUserId(v51);

        if PlayerByUserId and PlayerByUserId:IsDescendantOf(Players) then
            u1.ApplyInventoryDelta(PlayerByUserId, p50.Items, p50.DeletedItemIds);
        end;
    end);
    Players.PlayerRemoving:Connect(function(p52: userdata) -- Line: 270
        -- upvalues: u5 (ref), u4 (ref)
        u5[p52] = nil;
        u4[p52] = nil;
    end);
end;

return u1;