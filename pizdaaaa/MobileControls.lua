-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.MobileControls
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.MobileControls
-- Decompile time: 37.19 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
game:GetService("HttpService");
game:GetService("Lighting");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local TextChatService = game:GetService("TextChatService");
local LocalPlayer = Players.LocalPlayer;
local _ = workspace.CurrentCamera;
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
local u17 = nil;
TweenInfo.new(0.25);
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = {};
local u23 = {};
local u24 = nil;
local u25 = {};
local u26 = false;
local u27 = nil;
local u28 = "Both";
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = false;
local u34 = nil;
local u35 = nil;
local u36 = "Classic";
local u37 = "Fixed";
local u38 = false;
local u39 = true;
local u40 = nil;
local u41 = nil;
local OverlapParams_new_ret = OverlapParams.new();
OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local u42 = { "Equip Primary", "Equip Secondary", "Equip Melee", "Cycle Grenades", "Equip Bomb" };
local u43 = { {
        Bind = "Equip Primary",
        Slots = { 1 }
    }, {
        Bind = "Equip Secondary",
        Slots = { 2 }
    }, {
        Bind = "Equip Melee",
        Slots = { 3 }
    }, {
        Bind = "Cycle Grenades",
        Slots = { 4, 5, 6, 7 }
    }, {
        Bind = "Equip Bomb",
        Slots = { 8 }
    } };
local TweenInfo_new_ret = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local TweenInfo_new_ret3 = TweenInfo.new(0.12);
local TweenInfo_new_ret4 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1);
local u44 = { 0.55, 0.65, 0.7, 0.75, 0.8, 0.85, 0.875 };
local u45 = {
    Pickup = "PICK UP",
    Defuse = "DEFUSE",
    Plant = "PLANT"
};
local u46 = {
    Scope = "SCOPE",
    ScopeRifle = "SCOPE",
    Silencer = "SILENCER",
    Burst = "BURST"
};
local u47 = {
    ["Spectate Mode"] = true,
    ["Spectate Previous"] = true,
    ["Spectate Next"] = true
};
local u48 = {
    Thumbstick = true,
    MainMenu = true,
    Scoreboard = true,
    Chat = true,
    ["Team Chat"] = true,
    ["Team Selection"] = true
};
local u49 = {
    Buymenu = true,
    MainMenu = true,
    Scoreboard = true,
    Chat = true,
    ["Team Chat"] = true,
    ["Team Selection"] = true
};
local u50 = false;
local u51 = false;
local u52 = false;
local u53 = false;
local u54 = Vector3.new(0, 0, 0);
local u55 = {
    ["Character Use"] = "Character Pickup",
    ["Character Pickup"] = "Character Pickup",
    TeamChat = "Team Chat",
    ["Team Chat"] = "Team Chat"
};

local function NormalizeSettingName(p56: string) -- Line: 141
    -- upvalues: u55 (copy)
    return u55[p56] or p56;
end;

local function CheckChatPolicy() -- Line: 145
    -- upvalues: LocalPlayer (copy), TextChatService (copy)
    if not LocalPlayer then
        return false;
    end;

    local success, result = pcall(function() -- Line: 150
        -- upvalues: TextChatService (ref), LocalPlayer (ref)
        return TextChatService:CanUserChatAsync(LocalPlayer.UserId);
    end);

    if success then
        return result == true;
    end;

    local success2, result2 = pcall(function() -- Line: 158
        -- upvalues: LocalPlayer (ref)
        return game:GetService("Chat"):CanUserChatAsync(LocalPlayer.UserId);
    end);

    if success2 then
        return result2 == true;
    end;

    return false;
end;

local function ApplyButtonTransparency(p57: any, p58: boolean, p59: any) -- Line: 168
    if not p57 then
        return;
    end;

    local v60;

    if p59 and p59.Hidden == true then
        v60 = true;
    else
        v60 = p59 and p59.Transparency and p59.Transparency >= 1;
    end;

    local v61 = v60 and 1 or (p59 and p59.Transparency or 0.5);

    if p58 then
        if p57:FindFirstChild("Ring") then
            p57.Ring.ImageTransparency = v61;
        end;

        if p57:FindFirstChild("Disk") then
            p57.Disk.ImageTransparency = v61;
        end;

        if p57:FindFirstChild("Stick") then
            p57.Stick.ImageTransparency = v61;
        end;
    else
        if p57:FindFirstChild("Disk") then
            p57.Disk.ImageColor3 = Color3.new(0, 0, 0);
            p57.Disk.ImageTransparency = v61;
        end;

        if p57:FindFirstChild("Ring") then
            p57.Ring.ImageColor3 = Color3.new(1, 1, 1);
            p57.Ring.ImageTransparency = v61;
        end;

        if p57:FindFirstChild("Decal") then
            p57.Decal.ImageColor3 = Color3.new(1, 1, 1);
            p57.Decal.ImageTransparency = v61;
        end;

        if p57:FindFirstChild("Title") then
            p57.Title.TextColor3 = Color3.new(1, 1, 1);
            p57.Title.TextTransparency = v61;
        end;
    end;
end;

local function ApplyBarTransparency(p62, p63) -- Line: 197
    p62.Strip.GroupTransparency = (p63.Hidden == true and true or p63.Transparency >= 1) and 1 or math.clamp((p63.Transparency - 0.5) * 2, 0, 1);
end;

local function ApplyZoneVisual(p64: any, p65: any, p66: boolean) -- Line: 202
    -- upvalues: TweenService (copy), TweenInfo_new_ret3 (copy)
    local v67 = (p65.Hidden == true and true or p65.Transparency >= 1) and 0 or 1 - p65.Transparency;
    TweenService:Create(p64.Fill, TweenInfo_new_ret3, {
        BackgroundTransparency = 1 - v67 * (p66 and 0.18 or 0.06)
    }):Play();
    TweenService:Create(p64.Fill.Stroke, TweenInfo_new_ret3, {
        Transparency = 1 - v67 * (p66 and 0.6 or 0.3)
    }):Play();
end;

local function CallBind(p68: string, p69: userdata) -- Line: 210
    -- upvalues: u19 (copy)
    local v70 = u19[p68];

    if v70 then
        v70(p68, Enum.UserInputState.Begin, p69);
    end;
end;

local function CardAt(p71) -- Line: 217
    -- upvalues: u25 (copy)
    for _, v in u25 do
        local Frame = v.Frame;

        if Frame.Visible then
            local AbsolutePosition = Frame.AbsolutePosition;
            local v72 = AbsolutePosition + Frame.AbsoluteSize;

            if p71.X >= AbsolutePosition.X and (p71.X <= v72.X and (p71.Y >= AbsolutePosition.Y and p71.Y <= v72.Y)) then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function QueueWeaponBar() -- Line: 234
    -- upvalues: u26 (ref), u24 (ref), u1 (copy)
    if u26 or not u24 then
        return;
    end;

    u26 = true;
    task.defer(u1.UpdateWeaponBar);
end;

local function UpdateVisibility(p73) -- Line: 243
    -- upvalues: u55 (copy), u18 (copy), u47 (copy), u50 (ref), u51 (ref), u48 (copy), u49 (copy), u20 (copy)
    local v74 = u55[p73] or p73;
    local v75 = u18[v74];

    if not v75 then
        return;
    end;

    if u47[v74] then
        v75.Visible = u50 and not u51;

        return;
    end;

    local v76;

    if u50 and u48[v74] ~= true then
        v76 = false;
    else
        v76 = not u51 or u49[v74] == true;
    end;

    if u20[v74] ~= true then
        v76 = false;
    end;

    v75.Visible = v76;
end;

function u1.Draw() -- Line: 261
    -- upvalues: u8 (ref), u39 (ref), u4 (ref), u1 (copy), u35 (ref), ApplyZoneVisual (copy), TweenService (copy), u21 (copy), u3 (ref), u22 (copy), u29 (ref), u28 (ref), u19 (copy), u55 (copy), UserInputService (copy), u10 (ref), u23 (copy), u40 (ref), ApplyButtonTransparency (copy), u18 (copy), u52 (ref), u20 (copy), u53 (ref), u47 (copy), u50 (ref), u51 (ref), u48 (copy), u49 (copy)
    local v77 = u8:GetPlayerSettings().Controls["Mobile Buttons"];
    local v78 = v77["Rotate Camera with Fire Button"];

    if v78 ~= nil then
        u39 = v78 == true;
    end;

    u8:AddConnection("Controls", "Mobile Buttons", "Rotate Camera with Fire Button", function(p79) -- Line: 269
        -- upvalues: u39 (ref)
        u39 = p79 == true;
    end);

    for i, v in u4.GetData().Controls["Mobile Buttons"] do
        if v.MobileControls then
            local v80 = v77[i];
            local u81 = v80;
            local Position = v80.Position;
            local Size = v80.Size;
            local u82;

            if i == "Thumbstick" then
                u82 = u1.thumbstick(UDim2.fromScale(Position[1], Position[2]), Size);
                u35 = u81;
                local v83 = u82;
                local v84 = u81;

                if v83 then
                    local v85;

                    if v84 and v84.Hidden == true then
                        v85 = true;
                    else
                        v85 = v84 and v84.Transparency and v84.Transparency >= 1;
                    end;

                    local v86 = v85 and 1 or (v84 and v84.Transparency or 0.5);

                    if v83:FindFirstChild("Ring") then
                        v83.Ring.ImageTransparency = v86;
                    end;

                    if v83:FindFirstChild("Disk") then
                        v83.Disk.ImageTransparency = v86;
                    end;

                    if v83:FindFirstChild("Stick") then
                        v83.Stick.ImageTransparency = v86;
                    end;
                end;
            elseif i == "Weapon Bar" then
                u82 = u1.weaponBar(UDim2.fromScale(Position[1], Position[2]), Size, v.Aspect);
                local v87 = u81;
                u82.Strip.GroupTransparency = (v87.Hidden == true and true or v87.Transparency >= 1) and 1 or math.clamp((v87.Transparency - 0.5) * 2, 0, 1);
            else
                local u88;

                if v.Zone then
                    u82 = u1.zone(UDim2.fromScale(Position[1], Position[2]), Size, v.Aspect);

                    u88 = function(p89: boolean) -- Line: 297
                        -- upvalues: ApplyZoneVisual (ref), u82 (ref), u81 (ref)
                        ApplyZoneVisual(u82, u81, p89);
                    end;
                else
                    u82 = u1.template(UDim2.fromScale(Position[1], Position[2]), Size, v.Decal, v.Title);

                    u88 = function(p90: boolean) -- Line: 303
                        -- upvalues: u81 (ref), u82 (ref), v (copy), Size (ref), TweenService (ref)
                        local v91;

                        if u81 and u81.Hidden == true then
                            v91 = true;
                        else
                            v91 = u81 and u81.Transparency and u81.Transparency >= 1;
                        end;

                        if v91 then
                            if u82:FindFirstChild("Disk") then
                                u82.Disk.ImageTransparency = 1;
                            end;

                            if u82:FindFirstChild("Ring") then
                                u82.Ring.ImageTransparency = 1;
                            end;

                            if u82:FindFirstChild("Decal") then
                                u82.Decal.ImageTransparency = 1;
                            end;

                            if u82:FindFirstChild("Title") then
                                u82.Title.TextTransparency = 1;
                            end;

                            return;
                        end;

                        local v92 = u81 and u81.Transparency or 0.5;

                        if v.Decal then
                            if u82:FindFirstChild("Decal") then
                                u82.Decal.ImageColor3 = p90 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1);
                                u82.Decal.ImageTransparency = v92;
                            end;
                        elseif u82:FindFirstChild("Title") then
                            u82.Title.TextColor3 = p90 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1);
                            u82.Title.TextTransparency = v92;
                        end;

                        if u82:FindFirstChild("Disk") then
                            u82.Disk.ImageColor3 = p90 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
                            u82.Disk.ImageTransparency = v92;
                        end;

                        if u82:FindFirstChild("Ring") then
                            u82.Ring.ImageColor3 = p90 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1);
                            u82.Ring.ImageTransparency = v92;
                        end;

                        local v93 = (u81 and u81.Size or Size) * (p90 and 0.92 or 1);
                        TweenService:Create(u82, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.fromScale(v93, v93)
                        }):Play();
                    end;

                    if i == "Character Pickup" then
                        u1.pulse(u82);
                    end;
                end;

                u88(false);
                u21[i] = u88;
                local u94 = nil;
                local u95 = nil;
                u3:Add(`{i}_InputBegan`, u82.InputBegan:Connect(function(p96: userdata) -- Line: 355
                    -- upvalues: u94 (ref), u22 (ref), i (copy), u88 (ref), u29 (ref), u28 (ref), v (copy), u95 (ref), u19 (ref), u55 (ref)
                    if p96.UserInputType ~= Enum.UserInputType.Touch and p96.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return;
                    end;

                    if p96.UserInputState ~= Enum.UserInputState.Begin then
                        return;
                    end;

                    u94 = p96;
                    u22[i] = true;
                    u88(true);
                    local v97 = i == "Character Pickup" and (u29 == "Plant" and u28 ~= "Off") and "Weapon Fire" or (v.Bind or i);
                    u95 = u19[v97] or u19[u55[v97] or v97];

                    if u95 then
                        u95(i, Enum.UserInputState.Begin, p96);
                    end;
                end));

                if v.AllowCameraDrag or (i == "Weapon Fire" or (i == "Weapon Alt Function" or i == "Character Pickup")) then
                    u3:Add(`{i}_InputChanged`, UserInputService.InputChanged:Connect(function(p98: userdata) -- Line: 376
                        -- upvalues: u94 (ref), i (copy), v (copy), u39 (ref), u10 (ref)
                        if p98 == u94 and p98.UserInputType == Enum.UserInputType.Touch then
                            if not (i ~= "Weapon Fire" and (i ~= "Fire Zone" and not v.Zone) or u39) then
                                return;
                            end;

                            if u10 and u10.AddTouchDelta then
                                u10.AddTouchDelta(p98.Delta);
                            end;
                        end;
                    end));
                end;

                u3:Add(`{i}_InputEnded`, UserInputService.InputEnded:Connect(function(p99: userdata) -- Line: 388
                    -- upvalues: u94 (ref), u22 (ref), i (copy), u88 (ref), u23 (ref), u95 (ref)
                    if not u94 then
                        return;
                    end;

                    local v100;

                    if u94.UserInputType == Enum.UserInputType.MouseButton1 then
                        v100 = p99.UserInputType == Enum.UserInputType.MouseButton1;
                    else
                        v100 = false;
                    end;

                    if p99 == u94 or v100 then
                        u94 = nil;
                        u22[i] = nil;
                        u88(u23[i] == true);

                        if u95 then
                            u95(i, Enum.UserInputState.End, p99);
                            u95 = nil;
                        end;
                    end;
                end));
            end;

            u8:AddConnection("Controls", "Mobile Buttons", i, function(p101) -- Line: 409
                -- upvalues: u81 (ref), Position (ref), Size (ref), u82 (ref), v (copy), i (copy), u35 (ref), u40 (ref), ApplyZoneVisual (ref), u22 (ref), ApplyButtonTransparency (ref)
                u81 = p101;
                Position = p101.Position;
                Size = p101.Size;
                u82.Size = UDim2.fromScale(Size * (v.Aspect or 1), Size);
                u82.Position = UDim2.fromScale(Position[1], Position[2]);

                if i == "Thumbstick" then
                    u35 = p101;
                    u40();

                    return;
                end;

                if i == "Weapon Bar" then
                    u82.Strip.GroupTransparency = (p101.Hidden == true and true or p101.Transparency >= 1) and 1 or math.clamp((p101.Transparency - 0.5) * 2, 0, 1);

                    return;
                end;

                if v.Zone then
                    ApplyZoneVisual(u82, p101, u22[i] == true);

                    return;
                end;

                ApplyButtonTransparency(u82, false, p101);
            end);
            u18[i] = u82;

            if (i == "Chat" or i == "Team Chat") and u52 then
                u20[i] = u53;
            else
                u20[i] = not v.DisabledByDefault;
            end;

            local v102 = i;
            local v103 = u55[v102] or v102;
            local v104 = u18[v103];

            if v104 then
                if u47[v103] then
                    v104.Visible = u50 and not u51;
                else
                    local v105;

                    if u50 and u48[v103] ~= true then
                        v105 = false;
                    else
                        v105 = not u51 or u49[v103] == true;
                    end;

                    if u20[v103] ~= true then
                        v105 = false;
                    end;

                    v104.Visible = v105;
                end;
            end;
        end;
    end;

    u1.DrawThumbstick();
    u1.DrawWeaponBar();
end;

function u1.SetButtonCallback(p106, p107) -- Line: 440
    -- upvalues: u55 (copy), u19 (copy)
    u19[u55[p106] or p106] = p107;
    u19[p106] = p107;
end;

function u1.Enabled(p108, p109) -- Line: 446
    -- upvalues: u55 (copy), u18 (copy), u20 (copy), u47 (copy), u50 (ref), u51 (ref), u48 (copy), u49 (copy)
    local v110 = u55[p108] or p108;

    if not u18[v110] then
        return;
    end;

    u20[v110] = p109;
    local v111 = u55[v110] or v110;
    local v112 = u18[v111];

    if not v112 then
        return;
    end;

    if u47[v111] then
        v112.Visible = u50 and not u51;

        return;
    end;

    local v113;

    if u50 and u48[v111] ~= true then
        v113 = false;
    else
        v113 = not u51 or u49[v111] == true;
    end;

    if u20[v111] ~= true then
        v113 = false;
    end;

    v112.Visible = v113;
end;

u1.Enable = u1.Enabled;

function u1.SetLatched(p114: any, p115: boolean) -- Line: 457
    -- upvalues: u23 (copy), u21 (copy), u22 (copy)
    u23[p114] = p115;
    local v116 = u21[p114];

    if v116 then
        v116(p115 or u22[p114] == true);
    end;
end;

function u1.LayoutHidden(p117: string, p118: any) -- Line: 466
    -- upvalues: u1 (copy)
    if p117 == "Weapon Fire" then
        return p118["Fire Mode"] == "Zone";
    end;

    if p117 == "Fire Zone" then
        return p118["Fire Mode"] == "Button";
    end;

    return u1.SwitchHidden(p117, p118["Weapon Switching"]);
end;

function u1.SetFireMode(p119: string) -- Line: 476
    -- upvalues: u1 (copy)
    u1.Enabled("Weapon Fire", p119 ~= "Zone");
    u1.Enabled("Fire Zone", p119 ~= "Button");
end;

local function RefreshInteract() -- Line: 481
    -- upvalues: u18 (copy), u8 (ref), u29 (ref), u28 (ref), u22 (copy), u33 (ref), u45 (copy), u30 (ref), u1 (copy), u32 (ref), TweenService (copy), TweenInfo_new_ret4 (copy)
    local v120 = u18["Character Pickup"];
    local v121 = u8:GetPlayerSettings().Controls["Mobile Buttons"]["Character Pickup"];
    local v122;

    if u29 == nil then
        v122 = false;
    else
        v122 = u28 ~= "Off";
    end;

    local v123 = u22["Character Pickup"] == true;
    local v124 = u28 == "Auto Hide" and true or u28 == "Both";
    local v125;

    if v124 then
        v125 = not v122 and v123;
    else
        v125 = v124;
    end;

    u33 = v125;
    v120.Title.Text = v122 and u45[u29] or u30;
    u1.Enabled("Character Pickup", v122 or (v123 or not v124));

    if u32 then
        u32:Cancel();
        u32 = nil;
    end;

    v120.Pulse.ImageTransparency = 1;

    if v122 and (u28 == "Pulse" or u28 == "Both") and (v121.Hidden ~= true and v121.Transparency < 1) then
        v120.Pulse.Size = UDim2.fromScale(1, 1);
        v120.Pulse.ImageTransparency = 0.35;
        u32 = TweenService:Create(v120.Pulse, TweenInfo_new_ret4, {
            ImageTransparency = 1,
            Size = UDim2.fromScale(1.45, 1.45)
        });
        u32:Play();
    end;
end;

local function RefreshAltTitle(p126) -- Line: 509
    -- upvalues: u18 (copy), u46 (copy), u31 (ref)
    local v127;

    if p126 then
        v127 = p126.Data.AltFunction;
    else
        v127 = p126;
    end;

    u18["Weapon Alt Function"].Title.Text = v127 and u46[v127.Name] or (p126 and p126.Data.Type == "Melee" and "STAB" or u31);
end;

local function FindContext() -- Line: 515
    -- upvalues: u12 (ref), u16 (ref), u17 (ref), u11 (ref), u13 (ref), u34 (ref), OverlapParams_new_ret (copy), u15 (ref)
    local Character = u12.GetCharacter();

    if Character then
        Character = Character.Simulation;
    end;

    if not Character then
        return nil;
    end;

    local AllCategoryEntities = u16.GetAllCategoryEntities("Bomb");

    if AllCategoryEntities and u17.Get("Bomb", "CanDefuse")[Character.Team] then
        local Position = u11.GetCFrame().Position;
        local v128 = u17.Get("Bomb", "DefuseRange");

        for _, v in AllCategoryEntities do
            if not (v.Defused or v.Exploded) then
                local v129 = v.Model.PrimaryPart.Position - Position;

                if Vector2.new(v129.X, v129.Z).Magnitude <= v128 and v129.Magnitude <= v128 * 72 / 62 then
                    return "Defuse";
                end;
            end;
        end;
    end;

    local CurrentWeapon = u13.GetCurrentWeapon();

    if CurrentWeapon and (CurrentWeapon.Data.Type == "Bomb" and u17.Get("Bomb", "CanPlant")[Character.Team]) then
        local Map = workspace:FindFirstChild("Map");

        if Map then
            Map = Map:FindFirstChild("Zones");
        end;

        if Map then
            Map = Map:FindFirstChild("Plants");
        end;

        if Map then
            if u34 ~= Map then
                u34 = Map;
                OverlapParams_new_ret.FilterDescendantsInstances = { Map };
            end;

            if #workspace:GetPartBoundsInBox(CFrame.new(Character.Position), u17.Get("Character", "StandCollisionSize"), OverlapParams_new_ret) > 0 then
                return "Plant";
            end;
        end;
    end;

    return u15.GetTarget() and "Pickup" or nil;
end;

function u1.SetInteractMode(p130: string) -- Line: 564
    -- upvalues: u28 (ref), RefreshInteract (copy)
    u28 = p130;
    RefreshInteract();
end;

function u1.SwitchHidden(p131: string, p132: string) -- Line: 569
    -- upvalues: u42 (copy)
    if p131 == "Weapon Bar" then
        return p132 == "Number Buttons";
    end;

    local v133;

    if table.find(u42, p131) == nil then
        v133 = false;
    else
        v133 = p132 ~= "Number Buttons";
    end;

    return v133;
end;

function u1.SetSwitchMode(p134: string) -- Line: 577
    -- upvalues: u27 (ref), u42 (copy), u1 (copy), u26 (ref), u24 (ref)
    u27 = p134;

    for _, v in { "Weapon Bar", unpack(u42) } do
        u1.Enabled(v, not u1.SwitchHidden(v, p134));
    end;

    if not u26 then
        if not u24 then
            return;
        end;

        u26 = true;
        task.defer(u1.UpdateWeaponBar);
    end;
end;

function u1.UpdateWeaponBar() -- Line: 587
    -- upvalues: u26 (ref), u13 (ref), u27 (ref), u25 (copy), u14 (ref), TweenService (copy), TweenInfo_new_ret (copy), u24 (ref)
    u26 = false;
    local WeaponInventory = u13.GetWeaponInventory();
    local CurrentWeapon = u13.GetCurrentWeapon();

    if CurrentWeapon then
        CurrentWeapon = CurrentWeapon.Slot;
    end;

    local v135 = u27 == "Swipe Button";

    for _, v in u25 do
        local Frame = v.Frame;
        local v136 = v;
        local v137 = 0;
        local v138 = nil;

        for _, v2 in v.Slots do
            local v139 = WeaponInventory[v2];

            if v139 then
                v137 = v137 + 1;

                if not v138 or v2 == CurrentWeapon then
                    v138 = v139;
                end;
            end;
        end;

        local v140 = table.find(v136.Slots, CurrentWeapon) ~= nil;
        local v141;

        if v138 == nil then
            v141 = false;
        else
            v141 = not v135 or v140;
        end;

        Frame.Visible = v141;

        if v138 then
            Frame.Icon.Image = `rbxassetid://{u14.Get(v138.Name).GuiInformation.Icon}`;
            Frame.Count.Text = `x{v137}`;
            Frame.Count.Visible = v137 > 1;
        end;

        if v136.Selected ~= v140 then
            v136.Selected = v140;
            TweenService:Create(Frame, TweenInfo_new_ret, {
                BackgroundTransparency = v140 and 0.3 or 0.6
            }):Play();
            TweenService:Create(Frame.UIStroke, TweenInfo_new_ret, {
                Transparency = v140 and 0.35 or 0.85
            }):Play();
            TweenService:Create(Frame.Icon, TweenInfo_new_ret, {
                ImageTransparency = v140 and 0 or 0.45
            }):Play();
            TweenService:Create(Frame.Accent, TweenInfo_new_ret, {
                Size = UDim2.new(v140 and 0.5 or 0, 0, 0, 2)
            }):Play();
        end;
    end;

    u24.Hint.Visible = v135;
end;

function u1.DrawWeaponBar() -- Line: 634
    -- upvalues: u24 (ref), u18 (copy), u43 (copy), u25 (copy), u3 (ref), u27 (ref), CardAt (copy), u19 (copy), UserInputService (copy)
    u24 = u18["Weapon Bar"];

    for i, v in u43 do
        u25[i] = {
            Frame = u24.Strip[tostring(i)],
            Slots = v.Slots,
            Bind = v.Bind
        };
    end;

    local u142 = nil;
    local u143 = nil;
    local Vector2_zero = Vector2.zero;
    u3:Add("WeaponBar_InputBegan", u24.InputBegan:Connect(function(p144: userdata) -- Line: 649
        -- upvalues: u142 (ref), Vector2_zero (ref), u143 (ref), u27 (ref), CardAt (ref), u19 (ref)
        if p144.UserInputType ~= Enum.UserInputType.Touch and p144.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p144.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        if u142 and (u142.UserInputState == Enum.UserInputState.Begin or u142.UserInputState == Enum.UserInputState.Change) then
            return;
        end;

        u142 = p144;
        Vector2_zero = Vector2.new(p144.Position.X, p144.Position.Y);
        local v145;

        if u27 == "Swipe Button" then
            v145 = nil;
        else
            v145 = CardAt(Vector2_zero) or nil;
        end;

        u143 = v145;

        if u143 then
            local Bind = u143.Bind;
            local v146 = u19[Bind];

            if v146 then
                v146(Bind, Enum.UserInputState.Begin, p144);
            end;
        end;
    end));
    u3:Add("WeaponBar_InputEnded", UserInputService.InputEnded:Connect(function(p147: userdata) -- Line: 671
        -- upvalues: u142 (ref), u143 (ref), Vector2_zero (ref), u24 (ref), u19 (ref), u27 (ref)
        local v148;

        if u142 == nil or u142.UserInputType ~= Enum.UserInputType.MouseButton1 then
            v148 = false;
        else
            v148 = p147.UserInputType == Enum.UserInputType.MouseButton1;
        end;

        if not (p147 == u142 or v148) then
            return;
        end;

        u142 = nil;

        if u143 then
            u143 = nil;

            return;
        end;

        local v149 = p147.Position.X - Vector2_zero.X;

        if math.abs(v149) >= u24.AbsoluteSize.Y * 0.6 then
            local v150 = v149 > 0 and "Weapon Switch Down" or "Weapon Switch Up";
            local v151 = u19[v150];

            if v151 then
                v151(v150, Enum.UserInputState.Begin, p147);
            end;
        else
            local v152 = u27 == "Swipe Button" and u19["Weapon Switch Down"];

            if v152 then
                v152("Weapon Switch Down", Enum.UserInputState.Begin, p147);
            end;
        end;
    end));
end;

function u1.SetSpectating(p153: boolean) -- Line: 696
    -- upvalues: u50 (ref), u18 (copy), u55 (copy), u47 (copy), u51 (ref), u48 (copy), u49 (copy), u20 (copy)
    u50 = p153;

    for i in u18 do
        local v154 = u55[i] or i;
        local v155 = u18[v154];

        if v155 then
            if u47[v154] then
                v155.Visible = u50 and not u51;
            else
                local v156;

                if u50 and u48[v154] ~= true then
                    v156 = false;
                else
                    v156 = not u51 or u49[v154] == true;
                end;

                if u20[v154] ~= true then
                    v156 = false;
                end;

                v155.Visible = v156;
            end;
        end;
    end;
end;

function u1.SetBuymenuOpen(p157: boolean) -- Line: 704
    -- upvalues: u51 (ref), u54 (ref), u18 (copy), u55 (copy), u47 (copy), u50 (ref), u48 (copy), u49 (copy), u20 (copy)
    u51 = p157 == true;

    if u51 then
        u54 = Vector3.new(0, 0, 0);
    end;

    for i in u18 do
        local v158 = u55[i] or i;
        local v159 = u18[v158];

        if v159 then
            if u47[v158] then
                v159.Visible = u50 and not u51;
            else
                local v160;

                if u50 and u48[v158] ~= true then
                    v160 = false;
                else
                    v160 = not u51 or u49[v158] == true;
                end;

                if u20[v158] ~= true then
                    v160 = false;
                end;

                v159.Visible = v160;
            end;
        end;
    end;
end;

function u1.GetMoveVector() -- Line: 715
    -- upvalues: u51 (ref), u54 (ref)
    return u51 and Vector3.new(0, 0, 0) or u54;
end;

function u1.DrawThumbstick() -- Line: 722
    -- upvalues: u18 (copy), u1 (copy), u44 (copy), u54 (ref), u35 (ref), u37 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u38 (ref), u36 (ref), TweenInfo_new_ret (copy), u41 (ref), u40 (ref), u3 (ref), UserInputService (copy), RunService (copy), GuiService (copy)
    local Thumbstick = u18.Thumbstick;
    local Stick = Thumbstick.Stick;
    local Dynamic = Thumbstick.Dynamic;
    local u161 = u1.thumbstickArea();
    local u162 = {};

    for i = 1, #u44 do
        u162[i] = Dynamic[`Middle{i}`];
        local _ = i;
    end;

    local u163 = nil;
    local Vector2_zero = Vector2.zero;
    local u164 = nil;
    u54 = Vector3.new(0, 0, 0);

    local function DoMove(p165) -- Line: 742
        -- upvalues: u54 (ref)
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            workspace_CurrentCamera = workspace_CurrentCamera.ViewportSize;
        end;

        if workspace_CurrentCamera then
            workspace_CurrentCamera = math.min(workspace_CurrentCamera.X, workspace_CurrentCamera.Y) > 500;
        end;

        local v166 = workspace_CurrentCamera and 40 or 20;
        local Magnitude = p165.Magnitude;

        if Magnitude < (workspace_CurrentCamera and 4 or 2) then
            u54 = Vector3.new(0, 0, 0);

            return;
        end;

        local v167 = 1 - math.max(0, (v166 - Magnitude) / v166);
        local Unit = p165.Unit;
        u54 = vector.create(Unit.X * v167, 0, Unit.Y * v167);
    end;

    local function RestPosition() -- Line: 759
        -- upvalues: u35 (ref)
        return UDim2.fromScale(u35.Position[1], u35.Position[2]);
    end;

    local function RefreshArea() -- Line: 763
        -- upvalues: u161 (copy), u37 (ref), Thumbstick (copy)
        local v168;

        if u37 == "Dynamic" then
            v168 = Thumbstick.Visible;
        else
            v168 = false;
        end;

        u161.Visible = v168;
    end;

    local function Fade(p169: boolean) -- Line: 767
        -- upvalues: u35 (ref), TweenService (ref), Dynamic (copy), TweenInfo_new_ret2 (ref), u162 (copy), u44 (ref)
        local v170 = (u35.Hidden == true or u35.Transparency >= 1) and 1 or math.max(u35.Transparency, 0.4);
        TweenService:Create(Dynamic.Start, TweenInfo_new_ret2, {
            BackgroundTransparency = p169 and 0.4 or v170
        }):Play();
        TweenService:Create(Dynamic.End.Stroke, TweenInfo_new_ret2, {
            Transparency = p169 and 0 or v170
        }):Play();
        TweenService:Create(Dynamic.End.Center, TweenInfo_new_ret2, {
            BackgroundTransparency = p169 and 0 or v170
        }):Play();

        for i, v in u162 do
            TweenService:Create(v, TweenInfo_new_ret2, {
                BackgroundTransparency = p169 and u44[i] or 1
            }):Play();
        end;
    end;

    local function LayoutMiddles(p171) -- Line: 779
        -- upvalues: Thumbstick (copy), u162 (copy)
        local v172 = Thumbstick.AbsoluteSize.X / 74;
        local v173 = 10 * v172;
        local v174 = 14 * v172;
        local v175 = 45 * v172 / 2 + v173;
        local v176 = p171.Magnitude - 20 * v172 / 2 - v173;
        local v177 = p171.Magnitude > 0 and p171.Unit or Vector2.zero;

        if v174 * #u162 < v176 then
            v174 = v176 / #u162;
        end;

        for i, v in u162 do
            local v178 = v175 + v174 * (i - 1);
            local v179 = v175 + v174 * (i - 2) < v176;
            v.Visible = v179;

            if v179 then
                local v180 = p171 - v177 * v178;
                local math_clamp_ret = math.clamp(1 - (v178 - v176) / v174, 0, 1);
                v.Position = UDim2.new(0.5, v180.X, 0.5, v180.Y);
                v.Size = UDim2.fromOffset(v173 * math_clamp_ret, v173 * math_clamp_ret);
            end;
        end;
    end;

    local function Place(p181) -- Line: 807
        -- upvalues: Thumbstick (copy)
        local contextButtons_AbsolutePosition = contextButtons.AbsolutePosition;
        Thumbstick.Position = UDim2.fromOffset(p181.X - contextButtons_AbsolutePosition.X, p181.Y - contextButtons_AbsolutePosition.Y);
    end;

    local function MoveStick(p182) -- Line: 813
        -- upvalues: Thumbstick (copy), Vector2_zero (ref), u38 (ref), DoMove (copy), u36 (ref), Dynamic (copy), LayoutMiddles (copy), Stick (copy)
        local v183 = Thumbstick.AbsoluteSize.X / 2;
        local v184 = p182 - Vector2_zero;

        if u38 and v183 < v184.Magnitude then
            Vector2_zero = p182 - v184.Unit * v183;
            v184 = p182 - Vector2_zero;
            local v185 = Vector2_zero;
            local contextButtons_AbsolutePosition = contextButtons.AbsolutePosition;
            Thumbstick.Position = UDim2.fromOffset(v185.X - contextButtons_AbsolutePosition.X, v185.Y - contextButtons_AbsolutePosition.Y);
        end;

        DoMove(v184);

        if u36 == "Dynamic" then
            Dynamic.End.Position = UDim2.new(0.5, v184.X, 0.5, v184.Y);
            LayoutMiddles(v184);

            return;
        end;

        if v183 < v184.Magnitude then
            v184 = v184.Unit * v183 or v184;
        end;

        Stick.Position = UDim2.new(0.5, v184.X, 0.5, v184.Y);
    end;

    local function Finish() -- Line: 836
        -- upvalues: u163 (ref), u54 (ref), Stick (copy), Dynamic (copy), LayoutMiddles (copy), u36 (ref), Fade (copy), u164 (ref), TweenService (ref), Thumbstick (copy), TweenInfo_new_ret (ref), u35 (ref)
        u163 = nil;
        u54 = Vector3.new(0, 0, 0);
        Stick.Position = UDim2.fromScale(0.5, 0.5);
        Dynamic.End.Position = UDim2.fromScale(0.5, 0.5);
        LayoutMiddles(Vector2.zero);

        if u36 == "Dynamic" then
            Fade(false);
        end;

        u164 = TweenService:Create(Thumbstick, TweenInfo_new_ret, {
            Position = UDim2.fromScale(u35.Position[1], u35.Position[2])
        });
        u164:Play();
    end;

    local function Released() -- Line: 852
        -- upvalues: u163 (ref)
        local v186;

        if u163 == nil then
            v186 = false;
        else
            v186 = u163.UserInputState == Enum.UserInputState.End and true or u163.UserInputState == Enum.UserInputState.Cancel;
        end;

        return v186;
    end;

    u41 = function() -- Line: 856
        -- upvalues: u163 (ref), Finish (copy)
        if u163 then
            Finish();
        end;
    end;

    local function Begin(p187: userdata, p188: boolean) -- Line: 862
        -- upvalues: u163 (ref), Finish (copy), u164 (ref), Vector2_zero (ref), Thumbstick (copy), u35 (ref), u36 (ref), Fade (copy), MoveStick (copy)
        if p187.UserInputType ~= Enum.UserInputType.Touch and p187.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p187.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        if p187 == u163 then
            return;
        end;

        if u163 then
            Finish();
        end;

        local Vector2_new_ret = Vector2.new(p187.Position.X, p187.Position.Y);
        u163 = p187;

        if u164 then
            u164:Cancel();
            u164 = nil;
        end;

        if p188 then
            Vector2_zero = Vector2_new_ret;
            local contextButtons_AbsolutePosition = contextButtons.AbsolutePosition;
            Thumbstick.Position = UDim2.fromOffset(Vector2_new_ret.X - contextButtons_AbsolutePosition.X, Vector2_new_ret.Y - contextButtons_AbsolutePosition.Y);
        else
            Thumbstick.Position = UDim2.fromScale(u35.Position[1], u35.Position[2]);
            Vector2_zero = contextButtons.AbsolutePosition + contextButtons.AbsoluteSize * Vector2.new(u35.Position[1], u35.Position[2]);
        end;

        if u36 == "Dynamic" then
            Fade(true);
        end;

        MoveStick(Vector2_new_ret);
    end;

    u40 = function() -- Line: 904
        -- upvalues: u36 (ref), Thumbstick (copy), Stick (copy), Dynamic (copy), u35 (ref), Fade (copy), u163 (ref), u161 (copy), u37 (ref)
        local v189 = u36 == "Dynamic";
        Thumbstick.Ring.Visible = not v189;
        Thumbstick.Disk.Visible = not v189;
        Stick.Visible = not v189;
        Dynamic.Visible = v189;
        local v190 = Thumbstick;
        local v191 = u35;

        if v190 then
            local v192;

            if v191 and v191.Hidden == true then
                v192 = true;
            else
                v192 = v191 and v191.Transparency and v191.Transparency >= 1;
            end;

            local v193 = v192 and 1 or (v191 and v191.Transparency or 0.5);

            if v190:FindFirstChild("Ring") then
                v190.Ring.ImageTransparency = v193;
            end;

            if v190:FindFirstChild("Disk") then
                v190.Disk.ImageTransparency = v193;
            end;

            if v190:FindFirstChild("Stick") then
                v190.Stick.ImageTransparency = v193;
            end;
        end;

        Fade(u163 ~= nil);
        local v194;

        if u37 == "Dynamic" then
            v194 = Thumbstick.Visible;
        else
            v194 = false;
        end;

        u161.Visible = v194;

        if not u163 then
            Thumbstick.Position = UDim2.fromScale(u35.Position[1], u35.Position[2]);
        end;
    end;

    u40();
    u3:Add("Thumbstick_InputBegan", Thumbstick.InputBegan:Connect(function(p195: userdata) -- Line: 923
        -- upvalues: Begin (copy), u37 (ref)
        Begin(p195, u37 == "Dynamic");
    end));
    u3:Add("ThumbstickArea_InputBegan", u161.InputBegan:Connect(function(p196: userdata) -- Line: 927
        -- upvalues: Begin (copy)
        Begin(p196, true);
    end));
    u3:Add("ThumbstickArea_Visible", Thumbstick:GetPropertyChangedSignal("Visible"):Connect(RefreshArea));
    u3:Add("Thumbstick_InputChanged", UserInputService.InputChanged:Connect(function(p197: userdata) -- Line: 933
        -- upvalues: u163 (ref), MoveStick (copy)
        local v198;

        if u163 == nil or u163.UserInputType ~= Enum.UserInputType.MouseButton1 then
            v198 = false;
        else
            v198 = p197.UserInputType == Enum.UserInputType.MouseMovement;
        end;

        if p197 == u163 or v198 then
            MoveStick(Vector2.new(p197.Position.X, p197.Position.Y));
        end;
    end));
    u3:Add("Thumbstick_InputEnded", UserInputService.InputEnded:Connect(function(p199: userdata) -- Line: 942
        -- upvalues: u163 (ref), Finish (copy)
        local v200;

        if u163 == nil or u163.UserInputType ~= Enum.UserInputType.MouseButton1 then
            v200 = false;
        else
            v200 = p199.UserInputType == Enum.UserInputType.MouseButton1;
        end;

        if p199 == u163 or v200 then
            Finish();
        end;
    end));
    u3:Add("Thumbstick_Released", RunService.Heartbeat:Connect(function() -- Line: 951
        -- upvalues: u163 (ref), Finish (copy)
        local v201;

        if u163 == nil then
            v201 = false;
        else
            v201 = u163.UserInputState == Enum.UserInputState.End and true or u163.UserInputState == Enum.UserInputState.Cancel;
        end;

        if v201 then
            Finish();
        end;
    end));
    u3:Add("Thumbstick_FocusReleased", UserInputService.WindowFocusReleased:Connect(u41));
    u3:Add("Thumbstick_MenuOpened", GuiService.MenuOpened:Connect(u41));
end;

function u1.Init(p202) -- Line: 963
    -- upvalues: u2 (ref), u4 (ref), u5 (ref), u6 (ref), u3 (ref), u7 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref)
    u2 = p202:GetModule("Gui");
    u4 = p202:GetModule("SettingsData");
    u5 = p202:GetModule("Enums");
    u6 = p202:GetModule("Network");
    u3 = p202:GetModule("Maid").new();
    u7 = p202:GetModule("GetUserPlatform");
    u9 = u7() == "Mobile";
    u11 = p202:GetModule("CameraController");
    u10 = p202:GetModule("CameraInput");
    u12 = p202:GetModule("CharacterController");
    u13 = p202:GetModule("WeaponController");
    u14 = p202:GetModule("WeaponManager");
    u15 = p202:GetModule("InteractionController");
    u16 = p202:GetModule("Entities");
    u17 = p202:GetModule("GameConfiguration");
end;

function u1.Start(p203) -- Line: 981
    -- upvalues: u8 (ref), u2 (ref), u9 (ref), u50 (ref), u12 (ref), LocalPlayer (copy), u36 (ref), u37 (ref), u38 (ref), u28 (ref), u1 (copy), u30 (ref), u18 (copy), u31 (ref), RefreshInteract (copy), u13 (ref), u46 (copy), u40 (ref), u3 (ref), RunService (copy), FindContext (copy), u29 (ref), u33 (ref), u22 (copy), QueueWeaponBar (copy), RefreshAltTitle (copy), u41 (ref), u26 (ref), u24 (ref), u55 (copy), u47 (copy), u51 (ref), u48 (copy), u49 (copy), u20 (copy), u53 (ref), CheckChatPolicy (copy), u52 (ref)
    u8 = u2.GetComponent("Settings");

    if u9 then
        local v204 = not u12.IsAlive() or LocalPlayer and LocalPlayer:GetAttribute("Team") == "Spectator";
        u50 = v204;
        local v205 = u8:GetPlayerSettings().Controls["Mobile Buttons"];
        u36 = v205["Thumbstick Style"];
        u37 = v205["Thumbstick Position"];
        u38 = v205["Follow Stick"];
        u28 = v205["Interact Button"];
        u1.new();
        u1.Draw();
        u1.SetSwitchMode(v205["Weapon Switching"]);
        u1.SetFireMode(v205["Fire Mode"]);
        u30 = u18["Character Pickup"].Title.Text;
        u31 = u18["Weapon Alt Function"].Title.Text;
        RefreshInteract();
        local CurrentWeapon = u13.GetCurrentWeapon();
        CurrentWeapon = CurrentWeapon;
        local v206;

        if CurrentWeapon then
            v206 = CurrentWeapon.Data.AltFunction;
        else
            v206 = CurrentWeapon;
        end;

        u18["Weapon Alt Function"].Title.Text = v206 and u46[v206.Name] or (CurrentWeapon and CurrentWeapon.Data.Type == "Melee" and "STAB" or u31);
        u8:AddConnection("Controls", "Mobile Buttons", "Weapon Switching", u1.SetSwitchMode);
        u8:AddConnection("Controls", "Mobile Buttons", "Fire Mode", u1.SetFireMode);
        u8:AddConnection("Controls", "Mobile Buttons", "Interact Button", u1.SetInteractMode);
        u8:AddConnection("Controls", "Mobile Buttons", "Thumbstick Style", function(p207) -- Line: 1006
            -- upvalues: u36 (ref), u40 (ref)
            u36 = p207;
            u40();
        end);
        u8:AddConnection("Controls", "Mobile Buttons", "Thumbstick Position", function(p208) -- Line: 1011
            -- upvalues: u37 (ref), u40 (ref)
            u37 = p208;
            u40();
        end);
        u8:AddConnection("Controls", "Mobile Buttons", "Follow Stick", function(p209) -- Line: 1016
            -- upvalues: u38 (ref)
            u38 = p209;
        end);
        local u210 = 0;
        u3:Add("InteractContext", RunService.Heartbeat:Connect(function() -- Line: 1022
            -- upvalues: u210 (ref), FindContext (ref), u29 (ref), u33 (ref), u22 (ref), RefreshInteract (ref)
            local os_clock_ret = os.clock();

            if os_clock_ret < u210 then
                return;
            end;

            u210 = os_clock_ret + 0.1;
            local v211 = FindContext();

            if v211 ~= u29 or u33 and not u22["Character Pickup"] then
                u29 = v211;
                RefreshInteract();
            end;
        end));
        u13.OnWeaponCreate:Connect(QueueWeaponBar);
        u13.OnWeaponChanged:Connect(QueueWeaponBar);
        u13.OnWeaponChanged:Connect(RefreshAltTitle);
        u13.OnWeaponUnequip:Connect(QueueWeaponBar);
        u13.OnWeaponDestroy:Connect(QueueWeaponBar);
        u12.OnCharacterSpawn:Connect(function() -- Line: 1045
            -- upvalues: u41 (ref), u1 (ref), u26 (ref), u24 (ref)
            u41();
            u1.SetSpectating(false);

            if not u26 then
                if not u24 then
                    return;
                end;

                u26 = true;
                task.defer(u1.UpdateWeaponBar);
            end;
        end);
        u12.OnCharacterDestroy:Connect(function() -- Line: 1051
            -- upvalues: u41 (ref), u1 (ref)
            u41();
            u1.SetSpectating(true);
        end);

        if LocalPlayer then
            LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 1057
                -- upvalues: LocalPlayer (ref), u12 (ref), u1 (ref), u55 (ref), u18 (ref), u47 (ref), u50 (ref), u51 (ref), u48 (ref), u49 (ref), u20 (ref)
                if LocalPlayer:GetAttribute("Team") == "Spectator" or not u12.IsAlive() then
                    u1.SetSpectating(true);
                else
                    u1.SetSpectating(false);
                end;

                local v212 = "Team Chat";
                local v213 = u55[v212] or v212;
                local v214 = u18[v213];

                if not v214 then
                    return;
                end;

                if u47[v213] then
                    v214.Visible = u50 and not u51;

                    return;
                end;

                local v215;

                if u50 and u48[v213] ~= true then
                    v215 = false;
                else
                    v215 = not u51 or u49[v213] == true;
                end;

                if u20[v213] ~= true then
                    v215 = false;
                end;

                v214.Visible = v215;
            end);
        end;

        task.spawn(function() -- Line: 1068
            -- upvalues: u53 (ref), CheckChatPolicy (ref), u52 (ref), u1 (ref)
            u53 = CheckChatPolicy();
            u52 = true;

            if u53 then
                u1.Enable("Chat", true);
                u1.Enable("Team Chat", true);

                return;
            end;

            u1.Enable("Chat", false);
            u1.Enable("Team Chat", false);
        end);
    end;
end;

function u1.new() -- Line: 1085
    -- upvalues: u2 (ref)
    contextButtons = Instance.new("Frame");
    contextButtons.Name = "MobileControls";
    contextButtons.AnchorPoint = Vector2.new(0.5, 0.5);
    contextButtons.BackgroundTransparency = 1;
    contextButtons.ClipsDescendants = true;
    contextButtons.Position = UDim2.fromScale(0.5, 0.5);
    contextButtons.Size = UDim2.fromScale(1, 1);
    contextButtons.Visible = true;
    contextButtons.Parent = u2.Handler.HUD;
end;

function u1.zone(p216, p217, p218) -- Line: 1098
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Zone";
    ImageButton.Active = true;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = p216;
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(p217 * p218, p217);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.ZIndex = 1;
    local Frame = Instance.new("Frame");
    Frame.Name = "Fill";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = ImageButton;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.08, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "Stroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 1;
    UIStroke.Parent = Frame;
    ImageButton.Parent = contextButtons;

    return ImageButton;
end;

function u1.pulse(p219) -- Line: 1134
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Pulse";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxasset://textures/ui/Input/Ring_padded.png";
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.ZIndex = 1;
    ImageLabel.Parent = p219;
end;

function u1.thumbstickArea() -- Line: 1147
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ThumbstickArea";
    ImageButton.Active = true;
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = UDim2.fromScale(0, 0.3333333333333333);
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(0.4, 0.6666666666666666);
    ImageButton.Visible = false;
    ImageButton.ZIndex = 0;
    ImageButton.Parent = contextButtons;

    return ImageButton;
end;

function u1.template(p220, p221, p222, p223) -- Line: 1164
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Template";
    ImageButton.Active = true;
    ImageButton.AutoButtonColor = false;
    ImageButton.Selectable = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageRectOffset = Vector2.new(1, 146);
    ImageButton.ImageRectSize = Vector2.new(144, 144);
    ImageButton.Position = p220;
    ImageButton.Size = UDim2.fromScale(p221, p221);
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.ZIndex = 5;

    if p222 then
        local ImageButton2 = Instance.new("ImageButton");
        ImageButton2.Name = "Decal";
        ImageButton2.Active = false;
        ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageButton2.AutoButtonColor = false;
        ImageButton2.BackgroundTransparency = 1;
        ImageButton2.Image = p222;
        ImageButton2.ImageTransparency = 0.5;
        ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
        ImageButton2.Selectable = false;
        ImageButton2.Size = UDim2.fromScale(0.4, 0.4);
        ImageButton2.ZIndex = 3;
        ImageButton2.Parent = ImageButton;
    end;

    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Disk";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxasset://textures/ui/Input/Disk_padded.png";
    ImageButton2.ImageColor3 = Color3.new();
    ImageButton2.ImageTransparency = 0.5;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.Selectable = false;
    ImageButton2.Size = UDim2.fromScale(1, 1);
    ImageButton2.Parent = ImageButton;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Ring";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxasset://textures/ui/Input/Ring_padded.png";
    ImageButton3.ImageTransparency = 0.5;
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.Selectable = false;
    ImageButton3.Size = UDim2.fromScale(0.935, 0.935);
    ImageButton3.ZIndex = 2;
    ImageButton3.Parent = ImageButton;

    if p223 then
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Title";
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
        TextLabel.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel.Size = UDim2.fromScale(0.75, 0.5);
        TextLabel.Text = p223;
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        TextLabel.TextScaled = true;
        TextLabel.TextTransparency = 0.5;
        TextLabel.ZIndex = 3;
        TextLabel.Parent = ImageButton;
    end;

    ImageButton.Parent = contextButtons;

    return ImageButton;
end;

function u1.weaponBar(p224, p225, p226) -- Line: 1244
    -- upvalues: u43 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "WeaponBar";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = p224;
    Frame.Size = UDim2.fromScale(p225 * p226, p225);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame.ZIndex = 5;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Strip";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingBottom = UDim.new(0, 2);
    UIPadding.PaddingLeft = UDim.new(0, 2);
    UIPadding.PaddingRight = UDim.new(0, 2);
    UIPadding.PaddingTop = UDim.new(0, 2);
    UIPadding.Parent = CanvasGroup;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.015, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = CanvasGroup;

    for i = 1, #u43 do
        local Frame2 = Instance.new("Frame");
        Frame2.Name = tostring(i);
        Frame2.BackgroundColor3 = Color3.new();
        Frame2.BackgroundTransparency = 0.6;
        Frame2.LayoutOrder = i;
        Frame2.Size = UDim2.fromScale(0.185, 1);
        Frame2.Visible = false;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0.18, 0);
        UICorner.Parent = Frame2;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3.new(1, 1, 1);
        UIStroke.Transparency = 0.85;
        UIStroke.Parent = Frame2;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = "Icon";
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Image = "";
        ImageLabel.ImageTransparency = 0.45;
        ImageLabel.Position = UDim2.fromScale(0.5, 0.46);
        ImageLabel.ScaleType = Enum.ScaleType.Fit;
        ImageLabel.Size = UDim2.fromScale(0.82, 0.62);
        ImageLabel.Parent = Frame2;
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "Accent";
        Frame3.AnchorPoint = Vector2.new(0.5, 1);
        Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
        Frame3.BorderSizePixel = 0;
        Frame3.Position = UDim2.fromScale(0.5, 0.92);
        Frame3.Size = UDim2.new(0, 0, 0, 2);
        Frame3.Parent = Frame2;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(1, 0);
        UICorner2.Parent = Frame3;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Count";
        TextLabel.AnchorPoint = Vector2.new(1, 0);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
        TextLabel.Position = UDim2.fromScale(0.94, 0.06);
        TextLabel.Size = UDim2.fromScale(0.4, 0.28);
        TextLabel.Text = "";
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        TextLabel.TextScaled = true;
        TextLabel.TextTransparency = 0.2;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel.Visible = false;
        TextLabel.Parent = Frame2;
        Frame2.Parent = CanvasGroup;
        local _ = i;
    end;

    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Hint";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Visible = false;
    Frame2.Parent = Frame;

    for _, v in { { "Left", "<", 0.37 }, { "Right", ">", 0.63 } } do
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = v[1];
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
        TextLabel.Position = UDim2.fromScale(v[3], 0.5);
        TextLabel.Size = UDim2.fromScale(0.05, 0.4);
        TextLabel.Text = v[2];
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        TextLabel.TextScaled = true;
        TextLabel.TextTransparency = 0.5;
        TextLabel.Parent = Frame2;
    end;

    Frame.Parent = contextButtons;

    return Frame;
end;

function u1.thumbstick(p227, p228) -- Line: 1363
    -- upvalues: u44 (copy)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ThumbstickFrame";
    ImageButton.Active = true;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = p227;
    ImageButton.Size = UDim2.fromScale(p228, p228);
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Ring";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxasset://textures/ui/Input/Ring_padded.png";
    ImageButton2.ImageTransparency = 0.5;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.Selectable = false;
    ImageButton2.Size = UDim2.fromScale(0.935, 0.935);
    ImageButton2.ZIndex = 2;
    ImageButton2.Parent = ImageButton;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Disk";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxasset://textures/ui/Input/Disk_padded.png";
    ImageButton3.ImageColor3 = Color3.new();
    ImageButton3.ImageTransparency = 0.5;
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.Selectable = false;
    ImageButton3.Size = UDim2.fromScale(1, 1);
    ImageButton3.Parent = ImageButton;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "Stick";
    ImageButton4.Active = false;
    ImageButton4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton4.AutoButtonColor = false;
    ImageButton4.BackgroundTransparency = 1;
    ImageButton4.Image = "rbxasset://textures/ui/Input/Ring_padded.png";
    ImageButton4.ImageTransparency = 0.5;
    ImageButton4.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton4.Selectable = false;
    ImageButton4.Size = UDim2.fromScale(0.5, 0.5);
    ImageButton4.ZIndex = 3;
    ImageButton4.Parent = ImageButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Dynamic";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Start";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(18, 18, 21);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame2;

    for i = 1, #u44 do
        local Frame3 = Instance.new("Frame");
        Frame3.Name = `Middle{i}`;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
        Frame3.BackgroundTransparency = 1;
        Frame3.Visible = false;
        Frame3.ZIndex = 2;
        Frame3.Parent = Frame;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0.5, 0);
        UICorner2.Parent = Frame3;
        local _ = i;
    end;

    local Frame3 = Instance.new("Frame");
    Frame3.Name = "End";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.fromScale(0.365, 0.365);
    Frame3.ZIndex = 3;
    Frame3.Parent = Frame;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0.5, 0);
    UICorner2.Parent = Frame3;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "Stroke";
    UIStroke.Color = Color3.fromRGB(213, 215, 221);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 1;
    UIStroke.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Center";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(213, 215, 221);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 0.5);
    Frame4.Size = UDim2.fromScale(0.74, 0.74);
    Frame4.ZIndex = 3;
    Frame4.Parent = Frame3;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0.5, 0);
    UICorner3.Parent = Frame4;
    Frame.Parent = ImageButton;
    ImageButton.Parent = contextButtons;

    return ImageButton;
end;

return u1;