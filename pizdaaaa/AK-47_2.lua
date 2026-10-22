-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Rifles.AK-47
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Rifles.AK-47
-- Decompile time: 5.24 ms

-- Decompiled with Potassium's decompiler.

return {
    Animations = script:GetChildren(),
    Rig = {
        name = "RootPart",
        c0 = CFrame.identity,
        c1 = CFrame.identity,
        children = {
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    1.169006,
                    -1.218989,
                    -4.39032,
                    0.7941709,
                    -0.4745012,
                    -0.3796595,
                    0.3379343,
                    0.8640819,
                    -0.3730455,
                    0.5050675,
                    0.1679619,
                    0.8465788
                ),
                c1 = CFrame.new(
                    -0.07305805,
                    -0.04175,
                    -2.199716,
                    0.9806551,
                    0.1947423,
                    -0.01977455,
                    -0.1953711,
                    0.9800113,
                    -0.03752281,
                    0.012072,
                    0.04066031,
                    0.9991001
                )
            },
            {
                name = "Right Arm",
                c0 = CFrame.new(
                    1.632263,
                    -1.518614,
                    -1.981506,
                    0.9969606,
                    -0.01650391,
                    -0.07613967,
                    0.01452424,
                    0.9995438,
                    -0.02648139,
                    0.07654198,
                    0.02529503,
                    0.9967455
                ),
                c1 = CFrame.new(
                    0,
                    0,
                    -1.899963,
                    1,
                    2.478466e-6,
                    0.00001104174,
                    -2.478477e-6,
                    1,
                    9.741352e-7,
                    -0.00001104174,
                    -9.741625e-7,
                    1
                ),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.2933655,
                            0.5620384,
                            -1.486816,
                            0.9997841,
                            0.02077823,
                            0.0003505861,
                            -0.02078017,
                            0.9994254,
                            0.02678268,
                            0.0002061121,
                            -0.02678419,
                            0.9996412
                        ),
                        c1 = CFrame.new(
                            -0.03567864,
                            0.1247823,
                            1.335688,
                            0.9989553,
                            4.411314e-7,
                            -0.04569882,
                            -5.61868e-7,
                            1,
                            -2.629171e-6,
                            0.04569882,
                            2.652101e-6,
                            0.9989553
                        ),
                        children = {
                            {
                                name = "Mag",
                                c0 = CFrame.new(-0.01437909, 0.02323045, 0.181157),
                                c1 = CFrame.new(-0.01907419, 0.519389, 0.2680543)
                            },
                            {
                                name = "Slide1",
                                c0 = CFrame.new(0.2112847, 0.5049567, 0.005151694),
                                c1 = CFrame.new(0.08617767, 0.05104051, -0.05648953)
                            }
                        }
                    }
                }
            }
        }
    }
};