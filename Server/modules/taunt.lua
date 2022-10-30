local CurTime = CurTime

--[[ Character:Taunt ]]--
function Character:Taunt()
    if ( #GM.Taunts == 0 ) or ( self:GetHealth() <= 0 ) then
        return
    end

    local iNextTaunt = self:GetValue( "next_taunt" )
    if iNextTaunt and ( CurTime() < iNextTaunt ) then
        local pPlayer = self:GetPlayer()
        if pPlayer and pPlayer:IsValid() then
            pPlayer:Notify( NotificationType.Info, "Wait " .. math.ceil( ( iNextTaunt - CurTime() ) * 0.001 ) .. " seconds before taunting again." )
        end
        return
    end

    self:SetValue( "next_taunt", CurTime() + GM.Cfg.TauntCooldown, false )

    NW.Broadcast( "GM:Taunt:Play", self, math.random( 1, #GM.Taunts ) )
end

--[[ GM:Taunt:Request ]]--
NW.Receive( "GM:Taunt:Request", function( pPlayer )
    if not pPlayer or not pPlayer:IsValid() then
        return
    end

    local eChar = pPlayer:GetControlledCharacter()
    if eChar and eChar:IsValid() then
        eChar:Taunt()
    end
end )