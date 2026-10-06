-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local LogService = game:GetService("LogService");
local Module = require(script.Parent.Parent.Module);
local Networking = require(script.Parent.Parent.Networking);
local Console = Module.new("Console");
local u1 = {
    MessagesHistory = {}
};

function u1.sendMessagesHistory(p2: userdata) -- Line: 15
    -- upvalues: u1 (copy), Networking (copy)
    for _, v in u1.MessagesHistory do
        Networking:SendMessageToPlayer(p2, "console_messages", v.MessageType, v.Message, v.Timestamp);
    end;
end;

function Console.Init(p3) -- Line: 27
    -- upvalues: RunService (copy), LogService (copy), Networking (copy), u1 (copy)
    if RunService:IsStudio() then
        return;
    end;

    LogService.MessageOut:Connect(function(p4: string, p5: any) -- Line: 34
        -- upvalues: Networking (ref), u1 (ref)
        local v6 = os.clock() * 1000;
        local v7 = math.floor(v6) / 1000;
        Networking:SendMessage("console_messages", p5, p4, v7);
        table.insert(u1.MessagesHistory, {
            Message = p4,
            MessageType = p5,
            Timestamp = v7
        });

        if #u1.MessagesHistory > 100 then
            table.remove(u1.MessagesHistory, 1);
        end;
    end);

    for _, v in Networking:GetNetworkTargets() do
        u1.sendMessagesHistory(v);
    end;

    Networking.NetworkTargetAdded:Connect(function(p8: userdata) -- Line: 54
        -- upvalues: u1 (ref)
        u1.sendMessagesHistory(p8);
    end);
end;

return Console;