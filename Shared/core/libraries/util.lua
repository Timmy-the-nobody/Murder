--[[ IsPlayer ]]--
function IsPlayer( xAny )
    return ( getmetatable( xAny ) == Player )
end

--[[ IsCharacter ]]--
function IsCharacter( xAny )
    return ( getmetatable( xAny ) == Character )
end

--[[
    tobool
        desc: Converts any value to a boolean
        args: Value (any)
        return: Boolean (bool)
]]--
function tobool( xVal )
    if not xVal or ( xVal == false ) or ( xVal == "false" ) or ( xVal == 0 ) or ( xVal == "0" ) then
        return false
    end
    return true
end

--[[ FormatTime ]]--
function FormatTime( iTimestamp, bLeftFromNow )
    iTimestamp = math.abs( iTimestamp )

    local floor = math.floor
    local iTime = CurTime() / 1000

    if bLeftFromNow then
        iTimestamp = ( iTimestamp - iTime )
    end

    local bIsNegative = ( iTimestamp < 0 )

    local iDays = floor( iTimestamp / 86400 )
    iTimestamp = iTimestamp - ( iDays * 86400 )

    local iHours = floor( iTimestamp / 3600 ) % 24
    iTimestamp = iTimestamp - ( iHours * 3600 )

    local iMinutes = floor( iTimestamp / 60 ) % 60
    iTimestamp = iTimestamp - ( iMinutes * 60 )

    local iSeconds = floor( iTimestamp % 60 )

    -- I don't like this part of the code, but it works
    local sTime = ""
    if ( iDays > 0 ) then
        sTime = sTime .. ( iDays + "d " .. iHours + "h " .. iMinutes .. "min " .. iSeconds .. "s" )
    else
        if ( iHours > 0 ) then
            sTime = ( iHours .. "h " .. iMinutes .. "min " .. iSeconds .. "s" )
        else
            if ( iMinutes > 0 ) then
                sTime = ( iMinutes .. "min " .. iSeconds .. "s" )
            else
                sTime = ( iSeconds .. "s" )
            end
        end
    end

    return sTime, bIsNegative
end