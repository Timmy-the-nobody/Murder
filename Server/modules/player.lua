Player.Subscribe( "Ready", function( pPlayer )
    NW.Send( "GM:Round:Sync", pPlayer, GM:GetRound(), GM.RoundStart )

    if ( GM:GetRound() == RoundType.NotEnoughPlayers ) then
        NW.Send( "GM:Round:Start", pPlayer )
    end
end )