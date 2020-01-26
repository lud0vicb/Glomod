function playSnd (msg)
    sndId = tonumber(msg)
    PlaySound(sndId)
end
SLASH_PL1 = '/pl'
SLASH_PL2 = '/play'
SlashCmdList["PL"] = playSnd

function switchZoomFunc(args)
    local cmd = string.sub(args, 1, 1)
    if cmd == "0" then
        isZoomOn = false
        debugFrame.zoomText:SetText("OFF")
    elseif cmd == '1' then
        isZoomOn = true
        local tableArgs = {}
        local j = 0
        for i in string.gmatch(args, "%w+") do
            tableArgs[j] = i
            j = j +1
        end
        intFeetZoom = tonumber(tableArgs[1])
        intMountZoom = tonumber(tableArgs[3])
        intCombatZoom = tonumber(tableArgs[2])
        moveCam(intFeetZoom)
        if isDebuging then
            local z = string.format("z = %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
            debugFrame.zoomText:SetText(z)
        end
    end
end
SLASH_ZOOM1 = '/zoom'
SLASH_ZOOM2 = '/z'
SlashCmdList["ZOOM"] = switchZoomFunc

function printZoom(msg)
    print(string.format("GLOZOOM %s %d %d %d", tostring(isZoomOn), intFeetZoom, intCombatZoom, intMountZoom))
end
SLASH_PZOOM1 = '/pzoom'
SLASH_PZOOM2 = '/pz'
SlashCmdList["PZOOM"] = printZoom

function showDebug()
    if debugButton:IsVisible() then
        debugButton:Hide()
    else
        debugButton:Show()
    end
end
SLASH_DEBUG1 = '/debug'
SlashCmdList["DEBUG"] = showDebug

function changePitch(args)
    local tableArgs = {}
    local j = 0
    for i in string.gmatch(args, "%w+") do
        tableArgs[j] = i
        j = j +1
    end
    intPitchZoom = tonumber(tableArgs[0])
    if intPitchZoom == 0 then
        C_CVar.SetCVar("test_cameraDynamicPitch", 0)
        printDebug("PITCH OFF")
        return
    end
    intPitchZoom = intPitchZoom / 10
    local actual = GetCVar("test_cameraDynamicPitchBaseFovPad")
    local isActivated = C_CVar.SetCVar("test_cameraDynamicPitch", 1)
    local isPitched = C_CVar.SetCVar("test_cameraDynamicPitchBaseFovPad", intPitchZoom) --, "scriptCVar"
    local isPitched2 = C_CVar.SetCVar("test_cameraDynamicPitchBaseFovPadFlying", intPitchZoom) --, "scriptCVar"
    if isDebuging then
        log = string.format("PITCH from %.2f to %.2f = %.2f", actual, intPitchZoom, GetCVar("test_cameraDynamicPitchBaseFovPad"))
        debugFrame.dynamicPitchActual:SetText("P : " .. tostring(intPitchZoom))
        printDebug(log)
    end
end
SLASH_PI1 = "/pi"
SlashCmdList["PI"] = changePitch
