-- ReplicatedStorage.Assets.Maps.de_vertigo.Modifications.Client.Fan
-- Script path: ReplicatedStorage.Assets.Maps.de_vertigo.Modifications.Client.Fan
-- Decompile time: 7.87 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local u2 = {};
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;

local function IsSelected(p10, p11) -- Line: 30
    local v12;

    if type(p10) == "table" then
        v12 = p10[p11] == true and true or table.find(p10, p11) ~= nil;
    else
        v12 = false;
    end;

    return v12;
end;

local function Start(p13) -- Line: 36
    -- upvalues: u9 (ref), RunService (copy), u2 (copy), u3 (ref)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if p13 then
        return;
    end;

    u9 = RunService.PostSimulation:Connect(function(p14) -- Line: 46
        -- upvalues: u2 (ref), u3 (ref)
        for i, _ in u2 do
            local Pivot = i:GetPivot();

            if u3:VisiblePoint(Pivot.Position, 1) then
                i:PivotTo(Pivot * CFrame.Angles(math.rad(80 * p14), 0, 0));
            end;
        end;
    end);
end;

function v1.Init(p15, p16) -- Line: 59
    -- upvalues: u4 (ref), u3 (ref), CollectionService (copy), u2 (copy), u8 (ref)
    u4 = p16:GetModule("Gui");
    u3 = p16:GetModule("FrustumCuller").Shared();

    for _, v in CollectionService:GetTagged("Mod_Vent") do
        u2[v] = true;
    end;

    u8 = CollectionService:GetInstanceAddedSignal("Mod_Vent"):Connect(function(p17) -- Line: 67
        -- upvalues: u2 (ref)
        u2[p17] = true;
    end);
end;

function v1.Start(p18) -- Line: 72
    -- upvalues: u5 (ref), u4 (ref), u6 (ref), GameStats (copy), u9 (ref), RunService (copy), u2 (copy), u3 (ref), u7 (ref)
    u5 = u4.GetComponent("Settings");
    u6 = GameStats:GetAttribute("Map");
    local Maps = u5:GetPlayerSettings().Maps;

    if Maps then
        Maps = Maps[u6];
    end;

    if Maps then
        Maps = Maps["Map Settings"];
    end;

    local v19;

    if type(Maps) == "table" then
        v19 = Maps["Remove Fan Animation"] == true and true or table.find(Maps, "Remove Fan Animation") ~= nil;
    else
        v19 = false;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if not v19 then
        u9 = RunService.PostSimulation:Connect(function(p20) -- Line: 46
            -- upvalues: u2 (ref), u3 (ref)
            for i, _ in u2 do
                local Pivot = i:GetPivot();

                if u3:VisiblePoint(Pivot.Position, 1) then
                    i:PivotTo(Pivot * CFrame.Angles(math.rad(80 * p20), 0, 0));
                end;
            end;
        end);
    end;

    u7 = function(p21) -- Line: 81
        -- upvalues: u9 (ref), RunService (ref), u2 (ref), u3 (ref)
        local v22;

        if type(p21) == "table" then
            v22 = p21["Remove Fan Animation"] == true and true or table.find(p21, "Remove Fan Animation") ~= nil;
        else
            v22 = false;
        end;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        if v22 then
            return;
        end;

        u9 = RunService.PostSimulation:Connect(function(p23) -- Line: 46
            -- upvalues: u2 (ref), u3 (ref)
            for i, _ in u2 do
                local Pivot = i:GetPivot();

                if u3:VisiblePoint(Pivot.Position, 1) then
                    i:PivotTo(Pivot * CFrame.Angles(math.rad(80 * p23), 0, 0));
                end;
            end;
        end);
    end;

    u5:AddConnection("Maps", u6, "Map Settings", u7);
end;

function v1.Destroy(p24) -- Line: 89
    -- upvalues: u9 (ref), u8 (ref), u7 (ref), u5 (ref), u6 (ref), u2 (copy)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u8:Disconnect();
    u8 = nil;

    if u7 then
        u5:DisconnectConnection("Maps", u6, "Map Settings", u7);
        u7 = nil;
    end;

    table.clear(u2);
end;

return v1;