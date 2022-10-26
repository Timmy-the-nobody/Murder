local pairs = pairs

--[[
    table.Copy
        desc: Copy a table and inherit it's metatable
        args: Target (table)
        return: Table deep copy (table)
]]--
function table.Copy( tTarget )
    local tNew = {}
    for xKey, xVal in pairs( tTarget ) do
        tNew[ xKey ] = xVal
    end

    return setmetatable( tNew, getmetatable( tTarget ) )
end

--[[
    table.Count
        desc: Count the keys in a non sequential table, equivalent to #table on sequential tables
        return: Counted keys (number)
]]--
function table.Count( tTarget )
    local i = 0
    for _, _ in pairs( tTarget ) do
        i = ( i + 1 )
    end

    return i
end

--[[ table.Random ]]--
function table.Random( tInput )
	local iRandKey, iCurKey = math.random( 1, table.Count( tInput ) ), 1
    for xKey, xVal in pairs( tInput ) do
		if ( iCurKey == iRandKey ) then
            return xVal, xKey
        end
        iCurKey = ( iCurKey + 1 )
	end
end

--[[ table.ClearKeys ]]--
function table.ClearKeys( tTarget )
    local tOutput = {}
    for _, xVal in pairs( tTarget ) do
        tOutput[ #tOutput + 1 ] = xVal
    end

    return tOutput
end

--[[ RandPairs ]]--
function RandPairs( tInput )
    local tKeys = {}
    for i = 1, #tInput do
        tKeys[ i ] = i
    end

    local tOutput = {}
    for i = 1, #tInput do
        local iRandKey = math.random( 1, #tKeys )
        tOutput[ i ] = tInput[ tKeys[ iRandKey ] ]
        table.remove( tKeys, iRandKey )
    end

    return pairs( tOutput )
end