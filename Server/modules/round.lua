local iNextTick = 0
local CurTime = CurTime

--[[
    GM:SetRound
        desc: Sets the round
        args:
            iRound: The new round (number)
]]--
function GM:SetRound( iRound )
    local iOld = self.CurrentRound

    self.CurrentRound = iRound
    self.RoundStart = CurTime()

    Events.Call( "GM:OnRoundChange", iOld, GM.CurrentRound )
    NW.Broadcast( "GM:Round:Sync", self.CurrentRound, self.RoundStart )
end

--[[
    GM:EndRound
        desc: Ends the current round
        args:
            iReason: The reason for the round ending (number)
]]--
function GM:EndRound( iReason )
    if ( self:GetRound() ~= RoundType.Playing ) then
        return
    end

    iReason = ( iReason or EndReason.Unknown )

    local tAllChars = Character.GetAll()
    for _, eChar in ipairs( tAllChars ) do
        if not eChar:IsValid() then
            goto continue
        end

        if ( iReason == EndReason.MurdererWins ) then
            if eChar:IsMurderer() then
                local pPlayer = eChar:GetPlayer()
                if pPlayer and pPlayer:IsValid() then
                    pPlayer:SetScore( pPlayer:GetScore() + 1 )
                end
            end
        else
            if not eChar:IsMurderer() and ( eChar:GetHealth() > 0 ) then
                local pPlayer = eChar:GetPlayer()
                if pPlayer and pPlayer:IsValid() then
                    pPlayer:SetScore( pPlayer:GetScore() + 1 )
                end
            end
        end

        ::continue::
    end

    if ( iReason == EndReason.MurdererWins ) then
        Package.Log( "Murderer wins!" )
    elseif ( iReason == EndReason.MurdererLoses ) then
        Package.Log( "Murderer loses!" )
    elseif ( iReason == EndReason.MurdererLeft ) then
        Package.Log( "Murderer rage quitted!" )
    end

    Events.Call( "GM:OnRoundEnd", iReason )
    NW.Broadcast( "GM:Round:RoundEnd", iReason )

    -- Round ending
    self:SetRound( RoundType.RoundEnd )

    -- Clear/Reset stuff
    for _, pPlayer in ipairs( Player.GetAll() ) do
        pPlayer:SetVOIPChannel( GM.Cfg.VOIPChannelDefault )
        pPlayer:ResetCamera()
    end

    Timer.SetTimeout( function()
        -- Clear map entities
        local tClear = {
            "Character",
            "Weapon",
            "Melee",
            "Prop",
            "StaticMesh",
            "Particle",
            "Trigger",
            "Light"
        }

        for _, sClass in ipairs( tClear ) do
            for _, v in ipairs( _ENV[ sClass ].GetAll() ) do
                if v:IsValid() then
                    v:Destroy()
                end
            end
        end

        Events.Call( "GM:OnMapCleared" )
    end, GM.Cfg.RoundEndTime or 5000 )
end

--[[
    GM:StartRound
        desc: Starts the round
]]--
function GM:StartRound()
    local tPlayers = Player.GetAll()
    if ( #tPlayers < GM.Cfg.MinPlayers ) then
        return
    end

    local sMap = Server.GetMap()
    local tSpawns = { Vector() }
    if GM.CharacterSpawns[ sMap ] and ( #GM.CharacterSpawns[ sMap ] > 0 ) then
        tSpawns = GM.CharacterSpawns[ sMap ]
    end

    for _, pPlayer in ipairs( tPlayers ) do
        local tRandomSpawn = tSpawns[ math.random( 1, #tSpawns ) ]

        local eChar = Character( tRandomSpawn + Vector( 0, 0, 40 ), Rotator( 0, math.random( -180, 180 ), 0 ), "nanos-world::SK_Mannequin" )
        eChar:SetCameraMode( CameraMode.FPSOnly )
        eChar:SetCanPunch( false )
        eChar:SetCanDeployParachute( false )
        eChar:SetHighFallingTime( -1 )
        eChar:SetJumpZVelocity( 600 )
        eChar:SetAccelerationSettings( 1024, 512, 768, 128, 256, 256, 1024 )
        eChar:SetBrakingSettings( 4, 2, 1024, 3000, 10, 0 )
        eChar:SetFallDamageTaken( 0 )
        eChar:AttachFlashlight()

        pPlayer:Possess( eChar )
        eChar:SetValue( "possesser_name", pPlayer:GetName(), true )

        -- Avoid blocking 2 characters on the same spawn
        eChar:SetCollision( CollisionType.IgnoreOnlyPawn )
        eChar:SetInvulnerable( true )
        eChar:SetCanDrop( false )

        Timer.SetTimeout( function()
            if eChar:IsValid() then
                eChar:SetInvulnerable( false )
                eChar:SetCollision( CollisionType.Normal )
            end
        end, GM.Cfg.StartScreenTime )
    end

    local tAllChars = Character.GetAll()

    -- Murderer
    local eMurder = tAllChars[ math.random( 1, #tAllChars ) ]
    eMurder:SetMurderer( true )
    eMurder:SetWeapon( WeaponType.Knife )

    -- Non-murderer characters
    local tCivs = {}
    for _, eChar in ipairs( tAllChars ) do
        if not eChar:IsMurderer() then
            tCivs[ #tCivs + 1 ] = eChar
        end
    end

    if ( #tCivs >= 1 ) then
        local eGunner = tCivs[ math.random( 1, #tCivs ) ]
        eGunner:SetWeapon( WeaponType.Pistol )
    end

    -- Initialize characters values
    for _, eChar in ipairs( tAllChars ) do
        eChar:SetCollectedLoot( 0 )
        eChar:SetFlashlightBattery( 100 )
        eChar:GenerateCodeName()
        eChar:GenerateCodeColor()
        eChar:ComputeSpeed()

        eChar:SetValue( "default_code_name", eChar:GetCodeName(), false )
        eChar:SetValue( "default_code_color", eChar:GetCodeColor(), false )
    end

    self:SetRound( RoundType.Playing )
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
--[[ Server Tick ]]--
Server.Subscribe( "Tick", function( fDelta )
    local iTime = CurTime()
    if ( iTime < iNextTick ) then
        return
    end

    iNextTick = ( iTime + 500 )

    local iRound = GM:GetRound()
    local iRoundStart = GM:GetRoundStart()

    if ( iRound == RoundType.NotEnoughPlayers ) then
        if ( iTime > ( iRoundStart + GM.Cfg.PlayersWaitTime ) ) then
            GM:StartRound()
        end
        return
    end

    if ( iRound == RoundType.Playing ) then
        if ( iTime > ( iRoundStart + GM.Cfg.RoundMaxTime ) ) then
            GM:EndRound( EndReason.MurdererLoses )
            return
        end

        GM:LootTick()
        return
    end

    if ( iRound == RoundType.RoundEnd ) then
        if ( iTime > ( iRoundStart + GM.Cfg.RoundEndTime ) ) then
            GM:SetRound( RoundType.NotEnoughPlayers )
        end
    end
end )

--[[ handleRoundStateByAlivePlayers ]]--
local function handleRoundStateByAlivePlayers()
    local tAlive = {}
    for _, v in ipairs( Character.GetAll() ) do
        if ( v:GetHealth() > 0 ) then
            tAlive[ #tAlive + 1 ] = v
        end
    end

    if ( #tAlive == 1 ) then
        GM:EndRound( EndReason.MurdererWins )
    end
end

--[[ Character Death ]]--
Character.Subscribe( "Death", function( eChar )
    if eChar:IsMurderer() then
        GM:EndRound( EndReason.MurdererLoses )
    else
        handleRoundStateByAlivePlayers()
    end
end )

--[[ Player Destroy ]]--
Player.Subscribe( "Destroy", function( pPlayer )
    local eChar = pPlayer:GetControlledCharacter()
    if not eChar or not eChar:IsValid() then
        return
    end

    local bWasMurder = eChar:IsMurderer()
    if eChar:IsValid() then
        eChar:Destroy()
    end

    if bWasMurder then
        GM:EndRound( EndReason.MurdererLeft )
        return
    end

    handleRoundStateByAlivePlayers()
end )

--[[ Package Load ]]--
Package.Subscribe( "Load", function()
    GM:SetRound( RoundType.NotEnoughPlayers )
end )