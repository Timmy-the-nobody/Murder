local tSpawnedLoot = {}
local sMap = Server.GetMap()

--[[ Character:SetCollectedLoot ]]--
function Character:SetCollectedLoot( iLootCount )
    self:SetValue( "collected_loot", iLootCount, true )
end

--[[ GM:SpawnLoot ]]--
function GM:SpawnLoot()
    local tLootManagers = LootManager.GetAll()
    if ( #tLootManagers == 0 ) or not GM.LootSpawns[ sMap ] then
        return
    end

    local iSpawnCount = table.Count( tSpawnedLoot )
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

    local tLootPos, iLootPos = table.Random( GM.LootSpawns[ sMap ] )

    -- Spawn point already use, searching another spawn
    if tSpawnedLoot[ iLootPos ] then
        self:SpawnLoot()
        return
    end

    -- Spawn new loot
    local oRandomLoot, iLootID = table.Random( tLootManagers )

    local eLoot = Prop(
        tLootPos + Vector( 0, 0, -25 ) + oRandomLoot:GetOffset(),
        Rotator( 0, math.random( -180, 180 ), 0 ),
        oRandomLoot:GetMesh(),
        CollisionType.Normal
    )

    eLoot:SetScale( oRandomLoot:GetScale() )
    eLoot:SetGravityEnabled( false )
    eLoot:SetCollision( CollisionType.IgnoreOnlyPawn )
    eLoot:SetValue( "loot_manager_id", iLootID, true )

    eLoot:Subscribe( "Destroy", function()
        for k, v in pairs( tSpawnedLoot ) do
            if ( v == eLoot ) then
                tSpawnedLoot[ k ] = nil
                break
            end
        end
    end )

    eLoot:Subscribe( "Interact", function( _, eChar )
        local tPickupPos = eLoot:GetLocation()
        eLoot:Destroy()

        local pPlayer = eChar:GetPlayer()
        if not pPlayer or not pPlayer:IsValid() then
            return
        end

        local iCollectedLoot = eChar:GetCollectedLoot() + oRandomLoot:GetLootPoints()
        eChar:SetCollectedLoot( iCollectedLoot )

        if eChar:IsMurderer() then
            eChar:SetValue( "total_loot", eChar:GetValue( "total_loot", 0 ) + 1, true )
        end

        pPlayer:Notify( NotificationType.Info, oRandomLoot:GetName() .. " collected" )
        NW.Broadcast( "GM:Loot:PickupSound", tPickupPos )

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

    tSpawnedLoot[ iLootPos ] = eLoot
end

--[[ GM:LootTick ]]--
local iNextLootSpawn = 0

function GM:LootTick()
    if ( CurTime() > iNextLootSpawn ) then
        iNextLootSpawn = CurTime() + GM.Cfg.LootSpawnTime
        self:SpawnLoot()
    end
end