-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
require(script.Parent:WaitForChild("Types"));
local WeaponDropShadows = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.WeaponDropShadows);
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local UDim2_new_ret = UDim2.new(0, 0, -0.05, 0);

local function NormalizeAssetId(p2: string?) -- Line: 23
    if typeof(p2) == "string" and p2 ~= "" then
        return p2:gsub("^rbxassetid://", "");
    end;

    return nil;
end;

function v1.PreloadDropShadows() -- Line: 85
    -- upvalues: WeaponDropShadows (copy), ContentProvider (copy)
    local v3 = {};

    for _, v in pairs(WeaponDropShadows) do
        table.insert(v3, v);
    end;

    ContentProvider:PreloadAsync(v3);
end;

function v1.GetDropShadowImageForItem(p4: any, p5: string?) -- Line: 31
    -- upvalues: WeaponDropShadows (copy)
    local v6;

    if typeof(p5) == "string" and p5 ~= "" then
        v6 = p5:gsub("^rbxassetid://", "");
    else
        v6 = nil;
    end;

    local v7 = WeaponDropShadows[p4.Name] or (WeaponDropShadows[p4.Skin] or p5 and WeaponDropShadows[p5]);

    if v7 then
        v6 = v7;
    elseif v6 then
        v6 = WeaponDropShadows[v6];
    end;

    return v6;
end;

function v1.CreateIconDropShadow(p8: userdata, p9: string?, p10: userdata) -- Line: 41
    if not p9 then
        return nil;
    end;

    local v11 = p8:Clone();
    v11.Name = "DropShadow";
    v11.Image = p9;
    v11.ImageTransparency = 1;
    v11.ZIndex = p8.ZIndex - 1;
    v11.Parent = p10;

    return v11;
end;

function v1.CreateIconHoverTweens(u12: userdata, u13: userdata?) -- Line: 56
    -- upvalues: UDim2_new_ret (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local Position = u12.Position;

    return function() -- Line: 59, Name: playHover
        -- upvalues: Position (copy), UDim2_new_ret (ref), TweenService (ref), u12 (copy), TweenInfo_new_ret (ref), u13 (copy)
        TweenService:Create(u12, TweenInfo_new_ret, {
            Position = UDim2.new(Position.X.Scale + UDim2_new_ret.X.Scale, Position.X.Offset + UDim2_new_ret.X.Offset, Position.Y.Scale + UDim2_new_ret.Y.Scale, Position.Y.Offset + UDim2_new_ret.Y.Offset)
        }):Play();

        if u13 then
            TweenService:Create(u13, TweenInfo_new_ret, {
                ImageTransparency = 0.3
            }):Play();
        end;
    end, function() -- Line: 72, Name: playUnhover
        -- upvalues: TweenService (ref), u12 (copy), TweenInfo_new_ret (ref), Position (copy), u13 (copy)
        TweenService:Create(u12, TweenInfo_new_ret, {
            Position = Position
        }):Play();

        if u13 then
            TweenService:Create(u13, TweenInfo_new_ret, {
                ImageTransparency = 1
            }):Play();
        end;
    end;
end;

return v1;