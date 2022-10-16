if ( Server.GetMap() ~= "murder-underground::nw_underground" ) then
    return
end

local iDoorMaxZ = 305

local tDoors = {
    { ang = Rotator(0, -90, 0), pos = Vector(-3280.2336425781, 5782.9448242188, 43.621948242188),   scale = Vector(1) },
    { ang = Rotator(0, 180, 0), pos = Vector(-4214.0961914062, 6458.5048828125, 49.701641082764),   scale = Vector(1) },
    { ang = Rotator(0, -90, 0), pos = Vector(-3703.8740234375, 9215.994140625, 49.701641082764),    scale = Vector(1) },
    { ang = Rotator(0, -90, 0), pos = Vector(-5020.0991210938, 9215.994140625, 49.701641082764),    scale = Vector(1) },
    { ang = Rotator(0, -90, 0), pos = Vector(-5990.4819335938, 1441.4621582031, 49.701641082764),   scale = Vector(1) },
    { ang = Rotator(0, 0, 0),   pos = Vector(-604.14672851562, 5223.7490234375, 43.621948242188),   scale = Vector(1) },
    { ang = Rotator(0, -90, 0), pos = Vector(-3530.8669433594, 1441.4621582031, 49.701641082764),   scale = Vector(1) },
    { ang = Rotator(0, 0, 0),   pos = Vector(-604.14672851562, 4269.7197265625, 43.621948242188),   scale = Vector(1) },
    { ang = Rotator(0, 0, 0),   pos = Vector(-2804.6838378906, 3034.59765625, 39.907917022705),     scale = Vector(1) },
    { ang = Rotator(0, -90, 0), pos = Vector(254.20666503906, 5771.904296875, 43.621948242188),     scale = Vector(1) },
    { ang = Rotator(0, 0, 0),   pos = Vector(-602.66577148438, 2973.5112304688, 196.17231750488),   scale = Vector(1) },
    { ang = Rotator(0, 0, 0),   pos = Vector(2237.1208496094, 2473.5737304688, 182.86909484863),    scale = Vector(1) },
}

--[[ initDoors ]]--
local function initDoors()
    for _, v in ipairs( tDoors ) do
        local eDoor = StaticMesh( v.pos - Vector( 0, 0, iDoorMaxZ ), v.ang, "murder-underground::SM_Metal_Door_2" )
        eDoor:SetValue( "door_open", false, false )

        local tTriggerPos = eDoor:GetLocation() + ( v.ang:GetForwardVector() * 160 ) + Vector( 0, 0, 150 )
        local eTrigger = Trigger( tTriggerPos, Rotator(), Vector( 400 ), TriggerType.Sphere, false, Color( 1, 0, 0 ), { "Character" } )
        local tInSphere = {}

        eTrigger:Subscribe( "BeginOverlap", function( _, eChar )
            tInSphere[ eChar ] = true

            if not eDoor:GetValue( "door_open" ) then
                eDoor:SetValue( "door_open", true, false )
                eDoor:TranslateTo( v.pos, 0.25, 0 )
            end
        end )

        eTrigger:Subscribe( "EndOverlap", function( _, eChar )
            tInSphere[ eChar ] = nil

            if eDoor:GetValue( "door_open" ) and ( table.Count( tInSphere ) == 0 ) then
                eDoor:SetValue( "door_open", false, false )
                eDoor:TranslateTo( v.pos - Vector( 0, 0, iDoorMaxZ ), 0.25, 0 )
            end
        end )
    end
end

--[[ Package Load ]]--
-- initDoors()

-- Events.Subscribe( "GM:OnRoundChange", function( iOld, iNew )
--     if iNew == RoundType.Playing then
--         initDoors()
--     end
-- end )

-- Package.Subscribe( "Load", initDoors )