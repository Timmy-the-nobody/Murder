-- playTaunt
local function playTaunt(eChar, iTaunt)
    if not eChar or not eChar:IsValid() then return end

    if not GM.Taunts[iTaunt] then  return end

    local oTaunt = Sound(
        eChar:GetLocation(),
        GM.Taunts[iTaunt],
        false,
        true,
        SoundType.SFX,
        0.7,
        1,
        80
    )

    oTaunt:AttachTo(eChar, AttachmentRule.SnapToTarget, "", -1, false)
end

NW.Receive("GM:Taunt:Play", playTaunt)

-- Input: "Taunt"
Input.Register("Taunt", "B")
Input.Bind("Taunt", InputEvent.Pressed, function()
    if not LocalCharacter() or (LocalCharacter():GetHealth() <= 0) then return end
    NW.Send("GM:Taunt:Request")
end)