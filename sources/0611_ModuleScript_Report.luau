-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = {};
local u7 = false;
local u8 = {};

local function getReasonOption(p9: string) -- Line: 33
    -- upvalues: u6 (ref)
    for _, v in u6 do
        if v.name == p9 then
            return v;
        end;
    end;

    return nil;
end;

local function setReasonChecked(p10: table, p11: boolean) -- Line: 42
    if p10.icon then
        p10.icon.Visible = p11;
    end;
end;

local function clearOtherText() -- Line: 48
    -- upvalues: u6 (ref), u7 (ref)
    local v12 = nil;

    for _, v in u6 do
        if v.name == "Other" then
            v12 = v;
            break;
        end;
    end;

    if v12 and v12.textBox then
        u7 = true;
        v12.textBox.Text = "";
        u7 = false;
    end;
end;

local function clearSelection() -- Line: 57
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    u5 = nil;

    for _, v in u6 do
        if v.icon then
            v.icon.Visible = false;
        end;
    end;

    local v13 = nil;

    for _, v in u6 do
        if v.name == "Other" then
            v13 = v;
            break;
        end;
    end;

    if v13 and v13.textBox then
        u7 = true;
        v13.textBox.Text = "";
        u7 = false;
    end;
end;

local function selectReason(p14: string) -- Line: 65
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    u5 = p14;

    for _, v in u6 do
        local v15 = v.name == p14;

        if v.icon then
            v.icon.Visible = v15;
        end;
    end;

    if p14 ~= "Other" then
        local v16 = nil;

        for _, v in u6 do
            if v.name == "Other" then
                v16 = v;
                break;
            end;
        end;

        if v16 and v16.textBox then
            u7 = true;
            v16.textBox.Text = "";
            u7 = false;
        end;
    end;
end;

local function toggleReason(p17: string) -- Line: 76
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    if u5 ~= p17 then
        u5 = p17;

        for _, v in u6 do
            local v18 = v.name == p17;

            if v.icon then
                v.icon.Visible = v18;
            end;
        end;

        if p17 ~= "Other" then
            local v19 = nil;

            for _, v in u6 do
                if v.name == "Other" then
                    v19 = v;
                    break;
                end;
            end;

            if v19 and v19.textBox then
                u7 = true;
                v19.textBox.Text = "";
                u7 = false;
            end;
        end;

        return;
    end;

    u5 = nil;

    for _, v in u6 do
        if v.icon then
            v.icon.Visible = false;
        end;
    end;

    local v20 = nil;

    for _, v in u6 do
        if v.name == "Other" then
            v20 = v;
            break;
        end;
    end;

    if v20 and v20.textBox then
        u7 = true;
        v20.textBox.Text = "";
        u7 = false;
    end;
end;

local function onOtherTextChanged(p21: string) -- Line: 85
    -- upvalues: u7 (ref), u6 (ref), u5 (ref)
    if u7 then
        return;
    end;

    local utf8_len_ret = utf8.len(p21);

    if utf8_len_ret and utf8_len_ret > 100 then
        local utf8_offset_ret = utf8.offset(p21, 101);
        local v22 = nil;

        for _, v in u6 do
            if v.name == "Other" then
                v22 = v;
                break;
            end;
        end;

        if utf8_offset_ret and (v22 and v22.textBox) then
            p21 = string.sub(p21, 1, utf8_offset_ret - 1);
            u7 = true;
            v22.textBox.Text = p21;
            u7 = false;
        end;
    end;

    if p21 == "" then
        if u5 == "Other" then
            u5 = nil;
        end;

        return;
    end;

    u5 = "Other";

    for _, v in u6 do
        if v.name ~= "Other" and v.icon then
            v.icon.Visible = false;
        end;
    end;
end;

local function bindReasonOption(p23: userdata) -- Line: 119
    -- upvalues: ActivateButton (copy), onOtherTextChanged (copy), u5 (ref), u6 (ref), u7 (ref)
    local Name = p23.Name;

    if Name ~= "Toxicity" and (Name ~= "Bot" and (Name ~= "Cheating" and Name ~= "Other")) then
        return;
    end;

    local Check = p23:FindFirstChild("Check");

    if not (Check and Check:IsA("ImageButton")) then
        return;
    end;

    local Icon = Check:FindFirstChild("Icon");
    local TextBox = Check:FindFirstChild("TextBox");
    local u24 = {
        name = Name,
        checkButton = Check
    };

    if not (Icon and Icon:IsA("ImageLabel")) then
        Icon = nil;
    end;

    u24.icon = Icon;

    if not (TextBox and TextBox:IsA("TextBox")) then
        TextBox = nil;
    end;

    u24.textBox = TextBox;

    if u24.icon then
        u24.icon.Visible = false;
    end;

    ActivateButton(Check);

    if Name == "Other" then
        Check.MouseButton1Click:Connect(function() -- Line: 144
            -- upvalues: u24 (copy)
            if u24.textBox then
                u24.textBox:CaptureFocus();
            end;
        end);

        if u24.textBox then
            u24.textBox.ClearTextOnFocus = false;
            u24.textBox.MultiLine = false;
            u24.textBox.TextWrapped = false;
            u24.textBox.TextXAlignment = Enum.TextXAlignment.Left;
            u24.textBox.ClipsDescendants = true;
            Check.ClipsDescendants = true;
            u24.textBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 159
                -- upvalues: onOtherTextChanged (ref), u24 (copy)
                onOtherTextChanged(u24.textBox.Text);
            end);
        end;
    else
        Check.MouseButton1Click:Connect(function() -- Line: 164
            -- upvalues: Name (copy), u5 (ref), u6 (ref), u7 (ref)
            local v25 = Name;

            if u5 == v25 then
                u5 = nil;

                for _, v in u6 do
                    if v.icon then
                        v.icon.Visible = false;
                    end;
                end;

                local v26 = nil;

                for _, v in u6 do
                    if v.name == "Other" then
                        v26 = v;
                        break;
                    end;
                end;

                if v26 and v26.textBox then
                    u7 = true;
                    v26.textBox.Text = "";
                    u7 = false;
                end;
            else
                u5 = v25;

                for _, v in u6 do
                    local v27 = v.name == v25;

                    if v.icon then
                        v.icon.Visible = v27;
                    end;
                end;

                if v25 ~= "Other" then
                    local v28 = nil;

                    for _, v in u6 do
                        if v.name == "Other" then
                            v28 = v;
                            break;
                        end;
                    end;

                    if v28 and v28.textBox then
                        u7 = true;
                        v28.textBox.Text = "";
                        u7 = false;
                    end;
                end;
            end;
        end);
    end;

    table.insert(u6, u24);
end;

function u1.Close() -- Line: 172
    -- upvalues: u2 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), CameraController (copy)
    if u2 then
        u2.Visible = false;
    end;

    u4 = nil;
    u5 = nil;

    for _, v in u6 do
        if v.icon then
            v.icon.Visible = false;
        end;
    end;

    local v29 = nil;

    for _, v in u6 do
        if v.name == "Other" then
            v29 = v;
            break;
        end;
    end;

    if v29 and v29.textBox then
        u7 = true;
        v29.textBox.Text = "";
        u7 = false;
    end;

    CameraController.setForceLockOverride("Report", false);
end;

function u1.Open(p30: userdata) -- Line: 181
    -- upvalues: LocalPlayer (copy), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u3 (ref), u2 (ref), CameraController (copy)
    if p30 == LocalPlayer then
        return;
    end;

    u4 = p30;
    u5 = nil;

    for _, v in u6 do
        if v.icon then
            v.icon.Visible = false;
        end;
    end;

    local v31 = nil;

    for _, v in u6 do
        if v.name == "Other" then
            v31 = v;
            break;
        end;
    end;

    if v31 and v31.textBox then
        u7 = true;
        v31.textBox.Text = "";
        u7 = false;
    end;

    if u3 then
        u3.Text = `Reporting {p30.Name}`;
    end;

    if u2 then
        u2.Visible = true;
    end;

    CameraController.setForceLockOverride("Report", true);
end;

function u1.Submit() -- Line: 200
    -- upvalues: u4 (ref), u5 (ref), LocalPlayer (copy), u1 (copy), u8 (copy), Remotes (copy)
    local v32 = u4;
    local v33 = u5;

    if not (v32 and (v32 ~= LocalPlayer and v33)) then
        u1.Close();

        return;
    end;

    if u8[v32.UserId] then
        u1.Close();

        return;
    end;

    u8[v32.UserId] = true;
    local v34;

    if v33 == "Other" then
        v34 = u1.GetOtherReasonText();
    else
        v34 = nil;
    end;

    Remotes.Player.SubmitPlayerReport.Send({
        ReportedPlayer = v32,
        Reason = v33,
        Detail = v34
    });
    u1.Close();
end;

function u1.GetOtherReasonText() -- Line: 228
    -- upvalues: u6 (ref)
    local v35 = nil;

    for _, v in u6 do
        if v.name == "Other" then
            v35 = v;
            break;
        end;
    end;

    return not (v35 and v35.textBox) and "" or v35.textBox.Text;
end;

function u1.Initialize(p36: userdata, p37: userdata) -- Line: 236
    -- upvalues: u2 (ref), u3 (ref), u6 (ref), bindReasonOption (copy), ActivateButton (copy), u1 (copy)
    u2 = p37;
    u2.Visible = false;
    local Main = p37:FindFirstChild("Main");
    local v38;

    if Main then
        v38 = Main:FindFirstChild("Top");
    else
        v38 = Main;
    end;

    local v39;

    if Main then
        v39 = Main:FindFirstChild("Reason");
    else
        v39 = Main;
    end;

    if Main then
        Main = Main:FindFirstChild("Options");
    end;

    if v38 then
        v38 = v38:FindFirstChild("TextLabel");
    end;

    u3 = v38;
    u6 = {};

    if v39 then
        for _, child in v39:GetChildren() do
            if child:IsA("Frame") then
                bindReasonOption(child);
            end;
        end;
    end;

    if Main then
        local Close = Main:FindFirstChild("Close");

        if Close and Close:IsA("ImageButton") then
            ActivateButton(Close);
            Close.MouseButton1Click:Connect(u1.Close);
        end;

        local Report = Main:FindFirstChild("Report");

        if Report and Report:IsA("ImageButton") then
            ActivateButton(Report);
            Report.MouseButton1Click:Connect(u1.Submit);
        end;
    end;
end;

return u1;