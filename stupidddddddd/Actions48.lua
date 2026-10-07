-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions
-- Decompile time: 2.14 ms

local Parent = script.Parent.Parent.Parent
local Tab = require(Parent.Tab)
local Networking = require(Parent.Networking)
local Action = require(Parent.Parent.Shared.Action)
local Value = require(Parent.Parent.Shared.Value)
local ActionsList = require(script.Interface.ActionsList)
local ActionGroupsExplorer = require(script.Interface.ActionGroupsExplorer)
local u30 = {}
u30.internal = {
    ActionGroups = Value.new({}),
    Actions = Value.new({}),
    SelectedGroup = Value.new(false),
}

function u30.internal.executeServerAction(a1, a2) -- Line: 26
    -- upvalues: Networking (val)
    Networking:SendMessage("actions_execute", a1, a2)
    return true
end

function u30.internal.addAction(a1) -- Line: 32 -- upvalues: u30 (val)
    local v1
    local Name_4 = string.sub(a1.Name, 1, 7) == "Server/" and string.sub(a1.Name, 8, #a1.Name) or a1.Name
    local v2 = string.find(Name_4, "/")
    local v3 = v2 and string.sub(Name_4, v2 + 1, #Name_4) or Name_4
    local v4 = v2 and string.sub(Name_4, 1, v2 - 1) or "Uncategorized"
    local v5 = u30.internal.ActionGroups:Get()
    if not table.find(v5, v4) then
        table.insert(v5, v4)
        u30.internal.ActionGroups:Set(v5, true)
    end
    local v6 = u30.internal.Actions:Get()
    if not v6[v4] then
        v6[v4] = {}
    end
    table.insert(v6[v4], {
        Name = v3,
        RawName = a1.Name,
        Description = a1.Description,
        Arguments = a1.Arguments,
        ServerAction = v1,
    })
    u30.internal.Actions:Set(v6, true)
    if not u30.internal.SelectedGroup:Get() then
        u30.internal.SelectedGroup:Set(v4)
    end
end

function u30.internal.removeAction(a1) -- Line: 72 -- upvalues: u30 (val) -- types: a1: string
    local v1
    local v2 = {}
    local v3 = (u30.internal.Actions:Get())
    local v4 = nil
    local v5 = nil
    for i, j in v3, v4, v5 do
        v1 = {}
        for k, n in j do
            if n.RawName ~= v6 and n.RawName ~= ("Server/%*"):format(v6) then
                v1[n.Name] = n
            end
        end
        v2[i] = v1
    end
    u30.internal.Actions:Set(v2, true)
end

function u30.internal.Init(a1) -- Line: 94 -- upvalues: Networking (val), Action (val), u30 (val)
    Networking:SubscribeToTopic("actions_update", function(a1) -- Line: 95 -- upvalues: Action (upval), u30 (upval)
        for i, j in a1 do
            Action.new(("Server/%*"):format(j.Name), j.Description, function(...) -- Line: 97 -- upvalues: u30 (upval), j (val)
                return u30.internal.executeServerAction(j.Name, {...})
            end, j.Arguments)
        end
    end)
    Networking:SubscribeToTopic("actions_remove", u30.internal.removeAction)
    for i, j in Action:GetAll() do
        u30.internal.addAction(j)
    end
    Action.ActionAdded:Connect(function(a1) -- Line: 109 -- upvalues: Action (upval), u30 (upval) -- types: a1: string
        local Definition = Action:GetDefinition(a1)
        u30.internal.addAction(Definition)
    end)
    Action.ActionRemoved:Connect(u30.internal.removeAction)
end

function u30.internal.MountInterface(a1, a2) -- Line: 117
    -- upvalues: u30 (val), ActionsList (val), ActionGroupsExplorer (val), Networking (val)
    u30.internal.ActionsListDestroyer = ActionsList(a2, u30.internal.SelectedGroup, u30.internal.Actions)
    u30.internal.ActionGroupsExplorerDestroyer = ActionGroupsExplorer(a2, u30.internal.ActionGroups, u30.internal.SelectedGroup, function(a1) -- Line: 125 -- upvalues: u30 (upval) -- types: a1: string
        u30.internal.SelectedGroup:Set(a1)
    end)
    Networking:SendMessage("actions_listening", true)
end

function u30.internal.UnmountInterface(a1) -- Line: 133 -- upvalues: u30 (val), Networking (val)
    if u30.internal.ActionsListDestroyer then
        u30.internal.ActionsListDestroyer()
        u30.internal.ActionsListDestroyer = nil
    end
    if u30.internal.ActionGroupsExplorerDestroyer then
        u30.internal.ActionGroupsExplorerDestroyer()
        u30.internal.ActionGroupsExplorerDestroyer = nil
    end
    Networking:SendMessage("actions_listening", false)
end

u30.internal:Init()
Tab.new("Actions", function(a1) -- Line: 149 -- upvalues: u30 (val) -- types: a1: userdata
    u30.internal:MountInterface(a1)
    return function() -- Line: 152 -- upvalues: u30 (upval)
        u30.internal:UnmountInterface()
    end
end)
return nil