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
    local pAttacker
    if pInstigator and pInstigator:GetControlledCharacter() then
        pAttacker = pInstigator:GetControlledCharacter()
    end

    if not eChar:IsMurderer() and not pAttacker:IsMurderer() then
        pAttacker:SetTeamKiller( true )
        pAttacker:ComputeSpeed()
    end
end )