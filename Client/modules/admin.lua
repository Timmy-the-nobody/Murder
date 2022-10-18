local adminTick = false
local ePlaceholder = false
local eSelectedEnt = false
local sIDKey = GM.AdminSubModes[ 1 ].placeholderIDKey

local iCollision = CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Mesh
local traceLine = Client.TraceLineSingle

--[[ getEyeTrace ]]--
local function getEyeTrace( tFilter )
    local pPlayer = LocalPlayer()
    local tPos = pPlayer:GetCameraLocation()
    local tForward = pPlayer:GetCameraRotation():GetForwardVector()

    return traceLine(
        tPos + ( tForward * 50 ),
        tPos + ( tForward * 10000 ),
        iCollision,
        TraceMode.ReturnEntity,
        tFilter or {}
    )
end

--[[ disableAdminMode ]]--
local function disableAdminMode()
    if adminTick then
        Client.Unsubscribe( "Tick", adminTick )
        adminTick = false
    end

    if ePlaceholder then
        if ePlaceholder:IsValid() then
            ePlaceholder:Destroy()
        end
        ePlaceholder = false
    end

    eSelectedEnt = false
end

--[[ enableAdminMode ]]--
local function enableAdminMode()
    if adminTick or ePlaceholder or eSelectedEnt then
        disableAdminMode()
    end

    ePlaceholder = StaticMesh( Vector(), Rotator(), "nanos-world::SM_Cube" )
    ePlaceholder:SetScale( Vector( 0.5 ) )
    ePlaceholder:SetCollision( CollisionType.NoCollision )
    ePlaceholder:SetHighlightEnabled( true, 0 )
    ePlaceholder:SetMaterial( "nanos-world::M_NanosWireframe" )
    ePlaceholder:SetMaterialColorParameter( "Tint", Color.WHITE )
    ePlaceholder:SetMaterialColorParameter( "Emissive", Color.WHITE )
    local tBoxEx = ePlaceholder:GetBounds().BoxExtent

    -- Tick event
    local tFilter = { ePlaceholder }

    if LocalCharacter() then
        tFilter[ #tFilter + 1 ] = LocalCharacter()
    end

    adminTick = Client.Subscribe( "Tick", function( _ )
        local tTrace = getEyeTrace( tFilter )
        if not tTrace.Success then
            return
        end

        if tTrace.Entity and tTrace.Entity:IsValid() and tTrace.Entity:GetValue( sIDKey ) then
            if not eSelectedEnt then
                ePlaceholder:SetVisibility( false )

                eSelectedEnt = tTrace.Entity
                eSelectedEnt:SetMaterial( "nanos-world::M_NanosWireframe" )
                eSelectedEnt:SetMaterialColorParameter( "Emissive", Color( 200, 0, 0 ) )
            end
        else
            if eSelectedEnt then
                if eSelectedEnt:IsValid() then
                    eSelectedEnt:SetMaterial( "" )
                    ePlaceholder:SetVisibility( true )
                end

                ePlaceholder:SetVisibility( true )
                eSelectedEnt = false
            end
        end

        ePlaceholder:SetLocation( tTrace.Location + ( tTrace.Normal * tBoxEx ) )
    end )
end

--[[ Player ValueChange ]]--
Player.Subscribe( "ValueChange", function( pPlayer, sKey, xValue )
    if ( pPlayer == LocalPlayer() ) then
        if ( sKey == "admin_mode" ) then
            if xValue then
                enableAdminMode()
            else
                disableAdminMode()
            end
            return
        end
        if ( sKey == "admin_submode" ) then
            sIDKey = GM.AdminSubModes[ xValue ].placeholderIDKey
        end
    end
end )

StaticMesh.Subscribe( "ValueChange", function( eSM, sKey, xValue )
    if not LocalPlayer():IsInAdminMode() then
        return
    end

    if ( sKey == sIDKey ) then
        eSM:SetVisibility( true )
        eSM:SetHighlightEnabled( true, 0 )
    end
end )

--[[ LeftClick ]]--
Input.Bind( "LeftClick", InputEvent.Pressed, function()
    if not LocalPlayer():IsInAdminMode() then
        return
    end

    if eSelectedEnt and eSelectedEnt:IsValid() then
        NW.Send( "GM:Admin:RemoveSpawn", eSelectedEnt:GetValue( sIDKey ) )
        return
    end

    if ePlaceholder and ePlaceholder:IsValid() then
        NW.Send( "GM:Admin:AddSpawn", ePlaceholder:GetLocation() )
    end
end )

--[[ Admin Mode toggle ]]--
Input.Register( "Admin Mode", "F1" )
Input.Bind( "Admin Mode", InputEvent.Pressed, function()
    NW.Send( "GM:Admin:ToggleAdminMode" )
end )

--[[ Admin Submode ]]--
Input.Bind( "Reload", InputEvent.Pressed, function()
    if LocalPlayer():IsInAdminMode() then
        NW.Send( "GM:Admin:ChangeSubMode" )
    end
end )