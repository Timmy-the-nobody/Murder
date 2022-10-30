Package.Require( "modules/round.lua" )
Package.Require( "modules/player.lua" )
Package.Require( "modules/character.lua" )
Package.Require( "modules/weapon.lua" )
Package.Require( "modules/loot.lua" )
Package.Require( "modules/flashlight.lua" )
Package.Require( "modules/taunt.lua" )

Package.Require( "modules/admin.lua" )

-- Map files
for _, sPath in ipairs( Package.GetFiles( "Server/maps", ".lua" ) ) do
    Package.Require( sPath )
end

--------------------------------------------------------------------------------
-- Assets precache
--------------------------------------------------------------------------------
-- SkeletalMesh
Assets.Precache( "nanos-world::SK_Mannequin", AssetType.SkeletalMesh )
Assets.Precache( "nanos-world::SK_DesertEagle", AssetType.SkeletalMesh )
Assets.Precache( "nanos-world::SM_M9", AssetType.StaticMesh )

-- Animation
Assets.Precache( "nanos-world::A_Mannequin_Throw_01", AssetType.Animation )
Assets.Precache( "nanos-world::AM_Mannequin_Melee_Stab_Attack", AssetType.Animation )

-- Material
Assets.Precache( "nanos-world::M_NanosDecal", AssetType.Material )
Assets.Precache( "nanos-world::MI_Crosshair_Crossbow", AssetType.Material )

-- Loot
for _, oLootManager in ipairs( LootManager.GetAll() ) do
    Assets.Precache( oLootManager:GetMesh(), AssetType.StaticMesh )
end

--------------------------------------------------------------------------------
-- Max slots
--------------------------------------------------------------------------------
if ( Server.GetMaxPlayers() > #GM.Cfg.CodeNames ) then
    Server.SetMaxPlayers( #GM.Cfg.CodeNames, false )
    Package.Warn( "Server max players is greater than the number of code names. Setting max players to " .. #GM.Cfg.CodeNames )
end