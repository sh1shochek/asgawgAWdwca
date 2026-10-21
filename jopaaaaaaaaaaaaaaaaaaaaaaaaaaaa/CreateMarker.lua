-- ReplicatedStorage.Components.Common.VFXLibary.CreateMarker
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMarker
-- Decompile time: 3.12 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local Other = Assets:WaitForChild("Other");
local Debris = workspace:WaitForChild("Debris");
local u1 = {
    Bullet = require(script.Components.Bullet),
    Melee = require(script.Components.Melee)
};
local CFrame_new_ret = CFrame.new(0, -10000, 0);
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = setmetatable({}, {
    __mode = "k"
});
local u4 = {};
local HitMarker = Other:WaitForChild("HitMarker");
local u8 = ObjectPool.new(HitMarker, {
    MaxRetained = 20,
    InPlace = true,
    StorageName = "BulletMarkers",
    InitialSize = RunService:IsClient() and 20 or 0,

    Prepare = function(p5: userdata) -- Line: 53, Name: initMarkerPart
        -- upvalues: CFrame_new_ret (copy), u2 (copy), u3 (copy)
        p5.CollisionGroup = "Debris";
        p5.CanCollide = false;
        p5.CanQuery = false;
        p5.CanTouch = false;
        p5.Anchored = true;
        p5.CFrame = CFrame_new_ret;
        local v6 = {};

        for _, descendant in ipairs(p5:GetDescendants()) do
            if descendant:IsA("Decal") then
                table.insert(v6, descendant);
            end;
        end;

        u2[p5] = v6;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Enabled = false;
        WeldConstraint.Part0 = p5;
        WeldConstraint.Parent = p5;
        u3[p5] = WeldConstraint;
    end,

    Reset = function(p7: userdata) -- Line: 77, Name: hideMarkerPart
        -- upvalues: CFrame_new_ret (copy)
        p7.Anchored = true;
        p7.CFrame = CFrame_new_ret;
    end,

    StorageParent = Debris
});

return function(u9: userdata?, p10: string, p11: vector, p12: vector) -- Line: 97
    -- upvalues: u1 (copy), u4 (copy), u8 (copy), u3 (copy), u2 (copy)
    if u9 ~= nil and u9.ClassName == "Terrain" then
        return;
    end;

    local v13 = u1[p10];
    local v14 = `{p10} is not apart of library "MarkerInfo"`;
    assert(v13, v14);
    debug.profilebegin("VFX.Marker");
    local v15 = #u4 >= 20 and table.remove(u4, 1);

    if v15 then
        v15();
    end;

    local u16, u17 = u8:Acquire();
    local u18 = u3[u16];
    local v19 = v13.Properties.SizeRange();
    u16.Size = Vector3.new(v19, v19, 0.001);
    u16.CFrame = CFrame.new(p11, p11 + p12) * CFrame.Angles(0, 0, v13.Properties.Rotation() * 3.141592653589793 / 180);

    for _, v in ipairs(u2[u16]) do
        v.Transparency = v13.Properties.Transparency();
        v.Texture = v13.Images[math.random(1, #v13.Images)];
        v.Color3 = v13.Properties.Color3;
    end;

    local v20;

    if u9 == nil then
        v20 = false;
    else
        v20 = u9:IsA("BasePart") and not u9.Anchored;
    end;

    if v20 then
        u18.Part1 = u9;
        u18.Enabled = true;
        u16.Anchored = false;
    end;

    local u21 = {};

    local function release() -- Line: 139
        -- upvalues: u21 (copy), u8 (ref), u16 (copy), u17 (copy), u18 (copy), u4 (ref), release (copy)
        for _, v in ipairs(u21) do
            v:Disconnect();
        end;

        table.clear(u21);

        if u8:IsAcquired(u16, u17) then
            u18.Enabled = false;
            u18.Part1 = nil;
            u8:Release(u16, u17);
        end;

        local table_find_ret = table.find(u4, release);

        if table_find_ret then
            table.remove(u4, table_find_ret);
        end;
    end;

    table.insert(u4, release);

    if u9 ~= nil and (u9:IsA("BasePart") and u9:IsDescendantOf(workspace)) then
        table.insert(u21, u9.Destroying:Once(release));
        local PropertyChangedSignal = u9:GetPropertyChangedSignal("Transparency");
        table.insert(u21, PropertyChangedSignal:Connect(function() -- Line: 162
            -- upvalues: u9 (copy), release (copy)
            if u9.Transparency == 1 then
                release();
            end;
        end));
    end;

    task.delay(15, release);
    debug.profileend();
end;