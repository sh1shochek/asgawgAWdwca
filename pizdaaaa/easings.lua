-- ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.easings
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.easings
-- Decompile time: 3.38 ms

-- Decompiled with Potassium's decompiler.

return {
    linear = function(p1: number) -- Line: 2, Name: linear
        return p1;
    end,

    constant = function(p2: number) -- Line: 120, Name: constant
        return 0;
    end,

    cubic_in = function(p3: number) -- Line: 6, Name: cubic_in
        return p3 ^ 3;
    end,

    cubic_out = function(p4: number) -- Line: 10, Name: cubic_out
        return 1 - (1 - p4) ^ 3;
    end,

    cubic_in_out = function(p5: number) -- Line: 14, Name: cubic_in_out
        if p5 < 0.5 then
            return p5 ^ 3 * 4;
        end;

        return 1 - (p5 * -2 + 2) ^ 3 * 0.5;
    end,

    bounce_in = function(p6: number) -- Line: 22, Name: bounce_in
        local v7 = 1 - p6;

        if v7 < 0.36363636363636365 then
            return 1 - v7 * 7.5625 * v7;
        end;

        if v7 < 0.7272727272727273 then
            local v8 = v7 - 0.5454545454545454;

            return 1 - v8 * 7.5625 * v8 + 0.75;
        end;

        if v7 < 0.9090909090909091 then
            local v9 = v7 - 0.9090909090909091;

            return 1 - v9 * 7.5625 * v9 + 0.9375;
        end;

        local v10 = v7 - 0.9545454545454546;

        return 1 - v10 * 7.5625 * v10 + 0.984375;
    end,

    bounce_out = function(p11: number) -- Line: 43, Name: bounce_out
        if p11 < 0.36363636363636365 then
            return p11 * 7.5625 * p11;
        end;

        if p11 < 0.7272727272727273 then
            local v12 = p11 - 0.5454545454545454;

            return v12 * 7.5625 * v12 + 0.75;
        end;

        if p11 < 0.9090909090909091 then
            local v13 = p11 - 0.9090909090909091;

            return v13 * 7.5625 * v13 + 0.9375;
        end;

        local v14 = p11 - 0.9545454545454546;

        return v14 * 7.5625 * v14 + 0.984375;
    end,

    bounce_in_out = function(p15: number) -- Line: 62, Name: bounce_in_out
        if p15 < 0.5 then
            local v16 = 1 - p15 * 2;

            if v16 < 0.36363636363636365 then
                return (1 - v16 * 7.5625 * v16) * 0.5;
            end;

            if v16 < 0.7272727272727273 then
                local v17 = v16 - 0.5454545454545454;

                return (1 - v17 * 7.5625 * v17 + 0.75) * 0.5;
            end;

            if v16 < 0.9090909090909091 then
                local v18 = v16 - 0.9090909090909091;

                return (1 - v18 * 7.5625 * v18 + 0.9375) * 0.5;
            end;

            local v19 = v16 - 0.9545454545454546;

            return (1 - v19 * 7.5625 * v19 + 0.984375) * 0.5;
        end;

        local v20 = p15 * 2 - 1;

        if v20 < 0.36363636363636365 then
            return (v20 * 7.5625 * v20 + 1) * 0.5;
        end;

        if v20 < 0.7272727272727273 then
            local v21 = v20 - 0.5454545454545454;

            return (v21 * 7.5625 * v21 + 1 + 0.75) * 0.5;
        end;

        if v20 < 0.9090909090909091 then
            local v22 = v20 - 0.9090909090909091;

            return (v22 * 7.5625 * v22 + 1 + 0.9375) * 0.5;
        end;

        local v23 = v20 - 0.9545454545454546;

        return (v23 * 7.5625 * v23 + 1 + 0.984375) * 0.5;
    end,

    elastic_in = function(p24: number) -- Line: 104, Name: elastic_in
        return -2 ^ (p24 * 10 - 10) * math.sin((p24 * 10 - 10.75) * 2.0943951023931953);
    end,

    elastic_out = function(p25: number) -- Line: 108, Name: elastic_out
        return 2 ^ (p25 * -10) * math.sin((p25 * 10 - 0.75) * 2.0943951023931953) + 1;
    end,

    elastic_in_out = function(p26: number) -- Line: 112, Name: elastic_in_out
        if p26 < 0.5 then
            return -2 ^ (p26 * 20 - 10) * math.sin((p26 * 20 - 11.125) * 1.3962634015954636) * 0.5;
        end;

        return p26 * 9.5367431640625e-7 + math.sin(p26 * 20 - 15.533430342749533) * 10 * 0.5 + 1;
    end
};