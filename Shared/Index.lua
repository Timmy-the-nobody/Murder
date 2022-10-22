GM = GM or {}
GM.Cfg = GM.Cfg or {}

-- Package.RequirePackage( "luarun" )
Package.RequirePackage( "nanos-world-weapons" )

--------------------------------------------------------------------------------
-- Core files
--------------------------------------------------------------------------------
-- Libraries
for _, sPath in ipairs( Package.GetFiles( "Shared/core/libraries/includes", ".lua" ) ) do
    Package.Require( sPath )
end

Package.Require( "Shared/core/libraries/util.lua" )
Package.Require( "Shared/core/libraries/time.lua" )
Package.Require( "Shared/core/libraries/network.lua" )
Package.Require( "Shared/core/libraries/private_value.lua" )

-- Misc
Package.Require( "Shared/core/enum.lua" )

-- Classes
Package.Require( "Shared/core/classes/loot.lua" )

-- Config
Package.Require( "Shared/config/main.lua" )
Package.Require( "Shared/config/loot.lua" )

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
Package.Require( "Shared/modules/notify.lua" )
Package.Require( "Shared/modules/round.lua" )
Package.Require( "Shared/modules/player.lua" )
Package.Require( "Shared/modules/character.lua" )
Package.Require( "Shared/modules/weapon.lua" )
Package.Require( "Shared/modules/loot.lua" )
Package.Require( "Shared/modules/flashlight.lua" )
Package.Require( "Shared/modules/admin.lua" )