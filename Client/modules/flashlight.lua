--[[ Flashlight Input ]]--
Input.Register( "Flashlight", "F" )
Input.Bind( "Flashlight", InputEvent.Pressed, function()
    NW.Send( "GM:Flashlight:Toggle" )
end )

--[[ Character ValueChange ]]--
local sToggleSound = "package://" .. Package.GetPath() .. "/Client/resources/sounds/flashlight_toggle.ogg"

Character.Subscribe( "ValueChange", function( eChar, sKey, xValue )
    if ( sKey ~= "flashlight_enabled" ) or not eChar or not eChar:IsValid() then
        return
    end

    Sound(
        eChar:GetLocation(),
        sToggleSound,
        false,
        true,
        SoundType.SFX,
        0.3,
        ( xValue and 1.2 or 1 ),
        50
    )
end )