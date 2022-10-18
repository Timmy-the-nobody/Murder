local mathFloor = math.floor
local worldToScreen = Client.ProjectWorldToScreen

--[[
    LocalPlayer
        desc: Wrapper to quickly call `Client.GetLocalPlayer`
]]--
LocalPlayer = Client.GetLocalPlayer

--[[
    LocalCharacter
        desc: Wrapper function to quickly get LocalPlayer's controlled character
]]--
function LocalCharacter()
    if LocalPlayer() and LocalPlayer():IsValid() then
        return LocalPlayer():GetControlledCharacter()
    end
end

--[[ Client Tick ]]--
local bTargetVisible = false
local iNextTick = 0

Client.Subscribe( "Tick", function( fDelta )
    local iTime = CurTime()
    if ( iTime < iNextTick ) or not GM.WebUI then
        return
    end

    iNextTick = ( iTime + 250 )

    local tTrace
    local xExclude

    local eChar = LocalCharacter()
    if eChar and eChar:IsValid() then
        xExclude = { eChar }

        tTrace = Client.TraceLineSingle(
            eChar:GetLocation(),
            ( eChar:GetControlRotation():GetForwardVector() * 500 ),
            CollisionChannel.Pawn,
            TraceMode.ReturnEntity,
            xExclude
        )
    end

    if not tTrace then
        local pPlayer = LocalPlayer()
        if not pPlayer or not pPlayer:IsValid() then
            return
        end

        tTrace = Client.TraceLineSingle(
            pPlayer:GetCameraLocation(),
            ( LocalPlayer():GetCameraRotation():GetForwardVector() * 500 ),
            CollisionChannel.Pawn,
            TraceMode.ReturnEntity,
            xExclude
        )
    end

    if tTrace.Entity and tTrace.Entity:IsValid() then
        bTargetVisible = true

        local t2DPos = worldToScreen( tTrace.Entity:GetLocation() + Vector( 0, 0, 40 ) )
        GM.WebUI:CallEvent( "ShowTarget", true, tTrace.Entity:GetCodeName(), tTrace.Entity:GetCodeColor( true ), mathFloor( t2DPos.X ), mathFloor( t2DPos.Y ) )
    else
        if bTargetVisible then
            GM.WebUI:CallEvent( "ShowTarget", false )
        end
    end
end )

--[[ Interact ]]--
-- Input.Register( "Spectate", "LeftMouseButton" )
-- Input.Bind( "Spectate", InputEvent.Pressed, function()
--     if not LocalCharacter() then
--         NW.Send( "GM:Player:Spectate" )
--     end
-- end )