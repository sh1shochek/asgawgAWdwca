-- ReplicatedStorage.Packages.DebugTools.Server.Builtin.Actions
-- Script path: ReplicatedStorage.Packages.DebugTools.Server.Builtin.Actions
-- Decompile time: 1.09 ms

local Module = require(script.Parent.Parent.Module)
local Networking = require(script.Parent.Parent.Networking)
local Action = require(script.Parent.Parent.Parent.Shared.Action)
local Actions = Module.new("Actions")
local u23 = {ActionListeners = {}}

function u23.SendActionsList(a1, a2) -- Line: 12
    -- upvalues: u23 (val), Action (val), Networking (val)
    local v1 = u23.ActionListeners[a2]
    if not v1 then
        u23.ActionListeners[a2] = {Listening = true, SentActions = {}}
    end
    local v2 = {}
    for i, j in Action:GetAll() do
        if not v1.SentActions[j.Name] then
            v1.SentActions[j.Name] = true
            table.insert(v2, j)
        end
    end
    if #v2 == 0 then
        return
    end
    Networking:SendMessageToPlayer(a2, "actions_update", v2)
end

function Actions.Init() -- Line: 41 -- upvalues: Action (val), u23 (val), Networking (val)
    Action.ActionAdded:Connect(function(a1) -- Line: 42 -- upvalues: Action (upval), u23 (upval), Networking (upval) -- types: a1: string
        local Definition = Action:GetDefinition(a1)
        for i, j in u23.ActionListeners do
            if j.Listening then
                j.SentActions[a1] = true
                Networking:SendMessageToPlayer(i, "actions_update", {Definition})
            end
        end
    end)
    Action.ActionRemoved:Connect(function(a1) -- Line: 56 -- upvalues: u23 (upval), Networking (upval) -- types: a1: string
        for i, j in u23.ActionListeners do
            if j.Listening then
                j.SentActions[a1] = nil
                Networking:SendMessageToPlayer(i, "actions_remove", a1)
            end
        end
    end)
    Networking:SubscribeToTopic("actions_listening", function(a1, a2) -- Line: 68 -- upvalues: u23 (upval) -- types: a1: userdata, a2: boolean
        if a2 then
            u23:SendActionsList(a1)
            return
        end
        local v1 = u23.ActionListeners[a1]
        v1.Listening = false
    end)
    Networking:SubscribeToTopic("actions_execute", function(a1, a2, a3) -- Line: 76 -- upvalues: Action (upval) -- types: a2: string, a3: table?
        Action:Execute(a2, a3)
    end)
end

return Actions