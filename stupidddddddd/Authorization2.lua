-- ReplicatedStorage.Packages.DebugTools.Server.Authorization
-- Script path: ReplicatedStorage.Packages.DebugTools.Server.Authorization
-- Decompile time: 0.91 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Shared = script.Parent.Parent.Shared
local Signal = require(Shared.Signal)
local Constants = require(Shared.Constants)
local u20 = {internal = {Players = {}}}
u20.interface = {PlayerAuthorized = Signal.new()}

function u20.internal.playerAdded(a1) -- Line: 24
    -- upvalues: u20 (val), RunService (val), Constants (val)
    u20.internal.Players[a1] = {Authorized = false, Authorizing = true}
    local v1 = RunService:IsStudio() or Constants.GROUP_RANK <= (a1:GetRankInGroup(Constants.GROUP_ID))
    if not u20.internal.Players[a1] then
        return
    end
    u20.internal.Players[a1].Authorized = v1
    local v2 = u20.internal.Players[a1]
    v2.Authorizing = false
    if not v1 then
        return
    end
    u20.interface.PlayerAuthorized:Fire(a1)
end

function u20.internal.playerRemoved(a1) -- Line: 48 -- upvalues: u20 (val) -- types: a1: userdata
    if not u20.internal.Players[a1] then
        return
    end
    u20.internal.Players[a1] = nil
end

function u20.internal.listenToPlayers() -- Line: 56 -- upvalues: Players (val), u20 (val)
    Players.PlayerAdded:Connect(function(a1) -- Line: 57 -- upvalues: u20 (upval) -- types: a1: userdata
        u20.internal.playerAdded(a1)
    end)
    for i, j in Players:GetPlayers() do
        u20.internal.playerAdded(j)
    end
    Players.PlayerRemoving:Connect(function(a1) -- Line: 65 -- upvalues: u20 (upval) -- types: a1: userdata
        u20.internal.playerRemoved(a1)
    end)
end

function u20.interface.isPlayerAuthorized(a1) -- Line: 70
    -- upvalues: RunService (val), u20 (val)
    if RunService:IsStudio() then
        return true
    end
    local v1 = u20.internal.Players[a1]
    if not v1 then
        return false
    end
    while u20.internal.Players[a1] do
        if not v1.Authorizing then
            break
        end
        task.wait()
    end
    return u20.internal.Players[a1] and v1.Authorized
end

u20.internal.listenToPlayers()
return u20.interface