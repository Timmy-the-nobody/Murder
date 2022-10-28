local tFlashlightColor = Color( 0.97, 0.76, 0.46 )

--[[ Character:AttachFlashlight ]]--
function Character:AttachFlashlight()
    if self:GetAttachedFlashlight() then
        return
    end

    local eFlashlight = StaticMesh( Vector(), Rotator(), "nanos-world::SM_Flashlight", CollisionType.NoCollision )
    eFlashlight:SetScale( Vector( 0.5 ) )
    eFlashlight:AttachTo( self, AttachmentRule.SnapToTarget, "head", -1, false )
    eFlashlight:SetRelativeRotation( Rotator( 0, 90, 0 ) )
    eFlashlight:SetRelativeLocation( Vector( 12, -4, 0 ) )

    local eLight = Light( Vector(), Rotator(), tFlashlightColor, LightType.Spot, 5, 3000, 28, 0, 5000, true, true, false )
    eLight:AttachTo( eFlashlight, AttachmentRule.SnapToTarget, "", -1, false )
    eLight:SetTextureLightProfile( LightProfile.Shattered_04 )
    eLight:SetRelativeLocation( Vector( 35, 0, 0 ) )

    self:SetValue( "flashlight_mesh", eFlashlight, false )
    self:SetValue( "flashlight_light", eLight, false )

    self:Subscribe( "Destroy", function()
        if eFlashlight:IsValid() then
           eFlashlight:Destroy()
        end
        if eLight:IsValid() then
            eLight:Destroy()
        end
    end )
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
        if ( self:GetGaitMode() == GaitMode.Sprinting ) then
            self:SetFlashlightBattery( self:GetFlashlightBattery() + 1 )
        end
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
local tFLCooldown = {}

NW.Receive( "GM:Flashlight:Toggle", function( pPlayer )
    local iTime = CurTime()
    if tFLCooldown[ pPlayer ] and ( tFLCooldown[ pPlayer ] > iTime ) then
        return
    end

    tFLCooldown[ pPlayer ] = ( iTime + 350 )

    local eChar = pPlayer:GetControlledCharacter()
    if not eChar or not eChar:IsValid() or ( eChar:GetHealth() <= 0 ) then
        return
    end

    if eChar:IsFlashlightEnabled() then
        eChar:DisableFlashlight()
    else
        eChar:EnableFlashlight()
    end
end )

--------------------------------------------------------------------------------
-- Light bug
--------------------------------------------------------------------------------
if not GM.Cfg.FlashlightBugDelay then
    return
end

--[[ triggerLightBug ]]--
local function triggerLightBug()
    local tHasFlashlightEnabled = {}
    for _, v in ipairs( Character.GetAll() ) do
        if v:IsValid() and v:IsFlashlightEnabled() then
            tHasFlashlightEnabled[ #tHasFlashlightEnabled + 1 ] = v
        end
    end

    if ( #tHasFlashlightEnabled == 0 ) then
        return
    end

    local eChar = tHasFlashlightEnabled[ math.random( 1, #tHasFlashlightEnabled ) ]
    if not eChar or not eChar:IsValid() then
        return
    end

    local pPlayer = eChar:GetPlayer()
    if pPlayer and pPlayer:IsValid() then
        pPlayer:Notify( NotificationType.Generic, "Your flashlight starts to flicker for an unknown reason" )
    end

    local iIntervals = 0
    local iTimer = Timer.SetInterval( function()
        if ( iIntervals == 5 ) then
            return false
        end

        iIntervals = iIntervals + 1

        if ( iIntervals < 3 ) or ( iIntervals > 4 ) then
            if eChar:IsFlashlightEnabled() then
                eChar:DisableFlashlight()
            else
                eChar:EnableFlashlight()
            end
        end
    end, 150 )

    Timer.Bind( iTimer, eChar )
end

--[[ Server Tick ]]--
local iLightBugInterval = false

Events.Subscribe( "GM:OnRoundChange", function( _, iNew )
    if ( iNew ~= RoundType.Playing ) then
        if iLightBugInterval and Timer.IsValid( iLightBugInterval ) then
            Timer.ClearInterval( iLightBugInterval )
            iLightBugInterval = false
        end
        return
    end

    iLightBugInterval = Timer.SetInterval( triggerLightBug, GM.Cfg.FlashlightBugDelay )
end )