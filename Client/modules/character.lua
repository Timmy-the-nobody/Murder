--[[ Interact ]]--
Input.Bind( "Interact", InputEvent.Pressed, function()
    local eChar = LocalCharacter()
    if not eChar or ( eChar:GetHealth() <= 0 ) or not eChar:IsMurderer() then
        return
    end

    -- Attempt to disguise
    if ( eChar:GetCollectedLoot() < GM.Cfg.DisguiseLootRequired ) then
        LocalPlayer():Notify( NotificationType.Error, "Not enough loot to disguise" )
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

    if ( tTrace.Entity:GetHealth() > 0 ) then
        LocalPlayer():Notify( NotificationType.Error, "You can't disguise while this character is alive" )
        return
    end

    NW.Send( "GM:Character:RequestDisguise", tTrace.Entity )
end )

--[[ Character Death ]]--
Client.SetHighlightColor( Color( 10, 2.5, 0 ), 1, HighlightMode.Always )

Character.Subscribe( "Death", function( eChar )
    if not LocalCharacter() or ( eChar ~= LocalCharacter() ) then
        return
    end

    for _, v in ipairs( Character.GetAll() ) do
        v:SetHighlightEnabled( true, 1 )
    end
end )