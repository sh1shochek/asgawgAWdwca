-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};

local function GetFinisherModule(p5) -- Line: 41
    -- upvalues: u4 (copy)
    local v6 = u4[p5.Finisher];
    local v7 = `"{p5.Finisher}" is not a valid member of database.custom.finishers`;
    assert(v6, v7);

    return v6;
end;

local function findTutorialDummy(p8: number) -- Line: 51
    -- upvalues: IsTutorialMode (copy)
    if not IsTutorialMode() then
        return nil;
    end;

    for _, child in workspace:GetChildren() do
        if child.Name == "Debris" or child:IsA("Folder") and string.sub(child.Name, 1, 8) == "Tutorial" then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Model") and (child2:GetAttribute("TutorialDummy") == true and child2:GetAttribute("DummyUserId") == p8) then
                    return child2;
                end;
            end;
        end;
    end;

    return nil;
end;

function u1.ResolveVictimCharacter(p9) -- Line: 72
    -- upvalues: findTutorialDummy (copy), ReplicatedStorage (copy), Players (copy), ClientCharacterPresentation (copy), CharacterGeneration (copy)
    if p9.Generation == 0 then
        return findTutorialDummy(p9.Victim);
    end;

    local v10;

    if p9.Victim <= -1000 then
        v10 = require(ReplicatedStorage.Controllers.CharacterController.BotCharacters).TakeCorpse(-p9.Victim - 1000, p9.Generation, p9.Position, p9.LookYaw);
    else
        local PlayerByUserId = Players:GetPlayerByUserId(p9.Victim);

        if PlayerByUserId == nil then
            return nil;
        end;

        v10 = ClientCharacterPresentation.Create(PlayerByUserId, p9.Generation);
    end;

    if v10 == nil or not CharacterGeneration.Matches(v10, p9.Generation) then
        return nil;
    end;

    v10:PivotTo(CFrame.new(p9.Position) * CFrame.Angles(0, p9.LookYaw, 0));
    v10:SetAttribute("Health", 0);
    v10:SetAttribute("Dead", true);

    return v10;
end;

function u1.IsFinisherValidForReplication(p11) -- Line: 105
    -- upvalues: u4 (copy), LocalPlayer (copy)
    local v12 = u4[p11.Finisher];
    local v13 = `"{p11.Finisher}" is not a valid member of database.custom.finishers`;
    assert(v12, v13);
    local UserId = LocalPlayer.UserId;

    return v12.Replication == "Killer" and p11.Killer == UserId and true or (v12.Replication == "Victim" and p11.Victim == UserId and true or (v12.Replication == "Both" and (p11.Killer == UserId or p11.Victim == UserId) and true or v12.Replication == "All"));
end;

function u1.ExecuteFinisher(u14) -- Line: 118
    -- upvalues: u1 (copy), u4 (copy), u3 (copy), u2 (copy)
    if not u1.IsFinisherValidForReplication(u14) then
        return;
    end;

    local u15 = u4[u14.Finisher];
    local v16 = `"{u14.Finisher}" is not a valid member of database.custom.finishers`;
    assert(u15, v16);
    local success, result = pcall(function() -- Line: 124
        -- upvalues: u1 (ref), u14 (copy), u3 (ref), u2 (ref), u15 (copy)
        local v17 = u1.ResolveVictimCharacter(u14);

        if not v17 then
            warn((`Failed to execute finisher "{u14.Finisher}": missing victim character "{u14.Victim}"`));

            return nil;
        end;

        v17.Archivable = true;
        local u18 = tostring(u14.Victim);
        local v19 = u3[u18];

        if v19 then
            v19.Destroy();
        end;

        while #u2 >= 8 do
            local table_remove_ret = table.remove(u2, 1);

            if table_remove_ret then
                table_remove_ret.Destroy();
            end;
        end;

        local u20 = u15.Finisher(v17, u14);
        local u21 = {
            Name = u18,

            Destroy = function() -- Line: 152, Name: Destroy
                -- upvalues: u3 (ref), u18 (copy), u20 (copy)
                u3[u18] = nil;
                u20.Destroy();
            end
        };
        u3[u18] = u20;
        table.insert(u2, u21);
        u20.OnDestroy:Once(function() -- Line: 161
            -- upvalues: u2 (ref), u21 (copy)
            local table_find_ret = table.find(u2, u21);

            if table_find_ret then
                table.remove(u2, table_find_ret);
            end;
        end);
    end);

    if not success then
        warn((`Failed to execute finisher "{u14.Finisher}": {result}`));
    end;
end;

for _, child in ipairs(ReplicatedStorage.Database.Custom.Finishers:GetChildren()) do
    if child:IsA("ModuleScript") then
        u4[child.Name] = require(child);
    end;
end;

return u1;