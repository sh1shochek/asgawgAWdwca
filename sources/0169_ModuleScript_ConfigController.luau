-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys);
local u1 = RunService:IsServer();
local u2 = RunService:IsStudio();
local LocalPlayer = Players.LocalPlayer;
local u3 = {};
local u4 = nil;

local function getSnapshot() -- Line: 20
    -- upvalues: u1 (copy), u4 (ref)
    if not u1 then
        return nil;
    end;

    if u4 then
        return u4;
    end;

    local success, result = pcall(function() -- Line: 24
        return game:GetService("ConfigService"):GetConfigAsync();
    end);

    if not (success and result) then
        return nil;
    end;

    u4 = result;
    result.UpdateAvailable:Connect(function() -- Line: 30
        -- upvalues: result (copy)
        pcall(result.Refresh, result);
    end);

    return u4;
end;

function u3.Get(p5: string) -- Line: 36
    -- upvalues: u2 (copy), ConfigKeys (copy), u1 (copy), getSnapshot (copy), LocalPlayer (copy)
    if u2 and ConfigKeys.Defaults[p5] ~= nil then
        return ConfigKeys.Defaults[p5];
    end;

    if not u1 then
        return LocalPlayer:GetAttribute(p5);
    end;

    local v6 = getSnapshot();

    if not v6 then
        return nil;
    end;

    local success, result = pcall(v6.GetValue, v6, p5);

    if success then
        return result;
    end;

    return nil;
end;

function u3.GetRewardMultiplier(p7: string) -- Line: 50
    -- upvalues: u3 (copy), ConfigKeys (copy)
    local v8 = tonumber(u3.Get(p7)) or (ConfigKeys.Defaults[p7] or 1);

    return math.max(0, v8);
end;

function u3.OnChanged(u9: string, u10: function) -- Line: 54
    -- upvalues: u1 (copy), getSnapshot (copy), LocalPlayer (copy)
    if not u1 then
        return LocalPlayer:GetAttributeChangedSignal(u9):Connect(function() -- Line: 65
            -- upvalues: u10 (copy), LocalPlayer (ref), u9 (copy)
            u10(LocalPlayer:GetAttribute(u9));
        end);
    end;

    local u11 = getSnapshot();

    if not u11 then
        return nil;
    end;

    local success, result = pcall(u11.GetValueChangedSignal, u11, u9);

    if success and result then
        return result:Connect(function() -- Line: 60
            -- upvalues: u11 (copy), u9 (copy), u10 (copy)
            local success2, result2 = pcall(u11.GetValue, u11, u9);

            if not success2 then
                result2 = nil;
            end;

            u10(result2);
        end);
    end;

    return nil;
end;

return u3;