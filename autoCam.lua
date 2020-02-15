function moved()
    if isInCombat then
        return
    end
    if isFishing then
        isFishing = false
        MoveViewLeftStart(0.05)
        C_Timer.After(2, function() MoveViewLeftStop() end)
    end
    if isFadeOn then
        if iclass == 11 or iclass == 7 then -- druide et shaman
            if not iforme ~= tableForm[iclass] then -- le druide/shaman est humanoide ; il peut en se cas être sur une monture !
                checkMount()
            end
        else
            checkMount()
        end
    end
end

function combatCamIn()
    if IsMounted() or isZoomOn == false then
        return
    end
    if iclass == 11 or iclass == 7 then -- druid shaman
        if iforme ~= tableForm[iclass] then
            moveCam(intCombatZoom)
        end
    else
        moveCam(intCombatZoom)
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
    C_Timer.After(secCamAfterCombat, function() isFirstFeetMove = true end)
end

function checkMount()
    if IsMounted() then
        if isFirstMountMove then
            moveCam(intMountZoom)
            isFirstMountMove = false
            isFirstFeetMove = true
        end
    else
        if isFirstFeetMove then
            moveCam(intFeetZoom)
            isFirstFeetMove = false
            isFirstMountMove = true
        end
    end
end

function moveCam(ref)
    if ref == 0 or isCamLock then
        return
    end
    isCamLock = true
    local z = GetCameraZoom()
    local y
    local m
    if ref > z then
        y = ref -z
        CameraZoomOut(y)
        m = "Out"
    else
        y = z - ref
        CameraZoomIn(y)
        m = "In"
    end
    isCamLock = false
    if isDebuging then
        local msg = string.format("%s %d from %d to %d", m, y, z, ref)
        printDebug(msg)
        debugFrame.zoomActual:SetText(tostring("a: " .. ref))
    end
end
