-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent.Parent;
local Tab = require(Parent.Tab);
local Imgui = require(Parent.Imgui);
require(script.ClassIcon);
require(script.BeginExplorerHorizontal);
local u1 = {
    interface = {},
    internal = {
        SelectedInstance = nil,
        ExpandedInstances = {}
    }
};

function u1.internal.processChildren(p2: table, p3: number?) -- Line: 17
    -- upvalues: u1 (copy)
    for _, v in p2 do
        u1.internal.processInstance(v, (p3 or -1) + 1);
    end;
end;

function u1.internal.processInstance(p4: userdata, p5: number) -- Line: 23
    -- upvalues: u1 (copy), Imgui (copy)
    local Children = p4:GetChildren();
    local v6 = #Children == 0 and "" or (u1.internal.ExpandedInstances[p4] and "rbxasset://studio_svg_textures/Shared/Navigation/Dark/Standard/ArrowDown.png" or "rbxasset://studio_svg_textures/Shared/Navigation/Dark/Standard/ArrowRight.png");

    if Imgui:BeginExplorerHorizontal(u1.internal.SelectedInstance == p4).activated() then
        u1.internal.SelectedInstance = p4;
    end;

    Imgui:BeginGroup(UDim2.fromOffset(p5 * 10, 0));
    Imgui:End();

    if Imgui:ImageButton(UDim2.fromOffset(16, 16), v6).activated() then
        u1.internal.ExpandedInstances[p4] = not u1.internal.ExpandedInstances[p4];
    end;

    Imgui:ExplorerClassIcon(UDim2.fromOffset(16, 16), p4);
    Imgui:BeginGroup(UDim2.fromOffset(5, 0));
    Imgui:End();
    Imgui:Label((`<i>{p4.ClassName}</i> ["{p4.Name}"]`));
    Imgui:End();

    if u1.internal.ExpandedInstances[p4] then
        u1.internal.processChildren(Children, p5 + 1);
    end;
end;

function u1.interface.getSelectedObject() -- Line: 54
    -- upvalues: u1 (copy)
    return u1.internal.SelectedInstance;
end;

Tab.new("Explorer", function(p7: userdata) -- Line: 58
    -- upvalues: Imgui (copy), u1 (copy)
    return Imgui:Connect(p7, function() -- Line: 59
        -- upvalues: Imgui (ref), u1 (ref)
        Imgui:ScrollingFrameY(UDim2.fromScale(1, 1));
        Imgui:BeginVertical();
        u1.internal.processChildren({
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
            game:GetService("LocalizationService")
        });
        Imgui:End();
        Imgui:End();
    end);
end);

return u1.interface;