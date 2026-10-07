-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Explorer
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Explorer
-- Decompile time: 1.25 ms

local Parent = script.Parent.Parent.Parent
local Tab = require(Parent.Tab)
local Imgui = require(Parent.Imgui)
require(script.ClassIcon)
require(script.BeginExplorerHorizontal)
local u18 = {interface = {}, internal = {ExpandedInstances = {}}}

function u18.internal.processChildren(a1, a2) -- Line: 17 -- upvalues: u18 (val) -- types: a1: table, a2: number?
    for i, j in a1 do
        u18.internal.processInstance(j, (a2 or -1) + 1)
    end
end

function u18.internal.processInstance(a1, a2) -- Line: 23
    -- upvalues: u18 (val), Imgui (val)
    local Children = a1:GetChildren()
    local v1 = if #Children ~= 0 then if not u18.internal.ExpandedInstances[a1] then "rbxasset://studio_svg_textures/Shared/Navigation/Dark/Standard/ArrowRight.png" else "rbxasset://studio_svg_textures/Shared/Navigation/Dark/Standard/ArrowDown.png" else ""
    if Imgui:BeginExplorerHorizontal(u18.internal.SelectedInstance == a1).activated() then
        u18.internal.SelectedInstance = a1
    end
    Imgui:BeginGroup((UDim2.fromOffset(a2 * 10, 0)))
    Imgui:End()
    if Imgui:ImageButton(UDim2.fromOffset(16, 16), v1).activated() then
        u18.internal.ExpandedInstances[a1] = not u18.internal.ExpandedInstances[a1]
    end
    Imgui:ExplorerClassIcon(UDim2.fromOffset(16, 16), a1)
    Imgui:BeginGroup((UDim2.fromOffset(5, 0)))
    Imgui:End()
    Imgui:Label((("<i>%*</i> [\"%*\"]"):format(a1.ClassName, a1.Name)))
    Imgui:End()
    if u18.internal.ExpandedInstances[a1] then
        u18.internal.processChildren(Children, a2 + 1)
    end
end

function u18.interface.getSelectedObject() -- Line: 54 -- upvalues: u18 (val)
    return u18.internal.SelectedInstance
end

Tab.new("Explorer", function(a1) -- Line: 58 -- upvalues: Imgui (val), u18 (val) -- types: a1: userdata
    return Imgui:Connect(a1, function() -- Line: 59 -- upvalues: Imgui (upval), u18 (upval)
        Imgui:ScrollingFrameY((UDim2.fromScale(1, 1)))
        Imgui:BeginVertical()
        u18.internal.processChildren({
            game:GetService("Workspace"),
            game:GetService("Players"),
            game:GetService("Lighting"),
            game:GetService("MaterialService"),
            game:GetService("ReplicatedFirst"),
            game:GetService("ReplicatedStorage"),
            game:GetService("ServerScriptService"),
            game:GetService("ServerStorage"),
            game:GetService("StarterGui"),
            game:GetService("StarterPack"),
            game:GetService("StarterPlayer"),
            game:GetService("Teams"),
            game:GetService("SoundService"),
            game:GetService("Chat"),
            game:GetService("TextChatService"),
            game:GetService("VoiceChatService"),
            (game:GetService("LocalizationService")),
        })
        Imgui:End()
        Imgui:End()
    end)
end)
return u18.interface