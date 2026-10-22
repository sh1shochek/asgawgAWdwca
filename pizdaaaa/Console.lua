-- ReplicatedStorage.GameClient.Gui.HUD.Console
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Console
-- Decompile time: 55.69 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local ValueCodec = require(ReplicatedStorage.Shared.ValueCodec);

function u1.GetCommand(p17: string) -- Line: 32
    -- upvalues: u1 (copy), u8 (ref)
    if not p17 or p17 == "" then
        return nil;
    end;

    local v18 = u1[p17];

    if v18 and (typeof(v18) == "table" and (v18.Callback or (v18.Hints or v18.Button))) then
        return v18;
    end;

    local v19 = u8.Get(p17);

    if v19 then
        return not (u1[v19.Name] and (typeof(u1[v19.Name]) == "table" and (u1[v19.Name].Callback or (u1[v19.Name].Hints or u1[v19.Name].Button)))) and {
            Definition = v19,
            Hints = v19.Hints or {}
        } or u1[v19.Name];
    end;

    local v20 = p17:lower();

    for i, v in pairs(u1) do
        if typeof(i) == "string" and (typeof(v) == "table" and (v.Callback or (v.Hints or v.Button))) and i:lower() == v20 then
            return v;
        end;
    end;

    return nil;
end;

function u1.ReSizeConsole() -- Line: 62
    -- upvalues: u3 (ref), u4 (ref), UserInputService (copy)
    local u21 = nil;
    local u22 = nil;
    local u23 = nil;
    local u24 = false;
    u3:Add("ReSizeBegan", u4.Down.Resize.InputBegan:Connect(function(p25) -- Line: 66
        -- upvalues: u21 (ref), u22 (ref), u24 (ref), u4 (ref)
        if p25.UserInputType == Enum.UserInputType.MouseButton1 then
            u21 = p25.Position;
            u22 = u4.Size;
            u24 = true;
        end;
    end));
    u3:Add("ReSizeChanged", UserInputService.InputChanged:Connect(function(p26) -- Line: 72
        -- upvalues: u24 (ref), u23 (ref), u21 (ref), u4 (ref), u22 (ref)
        if p26.UserInputType == Enum.UserInputType.MouseMovement and u24 then
            u23 = p26.Position - u21;
            u4.Size = UDim2.fromOffset(math.clamp(u22.X.Offset + u23.X, 600, 1200), (math.clamp(u22.Y.Offset + u23.Y, 500, 900)));
        end;
    end));
    u3:Add("ReSizeEnded", UserInputService.InputEnded:Connect(function(p27) -- Line: 83
        -- upvalues: u24 (ref)
        if p27.UserInputType == Enum.UserInputType.MouseButton1 then
            u24 = false;
        end;
    end));
end;

function u1.ConsoleDraggin() -- Line: 90
    -- upvalues: u3 (ref), u4 (ref), UserInputService (copy)
    local u28 = nil;
    local u29 = nil;
    local u30 = nil;
    local u31 = false;
    u3:Add("Dragging_Began", u4.Top.InputBegan:Connect(function(u32) -- Line: 94
        -- upvalues: u29 (ref), u30 (ref), u31 (ref), u4 (ref), u3 (ref)
        if u32.UserInputType == Enum.UserInputType.MouseButton1 then
            u29 = u32.Position;
            u30 = u4.Position;
            u31 = true;
            u3:Add("Dragging_Input", u32.Changed:Connect(function() -- Line: 98
                -- upvalues: u32 (copy), u31 (ref)
                if u32.UserInputState == Enum.UserInputState.End then
                    u31 = false;
                end;
            end));
        end;
    end));
    u3:Add("Dragging_Changed", u4.Top.InputChanged:Connect(function(p33) -- Line: 106
        -- upvalues: u28 (ref)
        if p33.UserInputType == Enum.UserInputType.MouseMovement then
            u28 = p33;
        end;
    end));
    u3:Add("Dragging_InputChanged", UserInputService.InputChanged:Connect(function(p34) -- Line: 112
        -- upvalues: u28 (ref), u31 (ref), u29 (ref), u4 (ref), u30 (ref)
        if p34 == u28 and u31 then
            local v35 = p34.Position - u29;
            u4.Position = UDim2.new(u30.X.Scale, u30.X.Offset + v35.X, u30.Y.Scale, u30.Y.Offset + v35.Y);
        end;
    end));
end;

function u1.RegisterCommand() -- Line: 121
    -- upvalues: u1 (copy), u3 (ref), u4 (ref)
    for _, v in pairs(u1) do
        if typeof(v) == "table" and (v.Button and v.Button:IsA("TextButton")) then
            u3:Add(`ConsoleCommand_{v.Click}`, v.Button.MouseButton1Click:Connect(function() -- Line: 125
                -- upvalues: u4 (ref), v (copy)
                u4.Down.TextBox.Text = v.Click .. " ";
                u4.Down.TextBox:CaptureFocus();
            end));
        end;
    end;
end;

local u36 = {};
local u37 = 0;

function u1.SendCommand() -- Line: 138
    -- upvalues: u4 (ref), u8 (ref), u36 (copy), u37 (ref), u1 (copy)
    local Text = u4.Down.TextBox.Text;
    local v38 = u8.Tokenize(Text);

    if Text:match("%S") then
        local table_find_ret = table.find(u36, Text);

        if table_find_ret then
            table.remove(u36, table_find_ret);
        end;

        table.insert(u36, Text);

        if #u36 > 50 then
            table.remove(u36, 1);
        end;
    end;

    u37 = 0;
    local v39 = v38[1] or "";
    local v40 = {};

    for i = 2, #v38 do
        table.insert(v40, v38[i]);
        local _ = i;
    end;

    local Command = u1.GetCommand(v39);

    if Command and typeof(Command.Callback) == "function" then
        local success, result = pcall(Command.Callback, v40, Text);

        if not success and result then
            u1.CreateOutput(tostring(result):gsub("^.+:%d+:%s*", ""), Color3.fromRGB(250, 0, 0));
        end;
    elseif Command and Command.Definition then
        u1.Dispatch(Command.Definition, v40, Text);
    elseif Text ~= "" then
        u1.CreateOutput(`unknown command: {v39}`, Color3.fromRGB(250, 0, 0));
    end;

    u4.Down.TextBox.Text = "";
    u1.ClearHints();
    u4.Down.TextBox:CaptureFocus();
end;

local u41 = {};

function u1.CreateOutput(p42: string, p43) -- Line: 187
    -- upvalues: u1 (copy), u4 (ref), u41 (copy)
    local v44 = u1.newOutput();
    v44.TextColor3 = p43 or Color3.fromRGB(255, 255, 255);
    v44.Text = p42;
    v44.Parent = u4.ScrollingFrame;
    table.insert(u41, v44);
    local v45 = #u41 > 200 and table.remove(u41, 1);

    if v45 then
        v45:Destroy();
    end;

    u4.ScrollingFrame.CanvasPosition = Vector2.new(0, 999999);
end;

function u1.ClearHints() -- Line: 206
    -- upvalues: u4 (ref), u3 (ref)
    for _, child in ipairs(u4.Down.ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") and (child.Name == "_hint" or child.Name == "_usage") then
            child:Destroy();
            u3:Removes((`hint_{child.Text}`));
        end;
    end;
end;

local function ParseInputState(p46: string) -- Line: 215
    -- upvalues: u8 (ref)
    local v47 = u8.Tokenize(p46);
    local v48 = v47[1] or "";
    local v49 = false;
    local v50 = nil;

    for i = 1, #p46 do
        local v51 = p46:sub(i, i);
        local v52;

        if v51 == "\"" or v51 == "\'" then
            if v49 then
                if v51 == v50 then
                    v52 = i;
                    v49 = false;
                    v50 = nil;
                else
                    v52 = i;
                end;
            else
                v50 = v51;
                v52 = i;
                v49 = true;
            end;
        else
            v52 = i;
        end;
    end;

    local v53 = not v49 and p46:match("%s$") ~= nil;
    local v54 = {};
    local v55, v56;

    if v53 then
        for i = 2, #v47 do
            table.insert(v54, v47[i]);
            local _ = i;
        end;

        v55 = #v54 + 1;
        v56 = "";
    else
        for i = 2, #v47 - 1 do
            table.insert(v54, v47[i]);
            local _ = i;
        end;

        if #v47 >= 2 then
            v55 = #v47 - 1;
            v56 = v47[#v47];
        else
            v55 = 0;
            v56 = "";
        end;
    end;

    return v48, v54, v55, v56, v49;
end;

local function TraverseHintsTable(p57: any, p58: table, p59: number) -- Line: 261
    if typeof(p57) ~= "table" then
        return nil;
    end;

    for i = 1, p59 - 1 do
        if typeof(p57) ~= "table" then
            return nil;
        end;

        p57 = p57[p58[i]] or p57["*"];
        local _ = i;
    end;

    if typeof(p57) == "table" then
        local v60 = {};
        local v61 = {};

        for i = 1, #p57 do
            local v62 = p57[i];
            local v63;

            if typeof(v62) == "string" then
                table.insert(v60, v62);
                v61[v62] = true;
                v63 = i;
            else
                v63 = i;
            end;
        end;

        for i, _ in pairs(p57) do
            if typeof(i) == "string" and (i ~= "*" and not v61[i]) then
                table.insert(v60, i);
                v61[i] = true;
            end;
        end;

        if #v60 > 0 then
            return v60;
        end;
    end;

    return nil;
end;

local function ConstantsTableFor(p64: string, p65: table) -- Line: 304
    -- upvalues: u15 (ref), u9 (ref), Players (copy), u16 (ref)
    if p64 == "simulationconstant" or p64 == "templatesimulationconstant" then
        return u15.ConstantsTemplate;
    end;

    if p64 == "templateweaponconstant" then
        local v66 = p65[1] and u9.Get(p65[1]);

        if v66 then
            return v66.Data;
        end;
    else
        if p64 ~= "weaponconstant" then
            return nil;
        end;

        local v67 = p65[1] and p65[1]:lower();
        local v68 = ((v67 == nil or v67 == "me") and true or v67 == Players.LocalPlayer.Name:lower()) and u16.GetCurrentWeapon();

        if v68 and v68.Data then
            return v68.Data;
        end;
    end;

    local v69 = {};

    for _, v in pairs(u9.GetAllWeapons()) do
        for i, v2 in pairs(v.Data or {}) do
            v69[i] = v2;
        end;
    end;

    return v69;
end;

function u1.GetHintsForArgument(p70: string, p71: table, p72: number, p73: string) -- Line: 340
    -- upvalues: u1 (copy), u8 (ref), Players (copy), u9 (ref), u10 (ref), u11 (ref), u13 (ref), ConstantsTableFor (copy), ValueCodec (copy), u12 (ref), TraverseHintsTable (copy), u14 (ref)
    local Command = u1.GetCommand(p70);
    local v74 = Command and Command.Definition or u8.Get(p70);
    local v75;

    if v74 then
        v75 = v74.Args;
    else
        v75 = v74;
    end;

    if v75 then
        v75 = v75[p72];
    end;

    local v76;

    if v74 then
        v76 = v74.Usage or v74.Name;
    else
        v76 = v74;
    end;

    local v77 = p70:lower();

    if v75 and (v75.Type == "player" or (v75.Type == "target" or (v75.Name == "player" or v75.Name == "target"))) then
        local v78 = {};

        for _, v in ipairs(Players:GetPlayers()) do
            table.insert(v78, v.Name);
        end;

        table.sort(v78);

        if v75.AllowKeywords ~= false and (v75.NoKeywords ~= true and (v77 ~= "kick" and (v77 ~= "ban" and (v77 ~= "unban" and v77 ~= "boot")))) then
            table.insert(v78, 1, "All");
            table.insert(v78, 2, "Me");
            table.insert(v78, 3, "Random");
        end;

        if v75.Type == "target" and p73:match("^%d+$") then
            table.insert(v78, 1, p73);
        end;

        return v78, v76;
    end;

    if v75 and v75.Name == "weapon" or (v77 == "addweapon" and p72 == 2 or (v77 == "addskin" and p72 == 2 or v77 == "removeskin" and p72 == 2)) then
        local v79 = {};
        local v80 = {};

        for i in pairs(u9.GetAllWeapons()) do
            if not v79[i] then
                table.insert(v80, i);
                v79[i] = true;
            end;
        end;

        for _, v in ipairs({ "Kevlar Vest", "Kevlar & Helmet", "Rescue Kit" }) do
            if not v79[v] then
                table.insert(v80, v);
                v79[v] = true;
            end;
        end;

        table.sort(v80);

        return v80, v76;
    end;

    if v75 and v75.Name == "skin" or (v77 == "addweapon" and p72 == 3 or (v77 == "addskin" and p72 == 3 or v77 == "removeskin" and p72 == 3)) then
        local v81 = p71[2];
        local v82 = {};
        local v83 = {};
        table.insert(v82, "Stock");
        v83.Stock = true;

        if v81 then
            local AllSkins = u10.GetAllSkins();

            if AllSkins then
                AllSkins = AllSkins[v81];
            end;

            if AllSkins then
                local v84 = {};

                for i in pairs(AllSkins) do
                    if not v83[i] then
                        table.insert(v84, i);
                        v83[i] = true;
                    end;
                end;

                table.sort(v84);

                for _, v in ipairs(v84) do
                    table.insert(v82, v);
                end;
            end;
        end;

        return v82, v76;
    end;

    if (v77 == "additem" or v77 == "removeitem") and (p72 == 2 or v75 and v75.Name == "category") then
        local v85 = { "Agents", "Badges", "Charms", "Containers", "Equipment", "Gloves", "Graffiti", "KillTracks", "Music Kits", "Name Tags", "Stickers" };

        for i in pairs(u11.GetGloveCategories()) do
            table.insert(v85, i);
        end;

        table.sort(v85);

        return v85, v76;
    end;

    if (v77 == "additem" or v77 == "removeitem") and (p72 == 3 or v75 and v75.Name == "item") then
        local v86 = p71[2];
        local v87 = {};

        if v86 and v86:lower() == "gloves" then
            for _, v in pairs(u11.GetGloveCategories()) do
                for i in pairs(v) do
                    if not table.find(v87, i) then
                        table.insert(v87, i);
                    end;
                end;
            end;
        elseif v86 then
            local Items = u11.GetItems(v86);

            if Items then
                for i in pairs(Items) do
                    table.insert(v87, i);
                end;
            end;
        end;

        table.sort(v87);

        return v87, v76;
    end;

    if v77 == "addgamepass" or v77 == "removegamepass" then
        local v88 = {};
        local v89 = {};

        for _, v in pairs(u13.Gamepasses) do
            local v90 = v.DisplayName or v.Name;

            if v90 and not v88[v90] then
                table.insert(v89, v90);
                v88[v90] = true;
            end;
        end;

        table.sort(v89);

        return v89, v76;
    end;

    if v77 == "characterproperty" then
        if p72 == 2 then
            return { "Health", "MaxHealth", "Armor", "Helmet", "DefuseKit" }, v76;
        end;

        if p72 == 3 then
            local v91 = p71[2] and p71[2]:lower();

            if v91 == "helmet" or v91 == "defusekit" then
                return { "0", "1" }, v76;
            end;

            if v91 == "health" or (v91 == "hp" or v91 == "maxhealth") then
                return { "100", "150", "200", "50", "1" }, v76;
            end;

            if v91 == "armor" then
                return { "100", "50", "0" }, v76;
            end;

            return { "0", "1", "100" }, v76;
        end;
    end;

    if v75 then
        local v92 = v75.Name:lower();
        local v93 = ConstantsTableFor(v77, p71);
        local v94;

        if v92 == "constant" then
            v94 = true;
        elseif v92 == "property" then
            v94 = v77 == "simulationconstant";
        else
            v94 = false;
        end;

        if v93 and (v94 or v92 == "value") then
            if v94 then
                local v95 = {};

                for i in pairs(v93) do
                    table.insert(v95, i);
                end;

                table.sort(v95);

                return v95, v76;
            end;

            local v96 = p71[p72 - 1];

            if v96 then
                v96 = v93[v96];
            end;

            if v96 == nil then
                return {}, v76;
            end;

            return { ValueCodec.Encode(v96) }, v76;
        end;
    end;

    if v77 == "config" then
        local Config = u12.GetConfig();

        if p72 == 1 then
            local v97 = {};

            if Config then
                for i in pairs(Config) do
                    table.insert(v97, i);
                end;
            end;

            table.sort(v97);

            return v97, v76;
        end;

        if p72 == 2 then
            local v98 = p71[1];
            local v99 = {};

            if v98 and Config then
                local v100 = Config[v98];

                if not v100 then
                    local v101 = v98:lower();

                    for i, v in pairs(Config) do
                        if i:lower() == v101 then
                            v100 = v;
                            break;
                        end;
                    end;
                end;

                if v100 and typeof(v100) == "table" then
                    for i in pairs(v100) do
                        table.insert(v99, i);
                    end;
                end;
            end;

            table.sort(v99);

            return v99, v76;
        end;

        if p72 == 3 then
            local v102 = p71[1];
            local v103 = p71[2];

            if v102 and (v103 and Config) then
                local v104 = Config[v102];

                if not v104 then
                    local v105 = v102:lower();

                    for i, v in pairs(Config) do
                        if i:lower() == v105 then
                            v104 = v;
                            break;
                        end;
                    end;
                end;

                local v106;

                if v104 then
                    v106 = v104[v103];
                else
                    v106 = v104;
                end;

                if v106 == nil and v104 then
                    local v107 = v103:lower();

                    for i, v in pairs(v104) do
                        if i:lower() == v107 then
                            v106 = v;
                            break;
                        end;
                    end;
                end;

                if typeof(v106) == "boolean" then
                    return { "0", "1" }, v76;
                end;

                if typeof(v106) == "vector" or typeof(v106) == "Vector3" then
                    return { string.format("%g,%g,%g", v106.X, v106.Y, v106.Z) }, v76;
                end;

                if v106 ~= nil then
                    return { (tostring(v106)) }, v76;
                end;
            end;

            return { "0", "1" }, v76;
        end;
    end;

    if v75 and v75.Type == "boolean" then
        return { "0", "1" }, v76;
    end;

    if Command and Command.Hints then
        local v108 = TraverseHintsTable(Command.Hints, p71, p72);

        if v108 and #v108 > 0 then
            return v108, v76;
        end;
    end;

    if v74 and v74.Hints then
        local v109 = TraverseHintsTable(v74.Hints, p71, p72);

        if v109 and #v109 > 0 then
            return v109, v76;
        end;
    end;

    if v75 then
        local v110 = v75.Name:lower();

        if v110 == "amount" or v110 == "ktamount" then
            if v77 == "setkredits" or v77 == "addkredits" then
                return { "100", "500", "1000", "5000", "10000" }, v76;
            end;

            return { "1", "5", "10", "50", "100" }, v76;
        end;

        if v110 == "killtrack" then
            return { "0", "1" }, v76;
        end;

        if v110 == "reason" then
            return { "AFK", "Cheating", "Exploiting", "Toxic", "Trolling" }, v76;
        end;

        if v110 == "time" or v110 == "seconds" then
            return { "0", "5", "10", "15", "30", "60", "120" }, v76;
        end;

        if v110 == "r" or (v110 == "g" or v110 == "b") then
            return { "255", "0", "128" }, v76;
        end;

        if v110 == "value" and (v77 == "cliptransparency" or v77 == "zonetransparency") then
            return { "0", "0.25", "0.5", "0.75", "1" }, v76;
        end;

        if v110 == "state" and v77 == "setstate" then
            return { "Warmup", "Preparation", "RoundTime", "RoundEnded", "MatchEnded", "BombPlanted", "BombDefused", "BombExploded", "Restart" }, v76;
        end;

        if v110 == "map" then
            local v111 = {};

            for i in pairs(u14.Maps) do
                table.insert(v111, i);
            end;

            table.sort(v111);

            return v111, v76;
        end;

        if v110 == "height" then
            return { "64", "100", "200", "300" }, v76;
        end;
    end;

    return {}, v76;
end;

local u112 = 0;
local u113 = nil;
local u114 = false;

local function GetVisibleHints() -- Line: 663
    -- upvalues: u4 (ref)
    local v115 = {};

    for _, child in ipairs(u4.Down.ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") and (child.Name == "_hint" and child.Visible) then
            v115[#v115 + 1] = child;
        end;
    end;

    return v115;
end;

local function CommandRedeemable(p116: string) -- Line: 675
    -- upvalues: u1 (copy), u8 (ref), u7 (ref), Players (copy)
    local Command = u1.GetCommand(p116);

    if Command then
        Command = Command.Definition;
    end;

    if not (Command and u8) then
        return true;
    end;

    local Rank = u7.GetRank(Players.LocalPlayer.UserId);
    local v117 = Players.LocalPlayer:GetAttribute("IsServerOwner") == true;
    local v118 = workspace:GetAttribute("sv_cheats") == true;

    return u8.CanPlayerRun(Command, Rank, v117, v118, Players.LocalPlayer.UserId);
end;

local function GetVisibleCommands() -- Line: 689
    -- upvalues: u4 (ref)
    local v119 = {};

    for _, child in ipairs(u4.Down.ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") and (child.Name ~= "_hint" and (child.Name ~= "_usage" and (child.Name ~= "UIListLayout" and (child.Name ~= "UIPadding" and child.Visible)))) then
            v119[#v119 + 1] = child;
        end;
    end;

    return v119;
end;

local function HighlightItems(p120: table) -- Line: 699
    -- upvalues: u112 (ref)
    for i, v in ipairs(p120) do
        if i == u112 then
            v.BackgroundColor3 = Color3.fromRGB(90, 100, 110);
        else
            v.BackgroundColor3 = Color3.fromRGB(62, 69, 72);
        end;
    end;
end;

local function ResetHighlights() -- Line: 709
    -- upvalues: u4 (ref)
    for _, child in ipairs(u4.Down.ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "_usage" then
            child.BackgroundColor3 = Color3.fromRGB(62, 69, 72);
        end;
    end;
end;

local function ApplyHint(p121: string) -- Line: 717
    -- upvalues: u4 (ref), ParseInputState (copy), u114 (ref), u112 (ref), u113 (ref), ResetHighlights (copy), u1 (copy)
    local Text = u4.Down.TextBox.Text;
    local v122, _, _, _, v123 = ParseInputState(Text);

    if p121:find("%s") then
        p121 = `"{p121}"` or p121;
    end;

    local v124 = not v123 and Text:match("%s$") ~= nil;
    local v125;

    if v124 then
        v125 = Text .. p121 .. " ";
    elseif v123 then
        v125 = (Text:match("^(.-)[\"\'][^\"\']*$") or "") .. p121 .. " ";
    else
        local v126 = Text:match("^(.-)%s*[^%s]*$") or "";
        v125 = (v126 == "" and "" or (v126 .. " " or "")) .. p121 .. " ";
    end;

    u114 = true;
    u4.Down.TextBox.Text = v125;
    u4.Down.TextBox.CursorPosition = #v125 + 1;
    u4.Down.TextBox:CaptureFocus();
    u112 = 0;
    u113 = nil;
    ResetHighlights();
    u1.ShowHints(v122);
end;

function u1.ShowHints(p127: string) -- Line: 746
    -- upvalues: u1 (copy), u4 (ref), ParseInputState (copy), u3 (ref), ApplyHint (copy)
    if not u1.GetCommand(p127) then
        u1.ClearHints();

        return;
    end;

    local _, v128, v129, v130, _ = ParseInputState(u4.Down.TextBox.Text);

    if v129 <= 0 then
        u1.ClearHints();

        return;
    end;

    local HintsForArgument, v131 = u1.GetHintsForArgument(p127, v128, v129, v130);
    u1.ClearHints();

    if v131 and v131 ~= "" then
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "_usage";
        TextButton.Text = `Usage: {v131}`;
        TextButton.Size = UDim2.new(1, 0, 0, 18);
        TextButton.BackgroundColor3 = Color3.fromRGB(45, 52, 55);
        TextButton.BorderSizePixel = 0;
        TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
        TextButton.TextColor3 = Color3.fromRGB(130, 200, 255);
        TextButton.TextSize = 12;
        TextButton.TextXAlignment = Enum.TextXAlignment.Left;
        TextButton.AutoButtonColor = false;
        TextButton.Parent = u4.Down.ScrollingFrame;
        local UIPadding = Instance.new("UIPadding", TextButton);
        UIPadding.PaddingLeft = UDim.new(0, 8);
        UIPadding.PaddingRight = UDim.new(0, 8);
        local UIStroke = Instance.new("UIStroke", TextButton);
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Color = Color3.fromRGB(40, 48, 52);
        UIStroke.Thickness = 1;
    end;

    local u132 = v130:lower();
    local v133 = {};

    for _, v in ipairs(HintsForArgument) do
        if u132 == "" or v:lower():find(u132, 1, true) then
            table.insert(v133, v);
        end;
    end;

    if u132 ~= "" then
        table.sort(v133, function(p134, p135) -- Line: 799
            -- upvalues: u132 (copy)
            local v136 = p134:lower():sub(1, #u132) == u132;

            if v136 == (p135:lower():sub(1, #u132) == u132) then
                return p134:lower() < p135:lower();
            end;

            return v136;
        end);
    end;

    for _, v in ipairs(v133) do
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "_hint";
        TextButton.Text = v;
        TextButton.Size = UDim2.new(1, 0, 0, 18);
        TextButton.BackgroundColor3 = Color3.fromRGB(62, 69, 72);
        TextButton.BorderSizePixel = 0;
        TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold);
        TextButton.TextColor3 = Color3.new(1, 1, 1);
        TextButton.TextSize = 13;
        TextButton.TextXAlignment = Enum.TextXAlignment.Left;
        TextButton.Parent = u4.Down.ScrollingFrame;
        local UIPadding = Instance.new("UIPadding", TextButton);
        UIPadding.PaddingLeft = UDim.new(0, 8);
        UIPadding.PaddingRight = UDim.new(0, 8);
        local UIStroke = Instance.new("UIStroke", TextButton);
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Color = Color3.fromRGB(53, 58, 61);
        UIStroke.Thickness = 1;
        u3:Add(`hint_{v}`, TextButton.MouseButton1Click:Connect(function() -- Line: 831
            -- upvalues: ApplyHint (ref), v (copy)
            ApplyHint(v);
        end));
    end;
end;

function u1.Tab() -- Line: 837
    -- upvalues: u3 (ref), UserInputService (copy), u4 (ref), u37 (ref), u36 (copy), u114 (ref), u112 (ref), u1 (copy), GetVisibleHints (copy), GetVisibleCommands (copy), HighlightItems (copy), ApplyHint (copy), ResetHighlights (copy)
    u3:Add("ConsoleTab", UserInputService.InputBegan:Connect(function(p137) -- Line: 838
        -- upvalues: u4 (ref), u37 (ref), u36 (ref), u114 (ref), u112 (ref), u1 (ref), GetVisibleHints (ref), GetVisibleCommands (ref), HighlightItems (ref), ApplyHint (ref), ResetHighlights (ref)
        local Text = u4.Down.TextBox.Text;
        local v138 = Text:match("^(%S+)");
        local v139 = Text:find("%s");

        if (p137.KeyCode == Enum.KeyCode.Up or p137.KeyCode == Enum.KeyCode.Down) and ((Text == "" or u37 > 0) and #u36 > 0) then
            if p137.KeyCode == Enum.KeyCode.Up then
                u37 = math.min(u37 + 1, #u36);
            else
                u37 = math.max(u37 - 1, 0);
            end;

            local v140 = u37 > 0 and u36[#u36 - u37 + 1] or "";

            if Text ~= v140 then
                u114 = true;
                u4.Down.TextBox.Text = v140;
            end;

            u112 = 0;
            u1.ClearHints();
            u4.Down.TextBox.CursorPosition = #v140 + 1;
            u4.Down.TextBox:CaptureFocus();

            return;
        end;

        if p137.KeyCode ~= Enum.KeyCode.Up and p137.KeyCode ~= Enum.KeyCode.Down then
            if p137.KeyCode ~= Enum.KeyCode.Tab then
                return;
            end;

            u4.Down.TextBox:ReleaseFocus();

            if v139 and u1.GetCommand(v138) then
                local v141 = GetVisibleHints();
                local v142 = #v141 > 0 and (u112 > 0 and v141[u112] or v141[1]);

                if v142 then
                    ApplyHint(v142.Text);

                    return;
                end;
            else
                local v143 = GetVisibleCommands();
                local v144 = #v143 > 0 and (u112 > 0 and v143[u112] or v143[1]);

                if v144 then
                    u114 = true;
                    u4.Down.TextBox.Text = v144.Name .. " ";
                    u4.Down.TextBox.CursorPosition = #u4.Down.TextBox.Text + 1;
                    u112 = 0;
                    ResetHighlights();
                    u4.Down.TextBox:CaptureFocus();
                    u1.ShowHints(v144.Name);

                    return;
                end;
            end;

            u4.Down.TextBox:CaptureFocus();

            return;
        end;

        local v145;

        if v139 and u1.GetCommand(v138) then
            v145 = GetVisibleHints();
        else
            v145 = GetVisibleCommands();
        end;

        if #v145 == 0 then
            return;
        end;

        if p137.KeyCode == Enum.KeyCode.Down then
            u112 = u112 + 1;

            if u112 > #v145 then
                u112 = 1;
            end;
        else
            u112 = u112 - 1;

            if u112 < 1 then
                u112 = #v145;
            end;
        end;

        HighlightItems(v145);

        if v145[u112] then
            u4.Down.ScrollingFrame.CanvasPosition = Vector2.new(0, (math.clamp((u112 - 1) * 19 - 40, 0, 9999)));
        end;

        u4.Down.TextBox:CaptureFocus();
    end));
end;

function u1.CreateCommand(p146: string, p147: string, p148: any, p149: any, p150: any) -- Line: 936
    -- upvalues: u4 (ref), u1 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.BackgroundColor3 = Color3.fromRGB(62, 69, 72);
    TextButton.BorderSizePixel = 0;
    TextButton.Text = p147;
    TextButton.Name = p146;
    TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextButton.TextColor3 = Color3.new(1, 1, 1);
    TextButton.TextSize = 13;
    TextButton.TextScaled = false;
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton.Size = UDim2.new(1, 0, 0, 18);
    TextButton.Visible = false;
    local UIPadding = Instance.new("UIPadding", TextButton);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(53, 58, 61);
    UIStroke.Thickness = 1;
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Parent = TextButton;
    TextButton.Parent = u4.Down.ScrollingFrame;
    u1[p146] = {
        Callback = p149,
        Button = TextButton,
        Click = p146,
        Hints = p148 or {},
        Definition = p150
    };
end;

function u1.RefreshInput() -- Line: 973
    -- upvalues: u112 (ref), u113 (ref), u37 (ref), u4 (ref), u1 (copy), CommandRedeemable (copy)
    u112 = 0;
    u113 = nil;
    u37 = 0;
    local Text = u4.Down.TextBox.Text;

    if Text:find("`") then
        local v151 = Text:gsub("\t", ""):gsub("`", "");
        u4.Down.TextBox.Text = v151;
        u1.Open();

        return;
    end;

    local v152 = Text:gsub("\t", "");

    if v152 ~= u4.Down.TextBox.Text then
        u4.Down.TextBox.Text = v152;

        return;
    end;

    local v153 = v152:match("^(%S+)");

    if v152:find("%s") and (v153 and u1.GetCommand(v153)) then
        for _, child in ipairs(u4.Down.ScrollingFrame:GetChildren()) do
            if child:IsA("TextButton") and (child.Name ~= "_hint" and child.Name ~= "_usage") then
                child.Visible = false;
            end;
        end;

        u1.ShowHints(v153);

        return;
    end;

    u1.ClearHints();
    local v154 = v153 or "";

    for _, child in ipairs(u4.Down.ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") and (child.Name ~= "_hint" and child.Name ~= "_usage") then
            local v155;

            if v154 == "" or child.Name:lower():find(v154:lower(), 1, true) == nil then
                v155 = false;
            else
                v155 = CommandRedeemable(child.Name);
            end;

            child.Visible = v155;
        end;
    end;
end;

function u1.Open() -- Line: 1016
    -- upvalues: Players (copy), u4 (ref), u6 (ref), u1 (copy), u3 (ref), UserInputService (copy), u112 (ref), GetVisibleHints (copy), ApplyHint (copy), GetVisibleCommands (copy), u114 (ref), ResetHighlights (copy), u113 (ref), u37 (ref)
    if Players.LocalPlayer:GetAttribute("CanUseConsole") then
        u4.Visible = not u4.Visible;
        u6.SetFramePriority("Console", u4.Visible);

        if u4.Visible then
            u1.ReSizeConsole();
            u1.ConsoleDraggin();
            u1.RegisterCommand();
            u1.Tab();
            u3:Add("ConsoleSendCommand", UserInputService.InputEnded:Connect(function(p156) -- Line: 1030
                -- upvalues: u112 (ref), u4 (ref), u1 (ref), GetVisibleHints (ref), ApplyHint (ref), GetVisibleCommands (ref), u114 (ref), ResetHighlights (ref)
                if p156.KeyCode == Enum.KeyCode.Return then
                    if u112 > 0 then
                        local Text = u4.Down.TextBox.Text;
                        local v157 = Text:match("^(%S+)");

                        if Text:find("%s") and u1.GetCommand(v157) then
                            local v158 = GetVisibleHints()[u112];

                            if v158 then
                                ApplyHint(v158.Text);

                                return;
                            end;
                        else
                            local v159 = GetVisibleCommands()[u112];

                            if v159 then
                                u114 = true;
                                u4.Down.TextBox.Text = v159.Name .. " ";
                                u4.Down.TextBox.CursorPosition = #u4.Down.TextBox.Text + 1;
                                u112 = 0;
                                ResetHighlights();
                                u4.Down.TextBox:CaptureFocus();
                                u1.ShowHints(v159.Name);

                                return;
                            end;
                        end;
                    end;

                    u1.SendCommand();
                end;
            end));
            u3:Add("ConsoleSearch", u4.Down.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1062
                -- upvalues: u114 (ref), u1 (ref)
                if u114 then
                    u114 = false;

                    return;
                end;

                u1.RefreshInput();
            end));
            u3:Add("ConsoleCheatsWatch", workspace:GetAttributeChangedSignal("sv_cheats"):Connect(function() -- Line: 1073
                -- upvalues: u4 (ref), u1 (ref)
                if u4.Visible then
                    u1.RefreshInput();
                end;
            end));
            u3:Add("ConsoleOwnerWatch", Players.LocalPlayer:GetAttributeChangedSignal("IsServerOwner"):Connect(function() -- Line: 1079
                -- upvalues: u4 (ref), u1 (ref)
                if u4.Visible then
                    u1.RefreshInput();
                end;
            end));
            u3:Add("ConsoleClose", u4.Top.Close.MouseButton1Click:Connect(function() -- Line: 1085
                -- upvalues: u1 (ref)
                u1.Open();
            end));
            task.delay(0.1, function() -- Line: 1089
                -- upvalues: u4 (ref)
                u4.Down.TextBox:CaptureFocus();
            end);
        else
            u3:Cleanup();
            u1.ClearHints();
            u112 = 0;
            u113 = nil;
            u37 = 0;

            for _, v in pairs(u1) do
                if typeof(v) == "table" and v.Button then
                    u3:Removes((`ConsoleCommand_{v.Click}`));
                end;
            end;

            u4.Down.TextBox:ReleaseFocus();
        end;

        return u4.Visible;
    end;
end;

function u1.Init(p160) -- Line: 1111
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref)
    u2 = p160:GetModule("Gui");
    u3 = p160:GetModule("Maid").new();
    u5 = p160:GetModule("Network");
    u6 = p160:GetModule("BindsController");
    u7 = p160:GetModule("Roles");
    u8 = p160:GetModule("ConsoleShared");
    u9 = p160:GetModule("WeaponManager");
    u10 = p160:GetModule("SkinManager");
    u11 = p160:GetModule("ItemManager");
    u12 = p160:GetModule("GameConfiguration");
    u13 = p160:GetModule("GamepassesData");
    u14 = p160:GetModule("GamemodesData");
    u15 = p160:GetModule("Config");
    u16 = p160:GetModule("WeaponController");
end;

function u1.Start(p161) -- Line: 1129
    -- upvalues: u1 (copy), u5 (ref)
    u1.new();
    u5.ConsoleServer.On(function(p162) -- Line: 1132
        -- upvalues: u1 (ref)
        if p162.Exec then
            u1.RunClientCommand(p162.Exec, p162.Args);

            return;
        end;

        u1.CreateOutput(p162.Text, p162.Ok and Color3.fromRGB(0, 250, 0) or Color3.fromRGB(250, 0, 0));
    end);
    u1.RegisterSharedCommands();
end;

function u1.Dispatch(p163: any, p164: table, p165: string?) -- Line: 1159
    -- upvalues: u5 (ref), u1 (copy)
    if not u5.Console then
        u1.CreateOutput("console networking unavailable", Color3.fromRGB(250, 0, 0));

        return;
    end;

    local v166 = p165 or p163.Name;

    if not p165 and #p164 > 0 then
        v166 = v166 .. " " .. table.concat(p164, " ");
    end;

    u5.Console.Fire(v166);
end;

function u1.RunClientCommand(p167: string, p168: table?) -- Line: 1178
    -- upvalues: u8 (ref), Players (copy), u1 (copy)
    local v169 = u8.Get(p167);

    if not v169 or v169.Side ~= "Client" then
        return;
    end;

    local success, result = pcall(v169.Run, {
        Player = Players.LocalPlayer,
        Args = p168 or {},

        Reply = function(p170: string, p171) -- Line: 1187, Name: Reply
            -- upvalues: u1 (ref)
            u1.CreateOutput(p170, p171);
        end,

        GetModule = function(p172: string) -- Line: 1190, Name: GetModule
            -- upvalues: u1 (ref)
            return u1:GetModule(p172);
        end
    });

    if not success and result then
        u1.CreateOutput(tostring(result):gsub("^.+:%d+:%s*", ""), Color3.fromRGB(250, 0, 0));
    end;
end;

function u1.RegisterSharedCommands() -- Line: 1204
    -- upvalues: u7 (ref), Players (copy), u8 (ref), u1 (copy)
    local Rank = u7.GetRank(Players.LocalPlayer.UserId);

    for _, v in ipairs(u8.Commands) do
        local u173, v174;

        if u8.IsUnlockedCommand(v, Players.LocalPlayer.UserId) or (not v.Role or (v.AllowServerOwner or v.AllowCheats)) then
            u173 = v;
            v174 = { u173.Name };

            for i, v2 in ipairs(u173.Aliases or {}) do
                table.insert(v174, v2);
            end;

            for i, v2 in ipairs(v174) do
                if not u1[v2] then
                    u1.CreateCommand(v2, u173.Usage or v2, u173.Hints or {}, function(p175, p176) -- Line: 1246
                        -- upvalues: u1 (ref), u173 (copy)
                        u1.Dispatch(u173, p175, p176);
                    end, u173);
                end;
            end;
        else
            local v177 = typeof(v.Role) == "table" and v.Role or { v.Role };
            u173 = v;
            local v178 = false;

            for _, v2 in ipairs(v177) do
                if u7.HasRole(Players.LocalPlayer.UserId, v2) then
                    v178 = true;
                    break;
                end;

                local v179 = u7.Ranks[v2];

                if v179 and v179 <= Rank then
                    v178 = true;
                    break;
                end;
            end;

            if v178 then
                v174 = { u173.Name };

                for i, v2 in ipairs(u173.Aliases or {}) do
                    table.insert(v174, v2);
                end;

                for i, v2 in ipairs(v174) do
                    if not u1[v2] then
                        u1.CreateCommand(v2, u173.Usage or v2, u173.Hints or {}, function(p175, p176) -- Line: 1246
                            -- upvalues: u1 (ref), u173 (copy)
                            u1.Dispatch(u173, p175, p176);
                        end, u173);
                    end;
                end;
            end;
        end;
    end;
end;

function u1.new() -- Line: 1253
    -- upvalues: u2 (ref), u4 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Console";
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.307, 0.0400001);
    Frame.Size = UDim2.fromOffset(823, 589);
    Frame.Visible = false;
    Frame.ZIndex = 5;
    Frame.Parent = u2.Handler;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Shadow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://186491278";
    ImageLabel.ImageTransparency = 0.454875;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.Size = UDim2.new(1, 35, 1, 35);
    ImageLabel.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel.ZIndex = -9999;
    ImageLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Background";
    Frame2.BackgroundColor3 = Color3.fromRGB(35, 35, 35);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Down";
    Frame3.AnchorPoint = Vector2.new(0, 1);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0, 1);
    Frame3.Size = UDim2.new(1, 0, 0, 20);
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.Position = UDim2.new(0, 4, 0.5, 0);
    TextBox.Size = UDim2.new(0.975, -8, 0.8, 0);
    TextBox.Text = "";
    TextBox.PlaceholderText = "Enter command";
    TextBox.TextColor3 = Color3.new(1, 1, 1);
    TextBox.TextScaled = true;
    TextBox.ClearTextOnFocus = false;
    TextBox.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame3;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Resize";
    ImageButton.AnchorPoint = Vector2.new(1, 1);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Position = UDim2.fromScale(1, 1);
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(1, 1);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.new(1, -1, 1, -1);
    Frame4.Size = UDim2.new(0.75, -4, 0, 2);
    Frame4.Parent = ImageButton;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Frame";
    Frame5.AnchorPoint = Vector2.new(1, 1);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.new(1, -1, 1, -1);
    Frame5.Size = UDim2.new(0, 2, 0.75, -4);
    Frame5.Parent = ImageButton;
    ImageButton.Parent = Frame3;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ScrollingFrame";
    ScrollingFrame.Active = true;
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.Position = UDim2.fromScale(0, 1);
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 95, 94);
    ScrollingFrame.ScrollBarThickness = 6;
    ScrollingFrame.Size = UDim2.new(0.7, 0, 0, 180);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 1);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = ScrollingFrame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingRight = UDim.new(0, 6);
    UIPadding.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame3;
    Frame3.Parent = Frame;
    local ScrollingFrame2 = Instance.new("ScrollingFrame");
    ScrollingFrame2.Name = "ScrollingFrame";
    ScrollingFrame2.Active = true;
    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame2.BackgroundTransparency = 1;
    ScrollingFrame2.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame2.Position = UDim2.fromOffset(0, 22);
    ScrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(80, 95, 94);
    ScrollingFrame2.ScrollBarThickness = 6;
    ScrollingFrame2.Size = UDim2.new(1, 0, 1, -44);
    ScrollingFrame2.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0, 2);
    UIPadding2.PaddingLeft = UDim.new(0, 4);
    UIPadding2.PaddingRight = UDim.new(0, 8);
    UIPadding2.PaddingTop = UDim.new(0, 2);
    UIPadding2.Parent = ScrollingFrame2;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.Padding = UDim.new(0, 1);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Top;
    UIListLayout2.Parent = ScrollingFrame2;
    UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 1409
        -- upvalues: UIListLayout2 (copy), UIPadding2 (copy), ScrollingFrame2 (copy)
        local v180;

        if UIListLayout2.AbsoluteContentSize.Y + UIPadding2.PaddingTop.Offset + UIPadding2.PaddingBottom.Offset > ScrollingFrame2.AbsoluteSize.Y then
            v180 = Enum.VerticalAlignment.Top;
        else
            v180 = Enum.VerticalAlignment.Bottom;
        end;

        UIListLayout2.VerticalAlignment = v180;
        ScrollingFrame2.CanvasPosition = Vector2.new(0, 9999);
    end);
    ScrollingFrame2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 1401, Name: updateAlignment
        -- upvalues: UIListLayout2 (copy), UIPadding2 (copy), ScrollingFrame2 (copy)
        local v181;

        if UIListLayout2.AbsoluteContentSize.Y + UIPadding2.PaddingTop.Offset + UIPadding2.PaddingBottom.Offset > ScrollingFrame2.AbsoluteSize.Y then
            v181 = Enum.VerticalAlignment.Top;
        else
            v181 = Enum.VerticalAlignment.Bottom;
        end;

        UIListLayout2.VerticalAlignment = v181;
    end);
    local v182;

    if UIListLayout2.AbsoluteContentSize.Y + UIPadding2.PaddingTop.Offset + UIPadding2.PaddingBottom.Offset > ScrollingFrame2.AbsoluteSize.Y then
        v182 = Enum.VerticalAlignment.Top;
    else
        v182 = Enum.VerticalAlignment.Bottom;
    end;

    UIListLayout2.VerticalAlignment = v182;
    ScrollingFrame2.Parent = Frame;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Top";
    TextButton.Active = false;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52);
    TextButton.BorderColor3 = Color3.new();
    TextButton.BorderSizePixel = 0;
    TextButton.Size = UDim2.new(1, 0, 0, 22);
    TextButton.TextTransparency = 1;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0, 4, 0.5, 0);
    TextLabel.Size = UDim2.new(0.25, 4, 0.85, 0);
    TextLabel.Text = "CONSOLE";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel.Parent = TextButton;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Close";
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.BackgroundTransparency = 1;
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextButton2.Position = UDim2.new(1, -2, 0.5, 0);
    TextButton2.Size = UDim2.fromScale(0.8, 0.8);
    TextButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton2.Text = "x";
    TextButton2.TextColor3 = Color3.fromRGB(197, 197, 197);
    TextButton2.TextScaled = true;
    TextButton2.Parent = TextButton;
    TextButton.Parent = Frame;
    u4 = Frame;
end;

function u1.newOutput() -- Line: 1472
    local TextLabel = Instance.new("TextLabel");
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.TextColor3 = Color3.new(255, 255, 255);
    TextLabel.TextSize = 16;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Size = UDim2.new(1, 0, 0, 16);
    TextLabel.Text = "";

    return TextLabel;
end;

return u1;