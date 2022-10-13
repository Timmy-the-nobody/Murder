NW.AddNWString( "GM:Flashlight:Toggle" )

--[[ Character:GetFlashlightBattery ]]--
function Character:GetFlashlightBattery()
    return self:GetValue( "flashlight_battery", 0 )
end

--[[ Character:IsFlashlightEnabled ]]--
function Character:IsFlashlightEnabled()
    return self:GetValue( "flashlight_enabled", false )
end