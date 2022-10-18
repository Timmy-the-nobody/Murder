--[[ Character Possessed ]]--
Character.Subscribe( "Possessed", function( _, pPlayer )
    if not LocalPlayer() or ( pPlayer ~= LocalPlayer() ) then
        return
    end

    -- TODO: Remove workaround when fixed in game
    Timer.SetTimeout( function()
        -- Effects
        World.SetPPBloom( 0.5, 5 )
        World.SetPPChromaticAberration( 1.2, 0.001 )
        World.SetPPImageEffects( 0.5, 1 )

        -- Color correction
        World.SetPPFilm( 0.8, 0.55, 0.26, 0.001, 0.3 )
        World.SetPPGlobalSaturation( Color( 0.8, 0.8, 1 ) )
    end, 0 )
end )