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

    if ( iReason == EndReason.MurdererWins ) then
        print( "murderer wins!" )
    elseif ( iReason == EndReason.MurdererLoses ) then
        print( "murderer loses!" )
    elseif ( iReason == EndReason.MurdererLeft ) then
        print( "murderer rage quitted!" )
    end

    Events.Call( "GM:OnRoundEnd", iReason )
    NW.Broadcast( "GM:Round:RoundEnd", iReason )

    for _, pPlayer in ipairs( Player.GetAll() ) do
        pPlayer:SetVOIPChannel( GM.Cfg.VOIPChannelDefault )
        pPlayer:ResetCamera()
    end

    -- Round ending
    self:SetRound( RoundType.RoundEnd )

    Timer.SetTimeout( function()
        -- Clear map entities
        local tClear = {
            "Character",
            "Weapon",
            "Melee",
            "Prop",
            "StaticMesh",
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
    local tSpawns = GM.Cfg.CharacterSpawns[ sMap ] and GM.Cfg.CharacterSpawns[ sMap ] or { { Vector(), Rotator() } }

    for _, pPlayer in ipairs( tPlayers ) do
        local tRandomSpawn = tSpawns[ math.random( 1, #tSpawns ) ]

        local eChar = Character( tRandomSpawn[ 1 ], tRandomSpawn[ 2 ] or Rotator(), "nanos-world::SK_Mannequin" )
        eChar:SetCanPunch( false )
        eChar:SetCanDeployParachute( false )
        eChar:SetHighFallingTime( -1 )
        eChar:SetCameraMode( CameraMode.FPSOnly )
        eChar:AttachFlashlight()

        pPlayer:Possess( eChar )

        -- Avoid blocking 2 characters on the same spawn
        eChar:SetCollision( CollisionType.IgnoreOnlyPawn )
        eChar:SetInvulnerable( true )
        eChar:SetCanDrop( false )

        Timer.SetTimeout( function()
            if eChar:IsValid() then
                eChar:SetCanDrop( true )
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
local iNextTick = 0
Server.Subscribe( "Tick", function( fDelta )
    local iTime = CurTime()
    local iRound = GM:GetRound()
    local iRoundStart = GM:GetRoundStart()

    if ( iTime < iNextTick ) then
        return
    end

    iNextTick = iTime + 500

    if ( iRound == RoundType.NotEnoughPlayers ) then
        if ( iTime > ( iRoundStart + GM.Cfg.PlayersWaitTime ) ) then
            -- if ( #Player.GetAll() > 1 ) then
                GM:StartRound()
            -- end
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

--[[ handleRoundByAlivePlayers ]]--
local function handleRoundByAlivePlayers()
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
        handleRoundByAlivePlayers()
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

    handleRoundByAlivePlayers()
end )

--[[ Package Load ]]--
Package.Subscribe( "Load", function()
    GM:SetRound( RoundType.NotEnoughPlayers )
end )