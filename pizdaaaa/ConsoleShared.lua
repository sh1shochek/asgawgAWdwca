-- ReplicatedStorage.Shared.ConsoleShared
-- Script path: ReplicatedStorage.Shared.ConsoleShared
-- Decompile time: 47.63 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Roles = require(game:GetService("ReplicatedStorage").Shared.Roles);

local function TradeLocked(p2: any, p3: boolean?) -- Line: 14
    -- upvalues: Roles (copy)
    local v4;

    if p3 == true then
        v4 = true;
    else
        local v5 = p2.Player == nil and true or Roles.IsDeveloper(p2.Player.UserId);
        v4 = not v5;
    end;

    return v4;
end;

function u1.IsBlockedCommand(p6) -- Line: 18
    -- upvalues: Roles (copy)
    local v7;

    if game.PlaceId == Roles.PentestPlaceId then
        v7 = p6.Name:lower():sub(1, 6) == "promo_";
    else
        v7 = false;
    end;

    return v7;
end;

function u1.IsUnlockedCommand(p8: any, p9: number?) -- Line: 22
    -- upvalues: Roles (copy), u1 (copy)
    local v10;

    if game.PlaceId == Roles.PentestPlaceId then
        v10 = (workspace:GetAttribute("TestVIPConsole") == true or Roles.IsPentester(p9)) and not u1.IsBlockedCommand(p8);

        if v10 then
            if p8.Name:lower() == "ban" then
                v10 = false;
            else
                v10 = p8.Name:lower() ~= "kick";
            end;
        end;
    else
        v10 = false;
    end;

    return v10;
end;

function u1.CanPlayerRun(p11: any, p12: number, p13: boolean, p14: boolean, p15: number?) -- Line: 36
    -- upvalues: u1 (copy), Roles (copy)
    if u1.IsBlockedCommand(p11) then
        return false;
    end;

    if u1.IsUnlockedCommand(p11, p15) then
        return true;
    end;

    if p11.RequireCheats and not p14 then
        return false;
    end;

    local Role = p11.Role;

    if Role == nil then
        if (Roles.Ranks.Developer or 1) <= p12 or p13 == true then
            p15 = true;
        elseif p15 then
            p15 = Roles.IsStar(p15) or Roles.IsMedia(p15);
        end;

        return p15;
    end;

    local v16 = typeof(Role) == "table" and Role and Role or { Role };

    for _, v in ipairs(v16) do
        if p15 and Roles.HasRole(p15, v) then
            return true;
        end;

        local v17 = Roles.Ranks[v];

        if v17 and v17 <= p12 then
            return true;
        end;
    end;

    return p11.AllowServerOwner and p13 == true and true or (p11.AllowCheats and (p13 == true and p14 == true) and true or false);
end;

function u1.Tokenize(p18: string) -- Line: 121
    local v19 = #p18;
    local v20 = 1;
    local v21 = {};

    while v20 <= v19 do
        while v20 <= v19 and p18:sub(v20, v20):match("%s") do
            v20 = v20 + 1;
        end;

        if v19 < v20 then
            break;
        end;

        local v22 = p18:sub(v20, v20);

        if v22 == "\"" or v22 == "\'" then
            local v23 = v20 + 1;
            local v24 = {};

            while v23 <= v19 and p18:sub(v23, v23) ~= v22 do
                table.insert(v24, p18:sub(v23, v23));
                v23 = v23 + 1;
            end;

            table.insert(v21, table.concat(v24));
            v20 = v23 + 1;
        else
            local v25 = v20;

            while v20 <= v19 and not p18:sub(v20, v20):match("%s") do
                v20 = v20 + 1;
            end;

            table.insert(v21, p18:sub(v25, v20 - 1));
        end;
    end;

    return v21;
end;

function u1.Parse(p26: string) -- Line: 164
    -- upvalues: u1 (copy)
    local v27 = u1.Tokenize(p26 or "");
    local v28 = v27[1];
    local v29 = {};

    for i = 2, #v27 do
        v29[i - 1] = v27[i];
        local _ = i;
    end;

    return v28, v29;
end;

local function TeleportCharacter(p30: any, p31: userdata, p32: vector) -- Line: 179
    local Player = p30.GetModule("PlayerHandler").GetPlayer(p31);

    if not (Player and Player:IsAlive()) then
        p30.Reply(("%s has no alive character"):format(p31.Name), false);

        return;
    end;

    local Simulation = Player.Character.Simulation;
    Simulation.Position = p32;
    Simulation.Velocity = Vector3.new(0, 0, 0);
    Simulation.FallingVelocity = 0;
    p30.GetModule("Entities").MarkTeleported("Character", Player.Character.Identifier);
    p30.Reply(("%s -> %.1f, %.1f, %.1f"):format(p31.Name, p32.x, p32.y, p32.z), true);
end;

local function FormatDuration(p33: number) -- Line: 195
    local v34 = p33 // 86400;
    local v35 = p33 % 86400 // 3600;
    local v36 = p33 % 3600 // 60;

    if v34 > 0 then
        return ("%dd %dh"):format(v34, v35);
    end;

    if v35 > 0 then
        return ("%dh %dm"):format(v35, v36);
    end;

    return ("%dm"):format(v36);
end;

local function FormatDate(p37: number) -- Line: 209
    return os.date("!%Y-%m-%d %H:%M UTC", p37);
end;

local function FormatEnds(p38) -- Line: 213
    -- upvalues: FormatDuration (copy)
    if p38.Expires == 0 then
        return "never ends";
    end;

    local v39 = p38.Expires - os.time();

    if v39 <= 0 then
        return ("ended %s ago"):format(FormatDuration(-v39));
    end;

    return ("ends in %s"):format(FormatDuration(v39));
end;

local function FormatRewards(p40: any, p41: boolean?) -- Line: 227
    local v42 = {};

    for _, v in p40 do
        local v43 = v[1];
        local v44 = tostring(v[2]);
        table.insert(v42, ("%s %s"):format(v43, v44));
    end;

    return table.concat(v42, ", ") .. (p41 and " (tradelocked)" or "");
end;

u1.Commands = {
    {
        Name = "help",
        Description = "List of all commands",
        Usage = "help",
        Side = "Client",
        Role = nil,
        Aliases = { "cmds", "commands" },
        Args = {},

        Run = function(p45) -- Line: 253, Name: Run
            -- upvalues: Roles (copy)
            local Module = p45.GetModule("ConsoleShared");
            local Rank = Roles.GetRank(p45.Player and p45.Player.UserId);
            local v46 = p45.Player and p45.Player:GetAttribute("IsServerOwner") == true;
            local v47 = workspace:GetAttribute("sv_cheats") == true;
            p45.Reply("Commands:");

            for _, v in ipairs(Module.Commands) do
                if Module.CanPlayerRun(v, Rank, v46, v47) then
                    p45.Reply(("  %s  --  %s"):format(v.Usage or v.Name, v.Description or ""));
                end;
            end;
        end
    },
    {
        Name = "sv_cheats",
        Description = "Enable/disable cheats on the server",
        Usage = "sv_cheats <0|1>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "value",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p48) -- Line: 288, Name: Run
            local v49 = p48.Args[1];
            p48.GetModule("Whitelist"):SetCheats(v49);
            p48.Reply(("sv_cheats %s"):format(v49 and "1" or "0"), true);
        end
    },
    {
        Name = "AddServerOwner",
        Description = "Grant server-owner rights to a player (by name or UserId)",
        Usage = "AddServerOwner <player|userid>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            } },

        Run = function(p50) -- Line: 314, Name: Run
            local v51 = p50.Args[1];
            p50.GetModule("Whitelist"):AddOwner(v51.UserId);

            if v51.Player then
                p50.GetModule("Console").RefreshAccess(v51.Player);
            end;

            p50.Reply(("%s is now a server owner"):format(v51.Name), true);
        end
    },
    {
        Name = "kick",
        Description = "Kick a player (staff: name/UserId, any server; VIP owner: players here only)",
        Usage = "kick <player|userid> [reason]",
        Side = "Server",
        Role = "Moderator",
        AllowServerOwner = true,
        Aliases = { "boot" },
        Hints = {
            ["*"] = { "AFK", "Cheating", "Toxic", "Trolling" }
        },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false,
                AllowKeywords = false
            }, {
                Name = "reason",
                Type = "text",
                Optional = true
            } },

        Run = function(p52) -- Line: 348, Name: Run
            -- upvalues: Roles (copy)
            local u53 = p52.Args[1];
            local u54 = p52.Args[2];

            if p52.Player and u53.UserId == p52.Player.UserId then
                p52.Reply("You cant kick yourself", false);

                return;
            end;

            local v55 = Roles.GetRank(p52.Player and p52.Player.UserId) >= (Roles.Ranks.Moderator or 1);

            if not (v55 or u53.Player) then
                p52.Reply("server owners can only kick players in this server", false);

                return;
            end;

            local v56 = "Kicked from console";
            local v57;

            if u54 and u54 ~= "" then
                local TextService = game:GetService("TextService");
                local u58 = p52.Player and (p52.Player.UserId or 1) or 1;
                local success, result = pcall(function() -- Line: 371
                    -- upvalues: TextService (copy), u54 (copy), u58 (copy)
                    return TextService:FilterStringAsync(u54, u58);
                end);

                if success and result then
                    local v59;
                    v59, v57 = pcall(function() -- Line: 376
                        -- upvalues: result (copy), u53 (copy)
                        return result:GetNonChatStringForUserAsync(u53.UserId);
                    end);

                    if v59 and v57 then
                        if v57 == "" then
                            v57 = v56;
                        end;
                    else
                        v57 = v56;
                    end;
                else
                    v57 = v56;
                end;
            else
                v57 = v56;
            end;

            if not (v55 or game:GetService("Players"):GetPlayerByUserId(u53.UserId)) then
                p52.Reply("server owners can only kick players in this server", false);

                return;
            end;

            local Kick = p52.GetModule("KickManager").Kick;
            local v60, v61 = Kick(u53.UserId, v57, u53.Name, p52.Player and p52.Player.UserId);
            p52.Reply(v61, v60);
        end
    },
    {
        Name = "PlaceVersion",
        Description = "Print the place version",
        Usage = "PlaceVersion",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = {},

        Run = function(p62) -- Line: 413, Name: Run
            p62.Reply(("PlaceVersion: %d"):format(game.PlaceVersion));
        end
    },
    {
        Name = "gamepad_test",
        Description = "Run the controller navigation test suite",
        Usage = "gamepad_test",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        Args = {},

        Run = function(p63) -- Line: 428, Name: Run
            p63.GetModule("GamepadTests").Run(p63.Reply);
        end
    },
    {
        Name = "sv_arcade",
        Description = "Toggle developer/creator arcade visual and audio effects (outlines, damage numbers, hitmarkers, rainbow hud, hitsounds, combo meter, viewmodel outline, confetti)",
        Usage = "sv_arcade [all|outline|damage|hitmarker|rainbow|hitsound|combo|viewmodel|confetti|0|1] [0|1]",
        Side = "Client",
        Aliases = { "arcade" },
        Role = { "Developer", "Star" },
        Hints = {
            all = { "0", "1" },
            outline = { "0", "1" },
            damage = { "0", "1" },
            hitmarker = { "0", "1" },
            rainbow = { "0", "1" },
            hitsound = { "0", "1" },
            combo = { "0", "1" },
            viewmodel = { "0", "1" },
            confetti = { "0", "1" },
            ["0"] = {},
            ["1"] = {}
        },
        Args = { {
                Name = "feature",
                Type = "string",
                Optional = true
            }, {
                Name = "state",
                Type = "value",
                Optional = true
            } },

        Run = function(p64) -- Line: 458, Name: Run
            local Module = p64.GetModule("ArcadeEffects");

            if not Module then
                pcall(function() -- Line: 461
                    -- upvalues: Module (ref)
                    Module = require(game:GetService("ReplicatedStorage").ClientModules.ArcadeEffects);
                end);
            end;

            if not Module then
                p64.Reply("ArcadeEffects module not found", Color3.fromRGB(250, 0, 0));

                return;
            end;

            local v65, v66 = Module.HandleCommand(p64.Args);

            for i in (v65 .. "\n"):gmatch("([^\n]*)\n") do
                if i ~= "" then
                    p64.Reply(i, v66 and Color3.fromRGB(0, 250, 0) or Color3.fromRGB(250, 0, 0));
                end;
            end;
        end
    },
    {
        Name = "NetInterp",
        Description = "Interpolation / network debug stats",
        Usage = "NetInterp [0|1]",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p67) -- Line: 493, Name: Run
            local Module = p67.GetModule("ClientModule");
            local Module2 = p67.GetModule("Entities");

            if p67.Args[1] ~= nil then
                Module.SetNetworkDebugEnabled(p67.Args[1]);
            end;

            local NetworkDebugStats = Module.GetNetworkDebugStats();
            local InterpolationStats, v68 = Module2.GetInterpolationStats();
            p67.Reply(("interp: %s  headroom: %s"):format(tostring(InterpolationStats), (tostring(v68))));

            if typeof(NetworkDebugStats) == "table" then
                for i, v in NetworkDebugStats do
                    p67.Reply(("  %s = %s"):format(tostring(i), (tostring(v))));
                end;
            end;
        end
    },
    {
        Name = "net_graph",
        Description = "Draw network usage and performance data (0=off, 1=text, 2=detailed)",
        Usage = "net_graph [0|1|2]",
        Side = "Client",
        AllowServerOwner = true,
        AllowCheats = true,
        Aliases = { "netgraph" },
        Hints = { "0", "1", "2" },
        Args = { {
                Name = "mode",
                Type = "integer",
                Optional = true
            } },

        Run = function(p69) -- Line: 528, Name: Run
            local Module = p69.GetModule("Gui");

            if Module then
                Module = Module.GetComponent("NetGraph");
            end;

            local v70 = p69.Args[1];

            if v70 == nil then
                p69.Reply("net_graph: 0=off, 1=text, 2=detailed text");

                return;
            end;

            if Module then
                Module.SetMode(v70);
            end;

            p69.Reply(("net_graph = %d (%s)"):format(v70, v70 == 1 and "1: Text" or (v70 == 2 and "2: Detailed Text" or "Off")));
        end
    },
    {
        Name = "net_graphpos",
        Description = "Net graph position: 1=right, 2=center, 3=left",
        Usage = "net_graphpos [1|2|3]",
        Side = "Client",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "1", "2", "3" },
        Args = { {
                Name = "pos",
                Type = "integer",
                Optional = true
            } },

        Run = function(p71) -- Line: 556, Name: Run
            local Module = p71.GetModule("Gui");

            if Module then
                Module = Module.GetComponent("NetGraph");
            end;

            local v72 = p71.Args[1];

            if v72 == nil then
                p71.Reply("net_graphpos: 1=right, 2=center, 3=left");

                return;
            end;

            local v73 = v72 == 2 and "Center" or (v72 == 3 and "Left" or "Right");

            if Module then
                Module.SetAlignment(v73);
            end;

            p71.Reply(("net_graphpos = %d (%s)"):format(v72, v73));
        end
    },
    {
        Name = "net_graphheight",
        Description = "Height of net graph panel from bottom of screen in pixels",
        Usage = "net_graphheight <height>",
        Side = "Client",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "height",
                Type = "integer",
                Optional = false
            } },

        Run = function(p74) -- Line: 583, Name: Run
            local Module = p74.GetModule("Gui");

            if Module then
                Module = Module.GetComponent("NetGraph");
            end;

            local v75 = p74.Args[1];

            if Module and v75 then
                Module.SetPositionY(v75);
            end;

            p74.Reply(("net_graphheight = %d"):format(v75 or 0));
        end
    },
    {
        Name = "net_graphproportionalfont",
        Description = "Determines whether net graph font is proportional (1) or fixed (0)",
        Usage = "net_graphproportionalfont [0|1]",
        Side = "Client",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p76) -- Line: 606, Name: Run
            local Module = p76.GetModule("Gui");

            if Module then
                Module = Module.GetComponent("NetGraph");
            end;

            local v77 = p76.Args[1];

            if Module and v77 ~= nil then
                Module.SetProportionalFont(v77);
            end;

            p76.Reply(("net_graphproportionalfont = %s"):format((tostring(v77))));
        end
    },
    {
        Name = "cl_showpos",
        Description = "Toggle camera position and view angles (yaw, pitch) in net graph (0=off, 1=on)",
        Usage = "cl_showpos [0|1]",
        Side = "Client",
        AllowServerOwner = true,
        AllowCheats = true,
        Aliases = { "showpos" },
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p78) -- Line: 630, Name: Run
            local Module = p78.GetModule("Gui");

            if Module then
                Module = Module.GetComponent("NetGraph");
            end;

            local v79 = p78.Args[1];
            local v80 = v79 == nil and true or v79;

            if Module then
                Module.SetShowCameraInfo(v80);
            end;

            p78.Reply(("cl_showpos = %s"):format((tostring(v80))));
        end
    },
    {
        Name = "esp",
        Description = "Highlight other players through walls",
        Usage = "esp <0|1> [player]",
        Side = "Server",
        Role = "Developer",
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            }, {
                Name = "player",
                Type = "player",
                Optional = true
            } },

        Run = function(p81) -- Line: 657, Name: Run
            local v82 = p81.Args[2] or p81.Player;
            v82:SetAttribute("EspEnabled", p81.Args[1]);
            p81.Reply(("ESP %s for %s"):format(p81.Args[1] and "enabled" or "disabled", v82.Name), true);
        end
    },
    {
        Name = "ShowClips",
        Description = "Show invisible collision walls (clips)",
        Usage = "ShowClips <0|1>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p83) -- Line: 677, Name: Run
            p83.Reply(p83.GetModule("DebugVisualizers").SetClips(p83.Args[1]));
        end
    },
    {
        Name = "ClipColor",
        Description = "Clip highlight colour (R G B, 0-255)",
        Usage = "ClipColor <r> <g> <b>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = {
                ["*"] = { "0", "128", "255" }
            }
        },
        Args = { {
                Name = "r",
                Type = "integer",
                Optional = false
            }, {
                Name = "g",
                Type = "integer",
                Optional = false
            }, {
                Name = "b",
                Type = "integer",
                Optional = false
            } },

        Run = function(p84) -- Line: 697, Name: Run
            p84.Reply(p84.GetModule("DebugVisualizers").SetClipColor(p84.Args[1], p84.Args[2], p84.Args[3]));
        end
    },
    {
        Name = "ClipTransparency",
        Description = "Clip highlight transparency (0-1)",
        Usage = "ClipTransparency <0-1>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "0.25", "0.5", "0.75", "1" },
        Args = { {
                Name = "value",
                Type = "number",
                Optional = false
            } },

        Run = function(p85) -- Line: 715, Name: Run
            p85.Reply(p85.GetModule("DebugVisualizers").SetClipTransparency(p85.Args[1]));
        end
    },
    {
        Name = "ShowZones",
        Description = "Show zone volumes (BuyZones, Detects, Kill, Plants)",
        Usage = "ShowZones <0|1>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p86) -- Line: 733, Name: Run
            p86.Reply(p86.GetModule("DebugVisualizers").SetZones(p86.Args[1]));
        end
    },
    {
        Name = "ZoneColor",
        Description = "Zone highlight colour (R G B, 0-255)",
        Usage = "ZoneColor <r> <g> <b>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = {
                ["*"] = { "0", "128", "255" }
            }
        },
        Args = { {
                Name = "r",
                Type = "integer",
                Optional = false
            }, {
                Name = "g",
                Type = "integer",
                Optional = false
            }, {
                Name = "b",
                Type = "integer",
                Optional = false
            } },

        Run = function(p87) -- Line: 753, Name: Run
            p87.Reply(p87.GetModule("DebugVisualizers").SetZoneColor(p87.Args[1], p87.Args[2], p87.Args[3]));
        end
    },
    {
        Name = "ZoneTransparency",
        Description = "Zone highlight transparency (0-1)",
        Usage = "ZoneTransparency <0-1>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "0.25", "0.5", "0.75", "1" },
        Args = { {
                Name = "value",
                Type = "number",
                Optional = false
            } },

        Run = function(p88) -- Line: 771, Name: Run
            p88.Reply(p88.GetModule("DebugVisualizers").SetZoneTransparency(p88.Args[1]));
        end
    },
    {
        Name = "ShowSpawns",
        Description = "Show player spawn points (per team)",
        Usage = "ShowSpawns <0|1>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p89) -- Line: 789, Name: Run
            p89.Reply(p89.GetModule("DebugVisualizers").SetSpawns(p89.Args[1]));
        end
    },
    {
        Name = "+move",
        Description = "Test character movement on X/Z axis (-1, 0, 1)",
        Usage = "+move <x|z> <-1|0|1>",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        RequireCheats = true,
        Hints = {
            X = { "-1", "0", "1" },
            Z = { "-1", "0", "1" },
            x = { "-1", "0", "1" },
            z = { "-1", "0", "1" }
        },
        Args = { {
                Name = "axis",
                Type = "string",
                Optional = false
            }, {
                Name = "direction",
                Type = "integer",
                Optional = false
            } },

        Run = function(p90) -- Line: 814, Name: Run
            if workspace:GetAttribute("sv_cheats") ~= true then
                p90.Reply("sv_cheats must be 1 to use +move", false);

                return;
            end;

            local v91 = p90.Args[1];
            local v92 = typeof(v91) == "string" and (v91:upper() or "") or "";

            if v92 ~= "X" and v92 ~= "Z" then
                p90.Reply("invalid axis: expected X or Z", false);

                return;
            end;

            local v93 = p90.Args[2];

            if v93 ~= -1 and (v93 ~= 0 and v93 ~= 1) then
                p90.Reply("invalid value: expected -1, 0, or 1", false);

                return;
            end;

            local Module = p90.GetModule("CharacterInput");

            if not Module then
                p90.Reply("CharacterInput not found", false);

                return;
            end;

            Module.SetForcedMove(v92, v93);
            p90.Reply(("+move %s %d"):format(v92, v93), true);
        end
    },
    {
        Name = "-move",
        Description = "Stop test character movement on X/Z axis",
        Usage = "-move [x|z] [value]",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        RequireCheats = true,
        Hints = {
            X = { "0", "-1", "1" },
            Z = { "0", "-1", "1" },
            x = { "0", "-1", "1" },
            z = { "0", "-1", "1" }
        },
        Args = { {
                Name = "axis",
                Type = "string",
                Optional = true
            }, {
                Name = "direction",
                Type = "integer",
                Optional = true
            } },

        Run = function(p94) -- Line: 864, Name: Run
            if workspace:GetAttribute("sv_cheats") ~= true then
                p94.Reply("sv_cheats must be 1 to use -move", false);

                return;
            end;

            local Module = p94.GetModule("CharacterInput");

            if not Module then
                p94.Reply("CharacterInput not found", false);

                return;
            end;

            local v95 = p94.Args[1];

            if not v95 then
                Module.ResetForcedMove();
                p94.Reply("-move (X=0, Z=0)", true);

                return;
            end;

            local v96 = typeof(v95) == "string" and (v95:upper() or "") or "";

            if v96 ~= "X" and v96 ~= "Z" then
                p94.Reply("invalid axis: expected X or Z", false);

                return;
            end;

            local v97 = p94.Args[2] or 0;

            if v97 ~= -1 and (v97 ~= 0 and v97 ~= 1) then
                p94.Reply("invalid value: expected -1, 0, or 1", false);

                return;
            end;

            Module.SetForcedMove(v96, v97);
            p94.Reply(("-move %s %d"):format(v96, v97), true);
        end
    },
    {
        Name = "autowalk",
        Description = "Walk back and forth automatically, reversing direction when hitting a wall (0=off, 1=on)",
        Usage = "autowalk [0|1] [x|z]",
        Side = "Client",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        RequireCheats = true,
        Aliases = { "pingpong", "walkbot", "patrol", "bot_walk" },
        Hints = {
            ["0"] = {},
            ["1"] = { "z", "x" }
        },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = true
            }, {
                Name = "axis",
                Type = "string",
                Optional = true
            } },

        Run = function(p98) -- Line: 919, Name: Run
            if workspace:GetAttribute("sv_cheats") ~= true then
                p98.Reply("sv_cheats must be 1 to use autowalk", false);

                return;
            end;

            local Module = p98.GetModule("CharacterInput");

            if not Module then
                p98.Reply("CharacterInput not found", false);

                return;
            end;

            local v99 = p98.Args[1];
            local v100 = p98.Args[2];
            local v101;

            if typeof(v100) == "string" then
                v101 = v100:upper() or nil;
            else
                v101 = nil;
            end;

            if v99 == nil then
                v99 = Module.ToggleAutoWalk(nil, v101);
            else
                Module.SetAutoWalk(v99, nil, v101);
            end;

            local _, v102, v103 = Module.GetAutoWalk();

            if v99 then
                p98.Reply(("autowalk on (axis=%s, dir=%d)"):format(v103, v102), true);

                return;
            end;

            p98.Reply("autowalk off", true);
        end
    },
    {
        Name = "ShowImpacts",
        Description = "Show bullet impact points (client + server)",
        Usage = "ShowImpacts <0|1>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p104) -- Line: 969, Name: Run
            local v105, v106 = p104.GetModule("ShotDebug").SetImpacts(p104.Player, p104.Args[1]);
            p104.Reply(v106, v105);
        end
    },
    {
        Name = "ShowServerShots",
        Description = "Show server hitmarkers + lag-compensated positions",
        Usage = "ShowServerShots <0|1>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p107) -- Line: 988, Name: Run
            local v108, v109 = p107.GetModule("ShotDebug").SetServerShots(p107.Player, p107.Args[1]);
            p107.Reply(v109, v108);
        end
    },
    {
        Name = "kill",
        Description = "Kill a player\'s character",
        Usage = "kill <player>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            } },

        Run = function(p110) -- Line: 1006, Name: Run
            local Player = p110.GetModule("PlayerHandler").GetPlayer(p110.Args[1]);

            if not (Player and Player:IsAlive()) then
                p110.Reply("target has no alive character", false);

                return;
            end;

            local Character = Player.Character;
            p110.GetModule("HitPoints").TakeDamage(Character, {
                DespawnTick = true,
                DamageType = "FallDamage",
                IgnoreSpawnProtection = true,
                Amount = Character.Health
            });
            p110.Reply(("%s killed"):format(p110.Args[1].Name), true);
        end
    },
    {
        Name = "Respawn",
        Description = "Respawn a player",
        Usage = "Respawn <player>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            } },

        Run = function(p111) -- Line: 1036, Name: Run
            local Player = p111.GetModule("PlayerHandler").GetPlayer(p111.Args[1]);

            if not Player then
                p111.Reply("player not found", false);

                return;
            end;

            if not Player:CreateCharacter() then
                p111.Reply("no spawn available for that team", false);

                return;
            end;

            p111.GetModule("WeaponHandler").GiveLoadoutWeapons(Player.Character);
            p111.Reply(("%s respawned"):format(p111.Args[1].Name), true);
        end
    },
    {
        Name = "SetPlayerTeam",
        Description = "Move a player to a team (respawns them if they were alive)",
        Usage = "SetPlayerTeam <player> <CT|T|Spectator>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = { "CT", "T", "Spectator" }
        },
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "team",
                Type = "string",
                Optional = false
            } },

        Run = function(p112) -- Line: 1070, Name: Run
            local v113 = ({
                ct = "CT",
                t = "T",
                spectator = "Spectator",
                spec = "Spectator"
            })[p112.Args[2]:lower()];

            if not v113 then
                p112.Reply("team must be CT, T or Spectator", false);

                return;
            end;

            local Player = p112.GetModule("PlayerHandler").GetPlayer(p112.Args[1]);

            if not Player then
                p112.Reply("player not found", false);

                return;
            end;

            local v114 = Player:IsAlive();
            Player:SetTeam(v113);

            if v114 and (v113 ~= "Spectator" and Player:CreateCharacter()) then
                p112.GetModule("WeaponHandler").GiveLoadoutWeapons(Player.Character);
            end;

            p112.Reply(("%s -> %s"):format(p112.Args[1].Name, v113), true);
        end
    },
    {
        Name = "Teleport",
        Description = "Teleport a player to coordinates",
        Usage = "Teleport <player> <x,y,z>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Aliases = { "tp" },
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "position",
                Type = "vector",
                Optional = false
            } },

        Run = function(p115) -- Line: 1109, Name: Run
            -- upvalues: TeleportCharacter (copy)
            local v116 = p115.Args[2];
            TeleportCharacter(p115, p115.Args[1], (vector.create(v116.X, v116.Y, v116.Z)));
        end
    },
    {
        Name = "TeleportTarget",
        Description = "Teleport a player to a spawn, another player, a map zone, or where you look",
        Usage = "TeleportTarget <player> <spawn|ct|t|look|player|zone>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Aliases = { "tpt" },
        Hints = {
            ["*"] = { "spawn", "ct", "t", "look" }
        },
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "destination",
                Type = "string",
                Optional = false
            } },

        Run = function(p117) -- Line: 1130, Name: Run
            -- upvalues: TeleportCharacter (copy)
            local v118 = p117.Args[1];
            local v119 = p117.Args[2];
            local v120 = v119:lower();
            local Module = p117.GetModule("PlayerHandler");

            if v120 ~= "look" and v120 ~= "camera" then
                if v120 == "spawn" or (v120 == "ct" or v120 == "t") then
                    local v121 = v120 == "spawn" and v118:GetAttribute("Team") or v119:upper();
                    local ChooseRandomSpawn = p117.GetModule("GameHandler").CurrentGamemode.ChooseRandomSpawn;
                    local success, result = pcall(ChooseRandomSpawn, v121);

                    if success then
                        TeleportCharacter(p117, v118, result);

                        return;
                    end;

                    p117.Reply(tostring(result):gsub("^.+:%d+:%s*", ""), false);

                    return;
                end;

                local v122 = p117.ResolvePlayer(v119);

                if typeof(v122) == "Instance" then
                    local Player = Module.GetPlayer(v122);

                    if Player and Player:IsAlive() then
                        TeleportCharacter(p117, v118, Player.Character.Simulation.Position);

                        return;
                    end;

                    p117.Reply(("%s has no alive character"):format(v122.Name), false);

                    return;
                end;

                local Map = workspace:FindFirstChild("Map");

                for _, v in { "Zones", "Spawns" } do
                    local v123;

                    if Map then
                        v123 = Map:FindFirstChild(v);
                    else
                        v123 = Map;
                    end;

                    if v123 then
                        v123 = v123:FindFirstChild(v119, true);
                    end;

                    if v123 and v123:IsA("BasePart") then
                        local Position = v123.Position;
                        TeleportCharacter(p117, v118, (vector.create(Position.X, Position.Y, Position.Z)));

                        return;
                    end;
                end;

                p117.Reply(("unknown destination: %s"):format(v119), false);

                return;
            end;

            local Player = Module.GetPlayer(p117.Player);

            if not (Player and Player:IsAlive()) then
                p117.Reply("look needs you to be alive", false);

                return;
            end;

            local Map = workspace:FindFirstChild("Map");

            if not Map then
                p117.Reply("no map loaded", false);

                return;
            end;

            local v124 = {};

            for _, child in Map:GetChildren() do
                if child.Name ~= "Zones" and child.Name ~= "Spawns" then
                    table.insert(v124, child);
                end;
            end;

            local RaycastParams_new_ret = RaycastParams.new();
            RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
            RaycastParams_new_ret.FilterDescendantsInstances = v124;
            local Simulation = Player.Character.Simulation;
            local v125 = Simulation.Position + vector.create(0, Simulation.CameraOffset + Simulation.Height, 0);
            local LookVector = CFrame.fromEulerAnglesYXZ(-Simulation.Pitch, Simulation.Yaw, 0).LookVector;
            local v126 = workspace:Raycast(v125, LookVector * 2000, RaycastParams_new_ret);

            if not v126 then
                p117.Reply("not looking at anything", false);

                return;
            end;

            local v127 = v126.Position + v126.Normal * 1.1 + Vector3.new(0, 2.6, 0);
            TeleportCharacter(p117, v118, (vector.create(v127.X, v127.Y, v127.Z)));
        end
    },
    {
        Name = "bot_add",
        Description = "Add a bot with explicit team, difficulty, name and weapon preference",
        Usage = "bot_add [ct|t] [easy|normal|hard|expert|extreme] [name] [rifle|smg|sniper|shotgun|pistol] [amount]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "team",
                Type = "string",
                Optional = true
            }, {
                Name = "difficulty",
                Type = "string",
                Optional = true
            }, {
                Name = "name",
                Type = "string",
                Optional = true
            }, {
                Name = "weapon",
                Type = "string",
                Optional = true
            }, {
                Name = "amount",
                Type = "integer",
                Optional = true
            } },

        Run = function(p128) -- Line: 1231, Name: Run
            local v129 = p128.Args[1];
            local v130 = p128.Args[2];
            local v131 = p128.Args[3];
            local v132 = p128.Args[4];
            local v133 = p128.Args[5] or 1;
            local v134 = {
                ct = "CT",
                t = "T",
                any = false
            };
            local v135 = {
                easy = 0,
                normal = 1,
                hard = 2,
                expert = 3,
                extreme = 4,
                ["0"] = 0,
                ["1"] = 1,
                ["2"] = 2,
                ["3"] = 3,
                ["4"] = 4
            };
            local v136 = {
                rifle = true,
                smg = true,
                sniper = true,
                shotgun = true,
                pistol = true
            };
            local v137;

            if v129 then
                v137 = v134[v129:lower()];
            else
                v137 = v129;
            end;

            if v129 and v137 == nil then
                p128.Reply("team must be ct, t or any", false);

                return;
            end;

            local v138 = v135[(v130 or "normal"):lower()];

            if v138 == nil then
                p128.Reply("difficulty must be easy, normal, hard, expert or extreme", false);

                return;
            end;

            if v132 and not v136[v132:lower()] then
                p128.Reply("weapon must be rifle, smg, sniper, shotgun or pistol", false);

                return;
            end;

            if v133 < 1 then
                p128.Reply("amount must be at least 1", false);

                return;
            end;

            local Module = p128.GetModule("BotManager");

            for i = 1, v133 do
                local Add = Module.Add;
                local v139;

                if v133 > 1 and v131 then
                    v139 = v131 .. " " .. i or v131;
                else
                    v139 = v131;
                end;

                local v140;

                if v132 then
                    v140 = v132:lower();
                else
                    v140 = v132;
                end;

                Add(v137 or nil, v138, v139, v140);
                local _ = i;
            end;

            p128.Reply(("added %d bot(s)"):format(v133), true);
        end
    },
    {
        Name = "bot_add_difficulty",
        Description = "Add a bot of the given difficulty to the smaller team",
        Usage = "bot_add_difficulty <easy|normal|hard|expert|extreme> [amount]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "difficulty",
                Type = "string",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = true
            } },

        Run = function(p141) -- Line: 1280, Name: Run
            local v142 = ({
                easy = 0,
                normal = 1,
                hard = 2,
                expert = 3,
                extreme = 4
            })[p141.Args[1]:lower()];

            if v142 == nil then
                p141.Reply("difficulty must be easy, normal, hard, expert or extreme", false);

                return;
            end;

            local v143 = p141.Args[2] or 1;

            if v143 < 1 then
                p141.Reply("amount must be at least 1", false);

                return;
            end;

            local Module = p141.GetModule("BotManager");

            for i = 1, v143 do
                Module.Add(nil, v142);
                local _ = i;
            end;

            p141.Reply(("added %d bot(s)"):format(v143), true);
        end
    },
    {
        Name = "bot_kick",
        Description = "Remove a bot by name, or all bots",
        Usage = "bot_kick [name|all]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "name",
                Type = "text",
                Optional = true
            } },

        Run = function(p144) -- Line: 1313, Name: Run
            local v145 = p144.GetModule("BotManager").Kick(p144.Args[1] or "all");
            p144.Reply(("removed %d bot(s)"):format(v145), v145 > 0);
        end
    },
    {
        Name = "bot_stop",
        Description = "Freeze all bots or resume their AI",
        Usage = "bot_stop [0|1]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = { "0", "1" }
        },
        Args = { {
                Name = "state",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p146) -- Line: 1332, Name: Run
            local v147 = p146.Args[1] ~= false;
            p146.GetModule("BotManager").Stop(v147);
            p146.Reply(v147 and "bots frozen" or "bots resumed", true);
        end
    },
    {
        Name = "bot_place",
        Description = "Teleport the nearest living bot, or a named bot, where you look",
        Usage = "bot_place [name]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "name",
                Type = "text",
                Optional = true
            } },

        Run = function(p148) -- Line: 1351, Name: Run
            -- upvalues: u1 (copy)
            local Module = p148.GetModule("PlayerHandler");
            local Player = Module.GetPlayer(p148.Player);

            if not (Player and Player:IsAlive()) then
                p148.Reply("bot_place needs you to be alive", false);

                return;
            end;

            local v149 = p148.Args[1] and p148.Args[1]:lower();
            local v150 = (1 / 0);
            local v151 = nil;

            for i, v in Module.GetPlayers() do
                if v.IsBot and v:IsAlive() then
                    local v152 = i.Name:lower();

                    if not (v149 and (v152 ~= v149 and v152 ~= "bot " .. v149)) then
                        local vector_magnitude_ret = vector.magnitude(v.Character.Simulation.Position - Player.Character.Simulation.Position);

                        if vector_magnitude_ret < v150 then
                            v151 = i;
                            v150 = vector_magnitude_ret;
                        end;
                    end;
                end;
            end;

            if not v151 then
                p148.Reply(v149 and "no living bot with that name" or "no living bots", false);

                return;
            end;

            local table_clone_ret = table.clone(p148);
            table_clone_ret.Args = { v151, "look" };
            u1.Get("TeleportTarget").Run(table_clone_ret);
        end
    },
    {
        Name = "Noclip",
        Description = "Toggle noclip (fly through geometry) on a player",
        Usage = "Noclip [player] [0|1]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = { "0", "1" }
        },
        Args = { {
                Name = "player",
                Type = "player",
                Optional = true
            }, {
                Name = "state",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p153) -- Line: 1400, Name: Run
            local v154 = p153.Args[1] or p153.Player;
            local Player = p153.GetModule("PlayerHandler").GetPlayer(v154);

            if not (Player and Player:IsAlive()) then
                p153.Reply("target has no alive character", false);

                return;
            end;

            local v155;

            if Player.Character.Simulation then
                v155 = Player.Character.Simulation.Noclip or false;
            else
                v155 = false;
            end;

            local v156;

            if p153.Args[2] == nil then
                v156 = not v155;
            else
                v156 = p153.Args[2] or not v155;
            end;

            Player.Character:SetSimulationProperty("Noclip", v156);
            p153.Reply(("%s noclip %s"):format(v154.Name, v156 and "on" or "off"), true);
        end
    },
    {
        Name = "Freeze",
        Description = "Freeze/unfreeze a player\'s movement",
        Usage = "Freeze <player> <0|1>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = { "0", "1" }
        },
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "state",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p157) -- Line: 1430, Name: Run
            local Player = p157.GetModule("PlayerHandler").GetPlayer(p157.Args[1]);

            if not (Player and Player:IsAlive()) then
                p157.Reply("target has no alive character", false);

                return;
            end;

            Player.Character:SetSimulationProperty("Frozen", p157.Args[2]);
            p157.Reply(("%s frozen %s"):format(p157.Args[1].Name, p157.Args[2] and "on" or "off"), true);
        end
    },
    {
        Name = "Invisible",
        Description = "Make a player invisible/visible",
        Usage = "Invisible <player> <0|1>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = { "0", "1" }
        },
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "state",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p158) -- Line: 1456, Name: Run
            local Player = p158.GetModule("PlayerHandler").GetPlayer(p158.Args[1]);

            if not (Player and Player:IsAlive()) then
                p158.Reply("target has no alive character", false);

                return;
            end;

            local v159 = p158.Args[2] and 1 or 0;

            for _, descendant in Player.Character.Model:GetDescendants() do
                if descendant:IsA("BasePart") and (descendant.Name ~= "CollisionBox" and descendant.Name ~= "HumanoidRootPart") then
                    descendant.Transparency = v159;
                end;
            end;

            p158.Reply(("%s invisible %s"):format(p158.Args[1].Name, p158.Args[2] and "on" or "off"), true);
        end
    },
    {
        Name = "CharacterProperty",
        Description = "Set a character property (Health, MaxHealth, Armor, Helmet, ...)",
        Usage = "CharacterProperty <player> <property> <value>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = {
            ["*"] = {
                Health = { "100", "50", "1" },
                MaxHealth = { "100", "150", "200" },
                Armor = { "100", "50", "0" },
                Helmet = { "0", "1" },
                DefuseKit = { "0", "1" }
            }
        },
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "property",
                Type = "string",
                Optional = false
            }, {
                Name = "value",
                Type = "string",
                Optional = false
            } },

        Run = function(p160) -- Line: 1488, Name: Run
            local v161 = p160.Args[1];
            local v162 = p160.Args[2];
            local v163 = p160.Args[3];
            local Player = p160.GetModule("PlayerHandler").GetPlayer(v161);

            if not (Player and Player:IsAlive()) then
                p160.Reply("target has no alive character", false);

                return;
            end;

            local Character = Player.Character;
            local Simulation = Character.Simulation;
            local v164 = v162:lower();
            local v165 = tonumber(v163);
            local v166 = v163 == "1" and true or v163:lower() == "true";

            if v164 == "health" or v164 == "hp" then
                if not v165 then
                    p160.Reply("value must be a number", false);

                    return;
                end;

                p160.GetModule("HitPoints").SetHP(Character, v165);
            elseif v164 == "maxhealth" then
                if not v165 then
                    p160.Reply("value must be a number", false);

                    return;
                end;

                Character.MaxHealth = v165;
                v161:SetAttribute("MaxHealth", v165);
            elseif v164 == "armor" then
                if not v165 then
                    p160.Reply("value must be a number", false);

                    return;
                end;

                Simulation:SetArmorValue(v161, v165);
            elseif v164 == "helmet" then
                Simulation:SetHasHelmet(v161, v166);
            elseif v164 == "defusekit" then
                Simulation:SetDefuseKit(v161, v166);
            else
                if not v165 then
                    if v163 == "true" then
                        v165 = true;
                    else
                        local _ = v163 == "false";
                        v165 = v163;
                    end;
                end;

                v161:SetAttribute(v162, v165);
            end;

            p160.Reply(("%s.%s = %s"):format(v161.Name, v162, v163), true);
        end
    },
    {
        Name = "SimulationConstant",
        Description = "Set a movement simulation constant on a player (number/vector/table)",
        Usage = "SimulationConstant <player> <property> <value>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "property",
                Type = "string",
                Optional = false
            }, {
                Name = "value",
                Type = "value",
                Optional = false
            } },

        Run = function(p167) -- Line: 1542, Name: Run
            local v168 = p167.Args[1];
            local v169 = p167.Args[2];
            local v170 = p167.Args[3];
            local Player = p167.GetModule("PlayerHandler").GetPlayer(v168);

            if not (Player and Player:IsAlive()) then
                p167.Reply("target has no alive character", false);

                return;
            end;

            local Constants = Player.Character.Simulation.Constants;

            if Constants[v169] == nil then
                p167.Reply(("unknown constant: %s"):format(v169), false);

                return;
            end;

            Constants[v169] = v170;
            p167.GetModule("Network").Character.CharacterConstantBalls.Fire(v168, {
                Key = v169,
                Value = p167.GetModule("ValueCodec").Encode(v170)
            });
            p167.Reply(("%s.Constants.%s = %s"):format(v168.Name, v169, (tostring(v170))), true);
        end
    },
    {
        Name = "WeaponConstant",
        Description = "Set a weapon Data constant on a player\'s weapon (number/vector/table)",
        Usage = "WeaponConstant <player> <constant> <value> [AllInventory]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "constant",
                Type = "string",
                Optional = false
            }, {
                Name = "value",
                Type = "value",
                Optional = false
            }, {
                Name = "allinventory",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p171) -- Line: 1591, Name: Run
            local v172 = p171.Args[1];
            local u173 = p171.Args[2];
            local u174 = p171.Args[3];
            local v175 = p171.Args[4] == true;
            local Player = p171.GetModule("PlayerHandler").GetPlayer(v172);

            if not (Player and Player:IsAlive()) then
                p171.Reply("target has no alive character", false);

                return;
            end;

            local Character = Player.Character;
            local Module = p171.GetModule("Network");
            local v176 = p171.GetModule("ValueCodec").Encode(u174);

            local function Patch(p177) -- Line: 1607
                -- upvalues: u173 (copy), u174 (copy)
                if not (p177 and (p177.Data and p177.Data[u173] ~= nil)) then
                    return false;
                end;

                p177.Data[u173] = u174;
                p177.PacketDirty = true;

                return true;
            end;

            if v175 then
                local v178 = 0;

                for _, v in Character.WeaponInventory do
                    local v179;

                    if v and (v.Data and v.Data[u173] ~= nil) then
                        v.Data[u173] = u174;
                        v.PacketDirty = true;
                        v179 = true;
                    else
                        v179 = false;
                    end;

                    if v179 then
                        v178 = v178 + 1;
                    end;
                end;

                if v178 == 0 then
                    p171.Reply(("no weapon has constant \'%s\'"):format(u173), false);

                    return;
                end;

                if Module.Weapon and Module.Weapon.Constant then
                    Module.Weapon.Constant.Fire(v172, {
                        Slot = 0,
                        All = true,
                        Key = u173,
                        Value = v176
                    });
                end;

                p171.Reply(("%s: %s = %s on %d weapon(s)"):format(v172.Name, u173, tostring(u174), v178), true);

                return;
            end;

            local CurrentWeapon = Character.CurrentWeapon;
            local v180;

            if CurrentWeapon and (CurrentWeapon.Data and CurrentWeapon.Data[u173] ~= nil) then
                CurrentWeapon.Data[u173] = u174;
                CurrentWeapon.PacketDirty = true;
                v180 = true;
            else
                v180 = false;
            end;

            if not v180 then
                p171.Reply(("equipped weapon has no constant \'%s\'"):format(u173), false);

                return;
            end;

            if Module.Weapon and Module.Weapon.Constant then
                Module.Weapon.Constant.Fire(v172, {
                    All = false,
                    Slot = CurrentWeapon.Slot,
                    Key = u173,
                    Value = v176
                });
            end;

            p171.Reply(("%s.%s.%s = %s"):format(v172.Name, CurrentWeapon.Name, u173, (tostring(u174))), true);
        end
    },
    {
        Name = "TemplateSimulationConstant",
        Description = "Set a simulation constant for EVERYONE (alive + future spawns, whole session)",
        Usage = "TemplateSimulationConstant <constant> <value>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "constant",
                Type = "string",
                Optional = false
            }, {
                Name = "value",
                Type = "value",
                Optional = false
            } },

        Run = function(p181) -- Line: 1660, Name: Run
            local v182 = p181.Args[1];
            local v183 = p181.Args[2];

            if require(game:GetService("ReplicatedStorage").Shared.Simulation.Config).ConstantsTemplate[v182] == nil then
                p181.Reply(("unknown constant: %s"):format(v182), false);

                return;
            end;

            p181.GetModule("TemplateOverrides").SetSimulation(v182, v183);
            local v184 = 0;

            for _, v in p181.GetModule("PlayerHandler").GetPlayers() do
                if v:IsAlive() then
                    local Constants = v.Character.Simulation.Constants;

                    if Constants[v182] ~= nil then
                        Constants[v182] = v183;
                        v184 = v184 + 1;
                    end;
                end;
            end;

            p181.Reply(("template %s = %s (%d alive updated)"):format(v182, tostring(v183), v184), true);
        end
    },
    {
        Name = "TemplateWeaponConstant",
        Description = "Set a weapon Data constant for EVERYONE (alive + future, whole session)",
        Usage = "TemplateWeaponConstant <weapon> <constant> <value>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "weapon",
                Type = "string",
                Optional = false
            }, {
                Name = "constant",
                Type = "string",
                Optional = false
            }, {
                Name = "value",
                Type = "value",
                Optional = false
            } },

        Run = function(p185) -- Line: 1704, Name: Run
            local v186 = p185.Args[1];
            local v187 = p185.Args[2];
            local v188 = p185.Args[3];
            local v189 = p185.GetModule("WeaponManager").Get(v186);

            if not v189 then
                p185.Reply(("unknown weapon: %s"):format(v186), false);

                return;
            end;

            if v189.Data[v187] == nil then
                p185.Reply(("%s has no constant \'%s\'"):format(v186, v187), false);

                return;
            end;

            p185.GetModule("TemplateOverrides").SetWeapon(v186, v187, v188);
            local v190 = 0;

            for _, v in p185.GetModule("PlayerHandler").GetPlayers() do
                if v:IsAlive() then
                    for _, v2 in v.Character.WeaponInventory do
                        if v2.Name == v186 and v2.Data[v187] ~= nil then
                            v2.Data[v187] = v188;
                            v2.PacketDirty = true;
                            v190 = v190 + 1;
                        end;
                    end;
                end;
            end;

            p185.Reply(("template %s.%s = %s (%d held updated)"):format(v186, v187, tostring(v188), v190), true);
        end
    },
    {
        Name = "TemplateReset",
        Description = "Clear template overrides (Simulation | Weapons | all)",
        Usage = "TemplateReset <Simulation|Weapons|all>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "all", "Simulation", "Weapons" },
        Args = { {
                Name = "which",
                Type = "string",
                Optional = true
            } },

        Run = function(p191) -- Line: 1753, Name: Run
            local v192 = (p191.Args[1] or "all"):lower();
            local Module = p191.GetModule("TemplateOverrides");

            if v192 == "simulation" or v192 == "all" then
                Module.ResetSimulation();
            end;

            if v192 == "weapons" or v192 == "all" then
                Module.ResetWeapons();
            end;

            p191.Reply(("template overrides reset (%s) -- respawn for full effect"):format(v192), true);
        end
    },
    {
        Name = "Config",
        Description = "Set a GameConfiguration value",
        Usage = "Config <category> <name> <value>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "category",
                Type = "string",
                Optional = false
            }, {
                Name = "name",
                Type = "string",
                Optional = false
            }, {
                Name = "value",
                Type = "string",
                Optional = false
            } },

        Run = function(p193) -- Line: 1782, Name: Run
            local v194, v195 = p193.GetModule("GameConfiguration").Set(p193.Args[1], p193.Args[2], p193.Args[3]);

            if v194 then
                p193.Reply(("Config %s.%s = %s"):format(p193.Args[1], p193.Args[2], p193.Args[3]), true);

                return;
            end;

            p193.Reply(("Config failed: %s"):format((tostring(v195))), false);
        end
    },
    {
        Name = "fow_status",
        Description = "Fog of war: state, leaks, parity and cost",
        Usage = "fow_status [leaks|reset|parity|bench] [count]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "leaks", "reset", "parity", "bench" },
        Args = { {
                Name = "mode",
                Type = "string",
                Optional = true
            }, {
                Name = "count",
                Type = "integer",
                Optional = true
            } },

        Run = function(u196) -- Line: 1831, Name: Run
            local Module = u196.GetModule("FOWWorker");

            if not Module then
                u196.Reply("FOW is not installed on this server", false);

                return;
            end;

            local function ReplyLines(p197: string, p198: boolean) -- Line: 1839
                -- upvalues: u196 (copy)
                for i in (p197 .. "\n"):gmatch("([^\n]*)\n") do
                    u196.Reply(i, p198);
                end;
            end;

            local v199;

            if u196.Args[1] then
                v199 = u196.Args[1]:lower() or nil;
            else
                v199 = nil;
            end;

            if v199 == "reset" then
                Module.ClearDiagnostics();
                u196.Reply("fow: leak counters and stale reads zeroed (the matrix is untouched)", true);

                return;
            end;

            if v199 == "parity" then
                local v200, v201 = Module.ArmParity();
                u196.Reply(("fow: %s"):format(v201), v200);

                return;
            end;

            if v199 == "leaks" then
                local v202 = Module.RecentLeaks();

                if #v202 == 0 then
                    u196.Reply("fow: no reveals recorded since the last reset", true);

                    return;
                end;

                for _, v in v202 do
                    for i in (Module.LeakText(v) .. "\n"):gmatch("([^\n]*)\n") do
                        u196.Reply(i, true);
                    end;
                end;

                return;
            end;

            if v199 ~= "bench" then
                if v199 == nil then
                    for i in (Module.StatusText() .. "\n"):gmatch("([^\n]*)\n") do
                        u196.Reply(i, true);
                    end;

                    return;
                end;

                u196.Reply(("fow_status: unknown mode %q (leaks, reset, parity, bench)"):format(v199), false);

                return;
            end;

            local v203, v204 = Module.Bench(u196.Args[2] or 25);

            if v203 then
                for i in (Module.BenchText(v203) .. "\n"):gmatch("([^\n]*)\n") do
                    u196.Reply(i, true);
                end;

                return;
            end;

            u196.Reply(("fow bench: %s"):format((tostring(v204))), false);
        end
    },
    {
        Name = "Restart",
        Description = "Restart the match",
        Usage = "Restart",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = {},

        Run = function(p205) -- Line: 1898, Name: Run
            local v206, v207 = p205.GetModule("GameHandler").RestartMatch();
            p205.Reply(v206 and "match restarting" or tostring(v207), v206);
        end
    },
    {
        Name = "EndState",
        Description = "End the current match state early",
        Usage = "EndState",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = {},

        Run = function(p208) -- Line: 1914, Name: Run
            local v209, v210 = p208.GetModule("GameHandler").EndCurrentState();
            p208.Reply(v209 and "state ended" or tostring(v210), v209);
        end
    },
    {
        Name = "SetState",
        Description = "Force a match state (Enums.RoundStates)",
        Usage = "SetState <state>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "Warmup", "Preparation", "RoundTime", "RoundEnded", "MatchEnded", "BombPlanted", "BombDefused", "BombExploded", "Restart" },
        Args = { {
                Name = "state",
                Type = "string",
                Optional = false
            } },

        Run = function(p211) -- Line: 1933, Name: Run
            local v212, v213 = p211.GetModule("GameHandler").SetState(p211.Args[1]);
            p211.Reply(v212 and ("state -> %s"):format(p211.Args[1]) or tostring(v213), v212);
        end
    },
    {
        Name = "SetTime",
        Description = "Set the remaining time of the current state",
        Usage = "SetTime <seconds>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "5", "10", "15", "30", "60", "120" },
        Args = { {
                Name = "seconds",
                Type = "integer",
                Optional = false
            } },

        Run = function(p214) -- Line: 1952, Name: Run
            local v215, v216 = p214.GetModule("GameHandler").SetTime(p214.Args[1]);
            p214.Reply(v215 and ("time -> %d"):format(p214.Args[1]) or tostring(v216), v215);
        end
    },
    {
        Name = "SetScore",
        Description = "Set the round win score of a team",
        Usage = "SetScore <team> <amount>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "CT", "T" },
        Args = { {
                Name = "team",
                Type = "string",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = false
            } },

        Run = function(p217) -- Line: 1972, Name: Run
            local v218, v219 = p217.GetModule("GameHandler").SetScore(p217.Args[1], p217.Args[2]);
            p217.Reply(v218 and ("%s -> %d"):format(p217.Args[1], p217.Args[2]) or tostring(v219), v218);
        end
    },
    {
        Name = "SetSubTime",
        Description = "Set the sub-state timer (buy time etc.)",
        Usage = "SetSubTime <seconds>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "5", "10", "15", "20", "30" },
        Args = { {
                Name = "seconds",
                Type = "integer",
                Optional = false
            } },

        Run = function(p220) -- Line: 1991, Name: Run
            local v221, v222 = p220.GetModule("GameHandler").SetSubTime(p220.Args[1]);
            p220.Reply(v221 and ("subtime -> %d"):format(p220.Args[1]) or tostring(v222), v221);
        end
    },
    {
        Name = "ChangeMap",
        Description = "Change the map (RestartGame true also resets the score)",
        Usage = "ChangeMap <map> [restartgame]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "map",
                Type = "string",
                Optional = false
            }, {
                Name = "restartgame",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p223) -- Line: 2011, Name: Run
            local v224, v225 = p223.GetModule("GameHandler").ChangeMap(p223.Args[1], p223.Args[2] == true);
            p223.Reply(v224 and ("map -> %s"):format(p223.Args[1]) or tostring(v225), v224);
        end
    },
    {
        Name = "Gamemode",
        Description = "Change the gamemode",
        Usage = "Gamemode <name>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "Casual" },
        Args = { {
                Name = "name",
                Type = "string",
                Optional = false
            } },

        Run = function(p226) -- Line: 2031, Name: Run
            local v227, v228 = p226.GetModule("GameHandler").SetGamemode(p226.Args[1]);
            p226.Reply(v227 and ("gamemode -> %s"):format(p226.Args[1]) or tostring(v228), v227);
        end
    },
    {
        Name = "AddWeapon",
        Description = "Give a weapon to a player (skin optional, default stock)",
        Usage = "AddWeapon <player> <weapon> [skin]",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "weapon",
                Type = "string",
                Optional = false
            }, {
                Name = "skin",
                Type = "text",
                Optional = true
            } },

        Run = function(p229) -- Line: 2051, Name: Run
            local v230, v231 = p229.GetModule("WeaponShop").ConsoleGiveWeapon(p229.Args[1], p229.Args[2], p229.Args[3]);
            p229.Reply(v231, v230);
        end
    },
    {
        Name = "RemoveWeapon",
        Description = "Remove a weapon from a player\'s inventory",
        Usage = "RemoveWeapon <player> <weapon>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            }, {
                Name = "weapon",
                Type = "string",
                Optional = false
            } },

        Run = function(p232) -- Line: 2070, Name: Run
            local v233 = p232.Args[1];
            local v234 = p232.Args[2];
            local Player = p232.GetModule("PlayerHandler").GetPlayer(v233);

            if not (Player and Player:IsAlive()) then
                p232.Reply("target has no alive character", false);

                return;
            end;

            local Character = Player.Character;
            local v235 = {};

            for _, v in Character.WeaponInventory do
                if v.Name == v234 then
                    table.insert(v235, v);
                end;
            end;

            if #v235 == 0 then
                p232.Reply(("%s has no %s"):format(v233.Name, v234), false);

                return;
            end;

            for _, v in v235 do
                v:Destroy(Character, true);
            end;

            p232.Reply(("removed %d x %s from %s"):format(#v235, v234, v233.Name), true);
        end
    },
    {
        Name = "CloseServer",
        Description = "Close the server (kick non-staff joiners)",
        Usage = "CloseServer <0|1>",
        Side = "Server",
        Role = "Developer",
        AllowServerOwner = true,
        AllowCheats = true,
        Hints = { "0", "1" },
        Args = { {
                Name = "closed",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p236) -- Line: 2117, Name: Run
            local v237, v238 = p236.GetModule("Console").SetClosed(p236.Args[1], p236.Player.Name);
            p236.Reply(v238, v237);
        end
    },
    {
        Name = "AddSkin",
        Description = "Grant a weapon skin (online or offline)",
        Usage = "AddSkin <player|userid> <weapon> <skin> [amount] [killtrack] [kt-amount] [tradelocked] [nametag]",
        Side = "Server",
        Role = { "Developer", "Admin" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "weapon",
                Type = "string",
                Optional = false
            }, {
                Name = "skin",
                Type = "string",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = true
            }, {
                Name = "killtrack",
                Type = "boolean",
                Optional = true
            }, {
                Name = "ktamount",
                Type = "integer",
                Optional = true
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            }, {
                Name = "nametag",
                Type = "text",
                Optional = true
            } },

        Run = function(p239) -- Line: 2144, Name: Run
            -- upvalues: Roles (copy)
            local v240 = p239.Args[1];
            local ConsoleDispatch = p239.GetModule("DataManager").ConsoleDispatch;
            local UserId = v240.UserId;
            local v241 = {
                Action = "AddSkin",
                Weapon = p239.Args[2],
                Skin = p239.Args[3],
                Amount = p239.Args[4] or 1,
                KillTrack = p239.Args[5] or false,
                KillTrackAmount = p239.Args[6] or 0
            };
            local v242;

            if p239.Args[7] == true then
                v242 = true;
            else
                local v243 = p239.Player == nil and true or Roles.IsDeveloper(p239.Player.UserId);
                v242 = not v243;
            end;

            v241.TradeLocked = v242;
            v241.NameTag = p239.Args[8];
            v241.SenderUserId = p239.Player and p239.Player.UserId;
            local v244, v245 = ConsoleDispatch(UserId, v241);
            p239.Reply(v245, v244);
        end
    },
    {
        Name = "RemoveSkin",
        Description = "Remove a weapon skin (online or offline)",
        Usage = "RemoveSkin <player|userid> <weapon> <skin> [amount]",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "weapon",
                Type = "string",
                Optional = false
            }, {
                Name = "skin",
                Type = "string",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = true
            } },

        Run = function(p246) -- Line: 2174, Name: Run
            local v247, v248 = p246.GetModule("DataManager").ConsoleDispatch(p246.Args[1].UserId, {
                Action = "RemoveSkin",
                Weapon = p246.Args[2],
                Skin = p246.Args[3],
                Amount = p246.Args[4] or 1
            });
            p246.Reply(v248, v247);
        end
    },
    {
        Name = "AddItem",
        Description = "Grant an item (online or offline)",
        Usage = "AddItem <player|userid> <category> <item> [amount] [tradelocked]",
        Side = "Server",
        Role = { "Developer", "Admin" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "category",
                Type = "string",
                Optional = false
            }, {
                Name = "item",
                Type = "string",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = true
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p249) -- Line: 2199, Name: Run
            -- upvalues: Roles (copy)
            if tostring(p249.Args[3]):lower() == "galaxy outlaw" and (p249.Player ~= nil and not Roles.IsDeveloper(p249.Player.UserId)) then
                p249.Reply("only developers can grant galaxy outlaw", false);

                return;
            end;

            local ConsoleDispatch = p249.GetModule("DataManager").ConsoleDispatch;
            local UserId = p249.Args[1].UserId;
            local v250 = {
                Action = "AddItem",
                Category = p249.Args[2],
                ItemName = p249.Args[3],
                Amount = p249.Args[4] or 1
            };
            local v251;

            if p249.Args[5] == true then
                v251 = true;
            else
                local v252 = p249.Player == nil and true or Roles.IsDeveloper(p249.Player.UserId);
                v251 = not v252;
            end;

            v250.TradeLocked = v251;
            local v253, v254 = ConsoleDispatch(UserId, v250);
            p249.Reply(v254, v253);
        end
    },
    {
        Name = "RemoveItem",
        Description = "Remove an item (online or offline)",
        Usage = "RemoveItem <player|userid> <category> <item> [amount]",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "category",
                Type = "string",
                Optional = false
            }, {
                Name = "item",
                Type = "string",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = true
            } },

        Run = function(p255) -- Line: 2228, Name: Run
            local v256, v257 = p255.GetModule("DataManager").ConsoleDispatch(p255.Args[1].UserId, {
                Action = "RemoveItem",
                Category = p255.Args[2],
                ItemName = p255.Args[3],
                Amount = p255.Args[4] or 1
            });
            p255.Reply(v257, v256);
        end
    },
    {
        Name = "AddAllSkins",
        Description = "Grant every skin in the catalog (online or offline)",
        Usage = "AddAllSkins <player|userid> [tradelocked]",
        Side = "Server",
        Role = { "Developer" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p258) -- Line: 2250, Name: Run
            -- upvalues: Roles (copy)
            local ConsoleDispatch = p258.GetModule("DataManager").ConsoleDispatch;
            local UserId = p258.Args[1].UserId;
            local v259 = {
                Action = "AddAllSkins"
            };
            local v260;

            if p258.Args[2] == true then
                v260 = true;
            else
                local v261 = p258.Player == nil and true or Roles.IsDeveloper(p258.Player.UserId);
                v260 = not v261;
            end;

            v259.TradeLocked = v260;
            local v262, v263 = ConsoleDispatch(UserId, v259);
            p258.Reply(v263, v262);
        end
    },
    {
        Name = "AddAllItems",
        Description = "Grant every item in the catalog (online or offline)",
        Usage = "AddAllItems <player|userid> [tradelocked]",
        Side = "Server",
        Role = { "Developer" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p264) -- Line: 2267, Name: Run
            -- upvalues: Roles (copy)
            local ConsoleDispatch = p264.GetModule("DataManager").ConsoleDispatch;
            local UserId = p264.Args[1].UserId;
            local v265 = {
                Action = "AddAllItems"
            };
            local v266;

            if p264.Args[2] == true then
                v266 = true;
            else
                local v267 = p264.Player == nil and true or Roles.IsDeveloper(p264.Player.UserId);
                v266 = not v267;
            end;

            v265.TradeLocked = v266;
            local v268, v269 = ConsoleDispatch(UserId, v265);
            p264.Reply(v269, v268);
        end
    },
    {
        Name = "AddAllGloves",
        Description = "Grant every glove (online or offline)",
        Usage = "AddAllGloves <player|userid> [tradelocked]",
        Side = "Server",
        Role = { "Developer" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p270) -- Line: 2284, Name: Run
            -- upvalues: Roles (copy)
            local ConsoleDispatch = p270.GetModule("DataManager").ConsoleDispatch;
            local UserId = p270.Args[1].UserId;
            local v271 = {
                Action = "AddAllGloves"
            };
            local v272;

            if p270.Args[2] == true then
                v272 = true;
            else
                local v273 = p270.Player == nil and true or Roles.IsDeveloper(p270.Player.UserId);
                v272 = not v273;
            end;

            v271.TradeLocked = v272;
            local v274, v275 = ConsoleDispatch(UserId, v271);
            p270.Reply(v275, v274);
        end
    },
    {
        Name = "WipeInventory",
        Description = "Reset a player\'s inventory to default (online or offline)",
        Usage = "WipeInventory <player|userid>",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            } },

        Run = function(p276) -- Line: 2300, Name: Run
            local v277, v278 = p276.GetModule("DataManager").ConsoleDispatch(p276.Args[1].UserId, {
                Action = "WipeInventory"
            });
            p276.Reply(v278, v277);
        end
    },
    {
        Name = "ResetAllData",
        Description = "Reset player data to default (online or offline, \'all\' for all players, default self)",
        Usage = "ResetAllData [player|userid|all]",
        Side = "Server",
        Role = "Developer",
        Aliases = { "resetdata", "wipedata", "wipealldata", "reset_all_data", "reset_data" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = true
            } },

        Run = function(p279) -- Line: 2317, Name: Run
            local v280 = p279.Args[1];
            local v281 = v280 and v280.UserId or p279.Player and p279.Player.UserId;
            local v282 = v280 and v280.Name or p279.Player and p279.Player.Name;

            if not v281 then
                p279.Reply("target required", false);

                return;
            end;

            local v283, v284 = p279.GetModule("DataManager").ConsoleDispatch(v281, {
                Action = "WipeData"
            });

            if v282 and v282 ~= "" then
                p279.Reply(("%s: %s"):format(v282, v284), v283);

                return;
            end;

            p279.Reply(v284, v283);
        end
    },
    {
        Name = "AddGamepass",
        Description = "Grant a gamepass by name (online or offline, no ownership check)",
        Usage = "AddGamepass <player|userid> <gamepass name>",
        Side = "Server",
        Role = { "Developer", "Admin" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "gamepass",
                Type = "text",
                Optional = false
            } },

        Run = function(p285) -- Line: 2347, Name: Run
            local v286, v287 = p285.GetModule("DataManager").ConsoleDispatch(p285.Args[1].UserId, {
                Action = "AddGamepass",
                GamepassName = p285.Args[2]
            });
            p285.Reply(v287, v286);
        end
    },
    {
        Name = "votekick_immunity",
        Description = "Toggle votekick immunity for yourself",
        Usage = "votekick_immunity <0|1>",
        Side = "Server",
        Role = { "Developer", "Media", "Star" },
        Hints = { "0", "1" },
        Args = { {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p288) -- Line: 2367, Name: Run
            p288.Player:SetAttribute("VotekickImmune", p288.Args[1]);
            p288.Reply(("votekick immunity %s"):format(p288.Args[1] and "enabled" or "disabled"), true);
        end
    },
    {
        Name = "RemoveGamepass",
        Description = "Remove a gamepass from yourself by name",
        Usage = "RemoveGamepass <gamepass name>",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "gamepass",
                Type = "text",
                Optional = false
            } },

        Run = function(p289) -- Line: 2383, Name: Run
            local v290, v291 = p289.GetModule("DataManager").ConsoleDispatch(p289.Player.UserId, {
                Action = "RemoveGamepass",
                GamepassName = p289.Args[1]
            });
            p289.Reply(v291, v290);
        end
    },
    {
        Name = "SetKredits",
        Description = "Set a player\'s credit balance (online or offline), tradelocked sets the tradelocked balance",
        Usage = "SetKredits <player|userid> <amount> [tradelocked]",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = false
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p292) -- Line: 2407, Name: Run
            -- upvalues: Roles (copy)
            local ConsoleDispatch = p292.GetModule("DataManager").ConsoleDispatch;
            local UserId = p292.Args[1].UserId;
            local v293 = {
                Action = "SetKredits",
                Amount = p292.Args[2]
            };
            local v294;

            if p292.Args[3] == true then
                v294 = true;
            else
                local v295 = p292.Player == nil and true or Roles.IsDeveloper(p292.Player.UserId);
                v294 = not v295;
            end;

            v293.TradeLocked = v294;
            local v296, v297 = ConsoleDispatch(UserId, v293);
            p292.Reply(v297, v296);
        end
    },
    {
        Name = "AddKredits",
        Description = "Add credits to a player (online or offline, negative removes), tradelocked adds tradelocked credits",
        Usage = "AddKredits <player|userid> <amount> [tradelocked]",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "amount",
                Type = "integer",
                Optional = false
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p298) -- Line: 2429, Name: Run
            -- upvalues: Roles (copy)
            local ConsoleDispatch = p298.GetModule("DataManager").ConsoleDispatch;
            local UserId = p298.Args[1].UserId;
            local v299 = {
                Action = "AddKredits",
                Amount = p298.Args[2]
            };
            local v300;

            if p298.Args[3] == true then
                v300 = true;
            else
                local v301 = p298.Player == nil and true or Roles.IsDeveloper(p298.Player.UserId);
                v300 = not v301;
            end;

            v299.TradeLocked = v300;
            local v302, v303 = ConsoleDispatch(UserId, v299);
            p298.Reply(v303, v302);
        end
    },
    {
        Name = "Ban",
        Description = "Ban a player (BanAsync + datastore backup)",
        Usage = "Ban <player|userid> <reason> [time: 30s/10m/2h/7d/1mo/1y, 0=perm]",
        Side = "Server",
        Aliases = { "ban" },
        Role = { "Developer", "Admin", "Moderator" },
        Hints = {
            ["*"] = {
                Cheating = { "0", "1d", "7d", "1mo" },
                Exploiting = { "0", "1d", "7d", "1mo" },
                Toxic = { "1h", "1d", "7d" },
                ["Bug abuse"] = { "0", "1d", "7d" }
            }
        },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false,
                AllowKeywords = false
            }, {
                Name = "reason",
                Type = "text",
                Optional = true
            }, {
                Name = "time",
                Type = "duration",
                Optional = true
            } },

        Run = function(p304) -- Line: 2455, Name: Run
            local v305 = p304.Args[1];
            local v306, v307 = p304.GetModule("BanManager").Ban(v305.UserId, p304.Args[2], p304.Args[3], p304.Player.UserId);
            p304.Reply(v307, v306);
        end
    },
    {
        Name = "Mute",
        Description = "Mute a player in chat, any server, survives rejoin (0 = unmute)",
        Usage = "Mute <player|userid> <time: 30s/10m/2h/7d/1mo/1y, 0=unmute>",
        Side = "Server",
        Role = { "Developer", "Admin", "Moderator" },
        Hints = {
            ["*"] = { "5m", "1h", "1d", "0" }
        },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            }, {
                Name = "time",
                Type = "duration",
                Optional = false
            } },

        Run = function(p308) -- Line: 2474, Name: Run
            local v309 = p308.Args[1];
            local v310, v311 = p308.GetModule("ChatHandler").Mute(v309.UserId, p308.Args[2]);
            p308.Reply(("%s: %s"):format(v309.Name, v311), v310);
        end
    },
    {
        Name = "Vanish",
        Description = "Toggle hiding a player\'s team-join and leave messages",
        Usage = "Vanish <player>",
        Side = "Server",
        Role = "Moderator",
        Args = { {
                Name = "player",
                Type = "player",
                Optional = false
            } },

        Run = function(p312) -- Line: 2493, Name: Run
            local v313 = p312.Args[1];
            local Vanished = p312.GetModule("ChatHandler").Vanished;
            local v314 = not Vanished[v313];
            Vanished[v313] = v314 or nil;
            p312.Reply(("%s vanish %s"):format(v313.Name, v314 and "on" or "off"), true);
        end
    },
    {
        Name = "TeleportPlayer",
        Description = "Teleport yourself to the server the target is in",
        Usage = "TeleportPlayer <player|userid>",
        Side = "Server",
        Role = "Moderator",
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false
            } },

        Run = function(p315) -- Line: 2512, Name: Run
            local v316 = p315.Args[1];

            if v316.Player then
                p315.Reply(("%s is already in this server"):format(v316.Name), false);

                return;
            end;

            local TeleportService = game:GetService("TeleportService");
            local _, _, v317, v318 = TeleportService:GetPlayerPlaceInstanceAsync(v316.UserId);

            if not (v317 and (v318 and v318 ~= "")) then
                p315.Reply(("%s is not in any server of this game"):format(v316.Name), false);

                return;
            end;

            local TeleportOptions = Instance.new("TeleportOptions");
            TeleportOptions.ServerInstanceId = v318;
            p315.Reply(("teleporting to %s (%s)"):format(v316.Name, v318), true);
            TeleportService:TeleportAsync(v317, { p315.Player }, TeleportOptions);
        end
    },
    {
        Name = "GetServer",
        Description = "Show which server a player is in",
        Usage = "GetServer <player|userid>",
        Side = "Server",
        Role = "Moderator",
        Args = { {
                Name = "userid",
                Type = "target",
                Optional = false,
                AllowKeywords = false
            } },

        Run = function(p319) -- Line: 2544, Name: Run
            local v320 = p319.Args[1];

            if v320.Player then
                p319.Reply(("%s is in server %s (place %d)"):format(v320.Name, game.JobId, game.PlaceId), true);

                return;
            end;

            local _, _, v321, v322 = game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync(v320.UserId);

            if v321 and (v322 and v322 ~= "") then
                p319.Reply(("%s is in server %s (place %d)"):format(v320.Name, v322, v321), true);

                return;
            end;

            p319.Reply(("%s is not in any server of this game"):format(v320.Name), false);
        end
    },
    {
        Name = "Unban",
        Description = "Unban a player (UnbanAsync + datastore backup)",
        Usage = "Unban <player|userid>",
        Side = "Server",
        Aliases = { "unban" },
        Role = { "Developer", "Admin", "Moderator" },
        Args = { {
                Name = "target",
                Type = "target",
                Optional = false,
                AllowKeywords = false
            } },

        Run = function(p323) -- Line: 2575, Name: Run
            local v324 = p323.Args[1];
            local v325, v326 = p323.GetModule("BanManager").Unban(v324.UserId);
            p323.Reply(v326, v325);

            if v325 then
                local Module = p323.GetModule("WebhookManager");
                Module.Send("ConsoleUnban", (`**Unban** {Module.Who(p323.Player)} -> {v324.Name} ({v324.UserId}) -- {Module.Now()}`));
            end;
        end
    },
    {
        Name = "promo_create",
        Description = "Create a promocode (Credits=100,XP=500,FuserScrolls=1,Container=X,Skin=AK-47_X,Item=Badges_X)",
        Usage = "promo_create <code> <uses> <rewards> [days, 0=never] [playtime-min] [tradelocked]",
        Side = "Server",
        Role = "Developer",
        Hints = {
            ["*"] = {
                "100",
                "250",
                "500",
                "1000",
                ["*"] = {
                    "Credits=100",
                    "Credits=250",
                    "Credits=500",
                    "XP=500",
                    "FuserScrolls=1",
                    "Skin=AWP_Alpha",
                    "Item=Badges_Anim",
                    ["*"] = {
                        "0",
                        "1",
                        "3",
                        "7",
                        "30",
                        ["*"] = { "0", "30", "60", "120" }
                    }
                }
            }
        },
        Args = { {
                Name = "code",
                Type = "string",
                Optional = false
            }, {
                Name = "uses",
                Type = "integer",
                Optional = false
            }, {
                Name = "rewards",
                Type = "value",
                Optional = false
            }, {
                Name = "days",
                Type = "number",
                Optional = true
            }, {
                Name = "playtime",
                Type = "integer",
                Optional = true
            }, {
                Name = "tradelocked",
                Type = "boolean",
                Optional = true
            } },

        Run = function(p327) -- Line: 2614, Name: Run
            -- upvalues: FormatRewards (copy), FormatEnds (copy)
            local Module = p327.GetModule("Promocodes");
            local v328 = p327.Args[1];
            local v329 = p327.Args[2];
            local v330 = p327.Args[4] or 0;
            local v331 = p327.Args[5] or 0;

            if v329 < 1 then
                p327.Reply("uses must be at least 1", false);

                return;
            end;

            local v332, v333 = Module.ParseRewards(p327.Args[3]);

            if not v332 then
                p327.Reply(v333, false);

                return;
            end;

            local os_time_ret = os.time();
            local v334 = {
                Starts = 0,
                Enabled = true,
                Source = "Console",
                Rewards = v332,
                Uses = v329,
                RequiredPlaytime = math.max(0, v331) * 60,
                Expires = v330 > 0 and (os_time_ret + math.floor(v330 * 86400) or 0) or 0,
                TradeLocked = p327.Args[6] or nil,
                CreatedBy = p327.Player.UserId,
                CreatedAt = os_time_ret
            };
            local v335, v336 = Module.Create(v328, v334);

            if v335 then
                p327.Reply(("%s created -- %d uses -- %s -- %s"):format(v328, v329, FormatRewards(v332, v334.TradeLocked), FormatEnds(v334)), true);

                return;
            end;

            p327.Reply(v336, false);
        end
    },
    {
        Name = "promo_list",
        Description = "List every promocode with its usage and status",
        Usage = "promo_list",
        Side = "Server",
        Role = "Developer",
        Args = {},

        Run = function(p337) -- Line: 2662, Name: Run
            -- upvalues: FormatRewards (copy), FormatEnds (copy)
            local Module = p337.GetModule("Promocodes");
            local All = Module.GetAll();
            local v338 = {};

            for i in All do
                table.insert(v338, i);
            end;

            if #v338 == 0 then
                p337.Reply("no promocodes yet -- promo_create to add one", false);

                return;
            end;

            local Used = Module.GetUsed(v338);
            local u339 = {};
            local v340 = 0;

            for _, v in v338 do
                u339[v] = Module.Status(All[v], Used[v]);

                if u339[v] == "ACTIVE" then
                    v340 = v340 + 1;
                end;
            end;

            table.sort(v338, function(p341, p342) -- Line: 2688
                -- upvalues: u339 (copy)
                local v343 = u339[p342] == "ACTIVE";

                if u339[p341] == "ACTIVE" == v343 then
                    return p341:lower() < p342:lower();
                end;

                return v343;
            end);
            p337.Reply(("promocodes: %d total, %d active"):format(#v338, v340), true);

            for _, v in v338 do
                local v344 = All[v];
                local v345 = u339[v];
                p337.Reply(("%s | %s | %s/%d | %s | %s"):format(v, v345, Used[v] and (tostring(Used[v]) or "?") or "?", v344.Uses, FormatRewards(v344.Rewards, v344.TradeLocked), FormatEnds(v344)), v345 == "ACTIVE" and true or v345 == "SCHEDULED");
            end;
        end
    },
    {
        Name = "promo_info",
        Description = "Everything about one promocode",
        Usage = "promo_info <code>",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "code",
                Type = "string",
                Optional = false
            } },

        Run = function(p346) -- Line: 2726, Name: Run
            -- upvalues: FormatRewards (copy), FormatDate (copy), FormatEnds (copy)
            local Module = p346.GetModule("Promocodes");
            local v347 = p346.Args[1];
            local v348 = Module.Get(v347);

            if not v348 then
                p346.Reply(("%s not found"):format(v347), false);

                return;
            end;

            local v349 = Module.GetUsed({ v347 })[v347];
            local v350 = Module.Status(v348, v349);
            p346.Reply(("%s -- %s"):format(v347, v350), v350 == "ACTIVE" and true or v350 == "SCHEDULED");

            if v349 then
                local Reply = p346.Reply;
                local Uses = v348.Uses;
                local math_max_ret = math.max(0, v348.Uses - v349);
                local v351 = v349 / math.max(1, v348.Uses) * 100;
                Reply(("used %d/%d -- %d left (%d%%)"):format(v349, Uses, math_max_ret, (math.floor(v351))), true);
            else
                p346.Reply(("used ?/%d -- could not read the counter"):format(v348.Uses), false);
            end;

            p346.Reply(("rewards: %s"):format((FormatRewards(v348.Rewards, v348.TradeLocked))), true);
            local Reply = p346.Reply;
            local v352;

            if v348.RequiredPlaytime > 0 then
                local RequiredPlaytime = v348.RequiredPlaytime;
                local v353 = RequiredPlaytime // 86400;
                local v354 = RequiredPlaytime % 86400 // 3600;
                local v355 = RequiredPlaytime % 3600 // 60;
                local v356;

                if v353 > 0 then
                    v356 = ("%dd %dh"):format(v353, v354);
                elseif v354 > 0 then
                    v356 = ("%dh %dm"):format(v354, v355);
                else
                    v356 = ("%dm"):format(v355);
                end;

                v352 = v356 .. " required" or "none";
            else
                v352 = "none";
            end;

            Reply(("playtime: %s"):format(v352), true);

            if v348.Starts > 0 then
                p346.Reply(("starts: %s"):format(FormatDate(v348.Starts)), true);
            end;

            p346.Reply(("expires: %s"):format(v348.Expires > 0 and (("%s (%s)"):format(os.date("!%Y-%m-%d %H:%M UTC", v348.Expires), FormatEnds(v348)) or "never") or "never"), true);

            if v348.Source == "File" then
                p346.Reply(("created: %s -- imported from PromocodesData"):format(FormatDate(v348.CreatedAt)), true);

                return;
            end;

            p346.Reply(("created: %s -- %s via %s"):format(os.date("!%Y-%m-%d %H:%M UTC", v348.CreatedAt), p346.GetModule("WebhookManager").Who(v348.CreatedBy), v348.Source:lower()), true);
        end
    },
    {
        Name = "promo_uses",
        Description = "Add, remove or set a promocode\'s use limit",
        Usage = "promo_uses <code> <+N|-N|N>",
        Side = "Server",
        Role = "Developer",
        Hints = {
            ["*"] = { "+50", "+100", "+500", "-50", "-100" }
        },
        Args = { {
                Name = "code",
                Type = "string",
                Optional = false
            }, {
                Name = "change",
                Type = "string",
                Optional = false
            } },

        Run = function(p357) -- Line: 2776, Name: Run
            local Module = p357.GetModule("Promocodes");
            local v358 = p357.Args[1];
            local u359, v360 = p357.Args[2]:match("^([%+%-]?)(%d+)$");

            if not v360 then
                p357.Reply("change must be +N, -N or N (e.g. +100)", false);

                return;
            end;

            local u361 = tonumber(v360);
            local u362 = nil;
            local u363 = nil;
            local v365, v366 = Module.Edit(v358, function(p364) -- Line: 2789
                -- upvalues: u362 (ref), u359 (copy), u361 (copy), u363 (ref)
                u362 = p364.Uses;

                if u359 == "+" then
                    p364.Uses = p364.Uses + u361;
                elseif u359 == "-" then
                    p364.Uses = math.max(0, p364.Uses - u361);
                else
                    p364.Uses = u361;
                end;

                u363 = p364.Uses;
            end);

            if not v365 then
                p357.Reply(v366, false);

                return;
            end;

            local v367 = Module.GetUsed({ v358 })[v358];
            p357.Reply(("%s uses %d -> %d -- %s/%d used"):format(v358, u362, u363, v367 and tostring(v367) or "?", u363), true);
        end
    },
    {
        Name = "promo_enable",
        Description = "Pause (0) or resume (1) a promocode without deleting it",
        Usage = "promo_enable <code> <0|1>",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "code",
                Type = "string",
                Optional = false
            }, {
                Name = "enabled",
                Type = "boolean",
                Optional = false
            } },

        Run = function(p368) -- Line: 2824, Name: Run
            local v369 = p368.Args[1];
            local u370 = p368.Args[2];
            local v372, v373 = p368.GetModule("Promocodes").Edit(v369, function(p371) -- Line: 2827
                -- upvalues: u370 (copy)
                p371.Enabled = u370;
            end);
            local Reply = p368.Reply;

            if v372 then
                v373 = ("%s %s"):format(v369, u370 and "resumed" or "paused") or v373;
            end;

            Reply(v373, v372);
        end
    },
    {
        Name = "promo_expire",
        Description = "Set when a promocode ends, in days from now (0 = never)",
        Usage = "promo_expire <code> <days>",
        Side = "Server",
        Role = "Developer",
        Hints = {
            ["*"] = { "0", "1", "3", "7", "30" }
        },
        Args = { {
                Name = "code",
                Type = "string",
                Optional = false
            }, {
                Name = "days",
                Type = "number",
                Optional = false
            } },

        Run = function(p374) -- Line: 2847, Name: Run
            -- upvalues: FormatEnds (copy)
            local v375 = p374.Args[1];
            local u376 = p374.Args[2];
            local u377 = nil;
            local v379, v380 = p374.GetModule("Promocodes").Edit(v375, function(p378) -- Line: 2851
                -- upvalues: u376 (copy), u377 (ref)
                p378.Expires = u376 > 0 and os.time() + math.floor(u376 * 86400) or 0;
                u377 = p378;
            end);
            local Reply = p374.Reply;

            if v379 then
                v380 = ("%s %s"):format(v375, FormatEnds(u377)) or v380;
            end;

            Reply(v380, v379);
        end
    },
    {
        Name = "promo_delete",
        Description = "Delete a promocode and its usage counter",
        Usage = "promo_delete <code>",
        Side = "Server",
        Role = "Developer",
        Args = { {
                Name = "code",
                Type = "string",
                Optional = false
            } },

        Run = function(p381) -- Line: 2870, Name: Run
            local v382 = p381.Args[1];
            local v383, v384 = p381.GetModule("Promocodes").Delete(v382);
            local Reply = p381.Reply;

            if v383 then
                v384 = ("%s deleted"):format(v382) or v384;
            end;

            Reply(v384, v383);
        end
    }
};
local u385 = {};

for _, v in ipairs(u1.Commands) do
    u385[v.Name:lower()] = v;
    local v386 = v;

    for _, v2 in ipairs(v.Aliases or {}) do
        u385[v2:lower()] = v386;
    end;
end;

function u1.Get(p387: string?) -- Line: 2891
    -- upvalues: u385 (copy)
    return p387 and u385[p387:lower()] or nil;
end;

return u1;