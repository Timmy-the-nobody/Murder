local tSpawnedLoot = {}

--[[ Character:SetCollectedLoot ]]--
function Character:SetCollectedLoot( iLoot )
    self:SetPrivateValue( "collected_loot", iLoot )
end

--[[ GM:SpawnLoot ]]--
function GM:SpawnLoot()
    local sMap = Server.GetMap()
    if not GM.Cfg.LootSpawns[ sMap ] then
        return
    end

    local iSpawnCount = table.Count( tSpawnedLoot )

    -- No more available loot spawns
    if ( iSpawnCount == #GM.Cfg.LootSpawns[ sMap ] ) then
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

    local tLoot, iLoot = table.Random( GM.Cfg.LootSpawns[ sMap ] )

    -- Already spawned, attempt another spawn
    if tSpawnedLoot[ iLoot ] then
        self:SpawnLoot()
        return
    end

    -- Spawn new loot
    local eLoot = Prop( tLoot[ 2 ], tLoot[ 3 ], tLoot[ 1 ], CollisionType.Normal )
    eLoot:SetGravityEnabled( false )
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

        local iCollectedLoot = eChar:GetCollectedLoot() + 1
        eChar:SetCollectedLoot( iCollectedLoot )

        if not eChar:IsMurderer() and ( ( iCollectedLoot % GM.Cfg.BonusRequiredCollectables ) == 0 ) then
            if eChar:GetStoredWeapon() then
                eChar:EquipWeapon()
            end

            eChar:Drop()
            eChar:SetWeapon( WeaponType.Pistol )
            eChar:EquipWeapon()
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