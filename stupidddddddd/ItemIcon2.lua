-- ReplicatedStorage.Interface.Screens.Menu.Loadout.ItemIcon
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Loadout.ItemIcon
-- Decompile time: 1.33 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
require(script.Parent:WaitForChild("Types"))
local WeaponDropShadows = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.WeaponDropShadows)
local u36 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u42 = UDim2.new(0, 0, -0.05, 0)

local function NormalizeAssetId(a1) -- Line: 23 -- types: a1: string?
    if typeof(a1) == "string" and a1 ~= "" then
        return a1:gsub("^rbxassetid://", "")
    end
    return nil
end

function v1.PreloadDropShadows() -- Line: 85 -- upvalues: WeaponDropShadows (val), ContentProvider (val)
    local v1 = {}
    for k, v in pairs(WeaponDropShadows) do
        table.insert(v1, v)
    end
    ContentProvider:PreloadAsync(v1)
end

function v1.GetDropShadowImageForItem(a1, a2) -- Line: 31 -- upvalues: WeaponDropShadows (val) -- types: a2: string?
    local v1 = if typeof(a2) ~= "string" then nil else if a2 ~= "" then a2:gsub("^rbxassetid://", "") else nil
    return WeaponDropShadows[a1.Name] or WeaponDropShadows[a1.Skin] or a2 and WeaponDropShadows[a2] or v1 and WeaponDropShadows[v1]
end

function v1.CreateIconDropShadow(a1, a2, a3) -- Line: 41 -- types: a1: userdata, a2: string?, a3: userdata
    if not a2 then
        return nil
    end
    local v1 = a1:Clone()
    v1.Name = "DropShadow"
    v1.Image = a2
    v1.ImageTransparency = 1
    v1.ZIndex = a1.ZIndex - 1
    v1.Parent = a3
    return v1
end

function v1.CreateIconHoverTweens(a1, a2) -- Line: 56
    -- upvalues: u42 (val), TweenService (val), u36 (val)
    local Position = a1.Position
    return function() -- Line: 59 -- upvalues: Position (val), u42 (upval), TweenService (upval), a1 (val), u36 (upval), a2 (val)
        local v1 = UDim2.new(
            Position.X.Scale + u42.X.Scale,
            Position.X.Offset + u42.X.Offset,
            Position.Y.Scale + u42.Y.Scale,
            Position.Y.Offset + u42.Y.Offset
        )
        TweenService:Create(a1, u36, {Position = v1}):Play()
        if a2 then
            TweenService:Create(a2, u36, {ImageTransparency = 0.3}):Play()
        end
    end, function() -- Line: 72 -- upvalues: TweenService (upval), a1 (val), u36 (upval), Position (val), a2 (val)
        TweenService:Create(a1, u36, {Position = Position}):Play()
        if a2 then
            TweenService:Create(a2, u36, {ImageTransparency = 1}):Play()
        end
    end
end

return v1