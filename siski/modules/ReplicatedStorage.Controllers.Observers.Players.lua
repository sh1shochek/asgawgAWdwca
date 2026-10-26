-- ReplicatedStorage.Controllers.Observers.Players
-- class: ModuleScript

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
            local l_warn = warn;
            local Name = u28.Name;
            local v30 = typeof(p29) == "string" and (#p29 or -1) or -1;
            l_warn(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(Name, (tostring(v30))));
        end;

        if not p29 then
            u5[u28] = nil;
            clearCurrentEquippedVisuals(u28);

            return function() -- Line: 202
            end;
        end;

        local u31 = HttpService:JSONDecode(p29);
        local v32 = visualSignature(u31);

        if v32 ~= "" and u1[u28] == v32 then
            local v33 = u31.IsSuppressed == true;

            if u2[u28] ~= v33 then
                u2[u28] = v33;

                local function v34() -- Line: 213
                    -- upvalues: CreateWeaponModel (ref), u28 (ref), u31 (copy)
                    return CreateWeaponModel.RefreshSuppressorState(u28, u31);
                end;

                debug.profilebegin("Observers.Players.RefreshSuppressorState");
                local success, result = pcall(v34);
                debug.profileend();

                if not success then
                    error(result, 0);
                end;

                if not result then
                    local v35 = u28;

                    if not u5[v35] then
                        u5[v35] = true;
                        table.insert(u6, v35);

                        if not u8 then
                            u8 = true;
                            task.spawn(function() -- Line: 59
                                -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                                while u7 <= #u6 do
                                    RunService.Heartbeat:Wait();
                                    local u36 = u6[u7];
                                    u7 = u7 + 1;

                                    if u5[u36] then
                                        u5[u36] = nil;

                                        if u36.Parent == Players then
                                            task.spawn(function() -- Line: 73
                                                -- upvalues: u9 (ref), u36 (copy)
                                                local success2, result2 = pcall(u9, u36);

                                                if not success2 then
                                                    warn((`[ThirdPersonWeaponModels] {u36.Name} presentation rebuild failed: {result2}`));
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

        u1[u28] = v32;
        u2[u28] = u31.IsSuppressed == true;
        local v37 = u28;

        if not u5[v37] then
            u5[v37] = true;
            table.insert(u6, v37);

            if not u8 then
                u8 = true;
                task.spawn(function() -- Line: 59
                    -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                    while u7 <= #u6 do
                        RunService.Heartbeat:Wait();
                        local u38 = u6[u7];
                        u7 = u7 + 1;

                        if u5[u38] then
                            u5[u38] = nil;

                            if u38.Parent == Players then
                                task.spawn(function() -- Line: 73
                                    -- upvalues: u9 (ref), u38 (copy)
                                    local success, result = pcall(u9, u38);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u38.Name} presentation rebuild failed: {result}`));
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

local function refreshHolster(p39: userdata, p40: string) -- Line: 240
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    local success, result = pcall(CreateWeaponModel[p40], p39);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(p39.Name, p40, (tostring(result))));
    end;
end;

local function refreshObjectiveKitHolster(p41: userdata) -- Line: 247
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    local success, result = pcall(CreateWeaponModel.RefreshObjectiveKitHolster, p41);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(p41.Name, "RefreshObjectiveKitHolster", (tostring(result))));
    end;
end;

local function refreshBombHolster(p42: userdata) -- Line: 251
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    debug.profilebegin("Observers.Players.RefreshBombHolster");
    local success, result = pcall(CreateWeaponModel.RefreshBombHolster, p42);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(p42.Name, "RefreshBombHolster", (tostring(result))));
    end;

    debug.profileend();
end;

local function scheduleHolsterRefresh(u43: userdata, u44: table, u45: function) -- Line: 259
    -- upvalues: u5 (copy), Players (copy)
    if u5[u43] or u44[u43] then
        return;
    end;

    u44[u43] = true;
    task.defer(function() -- Line: 265
        -- upvalues: u44 (copy), u43 (copy), Players (ref), u5 (ref), u45 (copy)
        u44[u43] = nil;

        if u43.Parent == Players and not u5[u43] then
            u45(u43);
        end;
    end);
end;

local function createObjectiveKitListener(u46: userdata) -- Line: 275
    -- upvalues: u3 (copy), refreshObjectiveKitHolster (copy), u5 (copy), Players (copy), Observers (copy)
    local function onKitChanged() -- Line: 276
        -- upvalues: u46 (copy), u3 (ref), refreshObjectiveKitHolster (ref), u5 (ref), Players (ref)
        local u47 = u46;
        local u48 = u3;
        local u49 = refreshObjectiveKitHolster;

        if not (u5[u47] or u48[u47]) then
            u48[u47] = true;
            task.defer(function() -- Line: 265
                -- upvalues: u48 (copy), u47 (copy), Players (ref), u5 (ref), u49 (copy)
                u48[u47] = nil;

                if u47.Parent == Players and not u5[u47] then
                    u49(u47);
                end;
            end);
        end;

        return function() -- Line: 278
        end;
    end;

    local u50 = Observers.observeAttribute(u46, "HasDefuseKit", onKitChanged);
    local u51 = Observers.observeAttribute(u46, "HasRescueKit", onKitChanged);
    local u52 = u46:GetAttributeChangedSignal("Team"):Connect(onKitChanged);

    return function() -- Line: 285
        -- upvalues: u50 (copy), u51 (copy), u52 (copy)
        u50();
        u51();
        u52:Disconnect();
    end;
end;

local function createBombHolsterListener(u53: userdata) -- Line: 294
    -- upvalues: u4 (copy), refreshBombHolster (copy), u5 (copy), Players (copy), Observers (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), u9 (ref)
    local Attribute = u53:GetAttribute("CurrentEquipped");
    local u54 = typeof(Attribute) == "string" and (string.match(Attribute, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";
    local u58 = u53:GetAttributeChangedSignal("Slot5"):Connect(function() -- Line: 298
        -- upvalues: u53 (copy), u4 (ref), refreshBombHolster (ref), u5 (ref), Players (ref)
        local u55 = u53;
        local u56 = u4;
        local u57 = refreshBombHolster;

        if not u5[u55] then
            if u56[u55] then
                return;
            end;

            u56[u55] = true;
            task.defer(function() -- Line: 265
                -- upvalues: u56 (copy), u55 (copy), Players (ref), u5 (ref), u57 (copy)
                u56[u55] = nil;

                if u55.Parent == Players and not u5[u55] then
                    u57(u55);
                end;
            end);
        end;
    end);
    local u63 = Observers.observeAttribute(u53, "CurrentEquipped", function(p59) -- Line: 306
        -- upvalues: u54 (ref), u53 (copy), u5 (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref)
        local v60 = typeof(p59) == "string" and (string.match(p59, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";

        if v60 == u54 then
            return function() -- Line: 309
            end;
        end;

        u54 = v60;
        local v61 = u53;

        if not u5[v61] then
            u5[v61] = true;
            table.insert(u6, v61);

            if not u8 then
                u8 = true;
                task.spawn(function() -- Line: 59
                    -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                    while u7 <= #u6 do
                        RunService.Heartbeat:Wait();
                        local u62 = u6[u7];
                        u7 = u7 + 1;

                        if u5[u62] then
                            u5[u62] = nil;

                            if u62.Parent == Players then
                                task.spawn(function() -- Line: 73
                                    -- upvalues: u9 (ref), u62 (copy)
                                    local success, result = pcall(u9, u62);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u62.Name} presentation rebuild failed: {result}`));
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
        -- upvalues: u58 (copy), u63 (copy)
        u58:Disconnect();
        u63();
    end;
end;

u9 = function(u64: userdata) -- Line: 324
    -- upvalues: CharacterResolver (copy), CreateWeaponModel (copy), waitForPresentationRig (copy), u5 (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), Players (copy), u9 (ref), HttpService (copy), u1 (copy), visualSignature (copy), u2 (copy), buildInventorySlots (copy), DebugFlags (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(u64);

    if not PlayerCharacter or PlayerCharacter:GetAttribute("Dead") == true then
        local function v65() -- Line: 327
            -- upvalues: CreateWeaponModel (ref), u64 (copy)
            CreateWeaponModel.ClearPlayerCache(u64);
        end;

        debug.profilebegin("Observers.Players.RebuildCharacterVisuals.ClearCache");
        local success, result = pcall(v65);
        debug.profileend();

        if not success then
            error(result, 0);
        end;

        return;
    end;

    if not waitForPresentationRig(PlayerCharacter) then
        CreateWeaponModel.ClearPlayerCache(u64);

        return;
    end;

    local function v74() -- Line: 337
        -- upvalues: CharacterResolver (ref), u64 (copy), PlayerCharacter (copy), u5 (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref), HttpService (ref), u1 (ref), visualSignature (ref), u2 (ref), CreateWeaponModel (ref), buildInventorySlots (ref), DebugFlags (ref)
        if CharacterResolver.getPlayerCharacter(u64) == PlayerCharacter and PlayerCharacter:GetAttribute("Dead") ~= true then
            local v66 = false;
            local Attribute = u64:GetAttribute("CurrentEquipped");

            if Attribute then
                local success, result = pcall(function() -- Line: 349
                    -- upvalues: HttpService (ref), Attribute (copy)
                    return HttpService:JSONDecode(Attribute);
                end);

                if success and typeof(result) == "table" then
                    u1[u64] = visualSignature(result);
                    u2[u64] = result.IsSuppressed == true;

                    local function v67() -- Line: 355
                        -- upvalues: CreateWeaponModel (ref), u64 (ref), result (copy), buildInventorySlots (ref)
                        CreateWeaponModel(u64, result, (buildInventorySlots(u64)));
                    end;

                    debug.profilebegin("Observers.Players.RebuildCharacterVisuals.Weapon");
                    local success2, result2 = pcall(v67);
                    debug.profileend();

                    if success2 then
                        v66 = true;
                    else
                        error(result2, 0);
                        v66 = true;
                    end;
                end;
            end;

            if not v66 then
                local function v69() -- Line: 364
                    -- upvalues: u64 (ref), CreateWeaponModel (ref), DebugFlags (ref)
                    local v68 = u64;
                    local success, result = pcall(CreateWeaponModel.RefreshObjectiveKitHolster, v68);

                    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
                        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(v68.Name, "RefreshObjectiveKitHolster", (tostring(result))));
                    end;
                end;

                debug.profilebegin("Observers.Players.RebuildCharacterVisuals.ObjectiveKit");
                local success, result = pcall(v69);
                debug.profileend();

                if not success then
                    error(result, 0);
                end;

                local function v71() -- Line: 367
                    -- upvalues: u64 (ref), CreateWeaponModel (ref), DebugFlags (ref)
                    local v70 = u64;
                    debug.profilebegin("Observers.Players.RefreshBombHolster");
                    local success2, result2 = pcall(CreateWeaponModel.RefreshBombHolster, v70);

                    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success2 then
                        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(v70.Name, "RefreshBombHolster", (tostring(result2))));
                    end;

                    debug.profileend();
                end;

                debug.profilebegin("Observers.Players.RebuildCharacterVisuals.BombHolster");
                local success2, result2 = pcall(v71);
                debug.profileend();

                if not success2 then
                    error(result2, 0);
                end;
            end;

            return;
        end;

        local v72 = u64;

        if u5[v72] then
            return;
        end;

        u5[v72] = true;
        table.insert(u6, v72);

        if u8 then
            return;
        end;

        u8 = true;
        task.spawn(function() -- Line: 59
            -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
            while u7 <= #u6 do
                RunService.Heartbeat:Wait();
                local u73 = u6[u7];
                u7 = u7 + 1;

                if u5[u73] then
                    u5[u73] = nil;

                    if u73.Parent == Players then
                        task.spawn(function() -- Line: 73
                            -- upvalues: u9 (ref), u73 (copy)
                            local success, result = pcall(u9, u73);

                            if not success then
                                warn((`[ThirdPersonWeaponModels] {u73.Name} presentation rebuild failed: {result}`));
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
    local success, result = pcall(v74);
    debug.profileend();

    if not success then
        error(result, 0);
    end;
end;

return Observers.observePlayer(function(u75: userdata) -- Line: 377
    -- upvalues: LocalPlayer (copy), Observers (copy), DebugFlags (copy), u5 (copy), clearCurrentEquippedVisuals (copy), HttpService (copy), visualSignature (copy), u1 (copy), u2 (copy), CreateWeaponModel (copy), u6 (copy), u8 (ref), u7 (ref), RunService (copy), Players (copy), u9 (ref), createObjectiveKitListener (copy), createBombHolsterListener (copy), CharacterResolver (copy), u3 (copy), u4 (copy)
    if u75 == LocalPlayer then
        return function() -- Line: 380
        end;
    end;

    local u86 = Observers.observeAttribute(u75, "CurrentEquipped", function(p76) -- Line: 189
        -- upvalues: DebugFlags (ref), u75 (copy), u5 (ref), clearCurrentEquippedVisuals (ref), HttpService (ref), visualSignature (ref), u1 (ref), u2 (ref), CreateWeaponModel (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref)
        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            local l_warn = warn;
            local Name = u75.Name;
            local v77 = typeof(p76) == "string" and (#p76 or -1) or -1;
            l_warn(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(Name, (tostring(v77))));
        end;

        if not p76 then
            u5[u75] = nil;
            clearCurrentEquippedVisuals(u75);

            return function() -- Line: 202
            end;
        end;

        local u78 = HttpService:JSONDecode(p76);
        local v79 = visualSignature(u78);

        if v79 ~= "" and u1[u75] == v79 then
            local v80 = u78.IsSuppressed == true;

            if u2[u75] ~= v80 then
                u2[u75] = v80;

                local function v81() -- Line: 213
                    -- upvalues: CreateWeaponModel (ref), u75 (ref), u78 (copy)
                    return CreateWeaponModel.RefreshSuppressorState(u75, u78);
                end;

                debug.profilebegin("Observers.Players.RefreshSuppressorState");
                local success, result = pcall(v81);
                debug.profileend();

                if not success then
                    error(result, 0);
                end;

                if not result then
                    local v82 = u75;

                    if not u5[v82] then
                        u5[v82] = true;
                        table.insert(u6, v82);

                        if not u8 then
                            u8 = true;
                            task.spawn(function() -- Line: 59
                                -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                                while u7 <= #u6 do
                                    RunService.Heartbeat:Wait();
                                    local u83 = u6[u7];
                                    u7 = u7 + 1;

                                    if u5[u83] then
                                        u5[u83] = nil;

                                        if u83.Parent == Players then
                                            task.spawn(function() -- Line: 73
                                                -- upvalues: u9 (ref), u83 (copy)
                                                local success2, result2 = pcall(u9, u83);

                                                if not success2 then
                                                    warn((`[ThirdPersonWeaponModels] {u83.Name} presentation rebuild failed: {result2}`));
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

        u1[u75] = v79;
        u2[u75] = u78.IsSuppressed == true;
        local v84 = u75;

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
                                    local success, result = pcall(u9, u85);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u85.Name} presentation rebuild failed: {result}`));
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
            -- upvalues: u75 (ref), clearCurrentEquippedVisuals (ref)
            if u75:GetAttribute("CurrentEquipped") ~= nil then
                return;
            end;

            clearCurrentEquippedVisuals(u75);
        end;
    end);
    local u87 = createObjectiveKitListener(u75);
    local u88 = createBombHolsterListener(u75);
    local u91 = CharacterResolver.observeCharacter(u75, function() -- Line: 387
        -- upvalues: u75 (copy), u5 (ref), u6 (ref), u8 (ref), u7 (ref), RunService (ref), Players (ref), u9 (ref)
        local v89 = u75;

        if not u5[v89] then
            u5[v89] = true;
            table.insert(u6, v89);

            if not u8 then
                u8 = true;
                task.spawn(function() -- Line: 59
                    -- upvalues: u7 (ref), u6 (ref), RunService (ref), u5 (ref), Players (ref), u9 (ref), u8 (ref)
                    while u7 <= #u6 do
                        RunService.Heartbeat:Wait();
                        local u90 = u6[u7];
                        u7 = u7 + 1;

                        if u5[u90] then
                            u5[u90] = nil;

                            if u90.Parent == Players then
                                task.spawn(function() -- Line: 73
                                    -- upvalues: u9 (ref), u90 (copy)
                                    local success, result = pcall(u9, u90);

                                    if not success then
                                        warn((`[ThirdPersonWeaponModels] {u90.Name} presentation rebuild failed: {result}`));
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
        -- upvalues: u86 (copy), u87 (copy), u88 (copy), u91 (copy), u3 (ref), u75 (copy), u4 (ref), u5 (ref), CreateWeaponModel (ref), u1 (ref), u2 (ref)
        u86();
        u87();
        u88();
        u91();
        u3[u75] = nil;
        u4[u75] = nil;
        u5[u75] = nil;
        CreateWeaponModel.ClearPlayerCache(u75);
        u1[u75] = nil;
        u2[u75] = nil;
    end;
end);