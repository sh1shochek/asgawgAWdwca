-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local v1 = {};
local CFrame_new_ret = CFrame.new(0, 10000, 0);
local u2 = nil;

local function getStash() -- Line: 12
    -- upvalues: u2 (ref), Workspace (copy)
    local v3 = u2;

    if v3 and v3.Parent == Workspace then
        return v3;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "ThirdPersonWeaponStash";
    Folder.Archivable = false;
    Folder.Parent = Workspace;
    u2 = Folder;

    return Folder;
end;

function v1.Park(p4: userdata, p5: table) -- Line: 26
    -- upvalues: CFrame_new_ret (copy), u2 (ref), Workspace (copy)
    for _, v in p5 do
        local Part1 = v.Part1;
        v:Destroy();

        if Part1 then
            Part1.Anchored = true;
            Part1.CFrame = CFrame_new_ret;
        end;
    end;

    table.clear(p5);
    local v6 = u2;

    if not v6 or v6.Parent ~= Workspace then
        v6 = Instance.new("Folder");
        v6.Name = "ThirdPersonWeaponStash";
        v6.Archivable = false;
        v6.Parent = Workspace;
        u2 = v6;
    end;

    p4.Parent = v6;
end;

function v1.PoseForJoint(p7: userdata, p8: userdata, p9, p10) -- Line: 40
    if p7.Anchored then
        p7.CFrame = p8.CFrame * p9 * p10:Inverse();
    end;
end;

function v1.Release(p11: table) -- Line: 47
    for _, v in p11 do
        local Part1 = v.Part1;

        if Part1 then
            Part1.Anchored = false;
        end;
    end;
end;

function v1.TryUnpark(u12: userdata, u13: userdata) -- Line: 57
    return pcall(function() -- Line: 58
        -- upvalues: u12 (copy), u13 (copy)
        u12.Parent = u13;
    end);
end;

return table.freeze(v1);