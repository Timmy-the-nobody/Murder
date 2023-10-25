Package.Require("webui/ui.lua")

Package.Require("modules/round.lua")
Package.Require("modules/player.lua")
Package.Require("modules/character.lua")
Package.Require("modules/loot.lua")
Package.Require("modules/weapon.lua")
Package.Require("modules/footprint.lua")
Package.Require("modules/flashlight.lua")
Package.Require("modules/taunt.lua")

Package.Require("modules/world.lua")
Package.Require("modules/intro.lua")
Package.Require("modules/admin.lua")

-- Map files
for _, sPath in ipairs(Package.GetFiles("Client/maps", ".lua")) do
    Package.Require(sPath)
end

-- Client.SetDebugEnabled( false )

-- Chat Location
local tVPSize = Viewport.GetViewportSize()
Chat.SetConfiguration(
    Vector2D((tVPSize.Y * 0.025), 0),
    Vector2D(600, 250),
    Vector2D(0, 0.9),
    Vector2D(0, 0.9),
    Vector2D(0, 1),
    false,
    true
)
