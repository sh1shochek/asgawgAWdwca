-- Decompiled with Potassium's decompiler.

local u1 = {
    Connected = true
};
u1.__index = u1;

function u1.Disconnect(p2) -- Line: 20
    if p2.Connected then
        p2.Connected = false;
        p2.Connection:Disconnect();
    end;
end;

function u1._new(p3: userdata) -- Line: 27
    -- upvalues: u1 (copy)
    return setmetatable({
        Connection = p3
    }, u1);
end;

function u1.__tostring(p4) -- Line: 33
    return "RbxScriptConnection<" .. tostring(p4.Connected) .. ">";
end;

return u1;