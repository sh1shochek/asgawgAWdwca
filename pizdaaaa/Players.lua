-- ReplicatedStorage.Controllers.Observers.Players
-- Script path: ReplicatedStorage.Controllers.Observers.Players
-- Decompile time: 12.56 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Observers = require(ReplicatedStorage.Packages.Observers);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local LocalPlayer = Players.LocalPlayer;
local CreateWeaponModel = require(script.Components.CreateWeaponModel);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = 1;
local u8 = false;
local u9 = nil;

local function profileScope(p10: string, p11: function) -- Line: 37
    debug.profilebegin(p10);
    local success, result = pcall(p11);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    return result;
end;

local function requestCharacterVisualRebuild(p12: userdata) -- Line: 47
    -- upvalues: u5 (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), Players (copy), u9 (ref)
    if u5[p12] then
        return;
    end;

    u5[p12] = true;
    table.insert(u6, p12);

    if u8 then
        return;
    end;

    u8 = true;
    task.spawn(function() -- Line: 59
        -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
        while u7 <= #u6 do
            RunService.Heartbeat:Wait();
            local u13 = u6[u7];
            u7 = u7 + 1;

            if u5[u13] then
                u5[u13] = nil;

                if u13.Parent == Players then
                    task.spawn(function() -- Line: 73
                        -- upvalues: u9 (ref), u13 (copy)
                        local success, result = pcall(u9, u13);

                        if not success then
                            warn((`[ThirdPersonWeaponModels] {u13.Name} presentation rebuild failed: {result}`));
                        end;
                    end);
                end;
            end;
        end;

        table.clear(u6);
        u7 = 1;
        u8 = false;
    end);
end;

local function cancelCharacterVisualRebuild(p14: userdata) -- Line: 88
    -- upvalues: u5 (copy)
    u5[p14] = nil;
end;

local function waitForPresentationRig(p15: userdata) -- Line: 92
    for _, v in { "HumanoidRootPart", "UpperTorso", "LeftHand", "RightHand" } do
        local v16 = p15:FindFirstChild(v) or p15:WaitForChild(v, 10);

        if not (v16 and v16:IsA("BasePart")) then
            return false;
        end;
    end;

    return true;
end;

local function clearCurrentEquippedVisuals(p17: userdata) -- Line: 104
    -- upvalues: u1 (copy), u2 (copy), CharacterResolver (copy), CreateWeaponModel (copy)
    u1[p17] = nil;
    u2[p17] = nil;
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p17);

    if PlayerCharacter then
        for _, child in ipairs(PlayerCharacter:GetChildren()) do
            if child:IsA("Folder") and (child.Name == "WeaponAttachments" or child.Name == "WeaponModel") then
                child:ClearAllChildren();
            end;
        end;
    end;

    CreateWeaponModel.ClearPlayerCache(p17);
end;

local function buildInventorySlots(p18: userdata) -- Line: 122
    -- upvalues: HttpService (copy)
    local v19 = {};

    for i = 1, 3 do
        local Attribute = p18:GetAttribute("Slot" .. i);
        local v20;

        if Attribute then
            v19[i] = HttpService:JSONDecode(Attribute);
            v20 = i;
        else
            v20 = i;
        end;
    end;

    return v19;
end;

local function stickerSignature(p21) -- Line: 135
    if typeof(p21) ~= "table" then
        return "";
    end;

    local v22 = {};

    for i, v in ipairs(p21) do
        if typeof(v) == "table" then
            local Position = v.Position;
            local v23 = typeof(Position) == "table" and (Position.Rotation or "") or "";
            local v24 = typeof(Position) == "table" and (Position.X or "") or "";
            local v25 = typeof(Position) == "table" and (Position.Y or "") or "";
            v22[i] = string.format("%s@%s,%s,%s", tostring(v.Sticker or ""), tostring(v23), tostring(v24), (tostring(v25)));
        else
            v22[i] = tostring(v);
        end;
    end;

    return table.concat(v22, ";");
end;

local function visualSignature(p26) -- Line: 158
    -- upvalues: stickerSignature (copy)
    return typeof(p26) ~= "table" and "" or table.concat({
        tostring(p26.Identifier or ""),
        tostring(p26.Name or ""),
        tostring(p26.Skin or ""),
        tostring(p26.Float or ""),
        tostring(p26.StatTrack or ""),
        tostring(p26.NameTag or ""),
        stickerSignature(p26.Stickers)
    }, "|");
end;

local function getEquippedWeaponName(p27) -- Line: 176
    return typeof(p27) == "string" and (string.match(p27, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";
end;

local function createInventoryListener(u28: userdata) -- Line: 188
    -- upvalues: Observers (copy), DebugFlags (copy), u5 (copy), clearCurrentEquippedVisuals (copy), HttpService (copy), visualSignature (copy), u1 (copy), u2 (copy), CreateWeaponModel (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), Players (copy), u9 (ref)
    return Observers.observeAttribute(u28, "CurrentEquipped", function(p29) -- Line: 189
        -- upvalues: DebugFlags (ref), u28 (copy), u5 (ref), clearCurrentEquippedVisuals (ref), HttpService (ref), visualSignature (ref), u1 (ref), u2 (ref), CreateWeaponModel (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref)
        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            local v30 = warn;
            local Name = u28.Name;
            local v31 = typeof(p29) == "string" and (#p29 or -1) or -1;
            v30(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(Name, (tostring(v31))));
        end;

        if not p29 then
            u5[u28] = nil;
            clearCurrentEquippedVisuals(u28);

            return function() -- Line: 202
            end;
        end;

        local u32 = HttpService:JSONDecode(p29);
        local v33 = visualSignature(u32);

        if v33 ~= "" and u1[u28] == v33 then
            local v34 = u32.IsSuppressed == true;

            if u2[u28] ~= v34 then
                u2[u28] = v34;

                local function v35() -- Line: 213
                    -- upvalues: CreateWeaponModel (ref), u28 (ref), u32 (copy)
                    return CreateWeaponModel.RefreshSuppressorState(u28, u32);
                end;

                debug.profilebegin("Observers.Players.RefreshSuppressorState");
                local success, result = pcall(v35);
                debug.profileend();

                if not success then
                    error(result, 0);
                end;

                if not result then
                    local v36 = u28;

                    if not u5[v36] then
                        u5[v36] = true;
                        table.insert(u6, v36);

                        if not u8 then
                            u8 = true;
                            task.spawn(function() -- Line: 59
                                -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                                while u7 <= #u6 do
                                    RunService.Heartbeat:Wait();
                                    local u37 = u6[u7];
                                    u7 = u7 + 1;

                                    if u5[u37] then
                                        u5[u37] = nil;

                                        if u37.Parent == Players then
                                            task.spawn(function() -- Line: 73
                                                -- upvalues: u9 (ref), u37 (copy)
                                                local success2, result2 = pcall(u9, u37);

                                                if not success2 then
                                                    warn((`[ThirdPersonWeaponModels] {u37.Name} presentation rebuild failed: {result2}`));
                                                end;
                                            end);
                                        end;
                                    end;
                                end;

                                table.clear(u6);
                                u7 = 1;
                                u8 = false;
                            end);
                        end;
                    end;
                end;
            end;

            return function() -- Line: 220
            end;
        end;

        u1[u28] = v33;
        u2[u28] = u32.IsSuppressed == true;
        local v38 = u28;

        if not u5[v38] then
            u5[v38] = true;
            table.insert(u6, v38);

            if not u8 then
                u8 = true;
                task.spawn(function() -- Line: 59
                    -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                    while u7 <= #u6 do
                        RunService.Heartbeat:Wait();
                        local u39 = u6[u7];
                        u7 = u7 + 1;

                        if u5[u39] then
                            u5[u39] = nil;

                            if u39.Parent == Players then
                                task.spawn(function() -- Line: 73
                                    -- upvalues: u9 (ref), u39 (copy)
                                    local success, result = pcall(u9, u39);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u39.Name} presentation rebuild failed: {result}`));
                                    end;
                                end);
                            end;
                        end;
                    end;

                    table.clear(u6);
                    u7 = 1;
                    u8 = false;
                end);
            end;
        end;

        return function() -- Line: 229
            -- upvalues: u28 (ref), clearCurrentEquippedVisuals (ref)
            if u28:GetAttribute("CurrentEquipped") ~= nil then
                return;
            end;

            clearCurrentEquippedVisuals(u28);
        end;
    end);
end;

local function refreshHolster(p40: userdata, p41: string) -- Line: 240
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    local success, result = pcall(CreateWeaponModel[p41], p40);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(p40.Name, p41, (tostring(result))));
    end;
end;

local function refreshObjectiveKitHolster(p42: userdata) -- Line: 247
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    local success, result = pcall(CreateWeaponModel.RefreshObjectiveKitHolster, p42);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(p42.Name, "RefreshObjectiveKitHolster", (tostring(result))));
    end;
end;

local function refreshBombHolster(p43: userdata) -- Line: 251
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    debug.profilebegin("Observers.Players.RefreshBombHolster");
    local success, result = pcall(CreateWeaponModel.RefreshBombHolster, p43);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(p43.Name, "RefreshBombHolster", (tostring(result))));
    end;

    debug.profileend();
end;

local function scheduleHolsterRefresh(u44: userdata, u45: table, u46: function) -- Line: 259
    -- upvalues: u5 (copy), Players (copy)
    if u5[u44] or u45[u44] then
        return;
    end;

    u45[u44] = true;
    task.defer(function() -- Line: 265
        -- upvalues: u45 (copy), u44 (copy), Players (ref), u5 (ref), u46 (copy)
        u45[u44] = nil;

        if u44.Parent == Players and not u5[u44] then
            u46(u44);
        end;
    end);
end;

local function createObjectiveKitListener(u47: userdata) -- Line: 275
    -- upvalues: u3 (copy), refreshObjectiveKitHolster (copy), u5 (copy), Players (copy), Observers (copy)
    local function onKitChanged() -- Line: 276
        -- upvalues: u47 (copy), u3 (ref), refreshObjectiveKitHolster (ref), u5 (ref), Players (ref)
        local u48 = u47;
        local u49 = u3;
        local u50 = refreshObjectiveKitHolster;

        if not (u5[u48] or u49[u48]) then
            u49[u48] = true;
            task.defer(function() -- Line: 265
                -- upvalues: u49 (copy), u48 (copy), Players (ref), u5 (ref), u50 (copy)
                u49[u48] = nil;

                if u48.Parent == Players and not u5[u48] then
                    u50(u48);
                end;
            end);
        end;

        return function() -- Line: 278
        end;
    end;

    local u51 = Observers.observeAttribute(u47, "HasDefuseKit", onKitChanged);
    local u52 = Observers.observeAttribute(u47, "HasRescueKit", onKitChanged);
    local u53 = u47:GetAttributeChangedSignal("Team"):Connect(onKitChanged);

    return function() -- Line: 285
        -- upvalues: u51 (copy), u52 (copy), u53 (copy)
        u51();
        u52();
        u53:Disconnect();
    end;
end;

local function createBombHolsterListener(u54: userdata) -- Line: 294
    -- upvalues: u4 (copy), refreshBombHolster (copy), u5 (copy), Players (copy), Observers (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), u9 (ref)
    local Attribute = u54:GetAttribute("CurrentEquipped");
    local u55 = typeof(Attribute) == "string" and (string.match(Attribute, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";
    local u59 = u54:GetAttributeChangedSignal("Slot5"):Connect(function() -- Line: 298
        -- upvalues: u54 (copy), u4 (ref), refreshBombHolster (ref), u5 (ref), Players (ref)
        local u56 = u54;
        local u57 = u4;
        local u58 = refreshBombHolster;

        if not u5[u56] then
            if u57[u56] then
                return;
            end;

            u57[u56] = true;
            task.defer(function() -- Line: 265
                -- upvalues: u57 (copy), u56 (copy), Players (ref), u5 (ref), u58 (copy)
                u57[u56] = nil;

                if u56.Parent == Players and not u5[u56] then
                    u58(u56);
                end;
            end);
        end;
    end);
    local u64 = Observers.observeAttribute(u54, "CurrentEquipped", function(p60) -- Line: 306
        -- upvalues: u55 (ref), u54 (copy), u5 (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref)
        local v61 = typeof(p60) == "string" and (string.match(p60, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";

        if v61 == u55 then
            return function() -- Line: 309
            end;
        end;

        u55 = v61;
        local v62 = u54;

        if not u5[v62] then
            u5[v62] = true;
            table.insert(u6, v62);

            if not u8 then
                u8 = true;
                task.spawn(function() -- Line: 59
                    -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                    while u7 <= #u6 do
                        RunService.Heartbeat:Wait();
                        local u63 = u6[u7];
                        u7 = u7 + 1;

                        if u5[u63] then
                            u5[u63] = nil;

                            if u63.Parent == Players then
                                task.spawn(function() -- Line: 73
                                    -- upvalues: u9 (ref), u63 (copy)
                                    local success, result = pcall(u9, u63);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u63.Name} presentation rebuild failed: {result}`));
                                    end;
                                end);
                            end;
                        end;
                    end;

                    table.clear(u6);
                    u7 = 1;
                    u8 = false;
                end);
            end;
        end;

        return function() -- Line: 314
        end;
    end);

    return function() -- Line: 318
        -- upvalues: u59 (copy), u64 (copy)
        u59:Disconnect();
        u64();
    end;
end;

u9 = function(u65: userdata) -- Line: 324
    -- upvalues: CharacterResolver (copy), CreateWeaponModel (copy), waitForPresentationRig (copy), u5 (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), Players (copy), u9 (ref), HttpService (copy), u1 (copy), visualSignature (copy), u2 (copy), buildInventorySlots (copy), DebugFlags (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(u65);

    if not PlayerCharacter or PlayerCharacter:GetAttribute("Dead") == true then
        local function v66() -- Line: 327
            -- upvalues: CreateWeaponModel (ref), u65 (copy)
            CreateWeaponModel.ClearPlayerCache(u65);
        end;

        debug.profilebegin("Observers.Players.RebuildCharacterVisuals.ClearCache");
        local success, result = pcall(v66);
        debug.profileend();

        if not success then
            error(result, 0);
        end;

        return;
    end;

    if not waitForPresentationRig(PlayerCharacter) then
        CreateWeaponModel.ClearPlayerCache(u65);

        return;
    end;

    local function v75() -- Line: 337
        -- upvalues: CharacterResolver (ref), u65 (copy), PlayerCharacter (copy), u5 (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref), HttpService (ref), u1 (ref), visualSignature (ref), u2 (ref), CreateWeaponModel (ref), buildInventorySlots (ref), DebugFlags (ref)
        if CharacterResolver.getPlayerCharacter(u65) == PlayerCharacter and PlayerCharacter:GetAttribute("Dead") ~= true then
            local v67 = false;
            local Attribute = u65:GetAttribute("CurrentEquipped");

            if Attribute then
                local success, result = pcall(function() -- Line: 349
                    -- upvalues: HttpService (ref), Attribute (copy)
                    return HttpService:JSONDecode(Attribute);
                end);

                if success and typeof(result) == "table" then
                    u1[u65] = visualSignature(result);
                    u2[u65] = result.IsSuppressed == true;

                    local function v68() -- Line: 355
                        -- upvalues: CreateWeaponModel (ref), u65 (ref), result (copy), buildInventorySlots (ref)
                        CreateWeaponModel(u65, result, (buildInventorySlots(u65)));
                    end;

                    debug.profilebegin("Observers.Players.RebuildCharacterVisuals.Weapon");
                    local success2, result2 = pcall(v68);
                    debug.profileend();

                    if success2 then
                        v67 = true;
                    else
                        error(result2, 0);
                        v67 = true;
                    end;
                end;
            end;

            if not v67 then
                local function v70() -- Line: 364
                    -- upvalues: u65 (ref), CreateWeaponModel (ref), DebugFlags (ref)
                    local v69 = u65;
                    local success, result = pcall(CreateWeaponModel.RefreshObjectiveKitHolster, v69);

                    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
                        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(v69.Name, "RefreshObjectiveKitHolster", (tostring(result))));
                    end;
                end;

                debug.profilebegin("Observers.Players.RebuildCharacterVisuals.ObjectiveKit");
                local success, result = pcall(v70);
                debug.profileend();

                if not success then
                    error(result, 0);
                end;

                local function v72() -- Line: 367
                    -- upvalues: u65 (ref), CreateWeaponModel (ref), DebugFlags (ref)
                    local v71 = u65;
                    debug.profilebegin("Observers.Players.RefreshBombHolster");
                    local success2, result2 = pcall(CreateWeaponModel.RefreshBombHolster, v71);

                    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success2 then
                        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(v71.Name, "RefreshBombHolster", (tostring(result2))));
                    end;

                    debug.profileend();
                end;

                debug.profilebegin("Observers.Players.RebuildCharacterVisuals.BombHolster");
                local success2, result2 = pcall(v72);
                debug.profileend();

                if not success2 then
                    error(result2, 0);
                end;
            end;

            return;
        end;

        local v73 = u65;

        if u5[v73] then
            return;
        end;

        u5[v73] = true;
        table.insert(u6, v73);

        if u8 then
            return;
        end;

        u8 = true;
        task.spawn(function() -- Line: 59
            -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
            while u7 <= #u6 do
                RunService.Heartbeat:Wait();
                local u74 = u6[u7];
                u7 = u7 + 1;

                if u5[u74] then
                    u5[u74] = nil;

                    if u74.Parent == Players then
                        task.spawn(function() -- Line: 73
                            -- upvalues: u9 (ref), u74 (copy)
                            local success, result = pcall(u9, u74);

                            if not success then
                                warn((`[ThirdPersonWeaponModels] {u74.Name} presentation rebuild failed: {result}`));
                            end;
                        end);
                    end;
                end;
            end;

            table.clear(u6);
            u7 = 1;
            u8 = false;
        end);
    end;

    debug.profilebegin("Observers.Players.RebuildCharacterVisuals");
    local success, result = pcall(v75);
    debug.profileend();

    if not success then
        error(result, 0);
    end;
end;

return Observers.observePlayer(function(u76: userdata) -- Line: 377
    -- upvalues: LocalPlayer (copy), Observers (copy), DebugFlags (copy), u5 (copy), clearCurrentEquippedVisuals (copy), HttpService (copy), visualSignature (copy), u1 (copy), u2 (copy), CreateWeaponModel (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), Players (copy), u9 (ref), createObjectiveKitListener (copy), createBombHolsterListener (copy), CharacterResolver (copy), u3 (copy), u4 (copy)
    if u76 == LocalPlayer then
        return function() -- Line: 380
        end;
    end;

    local u88 = Observers.observeAttribute(u76, "CurrentEquipped", function(p77) -- Line: 189
        -- upvalues: DebugFlags (ref), u76 (copy), u5 (ref), clearCurrentEquippedVisuals (ref), HttpService (ref), visualSignature (ref), u1 (ref), u2 (ref), CreateWeaponModel (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref)
        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            local v78 = warn;
            local Name = u76.Name;
            local v79 = typeof(p77) == "string" and (#p77 or -1) or -1;
            v78(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(Name, (tostring(v79))));
        end;

        if not p77 then
            u5[u76] = nil;
            clearCurrentEquippedVisuals(u76);

            return function() -- Line: 202
            end;
        end;

        local u80 = HttpService:JSONDecode(p77);
        local v81 = visualSignature(u80);

        if v81 ~= "" and u1[u76] == v81 then
            local v82 = u80.IsSuppressed == true;

            if u2[u76] ~= v82 then
                u2[u76] = v82;

                local function v83() -- Line: 213
                    -- upvalues: CreateWeaponModel (ref), u76 (ref), u80 (copy)
                    return CreateWeaponModel.RefreshSuppressorState(u76, u80);
                end;

                debug.profilebegin("Observers.Players.RefreshSuppressorState");
                local success, result = pcall(v83);
                debug.profileend();

                if not success then
                    error(result, 0);
                end;

                if not result then
                    local v84 = u76;

                    if not u5[v84] then
                        u5[v84] = true;
                        table.insert(u6, v84);

                        if not u8 then
                            u8 = true;
                            task.spawn(function() -- Line: 59
                                -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                                while u7 <= #u6 do
                                    RunService.Heartbeat:Wait();
                                    local u85 = u6[u7];
                                    u7 = u7 + 1;

                                    if u5[u85] then
                                        u5[u85] = nil;

                                        if u85.Parent == Players then
                                            task.spawn(function() -- Line: 73
                                                -- upvalues: u9 (ref), u85 (copy)
                                                local success2, result2 = pcall(u9, u85);

                                                if not success2 then
                                                    warn((`[ThirdPersonWeaponModels] {u85.Name} presentation rebuild failed: {result2}`));
                                                end;
                                            end);
                                        end;
                                    end;
                                end;

                                table.clear(u6);
                                u7 = 1;
                                u8 = false;
                            end);
                        end;
                    end;
                end;
            end;

            return function() -- Line: 220
            end;
        end;

        u1[u76] = v81;
        u2[u76] = u80.IsSuppressed == true;
        local v86 = u76;

        if not u5[v86] then
            u5[v86] = true;
            table.insert(u6, v86);

            if not u8 then
                u8 = true;
                task.spawn(function() -- Line: 59
                    -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                    while u7 <= #u6 do
                        RunService.Heartbeat:Wait();
                        local u87 = u6[u7];
                        u7 = u7 + 1;

                        if u5[u87] then
                            u5[u87] = nil;

                            if u87.Parent == Players then
                                task.spawn(function() -- Line: 73
                                    -- upvalues: u9 (ref), u87 (copy)
                                    local success, result = pcall(u9, u87);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u87.Name} presentation rebuild failed: {result}`));
                                    end;
                                end);
                            end;
                        end;
                    end;

                    table.clear(u6);
                    u7 = 1;
                    u8 = false;
                end);
            end;
        end;

        return function() -- Line: 229
            -- upvalues: u76 (ref), clearCurrentEquippedVisuals (ref)
            if u76:GetAttribute("CurrentEquipped") ~= nil then
                return;
            end;

            clearCurrentEquippedVisuals(u76);
        end;
    end);
    local u89 = createObjectiveKitListener(u76);
    local u90 = createBombHolsterListener(u76);
    local u93 = CharacterResolver.observeCharacter(u76, function() -- Line: 387
        -- upvalues: u76 (copy), u5 (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref)
        local v91 = u76;

        if not u5[v91] then
            u5[v91] = true;
            table.insert(u6, v91);

            if not u8 then
                u8 = true;
                task.spawn(function() -- Line: 59
                    -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                    while u7 <= #u6 do
                        RunService.Heartbeat:Wait();
                        local u92 = u6[u7];
                        u7 = u7 + 1;

                        if u5[u92] then
                            u5[u92] = nil;

                            if u92.Parent == Players then
                                task.spawn(function() -- Line: 73
                                    -- upvalues: u9 (ref), u92 (copy)
                                    local success, result = pcall(u9, u92);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u92.Name} presentation rebuild failed: {result}`));
                                    end;
                                end);
                            end;
                        end;
                    end;

                    table.clear(u6);
                    u7 = 1;
                    u8 = false;
                end);
            end;
        end;

        return function() -- Line: 389
        end;
    end);

    return function() -- Line: 391
        -- upvalues: u88 (copy), u89 (copy), u90 (copy), u93 (copy), u3 (ref), u76 (copy), u4 (ref), u5 (ref), CreateWeaponModel (ref), u1 (ref), u2 (ref)
        u88();
        u89();
        u90();
        u93();
        u3[u76] = nil;
        u4[u76] = nil;
        u5[u76] = nil;
        CreateWeaponModel.ClearPlayerCache(u76);
        u1[u76] = nil;
        u2[u76] = nil;
    end;
end);