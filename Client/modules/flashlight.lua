Input.Register( "Flashlight", "H" )
Input.Bind( "Flashlight", InputEvent.Pressed, function()
    NW.Send( "GM:Flashlight:Toggle" )
end )

--[[ Character ValueChange ]]--
local sToggleSound = "package://" .. Package.GetPath() .. "/Client/resources/sounds/flashlight_toggle.ogg"

Character.Subscribe( "ValueChange", function( eChar, sKey, _ )
    if ( sKey == "flashlight_enabled" ) then
        Sound( eChar:GetLocation(), sToggleSound, false, true, SoundType.SFX, 0.3, 1, 60 )
    end
end )