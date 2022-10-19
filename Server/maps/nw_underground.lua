if ( Server.GetMap() ~= "murder-underground::nw_underground" ) then
    return
end

--------------------------------------------------------------------------------
-- Doors
--------------------------------------------------------------------------------
local iDoorAnimDuration = 3

local iDoorMaxZ = 305
local tDoors = {
    { pos = Vector(-3280.2336425781, 5782.9448242188, 43.621948242188), ang = Rotator(0, -90, 0), scale = Vector(1) },
    { pos = Vector(-4214.0961914062, 6458.5048828125, 49.701641082764), ang = Rotator(0, 180, 0), scale = Vector(1) },
    { pos = Vector(-3703.8740234375, 9215.994140625, 49.701641082764),  ang = Rotator(0, -90, 0), scale = Vector(1) },
    { pos = Vector(-5020.0991210938, 9215.994140625, 49.701641082764),  ang = Rotator(0, -90, 0), scale = Vector(1) },
    { pos = Vector(-5990.4819335938, 1441.4621582031, 49.701641082764), ang = Rotator(0, -90, 0), scale = Vector(1) },
    { pos = Vector(-604.14672851562, 5223.7490234375, 43.621948242188), ang = Rotator(0, 0, 0),   scale = Vector(1) },
    { pos = Vector(-3530.8669433594, 1441.4621582031, 49.701641082764), ang = Rotator(0, -90, 0), scale = Vector(1) },
    { pos = Vector(-604.14672851562, 4269.7197265625, 43.621948242188), ang = Rotator(0, 0, 0),   scale = Vector(1) },
    { pos = Vector(-2804.6838378906, 3034.59765625, 39.907917022705),   ang = Rotator(0, 0, 0),   scale = Vector(1) },
    { pos = Vector(254.20666503906, 5771.904296875, 43.621948242188),   ang = Rotator(0, -90, 0), scale = Vector(1) },
    { pos = Vector(-602.66577148438, 2973.5112304688, 196.17231750488), ang = Rotator(0, 0, 0),   scale = Vector(1) },
    { pos = Vector(2237.1208496094, 2473.5737304688, 182.86909484863),  ang = Rotator(0, 0, 0),   scale = Vector(1) },
}

local closeDoor
local iStepsPerTick = ( iDoorMaxZ / ( Server.GetTickRate() * iDoorAnimDuration ) )

--[[ openDoor ]]--
local function openDoor( eDoor )
    if eDoor:GetValue( "door_open" ) or eDoor:GetValue( "door_anim" ) then
        return
    end

    eDoor:SetValue( "door_open", true, true )
    eDoor:SetValue( "door_anim", true, false )

    local tEndPos = tDoors[ eDoor:GetValue( "door_id" ) ].pos
    local doorTick

    doorTick = Server.Subscribe( "Tick", function( fDelta )
        if not eDoor:IsValid() then
            Server.Unsubscribe( "Tick", doorTick )
            return
        end

        local tNewPos = eDoor:GetLocation() + Vector( 0, 0, iStepsPerTick )
        eDoor:SetLocation( tNewPos )

        if ( tNewPos.Z >= tEndPos.Z ) then
            Server.Unsubscribe( "Tick", doorTick )

            eDoor:SetLocation( tEndPos )
            eDoor:SetValue( "door_anim", nil, false )

            if ( table.Count( eDoor:GetValue( "characters_in_sphere", {} ) ) == 0 ) then
                closeDoor( eDoor )
                return
            end
        end
    end )
end

--[[ closeDoor ]]--
closeDoor = function( eDoor )
    if not eDoor:GetValue( "door_open" ) or eDoor:GetValue( "door_anim" ) then
        return
    end

    local tInSphere = eDoor:GetValue( "characters_in_sphere", {} )
    if ( table.Count( tInSphere ) > 0 ) then
        return
    end

    eDoor:SetValue( "door_open", false, true )
    eDoor:SetValue( "door_anim", true, false )

    local tEndPos = tDoors[ eDoor:GetValue( "door_id" ) ].pos - Vector( 0, 0, iDoorMaxZ )
    local doorTick

    doorTick = Server.Subscribe( "Tick", function( fDelta )
        if not eDoor:IsValid() then
            Server.Unsubscribe( "Tick", doorTick )
            return
        end

        local tNewPos = eDoor:GetLocation() - Vector( 0, 0, iStepsPerTick )
        eDoor:SetLocation( tNewPos )

        if ( tNewPos.Z <= tEndPos.Z ) then
            Server.Unsubscribe( "Tick", doorTick )

            eDoor:SetLocation( tEndPos )
            eDoor:SetValue( "door_anim", nil, false )

            if ( table.Count( eDoor:GetValue( "characters_in_sphere", {} ) ) > 0 ) then
                openDoor( eDoor )
                return
            end
        end
    end )
end

--[[ initDoors ]]--
local function initDoors()
    for iDoorID, tDoor in ipairs( tDoors ) do
        local eDoor = StaticMesh(
            tDoor.pos - Vector( 0, 0, iDoorMaxZ ),
            tDoor.ang,
            "murder-underground::SM_Metal_Door_2"
        )

        if tDoor.scale then
            eDoor:SetScale( tDoor.scale )
        end

        eDoor:SetValue( "door_id", iDoorID, false )
        eDoor:SetValue( "door_open", false, false )

        local eTrigger = Trigger(
            eDoor:GetLocation() + ( tDoor.ang:GetForwardVector() * 160 ) + Vector( 0, 0, 150 ),
            Rotator(),
            Vector( 400 ),
            TriggerType.Sphere,
            false,
            Color( 1, 0, 0 ),
            { "Character" }
        )

        eTrigger:Subscribe( "BeginOverlap", function( _, eChar )
            if not eDoor:IsValid() then
                return
            end

            local tInSphere = eDoor:GetValue( "characters_in_sphere", {} )
            tInSphere[ eChar ] = true
            eDoor:SetValue( "characters_in_sphere", tInSphere, false )

            openDoor( eDoor )
        end )

        eTrigger:Subscribe( "EndOverlap", function( _, eChar )
            if not eDoor:IsValid() then
                return
            end

            local tInSphere = eDoor:GetValue( "characters_in_sphere", {} )
            tInSphere[ eChar ] = nil
            eDoor:SetValue( "characters_in_sphere", tInSphere, false )

            closeDoor( eDoor )
        end )
    end
end

--[[ GM:OnMapCleared ]]--
Events.Subscribe( "GM:OnMapCleared", initDoors )

--[[ Package Load ]]--
Package.Subscribe( "Load", initDoors )