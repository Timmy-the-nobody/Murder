NW.AddNWString( "GM:Character:RequestDisguise" )

--[[ Character:IsMurderer ]]--
function Character:IsMurderer()
    return self:GetValue( "murderer", false )
end

--[[ Character:IsTeamKiller ]]--
function Character:IsTeamKiller()
    return self:GetValue( "team_killer", false )
end

--[[ Character:GetCodeName ]]--
function Character:GetCodeName()
    return self:GetValue( "code_name", "" )
end

--[[ Character:GetCodeColor ]]--
function Character:GetCodeColor( bToRGBString )
    local tCol = self:GetValue( "code_color", Color.YELLOW )
    if not bToRGBString then
        return tCol
    end

    return "rgb(" .. ( tCol.R * 255 ) .. "," .. ( tCol.G * 255 ) .. "," .. ( tCol.B * 255 ) .. ")"
end

--[[ Character:GetCollectedLoot ]]--
function Character:GetCollectedLoot()
    return self:GetValue( "collected_loot", 0 )
end

--[[ Character:IsDisguised ]]--
function Character:IsDisguised()
    return self:GetValue( "is_disguised", false )
end