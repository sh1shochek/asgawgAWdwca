-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.P90
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.P90
-- Decompile time: 4.50 ms

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
                    1.514511,
                    -1.725819,
                    -2.967216,
                    0.9999157,
                    0.01298888,
                    0.0002446824,
                    -0.01295813,
                    0.9985366,
                    -0.05250328,
                    -0.0009262835,
                    0.05249568,
                    0.9986207
                ),
                c1 = CFrame.new(-0.2930145, 1.907349e-6, -1.851036),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.2107849,
                            0.3439164,
                            -1.453255,
                            0.9999156,
                            -0.01298781,
                            -0.0003018737,
                            0.01298891,
                            0.9999079,
                            0.003954369,
                            0.0002504873,
                            -0.003957957,
                            0.9999921
                        ),
                        c1 = CFrame.new(-7.629395e-6, -0.2330022, -0.5530167),
                        children = {
                            {
                                name = "Mag",
                                c0 = CFrame.new(7.629395e-6, 0.3518767, -1.405846),
                                c1 = CFrame.new(0, -9.536743e-7, -1.141006)
                            },
                            {
                                name = "Slide1",
                                c0 = CFrame.new(-0.1970024, 0.06663513, -1.58197),
                                c1 = CFrame.new(-0.1969986, -1.430511e-6, -7.629395e-6)
                            }
                        }
                    }
                }
            },
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    1.397743,
                    -1.779941,
                    -3.740135,
                    0.9433671,
                    0.05329417,
                    -0.3274421,
                    -0.1307982,
                    0.9668105,
                    -0.219475,
                    0.3048777,
                    0.2498743,
                    0.919028
                ),
                c1 = CFrame.new(
                    0.2560196,
                    5.722046e-6,
                    -1.848022,
                    1,
                    -0.00002138194,
                    0.00009652976,
                    0.00002138312,
                    1,
                    -0.00001217219,
                    -0.0000965295,
                    0.00001217425,
                    1
                )
            }
        }
    }
};