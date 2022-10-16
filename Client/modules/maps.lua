--------------------------------------------------------------------------------
-- Doors
--------------------------------------------------------------------------------
local tMaps = {
    [ "murder-underground::nw_underground" ] = {
        load = function()
            for _, v in ipairs( StaticMesh.GetAll() ) do
                if v:IsFromLevel() and ( v:GetMesh() == "/Game/murder_underground/ResearchMegaPack/ResearchUnderground/Meshes/SM_Metal_Door_2.SM_Metal_Door_2" ) then
                    v:Destroy()
                end
            end
        end,
        listDoors = function()
            local tDoors = {}
            for _, v in ipairs( StaticMesh.GetAll() ) do
                if v:IsFromLevel() and ( v:GetMesh() == "/Game/murder_underground/ResearchMegaPack/ResearchUnderground/Meshes/SM_Metal_Door_2.SM_Metal_Door_2" ) then
                    tDoors[ #tDoors + 1 ] = {
                        pos = v:GetLocation(),
                        ang = v:GetRotation(),
                        scale = v:GetScale()
                    }
                end
            end
            print( NanosUtils.Dump( tDoors ) )
        end
    }
}

--[[ Package Load ]]--
Package.Subscribe( "Load", function()
    local sMap = Client.GetMap()
    if not tMaps[ sMap ] then
        return
    end

    -- if tMaps[ sMap ].listDoors then
    --     tMaps[ sMap ].listDoors()
    -- end

    if tMaps[ sMap ].load then
        tMaps[ sMap ].load()
    end
end )

--[[ StaticMesh ValueChange ]]--
StaticMesh.Subscribe( "ValueChange", function( eSM, sKey, xValue )
    if ( sKey ~= "door_open" ) or not eSM or not eSM:IsValid() then
        return
    end

    local sToggleSound = "package://" .. Package.GetPath() .. "/Client/resources/sounds/door_open_close.ogg"
    Sound( eSM:GetLocation(), sToggleSound, false, true, SoundType.SFX, 0.2, 1, 80 )
end )

--------------------------------------------------------------------------------
-- CCTV
--------------------------------------------------------------------------------
if ( Client.GetMap() ~= "murder-underground::nw_underground" ) then
    return
end

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
Package.Subscribe( "Load", initCCTV )