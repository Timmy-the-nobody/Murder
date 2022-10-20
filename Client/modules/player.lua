local mathFloor = math.floor
local worldToScreen = Client.ProjectWorldToScreen
local traceLine = Client.TraceLineSingle

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

Client.Subscribe( "Tick", function( fDelta )
    if not GM.WebUI then
        return
    end

    local tTrace
    local xExclude

    local eChar = LocalCharacter()
    if eChar and eChar:IsValid() then
        xExclude = { eChar }

        tTrace = traceLine(
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

        tTrace = traceLine(
            pPlayer:GetCameraLocation(),
            ( pPlayer:GetCameraRotation():GetForwardVector() * 500 ),
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