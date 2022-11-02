local sOOCCmd = "/ooc"

local stringFormat = string.format
local sendChatMessage = Server.SendChatMessage
local broadcastChatMessage = Server.BroadcastChatMessage

--[[ Server Chat ]]--
Server.Subscribe( "Chat", function( sText, pPlayer )
    -- OOC
    if ( string.sub( sText, 1, #sOOCCmd ) == sOOCCmd ) then
        local sMsg = stringFormat( "[OOC] <Bold>%s</> %s", pPlayer:GetName(), string.sub( sText, #sOOCCmd + 1 ) )
        broadcastChatMessage( sMsg )
        return false
    end

    -- RP chat
    local eChar = pPlayer:GetControlledCharacter()
    if eChar then
        local sMsg = stringFormat( "<green>%s</> %s", eChar:GetCodeName(), sText )

        for _, p in ipairs( Player.GetAll() ) do
            if p:GetControlledCharacter() then
                sendChatMessage( p, sMsg )
            end
        end
        return false
    end

    -- Spectator/Dead chat
    local sMsg = stringFormat( "[Spectator] <Bold>%s</> %s", pPlayer:GetName(), sText )

    for _, p in ipairs( Player.GetAll() ) do
        if not p:GetControlledCharacter() then
            sendChatMessage( p, sMsg )
        end
    end

    return false
end )