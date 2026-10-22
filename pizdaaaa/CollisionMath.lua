-- ReplicatedStorage.Shared.Utility.CollisionMath
-- Script path: ReplicatedStorage.Shared.Utility.CollisionMath
-- Decompile time: 14.16 ms

-- Decompiled with Potassium's decompiler.

return {
    FindAABB = function(p1, p2: vector) -- Line: 11, Name: FindAABB
        local v3 = p2 * 0.5;
        local Components, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14 = p1:GetComponents();
        local X = v3.X;
        local Y = v3.Y;
        local Z = v3.Z;
        local v15 = math.abs(v6) * X + math.abs(v7) * Y + math.abs(v8) * Z;
        local v16 = math.abs(v9) * X + math.abs(v10) * Y + math.abs(v11) * Z;
        local v17 = math.abs(v12) * X + math.abs(v13) * Y + math.abs(v14) * Z;

        return Components - v15, v4 - v16, v5 - v17, Components + v15, v4 + v16, v5 + v17;
    end,

    SweepPointBox = function(p18, p19, p20, p21, p22, p23, p24, p25, p26) -- Line: 23, Name: SweepPointBox
        local v27 = 0;
        local v28 = 1;
        local v29 = 0;
        local v30 = 0;
        local v31 = 0;
        local v32, v33;

        if p21 > -1e-8 and p21 < 1e-8 then
            if p18 < -p24 or p24 < p18 then
                return 2, 0, 0, 0;
            end;

            v32 = v28;
            v33 = v27;
        else
            local v34 = 1 / p21;
            v32 = (-p24 - p18) * v34;
            v33 = (p24 - p18) * v34;

            if v33 >= v32 then
                local v35 = v32;
                v32 = v33;
                v33 = v35;
            end;

            if v27 < v33 then
                v29 = p21 > 0 and -1 or 1;
                v30 = 0;
                v31 = 0;
            else
                v33 = v27;
            end;

            if v32 >= v28 then
                v32 = v28;
            end;

            if v32 < v33 then
                return 2, 0, 0, 0;
            end;
        end;

        local v36, v37;

        if p22 > -1e-8 and p22 < 1e-8 then
            if p19 < -p25 or p25 < p19 then
                return 2, 0, 0, 0;
            end;

            v36 = v32;
            v37 = v33;
        else
            local v38 = 1 / p22;
            v36 = (-p25 - p19) * v38;
            v37 = (p25 - p19) * v38;

            if v37 >= v36 then
                local v39 = v36;
                v36 = v37;
                v37 = v39;
            end;

            if v33 < v37 then
                v30 = p22 > 0 and -1 or 1;
                v29 = 0;
                v31 = 0;
            else
                v37 = v33;
            end;

            if v36 >= v32 then
                v36 = v32;
            end;

            if v36 < v37 then
                return 2, 0, 0, 0;
            end;
        end;

        local v40;

        if p23 > -1e-8 and p23 < 1e-8 then
            if p20 < -p26 or p26 < p20 then
                return 2, 0, 0, 0;
            end;

            v40 = v37;
        else
            local v41 = 1 / p23;
            local v42 = (-p26 - p20) * v41;
            v40 = (p26 - p20) * v41;

            if v40 >= v42 then
                local v43 = v42;
                v42 = v40;
                v40 = v43;
            end;

            if v37 < v40 then
                v31 = p23 > 0 and -1 or 1;
                v29 = 0;
                v30 = 0;
            else
                v40 = v37;
            end;

            if v42 >= v36 then
                v42 = v36;
            end;

            if v42 < v40 then
                return 2, 0, 0, 0;
            end;
        end;

        return v40, v29, v30, v31;
    end,

    HalfArea = function(p44: vector, p45: vector) -- Line: 66, Name: HalfArea
        local v46 = p45 - p44;

        return v46.X * v46.Y + v46.Y * v46.Z + v46.Z * v46.X;
    end,

    RayHitsBox = function(p47: any, p48: any, p49: any, p50: any, p51: any, p52: any, p53: vector, p54: vector, p55: number) -- Line: 71, Name: RayHitsBox
        local v56 = 0;
        local v57, v58;

        if p50 == 0 then
            if p47 < p53.X or p54.X < p47 then
                return false;
            end;

            v57 = p55;
            v58 = v56;
        else
            local v59 = 1 / p50;
            v57 = (p53.X - p47) * v59;
            v58 = (p54.X - p47) * v59;

            if v58 >= v57 then
                local v60 = v57;
                v57 = v58;
                v58 = v60;
            end;

            if v56 >= v58 then
                v58 = v56;
            end;

            if v57 >= p55 then
                v57 = p55;
            end;

            if v57 < v58 then
                return false;
            end;
        end;

        if p51 == 0 then
            if p48 < p53.Y or p54.Y < p48 then
                return false;
            end;
        else
            local v61 = 1 / p51;
            local v62 = (p53.Y - p48) * v61;
            local v63 = (p54.Y - p48) * v61;

            if v63 >= v62 then
                local v64 = v62;
                v62 = v63;
                v63 = v64;
            end;

            if v58 >= v63 then
                v63 = v58;
            end;

            if v62 >= v57 then
                v62 = v57;
            end;

            if v62 < v63 then
                return false;
            end;

            v57 = v62;
            v58 = v63;
        end;

        if p52 == 0 then
            if p49 < p53.Z or p54.Z < p49 then
                return false;
            end;
        else
            local v65 = 1 / p52;
            local v66 = (p53.Z - p49) * v65;
            local v67 = (p54.Z - p49) * v65;

            if v67 >= v66 then
                local v68 = v66;
                v66 = v67;
                v67 = v68;
            end;

            if v58 >= v67 then
                v67 = v58;
            end;

            if v66 >= v57 then
                v66 = v57;
            end;

            if v66 < v67 then
                return false;
            end;
        end;

        return true;
    end,

    SegmentBox = function(p69, p70, p71, p72, p73, p74, p75, p76, p77) -- Line: 124, Name: SegmentBox
        local v78 = (-1 / 0);
        local v79 = (1 / 0);
        local v80 = 0;
        local v81 = 0;
        local v82 = 0;
        local v83, v84;

        if p72 > -1e-8 and p72 < 1e-8 then
            if p69 < -p75 or p75 < p69 then
                return nil;
            end;

            v83 = v79;
            v84 = v78;
        else
            local v85 = 1 / p72;
            v83 = (-p75 - p69) * v85;
            v84 = (p75 - p69) * v85;

            if v84 >= v83 then
                local v86 = v83;
                v83 = v84;
                v84 = v86;
            end;

            if v78 < v84 then
                v80 = p72 > 0 and -1 or 1;
                v81 = 0;
                v82 = 0;
            else
                v84 = v78;
            end;

            if v83 >= v79 then
                v83 = v79;
            end;

            if v83 < v84 then
                return nil;
            end;
        end;

        local v87, v88;

        if p73 > -1e-8 and p73 < 1e-8 then
            if p70 < -p76 or p76 < p70 then
                return nil;
            end;

            v87 = v83;
            v88 = v84;
        else
            local v89 = 1 / p73;
            v87 = (-p76 - p70) * v89;
            v88 = (p76 - p70) * v89;

            if v88 >= v87 then
                local v90 = v87;
                v87 = v88;
                v88 = v90;
            end;

            if v84 < v88 then
                v81 = p73 > 0 and -1 or 1;
                v80 = 0;
                v82 = 0;
            else
                v88 = v84;
            end;

            if v87 >= v83 then
                v87 = v83;
            end;

            if v87 < v88 then
                return nil;
            end;
        end;

        local v91, v92;

        if p74 > -1e-8 and p74 < 1e-8 then
            if p71 < -p77 or p77 < p71 then
                return nil;
            end;

            v91 = v88;
            v92 = v87;
        else
            local v93 = 1 / p74;
            v92 = (-p77 - p71) * v93;
            v91 = (p77 - p71) * v93;

            if v91 >= v92 then
                local v94 = v92;
                v92 = v91;
                v91 = v94;
            end;

            if v88 < v91 then
                v82 = p74 > 0 and -1 or 1;
                v80 = 0;
                v81 = 0;
            else
                v91 = v88;
            end;

            if v92 >= v87 then
                v92 = v87;
            end;

            if v92 < v91 then
                return nil;
            end;
        end;

        if v92 < 0 or v91 > 1 then
            return nil;
        end;

        return v91, v92, v80, v81, v82;
    end
};