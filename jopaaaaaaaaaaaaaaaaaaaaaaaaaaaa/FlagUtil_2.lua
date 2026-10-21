-- StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.FlagUtil
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.FlagUtil
-- Decompile time: 3.30 ms

-- Decompiled with Potassium's decompiler.

return {
    getUserFlag = function(u1) -- Line: 11, Name: getUserFlag
        local success, result = pcall(function() -- Line: 12
            -- upvalues: u1 (copy)
            return UserSettings():IsUserFeatureEnabled(u1);
        end);

        return success and result;
    end
};