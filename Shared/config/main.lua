--[[
    Credits:
        Gamemode made with <3 by Timmy (https://github.com/Timmy-the-nobody)
        Inspired by MechanicalMind's Murder gamemode (https://github.com/MechanicalMind/murder)
        Audio from Zapsplat.com
]]--
--------------------------------------------------------------------------------
-- Rounds config
--------------------------------------------------------------------------------
GM.Cfg.RoundMaxTime = 900000                                    -- Maximum duration of a round [default: 900000]
GM.Cfg.RoundEndTime = 6000                                      -- Time before the round starts again [default: 6000]
GM.Cfg.PlayersWaitTime = 2500                                  -- Minimum time to wait for players to join [default: 25000]
GM.Cfg.StartScreenTime = 1000                                  -- Time the start screen will stay visible [default: 10000]
GM.Cfg.MinPlayers = 1                                           -- Minimum players to start a round [default: 2]

--------------------------------------------------------------------------------
-- Loot config
--------------------------------------------------------------------------------
GM.Cfg.LootSpawnTime = 4000                                     -- Time between loot spawns [default: 4000]
GM.Cfg.MaxLootPerPlayer = 5                                     -- Maximum loot per player spawned at the same time [default: 10]
GM.Cfg.BonusRequiredCollectables = 5                            -- Required collectables to get a new pistol [default: 5]

--------------------------------------------------------------------------------
-- Disguise
--------------------------------------------------------------------------------
GM.Cfg.DisguiseLootRequired = 2                                 -- Required loot to disguise as a dead player [default: 2]
GM.Cfg.DisguiseCooldown = 10000                                 -- Time before a player can disguise again [default: 10000]

--------------------------------------------------------------------------------
-- Footprints
--------------------------------------------------------------------------------
GM.Cfg.FootPrintMaxTime = 15000                                 -- Maximum time a footprint will stay on the ground [default: 15000]
GM.Cfg.FootPrintTick = 330                                      -- Time between footprint ticks [default: 330]

--------------------------------------------------------------------------------
-- Flashlight
--------------------------------------------------------------------------------
GM.Cfg.FlashlightDrainTime = 500                                -- Time between flashlight drain [default: 500]
GM.Cfg.FlashlightRegenTime = 1000                               -- Time between flashlight regen [default: 1000]

--------------------------------------------------------------------------------
-- Misc.
--------------------------------------------------------------------------------
GM.Cfg.KnifeSpeedMultiplier = 0.9                               -- Speed penalty for knife users [default: 0.9]
GM.Cfg.PistolSpeedMultiplier = 0.75                             -- Speed penalty for pistol users [default: 0.75]

GM.Cfg.TeamKillPenaltyDuration = 20000                          -- Speed and weapon pickup penalty for team killers [default: 20000]
GM.Cfg.TeamKillSpeedMultiplier = 0.5                            -- Speed penalty for team killers [default: 0.5]
GM.Cfg.TeamKillBlindTime = 5000                                 -- Time the screen will be blinded for team killers [default: 5000]
GM.Cfg.TeamKillBlindFadeTime = 10000                            -- Time the screen will fade back in for team killers [default: 10000]

GM.Cfg.KnifeHighlightColor = Color( 20, 0, 0 )                  -- Color of the knife highlight [default: Color( 20, 0, 0 )]
GM.Cfg.DeadPlayerHighlightColor = Color( 30, 16, 35 )           -- Color of the dead players highlight [default: Color( 30, 16, 35 )]

GM.Cfg.KnifeAutoPickupDuration = 15000                          -- Time a knife will stay on the ground before it gets picked up [default: 15000]

--------------------------------------------------------------------------------
-- VOIP
--------------------------------------------------------------------------------
GM.Cfg.VOIPSetting = VOIPSetting.Global                         -- VOIP settings: VOIPSetting.Local, VOIPSetting.Global or VOIPSetting.Muted [default: VOIPSetting.Global]
GM.Cfg.VOIPChannelDefault = 0                                   -- Default VOIP channel [default: 0]
GM.Cfg.VOIPChannelDead = 1                                      -- VOIP channel for dead players [default: 1]

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
    { mesh = "nanos-world::SM_Paintbrush_01" },
    { mesh = "nanos-world::SM_Paintbrush_03" },
    { mesh = "nanos-world::SM_Pot_02" },
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