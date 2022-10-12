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