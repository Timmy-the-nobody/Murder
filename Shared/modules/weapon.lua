NW.AddNWString( "GM:Weapon:Toggle" )
NW.AddNWString( "GM:Weapon:ThrowKnife" )

--[[ Character:GetStoredWeapon ]]--
function Character:GetStoredWeapon()
    return self:GetValue( "stored_weapon", false )
end