-- ReplicatedStorage.Components.Common.GetWeaponCameraKick
-- Script path: ReplicatedStorage.Components.Common.GetWeaponCameraKick
-- Decompile time: 0.82 ms

return function(a1) -- Line: 1
    local Rotation = a1.Rotation
    local Position = a1.Position
    local Value = Rotation.RotationDampen.Value
    local Value_2 = Rotation.RotationSpeed.Value
    local Value_3 = Position.PositionDampen.Value
    local Value_4 = Position.PositionSpeed.Value
    local v1 = if not (Value_3 > 2) then Value_3 else 1
    local v2 = if not (Value_4 > 2) then Value_4 else 1
    local v3 = if not (Value_2 >= 30) then Value_2 else 25
    local Value_5 = Rotation.RotationX.Value
    local Value_6 = Rotation.RotationY.Value
    local Value_7 = Rotation.RotationZ.Value
    local v4 = if not (Value >= 5) then Value else 1
    local v5 = if not ((math.abs(Value_6)) < 0.1) then math.abs(Value_6) else 25
    local v6 = (math.random() * 2 - 1) * v5 * 0.5
    local v7 = if not (Value_7 < 0.1) then Value_7 else 1
    return {
        Value = Vector3.new((if not (Value_5 < 0.1) then Value_5 else 1) * 0.8, v6, v7),
        Damper = v4,
        Speed = v3,
    }, {
        Value = Vector3.new(Position.PositionX.Value, Position.PositionY.Value, Position.PositionZ.Value),
        Damper = v1,
        Speed = v2,
    }
end