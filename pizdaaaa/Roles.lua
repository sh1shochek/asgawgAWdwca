-- ReplicatedStorage.Shared.Roles
-- Script path: ReplicatedStorage.Shared.Roles
-- Decompile time: 13.37 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    PentestPlaceId = 109013281719699
};

function u1.IsPentester(p2: number?) -- Line: 23
    -- upvalues: u1 (copy)
    local v3;

    if p2 == nil then
        v3 = false;
    else
        v3 = u1.Pentesters[p2] == true;
    end;

    return v3;
end;

local RunService = game:GetService("RunService");
u1.Ranks = {
    Moderator = 1,
    Admin = 2,
    Developer = 3
};
u1.Prefixes = {
    Developer = {
        Tag = "[DEV]",
        Text = "DEV",
        Color = "rgb(8, 193, 245)",
        Color3 = Color3.fromRGB(8, 193, 245)
    },
    Collaborator = {
        Tag = "[COLLAB]",
        Text = "COLLAB",
        Color = "rgb(62, 221, 152)",
        Color3 = Color3.fromRGB(62, 221, 152)
    },
    Moderator = {
        Tag = "[MOD]",
        Text = "MOD",
        Color = "rgb(233, 102, 36)",
        Color3 = Color3.fromRGB(233, 102, 36)
    },
    Overwatch = {
        Tag = "[WATCH]",
        Text = "WATCH",
        Color = "rgb(255, 182, 24)",
        Color3 = Color3.fromRGB(255, 182, 24)
    },
    Star = {
        Tag = "[STAR]",
        Text = "STAR",
        Color = "rgb(233, 224, 122)",
        Color3 = Color3.fromRGB(233, 224, 122)
    },
    Media = {
        Tag = "[MEDIA]",
        Text = "MEDIA",
        Color = "rgb(226, 74, 74)",
        Color3 = Color3.fromRGB(226, 74, 74)
    },
    Tester = {
        Tag = "[TESTER]",
        Text = "TESTER",
        Color = "rgb(142, 136, 255)",
        Color3 = Color3.fromRGB(142, 136, 255)
    }
};

if RunService:IsServer() then
    local RoleList = require(game:GetService("ServerScriptService").GameServer.RoleList);
    u1.Users = RoleList.Users;
    u1.PrefixRoles = RoleList.PrefixRoles;
    u1.PrefixUsers = RoleList.PrefixRoles;
    u1.Pentesters = RoleList.Pentesters;
else
    local LocalPlayer = game:GetService("Players").LocalPlayer;

    local function Own(u4: string, u5: string?) -- Line: 92
        -- upvalues: LocalPlayer (copy)
        return setmetatable({}, {
            __index = function(p6, p7) -- Line: 93, Name: __index
                -- upvalues: LocalPlayer (ref), u4 (copy), u5 (copy)
                if p7 == LocalPlayer.UserId then
                    local v8 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

                    if v8 then
                        v8 = v8:GetAttribute(u4);
                    end;

                    return v8;
                end;

                local v9 = u5;

                if v9 then
                    if type(p7) == "number" then
                        v9 = game:GetService("Players"):GetPlayerByUserId(p7);
                    else
                        v9 = false;
                    end;
                end;

                return v9 and v9:GetAttribute(u5) or nil;
            end
        });
    end;

    u1.Users = Own("Role");
    u1.PrefixRoles = Own("PrefixRole", "ChatPrefix");
    u1.PrefixUsers = u1.PrefixRoles;
    u1.Pentesters = Own("Pentester");
end;

function u1.GetRole(p10: number?) -- Line: 109
    -- upvalues: u1 (copy)
    return p10 and u1.Users[p10] or nil;
end;

function u1.GetPrefixRole(p11: number?) -- Line: 113
    -- upvalues: u1 (copy)
    if p11 then
        return u1.PrefixRoles[p11] or u1.Users[p11];
    end;

    return nil;
end;

function u1.GetRank(p12: number?) -- Line: 118
    -- upvalues: u1 (copy)
    local Role = u1.GetRole(p12);

    return Role and u1.Ranks[Role] or 0;
end;

function u1.GetChatPrefix(p13: number?) -- Line: 124
    -- upvalues: u1 (copy)
    local PrefixRole = u1.GetPrefixRole(p13);

    if not PrefixRole then
        return nil;
    end;

    local v14 = u1.Prefixes[PrefixRole];

    if not v14 then
        local v15 = PrefixRole:gsub("%s+", ""):lower();

        for i, v in u1.Prefixes do
            if i:gsub("%s+", ""):lower() == v15 then
                return v;
            end;
        end;
    end;

    return v14;
end;

function u1.HasChatPrefix(p16: number?) -- Line: 141
    -- upvalues: u1 (copy)
    return u1.GetChatPrefix(p16) ~= nil;
end;

function u1.HasRole(p17: number?, p18: string) -- Line: 145
    -- upvalues: u1 (copy)
    if not p17 then
        return false;
    end;

    local v19 = u1.GetPrefixRole(p17) or u1.GetRole(p17);

    if v19 and (v19:lower() == p18:lower() or v19:gsub("%s+", ""):lower() == p18:gsub("%s+", ""):lower()) then
        return true;
    end;

    local v20 = u1.Ranks[p18];
    local v21;

    if v20 == nil then
        v21 = false;
    else
        v21 = v20 <= u1.GetRank(p17);
    end;

    return v21;
end;

function u1.IsDeveloper(p22: number?) -- Line: 156
    -- upvalues: u1 (copy)
    return u1.HasRole(p22, "Developer");
end;

function u1.IsCollaborator(p23: number?) -- Line: 160
    -- upvalues: u1 (copy)
    return u1.HasRole(p23, "Collaborator");
end;

function u1.IsModerator(p24: number?) -- Line: 164
    -- upvalues: u1 (copy)
    return u1.HasRole(p24, "Moderator");
end;

function u1.IsStar(p25: number?) -- Line: 168
    -- upvalues: u1 (copy)
    return u1.HasRole(p25, "Star");
end;

function u1.IsMedia(p26: number?) -- Line: 172
    -- upvalues: u1 (copy)
    return u1.HasRole(p26, "Media");
end;

function u1.IsContentCreator(p27: number?) -- Line: 176
    -- upvalues: u1 (copy)
    return u1.IsStar(p27) or u1.IsMedia(p27) or (u1.HasRole(p27, "ContentCreator") or u1.HasRole(p27, "Content Creator"));
end;

function u1.IsTester(p28: number?) -- Line: 180
    -- upvalues: u1 (copy)
    return u1.HasRole(p28, "Tester");
end;

return u1;