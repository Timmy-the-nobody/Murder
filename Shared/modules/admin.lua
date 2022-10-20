NW.AddNWString( "GM:Admin:ToggleAdminMode" )
NW.AddNWString( "GM:Admin:ChangeSubMode" )
NW.AddNWString( "GM:Admin:AddSpawn" )
NW.AddNWString( "GM:Admin:RemoveSpawn" )

GM.AdminSubModes = {
    [ 1 ] = {
        name = "Loot Spawn Placer",
        table = "LootSpawns",
        placeholderIDKey = "loot_spawn_id"
    },
    [ 2 ] = {
        name = "Character Spawn Placer",
        table = "CharacterSpawns",
        placeholderIDKey = "character_spawn_id"
    }
}

--[[ Player:IsAdminModeEnabled ]]--
function Player:IsAdminModeEnabled()
    return self:GetValue( "admin_mode_enabled", false )
end

--[[ Player:GetAdminSubMode ]]--
function Player:GetAdminSubMode()
    return self:GetValue( "admin_submode", 1 )
end