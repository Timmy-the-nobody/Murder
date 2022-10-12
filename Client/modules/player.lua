local mathFloor = math.floor
local worldToScreen = Client.ProjectWorldToScreen

--[[
    LocalPlayer
        desc: Wrapper _ENV var to quickly call `Client.GetLocalPlayer`
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

local bTargetVisible = false

Client.Subscribe( "Tick", function( fDelta )
    local eChar = LocalCharacter()
    if not eChar or not GM.WebUI then
        return
    end

    local tTrace = Client.TraceLineSingle(
        eChar:GetLocation(),
        ( LocalPlayer():GetCameraRotation():GetForwardVector() * 10000 ),
        CollisionChannel.Pawn,
        TraceMode.ReturnEntity,
        { eChar }
    )

    if tTrace.Entity and tTrace.Entity:IsValid() then
        local t2DPos = worldToScreen( tTrace.Entity:GetLocation() + Vector( 0, 0, 50 ) )
        GM.WebUI:CallEvent( "ShowTarget", true, tTrace.Entity:GetCodeName(), tTrace.Entity:GetCodeColor( true ), mathFloor( t2DPos.X ), mathFloor( t2DPos.Y ) )
        bTargetVisible = true
    else
        if bTargetVisible then
            GM.WebUI:CallEvent( "ShowTarget", false )
        end
    end
end )