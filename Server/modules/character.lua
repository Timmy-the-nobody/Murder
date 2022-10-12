--------------------------------------------------------------------------------
-- Murder
--------------------------------------------------------------------------------
--[[ Character:SetMurderer ]]--
function Character:SetMurderer( bMurderer )
    self:SetValue( "murderer", tobool( bMurderer ), true )
end

--------------------------------------------------------------------------------
-- Team killer
--------------------------------------------------------------------------------
--[[ Character:SetTeamKiller ]]--
function Character:SetTeamKiller( bTeamKiller )
    if bTeamKiller and self:IsTeamKiller() then
        return
    end

    self:SetPrivateValue( "team_killer", tobool( bTeamKiller ) )
    self:Drop()

    local oTimer = Timer.SetTimeout( function()
        self:SetTeamKiller( false )
    end, GM.Cfg.TeamKillPenaltyDuration )

    Timer.Bind( oTimer, self )
end

--------------------------------------------------------------------------------
-- Code name
--------------------------------------------------------------------------------
--[[ Character:SetCodeName ]]--
function Character:SetCodeName( sName )
    self:SetValue( "code_name", sName, true )
end

--[[ Character:GenerateCodeName ]]--
function Character:GenerateCodeName()
    local sName = GM.Cfg.CodeNames[ math.random( 1, #GM.Cfg.CodeNames ) ]
    for _, eChar in ipairs( Character.GetAll() ) do
        if ( eChar:GetCodeName() == sName ) then
            return self:GenerateCodeName()
        end
    end

    self:SetCodeName( sName )
end

--[[ Character:SetCodeColor ]]--
function Character:SetCodeColor( tColor )
    if getmetatable( tColor ) == Color then
        self:SetValue( "code_color", tColor, true )
        self:SetMaterialColorParameter( "Tint", tColor )
    end
end

--[[ Character:GenerateCodeColor ]]--
function Character:GenerateCodeColor()
    self:SetCodeColor( GM.Cfg.CodeColors[ math.random( 1, #GM.Cfg.CodeColors ) ] )
end

--------------------------------------------------------------------------------
-- Speed
--------------------------------------------------------------------------------
--[[ Character:ComputeSpeed ]]--
function Character:ComputeSpeed()
    local fSpeedMul = 1.2

	if self:IsTeamKiller() then
		fSpeedMul = ( fSpeedMul * GM.Cfg.TeamKillSpeedMultiplier )
	end

	local ePicked = self:GetPicked()
	if ePicked and ePicked:IsValid() then
        local iWeaponType = ePicked:GetValue( "weapon_type" )
        if iWeaponType then
            if ( iWeaponType == WeaponType.Knife ) then
                fSpeedMul = ( fSpeedMul * GM.Cfg.KnifeSpeedMultiplier )
            else
                fSpeedMul = ( fSpeedMul * GM.Cfg.PistolSpeedMultiplier )
            end
        else
            fSpeedMul = ( fSpeedMul * GM.Cfg.PistolSpeedMultiplier )
        end
	end

    self:SetCanSprint( self:IsMurderer() )
    self:SetSpeedMultiplier( fSpeedMul )
end

Character.Subscribe( "Drop", function( eChar, _ ) eChar:ComputeSpeed() end )
Character.Subscribe( "PickUp", function( eChar, _ ) eChar:ComputeSpeed() end )
Character.Subscribe( "GrabProp", function( eChar, _ ) eChar:ComputeSpeed() end )

--------------------------------------------------------------------------------
-- Death
--------------------------------------------------------------------------------
--[[ Character Death ]]--
Character.Subscribe( "Death", function( eChar, _, _, _, _, pInstigator, eCauser )
    -- Send voice in dead players VOIP channel
    local pPlayer = eChar:GetPlayer()
    if pPlayer and pPlayer:IsValid() then
        pPlayer:SetVOIPChannel( GM.Cfg.VOIPChannelDead )
        pPlayer:UnPossess()
        -- pPlayer:FindSpectateTarget()
    end

    -- Drop stored weapon
    local iStoredWeapon = eChar:GetStoredWeapon()
    if iStoredWeapon and GM.Weapons[ iStoredWeapon ] then
        local eWeapon = GM.Weapons[ iStoredWeapon ].spawn()
        eWeapon:SetLocation( eChar:GetLocation() )
    end

    -- Murder death
    if eChar:IsMurderer() then
        eChar:UnDisguise()
    end

    local eAttacker
    if pInstigator and pInstigator:GetControlledCharacter() then
        eAttacker = pInstigator:GetControlledCharacter()
    end

    if not eAttacker:IsValid() then
        return
    end

    if not eChar:IsMurderer() then
        -- Murderer kill
        if eAttacker:IsMurderer() then
            eAttacker:UnDisguise()

        -- Team kill
        else
            eAttacker:SetTeamKiller( true )
            eAttacker:ComputeSpeed()
        end
    end
end )

--------------------------------------------------------------------------------
-- Disguise
--------------------------------------------------------------------------------
--[[ Character:Disguise ]]--
function Character:Disguise( eChar )
    if not IsCharacter( eChar ) then
        return
    end

    self:SetPrivateValue( "is_disguised", true )
    self:SetCodeName( eChar:GetCodeName() )
    self:SetCodeColor( eChar:GetCodeColor() )
end

--[[ Character:UnDisguise ]]--
function Character:UnDisguise()
    if not self:IsDisguised() then
        return
    end

    self:SetPrivateValue( "is_disguised", false )
    self:SetCodeName( self:GetValue( "default_code_name" ) )
    self:SetCodeColor( self:GetValue( "default_code_color" ) )
end

--[[ GM:Character:RequestDisguise ]]--
NW.Receive( "GM:Character:RequestDisguise", function( pPlayer, eVictim )
    local eChar = pPlayer:GetControlledCharacter()
    if not IsCharacter( eChar ) or not eChar:IsMurderer() or ( eChar:GetHealth() <= 0 ) then
        return
    end

    if ( eChar:GetCollectedLoot() < GM.Cfg.DisguiseLootRequired ) then
        return
    end

    if not IsCharacter( eVictim ) or ( eVictim:GetHealth() > 0 ) then
        return
    end

    if ( eChar:GetLocation():DistanceSquared( eVictim:GetLocation() ) > 20000 ) then
        return
    end

    local iLastDisguise = eChar:GetValue( "last_disguise" )
    if iLastDisguise and ( CurTime() < ( iLastDisguise + GM.Cfg.DisguiseCooldown ) ) then
        return
    end

    eChar:SetValue( "last_disguise", CurTime(), false )

    eChar:SetCollectedLoot( eChar:GetCollectedLoot() - GM.Cfg.DisguiseLootRequired )
    eChar:Disguise( eVictim )
end )