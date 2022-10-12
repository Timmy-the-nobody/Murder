--------------------------------------------------------------------------------
-- Rounds config
--------------------------------------------------------------------------------
GM.Cfg.RoundMaxTime = 900000                -- Maximum duration of a round
GM.Cfg.RoundEndTime = 1000                  -- Time before the round starts again
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
-- Misc.
--------------------------------------------------------------------------------
GM.Cfg.TeamKillPenaltyDuration = 20000      -- Speed and weapon pickup penalty for team killers
GM.Cfg.TeamKillSpeedMultiplier = 0.5        -- Speed penalty for team killers
GM.Cfg.KnifeSpeedMultiplier = 0.9           -- Speed penalty for knife users
GM.Cfg.PistolSpeedMultiplier = 0.75         -- Speed penalty for pistol users

GM.Cfg.CodeColors = {
    Color.RED,
    Color.YELLOW,
    Color.BLUE,
    Color.VIOLET,
    Color.ORANGE
    -- rgb(52, 152, 219),
    -- rgb(46, 204, 113),
    -- rgb(26, 188, 156),
    -- rgb(155, 89, 182),
    -- rgb(241, 196, 15),
    -- rgb(230, 126, 34),
    -- rgb(231, 76, 60),
    -- rgb(52, 73, 94),
    -- rgb(189, 195, 199)
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