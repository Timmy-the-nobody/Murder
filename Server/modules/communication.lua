--------------------------------------------------------------------------------
-- Chat commands
--------------------------------------------------------------------------------
-- local tCommands = {
--     {
--         command = "/ooc",
--         onSend = function( pPlayer, sText )
--             Server.BroadcastChatMessage( "<Bold>" .. pPlayer:GetName() .. "</> " .. sText )
--         end,
--         hide = true
--     }
-- }

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

    -- for _, v in ipairs( tCommands ) do
    --     if ( string.sub( sText, 1, #v.command ) == v.command ) then
    --         v.onSend( pPlayer, string.sub( sText, #v.command + 2 ) )
    --         if v.hide then
    --             return false
    --         end
    --         return
    --     end
    -- end

    -- local eChar = pPlayer:GetControlledCharacter()
    -- if not eChar or not eChar:IsValid() then
    --     tCommands[ 1 ].onSend( pPlayer, sText )
    --     return false
    -- end

    -- local sName = eChar:GetCodeName()
    -- local sMessage = "<" .. ( ( eChar:GetHealth() > 0 ) and "green" or "red" ) .. ">" .. sName .. "</> " .. sText


    -- Server.BroadcastChatMessage( sMessage )

    return false
end )