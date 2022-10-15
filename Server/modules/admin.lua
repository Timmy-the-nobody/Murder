local sCurMap = Server.GetMap()
local StaticMesh = StaticMesh

--------------------------------------------------------------------------------
-- Placeholders
--------------------------------------------------------------------------------
--[[ GM:DestroyPlaceholder ]]--
function GM:DestroyPlaceholder( iSubMode, iID )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] then
        return
    end

    local sKeyID = self.AdminSubModes[ iSubMode ].placeholderIDKey

    for _, v in ipairs( StaticMesh.GetAll() ) do
        local i = v:GetValue( sKeyID )
        if i and ( i == iID ) then
            v:Destroy()
        end
    end
end

--[[ GM:DestroyAllPlaceholders ]]--
function GM:DestroyAllPlaceholders( iSubMode )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] then
        return
    end

    local sKeyID = self.AdminSubModes[ iSubMode ].placeholderIDKey

    for _, v in ipairs( StaticMesh.GetAll() ) do
        if v:GetValue( sKeyID ) then
            v:Destroy()
        end
    end
end

--[[ GM:SpawnPlaceholder ]]--
function GM:SpawnPlaceholder( iSubMode, iID, tPos )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] then
        return
    end

    local sKeyID = self.AdminSubModes[ iSubMode ].placeholderIDKey

    local ePlaceholder = StaticMesh( tPos, Rotator(), "nanos-world::SM_Cube" )
    ePlaceholder:SetScale( Vector( 0.5 ) )
    ePlaceholder:SetGravityEnabled( false )
    ePlaceholder:SetCollision( CollisionType.IgnoreOnlyPawn )
    ePlaceholder:SetVisibility( false )
    ePlaceholder:SetValue( sKeyID, iID, true )
end

--[[ GM:SpawnAllPlaceholders ]]--
function GM:SpawnAllPlaceholders( iSubMode )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] then
        return
    end

    local sTable = self.AdminSubModes[ iSubMode ].table

    self:DestroyAllPlaceholders( iSubMode )

    for iID, tPos in ipairs( self[ sTable ][ sCurMap ] or {} ) do
        self:SpawnPlaceholder( iSubMode, iID, tPos )
    end
end

--------------------------------------------------------------------------------
-- Spawns
--------------------------------------------------------------------------------
--[[ GM:LoadAllSpawns ]]--
function GM:LoadAllSpawns( iSubMode )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] then
        return
    end

    local sTable = self.AdminSubModes[ iSubMode ].table

    self[ sTable ] = {}
    self[ sTable ][ sCurMap ] = {}

    local tConfig = Package.GetPersistentData()[ sTable ] or {}

    for sMap, tMapConfig in pairs( tConfig ) do
        if ( type( sMap ) ~= "string" ) or ( type( tMapConfig ) ~= "table" ) then
            goto continue
        end

        local sTrueMapName = string.sub( sMap, 2, #sMap - 1 )
        self[ sTable ][ sTrueMapName ] = self[ sTable ][ sTrueMapName ] or {}

        for _, v in ipairs( tMapConfig ) do
            if not v[ 1 ] or not v[ 2 ] or not v[ 3 ] then
                goto continue
            end

            self[ sTable ][ sTrueMapName ][ #self[ sTable ][ sTrueMapName ] + 1 ] = Vector(
                v[ 1 ],
                v[ 2 ],
                v[ 3 ]
            )

            ::continue::
        end

        ::continue::
    end
end

for k, _ in ipairs( GM.AdminSubModes ) do
    GM:LoadAllSpawns( k )
end

--[[ GM:SaveAllSpawns ]]--
function GM:SaveAllSpawns( iSubMode )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] then
        return
    end

    local sTable = self.AdminSubModes[ iSubMode ].table

    local tFormatted = {}
    for sMap, tSpawns in pairs( GM[ sTable ] ) do
        local sFormattedMapName = '"' .. sMap .. '"'
        tFormatted[ sFormattedMapName ] = {}

        for _, v in ipairs( tSpawns ) do
            tFormatted[ sFormattedMapName ][ #tFormatted[ sFormattedMapName ] + 1 ] = {
                v.X,
                v.Y,
                v.Z
            }
        end
    end

    Package.SetPersistentData( sTable, tFormatted )
end

--[[ GM:AddSpawn ]]--
function GM:AddSpawn( iSubMode, tPos )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] or ( getmetatable( tPos ) ~= Vector ) then
        return false
    end

    local sTable = self.AdminSubModes[ iSubMode ].table

    local iID = ( #self[ sTable ][ sCurMap ] + 1 )
    self[ sTable ][ sCurMap ][ iID ] = tPos

    self:SaveAllSpawns( iSubMode )
    self:SpawnPlaceholder( iSubMode, iID, tPos )

    return true
end

--[[ GM:RemoveSpawn ]]--
function GM:RemoveSpawn( iSubMode, iID )
    iSubMode = iSubMode or 1
    if not self.AdminSubModes[ iSubMode ] then
        return false
    end

    local sTable = self.AdminSubModes[ iSubMode ].table

    if not iID or not self[ sTable ][ sCurMap ] then
        return false
    end

    self[ sTable ][ sCurMap ][ iID ] = nil
    self[ sTable ][ sCurMap ] = table.ClearKeys( self[ sTable ][ sCurMap ] )

    self:SaveAllSpawns( iSubMode )
    self:DestroyPlaceholder( iSubMode, iID )

    return true
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
--[[ GM:Admin:AddSpawn ]]--
NW.Receive( "GM:Admin:AddSpawn", function( pPlayer, tPos )
    if pPlayer:IsInAdminMode() then
        local iSubMode = pPlayer:GetAdminSubMode()
        if GM:AddSpawn( iSubMode, tPos ) then
            pPlayer:Notify( NotificationType.Info, GM.AdminSubModes[ iSubMode ].name .. " added" )
        end
    end
end )

--[[ GM:Admin:RemoveSpawn ]]--
NW.Receive( "GM:Admin:RemoveSpawn", function( pPlayer, iID )
    if pPlayer:IsInAdminMode() then
        local iSubMode = pPlayer:GetAdminSubMode()
        if GM:RemoveSpawn( iSubMode, iID ) then
            pPlayer:Notify( NotificationType.Info, GM.AdminSubModes[ iSubMode ].name .. " removed" )
        end
    end
end )

--[[ GM:Admin:Toggle ]]--
NW.Receive( "GM:Admin:ToggleAdminMode", function( pPlayer )
    if GM.Cfg.AdminsSteamID[ pPlayer:GetSteamID() ] then
        local bEnabled = not pPlayer:IsInAdminMode()
        local iSubMode = pPlayer:GetAdminSubMode()

        pPlayer:SetPrivateValue( "admin_mode", bEnabled )

        if bEnabled then
            pPlayer:SetPrivateValue( "admin_submode", iSubMode )
            GM:SpawnAllPlaceholders( iSubMode )
        else
            GM:DestroyAllPlaceholders( iSubMode )
        end
    end
end )

--[[ GM:Admin:ChangeSubMode ]]--
NW.Receive( "GM:Admin:ChangeSubMode", function( pPlayer )
    if not pPlayer:IsInAdminMode() then
        return
    end

    local iOldMode = pPlayer:GetAdminSubMode()
    local iNewMode = GM.AdminSubModes[ iOldMode + 1 ] and ( iOldMode + 1 ) or 1

    GM:DestroyAllPlaceholders( iOldMode )

    pPlayer:SetPrivateValue( "admin_submode", iNewMode )
    GM:SpawnAllPlaceholders( iNewMode )
end )