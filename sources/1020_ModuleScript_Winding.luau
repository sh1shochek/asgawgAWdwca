-- Decompiled with Potassium's decompiler.

local u99 = {
    count = function(p1) -- Line: 9, Name: count
        return #p1 // 3;
    end,

    baseForPlane = function(p2, p3, p4, p5) -- Line: 13, Name: baseForPlane
        local math_abs_ret = math.abs(p2);
        local math_abs_ret2 = math.abs(p3);
        local math_abs_ret3 = math.abs(p4);
        local v6, v7, v8;

        if math_abs_ret <= math_abs_ret3 and math_abs_ret2 <= math_abs_ret3 then
            v6 = 1;
            v7 = 0;
            v8 = 0;
        else
            v6 = 0;
            v7 = 0;
            v8 = 1;
        end;

        local v9 = v6 * p2 + v7 * p3 + v8 * p4;
        local v10 = v6 - p2 * v9;
        local v11 = v7 - p3 * v9;
        local v12 = v8 - p4 * v9;
        local math_sqrt_ret = math.sqrt(v10 * v10 + v11 * v11 + v12 * v12);
        local v13 = v10 / math_sqrt_ret;
        local v14 = v11 / math_sqrt_ret;
        local v15 = v12 / math_sqrt_ret;
        local v16 = p2 * p5;
        local v17 = p3 * p5;
        local v18 = p4 * p5;
        local v19 = v13 * 100000;
        local v20 = v14 * 100000;
        local v21 = v15 * 100000;
        local v22 = (v14 * p4 - v15 * p3) * 100000;
        local v23 = (v15 * p2 - v13 * p4) * 100000;
        local v24 = (v13 * p3 - v14 * p2) * 100000;

        return {
            v16 - v22 + v19,
            v17 - v23 + v20,
            v18 - v24 + v21,
            v16 + v22 + v19,
            v17 + v23 + v20,
            v18 + v24 + v21,
            v16 + v22 - v19,
            v17 + v23 - v20,
            v18 + v24 - v21,
            v16 - v22 - v19,
            v17 - v23 - v20,
            v18 - v24 - v21
        };
    end,

    clip = function(p25, p26, p27, p28, p29, p30) -- Line: 47, Name: clip
        local v31 = #p25 // 3;
        local table_create_ret = table.create(v31);
        local table_create_ret2 = table.create(v31);
        local v32 = 0;
        local v33 = 0;

        for i = 1, v31 do
            local v34 = i * 3;
            local v35 = p25[v34 - 2] * p26 + p25[v34 - 1] * p27 + p25[v34] * p28 - p29;
            table_create_ret[i] = v35;
            local v36;

            if p30 < v35 then
                table_create_ret2[i] = 1;
                v32 = v32 + 1;
                v36 = i;
            elseif v35 < -p30 then
                table_create_ret2[i] = -1;
                v33 = v33 + 1;
                v36 = i;
            else
                table_create_ret2[i] = 0;
                v36 = i;
            end;
        end;

        if v32 == 0 then
            return nil;
        end;

        if v33 == 0 then
            return p25;
        end;

        local v37 = 0;
        local v38 = {};

        for i = 1, v31 do
            local v39 = i * 3;
            local v40 = p25[v39 - 2];
            local v41 = p25[v39 - 1];
            local v42 = p25[v39];
            local v43 = table_create_ret2[i];
            local v44;

            if v43 == 0 then
                v38[v37 + 1] = v40;
                v38[v37 + 2] = v41;
                v38[v37 + 3] = v42;
                v37 = v37 + 3;
                v44 = i;
            else
                if v43 == 1 then
                    v38[v37 + 1] = v40;
                    v38[v37 + 2] = v41;
                    v38[v37 + 3] = v42;
                    v37 = v37 + 3;
                end;

                local v45 = i % v31 + 1;
                local v46 = table_create_ret2[v45];

                if v46 == 0 or v46 == v43 then
                    v44 = i;
                else
                    local v47 = v45 * 3;
                    local v48 = p25[v47 - 2];
                    local v49 = p25[v47 - 1];
                    local v50 = p25[v47];
                    local v51 = table_create_ret[i] / (table_create_ret[i] - table_create_ret[v45]);
                    local v52;

                    if p26 == 1 then
                        v52 = p29;
                    elseif p26 == -1 then
                        v52 = -p29;
                    else
                        v52 = v40 + v51 * (v48 - v40);
                    end;

                    local v53;

                    if p27 == 1 then
                        v53 = p29;
                    elseif p27 == -1 then
                        v53 = -p29;
                    else
                        v53 = v41 + v51 * (v49 - v41);
                    end;

                    local v54;

                    if p28 == 1 then
                        v54 = p29;
                    elseif p28 == -1 then
                        v54 = -p29;
                    else
                        v54 = v42 + v51 * (v50 - v42);
                    end;

                    v38[v37 + 1] = v52;
                    v38[v37 + 2] = v53;
                    v38[v37 + 3] = v54;
                    v37 = v37 + 3;
                    v44 = i;
                end;
            end;
        end;

        if v37 < 9 then
            return nil;
        end;

        return v38;
    end,

    split = function(p55, p56, p57, p58, p59, p60) -- Line: 107, Name: split
        local v61 = #p55 // 3;
        local table_create_ret = table.create(v61);
        local table_create_ret2 = table.create(v61);
        local v62 = 0;
        local v63 = 0;

        for i = 1, v61 do
            local v64 = i * 3;
            local v65 = p55[v64 - 2] * p56 + p55[v64 - 1] * p57 + p55[v64] * p58 - p59;
            table_create_ret[i] = v65;
            local v66;

            if p60 < v65 then
                table_create_ret2[i] = 1;
                v62 = v62 + 1;
                v66 = i;
            elseif v65 < -p60 then
                table_create_ret2[i] = -1;
                v63 = v63 + 1;
                v66 = i;
            else
                table_create_ret2[i] = 0;
                v66 = i;
            end;
        end;

        if v62 == 0 then
            return nil, p55;
        end;

        if v63 == 0 then
            return p55, nil;
        end;

        local v67 = {};
        local v68 = {};

        for i = 1, v61 do
            local v69 = i * 3;
            local v70 = p55[v69 - 2];
            local v71 = p55[v69 - 1];
            local v72 = p55[v69];
            local v73 = table_create_ret2[i];
            local v74;

            if v73 == 0 then
                v67[#v67 + 1] = v70;
                v67[#v67 + 2] = v71;
                v67[#v67 + 3] = v72;
                v68[#v68 + 1] = v70;
                v68[#v68 + 2] = v71;
                v68[#v68 + 3] = v72;
                v74 = i;
            else
                if v73 == 1 then
                    v67[#v67 + 1] = v70;
                    v67[#v67 + 2] = v71;
                    v67[#v67 + 3] = v72;
                else
                    v68[#v68 + 1] = v70;
                    v68[#v68 + 2] = v71;
                    v68[#v68 + 3] = v72;
                end;

                local v75 = i % v61 + 1;
                local v76 = table_create_ret2[v75];

                if v76 == 0 or v76 == v73 then
                    v74 = i;
                else
                    local v77 = v75 * 3;
                    local v78 = p55[v77 - 2];
                    local v79 = p55[v77 - 1];
                    local v80 = p55[v77];
                    local v81 = table_create_ret[i] / (table_create_ret[i] - table_create_ret[v75]);
                    local v82;

                    if p56 == 1 then
                        v82 = p59;
                    elseif p56 == -1 then
                        v82 = -p59;
                    else
                        v82 = v70 + v81 * (v78 - v70);
                    end;

                    local v83;

                    if p57 == 1 then
                        v83 = p59;
                    elseif p57 == -1 then
                        v83 = -p59;
                    else
                        v83 = v71 + v81 * (v79 - v71);
                    end;

                    local v84;

                    if p58 == 1 then
                        v84 = p59;
                    elseif p58 == -1 then
                        v84 = -p59;
                    else
                        v84 = v72 + v81 * (v80 - v72);
                    end;

                    v67[#v67 + 1] = v82;
                    v67[#v67 + 2] = v83;
                    v67[#v67 + 3] = v84;
                    v68[#v68 + 1] = v82;
                    v68[#v68 + 2] = v83;
                    v68[#v68 + 3] = v84;
                    v74 = i;
                end;
            end;
        end;

        if #v67 < 9 then
            v67 = nil;
        end;

        if #v68 >= 9 then
            return v67, v68;
        end;

        return v67, nil;
    end,

    area = function(p85) -- Line: 164, Name: area
        local v86 = #p85 // 3;

        if v86 < 3 then
            return 0;
        end;

        local v87 = p85[1];
        local v88 = p85[2];
        local v89 = p85[3];
        local v90 = 0;
        local v91 = 0;
        local v92 = 0;

        for i = 2, v86 - 1 do
            local v93 = p85[i * 3 - 2] - v87;
            local v94 = p85[i * 3 - 1] - v88;
            local v95 = p85[i * 3] - v89;
            local v96 = p85[i * 3 + 1] - v87;
            local v97 = p85[i * 3 + 2] - v88;
            local v98 = p85[i * 3 + 3] - v89;
            v90 = v90 + (v94 * v98 - v95 * v97);
            v91 = v91 + (v95 * v96 - v93 * v98);
            v92 = v92 + (v93 * v97 - v94 * v96);
            local _ = i;
        end;

        return math.sqrt(v90 * v90 + v91 * v91 + v92 * v92) * 0.5;
    end
};

function u99.contains(p100, p101, p102, p103, p104, p105) -- Line: 182
    -- upvalues: u99 (copy)
    local v106 = #p100 // 3;

    for i = 1, v106 do
        local v107 = i % v106 + 1;
        local v108 = p100[i * 3 - 2];
        local v109 = p100[i * 3 - 1];
        local v110 = p100[i * 3];
        local v111 = p100[v107 * 3 - 2] - v108;
        local v112 = p100[v107 * 3 - 1] - v109;
        local v113 = p100[v107 * 3] - v110;
        local v114 = p102 * v113 - p103 * v112;
        local v115 = p103 * v111 - p101 * v113;
        local v116 = p101 * v112 - p102 * v111;
        local math_sqrt_ret = math.sqrt(v114 * v114 + v115 * v115 + v116 * v116);
        local v117;

        if math_sqrt_ret < 1e-9 then
            v117 = i;
        else
            local v118 = v114 / math_sqrt_ret;
            local v119 = v115 / math_sqrt_ret;
            local v120 = v116 / math_sqrt_ret;
            local v121 = v118 * v108 + v119 * v109 + v120 * v110;
            local v122, v123, v124 = u99.center(p100);

            if v118 * v122 + v119 * v123 + v120 * v124 - v121 < 0 then
                v118 = -v118;
                v119 = -v119;
                v120 = -v120;
                v121 = -v121;
            end;

            v117 = i;

            for i2 = 1, #p104, 3 do
                if v118 * p104[i2] + v119 * p104[i2 + 1] + v120 * p104[i2 + 2] - v121 < -p105 then
                    return false;
                end;

                local _ = i2;
            end;
        end;
    end;

    return true;
end;

function u99.reverse(p125) -- Line: 210
    local v126 = #p125 // 3;
    local table_create_ret = table.create(#p125);

    for i = 1, v126 do
        local v127 = v126 + 1 - i;
        local v128 = p125[v127 * 3 - 1];
        local v129 = p125[v127 * 3];
        table_create_ret[i * 3 - 2] = p125[v127 * 3 - 2];
        table_create_ret[i * 3 - 1] = v128;
        table_create_ret[i * 3] = v129;
        local _ = i;
    end;

    return table_create_ret;
end;

function u99.range(p130, p131, p132, p133, p134) -- Line: 221
    local v135 = (1 / 0);
    local v136 = (-1 / 0);

    for i = 1, #p130, 3 do
        local v137 = p130[i] * p131 + p130[i + 1] * p132 + p130[i + 2] * p133 - p134;

        if v137 < v135 then
            v135 = v137;
        end;

        local v138;

        if v136 < v137 then
            v138 = i;
            v136 = v137;
        else
            v138 = i;
        end;
    end;

    return v135, v136;
end;

function u99.center(p139) -- Line: 235
    local v140 = #p139 // 3;
    local v141 = 0;
    local v142 = 0;
    local v143 = 0;

    for i = 1, #p139, 3 do
        v141 = v141 + p139[i];
        v142 = v142 + p139[i + 1];
        v143 = v143 + p139[i + 2];
        local _ = i;
    end;

    return v141 / v140, v142 / v140, v143 / v140;
end;

function u99.bounds(p144) -- Line: 246
    local v145 = (-1 / 0);
    local v146 = (-1 / 0);
    local v147 = (1 / 0);
    local v148 = (1 / 0);
    local v149 = (1 / 0);
    local v150 = (-1 / 0);

    for i = 1, #p144, 3 do
        local v151 = p144[i];
        local v152 = p144[i + 1];
        local v153 = p144[i + 2];

        if v151 < v147 then
            v147 = v151;
        end;

        if v152 < v148 then
            v148 = v152;
        end;

        if v153 < v149 then
            v149 = v153;
        end;

        if v150 >= v151 then
            v151 = v150;
        end;

        if v145 >= v152 then
            v152 = v145;
        end;

        local v154;

        if v146 < v153 then
            v150 = v151;
            v154 = i;
            v146 = v153;
            v145 = v152;
        else
            v150 = v151;
            v154 = i;
            v145 = v152;
        end;
    end;

    return v147, v148, v149, v150, v145, v146;
end;

function u99.planeFromPoints(p155, p156, p157, p158, p159, p160, p161, p162, p163) -- Line: 274
    local v164 = p158 - p155;
    local v165 = p159 - p156;
    local v166 = p160 - p157;
    local v167 = p161 - p155;
    local v168 = p162 - p156;
    local v169 = p163 - p157;
    local v170 = v165 * v169 - v166 * v168;
    local v171 = v166 * v167 - v164 * v169;
    local v172 = v164 * v168 - v165 * v167;
    local math_sqrt_ret = math.sqrt(v170 * v170 + v171 * v171 + v172 * v172);

    if math_sqrt_ret < 1e-6 then
        return nil;
    end;

    local v173 = v170 / math_sqrt_ret;
    local v174 = v171 / math_sqrt_ret;
    local v175 = v172 / math_sqrt_ret;

    return v173, v174, v175, v173 * p155 + v174 * p156 + v175 * p157;
end;

function u99.planeKey(p176, p177, p178, p179) -- Line: 287
    local v180;

    if p176 < -1e-6 then
        v180 = true;
    elseif math.abs(p176) <= 1e-6 then
        if p177 < -1e-6 then
            v180 = true;
        elseif math.abs(p177) <= 1e-6 then
            v180 = p178 < 0;
        else
            v180 = false;
        end;
    else
        v180 = false;
    end;

    if v180 then
        p176 = -p176;
        p177 = -p177;
        p178 = -p178;
        p179 = -p179;
    end;

    return string.format("%.4f,%.4f,%.4f,%.2f", p176, p177, p178, p179);
end;

function u99.isAxial(p181, p182, p183) -- Line: 295
    return (math.abs(p181) > 0.9999 or math.abs(p182) > 0.9999) and true or math.abs(p183) > 0.9999;
end;

return u99;