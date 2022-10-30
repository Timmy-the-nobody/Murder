-- --[[ WEAPON_KNIFE constructor ]]--
-- WEAPON_KNIFE = SWEPManager( "knife" )
-- WEAPON_KNIFE:SetName( "Knife" )

-- --[[ WEAPON_KNIFE:Spawn ]]--
-- function WEAPON_KNIFE:Spawn( tPos, tAng )
--     local eKnife = Melee(
--         tPos or Vector(),
--         tAng or Rotator(),
--         "nanos-world::SM_M9",
--         CollisionType.Normal,
--         true,
--         HandlingMode.Throwable,
--         ""
--     )

--     eWeapon:SetScale( Vector( 0.8 ) )
--     eWeapon:AddAnimationCharacterUse( "nanos-world::AM_Mannequin_Melee_Stab_Attack" )
--     eWeapon:SetDamageSettings( 0.3, 0.5 )
--     eWeapon:SetCooldown( 1 )
--     eWeapon:SetBaseDamage( 1000 )
--     eWeapon:SetCrosshairMaterial( "nanos-world::MI_Crosshair_Crossbow" )

--     return eKnife
-- end

-- --[[ WEAPON_KNIFE:CanPickup ]]--
-- function WEAPON_KNIFE:CanPickup( eChar )
--     return eChar:IsMurderer()
-- end

-- --[[ WEAPON_KNIFE:OnPickup ]]--
-- function WEAPON_KNIFE:OnPickup( eChar, eWeapon )
--     eObject:SetValue( "thrown_knife", false, true )
-- end

-- --[[ WEAPON_KNIFE:OnDrop ]]--
-- function WEAPON_KNIFE:OnDrop( eChar, eWeapon )
--     eObject:SetValue( "thrown_knife", true, true )
-- end