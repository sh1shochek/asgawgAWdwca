-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent.Parent;
local Tab = require(Parent.Tab);
local Networking = require(Parent.Networking);
local Action = require(Parent.Parent.Shared.Action);
local Value = require(Parent.Parent.Shared.Value);
local ActionsList = require(script.Interface.ActionsList);
local ActionGroupsExplorer = require(script.Interface.ActionGroupsExplorer);
local u1 = {
    internal = {
        ActionsListDestroyer = nil,
        ActionGroupsExplorerDestroyer = nil,
        ActionGroups = Value.new({}),
        Actions = Value.new({}),
        SelectedGroup = Value.new(false)
    }
};

function u1.internal.executeServerAction(p2: string, p3: table?) -- Line: 26
    -- upvalues: Networking (copy)
    Networking:SendMessage("actions_execute", p2, p3);

    return true;
end;

function u1.internal.addAction(p4) -- Line: 32
    -- upvalues: u1 (copy)
    local v5 = string.sub(p4.Name, 1, 7) == "Server/";
    local v6 = v5 and string.sub(p4.Name, 8, #p4.Name) or p4.Name;
    local string_find_ret = string.find(v6, "/");
    local v7;

    if string_find_ret then
        v7 = string.sub(v6, string_find_ret + 1, #v6) or v6;
    else
        v7 = v6;
    end;

    local v8 = string_find_ret and string.sub(v6, 1, string_find_ret - 1) or "Uncategorized";
    local v9 = u1.internal.ActionGroups:Get();

    if not table.find(v9, v8) then
        table.insert(v9, v8);
        u1.internal.ActionGroups:Set(v9, true);
    end;

    local v10 = u1.internal.Actions:Get();

    if not v10[v8] then
        v10[v8] = {};
    end;

    table.insert(v10[v8], {
        Name = v7,
        RawName = p4.Name,
        Description = p4.Description,
        Arguments = p4.Arguments,
        ServerAction = v5
    });
    u1.internal.Actions:Set(v10, true);

    if not u1.internal.SelectedGroup:Get() then
        u1.internal.SelectedGroup:Set(v8);
    end;
end;

function u1.internal.removeAction(p11: string) -- Line: 72
    -- upvalues: u1 (copy)
    local v12 = {};

    for i, v in u1.internal.Actions:Get() do
        local v13 = {};

        for _, v2 in v do
            if v2.RawName ~= p11 and v2.RawName ~= `Server/{p11}` then
                v13[v2.Name] = v2;
            end;
        end;

        v12[i] = v13;
    end;

    u1.internal.Actions:Set(v12, true);
end;

function u1.internal.Init(p14) -- Line: 94
    -- upvalues: Networking (copy), Action (copy), u1 (copy)
    Networking:SubscribeToTopic("actions_update", function(p15) -- Line: 95
        -- upvalues: Action (ref), u1 (ref)
        for _, v in p15 do
            Action.new(`Server/{v.Name}`, v.Description, function(...) -- Line: 97
                -- upvalues: u1 (ref), v (copy)
                return u1.internal.executeServerAction(v.Name, { ... });
            end, v.Arguments);
        end;
    end);
    Networking:SubscribeToTopic("actions_remove", u1.internal.removeAction);

    for _, v in Action:GetAll() do
        u1.internal.addAction(v);
    end;

    Action.ActionAdded:Connect(function(p16: string) -- Line: 109
        -- upvalues: Action (ref), u1 (ref)
        local Definition = Action:GetDefinition(p16);
        u1.internal.addAction(Definition);
    end);
    Action.ActionRemoved:Connect(u1.internal.removeAction);
end;

function u1.internal.MountInterface(p17: table, p18: userdata) -- Line: 117
    -- upvalues: u1 (copy), ActionsList (copy), ActionGroupsExplorer (copy), Networking (copy)
    u1.internal.ActionsListDestroyer = ActionsList(p18, u1.internal.SelectedGroup, u1.internal.Actions);
    u1.internal.ActionGroupsExplorerDestroyer = ActionGroupsExplorer(p18, u1.internal.ActionGroups, u1.internal.SelectedGroup, function(p19: string) -- Line: 125
        -- upvalues: u1 (ref)
        u1.internal.SelectedGroup:Set(p19);
    end);
    Networking:SendMessage("actions_listening", true);
end;

function u1.internal.UnmountInterface(p20) -- Line: 133
    -- upvalues: u1 (copy), Networking (copy)
    if u1.internal.ActionsListDestroyer then
        u1.internal.ActionsListDestroyer();
        u1.internal.ActionsListDestroyer = nil;
    end;

    if u1.internal.ActionGroupsExplorerDestroyer then
        u1.internal.ActionGroupsExplorerDestroyer();
        u1.internal.ActionGroupsExplorerDestroyer = nil;
    end;

    Networking:SendMessage("actions_listening", false);
end;

u1.internal:Init();
Tab.new("Actions", function(p21: userdata) -- Line: 149
    -- upvalues: u1 (copy)
    u1.internal:MountInterface(p21);

    return function() -- Line: 152
        -- upvalues: u1 (ref)
        u1.internal:UnmountInterface();
    end;
end);

return nil;