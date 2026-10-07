-- ReplicatedStorage.Controllers.PlayerController
-- Script path: ReplicatedStorage.Controllers.PlayerController
-- Decompile time: 1.25 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local u12 = tick()
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)

local function ReportPlayerState() -- Line: 24 -- upvalues: Remotes (val), u12 (ref)
    debug.profilebegin("PlayerController.HandleNextFrame")
    local v1 = tick()
    Remotes.Player.BlankRequest.Send(v1)
    if 900 <= v1 - u12 then
        Remotes.Player.AFKTeleport.Send()
        u12 = v1
    end
    debug.profileend()
end

function v1.Initialize() -- Line: 38 -- upvalues: UserInputService (val), u12 (ref), Remotes (val)
    UserInputService.InputBegan:Connect(function() -- Line: 39 -- upvalues: u12 (upval)
        u12 = tick()
    end)
    UserInputService.InputChanged:Connect(function() -- Line: 43 -- upvalues: u12 (upval)
        u12 = tick()
    end)
    Remotes.Player.BlankRequest.Listen(function(a1) -- Line: 48 -- upvalues: Remotes (upval) -- types: a1: number
        Remotes.Player.ReportPlayerConnect.Send((tostring((math.floor(((tick()) - a1) * 1000)))))
    end)
end

function v1.Start() -- Line: 53 -- upvalues: GetUserPlatform (val), Remotes (val), ReportPlayerState (val)
    task.delay(5, function() -- Line: 55 -- upvalues: GetUserPlatform (upval), Remotes (upval)
        local v1 = GetUserPlatform()
        if v1 and #v1 > 0 then
            Remotes.Player.SubmitUserPlatformAnalytics.Send(v1[1])
        end
    end)
    task.spawn(function() -- Line: 61 -- upvalues: ReportPlayerState (upval)
        while true do
            task.wait(5)
            ReportPlayerState()
        end
    end)
end

return v1