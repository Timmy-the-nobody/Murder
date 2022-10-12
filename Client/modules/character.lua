--[[ Interact ]]--
Input.Bind( "Interact", InputEvent.Pressed, function()
    local eChar = LocalCharacter()
    if not eChar or ( eChar:GetHealth() <= 0 ) then
        return
    end

    -- Attempt to disguise
    if not eChar:IsMurderer() or ( eChar:GetCollectedLoot() < GM.Cfg.DisguiseLootRequired ) then
        return
    end

    local tTrace = Client.TraceLineSingle(
        eChar:GetLocation(),
        ( LocalPlayer():GetCameraRotation():GetForwardVector() * 10000 ),
        CollisionChannel.Pawn,
        TraceMode.ReturnEntity,
        { eChar }
    )

    if not tTrace.Entity or not tTrace.Entity:IsValid() or not IsCharacter( tTrace.Entity ) then
        return
    end

    if ( tTrace.Entity:GetHealth() <= 0 ) then
        NW.Send( "GM:Character:RequestDisguise", tTrace.Entity )
    end
end )