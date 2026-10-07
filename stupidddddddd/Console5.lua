-- ReplicatedStorage.Packages.DebugTools.Server.Builtin.Console
-- Script path: ReplicatedStorage.Packages.DebugTools.Server.Builtin.Console
-- Decompile time: 0.78 ms

local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")
local Module = require(script.Parent.Parent.Module)
local Networking = require(script.Parent.Parent.Networking)
local Console = Module.new("Console")
local u25 = {MessagesHistory = {}}

function u25.sendMessagesHistory(a1) -- Line: 15 -- upvalues: u25 (val), Networking (val) -- types: a1: userdata
    for i, j in u25.MessagesHistory do
        Networking:SendMessageToPlayer(a1, "console_messages", j.MessageType, j.Message, j.Timestamp)
    end
end

function Console.Init(a1) -- Line: 27 -- upvalues: RunService (val), LogService (val), Networking (val), u25 (val)
    if RunService:IsStudio() then
        return
    end
    LogService.MessageOut:Connect(function(a1, a2) -- Line: 34 -- upvalues: Networking (upval), u25 (upval) -- types: a1: string
        local v1 = math.floor((os.clock()) * 1000) / 1000
        Networking:SendMessage("console_messages", a2, a1, v1)
        table.insert(u25.MessagesHistory, {Message = a1, MessageType = a2, Timestamp = v1})
        if #u25.MessagesHistory > 100 then
            table.remove(u25.MessagesHistory, 1)
        end
    end)
    for i, j in Networking:GetNetworkTargets() do
        u25.sendMessagesHistory(j)
    end
    Networking.NetworkTargetAdded:Connect(function(a1) -- Line: 54 -- upvalues: u25 (upval) -- types: a1: userdata
        u25.sendMessagesHistory(a1)
    end)
end

return Console