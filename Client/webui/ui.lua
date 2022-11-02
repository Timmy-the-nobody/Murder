local mathCeil = math.ceil
local CurTime = CurTime

GM.WebUI = WebUI( "GUI", "file://webui/index.html", true )
GM.WebUI:Subscribe( "Ready", function()
    GM.WebUI:CallEvent( "SetElementInnerHTML", "req-loot-bystander", "Innocents can loot <b>" .. GM.Cfg.BonusRequiredCollectables .. " collectable(s)</b> to get a pistol" )
    GM.WebUI:CallEvent( "SetElementInnerHTML", "req-loot-murderer", "The murderer can loot <b>" .. GM.Cfg.DisguiseLootRequired .. " collectable(s)</b> to be able to disguise as a victim" )
end )

--[[ updateWaitingPlayers ]]--
local function updateWaitingPlayers()
    local iPlyCount = #Player.GetAll()
    if ( iPlyCount < GM.Cfg.MinPlayers ) then
        GM.WebUI:CallEvent( "SetElementInnerText", "waiting-players-title", "Awaiting players" )
        GM.WebUI:CallEvent( "SetElementInnerText", "waiting-players-text", iPlyCount .. "/" .. GM.Cfg.MinPlayers )
    else
        GM.WebUI:CallEvent( "SetElementInnerText", "waiting-players-title", iPlyCount .. " player(s) ready!" )
        GM.WebUI:CallEvent( "SetElementInnerText", "waiting-players-text", "The game is about to start" )
    end
end

--[[ Round based updates ]]--
local tHUDActions = {
    [ RoundType.NotEnoughPlayers ] = {
        title = "Waiting for Players (min. " .. GM.Cfg.MinPlayers .. " required)",
        onStart = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "hud", "none" )
            GM.WebUI:CallEvent( "SetElementDisplay", "spectating", "none" )
            GM.WebUI:CallEvent( "SetElementDisplay", "spectating-disclose", "none" )
            GM.WebUI:CallEvent( "SetElementDisplay", "waiting-players", "block" )
            updateWaitingPlayers()
        end,
        onEnd = function()
            GM.WebUI:CallEvent( "SetElementDisplay", "waiting-players", "none" )
        end
    },
    [ RoundType.Playing ] = {
        title = "Game In Progress",
        onStart = function()
            local eChar = LocalCharacter()
            if not eChar then
                GM.WebUI:CallEvent( "SetElementDisplay", "spectating", "block" )
                GM.WebUI:CallEvent( "SetElementDisplay", "spectating-disclose", "block" )
                return
            end

            if eChar:IsMurderer() then
                GM.WebUI:CallEvent( "SetElementInnerText", "role", "Murderer" )
                GM.WebUI:CallEvent( "ShowStartScreen", "You're the Murderer", [[
                    You have to murder everybody, preferably without being spotted
                ]], GM.Cfg.StartScreenTime )
            else
                GM.WebUI:CallEvent( "SetElementInnerText", "role", "Bystander" )

                -- Detective
                if eChar:GetStoredWeapon() and ( eChar:GetStoredWeapon() == WeaponType.Pistol ) then
                    GM.WebUI:CallEvent( "ShowStartScreen", "You're the Detective", [[
                        The bystanders and detective have to find out who the murderer is and kill him
                    ]], GM.Cfg.StartScreenTime )

                -- Bystander
                else
                    GM.WebUI:CallEvent( "ShowStartScreen", "You're a Bystander", [[
                        The bystanders and detective have to find out who the murderer is and kill him
                    ]], GM.Cfg.StartScreenTime )
                end
            end

            GM.WebUI:CallEvent( "SetElementDisplay", "hud", "flex" )
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
            GM.WebUI:CallEvent( "SetElementDisplay", "round-overview", "none" )
        end
    }
}

--[[ GM:OnRoundChange ]]--
Events.Subscribe( "GM:OnRoundChange", function( iOld, iNew )
    if tHUDActions[ iOld ] then
        tHUDActions[ iOld ].onEnd()
    end
    if tHUDActions[ iNew ] then
        tHUDActions[ iNew ].onStart()
        GM.WebUI:CallEvent( "SetElementInnerText", "round", tHUDActions[ iNew ].title )
    end
end )

--[[ updateRoundOverview ]]--
local function updateRoundOverview()
    local tData = {}
    for _, v in ipairs( Character.GetAll() ) do
        if not v:IsValid() then
            goto continue
        end

        local iInd = ( #tData + 1 )
        local iLootCount = 0
        if v:GetValue( "total_loot" ) then
            iLootCount = v:GetValue( "total_loot" )
        else
            iLootCount = v:GetCollectedLoot()
        end

        tData[ iInd ] = {
            codename = v:GetCodeName(),
            color = v:GetCodeColor( true ),
            isMurderer = v:IsMurderer(),
            isAlive = ( v:GetHealth() > 0 ),
            collectedLoot = iLootCount,
            possesserName = v:GetValue( "possesser_name", "???" )
        }

        ::continue::
    end

    GM.WebUI:CallEvent( "UpdateRoundOverview", tData )
    GM.WebUI:CallEvent( "SetElementDisplay", "round-overview", "block" )
end

--[[ GM:OnRoundEnd ]]--
local tRoundEndReason = {
    [ EndReason.MurdererWins ] = "Murderer Wins",
    [ EndReason.MurdererLoses ] = "Survivors Wins",
    [ EndReason.MurdererLeft ] = "Murderer Left"
}

Events.Subscribe( "GM:OnRoundEnd", function( iReason )
    if tRoundEndReason[ iReason ] then
        GM.WebUI:CallEvent( "SetElementInnerText", "end-game-text", tRoundEndReason[ iReason ] )
    end

    Timer.SetTimeout( updateRoundOverview, 0 )
end )

--[[ Character ValueChange ]]--
local tValueChange = {
    [ "collected_loot" ] = function( _, xValue )
        GM.WebUI:CallEvent( "SetElementInnerText", "collected-loot", "Loot: " .. xValue )
    end,
    [ "code_name" ] = function( _, xValue )
        GM.WebUI:CallEvent( "SetElementInnerText", "code-name", xValue )
    end,
    [ "code_color" ] = function( eChar, _ )
        GM.WebUI:CallEvent( "SetElementProperty", "hud", "container-color", eChar:GetCodeColor( true ) )
    end,
    [ "team_killer" ] = function( _, xValue )
        if xValue then
            GM.WebUI:CallEvent( "MakeBlind", GM.Cfg.TeamKillBlindTime, GM.Cfg.TeamKillBlindFadeTime )
        end
    end,
    [ "flashlight_battery" ] = function( _, xValue )
        GM.WebUI:CallEvent( "SetElementInnerText", "flashlight-battery", math.floor( xValue ) .. "%" )
    end,
    [ "stored_weapon" ] = function( _, _ )
        RebuildKeybinds()
    end
}

Character.Subscribe( "ValueChange", function( eChar, sKey, xValue )
    if LocalCharacter() and ( eChar == LocalCharacter() ) then
        if tValueChange[ sKey ] then
            tValueChange[ sKey ]( eChar, xValue )
        end
    end
end )

Player.Subscribe( "ValueChange", function( pPlayer, sKey, xValue )
    if LocalPlayer() and ( LocalPlayer() == pPlayer ) then
        if ( sKey == "admin_mode_enabled" ) then
            GM.WebUI:CallEvent( "SetElementDisplay", "admin", xValue and "block" or "none" )
            return
        end

        if ( sKey == "admin_submode" ) then
            GM.WebUI:CallEvent( "SetElementInnerText", "admin-submode", "[SubMode] " .. GM.AdminSubModes[ xValue ].name )
        end
    end
end )

--[[ Character Death ]]--
Character.Subscribe( "Death", function( eChar )
    local pPlayer = eChar:GetPlayer()
    if pPlayer and ( pPlayer == LocalPlayer() ) then
        GM.WebUI:CallEvent( "SetElementDisplay", "hud", "none" )
        GM.WebUI:CallEvent( "SetElementDisplay", "spectating", "block" )
        GM.WebUI:CallEvent( "SetElementDisplay", "spectating-disclose", "block" )
    end
end )

--[[ Player Spawn ]]--
Player.Subscribe( "Spawn", updateWaitingPlayers )

--[[ Player Destroy ]]--
Player.Subscribe( "Destroy", updateWaitingPlayers )

--[[ Client Tick ]]--
local iNextTick = 0
Client.Subscribe( "Tick", function( fDelta )
    local iTime = CurTime()
    if ( iTime < iNextTick ) then
        return
    end

    iNextTick = iTime + 1000

    local iSecondsLeft = mathCeil( GM:GetRoundTimeLeft() / 1000 )
    GM.WebUI:CallEvent( "SetElementInnerText", "round-time", "Time left: " .. FormatTime( iSecondsLeft ) )
end )

--------------------------------------------------------------------------------
-- Scoreboard
--------------------------------------------------------------------------------
--[[ updateScoreboard ]]--
local function updateScoreboard()
    for _, pPlayer in ipairs( Player.GetAll() ) do
        GM.WebUI:CallEvent( "UpdateScoreboardRow", pPlayer:GetSteamID(), pPlayer:GetScore(), pPlayer:GetPing() )
    end
end

--[[ Player Spawn ]]--
local function addScoreboardRow( pPlayer )
    GM.WebUI:CallEvent( "AddScoreboardRow", pPlayer:GetSteamID(), pPlayer:GetName() )
    updateScoreboard()
end

Player.Subscribe( "Spawn", addScoreboardRow )

--[[ Player Destroy ]]--
local function removeScoreboardRow( pPlayer )
    GM.WebUI:CallEvent( "RemoveScoreboardRow", pPlayer:GetSteamID() )
    updateScoreboard()
end

Player.Subscribe( "Destroy", removeScoreboardRow )

--[[ Inputs ]]--
Input.Register( "Scoreboard", "Tab" )
Input.Bind( "Scoreboard", InputEvent.Pressed, function()
    GM.WebUI:CallEvent( "SetElementDisplay", "scoreboard", "flex" )
    updateScoreboard()
    Client.SetMouseEnabled( true )
end )

Input.Bind( "Scoreboard", InputEvent.Released, function()
    GM.WebUI:CallEvent( "SetElementDisplay", "scoreboard", "none" )
    Client.SetMouseEnabled( false )
end )

--[[ Misc. ]]--
Character.Subscribe( "Death", updateScoreboard )
Events.Subscribe( "GM:OnRoundChange", updateScoreboard )

Player.Subscribe( "ValueChange", function( pPlayer, sKey, _ )
    if ( pPlayer == LocalPlayer() ) and ( sKey == "score" ) then
        updateScoreboard()
    end
end )

Package.Subscribe( "Load", function()
    for _, pPlayer in ipairs( Player.GetAll() ) do
        GM.WebUI:CallEvent( "AddScoreboardRow", pPlayer:GetSteamID(), pPlayer:GetName() )
    end
    updateScoreboard()
end )

--[[ Player VOIP ]]--
Player.Subscribe( "VOIP", function( pPlayer, bIsTalking )
    local eChar = pPlayer:GetControlledCharacter()
    local sName = eChar and eChar:GetCodeName() or pPlayer:GetName()

    GM.WebUI:CallEvent( ( bIsTalking and "AddTalker" or "RemoveTalker" ), pPlayer:GetSteamID(), sName )
end )

--[[ RebuildKeybinds ]]--
function RebuildKeybinds()
    GM.WebUI:CallEvent( "ClearKeybinds" )

    local pPlayer = Client.GetLocalPlayer()
    if not pPlayer then
        return
    end

    local eChar = pPlayer:GetControlledCharacter()
    if not eChar then
        GM.WebUI:CallEvent( "AddBindTooltip", Input.GetKeyIcon( Input.GetMappedKey( "Scoreboard" ), true ), "Scoreboard" )
        GM.WebUI:CallEvent( "AddBindTooltip", Input.GetKeyIcon( Input.GetMappedKey( "Rules" ), true ), "Rules" )
        return
    end

    GM.WebUI:CallEvent( "AddBindTooltip", Input.GetKeyIcon( Input.GetMappedKey( "Flashlight" ), true ), "Flashlight" )
    GM.WebUI:CallEvent( "AddBindTooltip", Input.GetKeyIcon( Input.GetMappedKey( "Taunt" ), true ), "Taunt" )

    local bEquiped = ( eChar:GetPicked() ~= nil )
    bEquiped = bEquiped or ( eChar:GetStoredWeapon() == nil )

    GM.WebUI:CallEvent( "AddBindTooltip", Input.GetKeyIcon( Input.GetMappedKey( "Equip/Unequip Weapon" ), true ), ( bEquiped and "Unequip" or "Equip" ) .. " Weapon" )

    if bEquiped and eChar:IsMurderer() then
        GM.WebUI:CallEvent( "AddBindTooltip", Input.GetKeyIcon( Input.GetMappedKey( "Throw Knife" ), true ), "Throw Knife" )
    end
end

Package.Subscribe( "Load", RebuildKeybinds )

Character.Subscribe( "Death", function( eChar )
    if LocalCharacter() and ( eChar == LocalCharacter() ) then RebuildKeybinds() end
end )
Character.Subscribe( "PickUp", function( eChar )
    if LocalCharacter() and ( eChar == LocalCharacter() ) then RebuildKeybinds() end
end )
Character.Subscribe( "Drop", function( eChar )
    if LocalCharacter() and ( eChar == LocalCharacter() ) then RebuildKeybinds() end
end )

Events.Subscribe( "GM:OnRoundChange", RebuildKeybinds )

--------------------------------------------------------------------------------
-- Rules
--------------------------------------------------------------------------------
local bRulesToggled = false

Input.Register( "Rules", "F2" )
Input.Bind( "Rules", InputEvent.Pressed, function()
    bRulesToggled = not bRulesToggled

    if bRulesToggled then
        GM.WebUI:CallEvent( "SetElementDisplay", "rules", "flex" )
        Client.SetMouseEnabled( true )
    else
        GM.WebUI:CallEvent( "SetElementDisplay", "rules", "none" )
        Client.SetMouseEnabled( false )
    end
end )