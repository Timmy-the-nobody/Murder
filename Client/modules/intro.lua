local Vector = Vector
local Rotator = Rotator
local CurTime = CurTime

--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------
local bDebugIntro = false       -- Put on true to stay in freecam, and place the camera where you want

local tIntro = {
    [ "murder-underground::nw_underground" ] = {
        {
            text = "Area 01",
            duration = 5000,
            start = { pos = Vector( -1560, 3847, -350 ), ang = Rotator( 0, 90, 0 ) },
            target = { pos = Vector( -1560, 3847, -1050 ), ang = Rotator( 0, 90, 0 ) }
        },
        {
            text = "Tunnel",
            duration = 5000,
            start = { pos = Vector( -2564, 9050, -150 ), ang = Rotator( 349, 0, -180 ) },
            target = { pos = Vector( -1000, 9050, -400 ), ang = Rotator( 349, 0, 0 ) }
        },
        {
            text = "Corridor",
            duration = 5000,
            start = { pos = Vector( -8895, 4600, -100 ), ang = Rotator( 0, 90, -25 ) },
            target = { pos = Vector( -8895, 8300, -85 ), ang = Rotator( 0, -89, 0 ) }
        },
        {
            text = "Office",
            duration = 5000,
            start = { pos = Vector( -5684, 6240, -50 ), ang = Rotator( -45, 0, 32 ) },
            target = { pos = Vector( -3313, 3593, -50 ), ang = Rotator( 0, 56, 0 ) }
        },
        {
            text = "Office (2)",
            duration = 5000,
            start = { pos = Vector( -3105, 5573, 256 ), ang = Rotator( 339, 332, 32 ) },
            target = { pos = Vector( -801, 5544, -49 ), ang = Rotator( 350, 233, -12 ) }
        },

        {
            text = "Operating Room",
            duration = 10000,
            start = { pos = Vector( -8488, 8, -28 ), ang = Rotator( 300, 142, -90 ) },
            target = { pos = Vector( -9320, 375, 35 ), ang = Rotator( 332, 322, 0 ) }
        },
    }
}

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
local bIntroRunning = false
local lastTranslateTo = false

--[[ stopIntro ]]--
local function stopIntro()
    LocalPlayer():ResetCamera()

    if lastTranslateTo then
        Client.Unsubscribe( "Tick", lastTranslateTo )
        lastTranslateTo = false
    end

    Client.SetInputEnabled( true )
    Client.SetMouseEnabled( false )

    bIntroRunning = false
end

if bDebugIntro then
    stopIntro()
    return
end

local sMap = Client.GetMap()
if not tIntro[ sMap ] then
    return
end


--[[ transition from A to B, in a given time ]]--
local function moveFloat( fA, fB, iStartTime, iCurTime, iDurationMs )
    local iEndMs = ( iStartTime + iDurationMs )
    if ( iCurTime < iStartTime ) or ( iCurTime > iEndMs ) then
        return fB
    end

    return ( fA + ( ( fB - fA ) * math.abs( iStartTime - iCurTime ) / iDurationMs ) )
end

--[[ moveVector ]]--
local function moveVector( tStart, tEnd, iStartTime, iCurTime, iDuration )
    return Vector(
        moveFloat( tStart.X, tEnd.X, iStartTime, iCurTime, iDuration ),
        moveFloat( tStart.Y, tEnd.Y, iStartTime, iCurTime, iDuration ),
        moveFloat( tStart.Z, tEnd.Z, iStartTime, iCurTime, iDuration )
    )
end

--[[ moveRotator ]]--
local function moveRotator( tStart, tEnd, iStartTime, iCurTime, iDuration )
    return Rotator(
        moveFloat( tStart.Pitch, tEnd.Pitch, iStartTime, iCurTime, iDuration ),
        moveFloat( tStart.Yaw, tEnd.Yaw, iStartTime, iCurTime, iDuration ),
        moveFloat( tStart.Roll, tEnd.Roll, iStartTime, iCurTime, iDuration )
    )
end

--[[ translateCameraTo ]]--
local function translateCameraTo( tTargetPos, tTargetAng, iDuration, callback )
    local pPlayer = LocalPlayer()
    if not pPlayer or not pPlayer:IsValid() or LocalCharacter() then
        return
    end

    if lastTranslateTo then
        Client.Unsubscribe( "Tick", lastTranslateTo )
        lastTranslateTo = false
    end

    iDuration = ( iDuration or 5000 )

    local iStartTime = CurTime()
    local tStartPos = pPlayer:GetCameraLocation() or Vector()
    local tStartAng = pPlayer:GetCameraRotation() or Rotator()

    local tickFunc
    tickFunc = Client.Subscribe( "Tick", function( fDelta )
        local iCurTime = CurTime()

        pPlayer:SetCameraLocation( moveVector( tStartPos, tTargetPos, iStartTime, iCurTime, iDuration ) )
        pPlayer:SetCameraRotation( moveRotator( tStartAng, tTargetAng, iStartTime, iCurTime, iDuration ) )

        if pPlayer:GetCameraLocation():Equals( tTargetPos, 0.0001 ) then
            if callback then
                callback()
            end

            if tickFunc then
                Client.Unsubscribe( "Tick", tickFunc )
                tickFunc = false
            end
        end
    end )

    lastTranslateTo = tickFunc
end

--[[ setIntroStep ]]--
local function setIntroStep( iStep )
    local tStep = tIntro[ sMap ][ iStep ]
    if not tStep then
        if tIntro[ sMap ][ 1 ] then
            setIntroStep( 1 )
        end
        return
    end

    local pPlayer = LocalPlayer()
    pPlayer:ResetCamera()
    pPlayer:SetCameraLocation( tStep.start.pos )
    pPlayer:SetCameraRotation( tStep.start.ang )

    translateCameraTo( tStep.target.pos, tStep.target.ang, tStep.duration, function()
        if bIntroRunning then
            setIntroStep( iStep + 1 )
        end
    end )
end

--[[ startIntro ]]
local function startIntro()
    Client.SetInputEnabled( false )
    Client.SetMouseEnabled( true )

    setIntroStep( 1 )
    bIntroRunning = true
end

--[[ GM:OnRoundChange ]]--
Events.Subscribe( "GM:OnRoundChange", function( iOld, iNew )
    if ( iNew == RoundType.NotEnoughPlayers ) then
        startIntro()
    else
        stopIntro()
    end
end )