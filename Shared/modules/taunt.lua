NW.AddNWString( "GM:Taunt:Request" )
NW.AddNWString( "GM:Taunt:Play" )

GM.Taunts = {}
for _, sPath in ipairs( Package.GetFiles( "Client/resources/sounds/taunts", ".ogg" ) ) do
    GM.Taunts[ #GM.Taunts + 1 ] = "package://" .. Package.GetPath() .. "/" .. sPath
end