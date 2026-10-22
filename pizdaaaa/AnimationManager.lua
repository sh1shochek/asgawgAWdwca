-- ReplicatedStorage.Shared.Managers.AnimationManager
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager
-- Decompile time: 18.18 ms

-- Decompiled with Potassium's decompiler.

local script_Rigs = script.Rigs;
local u1 = {};
local u2 = {};

local function IsRigModule(p3: userdata, p4: userdata) -- Line: 28
    local Parent = p3.Parent;

    while Parent and Parent ~= p4 do
        if not Parent:IsA("Folder") then
            return false;
        end;

        Parent = Parent.Parent;
    end;

    return Parent ~= nil;
end;

local u5 = {};

for i, v in {
    Character = script_Rigs.Character,
    Weapon = script_Rigs.Weapons
} do
    local v6 = {};
    local v7 = {};
    u1[i] = v6;
    u2[i] = v7;
    local v8 = v;

    for _, descendant in pairs(v:GetDescendants()) do
        if descendant:IsA("ModuleScript") and IsRigModule(descendant, v8) then
            v6[descendant.Name] = descendant;
            v7[descendant.Name:lower():gsub("[^%w]", "")] = descendant;
        end;
    end;
end;

local u9 = { "Character", "Weapons", "Glock-18" };

local function RigAnimationModules(p10: userdata) -- Line: 72
    -- upvalues: u9 (copy)
    if p10.Name == u9[1] then
        for i = 2, #u9 do
            local v11 = u9[i];
            local v12 = p10:FindFirstChild(v11);
            local v13 = `AnimationManager: base rig is missing '{v11}' -- BASE_RIG_CLIP_PATH is stale`;
            p10 = assert(v12, v13);
            local _ = i;
        end;
    end;

    local v14 = {};

    for _, child in p10:GetChildren() do
        if child:IsA("ModuleScript") then
            table.insert(v14, child);
        end;
    end;

    return v14;
end;

local u15 = setmetatable({}, {
    __mode = "k"
});
local u16 = setmetatable({}, {
    __mode = "k"
});
local script_Crunchyroll = require(script.Crunchyroll);
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = {};

local function ResolveRig(p22: userdata?) -- Line: 116
    -- upvalues: u21 (copy)
    if not p22 then
        return nil;
    end;

    local v23 = u21[p22];

    if v23 ~= nil then
        return v23 or nil;
    end;

    local v24 = require(p22);
    local v25;

    if typeof(v24) == "table" then
        v25 = v24.Rig ~= nil;
    else
        v25 = false;
    end;

    u21[p22] = v25 and v24 and v24 or false;

    return v25 and v24 and v24 or nil;
end;

function u5.GetRig(p26: string, p27: string) -- Line: 135
    -- upvalues: u1 (copy), u21 (copy), u2 (copy)
    local v28 = u1[p26];

    if not v28 then
        return nil;
    end;

    local v29 = v28[p27];
    local v30;

    if v29 then
        local v31 = u21[v29];

        if v31 == nil then
            local v32 = require(v29);
            local v33;

            if typeof(v32) == "table" then
                v33 = v32.Rig ~= nil;
            else
                v33 = false;
            end;

            u21[v29] = v33 and v32 and v32 or false;
            v30 = v33 and v32 and v32 or nil;
        else
            v30 = v31 or nil;
        end;
    else
        v30 = nil;
    end;

    if v30 then
        return v30;
    end;

    local v34 = p27:lower():gsub("[^%w]", "");
    local v35 = u2[p26][v34];

    if not v35 then
        return nil;
    end;

    local v36 = u21[v35];

    if v36 ~= nil then
        return v36 or nil;
    end;

    local v37 = require(v35);
    local v38;

    if typeof(v37) == "table" then
        v38 = v37.Rig ~= nil;
    else
        v38 = false;
    end;

    u21[v35] = v38 and v37 and v37 or false;

    return v38 and v37 and v37 or nil;
end;

local u39 = {};
local u40 = {};
local u41 = {};

local function VerifyRigAnimations(p42) -- Line: 172
    -- upvalues: u41 (copy), u19 (ref)
    if u41[p42] or not (u19 and u19.AnimationsNum) then
        return;
    end;

    u41[p42] = true;

    for _, v in p42.Animations do
        local v43 = u19.AnimationsNum[v.Name];
        local v44 = `AnimationManager: clip '{v.Name}' is missing from the animation enum -- RigAnimationModules no longer matches how this rig picks its clips`;
        assert(v43, v44);
    end;
end;

function u5.LoadRig(p45) -- Line: 187
    -- upvalues: VerifyRigAnimations (copy), script_Crunchyroll (ref), u39 (copy)
    VerifyRigAnimations(p45);
    local v46 = script_Crunchyroll.create_rig(p45.Rig);
    local v47 = u39[p45];

    if not v47 then
        v47 = {};

        for _, v in p45.Animations do
            v47[v.Name] = script_Crunchyroll.load_keyframe_sequence(v, v46);
        end;

        u39[p45] = v47;
    end;

    return {
        Rig = v46,
        Assets = v47
    };
end;

function u5.LoadAnimationMetadata(p48) -- Line: 206
    -- upvalues: VerifyRigAnimations (copy), u39 (copy), u40 (copy), script_Crunchyroll (ref)
    VerifyRigAnimations(p48);
    local v49 = u39[p48] or u40[p48];

    if not v49 then
        v49 = {};

        for _, v in p48.Animations do
            v49[v.Name] = script_Crunchyroll.load_keyframe_sequence_metadata(v);
        end;

        u40[p48] = v49;
    end;

    return v49;
end;

local u50 = setmetatable({}, {
    __mode = "k"
});

function u5.Solve(p51: any, p52: any, p53: boolean?) -- Line: 226
    -- upvalues: u50 (copy), script_Crunchyroll (ref)
    local v54 = u50[p51];

    if not v54 then
        v54 = {
            Tracks = {},
            Descriptors = {}
        };
        u50[p51] = v54;
    end;

    local Tracks = v54.Tracks;
    local Descriptors = v54.Descriptors;
    table.clear(Tracks);
    local v55 = 0;
    local v56 = false;
    local v57 = nil;

    for _, v in p52 do
        if v.Playing then
            local Track = v.Track;
            local v58 = Descriptors[v];
            v55 = v55 + 1;

            if not v58 then
                v58 = {};
                Descriptors[v] = v58;
            end;

            v56 = v56 or ((v58.alpha ~= Track.Alpha or (v58.start_fade_time ~= Track.StartFadeTime or (v58.stop_fade_time ~= Track.StopFadeTime or v58.weight ~= Track.Weight))) and true or v58.priority ~= Track.Priority);
            v58.alpha = Track.Alpha;
            v58.start_fade_time = Track.StartFadeTime;
            v58.stop_fade_time = Track.StopFadeTime;
            v58.weight = Track.Weight;
            v58.priority = Track.Priority;
            Tracks[v.Asset] = v58;
            v57 = v;
        end;
    end;

    if v55 == 0 then
        v54.Reusable = false;

        return false, false;
    end;

    local v59;

    if p53 and v55 == 1 then
        local Track = v57.Track;
        local v60 = v57.Asset.length * Track.Alpha;

        if Track.Weight > 0 and (Track.Priority >= 0 and (Track.StartFadeTime <= 0 or Track.StartFadeTime <= v60)) then
            v59 = Track.StopFadeTime <= 0 and true or v60 <= v57.Asset.length - Track.StopFadeTime;
        else
            v59 = false;
        end;

        if v59 and (v54.Reusable and not (v56 or (v54.SingleAnimator ~= v57 or v54.Asset ~= v57.Asset))) then
            return true, false;
        end;
    else
        v59 = false;
    end;

    v54.Reusable = v59;
    v54.SingleAnimator = v57;
    v54.Asset = v57.Asset;
    script_Crunchyroll.solve_animation(p51, Tracks, CFrame.identity, true);

    return true, true;
end;

function u5.LoadAnimation(p61: any, p62: boolean?) -- Line: 294
    -- upvalues: u17 (ref), u16 (copy), u15 (copy)
    local v63 = u17.new(p61, p62, u16);
    u15[v63] = true;

    return v63;
end;

function u5.PickVariant(p64: any, p65: string, p66: number?) -- Line: 307
    if not p64 then
        return p65;
    end;

    local v67 = 0;

    while p64[p65 .. v67 + 1] do
        v67 = v67 + 1;
    end;

    if v67 < 1 then
        return p65;
    end;

    local v68;

    if p66 then
        v68 = Random.new(p66):NextInteger(1, v67);
    else
        v68 = math.random(1, v67);
    end;

    return p65 .. v68;
end;

local table_freeze_ret = table.freeze({
    Fire = 4,
    Reload = 3,
    Equip = 2,
    Inspect = 1
});
local table_freeze_ret2 = table.freeze({
    Equip = true,
    Inspect = true,
    Fire = true
});

function u5.RollVariant(p69: any, p70: string) -- Line: 355
    -- upvalues: table_freeze_ret2 (copy), u5 (copy)
    if not table_freeze_ret2[p70] then
        return p70;
    end;

    local v71 = u5.PickVariant(p69.Animators, p70, p69.RandomSeed);
    local ActiveVariants = p69.ActiveVariants;

    if not ActiveVariants then
        ActiveVariants = {};
        p69.ActiveVariants = ActiveVariants;
    end;

    ActiveVariants[p70] = v71;

    return v71;
end;

function u5.CurrentVariant(p72: any, p73: string) -- Line: 373
    local ActiveVariants = p72.ActiveVariants;

    if ActiveVariants then
        p73 = ActiveVariants[p73] or p73;
    end;

    return p73;
end;

function u5.StartTrack(p74: any, p75: string, p76: string, p77: boolean?) -- Line: 381
    -- upvalues: table_freeze_ret (copy)
    local Animators = p74.Animators;

    if Animators then
        Animators = Animators[p75];
    end;

    if not Animators then
        return nil;
    end;

    for i, v in table_freeze_ret do
        if p76:sub(1, #i) == i then
            Animators.Track.Priority = v;
            break;
        end;
    end;

    if p77 or Animators.Track.Alpha >= 1 then
        Animators.Track.Alpha = 0;
    end;

    Animators.Direction = 1;
    Animators:Play();

    return Animators;
end;

function u5.ReverseTrack(p78: any, p79: string) -- Line: 406
    -- upvalues: u5 (copy)
    local v80 = u5.CurrentVariant(p78, p79);
    local Animators = p78.Animators;

    if Animators then
        Animators = Animators[v80];
    end;

    if not Animators then
        return nil;
    end;

    Animators:Reverse();
    Animators:Play();

    return Animators, v80;
end;

function u5.StopTrack(p81: any, p82: string) -- Line: 421
    -- upvalues: u5 (copy)
    local v83 = u5.CurrentVariant(p81, p82);
    local Animators = p81.Animators;

    if Animators then
        Animators = Animators[v83];
    end;

    if not Animators then
        return nil;
    end;

    Animators:Stop();

    return Animators, v83;
end;

function u5.StopAllTracks(p84: any, p85: string?) -- Line: 436
    local Animators = p84.Animators;

    if not Animators then
        return false;
    end;

    for i, v in Animators do
        if i ~= p85 then
            v:Stop();
        end;
    end;

    return true;
end;

function u5.Remove(p86) -- Line: 454
    -- upvalues: u15 (copy)
    if not u15[p86] then
        return;
    end;

    p86:Destroy();
    u15[p86] = nil;
end;

function u5.Step(p87: number) -- Line: 463
    -- upvalues: u16 (copy)
    for i in u16 do
        i:Step(p87);
    end;
end;

function u5.Init(p88) -- Line: 469
    -- upvalues: script_Crunchyroll (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u1 (copy), RigAnimationModules (copy)
    script_Crunchyroll = require(script.Crunchyroll);
    u17 = require(script.Animator);
    u18 = p88:GetModule("Tick");
    u19 = p88:GetModule("Enums");
    u20 = p88:GetModule("Table");
    local v89 = {};

    for _, v in u1 do
        for _, v2 in v do
            for _, v3 in RigAnimationModules(v2) do
                v89[v3.Name] = true;
            end;
        end;
    end;

    local v90 = {};

    for i in v89 do
        table.insert(v90, i);
    end;

    table.sort(v90);
    local v91 = `AnimationManager: {#v90} distinct animation names, SpectateData's u8 id holds 255`;
    assert(#v90 <= 255, v91);
    local v92 = {};

    for i, v in v90 do
        v92[v] = i;
    end;

    u19.Animations = u20.Freeze(v90);
    u19.AnimationsNum = u20.Freeze(v92);
end;

function u5.Start(p93) -- Line: 507
    -- upvalues: u18 (ref), u5 (copy)
    u18.PostTick.Connect({
        Function = function(p94) -- Line: 509
            -- upvalues: u5 (ref)
            u5.Step(p94);
        end,

        Priority = 1,
        SubPriority = 3
    });
end;

return u5;