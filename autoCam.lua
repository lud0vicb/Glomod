function Moved()
    if isInCombat then
        return
    end
    -- druide et shaman
    if iclass == 11 or iclass == 7 then
        if iforme == 0 then
            -- le druide/shaman est en humanoide ; il peut en se cas être sur une monture !
            CheckMount()
        end
    else
        CheckMount()
    end
    if isFishing then
        isFishing = false
        MoveViewLeftStart(0.05)
        C_Timer.After(2, function() MoveViewLeftStop() end)
    end
end

function combatCamIn()
    if IsMounted() or isZoomOn == false then
        return
    end
    if iclass == 11 or iclass == 7 then -- druid shaman
        if iforme ~= tableForm[iclass] then
            MoveCam(intCombatZoom)
        end
    else
        MoveCam(intCombatZoom)
    end
end

function combatCamOut()
    if IsMounted() or isZoomOn == false then
        return
    end
    if (iclass == 11 and iforme == 3) or (iclass == 7 and iforme == 1) then
        return
    end
    isFirstMountMove = false
    C_Timer.After(3, function() isFirstFeetMove = true end)
end

function CheckMount()
    if IsMounted() then
        if isFirstMountMove then
            MoveCam(intMountZoom)
            isFirstMountMove = false
            isFirstFeetMove = true
        end
    else
        if isFirstFeetMove then
            MoveCam(intFeetZoom)
            isFirstFeetMove = false
            isFirstMountMove = true
        end
    end
end

function MoveCam(ref)
    if isZoomOn == false or ref == 0 then
        return
    end
    local z = GetCameraZoom()
    local y
    if ref > z then
        y = ref -z
        CameraZoomOut(y)
        local msg = string.format("OUT de %d depuis %d pour atteindre %d", y, z, ref)
        --SendChatMessage(msg, "WHISPER", nil, GetUnitName("player"))
        --DebugFrame.zoomText:SetText(msg)
    else
        y = z - ref
        CameraZoomIn(y)
        local msg = string.format("OUT de %d depuis %d pour atteindre %d", y, z, ref)
        --SendChatMessage(msg, "WHISPER", nil, GetUnitName("player"))
        --DebugFrame.zoomText:SetText(msg)
    end

end
