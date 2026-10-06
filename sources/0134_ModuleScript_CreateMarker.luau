-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local Other = Assets:WaitForChild("Other");
local Debris = workspace:WaitForChild("Debris");
local u1 = {
    Bullet = require(script.Components.Bullet),
    Melee = require(script.Components.Melee)
};
local HitMarker = Other:WaitForChild("HitMarker");
local u2 = ObjectPool.new(HitMarker, {
    InitialSize = 4,
    MaxRetained = 20
});
local u3 = setmetatable({}, {
    __mode = "k"
});
local u4 = setmetatable({}, {
    __mode = "k"
});
local u5 = {};

local function initMarkerPart(p6: userdata) -- Line: 55
    -- upvalues: u3 (copy), u4 (copy)
    p6.CollisionGroup = "Debris";
    p6.CanCollide = false;
    p6.CanQuery = false;
    p6.CanTouch = false;
    local v7 = {};

    for _, descendant in ipairs(p6:GetDescendants()) do
        if descendant:IsA("Decal") then
            table.insert(v7, descendant);
        end;
    end;

    u3[p6] = v7;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Enabled = false;
    WeldConstraint.Part0 = p6;
    WeldConstraint.Parent = p6;
    u4[p6] = WeldConstraint;

    return WeldConstraint;
end;

return function(u8: userdata?, p9: string, p10: vector, p11: vector) -- Line: 80
    -- upvalues: u1 (copy), u5 (copy), u2 (copy), u4 (copy), initMarkerPart (copy), u3 (copy), Debris (copy)
    if u8 ~= nil and u8.ClassName == "Terrain" then
        return;
    end;

    local v12 = u1[p9];
    local v13 = `{p9} is not apart of library "MarkerInfo"`;
    assert(v12, v13);
    debug.profilebegin("VFX.Marker");
    local v14 = #u5 >= 20 and table.remove(u5, 1);

    if v14 then
        v14();
    end;

    local u15, u16 = u2:Acquire();
    local u17 = u4[u15] or initMarkerPart(u15);
    local v18 = v12.Properties.SizeRange();
    u15.Size = Vector3.new(v18, v18, 0.001);
    u15.CFrame = CFrame.new(p10, p10 + p11) * CFrame.Angles(0, 0, v12.Properties.Rotation() * 3.141592653589793 / 180);

    for _, v in ipairs(u3[u15]) do
        v.Transparency = v12.Properties.Transparency();
        v.Texture = v12.Images[math.random(1, #v12.Images)];
        v.Color3 = v12.Properties.Color3;
    end;

    local v19;

    if u8 == nil then
        v19 = false;
    else
        v19 = u8:IsA("BasePart") and not u8.Anchored;
    end;

    u15.Anchored = true;
    u15.Parent = Debris;

    if v19 then
        u17.Part1 = u8;
        u17.Enabled = true;
        u15.Anchored = false;
    end;

    local u20 = {};

    local function release() -- Line: 124
        -- upvalues: u20 (copy), u2 (ref), u15 (copy), u16 (copy), u17 (copy), u5 (ref), release (copy)
        for _, v in ipairs(u20) do
            v:Disconnect();
        end;

        table.clear(u20);

        if u2:IsAcquired(u15, u16) then
            u17.Enabled = false;
            u17.Part1 = nil;
            u2:Release(u15, u16);
        end;

        local table_find_ret = table.find(u5, release);

        if table_find_ret then
            table.remove(u5, table_find_ret);
        end;
    end;

    table.insert(u5, release);

    if u8 ~= nil and (u8:IsA("BasePart") and u8:IsDescendantOf(workspace)) then
        table.insert(u20, u8.Destroying:Once(release));
        local PropertyChangedSignal = u8:GetPropertyChangedSignal("Transparency");
        table.insert(u20, PropertyChangedSignal:Connect(function() -- Line: 147
            -- upvalues: u8 (copy), release (copy)
            if u8.Transparency == 1 then
                release();
            end;
        end));
    end;

    task.delay(15, release);
    debug.profileend();
end;