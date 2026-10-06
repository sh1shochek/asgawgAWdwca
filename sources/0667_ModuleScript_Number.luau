-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);

return function(u1: string, p2: any, p3: userdata, p4: number, u5: any, p6: number, u7: function, u8: string) -- Line: 18
    -- upvalues: Janitor (copy)
    u5.Name = u1;
    u5.Left.Label.Text = p2.DisplayName or u1;
    u5.LayoutOrder = p4;
    local u9 = p6;
    local u10 = Janitor.new();
    u10:Add(u5, "Destroy");

    local function FormatNumber(p11: number) -- Line: 39
        local math_floor_ret = math.floor(p11);

        return tostring(math_floor_ret);
    end;

    local function UpdateValue(p12: number) -- Line: 44
        -- upvalues: u9 (ref), u5 (copy)
        u9 = math.floor(p12);
        local Title = u5.Right.Dropdown.Container.Left.Title;
        local math_floor_ret = math.floor(u9);
        Title.Text = tostring(math_floor_ret);
    end;

    u9 = math.floor(u9);
    local Title = u5.Right.Dropdown.Container.Left.Title;
    local math_floor_ret = math.floor(u9);
    Title.Text = tostring(math_floor_ret);
    local Title2 = u5.Right.Dropdown.Container.Left.Title;
    local Dropdown = u5.Right.Dropdown;
    u10:Add(Dropdown.MouseButton1Click:Connect(function() -- Line: 54
        -- upvalues: Title2 (copy)
        Title2:CaptureFocus();
    end), "Disconnect");
    u10:Add(Dropdown.Activated:Connect(function() -- Line: 57
        -- upvalues: Title2 (copy)
        Title2:CaptureFocus();
    end), "Disconnect");
    u10:Add(u5.Right.Dropdown.Container.Left.Title.FocusLost:Connect(function() -- Line: 62
        -- upvalues: u5 (copy), u9 (ref), u7 (copy), u8 (copy), u1 (copy)
        local v13 = tonumber(u5.Right.Dropdown.Container.Left.Title.Text);

        if not v13 then
            local Title3 = u5.Right.Dropdown.Container.Left.Title;
            local math_floor_ret2 = math.floor(u9);
            Title3.Text = tostring(math_floor_ret2);

            return;
        end;

        u9 = math.floor(v13);
        local Title3 = u5.Right.Dropdown.Container.Left.Title;
        local math_floor_ret2 = math.floor(u9);
        Title3.Text = tostring(math_floor_ret2);
        u7(u8, u1, u9);
    end), "Disconnect");
    u5.Parent = p3;

    return function() -- Line: 76
        -- upvalues: u10 (copy)
        u10:Cleanup();
    end;
end;