-- ReplicatedStorage.Controllers.WarmupEffectsController
-- Script path: ReplicatedStorage.Controllers.WarmupEffectsController
-- Decompile time: 10.68 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local LocalPlayer = Players.LocalPlayer
local u40 = {WarmupColorCorrection = true, FlashbangColorCorrection = true}
local u43 = {"Brightness", "Contrast", "Saturation", "TintColor"}
local v1 = {}
local u49 = nil

local function getBestMapColorCorrection() -- Line: 39 -- upvalues: u49 (ref), Lighting (val), u40 (val)
    local v1 = u49
    if v1 and v1.Enabled and v1:IsDescendantOf(Lighting) and not u40[v1.Name] then
        return v1
    end
    local v2 = nil
    local v3 = nil
    for i, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("ColorCorrectionEffect") and not u40[v.Name] then
            if v.Enabled and not v2 then
                v2 = v
            end
            if not v3 then
                v3 = v
            end
        end
    end
    u49 = v2 or v3
    return u49
end

local function copyColorCorrection(a1, a2) -- Line: 64 -- upvalues: u43 (val)
    for i, j in u43 do
        a1[j] = a2[j]
    end
end

local function findActiveViewmodelModel() -- Line: 70 -- upvalues: Workspace (val)
    local CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then
        return nil
    end
    for i, v in ipairs(CurrentCamera:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Stats") then
            return v
        end
    end
    for i2, i3 in ipairs(CurrentCamera:GetDescendants()) do
        if i3:IsA("Model") and i3:FindFirstChild("Stats") then
            return i3
        end
    end
    return nil
end

local function getViewmodelModelFromInstance(a1, a2) -- Line: 93 -- types: a1: userdata, a2: userdata
    local Parent = a1
    while Parent do
        if Parent == a2 then
            break
        end
        if Parent:IsA("Model") and Parent:FindFirstChild("Stats") then
            return Parent
        end
        Parent = Parent.Parent
    end
    return nil
end

function v1.Start() -- Line: 108
    -- upvalues: ReplicatedStorage (val), MenuState (val), LocalPlayer (val), getBestMapColorCorrection (val), u43 (val)
    -- upvalues: TweenService (val), Router (val), Workspace (val), findActiveViewmodelModel (val)
    -- upvalues: getViewmodelModelFromInstance (val), GameState (val)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Warmup = Assets and Assets:FindFirstChild("Warmup")
    if Warmup and Warmup:IsA("Folder") then
        local ColorCorrection = Warmup:FindFirstChild("ColorCorrection")
        local ViewmodelHighlight = Warmup:FindFirstChild("ViewmodelHighlight")
        if ColorCorrection and ColorCorrection:IsA("ColorCorrectionEffect") then
            if ViewmodelHighlight and ViewmodelHighlight:IsA("Highlight") then
                local u31 = 0
                local u32 = nil
                local u33 = false

                local function isEligibleToShow() -- Line: 131 -- upvalues: MenuState (upval), LocalPlayer (upval)
                    if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
                        local v1 = MenuState.GetMenuFrame()
                        if v1 and v1.Visible then
                            return false
                        end
                        local v2 = LocalPlayer:GetAttribute("IsSpectating") == true
                        local v3 = true
                        if LocalPlayer.Character == nil then
                            v3 = v2
                        end
                        return v3
                    end
                    return false
                end

                local function stop() -- Line: 146 -- upvalues: u31 (ref), u32 (ref)
                    u31 = u31 + 1
                    if u32 then
                        u32()
                        u32 = nil
                    end
                end

                local function startBuyPeriodEffects() -- Line: 154
                    -- upvalues: u31 (ref), u32 (ref), getBestMapColorCorrection (upval), u43 (upval)
                    -- upvalues: ColorCorrection (val), TweenService (upval), Router (upval), Workspace (upval)
                    -- upvalues: findActiveViewmodelModel (upval), ViewmodelHighlight (val)
                    -- upvalues: getViewmodelModelFromInstance (upval)
                    local Enabled
                    u31 = u31 + 1
                    if u32 then
                        u32()
                        u32 = nil
                    end
                    u31 = u31 + 1
                    local u8 = u31
                    local u9 = false
                    local u10 = false
                    local u11 = nil
                    local u12 = nil
                    local u14 = getBestMapColorCorrection()
                    local u15 = nil
                    if not u14 then
                        Enabled = false
                    else
                        Enabled = u14.Enabled
                        if not Enabled then
                            Enabled = false
                        end
                    end
                    local u18 = nil
                    if not u14 then
                        warn("[WarmupEffectsController] No map ColorCorrectionEffect found under Lighting; warmup CC tween skipped")
                    else
                        local v1 = {}
                        for i, j in u43 do
                            v1[j] = u14[j]
                        end
                        u18 = v1
                        u14.Enabled = true
                        for k, n in u43 do
                            u14[n] = ColorCorrection[n]
                        end
                    end

                    local function getCountdownRemaining() -- Line: 179 -- upvalues: u9 (ref), u11 (ref), u12 (ref)
                        if u9 and u11 and u12 then
                            return (math.max(0, u12 - ((os.clock()) - u11)))
                        end
                        return 0
                    end

                    local function startFinalCountdownTweens(a1) -- Line: 186
                        -- upvalues: u9 (ref), u11 (ref), u12 (ref), u14 (val), u18 (ref), u15 (ref)
                        -- upvalues: TweenService (upval)
                        if not u9 and not (a1 <= 0) then
                            u9 = true
                            u11 = os.clock()
                            u12 = a1
                            if u14 and u18 then
                                if u15 then
                                    u15:Cancel()
                                    u15 = nil
                                end
                                local v1 = TweenService:Create(u14, TweenInfo.new(a1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), u18)
                                u15 = v1
                                v1:Play()
                            end
                            return
                        end
                    end

                    local function maybePlayGameticSound(a1) -- Line: 208
                        -- upvalues: u10 (ref), Router (upval)
                        if not u10 and a1 <= 2 then
                            u10 = true
                            Router.broadcastRouter("RunRoundSound", "Round Start Countdown")
                        end
                    end

                    local u85 = nil
                    local u86 = nil
                    local u87 = {}
                    local u88 = nil
                    local u89 = false
                    local u163 = false

                    local function releaseHighlight(a1) -- Line: 224 -- upvalues: u86 (ref) -- types: a1: userdata
                        if a1.Parent then
                            a1:Destroy()
                        end
                        if u86 == a1 then
                            u86 = nil
                        end
                    end

                    local function endHighlightPhase() -- Line: 233 -- upvalues: u89 (ref), u85 (ref), u86 (ref)
                        u89 = true
                        if u85 then
                            u85:Cancel()
                            u85 = nil
                        end
                        if u86 then
                            u86:Destroy()
                            u86 = nil
                        end
                    end

                    local function startHighlightTweenIfPossible(a1) -- Line: 245
                        -- upvalues: u89 (ref), u86 (ref), u85 (ref), u9 (ref), u11 (ref), u12 (ref)
                        -- upvalues: TweenService (upval)
                        if u89 then
                            if a1.Parent then
                                a1:Destroy()
                            end
                            if u86 == a1 then
                                u86 = nil
                            end
                            return
                        end
                        if not u85 and u9 then
                            local v1 = if not u9 or not u11 then 0 else if u12 then math.max(0, u12 - ((os.clock()) - u11)) else 0
                            if not (v1 <= 0) then
                                local u46 = TweenService:Create(
                                    a1,
                                    TweenInfo.new(v1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                    {FillTransparency = 1, OutlineTransparency = 1}
                                )
                                u85 = u46
                                u46.Completed:Connect(function(a1_2) -- Line: 274 -- upvalues: u85 (upval), u46 (val), u89 (upval), a1 (val), u86 (upval)
                                    if u85 == u46 then
                                        u85 = nil
                                    end
                                    if a1_2 == Enum.PlaybackState.Completed then
                                        u89 = true
                                    end
                                    local v1 = a1
                                    if v1.Parent then
                                        v1:Destroy()
                                    end
                                    if u86 == v1 then
                                        u86 = nil
                                    end
                                end)
                                u46:Play()
                                return
                            end
                            u89 = true
                            a1.FillTransparency = 1
                            a1.OutlineTransparency = 1
                            a1:Destroy()
                            if u86 == a1 then
                                u86 = nil
                            end
                            return
                        end
                    end

                    local function ensureHighlightAttached() -- Line: 288
                        -- upvalues: u31 (upval), u8 (val), u89 (ref), u9 (ref), u11 (ref), u12 (ref), u85 (ref)
                        -- upvalues: u86 (ref), Workspace (upval), u88 (ref), findActiveViewmodelModel (upval)
                        -- upvalues: ViewmodelHighlight (upval), startHighlightTweenIfPossible (val)
                        if u31 == u8 and not u89 then
                            local v1
                            if u9 then
                                if (if not u9 or not u11 then 0 else if u12 then math.max(0, u12 - ((os.clock()) - u11)) else 0) <= 0 then
                                    u89 = true
                                    if u85 then
                                        u85:Cancel()
                                        u85 = nil
                                    end
                                    if u86 then
                                        u86:Destroy()
                                        u86 = nil
                                    end
                                    return
                                end
                            end
                            local CurrentCamera = Workspace.CurrentCamera
                            if not CurrentCamera then
                                return
                            end
                            local v2 = u88
                            if not v2 or not v2:IsDescendantOf(CurrentCamera) then
                                u88 = (findActiveViewmodelModel())
                            end
                            if not v2 then
                                return
                            end
                            local v3 = u86
                            if not v3 or v3.Parent == nil then
                                u86 = (ViewmodelHighlight:Clone())
                                u85 = nil
                            else
                                v1 = v3
                            end
                            if v1.Parent ~= v2 then
                                v1.Parent = v2
                            end
                            if v1.Adornee ~= v2 then
                                v1.Adornee = v2
                            end
                            startHighlightTweenIfPossible(v1)
                            return
                        end
                    end

                    local function queueEnsureHighlightAttached() -- Line: 335
                        -- upvalues: u163 (ref), u31 (upval), u8 (val), u89 (ref), ensureHighlightAttached (val)
                        if not u163 and u31 == u8 and not u89 then
                            u163 = true
                            task.defer(function() -- Line: 341 -- upvalues: u163 (upval), ensureHighlightAttached (upval)
                                u163 = false
                                ensureHighlightAttached()
                            end)
                            return
                        end
                    end

                    local function startCountdown(a1) -- Line: 347
                        -- upvalues: startFinalCountdownTweens (val), u86 (ref), startHighlightTweenIfPossible (val)
                        -- upvalues: u163 (ref), u31 (upval), u8 (val), u89 (ref), ensureHighlightAttached (val)
                        startFinalCountdownTweens((math.min(3, a1)))
                        local v1 = u86
                        if v1 then
                            startHighlightTweenIfPossible(v1)
                            return
                        end
                        if not u163 and u31 == u8 then
                            if u89 then
                                return
                            end
                            u163 = true
                            task.defer(function() -- Line: 341 -- upvalues: u163 (upval), ensureHighlightAttached (upval)
                                u163 = false
                                ensureHighlightAttached()
                            end)
                        end
                    end

                    ensureHighlightAttached()

                    local function disconnectCamera() -- Line: 360 -- upvalues: u87 (val)
                        for i, j in u87 do
                            j:Disconnect()
                        end
                        table.clear(u87)
                    end

                    local function bindToCamera(a1) -- Line: 367
                        -- upvalues: u87 (val), u89 (ref), getViewmodelModelFromInstance (upval), u88 (ref), u163 (ref)
                        -- upvalues: u31 (upval), u8 (val), ensureHighlightAttached (val), u86 (ref)
                        -- upvalues: ViewmodelHighlight (upval)
                        for i, j in u87 do
                            j:Disconnect()
                        end
                        table.clear(u87)
                        if not a1 then
                            return
                        end
                        table.insert(u87, (a1.ChildAdded:Connect(function(a1_2) -- Line: 373
                            -- upvalues: u89 (upval), getViewmodelModelFromInstance (upval), a1 (val), u88 (upval)
                            -- upvalues: u163 (upval), u31 (upval), u8 (upval), ensureHighlightAttached (upval)
                            if u89 then
                                return
                            end
                            local v1 = getViewmodelModelFromInstance(a1_2, a1)
                            if v1 then
                                u88 = v1
                            end
                            if not u163 and u31 == u8 then
                                if u89 then
                                    return
                                end
                                u163 = true
                                task.defer(function() -- Line: 341 -- upvalues: u163 (upval), ensureHighlightAttached (upval)
                                    u163 = false
                                    ensureHighlightAttached()
                                end)
                            end
                        end)))
                        table.insert(u87, (a1.ChildRemoved:Connect(function(a1) -- Line: 386
                            -- upvalues: u89 (upval), u88 (upval), u163 (upval), u31 (upval), u8 (upval)
                            -- upvalues: ensureHighlightAttached (upval)
                            if u89 then
                                return
                            end
                            if u88 == a1 or u88 and u88:IsDescendantOf(a1) then
                                u88 = nil
                            end
                            if not u163 and u31 == u8 then
                                if u89 then
                                    return
                                end
                                u163 = true
                                task.defer(function() -- Line: 341 -- upvalues: u163 (upval), ensureHighlightAttached (upval)
                                    u163 = false
                                    ensureHighlightAttached()
                                end)
                            end
                        end)))
                        table.insert(u87, (a1.DescendantAdded:Connect(function(a1_2) -- Line: 398
                            -- upvalues: u89 (upval), u86 (upval), ViewmodelHighlight (upval)
                            -- upvalues: getViewmodelModelFromInstance (upval), a1 (val), u88 (upval), u163 (upval)
                            -- upvalues: u31 (upval), u8 (upval), ensureHighlightAttached (upval)
                            if not u89 and a1_2 ~= u86 then
                                if a1_2:IsA("Highlight") and a1_2.Name == ViewmodelHighlight.Name then
                                    return
                                end
                                local v1 = getViewmodelModelFromInstance(a1_2, a1)
                                if v1 then
                                    u88 = v1
                                    if not u163 and u31 == u8 then
                                        if u89 then
                                            return
                                        end
                                        u163 = true
                                        task.defer(function() -- Line: 341 -- upvalues: u163 (upval), ensureHighlightAttached (upval)
                                            u163 = false
                                            ensureHighlightAttached()
                                        end)
                                    end
                                end
                                return
                            end
                        end)))
                    end

                    bindToCamera(Workspace.CurrentCamera)
                    local u118 = (Workspace:GetPropertyChangedSignal("CurrentCamera")):Connect(function() -- Line: 414
                        -- upvalues: u88 (ref), bindToCamera (val), Workspace (upval), u163 (ref), u31 (upval), u8 (val)
                        -- upvalues: u89 (ref), ensureHighlightAttached (val)
                        u88 = nil
                        bindToCamera(Workspace.CurrentCamera)
                        if not u163 and u31 == u8 then
                            if u89 then
                                return
                            end
                            u163 = true
                            task.defer(function() -- Line: 341 -- upvalues: u163 (upval), ensureHighlightAttached (upval)
                                u163 = false
                                ensureHighlightAttached()
                            end)
                        end
                    end)
                    local u127 = (Workspace:GetAttributeChangedSignal("Timer")):Connect(function() -- Line: 421
                        -- upvalues: u31 (upval), u8 (val), Workspace (upval), u89 (ref), u85 (ref), u86 (ref)
                        -- upvalues: u10 (ref), Router (upval), u9 (ref), startFinalCountdownTweens (val)
                        -- upvalues: startHighlightTweenIfPossible (val), u163 (ref), ensureHighlightAttached (val)
                        if u31 ~= u8 then
                            return
                        end
                        local Attribute = Workspace:GetAttribute("Timer")
                        if typeof(Attribute) ~= "number" then
                            return
                        end
                        if Attribute <= 0 then
                            u89 = true
                            if u85 then
                                u85:Cancel()
                                u85 = nil
                            end
                            if u86 then
                                u86:Destroy()
                                u86 = nil
                            end
                            return
                        end
                        if not u10 and Attribute <= 2 then
                            u10 = true
                            Router.broadcastRouter("RunRoundSound", "Round Start Countdown")
                        end
                        if not u9 and Attribute <= 3 then
                            startFinalCountdownTweens((math.min(3, Attribute)))
                            local v1 = u86
                            if v1 then
                                startHighlightTweenIfPossible(v1)
                                return
                            end
                            if not u163 and u31 == u8 then
                                if u89 then
                                    return
                                end
                                u163 = true
                                task.defer(function() -- Line: 341 -- upvalues: u163 (upval), ensureHighlightAttached (upval)
                                    u163 = false
                                    ensureHighlightAttached()
                                end)
                            end
                        end
                    end)
                    local Attribute = Workspace:GetAttribute("Timer")
                    if typeof(Attribute) == "number" and Attribute > 0 then
                        if not u10 and Attribute <= 2 then
                            Router.broadcastRouter("RunRoundSound", "Round Start Countdown")
                        end
                        if Attribute <= 3 then
                            startFinalCountdownTweens((math.min(3, Attribute)))
                            local v2 = u86
                            if v2 then
                                startHighlightTweenIfPossible(v2)
                            elseif not u163 and u31 == u8 and not u89 then
                                u163 = true
                                task.defer(function() -- Line: 341 -- upvalues: u163 (ref), ensureHighlightAttached (val)
                                    u163 = false
                                    ensureHighlightAttached()
                                end)
                            end
                        end
                    end

                    function u32() -- Line: 450
                        -- upvalues: u163 (ref), u15 (ref), u85 (ref), u87 (val), u118 (val), u127 (val), u86 (ref)
                        -- upvalues: u14 (val), u18 (ref), u43 (upval), Enabled (val)
                        u163 = false
                        if u15 then
                            u15:Cancel()
                            u15 = nil
                        end
                        if u85 then
                            u85:Cancel()
                            u85 = nil
                        end
                        for i, j in u87 do
                            j:Disconnect()
                        end
                        table.clear(u87)
                        u118:Disconnect()
                        u127:Disconnect()
                        if u86 then
                            u86:Destroy()
                            u86 = nil
                        end
                        if u14 and u18 then
                            for k, n in u43 do
                                u14[n] = u18[n]
                            end
                            u14.Enabled = Enabled
                        end
                    end
                end

                local function updateState() -- Line: 479
                    -- upvalues: GameState (upval), MenuState (upval), LocalPlayer (upval), u33 (ref)
                    -- upvalues: startBuyPeriodEffects (val), u31 (ref), u32 (ref)
                    if GameState.GetState() == "Buy Period" then
                        local v1
                        if MenuState.IsInspectActive() then
                            v1 = false
                        elseif not MenuState.IsCaseSceneActive() then
                            local v2 = MenuState.GetMenuFrame()
                            if not v2 or not v2.Visible then
                                local v3 = LocalPlayer:GetAttribute("IsSpectating") == true
                                v1 = true
                                if LocalPlayer.Character == nil then
                                    v1 = v3
                                end
                            else
                                v1 = false
                            end
                        else
                            v1 = false
                        end
                        if v1 then
                            if u33 then
                                return
                            end
                            u33 = true
                            startBuyPeriodEffects()
                            return
                        end
                    end
                    if u33 then
                        u33 = false
                        u31 = u31 + 1
                        if u32 then
                            u32()
                            u32 = nil
                        end
                    end
                end

                GameState.ListenToState(updateState)
                MenuState.OnScreenChanged:Connect(updateState)
                MenuState.OnInspectStateChanged:Connect(updateState)
                MenuState.OnCaseSceneStateChanged:Connect(updateState)
                LocalPlayer.CharacterAdded:Connect(updateState)
                LocalPlayer.CharacterRemoving:Connect(updateState)
                ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(updateState)
                if GameState.GetState() == "Buy Period" then
                    local v1
                    if MenuState.IsInspectActive() then
                        v1 = false
                    elseif not MenuState.IsCaseSceneActive() then
                        local v2 = MenuState.GetMenuFrame()
                        if not v2 or not v2.Visible then
                            local v3 = LocalPlayer:GetAttribute("IsSpectating") == true
                            v1 = true
                            if LocalPlayer.Character == nil then
                                v1 = v3
                            end
                        else
                            v1 = false
                        end
                    else
                        v1 = false
                    end
                    if not v1 then
                        if u33 then
                            u31 = u31 + 1
                            if u32 then
                                u32()
                            end
                        end
                    elseif not u33 then
                        startBuyPeriodEffects()
                    end
                elseif u33 then
                    u31 = u31 + 1
                    if u32 then
                        u32()
                    end
                end
                return
            end
            warn("[WarmupEffectsController] Missing Assets.Warmup.ViewmodelHighlight (Highlight)")
            return
        end
        warn("[WarmupEffectsController] Missing Assets.Warmup.ColorCorrection (ColorCorrectionEffect)")
        return
    end
    warn("[WarmupEffectsController] Missing ReplicatedStorage.Assets.Warmup")
end

return v1