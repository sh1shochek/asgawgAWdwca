-- ReplicatedStorage.Assets.Maps.de_seaside.Modifications.Client.Water
-- Script path: ReplicatedStorage.Assets.Maps.de_seaside.Modifications.Client.Water
-- Decompile time: 10.36 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local MaterialService = game:GetService("MaterialService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
MaterialService:WaitForChild("Materials").Water:GetChildren();
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = nil;
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;

local function IsSelected(p12, p13) -- Line: 31
    local v14;

    if type(p12) == "table" then
        v14 = p12[p13] == true and true or table.find(p12, p13) ~= nil;
    else
        v14 = false;
    end;

    return v14;
end;

local function WaterRun(p15: boolean) -- Line: 35
    -- upvalues: u5 (ref), u2 (copy), u6 (ref), u3 (copy)
    if p15 then
        if u5 then
            return;
        end;

        u5 = task.spawn(function() -- Line: 41
            -- upvalues: u2 (ref)
            local v16 = 10;
            local v17 = 1;

            for i, _ in u2 do
                i.Material = Enum.Material.Limestone;
            end;

            while true do
                local v18 = "WaterFrame" .. v16;

                for i, _ in u2 do
                    if i.Parent then
                        i.MaterialVariant = v18;
                    end;
                end;

                v16 = v16 + v17;

                if v16 >= 40 then
                    v17 = -v17;
                elseif v16 <= 10 then
                    v17 = -v17;
                end;

                task.wait(0.06);
            end;
        end);
        u6 = task.spawn(function() -- Line: 69
            -- upvalues: u3 (ref)
            while true do
                local v19, v20, v21, v22;
                local v23 = 0;

                while true do
                    if v23 == 0 then
                        v23 = -1;
                        local v24 = tick();
                        local math_sin_ret = math.sin(v24);
                        v19 = math.clamp(math_sin_ret, 0.9, 0.99);
                        v20, v21, v22 = u3, nil, nil;
                        v23 = 1;
                        continue;
                    elseif v23 == 1 then
                        v23 = -1;
                        local v25, v26;

                        if type(v20) == "function" then
                            v25, v26 = v20(v21, v22);
                        else
                            v25, v26 = next(v20, v22);
                        end;

                        if v25 ~= nil then
                            v22 = v25;

                            if not v25.Parent then
                                v23 = 1;
                                continue;
                            end;

                            local v27;

                            if v26 ~= true then
                                v27 = v26;
                                v27.OffsetStudsU = v27.OffsetStudsU + 0.05;
                                v27.OffsetStudsV = v27.OffsetStudsV + 0.05;
                                v27.Transparency = v19;
                                v23 = 1;
                                continue;
                            end;

                            v27 = v25:FindFirstChild("Texture");

                            if v27 then
                                u3[v25] = v27;
                                goto l0;
                            end;

                            task.wait(0.05);
                            break;
                        else
                            break;
                        end;
                    else
                        break;
                    end;
                end;
            end;
        end);

        return;
    end;

    if u5 then
        task.cancel(u5);
    end;

    if u6 then
        task.cancel(u6);
    end;

    u5 = nil;
    u6 = nil;
end;

function v1.Init(p28, p29) -- Line: 103
    -- upvalues: u8 (ref), u7 (ref), CollectionService (copy), u2 (copy), u3 (copy), u4 (copy), u5 (ref)
    u8 = p29:GetModule("Gui");
    u7 = p29:GetModule("FrustumCuller").Shared();

    for _, v in CollectionService:GetTagged("Water") do
        u2[v] = true;
    end;

    for _, v in CollectionService:GetTagged("WaterSand") do
        u3[v] = true;
    end;

    local InstanceAddedSignal = CollectionService:GetInstanceAddedSignal("WaterSand");
    table.insert(u4, InstanceAddedSignal:Connect(function(p30) -- Line: 115
        -- upvalues: u3 (ref)
        u3[p30] = true;
    end));
    local InstanceRemovedSignal = CollectionService:GetInstanceRemovedSignal("WaterSand");
    table.insert(u4, InstanceRemovedSignal:Connect(function(p31) -- Line: 118
        -- upvalues: u3 (ref)
        u3[p31] = nil;
    end));
    local InstanceAddedSignal2 = CollectionService:GetInstanceAddedSignal("Water");
    table.insert(u4, InstanceAddedSignal2:Connect(function(p32) -- Line: 122
        -- upvalues: u2 (ref), u5 (ref)
        u2[p32] = true;

        if u5 then
            p32.Material = Enum.Material.Limestone;
        end;
    end));
    local InstanceRemovedSignal2 = CollectionService:GetInstanceRemovedSignal("Water");
    table.insert(u4, InstanceRemovedSignal2:Connect(function(p33) -- Line: 128
        -- upvalues: u2 (ref)
        u2[p33] = nil;
    end));
end;

function v1.Start(p34) -- Line: 134
    -- upvalues: u9 (ref), u8 (ref), u10 (ref), GameStats (copy), WaterRun (copy), u11 (ref)
    u9 = u8.GetComponent("Settings");
    u10 = GameStats:GetAttribute("Map");
    local Maps = u9:GetPlayerSettings().Maps;

    if Maps then
        Maps = Maps[u10];
    end;

    if Maps then
        Maps = Maps["Map Settings"];
    end;

    local v35;

    if type(Maps) == "table" then
        v35 = Maps["Remove Water Animation"] == true and true or table.find(Maps, "Remove Water Animation") ~= nil;
    else
        v35 = false;
    end;

    WaterRun(not v35);

    u11 = function(p36) -- Line: 143
        -- upvalues: WaterRun (ref)
        local v37;

        if type(p36) == "table" then
            v37 = p36["Remove Water Animation"] == true and true or table.find(p36, "Remove Water Animation") ~= nil;
        else
            v37 = false;
        end;

        WaterRun(not v37);
    end;

    u9:AddConnection("Maps", u10, "Map Settings", u11);
end;

function v1.Destroy(p38) -- Line: 149
    -- upvalues: u5 (ref), u6 (ref), u11 (ref), u9 (ref), u10 (ref), u2 (copy), u3 (copy), u4 (copy)
    if u5 then
        task.cancel(u5);
    end;

    if u6 then
        task.cancel(u6);
    end;

    u5 = nil;
    u6 = nil;

    if u11 then
        u9:DisconnectConnection("Maps", u10, "Map Settings", u11);
        u11 = nil;
    end;

    table.clear(u2);
    table.clear(u3);

    for _, v in u4 do
        v:Disconnect();
    end;

    table.clear(u4);
end;

return v1;