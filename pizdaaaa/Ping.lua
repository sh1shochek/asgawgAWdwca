-- ReplicatedStorage.GameClient.Gui.Misc.Ping
-- Script path: ReplicatedStorage.GameClient.Gui.Misc.Ping
-- Decompile time: 14.82 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local _ = ReplicatedStorage.GameStats;
local Ping = ReplicatedStorage.Assets.Ping;
local u2 = nil;
local u3 = nil;
local DroppedWeapons = workspace:WaitForChild("Debris"):WaitForChild("DroppedWeapons");
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
local u18 = {};

local function RefreshConfig() -- Line: 41
    -- upvalues: u18 (copy), u11 (ref)
    u18.TickRate = u11.Get("Game", "TickRate");
end;

local _ = {
    CT = Color3.fromRGB(172, 195, 220),
    T = Color3.fromRGB(255, 203, 107),
    Spectator = Color3.fromRGB(120, 120, 120)
};
local _ = {
    CT = Color3.fromRGB(62, 71, 80),
    T = Color3.fromRGB(80, 63, 34),
    Spectator = Color3.fromRGB(91, 91, 91)
};
local u19 = {};
local u20 = {};
local OverlapParams_new_ret = OverlapParams.new();
OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
OverlapParams_new_ret.MaxParts = 1;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.IgnoreWater = true;
local u21 = 0;

local function RemovePing(p22) -- Line: 67
    -- upvalues: u19 (copy), u20 (copy)
    local table_find_ret = table.find(u19, p22);

    if table_find_ret then
        table.remove(u19, table_find_ret);
    end;

    local Attribute = p22:GetAttribute("Sender");

    if Attribute and u20[Attribute] == p22 then
        u20[Attribute] = nil;
    end;

    p22:Destroy();
end;

function u1.Input() -- Line: 83
    -- upvalues: u4 (ref), u8 (ref), workspace_CurrentCamera (copy), RaycastParams_new_ret (copy), u21 (ref), OverlapParams_new_ret (copy), u19 (copy), u3 (ref), u13 (ref), u1 (copy), LocalPlayer (copy), u12 (ref), u18 (copy)
    if not u4.Handler.HUD.Visible then
        return;
    end;

    if not u8 then
        return;
    end;

    local v23 = workspace:Raycast(workspace_CurrentCamera.CFrame.Position, workspace_CurrentCamera.CFrame.LookVector * 1000, RaycastParams_new_ret);

    if not v23 then
        return;
    end;

    local Position = v23.Position;

    if not Position then
        return;
    end;

    if u21 > 5 then
        return;
    end;

    OverlapParams_new_ret.FilterDescendantsInstances = u19;
    local v24 = nil;
    local Instance2 = v23.Instance;

    if Instance2 then
        local v25 = Instance2:FindFirstAncestorOfClass("Model");

        if v25 and v25:IsDescendantOf(u3) then
            v24 = u13.GetEntity("DroppedWeapon", (tonumber(v25.Name)));

            if v24 then
                v24 = v24.Name;
            end;
        end;
    end;

    if not v24 then
        local PartBoundsInRadius = workspace:GetPartBoundsInRadius(Position, 2, OverlapParams_new_ret);

        if PartBoundsInRadius and (next(PartBoundsInRadius) and PartBoundsInRadius[1]:GetAttribute("Type") ~= "Info") then
            return;
        end;
    end;

    u1.Create(LocalPlayer.UserId, LocalPlayer:GetAttribute("Team"), Position, v24 and "Weapon" or "Info", v24);
    u8.Ping = true;
    u21 = u21 + 1;
    u12.Delay(5 * u18.TickRate, function() -- Line: 139
        -- upvalues: u21 (ref)
        u21 = u21 - 1;
    end);
end;

function u1.Create(p26, p27, p28, p29, p30) -- Line: 145
    -- upvalues: u20 (copy), RemovePing (copy), OverlapParams_new_ret (copy), u19 (copy), u1 (copy), Ping (copy), u17 (ref), Debris (copy), TweenService (copy), u15 (ref), u16 (ref), u2 (ref), u5 (ref), u7 (ref), u4 (ref)
    local v31 = u20[p26];

    if v31 then
        RemovePing(v31);
    end;

    OverlapParams_new_ret.FilterDescendantsInstances = u19;
    local PartBoundsInRadius = workspace:GetPartBoundsInRadius(p28, 2, OverlapParams_new_ret);

    if PartBoundsInRadius and next(PartBoundsInRadius) then
        local v32 = PartBoundsInRadius[1];

        if p29 == "Type" and (v32:GetAttribute("Type") == "Info" and v32:GetAttribute("Team") == p27) then
            v32:Destroy();
            u1.Create(p26, p27, v32.Position, "Warning");
        end;

        return;
    end;

    local u33 = Ping:Clone();
    local BillboardGui = u33.BillboardGui;
    local Circles = BillboardGui.Circles;
    local Folder = BillboardGui.Folder;
    local Color = u17.GetColor(p26, p27);
    local Color3_new_ret = Color3.new(Color.R * 0.35, Color.G * 0.35, Color.B * 0.35);
    task.defer(function() -- Line: 172
        -- upvalues: u1 (ref), Circles (copy), Color (copy), Debris (ref), TweenService (ref)
        for i = 1, 33 do
            local v34 = u1.circle(Circles, Color);
            Debris:AddItem(v34, 0.6);
            TweenService:Create(v34, TweenInfo.new(0.1), {
                ImageTransparency = 0.5
            }):Play();
            task.wait(0.1);
            TweenService:Create(v34, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                ImageTransparency = 1,
                Size = UDim2.fromScale(2.5, 2.5)
            }):Play();
            task.wait(0.2);
            local _ = i;
        end;
    end);

    if p29 == "Warning" then
        Folder.Warning.ImageColor3 = Color3_new_ret;
        Folder.Warning.ImageLabel.ImageColor3 = Color;
        Folder.Warning.Visible = true;
        task.defer(function() -- Line: 191
            -- upvalues: TweenService (ref), Folder (copy), Color3_new_ret (copy), Color (copy)
            for i = 1, 10 do
                TweenService:Create(Folder.Warning, TweenInfo.new(0.1), {
                    ImageColor3 = Color3.fromRGB(89, 34, 36)
                }):Play();
                TweenService:Create(Folder.Warning.ImageLabel, TweenInfo.new(0.1), {
                    ImageColor3 = Color3.fromRGB(255, 98, 101)
                }):Play();
                task.wait(0.1);
                TweenService:Create(Folder.Warning, TweenInfo.new(0.9), {
                    ImageColor3 = Color3_new_ret
                }):Play();
                TweenService:Create(Folder.Warning.ImageLabel, TweenInfo.new(0.5), {
                    ImageColor3 = Color
                }):Play();
                task.wait(0.9);
                local _ = i;
            end;
        end);
    elseif p29 == "Weapon" then
        local v35 = u15.GetCategory(p30) or u16.Get(p30);
        Folder.Weapon.Image = `rbxassetid://{v35.GuiInformation.IconHorizontal}`;
        Folder.Weapon.ImageColor3 = Color;
        Folder.Weapon.Visible = true;
    else
        Folder.Info.BackgroundColor3 = Color3_new_ret;
        Folder.Info.ImageLabel.ImageColor3 = Color;
        Folder.Info.Visible = true;
    end;

    u33:SetAttribute("Type", p29);
    u33:SetAttribute("Team", p27);
    u33:SetAttribute("Sender", p26);
    BillboardGui.ImageLabel.ImageColor3 = Color;
    u33.Attachment.ParticleEmitter.Color = ColorSequence.new(Color);
    u33.CFrame = CFrame.new(p28);
    u33.Parent = u2;
    u5.Play("Misc.Playerping");
    local v36 = u7 or u4 and u4.GetComponent("Radar");
    u7 = v36;

    if u7 then
        u7.CreateSound(25, 1, p28, Color);
    end;

    table.insert(u19, u33);
    u20[p26] = u33;
    task.delay(5, function() -- Line: 233
        -- upvalues: RemovePing (ref), u33 (copy)
        RemovePing(u33);
    end);
end;

function u1.Init(p37) -- Line: 240
    -- upvalues: u4 (ref), u7 (ref), u9 (ref), u5 (ref), u6 (ref), u10 (ref), u11 (ref), u12 (ref), u14 (ref), u15 (ref), u16 (ref), u13 (ref), u17 (ref), u18 (copy), RefreshConfig (copy), RaycastParams_new_ret (copy), DroppedWeapons (copy)
    u4 = p37:GetModule("Gui");
    u7 = u4.GetComponent("Radar");
    u9 = p37:GetModule("Network");
    u5 = p37:GetModule("SoundManager");
    u6 = p37:GetModule("Maid").new();
    u10 = p37:GetModule("CharacterController");
    u11 = p37:GetModule("GameConfiguration");
    u12 = p37:GetModule("Tick");
    u14 = p37:GetModule("Enums");
    u15 = p37:GetModule("ItemManager");
    u16 = p37:GetModule("WeaponManager");
    u13 = p37:GetModule("Entities");
    NewMapAdded = p37:GetModule("NewMapAdded");
    u17 = p37:GetModule("PlayerColor");
    u18.TickRate = u11.Get("Game", "TickRate");
    u11.Updated:Connect(RefreshConfig);
    local Map = workspace:FindFirstChild("Map");

    if Map then
        local Geometry = Map:FindFirstChild("Geometry");
        RaycastParams_new_ret.FilterDescendantsInstances = Geometry and { DroppedWeapons, Geometry } or { DroppedWeapons };
    end;
end;

function u1.Start(p38) -- Line: 267
    -- upvalues: u2 (ref), u3 (ref), u10 (ref), u8 (ref), RaycastParams_new_ret (copy), DroppedWeapons (copy), u9 (ref), u1 (copy), u14 (ref)
    u2 = workspace:WaitForChild("Debris", 5);
    local v39 = u2 and u2:WaitForChild("DroppedWeapons", 5);
    u3 = v39;
    u10.OnCharacterSpawn:Connect(function(p40) -- Line: 271
        -- upvalues: u8 (ref)
        u8 = p40;
    end);
    u10.OnCharacterDestroy:Connect(function() -- Line: 275
        -- upvalues: u8 (ref)
        u8 = nil;
    end);
    NewMapAdded.OnMapAdded:Connect(function(p41) -- Line: 279
        -- upvalues: RaycastParams_new_ret (ref), DroppedWeapons (ref)
        RaycastParams_new_ret.FilterDescendantsInstances = { DroppedWeapons, p41.Geometry };
    end);
    u9.Gui.Ping.On(function(p42) -- Line: 283
        -- upvalues: u1 (ref), u14 (ref)
        u1.Create(p42.Sender, u14.Teams[p42.Team], p42.Position, u14.PingTypes[p42.Type], p42.Weapon and u14.Weapons[p42.Weapon]);
    end);
end;

function u1.circle(p43, p44) -- Line: 288
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://131269837958183";
    ImageLabel.ImageColor3 = p44;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.475, 0.51);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1.4, 1.4);
    ImageLabel.Parent = p43;

    return ImageLabel;
end;

return u1;