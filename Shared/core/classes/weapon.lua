SWEPManager = {}
_SetupMetaTable( SWEPManager, nil, true )

local _tSeqInstances = {}
local _tHashInstances = {}

--------------------------------------------------------------------------------
-- SWEPManager
--------------------------------------------------------------------------------
--[[ SWEPManager.GetAll ]]--
function SWEPManager.GetAll()
    return _tSeqInstances
end

--[[ SWEPManager.GetByID ]]--
function SWEPManager.GetByID( iID )
    return _tSeqInstances[ iID ]
end

--[[ SWEPManager.GetByClass ]]--
function SWEPManager.GetByClass( sClass )
    return SWEPManager.GetByID( _tHashInstances[ sClass ] )
end

-- --[[ SWEPManager.Find ]]--
-- function SWEPManager.Find( xSWEPManager )
--     if IsNumber( xSWEPManager ) then
--         return SWEPManager.GetByID( xSWEPManager )
--     end

--     if IsString( xSWEPManager ) then
--         return SWEPManager.GetByClass( xSWEPManager )
--     end

--     if IsTable( xSWEPManager ) then
--         if ( getmetatable( xSWEPManager ) == SWEPManager ) then
--             return xSWEPManager
--         end

--         if xSWEPManager.GetValue then
--             local sClass = xSWEPManager:GetValue( "weapon_manager" )
--             if sClass then
--                 return SWEPManager.GetByClass( sClass )
--             end
--         end
--     end
-- end

--[[ SWEPManager constructor ]]--
function SWEPManager.new( sClass )
    local oExisting = SWEPManager.GetByClass( sClass )
    if oExisting then
        return oExisting
    end

    local self = setmetatable( {}, SWEPManager )
    self.id = ( #_tSeqInstances + 1 )
    self.class = sClass
    self.name = sClass

    _tSeqInstances[ self.id ] = self
    _tHashInstances[ self.class ] = self.id

    return self
end

--------------------------------------------------------------------------------
-- SWEPManager meta methods
--------------------------------------------------------------------------------
--[[ SWEPManager:GetID ]]--
function SWEPManager:GetID()
    return self.id
end

--[[ SWEPManager:[Set/Get]Name ]]--
function SWEPManager:SetName( sName )
    self.name = sName
end

function SWEPManager:GetName()
    return self.name
end

--[[ SWEPManager:GetClass ]]--
function SWEPManager:GetClass()
    return self.class
end

function SWEPManager:CanPickup( eChar )
end

function SWEPManager:OnPickup( eChar )
end

function SWEPManager:OnDrop( eChar )
end

function SWEPManager:Initialize()
end

function SWEPManager:_Initialize( eWeapon )
    self.weapon = eWeapon
    eWeapon:SetValue( "weapon_manager", self:GetClass() )
end

function SWEPManager:Spawn()
end