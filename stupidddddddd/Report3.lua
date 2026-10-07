-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Report
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Report
-- Decompile time: 5.78 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local LocalPlayer = Players.LocalPlayer
local u27 = nil
local u28 = nil
local u29 = nil
local u30 = nil
local u31 = {}
local u32 = false
local u33 = {}

local function getReasonOption(a1) -- Line: 33 -- upvalues: u31 (ref) -- types: a1: string
    for i, j in u31 do
        if j.name == a1 then
            return j
        end
    end
    return nil
end

local function setReasonChecked(a1, a2) -- Line: 42 -- types: a1: table, a2: boolean
    if a1.icon then
        a1.icon.Visible = a2
    end
end

local function clearOtherText() -- Line: 48 -- upvalues: u31 (ref), u32 (ref)
    local v1
    for i, j in u31 do
        if j.name == "Other" then
            v1 = j
            if v1 and v1.textBox then
                u32 = true
                v1.textBox.Text = ""
                u32 = false
            end
            return
        end
    end
    v1 = nil
    if v1 and v1.textBox then
        u32 = true
        v1.textBox.Text = ""
        u32 = false
    end
end

local function clearSelection() -- Line: 57 -- upvalues: u30 (ref), u31 (ref), u32 (ref)
    u30 = nil
    local v1 = u31
    for i, j in v1 do
        if j.icon then
            j.icon.Visible = false
        end
    end
    for k, n in u31 do
        if n.name == "Other" then
            v1 = n
            if v1 and v1.textBox then
                u32 = true
                v1.textBox.Text = ""
                u32 = false
            end
            return
        end
    end
    v1 = nil
    if v1 and v1.textBox then
        u32 = true
        v1.textBox.Text = ""
        u32 = false
    end
end

local function selectReason(a1) -- Line: 65 -- upvalues: u30 (ref), u31 (ref), u32 (ref) -- types: a1: string
    local v1
    u30 = a1
    local v2 = u31
    local v3 = nil
    local v4 = nil
    local v5 = a1
    for i, j in v2, v3, v4 do
        v1 = j.name == v5
        if j.icon then
            j.icon.Visible = v1
        end
    end
    if v5 ~= "Other" then
        for k, n in u31 do
            if n.name == "Other" then
                v2 = n
                if v2 and v2.textBox then
                    u32 = true
                    v2.textBox.Text = ""
                    u32 = false
                end
                return
            end
        end
        v2 = nil
        if v2 and v2.textBox then
            u32 = true
            v2.textBox.Text = ""
            u32 = false
        end
    end
end

local function toggleReason(a1) -- Line: 76 -- upvalues: u30 (ref), u31 (ref), u32 (ref) -- types: a1: string
    local v1, v2
    if u30 == a1 then
        u30 = nil
        v1 = u31
        for m, i5 in v1 do
            if i5.icon then
                i5.icon.Visible = false
            end
        end
        for i6, i7 in u31 do
            if i7.name == "Other" then
                v1 = i7
                if v1 and v1.textBox then
                    u32 = true
                    v1.textBox.Text = ""
                    u32 = false
                end
                return
            end
        end
        v1 = nil
        if v1 and v1.textBox then
            u32 = true
            v1.textBox.Text = ""
            u32 = false
        end
        return
    end
    u30 = a1
    v1 = u31
    local v3 = nil
    local v4 = nil
    local v5 = a1
    for i, j in v1, v3, v4 do
        v2 = j.name == v5
        if j.icon then
            j.icon.Visible = v2
        end
    end
    if v5 ~= "Other" then
        for k, n in u31 do
            if n.name == "Other" then
                v1 = n
                if v1 and v1.textBox then
                    u32 = true
                    v1.textBox.Text = ""
                    u32 = false
                end
                return
            end
        end
        v1 = nil
        if v1 and v1.textBox then
            u32 = true
            v1.textBox.Text = ""
            u32 = false
        end
    end
end

local function onOtherTextChanged(a1) -- Line: 85 -- upvalues: u32 (ref), u31 (ref), u30 (ref) -- types: a1: string
    if u32 then
        return
    end
    local v1 = utf8.len(a1)
    if v1 and v1 > 100 then
        local v2
        local v3 = utf8.offset(a1, 101)
        for i, j in u31 do
            if j.name == "Other" then
                v2 = j
                if v3 and v2 and v2.textBox then
                    a1 = string.sub(a1, 1, v3 - 1)
                    u32 = true
                    v2.textBox.Text = a1
                    u32 = false
                end
                if a1 == "" then
                    if u30 == "Other" then
                        u30 = nil
                    end
                    return
                end
                u30 = "Other"
                for k, n in u31 do
                    if n.name ~= "Other" and n.icon then
                        n.icon.Visible = false
                    end
                end
                return
            end
        end
        v2 = nil
        if v3 and v2 and v2.textBox then
            a1 = string.sub(a1, 1, v3 - 1)
            u32 = true
            v2.textBox.Text = a1
            u32 = false
        end
    end
    if a1 == "" then
        if u30 == "Other" then
            u30 = nil
        end
        return
    end
    u30 = "Other"
    for m, i5 in u31 do
        if i5.name ~= "Other" and i5.icon then
            i5.icon.Visible = false
        end
    end
end

local function bindReasonOption(a1) -- Line: 119
    -- upvalues: ActivateButton (val), onOtherTextChanged (val), u30 (ref), u31 (ref), u32 (ref)
    local Name = a1.Name
    if Name ~= "Toxicity" and Name ~= "Bot" and Name ~= "Cheating" and Name ~= "Other" then
        return
    end
    local Check = a1:FindFirstChild("Check")
    if Check and Check:IsA("ImageButton") then
        local Icon = Check:FindFirstChild("Icon")
        local TextBox = Check:FindFirstChild("TextBox")
        local u19 = {name = Name, checkButton = Check}
        u19.icon = if not Icon then nil else if not Icon:IsA("ImageLabel") then nil else Icon
        u19.textBox = if not TextBox then nil else if not TextBox:IsA("TextBox") then nil else TextBox
        if u19.icon then
            u19.icon.Visible = false
        end
        ActivateButton(Check)
        if Name ~= "Other" then
            Check.MouseButton1Click:Connect(function() -- Line: 164 -- upvalues: Name (val), u30 (upval), u31 (upval), u32 (upval)
                local v1, v2
                local v3 = Name
                if u30 == v3 then
                    u30 = nil
                    v1 = u31
                    for m, i5 in v1 do
                        if i5.icon then
                            i5.icon.Visible = false
                        end
                    end
                    for i6, i7 in u31 do
                        if i7.name == "Other" then
                            v1 = i7
                            if v1 and v1.textBox then
                                u32 = true
                                v1.textBox.Text = ""
                                u32 = false
                                return
                            end
                            return
                        end
                    end
                    v1 = nil
                    if v1 and v1.textBox then
                        u32 = true
                        v1.textBox.Text = ""
                        u32 = false
                        return
                    end
                    return
                end
                u30 = v3
                v1 = u31
                local v4 = nil
                local v5 = nil
                for i, j in v1, v4, v5 do
                    v2 = j.name == v3
                    if j.icon then
                        j.icon.Visible = v2
                    end
                end
                if v3 ~= "Other" then
                    for k, n in u31 do
                        if n.name == "Other" then
                            v1 = n
                            if v1 and v1.textBox then
                                u32 = true
                                v1.textBox.Text = ""
                                u32 = false
                            end
                            return
                        end
                    end
                    v1 = nil
                    if v1 and v1.textBox then
                        u32 = true
                        v1.textBox.Text = ""
                        u32 = false
                    end
                end
            end)
        else
            Check.MouseButton1Click:Connect(function() -- Line: 144 -- upvalues: u19 (val)
                if u19.textBox then
                    u19.textBox:CaptureFocus()
                end
            end)
            if u19.textBox then
                u19.textBox.ClearTextOnFocus = false
                u19.textBox.MultiLine = false
                u19.textBox.TextWrapped = false
                u19.textBox.TextXAlignment = Enum.TextXAlignment.Left
                u19.textBox.ClipsDescendants = true
                Check.ClipsDescendants = true
                ;(u19.textBox:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 159 -- upvalues: onOtherTextChanged (upval), u19 (val)
                    onOtherTextChanged(u19.textBox.Text)
                end)
            end
        end
        table.insert(u31, u19)
        return
    end
end

function u0.Close() -- Line: 172
    -- upvalues: u27 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref), CameraController (val)
    if u27 then
        u27.Visible = false
    end
    u29 = nil
    u30 = nil
    local v1 = u31
    for i, j in v1 do
        if j.icon then
            j.icon.Visible = false
        end
    end
    for k, n in u31 do
        if n.name == "Other" then
            v1 = n
            if v1 and v1.textBox then
                u32 = true
                v1.textBox.Text = ""
                u32 = false
            end
            CameraController.setForceLockOverride("Report", false)
            return
        end
    end
    v1 = nil
    if v1 and v1.textBox then
        u32 = true
        v1.textBox.Text = ""
        u32 = false
    end
    CameraController.setForceLockOverride("Report", false)
end

function u0.Open(a1) -- Line: 181
    -- upvalues: LocalPlayer (val), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u28 (ref), u27 (ref)
    -- upvalues: CameraController (val)
    if a1 == LocalPlayer then
        return
    end
    u29 = a1
    u30 = nil
    local v1 = u31
    for i, j in v1 do
        if j.icon then
            j.icon.Visible = false
        end
    end
    for k, n in u31 do
        if n.name == "Other" then
            v1 = n
            if v1 and v1.textBox then
                u32 = true
                v1.textBox.Text = ""
                u32 = false
            end
            if u28 then
                u28.Text = ("Reporting %*"):format(a1.Name)
            end
            if u27 then
                u27.Visible = true
            end
            CameraController.setForceLockOverride("Report", true)
            return
        end
    end
    v1 = nil
    if v1 and v1.textBox then
        u32 = true
        v1.textBox.Text = ""
        u32 = false
    end
    if u28 then
        u28.Text = ("Reporting %*"):format(a1.Name)
    end
    if u27 then
        u27.Visible = true
    end
    CameraController.setForceLockOverride("Report", true)
end

function u0.Submit() -- Line: 200
    -- upvalues: u29 (ref), u30 (ref), LocalPlayer (val), u0 (val), u33 (val), Remotes (val)
    local v1 = u29
    local v2 = u30
    if v1 and v1 ~= LocalPlayer and v2 then
        if u33[v1.UserId] then
            u0.Close()
            return
        end
        u33[v1.UserId] = true
        Remotes.Player.SubmitPlayerReport.Send({
            ReportedPlayer = v1,
            Reason = v2,
            Detail = if v2 ~= "Other" then nil else u0.GetOtherReasonText(),
        })
        u0.Close()
        return
    end
    u0.Close()
end

function u0.GetOtherReasonText() -- Line: 228 -- upvalues: u31 (ref)
    local v1
    for i, j in u31 do
        if j.name == "Other" then
            v1 = j
            if v1 and v1.textBox then
                return v1.textBox.Text
            end
            return ""
        end
    end
    v1 = nil
    if v1 and v1.textBox then
        return v1.textBox.Text
    end
    return ""
end

function u0.Initialize(a1, a2) -- Line: 236
    -- upvalues: u27 (ref), u28 (ref), u31 (ref), bindReasonOption (val), ActivateButton (val), u0 (val)
    a2.Visible = false
    local Main = a2:FindFirstChild("Main")
    local Top = Main and Main:FindFirstChild("Top")
    local Reason = Main and Main:FindFirstChild("Reason")
    local Options = Main and Main:FindFirstChild("Options")
    u28 = Top and Top:FindFirstChild("TextLabel")
    u31 = {}
    if Reason then
        for i, j in Reason:GetChildren() do
            if j:IsA("Frame") then
                bindReasonOption(j)
            end
        end
    end
    if Options then
        local Close = Options:FindFirstChild("Close")
        if Close and Close:IsA("ImageButton") then
            ActivateButton(Close)
            Close.MouseButton1Click:Connect(u0.Close)
        end
        local Report = Options:FindFirstChild("Report")
        if Report and Report:IsA("ImageButton") then
            ActivateButton(Report)
            Report.MouseButton1Click:Connect(u0.Submit)
        end
    end
end

return u0