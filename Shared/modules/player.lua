--[[ Player:GetScore ]]--
function Player:GetScore()
    return self:GetValue( "score", 0 )
end