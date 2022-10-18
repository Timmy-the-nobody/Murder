--[[ Character:AttachFlashlight ]]--
function Character:AttachFlashlight()
    if self:GetAttachedFlashlight() then
        return
    end

    local eFlashlight = StaticMesh( Vector(), Rotator(), "nanos-world::SM_Flashlight", CollisionType.NoCollision )
    eFlashlight:SetScale( Vector( 0.6 ) )
    eFlashlight:AttachTo( self, AttachmentRule.SnapToTarget, "spine_03", -1, false )
    eFlashlight:SetRelativeRotation( Rotator( 0, 100, 0 ) )
    eFlashlight:SetRelativeLocation( Vector( 24, -12, 14 ) )

    local eLight = Light( Vector(), Rotator(), Color.WHITE, LightType.Spot, 35, 2000, 40, 0, 5000, true, true, false )
    eLight:AttachTo( eFlashlight, AttachmentRule.SnapToTarget, "", -1, false )
    eLight:SetTextureLightProfile( LightProfile.SpotLight_03 )
    eLight:SetRelativeLocation( Vector( 35, 0, 0 ) )

    self:SetValue( "flashlight_mesh", eFlashlight, false )
    self:SetValue( "flashlight_light", eLight, false )
end

--[[ Character:GetAttachedFlashlight ]]--
function Character:GetAttachedFlashlight()
    return self:GetValue( "flashlight_mesh" ), self:GetValue( "flashlight_light" )
end

--[[ Character:SetFlashlightBattery ]]--
function Character:SetFlashlightBattery( iBattery )
    iBattery = NanosMath.Clamp( iBattery, 0, 100 )
    if ( iBattery == self:GetFlashlightBattery() ) then
        return
    end

    self:SetPrivateValue( "flashlight_battery", iBattery )

    if ( iBattery <= 0 ) then
        self:DisableFlashlight()
    end
end

--[[ Character:EnableFlashlight ]]--
function Character:EnableFlashlight()
    if self:IsFlashlightEnabled() then
        return false
    end

    if ( self:GetFlashlightBattery() <= 0 ) then
        return false, "Not enough battery"
    end

    -- Clear regen timer
    local iRegenTimer = self:GetValue( "battery_regen_timer" )
    if iRegenTimer and Timer.IsValid( iRegenTimer ) then
        Timer.ClearInterval( iRegenTimer )
        self:SetValue( "battery_regen_timer", nil, false )
    end

    -- Drain
    local iDrainTimer = Timer.SetInterval( function()
        self:SetFlashlightBattery( self:GetFlashlightBattery() - 1 )
    end, GM.Cfg.FlashlightDrainTime )
    Timer.Bind( iDrainTimer, self )
    self:SetValue( "battery_drain_timer", iDrainTimer )

    -- Enable light
    local eSM, eLight = self:GetAttachedFlashlight()
    if eSM and eSM:IsValid() then
        eSM:SetMaterialColorParameter( "Emissive", Color( 50, 50, 50 ) )
    end
    if eLight and eLight:IsValid() then
        eLight:SetVisibility( true )
    end

    self:SetValue( "flashlight_enabled", true, true )
    return true
end

--[[ Character:DisableFlashlight ]]--
function Character:DisableFlashlight()
    if not self:IsFlashlightEnabled() then
        return false
    end

    -- Clear drain timer
    local iDrainTimer = self:GetValue( "battery_drain_timer" )
    if iDrainTimer and Timer.IsValid( iDrainTimer ) then
        Timer.ClearInterval( iDrainTimer )
        self:SetValue( "battery_drain_timer", nil, false )
    end

    -- Regen
    local iRegenTimer = Timer.SetInterval( function()
        self:SetFlashlightBattery( self:GetFlashlightBattery() + 1 )
    end, GM.Cfg.FlashlightRegenTime )
    Timer.Bind( iRegenTimer, self )
    self:SetValue( "battery_regen_timer", iRegenTimer )

    -- Detach flashlight
    local eSM, eLight = self:GetAttachedFlashlight()
    if eSM and eSM:IsValid() then
        eSM:SetMaterialColorParameter( "Emissive", Color.BLACK )
    end
    if eLight and eLight:IsValid() then
        eLight:SetVisibility( false )
    end

    self:SetValue( "flashlight_enabled", false, true )
    return true
end

--[[ GM:Flashlight:Toggle ]]--
NW.Receive( "GM:Flashlight:Toggle", function( pPlayer )
    local eChar = pPlayer:GetControlledCharacter()
    if not eChar or not eChar:IsValid() or ( eChar:GetHealth() <= 0 ) then
        return
    end

    if eChar:IsFlashlightEnabled() then
        local bSuccess = eChar:DisableFlashlight()
        if bSuccess then
            pPlayer:Notify( NotificationType.Info, "Flashlight disabled" )
        end
    else
        local bSuccess = eChar:EnableFlashlight()
        if bSuccess then
            pPlayer:Notify( NotificationType.Info, "Flashlight enabled" )
        end
    end
end )