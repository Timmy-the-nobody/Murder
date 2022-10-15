Package.Require( "modules/round.lua" )
Package.Require( "modules/player.lua" )
Package.Require( "modules/character.lua" )
Package.Require( "modules/weapon.lua" )
Package.Require( "modules/loot.lua" )
Package.Require( "modules/flashlight.lua" )

Package.Require( "modules/maps.lua" )
Package.Require( "modules/admin.lua" )

--------------------------------------------------------------------------------
-- Assets precache
--------------------------------------------------------------------------------
Assets.Precache( "nanos-world::SK_Mannequin", AssetType.SkeletalMesh )
Assets.Precache( "nanos-world::M_NanosDecal", AssetType.Material )
Assets.Precache( "nanos-world::SM_M9", AssetType.StaticMesh )
Assets.Precache( "nanos-world::A_Mannequin_Throw_01", AssetType.Animation )
Assets.Precache( "nanos-world::AM_Mannequin_Melee_Stab_Attack", AssetType.Animation )

for _, v in ipairs( GM.Cfg.Loot ) do
    if v.mesh then
        Assets.Precache( v.mesh, AssetType.StaticMesh )
    end
end

--------------------------------------------------------------------------------
-- Max slots
--------------------------------------------------------------------------------
if ( Server.GetMaxPlayers() > #GM.Cfg.CodeNames ) then
    Server.SetMaxPlayers( #GM.Cfg.CodeNames, false )
    Package.Warn( "Server max players is greater than the number of code names. Setting max players to " .. #GM.Cfg.CodeNames )
end