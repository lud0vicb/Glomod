-- une fonction pour créer un /play qui joue un son, utile pour tester des sons en jeu
function playSnd (msg)
    sndId = tonumber(msg)
    PlaySound(sndId)
end
SLASH_PL1 = '/pl'
SLASH_PL2 = '/play'
SlashCmdList["PL"] = playSnd
-- fonction /zoom pour changer les zooms dans le chat
function switchZoomFunc(args)
    local cmd = string.sub(args, 1, 1)
    if cmd == "0" then
        isZoomOn = false
        if isDebuging then
            local z = string.format("0 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
            debugFrame.zoomText:SetText(z)
        end
        optionsFrame.zoomButton:SetChecked(false)
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

        optionsFrame.zoomButton:SetChecked(true)
        moveCam(intFeetZoom)
        if isDebuging then
            local z = string.format("1 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
            debugFrame.zoomText:SetText(z)
        end
    end
end
SLASH_ZOOM1 = '/zoom'
SLASH_ZOOM2 = '/z'
SlashCmdList["ZOOM"] = switchZoomFunc
-- fonction pour afficher les zooms
function printZoom(msg)
    print(string.format("GLOZOOM %s %d %d %d", tostring(isZoomOn), intFeetZoom, intCombatZoom, intMountZoom))
end
SLASH_PZOOM1 = '/pzoom'
SLASH_PZOOM2 = '/pz'
SlashCmdList["PZOOM"] = printZoom
-- affichage ou masquage de la fentre de /debug
function showDebug()
    if debugFrame:IsVisible() then
        debugFrame:Hide()
    else
        debugFrame:Show()
    end
end
SLASH_DEBUG1 = '/debug'
SlashCmdList["DEBUG"] = showDebug
-- fonction de changement de pitch au chat /pi
function changePitch(args)
    local tableArgs = {}
    local j = 0
    for i in string.gmatch(args, "%w+") do
        tableArgs[j] = i
        j = j +1
    end
    local k = tonumber(tableArgs[0])
    if k == 0 then
        stopPitch()
    else
        setPitch(k)
    end
end
SLASH_PI1 = "/pi"
SlashCmdList["PI"] = changePitch
