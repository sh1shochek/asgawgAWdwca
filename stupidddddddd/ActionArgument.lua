-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionArgument
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionArgument
-- Decompile time: 1.45 ms

local Players = game:GetService("Players")
local Parent = script.Parent.Parent.Parent.Parent.Parent
local ArgumentType = require(Parent.Parent.Shared.Enums.ArgumentType)
local StringPropertyComponent = require(Parent.Components.StringPropertyComponent)
local NumberPropertyComponent = require(Parent.Components.NumberPropertyComponent)
local DropdownPropertyComponent = require(Parent.Components.DropdownPropertyComponent)
local CheckmarkPropertyComponent = require(Parent.Components.CheckmarkPropertyComponent)
return function(a1, a2, a3) -- Line: 21
    -- upvalues: ArgumentType (val), Players (val), DropdownPropertyComponent (val), CheckmarkPropertyComponent (val)
    -- upvalues: StringPropertyComponent (val), NumberPropertyComponent (val)
    local v1 = a2.Name and ("%*:"):format((string.gsub(a2.Name, "^%l", string.upper))) or ("#%* argument:"):format(a2.Index)
    local u107 = nil
    if a2.Type == ArgumentType.Player then
        local v2 = {}
        for i, j in Players:GetPlayers() do
            table.insert(v2, j.DisplayName)
        end
        u107 = DropdownPropertyComponent({
            PropertyText = v1,
            Value = Players.LocalPlayer.DisplayName,
            Options = v2,
            Parent = a1,
        }, function(a1) -- Line: 40 -- upvalues: Players (upval), a3 (val) -- types: a1: string
            for i, j in Players:GetPlayers() do
                if j.DisplayName == a1 then
                    a3(j)
                    return
                end
            end
        end)
        a3(Players.LocalPlayer)
    elseif a2.Options then
        local v3 = {PropertyText = v1}
        local Default = a2.Default or a2.Options[1]
        v3.Value = Default
        v3.Options = a2.Options
        v3.Parent = a1
        u107 = DropdownPropertyComponent(v3, function(a1) -- Line: 58 -- upvalues: a3 (val)
            a3(a1)
        end)
    elseif a2.Type == ArgumentType.boolean then
        u107 = CheckmarkPropertyComponent({PropertyText = v1, Value = a2.Default, Parent = a1}, function(a1) -- Line: 68 -- upvalues: a3 (val) -- types: a1: boolean
            a3(a1)
        end)
    elseif a2.Type == ArgumentType.string then
        u107 = StringPropertyComponent({PropertyText = v1, Value = a2.Default, Default = a2.Default, Parent = a1}, function(a1) -- Line: 79 -- upvalues: a3 (val) -- types: a1: string
            a3(a1)
        end)
    elseif a2.Type == ArgumentType.number then
        u107 = NumberPropertyComponent({PropertyText = v1, Value = a2.Default, Default = a2.Default, Parent = a1}, function(a1) -- Line: 90 -- upvalues: a3 (val) -- types: a1: number
            a3(a1)
        end)
    end
    return function() -- Line: 95 -- upvalues: u107 (ref)
        if u107 then
            u107()
        end
    end
end