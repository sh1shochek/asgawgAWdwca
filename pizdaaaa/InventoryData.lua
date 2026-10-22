-- ReplicatedStorage.GameClient.InventoryData
-- Script path: ReplicatedStorage.GameClient.InventoryData
-- Decompile time: 19.07 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = {
    Equipment = {},
    Containers = {},
    ["Graphic Art"] = {
        Badges = {},
        Graffiti = {},
        Stickers = {},
        ["Name Tags"] = {},
        KillTracks = {}
    }
};
local u8 = {};
local u9 = false;

local function QueueUpdated() -- Line: 40
    -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (copy)
    if u9 then
        return;
    end;

    u9 = true;
    task.defer(function() -- Line: 47
        -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
        u9 = false;

        for _, v in u7.Equipment do
            for _, v2 in v do
                for i, v3 in v2 do
                    v3.TradeLocked = u8[i];
                end;
            end;
        end;

        u1.Updated:Fire();
    end);
end;

local function AddItem(p10) -- Line: 62
    -- upvalues: u7 (ref)
    if p10.Type ~= "Equipment" then
        if p10.Type ~= "Container" then
            if p10.Type == "GraphicArt" then
                local v11 = u7["Graphic Art"] or {};
                u7["Graphic Art"] = v11;
                local v12 = v11[p10.Category];

                if not v12 then
                    v12 = {};
                    v11[p10.Category] = v12;
                end;

                local v13 = v12[p10.ItemName] or {};
                v13[p10.ItemId] = p10.Category == "Badges" and ({
                    EquippedCT = false,
                    EquippedT = false
                } or {}) or {};
                v12[p10.ItemName] = v13;
            end;

            return;
        end;

        local v14 = u7.Containers[p10.ItemName] or {};
        v14[p10.ItemId] = true;
        u7.Containers[p10.ItemName] = v14;

        return;
    end;

    local v15 = u7.Equipment[p10.WeaponName] or {};
    local v16 = v15[p10.SkinName] or {};
    v16[p10.SkinId] = {
        EquippedCT = false,
        EquippedT = false,
        Date = p10.Date or 0,
        Stickers = {},
        NameTag = p10.NameTag,
        KillTrack = p10.KillTrack or nil,
        KillTrackColor = p10.KillTrackColor or nil
    };
    v15[p10.SkinName] = v16;
    u7.Equipment[p10.WeaponName] = v15;
end;

local function RemoveItem(p17) -- Line: 99
    -- upvalues: u7 (ref)
    if p17.Type == "Equipment" then
        local v18 = u7.Equipment[p17.WeaponName];
        local v19;

        if v18 then
            v19 = v18[p17.SkinName];
        else
            v19 = v18;
        end;

        if not v19 then
            return;
        end;

        v19[p17.SkinId] = nil;

        if not next(v19) then
            v18[p17.SkinName] = nil;
        end;

        if not next(v18) then
            u7.Equipment[p17.WeaponName] = nil;
        end;
    elseif p17.Type == "Container" then
        local v20 = u7.Containers[p17.ItemName];

        if not v20 then
            return;
        end;

        v20[p17.ItemId] = nil;

        if not next(v20) then
            u7.Containers[p17.ItemName] = nil;
        end;
    elseif p17.Type == "GraphicArt" then
        local v21 = u7["Graphic Art"][p17.Category];
        local v22;

        if v21 then
            v22 = v21[p17.ItemName];
        else
            v22 = v21;
        end;

        if not v22 then
            return;
        end;

        v22[p17.ItemId] = nil;

        if not next(v22) then
            v21[p17.ItemName] = nil;
        end;
    end;
end;

function u1.Get() -- Line: 147
    -- upvalues: u7 (ref)
    return u7;
end;

function u1.IsLocked(p23: string) -- Line: 151
    -- upvalues: u8 (ref)
    return u8[p23] == true;
end;

function u1.Apply(p24, p25) -- Line: 155
    -- upvalues: RemoveItem (copy), AddItem (copy), u9 (ref), u7 (ref), u8 (ref), u1 (copy)
    for _, v in p24 do
        RemoveItem(v);
    end;

    for _, v in p25 do
        AddItem(v);
    end;

    if u9 then
        return;
    end;

    u9 = true;
    task.defer(function() -- Line: 47
        -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
        u9 = false;

        for _, v in u7.Equipment do
            for _, v2 in v do
                for i, v3 in v2 do
                    v3.TradeLocked = u8[i];
                end;
            end;
        end;

        u1.Updated:Fire();
    end);
end;

function u1.SetEquipped(p26: string, p27: string, p28: string, p29: string) -- Line: 167
    -- upvalues: u6 (ref), u5 (ref), u7 (ref), u1 (copy)
    local v30 = `Equipped{p26}`;
    local v31 = u6 and u6.Get(p27) or u5 and u5.GetCategory(p27);
    local v32;

    if v31 then
        if v31.Data and v31.Data.Type == "Melee" then
            v32 = true;
        else
            v32 = v31.GuiInformation and v31.GuiInformation.LoadoutCategory == "Melee";
        end;
    else
        v32 = v31;
    end;

    local v33 = v31 and v31.GuiInformation and v31.GuiInformation.LoadoutCategory == "Gloves";

    if u7.Equipment then
        for i, v in u7.Equipment do
            local v34 = u6 and u6.Get(i) or u5 and u5.GetCategory(i);
            local v35;

            if v34 then
                if v34.Data and v34.Data.Type == "Melee" then
                    v35 = true;
                else
                    v35 = v34.GuiInformation and v34.GuiInformation.LoadoutCategory == "Melee";
                end;
            else
                v35 = v34;
            end;

            if i == p27 and true or (v32 and v35 and v35 or v33 and (v34 and v34.GuiInformation and v34.GuiInformation.LoadoutCategory == "Gloves")) then
                for _, v2 in v do
                    for _, v3 in v2 do
                        v3[v30] = false;
                    end;
                end;
            end;
        end;

        local v36 = u7.Equipment[p27];

        if v36 then
            v36 = v36[p28];
        end;

        if v36 then
            v36 = v36[p29];
        end;

        if v36 then
            v36[v30] = true;
        end;
    end;

    local v37 = u7["Graphic Art"] and u7["Graphic Art"][p27];

    if v37 then
        for _, v in v37 do
            for _, v2 in v do
                v2[v30] = false;
            end;
        end;

        local v38 = v37[p28];

        if v38 then
            v38 = v38[p29];
        end;

        if v38 then
            v38[v30] = true;
        end;
    end;

    u1.Updated:Fire();
end;

function u1.Init(p39) -- Line: 218
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u1 (copy)
    u2 = p39:GetModule("Network");
    u3 = p39:GetModule("Signal");
    u4 = p39:GetModule("Enums");
    u5 = p39:GetModule("ItemManager");
    u6 = p39:GetModule("WeaponManager");
    u1.Updated = u3.new();
end;

function u1.Start2(p40) -- Line: 235
    -- upvalues: u2 (ref), u4 (ref), u7 (ref), u9 (ref), u8 (ref), u1 (copy), AddItem (copy), RemoveItem (copy), HttpService (copy), LocalPlayer (copy)
    u2.Gui.InventoryUpdate.On(function(p41) -- Line: 244
        -- upvalues: u4 (ref), u7 (ref), u9 (ref), u8 (ref), u1 (ref)
        if not p41 then
            return;
        end;

        local v42 = {};

        for i, v in p41.Equipment do
            local v43 = u4.Weapons[i];
            local v44 = u4.SkinsNum[i];

            if v43 and v44 then
                local v45 = {};

                for i2, v2 in v do
                    local v46 = v44[i2];

                    if v46 then
                        v45[v46] = v2;
                    end;
                end;

                v42[v43] = v45;
            end;
        end;

        local Graphic_Art = p41.Graphic_Art;
        Graphic_Art["Name Tags"] = Graphic_Art.NameTags;
        Graphic_Art.NameTags = nil;
        u7 = {
            Equipment = v42,
            Containers = p41.Containers,
            ["Graphic Art"] = Graphic_Art
        };

        if u9 then
            return;
        end;

        u9 = true;
        task.defer(function() -- Line: 47
            -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
            u9 = false;

            for _, v in u7.Equipment do
                for _, v2 in v do
                    for i, v3 in v2 do
                        v3.TradeLocked = u8[i];
                    end;
                end;
            end;

            u1.Updated:Fire();
        end);
    end);
    u2.Gui.InventoryAdd.On(function(p47) -- Line: 287
        -- upvalues: AddItem (ref), u9 (ref), u7 (ref), u8 (ref), u1 (ref)
        AddItem(p47);

        if u9 then
            return;
        end;

        u9 = true;
        task.defer(function() -- Line: 47
            -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
            u9 = false;

            for _, v in u7.Equipment do
                for _, v2 in v do
                    for i, v3 in v2 do
                        v3.TradeLocked = u8[i];
                    end;
                end;
            end;

            u1.Updated:Fire();
        end);
    end);
    u2.Gui.InventoryRemove.On(function(p48) -- Line: 293
        -- upvalues: RemoveItem (ref), u9 (ref), u7 (ref), u8 (ref), u1 (ref)
        RemoveItem(p48);

        if u9 then
            return;
        end;

        u9 = true;
        task.defer(function() -- Line: 47
            -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
            u9 = false;

            for _, v in u7.Equipment do
                for _, v2 in v do
                    for i, v3 in v2 do
                        v3.TradeLocked = u8[i];
                    end;
                end;
            end;

            u1.Updated:Fire();
        end);
    end);
    u2.Gui.KillTrackUpdate.On(function(p49) -- Line: 298
        -- upvalues: u4 (ref), u7 (ref), u9 (ref), u8 (ref), u1 (ref)
        local v50 = u4.Weapons[p49.WeaponName];
        local v51 = u4.SkinsNum[p49.WeaponName] and u4.SkinsNum[p49.WeaponName][p49.SkinName];

        if v50 then
            v50 = u7.Equipment[v50];
        end;

        if v50 then
            v50 = v50[v51];
        end;

        if v50 then
            v50 = v50[p49.SkinId];
        end;

        if not v50 then
            return;
        end;

        v50.KillTrack = p49.KillTrack;

        if u9 then
            return;
        end;

        u9 = true;
        task.defer(function() -- Line: 47
            -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
            u9 = false;

            for _, v in u7.Equipment do
                for _, v2 in v do
                    for i, v3 in v2 do
                        v3.TradeLocked = u8[i];
                    end;
                end;
            end;

            u1.Updated:Fire();
        end);
    end);
    u2.Gui.KillTrackColorUpdate.On(function(p52) -- Line: 313
        -- upvalues: u4 (ref), u7 (ref), u9 (ref), u8 (ref), u1 (ref)
        local v53 = u4.Weapons[p52.WeaponName];
        local v54 = u4.SkinsNum[p52.WeaponName] and u4.SkinsNum[p52.WeaponName][p52.SkinName];

        if v53 then
            v53 = u7.Equipment[v53];
        end;

        if v53 then
            v53 = v53[v54];
        end;

        if v53 then
            v53 = v53[p52.SkinId];
        end;

        if not v53 then
            return;
        end;

        v53.KillTrackColor = p52.Color;

        if u9 then
            return;
        end;

        u9 = true;
        task.defer(function() -- Line: 47
            -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
            u9 = false;

            for _, v in u7.Equipment do
                for _, v2 in v do
                    for i, v3 in v2 do
                        v3.TradeLocked = u8[i];
                    end;
                end;
            end;

            u1.Updated:Fire();
        end);
    end);

    local function ReadLocked() -- Line: 329
        -- upvalues: u8 (ref), HttpService (ref), LocalPlayer (ref), u9 (ref), u7 (ref), u1 (ref)
        u8 = {};

        for _, v in HttpService:JSONDecode(LocalPlayer:GetAttribute("TradeLocked")) do
            u8[v] = true;
        end;

        if u9 then
            return;
        end;

        u9 = true;
        task.defer(function() -- Line: 47
            -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
            u9 = false;

            for _, v in u7.Equipment do
                for _, v2 in v do
                    for i, v3 in v2 do
                        v3.TradeLocked = u8[i];
                    end;
                end;
            end;

            u1.Updated:Fire();
        end);
    end;

    LocalPlayer:GetAttributeChangedSignal("TradeLocked"):Connect(ReadLocked);

    if LocalPlayer:GetAttribute("TradeLocked") then
        ReadLocked();
    end;

    u2.Gui.InventoryEquip.On(function(p55) -- Line: 345
        -- upvalues: u4 (ref), u7 (ref), u9 (ref), u8 (ref), u1 (ref)
        local v56 = `Equipped{u4.Teams[p55.Team]}`;

        for _, v in p55.Changes do
            local v57 = u7.Equipment[v.WeaponName];

            if v57 then
                v57 = v57[v.SkinName];
            end;

            if v57 then
                v57 = v57[v.SkinId];
            end;

            if not v57 and u7["Graphic Art"] then
                v57 = u7["Graphic Art"][v.WeaponName];

                if v57 then
                    v57 = v57[v.SkinName];
                end;

                if v57 then
                    v57 = v57[v.SkinId];
                end;
            end;

            if v57 then
                v57[v56] = v.Equipped;
            end;
        end;

        if u9 then
            return;
        end;

        u9 = true;
        task.defer(function() -- Line: 47
            -- upvalues: u9 (ref), u7 (ref), u8 (ref), u1 (ref)
            u9 = false;

            for _, v in u7.Equipment do
                for _, v2 in v do
                    for i, v3 in v2 do
                        v3.TradeLocked = u8[i];
                    end;
                end;
            end;

            u1.Updated:Fire();
        end);
    end);
end;

return u1;