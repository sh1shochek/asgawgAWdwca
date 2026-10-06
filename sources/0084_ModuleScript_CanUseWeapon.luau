-- Decompiled with Potassium's decompiler.

return function(p1: userdata?) -- Line: 3
    local v2;

    if p1 == nil or (p1:GetAttribute("IsPlantingBomb") == true or p1:GetAttribute("IsDefusingBomb") == true) then
        v2 = false;
    else
        v2 = p1:GetAttribute("IsRescuingHostage") ~= true;
    end;

    return v2;
end;