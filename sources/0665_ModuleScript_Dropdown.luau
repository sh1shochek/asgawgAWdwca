-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 201, 14);

local function AnimateButton(p1: userdata, p2: boolean) -- Line: 30
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    local v3;

    if p2 then
        v3 = Color3_fromRGB_ret2;
    else
        v3 = Color3_fromRGB_ret;
    end;

    p1.TextColor3 = v3;
end;

return function(u4: string, u5: any, p6: userdata, p7: number, u8: any, p9: string, u10: function, u11: string, u12: userdata, u13: function, u14: function) -- Line: 37
    -- upvalues: Janitor (copy), Color3_fromRGB_ret (copy), GuiService (copy)
    local u15 = Janitor.new();
    local u16 = p9;
    u8:SetAttribute("IsDropdown", true);
    u8.LayoutOrder = p7;
    u8.Left.Label.Text = u5.DisplayName or u4;
    u8.Name = u4;
    local DropdownContent = u8.Right.Dropdown.DropdownContent;
    local Scroll = DropdownContent.Scroll;
    local Scale = DropdownContent.Size.Y.Scale;
    u8.Right.Dropdown.Container.Left.Title.Text = u16;
    DropdownContent.Active = false;
    DropdownContent.Visible = false;
    Scroll.Visible = false;

    local function ClearOptions() -- Line: 73
        -- upvalues: u15 (copy), Scroll (copy)
        u15:Cleanup();

        for _, child in ipairs(Scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy();
            end;
        end;
    end;

    local u17 = Janitor.new();
    u17:Add(u8, "Destroy");
    u17:Add(ClearOptions);
    u17:Add(u8.Right.Dropdown.MouseButton1Click:Connect(function() -- Line: 88
        -- upvalues: u13 (copy), Scroll (copy), u8 (copy), ClearOptions (copy), u5 (copy), u12 (copy), Color3_fromRGB_ret (ref), u15 (copy), GuiService (ref), u16 (ref), DropdownContent (copy), u14 (copy), u10 (copy), u11 (copy), u4 (copy), Scale (copy)
        local v18 = u13();
        local v19 = not Scroll.Visible;

        if v18 and v18 ~= Scroll then
            v18.Visible = false;
            local Parent = v18.Parent;

            if Parent then
                Parent.Visible = false;
            end;

            for _, child in ipairs(v18:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy();
                end;
            end;
        end;

        for _, child in ipairs(u8.Parent:GetChildren()) do
            if child:GetAttribute("IsDropdown") then
                child.ZIndex = v19 and child.Name == u8.Name and 125 or 15;
            end;
        end;

        ClearOptions();

        if not (v19 and u5.Enums) then
            Scroll.Visible = false;
            DropdownContent.Visible = false;
            u14(nil);

            return;
        end;

        local math_min_ret = math.min(#u5.Enums, 7);

        for i, v in ipairs(u5.Enums) do
            local u20 = u12:WaitForChild("OptionTemplate"):Clone();
            u20.Size = UDim2.fromScale(1, 1 / math_min_ret);
            u20.Name = `Option_{v}`;
            u20.Frame.TextButton.Text = v;
            u20.LayoutOrder = i;
            u20.Visible = true;
            u20.Parent = Scroll;
            local u21 = u8.Right.Dropdown.Container.Left.Title.Text == v;
            u20.Frame.BackgroundTransparency = u21 and 0.3 or 1;
            u20.TextColor3 = Color3_fromRGB_ret;
            u15:Add(u20.MouseEnter:Connect(function() -- Line: 143
                -- upvalues: u20 (copy), u21 (copy)
                u20.Frame.BackgroundTransparency = u21 and 0.3 or 0.65;
            end), "Disconnect", (`Option_{v}_1`));
            u15:Add(u20.MouseLeave:Connect(function() -- Line: 148
                -- upvalues: u20 (copy), u21 (copy)
                u20.Frame.BackgroundTransparency = u21 and 0.3 or 1;
            end), "Disconnect", (`Option_{v}_2`));
            u15:Add(u20.MouseButton1Click:Connect(function() -- Line: 153
                -- upvalues: GuiService (ref), Scroll (ref), u16 (ref), v (copy), u8 (ref), DropdownContent (ref), u14 (ref), u10 (ref), u11 (ref), u4 (ref), ClearOptions (ref)
                local v22;

                if GuiService.SelectedObject == nil then
                    v22 = false;
                else
                    v22 = GuiService.SelectedObject:IsDescendantOf(Scroll);
                end;

                u16 = v;
                u8.Right.Dropdown.Container.Left.Title.Text = v;
                Scroll.Visible = false;
                DropdownContent.Visible = false;
                u14(nil);
                u10(u11, u4, u16);
                ClearOptions();
                local Dropdown = u8.Right.Dropdown;

                if v22 and Dropdown:IsDescendantOf(game) then
                    GuiService.SelectedObject = Dropdown;
                end;
            end), "Disconnect", (`Option_{v}_3`));
            u15:Add(u20, "Destroy");
        end;

        DropdownContent.Size = UDim2.new(DropdownContent.Size.X, UDim.new(Scale * math_min_ret / 7, 0));
        DropdownContent.Visible = true;
        Scroll.Visible = true;
        u14(Scroll);
    end), "Disconnect");
    u8.Parent = p6;

    return function() -- Line: 197
        -- upvalues: u15 (copy), u17 (copy)
        u15:Cleanup();
        u17:Cleanup();
    end;
end;