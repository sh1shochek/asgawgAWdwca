-- ReplicatedStorage.Controllers.TutorialBotSmoothing
-- Script path: ReplicatedStorage.Controllers.TutorialBotSmoothing
-- Decompile time: 7.31 ms

local track
local v1 = {}
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local u11 = {TutorialEscorts = true, TutorialRetakers = true, TutorialCTSquad = true, TutorialBAttackers = true}
local u12 = {}
local u13 = {}
local u14 = nil
local u15 = {}
local u16 = {}
local u17 = 0

local function isSamePose(a1, a2) -- Line: 81 -- types: a1: userdata, a2: userdata
    local v1 = false
    if (a1.Position - a2.Position).Magnitude <= 0.001 then
        v1 = false
        if 0.999998 <= (a1.LookVector:Dot(a2.LookVector)) then
            v1 = 0.999998 <= (a1.UpVector:Dot(a2.UpVector))
        end
    end
    return v1
end

local function untrack(a1) -- Line: 87 -- upvalues: u12 (val), u14 (ref) -- types: a1: userdata
    local v1 = u12[a1]
    if not v1 then
        return
    end
    u12[a1] = nil
    local v2 = nil
    for i, j in v1.Connections, v2 do
        j:Disconnect()
    end
    local Written = v1.Written
    if Written and v1.Root.Parent then
        local CFrame = v1.Root.CFrame
        v2 = false
        if (CFrame.Position - Written.Position).Magnitude <= 0.001 then
            v2 = false
            if 0.999998 <= (CFrame.LookVector:Dot(Written.LookVector)) then
                v2 = 0.999998 <= (CFrame.UpVector:Dot(Written.UpVector))
            end
        end
        if v2 then
            v1.Root.CFrame = v1.Target
        end
    end
    if next(u12) == nil and u14 then
        u14:Disconnect()
        u14 = nil
    end
end

local function receive(a1, a2, a3) -- Line: 107 -- upvalues: u17 (ref) -- types: a1: table, a2: userdata, a3: number
    a1.Target = a2
    local Position = a2.Position
    local Path = a1.Path
    local Position_2 = if not (#Path > 0) then a1.Visual.Position else Path[#Path]
    local Magnitude = (Position - Position_2).Magnitude
    if Magnitude > 8 then
        table.clear(Path)
        table.clear(a1.Arrivals)
        a1.Visual = a2
        a1.Speed = 0
        a1.Cruise = 0
        return
    end
    if Magnitude > 0.001 then
        table.insert(Path, Position)
        a1.Queued = a1.Queued + Magnitude
        local MovedAt = a1.MovedAt
        if MovedAt and a3 - MovedAt < 0.6 then
            u17 = math.max(u17, a3 - MovedAt)
        end
        a1.MovedAt = a3
    end
    table.insert(a1.Arrivals, {Time = a3, Distance = a1.Queued})
end

local function measureSpeed(a1, a2) -- Line: 134 -- types: a1: table, a2: number
    local Arrivals = a1.Arrivals
    while #Arrivals > 1 do
        if not (0.5 < a2 - Arrivals[1].Time) then
            break
        end
        table.remove(Arrivals, 1)
    end
    if #Arrivals < 2 then
        return 0
    end
    local v1 = Arrivals[1]
    return (a1.Queued - v1.Distance) / math.max(a2 - v1.Time, 0.25)
end

local function pathLength(a1, a2) -- Line: 146 -- types: a1: vector, a2: table
    local v1 = 0
    for i, j in a2 do
        v1 = v1 + (j - a1).Magnitude
    end
    return v1
end

local function advance(a1, a2, a3) -- Line: 157 -- types: a1: vector, a2: table, a3: number
    local Magnitude, v1
    local v2 = a1
    local v3 = a3
    while #a2 > 0 do
        v1 = a2[1]
        Magnitude = (v1 - v2).Magnitude
        if v3 < Magnitude then
            return v2 + (v1 - v2) * (v3 / Magnitude)
        end
        v3 = v3 - Magnitude
        v2 = v1
        table.remove(a2, 1)
    end
    return v2
end

local function step(a1) -- Line: 172
    -- upvalues: u17 (ref), u15 (val), u16 (val), u12 (val), untrack (val), receive (val), measureSpeed (val)
    -- upvalues: advance (val), Workspace (val)
    local CFrame_2, MovedAt, Path, Position, Root, Rotation, Speed, Speed_2, Target, Visual, Written, v1, v2, v3, v4, v5, v6
    local v7 = math.min(a1, 0.1)
    local v8 = os.clock()
    local v9 = 1 - math.exp(v7 * -10)
    local v10 = 1 - math.exp(v7 * -14)
    u17 = u17 * math.exp(-v7 / 3)
    local v11 = math.clamp(u17 * 1.25, 0.1, 0.4)
    local v12 = math.exp(-v7 / 1)
    table.clear(u15)
    table.clear(u16)
    local v13 = nil
    local v14 = nil
    for i, j in u12, v13, v14 do
        Root = j.Root
        if i.Parent ~= j.Folder or Root.Parent == nil then
            untrack(i)
        elseif i:GetAttribute("Dead") ~= true then
            CFrame_2 = Root.CFrame
            Written = j.Written
            if not Written then
                receive(j, CFrame_2, v8)
            else
                v1 = false
                if (CFrame_2.Position - Written.Position).Magnitude <= 0.001 then
                    v1 = false
                    if 0.999998 <= (CFrame_2.LookVector:Dot(Written.LookVector)) then
                        v1 = 0.999998 <= (CFrame_2.UpVector:Dot(Written.UpVector))
                    end
                end
                if not v1 then
                    receive(j, CFrame_2, v8)
                end
            end
            Target = j.Target
            Visual = j.Visual
            Speed = j.Speed
            v4 = measureSpeed(j, v8)
            j.Speed = Speed + (v4 - j.Speed) * v9
            Speed_2 = j.Speed
            v3 = j.Cruise * v12
            j.Cruise = math.max(Speed_2, v3)
            Path = j.Path
            v2 = 0
            v4 = Visual.Position
            v5 = nil
            v6 = nil
            for k, n in Path, v5, v6 do
                v2 = v2 + (n - v4).Magnitude
                v4 = n
            end
            if not (v2 <= 0.01) then
                v4 = j.Speed + (v2 - j.Speed * v11) * 3
                MovedAt = j.MovedAt
                if not MovedAt or v11 < v8 - MovedAt then
                    v4 = math.max(v4, j.Cruise)
                end
                v5 = math.max((math.clamp(v4, 0, (math.max(j.Cruise * 1.5, 4)))) * v7, v2 - 7)
                Position = if not (v2 - 0.01 <= v5) then advance(Visual.Position, Path, v5) else advance(Visual.Position, Path, (1 / 0))
            else
                table.clear(Path)
                Position = Target.Position
            end
            v4 = false
            if 0.9999904807207345 <= (Visual.LookVector:Dot(Target.LookVector)) then
                v4 = 0.9999904807207345 <= (Visual.UpVector:Dot(Target.UpVector))
            end
            Rotation = if not v4 then Visual.Rotation:Lerp(Target.Rotation, v10) else Target.Rotation
            v5 = CFrame.new(Position) * Rotation
            if #Path == 0 and v4 then
                v5 = Target
            end
            j.Visual = v5
            if v5 ~= Target then
                j.Written = v5
                u15[#u15 + 1] = Root
                u16[#u16 + 1] = v5
            else
                v6 = false
                if (CFrame_2.Position - Target.Position).Magnitude <= 0.001 then
                    v6 = false
                    if 0.999998 <= (CFrame_2.LookVector:Dot(Target.LookVector)) then
                        v6 = 0.999998 <= (CFrame_2.UpVector:Dot(Target.UpVector))
                    end
                end
                if not v6 then
                    j.Written = v5
                    u15[#u15 + 1] = Root
                    u16[#u16 + 1] = v5
                else
                    j.Written = CFrame_2
                end
            end
        else
            untrack(i)
        end
    end
    if #u15 == 1 then
        u15[1].CFrame = u16[1]
        return
    end
    if #u15 > 1 then
        Workspace:BulkMoveTo(u15, u16, Enum.BulkMoveMode.FireCFrameChanged)
    end
end

function track(a1, a2) -- Line: 249
    -- upvalues: u12 (val), track (val), untrack (val), u14 (ref), RunService (val), step (val)
    if a1:IsA("Model") and not u12[a1] then
        if a1:GetAttribute("TutorialDummy") == true and a1:GetAttribute("TutorialCutout") ~= true then
            if a1:GetAttribute("Dead") == true then
                return
            end
            local HumanoidRootPart = a1:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                if not HumanoidRootPart.Anchored then
                    return
                end
                local CFrame = HumanoidRootPart.CFrame
                local v1 = {
                    Queued = 0,
                    Speed = 0,
                    Cruise = 0,
                    Model = a1,
                    Folder = a2,
                    Root = HumanoidRootPart,
                    Target = CFrame,
                    Visual = CFrame,
                    Path = {},
                    Arrivals = {},
                    Connections = {},
                }
                u12[a1] = v1
                table.insert(v1.Connections, ((a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 299 -- upvalues: a1 (val), untrack (upval)
                    if a1:GetAttribute("Dead") == true then
                        untrack(a1)
                    end
                end)))
                table.insert(v1.Connections, (a1.AncestryChanged:Connect(function() -- Line: 307 -- upvalues: a1 (val), a2 (val), untrack (upval)
                    if a1.Parent ~= a2 then
                        untrack(a1)
                    end
                end)))
                if not u14 then
                    u14 = RunService.RenderStepped:Connect(step)
                end
                return
            end
            local u61 = nil
            u61 = a1.ChildAdded:Connect(function(a1_2) -- Line: 263 -- upvalues: u61 (ref), track (upval), a1 (val), a2 (val)
                if a1_2.Name == "HumanoidRootPart" then
                    u61:Disconnect()
                    track(a1, a2)
                end
            end)
            task.delay(10, function() -- Line: 269 -- upvalues: u61 (ref)
                u61:Disconnect()
            end)
            return
        end
        return
    end
end

local function watchFolder(a1) -- Line: 318
    -- upvalues: u11 (val), u13 (val), track (val), untrack (val)
    if u11[a1.Name] and not u13[a1] then
        u13[a1] = {
            a1.ChildAdded:Connect(function(a1_2) -- Line: 323 -- upvalues: track (upval), a1 (val)
                track(a1_2, a1)
            end),
            (a1.ChildRemoved:Connect(function(a1) -- Line: 326 -- upvalues: untrack (upval)
                if a1:IsA("Model") then
                    untrack(a1)
                end
            end)),
        }
        for i, j in a1:GetChildren() do
            track(j, a1)
        end
        return
    end
end

local function unwatchFolder(a1) -- Line: 337 -- upvalues: u13 (val), u12 (val), untrack (val) -- types: a1: userdata
    local v1 = u13[a1]
    if not v1 then
        return
    end
    u13[a1] = nil
    for i, j in v1 do
        j:Disconnect()
    end
    for k, n in u12 do
        if n.Folder == a1 then
            untrack(k)
        end
    end
end

function v1.Start() -- Line: 356 -- upvalues: Workspace (val), watchFolder (val), unwatchFolder (val)
    Workspace.ChildAdded:Connect(watchFolder)
    Workspace.ChildRemoved:Connect(unwatchFolder)
    for i, j in Workspace:GetChildren() do
        watchFolder(j)
    end
end

return v1