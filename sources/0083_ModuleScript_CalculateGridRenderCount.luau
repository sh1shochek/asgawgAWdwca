-- Decompiled with Potassium's decompiler.

return function(p1: userdata) -- Line: 3
    local v2 = p1:FindFirstChildOfClass("UIGridLayout");

    if not v2 then
        return 50;
    end;

    local X = p1.AbsoluteSize.X;
    local Y = p1.AbsoluteSize.Y;
    local v3 = v2.CellSize.X.Scale * X + v2.CellSize.X.Offset;
    local v4 = v2.CellSize.Y.Scale * Y + v2.CellSize.Y.Offset;
    local v5 = v2.CellPadding.X.Scale * X + v2.CellPadding.X.Offset;
    local v6 = v2.CellPadding.Y.Scale * Y + v2.CellPadding.Y.Offset;
    local v7 = p1:FindFirstChildOfClass("UIPadding");

    if v7 then
        X = X - ((v7.PaddingLeft.Scale + v7.PaddingRight.Scale) * X + v7.PaddingLeft.Offset + v7.PaddingRight.Offset);
        Y = Y - ((v7.PaddingTop.Scale + v7.PaddingBottom.Scale) * Y + v7.PaddingTop.Offset + v7.PaddingBottom.Offset);
    end;

    local v8;

    if v3 + v5 > 0 then
        local math_floor_ret = math.floor((X + v5) / (v3 + v5));
        v8 = math.max(1, math_floor_ret);
    else
        v8 = 1;
    end;

    local v9;

    if v4 + v6 > 0 then
        local math_floor_ret = math.floor((Y + v6) / (v4 + v6));
        v9 = math.max(1, math_floor_ret);
    else
        v9 = 1;
    end;

    return (v9 + 1) * v8;
end;