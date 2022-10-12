Package.Require( "modules/round.lua" )
Package.Require( "modules/player.lua" )
Package.Require( "modules/character.lua" )
Package.Require( "modules/weapon.lua" )
Package.Require( "modules/loot.lua" )

if ( Server.GetMaxPlayers() > #GM.Cfg.CodeNames ) then
    Server.SetMaxPlayers( #GM.Cfg.CodeNames, false )
    Package.Warn( "Server max players is greater than the number of code names. Setting max players to " .. #GM.Cfg.CodeNames )
end