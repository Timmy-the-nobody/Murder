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

--[[ Player:IsInAdminMode ]]--
function Player:IsInAdminMode()
    return self:GetValue( "admin_mode", false )
end

--[[ Player:GetAdminSubMode ]]--
function Player:GetAdminSubMode()
    return self:GetValue( "admin_submode", 1 )
end