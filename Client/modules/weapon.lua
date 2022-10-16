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
Client.SetHighlightColor( GM.Cfg.KnifeHighlightColor, 0, HighlightMode.Always )

--[[ Melee ValueChange ]]--
Melee.Subscribe( "ValueChange", function( eMelee, sKey, xValue )
    if eMelee:IsValid() and ( sKey == "thrown_knife" ) then
        eMelee:SetHighlightEnabled( tobool( xValue ), 0 )
    end
end )

--[[ Character Highlight ]]--
Character.Subscribe( "Highlight", function( _, _, eObject )
    if eObject and eObject:IsValid() then
        local bThrownKnife = eObject:GetValue( "thrown_knife" )
        if bThrownKnife then
            eObject:SetHighlightEnabled( true, 0 )
        end
    end
end )