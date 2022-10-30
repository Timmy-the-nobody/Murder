--[[
    Credits:
        Gamemode made with <3 by Timmy (https://github.com/Timmy-the-nobody)
        Inspired by MechanicalMind's Murder gamemode (https://github.com/MechanicalMind/murder)
        Audio from Zapsplat.com
]]--
--------------------------------------------------------------------------------
-- Rounds config
--------------------------------------------------------------------------------
GM.Cfg.RoundMaxTime = 600000                                    -- Maximum duration of a round [default: 600000]
GM.Cfg.RoundEndTime = 15000                                     -- Time before the round starts again [default: 15000]
GM.Cfg.PlayersWaitTime = 20000                                  -- Minimum time to wait for players to join [default: 20000]
GM.Cfg.StartScreenTime = 10000                                  -- Time the start screen will stay visible [default: 10000]
GM.Cfg.MinPlayers = 3                                           -- Minimum players to start a round [default: 3]

--------------------------------------------------------------------------------
-- Loot config
--------------------------------------------------------------------------------
GM.Cfg.LootSpawnTime = 4000                                     -- Time between loot spawns [default: 4000]
GM.Cfg.MaxLootPerPlayer = 3                                     -- Maximum loot per player spawned at the same time [default: 3]
GM.Cfg.BonusRequiredCollectables = 5                            -- Required collectables to get a new pistol [default: 5]
GM.Cfg.LootHaloDistance = 2000000                               -- Maximum distance from the loot for the outline to show up [default: 1000000]

--------------------------------------------------------------------------------
-- Disguise
--------------------------------------------------------------------------------
GM.Cfg.DisguiseLootRequired = 5                                 -- Required loot to disguise as a dead player [default: 2]
GM.Cfg.DisguiseCooldown = 10000                                 -- Time before a player can disguise again [default: 10000]

--------------------------------------------------------------------------------
-- Footprints
--------------------------------------------------------------------------------
GM.Cfg.FootPrintMaxTime = 10000                                 -- Maximum time a footprint will stay on the ground [default: 10000]
GM.Cfg.FootPrintTick = 330                                      -- Time between footprint ticks [default: 330]

--------------------------------------------------------------------------------
-- Flashlight
--------------------------------------------------------------------------------
GM.Cfg.FlashlightDrainTime = 500                                -- Time between flashlight drain [default: 500]
GM.Cfg.FlashlightRegenTime = 1000                               -- Time between flashlight regen [default: 1000]
GM.Cfg.FlashlightBugDelay = 60000                               -- Time before the flashlight bug happens [default: 60000, false to disable]

--------------------------------------------------------------------------------
-- Misc.
--------------------------------------------------------------------------------
GM.Cfg.DefaultSpeed = 1.2                                       -- Default player speed [default: 1.2]
GM.Cfg.KnifeSpeedMultiplier = 1.2                               -- Speed penalty for knife holders [default: 0.9]
GM.Cfg.PistolSpeedMultiplier = 0.8                              -- Speed penalty for pistol holders [default: 0.75]
GM.Cfg.TeamKillPenaltyDuration = 20000                          -- Speed and weapon pickup penalty for team killers [default: 20000]
GM.Cfg.TeamKillSpeedMultiplier = 0.8                            -- Speed penalty for team killers [default: 0.5]
GM.Cfg.TeamKillBlindTime = 5000                                 -- Time the screen will be blinded for team killers [default: 5000]
GM.Cfg.TeamKillBlindFadeTime = 10000                            -- Time the screen will fade back in for team killers [default: 10000]

GM.Cfg.KnifeHighlightColor = Color( 20, 0, 0 )                  -- Color of the knife highlight [default: Color( 20, 0, 0 )]
GM.Cfg.DeadPlayerHighlightColor = Color( 30, 16, 35 )           -- Color of the dead players highlight [default: Color( 30, 16, 35 )]

GM.Cfg.KnifeAutoPickupDuration = 15000                          -- Time a knife will stay on the ground before it gets picked up [default: 15000]
GM.Cfg.TauntCooldown = 5000                                     -- Time before a player can taunt again [default: 5000]

--------------------------------------------------------------------------------
-- VOIP
--------------------------------------------------------------------------------
GM.Cfg.VOIPSetting = VOIPSetting.Global                         -- VOIP settings: VOIPSetting.Local, VOIPSetting.Global or VOIPSetting.Muted [default: VOIPSetting.Global]
GM.Cfg.SpectatorVOIPChannel = 0                                 -- VOIP channel for spectators and dead players [default: 0]
GM.Cfg.InGameVOIPChannel = 1                                    -- VOIP channel for players in game [default: 1]

--------------------------------------------------------------------------------
-- Character code
--------------------------------------------------------------------------------
GM.Cfg.CodeColors = {                                           -- Charactes/Names colors
    Color( 0.2039, 0.5960, 0.8588 ),                                    -- Blue
    Color( 0.1803, 0.8000, 0.4431 ),                                    -- Green
    Color( 0.9450, 0.7686, 0.0588 ),                                    -- Yellow
    -- Color( 0.8274, 0.3294, 0.0000 ),                                    -- Orange
    Color( 0.9058, 0.2980, 0.2352 ),                                    -- Red
    Color( 0.6078, 0.3490, 0.7137 ),                                    -- Purple
    Color( 0.9098, 0.2627, 0.5764 ),                                    -- Pink
    -- Color( 0.8745, 0.9019, 0.9137 )                                     -- White
}

GM.Cfg.CodeNames = {                                            -- Code names
    "Alfa",
    "Bravo",
    "Charlie",
    "Delta",
    "Echo",
    "Foxtrot",
    "Golf",
    "Hotel",
    "India",
    "Juliett",
    "Kilo",
    "Lima",
    "Miko",
    "November",
    "Oscar",
    "Papa",
    "Quebec",
    "Romeo",
    "Sierra",
    "Tango",
    "Uniform",
    "Victor",
    "Whiskey",
    "X-ray",
    "Yankee",
    "Zulu"
}

--------------------------------------------------------------------------------
-- Admin
--------------------------------------------------------------------------------
GM.Cfg.AdminsSteamID = {                    -- Admins SteamID
    [ "76561198144995316" ] = true,         -- Timmy
    [ "76561198068443582" ] = true          -- Cedi
}