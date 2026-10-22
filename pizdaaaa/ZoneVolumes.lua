-- ReplicatedStorage.Shared.ZoneVolumes
-- Script path: ReplicatedStorage.Shared.ZoneVolumes
-- Decompile time: 4.35 ms

-- Decompiled with Potassium's decompiler.

return {
    Collect = function(p1: userdata?) -- Line: 20, Name: Collect
        local v2 = {};

        if not p1 then
            return v2;
        end;

        for i, child in ipairs(p1:GetChildren()) do
            v2[i] = {
                Name = child.Name,
                CFrame = child.CFrame,
                Half = child.Size * 0.5
            };
        end;

        return v2;
    end,

    At = function(p3: any, p4: vector) -- Line: 40, Name: At
        for _, v in p3 do
            local v5 = v.CFrame:PointToObjectSpace(p4);
            local Half = v.Half;

            if math.abs(v5.X) <= Half.X and (math.abs(v5.Y) <= Half.Y and math.abs(v5.Z) <= Half.Z) then
                return v.Name;
            end;
        end;

        return nil;
    end
};