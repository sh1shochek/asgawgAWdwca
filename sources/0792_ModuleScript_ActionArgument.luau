-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Parent = script.Parent.Parent.Parent.Parent.Parent;
local ArgumentType = require(Parent.Parent.Shared.Enums.ArgumentType);
local StringPropertyComponent = require(Parent.Components.StringPropertyComponent);
local NumberPropertyComponent = require(Parent.Components.NumberPropertyComponent);
local DropdownPropertyComponent = require(Parent.Components.DropdownPropertyComponent);
local CheckmarkPropertyComponent = require(Parent.Components.CheckmarkPropertyComponent);

return function(p1: userdata, p2: table, u3: function) -- Line: 21
    -- upvalues: ArgumentType (copy), Players (copy), DropdownPropertyComponent (copy), CheckmarkPropertyComponent (copy), StringPropertyComponent (copy), NumberPropertyComponent (copy)
    local v4 = p2.Name and `{string.gsub(p2.Name, "^%l", string.upper)}:` or `#{p2.Index} argument:`;
    local u5 = nil;

    if p2.Type == ArgumentType.Player then
        local v6 = {};

        for _, v in Players:GetPlayers() do
            table.insert(v6, v.DisplayName);
        end;

        u5 = DropdownPropertyComponent({
            PropertyText = v4,
            Value = Players.LocalPlayer.DisplayName,
            Options = v6,
            Parent = p1
        }, function(p7: string) -- Line: 40
            -- upvalues: Players (ref), u3 (copy)
            for _, v in Players:GetPlayers() do
                if v.DisplayName == p7 then
                    u3(v);

                    return;
                end;
            end;
        end);
        u3(Players.LocalPlayer);
    elseif p2.Options then
        u5 = DropdownPropertyComponent({
            PropertyText = v4,
            Value = p2.Default or p2.Options[1],
            Options = p2.Options,
            Parent = p1
        }, function(p8) -- Line: 58
            -- upvalues: u3 (copy)
            u3(p8);
        end);
    elseif p2.Type == ArgumentType.boolean then
        u5 = CheckmarkPropertyComponent({
            PropertyText = v4,
            Value = p2.Default,
            Parent = p1
        }, function(p9: boolean) -- Line: 68
            -- upvalues: u3 (copy)
            u3(p9);
        end);
    elseif p2.Type == ArgumentType.string then
        u5 = StringPropertyComponent({
            PropertyText = v4,
            Value = p2.Default,
            Default = p2.Default,
            Parent = p1
        }, function(p10: string) -- Line: 79
            -- upvalues: u3 (copy)
            u3(p10);
        end);
    elseif p2.Type == ArgumentType.number then
        u5 = NumberPropertyComponent({
            PropertyText = v4,
            Value = p2.Default,
            Default = p2.Default,
            Parent = p1
        }, function(p11: number) -- Line: 90
            -- upvalues: u3 (copy)
            u3(p11);
        end);
    end;

    return function() -- Line: 95
        -- upvalues: u5 (ref)
        if u5 then
            u5();
        end;
    end;
end;