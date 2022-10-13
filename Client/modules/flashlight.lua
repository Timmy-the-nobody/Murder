Input.Register( "Flashlight", "H" )
Input.Bind( "Flashlight", InputEvent.Pressed, function()
    NW.Send( "GM:Flashlight:Toggle" )
end )