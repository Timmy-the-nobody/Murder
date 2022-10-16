Prop.Subscribe( "ValueChange", function( eSM, sKey, xValue )
    if ( sKey == "loot_id" ) then
        eSM:SetOutlineEnabled( true, 0 )
    end
end )