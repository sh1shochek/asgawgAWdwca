-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local Color3_fromRGB_ret = Color3.fromRGB(77, 77, 77);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);
local u1 = { "1", "2" };

return function(u2: string, p3: any, p4: userdata, p5: number, p6: any, p7: boolean, u8: function, u9: string) -- Line: 27
    -- upvalues: Janitor (copy), u1 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    p6.Name = u2;
    p6.Left.Label.Text = p3.DisplayName or u2;
    p6.LayoutOrder = p5;
    local u10 = p7;
    local u11 = Janitor.new();
    u11:Add(p6, "Destroy");
    local Switch = p6.Right.Switch;
    local Selection = Switch.Selection;
    local Title = Selection.Title;
    local Frame = Selection:FindFirstChild("Frame");

    local function UpdateToggleVisual(p12: boolean) -- Line: 54
        -- upvalues: Title (copy), Frame (copy), u1 (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref)
        Title.Text = p12 and "ON" or "OFF";

        if not Frame then
            return;
        end;

        for i, v in ipairs(u1) do
            local v13 = Frame:FindFirstChild(v);

            if v13 and v13:IsA("GuiObject") then
                local v14;

                if i == 2 == p12 then
                    v14 = Color3_fromRGB_ret2;
                else
                    v14 = Color3_fromRGB_ret;
                end;

                v13.BackgroundColor3 = v14;
            end;
        end;
    end;

    UpdateToggleVisual(u10);

    local function SetEnabled(p15: boolean) -- Line: 73
        -- upvalues: u10 (ref), UpdateToggleVisual (copy), u8 (copy), u9 (copy), u2 (copy)
        if p15 == u10 then
            return;
        end;

        u10 = p15;
        UpdateToggleVisual(u10);
        u8(u9, u2, u10);
    end;

    local function Toggle() -- Line: 84
        -- upvalues: u10 (ref), UpdateToggleVisual (copy), u8 (copy), u9 (copy), u2 (copy)
        local v16 = not u10;

        if v16 == u10 then
            return;
        end;

        u10 = v16;
        UpdateToggleVisual(u10);
        u8(u9, u2, u10);
    end;

    u11:Add(Switch.MouseButton1Click:Connect(Toggle), "Disconnect");

    for _, v in { "Left", "Right" } do
        local v17 = Switch:FindFirstChild(v);

        if v17 and v17:IsA("GuiButton") then
            u11:Add(v17.MouseButton1Click:Connect(Toggle), "Disconnect");
        end;
    end;

    p6.Parent = p4;

    return function() -- Line: 100
        -- upvalues: u11 (copy)
        u11:Cleanup();
    end;
end;