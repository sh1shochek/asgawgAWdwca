-- ReplicatedStorage.Components.Common.CalculateGridRenderCount
-- Script path: ReplicatedStorage.Components.Common.CalculateGridRenderCount
-- Decompile time: 2.04 ms

return function(a1) -- Line: 3 -- types: a1: userdata
    local UIGridLayout = a1:FindFirstChildOfClass("UIGridLayout")
    if not UIGridLayout then
        return 50
    end
    local X = a1.AbsoluteSize.X
    local Y = a1.AbsoluteSize.Y
    local v1 = UIGridLayout.CellSize.X.Scale * X + UIGridLayout.CellSize.X.Offset
    local v2 = UIGridLayout.CellSize.Y.Scale * Y + UIGridLayout.CellSize.Y.Offset
    local v3 = UIGridLayout.CellPadding.X.Scale * X + UIGridLayout.CellPadding.X.Offset
    local v4 = UIGridLayout.CellPadding.Y.Scale * Y + UIGridLayout.CellPadding.Y.Offset
    local UIPadding = a1:FindFirstChildOfClass("UIPadding")
    local v5 = X
    local v6 = Y
    if UIPadding then
        v5 = v5 - ((UIPadding.PaddingLeft.Scale + UIPadding.PaddingRight.Scale) * X + UIPadding.PaddingLeft.Offset + UIPadding.PaddingRight.Offset)
        v6 = v6 - ((UIPadding.PaddingTop.Scale + UIPadding.PaddingBottom.Scale) * Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
    end
    local v7 = if not (0 < v1 + v3) then 1 else math.max(1, (math.floor((v5 + v3) / (v1 + v3))))
    return ((if not (0 < v2 + v4) then 1 else math.max(1, (math.floor((v6 + v4) / (v2 + v4))))) + 1) * v7
end