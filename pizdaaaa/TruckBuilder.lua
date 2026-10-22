-- ReplicatedStorage.Cutscenes.TutorialIntro.TruckBuilder
-- Script path: ReplicatedStorage.Cutscenes.TutorialIntro.TruckBuilder
-- Decompile time: 4.63 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};
local u2 = setmetatable({}, {
    __mode = "k"
});

local function findTemplate() -- Line: 32
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:WaitForChild("Assets", 5);

    if Assets then
        Assets = Assets:WaitForChild("Cutscenes", 5);
    end;

    if Assets then
        Assets = Assets:WaitForChild("TutorialTruck", 5);
    end;

    local v3;

    if Assets then
        v3 = Assets:IsA("Model");
    else
        v3 = Assets;
    end;

    assert(v3, "ReplicatedStorage.Assets.Cutscenes.TutorialTruck is missing");

    return Assets;
end;

function v1.template() -- Line: 40
    -- upvalues: findTemplate (copy)
    return findTemplate();
end;

function v1.build(p4: userdata?) -- Line: 44
    -- upvalues: findTemplate (copy), u2 (copy)
    local v5 = findTemplate();
    local v6 = v5:Clone();
    v6.Name = "CutsceneTruck";
    local v7 = {
        Start = nil,
        Parts = {},
        Locals = {},
        Axles = {},
        IsWheel = {},
        CFrames = {},
        Radius = v5:GetAttribute("WheelRadius") or 1.6
    };

    for _, child in v6:GetChildren() do
        local v8 = child.Name == "Wheels";

        for _, child2 in child:GetChildren() do
            local Attribute = child2:GetAttribute("Local");

            if child2:IsA("BasePart") and typeof(Attribute) == "CFrame" then
                local Attribute2 = child2:GetAttribute("Axle");
                table.insert(v7.Parts, child2);
                table.insert(v7.Locals, Attribute);
                local Axles = v7.Axles;
                local v9 = #v7.Parts;

                if typeof(Attribute2) ~= "Vector3" then
                    Attribute2 = nil;
                end;

                Axles[v9] = Attribute2;
                table.insert(v7.IsWheel, v8);
                table.insert(v7.CFrames, Attribute);
            end;
        end;
    end;

    u2[v6] = v7;
    v6.Parent = p4;

    return v6;
end;

function v1.place(p10: userdata, p11, p12) -- Line: 77
    -- upvalues: u2 (copy)
    local v13 = u2[p10];

    if not v13 then
        return;
    end;

    local v14 = p12 or p11;

    if not v13.Start then
        v13.Start = v14.Position;
    end;

    local v15 = (v14.Position - v13.Start):Dot(v14.LookVector);
    local CFrame_Angles_ret = CFrame.Angles(-v15 / v13.Radius, 0, 0);
    local CFrames = v13.CFrames;

    for i, v in v13.Locals do
        if v13.IsWheel[i] then
            local v16 = v13.Axles[i];

            if v16 then
                local CFrame_new_ret = CFrame.new(v16);
                CFrames[i] = v14 * CFrame_new_ret * CFrame_Angles_ret * CFrame_new_ret:Inverse() * v;
            else
                CFrames[i] = v14 * v;
            end;
        else
            CFrames[i] = p11 * v;
        end;
    end;

    workspace:BulkMoveTo(v13.Parts, CFrames, Enum.BulkMoveMode.FireCFrameChanged);
end;

return v1;