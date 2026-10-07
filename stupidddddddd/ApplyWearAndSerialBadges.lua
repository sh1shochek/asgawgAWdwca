-- ReplicatedStorage.Components.Common.ApplyWearAndSerialBadges
-- Script path: ReplicatedStorage.Components.Common.ApplyWearAndSerialBadges
-- Decompile time: 1.37 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local CommaNumber = require(script.Parent.CommaNumber)
local u16 = {Case = true, Package = true}

local function GetWearAbbreviation(a1, a2) -- Line: 27 -- upvalues: Skins (val) -- types: a1: number?
    if typeof(a1) ~= "number" then
        return nil
    end
    if typeof(a2) == "table" and typeof(a2.floatRange) == "table" then
        local v1
        _, v1 = Skins.GetWearNameForFloat(a2, a1)
        if typeof(v1) ~= "string" then
            return nil
        end
        return Skins.GetAbbreviatedWearName(v1)
    end
    return nil
end

return function(a1, a2, a3) -- Line: 53
    -- upvalues: GetWearAbbreviation (val), u16 (val), CommaNumber (val)
    local v1
    local ItemContent = a1:FindFirstChild("ItemContent")
    if not ItemContent then
        return
    end
    local Rarity = ItemContent:FindFirstChild("Rarity")
    if not Rarity then
        return
    end
    local v2 = GetWearAbbreviation(tonumber(a2.Float), a3)
    local Condition = Rarity:FindFirstChild("Condition")
    if Condition and Condition:IsA("ImageLabel") then
        for i, j in Condition:GetChildren() do
            if j:IsA("UIGradient") then
                j.Enabled = false
            end
        end
        Condition.Visible = v2 ~= nil
        if v2 then
            local WearAbbreviation = Condition:FindFirstChild("WearAbbreviation")
            if WearAbbreviation and WearAbbreviation:IsA("TextLabel") then
                WearAbbreviation.Text = v2
            end
            v1 = Condition:FindFirstChild(v2 .. "Gradient")
            if v1 and v1:IsA("UIGradient") then
                v1.Enabled = true
            end
        end
    end
    local Serial = Rarity:FindFirstChild("Serial")
    if Serial and Serial:IsA("ImageLabel") then
        v1 = if not u16[a2.Type] then tonumber(a2.Serial) else nil
        local v3 = false
        if v1 ~= nil then
            v3 = v1 > 0
        end
        Serial.Visible = v3
        local SerialText = Serial:FindFirstChild("SerialText")
        if SerialText and SerialText:IsA("TextLabel") then
            if v1 then
                SerialText.Text = ("#%*"):format((CommaNumber(v1)))
            end
            SerialText.Size = UDim2.fromScale(if not v2 then 1 else 0.557, SerialText.Size.Y.Scale)
        end
    end
end