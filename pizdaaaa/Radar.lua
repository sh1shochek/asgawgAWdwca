-- ReplicatedStorage.GameClient.Gui.HUD.Radar
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Radar
-- Decompile time: 32.71 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local GameStats = ReplicatedStorage.GameStats;
local _ = {
    CT = Color3.fromRGB(184, 214, 239),
    T = Color3.fromRGB(234, 210, 139),
    Spectator = Color3.fromRGB(255, 255, 255)
};
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
local u17 = {
    A = nil,
    B = nil
};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = {};
local u23 = 0;
local u24 = {};
local u25 = "asf";
local u26 = 1;
local u27 = 0.015625;
local u28 = nil;
local u29 = 0;
local u30 = 1;
local u31 = 0;
local CFrame_Angles_ret = CFrame.Angles(-1.5707963267948966, 0, 0);
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;

local function InvalidateWriteCache() -- Line: 48
    -- upvalues: u32 (ref), u33 (ref), u34 (ref), u35 (ref)
    u32 = nil;
    u33 = nil;
    u34 = nil;
    u35 = nil;
end;

local u36 = {};
local u37 = nil;
local u38 = {};
local u39 = 10000;
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = true;
local u45 = true;
local TweenInfo_new_ret = TweenInfo.new(5);
local TweenInfo_new_ret2 = TweenInfo.new(0.1);

local function CreateCarrierBombIcon(p46) -- Line: 74
    -- upvalues: u1 (copy)
    local v47 = u1.bomb();
    v47.Name = "BombCarrier";
    v47.ImageColor3 = Color3.fromRGB(255, 203, 107);
    v47.Position = UDim2.fromScale(0.5, 0.5);
    v47.AnchorPoint = Vector2.new(0.5, 0.5);
    v47.Size = UDim2.fromScale(1, 1);
    v47.ZIndex = 6;
    v47.Visible = false;
    v47.Parent = p46;

    return v47;
end;

local function UpdateLocalBombIcon() -- Line: 88
    -- upvalues: u7 (ref), u16 (ref)
    local WeaponInventory = u7.GetWeaponInventory();
    u16.BombCarrier.Visible = WeaponInventory and WeaponInventory[8] ~= nil and true or false;
end;

function u1.DrawViewport() -- Line: 93
    -- upvalues: u32 (ref), u33 (ref), u34 (ref), u35 (ref), u12 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u38 (ref), u39 (ref), u40 (ref), u23 (ref), u30 (ref), u31 (ref), u22 (copy)
    u32 = nil;
    u33 = nil;
    u34 = nil;
    u35 = nil;

    if u12:FindFirstChild("ViewportFrame") then
        u12:FindFirstChild("ViewportFrame"):Destroy();
    end;

    u18 = Instance.new("Camera");
    u18.FieldOfView = 70;
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Size = UDim2.fromScale(1, 1);
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ViewportFrame.Position = UDim2.fromScale(0.5, 0.5);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.CurrentCamera = u18;
    ViewportFrame.Parent = u12;
    u18.Parent = ViewportFrame;
    local WorldModel = Instance.new("WorldModel");
    WorldModel.Parent = ViewportFrame;
    u19 = workspace:WaitForChild("Map", 30);

    if not u19 then
        warn("[Streaming] Map not found after 30s — Radar setup aborted");

        return;
    end;

    if not u19:WaitForChild("Radar", 10) then
        return;
    end;

    u20 = u19.Radar:Clone();
    u20.Parent = WorldModel;
    local Zones = u19:WaitForChild("Zones", 30);

    if Zones then
        u21 = Zones:WaitForChild("Plants", 30);
    else
        warn("[Streaming] Map.Zones not found — plant blips unavailable");
    end;

    u38 = {
        Top = u20:GetAttribute("Radar"),
        Lower = u20:GetAttribute("RadarLower")
    };
    u39 = u20:GetAttribute("LowerStartFrom");
    u20:ClearAllChildren();

    for i, v in u38 do
        local Decal = Instance.new("Decal");
        Decal.Face = Enum.NormalId.Top;
        Decal.Parent = u20;
        Decal.ColorMap = v;
        u38[i] = Decal;
    end;

    u40 = nil;
    local v48;

    if u20:IsA("Model") then
        v48 = u20:GetExtentsSize();
    else
        v48 = not u20:IsA("BasePart") and Vector3.new(0, 0, 0) or u20.Size;
    end;

    u23 = v48.X / 2;
    local math_rad_ret = math.rad(u18.FieldOfView / 2);
    u30 = math.tan(math_rad_ret);
    u31 = u20.CFrame.Y;
    table.clear(u22);

    if u19:FindFirstChild("Zones2") then
        for _, child in u19.Zones2.Objects:GetChildren() do
            local Position = child.Position;
            local Size = child.Size;
            local X = Position.X;
            local Y = Position.Y;
            local Z = Position.Z;
            local v49 = Size.X / 2;
            local v50 = Size.Y / 2;
            local v51 = Size.Z / 2;
            local v52 = {
                name = child:GetAttribute("Location"),
                min = Vector3.new(X - v49, Y - v50, Z - v51),
                max = Vector3.new(X + v49, Y + v50, Z + v51)
            };
            table.insert(u22, v52);
        end;
    end;

    table.sort(u22, function(p53, p54) -- Line: 167
        local v55 = p53.max - p53.min;
        local v56 = p54.max - p54.min;

        return v55.X * v55.Y * v55.Z < v56.X * v56.Y * v56.Z;
    end);
end;

function u1.CreateBlipCross(p57, p58) -- Line: 178
    -- upvalues: u1 (copy), u24 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local u59 = u1.cross();
    u59.TextColor3 = p58;
    local u60 = {
        class = "cross",
        position = p57,
        blip = u59
    };
    table.insert(u24, u60);
    TweenService:Create(u59, TweenInfo_new_ret, {
        TextTransparency = 1
    }):Play();
    task.delay(5, function() -- Line: 191
        -- upvalues: u60 (copy), u59 (copy)
        u60.blip = nil;
        u59:Destroy();
    end);
end;

function u1.CreateBlipBombT(p61) -- Line: 197
    -- upvalues: u1 (copy), u24 (copy), u3 (ref), u37 (ref)
    if p61 and p61.Parent then
        local u62 = u1.bomb();
        u62.ImageColor3 = Color3.fromRGB(255, 203, 107);
        u62.Visible = false;
        local u63 = {
            class = "bomb",
            instance = p61,
            blip = u62
        };
        table.insert(u24, u63);
        u3:Add("Bomb", p61.Destroying:Connect(function() -- Line: 214
            -- upvalues: u63 (copy), u62 (copy), u37 (ref), u3 (ref)
            u63.blip = nil;
            u62:Destroy();
            u37 = nil;
            u3:Remove("Bomb");
        end));

        return {
            Destroy = function() -- Line: 222, Name: Destroy
                -- upvalues: u62 (copy), u3 (ref)
                if not u62 then
                    return;
                end;

                u62:Destroy();
                u3:Remove("Bomb");
            end
        };
    end;
end;

function u1.CreateBlipBombCT(u64) -- Line: 233
    -- upvalues: u1 (copy), u24 (copy), u3 (ref), u37 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if u64 and u64.Parent then
        local u65 = u1.bomb();
        u65.ImageColor3 = Color3.new(1, 0.203922, 0.215686);
        u65.Visible = false;
        local u66 = {
            class = "bomb",
            instance = u64,
            blip = u65
        };
        table.insert(u24, u66);
        u3:Add("Bomb", u64.Destroying:Connect(function() -- Line: 251
            -- upvalues: u66 (copy), u65 (copy), u37 (ref), u3 (ref)
            u66.blip = nil;
            u65:Destroy();
            u37 = nil;
            u3:Remove("Bomb");
        end));

        return {
            Destroy = function() -- Line: 259, Name: Destroy
                -- upvalues: u65 (copy), u66 (copy), u64 (copy), TweenService (ref), TweenInfo_new_ret (ref), u37 (ref), u3 (ref)
                if not u65 then
                    return;
                end;

                u66.position = u64.Position;
                u66.instance = nil;
                TweenService:Create(u65, TweenInfo_new_ret, {
                    ImageTransparency = 1
                }):Play();
                u37 = nil;
                u3:Remove("Bomb");
                task.delay(5, function() -- Line: 271
                    -- upvalues: u66 (ref), u65 (ref)
                    u66.blip = nil;

                    if u65 then
                        u65:Destroy();
                    end;
                end);
            end
        };
    end;
end;

local function GetTeammateColor(p67) -- Line: 282
    -- upvalues: u8 (ref)
    return u8.GetColor(p67);
end;

local function UpdateLocalPlayerColor() -- Line: 286
    -- upvalues: u16 (ref), u8 (ref), LocalPlayer (copy)
    if not u16 then
        return;
    end;

    u16.ImageColor3 = u8.GetColor(LocalPlayer, nil, Color3.fromRGB(110, 197, 255));
end;

function u1.CreateBlipTeammate(p68, p69) -- Line: 294
    -- upvalues: u1 (copy), u8 (ref), CreateCarrierBombIcon (copy), u3 (ref), u24 (copy)
    local v70;

    if p68 then
        v70 = p68.PrimaryPart;
    else
        v70 = p68;
    end;

    local v71;

    if v70 then
        v71 = v70.Parent;
    else
        v71 = v70;
    end;

    if not v71 then
        return;
    end;

    local u72 = u1.playerIn();
    local v73 = p69 or u8.GetColor(p68);
    u72.ImageColor3 = v73;
    u72.PlayerOut.ImageColor3 = v73;
    u72.Visible = false;
    local u74 = CreateCarrierBombIcon(u72);
    local WeaponInventory = p68.WeaponInventory;
    u74.Visible = WeaponInventory and WeaponInventory[8] ~= nil and true or false;
    local u75 = {
        class = "teammate",
        entity = p68,
        instance = v70,
        blip = u72,
        color = v73
    };
    local u76 = `TeammateBomb_{p68.Identifier}`;
    u3:Add(u76, p68.WeaponInventoryChanged:Connect(function(p77) -- Line: 309, Name: UpdateBombIcon
        -- upvalues: u74 (copy)
        u74.Visible = p77 and p77[8] ~= nil and true or false;
    end));

    function u75.destroy() -- Line: 324
        -- upvalues: u75 (copy), u3 (ref), u76 (copy), u72 (copy)
        if not u75.blip then
            return;
        end;

        u3:Remove(u76);
        u75.blip = nil;
        u72:Destroy();
    end;

    table.insert(u24, u75);
end;

function u1.CreateBlipEnemy(p78, u79) -- Line: 348
    -- upvalues: u1 (copy), u24 (copy), TweenService (copy), TweenInfo_new_ret (copy), Players (copy), u42 (ref)
    local u80 = u1.enemy();
    local Color3_new_ret = Color3.new(1, 0, 0.0156863);
    local u81 = {
        class = "enemy",
        identifier = u79,
        position = p78,
        blip = u80,
        color = Color3_new_ret
    };
    u80.ImageColor3 = Color3_new_ret;
    u80.PlayerOut.ImageColor3 = Color3_new_ret;
    u80.Visible = false;
    table.insert(u24, u81);

    function u81.fade() -- Line: 366
        -- upvalues: u81 (copy), u1 (ref), u80 (copy), TweenService (ref), TweenInfo_new_ret (ref), Players (ref), u79 (copy), u42 (ref)
        if not u81.isQuestion then
            local u82 = u1.questionMark();
            u82.TextTransparency = 0;
            u82.Visible = true;
            u81.blip = u82;
            u81.isQuestion = true;
            u81.instance = nil;
            u81.entity = nil;
            u81.lastPosX = nil;
            u81.lastPosY = nil;
            u81.lastVis = nil;
            u81.lastIT = nil;
            u81.lastRot = nil;
            u81.lastArrow = nil;
            u81.lastPO = nil;
            u81.arrow = nil;
            u81.playerOut = nil;
            u80:Destroy();
            TweenService:Create(u82, TweenInfo_new_ret, {
                TextTransparency = 1
            }):Play();
            local PlayerByUserId = Players:GetPlayerByUserId(u79);

            if PlayerByUserId and u42.GetHealth(PlayerByUserId) <= 0 then
                u81.blip = nil;

                if u82 then
                    u82:Destroy();
                end;
            end;

            task.delay(5, function() -- Line: 404
                -- upvalues: u81 (ref), u82 (copy)
                if u81.blip == nil then
                    return;
                end;

                u81.blip = nil;

                if u82 then
                    u82:Destroy();
                end;
            end);

            return u82;
        end;
    end;

    return u81;
end;

function u1.CreateBlipPlant(p83) -- Line: 421
    -- upvalues: u17 (ref), u24 (copy)
    local v84 = {
        class = "plant",
        instance = p83,
        blip = u17[p83.Name:gsub("Plant", "")]
    };
    table.insert(u24, v84);
end;

local u85 = nil;
local u86 = nil;
local u87 = nil;
local u88 = nil;
local u89 = nil;

local function StopSoundPulse() -- Line: 434
    -- upvalues: u87 (ref), u85 (ref), u86 (ref)
    if u87 then
        task.cancel(u87);
        u87 = nil;
    end;

    if u85 then
        u85:Cancel();
    end;

    if u86 then
        u86:Cancel();
    end;
end;

local function PulseBorder(p90) -- Line: 440
    -- upvalues: u87 (ref), u85 (ref), u86 (ref), u11 (ref), u43 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u88 (ref), u89 (ref)
    if u87 then
        task.cancel(u87);
        u87 = nil;
    end;

    if u85 then
        u85:Cancel();
    end;

    if u86 then
        u86:Cancel();
    end;

    local UIStroke = u11.UIStroke;
    local HudColor = u43.GetHudColor();

    if not u85 then
        u85 = TweenService:Create(UIStroke, TweenInfo_new_ret2, {
            Thickness = 3,
            Color = Color3.new(1, 1, 1)
        });
    end;

    if not (u86 and (u88 == p90 and u89 == HudColor)) then
        if u86 then
            u86:Destroy();
        end;

        u88 = p90;
        u89 = HudColor;
        u86 = TweenService:Create(UIStroke, TweenInfo.new((math.max(0, p90 - 0.1))), {
            Thickness = 1,
            Color = HudColor
        });
    end;

    u85:Play();
    u87 = task.delay(0.1, function() -- Line: 453
        -- upvalues: u87 (ref), u11 (ref), u86 (ref)
        u87 = nil;

        if u11.Parent then
            u86:Play();
        end;
    end);
end;

function u1.CreateSound(p91, p92, p93, p94) -- Line: 459
    -- upvalues: u23 (ref), u26 (ref), PulseBorder (copy), u1 (copy), u43 (ref), u24 (copy), TweenService (copy)
    if u23 <= 0 or p91 <= 0 then
        return;
    end;

    local v95 = p91 / (u23 / 2) * (1 / u26);

    if p93 or v95 < 1 then
        local u96 = u1.soundTemplate();
        u96.UIStroke.Color = p94 or u43.GetHudColor();
        u96.UIStroke.Transparency = 0.2;
        u96.Visible = true;
        local u97 = nil;

        if p93 then
            u97 = {
                class = "sound",
                position = p93,
                blip = u96
            };
            table.insert(u24, u97);
            u96.Size = UDim2.fromScale(v95 * 0.3, v95 * 0.3);
            TweenService:Create(u96, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromScale(v95, v95)
            }):Play();
        else
            u96.Size = UDim2.fromScale(v95, v95);
        end;

        local u98 = false;

        local function Destroy(p99) -- Line: 495
            -- upvalues: u98 (ref), u97 (ref), TweenService (ref), u96 (copy)
            if u98 then
                return;
            end;

            u98 = true;

            if u97 then
                u97.blip = nil;
            end;

            local v100 = TweenService:Create(u96.UIStroke, TweenInfo.new(p99), {
                Transparency = 1
            });
            v100.Completed:Once(function() -- Line: 505
                -- upvalues: u96 (ref)
                u96:Destroy();
            end);
            v100:Play();
        end;

        local v101 = p92 or 0.8;
        local math_min_ret = math.min(v101, 0.5);
        task.delay(v101 - math_min_ret, Destroy, math_min_ret);

        return {
            Destroy = function() -- Line: 516, Name: Destroy
                -- upvalues: Destroy (copy)
                Destroy(0.2);
            end
        };
    end;

    PulseBorder(p92 or 0.5);
end;

function u1.Update() -- Line: 522
    -- upvalues: u11 (ref), GameStats (copy), u25 (ref), u4 (ref), u45 (ref), u23 (ref), u26 (ref), u24 (copy), u30 (ref), u31 (ref), CFrame_Angles_ret (copy), u32 (ref), u18 (ref), u1 (copy), u39 (ref), u33 (ref), u12 (ref), u34 (ref), u16 (ref)
    local Parent = u11.Parent;

    if not (u11.Visible and (not Parent or Parent.Visible)) or GameStats:GetAttribute("State") == "MatchEnded" then
        return;
    end;

    local v102 = u25 == "Circle";
    local CFrame2 = u4.GetCFrame();
    local Position = CFrame2.Position;
    local LookVector = CFrame2.LookVector;
    local _, v103 = CFrame2:ToOrientation();
    local v104 = u45 and v103 and v103 or 3.141592653589793;
    local math_deg_ret = math.deg(v104);
    local math_cos_ret = math.cos(v104);
    local math_sin_ret = math.sin(v104);
    local v105 = u23 / 2;
    local v106 = 1 / u26;
    local v107 = u23 * u26;

    for i = #u24, 1, -1 do
        local v108 = u24[i];
        local instance = v108.instance;
        local position = v108.position;
        local blip = v108.blip;
        local class = v108.class;
        local v109;

        if blip then
            if class and (instance or position) then
                local entity = v108.entity;
                local v110 = entity and entity.Snapshots and entity.Snapshots:Newest();
                local v111 = v110 and not v110.FogCulled and v110.Snapshot.Position or (position or (entity and entity.Position or instance.Position));

                if v111.X == 0 and v111.Z == 0 then
                    if v108.lastVis == false then
                        v109 = i;
                    else
                        v108.lastVis = false;
                        blip.Visible = false;
                        v109 = i;
                    end;
                else
                    local vector_create_ret = vector.create(v111.X - Position.X, 0, v111.Z - Position.Z);
                    local v112 = 0;
                    local v113, v114;

                    if v102 then
                        v112 = vector.magnitude(vector_create_ret) / v105 * v106;
                        local v115 = 1 / (v107 * math.max(1, v112));
                        v113 = (vector_create_ret.X * math_cos_ret - vector_create_ret.Z * math_sin_ret) * v115;
                        v114 = (vector_create_ret.Z * math_cos_ret + vector_create_ret.X * math_sin_ret) * v115;
                    else
                        local X = vector_create_ret.X;
                        local Z = vector_create_ret.Z;

                        if u45 then
                            X = -vector_create_ret.X * math_cos_ret + vector_create_ret.Z * math_sin_ret;
                            Z = -vector_create_ret.X * math_sin_ret - vector_create_ret.Z * math_cos_ret;
                        end;

                        local v116 = X / v107;
                        local v117 = Z / v107;

                        if math.abs(v116) > 0.5 or math.abs(v117) > 0.5 then
                            v116 = math.clamp(v116, -0.5, 0.5);
                            v117 = math.clamp(v117, -0.5, 0.5);
                            v112 = 1;
                        end;

                        v113 = -v116;
                        v114 = -v117;
                    end;

                    local arrow = v108.arrow;
                    local playerOut = v108.playerOut;

                    if arrow == nil and playerOut == nil then
                        arrow = blip:FindFirstChild("Arrow") or false;
                        playerOut = blip:FindFirstChild("PlayerOut") or false;
                        v108.arrow = arrow;
                        v108.playerOut = playerOut;
                    end;

                    local v118 = 0.5 + v113;
                    local v119 = 0.5 + v114;

                    if v108.lastPosX ~= v118 or v108.lastPosY ~= v119 then
                        v108.lastPosX = v118;
                        v108.lastPosY = v119;
                        blip.Position = UDim2.new(v118, 0, v119, 0);
                    end;

                    local v120 = class == "teammate";
                    local v121 = class == "enemy";
                    local isQuestion = v108.isQuestion;
                    local v122 = class == "sound";

                    if v112 >= 1 then
                        if v120 then
                            if v108.lastIT ~= 1 then
                                v108.lastIT = 1;
                                blip.ImageTransparency = 1;
                            end;

                            if v108.lastArrow ~= false then
                                v108.lastArrow = false;
                                arrow.Visible = false;
                            end;

                            if v108.lastPO ~= true then
                                v108.lastPO = true;
                                playerOut.Visible = true;
                            end;

                            local v123 = -math.atan2(vector_create_ret.X, vector_create_ret.Z);
                            local v124 = math.deg(v123) + math_deg_ret - 180;

                            if v108.lastRot ~= v124 then
                                v108.lastRot = v124;
                                blip.Rotation = v124;
                            end;

                            if v108.lastVis == true then
                                v109 = i;
                            else
                                v108.lastVis = true;
                                blip.Visible = true;
                                v109 = i;
                            end;
                        else
                            if v121 and not isQuestion then
                                if v108.lastIT ~= 1 then
                                    v108.lastIT = 1;
                                    blip.ImageTransparency = 1;
                                end;

                                if v108.lastPO ~= true then
                                    v108.lastPO = true;
                                    playerOut.Visible = true;
                                end;

                                local v125 = -math.atan2(vector_create_ret.X, vector_create_ret.Z);
                                local v126 = math.deg(v125) + math_deg_ret - 180;

                                if v108.lastRot ~= v126 then
                                    v108.lastRot = v126;
                                    blip.Rotation = v126;
                                end;

                                if v108.lastVis == true then
                                    v109 = i;
                                else
                                    v108.lastVis = true;
                                    blip.Visible = true;
                                    v109 = i;
                                end;
                            end;

                            if not v122 then
                                if v108.lastVis == true then
                                    v109 = i;
                                else
                                    v108.lastVis = true;
                                    blip.Visible = true;
                                    v109 = i;
                                end;
                            end;

                            if v108.lastVis == false then
                                v109 = i;
                            else
                                v108.lastVis = false;
                                blip.Visible = false;
                                v109 = i;
                            end;
                        end;
                    else
                        if v120 then
                            local LookVector2 = (entity and entity.CFrame or instance.CFrame).LookVector;
                            local math_atan2_ret = math.atan2(LookVector2.X, LookVector2.Z);

                            if v108.lastIT ~= 0 then
                                v108.lastIT = 0;
                                blip.ImageTransparency = 0;
                            end;

                            if v108.lastArrow ~= true then
                                v108.lastArrow = true;
                                arrow.Visible = true;
                            end;

                            if v108.lastPO ~= false then
                                v108.lastPO = false;
                                playerOut.Visible = false;
                            end;

                            local v127 = math_deg_ret - math.deg(math_atan2_ret) + 90;

                            if v108.lastRot ~= v127 then
                                v108.lastRot = v127;
                                blip.Rotation = v127;
                            end;
                        elseif v121 and not isQuestion then
                            if v108.lastIT ~= 0 then
                                v108.lastIT = 0;
                                blip.ImageTransparency = 0;
                            end;

                            if v108.lastPO ~= false then
                                v108.lastPO = false;
                                playerOut.Visible = false;
                            end;
                        end;

                        if v108.lastVis == true then
                            v109 = i;
                        else
                            v108.lastVis = true;
                            blip.Visible = true;
                            v109 = i;
                        end;
                    end;
                end;
            else
                blip:Destroy();
                table.remove(u24, i);
                v109 = i;
            end;
        else
            table.remove(u24, i);
            v109 = i;
        end;
    end;

    local v128 = CFrame.new(Position.X, u31 + v107 / u30, Position.Z) * CFrame_Angles_ret;

    if u32 ~= v128 then
        u32 = v128;
        u18.CFrame = v128;
    end;

    u1.ChangeDecal(u39 and (u39 or 0) < Position.Y);
    local v129;

    if u45 then
        v129 = 0;
    else
        local v130 = -math.atan2(LookVector.X, LookVector.Z);
        v129 = math.deg(v130);
        math_deg_ret = 180;
    end;

    if u33 ~= math_deg_ret then
        u33 = math_deg_ret;
        u12.Rotation = math_deg_ret;
    end;

    if u34 ~= v129 then
        u34 = v129;
        u16.Rotation = v129;
    end;

    u1.UpdateLocation();
end;

function u1.UpdateLocation() -- Line: 718
    -- upvalues: u29 (ref), u22 (copy), u35 (ref), u15 (ref), u4 (ref)
    local os_clock_ret = os.clock();

    if os_clock_ret < u29 then
        return;
    end;

    u29 = os_clock_ret + 0.2;

    if not next(u22) then
        if u35 ~= "" then
            u35 = "";
            u15.Text = "";
        end;

        return;
    end;

    local Position = u4.GetAppliedCFrame().Position;
    local v131 = "";

    for _, v in u22 do
        if Position.X >= v.min.X and (Position.X <= v.max.X and (Position.Y >= v.min.Y and (Position.Y <= v.max.Y and (Position.Z >= v.min.Z and Position.Z <= v.max.Z)))) then
            v131 = v.name;
            break;
        end;
    end;

    if v131 ~= "" and v131 ~= u35 then
        u35 = v131;
        u15.Text = v131;
    end;
end;

local function ApplyLeak(p132: table, p133: table, p134: boolean) -- Line: 755
    -- upvalues: u36 (ref), u42 (ref), u1 (copy), u37 (ref), LocalPlayer (copy)
    local v135 = {};

    for i, v in u36 do
        if not table.find(p132, i) then
            v.fade();
            u36[i] = nil;
        end;
    end;

    for i, v in p132 do
        local v136 = p133[i];
        local Entity = u42.GetEntity("Character", v);
        local v137 = u36[v] or u1.CreateBlipEnemy(v136, v);
        v137.entity = Entity;
        v137.position = v136;
        v135[v] = v137;
    end;

    u36 = v135;

    if p134 and not u37 then
        local v138 = nil;
        local _, v139 = next(u42.GetAllCategoryEntities("Bomb") or {});

        if v139 then
            v138 = v139.Model and v139.Model.PrimaryPart;
        else
            for _, v in u42.GetAllCategoryEntities("DroppedWeapon") or {} do
                if v.Name == "Bomb" then
                    v138 = v.Model and v.Model.PrimaryPart;
                    break;
                end;
            end;
        end;

        if v138 then
            if LocalPlayer:GetAttribute("Team") == "T" then
                u37 = u1.CreateBlipBombT(v138);

                return;
            end;

            u37 = u1.CreateBlipBombCT(v138);
        end;
    elseif not p134 and u37 then
        u37:Destroy();
        u37 = nil;
    end;
end;

function u1.Run() -- Line: 812
    -- upvalues: u11 (ref), GameStats (copy), u7 (ref), u16 (ref), u8 (ref), LocalPlayer (copy), u3 (ref), UpdateLocalBombIcon (copy), u1 (copy), u6 (ref), ApplyLeak (copy), u24 (copy), u21 (ref), u42 (ref), GetTeammateColor (copy), u36 (ref), u28 (ref), u20 (ref), u27 (ref)
    if not u11.Visible or GameStats:GetAttribute("State") == "MatchEnded" then
        return;
    end;

    local WeaponInventory = u7.GetWeaponInventory();
    u16.BombCarrier.Visible = WeaponInventory and WeaponInventory[8] ~= nil and true or false;

    if u16 then
        u16.ImageColor3 = u8.GetColor(LocalPlayer, nil, Color3.fromRGB(110, 197, 255));
    end;

    u3:Add("LocalBombCreate", u7.OnWeaponCreate:Connect(UpdateLocalBombIcon));
    u3:Add("LocalBombDestroy", u7.OnWeaponDestroy:Connect(UpdateLocalBombIcon));
    u1.Shape();
    u1.DrawViewport();
    u1.SetTeam(LocalPlayer:GetAttribute("Team"));
    u3:Add("Team", LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 828
        -- upvalues: u1 (ref), LocalPlayer (ref)
        u1.SetTeam(LocalPlayer:GetAttribute("Team"));
    end));
    u6.RadarLeak.On(ApplyLeak);

    for i = #u24, 1, -1 do
        local v140;

        if u24[i].class == "plant" then
            table.remove(u24, i);
            v140 = i;
        else
            v140 = i;
        end;
    end;

    for _, child in u21:GetChildren() do
        u1.CreateBlipPlant(child);
    end;

    u3:Add("EntityCreated", u42.OnEntityCreated:Connect(function(p141, p142, p143) -- Line: 844
        -- upvalues: LocalPlayer (ref), u1 (ref), GetTeammateColor (ref)
        if p141 ~= "Character" then
            return;
        end;

        if not p143 then
            return;
        end;

        if p143.Data.Team ~= LocalPlayer:GetAttribute("Team") then
            return;
        end;

        u1.CreateBlipTeammate(p143, GetTeammateColor(p143));
    end));
    u3:Add("EntityDestroyed", u42.OnEntityDestroyed:Connect(function(p144, p145, p146) -- Line: 858
        -- upvalues: u24 (ref), u1 (ref), u36 (ref)
        if p144 ~= "Character" then
            return;
        end;

        local v147 = false;

        for _, v in u24 do
            if v.class == "enemy" and (v.identifier == p145 and v.blip) then
                v.blip:Destroy();
                v.blip = nil;
            elseif v.class == "teammate" and (v.instance == p146.PrimaryPart and v.blip) then
                if not v147 then
                    u1.CreateBlipCross(p146.Position or v.instance.Position, v.color);
                    v147 = true;
                end;

                v.destroy();
            end;
        end;

        u36[p145] = nil;
    end));

    if u28 then
        task.cancel(u28);
        u28 = nil;
    end;

    if not u11.Visible then
        return;
    end;

    u28 = task.spawn(function() -- Line: 886
        -- upvalues: u20 (ref), u1 (ref), u27 (ref)
        while true do
            if u20 then
                u1.Update();
            end;

            task.wait(u27);
        end;
    end);
end;

function u1.SetTeam(p148) -- Line: 894
    -- upvalues: u24 (copy), u42 (ref), LocalPlayer (copy), u1 (copy), GetTeammateColor (copy), u37 (ref)
    for _, v in u24 do
        if v.class == "teammate" then
            v.destroy();
        end;
    end;

    for _, v in u42.GetAllCategoryEntities("Character") do
        if v.Data.Team == LocalPlayer:GetAttribute("Team") then
            u1.CreateBlipTeammate(v, GetTeammateColor(v));
        end;
    end;

    if u37 then
        u37:Destroy();
        u37 = nil;
    end;
end;

function u1.ChangeDecal(p149) -- Line: 915
    -- upvalues: u40 (ref), TweenService (copy), u38 (ref)
    if u40 == p149 then
        return;
    end;

    u40 = p149;
    TweenService:Create(u38[p149 and "Top" or "Lower"], TweenInfo.new(0.25), {
        Transparency = 0
    }):Play();
    TweenService:Create(u38[p149 and "Lower" or "Top"], TweenInfo.new(0.5), {
        Transparency = 1
    }):Play();
end;

function u1.Destroy() -- Line: 926
    -- upvalues: u28 (ref), u87 (ref), u85 (ref), u86 (ref), u11 (ref), u43 (ref), u3 (ref)
    if u28 then
        task.cancel(u28);
        u28 = nil;
    end;

    if u87 then
        task.cancel(u87);
        u87 = nil;
    end;

    if u85 then
        u85:Cancel();
    end;

    if u86 then
        u86:Cancel();
    end;

    if u11 then
        u11.UIStroke.Thickness = 1;
        u11.UIStroke.Color = u43.GetHudColor();
    end;

    u3:Removes("Team", "Bomb", "EntityCreated", "EntityDestroyed", "LocalBombCreate", "LocalBombDestroy");
end;

function u1.ScaleTo(p150) -- Line: 938
    -- upvalues: u11 (ref), u10 (ref)
    if u10 then
        p150 = p150 * 1.15 or p150;
    end;

    u11.UIScale.Scale = p150;
end;

function u1.TransparencyTo(p151, p152) -- Line: 942
    -- upvalues: u11 (ref)
    u11.BackgroundTransparency = p151 or u11.BackgroundTransparency;
    u11.Main.GroupTransparency = p152 or u11.Main.GroupTransparency;
end;

function u1.Enabled(p153) -- Line: 947
    -- upvalues: GameStats (copy), u11 (ref), u44 (ref), u1 (copy)
    if p153 and GameStats:GetAttribute("State") == "MatchEnded" then
        p153 = false;
    end;

    if p153 then
        p153 = u44;
    end;

    u11.Visible = p153;

    if u11.Visible then
        u1.Run();

        return;
    end;

    u1.Destroy();
end;

function u1.Shape() -- Line: 961
    -- upvalues: u32 (ref), u33 (ref), u34 (ref), u35 (ref), u25 (ref), u11 (ref), u13 (ref), u12 (ref), u16 (ref)
    u32 = nil;
    u33 = nil;
    u34 = nil;
    u35 = nil;

    if u25 == "Circle" then
        u11.UICorner.CornerRadius = UDim.new(1, 0);
        u13.UICorner.CornerRadius = UDim.new(1, 0);
        u12.UICorner.CornerRadius = UDim.new(1, 0);
        u16.Rotation = 0;

        return;
    end;

    u11.UICorner.CornerRadius = UDim.new(0, 0);
    u13.UICorner.CornerRadius = UDim.new(0, 0);
    u12.UICorner.CornerRadius = UDim.new(0, 0);
    u12.Rotation = 180;
end;

local u154 = false;

function u1.Init(p155) -- Line: 980
    -- upvalues: u2 (ref), u4 (ref), u3 (ref), u41 (ref), u42 (ref), u6 (ref), u7 (ref), u43 (ref), u8 (ref), u9 (ref), u10 (ref), u5 (ref), u44 (ref), u154 (ref), GameStats (copy), u1 (copy), u27 (ref), u26 (ref), u25 (ref), u45 (ref)
    u2 = p155:GetModule("Gui");
    u4 = p155:GetModule("CameraController");
    u3 = p155:GetModule("Maid").new();
    u41 = p155:GetModule("NewMapAdded");
    u42 = p155:GetModule("Entities");
    u6 = p155:GetModule("Network");
    u7 = p155:GetModule("WeaponController");
    u43 = p155:GetModule("UIColor");
    u8 = p155:GetModule("PlayerColor");
    u9 = p155:GetModule("GetUserPlatform");
    u10 = u9() == "Mobile";
    u2 = p155:GetModule("Gui");
    u5 = u2.GetComponent("Settings");
    u5:AddConnection("Game", "Radar", "Radar Enabled", function(p156) -- Line: 996
        -- upvalues: u44 (ref), u154 (ref), u2 (ref), GameStats (ref), u1 (ref)
        u44 = p156;

        if not (u154 and (not u2.Handler.HUD.Buymenu.Visible and GameStats:GetAttribute("State") ~= "MatchEnded")) then
            return;
        end;

        u1.Enabled(true);
    end);
    u1.new();
    u5:AddConnection("Game", "Radar", "Radar FPS Cap", function(p157) -- Line: 1007
        -- upvalues: u27 (ref)
        u27 = 1 / math.max(1, p157);
    end);
    u5:AddConnection("Game", "Radar", "Radar Zoom Level", function(p158) -- Line: 1012
        -- upvalues: u26 (ref)
        u26 = 1 / (p158 - 0.3);
    end);
    u5:AddConnection("Game", "Radar", "Radar Shape", function(p159) -- Line: 1017
        -- upvalues: u25 (ref), u1 (ref)
        u25 = p159;
        u1.Shape();
    end);
    u5:AddConnection("Game", "Radar", "Radar Scale", function(p160) -- Line: 1025
        -- upvalues: u1 (ref)
        u1.ScaleTo(p160);
    end);
    u5:AddConnection("Game", "Radar", "Radar Background Transparency", function(p161) -- Line: 1032
        -- upvalues: u1 (ref)
        u1.TransparencyTo(p161, nil);
    end);
    u5:AddConnection("Game", "Radar", "Radar Transparency", function(p162) -- Line: 1036
        -- upvalues: u1 (ref)
        u1.TransparencyTo(nil, p162);
    end);
    u5:AddConnection("Game", "Radar", "Radar Rotation", function(p163) -- Line: 1041
        -- upvalues: u45 (ref)
        u45 = p163;
    end);
end;

function u1.Start2(p164) -- Line: 1046
    -- upvalues: GameStats (copy), u1 (copy), u41 (ref), LocalPlayer (copy), UpdateLocalPlayerColor (copy), u16 (ref), u8 (ref), u2 (ref), u154 (ref)
    task.defer(function() -- Line: 1047
        -- upvalues: GameStats (ref), u1 (ref)
        local Map = workspace:WaitForChild("Map", 30);

        if Map then
            Map:WaitForChild("Radar", 9000000000);
        end;

        task.delay(2, function() -- Line: 1051
            -- upvalues: GameStats (ref), u1 (ref)
            if GameStats:GetAttribute("State") ~= "MatchEnded" then
                u1.Run();
            end;
        end);
    end);
    u41.OnMapAdded:Connect(function(p165) -- Line: 1058
        -- upvalues: GameStats (ref), u1 (ref)
        if GameStats:GetAttribute("State") ~= "MatchEnded" then
            u1.Run();
        end;
    end);
    u41.OnMapRemove:Connect(function(p166) -- Line: 1064
        -- upvalues: u1 (ref)
        u1.Destroy();
    end);
    LocalPlayer:GetAttributeChangedSignal("Color"):Connect(UpdateLocalPlayerColor);
    GameStats:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 1069
        -- upvalues: u16 (ref), u8 (ref), LocalPlayer (ref), u1 (ref)
        if u16 then
            u16.ImageColor3 = u8.GetColor(LocalPlayer, nil, Color3.fromRGB(110, 197, 255));
        end;

        u1.SetTeam(LocalPlayer:GetAttribute("Team"));
    end);
    GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 1074
        -- upvalues: GameStats (ref), u1 (ref), u2 (ref)
        local Attribute = GameStats:GetAttribute("State");

        if Attribute == "MatchEnded" then
            u1.Enabled(false);

            return;
        end;

        if not (Attribute ~= "Warmup" and (Attribute ~= "Preparation" and (Attribute ~= "RoundTime" and Attribute ~= "Restart")) or (u2.Handler.HUD.Buymenu.Visible or u2.Handler.MainMenu and u2.Handler.MainMenu.Visible)) then
            u1.Enabled(true);
        end;
    end);
    u154 = true;
end;

function u1.new() -- Line: 1090
    -- upvalues: u11 (ref), u16 (ref), CreateCarrierBombIcon (copy), u17 (ref), u14 (ref), u15 (ref), u13 (ref), u12 (ref), u2 (ref)
    u11 = Instance.new("Frame");
    u11.Name = "Radar";
    u11.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647);
    u11.BackgroundTransparency = 0.25;
    u11.Position = UDim2.new(0.015, 0, 0.025, 36);
    u11.Size = UDim2.fromScale(0.225, 0.225);
    local Folder = Instance.new("Folder");
    Folder.Name = "Misc";
    u16 = Instance.new("ImageLabel");
    u16.Name = "You";
    u16.AnchorPoint = Vector2.new(0.5, 0.5);
    u16.BackgroundTransparency = 1;
    u16.Image = "rbxassetid://122385262611498";
    u16.ImageColor3 = Color3.fromRGB(110, 197, 255);
    u16.LayoutOrder = -1;
    u16.Position = UDim2.fromScale(0.5, 0.5);
    u16.ScaleType = Enum.ScaleType.Fit;
    u16.Size = UDim2.fromScale(0.1, 0.1);
    u16.TileSize = UDim2.fromScale(5, 5);
    u16.ZIndex = 5;
    local Frame = Instance.new("Frame");
    Frame.Name = "Fov";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, -1.6);
    Frame.Rotation = 45;
    Frame.Size = UDim2.fromScale(3, 3);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = -135;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.098831, 0.863388),
        NumberSequenceKeypoint.new(0.500531, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame;
    Frame.Parent = u16;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Arrow";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://97571290732091";
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.fromScale(5, 5);
    ImageLabel.ZIndex = 5;
    ImageLabel.Parent = u16;
    CreateCarrierBombIcon(u16);
    u16.Parent = Folder;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "A";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.7, 0.25);
    TextLabel.Size = UDim2.fromScale(0.15, 0.15);
    TextLabel.Text = "A";
    TextLabel.TextColor3 = Color3.fromRGB(241, 199, 61);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Folder;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "B";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.25);
    TextLabel2.Size = UDim2.fromScale(0.15, 0.15);
    TextLabel2.Text = "B";
    TextLabel2.TextColor3 = Color3.fromRGB(241, 199, 61);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Folder;
    u17 = {
        A = TextLabel,
        B = TextLabel2
    };
    Folder.Parent = u11;
    u14 = Instance.new("Folder");
    u14.Name = "Folder";
    u14.Parent = u11;
    u15 = Instance.new("TextLabel");
    u15.Name = "Location";
    u15.AnchorPoint = Vector2.new(0.5, 0);
    u15.AutoLocalize = false;
    u15.BackgroundTransparency = 1;
    u15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u15.Position = UDim2.fromScale(0.5, 1.1);
    u15.Size = UDim2.fromScale(1, 0.1);
    u15.Text = "Bombsite A";
    u15.TextColor3 = Color3.fromRGB(255, 203, 107);
    u15.TextScaled = true;
    u15.ZIndex = 9;
    u15.Parent = u11;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = u11;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = u11;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(255, 203, 107);
    UIStroke.Parent = u11;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = u11;
    u13 = Instance.new("CanvasGroup");
    u13.Name = "Main";
    u13.AnchorPoint = Vector2.new(0.5, 0.5);
    u13.BackgroundTransparency = 1;
    u13.ClipsDescendants = true;
    u13.Position = UDim2.fromScale(0.5, 0.5);
    u13.Size = UDim2.fromScale(1, 1);
    u12 = Instance.new("Frame");
    u12.Name = "Main";
    u12.AnchorPoint = Vector2.new(0.5, 0.5);
    u12.BackgroundTransparency = 1;
    u12.ClipsDescendants = true;
    u12.Position = UDim2.fromScale(0.5, 0.5);
    u12.Size = UDim2.fromScale(2, 2);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = u12;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(1, 0);
    UICorner3.Parent = u13;
    u12.Parent = u13;
    u13.Parent = u11;
    u11.Parent = u2.Handler.HUD;
end;

function u1.bomb() -- Line: 1266
    -- upvalues: u14 (ref)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Bomb";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://82055785021420";
    ImageLabel.ImageColor3 = Color3.fromRGB(255, 0, 4);
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0.2, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.1, 0.1);
    ImageLabel.TileSize = UDim2.fromScale(5, 5);
    ImageLabel.ZIndex = 5;
    ImageLabel.Parent = u14;

    return ImageLabel;
end;

function u1.soundTemplate() -- Line: 1284
    -- upvalues: u14 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "SoundTemplate";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.5, 0.5);
    Frame.ZIndex = 5;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(255, 203, 107);
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    Frame.Parent = u14;

    return Frame;
end;

function u1.playerIn() -- Line: 1309
    -- upvalues: u1 (copy), u14 (ref)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "PlayerIn";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://122385262611498";
    ImageLabel.ImageColor3 = Color3.fromRGB(89, 183, 255);
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0.7, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.1, 0.1);
    ImageLabel.TileSize = UDim2.fromScale(5, 5);
    ImageLabel.ZIndex = 5;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Arrow";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://97571290732091";
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Rotation = 79;
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.TileSize = UDim2.fromScale(5, 5);
    ImageLabel2.ZIndex = 5;
    ImageLabel2.Parent = ImageLabel;
    u1.playerOut().Parent = ImageLabel;
    ImageLabel.Parent = u14;

    return ImageLabel;
end;

function u1.playerOut() -- Line: 1342
    -- upvalues: u14 (ref)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "PlayerOut";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://140480386922828";
    ImageLabel.ImageColor3 = Color3.fromRGB(78, 226, 255);
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.fromScale(5, 5);
    ImageLabel.ZIndex = 5;
    ImageLabel.Parent = u14;

    return ImageLabel;
end;

function u1.questionMark() -- Line: 1360
    -- upvalues: u14 (ref)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "QuestionMark";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = -1;
    TextLabel.Position = UDim2.fromScale(0.5, 0.7);
    TextLabel.Size = UDim2.fromScale(0.15, 0.15);
    TextLabel.Text = "?";
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 4);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 5;
    TextLabel.Parent = u14;

    return TextLabel;
end;

function u1.cross() -- Line: 1382
    -- upvalues: u14 (ref)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Cross";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = -1;
    TextLabel.Position = UDim2.fromScale(0.3, 0.5);
    TextLabel.Size = UDim2.fromScale(0.1, 0.1);
    TextLabel.Text = "X";
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 4);
    TextLabel.TextTransparency = 0;
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 5;
    TextLabel.Parent = u14;

    return TextLabel;
end;

function u1.enemy() -- Line: 1405
    -- upvalues: u14 (ref), u1 (copy)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "PlayerEnemy";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://6976119485";
    ImageLabel.ImageColor3 = Color3.fromRGB(255, 37, 77);
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.Rotation = 270;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.06, 0.06);
    ImageLabel.TileSize = UDim2.fromScale(5, 5);
    ImageLabel.ZIndex = 5;
    ImageLabel.Visible = false;
    ImageLabel.Parent = u14;
    u1.playerOut().Parent = ImageLabel;

    return ImageLabel;
end;

return u1;