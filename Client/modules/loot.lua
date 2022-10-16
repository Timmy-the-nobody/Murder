--[[ Prop ValueChange ]]--
Prop.Subscribe( "ValueChange", function( eSM, sKey, _ )
    if eSM:IsValid() and ( sKey == "loot_id" ) then
        eSM:SetOutlineEnabled( true, 0 )
    end
end )

--[[ Character Highlight ]]--
Character.Subscribe( "Highlight", function( eChar, bIsEnabled, eObject )
    if LocalCharacter() and ( LocalCharacter() == eChar )  then
        if eObject and eObject:IsValid() and eObject:GetValue( "loot_id" ) then
            eObject:SetOutlineEnabled( true, 0 )
        end
    end
end )