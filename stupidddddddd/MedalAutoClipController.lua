-- ReplicatedStorage.Controllers.MedalAutoClipController
-- Script path: ReplicatedStorage.Controllers.MedalAutoClipController
-- Decompile time: 0.73 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MedalClipper = require((ReplicatedStorage:WaitForChild("Shared")):WaitForChild("MedalClipper"))
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local u28 = RunService:IsStudio()

local function triggerMedalClip(a1) -- Line: 25 -- upvalues: u28 (val), MedalClipper (val) -- types: a1: table
    if u28 then
        print(
            "[MedalAutoClipController]",
            "Received clip request",
            ("eventId=%*"):format(a1.EventId),
            ("eventName=%*"):format(a1.EventName),
            ("duration=%*"):format(a1.Duration),
            (("captureDelayMs=%*"):format(a1.CaptureDelayMs or 0))
        )
    end
    local success, result = pcall(MedalClipper.TriggerClip, MedalClipper, a1.EventId, a1.EventName, {
        duration = a1.Duration,
        captureDelayMs = a1.CaptureDelayMs,
        contextTags = a1.ContextTags,
    })
    if not success then
        warn((("[MedalAutoClipController] Failed to trigger Medal clip: %*"):format(result)))
        return
    end
    if u28 then
        print("[MedalAutoClipController]", "Medal TriggerClip completed", a1.EventName)
    end
end

function v1.Initialize() -- Line: 50 -- upvalues: Remotes (val), triggerMedalClip (val)
    Remotes.Collaborations.MedalAutoClip.Listen(triggerMedalClip)
end

return v1