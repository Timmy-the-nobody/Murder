--[[ Server Chat ]]--
Server.Subscribe( "Chat", function( sText, pPlayer )
    local eChar = pPlayer:GetControlledCharacter()
    if eChar then
        for _, p in ipairs( Player.GetAll() ) do
            if p:GetControlledCharacter() then
                Server.SendChatMessage( p, "<green>" .. eChar:GetCodeName() .. "</> " .. sText )
            end
        end
        return false
    end

    for _, p in ipairs( Player.GetAll() ) do
        if not p:GetControlledCharacter() then
            Server.SendChatMessage( p, "[Spectator] <Bold>" .. pPlayer:GetName() .. "</> " .. sText )
        end
    end

    return false
end )