-- StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.FlagUtil
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.FlagUtil
-- Decompile time: 0.24 ms

return {
    getUserFlag = function(a1) -- Line: 11
        local success, result = pcall(function() -- Line: 12 -- upvalues: a1 (val)
            return (UserSettings()):IsUserFeatureEnabled(a1)
        end)
        return success and result
    end,
}