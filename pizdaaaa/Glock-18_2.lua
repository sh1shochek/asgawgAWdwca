-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.Glock-18
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.Glock-18
-- Decompile time: 6.58 ms

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
                    1.233957,
                    -1.568382,
                    -2.851444,
                    0.9996353,
                    -0.02590103,
                    -0.00764725,
                    0.02560207,
                    0.9989911,
                    -0.03689782,
                    0.008595225,
                    0.03668858,
                    0.9992899
                ),
                c1 = CFrame.new(-0.2680073, -3.814697e-6, -1.840008),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.226593,
                            0.2524309,
                            -2.136078,
                            0.9995848,
                            0.02727087,
                            0.009310503,
                            -0.02759864,
                            0.9989302,
                            0.03710688,
                            -0.008288605,
                            -0.03734843,
                            0.9992679
                        ),
                        c1 = CFrame.new(0, 0.004999099, -0.01262664),
                        children = {
                            {
                                name = "Mag",
                                c0 = CFrame.new(0.001410907, -0.1782282, 0.5204402),
                                c1 = CFrame.identity
                            },
                            {
                                name = "Slide1",
                                c0 = CFrame.new(0.002469087, 0.3853208, -0.007206847),
                                c1 = CFrame.identity
                            }
                        }
                    }
                }
            },
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    1.16552,
                    -1.753506,
                    -2.801788,
                    0.8813658,
                    -0.2756662,
                    -0.3836698,
                    0.2125485,
                    0.9566541,
                    -0.1990884,
                    0.4219212,
                    0.09392131,
                    0.9017546
                ),
                c1 = CFrame.new(0.2730045, 4.768372e-7, -1.870987)
            }
        }
    }
};