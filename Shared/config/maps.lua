--------------------------------------------------------------------------------
-- Character spawns
--------------------------------------------------------------------------------
GM.Cfg.CharacterSpawns = {
    [ "nanos-world::BlankMap" ] = {
        { Vector( -200, 0, 0 ), Rotator() },
        -- { Vector( -100, 0, 0 ), Rotator() },
        -- { Vector( 0, 0, 0 ), Rotator() },
        -- { Vector( 100, 0, 0 ), Rotator() },
        -- { Vector( 200, 0, 0 ), Rotator() }
    }
}

--------------------------------------------------------------------------------
-- Loot
--------------------------------------------------------------------------------
GM.Cfg.Loot = {
    { mesh = "nanos-world::SM_Fruit_Pumpkin_01", points = 1, onPickup = function( eChar ) end }
}

-- GM.Cfg.LootSpawns = {
--     [ "nanos-world::BlankMap" ] = {
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 0, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 100, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 200, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 300, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 400, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 500, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 600, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 700, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 800, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 900, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1000, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1100, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1200, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1300, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1400, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1500, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1600, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1700, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1800, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 1900, 0, 0 ), Rotator( 0, 0, 0 ) },
--         { "nanos-world::SM_Fruit_Pumpkin_01", Vector( 2000, 0, 0 ), Rotator( 0, 0, 0 ) }
--     }
-- }