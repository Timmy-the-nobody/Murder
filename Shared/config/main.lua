--------------------------------------------------------------------------------
-- Rounds config
--------------------------------------------------------------------------------
GM.Cfg.RoundMaxTime = 900000                                    -- Maximum duration of a round
GM.Cfg.RoundEndTime = 6000                                      -- Time before the round starts again
GM.Cfg.PlayersWaitTime = 10000                                  -- Minimum time to wait for players to join
GM.Cfg.MinPlayers = 2                                           -- Minimum players to start a round

--------------------------------------------------------------------------------
-- Loot config
--------------------------------------------------------------------------------
GM.Cfg.LootSpawnTime = 4000                                     -- Time between loot spawns
GM.Cfg.MaxLootPerPlayer = 10                                    -- Maximum loot per player spawned at the same time
GM.Cfg.BonusRequiredCollectables = 5                            -- Required collectables to get a new pistol

--------------------------------------------------------------------------------
-- Footprints
--------------------------------------------------------------------------------
GM.Cfg.FootPrintMaxTime = 20000                                 -- Maximum time a footprint will stay on the ground
GM.Cfg.FootPrintTick = 330                                      -- Time between footprint ticks

--------------------------------------------------------------------------------
-- Disguise
--------------------------------------------------------------------------------
GM.Cfg.DisguiseLootRequired = 2                                 -- Required loot to disguise as a dead player
GM.Cfg.DisguiseCooldown = 10000                                 -- Time before a player can disguise again

--------------------------------------------------------------------------------
-- Flashlight
--------------------------------------------------------------------------------
GM.Cfg.FlashlightDrainTime = 500                                -- Time between flashlight drain
GM.Cfg.FlashlightRegenTime = 1000                               -- Time between flashlight regen

--------------------------------------------------------------------------------
-- Misc.
--------------------------------------------------------------------------------
GM.Cfg.TeamKillPenaltyDuration = 20000                          -- Speed and weapon pickup penalty for team killers
GM.Cfg.TeamKillSpeedMultiplier = 0.5                            -- Speed penalty for team killers
GM.Cfg.KnifeSpeedMultiplier = 0.9                               -- Speed penalty for knife users
GM.Cfg.PistolSpeedMultiplier = 0.75                             -- Speed penalty for pistol users

GM.Cfg.StartScreenTime = 10000                                    -- Time the start screen will stay visible
GM.Cfg.TeamKillBlindTime = 10000                                -- Time the screen will be blinded for team killers
GM.Cfg.TeamKillBlindFadeTime = 10000                            -- Time the screen will fade back in for team killers

GM.Cfg.KnifeHighlightColor = Color( 20, 0, 0 )                  -- Color of the knife highlight
GM.Cfg.DeadPlayerHighlightColor = Color( 0.60, 0.34, 0.71 )     -- Color of the dead players highlight

--------------------------------------------------------------------------------
-- VOIP
--------------------------------------------------------------------------------
GM.Cfg.VOIPSetting = VOIPSetting.Global                         -- VOIP settings: VOIPSetting.Local, VOIPSetting.Global or VOIPSetting.Muted
GM.Cfg.VOIPChannelDefault = 0                                   -- Default VOIP channel
GM.Cfg.VOIPChannelDead = 1                                      -- VOIP channel for dead players

--------------------------------------------------------------------------------
-- Loot
--------------------------------------------------------------------------------
GM.Cfg.Loot = {
    { mesh = "nanos-world::SM_Fruit_Pumpkin_01", points = 1, offset = Vector( 0, 0, 0 ), onPickup = function( eChar ) end },
    { mesh = "nanos-world::SM_Boltcutters" },
    { mesh = "nanos-world::SM_Bunny" },
    { mesh = "nanos-world::SM_Lunchbox_01" },
    { mesh = "nanos-world::SM_Spraycan_01" },
    { mesh = "nanos-world::SM_Spraycan_02" },
    { mesh = "nanos-world::SM_Sunglasses" },
}

--------------------------------------------------------------------------------
-- Character code
--------------------------------------------------------------------------------
GM.Cfg.CodeColors = {                                           -- Charactes/Names colors
    Color( 0.2039, 0.5960, 0.8588 ),                                    -- Blue
    Color( 0.1803, 0.8000, 0.4431 ),                                    -- Green
    Color( 0.9450, 0.7686, 0.0588 ),                                    -- Yellow
    Color( 0.9058, 0.2980, 0.2352 ),                                    -- Red
    Color( 0.6078, 0.3490, 0.7137 ),                                    -- Purple
    Color( 0.1764, 0.2039, 0.2117 ),                                    -- Black
    Color( 0.9098, 0.2627, 0.5764 ),                                    -- Pink
    Color( 0.8745, 0.9019, 0.9137 )                                     -- White
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