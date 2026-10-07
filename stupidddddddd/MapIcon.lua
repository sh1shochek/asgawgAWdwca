-- ReplicatedStorage.Interface.Screens.Menu.Career.MapIcon
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.MapIcon
-- Decompile time: 0.86 ms

local Maps = game:GetService("ReplicatedStorage").Database.Custom.GameStats.Maps
local u9 = {}
local u15 = Rect.new(0, 0, 0, 0)
local u60 = table.freeze({
    ["rbxassetid://72973444783842"] = Rect.new(280, 308, 756, 720),
    ["rbxassetid://96627370550320"] = Rect.new(296, 296, 688, 712),
    ["rbxassetid://88605850938693"] = Rect.new(252, 236, 748, 764),
    ["rbxassetid://139602408955630"] = Rect.new(260, 364, 760, 648),
    ["rbxassetid://118014135553992"] = Rect.new(240, 304, 784, 772),
    ["rbxassetid://95578841758233"] = Rect.new(268, 252, 756, 772),
    ["rbxassetid://78468254134558"] = Rect.new(276, 320, 716, 728),
})
local u61 = {}

local function Read(a1, a2) -- Line: 29 -- upvalues: u61 (val), Maps (val) -- types: a1: string, a2: string
    if a1 == "" then
        return ""
    end
    local v1 = u61[a1]
    if not v1 then
        u61[a1] = {}
    end
    local v2 = v1[a2]
    if v2 then
        return v2
    end
    local v3 = Maps:FindFirstChild(a1)
    local v4 = ""
    if v3 and v3:IsA("ModuleScript") then
        local success, result = pcall(require, v3)
        if success and typeof(result) == "table" then
            v4 = tostring(result[a2] or "")
        end
    end
    if v4 ~= "" then
        v1[a2] = v4
    end
    return v4
end

function u9.Get(a1) -- Line: 65 -- upvalues: Read (val) -- types: a1: string
    return (Read(a1, "Icon"))
end

function u9.GetRadar(a1) -- Line: 72 -- upvalues: Read (val), u9 (val), u15 (val), u60 (val) -- types: a1: string
    local v1 = Read(a1, "Radar")
    if v1 == "" then
        return (u9.Get(a1)), u15
    end
    local v2 = u60[v1] or u15
    return v1, v2
end

return u9