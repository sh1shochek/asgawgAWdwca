-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local CommaNumber = require(script.Parent.CommaNumber);
local u1 = {
    Case = true,
    Package = true
};

local function GetWearAbbreviation(p2: number?, p3: any) -- Line: 27
    -- upvalues: Skins (copy)
    if typeof(p2) ~= "number" then
        return nil;
    end;

    if typeof(p3) ~= "table" or typeof(p3.floatRange) ~= "table" then
        return nil;
    end;

    local _, v4 = Skins.GetWearNameForFloat(p3, p2);

    if typeof(v4) == "string" then
        return Skins.GetAbbreviatedWearName(v4);
    end;

    return nil;
end;

return function(p5: userdata, p6: any, p7: any) -- Line: 53
    -- upvalues: GetWearAbbreviation (copy), u1 (copy), CommaNumber (copy)
    local ItemContent = p5:FindFirstChild("ItemContent");

    if not ItemContent then
        return;
    end;

    local Rarity = ItemContent:FindFirstChild("Rarity");

    if not Rarity then
        return;
    end;

    local v8 = GetWearAbbreviation(tonumber(p6.Float), p7);
    local Condition = Rarity:FindFirstChild("Condition");

    if Condition and Condition:IsA("ImageLabel") then
        for _, child in Condition:GetChildren() do
            if child:IsA("UIGradient") then
                child.Enabled = false;
            end;
        end;

        Condition.Visible = v8 ~= nil;

        if v8 then
            local WearAbbreviation = Condition:FindFirstChild("WearAbbreviation");

            if WearAbbreviation and WearAbbreviation:IsA("TextLabel") then
                WearAbbreviation.Text = v8;
            end;

            local v9 = Condition:FindFirstChild(v8 .. "Gradient");

            if v9 and v9:IsA("UIGradient") then
                v9.Enabled = true;
            end;
        end;
    end;

    local Serial = Rarity:FindFirstChild("Serial");

    if Serial and Serial:IsA("ImageLabel") then
        local v10;

        if u1[p6.Type] then
            v10 = nil;
        else
            v10 = tonumber(p6.Serial);
        end;

        local v11;

        if v10 == nil then
            v11 = false;
        else
            v11 = v10 > 0;
        end;

        Serial.Visible = v11;
        local SerialText = Serial:FindFirstChild("SerialText");

        if SerialText and SerialText:IsA("TextLabel") then
            if v10 then
                SerialText.Text = `#{CommaNumber(v10)}`;
            end;

            SerialText.Size = UDim2.fromScale(v8 and 0.557 or 1, SerialText.Size.Y.Scale);
        end;
    end;
end;