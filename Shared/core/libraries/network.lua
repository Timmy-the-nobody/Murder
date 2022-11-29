local NWReceive = Events.SubscribeRemote
local NWSend = Events.CallRemote
local NWBroadcast = Events.BroadcastRemote

NW = {}
local _tNWStr = {}

--[[
    NW.AddNWString
        desc: Adds a network string to the network string table
        args:
            sNWStr: The name of the network string, must be unique (string)
]]--
function NW.AddNWString( sNWStr )
    if _tNWStr[ sNWStr ] then
        return
    end

    _tNWStr[ sNWStr ] = tostring( table.Count( _tNWStr ) + 1 )
end

if Server then
    --[[
        NW.Send (serverside)
            desc: Sends a packet to a player, or to a table of players
            args:
                sEventName: The networked string ID (string)
                xPlayer: The player(s) to send the packet to (Player/table)
                ...: Any additional arguments to send (any)
            return:
                Whether the packet was sent successfully (boolean)
    ]]--
    function NW.Send( sEventName, xPlayer, ... )
        if not _tNWStr[ sEventName ] then
            Package.Warn( "Trying to send a non-regitered NW packet: " .. sEventName )
            return false
        end

        if IsPlayer( xPlayer ) then
            NWSend( _tNWStr[ sEventName ], xPlayer, ... )
            return true
        end

        if IsTable( xPlayer ) then
            local bSent = false

            for _, pPlayer in ipairs( xPlayer ) do
                if IsPlayer( pPlayer ) then
                    NWSend( _tNWStr[ sEventName ], pPlayer, ... )
                    bSent = true
                end
            end

            return bSent
        end

        return false
    end

    --[[
        NW.Broadcast
            desc: Broadcasts a packet to all players
            args:
                sEventName: The networked string ID (string)
                ...: Any additional arguments to send (any)
            return:
                Whether the packet was broadcasted successfully (boolean)
    ]]--
    function NW.Broadcast( sEventName, ... )
        if not _tNWStr[ sEventName ] then
            Package.Warn( "Trying to broadcast a non-regitered NW packet: " .. sEventName )
            return false
        end

        NWBroadcast( _tNWStr[ sEventName ], ... )
        return true
    end
else
    --[[
        NW.Send (clientside)
            desc: Sends a packet to the server
            args:
                sEventName: The networked string ID (string)
                ...: Any additional arguments to send (any)
            return:
                Whether the packet was sent successfully (boolean)
    ]]--
    function NW.Send( sEventName, ... )
        if not _tNWStr[ sEventName ] then
            Package.Warn( "Trying to send a non-regitered NW packet: " .. sEventName )
            return
        end

        NWSend( _tNWStr[ sEventName ], ... )
    end
end

--[[
    NW.Receive
        desc: Receives a packet from the server
        args:
            sEventName: The networked string ID (string)
            fCallback: The callback function to call when the packet is received (function)
        return:
            Wether or not the packet can be received (boolean)            
]]--
function NW.Receive( sEventName, fCallback )
    if not _tNWStr[ sEventName ] then
        Package.Warn( "Trying to receive a non-regitered NW packet: " .. sEventName )
        return false
    end

    NWReceive( _tNWStr[ sEventName ], fCallback )
    return true
end