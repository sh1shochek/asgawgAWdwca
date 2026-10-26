-- ReplicatedStorage.Components.Common.IsRadarHidden
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);

return function() -- Line: 9
    -- upvalues: IsTutorialMode (copy), IsSurvivalMode (copy)
    return IsTutorialMode() or IsSurvivalMode();
end;