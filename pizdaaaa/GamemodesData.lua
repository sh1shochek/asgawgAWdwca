-- ReplicatedStorage.Shared.Data.GamemodesData
-- Script path: ReplicatedStorage.Shared.Data.GamemodesData
-- Decompile time: 6.23 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    Modes = {
        Casual = {
            Icon = "rbxassetid://100525337297460",
            Thumbnail = 119939440047927,
            PlaceId = 87204735676240
        }
    },
    Maps = {
        de_seaside = {
            Name = "Seaside",
            Thumbnail = 91040899093943
        },
        de_vertigo = {
            Name = "Vertigo",
            Thumbnail = 121264823441806
        },
        de_dust2 = {
            Name = "Dust II",
            Thumbnail = 131413802758115
        }
    }
};

function u1.getMode(p2) -- Line: 38
    -- upvalues: u1 (copy)
    for i, v in u1.Modes do
        if v.PlaceId == p2 then
            return i;
        end;
    end;

    return nil;
end;

function u1.getIcon(p3) -- Line: 52
    -- upvalues: u1 (copy)
    if typeof(p3) ~= "table" and p3 then
        p3 = u1.Modes[p3];
    end;

    if not p3 then
        return "rbxassetid://0";
    end;

    local v4 = p3.Icon or p3.Thumbnail;

    if not v4 then
        return "rbxassetid://0";
    end;

    if typeof(v4) == "string" then
        return v4;
    end;

    return `rbxassetid://{v4}`;
end;

return u1;