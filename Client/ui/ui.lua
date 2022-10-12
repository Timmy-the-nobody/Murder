GM.WebUI = WebUI( "GUI", "file://ui/index.html", true )

local tHUDActions = {
    [ RoundType.NotEnoughPlayers ] = {
        title = "Waiting for Players (min. 2 required)",
        onStart = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "spectating", "none" )
        end,
        onEnd = function()
        end
    },
    [ RoundType.Playing ] = {
        title = "Game In Progress",
        onStart = function()
            local eChar = LocalCharacter()
            if not eChar then
                GM.WebUI:CallEvent( "SetElementDisplay", "spectating", "block" )
                return
            end

            if eChar:IsMurderer() then
                GM.WebUI:CallEvent( "SetElementInnerHTML", "role", "Murderer", "color: red;" )
                GM.WebUI:CallEvent( "ShowStartScreen", "You're the Murderer", [[
                    The murderer has to murder everybody.
                    The murderer has the ability to run, stab, and throw their knife, but must preferably not get caught in order to not get shot.
                    The murderer also has the ability to see other player's footprints.
                ]], GM.Cfg.StartScreenTime )
            else
                GM.WebUI:CallEvent( "SetElementInnerHTML", "role", "Bystander", "color: blue;" )

                -- Detective
                if eChar:GetStoredWeapon() and ( eChar:GetStoredWeapon() == WeaponType.Pistol ) then
                    GM.WebUI:CallEvent( "ShowStartScreen", "You're the Detective", [[
                        The bystanders and detective have to find out who the murderer is and can only win by killing the murderer.
                        If the detective kills another bystander, he becomes blind and drops the gun.
                        Only other bystanders can pick up the gun, however the detective can pick it up again once they are no longer blind.
                    ]], GM.Cfg.StartScreenTime )

                -- Bystander
                else
                    GM.WebUI:CallEvent( "ShowStartScreen", "You're a Bystander", [[
                        The bystanders and detective have to find out who the murderer is and can only win by killing the murderer.
                        If the detective kills another bystander, he becomes blind and drops the gun.
                        Only other bystanders can pick up the gun, however the detective can pick it up again once they are no longer blind.
                    ]], GM.Cfg.StartScreenTime )
                end
            end

            GM.WebUI:CallEvent( "SetElementDisplay", "hud", "block" )
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

local tValueChange = {
    [ "collected_loot" ] = function( eChar, xValue )
        GM.WebUI:CallEvent( "SetElementInnerHTML", "collected-loot", xValue )
    end,
    [ "code_name" ] = function( eChar, xValue )
        GM.WebUI:CallEvent( "SetElementInnerHTML", "code-name", xValue )
    end,
    [ "code_color" ] = function( eChar, xValue )
        GM.WebUI:CallEvent( "SetProperty", "code-color", eChar:GetCodeColor( true ) )
    end,
    [ "team_killer" ] = function( eChar, xValue )
        if not xValue then
            return
        end
        GM.WebUI:CallEvent( "MakeBlind", GM.Cfg.TeamKillBlindTime, GM.Cfg.TeamKillBlindFadeTime )
    end
}

Character.Subscribe( "ValueChange", function( eChar, sKey, xValue )
    if LocalCharacter() and ( eChar == LocalCharacter() ) then
        if tValueChange[ sKey ] then
            tValueChange[ sKey ]( eChar, xValue )
        end
    end
end )

--[[ Character Death ]]--
Character.Subscribe( "Death", function( eChar )
    local pPlayer = eChar:GetPlayer()
    if pPlayer and ( pPlayer == LocalPlayer() ) then
        GM.WebUI:CallEvent( "SetElementDisplay", "hud", "none" )
        GM.WebUI:CallEvent( "SetElementDisplay", "spectating", "block" )
    end
end )

--[[ Client Tick ]]--
local mathCeil = math.ceil
local CurTime = CurTime

local iNextTick = 0
Client.Subscribe( "Tick", function( fDelta )
    if ( CurTime() < iNextTick ) then
        return
    end

    iNextTick = CurTime() + 1000

    local iSecondsLeft = mathCeil( GM:GetRoundTimeLeft() / 1000 )
    GM.WebUI:CallEvent( "SetElementInnerHTML", "round-time", "Time left: " .. iSecondsLeft .. "s" )
end )