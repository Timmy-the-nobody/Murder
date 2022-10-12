local getTime = _ENV[ Client and "Client" or "Server" ].GetTime

--[[
    CurTime
        desc: Returns the current time in milliseconds.
]]--
function CurTime()
    return getTime()
end