-- ReplicatedStorage.Controllers.Observers.Game.ElectricShort
-- Script path: ReplicatedStorage.Controllers.Observers.Game.ElectricShort
-- Decompile time: 12.82 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Color3_fromRGB_ret = Color3.fromRGB(255, 175, 70);
local Color3_fromRGB_ret2 = Color3.fromRGB(150, 28, 6);
local u1 = {};
local u2 = nil;
local Random_new_ret = Random.new();
local u3 = false;

local function isNearCamera(p4: vector) -- Line: 67
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local v5;

    if CurrentCamera == nil then
        v5 = false;
    else
        v5 = (CurrentCamera.CFrame.Position - p4).Magnitude < 250;
    end;

    return v5;
end;

local function stepShorts(p6: number) -- Line: 74
    -- upvalues: u1 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    local math_exp_ret = math.exp(-p6 * 26);
    local math_exp_ret2 = math.exp(-p6 * 0.8);

    for _, v in u1 do
        if not (v.Idle and (v.Flash <= 0.001 and v.Heat <= 0.001)) then
            v.Flash = v.Flash * math_exp_ret;
            v.Heat = v.Heat * math_exp_ret2;

            if v.Flash < 0.001 and v.Heat < 0.001 then
                v.Flash = 0;
                v.Heat = 0;
                v.Idle = true;
            else
                v.Idle = false;
            end;

            local Heat = v.Heat;
            v.ArcLight.Brightness = v.BaseBrightness * v.Flash;
            v.HotLight.Brightness = Heat * 1.2;
            local Glow = v.Glow;
            local v7 = Heat > 0.05;

            if Glow.Enabled ~= v7 then
                Glow.Enabled = v7;
            end;

            if v7 then
                local v8 = math.clamp(Heat, 0, 1) * 50 + 0.5;
                local v9 = math.floor(v8) / 50;

                if v9 ~= v.GlowStep then
                    v.GlowStep = v9;
                    Glow.Color = ColorSequence.new(Color3_fromRGB_ret2:Lerp(Color3_fromRGB_ret, v9));
                    Glow.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4, 1 - v9 * 0.9), NumberSequenceKeypoint.new(1, 1) });
                end;
            end;
        end;
    end;
end;

local function ensureHeartbeat() -- Line: 116
    -- upvalues: u2 (ref), RunServiceController (copy), stepShorts (copy)
    if u2 then
        return;
    end;

    u2 = RunServiceController.BindToHeartbeat("Observers.Game.ElectricShort.Update", stepShorts);
end;

local function stopHeartbeatIfIdle() -- Line: 125
    -- upvalues: u1 (copy), u2 (ref)
    if next(u1) == nil and u2 then
        u2:Disconnect();
        u2 = nil;
    end;
end;

local function restoreShort(p10: table) -- Line: 134
    p10.ArcLight.Brightness = p10.AuthoredArcBrightness;
    p10.HotLight.Brightness = p10.AuthoredHotBrightness;
    p10.Glow.Enabled = p10.AuthoredGlowEnabled;
    p10.Glow.Color = p10.AuthoredGlowColor;
    p10.Glow.Transparency = p10.AuthoredGlowTransparency;
end;

local function waitForChild(p11: userdata, p12: string) -- Line: 145
    return p11:WaitForChild(p12, 10);
end;

local function runShort(u13: userdata, u14: table, p15: any) -- Line: 151
    -- upvalues: Sound (copy), Random_new_ret (copy), Workspace (copy)
    local Emit = u13:WaitForChild("Emit", 10);

    if Emit then
        Emit = Emit:WaitForChild("Sparks", 10);
    end;

    local PlasmaFlash = u13:WaitForChild("PlasmaFlash", 10);
    local Drips = u13:WaitForChild("Drips", 10);
    local SmokeWisp = u13:WaitForChild("SmokeWisp", 10);

    if not (Emit and (PlasmaFlash and (Drips and SmokeWisp))) then
        warn((`[ElectricShort] {u13:GetFullName()} is missing its emitters`));

        return;
    end;

    local u16 = {};

    for i = 0, 8 do
        local v17 = u13:WaitForChild(`ArcJ{i}`, 10);
        local v18;

        if v17 then
            table.insert(u16, v17);
            v18 = i;
        else
            v18 = i;
        end;
    end;

    local u19 = {};

    for i = 1, 8 do
        local v20 = u13:WaitForChild(`ArcSeg{i}`, 10);
        local v21;

        if v20 then
            table.insert(u19, v20);
            v21 = i;
        else
            v21 = i;
        end;
    end;

    local u22 = {};

    for i = 0, 2 do
        local v23 = u13:WaitForChild(`ArcK{i}`, 10);
        local v24;

        if v23 then
            table.insert(u22, v23);
            v24 = i;
        else
            v24 = i;
        end;
    end;

    local u25 = {};
    local v26 = u13:WaitForChild(`ArcBr{1}`, 10);

    if v26 then
        table.insert(u25, v26);
    end;

    local v27 = u13:WaitForChild(`ArcBr{2}`, 10);

    if v27 then
        table.insert(u25, v27);
    end;

    local u28 = {};

    for _, descendant in u13:GetDescendants() do
        if descendant:IsA("ParticleEmitter") and string.sub(descendant.Name, 1, 5) == "Burst" then
            table.insert(u28, descendant);
        end;
    end;

    local Impact = u13:FindFirstChild("Impact");
    local u29;

    if Impact then
        u29 = Impact:FindFirstChild("ImpactSparks");
    else
        u29 = Impact;
    end;

    if Impact then
        Impact = Impact:FindFirstChild("ImpactGlow");
    end;

    local string_split_ret = string.split(u13:GetAttribute("ArcSegTextures") or "", ",");
    local u30;

    if #u16 == 9 and (#u19 == 8 and (#u22 == 3 and #u25 == 2)) then
        u30 = string_split_ret[1] ~= "";
    else
        u30 = false;
    end;

    local Position = u13.Position;
    local v31 = u13:GetAttribute("Activity") or 1;
    local u32 = u13:GetAttribute("FloorDrop") or 0;
    local u33 = 0;
    local u34 = true;
    local Miscellaneous = Sound.new("Miscellaneous");
    local u35 = (-1 / 0);
    p15:Add(function() -- Line: 214
        -- upvalues: u34 (ref), u19 (copy), u25 (copy)
        u34 = false;

        for _, v in u19 do
            v.Enabled = false;
        end;

        for _, v in u25 do
            v.Enabled = false;
        end;
    end, true);

    local function randomTexture() -- Line: 224
        -- upvalues: string_split_ret (copy), Random_new_ret (ref)
        return string_split_ret[Random_new_ret:NextInteger(1, #string_split_ret)];
    end;

    local function setArcEnabled(p36: boolean) -- Line: 228
        -- upvalues: u19 (copy), u25 (copy)
        for _, v in u19 do
            v.Enabled = p36;
        end;

        if not p36 then
            for _, v in u25 do
                v.Enabled = false;
            end;
        end;
    end;

    local function arc(p37: number?) -- Line: 240
        -- upvalues: u30 (copy), u33 (ref), Random_new_ret (ref), Position (copy), u16 (copy), u19 (copy), string_split_ret (copy), u22 (copy), u25 (copy), u34 (ref)
        if not u30 then
            return;
        end;

        u33 = u33 + 1;
        local u38 = u33;
        local v39 = Random_new_ret:NextNumber(-1, 1);
        local v40 = Random_new_ret:NextNumber(-0.6, 1);
        local Unit = Vector3.new(v39, v40, Random_new_ret:NextNumber(-1, 1)).Unit;
        local v41 = Random_new_ret:NextNumber(0.5, 1.4);
        local v42 = Position + Unit * v41;
        local v43 = Unit:Cross(Vector3.new(0, 1, 0));

        if v43.Magnitude < 0.1 then
            v43 = Unit:Cross(Vector3.new(1, 0, 0));
        end;

        local Unit2 = v43.Unit;
        local v44 = Unit:Cross(Unit2);
        u16[1].WorldPosition = Position;
        local v45 = Random_new_ret:NextNumber() < 0.5 and 1 or -1;

        for i = 2, 8 do
            local v46 = (i - 1) / 8;

            if Random_new_ret:NextNumber() < 0.75 then
                v45 = -v45;
            end;

            local v47 = v41 * Random_new_ret:NextNumber(0.04, 0.15) * math.sin(3.141592653589793 * v46) ^ 0.5;
            u16[i].WorldPosition = Position:Lerp(v42, v46) + Unit2 * v45 * v47 + v44 * Random_new_ret:NextNumber(-1, 1) * v47 * 0.6;
            local _ = i;
        end;

        u16[9].WorldPosition = v42;

        for _, v in u19 do
            v.Texture = string_split_ret[Random_new_ret:NextInteger(1, #string_split_ret)];
            local v48 = Random_new_ret:NextNumber(0.08, 0.15);
            v.Width0 = v48;
            v.Width1 = v48 * Random_new_ret:NextNumber(0.75, 1);
        end;

        for _, v in u19 do
            v.Enabled = true;
        end;

        if Random_new_ret:NextNumber() < 0.6 then
            local WorldPosition = u16[Random_new_ret:NextInteger(2, 8)].WorldPosition;
            local Unit3 = (Unit + (Unit2 * Random_new_ret:NextNumber(-1, 1) + v44 * Random_new_ret:NextNumber(-1, 1)) * 1.2).Unit;
            u22[1].WorldPosition = WorldPosition;
            u22[2].WorldPosition = WorldPosition + Unit3 * v41 * Random_new_ret:NextNumber(0.15, 0.25) + v44 * Random_new_ret:NextNumber(-0.06, 0.06);
            u22[3].WorldPosition = u22[2].WorldPosition + Unit3 * v41 * Random_new_ret:NextNumber(0.12, 0.22) + Unit2 * Random_new_ret:NextNumber(-0.06, 0.06);

            for _, v in u25 do
                v.Texture = string_split_ret[Random_new_ret:NextInteger(1, #string_split_ret)];
                v.Width0 = Random_new_ret:NextNumber(0.04, 0.08);
                v.Width1 = v.Width0 * 0.7;
                v.Enabled = true;
            end;
        else
            for _, v in u25 do
                v.Enabled = false;
            end;
        end;

        task.delay(p37 or Random_new_ret:NextNumber(0.03, 0.08), function() -- Line: 301
            -- upvalues: u34 (ref), u33 (ref), u38 (copy), u19 (ref), u25 (ref)
            if u34 and u33 == u38 then
                for _, v in u19 do
                    v.Enabled = false;
                end;

                for _, v in u25 do
                    v.Enabled = false;
                end;
            end;
        end);
    end;

    local function crackle(p49: number, p50: boolean?) -- Line: 309
        -- upvalues: u35 (ref), Miscellaneous (copy), u13 (copy)
        local os_clock_ret = os.clock();

        if not p50 and os_clock_ret - u35 < 0.15 then
            return;
        end;

        u35 = os_clock_ret;
        Miscellaneous:play({
            Name = "Electricity Zap",
            Parent = u13
        }, p49);
    end;

    local function land(u51: number, u52: number) -- Line: 319
        -- upvalues: u29 (copy), Impact (copy), u32 (copy), u34 (ref), Random_new_ret (ref)
        if not (u29 and Impact) then
            return;
        end;

        if u51 > 0 and u32 < 13 then
            task.delay(math.sqrt(2 * u32 / 35) * 1.25 + 0.15, function() -- Line: 324
                -- upvalues: u34 (ref), u29 (ref), u51 (copy), Random_new_ret (ref), Impact (ref)
                if u34 then
                    local v53 = u51 * Random_new_ret:NextNumber(0.25, 0.45);
                    local math_floor_ret = math.floor(v53);
                    u29:Emit((math.max(1, math_floor_ret)));
                    Impact:Emit(Random_new_ret:NextInteger(1, 3));
                end;
            end);
        end;

        if u52 > 0 then
            task.delay(math.sqrt(2 * u32 / 30) * 1.1 + 0.1, function() -- Line: 332
                -- upvalues: u34 (ref), Impact (ref), u52 (copy), u29 (ref), Random_new_ret (ref)
                if u34 then
                    Impact:Emit(u52);
                    u29:Emit(u52 * Random_new_ret:NextInteger(2, 5));
                end;
            end);
        end;
    end;

    local function zap(p54: number, p55: number?, p56: number?) -- Line: 341
        -- upvalues: PlasmaFlash (copy), Random_new_ret (ref), u14 (copy), u35 (ref), Miscellaneous (copy), u13 (copy), Emit (copy), u29 (copy), Impact (copy), u32 (copy), u34 (ref), arc (copy)
        PlasmaFlash:Emit(1);
        local v57 = p54 * Random_new_ret:NextNumber(0.7, 1);
        u14.Flash = math.max(u14.Flash, v57);
        local os_clock_ret = os.clock();

        if os_clock_ret - u35 >= 0.15 then
            u35 = os_clock_ret;
            Miscellaneous:play({
                Name = "Electricity Zap",
                Parent = u13
            }, v57);
        end;

        u14.ArcLight.Color = Color3.fromRGB(Random_new_ret:NextInteger(175, 215), Random_new_ret:NextInteger(190, 222), 255);
        u14.Heat = math.min(1.2, u14.Heat + p54 * 0.1);

        if Random_new_ret:NextNumber() < 0.75 then
            local v58 = Random_new_ret:NextInteger(5, 22) * p54 * (p55 or 1) + 0.5;
            local math_floor_ret = math.floor(v58);
            Emit:Emit(math_floor_ret);

            if u29 and (Impact and (math_floor_ret > 0 and u32 < 13)) then
                task.delay(math.sqrt(2 * u32 / 35) * 1.25 + 0.15, function() -- Line: 324
                    -- upvalues: u34 (ref), u29 (ref), math_floor_ret (copy), Random_new_ret (ref), Impact (ref)
                    if u34 then
                        local v59 = math_floor_ret * Random_new_ret:NextNumber(0.25, 0.45);
                        local math_floor_ret2 = math.floor(v59);
                        u29:Emit((math.max(1, math_floor_ret2)));
                        Impact:Emit(Random_new_ret:NextInteger(1, 3));
                    end;
                end);
            end;
        end;

        if p56 or Random_new_ret:NextNumber() < 0.55 then
            arc(p56);
        end;
    end;

    local function burst() -- Line: 358
        -- upvalues: u28 (copy), Random_new_ret (ref), PlasmaFlash (copy), Emit (copy), u29 (copy), Impact (copy), u32 (copy), u34 (ref), arc (copy), u14 (copy), u35 (ref), Miscellaneous (copy), u13 (copy)
        if #u28 > 0 then
            u28[Random_new_ret:NextInteger(1, #u28)]:Emit(1);
        end;

        PlasmaFlash:Emit(1);
        local u60 = Random_new_ret:NextInteger(24, 50);
        Emit:Emit(u60);

        if u29 and (Impact and (u60 > 0 and u32 < 13)) then
            task.delay(math.sqrt(2 * u32 / 35) * 1.25 + 0.15, function() -- Line: 324
                -- upvalues: u34 (ref), u29 (ref), u60 (copy), Random_new_ret (ref), Impact (ref)
                if u34 then
                    local v61 = u60 * Random_new_ret:NextNumber(0.25, 0.45);
                    local math_floor_ret = math.floor(v61);
                    u29:Emit((math.max(1, math_floor_ret)));
                    Impact:Emit(Random_new_ret:NextInteger(1, 3));
                end;
            end);
        end;

        arc(Random_new_ret:NextNumber(0.05, 0.11));
        u14.Flash = Random_new_ret:NextNumber(1.1, 1.5);
        local Flash = u14.Flash;
        u35 = os.clock();
        Miscellaneous:play({
            Name = "Electricity Zap",
            Parent = u13
        }, Flash);
        u14.Heat = math.min(1.2, u14.Heat + 0.35);
    end;

    task.wait(Random_new_ret:NextNumber(0, 6));

    while true do
        local CurrentCamera = Workspace.CurrentCamera;
        local v62;

        if CurrentCamera == nil then
            v62 = false;
        else
            v62 = (CurrentCamera.CFrame.Position - Position).Magnitude < 250;
        end;

        if v62 then
            local v63;

            if Random_new_ret:NextNumber() < 0.2 then
                v63 = Random_new_ret:NextNumber(0.3, 1.2);
            else
                v63 = Random_new_ret:NextNumber(2, 9);
            end;

            local os_clock_ret = os.clock();

            while os.clock() - os_clock_ret < v63 / v31 do
                task.wait(Random_new_ret:NextNumber(0.4, 1.6));

                if Random_new_ret:NextNumber() < 0.18 then
                    local u64 = Random_new_ret:NextInteger(2, 6);
                    Emit:Emit(u64);

                    if u29 and (Impact and (u64 > 0 and u32 < 13)) then
                        task.delay(math.sqrt(2 * u32 / 35) * 1.25 + 0.15, function() -- Line: 324
                            -- upvalues: u34 (ref), u29 (copy), u64 (copy), Random_new_ret (ref), Impact (copy)
                            if u34 then
                                local v65 = u64 * Random_new_ret:NextNumber(0.25, 0.45);
                                local math_floor_ret = math.floor(v65);
                                u29:Emit((math.max(1, math_floor_ret)));
                                Impact:Emit(Random_new_ret:NextInteger(1, 3));
                            end;
                        end);
                    end;

                    u14.Flash = math.max(u14.Flash, 0.15);
                    local os_clock_ret2 = os.clock();

                    if os_clock_ret2 - u35 >= 0.15 then
                        u35 = os_clock_ret2;
                        Miscellaneous:play({
                            Name = "Electricity Zap",
                            Parent = u13
                        }, 0.15);
                    end;

                    if Random_new_ret:NextNumber() < 0.5 then
                        PlasmaFlash:Emit(1);
                    end;
                end;
            end;

            local v66 = Random_new_ret:NextNumber();

            if v66 < 0.35 then
                burst();

                if Random_new_ret:NextNumber() < 0.4 then
                    task.wait(Random_new_ret:NextNumber(0.06, 0.2));
                    zap(0.8);
                end;
            elseif v66 < 0.75 then
                if Random_new_ret:NextNumber() < 0.6 then
                    burst();
                end;

                for i = 1, Random_new_ret:NextInteger(3, 12) do
                    zap(Random_new_ret:NextNumber(0.35, 1));
                    task.wait(Random_new_ret:NextNumber(0.03, 0.17));
                    local _ = i;
                end;

                if Random_new_ret:NextNumber() < 0.35 then
                    burst();
                end;
            else
                burst();
                local v67 = Random_new_ret:NextNumber(0.3, 1.4);
                local os_clock_ret2 = os.clock();

                while os.clock() - os_clock_ret2 < v67 do
                    zap(Random_new_ret:NextNumber(0.5, 1), 0.35, 0.07);
                    task.wait(Random_new_ret:NextNumber(0.02, 0.06));
                end;

                if Random_new_ret:NextNumber() < 0.5 then
                    burst();
                end;
            end;

            if Random_new_ret:NextNumber() < 0.75 then
                SmokeWisp:Emit(Random_new_ret:NextInteger(1, 2));
            end;

            if u14.Heat > 0.4 and Random_new_ret:NextNumber() < 0.6 then
                local u68 = Random_new_ret:NextInteger(1, 4);
                Drips:Emit(u68);

                if u29 and (Impact and u68 > 0) then
                    task.delay(math.sqrt(2 * u32 / 30) * 1.1 + 0.1, function() -- Line: 332
                        -- upvalues: u34 (ref), Impact (copy), u68 (copy), u29 (copy), Random_new_ret (ref)
                        if u34 then
                            Impact:Emit(u68);
                            u29:Emit(u68 * Random_new_ret:NextInteger(2, 5));
                        end;
                    end);
                end;
            end;
        else
            task.wait(1);
        end;
    end;
end;

return Observers.observeTag("ElectricShort", function(u69: userdata) -- Line: 443
    -- upvalues: GraphicsQualityController (copy), Janitor (copy), u1 (copy), u2 (ref), RunServiceController (copy), stepShorts (copy), u3 (ref), Sound (copy), runShort (copy)
    return GraphicsQualityController.RunAnimatedProp(function() -- Line: 445
        -- upvalues: Janitor (ref), u69 (copy), u1 (ref), u2 (ref), RunServiceController (ref), stepShorts (ref), u3 (ref), Sound (ref), runShort (ref)
        local u70 = Janitor.new();
        u70:Add(task.spawn(function() -- Line: 448
            -- upvalues: u69 (ref), u1 (ref), u2 (ref), RunServiceController (ref), stepShorts (ref), u3 (ref), Sound (ref), u70 (copy), runShort (ref)
            local ArcLight = u69:WaitForChild("ArcLight", 10);
            local HotLight = u69:WaitForChild("HotLight", 10);
            local HotGlow = u69:WaitForChild("HotGlow", 10);

            if not (ArcLight and (HotLight and HotGlow)) then
                warn((`[ElectricShort] {u69:GetFullName()} is missing ArcLight, HotLight or HotGlow`));

                return;
            end;

            local u71 = {
                Flash = 0,
                Heat = 0,
                Idle = false,
                GlowStep = -1,
                ArcLight = ArcLight,
                HotLight = HotLight,
                Glow = HotGlow,
                BaseBrightness = ArcLight:GetAttribute("BaseBrightness") or 5,
                AuthoredArcBrightness = ArcLight.Brightness,
                AuthoredHotBrightness = HotLight.Brightness,
                AuthoredGlowEnabled = HotGlow.Enabled,
                AuthoredGlowColor = HotGlow.Color,
                AuthoredGlowTransparency = HotGlow.Transparency
            };
            u1[u69] = u71;

            if not u2 then
                u2 = RunServiceController.BindToHeartbeat("Observers.Game.ElectricShort.Update", stepShorts);
            end;

            if not u3 then
                u3 = true;
                task.spawn(Sound.WarmPersistentSound, "Miscellaneous", "Electricity Zap");
            end;

            u70:Add(function() -- Line: 479
                -- upvalues: u1 (ref), u69 (ref), u71 (copy), u2 (ref)
                u1[u69] = nil;
                local v72 = u71;
                v72.ArcLight.Brightness = v72.AuthoredArcBrightness;
                v72.HotLight.Brightness = v72.AuthoredHotBrightness;
                v72.Glow.Enabled = v72.AuthoredGlowEnabled;
                v72.Glow.Color = v72.AuthoredGlowColor;
                v72.Glow.Transparency = v72.AuthoredGlowTransparency;

                if next(u1) == nil and u2 then
                    u2:Disconnect();
                    u2 = nil;
                end;
            end, true);
            runShort(u69, u71, u70);
        end), true);

        return function() -- Line: 488
            -- upvalues: u70 (copy)
            u70:Destroy();
        end;
    end);
end, { Workspace });