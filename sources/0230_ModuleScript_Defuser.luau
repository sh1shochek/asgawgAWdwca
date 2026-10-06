-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Other = ReplicatedStorage.Assets.Other;
local Defuser = Other.Defuser;
local DefuseA1 = Other.DefuseA1;
local DefuseA2 = Other.DefuseA2;
local DefuseB1 = Other.DefuseB1;
local DefuseB2 = Other.DefuseB2;
local u1 = CFrame.new(0, -0.2, -0.5) * CFrame.Angles(0, 3.141592653589793, 0);
local u2 = {};
u2.__index = u2;

local function cloneDefusePart(p3: userdata, p4: userdata, p5: any) -- Line: 33
    local v6 = p3:Clone();
    local Attachment = v6:FindFirstChild("Attachment");
    local Parent = p4.Parent;
    v6.CFrame = Parent.CFrame * p4.CFrame * Attachment.CFrame:Inverse();
    v6.Parent = workspace;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = Parent;
    WeldConstraint.Part1 = v6;
    WeldConstraint.Parent = v6;
    p5:Add(v6);

    return Attachment;
end;

local function disconnectBeam(p7: userdata?) -- Line: 50
    if p7 then
        p7.Attachment0 = nil;
        p7.Attachment1 = nil;
    end;
end;

local function cleanupVisuals(u8) -- Line: 58
    task.defer(function() -- Line: 59
        -- upvalues: u8 (copy)
        pcall(function() -- Line: 60
            -- upvalues: u8 (ref)
            u8:Destroy();
        end);
    end);
end;

local function connectBeam(p9: userdata, p10: userdata) -- Line: 67
    local v11 = p9.Parent:FindFirstChildWhichIsA("Beam");

    if v11 then
        v11.Attachment0 = p9;
        v11.Attachment1 = p10;
        v11.Enabled = true;
    end;

    return v11;
end;

function u2.new(p12: userdata, u13: userdata) -- Line: 78
    -- upvalues: u2 (copy), Janitor (copy), Observers (copy), CollectionService (copy), Defuser (copy), u1 (copy), cloneDefusePart (copy), DefuseA1 (copy), DefuseA2 (copy), DefuseB1 (copy), DefuseB2 (copy)
    local v14 = setmetatable({}, u2);
    v14.Janitor = Janitor.new();
    local u15 = nil;
    local u16 = nil;
    local u17 = nil;

    local function reset() -- Line: 86
        -- upvalues: u16 (ref), u17 (ref), u15 (ref)
        local v18 = u16;

        if v18 then
            v18.Attachment0 = nil;
            v18.Attachment1 = nil;
        end;

        local v19 = u17;

        if v19 then
            v19.Attachment0 = nil;
            v19.Attachment1 = nil;
        end;

        if u15 then
            local u20 = u15;
            task.defer(function() -- Line: 59
                -- upvalues: u20 (copy)
                pcall(function() -- Line: 60
                    -- upvalues: u20 (ref)
                    u20:Destroy();
                end);
            end);
        end;

        u16 = nil;
        u17 = nil;
        u15 = nil;
    end;

    v14.Janitor:Add(Observers.observeAttribute(p12, "IsDefusingBomb", function(p21) -- Line: 97
        -- upvalues: u16 (ref), u17 (ref), u15 (ref), reset (copy), u13 (copy), CollectionService (ref), Janitor (ref), Defuser (ref), u1 (ref), cloneDefusePart (ref), DefuseA1 (ref), DefuseA2 (ref), DefuseB1 (ref), DefuseB2 (ref)
        local v22 = u16;

        if v22 then
            v22.Attachment0 = nil;
            v22.Attachment1 = nil;
        end;

        local v23 = u17;

        if v23 then
            v23.Attachment0 = nil;
            v23.Attachment1 = nil;
        end;

        if u15 then
            local u24 = u15;
            task.defer(function() -- Line: 59
                -- upvalues: u24 (copy)
                pcall(function() -- Line: 60
                    -- upvalues: u24 (ref)
                    u24:Destroy();
                end);
            end);
        end;

        u16 = nil;
        u17 = nil;
        u15 = nil;

        if p21 ~= true then
            return reset;
        end;

        local LeftHand = u13:FindFirstChild("LeftHand");
        local v25 = CollectionService:GetTagged("Bomb")[1];

        if not (LeftHand and v25) then
            return function() -- Line: 106
            end;
        end;

        u15 = Janitor.new();
        local v26 = Defuser:Clone();
        local Handle = v26.Handle;
        v26.Parent = u13;
        Handle.CFrame = LeftHand.CFrame * u1;
        v26.PrimaryPart = Handle;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = LeftHand;
        WeldConstraint.Part1 = Handle;
        WeldConstraint.Parent = Handle;
        u15:Add(v26);
        local Body = v25.Weapon.Body;
        local v27 = cloneDefusePart(DefuseA1, Handle:FindFirstChild("AttachmentA"), u15);
        local v28 = cloneDefusePart(DefuseA2, Body:FindFirstChild("AttachmentA"), u15);
        local v29 = cloneDefusePart(DefuseB1, Handle:FindFirstChild("AttachmentB"), u15);
        local v30 = cloneDefusePart(DefuseB2, Body:FindFirstChild("AttachmentB"), u15);
        local v31 = v27.Parent:FindFirstChildWhichIsA("Beam");

        if v31 then
            v31.Attachment0 = v27;
            v31.Attachment1 = v28;
            v31.Enabled = true;
        end;

        u16 = v31;
        local v32 = v29.Parent:FindFirstChildWhichIsA("Beam");

        if v32 then
            v32.Attachment0 = v29;
            v32.Attachment1 = v30;
            v32.Enabled = true;
        end;

        u17 = v32;

        return reset;
    end));

    return v14;
end;

function u2.Destroy(p33) -- Line: 140
    p33.Janitor:Destroy();
end;

return u2;