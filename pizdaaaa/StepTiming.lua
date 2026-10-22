-- ReplicatedStorage.Shared.StepTiming
-- Script path: ReplicatedStorage.Shared.StepTiming
-- Decompile time: 5.29 ms

-- Decompiled with Potassium's decompiler.

local v1 = {
    FLAG_RIGHT_FOOT = 1,
    FLAG_LANDING = 2,
    FLAG_LADDER = 4
};

local function SetStepSoundTime(p2: any, p3: boolean, p4: boolean, p5: boolean) -- Line: 59
    local v6 = p3 and 190 or (p4 and 390 or 290);

    if p5 or p3 then
        v6 = v6 + 100;
    end;

    p2.Time = v6 / 1000 * 0.97;
end;

function v1.Update(p7: any, p8: vector, p9: vector, p10: boolean, p11: boolean, p12: boolean, p13: boolean, p14: number, p15: function) -- Line: 81
    local vector_magnitude_ret = vector.magnitude(p9);
    local WasGround = p7.WasGround;
    p7.WasGround = p10;

    if not (p10 or p12) then
        p7.FallSpeed = math.max(p7.FallSpeed or 0, -p9.Y);
    end;

    if p10 and WasGround == false then
        local v16 = p7.FallSpeed or 0;
        p7.FallSpeed = 0;
        p7.Time = 0.4;

        if v16 > 18.044 then
            p15(p8, false, true, 1);

            if v16 >= 24.290000000000003 then
                p7.Right = not p7.Right;
                p15(p8, p7.Right, false, v16 > 40.252 and 1 or 0.85);
            end;
        end;

        return;
    end;

    if WasGround and (not p10 and p9.Y > 0) then
        local vector_create_ret = vector.create(p9.X, 0, p9.Z);

        if vector.magnitude(vector_create_ret) > 9.716000000000001 then
            p7.Right = not p7.Right;
            p15(p8, p7.Right, false, 1);
        end;
    end;

    if p12 then
        p7.Time = nil;

        if p11 or p13 then
            p7.LadderTime = 0.2813;

            return;
        end;

        if vector_magnitude_ret < 0.6940000000000001 then
            p7.LadderTime = math.max(0, (p7.LadderTime or 0) - p14);

            return;
        end;

        local v17 = (p7.LadderTime or 0) - p14;

        if v17 > 0 then
            p7.LadderTime = v17;

            return;
        end;

        p7.LadderTime = 0.2813;
        p7.Right = not p7.Right;
        p15(p8, p7.Right, false, 1, true);

        return;
    end;

    p7.LadderTime = nil;

    if p7.Time == nil then
        local v18 = 290;

        if p11 then
            v18 = v18 + 100;
        end;

        p7.Time = v18 / 1000 * 0.97;
    end;

    if vector_magnitude_ret < 9.382880000000002 then
        if vector_magnitude_ret < 0.6940000000000001 then
            local v19 = 290;

            if p11 then
                v19 = v19 + 100;
            end;

            p7.Time = v19 / 1000 * 0.97;
        end;

        return;
    end;

    local v20 = (p7.Time or 0) - p14;

    if v20 > 0 then
        p7.Time = v20;

        return;
    end;

    p7.Time = 0;

    if not p10 then
        return;
    end;

    if vector_magnitude_ret < (p11 and 4.164000000000001 or 6.246) then
        return;
    end;

    local v21 = vector_magnitude_ret < (p11 and 5.5520000000000005 or 15.268) and 390 or 290;

    if p11 then
        v21 = v21 + 100;
    end;

    p7.Time = v21 / 1000 * 0.97;
    p7.Right = not p7.Right;
    p15(p8, p7.Right, false, 1, false);
end;

return v1;