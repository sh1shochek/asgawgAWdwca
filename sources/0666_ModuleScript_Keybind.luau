-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local BindDisplay = require(script.Parent.Parent.BindDisplay);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local u1 = { "Computer", "Console" };

local function GetKeybindTextBox(p2: userdata) -- Line: 22
    -- upvalues: BindDisplay (copy)
    return BindDisplay.GetTextBox(p2);
end;

local function GetKeybindReset(p3: userdata) -- Line: 26
    -- upvalues: BindDisplay (copy)
    local Reset = BindDisplay.GetReset(p3);

    if Reset and Reset:IsA("GuiButton") then
        return Reset;
    end;

    return nil;
end;

return function(u4: string, p5: any, p6: userdata, p7: number, p8: any, p9: any, u10: function, u11: string, u12: function, p13: function) -- Line: 34
    -- upvalues: Janitor (copy), u1 (copy), BindDisplay (copy)
    p8.LayoutOrder = p7;
    p8.Left.Label.Text = p5.DisplayName or u4;
    p8.Name = u4;
    local u14 = Janitor.new();
    u14:Add(p8, "Destroy");
    local u15 = {};

    for _, v in u1 do
        local v16 = p9[v];

        if v16 == nil then
            if p5.Default then
                local Default = p5.Default;
                u15[v] = typeof(Default) == "table" and (Default[v] or "") or "";
            else
                u15[v] = "";
            end;
        else
            u15[v] = v16;
        end;
    end;

    local function UpdateKeybindUI(p17: userdata, p18: string) -- Line: 70
        -- upvalues: BindDisplay (ref)
        BindDisplay.Apply(p17, p18);
    end;

    local function SaveKeybinds() -- Line: 75
        -- upvalues: u10 (copy), u11 (copy), u4 (copy), u15 (copy)
        u10(u11, u4, {
            Computer = u15.Computer,
            Console = u15.Console
        });
    end;

    for _, v in u1 do
        local u19 = p8.Right:FindFirstChild(v);

        if u19 then
            BindDisplay.Apply(u19, u15[v]);
            local TextBox = BindDisplay.GetTextBox(u19);

            if TextBox then
                u14:Add(TextBox.Focused:Connect(function() -- Line: 92
                    -- upvalues: u12 (copy), TextBox (copy), u15 (copy), v (copy)
                    u12(TextBox, u15[v], tick());
                end), "Disconnect");
            end;

            local Reset = BindDisplay.GetReset(u19);

            if not (Reset and Reset:IsA("GuiButton")) then
                Reset = nil;
            end;

            if Reset then
                u14:Add(Reset.MouseButton1Click:Connect(function() -- Line: 100
                    -- upvalues: u15 (copy), v (copy), u19 (copy), BindDisplay (ref), u10 (copy), u11 (copy), u4 (copy)
                    u15[v] = "";
                    BindDisplay.Apply(u19, u15[v]);
                    u10(u11, u4, {
                        Computer = u15.Computer,
                        Console = u15.Console
                    });
                end), "Disconnect");
            end;

            p13(v, u15[v]);
        end;
    end;

    p8.Parent = p6;

    return function() -- Line: 115
        -- upvalues: u14 (copy)
        u14:Cleanup();
    end;
end;