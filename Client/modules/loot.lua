local CurTime = CurTime
local hsvToColor = Color.FromHSV
local setOutlineColor = Client.SetOutlineColor
local lootHighlightTick = false

-- Character: "Highlight"
Character.Subscribe("Highlight", function(eChar, bIsEnabled, eObject)
    if LocalCharacter() and (LocalCharacter() == eChar) then
        if eObject and eObject:IsValid() and eObject:GetValue("loot_manager_id") then
            eObject:SetOutlineEnabled(true, 0)
        end
    end
end)

NW.Receive("GM:Loot:PickupSound", function(tPos)
    Sound(tPos, "nanos-world::A_Object_PickUp", false, true, SoundType.SFX, 1, 1, 60)
end)

-- Events: "GM:OnRoundChange"
Events.Subscribe("GM:OnRoundChange", function(_, iNew)
    if (iNew ~= RoundType.Playing) then
        if lootHighlightTick then
            Client.Unsubscribe("Tick", lootHighlightTick)
            lootHighlightTick = false
        end

        return
    end

    local iNextTick = 0
    local iNextOutlineColorChange = 0
    local tHighlighted = {}

    lootHighlightTick = Client.Subscribe("Tick", function(_)
        local iTime = CurTime()

        if (iTime > iNextOutlineColorChange) then
            setOutlineColor(hsvToColor(math.floor(iTime * 0.1) % 100, 10, 10), 0, 1)
            iNextOutlineColorChange = (iTime + 80)
        end

        if (iTime < iNextTick) then return end

        iNextTick = (iTime + 250)

        local eChar = LocalCharacter()
        if not eChar or not eChar:IsValid() then
            Client.Unsubscribe("Tick", lootHighlightTick)
            lootHighlightTick = false
            return
        end

        local tPos = eChar:GetLocation()
        for _, eProp in ipairs(Prop.GetAll()) do
            if not eProp:IsValid() or not eProp:GetValue("loot_manager_id") then
                goto continue
            end

            if (eProp:GetLocation():DistanceSquared(tPos) <= GM.Cfg.LootHaloDistance) then
                if tHighlighted[eProp] then
                    goto continue
                end

                eProp:SetOutlineEnabled(true, 0)
                tHighlighted[eProp] = true
            else
                if not tHighlighted[eProp] then
                    goto continue
                end

                eProp:SetOutlineEnabled(false, 0)
                tHighlighted[eProp] = nil
            end

            ::continue::
        end
    end)
end)