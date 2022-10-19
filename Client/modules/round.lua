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

--------------------------------------------------------------------------------
-- Ambiance Sounds
--------------------------------------------------------------------------------
local sPackagePath = Package.GetPath()
local tAmbiance = {
    [ RoundType.NotEnoughPlayers ] = {
        { path = "package://" .. sPackagePath .. "/Client/resources/sounds/ambiance_01.ogg", volume = 0.7 }
    },
    [ RoundType.Playing ] = {
        { path = "package://" .. sPackagePath .. "/Client/resources/sounds/ambiance_02.ogg", volume = 0.45 },
    },
    [ RoundType.RoundEnd ] = {
        { path = "package://" .. sPackagePath .. "/Client/resources/sounds/ambiance_03.ogg", volume = 0.45 }
    }
}

local tPlaying = {}

Events.Subscribe( "GM:OnRoundChange", function( iOld, iNew )
    if tPlaying[ iOld ] and tPlaying[ iOld ]:IsPlaying() then
        tPlaying[ iOld ]:FadeOut( 5, 0, true )
    end

    if ( iNew == RoundType.Playing ) then
        Sound(
            Vector(),
            "package://" .. sPackagePath .. "/Client/resources/sounds/game_start.ogg",
            true,
            true,
            SoundType.SFX,
            0.25,
            1,
            -1,
            -1,
            AttenuationFunction.Linear,
            false,
            SoundLoopMode.Never
        )
    end

    if not tAmbiance[ iNew ] or ( #tAmbiance[ iNew ] == 0 ) then
        return
    end

    local tRandomAmbiance = tAmbiance[ iNew ][ math.random( 1, #tAmbiance[ iNew ] ) ]
    if not tRandomAmbiance.path then
        return
    end

    tPlaying[ iNew ] = Sound(
        Vector(),
        tRandomAmbiance.path,
        true,
        false,
        SoundType.SFX,
        ( tRandomAmbiance.volume or 0.3 ),
        1,
        -1,
        -1,
        AttenuationFunction.Linear,
        false,
        SoundLoopMode.Forever
    )
end )

Events.Subscribe( "GM:OnRoundEnd", function( iReason )
    if iReason == EndReason.MurdererWins then
        Sound(
            Vector(),
            "package://" .. sPackagePath .. "/Client/resources/sounds/game_end_murderer_wins.ogg",
            true,
            true,
            SoundType.SFX,
            0.3,
            1,
            -1,
            -1,
            AttenuationFunction.Linear,
            false,
            SoundLoopMode.Never
        )
    end
end )