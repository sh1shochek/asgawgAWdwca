-- Decompiled with Potassium's decompiler.

local ServerScriptService = game:GetService("ServerScriptService");
require(ServerScriptService.TestRunner.Test);

local function AwaitCondition(p1: function, p2: number?) -- Line: 5
    local os_clock_ret = os.clock();
    local v3 = p2 or 10;

    while not p1() do
        if v3 < os.clock() - os_clock_ret then
            return false;
        end;

        task.wait();
    end;

    return true;
end;

return function(u4) -- Line: 19
    -- upvalues: AwaitCondition (copy)
    local script_Parent = require(script.Parent);
    local u5 = nil;

    local function NumConns(p6) -- Line: 24
        -- upvalues: u5 (ref)
        return #(p6 or u5):GetConnections();
    end;

    u4:BeforeEach(function() -- Line: 29
        -- upvalues: u5 (ref), script_Parent (copy)
        u5 = script_Parent.new();
    end);
    u4:AfterEach(function() -- Line: 33
        -- upvalues: u5 (ref)
        u5:Destroy();
    end);
    u4:Describe("Constructor", function() -- Line: 37
        -- upvalues: u4 (copy), script_Parent (copy), u5 (ref), AwaitCondition (ref)
        u4:Test("should create a new signal and fire it", function() -- Line: 38
            -- upvalues: u4 (ref), script_Parent (ref), u5 (ref)
            u4:Expect(script_Parent.Is(u5)):ToBe(true);
            task.defer(function() -- Line: 40
                -- upvalues: u5 (ref)
                u5:Fire(10, 20);
            end);
            local v7, v8 = u5:Wait();
            u4:Expect(v7):ToBe(10);
            u4:Expect(v8):ToBe(20);
        end);
        u4:Test("should create a proxy signal and connect to it", function() -- Line: 48
            -- upvalues: script_Parent (ref), u4 (ref), AwaitCondition (ref)
            local v9 = script_Parent.Wrap(game:GetService("RunService").Heartbeat);
            u4:Expect(script_Parent.Is(v9)):ToBe(true);
            local u10 = false;
            v9:Connect(function() -- Line: 52
                -- upvalues: u10 (ref)
                u10 = true;
            end);
            u4:Expect(AwaitCondition(function() -- Line: 55
                -- upvalues: u10 (ref)
                return u10;
            end, 2)):ToBe(true);
            v9:Destroy();
        end);
    end);
    u4:Describe("FireDeferred", function() -- Line: 62
        -- upvalues: u4 (copy), u5 (ref), AwaitCondition (ref)
        u4:Test("should be able to fire primitive argument", function() -- Line: 63
            -- upvalues: u5 (ref), u4 (ref), AwaitCondition (ref)
            local u11 = nil;
            u5:Connect(function(p12) -- Line: 66
                -- upvalues: u11 (ref)
                u11 = p12;
            end);
            u5:FireDeferred(10);
            u4:Expect(AwaitCondition(function() -- Line: 70
                -- upvalues: u11 (ref)
                return u11 == 10;
            end, 1)):ToBe(true);
        end);
        u4:Test("should be able to fire a reference based argument", function() -- Line: 75
            -- upvalues: u5 (ref), u4 (ref), AwaitCondition (ref)
            local u13 = { 10, 20 };
            local u14 = nil;
            u5:Connect(function(p15) -- Line: 78
                -- upvalues: u14 (ref)
                u14 = p15;
            end);
            u5:FireDeferred(u13);
            u4:Expect(AwaitCondition(function() -- Line: 82
                -- upvalues: u13 (copy), u14 (ref)
                return u13 == u14;
            end, 1)):ToBe(true);
        end);
    end);
    u4:Describe("Fire", function() -- Line: 88
        -- upvalues: u4 (copy), u5 (ref)
        u4:Test("should be able to fire primitive argument", function() -- Line: 89
            -- upvalues: u5 (ref), u4 (ref)
            local u16 = nil;
            u5:Connect(function(p17) -- Line: 92
                -- upvalues: u16 (ref)
                u16 = p17;
            end);
            u5:Fire(10);
            u4:Expect(u16):ToBe(10);
        end);
        u4:Test("should be able to fire a reference based argument", function() -- Line: 99
            -- upvalues: u5 (ref), u4 (ref)
            local v18 = { 10, 20 };
            local u19 = nil;
            u5:Connect(function(p20) -- Line: 102
                -- upvalues: u19 (ref)
                u19 = p20;
            end);
            u5:Fire(v18);
            u4:Expect(u19):ToBe(v18);
        end);
    end);
    u4:Describe("ConnectOnce", function() -- Line: 110
        -- upvalues: u4 (copy), u5 (ref)
        u4:Test("should only capture first fire", function() -- Line: 111
            -- upvalues: u5 (ref), u4 (ref)
            local u21 = nil;
            local v23 = u5:ConnectOnce(function(p22) -- Line: 113
                -- upvalues: u21 (ref)
                u21 = p22;
            end);
            u4:Expect(v23.Connected):ToBe(true);
            u5:Fire(10);
            u4:Expect(v23.Connected):ToBe(false);
            u5:Fire(20);
            u4:Expect(u21):ToBe(10);
        end);
    end);
    u4:Describe("Wait", function() -- Line: 124
        -- upvalues: u4 (copy), u5 (ref)
        u4:Test("should be able to wait for a signal to fire", function() -- Line: 125
            -- upvalues: u5 (ref), u4 (ref)
            task.defer(function() -- Line: 126
                -- upvalues: u5 (ref)
                u5:Fire(10, 20, 30);
            end);
            local v24, v25, v26 = u5:Wait();
            u4:Expect(v24):ToBe(10);
            u4:Expect(v25):ToBe(20);
            u4:Expect(v26):ToBe(30);
        end);
    end);
    u4:Describe("DisconnectAll", function() -- Line: 136
        -- upvalues: u4 (copy), u5 (ref)
        u4:Test("should disconnect all connections", function() -- Line: 137
            -- upvalues: u5 (ref), u4 (ref)
            u5:Connect(function() -- Line: 138
            end);
            u5:Connect(function() -- Line: 139
            end);
            u4:Expect(#(nil or u5):GetConnections()):ToBe(2);
            u5:DisconnectAll();
            u4:Expect(#(nil or u5):GetConnections()):ToBe(0);
        end);
    end);
    u4:Describe("Disconnect", function() -- Line: 146
        -- upvalues: u4 (copy), u5 (ref), AwaitCondition (ref)
        u4:Test("should disconnect connection", function() -- Line: 147
            -- upvalues: u5 (ref), u4 (ref)
            local v27 = u5:Connect(function() -- Line: 148
            end);
            u4:Expect(#(nil or u5):GetConnections()):ToBe(1);
            v27:Disconnect();
            u4:Expect(#(nil or u5):GetConnections()):ToBe(0);
        end);
        u4:Test("should still work if connections disconnected while firing", function() -- Line: 154
            -- upvalues: u5 (ref), u4 (ref)
            local u28 = 0;
            local u29 = nil;
            u5:Connect(function() -- Line: 157
                -- upvalues: u28 (ref)
                u28 = u28 + 1;
            end);
            u29 = u5:Connect(function() -- Line: 160
                -- upvalues: u29 (ref), u28 (ref)
                u29:Disconnect();
                u28 = u28 + 1;
            end);
            u5:Connect(function() -- Line: 164
                -- upvalues: u28 (ref)
                u28 = u28 + 1;
            end);
            u5:Fire();
            u4:Expect(u28):ToBe(3);
        end);
        u4:Test("should still work if connections disconnected while firing deferred", function() -- Line: 171
            -- upvalues: u5 (ref), u4 (ref), AwaitCondition (ref)
            local u30 = 0;
            local u31 = nil;
            u5:Connect(function() -- Line: 174
                -- upvalues: u30 (ref)
                u30 = u30 + 1;
            end);
            u31 = u5:Connect(function() -- Line: 177
                -- upvalues: u31 (ref), u30 (ref)
                u31:Disconnect();
                u30 = u30 + 1;
            end);
            u5:Connect(function() -- Line: 181
                -- upvalues: u30 (ref)
                u30 = u30 + 1;
            end);
            u5:FireDeferred();
            u4:Expect(AwaitCondition(function() -- Line: 185
                -- upvalues: u30 (ref)
                return u30 == 3;
            end)):ToBe(true);
        end);
    end);
end;