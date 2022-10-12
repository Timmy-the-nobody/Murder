--------------------------------------------------------------------------------
-- Rounds config
--------------------------------------------------------------------------------
GM.Cfg.RoundMaxTime = 900000                -- Maximum duration of a round
GM.Cfg.RoundEndTime = 10000                  -- Time before the round starts again
GM.Cfg.PlayersWaitTime = 5000               -- Minimum time to wait for players to join

--------------------------------------------------------------------------------
-- Loot config
--------------------------------------------------------------------------------
GM.Cfg.LootSpawnTime = 1000                 -- Time between loot spawns
GM.Cfg.MaxLootPerPlayer = 4                 -- Maximum loot per player spawned at the same time
GM.Cfg.BonusRequiredCollectables = 10       -- Required collectables to get a new pistol

--------------------------------------------------------------------------------
-- Footprints
--------------------------------------------------------------------------------
GM.Cfg.FootPrintMaxTime = 45000             -- Maximum time a footprint will stay on the ground
GM.Cfg.FootPrintTick = 330                  -- Time between footprint ticks

--------------------------------------------------------------------------------
-- Disguise
--------------------------------------------------------------------------------
GM.Cfg.DisguiseLootRequired = 0             -- Required loot to disguise as a dead player
GM.Cfg.DisguiseCooldown = 10000             -- Time before a player can disguise again

--------------------------------------------------------------------------------
-- Misc.
--------------------------------------------------------------------------------
GM.Cfg.TeamKillPenaltyDuration = 20000      -- Speed and weapon pickup penalty for team killers
GM.Cfg.TeamKillSpeedMultiplier = 0.5        -- Speed penalty for team killers
GM.Cfg.KnifeSpeedMultiplier = 0.9           -- Speed penalty for knife users
GM.Cfg.PistolSpeedMultiplier = 0.75         -- Speed penalty for pistol users

--------------------------------------------------------------------------------
-- VOIP
--------------------------------------------------------------------------------
GM.Cfg.VOIPSetting = VOIPSetting.Global     -- VOIP settings: VOIPSetting.Local, VOIPSetting.Global or VOIPSetting.Muted
GM.Cfg.VOIPChannelDefault = 0               -- Default VOIP channel
GM.Cfg.VOIPChannelDead = 1                  -- VOIP channel for dead players

GM.Cfg.CodeColors = {                       -- Charactes/Names colors
    Color(0.79, 0.40, 0.14),
    Color(0.81, 0.20, 0.55),
    Color(0.90, 0.26, 0.39),
    Color(0.39, 0.65, 0.28),
    Color(0.05, 0.23, 0.94),
    Color(0.09, 0.50, 0.86),
    Color(0.09, 0.70, 0.76),
    Color(0.79, 0.71, 0.63),
}

GM.Cfg.CodeNames = {                        -- Code names
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

GM.Cfg.LootPos = {                          -- Loot spawns
    [ "nanos-world::BlankMap" ] = {
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 0, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 100, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 200, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 300, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 400, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 500, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 600, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 700, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 800, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 900, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1000, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1100, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1200, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1300, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1400, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1500, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1600, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1700, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1800, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1900, 0, 0 ), Rotator( 0, 0, 0 ) },
        { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 2000, 0, 0 ), Rotator( 0, 0, 0 ) }
    }
}