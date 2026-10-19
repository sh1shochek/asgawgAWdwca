-- CreateGrenadeBurst (ModuleScript)
-- full path: ReplicatedStorage.Components.Common.VFXLibary.CreateGrenadeBurst

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Sound = require(ReplicatedStorage.Classes.Sound);
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local Debris = workspace:WaitForChild("Debris");
local CFrame_new_ret = CFrame.new(0, -10000, 0);
local u1 = setmetatable({}, {
    __mode = "k"
});
local u2 = {};
local u3 = {};
local u4 = {};

local function prepareBurst(p5: userdata) -- Line: 37
    -- upvalues: CFrame_new_ret (copy), u1 (copy)
    p5.Anchored = true;
    p5.CanCollide = false;
    p5.CanQuery = false;
    p5.CanTouch = false;
    p5.CFrame = CFrame_new_ret;
    local v6 = {};

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            v6[#v6 + 1] = {
                Emitter = descendant,
                Delay = descendant:GetAttribute("EmitDelay") or 0,
                Count = descendant:GetAttribute("EmitCount") or 1
            };
        end;
    end;

    local Sound2 = Instance.new("Sound");
    Sound2.Name = "Explode";
    Sound2.Parent = p5;
    u1[p5] = {
        Emitters = v6,
        Bang = Sound2
    };
end;

local function hideBurst(p7: userdata) -- Line: 59
    -- upvalues: CFrame_new_ret (copy)
    p7.CFrame = CFrame_new_ret;
end;

local function getHold(p8: userdata) -- Line: 64
    local v9 = 0;

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v10 = (descendant:GetAttribute("EmitDelay") or 0) + descendant.Lifetime.Max;
            v9 = math.max(v9, v10);
        end;
    end;

    return v9 + 0.25;
end;

local function getPool(p11: userdata) -- Line: 75
    -- upvalues: u2 (copy), ObjectPool (copy), prepareBurst (copy), hideBurst (copy), Debris (copy), u3 (copy), getHold (copy)
    local v12 = u2[p11];

    if v12 then
        return v12;
    end;

    local v13 = ObjectPool.new(p11, {
        MaxRetained = 6,
        InPlace = true,
        Prepare = prepareBurst,
        Reset = hideBurst,
        StorageParent = Debris,
        StorageName = `GrenadeBursts_{p11.Name}`
    });
    u2[p11] = v13;
    u3[p11] = getHold(p11);

    return v13;
end;

return function(p14: userdata, p15: vector, p16: string?) -- Line: 93
    -- upvalues: getPool (copy), u1 (copy), u4 (copy), Sound (copy), u3 (copy)
    local u17 = getPool(p14);
    local u18, u19 = u17:Acquire();
    local v20 = u1[u18];
    u18.CFrame = CFrame.new(p15);

    for _, v in v20.Emitters do
        local Emitter = v.Emitter;
        local Count = v.Count;

        if v.Delay <= 0 then
            Emitter:Emit(Count);
        else
            task.delay(v.Delay, function() -- Line: 104
                -- upvalues: u17 (copy), u18 (copy), u19 (copy), Emitter (copy), Count (copy)
                if u17:IsAcquired(u18, u19) then
                    Emitter:Emit(Count);
                end;
            end);
        end;
    end;

    if p16 then
        local v21 = u4[p16];

        if not v21 then
            v21 = Sound.new(p16);
            u4[p16] = v21;
        end;

        v21:playOn(v20.Bang, "Explode");
    end;

    task.delay(u3[p14], function() -- Line: 121
        -- upvalues: u17 (copy), u18 (copy), u19 (copy)
        u17:Release(u18, u19);
    end);
end;