GM.WebUI = WebUI( "GUI", "file://ui/index.html", true )

local tHUDActions = {
    [ RoundType.NotEnoughPlayers ] = {
        title = "Waiting for Players (2 required)",
        onStart = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "hud", "none" )
        end,
        onEnd = function()
        end
    },
    [ RoundType.Playing ] = {
        title = "Game In Progress",
        onStart = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "hud", "block" )

            local eChar = LocalCharacter()
            if eChar and eChar:IsValid() then
                GM.WebUI:CallEvent( "SetElementInnerHTML", "name", eChar:GetCodeName() )
                GM.WebUI:CallEvent( "SetProperty", "code-color", eChar:GetCodeColor( true ) )
                GM.WebUI:CallEvent( "SetElementDisplay", "collected-loot", eChar:IsMurderer() and "none" or "block" )
            end
        end,
        onEnd = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "hud", "none" )
        end
    },
    [ RoundType.RoundEnd ] = {
        title = "Game over",
        onStart = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "end-game", "block" )
        end,
        onEnd = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "end-game", "none" )
        end
    }
}

Events.Subscribe( "GM:OnRoundChange", function( iOld, iNew )
    if tHUDActions[ iOld ] then
        tHUDActions[ iOld ].onEnd()
    end
    if tHUDActions[ iNew ] then
        tHUDActions[ iNew ].onStart()
        GM.WebUI:CallEvent( "SetElementInnerHTML", "round", tHUDActions[ iNew ].title )
    end
end )

Events.Subscribe( "GM:OnRoundEnd", function( iReason )
    if ( iReason == EndReason.MurdererWins ) then
        GM.WebUI:CallEvent( "SetElementInnerHTML", "end-game-text", "Murderer Wins" )
        return
    end

    if ( iReason == EndReason.MurdererLoses ) then
        GM.WebUI:CallEvent( "SetElementInnerHTML", "end-game-text", "Survivors Wins" )
        return
    end

    if ( iReason == EndReason.MurdererLeft ) then
        GM.WebUI:CallEvent( "SetElementInnerHTML", "end-game-text", "Murderer Left" )
        return
    end
end )

Character.Subscribe( "ValueChange", function( eChar, sKey, xValue )
    if ( sKey == "collected_loot" ) then
        GM.WebUI:CallEvent( "SetElementInnerHTML", "collected-loot", xValue )
    end
end )