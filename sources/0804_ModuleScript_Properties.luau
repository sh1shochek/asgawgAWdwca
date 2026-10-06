-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent.Parent;
local Tab = require(Parent.Tab);
local Imgui = require(Parent.Imgui);
local ClassIndex = require((Parent.Vendor:WaitForChild("ClassIndex")));
local Explorer = require(script.Parent.Explorer);
require(script.PropertyLabel);
local u1 = {
    interface = {},
    internal = {}
};

function u1.internal.getPropertiesFor(p2) -- Line: 17
    -- upvalues: ClassIndex (copy)
    local v3 = ClassIndex.FetchClassSuperclasses(p2.ClassName);
    table.insert(v3, 1, p2.ClassName);
    local v4 = {};

    for _, v in v3 do
        v4[v] = {};
    end;

    for _, v in v3 do
        if v ~= "<<<ROOT>>>" then
            local v5 = v;

            for _, v2 in ClassIndex.FetchClassMembers(v) do
                local v6 = ClassIndex.FetchClassMemberType(v5, v2);

                if not ClassIndex.FetchClassMemberTags(v5, v2).Deprecated and v6 == "Property" then
                    table.insert(v4[v5], v2);
                end;
            end;
        end;
    end;

    return v4;
end;

Tab.new("Properties", function(p7: userdata) -- Line: 51
    -- upvalues: Imgui (copy), Explorer (copy), u1 (copy)
    return Imgui:Connect(p7, function() -- Line: 52
        -- upvalues: Imgui (ref), Explorer (ref), u1 (ref)
        Imgui:ScrollingFrameY(UDim2.fromScale(1, 1));
        Imgui:BeginVertical();
        local SelectedObject = Explorer.getSelectedObject();

        if SelectedObject then
            local PropertiesFor = u1.internal.getPropertiesFor(SelectedObject);
            Imgui:Label((`<b><i>{SelectedObject.ClassName}</i> ["{SelectedObject:GetFullName()}"]</b>`));

            for i, v in PropertiesFor do
                if #v ~= 0 then
                    Imgui:Label("");
                    Imgui:Label((`<b><i>Superclass</i> [{i}]</b>`));

                    for _, v2 in v do
                        Imgui:PropertyLabel(SelectedObject, v2);
                    end;
                end;
            end;
        else
            Imgui:Label("No instace currently selected, please go to the \'Explorer\' page and select an instance.");
        end;

        Imgui:End();
        Imgui:End();
    end);
end);

return u1.interface;