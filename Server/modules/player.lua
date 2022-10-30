--[[ Player:SetScore ]]--
function Player:SetScore( iScore )
    self:SetValue( "score", iScore, true )
end

--[[ Player:CreateCharacter ]]--
function Player:CreateCharacter( tPos )
    if self:GetControlledCharacter() then
        return
    end

    self:SetVOIPChannel( GM.Cfg.InGameVOIPChannel )

    local eChar = Character( tPos + Vector( 0, 0, 40 ), Rotator( 0, math.random( -180, 180 ), 0 ), "nanos-world::SK_Mannequin" )
    self:Possess( eChar )

    eChar:SetCameraMode( CameraMode.FPSOnly )
    eChar:SetCanPunch( false )
    eChar:SetCanDeployParachute( false )
    eChar:SetHighFallingTime( -1 )
    eChar:SetJumpZVelocity( 600 )
    eChar:SetAccelerationSettings( 2048, 512, 768, 128, 256, 256, 1024 )
    eChar:SetBrakingSettings( 4, 2, 2048, 3000, 10, 0 )
    eChar:SetFallDamageTaken( 0 )
    eChar:SetCapsuleSize( 36, 96 )

    -- Gamemode related
    eChar:AttachFlashlight()
    eChar:SetCollectedLoot( 0 )
    eChar:SetFlashlightBattery( 100 )
    eChar:GenerateCodeName()
    eChar:GenerateCodeColor()
    eChar:ComputeSpeed()

    eChar:SetValue( "default_code_name", eChar:GetCodeName(), false )
    eChar:SetValue( "default_code_color", eChar:GetCodeColor(), false )
    eChar:SetValue( "possesser_name", self:GetName(), true )

    return eChar
end

--[[ playerInit ]]--
local function playerInit( pPlayer )
    if not pPlayer or not pPlayer:IsValid() then
        return
    end

    pPlayer:SetVOIPSetting( GM.Cfg.VOIPSetting )
    pPlayer:SetVOIPChannel( GM.Cfg.SpectatorVOIPChannel )
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