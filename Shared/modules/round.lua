NW.AddNWString( "GM:Round:Sync" )
NW.AddNWString( "GM:Round:RoundEnd" )

local mathMax = math.max
local CurTime = CurTime

--[[ GM:GetRound ]]--
function GM:GetRound()
    return self.CurrentRound or RoundType.NotEnoughPlayers
end

--[[ GM:GetRoundStart ]]--
function GM:GetRoundStart()
    return self.RoundStart or CurTime()
end

--[[ GM:GetRoundTimeLeft ]]--
function GM:GetRoundTimeLeft()
    local iRound = self:GetRound()
    if ( iRound == RoundType.NotEnoughPlayers ) then
        return mathMax( 0, self.Cfg.PlayersWaitTime - ( CurTime() - self:GetRoundStart() ) )
    end
    if ( iRound == RoundType.Playing ) then
        return mathMax( 0, self.Cfg.RoundMaxTime - ( CurTime() - self:GetRoundStart() ) )
    end
    if ( iRound == RoundType.RoundEnd ) then
        return mathMax( 0, self.Cfg.RoundEndTime - ( CurTime() - self:GetRoundStart() ) )
    end
    return 0
end