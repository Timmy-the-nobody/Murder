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

    if pPlayer:IsInAdminMode() then
        pPlayer:SetPrivateValue( "admin_mode", false )
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

--------------------------------------------------------------------------------
-- Spectator mode
--------------------------------------------------------------------------------
-- --[[
--     Player:FindSpectateTarget
--         desc: Finds a target to spectate
--         returns: Player
-- ]]--
-- function Player:FindSpectateTarget()
--     local eChar = self:GetControlledCharacter()
--     if IsCharacter( eChar ) then
--         return print( 1 )
--     end

--     local tSpectatable = {}
--     for _, v in ipairs( Player.GetAll() ) do
--         if v:GetControlledCharacter() then
--             tSpectatable[ #tSpectatable + 1 ] = v
--         end
--     end

--     if ( #tSpectatable == 0 ) then
--         return print( 2 )
--     end

--     print( "try")

--     local bFoundLast = false
--     local pLastSpectated = self:GetValue( "spectated_player", false )

--     for _, v in ipairs( tSpectatable ) do
--         if bFoundLast or not pLastSpectated then
--             self:SetPrivateValue( "spectated_player", v )
--             self:Spectate( v, 1 )

--             print( "spectating", v )

--             return v
--         end

--         if ( v == pLastSpectated ) then
--             bFoundLast = true
--         end
--     end

--     if not bFoundLast then
--         self:SetPrivateValue( "spectated_player", nil )
--         self:FindSpectateTarget()
--     end
-- end

-- --[[ Spectate ]]--
-- NW.Receive( "GM:Player:Spectate", function( pPlayer )
--     pPlayer:FindSpectateTarget()
-- end )