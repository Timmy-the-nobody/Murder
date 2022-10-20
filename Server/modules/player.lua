--[[ Player:SetScore ]]--
function Player:SetScore( iScore )
    self:SetValue( "score", iScore, true )
end

--[[ playerInit ]]--
local function playerInit( pPlayer )
    if not pPlayer or not pPlayer:IsValid() then
        return
    end

    pPlayer:SetVOIPSetting( GM.Cfg.VOIPSetting )
    pPlayer:SetVOIPChannel( GM.Cfg.VOIPChannelDefault )
    pPlayer:ResetCamera()

    if pPlayer:IsAdminModeEnabled() then
        pPlayer:SetAdminModeEnabled( false )
    end

    -- Sync round state
    NW.Send( "GM:Round:Sync", pPlayer, GM:GetRound(), GM.RoundStart )
end

--[[ Player Ready ]]--
Player.Subscribe( "Ready", playerInit )

--[[ Package Load ]]--
Package.Subscribe( "Load", function()
    for _, pPlayer in ipairs( Player.GetAll() ) do
        playerInit( pPlayer )
    end
end )