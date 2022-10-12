--[[ GM:Round:Sync ]]--
NW.Receive( "GM:Round:Sync", function( iRound, iStartTime )
    local iOld = GM.CurrentRound

    GM.CurrentRound = iRound
    GM.RoundStart = iStartTime

    Events.Call( "GM:OnRoundChange", iOld, GM.CurrentRound )
end )

--[[ GM:Round:RoundEnd ]]--
NW.Receive( "GM:Round:RoundEnd", function( iReason )
    Events.Call( "GM:OnRoundEnd", iReason )
end )