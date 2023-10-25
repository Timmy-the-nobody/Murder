-- -- TODO: Remove when it's added natively
-- Input.__KeyIcons[ "MiddleMouseButton" ] = "Mouse_Middle_Key"
-- -- TODO end

--------------------------------------------------------------------------------
-- Weapon Inputs
--------------------------------------------------------------------------------
Input.Register( "Equip/Unequip Weapon", "MiddleMouseButton" )
Input.Bind( "Equip/Unequip Weapon", InputEvent.Pressed, function()
    NW.Send( "GM:Weapon:Toggle" )
end )

Input.Register( "Throw Knife", "LeftAlt" )
Input.Bind( "Throw Knife", InputEvent.Pressed, function()
    NW.Send( "GM:Weapon:ThrowKnife" )
end )

--------------------------------------------------------------------------------
-- Knife highlight
--------------------------------------------------------------------------------
Client.SetHighlightColor( GM.Cfg.KnifeHighlightColor, 0, HighlightMode.Always )

--[[ Melee ValueChange ]]--
local sKnifeThrowSound = "package://" .. Package.GetName() .. "/Client/resources/sounds/knife_throw.ogg"

Melee.Subscribe( "ValueChange", function( eMelee, sKey, xValue )
    if eMelee:IsValid() and ( sKey == "thrown_knife" ) then
        eMelee:SetHighlightEnabled( tobool( xValue ), 0 )

        if xValue then
            Sound( eMelee:GetLocation(), sKnifeThrowSound, false, true, SoundType.SFX, 0.35, 1, 50 )

            local iStart = CurTime()
            local iDuration = 2500

            local knifeParticleTick
            knifeParticleTick = Client.Subscribe( "Tick", function()
                local iCurTime = CurTime()

                if not eMelee:IsValid() or not eMelee:GetValue( "thrown_knife" ) or ( iCurTime > ( iStart + iDuration ) ) then
                    Client.Unsubscribe( "Tick", knifeParticleTick )
                    return
                end

                local fScale = ( 1 - ( ( iCurTime - iStart ) / iDuration ) )
                Particle(
                    eMelee:GetLocation(),
                    Rotator( 1440 * fScale ),
                    "nanos-world::P_Smoke_06",
                    true,
                    true
                ):SetScale( Vector( 0.25 * fScale ) + 0.05 )
            end )
        end
    end
end )

--[[ Character Highlight ]]--
Character.Subscribe( "Highlight", function( _, _, eObject )
    if eObject and eObject:IsValid() then
        local bThrownKnife = eObject:GetValue( "thrown_knife" )
        if bThrownKnife then
            eObject:SetHighlightEnabled( true, 0 )
        end
    end
end )