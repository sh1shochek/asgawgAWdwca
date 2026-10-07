-- ReplicatedStorage.MovementV2.Client.DamageTagReplay
-- Script path: ReplicatedStorage.MovementV2.Client.DamageTagReplay
-- Decompile time: 1.19 ms

local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.RuntimeTypes)
return table.freeze({
    flush = function(a1) -- Line: 12 -- upvalues: Serial (val)
        local _pendingDamageTagReplayMovementTick = a1._pendingDamageTagReplayMovementTick
        if _pendingDamageTagReplayMovementTick ~= nil and a1._pendingReconciliationInstall == nil then
            local _mapping = a1._mapping
            local _lastAcceptedOwnerSnapshot = a1._lastAcceptedOwnerSnapshot
            local MovementTick = if a1._state ~= nil then a1._state.MovementTick else nil
            if _mapping ~= nil and _lastAcceptedOwnerSnapshot ~= nil and MovementTick ~= nil then
                local v1, v2
                if 0 <= (Serial.deltaUInt32(_lastAcceptedOwnerSnapshot.State.MovementTick, _pendingDamageTagReplayMovementTick)) then
                    a1:_pruneDamageTagsThrough(_lastAcceptedOwnerSnapshot.State.MovementTick)
                    return false
                end
                if (Serial.deltaUInt32(MovementTick, _pendingDamageTagReplayMovementTick)) < 0 then
                    a1._pendingDamageTagReplayMovementTick = nil
                    return false
                end
                local _pendingOwnerSnapshot = a1._pendingOwnerSnapshot
                if _pendingOwnerSnapshot == nil then
                    a1._pendingDamageTagReplayMovementTick = nil
                    v1, v2 = a1:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, nil, nil, (Serial.addUInt32(
                        _lastAcceptedOwnerSnapshot.ServerTick,
                        (Serial.deltaUInt32(_pendingDamageTagReplayMovementTick, _lastAcceptedOwnerSnapshot.State.MovementTick))
                    )))
                    if not v1 and v2 ~= "ReplayPending" then
                        a1:_setStatus("WaitingForAuthority", "DamageTagChangedInsidePrediction")
                        a1:_sendMappingRequest(_mapping.Generation)
                        a1:_warn((("could not replay late damage tag: %*"):format(v2)))
                        return false
                    end
                    return true
                end
                a1._pendingOwnerSnapshot = nil
                if not a1:_handleOwnerSnapshot(_pendingOwnerSnapshot, true)
                    and a1._pendingReconciliationInstall == nil then
                    a1._pendingDamageTagReplayMovementTick = nil
                    v1, v2 = a1:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, nil, nil, (Serial.addUInt32(
                        _lastAcceptedOwnerSnapshot.ServerTick,
                        (Serial.deltaUInt32(_pendingDamageTagReplayMovementTick, _lastAcceptedOwnerSnapshot.State.MovementTick))
                    )))
                    if not v1 and v2 ~= "ReplayPending" then
                        a1:_setStatus("WaitingForAuthority", "DamageTagChangedInsidePrediction")
                        a1:_sendMappingRequest(_mapping.Generation)
                        a1:_warn((("could not replay late damage tag: %*"):format(v2)))
                        return false
                    end
                    return true
                end
                return true
            end
            return false
        end
        return false
    end,
})