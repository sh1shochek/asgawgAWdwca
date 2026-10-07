-- Players.Caelclaw404.PlayerScripts.PlayerModule.CommonUtils.FlagUtil
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CommonUtils.FlagUtil
-- Decompile time: 0.23 ms

return {
    getUserFlag = function(a1) -- Line: 11
        local success, result = pcall(function() -- Line: 12 -- upvalues: a1 (val)
            return (UserSettings()):IsUserFeatureEnabled(a1)
        end)
        return success and result
    end,
}