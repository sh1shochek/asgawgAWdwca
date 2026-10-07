-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Explorer.ClassIcon
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Explorer.ClassIcon
-- Decompile time: 0.41 ms

local Imgui = require(script.Parent.Parent.Parent.Parent.Imgui)
local ClassIndex = require(script.Parent.Parent.Parent.Parent.Vendor.ClassIndex)
Imgui:NewWidgetDefinition("ExplorerClassIcon", {
    Construct = function(a1, a2, a3, a4) -- Line: 9 -- upvalues: ClassIndex (val) -- types: a2: userdata, a3: userdata, a4: userdata
        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = ("Label (%*)"):format(a1.ID)
        ImageLabel.AutomaticSize = Enum.AutomaticSize.XY
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Size = a3
        for i, j in ClassIndex.FetchClassIcon(a4.ClassName) do
            ImageLabel[i] = j
        end
        ImageLabel.Parent = a2
        return ImageLabel
    end,
    Update = function(a1, a2, a3) -- Line: 26 -- upvalues: ClassIndex (val) -- types: a2: userdata, a3: userdata
        a1.TopInstance.Size = a2
        for i, j in ClassIndex.FetchClassIcon(a3.ClassName) do
            a1.TopInstance[i] = j
        end
    end,
})
return nil