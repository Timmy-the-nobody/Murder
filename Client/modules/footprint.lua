local tFootprintSize = Vector(2, 18, 18)
local iFootprintDuration = (GM.Cfg.FootPrintMaxTime * 0.001)

-- addFootprint
local function addFootprint(tPos, tAng, bRight, tColor)
    local tTrace = Trace.LineSingle(
        tPos,
        tPos - Vector(0, 0, 200),
        CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic,
        TraceMode.TraceComplex,
        { LocalCharacter() }
    )

    local eDecal = Decal(
        tTrace.Location,
        Rotator(0, tAng.Yaw + 90, 0),
        "nanos-world::M_NanosDecal",
        tFootprintSize,
        iFootprintDuration,
        0.01
    )

    local sTexturePath = "package://" ..
    Package.GetName() .. "/Client/resources/images/footprint_"..(bRight and "r" or "l")..".png"
    tColor.A = 0.5

    eDecal:SetMaterialTextureParameter("Texture", sTexturePath)
    eDecal:SetMaterialColorParameter("Tint", tColor)
    eDecal:SetMaterialColorParameter("Emissive", (tColor * 5))
end

-- initFootprintTick
local function initFootprintTick()
    local pLocalChar = LocalCharacter()
    if not pLocalChar or not pLocalChar:IsMurderer() then
        return
    end

    local iNextFootprint = 0

    local tickFunc
    tickFunc = Client.Subscribe("Tick", function(fDelta)
        local iTime = CurTime()
        if (iTime < iNextFootprint) then return end

        iNextFootprint = (iTime + 330)

        if not pLocalChar:IsValid() or (GM:GetRound() ~= RoundType.Playing) then
            Client.Unsubscribe("Tick", tickFunc)
            return
        end

        for _, eChar in ipairs(Character.GetAll()) do
            if not eChar:IsValid() or (eChar == pLocalChar) or (eChar:GetHealth() <= 0) then
                goto continue
            end

            if (eChar:GetFallingMode() ~= FallingMode.None) or (eChar:GetGaitMode() == GaitMode.None) then
                goto continue
            end

            local tAng = eChar:GetRotation()
            local bRight = eChar:GetValue("last_footstep_right", false)
            eChar:SetValue("last_footstep_right", not bRight)

            addFootprint(
                eChar:GetLocation() + (tAng:GetRightVector() * (bRight and 10 or -10)),
                tAng + Rotator(0, 0, 0),
                bRight,
                eChar:GetCodeColor()
            )

            ::continue::
        end
    end)
end

-- Events: "GM:OnRoundChange"
Events.Subscribe("GM:OnRoundChange", function(_, iNew)
    if (iNew == RoundType.Playing) then
        initFootprintTick()
        return
    end

    for _, eDecal in ipairs(Decal.GetAll()) do
        if eDecal and eDecal:IsValid() then
            eDecal:Destroy()
        end
    end
end)