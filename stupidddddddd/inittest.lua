-- ReplicatedStorage.Packages._Index.sleitnick_signal@2.0.3.signal.init.test
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_signal@2.0.3.signal.init.test
-- Decompile time: 2.88 ms

local ServerScriptService = game:GetService("ServerScriptService")
require(ServerScriptService.TestRunner.Test)

local function AwaitCondition(a1, a2) -- Line: 5 -- types: a1: function, a2: number?
    local v1 = os.clock()
    while not a1() do
        if (a2 or 10) < os.clock() - v1 then
            return false
        end
        task.wait()
    end
    return true
end

return function(a1) -- Line: 19 -- upvalues: AwaitCondition (val)
    local Parent = require(script.Parent)
    local u5 = nil

    local function NumConns(a1) -- Line: 24 -- upvalues: u5 (ref)
        return #(a1 or u5):GetConnections()
    end

    a1:BeforeEach(function() -- Line: 29 -- upvalues: u5 (ref), Parent (val)
        u5 = Parent.new()
    end)
    a1:AfterEach(function() -- Line: 33 -- upvalues: u5 (ref)
        u5:Destroy()
    end)
    a1:Describe("Constructor", function() -- Line: 37 -- upvalues: a1 (val), Parent (val), u5 (ref), AwaitCondition (upval)
        a1:Test("should create a new signal and fire it", function() -- Line: 38 -- upvalues: a1 (upval), Parent (upval), u5 (upval)
            local v1 = u5
            ;(a1:Expect((Parent.Is(v1)))):ToBe(true)
            task.defer(function() -- Line: 40 -- upvalues: u5 (upval)
                u5:Fire(10, 20)
            end)
            local v2, v3 = u5:Wait()
            ;(a1:Expect(v2)):ToBe(10)
            ;(a1:Expect(v3)):ToBe(20)
        end)
        a1:Test("should create a proxy signal and connect to it", function() -- Line: 48 -- upvalues: Parent (upval), a1 (upval), AwaitCondition (upval)
            local v1 = Parent.Wrap(game:GetService("RunService").Heartbeat)
            ;(a1:Expect((Parent.Is(v1)))):ToBe(true)
            local u21 = false
            v1:Connect(function() -- Line: 52 -- upvalues: u21 (ref)
                u21 = true
            end)
            ;(a1:Expect((AwaitCondition(function() -- Line: 55 -- upvalues: u21 (ref)
                return u21
            end, 2)))):ToBe(true)
            v1:Destroy()
        end)
    end)
    a1:Describe("FireDeferred", function() -- Line: 62 -- upvalues: a1 (val), u5 (ref), AwaitCondition (upval)
        a1:Test("should be able to fire primitive argument", function() -- Line: 63 -- upvalues: u5 (upval), a1 (upval), AwaitCondition (upval)
            local u0 = nil
            u5:Connect(function(a1) -- Line: 66 -- upvalues: u0 (ref)
                u0 = a1
            end)
            u5:FireDeferred(10)
            ;(a1:Expect((AwaitCondition(function() -- Line: 70 -- upvalues: u0 (ref)
                return u0 == 10
            end, 1)))):ToBe(true)
        end)
        a1:Test("should be able to fire a reference based argument", function() -- Line: 75 -- upvalues: u5 (upval), a1 (upval), AwaitCondition (upval)
            local u0 = {10, 20}
            local u3 = nil
            u5:Connect(function(a1) -- Line: 78 -- upvalues: u3 (ref)
                u3 = a1
            end)
            u5:FireDeferred(u0)
            ;(a1:Expect((AwaitCondition(function() -- Line: 82 -- upvalues: u0 (val), u3 (ref)
                return u0 == u3
            end, 1)))):ToBe(true)
        end)
    end)
    a1:Describe("Fire", function() -- Line: 88 -- upvalues: a1 (val), u5 (ref)
        a1:Test("should be able to fire primitive argument", function() -- Line: 89 -- upvalues: u5 (upval), a1 (upval)
            local u0 = nil
            u5:Connect(function(a1) -- Line: 92 -- upvalues: u0 (ref)
                u0 = a1
            end)
            u5:Fire(10)
            local v1 = u0
            ;(a1:Expect(v1)):ToBe(10)
        end)
        a1:Test("should be able to fire a reference based argument", function() -- Line: 99 -- upvalues: u5 (upval), a1 (upval)
            local v1 = {10, 20}
            local u3 = nil
            u5:Connect(function(a1) -- Line: 102 -- upvalues: u3 (ref)
                u3 = a1
            end)
            u5:Fire(v1)
            local v2 = u3
            ;(a1:Expect(v2)):ToBe(v1)
        end)
    end)
    a1:Describe("ConnectOnce", function() -- Line: 110 -- upvalues: a1 (val), u5 (ref)
        a1:Test("should only capture first fire", function() -- Line: 111 -- upvalues: u5 (upval), a1 (upval)
            local u0 = nil
            local v1 = u5:ConnectOnce(function(a1) -- Line: 113 -- upvalues: u0 (ref)
                u0 = a1
            end)
            ;(a1:Expect(v1.Connected)):ToBe(true)
            u5:Fire(10)
            ;(a1:Expect(v1.Connected)):ToBe(false)
            u5:Fire(20)
            local v2 = u0
            ;(a1:Expect(v2)):ToBe(10)
        end)
    end)
    a1:Describe("Wait", function() -- Line: 124 -- upvalues: a1 (val), u5 (ref)
        a1:Test("should be able to wait for a signal to fire", function() -- Line: 125 -- upvalues: u5 (upval), a1 (upval)
            task.defer(function() -- Line: 126 -- upvalues: u5 (upval)
                u5:Fire(10, 20, 30)
            end)
            local v1, v2, v3 = u5:Wait()
            ;(a1:Expect(v1)):ToBe(10)
            ;(a1:Expect(v2)):ToBe(20)
            ;(a1:Expect(v3)):ToBe(30)
        end)
    end)
    a1:Describe("DisconnectAll", function() -- Line: 136 -- upvalues: a1 (val), u5 (ref)
        a1:Test("should disconnect all connections", function() -- Line: 137 -- upvalues: u5 (upval), a1 (upval)
            u5:Connect(function() end)
            u5:Connect(function() end)
            ;(a1:Expect(#(u5:GetConnections()))):ToBe(2)
            u5:DisconnectAll()
            ;(a1:Expect(#(u5:GetConnections()))):ToBe(0)
        end)
    end)
    a1:Describe("Disconnect", function() -- Line: 146 -- upvalues: a1 (val), u5 (ref), AwaitCondition (upval)
        a1:Test("should disconnect connection", function() -- Line: 147 -- upvalues: u5 (upval), a1 (upval)
            local v1 = u5:Connect(function() end)
            ;(a1:Expect(#(u5:GetConnections()))):ToBe(1)
            v1:Disconnect()
            ;(a1:Expect(#(u5:GetConnections()))):ToBe(0)
        end)
        a1:Test("should still work if connections disconnected while firing", function() -- Line: 154 -- upvalues: u5 (upval), a1 (upval)
            local u0 = 0
            local u1 = nil
            u5:Connect(function() -- Line: 157 -- upvalues: u0 (ref)
                u0 = u0 + 1
            end)
            local v1 = u5:Connect(function() -- Line: 160 -- upvalues: u1 (ref), u0 (ref)
                u1:Disconnect()
                u0 = u0 + 1
            end)
            u5:Connect(function() -- Line: 164 -- upvalues: u0 (ref)
                u0 = u0 + 1
            end)
            u5:Fire()
            local v2 = u0
            ;(a1:Expect(v2)):ToBe(3)
        end)
        a1:Test("should still work if connections disconnected while firing deferred", function() -- Line: 171 -- upvalues: u5 (upval), a1 (upval), AwaitCondition (upval)
            local u0 = 0
            local u1 = nil
            u5:Connect(function() -- Line: 174 -- upvalues: u0 (ref)
                u0 = u0 + 1
            end)
            local v1 = u5:Connect(function() -- Line: 177 -- upvalues: u1 (ref), u0 (ref)
                u1:Disconnect()
                u0 = u0 + 1
            end)
            u5:Connect(function() -- Line: 181 -- upvalues: u0 (ref)
                u0 = u0 + 1
            end)
            u5:FireDeferred()
            ;(a1:Expect((AwaitCondition(function() -- Line: 185 -- upvalues: u0 (ref)
                return u0 == 3
            end)))):ToBe(true)
        end)
    end)
end