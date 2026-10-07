-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Properties
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Properties
-- Decompile time: 1.19 ms

local Parent = script.Parent.Parent.Parent
local Tab = require(Parent.Tab)
local Imgui = require(Parent.Imgui)
local ClassIndex = require((Parent.Vendor:WaitForChild("ClassIndex")))
local Explorer = require(script.Parent.Explorer)
require(script.PropertyLabel)
local u26 = {interface = {}, internal = {}}

function u26.internal.getPropertiesFor(a1) -- Line: 17 -- upvalues: ClassIndex (val)
    local v1
    local v2 = ClassIndex.FetchClassSuperclasses(a1.ClassName)
    local v3 = {}
    table.insert(v2, 1, a1.ClassName)
    for i, j in v2 do
        v3[j] = {}
    end
    local v4 = nil
    local v5 = nil
    for k, n in v2, v4, v5 do
        if n ~= "<<<ROOT>>>" then
            for m, i5 in (ClassIndex.FetchClassMembers(n)) do
                v1 = ClassIndex.FetchClassMemberType(n, i5)
                if not ClassIndex.FetchClassMemberTags(n, i5).Deprecated and v1 == "Property" then
                    table.insert(v3[n], i5)
                end
            end
        end
    end
    return v3
end

Tab.new("Properties", function(a1) -- Line: 51 -- upvalues: Imgui (val), Explorer (val), u26 (val) -- types: a1: userdata
    return Imgui:Connect(a1, function() -- Line: 52 -- upvalues: Imgui (upval), Explorer (upval), u26 (upval)
        Imgui:ScrollingFrameY((UDim2.fromScale(1, 1)))
        Imgui:BeginVertical()
        local v1 = Explorer.getSelectedObject()
        if v1 then
            local v2 = u26.internal.getPropertiesFor(v1)
            Imgui:Label((("<b><i>%*</i> [\"%*\"]</b>"):format(v1.ClassName, (v1:GetFullName()))))
            local v3 = nil
            local v4 = nil
            for i, j in v2, v3, v4 do
                if #j ~= 0 then
                    Imgui:Label("")
                    Imgui:Label((("<b><i>Superclass</i> [%*]</b>"):format(i)))
                    for k, n in j do
                        Imgui:PropertyLabel(v1, n)
                    end
                end
            end
        else
            Imgui:Label("No instace currently selected, please go to the 'Explorer' page and select an instance.")
        end
        Imgui:End()
        Imgui:End()
    end)
end)
return u26.interface