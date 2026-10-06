-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local Rotation = p1.Rotation;
    local Position = p1.Position;
    local Value = Rotation.RotationDampen.Value;
    local Value2 = Rotation.RotationSpeed.Value;
    local Value3 = Position.PositionDampen.Value;
    local Value4 = Position.PositionSpeed.Value;
    local Value5 = Rotation.RotationX.Value;
    local Value6 = Rotation.RotationY.Value;
    local Value7 = Rotation.RotationZ.Value;
    local v2 = math.abs(Value6) < 0.1 and 25 or math.abs(Value6);
    local v3 = (math.random() * 2 - 1) * v2 * 0.5;

    return {
        Value = Vector3.new((Value5 < 0.1 and 1 or Value5) * 0.8, v3, Value7 < 0.1 and 1 or Value7),
        Damper = Value >= 5 and 1 or Value,
        Speed = Value2 >= 30 and 25 or Value2
    }, {
        Value = Vector3.new(Position.PositionX.Value, Position.PositionY.Value, Position.PositionZ.Value),
        Damper = Value3 > 2 and 1 or Value3,
        Speed = Value4 > 2 and 1 or Value4
    };
end;