LootManager = {}
_SetupMetaTable( LootManager, nil, true )

local _tSeqInstances = {}

--------------------------------------------------------------------------------
-- LootManager
--------------------------------------------------------------------------------
--[[ LootManager.GetAll ]]--
function LootManager.GetAll()
    return _tSeqInstances
end

--[[ LootManager.GetByID ]]--
function LootManager.GetByID( iID )
    return _tSeqInstances[ iID ]
end

--[[ LootManager constructor ]]--
function LootManager.new()
    local self = setmetatable( {}, LootManager )
    self.id = ( #_tSeqInstances + 1 )
    self.name = "Loot"
    self.mesh = "nanos-world::SM_Cube"
    self.lootPoints = 1
    self.scale = Vector( 1, 1, 1 )
    self.offset = Vector( 0, 0, 0 )

    _tSeqInstances[ self.id ] = self
    return self
end

--------------------------------------------------------------------------------
-- LootManager meta methods
--------------------------------------------------------------------------------
--[[ LootManager:__tostring ]]--
function LootManager:__tostring()
    return "LootManager " .. self.id .. " [" .. self.name .. "]"
end

--[[ LootManager:__eq ]]--
function LootManager:__eq( oOther )
    return ( self.id == oOther.id )
end

--[[ LootManager:GetID ]]--
function LootManager:GetID()
    return self.id
end

--[[ LootManager:[Get/Set]Name ]]--
function LootManager:GetName()
    return self.name
end

function LootManager:SetName( sName )
    self.name = sName
end

--[[ LootManager:[Get/Set]Mesh ]]--
function LootManager:GetMesh()
    return self.mesh
end

function LootManager:SetMesh( sMesh )
    self.mesh = sMesh
end

--[[ LootManager:[Get/Set]LootPoints ]]--
function LootManager:GetLootPoints()
    return self.lootPoints
end

function LootManager:SetLootPoints( iValue )
    self.lootPoints = ( type( iValue ) == "number" ) and iValue or 1
end

--[[ LootManager:[Get/Set]Scale ]]--
function LootManager:GetScale()
    return self.scale
end

function LootManager:SetScale( tScale )
    self.scale = ( getmetatable( tScale ) == Vector ) and tScale or Vector()
end

--[[ LootManager:[Get/Set]Offset ]]--
function LootManager:GetOffset()
    return self.offset
end

function LootManager:SetOffset( tOffset )
    self.offset = ( getmetatable( tOffset ) == Vector ) and tOffset or Vector()
end