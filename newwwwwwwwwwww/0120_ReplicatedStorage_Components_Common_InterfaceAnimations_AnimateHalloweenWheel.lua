-- AnimateHalloweenWheel (ModuleScript)
-- full path: ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateHalloweenWheel

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GuiShown = require(script.Parent.GuiShown);
local Vector2_new_ret = Vector2.new(0.4986, 0.497);
local u1 = { 359.4, 44.6, 89.5, 134.2, 179.1, 224.3, 269.4, 314.3 };
local u2 = { 0.8, 23.4, 46.3, 68.6, 90.9, 113.1, 134.6, 156.7, 179.2, 202.1, 224, 246.3, 269, 292, 314.6, 337.7 };

local function centreFromPivot(p3: number, p4: number) -- Line: 115
    local math_rad_ret = math.rad(p3);

    return Vector2.new(-math.sin(math_rad_ret), (math.cos(math_rad_ret))) * p4;
end;

local function restCentre(p5: userdata, p6) -- Line: 123
    local Parent = p5.Parent;
    local AbsoluteSize = Parent.AbsoluteSize;
    local AbsoluteSize2 = p5.AbsoluteSize;
    local Vector2_new_ret2 = Vector2.new(p6.X.Scale * AbsoluteSize.X + p6.X.Offset, p6.Y.Scale * AbsoluteSize.Y + p6.Y.Offset);

    return Parent.AbsolutePosition + Vector2_new_ret2 + (Vector2.new(0.5, 0.5) - p5.AnchorPoint) * AbsoluteSize2;
end;

local function wrapDegrees(p7: number) -- Line: 137
    return (p7 + 180) % 360 - 180;
end;

local function landingCurve(p8: number, p9: number) -- Line: 148
    local v10 = p9 - 1;
    local v11 = 1 - p8;

    return (v10 + 2) / 2 * (1 - v11 ^ (v10 + 1) - v10 / (v10 + 2) * (1 - v11 ^ (v10 + 2)));
end;

local function glide(p12: number) -- Line: 159
    if p12 >= 0.3333333333333333 then
        return (1 - (1 - (p12 - 0.3333333333333333) * 1.5) ^ 3) * 0.5 + 0.5;
    end;

    local v13 = p12 * 1.5;

    return v13 * v13 * (3 - v13 * 2);
end;

local u14 = { "Normal", "ForwardBait", "BackwardBait" };

return function(p15: any, u16: boolean?, u17: boolean?) -- Line: 185
    -- upvalues: Vector2_new_ret (copy), u1 (copy), restCentre (copy), u2 (copy), Router (copy), GuiService (copy), RunServiceController (copy), GuiShown (copy), u14 (copy)
    local Spinner = p15.Spinner;
    local Pointer = p15.Pointer;
    local Glow = p15.Glow;
    local u18 = Vector2_new_ret - Vector2.new(0.5, 0.5);
    local u19 = {};

    for _, child in Spinner:GetChildren() do
        if child:IsA("GuiObject") then
            local Position = child.Position;
            local Vector2_new_ret2 = Vector2.new(Position.X.Scale - 0.5, Position.Y.Scale - 0.5);
            local math_atan2_ret = math.atan2(Vector2_new_ret2.X, -Vector2_new_ret2.Y);
            local math_deg_ret = math.deg(math_atan2_ret);
            local v20 = u1[1];
            local v21 = child;

            for _, v in u1 do
                if math.abs((v - math_deg_ret + 180) % 360 - 180) < math.abs((v20 - math_deg_ret + 180) % 360 - 180) then
                    v20 = v;
                end;
            end;

            local math_rad_ret = math.rad(v20);
            local Magnitude = Vector2_new_ret2.Magnitude;
            v21.Rotation = v20;
            v21.Position = UDim2.fromScale(Vector2_new_ret.X + math.sin(math_rad_ret) * Magnitude, Vector2_new_ret.Y - math.cos(math_rad_ret) * Magnitude);
            table.insert(u19, v21);
        end;
    end;

    local u22 = 360 / math.max(#u19, 1);
    local Position = Spinner.Position;
    local Rotation = Pointer.Rotation;
    local Size = Pointer.Size;
    local u23 = Pointer.Position - UDim2.new(0, 0, 0.14 * Size.Y.Scale, 0.14 * Size.Y.Offset);
    Pointer.Position = u23;
    local ImageTransparency = Glow.ImageTransparency;
    local Random_new_ret = Random.new();
    local Rotation2 = Spinner.Rotation;
    local u24 = 0;
    local u25 = 0;
    local u26 = true;
    local u27 = false;
    local u28 = 0;
    local u29 = os.clock() + 6;
    local u30 = "Idle";
    local u31 = 12;
    local u32 = 0;
    local u33 = 0;
    local u34 = 0;
    local u35 = 0;
    local u36 = 0;
    local u37 = 1;
    local u38 = 0;
    local u39 = 0;
    local u40 = 0;
    local u41 = 0;
    local u42 = 1;

    local function isLanding() -- Line: 251
        -- upvalues: u30 (ref)
        return (u30 == "Landing" or u30 == "Creep") and true or u30 == "RollBack";
    end;

    local u43 = nil;
    local u44 = nil;
    local u45 = false;

    local function wheelCentre() -- Line: 259
        -- upvalues: restCentre (ref), Spinner (copy), Position (copy), u18 (copy)
        return restCentre(Spinner, Position) + u18 * Spinner.AbsoluteSize;
    end;

    local function measureFlapper() -- Line: 274
        -- upvalues: Spinner (copy), Pointer (copy), restCentre (ref), Position (copy), u18 (copy), u23 (copy), Rotation (copy)
        local X = Spinner.AbsoluteSize.X;
        local Y = Pointer.AbsoluteSize.Y;

        if X <= 0 or Y <= 0 then
            return nil;
        end;

        local v46 = restCentre(Spinner, Position) + u18 * Spinner.AbsoluteSize;
        local v47 = restCentre(Pointer, u23);
        local math_rad_ret = math.rad(Rotation);
        local v48 = v47 - Vector2.new(-math.sin(math_rad_ret), (math.cos(math_rad_ret))) * (0.31 * Y);
        local v49 = 0.4689 * X;
        local v50 = 0.0185 * X;
        local v51 = v46.Y - v49 - v48.Y + 0 * v50;

        if v51 <= 0 then
            return nil;
        end;

        local v52 = math.max(0.43 * (0.7250000000000001 - v51 / Y), 0) * Y;

        return {
            Centre = v46,
            Pivot = v48,
            RingRadius = v49,
            PegRadius = v50,
            Reach = v51,
            EdgeAngle = math.atan2(v52, v51)
        };
    end;

    local function pegContact(p53: table, p54: number) -- Line: 304
        local math_rad_ret = math.rad(p54);
        local v55 = p53.Centre + Vector2.new(math.sin(math_rad_ret), -math.cos(math_rad_ret)) * p53.RingRadius - p53.Pivot;
        local Magnitude = v55.Magnitude;
        local Reach = p53.Reach;
        local PegRadius = p53.PegRadius;

        if Magnitude <= 0 or PegRadius <= math.abs(Magnitude - Reach) then
            return false, 0, 0;
        end;

        local EdgeAngle = p53.EdgeAngle;
        local math_clamp_ret = math.clamp((Magnitude * Magnitude + Reach * Reach - PegRadius * PegRadius) / (2 * Magnitude * Reach), -1, 1);
        local v56 = EdgeAngle + math.acos(math_clamp_ret);

        return true, math.atan2(v55.X, v55.Y), v56;
    end;

    local function pegWindow() -- Line: 319
        -- upvalues: measureFlapper (copy), pegContact (copy)
        local v57 = measureFlapper();

        if not v57 then
            return 4, 8.1;
        end;

        local v58 = 4;

        for i = 450, 0, -1 do
            local v59, v60, v61 = pegContact(v57, -i / 10);

            if v59 and math.abs(v60) < v61 then
                v58 = i / 10;
                break;
            end;

            local _ = i;
        end;

        for i = 0, 450 do
            if not pegContact(v57, i / 10) then
                return v58, i / 10;
            end;

            local _ = i;
        end;

        return v58, 8.1;
    end;

    local function pegNear(p62: number, p63: number) -- Line: 342
        -- upvalues: u2 (ref)
        local v64 = u2[1];

        for _, v in u2 do
            if math.abs((v - p63 + 180) % 360 - 180) < math.abs((v64 - p63 + 180) % 360 - 180) then
                v64 = v;
            end;
        end;

        return p62 + ((v64 - p62 + 180) % 360 - 180);
    end;

    local function landingFor(p65: userdata, p66: string) -- Line: 358
        -- upvalues: pegNear (copy), u22 (copy), pegWindow (copy), Random_new_ret (copy)
        local Rotation3 = p65.Rotation;
        local v67 = pegNear(Rotation3, Rotation3 + u22 / 2);
        local v68 = pegNear(Rotation3, Rotation3);
        local v69 = pegNear(Rotation3, Rotation3 - u22 / 2);
        local v70, v71 = pegWindow();

        if p66 == "Showcase" then
            return -(v68 - v71 - 2.4), 0, 0, 0;
        end;

        if p66 == "ForwardBait" then
            return -(v67 - v71 + 1), 0, 1.5, 1.2;
        end;

        if p66 == "BackwardBait" then
            local v72 = v69 - v71 + 1;

            return -v72, v69 + v70 + 2.5 - v72, 0, 0;
        end;

        local v73 = v69 + v70 + 1;
        local math_max_ret = math.max(v68 - v71 - 1 - v73, 0);
        local v74 = v68 + v70 + 1;
        local math_max_ret2 = math.max(v67 - v71 - 1 - v74, 0);
        local v75 = Random_new_ret:NextNumber() * (math_max_ret + math_max_ret2);
        local v76;

        if v75 < math_max_ret then
            v76 = v73 + v75;
        else
            v76 = v74 + v75 - math_max_ret;
        end;

        return -v76, 0, 0, 0;
    end;

    local function beginLanding(p77: number, p78: userdata, p79: function?, p80: string) -- Line: 385
        -- upvalues: landingFor (copy), u31 (ref), Rotation2 (ref), u30 (ref), u34 (ref), u35 (ref), u36 (ref), u38 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref), u44 (ref), u45 (ref), u43 (ref)
        local v81, v82, v83, v84 = landingFor(p78, p80);
        local math_max_ret = math.max(u31, 12);
        local v85 = math_max_ret * 2 * 4.5 / 5;
        local v86 = v85 + (v81 - (Rotation2 + v85)) % 360;
        u30 = "Landing";
        u34 = Rotation2;
        u35 = v86;
        u36 = p77;
        u38 = v82;
        u37 = v86 * 5 / (math_max_ret * 2 + 3 * v83);
        u40 = v83;
        u41 = v84;
        u42 = v83 <= 0 and 1 or 2 * v84 / v83;
        u44 = p79;
        u45 = p80 == "Showcase";
        u43 = nil;
    end;

    local function placeSpinner() -- Line: 407
        -- upvalues: Spinner (copy), Rotation2 (ref), u18 (copy), Position (copy)
        local AbsoluteSize = Spinner.Parent.AbsoluteSize;
        local math_rad_ret = math.rad(Rotation2);
        local math_cos_ret = math.cos(math_rad_ret);
        local math_sin_ret = math.sin(math_rad_ret);
        local v87 = u18 * Spinner.AbsoluteSize;
        local v88 = v87 - Vector2.new(v87.X * math_cos_ret - v87.Y * math_sin_ret, v87.X * math_sin_ret + v87.Y * math_cos_ret);
        Spinner.Rotation = Rotation2 % 360;

        if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
            Spinner.Position = Position + UDim2.fromScale(v88.X / AbsoluteSize.X, v88.Y / AbsoluteSize.Y);
        end;
    end;

    local function finishLandingNow() -- Line: 420
        -- upvalues: u43 (ref), landingFor (copy), Rotation2 (ref), u44 (ref), u30 (ref), u34 (ref), u35 (ref), u38 (ref), u41 (ref), placeSpinner (copy), u31 (ref), u33 (ref)
        if u43 then
            local v89, v90, _, v91 = landingFor(u43.Slice, u43.Style);
            Rotation2 = v89 - v90 + v91;
            u44 = u43.OnLanded;
            u43 = nil;
        elseif (u30 == "Landing" or u30 == "Creep") and true or u30 == "RollBack" then
            Rotation2 = u34 + u35 - u38 + u41;
        end;

        placeSpinner();
        u30 = "Hold";
        u31 = 0;
        u33 = os.clock() + 1;
        local v92 = u44;
        u44 = nil;

        if v92 then
            task.defer(v92);
        end;
    end;

    local function settle(p93: number) -- Line: 442
        -- upvalues: u30 (ref), u31 (ref), u45 (ref), u33 (ref), u44 (ref)
        u30 = u45 and "Idle" or "Hold";
        u31 = 0;
        u33 = p93 + 1;
        local v94 = u44;
        u44 = nil;

        if v94 then
            task.spawn(v94);
        end;
    end;

    local function advance(p95: number, p96: number) -- Line: 452
        -- upvalues: u30 (ref), u31 (ref), Rotation2 (ref), u43 (ref), u32 (ref), beginLanding (copy), u36 (ref), u37 (ref), u40 (ref), u34 (ref), u35 (ref), u41 (ref), u38 (ref), u39 (ref), u45 (ref), u33 (ref), u44 (ref), u42 (ref), u16 (copy), u29 (ref), u19 (copy), Random_new_ret (copy)
        if u30 == "SpinUp" then
            u31 = u31 + (720 - u31) * (1 - math.exp(p96 * -4));
            Rotation2 = Rotation2 + u31 * p96;

            if u43 and (u31 >= 684 and p95 - u32 >= 0.8) then
                beginLanding(p95, u43.Slice, u43.OnLanded, u43.Style);
            end;

            return;
        end;

        if u30 == "Landing" then
            local math_min_ret = math.min((p95 - u36) / u37, 1);
            local v97 = u40 * u37;
            local v98 = 1 - math_min_ret;
            Rotation2 = u34 + (u35 - v97) * ((1 - v98 ^ 4 - (1 - v98 ^ 5) * 0.6) * 2.5) + v97 * math_min_ret;

            if math_min_ret == 1 then
                if u41 > 0 then
                    u30 = "Creep";

                    return;
                end;

                if u38 > 0 then
                    u30 = "RollBack";
                    u39 = p95 + 0.1;

                    return;
                end;

                u30 = u45 and "Idle" or "Hold";
                u31 = 0;
                u33 = p95 + 1;
                local v99 = u44;
                u44 = nil;

                if v99 then
                    task.spawn(v99);
                end;
            end;

            return;
        end;

        if u30 == "Creep" then
            local math_clamp_ret = math.clamp((p95 - u36 - u37) / u42, 0, 1);
            Rotation2 = u34 + u35 + u41 * (1 - (1 - math_clamp_ret) ^ 2);

            if math_clamp_ret == 1 then
                u30 = u45 and "Idle" or "Hold";
                u31 = 0;
                u33 = p95 + 1;
                local v100 = u44;
                u44 = nil;

                if v100 then
                    task.spawn(v100);
                end;
            end;

            return;
        end;

        if u30 ~= "RollBack" then
            if u30 == "Hold" then
                if u33 <= p95 then
                    u30 = "Idle";
                end;

                return;
            end;

            u31 = u31 + (12 - u31) * (1 - math.exp(p96 * -1.5));
            Rotation2 = Rotation2 + u31 * p96;

            if u16 and (u29 <= p95 and #u19 > 0) then
                u30 = "SpinUp";
                u32 = p95;
                u43 = {
                    Style = "Showcase",
                    Slice = u19[Random_new_ret:NextInteger(1, #u19)],

                    OnLanded = function() -- Line: 508, Name: OnLanded
                        -- upvalues: u29 (ref)
                        u29 = os.clock() + 6;
                    end
                };
            end;

            return;
        end;

        local math_clamp_ret = math.clamp((p95 - u39) / 1.5, 0, 1);
        local v101;

        if math_clamp_ret < 0.3333333333333333 then
            local v102 = math_clamp_ret * 1.5;
            v101 = v102 * v102 * (3 - v102 * 2);
        else
            v101 = (1 - (1 - (math_clamp_ret - 0.3333333333333333) * 1.5) ^ 3) * 0.5 + 0.5;
        end;

        Rotation2 = u34 + u35 - u38 * v101;

        if math_clamp_ret == 1 then
            u30 = u45 and "Idle" or "Hold";
            u31 = 0;
            u33 = p95 + 1;
            local v103 = u44;
            u44 = nil;

            if v103 then
                task.spawn(v103);
            end;
        end;
    end;

    local function placePointer() -- Line: 518
        -- upvalues: Rotation (copy), u24 (ref), Pointer (copy), u23 (copy)
        local v104 = Rotation - math.deg(u24);
        local v105 = 0.31 * Pointer.AbsoluteSize.Y;
        local math_rad_ret = math.rad(v104);
        local v106 = Vector2.new(-math.sin(math_rad_ret), (math.cos(math_rad_ret))) * v105;
        local math_rad_ret2 = math.rad(Rotation);
        local v107 = v106 - Vector2.new(-math.sin(math_rad_ret2), (math.cos(math_rad_ret2))) * v105;
        Pointer.Rotation = v104;
        Pointer.Position = u23 + UDim2.fromOffset(v107.X, v107.Y);
    end;

    local function onPegReleased() -- Line: 528
        -- upvalues: u17 (copy), u30 (ref), u28 (ref), Router (ref)
        if not (u17 and (u30 == "SpinUp" or (u30 == "Landing" or u30 == "Creep" or u30 == "RollBack"))) then
            return;
        end;

        local os_clock_ret = os.clock();

        if os_clock_ret - u28 >= 0.035 then
            u28 = os_clock_ret;
            Router.broadcastRouter("RunInterfaceSound", "Halloween Wheel Tick");
        end;
    end;

    local function simulatePointer(p108: number, p109: number) -- Line: 545
        -- upvalues: measureFlapper (copy), Rotation2 (ref), u24 (ref), u25 (ref), u2 (ref), pegContact (copy), u27 (ref), u17 (copy), u30 (ref), u28 (ref), Router (ref), u26 (ref), Rotation (copy), Pointer (copy), u23 (copy)
        local v110 = measureFlapper();

        if not v110 or p109 <= 0 then
            return false;
        end;

        local v111 = Rotation2 - p108;
        local math_ceil_ret = math.ceil(p109 / 0.004166666666666667);
        local v112 = math.abs(v111) / 1;
        local math_ceil_ret2 = math.ceil(v112);
        local math_max_ret = math.max(math_ceil_ret, math_ceil_ret2);
        local math_clamp_ret = math.clamp(math_max_ret, 1, 240);
        local v113 = p109 / math_clamp_ret;
        local v114 = false;

        for i = 1, math_clamp_ret do
            local v115 = p108 + v111 * i / math_clamp_ret;
            local v116 = u24;
            u25 = u25 + (u24 * -1024 - u25 * 20.48) * v113;
            u24 = u24 + u25 * v113;
            local _ = i;
            local v117 = false;

            for _, v in u2 do
                local v118 = (v115 + v + 180) % 360 - 180;

                if math.abs(v118) <= 90 then
                    local v119, v120, v121 = pegContact(v110, v118);

                    if v119 and math.abs(u24 - v120) < v121 then
                        v117 = true;
                        local v122;

                        if v120 <= v116 then
                            v122 = v120 + v121;
                        else
                            v122 = v120 - v121;
                        end;

                        u24 = v122;
                    end;
                end;
            end;

            if v117 then
                v114 = true;
                u25 = math.clamp((u24 - v116) / v113, -26.17993877991494, 26.17993877991494);
            elseif u27 and u17 and (u30 == "SpinUp" or (u30 == "Landing" or u30 == "Creep" or u30 == "RollBack")) then
                local os_clock_ret = os.clock();

                if os_clock_ret - u28 >= 0.035 then
                    u28 = os_clock_ret;
                    Router.broadcastRouter("RunInterfaceSound", "Halloween Wheel Tick");
                end;
            end;

            u27 = v117;
        end;

        if not (v114 or (math.abs(u24) >= 0.00034906585039886593 or math.abs(u25) >= 0.00034906585039886593)) then
            u24 = 0;
            u25 = 0;

            if not u26 then
                u26 = true;
                local v123 = Rotation - math.deg(u24);
                local v124 = 0.31 * Pointer.AbsoluteSize.Y;
                local math_rad_ret = math.rad(v123);
                local v125 = Vector2.new(-math.sin(math_rad_ret), (math.cos(math_rad_ret))) * v124;
                local math_rad_ret2 = math.rad(Rotation);
                local v126 = v125 - Vector2.new(-math.sin(math_rad_ret2), (math.cos(math_rad_ret2))) * v124;
                Pointer.Rotation = v123;
                Pointer.Position = u23 + UDim2.fromOffset(v126.X, v126.Y);
            end;

            return false;
        end;

        u26 = false;
        local v127 = Rotation - math.deg(u24);
        local v128 = 0.31 * Pointer.AbsoluteSize.Y;
        local math_rad_ret = math.rad(v127);
        local v129 = Vector2.new(-math.sin(math_rad_ret), (math.cos(math_rad_ret))) * v128;
        local math_rad_ret2 = math.rad(Rotation);
        local v130 = v129 - Vector2.new(-math.sin(math_rad_ret2), (math.cos(math_rad_ret2))) * v128;
        Pointer.Rotation = v127;
        Pointer.Position = u23 + UDim2.fromOffset(v130.X, v130.Y);

        return true;
    end;

    local u131 = true;

    local function step(p132: number) -- Line: 611
        -- upvalues: GuiService (ref), Rotation2 (ref), advance (copy), placeSpinner (copy), u131 (ref), simulatePointer (copy), Glow (copy), ImageTransparency (copy)
        if GuiService.ReducedMotionEnabled then
            return;
        end;

        local os_clock_ret = os.clock();
        local v133 = Rotation2;
        advance(os_clock_ret, p132);
        placeSpinner();

        if u131 or Rotation2 ~= v133 then
            u131 = simulatePointer(v133, p132);
        end;

        local v134 = (1 - math.cos(os_clock_ret * 2 * 3.141592653589793 / 2.5)) / 2;
        Glow.ImageTransparency = ImageTransparency + (1 - ImageTransparency) * 0.35 * v134;
    end;

    local u135 = RunServiceController.CreateBindingName("UI.HalloweenWheel");
    local u136 = nil;
    local u137 = false;

    local function isMidSpin() -- Line: 634
        -- upvalues: u43 (ref), u30 (ref)
        return (u43 ~= nil or (u30 == "SpinUp" or (u30 == "Landing" or u30 == "Creep"))) and true or u30 == "RollBack";
    end;

    local function stepWhileNeeded(p138: number) -- Line: 642
        -- upvalues: step (copy), u137 (ref), u43 (ref), u30 (ref), u136 (ref)
        step(p138);

        if not (u137 or (u43 ~= nil or (u30 == "SpinUp" or (u30 == "Landing" or u30 == "Creep")) or u30 == "RollBack" or not u136)) then
            u136:Disconnect();
            u136 = nil;
        end;
    end;

    GuiShown.Observe(p15, function(p139: boolean) -- Line: 650
        -- upvalues: u137 (ref), u136 (ref), RunServiceController (ref), u135 (copy), stepWhileNeeded (copy), u43 (ref), u30 (ref)
        u137 = p139;

        if p139 then
            if not u136 then
                u136 = RunServiceController.BindToRenderStep(u135, stepWhileNeeded);
            end;
        elseif u136 and (u43 == nil and (u30 ~= "SpinUp" and (u30 ~= "Landing" and u30 ~= "Creep")) and u30 ~= "RollBack") then
            u136:Disconnect();
            u136 = nil;
        end;
    end);
    local u141 = {
        GetSlices = function() -- Line: 668, Name: GetSlices
            -- upvalues: Spinner (copy)
            local v140 = {};

            for _, child in Spinner:GetChildren() do
                if child:IsA("GuiObject") then
                    table.insert(v140, child);
                end;
            end;

            return v140;
        end,

        Spin = function() -- Line: 679, Name: Spin
            -- upvalues: u30 (ref), u32 (ref)
            if u30 == "SpinUp" or (u30 == "Landing" or u30 == "Creep" or u30 == "RollBack") then
                return;
            end;

            u30 = "SpinUp";
            u32 = os.clock();
        end
    };

    function u141.LandOn(p142: userdata, p143: function?, p144: string?) -- Line: 689
        -- upvalues: u14 (ref), Random_new_ret (copy), u43 (ref), GuiService (ref), u136 (ref), finishLandingNow (copy), u30 (ref), u141 (copy)
        u43 = {
            Slice = p142,
            OnLanded = p143,
            Style = p144 or u14[Random_new_ret:NextInteger(1, #u14)]
        };

        if GuiService.ReducedMotionEnabled or not u136 then
            finishLandingNow();

            return;
        end;

        if u30 ~= "SpinUp" then
            u141.Spin();
        end;
    end;

    function u141.Stop() -- Line: 700
        -- upvalues: u30 (ref), u43 (ref)
        if u30 == "SpinUp" then
            u30 = "Idle";
        end;

        u43 = nil;
    end;

    function u141.IsSpinning() -- Line: 708
        -- upvalues: u30 (ref)
        return (u30 == "SpinUp" or (u30 == "Landing" or u30 == "Creep")) and true or u30 == "RollBack";
    end;

    return u141;
end;