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
    bTeamKiller = tobool( bTeamKiller )
    if ( bTeamKiller == self:IsTeamKiller() ) then
        return
    end

    self:SetPrivateValue( "team_killer", bTeamKiller )
    self:ComputeSpeed()

    -- Team kill penalty
    local oTimer = Timer.SetTimeout( function()
        self:SetTeamKiller( false )
    end, GM.Cfg.TeamKillPenaltyDuration )

    Timer.Bind( oTimer, self )

    -- Drop current weapon
    if bTeamKiller then
        self:Drop()
    end
end

--------------------------------------------------------------------------------
-- Code name/code color
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
    if ( getmetatable( tColor ) == Color ) then
        self:SetValue( "code_color", tColor, true )
        self:SetMaterialColorParameter( "Tint", tColor * 0.25 )
    end
end

--[[ Character:GenerateCodeColor ]]--
local function findLessUsedColor()
    local tAllChars = Character.GetAll()
    local tColorCount = {}

    for _, eChar in ipairs( tAllChars ) do
        local tColor = eChar:GetCodeColor()
        if tColor then
            tColorCount[ tColor ] = ( tColorCount[ tColor ] or 0 ) + 1
        end
    end

    local tUnusedColors = {}
    for _, tColor in ipairs( GM.Cfg.CodeColors ) do
        if not tColorCount[ tColor ] then
            tUnusedColors[ #tUnusedColors + 1 ] = tColor
        end
    end

    if ( #tUnusedColors > 0 ) then
        return tUnusedColors[ math.random( 1, #tUnusedColors ) ]
    end

    local tLeastUsedColor
    for tColor, iCount in pairs( tColorCount ) do
        if not tLeastUsedColor or ( iCount < tColorCount[ tLeastUsedColor ] ) then
            tLeastUsedColor = tColor
        end
    end

    return tLeastUsedColor
end

function Character:GenerateCodeColor()
    self:SetCodeColor( findLessUsedColor() )
end

--------------------------------------------------------------------------------
-- Speed
--------------------------------------------------------------------------------
--[[ Character:ComputeSpeed ]]--
function Character:ComputeSpeed()
    local fSpeedMul = GM.Cfg.DefaultSpeed

    if not self:IsMurderer() and self:IsTeamKiller() then
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

    -- self:SetCanSprint( self:IsMurderer() )
    self:SetSpeedMultiplier( fSpeedMul )
end

Character.Subscribe( "GaitModeChanged", function( eChar, _, _ ) eChar:ComputeSpeed() end )
Character.Subscribe( "Drop", function( eChar, _ ) eChar:ComputeSpeed() end )
Character.Subscribe( "PickUp", function( eChar, _ ) eChar:ComputeSpeed() end )
Character.Subscribe( "GrabProp", function( eChar, _ ) eChar:ComputeSpeed() end )

--------------------------------------------------------------------------------
-- Death
--------------------------------------------------------------------------------
--[[ Character Death ]]--
Character.Subscribe( "Death", function( eChar, _, _, _, _, pInstigator, _ )
    -- Send voice in dead players VOIP channel
    local pPlayer = eChar:GetPlayer()
    if pPlayer and pPlayer:IsValid() then
        pPlayer:UnPossess()
        pPlayer:SetVOIPChannel( GM.Cfg.SpectatorVOIPChannel )
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

    if not eAttacker or not eAttacker:IsValid() then
        return
    end

    if not eChar:IsMurderer() then
        -- Murderer kill
        if eAttacker:IsMurderer() then
            eAttacker:UnDisguise()

        -- Team kill
        else
            eAttacker:SetTeamKiller( true )
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

    pPlayer:Notify( NotificationType.Info, "You're now disguised!" )
end )