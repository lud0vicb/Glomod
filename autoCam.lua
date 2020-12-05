function moved()
    if isInCombat then
        return
    end
    if isFishing then
        isFishing = false
        MoveViewLeftStart(0.05)
        C_Timer.After(2, function() MoveViewLeftStop() end)
    end
    if isZoomOn then
        if iclass == 11 or iclass == 7 then -- druide et shaman
            if not iforme ~= tableForm[iclass] then -- le druide/shaman est humanoide ; il peut en se cas être sur une monture !
                C_Timer.After(2, function() checkMount() end)
            end
        else
            C_Timer.After(2, function() checkMount() end)
        end
    end
end
-- déplacement de la caméra en zoom in selon le contexte et le point de départ
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
-- déplcament de la caméra en zoom out selon le contexte et le point de départ
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
-- vérification d'une monture
-- pour éviter les allers retours jeu avec des flags isFirstXXXXMove
function checkMount()
    if isInCombat == true then
      return
    end
    if IsMounted() then
        if isFirstMountMove then
            intCamZoomBackup = GetCameraZoom()
            moveCam(intMountZoom)
            isFirstMountMove = false
            isFirstFeetMove = true
        end
    else
        if isFirstFeetMove then
            moveCam(intCamZoomBackup)
            isFirstFeetMove = false
            isFirstMountMove = true
        end
    end
end
-- déplacelement de la caméra, prise en compte de la distance actuelle pour trouver la distance arrivée
function moveCam(ref)
    if not isZoomOn or ref == 0 or isCamLock then
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
