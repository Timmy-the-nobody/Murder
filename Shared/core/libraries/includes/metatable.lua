local setmetatable = setmetatable

--[[ parentsLookup ]]--
local function parentsLookup( xKey, tParents )
    for i = 1, #tParents do
        if tParents[ i ][ xKey ] then
            return tParents[ i ][ xKey ]
        end
    end
end

--[[
    _SetupMetaTable
        desc: Sets up the inheritance chain for a class.
        args:
            oClass (table) - The class to set up the inheritance chain for.
            tParentClasses (table) - A table of parent classes.
            bCallObjectConstructor (bool) - Calls the constructor function (o.new) when calling the object as a function.
]]--
function _SetupMetaTable( oClass, tParentClasses, bCallObjectConstructor )
    oClass.__index = oClass

    local tMT = {}
    tMT.__metatable = "This metatable is protected"

    if tParentClasses then
        tMT.__index = function( self, xKey )
            return parentsLookup( xKey, tParentClasses )
        end
    end

    if bCallObjectConstructor then
        tMT.__call = function( self, ... )
            return self.new( ... )
        end
    end

    setmetatable( oClass, tMT )
end