-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Database.Custom.Types);
local Observers = require(ReplicatedStorage.Packages.Observers);
local u1 = { "Map Voting", "Game Ending", "Warmup", "Round In Progress", "Buy Period", "Intermission" };

local function isValidState(p2: string) -- Line: 29
    -- upvalues: u1 (copy)
    local table_find_ret = table.find(u1, p2);
    local v3 = `"{p2}" is not a valid state!`;
    assert(table_find_ret, v3);

    return true;
end;

return {
    GetState = function() -- Line: 40, Name: GetState
        return workspace:GetAttribute("GameState");
    end,

    GetStateAtTime = function(p4: number?) -- Line: 46, Name: GetStateAtTime
        -- upvalues: u1 (copy)
        local Attribute = workspace:GetAttribute("GameState");
        local Attribute2 = workspace:GetAttribute("ScheduledGameState");
        local Attribute3 = workspace:GetAttribute("ScheduledGameStateServerTime");

        if typeof(p4) == "number" and (p4 == p4 and (typeof(Attribute3) == "number" and (Attribute3 <= p4 and (typeof(Attribute2) == "string" and table.find(u1, Attribute2) ~= nil)))) then
            return Attribute2;
        end;

        local Attribute4 = workspace:GetAttribute("GameStateTransitionServerTime");
        local Attribute5 = workspace:GetAttribute("PreviousGameState");

        if typeof(p4) == "number" and (p4 == p4 and (typeof(Attribute4) == "number" and (p4 < Attribute4 and (typeof(Attribute5) == "string" and table.find(u1, Attribute5) ~= nil)))) then
            return Attribute5;
        end;

        return Attribute;
    end,

    SetState = function(p5) -- Line: 75, Name: SetState
        -- upvalues: RunService (copy), u1 (copy)
        local v6 = RunService:IsServer();
        assert(v6, "This method is only available to the server.");
        local table_find_ret = table.find(u1, p5);
        local v7 = `"{p5}" is not a valid state!`;
        assert(table_find_ret, v7);

        if true then
            local Attribute = workspace:GetAttribute("GameState");

            if Attribute == p5 then
                return;
            end;

            local Attribute2 = workspace:GetAttribute("ScheduledGameState");
            local Attribute3 = workspace:GetAttribute("ScheduledGameStateServerTime");

            if Attribute2 ~= p5 or typeof(Attribute3) ~= "number" then
                Attribute3 = workspace:GetServerTimeNow();
            end;

            workspace:SetAttribute("PreviousGameState", Attribute);
            workspace:SetAttribute("GameStateTransitionServerTime", Attribute3);
            workspace:SetAttribute("GameState", p5);
            workspace:SetAttribute("ScheduledGameState", nil);
            workspace:SetAttribute("ScheduledGameStateServerTime", nil);
        end;
    end,

    ScheduleState = function(p8: any, p9: number) -- Line: 94, Name: ScheduleState
        -- upvalues: RunService (copy), u1 (copy)
        local v10 = RunService:IsServer();
        assert(v10, "This method is only available to the server.");
        local v11;

        if p9 == p9 and p9 > (-1 / 0) then
            v11 = p9 < (1 / 0);
        else
            v11 = false;
        end;

        assert(v11);
        local table_find_ret = table.find(u1, p8);
        local v12 = `"{p8}" is not a valid state!`;
        assert(table_find_ret, v12);

        if true then
            workspace:SetAttribute("ScheduledGameStateServerTime", p9);
            workspace:SetAttribute("ScheduledGameState", p8);
        end;
    end,

    CancelScheduledState = function() -- Line: 104, Name: CancelScheduledState
        -- upvalues: RunService (copy)
        local v13 = RunService:IsServer();
        assert(v13, "This method is only available to the server.");
        workspace:SetAttribute("ScheduledGameState", nil);
        workspace:SetAttribute("ScheduledGameStateServerTime", nil);
    end,

    ListenToState = function(u14: function) -- Line: 110, Name: ListenToState
        -- upvalues: Observers (copy)
        local u15 = nil;

        return Observers.observeAttribute(workspace, "GameState", function(p16) -- Line: 112
            -- upvalues: u14 (copy), u15 (ref)
            u14(u15, p16);
            u15 = p16;
        end);
    end
};