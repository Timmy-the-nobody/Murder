--------------------------------------------------------------------------------
-- Rounds config
--------------------------------------------------------------------------------
GM.Cfg.RoundMaxTime = 600000                                    -- Maximum duration of a round
GM.Cfg.RoundEndTime = 6000                                      -- Time before the round starts again
GM.Cfg.PlayersWaitTime = 1000                                   -- Minimum time to wait for players to join
GM.Cfg.MinPlayers = 1                                           -- Minimum players to start a round

--------------------------------------------------------------------------------
-- Loot config
--------------------------------------------------------------------------------
GM.Cfg.LootSpawnTime = 10000                                    -- Time between loot spawns
GM.Cfg.MaxLootPerPlayer = 4                                     -- Maximum loot per player spawned at the same time
GM.Cfg.BonusRequiredCollectables = 5                            -- Required collectables to get a new pistol

--------------------------------------------------------------------------------
-- Footprints
--------------------------------------------------------------------------------
GM.Cfg.FootPrintMaxTime = 20000                                 -- Maximum time a footprint will stay on the ground
GM.Cfg.FootPrintTick = 330                                      -- Time between footprint ticks

--------------------------------------------------------------------------------
-- Disguise
--------------------------------------------------------------------------------
GM.Cfg.DisguiseLootRequired = 0                                 -- Required loot to disguise as a dead player
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

GM.Cfg.StartScreenTime = 500                                    -- Time the start screen will stay visible
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
-- Character code
--------------------------------------------------------------------------------
GM.Cfg.CodeColors = {                                           -- Charactes/Names colors
    Color(0.79, 0.40, 0.14),
    Color(0.81, 0.20, 0.55),
    Color(0.90, 0.26, 0.39),
    Color(0.39, 0.65, 0.28),
    Color(0.05, 0.23, 0.94),
    Color(0.09, 0.50, 0.86),
    Color(0.09, 0.70, 0.76),
    Color(0.79, 0.71, 0.63),
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
    [ "76561198144995316" ] = true          -- Timmy
}