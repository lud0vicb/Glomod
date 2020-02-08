function moved()
    if isInCombat then
        return
    end
    if isFishing then
        isFishing = false
        MoveViewLeftStart(0.05)
        C_Timer.After(2, function() MoveViewLeftStop() end)
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
