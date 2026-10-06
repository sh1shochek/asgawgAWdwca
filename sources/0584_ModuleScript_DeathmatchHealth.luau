-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Sound = require(ReplicatedStorage.Classes.Sound);
local Router = require(ReplicatedStorage.Database.Security.Router);
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = nil;
local u3 = nil;
local u4 = 0;
local u5 = 0;

local function animateCross(p6: number) -- Line: 47
    -- upvalues: u3 (ref), u2 (ref), TweenService (copy)
    local u7 = u3:Clone();
    local u8 = 0.6 + math.random() * 0.4;
    local Size = u3.Size;

    local function scaledSize(p9: number) -- Line: 53
        -- upvalues: Size (copy)
        return UDim2.fromScale(Size.X.Scale * p9, Size.Y.Scale * p9);
    end;

    local v10 = math.random() < 0.5 and -1 or 1;
    local v11 = math.random() ^ 0.5 * 0.44;
    local v12 = 0.5 + v10 * v11;
    local v13 = (math.random() - 0.5) * 2 * 0.04;
    local v14 = (math.clamp((v11 - 0.15) / 0.29000000000000004, 0, 1) * 0.3 + 0.3) * (0.9 + math.random() * 0.2);
    local u15 = {
        {
            Label = u7,
            Authored = u3.ImageTransparency
        }
    };

    for _, descendant in u7:GetDescendants() do
        if descendant:IsA("ImageLabel") then
            table.insert(u15, {
                Label = descendant,
                Authored = descendant.ImageTransparency
            });
        end;
    end;

    u7.Name = "Cross";
    u7.Visible = true;
    u7.AnchorPoint = Vector2.new(0.5, 0.5);
    u7.Size = UDim2.fromScale(0, 0);
    u7.Position = UDim2.fromScale(v12, 1.04);
    u7.Rotation = (math.random() - 0.5) * 24;

    for _, v in u15 do
        v.Label.ImageTransparency = 1;
    end;

    u7.Parent = u2;
    local TweenInfo_new_ret = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
    local v16 = {};
    local v17 = u8 * 1.25;
    v16.Size = UDim2.fromScale(Size.X.Scale * v17, Size.Y.Scale * v17);
    TweenService:Create(u7, TweenInfo_new_ret, v16):Play();

    for _, v in u15 do
        TweenService:Create(v.Label, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = v.Authored
        }):Play();
    end;

    task.delay(0.12, function() -- Line: 104
        -- upvalues: TweenService (ref), u7 (copy), u8 (copy), Size (copy)
        local TweenInfo_new_ret2 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v18 = {};
        local v19 = u8;
        v18.Size = UDim2.fromScale(Size.X.Scale * v19, Size.Y.Scale * v19);
        TweenService:Create(u7, TweenInfo_new_ret2, v18):Play();
    end);
    TweenService:Create(u7, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(v12 + v13, 1.04 - v14),
        Rotation = u7.Rotation + (math.random() - 0.5) * 30
    }):Play();
    task.delay(0.54, function() -- Line: 118
        -- upvalues: TweenService (ref), u7 (copy), u8 (copy), Size (copy), u15 (copy)
        local TweenInfo_new_ret2 = TweenInfo.new(0.66, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        local v20 = {};
        local v21 = u8 * 0.6;
        v20.Size = UDim2.fromScale(Size.X.Scale * v21, Size.Y.Scale * v21);
        TweenService:Create(u7, TweenInfo_new_ret2, v20):Play();

        for _, v in u15 do
            TweenService:Create(v.Label, TweenInfo.new(0.66, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1
            }):Play();
        end;
    end);
    task.delay(1.3, function() -- Line: 129
        -- upvalues: u7 (copy)
        u7:Destroy();
    end);
end;

local function ExecuteHPClaimBonus() -- Line: 134
    -- upvalues: u5 (ref), u2 (ref), TweenService (copy), u4 (ref), Sound (copy), workspace_CurrentCamera (copy), animateCross (copy)
    u5 = u5 + 1;
    local u22 = u5;

    if not u2.Visible then
        u2.BackgroundTransparency = 1;
        u2.Visible = true;
    end;

    TweenService:Create(u2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = u4
    }):Play();
    Sound.new("Deathmatch"):playOneTime({
        Name = "Deathmatch HP Bonus",
        Parent = workspace_CurrentCamera
    });

    for i = 1, 10 do
        task.delay((i - 1) * 0.05, animateCross, i);
        local _ = i;
    end;

    task.delay(0.99, function() -- Line: 165
        -- upvalues: u5 (ref), u22 (copy), TweenService (ref), u2 (ref)
        if u5 ~= u22 then
            return;
        end;

        local v23 = TweenService:Create(u2, TweenInfo.new(0.66, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        });
        v23.Completed:Once(function() -- Line: 171
            -- upvalues: u5 (ref), u22 (ref), u2 (ref)
            if u5 == u22 then
                u2.Visible = false;
            end;
        end);
        v23:Play();
    end);
end;

function v1.Initialize(p24, p25) -- Line: 183
    -- upvalues: u3 (ref), u2 (ref), u4 (ref)
    u3 = p25:WaitForChild("Template");
    u3.Visible = false;
    u2 = p25;
    u4 = p25.BackgroundTransparency;
    u2.BackgroundTransparency = 1;
    u2.Visible = false;
end;

function v1.Start() -- Line: 193
    -- upvalues: Router (copy), ExecuteHPClaimBonus (copy)
    Router.observerRouter("DeathmatchHealthClaimed", ExecuteHPClaimBonus);
end;

return v1;