-- ReplicatedStorage.Shared.Zone.ZoneController.Tracker
-- Script path: ReplicatedStorage.Shared.Zone.ZoneController.Tracker
-- Decompile time: 3.61 ms

local Players = game:GetService("Players")
local Heartbeat = game:GetService("RunService").Heartbeat
local Signal = require(script.Parent.Parent.Signal)
local Janitor = require(script.Parent.Parent.Janitor)
local u23 = {}
u23.__index = u23
local u24 = {}
u23.trackers = u24
u23.itemAdded = Signal.new()
u23.itemRemoved = Signal.new()
u23.bodyPartsToIgnore = {
    UpperTorso = true,
    LowerTorso = true,
    Torso = true,
    LeftHand = true,
    RightHand = true,
    LeftFoot = true,
    RightFoot = true,
}

function u23.getCombinedTotalVolumes() -- Line: 35 -- upvalues: u24 (val)
    local v1 = 0
    for k, v in pairs(u24) do
        v1 = v1 + k.totalVolume
    end
    return v1
end

function u23.getCharacterSize(a1) -- Line: 43
    local Head = a1 and a1:FindFirstChild("Head")
    local HumanoidRootPart = a1 and a1:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart and Head then
        if not Head:IsA("BasePart") then
            Head = HumanoidRootPart
        end
        local Y = Head.Size.Y
        local Size = HumanoidRootPart.Size
        return Size * Vector3.new(2, 2, 1) + Vector3.new(0, Y, 0), HumanoidRootPart.CFrame * CFrame.new(0, Y / 2 - Size.Y / 2, 0)
    end
    return nil
end

function u23.new(a1) -- Line: 60 -- upvalues: u23 (val), Janitor (val), Players (val), u24 (val)
    local u1 = {}
    setmetatable(u1, u23)
    u1.name = a1
    u1.totalVolume = 0
    u1.parts = {}
    u1.partToItem = {}
    u1.items = {}
    u1.whitelistParams = nil
    u1.characters = {}
    u1.baseParts = {}
    u1.exitDetections = {}
    u1.janitor = Janitor.new()
    if a1 == "player" then
        local function updatePlayerCharacters() -- Line: 76 -- upvalues: Players (upval), u1 (val)
            local Character
            local v1 = {}
            for k, v in pairs(Players:GetPlayers()) do
                Character = v.Character
                if Character then
                    v1[Character] = true
                end
            end
            u1.characters = v1
        end

        local function playerAdded(a1) -- Line: 87 -- upvalues: updatePlayerCharacters (val), u1 (val)
            local function charAdded(a1) -- Line: 88 -- upvalues: updatePlayerCharacters (upval), u1 (upval)
                local HumanoidRootPart = a1:FindFirstChild("HumanoidRootPart")
                if not HumanoidRootPart then
                    local v1 = tick()
                    repeat
                        task.wait(0.1)
                    until (a1:FindFirstChild("HumanoidRootPart")) or 3 < tick() - v1
                end
                if HumanoidRootPart then
                    updatePlayerCharacters()
                    u1:update()
                end
            end

            if a1.Character then
                charAdded(a1.Character)
            end
            a1.CharacterAdded:Connect(charAdded)
            a1.CharacterRemoving:Connect(function(a1) -- Line: 107 -- upvalues: u1 (upval)
                u1.exitDetections[a1] = nil
            end)
        end

        Players.PlayerAdded:Connect(playerAdded)
        for k, v in pairs(Players:GetPlayers()) do
            playerAdded(v)
        end
        Players.PlayerRemoving:Connect(function(a1) -- Line: 117 -- upvalues: updatePlayerCharacters (val), u1 (val)
            updatePlayerCharacters()
            u1:update()
        end)
    elseif a1 == "item" then
        local function updateItem(a1, a2) -- Line: 124 -- upvalues: u1 (val)
            if a1.isCharacter then
                u1.characters[a1.item] = a2
            elseif a1.isBasePart then
                u1.baseParts[a1.item] = a2
            end
            u1:update()
        end

        u23.itemAdded:Connect(function(a1) -- Line: 132 -- upvalues: u1 (val)
            if a1.isCharacter then
                u1.characters[a1.item] = true
            elseif a1.isBasePart then
                u1.baseParts[a1.item] = true
            end
            u1:update()
        end)
        u23.itemRemoved:Connect(function(a1) -- Line: 135 -- upvalues: u1 (val)
            u1.exitDetections[a1.item] = nil
            if a1.isCharacter then
                u1.characters[a1.item] = nil
            elseif a1.isBasePart then
                u1.baseParts[a1.item] = nil
            end
            u1:update()
        end)
    end
    u24[u1] = true
    task.defer(u1.update, u1)
    return u1
end

function u23:_preventMultiFrameUpdates(a2, ...) -- Line: 149
    local _preventMultiDetails = self._preventMultiDetails or {}
    self._preventMultiDetails = _preventMultiDetails
    local u10 = self._preventMultiDetails[a2]
    if not u10 then
        u10 = {calling = false, callsThisFrame = 0, updatedThisFrame = false}
        self._preventMultiDetails[a2] = u10
    end
    u10.callsThisFrame = u10.callsThisFrame + 1
    if u10.callsThisFrame ~= 1 then
        return true
    end
    local u18 = table.pack(...)
    task.defer(function() -- Line: 166 -- upvalues: u10 (ref), self (val), a2 (val), u18 (val)
        local callsThisFrame = u10.callsThisFrame
        u10.callsThisFrame = 0
        if callsThisFrame > 1 then
            self[a2](self, unpack(u18))
        end
    end)
    return false
end

function u23:update() -- Line: 178 -- upvalues: u23 (val), Janitor (val)
    local Size, updateTrackerOnParentChanged, v1, v2, v3
    if self:_preventMultiFrameUpdates("update") then
        return
    end
    self.totalVolume = 0
    self.parts = {}
    self.partToItem = {}
    self.items = {}
    for k, v in pairs(self.characters) do
        v3 = u23.getCharacterSize(k)
        if v3 then
            self.totalVolume = self.totalVolume + v3.X * v3.Y * v3.Z
            local u82 = self.janitor:add(Janitor.new(), "destroy", "trackCharacterParts-" .. self.name)

            function updateTrackerOnParentChanged(a1) -- Line: 199 -- upvalues: u82 (ref), self (val)
                u82:add(a1.AncestryChanged:Connect(function() -- Line: 200 -- upvalues: a1 (val), u82 (upval), self (upval)
                    if not a1:IsDescendantOf(game) and a1.Parent == nil and u82 ~= nil then
                        u82:destroy()
                        u82 = nil
                        self:update()
                    end
                end), "Disconnect")
            end

            for k2, i in pairs(k:GetChildren()) do
                if i:IsA("BasePart") and not u23.bodyPartsToIgnore[i.Name] then
                    self.partToItem[i] = k
                    table.insert(self.parts, i)
                    v2 = i.AncestryChanged:Connect(function() -- Line: 200 -- upvalues: i (val), u82 (ref), self (val)
                        if not i:IsDescendantOf(game) and i.Parent == nil and u82 ~= nil then
                            u82:destroy()
                            u82 = nil
                            self:update()
                        end
                    end)
                    u82:add(v2, "Disconnect")
                end
            end
            v1 = k.AncestryChanged:Connect(function() -- Line: 200 -- upvalues: k (val), u82 (ref), self (val)
                if not k:IsDescendantOf(game) and k.Parent == nil and u82 ~= nil then
                    u82:destroy()
                    u82 = nil
                    self:update()
                end
            end)
            u82:add(v1, "Disconnect")
            table.insert(self.items, k)
        end
    end
    for k3, j in pairs(self.baseParts) do
        Size = k3.Size
        self.totalVolume = self.totalVolume + Size.X * Size.Y * Size.Z
        self.partToItem[k3] = k3
        table.insert(self.parts, k3)
        table.insert(self.items, k3)
    end
    self.whitelistParams = OverlapParams.new()
    self.whitelistParams.FilterType = Enum.RaycastFilterType.Whitelist
    self.whitelistParams.MaxParts = #self.parts
    self.whitelistParams.FilterDescendantsInstances = self.parts
end

return u23