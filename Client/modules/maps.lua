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
