-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GetBindIcon = require(ReplicatedStorage.Components.Common.GetBindIcon);
local KeybindParser = require(ReplicatedStorage.Controllers.InputController.KeybindParser);
local Color3_fromRGB_ret = Color3.fromRGB(255, 90, 90);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);

function u1.GetTextBox(p2: userdata) -- Line: 25
    local TextBox = p2:FindFirstChild("TextBox", true);

    if TextBox and TextBox:IsA("TextBox") then
        return TextBox;
    end;

    return nil;
end;

function u1.GetIcon(p3: userdata) -- Line: 30
    local Bind = p3:FindFirstChild("Bind", true);

    if Bind and Bind:IsA("ImageLabel") then
        return Bind;
    end;

    return nil;
end;

function u1.GetReset(p4: userdata) -- Line: 35
    local Reset = p4:FindFirstChild("Reset", true);

    if Reset and Reset:IsA("GuiObject") then
        return Reset;
    end;

    return nil;
end;

function u1.FormatText(p5: string) -- Line: 41
    return p5 == "" and "" or p5:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "");
end;

function u1.GetIconImage(p6: string) -- Line: 50
    -- upvalues: KeybindParser (copy), GetBindIcon (copy)
    if p6 == "" then
        return nil;
    end;

    local v7 = KeybindParser.parse(p6);

    if typeof(v7) == "EnumItem" then
        return GetBindIcon(v7);
    end;

    return nil;
end;

function u1.Apply(p8: userdata, p9: string) -- Line: 65
    -- upvalues: u1 (copy), Color3_fromRGB_ret2 (copy)
    local TextBox = u1.GetTextBox(p8);

    if not TextBox then
        return;
    end;

    local v10 = p9 == "";
    local IconImage = u1.GetIconImage(p9);
    local Icon = u1.GetIcon(p8);

    if Icon then
        Icon.Image = IconImage or "";
        Icon.ImageColor3 = Color3_fromRGB_ret2;
        Icon.Visible = IconImage ~= nil;
    end;

    local v11;

    if Icon == nil then
        v11 = false;
    else
        v11 = IconImage ~= nil;
    end;

    TextBox.TextEditable = false;
    TextBox.Active = true;
    TextBox.PlaceholderText = v10 and "None" or "";
    TextBox.Text = (v10 or v11) and "" or u1.FormatText(p9);
    local Reset = u1.GetReset(p8);

    if Reset then
        Reset.Visible = not v10;
    end;
end;

function u1.HideIcon(p12: userdata) -- Line: 97
    -- upvalues: u1 (copy)
    local Icon = u1.GetIcon(p12);

    if Icon then
        Icon.Visible = false;
    end;
end;

function u1.SetConflict(p13: userdata, p14: boolean) -- Line: 105
    -- upvalues: u1 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local Icon = u1.GetIcon(p13);

    if Icon then
        local v15;

        if p14 then
            v15 = Color3_fromRGB_ret;
        else
            v15 = Color3_fromRGB_ret2;
        end;

        Icon.ImageColor3 = v15;
    end;
end;

return u1;