-- Decompiled with Potassium's decompiler.

local v1 = {};

if game:GetService("RunService"):IsClient() then
    v1.Client = require(script.Client);

    return v1;
end;

v1.Server = require(script.Server);

return v1;