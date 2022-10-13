NW.AddNWString( "GM:Notify" )

if Server then
    function Player:Notify( iNotifType, sText, iTime )
        NW.Send( "GM:Notify", self, iNotifType, sText, iTime )
    end
end

if not Client then
    return
end

--[[ Notif type infos ]]--
local tNotifInfo = {
    [ NotificationType.Generic ] = {
        color = "#2ecc71",
        icon = "bell"
    },
    [ NotificationType.Error ] = {
        color = "#e74c3c",
        icon = "circle-xmark"
    },
    [ NotificationType.Warning ] = {
        color = "#f39c12",
        icon = "triangle-exclamation"
    },
    [ NotificationType.Info ] = {
        color = "#3498db",
        icon = "circle-info"
    }
}

--[[
    Player:Notify
        desc: Sends a notification to a player
        args:
            iNotifType: The type of notification (number)
            sText: The message to send (string)
            iTime: The time to display the notification for (number) [optionnal, default: 5000]
]]--
function Player:Notify( iNotifType, sText, iTime )
    if not GM.WebUI then
        return
    end

    iNotifType = iNotifType or NotificationType.Generic
    if not tNotifInfo[ iNotifType ] then
        iNotifType = NotificationType.Generic
    end

    sText = sText or "???"
    iTime = iTime or 5000

    GM.WebUI:CallEvent( "Notify", sText, iTime, tNotifInfo[ iNotifType ].color, tNotifInfo[ iNotifType ].icon )
end

--[[ GM:Notify ]]--
NW.Receive( "GM:Notify", function( iNotifType, sText, iTime )
    local pPlayer = LocalPlayer()
    if not pPlayer or not pPlayer:IsValid() then
        return
    end

    pPlayer:Notify( iNotifType, sText, iTime )
end )