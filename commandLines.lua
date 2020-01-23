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
        print ('GLO ZOOM disabled')
    elseif cmd == '1' then
        isZoomOn = true
        local tableArgs = {}
        local j = 0
        for i in string.gmatch(args, "%w+") do
            tableArgs[j] = i
            j = j +1
        end
        intFeetZoom = tonumber(tableArgs[1])
        intMountZoom = tonumber(tableArgs[2])
        intCombatZoom = tonumber(tableArgs[3])
        print (string.format("GLO ZOOM  F%d M%d C%d", tableArgs[1], tableArgs[2], tableArgs[3]))
    end
end
SLASH_ZOOM1 = '/zoom'
SLASH_ZOOM2 = '/z'
SlashCmdList["ZOOM"] = switchZoomFunc

function printZoom(msg)
    print(string.format("GLOZOOM %s %d %d %d", tostring(isZoomOn), intFeetZoom, intMountZoom, intCombatZoom))
end
SLASH_PZOOM1 = '/pzoom'
SLASH_PZOOM2 = '/pz'
SlashCmdList["PZOOM"] = printZoom

function showDebug()
    if isDebuging == true then
        isDebuging = false
        DebugFrame:Hide()
    else
        isDebuging = true
        DebugFrame:Show()
    end
end
SLASH_DEBUG1 = '/debug'
SlashCmdList["DEBUG"] = showDebug
