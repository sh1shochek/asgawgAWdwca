-- ReplicatedStorage.Shared.MedalClipper
-- Script path: ReplicatedStorage.Shared.MedalClipper
-- Decompile time: 0.72 ms

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Base64 = require(script.Parent:WaitForChild("Base64"))
local v1 = {}
local u21 = RunService:IsStudio()

local function debugPrint(...) -- Line: 23 -- upvalues: u21 (val)
    if u21 then
        print("[MedalClipper]", ...)
    end
end

function v1.TriggerClip(a1, a2, a3, a4) -- Line: 29
    -- upvalues: debugPrint (val), Base64 (val), HttpService (val)
    local v1 = a4 or {}
    debugPrint(
        "TriggerClip",
        ("eventId=%*"):format(a2),
        ("eventName=%*"):format(a3),
        ("duration=%*"):format(v1.duration or 30),
        (("captureDelayMs=%*"):format(v1.captureDelayMs or 0))
    )
    local v2 = {
        eventId = a2,
        eventName = a3,
        triggerActions = {"SaveClip"},
        clipOptions = {duration = v1.duration or 30, captureDelayMs = v1.captureDelayMs},
    }
    if v1.contextTags and next(v1.contextTags) then
        v2.contextTags = v1.contextTags
    end
    local v3 = {gameEvent = v2, universeId = game.GameId}
    print("[_MAPIEvent][v1/event/invoke]", Base64.ToBase64(HttpService:JSONEncode(v3)))
end

return v1