GM = GM or {}
GM.Cfg = GM.Cfg or {}

_GM = _GM or {}

Package.RequirePackage( "luarun" )
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

--------------------------------------------------------------------------------
-- Config files
--------------------------------------------------------------------------------
Package.Require( "Shared/config/main.lua" )

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
Package.Require( "Shared/modules/round.lua" )
Package.Require( "Shared/modules/player.lua" )
Package.Require( "Shared/modules/character.lua" )
Package.Require( "Shared/modules/weapon.lua" )