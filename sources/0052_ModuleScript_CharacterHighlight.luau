-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);

local function applyFill(p2: any, p3: number) -- Line: 26
    local v4;

    if p2.OutlineOnly then
        v4 = p2.Properties.OutlineColor:Lerp(Color3.new(1, 1, 1), 0.2);
        p3 = 0.9;
    else
        v4 = p2.Properties.FillColor;
    end;

    if p2.AppliedFillColor ~= v4 then
        p2.Highlight.FillColor = v4;
        p2.AppliedFillColor = v4;
    end;

    if p2.AppliedFillTransparency ~= p3 then
        p2.Highlight.FillTransparency = p3;
        p2.AppliedFillTransparency = p3;
    end;
end;

function u1.UpdateState(p5: any, p6: boolean) -- Line: 45
    -- upvalues: applyFill (copy)
    if not (p5.Highlight and p5.Highlight.Parent) then
        return;
    end;

    if p5.IsEnabled ~= p6 then
        if p6 then
            applyFill(p5, p5.CurrentTransparency:getPosition());
        end;

        p5.Highlight.Enabled = p6;
        p5.IsEnabled = p6;
    end;
end;

function u1.new(u7: userdata, p8: any) -- Line: 62
    -- upvalues: u1 (copy), Janitor (copy), Spring (copy), CharacterResolver (copy), RunServiceController (copy), applyFill (copy)
    local u9 = setmetatable({}, u1);
    u9.Janitor = Janitor.new();
    u9.CurrentTransparency = Spring.new(0.95, 1.5, 0.6);
    u9.Properties = p8;
    u9.Character = u7;
    local v10 = u9.Janitor:Add(Instance.new("Highlight", u7));
    v10.Enabled = false;
    v10.OutlineTransparency = p8.OutlineTransparency;
    v10.FillTransparency = p8.FillTransparency;
    v10.OutlineColor = p8.OutlineColor;
    v10.DepthMode = p8.DepthMode;
    v10.FillColor = p8.FillColor;
    u9.Highlight = v10;
    u9.IsEnabled = false;
    u9.OutlineOnly = false;

    if CharacterResolver.isAliveCharacter(u7) then
        u9.Janitor:Add(u7:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 91
            -- upvalues: u7 (copy), u9 (copy)
            if u7:GetAttribute("Dead") then
                u9:Destroy();
            end;
        end));
    end;

    local v11 = RunServiceController.CreateBindingName("Classes.CharacterHighlight.Pulse");
    u9.Janitor:Add(RunServiceController.BindToHeartbeat(v11, function(p12: number) -- Line: 100
        -- upvalues: u9 (copy), applyFill (ref)
        if not (u9.IsEnabled and (u9.Highlight and u9.Highlight.Parent)) then
            return;
        end;

        local Position = u9.CurrentTransparency:getPosition();
        u9.CurrentTransparency:update(p12);

        if Position >= 0.8 then
            u9.CurrentTransparency:setGoal(0.6);
        elseif Position <= 0.6 then
            u9.CurrentTransparency:setGoal(0.8);
        end;

        applyFill(u9, Position);
    end));

    return u9;
end;

function u1.Destroy(p13) -- Line: 125
    p13.Janitor:Destroy();
end;

return u1;