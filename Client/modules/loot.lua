Prop.Subscribe( "ValueChange", function( eSM, sKey, xValue )
    if ( sKey == "loot_id" ) then
        eSM:SetOutlineEnabled( true, 0 )
    end
end )

--[[ Character Highlight ]]--
Character.Subscribe( "Highlight", function( eChar, bIsEnabled, eObject )
    if not LocalCharacter() or ( LocalCharacter() ~= eChar ) then
        return
    end

    if eObject:GetValue( "loot_id" ) then
        eObject:SetOutlineEnabled( true, 0 )
    end
end )