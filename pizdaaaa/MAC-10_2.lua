-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.MAC-10
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.MAC-10
-- Decompile time: 5.47 ms

-- Decompiled with Potassium's decompiler.

return {
    Animations = script:GetChildren(),
    Rig = {
        name = "RootPart",
        c0 = CFrame.identity,
        c1 = CFrame.identity,
        children = {
            {
                name = "Right Arm",
                c0 = CFrame.new(
                    1.802773,
                    -1.392592,
                    -3.609528,
                    0.9891641,
                    -0.1467021,
                    -0.005741327,
                    0.1438991,
                    0.9765347,
                    -0.1602285,
                    0.02911246,
                    0.1576661,
                    0.9870632
                ),
                c1 = CFrame.new(-0.2660065, -0.00003433228, -1.84996),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.2316208,
                            0.4967308,
                            -1.833435,
                            0.9994194,
                            -0.01154344,
                            0.03205832,
                            0.008157612,
                            0.9945642,
                            0.103805,
                            -0.03308233,
                            -0.1034832,
                            0.9940809
                        ),
                        c1 = CFrame.identity,
                        children = {
                            {
                                name = "Slide1",
                                c0 = CFrame.new(0.02324677, 0.6641884, -0.4695587),
                                c1 = CFrame.identity
                            },
                            {
                                name = "Slide",
                                c0 = CFrame.new(0.2178345, 0.4421158, 0.01016235),
                                c1 = CFrame.new(-0.00009918213, 0.00003051758, 0.1890411)
                            }
                        }
                    }
                }
            },
            {
                name = "Mag",
                c0 = CFrame.new(
                    1.756958,
                    -0.7150415,
                    -3.233749,
                    0.9875828,
                    -0.1567295,
                    0.01077592,
                    0.157083,
                    0.9861467,
                    -0.05328877,
                    -0.002274717,
                    0.05431978,
                    0.998521
                ),
                c1 = CFrame.new(-7.629395e-6, 0.932003, 0)
            },
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    0.7003021,
                    -1.823502,
                    2.440048,
                    0.9747493,
                    -0.06724228,
                    -0.2129374,
                    0.2113226,
                    -0.03036174,
                    0.9769447,
                    -0.07215714,
                    -0.9972746,
                    -0.01538527
                ),
                c1 = CFrame.new(
                    0.282074,
                    -0.00004577637,
                    -1.831078,
                    1,
                    -6.936336e-6,
                    0.00001153982,
                    6.936466e-6,
                    1,
                    -0.00001118971,
                    -0.00001153974,
                    0.00001118979,
                    1
                )
            }
        }
    }
};