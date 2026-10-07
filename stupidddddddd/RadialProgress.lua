-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb.RadialProgress
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb.RadialProgress
-- Decompile time: 2.79 ms

local v1 = {}
local u5 = Color3.fromRGB(219, 159, 47)
local u10 = Color3.fromRGB(43, 172, 43)
local u15 = Color3.fromRGB(182, 45, 45)
local u20 = Color3.new(0, 0, 0)
local u25 = Color3.new(1, 1, 1)
local u30 = Color3.fromRGB(255, 200, 0)
local u35 = Color3.fromRGB(255, 255, 255)
local u54 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(0.501, 1),
    (NumberSequenceKeypoint.new(1, 1)),
})

local function formatTime(a1) -- Line: 27 -- types: a1: number
    local v1 = math.floor(a1 / 60)
    local v2 = a1 % 60
    local v3 = math.floor(v2)
    return string.format("%02d:%02d.%03d", v1, v3, (math.floor((v2 - v3) * 1000)))
end

local function getBackgroundColor(a1) -- Line: 36 -- upvalues: u15 (val), u5 (val), u10 (val) -- types: a1: number
    local v1 = math.clamp(a1, 0, 1)
    if v1 <= 0.5 then
        return u15:Lerp(u5, v1 * 2)
    end
    return u5:Lerp(u10, (v1 - 0.5) * 2)
end

local function applyHighContrastText(a1) -- Line: 51 -- upvalues: u20 (val), u25 (val) -- types: a1: userdata
    a1.TextStrokeColor3 = u20
    a1.TextColor3 = u25
    a1.TextStrokeTransparency = 0
end

local function animateIcon(a1, a2, a3, a4) -- Line: 58
    -- upvalues: u30 (val), u35 (val)
    if a1 and a1.ProgressBar then
        local v1 = a1.ProgressBar:FindFirstChild(a3)
        if not v1 then
            return
        end
        local v2 = a2 * 0.5 + 0.5
        local v3 = math.sin((tick()) * v2 * 3.141592653589793 * 2)
        local v4 = v3 * 0.05 + 1
        local v5 = UDim2.new(a4.X * v4, 0, a4.Y * v4, 0)
        local v6 = u30:Lerp(u35, (v3 + 1) / 2)
        v1.Size = v5
        v1.ImageColor3 = v6
        return
    end
end

function v1.Initialize(a1, a2) -- Line: 88 -- upvalues: u15 (val), u54 (val) -- types: a2: string
    if a1.Frame and a1.Frame.ProgressBar then
        local ProgressBar = a1.Frame.ProgressBar
        local LeftGradient = ProgressBar:FindFirstChild("LeftGradient")
        local RightGradient = ProgressBar:FindFirstChild("RightGradient")
        local ProgressBarImage = LeftGradient:FindFirstChild("ProgressBarImage")
        local ProgressBarImage_2 = RightGradient:FindFirstChild("ProgressBarImage")
        local UIGradient = ProgressBarImage:FindFirstChild("UIGradient")
        local UIGradient_2 = ProgressBarImage_2:FindFirstChild("UIGradient")
        a1.LeftProgressImage = ProgressBarImage
        a1.RightProgressImage = ProgressBarImage_2
        a1.LeftGradient = UIGradient
        a1.RightGradient = UIGradient_2
        ProgressBarImage.ImageColor3 = u15
        ProgressBarImage_2.ImageColor3 = u15
        ProgressBarImage.ImageTransparency = 0
        ProgressBarImage_2.ImageTransparency = 0
        LeftGradient.Visible = true
        RightGradient.Visible = true
        ProgressBarImage.Visible = true
        ProgressBarImage_2.Visible = true
        UIGradient.Transparency = u54
        UIGradient_2.Transparency = u54
        UIGradient.Rotation = 0
        UIGradient_2.Rotation = 0
        return
    end
    warn((("%*: Frame or ProgressBar not found"):format(a2)))
end

function v1.Update(a1, a2, a3, a4) -- Line: 128
    -- upvalues: u15 (val), u5 (val), u10 (val), animateIcon (val), u20 (val)
    if a1.Frame and a1.Frame.ProgressBar then
        if a1.LeftGradient and a1.RightGradient then
            if a1.LeftProgressImage and a1.RightProgressImage then
                local v1
                local v2 = math.clamp(a2, 0, 1)
                local v3 = math.clamp(v2, 0, 1)
                local v4 = if not (v3 <= 0.5) then u5:Lerp(u10, (v3 - 0.5) * 2) else u15:Lerp(u5, v3 * 2)
                a1.LeftProgressImage.ImageColor3 = v4
                a1.RightProgressImage.ImageColor3 = v4
                v3 = v2 * 180
                a1.RightGradient.Rotation = 360 - v3
                a1.LeftGradient.Rotation = v3 + 180
                animateIcon(a1.Frame, v2, a3, a4)
                if a1.Frame.UIGradient then
                    v1 = v4:Lerp(u20, 0.3)
                    a1.Frame.UIGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, v4),
                        (ColorSequenceKeypoint.new(1, v1)),
                    })
                end
                v1 = v4:Lerp(u20, 0.2)
                if a1.Frame.Frame1 then
                    a1.Frame.Frame1.BackgroundColor3 = v1
                end
                if a1.Frame.Frame2 then
                    a1.Frame.Frame2.BackgroundColor3 = v1
                end
                return
            end
            return
        end
        return
    end
end

function v1.SetTimer(a1, a2) -- Line: 172 -- upvalues: u20 (val), u25 (val) -- types: a2: number
    if a1 and a1.Timer then
        local Timer = a1.Timer
        local v1 = math.floor(a2 / 60)
        local v2 = a2 % 60
        local v3 = math.floor(v2)
        Timer.Text = string.format("%02d:%02d.%03d", v1, v3, (math.floor((v2 - v3) * 1000)))
        local Timer_2 = a1.Timer
        Timer_2.TextStrokeColor3 = u20
        Timer_2.TextColor3 = u25
        Timer_2.TextStrokeTransparency = 0
        return
    end
end

function v1.SetTitle(a1, a2) -- Line: 180 -- upvalues: u20 (val), u25 (val) -- types: a2: string
    if a1 and a1.Title then
        a1.Title.Text = a2
        local Title = a1.Title
        Title.TextStrokeColor3 = u20
        Title.TextColor3 = u25
        Title.TextStrokeTransparency = 0
        return
    end
end

return v1