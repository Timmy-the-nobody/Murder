WEAPON_DEAGLE = SWEPManager( "deagle" )
WEAPON_DEAGLE:SetName( "Desert Eagle" )

--[[ WEAPON_DEAGLE:Spawn ]]--
function WEAPON_DEAGLE:Spawn( tPos, tAng )
    local eDeagle = NanosWorldWeapons.DesertEagle(
        tPos or Vector(),
        tAng or Rotator()
    )

    eDeagle:SetAmmoSettings( 1, 99999, 1, 1 )
    eDeagle:SetBulletColor( Color( 1, 1, 1 ) )
    eDeagle:SetDamage( 1000 )

    return eDeagle
end

--[[ WEAPON_DEAGLE:CanPickup ]]--
function WEAPON_DEAGLE:CanPickup( eChar )
    if eChar:IsMurderer() or eChar:IsTeamKiller() then
        return false
    end
    return true
end

-- [ WeaponType.Pistol ] = {
--     canPickup = function( eChar )
--         if eChar:IsMurderer() or eChar:IsTeamKiller() then
--             return false
--         end
--         return true
--     end,
--     spawn = function()
--         local ePistol = NanosWorldWeapons.DesertEagle( Vector(), Rotator() )
--         ePistol:SetAmmoSettings( 1, 99999, 1, 1 )
--         ePistol:SetBulletColor( Color( 1, 1, 1 ) )
--         ePistol:SetDamage( 1000 )
--         ePistol:SetValue( "weapon_type", WeaponType.Pistol )
--         return ePistol
--     end
-- }