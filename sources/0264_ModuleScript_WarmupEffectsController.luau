-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u1 = {
    WarmupColorCorrection = true,
    FlashbangColorCorrection = true
};
local u2 = { "Brightness", "Contrast", "Saturation", "TintColor" };
local v3 = {};
local u4 = nil;

local function getBestMapColorCorrection() -- Line: 39
    -- upvalues: u4 (ref), Lighting (copy), u1 (copy)
    local v5 = u4;

    if v5 and (v5.Enabled and (v5:IsDescendantOf(Lighting) and not u1[v5.Name])) then
        return v5;
    end;

    local v6 = nil;
    local v7 = nil;

    for _, descendant in ipairs(Lighting:GetDescendants()) do
        if descendant:IsA("ColorCorrectionEffect") and not u1[descendant.Name] then
            if descendant.Enabled then
                v6 = v6 or descendant;
            end;

            if not v7 then
                v7 = descendant;
            end;
        end;
    end;

    u4 = v6 or v7;

    return u4;
end;

local function copyColorCorrection(p8, p9) -- Line: 64
    -- upvalues: u2 (copy)
    for _, v in u2 do
        p8[v] = p9[v];
    end;
end;

local function findActiveViewmodelModel() -- Line: 70
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    for _, child in ipairs(CurrentCamera:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChild("Stats") then
            return child;
        end;
    end;

    for _, descendant in ipairs(CurrentCamera:GetDescendants()) do
        if descendant:IsA("Model") and descendant:FindFirstChild("Stats") then
            return descendant;
        end;
    end;

    return nil;
end;

local function getViewmodelModelFromInstance(p10: userdata, p11: userdata) -- Line: 93
    while p10 and p10 ~= p11 do
        if p10:IsA("Model") and p10:FindFirstChild("Stats") then
            return p10;
        end;

        p10 = p10.Parent;
    end;

    return nil;
end;

function v3.Start() -- Line: 108
    -- upvalues: ReplicatedStorage (copy), MenuState (copy), LocalPlayer (copy), getBestMapColorCorrection (copy), u2 (copy), TweenService (copy), Router (copy), Workspace (copy), findActiveViewmodelModel (copy), getViewmodelModelFromInstance (copy), GameState (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Warmup");
    end;

    if not (Assets and Assets:IsA("Folder")) then
        warn("[WarmupEffectsController] Missing ReplicatedStorage.Assets.Warmup");

        return;
    end;

    local ColorCorrection = Assets:FindFirstChild("ColorCorrection");
    local ViewmodelHighlight = Assets:FindFirstChild("ViewmodelHighlight");

    if not (ColorCorrection and ColorCorrection:IsA("ColorCorrectionEffect")) then
        warn("[WarmupEffectsController] Missing Assets.Warmup.ColorCorrection (ColorCorrectionEffect)");

        return;
    end;

    if not (ViewmodelHighlight and ViewmodelHighlight:IsA("Highlight")) then
        warn("[WarmupEffectsController] Missing Assets.Warmup.ViewmodelHighlight (Highlight)");

        return;
    end;

    local u12 = 0;
    local u13 = nil;
    local u14 = false;

    local function isEligibleToShow() -- Line: 131
        -- upvalues: MenuState (ref), LocalPlayer (ref)
        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return false;
        end;

        local MenuFrame = MenuState.GetMenuFrame();

        if MenuFrame and MenuFrame.Visible then
            return false;
        end;

        local v15 = LocalPlayer:GetAttribute("IsSpectating") == true;

        return LocalPlayer.Character ~= nil and true or v15;
    end;

    local function stop() -- Line: 146
        -- upvalues: u12 (ref), u13 (ref)
        u12 = u12 + 1;

        if u13 then
            u13();
            u13 = nil;
        end;
    end;

    local function startBuyPeriodEffects() -- Line: 154
        -- upvalues: u12 (ref), u13 (ref), getBestMapColorCorrection (ref), u2 (ref), ColorCorrection (copy), TweenService (ref), Router (ref), Workspace (ref), findActiveViewmodelModel (ref), ViewmodelHighlight (copy), getViewmodelModelFromInstance (ref)
        u12 = u12 + 1;

        if u13 then
            u13();
            u13 = nil;
        end;

        u12 = u12 + 1;
        local u16 = u12;
        local u17 = false;
        local u18 = false;
        local u19 = nil;
        local u20 = nil;
        local u21 = getBestMapColorCorrection();
        local u22 = nil;
        local u23;

        if u21 then
            u23 = u21.Enabled or false;
        else
            u23 = false;
        end;

        local u24 = nil;

        if u21 then
            u24 = {};

            for _, v in u2 do
                u24[v] = u21[v];
            end;

            u21.Enabled = true;
            local v25 = ColorCorrection;

            for _, v in u2 do
                u21[v] = v25[v];
            end;
        else
            warn("[WarmupEffectsController] No map ColorCorrectionEffect found under Lighting; warmup CC tween skipped");
        end;

        local function getCountdownRemaining() -- Line: 179
            -- upvalues: u17 (ref), u19 (ref), u20 (ref)
            if not (u17 and (u19 and u20)) then
                return 0;
            end;

            local v26 = u20 - (os.clock() - u19);

            return math.max(0, v26);
        end;

        local function startFinalCountdownTweens(p27: number) -- Line: 186
            -- upvalues: u17 (ref), u19 (ref), u20 (ref), u21 (copy), u24 (ref), u22 (ref), TweenService (ref)
            if u17 or p27 <= 0 then
                return;
            end;

            u17 = true;
            u19 = os.clock();
            u20 = p27;

            if u21 and u24 then
                if u22 then
                    u22:Cancel();
                    u22 = nil;
                end;

                local v28 = TweenService:Create(u21, TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), u24);
                u22 = v28;
                v28:Play();
            end;
        end;

        local function maybePlayGameticSound(p29: number) -- Line: 208
            -- upvalues: u18 (ref), Router (ref)
            if not u18 and p29 <= 2 then
                u18 = true;
                Router.broadcastRouter("RunRoundSound", "Round Start Countdown");
            end;
        end;

        local u30 = nil;
        local u31 = nil;
        local u32 = {};
        local u33 = nil;
        local u34 = false;
        local u35 = false;

        local function releaseHighlight(p36: userdata) -- Line: 224
            -- upvalues: u31 (ref)
            if p36.Parent then
                p36:Destroy();
            end;

            if u31 == p36 then
                u31 = nil;
            end;
        end;

        local function endHighlightPhase() -- Line: 233
            -- upvalues: u34 (ref), u30 (ref), u31 (ref)
            u34 = true;

            if u30 then
                u30:Cancel();
                u30 = nil;
            end;

            if u31 then
                u31:Destroy();
                u31 = nil;
            end;
        end;

        local function startHighlightTweenIfPossible(u37: userdata) -- Line: 245
            -- upvalues: u34 (ref), u31 (ref), u30 (ref), u17 (ref), u19 (ref), u20 (ref), TweenService (ref)
            if u34 then
                if u37.Parent then
                    u37:Destroy();
                end;

                if u31 == u37 then
                    u31 = nil;
                end;

                return;
            end;

            if u30 or not u17 then
                return;
            end;

            local v38;

            if u17 and (u19 and u20) then
                local v39 = u20 - (os.clock() - u19);
                v38 = math.max(0, v39);
            else
                v38 = 0;
            end;

            if v38 > 0 then
                local u40 = TweenService:Create(u37, TweenInfo.new(v38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    FillTransparency = 1,
                    OutlineTransparency = 1
                });
                u30 = u40;
                u40.Completed:Connect(function(p41) -- Line: 274
                    -- upvalues: u30 (ref), u40 (copy), u34 (ref), u37 (copy), u31 (ref)
                    if u30 == u40 then
                        u30 = nil;
                    end;

                    if p41 == Enum.PlaybackState.Completed then
                        u34 = true;
                    end;

                    local v42 = u37;

                    if v42.Parent then
                        v42:Destroy();
                    end;

                    if u31 == v42 then
                        u31 = nil;
                    end;
                end);
                u40:Play();

                return;
            end;

            u34 = true;
            u37.FillTransparency = 1;
            u37.OutlineTransparency = 1;
            u37:Destroy();

            if u31 == u37 then
                u31 = nil;
            end;
        end;

        local function ensureHighlightAttached() -- Line: 288
            -- upvalues: u12 (ref), u16 (copy), u34 (ref), u17 (ref), u19 (ref), u20 (ref), u30 (ref), u31 (ref), Workspace (ref), u33 (ref), findActiveViewmodelModel (ref), ViewmodelHighlight (ref), startHighlightTweenIfPossible (copy)
            if u12 ~= u16 or u34 then
                return;
            end;

            if u17 then
                local v43;

                if u17 and (u19 and u20) then
                    local v44 = u20 - (os.clock() - u19);
                    v43 = math.max(0, v44);
                else
                    v43 = 0;
                end;

                if v43 <= 0 then
                    u34 = true;

                    if u30 then
                        u30:Cancel();
                        u30 = nil;
                    end;

                    if u31 then
                        u31:Destroy();
                        u31 = nil;
                    end;

                    return;
                end;
            end;

            local CurrentCamera = Workspace.CurrentCamera;

            if not CurrentCamera then
                return;
            end;

            local v45 = u33;

            if not (v45 and v45:IsDescendantOf(CurrentCamera)) then
                v45 = findActiveViewmodelModel();
                u33 = v45;
            end;

            if not v45 then
                return;
            end;

            local v46 = u31;

            if not v46 or v46.Parent == nil then
                v46 = ViewmodelHighlight:Clone();
                u31 = v46;
                u30 = nil;
            end;

            if v46.Parent ~= v45 then
                v46.Parent = v45;
            end;

            if v46.Adornee ~= v45 then
                v46.Adornee = v45;
            end;

            startHighlightTweenIfPossible(v46);
        end;

        local function queueEnsureHighlightAttached() -- Line: 335
            -- upvalues: u35 (ref), u12 (ref), u16 (copy), u34 (ref), ensureHighlightAttached (copy)
            if u35 or (u12 ~= u16 or u34) then
                return;
            end;

            u35 = true;
            task.defer(function() -- Line: 341
                -- upvalues: u35 (ref), ensureHighlightAttached (ref)
                u35 = false;
                ensureHighlightAttached();
            end);
        end;

        local function startCountdown(p47: number) -- Line: 347
            -- upvalues: startFinalCountdownTweens (copy), u31 (ref), startHighlightTweenIfPossible (copy), u35 (ref), u12 (ref), u16 (copy), u34 (ref), ensureHighlightAttached (copy)
            startFinalCountdownTweens((math.min(3, p47)));
            local v48 = u31;

            if v48 then
                startHighlightTweenIfPossible(v48);

                return;
            end;

            if not u35 and u12 == u16 then
                if u34 then
                    return;
                end;

                u35 = true;
                task.defer(function() -- Line: 341
                    -- upvalues: u35 (ref), ensureHighlightAttached (ref)
                    u35 = false;
                    ensureHighlightAttached();
                end);
            end;
        end;

        ensureHighlightAttached();

        local function disconnectCamera() -- Line: 360
            -- upvalues: u32 (copy)
            for _, v in u32 do
                v:Disconnect();
            end;

            table.clear(u32);
        end;

        local function bindToCamera(u49: userdata?) -- Line: 367
            -- upvalues: u32 (copy), u34 (ref), getViewmodelModelFromInstance (ref), u33 (ref), u35 (ref), u12 (ref), u16 (copy), ensureHighlightAttached (copy), u31 (ref), ViewmodelHighlight (ref)
            for _, v in u32 do
                v:Disconnect();
            end;

            table.clear(u32);

            if not u49 then
                return;
            end;

            table.insert(u32, u49.ChildAdded:Connect(function(p50: userdata) -- Line: 373
                -- upvalues: u34 (ref), getViewmodelModelFromInstance (ref), u49 (copy), u33 (ref), u35 (ref), u12 (ref), u16 (ref), ensureHighlightAttached (ref)
                if u34 then
                    return;
                end;

                local v51 = getViewmodelModelFromInstance(p50, u49);

                if v51 then
                    u33 = v51;
                end;

                if not u35 and u12 == u16 then
                    if u34 then
                        return;
                    end;

                    u35 = true;
                    task.defer(function() -- Line: 341
                        -- upvalues: u35 (ref), ensureHighlightAttached (ref)
                        u35 = false;
                        ensureHighlightAttached();
                    end);
                end;
            end));
            table.insert(u32, u49.ChildRemoved:Connect(function(p52: userdata) -- Line: 386
                -- upvalues: u34 (ref), u33 (ref), u35 (ref), u12 (ref), u16 (ref), ensureHighlightAttached (ref)
                if u34 then
                    return;
                end;

                if u33 == p52 or u33 and u33:IsDescendantOf(p52) then
                    u33 = nil;
                end;

                if not u35 and u12 == u16 then
                    if u34 then
                        return;
                    end;

                    u35 = true;
                    task.defer(function() -- Line: 341
                        -- upvalues: u35 (ref), ensureHighlightAttached (ref)
                        u35 = false;
                        ensureHighlightAttached();
                    end);
                end;
            end));
            table.insert(u32, u49.DescendantAdded:Connect(function(p53: userdata) -- Line: 398
                -- upvalues: u34 (ref), u31 (ref), ViewmodelHighlight (ref), getViewmodelModelFromInstance (ref), u49 (copy), u33 (ref), u35 (ref), u12 (ref), u16 (ref), ensureHighlightAttached (ref)
                if u34 or (p53 == u31 or p53:IsA("Highlight") and p53.Name == ViewmodelHighlight.Name) then
                    return;
                end;

                local v54 = getViewmodelModelFromInstance(p53, u49);

                if v54 then
                    u33 = v54;

                    if not u35 and u12 == u16 then
                        if u34 then
                            return;
                        end;

                        u35 = true;
                        task.defer(function() -- Line: 341
                            -- upvalues: u35 (ref), ensureHighlightAttached (ref)
                            u35 = false;
                            ensureHighlightAttached();
                        end);
                    end;
                end;
            end));
        end;

        bindToCamera(Workspace.CurrentCamera);
        local u55 = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 414
            -- upvalues: u33 (ref), bindToCamera (copy), Workspace (ref), u35 (ref), u12 (ref), u16 (copy), u34 (ref), ensureHighlightAttached (copy)
            u33 = nil;
            bindToCamera(Workspace.CurrentCamera);

            if not u35 and u12 == u16 then
                if u34 then
                    return;
                end;

                u35 = true;
                task.defer(function() -- Line: 341
                    -- upvalues: u35 (ref), ensureHighlightAttached (ref)
                    u35 = false;
                    ensureHighlightAttached();
                end);
            end;
        end);
        local u57 = Workspace:GetAttributeChangedSignal("Timer"):Connect(function() -- Line: 421
            -- upvalues: u12 (ref), u16 (copy), Workspace (ref), u34 (ref), u30 (ref), u31 (ref), u18 (ref), Router (ref), u17 (ref), startFinalCountdownTweens (copy), startHighlightTweenIfPossible (copy), u35 (ref), ensureHighlightAttached (copy)
            if u12 ~= u16 then
                return;
            end;

            local Attribute = Workspace:GetAttribute("Timer");

            if typeof(Attribute) ~= "number" then
                return;
            end;

            if Attribute > 0 then
                if not u18 and Attribute <= 2 then
                    u18 = true;
                    Router.broadcastRouter("RunRoundSound", "Round Start Countdown");
                end;

                if not u17 and Attribute <= 3 then
                    startFinalCountdownTweens((math.min(3, Attribute)));
                    local v56 = u31;

                    if v56 then
                        startHighlightTweenIfPossible(v56);

                        return;
                    end;

                    if not u35 and u12 == u16 then
                        if u34 then
                            return;
                        end;

                        u35 = true;
                        task.defer(function() -- Line: 341
                            -- upvalues: u35 (ref), ensureHighlightAttached (ref)
                            u35 = false;
                            ensureHighlightAttached();
                        end);
                    end;
                end;

                return;
            end;

            u34 = true;

            if u30 then
                u30:Cancel();
                u30 = nil;
            end;

            if u31 then
                u31:Destroy();
                u31 = nil;
            end;
        end);
        local Attribute = Workspace:GetAttribute("Timer");

        if typeof(Attribute) == "number" and Attribute > 0 then
            if not u18 and Attribute <= 2 then
                u18 = true;
                Router.broadcastRouter("RunRoundSound", "Round Start Countdown");
            end;

            if Attribute <= 3 then
                startFinalCountdownTweens((math.min(3, Attribute)));
                local v58 = u31;

                if v58 then
                    startHighlightTweenIfPossible(v58);
                elseif not (u35 or (u12 ~= u16 or u34)) then
                    u35 = true;
                    task.defer(function() -- Line: 341
                        -- upvalues: u35 (ref), ensureHighlightAttached (copy)
                        u35 = false;
                        ensureHighlightAttached();
                    end);
                end;
            end;
        end;

        u13 = function() -- Line: 450
            -- upvalues: u35 (ref), u22 (ref), u30 (ref), u32 (copy), u55 (copy), u57 (copy), u31 (ref), u21 (copy), u24 (ref), u2 (ref), u23 (copy)
            u35 = false;

            if u22 then
                u22:Cancel();
                u22 = nil;
            end;

            if u30 then
                u30:Cancel();
                u30 = nil;
            end;

            for _, v in u32 do
                v:Disconnect();
            end;

            table.clear(u32);
            u55:Disconnect();
            u57:Disconnect();

            if u31 then
                u31:Destroy();
                u31 = nil;
            end;

            if u21 and u24 then
                local v59 = u21;
                local v60 = u24;

                for _, v in u2 do
                    v59[v] = v60[v];
                end;

                u21.Enabled = u23;
            end;
        end;
    end;

    local function updateState() -- Line: 479
        -- upvalues: GameState (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u12 (ref), u13 (ref)
        if GameState.GetState() == "Buy Period" then
            local v61;

            if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
                v61 = false;
            else
                local MenuFrame = MenuState.GetMenuFrame();

                if MenuFrame and MenuFrame.Visible then
                    v61 = false;
                else
                    local v62 = LocalPlayer:GetAttribute("IsSpectating") == true;
                    v61 = LocalPlayer.Character ~= nil and true or v62;
                end;
            end;

            if v61 then
                if not u14 then
                    u14 = true;
                    startBuyPeriodEffects();
                end;
            elseif u14 then
                u14 = false;
                u12 = u12 + 1;

                if u13 then
                    u13();
                    u13 = nil;
                end;
            end;
        elseif u14 then
            u14 = false;
            u12 = u12 + 1;

            if u13 then
                u13();
                u13 = nil;
            end;
        end;
    end;

    GameState.ListenToState(updateState);
    MenuState.OnScreenChanged:Connect(updateState);
    MenuState.OnInspectStateChanged:Connect(updateState);
    MenuState.OnCaseSceneStateChanged:Connect(updateState);
    LocalPlayer.CharacterAdded:Connect(updateState);
    LocalPlayer.CharacterRemoving:Connect(updateState);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(updateState);

    if GameState.GetState() == "Buy Period" then
        local v63;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v63 = false;
        else
            local MenuFrame = MenuState.GetMenuFrame();

            if MenuFrame and MenuFrame.Visible then
                v63 = false;
            else
                local v64 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v63 = LocalPlayer.Character ~= nil and true or v64;
            end;
        end;

        if v63 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u12 = u12 + 1;

            if u13 then
                u13();
                u13 = nil;
            end;
        end;
    elseif u14 then
        u14 = false;
        u12 = u12 + 1;

        if u13 then
            u13();
            u13 = nil;
        end;
    end;
end;

return v3;