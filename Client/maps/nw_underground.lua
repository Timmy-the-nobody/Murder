if ( Client.GetMap() ~= "murder-underground::nw_underground" ) then
    return
end

--------------------------------------------------------------------------------
-- Doors
--------------------------------------------------------------------------------
local sDoorSM = "/Game/murder_underground/ResearchMegaPack/ResearchUnderground/Meshes/SM_Metal_Door_2.SM_Metal_Door_2"

--[[ destroyAllDoors ]]--
local function destroyAllDoors()
    for _, v in ipairs( StaticMesh.GetAll() ) do
        if v:IsFromLevel() and ( v:GetMesh() == sDoorSM ) then
            v:Destroy()
        end
    end
end

--[[
    dumpDoorsList
        desc: Debug function to get door pos, ang, scale
]]--
-- local function dumpDoorsList()
--     local tDoors = {}
--     for _, v in ipairs( StaticMesh.GetAll() ) do
--         if v:IsFromLevel() and ( v:GetMesh() == "/Game/murder_underground/ResearchMegaPack/ResearchUnderground/Meshes/SM_Metal_Door_2.SM_Metal_Door_2" ) then
--             tDoors[ #tDoors + 1 ] = {
--                 pos = v:GetLocation(),
--                 ang = v:GetRotation(),
--                 scale = v:GetScale()
--             }
--         end
--     end
--     print( NanosUtils.Dump( tDoors ) )
-- end

--[[ StaticMesh ValueChange ]]--
local tDoorSound = {
    open = "package://" .. Package.GetPath() .. "/Client/resources/sounds/nw_underground/door_open.ogg",
    close = "package://" .. Package.GetPath() .. "/Client/resources/sounds/nw_underground/door_close.ogg"
}

StaticMesh.Subscribe( "ValueChange", function( eSM, sKey, xValue )
    if ( sKey ~= "door_open" ) or not eSM or not eSM:IsValid() then
        return
    end

    local oSound = Sound(
        eSM:GetLocation(),
        tDoorSound[ xValue and "open" or "close" ],
        false,
        true,
        SoundType.SFX,
        0.16,
        math.random( 90, 110 ) * 0.01,
        50
    )

    oSound:AttachTo( eSM, AttachmentRule.SnapToTarget, "", -1, false )
    oSound:SetRelativeLocation( eSM:GetRotation():GetForwardVector() * 150 )
end )

--------------------------------------------------------------------------------
-- CCTV
--------------------------------------------------------------------------------
local tCCTVs = {
    {
        pos = Vector( -2255, 4560, -230 ),
        ang = Rotator( 0, -90, 0 ),
        scale = Vector( 2.09 ),
        sceneCapture = {
            pos = Vector( -656, -643, 180 ),
            ang = Rotator( -20, 53, 0 ),
            fov = 100
        }
    },
    {
        pos = Vector( -2255, 4300, -230 ),
        ang = Rotator( 0, -90, 0 ),
        scale = Vector( 2.09 ),
        sceneCapture = {
            pos = Vector( 1647, 9205, 0 ),
            ang = Rotator( -35, -100, 0 ),
            fov = 100
        }
    },
    {
        pos = Vector( -2255, 4040, -230 ),
        ang = Rotator( 0, -90, 0 ),
        scale = Vector( 2.09 ),
        sceneCapture = {
            pos = Vector( -8141, 8075, 50 ),
            ang = Rotator( -10, -138, 0 ),
            fov = 80
        }
    }
}

--[[ initCCTV ]]--
local function initCCTV()
    for _, v in ipairs( tCCTVs ) do
        local eCCTV = StaticMesh( v.pos, v.ang, "nanos-world::SM_TV_Hanging" )
        if v.scale then
            eCCTV:SetScale( v.scale )
        end

        if not v.sceneCapture then
            goto continue
        end

        local eSceneCapture = SceneCapture(
            v.sceneCapture.pos,
            v.sceneCapture.ang or Rotator(),
            512,
            512,
            0.25,
            5000,
            v.sceneCapture.fov or 90
        )

        eCCTV:SetMaterialFromSceneCapture( eSceneCapture, 1 )
        eCCTV:SetMaterialColorParameter( "Emissive", Color( 30, 30, 30 ) )

        ::continue::
    end
end

--[[ Package Load ]]--
local tRedLightPos = {
    Vector( 1143, 5606, 63 ),
    Vector( 2412, 3444, 63 ),
    Vector( -10215, 2777, 199 ),
    Vector( -439, 9049, -369 ),
    Vector( -8008, 9032, 152 )
}

Package.Subscribe( "Load", function()
    destroyAllDoors()
    initCCTV()

    for _, v in ipairs( tRedLightPos ) do
        Sound(
            v,
            "package://" .. Package.GetPath() .. "/Client/resources/sounds/nw_underground/emergency_light_engine_loop.ogg",
            false,
            false,
            SoundType.SFX,
            0.4,
            0.5,
            20,
            3600,
            AttenuationFunction.Linear,
            false,
            SoundLoopMode.Forever
        )
    end
end )

--------------------------------------------------------------------------------
-- Client Doors
--------------------------------------------------------------------------------
local tCSDoors = {}

StaticMesh.Subscribe( "ValueChange", function( eSM, sKey, xValue )
    if ( sKey ~= "door_id" ) or not eSM or not eSM:IsValid() then
        return
    end

    tCSDoors[ xValue ] = {
        serverMesh = eSM
    }

    local eCSDoor = StaticMesh( eSM:GetLocation(), eSM:GetRotation(), eSM:GetMesh(), CollisionType.NoCollision )
    eCSDoor:SetScale( eSM:GetScale() )

    tCSDoors[ xValue ].clientMesh = eCSDoor
end )

--[[ StaticMesh Destroy ]]--
StaticMesh.Subscribe( "Destroy", function( eSM )
    local iDoorID = eSM:GetValue( "door_id" )
    if not iDoorID or not tCSDoors[ iDoorID ] then
        return
    end

    if tCSDoors[ iDoorID ].clientMesh and tCSDoors[ iDoorID ].clientMesh:IsValid() then
        tCSDoors[ iDoorID ].clientMesh:Destroy()
        tCSDoors[ iDoorID ] = nil
    end
end )

Client.Subscribe( "Tick", function( fDelta )
    for _, v in ipairs( tCSDoors ) do
        if not v.serverMesh or not v.serverMesh:IsValid() then
            goto continue
        end

        if not v.clientMesh or not v.clientMesh:IsValid() then
            goto continue
        end

        local tCSPos = v.clientMesh:GetLocation()
        local tSVPos = v.serverMesh:GetLocation()

        if not tCSPos:Equals( tSVPos, 0.1 ) then
            v.clientMesh:SetLocation( NanosMath.VInterpTo( tCSPos, tSVPos, fDelta, 5 ) )
        end

        ::continue::
    end
end )