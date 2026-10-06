-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.RuntimeTypes);

return table.freeze({
    queue = function(p1, p2) -- Line: 12, Name: queue
        -- upvalues: Serial (copy)
        local _mapping = p1._mapping;

        if _mapping == nil or _mapping.Generation ~= p2.Generation then
            if p1._retiredGeneration ~= p2.Generation then
                p1:_sendMappingRequest(p2.Generation);
            end;

            return;
        end;

        local _actionLocks = p1._actionLocks;

        if _actionLocks ~= nil and Serial.deltaUInt32(p2.History.Revision, _actionLocks.Revision) <= 0 then
            return;
        end;

        p1._actionLocks = p2.History;
        local _pendingReconciliationInstall = p1._pendingReconciliationInstall;
        local _reconciler = p1._reconciler;

        if _pendingReconciliationInstall == nil or _reconciler == nil then
            if p1._state ~= nil then
                p1._pendingActionLockReplay = true;
            end;

            return;
        end;

        p1._pendingActionLockReplay = not _reconciler:invalidatePendingReplayFromTick(Serial.addUInt32(_pendingReconciliationInstall.Snapshot.ServerTick, 1));
    end,

    flush = function(p3) -- Line: 36, Name: flush
        if not p3._pendingActionLockReplay or p3._pendingReconciliationInstall ~= nil then
            return false;
        end;

        local _mapping = p3._mapping;
        local _lastAcceptedOwnerSnapshot = p3._lastAcceptedOwnerSnapshot;

        if _mapping == nil or (_lastAcceptedOwnerSnapshot == nil or p3._state == nil) then
            return false;
        end;

        p3._pendingActionLockReplay = false;
        local _pendingOwnerSnapshot = p3._pendingOwnerSnapshot;

        if _pendingOwnerSnapshot ~= nil then
            p3._pendingOwnerSnapshot = nil;

            if p3:_handleOwnerSnapshot(_pendingOwnerSnapshot, true) or p3._pendingReconciliationInstall ~= nil then
                return true;
            end;
        end;

        local v4, v5 = p3:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, true);

        if v4 or v5 == "ReplayPending" then
            return true;
        end;

        p3:_setStatus("WaitingForAuthority", "ActionLockChangedInsidePrediction");
        p3:_sendMappingRequest(_mapping.Generation);
        p3:_warn((`could not replay action lock: {v5}`));

        return false;
    end
});