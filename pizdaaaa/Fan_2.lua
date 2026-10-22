-- Workspace.Map.Modifications.Client.Fan
-- Script path: Workspace.Map.Modifications.Client.Fan
-- Decompile time: 5.15 ms

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

local function Start(p8) -- Line: 27
    -- upvalues: u7 (ref), RunService (copy), u2 (copy), u3 (ref)
    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if p8 then
        return;
    end;

    u7 = RunService.PostSimulation:Connect(function(p9) -- Line: 37
        -- upvalues: u2 (ref), u3 (ref)
        for i, _ in u2 do
            local Pivot = i:GetPivot();

            if u3:VisiblePoint(Pivot.Position, 1) then
                i:PivotTo(Pivot * CFrame.Angles(math.rad(80 * p9), 0, 0));
            end;
        end;
    end);
end;

function v1.Init(p10, p11) -- Line: 50
    -- upvalues: u4 (ref), u3 (ref), CollectionService (copy), u2 (copy), u6 (ref)
    u4 = p11:GetModule("Gui");
    u3 = p11:GetModule("FrustumCuller").Shared();

    for _, v in CollectionService:GetTagged("Mod_Vent") do
        u2[v] = true;
    end;

    u6 = CollectionService:GetInstanceAddedSignal("Mod_Vent"):Connect(function(p12) -- Line: 58
        -- upvalues: u2 (ref)
        u2[p12] = true;
    end);
end;

function v1.Start(p13) -- Line: 63
    -- upvalues: u5 (ref), u4 (ref), GameStats (copy), u7 (ref), RunService (copy), u2 (copy), u3 (ref)
    u5 = u4.GetComponent("Settings");
    u5:AddConnection("Maps", GameStats:GetAttribute("Map"), "Map Settings", function(p14) -- Line: 66
        -- upvalues: u7 (ref), RunService (ref), u2 (ref), u3 (ref)
        for i, v in p14 do
            if i == "Fan Animation" then
                if u7 then
                    u7:Disconnect();
                    u7 = nil;
                end;

                if not v then
                    u7 = RunService.PostSimulation:Connect(function(p15) -- Line: 37
                        -- upvalues: u2 (ref), u3 (ref)
                        for i2, _ in u2 do
                            local Pivot = i2:GetPivot();

                            if u3:VisiblePoint(Pivot.Position, 1) then
                                i2:PivotTo(Pivot * CFrame.Angles(math.rad(80 * p15), 0, 0));
                            end;
                        end;
                    end);
                end;
            end;
        end;
    end);

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    u7 = RunService.PostSimulation:Connect(function(p16) -- Line: 37
        -- upvalues: u2 (ref), u3 (ref)
        for i, _ in u2 do
            local Pivot = i:GetPivot();

            if u3:VisiblePoint(Pivot.Position, 1) then
                i:PivotTo(Pivot * CFrame.Angles(math.rad(80 * p16), 0, 0));
            end;
        end;
    end);
end;

function v1.Destroy(p17) -- Line: 79
    -- upvalues: u6 (ref), u5 (ref), u2 (copy)
    u6:Disconnect();
    u6 = nil;
    u5:DisconnectConnection();
    table.clear(u2);
end;

return v1;