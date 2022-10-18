--------------------------------------------------------------------------------
-- Generic
--------------------------------------------------------------------------------
GM.Weapons = {
    [ WeaponType.Knife ] = {
        canPickup = function( eChar )
            return eChar:IsMurderer()
        end,
        onPickup = function( eChar, eObject )
            eObject:SetValue( "thrown_knife", false, true )
        end,
        onDrop = function( eChar, eObject )
            eObject:SetValue( "thrown_knife", true, true )
        end,
        spawn = function()
            local eKnife = Melee( Vector(), Rotator(), "nanos-world::SM_M9", CollisionType.Normal, true, HandlingMode.Throwable, "" )
            eKnife:AddAnimationCharacterUse( "nanos-world::AM_Mannequin_Melee_Stab_Attack" )
            eKnife:SetDamageSettings( 0.3, 0.5 )
            eKnife:SetCooldown( 1 )
            eKnife:SetBaseDamage( 100 )
            eKnife:SetValue( "weapon_type", WeaponType.Knife )
            eKnife:SetCrosshairMaterial( "nanos-world::MI_Crosshair_Crossbow" )
            return eKnife
        end
    },
    [ WeaponType.Pistol ] = {
        canPickup = function( eChar )
            if eChar:IsMurderer() or eChar:IsTeamKiller() then
                return false
            end
            return true
        end,
        spawn = function()
            local ePistol = NanosWorldWeapons.DesertEagle( Vector(), Rotator() )
            ePistol:SetAmmoSettings( 1, 99999, 1, 1 )
            ePistol:SetBulletColor( Color( 1, 1, 1 ) )
            ePistol:SetDamage( 100 )
            ePistol:SetValue( "weapon_type", WeaponType.Pistol )
            return ePistol
        end
    }
}

--------------------------------------------------------------------------------
-- Methods
--------------------------------------------------------------------------------
--[[
    Character:SetWeapon
        desc: Sets the character's holster weapon
        args:
            iWeapon: The weapon type from GM.Weapons
]]--
function Character:SetWeapon( iWeapon )
    self:SetPrivateValue( "stored_weapon", iWeapon )
end

--[[
    Character:EquipWeapon
        desc: Equips the holster weapon
]]--
function Character:EquipWeapon()
    if ( CurTime() - GM:GetRoundStart() ) < GM.Cfg.StartScreenTime then
        return false, "Wait a few seconds to equip your weapon"
    end

    local iWeaponType = self:GetStoredWeapon()
    if not iWeaponType or not GM.Weapons[ iWeaponType ] then
        return false, "You don't have any weapon"
    end

    self:SetWeapon( false )

    local eWeapon = GM.Weapons[ iWeaponType ].spawn()
    if GM.Weapons[ iWeaponType ].onDrop then
        eWeapon:Subscribe( "Drop", function( _, eChar )
            GM.Weapons[ iWeaponType ].onDrop( eChar, eWeapon )
        end )
    end

    self:PickUp( eWeapon )
    self:ComputeSpeed()

    return true
end

--[[
    Character:StoreWeapon
        desc: Store the current weapon in the character's holster
]]--
function Character:StoreWeapon()
    local ePicked = self:GetPicked()
    if not ePicked or not ePicked:IsValid() then
        return false, "You don't have any weapon"
    end

    local iWeaponType = ePicked:GetValue( "weapon_type" )
    if not iWeaponType then
        return false, "You don't have any weapon"
    end

    ePicked:Destroy()

    self:SetWeapon( iWeaponType )
    self:ComputeSpeed()

    return true
end

--[[
    Character:ThrowKnife
        desc: Throw the equiped knife in the direction the character is facing
]]--
function Character:ThrowKnife()
    if self:GetValue( "knife_throw_anim" ) then
        return false
    end

    local ePicked = self:GetPicked()
    if not ePicked or not ePicked:IsValid() then
        return false, "You're not carrying any knife"
    end

    local iWeaponType = ePicked:GetValue( "weapon_type" )
    if not iWeaponType or ( iWeaponType ~= WeaponType.Knife ) then
        return false, "You're not carrying any knife"
    end

    self:PlayAnimation( "nanos-world::A_Mannequin_Throw_01", AnimationSlotType.FullBody, false, 0.25, 0.25, 3, false )
    self:SetValue( "knife_throw_anim", true, false )

    local iThrowAnimTimer = Timer.SetTimeout( function()
        if not self:IsValid() or not ePicked:IsValid() then
            return
        end

        local iIntervals = 0
        local iTickRate = Server.GetTickRate()
        local iMaxIntervals = math.floor( 2500 / iTickRate )

        self:SetValue( "knife_throw_anim", nil, false )
        self:Drop()

        local tForward = self:GetControlRotation():GetForwardVector()

        ePicked:SetLocation( self:GetLocation() + ( tForward * 5 ) + Vector( 0, 0, 50 ) )
        ePicked:SetRotation( self:GetRotation() + Rotator( 90, 180, 0 ) )
        ePicked:AddImpulse( ( tForward * 2000 ) + Vector( 0, 0, 100 ), true )
        ePicked:SetValue( "thrown_knife", true, true )

        -- Damage trigger
        local eTrigger = Trigger( ePicked:GetLocation(), Rotator(), Vector( 100 ), TriggerType.Sphere, false, Color.BLACK, { "Character" } )
        eTrigger:Subscribe( "BeginOverlap", function( _, eEntity )
            if ( eEntity ~= self ) and ( eEntity:GetHealth() > 0 ) then
                eEntity:ApplyDamage( 100, "", DamageType.RunOverProp, Vector(), self:GetPlayer(), ePicked )
            end
        end )

        Timer.SetInterval( function()
            iIntervals = ( iIntervals + 1 )
            if not eTrigger:IsValid() or not ePicked:IsValid() or ePicked:GetHandler() or ( iIntervals == iMaxIntervals ) then
                eTrigger:Destroy()
                return false
            end
            eTrigger:SetLocation( ePicked:GetLocation())
        end, iTickRate )

        -- Giving knife back to the character if it has been picked up
        local iAutoGiveTimer = Timer.SetTimeout( function()
            if self:IsValid() and ePicked:IsValid() then
                ePicked:SetValue( "thrown_knife", nil, true )

                Timer.SetTimeout( function()
                    if self:IsValid() then
                        self:PickUp( ePicked )
                    end
                end, 100 )
            end
        end, GM.Cfg.KnifeAutoPickupDuration )

        Timer.Bind( iAutoGiveTimer, ePicked )

        ePicked:Subscribe( "PickUp", function( _, _ )
            if Timer.IsValid( iAutoGiveTimer ) then
                Timer.ClearTimeout( iAutoGiveTimer )
            end
        end )
    end, 500 )

    Timer.Bind( iThrowAnimTimer, self )

    return true
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
Character.Subscribe( "Interact", function( eChar, eObject )
    local iWeaponType = eObject:GetValue( "weapon_type" )
    if not iWeaponType or not GM.Weapons[ iWeaponType ] or not GM.Weapons[ iWeaponType ].canPickup then
        return true
    end

    local iStoredWeapon = eChar:GetStoredWeapon()
    if iStoredWeapon and ( iStoredWeapon == iWeaponType ) then
        return false
    end

    local ePicked = eChar:GetPicked()
    if ePicked and ePicked:IsValid() then
        local iPickedType = ePicked:GetValue( "weapon_type" )
        if iPickedType and ( iPickedType == iWeaponType ) then
            return false
        end
    end

    if GM.Weapons[ iWeaponType ].canPickup( eChar ) then
        eChar:StoreWeapon()

        if GM.Weapons[ iWeaponType ].onPickup then
            GM.Weapons[ iWeaponType ].onPickup( eChar, eObject )
        end
        return true
    end

    return false
end )

--------------------------------------------------------------------------------
-- NW events
--------------------------------------------------------------------------------
--[[ Toggle equip/unequip ]]--
NW.Receive( "GM:Weapon:Toggle", function( pPlayer )
    local eChar = pPlayer:GetControlledCharacter()
    if eChar and eChar:IsValid() then
        local ePicked = eChar:GetPicked()

        local bSuccess, sError = eChar[ ePicked and "StoreWeapon" or "EquipWeapon" ]( eChar )
        if bSuccess then
            if ePicked then
                pPlayer:Notify( NotificationType.Generic, "Weapon stored" )
            else
                pPlayer:Notify( NotificationType.Generic, "Weapon equipped" )
            end
        else
            pPlayer:Notify( NotificationType.Error, sError )
        end
    end
end )

--[[ ThrowKnife ]]--
NW.Receive( "GM:Weapon:ThrowKnife", function( pPlayer )
    local eChar = pPlayer:GetControlledCharacter()
    if eChar and eChar:IsValid() and eChar:IsMurderer() then
        local bSuccess, sError = eChar:ThrowKnife()
        if not bSuccess and sError then
            pPlayer:Notify( NotificationType.Error, sError )
        end
    end
end )