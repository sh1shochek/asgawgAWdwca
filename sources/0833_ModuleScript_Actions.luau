-- Decompiled with Potassium's decompiler.

local Module = require(script.Parent.Parent.Module);
local Networking = require(script.Parent.Parent.Networking);
local Action = require(script.Parent.Parent.Parent.Shared.Action);
local Actions = Module.new("Actions");
local u1 = {
    ActionListeners = {}
};

function u1.SendActionsList(p2: table, p3: userdata) -- Line: 12
    -- upvalues: u1 (copy), Action (copy), Networking (copy)
    local v4 = u1.ActionListeners[p3];

    if not v4 then
        v4 = {
            Listening = true,
            SentActions = {}
        };
        u1.ActionListeners[p3] = v4;
    end;

    local v5 = {};

    for _, v in Action:GetAll() do
        if not v4.SentActions[v.Name] then
            v4.SentActions[v.Name] = true;
            table.insert(v5, v);
        end;
    end;

    if #v5 == 0 then
        return;
    end;

    Networking:SendMessageToPlayer(p3, "actions_update", v5);
end;

function Actions.Init() -- Line: 41
    -- upvalues: Action (copy), u1 (copy), Networking (copy)
    Action.ActionAdded:Connect(function(p6: string) -- Line: 42
        -- upvalues: Action (ref), u1 (ref), Networking (ref)
        local Definition = Action:GetDefinition(p6);

        for i, v in u1.ActionListeners do
            if v.Listening then
                v.SentActions[p6] = true;
                Networking:SendMessageToPlayer(i, "actions_update", { Definition });
            end;
        end;
    end);
    Action.ActionRemoved:Connect(function(p7: string) -- Line: 56
        -- upvalues: u1 (ref), Networking (ref)
        for i, v in u1.ActionListeners do
            if v.Listening then
                v.SentActions[p7] = nil;
                Networking:SendMessageToPlayer(i, "actions_remove", p7);
            end;
        end;
    end);
    Networking:SubscribeToTopic("actions_listening", function(p8: userdata, p9: boolean) -- Line: 68
        -- upvalues: u1 (ref)
        if p9 then
            u1:SendActionsList(p8);

            return;
        end;

        u1.ActionListeners[p8].Listening = false;
    end);
    Networking:SubscribeToTopic("actions_execute", function(p10: any, p11: string, p12: table?) -- Line: 76
        -- upvalues: Action (ref)
        Action:Execute(p11, p12);
    end);
end;

return Actions;