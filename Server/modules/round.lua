local iNextTick = 0
local CurTime = CurTime
local sMap = Server.GetMap()

--[[ GM:ClearMap ]]--
function GM:ClearMap()
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
end

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
        if pPlayer:GetControlledCharacter() then
            pPlayer:UnPossess()
        end

        pPlayer:SetVOIPChannel( GM.Cfg.SpectatorVOIPChannel )
        pPlayer:SetVOIPSetting( VOIPSetting.Global )
        pPlayer:ResetCamera()
    end
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

    self:ClearMap()

    local tSpawns = { Vector() }
    if self.CharacterSpawns[ sMap ] and ( #self.CharacterSpawns[ sMap ] > 0 ) then
        tSpawns = self.CharacterSpawns[ sMap ]
    end

    for _, pPlayer in ipairs( tPlayers ) do
        local eChar = pPlayer:CreateCharacter( tSpawns[ math.random( 1, #tSpawns ) ] )

        -- Avoid blocking 2 characters on the same spawn
        eChar:SetCollision( CollisionType.IgnoreOnlyPawn )
        eChar:SetInvulnerable( true )
        eChar:SetCanDrop( false )

        Timer.SetTimeout( function()
            if eChar:IsValid() then
                eChar:SetInvulnerable( false )
                eChar:SetCollision( CollisionType.Normal )
            end
        end, self.Cfg.StartScreenTime )
    end

    local tAllChars = Character.GetAll()

    -- Define Murderer
    local eMurder = tAllChars[ math.random( 1, #tAllChars ) ]
    eMurder:SetMurderer( true )
    eMurder:SetWeapon( WeaponType.Knife )

    -- Define Detective
    for _, eChar in RandPairs( tAllChars ) do
        if not eChar:IsMurderer() then
            eChar:SetWeapon( WeaponType.Pistol )
            break
        end
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