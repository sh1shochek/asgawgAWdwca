-- ReplicatedStorage.MovementV2.Client.ActionLockReplay
-- Script path: ReplicatedStorage.MovementV2.Client.ActionLockReplay
-- Decompile time: 0.97 ms

local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.RuntimeTypes)
return table.freeze({
    queue = function(a1, a2) -- Line: 12 -- upvalues: Serial (val)
        local _mapping = a1._mapping
        if _mapping ~= nil and _mapping.Generation == a2.Generation then
            local _actionLocks = a1._actionLocks
            if _actionLocks ~= nil and (Serial.deltaUInt32(a2.History.Revision, _actionLocks.Revision)) <= 0 then
                return
            end
            a1._actionLocks = a2.History
            local _pendingReconciliationInstall = a1._pendingReconciliationInstall
            local _reconciler = a1._reconciler
            if _pendingReconciliationInstall ~= nil and _reconciler ~= nil then
                a1._pendingActionLockReplay = not _reconciler:invalidatePendingReplayFromTick((Serial.addUInt32(_pendingReconciliationInstall.Snapshot.ServerTick, 1)))
                return
            end
            if a1._state ~= nil then
                a1._pendingActionLockReplay = true
            end
            return
        end
        if a1._retiredGeneration ~= a2.Generation then
            a1:_sendMappingRequest(a2.Generation)
        end
    end,
    flush = function(a1) -- Line: 36
        if a1._pendingActionLockReplay and a1._pendingReconciliationInstall == nil then
            local _mapping = a1._mapping
            local _lastAcceptedOwnerSnapshot = a1._lastAcceptedOwnerSnapshot
            if _mapping ~= nil and _lastAcceptedOwnerSnapshot ~= nil and a1._state ~= nil then
                local v1, v2
                a1._pendingActionLockReplay = false
                local _pendingOwnerSnapshot = a1._pendingOwnerSnapshot
                if _pendingOwnerSnapshot == nil then
                    v1, v2 = a1:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, true)
                    if not v1 and v2 ~= "ReplayPending" then
                        a1:_setStatus("WaitingForAuthority", "ActionLockChangedInsidePrediction")
                        a1:_sendMappingRequest(_mapping.Generation)
                        a1:_warn((("could not replay action lock: %*"):format(v2)))
                        return false
                    end
                    return true
                end
                a1._pendingOwnerSnapshot = nil
                if not a1:_handleOwnerSnapshot(_pendingOwnerSnapshot, true)
                    and a1._pendingReconciliationInstall == nil then
                    v1, v2 = a1:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, true)
                    if not v1 and v2 ~= "ReplayPending" then
                        a1:_setStatus("WaitingForAuthority", "ActionLockChangedInsidePrediction")
                        a1:_sendMappingRequest(_mapping.Generation)
                        a1:_warn((("could not replay action lock: %*"):format(v2)))
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