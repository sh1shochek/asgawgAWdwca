-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
require(script:WaitForChild("Types"));
local Rig = require(script:WaitForChild("Rig"));
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u1 = {};
u1.__index = u1;
local Debris = workspace:WaitForChild("Debris");
local math_clamp_ret = math.clamp(Players.MaxPlayers * 2, 4, 24);
local CFrame_new_ret = CFrame.new(0, -100, 0);
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = setmetatable({}, {
    __mode = "k"
});
local u9 = {};
local u10 = 1;
local u11 = false;
local u12 = setmetatable({}, {
    __mode = "k"
});
local u13 = setmetatable({}, {
    __mode = "k"
});
local u14 = {};
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = setmetatable({}, {
    __mode = "k"
});
local u19 = {};
local u20 = 0;
local u21 = 0;
local u22 = true;
local u23 = nil;
local u24 = {
    AnimationController = true,
    CharacterModel = true,
    WeaponAttachments = true,
    WeaponModel = true
};
local u25 = {
    RagdollReady = true,
    RagdollStaged = true
};
local u26 = {
    Dead = true,
    Ragdolled = true,
    RagdollCreatedAt = true,
    PreparedRagdoll = true,
    ClientRagdoll = true
};

local function profileScope(p27: string, p28: function) -- Line: 93
    debug.profilebegin(p27);
    local success, result = pcall(p28);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    return result;
end;

local function startPreparationStageWorker() -- Line: 103
    -- upvalues: u11 (ref), u10 (ref), u9 (copy), RunService (copy)
    if u11 then
        return;
    end;

    u11 = true;
    task.spawn(function() -- Line: 109
        -- upvalues: u10 (ref), u9 (ref), RunService (ref), u11 (ref)
        while u10 <= #u9 do
            RunService.Heartbeat:Wait();
            local v29 = u9[u10];
            u10 = u10 + 1;
            local success, result = pcall(v29.Callback);
            v29.Succeeded = success;
            v29.Result = result;
            v29.Completed = true;
        end;

        table.clear(u9);
        u10 = 1;
        u11 = false;
    end);
end;

local function runPreparationStage(p30: function) -- Line: 127
    -- upvalues: u9 (copy), u11 (ref), u10 (ref), RunService (copy)
    local v31 = {
        Completed = false,
        Succeeded = false,
        Result = nil,
        Callback = p30
    };
    table.insert(u9, v31);

    if not u11 then
        u11 = true;
        task.spawn(function() -- Line: 109
            -- upvalues: u10 (ref), u9 (ref), RunService (ref), u11 (ref)
            while u10 <= #u9 do
                RunService.Heartbeat:Wait();
                local v32 = u9[u10];
                u10 = u10 + 1;
                local success, result = pcall(v32.Callback);
                v32.Succeeded = success;
                v32.Result = result;
                v32.Completed = true;
            end;

            table.clear(u9);
            u10 = 1;
            u11 = false;
        end);
    end;

    while not v31.Completed do
        RunService.Heartbeat:Wait();
    end;

    if not v31.Succeeded then
        error(v31.Result, 0);
    end;

    return v31.Result;
end;

local function isVisualEffect(p33: userdata) -- Line: 146
    return p33:IsA("ParticleEmitter") or p33:IsA("Trail") or (p33:IsA("Beam") or p33:IsA("Fire") or (p33:IsA("Smoke") or p33:IsA("Sparkles")));
end;

local function isExcludedRagdollContent(p34: userdata) -- Line: 155
    -- upvalues: u24 (copy)
    return u24[p34.Name] == true and true or (p34:IsA("AnimationController") or (p34:IsA("Script") or p34:IsA("LocalScript") or (p34:IsA("ModuleScript") or p34:IsA("BillboardGui")) or (p34:IsA("SurfaceGui") or p34:IsA("Highlight") or (p34:IsA("ProximityPrompt") or p34:IsA("ClickDetector")))));
end;

local function markNonArchivableRagdollContent(p35: userdata) -- Line: 168
    -- upvalues: isExcludedRagdollContent (copy), u13 (copy)
    for _, descendant in p35:GetDescendants() do
        if isExcludedRagdollContent(descendant) then
            descendant.Archivable = false;
        end;
    end;

    u13[p35] = true;
end;

local function getRagdollLifetime() -- Line: 177
    -- upvalues: GameState (copy)
    local v36;

    if GameState.GetState() == "Warmup" then
        v36 = workspace:GetAttribute("Gamemode") == "Deathmatch";
    else
        v36 = false;
    end;

    return v36 and 10 or 15;
end;

local function cleanupAttachments(p37: userdata) -- Line: 182
    local CharacterModel = p37:FindFirstChild("CharacterModel");

    if CharacterModel then
        CharacterModel:Destroy();
    end;
end;

local function getSourceCharacter(p38: userdata) -- Line: 189
    -- upvalues: u4 (copy)
    return u4[p38] or p38;
end;

local function destroyLocalCorpse(p39: userdata) -- Line: 193
    -- upvalues: u3 (copy), u4 (copy), u23 (ref)
    local v40 = u3[p39];
    u3[p39] = nil;

    if v40 then
        u4[v40] = nil;
        u23(v40);
    end;
end;

local function destroyPreparedCorpse(p41: userdata) -- Line: 203
    -- upvalues: u7 (copy), u23 (ref), u5 (copy)
    local v42 = u7[p41];
    u7[p41] = nil;

    if v42 then
        v42.Cancelled = true;
        local Corpse = v42.Corpse;
        v42.Corpse = nil;

        if Corpse then
            u23(Corpse);
        end;
    end;

    local v43 = u5[p41];
    u5[p41] = nil;

    if v43 then
        u23(v43);
    end;
end;

local function disconnectPreparationCleanup(p44: userdata) -- Line: 222
    -- upvalues: u6 (copy)
    local v45 = u6[p44];
    u6[p44] = nil;

    if v45 then
        v45:Disconnect();
    end;
end;

local function clearCorpseDeathState(p46: userdata) -- Line: 230
    -- upvalues: CollectionService (copy)
    p46:SetAttribute("PreparedRagdoll", true);
    p46:SetAttribute("Dead", nil);
    p46:SetAttribute("Ragdolled", nil);
    p46:SetAttribute("RagdollCreatedAt", nil);
    CollectionService:RemoveTag(p46, "Ragdoll");
end;

local function markCorpseAsPrepared(p47: userdata, p48: userdata) -- Line: 239
    -- upvalues: clearCorpseDeathState (copy)
    p48.Name = `__PreparedRagdoll_{p47.Name}`;
    p48:SetAttribute("ClientRagdoll", true);
    clearCorpseDeathState(p48);
end;

local function configureCorpseClone(p49: userdata, p50: userdata) -- Line: 245
    -- upvalues: clearCorpseDeathState (copy), isVisualEffect (copy), u8 (copy)
    p50.Name = `__PreparedRagdoll_{p49.Name}`;
    p50:SetAttribute("ClientRagdoll", true);
    clearCorpseDeathState(p50);
    local v51 = {};
    local v52 = {};

    for _, descendant in p50:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            descendant.LocalTransparencyModifier = 1;
            table.insert(v51, descendant);
        elseif isVisualEffect(descendant) or descendant:IsA("Light") then
            table.insert(v52, {
                Instance = descendant,
                Enabled = descendant.Enabled
            });
            descendant.Enabled = false;
        end;

        if descendant:IsA("Motor6D") or (descendant:IsA("Weld") or descendant:IsA("WeldConstraint")) then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;

            if Part0 and not Part0:IsDescendantOf(p50) or Part1 and not Part1:IsDescendantOf(p50) then
                descendant:Destroy();
            end;
        elseif descendant:IsA("Highlight") then
            descendant:Destroy();
        end;
    end;

    u8[p50] = {
        Effects = v52,
        Renderables = v51
    };
end;

local function setCorpseVisible(p53: userdata, p54: boolean) -- Line: 281
    -- upvalues: u8 (copy)
    local v55 = u8[p53];

    if not v55 then
        return;
    end;

    local v56 = p54 and 0 or 1;

    for _, v in v55.Renderables do
        if v.Parent then
            v.LocalTransparencyModifier = v56;
        end;
    end;

    for _, v in v55.Effects do
        if v.Instance.Parent then
            local v57;

            if p54 then
                v57 = v.Enabled;
            else
                v57 = p54;
            end;

            v.Instance.Enabled = v57;
        end;
    end;
end;

local function getCorpsePoolKey(p58: userdata) -- Line: 299
    -- upvalues: CharacterResolver (copy)
    local PlayerFromCharacter = CharacterResolver.getPlayerFromCharacter(p58);
    local v59;

    if PlayerFromCharacter then
        v59 = tostring(PlayerFromCharacter.UserId);
    else
        v59 = p58.Name;
    end;

    local Attribute = p58:GetAttribute("CharacterName");
    local Attribute2 = p58:GetAttribute("EquippedGloves");

    return table.concat({ v59, tostring(Attribute or ""), (tostring(Attribute2 or "")) }, "\0");
end;

local function syncCorpseAppearance(p60: userdata, p61: userdata) -- Line: 307
    -- upvalues: u25 (copy), u26 (copy), clearCorpseDeathState (copy)
    for _, child in p60:GetChildren() do
        local v62 = p61:FindFirstChild(child.Name);

        if child:IsA("BasePart") and (v62 and v62:IsA("BasePart")) then
            if v62.Color ~= child.Color then
                v62.Color = child.Color;
            end;
        elseif child:IsA("BodyColors") and (v62 and v62:IsA("BodyColors")) then
            v62.HeadColor3 = child.HeadColor3;
            v62.LeftArmColor3 = child.LeftArmColor3;
            v62.LeftLegColor3 = child.LeftLegColor3;
            v62.RightArmColor3 = child.RightArmColor3;
            v62.RightLegColor3 = child.RightLegColor3;
            v62.TorsoColor3 = child.TorsoColor3;
        end;
    end;

    for i in p61:GetAttributes() do
        if not u25[i] then
            p61:SetAttribute(i, nil);
        end;
    end;

    for i, v in p60:GetAttributes() do
        if not (u25[i] or u26[i]) then
            p61:SetAttribute(i, v);
        end;
    end;

    p61.Name = `__PreparedRagdoll_{p60.Name}`;
    p61:SetAttribute("ClientRagdoll", true);
    clearCorpseDeathState(p61);
end;

local function removePoolMembership(p63: userdata) -- Line: 339
    -- upvalues: u17 (copy), u14 (copy), u16 (copy), u15 (copy), u20 (ref)
    u17[p63] = nil;
    local v64 = u14[p63];
    u14[p63] = nil;

    if not v64 then
        return;
    end;

    local v65 = u16[v64];

    if v65 then
        for i = #v65, 1, -1 do
            local v66;

            if v65[i] == p63 then
                table.remove(v65, i);
                v66 = i;
            else
                v66 = i;
            end;
        end;

        if #v65 == 0 then
            u16[v64] = nil;
        end;
    end;

    local v67 = (u15[v64] or 1) - 1;

    if v67 <= 0 then
        v67 = nil;
    end;

    u15[v64] = v67;
    u20 = math.max(0, u20 - 1);
end;

local function u69(p68: userdata) -- Line: 364
    -- upvalues: removePoolMembership (copy), u18 (copy), u4 (copy), u8 (copy), CollectionService (copy)
    removePoolMembership(p68);
    u18[p68] = nil;
    u4[p68] = nil;
    u8[p68] = nil;
    CollectionService:RemoveTag(p68, "Ragdoll");
    p68:Destroy();
end;

local function registerPoolMember(p70: userdata, p71: string) -- Line: 373
    -- upvalues: u14 (copy), u15 (copy), u20 (ref), math_clamp_ret (copy)
    local v72 = u14[p70];

    if v72 then
        return v72 == p71;
    end;

    if (u15[p71] or 0) >= 2 then
        return false;
    end;

    if math_clamp_ret <= u20 then
        return false;
    end;

    u14[p70] = p71;
    u15[p71] = (u15[p71] or 0) + 1;
    u20 = u20 + 1;

    return true;
end;

local function parkCorpse(u73: userdata) -- Line: 392
    -- upvalues: CFrame_new_ret (copy)
    local function v74() -- Line: 393
        -- upvalues: u73 (copy), CFrame_new_ret (ref)
        u73:PivotTo(CFrame_new_ret);
    end;

    debug.profilebegin("Ragdoll.Pool.Park");
    local success, result = pcall(v74);
    debug.profileend();

    if not success then
        error(result, 0);
    end;
end;

u23 = function(u75: userdata) -- Line: 398
    -- upvalues: u18 (copy), u14 (copy), Debris (copy), Rig (copy), u69 (ref), u17 (copy), setCorpseVisible (copy), clearCorpseDeathState (copy), CFrame_new_ret (copy), u16 (copy)
    if u18[u75] or not (u14[u75] and (u75.Parent == Debris and Rig.ResetPrepared(u75))) then
        u69(u75);

        return;
    end;

    if u17[u75] then
        return;
    end;

    setCorpseVisible(u75, false);
    u75.Name = "__PooledRagdoll";
    clearCorpseDeathState(u75);

    local function v76() -- Line: 393
        -- upvalues: u75 (copy), CFrame_new_ret (ref)
        u75:PivotTo(CFrame_new_ret);
    end;

    debug.profilebegin("Ragdoll.Pool.Park");
    local success, result = pcall(v76);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    local v77 = u14[u75];
    local v78 = u16[v77];

    if not v78 then
        v78 = {};
        u16[v77] = v78;
    end;

    u17[u75] = true;
    table.insert(v78, u75);
end;

local function acquirePooledCorpse(p79: userdata, p80: string) -- Line: 427
    -- upvalues: u16 (copy), u17 (copy), Debris (copy), u14 (copy), u18 (copy), Rig (copy), u69 (ref), syncCorpseAppearance (copy), setCorpseVisible (copy), CFrame_new_ret (copy)
    local v81 = u16[p80];

    while v81 and #v81 > 0 do
        local table_remove_ret = table.remove(v81);

        if #v81 == 0 then
            u16[p80] = nil;
        end;

        if u17[table_remove_ret] then
            u17[table_remove_ret] = nil;

            if table_remove_ret.Parent == Debris and (u14[table_remove_ret] == p80 and (not u18[table_remove_ret] and Rig.ResetPrepared(table_remove_ret))) then
                syncCorpseAppearance(p79, table_remove_ret);
                setCorpseVisible(table_remove_ret, false);

                local function v82() -- Line: 393
                    -- upvalues: table_remove_ret (copy), CFrame_new_ret (ref)
                    table_remove_ret:PivotTo(CFrame_new_ret);
                end;

                debug.profilebegin("Ragdoll.Pool.Park");
                local success, result = pcall(v82);
                debug.profileend();

                if not success then
                    error(result, 0);
                end;

                return table_remove_ret;
            end;

            u69(table_remove_ret);
        end;
    end;

    return nil;
end;

local function ensurePreparationCleanup(u83: userdata) -- Line: 456
    -- upvalues: u6 (copy), u7 (copy), u23 (ref), u5 (copy)
    if u6[u83] then
        return;
    end;

    u6[u83] = u83.AncestryChanged:Connect(function(p84, p85) -- Line: 461
        -- upvalues: u83 (copy), u7 (ref), u23 (ref), u5 (ref), u6 (ref)
        if p85 ~= nil then
            return;
        end;

        local v86 = u83;
        local v87 = u7[v86];
        u7[v86] = nil;

        if v87 then
            v87.Cancelled = true;
            local Corpse = v87.Corpse;
            v87.Corpse = nil;

            if Corpse then
                u23(Corpse);
            end;
        end;

        local v88 = u5[v86];
        u5[v86] = nil;

        if v88 then
            u23(v88);
        end;

        local v89 = u83;
        local v90 = u6[v89];
        u6[v89] = nil;

        if v90 then
            v90:Disconnect();
        end;
    end);
end;

local function canPrepareSource(p91: userdata) -- Line: 470
    -- upvalues: u22 (ref), u12 (copy)
    local v92 = u22;

    if v92 then
        if p91.Parent == nil or (p91:GetAttribute("ClientRagdoll") == true or p91:GetAttribute("Dead") == true) then
            v92 = false;
        else
            v92 = not u12[p91];
        end;
    end;

    return v92;
end;

local function canPrewarmReserve() -- Line: 478
    -- upvalues: GameState (copy), u22 (ref)
    local State = GameState.GetState();

    return u22 and (State == "Warmup" and true or State == "Buy Period");
end;

local function isPreparationCurrent(p93: userdata, p94: table) -- Line: 483
    -- upvalues: u7 (copy), u22 (ref), u12 (copy)
    local v95;

    if u7[p93] == p94 then
        v95 = not p94.Cancelled and u22;

        if v95 then
            if p93.Parent == nil or (p93:GetAttribute("ClientRagdoll") == true or p93:GetAttribute("Dead") == true) then
                v95 = false;
            else
                v95 = not u12[p93];
            end;
        end;
    else
        v95 = false;
    end;

    return v95;
end;

local function cloneCorpse(u96: userdata, p97: string, p98: string) -- Line: 489
    -- upvalues: configureCorpseClone (copy)
    if not u96.Parent or u96:GetAttribute("ClientRagdoll") == true then
        return nil;
    end;

    u96.Archivable = true;
    debug.profilebegin(p97);
    local success, result = pcall(function() -- Line: 495
        -- upvalues: u96 (copy)
        return u96:Clone();
    end);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    local function v99() -- Line: 498
        -- upvalues: configureCorpseClone (ref), u96 (copy), result (copy)
        configureCorpseClone(u96, result);
    end;

    debug.profilebegin(p98);
    local success2, result2 = pcall(v99);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    return result;
end;

local function scheduleReservePrewarm(u100: userdata, u101: string) -- Line: 504
    -- upvalues: GameState (copy), u22 (ref), u15 (copy), u19 (copy), u21 (ref), CharacterResolver (copy), Players (copy), runPreparationStage (copy), u12 (copy), u13 (copy), isExcludedRagdollContent (copy), cloneCorpse (copy), Rig (copy), CFrame_new_ret (copy), u14 (copy), u20 (ref), math_clamp_ret (copy), Debris (copy), u23 (ref), u69 (ref)
    local State = GameState.GetState();

    if not (u22 and (State == "Warmup" and true or State == "Buy Period") and ((u15[u101] or 0) < 2 and u19[u101] == nil)) then
        return;
    end;

    local u102 = u21;
    u19[u101] = u102;
    local PlayerFromCharacter = CharacterResolver.getPlayerFromCharacter(u100);

    local function isStale() -- Line: 516
        -- upvalues: u102 (copy), u21 (ref), PlayerFromCharacter (copy), Players (ref), GameState (ref), u22 (ref)
        local v103;

        if u102 == u21 and (PlayerFromCharacter == nil or PlayerFromCharacter.Parent == Players) then
            local State2 = GameState.GetState();
            v103 = not (u22 and (State2 == "Warmup" and true or State2 == "Buy Period"));
        else
            v103 = true;
        end;

        return v103;
    end;

    task.spawn(function() -- Line: 519
        -- upvalues: runPreparationStage (ref), u102 (copy), u21 (ref), PlayerFromCharacter (copy), Players (ref), GameState (ref), u22 (ref), u100 (copy), u12 (ref), u13 (ref), isExcludedRagdollContent (ref), cloneCorpse (ref), Rig (ref), u15 (ref), u101 (copy), CFrame_new_ret (ref), u14 (ref), u20 (ref), math_clamp_ret (ref), Debris (ref), u23 (ref), u69 (ref), u19 (ref)
        local u104 = nil;
        local success, result = pcall(function() -- Line: 521
            -- upvalues: runPreparationStage (ref), u102 (ref), u21 (ref), PlayerFromCharacter (ref), Players (ref), GameState (ref), u22 (ref), u100 (ref), u12 (ref), u13 (ref), isExcludedRagdollContent (ref), u104 (ref), cloneCorpse (ref), Rig (ref), u15 (ref), u101 (ref), CFrame_new_ret (ref), u14 (ref), u20 (ref), math_clamp_ret (ref), Debris (ref), u23 (ref)
            runPreparationStage(function() -- Line: 522
                -- upvalues: u102 (ref), u21 (ref), PlayerFromCharacter (ref), Players (ref), GameState (ref), u22 (ref), u100 (ref), u12 (ref), u13 (ref), isExcludedRagdollContent (ref), u104 (ref), cloneCorpse (ref)
                local v105;

                if u102 == u21 and (PlayerFromCharacter == nil or PlayerFromCharacter.Parent == Players) then
                    local State2 = GameState.GetState();
                    v105 = not (u22 and (State2 == "Warmup" and true or State2 == "Buy Period"));
                else
                    v105 = true;
                end;

                if not v105 then
                    local v106 = u100;
                    local v107 = u22;

                    if v107 then
                        if v106.Parent == nil or (v106:GetAttribute("ClientRagdoll") == true or v106:GetAttribute("Dead") == true) then
                            v107 = false;
                        else
                            v107 = not u12[v106];
                        end;
                    end;

                    if v107 then
                        if not u13[u100] then
                            local v108 = u100;

                            for _, descendant in v108:GetDescendants() do
                                if isExcludedRagdollContent(descendant) then
                                    descendant.Archivable = false;
                                end;
                            end;

                            u13[v108] = true;
                        end;

                        u104 = cloneCorpse(u100, "Ragdoll.Pool.CloneReserve", "Ragdoll.Pool.ConfigureReserve");
                    end;
                end;
            end);

            if u104 then
                local v109;

                if u102 == u21 and (PlayerFromCharacter == nil or PlayerFromCharacter.Parent == Players) then
                    local State2 = GameState.GetState();
                    v109 = not (u22 and (State2 == "Warmup" and true or State2 == "Buy Period"));
                else
                    v109 = true;
                end;

                if not v109 then
                    local u110 = u104;

                    if runPreparationStage(function() -- Line: 536
                        -- upvalues: u102 (ref), u21 (ref), PlayerFromCharacter (ref), Players (ref), GameState (ref), u22 (ref), u100 (ref), u12 (ref), Rig (ref), u110 (copy)
                        local v111;

                        if u102 == u21 and (PlayerFromCharacter == nil or PlayerFromCharacter.Parent == Players) then
                            local State2 = GameState.GetState();
                            v111 = not (u22 and (State2 == "Warmup" and true or State2 == "Buy Period"));
                        else
                            v111 = true;
                        end;

                        if not v111 then
                            local v112 = u100;
                            local v113 = u22;

                            if v113 then
                                if v112.Parent == nil or (v112:GetAttribute("ClientRagdoll") == true or v112:GetAttribute("Dead") == true) then
                                    v113 = false;
                                else
                                    v113 = not u12[v112];
                                end;
                            end;

                            if v113 then
                                local v114 = Rig.Prepare(u110) and Rig.StagePrepared(u110);

                                return v114;
                            end;
                        end;

                        return false;
                    end) == true and u102 == u21 then
                        local State2 = GameState.GetState();

                        if u22 and (State2 == "Warmup" and true or State2 == "Buy Period") then
                            runPreparationStage(function() -- Line: 546
                                -- upvalues: u102 (ref), u21 (ref), PlayerFromCharacter (ref), Players (ref), GameState (ref), u22 (ref), u15 (ref), u101 (ref), u110 (copy), CFrame_new_ret (ref), u14 (ref), u20 (ref), math_clamp_ret (ref), Debris (ref), u23 (ref), u104 (ref)
                                local v115;

                                if u102 == u21 and (PlayerFromCharacter == nil or PlayerFromCharacter.Parent == Players) then
                                    local State3 = GameState.GetState();
                                    v115 = not (u22 and (State3 == "Warmup" and true or State3 == "Buy Period"));
                                else
                                    v115 = true;
                                end;

                                if v115 or (u15[u101] or 0) >= 2 then
                                    return false;
                                end;

                                local u116 = u110;

                                local function v117() -- Line: 393
                                    -- upvalues: u116 (copy), CFrame_new_ret (ref)
                                    u116:PivotTo(CFrame_new_ret);
                                end;

                                debug.profilebegin("Ragdoll.Pool.Park");
                                local success, result = pcall(v117);
                                debug.profileend();

                                if not success then
                                    error(result, 0);
                                end;

                                local v118 = u110;
                                local v119 = u101;
                                local v120 = u14[v118];
                                local v121;

                                if v120 then
                                    v121 = v120 == v119;
                                elseif (u15[v119] or 0) >= 2 or math_clamp_ret <= u20 then
                                    v121 = false;
                                else
                                    u14[v118] = v119;
                                    u15[v119] = (u15[v119] or 0) + 1;
                                    u20 = u20 + 1;
                                    v121 = true;
                                end;

                                if not v121 then
                                    return false;
                                end;

                                local function v122() -- Line: 554
                                    -- upvalues: u110 (ref), Debris (ref)
                                    u110.Parent = Debris;
                                end;

                                debug.profilebegin("Ragdoll.Pool.ParentReserve");
                                local success2, result2 = pcall(v122);
                                debug.profileend();

                                if not success2 then
                                    error(result2, 0);
                                end;

                                u23(u110);
                                u104 = nil;

                                return true;
                            end);
                        end;
                    end;
                end;
            end;
        end);

        if u104 then
            u69(u104);
        end;

        if u19[u101] == u102 then
            u19[u101] = nil;
        end;

        if not success then
            warn((`[Ragdoll] Reserve prewarm failed: {result}`));
        end;
    end);
end;

local function takePreparedCorpse(p123: userdata) -- Line: 575
    -- upvalues: u5 (copy), u7 (copy), u23 (ref), u6 (copy)
    local v124 = u5[p123];
    u5[p123] = nil;
    local v125 = u7[p123];
    u7[p123] = nil;

    if v125 then
        v125.Cancelled = true;

        if v124 then
            if v125.Corpse then
                u23(v125.Corpse);
                v125.Corpse = nil;
            end;
        else
            v124 = v125.Corpse;
            v125.Corpse = nil;
        end;
    end;

    local v126 = u6[p123];
    u6[p123] = nil;

    if v126 then
        v126:Disconnect();
    end;

    return v124;
end;

function u1.HideCharacterLocally(p127: userdata) -- Line: 596
    -- upvalues: isVisualEffect (copy)
    for _, descendant in p127:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
        elseif descendant:IsA("Decal") then
            descendant.LocalTransparencyModifier = 1;
        elseif isVisualEffect(descendant) or (descendant:IsA("BillboardGui") or (descendant:IsA("SurfaceGui") or descendant:IsA("Highlight"))) then
            descendant.Enabled = false;
        end;
    end;
end;

function u1.PrepareCharacter(u128: userdata) -- Line: 616
    -- upvalues: u5 (copy), u22 (ref), u12 (copy), u7 (copy), RunService (copy), getCorpsePoolKey (copy), acquirePooledCorpse (copy), u6 (copy), u23 (ref), scheduleReservePrewarm (copy), runPreparationStage (copy), u13 (copy), isExcludedRagdollContent (copy), cloneCorpse (copy), u69 (ref), Rig (copy), CFrame_new_ret (copy), u14 (copy), u15 (copy), u20 (ref), math_clamp_ret (copy), Debris (copy)
    if u5[u128] then
        return true;
    end;

    local v129 = u22;

    if v129 then
        if u128.Parent == nil or (u128:GetAttribute("ClientRagdoll") == true or u128:GetAttribute("Dead") == true) then
            v129 = false;
        else
            v129 = not u12[u128];
        end;
    end;

    if not v129 then
        return false;
    end;

    local v130 = u7[u128];

    if not v130 then
        local u131 = getCorpsePoolKey(u128);
        local v132 = acquirePooledCorpse(u128, u131);

        if v132 then
            u5[u128] = v132;

            if not u6[u128] then
                u6[u128] = u128.AncestryChanged:Connect(function(p133, p134) -- Line: 461
                    -- upvalues: u128 (copy), u7 (ref), u23 (ref), u5 (ref), u6 (ref)
                    if p134 ~= nil then
                        return;
                    end;

                    local v135 = u128;
                    local v136 = u7[v135];
                    u7[v135] = nil;

                    if v136 then
                        v136.Cancelled = true;
                        local Corpse = v136.Corpse;
                        v136.Corpse = nil;

                        if Corpse then
                            u23(Corpse);
                        end;
                    end;

                    local v137 = u5[v135];
                    u5[v135] = nil;

                    if v137 then
                        u23(v137);
                    end;

                    local v138 = u128;
                    local v139 = u6[v138];
                    u6[v138] = nil;

                    if v139 then
                        v139:Disconnect();
                    end;
                end);
            end;

            scheduleReservePrewarm(u128, u131);

            return true;
        end;

        local u140 = {
            Corpse = nil,
            Cancelled = false
        };
        u7[u128] = u140;

        if not u6[u128] then
            u6[u128] = u128.AncestryChanged:Connect(function(p141, p142) -- Line: 461
                -- upvalues: u128 (copy), u7 (ref), u23 (ref), u5 (ref), u6 (ref)
                if p142 ~= nil then
                    return;
                end;

                local v143 = u128;
                local v144 = u7[v143];
                u7[v143] = nil;

                if v144 then
                    v144.Cancelled = true;
                    local Corpse = v144.Corpse;
                    v144.Corpse = nil;

                    if Corpse then
                        u23(Corpse);
                    end;
                end;

                local v145 = u5[v143];
                u5[v143] = nil;

                if v145 then
                    u23(v145);
                end;

                local v146 = u128;
                local v147 = u6[v146];
                u6[v146] = nil;

                if v147 then
                    v147:Disconnect();
                end;
            end);
        end;

        local success, result = pcall(function() -- Line: 648
            -- upvalues: runPreparationStage (ref), u128 (copy), u140 (copy), u7 (ref), u22 (ref), u12 (ref), u13 (ref), isExcludedRagdollContent (ref), cloneCorpse (ref), u69 (ref), Rig (ref), CFrame_new_ret (ref), u131 (copy), u14 (ref), u15 (ref), u20 (ref), math_clamp_ret (ref), Debris (ref), u5 (ref), scheduleReservePrewarm (ref)
            runPreparationStage(function() -- Line: 650
                -- upvalues: u128 (ref), u140 (ref), u7 (ref), u22 (ref), u12 (ref), u13 (ref), isExcludedRagdollContent (ref), cloneCorpse (ref), u69 (ref)
                local v148 = u128;
                local v149 = u140;
                local v150;

                if u7[v148] == v149 then
                    v150 = not v149.Cancelled and u22;

                    if v150 then
                        if v148.Parent == nil or (v148:GetAttribute("ClientRagdoll") == true or v148:GetAttribute("Dead") == true) then
                            v150 = false;
                        else
                            v150 = not u12[v148];
                        end;
                    end;
                else
                    v150 = false;
                end;

                if not v150 then
                    return;
                end;

                if not u13[u128] then
                    local function v152() -- Line: 655
                        -- upvalues: u128 (ref), isExcludedRagdollContent (ref), u13 (ref)
                        local v151 = u128;

                        for _, descendant in v151:GetDescendants() do
                            if isExcludedRagdollContent(descendant) then
                                descendant.Archivable = false;
                            end;
                        end;

                        u13[v151] = true;
                    end;

                    debug.profilebegin("Ragdoll.Prepare.MarkNonArchivable");
                    local success, result = pcall(v152);
                    debug.profileend();

                    if not success then
                        error(result, 0);
                    end;
                end;

                local v153 = cloneCorpse(u128, "Ragdoll.Prepare.Clone", "Ragdoll.Prepare.ConfigureClone");

                if not v153 then
                    return;
                end;

                local v154 = u128;
                local v155 = u140;
                local v156;

                if u7[v154] == v155 then
                    v156 = not v155.Cancelled and u22;

                    if v156 then
                        if v154.Parent == nil or (v154:GetAttribute("ClientRagdoll") == true or v154:GetAttribute("Dead") == true) then
                            v156 = false;
                        else
                            v156 = not u12[v154];
                        end;
                    end;
                else
                    v156 = false;
                end;

                if v156 then
                    u140.Corpse = v153;

                    return;
                end;

                u69(v153);
            end);
            local Corpse = u140.Corpse;

            if Corpse then
                local v157 = u128;
                local v158 = u140;
                local v159;

                if u7[v157] == v158 then
                    v159 = not v158.Cancelled and u22;

                    if v159 then
                        if v157.Parent == nil or (v157:GetAttribute("ClientRagdoll") == true or v157:GetAttribute("Dead") == true) then
                            v159 = false;
                        else
                            v159 = not u12[v157];
                        end;
                    end;
                else
                    v159 = false;
                end;

                if v159 then
                    local function isCorpseCurrent() -- Line: 675
                        -- upvalues: u128 (ref), u140 (ref), u7 (ref), u22 (ref), u12 (ref), Corpse (copy)
                        local v160 = u128;
                        local v161 = u140;
                        local v162;

                        if u7[v160] == v161 then
                            v162 = not v161.Cancelled and u22;

                            if v162 then
                                if v160.Parent == nil or (v160:GetAttribute("ClientRagdoll") == true or v160:GetAttribute("Dead") == true) then
                                    v162 = false;
                                else
                                    v162 = not u12[v160];
                                end;
                            end;
                        else
                            v162 = false;
                        end;

                        if v162 then
                            v162 = u140.Corpse == Corpse;
                        end;

                        return v162;
                    end;

                    if runPreparationStage(function() -- Line: 680
                        -- upvalues: u128 (ref), u140 (ref), u7 (ref), u22 (ref), u12 (ref), Corpse (copy), Rig (ref)
                        local v163 = u128;
                        local v164 = u140;
                        local v165;

                        if u7[v163] == v164 then
                            v165 = not v164.Cancelled and u22;

                            if v165 then
                                if v163.Parent == nil or (v163:GetAttribute("ClientRagdoll") == true or v163:GetAttribute("Dead") == true) then
                                    v165 = false;
                                else
                                    v165 = not u12[v163];
                                end;
                            end;
                        else
                            v165 = false;
                        end;

                        if v165 then
                            v165 = u140.Corpse == Corpse;
                        end;

                        if not v165 then
                            return false;
                        end;

                        local v166 = Rig.Prepare(Corpse) and Rig.StagePrepared(Corpse);

                        return v166;
                    end) == true then
                        local v167 = u128;
                        local v168 = u140;
                        local v169;

                        if u7[v167] == v168 then
                            v169 = not v168.Cancelled and u22;

                            if v169 then
                                if v167.Parent == nil or (v167:GetAttribute("ClientRagdoll") == true or v167:GetAttribute("Dead") == true) then
                                    v169 = false;
                                else
                                    v169 = not u12[v167];
                                end;
                            end;
                        else
                            v169 = false;
                        end;

                        if v169 then
                            v169 = u140.Corpse == Corpse;
                        end;

                        if v169 then
                            if runPreparationStage(function() -- Line: 691
                                -- upvalues: u128 (ref), u140 (ref), u7 (ref), u22 (ref), u12 (ref), Corpse (copy), CFrame_new_ret (ref), u131 (ref), u14 (ref), u15 (ref), u20 (ref), math_clamp_ret (ref), Debris (ref)
                                local v170 = u128;
                                local v171 = u140;
                                local v172;

                                if u7[v170] == v171 then
                                    v172 = not v171.Cancelled and u22;

                                    if v172 then
                                        if v170.Parent == nil or (v170:GetAttribute("ClientRagdoll") == true or v170:GetAttribute("Dead") == true) then
                                            v172 = false;
                                        else
                                            v172 = not u12[v170];
                                        end;
                                    end;
                                else
                                    v172 = false;
                                end;

                                if v172 then
                                    v172 = u140.Corpse == Corpse;
                                end;

                                if not v172 then
                                    return false;
                                end;

                                local u173 = Corpse;

                                local function v174() -- Line: 393
                                    -- upvalues: u173 (copy), CFrame_new_ret (ref)
                                    u173:PivotTo(CFrame_new_ret);
                                end;

                                debug.profilebegin("Ragdoll.Pool.Park");
                                local success, result = pcall(v174);
                                debug.profileend();

                                if not success then
                                    error(result, 0);
                                end;

                                local v175 = Corpse;
                                local v176 = u131;
                                local v177 = u14[v175];

                                if v177 then
                                    local _ = v177 == v176;
                                elseif (u15[v176] or 0) < 2 and math_clamp_ret > u20 then
                                    u14[v175] = v176;
                                    u15[v176] = (u15[v176] or 0) + 1;
                                    u20 = u20 + 1;
                                end;

                                local function v178() -- Line: 697
                                    -- upvalues: Corpse (ref), Debris (ref)
                                    Corpse.Parent = Debris;
                                end;

                                debug.profilebegin("Ragdoll.Prepare.ParentInitialPoolSlot");
                                local success2, result2 = pcall(v178);
                                debug.profileend();

                                if not success2 then
                                    error(result2, 0);
                                end;

                                return true;
                            end) == true then
                                local v179 = u128;
                                local v180 = u140;
                                local v181;

                                if u7[v179] == v180 then
                                    v181 = not v180.Cancelled and u22;

                                    if v181 then
                                        if v179.Parent == nil or (v179:GetAttribute("ClientRagdoll") == true or v179:GetAttribute("Dead") == true) then
                                            v181 = false;
                                        else
                                            v181 = not u12[v179];
                                        end;
                                    end;
                                else
                                    v181 = false;
                                end;

                                if v181 then
                                    v181 = u140.Corpse == Corpse;
                                end;

                                if v181 then
                                    u5[u128] = Corpse;
                                    u140.Corpse = nil;
                                    u7[u128] = nil;
                                    scheduleReservePrewarm(u128, u131);

                                    return true;
                                end;
                            end;

                            return false;
                        end;
                    end;

                    return false;
                end;
            end;

            return false;
        end);

        if u7[u128] == u140 then
            u7[u128] = nil;
        end;

        if u140.Corpse then
            u23(u140.Corpse);
            u140.Corpse = nil;
        end;

        if not success then
            local v182 = u6[u128];
            u6[u128] = nil;

            if v182 then
                v182:Disconnect();
            end;

            error(result, 0);
        end;

        if result ~= true and not u5[u128] then
            local v183 = u6[u128];
            u6[u128] = nil;

            if v183 then
                v183:Disconnect();
            end;
        end;

        return result == true;
    end;

    while u7[u128] == v130 do
        local v184 = u22;

        if v184 then
            if u128.Parent == nil or (u128:GetAttribute("ClientRagdoll") == true or u128:GetAttribute("Dead") == true) then
                v184 = false;
            else
                v184 = not u12[u128];
            end;
        end;

        if not v184 then
            break;
        end;

        RunService.Heartbeat:Wait();
    end;

    return u5[u128] ~= nil;
end;

function u1.ActivateCharacter(u185: userdata, u186: vector?) -- Line: 730
    -- upvalues: u3 (copy), u12 (copy), u1 (copy), u13 (copy), isExcludedRagdollContent (copy), Rig (copy), u5 (copy), u7 (copy), u23 (ref), u6 (copy), cloneCorpse (copy), u69 (ref), u14 (copy), getCorpsePoolKey (copy), u15 (copy), u20 (ref), math_clamp_ret (copy), u4 (copy), setCorpseVisible (copy), Debris (copy), GameState (copy)
    if u185:GetAttribute("ClientRagdoll") == true then
        return u185;
    end;

    local v187 = u3[u185];

    if v187 and v187.Parent then
        return v187;
    end;

    if u12[u185] then
        u1.HideCharacterLocally(u185);

        return u185;
    end;

    if not u13[u185] then
        local function v189() -- Line: 747
            -- upvalues: u185 (copy), isExcludedRagdollContent (ref), u13 (ref)
            local v188 = u185;

            for _, descendant in v188:GetDescendants() do
                if isExcludedRagdollContent(descendant) then
                    descendant.Archivable = false;
                end;
            end;

            u13[v188] = true;
        end;

        debug.profilebegin("Ragdoll.Activate.MarkNonArchivable");
        local success, result = pcall(v189);
        debug.profileend();

        if not success then
            error(result, 0);
        end;
    end;

    local function v190() -- Line: 752
        -- upvalues: Rig (ref), u185 (copy)
        return Rig.CapturePose(u185);
    end;

    debug.profilebegin("Ragdoll.Activate.CapturePose");
    local success, result = pcall(v190);
    debug.profileend();

    if not success then
        error(result, 0);
    end;

    local function v195() -- Line: 755
        -- upvalues: u185 (copy), u5 (ref), u7 (ref), u23 (ref), u6 (ref)
        local v191 = u185;
        local v192 = u5[v191];
        u5[v191] = nil;
        local v193 = u7[v191];
        u7[v191] = nil;

        if v193 then
            v193.Cancelled = true;

            if v192 then
                if v193.Corpse then
                    u23(v193.Corpse);
                    v193.Corpse = nil;
                end;
            else
                v192 = v193.Corpse;
                v193.Corpse = nil;
            end;
        end;

        local v194 = u6[v191];
        u6[v191] = nil;

        if v194 then
            v194:Disconnect();
        end;

        return v192;
    end;

    debug.profilebegin("Ragdoll.Activate.TakePrepared");
    local success2, result2 = pcall(v195);
    debug.profileend();

    if not success2 then
        error(result2, 0);
    end;

    local u196 = result2 or cloneCorpse(u185, "Ragdoll.Activate.Clone", "Ragdoll.Activate.ConfigureFallbackClone");

    if not u196 then
        return u185;
    end;

    if not Rig.IsPrepared(u196) then
        local function v197() -- Line: 766
            -- upvalues: Rig (ref), u196 (copy)
            return Rig.Prepare(u196);
        end;

        debug.profilebegin("Ragdoll.Activate.CompletePreparation");
        local success3, result3 = pcall(v197);
        debug.profileend();

        if not success3 then
            error(result3, 0);
        end;

        if result3 ~= true then
            u69(u196);

            return u185;
        end;
    end;

    if not u14[u196] then
        local v198 = getCorpsePoolKey(u185);
        local v199 = u14[u196];

        if v199 then
            local _ = v199 == v198;
        elseif (u15[v198] or 0) < 2 and math_clamp_ret > u20 then
            u14[u196] = v198;
            u15[v198] = (u15[v198] or 0) + 1;
            u20 = u20 + 1;
        end;
    end;

    local function v200() -- Line: 778
        -- upvalues: u196 (copy), u185 (copy), u3 (ref), u4 (ref)
        u196.Name = u185.Name;
        u196:SetAttribute("PreparedRagdoll", nil);
        u196:SetAttribute("Dead", true);
        u3[u185] = u196;
        u4[u196] = u185;
    end;

    debug.profilebegin("Ragdoll.Activate.ConfigureClone");
    local success3, result3 = pcall(v200);
    debug.profileend();

    if not success3 then
        error(result3, 0);
    end;

    local function v201() -- Line: 786
        -- upvalues: Rig (ref), u196 (copy), result (copy), u186 (copy)
        Rig.Activate(u196, result, u186);
    end;

    debug.profilebegin("Ragdoll.Activate.Rig");
    local success4, result4 = pcall(v201);
    debug.profileend();

    if not success4 then
        error(result4, 0);
    end;

    local function v202() -- Line: 789
        -- upvalues: setCorpseVisible (ref), u196 (copy)
        setCorpseVisible(u196, true);
    end;

    debug.profilebegin("Ragdoll.Activate.Reveal");
    local success5, result5 = pcall(v202);
    debug.profileend();

    if not success5 then
        error(result5, 0);
    end;

    local function v203() -- Line: 793
        -- upvalues: u196 (copy), Debris (ref)
        if u196.Parent ~= Debris then
            u196.Parent = Debris;
        end;
    end;

    debug.profilebegin("Ragdoll.Activate.Parent");
    local success6, result6 = pcall(v203);
    debug.profileend();

    if not success6 then
        error(result6, 0);
    end;

    local function v204() -- Line: 798
        -- upvalues: u185 (copy), u196 (copy), u1 (ref)
        local CharacterModel = u185:FindFirstChild("CharacterModel");

        if CharacterModel then
            CharacterModel:Destroy();
        end;

        local CharacterModel2 = u196:FindFirstChild("CharacterModel");

        if CharacterModel2 then
            CharacterModel2:Destroy();
        end;

        u1.HideCharacterLocally(u185);
    end;

    debug.profilebegin("Ragdoll.Activate.Cleanup");
    local success7, result7 = pcall(v204);
    debug.profileend();

    if not success7 then
        error(result7, 0);
    end;

    local task_delay = task.delay;
    local v205;

    if GameState.GetState() == "Warmup" then
        v205 = workspace:GetAttribute("Gamemode") == "Deathmatch";
    else
        v205 = false;
    end;

    task_delay(v205 and 10 or 15, function() -- Line: 804
        -- upvalues: u3 (ref), u185 (copy), u196 (copy), u4 (ref), u23 (ref)
        if u3[u185] == u196 then
            local v206 = u185;
            local v207 = u3[v206];
            u3[v206] = nil;

            if v207 then
                u4[v207] = nil;
                u23(v207);
            end;
        end;
    end);

    return u196;
end;

local function markPreparedCorpsesNonReusable(p208: userdata) -- Line: 813
    -- upvalues: u5 (copy), u18 (copy), u7 (copy)
    local v209 = u5[p208];

    if v209 then
        u18[v209] = true;
    end;

    local v210 = u7[p208];

    if v210 and v210.Corpse then
        u18[v210.Corpse] = true;
    end;
end;

function u1.RetireCorpseLocally(u211: userdata) -- Line: 825
    -- upvalues: u4 (copy), u12 (copy), u3 (copy), u18 (copy), u5 (copy), u7 (copy), u23 (ref), u6 (copy), u1 (copy)
    task.defer(function() -- Line: 826
        -- upvalues: u211 (copy), u4 (ref), u12 (ref), u3 (ref), u18 (ref), u5 (ref), u7 (ref), u23 (ref), u6 (ref), u1 (ref)
        local v212 = u211;
        local v213 = u4[v212] or v212;
        u12[v213] = true;
        local v214 = u3[v213];

        if v214 then
            u18[v214] = true;
        end;

        local v215 = u5[v213];

        if v215 then
            u18[v215] = true;
        end;

        local v216 = u7[v213];

        if v216 and v216.Corpse then
            u18[v216.Corpse] = true;
        end;

        local v217 = u7[v213];
        u7[v213] = nil;

        if v217 then
            v217.Cancelled = true;
            local Corpse = v217.Corpse;
            v217.Corpse = nil;

            if Corpse then
                u23(Corpse);
            end;
        end;

        local v218 = u5[v213];
        u5[v213] = nil;

        if v218 then
            u23(v218);
        end;

        local v219 = u6[v213];
        u6[v213] = nil;

        if v219 then
            v219:Disconnect();
        end;

        local v220 = u3[v213];
        u3[v213] = nil;

        if v220 then
            u4[v220] = nil;
            u23(v220);
        end;

        if v213.Parent then
            local CharacterModel = v213:FindFirstChild("CharacterModel");

            if CharacterModel then
                CharacterModel:Destroy();
            end;

            u1.HideCharacterLocally(v213);
        end;
    end);
end;

function u1.RecycleAll() -- Line: 844
    -- upvalues: u2 (copy), u3 (copy), u4 (copy), u23 (ref)
    local v221 = {};

    for i in u2 do
        table.insert(v221, i);
    end;

    for _, v in v221 do
        v:Destroy();
    end;

    local v222 = {};

    for i in u3 do
        table.insert(v222, i);
    end;

    for _, v in v222 do
        local v223 = u3[v];
        u3[v] = nil;

        if v223 then
            u4[v223] = nil;
            u23(v223);
        end;
    end;
end;

function u1.DestroyAll() -- Line: 862
    -- upvalues: u21 (ref), u1 (copy), u5 (copy), u7 (copy), u18 (copy), u23 (ref), u6 (copy), u14 (copy), u69 (ref), u16 (copy), u17 (copy), u15 (copy), u19 (copy), u20 (ref)
    u21 = u21 + 1;
    u1.RecycleAll();
    local v224 = {};

    for i in u5 do
        v224[i] = true;
    end;

    for i in u7 do
        v224[i] = true;
    end;

    for i in v224 do
        local v225 = u5[i];

        if v225 then
            u18[v225] = true;
        end;

        local v226 = u7[i];

        if v226 and v226.Corpse then
            u18[v226.Corpse] = true;
        end;

        local v227 = u7[i];
        u7[i] = nil;

        if v227 then
            v227.Cancelled = true;
            local Corpse = v227.Corpse;
            v227.Corpse = nil;

            if Corpse then
                u23(Corpse);
            end;
        end;

        local v228 = u5[i];
        u5[i] = nil;

        if v228 then
            u23(v228);
        end;

        local v229 = u6[i];
        u6[i] = nil;

        if v229 then
            v229:Disconnect();
        end;
    end;

    local v230 = {};

    for i in u14 do
        table.insert(v230, i);
    end;

    for _, v in v230 do
        u69(v);
    end;

    table.clear(u16);
    table.clear(u17);
    table.clear(u15);
    table.clear(u19);
    u20 = 0;
end;

function u1.SetEnabled(p231: boolean) -- Line: 894
    -- upvalues: u22 (ref), u1 (copy), Players (copy)
    if u22 == p231 then
        return;
    end;

    u22 = p231;

    if p231 then
        for _, v in Players:GetPlayers() do
            local Character = v.Character;

            if Character then
                task.spawn(function() -- Line: 909
                    -- upvalues: u1 (ref), Character (copy)
                    local success, result = pcall(u1.PrepareCharacter, Character);

                    if not success then
                        warn((`[Ragdoll] Re-enabled prewarm failed: {result}`));
                    end;
                end);
            end;
        end;

        return;
    end;

    u1.DestroyAll();
end;

function u1.OnceAppearanceReady(p232: any, p233: function) -- Line: 919
    p233();
end;

function u1.SetupCharacterAppearance(p234) -- Line: 924
end;

function u1.new(p235: userdata, p236: any) -- Line: 926
    -- upvalues: u1 (copy), Janitor (copy), u4 (copy), u18 (copy), Signal (copy), Rig (copy), u2 (copy), GameState (copy)
    local u237 = setmetatable({}, u1);
    u237.Janitor = Janitor.new();
    u237.SourceCharacter = u4[p235] or p235;
    u237.CharacterModel = u1.ActivateCharacter(u237.SourceCharacter, p236.Velocity);

    if p236.Finisher == "Charred" or (p236.Finisher == "Gold" or p236.Finisher == "Melted") then
        u18[u237.CharacterModel] = true;
    end;

    u237.OnDestroy = u237.Janitor:Add(Signal.new());
    u237.OnAppearanceBuilt = u237.Janitor:Add(Signal.new());
    u237.IsAppearanceBuilt = true;
    u237.IsDestroyed = false;
    Rig.ApplyImpulse(u237.CharacterModel, p236);
    u237.Janitor:Add(u237.CharacterModel.AncestryChanged:Connect(function(p238, p239) -- Line: 942
        -- upvalues: u237 (copy)
        if p239 == nil then
            u237:Destroy();
        end;
    end));
    u2[u237] = true;
    local task_delay = task.delay;
    local v240;

    if GameState.GetState() == "Warmup" then
        v240 = workspace:GetAttribute("Gamemode") == "Deathmatch";
    else
        v240 = false;
    end;

    task_delay(v240 and 10 or 15, function() -- Line: 949
        -- upvalues: u237 (copy)
        u237:Destroy();
    end);

    return u237;
end;

function u1.Destroy(p241) -- Line: 955
    -- upvalues: u2 (copy), u3 (copy), u4 (copy), u23 (ref)
    if p241.IsDestroyed then
        return;
    end;

    p241.IsDestroyed = true;
    u2[p241] = nil;
    p241.OnDestroy:Fire();
    local SourceCharacter = p241.SourceCharacter;
    local v242 = u3[SourceCharacter];
    u3[SourceCharacter] = nil;

    if v242 then
        u4[v242] = nil;
        u23(v242);
    end;

    task.defer(p241.Janitor.Destroy, p241.Janitor);
end;

GameState.ListenToState(function(p243, p244) -- Line: 967
    -- upvalues: u1 (copy), u5 (copy), scheduleReservePrewarm (copy), getCorpsePoolKey (copy)
    if p244 == "Buy Period" then
        u1.RecycleAll();
    end;

    if p244 ~= "Warmup" and p244 ~= "Buy Period" then
        return;
    end;

    for i in u5 do
        scheduleReservePrewarm(i, getCorpsePoolKey(i));
    end;
end);
Players.PlayerRemoving:Connect(function(p245: userdata) -- Line: 981
    -- upvalues: u14 (copy), u17 (copy), u69 (ref), u18 (copy)
    local v246 = `{p245.UserId}\0`;
    local v247 = {};

    for i, v in u14 do
        if string.sub(v, 1, #v246) == v246 then
            table.insert(v247, i);
        end;
    end;

    for _, v in v247 do
        if u17[v] then
            u69(v);
        else
            u18[v] = true;
        end;
    end;
end);
u1.Rig = Rig;

return u1;