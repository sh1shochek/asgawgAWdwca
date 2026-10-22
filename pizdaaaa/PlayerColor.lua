-- ReplicatedStorage.Shared.PlayerColor
-- Script path: ReplicatedStorage.Shared.PlayerColor
-- Decompile time: 10.58 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local GameStats = game:GetService("ReplicatedStorage"):WaitForChild("GameStats");
local u2 = {
    CT = Color3.fromRGB(184, 214, 239),
    T = Color3.fromRGB(234, 210, 139),
    Spectator = Color3.fromRGB(255, 255, 255)
};

function u1.IsCompetitive() -- Line: 19
    -- upvalues: GameStats (copy)
    return GameStats:GetAttribute("Gamemode") == "Competitive";
end;

function u1.GetTeamColor(p3: string?) -- Line: 23
    -- upvalues: u2 (copy)
    return p3 and u2[p3] or u2.Spectator;
end;

function u1.GetColor(p4: any, p5: string?, p6) -- Line: 27
    -- upvalues: Players (copy), u1 (copy)
    local v7 = nil;

    if typeof(p4) == "Instance" and p4:IsA("Player") then
        if p5 then
            v7 = p4;
        else
            p5 = p4:GetAttribute("Team");
            v7 = p4;
        end;
    elseif typeof(p4) == "table" then
        if p4.UserId then
            v7 = Players:GetPlayerByUserId(p4.UserId);
        end;

        if not p5 and (p4.Data and p4.Data.Team) then
            p5 = p4.Data.Team;
        end;
    elseif typeof(p4) == "number" then
        v7 = Players:GetPlayerByUserId(p4);
    elseif typeof(p4) == "string" then
        v7 = Players:FindFirstChild(p4);
    end;

    return u1.IsCompetitive() and (v7 and v7:GetAttribute("Color")) or (p6 or u1.GetTeamColor(p5));
end;

function u1.GetColorRGB(p8: any, p9: string?, p10) -- Line: 63
    -- upvalues: u1 (copy)
    local Color = u1.GetColor(p8, p9, p10);

    return string.format("rgb(%d,%d,%d)", math.round(Color.R * 255), math.round(Color.G * 255), (math.round(Color.B * 255)));
end;

function u1.Init(p11) -- Line: 68
end;

return u1;