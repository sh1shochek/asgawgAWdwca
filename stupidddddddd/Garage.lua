-- ReplicatedStorage.Controllers.Observers.Game.Garage
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Garage
-- Decompile time: 2.02 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MoverTrajectory = require(ReplicatedStorage.MovementV2.MoverTrajectory)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Sound = require(ReplicatedStorage.Classes.Sound)

local function playGarageSound(a1, a2) -- Line: 10 -- upvalues: Sound (val) -- types: a1: userdata, a2: boolean
    (Sound.new("Miscellaneous")):playOneTime({Parent = a1, Name = if not a2 then "Close Garage" else "Open Garage"})
end

return Observers.observeTag("Garage", function(a1) -- Line: 18 -- upvalues: MoverTrajectory (val), RunService (val), Sound (val) -- types: a1: userdata
    if not a1:IsDescendantOf(workspace) then
        return nil
    end
    local Handle = a1:FindFirstChild("Handle")
    if Handle ~= nil and Handle:IsA("BasePart") then
        local u14 = nil
        local u62 = nil
        local u16 = true

        local function disconnectRender() -- Line: 31 -- upvalues: u62 (ref)
            if u62 ~= nil then
                u62:Disconnect()
                u62 = nil
            end
        end

        local function applyPose() -- Line: 38 -- upvalues: u14 (ref), Handle (val), u62 (ref), MoverTrajectory (upval)
            if u14 ~= nil and Handle.Parent ~= nil then
                local ServerTimeNow = workspace:GetServerTimeNow()
                Handle.CFrame = MoverTrajectory.EvaluateTime(u14, ServerTimeNow)
                if not u14.Moving then
                    if u62 ~= nil then
                        u62:Disconnect()
                        u62 = nil
                    end
                elseif 1 <= (MoverTrajectory.TimeAlpha(u14, ServerTimeNow)) and u62 ~= nil then
                    u62:Disconnect()
                    u62 = nil
                end
                return
            end
            if u62 ~= nil then
                u62:Disconnect()
                u62 = nil
            end
        end

        local function refreshTrajectory() -- Line: 50
            -- upvalues: MoverTrajectory (upval), Handle (val), u14 (ref), u62 (ref), RunService (upval)
            -- upvalues: applyPose (val)
            local v1 = MoverTrajectory.Read(Handle)
            if v1 == nil then
                return
            end
            u14 = v1
            if u62 ~= nil then
                u62:Disconnect()
                u62 = nil
            end
            if v1.Moving then
                u62 = RunService.RenderStepped:Connect(applyPose)
            end
            applyPose()
        end

        local u29 = (Handle:GetAttributeChangedSignal(MoverTrajectory.Attributes.Revision)):Connect(refreshTrajectory)
        local u39 = (Handle:GetAttributeChangedSignal(MoverTrajectory.Attributes.Id)):Connect(refreshTrajectory)
        local u45 = MoverTrajectory.ClientDescriptorChanged:Connect(function(a1) -- Line: 66
            -- upvalues: Handle (val), MoverTrajectory (upval), u14 (ref), u62 (ref), RunService (upval)
            -- upvalues: applyPose (val)
            local v1 = Handle
            if v1:GetAttribute(MoverTrajectory.Attributes.Id) == a1 then
                v1 = MoverTrajectory.Read(Handle)
                if v1 == nil then
                    return
                end
                u14 = v1
                if u62 ~= nil then
                    u62:Disconnect()
                    u62 = nil
                end
                if v1.Moving then
                    u62 = RunService.RenderStepped:Connect(applyPose)
                end
                applyPose()
            end
        end)
        local u53 = (a1:GetAttributeChangedSignal("CurrentState")):Connect(function() -- Line: 71 -- upvalues: u16 (ref), Handle (val), a1 (val), Sound (upval)
            if not u16 then
                local v1 = a1:GetAttribute("CurrentState") == true
                ;(Sound.new("Miscellaneous")):playOneTime({Parent = Handle, Name = if not v1 then "Close Garage" else "Open Garage"})
            end
            u16 = false
        end)
        local v1 = MoverTrajectory.Read(Handle)
        if v1 ~= nil then
            if u62 ~= nil then
                u62:Disconnect()
                u62 = nil
            end
            if v1.Moving then
                u62 = RunService.RenderStepped:Connect(applyPose)
            end
            applyPose()
        end
        return function() -- Line: 80 -- upvalues: u62 (ref), u29 (val), u39 (val), u45 (val), u53 (val)
            if u62 ~= nil then
                u62:Disconnect()
                u62 = nil
            end
            u29:Disconnect()
            u39:Disconnect()
            u45:Disconnect()
            u53:Disconnect()
        end
    end
    return nil
end)