Input.Register( "Equip/Unequip Weapon", "F" )
Input.Bind( "Equip/Unequip Weapon", InputEvent.Pressed, function()
    NW.Send( "GM:Weapon:Toggle" )
end )

Input.Register( "Throw Knife", "A" )
Input.Bind( "Throw Knife", InputEvent.Pressed, function()
    NW.Send( "GM:Weapon:ThrowKnife" )
end )

--------------------------------------------------------------------------------
-- Knife highlight
--------------------------------------------------------------------------------
local tColor = Color( 2000, 0, 0 )
Client.SetHighlightColor( tColor, 0, HighlightMode.Always )

--[[ Melee ValueChange ]]--
Melee.Subscribe( "ValueChange", function( eMelee, sKey, xValue )
    if ( sKey == "thrown_knife" ) then
        eMelee:SetHighlightEnabled( xValue, 0 )
    end
end )

--[[ Character Highlight ]]--
Character.Subscribe( "Highlight", function( _, _, eObject )
    if not eObject or not eObject:IsValid() then
        return
    end

    local bThrownKnife = eObject:GetValue( "thrown_knife" )
    if bThrownKnife then
        eObject:SetHighlightEnabled( true, 0 )
    end
end )