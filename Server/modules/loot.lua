local tSpawnedLoot = {}

--[[ Character:SetCollectedLoot ]]--
function Character:SetCollectedLoot( iLoot )
    self:SetPrivateValue( "collected_loot", iLoot )
end

--[[ GM:SpawnLoot ]]--
function GM:SpawnLoot()
    if ( #GM.Cfg.Loot == 0 ) then
        return
    end

    local sMap = Server.GetMap()
    if not GM.LootSpawns[ sMap ] then
        return
    end

    local iSpawnCount = table.Count( tSpawnedLoot )

    -- No more available loot spawns
    if ( iSpawnCount == #GM.LootSpawns[ sMap ] ) then
        return
    end

    local iAlive = 0
    for _, v in ipairs( Character.GetAll() ) do
        if ( v:GetHealth() > 0 ) then
            iAlive = ( iAlive + 1 )
        end
    end

    -- Limit reached
    if ( iSpawnCount >= ( GM.Cfg.MaxLootPerPlayer * iAlive ) ) then
        return
    end

    local tLootPos, iLoot = table.Random( GM.LootSpawns[ sMap ] )

    -- Spawn point already use, searching another spawn
    if tSpawnedLoot[ iLoot ] then
        self:SpawnLoot()
        return
    end

    -- Spawn new loot
    local tRandomLoot, iLootID = table.Random( GM.Cfg.Loot )
    local tOffset = Vector( 0, 0, -25 )
    if tRandomLoot.offset then
        tOffset = tOffset + tRandomLoot.offset
    end

    local eLoot = Prop(
        tLootPos + tOffset,
        Rotator( 0, math.random( -180, 180 ), 0 ),
        tRandomLoot.mesh,
        CollisionType.Normal
    )

    eLoot:SetGravityEnabled( false )
    eLoot:SetValue( "loot_id", iLootID, true )

    eLoot:Subscribe( "Destroy", function()
        for k, v in pairs( tSpawnedLoot ) do
            if ( v == eLoot ) then
                tSpawnedLoot[ k ] = nil
                break
            end
        end
    end )

    eLoot:Subscribe( "Interact", function( _, eChar )
        eLoot:Destroy()

        local pPlayer = eChar:GetPlayer()

        local iCollectedLoot = eChar:GetCollectedLoot() + ( GM.Cfg.Loot[ iLootID ].points or 1 )
        eChar:SetCollectedLoot( iCollectedLoot )

        pPlayer:Notify( NotificationType.Generic, "You collected some loot" )

        if not eChar:IsMurderer() and ( ( iCollectedLoot % GM.Cfg.BonusRequiredCollectables ) == 0 ) then
            if eChar:GetStoredWeapon() then
                eChar:EquipWeapon()
            end

            eChar:Drop()
            eChar:SetWeapon( WeaponType.Pistol )
            eChar:EquipWeapon()

            pPlayer:Notify( NotificationType.Info, "You collected enough loot and got a bonus weapon!" )
        end
    end )

    tSpawnedLoot[ iLoot ] = eLoot
end

--[[ GM:LootTick ]]--
local iNextLootSpawn = 0

function GM:LootTick()
    if ( CurTime() > iNextLootSpawn ) then
        iNextLootSpawn = CurTime() + GM.Cfg.LootSpawnTime
        self:SpawnLoot()
    end
end