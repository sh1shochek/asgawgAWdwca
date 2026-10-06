-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.RuntimeTypes);

return table.freeze({
    flush = function(p1) -- Line: 12, Name: flush
        -- upvalues: Serial (copy)
        local _pendingDamageTagReplayMovementTick = p1._pendingDamageTagReplayMovementTick;

        if _pendingDamageTagReplayMovementTick == nil or p1._pendingReconciliationInstall ~= nil then
            return false;
        end;

        local _mapping = p1._mapping;
        local _lastAcceptedOwnerSnapshot = p1._lastAcceptedOwnerSnapshot;
        local v2;

        if p1._state == nil then
            v2 = nil;
        else
            v2 = p1._state.MovementTick;
        end;

        if _mapping == nil or (_lastAcceptedOwnerSnapshot == nil or v2 == nil) then
            return false;
        end;

        if Serial.deltaUInt32(_lastAcceptedOwnerSnapshot.State.MovementTick, _pendingDamageTagReplayMovementTick) >= 0 then
            p1:_pruneDamageTagsThrough(_lastAcceptedOwnerSnapshot.State.MovementTick);

            return false;
        end;

        if Serial.deltaUInt32(v2, _pendingDamageTagReplayMovementTick) < 0 then
            p1._pendingDamageTagReplayMovementTick = nil;

            return false;
        end;

        local _pendingOwnerSnapshot = p1._pendingOwnerSnapshot;

        if _pendingOwnerSnapshot ~= nil then
            p1._pendingOwnerSnapshot = nil;

            if p1:_handleOwnerSnapshot(_pendingOwnerSnapshot, true) or p1._pendingReconciliationInstall ~= nil then
                return true;
            end;
        end;

        p1._pendingDamageTagReplayMovementTick = nil;
        local v3, v4 = p1:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, nil, nil, (Serial.addUInt32(_lastAcceptedOwnerSnapshot.ServerTick, Serial.deltaUInt32(_pendingDamageTagReplayMovementTick, _lastAcceptedOwnerSnapshot.State.MovementTick))));

        if v3 or v4 == "ReplayPending" then
            return true;
        end;

        p1:_setStatus("WaitingForAuthority", "DamageTagChangedInsidePrediction");
        p1:_sendMappingRequest(_mapping.Generation);
        p1:_warn((`could not replay late damage tag: {v4}`));

        return false;
    end
});