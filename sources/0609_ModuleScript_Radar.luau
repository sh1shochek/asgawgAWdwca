-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local GuiService = game:GetService("GuiService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local CreateVoxelSmoke = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local u2 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local Radar = ReplicatedStorage.Assets.UI.Radar;

local function GetCurrentCamera() -- Line: 54
    -- upvalues: Workspace (copy)
    return Workspace.CurrentCamera;
end;

local u3 = u2 and 120 or 200;
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);

local function GetEffectiveScale(p4: number) -- Line: 67
    -- upvalues: u2 (copy)
    if u2 then
        return (p4 - 1) * 0.5 + 1;
    end;

    return p4;
end;

local function RoundToPixel(p5: number) -- Line: 74
    return math.floor(p5 + 0.5);
end;

local u6 = u2 and 30 or 50;
local u7 = u2 and 21 or 35;
local u8 = {
    DeadTeammate = 13,
    LocalPlayer = 15,
    Teammate = 14,
    Enemy = 17,
    Bomb = 19,
    Site = 16,
    EnemyQuestionMark = 20,
    Hostage = 18
};
local u9 = {
    Vertigo = 387,
    ["Winter Vertigo"] = 387,
    Reactor = 67.388
};

local function GetUpperLayerHeight(p10: string?) -- Line: 130
    -- upvalues: u9 (copy)
    if p10 then
        return u9[p10];
    end;

    return nil;
end;

local function IsDeathmatchGamemode() -- Line: 134
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Workspace:GetAttribute("ServerGamemode") == "Deathmatch";
end;

local v11 = {
    A = { -0.02, 0.04 },
    B = { -0.015, -0.005 }
};
local v12 = {
    A = { 0.0425, 0.005 },
    B = { -0.01, -0.01 }
};
local u13 = {
    Mirage = v11,
    ["Winter Mirage"] = v11,
    Vertigo = v12,
    ["Winter Vertigo"] = v12,
    Seaside = {
        A = { -0.01, -0.01 },
        B = { 0, 0.02 }
    },
    ["Dust 2"] = {
        A = { -0.06, -0.04 },
        B = { -0.065, -0.02 }
    }
};
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 0, 0);
local Color3_fromRGB_ret3 = Color3.fromRGB(255, 0, 0);
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 255, 255);
local u14 = nil;
local u15 = { { "Radar Centers The Player", "CentersPlayer" }, { "Radar Hud Size", "Scale" }, { "Radar Is Rotating", "Rotation" }, { "Radar Map Zoom", "Zoom" } };
local u16 = {
    CentersPlayer = true,
    Rotation = false,
    Zoom = 0.7,
    Scale = 1
};
local u17 = nil;
local u18 = nil;

local function getRadarCharacter(p19: userdata?) -- Line: 202
    -- upvalues: Participants (copy), CharacterResolver (copy)
    if not p19 then
        return nil;
    end;

    if p19:IsA("Player") then
        local PlayerCharacter = CharacterResolver.getPlayerCharacter(p19);

        if PlayerCharacter and PlayerCharacter:IsDescendantOf(workspace) then
            return PlayerCharacter;
        end;

        return nil;
    end;

    local v20 = Participants.Character(p19);

    if v20 and v20:IsDescendantOf(workspace) then
        return v20;
    end;

    return nil;
end;

local function getRadarObserverCharacter(p21: userdata?) -- Line: 216
    -- upvalues: getRadarCharacter (copy), CharacterResolver (copy)
    local v22 = getRadarCharacter(p21);

    if not (v22 and CharacterResolver.isAliveCharacter(v22)) then
        return nil;
    end;

    if p21 and p21:GetAttribute("Dead") == true then
        return nil;
    end;

    return v22;
end;

local function GetMinimapReference() -- Line: 229
    -- upvalues: CollectionService (copy)
    local Map = workspace:FindFirstChild("Map");

    if not Map then
        return nil;
    end;

    for _, v in ipairs(CollectionService:GetTagged("Minimap")) do
        if v:IsA("BasePart") and v:IsDescendantOf(Map) then
            local Attribute = v:GetAttribute("TextureSize");
            local v23 = (typeof(Attribute) ~= "number" or Attribute <= 0) and 1024 or Attribute;

            return {
                Size = v.Size,
                Upper = v:FindFirstChild("Upper"),
                Lower = v:FindFirstChild("Lower"),
                Part = v,
                TextureSize = v23
            };
        end;
    end;

    return nil;
end;

local function GetTeammateDisplayColor(p24: userdata, p25: string?) -- Line: 256
    -- upvalues: getRadarCharacter (copy), Colors (copy)
    if not p25 then
        return nil;
    end;

    local v26 = getRadarCharacter(p24);

    if v26 then
        v26 = v26:GetAttribute("CompetitivePlayerColor");
    end;

    return v26 or Colors["Team Color"][p25];
end;

local function createRadarInstance(u27: userdata?, p28: userdata, p29: boolean?) -- Line: 266
    -- upvalues: Profiler (copy), u17 (ref), u1 (copy), u14 (ref)
    Profiler.mark("UI.Radar.CreateRadarForCharacter");

    if u17 then
        u17:Destroy();
        u17 = nil;
    end;

    local v30 = u1.new(u14, u27);
    u17 = v30;
    v30.LocalPlayer = p28;
    v30.Team = p28:GetAttribute("Team");
    v30.IsSpectating = p29 or false;

    if p29 then
        v30.MapImage.Rotation = 90;

        if v30.UpperMapImage then
            v30.UpperMapImage.Rotation = 90;
        end;
    end;

    if u27 then
        v30.Janitor:Add(u27:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 290
            -- upvalues: u17 (ref), u27 (copy)
            if u17 and u27:GetAttribute("Dead") then
                u17:Destroy();
                u17 = nil;
            end;
        end));
    end;
end;

local function GetSiteParts() -- Line: 299
    -- upvalues: CollectionService (copy)
    local v31 = {};

    for _, v in ipairs(CollectionService:GetTagged("PlantArea")) do
        if v:IsA("BasePart") then
            local Attribute = v:GetAttribute("Site");

            if Attribute == "A" or Attribute == "B" then
                if not v31[Attribute] then
                    v31[Attribute] = {};
                end;

                table.insert(v31[Attribute], v.CFrame);
            end;
        end;
    end;

    return v31;
end;

local function GetSiteCenter(p32: table) -- Line: 315
    if #p32 == 0 then
        return Vector3.new(0, 0, 0);
    end;

    local v33 = Vector3.new(0, 0, 0);

    for _, v in ipairs(p32) do
        v33 = v33 + v.Position;
    end;

    return v33 / #p32;
end;

local u34 = {};
local u35 = 0;

local function PlayerHasBomb(p36: userdata) -- Line: 330
    -- upvalues: u34 (copy), HttpService (copy), u35 (ref)
    local Attribute = p36:GetAttribute("Slot5");

    if not Attribute then
        return false;
    end;

    local v37 = u34[Attribute];

    if v37 ~= nil then
        return v37;
    end;

    local v38 = HttpService:JSONDecode(Attribute);
    local v39;

    if v38 == nil then
        v39 = false;
    else
        v39 = v38.Weapon == "C4";
    end;

    if u35 >= 64 then
        table.clear(u34);
        u35 = 0;
    end;

    u34[Attribute] = v39;
    u35 = u35 + 1;

    return v39;
end;

local function PlayerIsCarryingHostage(p40: userdata) -- Line: 355
    return p40:GetAttribute("IsCarryingHostage") == true;
end;

local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.CollisionGroup = "Bullet";
RaycastParams_new_ret.IgnoreWater = true;

local function GetObserverSpottingRay(p41: userdata, p42: userdata, p43: userdata?, p44: vector) -- Line: 364
    -- upvalues: Workspace (copy), CharacterResolver (copy)
    local v45, v46;

    if p41 == p43 then
        local CurrentCamera = Workspace.CurrentCamera;

        if not CurrentCamera then
            return nil, nil, nil;
        end;

        local CFrame = CurrentCamera.CFrame;
        v45 = CFrame.Position;
        v46 = CFrame.LookVector;
    else
        local Head = CharacterResolver.getHead(p42);

        if Head then
            v45 = Head.Position;
            v46 = Head.CFrame.LookVector;
        else
            local RootPart = CharacterResolver.getRootPart(p42);

            if not RootPart then
                return nil, nil, nil;
            end;

            v45 = RootPart.Position + Vector3.new(0, 1.5, 0);
            v46 = RootPart.CFrame.LookVector;
        end;
    end;

    local v47 = p44 - v45;
    local Magnitude = v47.Magnitude;

    if Magnitude <= 1e-6 or Magnitude > 200 then
        return nil, nil, nil;
    end;

    local Unit = v47.Unit;

    if Unit:Dot(v46) <= 0.65 then
        return nil, nil, nil;
    end;

    return v45, Unit, Magnitude;
end;

local function HasClearSpottingLine(p48: vector, p49: vector, p50: number, p51: table) -- Line: 411
    -- upvalues: CreateVoxelSmoke (copy), RaycastParams_new_ret (copy), Workspace (copy)
    if CreateVoxelSmoke.DoesRayIntersectActiveSmoke(p48, p49, p50) then
        return false;
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = p51;

    return Workspace:Raycast(p48, p49 * p50, RaycastParams_new_ret) == nil;
end;

local u52 = {};
local u53 = setmetatable({}, {
    __mode = "k"
});

local function CanObserverSpot(p54: userdata, p55: string, p56: vector, p57: userdata?, p58: userdata?) -- Line: 430
    -- upvalues: getRadarCharacter (copy), CharacterResolver (copy), GetObserverSpottingRay (copy), u52 (copy), CreateVoxelSmoke (copy), RaycastParams_new_ret (copy), Workspace (copy)
    if p54 == p58 or p54:GetAttribute("Team") ~= p55 then
        return false;
    end;

    local v59 = getRadarCharacter(p54);

    if v59 and CharacterResolver.isAliveCharacter(v59) then
        if p54 and p54:GetAttribute("Dead") == true then
            v59 = nil;
        end;
    else
        v59 = nil;
    end;

    if not v59 then
        return false;
    end;

    local v60, v61, v62 = GetObserverSpottingRay(p54, v59, p57, p56);

    if not (v60 and (v61 and v62)) then
        return false;
    end;

    u52[1] = v59;

    if CreateVoxelSmoke.DoesRayIntersectActiveSmoke(v60, v61, v62) then
        return false;
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = u52;

    return Workspace:Raycast(v60, v61 * v62, RaycastParams_new_ret) == nil;
end;

local function IsVisibleToTeam(p63: string, p64: vector, p65: userdata?, p66: userdata?, p67: userdata?) -- Line: 456
    -- upvalues: u52 (copy), Workspace (copy), CollectionService (copy), u53 (copy), CanObserverSpot (copy), Participants (copy)
    table.clear(u52);
    u52[1] = Workspace;
    local Map = Workspace:FindFirstChild("Map");
    local v68;

    if Map then
        v68 = Map:FindFirstChild("Barriers");
    else
        v68 = nil;
    end;

    if v68 then
        table.insert(u52, v68);
    end;

    if p65 then
        table.insert(u52, p65);
    end;

    for _, v in ipairs(CollectionService:GetTagged("Hostage")) do
        if v:IsA("Model") and v ~= p65 then
            table.insert(u52, v);
        end;
    end;

    local v69;

    if p65 then
        v69 = u53[p65];
    else
        v69 = nil;
    end;

    if v69 and CanObserverSpot(v69, p63, p64, p66, p67) then
        return true;
    end;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= v69 and CanObserverSpot(v, p63, p64, p66, p67) then
            if p65 then
                u53[p65] = v;
            end;

            return true;
        end;
    end;

    return false;
end;

local function ReadCachedVisibility(p70: any, p71: number) -- Line: 497
    if p70 and p71 - p70.UpdatedAt <= 0.1 then
        return p70.Visible;
    end;

    return nil;
end;

local function GetEnemyVisibility(p72: any, p73: string, p74: userdata, p75: userdata, p76: number) -- Line: 504
    -- upvalues: CharacterResolver (copy), IsVisibleToTeam (copy)
    local v77 = p72.EnemyVisibilityCache[p73];
    local v78;

    if v77 and p76 - v77.UpdatedAt <= 0.1 then
        v78 = v77.Visible;
    else
        v78 = nil;
    end;

    if v78 ~= nil then
        return v78;
    end;

    if p72.EnemyVisibilityChecksRemaining <= 0 then
        if v77 then
            return v77.Visible;
        end;

        return false;
    end;

    p72.EnemyVisibilityChecksRemaining = p72.EnemyVisibilityChecksRemaining - 1;
    local RootPart = CharacterResolver.getRootPart(p74);
    local v79;

    if RootPart then
        local Head = CharacterResolver.getHead(p74);
        local v80;

        if Head then
            v80 = Head.Position;
        else
            v80 = RootPart.Position + Vector3.new(0, 1.5, 0);
        end;

        v79 = IsVisibleToTeam(p72.Team, v80, p74, p72.LocalPlayer, p75);
    else
        v79 = false;
    end;

    p72.EnemyVisibilityCache[p73] = {
        Visible = v79,
        UpdatedAt = p76
    };

    return v79;
end;

local function GetBombVisibility(p81: any, p82: vector, p83: userdata, p84: number) -- Line: 538
    -- upvalues: IsVisibleToTeam (copy)
    local BombVisibilityCache = p81.BombVisibilityCache;
    local v85;

    if BombVisibilityCache and p84 - BombVisibilityCache.UpdatedAt <= 0.1 then
        v85 = BombVisibilityCache.Visible;
    else
        v85 = nil;
    end;

    if v85 ~= nil then
        return v85;
    end;

    local v86 = IsVisibleToTeam("Counter-Terrorists", p82, p83, p81.LocalPlayer);
    p81.BombVisibilityCache = {
        Visible = v86,
        UpdatedAt = p84
    };

    return v86;
end;

local function GetHostageVisibility(p87: any, p88: string, p89: vector, p90: userdata, p91: number) -- Line: 552
    -- upvalues: IsVisibleToTeam (copy)
    local v92 = p87.HostageVisibilityCache[p88];
    local v93;

    if v92 and p91 - v92.UpdatedAt <= 0.1 then
        v93 = v92.Visible;
    else
        v93 = nil;
    end;

    if v93 ~= nil then
        return v93;
    end;

    local v94 = IsVisibleToTeam("Terrorists", p89, p90, p87.LocalPlayer);
    p87.HostageVisibilityCache[p88] = {
        Visible = v94,
        UpdatedAt = p91
    };

    return v94;
end;

local function HideDirectionIndicators(p95: userdata) -- Line: 573
    for _, child in ipairs(p95:GetChildren()) do
        if child.Name == "Direction" and child:IsA("ImageLabel") then
            child.Visible = false;
        end;
    end;
end;

local u96 = {
    Teammate = "Player",
    Enemy = "Enemy",
    DeadTeammate = "Dead"
};

local function CreateIcon(p97: userdata, p98: string, p99: number) -- Line: 587
    -- upvalues: u96 (copy), Radar (copy), u8 (copy), HideDirectionIndicators (copy)
    local v100 = u96[p98];

    if not v100 then
        error((`Invalid icon type: {p98}`));
    end;

    local v101 = Radar[v100]:Clone();
    v101.ZIndex = u8[p98];
    v101.Position = UDim2.fromScale(0.5, 0.5);
    v101.AnchorPoint = Vector2.new(0.5, 0.5);
    v101.Size = UDim2.fromOffset(p99, p99);
    v101.Parent = p97;
    HideDirectionIndicators(v101);

    return v101;
end;

local function GetHostageAsset() -- Line: 605
    -- upvalues: Radar (copy)
    local Hostage = Radar:FindFirstChild("Hostage");

    if Hostage and Hostage:IsA("ImageLabel") then
        return Hostage;
    end;

    return Radar.Player;
end;

local function ApplyEnemyIconImage(p102: userdata, p103: userdata) -- Line: 614
    -- upvalues: PlayerHasBomb (copy), Radar (copy)
    if PlayerHasBomb(p103) then
        p102.Image = Radar.Bomb.Image;
        p102.Size = UDim2.fromOffset(14, 14);

        return;
    end;

    if p103:GetAttribute("IsCarryingHostage") ~= true then
        p102.Image = Radar.Player.Image;
        p102.Size = UDim2.fromOffset(12, 12);

        return;
    end;

    local Hostage = Radar:FindFirstChild("Hostage");

    if not (Hostage and Hostage:IsA("ImageLabel")) then
        Hostage = Radar.Player;
    end;

    p102.Image = Hostage.Image;
    p102.Size = UDim2.fromOffset(30, 30);
end;

local function GetYawUIDeg(p104: vector, p105: userdata?) -- Line: 628
    local Vector3_new_ret = Vector3.new(p104.X, 0, p104.Z);
    local v106 = Vector3_new_ret.Magnitude < 1e-6 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;

    if p105 then
        v106 = p105.CFrame:VectorToObjectSpace(v106);
    end;

    local math_atan2_ret = math.atan2(-v106.Z, -v106.X);

    return (math.deg(math_atan2_ret) + 90) % 360;
end;

local function ProjectToRadar(p107: any, p108: any, p109: vector, p110: number?, p111: number?) -- Line: 660
    local Size = p108.Size;
    local TextureSize = p108.TextureSize;
    local v112 = p108.Part.CFrame:PointToObjectSpace(p109);
    local v113 = -v112.X / Size.X + 0.5;
    local v114 = -v112.Z / Size.Z + 0.5;
    local ImageRectOffset = p107.MapImage.ImageRectOffset;
    local ImageRectSize = p107.MapImage.ImageRectSize;

    if p110 and p111 then
        v113 = v113 + p110 * ImageRectSize.X / TextureSize;
        v114 = v114 + p111 * ImageRectSize.Y / TextureSize;
    end;

    local v115 = (v113 * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
    local v116 = (v114 * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

    if p107.MapImage.Rotation ~= 0 then
        local math_rad_ret = math.rad(p107.MapImage.Rotation);
        local math_cos_ret = math.cos(math_rad_ret);
        local math_sin_ret = math.sin(math_rad_ret);
        local v117 = v115 - 0.5;
        local v118 = v116 - 0.5;
        v115 = 0.5 + (v117 * math_cos_ret - v118 * math_sin_ret);
        v116 = 0.5 + (v117 * math_sin_ret + v118 * math_cos_ret);
    end;

    return v115, v116;
end;

local function ClampToRadarCircle(p119: number, p120: number, p121: number) -- Line: 714
    local v122 = p119 - 0.5;
    local v123 = p120 - 0.5;
    local math_sqrt_ret = math.sqrt(v122 * v122 + v123 * v123);

    if math_sqrt_ret > 0.5 then
        return v122 / math_sqrt_ret * p121 + 0.5, v123 / math_sqrt_ret * p121 + 0.5, math_sqrt_ret;
    end;

    return p119, p120, math_sqrt_ret;
end;

local function GetClampedRadarPosition(p124: any, p125: any, p126: vector) -- Line: 729
    -- upvalues: ProjectToRadar (copy), ClampToRadarCircle (copy)
    local v127, v128 = ProjectToRadar(p124, p125, p126);

    return ClampToRadarCircle(v127, v128, 0.5);
end;

local function ScheduleDeadIconFade(u129: any, u130: string) -- Line: 738
    -- upvalues: TweenService (copy)
    task.delay(2, function() -- Line: 739
        -- upvalues: u129 (copy), u130 (copy), TweenService (ref)
        local v131 = u129.Icons[u130];

        if v131 and (v131.Instance and v131.Instance.Parent) then
            u129.FadedDeadIcons[u130] = true;
            local v132 = TweenService:Create(v131.Instance, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                ImageTransparency = 1
            });
            v132:Play();
            v132.Completed:Connect(function() -- Line: 754
                -- upvalues: u129 (ref), u130 (ref)
                if u129.Icons[u130] then
                    u129:RemoveIcon(u130);
                end;
            end);
        end;
    end);
end;

local function CreateRadarCircle(p133: any, p134: string, p135: boolean) -- Line: 764
    -- upvalues: Color3_fromRGB_ret4 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = p134;
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.ZIndex = 14;
    Frame.Parent = p133.RadarContainer;

    if p135 then
        Frame.Visible = false;
    end;

    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3_fromRGB_ret4;
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 1;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;

    return Frame;
end;

local function GetCircleRadius(p136: any, p137: number) -- Line: 791
    -- upvalues: u2 (copy), u3 (copy)
    local math_clamp_ret = math.clamp(p136.Zoom or 0.5, 0.1, 1);
    local v138 = p136.Scale or 1;

    if u2 then
        v138 = (v138 - 1) * 0.5 + 1;
    end;

    local v139 = u3 / 2 * v138;

    return math.min(p137 * (0.5 / math_clamp_ret) * v138, v139), v139;
end;

local function IsCharacterMoving(p140) -- Line: 800
    if not p140 then
        return false;
    end;

    local GlobalDirection = p140.GlobalDirection;
    local GlobalVelocity = p140.GlobalVelocity;

    if not (GlobalDirection and GlobalVelocity) then
        return false;
    end;

    local Magnitude = Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z).Magnitude;

    return GlobalDirection.Magnitude > 0.1 and true or Magnitude > 0.1;
end;

local function GetSiteShift(p141: string?, p142: string) -- Line: 814
    -- upvalues: u13 (copy)
    local v143;

    if p141 then
        v143 = u13[p141];
    else
        v143 = nil;
    end;

    if v143 then
        v143 = v143[p142];
    end;

    if v143 then
        return v143[1], v143[2];
    end;

    return nil, nil;
end;

local function ClearEnemyTracking(p144: any, p145: string) -- Line: 824
    p144.EnemyVisibilityState[p145] = nil;
    p144.EnemyLastSeenPositions[p145] = nil;
    p144.EnemyLastSeenPositions[p145 .. "_Frozen"] = nil;
end;

local function CreateDeadIcon(u146: any, p147: userdata, u148: string, p149) -- Line: 831
    -- upvalues: CreateIcon (copy), Participants (copy), Radar (copy), TweenService (copy)
    local v150 = CreateIcon(u146.RadarContainer, "DeadTeammate", 12);
    v150.Name = Participants.Name(p147) .. "_Dead";
    v150.ImageTransparency = 0;

    if p149 then
        v150.ImageColor3 = p149;
    end;

    u146.Icons[u148] = {
        Type = "DeadTeammate",
        Instance = v150,
        Player = p147,
        DefaultSize = Radar.Dead.Size
    };
    task.delay(2, function() -- Line: 739
        -- upvalues: u146 (copy), u148 (copy), TweenService (ref)
        local v151 = u146.Icons[u148];

        if v151 and (v151.Instance and v151.Instance.Parent) then
            u146.FadedDeadIcons[u148] = true;
            local v152 = TweenService:Create(v151.Instance, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                ImageTransparency = 1
            });
            v152:Play();
            v152.Completed:Connect(function() -- Line: 754
                -- upvalues: u146 (ref), u148 (ref)
                if u146.Icons[u148] then
                    u146:RemoveIcon(u148);
                end;
            end);
        end;
    end);

    return v150;
end;

function u1.GetTrackedPosition(p153) -- Line: 854
    -- upvalues: SpectateController (copy), Workspace (copy)
    local v154 = SpectateController.IsFreecamActive() and Workspace.CurrentCamera;

    if v154 then
        return v154.CFrame.Position;
    end;

    local Character = p153.Character;

    if Character then
        Character = Character.PrimaryPart;
    end;

    if Character then
        Character = Character.Position;
    end;

    return Character;
end;

function u1.WorldToRadar(p155: any, p156: vector) -- Line: 867
    -- upvalues: SpectateController (copy), CharacterResolver (copy), ProjectToRadar (copy)
    if not p155.MinimapReference then
        return nil;
    end;

    if not (SpectateController.IsFreecamActive() or CharacterResolver.getRootPart(p155.Character)) then
        return nil;
    end;

    local MinimapReference = p155.MinimapReference;
    local Size = MinimapReference.Size;

    if Size.X == 0 or Size.Z == 0 then
        return nil;
    end;

    local ImageRectSize = p155.MapImage.ImageRectSize;

    if ImageRectSize.X == 0 or ImageRectSize.Y == 0 then
        return nil;
    end;

    local v157, v158 = ProjectToRadar(p155, MinimapReference, p156);

    return Vector2.new(v157, v158);
end;

local function CalculateClampedPosition(p159: userdata, p160: number, p161) -- Line: 892
    -- upvalues: Workspace (copy), GuiService (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local v162;

    if CurrentCamera then
        v162 = CurrentCamera.ViewportSize;
    else
        v162 = p159.AbsoluteSize;
    end;

    local X = v162.X;
    local Y = v162.Y;
    local X2 = GuiService:GetGuiInset().X;
    local v163 = X2 + 50;
    local AnchorPoint = p159.AnchorPoint;
    local v164 = p161.X.Scale * X + p161.X.Offset;
    local v165 = p161.Y.Scale * Y + p161.Y.Offset;
    local v166, v167, v168, v169;

    if AnchorPoint.X == 0.5 and AnchorPoint.Y == 0.5 then
        v166 = v164 - p160 / 2;
        v167 = v165 - p160 / 2;
        v168 = v164 + p160 / 2;
        v169 = v165 + p160 / 2;
    else
        v166 = v164 - AnchorPoint.X * p160;
        v167 = v165 - AnchorPoint.Y * p160;
        v168 = v166 + p160;
        v169 = v167 + p160;
    end;

    local v170 = 0;
    local v171 = v166 >= X2 + 10 and 0 or X2 + 10 - v166;

    if X - 10 < v168 then
        v171 = X - 10 - v168;
    end;

    if v167 < v163 + 10 then
        v170 = v163 + 10 - v167;
    end;

    if Y - 10 < v169 then
        v170 = Y - 10 - v169;
    end;

    return UDim2.new(UDim.new(0, v164 + v171), UDim.new(0, v165 + v170));
end;

function u1.UpdateIcon(p172: any, p173: string, p174: vector, p175: number?) -- Line: 943
    local v176 = p172.Icons[p173];

    if not v176 then
        return;
    end;

    local v177 = p172:WorldToRadar(p174);

    if not v177 then
        v176.Instance.Visible = false;

        return;
    end;

    local X = v177.X;
    local Y = v177.Y;
    local v178 = X - 0.5;
    local v179 = Y - 0.5;
    local math_sqrt_ret = math.sqrt(v178 * v178 + v179 * v179);

    if math_sqrt_ret > 0.5 then
        X = v178 / math_sqrt_ret * 0.5 + 0.5;
        Y = v179 / math_sqrt_ret * 0.5 + 0.5;
    end;

    v176.Instance.Visible = true;
    v176.Instance.Position = UDim2.fromScale(X, Y);

    if p175 then
        v176.Instance.Rotation = math.deg(p175);
    end;
end;

function u1.UpdateTeammateIcon(p180: any, p181: string, p182: vector, p183: number?) -- Line: 966
    -- upvalues: ProjectToRadar (copy)
    local v184 = p180.Icons[p181];

    if not v184 then
        return;
    end;

    local Instance2 = v184.Instance;

    if not (Instance2 and Instance2:IsA("GuiObject")) then
        return;
    end;

    if not p180.MinimapReference then
        Instance2.Visible = false;

        return;
    end;

    local v185, v186 = ProjectToRadar(p180, p180.MinimapReference, p182);
    local v187 = v185 - 0.5;
    local v188 = v186 - 0.5;
    local math_sqrt_ret = math.sqrt(v187 * v187 + v188 * v188);

    if math_sqrt_ret > 0.5 then
        v185 = v187 / math_sqrt_ret * 0.5 + 0.5;
        v186 = v188 / math_sqrt_ret * 0.5 + 0.5;
    end;

    Instance2.Position = UDim2.fromScale(v185, v186);
    Instance2.Visible = true;

    if p183 and Instance2:IsA("ImageLabel") then
        Instance2.Rotation = math.deg(p183);
    end;
end;

function u1.CreatePlayerIcon(p189: any, p190: userdata, p191: string) -- Line: 994
    -- upvalues: PlayerHasBomb (copy), Radar (copy), Color3_fromRGB_ret3 (copy), HideDirectionIndicators (copy), getRadarCharacter (copy), Colors (copy), CreateIcon (copy), Participants (copy)
    local v192;

    if p191 == "Enemy" then
        local v193 = PlayerHasBomb(p190);
        local v194 = p190:GetAttribute("IsCarryingHostage") == true;

        if v193 then
            v192 = Radar.Bomb:Clone();
            v192.Size = UDim2.fromOffset(14, 14);
        elseif v194 then
            local Hostage = Radar:FindFirstChild("Hostage");

            if not (Hostage and Hostage:IsA("ImageLabel")) then
                Hostage = Radar.Player;
            end;

            v192 = Hostage:Clone();
            v192.Size = UDim2.fromOffset(30, 30);
        else
            v192 = Radar.Player:Clone();
            v192.Size = UDim2.fromOffset(12, 12);
        end;

        v192.ImageColor3 = Color3_fromRGB_ret3;
        v192.ZIndex = 17;
        v192.Position = UDim2.fromScale(0.5, 0.5);
        v192.AnchorPoint = Vector2.new(0.5, 0.5);
        v192.Parent = p189.RadarContainer;
        HideDirectionIndicators(v192);
    else
        local Attribute = p190:GetAttribute("Team");
        local v195;

        if Attribute then
            local v196 = getRadarCharacter(p190);

            if v196 then
                v196 = v196:GetAttribute("CompetitivePlayerColor");
            end;

            v195 = v196 or Colors["Team Color"][Attribute];
        else
            v195 = nil;
        end;

        v192 = CreateIcon(p189.RadarContainer, p191, 12);

        if v195 then
            v192.ImageColor3 = v195;
        end;
    end;

    v192.Name = Participants.Name(p190);
    local v197 = Participants.Key(p190) .. "_" .. p191;
    p189.Icons[v197] = {
        Instance = v192,
        Player = p190,
        Type = p191
    };

    return v197;
end;

function u1.RemoveIcon(p198: any, p199: string) -- Line: 1039
    local v200 = p198.Icons[p199];

    if v200 then
        v200.Instance:Destroy();
        p198.Icons[p199] = nil;
    end;
end;

function u1.RefreshPlayerIcon(p201: any, p202: userdata) -- Line: 1048
    -- upvalues: Participants (copy)
    local v203 = Participants.Key(p202);
    local v204 = v203 .. "_Player";
    local v205 = v203 .. "_Dead";
    p201:RemoveIcon(v204);
    p201:RemoveIcon(v205);
    p201.EnemyVisibilityCache[v204] = nil;
    p201.EnemyVisibilityState[v204] = nil;
    p201.EnemyLastSeenPositions[v204] = nil;
    p201.EnemyLastSeenPositions[v204 .. "_Frozen"] = nil;
    p201.DeadPlayerPositions[v203] = nil;
    p201.FadedDeadIcons[v205] = nil;
end;

function u1.RefreshIconsOnTeamChange(p206) -- Line: 1060
    -- upvalues: LocalPlayer (copy), getRadarCharacter (copy), Colors (copy)
    local Team = p206.Team;
    local Attribute = LocalPlayer:GetAttribute("Team");

    if not Attribute then
        return;
    end;

    p206.Team = Attribute;

    if p206.Team == Team then
        return;
    end;

    for i, v in pairs(p206.Icons) do
        if v.Player and v.Player ~= LocalPlayer then
            p206:RemoveIcon(i);
        end;
    end;

    table.clear(p206.EnemyVisibilityCache);
    table.clear(p206.HostageVisibilityCache);
    p206.BombVisibilityCache = nil;
    p206.EnemyVisibilityState = {};
    p206.EnemyLastSeenPositions = {};
    p206.DeadPlayerPositions = {};
    p206.FadedDeadIcons = {};

    if p206.Icons.LocalPlayer then
        local Instance2 = p206.Icons.LocalPlayer.Instance;
        local LocalPlayer2 = p206.LocalPlayer;
        local Team2 = p206.Team;
        local v207;

        if Team2 then
            local v208 = getRadarCharacter(LocalPlayer2);

            if v208 then
                v208 = v208:GetAttribute("CompetitivePlayerColor");
            end;

            v207 = v208 or Colors["Team Color"][Team2];
        else
            v207 = nil;
        end;

        if v207 then
            Instance2.ImageColor3 = v207;
        end;
    end;
end;

function u1.UpdatePlayerIcons(u209) -- Line: 1101
    -- upvalues: Profiler (copy), Workspace (copy), CharacterResolver (copy), SpectateController (copy), Radar (copy), LocalPlayer (copy), getRadarCharacter (copy), Colors (copy), Color3_fromRGB_ret (copy), PlayerHasBomb (copy), Participants (copy), Color3_fromRGB_ret3 (copy), CreateDeadIcon (copy), GetEnemyVisibility (copy), ApplyEnemyIconImage (copy), TweenService (copy), ProjectToRadar (copy)
    Profiler.mark("UI.Radar.UpdatePlayerIcons");
    local v210 = Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Workspace:GetAttribute("ServerGamemode") == "Deathmatch";
    local v211 = tick();
    local RootPart = CharacterResolver.getRootPart(u209.Character);
    local v212;

    if SpectateController.IsFreecamActive() then
        v212 = Workspace.CurrentCamera;

        if v212 then
            v212 = v212.CFrame;
        end;
    else
        v212 = nil;
    end;

    local v213 = v212 ~= nil;

    for i, v in pairs(u209.Icons) do
        if v.Instance.Parent == nil then
            u209.Icons[i] = nil;
        end;
    end;

    local v214 = u209.MinimapReference and u209.MinimapReference.Part;

    if v212 then
        RootPart = v212;
    elseif RootPart then
        RootPart = RootPart.CFrame;
    end;

    if RootPart then
        if not u209.Icons.LocalPlayer then
            local v215 = Radar.Player:Clone();
            v215.Position = UDim2.fromScale(0.5, 0.5);
            v215.AnchorPoint = Vector2.new(0.5, 0.5);
            v215.ZIndex = 15;
            v215.Parent = u209.RadarContainer;
            v215.Name = "LocalPlayer";
            u209.Icons.LocalPlayer = {
                Type = "Teammate",
                Instance = v215,
                Player = u209.LocalPlayer
            };
        end;

        local Instance2 = u209.Icons.LocalPlayer.Instance;
        Instance2.Visible = true;

        if v213 then
            local Attribute = LocalPlayer:GetAttribute("Team");
            local v216 = LocalPlayer;
            local v217;

            if Attribute then
                local v218 = getRadarCharacter(v216);

                if v218 then
                    v218 = v218:GetAttribute("CompetitivePlayerColor");
                end;

                v217 = v218 or Colors["Team Color"][Attribute];
            else
                v217 = nil;
            end;

            Instance2.ImageColor3 = v217 or Color3_fromRGB_ret;
        else
            local LocalPlayer2 = u209.LocalPlayer;
            local Team = u209.Team;
            local v219;

            if Team then
                local v220 = getRadarCharacter(LocalPlayer2);

                if v220 then
                    v220 = v220:GetAttribute("CompetitivePlayerColor");
                end;

                v219 = v220 or Colors["Team Color"][Team];
            else
                v219 = nil;
            end;

            if v219 then
                Instance2.ImageColor3 = v219;
            end;
        end;

        local v221 = not v213 and PlayerHasBomb(u209.LocalPlayer);

        if v221 then
            Instance2.Image = Radar.Bomb.Image;
            Instance2.Size = UDim2.fromOffset(14, 14);
        else
            Instance2.Image = Radar.Player.Image;
            Instance2.Size = UDim2.fromOffset(12, 12);
        end;

        local v222;

        if v214 then
            local LookVector = RootPart.LookVector;
            local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);
            local v223 = Vector3_new_ret.Magnitude < 1e-6 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;

            if v214 then
                v223 = v214.CFrame:VectorToObjectSpace(v223);
            end;

            local math_atan2_ret = math.atan2(-v223.Z, -v223.X);
            v222 = (math.deg(math_atan2_ret) + 90) % 360 + u209.MapImage.Rotation + 0;
        else
            v222 = 0;
        end;

        u209:UpdateIcon("LocalPlayer", RootPart.Position, (math.rad(v222)));
    end;

    for _, v in ipairs(Participants.GetAll()) do
        local v224 = Participants.Key(v);
        local u225 = v224 .. "_Player";

        if v213 or v ~= u209.LocalPlayer then
            local v226 = v224 .. "_Dead";
            local v227 = getRadarCharacter(v);
            local RootPart2 = CharacterResolver.getRootPart(v227);
            local Attribute = v:GetAttribute("Team");

            if Attribute and Attribute ~= "Spectators" then
                local v228 = u209.DeadPlayerPositions[v224];
                local v229;

                if v228 == nil then
                    if v227 == nil then
                        v229 = false;
                    else
                        v229 = v227:GetAttribute("Dead") == true;
                    end;
                else
                    v229 = true;
                end;

                local v230 = v:GetAttribute("Dead") == true and true or v229;
                local v231;

                if v210 then
                    v231 = v210;
                else
                    v231 = not (v213 or Attribute == u209.Team);
                end;

                if v230 then
                    u209:RemoveIcon(u225);

                    if not v228 and RootPart2 then
                        v228 = RootPart2.Position;
                        u209.DeadPlayerPositions[v224] = v228;
                    end;

                    if v228 and not (u209.Icons[v226] or u209.FadedDeadIcons[v226]) then
                        local v232;

                        if v231 then
                            v232 = Color3_fromRGB_ret3;
                        elseif Attribute then
                            local v233 = getRadarCharacter(v);

                            if v233 then
                                v233 = v233:GetAttribute("CompetitivePlayerColor");
                            end;

                            v232 = v233 or Colors["Team Color"][Attribute];
                        else
                            v232 = nil;
                        end;

                        CreateDeadIcon(u209, v, v226, v232);
                    end;

                    if v231 then
                        u209.EnemyVisibilityState[u225] = nil;
                        u209.EnemyLastSeenPositions[u225] = nil;
                        u209.EnemyLastSeenPositions[u225 .. "_Frozen"] = nil;
                    end;
                else
                    if v227 and RootPart2 then
                        u209:RemoveIcon(v226);
                        u209.DeadPlayerPositions[v224] = nil;
                        u209.FadedDeadIcons[v226] = nil;
                        local v234 = u209.Icons[u225];

                        if v234 and v231 ~= (v234.Type ~= "Teammate") then
                            u209:RemoveIcon(u225);
                        end;

                        if not u209.Icons[u225] then
                            local v235 = u209:CreatePlayerIcon(v, v231 and "Enemy" or "Teammate");
                            u209.Icons[u225] = u209.Icons[v235];
                            u209.Icons[v235] = nil;

                            if v231 then
                                u209.Icons[u225].Instance.Visible = false;
                            end;
                        end;
                    end;

                    local v236 = u209.Icons[u225];

                    if v231 then
                        if v236 then
                            if v227 or Participants.IsAlive(v) then
                                local v237;

                                if v213 then
                                    v237 = v213;
                                elseif v227 == nil then
                                    v237 = false;
                                else
                                    v237 = GetEnemyVisibility(u209, u225, v227, v, v211);
                                end;

                                if v237 then
                                    if v236.Type == "EnemyQuestionMark" then
                                        local FadeTween = v236.FadeTween;

                                        if FadeTween then
                                            FadeTween:Cancel();
                                            v236.FadeTween = nil;
                                        end;

                                        local Instance2 = v236.Instance;

                                        if Instance2:IsA("TextLabel") then
                                            local Position = Instance2.Position;
                                            local AnchorPoint = Instance2.AnchorPoint;
                                            Instance2:Destroy();
                                            local ImageLabel = Instance.new("ImageLabel");
                                            ImageLabel.Name = Participants.Name(v) .. "_Enemy";
                                            ApplyEnemyIconImage(ImageLabel, v);
                                            ImageLabel.ImageColor3 = Color3_fromRGB_ret3;
                                            ImageLabel.BackgroundTransparency = 1;
                                            ImageLabel.BorderSizePixel = 0;
                                            ImageLabel.Position = Position;
                                            ImageLabel.AnchorPoint = AnchorPoint;
                                            ImageLabel.ZIndex = 17;
                                            ImageLabel.Visible = true;
                                            ImageLabel.Parent = u209.RadarContainer;
                                            v236.Instance = ImageLabel;
                                            v236.Type = "Enemy";
                                            u209.EnemyLastSeenPositions[u225 .. "_Frozen"] = nil;
                                        end;
                                    end;

                                    if RootPart2 then
                                        local Instance2 = v236.Instance;
                                        Instance2.Visible = true;
                                        Instance2.ImageColor3 = Color3_fromRGB_ret3;
                                        ApplyEnemyIconImage(Instance2, v);
                                        u209:UpdateTeammateIcon(u225, RootPart2.Position, nil);
                                        u209.EnemyLastSeenPositions[u225] = RootPart2.Position;
                                    else
                                        u209:RemoveIcon(u225);
                                    end;
                                else
                                    if u209.EnemyVisibilityState[u225] then
                                        local Instance2 = v236.Instance;
                                        local v238 = nil;
                                        local v239 = nil;
                                        local FadeTween = v236.FadeTween;

                                        if FadeTween then
                                            FadeTween:Cancel();
                                            v236.FadeTween = nil;
                                        end;

                                        if Instance2:IsA("ImageLabel") or Instance2:IsA("TextLabel") then
                                            v238 = Instance2.Position;
                                            v239 = Instance2.AnchorPoint;
                                            Instance2:Destroy();
                                        end;

                                        local u240 = Radar.EnemySeen:Clone();
                                        u240.Name = Participants.Name(v) .. "_QuestionMark";
                                        u240.Position = v238;
                                        u240.AnchorPoint = v239;
                                        u240.ZIndex = 20;
                                        u240.TextTransparency = 0;
                                        u240.Visible = true;
                                        u240.Parent = u209.RadarContainer;
                                        v236.Instance = u240;
                                        v236.Type = "EnemyQuestionMark";

                                        if u209.EnemyLastSeenPositions[u225] then
                                            u209.EnemyLastSeenPositions[u225 .. "_Frozen"] = u209.EnemyLastSeenPositions[u225];
                                        end;

                                        task.delay(0.1, function() -- Line: 1378
                                            -- upvalues: u209 (copy), u225 (copy), u240 (copy), TweenService (ref)
                                            local v241 = u209.Icons[u225];

                                            if v241 and (v241.Instance == u240 and u240:IsA("TextLabel")) then
                                                local u242 = u240;
                                                u242.TextTransparency = 0;
                                                local u243 = TweenService:Create(u242, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                                                    TextTransparency = 1
                                                });
                                                u243:Play();
                                                v241.FadeTween = u243;
                                                u243.Completed:Connect(function(p244) -- Line: 1399
                                                    -- upvalues: u209 (ref), u225 (ref), u242 (copy), u243 (copy)
                                                    local v245 = u209.Icons[u225];

                                                    if p244 == Enum.PlaybackState.Completed and (v245 and (v245.Instance == u242 and v245.FadeTween == u243)) then
                                                        u209:RemoveIcon(u225);
                                                        u209.EnemyLastSeenPositions[u225 .. "_Frozen"] = nil;
                                                    end;
                                                end);
                                            end;
                                        end);
                                    end;

                                    if v236.Type == "EnemyQuestionMark" then
                                        local v246 = u209.EnemyLastSeenPositions[u225 .. "_Frozen"];

                                        if v246 then
                                            u209:UpdateQuestionMarkIcon(u225, v246);
                                        end;
                                    else
                                        v236.Instance.Visible = false;
                                    end;
                                end;

                                if u209.Icons[u225] then
                                    u209.EnemyVisibilityState[u225] = v237;
                                end;
                            else
                                u209:RemoveIcon(u225);
                                local v247 = u209.EnemyLastSeenPositions[u225] or u209.EnemyLastSeenPositions[u225 .. "_Frozen"];

                                if v247 then
                                    u209.DeadPlayerPositions[v224] = v247;

                                    if not (u209.Icons[v226] or u209.FadedDeadIcons[v226]) then
                                        CreateDeadIcon(u209, v, v226, Color3_fromRGB_ret3);
                                    end;
                                end;

                                u209.EnemyVisibilityState[u225] = nil;
                                u209.EnemyLastSeenPositions[u225] = nil;
                                u209.EnemyLastSeenPositions[u225 .. "_Frozen"] = nil;
                            end;
                        end;
                    elseif RootPart2 then
                        u209:UpdateTeammateIcon(u225, RootPart2.Position, nil);
                    else
                        u209:RemoveIcon(u225);
                    end;
                end;
            else
                u209:RemoveIcon(u225);
                u209:RemoveIcon(v226);
                u209.EnemyVisibilityState[u225] = nil;
                u209.EnemyLastSeenPositions[u225] = nil;
                u209.EnemyLastSeenPositions[u225 .. "_Frozen"] = nil;
                u209.DeadPlayerPositions[v224] = nil;
                u209.FadedDeadIcons[v226] = nil;
            end;
        else
            u209:RemoveIcon(u225);
        end;
    end;

    for i, v in pairs(u209.DeadPlayerPositions) do
        local v248 = u209.Icons[i .. "_Dead"];

        if v248 and u209.MinimapReference then
            local v249, v250 = ProjectToRadar(u209, u209.MinimapReference, v);
            local v251 = v249 - 0.5;
            local v252 = v250 - 0.5;
            local math_sqrt_ret = math.sqrt(v251 * v251 + v252 * v252);

            if math_sqrt_ret > 0.5 then
                v249 = v251 / math_sqrt_ret * 0.5 + 0.5;
                v250 = v252 / math_sqrt_ret * 0.5 + 0.5;
            end;

            v248.Instance.Position = UDim2.fromScale(v249, v250);
            v248.Instance.Visible = true;
        end;
    end;
end;

local function SetBombIconAppearance(p253: userdata, p254: number, p255) -- Line: 1446
    if p253:IsA("ImageLabel") or p253:IsA("ImageButton") then
        p253.ImageTransparency = p254;

        if p255 then
            p253.ImageColor3 = p255;
        end;
    elseif p253:IsA("TextLabel") or p253:IsA("TextButton") then
        p253.TextTransparency = p254;
    end;
end;

function u1.UpdateBombIcon(p256) -- Line: 1457
    -- upvalues: Profiler (copy), CollectionService (copy), Workspace (copy), Radar (copy), ProjectToRadar (copy), Color3_fromRGB_ret2 (copy), SetBombIconAppearance (copy), IsVisibleToTeam (copy)
    Profiler.mark("UI.Radar.UpdateBombIcon");
    local v257 = nil;
    local v258 = p256.Team == "Counter-Terrorists";
    local v259 = CollectionService:GetTagged("Bomb")[1];

    if Workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v259 = nil;
    end;

    if v259 and (v259:IsA("Model") and v259.PrimaryPart) then
        v257 = v259;
    else
        for _, v in ipairs(CollectionService:GetTagged("WeaponDropped")) do
            if v:IsA("Model") and (v.PrimaryPart and v:GetAttribute("Weapon") == "C4") then
                v257 = v;
                break;
            end;
        end;
    end;

    if not v257 then
        if p256.Icons.Bomb then
            p256.Icons.Bomb.Instance.Visible = false;
            p256.BombIsVisible = false;
            p256.BombFadeStartTime = nil;
        end;

        p256.BombVisibilityCache = nil;

        return;
    end;

    if not p256.Icons.Bomb then
        local v260 = Radar.Bomb:Clone();
        v260.Position = UDim2.fromScale(0.5, 0.5);
        v260.AnchorPoint = Vector2.new(0.5, 0.5);
        v260.Parent = p256.RadarContainer;
        v260.Size = UDim2.fromOffset(14, 14);
        v260.ZIndex = 19;
        v260.Name = "Bomb";
        p256.Icons.Bomb = {
            Player = nil,
            Type = "Bomb",
            Instance = v260
        };
    end;

    local Instance2 = p256.Icons.Bomb.Instance;

    if not p256.MinimapReference then
        Instance2.Visible = false;

        return;
    end;

    local Position = v257.PrimaryPart.Position;
    local v261, v262 = ProjectToRadar(p256, p256.MinimapReference, Position);
    local v263 = v261 - 0.5;
    local v264 = v262 - 0.5;
    local math_sqrt_ret = math.sqrt(v263 * v263 + v264 * v264);

    if math_sqrt_ret > 0.5 then
        v261 = v263 / math_sqrt_ret * 0.5 + 0.5;
        v262 = v264 / math_sqrt_ret * 0.5 + 0.5;
    end;

    Instance2.Position = UDim2.fromScale(v261, v262);

    if not v258 or v259 then
        Instance2.Visible = true;
        local v265;

        if v259 and (v258 and math_sqrt_ret > 0.5) then
            v265 = Color3_fromRGB_ret2;
        else
            v265 = nil;
        end;

        SetBombIconAppearance(Instance2, 0, v265);

        return;
    end;

    local v266 = tick();
    local BombVisibilityCache = p256.BombVisibilityCache;
    local v267;

    if BombVisibilityCache and v266 - BombVisibilityCache.UpdatedAt <= 0.1 then
        v267 = BombVisibilityCache.Visible;
    else
        v267 = nil;
    end;

    if v267 == nil then
        v267 = IsVisibleToTeam("Counter-Terrorists", Position, v257, p256.LocalPlayer);
        p256.BombVisibilityCache = {
            Visible = v267,
            UpdatedAt = v266
        };
    end;

    if not v267 then
        if p256.BombIsVisible then
            p256.BombFadeStartTime = v266;
        end;

        p256.BombIsVisible = false;

        if p256.BombFadeStartTime then
            local math_clamp_ret = math.clamp((v266 - p256.BombFadeStartTime) / 8, 0, 1);

            if math_clamp_ret >= 1 then
                Instance2.Visible = false;

                return;
            end;

            Instance2.Visible = true;

            if Instance2:IsA("ImageLabel") or Instance2:IsA("ImageButton") then
                Instance2.ImageTransparency = math_clamp_ret;

                return;
            end;

            if Instance2:IsA("TextLabel") or Instance2:IsA("TextButton") then
                Instance2.TextTransparency = math_clamp_ret;

                return;
            end;
        else
            Instance2.Visible = false;
        end;

        return;
    end;

    if not p256.BombIsVisible then
        p256.BombFadeStartTime = nil;
    end;

    p256.BombIsVisible = true;
    Instance2.Visible = true;
    SetBombIconAppearance(Instance2, 0, Color3_fromRGB_ret2);
end;

function u1.UpdateQuestionMarkIcon(p268: any, p269: string, p270: vector) -- Line: 1562
    -- upvalues: ProjectToRadar (copy)
    local v271 = p268.Icons[p269];

    if not (v271 and p268.MinimapReference) then
        return;
    end;

    local Instance2 = v271.Instance;

    if not (Instance2 and Instance2:IsA("TextLabel")) then
        return;
    end;

    local v272, v273 = ProjectToRadar(p268, p268.MinimapReference, p270);
    local v274 = v272 - 0.5;
    local v275 = v273 - 0.5;
    local math_sqrt_ret = math.sqrt(v274 * v274 + v275 * v275);

    if math_sqrt_ret > 0.5 then
        v272 = v274 / math_sqrt_ret * 0.5 + 0.5;
        v273 = v275 / math_sqrt_ret * 0.5 + 0.5;
    end;

    Instance2.Position = UDim2.fromScale(v272, v273);
    Instance2.Visible = true;
end;

function u1.UpdateSiteIcons(p276) -- Line: 1582
    -- upvalues: Profiler (copy), Radar (copy), u13 (copy), ProjectToRadar (copy)
    Profiler.mark("UI.Radar.UpdateSiteIcons");

    for i, v in pairs(p276.SiteParts) do
        local v277 = "Site_" .. i;
        local v278, v279;

        if #v == 0 then
            v278 = i;
            v279 = Vector3.new(0, 0, 0);
        else
            v278 = i;
            local v280 = Vector3.new(0, 0, 0);

            for _, v2 in ipairs(v) do
                v280 = v280 + v2.Position;
            end;

            v279 = v280 / #v;
        end;

        local v281, v282, v283, v284, v285, v286, v287, v288, v289, v290, v291, v292, v293, v294;

        if p276.Icons[v277] then
            v281 = p276.Icons[v277];

            if p276.MinimapReference then
                v282 = 0.5 / math.clamp(p276.Settings.Zoom or 0.5, 0.1, 1);
                v283 = workspace:GetAttribute("Map");

                if v283 then
                    v284 = u13[v283];
                else
                    v284 = nil;
                end;

                if v284 then
                    v284 = v284[v278];
                end;

                if v284 then
                    v285 = v284[1];
                    v286 = v284[2];
                else
                    v285 = nil;
                    v286 = nil;
                end;

                if v285 and v286 then
                    v285 = v285 * v282;
                    v286 = v286 * v282;
                end;

                v287, v288 = ProjectToRadar(p276, p276.MinimapReference, v279, v285, v286);
                v289 = v287 - 0.5;
                v290 = v288 - 0.5;
                v291 = math.sqrt(v289 * v289 + v290 * v290);

                if v291 > 0.5 then
                    v292 = v289 / v291;
                    v293 = v290 / v291;
                    v287 = v292 * 0.485 + 0.5;
                    v288 = v293 * 0.485 + 0.5;
                end;

                v281.Instance.Position = UDim2.fromScale(v287, v288);
                v281.Instance.Visible = true;
                v294 = v281.DefaultSize;

                if v294 then
                    if v291 > 0.5 then
                        v281.Instance.Size = v294;
                    else
                        v281.Instance.Size = UDim2.new(v294.X.Scale * v282, v294.X.Offset * v282, v294.Y.Scale * v282, v294.Y.Offset * v282);
                    end;
                end;
            else
                v281.Instance.Visible = false;
            end;
        else
            local v295 = Radar:FindFirstChild(v278);

            if v295 then
                local v296 = v295:Clone();
                v296.Name = v278 .. "_Icon";
                v296.Position = UDim2.fromScale(0.5, 0.5);
                v296.AnchorPoint = Vector2.new(0.5, 0.5);
                v296.ZIndex = 16;
                v296.Visible = true;

                if v296:IsA("TextLabel") then
                    v296.TextXAlignment = Enum.TextXAlignment.Center;
                    v296.TextYAlignment = Enum.TextYAlignment.Center;
                end;

                v296.Parent = p276.RadarContainer;
                p276.Icons[v277] = {
                    Player = nil,
                    Type = "Site",
                    Instance = v296,
                    DefaultSize = v295.Size
                };
                v281 = p276.Icons[v277];

                if p276.MinimapReference then
                    v282 = 0.5 / math.clamp(p276.Settings.Zoom or 0.5, 0.1, 1);
                    v283 = workspace:GetAttribute("Map");

                    if v283 then
                        v284 = u13[v283];
                    else
                        v284 = nil;
                    end;

                    if v284 then
                        v284 = v284[v278];
                    end;

                    if v284 then
                        v285 = v284[1];
                        v286 = v284[2];
                    else
                        v285 = nil;
                        v286 = nil;
                    end;

                    if v285 and v286 then
                        v285 = v285 * v282;
                        v286 = v286 * v282;
                    end;

                    v287, v288 = ProjectToRadar(p276, p276.MinimapReference, v279, v285, v286);
                    v289 = v287 - 0.5;
                    v290 = v288 - 0.5;
                    v291 = math.sqrt(v289 * v289 + v290 * v290);

                    if v291 > 0.5 then
                        v292 = v289 / v291;
                        v293 = v290 / v291;
                        v287 = v292 * 0.485 + 0.5;
                        v288 = v293 * 0.485 + 0.5;
                    end;

                    v281.Instance.Position = UDim2.fromScale(v287, v288);
                    v281.Instance.Visible = true;
                    v294 = v281.DefaultSize;

                    if v294 then
                        if v291 > 0.5 then
                            v281.Instance.Size = v294;
                        else
                            v281.Instance.Size = UDim2.new(v294.X.Scale * v282, v294.X.Offset * v282, v294.Y.Scale * v282, v294.Y.Offset * v282);
                        end;
                    end;
                else
                    v281.Instance.Visible = false;
                end;
            end;

            warn((`Site icon template not found for: {v278}`));
        end;
    end;
end;

function u1.UpdateHostageIcons(p297) -- Line: 1657
    -- upvalues: Profiler (copy), CollectionService (copy), Radar (copy), HideDirectionIndicators (copy), Players (copy), getRadarCharacter (copy), ProjectToRadar (copy), GetHostageVisibility (copy)
    Profiler.mark("UI.Radar.UpdateHostageIcons");
    local v298 = tick();
    local v299 = {};

    for _, v in ipairs(CollectionService:GetTagged("Hostage")) do
        if v:IsA("Model") and v.PrimaryPart then
            local Name = v.Name;
            local v300 = "Hostage_" .. Name;
            v299[v300] = true;

            if not p297.Icons[v300] then
                local Hostage = Radar:FindFirstChild("Hostage");

                if not (Hostage and Hostage:IsA("ImageLabel")) then
                    Hostage = Radar.Player;
                end;

                local v301 = Hostage:Clone();
                v301.Position = UDim2.fromScale(0.5, 0.5);
                v301.AnchorPoint = Vector2.new(0.5, 0.5);
                v301.Parent = p297.RadarContainer;
                v301.Size = UDim2.fromOffset(30, 30);
                v301.ZIndex = 18;
                v301.Name = "Hostage_" .. Name;
                v301.Visible = true;
                HideDirectionIndicators(v301);
                p297.Icons[v300] = {
                    Player = nil,
                    Type = "Hostage",
                    Instance = v301
                };
            end;

            local v302 = p297.Icons[v300];

            if p297.MinimapReference then
                local Position = v.PrimaryPart.Position;
                local Attribute = v:GetAttribute("CarryingPlayer");

                if Attribute then
                    local v303 = Players:FindFirstChild(Attribute);
                    local v304;

                    if v303 and v303:IsA("Player") then
                        v304 = getRadarCharacter(v303);
                    else
                        v304 = nil;
                    end;

                    if v304 and v304.PrimaryPart then
                        Position = v304.PrimaryPart.Position;
                    end;
                end;

                local v305, v306 = ProjectToRadar(p297, p297.MinimapReference, Position);
                local v307 = v305 - 0.5;
                local v308 = v306 - 0.5;
                local math_sqrt_ret = math.sqrt(v307 * v307 + v308 * v308);

                if math_sqrt_ret > 0.5 then
                    v305 = v307 / math_sqrt_ret * 0.5 + 0.5;
                    v306 = v308 / math_sqrt_ret * 0.5 + 0.5;
                end;

                v302.Instance.Position = UDim2.fromScale(v305, v306);
                local Team = p297.Team;

                if Attribute == nil then
                    v302.Instance.Visible = Team == "Terrorists";
                elseif Team == "Terrorists" then
                    v302.Instance.Visible = GetHostageVisibility(p297, v300, Position, v, v298);
                else
                    v302.Instance.Visible = true;
                end;
            else
                v302.Instance.Visible = false;
            end;
        end;
    end;

    for i, v in pairs(p297.Icons) do
        if v.Type == "Hostage" and not v299[i] then
            p297.HostageVisibilityCache[i] = nil;
            p297:RemoveIcon(i);
        end;
    end;
end;

function u1.UpdateMinimapTexture(p309) -- Line: 1732
    -- upvalues: Profiler (copy), u9 (copy), Workspace (copy)
    Profiler.mark("UI.Radar.UpdateMinimapTexture");

    if not p309.MinimapReference then
        return;
    end;

    local MinimapReference = p309.MinimapReference;
    local Part = MinimapReference.Part;

    if Part then
        local Lower = Part:FindFirstChild("Lower");
        local Upper = Part:FindFirstChild("Upper");

        if Lower and Lower:IsA("Decal") then
            MinimapReference.Lower = Lower;
        end;

        if Upper and Upper:IsA("Decal") then
            MinimapReference.Upper = Upper;
        end;
    end;

    local v310 = MinimapReference.Lower or MinimapReference.Upper;

    if not v310 then
        return;
    end;

    p309.MapImage.Image = v310.Texture;
    p309.MapImage.ImageTransparency = 0;

    if not v310.Texture:match("%d+") then
        return;
    end;

    local TextureSize = MinimapReference.TextureSize;
    local Attribute = workspace:GetAttribute("Map");
    local v311;

    if Attribute then
        v311 = u9[Attribute];
    else
        v311 = nil;
    end;

    local Upper = MinimapReference.Upper;
    local UpperMapImage = p309.UpperMapImage;
    local v312;

    if v311 == nil or Upper == nil then
        v312 = false;
    else
        v312 = UpperMapImage ~= nil;
    end;

    local TrackedPosition = p309:GetTrackedPosition();

    if v312 and (UpperMapImage and Upper) then
        UpperMapImage.Image = Upper.Texture;

        if TrackedPosition then
            local v313;

            if v311 == nil then
                v313 = false;
            else
                v313 = v311 <= TrackedPosition.Y;
            end;

            UpperMapImage.ImageTransparency = v313 and 0 or 1;
        end;
    end;

    local v314 = 90;
    local v315, v316;

    if TrackedPosition then
        local v317 = Part.CFrame:PointToObjectSpace(TrackedPosition);
        local Size = MinimapReference.Size;
        local v318 = -v317.X / Size.X + 0.5;
        local v319 = -v317.Z / Size.Z + 0.5;
        local v320 = TextureSize * math.clamp(p309.Settings.Zoom or 0.7, 0.1, 1) * 0.5;
        local math_clamp_ret = math.clamp(v318 * TextureSize - v320 / 2, 0, TextureSize - v320);
        local math_clamp_ret2 = math.clamp(v319 * TextureSize - v320 / 2, 0, TextureSize - v320);
        v315 = Vector2.new(math.floor(math_clamp_ret + 0.5), (math.floor(math_clamp_ret2 + 0.5)));
        v316 = Vector2.new(v320, v320);

        if not p309.IsSpectating and p309.Settings.Rotation then
            local CurrentCamera = Workspace.CurrentCamera;

            if CurrentCamera then
                local LookVector = CurrentCamera.CFrame.LookVector;
                local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);
                local v321 = Vector3_new_ret.Magnitude < 1e-6 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;

                if Part then
                    v321 = Part.CFrame:VectorToObjectSpace(v321);
                end;

                local math_atan2_ret = math.atan2(-v321.Z, -v321.X);
                v314 = -((math.deg(math_atan2_ret) + 90) % 360) + 90 - 90;
            end;
        end;
    else
        v315 = Vector2.new(0, 0);
        v316 = Vector2.new(TextureSize, TextureSize);
    end;

    p309.MapImage.ImageRectOffset = v315;
    p309.MapImage.ImageRectSize = v316;
    p309.MapImage.Rotation = v314;

    if v312 and UpperMapImage then
        UpperMapImage.ImageRectOffset = v315;
        UpperMapImage.ImageRectSize = v316;
        UpperMapImage.Rotation = v314;
    end;
end;

function u1.ApplySettings(p322) -- Line: 1836
    -- upvalues: Profiler (copy), u2 (copy), u3 (copy), CalculateClampedPosition (copy)
    Profiler.mark("UI.Radar.ApplySettings");
    p322.MapImage.Size = UDim2.fromScale(1, 1);

    if p322.UpperMapImage then
        p322.UpperMapImage.Size = UDim2.fromScale(1, 1);
    end;

    local v323 = p322.Settings.Scale or 1;

    if u2 then
        v323 = (v323 - 1) * 0.5 + 1;
    end;

    local v324 = u3 * v323;
    p322.Frame.Size = UDim2.fromOffset(v324, v324);
    p322.RadarContainer.Size = UDim2.fromOffset(v324, v324);
    local UDim2_new_ret = UDim2.new(0, 10, 0, 10);
    p322.Frame.Position = CalculateClampedPosition(p322.Frame, v324, UDim2_new_ret);
    p322:UpdateMinimapTexture();
end;

function u1.FlashRadarBorder(u325) -- Line: 1857
    -- upvalues: u14 (ref), Color3_fromRGB_ret4 (copy), GetPreferenceColor (copy)
    if not (u14 and u14.Radar) then
        return;
    end;

    local UIStroke = u14.Radar.UIStroke;

    if not UIStroke then
        return;
    end;

    UIStroke.Color = Color3_fromRGB_ret4;

    if u325.BorderRestoreTask then
        task.cancel(u325.BorderRestoreTask);
        u325.BorderRestoreTask = nil;
    end;

    u325.BorderRestoreTask = task.delay(0.2, function() -- Line: 1878
        -- upvalues: u14 (ref), GetPreferenceColor (ref), u325 (copy)
        if u14 and (u14.Radar and u14.Radar.UIStroke) then
            u14.Radar.UIStroke.Color = GetPreferenceColor();
        end;

        u325.BorderRestoreTask = nil;
    end);
end;

function u1.ShowWeaponCircle(u326) -- Line: 1886
    -- upvalues: CreateRadarCircle (copy), u3 (copy), u2 (copy)
    local WeaponCircle = u326.WeaponCircle;

    if not WeaponCircle then
        WeaponCircle = CreateRadarCircle(u326, "WeaponCircle", true);
        u326.WeaponCircle = WeaponCircle;
    end;

    local u327 = WeaponCircle:FindFirstChildOfClass("UIStroke");

    if not u327 then
        return;
    end;

    local v328 = u326.Settings.Scale or 1;

    if u2 then
        v328 = (v328 - 1) * 0.5 + 1;
    end;

    local v329 = u3 / 2 * v328 * 2;
    WeaponCircle.Size = UDim2.fromOffset(v329, v329);
    u327.Thickness = 2;
    u327.Transparency = 0;
    WeaponCircle.Visible = true;

    if u326.WeaponCircleHideTask then
        task.cancel(u326.WeaponCircleHideTask);
        u326.WeaponCircleHideTask = nil;
    end;

    u326.WeaponCircleHideTask = task.delay(0.2, function() -- Line: 1913
        -- upvalues: u327 (copy), WeaponCircle (ref), u326 (copy)
        u327.Transparency = 1;
        WeaponCircle.Visible = false;
        u326.WeaponCircleHideTask = nil;
    end);
end;

function u1.ShowKnifeCircle(p330) -- Line: 1920
    -- upvalues: CreateRadarCircle (copy), u7 (copy), u2 (copy), u3 (copy)
    local KnifeCircle = p330.KnifeCircle;

    if not KnifeCircle then
        KnifeCircle = CreateRadarCircle(p330, "KnifeCircle", true);
        p330.KnifeCircle = KnifeCircle;
    end;

    local u331 = KnifeCircle:FindFirstChildOfClass("UIStroke");

    if not u331 then
        return;
    end;

    local Settings = p330.Settings;
    local math_clamp_ret = math.clamp(Settings.Zoom or 0.5, 0.1, 1);
    local v332 = Settings.Scale or 1;

    if u2 then
        v332 = (v332 - 1) * 0.5 + 1;
    end;

    local v333 = u3 / 2 * v332;
    local math_min_ret = math.min(u7 * (0.5 / math_clamp_ret) * v332, v333);
    local v334 = math_min_ret * 2;
    KnifeCircle.Size = UDim2.fromOffset(v334, v334);
    local v335 = math_min_ret == v333;
    u331.Thickness = v335 and 2 or 1;
    u331.Transparency = v335 and 0 or 0.5;
    KnifeCircle.Visible = true;
    task.delay(0.2, function() -- Line: 1943
        -- upvalues: u331 (copy), KnifeCircle (ref)
        u331.Transparency = 1;
        KnifeCircle.Visible = false;
    end);
end;

local function CancelRunningCircleDelay(p336) -- Line: 1949
    if p336.RunningCircleDelayTask then
        task.cancel(p336.RunningCircleDelayTask);
        p336.RunningCircleDelayTask = nil;
    end;
end;

function u1.UpdateRunningCircle(u337) -- Line: 1956
    -- upvalues: CharacterResolver (copy), CharacterController (copy), CreateRadarCircle (copy), u6 (copy), u2 (copy), u3 (copy)
    if not (u337.Character and u337.Character.PrimaryPart) then
        return;
    end;

    if not CharacterResolver.isAliveCharacter(u337.Character) then
        return;
    end;

    local CurrentCharacter = CharacterController.getCurrentCharacter();
    local v338;

    if CurrentCharacter then
        local GlobalDirection = CurrentCharacter.GlobalDirection;
        local GlobalVelocity = CurrentCharacter.GlobalVelocity;

        if GlobalDirection and GlobalVelocity then
            local Magnitude = Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z).Magnitude;
            v338 = GlobalDirection.Magnitude > 0.1 and true or Magnitude > 0.1;
        else
            v338 = false;
        end;
    else
        v338 = false;
    end;

    local v339 = CharacterController.GetWalkState() or false;

    if v338 then
        v338 = not v339;
    end;

    local v340 = CurrentCharacter and CurrentCharacter.IsJumping or false;
    local v341 = v338 or v340;
    local RunningCircle = u337.RunningCircle;

    if not RunningCircle then
        RunningCircle = CreateRadarCircle(u337, "RunningCircle", false);
        u337.RunningCircle = RunningCircle;
    end;

    local v342 = RunningCircle:FindFirstChildOfClass("UIStroke");

    if not v342 then
        return;
    end;

    local Settings = u337.Settings;
    local math_clamp_ret = math.clamp(Settings.Zoom or 0.5, 0.1, 1);
    local v343 = Settings.Scale or 1;

    if u2 then
        v343 = (v343 - 1) * 0.5 + 1;
    end;

    local v344 = u3 / 2 * v343;
    local math_min_ret = math.min(u6 * (0.5 / math_clamp_ret) * v343, v344);
    local v345 = math_min_ret * 2;
    RunningCircle.Size = UDim2.fromOffset(v345, v345);
    local v346 = math_min_ret == v344;
    v342.Thickness = v346 and 2 or 1;

    if v341 then
        v342.Transparency = v346 and 0 or 0.5;

        if v340 then
            if u337.RunningCircleDelayTask then
                task.cancel(u337.RunningCircleDelayTask);
                u337.RunningCircleDelayTask = nil;
            end;

            RunningCircle.Visible = true;
        elseif v338 then
            if u337.WasRunning then
                if not u337.RunningCircleDelayTask then
                    RunningCircle.Visible = true;
                end;
            else
                if u337.RunningCircleDelayTask then
                    task.cancel(u337.RunningCircleDelayTask);
                    u337.RunningCircleDelayTask = nil;
                end;

                RunningCircle.Visible = false;
                v342.Transparency = 1;
                u337.RunningCircleDelayTask = task.delay(0.4, function() -- Line: 2006
                    -- upvalues: u337 (copy), CharacterController (ref), u6 (ref), u2 (ref), u3 (ref)
                    if not (u337.Character and u337.Character.PrimaryPart) then
                        u337.RunningCircleDelayTask = nil;

                        return;
                    end;

                    local CurrentCharacter2 = CharacterController.getCurrentCharacter();
                    local v347;

                    if CurrentCharacter2 then
                        local GlobalDirection = CurrentCharacter2.GlobalDirection;
                        local GlobalVelocity = CurrentCharacter2.GlobalVelocity;

                        if GlobalDirection and GlobalVelocity then
                            local Magnitude = Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z).Magnitude;
                            v347 = GlobalDirection.Magnitude > 0.1 and true or Magnitude > 0.1;
                        else
                            v347 = false;
                        end;
                    else
                        v347 = false;
                    end;

                    local v348 = CharacterController.GetWalkState() or false;

                    if v347 then
                        v347 = not v348;
                    end;

                    if v347 and u337.RunningCircle then
                        local RunningCircle2 = u337.RunningCircle;
                        local v349 = RunningCircle2:FindFirstChildOfClass("UIStroke");

                        if v349 then
                            local Settings2 = u337.Settings;
                            local math_clamp_ret2 = math.clamp(Settings2.Zoom or 0.5, 0.1, 1);
                            local v350 = Settings2.Scale or 1;

                            if u2 then
                                v350 = (v350 - 1) * 0.5 + 1;
                            end;

                            local v351 = u3 / 2 * v350;
                            v349.Transparency = math.min(u6 * (0.5 / math_clamp_ret2) * v350, v351) == v351 and 0 or 0.5;
                            RunningCircle2.Visible = true;
                        end;
                    end;

                    u337.RunningCircleDelayTask = nil;
                end);
            end;
        end;
    else
        if u337.RunningCircleDelayTask then
            task.cancel(u337.RunningCircleDelayTask);
            u337.RunningCircleDelayTask = nil;
        end;

        RunningCircle.Visible = false;
        v342.Transparency = 1;
    end;

    u337.WasRunning = v341;
end;

function u1.CreateDeadIconForPlayer(p352: any, p353: userdata, p354: vector) -- Line: 2044
    -- upvalues: Participants (copy), Workspace (copy), Color3_fromRGB_ret3 (copy), getRadarCharacter (copy), Colors (copy), CreateDeadIcon (copy), ProjectToRadar (copy)
    p352:RemoveIcon(Participants.Key(p353) .. "_Player");
    local v355 = Participants.Key(p353) .. "_Dead";

    if p352.Icons[v355] or p352.FadedDeadIcons[v355] then
        return;
    end;

    local Attribute = p353:GetAttribute("Team");
    local v356;

    if Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Workspace:GetAttribute("ServerGamemode") == "Deathmatch" or Attribute ~= p352.Team then
        v356 = Color3_fromRGB_ret3;
    elseif Attribute then
        local v357 = getRadarCharacter(p353);

        if v357 then
            v357 = v357:GetAttribute("CompetitivePlayerColor");
        end;

        v356 = v357 or Colors["Team Color"][Attribute];
    else
        v356 = nil;
    end;

    local v358 = CreateDeadIcon(p352, p353, v355, v356);

    if p354 and p352.MinimapReference then
        local v359, v360 = ProjectToRadar(p352, p352.MinimapReference, p354);
        local v361 = v359 - 0.5;
        local v362 = v360 - 0.5;
        local math_sqrt_ret = math.sqrt(v361 * v361 + v362 * v362);

        if math_sqrt_ret > 0.5 then
            v359 = v361 / math_sqrt_ret * 0.5 + 0.5;
            v360 = v362 / math_sqrt_ret * 0.5 + 0.5;
        end;

        v358.Position = UDim2.fromScale(v359, v360);
        v358.Visible = true;
    end;
end;

function u1.Render(p363: any, p364: number) -- Line: 2066
    -- upvalues: Profiler (copy)
    Profiler.mark("UI.Radar.Render");
    p363.EnemyVisibilityChecksRemaining = 2;
    p363:UpdateMinimapTexture();
    p363:UpdatePlayerIcons();
    p363:UpdateBombIcon();
    p363:UpdateSiteIcons();
    p363:UpdateHostageIcons();
    p363:UpdateRunningCircle();
end;

local function DestroyUpperMapImages(p365) -- Line: 2079
    if p365.UpperMapImage then
        p365.UpperMapImage:Destroy();
        p365.UpperMapImage = nil;
    end;

    for _, child in ipairs(p365.RadarContainer:GetChildren()) do
        if child.Name == "UpperMap" and child:IsA("ImageLabel") then
            child:Destroy();
        end;
    end;
end;

local function CreateUpperMapImage(p366) -- Line: 2092
    -- upvalues: u9 (copy)
    local Attribute = workspace:GetAttribute("Map");
    local v367;

    if Attribute then
        v367 = u9[Attribute];
    else
        v367 = nil;
    end;

    if v367 == nil or not (p366.MinimapReference and p366.MinimapReference.Upper) then
        return nil;
    end;

    local v368 = p366.MapImage:Clone();
    v368.Name = "UpperMap";
    v368.ZIndex = 2;
    v368.Parent = p366.RadarContainer;

    return v368;
end;

function u1.new(p369: any, p370: userdata?) -- Line: 2108
    -- upvalues: Profiler (copy), u1 (copy), Janitor (copy), LocalPlayer (copy), GetMinimapReference (copy), CreateUpperMapImage (copy), IsTutorialMode (copy), u16 (copy), GetSiteParts (copy), Router (copy), RunServiceController (copy), CharacterResolver (copy), Players (copy), Participants (copy), Remotes (copy), DestroyUpperMapImages (copy)
    Profiler.mark("UI.Radar.New");
    local u371 = setmetatable({}, u1);
    u371.Janitor = Janitor.new();
    u371.Frame = p369;
    u371.RadarContainer = p369.Radar;
    u371.MapImage = p369.Radar.Map;
    u371.MapImage.AnchorPoint = Vector2.new(0.5, 0.5);
    u371.MapImage.Position = UDim2.fromScale(0.5, 0.5);
    u371.MapImage.ZIndex = 1;
    u371.LocalPlayer = LocalPlayer;
    u371.Character = p370;
    u371.Team = LocalPlayer:GetAttribute("Team");
    u371.MinimapReference = GetMinimapReference();
    u371.UpperMapImage = CreateUpperMapImage(u371);

    if u371.UpperMapImage then
        u371.UpperMapImage.BackgroundTransparency = 1;
    end;

    u371.Frame.Visible = not IsTutorialMode();
    u371.Janitor:Add(function() -- Line: 2141
        -- upvalues: u371 (copy), IsTutorialMode (ref)
        u371.Frame.Visible = not IsTutorialMode();
    end);
    u371.Settings = u16;
    u371.IsSpectating = false;
    u371.Icons = {};
    u371.SiteParts = GetSiteParts();
    u371.DeadPlayerPositions = {};
    u371.FadedDeadIcons = {};
    u371.EnemyVisibilityState = {};
    u371.EnemyLastSeenPositions = {};
    u371.EnemyVisibilityCache = {};
    u371.EnemyVisibilityChecksRemaining = 0;
    u371.HostageVisibilityCache = {};
    u371.WasRunning = false;
    u371.BombIsVisible = false;
    u371:ApplySettings();
    local broadcastRouter = Router.broadcastRouter;

    function Router.broadcastRouter(p372: string, ...) -- Line: 2173
        -- upvalues: broadcastRouter (copy), u371 (copy)
        local v373 = broadcastRouter(p372, ...);

        if p372 == "UpdatePlayerNoiseCone" then
            local v374, v375 = ...;

            if v375 and (u371.Character and (u371.Character.PrimaryPart and (v375 - u371.Character.PrimaryPart.Position).Magnitude < 5)) then
                if v374 == "Melee" then
                    u371:ShowKnifeCircle();

                    return v373;
                end;

                if v374 == "Weapon" then
                    u371:ShowWeaponCircle();
                    u371:FlashRadarBorder();
                end;
            end;
        end;

        return v373;
    end;

    u371.Janitor:Add(function() -- Line: 2194
        -- upvalues: Router (ref), broadcastRouter (copy)
        Router.broadcastRouter = broadcastRouter;
    end);
    local u376 = 0;
    u371.Janitor:Add(RunServiceController.BindToRenderStep("UI.Radar.Update", function(p377: number) -- Line: 2200
        -- upvalues: Profiler (ref), u376 (ref), u371 (copy)
        Profiler.mark("UI.Radar.RenderStepped");
        u376 = u376 + p377;

        if u376 >= 0.016666666666666666 then
            u371:Render(p377);
            u376 = math.min(u376 - 0.016666666666666666, 0.008333333333333333);
        end;
    end));
    u371.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 2211
        -- upvalues: u371 (copy)
        u371:RefreshIconsOnTeamChange();
    end));

    local function setupPlayerListeners(u378: userdata) -- Line: 2216
        -- upvalues: u371 (copy), CharacterResolver (ref)
        if u378 == u371.LocalPlayer then
            return;
        end;

        u371.Janitor:Add(u378:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 2221
            -- upvalues: u371 (ref), u378 (copy)
            u371:RefreshPlayerIcon(u378);
        end));
        u371.Janitor:Add(CharacterResolver.observeCharacter(u378, function(p379, p380) -- Line: 2225
            -- upvalues: u371 (ref), u378 (copy)
            if p379 ~= p380 then
                u371:RefreshPlayerIcon(u378);
            end;

            return nil;
        end));
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        setupPlayerListeners(v);
    end;

    u371.Janitor:Add(Players.PlayerAdded:Connect(setupPlayerListeners));
    u371.Janitor:Add(Players.PlayerRemoving:Connect(function(p381: userdata) -- Line: 2240
        -- upvalues: u371 (copy)
        for i, v in pairs(u371.Icons) do
            if v.Player == p381 then
                u371:RemoveIcon(i);
            end;
        end;

        u371.DeadPlayerPositions[p381.UserId] = nil;
        u371.FadedDeadIcons[p381.UserId .. "_Dead"] = nil;
        u371.EnemyVisibilityCache[p381.UserId .. "_Player"] = nil;
    end));
    local u382 = {};
    u371.Janitor:Add(Participants.Observe(function(u383: userdata) -- Line: 2253
        -- upvalues: u382 (copy), u371 (copy)
        if u383:IsA("Player") or u382[u383] then
            return;
        end;

        local function refresh() -- Line: 2257
            -- upvalues: u371 (ref), u383 (copy)
            u371:RefreshPlayerIcon(u383);
        end;

        u382[u383] = { u383:GetAttributeChangedSignal("Team"):Connect(refresh), u383:GetAttributeChangedSignal("Generation"):Connect(refresh) };
    end, function(p384: userdata) -- Line: 2265
        -- upvalues: u382 (copy), u371 (copy)
        if p384:IsA("Player") then
            return;
        end;

        local v385 = u382[p384];

        if v385 then
            for _, v in v385 do
                v:Disconnect();
            end;

            u382[p384] = nil;
        end;

        for i, v in pairs(u371.Icons) do
            if v.Player == p384 then
                u371:RemoveIcon(i);
            end;
        end;

        u371:RefreshPlayerIcon(p384);
    end));
    u371.Janitor:Add(function() -- Line: 2283
        -- upvalues: u382 (copy)
        for _, v in u382 do
            for _, v2 in v do
                v2:Disconnect();
            end;
        end;

        table.clear(u382);
    end);
    u371.Janitor:Add(Remotes.UI.UIPlayerKilled.Listen(function(p386) -- Line: 2293
        -- upvalues: Participants (ref), LocalPlayer (ref), u371 (copy)
        local v387 = Participants.FromKey(p386.Victim);

        if not v387 or v387 == LocalPlayer then
            return;
        end;

        local DeathPosition = p386.DeathPosition;

        if not DeathPosition then
            return;
        end;

        u371.DeadPlayerPositions[Participants.Key(v387)] = DeathPosition;
        u371:CreateDeadIconForPlayer(v387, DeathPosition);
    end));
    u371.Janitor:Add(workspace:GetAttributeChangedSignal("Map"):Connect(function() -- Line: 2310
        -- upvalues: u371 (copy), GetMinimapReference (ref), GetSiteParts (ref), DestroyUpperMapImages (ref), CreateUpperMapImage (ref)
        u371.MinimapReference = GetMinimapReference();
        u371.SiteParts = GetSiteParts();
        DestroyUpperMapImages(u371);
        u371.MapImage.Image = "";
        u371.MapImage.ImageTransparency = 0;
        u371.MapImage.ImageRectOffset = Vector2.new(0, 0);
        u371.MapImage.ImageRectSize = Vector2.new(1024, 1024);
        u371.MapImage.Rotation = 0;
        u371.MapImage.Visible = true;
        u371.MapImage.Size = UDim2.fromScale(1, 1);
        u371.UpperMapImage = CreateUpperMapImage(u371);
        u371:UpdateMinimapTexture();

        for i in pairs(u371.Icons) do
            u371:RemoveIcon(i);
        end;

        table.clear(u371.EnemyVisibilityState);
        table.clear(u371.EnemyLastSeenPositions);
        table.clear(u371.EnemyVisibilityCache);
        table.clear(u371.HostageVisibilityCache);
        u371.BombVisibilityCache = nil;
        table.clear(u371.DeadPlayerPositions);
        table.clear(u371.FadedDeadIcons);
    end));
    u371.Janitor:Add(function() -- Line: 2342
        -- upvalues: u371 (copy), DestroyUpperMapImages (ref)
        for _, v in pairs(u371.Icons) do
            if v.Instance and v.Instance.Parent then
                v.Instance:Destroy();
            end;
        end;

        table.clear(u371.Icons);
        table.clear(u371.EnemyVisibilityState);
        table.clear(u371.EnemyLastSeenPositions);
        DestroyUpperMapImages(u371);
        local v388 = u371;

        if v388.RunningCircleDelayTask then
            task.cancel(v388.RunningCircleDelayTask);
            v388.RunningCircleDelayTask = nil;
        end;

        if u371.RunningCircle then
            u371.RunningCircle:Destroy();
            u371.RunningCircle = nil;
        end;

        if u371.KnifeCircle then
            u371.KnifeCircle:Destroy();
            u371.KnifeCircle = nil;
        end;

        if u371.WeaponCircleHideTask then
            task.cancel(u371.WeaponCircleHideTask);
            u371.WeaponCircleHideTask = nil;
        end;

        if u371.WeaponCircle then
            u371.WeaponCircle:Destroy();
            u371.WeaponCircle = nil;
        end;

        local v389 = u371;

        if v389.BorderRestoreTask then
            task.cancel(v389.BorderRestoreTask);
            v389.BorderRestoreTask = nil;
        end;
    end);

    return u371;
end;

function u1.Destroy(p390) -- Line: 2385
    p390.Janitor:Destroy();
end;

function u1.Initialize(p391, p392) -- Line: 2392
    -- upvalues: Profiler (copy), u14 (ref), IsTutorialMode (copy), u15 (copy), DataController (copy), LocalPlayer (copy), u16 (copy), u17 (ref), GetPreferenceColor (copy), CharacterResolver (copy), Color3_fromRGB_ret4 (copy)
    Profiler.mark("UI.Radar.Initialize");
    u14 = p392;

    local function syncTutorialVisibility() -- Line: 2403
        -- upvalues: IsTutorialMode (ref), u14 (ref)
        if IsTutorialMode() then
            u14.Visible = false;
        end;
    end;

    if IsTutorialMode() then
        u14.Visible = false;
    end;

    workspace:GetAttributeChangedSignal("Gamemode"):Connect(syncTutorialVisibility);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(syncTutorialVisibility);

    for _, v in u15 do
        DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet." .. v[1], function(p393) -- Line: 2415
            -- upvalues: u16 (ref), v (copy), u17 (ref)
            u16[v[2]] = p393;

            if u17 then
                u17:ApplySettings();
            end;
        end);
    end;

    u14.Radar.UIStroke.Color = GetPreferenceColor();
    CharacterResolver.observeCharacter(LocalPlayer, function() -- Line: 2427
        -- upvalues: u14 (ref), GetPreferenceColor (ref)
        u14.Radar.UIStroke.Color = GetPreferenceColor();

        return nil;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 2433
        -- upvalues: u14 (ref), u17 (ref), Color3_fromRGB_ret4 (ref), GetPreferenceColor (ref)
        if u14 and (u14.Radar and u14.Radar.UIStroke) then
            local UIStroke = u14.Radar.UIStroke;
            local v394;

            if u17 == nil then
                v394 = false;
            else
                v394 = u17.BorderRestoreTask ~= nil;
            end;

            if not v394 or UIStroke.Color ~= Color3_fromRGB_ret4 then
                UIStroke.Color = GetPreferenceColor();
            end;
        end;
    end);
end;

local function observeBotCharacter(u395: userdata, u396: function) -- Line: 2446
    -- upvalues: getRadarCharacter (copy)
    local u397 = getRadarCharacter(u395);
    u396(u397);

    local function v399() -- Line: 2449
        -- upvalues: getRadarCharacter (ref), u395 (copy), u397 (ref), u396 (copy)
        local v398 = getRadarCharacter(u395);

        if v398 ~= u397 then
            u397 = v398;
            u396(v398);
        end;
    end;

    local u400 = { u395:GetAttributeChangedSignal("Generation"):Connect(v399) };
    local Characters = workspace:FindFirstChild("Characters");

    if Characters then
        table.insert(u400, Characters.ChildAdded:Connect(v399));
        table.insert(u400, Characters.ChildRemoved:Connect(v399));
    end;

    return function() -- Line: 2462
        -- upvalues: u400 (copy)
        for _, v in u400 do
            v:Disconnect();
        end;
    end;
end;

local function observeRadarTarget(u401: userdata, u402: boolean) -- Line: 2469
    -- upvalues: u18 (ref), createRadarInstance (copy), SpectateController (copy), LocalPlayer (copy), Profiler (copy), u17 (ref), u1 (copy), u14 (ref), CharacterResolver (copy), observeBotCharacter (copy)
    if u18 then
        u18();
        u18 = nil;
    end;

    local function onCharacter(p403: userdata?) -- Line: 2475
        -- upvalues: createRadarInstance (ref), u401 (copy), u402 (copy), SpectateController (ref), LocalPlayer (ref), Profiler (ref), u17 (ref), u1 (ref), u14 (ref)
        if p403 and p403:IsDescendantOf(workspace) then
            createRadarInstance(p403, u401, u402);

            return;
        end;

        if SpectateController.IsFreecamActive() then
            local v404 = LocalPlayer;
            Profiler.mark("UI.Radar.CreateRadarForCharacter");

            if u17 then
                u17:Destroy();
                u17 = nil;
            end;

            local v405 = u1.new(u14, nil);
            u17 = v405;
            v405.LocalPlayer = v404;
            v405.Team = v404:GetAttribute("Team");
            v405.IsSpectating = true;
            v405.MapImage.Rotation = 90;

            if v405.UpperMapImage then
                v405.UpperMapImage.Rotation = 90;
            end;
        elseif u17 and u17.LocalPlayer == u401 then
            u17:Destroy();
            u17 = nil;
        end;
    end;

    if u401:IsA("Player") then
        u18 = CharacterResolver.observeCharacter(u401, function(u406: userdata?) -- Line: 2488
            -- upvalues: onCharacter (copy)
            onCharacter(u406);

            if not u406 then
                return nil;
            end;

            local u407 = u406:IsDescendantOf(workspace);
            local u409 = u406.AncestryChanged:Connect(function() -- Line: 2497
                -- upvalues: u406 (copy), u407 (ref), onCharacter (ref)
                local v408 = u406:IsDescendantOf(workspace);

                if v408 ~= u407 then
                    u407 = v408;
                    onCharacter(u406);
                end;
            end);

            return function() -- Line: 2504
                -- upvalues: u409 (copy)
                u409:Disconnect();
            end;
        end);

        return;
    end;

    u18 = observeBotCharacter(u401, onCharacter);
end;

function u1.Start() -- Line: 2513
    -- upvalues: observeRadarTarget (copy), LocalPlayer (copy), SpectateController (copy), u17 (ref), Profiler (copy), u1 (copy), u14 (ref)
    observeRadarTarget(LocalPlayer, false);
    SpectateController.ListenToSpectate:Connect(function(p410: userdata?) -- Line: 2517
        -- upvalues: observeRadarTarget (ref), LocalPlayer (ref)
        if p410 then
            observeRadarTarget(p410, true);

            return;
        end;

        observeRadarTarget(LocalPlayer, false);
    end);
    SpectateController.ListenToFreecam:Connect(function() -- Line: 2526
        -- upvalues: u17 (ref), LocalPlayer (ref), Profiler (ref), u1 (ref), u14 (ref)
        if not u17 then
            local v411 = LocalPlayer;
            Profiler.mark("UI.Radar.CreateRadarForCharacter");

            if u17 then
                u17:Destroy();
                u17 = nil;
            end;

            local v412 = u1.new(u14, nil);
            u17 = v412;
            v412.LocalPlayer = v411;
            v412.Team = v411:GetAttribute("Team");
            v412.IsSpectating = true;
            v412.MapImage.Rotation = 90;

            if v412.UpperMapImage then
                v412.UpperMapImage.Rotation = 90;
            end;
        end;
    end);
end;

return u1;