NW.AddNWString( "GM:Round:Sync" )
NW.AddNWString( "GM:Round:RoundEnd" )

--[[ GM:GetRound ]]--
function GM:GetRound()
    return self.CurrentRound or RoundType.NotEnoughPlayers
end

--[[ GM:GetRoundStart ]]--
function GM:GetRoundStart()
    return self.RoundStart or CurTime()
end