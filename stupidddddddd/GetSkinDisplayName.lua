-- ReplicatedStorage.Components.Common.GetSkinDisplayName
-- Script path: ReplicatedStorage.Components.Common.GetSkinDisplayName
-- Decompile time: 2.63 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local u11 = {["Zeus x27"] = "Taser"}
local u17 = table.freeze({["Lebron James"] = "LeGoat", ["Medal.tv"] = "Medal"})
local u18 = {}
for i, j in u11 do
    u18[j:lower()] = i
end
local u29 = {}

local function replaceCaseInsensitive(a1, a2, a3) -- Line: 23 -- types: a1: string, a2: string, a3: string
    local v1, v2
    if a2 == "" then
        return a1
    end
    local v3 = a1:lower()
    local v4 = {}
    local v5 = 1
    while true do
        v1, v2 = v3:find(a2, v5, true)
        if not v1 or not v2 then
            break
        end
        table.insert(v4, (a1:sub(v5, v1 - 1)))
        table.insert(v4, a3)
        v5 = v2 + 1
    end
    table.insert(v4, (a1:sub(v5)))
    return table.concat(v4)
end

function u29.GetNameTag(a1) -- Line: 47
    if typeof(a1) == "string" and a1 ~= "" then
        return a1
    end
    return nil
end

local function escapeRichText(a1) -- Line: 54 -- types: a1: string
    return ((a1:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
end

function u29.FormatNameLabelText(a1, a2) -- Line: 58 -- upvalues: u29 (val) -- types: a1: string
    if u29.GetNameTag(a2) then
        return (("<i>%*</i>"):format((((a1:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))))
    end
    return a1
end

function u29.ApplyNameLabel(a1, a2, a3) -- Line: 65 -- upvalues: u29 (val) -- types: a1: userdata?, a2: string
    if not a1 then
        return
    end
    if not a1:IsA("TextLabel") and not a1:IsA("TextButton") and not a1:IsA("TextBox") then
        return
    end
    local v1 = u29.GetNameTag(a3) ~= nil
    if a1:GetAttribute("NameTagRichTextDefault") == nil then
        a1:SetAttribute("NameTagRichTextDefault", a1.RichText)
    end
    if a1:GetAttribute("NameTagFontStyleDefault") == nil then
        a1:SetAttribute("NameTagFontStyleDefault", a1.FontFace.Style.Name)
    end
    local Attribute = a1:GetAttribute("NameTagFontStyleDefault")
    local FontFace_2 = a1.FontFace
    local Normal = if v1 then Enum.FontStyle.Italic else if Attribute ~= "Italic" then Enum.FontStyle.Normal else Enum.FontStyle.Italic
    a1.FontFace = Font.new(FontFace_2.Family, FontFace_2.Weight, Normal)
    a1.RichText = v1 or a1:GetAttribute("NameTagRichTextDefault") == true
    a1.Text = u29.FormatNameLabelText(a2, a3)
end

function u29.GetWeaponDisplayName(a1, a2) -- Line: 86
    -- upvalues: u29 (val), u11 (val), replaceCaseInsensitive (val)
    local v1 = u29.GetNameTag(a2)
    if v1 then
        return v1
    end
    if not a1 then
        return ""
    end
    local v2 = u11[a1]
    if v2 then
        return v2
    end
    local v3 = a1
    for i, j in u11 do
        v3 = replaceCaseInsensitive(v3, i:lower(), j)
    end
    return v3
end

function u29.GetSkinDisplayName(a1, a2) -- Line: 109 -- upvalues: u17 (val) -- types: a1: string?, a2: boolean?
    if not a1 then
        return ""
    end
    if not a1:find("PATTERN") then
        return u17[a1] or a1
    end
    local v1, v2 = table.unpack((a1:split("_PATTERN_")))
    return a2 and ("%* • Pattern %*"):format(v1, v2) or v1
end

function u29.GetFullItemDisplayName(a1, a2, a3, a4, a5) -- Line: 122
    -- upvalues: Skins (val), u29 (val)
    local v1
    local v2 = Skins.GetSkinInformation(a1, a2)
    if not v2 then
        return ""
    end
    local v3 = if a4 ~= nil then a4 else true
    local v4 = u29.GetWeaponDisplayName(v2.paintId, a5)
    if v4:find("PATTERN") then
        local v5
        v1, v5 = table.unpack((v4:split("_PATTERN_")))
        return v3 and ("%* • Pattern %*"):format(v1, v5) or v1
    end
    v4 = ("%* | %*"):format(v4:split(" | ")[1], (u29.GetSkinDisplayName(a2, v3)))
    v1 = if not a3 then "" else "KillTrak™ "
    if v2.type == "Melee" or v2.type == "Glove" then
        v1 = v1 .. "★ "
    end
    return (("%*%*"):format(v1, v4))
end

function u29.GetInternalSearchQuery(a1) -- Line: 153
    -- upvalues: u18 (val), replaceCaseInsensitive (val)
    if not a1 then
        return ""
    end
    local v1 = a1
    for i, j in u18 do
        v1 = replaceCaseInsensitive(v1, i, j)
    end
    return v1
end

function u29.GetSearchIdentity(a1, a2) -- Line: 166 -- upvalues: u29 (val) -- types: a1: string?, a2: string?
    local v1 = a1 or ""
    local v2 = u29.GetWeaponDisplayName(v1)
    local v3 = u29.GetSkinDisplayName(a2 or "", true)
    if v2 == v1 then
        return (("%* | %*"):format(v1, v3))
    end
    return (("%* | %* %*"):format(v2, v3, v1))
end

return (setmetatable(u29, {
    __call = function(a1, a2, a3) -- Line: 180 -- upvalues: u29 (val) -- types: a2: string, a3: boolean?
        return u29.GetSkinDisplayName(a2, a3)
    end,
}))