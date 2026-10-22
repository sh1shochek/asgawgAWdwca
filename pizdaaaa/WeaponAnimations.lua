-- ReplicatedStorage.GameClient.WeaponController.WeaponAnimations
-- Script path: ReplicatedStorage.GameClient.WeaponController.WeaponAnimations
-- Decompile time: 3.93 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;

function v1.PlayAnimation(p5: table, p6: string, p7: boolean, p8: number?) -- Line: 18
    -- upvalues: u3 (ref), u4 (ref), u2 (ref)
    local v9 = p6:gsub("%d+$", "");
    local v10 = u3.RollVariant(p5, p6);
    local v11 = u3.StartTrack(p5, v10, v9, p7);

    if v11 then
        v11.Track.StartFadeTime = p8 or 0;
        local v12 = v9 == "Equip" and v11.Events.equip == nil and u4.GetWeaponSound(p5.Data.Type == "Melee" and "Knife" or p5.Name, "equip");

        if v12 then
            u4.Play(v12);
        end;

        u2.PlayAnimatedTint(p5, v9);
        p5.CurrentAnimator = v11;
        p5.CurrentAnimationName = v10;

        return v11;
    end;
end;

function v1.IsPlayingFire(p13) -- Line: 55
    local CurrentAnimationName = p13.CurrentAnimationName;
    local v14;

    if CurrentAnimationName == nil or (CurrentAnimationName:sub(1, 4) ~= "Fire" or p13.CurrentAnimator == nil) then
        v14 = false;
    else
        v14 = p13.CurrentAnimator.Playing;
    end;

    return v14;
end;

function v1.ReverseAnimation(p15: table, p16: string) -- Line: 60
    -- upvalues: u3 (ref)
    local v17, v18 = u3.ReverseTrack(p15, p16);

    if v17 then
        p15.CurrentAnimator = v17;
        p15.CurrentAnimationName = v18;

        return v17;
    end;
end;

function v1.StopAnimation(p19: table, p20: string) -- Line: 73
    -- upvalues: u3 (ref), u2 (ref)
    local v21 = u3.StopTrack(p19, p20);

    if v21 then
        u2.ResetPose(p19);

        if p19.CurrentAnimator == v21 then
            p19.CurrentAnimator = nil;
            p19.CurrentAnimationName = nil;
        end;

        return v21;
    end;
end;

function v1.StopAllAnimations(p22: table, p23: string?) -- Line: 90
    -- upvalues: u3 (ref), u2 (ref)
    if not u3.StopAllTracks(p22, p23) then
        return;
    end;

    u2.ResetPose(p22);
    p22.CurrentAnimator = nil;
    p22.CurrentAnimationName = nil;
end;

function v1.Init(p24) -- Line: 115
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    u2 = p24:GetModule("Viewmodel");
    u3 = p24:GetModule("AnimationManager");
    u4 = p24:GetModule("SoundManager");
end;

return v1;