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
            local eKnife = Melee( Vector(), Rotator(), "nanos-world::SM_M9", CollisionType.Normal, true, HandlingMode.SingleHandedMelee, "" )
            eKnife:AddAnimationCharacterUse( "nanos-world::AM_Mannequin_Melee_Stab_Attack" )
            eKnife:SetDamageSettings( 0.3, 0.5 )
            eKnife:SetCooldown( 1 )
            eKnife:SetBaseDamage( 100 )
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
    local iWeaponType = self:GetStoredWeapon()
    if not iWeaponType or not GM.Weapons[ iWeaponType ] then
        return
    end

    self:SetWeapon( false )

    local eWeapon = GM.Weapons[ iWeaponType ].spawn()
    eWeapon:SetValue( "weapon_type", iWeaponType )

    if GM.Weapons[ iWeaponType ].onDrop then
        eWeapon:Subscribe( "Drop", function( _, eChar )
            GM.Weapons[ iWeaponType ].onDrop( eChar, eWeapon )
        end )
    end

    self:PickUp( eWeapon )
end

--[[
    Character:StoreWeapon
        desc: Store the current weapon in the character's holster
]]--
function Character:StoreWeapon()
    local ePicked = self:GetPicked()
    if not ePicked or not ePicked:IsValid() then
        return
    end

    local iWeaponType = ePicked:GetValue( "weapon_type" )
    if not iWeaponType then
        return
    end

    self:SetWeapon( iWeaponType )
    ePicked:Destroy()
end

--[[
    Character:ThrowKnife
        desc: Throw the equiped knife in the direction the character is facing
]]--
function Character:ThrowKnife()
    if self:GetValue( "dropping_knife" ) then
        return
    end

    local ePicked = self:GetPicked()
    if not ePicked or not ePicked:IsValid() then
        return
    end

    local iWeaponType = ePicked:GetValue( "weapon_type" )
    if not iWeaponType or ( iWeaponType ~= WeaponType.Knife ) then
        return
    end

    self:PlayAnimation( "nanos-world::A_Mannequin_Throw_01", AnimationSlotType.FullBody, false, 0.25, 0.25, 1.5, false )
    self:SetValue( "dropping_knife", true, false )

    Timer.SetTimeout( function()
        if not self:IsValid() then
            return
        end

        local iIntervals = 0
        local iMaxIntervals = math.floor( 2500 / Server.GetTickRate() )

        self:SetValue( "dropping_knife", nil, false )
        self:Drop()

        ePicked:AddImpulse( ( LocalPlayer():GetControlRotation():GetForwardVector() * 600 ) + Vector( 0, 0, 200 ), true )
        ePicked:SetValue( "thrown_knife", true, true )

        local eTrigger = Trigger( ePicked:GetLocation(), Rotator(), Vector( 50 ), TriggerType.Sphere, true, Color.RED, { "Character" } )
        eTrigger:Subscribe( "BeginOverlap", function( _, eEntity )
            if ( eEntity ~= self ) and ( eEntity:GetHealth() > 0 ) then
                eEntity:ApplyDamage( 100, "", DamageType.RunOverProp, Vector(), self:GetPlayer(), ePicked )
            end
        end )

        Timer.SetInterval( function()
            iIntervals = ( iIntervals + 1 )
            if not eTrigger:IsValid() then
                return false
            end

            if not ePicked:IsValid() or ( iIntervals == iMaxIntervals ) then
                eTrigger:Destroy()
                return false
            end

            if not ePicked:IsValid() or ePicked:GetHandler() then
                eTrigger:Destroy()
                return false
            end

            eTrigger:SetLocation( ePicked:GetLocation())
        end, Server.GetTickRate() )
    end, 1000 )
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
Character.Subscribe( "Interact", function( eChar, eObject )
    local iWeaponType = eObject:GetValue( "weapon_type" )
    if not iWeaponType or not GM.Weapons[ iWeaponType ] or not GM.Weapons[ iWeaponType ].canPickup then
        return true
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
        eChar[ eChar:GetPicked() and "StoreWeapon" or "EquipWeapon" ]( eChar )
    end
end )

--[[ ThrowKnife ]]--
NW.Receive( "GM:Weapon:ThrowKnife", function( pPlayer )
    local eChar = pPlayer:GetControlledCharacter()
    if eChar and eChar:IsValid() then
        eChar:ThrowKnife()
    end
end )