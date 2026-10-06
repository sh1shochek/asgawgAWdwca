-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
u1.Descriptions = {
    Video = "Configure visual quality, performance settings, and display options to optimize your gaming experience. Adjust frame rate limits, graphics quality, and rendering settings to balance visual fidelity with smooth performance. Fine-tune these settings based on your hardware capabilities to achieve the best possible gameplay experience.",
    Audio = "Adjust volume levels for game sounds, music, and voice chat to create your ideal audio environment. Fine-tune your audio experience for optimal situational awareness during gameplay, ensuring you can hear enemy footsteps, gunfire, and other critical sound cues. Customize audio output settings to match your headphones or speaker setup for the best immersive experience.",
    Game = "Customize your HUD, crosshair, radar, and other gameplay elements to match your playstyle and preferences. Modify interface transparency, element positioning, and visual indicators to create a clean and efficient gaming environment. Tailor these settings to reduce visual clutter and improve your reaction time during intense combat situations.",
    Keybinds = "Rebind keyboard, mouse, and controller inputs to your preferred layout for maximum comfort and efficiency. Customize movement controls, weapon selection, utility bindings, and action keys to match your muscle memory and playstyle. Create a personalized control scheme that allows for quick reactions and smooth execution of complex maneuvers during gameplay."
};
u1.Video = {
    _Divider_Presets_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Presets",
        Order = 1
    },
    ["Texture Quality"] = {
        Type = "Dropdown",
        Template = "DropdownTemplate",
        Default = "High",
        Category = "Presets",
        Description = "Controls the resolution and detail level of textures on surfaces throughout the game. Higher quality textures look better but require more video memory. Low settings are recommended for systems with 2GB or less VRAM.",
        IsEnabled = false,
        Order = 2,
        Enums = { "Low", "Medium", "High", "Ultra" }
    },
    _Divider_Presets_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Presets",
        Order = 3
    },
    ["Global Shadows"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Presets",
        Description = "Enables dynamic shadows from players, props, and other objects in the game world. Disabling shadows can significantly improve performance on lower-end systems but reduces visual quality and situational awareness.",
        Order = 4
    },
    _Divider_Presets_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Presets",
        Order = 5
    },
    ["Glass Shatter"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Presets",
        Description = "Enables glass breaking effects when shooting or impacting glass surfaces. Disabling this can improve performance and reduce visual clutter during intense firefights.",
        Order = 6
    },
    _Divider_Presets_5 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Presets",
        Order = 7
    },
    ["First Person Tracers"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Presets",
        Description = "Shows bullet tracer lines from your own weapon in first-person view. Tracers help you see the trajectory of your shots and adjust your aim. Disabling this can reduce visual clutter and improve FPS.",
        Order = 8
    },
    _Divider_Presets_6 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Presets",
        Order = 9
    },
    ["Muzzle Flash"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Presets",
        Description = "Enables muzzle flash effects when firing weapons. Muzzle flash helps identify enemy positions but can be distracting. Disabling improves visibility during sustained fire.",
        Order = 10
    },
    _Divider_Presets_7 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Presets",
        Order = 11
    },
    Ragdolls = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Presets",
        Description = "Enables ragdoll physics for player deaths and character models. When disabled, characters will disappear immediately upon death, which can improve performance but reduces visual feedback during combat.",
        Order = 12
    },
    _Divider_Presets_8 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Presets",
        Order = 13
    },
    ["Potato Mode"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "Presets",
        Description = "Maximum performance mode for low-end devices. Uses default Roblox materials, removes map textures, prop shadows, bloom, sun rays, depth of field and clouds, stops animated map props, and switches off Global Shadows, Glass Shatter, First Person Tracers, Muzzle Flash, and Ragdolls. Removed content only comes back after you rejoin.",
        Order = 14,
        DisplayName = "Potato Mode ⚡🥔"
    },
    _Divider_Advanced_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Advanced",
        Description = nil,
        IsEnabled = false,
        Order = 1
    },
    ["Aspect Ratio"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 1,
        Min = 0.5,
        Max = 1,
        Step = 0.01,
        Category = "Advanced",
        Description = "Stretches the game view horizontally, like playing 4:3 stretched. 1.0 is your screen\'s native aspect ratio and 0.5 is a full 4:3 stretch (on a 4:3 or 16:10 screen, the same stretch a 16:9 screen gets): players and objects look wider, and you see less to the sides.",
        Order = 2
    },
    _Divider_Advanced_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Advanced",
        IsEnabled = false,
        Order = 3
    },
    ["Maximum Render FPS In Game"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 400,
        Min = 30,
        Max = 1000,
        Step = 10,
        Category = "Advanced",
        Description = "Sets the maximum frames per second the game will render while playing. Higher values provide smoother gameplay but require more powerful hardware. If you experience performance issues, try lowering this value.",
        IsEnabled = false,
        Order = 4
    },
    _Divider_Advanced_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Advanced",
        IsEnabled = false,
        Order = 5
    },
    ["Maximum Render FPS In Menu"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 200,
        Min = 30,
        Max = 500,
        Step = 10,
        Category = "Advanced",
        Description = "Sets the maximum frames per second the game will render in menus. Lower values can reduce power consumption and heat generation while not actively playing.",
        IsEnabled = false,
        Order = 6
    }
};
u1.Audio = {
    _Divider_Audio_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Audio",
        Order = 1
    },
    ["Master Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 100,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Audio",
        Description = "Sets the overall volume level for all game audio. This is the master control that affects all other volume settings proportionally. Adjust this first to set a comfortable base level, then fine-tune individual categories like music, voice chat, and sound effects. Lowering the master volume won\'t affect the relative balance between different sound types.",
        Order = 2
    },
    _Divider_Audio_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Audio",
        IsEnabled = false,
        Order = 3
    },
    ["Voice Chat Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 100,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Audio",
        Description = "Controls the volume level of voice communications from other players. Adjust this setting to balance voice chat against game sounds and music. Set it higher if you\'re having trouble hearing teammate callouts, or lower if voice chat is too loud compared to game audio. This setting does not affect your microphone output level, only what you hear from others during matches and in lobby.",
        IsEnabled = false,
        Order = 4
    },
    _Divider_Audio_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Audio",
        Order = 5
    },
    ["Main Menu Ambience Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 100,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Audio",
        Description = "Adjusts the volume of ambient background sounds in the main menu, including environmental audio and atmospheric effects. These subtle sounds create ambience while you\'re navigating menus and customizing your loadout. Many players prefer to keep this lower to reduce distraction while browsing the menus or discussing strategy with teammates between matches.",
        Order = 6
    },
    _Divider_Music_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        Order = 1
    },
    ["Main Menu Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Sets the volume level of music played in the main menu and during match intermissions. This includes background music, lobby sounds, and the music in the buy menu. Adjusting this won\'t affect in-game sounds like footsteps, gunshots, or voice chat. Many competitive players prefer to keep menu music lower or muted entirely to avoid distraction while strategizing between rounds.",
        Order = 2
    },
    _Divider_Music_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        Order = 3
    },
    ["Round Start Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Controls the volume of music that plays at the beginning of each round when both teams are preparing their strategy. This brief musical cue helps set the tone for the round ahead. Setting this to zero will disable round start music, allowing you to focus purely on voice communications and sound cues during the crucial opening seconds.",
        Order = 4
    },
    _Divider_Music_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        Order = 5
    },
    ["Round Action Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Sets the volume for dynamic music that plays during intense moments of the round, such as when the bomb has been planted or when few players remain alive. This adaptive music responds to the action and tension of the match. Most competitive players keep this at zero to maintain full focus on tactical audio cues like footsteps and weapon sounds.",
        Order = 6
    },
    _Divider_Music_4 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        Order = 7
    },
    ["Round End Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Adjusts the volume of music that plays when a round concludes, whether by elimination, time expiration, or objective completion. This victory or defeat music plays during the brief freeze period after the round ends. Setting this lower allows you to hear post-round voice communications more clearly while your team discusses what happened.",
        Order = 8
    },
    _Divider_Music_5 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        Order = 9
    },
    ["MVP Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Controls the volume of the MVP anthem that plays when a player is awarded the Most Valuable Player distinction for their performance in the previous round. This music can be customized with different music kits. While entertaining, many competitive players keep this relatively low so it doesn\'t interfere with strategic discussions during the buy phase.",
        Order = 10
    },
    _Divider_Music_6 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        Order = 11
    },
    ["Bomb/Hostage Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Sets the volume for music specifically tied to bomb and hostage scenarios, including the tense music that plays as the bomb timer counts down. This music helps create dramatic tension during these critical objective-focused moments. The bomb beeping sound itself is controlled separately and won\'t be affected by this setting.",
        Order = 12
    },
    _Divider_Music_7 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        IsEnabled = false,
        Order = 13
    },
    ["Ten Second Warning Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Controls the volume of the distinct audio cue that plays when only ten seconds remain in the round timer or bomb countdown. This urgent warning helps players track time without checking the display. It\'s an important tactical cue that signals the need for immediate action, whether that\'s rushing to plant/defuse or taking a position.",
        IsEnabled = false,
        Order = 14
    },
    _Divider_Music_8 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Music",
        IsEnabled = false,
        Order = 15
    },
    ["Death Camera Volume"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 50,
        Min = 0,
        Max = 100,
        Step = 1,
        Category = "Music",
        Description = "Adjusts the volume of music that plays when you\'re spectating teammates after being eliminated. This somber music accompanies the death camera and spectator view. Some players prefer this lower so they can better hear what\'s happening in the match and provide useful information to surviving teammates via voice chat.",
        IsEnabled = false,
        Order = 16
    },
    _Divider_Voice_Chat_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Voice Chat",
        Order = 1
    },
    ["Voice Chat Activation Mode"] = {
        Type = "Dropdown",
        Template = "DropdownTemplate",
        Default = "Open Microphone",
        Category = "Voice Chat",
        Description = "How your microphone is activated in voice chat",
        Order = 2,
        Enums = { "Disabled", "Push To Talk", "Open Microphone" }
    },
    _Divider_Other_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 1
    },
    ["Mute MVP Music when players on both teams are alive"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "Other",
        Description = "When enabled, MVP music will not play at the start of the next round if all players on both teams are still alive. This prevents the music from potentially masking important audio cues during the opening moments of the round. Useful for competitive players who want to maintain maximum auditory awareness throughout the match without musical interruption.",
        Order = 2
    }
};
u1.Game = {
    _Divider_Item_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Item",
        Order = 1
    },
    ["Auto Re-Zoom Sniper Rifle after Shot"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Item",
        Description = "Automatically re-zoom after firing a sniper rifle",
        Order = 2
    },
    _Divider_Item_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Item",
        Order = 3
    },
    ["Detach Silencer on M4A1-S and USP-S"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "Item",
        Description = "Allow detaching silencers from M4A1-S and USP-S",
        Order = 4
    },
    _Divider_Item_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Item",
        Order = 5
    },
    ["Always Show Inventory"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Item",
        Description = "Always display inventory on screen",
        Order = 6
    },
    _Divider_Item_4 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Item",
        Order = 7
    },
    ["Auto Pickup Dropped Weapons"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Item",
        Description = "Automatically pick up weapons when you walk near them",
        Order = 8
    },
    _Divider_HUD_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        Order = 1
    },
    Scale = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 1,
        Min = 0.5,
        Max = 2,
        Step = 0.1,
        Category = "HUD",
        Description = "Scale of the HUD elements",
        Platform = "PC",
        Order = 2
    },
    _Divider_HUD_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        Order = 3
    },
    Color = {
        Type = "Dropdown",
        Template = "DropdownTemplate",
        Default = "Team Color",
        Category = "HUD",
        Description = "Color scheme for HUD elements",
        Order = 4,
        Enums = { "Team Color", "Bright White", "Light Blue", "Purple", "Yellow", "White", "Pink", "Orange", "Aqua", "Blue", "Green", "Red" }
    },
    _Divider_HUD_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        IsEnabled = false,
        Order = 5
    },
    ["Player Pings"] = {
        Type = "Dropdown",
        Template = "DropdownTemplate",
        Default = "Display and Play Sound",
        Category = "HUD",
        Description = "Configure player pings and how they\'re displayed",
        Order = 6,
        Enums = { "Display and Play Sound", "Display Without Sound", "Disabled" }
    },
    _Divider_HUD_4 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        IsEnabled = false,
        Order = 7
    },
    ["Override Spectating HUD Color"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "HUD",
        Description = "Use custom HUD color when spectating",
        IsEnabled = false,
        Order = 8
    },
    _Divider_HUD_5 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        Order = 9
    },
    ["Glow Weapon with Rarity Color"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "HUD",
        Description = "Make weapons glow with their rarity color",
        Order = 10
    },
    _Divider_HUD_6 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        Order = 11
    },
    ["System Chat Messages"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "HUD",
        Description = "Show system chat messages in the bottom left corner of the screen",
        Order = 12
    },
    _Divider_HUD_7 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        Order = 13
    },
    ["Enable Game Instructor Messages"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "HUD",
        Description = "Enable In-Game Hints (Instructor Messages)",
        DisplayName = "Tool Tips",
        Order = 14
    },
    _Divider_HUD_8 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "HUD",
        Order = 15
    },
    ["Enable Missions Notifications"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "HUD",
        Description = "Show a notification when you complete a mission",
        Order = 16
    },
    ["Crosshair Preview"] = {
        Type = "CrosshairPreview",
        Template = "CrosshairPreviewTemplate",
        Default = nil,
        Category = "Crosshair",
        Description = "Preview and configure your crosshair",
        Order = 1
    },
    ["Crosshair Style"] = {
        Type = "Dropdown",
        Template = "DropdownTemplate",
        Default = "Classic",
        Category = "Crosshair",
        Description = "Style of the crosshair",
        Order = 2,
        Enums = { "Classic", "Classic Static", "Image" }
    },
    ["Crosshair Image"] = {
        Type = "Number",
        Template = "NumberTemplate",
        Default = 0,
        Category = "Crosshair",
        Description = "Custom crosshair image asset ID",
        Order = 3
    },
    ["Friendly Fire Reticle Warning"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Crosshair",
        Description = "Show warning when aiming at teammates",
        IsEnabled = false,
        Order = 4
    },
    ["Follow Recoil"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Crosshair",
        Description = "Crosshair follows weapon recoil",
        Order = 5
    },
    ["Center Dot"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Crosshair",
        Description = "Show center dot on crosshair",
        Order = 6
    },
    Length = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 5,
        Min = 0,
        Max = 10,
        Step = 1,
        Category = "Crosshair",
        Description = "Length of crosshair lines",
        Order = 7
    },
    Thickness = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 1,
        Min = 0,
        Max = 5,
        Step = 1,
        Category = "Crosshair",
        Description = "Thickness of crosshair lines",
        Order = 8
    },
    Gap = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0,
        Min = -5,
        Max = 5,
        Step = 0.5,
        Category = "Crosshair",
        Description = "Gap between crosshair lines",
        Order = 9
    },
    Outline = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 1,
        DefaultEnabled = true,
        Min = 0,
        Max = 10,
        Step = 1,
        HasEnabledToggle = true,
        Category = "Crosshair",
        Description = "Thickness of crosshair outline",
        Order = 10
    },
    Red = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0,
        Min = 0,
        Max = 255,
        Step = 1,
        Category = "Crosshair",
        Description = "Red color value (0-255)",
        Order = 11
    },
    Green = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 255,
        Min = 0,
        Max = 255,
        Step = 1,
        Category = "Crosshair",
        Description = "Green color value (0-255)",
        Order = 12
    },
    Blue = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0,
        Min = 0,
        Max = 255,
        Step = 1,
        Category = "Crosshair",
        Description = "Blue color value (0-255)",
        Order = 13
    },
    Alpha = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 200,
        DefaultEnabled = false,
        Min = 0,
        Max = 255,
        Step = 1,
        HasEnabledToggle = true,
        Category = "Crosshair",
        Description = "Alpha/transparency value (0-255)",
        Order = 14
    },
    ["T Style"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "Crosshair",
        Description = "Use T-style crosshair",
        Order = 15
    },
    ["Use Crosshair Color for Scope Dot"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Crosshair",
        Description = "Use crosshair color for scope dot",
        IsEnabled = false,
        Order = 16
    },
    ["Show Player Crosshairs"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "Crosshair",
        Description = "Show other players\' crosshairs when spectating",
        Order = 17
    },
    ["Show my crosshair when spectating bots"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = false,
        Category = "Crosshair",
        Description = "Use your crosshair when spectating bots",
        IsEnabled = false,
        Order = 18
    },
    _Divider_Viewmodel_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Viewmodel",
        Order = 1
    },
    ["X Offset"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0,
        Min = -25,
        Max = 20,
        Step = 0.1,
        Category = "Viewmodel",
        Description = "Horizontal offset of the weapon viewmodel (left/right positioning)",
        Order = 2
    },
    _Divider_Viewmodel_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Viewmodel",
        Order = 3
    },
    ["Y Offset"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0,
        Min = -15,
        Max = 3,
        Step = 0.1,
        Category = "Viewmodel",
        Description = "Vertical offset of the weapon viewmodel (up/down positioning)",
        Order = 4
    },
    _Divider_Viewmodel_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Viewmodel",
        Order = 5
    },
    ["Z Offset"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0,
        Min = -7.5,
        Max = 7.5,
        Step = 0.1,
        Category = "Viewmodel",
        Description = "Depth offset of the weapon viewmodel (forward/backward positioning)",
        Order = 6
    },
    _Divider_Radar_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Radar/Tablet",
        IsEnabled = false,
        Order = 1
    },
    ["Radar Centers The Player"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Radar/Tablet",
        Description = "Center the radar on the player",
        IsEnabled = false,
        Order = 2
    },
    _Divider_Radar_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Radar/Tablet",
        Order = 3
    },
    ["Radar Is Rotating"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Radar/Tablet",
        Description = "Rotate the radar with player direction",
        Order = 4
    },
    _Divider_Radar_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Radar/Tablet",
        Order = 5
    },
    ["Radar Hud Size"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 1,
        Min = 0.5,
        Max = 2,
        Step = 0.1,
        Category = "Radar/Tablet",
        Description = "Size of the radar HUD element",
        Order = 6
    },
    _Divider_Radar_4 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Radar/Tablet",
        Order = 7
    },
    ["Radar Map Zoom"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0.5,
        Min = 0.1,
        Max = 1,
        Step = 0.05,
        Category = "Radar/Tablet",
        Description = "Zoom level of the radar map",
        Order = 8
    },
    ["Emit Particles When Server Validated"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Other",
        Description = "Show player-hit damage effects immediately using client prediction",
        DisplayName = "Damage Prediction",
        Order = 1
    },
    _Divider_Other_1 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 2
    },
    ["Controller Haptics/Vibrations"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Category = "Other",
        Default = true,
        Description = "Enable controller vibration feedback during gameplay",
        Platform = "Console",
        Order = 3
    },
    _Divider_Other_2 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 4
    },
    ["Controller Aim Assist"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Category = "Other",
        Default = true,
        Description = "Enable aim assist features on controllers (target selection, friction, magnetism, recoil assist)",
        Platform = "Console",
        Order = 5
    },
    _Divider_Other_3 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 6
    },
    ["Mobile Haptics/Vibrations"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Category = "Other",
        Default = true,
        Description = "Enable mobile vibration feedback during gameplay",
        Platform = "Mobile",
        Order = 7
    },
    _Divider_Other_4 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 8
    },
    ["Mobile Auto Shoot"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Other",
        Description = "Automatically shoot when aiming at an enemy on mobile",
        Platform = "Mobile",
        Order = 9
    },
    _Divider_Other_5 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 10
    },
    ["Mobile Aim Assist"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Other",
        Description = "Enable aim assist features on mobile devices (target selection, friction, magnetism, recoil assist)",
        Platform = "Mobile",
        Order = 11
    },
    _Divider_Other_6 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 12
    },
    ["Show Ping"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Other",
        Description = "Display ping/latency on screen",
        Order = 13
    },
    _Divider_Other_7 = {
        Type = "Divider",
        Template = "Divider",
        Default = nil,
        Category = "Other",
        Order = 14
    },
    ["Show FPS"] = {
        Type = "Toggle",
        Template = "ToggleTemplate",
        Default = true,
        Category = "Other",
        Description = "Display FPS counter on screen",
        Order = 15
    }
};
u1.Keybinds = {
    ["Move Forward"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Movement Keys",
        Description = "Move forward",
        Platform = "PC",
        Order = 4,
        Default = {
            Computer = "Enum.KeyCode.W",
            Console = ""
        }
    },
    ["Move Backward"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Movement Keys",
        Description = "Move backward",
        Platform = "PC",
        Order = 5,
        Default = {
            Computer = "Enum.KeyCode.S",
            Console = ""
        }
    },
    ["Move Left (Strafe)"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Movement Keys",
        Description = "Strafe left",
        Platform = "PC",
        Order = 6,
        Default = {
            Computer = "Enum.KeyCode.A",
            Console = ""
        }
    },
    ["Move Right (Strafe)"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Movement Keys",
        Description = "Strafe right",
        Platform = "PC",
        Order = 7,
        Default = {
            Computer = "Enum.KeyCode.D",
            Console = ""
        }
    },
    Jump = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Movement Keys",
        Description = "Jump",
        Order = 8,
        Default = {
            Computer = "Enum.KeyCode.Space",
            Console = "Enum.KeyCode.ButtonA"
        }
    },
    Crouch = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Movement Keys",
        Description = "Crouch",
        Order = 9,
        Default = {
            Computer = "Enum.KeyCode.LeftControl",
            Console = "Enum.KeyCode.ButtonL3"
        }
    },
    Walk = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Movement Keys",
        Description = "Walk (slower movement)",
        Order = 10,
        Default = {
            Computer = "Enum.KeyCode.LeftShift",
            Console = "Enum.KeyCode.ButtonR3"
        }
    },
    Fire = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Fire weapon",
        Order = 11,
        Default = {
            Computer = "Enum.UserInputType.MouseButton1",
            Console = "Enum.KeyCode.ButtonR2"
        }
    },
    ["Secondary Fire"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Secondary fire/aim down sights",
        Order = 12,
        Default = {
            Computer = "Enum.UserInputType.MouseButton2",
            Console = "Enum.KeyCode.ButtonL2"
        }
    },
    Reload = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Reload weapon",
        Order = 13,
        Default = {
            Computer = "Enum.KeyCode.R",
            Console = "Enum.KeyCode.ButtonX"
        }
    },
    ["Last Weapon Used"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Switch to last weapon used",
        Order = 14,
        Default = {
            Computer = "Enum.KeyCode.Q",
            Console = "Enum.KeyCode.DPadLeft"
        }
    },
    Use = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Use/interact with objects",
        Order = 15,
        Default = {
            Computer = "Enum.KeyCode.E",
            Console = "Enum.KeyCode.DPadUp"
        }
    },
    ["Drop Weapon"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Drop current weapon",
        Order = 16,
        Default = {
            Computer = "Enum.KeyCode.G",
            Console = "Enum.KeyCode.DPadDown"
        }
    },
    Inspect = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Inspect weapon",
        Order = 17,
        Default = {
            Computer = "Enum.KeyCode.F",
            Console = "Enum.KeyCode.ButtonY"
        }
    },
    ["Switch Viewmodel Left/Right Hand"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Switch the viewmodel between your left and right hand",
        Order = 17.5,
        Default = {
            Computer = "Enum.KeyCode.H",
            Console = ""
        }
    },
    ["Buy Menu"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Open buy menu",
        Order = 18,
        Default = {
            Computer = "Enum.KeyCode.B",
            Console = "Enum.KeyCode.DPadRight"
        }
    },
    ["Cycle Weapons Left"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Cycle weapons left",
        Order = 19,
        Default = {
            Computer = "Enum.CustomInputType.ScrollWheelUp",
            Console = "Enum.KeyCode.ButtonL1"
        }
    },
    ["Cycle Weapons Right"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Cycle weapons right",
        Order = 20,
        Default = {
            Computer = "Enum.CustomInputType.ScrollWheelDown",
            Console = "Enum.KeyCode.ButtonR1"
        }
    },
    ["Primary Weapon"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select primary weapon",
        Platform = "PC",
        Order = 21,
        Default = {
            Computer = "Enum.KeyCode.One",
            Console = ""
        }
    },
    ["Secondary Weapon"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select secondary weapon",
        Platform = "PC",
        Order = 22,
        Default = {
            Computer = "Enum.KeyCode.Two",
            Console = ""
        }
    },
    ["Melee Weapon"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select melee weapon",
        Platform = "PC",
        Order = 23,
        Default = {
            Computer = "Enum.KeyCode.Three",
            Console = ""
        }
    },
    ["Cycle Grenades"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Cycle through grenades",
        Platform = "PC",
        Order = 24,
        Default = {
            Computer = "Enum.KeyCode.Four",
            Console = ""
        }
    },
    ["HE Grenade"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select HE grenade",
        Platform = "PC",
        Order = 25,
        Default = {
            Computer = "",
            Console = ""
        }
    },
    Flashbang = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select flashbang",
        Platform = "PC",
        Order = 26,
        Default = {
            Computer = "",
            Console = ""
        }
    },
    ["Smoke Grenade"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select smoke grenade",
        Platform = "PC",
        Order = 27,
        Default = {
            Computer = "",
            Console = ""
        }
    },
    ["Fire Grenade"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select Molotov or incendiary grenade",
        Platform = "PC",
        Order = 28,
        Default = {
            Computer = "",
            Console = ""
        }
    },
    ["Decoy Grenade"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select decoy grenade",
        Platform = "PC",
        Order = 29,
        Default = {
            Computer = "",
            Console = ""
        }
    },
    ["Explosives & Traps"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Select explosives/traps",
        Platform = "PC",
        Order = 30,
        Default = {
            Computer = "Enum.KeyCode.Five",
            Console = ""
        }
    },
    ["Health Shot"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Weapon Keys",
        Description = "Use health shot",
        IsEnabled = false,
        Platform = "PC",
        Order = 31,
        Default = {
            Computer = "Enum.KeyCode.X",
            Console = ""
        }
    },
    Ping = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "UI Keys",
        Description = "Place ping marker",
        Platform = "PC",
        Order = 27,
        Default = {
            Computer = "Enum.UserInputType.MouseButton3",
            Console = ""
        }
    },
    ["Toggle Inventory Display"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "UI Keys",
        Description = "Toggle inventory display",
        IsEnabled = false,
        Order = 28,
        Default = {
            Computer = "Enum.KeyCode.I",
            Console = ""
        }
    },
    Scoreboard = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "UI Keys",
        Description = "Toggle scoreboard",
        Platform = "PC",
        Order = 29,
        Default = {
            Computer = "Enum.KeyCode.Tab",
            Console = ""
        }
    },
    ["Main Menu"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "UI Keys",
        Description = "Open main menu",
        Platform = "PC",
        Order = 30,
        Default = {
            Computer = "Enum.KeyCode.N",
            Console = "Enum.KeyCode.ButtonB"
        }
    },
    ["Choose Team"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "UI Keys",
        Description = "Open team selection menu",
        Platform = "PC",
        Order = 31,
        Default = {
            Computer = "Enum.KeyCode.M",
            Console = ""
        }
    },
    ["Graffiti Menu"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "UI Keys",
        Description = "Open graffiti menu",
        IsEnabled = false,
        Platform = "PC",
        Order = 32,
        Default = {
            Computer = "Enum.KeyCode.T",
            Console = ""
        }
    },
    ["VIP Menu"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "UI Keys",
        Description = "Open VIP server owner menu",
        Platform = "PC",
        Order = 33,
        Default = {
            Computer = "Enum.KeyCode.O",
            Console = ""
        }
    },
    ["Voice Chat"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Communication Options",
        Description = "Push to talk for voice chat",
        Platform = "PC",
        Order = 34,
        Default = {
            Computer = "Enum.KeyCode.V",
            Console = ""
        }
    },
    ["Team Message"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Communication Options",
        Description = "Send team message",
        Platform = "PC",
        Order = 35,
        Default = {
            Computer = "Enum.KeyCode.U",
            Console = ""
        }
    },
    ["Chat Message"] = {
        Type = "Keybind",
        Template = "KeybindTemplate",
        Category = "Communication Options",
        Description = "Send chat message to all",
        Platform = "PC",
        Order = 36,
        Default = {
            Computer = "Enum.KeyCode.Y",
            Console = ""
        }
    },
    ["Mouse Sensitivity"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 1,
        Min = 0.1,
        Max = 10,
        Step = 0.1,
        Category = "Keyboard & Mouse Settings",
        Description = "Mouse sensitivity for looking around",
        Order = 1
    },
    ["Zoom Sensitivity Multiplier"] = {
        Type = "Slider",
        Template = "SliderTemplate",
        Default = 0.5,
        Min = 0.1,
        Max = 5,
        Step = 0.1,
        Category = "Keyboard & Mouse Settings",
        Description = "Sensitivity multiplier when zoomed/scoped",
        Order = 2
    },
    ["Walk Mode"] = {
        Type = "Dropdown",
        Template = "DropdownTemplate",
        Default = "Hold",
        Category = "Keyboard & Mouse Settings",
        Description = "Walk button behavior",
        Order = 3,
        Enums = { "Hold", "Toggle" }
    }
};

local function IsSettingVisible(p2: table, p3: table) -- Line: 1735
    local v4;

    if p2.IsEnabled == false then
        v4 = false;
    else
        local v5 = p2.Platform and not table.find(p3, p2.Platform);
        v4 = not v5;
    end;

    return v4;
end;

function u1.GetPage(p6: string) -- Line: 1742
    -- upvalues: u1 (copy)
    return u1[p6];
end;

function u1.GetCategory(p7: string, p8: string) -- Line: 1748
    -- upvalues: u1 (copy), GetUserPlatform (copy)
    local Page = u1.GetPage(p7);

    if not Page then
        return {};
    end;

    local v9 = GetUserPlatform();
    local v10 = {};

    for i, v in pairs(Page) do
        if v.Category == p8 then
            local v11;

            if v.IsEnabled == false then
                v11 = false;
            else
                local v12 = v.Platform and not table.find(v9, v.Platform);
                v11 = not v12;
            end;

            if v11 then
                v10[i] = v;
            end;
        end;
    end;

    return v10;
end;

function u1.GetCategories(p13: string) -- Line: 1766
    -- upvalues: u1 (copy), GetUserPlatform (copy)
    local Page = u1.GetPage(p13);

    if not Page then
        return {};
    end;

    local v14 = GetUserPlatform();
    local v15 = {};
    local v16 = {};

    for _, v in pairs(Page) do
        local v17;

        if v.IsEnabled == false then
            v17 = false;
        else
            local v18 = v.Platform and not table.find(v14, v.Platform);
            v17 = not v18;
        end;

        if v17 and not v15[v.Category] then
            table.insert(v16, v.Category);
            v15[v.Category] = true;
        end;
    end;

    return v16;
end;

function u1.GetSetting(p19: string, p20: string) -- Line: 1787
    -- upvalues: u1 (copy)
    local Page = u1.GetPage(p19);

    if Page then
        return Page[p20];
    end;

    return nil;
end;

return u1;