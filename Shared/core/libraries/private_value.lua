NW.AddNWString( "_GM:PrivateValue:Player" )
NW.AddNWString( "_GM:PrivateValue:Character" )

if Server then
    --[[
    Player:SetPrivateValue
        desc: Sets a private value that will be networked to the concerned player only
        args:
            sKey: The key to set the value to (string)
            xValue: The value to set (any)
    ]]--
    function Player:SetPrivateValue( sKey, xValue )
        self:SetValue( sKey, xValue, false )
        NW.Send( "_GM:PrivateValue:Player", self, sKey, xValue )
    end

    --[[
        Character:SetPrivateValue
            args: Key (string), Value (any)
            desc: Sets a private value that will be networked only to the player controlling this character
    ]]--
    function Character:SetPrivateValue( sKey, xValue )
        self:SetValue( sKey, xValue, false )

        local pPlayer = self:GetPlayer()
        if pPlayer and pPlayer:IsValid() then
            NW.Send( "_GM:PrivateValue:Character", pPlayer, sKey, xValue )
        end
    end
end

if Client then
    --[[ _GM:PrivateValue:Player ]]--
    NW.Receive( "_GM:PrivateValue:Player", function( sKey, xValue )
        LocalPlayer():SetValue( sKey, xValue )
    end )

    --[[ _GM:PrivateValue:Character ]]--
    NW.Receive( "_GM:PrivateValue:Character", function( sKey, xValue )
        local eChar = LocalCharacter()
        if eChar and eChar:IsValid() then
            eChar:SetValue( sKey, xValue )
        end
    end )
end